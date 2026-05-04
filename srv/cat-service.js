const cds = require('@sap/cds');
module.exports = class enterpriseService extends cds.ApplicationService {
    init() {
        const { Assets, assignment, maintenance, employee } = this.entities;

        // ── BEFORE CREATE/UPDATE assignment ────────────────────────────────
        this.before(['CREATE', 'UPDATE'], assignment, async (req) => {
            const { asset_ID, employee_ID } = req.data;

            if (!req.data.status_code) {
                req.data.status_code = '0';
            }

            if (!asset_ID)
                return req.error(400, 'Asset is required. Please select an asset.');

            const asset = await SELECT.one.from(Assets).where({ ID: asset_ID });
            if (!asset)
                return req.error(400, 'Asset not found');
            if (asset.status !== 'Active')
                return req.error(400, `Asset is not available (status: ${asset.status})`);

            const existing = await SELECT.one.from(assignment).where({ asset_ID });
            if (existing && existing.ID !== req.data.ID)
                return req.error(400, 'Asset is already assigned to another employee');

            req.data.assetName = asset.name;
            req.data.assetType = asset.type;

            if (employee_ID) {
                const emp = await SELECT.one.from(employee).where({ ID: employee_ID });
                if (!emp || emp.role !== 'Employee')
                    return req.error(400, 'Only employees (not managers) can be assigned an asset');
                req.data.employeeName = emp.name;
            }
        });

        // ── AFTER CREATE assignment → mark asset as Assigned ───────────────
        this.after('CREATE', assignment, async (data) => {
            if (data.asset_ID) {
                await UPDATE(Assets)
                    .set({ status: 'Assigned' })
                    .where({ ID: data.asset_ID });
            }
        });

        // ── AFTER CREATE maintenance → mark asset as UnderMaintenance ──────
        this.after('CREATE', maintenance, async (data) => {
            if (data.asset_ID) {
                await UPDATE(Assets)
                    .set({ status: 'UnderMaintenance' })
                    .where({ ID: data.asset_ID });
            }
        });

        // ── BEFORE UPDATE maintenance → react to status changes ────────────
        this.before('UPDATE', maintenance, async (req) => {
            const { status_code } = req.data;
            if (!status_code) return;

            const record = await SELECT.one.from(maintenance).where({ ID: req.data.ID });
            if (!record) return;

            if (status_code === 'Completed') {
                await UPDATE(Assets)
                    .set({ status: 'Active' })
                    .where({ ID: record.asset_ID });
            }
            if (status_code === 'Rejected') {
                await UPDATE(Assets)
                    .set({ status: 'Retired' })
                    .where({ ID: record.asset_ID });
            }
        });

        // ── helper: get ID and correct table based on draft status ──────────
        const getRecordAndTable = async (req, entity) => {
            const ID = req.params[req.params.length - 1]?.ID;
            if (!ID) return {};

            // ✅ Check IsActiveEntity from query params to know draft vs active
            const isActive = req.query?.SELECT?.where?.find?.(
                w => w?.ref?.[0] === 'IsActiveEntity'
            )?.val !== false;

            // Try active table first, then draft table
            let record = await SELECT.one.from(entity).where({ ID });
            let table = entity;

            if (!record) {
                // ✅ fallback to draft table (composition child draft)
                record = await SELECT.one.from(entity.drafts).where({ ID });
                table = entity.drafts;
            }

            return { ID, record, table };
        };

        // ── ACTION: acceptMaintenance ───────────────────────────────────────
        this.on('acceptMaintenance', async (req) => {
            const { ID, record, table } = await getRecordAndTable(req, maintenance);
            if (!ID) return req.error(400, 'Missing ID');
            if (!record) return req.error(404, 'Maintenance record not found');

            if (record.status_code === 'Completed')
                return req.error(400, 'Already completed');

            await UPDATE(table).set({ status_code: 'Completed' }).where({ ID });

            // ✅ Only update asset status if record has asset_ID
            if (record.asset_ID) {
                await UPDATE(Assets).set({ status: 'Active' }).where({ ID: record.asset_ID });
            }
            req.info('Maintenance accepted — asset marked Active');
            return SELECT.one.from(table).where({ ID });
        });
        // ── ACTION: rejectMaintenance ───────────────────────────────────────
        this.on('rejectMaintenance', async (req) => {
            const { ID, record, table } = await getRecordAndTable(req, maintenance);
            if (!ID) return req.error(400, 'Missing ID');
            if (!record) return req.error(404, 'Maintenance record not found');

            if (record.status_code === 'Rejected')
                return req.error(400, 'Already rejected');

            await UPDATE(table).set({ status_code: 'Rejected' }).where({ ID });

            if (record.asset_ID) {
                await UPDATE(Assets).set({ status: 'Retired' }).where({ ID: record.asset_ID });
            }

            req.info('Maintenance rejected — asset marked Retired');
            return SELECT.one.from(table).where({ ID });
        });

        // ── ACTION: openMaintenance ─────────────────────────────────────────
        this.on('openMaintenance', async (req) => {
            const { ID, record, table } = await getRecordAndTable(req, maintenance);
            if (!ID) return req.error(400, 'Missing ID');
            if (!record) return req.error(404, 'Maintenance record not found');

            await UPDATE(table).set({ status_code: 'Open' }).where({ ID });

            req.info('Maintenance re-opened');
            return SELECT.one.from(table).where({ ID });
        });

        // ── ACTION: closeAssignment ─────────────────────────────────────────
        this.on('closeAssignment', assignment, async (req) => {
            const { ID } = req.params[0];
            const rec = await SELECT.one.from(assignment).where({ ID });
            if (!rec) return req.error(404, 'Assignment not found');

            await UPDATE(Assets).set({ status: 'Active' }).where({ ID: rec.asset_ID });

            req.info('Assignment closed — asset returned to Active');
            return SELECT.one.from(assignment).where({ ID });
        });

        return super.init();
    }
};
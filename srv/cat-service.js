const cds = require('@sap/cds');
const { message } = require('@sap/cds/lib/log/cds-error');
const { SELECT, UPDATE, INSERT } = require('@sap/cds/lib/ql/cds-ql');

module.exports = class enterpriseService extends cds.ApplicationService {

    init() {
        const { Assets, employee, assignment, maintenance, AssetRequests } = this.entities;

        this.before(['CREATE', 'UPDATE'], assignment, async (req) => {
            const { asset_ID } = req.data;
            console.log(asset_ID, "thils asset_ID");

            // check the stock available or not 
            const asset = await SELECT.one.from(Assets).where({ ID: asset_ID });
            console.log(asset, "this is asset");

            if (!asset) {
                req.error(400, "Asset not found")
            }
            // this will active  status  
            if (asset.status !== 'Active') {
                req.error(400, 'Asset is not available ');
            }

            // check wheather the asset is already assigned to other employee check with this code 
            const existing = await SELECT.one.from(assignment)
                .where({ asset_ID: asset_ID });
            console.log(existing, "this is exiting");

            if (existing) {
                req.error(400, 'Asset is already assigned to another employee');
            }

            const { employee_ID } = req.data
            console.log(employee_ID);

            if (!employee_ID) {
                req.error(400, 'employee ID is required')
            }
            const employeeAssign = await SELECT.one.from(employee).where({ ID: employee_ID })

            if (!employeeAssign || employeeAssign.role !== "Employee") {
                req.error(400, 'only Employee is only will assign the asset')
            }
        })
        this.after('CREATE', maintenance, async (data) => {
            await UPDATE(Assets)
                .set({ status: 'Maintenance' })
                .where({ ID: data.asset_ID });
        });
        this.before('UPDATE', maintenance, async (req) => {
            console.log("Incoming data:", req.data);

            const { status } = req.data

            if (!status) return;

            console.log("status", status);
            const record = await SELECT.one.from(maintenance)
                .where({ ID: req.data.ID });

            console.log(record);
            if (!record) return;

            const assetID = record.asset_ID

            if (status === 'Completed') {
                await UPDATE(Assets)
                    .set({ status: 'Active' })
                    .where({ ID: assetID });
            }

            if (status === 'Failed') {
                await UPDATE(Assets)
                    .set({ status: 'Retired' })
                    .where({ ID: assetID });
            }
        })
        this.before('CREATE', Assets, async (req) => {

            const { status } = req.data;

            if (status === 'maintenance') {
                req.error(400, "asset under maintenance")
            }
            if (status === 'retired') {
                req.error(400, "asset is retired")
            }
        })
        this.before('CREATE', Assets, (req) => {
            if (!req.data.status) {
                req.data.status = 'Active'
            }
        })
        this.on('approved', AssetRequests, async (req) => {

            const approvedBy_ID = "550e8400-e29b-41d4-a716-446655440013";
            const { ID } = req.params[0];

            // 1. Validate approver
            if (!approvedBy_ID) {
                return req.error(400, 'Approver ID is required');
            }

            const approver = await SELECT.one.from(employee)
                .where({ ID: approvedBy_ID });

            if (!approver || approver.role !== 'Manager') {
                return req.error(400, 'Only Manager can approve this request');
            }

            // 2. Update
            await UPDATE(AssetRequests)
                .set({
                    status: 'Approved',
                    approvedBy_ID: approvedBy_ID
                })
                .where({ ID });

            // 3. JOIN (association expand)
            const result = await SELECT.one
                .from(AssetRequests)
                .where({ ID });

            // 4. Return joined data
       req.info("Approved successfully") 
        })
        this.on('requested', AssetRequests, async (req) => {

            const { ID } = req.params[0];
            const userId = req.user.id;

            const request = await SELECT.one
                .from(AssetRequests)
                .where({ ID });

            if (!request) {
                return req.error(404, 'Request not found');
            }

            await UPDATE(AssetRequests)
                .set({
                    status: 'pending',
                    requestedBy_ID: userId
                })
                .where({ ID });
            const updated = await SELECT.one
                .from(AssetRequests)
                .where({ ID });
                 req.info("Requested successfully")

            return updated;
           
        });

        this.on('createreq', 'AssetRequests.drafts', async (req) => {

            const { assetName, type, status } = req.data;

            await INSERT.into(AssetRequests).entries({
                ID: cds.utils.uuid(),
                assetName,
                type,
                status
            })
        })
        super.init()
    }
}

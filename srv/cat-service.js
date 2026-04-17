const cds = require('@sap/cds');

module.exports = class enterpriseService extends cds.ApplicationService {

    init() {

        const { Assets, employee, assignment, maintenance, AssetRequests } = this.entities;

        this.before('CREATE', assignment, async (req) => {
            const { asset_ID } = req.data;
            console.log(asset_ID, "this asset_ID");

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



        this.before('UPDATE', AssetRequests, async (req) => {

            const { approvedBy_ID, status } = req.data;

            if (status === 'Approved') {

                const approver = await SELECT.one.from(employee)
                    .where({ ID: approvedBy_ID });

                if (!approver || approver.role !== 'Manager') {
                    req.error(400, 'Only manager can approve this')
                }

            }

            if (!req.data.status) {
                req.data.status = "pending"
            }
        })


        this.before('CREATE', AssetRequests, async (req) => {
            if (!req.data.status) {
                req.data.status = "pending"
            }
        })

        
        super.init()
    }
}
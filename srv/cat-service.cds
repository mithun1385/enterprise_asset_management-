using { eam as db } from '../db/schema';

@path: '/odata/v4/enterprise'
service enterpriseService {

    @readonly entity Assets   as projection on db.Assets;
    @readonly entity employee as projection on db.employee;
    @readonly entity statusVH as projection on db.Status;  // ✅ exposed for value help

    entity assignment as projection on db.assignment {
        *,
        asset.location as assetLocation : String,
        asset.status   as assetStatus   : String,
        employee.email as employeeEmail : String,
        employee.role  as employeeRole  : String,
        maintenances
    } actions {
        action closeAssignment() returns assignment;
    };

    entity maintenance as projection on db.maintenance {
        *,
        // ── navigable association (keeps status_code writable) ──────────
        status,                                             // ✅ exposes status_code + association

        // ── flattened read fields for UI display ────────────────────────
        asset.name         as assetName        : String,
        employee.name      as technicianName   : String,
        status.description as statusDescription: String,   // ✅ for UI.DataFieldWithCriticality Value
        status.criticality as criticality      : Integer   // ✅ for Criticality property
    } actions {
        @Common.IsActionCritical: false
        action acceptMaintenance() returns maintenance;

        @Common.IsActionCritical: true
        action rejectMaintenance() returns maintenance;

        action openMaintenance()   returns maintenance;
    };
}

// ✅ Only assignment gets draft — maintenance inherits automatically
annotate enterpriseService.assignment with @odata.draft.enabled;
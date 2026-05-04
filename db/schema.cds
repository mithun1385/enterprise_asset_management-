    namespace eam;
    using { cuid, managed } from '@sap/cds/common';

    entity assignment : cuid, managed {
        asset        : Association to Assets;
        employee     : Association to employee;
        assignedOn   : Date;
        notes        : String;
        location     : String;
        assetName    : String;
        employeeName : String;
        assetType    : String;
        maintenances : Composition of many maintenance on maintenances.assignment = $self;
    }

    entity maintenance : cuid, managed {
        assignment   : Association to assignment;
        asset        : Association to Assets;
        employee     : Association to employee;
        status       : Association to Status;
        issue        : String;
        cost         : Decimal(10,2);
        resolvedOn   : Date;
        notes        : String;
        location     : String;
    }

    entity Assets : cuid {
        name         : String;
        type         : String;
        serialNumber : String;
        purchaseDate : Date;
        value        : Decimal(10,2);
        location     : String;
        status       : String;
    }

    entity employee : cuid {
        name  : String;
        email : String;
        role  : String;
    }

    entity Status {
        key code        : String;
            description : String;
            criticality : Integer;
    }


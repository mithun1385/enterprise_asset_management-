namespace eam;

using { cuid } from '@sap/cds/common';

entity employee : cuid {
    name  : String;
    email : String;
    role  : String enum {
        Employee;
        Manager;
    };
}
entity AssetRequests : cuid {
    assetName   : String;
    type        : String;
    requestedBy : Association to employee;
    approvedBy  : Association to employee;
    status      : String enum {
        Pending;
        Approved;
        Rejected;
    };
}

entity Assets : cuid {
    name         : String;
    type         : String;
    serialNumber : String;
    purchaseDate : Date;
    value        : Decimal(10, 2);
    status       : String enum {
        Available;
        Assigned;
        UnderMaintenance;
        Retired;
    };
    location     : String;
}
entity assignment : cuid {
    asset      : Association to Assets;
    employee   : Association to employee;
    assignedOn : Date;
}
entity maintenance : cuid {
    asset : Association to Assets;
    employee   : Association to employee;
    issue  : String;
    status : Association to Status;
    cost   : Decimal(10, 2);
    assignment:Association to assignment;
}
entity Status {
    key code :String;
    description:String;
}

namespace eam;

using {cuid} from '@sap/cds/common';

entity AssetRequests : cuid {
    assetName   : String;
    type        : String;
    requestedBy : Association to employee;
    approvedBy  : Association to employee;
    status      : String;
}

entity Assets : cuid {
    name         : String;
    type         : String;
    serialNumber : String;
    purchaseDate : Date;
    value        : Decimal(10, 2);
    status       : String;
    location     : String;
}

entity employee : cuid {
    name  : String;
    email : String;
    role  : String enum {
        Employee;
        Manager;
        
    }
}

entity assignment : cuid {

    asset      : Association to Assets;
    employees  : Association to employee;
    assignedOn : Date;
}

entity maintenance : cuid {

    asset  : Association to Assets;
    issue  : String;
    status : String enum {
        open;
        inProgress;
        Completed;
    }
    cost   : Decimal(10, 2);
}



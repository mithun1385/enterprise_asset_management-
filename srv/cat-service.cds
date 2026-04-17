using {eam as db} from '../db/schema';

service enterpriseService {
     entity Assets        as projection on db.Assets;
     entity AssetRequests as projection on db.AssetRequests;
     entity employee      as projection on db.employee;
     entity assignment    as projection on db.assignment;
     entity maintenance   as projection on db.maintenance;
}

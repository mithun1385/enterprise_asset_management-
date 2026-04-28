using {eam as db} from '../db/schema';

service enterpriseService {
     type approveInput : {
          assetName   : String;
          type        : String;

          @Core.Immutable
          requestedBy : UUID;
          status      : String enum {
               pending  @title: 'Pending';
               approved @title: 'Approved';
               rejected @title: 'Rejected';
          };
     }

     entity Assets as projection on db.Assets;

     entity AssetRequests as projection on db.AssetRequests actions{
          action requested();
          action approved();
     action createreq(assetName:String,
       type:String,
       status:String) returns AssetRequests;
        
     }

    
     entity employee      as projection on db.employee;
     entity assignment    as projection on db.assignment;
     entity maintenance   as projection on db.maintenance;

     entity statusVH as projection on db.Status;
}
annotate enterpriseService.AssetRequests with @odata.draft.enabled;
annotate enterpriseService.maintenance with @odata.draft.enabled;
annotate enterpriseService.assignment with @odata.draft.enabled;





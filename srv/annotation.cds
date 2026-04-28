using enterpriseService as service from './cat-service';

annotate service.AssetRequests with {
  requestedBy @Common.ValueList: {
    $Type: 'Common.ValueListType',
    CollectionPath: 'employee',
    Parameters: [
      {
        $Type: 'Common.ValueListParameterInOut',
        LocalDataProperty: requestedBy,
        ValueListProperty: 'ID'
      },
      {
        $Type: 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'name'
      }
    ]
  };
};
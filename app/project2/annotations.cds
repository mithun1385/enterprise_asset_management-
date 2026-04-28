using enterpriseService as service from '../../srv/cat-service';

annotate service.maintenance with @(
    UI.FieldGroup #GeneratedGroup           : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'issue',
                Value: issue,
            },
            {
                $Type: 'UI.DataField',
                Label: 'cost',
                Value: cost,
            },
            {
                $Type : 'UI.DataField',
                Value : status_code,
                Label : 'status_code',
            },
        ],
    },
    UI.Facets                               : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem                             : [
        {
            $Type: 'UI.DataField',
            Label: 'issue',
            Value: issue,
        },
        {
            $Type: 'UI.DataField',
            Label: 'status',
            Value: status_code,
        },
        {
            $Type: 'UI.DataField',
            Label: 'cost',
            Value: cost,
        },
    ],
    UI.FieldGroup #assignmentAssettoemployee: {
        $Type: 'UI.FieldGroupType',
        Data : [
            
        ],
    },
    UI.SelectionFields : [
        asset.ID,
    ],
);

annotate service.maintenance with {
    asset @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Assets',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: asset_ID,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'type',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'serialNumber',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'purchaseDate',
            },
        ],
    }
};

annotate service.maintenance with {
    status @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'statusVH',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: status_code,
                ValueListProperty: 'code',
            }, ],
            Label         : 'statusVH',
        },
        Common.ValueListWithFixedValues: true,
        Common.Text : status.code,
    )
};annotate enterpriseService.assignment with {

    asset @(
        Common.ValueList: {
            $Type: 'Common.ValueListType',
            CollectionPath: 'Assets',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: asset_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                }
            ]
        },
        Common.Text: asset.name   // 🔥 IMPORTANT
    );

    employee @(
        Common.ValueList: {
            $Type: 'Common.ValueListType',
            CollectionPath: 'employee',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: employee_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                }
            ]
        },
        Common.Text: employee.name   // 🔥 IMPORTANT
    );

};
annotate service.Assets with {
    status @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'maintenance',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : status,
                    ValueListProperty : 'status_code',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
)};

annotate service.statusVH with {
    code @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'statusVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : code,
                    ValueListProperty : 'code',
                },
            ],
            Label : 'status',
        },
        Common.ValueListWithFixedValues : true,
)};

annotate service.Assets with {
    name @Common.Label : 'asset/name'
};

annotate service.Assets with {
    ID @Common.Label : 'asset/ID'
};


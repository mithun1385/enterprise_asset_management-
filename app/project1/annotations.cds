using enterpriseService as service from '../../srv/cat-service';
annotate service.AssetRequests with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'assetName',
                Value : assetName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'type',
                Value : type,
            },
            {
                $Type : 'UI.DataField',
                Label : 'status',
                Value : status,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>AsignmentInformation}',
            ID : 'i18nAsignmentInformation',
            Target : '@UI.FieldGroup#i18nAsignmentInformation',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'assetName',
            Value : assetName,
        },
        {
            $Type : 'UI.DataField',
            Label : 'type',
            Value : type,
        },
        {
            $Type : 'UI.DataField',
            Label : 'status',
            Value : status,
        },
         {
            $Type : 'UI.DataFieldForAction',
            Action : 'enterpriseService.approved',  // 👈 IMPORTANT
            Label : 'Approve'
        },
        {
            $Type:'UI.DataFieldForAction',
            Action:'enterpriseService.requested',
            Label:'Request'
        },
        {
            $Type:'UI.DataFieldForAction',
            Action:'enterpriseService.createreq',
            Label:'employeeRequest'
        }
    ],
    UI.FieldGroup #i18nAsignmentInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : approvedBy_ID,
                Label : 'approvedBy_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : assetName,
                Label : 'assetName',
            },
            {
                $Type : 'UI.DataField',
                Value : ID,
                Label : 'ID',
            },
            {
                $Type : 'UI.DataField',
                Value : requestedBy_ID,
                Label : 'requestedBy_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : requestedBy.name,
                Label : 'name',
            },
        ],
    },
);

annotate service.AssetRequests with {
    approvedBy @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'employee',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : approvedBy_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'role',
            },
        ],
    }
};

annotate service.AssetRequests with {
    assetName @(
        Common.Text : type,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'AssetRequests',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : assetName,
                    ValueListProperty : 'assetName',
                },
            ],
            Label : 'assetName',
        },
        Common.ValueListWithFixedValues : true,
)};

annotate service.AssetRequests with {
    requestedBy @Common.Text : requestedBy.name
};


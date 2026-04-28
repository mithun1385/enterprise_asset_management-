using enterpriseService as service from '../../srv/cat-service';
annotate service.assignment with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : asset_ID,
                Label : 'asset_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : employee_ID,
                Label : 'employee_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : assignedOn,
                Label : 'assignedOn',
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
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : asset_ID,
            Label : 'asset_ID',
        },
        {
            $Type : 'UI.DataField',
            Value : employee_ID,
            Label : 'employee_ID',
        },
        {
            $Type : 'UI.DataField',
            Value : assignedOn,
            Label : 'assignedOn',
        },
    ],
);


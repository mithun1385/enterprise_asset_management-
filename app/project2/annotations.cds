using enterpriseService as service from '../../srv/cat-service';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  ASSIGNMENT ANNOTATIONS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

annotate service.assignment with @(

    UI.HeaderInfo: {
        TypeName       : 'Asset Assignment',
        TypeNamePlural : 'Asset Assignments',
        Title          : {
            $Type: 'UI.DataField',
            Value: assetName
        },
        Description    : {
            $Type: 'UI.DataField',
            Value: employeeName
        }
    },

    UI.SelectionFields: [
        assetName,
        employeeName,
        assetStatus,
        assignedOn
    ],

    UI.LineItem: [
        { $Type: 'UI.DataField', Label: 'Asset',        Value: assetName     },
        { $Type: 'UI.DataField', Label: 'Asset Type',   Value: assetType     },
        { $Type: 'UI.DataField', Label: 'Location',     Value: assetLocation },
        { $Type: 'UI.DataField', Label: 'Assigned To',  Value: employeeName  },
        { $Type: 'UI.DataField', Label: 'Role',         Value: employeeRole  },
        { $Type: 'UI.DataField', Label: 'Assigned On',  Value: assignedOn    },
        { $Type: 'UI.DataField', Label: 'Asset Status', Value: assetStatus   },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Close Assignment',
            Action : 'enterpriseService.closeAssignment',
            Inline : false
        }
    ],

    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Assignment Details',
            Target: '@UI.FieldGroup#AssignmentHeader'
        }
    ],

    UI.FieldGroup #AssignmentHeader: {
        $Type: 'UI.FieldGroupType',
        Data : [
            { $Type: 'UI.DataField', Label: 'Asset',        Value: assetName     },
            { $Type: 'UI.DataField', Label: 'Asset Type',   Value: assetType     },
            { $Type: 'UI.DataField', Label: 'Location',     Value: assetLocation },
            { $Type: 'UI.DataField', Label: 'Assigned To',  Value: employeeName  },
            { $Type: 'UI.DataField', Label: 'Email',        Value: employeeEmail },
            { $Type: 'UI.DataField', Label: 'Assigned On',  Value: assignedOn    },
            { $Type: 'UI.DataField', Label: 'Asset Status', Value: assetStatus   },
            { $Type: 'UI.DataField', Label: 'Notes',        Value: notes         }
        ]
    },

    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'AssignmentInfoSection',
            Label : 'Assignment Info',
            Target: '@UI.FieldGroup#AssignmentInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'MaintenanceSection',
            Label : 'Maintenance Issues',
            Target: 'maintenances/@UI.LineItem'
        }
    ],

    UI.FieldGroup #AssignmentInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            { $Type: 'UI.DataField', Label: 'Asset',        Value: assetName     },
            { $Type: 'UI.DataField', Label: 'Asset Type',   Value: assetType     },
            { $Type: 'UI.DataField', Label: 'Assigned To',  Value: employeeName  },
            { $Type: 'UI.DataField', Label: 'Assigned On',  Value: assignedOn    },
            { $Type: 'UI.DataField', Label: 'Notes',        Value: notes         },
            { $Type: 'UI.DataField', Label: 'Location',     Value: assetLocation }
        ]
    }
);

// ── Field labels and value helps for assignment ────────────────────────────
annotate service.assignment with {
    assetName     @Common.Label: 'Asset';
    employeeName  @Common.Label: 'Assigned To';
    assetType     @Common.Label: 'Asset Type';
    assetLocation @Common.Label: 'Location';
    assignedOn    @Common.Label: 'Assigned On';
    assetStatus   @Common.Label: 'Asset Status';

    asset @(
        Common.Label          : 'Asset',
        Common.Text           : assetName,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Assets',
            Parameters    : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : asset_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : assetName,
                    ValueListProperty : 'name'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : assetType,
                    ValueListProperty : 'type'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'location'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'status'
                }
            ]
        },
        Common.ValueListWithFixedValues: false
    );

    employee @(
        Common.Label          : 'Employee',
        Common.Text           : employeeName,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'employee',
            Parameters    : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : employee_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : employeeName,
                    ValueListProperty : 'name'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'role'
                }
            ]
        },
        Common.ValueListWithFixedValues: false
    );
};

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  MAINTENANCE ANNOTATIONS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

annotate service.maintenance with @(

    UI.CreateHidden: false,

    UI.HeaderInfo: {
        TypeName       : 'Maintenance Issue',
        TypeNamePlural : 'Maintenance Issues',
        Title          : { $Type: 'UI.DataField', Value: issue     },
        Description    : { $Type: 'UI.DataField', Value: assetName }
    },

    UI.LineItem: [
        { $Type: 'UI.DataField', Label: 'Issue',       Value: issue          },
        // ── Status with criticality color — uses status_code (works in draft too) ──
        {
            $Type                    : 'UI.DataField',
            Label                    : 'Status',
            Value                    : status_code,
            Criticality              : criticality,
            CriticalityRepresentation: #WithIcon
        },
 
        { $Type: 'UI.DataField', Label: 'Repair Cost', Value: cost           },
        { $Type: 'UI.DataField', Label: 'Technician',  Value: technicianName },
        { $Type: 'UI.DataField', Label: 'Resolved On', Value: resolvedOn     },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Accept',
            Action : 'enterpriseService.acceptMaintenance',
            Inline : false,
            ![@UI.Importance]: #High
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Reject',
            Action : 'enterpriseService.rejectMaintenance',
            Inline : false,
            ![@UI.Importance]: #High
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Re-Open',
            Action : 'enterpriseService.openMaintenance',
            Inline : false
        }
    ],

    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'MaintenanceDetails',
            Label : 'Maintenance Details',
            Target: '@UI.FieldGroup#MaintenanceDetails'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'AssetDetails',
            Label : 'Asset Details',
            Target: '@UI.FieldGroup#AssetDetails'
        }
    ],

    UI.FieldGroup #MaintenanceDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            { $Type: 'UI.DataField', Label: 'Issue',       Value: issue          },
            // ── Status with criticality color in detail page ───────────────
            {
                $Type                    : 'UI.DataFieldWithCriticality',
                Label                    : 'Status',
                Value                    : status_code,
                Criticality              : criticality,
                CriticalityRepresentation: #WithIcon
            },
            { $Type: 'UI.DataField', Label: 'Repair Cost', Value: cost           },
            { $Type: 'UI.DataField', Label: 'Technician',  Value: technicianName },
            { $Type: 'UI.DataField', Label: 'Resolved On', Value: resolvedOn     },
            { $Type: 'UI.DataField', Label: 'Notes',       Value: notes          },
            { $Type: 'UI.DataField', Label: 'Location',    Value: location       }
        ]
    },

    UI.FieldGroup #AssetDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            { $Type: 'UI.DataField', Label: 'Asset Name', Value: assetName     },
            { $Type: 'UI.DataField', Label: 'Technician', Value: technicianName }
        ]
    }
);

annotate service.maintenance with {
    issue          @Common.Label: 'Issue Description';
    cost           @Common.Label: 'Repair Cost';
    assetName      @Common.Label: 'Asset';
    technicianName @Common.Label: 'Technician';

    // ✅ shows description text ("Open") instead of raw code ("O")
    // ✅ works in both draft and active mode
    status_code @(
        Common.Label                   : 'Status',
        Common.Text                    : statusDescription,
        Common.TextArrangement         : #TextOnly,
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'statusVH',
            Label         : 'Status',
            Parameters    : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : status_code,
                    ValueListProperty : 'code'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description'
                }
            ]
        },
        Common.ValueListWithFixedValues: true
    );

    // ✅ hidden from UI — only drives the criticality color rendering
    criticality @UI.Hidden: true;

    asset @(
        Common.Label          : 'Asset',
        Common.Text           : assetName,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Assets',
            Parameters    : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : asset_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'type'
                }
            ]
        }
    );

    employee @(
        Common.Label          : 'Technician',
        Common.Text           : technicianName,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'employee',
            Parameters    : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : employee_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name'
                }
            ]
        }
    );
};
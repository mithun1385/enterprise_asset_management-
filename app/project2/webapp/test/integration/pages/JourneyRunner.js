sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project2/test/integration/pages/maintenanceList",
	"project2/test/integration/pages/maintenanceObjectPage"
], function (JourneyRunner, maintenanceList, maintenanceObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project2') + '/test/flp.html#app-preview',
        pages: {
			onThemaintenanceList: maintenanceList,
			onThemaintenanceObjectPage: maintenanceObjectPage
        },
        async: true
    });

    return runner;
});


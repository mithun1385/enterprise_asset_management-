sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project3/test/integration/pages/assignmentList",
	"project3/test/integration/pages/assignmentObjectPage"
], function (JourneyRunner, assignmentList, assignmentObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project3') + '/test/flp.html#app-preview',
        pages: {
			onTheassignmentList: assignmentList,
			onTheassignmentObjectPage: assignmentObjectPage
        },
        async: true
    });

    return runner;
});


sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/AssetRequestsList",
	"project1/test/integration/pages/AssetRequestsObjectPage"
], function (JourneyRunner, AssetRequestsList, AssetRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onTheAssetRequestsList: AssetRequestsList,
			onTheAssetRequestsObjectPage: AssetRequestsObjectPage
        },
        async: true
    });

    return runner;
});


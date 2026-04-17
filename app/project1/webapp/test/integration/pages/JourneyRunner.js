sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/AssetsList",
	"project1/test/integration/pages/AssetsObjectPage"
], function (JourneyRunner, AssetsList, AssetsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onTheAssetsList: AssetsList,
			onTheAssetsObjectPage: AssetsObjectPage
        },
        async: true
    });

    return runner;
});


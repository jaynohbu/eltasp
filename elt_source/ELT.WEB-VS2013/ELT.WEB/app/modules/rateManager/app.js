


var appRateManager = angular.module("appRateManager", [
     'ngRoute', 'AxelSoft','ngCookies'
]);


appRateManager.controller('RateManagerController', [
    '$scope', '$location', '$sce', '$timeout', '$q', '$rootScope', '$routeParams', 'ReferenceService', 'RateManagerService','AccountService', RateManagerController

]);

////register appRateMananager 

appRateManager.service('RateManagerService', ['$http', '$q', '$cookies', RateManagerService]);
appRateManager.service('ReferenceService', ['$http', '$q', '$cookies', ReferenceService]);
appRateManager.service('AccountService', ['$http', '$q', '$cookies', AccountService]);

appRateManager.config([
    '$httpProvider', function ($httpProvider) {
        "use strict";
        $httpProvider.defaults.useXDomain = true;
        $httpProvider.defaults.headers.common = {};
        $httpProvider.defaults.headers.post = {};
        $httpProvider.defaults.headers.put = {};
        $httpProvider.defaults.headers.patch = {};
        var baseUrl = $("#rootUrl").attr("value") + "scripts/";
        //$routeProvider
        //    .when('/', {
        //        templateUrl: baseUrl + '/app/modules/admin/views/appRateMananager.html',
        //        controller: 'UserAccessController'
        //    })
        //    .otherwise('/');
    }
]);

var RateManagerService = function ($http, $q, $cookies) {
    $http.defaults.useXDomain = true;
    return {
        getCustomerSellingRate: getCustomerSellingRate,
        getIataRate: getIataRate,
        getAirlineBuyingRate: getAirlineBuyingRate,
        getAgentBuyingRate:getAgentBuyingRate,
        getCarrierModel: getCarrirModel,
        getRouteModel: getRouteModel,
        saveTable: saveTable,
        addCompanyWrapperModel: addCompanyWrapperModel
    }
    function getSessionId() {
        var sessionId = $cookies.get('ELTSession');
       // alert(sessionId);
        return sessionId;
    }



    function saveTable(table) {
        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'post',
            headers: {
                'Content-Type': 'application/json'
            },
            data: { table: table, sessionId: getSessionId() },
            url: apiBaseUrl + 'rate/save'
        });
        return request.then(handleSuccess, handleError);
    }

    function addCompanyWrapperModel() {
        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'rate/companywrappermodel'
        });
        return request.then(handleSuccess, handleError);

    }

    function getCarrirModel() {
        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'rate/carriermodel'
    });
        return request.then(handleSuccess, handleError);
    }
    function getRouteModel() {
        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'rate/routemodel'
        });
        return request.then(handleSuccess, handleError);
    }
    //getAirlineBuyingRate
    function getAirlineBuyingRate( skip, take) {
        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'rate/airlineBuying?sessionId=' + getSessionId()+'&skip='+skip+'&take='+take
        });
        return request.then(handleSuccess, handleError);
    }
    function getAgentBuyingRate(agentId, skip, take) {
        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'rate/agentBuying?agentId=' + agentId + '&sessionId=' + getSessionId() + '&skip=' + skip + '&take=' + take
        });
        return request.then(handleSuccess, handleError);
    }
    function getIataRate(skip, take) {
        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'rate/iata?sessionId=' + getSessionId() + '&skip=' + skip + '&take=' + take
        });
        return request.then(handleSuccess, handleError);
    }
    function getCustomerSellingRate(customerid, skip, take) {
        var apiBaseUrl = $("#apiBaseUrl").attr("value");

        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'rate/customerselling?customerId=' + customerid + '&sessionId=' + getSessionId() + '&skip=' + skip + '&take=' + take
        });
        return request.then(handleSuccess, handleError);
    }
    function handleSuccess(response) {
        return (response.data);
    }
    function handleError(response) {
        if (!angular.isObject(response.data) || !response.data.message) {
            return $q.reject("An unknown error occurred.");
        }
        return $q.reject(response.data.message);
    }
}


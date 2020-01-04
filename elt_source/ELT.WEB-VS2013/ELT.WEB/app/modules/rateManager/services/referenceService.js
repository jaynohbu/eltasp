
var ReferenceService = function ($http, $q, $cookies) {
  
    $http.defaults.useXDomain = true;
    return {
        getCustomers: getCustomers,
        getAgents:getAgents,
        getAirlines: getAirlines,
        getPorts: getPorts
    }
    function getSessionId() {
        var sessionId = $cookies.get('ELTSession');
       
        return sessionId;
    }
    function getAirlines(qry) {

        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'reference/airlines?qry=' + qry + "&sessionId=" + getSessionId()

        });
        return request.then(handleSuccess, handleError);
    }
    function getCustomers(qry) {
        
        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'reference/customers?qry=' + qry + "&sessionId=" + getSessionId()

        });
        return request.then(handleSuccess, handleError);
    }
    function getAgents(qry) {

        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'reference/agents?qry=' + qry + "&sessionId=" + getSessionId()

        });
        return request.then(handleSuccess, handleError);
    }
    function getPorts(qry) {

        var apiBaseUrl = $("#apiBaseUrl").attr("value");
        var request = $http({
            method: 'get',
            url: apiBaseUrl + 'reference/ports?qry=' + qry + "&sessionId=" + getSessionId()

        });
        return request.then(handleSuccess, handleError);
    }

    function handleError(response) {
        if (!angular.isObject(response.data) || !response.data.message) {
            return $q.reject("An unknown error occurred.");
        }
        return $q.reject(response.data.message);
    }
    function handleSuccess(response) {

        return (response.data);
    }
   
}


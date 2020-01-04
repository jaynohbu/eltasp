
var AccountService = function ($http, $q, $cookies) {
  
    $http.defaults.useXDomain = true;
    return {
        getSessionId: getSessionId
    }
    function getSessionId() {
        var sessionId = $cookies.get('ELTSession');

        return sessionId;
    }
 
   
}


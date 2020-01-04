

var RateManagerController = function ($scope, $location, $sce, $timeout, $q, $rootScope, $routeParams, ReferenceService, RateManagerService, AccountService) {
    $scope.baseUrl = $("#rootUrl").attr("value") + "scripts/";
    $scope.pageSize = $("#pageSize").attr("value");
    $scope.apiBaseUrl = $("#apiBaseUrl").attr("value");
    $scope.contentUrl = $scope.apiBaseUrl + 'useraccess/search';
    $scope.resetModel = function () {
        $scope.rateTable = null;
        $scope.model = { customerSellingRateTable: [], iataRateTable: [], agentBuyingRateTable: [], airlineBuyingRateTable: [] }
    }
    $(window).on('beforeunload', function (e) {

        if (!$scope.compareModel()) {
            return false;
        }
    });
    $scope.page_load = function(s) {
        $scope.reset = 1;
        $scope.resetModel();
        $scope.skip = 0;
    };
    $scope.getPage = function (skip) {
        $scope.skip = skip;
        $scope.fetchRate();
    }
  
    $scope.getRates = function () {
        $scope.skip = 0;
        $scope.fetchRate();
        $scope.reset++;
    }
    $scope.fetchRate = function (noShow) {
        if (noShow == undefined)noShow = false;
        if ($scope.customer == undefined) {
            $scope.customer = { value: 0 };
        }
        if ($scope.agent == undefined) {
            $scope.agent = { value: 0 };
        }
        if ($scope.rateTypeId === 4) {
            $scope.resetModel();
            $scope.rateTypeText = "Customer Selling Rate";
           
            RateManagerService.getCustomerSellingRate($scope.customer.value, $scope.skip, $scope.pageSize).then(function (data) {

                $scope.rateTable = [];
                $scope.model.companyWrappers = data.companyWrappers;
                $scope.totalRows = data.total;
             
                if (!noShow) {
                    $scope.message = "Rate table fetched successfully.";
                    $scope.showMessage();
                }
                $scope.rateTable = $scope.extractRouts();
                var oldModel = JSON.stringify($scope.rateTable);
                $("#oldModel").val(oldModel);

            }, function() {
                $scope.error = "Rate table fetch failed. Please retry.";
                if (noShow == undefined)
                $scope.showError();
            });
        }
        if ($scope.rateTypeId === 1) {
            $scope.resetModel();
            $scope.rateTypeText = "Agent Buying Rate";
            //alert($scope.agent.value);
            RateManagerService.getAgentBuyingRate($scope.agent.value, $scope.skip, $scope.pageSize).then(function (data) {

                $scope.rateTable = [];
                $scope.model.companyWrappers = data.companyWrappers;
                $scope.totalRows = data.total;
                $scope.message = "Rate table fetched successfully.";
                $scope.showMessage();
                $scope.rateTable = $scope.extractRouts();
                var oldModel = JSON.stringify($scope.rateTable);
                $("#oldModel").val(oldModel);

            }, function () {
                $scope.error = "Rate table fetch failed. Please retry.";
                $scope.showError();
            });
        }
        if ($scope.rateTypeId === 3) {
            $scope.resetModel();
            $scope.rateTypeText = "Airline Buying Rate";
            RateManagerService.getAirlineBuyingRate($scope.skip, $scope.pageSize).then(function (data) {
                
                $scope.rateTable = $scope.model.airlineBuyingRateTable = data.table;
                $scope.totalRows = data.total;
                var oldModel = JSON.stringify($scope.rateTable);
                $("#oldModel").val(oldModel);

                $scope.message = "Rate table fetched successfully.";
                $scope.showMessage();

            }, function () {
                $scope.error = "Rate table fetch failed. Please retry.";
                $scope.showError();
            });
        }
       
        if ($scope.rateTypeId === 5) {
            $scope.resetModel();
            $scope.rateTypeText = "IATA  Rate";

            RateManagerService.getIataRate($scope.skip, $scope.pageSize).then(function (data) {

                $scope.rateTable = $scope.model.iataRateTable = data.table;
                $scope.totalRows = data.total;
                var oldModel = JSON.stringify($scope.rateTable);
                $("#oldModel").val(oldModel);
                $scope.message = "Rate table fetched successfully.";
                $scope.showMessage();

            }, function () {
                $scope.error = "Rate table fetch failed. Please retry.";
                $scope.showError();
            });
        }

        
        $scope.updateModel();
    }
    $scope.rateTypeText = "Customer Selling Rate";
    $scope.rateTypeId = 4;
    $scope.rateTypeChanged = function (id) {
        if (!$scope.compareModel()) {
            if (!confirm("Changes are not saved. Would you like to pefrom another serach")) {
                return;
            }
        }
        $scope.rateTable = [];
        $scope.model = null;
        $scope.totalRows = null;
        $scope.companyWrappers = [];
        $scope.rateTypeId = id;
        if (id == 4) {
            $scope.rateTypeText = "Customer Selling Rate";
        }
        if (id == 3) {
            $scope.rateTypeText = "Airline Buying Rate";
        }
        if (id == 1) {
            $scope.rateTypeText = "Agent Buying Rate";
        }
        if (id == 5) {
            $scope.rateTypeText = "IATA  Rate";
        }
        $("#oldModel").val(null);
        // $scope.$apply();
    }
    $scope.updateModel = function () {
       
        //setTimeout(function () { $("#form-rate-man").areYouSure(); }, 1000);
    }
    $scope.showMessage = function () {
        $scope.error = null;
        $('#displayMsg').modal();
       // $('#displayMsg').fadeOut(4000);
    }
    $scope.showError = function () {
        $scope.message = null;
        $('#displayError').dialog();
       // $('#displayError').fadeOut(4000);
    }
    $scope.checkOriginDestination = function () {
        var goOn = true;
        $.each($(".sPortOrign :selected"), function (i, obj) {
            var destin = $(obj).parent().parent().parent().find(".sPortDestin :selected");
            if(destin.text() !== '' && $(obj).text() !== ''){
                if ($(obj).text() === destin.text()) {
                    $(obj).parent().css('background-color', 'red');
                    destin.parent().css('background-color', 'red');
                    goOn = false;
                    return;
                }
            } else {
                $(obj).parent().css('background-color', '');
                destin.parent().css('background-color', '');
            }
        });

        if (!goOn) {
            $scope.error = "Destination cannot be the same as Origin. Please retry.";
            $scope.showError();
        }
        return goOn;
    }
    $scope.checkFieldValidation=function() {
        var goOn = true;
        $.each($(".sPortOrign :selected"), function (i, obj) {
            //alert('sPortOrign');
            if ($(obj).text() === '') {
                $(obj).parent().focus();
                $(obj).parent().css('background-color', 'yellow');
                goOn = false;
                return;
            } else {
                $(obj).parent().css('background-color', '');
            }
        });
        $.each($(".sPortDestin :selected"), function (i, obj) {
            //alert('sPortDestin');
            if ($(obj).text() === '') {
                $(obj).parent().focus();
                $(obj).parent().css('background-color', 'yellow');
                goOn = false;
                return;
            } else {
                $(obj).parent().css('background-color', '');
            }
        });
        $.each($(".sKgLb :selected"), function (i, obj) {
           // alert('kglb');
            if ($(obj).text() === '') {
                $(obj).parent().focus();
                $(obj).parent().css('background-color', 'yellow');
                goOn = false;
                return;
            } else {
                $(obj).parent().css('background-color', '');
            }
        });
        if (!goOn) {
            $scope.error = "Required fields are missing. Please retry.";
            $scope.showError();
        }
        return goOn;
    }
    //savewrappers
    $scope.saveTable = function () {
        var goOn = $scope.checkFieldValidation();
       
        if (goOn) {
            goOn = $scope.checkOriginDestination();
            if (goOn) {
                if ($scope.rateTypeId === 4 || $scope.rateTypeId === 1) {
                    $scope.rateTable = $scope.extractRouts();
                }
                RateManagerService.saveTable($scope.rateTable).then(function () {
                    $scope.message = "Rate table saved successfully.";
                    $scope.showMessage();
                    $scope.fetchRate(true);
                }, function () {
                    $scope.error = "Saving rate table failed. Please retry.";
                    $scope.showError();
                });
            }
        }
        
    }
    function isRouteEquivalent(a, b) {
        var aProps = Object.getOwnPropertyNames(a);
        for (var i = 0; i < aProps.length; i++) {
            var propName = aProps[i];

            // If values of same property are not equal,
            // objects are not equivalent
            console.log( b[propName]);
            if (propName === "disabled") {
                console.log("disabled"+" "+b[propName]);
               if (b[propName] === true) {
                   return false;
               }
            }
            if (propName !== "perCarrier") {
                if (propName === "weightBreak") {
                    for (var j = 0; j < a[propName].length; j++) {
                        console.log(propName + "-" + a[propName][j] + ":" + b[propName][j]);
                        if (a[propName][j] !== b[propName][j]) {
                            return false;
                        }
                    }
                    if (a[propName].length !== b[propName].length) {
                        console.log("length-" + a[propName].length + ":" + b[propName].length);
                        for (var k = a[propName].length; k < b[propName].length; k++) {

                            if (b[propName][k] !== "" && b[propName][k] != null) {
                               
                                return false;
                            }
                        }
                       
                    }
                    
                } else {
                    if (a[propName] !== b[propName]) {
                        console.log(propName + "-" + a[propName] + ":" + b[propName]);
                        return false;
                    }
                }
            }
        }
        return true;
    }
    function isCarrierEquivalent(a, b) {
        // Create arrays of property names
        var aProps = Object.getOwnPropertyNames(a);
        for (var i = 0; i < aProps.length; i++) {
            var propName = aProps[i];

            // If values of same property are not equal,
            // objects are not equivalent
            if (propName === "rateBreak") {
                for (var j = 0; j < a[propName].length; j++) {
                    if (a[propName][j] !== b[propName][j]) {
                        return false;
                    }
                }
            } else {
                if (a[propName] !== b[propName]) {
                    return false;
                }
            }
        }

        // If we made it this far, objects
        // are considered equivalent
        return true;
    }
    $scope.compareModel = function () {
        try {
            console.log($scope.rateTypeId);
            if ($scope.rateTypeId === 4 || $scope.rateTypeId === 1) {
                $scope.rateTable = $scope.extractRouts();
            }
            var result = true;
            //1) route count comparision 

            $scope.rateTableOld = JSON.parse($("#oldModel").val());
            $scope.rateTable = JSON.parse(JSON.stringify($scope.rateTable));
            console.log($scope.rateTableOld);
            if ($scope.rateTable == undefined) {
                console.log('point 1');
                return false;
            }
            if ($scope.rateTableOld.length !== $scope.rateTable.length) {
                console.log('point 2');
                return false;
            }

            $.each($scope.rateTable, function (i, route) {
                if (route.perCarrier == undefined) {
                    console.log('point 3');
                    result = false;
                    return;
                }
                if ($scope.rateTableOld[i].perCarrier.length !== route.perCarrier.length) {
                    console.log('point 4');
                    result = false;
                    return;
                }
                $.each(route.perCarrier, function(j, carrier) {
                    if (!isCarrierEquivalent($scope.rateTableOld[i].perCarrier[j], carrier)) {
                        result = false;
                        console.log('point 5');
                        return;
                    }
                    console.log('point 6');
                });
                console.log('point 7');

                if (!isRouteEquivalent($scope.rateTableOld[i], route)) {
                    result = false;
                    console.log('point 8');
                    return;
                }
            });
        } catch (e) {
           
        }
        return result;
    }

  

    $scope.reset = function () {
        $scope.customer = undefined;
    };
    $scope.extractRouts=function() {
        var rateRoutes = [];
        $.each($scope.model.companyWrappers, function (i, obj) {

            $.each(obj.rateRoutes, function (j, route) {

                if (route != undefined) {
                    if ($scope.rateTypeId == 4) {
                        $.each(route.perCarrier, function () {
                            this.customerNo = obj.companyNo;
                            this.rateType = 4;
                        });
                        route.rateType = 4;
                        route.customerNo = obj.companyNo;
                    } else {
                        route.agentNo = obj.companyNo;
                        route.rateType = 1;
                        $.each(route.perCarrier, function (
                        ) {

                            this.agentNo = obj.companyNo;
                            this.rateType = 1;
                        });
                    }
                    rateRoutes.push(route);
                }
            });
        });
        return rateRoutes;
    }
    $scope.isCustomEnabled = true;

    $scope.searchAsync = function (term) {
      //  alert(term);
        var deferred = $q.defer();
        if (term.length > 1) {

            $scope.customers = [];
            ReferenceService.getCustomers(term).then(function (customers) {
                deferred.resolve(customers);
            });

        } else {
            ReferenceService.getCustomers('default1000').then(function (customers) {
                deferred.resolve(customers);
            });
        }
      
        return deferred.promise;
    };

    $scope.searchAsyncAgent = function (term) {
        //  alert(term);
        var deferred = $q.defer();
        if (term.length > 1) {

            $scope.agents = [];
            ReferenceService.getAgents(term).then(function (agents) {
                deferred.resolve(agents);
            });

        } else {
            ReferenceService.getAgents('default1000').then(function (agents) {
                deferred.resolve(agents);
            });
        }
        return deferred.promise;
    };

    //$scope.$on('$locationChangeStart', function(event, next, current) {
    //    alert('a');
    //});

}

var checkOrder = function (obj) {
    var prev = 0;
    var index = 0;
    var inputs = $(obj).parent().parent().find(".smallInputBox");
    inputs.each(function (i, obj2) {
        if (obj2 === obj) {
            if (index > 0) {

                if (parseInt(inputs[index - 1].value) >= parseInt(obj.value)) {
                    alert("The break is not in order!");
                    obj.value = '';
                }
            }
        }
        index++;
    });

}
var checkNumeric = function (obj) {
    if (!$.isNumeric(obj.value)) {
        alert('The value must be a number!');
        obj.value = null;
    }
}

Array.prototype.insert = function (index, item) {
    this.splice(index, 0, item);
};




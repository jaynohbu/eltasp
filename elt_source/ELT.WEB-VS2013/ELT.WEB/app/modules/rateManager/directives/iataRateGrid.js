
angular.module('appRateManager').directive("iataRateGrid", function () {
    var baseUrl = $("#rootUrl").attr("value");

    return {
        transclude: true,
        scope: {
            ngModel: '=',
            resetModel: '&',
            onChange: '&',
            rateType:'@'
        },
     
        templateUrl: function (tElement, tAttrs) {
            var url = baseUrl + "/app/modules/rateManager/views/iataRateGrid.html";
            return url;
            
        } ,
        compile: function (element, attrs) {

            
        },
        controller: function ($scope, $q, RateManagerService, ReferenceService) {
           
            (function() {
                ReferenceService.getPorts('default1000').then(function(ports) {
                    $scope.ports = ports;
                   // console.log(ports);
                });
               
            })();

            $scope.$watch("ngModel", function () {
                $scope.model = $scope.ngModel;
               // console.log($scope.model);
            });
            $scope.removeRate = function (r) {
                if (confirm("Are you sure you want to remove this route?")) {
                    var index = $scope.model.indexOf(r);
                 
                    $scope.model[index].disabled = true;
                    $scope.onChange({ model: $scope.model });
                    // $scope.model.splice(index, 1);
                }
            }
           
            $scope.removeCarrier = function (r, c) {
                if (confirm("Are you sure you want to remove this carrier?")) {
                    var index = $scope.model.indexOf(r);
                    var index2 = $scope.model[index].perCarrier.indexOf(c);
                    $scope.model[index].perCarrier[index2].disabled = true;
                    var noCarrier = true;
                    $.each($scope.model[index].perCarrier, function (i, obj) {
                        if (obj.disabled === false) {
                            noCarrier = false;
                        }
                    });
                    if (noCarrier === true) {
                        $scope.model[index].disabled = true;
                    }
                    $scope.onChange({ model: $scope.model });
                   // $scope.model[index].perCarrier.splice(index2, 1);
                }
            }
           
            $scope.addRoute = function () {
                RateManagerService.getRouteModel().then(function (data) {
                    data.rateType = $scope.rateType;
                    if ($scope.model == undefined) $scope.model = [];
                    $scope.model.push(data);
                    $scope.onChange({model:$scope.model});
                   
                });
              
            }
            $scope.addCarrier = function (customerNo) {
              
                $.each($scope.model, function (i, obj) {
              
                    if (obj.customerNo === customerNo) {
                        RateManagerService.getCarrierModel().then(function (data) {
                            if (obj.perCarrier == undefined) obj.perCarrier = [];
                            obj.perCarrier.push(data);
                           // $scope.model[i].perCarrier = obj.perCarrier;
                            $scope.onChange({ model: $scope.model });
                        });
                    }
                });
            }


            $scope.reset = function () {
                $scope.customer = undefined;
            };

            $scope.isCustomEnabled = true;
            $scope.customOptions = {
                displayText: 'Select',
                emptyListText: 'Oops! The list is empty',
                emptySearchResultText: 'Sorry, couldn\'t find "$0"'
            };
            $scope.existingRoute = function (r) {
                if (r.perCarrier) {
                    if (r.perCarrier.length > 0 && r.perCarrier[0].id > 0) return true;
                }
                return false;
            }
            $scope.searchAirline = function (term) {
              
                var deferred = $q.defer();
                if (term.length > 1) {

                    $scope.airlines = [];
                    ReferenceService.getAirlines(term).then(function (airlines) {
                        deferred.resolve(airlines);
                    });

                } else {
                    ReferenceService.getAirlines('default1000').then(function (airlines) {
                        // console.log(customers);
                        deferred.resolve(airlines);
                    });
                }


                return deferred.promise;
            };

            $scope.searchCustomer = function (term) {

                var deferred = $q.defer();
                if (term.length > 1) {

                    $scope.customers = [];
                    ReferenceService.getCustomers(term).then(function (customers) {
                        deferred.resolve(customers);
                    });

                } else {
                    ReferenceService.getCustomers('default1000').then(function (customers) {
                       // console.log(customers);
                        deferred.resolve(customers);
                    });
                }


                return deferred.promise;
            };
        }



    };
});

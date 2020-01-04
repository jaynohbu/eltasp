
angular.module('appRateManager').directive("agentBuyingRateGrid", function () {
    var baseUrl = $("#rootUrl").attr("value");

    return {
        transclude: true,
        scope: {
            ngModel: '=',
            resetModel: '&',
            onChange: '&',
            rateType: '@'
        },
        templateUrl: function (tElement, tAttrs) {
            var url = baseUrl + "/app/modules/rateManager/views/agentBuyingGrid.html";
            return url;
        },
        compile: function (element, attrs) {


        },
        controller: function ($scope, $q, RateManagerService, ReferenceService) {

            (function () {
                ReferenceService.getPorts('default1000').then(function (ports) {
                    $scope.ports = ports;
                    // console.log(ports);
                });

            })();
            
            $scope.$watch("ngModel", function () {
                $scope.model = $scope.ngModel;
                // console.log($scope.model);
            });
            $scope.existingRoute = function (r) {
                if (r.perCarrier) {
                    if (r.perCarrier.length > 0 && r.perCarrier[0].id > 0) return true;
                }
                return false;
            }
            $scope.removeRoute = function (r, m) {
                if (confirm("Are you sure you want to remove this route?")) {
                    var index = m.rateRoutes.indexOf(r);

                    m.rateRoutes[index].disabled = true;
                    $scope.onChange({ model: $scope.model });
                    // $scope.model.splice(index, 1);
                }
            }
            $scope.removeCarrier = function (r, c) {
                if (confirm("Are you sure you want to remove this carrier?")) {
                    c.disabled = true;

                    $scope.onChange({ model: $scope.model });
                    // $scope.model[index].perCarrier.splice(index2, 1);
                }
            }
            $scope.addCompany = function () {
               // alert('a');
                RateManagerService.addCompanyWrapperModel().then(function (data) {
                    data.rateType = 4;
                    if ($scope.model == undefined) $scope.model = [];
                    $scope.model.insert(0, data);
                    $scope.onChange({ model: $scope.model });
                });
            }

            $scope.removeCompany = function (m) {
                if (confirm("Are you sure you want to remove this company?")) {
                    var index = $scope.model.indexOf(m);
                    $scope.model[index].disabled = true;
                    $.each($scope.model[index].rateRoutes, function () {
                        this.disabled = true;
                    });
                    $scope.onChange({ model: $scope.model });
                    // $scope.model.splice(index, 1);
                }
            }

            $scope.addRoute = function (m) {
                RateManagerService.getRouteModel().then(function (data) {
                    if (m.rateRoutes == undefined) m.rateRoutes = [];
                    m.rateRoutes.insert(0, data);
                    $scope.onChange({ model: $scope.model });
                });
            }
            $scope.addCarrier = function (r) {
                RateManagerService.getCarrierModel().then(function (data) {
                    if (r.perCarrier == undefined) r.perCarrier = [];
                    r.perCarrier.push(data);
                    // $scope.model[i].perCarrier = obj.perCarrier;
                    $scope.onChange({ model: $scope.model });
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

            $scope.searchAgent = function (term) {

                var deferred = $q.defer();
                if (term.length > 1) {

                    $scope.customers = [];
                    ReferenceService.getAgents(term).then(function (customers) {
                        deferred.resolve(customers);
                    });

                } else {
                    ReferenceService.getAgents('default1000').then(function (customers) {
                        // console.log(customers);
                        deferred.resolve(customers);
                    });
                }


                return deferred.promise;
            };
        }



    };
});

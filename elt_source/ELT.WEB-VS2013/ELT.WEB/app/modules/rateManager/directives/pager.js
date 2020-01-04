
angular.module('appRateManager').directive("pager", function () {
    var baseUrl = $("#rootUrl").attr("value");

    return {
        scope: {
            ngModel: '=',
            size: '=',
            onChange: '&',
            reset:'='
        },
        templateUrl: function (tElement, tAttrs) {
            var url = baseUrl + "/app/modules/rateManager/views/pager.html";
            return url;
            
        } ,
        compile: function (element, attrs) {

            
        },
        controller: function ($scope) {
            $scope.$watch("reset", function () {
                $scope.generatePaging();

            });
            $scope.$watch("ngModel", function () {
                //alert($scope.ngModel);
                $scope.totalCount = parseInt($scope.ngModel);
              //  alert($scope.totalCount);
                $scope.generatePaging();
               
            });
            $scope.pageBlocks = [];
            $scope.goNextBlock=function() {
                $scope.currentBlock++;
                if ($scope.currentBlock > $scope.blockCount) {
                    $scope.currentBlock = $scope.blockCount;
                }
                $scope.goToPage($scope.currentBlock);
            }
            $scope.goPreviousBlock = function () {
                $scope.currentBlock --;
                if ($scope.currentBlock == 0) {
                    $scope.currentBlock = 1;
                }
                $scope.goToPage($scope.currentBlock);
            }
            $scope.generatePaging = function () {
                $scope.pageBlocks = [];
                $scope.blockCount = 1;
              //  alert($scope.totalCount);
              //  scope.pageBlocks.push( $scope.blockCount);
                for (var i = 0; i < $scope.totalCount; i++)
                {//block count and the index within it are the same 

                    if (i % 10 == 1) {//10,20,30
                        $scope.pageBlocks.push($scope.blockCount);
                        $scope.blockCount++;
                    } 
                }
                $scope.currentBlock = 1;
                setTimeout(function() {
                    var obj = $('#li_1').get(0);
                    $('#ul_pager').children().removeClass('active');
                    $(obj).addClass("active");
                    $scope.page = 1;
                    
                }, 1000);
            }
           
            $scope.goToPage = function (page) {
                if (page == -1) {
                    $scope.goNextBlock();
                }else if (page == -2) {
                    $scope.goPreviousBlock();
                } else {
                    var obj = $('#li_' + page).get(0);
                    $('#ul_pager').children().removeClass('active');
                    $(obj).addClass("active");
                    $scope.page = page;
                    var skip = (page - 1) * $scope.size;
                    $scope.onChange({ skip: skip });
                }

            }
        }



    };
});


//1: scoping - ($) is a function that is within jQuery Space 
//-> notic the jQuery is passed immediately to the parameter ($) after definition.
//-> outer ();  is the immediately invoked function expression 
(function ($) {
    $.fn.PeriodList = function (options) {

        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        today = mm + '/' + dd + '/' + yyyy;

        var settings = $.extend({
            StartDateField: null,
            EndDateField: null
        }, options); //saying this is the parameter that will be extened as to have two properties by the $.extend function

        $(this).append($('<option>', {
            value: -1,
            text: 'Select'
        }));

        $(this).append($('<option>', {
            value: 0,
            text: 'Today'
        }));
        $(this).append($('<option>', {
            value: 1,
            text: 'Month to Date'
        }));
        $(this).append($('<option>', {
            value: 2,
            text: 'Quarter to Date'
        }));
        $(this).append($('<option>', {
            value: 3,
            text: 'Year to Date'
        }));
        $(this).append($('<option>', {
            value: 4,
            text: 'This Month'
        }));
        $(this).append($('<option>', {
            value: 5,
            text: 'This Quearter'
        }));
        $(this).append($('<option>', {
            value: 6,
            text: 'This Year'
        }));

        function daysInMonth(iMonth, iYear) {
            return new Date(iYear, iMonth, 0).getDate();
        }

        function getQuarterMonth(d) {
            d = d || new Date(); // If no date supplied, use today
            var q = [4, 1, 2, 3];
            result = q[Math.floor(d.getMonth() / 3)];
            if (result == 4) {
                return "1";
            }
            if (result == 1) {
                return "4";
            }
            if (result == 2) {
                return "7";
            }
            if (result == 3) {
                return "10";
            }
        }

        function GetPeriod() {
            var begin = today;
            var end = today;
            if ($(this).val() == "0") {//<option value="0">Today</option>
                begin = today;
                end = today;
                $(settings.StartDateField).val(begin);
                $(settings.EndDateField).val(end);
            }
            if ($(this).val() == "1") {//<option value="1">Month to Date</option>
                begin = mm + '/' + "1" + '/' + yyyy;
                $(settings.StartDateField).val(begin);
                $(settings.EndDateField).val(end);
            }
            if ($(this).val() == "2") {//<option value="2">Quarter to Date</option>
                begin = getQuarterMonth() + '/' + "1" + '/' + yyyy;
                $(settings.StartDateField).val(begin);
                $(settings.EndDateField).val(end);
            }
            if ($(this).val() == "3") {//<option value="3">Year to Date</option>
                begin = "1" + '/' + "1" + '/' + yyyy;
                $(settings.StartDateField).val(begin);
                $(settings.EndDateField).val(end);
            }
            if ($(this).val() == "4") {//<option value="4">This Month</option>
                begin = mm + '/' + "1" + '/' + yyyy;
                end = mm + '/' + daysInMonth(mm, yyyy) + '/' + yyyy;
                $(settings.StartDateField).val(begin);
                $(settings.EndDateField).val(end);
            }
            if ($(this).val() == "5") {//<option value="5">This Quearter</option>
                begin = getQuarterMonth() + '/' + "1" + '/' + yyyy;
                end = (parseInt(getQuarterMonth()) + 2) + '/' + daysInMonth((parseInt(getQuarterMonth()) + 2), yyyy) + '/' + yyyy;
                $(settings.StartDateField).val(begin);
                $(settings.EndDateField).val(end);
            }
            if ($(this).val() == "6") {//<option value="6">This Year</option>
                begin = "1" + '/' + "1" + '/' + yyyy;
                end = "12" + '/' + "31" + '/' + yyyy;
                $(settings.StartDateField).val(begin);
                $(settings.EndDateField).val(end);
            }
          
        }
        return this.change(GetPeriod);
    };
} (jQuery));


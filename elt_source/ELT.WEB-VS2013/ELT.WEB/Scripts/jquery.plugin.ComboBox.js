
(function ($) {
    $.fn.ComboBoxJnoh = function (options) {
        
        var settings = $.extend({
            Width: null,
            DataSourceUrl: null,
            TypeOfOrg: null,
            ValueField: null,
            TextField:null,
            CallBack: null
        }, options); //saying this is the parameter that will be extened as to have two properties by the $.extend function

        var firstCompanyName;
        var firstCompanyValue;
        var fieldObj = this;
        //alert($(settings.ValueField).length);
        if (settings.Width == null) { settings.Width = "200px"; }
        var id = $(this).attr("id");
       // var h_fieldObj= $("<input class='HiddenComboJnoh' name='h_"+id+"' id='h_"+id+"' type='hidden'>");
        var load_div = $("<div class='LoadDivComboJnoh' style=' display:block'width: " + parseInt(settings.Width)+50 + "; border: 1px solid rgb(170, 170, 170);  overflow-y: scroll; overflow-x: hidden; height: 200px; z-index: 1;'></div>");
        var table = $("<table class='tableComboJnoh' id='tb_" + id + "' border='0' cellspacing='0' cellpadding='0'></table>");
        var tbody = $("<tbody></tbody>");       
        var textbox_style = "border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgb(127, 157, 185); width: 200px;height:15px;";
        this.attr("style", textbox_style);
        var first_tr=$("<tr></tr>");
        var first_td = $("<td class='ComboInputWarp' style='display:table-cell; vertical-align:middle'></td>");      
        $(first_tr).append(first_td);
        $(tbody).append(first_tr);
        $(table).append(tbody);
        $(this).wrap($("<div>").append(table).html());
        var second_td=$("<td style='display:table-cell; vertical-align:middle'></td>");
        var img_drop = $("<img style='border-width: 1px 1px 1px 0px; border-style: solid; border-color: rgb(127, 157, 185); cursor: hand;' alt='' src='/ig_common/Images/combobox_drop.gif'>");
        var third_td = $("<td style='display:table-cell; vertical-align:middle'></td>");
        $(second_td).append(img_drop);
        $(this).parent().after(second_td);       
        $(this).parent().parent().parent().parent().after(load_div);
        $(this).keyup(organizationFill);
        $(img_drop).click(function () { $(fieldObj).val(""); lock_div = true; $(fieldObj).blur(); });
        $(img_drop).click(organizationFill);

        function Initialize() {        
            var tmpVal = "";          
            this.onclick = function () {
                this.select();
            };
            this.onkeydown = function () {
                if (event.keyCode == 9 || event.keyCode == 13) {
                    event.keyCode = 9;                
                    try {
                      
                        setTimeout(load_div.get(0).children(0).firstChild.children(1).firstChild.onclick, 0);
                    } catch (err) {
                       
                        if (load_div.innerHTML != "") {
                            setTimeout(load_div.get(0).children(0).firstChild.children(0).firstChild.onclick, 0);
                        }
                    }
                }
            };
            this.onblur = function () {
                try {                  
                   // setTimeout(CloseJPEDG, 200);
                } catch (err) { }
            };
        }

        function organizationFill(e)
        {
            e.preventDefault();
           
            $(fieldObj).focus();
            var qStr = $(fieldObj).val();       
            var keyCode = window.event.keyCode;
            var url;
            if (keyCode != 229 && keyCode != 27) {
                if (qStr == '') {
                    url = "/asp/ajaxFunctions/ajax_get_organization_xml.asp?oType="
                                       + settings.TypeOfOrg;
            }else{
                    url = "/asp/ajaxFunctions/ajax_get_organization_xml.asp?oType="
                                       + settings.TypeOfOrg + "&qStr=" + qStr;
            }
                FillOutJPED( url);
            }
        }

        function FillOutJPED(url) {
            urlStr = url; 
            load_div.get(0).innerHTML = "";
            load_div.get(0).style.display = "none";
            bufferSize = 1;
            url = encodeURI(url + "&limit=" + PageLimit);
            $.ajax({
                url: url
            }).success(DrawJPED);
          
        }

        
        var PageLimit = 50;
        var urlStr = "";
        var L_Item = new Array();
        var firstCompanyName = "";
        var firstCompanyValue = "";
        var bufferSize;
        L_Item[bufferSize] = "";
        var lock_div = true;
        function DrawJPED(xmlObj) {
      
            var divObj = load_div.get(0);
            var position = fieldObj.offset();
            divObj.innerHTML = "";
            divObj.style.display = "block";
            divObj.style.position = "absolute";
            divObj.style.posTop = position.top + fieldObj.height() + 15;
            divObj.style.posLeft = position.left;
            divObj.style.width = fieldObj.width() + 16;
            divObj.style.border = "1px solid #aaaaaa";
            divObj.style.backgroundColor = "efefef";
            divObj.style.overflowY = "scroll";
            divObj.style.overflowX = "hidden";
            divObj.style.height = "200px";            
            var itemObj = xmlObj.getElementsByTagName("item");
            var valueObj = xmlObj.getElementsByTagName("value");
            var labelObj = xmlObj.getElementsByTagName("label");

            divObj.innerHTML = "";    
           
            var tempVal = "";           
            var LoadingTable = $("<ul class='JnohComboUl' style='margin-top:10px; padding-top:10px; background-color:white; padding-left:0px;width:" + settings.Width + "'></ul>");
                 

            try {
                firstCompanyName = class_code_remove(labelObj[0].childNodes[0].nodeValue)
                firstCompanyValue = valueObj[0].childNodes[0].nodeValue;

            } catch (err) { }

            var tmpVal, tmpLabel, tmpElements;
            var itemLength = itemObj.length;
            tmpElements = new Array(itemObj.length);

            //if (itemLength > PageLimit) {
            //    itemLength = PageLimit;
            //}

            for (var i = 0; i < itemLength ; i++) {
              var  tmpVal = valueObj[i].childNodes[0].nodeValue;
               var tmpLabel = labelObj[i].childNodes[0].nodeValue;
                //alert(tmpLabel);
             
               var item_tr = $("<li  style='display:block; text-align:left; margin-left:2px'  onmouseover=\"this.style.backgroundColor='#cdcddd';\" onmouseout=\"this.style.backgroundColor='transparent';\">" + tmpLabel + "<input type='hidden' value='" + tmpLabel+"_"+ tmpVal + "'/></li>");
               
               item_tr.click(function (e) {
                   e.stopPropagation();
                    SelectValueNow(this);                   
                });
             
                //alert(tmpLabel);
                LoadingTable.append(item_tr);
              
            }
         
        
            $(divObj).append(LoadingTable);
            $(fieldObj).blur(function () {  setTimeout(CloseJPEDG, 200); });           

            $(divObj).mouseover(function (e) {  lock_div = true; $(fieldObj).focus(); })
            $(divObj).mouseout(function () { lock_div = false;  })
            $(divObj).scroll(function () { lock_div = true; })
        }    
       
        function CloseJPEDG() {
            if (!lock_div) {
                load_div.get(0).style.position = "absolute";
                load_div.get(0).innerHTML = "";
                load_div.get(0).style.display = "none";
            }
         
            return false;
        }      
        function SelectValueNow(obj) {

            var text = $(obj).children("input").val().split("_")[0];
            var value = $(obj).children("input").val().split("_")[1];           
            fieldObj.val(text);          
            $(settings.ValueField).val(value);
            lock_div = false;
            setTimeout(CloseJPEDG, 200);         
            if (text != undefined) {
                if (settings.CallBack != null) {
                    settings.CallBack();
                }
            }
        }
        function class_code_remove(strArg) {
            var tempArray = new Array();
            tempArray = strArg.split("[");

            if (tempArray.length >= 2) {
                strArg = tempArray[0];
            }
            return strArg;
        }
    
        return this.focus(Initialize);
    };
}(jQuery));





var PageLimit = 100;
var urlStr = "";
var L_Item = new Array();
var firstCompanyName = "";
var firstCompanyValue = "";
var bufferSize;
L_Item[bufferSize] = "";
var lock_div_of_jped = false;

function FillOutJPED(obj, url, funcName, vHeight) {

    urlStr = url;
    var divObj = document.getElementById(obj.id + "Div");
    divObj.style.position = "absolute";
    divObj.innerHTML = "";
    divObj.style.visibility = "hidden";
    bufferSize = 1;
    url = encodeURI(url + "&limit=" + PageLimit);

    new ajax.xhr.Request('GET', '', url, PopulateJPED, obj.id, funcName, vHeight, '');
}

function PopulateJPED(req, field, funcName, vHeight, vVal_1, url) {
  
    var divName = field + "Div";
    if (req.readyState == 1) {
        LoadJPED(divName, field, "");
    }

    if (req.readyState == 4) {
       
        if (req.status == 200) {
            DrawJPED(divName, field, req.responseXML, funcName, vHeight);
            MaskJPED(divName);
        }
        else {
            document.write(req.responseText);
        }
    }
}

function LoadJPED(divName, fieldName, msg) {
    var divObj = document.getElementById(divName);
    var fieldObj = document.getElementById(fieldName);
    divObj.innerHTML = msg;

    try {
        divObj.style.posTop = findPosY(fieldObj);
        divObj.style.posLeft = findPosX(fieldObj);
        divObj.style.height = fieldObj.clientHeight + 2;
        divObj.style.width = fieldObj.clientWidth + 16;
        divObj.style.border = "1px solid #aaaaaa";
        divObj.style.background = "transparent";
        divObj.style.overflowY = "hidden";
        divObj.style.visibility = "visible";
        divObj.style["min-height"] = "100px";
       
        fieldObj.focus();
    } catch (err) { }
}
var _selectedVal;
var _selectedLabel;
function SelectValueNow(a, b) {
    _selectedVal = a;
    _selectedLabel = class_code_remove(b);
    //alert(_selectedVal);
    //alert(_selectedLabel);
}
function ExecuteSelectFunction(functname) {
    window[functname](_selectedVal, _selectedLabel);
}
function DrawJPED(divName, fieldName, xmlObj, funcName, vHeight) {

    if (vHeight == null || vHeight == "") {
        vHeight = 200;
    }
    var itemObj = xmlObj.getElementsByTagName("item");
    var valueObj = xmlObj.getElementsByTagName("value");
    var labelObj = xmlObj.getElementsByTagName("label");
    var divObj = document.getElementById(divName);
    var fieldObj = document.getElementById(fieldName);

    var innerHTML = "";
    divObj.innerHTML = "";
    divObj.style.position = "absolute";
    divObj.style.posTop = findPosY(fieldObj) + fieldObj.clientHeight + 15;
    divObj.style.posLeft = findPosX(fieldObj);
    divObj.style.width = fieldObj.clientWidth + 16;
    divObj.style.border = "1px solid #aaaaaa";
    divObj.style.backgroundColor = "efefef";
    divObj.style["min-height"] = "100px";
  
    // event handlers ///////////////////////////////////////////////////////////
    var tempVal = "";
   
  
    divObj.onmouseout = function () {
        lock_div_of_jped = false;
    };
    divObj.onscroll = function () {
        lock_div_of_jped = true;
        try {
            fieldObj.focus();
        } catch (ex) { }
    };
    divObj.onmouseover = function () {
        lock_div_of_jped = true;
        try {
            fieldObj.focus();
        } catch (ex) { }
    };
    innerHTML = "<table class='jped' id=\"" + fieldName + "Table\" cellspacing=0 cellpadding=1 border=0 "
            + "bgcolor=\"#efefef\" width=100% height=100% class=bodycopy style=\"cursor:hand; color:#000000\">"
            + "<tr><td onmouseover=\"this.style.backgroundColor='#cdcddd';\" "
            + "onmouseout=\"this.style.backgroundColor='transparent';\" "
            + "onclick=\"" + funcName + "('0','');\"><font color=\"#888888\">&lt; RESET FIELD &gt;</font></td></tr>";

    //alert(innerHTML);
    if (bufferSize > 1) {
        innerHTML = innerHTML + "\n<tr><td onmouseover=\"this.style.backgroundColor='#cdcddd';\" "
            + "onmouseout=\"this.style.backgroundColor='transparent';\" onclick=\"showPreviousGroupJPED('"
            + fieldName + "','" + funcName + "'," + vHeight + ",'" + L_Item[bufferSize]
            + "');\"><font color=\"#ff8800\">&lt; PREVIOUS "
            + " 100 &gt;</font></td></tr>";
    }

    //try {

    try {
        firstCompanyName = class_code_remove(labelObj[0].childNodes[0].nodeValue)
        firstCompanyValue = valueObj[0].childNodes[0].nodeValue;

    } catch (err) { }

    var tmpVal, tmpLabel, tmpElements;
    var itemLength = itemObj.length;
    tmpElements = new Array(itemObj.length);

    if (itemLength > PageLimit) {
        itemLength = PageLimit;
    }

    for (var i = 0; i < itemLength; i++) {
        if (valueObj[i].childNodes.length > 0 && labelObj[i].childNodes.length > 0) {
            tmpVal = valueObj[i].childNodes[0].nodeValue;
            tmpLabel = labelObj[i].childNodes[0].nodeValue;
            
            tmpElements[i] = "<tr><td onmouseover=\"this.style.backgroundColor='#cdcddd';SelectValueNow('" + tmpVal + "','" + tmpLabel + "');\" "
                + "onmouseout=\"this.style.backgroundColor='transparent';\" "
                + "onclick=\"" + funcName + "('" + tmpVal + "','" + class_code_remove(tmpLabel) + "'); \">"
                + tmpLabel + "</td></tr>";
            //alert(tmpElements[i]);
        }
    }

    innerHTML = innerHTML + tmpElements.join("\n");


    if (itemLength == PageLimit) {
        innerHTML = innerHTML + "\n<tr><td onmouseover=\"this.style.backgroundColor='#cdcddd';\" "
            + "onmouseout=\"this.style.backgroundColor='transparent';\" onclick=\"showNextGroupJPED('"
            + fieldName + "','" + funcName + "'," + vHeight + ",'" + class_code_remove(tmpLabel)
            + "');\"><font color=\"#ff8800\">&lt; SHOW NEXT "
            + itemLength + " &gt;</font></td></tr></table>";
    }
    else {
        innerHTML = innerHTML + "</table>";
    }

    divObj.innerHTML = innerHTML;

    var vTableHeight = document.getElementById(fieldName + "Table").clientHeight;

    if (vHeight < vTableHeight) {
        divObj.style.overflowY = "scroll";
        divObj.style.overflowX = "hidden";
        divObj.style.height = vHeight;
        if (divObj.style.width.match(divObj.clientWidth) != null) {
            divObj.style.width = divObj.clientWidth - 16;
        }
    }
    else {
        divObj.style.height = vTableHeight + 2;
        divObj.style.overflowY = "scroll";
    }

    divObj.style.visibility = "visible";
    fieldObj.focus();

    //} catch(err){ }
}

function clear_buffer() {
    bufferSize = 0;
}

function showNextGroupJPED(fieldName, funcName, vHeight, vCompany) {
    var tmpUrl = urlStr;
    bufferSize = bufferSize + 1;
    L_Item[bufferSize] = firstCompanyName;

    tmpUrl = tmpUrl + "&limit=" + PageLimit + "&cursor=" + vCompany;
    new ajax.xhr.Request('GET', '', tmpUrl, PopulateJPED, fieldName, funcName, vHeight, '');
}

function showPreviousGroupJPED(fieldName, funcName, vHeight, LItem) {
    var tmpUrl = urlStr;

    tmpUrl = tmpUrl + "&limit=" + PageLimit + "&cursor=" + LItem;
    new ajax.xhr.Request('GET', '', tmpUrl, PopulateJPED, fieldName, funcName, vHeight, '');
    bufferSize = bufferSize - 1;
}

function MaskJPED(arg) {//return;
    var listDivObj = document.getElementById(arg);
    var innerHTML = listDivObj.innerHTML;


    listDivObj.innerHTML = innerHTML + "<iframe id=\"" + arg
        + "Iframe\" frameborder=\"no\" scrolling=\"yes\" style='border-width:1px'></iframe>";

    var iFrame = document.getElementById(arg + "Iframe");
    iFrame.style.position = "absolute";
    iFrame.style.posTop = 0;
    iFrame.style.posLeft = 0;
    if (listDivObj.style.overflowY == "scroll" || listDivObj.style.overflowY == "auto") {
        iFrame.style.width = listDivObj.clientWidth + 18;
    }
    if (listDivObj.style.overflowY == "hidden") {
        iFrame.style.width = listDivObj.clientWidth + 2;
    }
    iFrame.style.height = listDivObj.scrollHeight;
    listDivObj.style.zIndex = 1;
    iFrame.style.zIndex = -1;
    iFrame.style.filter = "progid:DXImageTransform.Microsoft.BasicImage(mask=1)";
    return false;
}
var divToHide;
function CloseJPEDG() {
    if (lock_div_of_jped != true) {
        divToHide.style.position = "absolute";
        divToHide.innerHTML = "";
        divToHide.style.visibility = "hidden";
        return false;
    }

}
function CloseJPED(divObj, e) {
    evt = e || window.event;
    divToHide = divObj;
    setTimeout(CloseJPEDG, 200);

    divObj.style.position = "absolute";

    var divWidth = divObj.clientWidth + 16;
    var divHieght = divObj.clientHeight + 20;
    var offX = evt.offsetX;
    var offY = evt.offsetY;

    if (offX == null) {
        offX = 0;
    }
    if (offY == null) {
        offY = 0;
    }
    if (offX < 0 || offY < 0 || offX > divWidth || offY > divHieght) {
        setTimeout(CloseJPEDG, 200);

        return false;
    }
    return true;
}

function initializeJPEDField(obj, vFixed) {

    var tmpVal = "";
    obj.onclick = function () { obj.select(); };
    obj.onkeydown = function () {
        if (event.keyCode == 9 || event.keyCode == 13) {
            event.keyCode = 9;
            try {
                var divObj = document.getElementById(obj.id + "Div");
                setTimeout(divObj.children(0).firstChild.children(1).firstChild.onclick, 0);
            } catch (err) {
                if (divObj.innerHTML != "") {
                    setTimeout(divObj.children(0).firstChild.children(0).firstChild.onclick, 0);
                }
            }
        }
    };

    if (vFixed == undefined) {
        vFixed = "";
    }

    obj.onblur = function () {
        try {
            var divObj = document.getElementById(obj.id + "Div");
            if (vFixed != "fixed") {
                CloseJPED(divObj);
            }
        } catch (err) { }
    };
}

function findPosX(obj) {
    var curleft = 0;
    if (obj.offsetParent) {
        while (1) {
            curleft += obj.offsetLeft;
            if (!obj.offsetParent) break;
            obj = obj.offsetParent;
        }
    }
    else if (obj.x) {
        curleft += obj.x;
    }
    return curleft;
}

function findPosY(obj) {
    var curtop = 0;
    if (obj.offsetParent) {
        while (1) {
            curtop += obj.offsetTop;
            if (!obj.offsetParent) break;
            obj = obj.offsetParent;
        }
    }
    else if (obj.y) {
        curtop += obj.y;
    }
    return curtop;
}

function class_code_remove(strArg) {
    var tempArray = new Array();
    tempArray = strArg.split("[");

    if (tempArray.length >= 2) {
        strArg = tempArray[0];
    }
    return strArg;
}

function checkDecimalTextMax(obj, limit) {
    if (obj.value.length >= limit) {
        var temp = obj.value;
        var tempArray = new Array();
        tempArray = temp.split(".");
        temp = tempArray[0];
        if (temp.length >= limit) {
            obj.value = temp.substring(0, limit);
        }
        else {
            obj.value = temp;
        }
        return false;
    }
    else {
        return true;
    }
}

function GLItemFill(obj, glType, changeFunction, vHeight, e) {
    evt = e || window.event;
    var qStr = obj.value;
    var keyCode = evt.which || evt.keyCode;
    var url;

    if (qStr != "" && keyCode != 229 && keyCode != 27) {
        url = "/asp/ajaxFunctions/ajax_account_payable.asp?mode=list&filter="
            + glType + "&qStr=" + qStr;

        FillOutJPED(obj, url, changeFunction, vHeight);
    }
}

function GLItemFillAll(objName, glType, changeFunction, vHeight) {
    var obj = document.getElementById(objName);
    var url = "/asp/ajaxFunctions/ajax_account_payable.asp?mode=list&filter="
        + glType + "&qStr=";

    if (obj.value == "") {
        FillOutJPED(obj, url, changeFunction, vHeight);
    }
    else {
        FillOutJPED(obj, url, changeFunction, vHeight);
        // GLItemFill(obj,glType,changeFunction,vHeight)
    }
}

function organizationFill(obj, oType, changeFunction, vHeight,e) {
    evt = e || window.event;
    var qStr = obj.value;
    var keyCode = evt.which || evt.keyCode;

    var url;

    if (qStr != "" && keyCode != 229 && keyCode != 27) {
        url = "/asp/ajaxFunctions/ajax_get_organization_xml.asp?oType="
            + oType + "&qStr=" + qStr;
        FillOutJPED(obj, url, changeFunction, vHeight);
    }
}

function organizationFillAll(objName, oType, changeFunction, vHeight) {
    var obj = document.getElementById(objName);
    var url = "/asp/ajaxFunctions/ajax_get_organization_xml.asp?qStr=&oType=" + oType;

    if (obj.value == "") {
        FillOutJPED(obj, url, changeFunction, vHeight);
    }
    else {
        FillOutJPED(obj, url, changeFunction, vHeight);
        // organizationFill(obj,oType,changeFunction,vHeight)
    }
}

function quickAddClient(acctFN, nameFN, infoFN) {
    
    var acctObj = document.getElementById(acctFN);
    var nameObj = document.getElementById(nameFN);
    var infoObj = document.getElementById(infoFN);

    var orgNum = acctObj.value;
    var popAddClient = showModalDialog("/ASP/Include/quickAddClient.asp?orgNum=" + orgNum,
        "AddClient", "dialogWidth:450px; dialogHeight:500px; help:0; status:1; scroll:0; center:1; Sunken;");
 
    if (popAddClient == undefined || popAddClient == "") {
        try {
            popAddClient = document.getElementById("quickAdd_output").value;

        } catch (e) {

        }
    }
    if (popAddClient != undefined && popAddClient != "") {
        while (popAddClient.indexOf("^^^") != -1) { popAddClient = popAddClient.replace('^^^', '\n'); }

        var startPos = popAddClient.indexOf("-");
        var startPos2 = popAddClient.indexOf("\n");
        var orgName = class_code_remove(popAddClient.substring(startPos + 1, startPos2));
        orgNum = popAddClient.substring(0, startPos);

        if (nameObj) { nameObj.value = orgName; }
        if (infoObj) { infoObj.value = orgName + "\n" + popAddClient.substring(startPos2 + 1); }
        if (acctObj) { acctObj.value = orgNum; }

    }
    return false;
}

function quickAddClientNew(acctFN, nameFN, infoFN, funcName) {
    var acctObj = document.getElementById(acctFN);
    var nameObj = document.getElementById(nameFN);
    var infoObj = document.getElementById(infoFN);

    var orgNum = acctObj.value;

    if (orgNum == "0" || orgNum == "") {
        alert("Please, select the company first!");
        return false;
    }

    var arrayResult = showModalDialog("/ASPX/Include/quickAddClientNew.aspx?orgID=" + orgNum,
        "EditClient", "dialogWidth:400px; dialogHeight:500px; help:0; status:1; scroll:0; center:1; Sunken;");

    if (arrayResult != undefined && arrayResult != null) {
        var functionText = funcName + "(" + arrayResult[0] + ",'" + arrayResult[1] + "')";
        setTimeout(functionText, 0);
    }
    return false;
}

function scrollToObj(arg) {
    try {
        if (arg != null && arg != "") {
            var obj = document.getElementById(arg);
            if (obj != null) {
                window.scrollTo(findPosX(obj), findPosY(obj));
            }
        }
    } catch (err) { }
}


function checkNum() {
    var ValidChars = "0123456789.-";

 
    if (ValidChars.indexOf(String.fromCharCode(event.keyCode)) == -1) {
        event.returnValue = false;
    }
    else {
        event.returnValue = true;
    }
}
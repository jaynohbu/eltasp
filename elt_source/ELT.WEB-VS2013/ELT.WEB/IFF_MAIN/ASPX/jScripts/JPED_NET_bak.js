
    var PageLimit = 100;
    var urlStr = "";
	// changed by Stanely
	var L_Item = new Array();
	var n = "";
	var s;
	L_Item[s] = "";

    
    function FillOutJPED(obj,url,fName,vHeight)
    {
  
        urlStr = url;
      
        var divObj = document.getElementById(obj.id+"Div");
        
        divObj.style.position = "absolute";
        divObj.innerHTML = "";
        
        if (event.keyCode == 13)
        {
       
            divObj.style.visibility = "hidden";
        }
        else
        {	
        
        // changed by Stanely
			s=1;
            new ajax.xhr.Request('GET','',url + "&limit=" + PageLimit,PopulateJPED,obj.id,fName,vHeight,'');
        }
    }
    
    function PopulateJPED(req,field,fName,tWidth,tMaxLength,url)
    {
    
        var divName = field + "Div";
        
       
        if (req.readyState == 1)
        {
            LoadJPED(divName,field,"");
            // MaskJPED(divName);
        }
        
        if (req.readyState == 4)
        {
	        if (req.status == 200)
	        {

	            DrawJPED(divName,field,req.responseXML,fName,tWidth);
                MaskJPED(divName);
	        }
	    }
	 }
	 
	 function LoadJPED(divName,fieldName,msg)
	 {
	
	    var divObj = document.getElementById(divName);
	    var fieldObj = document.getElementById(fieldName);
	    divObj.innerHTML = msg;

        divObj.style.posTop = findPosY(fieldObj);
        divObj.style.posLeft = findPosX(fieldObj);
        divObj.style.height = fieldObj.clientHeight + 2;
        divObj.style.width = fieldObj.clientWidth + 16;
        divObj.style.border = "1px solid #ababbb";
        divObj.style.background = "transparent";  
        // divObj.style.backgroundColor = "#efefff";
        divObj.style.overflowY = "hidden";
        divObj.style.visibility = "visible";
        fieldObj.focus();
	 }
	 
	 function DrawJPED(divName,fieldName,xmlObj,fName,vHeight)
	 {

		
	    if(vHeight == null || vHeight == "")
	    {
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
        divObj.style.posTop = findPosY(fieldObj) + fieldObj.clientHeight + 5;
        divObj.style.posLeft = findPosX(fieldObj);
        divObj.style.width = fieldObj.clientWidth + 16;
        divObj.style.border = "1px solid #999999";  
        divObj.style.backgroundColor = "efefef";

        // event handlers ///////////////////////////////////////////////////////////
        var tempVal ="";
        divObj.onmouseout = function() { fieldObj.focus(); };

        
        
	    innerHTML = "<table id=\"" + fieldName + "Table\" cellspacing=0 cellpadding=1 border=0 "
                + "bgcolor=\"#efefef\" width=100% height=100% class=bodycopy style=\"cursor:hand\">"
                + "<tr><td onmouseover=\"this.style.backgroundColor='#cdcddd';\" "
	            + "onmouseout=\"this.style.backgroundColor='transparent';\" "
				+ "onclick=\"" + fName + "('0','');\">&lt; RESET THIS FIELD &gt;</td></tr>";
				
// changed by Stanely

        if(s >= 2 )
        {
            innerHTML = innerHTML + "\n<tr><td onmouseover=\"this.style.backgroundColor='#cdcddd';\" "
	            + "onmouseout=\"this.style.backgroundColor='transparent';\" onclick=\"showPreviousGroupJPED('" 
                + fieldName + "','" + fName + "'," + vHeight + ",'" + L_Item[s] +"');\">&lt; SHOW PREVIOUS " 
                + " 100 ITEMS &gt;</td></tr>";
        }

// modified by Joon /////////////////////////////////////////

        try {
        
        if(labelObj[0].childNodes[0]!=null){
           n = class_code_remove( labelObj[0].childNodes[0].nodeValue)
        }
        
        var tmpVal,tmpLabel,tmpElements;
        var itemLength = itemObj.length;
        tmpElements = new Array(itemObj.length);

        if(itemLength > PageLimit)
        {
            itemLength = PageLimit;
        }
        
	    for(var i=0; i<itemLength; i++)
	    {
	        tmpVal = valueObj[i].childNodes[0].nodeValue;
	        tmpLabel = labelObj[i].childNodes[0].nodeValue;
	        tmpElements[i] = "<tr><td onmouseover=\"this.style.backgroundColor='#cdcddd';\" "
	            + "onmouseout=\"this.style.backgroundColor='transparent';\" "
	            + "onclick=\"" + fName + "('" + tmpVal + "','" + class_code_remove(tmpLabel) + "');\">" 
	            + tmpLabel + "</td></tr>";
        }

		innerHTML = innerHTML + tmpElements.join("\n");
        
        if(itemLength == PageLimit)
        {
            innerHTML = innerHTML + "\n<tr><td onmouseover=\"this.style.backgroundColor='#cdcddd';\" "
	            + "onmouseout=\"this.style.backgroundColor='transparent';\" onclick=\"showNextGroupJPED('" 
                + fieldName + "','" + fName + "'," + vHeight + ",'" + class_code_remove(tmpLabel) + "');\">&lt; SHOW NEXT " 
                + itemLength + " ITEMS &gt;</td></tr></table>";
        }
        
        else
        {
            innerHTML = innerHTML + "</table>";
        }

        } catch (err) {}
        
////////////////////////////////////////////////////////////////
        
        divObj.innerHTML = innerHTML;

        if(itemLength > 10)
        {
            divObj.style.height = vHeight;
            divObj.style.overflowY = "scroll";
        }
        else
        {
            divObj.style.height = document.getElementById(fieldName+"Table").clientHeight + 2;
            divObj.style.overflowY = "hidden";
        }

        divObj.style.visibility = "visible";
        fieldObj.focus();
     }
     function clear_S()
     {
		 s=1;
	 }
     
     function showNextGroupJPED(fieldName,fName,vHeight,vCompany)
     {

	 // changed by Stanely
        var tmpUrl = urlStr;
		s=s+1;
	    L_Item[s]=n;
        
        tmpUrl = tmpUrl + "&limit=" + PageLimit + "&cursor=" + vCompany;
        new ajax.xhr.Request('GET','',tmpUrl,PopulateJPED,fieldName,fName,vHeight,'');
     }
	 // changed by Stanely
	  function showPreviousGroupJPED(fieldName,fName,vHeight,LItem)
	  {
        var tmpUrl = urlStr;
        
        tmpUrl = tmpUrl + "&limit=" + PageLimit + "&cursor=" + LItem;
        new ajax.xhr.Request('GET','',tmpUrl,PopulateJPED,fieldName,fName,vHeight,'');
		s=s-1;

     }
     function MaskJPED(arg)
     {
        var listDivObj = document.getElementById(arg);
        var innerHTML = listDivObj.innerHTML;
        
        listDivObj.style.zIndex = 10;
        listDivObj.innerHTML = innerHTML + "<iframe id=\"" + arg + "Iframe\" ></iframe>";

        var iFrame = document.getElementById(arg + "Iframe");
        iFrame.style.position = "absolute";
        iFrame.style.posTop = -2;
        iFrame.style.posLeft = -2;
        iFrame.style.width = listDivObj.clientWidth + 20;
        iFrame.style.height = listDivObj.scrollHeight + 4;
        iFrame.style.zIndex = -1;
        iFrame.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(mask=1)';

        return false;
    }

    function CloseJPED(divObj)
    {            
        divObj.style.position = "absolute";

        var divWidth = divObj.clientWidth + 14;
        var divHieght = divObj.clientHeight + 20;
        var offX = window.event.offsetX;
        var offY = window.event.offsetY;
        
        if(offX == null){
            offX = 0;
        }
        if(offY == null){
            offY = 0;
        }
        if(offX < 0 || offY < 0 || offX > divWidth || offY > divHieght)
        {
            divObj.innerHTML = "";
            divObj.style.visibility = "hidden";
            return false;
        }
        return true;
    }
    
    function initializeJPEDField(obj)
    {
        var tmpVal = "";
        obj.onclick = function() { tmpVal = obj.value; obj.value = ""; };
        obj.onblur = function() { 
            var divObj = document.getElementById(obj.id+"Div");
            
            CloseJPED(divObj);
            
            if(tmpVal != "" && tmpVal != null){
                obj.value = tmpVal; 
            }
        };
    }
    
    function findPosX(obj)
    {
        var curleft = 0;
        if(obj.offsetParent){
            while(1){
                curleft += obj.offsetLeft;
                if(!obj.offsetParent) break;
                obj = obj.offsetParent;
            }
        }
        else if(obj.x){
            curleft += obj.x;
        }
        return curleft;
    }

    function findPosY(obj)
    {
        var curtop = 0;
        if(obj.offsetParent){
            while(1){
                curtop += obj.offsetTop;
                if(!obj.offsetParent) break;
                obj = obj.offsetParent;
            }
        }
        else if(obj.y){
            curtop += obj.y;
        }
        return curtop;
    }

    function class_code_remove(strArg)
    {
    
        var tempArray = new Array();
        tempArray = strArg.split("[");
    	        
        if(tempArray.length >= 2)
        {
            strArg = tempArray[0];
        }
        return strArg;
    }
    
    function checkDecimalTextMax(obj,limit)
    {
        if(obj.value.length >= limit){
            var temp = obj.value;
            var tempArray = new Array();
            tempArray = temp.split(".");
            temp = tempArray[0];
            if(temp.length >= limit){
                obj.value = temp.substring(0,limit);
            }
            else{
                obj.value = temp;
            }
            return false;
        }
        else
        {
            return true;
        }
    }
    
    function organizationFill(obj,oType,changeFunction,vHeight)
    {
        var qStr = obj.value;
        var keyCode = window.event.keyCode;
        var url;

        if(qStr != "" && keyCode != 229 && keyCode != 27)
        {
            url = "/ASP/ajaxFunctions/ajax_get_organization_xml.asp?oType=" 
                + oType + "&qStr=" + qStr;
               
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
    }
    
    function organizationFillAll(objName,oType,changeFunction,vHeight)
    {
    
        var obj = document.getElementById(objName);
        
        var url = "/ASP/ajaxFunctions/ajax_get_organization_xml.asp?qStr=&oType=" + oType; 
        FillOutJPED(obj,url,changeFunction,vHeight);
    }
    
    
    
    function quickAddClient(acctFN,nameFN,infoFN)
    {
        var acctObj = document.getElementById(acctFN);
        var nameObj = document.getElementById(nameFN);
        var infoObj = document.getElementById(infoFN);
        
        var orgNum = acctObj.value;
        var popAddClient = showModalDialog("/ASP/Include/quickAddClient.asp?orgNum=" + orgNum, "AddClient","dialogWidth:450px; dialogHeight:500px; help:0; status:1; scroll:0; center:1; Sunken;");
        
        if(popAddClient != undefined && popAddClient != "")
        {
            while(popAddClient.indexOf("^^^") != -1) { popAddClient = popAddClient.replace('^^^','\n');	}	
            
            var startPos = popAddClient.indexOf("-");
            var startPos2 = popAddClient.indexOf("\n");
            var orgName = class_code_remove(popAddClient.substring(startPos+1,startPos2));
            
            if(nameObj) { nameObj.value = orgName; }
            if(infoObj) { infoObj.value = orgName + "\n" + popAddClient.substring(startPos2+1); }
            
        }
        return false;
    }
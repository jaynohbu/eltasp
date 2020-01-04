
    function jPopUpNormal(){
        var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
        popUpWindow = window.open('','popUpWindow', argS);
    }

    function jPopUpNormalforSED(){
        var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
        popUpSED = window.open('','popUpSED', argS);
    }

    function jPopUpPDF(){
        var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
        popUpPDF = window.open('','popUpPDF', argS);
        return popUpPDF;
    }

    function jPopUpPDFAuth(){
        var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
        popUpPDF = window.open('','popUpPDFAuth', argS);
    }

    function jPopUp(sHeight){
        var argS = 'height=' + sHeight + ',width=500,hotkeys=0,scrollbars=1,resizable=1';
        if (document.layers) {
            var sinist = screen.width / 2 - outerWidth / 2;
            var toppo = screen.height / 2 - outerHeight / 2;
        } 
        else {
            var sinist = screen.width / 2 - document.body.offsetWidth / 2;
            var toppo = -75 + screen.height / 2 - document.body.offsetHeight / 2;
        }
        popUpWindow = window.open('','popUpWindow', argS);
    }

    function viewPop(Url) {
        
	    if ( Url.indexOf("pdf") >= 0 || Url.indexOf("agent_stmt.asp") >= 0 )
	    {
		    if(document.form1) {
			    jPopUpPDF();
			    document.form1.action = encodeURI(Url) + '&WindowName=popUpPDF';
			    document.form1.method = "POST";
			    document.form1.target = "popUpPDF"
			    document.form1.submit();
		    }
	    }
	    else
	    {
		    var strJavaPop = "";
		    strJavaPop = window.open(Url,'popupNew','staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=900,height=600,hotkeys=0');
		    strJavaPop.focus();
	    }
    }

    function viewPop2(WinName,Url) {
        var strJavaPop = "";
        window.open(Url,WinName,'staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=800,height=600,hotkeys=0');
    }

    function viewPop3(WinName,Url) {
        var strJavaPop = "";
        window.open(Url,WinName,'staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=1,resizable=1,location=0,width=800,height=600,hotkeys=0');
    }


    ////
    function CHECK_INVOICE_STATUS_AJAX(dType,s)
    { 
	    try
	    {
		    var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP") 
		    var param = 'dType=' + encodeURIComponent(dType) + '&n=' + encodeURIComponent(s) 
		        + '&e=' + '80002000';
		    xmlHTTP.open("get","/ASP/include/check_invoice_status.asp?" + param ,false); 
    		
		    xmlHTTP.send(); 
		    var sourceCode = xmlHTTP.responseText;

		    if (sourceCode) 
		    {
			    if (dType == 'MAWB')
			    {
			    alert ('Invoice No. ' + sourceCode + ' for MAWB#:' + s + ' was processed already.' + '\nPlease save the MAWB information on MAWB screen later.');
			    }

			    if (dType == 'Booking')
			    {
			    alert ('Invoice No. ' + sourceCode + ' for Booking#:' + s + ' was processed already.' + '\nPlease save the MBOL information on MBOL screen later.');
			    }
		    }
	    }	
	    catch(e) {}

    }

    function CHECK_ORGANIZATION_AJAX(s)
    { 
        var os = s
	        try
	        {
		        var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP") 
		        while(s.indexOf("&") != -1) { s = s.replace('&','________');	}	
		        while(s.indexOf("'") != -1) { s = s.replace("'","^^^^^^^^");	}	

		        var param = 'n=' + encodeURIComponent(s) + '&e=' + '80002000';
		        xmlHTTP.open("get","/ASP/include/check_organization.asp?" + param ,false); 
        		
		        xmlHTTP.send(); 
		        var sourceCode = xmlHTTP.responseText;

		        if (sourceCode) 
		        {
			        alert ("The client [" + os + "] already exists in your client master.");
			        return false;
		        }
		        else
		        {
			        return true;
		        }
	        }	
	        catch(e) {}

        return true;

    }

    function setChangeFlag(){
	    try
	    {
		    document.all.FlagChanged.value = true;
	    }	
	    catch(e) {}
    }

    function showJPModal(targetURL, sourceURL, vWidth, vHeight, vWindow){
        // parent window
        var returnVal = null;
        if (window.name == "" && window.opener == null){
            returnVal = showModalDialog(targetURL + "&WindowName=" + vWindow, "", 
                "dialogWidth:" + vWidth + "px; dialogHeight:" + vHeight + 
                "px; help:0; status:1; scroll:1; center:1; resizable:1;");

            // after modal closed with return value

            if(returnVal){
                // option 1 - close modal redirect parent to target URL
                // option 2 - close modal open new modal with target URL
                return showJPModal(returnVal, sourceURL, vWidth, vHeight, vWindow);
            }
            // after modal closed without return value
            else{
                if(sourceURL != ""){
                    window.location.href = sourceURL;
                }
                else{
                    return false;
                }
            }
        }
        // opened by window open
        else if(window.opener != null){
            window.location.href = targetURL;
        }
        // opened by showmodal
        else{
            window.returnValue = targetURL;
            window.close();
        }
        return true;
    }
    
    window.name="";
    
    function fixProgressBar()
    {
	    if(parent.frames['dummyFrame'])
	    {
		    parent.frames['dummyFrame'].document.write("");
		    parent.frames['dummyFrame'].document.close();
	    }    
    }

    function saveScrollPosition() {
        if (document.all.scrollPositionX) {
            document.all.scrollPositionX.value = window.document.body.scrollLeft;
        }
        if (document.all.scrollPositionY) {
            document.all.scrollPositionY.value = window.document.body.scrollTop;
        }
    }

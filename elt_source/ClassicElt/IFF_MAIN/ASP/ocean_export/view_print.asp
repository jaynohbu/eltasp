<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<% 
    Dim iMoonDefaultValue,iMoonComboBoxName,iMoonComboBoxWidth,i
    Dim hbol,booking,sType,search_num
    
    hbol = checkBlank(Request.QueryString.Item("hbol"),"")
    booking = checkBlank(Request.QueryString.Item("booking"),"")
    
    search_num = checkBlank(hbol,booking)
    sType = checkBlank(Request.QueryString.Item("sType"),"")
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Print Bill</title>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript"> 
    
    function loadValue()
    {
        var typeValue = "<%=sType %>";

        if(typeValue == "house")
        {
            document.getElementById("dotButton").style.visibility = "visible";
            document.getElementById("dotButton").style.width = "40px";
            document.getElementById("manifestButton").style.visibility = "hidden";
            document.getElementById("manifestButton").style.width = "0px";
            document.getElementById("lstSearchType").value = "house";
        }
        else if(typeValue == "booking")
        {
            document.getElementById("dotButton").style.visibility = "hidden";
            document.getElementById("dotButton").style.width = "0px";
            document.getElementById("manifestButton").style.visibility = "visible";
            document.getElementById("manifestButton").style.width = "80px";
            document.getElementById("lstSearchType").value = "booking";
        }
        else
        {
            document.getElementById("dotButton").style.visibility = "hidden";
            document.getElementById("dotButton").style.width = "0px";
            document.getElementById("manifestButton").style.visibility = "hidden";
            document.getElementById("manifestButton").style.width = "80px";
        }
        document.getElementById("txtSearchNum").value = "<%=search_num %>";
        findBillPDF(false);
    }

    function printWindowM() {
        try{
		    document.frames['fPrintFrame'].printWindow();
		    //document.frames['fPrintFrame'].resetDefault();
		}catch(error)
		{
		    try{
		        var iEmbed = document.getElementById("fPrintEmbed");
                iEmbed.click();
                iEmbed.setActive();
                iEmbed.focus();
                iEmbed.print();
            }catch(error){}
		}
    }
    function pageSetupM() {
        document.frames['fPrintFrame'].pageSetup();
    }
	
    function findBillPDF(arg)
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        var url = "";
        
        if(searchType == "booking" && searchNum != "")
        {
            url = "bol_instruction.asp?BookingNum=" + encodeURIComponent(searchNum);

        }
        else if(searchType == "house" && searchNum != "")
        {
            if(arg)
            {
                var returnVal = window.showModalDialog("PDF_print_prompt.asp", "", "dialogHeight:170px;dialogWidth:350px")
	            if(returnVal != null)
	            {
                    url = "hbol_pdf.asp?hbol=" + encodeURIComponent(searchNum) + "&Copy=" + returnVal;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                url = "hbol_pdf.asp?hbol=" + encodeURIComponent(searchNum);
            }
        }
        else
        {
            alert("Please, select the options before viewing.");
            return false;
        }
        
        var iDiv = document.getElementById("fPrintDiv");
        iDiv.innerHTML = "<embed id='fPrintEmbed' src='" + url + "' height=95% width=100%></embed>";
        //document.getElementById("btnSetup").style.visibility = "hidden";
        document.getElementById("btnPrint").style.visibility = "visible";
        document.getElementById("dotButton").style.backgroundColor = "";
        document.getElementById("pdfButton").style.backgroundColor = "#ccccff";
        document.getElementById("manifestButton").style.backgroundColor = "";
    }
    
    function findBillDot()
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        var url = "";
        
        if(searchType == "house")
        {
            url = "print_dot_hbol.asp?hbol=" + encodeURIComponent(searchNum);
            var iDiv = document.getElementById("fPrintDiv");
            iDiv.innerHTML = "<iframe id='fPrintFrame' allowtransparency='true' frameborder='no' height=95% width=100% scrolling='yes' src='" + url + "' style='padding-right: 0px; padding-left: 0px; padding-bottom: 0px; margin: 0px; padding-top: 0px' ></iframe>";
            //document.getElementById("btnSetup").style.visibility = "visible";
            document.getElementById("btnPrint").style.visibility = "visible";
            
            document.getElementById("dotButton").style.backgroundColor = "#ccccff";
            document.getElementById("pdfButton").style.backgroundColor = "";
            document.getElementById("manifestButton").style.backgroundColor = "";
        }
    }
    
    function findBillManifest()
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        var url = "";
        
        document.getElementById("btnPrint").style.visibility = "visible";
        //document.getElementById("btnSetup").style.visibility = "hidden";
        if(searchType == "booking" && searchNum != "")
        {
            var returnVal = window.showModalDialog("manifest_print_prompt.asp?booking=" 
                + encodeURIComponent(searchNum), "", "dialogHeight:160px;dialogWidth:350px")
	        if(returnVal != null)
	        {
	            url = "manifest_pdf.asp?" + returnVal;
	            var iDiv = document.getElementById("fPrintDiv");
	            iDiv.innerHTML = "<embed id='fPrintEmbed' src='" + url + "' height=95% width=100%></embed>";
	            
                document.getElementById("dotButton").style.backgroundColor = "";
                document.getElementById("pdfButton").style.backgroundColor = "";
                document.getElementById("manifestButton").style.backgroundColor = "#ccccff";
	        }
        }
        else
        {
            alert("Please, select the options before viewing.");
            return false;
        }  
    }
    
    function setBackground()
    {
	    var iframObj = document.getElementById("fPrintFrame");
	    // iframObj.style.backgroundImage = "../Images/dotmatrix_back.gif";
    }
    
    function findBillSED()
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        
        var url = "";
        // var iFrame = document.getElementById("fPrintFrame");
        
        if(searchType == "booking" && searchNum != "")
        {
            url = "sed.asp?EditSED=yes&tBooking=" + encodeURIComponent(searchNum) + "&WindowName=popupNew"
        }
        else if(searchType == "house" && encodeURIComponent(searchNum) != "")
        {
            url = "sed.asp?hbol=" + searchNum + "&WindowName=popupNew"
        }
        else
        {
            alert("Please, select the copy to print.");
            return false;
        }
        
        var props = "scrollBars=yes,resizable=yes,toolbar=no,menubar=yes,location=no,directories=no,status=yes,width=960,height=650"
        window.open(url, "popUpWindow", props)
        
        document.getElementById("manifestButton").style.backgroundColor = "#ccccff";
        document.getElementById("pdfButton").style.backgroundColor = "#ccccff";
        document.getElementById("dotButton").style.backgroundColor = "#ccccff";
    }
    
    </script>

</head>
<body onLoad="javascript:setBackground(); loadValue();" bgcolor="#e0e0e0">
    <form name="form1">
        <table class="bodycopy" style="width: 100%; height: 35px;" cellspacing="0" cellpadding="0"
            border="0">
            <tr>
                <td>
                    <table class="bodycopy" cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                                <strong>Bill Type: </strong>&nbsp;</td>
                            <td>
                                <select id="lstSearchType" class="bodyheader" style="width: 90px" disabled="disabled">
                                    <option value="">Select One</option>
                                    <option value="house">House B/L</option>
                                    <option value="booking">Booking No.</option>
                                </select>
                            </td>
                            <td style="width: 10px">
                            </td>
                            <td>
                                <strong>Bill Number: </strong>&nbsp;</td>
                            <td>
                                <input type="text" id="txtSearchNum" value="" class="bodyheader" size="20" disabled="disabled" /></td>

                            <td style="width: 10px">
                            </td>
                            <td>
                                <strong>Copy: </strong>&nbsp;</td>
                            <td>
                                
                            </td>
                            <td style="width: 10px">
                            </td>
                            <td>
                                <input type="button" id="pdfButton" value="PDF" onClick="findBillPDF(true);" class="bodycopy" style="width:40px" /></td>
                            <td style="width:5px"></td>
                            <td>
                                <input type="button" id="manifestButton" value="Manifest PDF" onClick="findBillManifest();" class="bodycopy" style="width:40px; visibility:hidden" />
                                <input type="button" id="dotButton" value="Dot" onClick="findBillDot();" class="bodycopy" style="width:40px; visibility:hidden" /></td>
                            <td style="width:5px"></td>
                            <td>
                                <input type="button" id="btnSED" value="SED" onclick="findBillSED();" class="bodycopy" style="width:40px; visibility:hidden" /></td>
                            <td style="width:5px"></td>
                        </tr>
                    </table>
                </td>
                <td align="right">
                    <table cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                                <input type="button" id="btnSetup" value="Setup" class="bodycopy" style="visibility:hidden; width:40px" onClick="pageSetupM();" /></td>
                            <td style="width:5px"></td>
                            <td>
                                <input type="button" id="btnPrint" value="Print" class="bodycopy" style="visibility:hidden; width:40px" onClick="printWindowM();" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <div id="fPrintDiv">
        </div>
    </form>
</body>
</html>

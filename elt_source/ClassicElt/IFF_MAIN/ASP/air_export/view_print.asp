<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<% 
    Dim iMoonDefaultValue,iMoonComboBoxName,iMoonComboBoxWidth,i
    Dim hawb,mawb,sType,search_num,colo
    
    hawb = checkBlank(Request.QueryString.Item("hawb"),"")
    mawb = checkBlank(Request.QueryString.Item("mawb"),"")
    colo = checkBlank(Request.QueryString.Item("COLODee"),"")
    search_num = checkBlank(hawb,mawb)
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
       
        if(typeValue == "master")
        {
            document.getElementById("btnManifest").style.visibility = "visible";
            document.getElementById("btnIAC").style.visibility = "visible";
            document.getElementById("btnRider").style.visibility = "hidden";
            document.getElementById("btnRider").style.width= "0px";
        }
        if(typeValue == "house")
        {
            document.getElementById("btnManifest").style.visibility = "hidden";
            document.getElementById("btnManifest").style.width= "0px";
            document.getElementById("btnIAC").style.visibility = "hidden";
            document.getElementById("btnIAC").style.width= "0px";
            document.getElementById("btnRider").style.visibility = "visible";
        }
        
        document.getElementById("lstSearchType").value = typeValue;
        document.getElementById("txtSearchNum").value = "<%=search_num %>";
        findBillPDF();
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
    
    function findBillPDF()
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        var printCopy = "SHIPPER";
        var url = "";
        // var iFrame = document.getElementById("fPrint");

        if(searchType == "master" && searchNum != "" && printCopy != "")
        {
            url = "mawb_pdf.asp?MAWB=" + encodeURIComponent(searchNum) + "&Copy=" + printCopy;
        }
        else if(searchType == "house" && searchNum != "" && printCopy != "")
        {
            url = "hawb_pdf.asp?HAWB=" + encodeURIComponent(searchNum) + "&Copy=" + printCopy;
        }
        else
        {
            alert("Please, select the copy to print.");
            return false;
        }

        var iDiv = document.getElementById("fPrintDiv");
        iDiv.innerHTML = "<Embed id='fPrintEmbed' src='" + url + "' height=95% width=100%></Embed>";
        //iDiv.innerHTML = "<p>Alternative text - include a link <a href=\"" + url + "\">to the PDF!</a></p>";
        document.getElementById("btnManifest").style.backgroundColor = "";
        document.getElementById("btnPDF").style.backgroundColor = "#ccccff";
        //document.getElementById("btnDot").style.backgroundColor = "";
        document.getElementById("btnIAC").style.backgroundColor = "";
        document.getElementById("btnRider").style.backgroundColor = "";
    }
    
    function findBillDot()
    {
    
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        var url = "";
        
        if(searchNum != "")
        {
            var returnVal = window.showModalDialog("PDF_print_prompt.asp?master=" 
                + encodeURIComponent(searchNum) + "&Billtype=DOT &HMtype=" + searchType ,"","dialogHeight:170px;dialogWidth:350px")
	        if(returnVal != null)
	        {
	            if(searchType == "master")
                {
	                url = "print_dot_mawb.asp?" + returnVal;
	            }
	            else if(searchType == "house")
	            {
	                url = "print_dot_hawb.asp?" + returnVal;
	            }
	            else
	            {
	                alert("Please, select the copy to print.");
	            }
	            //iFrame.src = url;
                var iDiv = document.getElementById("fPrintDiv");
                iDiv.innerHTML = "<iframe id='fPrintFrame' allowtransparency='true' frameborder='no' height=95% width=100% scrolling='yes' src='" + url + "' style='padding-right: 0px; padding-left: 0px; padding-bottom: 0px; margin: 0px; padding-top: 0px' ></iframe>";
	            
                document.getElementById("btnManifest").style.backgroundColor = "";
                document.getElementById("btnPDF").style.backgroundColor = "";
                document.getElementById("btnDot").style.backgroundColor = "#ccccff";
                document.getElementById("btnIAC").style.backgroundColor = "";
                document.getElementById("btnRider").style.backgroundColor = "";
	        }
        }
        else
        {
            alert("Please, select the copy to print.");
        }
        
    }

    
    function findBillManifest()
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        var url = "";
        //var iFrame = document.getElementById("fPrint");
        
        //document.getElementById("btnSetup").style.visibility = "hidden";
        //document.getElementById("btnPrint").style.visibility = "hidden";
        
        if(searchType == "master" && searchNum != "")
        {
            var returnVal = window.showModalDialog("manifest_print_prompt.asp?master=" + encodeURIComponent(searchNum),"","dialogHeight:170px;dialogWidth:350px")
	        if(returnVal != null)
	        {
	            url = "manifest_pdf.asp?" + returnVal;
	            //iFrame.src = url;
                var iDiv = document.getElementById("fPrintDiv");
                iDiv.innerHTML = "<embed id='fPrintEmbed' src='" + url + "' height=95% width=100%></embed>";
	            //iDiv.innerHTML = "<p>Alternative text - include a link <a href=\"" + url + "\">to the PDF!</a></p>";
                document.getElementById("btnManifest").style.backgroundColor = "#ccccff";
                document.getElementById("btnPDF").style.backgroundColor = "";
                //document.getElementById("btnDot").style.backgroundColor = "";
                document.getElementById("btnIAC").style.backgroundColor = "";
                document.getElementById("btnRider").style.backgroundColor = "";
	        }
        }
        else
        {
            alert("Please, select the copy to print.");
        }
    }
    
    
    function findBillPDF2()
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        var url = "";
        
        if(searchNum != "")
        {
            var returnVal = window.showModalDialog("PDF_print_prompt.asp?master=" 
                + encodeURIComponent(searchNum)+ "&Billtype=PDF&HMtype=" 
                + searchType,"","dialogHeight:170px;dialogWidth:350px")
	        if(returnVal != null)
	        {
	            if(searchType == "master")
                {
	                url = "mawb_pdf.asp?" + returnVal;
	            }
	            else if(searchType == "house")
	            {
	                url = "hawb_pdf.asp?" + returnVal;
	            }
	            else
	            {
	                alert("Please, select the copy to print.");
	            }

                var iDiv = document.getElementById("fPrintDiv");
                iDiv.innerHTML = "<embed id='fPrintEmbed' src='" + url + "' height=95% width=100%></embed>";
	            //iDiv.innerHTML = "<p>Alternative text - include a link <a href=\"" + url + "\">to the PDF!</a></p>";
                document.getElementById("btnManifest").style.backgroundColor = "";
                document.getElementById("btnPDF").style.backgroundColor = "#ccccff";
                //document.getElementById("btnDot").style.backgroundColor = "";
                document.getElementById("btnIAC").style.backgroundColor = "";
                document.getElementById("btnRider").style.backgroundColor = "";
	        }
        }
        else
        {
            alert("Please, select the copy to print.");
        }
    }
    
   function findBillIAC()
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;

        var url = "";
        //var iFrame = document.getElementById("fPrint");
        
        if(searchType == "master" && searchNum != "")
        {
			var returnVal = window.showModalDialog("IAC_Choose2.asp?master=" + encodeURIComponent(searchNum),"","dialogHeight:170px;dialogWidth:350px")

	        if(returnVal == "K" )
	        {

			url = "iac_pdf.asp?MAWB=" + searchNum;
            //iFrame.src = url;
            //document.getElementById("btnPrint").style.visibility = "hidden"; 
            var iDiv = document.getElementById("fPrintDiv");
            iDiv.innerHTML = "<embed id='fPrintEmbed' src='" + url + "' height=95% width=100%></embed>";
	            //iDiv.innerHTML = "<p>Alternative text - include a link <a href=\"" + url + "\">to the PDF!</a></p>";
            document.getElementById("btnManifest").style.backgroundColor = "";
            document.getElementById("btnPDF").style.backgroundColor = "";
            //document.getElementById("btnDot").style.backgroundColor = "";
            document.getElementById("btnIAC").style.backgroundColor = "#ccccff";
            document.getElementById("btnRider").style.backgroundColor = "";
			}
			if(returnVal == "U" )
	        {
            url = "iac_unknow_pdf.asp?MAWB=" + searchNum;
            //iFrame.src = url;
            //document.getElementById("btnPrint").style.visibility = "hidden"; 
            var iDiv = document.getElementById("fPrintDiv");
            iDiv.innerHTML = "<embed id='fPrintEmbed' src='" + url + "' height=95% width=100%></embed>";
			    //iDiv.innerHTML = "<p>Alternative text - include a link <a href=\"" + url + "\">to the PDF!</a></p>";
            document.getElementById("btnManifest").style.backgroundColor = "";
            document.getElementById("btnPDF").style.backgroundColor = "";
           // document.getElementById("btnDot").style.backgroundColor = "";
            document.getElementById("btnIAC").style.backgroundColor = "#ccccff";
            document.getElementById("btnRider").style.backgroundColor = "";
			}

        }
		
        else
        {
            alert("Please, select the copy to print.");
            return false;
        }
    }
    
    function findBillRider()
    {
        var searchType = document.getElementById("lstSearchType").value;
        var searchNum = document.getElementById("txtSearchNum").value;
        var url = "";
        // var iFrame = document.getElementById("fPrint");
        
        if(searchType == "house" && searchNum != "" )
        {
            url = "print_rider.asp?vMaster=" + encodeURIComponent(searchNum) + "&WindowName=popupNew";
            var iDiv = document.getElementById("fPrintDiv");
            iDiv.innerHTML = "<embed id='fPrintEmbed' src='" + url + "' height=95% width=100%></embed>";
            //iDiv.innerHTML = "<p>Alternative text - include a link <a href=\"" + url + "\">to the PDF!</a></p>";
        }
        
        document.getElementById("btnManifest").style.backgroundColor = "";
        document.getElementById("btnPDF").style.backgroundColor = "";
      //  document.getElementById("btnDot").style.backgroundColor = "";
        document.getElementById("btnIAC").style.backgroundColor = "";
        document.getElementById("btnRider").style.backgroundColor = "#ccccff";
    }
    
    function setBackground()
    {
	    var iframObj = document.getElementById("fPrint");
	    // iframObj.style.backgroundImage = "../Images/dotmatrix_back.gif";
    }
    
    </script>

</head>
<body onLoad="javascript:setBackground(); loadValue();" bgcolor="#e0e0e0">
    <form name="form1" action="" >
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
                                    <option value="house">House awb</option>
                                    <option value="master">Master awb</option>
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
                            
                            <td style="width: 10px">
                            </td>
                            <td>
                                <input type="button" id="btnPDF" value="PDF" onClick="findBillPDF2();" class="bodycopy" style="width:40px" /></td>
                            <td style="width:5px"></td>
                            <td>
                                <input type="button" id="btnDOT" value="Dot" onClick="findBillDot();" class="bodycopy" style="width:40px" /></td>
                            <td style="width:5px"></td>
                            <td>
                                <input type="button" id="btnRider" value="Rider" onClick="findBillRider();" class="bodycopy" style="width:40px; visibility:hidden" /></td>
                                
                            <td style="width:5px"></td>
                            <td>
                                <input type="button" id="btnManifest" value="Manifest" onClick="findBillManifest();" class="bodycopy" style="width:60px; visibility:hidden" /></td>
                            <td style="width:5px"></td>
                            <td>
                                <input type="button" id="btnIAC" value="IAC" onClick="findBillIAC();" class="bodycopy" style="width:40px; visibility:hidden" /></td>
                        </tr>
                    </table>
                </td>
                <td align="right">
                    <table cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td></td>
                            <td></td>
                            <td style="width:5px"></td>
                            <td>
                                <input type="button" id="btnPrint" value="Print" class="bodycopy" style="width:40px" onClick="printWindowM();" /></td>
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

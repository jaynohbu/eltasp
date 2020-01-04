<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->

<%

    Dim vHAWB,isHouseMade,vMode
    
    isHouseMade = False
    vHAWB = checkBlank(Request.Form.Item("txtHAWB"),"")
    vMode = checkBlank(Request.QueryString("mode"),"new")
    
    If vMode = "save" Then
        Call update_hawb_master()
    End If

    Sub update_hawb_master
        Dim SQL,rs
        
        Set rs = Server.CreateObject("ADODB.RecordSet")
        
        SQL= "select * from hawb_master where elt_account_number = " & elt_account_number & " and is_dome='Y' and HAWB_NUM='" & vHAWB & "'"
        
        If isDataExist(SQL) Then
            vHAWB = ""
            Exit Sub
        End If
        
        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    If rs.EOF=true Then		
		    rs.AddNew
		    rs("elt_account_number") = elt_account_number
		    rs("HAWB_NUM") = vHAWB
		    rs("agent_name") = ""
		    rs("agent_no") = "0"
		    rs("agent_info") = ""
		    rs("DEP_AIRPORT_CODE") = ""
		    rs("airline_vendor_num")=0
		    rs("Shipper_Name") = ""
		    rs("Shipper_Info") = ""
		    rs("Shipper_Account_Number") = ""
		    rs("ff_shipper_acct") = ""
		    rs("Consignee_Name") = ""
		    rs("Consignee_Info") = ""
		    rs("Consignee_acct_num") = ""
		    rs("ff_consignee_acct") = ""
		    rs("Issue_Carrier_Agent") = ""
		    rs("Agent_IATA_Code") = ""
		    rs("Account_No") = ""
		    rs("Departure_Airport") = ""
		    rs("departure_state")=""
		    rs("To_1") = ""
		    rs("By_1") = ""
		    rs("To_2") = ""
		    rs("By_2") = ""
		    rs("To_3") = ""
		    rs("By_3") = ""
		    rs("Dest_Airport") = ""
		    rs("Flight_Date_1") = ""
		    rs("Flight_Date_2") = ""
		    rs("export_date")=0
		    rs("IssuedBy")=""
		    rs("Account_Info") = ""
		    rs("Notify_No") = ""
		    rs("Currency") = ""
		    rs("Charge_Code") = ""
		    rs("PPO_1") = ""
		    rs("COLL_1") = ""
		    rs("PPO_2") = ""
		    rs("COLL_2") = ""
		    rs("Declared_Value_Carriage") = ""
		    rs("Declared_Value_Customs")= ""
		    rs("Insurance_AMT")=""
		    rs("Handling_Info")=""
		    rs("dest_country")=""
		    rs("SCI")=""
		    rs("total_pieces")=0
		    rs("total_gross_weight")=0
		    rs("total_chargeable_weight")=0
		    rs("total_weight_charge_hawb")=0
		    rs("af_cost")=0
		    rs("agent_profit")=0
		    rs("agent_profit_share")=0
		    rs("adjusted_weight")=0
		    rs("desc1")=""
		    rs("desc2")=""
		    rs("manifest_desc")=""
		    rs("lc")=""
		    rs("ci")=""
		    rs("other_ref")=""
		    rs("Date_Last_Modified")=Now

		    rs("Execution")=""
		    rs("colo")=""
		    rs("colo_pay")=""
		    rs("coloder_elt_acct")=0

		    rs("Agent_Info")= "Auto Generated No."
		    rs("date_executed")=Now
		    rs("prepaid_invoiced")="N"
		    rs("collect_invoiced")="N"
    		
		    '----------------------------------------------------------------
		     rs("CreatedBy")=session_user_lname	
		     rs("CreatedDate")=Now
		     rs("SalesPerson")=	vSalesPerson			
		    '----------------------------------------------------------------	
    		
		    rs("is_master_closed")="N"		
            rs("is_invoice_queued")="N"
            rs("is_dome")="Y"
            rs.update()
            isHouseMade = True
        End If
        
    End Sub
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Manual HAWB Number</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">
    <script type="text/javascript">
        function makeNewHAWB(){
            if(document.getElementById("txtHAWB").value != ""){
                document.modalForm.action = "hawb_numbering_manual.asp?mode=save";
                document.modalForm.method = "POST";
                document.modalForm.target = "manual_house_modal";
                document.modalForm.submit();
            }
        }
        
        function returnHAWB(){
            document.getElementById("txtHAWB").value = "<%=vHAWB %>";
            if(document.getElementById("txtHAWB").value != ""){
                window.returnValue = document.getElementById("txtHAWB").value;
                window.close();
            }
        }
    
    </script>
</head>
<body onload="window.name='manual_house_modal'; returnHAWB();">
    <br />
    <center>
        <form method="post" name="modalForm">
            <table class="bodycopy" cellspacing="0" cellpadding="0" border="0">
                <tr>
                    <td class="bodyheader">
                        HAWB No.</td>
                    <td width="8">
                    </td>
                    <td>
                        <input type="text" id="txtHAWB" name="txtHAWB" class="m_shorttextfield" />
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div id="resultDiv" class="bodycopy" style="width:200px">
                        <% If vMode="save" And Not isHouseMade Then%>
                            The HAWB couldn't be created. <br />Please, re-enter a new HAWB No.
                        <% Elseif vMode="new" Then %>
                            Please, enter a new HAWB No.
                        <% End If %>
                        </div>
                    </td>
                </tr>
            </table>
            <P align="center">
                <input name="OK" type="button" id="OK" value="OK" onClick="makeNewHAWB()" style="width: 70px">
                <input name="Cancel" type="button" id="Cancel" value="Cancel" onClick="window.close();"
                    style="width: 70px">
            </P>
        </form>
    </center>
</body>
</html>

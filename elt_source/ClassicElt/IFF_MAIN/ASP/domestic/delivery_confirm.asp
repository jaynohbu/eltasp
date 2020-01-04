<%@ LANGUAGE = VBScript %>
<html>
<head>
<title>Shipping Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

<!-- /Start of Combobox/ -->
<script type="text/javascript" language="javascript" src="../ajaxFunctions/ajax.js"></script>
<script type="text/javascript" src="../include/JPED.js"></script>
<script type="text/javascript">
<!-- 
// var ComboBoxes =  new Array('list1','list2','list3',.....);
var ComboBoxes =  new Array('lstMAWB','lstHAWB');
// -->

   function cleartext()
   {
         document.getElementById("lstSearchNum").value = "";
         document.getElementById("lstMAWB").value = "";
   }

    function selectSearchType(argV,argL)
    {
         var divObj = document.getElementById("lstSearchNumDiv");
        
        //document.getElementById("isDocBeingSubmitted").value = false;
        //document.getElementById("isDocBeingModified").value = 0;

        var typeIndex = document.getElementById("lstSearchType").selectedIndex;
        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
        
        document.getElementById("lstSearchNum").value = argL;
        document.getElementById("hSearchNum").value = argV;
        
        var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_domestic_delivery_confirmation.asp?mode=view&type=" + typeValue
            + "&export=A&no=" + argV;
        //new ajax.xhr.Request('GET','',url,displayScreen,'','','','');
        //resetWeight(0);
        //resetMeasure(0);
        
        divObj.style.visibility = "hidden";
        divObj.style.position = "absolute";
	    divObj.innerHTML = "";

        //lstSearchNumChange(-1,'');
        if(typeValue=="master")
        {
           
            MAWBChange();
        }
        else if(typeValue=="house")
        {
             
            HAWBChange();
        }
        else
        {
            lookupFile();
        }
        
    }
      function docModified(arg) {

            var isDocBeingModified = document.getElementById("isDocBeingModified");
            isDocBeingModified.value = parseInt(isDocBeingModified.value) + parseInt(arg);
        }
        
     function SEARCHByMAWB(MAWB)
     {
        
        MAWBChange2();
        //url ="delivery_confirm.asp?Edit=yes&rMAWB="+ MAWB ;
        //window.open(url);
     }
     function SEARCHByHAWB(HAWB)
     {
        url ="delivery_confirm.asp?Edit=yes" ;
        window.open(url);
     }

        
     function searchNumFill(obj,eType,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/IFF_MAIN/asp/ajaxFunctions/ajax_domestic_delivery_confirmation.asp?mode=list&export=" + eType 
                    + "&qStr=" + qStr + "&type=" + typeValue;

                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
         function searchNumFillAll(objName,eType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
            var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_domestic_delivery_confirmation.asp?mode=list&type=" + typeValue 
                + "&export=" + eType;

            FillOutJPED(obj,url,changeFunction,vHeight);
        }
</script>
<script language='JScript' src='../Include/iMoonCombo.js'></script>
<!-- /End of Combobox/ -->
<style type="text/css">
<!--
.style1 {color: #663366}
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.goto a:link, a:visited {
	color: #336699;
}
a:hover {
	color: #CC3300;
}
a:link {
	color: #336699;
}
-->
</style>
</head>

<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/MakeAgentPreAlertPDFFile.asp" -->
<!--  #INCLUDE FILE="../include/clsUpload.asp"-->
<!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_data_manager.inc" -->

<!--  added by Joon On Dec-8-2006 -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%
Dim aMAWB(2000),aAgentName(32),aAgentNo(32),aAgentEmail(32),aAgentCheck(32),aAgentCC(32),aAgentMSG(32)
Dim aHAWB(32,64),aHAWBCheck(32,64),aInvoice(32),aManifest(32),aHAWBIndex(32),aInvoiceAmt(32),aInvoiceCheck(32),aManifestCheck(32)
Dim aStmtCheck(32)
Dim aOnlineAlertCheck(32),aAgentELTAcct(32)
Dim aShipper(32,64),aConsignee(32,64)
Dim aShipperName(32),aShipperNo(32),aShipperEmail(32),aShipperCheck(32),aShipperCC(32),aShipperMSG(32)
Dim aFileNo(2000)


'//////////////////////////////////////////////////////////////////////////////////////////
Dim aShipperHAWB(32,64),aShipperHAWBCheck(32,64),aShipperHAWBIndex(32)
Dim aShipperInvoice(32,64),aShipperInvoiceCheck(32,64),aShipperInvoiceIndex(32)
Dim aShipperMAWB(1),aShipperMAWBIndex(1),sIndex,aIndex,shIndex,ahIndex,mIndex
Dim vCarrier,vFileNo,vFLT,vETD,vETA,vDepPort,vArrPort

Dim objUpload
Dim strFileName
Dim objConn
Dim objRs
Dim lngFileID
Dim rs,rs1,SQL

'//////////////////////////////////////////////////////////////////////////////////////////

Dim aShipperSubject(32),aAgentSubject(32)
Dim aShipperFileCheck(32,128),aShipperFileURL(32,128),aShipperFileIndex(32),aShipperFileName(32,128)
Dim aMAWBAgentCheck(32),aMAWBShipperCheck(32)
Dim aAgentFileCheck(32,128),aAgentFileURL(32,128),aAgentFileIndex(32),aAgentFileName(32,128)
Dim vMAWB,vAgent,vCC,vSubject,vYourName,vYourEmail,vMSG
Dim aSendInfo(32),vlstSearchNum,vlstSearchType
Dim MasterAgentNo,MasterAgentName,MasterAgentPhone
'//add by stanley on 7-31-2007////////////////////////////
Set UserTable = Server.CreateObject("System.Collections.HashTable")
Set BusinessnameTable = Server.CreateObject("System.Collections.HashTable")
Set mawb_mastertable1 = Server.CreateObject("System.Collections.HashTable")
Set mawb_mastertable2 = Server.CreateObject("System.Collections.HashTable")
Set ShippingTable1 = Server.CreateObject("System.Collections.HashTable")
'// Added by Joon On Dec-8-2006 /////////////////////
Dim vHAWB,hawb_list,rMAWB
Set hawb_list = get_HAWB_list_booked(elt_account_number)

'////////////////////////////////////////////////////
%>

<%
Send=Request.QueryString("Send")
Edit=Request.QueryString("Edit")
UP=Request.QueryString("UP")
RM=Request.QueryString("RM")
dFileName=Request.QueryString("dFileName")
vEMPHAWB=Request.QueryString("EMPHAWB")
'// added by Joon On Joon On Dec-8-2006
rMAWB=Request.QueryString("rMAWB")
rtype=Request.QueryString("rtype")
rfilename=Request.QueryString("rfilename")
%>

<%
Set rs=Server.CreateObject("ADODB.Recordset")
Set rs1=Server.CreateObject("ADODB.Recordset")
%>

<%
	rEdit=Request.QueryString("rEdit")
	if rEdit = "yes" then
		vMAWB = Request.QueryString("rMAWB")
	end if
%>

<%
if rEdit="yes" Then
	 if rEdit="yes" then
			response.write("<body link='336699' vlink='336699' leftmargin='0' topmargin='0' marginwidth='0' marginheight='0' onload='MAWBCHANGE()'>")
	  else
			response.write("<body link='336699' vlink='336699' leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>")
	 end if
End If
%>

<%
if rEdit="" then
%>

<%
if Edit="yes" or Send="yes" or UP="yes" Or RM="yes" then
    If rtype<>"" then
           vlstSearchType = rtype
           vlstSearchNum=rfilename

    end if    
' Instantiate Upload Class
	Set objUpload = New clsUpload
	if vlstSearchType="master" then
	vMAWB=checkBlank(objUpload("lstSearchNum").Value,"")
	else
	vMAWB=checkBlank(objUpload("lstMAWB").Value,"")
	end if
	If vMAWB <> "" Then
	    vMAWB=Mid(vMAWB,1,len(vMAWB)-2)
	End If
'// Added by Joon On Dec-8-2006 /////////////////////
'//change by stanley on 7/31/2007///////////////////
	if vlstSearchType="house" then
	vHAWB=checkBlank(objUpload("lstSearchNum").Value,"")
	else
    vHAWB=objUpload("lstHAWB").Value
    End if
    If rMAWB="" Then
	    vHAWB=Mid(vHAWB,1,len(vHAWB)-2)
	    'If IsNull(vMAWB) Or vMAWB = "0" Or vMAWB = "" Then
	        'vMAWB=get_mawb_by_hawb(vHAWB)
	    'End If
	End If
'////////////////////////////////////////////////////


	vYourName=objUpload("txtYourName").Value
	vYourName=Mid(vYourName,1,len(vYourName)-2)
	vYourEmail=objUpload("txtYourEmail").Value
	vYourEmail=Mid(vYourEmail,1,len(vYourEmail)-2)
end if
%>

<%
if Edit="yes" then


    Call get_USER_info
    vYourName=UserTable("user_fname") & " " & UserTable("user_lname")
	vYourEmail=UserTable("user_email")
    Call get_business_name 
    vFF=BusinessnameTable("dba_name")
	vSubject="Notice: " & vFF & " MAWB:" & vMAWB
elseif Send="yes" or UP="yes" Or RM="yes" then
	vFF=objUpload("hExportAgent").Value
end if
%>

<%
if Send = "yes" and vEMPHAWB = "yes" then
       sIndex=1
       shIndex=1
       aShipperName(0) = objUpload("txtShipperName" & 0).Value
       aShipperMAWB(0)=vMAWB
	  aShipperNo(0) = objUpload("hShipperNo" & 0).Value
	  aShipperNo(0) = Mid(aShipperNo(0),1,len(aShipperNo(0))-2)
       aShipperCheck(0)=Mid(objUpload("cShipperCheck" & 0).Value,1,1)
       aShipperSubject(0)=objUpload("txtShipperSubject" & 0).Value
       aShipperSubject(0)=Mid(aShipperSubject(0),1,len(aShipperSubject(0))-2)
       aShipperEmail(0)=objUpload("txtShipperEmail" & 0).Value
       aShipperEmail(0)=Mid(aShipperEmail(0),1,len(aShipperEmail(0))-2)
       aShipperCC(0)=objUpload("txtShipperCC" & 0).Value
       aShipperCC(0)=Mid(aShipperCC(0),1,len(aShipperCC(0))-2)
       aShipperMSG(0)=objUpload("txtShipperMSG" & 0).Value
	  aMAWBShipperCheck(0)=objUpload("cShipperMAWBCheck" & 0).Value
       aMAWBShipperCheck(0)=Mid(aMAWBShipperCheck(0),1,len(aMAWBShipperCheck(0))-2)

       for iii = 0 to 4
       	if Not objUpload("cShipperInvoiceCheck" & 0 & "," & iii).Value = NULL then
			aShipperInvoiceCheck(0,iii)=Mid(objUpload("cShipperInvoiceCheck" & 0 & "," & iii).Value,1,1)
		end if
       next

	  Call Get_Invoice_for_MAWB(0,0)
end if

if rEdit="" then
 if Not vMAWB="" then 
  if Not vEMPHAWB = "yes" then
	  Call Get_Normal_Shipping_Data
	  Call Get_Attached_File
  else
	  Call Get_Attached_File
  end if
  elseif Not vHAWB=""  then
    if Not vEMPHAWB = "yes" then
	  Call Get_Normal_Shipping_Data2
	  Call Get_Attached_File
  else
  	  Call Get_Attached_File
  end if
  else
  end if
end if 



Call Get_MAWB_NUMBER

'send email to all Shippers

'ShipperNoItem=Request("hShipperNoItem")
if Edit="yes" or Send="yes" or UP="yes" or RM="yes" then
	ShipperNoItem=objUpload("hShipperNoItem").Value
	if Not ShipperNoItem="" then
		ShipperNoItem=Mid(ShipperNoItem,1,len(ShipperNoItem)-2)
	end if
end if

if ShipperNoItem="" then ShipperNoItem=0

if Send="yes" And ShipperNoItem>0 then
	'response.buffer=True
	Set PDF = Server.CreateObject("APToolkit.Object")
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	for m=0 to ShipperNoItem-1
		AttachedFileName=""
		Attachment=""

		if Not aShipperNo(m) = "" And Not aShipperEmail(m)="" And aShipperCheck(m)="Y" then
			AttachedFileName=temp_path & "\Eltdata\" & elt_account_number & "\shippermail" & aShipperNo(m) & ".pdf"
			r=PDF.OpenOutputFile(AttachedFileName)
' insert mawb to pdf file
			'aMAWBShipperCheck(m)=Request("cMAWBShipperCheck" & m)
			if Not aMAWBShipperCheck(m)="" and Not vMAWB="" then
				Call InsertMAWBIntoPDF(vMAWB,"SHIPPER")
				Attachment="Y"
			end if
' insert hawb to pdf file
			for n=0 to aShipperHAWBIndex(m)
				'aShipperHAWBCheck(m,n)=Request("cShipperHAWBCheck" & m & "," & n)
				if aShipperHAWBCheck(m,n)="Y" then
					HAWBtmp=aShipperHAWB(m,n)
					Call InsertHAWBIntoPDF(HAWBtmp,"SHIPPER")
					Attachment="Y"
				end if
			next

' insert invoice to pdf file  // 
			for n=0 to aShipperInvoiceIndex(m)
				if aShipperInvoiceCheck(m,n)="Y" then
					Invoicetmp=aShipperInvoice(m,n)
					Call InsertInvoiceIntoPDF(aShipperInvoice(m,n))
					Attachment="Y"
				end if
			next

			PDF.CloseOutputFile

			Set Mail=Server.CreateObject("Persits.MailSender")
			MailServer=Request.ServerVariables("SERVER_NAME")
			Mail.Host = MailHost
            Mail.From=vYourEmail
			If Trim(vYourName) = "" Then
				Mail.FromName=vYourEmail	
			else
				Mail.FromName=vYourName
			End If
			Mail.Subject=aShipperSubject(m)
			Mail.AddAddress aShipperEmail(m)
			if Not aShipperCC(m)="" then
				Mail.AddCC aShipperCC(m)
			end if
			if Not AttachedFileName="" And Attachment="Y" then
				Mail.AddAttachment AttachedFileName
				for n=0 to aShipperFileIndex(m)-1
					vDest=temp_path & "\Eltdata\" & elt_account_number & "\" & aShipperNo(m)
					if aShipperFileCheck(m,n)="Y" then
						Call SaveBinaryFile(aShipperNo(m),aShipperFileName(m,n))
						Mail.AddAttachment vDest & "\" & aShipperFileName(m,n)
					end if
				next
			end if
			str="<HTML><BODY BGCOLOR=#FFFFFF>" & aShipperMSG(m) & "</BODY></html>"
			Mail.Body=str
			Mail.IsHTML=True
			On Error Resume Next
			Mail.Send	' send message
			error_num=Err.Number

			if error_num>0 then
				Response.Write("<font color='#FFF000' face='verdana' size='1px'><br>Send Mail to Shipper " & aShipperName(m) & " Failed with Error # " & CStr(Err.Number) & " " & Err.Description & "</font>")
'				Response.write("<br>")
'				Response.write("<a href='javascript:history.go(-2);'><font color='#FF0000' face='verdana' size='1px'><< Back</font></a>")
				Err.Clear
			else
				Response.Write("<font color='#000000' face='verdana' size='1px'><br>Send Mail to Shipper " & aShipperName(m) & " Success!" & "</font>")
'				Response.write("<br>")
'				Response.write("<a href='javascript:history.go(-2);'><font color='#FF0000' face='verdana' size='1px'><< Back</font></a>")
'				response.end()
			end if
			Set Mail=Nothing
		end if
	next
	set PDF=nothing
end if
%>

<%
'///////////////////// rEdit End
else
	Call Get_MAWB_NUMBER
end if
'///////////////////// rEdit End
%>

<%
  Set rs  = Nothing
  Set rs1 = Nothing
%>

<%
'// Input greeting message
%>

<!--  #INCLUDE FILE="../include/FunctionMailExtra.asp" -->
<%
IF Edit = "yes" or rEdit = "yes" then
	DIM tmpGreetingMessage
	tmpGreetingMessage = GET_GREETING_MESSAGE( "AE/Shipping Notice" )
	 for i=0 to sIndex-1
		aShipperMSG(i) = tmpGreetingMessage & chr(10)	& aShipperMSG(i)						
	 next
End if
%>

<!--  #include file="../include/recent_file.asp" -->

<%


Function get_HAWB_list_booked(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
		SQL = "SELECT hawb_num FROM HAWB_master where " _
	    & " is_dome='Y' AND elt_account_number=" & elt_num & " and isnull(shipper_account_number,0)<>0 ORDER BY hawb_num"

	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("hawb_num").value
		rs.MoveNext
	Loop
	rs.Close
            
    Set get_HAWB_list_booked = tempList
    
End Function

Sub Get_MAWB_NUMBER

SQL= "select a.* from mawb_number a inner join mawb_master b on (a.mawb_no=b.mawb_num and a.elt_account_number=b.elt_account_number) " _
    & "where a.is_dome='Y' and a.status='B' and a.elt_account_number=" & elt_account_number & " and isnull(b.Shipper_account_number,0)<>0 order by a.mawb_no"
rs.Open SQL, eltConn, , , adCmdText
mIndex=0

Do While Not rs.EOF
	aMAWB(mIndex)=rs("mawb_no")
	aFileNo(mIndex)=rs("File#")	
	if vMAWB=aMAWB(mIndex) then
		vCarrier=rs("carrier_desc")
		vFileNo=rs("file#")
		vFLT=rs("flight#1")
		vETD=rs("etd_date1")
		vETA=rs("eta_date1")
		vDepPort=rs("origin_port_id")
		vArrPort=rs("dest_port_id")
	end if
	rs.MoveNext
	mIndex=mIndex+1
Loop
rs.Close
End Sub


Sub get_USER_info
        Dim SQL,dataObj
       SQL= "select * from users where elt_account_number=" & elt_account_number 
       '& " and userid=" & user_id
	'rs.Open SQL, eltConn, , , adCmdText
	'if Not rs.EOF then
	'	vYourName=rs("user_fname") & " " & rs("user_lname")
	'	vYourEmail=rs("user_email")
	'end if
	'rs.Close
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set UserTable = dataObj.GetRowTable(0)
End Sub

Sub get_Business_name
        Dim SQL,dataObj
	SQL= "select dba_name from agent where elt_account_number=" & elt_account_number
	   Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set BusinessnameTable = dataObj.GetRowTable(0)
End Sub

Sub Get_Normal_Shipping_Data

'get master agent info
    Dim SQL,dataObj
    
	SQL="select a.master_agent as master_agent,b.dba_name as dba_name,b.business_phone as business_phone from mawb_master a left join organization b "
	SQL=SQL & "on ( a.elt_account_number=b.elt_account_number and a.master_agent=b.org_account_number) where a.elt_account_number = " & elt_account_number & " and a.is_dome='Y' and a.MAWB_NUM = '" & vMAWB & "'"
	 '
	 'SQL="select master_agent from mawb_master where is_dome='Y' and MAWB_NUM = '" & vMAWB & "' and elt_account_number = " & elt_account_number 
	 ' Set dataObj = new DataManager
     'dataObj.SetDataList(SQL)
     'Set mawb_mastertable1 = dataObj.GetRowTable(0)
     'MasterAgentNo=mawb_mastertable1("master_agent")

     rs.Open SQL, eltConn, , , adCmdText
	 if Not rs.EOF then
	     MasterAgentNo=rs("master_agent")
   	     MasterAgentName=rs("dba_name")
	     MasterAgentPhone=rs("business_phone")
	 end if
	 rs.close
    'Call Get_Normal_Shipping_Data1b(MasterAgentNo)
    CAll Get_Shipping_Data1
    
	
End Sub

Sub Get_Normal_Shipping_Data1b(MasterAgentNo)

'get master agent info
    Dim SQL,dataObj
     SQL=" select dba_name, business_phone from organization where org_account_number = " & MasterAgentNo & "' and elt_account_number =" & elt_account_number 
     Set dataObj = new DataManager
     dataObj.SetDataList(SQL)
     Set mawb_mastertable2 = dataObj.GetRowTable(0)
     'MasterAgentName=mawb_mastertable2("dba_name")
     'MasterAgentPhone=mawb_mastertable2("business_phone")
    End Sub

Sub Get_Shipping_Data1
    Dim SQL,dataObj
	SQL= "select a.agent_name,a.agent_no,a.shipper_name,a.consignee_name,hawb_num,b.agent_elt_acct,b.owner_email,b.edt from " _
	    & "hawb_master a, organization b where a.is_dome='Y' and a.elt_account_number=b.elt_account_number and a.elt_account_number = " _
	    & elt_account_number & " and a.agent_no=cast(b.org_account_number as nvarchar) and a.MAWB_NUM = '" & vMAWB & "' order by a.agent_name,a.hawb_num"
	rs.Open SQL, eltConn, , , adCmdText
	aIndex=0
	hIndex=0
	LastAgent=""
	Do While Not rs.EOF
		vHAWB=rs("hawb_num")
		vShipper=rs("shipper_name")
		vConsignee=rs("consignee_name")
		vAgentName=rs("agent_name")
		vAgentNo=rs("agent_no")
		vAgentEmail=rs("owner_email")
		vAgentELTAcct=rs("agent_elt_acct")
		if IsNull(vAgentELTAcct) or vAgentELTAcct="" then vAgentELTAcct=0
		vEDTEnable=rs("edt")
		if Not LastAgent=vAgentName then
			hIndex=0
			aHAWB(aIndex,hIndex)=vHAWB
			aShipper(aIndex,hIndex)=vShipper
			aConsignee(aIndex,hIndex)=vConsignee
			if Edit="yes" then
				aHAWBCheck(aIndex,hIndex)="Y"
			else
				aHAWBCheck(aIndex,hIndex)=Mid(objUpload("cHAWBCheck" & aIndex & "," & hIndex).Value,1,1)
			end if
			aHAWBIndex(aIndex)=hIndex
			aAgentName(aIndex)=vAgentName
			aAgentNo(aIndex)=vAgentNo
			aAgentELTAcct(aIndex)=vAgentELTAcct
			if Not MasterAgentNo="" and not vAgentNo="" then
				if Not cLng(MasterAgentNo)=cLng(vAgentNo) then
					aAgentMSG(aIndex)="Master agent is " & MasterAgentName & chr(10) & "Phone# " & MasterAgentPhone
				end if
			end if
			if Edit="yes" then

			else

			end if
			LastAgent=vAgentName

			aIndex=aIndex+1
			hIndex=hIndex+1
		else
			if aIndex > 0 then
			aHAWB(aIndex-1,hIndex)=vHAWB
			aShipper(aIndex-1,hIndex)=vShipper
			aConsignee(aIndex-1,hIndex)=vConsignee
			if Edit="yes" then
				aHAWBCheck(aIndex-1,hIndex)="Y"
			else
				aHAWBCheck(aIndex-1,hIndex)=Mid(objUpload("cHAWBCheck" & aIndex-1 & "," & hIndex).Value,1,1)
			end if
			aHAWBIndex(aIndex-1)=hIndex
			hIndex=hIndex+1
			end if	
		end if
		rs.MoveNext
	Loop
	rs.close
	Call get_info_for_shipper1
End Sub
	
Sub get_info_for_shipper1
'get info for shipper
	SQL= "select a.shipper_name,a.shipper_account_number,hawb_num,a.ci,b.owner_email from " _
	    & "hawb_master a, organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " _
	    & elt_account_number & " and a.shipper_account_number=cast(b.org_account_number as nvarchar) and a.MAWB_NUM = '" _
	    & vMAWB & "' and a.is_dome='Y' order by a.shipper_account_number,a.hawb_num"

	rs.Open SQL, eltConn, , , adCmdText
	sIndex=0
	shIndex=0
	LastShipper=""

'/////////////////////////
if  Not rs.EOF then
'/////////////////////////
  	Do While Not rs.EOF
		vHAWB=rs("hawb_num")
		vShipperName=rs("shipper_name")
		vShipperNo=rs("shipper_account_number")
		vShipperEmail=rs("owner_email")
		vShipperSubject=rs("ci")
		if Not LastShipper=vShipperName then
			shIndex=0
			aShipperHAWB(sIndex,shIndex)=vHAWB
			aShipperName(sIndex)=vShipperName
			if Edit="yes" then
				aShipperHAWBCheck(sIndex,shIndex)="Y"
			else
				aShipperHAWBCheck(sIndex,shIndex)=Mid(objUpload("cShipperHAWBCheck" & sIndex & "," & shIndex).Value,1,1)
			end if

			aShipperHAWBIndex(sIndex)=shIndex
			aShipperNo(sIndex)=vShipperNo
			if Edit="yes" then
				aShipperCheck(sIndex)="Y"
				aShipperEmail(sIndex)=vShipperEmail
				aShipperSubject(sIndex)="Notice: " & vFF & " " & vShipperSubject
				aMAWBShipperCheck(sIndex)="Y"
			else
				aShipperCheck(sIndex)=Mid(objUpload("cShipperCheck" & sIndex).Value,1,1)
				aShipperSubject(sIndex)=objUpload("txtShipperSubject" & sIndex).Value
				aShipperSubject(sIndex)=Mid(aShipperSubject(sIndex),1,len(aShipperSubject(sIndex))-2)
				aShipperEmail(sIndex)=objUpload("txtShipperEmail" & sIndex).Value
				aShipperEmail(sIndex)=Mid(aShipperEmail(sIndex),1,len(aShipperEmail(sIndex))-2)
				aShipperCC(sIndex)=objUpload("txtShipperCC" & sIndex).Value
				aShipperCC(sIndex)=Mid(aShipperCC(sIndex),1,len(aShipperCC(sIndex))-2)
				aShipperMSG(sIndex)=objUpload("txtShipperMSG" & sIndex).Value
				aMAWBShipperCheck(sIndex)=Mid(objUpload("cMAWBShipperCheck" & sIndex).Value,1,1)
			end if
			LastShipper=vShipperName

'get invoice
			SQL= "select distinct invoice_no from invoice where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' and customer_number=" & vShipperNo
'			response.write SQL
			rs1.Open SQL, eltConn, , , adCmdText
			sIIndex=0

			Do While Not rs1.EOF
				aShipperInvoice(sIndex,sIIndex)=rs1("invoice_no")
				if Edit="yes" then

					aShipperInvoiceCheck(sIndex,sIIndex)="Y"
				else
					aShipperInvoiceCheck(sIndex,sIIndex)=Mid(objUpload("cShipperInvoiceCheck" & sIndex & "," & sIIndex).Value,1,1)
				end if
	                 sIIndex=sIIndex+1
	                 rs1.MoveNext
			Loop
                 aShipperInvoiceIndex(sIndex)=sIIndex
			rs1.close

			sIndex=sIndex+1
			shIndex=shIndex+1
		else
			if sIndex > 0 then
			aShipperHAWB(sIndex-1,shIndex)=vHAWB
			aShipperName(sIndex-1)=vShipperName
			aShipperSubject(sIndex-1)=aShipperSubject(sIndex-1) & " " & vShipperSubject
			if Edit="yes" then
				aShipperHAWBCheck(sIndex-1,shIndex)="Y"
			else
				aShipperHAWBCheck(sIndex-1,shIndex)=Mid(objUpload("cShipperHAWBCheck" & sIndex-1 & "," & shIndex).Value,1,1)
			end if
			aShipperHAWBIndex(sIndex-1)=shIndex
			shIndex=shIndex+1
			end if
		end if
		rs.MoveNext
	Loop
	rs.close

'///////////////////////////
else
'///////////////////////////

		rs.close

		
		if  len(vShipperNo) < 5 then
			SQL= "select owner_email from organization where elt_account_number = " & elt_account_number & " and org_account_number = '" &  checkBlank(vShipperNo,0) & "'"
			rs.Open SQL, eltConn, , , adCmdText
			If Not rs.BOF And Not rs.EOF Then
			    vShipperEmail=rs("owner_email")
			End If
			rs.close
			aShipperEmail(0) = vShipperEmail
		else
			vShipperEmail=""
		end if

           Call Get_Invoice_For_MAWB(0,0)

		sIndex=sIndex+1
		shIndex=shIndex+1
		aShipperName(0) = vShipperName
		aShipperNo(0) = vShipperNo

		aShipperCheck(0)="Y"
		aShipperEmail(0)=vShipperEmail
		aShipperSubject(0)="Notice: " & vFF & " " & vShipperSubject
		aMAWBShipperCheck(0)="Y"
		aShipperMAWB(0)=vMAWB
		aMAWBShipperCheck(0)="Y"

    end if
End Sub
'///////////////////////////creat by stanley/////////////////////////
Sub Get_Normal_Shipping_Data2

'get master agent info
	
	SQL= "select a.agent_name,a.agent_no,a.shipper_name,a.consignee_name,hawb_num,b.agent_elt_acct,b.owner_email,b.edt from " _
	    & "hawb_master a, organization b where a.is_dome='Y' and a.elt_account_number=b.elt_account_number and a.elt_account_number = " _
	    & elt_account_number & " and a.agent_no=b.org_account_number and a.HAWB_NUM = '" & vHAWB & "' order by a.agent_name,a.hawb_num"
	rs.Open SQL, eltConn, , , adCmdText
	aIndex=0
	hIndex=0
	LastAgent=""
	Do While Not rs.EOF
		vHAWB=rs("hawb_num")
		vShipper=rs("shipper_name")
		vConsignee=rs("consignee_name")
		vAgentName=rs("agent_name")
		vAgentNo=rs("agent_no")
		vAgentEmail=rs("owner_email")
		vAgentELTAcct=rs("agent_elt_acct")
		if IsNull(vAgentELTAcct) or vAgentELTAcct="" then vAgentELTAcct=0
		vEDTEnable=rs("edt")
		if Not LastAgent=vAgentName then
			hIndex=0
			aHAWB(aIndex,hIndex)=vHAWB
			aShipper(aIndex,hIndex)=vShipper
			aConsignee(aIndex,hIndex)=vConsignee
			if Edit="yes" then
				aHAWBCheck(aIndex,hIndex)="Y"
			else
				aHAWBCheck(aIndex,hIndex)=Mid(objUpload("cHAWBCheck" & aIndex & "," & hIndex).Value,1,1)
			end if
			aHAWBIndex(aIndex)=hIndex
			aAgentName(aIndex)=vAgentName
			aAgentNo(aIndex)=vAgentNo
			aAgentELTAcct(aIndex)=vAgentELTAcct
			if Not MasterAgentNo="" and not vAgentNo="" then
				if Not cLng(MasterAgentNo)=cLng(vAgentNo) then
					aAgentMSG(aIndex)="Master agent is " & MasterAgentName & chr(10) & "Phone# " & MasterAgentPhone
				end if
			end if
			if Edit="yes" then
			else
			end if
			LastAgent=vAgentName
			aIndex=aIndex+1
			hIndex=hIndex+1
		else
			if aIndex > 0 then
			aHAWB(aIndex-1,hIndex)=vHAWB
			aShipper(aIndex-1,hIndex)=vShipper
			aConsignee(aIndex-1,hIndex)=vConsignee
			if Edit="yes" then
				aHAWBCheck(aIndex-1,hIndex)="Y"
			else
				aHAWBCheck(aIndex-1,hIndex)=Mid(objUpload("cHAWBCheck" & aIndex-1 & "," & hIndex).Value,1,1)
			end if
			aHAWBIndex(aIndex-1)=hIndex
			hIndex=hIndex+1
			end if	
		end if
		rs.MoveNext
	Loop
	rs.close

'get info for shipper
	SQL= "select a.shipper_name,a.shipper_account_number,hawb_num,a.ci,b.owner_email from " _
	    & "hawb_master a, organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " _
	    & elt_account_number & " and a.shipper_account_number=cast(b.org_account_number as nvarchar) and a.HAWB_NUM = '" _
	    & vHAWB & "' and a.is_dome='Y' order by a.shipper_account_number,a.hawb_num"
	rs.Open SQL, eltConn, , , adCmdText
	sIndex=0
	shIndex=0
	LastShipper=""

'/////////////////////////
if  Not rs.EOF then
'/////////////////////////
  	Do While Not rs.EOF
		vHAWB=rs("hawb_num")
		vShipperName=rs("shipper_name")
		vShipperNo=rs("shipper_account_number")
		vShipperEmail=rs("owner_email")
		vShipperSubject=rs("ci")
		if Not LastShipper=vShipperName then
			shIndex=0
			aShipperHAWB(sIndex,shIndex)=vHAWB
			aShipperName(sIndex)=vShipperName
			if Edit="yes" then
				aShipperHAWBCheck(sIndex,shIndex)="Y"
			else
				aShipperHAWBCheck(sIndex,shIndex)=Mid(objUpload("cShipperHAWBCheck" & sIndex & "," & shIndex).Value,1,1)
			end if

			aShipperHAWBIndex(sIndex)=shIndex
			aShipperNo(sIndex)=vShipperNo
			if Edit="yes" then
				aShipperCheck(sIndex)="Y"
				aShipperEmail(sIndex)=vShipperEmail
				aShipperSubject(sIndex)="Notice: " & vFF & " " & vShipperSubject
				aMAWBShipperCheck(sIndex)="Y"
			else
				aShipperCheck(sIndex)=Mid(objUpload("cShipperCheck" & sIndex).Value,1,1)
				aShipperSubject(sIndex)=objUpload("txtShipperSubject" & sIndex).Value
				aShipperSubject(sIndex)=Mid(aShipperSubject(sIndex),1,len(aShipperSubject(sIndex))-2)
				aShipperEmail(sIndex)=objUpload("txtShipperEmail" & sIndex).Value
				aShipperEmail(sIndex)=Mid(aShipperEmail(sIndex),1,len(aShipperEmail(sIndex))-2)
				aShipperCC(sIndex)=objUpload("txtShipperCC" & sIndex).Value
				aShipperCC(sIndex)=Mid(aShipperCC(sIndex),1,len(aShipperCC(sIndex))-2)
				aShipperMSG(sIndex)=objUpload("txtShipperMSG" & sIndex).Value
				aMAWBShipperCheck(sIndex)=Mid(objUpload("cMAWBShipperCheck" & sIndex).Value,1,1)
			end if
			LastShipper=vShipperName

'get invoice
			SQL= "select distinct invoice_no from invoice where elt_account_number = " & elt_account_number & " and HAWB_NUM = '" & vHAWB & "' and customer_number=" & vShipperNo
'			response.write SQL
			rs1.Open SQL, eltConn, , , adCmdText
			sIIndex=0

			Do While Not rs1.EOF
				aShipperInvoice(sIndex,sIIndex)=rs1("invoice_no")
				if Edit="yes" then

					aShipperInvoiceCheck(sIndex,sIIndex)="Y"
				else
					aShipperInvoiceCheck(sIndex,sIIndex)=Mid(objUpload("cShipperInvoiceCheck" & sIndex & "," & sIIndex).Value,1,1)
				end if
	                 sIIndex=sIIndex+1
	                 rs1.MoveNext
			Loop
                 aShipperInvoiceIndex(sIndex)=sIIndex
			rs1.close

			sIndex=sIndex+1
			shIndex=shIndex+1
		else
			if sIndex > 0 then
			aShipperHAWB(sIndex-1,shIndex)=vHAWB
			aShipperName(sIndex-1)=vShipperName
			aShipperSubject(sIndex-1)=aShipperSubject(sIndex-1) & " " & vShipperSubject
			if Edit="yes" then
				aShipperHAWBCheck(sIndex-1,shIndex)="Y"
			else
				aShipperHAWBCheck(sIndex-1,shIndex)=Mid(objUpload("cShipperHAWBCheck" & sIndex-1 & "," & shIndex).Value,1,1)
			end if
			aShipperHAWBIndex(sIndex-1)=shIndex
			shIndex=shIndex+1
			end if
		end if
		rs.MoveNext
	Loop
	rs.close
'///////////////////////////
else
'///////////////////////////
		rs.close
		if  len(vShipperNo) < 5 then
			SQL= "select owner_email from organization where elt_account_number=" & elt_account_number & " and org_account_number=" &  checkBlank(vShipperNo,0)
			rs.Open SQL, eltConn, , , adCmdText
			If Not rs.EOF And Not rs.BOF Then
			    vShipperEmail=rs("owner_email")
		    End If
			rs.close
			aShipperEmail(0) = vShipperEmail
		else
			vShipperEmail=""
		end if
           Call Get_Invoice_For_MAWB(0,0)
		sIndex=sIndex+1
		shIndex=shIndex+1
		aShipperName(0) = vShipperName
		aShipperNo(0) = vShipperNo
		aShipperCheck(0)="Y"
		aShipperEmail(0)=vShipperEmail
		aShipperSubject(0)="Notice: " & vFF & " " & vShipperSubject
		aMAWBShipperCheck(0)="Y"
		aShipperMAWB(0)=vMAWB
		aMAWBShipperCheck(0)="Y"
end if
End Sub
'////////////////////////////////////////////////////////////////////////
Sub Get_Invoice_For_MAWB(ssIndex,ssIIndex)
  SQL= "select distinct invoice_no from invoice where elt_account_number = " & elt_account_number & " and HAWB_NUM = '" & vHAWB & "'"
  rs1.Open SQL, eltConn, , , adCmdText
  Do While Not rs1.EOF
        aShipperInvoice(ssIndex,ssIIndex)=rs1("invoice_no")
        if Edit="yes" then
              aShipperInvoiceCheck(ssIndex,ssIIndex)="Y"
        else
              aShipperInvoiceCheck(ssIndex,ssIIndex)=Mid(objUpload("cShipperInvoiceCheck" & ssIndex & "," & ssIIndex).Value,1,1)
        end if
       ssIIndex=ssIIndex+1
       rs1.MoveNext
  Loop
  aShipperInvoiceIndex(ssIndex)=ssIIndex
  rs1.close
End SUb
Sub Get_Attached_File

'update shipper file check status
'	if Not Edit="yes" then
		for i=0 to sIndex-1
			SQL= "select file_checked from user_files where elt_account_number=" & elt_account_number & " and org_no=" & checkBlank(aShipperNo(i),0)
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			afIndex=0
			Do while Not rs.EOF
				vFileChecked=Mid(objUpload("cShipperFileCheck" & i & "," & afIndex).Value,1,1)
				rs("file_checked")=vFileChecked
				rs.Update
				rs.MoveNext
				afIndex=afIndex+1
			loop
			rs.Close
		next
'	end if

'uploading file
	if UP="yes" then
		UpOrgNo=Request.QueryString("UpOrgNo")
		if Not UpOrgNo="" then
			UpFileName=objUpload.Fields("File" & UpOrgNo).FileName
			SQL= "select * from user_files where elt_account_number =" & elt_account_number & " and org_no=" & UpOrgNo & " and file_name='" & UpFileName & "'"
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If rs.EOF=true Then
				rs.AddNew
				rs("elt_account_number") = elt_account_number
				rs("org_no") =UpOrgNo
				rs("file_name") = UpFileName
			end if
			rs("file_size") = objUpload.Fields("File" & UpOrgNo).Length
			rs("file_type") = objUpload.Fields("File" & UpOrgNo).ContentType
			rs("file_content").AppendChunk objUpload("File" & UpOrgNo).BLOB & ChrB(0)
			rs("file_checked")="Y"
			rs("in_dt") = Now
			rs.Update
			rs.Close
		end if
	end if
	if RM="yes" then
		UpOrgNo=Request.QueryString("UpOrgNo")

'//  by iMoon DEC/03/2006
		dFileName=objUpload("hDeleteFileName").Value
		dFileName=Mid(dFileName,1,len(dFileName)-2)
'////////////////////////
		
		SQL= "delete from user_files where elt_account_number = " & elt_account_number & " and org_no=" & UpOrgNo & " and file_name='" & dFileName & "'"
		eltConn.Execute SQL
	end if

' get shipper attached files
       for i=0 to sIndex-1
         SQL= "select file_name,file_checked from user_files where elt_account_number=" & elt_account_number & " and org_no=" & checkBlank(aShipperNo(i),0)
         rs.Open SQL, eltConn, , , adCmdText
         sfIndex=0
         Do while Not rs.EOF
               vFileName=rs("file_name")
               aShipperFileURL(i,sfIndex)= "/IFF_MAIN/ASP/include/viewfile.asp?OrgNo=" & aShipperNo(i) & "&FileName=" & vFileName
               aShipperFileName(i,sfIndex)=vFileName
               aShipperFileCheck(i,sfIndex)=rs("file_checked")
               rs.MoveNext
               sfIndex=sfIndex+1
         loop
         rs.Close
         aShipperFileIndex(i)=sfIndex
       next
End Sub

'// Added by Joon on Dec-8-2006 ////////////////////////////////////////////////////////////////

Function get_mawb_by_hawb(arg)

    Dim resV
    resV = ""
    SQL = "select a.MAWB_NUM from mawb_master a, hawb_master b where " _
        & "a.elt_account_number = b.elt_account_number and " _
        & "a.MAWB_NUM = b.mawb_num and b.HAWB_NUM='" & arg & "' and " _
        & "a.elt_account_number=" & elt_account_number & " and a.is_dome='Y' isnull(a.shipper_acct_number,0)<>0 and group by a.MAWB_NUM"
    rs.Open SQL, eltConn, , , adCmdText
    If Not rs.EOF And Not rs.BOF Then
        resV = rs("MAWB_NUM")
    End If
    rs.Close
    get_mawb_by_hawb = resV
End Function

'///////////////////////////////////////////////////////////////////////////////////////////////
%>
<body>
<!-- tooltip placeholder -->
<div id="tooltipcontent"></div>
<!-- placeholder ends -->
<form name="form1"  enctype="multipart/form-data">
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td width="56%" height="32" align="left" valign="middle" class="pageheader">delivery confirmation </td>
  </tr>
</table>
<div class="selectarea">
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
<td>
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td height="15" valign="top"><span class="select">Select AWB Type and No.</span></td>
                </tr>
                <tr>
                    <td width="64%" valign="bottom"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="14%"><span class="bodyheader">
                                <select id="lstSearchType" class="bodyheader"  onchange="cleartext()">
                                    <option value="house"  <% if vlstSearchType="house" then response.write("selected") %>>House AWB No.</option>
                                    <option value="master" <% if vlstSearchType="master" then response.write("selected")  %>>Master AWB No.</option>
                                    <option value="file" <% if vlstSearchType="file" then response.write("selected") %>>File No.</option>
                                </select>
                            </span></td>
                            <td width="66%"><!-- Start JPED -->
                                                        <input type="hidden" id="hSearchNum" name="hSearchNum" />
                                                        <div id="lstSearchNumDiv">
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td style="height: 18px"><input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value="<%=vlstSearchNum%>" tabindex="-1"
                                                                        class="shorttextfield" style="width: 140px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp=" searchNumFill(this,'A','selectSearchType',200);" onFocus="initializeJPEDField(this);" /></td>
                                                                <td style="height: 18px">
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="searchNumFillAll('lstSearchNum','A','selectSearchType',200);"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                            </tr>
                                                        </table>
                            <!-- End JPED --></td>
                        </tr>
                    </table>                    </td>
                </tr>
            </table>
            </td>

        <td width="62%" valign="bottom"><table border="0" cellspacing="0" cellpadding="0">
            <tr> 
                <td><!-- //Start of Combobox// -->	
<%  iMoonDefaultValue = vMAWB %>						
<%  iMoonComboBoxName =  "lstMAWB" %>
<%  iMoonComboBoxWidth =  "140px" %>
<script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() {	MAWBChange(); } </script>
<div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" ><input name="<%=iMoonComboBoxName%>:Text" type="hidden" id="<%=iMoonComboBoxName%>_Text" class="ComboBox" autocomplete="off" style="width:<%=iMoonComboBoxWidth%>;vertical-align:middle" value="<%=iMoonDefaultValue%>"/><div id="<%=iMoonComboBoxName%>_Div" ></div>
<!-- /End of Combobox/ --><select name="lstMAWB" id="lstMAWB" listsize = "20" class="ComboBox" style="width: 140px;display:none" onChange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                      <option value="">Select One</option>
                      <% for i=0 to mIndex-1 %>
                      <option <% if vMAWB=aMAWB(i) then response.write("selected") %>><%= aMAWB(i) %></option>
                      <% next %>
                    </select>
<!-- /End of Combobox/ --></td>
                <td></td>
                <td><!-- //Start of Combobox// -->	
<%  iMoonDefaultValue = "" %>						
<%  iMoonComboBoxName =  "lstHAWB" %>
<%  iMoonComboBoxWidth =  "140px" %>
<script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() {	HAWBChange(); } </script>
<div id="Div1" class="ComboBox" ><input name="<%=iMoonComboBoxName%>:Text" type="hidden" id="Hidden1" class="ComboBox" autocomplete="off" style="width:<%=iMoonComboBoxWidth%>;vertical-align:middle" value="<%=iMoonDefaultValue%>"/><div id="Div2" ></div></div><div id="Div3" style="display:none;position:absolute;top:0;left:0;width:17px"><img id="Img2" src="/ig_common/Images/combobox_addnew.gif" border="0" /></div>
<!-- /End of Combobox/ --><select name="lstHAWB" id="lstHAWB" listsize = "20" class="ComboBox" style="width: 140px;display:none" onChange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                      <option value="">Select One</option>
                      <% for i=0 to hawb_list.count-1 %>
                      <option <% if vHAWB=hawb_list(i) then response.write("selected") %>><%= hawb_list(i) %></option>
                      <% next %>
                    </select>
<!-- /End of Combobox/ --></td>
            </tr>
        </table></td>
        <td width="38%" align="right" valign="bottom">&nbsp;</td>
    </tr>
</table>
</div>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132" bgcolor="#997132" class="border1px">

  <tr>
    <td>
			<input type=hidden name="hNoItem" value="<%= aIndex %>">
			<input type=hidden name="hShipperNoItem" value="<%= sIndex %>">
			<input type=hidden name="hExportAgent" value="<%= vFF %>">
			<input type=hidden name="hShipperNo" value="<%= vShipperNo %>">
			<input type=hidden name="hDeleteFileName">

        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr bgcolor="edd3cf">
            <td height="24" colspan="6" align="center" valign="middle" bgcolor="#eec983" class="bodyheader"><span class="pageheader"><img src="../images/button_send_email.gif" width="101" height="18" name="bSend" onClick="SendClick()"  style="cursor:hand"></span></td>
          </tr>
		  <tr>
            <td height="1" colspan="6" align="left" valign="top" bgcolor="#997132" class="bodyheader"></td>
          </tr>
          <tr align="center" valign="middle" bgcolor="f3d9a8">
            <td height="24" colspan="6" align="center" bgcolor="#f3f3f3" class="bodyheader"><br>
<table width="65%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="50%" height="28" align="left" valign="middle"><span class="goto"><img src="/iff_main/ASP/Images/icon_email_history.gif" align="absbottom"><a href="javascript:;" onClick="ShowEmailHistory()">View Email History</a></span></td>
                    <td width="50%" align="right" class="bodyheader"><img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</td>
                </tr>
            </table>
                <table width="65%" border="0" cellpadding="2" cellspacing="0" bordercolor="#997132" bgcolor="edd3cf" class="border1px">
                
<!-- modified by Joon on Dec-8-2006 --->                
                
<!-- End of modified by Joon on Dec-8-2006 --->    
                <tr align="left" valign="middle" bgcolor="#f3d9a8">
                    <td width="1" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                    <td width="177" height="20" align="left" valign="middle" class="bodyheader">Your Name</td>
                    <td width="304" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                    <td width="246" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="#FFFFFF">
                  <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
                  <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><input name="txtYourName" class="shorttextfield" value="<%= vYourName %>" size="28">
                      <select name="lstFileNo" size="1" class="smallselect" style="width: 10px; visibility:hidden" >
                          <option value=0></option>
                          <% for i=0 to mIndex-1 %>
                          <option><%= aFileNo(i) %></option>
                          <% next %>
                      </select>                    <!-- for File No. Search --></td>
                  <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="#f3d9a8">
                    <td align="left" valign="middle" class="bodycopy">&nbsp;</td>
                    <td height="20" colspan="3" align="left" valign="middle" class="bodyheader">From</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="#F3f3f3">
                  <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
                  <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><input name="txtYourEmail" type="text" class="shorttextfield" value="<%= vYourEmail %>" size="45"></td>
                </tr>
              </table>
              <br> </td>
        </table>

	    <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#997132" class="bodycopy">
	    <tr>
	    <td>
          <input type=hidden id="AgentCheck">
          <input type=hidden id="hHAWBIndex">
          <input type=hidden id="InvoiceCheck">
          <input type=hidden id="STMTCheck">
          <input type=hidden id="ManifestCheck">
          <input type=hidden id="MAWBAgentCheck">
          <input type=hidden id="hAgentFileIndex">
          <input type=hidden id="OnlineAlertCheck">
          <input type=hidden id="ShipperCheck">
          <input type=hidden id="hShipperHAWBIndex">
          <input type=hidden id="hShipperInvoiceIndex">
          <input type=hidden id="hShipperMAWBIndex">
          <input type=hidden id="MAWBShipperCheck">
          <input type=hidden id="hShipperFileIndex"></td>
          </tr>
          <% for i=0 to sIndex-1 %>
          <tr>
            <td width="48" height="1" align="left" valign="middle" bgcolor="#997132" class="bodycopy"></td>
            <td width="69" align="left" valign="middle" bgcolor="#997132" class="bodycopy"></td>
            <td width="180" align="left" valign="middle" bgcolor="#997132" class="bodycopy"></td>
            <td width="171" align="left" valign="middle" bgcolor="#997132" class="bodycopy"></td>
            <td colspan="2" align="left" valign="middle" bgcolor="#997132" class="bodycopy"></td>
          </tr>
          <tr>
            <td colspan="8" height="1" align="center" valign="middle" bgcolor="#997132"></td>
          </tr>
          <tr bgcolor="#FFFFFF">
            <td align="center" valign="middle" style="height: 28px"> <input type="checkbox" id="ShipperCheck" name="cShipperCheck<%= i %>" value="Y" <% if aShipperCheck(i)="Y" then response.write("checked") %> onClick="ShipperCheckClick(<%= i %>)"></td>
            <td align="left" valign="middle" style="height: 28px">Shipper</td>
            <td colspan="6" align="left" valign="middle" style="height: 28px"><input name="hShipperNo<%= i %>" type=hidden value="<%= aShipperNo(i) %>">
              <input name="txtShipperName<%= i %>" type="text" class="shorttextfield" value="<%= aShipperName(i) %>" size="58"></td>
          </tr>
          <tr align="left" bgcolor="#F3f3f3">
              <td valign="middle">&nbsp;</td>
              <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader"><img src="/iff_main/ASP/Images/required.gif" align="absbottom">TO</td>
              <td colspan="6" align="left" valign="middle"><input name="txtShipperEmail<%= i %>" type="text" class="shorttextfield" value="<%= aShipperEmail(i) %>" size="58"></td>
          </tr>
          
          <tr align="left">
            <td valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">CC</td>
            <td colspan="6" align="left" valign="middle" bgcolor="#FFFFFF"><input name="txtShipperCC<%= i %>" type="text" class="shorttextfield" value="<%= aShipperCC(i) %>" size="58"></td>
          </tr>
          <tr align="left" bgcolor="#F3f3f3">
            <td valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#f3f3f3"><span class="bodyheader">Subject</span></td>
            <td colspan="6" align="left" valign="middle" bgcolor="#f3f3f3"><input name="txtShipperSubject<%= i %>" type="text" class="shorttextfield" value="<%=  aShipperSubject(i) %>" size="58"></td>
          </tr>
          <input type=hidden id="hShipperInvoiceIndex" name="hShipperInvoiceIndex<%= i %>" value="<%= aShipperInvoiceIndex(i) %>">
          <input name="ShipperInvoiceCheck" type=hidden id="ShipperInvoiceCheck<%= i %>">

		  <% if aShipperHAWB(0,0) = "" then%>
			  <tr align="left" bgcolor="#FFFFFF">
				<td valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
				<td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
				<td width="180" align="left" valign="middle" bgcolor="#f3f3f3"><em>
				<input type=checkbox id="cShipperMAWBCheck" name="cShipperMAWBCheck<%= i %>" value="Y" <% if aMAWBShipperCheck(0)="Y" then response.write("checked") %>>
				  <font color="#CC3300">MAWB:</font><a href= "javascript:void(viewPop('mawb_pdf.asp?MAWB=<%= aShipperMAWB(0) %>&Copy=SHIPPER'));"><%= aShipperMAWB(0) %></a>
				  </em></td>
				<td width="171" align="left" valign="middle" bgcolor="#f3f3f3"><em></em></td>
				<td width="160" align="left" valign="middle" bgcolor="#f3f3f3"><em></em></td>
				<td colspan="3" align="left" valign="middle" bgcolor="#f3f3f3"><em></em></td>
		  </tr>
		  <%end if%>


          <input type=hidden id="hShipperHAWBIndex" name="hShipperHawbIndex<%= i %>" value="<%= aShipperHAWBIndex(i) %>">
          <input name="ShipperHAWBCheck" type=hidden id="ShipperHAWBCheck<%= i %>">
          <% for j=0 to aShipperHAWBIndex(i) step 4%>
			  <tr align="left" bgcolor="#FFFFFF">
				<td valign="middle" bgcolor="#f3f3f3" style="height: 24px">&nbsp;</td>
				<td align="left" valign="middle" bgcolor="#f3f3f3" style="height: 24px">&nbsp;</td>
				<td width="180" align="left" valign="middle" bgcolor="#f3f3f3" style="height: 24px"><em>
				  <% if aShipperHAWB(i,j) = "" then%>
				  <%else%>
				  <input type=checkbox id="ShipperHAWBCheck<%= i %>" name="cShipperHAWBCheck<%= i %>,<%= j %>" value="Y" <% if aShipperHAWBCheck(i,j)="Y" then response.write("checked") %>>
				  <font color="#CC3300">HAWB:</font><a href= "javascript:void(viewPop('hawb_pdf.asp?HAWB=<%= aShipperHAWB(i,j) %>&Copy=SHIPPER'));"><%= aShipperHAWB(i,j) %></a>
				  <%end if%>
				  </em></td>
				<td width="171" align="left" valign="middle" bgcolor="#f3f3f3" style="height: 24px"><em>
				  <% if aShipperHAWB(i,j+1) = "" then%>
				  <%else%>
				  <input type=checkbox id="ShipperHAWBCheck<%= i %>" name="cShipperHAWBCheck<%= i %>,<%= j+1 %>" value="Y" <% if aShipperHAWBCheck(i,j+1)="Y" then response.write("checked") %>>
				  <a href= "javascript:void(viewPop('hawb_pdf.asp?HAWB=<%= aShipperHAWB(i,j+1) %>&Copy=SHIPPER'));"><%= aShipperHAWB(i,j+1) %></a>
				  <%end if%>
				  </em></td>
				<td width="160" align="left" valign="middle" bgcolor="#f3f3f3" style="height: 24px"><em>
				  <% if aShipperHAWB(i,j+2) = "" then%>
				  <%else%>
				  <input type=checkbox id="ShipperHAWBCheck<%= i %>" name="cShipperHAWBCheck<%= i %>,<%= j+2 %>" value="Y" <% if aShipperHAWBCheck(i,j+2)="Y" then response.write("checked") %>>
				  <a href= "javascript:void(viewPop('hawb_pdf.asp?HAWB=<%= aShipperHAWB(i,j+2) %>&Copy=SHIPPER'));"><%= aShipperHAWB(i,j+2) %></a>
				  <%end if%>
				  </em></td>
				<td colspan="3" align="left" valign="middle" bgcolor="#f3f3f3" style="height: 24px"><em>
				  <% if aShipperHAWB(i,j+3) = "" then%>
				  <%else%>
				  <input type=checkbox id="ShipperHAWBCheck" name="cShipperHAWBCheck<%= i %>,<%= j+3 %>" value="Y" <% if aShipperHAWBCheck(i,j+3)="Y" then response.write("checked") %>>
				  <a href= "javascript:void(viewPop('hawb_pdf.asp?HAWB=<%= aShipperHAWB(i,j+4) %>&Copy=SHIPPER'));"><%= aShipperHAWB(i,j+4) %></a>
				  <%end if%>
				  </em></td>
			  </tr>
          <% next %>

          <% for j=0 to aShipperInvoiceIndex(i) step 4%>
			  <tr align="left" bgcolor="#FFFFFF">
				<td valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
				<td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
				<td width="180" align="left" valign="middle" bgcolor="#f3f3f3"><em>
				  <% if aShipperInvoice(i,j) = "" then%>
				  <%else%>
				  <input type=checkbox id="ShipperInvoiceCheck<%= i %>" name="cShipperInvoiceCheck<%= i %>,<%= j %>" value="Y" <% if aShipperInvoiceCheck(i,j)="Y" then response.write("checked") %>>
				  <font color="#CC3300">Invoice:</font><a href="javascript:void(viewPop('../acct_tasks/invoice_pdf.asp?InvoiceNo=<%= aShipperInvoice(i,j) %>'));"><%= aShipperInvoice(i,j) %></a>
				  <%end if%>
				  </em></td>
				<td width="171" align="left" valign="middle" bgcolor="#f3f3f3"><em>
				  <% if aShipperInvoice(i,j+1) = "" then%>
				  <%else%>
				  <input type=checkbox id="ShipperInvoiceCheck<%= i %>" name="cShipperInvoiceCheck<%= i %>,<%= j +1%>" value="Y" <% if aShipperInvoiceCheck(i,j+1)="Y" then response.write("checked") %>>
				  <font color="#CC3300"></font><a href="javascript:void(viewPop('../acct_tasks/invoice_pdf.asp?InvoiceNo=<%= aShipperInvoice(i,j+1) %>'));"><%= aShipperInvoice(i,j+1) %></a>
				  <%end if%>
				  </em></td>
				<td width="160" align="left" valign="middle" bgcolor="#f3f3f3"><em>
				  <% if aShipperInvoice(i,j+2) = "" then%>
				  <%else%>
				  <input type=checkbox id="ShipperInvoiceCheck<%= i %>" name="cShipperInvoiceCheck<%= i %>,<%= j +2%>" value="Y" <% if aShipperInvoiceCheck(i,j+2)="Y" then response.write("checked") %>>
				  <font color="#CC3300"></font><a href="javascript:void(viewPop('../acct_tasks/invoice_pdf.asp?InvoiceNo=<%= aShipperInvoice(i,j+2) %>'));"><%= aShipperInvoice(i,j+2) %></a>
				  <%end if%>
				  </em></td>
				<td colspan="3" align="left" valign="middle" bgcolor="#f3f3f3"><em>
				  <% if aShipperInvoice(i,j+3) = "" then%>
				  <%else%>
				  <input type=checkbox id="ShipperInvoiceCheck<%= i %>" name="cShipperInvoiceCheck<%= i %>,<%= j +3%>" value="Y" <% if aShipperInvoiceCheck(i,j+3)="Y" then response.write("checked") %>>
				  <font color="#FF0000"></font><a href="javascript:void(viewPop('../acct_tasks/invoice_pdf.asp?InvoiceNo=<%= aShipperInvoice(i,j+3) %>'));"><%= aShipperInvoice(i,j+3) %></a>
				  <%end if%>
				  </em></td>
			  </tr>
          <% next %>

          <tr align="left" bgcolor="#FFFFFF">
            <td valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#FFFFFF">Attach Files</td>
            <td colspan="6" align="left" valign="middle" bgcolor="#FFFFFF"> <input type="File" name="File<%= aShipperNo(i) %>" size="50" onKeyDown="return false;">
              &nbsp;&nbsp;&nbsp; <img src="../images/button_upload.gif" width="95" height="18" name="txtUpload" onClick="UpLoadClick(<%= aShipperNo(i) %>)"  style="cursor:hand">
              <% if mode_begin then %>
              <div style="width:21px; display:inline; vertical-align:text-bottom" onMouseOver="showtip('Click Browse to find the fine on your local computer, and click Attach Files to add it to the email.  This is useful for documents such as packing lists and commercial invoices.')";
onMouseOut="hidetip()"><img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
              <% end if %></td>
          </tr>
          <input name="ShipperFileCheck" type=hidden id="ShipperFileCheck<%= i %>">
          <input type=hidden id="hShipperFileIndex" name="hShipperFileIndex<%= i %>" value="<%= aShipperFileIndex(i) %>">
          <% for j=0 to aShipperFileIndex(i)-1 step 4%>
          <tr align="left" bgcolor="#FFFFFF">
            <td valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF"><em>
                    <input type=checkbox id="ShipperFileCheck<%= i %>" name="cShipperFileCheck<%= i %>,<%= j %>" value="Y" <% if aShipperFileCheck(i,j)="Y" then response.write("checked") %>><font color="#CC3300">Attachment 1:</font>
                    <a href= "javascript:void(viewPop('<%= aShipperFileURL(i,j) %>'));"><%= aShipperFileName(i,j) %></a><img src="../Images/spacer.gif" width="10" height="8"><img src="../images/button_delete.gif" align="absbottom" onClick="DeleteFile(<%= aShipperNo(i) %>,'<%= aShipperFileName(i,j) %>')"  style="cursor:hand"></em></td>
            <td colspan="4" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><em>
                <% if aShipperFileName(i,j+1) = "" then%>
                <%else%>
                <input type=checkbox id="ShipperFileCheck<%= i %>" name="cShipperFileCheck<%= i %>,<%= j+1 %>" value="Y" <% if aShipperFileCheck(i,j+1)="Y" then response.write("checked") %>><font color="#CC3300">Attachment 2:</font>
                <a href= "javascript:void(viewPop('<%= aShipperFileURL(i,j+1) %>'));"><%= aShipperFileName(i,j+1) %></a><img src="../Images/spacer.gif" width="10" height="8"><img src="../images/button_delete.gif" align="absbottom" onClick="DeleteFile(<%= aShipperNo(i) %>,'<%= aShipperFileName(i,j+1) %>')"  style="cursor:hand">
                <%end if%>
            </em></td>
            </tr>
          <tr align="left" bgcolor="#FFFFFF">
              <td valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
              <td align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
              <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF"><em>
                  <% if aShipperFileName(i,j+2) = "" then%>
                  <%else%>
                  <input type=checkbox id="ShipperFileCheck<%= i %>" name="cShipperFileCheck<%= i %>,<%= j+2 %>" value="Y" <% if aShipperFileCheck(i,j+2)="Y" then response.write("checked") %>><font color="#CC3300">Attachment 3:</font>
                  <a href= "javascript:void(viewPop('<%= aShipperFileURL(i,j+2) %>'));"><%= aShipperFileName(i,j+2) %></a><img src="../Images/spacer.gif" width="10" height="8"><img src="../images/button_delete.gif" align="absbottom" onClick="DeleteFile(<%= aShipperNo(i) %>,'<%= aShipperFileName(i,j+2) %>')"  style="cursor:hand">
                  <%end if%>
              </em></td>
              <td colspan="4" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><em>
                  <% if aShipperFileName(i,j+3) = "" then%>
                  <%else%>
                  <input type=checkbox id="ShipperFileCheck<%= i %>" name="cShipperFileCheck<%= i %>,<%= j+3 %>" value="Y" <% if aShipperFileCheck(i,j+3)="Y" then response.write("checked") %>><font color="#CC3300">Attachment 4:</font>
                  <a href= "javascript:void(viewPop('<%= aShipperFileURL(i,j+3) %>'));"><%= aShipperFileName(i,j+3) %></a><img src="../Images/spacer.gif" width="10" height="8"><img src="../images/button_delete.gif" align="absbottom" onClick="DeleteFile(<%= aShipperNo(i) %>,'<%= aShipperFileName(i,j+3) %>')"  style="cursor:hand">
                  <%end if%>
              </em></td>
              </tr>
          <% next %>
          <tr align="left">
            <td height="20" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
            <td colspan="7" align="left" valign="top" bgcolor="#f3f3f3" class="bodyheader">Message<br>
                <textarea name="txtShipperMSG<%= i %>" cols="100" rows="3" class="multilinetextfield"><%= aShipperMSG(i) %></textarea></td>
            </tr>
          
          <% next %>
        </table>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td height="1" colspan="6" align="left" valign="middle" bgcolor="#997132" class="bodycopy"></td>
          </tr>
		  <tr>
            <td align="center" valign="middle" bgcolor="#eec983" style="height: 24px"><img src="../images/button_send_email.gif" width="101" height="18" name="bSend" onClick="SendClick()"  style="cursor:hand"></td>
         </tr>
        </table>
      
    </td>
  </tr>
</table>
</form>
</body>

<script language=VBscript>
// Add search function 7/11/2006

/////////////////////////////
Sub Lookup()
/////////////////////////////
DIM mIndex,existMAWB,MAWB
 mIndex = "<%=mIndex%>"
	MAWB=UCase(document.form1.txtSMAWB.value)

	if NOT TRIM(MAWB) = "" then
		existMAWB = false
		For i=0 to mIndex
			if MAWB = UCase(document.form1.lstMAWB.item(i).text) then
				existMAWB = true
				exit for
			end if
		Next	
		
		if existMAWB then
				document.form1.lstMAWB.selectedIndex = i
				document.form1.action="delivery_confirm.asp?Edit=yes&rMAWB="& document.form1.txtsMAWB.value & "&WindowName=" & window.name
				document.form1.txtsMAWB.value = ""
				document.form1.method="POST"
				document.form1.target = "_self"
				form1.submit()
		else
				msgbox "MAWB # " & document.form1.txtSMAWB.value & " does not exist."
		end if		
	END IF
End Sub

/////////////////////////////
Sub LookupFile()
/////////////////////////////
DIM mIndex, existMJob, JobNo, mFile,sIndex,MAWB

mIndex = "<%=mIndex%>"
	JobNo=document.form1.lstSearchNum.value
	if NOT TRIM(JobNo) = "" then
		existMJob = false
		For i=0 to mIndex
			if Trim(Replace(JobNo,"-","")) = Trim(Replace(document.form1.lstFileNo.item(i).text,"-","")) then
				existMJob = true
				MAWB = document.form1.lstMAWB.item(i).text
				exit for
			end if
		Next	
	
		if existMJob then
				document.form1.lstSearchNum.value = ""
				document.form1.lstMAWB.selectedIndex = i
				document.form1.action="delivery_confirm.asp?Edit=yes&rMAWB="& MAWB & "&rtype=file&rFilename="& jobNo & "&WindowName=" & window.name
				document.form1.method="POST"
				document.form1.target = "_self"
				form1.submit()
		else
				msgbox "File # " & JobNo & " does not exist."
		end if		
	end if	
End Sub

Sub SendClick()

if document.form1.txtYourEmail.value = "" then
	msgbox "Please enter your email address!"
	exit sub
end if

if document.form1.txtYourName.value = "" then
	msgbox "Please enter your name!"
	exit sub
end if

tmpIndex =  "<%= sIndex %>"
if not tmpIndex ="" then
Mail_Due = 0
For iii = 0 To tmpIndex-1
	If document.all("ShipperCheck").item(iii+1).checked=True Then
		'// Modifed by Joon on Feb/07/2007 /////////////////////
		If document.all("txtShipperEmail" & iii).value = "" Then
	        MsgBox "Please, enter recipient's email address."
	        Exit Sub
	    Else
		    Mail_Due = Mail_Due + 1
		End If
	End if
Next

if Mail_Due = 0 Then
	MsgBox "Please check at least one item."
	Exit sub
End If

ParamH = Mail_Due * 20 + 120

jPopUp(ParamH)

if  document.all("hShipperHAWBIndex").item(1).Value = "" then
	document.form1.action= "delivery_confirmOK.asp?Send=yes&EMPHAWB=yes"
else
	document.form1.action= "delivery_confirmOK.asp?Send=yes"
end If
	document.form1.method="post"
	document.form1.target="popUpWindow"
	form1.submit()
else

    msgbox "Please Select AirBill or File No!"

end if
End Sub

'/////////////////////////////////////

Sub MAWBChange()
    dim master_NO,MAWB
    master_NO = document.form1.lstSearchNum.value
    If TRIM(master_NO) = "" then
        document.location.href="delivery_confirm.asp"
        MAWB = document.form1.lstMAWB.item(i).text
    Else
		For i=0 to mIndex
			if Trim(Replace(master_NO,"-","")) = Trim(Replace(document.form1.lstMAWB.item(i).text,"-","")) then
				MAWB = document.form1.lstMAWB.item(i).text
				exit for
			end if
		Next
		'document.form1.lstSearchType.selectedIndex
        document.form1.target="_self"
        document.form1.action="delivery_confirm.asp?Edit=yes&rMAWB="& master_NO& "&rtype=master&rFilename="& master_NO & "&WindowName=" & window.name
        document.form1.method="post"
        form1.submit()
    End if
End Sub

/// added by Joon on Dec-08-2006 /////////////////////////////////////

Sub HAWBChange()
    dim House_NO,MAWB
    House_NO = document.form1.lstSearchNum.value
    If House_NO = "" then
        document.location.href="delivery_confirm.asp"
    Else
        document.form1.action="delivery_confirm.asp?Edit=yes&rtype=house&rFilename="& house_NO & "&WindowName=" & window.name
        document.form1.method="post"
        document.form1.target="_self"
        form1.submit()
    End if 
End Sub

///////////////////////////////////////////////////////////////////////

Sub ShipperCheckClick(m)

	NoItem=document.all("hShipperHAWBIndex").item(m+1).Value
	NoIVItem=document.all("hShipperInvoiceIndex").item(m+1).Value
	NoFile=document.all("hShipperFileIndex").item(m+1).Value

if document.all("ShipperCheck").item(m+1).checked=True then

	if  document.all("hShipperHAWBIndex").item(m+1).Value = "" then
		document.all("MAWBShipperCheck").item(m+1).checked=True
     end if

     if Not NoItem = "" then
	     for i=0 to NoItem
	           if  not document.all("hShipperHAWBIndex").item(m+1).Value = ""  then
	                 document.all("ShipperHAWBCheck" & m).item(i+1).checked=True
	           end if
	     next
     end if

     if Not NoIVItem = "" then
	     for i=0 to NoIVItem-1
	           if  not document.all("hShipperInvoiceIndex").item(m+1).Value = ""  then
	                 document.all("ShipperInvoiceCheck" & m).item(i+1).checked=True
	           end if
	     next
	End if

	for i=0 to NoFile-1
		document.all("ShipperFileCheck" & m).item(i+1).checked=True
	next

else
	if  document.all("hShipperHAWBIndex").item(m+1).Value = "" then
		document.all("MAWBShipperCheck").item(m+1).checked=False
     end if

     if Not NoItem = "" then
	     for i=0 to NoItem
	           if  not document.all("hShipperHAWBIndex").item(m+1).Value = ""  then
	                 document.all("ShipperHAWBCheck" & m).item(i+1).checked=False
	           end if
	     next
     end if

     if Not NoIVItem = "" then
	     for i=0 to NoIVItem-1
	           if  not document.all("hShipperInvoiceIndex").item(m+1).Value = ""  then
	                 document.all("ShipperInvoiceCheck" & m).item(i+1).checked=False
	           end if
	     next
	end if

	for i=0 to NoFile-1
		document.all("ShipperFileCheck" & m).item(i+1).checked=False
	next
end if
end Sub

Sub UploadClick(OrgNo)

	if Not OrgNo="" then
		if document.all("File" & OrgNo).Value="" then
			MsgBox "Please select a file to upload!"
			exit Sub
		end if
		document.form1.action="delivery_confirm.asp?UP=yes&UpOrgNo=" & OrgNo
		document.form1.method="POST"
		document.form1.target="_self"
		form1.submit()
	end if
End Sub
Sub DeleteFile(OrgNo, dFileName)

// by iMoon DEC/01/2006 /////////////////////////////////
		document.form1.hDeleteFileName.value = dFileName
/////////////////////////////////////////////////////////

		document.form1.action="delivery_confirm.asp?RM=yes&UpOrgNo=" & OrgNo & "&dFileName=" & dFileName
		document.form1.method="POST"
		document.form1.target="_self"
		form1.submit()
End Sub
Sub MenuMouseOver()
  document.form1.lstMAWB.style.visibility="hidden"
End Sub
Sub MenuMouseOut()
  document.form1.lstMAWB.style.visibility="visible"
End Sub
Sub ShowEmailHistory

    jPopUpNormal()
	document.form1.action= "../../ASPX/MISC/EmailHistory.aspx?title=Shipping Noticey&ao=A&ie=E"
	document.form1.method="post"
	document.form1.target="popUpWindow"
	form1.submit()
	
End Sub
</script>
<!-- //for Tooltip// -->
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>

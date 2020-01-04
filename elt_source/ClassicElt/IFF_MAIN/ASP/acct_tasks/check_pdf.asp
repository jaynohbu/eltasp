<%@ LANGUAGE = VBScript %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html>
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Check Print</title>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/check_shared.asp" -->
<%
DIM oFile, PDF, reader, checkInfo,cType,detailItem

cType = Request.QueryString("cType")
checkInfo = Request.QueryString("p")

	if cType = "all" then
		if isnull(checkInfo) then
			 checkInfo = ""
		end if
		call main_process( checkInfo )
	else
		postBack = Request.QueryString("postBack")
        if PostBack = "" then PostBack = true
		if Not ( PostBack ) then
			detailItem = Request.QueryString("oi")
			%>
			<body>
			<form name=form1 method='post'>
					<input type="hidden" name="detailItem">		  
					<input type='hidden' name="txtDate">
					<input type='hidden' name="txtPrintCheckAs">
					<input type='hidden' name="txtAmount">
					<input type='hidden' name="txtMoney">
					<input type='hidden' name="txtVendorInfo">
					<input type='hidden' name="txtMemo">
					<input type='hidden' id="hBillNo">
					<input type='hidden' id="BillAmt">
					<input type="hidden" id="BillMemo">
					<% if detailItem > 0 then 
						 for i=0 to detailItem - 1 %>
							<input type='hidden' id="hBillNo" name="hBillNo<%= i %>">
							<input type='hidden' id="BillAmt" name="BillAmt<%= i %>">
							<input type='hidden' id="BillMemo" name="BillMemo<%= i %>">
					<%	 next 
						end if %>
			</form>
			<script language= 'javascript'>
				try
				{
				document.all('txtDate').value = parent.document.form1.txtDate.value;
				document.all('txtPrintCheckAs').value = parent.document.form1.txtVendor.value;
				document.all('txtVendorInfo').value = parent.document.form1.txtVendorInfo.value;
				document.all('txtAmount').value = parent.document.form1.txtAmount.value;
				document.all('txtMoney').value = parent.document.form1.txtMoney.value;
				document.all('txtMemo').value = parent.document.form1.txtMemo.value;
				document.all('detailItem').value = parent.document.form1.detailItem.value;
				var oi = document.all('detailItem').value;
				for(i=0; i < oi; i++)
				{
					document.all("hBillNo").item(i+1).value = parent.document.all("hBillNo").item(i+1).value;
					document.all("BillAmt").item(i+1).value = parent.document.all("BillAmt").item(i+1).value;
					document.all("BillMemo").item(i+1).value = parent.document.all("BillMemo").item(i+1).value;
				}
				document.form1.target="popUpWindow"
				document.form1.action = 'check_pdf.asp?cType=one';
				document.form1.target = '_self';
				document.form1.submit();
				}
				catch(f) {}
			</script>
			</body>
			<%
			response.end
		end if
		call main_process_single()
	end if

%>
<%
sub main_process_single
	DIM txtDate, txtVendor,txtVendorInfo,txtAmount,txtMoney,detailItem,txtMemo
	DIM aItem(),aAmt(),aMemo(),SQL, tmpBillNo,tmpBillAmt,tmpBillMemo,rs
On Error Resume Next:
	txtDate = Request("txtDate")
	txtVendor = Request("txtPrintCheckAs")
	txtVendorInfo = Request("txtVendorInfo")
	txtAmount = Request("txtAmount")
	txtMoney = Request("txtMoney")
	txtMemo = Request("txtMemo")
	detailItem = cInt(Request("detailItem"))
	
	ReDim aItem(detailItem),aAmt(detailItem),aMemo(detailItem)

	for i=0 to detailItem - 1
		aItem(i)=Request("hBillNo" & i)
		aAmt(i)=Request("BillAmt" & i)
		aMemo(i)=Request("BillMemo" & i)
	next

Set rs = Server.CreateObject("ADODB.Recordset")
DIM detailString,iv_no,bamount
	for  i=0 to detailItem - 1
	On Error Resume Next:
		tmpBillNo = aItem(i)
		tmpBillAmt = aAmt(i)
		tmpBillMemo = aMemo(i)
		if NOT tmpBillNo = "" and  isnull(tmpBillNo) = false then
			SQL= "select * from bill where elt_account_number = " & elt_account_number & " and bill_status='A' and bill_number=" & tmpBillNo
			Set rs = eltConn.execute (SQL)
			if NOT rs.eof and NOT rs.bof then
				iv_no = rs("ref_no")
				if NOT trim(iv_no) = "" then
					detailString = detailString & "I/V #: " & iv_no & " /  Bill #: " & rs("bill_number") & " ($" & formatNumber(tmpBillAmt,2) & ") / " & tmpBillMemo & chr(13)
				else
					detailString = detailString & "Bill #: " & rs("bill_number") & " ($" & formatNumber(tmpBillAmt,2) & ") / " & tmpBillMemo & chr(13)
				end if
			else
					detailString = detailString & "I/V #: " & tmpBillNo  & " ($" & formatNumber(tmpBillAmt,2) & ") / " & tmpBillMemo & chr(13)
			end if
			rs.Close	
		else
			detailString = detailString  & " ($" & formatNumber(tmpBillAmt,2) & ") / " & tmpBillMemo & chr(13)
		end if
	next

Set rs=Nothing

	call init_pdf

	PDF.SetFormFieldData "date",txtDate,0
	PDF.SetFormFieldData "payto",txtVendor,0
	PDF.SetFormFieldData "vendor_info",txtVendorInfo,0
	PDF.SetFormFieldData "amount",FormatNumber(txtAmount,2),0
	PDF.SetFormFieldData "dollars",txtMoney,0
	PDF.SetFormFieldData "memo",txtMemo,0
	PDF.SetFormFieldData "detail",detailString,0
	PDF.FlattenRemainingFormFields = True
	'// reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
	reader=PDF.CopyForm(0, 0)
	PDF.ResetFormFields	
	call close_pdf

end sub
%>

<%
sub main_process( checkInfo )
DIM rs,tmpArray,Pages, i, pos, vQueueID, vCheckNo

	tmpArray = Split(checkInfo,"^^^")
	Pages = ubound(tmpArray)

	if Pages <= 0 then
		exit sub
	end if

call init_pdf

Set rs = Server.CreateObject("ADODB.Recordset")

	for i=1 to Pages
		pos=instr(tmpArray(i),"@")
		if pos>0 then
			vQueueID= MID(tmpArray(i),1,pos-1)
			vCheckNo= MID(tmpArray(i),pos+1,10)
		else
			vQueueID=0
			vCheckNo=0
		end if
		call print_pdf ( vQueueID, vCheckNo )
	next

call close_pdf

Set rs=Nothing
end sub
%>

<% 
sub init_pdf

DIM CustomerForm,fso

oFile = Server.MapPath("../template")

Set PDF = Server.CreateObject("APToolkit.Object")
reader = PDF.OpenOutputFile("MEMORY")

'/////////////////////////////////////////////////////////////////////////
Set fso = CreateObject("Scripting.FileSystemObject")

CustomerForm=oFile & "/Customer/" & "Check" & elt_account_number & ".pdf"

If fso.FileExists(CustomerForm) Then
	reader = PDF.OpenInputFile(CustomerForm)
Else
	reader = PDF.OpenInputFile(oFile+"/Check.pdf")
End If
Set fso = nothing

response.buffer = True

end sub
%>

<%
sub print_pdf( vQueueID , vCheckNo )
DIM SQL
DIM Vendor,CheckAmt,Money,CheckDate,vMemo,aItem,NoDetailItem,Vendor_info
'DIM BillInvoiceNo(256),BillAmt(256),detailIndex
DIM detailString,iv_no,tmpBillAmt,tmpBillMemo
	SQL= "select * from check_queue where elt_account_number = " & elt_account_number & " and print_id=" & vQueueID

	Set rs = eltConn.execute (SQL)
	if NOT rs.eof and NOT rs.bof then
		CheckDate=rs("bill_date")
		Vendor=rs("print_check_as")
		Vendor_info=rs("vendor_info")
		vMemo=rs("memo")
		CheckAmt=rs("check_amt")
	end if
	rs.Close	

	SQL= "select *,isnull(invoice_no,'') as iv from check_detail where elt_account_number=" & elt_account_number & " and print_id=" & vQueueID

	Set rs = eltConn.execute (SQL)
	detailString = ""

	Do While Not rs.EOF
On error Resume Next :
		iv_no = rs("iv")
		tmpBillAmt = cDbl(rs("amt_paid"))
		tmpBillMemo = rs("memo")
		if NOT trim(iv_no) = "" then
			detailString = detailString & "I/V #: " & iv_no & " /  Bill #: " & rs("bill_number") & " ($" & formatNumber(tmpBillAmt,2) & ") / " & tmpBillMemo & chr(13)
		else
			detailString = detailString & "Bill #: " & rs("bill_number") & " ($" & formatNumber(tmpBillAmt,2) & ") / " & tmpBillMemo & chr(13)
		end if
		rs.MoveNext
	Loop
	rs.Close
	Money = ToMoney(CheckAmt)
	
	if isnull(CheckDate) then CheckDate = ""
	if isnull(Vendor) then Vendor = ""
	if isnull(vMemo) then vMemo = ""
	if isnull(detailString) then detailString = ""
	if isnull(vendor_info) then vendor_info = ""

On Error Resume Next :
	PDF.SetFormFieldData "date",CheckDate,0
	PDF.SetFormFieldData "payto",Vendor,0
	PDF.SetFormFieldData "vendor_info",vendor_info,0
	PDF.SetFormFieldData "amount",FormatNumber(CheckAmt,2),0
	PDF.SetFormFieldData "dollars",Money,0
	PDF.SetFormFieldData "memo",vMemo,0
	PDF.SetFormFieldData "detail",detailString,0
	PDF.FlattenRemainingFormFields = True
	'// reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
	reader=PDF.CopyForm(0, 0)
	PDF.ResetFormFields

end sub
%>

<%
sub close_pdf
DIM zz

PDF.CloseOutputFile
zz=PDF.BinaryImage

response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"
response.AddHeader "Content-Disposition", "inline; filename=Check.pdf"
response.BinaryWrite zz

set PDF=nothing

end sub
%>
</html>
<%
response.end
%>




<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%

    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<% 

    '// Copied from header.asp /////////////////////////////////////////////////////
    
    Dim elt_account_number,login_name,user_id,ClientOS,session_ip,session_IntIp
    Dim session_server_name,session_user_lname,redPage
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	ClientOS = Request.Cookies("CurrentUserInfo")("ClientOS")
	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_user_lname = Request.Cookies("CurrentUserInfo")("lname")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")
	
	'////////////////////////////////////////////////////////////////////////////////

Dim MAWB,vHAWB,vAgent,vMasterAgent,vOrgAcct
Dim aOrgInfo(5)
Dim vAgentName
Dim aHAWB(64),aRCVL(64),aPYBL(64),aPS(64),aDebit(64),aCredit(64),aOCarrier(64),aOAgent(64)
Dim aAgentChg(64),aCarrierChg(64),aTotalDue(64)
Dim rs, SQL
Set rs = Server.CreateObject("ADODB.Recordset")
'InvoiceNo=Request.QueryString("InvoiceNo")
MAWB=Request.QueryString("MAWB")
AgentNo=Request.QueryString("AgentNo")
'vInvoiceDate=Request.QueryString("InvoiceDate")

if Not MAWB="" And Not AgentNo="" then
'get org info
	SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone from agent where elt_account_number = " & elt_account_number

	rs.Open SQL, eltConn, , , adCmdText	
	If Not rs.EOF Then
		aOrgInfo(0)=rs("dba_name")
		aOrgInfo(1)=rs("business_address")
		aOrgInfo(2)=rs("business_city") & "," & rs("business_state") & " " & rs("business_zip")
		aOrgInfo(3)=rs("business_country")
		aOrgInfo(4)=rs("business_phone")
	End If
	rs.Close
	SQL = "select c.file#,a.hawb_num,a.agent_name,a.by_1,a.departure_airport,a.flight_date_1,a.dest_airport,a.total_weight_charge_hawb,a.ppo_1,a.af_cost,a.agent_profit,a.agent_profit_share,a.other_agent_profit_carrier,other_agent_profit_agent,b.coll_prepaid,b.carrier_agent,sum(b.amt_hawb) as chg from hawb_master a LEFT OUTER JOIN hawb_other_charge b "
	SQL = SQL & " on (a.elt_account_number=b.elt_account_number and a.hawb_num=b.hawb_num)"
	SQL = SQL & " LEFT OUTER JOIN mawb_number c on (a.elt_account_number=c.elt_account_number and a.mawb_num=c.mawb_no)"
	SQL = SQL & " where a.elt_account_number = " & elt_account_number & " and a.mawb_num='" & MAWB & "' and a.agent_no=" & AgentNo
	SQL = SQL & " group by c.file#,a.hawb_num,a.agent_name,a.by_1,a.departure_airport,a.flight_date_1,a.dest_airport,a.ppo_1,a.total_weight_charge_hawb,a.af_cost,a.agent_profit,a.agent_profit_share,a.other_agent_profit_carrier,a.other_agent_profit_agent,b.coll_prepaid,b.carrier_agent order by a.hawb_num,b.carrier_agent"
	rs.Open SQL, eltConn, , , adCmdText

'response.write SQL
'response.end
'// get smtp data from ocean
'///////////////////////////
	if rs.eof then
		rs.close
		SQL = get_ocean_smtp_sql
		rs.Open SQL, eltConn, , , adCmdText
	end if
'///////////////////////////

	tIndex=0
	if Not rs.EOF then
		vAgentName=rs("Agent_name")
		vCarrier=rs("by_1")
		vDeptAirPort=rs("departure_airport")
		vFlightNo=rs("flight_date_1")
		vDestAirport=rs("dest_airport")
		pos=0
        vFileNo = rs("file#")
		LastHAWB = rs("hawb_num")
		aHAWB(0) = rs("hawb_num")
		vFreightPrepay = rs("ppo_1")
		if vFreightPrepay = "Y" then
			aRCVL(0)=0
		else
			aRCVL(0)=cDbl(rs("total_weight_charge_hawb"))
		end if
		if Not IsNull(rs("agent_profit")) then
			aCredit(0)=cDbl(rs("agent_profit"))
		else
			aCredit(0)=0
		end if
		if vFreightPrepay="Y" then
			aPYBL(0)=0
		else
			if Not IsNull(rs("af_cost")) then
				aPYBL(0)=cDbl(rs("af_cost"))
			else
				aPYBL(0)=0
			end if
		end if
		if Not IsNull(rs("other_agent_profit_carrier")) then
			aOCarrier(0)=cDbl(rs("other_agent_profit_carrier"))
		else
			aOCarrier(0)=0
		end if
		if Not IsNull(rs("other_agent_profit_agent")) then
			aOAgent(0)=cDbl(rs("other_agent_profit_agent"))
		else
			aOAgent(0)=0
		end if
		aTotalDue(0)=aRCVL(0)-aCredit(0)-aOAgent(0)-aOCarrier(0)
		GrandTotal=aTotalDue(0)
		Do While Not rs.EOF
			CurrHAWB=rs("hawb_num")
			if Not LastHAWB=CurrHAWB then
				tIndex=tIndex+1
				aHAWB(tIndex)=CurrHAWB
				vFreightPrepay=rs("ppo_1")
				if vFreightPrepay="Y" then
					aRCVL(tIndex)=0
				else
					aRCVL(tIndex)=cDbl(rs("total_weight_charge_hawb"))
				end if
				if Not IsNull(rs("agent_profit")) then
					aCredit(tIndex)=cDbl(rs("agent_profit"))
				else
					aCredit(tIndex)=0
				end if
				if vFreightPrepay="Y" then
					aPYBL(tIndex)=0
				else
					if Not IsNull(rs("af_cost")) then
						aPYBL(tIndex)=cDbl(rs("af_cost"))
					else
						aPYBL(tIndex)=0
					end if
				end if
				if Not IsNull(rs("other_agent_profit_carrier")) then
					aOCarrier(tIndex)=cDbl(rs("other_agent_profit_carrier"))
				else
					aOCarrier(tIndex)=0
				end if
				if Not IsNull(rs("other_agent_profit_agent")) then
					aOAgent(tIndex)=cDbl(rs("other_agent_profit_agent"))
				else
					aOAgent(tIndex)=0
				end if
				aTotalDue(tIndex)=aRCVL(tIndex)-aCredit(tIndex)-aOAgent(tIndex)-aOCarrier(tIndex)
				GrandTotal=GrandTotal+aTotalDue(tIndex)
			end if
			if rs("carrier_agent")="A" then
				if rs("coll_prepaid")="C" then
					aAgentChg(tIndex)=cDbl(rs("chg"))
				else
					aAgentChg(tIndex)=0
				end if
				aTotalDue(tIndex)=aTotalDue(tIndex)+aAgentChg(tIndex)
				GrandTotal=GrandTotal+aAgentChg(tIndex)
			elseif rs("carrier_agent")="C" then
				if rs("coll_prepaid")="C" then
					aCarrierChg(tIndex)=cDbl(rs("chg"))
				else
					aCarrierChg(tIndex)=0
				end if
				aTotalDue(tIndex)=aTotalDue(tIndex)+aCarrierChg(tIndex)
				GrandTotal=GrandTotal+aCarrierChg(tIndex)
			end if
			LastHAWB=CurrHAWB
			rs.MoveNext
		Loop
		rs.Close
	end if

end if
GrandTotal="USD " & FormatNumber(GrandTotal,2)
if tIndex="" then tIndex=1
Dim Pages,PageMod
Pages=Fix((tIndex+1)/4)
PageMod=tIndex mod 4
if PageMod<3 then Pages=Pages+1
response.buffer = True


DIM oFile,LogoName
oFile = Server.MapPath("../template")

Set fso = CreateObject("Scripting.FileSystemObject")
Dim CustomerForm
CustomerForm=oFile & "/Customer/" & "agent_stmt" & elt_account_number & ".pdf"

Set PDF = GetNewPDFObject()
'// Set PDF=Server.CreateObject("APtoolkit.Object")
r = PDF.OpenOutputFile("MEMORY")

If fso.FileExists(CustomerForm) Then
'// Customer has a specific invoice form
	r = PDF.OpenInputFile(CustomerForm)
Else
'// Normal Form
	r = PDF.OpenInputFile(oFile+"/agent_stmt.pdf")
End If

Set fso = nothing

On Error Resume Next:
r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
for j=1 to Pages
	PDF.SetFormFieldData "CompanyName",aOrgInfo(0),0
	PDF.SetFormFieldData "Address1",aOrgInfo(1),0
	PDF.SetFormFieldData "Address2",aOrgInfo(2),0
	PDF.SetFormFieldData "FileNo",vFileNo,0
	PDF.SetFormFieldData "BillTo",vAgentName,0
	PDF.SetFormFieldData "Carrier",vCarrier,0
	PDF.SetFormFieldData "Date",Date,0
	PDF.SetFormFieldData "MAWB",MAWB,0
	PDF.SetFormFieldData "Page",j,0
	PDF.SetFormFieldData "FlightNo",vFlightNo,0
	PDF.SetFormFieldData "DepAP",vDeptAirport,0
	PDF.SetFormFieldData "DestAP",vDestAirport,0
	for i=(j-1)*4 to 4*j-1
		PDF.SetFormFieldData "HAWB" & 1+i-(j-1)*4,aHAWB(i),0
		PDF.SetFormFieldData "FreightCollect" & 1+i-(j-1)*4,FormatNumber(aRCVL(i),2),0
		PDF.SetFormFieldData "FreightCost" & 1+i-(j-1)*4,FormatNumber(-aPYBL(i),2),0
		PDF.SetFormFieldData "AF" & 1+i-(j-1)*4,FormatNumber((aRCVL(i)-aPYBL(i)),2),0
		PDF.SetFormFieldData "Debit" & 1+i-(j-1)*4,FormatNumber(aRCVL(i),2),0
		PDF.SetFormFieldData "ProfitShare" & 1+i-(j-1)*4,FormatNumber(aCredit(i),2),0
		PDF.SetFormFieldData "OtherAgent" & 1+i-(j-1)*4,FormatNumber(aAgentChg(i),2),0
		PDF.SetFormFieldData "OtherCarrier" & 1+i-(j-1)*4,FormatNumber(aCarrierChg(i),2),0
		PDF.SetFormFieldData "OPSAgent" & 1+i-(j-1)*4,FormatNumber(aOAgent(i),2),0
		PDF.SetFormFieldData "OPSCarrier" & 1+i-(j-1)*4,FormatNumber(aOCarrier(i),2),0
		PDF.SetFormFieldData "Due" & 1+i-(j-1)*4,FormatNumber(aTotalDue(i),2),0
	next
		PDF.SetFormFieldData "test",j & Pages,0
	if j=Pages then
		PDF.SetFormFieldData "GrandTotal1","Grand Total",0
		PDF.SetFormFieldData "GrandTotal2",GrandTotal,0
	else
		PDF.SetFormFieldData "GrandTotal1","",0
		PDF.SetFormFieldData "GrandTotal2","",0
	end if
	'// PDF.FlattenRemainingFormFields = True
	r = PDF.CopyForm(0, 0)
	PDF.ResetFormFields
next

PDF.CloseOutputFile

response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"
response.AddHeader "Content-Disposition", "attachment; filename=AST" & Session.SessionID & ".pdf"
WritePDFBinary(PDF)
set PDF=nothing

response.end
%>
<!--  #INCLUDE FILE="stmt_ocean_sql.inc" -->
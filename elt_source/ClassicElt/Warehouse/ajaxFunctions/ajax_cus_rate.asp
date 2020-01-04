<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" --> 
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
 'Customer Selling Rate	: '4' in Oiginal table 
 dim rs, SQL 
 dim vConsigneeAcct 
 dim vWeight,origWeight
 dim rate
 
 dim minAmount
 dim min_break(3)
    
 vConsigneeAcct=request.QueryString("cusAcc") 
 dim vAirline
 vAirline=request.QueryString("airline")
 if vAirline="" then
    vAirline="-1"
 end if 
 if Not isnumeric(vAirline) then
    response.Write("0")
    response.End()
 end if 
 dim UNIT
 dim vTo 
 vTo=request.QueryString("arp")
 dim vOriginPortID 
 vOriginPortID=request.QueryString("dep")
 dim vUnit 
 vUnit=request.QueryString("Unit")
 dim vOrigUnit
 vOrigUnit=vUnit
  
 vWeight=request.QueryString("wgt") 
 origWeight=request.QueryString("wgt") 
 dim elt_account_number 
 elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")

  
 
 if vConsigneeAcct<>"" and vAirline <>"" and vTo<>"" and vOriginPortID<>"" and vUnit<>"" and vWeight <>"" then   
   
   CALL GET_UNIT
   
   if vUnit ="K" and UNIT="L" then 
         vUnit="L" 
         vWeight = vWeight * 2.20462262  
   else 
       if vUnit ="L" and UNIT="K" then 
         vUnit="K"
         vWeight =vWeight  /2.20462262  
       end if
   end if 
     
   CALL PREPARE_QUERY_STRING
   
   Set rs = Server.CreateObject("ADODB.Recordset")
   rs.Open SQL, eltConn, , , adCmdText 
   if rs.eof then
      rs.Close() 
      response.Write("0")
      response.End
   else 
      rate=rs("rate") 
      call CHECK_MINIMUM
      '------------convert according to unit--------------------   
      if vOrigUnit ="K" and UNIT="L" then 
	 		
            rate = cdbl(rate) * 2.20462262
            'origWeight=clng(origWeight)/2.20462262
			
      else 
           if vOrigUnit ="L" and UNIT="K" then 
             rate =cdbl(rate) /2.20462262  
             'origWeight=clng(origWeight)*2.20462262
           end if
      end if 
      '----------------------------------------------------------
      tempAmt=origWeight*cdbl(rate)
      
      if tempAmt > clng(minAmount) then 
        response.Write  rate
         rs.close()
        response.End
      else 
        response.Write "-" & minAmount
         rs.close()
        response.End
      end if 
     
   end if
    Set rs = Nothing 
else 
    response.Write("0") 
    response.End
end if 


Sub PREPARE_QUERY_STRING
    tWeight=vWeight+1
    SQL= "select rate, weight_break from all_rate_table"					
    SQL=SQL & " where elt_account_number=" & elt_account_number 
    SQL=SQL & " and customer_no= " & vConsigneeAcct   
    SQL=SQL & " and (airline=" & vAirline & " or airline=-1)"
    SQL=SQL & " and origin_port='" & vOriginPortID & "'"
    SQL=SQL & " and dest_port='" & vTo &"'" 
    SQL=SQL & " and weight_break = ( select max (weight_break) from all_rate_table "
    SQL=SQL & " where elt_account_number =" & elt_account_number & " and rate_type=4 and kg_lb ='" & vUnit &"'" 
    SQL=SQL & " and customer_no="& vConsigneeAcct& " and weight_break <=" & tWeight
    SQL=SQL & " and (airline=" & vAirline & " or airline=-1) and origin_port='" & vOriginPortID & "'"
    SQL=SQL & " and dest_port='" & vTo &"')" 
End Sub 

  
Sub CHECK_MINIMUM
    dim rs
    set rs=Server.CreateObject("ADODB.Recordset")
    SQL= "select  top 3 rate, weight_break  from all_rate_table"
    SQL=SQL & " where elt_account_number =" & elt_account_number & " and rate_type=4 and kg_lb ='" & vUnit &"'" 
    SQL=SQL & " and customer_no="& vConsigneeAcct&" and weight_break >= 0" 
    SQL=SQL & " and (airline=" & vAirline & " or airline=-1) and origin_port='" & vOriginPortID & "'"
    SQL=SQL & " and dest_port='" & vTo &"' order by weight_break" 

    rs.Open SQL, eltConn, , , adCmdText 
    i=0
    if rs.eof = true then
        exit sub
    end if 
    
    do while not rs.eof
     min_break(i)=cLng(rs("weight_break"))
     if i=0 then
        minAmount=rs("rate")
     end if
     rs.moveNext
     i=i+1
    loop 
    rs.Close()
    if min_break(0) <= clng(vWeight) and  clng(vWeight) < min_break(1)  then   
       response.Write "-" & minAmount
       response.End
    end if 
    SQL=""
    Set rs=Nothing 
End Sub 


Sub GET_UNIT
    dim rs
    set rs = Server.CreateObject("ADODB.Recordset")
    SQL= "select top 1 kg_lb from all_rate_table"	
    SQL=SQL & " where elt_account_number =" & elt_account_number & " and rate_type=4 " 
    SQL=SQL & " and customer_no="& vConsigneeAcct 
    SQL=SQL & " and (airline=" & vAirline & " or airline=-1) and origin_port='" & vOriginPortID & "'"
    SQL=SQL & " and dest_port='" & vTo &"'" 
   
    rs.Open SQL, eltConn, , , adCmdText
    
    if rs.eof or rs.bof then
        rs.close()
        response.Write("0")
        response.End       
    end if 
    UNIT=rs("kg_lb")
    rs.close()
    SQL=""
    set rs = Nothing 
End Sub 
%>

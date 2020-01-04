<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>   

<html xmlns="http://www.w3.org/1999/xhtml">
<head>  
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Ship Out Detail</title>
    <link href="/ASP/css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style8 {color: #cc6600;
            font-weight: bold;
        }
        body {
            margin-top: 0px;
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style9 {color: #999999}
        .style10 {color: #cc6600}
    </style>  
    <script type="text/javascript"  src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="/ASP/include/JPED.js"></script>
    
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/Header.asp" -->
<!--  #include VIRTUAL="/ASP/include/recent_file.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->

<% 
    Dim vMode,OP,dataTable,WRTableList,i,j,WRDBTableList,vOrg,vOrgN
    eltConn.BeginTrans
    vMode = checkBlank(Request.QueryString("mode"),"New")    
    OP = checkBlank(Request.QueryString("OP"),"")
    vOrg = checkBlank(Request.QueryString("n"),"")
    vOrgN = checkBlank(Request.QueryString("o"),"")    
    Set dataTable = Server.CreateObject("System.Collections.HashTable")
    Set WRTableList = Server.CreateObject("System.Collections.ArrayList")
    Set WRDBTableList = Server.CreateObject("System.Collections.ArrayList")    
    main_proc()    
    eltConn.CommitTrans
    
 Sub main_proc
        If vMode = "SaveAsNew" Then
            If GetPrefixFileNumber("SO", elt_account_number, "") = "" Then
                Response.Write("<script> alert('Please, set a shipout number on prefix manager page.'); window.location.href='shipout_detail.asp'; </script>")
                Response.End()
            Elseif IsDataExist("SELECT * FROM warehouse_shipout where so_num='" & GetPrefixFileNumber("SO", elt_account_number, "") & "' AND elt_account_number=" & elt_account_number) Then
                Response.Write("<script> alert('Please, reset a shipout number on prefix manager page.'); window.location.href='shipout_detail.asp'; </script>")
                Response.End()
            End If
            dataTable.Add "so_num", GetPrefixFileNumber("SO", elt_account_number, "")
            Call get_shipout_header()
            Set WRTableList = get_warehouse_list()            
            If update_warehouse_receipt() Then
                update_warehouse_history
                update_warehouse_shipout()                
            Else
                Response.Write("<script> alert('Ship-out could not complete.'); window.location.href='shipout_detail.asp'; </script>")
                Response.End()
            End If
        Elseif vMode = "Update" Then
            dataTable.Add "so_num", Request.Form.Item("txtSONum")
            Call get_shipout_header()
            Set WRTableList = get_warehouse_list()
            Set WRDBTableList = get_warehouse_list_DB() 
            If update_warehouse_receipt Then       
                update_warehouse_shipout()
                update_warehouse_history()    
            Else
                Response.Write("<script> alert('Ship-out could not complete.'); </script>")
                Response.End()
            End If
        Elseif vMode = "view" And checkBlank(Request.QueryString("so"),"") <> "" Then
            get_all_info()
    
        ElseIf vMode = "Reload" Then
            get_all_info2(vOrg)
    
        Elseif vMode = "delete" And checkBlank(Request.Form.Item("txtSONum"),"") <> "" Then
            dataTable.Add "so_num", Request.Form.Item("txtSONum")
            Call get_shipout_header()
            Set WRDBTableList = get_warehouse_list_DB()
            delete_warhouse_shipout()
            Set dataTable = Server.CreateObject("System.Collections.HashTable")
        End If        
        Set WRTableList = get_warehouse_list_DB()      
    End Sub
    
'// ---------------------------------------------------------------------------------------------

    Sub get_all_info()
        Dim SQL,dataObj,rs,so_num,uid
        so_num = checkBlank(Request.QueryString("so"),0)
        
        SQL = "SELECT TOP 1 * FROM warehouse_shipout WHERE elt_account_number=" & elt_account_number _
            & " AND so_num='" & so_num &"'"
      ' response.Write SQL
    'response.end
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)
    End Sub
    
    Sub get_all_info2(vOrg)
        Dim SQL,dataObj,rs,so_num,uid
        uid = vOrg
        
        SQL = "SELECT TOP 1 * FROM warehouse_shipout WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & uid
        
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)
    End Sub
    
    
    
    Function get_warehouse_list_DB()
    
        Dim i,tmpTable,dataObj,SQL,vSONum
        vSONum = checkBlank(dataTable("so_num"),"")
        
        SQL = "SELECT a.*, b.received_date,b.customer_ref_no,b.PO_NO,b.shipper_acct,b.item_desc  " _
            & " FROM warehouse_history a LEFT OUTER JOIN warehouse_receipt b " _
            & " ON (a.elt_account_number=b.elt_account_number AND a.wr_num=b.wr_num) "_
            & " WHERE a.so_num=N'" & vSONum _
            & "' And a.elt_account_number=" & elt_account_number & " AND a.history_type='Ship-out Made'"
        
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set get_warehouse_list_DB = dataObj.GetDataList()
    End Function
    
    Function get_warehouse_list()
        Dim tmpTable,i,resList
        
        Set resList = Server.CreateObject("System.Collections.ArrayList")
        For i=1 To Request.Form.Item("hWRNum").Count
            If(checkBlank(Request.Form.Item("hWRValue")(i),"") <> "") Then
                Set tmpTable = Server.CreateObject("System.Collections.HashTable")
                tmpTable.Add "auto_uid", Request.Form.Item("hWRValue")(i)
                tmpTable.Add "wr_num", Request.Form.Item("hWRNum")(i)
                tmpTable.Add "item_piece_remain", Request.Form.Item("txtRemainPiece")(i)
                tmpTable.Add "item_piece_shipout", Request.Form.Item("txtPiece")(i)
                tmpTable.Add "item_piece_origin", Request.Form.Item("txtOriginPiece")(i)
                tmpTable.Add "item_piece_available", Request.Form.Item("hAvailablePiece")(i)
                tmpTable.Add "item_piece_shipped", Request.Form.Item("txtShippedPiece")(i)
                resList.Add tmpTable
            End If
        Next
        Set get_warehouse_list = resList
    End Function
    
    Sub get_shipout_header
   
        dataTable.Add "elt_account_number", elt_account_number       
        dataTable.Add "carrier_ref_no", Request.Form.Item("txtCarrierRefNo")
        dataTable.Add "customer_ref_no", Request.Form.Item("txtCustomerRefNo")   
        dataTable.Add "PO_NO", Request.Form.Item("txtPONO")                
        dataTable.Add "created_date", Request.Form.Item("txtSODate")       
        dataTable.Add "customer_acct", Request.Form.Item("hAccountOfAcct")      
        dataTable.Add "trucker_acct", Request.Form.Item("hTruckerAcct") 
        dataTable.Add "other_info", Request.Form.Item("txtRemarks")
        dataTable.Add "consignee_acct", Request.Form.Item("hShipToAcct")
        dataTable.Add "customer_contact" , Request.Form.Item("txtAccountOfContact")
        dataTable.Add "shipout_date", Request.Form.Item("txtShipOutDate")
        dataTable.Add "received_date", Request.Form.Item("txtReceivedDate")   
        dataTable.Add "shipper_info", Request.Form.Item("txtShipToInfo")   
    End Sub

    Function update_warehouse_shipout
        Dim resVal,dataObj,so_num,SQL,uid
   
        resVal = False
        
        so_num = dataTable("so_num")
        
        If so_num = "" Then
            Response.Write("<script>alert('Ship-out could not complete. Please, add a ship-out prefix on company information page'); window.location.href='shipout_detail.asp'; </script>")
            Response.End()
        End IF
        
        Set dataObj = new DataManager

        dataTable.Add "shipout_status", "Complete"

        SQL = "SELECT * FROM warehouse_shipout WHERE elt_account_number=" & elt_account_number _
            & " AND so_num=N'" & so_num & "'" 
   
     
        dataObj.SetColumnKeys("warehouse_shipout")
        
        If dataObj.UpdateDBRow(SQL, dataTable) Then 
  
        '// If successful
            If vMode = "SaveAsNew" Then
                Call SetNextPrefixFileNumber("SO", elt_account_number,"")
  
            End If
            resVal = True
        Else
            Response.Write("<script>alert('Ship-out could not complete. Please, try again.'); window.location.href='shipout_detail.asp'; </script>")
        End If
        update_warehouse_shipout = resVal
        
    End Function
    
    Function update_warehouse_receipt
        Dim i,SQL,historyRS,WRRS,vTmpPiece,resVal
        
        resVal = True
        For i=0 To WRTableList.Count-1
            vTmpPiece = 0
            If vMode = "Update" Then
                vTmpPiece = CDbl(WRTableList(i)("item_piece_shipout")) - CDbl(WRTableList(i)("item_piece_shipped"))
            Else
                '// Inserting case
                vTmpPiece = CDbl(WRTableList(i)("item_piece_shipout"))
            End If

            SQL = "SELECT * FROM warehouse_receipt WHERE wr_num=N'" & WRTableList(i)("wr_num") _
                & "' AND elt_account_number=" & elt_account_number
            
            
            Set WRRS = Server.CreateObject("ADODB.RecordSet")
            WRRS.CursorLocation = adUseClient	
	        WRRS.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
  
            If NOT WRRS.EOF AND NOT WRRS.BOF Then
    'response.Write CDbl(WRRS("item_piece_remain"))
                WRRS("item_piece_remain") = CDbl(WRRS("item_piece_remain"))-CDbl(vTmpPiece)
                
                If CDbl(WRRS("item_piece_remain").value) < 0 Then
                    resVal = False
                Else
                    WRRS.Update()
                    WRRS.Close()
                End If
            Else
                resVal = False
            End If
        Next
      
        update_warehouse_receipt = resVal
    End Function


    Function update_warehouse_history

        Dim tmpChangeVal
        
        For i=0 To WRTableList.Count-1

            For j=0 To WRDBTableList.Count-1
                tmpChangeVal = 0
                If j < WRDBTableList.Count Then
                    If j < WRDBTableList.Count And WRTableList(i)("wr_num") = WRDBTableList(j)("wr_num") Then
                        '// Edit Case
                        tmpChangeVal = CDbl(WRTableList(i)("item_piece_shipout")) - CDbl(WRDBTableList(j)("item_piece_shipout"))
                        Call edit_warehouse_history(WRDBTableList(j),tmpChangeVal)
                        WRDBTableList.removeAt(j)
                    End If
                End If
            Next

            If j = WRDBTableList.Count Then
                '// Add Case OK
                tmpChangeVal = CDbl(WRTableList(i)("item_piece_shipout"))
                Call insert_warehouse_history(WRTableList(i),tmpChangeVal)
            End If

        Next

        For j=0 To WRDBTableList.Count-1
            '// Delete Case - add tmpChangeVal to remain pcs for Shipout greater and delete current SO
            tmpChangeVal = CDbl(WRDBTableList(j)("item_piece_shipout"))
            Call delete_warehouse_history(WRDBTableList(j),tmpChangeVal)
        Next
    End Function 

    Sub insert_warehouse_history(vWRTable,vChangeVal)
        Dim SQL,dataObj,tempTable,historyRS
        
        Set dataObj = new DataManager
        
        SQL = "SELECT * FROM warehouse_history where ISNULL(so_num,'')=N'" & dataTable("so_num") _
            & "' AND wr_num=N'" & vWRTable("wr_num") & "' AND history_type='Ship-out Made' " _
            & "AND elt_account_number=" & elt_account_number 
        
        
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        tempTable.Add "so_num", dataTable("so_num")
        tempTable.Add "wr_num", vWRTable("wr_num")
        tempTable.Add "elt_account_number", elt_account_number
        tempTable.Add "history_type", "Ship-out Made"
        tempTable.Add "item_piece_origin", vWRTable("item_piece_origin")
        tempTable.Add "item_piece_shipout", vChangeVal
        tempTable.Add "item_piece_remain", CDbl(vWRTable("item_piece_remain")) - vChangeVal
        
        dataObj.SetColumnKeys("warehouse_history")
        Call dataObj.UpdateDBRow(SQL, tempTable)

        '// Update Later remain values
        SQL = "SELECT * FROM warehouse_history where ISNULL(so_num,'')>N'" & dataTable("so_num") _
            & "' AND wr_num=N'" & vWRTable("wr_num") & "' AND history_type='Ship-out Made' " _
            & "AND elt_account_number=" & elt_account_number 
        
        
        Set historyRS = Server.CreateObject("ADODB.RecordSet")
        historyRS.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText

        DO While NOT historyRS.EOF AND NOT historyRS.BOF
            historyRS("item_piece_remain") = CDbl(historyRS("item_piece_remain")) - vChangeVal
            historyRS.update()
            historyRS.MoveNext()
        Loop
        
        historyRS.Close()
        
    End Sub
    
    
    Sub edit_warehouse_history(vWRTable,vChangeVal)
        Dim SQL,dataObj,tempTable,historyRS
        
        Set dataObj = new DataManager
        
        SQL = "SELECT * FROM warehouse_history where ISNULL(so_num,'')=N'" & dataTable("so_num") _
            & "' AND wr_num=N'" & vWRTable("wr_num") & "' AND history_type='Ship-out Made' " _
            & "AND elt_account_number=" & elt_account_number 
        
        
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        tempTable.Add "so_num", dataTable("so_num")
        tempTable.Add "wr_num", vWRTable("wr_num")
        tempTable.Add "elt_account_number", elt_account_number
        tempTable.Add "history_type", "Ship-out Made"
        tempTable.Add "item_piece_origin", vWRTable("item_piece_origin")
        tempTable.Add "item_piece_shipout", CDbl(vWRTable("item_piece_shipout")) + vChangeVal
        tempTable.Add "item_piece_remain", CDbl(vWRTable("item_piece_remain")) - vChangeVal

        dataObj.SetColumnKeys("warehouse_history")
        Call dataObj.UpdateDBRow(SQL, tempTable)

        '// Update Laster remain values
        SQL = "SELECT * FROM warehouse_history where ISNULL(so_num,'')>N'" & dataTable("so_num") _
            & "' AND wr_num=N'" & vWRTable("wr_num") & "' AND history_type='Ship-out Made' " _
            & "AND elt_account_number=" & elt_account_number 
        
        
        Set historyRS = Server.CreateObject("ADODB.RecordSet")
        historyRS.Open SQL,eltConn,adOpenDynamic,adLockOptimistic,adCmdText

        DO While NOT historyRS.EOF AND NOT historyRS.BOF
            historyRS("item_piece_remain") = CDbl(historyRS("item_piece_remain")) - vChangeVal
            historyRS.update()
            historyRS.MoveNext()
        Loop
        
        historyRS.Close()
        
    End Sub
    
    Sub delete_warehouse_history(vWRTable,vChangeVal)
        Dim SQL,dataObj,tempTable,historyRS
        
        Set dataObj = new DataManager
        
        '// Note: updating WR as well
        SQL = "BEGIN TRANSACTION " _
            & "UPDATE warehouse_receipt SET item_piece_remain=(item_piece_remain+" & vChangeVal _
            & ") WHERE wr_num=N'" & vWRTable("wr_num") & "' AND elt_account_number=" & elt_account_number _
            & " DELETE FROM warehouse_history where ISNULL(so_num,'')=N'" & dataTable("so_num") _
            & "' AND wr_num=N'" & vWRTable("wr_num") & "' AND history_type='Ship-out Made' " _
            & "AND elt_account_number=" & elt_account_number _
            & " COMMIT"
        
            
        Set historyRS = Server.CreateObject("ADODB.RecordSet")
        Set historyRS = eltConn.execute(SQL)

        '// Update Laster remain values
        SQL = "SELECT * FROM warehouse_history where ISNULL(so_num,'')>N'" & dataTable("so_num") _
            & "' AND wr_num=N'" & vWRTable("wr_num") & "' AND history_type='Ship-out Made' " _
            & "AND elt_account_number=" & elt_account_number 
        
        
        Set historyRS = Server.CreateObject("ADODB.RecordSet")
        historyRS.Open SQL,eltConn,adOpenDynamic,adLockOptimistic,adCmdText

        DO While NOT historyRS.EOF AND NOT historyRS.BOF
            historyRS("item_piece_remain") = CDbl(historyRS("item_piece_remain")) + vChangeVal
            historyRS.update()
            historyRS.MoveNext()
        Loop
    End Sub
    
    Sub delete_warhouse_shipout

        Dim SQL,historyRS
        
        SQL = "BEGIN TRANSACTION "

        For i=0 To WRDBTableList.Count-1
            SQL = SQL & "UPDATE warehouse_receipt SET item_piece_remain=(item_piece_remain+" _
            & WRDBTableList(i)("item_piece_shipout") & ") WHERE wr_num=N'" & WRDBTableList(i)("wr_num") _
            & "' AND elt_account_number=" & elt_account_number & " " _
            & "UPDATE warehouse_history SET item_piece_remain=(item_piece_remain+" _
            & WRDBTableList(i)("item_piece_shipout") & ") WHERE ISNULL(so_num,'')>N'" & dataTable("so_num") _
            & "' AND wr_num=N'" & WRDBTableList(i)("wr_num") & "' AND history_type='Ship-out Made' " _
            & "AND elt_account_number=" & elt_account_number & " "
        Next
        
        SQL = SQL & "DELETE FROM warehouse_history where ISNULL(so_num,'')=N'" & dataTable("so_num") _
            & "' AND history_type='Ship-out Made' AND elt_account_number=" & elt_account_number & " " _
            & "DELETE FROM warehouse_shipout where ISNULL(so_num,'') =N'" & dataTable("so_num") _
            & "' AND elt_account_number=" & elt_account_number & " " 
            
        SQL = SQL & " COMMIT"

        
        Set historyRS = Server.CreateObject("ADODB.RecordSet")
        Set historyRS = eltConn.execute(SQL)
    End Sub
    
%>
</head>
<body >
    <script type="text/javascript" >

function redirectToBill(resVal) {
 if(resVal){
                if(resVal[0] == "air_house"){
                    parent.window.location.href = "/AirExport/HAWB/"
                        + encodeURIComponent("DataTransfer=SO&SONum=" + document.getElementById("txtSONum").value);
                }
                if(resVal[0] == "air_master"){
                    parent.window.location.href = "/AirExport/MAWB/"
                        + encodeURIComponent("fBook=yes&Edit=yes&MAWB=" + resVal[1] + "&DataTransfer=SO&SONum=" + document.getElementById("txtSONum").value);
                }
                if(resVal[0] == "ocean_house"){
                    parent.window.location.href= "/OceanExport/HBOL/"
                       + encodeURIComponent("DataTransfer=SO&SONum=" + document.getElementById("txtSONum").value);
                }
                if(resVal[0] == "ocean_master"){
                    parent.window.location.href = "/OceanExport/MBOL/"
                        + encodeURIComponent("ChangeBookingNum=yes&Edit=yes&BookingNum=" + resVal[1] + "&DataTransfer=SO&SONum=" + document.getElementById("txtSONum").value);
                }
                if(resVal[0] == "domestic_house"){
                    parent.window.location.href= "/DomesticFreight/HouseAirBill/"
                        + encodeURIComponent("mode=transfer&SONum=" + document.getElementById("txtSONum").value);
                }
            }
}

        function ComeBack(){            
            document.formShipOut.action = "/ASP/WMS/shipout_detail.asp?mode=view&so=" + "<%=dataTable("so_num")%>";
            document.formShipOut.method = "POST";
            document.formShipOut.target = "_self";
            document.formShipOut.submit();
        }   
        function saveForm(){
            var so_num = document.getElementById("txtSONum").value;
            var totalPCS=document.getElementsByName("txtPiece");
            var Customer_num =document.getElementById("hAccountOfAcct").value;
            //Temp customer no from hidden customer item value
            var Temp_item_value=document.getElementById("hTempItemValue").value;
            //check customer selection 
            if(Customer_num == "" || Customer_num =="0")
            {
                alert("Please, select a customer account");
                document.getElementById("lstAccountOfName").focus();
            }
                //check Item selection 
            else if(Temp_item_value == "")
            {
                alert("Please, select Items to shipout");
            }
            else
            {
                if (so_num == "" ){	    
                    document.formShipOut.action = "/ASP/WMS/shipout_detail.asp?mode=SaveAsNew";
                }
                else{
                    document.formShipOut.action = "/ASP/WMS/shipout_detail.asp?mode=Update";
                }
                document.formShipOut.method = "POST";
                document.formShipOut.target = "_self";
                document.formShipOut.submit();
            }
        }        
        function GoDetail() {
        
            var Search_name=document.getElementById("lstAccountOfName").value;
            var Search_id=document.getElementById("hAccountOfAcct").value;
    
            if (Search_id == "" || Search_id == 0){
                alert("Please, select a customer account");
                document.getElementById("lstAccountOfName").focus();
            }
            else{
               
                var url="shipout_list_update.asp?orgAcct=" + Search_id 
               + "&orgName=" + encodeURIComponent(Search_name) 
               + "&SONum=" + encodeURIComponent(document.getElementById("txtSONum").value);

                viewPop(url);
               
            }
        }        
        function LoadScreen(){
            
            lstAccountOfChange('<%=checkBlank(dataTable("customer_acct"),0) %>','<%=GetBusinessName(dataTable("customer_acct")) %>');
            lstTruckerNameChange('<%=checkBlank(dataTable("trucker_acct"),0) %>','<%=GetBusinessName(dataTable("trucker_acct")) %>');
            setShipToName('<%=checkBlank(dataTable("consignee_acct"),0) %>','<%=GetBusinessName(dataTAble("consignee_acct")) %>');   
          
            <% If WRTableList.Count > 0 Then %>
            document.getElementById("lstAccountOfName").disabled = true;
            document.getElementById("txtAccountOfInfo").disabled = true;
            document.getElementById("imgAccountOfButton").disabled = true;
            document.getElementById("imgAccountOfAddButton").disabled = true;
            //set item vlaue to ture
            document.getElementById("hTempItemValue").value = "Y";
            <% End If %>
            
            <% If (vMode = "SaveAsNew" Or vMode = "Update") Then %>
            // CreateBill();
            <% End If %>
            }        
        function deleteThis(){
        
            var noValue = document.getElementById("hSearchNum").value;                        
            var shipout = document.getElementById("txtSONum").value; 
            if(noValue != "" && noValue != "Select One"){
                var answer = confirm("Please, click OK to delete this Ship Out No. ("+ shipout +")");
                if(!answer){
                    return false;
                }
                document.formShipOut.action = "shipout_detail.asp?mode=delete";
                document.formShipOut.method = "POST";
                document.formShipOut.target = "_self";
                document.formShipOut.submit();
            }
            else{
                alert("Please, select a shipout file to delete.");
                return false;
            }
        }        
        function setField(xmlTag,htmlTag,xmlObj){
        
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null){
                document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
            }
            else{
                document.getElementById(htmlTag).value = "";
            }
        }  
        function setSelectField(xmlTag,htmlTag,xmlObj,compareLen){
            var htmlObj = document.getElementById(htmlTag);
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null 
                && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null){
                for(var i=0;i<htmlObj.length;i++){
                    if(htmlObj.children.item(i).value.substring(0,compareLen) == xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue.substring(0,compareLen)){
                        htmlObj.children.item(i).selected = true;
                    }
                }
            }
            else{
                htmlObj.selectedIndex = -1;
            }
        }    
        function searchNumFill(obj,changeFunction,vHeight,event){
            var qStr = obj.value;
            var keyCode = event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/ASP/ajaxFunctions/ajax_shipout.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            
            url = "/ASP/ajaxFunctions/ajax_shipout.asp?mode=list";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        function lstSearchNumChange(argV,argL){           
            document.formShipOut.action = "/ASP/WMS/shipout_detail.asp?mode=view&uid=" + argV + "&so=" + encodeURIComponent(argL);
            document.formShipOut.method = "POST";           
            document.formShipOut.submit();
        }
        function setShipToName(orgNum,orgName)
        {
          
            var hiddenObj = document.getElementById("hShipToAcct");        
            var txtObj = document.getElementById("lstShipToName");
            var divObj = document.getElementById("lstShipToNameDiv")    
            hiddenObj.value = orgNum;            
            txtObj.value = orgName;
        }     

        function lstShipToNameChange(orgNum,orgName)
        {
            // alert('a');
            var hiddenObj = document.getElementById("hShipToAcct");
            var infoObj = document.getElementById("txtShipToInfo");
            var txtObj = document.getElementById("lstShipToName");
            var divObj = document.getElementById("lstShipToNameDiv")
    
            hiddenObj.value = orgNum;
           infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }        
        function lstAccountOfChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hAccountOfAcct");
            var infoObj = document.getElementById("txtAccountOfInfo");
            var txtObj = document.getElementById("lstAccountOfName");
            var divObj = document.getElementById("lstAccountOfNameDiv");
            // Old customer No.\Item carrier No. 
            var tempObj = document.getElementById("hTempItemValue").value;
            //Store old customer value to temp value
            var temptxt = txtObj.value;
            vCumNum=orgNum;
            vCumName=orgName;
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            if( tempObj != "" )
            {
                if(tempObj != hiddenObj.value)
                {
                    //confirm customer change
                    var answer = confirm("Changing customer will remove ship out item." );
                    if( answer) //if confirm = yes then keep new customer and clean up old item table
                    {
                        document.getElementById("hTempItemValue").value="";
                        document.getElementById("WRListDiv").innerHTML ="";
                    }
                    else        //if confirm = No then keep old customer and keep old item table
                    {
                        vCumNum=tempObj;
                        vCumName=temptxt;
                        hiddenObj.value = tempObj;
                        infoObj.value = getOrganizationInfo(tempObj,"B");
                        txtObj.value = temptxt;  
                    }
                }
            }
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
            divObj.innerHTML = "";
		    
        }	    
        function lstTruckerNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hTruckerAcct");
            var txtObj = document.getElementById("lstTruckerName");
            var divObj = document.getElementById("lstTruckerNameDiv");
            var infoObj = document.getElementById("txtTruckerInfo");
    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            infoObj.value = getOrganizationInfo(orgNum,"D");
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
            divObj.innerHTML = "";
        }        
        function getOrganizationInfo(orgNum,infoFormat){
            if (window.ActiveXObject) {
                try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                } catch(error) {
                    try {
                        xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(error) { return ""; }
                }
            } 
            else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
            } 
            else { return ""; }

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + encodeURIComponent(orgNum);

            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }	    
        function viewPDF(){
            var so_num = document.getElementById("txtSONum").value;

            if(so_num == ""){
                alert("Please, select ship-out number to view PDF");
                return false;
            }
            else{
                showPDFself();
            }
        }        
        function showPDFself(){
            var form = document.getElementById("formShipOut");
            
            form.action = "./warehouse_shipout_pdf.asp";
            form.method = "POST";
            form.target = "_self";
            form.submit();
        }        
        function CreateBill(){
            if(document.getElementById("txtSONum").value == ""){
                alert("Please, select ship-out number to create bill");
                return ;
            }

            <% If checkBlank(dataTable("file_type"),"")<>"" Then %>
                if(!confirm("Your have already transfered shipout data.\nPress Ok to create new shipout data transfer.")){
                    return;
                }
            <% End If %>
            
            var vURL = "./shipout_transfer.asp?SONum=" + document.getElementById("txtSONum").value;
            var resVal = showModalDialog(vURL, "Shipout Transfer","dialogWidth:310px; dialogHeight:300px; help:0; status:1; scroll:0; center:1; Sunken;");
            
            if(resVal){
                if(resVal[0] == "air_house"){
                    parent.window.location.href = "/AirExport/HAWB/"
                        + encodeURIComponent("DataTransfer=SO&SONum=" + document.getElementById("txtSONum").value);
                }
                if(resVal[0] == "air_master"){
                    parent.window.location.href = "/AirExport/MAWB/"
                        + encodeURIComponent("fBook=yes&Edit=yes&MAWB=" + resVal[1] + "&DataTransfer=SO&SONum=" + document.getElementById("txtSONum").value);
                }
                if(resVal[0] == "ocean_house"){
                    parent.window.location.href= "/OceanExport/HBOL/"
                       + encodeURIComponent("DataTransfer=SO&SONum=" + document.getElementById("txtSONum").value);
                }
                if(resVal[0] == "ocean_master"){
                    parent.window.location.href = "/OceanExport/MBOL/"
                        + encodeURIComponent("ChangeBookingNum=yes&Edit=yes&BookingNum=" + resVal[1] + "&DataTransfer=SO&SONum=" + document.getElementById("txtSONum").value);
                }
                if(resVal[0] == "domestic_house"){
                    parent.window.location.href= "/DomesticFreight/HouseAirBill/"
                        + encodeURIComponent("mode=transfer&SONum=" + document.getElementById("txtSONum").value);
                }
            }
        }       
    </script>
    <form id="formShipOut" name="formShipOut" action="">
        <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    SHIP OUT
                </td>
                <td width="50%" align="right" valign="middle">
                </td>
            </tr>
        </table>
        <div class="selectarea" align="center">
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <span class="select">Select Ship Out No.</span></td>
                    <td width="55%" rowspan="2" align="right" valign="bottom">
                        <div id="print">
                            <a href="javascript:CreateBill();">
                                <img src="/ASP/Images/icon_createhouse.gif" alt=""
                                    width="25" height="26" style="margin-right: 10px" />Create Bill</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="/IFF_MAIN/ASPX/WMS/ShipoutManager.aspx">
                                <img src="/ASP/Images/icon_detailwindow.gif" alt="" style="margin-right: 10px" />Ship
                                Out List</a>
                            <img src="/ASP/Images/button_devider.gif" alt="" />
                            <a href="javascript:;" onclick="viewPDF(); return false;">
                                <img src="/ASP/Images/icon_printer.gif" alt="" style="margin-right: -5px" />Ship Out Report</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="45%" valign="bottom">
                        <!-- Start JPED -->
                        <input type="hidden" id="hSearchNum" name="hSearchNum" value='<%=dataTable("auto_uid") %>' />
                        <div id="lstSearchNumDiv">
                        </div>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="width: 150px; height: 17px;">
                                    <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value='<%=dataTable("so_num") %>'
                                        class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                        onkeyup="searchNumFill(this,'lstSearchNumChange',200,event);"
                                        onfocus="initializeJPEDField(this,event);" /></td>
                                <td style="height: 17px">
                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9; border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                            </tr>
                        </table>
                        <!-- End JPED -->
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
            class="border1px">
            <tr>
                <td height="24" align="center" valign="middle" bgcolor="#e5cfbf">
                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="26%">&nbsp;
                            </td>
                            <td width="48%" align="center" valign="middle">
                                <img src="/ASP/images/button_save_medium.gif" name="bSaveTop" width="46"
                                    height="18" id="bSaveTop" style="cursor: hand" onclick="saveForm()" /></td>
                            <td width="13%" align="right" valign="middle">
                                <a href="/ASP/WMS/shipout_detail.asp" target="_self">
                                    <img src="/ASP/Images/button_new.gif" border="0" style="cursor: hand" /></a></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="/ASP/images/button_delete_medium.gif" style="cursor: hand" onclick="deleteThis()" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1" colspan="9" bgcolor="#9e816e"></td>
            </tr>
            <tr>
                <td bgcolor="#f3f3f3">
                    <br />
                    <table border="0" cellspacing="0" cellpadding="0" style="width: 95%; height: 17px">
                        <tr>
                            <td height="28" align="right">
                                <span class="bodyheader">&nbsp;<img src="/ASP/Images/required.gif" align="absbottom">Required
                                    field</span></td>
                        </tr>
                    </table>
                    <table width="90%" align="center" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
                        class="border1px">
                        <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                            <td height="19" valign="top" bgcolor="#f3f3f3">
                                <!-- starts pickup and deliver -->
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-right: #9e816e solid 1px">
                                    <tr>
                                        <td width="2%" bgcolor="#f4e9e0">
                                        </td>
                                        <td height="20" colspan="3" align="center" valign="middle" bgcolor="#f4e9e0" class="bodyheader">
                                            <span class="style8">SHIP OUT TO</span></td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                        <td height="1" colspan="4">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                        </td>
                                        <td height="6" colspan="3" bgcolor="#FFFFFF" class="bodycopy">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td colspan="3" bgcolor="#FFFFFF" class="bodycopy">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hShipToAcct" name="hShipToAcct" value='<%=dataTable("consignee_acct") %>' />
                                            <div id="lstShipToNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="height: 20px">
                                                        <input type="text" autocomplete="off" id="lstShipToName" name="lstShipToName" value=""
                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'All','lstShipToNameChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" alt="lstShipToName" /></td>
                                                    <td style="height: 20px">
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipToName','All','lstShipToNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td style="height: 20px">
                                                        <input type='hidden' id='quickAdd_output'/>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hShipToAcct','lstShipToName','txtPickupInfo')" /></td>
                                                </tr>
                                            </table>
                                            <textarea wrap="hard" id="txtShipToInfo" name="txtShipToInfo" class="multilinetextfield"
                                                cols="" rows="5" value="vshiperoutinfo" style="width: 300px"><%=dataTable("shipper_info") %></textarea>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                        </td>
                                        <td width="23%" bgcolor="#FFFFFF" class="bodycopy">
                                        </td>
                                        <td width="23%" height="8" bgcolor="#FFFFFF" class="bodycopy">
                                        </td>
                                        <td width="52%" bgcolor="#FFFFFF" class="bodycopy">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="4" bgcolor="#9e816e">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="2%" bgcolor="#f4e9e0">
                                        </td>
                                        <td height="20" colspan="3" align="center" valign="middle" bgcolor="#f4e9e0" class="bodyheader">
                                            <span class="style8">
                                                <img src="/ASP/Images/required.gif" align="absbottom">FOR ACCOUNT OF </span>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#9e816e" class="bodycopy">
                                        <td height="1" colspan="4">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                        </td>
                                        <td height="18" colspan="3" bgcolor="#FFFFFF" class="bodycopy">
                                            <span class="style9">Contact</span><br />
                                            <input name="txtAccountOfContact" id="txtAccountOfContact" maxlength="128" type="text"
                                                class="shorttextfield" value='<%=dataTable("customer_contact") %>' style="width: 300px;" /></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                        </td>
                                        <td height="8" colspan="3" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hAccountOfAcct" name="hAccountOfAcct" value='<%=dataTable("customer_acct") %>'/>
                                            <!--Temp item Carrier No and Value-->
                                            <input type="hidden" id="hTempItemValue" name="hTempItemValue" value="" />
                                            <div id="lstAccountOfNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="height: 20px">
                                                        <input type="text" autocomplete="off" id="lstAccountOfName" name="lstAccountOfName"
                                                            value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                            onkeyup="organizationFill(this,'','lstAccountOfChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td style="height: 20px">
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAccountOfName','','lstAccountOfChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" id="imgAccountOfButton" /></td>
                                                    <td style="height: 20px">
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hAccountOfAcct','lstAccountOfName','txtAccountOfInfo')"
                                                            id="imgAccountOfAddButton" /></td>
                                                </tr>
                                            </table>
                                            <textarea wrap="hard" id="txtAccountOfInfo" name="txtAccountOfInfo" class="multilinetextfield"
                                                cols="" rows="5" style="width: 300px"></textarea>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="8" colspan="4" bgcolor="#FFFFFF">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="4" bgcolor="#ffffff">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="4" bgcolor="#9e816e">
                                        </td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td bgcolor="#f3f3f3">
                                        </td>
                                        <td height="18" colspan="2" bgcolor="#f3f3f3" class="bodycopy">
                                            Customer Reference No.
                                        </td>
                                        <td bgcolor="#f3f3f3" class="bodycopy">
                                            P.O. No.
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                        </td>
                                        <td height="22" colspan="2" bgcolor="#FFFFFF" class="bodycopy">
                                            <span style="height: 18px"><span class="bodylistheader">
                                                <input name="txtCustomerRefNo" id="txtCustomerRefNo" type="text" maxlength="64" class="shorttextfield"
                                                    value='<%=dataTable("customer_ref_no") %>'  size="32" style="width: 140px" />
                                            </span></span>
                                        </td>
                                        <td bgcolor="#FFFFFF" class="bodycopy">
                                            <span style="height: 18px"><span class="bodylistheader">
                                                <input name="txtPONO" id="txtPONO" type="text" class="shorttextfield" maxlength="64"
                                                    value= '<%=dataTable("PO_NO") %>' size="32" style="width: 140px" />
                                            </span></span>
                                        </td>
                                    </tr>
                                </table>
                                <!-- ends pickup and deliver -->
                            </td>
                            <td width="50%" valign="top" bgcolor="#FFFFFF">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td width="47%" height="20">
                                            <span class="bodyheader">Created</span></td>
                                        <td width="51%">
                                            <span class="bodyheader">Ship Out No.</span></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td height="18" bgcolor="#FFFFFF">
                                            <input name="txtSODate" type="text" class="m_shorttextfield " value='<%=checkBlank(dataTable("created_date"),Date()) %>'
                                                size="16" style="width: 70px;
                                                height: 16px" preset="shortdate" id="txtSODate" /></td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtSONum" id="txtSONum" type="text" class="readonlybold" value='<%=dataTable("so_num") %>' size="20"
                                                readonly="readOnly" style="width: 140px" /></td>
                                    </tr>
                                    <tr>
                                        <td style="height:4px" colspan="3">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height:1px; background-color:#9e816e" colspan="3">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#F3F3F3">
                                            &nbsp;
                                        </td>
                                        <td height="18" colspan="2" bgcolor="#F3F3F3" class="bodyheader">
                                            Pickup by (Trucking Carrier)</td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td height="18" colspan="2" bgcolor="#FFFFFF">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hTruckerAcct" name="hTruckerAcct" value= '<%=dataTable("trucker_acct") %>' />
                                            <div id="lstTruckerNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstTruckerName" name="lstTruckerName" value=""
                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Trucker','lstTruckerNameChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstTruckerName','Trucker','lstTruckerNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hTruckerAcct','lstTruckerName')" /></td>
                                                </tr>
                                            </table>
                                            <textarea wrap="hard" id="txtTruckerInfo" name="txtTruckerInfo" class="multilinetextfield"
                                                cols="" rows="2" style="width: 300px"></textarea>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="2%" bgcolor="#f3f3f3">
                                            &nbsp;
                                        </td>
                                        <td height="18" colspan="2" bgcolor="#f3f3f3">
                                            <span class="bodyheader">Carrier Reference No. / Bill of Lading No.</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input name="txtCarrierRefNo" id="txtCarrierRefNo" type="text" maxlength="64" class="shorttextfield"
                                                value='<%=dataTable("carrier_ref_no") %>' style="width: 140px" />
                                        </td>
                                        <td>
                                            <input id="txtReceivedDate" name="txtReceivedDate" type="hidden" class="m_shorttextfield "
                                                value='<%=dataTable("received_date") %>' style="width: 140px" preset="shortdate" /></td>
                                    </tr>
                                    <tr>
                                        <td style="height:4px" colspan="3">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height:1px; background-color:#9e816e" colspan="3">
                                        </td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td bgcolor="#f3f3f3">
                                            &nbsp;
                                        </td>
                                        <td height="18" bgcolor="#f3f3f3">
                                            <span class="style10">Ship Out Date</span>
                                        </td>
                                        <td bgcolor="#f3f3f3">
                                            &nbsp;</td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td bgcolor="#ffffff">
                                            &nbsp;
                                        </td>
                                        <td height="18">
                                            <input name="txtShipOutDate" id="txtShipOutDate" type="text" class="m_shorttextfield " 
                                                value='<%=checkBlank(dataTable("shipout_date"),Date()) %>'  style="width: 140px" preset="shortdate" /></td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td bgcolor="#f3f3f3">
                                            &nbsp;
                                        </td>
                                        <td height="18" bgcolor="#f3f3f3">
                                            Remarks</td>
                                        <td bgcolor="#f3f3f3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF">
                                            &nbsp;
                                        </td>
                                        <td colspan="2" align="left" valign="top" bgcolor="#FFFFFF">
                                            <textarea name="txtRemarks" id="txtRemarks"  wrap="hard" cols="50" rows="5" class="multilinetextfield"   
                                                style="width: 300px"><%=MakeJavaString(dataTable("other_info")) %></textarea>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td style="height: 1px; background-color: #9e816e" colspan="9"></td>
            </tr>
            <tr>
                <td style="height: 12px">
                    <div id="WRListDiv">
                        <!--  #INCLUDE VIRTUAL="/ASP/WMS/shipout_list.asp" -->
                    </div>
                </td>
            </tr>
            <tr>
                <td height="32" align="center" valign="middle" class="bodycopy">
                    <img src="../images/button_go.gif" id="GoImg" width="31" height="18" onclick="GoDetail()"
                        style="cursor: hand"></td>
            </tr>
            <tr>
                <td colspan="9" bgcolor="#9e816e">
                </td>
            </tr>
            <tr>
                <td height="24" align="center" valign="middle" bgcolor="#e5cfbf">
                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="26%" style="height: 19px">&nbsp;
                            </td>
                            <td width="48%" align="center" valign="middle" style="height: 19px">
                                <img src="/ASP/images/button_save_medium.gif" name="bSaveBottom" width="46"
                                    height="18" id="bSaveBottom" style="cursor: hand" onclick="saveForm()" /></td>
                            <td width="13%" align="right" valign="middle" style="height: 19px">
                                <a href="/ASP/WMS/shipout_detail.asp" target="_self">
                                    <img src="/ASP/Images/button_new.gif" border="0" style="cursor: hand" /></a></td>
                            <td width="13%" align="right" valign="middle" style="height: 19px">
                                <img src="/ASP/images/button_delete_medium.gif" style="cursor: hand" onclick="deleteThis()" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>      
    </form>
    <script> $(document).ready(function(){LoadScreen();});</script>
</body>   
</html>
<!-- #INCLUDE VIRTUAL="/ASP/include/StatusFooter.asp" -->

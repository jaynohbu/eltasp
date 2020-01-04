<!--  #INCLUDE FILE="transaction.txt" -->
<!--  #INCLUDE FILE="connection.asp" -->

<%

Public vType
Public vMenu 
Public vCount
Public CodeList
Public DescList
Public vNewCode
Public vNewDesc
Public elt_account_number
Public vPostBack



Set CodeList = Server.CreateObject("System.Collections.ArrayList")
Set DescList = Server.CreateObject("System.Collections.ArrayList")


if Not IS_POST_BACK =true then 
   Call GET_QUERY_STRING
   Call GET_LIST_FROM_DB
else  
   Call GET_REQUEST
   if(vMenu="Cancel") then 
    Call DO_CANCEL
   end if 
   if(vMenu="AddNew") then
   
    Call DO_ADD
   end if 
   if(vMenu="Modify")then
    Call DO_MODIFY
   end if 
   if(vMenu="Delete")then
    Call DO_DELETE
   end if               
end if  

SET_IS_POST_BACK   



'------------------------------------------Sub Procedures---------
Function IS_POST_BACK
 
    result=false
    
    if request("hPostBack") = "true" then 
        result= true
    else        
        result= false
    end if  
    IS_POST_BACK= result
End Function

Sub SET_IS_POST_BACK
    vPostBack = "true"
End Sub 

'--------------------------------------------------------------
Sub GET_QUERY_STRING
    vType=request.QueryString("Type")
    vTYPE=1   ' FOR NOW
    elt_account_number = 80002000
End Sub
'--------------------------------------------------------------
Sub GET_REQUEST 
    vMenu=request("hMenu")
    vType=request("hType") 
    elt_account_number = 80002000 
   
End Sub 
'--------------------------------------------------------------
Sub GET_LIST_FROM_SCREEN(CLEAR)
    if CLEAR="Y" then 
        CodeList.Clear
        DescList.Clear
    end if 

    vCount=request("hCount")
    
    if isNumeric(vCount) then 
        vCount=cInt(vCount)
    else 
        vCount=0
    end if 
     
    for i=0 to vCount-1
        name=Request("hlst_"&i)
        name2=Request("h2lst_"&i)
        code=name
        desc=name2
       'response.Write code & desc &"<br>"
        CodeList.Add code
        DescList.Add desc    
    next 
   
End Sub 
'--------------------------------------------------------------
Sub STORE_CODES_TO_DB
    Dim code, desc
    Call GET_LIST_FROM_SCREEN("Y")
    
    SQL= "delete from all_code where elt_account_number = " & elt_account_number& " and type = "&vType
    eltConn.Execute SQL
    for i=0 to vCount-1
        code=CodeList(i)
        desc=DescList(i)
        if(code<>"")then
            SQL= "insert into all_code (elt_account_number, type, code, description) values (" & elt_account_number& ","&vType&",'"&code&"',"&"'"&desc&"')"
            eltConn.Execute SQL           
        end if 
    next 
End Sub
'--------------------------------------------------------------
Sub DO_CANCEL
    Call RETURN_TO_CALLER("Cancel")
End Sub 
'--------------------------------------------------------------
Sub DO_ADD 
    CodeList.Clear
    DescList.Clear
    CodeList.Add ""
    DescList.Add ""
    Call GET_LIST_FROM_SCREEN("N")
    vCount=vCount+1
End Sub 
'--------------------------------------------------------------
Sub DO_MODIFY
    Call GET_LIST_FROM_SCREEN("Y")
    Call STORE_CODES_TO_DB
    Call GET_LIST_FROM_DB
End Sub 
'--------------------------------------------------------------
Sub DO_DELETE
    ID=Request("hItemNo")
    index=cInt(ID)
    Call GET_LIST_FROM_SCREEN("Y")
    CodeList.removeAt(index)
    DescList.removeAt(index)
End Sub 
'--------------------------------------------------------------


Sub GET_LIST_FROM_DB
    Dim rs
    Dim aCode
    Dim aDesc
    strCodes=""
    aCode=""
    CodeList.clear
    DescList.clear
    Set rs=Server.CreateObject("ADODB.Recordset")   
    SQL= "select * from all_code where elt_account_number = " & elt_account_number& " and type = "&vType&" order by code"
    rs.Open SQL, eltConn, , , adCmdText    

    Do While Not rs.EOF
        aCode = rs("code")
        aDesc = rs("description")     
	    CodeList.Add aCode 
	    DescList.Add aDesc
	    rs.MoveNext
    Loop
    
     vCount=CodeList.Count
    
    rs.Close
    Set rs=Nothing 
    
End Sub 
'--------------------------------------------------------------
Sub RETURURN_TO_CALLER(vVal)
    response.write "<script language='javascript'>closeReturn(""" & vVal & """);</script>"
End Sub
'--------------------------------------------------------------------------------------------

 %>


<!--hNewCode,hNewDesc,hMenu-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >

<script  type="text/javascript" language='javascript'>
window.name = 'CodeManager';


function closeReturn(s) 
{
	window.returnValue = s;
	window.close();
}
</script>



<script type="text/javascript" language="javascript"> 

 var lockedId=-1;
 var lockedHTML="";
 
 var isEditOpen=false;
 var OpenId=-1;
 
 function LockPosition(obj)
 {
     if(lockedId !=-1){
         document.getElementById(lockedId).className="mouseOut"
         
     }
     lockedId=obj.id;
     
     obj.className='lockedID';
     //obj.innerHTML="<input type='text'/>";
    
 }
 
 function OpenEdit(obj)
 {
       if(obj.id!=-1){
            OpenId=obj.id            
            lockedHTML=obj.innerHTML;
       }
        var aCodeDes=obj.innerHTML.split("&nbsp;&nbsp;&nbsp;&nbsp;");
      
        obj.innerHTML="<input id='txtCode' class='codetextfield' value='"+aCodeDes[0]+"'/>"+"<input id='txtDesc'  class='codedesctextfield' value='"+aCodeDes[1]+"'/>"
      
 }
 
 function CloseEdit()
 {
   if(OpenId!=-1){
      var c=document.getElementById("txtCode").value;
      var d=document.getElementById("txtDesc").value;
      var newCode=c+"&nbsp;&nbsp;&nbsp;&nbsp;"+d;
      document.getElementById(OpenId).innerHTML=newCode; 
      var vect=OpenId.split("_");
      var id1="hlst_"+vect[1];
      var id2="h2lst_"+vect[1];
       document.getElementById(id1).value=c;
       document.getElementById(id2).value=d;
       
      lockedHTML="";
      OpenId=-1;
   } 
 }
 
 
 function isLock(obj){

    if (obj.id==lockedId)
    {
        return true;
    }
    else
    {
        return false;
    }   
 }

function addNew(){
    document.getElementById("hMenu").value="AddNew";
    document.form1.action="codeManager.asp";
    document.form1.method="POST";
    document.form1.target = "_self";

    if(document.getElementById("txtCode")){
        if(document.getElementById("txtCode").value!=""&&OpenId!="lst_0"){
            document.form1.submit();
        }else{
            alert("Please complete add!");
        }
    }else{
        document.form1.submit();
    }
}
 
 function deleteItem(){
   if(lockedId!=-1){
        var tmp=lockedId.split("_");
        var id=tmp[1];
        document.getElementById("hMenu").value="Delete";
        document.getElementById("hItemNo").value=id;
        document.form1.action="codeManager.asp";
        document.form1.method="POST";
        document.form1.target = "_self";
        document.form1.submit();
   } 
 }
 
 function saveList(){   
     
        document.getElementById("hMenu").value="Modify";
        document.form1.action="codeManager.asp";
        document.form1.method="POST";
        document.form1.target = "_self";
        document.form1.submit();
 }
 
 function cancel(){
     closeReturn("cancel");
 }

</script>
<head>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <title>Code Management</title>
    <style type="text/css"> 
.mouseOut{background:#cccff; color:#000000;}
.mouseOver{background:#99aacc; color:#ffffff;}
.lockedID{background:#336699; color:#ffffff;}
</style>
</head>
<body>
<form id="form1" name="form1" >
<table width="393" height="200" border="0">
  <tr>
    <td height="20" colspan="2" bgcolor="#003399" style="height: 20px">   </td>
  </tr>
  <tr>
    <td rowspan="4"  style="width: 336px"> 
	<div  id="panel"  style="width: 340px; height: 150px; z-index: 1; position:inherit;background-color: #f9f9ff; overflow-x: hidden; overflow-y: scroll; cursor: default;"><ol style="list-style:none; height:inherit" id="lstCodes"> 
 
     
    <%
      for i=0 to CodeList.Count-1
           response.Write "<li id='lst_"&i&"' name='lst_"&i&"' onmouseover=""if(!isLock(this)){this.className='mouseOver'}""  onmouseout=""if(!isLock(this)){this.className='mouseOut'}"" onclick=""if(this.id!=OpenId){CloseEdit();};LockPosition(this)"" ondblclick="" CloseEdit();OpenEdit(this)"">"&CodeList(i)&"&nbsp;&nbsp;&nbsp;&nbsp;"& DescList(i)& "</li>"       
      next
      
      if vMenu="AddNew" then
           response.Write "<script language='javascript'>LockPosition(document.getElementById('lst_0'));OpenEdit(document.getElementById('lst_0'));document.getElementById('txtCode').focus();</script>"                
      end if 
      
      
    %>    
	
    </ol></div>
    
    <%
     for i=0 to CodeList.Count-1
           response.Write "<input name='hlst_"&i&"' type='hidden' value='"&CodeList(i)&"'/><input name='h2lst_"&i&"' type='hidden' value='"&DescList(i)&"'/>"
      next
      
    
    
     %>
	</td>
    <td style="width: 123px">&nbsp;<img onclick="saveList();"  src="" /></td>
  </tr>
  <tr>
    <td style="width: 123px">&nbsp;<img onclick="addNew();" src="" /></td>
  </tr>
  <tr>
    <td style="width: 123px">&nbsp;<img onclick="cancel()" src="" /></td>
  </tr>
  <tr>
    <td height="46" style="width: 123px">&nbsp;<img onclick="deleteItem();"src="" /></td>
  </tr>
  <tr>
    <td height="20" colspan="2" bgcolor="#003399" style="height: 19px">
        <input id="hPostBack" name="hPostBack" type="hidden" value="<%=vPostBack %>" />
        <input id="hMenu" name="hMenu" type="hidden" />
        <input id="hCount" name="hCount" type="hidden" value="<%=vCount %>" />
        <input id="hItemNo" name="hItemNo" type="hidden" />
        <input id="hType" name="hType" type="hidden" value="<%=vType %>" />
    </td>   
 </tr>
 
</table>
</form>
</body>
</html>

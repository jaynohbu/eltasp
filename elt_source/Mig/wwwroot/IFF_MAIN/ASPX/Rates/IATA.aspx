<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IATA.aspx.cs" Inherits="ASPX_Rates_IATA" CodePage="65001" %>

<%@ Register TagName="RateControl" TagPrefix="uc1" Src="RateControl.ascx" %>
<%@ Register Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Rates</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../../ASP/include/JPED.js"></script>

    <link type="text/css" rel="stylesheet" href="../CSS/elt_css.css" />

    <script id="Infragistics" type="text/javascript">

        var gridNameMemory = "";
        
        function UltraWebGrid1_AfterRowInsertHandler(gridName, rowId, index){
            
            gridNameMemory = gridName;
            var currentRow = igtbl_getRowById(rowId);
            var parentRowObj = igtbl_getParentRow(gridName, currentRow.Element);
            
            if(parentRowObj == null)
            {
                currentRow.getCellFromKey("elt_account_number").setValue(<%=elt_account_number %>);
                currentRow.getCellFromKey("rate_type").setValue(<%=rate_type %>);
            }
            else 
            {
                var parentRow = igtbl_getRowById(parentRowObj.id);
                var parentBand = igtbl_getBandById(parentRowObj.id);
                
                if(parentBand.Key == "Routes"){
                    CopyRoutes(currentRow, parentRow);
                }
                if(parentBand.Key == "Airline"){
                    CopyAirline(currentRow, parentRow);
                }
            }
        }
        
        function resize_table()
        {
            var x,y;
            if (self.innerHeight) // all except Explorer
            {
	            x = self.innerWidth;
	            y = self.innerHeight;
            }
            else if (document.documentElement && document.documentElement.clientHeight)
	            // Explorer 6 Strict Mode
            {
	            x = document.documentElement.clientWidth;
	            y = document.documentElement.clientHeight;
            }
            else if (document.body) // other Explorers
            {
	            x = document.body.clientWidth;
	            y = document.body.clientHeight;
            }
            if(document.getElementById("RateWebGridxUltraWebGrid1_main")!=null){
	            document.getElementById("RateWebGridxUltraWebGrid1_main").style.height=parseInt(y-
	            document.getElementById("RateWebGridxUltraWebGrid1_main").offsetTop - 170)+"px";
	        }
        }
        window.onresize=resize_table; 
        
    </script>
</head>
<body style="margin: 0px 0px 0px 0px" onload="resize_table()">
    <form id="form1" runat="server">
        <div>
            <uc1:RateControl ID="RateWebGrid" runat="server" />
        </div>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OnInit="ObjectDataSource1_Init" />
    </form>
</body>
</html>



<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<% 
    Dim itemNum
    itemNum = checkBlank(Request.QueryString("ItemNum"),0)
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Dimension Calculator</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
            <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet" />
       <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <script type="text/jscript">

        var vPieces = 0;

        function AddDimEntry() {

            var D1 = document.getElementById("txtPieces");
            var D2 = document.getElementById("txtLength");
            var D3 = document.getElementById("txtWidth");
            var D4 = document.getElementById("txtHeight");
            var D5 = document.getElementById("lstUOM");
            var detail = document.getElementById("txtDimDetail");

            var totalCBM = document.getElementById("txtCBM");
            var totalCFT = document.getElementById("txtCFT");

            if (D1.value != "" && D2.value != "" && D3.value != "" && D4.value != "" && D5.value != "") {
                detail.value = detail.value + D1.value + "@"
                + D2.value + "X" + D3.value + "X" + D4.value + "(" + D5.value + ")" + "\n";
                D1.value = D2.value = D3.value = D4.value = "";
                totalCBM.value = totalCFT.value = "";
                getDimensionTotal();
            }
        }


        function getDimensionTotal() {

            try {
                var detail = document.getElementById("txtDimDetail").value;
                var totalCBM = document.getElementById("txtCBM");
                var totalCFT = document.getElementById("txtCFT");
                var dimArray = new Array();

                totalCBM.value = totalCFT.value = 0;
                dimArray = detail.split("\n");
                vPieces = 0;

                for (var i = 0; i < dimArray.length - 1; i++) {
                    var dimInfo = new Array(5);
                    var dimTemp = dimArray[i];
                    var cursor = dimTemp.indexOf("@");

                    // get dimenstion info into array                
                    dimInfo[0] = dimTemp.substring(0, cursor)
                    dimTemp = dimTemp.substring(cursor + 1, 500)
                    cursor = dimTemp.indexOf("X");
                    dimInfo[1] = dimTemp.substring(0, cursor)
                    dimTemp = dimTemp.substring(cursor + 1, 500)
                    cursor = dimTemp.indexOf("X");
                    dimInfo[2] = dimTemp.substring(0, cursor)
                    dimTemp = dimTemp.substring(cursor + 1, 500)
                    cursor = dimTemp.indexOf("(");
                    if (cursor == -1) {
                        dimInfo[3] = dimTemp.substring(0, 500);
                        dimInfo[4] = "CM";
                    }
                    else {
                        dimInfo[3] = dimTemp.substring(0, cursor)
                        dimTemp = dimTemp.substring(cursor + 1, 500)
                        cursor = dimTemp.indexOf(")");
                        dimInfo[4] = dimTemp.substring(0, cursor)
                    }

                    var dimTotalTemp = parseFloat(dimInfo[0]) * parseFloat(dimInfo[1])
                    * parseFloat(dimInfo[2]) * parseFloat(dimInfo[3]);

                    if (dimInfo[4] == "CM") {
                        totalCBM.value = (parseFloat(totalCBM.value) + dimTotalTemp / 5997.0691).toFixed(2);
                        totalCFT.value = (parseFloat(totalCBM.value) * 2.20462262).toFixed(2);
                    }
                    else {
                        totalCFT.value = (parseFloat(totalCFT.value) + dimTotalTemp / 166).toFixed(2);
                        totalCBM.value = (parseFloat(totalCFT.value) / 2.20462262).toFixed(2);
                    }
                    vPieces = vPieces + parseInt(dimInfo[0]);
                }
            }
            catch (err) {
                alert("Please, verify the dimension information.");
            }
        }

        function closeAndUpdate() {
            var factor;
            var totalDimension = 0;

            if (self.opener.document.frmHAWB.lstKgLb0.value == "K") {
                totalDimension = parseFloat(document.getElementById("txtCBM").value);
                //factor = 5997.0691
            }
            if (self.opener.document.frmHAWB.lstKgLb0.value == "L") {
                totalDimension = parseFloat(document.getElementById("txtCFT").value);
                //factor = 166
            }
            if (totalDimension == "") {
                var ans = confirm("Dimension values are imcomplete, Do you want to close window anyway?");
                if (ans) {
                    self.opener.document.frmHAWB.hDimDetail0.value = "";
                    self.opener.document.frmHAWB.txtDimension0.value = "0";
                    self.opener.document.frmHAWB.dimtext.value = "";
                    self.opener.setChargeableWeight(0);
                    window.close();
                }
            }
            else {
                if (vPieces != parseInt(self.opener.document.frmHAWB.txtPiece0.value)) {
                    alert("Please, verify the number of pieces!");
                    return false;
                }

                //self.opener.document.frmHAWB.txtDimension0.value = Math.round(totalDimension/factor) 

                self.opener.document.frmHAWB.txtDimension0.value = totalDimension.toFixed(0);
                self.opener.document.frmHAWB.hDimDetail0.value = document.getElementById("txtDimDetail").value;
                self.opener.document.frmHAWB.dimtext.value = document.getElementById("txtDimDetail").value;
                self.opener.setChargeableWeight(0);
                window.close();
            }
        }

        function initDimDetail() {

            var detail = document.getElementById("txtDimDetail");
            var tmpDetail = self.opener.document.frmHAWB.dimtext.value;

            if (tmpDetail != null && tmpDetail != "") {
                detail.value = tmpDetail;
                if (tmpDetail.lastIndexOf('\n') != tmpDetail.length - 1) {
                    tmpDetail = tmpDetail + "\n";
                }
                getDimensionTotal();
            }
        }
    

    </script>

</head>
<body bgcolor="#efeace" onload="initDimDetail();">
    <table class="bodycopy" cellpadding="1" cellspacing="1" border="0">
        <tr>
            <td colspan="6" style="height: 10px;">
            </td>
        </tr>
        <tr>
            <td>
                Pieces</td>
            <td>
                Length</td>
            <td>
                Width</td>
            <td>
                Height</td>
            <td>
                UOM</td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <input id="txtPieces" type="text" size="8" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
            <td>
                <input id="txtLength" type="text" size="8" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
            <td>
                <input id="txtWidth" type="text" size="8" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
            <td>
                <input id="txtHeight" type="text" size="8" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
            <td>
                <select id="lstUOM" class="smallselect">
                    <option selected="selected" value="CM">cm</option>
                    <option value="IN">inch</option>
                </select>
            </td>
            <td>
                <input id="btnAddDim" type="button" value="Add" class="bodycopy" style="width: 40px;"
                    onclick="AddDimEntry();" /></td>
        </tr>
        <tr>
            <td colspan="6">
                <textarea wrap="hard" name="txtDimDetail" id="txtDimDetail" class="multilinetextfield" style="width: 250px;height: 150px"></textarea>
            </td>
        </tr>
        <tr>
            <td colspan="6">
                <input id="btnCalculate" type="button" value="Get Total" class="bodycopy" onclick="getDimensionTotal();" />
                &nbsp; KG
                <input id="txtCBM" type="text" size="15" class="d_shorttextfield" readonly="readonly" />
                &nbsp; LB
                <input id="txtCFT" type="text" size="15" class="d_shorttextfield" readonly="readonly" /></td>
        </tr>
    </table>
    <br />
    <div align="center">
        <input id="btnDone" type="button" value="Close & Update" class="bodycopy" onclick="getDimensionTotal(); closeAndUpdate()" />
        <input id="btnNone" type="button" value="Close Only" class="bodycopy" onclick="window.close();" />
    </div>
</body>
</html>

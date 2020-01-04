<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->

<% 
    Dim itemNum
    itemNum = checkBlank(Request.QueryString("ItemNum"),0)
%>

<html>
<head>
    <title>Dimension Calculator</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
    
    var vPieces = 0;

    function AddDimEntry(){
    
        var D1 = document.getElementById("txtPieces");
        var D2 = document.getElementById("txtLength");
        var D3 = document.getElementById("txtWidth");
        var D4 = document.getElementById("txtHeight");
        var D5 = document.getElementById("lstUOM");
        var detail = document.getElementById("txtDimDetail");
        var totalDimWt = document.getElementById("txtDimWtLB");
        
        if(D1.value!=""&&D2.value!=""&&D3.value!=""&&D4.value!=""&&D5.value!=""){
            detail.value = detail.value + D1.value + "@" 
                + D2.value + "X" + D3.value + "X" + D4.value + "(" + D5.value + ")" + "\n";
            D1.value = D2.value = D3.value = D4.value = "";
            totalDimWt.value = "";
            getDimensionTotal();
        }
        document.getElementById("txtPieces").focus();
    }
    
    
    function getDimensionTotal(){
        
        try{
            var detail = document.getElementById("txtDimDetail").value;
            var totalDimWt = document.getElementById("txtDimWtLB");
            var totalCInch = document.getElementById("txtCInch");
            var vFactor = parseInt(document.getElementById("lstFactor").value);
            
            var dimArray = new Array();
            
            totalDimWt.value = totalCInch.value = 0;
            dimArray = detail.split("\n");
            vPieces = 0;
            
            for(var i=0;i<dimArray.length-1;i++){
                var dimInfo = new Array(5);
                var dimTemp = dimArray[i];
                var cursor = dimTemp.indexOf("@");
                
                // get dimenstion info into array                
                dimInfo[0] = dimTemp.substring(0,cursor)
                dimTemp = dimTemp.substring(cursor+1,500)
                cursor = dimTemp.indexOf("X");
                dimInfo[1] = dimTemp.substring(0,cursor)
                dimTemp = dimTemp.substring(cursor+1,500)
                cursor = dimTemp.indexOf("X");
                dimInfo[2] = dimTemp.substring(0,cursor)
                dimTemp = dimTemp.substring(cursor+1,500)
                cursor = dimTemp.indexOf("(");
                if(cursor == -1){
                    dimInfo[3] = dimTemp.substring(0,500);
                    dimInfo[4] = "CM";
                }
                else{
                    dimInfo[3] = dimTemp.substring(0,cursor)
                    dimTemp = dimTemp.substring(cursor+1,500)
                    cursor = dimTemp.indexOf(")");
                    dimInfo[4] = dimTemp.substring(0,cursor)
                }
                
                var dimTotalTemp = parseFloat(dimInfo[0]) * parseFloat(dimInfo[1])
                    * parseFloat(dimInfo[2]) * parseFloat(dimInfo[3]);

                totalCInch.value = parseFloat(totalCInch.value) + parseFloat(dimInfo[0]) * parseFloat(dimInfo[1])
                    * parseFloat(dimInfo[2]) * parseFloat(dimInfo[3]);
                
                totalDimWt.value = (parseFloat(totalDimWt.value) + dimTotalTemp/vFactor).toFixed(2);

                vPieces = vPieces + parseInt(dimInfo[0]);
            }
        } 
        catch(err){
            alert("Please, verify the dimension information.");
        }
    }
    
    function closeAndUpdate(){

        var totalCInch = parseFloat(document.getElementById("txtCInch").value);
        var totalDimension = parseFloat(document.getElementById("txtDimWtLB").value);
        var vFactor = parseInt(document.getElementById("lstFactor").value);
        
        if(totalDimension == ""){
            var ans = confirm("Dimension values are imcomplete, Do you want to close window anyway?");
            if(ans) { window.close(); }
        }
        else {
            if(vPieces != parseInt(self.opener.document.frmHAWB.txtPiece<%=itemNum %>.value)){
                alert("Please, verify the number of pieces!");
                return false;
            }
            
            self.opener.document.frmHAWB.txtDimension<%=itemNum %>.value=totalDimension.toFixed(2);
            self.opener.document.frmHAWB.txtCubicInches<%=itemNum %>.value=totalCInch.toFixed(2);
            self.opener.document.frmHAWB.hDimDetail<%=itemNum %>.value = document.getElementById("txtDimDetail").value;
            self.opener.document.frmHAWB.dimtext.value = document.getElementById("txtDimDetail").value;
            self.opener.document.frmHAWB.hDimFactor.value = vFactor;
            try{
            self.opener.setChargeableWeight(0);
            self.opener.setTotalWeightCharge(0);
            }catch(err){}
            
            window.close();
        }
    }
    
    function initDimDetail(){
        
        var detail = document.getElementById("txtDimDetail");
        var tmpDetail = self.opener.document.frmHAWB.dimtext.value;

        if (tmpDetail != null && tmpDetail != ""){
            detail.value = tmpDetail;
            if(tmpDetail.lastIndexOf('\n') != tmpDetail.length-1)
            {
                tmpDetail = tmpDetail + "\n";
            }
            var vFactor = self.opener.document.frmHAWB.hDimFactor.value;
            var objFactor = document.getElementById("lstFactor");
            
            if(objFactor.options[0].value == vFactor) objFactor.options[0].selected = true;
            if(objFactor.options[1].value == vFactor) objFactor.options[1].selected = true;
            if(objFactor.options[2].value == vFactor) objFactor.options[2].selected = true;
            
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
            <td></td>
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
                <input type="hidden" id="lstUOM" value="IN" />inch
            </td>
            <td>
                <input id="btnAddDim" type="button" value="Add" class="bodycopy" style="width: 40px;"
                    onclick="AddDimEntry();" /></td>
        </tr>
        <tr>
            <td colspan="6" style="height: 4px;">
            </td>
        </tr>
        <tr>
            <td colspan="6">
                <textarea wrap="hard" name="txtDimDetail" class="multilinetextfield" style="width: 250px;
                    height: 120px"></textarea>
            </td>
        </tr>
        <tr>
            <td colspan="6" style="height: 4px;">
            </td>
        </tr>
        <tr>
        <td colspan="6">
        <select name="lstFactor" id="lstFactor" class="samllselect" onchange="getDimensionTotal();">
            <option value="194">Domestic Air --- 194</option>
            <option value="250">Domestic Ground --- 250</option>
            <option value="166">International --- 166</option>
        </select>
        <input id="btnCalculate" type="button" value="Calculate" class="bodycopy" onclick="getDimensionTotal();" />
        </td>
        </tr>
        <tr>
            <td colspan="6" style="height: 4px;">
            </td>
        </tr>
        <tr>
            <td colspan="6">
                Cubic Inches <input id="txtCInch" type="text" size="15" class="d_shorttextfield" readonly="readonly" />
                &nbsp; &nbsp; 
                LB <input id="txtDimWtLB" type="text" size="15" class="d_shorttextfield" readonly="readonly" />
                <input id="txtCBM" type="hidden" class="d_shorttextfield" />
                </td>
        </tr>
    </table>
    <br />
    <div align="center">
        <input id="btnDone" type="button" value="Close & Update" class="bodycopy" onclick="getDimensionTotal(); closeAndUpdate()" />
        <input id="btnNone" type="button" value="Close Only" class="bodycopy" onclick="window.close();" />    
    </div>
</body>
</html>

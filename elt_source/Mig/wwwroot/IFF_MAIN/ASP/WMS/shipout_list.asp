<table width="100%" height="18" border="0" align="center" cellpadding="0" cellspacing="0"
    bgcolor="#f4e9e0">
    <tr class="bodyheader">
        <td width="2%" rowspan="2">
        </td>
        <td width="12%" rowspan="2" height="13">
            W/R No.
        </td>
        <td width="10%" rowspan="2">
            Received Date
        </td>
        <td width="12%" rowspan="2">
            Customer Ref No.
        </td>
        <td width="10%" rowspan="2">
            P.O. No.
        </td>
        <td width="22%" rowspan="2">
            Descriptions</td>
        <td colspan="3" align="center" style="border-left: 1px solid #9e816e; border-bottom: 1px solid #9e816e">
            NO. OF QTY <span class="style10"></span>
        </td>
    </tr>
    <tr class="bodyheader">
        <td width="7%" align="center" style="border-left: 1px solid #9e816e">
            Received
        </td>
        <td width="7%" align="center" style="border-left: 1px solid #9e816e">
            Remaining
        </td>
        <td width="7%" align="center" style="border-left: 1px solid #9e816e">
            <span class="style10">Ship Out</span></td>
    </tr>
    <tr>
        <td height="1" colspan="10" bgcolor="#9e816e">
        </td>
    </tr>
</table>
<% For i=0 To WRTableList.Count-1 %>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy"
    id="WRListTable" style="width: 100%">
    <tr id='Row<%=WRTableList(i)("auto_uid") %>'>
        <td width="2%" align="left">
            <input type="checkbox" name="chkWR" id="chkWR<%=WRTableList(i)("auto_uid") %>" class="bodycopy"
                onclick="enableTxtPiece(this,<%=WRTableList(i)("auto_uid") %>)" value="<%=WRTableList(i)("auto_uid") %>"
                <% If checkBlank(WRTableList(i)("so_num"),"") <> "" Then Response.Write("checked") %>
                style="visibility: hidden" />
            <input type="hidden" name="hWRNum" value="<%=WRTableList(i)("wr_num") %>" />
            <input type="hidden" name="hWRValue" value="<%=WRTableList(i)("auto_uid") %>" />
            <input type="hidden" name="hAvailablePiece" value="<%=WRTableList(i)("item_piece_available") %>" />
            <input type="hidden" name="txtOriginPiece" id="txtOriginPiece<%=WRTableList(i)("auto_uid") %>"
                value="<%=WRTableList(i)("item_piece_origin")%>" />
            <input type="hidden" name="txtRemainPiece" id="txtRemainPiece<%=WRTableList(i)("auto_uid") %>"
                value="<%=WRTableList(i)("item_piece_remain")%>" />
            <input type="hidden" name="txtShippedPiece" id="txtShippedPiece<%=WRTableList(i)("auto_uid") %>"
                value="<%=WRTableList(i)("item_piece_shipout")%>" />
        </td>
        <td width="12%" align="left" height="13">
            <%=WRTableList(i)("wr_num") %>
        </td>
        <td width="10%">
            <%=WRTableList(i)("received_date") %>
        </td>
        <td width="12%" align="left">
            <%=WRTableList(i)("customer_ref_no") %>
        </td>
        <td width="10%">
            <%=WRTableList(i)("PO_NO") %>
        </td>
        <td width="22%" align="left">
            <%=WRTableList(i)("item_desc") %>
        </td>
        <td width="7%" align="right" style="padding-right: 10px">
            <%=WRTableList(i)("item_piece_origin")%>
        </td>
        <td width="7%" align="right" style="padding-right: 10px">
            <%=CInt(WRTableList(i)("item_piece_remain")) + CInt(WRTableList(i)("item_piece_shipout"))%>
        </td>
        <td width="7%" align="right" style="padding-right: 10px">
            <input type="text" name="txtPiece" id="txtPiece<%=WRTableList(i)("auto_uid") %>"
                autocomplete="off" class="readonlybold" style="width: 50px; text-align: right"
                readonly="readOnly" value="<%=WRTableList(i)("item_piece_shipout") %>" /></td>
    </tr>
</table>
<% Next %>

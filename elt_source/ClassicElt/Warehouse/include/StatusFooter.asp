
<script language="javascript">
var obj = document.getElementById('txtBRStatus');
if(obj) {
	obj.value = '';
}
</script>

<%
	eltConn.Close
	Set eltConn=Nothing
%>

<SCRIPT src="../include/tabSync.js" type=text/javascript></SCRIPT>
<!-- scroll position -->
<% CALL RESTORE_SCROLL_BAR %>
<script language='javascript'>try{window.focus();}catch (ex) {}</script>


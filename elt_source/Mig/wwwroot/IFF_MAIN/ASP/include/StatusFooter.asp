<%
	eltConn.Close
	Set eltConn=Nothing
    CALL RESTORE_SCROLL_BAR 
%>

<script type="text/javascript">
    
    try{
        window.attachEvent("onload", function(){fixProgressBar();}); 
        window.focus();
        var tabURL = parent.document.frames['topFrame'].window.document.getElementById("hCurrentPage").value;
        var topModlueObj = parent.document.frames['topFrame'].window.document.getElementById("lstTopModule");
        var pageURL = document.location.href;
        if(encodeURIComponent(pageURL.toUpperCase()).match(encodeURIComponent(tabURL.toUpperCase()))==null){
            parent.document.frames['topFrame'].location = "/IFF_MAIN/ASP/tabs/tab_maker.asp?mode=back&page=" 
                + pageURL + "&top=" + topModlueObj.options[topModlueObj.options.selectedIndex].text;
        }
    }catch (ex) {}

</script>
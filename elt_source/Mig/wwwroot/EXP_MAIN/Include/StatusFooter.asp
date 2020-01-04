<%
	eltConn.Close
	Set eltConn=Nothing
%>

<script type="text/javascript">
    
    try{
        window.attachEvent("onload", function(){fixProgressBar();}); 
        window.focus();
        var tabURL = parent.document.frames['topFrame'].window.document.getElementById("hCurrentPage").value;
        var topModlueObj = parent.document.frames['topFrame'].window.document.getElementById("lstTopModule");
        var pageURL = document.location.href;
        if(encodeURIComponent(pageURL.toUpperCase()).match(encodeURIComponent(tabURL.toUpperCase()))==null){
            parent.document.frames['topFrame'].location = "/EXP_MAIN/Tabs/tab_maker.asp?mode=back&page=" 
                + pageURL + "&top=" + topModlueObj.options[topModlueObj.options.selectedIndex].text;
        }
    }catch (ex) {}
    
    function fixProgressBar()
    {
	    if(parent.frames['dummyFrame'])
	    {
		    parent.frames['dummyFrame'].document.write("");
		    parent.frames['dummyFrame'].document.close();
	    }    
    }

</script>

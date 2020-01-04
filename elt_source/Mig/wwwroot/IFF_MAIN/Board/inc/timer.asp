<% dim endtime,view_end,view_start,list_end,list_start %>
<% Endtime = Timer() %>
<!--
----------Processing Status----------
--><br>
Total execute Time : <%=FormatNumber(endtime-startTime,3)%> sec<br>
Viewer Time : <%=FormatNumber(view_end-view_start,3)%> sec<br>
List Time : <%=FormatNumber(list_end-list_start,3)%> sec<br><br>

Start time : <%=starttime%><br>
End time : <%=endtime%><br>
<!--
-------------------------------------
-->
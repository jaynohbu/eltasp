<%
sub page_tag
 if PageCount >= 1 then 
		If Int(Page) <> 0 Then 
	%>
		<img src="../Images/left_arrow.gif" onClick="javascript:goPage('<%=aPageArray(Page-1)%>');return false;" onfocus="this.blur()" style="cursor:hand" />
	<%
		end if
		
		First_Page = Int((Page)/Block)*Block
		
		If First_Page <> 0 Then
	%>
			<a href="javascript:;" onClick="javascript:goPage('<%=aPageArray(0)%>');return false;" onfocus="this.blur()"><span class="bodyheader"><%=aPageArray(0)%></span></a>&nbsp;..
	<%
		end if
		
		If PageCount - First_Page < Block Then
			End_Page = PageCount
		Else
			End_Page = First_Page + Block - 1
		End If
		
		For i = First_Page To End_Page
		If Int(Page) = i Then
	%>
			<span class="bodyheader"><font color="#FF0000"><b><%=aPageArray(i)%></b></font></span>
	<% Else %>
			<a href="javascript:;" onClick="javascript:goPage('<%=aPageArray(i)%>');return false;" onfocus="this.blur()"><span class="bodyheader"><%=aPageArray(i)%></span></a>
	<%
		End If
		Next
		
		If End_Page <> PageCount Then
	%>
	&nbsp;..&nbsp;<a href="javascript:;" onClick="javascript:goPage('<%=aPageArray(Pagecount-1)%>');return false;" onfocus="this.blur()"><span class="bodyheader"><%=aPageArray(Pagecount-1)%></span></a>
	<%
		end if
		If Int(Page) <> PageCount Then
	%>
	<img src="../Images/right_arrow.gif" onClick="javascript:goPage('<%=aPageArray(Page+1)%>');return false;" onfocus="this.blur()" style="cursor:hand" />
	<%
		End If 		
 end if 
end sub
%>


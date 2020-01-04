<%
 if isFirst = "y" then
		if IsNull(code_list) or isEmpty(code_list) or code_list.count = 0 then
			response.write "<span style='font-size: 10px;font-weight: bold;color: #c16b42' class='bodycopy'>Please set up the frequently being accessed Client.</span>"
			SQL_filter = ""
			get_dba_list_all(null)
		end if
 end if
%>
				  <% if Not IsNull(code_list) And Not isEmpty(code_list) And code_list.count > 0 Then %>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr class="bodyheader" align="left" style="color:Black;  background-color:#ecf7f8; height:20px;">
                        <td style="width:5px;"></td>
                        <td ></td>
                        <td onclick='javascript:result_sort(this);' id='dba_name' style="cursor:hand" value="<%
						if SortA = "dba_name" then 
							response.write ("A")
						elseif SortD = "dba_name" then 
							response.write ("D")
						end if
						%>">Company Name<div style="width:21px; display:inline; vertical-align: middle" onMouseOver="showtip('Clicking on the Label at the top of each column will sort by that column. You may click on it a second time to switch from ascending to descending.')"; onMouseOut="hidetip()"><img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader"></div>
            			</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='class_code' style="cursor:hand" value="<%
						if SortA = "class_code" then 
							response.write ("A")
						elseif SortD = "class_code" then 
							response.write ("D")
						end if
						%>">Class</td>
		                <td align="left" onclick='javascript:result_sort(this);' id='business_city' style="cursor:hand" value="<%
						if SortA = "business_city" then 
							response.write ("A")
						elseif SortD = "business_city" then 
							response.write ("D")
						end if
						%>">City</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='business_phone' style="cursor:hand" value="<%
						if SortA = "business_phone" then 
							response.write ("A")
						elseif SortD = "business_phone" then 
							response.write ("D")
						end if
						%>">Phone</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='owner_fname' style="cursor:hand" value="<%
						if SortA = "owner_fname" then 
							response.write ("A")
						elseif SortD = "owner_fname" then 
							response.write ("D")
						end if
						%>">Contact</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='is_consignee' style="cursor:hand" value="<%
						if SortA = "is_consignee" then 
							response.write ("A")
						elseif SortD = "is_consignee" then 
							response.write ("D")
						end if
						%>">Cgn</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='is_shipper' style="cursor:hand" value="<%
						if SortA = "is_shipper" then 
							response.write ("A")
						elseif SortD = "is_shipper" then 
							response.write ("D")
						end if
						%>">Shp</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='is_agent' style="cursor:hand" value="<%
						if SortA = "is_agent" then 
							response.write ("A")
						elseif SortD = "is_agent" then 
							response.write ("D")
						end if
						%>">Agn</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='is_carrier' style="cursor:hand" value="<%
						if SortA = "is_carrier" then 
							response.write ("A")
						elseif SortD = "is_carrier" then 
							response.write ("D")
						end if
						%>">Crr</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='z_is_trucker' style="cursor:hand" value="<%
						if SortA = "z_is_trucker" then 
							response.write ("A")
						elseif SortD = "z_is_trucker" then 
							response.write ("D")
						end if
						%>">Trk</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='z_is_warehousing' style="cursor:hand" value="<%
						if SortA = "z_is_warehousing" then 
							response.write ("A")
						elseif SortD = "z_is_warehousing" then 
							response.write ("D")
						end if
						%>">WH</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='z_is_cfs' style="cursor:hand" value="<%
						if SortA = "z_is_cfs" then 
							response.write ("A")
						elseif SortD = "z_is_cfs" then 
							response.write ("D")
						end if
						%>">CFS</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='z_is_broker' style="cursor:hand" value="<%
						if SortA = "z_is_broker" then 
							response.write ("A")
						elseif SortD = "z_is_broker" then 
							response.write ("D")
						end if
						%>">Brk</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='z_is_govt' style="cursor:hand" value="<%
						if SortA = "z_is_govt" then 
							response.write ("A")
						elseif SortD = "z_is_govt" then 
							response.write ("D")
						end if
						%>">Gov</td>
                        <td align="left" onclick='javascript:result_sort(this);' id='z_is_special' style="cursor:hand" value="<%
						if SortA = "z_is_special" then 
							response.write ("A")
						elseif SortD = "z_is_special" then 
							response.write ("D")
						end if
						%>">Otr</td>
                      </tr> 
					  <% DIM selChk %>
                      <% for i=0 To code_list.count-1 %>
					  <% 
							selChk = false
							if SelCnt > 0 then
								selChk = selChkChange(code_list(i)("org_account_number"))
							end if
					  %>
					  <% if ( i mod 2 = 1 ) then%>
                      <tr align="left" height="18" class="bodycopy"  style="background-color:#f3f3f3">
					  <% else %>
                      <tr align="left" height="18" class="bodycopy" style="background-color:white">
					  <% end if %>
                        <td align="center" style="width:5px;"></td>
                        <td style="width:18px; cursor:hand" onClick="DoChecking('<%=code_list(i)("org_account_number")%>');"><img border="0" align="absmiddle" src="../images/checkbox_<% if selChk then  response.write("o") else response.write("n") end if%>.gif" id='img<%=code_list(i)("org_account_number")%>' checkeditem="<% if selChk then  response.write("Y") else response.write("N") end if%>" onClick="ItemWasChecked(this);" WIDTH="10" HEIGHT="10"><input type="hidden" name="chk" id='chkimg<%=code_list(i)("org_account_number")%>' seq='<%=code_list(i)("org_account_number")%>'<% if selChk then response.write (" value='off'") %>></td>	                        
						<td style="width:240px;"><a href="javascrip:;" OnClick="goProfile('<%=code_list(i)("org_account_number")%>');return false;"><% response.write code_list(i)("dba_name") %></a></td>
                        <td style="width:70px;"><% response.write code_list(i)("class_code") %></td>
						<td style="width:140px;"><% response.write code_list(i)("business_city") %></td>
<!--!                        
                        <td style="width:40px;"><% 'response.write code_list(i)("business_state") %></td>
                        <td style="width:80px;"><% 'response.write code_list(i)("business_country") %></td>
-->
                        <td style="width:130px;"><% response.write code_list(i)("business_phone") %></td>
                        <td style="width:120px;"><% response.write code_list(i)("owner_name") %></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("is_consignee") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("is_shipper") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("is_agent") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("is_carrier") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("z_is_trucker") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("z_is_warehousing") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("z_is_cfs") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("z_is_broker") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("z_is_govt") %></strong></font></td>
                        <td><font color="#CC0000"><strong><% response.write code_list(i)("z_is_special") %></strong></font></td>
                      </tr>
                      <% next %>
                    </table>
                  <% else %>
				  	<table>
				  		<tr>
				  			<td><span class="bodyheader">There are no results to display. Try search again with modified options or <a href="javascript:" onclick="javascript:self.location='/ASP/Master_Data/client_profile_list.asp?PostBack=false';return false;"> click here to return to previous page</a></td>
						</tr>
					</table>
                  <% end if %>

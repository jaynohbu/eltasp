 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid_an.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// ig_WebGrid_an.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
function igtbl_addNewClickDown(evnt,gn) 
{
	if(igtbl_button(gn,evnt)!=0)
		return;
	var se=igtbl_srcElement(evnt);
	
	if(se.tagName=="TD" && se.getAttribute("addNew") && !igtbl_isDisabled(se))
	{
		se.setAttribute("addNewButtonClicked",1);
		igtbl_changeStyle(gn,se,gn+'_SelHeadClass');
	}	
	igtbl_activate(gn);
}

function igtbl_addNewClickUp(evnt,gn) 
{
	if(igtbl_button(gn,evnt)!=0)
		return;
	var se=igtbl_srcElement(evnt);
		
	if(se.tagName=="TD" && se.getAttribute("addNew") && !igtbl_isDisabled(se) && se.getAttribute("addNewButtonClicked"))
	{
		se.removeAttribute("addNewButtonClicked");
		var bandNo=parseInt(se.getAttribute("bandNo"),10);
		var g=igtbl_getGridById(gn);
		var band=g.Bands[bandNo];
		if(band.AddNewRowVisible==1)
		{
			var clickRow=igtbl_getClickRow(g,bandNo);
			var addNewRow=null;
			if(clickRow)
			{
				if(!clickRow.getExpanded())
					clickRow.setExpanded();
				if(clickRow.Rows)
					addNewRow=clickRow.Rows.AddNewRow;
			}
			else
				addNewRow=g.Rows.AddNewRow;
			if(addNewRow)
			{
				var cell=null;
				if(band.getCellClickAction()!=2)
				{
					cell=addNewRow.getCell(0);
					while(cell && (!cell.Column.hasCells() || !cell.Column.getVisible()))
						cell=addNewRow.getCell(cell.Column.Index+1);
					if(cell)
					{
						cell.scrollToView();
						cell.setSelected();
						cell.activate();
					}
				}
				if(!cell)
				{
					addNewRow.scrollToView();
					addNewRow.setSelected();
					addNewRow.activate();
				}
			}
		}
		else
		{
			igtbl_changeStyle(gn,se,null);
			igtbl_addNew(gn,bandNo);
		}
	}
	igtbl_activate(gn);
}

function igtbl_getClickRow(g,bandNo)
{
	var clickRow=null;
	if(g.ActiveCell!="")
		clickRow=igtbl_getRowById(g.ActiveCell);
	else if(g.ActiveRow!="")
		clickRow=igtbl_getRowById(g.ActiveRow);
	if(!clickRow && bandNo==0)
		clickRow=g.Rows.getRow(0);
	if(clickRow && bandNo<clickRow.Band.Index)
	{
		var pr=clickRow;
		while(pr && pr.Band.Index!=bandNo)
			pr=pr.ParentRow;
		if(!pr)
			return null;
		clickRow=pr;
	}
	if(clickRow && bandNo==clickRow.Band.Index)
		clickRow=clickRow.ParentRow;
	return clickRow;
}

function igtbl_addNew(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	if(!g) return null;
	gn=g.Id;
	var band=g.Bands[bandNo];
	if(band.AllowAddNew==2 || band.AllowAddNew==0 && g.AllowAddNew!=1 || band.IsGrouped)
		return null;
	var clickRow=igtbl_getClickRow(g,bandNo);
	if(!clickRow && bandNo!=0 || clickRow && clickRow.Band.Index+1!=bandNo)
		return null;
	return igtbl_rowsAddNew(gn,clickRow);
}


function igtbl_rowsAddNew(gn,clickRow
	,newRow
)
{
	var contentLabel="Ct";
	var valueLabel="V";
	var cellLabel="C";
	var rowLabel="R";
	var cellsLabel="Cs";
	var rowsLabel="Rs"; 
	var g=igtbl_getGridById(gn);
	var band=g.Bands[(clickRow?clickRow.Band.Index+1:0)];
	var rows=(clickRow?clickRow.Rows:g.Rows);
	var fac=band.firstActiveCell;
	var table=band.curTable;
	var row=null,rowObj=null;
	if(g.Rows.Node)
	{
		g.noMoreRows=true;
		window.setTimeout("igtbl_cancelNoMoreRows('"+g.Id+"')",500);
		if(clickRow)
		{
			if(!clickRow.Expandable)
				clickRow.Rows=new igtbl_Rows(null,g.Bands[clickRow.Band.Index+1],clickRow);
			else if(!clickRow.Rows)
			{
				if(g.LoadOnDemand==3 && !clickRow.HiddenElement)
					clickRow.requestChildRows();
				else
					clickRow.Rows=new igtbl_Rows(clickRow.Node.selectSingleNode(rowsLabel),g.Bands[clickRow.Band.Index+1],clickRow);					
			}
			rows=clickRow.Rows;
		}
		var doc=g.Xml.XMLDocument;
		var xmlns=g.XmlNS;
		if(igtbl_fireEvent(g.Id,g.Events.BeforeRowInsert,"(\""+g.Id+"\",\""+(rows.ParentRow?rows.ParentRow.Element.id:"")+"\")")==true)
			return null;
		if(rows.ParentRow && !rows.ParentRow.getExpanded())
			rows.ParentRow.setExpanded(true);
		var toExisting=(typeof(rows.Node)!="undefined");
		if(!toExisting)
		{
			rows.Node=doc.createNode(1,rowsLabel,xmlns);
			rows.SelectedNodes=rows.Node.selectNodes(rowLabel);	
			var pr=rows.ParentRow;
			pr.Node.appendChild(rows.Node);
			if(!pr.Expandable)
			{
				pr.Expandable=true;
				pr.Element.childNodes[0].innerHTML="<img src="+pr.Band.getExpandImage()+" border=0 onclick=\"igtbl_toggleRow(event);\">";
			}
		}
		var rowsNode=doc.createNode(1,rowsLabel,xmlns);
		g.Node.appendChild(rowsNode);
		var rowNode=doc.createNode(1,rowLabel,xmlns);
		var lrId=rows.getLastRowId();
		if(!lrId)
			rowNode.setAttribute("i",rows.length);
		else
		{
			var lr=lrId.split("_");
			rowNode.setAttribute("i",parseInt(lr[lr.length-1],10)+1);
		}
		if(rows.AddNewRow && rows.Band.Index<g.Bands.length-1 && g.Bands[rows.Band.Index+1].AllowAddNew==1)
			rowNode.setAttribute("showExpand","true");
		if(g.IsXHTML)
			rowNode.setAttribute("lit:dtdh","0");
		rowsNode.appendChild(rowNode);
		var cells=doc.createNode(1,cellsLabel,xmlns);
		rowNode.appendChild(cells);
		for(var i=0;i<rows.Band.Columns.length;i++)
		{
			if(rows.Band.Columns[i].ServerOnly) continue;
			var cell=doc.createNode(1,cellLabel,xmlns);
			cells.appendChild(cell);			
			var content=doc.createNode(1,contentLabel,xmlns);
			cell.appendChild(content);
			var cdata=doc.createNode(4,"",xmlns);
			content.appendChild(cdata);
			var value=doc.createNode(1,valueLabel,xmlns);
			cell.appendChild(value);
		}
		var offsetSO=0;
		for(var i=0;i<rows.Band.Columns.length;i++)
		{
			if(rows.Band.Columns[i].ServerOnly)
			{
				++offsetSO;
				continue;
			}
			var selCells=cells.selectNodes(cellLabel);
			var column=rows.Band.Columns[i];
			var cellNode=selCells[column.get("index")-1-offsetSO];
			var st=column.Style;
			if(column.CssClass)
				cellNode.setAttribute("class",column.CssClass);
			if(column.Hidden)
				st+="display:none;";
			if(st)
				cellNode.setAttribute("style",st);
			var it_str="";
			if(!column.Wrap)
				it_str+="<nobr>";
			switch(column.ColumnType)
			{
				case 3:
					it_str+="<input type=checkbox"+(column.getAllowUpdate()==1?"":" disabled")+" on"+(ig_csom.IsIE?"property":"")+"change='igtbl_chkBoxChange(event,\""+g.Id+"\");'>";
					break;
				case 7:
					var bc=column.ButtonClass;
					var bs=column.ButtonStyle;
					if(column.CellButtonDisplay==1)
						it_str+="<input type=button style='"+bs+"' onclick=\"igtbl_colButtonClick(event,'"+g.Id+"');\""+(bc==""?"":" class='"+bc+"'")+">";
					else
						it_str+="&nbsp;";
					break;
				case 9:
					it_str+="<a href=''>&nbsp;</a>";
					break;
				default:
					it_str+="&nbsp;";
					break;
			}
			if(!column.Wrap)
				it_str+="</nobr>";
			cellNode.firstChild.firstChild.text=it_str;
		}
		if(toExisting
			|| newRow
			)
		{
			var strTransform="";
			strTransform=rows.applyXslToNode(rowsNode,rows.length);
			g.Node.removeChild(rowsNode);
			if(strTransform)
			{
				rows.Node.appendChild(rowNode);
				rows.length++;
				rows.SelectedNodes=rows.Node.selectNodes(rowLabel);
				g._innerObj.innerHTML=strTransform;
				var addedRow=g._innerObj.firstChild.rows[0];
				if(g.UseFixedHeaders)
				{
					 var drs=addedRow.cells[addedRow.cells.length-1].firstChild;
					 if(drs.tagName=="DIV" && drs.id && drs.id.length>4 && drs.id.substr(drs.id.length-4)=="_drs")
						drs.firstChild.style.left=-g._scrElem.scrollLeft;
				}
				
				if(rows.Band.AddNewRowVisible==1 && rows.Band.AddNewRowView==2 && rows.Element.childNodes.length>0 && rows.AddNewRow.Element.parentNode==rows.Element)
					rows.Element.insertBefore(addedRow,rows.AddNewRow.Element);
				else
				
					rows.Element.appendChild(addedRow);
				if(g.UseFixedHeaders && g.IsXHTML)
				{
					 var drs=addedRow.cells[addedRow.cells.length-1].firstChild;
					 if(drs.tagName=="DIV" && drs.id && drs.id.length>4 && drs.id.substr(drs.id.length-4)=="_drs")
						drs.parentNode.style.height=drs.firstChild.offsetHeight;
				}
			}
		}
		else
		{
			rows.length++;
			rows.Node.appendChild(rowNode);
			rows.SelectedNodes=rows.Node.selectNodes(rowLabel);
			rows.ParentRow.setExpanded(true);
		}
		var rowObj=rows.getRow(rows.length-1);
		rows.setLastRowId(rowObj.Id);
		rowObj.Node.setAttribute("i",rows.length-1);	
		if(g.LoadOnDemand==3)
		{
			rowObj._dataChanged|=1;
			g.invokeXmlHttpRequest(g.eReqType.AddNewRow,rows);
		}
		else
			g._recordChange("AddedRows",rowObj);
		for(var i=0;i<rowObj.Band.Columns.length;i++)
		{
			var cellObj=rowObj.getCell(i);
			if(newRow)
				cellObj.setValue(newRow.getCell(i).getValue());
			else
				cellObj.setValue(cellObj.Column.getValueFromString(cellObj.Column.DefaultValue));
		}
		if(!newRow)
		{
			rowObj.activate();
			g.setNewRowImg(rowObj);
		}
		igtbl_fireEvent(g.Id,g.Events.InitializeRow,"(\""+g.Id+"\",\""+rowObj.Element.id+"\");");
		var oldNPB=g.NeedPostBack;
		igtbl_fireEvent(g.Id,g.Events.AfterRowInsert,"(\""+g.Id+"\",\""+rowObj.Element.id+"\");");
		if(!oldNPB && g.NeedPostBack && !g.Events.AfterRowInsert[1]&1 || g.LoadOnDemand==3)
			g.NeedPostBack=false;
		g.alignDivs();
		rowObj.scrollToView();
		row=rowObj.Element;
	}
	else
	{
		var nfrow=null;
		var setHeight=false;
		if(!table)
		{
			var hidRow=document.createElement("tr");
			var rn=clickRow.Element.id.split("_");
	
		rn[0]=gn+"_rh";
			hidRow.id=rn.join("_");
			hidRow.setAttribute("hiddenRow",true);
			if(g.Bands[band.Index-1].IndentationType!=2)
			{
				var ec=document.createElement("td");
				ec.className=igtbl_getExpAreaClass(gn,band.Index-1);
				ec.style.borderWidth=0;
				ec.style.textAlign="center";
				ec.style.padding=0;
				
				
				ec.innerHTML="&nbsp;";
				hidRow.appendChild(ec);
				if(igtbl_getRowSelectors(gn,band.Index-1)==1)
				{
					var rsc=document.createElement("td");
					rsc.className=igtbl_getRowLabelClass(gn,band.Index-1);
					rsc.innerHTML="&nbsp;";
					hidRow.appendChild(rsc);
				}
			}
			var majCell=document.createElement("td");
			var tBody;
			majCell.style.overflow="auto";
			majCell.style.border=0;
			majCell.style.width="100%";
			majCell.colSpan=g.Bands[band.Index-1].VisibleColumnsCount+(g.Bands[band.Index-1].IndentationType==2?2:0);
			hidRow.appendChild(majCell);
			if(band.HeaderHTML)
			{
				var str="<table>"+band.HeaderHTML+"<tbody></tbody>";
				if(band.ColFootersVisible==1 && band.FooterHTML)
					str+=band.FooterHTML;
				str+="</table>";
				majCell.innerHTML=str;
				table=majCell.firstChild;
				tBody=table.tBodies[0];
			}
			else
				table=document.createElement("table");
			rn[0]=gn+"t";
			table.id=rn.join("_");
			table.border=0;
			table.cellPadding=g.Element.cellPadding;
			table.cellSpacing=g.Element.cellSpacing;
			table.setAttribute("bandNo",band.Index);
			table.style.cssText=g.Element.style.cssText;
			table.style.position="";
			table.style.width="";
			if(!band.HeaderHTML)
			{
				majCell.appendChild(table);
				var colGr=document.createElement("colgroup");
				var col;

				col=document.createElement("col");
				if(band.Indentation>0)
					col.width=band.Indentation;
				else
					col.style.display="none";
				colGr.appendChild(col);

				if(igtbl_getRowSelectors(gn,band.Index)==1)
				{
					col=document.createElement("col");
					col.width=(band.RowLabelWidth?band.RowLabelWidth:"22px");
					colGr.appendChild(col);
				}
				for(var i=0;i<band.Columns.length;i++)
				{
					var clmn=band.Columns[i];
					if(!clmn.getHidden() && clmn.hasCells())
					{
						col=document.createElement("col");
						col.width=clmn.Width;
						colGr.appendChild(col);
					}
				}
				for(var i=0;i<band.Columns.length;i++)
					if(band.Columns[i].getHidden())
					{
						col=document.createElement("col");
						col.width="";
						colGr.appendChild(col);
					}
				table.appendChild(colGr);
				var tHead=document.createElement("thead");
				igtbl_addEventListener(tHead,"mousedown",igtbl_headerClickDown);
				igtbl_addEventListener(tHead,"mouseup",igtbl_headerClickUp);
				igtbl_addEventListener(tHead,"mouseout",igtbl_headerMouseOut);
				igtbl_addEventListener(tHead,"mousemove",igtbl_headerMouseMove);
				igtbl_addEventListener(tHead,"mouseover",igtbl_headerMouseOver);
				igtbl_addEventListener(tHead,"contextmenu",igtbl_headerContextMenu);
				var tr=document.createElement("tr");
				var th;
				var img;

				th=document.createElement("th");
				if(g.Bands[band.Index-1].IndentationType==2)
					th.className=igtbl_getExpAreaClass(gn,band.Index);
				else
					th.className=band.NonSelHeaderClass;
				th.height=band.DefaultRowHeight;
				img=document.createElement("img");
				img.src=g.BlankImage;
				img.border=0;
				th.appendChild(img);
				tr.appendChild(th);

				if(igtbl_getRowSelectors(gn,band.Index)==1)
				{
					th=document.createElement("th");
					th.className=band.NonSelHeaderClass;
					th.height=band.DefaultRowHeight;
					img=document.createElement("img");
					img.src=g.BlankImage;
					img.border=0;
					th.appendChild(img);
					tr.appendChild(th);
				}
				for(var i=0;i<band.Columns.length;i++)
				{
					var column=band.Columns[i];
					if(g.UseFixedHeaders && !column.Fixed && !nfrow)
					{
						var nftd=document.createElement("th");
						nftd.colSpan=band.Columns.length-column.Index;
						if(!g.IsXHTML)
							nftd.width="100%";
						else
						{
							nftd.style.verticalAlign="top";
							setHeight=true;
						}
						tr.appendChild(nftd);
						var nfd=document.createElement("div");
						nftd.appendChild(nfd);
						nfd.id=g.Id+"_drs";
						nfd.style.overflow="hidden";
						if(!g.IsXHTML)
							nfd.style.width="100%";
						nfd.style.height="100%";
						if(g.IsXHTML)
							nfd.style.position="relative";
						var nftable=document.createElement("table");
						nfd.appendChild(nftable);
						nftable.border="0";
						nftable.cellPadding=g.Element.cellPadding;
						nftable.cellSpacing=g.Element.cellSpacing;
						nftable.style.position="relative";
						nftable.style.tableLayout="fixed";
						nftable.height="100%";
						var nfcgs=document.createElement("colgroup");
						nftable.appendChild(nfcgs);
						for(var j=column.Index;j<band.Columns.length;j++)
						{
							if(band.Columns[j].hasCells() && !band.Columns[j].getHidden())
							{
								var nfcg=document.createElement("col");
								nfcg.width=band.Columns[j].Width;
								nfcgs.appendChild(nfcg);
							}
						}
						for(var j=column.Index;j<band.Columns.length;j++)
						{
							if(band.Columns[j].hasCells() && band.Columns[j].getHidden())
							{
								var nfcg=document.createElement("col");
								nfcg.width="1px";
								nfcg.style.display="none";
								nfcgs.appendChild(nfcg);
							}
						}
						var nftb=document.createElement("tbody");
						nftable.appendChild(nftb);
						nfrow=document.createElement("tr");
						nftb.appendChild(nfrow);
					}
					if(!column.Hidden && column.hasCells())
					{
						th=document.createElement("th");
						th.id=gn+"_c"+"_"+band.Index+"_"+i.toString();
						th.className=column.getHeadClass();
						th.setAttribute("columnNo",i);
						th.innerHTML=column.HeaderText;
						if (th.innerText)
							th.innerHTML=th.innerText;
						else if (th.lastChild && th.lastChild.data && th.lastChild.nodeName=="#text")
							th.innerHTML=th.lastChild.data;
						if(nfrow)
						{
							nfrow.appendChild(th);
							if(setHeight)
							{
								var nftd=nfrow.parentNode.parentNode.parentNode.parentNode;
								nftd.style.height=th.offsetHeight;
								setHeight=false;
							}
						}
						else
							tr.appendChild(th);
					}
				}
				tHead.appendChild(tr);
				if(band.ColHeadersVisible!=1)
					tHead.style.display="none";
				table.appendChild(tHead);
				tBody=document.createElement("tbody");
				table.appendChild(tBody);
			}
			if(band.ColFootersVisible==1 && !band.FooterHTML)
			{
				var tFoot=document.createElement("tfoot");
				var tr=document.createElement("tr");
				var th;

				th=document.createElement("th");
				th.className=igtbl_getExpAreaClass(gn,band.Index);
				th.height=band.DefaultRowHeight;
				th.innerHTML="&nbsp;";
				tr.appendChild(th);

				if(igtbl_getRowSelectors(gn,band.Index)==1)
				{
					th=document.createElement("th");
					th.className=igtbl_getRowLabelClass(gn,band.Index);
					th.height=band.DefaultRowHeight;
					th.innerHTML="&nbsp;";
					tr.appendChild(th);
				}
				nfrow=null;
				setHeight=false;
				for(var i=0;i<band.Columns.length;i++)
				{
					var column=band.Columns[i];
					if(g.UseFixedHeaders && !column.Fixed && !nfrow)
					{
						var nftd=document.createElement("th");
						nftd.colSpan=band.Columns.length-column.Index;
						if(!g.IsXHTML)
							nftd.width="100%";
						else
						{
							nftd.style.verticalAlign="top";
							setHeight=true;
						}
						tr.appendChild(nftd);
						var nfd=document.createElement("div");
						nftd.appendChild(nfd);
						nfd.id=g.Id+"_drs";
						nfd.style.overflow="hidden";
						if(!g.IsXHTML)
							nfd.style.width="100%";
						nfd.style.height="100%";
						if(g.IsXHTML)
							nfd.style.position="relative";
						var nftable=document.createElement("table");
						nfd.appendChild(nftable);
						nftable.border="0";
						nftable.cellPadding=g.Element.cellPadding;
						nftable.cellSpacing=g.Element.cellSpacing;
						nftable.style.position="relative";
						nftable.style.tableLayout="fixed";
						nftable.height="100%";
						var nfcgs=document.createElement("colgroup");
						nftable.appendChild(nfcgs);
						for(var j=column.Index;j<band.Columns.length;j++)
						{
							if(band.Columns[j].hasCells() && !band.Columns[j].getHidden())
							{
								var nfcg=document.createElement("col");
								nfcg.width=band.Columns[j].Width;
								nfcgs.appendChild(nfcg);
							}
						}
						for(var j=column.Index;j<band.Columns.length;j++)
						{
							if(band.Columns[j].hasCells() && band.Columns[j].getHidden())
							{
								var nfcg=document.createElement("col");
								nfcg.width="1px";
								nfcg.style.display="none";
								nfcgs.appendChild(nfcg);
							}
						}
						var nftb=document.createElement("tbody");
						nftable.appendChild(nftb);
						nfrow=document.createElement("tr");
						nftb.appendChild(nfrow);
					}
					if(!column.Hidden && column.hasCells())
					{
						th=document.createElement("th");
						th.id=gn+
						"_"+
						"f"+"_"+band.Index+"_"+i.toString();
						th.className=igtbl_getFooterClass(gn,band.Index,i);
						th.innerHTML="&nbsp;";
						if(nfrow)
						{
							nfrow.appendChild(th);
							if(setHeight)
							{
								var nftd=nfrow.parentNode.parentNode.parentNode.parentNode;
								nftd.style.height=th.offsetHeight;
								setHeight=false;
							}
						}
						else
							tr.appendChild(th);
					}
				}
				tFoot.appendChild(tr);
				table.appendChild(tFoot);
			}
			clickRow.Element.childNodes[0].oldInnerHTML=clickRow.Element.childNodes[0].innerHTML;
			clickRow.Element.childNodes[0].innerHTML="<img src="+igtbl_getCollapseImage(gn,band.Index-1)+" border=0 onclick=\"igtbl_toggleRow('"+gn+"','"+clickRow.Element.id+"');\">";
			igtbl_stateExpandRow(gn,clickRow,true);
			clickRow.Element.parentNode.insertBefore(hidRow,clickRow.Element.nextSibling);
			g.ExpandedRows[clickRow.Element.id]=true;
			clickRow.HiddenElement=hidRow;
		}
		row=document.createElement("tr");
		var rowsEl=table.tBodies[0].rows;
		var lastRow,lrObj,altRow;
		if(rowsEl.length>0)
			lastRow=rowsEl[rowsEl.length-1];
		if(lastRow)
		{
			if(lastRow.parentNode.tagName=="TFOOT")
				lastRow=lastRow.previousSibling;
			if(lastRow && lastRow.getAttribute("addNewRow"))
				lastRow=lastRow.previousSibling;
			if(lastRow && lastRow.getAttribute("hiddenRow"))
				lastRow=lastRow.previousSibling;
		}
		if(lastRow)
		{
			lrObj=igtbl_getRowById(lastRow.id);
			altRow=lastRow.getAttribute("alt")!="true" && (band.AltClass!="" || g.AltClass!="");
			var rLastRowId=lrObj.OwnerCollection.getLastRowId();
			if(lastRow.id!=rLastRowId)
			{
				var l1=igtbl_getRowById(rLastRowId);
				if(l1)
				{
					lrObj=l1;
					lastRow=l1.Element;
				}
			}
			var rn=rLastRowId.split("_");
			rn[rn.length-1]=parseInt(rn[rn.length-1],10)+1;
			row.id=rn.join("_");
			lrObj.OwnerCollection.setLastRowId(row.id);
		}
		else
		{
			if(!clickRow)
				row.id=gn+"_r_"+(g.AllowPaging && g.EIRM?(g.CurrentPageIndex-1)*g.PageSize:0)
			else
				row.id=clickRow.Element.id+"_0";
		}
		if(band.DefaultRowHeight!="")
			row.style.height=band.DefaultRowHeight;
		if(igtbl_fireEvent(gn,g.Events.BeforeRowInsert,"(\""+gn+"\",\""+row.id+"\")")==true)
		{
			if(!band.curTable && typeof(clickRow)!="undefined" && clickRow!=null)
			{
				clickRow.Element.childNodes[0].innerHTML=clickRow.Element.childNodes[0].oldInnerHTML;
				clickRow.Element.parentNode.removeChild(table.parentNode.parentNode);
			}
			if(g.NeedPostBack)
				igtbl_doPostBack(gn,"");
			return null;
		}
		if(lastRow)
		{
			lrObj.OwnerCollection.rows[lrObj.OwnerCollection.length]=null;
			lrObj.OwnerCollection.length++;
			if(lrObj.ParentRow)
			{
				lrObj.ParentRow.ChildRowsCount++;
				lrObj.ParentRow.VisChildRowsCount++;
			}
		}
		if(altRow)
			row.setAttribute("alt","true");
		if((band.Index!=0 || !g.StatFooter) && newRow && band.AddNewRowView!=1)
			table.tBodies[0].insertBefore(row,newRow.Element);
		else
		if(lastRow && rowsEl[rowsEl.length-1].parentNode.tagName=="TFOOT")
			table.tBodies[0].insertBefore(row,rowsEl[rowsEl.length-1]);
		else
			table.tBodies[0].appendChild(row);
		if(!clickRow && !rows)
		{
			delete g.Rows;
			g.Rows=new igtbl_Rows(null,g.Bands[0],null);
			g.Rows.length=1;
			g.Rows.rows[0]=null;
		}
		else if(!lastRow && clickRow)
		{
			clickRow.ChildRowsCount=1;
			clickRow.VisChildRowsCount=1;
			if(!clickRow.Rows)
				clickRow.Rows=new igtbl_Rows(null,g.Bands[clickRow.Band.Index+1],clickRow);
			clickRow.Rows.length=1;
			clickRow.Rows.rows[0]=null;
			clickRow.Expandable=true;
		}
		else if(!clickRow && rows && !lastRow)
		{
			rows.length++;
			rows.rows[rows.length-1]=null;
		}
		var phCellNo=0;
		nfrow=null;
		setHeight=false;
		var className;
		if(altRow)
			className=band.getAltClass();
		else
			className=band.getItemClass();
		if(className)
			row.className=className;
		for(var i=0;i<band.Columns.length+fac;i++)
		{
			if(i>=fac && !band.Columns[i-fac].hasCells())
				continue;
			var cell=document.createElement("td");
			var cn;
			if(lastRow)
			{
				cn=row.id.split("_");
				if(i>=fac)
				{
					cn[0]=gn;
					cn[1]="rc";
					cn[cn.length-1]--;
					cn[cn.length]=i-fac;
				}
				else if(lastRow.cells[phCellNo].id)
				{
					cn[1]="l";
					cn[cn.length-1]--;
				}
			}
			else
			{
				if(clickRow)
				{
					cn=clickRow.Element.id.split("_");
					cn[1]="rc";
					cn[cn.length]=-1;
					cn[cn.length]=i-fac;
				}
				else
				{
					cn=new Array();

					cn[0]=gn;
					cn[1]="rc";
					cn[cn.length]=(g.AllowPaging && g.EIRM?(g.CurrentPageIndex-1)*g.PageSize:0)-1;
					cn[cn.length]=i-fac;
				}
			}
			if(band.DefaultRowHeight!="")
				cell.height=band.DefaultRowHeight;
			if(g.Bands.length>1 && phCellNo==0)
			{
				cell.className=igtbl_getExpAreaClass(gn,band.Index);
				
				if(band.Index<g.Bands.length-1 && g.Bands[band.Index+1].AllowAddNew==1 && g.Bands[band.Index+1].AddNewRowVisible==1)
				{
					row.setAttribute("showExpand",true);
					cell.innerHTML="<img src="+band.getExpandImage()+" border=0 onclick=\"igtbl_toggleRow(event);\">";
				}
				else
					cell.innerHTML="<img src='"+g.BlankImage+"' border=0 imgType='blank' style='visibility:hidden;'>";
			}
			else if(igtbl_getRowSelectors(gn,band.Index)==1 && (g.Bands.length>1 && phCellNo==1 || phCellNo==0))
			{
				cell.className=igtbl_getRowLabelClass(gn,band.Index);
				if(lastRow)
				{
					cn[cn.length-1]++;
					cell.id=cn.join("_");
				}
				else
				{
					if(clickRow)
					{
						cn=clickRow.Element.id.split("_");
						cn[1]="l";
						cn[cn.length]=0;
						cell.id=cn.join("_");
					}
					else
						cell.id=gn+"_l_"+(g.AllowPaging && g.EIRM?(g.CurrentPageIndex-1)*g.PageSize:0);
				}
				cell.innerHTML="<img src='"+g.BlankImage+"' border=0 imgType='blank' style='visibility:hidden;'>";
				cell.style.textAlign="center";
			}
			else
			{
				var columnNo=i-fac;
				var column=band.Columns[columnNo];
				if(column.ServerOnly)
				{
					phCellNo++;
					delete cn;
					continue;
				}
				cn[cn.length-2]++;
				cell.id=cn.join("_");
				if(lastRow && lastRow.getAttribute("level"))
				{
					var cl=lastRow.getAttribute("level").split("_");
					cl[cl.length]=i-fac;
					cl[cl.length-2]=parseInt(cl[cl.length-2],10)+1;
					cell.setAttribute("level",cl.join("_"));
				}
				var cwk=cell;
				if(g.UseFixedHeaders && !column.Fixed && !nfrow)
				{
					var nftd=document.createElement("td");
					nftd.colSpan=band.Columns.length-column.Index;
					if(band._optSelectRow)
					{
						nftd.className=g.Id+"-no";
						if(g.IsXHTML)
							setHeight=true;
					}
					else
					{
						if(!g.IsXHTML)
							nftd.width="100%";
						else
						{
							nftd.style.verticalAlign="top";
							setHeight=true;
						}
					}
					row.appendChild(nftd);
					var nfd=document.createElement("div");
					nftd.appendChild(nfd);
					nfd.id=g.Id+"_drs";
					nfd.style.overflow="hidden";
					if(!g.IsXHTML)
						nfd.style.width="100%";
					nfd.style.height="100%";
					if(g.IsXHTML)
						nfd.style.position="relative";
					var nftable=document.createElement("table");
					nfd.appendChild(nftable);
					nftable.border="0";
					nftable.cellPadding=g.Element.cellPadding;
					nftable.cellSpacing=g.Element.cellSpacing;
					nftable.style.position="relative";
					nftable.style.tableLayout="fixed";
					nftable.height="100%";
					var nfcgs=document.createElement("colgroup");
					nftable.appendChild(nfcgs);
					for(var j=column.Index;j<band.Columns.length;j++)
					{
						if(band.Columns[j].hasCells() && !band.Columns[j].getHidden())
						{
							var nfcg=document.createElement("col");
							nfcg.width=band.Columns[j].Width;
							nfcgs.appendChild(nfcg);
						}
					}
					for(var j=column.Index;j<band.Columns.length;j++)
					{
						if(band.Columns[j].hasCells() && band.Columns[j].getHidden())
						{
							var nfcg=document.createElement("col");
							nfcg.width="1px";
							nfcg.style.display="none";
							nfcgs.appendChild(nfcg);
						}
					}
					nftable.style.left=-g._scrElem.scrollLeft;
					var nftb=document.createElement("tbody");
					nftable.appendChild(nftb);
					nfrow=document.createElement("tr");
					var nfrn=row.id.split("_");
					nfrn[1]="nfr";
					nfrow.id=nfrn.join("_");
					nftb.appendChild(nfrow);
				}
				if(column.CssClass && className!=column.CssClass)
					cwk.className+=(cwk.className.length>0?" ":"")+column.CssClass;
				if(column.Style)
					cwk.style.cssText=column.Style;
				if(band.Columns[i-fac].Hidden)
					cell.style.display='none';					
				var it_str="";
				if(!column.Wrap)
					it_str+="<nobr>";
				switch(column.ColumnType)
				{
					case 3:
						it_str+="<input type=checkbox"+(igtbl_getAllowUpdate(gn,band.Index,columnNo)==1?"":" disabled")+" on"+(ig_csom.IsIE?"property":"")+"change='igtbl_chkBoxChange(event,\""+gn+"\");'>";
						break;
					case 7:
						var bc=band.Columns[columnNo].ButtonClass;
						var bs=band.Columns[columnNo].ButtonStyle;
						if(column.CellButtonDisplay==1)
							it_str+="<input type=button style='"+bs+"' onclick=\"igtbl_colButtonClick(event,'"+gn+"');\""+(bc==""?"":" class='"+bc+"'")+">";
						else
							it_str+="&nbsp;";
						break;
					case 9:
						it_str+="<a href=''>&nbsp;</a>";
						break;
					default:
						it_str+="&nbsp;";
						break;
				}
				if(!column.Wrap)
					it_str+="</nobr>";
				cwk.innerHTML=it_str;
			}
			if(nfrow)
			{
				nfrow.appendChild(cell);
				if(setHeight)
				{
					var nftd=nfrow.parentNode.parentNode.parentNode.parentNode;
					nftd.style.height=cell.offsetHeight;
					setHeight=false;
				}
			}
			else
				row.appendChild(cell);
			phCellNo++;
			delete cn;
		}
		rowObj=igtbl_getRowById(row.id);
		if(lastRow && lastRow.getAttribute("level"))
		{
			var rl=lastRow.getAttribute("level").split("_");
			rl[rl.length-1]=parseInt(rl[rl.length-1],10)+1;
			row.setAttribute("level",rl.join("_"));
		}
		else if(clickRow && clickRow.Element.getAttribute("level"))
		{
			var rl=clickRow.Element.getAttribute("level").split("_");
			rl[rl.length]=0;
			row.setAttribute("level",rl.join("_"));
		}
		var parRow=table.parentNode.parentNode.previousSibling;
		if(parRow && parRow.childNodes[0].childNodes.length>0 && parRow.childNodes[0].childNodes[0].tagName=="IMG" && parRow.childNodes[0].childNodes[0].style.display=="none")
			parRow.childNodes[0].childNodes[0].style.display="";
		g._recordChange("AddedRows",rowObj);
		for(var i=0;i<rowObj.Band.Columns.length;i++)
		{
			var cellObj=rowObj.getCell(i);
			if(newRow)
				cellObj.setValue(newRow.getCell(i).getValue());
			else
				cellObj.setValue(cellObj.Column.getValueFromString(cellObj.Column.DefaultValue));
		}
		if(band.Index>0 && table.parentNode.parentNode.style.display=="none")
			igtbl_toggleRow(gn,table.parentNode.parentNode.previousSibling.id,table.parentNode.parentNode.id);
		if(!newRow)
		{
			igtbl_setActiveRow(gn,row);
			igtbl_setNewRowImg(gn,row);
		}
		g._calculateStationaryHeader();
		if(g.UseFixedHeaders)
			g.alignDivs();
		igtbl_scrollToView(gn,row);
		igtbl_fireEvent(gn,g.Events.InitializeRow,"(\""+gn+"\",\""+row.id+"\");");
		var oldNPB=g.NeedPostBack;
		igtbl_fireEvent(gn,g.Events.AfterRowInsert,"(\""+gn+"\",\""+row.id+"\");");
		if(!oldNPB && g.NeedPostBack && !g.Events.AfterRowInsert[1]&1)
			g.NeedPostBack=false;
	}
	if(g.NeedPostBack)
		igtbl_doPostBack(gn,"");
	if(g._recalcRowNumbers)g._recalcRowNumbers(rowObj);	
	return rowObj;
}

function igtbl_addNewMouseOut(evnt,gn) 
{
	var se=igtbl_srcElement(evnt);
	if(se.tagName == "TD" && se.getAttribute("addNew"))
		igtbl_changeStyle(gn,se,null);
}

function igtbl_updateAddNewStatus()
{
}

function igtbl_updateAddNewBox(gn)
{
	var grid=igtbl_getGridById(gn);
	if(!grid.AddNewBoxVisible)
		return;
	var curBandNo=-1;
	var expandable=false;
	var curRow=null;
	var curRowObj=null;
	if(grid.ActiveCell!="")
	{
		var cell=grid.getActiveCell();
		curRowObj=cell.Row;
		curRow=curRowObj.Element;
		curBandNo=curRowObj.Band.Index;
		if(curRowObj.Expandable && curRowObj.HiddenElement)
			expandable=true;
	}
	else if(grid.ActiveRow!="")
	{
		curRowObj=grid.getActiveRow();
		curRow=curRowObj.Element;
		curBandNo=curRowObj.Band.Index;
		if(curRowObj.Expandable && curRowObj.HiddenElement)
			expandable=true;
	}
	else
	{
		curRowObj=grid.Rows.getRow(0);
		if(curRowObj)
			curRow=curRowObj.Element;
	}
	
	for(var i=0;i<grid.Bands.length;i++)
	{
		
		if(grid.Bands[i].AllowAddNew==2 || grid.Bands[i].AllowAddNew==0 && grid.AllowAddNew!=1 || grid.Bands[i].IsGrouped)
			igtbl_setDisabled(grid.Bands[i].addNewElem,true);
		
		else if(curBandNo==-1 && i==0 || 
				i<=curBandNo || 
					i==curBandNo+1 && 
					!grid.Bands[i].IsGrouped && 
					!(grid.Bands[curBandNo].IsGrouped && curRowObj.GroupByRow) && 
					(grid.Bands[curBandNo].getExpandable()==1 || curRowObj.getExpanded() ) && 
					(!curRow.getAttribute("showExpand") || curRowObj.HiddenElement || (curRowObj.getChildRows()==null && grid.Bands[i].AddNewRowVisible==1) ) 
					
				)
		{	
			if(i==curBandNo+1)
			{
				if(curRowObj && curRowObj.IsAddNewRow)
				{
					igtbl_setDisabled(grid.Bands[i].addNewElem,true);
					continue;
				}
				if(expandable)
 					grid.Bands[i].curTable=curRow.nextSibling.childNodes[grid.Bands[i-1].IndentationType==2?0:grid.Bands[i-1].firstActiveCell].childNodes[0];
 				else if(i==0)
 					grid.Bands[i].curTable=grid.Element;
 				else
 					grid.Bands[i].curTable=null;
			}
			
			else
			{
				var cr=curRowObj;
				for(var j=curBandNo;j>=i;j--)
				{
					if(j>0)
						grid.Bands[j].curTable=cr?cr.Element.parentNode.parentNode:null;					
					if(cr)
					do
					{						
						cr=cr.ParentRow;
					}while(cr && cr.GroupByRow)
				}
			}
			igtbl_setDisabled(grid.Bands[i].addNewElem,false);
		}
		else 
			igtbl_setDisabled(grid.Bands[i].addNewElem,true);
	}
}

function igtbl_cancelNoMoreRows(gn)
{
	var g=igtbl_getGridById(gn);
	if(!g) return;
	g.noMoreRows=false;
}

 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// ig_WebGrid.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
var igtbl_lastActiveGrid="";
var igtbl_isXHTML=document.compatMode=="CSS1Compat";
var testVariable = null;
var igtbl_sUnmaskedValue="uV";
var igtbl_sigCellText="iCT";
var igtbl_sigDataValue="iDV";
function igtbl_initGrid(gridId) 
{
	var xml=ig_csom.getElementById(gridId+"_xml");
	var gridElement=igtbl_getElementById("G_"+gridId);
	var grid=new igtbl_Grid(gridElement,xml);
	var expRowsIds=grid._AddnlProps[3];
	for(var i=0;i<expRowsIds.length;i++)
		if(!xml)
		{
			var splitId=expRowsIds[i].split(";");
			igtbl_stateExpandRow(grid.Id,null,true,splitId[0],splitId[1]);
		}
		else
			igtbl_toggleRow(grid.Id,expRowsIds[i],true);
	var selRowsIds=grid._AddnlProps[4];
	for(i=0;i<selRowsIds.length;i++)
		igtbl_selectRow(grid.Id,selRowsIds[i]);
	var selCellsIds=grid._AddnlProps[5];
	for(i=0;i<selCellsIds.length;i++)
		igtbl_selectCell(grid.Id,selCellsIds[i]);
	var selColsIds=grid._AddnlProps[13];
	for(i=0;selColsIds && i<selColsIds.length;i++)
		igtbl_selectColumn(grid.Id,selColsIds[i]);
	var activeCellId=grid._AddnlProps[6];
	var activeRowId=grid._AddnlProps[7];
	var sortedColsIds=grid._AddnlProps[8];
	if(sortedColsIds)
		grid.addSortColumn(sortedColsIds);
	var de=grid.getDivElement();
	var scrollLeft=grid._AddnlProps[9];
	if(scrollLeft && !grid.UseFixedHeaders)
	{
		igtbl_scrollLeft(de,scrollLeft);
		grid.alignStatMargins();
	}
	var mainGrid=grid.MainGrid;
	if(ig_csom.IsNetscape6)
	{
		igtbl_adjustNNHeight(grid,parseInt(mainGrid.style.height));
		if(mainGrid.style.height.indexOf("%")>0)
			igtbl_oldOnBodyResize=igtbl_addEventListener(window,"resize",igtbl_onBodyResize,false);
		if(!grid.StatHeader)
			window.setTimeout(igtbl_onBodyResize,500);
	}
	if(!mainGrid.style.height && de.clientHeight!=de.scrollHeight)
	{
		var scDiv=document.createElement("DIV");
		scDiv.innerHTML="&nbsp;";
		scDiv.style.height=de.scrollHeight-de.clientHeight+1;
		de.appendChild(scDiv);
		de.style.overflowY="hidden";
	}
	grid.alignDivs(scrollLeft);
	if(grid.UseFixedHeaders
	|| grid.XmlLoadOnDemandType!=0
	)
	{
		grid.alignStatMargins();
	}
	var scrollTop=grid._AddnlProps[10];
	if(scrollTop)
		igtbl_scrollTop(de,scrollTop);
	if(scrollTop || scrollLeft)
	{
		var st=de.scrollTop.toString();
		de.setAttribute("noOnScroll","true");
		de.setAttribute("oldSL",de.scrollLeft.toString());
		de.setAttribute("oldST",st);
		grid.cancelNoOnScrollTimeout=window.setTimeout("igtbl_cancelNoOnScroll('"+grid.Id+"')",100);
	}
	if(activeCellId)
	{
		grid.setActiveCell(igtbl_getCellById(activeCellId));
		var cell=grid.oActiveCell;
		if(cell)
		{
			cell.scrollToView();
			if(cell.Band.getSelectTypeCell()==3)
				grid.Element.setAttribute("startPointCell",cell.Element.id);
		}
	}
	else if(activeRowId)
	{
		grid.setActiveRow(igtbl_getRowById(activeRowId));
		var row=grid.oActiveRow;
		if(row)
		{
			row.scrollToView();
			if(row.Band.getSelectTypeRow()==3)
				grid.Element.setAttribute("startPointRow",row.Element.id);
		}
	}
	grid._cb=typeof igtbl_editEvt=="function";
	grid._unsel=function(e,g)
	{
		if(!e)return;
		try{if(e.nodeName=="TD"||e.nodeName=="DIV")e.unselectable="on";}catch(ex){return;}
		var i=-1,n=e.childNodes;
		while(++i<n.length)g._unsel(n[i],g);
	}
	
	
	grid._fromServerActiveRow=grid.oActiveRow;
		
	grid.GridIsLoaded=true;
	igtbl_fireEvent(grid.Id,grid.Events.InitializeLayout,'("'+grid.Id+'");');
	
	try
	{
		
		if(!document.activeElement && (activeCellId || activeRowId))
			igtbl_activate(gridId);
	}
	catch(e){;}
	
	return grid;
}

// use igcsom.getElementById wherever is possible 
function igtbl_getElementById(tagId) 
{
	var obj=ig_csom.getElementById(tagId);
	if(obj && obj.length && typeof(obj.tagName)=="undefined")
	{
		var i=0;
		while(i<obj.length && (obj[i].id!=tagId || !igtbl_isVisible(obj[i]))) i++;
		if(i<obj.length) obj=obj[i];
		else obj=obj[0];
	}
	return obj;
}

function igtbl_getChildElementById(parent,id)
{
	if(!id || !parent.childNodes || !parent.childNodes.length)
		return null;
	for(var i=0;i<parent.childNodes.length;i++)
		try{
			if(parent.childNodes[i].id && parent.childNodes[i].id==id)
				return parent.childNodes[i];
			var che=igtbl_getChildElementById(parent.childNodes[i],id);
			if(che)
				return che;
		}catch(ex){;}
	return null;
}
function igtbl_getChildElementsById(parent,id)
{
	if(!id || !parent.childNodes || !parent.childNodes.length)
		return null;
	var array=[];
	for(var i=0;i<parent.childNodes.length;i++)
		try
		{
			if(parent.childNodes[i].id && parent.childNodes[i].id==id)
				array[array.length]=parent.childNodes[i];
			var ches=igtbl_getChildElementsById(parent.childNodes[i],id);
			if(ches)
				array=array.concat(ches);
		}
		catch(ex){;}
	if(array.length)
		return array;
	return null;
}

function igtbl_getGridById(gridId) 
{
	if(typeof(igtbl_gridState)=="undefined")
		return null;
	var grid=igtbl_gridState[gridId];
	if(!grid)
		for(var gId in igtbl_gridState)
			if(igtbl_gridState[gId].UniqueID==gridId || igtbl_gridState[gId].ClientID==gridId)
			{
				grid=igtbl_gridState[gId];
				break;
			}
	return grid;
}

function igtbl_getBandById(tagId) 
{
	if(!tagId)
		return null;
	var parts = tagId.split("_");
	var gridId = parts[0];
	var el=igtbl_getElementById(tagId);
	var bandIndex=igtbl_getBandNo(el);
	var objTypeId = parts[1];

	if(objTypeId=="c" && el && el.tagName=="TH")
	{
		bandIndex=parts[2];
	}
	if(!igtbl_getGridById(gridId))
		return null;
	var grid = igtbl_getGridById(gridId);
	return grid.Bands[bandIndex];
}

function igtbl_getColumnById(tagId) 
{
	if(!tagId)
		return null;
	var parts = tagId.split("_");
	var bandIndex = parts.length - 2;
	var gridId = parts[0];
	var objTypeId = parts[1];
	var el=igtbl_getElementById(tagId);
	
	if(objTypeId=="anc" && el && el.tagName=="TD")
	{
		bandIndex=igtbl_getBandById(tagId).Index;
	}
	else

if(objTypeId=="rc" && el && el.tagName=="TD")
	{
		bandIndex=igtbl_getBandById(tagId).Index;
	}
	else if(objTypeId=="cf")
	{
		if(el && el.tagName!="TH")
			return null;
		bandIndex=parts[2];
	}
	else if(objTypeId=="cg")
	{
		if(el && el.tagName!="DIV")
			return null;
		bandIndex=parts[2];
	}
	else if (objTypeId=="c")
	{
		if (el && el.tagName!="TH")
			return;
		bandIndex=parts[2];			
	}
	else
		return null;

	if(!igtbl_getGridById(gridId))
		return null;
	var grid = igtbl_getGridById(gridId);
	var band = grid.Bands[bandIndex];
	var colIndex = parts[parts.length - 1];
	return band.Columns[colIndex];
}


function _validateGrid(gridId)
{
	return (igtbl_getGridById(gridId)!=null) ;
}

function igtbl_getRowById(tagId) 
{
	if(!tagId)
		return null;
	var parts = tagId.split("_");

	var rowTypeId = parts[1];
	var gridId = parts[0];
	var row=null;
	var isGrouped=false;
		
	var gridIdStore = gridId;
	if(rowTypeId == "anfr")
	{
		row=igtbl_getWorkRow(igtbl_getElementById(tagId).parentNode.parentNode.parentNode.parentNode.parentNode);
		if(!row || row.tagName!="TR")
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
		}
	}

	if(row==null && rowTypeId=="grc")
	{
		row=igtbl_getElementById(tagId);
		if(typeof(row)!="undefined" && row)
			row=row.parentNode;
		if(!row || !row.getAttribute("groupRow"))
			row=null;
		isGrouped=true;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}
	}
	if(row==null && rowTypeId=="sgr")
	{
		row=igtbl_getWorkRow(igtbl_getElementById(tagId));
		if(!row || !row.getAttribute("groupRow"))
			row=null;
		isGrouped=true;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}		
	}

	if(row==null && rowTypeId=="nfr")
	{
		row=igtbl_getWorkRow(igtbl_getElementById(tagId).parentNode.parentNode.parentNode.parentNode.parentNode);
		if(!row || row.tagName!="TR")
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}			
	}
	if(row==null && rowTypeId=="anr")
	{
		row=igtbl_getElementById(tagId);
		if(!row || row.tagName!="TR")
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}			
	}
	if(row==null && rowTypeId=="anl")
	{
		row=igtbl_getElementById(tagId);
		if(typeof(row)!="undefined" && row)
			row=row.parentNode;
		if(!row || row.tagName!="TR")
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}			
	}
	if(row==null && rowTypeId=="anc")
	{
		row=igtbl_getElementById(tagId);
		if(typeof(row)!="undefined" && row)
			row=row.parentNode;

		if(row.id.substr(0,gridId.length+5)==gridId+"_anfr")
			do{
				row=row.parentNode
			}while(row && row.tagName!="TR");
		if(!row || row.tagName!="TR")
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}			
	}
	if(row==null && rowTypeId=="gr")
	{
		row=igtbl_getElementById(tagId);
		if(!row || !row.getAttribute("groupRow"))
			row=null;
		isGrouped=true;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}		
	}
	if(row==null && rowTypeId=="rh")
	{
		row=igtbl_getElementById(tagId);
		if(typeof(row)!="undefined" && row)
			row=row.previousSibling;
		if(!row || !row.getAttribute("hiddenRow"))
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}			
	}
	if(row==null && rowTypeId=="rc")
	{
		row=igtbl_getElementById(tagId);
		if(typeof(row)!="undefined" && row)
			row=row.parentNode;


		if(row.id.substr(0,gridId.length+1)==gridId.substr(0,gridId.length-2)+"_nfr")
			do{
				row=row.parentNode
			}while(row && row.tagName!="TR");
		if(!row || row.tagName!="TR")
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}			
	}
	if(row==null && rowTypeId=="r")
	{
		row=igtbl_getElementById(tagId);
		if(!row || row.tagName!="TR")
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}			
	}
	if(row==null && rowTypeId=="l")
	{
		row=igtbl_getElementById(tagId);
		if(typeof(row)!="undefined" && row)
			row=row.parentNode;
		if(!row || row.tagName!="TR")
			row=null;
			
		if (row && !_validateGrid(gridId))
		{
			row=null
			gridId=gridIdStore;
			isGrouped=false;
		}			
	}
	if(row==null)
		return null;
	var gs=igtbl_getGridById(gridId);
	if(!gs)
		return null;
	if(typeof(row.Object)!="undefined")
		return row.Object;
	else
	{
		parts=new Array();
		while(true)
		{
			row=igtbl_getWorkRow(row,gridId);
			var level=-1;
			if(gs.Bands.length==1 && !gs.Bands[0].IsGrouped)
			{
				level=row.sectionRowIndex;
				if(!gs.StatHeader && gs.Bands[0].AddNewRowVisible==1 && gs.Bands[0].AddNewRowView==1)
					level--;
			}
			else
				for(var i=0;i<row.parentNode.childNodes.length;i++)
				{
					var r=row.parentNode.childNodes[i];
					if(!r.getAttribute("hiddenRow")
						&& !r.getAttribute("addNewRow")
					)
						level++;
					if(r==row)
						break;
				}
			parts[parts.length]=level;
			if(row.parentNode.parentNode.id==gs.Element.id)
				break;
			row=row.parentNode.parentNode.parentNode.parentNode.previousSibling;
		}
		parts=parts.reverse();
		var rows=gs.Rows;
		for(var i=0;i<parts.length;i++)
		{
			row=rows.getRow(parseInt(parts[i],10),row.Element?null:row);
			if(row && row.Expandable && i<parts.length-1)
				rows=row.Rows;
			else if(i<parts.length-1)
			{
				row=null;
				break;
			}
		}
		if(!row)
			return null;
		delete parts;
		row.Element.Object=row;
		return row;
	}
}

function igtbl_getCellById(tagId) 
{
	if(!tagId)
		return null;
	var parts = tagId.split("_");
	var gridId = parts[0];
	var cellTypeId = parts[1];	

	if( cellTypeId!="rc" )
	{
	if( cellTypeId!="anc")	
			return null;
	}
	var gs=igtbl_getGridById(gridId);
	if(!gs)
		return null;
	
	var row = igtbl_getRowById(igtbl_getRowIdFromCellId(tagId));
	if(!row)
		return null;
	var column=row.Band.Columns[parseInt(parts[parts.length-1],10)];
	return row.getCellByColumn(column);
}
function igtbl_getRowIdFromCellId(id)
{
	if(id==null || id.length==0) return;
	var rowIdAr = id.split("_");
	switch(rowIdAr[1])
	{
		case("rc"):
			rowIdAr[1]="r";
			break;
		case("anc"):
			rowIdAr[1]="anr";
			break;
	}
	
	return rowIdAr.slice(0,rowIdAr.length-1).join("_");
}
function igtbl_getCellByElement(td)
{
	if(td && td.tagName!="TD")
		while(td && td.tagName!="TD")
			td=td.parentNode;
	if(!td) return null;
	if(td.id)
		return igtbl_getCellById(td.id);
	var tr=td.parentNode;
	var row=null;
	while(!row && tr)
	{
		if(tr.tagName=="TR" && tr.id)
			row=igtbl_getRowById(tr.id);
		tr=tr.parentNode;
	}
	if(row)
	{
		if(td.id)
			return igtbl_getCellById(td.id);
		while(td.parentNode && (td.parentNode!=row.Element && td.parentNode!=row.nfElement))
			td=td.parentNode;
		if(td.parentNode && td.tagName=="TD" && td.id)
			return igtbl_getCellById(td.id);
	}
	return null;
}

function igtbl_needPostBack(gn)
{
	igtbl_getGridById(gn).NeedPostBack=true;
}

function igtbl_cancelPostBack(gn)
{
	igtbl_getGridById(gn).CancelPostBack=true;
}

function igtbl_getCollapseImage(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].getCollapseImage();
}

function igtbl_getExpandImage(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].getExpandImage();
}

function igtbl_getCellClickAction(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].getCellClickAction();
}

function igtbl_getSelectTypeCell(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	var res=g.SelectTypeCell;
	if(g.Bands[bandNo].SelectTypeCell!=0)
		res=g.Bands[bandNo].SelectTypeCell;
	return res;
}

function igtbl_getSelectTypeColumn(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	var res=g.SelectTypeColumn;
	if(g.Bands[bandNo].SelectTypeColumn!=0)
		res=g.Bands[bandNo].SelectTypeColumn;
	return res;
}

function igtbl_getSelectTypeRow(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	var res=g.SelectTypeRow;
	if(g.Bands[bandNo].SelectTypeRow!=0)
		res=g.Bands[bandNo].SelectTypeRow;
	return res;
}

function igtbl_getHeaderClickAction(gn,bandNo,columnNo)
{
	var g=igtbl_getGridById(gn);
	var res=g.HeaderClickAction;
	var band=g.Bands[bandNo];
	var column=band.Columns[columnNo];
	if(column.HeaderClickAction!=0)
		res=column.HeaderClickAction;
	else if(band.HeaderClickAction!=0)
		res=band.HeaderClickAction;
	if(res>1)
	{
		if(band.AllowSort!=0)
		{
			if(band.AllowSort==2)
				res=0;
		}
		else if(g.AllowSort==0 || g.AllowSort==2)
			res=0;
	}	
	return res;
}

function igtbl_getAllowUpdate(gn,bandNo,columnNo)
{
	var g=igtbl_getGridById(gn);
	if(typeof(columnNo)!="undefined")
		return g.Bands[bandNo].Columns[columnNo].getAllowUpdate();
	var res=g.AllowUpdate;
	if(g.Bands[bandNo].AllowUpdate!=0)
		res=g.Bands[bandNo].AllowUpdate;
	return res;
}

function igtbl_getAllowColSizing(gn,bandNo,columnNo)
{
	var g=igtbl_getGridById(gn);
	var res=g.AllowColSizing;
	if(g.Bands[bandNo].AllowColSizing!=0)
		res=g.Bands[bandNo].AllowColSizing;
	if(g.Bands[bandNo].Columns[columnNo].AllowColResizing!=0)
		res=g.Bands[bandNo].Columns[columnNo].AllowColResizing;
	return res;
}

function igtbl_getRowSizing(gn,bandNo,row)
{
	var g=igtbl_getGridById(gn);
	var res=g.RowSizing;
	if(g.Bands[bandNo].RowSizing!=0)
		res=g.Bands[bandNo].RowSizing;
	if(row.getAttribute("sizing"))
		res=parseInt(row.getAttribute("sizing"),10);
	return res;
}

function igtbl_getRowSelectors(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].getRowSelectors();
}

function igtbl_getNullText(gn,bandNo,columnNo)
{
	var g=igtbl_getGridById(gn);
	if(g.Bands[bandNo].Columns[columnNo].NullText!="")
		return g.Bands[bandNo].Columns[columnNo].NullText;
	if(g.Bands[bandNo].NullText!="")
		return g.Bands[bandNo].NullText;
	return g.NullText;
}

function igtbl_getEditCellClass(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	if(g.Bands[bandNo].EditCellClass!="")
		return g.Bands[bandNo].EditCellClass;
	return g.EditCellClass;
}

function igtbl_getFooterClass(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].getFooterClass();
}

function igtbl_getGroupByRowClass(gn,bandNo)
{
	return g.Bands[bandNo].getGroupByRowClass();
}

function igtbl_getHeadClass(gn,bandNo,columnNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].Columns[columnNo].getHeadClass();
}

function igtbl_getRowLabelClass(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].getRowLabelClass();
}

function igtbl_getSelGroupByRowClass(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].getSelGroupByRowClass();
}

function igtbl_getSelHeadClass(gn,bandNo,columnNo)
{
	var g=igtbl_getGridById(gn);
	if(g.Bands[bandNo].Columns[columnNo].SelHeadClass!="")
		return g.Bands[bandNo].Columns[columnNo].SelHeadClass;
	if(g.Bands[bandNo].SelHeadClass!="")
		return g.Bands[bandNo].SelHeadClass;
	return g.SelHeadClass;
}

function igtbl_getSelCellClass(gn,bandNo,columnNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].Columns[columnNo].getSelClass();
}

function igtbl_getExpAreaClass(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	return g.Bands[bandNo].getExpAreaClass();
}

function igtbl_getCurrentRowImage(gn,bandNo)
{
	var g=igtbl_getGridById(gn);
	var res=g.CurrentRowImage;
	var band=g.Bands[bandNo];
	if(band.CurrentRowImage!="")
		res=band.CurrentRowImage;
	var au=igtbl_getAllowUpdate(gn,band.Index);
	if(band.RowTemplate!="" && (au==1 || au==3))
	{
		res=g.CurrentEditRowImage;
		if(band.CurrentEditRowImage!="")
			res=band.CurrentEditRowImage;
	}
	return res;
}

function igtbl_toggleRow() 
{
	var srcRow,expand;
	if(arguments.length==1)
	{
		var evnt=arguments[0];
		var se=igtbl_srcElement(evnt);
		if(!se || se.tagName!="IMG")
			return;
		srcRow=se.parentNode.parentNode.id;
	}
	else
	{
		srcRow=arguments[1];
		expand=arguments[2];
	}
	var sr = igtbl_getRowById(srcRow);
	if(!sr) return;
	igtbl_lastActiveGrid=sr.gridId;
	if(typeof(expand)=="undefined")
		expand=!sr.getExpanded();
	if(expand!=false) 
		sr.setExpanded(true);
	else
		sr.setExpanded(false);
}

function igtbl_selectStart(evnt,gn)
{
	var se=igtbl_srcElement(evnt);
	if(se)
	{
		var over=false,cell=null,column=null;		
		while(se && !over)
		{
			
			if(se && (se.tagName=="TABLE" && se.id=="G_"+gn ||
					  se.tagName=="TH" && (column=igtbl_getColumnById(se.id))!=null ||
					  se.tagName=="TD" && (cell=igtbl_getCellById(se.id))!=null)
					)
				over=true;
			se=se.parentNode;
		}
		if(cell)
		{
			if(!(cell.Column.TemplatedColumn&2))
				igtbl_cancelEvent(evnt);
		}
		
		else if(column)
		{
			if( (!(column.TemplatedColumn&1) && se.parentNode.parentNode.tagName=="THEAD") ||
				(!(column.TemplatedColumn&4) && se.parentNode.parentNode.tagName=="TFOOT")
			  )
				igtbl_cancelEvent(evnt);
		}
		else
			igtbl_cancelEvent(evnt);
	}
}

function igtbl_getBandFAC(gn,elem)
{
	var gs=igtbl_getGridById(gn);
	var bandNo=null;
	if(elem.tagName=="TD" || elem.tagName=="TH")
		return igtbl_getBandById(elem.id).firstActiveCell;
	else if(elem.tagName=="TR")
		bandNo=elem.parentNode.parentNode.getAttribute("bandNo");
	else if(elem.tagName=="TABLE")
		bandNo=elem.getAttribute("bandNo");
	if(bandNo)
		return gs.Bands[bandNo].firstActiveCell;
	return null;
}

function igtbl_headerClickDown(evnt,gn) 
{
	if(!evnt && event)
		evnt=event;
	if(!gn && igtbl_lastActiveGrid)
		gn=igtbl_lastActiveGrid;
	if(!gn || !evnt)
		return false;
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	gs.event=evnt;
	igtbl_lastActiveGrid=gn;
	var te=gs.Element;
	te.setAttribute("mouseDown","1");
	var se=igtbl_srcElement(evnt);
	if(se && se.tagName=="IMG" && (se.getAttribute("imgType")=="group" || se.getAttribute("imgType")=="fixed"))
		return;
	while(se && (se.tagName!="TH" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn) && (se.tagName!="DIV" || !se.getAttribute("groupInfo")))
		se=se.parentNode;
	if(!se)
		return;
	if(se.tagName=="TH" && se.parentNode.parentNode.tagName!="TFOOT")
	{
		var colObj=igtbl_getColumnById(se.id);
		if(!colObj) return;
		if(igtbl_fireEvent(gn,gs.Events.MouseDown,"(\""+gn+"\",\""+se.id+"\","+igtbl_button(gn,evnt)+")")==true)
			return true;
		if(igtbl_button(gn,evnt)!=0)
			return;
		var bandNo=colObj.Band.Index;
		var band=colObj.Band;
		if(igtbl_getOffsetX(evnt,se)>igtbl_clientWidth(se)-4 && igtbl_getAllowColSizing(gn,bandNo,colObj.Index)==2)
		{
			te.setAttribute("elementMode", "resize");
			te.setAttribute("resizeColumn", se.id);
			igtbl_lineupHeaders(se.id,band);
			var div,divr;
			if(!document.body.igtbl_resizeDiv)
			{
				div=document.createElement("DIV");
				div.style.zIndex=10000;
				div.style.position="absolute";
				div.style.left=0;
				div.style.top=0;
				div.style.width=0;
				div.style.height=0;
				document.body.insertBefore(div,document.body.firstChild);
				igtbl_addEventListener(div,"mouseup",igtbl_resizeDivMouseUp,false);
				igtbl_addEventListener(div,"mousemove",igtbl_resizeDivMouseMove,false);
				igtbl_addEventListener(div,"selectstart",igtbl_resizeDivSelectStart,false);
				document.body.igtbl_resizeDiv=div;
				divr=document.createElement("DIV");
				div.appendChild(divr);
				divr.style.position="absolute";
				divr.style.borderWidth=1;
				divr.style.borderColor="black";
				divr.style.borderStyle="solid";
				divr.style.width=2;
			}
			else
			{
				div=document.body.igtbl_resizeDiv;
				divr=div.firstChild;
			}
			div.style.display="";
			div.style.cursor="w-resize";
			var divw=document.body.clientWidth,divh=document.body.clientHeight
			div.style.width=divw;
			div.style.height=divh;
			div.style.backgroundColor="transparent";
			divr.style.top=igtbl_getTopPos(te.parentNode,false);
			divr.style.left=evnt.clientX
				+igtbl_getBodyScrollLeft()
			;
			divr.style.height=te.parentNode.offsetHeight;
			div.column=colObj;
			div.srcElement=se;
			div.initX=evnt.clientX;
			return true;
		}
		se.setAttribute("justClicked",true);
		if(igtbl_getHeaderClickAction(gn,bandNo,colObj.Index)==1 && (gs.SelectedColumns[se.id]!=true || gs.ViewType!=2 || igtbl_getSelectTypeColumn(gn,bandNo)==3))
		{
			if(igtbl_getSelectTypeColumn(gn,bandNo)<2)
				return true;
			te.setAttribute("elementMode", "select");
			te.setAttribute("selectMethod", "column");
			if(!(igtbl_getSelectTypeColumn(gn,bandNo)==3 && evnt.ctrlKey))
				igtbl_clearSelectionAll(gn);
			if(te.getAttribute("shiftSelect") && evnt.shiftKey)
			{
				te.setAttribute("lastSelectedColumn","");
				igtbl_selectColumnRegion(gn,se);
				te.removeAttribute("shiftSelect");
			}
			else
			{
				te.setAttribute("startColumn", se.id);
				if(gs.SelectedColumns[se.id] && evnt.ctrlKey)
					igtbl_selectColumn(gn,se.id,false);
				else
					igtbl_selectColumn(gn,se.id);
				te.removeAttribute("shiftSelect");
				if(!evnt.ctrlKey)
					te.setAttribute("shiftSelect",true);
			}
		}
		return true;
	}
	else if(se.tagName=="DIV" && se.getAttribute("groupInfo"))
	{
		if(igtbl_button(gn,evnt)!=0)
			return;
		if(igtbl_fireEvent(gn,gs.Events.MouseDown,"(\""+gn+"\",\""+se.id+"\","+igtbl_button(gn,evnt)+")")==true)
			return;
		var groupInfo=se.getAttribute("groupInfo").split(":");
		if(groupInfo[0]!="band")
			igtbl_changeStyle(gn,se,igtbl_getSelHeadClass(gn,groupInfo[1],groupInfo[2]));
		se.setAttribute("justClicked",true);
		return true;
	}
}

function igtbl_resizeDivMouseUp(evnt)
{
	if(!evnt) evnt=event;
	if(!evnt) return;
	var se=document.body.igtbl_resizeDiv;
	
	if (!se) return;
	se.style.display="none";
	if(se.initX!=evnt.clientX)
	{
		var col=se.column;
		var oldWidth;
		if(col.Width.length && col.Width.charAt(col.Width.length-1)=="%")
			oldWidth=se.srcElement.offsetWidth;
		else
			oldWidth=parseInt(col.Width,10);
		var newWidth=oldWidth+evnt.clientX-se.initX;
		if(newWidth<=0)
			newWidth=1;
		if(oldWidth!=newWidth)
			col.setWidth(newWidth);
	}
}

function igtbl_resizeDivMouseMove(evnt)
{
	if(!evnt)
		evnt=event;
	if(!evnt)
		return;
	var se=document.body.igtbl_resizeDiv;
	if(!se)
		return;
	if(igtbl_button(null,evnt)!=0)
		return igtbl_resizeDivMouseUp(evnt);
	se.style.cursor="w-resize";
	if(!se.firstChild)
		se=se.parentNode;
	if(se.initX!=evnt.clientX)
	{
		var col=se.column;
		if(parseInt(col.Width,10)+evnt.clientX-se.initX>0)
			se.firstChild.style.left=evnt.clientX+igtbl_getBodyScrollLeft();
	}
}

function igtbl_resizeDivSelectStart(evnt)
{
	if(!evnt) evnt=event;
	if(!evnt) return;
	return igtbl_cancelEvent(evnt);
}

function igtbl_lineupHeaders(colId,band)
{
	var gs=band.Grid;
	var te=gs.Element;
	var cg=new Array();
	var stat=false;
	if(band.Index==0 && !band.IsGrouped && gs.StationaryMargins>0)
	{
		cg[0]=te.childNodes[0];
		if(gs.StatHeader)
			cg[1]=gs.StatHeader.Element.previousSibling;
		if(gs.StatFooter)
		{
			if(gs.Rows.AddNewRow && band.AddNewRowView==2)
				cg[cg.length]=gs.StatFooter.Element.previousSibling.previousSibling;
			else
				cg[cg.length]=gs.StatFooter.Element.previousSibling;
		}
		stat=true;
	}
	else
	{
		var e=igtbl_getDocumentElement(colId);
		if(e && e.length)
			for(var i=0;i<e.length;i++)
				cg[i]=e[i].parentNode.parentNode.previousSibling;
		else if(e)
			cg[0]=e.parentNode.parentNode.previousSibling;
	}
	if(cg.length>0)
	{
		for(var j=0;j<cg.length;j++)
		{
			var hasPercW=false;
			for(var i=0;i<cg[j].childNodes.length && !hasPercW;i++)
			{
				var w=cg[j].childNodes[i].width.toString();
				if(!w || w.substr(w.length-1)=="%")
					hasPercW=true;
			}
			if(hasPercW)
				for(var i=0;i<cg[j].childNodes.length;i++)
					cg[j].childNodes[i].oldWidth=cg[j].childNodes[i].offsetWidth;
			if(j>0 && stat || gs.TableLayout)
				cg[j].parentNode.style.width="";
			for(var i=0;i<cg[j].childNodes.length;i++)
			{
				if(cg[j].childNodes[i].oldWidth)
				{
					if(cg[j].nextSibling)
					{
						var co=igtbl_getElemVis(cg[j].nextSibling.firstChild.childNodes,i);
						var column=igtbl_getColumnById(co.id);
						if(column)
						{
							co.style.width="";
							co.width=cg[j].childNodes[i].oldWidth;
							column.Width=co.width;
							if(column.Node) column.Node.setAttribute("lit:width",co.width);
						}
					}
					cg[j].childNodes[i].style.width="";
					cg[j].childNodes[i].width=cg[j].childNodes[i].oldWidth;
					cg[j].childNodes[i].oldWidth=null;
				}
			}
		}
	}
	igtbl_dispose(cg);
	delete cg;
}

function igtbl_headerClickUp(evnt,gn) 
{
	if(!evnt && event)
		evnt=event;
	if(!gn && igtbl_lastActiveGrid)
		gn=igtbl_lastActiveGrid;
	if(!gn || !evnt)
		return false;
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	gs.event=evnt;
	if(igtbl_button(gn,evnt)==2)
		return;
	var te=gs.Element;
	
	if (te.getAttribute("mouseDown"))
		te.removeAttribute("mouseDown");
	else
		return;	
	var se=igtbl_srcElement(evnt);
	if(se && se.tagName=="IMG" && (se.getAttribute("imgType")=="group" || se.getAttribute("imgType")=="fixed"))
		return;
	while(se && (se.tagName!="TH" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn) && (se.tagName!="DIV" || !se.getAttribute("groupInfo")))
		se=se.parentNode;
	if(!se)
		return;
		
	var seTemp = se;
	while(seTemp!=null)
	{
		if (seTemp.tagName=="TFOOT")
		{	
			return;
		}		
		seTemp = seTemp.parentNode
	}
	seTemp = null;		
	if(se.tagName == "TH")
	{
		var column=igtbl_getColumnById(se.id);
		if(!column) return;
		var bandNo=column.Band.Index;
		var columnNo=column.Index;
		var mode=te.getAttribute("elementMode");
				
		var headerClickNeedPost = false;
		if(mode!="resize")
		{
			var oldNP = gs.NeedPostBack;
			igtbl_fireEvent(gn,gs.Events.ColumnHeaderClick,"(\""+gn+"\",\""+se.id+"\","+igtbl_button(gn,evnt)+")");
			if (gs.NeedPostBack && gs.NeedPostBack!= oldNP)
				headerClickNeedPost = true;
		}	
		if(igtbl_fireEvent(gn,gs.Events.MouseUp,"(\""+gn+"\",\""+se.id+"\","+igtbl_button(gn,evnt)+")")==true)
			return true;
		if(igtbl_getHeaderClickAction(gn,bandNo,columnNo)!=1)
			igtbl_changeStyle(gn,se,null);
		te.removeAttribute("elementMode");
		te.removeAttribute("resizeColumn");
		te.removeAttribute("selectMethod");
		if(!te.getAttribute("shiftSelect"))
			te.removeAttribute("startColumn");
		if(mode!="resize" && (igtbl_getHeaderClickAction(gn,bandNo,columnNo)==2 || igtbl_getHeaderClickAction(gn,bandNo,columnNo)==3) && column.SortIndicator!=3)
		{
			if(gs.Bands[bandNo].ClientSortEnabled)
			{
				gs.startHourGlass();
				gs.sortingColumn=se;
				gs.oldColCursor=se.style.cursor;
				se.style.cursor="wait";
				window.setTimeout("igtbl_gridSortColumn('"+gn+"','"+se.id+"',"+evnt.shiftKey+")",1);
			}
			else
				gs.sortColumn(se.id,evnt.shiftKey);
			if(gs.NeedPostBack && !headerClickNeedPost)
				igtbl_doPostBack(gn,evnt.shiftKey?"shiftKey:true":"");
		}
		else
		{
			if(mode=="resize")
				igtbl_resizeDivMouseUp(evnt);
			if((mode=="resize" || mode=="select") && gs.NeedPostBack)
				igtbl_doPostBack(gn);
			te.removeAttribute("elementMode");
		}
	}
	else if(se.tagName=="DIV" && se.getAttribute("groupInfo"))
	{
		igtbl_fireEvent(gn,gs.Events.ColumnHeaderClick,"(\""+gn+"\",\""+se.id+"\","+igtbl_button(gn,evnt)+")");
		if(igtbl_fireEvent(gn,gs.Events.MouseUp,"(\""+gn+"\",\""+se.id+"\","+igtbl_button(gn,evnt)+")")==true)
			return;
		var groupInfo=se.getAttribute("groupInfo").split(":");
		if(groupInfo[0]!="band")
		{
			igtbl_changeStyle(gn,se,null);
			var bandNo=igtbl_bandNoFromColId(se.id);
			var columnNo=igtbl_colNoFromColId(se.id);
			var column=gs.Bands[bandNo].Columns[columnNo];
			if((igtbl_getHeaderClickAction(gn,bandNo,columnNo)==2 || igtbl_getHeaderClickAction(gn,bandNo,columnNo)==3) && column.SortIndicator!=3)
			{
				if(gs.Bands[bandNo].ClientSortEnabled)
				{
					gs.startHourGlass();
					gs.sortingColumn=se;
					gs.oldColCursor=se.style.cursor;
					se.style.cursor="wait";
					window.setTimeout("igtbl_gridSortColumn('"+gn+"','"+se.id+"',true)",1);
				}
				else
					gs.sortColumn(se.id,evnt.shiftKey);
				if(gs.NeedPostBack)
					igtbl_doPostBack(gn,evnt.shiftKey?"shiftKey:true":"");
			}
		}
	}
	if(gs.NeedPostBack)
		igtbl_doPostBack(gn,'HeaderClick:'+se.id);
	return true;
}

function igtbl_headerContextMenu(evnt,gn) 
{
	if(!evnt && event)
		evnt=event;
	if(!gn && igtbl_lastActiveGrid)
		gn=igtbl_lastActiveGrid;
	if(!gn || !evnt)
		return false;
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	gs.event=evnt;
	if(igtbl_button(gn,evnt)==2)
		return;
	var te=gs.Element;
	te.removeAttribute("mouseDown");
	var se=igtbl_srcElement(evnt);
	while(se && (se.tagName!="TH" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn) && (se.tagName!="DIV" || !se.getAttribute("groupInfo")))
		se=se.parentNode;
	if(!se)
		return;
	if(se.tagName == "TH" || se.tagName == "DIV")
	{
		var column=igtbl_getColumnById(se.id);
		if(se.tagName=="TH" && !column) return;
		igtbl_fireEvent(gn,gs.Events.ColumnHeaderClick,"(\""+gn+"\",\""+se.id+"\",2)");
		if(igtbl_fireEvent(gn,gs.Events.MouseUp,"(\""+gn+"\",\""+se.id+"\",2)")==true)
			return igtbl_cancelEvent(evnt);
	}
}

function igtbl_gridSortColumn(gn,colId,shiftKey)
{
	var gs=igtbl_getGridById(gn);
	gs._isSorting = true;
	gs.sortColumn(colId,shiftKey);
	if(gs.sortingColumn && gs.oldColCursor);
		gs.sortingColumn.style.cursor=gs.oldColCursor;
	gs.stopHourGlass();
	delete gs._isSorting;
	if(gs.NeedPostBack)
		igtbl_doPostBack(gn,"shiftKey:"+shiftKey.toString());
}

function igtbl_headerMouseOut(evnt,gn) 
{
	if(!evnt && event)
		evnt=event;
	if(!gn && igtbl_lastActiveGrid)
		gn=igtbl_lastActiveGrid;
	if(!gn || !evnt)
		return false;
	var gs=igtbl_getGridById(gn);
	var se=igtbl_srcElement(evnt);
	if(!gs || !se)
		return;
	gs.event=evnt;
	if(se.tagName=="NOBR" && se.title)
		se.title="";
	while(se && (se.tagName!="TH" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn) && (se.tagName!="DIV" || !se.getAttribute("groupInfo")))
		se=se.parentNode;
	if(!se)
		return;
	if(se.tagName == "TH")
	{
		var column=igtbl_getColumnById(se.id);
		if(!column) return;
		var sep=se.parentNode;
		if(gs.Element.getAttribute("elementMode")=="select")
			return true;
		if(!igtbl_isMouseOut(se,evnt))return true;
		if(igtbl_fireEvent(gn,gs.Events.MouseOut,"(\""+gn+"\",\""+se.id+"\",1)")==true)
			return true;
		if(igtbl_getHeaderClickAction(gn,column.Band.Index,column.Index)!=1)
			igtbl_changeStyle(gn,se,null);
		return true;
	}
	else if(se.tagName == "DIV" && se.getAttribute("groupInfo"))
	{
		if(!igtbl_isMouseOut(se,evnt))return true;
		if(igtbl_fireEvent(gn,gs.Events.MouseOut,"(\""+gn+"\",\""+se.id+"\",1)")==true)
			return true;
		var groupInfo=se.getAttribute("groupInfo").split(":");
		if(groupInfo[0]!="band")
			igtbl_changeStyle(gn,se,null);
		return true;
	}
}

function igtbl_isMouseOut(se,evnt)
{
	var te=evnt.toElement;
	if(te==null)te=evnt.relatedTarget;
	while(te!=null){if(te==se)return false;te=te.parentNode;}
	se._hasMouse=false;
	return true;
}

function igtbl_headerMouseOver(evnt,gn)
{
	if(!evnt && event)
		evnt=event;
	if(!evnt)
		return false;
	var se=igtbl_srcElement(evnt);
	if(!se)
		return;
	var column;
	if(se.tagName=="NOBR")
	{
		column=igtbl_getColumnById(se.parentNode.id);
		if(column)
		{
			var nobr=se;
			if(nobr.offsetWidth>se.parentNode.offsetWidth || nobr.offsetHeight>se.parentNode.offsetHeight)
				nobr.title=column.HeaderText;
		}
	}
	else
		column=igtbl_getColumnById(se.id);
	if(!column) return;
	var gs=column.Band.Grid;
	if(!gn)
		gn=gs.Id;
	gs.event=evnt;
	igtbl_lastActiveGrid=gn;
	while(se && (se.tagName!="TH" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn) && (se.tagName!="DIV" || !se.getAttribute("groupInfo")))
		se=se.parentNode;
	if(!se)
		return;
	if(se.tagName!="DIV")
	{
		while(se && (se.tagName!="TH" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn))
			se=se.parentNode;
		if(!se)
			return;
	}
	if(se._hasMouse)return;
	if(se.tagName == "TH")
	{
		var column=igtbl_getColumnById(se.id);
		if(!column) return;
		se._hasMouse=true;
		igtbl_fireEvent(gn,gs.Events.MouseOver,"(\""+gn+"\",\""+se.id+"\",1)");
	}
	else if(se.tagName == "DIV" && se.getAttribute("groupInfo"))
	{
		se._hasMouse=true;
		igtbl_fireEvent(gn,gs.Events.MouseOver,"(\""+gn+"\",\""+se.id+"\",1)");
	}
}

function igtbl_headerMouseMove(evnt,gn)
{
	if(!evnt && event)
		evnt=event;
	if(!gn && igtbl_lastActiveGrid)
		gn=igtbl_lastActiveGrid;
	if(!gn || !evnt)
		return false;
	var gs=igtbl_getGridById(gn);
	var se=igtbl_srcElement(evnt);
	if(!gs || !se)
		return false;
	gs.event=evnt;
	while(se && (se.tagName!="TH" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn) && (se.tagName!="DIV" || !se.getAttribute("groupInfo")))
		se=se.parentNode;
	if(!se)
		return;
	if(se.tagName == "TH")
	{
		var column=igtbl_getColumnById(se.id);
		if(!column) return;
		var bandNo=column.Band.Index;
		var columnNo=column.Index;
		if(igtbl_button(gn,evnt)==0)
		{
			var mode = gs.Element.getAttribute("elementMode");
			if(mode!=null && mode=="resize") 
				igtbl_resizeDivMouseMove(evnt);
			else if(mode=="select" && igtbl_getHeaderClickAction(gn,bandNo,columnNo)==1 && !evnt.ctrlKey) 
				igtbl_selectColumnRegion(gn,se);
			else
			{
				var cursorName = se.getAttribute("oldCursor");
				if(cursorName != null)
				{
					se.style.cursor=cursorName;
					se.removeAttribute("oldCursor");
				}
				if(igtbl_getHeaderClickAction(gn,bandNo,columnNo)!=1 || gs.SelectedColumns[se.id] || igtbl_getSelectTypeColumn(gn,bandNo)<2)
					if(column.AllowGroupBy==1 && gs.ViewType==2 && gs.GroupByBox.Element || column.Band.AllowColumnMoving>1)
					{
						if(se.getAttribute("justClicked"))
						{
							if(typeof(igtbl_headerDragStart)!="undefined")
								igtbl_headerDragStart(gn,se,evnt);
						}
						else
							igtbl_changeStyle(gn,se,null);
					}
			}
			if(se.getAttribute("justClicked"))
				se.removeAttribute("justClicked");
			if(column.TemplatedColumn&1 && se!=igtbl_srcElement(evnt))
				return;
			igtbl_cancelEvent(evnt);
			return true;
		}
		else 
		{
			var c,te=gs.Element;
			te.removeAttribute("elementMode");
			te.removeAttribute("resizeColumn");
			te.removeAttribute("selectMethod");
			if(!te.getAttribute("shiftSelect"))
				te.removeAttribute("startColumn");
			if(igtbl_getOffsetX(evnt,se)>igtbl_clientWidth(se)-4 && igtbl_getAllowColSizing(gn,bandNo,columnNo)==2)
			{
				if(se.getAttribute("oldCursor")==null)
					se.setAttribute("oldCursor", se.style.cursor);
				se.style.cursor="w-resize";
				if((c=se.firstChild)!=null)if((c=c.firstChild)!=null)if((c=c.style)!=null)c.cursor="w-resize";
			}
			else
			{
				var cursorName = se.getAttribute("oldCursor");
				if(cursorName != null)
				{
					se.style.cursor=cursorName;
					se.removeAttribute("oldCursor");
					if((c=se.firstChild)!=null)if((c=c.firstChild)!=null)if((c=c.style)!=null)c.cursor=cursorName;
				}
			}
		}
		if(se.getAttribute("justClicked"))
			se.removeAttribute("justClicked");
		if(column.TemplatedColumn&1 && se!=igtbl_srcElement(evnt))
			return;
	}
	else if(se.tagName == "DIV" && se.getAttribute("groupInfo"))
	{
		var groupInfo=se.getAttribute("groupInfo").split(":");
		if(groupInfo[0]!="band")
		{
			if(igtbl_button(gn,evnt)==0)
			{
				var cursorName = se.getAttribute("oldCursor");
				if(cursorName != null)
				{
					se.style.cursor=cursorName;
					se.removeAttribute("oldCursor");
				}
				igtbl_changeStyle(gn,se,null);
				if(gs.ViewType==2 && se.getAttribute("justClicked") && typeof(igtbl_headerDragStart)!="undefined")
					igtbl_headerDragStart(gn,se,evnt);
			}
		}
		if(se.getAttribute("justClicked"))
			se.removeAttribute("justClicked");
		return true;
	}
	return false;
}

function igtbl_tableMouseMove(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	var se=igtbl_srcElement(evnt);
	if(!gs || !se)
		return false;
	gs.event=evnt;
	var te=gs.Element;
	if(igtbl_button(gn,evnt)==0 && te.getAttribute("elementMode")=="resize")
	{
		if((se.id==gn+"_div" || se.id==gn+"_hdiv" || se.tagName=="TABLE" && se.parentNode.parentNode.getAttribute("hiddenRow") || se.tagName=="TD" && se.parentNode.getAttribute("hiddenRow")) && te.getAttribute("resizeColumn"))
		{
			if(typeof(te.parentNode.oldCursor)!="string")
			{
				te.parentNode.oldCursor=te.parentNode.style.cursor;
				te.parentNode.style.cursor="w-resize";
				if(gs.StatHeader)
					gs.StatHeader.Element.parentNode.parentNode.style.cursor="w-resize";
			}
			var column=te.getAttribute("resizeColumn");
			var resCol=igtbl_getElementById(column);
			var cg=se.childNodes[0];
			if(se.id==gn+"_div" || se.tagName=="TD")
				cg=cg.childNodes[0];
			else if(se.id==gn+"_hdiv")
				cg=cg.childNodes[0].childNodes[0];
			if(!cg)
				return false;
			var co=cg.childNodes[resCol.cellIndex];
			var c1w=evnt.clientX-igtbl_getLeftPos(resCol);
			igtbl_resizeColumn(gn,resCol.id,c1w);
			return igtbl_cancelEvent(evnt);
		}
		else if(te.getAttribute("resizeRow") && (se.id==gn+"_div" || se.tagName=="TH" && se.parentNode.parentNode.tagName=="TFOOT" || se.tagName=="TD" && se.parentNode.getAttribute("hiddenRow")))
		{
			if(typeof(te.parentNode.oldCursor)!="string")
			{
				te.parentNode.oldCursor=te.parentNode.style.cursor;
				te.parentNode.style.cursor="n-resize";
			}
			var rowId=te.getAttribute("resizeRow");
			var row=igtbl_getElementById(rowId);
			if(!row || row.getAttribute("hiddenRow"))
				return;
			var r1h=row.offsetHeight+(evnt.clientY-(igtbl_getTopPos(row)+row.offsetHeight));
			igtbl_resizeRow(gn,rowId,r1h);
			return igtbl_cancelEvent(evnt);
		}
	}
	else if(typeof(te.parentNode.oldCursor)=="string")
	{
		te.parentNode.style.cursor=te.parentNode.oldCursor;
		if(gs.StatHeader)
			gs.StatHeader.Element.parentNode.parentNode.style.cursor=te.parentNode.oldCursor;
		te.parentNode.oldCursor=null;
	}
	if(se==te || se==gs.DivElement || se.tagName=="TH")
		igtbl_colButtonMouseOut(evnt,gn);
}

function igtbl_tableMouseUp(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return false;
	gs.event=evnt;
	var se=igtbl_srcElement(evnt);
	if(!se) return;
	if(se==gs._editorCurrent)return;
	
	if(se.id==gn+"_div" && gs.Element.getAttribute("elementMode")=="resize")
	{
		gs.Element.removeAttribute("elementMode");
		gs.Element.removeAttribute("resizeColumn");
	}
	var ar=gs.getActiveRow();
	if(ar && !igtbl_isAChildOfB(se,ar.Element))
	{
		gs.endEdit();
		if(ar.IsAddNewRow)
			ar.commit();
		else
		if(ar._dataChanged && ar._dataChanged>1)
			ar.processUpdateRow();
	}
}

function igtbl_resizeColumn(gn,colId,width)
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return false;
	var col=igtbl_getColumnById(colId);
	if(!col)
		return false;
	return col.setWidth(width);
}

function igtbl_selectColumnRegion(gn,se)
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	var te=gs.Element;
	var lastSelectedColumn=te.getAttribute("lastSelectedColumn");
	var selMethod=te.getAttribute("selectMethod");
	if(selMethod=="column" && se.id!=lastSelectedColumn)
	{
		var startColumn=igtbl_getColumnById(te.getAttribute("startColumn"));
		if(startColumn==null)
			startColumn=igtbl_getColumnById(se.id);
		var endColumn=igtbl_getColumnById(se.id);
		if(igtbl_getSelectTypeColumn(gn,se.parentNode.parentNode.parentNode.getAttribute("bandNo"))==3)
			gs.selectColRegion(startColumn,endColumn);
		else
		{
			igtbl_clearSelectionAll(gn);
			igtbl_selectColumn(gn,se.id);
		}
		gs.Element.setAttribute("lastSelectedColumn",se.id);
	}
}

function igtbl_resizeRow(gn,rowId,height)
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	var row=igtbl_getRowById(rowId);
	if(!row)
		return;
	if(height>0)
	{
		var cancel=false;
		if(igtbl_fireEvent(gn,gs.Events.BeforeRowSizeChange,"(\""+gn+"\",\""+row.Element.id+"\","+height+")")==true)
			cancel=true;
		if(!cancel)
		{
			var rowLabel=null;
			if(!row.GroupByRow && igtbl_getRowSelectors(gn,row.Band.Index)!=2)
				rowLabel=row.Element.cells[row.Band.firstActiveCell-1];
			if(!row._origHeight)
				row._origHeight=row.Element.offsetHeight;
			row.Element.style.height=height;
			gs._removeChange("ResizedRows",row);
			gs._recordChange("ResizedRows",row,height);
			if(rowLabel)
				rowLabel.style.height=height;
			if(gs.UseFixedHeaders)
			{
				var i=0;
				while(i<row.Element.cells.length && (!row.Element.cells[i].firstChild || row.Element.cells[i].firstChild.id!=gn+"_drs")) i++;
				if(i<row.Element.cells.length)
				{
					var td=row.Element.cells[i];
					td.firstChild.firstChild.rows[0].style.height=height;
					if(gs.IsXHTML && height>row._origHeight)
					{
						if(rowLabel)
							td.style.height=height+rowLabel.offsetHeight-rowLabel.clientHeight;
						else
							td.style.height=height;
					}
				}
			}
			gs.alignGrid();
			igtbl_fireEvent(gn,gs.Events.AfterRowSizeChange,"(\""+gn+"\",\""+row.Element.id+"\","+height+")");
		}
	}
}

function igtbl_cellClickDown(evnt,gn) 
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	gs.event=evnt;
	igtbl_lastActiveGrid=gn;
	gs._mouseDown=1;
	gs.Element.setAttribute("mouseDown","1");
	var se=igtbl_srcElement(evnt);
	if(!se||se==gs._editorCurrent)return;
	if(se.id==gn+"_vl"){if(gs._focusElem)ig_cancelEvent(evnt);return;}
	if(se.id==gn+"_tb" || se.id==gn+"_ta")
		return;
	var sel=igtbl_getElementById(gn+"_vl");
	if(sel && sel.style.display=="" && sel.getAttribute("noOnBlur"))
		return igtbl_cancelEvent(evnt);
	ig_cancelEvent(evnt);
	while(se && se.tagName!="TD")
		se=se.parentNode;
	if(!se)
		return;
	if(se.tagName == "TD") 
	{
		var row;
		var cell=igtbl_getCellByElement(se);
		var id=gs._mouseID=se.id;
		if(cell)
		{
			row=cell.Row;
			id=cell.Element.id;
		}
		else row=igtbl_getRowById(id);
		if(!row && !cell) return;
		var fac=row.Band.firstActiveCell;
		if(igtbl_fireEvent(gn,gs.Events.MouseDown,"(\""+gn+"\",\""+id+"\","+igtbl_button(gn,evnt)+")")==true)
		{
			igtbl_cancelEvent(evnt);
			return true;
		}
		var band=row.Band;
		var bandNo=band.Index;
		if (igtbl_hideEdit(gn)) return;
		if(igtbl_button(gn,evnt)==0 && !cell && igtbl_getOffsetY(evnt,se)>igtbl_clientHeight(se)-4 && igtbl_getRowSizing(gn,bandNo,row.Element)==2 && !se.getAttribute("groupRow"))
		{
			gs.Element.setAttribute("elementMode", "resize");
			gs.Element.setAttribute("resizeRow", row.Element.id);
			row.Element.style.height=row.Element.offsetHeight;
		}
		else
		{
			var te=gs.Element;
			var workTableId;
			if(row.IsAddNewRow && row.Band.Index==0)
				workTableId=gs.Element.id;
			else
			if(se.getAttribute("groupRow"))
				workTableId=se.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.id;
			else
				workTableId=row.Element.parentNode.parentNode.id;
			if(igtbl_button(gn,evnt)!=0)
				return;
			if(workTableId=="")
				return;
			
			te.removeAttribute("lastSelectedCell");
			var prevSelRow=gs.SelectedRows[igtbl_getWorkRow(row.Element,gn).id];
			if(prevSelRow && igtbl_getLength(gs.SelectedRows)>1)
				prevSelRow=false;
			var selPresent=(igtbl_getLength(gs.SelectedCells)>0?1:0) | (igtbl_getLength(gs.SelectedRows)>0?2:0) | (igtbl_getLength(gs.SelectedCols)>0?4:0);
			if(se.getAttribute("groupRow") || !cell || igtbl_getCellClickAction(gn,bandNo)==2)
			{
				if(!(igtbl_getSelectTypeRow(gn,bandNo)==3 && evnt.ctrlKey) && !(row.getSelected() && igtbl_getLength(gs.SelectedRows)==1))
					igtbl_clearSelectionAll(gn);
			}
			else
			{
				if(!(igtbl_getSelectTypeCell(gn,bandNo)==3 && evnt.ctrlKey) && !(cell.getSelected() && igtbl_getLength(gs.SelectedCells)==1))
					igtbl_clearSelectionAll(gn);
			}
			gs.Element.setAttribute("elementMode", "select");
			if(se.getAttribute("groupRow"))
			{
				te.setAttribute("selectTable", se.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.id);
				te.setAttribute("selectMethod", "row");
			}
			else
			{
				te.setAttribute("selectTable", workTableId);
				if(!cell || igtbl_getCellClickAction(gn,bandNo)==2)
					te.setAttribute("selectMethod", "row");
				else
					te.setAttribute("selectMethod", "cell");
			}
			if(te.getAttribute("shiftSelect") && evnt.shiftKey)
				igtbl_selectRegion(gn,se);
			else
			{
				if(!cell || igtbl_getCellClickAction(gn,bandNo)==2 || se.getAttribute("groupRow"))
				{
					var seRow=igtbl_getRowById(row.Element.id);
					if(gs.SelectedRows[row.Element.id] && evnt.ctrlKey)
					{
						igtbl_selectRow(gn,seRow,false);
						gs.setActiveRow(seRow);
					}
					else
					{
						var showEdit=true;
						if(!gs._exitEditCancel)
						{
							if(gs.Activation.AllowActivation)
							{
								var ar=gs.oActiveRow;
								if(ar!=seRow)
								{
									gs.setActiveRow(seRow);
									showEdit=false;
								}
								else
									showEdit=true;
							}
							if(igtbl_getSelectTypeRow(gn,bandNo)>1)
								igtbl_selectRow(gn,seRow,true,!prevSelRow);
							if(showEdit && !se.getAttribute("groupRow") && row)
								row.editRow();
						}
					}
				}
				else
				{
					if(cell.getSelected() && evnt.ctrlKey)
					{
						cell.select(false);
						cell.activate();
					}
					else
					{
						if(band.getSelectTypeCell()>1 && band.getCellClickAction()>=1 && !gs._exitEditCancel)
							cell.select();
						else if(selPresent)
						{
							var gsNPB = gs.NeedPostBack;
							igtbl_fireEvent(gn,gs.Events.AfterSelectChange,"(\""+gn+"\",\""+id+"\");");
							if(!gsNPB && !(gs.Events.AfterSelectChange[1]&selPresent))
								gs.NeedPostBack=false;
						}
						cell.activate();
					}
				}
				if(se.getAttribute("groupRow"))
					te.setAttribute("startPointRow", se.parentNode.parentNode.parentNode.parentNode.parentNode.id);
				else
					te.setAttribute("startPointRow", row.Element.id);
				te.setAttribute("startPointCell", id);
				te.removeAttribute("shiftSelect");
				if(!evnt.ctrlKey)
					te.setAttribute("shiftSelect", true);
			}
		}
	}
	if(typeof(igtbl_currentEditTempl)!="undefined" && igtbl_currentEditTempl!=null)
		igtbl_gRowEditMouseDown(evnt);
	if(typeof(igcmbo_currentDropped)!="undefined" && igcmbo_currentDropped!=null)
		igcmbo_mouseDown(evnt);
}

function igtbl_cellClickUp(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	gs.event=evnt;
	gs._mouseDown=0;
	if(igtbl_button(gn,evnt)==2)
		return;
	gs.Element.removeAttribute("mouseDown");
	var se=igtbl_srcElement(evnt);
	if(!se || se==gs._editorCurrent || (se.tagName && se.tagName.length>4))
		return;
	if(!gs._editorCurrent && gs._focusElem && !gs._focus0)
		igtbl_activate(gn);
	if(se.id==gn+"_vl" || se.id==gn+"_tb" || se.id==gn+"_ta")
		return;
	var sel=igtbl_getElementById(gn+"_vl");
	if(sel && sel.style.display=="" && sel.getAttribute("noOnBlur"))
		return igtbl_cancelEvent(evnt);
	while(se && (se.tagName!="TD" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn))
		se=se.parentNode;
	if(!se)
		return;
	if(se.tagName != "TD")
		return;
	if(se.id == "")
		return;
	var row;
	var id=se.id;
	var cell=igtbl_getCellById(id);
	if(cell)
	{
		row=cell.Row;
		id=cell.Element.id;
	}
	else row=igtbl_getRowById(id);
	if(!row && !cell) return;
	var te=gs.Element;
	var mode=gs.Element.getAttribute("elementMode");
	gs.Element.removeAttribute("elementMode");
	te.removeAttribute("selectTable");
	te.removeAttribute("selectMethod");
	te.removeAttribute("resizeRow");
	if(!te.getAttribute("shiftSelect"))
	{
		te.removeAttribute("startPointRow");
		te.removeAttribute("startPointCell");
	}
	var bandNo=row.Band.Index;
	var fac=row.Band.firstActiveCell;
	if(cell && igtbl_getCellClickAction(gn,bandNo)==1 && gs._mouseID==id)
	{
		if(igtbl_getAllowUpdate(gn,bandNo,cell.Column.Index)==3)
			row.editRow(true);
		else
			cell.beginEdit();
	}
	if((mode=="resize" || mode=="select") && gs.NeedPostBack)
	{
		se=igtbl_srcElement(evnt);
		if(!(se&&se.tagName=="INPUT"&&se.type=="checkbox"))
			igtbl_doPostBack(gn);
		return;
	}
	if(!se.getAttribute("groupRow") && mode!="resize")
	{
		if(!cell)
			igtbl_fireEvent(gn,gs.Events.RowSelectorClick,"(\""+gn+"\",\""+row.Element.id+"\","+igtbl_button(gn,evnt)+")");
		else
			igtbl_fireEvent(gn,gs.Events.CellClick,"(\""+gn+"\",\""+id+"\","+igtbl_button(gn,evnt)+")");
	}
	gs._noCellChange=false;
	if(igtbl_fireEvent(gn,gs.Events.MouseUp,"(\""+gn+"\",\""+id+"\","+igtbl_button(gn,evnt)+")")==true)
	{
		igtbl_cancelEvent(evnt);
		return true;
	}
	if(gs.NeedPostBack && !cell)
		igtbl_doPostBack(gn,'RowClick:'+row.Element.id+(row.Element.getAttribute("level")?"\x05"+row.Element.getAttribute("level"):""));
	else if(gs.NeedPostBack && igtbl_getCellClickAction(gn,bandNo)==2)
		igtbl_doPostBack(gn,'RowClick:'+row.Element.id+(row.Element.getAttribute("level")?"\x05"+row.Element.getAttribute("level"):""));
	else if(gs.NeedPostBack)
		igtbl_doPostBack(gn,'CellClick:'+id+(cell.Element.getAttribute("level")?"\x05"+cell.Element.getAttribute("level"):""));
	return igtbl_cancelEvent(evnt);
}

function igtbl_cellContextMenu(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	gs.event=evnt;
	var te=gs.Element;
	te.removeAttribute("mouseDown");
	te.removeAttribute("elementMode");
	te.removeAttribute("resizeColumn");
	te.removeAttribute("selectMethod");
	if(!te.getAttribute("shiftSelect"))
		te.removeAttribute("startColumn");
	var se=igtbl_srcElement(evnt);
	if(!se||se.id==gn+"_vl"||se.id==gn+"_tb"||se.id==gn+"_ta")
		return;
	while(se && se.tagName!="TD")
		se=se.parentNode;
	if(!se || se.tagName != "TD")
		return;
	var row;
		var cell=igtbl_getCellByElement(se);
		var id=se.id;
	if(cell)
	{
		row=cell.Row;
		id=cell.Element.id;
	}
	else row=igtbl_getRowById(id);
	if(!row && !cell) return;
	if(!se.getAttribute("groupRow"))
	{
		if(!cell)
			igtbl_fireEvent(gn,gs.Events.RowSelectorClick,"(\""+gn+"\",\""+row.Element.id+"\",2)");
		else
			igtbl_fireEvent(gn,gs.Events.CellClick,"(\""+gn+"\",\""+id+"\",2)");
	}
	if(igtbl_fireEvent(gn,gs.Events.MouseUp,"(\""+gn+"\",\""+id+"\",2)")==true)
		return igtbl_cancelEvent(evnt);
}

function igtbl_cellMouseOver(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	var se=igtbl_srcElement(evnt);
	if(!gs || !se)
		return;
	gs.event=evnt;
	if(gs._cb&&!gs._unsel0){gs._unsel0=true;gs._unsel(igtbl_getElementById(gn+"_main"),gs);}
	if(se.tagName=="NOBR")
	{
		var cell=igtbl_getCellByElement(se.parentNode);
		if(cell)
		{
			var nobr=cell.Element.childNodes[0];
			if(cell.Element.title)
				nobr.title=cell.Element.title;
			else if(nobr.offsetWidth>cell.Element.offsetWidth 
					|| nobr.offsetHeight>cell.Element.offsetHeight
					|| (cell.Element.style.textOverflow=="ellipsis" && nobr.offsetWidth+6>cell.Element.offsetWidth)
					
					|| (cell.Element.currentStyle && cell.Element.currentStyle.textOverflow=="ellipsis" && nobr.offsetWidth+6>cell.Element.offsetWidth)					
					)
			{
				if(igtbl_trim(cell.MaskedValue))
					nobr.title=cell.MaskedValue;
				else
					nobr.title=cell.getValue(true);
			}
		}
		se=se.parentNode;
	}
	while(se && se.tagName!="TD")
		se=se.parentNode;
	if(!se || se.tagName!="TD")
		return;
	var row;
		var cell=igtbl_getCellByElement(se);
		var id=se.id;
	if(cell)
	{
		row=cell.Row;
		id=cell.Element.id;
	}
	else row=igtbl_getRowById(se.id);
	if(!row && !cell) return;
	if(se._hasMouse)return;
	se._hasMouse=true;
	var te=gs.Element;
	if(evnt.shiftKey && row.Band.getSelectTypeRow()==3 && !te.getAttribute("shiftSelect"))
		te.setAttribute("shiftSelect",true);
	if(igtbl_fireEvent(gn,gs.Events.MouseOver,"(\""+gn+"\",\""+id+"\",0)")==true)
		return;
}

function igtbl_cellMouseMove(evnt,gn)
{
	var se=igtbl_srcElement(evnt);
	var gs=igtbl_getGridById(gn);
	if(!gs || !se)
		return;
	gs.event=evnt;
	var te=gs.Element;
	if(se.id==gn+"_vl" || se.id==gn+"_tb" || se.id==gn+"_ta")
		return;
	if(te.getAttribute("resizeRow") && (se.tagName=="TH" && se.parentNode.parentNode.tagName=="TFOOT" || se.tagName=="TD" && se.parentNode.getAttribute("hiddenRow")))
		return igtbl_tableMouseMove(evnt,gn);
	while(se && se.tagName!="TD")
		se=se.parentNode;
	if(!se || se.tagName != "TD")
		return;
	var row;
		var cell=igtbl_getCellByElement(se);
		var id=se.id;
	if(cell)
	{
		row=cell.Row;
		if(!cell) return;
		id=cell.Element.id;
	}
	else row=igtbl_getRowById(se.id);
	if(!row && !cell) return;
	var bandNo=row.Band.Index;
	var fac=row.Band.firstActiveCell;
	if(igtbl_button(gn,evnt)==0)
	{
		var mode = te.getAttribute("elementMode");
		if(mode && mode=="resize") 
		{
			var rowID = te.getAttribute("resizeRow");
			var rowEl=igtbl_getElementById(rowID);
			if(!rowEl || rowEl.getAttribute("hiddenRow"))
				return;
			var r1h=rowEl.offsetHeight+(evnt.clientY-(igtbl_getTopPos(rowEl)-igtbl_getBodyScrollTop()+rowEl.offsetHeight-(rowEl.clientTop?rowEl.clientTop:0)));
			igtbl_resizeRow(gn,rowID,r1h);
			var cursorName = se.getAttribute("oldCursor");
			if(cursorName==null)
				se.setAttribute("oldCursor", se.style.cursor);
			se.style.cursor="n-resize";
		}
		else
		{
			if(!cell)
			{
				var cursorName = se.getAttribute("oldCursor");
				if(cursorName!=null)
				{
					se.style.cursor=cursorName;
					se.removeAttribute("oldCursor");
				}
			}
			if(mode && mode=="select" && !evnt.ctrlKey) 
			{
				var lsc=te.getAttribute("lastSelectedCell");
				if(!lsc || lsc!=se.id)
					igtbl_selectRegion(gn,se);
				te.setAttribute("lastSelectedCell",id);
			}
		}
	}
	else if(igtbl_getOffsetY(evnt,se)>igtbl_clientHeight(se)-4 && !cell && igtbl_getRowSizing(gn,bandNo,row.Element)==2)
	{
		var cursorName = se.getAttribute("oldCursor");
		if(cursorName==null)
			se.setAttribute("oldCursor", se.style.cursor);
		se.style.cursor="n-resize";
		igtbl_colButtonMouseOut(null,gn);
	}
	else
	{
		te.removeAttribute("elementMode");
		te.removeAttribute("resizeRow");
		var cursorName = se.getAttribute("oldCursor");
		if(cursorName!=null)
		{
			se.style.cursor=cursorName;
			se.removeAttribute("oldCursor");
		}
		if(!cell)
			igtbl_colButtonMouseOut(null,gn);
		else 
		{
			var column=(cell?cell.Column:null);
			if(column && !row.Element.getAttribute("groupRow") && column.ColumnType==7 && column.CellButtonDisplay==0)
			{
				if(gs._editorButton&&gs._editorButton.style.display!="")
					if(gs._mouseWait++>5)
						gs._mouseWait=0;
				if(gs._mouseIn!=id)
					igtbl_showColButton(gn,cell.Element);
			}
			else
				igtbl_colButtonMouseOut(null,gn);
		}
	}
	gs._mouseIn=id;
	return false;
}

// Event handler for mouse out from cell
function igtbl_cellMouseOut(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	var se=igtbl_srcElement(evnt);
	if(!gs || !se)
		return;
	gs.event=evnt;
	if(se.tagName=="NOBR")
	{
		var cell=igtbl_getCellByElement(se.parentNode);
		if(cell)
			cell.Element.childNodes[0].title="";
		se=se.parentNode;
	}
	while(se && se.tagName!="TD")
		se=se.parentNode;
	if(!se || se.tagName!="TD")
		return;
	var row;
		var cell=igtbl_getCellByElement(se);
		var id=se.id;
	if(cell)
	{
		row=cell.Row;
		id=cell.Element.id;
		var btn=igtbl_getElementById(gn+"_bt")
		if(btn && btn.style.display=="" && btn.getAttribute("srcElement")==id && evnt.toElement && evnt.toElement.id!=id && evnt.toElement.id!=gn+"_bt")
			igtbl_colButtonMouseOut(null,gn);
	}
	else row=igtbl_getRowById(id);
	if(!row && !cell) return;
	if(igtbl_isMouseOut(se,evnt))
		igtbl_fireEvent(gn,gs.Events.MouseOut,"(\""+gn+"\",\""+id+"\",0)");
}

function igtbl_cellDblClick(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	gs.event=evnt;
	var se=igtbl_srcElement(evnt);
	if(!se||se.id==gn+"_vl"||se.id==gn+"_tb"||se.id==gn+"_ta")
		return;
	while(se && (se.tagName!="TD" && se.tagName!="TH" || se.id.length<gn.length || se.id.substr(0,gn.length)!=gn))
		se=se.parentNode;
	if(!se)
		return;
	if(se.tagName!="TD" && se.tagName!="TH")
		return;
	var row;
	var id=se.id;
	var cell=igtbl_getCellById(id);
	if(cell)
	{
		row=cell.Row;
		id=cell.Element.id;
	}
	else row=igtbl_getRowById(se.id);
	var column=igtbl_getColumnById(se.id);
	if(!row && !cell && !column) return;
	if(se.tagName=="TD")
	{
		if(se.getAttribute("groupRow"))
		{
			igtbl_toggleRow(gn,row.Element.id);
			return;
		}
		
		if(igtbl_fireEvent(gn,gs.Events.DblClick,"(\""+gn+"\",\""+id+"\")")==true)
			return;
		if(row && !cell)
		{
			if(gs.NeedPostBack)
				igtbl_doPostBack(gn,'RowDblClick:'+row.Element.id+(row.Element.getAttribute("level")?"\x05"+row.Element.getAttribute("level"):""));
			return;
		}
		var bandNo=row.Band.Index;
		if(gs.NeedPostBack)
		{
			if(igtbl_getCellClickAction(gn,bandNo)==2)
				igtbl_doPostBack(gn,'RowDblClick:'+row.Element.id+(row.Element.getAttribute("level")?"\x05"+row.Element.getAttribute("level"):""));
			else
				igtbl_doPostBack(gn,'CellDblClick:'+id+(cell.getLevel(true)?"\x05"+cell.getLevel(true):""));
			return;
		}
		if(igtbl_getCellClickAction(gn,bandNo)==0)
			return;
		if(!gs._exitEditCancel)
		{
			if(cell.Column.getAllowUpdate()==3)
				row.editRow(true);
			else
				cell.beginEdit();
		}
	}
	else
	{
		
		if(igtbl_fireEvent(gn,gs.Events.DblClick,"(\""+gn+"\",\""+se.id+"\")")==true)
			return;
		if(gs.NeedPostBack)
			igtbl_doPostBack(gn,'HeaderDblClick:'+se.id);
	}
}

function igtbl_selectRegion(gn,se)
{
	var gs=igtbl_getGridById(gn);
	if(!gs || !se)
		return;
	var rowContainer;
	var cell=igtbl_getCellById(se.id),row=null;
	if(!cell)
		row=igtbl_getRowById(se.id);
	else
		row=cell.Row;
	if(!row)
		return;
	if(se.getAttribute("groupRow"))
		rowContainer=se.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
	else
		rowContainer=row.Element.parentNode;
	var te=gs.Element;
	var selTableId = te.getAttribute("selectTable");
	var workTableId;
	if(row.IsAddNewRow && row.Band.Index==0)
		workTableId=gs.Element.id;
	else
	if(se.getAttribute("groupRow"))
		workTableId=se.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.id;
	else
		workTableId=row.Element.parentNode.parentNode.id;
	if(workTableId=="")
		return;
	var bandNo=igtbl_getElementById(workTableId).getAttribute("bandNo");
	if(selTableId==workTableId)
	{
		var selMethod = te.getAttribute("selectMethod");
		if(selMethod=="row" && (!cell || igtbl_getCellClickAction(gn,bandNo)==2 && cell || se.getAttribute("groupRow")))
		{
			var selRow=igtbl_getRowById(te.getAttribute("startPointRow"));
			var rowId;
			if(se.getAttribute("groupRow"))
				rowId=se.parentNode.parentNode.parentNode.parentNode.parentNode.id;
			else
				rowId=row.Element.id;
			var curRow=igtbl_getRowById(rowId);
			if(selRow && igtbl_getSelectTypeRow(gn,bandNo)==3 && igtbl_getCellClickAction(gn,bandNo)>0)
			{
				gs.selectRowRegion(selRow,curRow);
				igtbl_setActiveRow(gn,curRow.getFirstRow());
			}
			else
			{
				if(!(curRow.getSelected() && igtbl_getLength(gs.SelectedRows)==1))
				{
					igtbl_clearSelectionAll(gn);
					if(se.getAttribute("groupRow"))
						rowId=igtbl_getWorkRow(row.Element,gn).id;
					if(igtbl_getSelectTypeRow(gn,bandNo)>1 && igtbl_getCellClickAction(gn,bandNo)>0)
						igtbl_selectRow(gn,curRow);
				}
				igtbl_setActiveRow(gn,igtbl_getFirstRow(igtbl_getElementById(rowId)));
			}
		}
		else if(selMethod=="cell" && cell)
		{
			var selCell=igtbl_getCellById(te.getAttribute("startPointCell"));
			var curCell=igtbl_getCellById(se.id);
			if(igtbl_getSelectTypeCell(gn,bandNo)==3 && igtbl_getCellClickAction(gn,bandNo)>0 && selCell)
			{
				gs.selectCellRegion(selCell,curCell);
				curCell.activate();
			}
			else
			{
				if(!(curCell.getSelected() && igtbl_getLength(gs.SelectedRows)==1))
				{
					igtbl_clearSelectionAll(gn);
					if(igtbl_getSelectTypeCell(gn,bandNo)>1 && igtbl_getCellClickAction(gn,bandNo)>0)
						igtbl_selectCell(gn,curCell);
				}
				igtbl_setActiveCell(gn,se);
			}
		}
	}
}

function igtbl_setSelectedRowImg(gn,row,hide)
{
	var gs=igtbl_getGridById(gn);
	if(!gs) return;
	if(row)
		igtbl_getRowById(row.id).setSelectedRowImg(hide);
}

function igtbl_setNewRowImg(gn,row)
{
	var gs=igtbl_getGridById(gn);
	if(!gs) return;
	gs.setNewRowImg(row?igtbl_getRowById(row.id):null);
}

function igtbl_clearSelectionAll(gn)
{
	var gs=igtbl_getGridById(gn);
	if(igtbl_fireEvent(gn,gs.Events.BeforeSelectChange,"(\""+gn+"\",\"\")")==true)
		return;
	var row,column,cell;
	gs._noCellChange=false;
	for(var row in gs.SelectedRows)
		igtbl_selectRow(gn,row,false,false);
	for(var column in gs.SelectedColumns)
		igtbl_selectColumn(gn,column,false,false);
	for(var row in gs.SelectedCellsRows)
	{
		for(var cell in gs.SelectedCellsRows[row])
			delete gs.SelectedCellsRows[row][cell];
		delete gs.SelectedCellsRows[row];
	}
	for(var cell in gs.SelectedCells)
		igtbl_selectCell(gn,cell,false,false);
}

function igtbl_selectCell(gn,cellID,selFlag,fireEvent)
{
	var cell=cellID;
	if(typeof(cell)=="string")
		cell=igtbl_getCellById(cellID);
	else
		cellID=cell.Element.id;
	if(!cell)
		return;
	cell.select(selFlag,fireEvent);
}

function igtbl_selectRow(gn,rowID,selFlag,fireEvent)
{
	var rowObj=rowID;
	if(typeof(rowObj)=="string")
		rowObj=igtbl_getRowById(rowID);
	else
		rowID=rowObj.Element.id;
	if(!rowObj)
		return false;
	return rowObj.select(selFlag,fireEvent);
}

function igtbl_selColRI(gn,column,bandNo,colNo,nonFixed)
{
	var cellElems=igtbl_enumColumnCells(gn,column);
	for(var i=0;i<cellElems.length;i++)
	{
		var visElem=cellElems[i];
		igtbl_changeStyle(gn,visElem,igtbl_getSelCellClass(gn,bandNo,colNo));
	}
	igtbl_changeStyle(gn,column,igtbl_getSelHeadClass(gn,bandNo,colNo));
	igtbl_dispose(cellElems);
}

function igtbl_enumColumnCells(gn,column)
{
	var cellIndex=null;
	var i=0;
	while(i<column.parentNode.childNodes.length && cellIndex===null)
	{
		if(column.parentNode.childNodes[i]==column)
			cellIndex=i;
		i++;
	}
	var nonFixed=false;
	i=0;
	var pn=column.parentNode;
	while(i<5 && pn && !(pn.tagName=="DIV" && pn.id==gn+"_drs"))
	{
		pn=pn.parentNode;
		nonFixed=pn && pn.tagName=="DIV" && pn.id==gn+"_drs";
		i++;
	}
	var ar=new Array();
	var colIdA=column.id.split("_");
	var fac=igtbl_getBandFAC(gn,column);
	var thead=column.parentNode;
	while(thead && thead.tagName!="THEAD")
		thead=thead.parentNode;
	if(thead)
		for(var i=1;i<thead.parentNode.rows.length;i++)
		{
			var row=thead.parentNode.rows[i];
			if(!row.getAttribute("hiddenRow") && row.parentNode.tagName!="TFOOT"
				
				
			)
			{
				var visElem=null;
				if(!nonFixed)
					visElem=row.cells[cellIndex];
				else
					for(var j=fac;j<row.cells.length && !visElem;j++)
					{
						var cell=row.cells[j];
						if(cell.firstChild && cell.firstChild.id==gn+"_drs")
						{
							row=cell.firstChild.firstChild.rows[0];
							visElem=row.cells[cellIndex];
						}
					}
				if(visElem)
					ar[ar.length]=visElem;
			}
		}
	return ar;
}

function igtbl_selectColumn(gn,columnID,selFlag,fireEvent)
{
	var column=igtbl_getElementById(columnID);
	var colObj=igtbl_getColumnById(columnID);
	
	if (!colObj)return;
	var bandNo=colObj.Band.Index;
	if(igtbl_getSelectTypeColumn(gn,bandNo)<2)
		return;
	var colNo=colObj.Index;
	var gs=igtbl_getGridById(gn);
	if(gs._exitEditCancel || gs._noCellChange)
		return;
	if(fireEvent!=false)
		if(igtbl_fireEvent(gn,gs.Events.BeforeSelectChange,"(\""+gn+"\",\""+columnID+"\")")==true)
			return;
	var nonFixed=gs.UseFixedHeaders && !colObj.getFixed();
	var aRow=null;
	var aCell=gs.getActiveCell();
	if(aCell && aCell.Column!=colObj)
		aCell=null;
	else if(!aCell)
		aRow=gs.getActiveRow();
	if(selFlag!=false)
	{
		var cols=igtbl_getDocumentElement(columnID);
		if (cols){
			if(cols.length)
				for(var j=0;j<cols.length;j++)
					igtbl_selColRI(gn,cols[j],bandNo,colNo,nonFixed);
			else
				igtbl_selColRI(gn,column,bandNo,colNo,nonFixed);
			gs._recordChange("SelectedColumns",colObj,gs.GridIsLoaded.toString());
			colObj.Selected=true;
			gs.Element.setAttribute("lastSelectedColumn",columnID);
		}
	}
	else
	{
		var cols=igtbl_getDocumentElement(columnID);
		if(!cols.length)
			cols=[cols];
		for(var j=0;j<cols.length;j++)
		{
			var colsj=cols[j];
			igtbl_changeStyle(gn,colsj,null);
			var cellElems=igtbl_enumColumnCells(gn,cols[j]);
			for(var i=0;i<cellElems.length;i++)
			{
				var cell=cellElems[i];
				var row=cell.parentNode;
				if(!row.getAttribute("hiddenRow") && !gs.SelectedRows[row.id] && !gs.SelectedCells[cell.id])
					igtbl_changeStyle(gn,cell,null);
			}
			igtbl_dispose(cellElems);
		}
		gs._removeChange("SelectedColumns",colObj);
		colObj.Selected=false;
	}
	if(aRow)
		aRow.renderActive();
	if(aCell)
		aCell.renderActive();
	if(fireEvent!=false)
	{
		var gsNPB = gs.NeedPostBack;
		igtbl_fireEvent(gn,gs.Events.AfterSelectChange,"(\""+gn+"\",\""+columnID+"\");");
		if(!gsNPB && !(gs.Events.AfterSelectChange[1]&4))
			gs.NeedPostBack=false;
		if(gs.NeedPostBack)
			igtbl_moveBackPostField(gn,"SelectedColumns");
	}
}

// Expands/collapses row in internal row structure
function igtbl_stateExpandRow(gn,row,expandFlag,id,level)
{
	var gs=igtbl_getGridById(gn);
	if(!gs)
		return;
	if(expandFlag)
	{
		var dk=(row?row.DataKey:null)
		var stateChange=gs._recordChange("ExpandedRows",row,dk,id);
		if(!row)
			ig_ClientState.setPropertyValue(stateChange.Node,"Level",level);
		else if(gs.CollapsedRows[row.Element.id])
			gs._removeChange("CollapsedRows",row);
	}
	else
	{
		if(!row) return;
		gs._recordChange("CollapsedRows",row,row.DataKey);
		gs._removeChange("ExpandedRows",row);
	}
}

function igtbl_arrayHasElements(array)
{
	if(!array)
		return false;
	for(element in array)
		if(array[element]!=null)
			return true;
	return false;
}

function igtbl_getLeftPos(e,cc,oe)
{
	return igtbl_getAbsolutePos("Left",e,cc,oe);
}

function igtbl_getTopPos(e,cc,oe) 
{
	return igtbl_getAbsolutePos("Top",e,cc,oe);
}

function igtbl_getAbsolutePos(where,e,cc,oe)
{
	var offs="offset"+where,cl="client"+where,bw="border"+where+"Width",sl="scroll"+where;
    var crd=e[offs];
    if(e[cl] && cc!=false)
		crd+=e[cl];
	if(typeof(oe)=="undefined")
		oe=null;
    var tmpE=e.offsetParent, cSb=true;
    while(tmpE!=null && tmpE!=oe)
    {
		crd+=tmpE[offs];
		if((tmpE.tagName=="DIV" || tmpE.tagName=="TD") && tmpE.style[bw])
		{
			var bwv=parseInt(tmpE.style[bw],10);
			if(!isNaN(bwv))
				crd+=bwv;
		}
		if(cSb && typeof(tmpE[sl])!="undefined")
		{
			var op=tmpE.offsetParent,t=tmpE;
			while(t && t!=op && t.tagName!=(igtbl_isXHTML?"HTML":"BODY"))
			{
				if(t[sl])
					crd-=t[sl];
				t=t.parentNode;
			}
			if(tmpE.tagName=="DIV")
				cSb=false;
		}
		if(tmpE[cl] && cc!=false)
			crd+=tmpE[cl];
        tmpE=tmpE.offsetParent;
    }
	if(tmpE && tmpE[cl] && cc!=false)
		crd+=tmpE[cl];
    return crd;
}

function igtbl_getAbsBounds(elem,g)
{
	var ok=0,r=new Object(),body=window.document.body,e=elem;
	var z=e.offsetWidth,pe=e;
	if(z==null||z<2)
		z=70;
	r.w=z;
	z=e.offsetHeight;
	if(z==null||z<2)
		z=18;
	r.h=z;
	r.x=1;
	r.y=1;
	while(e!=null)
	{
		if(ok<1||e==body)
		{
			z=e.offsetLeft;
			if(z)
				r.x+=z;
			z=e.offsetTop;
			if(z)
				r.y+=z;
		}
		if(e.nodeName=="HTML")
			body=e;
		if(e==body)
			break;
		z=e.scrollLeft;
		if(z==null||z==0)
			z=pe.scrollLeft;
		if(z!=null&&z>0)
			r.x-=z;
		z=e.scrollTop;
		if(z==null||z==0)
			z=pe.scrollTop;
		if(z!=null&&z>0)
			r.y-=z;
		pe=e.parentNode;
		e=e.offsetParent;
		if(pe.tagName=="TR")
			pe=e;
		if(e==body && pe.tagName=="DIV")
		{
			e=pe;
			ok++;
		}
	}
	try
	{
		
		if(!document.elementFromPoint || window.frameElement || body.currentStyle && (body.currentStyle.borderWidth=="0px" || body.currentStyle.borderStyle=="none"))
			return r;
	}
	catch(e)
	{
		return r;
	}			
	var i=1,x=r.x,y=r.y,x0=igtbl_getBodyScrollLeft(),y0=igtbl_getBodyScrollTop();
	while(++i<16)
	{
		z=(i>2)?((i&2)-1)*(i&14)/2*5:2;
		e=document.elementFromPoint(x+z-x0,y+z-y0);
		if(!e || e==elem || e.parentNode==elem || e.parentNode.parentNode==elem)
			break;
	}
	if(i>15||!e)
		return r;
	x+=z;
	y+=z;
	i=0;
	z=0;
	while(++i<22)
	{
		if(z==0)
			x--;
		else
			y--;
		e=document.elementFromPoint(x-x0,y-y0);
		if(!e || i>20)
			return r;
		if(e!=elem && e.parentNode!=elem && e.parentNode.parentNode!=elem)
			if(z>0)
				break;
			else
			{
				i=z=1;
				x++;
			}
	}
	r.x=x-1;
	r.y=y;
	return r;
}

function igtbl_getRelativePos(gn,e,where)
{
	var g=igtbl_getGridById(gn);
	var mainGrid=igtbl_getElementById(gn+"_main");
	var passedMainGrid=false;
	var offs="offset"+where,bw="border"+where+"Width";
	var ovfl="overflow",ovflC=ovfl+(where=="Left"?"X":"Y");
	var crd=e[offs];
	var parent=e.offsetParent;
	while((parent!=null && parent.tagName!=(igtbl_isXHTML?"HTML":"BODY") && (
		!passedMainGrid || 
		parent.style.position!="relative" || (parent.style.position=="relative" && parent.id=="G_"+gn))))
	{
		passedMainGrid=passedMainGrid||igtbl_isAChildOfB(mainGrid.parentNode,parent);
		if(passedMainGrid && (parent.style.position=="absolute" || parent.style[ovflC] && parent.style[ovflC]!="visible" || parent.style[ovfl] && parent.style[ovfl]!="visible"))
			break;
		crd+=parent[offs];
		if(ig_csom.IsIE && (parent.tagName=="DIV" || parent.tagName=="TD" || parent.tagName=="FIELDSET") && parent.style[bw])
		{
			var bwv=parseInt(parent.style[bw],10);
			if(!isNaN(bwv))
				crd+=bwv;
		}
		if(parent==mainGrid)
			passedMainGrid=true;
		parent=parent.offsetParent;
	}
	return crd-g.Element.offsetParent["scroll"+where];
}
function igtbl_isAChildOfB(a,b){
	if(a==null||b==null)return false;
	while(a!=null){
		if(a==b)return true;
		a=a.parentNode;
	}
	return false;
}
function igtbl_moveBackPostField(gn,param)
{
	var gs=igtbl_getGridById(gn);
	gs.moveBackPostField=param;
}

function igtbl_updatePostField(gn,param)
{
} 

function igtbl_isVisible(elem)
{
	while(elem && elem.tagName!=(igtbl_isXHTML?"HTML":"BODY"))
	{
		if(elem.style && elem.style.display=="none")
			return false;
		elem=elem.parentNode;
	}
	return true;
}

var igtbl_dontHandleChkBoxChange=false;

function igtbl_chkBoxChange(evnt,gn)
{
	if(igtbl_dontHandleChkBoxChange||
	 (ig_csom.IsIE && evnt.propertyName!="checked")||
	 (!ig_csom.IsIE && evnt.type!="change")
	 )
		return false;
	var se=igtbl_srcElement(evnt);
	if(!se)return false;
	var c=se.parentNode;
	while(c && !(c.tagName=="TD" && c.id!=""))
		c=c.parentNode;
	if(!c) return;
	var s=se;
	var cell=igtbl_getCellById(c.id);
	if(!cell) return;
	var column=cell.Column;
	var gs=igtbl_getGridById(gn);
	gs.event=evnt;
	var oldValue=!s.checked;
	if(gs._exitEditCancel || !cell.isEditable() || igtbl_fireEvent(gn,gs.Events.BeforeCellUpdate,"(\""+gn+"\",\""+c.id+"\",\""+s.checked+"\")"))
	{
		igtbl_dontHandleChkBoxChange=true;
		s.checked=oldValue;
		igtbl_dontHandleChkBoxChange=false;
		return true;
	}
	cell.Row._dataChanged|=2;
	if(typeof(cell._oldValue)=="undefined")
		cell._oldValue=oldValue;
	igtbl_saveChangedCell(gs,cell,s.checked.toString());
	cell.Value=cell.Column.getValueFromString(s.checked);
	if(!c.getAttribute("oldValue"))
		c.setAttribute("oldValue",s.checked);
	c.setAttribute("chkBoxState",s.checked.toString());
	var cca=igtbl_getCellClickAction(gn,column.Band.Index);
	if(cca==1 || cca==3)
		igtbl_setActiveCell(gn,c);
	else if(cca==2)
		igtbl_setActiveRow(gn,c.parentNode);
		
	if(cell.Node)
	{
		cell.Node.selectSingleNode("V").text=!s.checked?"False":"True";
		var cdata=cell.Node.firstChild.firstChild;
		if(s.checked)
			cdata.text=cdata.text.replace("type=checkbox","type=checkbox checked");
		else
			cdata.text=cdata.text.replace(" checked","");
		gs.invokeXmlHttpRequest(gs.eReqType.UpdateCell,cell,s.checked);
	}		
	igtbl_fireEvent(gn,gs.Events.AfterCellUpdate,"(\""+gn+"\",\""+c.id+"\",\""+s.checked+"\")");
	if(gs.LoadOnDemand==3)
		gs.NeedPostBack=false;
	if(gs.NeedPostBack)
		igtbl_doPostBack(gn);
	return false;
}

function igtbl_colButtonClick(evnt,gn,b,se)
{
	if(!b)b=igtbl_getElementById(gn+"_bt");
	if(b&&se==null)
		se=igtbl_getElementById(b.getAttribute("srcElement"));
	if(se==null || !se.id)
	{
		if(!se)
			se=igtbl_srcElement(evnt).parentNode;
		else
			se=se.parentNode;
		if(se && se.tagName=="NOBR")
			do
			{
				se=se.parentNode;
			}while(se && se.tagName!="TD");
	}
	var gs=igtbl_getGridById(gn);
	if(gs==null||gs._exitEditCancel||se==null||se.id=="")
		return;
	gs.event=evnt;
	var cell=igtbl_getCellById(se.id);
	if(!cell)return;
	var sel=cell!=gs.oActiveCell;
	try{
		if(sel && igtbl_isChild(gn,cell.Element))cell.activate();
	}catch(e){}
	igtbl_fireEvent(gn,gs.Events.ClickCellButton,"(\""+gn+"\",\""+se.id+"\")");
	if(gs.NeedPostBack)
	{
				
		var cellInfo = cell.Row._generateUpdateRowSemaphore(false);
		if(igtbl_doPostBack(gn,'CellButtonClick:'+se.id+"\x05"+cell.getLevel(true)+(gs.LoadOnDemand==3?"\x02"+cellInfo+"\x02"+cell.Row.Band.Index+"\x02"+cell.Row.DataKey:"")))
			return;
	}	
}

function igtbl_colButtonMouseOut(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	if(gs==null)return;
	var b=igtbl_getElementById(gn+"_bt");
	if(!b||b.getAttribute("noOnBlur"))
		return;
	if(evnt && evnt.toElement && evnt.toElement.id==b.getAttribute("srcElement"))
		return;
	if(b.style.display=="")
	{
		b.setAttribute("noOnBlur",true);
		b.style.display="none";
		b.removeAttribute("srcElement");
		if(!gs.Activation.AllowActivation)
			return;
		if(gs.oActiveCell)
		{
			if(!gs.oActiveCell.Row.GroupByRow && gs.oActiveCell.Column.ColumnType==7 && gs.oActiveCell.Column.CellButtonDisplay==0)
				igtbl_showColButton(gn,gs.oActiveCell.Element);
		}
		window.setTimeout("igtbl_clearNoOnBlurBtn('"+gn+"')",100);
		gs._mouseIn=null;
	}
}

function igtbl_clearNoOnBlurBtn(gn)
{
	var b=igtbl_getElementById(gn+"_bt");
	b.removeAttribute("noOnBlur");
}

function igtbl_clearNoOnBlurElem(id)
{
	var e=igtbl_getElementById(id);
	e.removeAttribute("noOnBlur");
}

function igtbl_getColumnNo(gn,cell)
{
	if(cell)
	{
		var column=igtbl_getColumnById(cell.id);
		if(column)
			return column.Index;
		else
			return -1;
	}
}

function igtbl_getBandNo(cell)
{
	if(!cell)
		return -1;
	var tbl=cell;
	while(tbl && !tbl.getAttribute("bandNo"))
		tbl=tbl.parentNode;
	if(tbl)
		return parseInt(tbl.getAttribute("bandNo"));
	return -1;
}

function igtbl_getFirstRow(row)
{
	if(row.getAttribute("groupRow"))
		return row.childNodes[0].childNodes[0].childNodes[0].rows[0];
	else
		return row;
}

function igtbl_getWorkRow(row,gridId)
{
	if(!row) return;
	if(row.getAttribute("groupRow"))
	{
		var id=row.id.split("_");
		if(!gridId)
		{			
			if(id[1]=="sgr")
				return row.parentNode.parentNode.parentNode.parentNode;
			else
				return row;
		}
		else
		{
			var rowId = id[1];
			if (rowId=="sgr")
				return row.parentNode.parentNode.parentNode.parentNode;
			else
				return row;
		}

	}
	else
		return row;
}

function igtbl_getCurCell(se)
{
	var c=null;
	while(se && !c) 
		if(se.tagName=="TD")
			c=se;
		else
			se=se.parentNode;
	return c;
}

function igtbl_getColumnByCellId(cellID)
{
	var cell=igtbl_getCellById(cellID);
	if(!cell)
		return null;
	if(cell.Band.Grid.UseFixedHeaders && !cell.Column.getFixed())
	{
		var tbl;
		if(cell.Band.Index==0 && !cell.Band.IsGrouped && cell.Band.ColHeadersVisible==1 && (cell.Band.Grid.StationaryMargins==1 || cell.Band.Grid.StationaryMargins==3))
			tbl=cell.Band.Grid.StatHeader.Element.parentNode;
		else
		{
			tbl=cell.Element;
			while(tbl!=null && (tbl.tagName!="TABLE" || !tbl.id))
				tbl=tbl.parentNode;
		}
		if(tbl)
		{
			thCells=tbl.childNodes[1].rows[0].cells[cell.Element.parentNode.parentNode.parentNode.parentNode.parentNode.cellIndex].firstChild.firstChild.rows[0].cells;
			var i=0;
			while(i<thCells.length && thCells[i].cellIndex!=cell.Element.cellIndex)
				i++;
			if(i<thCells.length)
				return thCells[i];
		}
		return null;
	}
	if(cell.Band.Index==0 && !cell.Band.IsGrouped && cell.Band.ColHeadersVisible==1 && (cell.Band.Grid.StationaryMargins==1 || cell.Band.Grid.StationaryMargins==3))
		return igtbl_getElemVis(cell.Band.Grid.StatHeader.Element.rows[0].cells,cell.Element.cellIndex);
	if(cell.Element.parentNode.parentNode.parentNode.childNodes[1].tagName=="THEAD")
		return igtbl_getElemVis(cell.Element.parentNode.parentNode.parentNode.childNodes[1].rows[0].cells,cell.Element.cellIndex);
	return null;
}

function igtbl_colButtonEvent(evnt,gn)
{
}

function igtbl_isCell(itemName)
{
	var parts = itemName.split("_");
	if(parts[0].charAt(parts[0].length-2)=="r" && parts[0].charAt(parts[0].length-1)=="c")
		return true;
	return false;
}

function igtbl_isColumnHeader(itemName)
{
	var parts = itemName.split("_");
	if(parts[0].charAt(parts[0].length-1)=="c" && !igtbl_isCell(itemName))
		return true;
	return false;
}

function igtbl_isRowLabel(itemName)
{
	var parts = itemName.split("_");
	if(parts[0].charAt(parts[0].length-1)=="l")
		return true;
	return false;
}

function igtbl_fireEvent(gn,eventObj,eventString)
{
	var gs=igtbl_getGridById(gn);
	if(!gs || !gs.GridIsLoaded) return;
	var result=false;
	if(eventObj[0]!="")
		try{result=eval(eventObj[0]+eventString);}catch(ex){return false;}
	if(gs.GridIsLoaded && result!=true && eventObj[1]>=1 && !gs.CancelPostBack)
		igtbl_needPostBack(gn);
	gs.CancelPostBack=false;
	return result;
}

function igtbl_dropDownChange(evnt,gn)
{
	var sel = null;
	if (!gn)
	{
		sel = igtbl_srcElement(evnt);
		gn = sel.id.substring(0,sel.id.length-3);
	}
	else
	{
		sel = igtbl_getElementById(gn+"_vl");
	}
	igtbl_getGridById(gn).event=evnt;
	if(sel && sel.style.display=="")
		igtbl_fireEvent(gn,igtbl_getGridById(gn).Events.ValueListSelChange,"(\""+gn+"\",\""+gn+"_vl\",\""+sel.getAttribute("currentCell")+"\");");
}

function igtbl_inEditMode(gn)
{
	var g = igtbl_getGridById(gn);
	if(g&&g._cb)return g._editorCurrent!=null;
	if(g.editorControl && g.editorControl.getVisible())
		return true;
	var sel=igtbl_getElementById(gn+"_vl");
	if(sel && sel.style.display=="")
		return true;
	var tb=igtbl_getElementById(gn+"_tb");
	if(tb && tb.style.display=="")
		return true;
	var ta=igtbl_getElementById(gn+"_ta");
	if(ta && ta.style.display=="")
		return true;
	return false;
}

function igtbl_bandNoFromColId(colId)
{
	var s=colId.split("_");
	if(s.length<3)
		return null;
	return parseInt(s[s.length-2]);
}

function igtbl_colNoFromColId(colId)
{
	var s=colId.split("_");
	if(s.length<3)
		return null;
	return parseInt(s[s.length-1]);
}

function igtbl_colNoFromId(id)
{
	if(!id)
		return null;
	var s=id.split("_");
	if(s.length==0)
		return null;
	return parseInt(s[s.length-1]);
}

function igtbl_doPostBack(gn,args)
{
	var gs=igtbl_getGridById(gn);
	if(gs.GridIsLoaded && !gs.CancelPostBack)
	{
		gs.GridIsLoaded=false;
		if(!args)
			args="";
		
		window.setTimeout("__doPostBack('"+gs.UniqueID+"','"+args+"');");
		return true;
	}
	return false;
}

function igtbl_scrollToView(gn,child,childWidth,nfWidth
,scrollDirection
)
{
	if(!child)
		return;
	var gs=igtbl_getGridById(gn);
	var parent=gs.Element.parentNode;
	var scrParent=parent;
	if(gs.UseFixedHeaders
	|| gs.XmlLoadOnDemandType!=0
	)
		scrParent=gs._scrElem;
	if(scrParent.scrollWidth<=scrParent.offsetWidth && scrParent.scrollHeight<=scrParent.offsetHeight)
		return;
	var childLeft=igtbl_getLeftPos(child);
	var parentLeft=igtbl_getLeftPos(parent);
	var childTop=igtbl_getTopPos(child);
	var parentTop=igtbl_getTopPos(parent);
	var childRight=childLeft+child.offsetWidth;
	var childBottom=childTop+child.offsetHeight;	
	
	var parentRight=parentLeft+parent.clientWidth;
	var parentBottom=parentTop+parent.clientHeight;	
	var hsw=parent.offsetHeight-parent.clientHeight;
	var vsw=parent.offsetWidth-parent.clientWidth;
	if(!scrollDirection || scrollDirection==2)
	{
		if(childBottom>parentBottom)
		{
			
			if(childTop-(parentTop-childTop)>parentTop && childBottom-childTop<parentBottom-parentTop)
				igtbl_scrollTop(scrParent,scrParent.scrollTop+childBottom-parentBottom+hsw-1);
			else
				igtbl_scrollTop(scrParent,scrParent.scrollTop+childTop-parentTop-1);
		}
		if(childTop<parentTop)
			igtbl_scrollTop(scrParent,scrParent.scrollTop-(parentTop-childTop)-1);
	}
	
	if(!scrollDirection || scrollDirection==1)
	{
		if(typeof(nfWidth)!="undefined" && nfWidth!==null && (childLeft==childRight || childRight-childLeft<=childWidth))
		{
			igtbl_scrollLeft(scrParent,nfWidth);
			return;
		}
		if(childRight>parentRight)
		{
			
			if(childLeft-(childRight-parentRight)>parentLeft && childRight-childLeft<parentRight-parentLeft)
				igtbl_scrollLeft(scrParent,scrParent.scrollLeft+childRight-parentRight+vsw);
			else
				igtbl_scrollLeft(scrParent,scrParent.scrollLeft+childLeft-parentLeft);
		}
		if(childLeft<parentLeft)
			igtbl_scrollLeft(scrParent, scrParent.scrollLeft-parentLeft+childLeft-vsw);
			
		else if(childLeft==parentLeft)
			igtbl_scrollLeft(scrParent, 0);
	}
}

function igtbl_unloadGrid(gn)
{
	var grid=igtbl_gridState[gn];
	if(!grid) return;
	if(grid.oldIgtblGrid)
		igtbl_unloadGrid(grid.oldIgtblGrid.Id);
	grid.disposing=true;
	try
	{
		var f = grid._thisForm;
		f.igtblGrid = null;;
		f.igtbl_oldOnSubmit = null;
		f.onsubmit = null;
		window.__doPostBackOld = null;
		window.__thisForm = null;
	}
	catch(ex)
	{
	}
	igtbl_dispose(igtbl_gridState[gn]);
	delete igtbl_gridState[gn];
}

function igtbl_dispose(obj)
{
	if(ig_csom.IsNetscape || ig_csom.IsNetscape6)
		return;
	for(var item in obj)
	{
		if(typeof(obj[item])!="undefined" && obj[item]!=null && !obj[item].tagName && !obj[item].disposing && typeof(obj[item])!="string")
		{
			try {
				
				obj[item].disposing=true;
				igtbl_dispose(obj[item]);				
			} catch(exc1) {;}
		}
		try {
			delete obj[item];
		} catch(exc2) {
			return;
		}
	}
}

function igtbl_getElemVis(cols,index)
{
	var i=0,j=-1;
	while(cols && cols[i] && j!=index)
	{
		if(cols[i].style.display!="none")
			j++;
		i++;
	}
	return cols[i-1];
}

function igtbl_trim(s)
{
	if(!s)
		return s;
	s=s.toString();
	var result=s;
	for(var i=0;i<s.length;i++)
		if(s.charAt(i)!=' ')
			break;
	result=s.substr(i,s.length-i);
	for(var i=result.length-1;i>=0;i--)
		if(result.charAt(i)!=' ')
			break;
	result=result.substr(0,i+1);
	return result;
}

function igtbl_cancelNoOnBlurTB(gn,id)
{
	if(id)
	{
		var src=igtbl_getElementById(id);
		if(src)
		{
			src.removeAttribute("noOnBlur");
			return;
		}
	}
	var textBox=igtbl_getElementById(gn+"_tb");
	if(textBox && textBox.style.display=="")
		textBox.removeAttribute("noOnBlur");
	var sel=igtbl_getElementById(gn+"_vl");
	if(sel && sel.style.display=="")
		sel.removeAttribute("noOnBlur");
}

function igtbl_cancelNoOnBlurDD(gn)
{
	if(arguments.length==0)
		gn=igtbl_lastActiveGrid;
	var gs=igtbl_getGridById(gn);
	if(gs && gs.editorControl)
		gs.editorControl.Element.removeAttribute("noOnBlur");
}

function igtbl_getChildRows(gn,row)
{
	var rows=null;
	if(!row || !row.id)
		return rows;
	var rObj=igtbl_getRowById(row.id);
	if(!rObj)
		return rows;
	return rObj.getChildRows();
}

function igtbl_rowsCount(rows)
{
	var i=0,j=0;
	while(j<rows.length)
	{
		if(!rows[j].getAttribute("hiddenRow")
			&& !rows[j].getAttribute("addNewRow")
		)
			i++;
		j++;
	}
	return i;
}

function igtbl_visRowsCount(rows)
{
	var i=0,j=0;
	while(j<rows.length)
	{
		if(!rows[j].getAttribute("hiddenRow") && rows[j].style.display==""
			&& !rows[j].getAttribute("addNewRow")
		)
			i++;
		j++;
	}
	return i;
}

var igtbl_oldOnUnload;
var igtbl_bInsideOldOnUnload=false;
function igtbl_unload()
{
	if(igtbl_oldOnUnload && !igtbl_bInsideOldOnUnload)
	{
		igtbl_bInsideOldOnUnload=true;
		igtbl_oldOnUnload();
		igtbl_bInsideOldOnUnload=false;
	}
	for(var gridId in igtbl_gridState)
	{
		try
		{
			if(typeof(document)!=='unknown')
			{
				var p=igtbl_getElementById(gridId);
				p.value=ig_ClientState.getText(igtbl_gridState[gridId].ViewState);
			}
		}
		catch(e)	
		{		
		}
		if(igtbl_gridState[gridId].unloadGrid)
			igtbl_gridState[gridId].unloadGrid();
		else
			delete igtbl_gridState[gridId];
	}
}

if(window.addEventListener)
	window.addEventListener('unload',igtbl_unload,false);
else if(window.onunload!=igtbl_unload)
{
	igtbl_oldOnUnload=window.onunload;
	window.onunload=igtbl_unload;
}

function igtbl_addEventListener(obj,eventName,fRef,dispatch)
{
	if(typeof(dispatch)=="undefined")
		dispatch=true;
	if(obj.addEventListener)
		return obj.addEventListener(eventName,fRef,dispatch);
	else
	{
		var oldHandler=obj["on"+eventName];
		eval("obj.on"+eventName+"=fRef;");
		return oldHandler;
	}
}
function igtbl_removeEventListener(obj,eventName,fRef,oldfRef,dispatch)
{
	if(typeof(dispatch)=="undefined")
		dispatch=true;
	if(obj.removeEventListener)
		return obj.removeEventListener(eventName,fRef,dispatch);
	else
		eval("obj.on"+eventName+"=oldfRef;");
}

// obsolete
// use igcsom.cancelEvent instead 
function igtbl_cancelEvent(evnt)
{
	ig_cancelEvent(evnt);
	return false;
}

function igtbl_getRegExpSafe(val)
{
	if(typeof(val)=="undefined" || val==null)
		return "";
	var res=val.toString().replace("\\","\\\\");
	res=res.replace(/\^/g,"\\^");
	res=res.replace(/\*/g,"\\*");
	res=res.replace(/\$/g,"\\$");
	res=res.replace(/\+/g,"\\+");
	res=res.replace(/\?/g,"\\?");
	res=res.replace(/\,/g,"\\,");
	res=res.replace(/\./g,"\\.");
	res=res.replace(/\:/g,"\\:");
	res=res.replace(/\=/g,"\\=");
	res=res.replace(/\-/g,"\\-");
	res=res.replace(/\!/g,"\\!");
	res=res.replace(/\|/g,"\\|");
	res=res.replace(/\(/g,"\\(");
	res=res.replace(/\)/g,"\\)");
	res=res.replace(/\[/g,"\\[");
	res=res.replace(/\]/g,"\\]");
	res=res.replace(/\{/g,"\\{");
	res=res.replace(/\}/g,"\\}");
	return res;
}

function igtbl_saveChangedCell(gs,cell,value)
{
	if(typeof(gs.ChangedRows[cell.Row.Element.id])=="undefined")
		gs.ChangedRows[cell.Row.Element.id]=new Object();
	if(cell.Element)
		gs.ChangedRows[cell.Row.Element.id][cell.Element.id]=true;
	gs._recordChange("ChangedCells",cell,value);
}

function igtbl_endCustomEdit()
{
	if(arguments.length<3)
		return;
	var oEditor=arguments[0];
	var oEvent=arguments[arguments.length-2];
	var oThis=arguments[arguments.length-1];
	var key=(oEvent&&oEvent.event)?oEvent.event.keyCode:0;
	if(oThis)oThis._lastKey=key;
	if(oEvent && typeof(oEvent.event)!="undefined"&&key!=9&&key!=13&&key!=27&&key!=0)
		return;
	var se=null;
	if(oEditor.Element)
		se=oEditor.Element;
	if(se!=null)
	{
		if(se.getAttribute("noOnBlur"))
			return igtbl_cancelEvent(oEvent.event);
		if(se.getAttribute("editorControl"))
		{
			if(!oEditor.getVisible())
				return;
			var cell=igtbl_getElementById(se.getAttribute("currentCell"));
			if(!cell)
				return;
			var gs=oThis;
			var cellObj=igtbl_getCellById(cell.id);
			if(key==27)
				oEditor.setValue(cellObj.getValue(),false);
			if(typeof(oEditor.getValue())!="undefined")
				cellObj.setValue(oEditor.getValue());
			if(igtbl_fireEvent(gs.Id,gs.Events.BeforeExitEditMode,"(\""+gs.Id+"\",\""+cell.id+"\")")==true)
			{
				if(!gs._exitEditCancel && !gs._insideSetActive)
				{
					gs._insideSetActive=true;
					igtbl_setActiveCell(gs.Id,cell);
					gs._insideSetActive=false;
				}
				gs._exitEditCancel=true;				
				return true;
			}
			oEditor.setVisible(false);
			oEditor.removeEventListener("blur",igtbl_endCustomEdit);
			oEditor.removeEventListener("keydown",igtbl_endCustomEdit);
			gs._exitEditCancel=false;
			se.removeAttribute("currentCell");
			se.removeAttribute("oldInnerText");
			gs.editorControl = null;
			se.removeAttribute("editorControl");
			igtbl_fireEvent(gs.Id,gs.Events.AfterExitEditMode,"(\""+gs.Id+"\",\""+cell.id+"\");");
			if(key==9||key==13)
			{
				var res=null;
				if(typeof(igtbl_ActivateNextCell)!="undefined")
				{
					if(oEvent.event.shiftKey&&key==9)
						res=igtbl_ActivatePrevCell(gs.Id);
					else
						res=igtbl_ActivateNextCell(gs.Id);
				}
				if(res && igtbl_getCellClickAction(gs.Id,cellObj.Column.Band.Index)==1)
					igtbl_EnterEditMode(gs.Id);
				if(!res)
				{
					igtbl_blur(gs.Id);
					return;
				}
				igtbl_activate(gs.Id);
				oEvent.cancel=true;
			}
			else
				gs.alignGrid();
			igtbl_blur(gs.Id);
			if(gs.NeedPostBack)
				igtbl_doPostBack(gs.Id);
		}
	}
}

function igtbl_getLength(obj)
{
	var count=0;
	for(var item in obj)
		count++;
	return count;
}

function igtbl_setActiveCell(gn,cell,force)
{
	var g=igtbl_getGridById(gn);
	if(g)
		g.setActiveCell(cell?igtbl_getCellById(cell.id):null,force);
	return;
}

function igtbl_setActiveRow(gn,row,force)
{
	var g=igtbl_getGridById(gn);
	if(g)
		g.setActiveRow(row?igtbl_getRowById(row.id):null,force);
	return;
}

function igtbl_sortGroupedRows(rows,bandNo,colId)
{
	
	if (rows.length<=0)
		return;
	if(rows.Band.Index==bandNo && rows.getRow(0).Element.getAttribute("groupRow")==colId)
	{
		rows.sort();
		return;
	}
	for(var i=0;i<rows.length;i++)
	{
		var row=rows.getRow(0);
		if(row.Rows && row.Rows.length>0)
			igtbl_sortGroupedRows(row.Rows,bandNo,colId);
	}
}

function igtbl_fixedClick(evnt)
{
	var se=igtbl_srcElement(evnt);
	if(!se)return;
	var pn=se.parentNode;
	while(pn && pn.tagName!="TH") pn=pn.parentNode;
	if(!pn || !pn.id) return;
	var column=igtbl_getColumnById(pn.id);
	if(column.Band.Grid.UseFixedHeaders)
	{
		if(column.getFixed())
			igtbl_doPostBack(column.Band.Grid.Id,"Unfix:"+column.Band.Index+":"+column.Index);
		else
			igtbl_doPostBack(column.Band.Grid.Id,"Fix:"+column.Band.Index+":"+column.Index);
		return igtbl_cancelEvent(evnt);
	}
}

function igtbl_mouseWheel(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	if(!gs || !gs._scrElem) return;
	if(evnt.wheelDelta)
	{
		igtbl_hideEdit(gn);
		gs._scrElem.scrollTop-=evnt.wheelDelta/3;
	}
}

function igtbl_onScrollFixed(evnt,gn)
{
	var g=igtbl_getGridById(gn)
	if(!g || !g._scrElem) return;
	var s=g.Element.parentNode.scrollTop;
	igtbl_scrollTop(g.Element.parentNode,0);
	igtbl_scrollTop(g.Element.parentNode.parentNode,0);
	igtbl_scrollTop(g._scrElem,s);
}

function igtbl_onResizeFixed(evnt,gn)
{
	var g=igtbl_getGridById(gn)
	if(!g || !g._scrElem) return;
	if(g.Element.getAttribute("noOnResize"))
	{
		if(g._scrElem.getAttribute("oldW"))
			g._scrElem.style.width=g._scrElem.getAttribute("oldW");
		if(g._scrElem.getAttribute("oldH"))
			g._scrElem.style.height=g._scrElem.getAttribute("oldH");
		return igtbl_cancelEvent(evnt);
	}
	if(!g._scrElem.style.width || g._scrElem.style.width.charAt(g._scrElem.style.width.length-1)!="%")
		g._scrElem.setAttribute("oldW",g._scrElem.offsetWidth);
	if(!g._scrElem.style.height || g._scrElem.style.height.charAt(g._scrElem.style.height.length-1)!="%")
		g._scrElem.setAttribute("oldH",g._scrElem.offsetHeight);
}

function igtbl_splitUrl(url)
{
	var targetFrame=null;
	if(url.substr(0,1)=="@")
	{
		targetFrame="_blank";
		url=url.substr(1);
		var cb=-1;
		if(url.substr(0,1)=="[" && (cb=url.indexOf("]"))>1)
		{
			targetFrame=url.substr(1,cb-1);
			url=url.substr(cb+1);
		}
	}
	return [url,targetFrame];
}

function igtbl_navigateUrl(url)
{
	var urls=igtbl_splitUrl(url);
	ig_csom.navigateUrl(urls[0],urls[1]);
	igtbl_dispose(urls);
}

function igtbl_isChild(gn,e)
{
	if(!e) return false;
	var ge=igtbl_getElementById(gn+"_main");
	var p=e.parentNode;
	while(p && p!=ge)
		p=p.parentNode;
	return p!=null;
}

function igtbl_blur(gn)
{
	window.setTimeout("igtbl_blurTimeout('"+gn+"')",100);
}

function igtbl_blurTimeout(gn)
{
	var g=igtbl_getGridById(gn);
	if(!g) return;
	var ar=g.getActiveRow();
	var activeElement=null;
	try{
	activeElement=document.activeElement;
	}catch(e){;}
	if(ar && !igtbl_inEditMode(gn) && activeElement && !igtbl_isAChildOfB(activeElement,g.DivElement))
	{
		if(ar.IsAddNewRow)
			ar.commit();
		else
		if(ar.processUpdateRow)
			ar.processUpdateRow();
	}
	if(g._focusElem)
		if(g._lastKey==9||g._lastKey==13||g._lastKey==27)
			igtbl_activate(gn);
}

function igtbl_cancelNoOnScroll(gn)
{
	var g=igtbl_getGridById(gn);
	if(!g)return;
	var de=g.getDivElement();
	de.removeAttribute("noOnScroll");
	de.removeAttribute("oldST");
	de.removeAttribute("oldSL");
	g.cancelNoOnScrollTimeout=0;
}

function igtbl_pageGrid(gn,pageNo)
{
	var g=igtbl_getGridById(gn);
	if(!g || !g.goToPage) return;
	g.goToPage(pageNo);
}

function igtbl_scrollLeft(e,left)
{
	e.scrollLeft=left;
	if((ig_csom.IsNetscape || ig_csom.IsNetscape6) && e.onscroll && !e._insideFFOnScroll)
	{
		e._insideFFOnScroll=true;
		e.onscroll();
		e._insideFFOnScroll=false;
	}
}

function igtbl_scrollTop(e,top)
{
	e.scrollTop=top;
	if((ig_csom.IsNetscape || ig_csom.IsNetscape6) && e.onscroll && !e._insideFFOnScroll)
	{
		e._insideFFOnScroll=true;
		e.onscroll();
		e._insideFFOnScroll=false;
	}
}

function igtbl_adjustNNHeight(grid,th)
{
	var mainGrid=grid.MainGrid;
	if(!mainGrid.style.height) return;
	if(ig_csom.IsNetscape6)
	{
		var tdHeight=th;
		var td=grid.Element.parentNode.parentNode;
		var adjTr=mainGrid.style.height.indexOf("%")<0;
		if(typeof(th)=="undefined")
		{
			var bt=parseInt(mainGrid.style.borderTopWidth);
			if(isNaN(bt)) bt=0;
			var bb=parseInt(mainGrid.style.borderBottomWidth);
			if(isNaN(bb)) bb=0;
			if(!grid._windowHeight)
				td.style.height="1px";
			else
				td.style.height=parseInt(td.style.height)+window.innerHeight-grid._windowHeight;
			if(adjTr)
			{
				td.parentNode.style.height=td.style.height;
								
				if (grid.UseFixedHeaders && td.parentNode.parentNode.tagName=="TR")
				{					
					td.parentNode.parentNode.style.height=td.style.height;
				}
			}	
			tdHeight=mainGrid.offsetHeight-bt-bb;
		}
		if(tdHeight && !isNaN(tdHeight))
		{
			
			if (grid.StatHeader)
			{
				tdHeight-=grid.StatHeader.Element.offsetHeight;			
			}		
			for(var i=0;i<mainGrid.rows.length;i++)
			{
				var row=mainGrid.rows[i];
				if(!igtbl_isAChildOfB(grid.Element.parentNode,row))
				{
					if(row.firstChild.firstChild.id==grid.Id+"_hdiv")
						continue;
					tdHeight-=row.offsetHeight;
				}
			}
			td.style.height=tdHeight;
			if(adjTr)
			{
				td.parentNode.style.height=tdHeight;
				
				if (grid.UseFixedHeaders && td.parentNode.parentNode.tagName=="TR")
				{					
					td.parentNode.parentNode.style.height=td.style.height;
				}
			}
			if(grid._scrElem)
				grid._scrElem.parentNode.parentNode.style.height=tdHeight;
		}
		grid._windowHeight=window.innerHeight;
	}
}

var igtbl_oldOnBodyResize=null;
function igtbl_onBodyResize()
{
	var result;
	if(igtbl_oldOnBodyResize)
		result=igtbl_oldOnBodyResize();
	for(var gridId in igtbl_gridState)
	{
		var grid=igtbl_getGridById(gridId);
		igtbl_adjustNNHeight(grid);
	}
	return result;
}

function igtbl_parseInt(inValue)
{
	var outValue=parseInt(inValue,10);
	if(isNaN(outValue))
		outValue=0;
	return outValue;
}

function _igtbl_getMoreRows(gn)
{
	var g = igtbl_getGridById(gn);
	if (g)
	{
		g.invokeXmlHttpRequest(g.eReqType.MoreRows);
	}
}	

function igtbl_getBodyScrollLeft()
{
	var isXHTML=document.compatMode=="CSS1Compat";
	if(isXHTML)
		return document.body.parentNode.scrollLeft;
	else
		return document.body.scrollLeft;
}

function igtbl_getBodyScrollTop()
{
	if(igtbl_isXHTML)
		return document.body.parentNode.scrollTop;
	else
		return document.body.scrollTop;
}

function igtbl_onPagerClick(gn,evnt)
{
	var g=igtbl_getGridById(gn);
	if(!g || !evnt) return;
	if(!g.GridIsLoaded)
		return ig_cancelEvent(evnt);
}

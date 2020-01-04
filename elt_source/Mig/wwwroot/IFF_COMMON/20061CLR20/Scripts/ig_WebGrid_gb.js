 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid_gb.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// ig_WebGrid_gb.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
var igtbl_documentMouseMove=null;
var igtbl_documentMouseUp=null;

function igtbl_dragDropMouseMove(evnt)
{
	if(!evnt)
		evnt=event;
	var gs=igtbl_getGridById(igtbl_lastActiveGrid);
	if(!gs && igtbl_documentMouseMove || igtbl_button(igtbl_lastActiveGrid,evnt)!=0)
	{
		igtbl_headerDragDrop();
		return;
	}
	if(!gs)
		return;
	gs.event=evnt;
	if(gs.dragDropDiv && gs.dragDropDiv.style.display=="")
	{
		var col=gs.dragDropDiv.srcElement;
		var bandNo=parseInt(igtbl_bandNoFromColId(col.id),10);
		var band=gs.Bands[bandNo];
		var colNo=parseInt(igtbl_colNoFromColId(col.id),10);
		var x=evnt.clientX+igtbl_getBodyScrollLeft();
		var y=evnt.clientY+igtbl_getBodyScrollTop();
		gs.dragDropDiv.style.left=x-gs.dragDropDiv.offsetWidth/2;
		gs.dragDropDiv.style.top=y-gs.dragDropDiv.offsetHeight/2;
		var gb=gs.GroupByBox;
		var gbx;
		var gby;
		if(gb.Element)
		{
			gbx=igtbl_getLeftPos(gb.Element,false);
			gby=igtbl_getTopPos(gb.Element,false);
		}
		if(gb.Element && x>=gbx && x<gbx+gb.Element.offsetWidth && y>=gby && y<gby+gb.Element.offsetHeight && band.Columns[colNo].AllowGroupBy==1)
		{
			if(gb.groups.length==0)
			{
				gb.pimgUp.style.display="";
				gb.pimgUp.style.left=gbx-gb.pimgUp.offsetWidth/2;
				gb.pimgUp.style.top=gby+gb.Element.offsetHeight;
				gb.pimgDn.style.display="";
				gb.pimgDn.style.left=gbx-gb.pimgDn.offsetWidth/2;
				gb.pimgDn.style.top=gby-gb.pimgDn.offsetHeight;
				gb.postString="group:"+bandNo+":"+colNo+":true:band:"+bandNo;
			}
			else
			{
				var el=null;
				var frontPark=false;
				var grNo=0;
				for(var i=0;i<gb.groups.length;i++)
				{
					var ge=gb.groups[i].Element;
					var gex=igtbl_getLeftPos(ge,false);
					var gey=igtbl_getTopPos(ge,false);
					var eBandNo=gb.groups[i].groupInfo[1];
					if(eBandNo<bandNo)
					{
						el=gb.groups[i];
						grNo=i;
						frontPark=false;
					}
					else if(eBandNo==bandNo)
					{
						if(!(el && x<gex))
						{
							el=gb.groups[i];
							grNo=i;
							if(el.groupInfo[0]=='band' || x<gex+ge.offsetWidth/2)
								frontPark=true;
							else
								frontPark=false;
							if(x>=gex && x<gex+ge.offsetWidth)
								break;
						}
					}
					else if(!el)
					{
						el=gb.groups[i];
						grNo=i;
						frontPark=true;
					}
				}
				if(el && (((el.groupInfo[0]=="col" && !(el.groupInfo[1]==bandNo && el.groupInfo[2]==colNo) || el.groupInfo[0]=="band") && (frontPark && (grNo==0 || gb.groups[grNo-1].groupInfo[0]=="band" || !(gb.groups[grNo-1].groupInfo[1]==bandNo && gb.groups[grNo-1].groupInfo[2]==colNo)) || !frontPark && (grNo>=gb.groups.length-1 || gb.groups[grNo+1].groupInfo[0]=="band" || !(gb.groups[grNo+1].groupInfo[1]==bandNo && gb.groups[grNo+1].groupInfo[2]==colNo))))))
				{
					var gex=igtbl_getLeftPos(el.Element,false);
					var gey=igtbl_getTopPos(el.Element,false);
					gb.pimgUp.style.display="";
					gb.pimgUp.style.left=gex-gb.pimgUp.offsetWidth/2+(frontPark?0:el.Element.offsetWidth);
					gb.pimgUp.style.top=gey+el.Element.offsetHeight;
					gb.pimgDn.style.display="";
					gb.pimgDn.style.left=gex-gb.pimgDn.offsetWidth/2+(frontPark?0:el.Element.offsetWidth);
					gb.pimgDn.style.top=gey-gb.pimgDn.offsetHeight;
					gb.postString="group:"+bandNo+":"+colNo+":"+frontPark+":"+el.groupInfo[0]+":"+el.groupInfo[1]+(el.groupInfo[0]=="col"?":"+el.groupInfo[2]:"");
				}
				else
				{
					gb.postString="";
					gb.moveString="";
					gb.pimgUp.style.display="none";
					gb.pimgDn.style.display="none";
				}
			}
		}
		else
		{
			var defaultInit=true;
			if(band.AllowColumnMoving>1 && !band.HasHeaderLayout && !band.HasFooterLayout)
			{
				var gdiv;
				if(bandNo==0)
				{
					if((gs.StationaryMargins==1 || gs.StationaryMargins==3) && gs.StatHeader)
						gdiv=gs.StatHeader.Element.parentNode.parentNode;
					else
						gdiv=gs.Element.parentNode;
				}
				else
					gdiv=col.parentNode;
				var gx=igtbl_getLeftPos(gdiv);
				var gy=igtbl_getTopPos(gdiv);
				var colEl=igtbl_overHeader(gs.Rows,x,y,gx,gy,gdiv.offsetWidth,gdiv.offsetHeight);
				if(colEl)
				{
					var tBandNo=parseInt(igtbl_bandNoFromColId(colEl.id),10);
					var tColNo=parseInt(igtbl_colNoFromColId(colEl.id),10);
					if(tBandNo==bandNo && tColNo!=colNo)
					{
						var cx=igtbl_getLeftPos(colEl,false);
						var cy=igtbl_getTopPos(colEl,false);
						var ow=colEl.offsetWidth;
						if(cx+ow>gx+gdiv.offsetWidth)
							ow=gx+gdiv.offsetWidth-cx;
						var frontPark=false;
						if(x<cx+ow/2)
							frontPark=true;
						var beforeColId=colEl.id;
						var col=gs.Bands[tBandNo].Columns[tColNo];
						var mCol=band.Columns[colNo];
						var beforeCol=gs.Bands[tBandNo].Columns[tColNo+1];
						if(!frontPark && beforeCol)
							beforeColId=beforeCol.Id;
						else if(!frontPark)
							beforeColId=null;
						var allowMove=false;
						if(!gs.UseFixedHeaders || (frontPark && (mCol.Fixed && (col.Fixed || tColNo>0 && tColNo-1!=colNo && gs.Bands[tBandNo].Columns[tColNo-1].Fixed) || !mCol.Fixed && !col.Fixed) || !frontPark && (mCol.Fixed && col.Fixed || !mCol.Fixed && (!beforeCol || mCol!=beforeCol && !beforeCol.Fixed))))
							allowMove=true;
						if(allowMove && (frontPark && (!colEl.previousSibling || !colEl.previousSibling.id || parseInt(igtbl_colNoFromColId(colEl.previousSibling.id),10)!=colNo) ||
								!frontPark && (!colEl.nextSibling || !colEl.nextSibling.id || parseInt(igtbl_colNoFromColId(colEl.nextSibling.id),10)!=colNo)))
							if(igtbl_fireEvent(gs.Id,gs.Events.ColumnDrag,"(\""+gs.Id+"\",\""+colEl.id+"\","+(beforeColId?"\""+beforeColId+"\"":null)+")")!=true)
							{
								gb.pimgUp.style.display="";
								gb.pimgUp.style.left=cx-gb.pimgUp.offsetWidth/2+(frontPark?0:ow);
								gb.pimgUp.style.top=cy+colEl.offsetHeight;
								gb.pimgDn.style.display="";
								gb.pimgDn.style.left=cx-gb.pimgDn.offsetWidth/2+(frontPark?0:ow);
								gb.pimgDn.style.top=cy-gb.pimgDn.offsetHeight;
								if(col && col.getAttribute && col.getAttribute("groupInfo"))
									gb.postString="ungroup:"+bandNo+":"+colNo;
								gb.moveString="move:"+bandNo+":"+colNo+":"+frontPark+":"+tBandNo+":"+tColNo;
								defaultInit=false;
							}
					}
				}
			}
			if(defaultInit)
			{
				if(col && col.getAttribute && col.getAttribute("groupInfo"))
					gb.postString="ungroup:"+bandNo+":"+colNo;
				else
					gb.postString="";
				gb.moveString="";
				gb.pimgUp.style.display="none";
				gb.pimgDn.style.display="none";
			}
		}
	}
	igtbl_cancelEvent(evnt);
	return true;
}

function igtbl_overHeader(rows,x,y,gx,gy,gw,gh)
{
	var g=rows.Grid;
	var useExp=0;
	while(rows)
	{
		
		
		var firstRow = rows.length>0 ? rows.getRow(0) : null;
		
			
		if(!firstRow 		
			|| (firstRow && !firstRow.GroupByRow)
					
			|| (rows.Band.Index==0 && rows.Grid.StatHeader)
		)
		{
			var colsCount;
			if(firstRow && !firstRow.GroupByRow)
				colsCount=firstRow.cells.length;
			else
				colsCount=rows.Band.Columns.length;
			for(var i=0;i<colsCount;i++)
			{
				if(!rows.Band.Columns[i].getVisible())
					continue;
				var colEl;
				if(firstRow && !firstRow.GroupByRow)
				{
					var cell=firstRow.getCell(i);
					colEl=igtbl_getColumnByCellId(cell.Element.id);
				}
				else
					colEl=rows.Band.Columns[i].Element;
				if(colEl)
				{
					var cy=igtbl_getTopPos(colEl);
					if(y>gy+gh)
						return false;
					var cx=igtbl_getLeftPos(colEl);
					var cx1=cx+colEl.offsetWidth;
					var cy1=cy+colEl.offsetHeight;
					if(cx<gx) cx=gx;
					if(cy<gy) cy=gy;
					if(cx1>gx+gw) cx1=gx+gw;
					if(cy1>gy+gh) cy1=gy+gh;
					if(!(y>cy && y<cy1))
						break;
					if(x>=cx && x<cx1)
						return colEl;
				}
			}
		}
		rows=null;
		var i=0;
		for(var rowId in g.ExpandedRows)
		{
			if(i==useExp)
			{
				var row=igtbl_getRowById(rowId);
				rows=row.Rows;
				useExp++;
				break;
			}
			i++;
		}
	}
}

function igtbl_headerDragStart(gn,se,evnt)
{
	var gs=igtbl_getGridById(gn);
	if(!gs) return;
	var column=igtbl_getColumnById(se.id);
	if(!column) return;
	if(!column.IsGroupBy)
	{
		var j=0;
		for(var i=0;i<column.Band.Columns.length;i++)
		{
			var col=column.Band.Columns[i];
			if(col.hasCells() && col.getVisible())
				j++;
		}
		if(j<=1)
			return;
	}
	if(igtbl_fireEvent(gs.Id,gs.Events.BeforeColumnMove,"(\""+gs.Id+"\",\""+se.id+"\")")==true)
		return;
	if(!gs.dragDropDiv)
	{
		gs.dragDropDiv=document.createElement("DIV");
		gs.dragDropDiv.style.display="none";
		document.body.insertBefore(gs.dragDropDiv,document.body.firstChild);
		var gb=gs.GroupByBox;
		if(gb && gb.pimgUp.parentNode!=document.body)
		{
			gb.pimgUp.parentNode.removeChild(gb.pimgUp);
			document.body.insertBefore(gb.pimgUp,document.body.firstChild);
			gb.pimgDn.parentNode.removeChild(gb.pimgDn);
			document.body.insertBefore(gb.pimgDn,document.body.firstChild);
		}
	}
	gs.dragDropDiv.className=se.className;
	gs.dragDropDiv.style.cssText=se.style.cssText;
	gs.dragDropDiv.style.position="absolute";
	gs.dragDropDiv.style.display="";
	gs.dragDropDiv.style.left=evnt.clientX+igtbl_getBodyScrollLeft()-se.offsetWidth/2;
	gs.dragDropDiv.style.top=evnt.clientY+igtbl_getBodyScrollTop()-se.offsetHeight/2;
	gs.dragDropDiv.style.width=se.offsetWidth;
	gs.dragDropDiv.style.height=se.offsetHeight;
	gs.dragDropDiv.style.zIndex=10000;
	gs.dragDropDiv.innerHTML=se.innerHTML;
	gs.dragDropDiv.srcElement=se;
	igtbl_documentMouseMove=igtbl_addEventListener(document,"mousemove",igtbl_dragDropMouseMove);
	igtbl_documentMouseUp=igtbl_addEventListener(document,"mouseup",igtbl_headerDragDrop);
}

function igtbl_headerDragDrop()
{
	var gs=igtbl_getGridById(igtbl_lastActiveGrid);
	if(!gs || !gs.dragDropDiv)
		return;
	gs.dragDropDiv.style.display="none";
	igtbl_removeEventListener(document,"mousemove",igtbl_dragDropMouseMove,igtbl_documentMouseMove);
	igtbl_removeEventListener(document,"mouseup",igtbl_headerDragDrop,igtbl_documentMouseUp);
	igtbl_documentMouseUp=null;
	igtbl_documentMouseMove=null;
	gs.GroupByBox.pimgUp.style.display="none";
	gs.GroupByBox.pimgDn.style.display="none";
	var col=gs.dragDropDiv.srcElement;
		
	var bandNo=parseInt(igtbl_bandNoFromColId(col.id),10);
	var band=gs.Bands[bandNo];		
	var xmlClientSideMoving = (gs.Node && band.AllowColumnMoving==3);
	if(gs.GroupByBox.moveString!="" && !xmlClientSideMoving)
		igtbl_fireEvent(gs.Id,gs.Events.AfterColumnMove,"(\""+gs.Id+"\",\""+col.id+"\")");
	if(gs.Node && band.AllowColumnMoving==3 && gs.GroupByBox.moveString!="" && gs.GroupByBox.postString=="")
	{
		var moveAr=gs.GroupByBox.moveString.split(":");
		var fromIndex=parseInt(moveAr[2],10),toIndex=parseInt(moveAr[5],10)+(moveAr[3]=="true"?0:1);
		if(fromIndex<toIndex)
			toIndex--;
		if(bandNo==0 && !band.IsGrouped)
		{
			var arIndex=-1,acColumn=null,acrIndex=-1;
			if(gs.oActiveRow && gs.oActiveRow.OwnerCollection==gs.Rows)
				arIndex=gs.oActiveRow.getIndex();
			if(gs.oActiveCell && gs.oActiveCell.Row.OwnerCollection==gs.Rows)
			{
				acColumn=gs.oActiveCell.Column;
				acrIndex=gs.oActiveCell.Row.getIndex();
			}
			gs.setActiveRow(null);
			gs.setActiveCell(null);
			band.Columns[fromIndex].move(toIndex);
			gs.Rows.repaint();
			if(arIndex!=-1)
				gs.Rows.getRow(arIndex).activate();
			
			if(acColumn && acrIndex>=0)
				gs.Rows.getRow(acrIndex).getCellByColumn(acColumn).activate();
		}
		else
		{
			var elem=igtbl_getDocumentElement(col.id);
			var rAr=new Array();
			if(!elem.length)
				elem=[elem];
			for(var i=0;i<elem.length;i++)
			{
				var pe=elem[i].parentNode.parentNode.parentNode.parentNode;
				if(pe.tagName=="DIV" && pe.id.substr(pe.id.length-4)=="_drs")
					pe=pe.parentNode.parentNode.parentNode.parentNode.parentNode;
				var ps=pe.parentNode.previousSibling;
				if(ps)
					rAr[i]=igtbl_getRowById(ps.id);
			}
			var arIndex=-1,acColumn=null,acrIndex=-1,aRows=null;
			if(gs.oActiveRow)
			{
				arIndex=gs.oActiveRow.getIndex();
				aRows=gs.oActiveRow.OwnerCollection;
				if(aRows.Band.Index>=bandNo)
					gs.setActiveRow(null);
			}
			if(gs.oActiveCell)
			{
				acColumn=gs.oActiveCell.Column;
				acrIndex=gs.oActiveCell.Row.getIndex();
				aRows=gs.oActiveCell.Row.OwnerCollection;
				if(aRows.Band.Index>=bandNo)
					gs.setActiveCell(null);
			}
			band.Columns[fromIndex].move(toIndex);
			for(var i=0;i<rAr.length;i++)
			{
				if(rAr[i])
				{
					rAr[i].Rows.repaint();
					if(aRows==rAr[i].Rows)
					{
						if(arIndex!=-1)
							aRows.getRow(arIndex).activate();
						if(acColumn)
							aRows.getRow(acrIndex).getCellByColumn(acColumn).activate();
						aRows=null;
					}
					rAr[i]=null;
				}
			}
			igtbl_dispose(rAr);
			delete rAr;
		}
			
		if(gs.GroupByBox.moveString!="" && xmlClientSideMoving)
			igtbl_fireEvent(gs.Id,gs.Events.AfterColumnMove,"(\""+gs.Id+"\",\""+col.id+"\")");
	}
	else
	{
		if(gs.GroupByBox.postString!="" || gs.GroupByBox.moveString!="")
		{
			var c=igtbl_getColumnById(col.id);
			if(gs.GroupByBox.postString)
				gs._recordChange("ColumnGroup",c,gs.GroupByBox.postString);
			else
				gs._recordChange("ColumnMove",c,gs.GroupByBox.moveString);
			igtbl_doPostBack(igtbl_lastActiveGrid,"");
		}
	}
	gs.GroupByBox.postString="";
	gs.GroupByBox.moveString="";
}

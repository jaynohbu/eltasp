 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid_dom.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// ig_WebGrid_dom.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
var igtbl_reqType=new Object();
igtbl_reqType.None=0;
igtbl_reqType.ChildRows=1;
igtbl_reqType.MoreRows=2;
igtbl_reqType.Sort=3;
igtbl_reqType.UpdateCell=4;
igtbl_reqType.AddNewRow=5;
igtbl_reqType.DeleteRow=6;
igtbl_reqType.UpdateRow=7;
igtbl_reqType.Custom=8;
igtbl_reqType.Page=9;
igtbl_reqType.Scroll=10;
var igtbl_readyState=new Object();
igtbl_readyState.Ready=0;
igtbl_readyState.Loading=1;

var igtbl_error=new Object();
igtbl_error.Ok=0;
igtbl_error.LoadFailed=1;

// General object. Where it all starts.
function igtbl_Object(type)
{
	if(arguments.length>0)
		this.init(type);
}
igtbl_Object.prototype.init=function(type)
{
	this.Type=type;
}

// Web object. The one with an HTML element attached.
igtbl_WebObject.prototype=new igtbl_Object();
igtbl_WebObject.prototype.constructor=igtbl_WebObject;
igtbl_WebObject.base=igtbl_Object.prototype;
function igtbl_WebObject(type,element,node)
{
	if(arguments.length>0)
		this.init(type,element,node);
}
igtbl_WebObject.prototype.init=function(type,element,node,viewState)
{
	igtbl_WebObject.base.init.apply(this,[type]);
	if(element)
	{
		this.Id=element.id;
		this.Element=element;
	}
	if(node)
		this.Node=node;
	if(viewState)
		this.ViewState=viewState;
}
igtbl_WebObject.prototype.get=function(name)
{
	if(this.Node)
		return this.Node.getAttribute(name);
	if(this.Element)
		return this.Element.getAttribute(name);
	return null;
}
igtbl_WebObject.prototype.set=function(name,value)
{
	if(this.Node)
		this.Node.setAttribute(name,value);
	else if(this.Element)
		this.Element.setAttribute(name,value);
	if(this.ViewState)
		ig_ClientState.setPropertyValue(this.ViewState,name,value);
}

// Grid object
igtbl_Grid.prototype=new igtbl_WebObject();
igtbl_Grid.prototype.constructor=igtbl_Grid;
igtbl_Grid.base=igtbl_WebObject.prototype;
function igtbl_Grid(element,node)
{
	if(arguments.length>0)
		this.init(element,node);
}
var igtbl_ptsGrid=[
"init",
function(element,node)
{
	igtbl_Grid.base.init.apply(this,["grid",element,node]);
	this.IsXHTML=igtbl_isXHTML;
	if(node)
	{
		this.XmlNS="http://schemas.infragistics.com/WebGrid";
		this.Xml=node;
		this.Node=this.Xml.selectSingleNode("UltraWebGrid/Header/UltraGridLayout");
	}
	this.ViewState=ig_ClientState.addNode(ig_ClientState.createRootNode(),"UltraWebGrid");
	this.ViewState=ig_ClientState.addNode(this.ViewState,"DisplayLayout");
	this.StateChanges=ig_ClientState.addNode(this.ViewState,"StateChanges");

	this.Id=this.Id.substr(2);

// Initialize properties

	this._Changes=new Array();
	
	this.SelectedRows=new Object();
	this.SelectedColumns=new Object();
	this.SelectedCells=new Object();
	this.SelectedCellsRows=new Object();
	this.ExpandedRows=new Object();
	this.CollapsedRows=new Object();
	this.ResizedColumns=new Object();
	this.ResizedRows=new Object();
	this.ChangedRows=new Object();
	this.ChangedCells=new Object();
	this.AddedRows=new Object();
	this.DeletedRows=new Object();
//** OBSOLETE ***
	this.ActiveCell="";
	this.ActiveRow="";
	this.grid=this;
	this.activeRect=null;
	this.SuspendUpdates=false;
//** END OBSOLETE ***
	
	this._lastSelectedRow="";
	this.ScrollPos=0;
	this.currentTriImg=null;
	this.newImg=null;
	
	this.NeedPostBack=false;
	this.CancelPostBack=false;
	this.GridIsLoaded=false;
	
	this._exitEditCancel=false;
	this._noCellChange=false;
	this._insideSetActive=false;
	this.CaseSensitiveSort=false;

	var defaultProps=new Array("AddNewBoxVisible","AddNewBoxView","AllowAddNew","AllowColSizing","AllowDelete","AllowSort",
					"ItemClass","AltClass","AllowUpdate","CellClickAction","EditCellClass","Expandable","FooterClass",
					"GroupByRowClass","GroupCount","HeaderClass","HeaderClickAction","Indentation","NullText",
					"ExpAreaClass","RowLabelClass","SelGroupByRowClass","SelHeadClass","SelCellClass","RowSizing",
					"SelectTypeCell","SelectTypeColumn","SelectTypeRow","ShowBandLabels","ViewType","AllowPaging",
					"PageCount","CurrentPageIndex","PageSize","CollapseImage","ExpandImage","CurrentRowImage",
					"CurrentEditRowImage","NewRowImage","BlankImage","SortAscImg","SortDscImg","Activation",
					"cultureInfo","RowSelectors","UniqueID","StationaryMargins","LoadOnDemand","RowLabelBlankImage",
					"EIRM","TabDirection","ClientID","DefaultCentury","UseFixedHeaders","FixedHeaderIndicator",
					"FixedHeaderOnImage","FixedHeaderOffImage","FixedColumnScrollType","TableLayout","AllowRowNumbering",
					"ClientSideRenumbering"
					,"XmlLoadOnDemandType"
					);
	this.Bands=new Array();
	var props;
	try{props=eval("igtbl_"+this.Id+"_GridProps");}catch(e){}
	if(props)
	{
		for(var i=0;i<defaultProps.length;i++)
			this[defaultProps[i]]=props[i];
		this.Activation=new igtbl_initActivation(this.Activation);
		this.Activation._cssClass=this.Id+"-ao";
		this.cultureInfo=this.cultureInfo.split("|");
	}
	if(this.UseFixedHeaders
	|| this.XmlLoadOnDemandType!=0
	)
	{
		this._scrElem=this.Element.parentNode.previousSibling;
		this._tdContainer=this._scrElem.parentNode.parentNode;
	}
	else
		this._tdContainer=this.Element.parentNode.parentNode;
	var xmlProps=eval("igtbl_"+this.Id+"_XmlGridProps");
	this._AddnlProps=xmlProps;
	this.RowsServerLength=xmlProps[0];
	this.RowsRange=xmlProps[1];
	this.RowsRetrieved=xmlProps[2];
	if(!node)
	{
		var bandsArray=eval("igtbl_"+this.Id+"_Bands");
		var bandCount=bandsArray.length;
		for(var i=0;i<bandCount;i++) 
			this.Bands[i]=new igtbl_Band(this,null,i);
	}
	else
	{
		this.Bands.Node=this.Node.selectSingleNode("Bands");
		var bandNodes=this.Bands.Node.selectNodes("Band");
		for(var i=0;i<bandNodes.length;i++)
			this.Bands[i]=new igtbl_Band(this,bandNodes[i],i);
	}
	igtbl_dispose(defaultProps);

	igtbl_gridState[this.Id]=this;
	this.Events=new igtbl_Events(this);
	this.Rows=new igtbl_Rows((this.Node?this.Xml.selectSingleNode("UltraWebGrid/Body/Rs"):null),this.Bands[0],null);
	
	
	
	if (this.Bands && !this.Bands[0].IsGrouped && this.StationaryMargins!=1 && this.StationaryMargins!=3)
	{
		
		

		var columnHeaders = this.Rows.Element.previousSibling.childNodes[0].childNodes;

		var bandZero = this.Bands[0];
		var i=0;
		while(i<columnHeaders.length)
		{
			var col=columnHeaders[i];
			i++;
			if(col.getAttribute("columnNo"))
			{
				var colNo=parseInt(col.getAttribute("columnNo"));
				bandZero.Columns[colNo].Element=col;
			}
			else if(col.colSpan>1 && col.firstChild.tagName=="DIV" && col.firstChild.id.substr(col.firstChild.id.length-4)=="_drs")
			{
				columnHeaders=col.firstChild.firstChild.childNodes[1].rows[0].childNodes;
				i=0;
			}
		}
	}
	this.regExp=null;
	this.backwardSearch=false;
	this.lastSearchedCell=null;
    this.lastSortedColumn="";
    if(this.AllowRowNumbering==2)this.CurrentRowNumber=0;
	this.GroupByBox=new igtbl_initGroupByBox(this);
	this.MainGrid=igtbl_getElementById(this.Id+"_main");
	this.DivElement=igtbl_getElementById(this.Id+"_div");
	this.eReqType=igtbl_reqType;
	this.eReadyState=igtbl_readyState;
	this.eError=igtbl_error;
	if(this.Node || !ig_csom.IsIE && this.LoadOnDemand==3)
	{		
		this.ReqType=this.eReqType.None;
		this.ReadyState=this.eReadyState.Ready;
		this.Error=this.eError.Ok;

		this._innerObj=document.createElement("div");

		
    	

		this.QueryString="";
		if(ig_csom.IsIE)
		{
			this.Url=document.URLUnencoded;
			this.Xslt=new ActiveXObject("Msxml2.FreeThreadedDOMDocument");
			this.Xslt.async=false;
			this.Xslt.load(this._AddnlProps[11]);
			
    		
			    this.XmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
			this.XmlResp=new ActiveXObject("Microsoft.XMLDOM");
			this.XslTemplate=new ActiveXObject("Msxml2.XSLTemplate");
			this.XslTemplate.stylesheet=this.Xslt;
			this.XslProcessor=this.XslTemplate.createProcessor();
		}
		else
		{
			this.Url=document.URL;
			this.Xslt=new XSLTProcessor();
			this.XmlHttp=new XMLHttpRequest();
			this.XmlResp=new DOMParser();
			this.XmlHttp.open("GET",this._AddnlProps[11],false);
			this.XmlHttp.send(null);
			this.Xslt.importStylesheet(this.XmlResp.parseFromString(this.XmlHttp.responseText,"text/xml"));
		}

		if(node)
			this.Rows.render();
	}
		if(this.Bands[0].ColHeadersVisible!=2 && (this.StationaryMargins==1 || this.StationaryMargins==3)
			&& igtbl_getElementById(this.Id+"_hdiv")
		)
			this.StatHeader=new igtbl_initStatHeader(this);
		if(this.Bands[0].ColFootersVisible==1 && (this.StationaryMargins==2 || this.StationaryMargins==3)
			&& igtbl_getElementById(this.Id+"_fdiv")
		)
			this.StatFooter=new igtbl_initStatFooter(this);
	this._calculateStationaryHeader();
	this.VirtualScrollDelay=500;
	if(this.XmlLoadOnDemandType==3)
		window.setTimeout("_igtbl_getMoreRows('"+this.Id+"');",100);
		
	var thisForm=this.Element.parentNode;
	while(thisForm && thisForm.tagName!="FORM")
		thisForm=thisForm.parentNode;
	if(thisForm)
	{
		this._thisForm=thisForm;
		if(thisForm.igtblGrid)
			this.oldIgtblGrid=thisForm.igtblGrid;
		else
		{
			if(thisForm.addEventListener)
				thisForm.addEventListener('submit',igtbl_submit,false);
			else if(thisForm.onsubmit!=igtbl_submit)
			{
				thisForm.igtbl_oldOnSubmit=thisForm.onsubmit;
				thisForm.onsubmit=igtbl_submit;
			}
			if(thisForm.submit!=igtbl_formSubmit)
			{
				thisForm.oldSubmit=thisForm.submit;
				thisForm.submit=igtbl_formSubmit;
			}
			window.__doPostBackOld=window.__doPostBack;
			window.__doPostBack=igtbl_submit;
			window.__thisForm=thisForm;
		}
		thisForm.igtblGrid=this;
	}
},
"sortColumn",
function(colId,shiftKey)
{
	var bandNo=igtbl_bandNoFromColId(colId);
	var band=this.Bands[bandNo];
	var colNo=igtbl_colNoFromColId(colId);
	if(band.Columns[colNo].SortIndicator==3)
		return;
	var headClk=igtbl_getHeaderClickAction(this.Id,bandNo,colNo);
	if(headClk==2 || headClk==3)
	{
		var gs=igtbl_getGridById(this.Id);
		if(!band.ClientSortEnabled)
			gs.NeedPostBack=true;
		var eventCanceled=igtbl_fireEvent(this.Id,this.Events.BeforeSortColumn,"(\""+this.Id+"\",\""+colId+"\")");
		if(eventCanceled && band.ClientSortEnabled)
			return;
		if(!eventCanceled)
			this.addSortColumn(colId,(headClk==2 || !shiftKey));
		else
			gs.NeedPostBack=false;
		if(!eventCanceled && band.ClientSortEnabled)
		{
			var el=igtbl_getDocumentElement(colId);
			if(!el.length && el.tagName!="TH")
				igtbl_sortGroupedRows(this.Rows,bandNo,colId);
			else
			{
				if(!el.length)
				{
					el=new Array();
					el[0]=igtbl_getElementById(colId);
				}
				for(var i=0;i<el.length;i++)
				{
					var rows=el[i].parentNode;
					
					while(rows && (rows.tagName!="TABLE" || (rows.tagName=="TABLE" && rows.id=="") ) ) rows=rows.parentNode;
					
					if(rows && rows.tBodies[0]) rows=rows.tBodies[0];
					if(!rows || !rows.Object) continue;
					rows.Object.sort();
				}
			}
			gs._recalcRowNumbers();
			igtbl_hideEdit(this.Id);
			igtbl_fireEvent(this.Id,this.Events.AfterSortColumn,"(\""+this.Id+"\",\""+colId+"\")");
		}
	}
},
"addSortColumn",
function(colId,clear)
{
	var colAr=colId.split(";");
	if(colAr.length>1)
	{
		for(var i=0;i<colAr.length;i++)
			if(colAr[i]!="")
			{
				var band=this.Bands[igtbl_bandNoFromColId(colAr[i])];
				band.SortedColumns[band.SortedColumns.length]=colAr[i];
				var colObj = igtbl_getColumnById(colAr[i]);				
				var colNo=igtbl_colNoFromColId(colAr[i]);				
				var bandNo=band.Index;
				if (colObj.IsGroupBy)
				{
					var postString="group:"+bandNo+":"+colNo+":false:band:"+bandNo;			
					this._recordChange("ColumnGroup",band.Columns[colNo],postString);
				}
				else			
					this._recordChange("SortedColumns",band.Columns[colNo],"false"+":"+band.Columns[colNo].SortIndicator);
			}
	}
	else
	{
		var band=this.Bands[igtbl_bandNoFromColId(colId)];
		var colNo=igtbl_colNoFromColId(colId);
		if(band.Columns[colNo].SortIndicator==3)
			return;
		if(clear)
		{
			var scLen=band.SortedColumns.length;
			for(var i=scLen-1;i>=0;i--)
			{
				var cn=igtbl_colNoFromColId(band.SortedColumns[i]);
				if(cn!=colNo && band.Columns[cn].SortIndicator!=3 && !band.Columns[cn].IsGroupBy)
				{
					band.Columns[cn].SortIndicator=0;
					if(band.ClientSortEnabled)
					{
						var colEl=igtbl_getDocumentElement(band.SortedColumns[i]);
						if(!colEl.length)
							colEl=[colEl];
						for(var j=0;j<colEl.length;j++)
						{
							var img=null;
							var el=colEl[j];
							if(el.firstChild && el.firstChild.tagName=="NOBR")
								el=el.firstChild;
												
							
					
							if (el.childNodes.length)
							{
								for (var imgNodeIndex=0;imgNodeIndex<el.childNodes.length;imgNodeIndex++)
								{
									if (el.childNodes[imgNodeIndex].tagName=="IMG" && el.childNodes[imgNodeIndex].getAttribute("imgType")=="sort")
										img=el.childNodes[imgNodeIndex];
								}
							}								
							if(img)
								el.removeChild(img);
						}
					}
				}
				if(band.Columns[cn].IsGroupBy)
					break;
				band.SortedColumns=band.SortedColumns.slice(0,-1);
				
			}
		}
		if(band.Columns[colNo].SortIndicator==1)
			band.Columns[colNo].SortIndicator=2;
		else
			band.Columns[colNo].SortIndicator=1;
		this._recordChange("SortedColumns",band.Columns[colNo],clear.toString()+":"+band.Columns[colNo].SortIndicator);
		band.Grid.lastSortedColumn=colId;
		if(band.ClientSortEnabled)
		{
			var colEl=igtbl_getDocumentElement(colId);
			if(!colEl.length)
				colEl=[colEl];
			for(var i=0;i<colEl.length;i++)
			{
				var img=null;
				var el=colEl[i];
				if(el.firstChild && el.firstChild.tagName=="NOBR")
					el=el.firstChild;				
				
				
				if (el.childNodes.length)
				{
					for (var imgNodeIndex=0 ; imgNodeIndex<el.childNodes.length ;imgNodeIndex++)
					{
						if (el.childNodes[imgNodeIndex].tagName=="IMG" && el.childNodes[imgNodeIndex].getAttribute("imgType")=="sort")
							img=el.childNodes[imgNodeIndex];
					}
				}
				
				if (img===null)
				{
					img=document.createElement("img");
					img.border="0";
					img.setAttribute("imgType","sort");
					el.appendChild(img);
				}
				if(band.Columns[colNo].SortIndicator==1)
					img.src=this.SortAscImg;
				else
					img.src=this.SortDscImg;
			}
		}
		if(!band.Columns[colNo].IsGroupBy)
		{
			for(var i=0;i<band.SortedColumns.length;i++)
				if(band.SortedColumns[i]==colId)
					break;
			if(i==band.SortedColumns.length)
			{
				band.Columns[colNo].ensureWebCombo();
				band.SortedColumns[band.SortedColumns.length]=colId;
			}
		}
	}
},
"getActiveCell",
function()
{
	return this.oActiveCell;
},
"setActiveCell",
function(cell,force)
{
	if(!this.Activation.AllowActivation || this._insideSetActive)
		return;
	if(!cell || !cell.Element || cell.Element.tagName!="TD")
		cell=null;
	if(!force && (cell && this.oActiveCell==cell || this._exitEditCancel))
	{
		this._noCellChange=true;
		return;
	}
	if(!cell)
	{
		this.ActiveCell="";
		this.ActiveRow="";
		var row=this.oActiveRow;
		cell=this.oActiveCell;
		if(cell)
			row=cell.Row;
		if(row)
			row.setSelectedRowImg(true);
		if(cell)
			cell.renderActive(false);
		if(this.oActiveRow)
			this.oActiveRow.renderActive(false);
		this.oActiveCell=null;
		this.oActiveRow=null;
		if(cell)
			this._removeChange("ActiveCell",cell);
		if(row)
			this._removeChange("ActiveRow",row);
		if(this.AddNewBoxVisible)
			this.updateAddNewBox();
		return;
	}
	var change=true;
	var oldACell=this.oActiveCell;
	var oldARow=this.oActiveRow;
	if(!oldARow && oldACell)
		oldARow=oldACell.Row;
	this.endEdit();
	
	if(this._exitEditCancel || this.fireEvent(this.Events.BeforeCellChange,[this.Id,cell.Element.id])==true)
		change=false;
	if(change && cell.Row!=oldARow)
	{
		if(oldARow)
		{
			if(oldARow.IsAddNewRow)
				oldARow.commit();
			else
				oldARow.processUpdateRow();
		}
		if(this._exitEditCancel || this.fireEvent(this.Events.BeforeRowActivate,[this.Id,cell.Row.Element.id])==true)
			change=false;
	}
	if(!change)
	{
		this._noCellChange=true;
		return;
	}
	this._noCellChange=false;
	if(this.oActiveCell)
		this.oActiveCell.renderActive(false);
	if(this.oActiveRow)
		this.oActiveRow.renderActive(false);
	this.oActiveCell=cell;
	this.ActiveCell=cell.Element.id;
	if(this.oActiveRow)
		this._removeChange("ActiveRow",this.oActiveRow);
	this.oActiveRow=null;
	this.ActiveRow="";
	this.oActiveCell.renderActive();
	if(this.oActiveCell.Row!=oldARow)
		this.setNewRowImg(null);
	this.oActiveCell.Row.setSelectedRowImg();
	this.colButtonMouseOut();
	if(this.AddNewBoxVisible)
		this.updateAddNewBox();
	
	
	igtbl_activate(this.Id);
	this._removeChange("ActiveCell",oldACell);
	this._recordChange("ActiveCell",this.oActiveCell);	
	this.fireEvent(this.Events.CellChange,[this.Id,this.oActiveCell.Element.id]);
	if(this.oActiveCell.Row!=oldARow)
		this.fireEvent(this.Events.AfterRowActivate,[this.Id,this.oActiveCell.Row.Element.id]);
},
"getActiveRow",
function()
{
	if(this.oActiveRow!=null)
		return this.oActiveRow;
	if(this.oActiveCell!=null)
		return this.oActiveCell.Row;
	return null;
},
"setActiveRow",
function(row,force,fireEvents)
{
	if(!this.Activation.AllowActivation || this._insideSetActive)
		return;
	if(typeof(fireEvents)=="undefined")
		fireEvents=true;
	if(!row || !row.Element || row.Element.tagName!="TR")
		row=null;
	if(!force && (row && this.oActiveRow==row || this._exitEditCancel))
	{
		this._noCellChange=true;
		return;
	}
	if(!row)
	{
		this.ActiveCell="";
		this.ActiveRow="";
		row=this.oActiveRow;
		var cell=this.oActiveCell;
		if(cell)
			row=cell.Row;
		if(row)
			row.setSelectedRowImg(true);
		if(cell)
			cell.renderActive(false);
		if(this.oActiveRow)
			this.oActiveRow.renderActive(false);
		this.oActiveCell=null;
		this.oActiveRow=null;

		if(cell)
			this._removeChange("ActiveCell",cell);
		this._removeChange("ActiveRow",row);

		
		if(this._fromServerActiveRow)
			this._recordChange("ActiveRow",this,-1);

		if(this.AddNewBoxVisible)
			this.updateAddNewBox();
		return;
	}
	var change=true;
	var oldACell=this.oActiveCell;
	var oldARow=this.oActiveRow;
	if(!oldARow && oldACell)
		oldARow=oldACell.Row;
	this.endEdit();

	if(fireEvents && row!=oldARow && oldARow)
	{
		if(oldARow.IsAddNewRow)
			oldARow.commit();
		else
			oldARow.processUpdateRow();
	}
	if(this._exitEditCancel || fireEvents && this.fireEvent(this.Events.BeforeRowActivate,[this.Id,row.Element.id])==true)
		change=false;
	var cellChanged=this.oActiveCell!=null;
	if(change && cellChanged)
		change=!this.fireEvent(this.Events.BeforeCellChange,[this.Id,this.oActiveCell.Element.id]);
	if(!change)
	{
		this._noCellChange=true;
		return;
	}
	this._noCellChange=false;
	if(this.oActiveCell)
		this.oActiveCell.renderActive(false);
	if(this.oActiveRow)
		this.oActiveRow.renderActive(false);
	this.oActiveRow=row;
	this.ActiveRow=row.Element.id;
	if(cellChanged)
		this._removeChange("ActiveCell",this.oActiveCell);
	this.oActiveCell=null;
	this.ActiveCell="";
	this.oActiveRow.renderActive();
	this.oActiveRow.setSelectedRowImg();
	this.colButtonMouseOut();
	if(this.AddNewBoxVisible)
		this.updateAddNewBox();
	
	
	igtbl_activate(this.Id);
	igtbl_activate(this.Id);
	this._removeChange("ActiveRow",oldARow);
	this._recordChange("ActiveRow",this.oActiveRow);	
	if(fireEvents)
	{
		if(cellChanged)
			this.fireEvent(this.Events.CellChange,[this.Id,""]);
		var oldNPB=this.NeedPostBack;
		this.fireEvent(this.Events.AfterRowActivate,[this.Id,row.Element.id]);
		if(!oldNPB && this.NeedPostBack && oldARow==row)
			this.NeedPostBack=false;
	}
},
"deleteSelectedRows",
function()
{
	igtbl_deleteSelRows(this.Id);
	igtbl_activate(this.Id);
	this._recalcRowNumbers();	
},
"unloadGrid",
function()
{
	if(this.Id)
		igtbl_unloadGrid(this.Id);
},
"beginEditTemplate",
function()
{
	var row=this.getActiveRow();
	if(row)
		row.editRow();
},
"endEditTemplate",
function(saveChanges)
{
	var row=this.getActiveRow();
	if(row)
		row.endEditRow(saveChanges);
},
"find",
function(re,back)
{
	var g=this;
	if(re)
		g.regExp=re;
	if(!g.regExp)
		return null;
	g.lastSearchedCell=null;
	if(back==true || back==false)
		g.backwardSearch=back;
	var row=null;
	if(!g.backwardSearch)
	{
		row=g.Rows.getRow(0);
		if(row && row.getHidden())
			row=row.getNextRow();
		while(row && row.find()==null)
			row=row.getNextTabRow(false,true);
	}
	else
	{
		var rows=g.Rows;
		while(rows)
		{
			row=rows.getRow(rows.length-1);
			if(row && row.getHidden())
				row=row.getPrevRow();
			if(row && row.Expandable)
				rows=row.Rows;
			else
			{
				if(!row)
					row=rows.ParentRow;
				rows=null;
			}
		}
		while(row && row.find()==null)
			row=row.getNextTabRow(true,true);
	}
	return g.lastSearchedCell;
},
"findNext",
function(re,back)
{
	var g=this;
	if(!g.lastSearchedCell)
		return this.find(re,back);
	if(re)
		g.regExp=re;
	if(!g.regExp)
		return null;
	if(back==true || back==false)
		g.backwardSearch=back;
	var row=g.lastSearchedCell.Row;
	while(row && row.findNext()==null)
		row=row.getNextTabRow(g.backwardSearch,true);
	return g.lastSearchedCell;
},
"alignStatMargins",
function()
{
	if(this.UseFixedHeaders) return;
	if(this.StatHeader)
		this.StatHeader.ScrollTo(this.getDivElement().scrollLeft);
	if(this.StatFooter)
		this.StatFooter.ScrollTo(this.getDivElement().scrollLeft);
},
"selectCellRegion",
function(startCell,endCell)
{
	var sCol=startCell.Column,eCol=endCell.Column;
	if(sCol.Index>eCol.Index)
	{
		var c=sCol;
		sCol=eCol;
		eCol=c;
	}
	var sRow=startCell.Row,sRowIndex=sRow.getIndex(),eRow=endCell.Row,eRowIndex=eRow.getIndex();
	if(sRowIndex>eRowIndex)
	{
		var c=sRow;
		sRow=eRow;
		eRow=c;
		var i=sRowIndex;
		sRowIndex=eRowIndex;
		eRowIndex=i;
	}
	var pc=sRow.OwnerCollection;
	var band=sCol.Band;
	
	
	var selArray=new Array();
	for(var i=sRowIndex;i<=eRowIndex;i++)
	{
		var row=pc.getRow(i);
		if(!row.getHidden())
			for(var j=sCol.Index;j<=eCol.Index;j++)
			{
				var col=band.Columns[j];
				if(col.getVisible())
				{
					var cell=row.getCellByColumn(col);
					if(cell && cell.Element)
						selArray[selArray.length]=cell.Element.id;
				}
			}
	}
	if(selArray.length>0)
		igtbl_gSelectArray(this.Id,0,selArray);
	delete selArray;
},
"selectRowRegion",
function(startRow,endRow)
{
	var sRowIndex=startRow.getIndex(),eRowIndex=endRow.getIndex();
	if(sRowIndex>eRowIndex)
	{
		var r=startRow;
		startRow=endRow;
		endRow=r;
		var i=sRowIndex;
		sRowIndex=eRowIndex;
		eRowIndex=i;
	}
	
	
	if( (startRow.isFixedTop && startRow.isFixedTop()) || 
		(startRow.isFixedBottom && startRow.isFixedBottom()) || 
		(endRow.isFixedTop && endRow.isFixedTop()) || 
		(endRow.isFixedBottom && endRow.isFixedBottom())
		)return;
	var pc=startRow.OwnerCollection;
	var selArray=new Array();
	for(var i=sRowIndex;i<=eRowIndex;i++)
	{
		var row=pc.getRow(i);
		if(row && !row.getHidden())
			selArray[selArray.length]=row.Element.id;
	}
	if(selArray.length>0)
		igtbl_gSelectArray(this.Id,1,selArray);
	delete selArray;
},
"selectColRegion",
function(startCol,endCol)
{
	if(startCol.Index>endCol.Index)
	{
		var c=startCol;
		startCol=endCol;
		endCol=c;
	}
	var band=startCol.Band;
	var selArray=new Array();
	for(var i=startCol.Index;i<=endCol.Index;i++)
	{
		var col=band.Columns[i];
		if(col.getVisible())
			selArray[selArray.length]=col.Id;
	}
	if(selArray.length>0)
		igtbl_gSelectArray(this.Id,2,selArray);
	delete selArray;
},
"startHourGlass",
function()
{
	if(!igtbl_waitDiv)
	{
		igtbl_waitDiv=document.createElement("div");
		document.body.insertBefore(igtbl_waitDiv,document.body.firstChild);
		igtbl_waitDiv.style.zIndex=10000;
		igtbl_waitDiv.style.position="absolute";
		igtbl_waitDiv.style.left=0;
		igtbl_waitDiv.style.top=0;
		igtbl_waitDiv.style.backgroundColor="transparent";
	}
	igtbl_waitDiv.style.display="";
	igtbl_waitDiv.style.width=document.body.clientWidth;
	igtbl_waitDiv.style.height=document.body.clientHeight;
	igtbl_waitDiv.style.cursor="wait";
	
	if(igtbl_wndOldCursor===null)
		igtbl_wndOldCursor=document.body.style.cursor;
		
	document.body.style.cursor="wait";
},
"stopHourGlass",
function()
{
	if(igtbl_waitDiv)
	{
		igtbl_waitDiv.style.cursor="";
		igtbl_waitDiv.style.display="none";
		document.body.style.cursor=igtbl_wndOldCursor;
		igtbl_wndOldCursor = null;
	}
},
"clearSelectionAll",
function()
{
	igtbl_clearSelectionAll(this.Id);
},
//*** OBSOLETE ***
"alignGrid",
function(){},
"suspendUpdates",
function(suspend)
{
	if(suspend==false)
	{
		this.SuspendUpdates=false;
	}
	else
		this.SuspendUpdates=true;
},
//*** END OBSOLETE ***
"beginEdit",
function()
{
	if(this.oActiveCell)
		this.oActiveCell.beginEdit();
},
"endEdit",
function()
{
	var ec=this._editorCurrent;
	if(ec && ec.getAttribute("noOnBlur"))
		return;
	igtbl_hideEdit(this.Id);
},
"fireEvent",
function(eventObj,args)
{
	if(!this.GridIsLoaded) return;
	var result=false;
	if(eventObj[0]!="")
		result=eval(eventObj[0]).apply(this,args);
	if(this.GridIsLoaded && result!=true && eventObj[1]>0 && !this.CancelPostBack)
		this.NeedPostBack=true;
	this.CancelPostBack=false;
	return result;
},
"setNewRowImg",
function(row)
{
	var gs=this;
	if(row)
		row.setSelectedRowImg(true);
	if(gs.newImg!=null)
	{
		gs._lastSelectedRow=null;
		var imgObj;
		imgObj=document.createElement("img");
		imgObj.src=gs.BlankImage;
		imgObj.border="0";
		imgObj.setAttribute("imgType","blank");
		gs.newImg.parentNode.appendChild(imgObj);
		gs.newImg.parentNode.removeChild(gs.newImg);
		var oRow=igtbl_getRowById(imgObj.parentNode.parentNode.id);
		if(oRow)
			gs._recalcRowNumbers(oRow);
		gs.newImg=null;
	}
	if(!row || row.Band.getRowSelectors()==2 || row.Band.AllowRowNumbering>1)
		return;
	var imgObj;
	imgObj=document.createElement("img");
	imgObj.src=gs.NewRowImage;
	imgObj.border="0";
	imgObj.setAttribute("imgType","newRow");
	var cell=row.Element.cells[row.Band.firstActiveCell-1];
	cell.innerHTML="";
	cell.appendChild(imgObj);
	gs.newImg=imgObj;
},
"colButtonMouseOut",
function()
{
	igtbl_colButtonMouseOut(null,this.Id);
},
"sort",
function()
{
	if(igtbl_sortGrid)
		igtbl_sortGrid.apply(this);
	this._recalcRowNumbers();
},
"updateAddNewBox",
function()
{
	igtbl_updateAddNewBox(this.Id);
},
"update",
function()
{
	var p=igtbl_getElementById(this.Id);
	if(!p) return;
	if(this.Element.parentNode)
	{
		if(this.Element.parentNode.scrollLeft)
			ig_ClientState.setPropertyValue(this.ViewState,"ScrollLeft",this.Element.parentNode.scrollLeft.toString());
		if(this.Element.parentNode.scrollTop)
			ig_ClientState.setPropertyValue(this.ViewState,"ScrollTop",this.Element.parentNode.scrollTop.toString());
	}
	p.value=ig_ClientState.getText(this.ViewState.parentNode);
},
"goToPage",
function(page)
{
	if(!this.GridIsLoaded || !this.AllowPaging || this.CurrentPageIndex==page || page<1 || page>this.PageCount)
		return;
	if(!this.Node && !ig_csom.IsNetscape6 || this.LoadOnDemand!=3)
	{
		this._recordChange("PageChanged",this,page);
		igtbl_doPostBack(this.Id);
	}	
	else
	{
		this._pageToGo=page;
		this.invokeXmlHttpRequest(this.eReqType.Page,this,page);
	}
},
"getRowByLevel",
function(level)
{
	if(typeof(level)=="string")
		level=level.split("_");
	var rows=this.Rows;
	for(var i=0;i<level.length-1;i++)
		rows=rows.getRow(level[i]).Rows;
	return rows.getRow(level[level.length-1]);
},
"xmlHttpRequest",
function(type)
{
	if(type==this.eReqType.Scroll && this._noXmlScroll)
		return;
	if(!this._xmlHttpQueue)
		this._xmlHttpQueue=new Array();
	if(this._xmlHttpQueue.length>0 && this._xmlHttpQueue[this._xmlHttpQueue.length-1].Type==type) 
		return;
	if(this.fireEvent(this.Events.BeforeXmlHttpRequest,[this.Id,type])==true)
		return;
	var xmlHttp=new Object();
	xmlHttp.Type=type;
	xmlHttp.QueryString=this.QueryString;
	xmlHttp.RowToQuery=this.RowToQuery;
	this._xmlHttpQueue[this._xmlHttpQueue.length]=xmlHttp;
	if(type==this.eReqType.Scroll)
	{
		this.getDivElement().setAttribute("noOnScroll","true");
		this._noXmlScroll=true;
		window.setTimeout("igtbl_getGridById('"+this.Id+"')._noXmlScroll=false;",500);
	}
	if(this._xmlHttpQueue.length==1)
		this._serveXmlHttpQueue();
},
"_serveXmlHttpQueue",
function(gn)
{
	var grid=this;
	if(gn)
		grid=igtbl_getGridById(gn);
	if(grid.ReadyState==grid.eReadyState.Ready && grid._xmlHttpQueue.length>0)
	{
		var xmlHttp=grid._xmlHttpQueue[0];
		grid._xmlHttpQueue=grid._xmlHttpQueue.slice(1);
		grid.ReqType=xmlHttp.Type;
		grid.ReadyState=grid.eReadyState.Loading;
		grid._servingXmlHttp=xmlHttp;
		if(grid.CallBack)
		{
			var arg=xmlHttp.QueryString;
			eval(grid.CallBack);
		}
		else
		{
			grid.XmlHttp.open("POST", grid.Url, true);
			grid.XmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			if(ig_csom.IsIE)
				grid.XmlHttp.onreadystatechange=new Function("igtbl_onReadyStateChange('"+grid.Id+"')");
			else
			{
				grid.XmlHttp.igtbl_currentGrid=grid.Id;
				grid.XmlHttp.addEventListener("load",igtbl_onReadyStateChange,false);
			}
			grid.XmlHttp.send("__EVENTTARGET="+grid.UniqueID+"&__EVENTARGUMENT=XmlHttpRequest&"+grid.UniqueID+"="+igtbl_escape(xmlHttp.QueryString));
		}
	}
	if(grid._xmlHttpQueue.length>0)
		window.setTimeout("igtbl_getGridById('"+grid.Id+"')._serveXmlHttpQueue('"+grid.Id+"');",200);
},
"_containsChange",
function(type,obj)
{	
	return obj&&(obj._Changes[type]!=null);
},
"_recordChange",
function(type,obj,value,inId)
{
	var stateChange=new igtbl_StateChange(type,this,obj,value);
	if(typeof(this[type])!="undefined")
	{
		var id=obj?(obj.Element?obj.Element.id:obj.Id):inId;
		if(typeof(value)!="undefined" && value!=null)
			this[type][id]=value;
		else
			this[type][id]=inId?stateChange:true;
	}
	return stateChange;
},
"_removeChange",
function(type,obj,lastOnly)
{
	var ch;
	if(obj&&(ch=obj._Changes[type]))
	{
		if(ch.length)
		{
			if(lastOnly)
				ch[ch.length-1].remove(lastOnly);
			else
			{
				for(var i=ch.length-1;i>=1;i--)
					ch[i].remove();
				obj._Changes[type].remove();
			}
		}
		else
			ch.remove(lastOnly);
		if(typeof(this[type])!="undefined")
		{
			var id=obj.Element?obj.Element.id:obj.Id;
			delete this[type][id];
		}
	}
},
"alignDivs",
function(scrollLeft,force)
{
	if(!this.UseFixedHeaders
		
		&& this.XmlLoadOnDemandType==0
	) return;
	var mainGrid=this.MainGrid;
	if(!mainGrid) return;
	var divs=this._scrElem;
	var divf=this.Element.parentNode;
	var isInit=false;
	this.Element.setAttribute("noOnResize",true);
	if(!divs.firstChild.style.width && this.Element.offsetWidth)
	{
		var corr=0;
		if(this.IsXHTML && ig_csom.IsIE && this.Bands[0].Columns[0].Element)
		{
			var colEl=this.Bands[0].Columns[0].Element;
			corr=colEl.offsetWidth-colEl.clientWidth;
			corr+=igtbl_parseInt(colEl.currentStyle.paddingLeft);
			corr+=igtbl_parseInt(colEl.currentStyle.paddingRight);
			var i=this.Bands[0].Columns.length;
			while(i>0 && this.Bands[0].Columns[this.Bands[0].Columns.length-i].getFixed())
				i--;
			corr*=i;
		}
		divs.firstChild.style.width=(this.Element.offsetWidth + (this.GroupCount==1?this.Indentation:0)+1+corr).toString()+"px";
		if(!mainGrid.style.height)
			divs.style.overflowY="hidden";
		isInit=true;
	}
		
	
	// this will end up being an if statement with the commented line being there for Synchronos lines while the 
	// current code will be for the new feature. 
	if (this.XmlLoadOnDemandType==0)
		divs.firstChild.style.height=this.Element.offsetHeight.toString()+"px";
	else	
	{	
		this._setScrollDivHeight();
	}
	if(!mainGrid.style.width)
		divs.style.width=mainGrid.clientWidth.toString()+"px";
	if(!mainGrid.style.height)
	{
		divs.style.height=this.Element.offsetHeight.toString()+"px";
		if(divs.scrollHeight!=divs.clientHeight)
			divs.style.height=(this.Element.offsetHeight+divs.scrollHeight-divs.clientHeight).toString()+"px";
		divs.parentNode.style.height=divs.offsetHeight.toString()+"px";
	}
	if(isInit)
	{
		if(!divs.style.width || divs.style.width.charAt(divs.style.width.length-1)!="%")
			divs.setAttribute("oldW",divs.offsetWidth);
		if(!divs.style.height || divs.style.height.charAt(divs.style.height.length-1)!="%")
			divs.setAttribute("oldH",divs.offsetHeight);
	}
	var relOffs=false;
	if(ig_csom.IsIE)
	{
		while(mainGrid && mainGrid.tagName!=(igtbl_isXHTML?"HTML":"BODY") && !relOffs)
		{
			relOffs=mainGrid.style.position!="" && mainGrid.style.position!="static";
			if(!relOffs) mainGrid=mainGrid.parentNode;
		}
	}
	
	divf.style.left=(parseInt(divf.style.left,10)+igtbl_getLeftPos(divs)-igtbl_getLeftPos(divf)).toString()+"px";
	divf.style.top=(parseInt(divf.style.top,10)+igtbl_getTopPos(divs)-igtbl_getTopPos(divf)).toString()+"px";
	divf.style.width=igtbl_clientWidth(divs).toString()+"px";
	divf.style.height=igtbl_clientHeight(divs).toString()+"px";
	if(divf.firstChild.style.left=="")
		divf.firstChild.style.left="0px";
	if(divf.firstChild.style.top=="")
		divf.firstChild.style.top="0px";
	if(!scrollLeft)
		scrollLeft=divs.scrollLeft;
	else
	{
		this.UseFixedHeaders=false;
		igtbl_scrollLeft(divs,scrollLeft);
		this.UseFixedHeaders=true;
	}
	var doHoriz=false;
	if(!this._oldScrollLeftAlign)
		this._oldScrollLeftAlign=0;
	if(this._oldScrollLeftAlign!=scrollLeft)
	{
		this._oldScrollLeftAlign=scrollLeft;
		doHoriz=true;
	}
	if(parseInt(divf.firstChild.style.top,10)!=-divs.scrollTop)
	{
		if(this.XmlLoadOnDemandType!=2)
			divf.firstChild.style.top=(-divs.scrollTop).toString()+"px";
		if(this.StatHeader || this.StateFooter)
			doHoriz=true;
	}
	if(doHoriz || force)
	{
		if (this.UseFixedHeaders)
		{
			
			var rowDivs=igtbl_getDocumentElement(this.Id+"_drs");
			if(rowDivs)
			{
				
				if(!rowDivs.length)
					rowDivs=[rowDivs];
				
				for(var i=0;i<rowDivs.length;i++)
					rowDivs[i].firstChild.style.left=(-scrollLeft).toString()+"px";
			}
		}
		else 
		{
			if(this.XmlLoadOnDemandType!=2)
				divf.firstChild.style.top=(-divs.scrollTop).toString()+"px";
			divf.firstChild.style.left=(-divs.scrollLeft).toString()+"px";
		}
	}
	if(isInit)
	{
		divf.style.left=(parseInt(divf.style.left,10)+igtbl_getLeftPos(divs)-igtbl_getLeftPos(divf)).toString()+"px";
		divf.style.top=(parseInt(divf.style.top,10)+igtbl_getTopPos(divs)-igtbl_getTopPos(divf)).toString()+"px";
		divf.style.width=igtbl_clientWidth(divs).toString()+"px";
		divf.style.height=igtbl_clientHeight(divs).toString()+"px";
	}
	this.Element.removeAttribute("noOnResize");
},
"_setScrollDivHeight",
function()
{
		var divs=this._scrElem;
		var estRowsHeight=(this.RowsServerLength+1)*this.getDefaultRowHeight()+1; 
		if(!this.StatHeader && this.Bands[0].ColHeadersVisible==1)
			estRowsHeight+=this.getDefaultRowHeight();
		if(!this.StatFooter && this.Bands[0].ColFootersVisible==1)
			estRowsHeight+=this.getDefaultRowHeight();
		divs.firstChild.style.height=(this.Rows.Element.offsetHeight>estRowsHeight)?this.Rows.Element.offsetHeight:estRowsHeight;
},
"_recalcRowNumbers",
function(row)
{
	if(this.ClientSideRenumbering!=1) return;
	if(row && row.Band.AllowRowNumbering<2 || !row && this.AllowRowNumbering<2) return;
	
	for(var i=0; i<this.Bands.length;i++)
		this.Bands[i]._currentRowNumber=0;
	
	if (!row) 
		igtbl_RecalculateRowNumbers(this.Rows,1,this.Bands[0],this.Rows.Node);
	else
		switch(row.Band.AllowRowNumbering)
		{
			case(2):
			case(4):
				igtbl_RecalculateRowNumbers(this.Rows,1,this.Bands[0],this.Rows.Node);
				break;
			case(3):
				var rc = row.ParentRow?row.ParentRow.Rows:this.Rows;					
				igtbl_RecalculateRowNumbers(rc,1,rc.Band,rc.Node);
				break;
		}
},
"_calculateStationaryHeader",
function()
{

	if(!this.Bands[0].IsGrouped && this.StatHeader && (this.StationaryMargins==1 || this.StationaryMargins==3))
	{
		var tr=this.StatHeader.Element.parentNode.parentNode.parentNode.parentNode;
		var th=this.Element.childNodes[1];
		var i=0;
		var drs=null;
		var row=th.firstChild;
		while(i<row.cells.length && (!row.cells[i].firstChild || row.cells[i].firstChild.id!=this.Id+"_drs")) i++;
		if(i<row.cells.length)
		{
			var td=row.cells[i];
			drs=td.firstChild;
		}
		if (this.Rows && this.Rows.length>0)
		{
			tr.style.display="";
			
			var hdiv = tr.childNodes[0].childNodes[0];
			if (hdiv.style.height=="0pt")hdiv.style.height="";
			
			th.style.display="none";			
			if(drs)
				drs.style.display="none";
		}
		else
		{
			tr.style.display="none";			
			th.style.display="";			
			if(drs)
				drs.style.display="";
		}		
	}
},
"invokeXmlHttpRequest",
function(type,object,data)
{
	var g=this;
	if(!g.Node && !ig_csom.IsNetscape6 || g.LoadOnDemand!=3) return;
	
	switch(type)
	{
		case g.eReqType.UpdateCell:
		{
			var cell=object;
			if(g.LoadOnDemand==3 && (typeof(g.Events.AfterRowUpdate)=="undefined" || g.Events.AfterRowUpdate[1]==0 && (g.Events.XmlHTTPResponse[1]==1 || g.Events.AfterCellUpdate[1]==1)))
			{
				g.QueryString="UpdateCell\x01"+cell.Band.Index+"\x02"+cell.Column.Index+"\x02"+cell.Row.getIndex(true)+"\x02"+cell.Row.DataKey+"\x02"+data+"\x02"+cell.getLevel(true)+"\x02"+cell.getOldValue();
				g.xmlHttpRequest(type);
			}
			break;
		}
		case g.eReqType.AddNewRow:
		{
			var rows=object;
			if((typeof(g.Events.AfterRowUpdate)=="undefined" || g.Events.AfterRowUpdate[1]==0 && g.Events.XmlHTTPResponse[1]==1))
			{
				g.QueryString="AddNewRow\x01"+rows.Band.Index+"\x02"+(rows.ParentRow?rows.ParentRow.getIndex(true)+"\x02"+rows.ParentRow.DataKey:"\x02");
				g.xmlHttpRequest(type);
			}
			break;
		}
		case g.eReqType.Sort:
		{
			var rows=object;
			rows.sortXml();
			break;
		}
		case g.eReqType.ChildRows:
		{
			var row=object;
			row.requestChildRows();
			break;
		}
		case g.eReqType.DeleteRow:
		{
			if(g.LoadOnDemand==3 && (!g.Events.XmlHTTPResponse || g.Events.XmlHTTPResponse[1] || g.Events.AfterRowDeleted[1]))
			{
				var row = object;
				var cellInfo = row._generateUpdateRowSemaphore(true);
				
				g.QueryString="DeleteRow\x01"+row.Band.Index+"\x02"+row.getIndex(true)+"\x02"+row.DataKey+"\x02"+row.getLevel(true)+"\x02"+row.DataKey+"\x02"+g.RowsRetrieved+"\x04"+(cellInfo.length>0?"CellValues\x06"+cellInfo+"\x04":"")+"Page"+"\x03"+(g.AllowPaging===true?g.CurrentPageIndex:-1);
				g.RowToQuery=row;
				g.xmlHttpRequest(type);
			}
			break;
		}
		case g.eReqType.UpdateRow:
		{
			var row=object;
			var cellInfo="";
			if(row._dataChanged&1)
				g.QueryString="AddNewRow\x06"+(row.ParentRow?row.ParentRow.getLevel(true)+"\x02"+row.ParentRow.DataKey:"\x02")+(g.QueryString.length>0?"\x04":"")+g.QueryString;
			else
				cellInfo=row._generateUpdateRowSemaphore();
			g.QueryString="UpdateRow\x01"+row._dataChanged+"\x02"+row.Band.Index+"\x02"+row.getLevel(true)+"\x02"+row.DataKey+"\x02"+g.RowsRetrieved+"\x04"+(cellInfo.length>0?"CellValues\x06"+cellInfo+"\x04":"")+g.QueryString;
			g.RowToQuery=row;
			g.xmlHttpRequest(type);
			break;
		}
		case g.eReqType.MoreRows:
		{
			
			if(this.AllowPaging)return;
			var de=g.getDivElement();
			de.setAttribute("oldST",de.scrollTop.toString());
			if(g.RowsServerLength>g.Rows.length)
			{
				g.QueryString="NeedMoreRows\x01"+g.RowsRetrieved+"\x02"+g.Rows.length.toString();
				var sortOrder="";
				sortOrder = g._buildSortOrder();
				
				if(g.Bands[0].ColumnsOrder)
					g.QueryString+="\x02"+g.Bands[0].ColumnsOrder;
				if(sortOrder)
					g.QueryString+="\x02"+sortOrder;
				de.setAttribute("noOnScroll","true");
				g.xmlHttpRequest(g.eReqType.MoreRows);
			}
			break;
		}
		case g.eReqType.Custom:
		{
			g.QueryString="Custom\x01"+data;
			g.xmlHttpRequest(g.eReqType.Custom);
			break;
		}
		case g.eReqType.Page:
		{			
			g.QueryString="Page\x01"+data+"\x01"+g.CurrentPageIndex+"\x01"+g._buildSortOrder(g);
			g.xmlHttpRequest(g.eReqType.Page);
			break;
		}
		case g.eReqType.Scroll:
		{
			if(this.AllowPaging) return;
			var de=g.getDivElement();
			de.setAttribute("oldST",de.scrollTop.toString());

			var topRowNo=Math.floor(de.scrollTop/g.getDefaultRowHeight());
			g.QueryString="NeedMoreRows\x01"+topRowNo.toString()+"\x02"+topRowNo.toString();
			var sortOrder="";
			sortOrder = g._buildSortOrder();
			if(g.Bands[0].ColumnsOrder)
				g.QueryString+="\x02"+g.Bands[0].ColumnsOrder;
			if(sortOrder)
				g.QueryString+="\x02"+sortOrder;
			g.xmlHttpRequest(g.eReqType.Scroll);
			break;
		}
	}
},
"getDefaultRowHeight",
function()
{
	var rh=igtbl_parseInt(this.Bands[0].DefaultRowHeight);
	if(!rh)
		return 22;
	return rh;
},
"_buildSortOrder",
function()
{
	var sortOrder="";
	for(var i=0;i<this.Bands[0].SortedColumns.length;i++)
	{
		var col=igtbl_getColumnById(this.Bands[0].SortedColumns[i]);
		sortOrder+=col.Key+(col.SortIndicator==2?" DESC":"")+(i<this.Bands[0].SortedColumns.length-1?",":"");
	}
	return sortOrder;
},
"_ensureValidParent",
function(obj)
{
	e=obj.Element;
	var pe=e?e.parentNode:null;
	if(pe&&pe.tagName!="FORM"&&pe.tagName!=(igtbl_isXHTML?"HTML":"BODY"))
		try
		{
			ig_csom._skipNew=true;
			npe=igtbl_getElementById(this.Id);
			if(npe)
				npe=npe.form;
			if(obj._relocate)
				obj._relocate(npe,window.document.body);
			else
			{
				pe.removeChild(e);
				if(npe)
					try
					{
						npe.appendChild(e);
					}
					catch(ex)
					{
						npe=null;
					}
				if(!npe)
					document.body.insertBefore(e,document.body.firstChild);
				e.style.zIndex=9999;
			}
			ig_csom._skipNew=false;
		}
		catch(ex){}
},
"getDivElement",
function()
{
	var de=this.DivElement;
	if(this._scrElem)
		de=this._scrElem;
	return de;
}
];
for(var i=0;i<igtbl_ptsGrid.length;i+=2)
	igtbl_Grid.prototype[igtbl_ptsGrid[i]]=igtbl_ptsGrid[i+1];

var igtbl_waitDiv=null;
var igtbl_wndOldCursor=null;

// Band object
igtbl_Band.prototype=new igtbl_WebObject();
igtbl_Band.prototype.constructor=igtbl_Band;
igtbl_Band.base=igtbl_WebObject.prototype;
function igtbl_Band(grid,node,index)
{
	if(arguments.length>0)
		this.init(grid,node,index);
}
var igtbl_ptsBand=[
"init",
function(grid,node,index)
{
	igtbl_Band.base.init.apply(this,["band",null,node]);

	this.Grid=grid;
	this.Index=index;
	var defaultProps=new Array("Key","AllowAddNew","AllowColSizing","AllowDelete","AllowSort","ItemClass","AltClass","AllowUpdate",
								"CellClickAction","ColHeadersVisible","ColFootersVisible","CollapseImage","CurrentRowImage",
								"CurrentEditRowImage","DefaultRowHeight","EditCellClass","Expandable","ExpandImage",
								"FooterClass","GroupByRowClass","GroupCount","HeaderClass","HeaderClickAction","Visible",
								"IsGrouped","ExpAreaClass","NonSelHeaderClass","RowLabelClass","SelGroupByRowClass","SelHeadClass",
								"SelCellClass","RowSizing","SelectTypeCell","SelectTypeColumn","SelectTypeRow","RowSelectors",
								"NullText","RowTemplate","ExpandEffects","AllowColumnMoving","ClientSortEnabled","Indentation",
								"RowLabelWidth","DataKeyField","HeaderHTML","FooterHTML","FixedHeaderIndicator","AllowRowNumbering",
								"IndentationType"
								,"HasHeaderLayout","HasFooterLayout","GroupByColumnsHidden","AddNewRowVisible","AddNewRowView",
								"AddNewRowStyle"
								,"_optSelectRow"
								);
	this.VisibleColumnsCount=0;
	this.Columns = new Array();
	var bandArray;
	try{bandArray=eval("igtbl_"+grid.Id+"_Bands["+index.toString()+"]");}catch(e){}
	var bandCount=0;
	if(bandArray)
	{
		bandCount=eval("igtbl_"+grid.Id+"_Bands").length;
		for(var i=0;i<bandArray.length;i++)
			this[defaultProps[i]]=bandArray[i];
		if(this.RowTemplate!="")
			this.ExpandEffects=new igtbl_expandEffects(this.ExpandEffects);
		if(this.HeaderHTML!="")
			this.HeaderHTML=unescape(this.HeaderHTML);
		if(this.FooterHTML!="")
			this.FooterHTML=unescape(this.FooterHTML);
	}	
	else
		bandCount=this.Node.parentNode.selectNodes("Band").length;	
	var colsArray=eval("igtbl_"+grid.Id+"_Columns_"+index.toString());
	if(!node)
	{
		for(var i=0;i<colsArray.length;i++)
		{
			this.Columns[i]=new igtbl_Column(null,this,i);
			if(!this.Columns[i].Hidden)
				this.VisibleColumnsCount++;
			if(this.Columns[i].getSelClass()!=this.getSelClass())
				this._selClassDiffer=true;
		}
	}
	else
	{
		this.Columns.Node=this.Node.selectSingleNode("Columns");
		var columNodes=this.Columns.Node.selectNodes("Column");
		var nodeIndex=0;		
		for(var i=0;i<columNodes.length;i++)
		{
			this.Columns[i]=new igtbl_Column(columNodes[i],this,i,nodeIndex);
			if(!this.Columns[i].Hidden && this.Columns[i].hasCells())
				this.VisibleColumnsCount++;
			if(!colsArray[i][33])
				nodeIndex++;
			if(this.Columns[i].getSelClass()!=this.getSelClass())
				this._selClassDiffer=true;
		}
	}

	igtbl_dispose(defaultProps);

	if(node)
	{
		this.ColumnsOrder="";
		for(var i=0;i<this.Columns.length;i++)
			this.ColumnsOrder+=this.Columns[i].Key+(i<this.Columns.length-1?";":"");
	}

	if(grid.AddNewBoxVisible)
	{
		if(this.Index==0)
			this.curTable=grid.Element;
		var addNew=igtbl_getElementById(grid.Id+"_addBox");
		if(grid.AddNewBoxView==0)
			this.addNewElem = addNew.childNodes[0].rows[0].cells[1].childNodes[0].rows[this.Index].cells[this.Index];
		else
			this.addNewElem = addNew.childNodes[0].rows[0].cells[1].childNodes[0].rows[0].cells[this.Index*2];
	}
	this.SortedColumns=new Array();

	var rs=this.getRowSelectors();
	if(bandCount==1)
	{
		if(rs==2)
			this.firstActiveCell=0;
		else
			this.firstActiveCell=1;
	}
	else
	{
		if(rs==2)
			this.firstActiveCell=1;
		else
			this.firstActiveCell=2;
	}
},
"getSelectTypeRow",
function()
{
	var res=this.Grid.SelectTypeRow;
	if(this.SelectTypeRow!=0)
		res=this.SelectTypeRow;
	return res;
},
"getSelectTypeCell",
function()
{
	var res=this.Grid.SelectTypeCell;
	if(this.SelectTypeCell!=0)
		res=this.SelectTypeCell;
	return res;
},
"getSelectTypeColumn",
function()
{
	var res=this.Grid.SelectTypeColumn;
	if(this.SelectTypeColumn!=0)
		res=this.SelectTypeColumn;
	return res;
},
"getColumnFromKey",
function(key)
{
	var column=null;
	for(var i=0;i<this.Columns.length;i++)
		if(	this.Columns[i].Key==key )
		{
			column=this.Columns[i];
			break;
		}
	return column;
},
"getExpandImage",
function()
{
	var ei=this.Grid.ExpandImage;
	if(this.ExpandImage!="")
		ei=this.ExpandImage;
	return ei;
},
"getCollapseImage",
function()
{
	var ci=this.Grid.CollapseImage;
	if(this.CollapseImage!="")
		ci=this.CollapseImage;
	return ci;
},
"getRowStyleClassName",
function()
{
	if(this.ItemClass!="")
		return this.ItemClass;
	return this.Grid.ItemClass;
},
"getRowAltClassName",
function()
{
	if(this.AltClass!="")
		return this.AltClass;
	return this.Grid.AltClass;
},
"getExpandable",
function()
{
	if(this.Expandable!=0)
		return this.Expandable;
	else return this.Grid.Expandable;
},
"getCellClickAction",
function()
{
	var res=this.Grid.CellClickAction;
	if(this.CellClickAction!=0)
		res=this.CellClickAction;
	return res;
},
"getExpAreaClass",
function()
{
	if(this.ExpAreaClass!="")
		return this.ExpAreaClass;
	return this.Grid.ExpAreaClass;
},
"getRowLabelClass",
function()
{
	if(this.RowLabelClass!="")
		return this.RowLabelClass;
	return this.Grid.RowLabelClass;
},
"getItemClass",
function()
{
	if(this.ItemClass!="")
		return this.ItemClass;
	return this.Grid.ItemClass;
},
"getAltClass",
function()
{
	if(this.AltClass!="")
		return this.AltClass;
	else if(this.Grid.AltClass!="")
		return this.Grid.AltClass;
	else if(this.ItemClass!="")
		return this.ItemClass;
	return this.Grid.ItemClass;
},
"getSelClass",
function()
{
	if(this.SelCellClass!="")
		return this.SelCellClass;
	return this.Grid.SelCellClass;
},
"getFooterClass",
function()
{
	if(this.FooterClass!="")
		return this.FooterClass;
	return this.Grid.FooterClass;
},
"getGroupByRowClass",
function()
{
	if(this.GroupByRowClass!="")
		return this.GroupByRowClass;
	return this.Grid.GroupByRowClass;
},
"addNew",
function()
{
	if(typeof(igtbl_addNew)=="undefined")
		return null;
	return igtbl_addNew(this.Grid.Id,this.Index);
},
"getHeadClass",
function()
{
	if(this.HeaderClass!="")
		return this.HeaderClass;
	return this.Grid.HeaderClass;
},
"getRowSelectors",
function()
{
	var res=this.Grid.RowSelectors;
	if(this.RowSelectors!=0)
		res=this.RowSelectors;
	return res;
},
"removeColumn",
function(index)
{
	if(!this.Node) return;
	var column=this.Columns[index];
	if(!column)
		return;
	var elem=column._getHeadTags(true);
	var fElem=column._getFootTags(true);
	var cols=column._getColTags(true);
	for(var i=0;elem && i<elem.length;i++)
	{
		if(elem[i])
		{
			elem[i].parentNode.removeChild(elem[i]);
			elem[i].id="";
		}
	}
	for(var i=0;fElem && i<fElem.length;i++)
	{
		if(fElem[i])
		{
			fElem[i].parentNode.removeChild(fElem[i]);
			fElem[i].id="";
		}
	}
	for(var i=0;cols && i<cols.length;i++)
		if(cols[i])
			cols[i].parentNode.removeChild(cols[i]);
	column.colElem=elem;
	column.colFElem=fElem;
	if(column.Node)
		column.Node.parentNode.removeChild(column.Node);
	if(this.Columns.splice)
		this.Columns.splice(index,1);
	else
		this.Columns=this.Columns.slice(0,index).concat(this.Columns.slice(index+1));
	column.Id="";
	column.fId="";
	this.reIdColumns();
	return column;
},
"insertColumn",
function(column,index)
{
	if(!this.Node || !column || !column.Node || index<0 || index>this.Columns.length)
		return;
	var column1=this.Columns[index];
	var hAr;
	var hAr1;
	var fAr;
	var fAr1;
	var insIndex;
	if(column1)
	{
		this.Columns.Node.insertBefore(column.Node,this.Columns[index].Node);
		if(this.Columns.splice)
			this.Columns.splice(index,0,column);
		else
			this.Columns=this.Columns.slice(0,index).concat(column,this.Columns.slice(index));
		insIndex=index;
		while(column1 && !column1.hasCells())
			column1=this.Columns[++index];
	}
	else
	{
		this.Columns.Node.appendChild(column.Node);
		this.Columns[this.Columns.length]=column;
		insIndex=this.Columns.length-1;
	}
	if(column1)
	{
		hAr=column.colElem;
		fAr=column.colFElem;
		if(column.getFixed()===column1.getFixed())
		{
			hAr1=column1._getHeadTags(true);
			for(var i=0;i<hAr.length;i++)
			{
				var tr=hAr1[i].parentNode;
				tr.insertBefore(hAr[i],hAr1[i])
			}
			if(fAr)
			{
				fAr1=column1._getFootTags(true);
				for(var i=0;i<fAr.length;i++)
				{
					var tr=fAr1[i].parentNode;
					tr.insertBefore(fAr[i],fAr1[i])
				}
			}
		}
		else
		{
			column1=this.Columns[index-1];
			hAr1=this.Columns[index-1]._getHeadTags(true);
			for(var i=0;i<hAr.length;i++)
			{
				var tr=hAr1[i].parentNode;
				tr.insertBefore(hAr[i],hAr1[i].nextSibling)
			}
			if(fAr)
			{
				fAr1=this.Columns[index-1]._getFootTags(true);
				for(var i=0;i<fAr.length;i++)
				{
					var tr=fAr1[i].parentNode;
					tr.insertBefore(fAr[i],fAr1[i].nextSibling)
				}
			}
		}
		if(column.getVisible() && column1.getVisible())
		{
			if(column.getFixed()===column1.getFixed())
				column1._insertCols(true,column.Width);
			else
				this.Columns[index-1]._insertCols(false,column.Width);
		}
		else if(column.getVisible())
		{
			column2=column1;
			if(!column1.hasCells()) 
			{
				while(column2 && !column2.hasCells())
					column2=this.Columns[column2.Index+1];
			}
			if(column2 && column2.getVisible())
				column2._insertCols(true,column.Width);
			else 
			{
				column2=column1;
				while(column2 && !column2.getVisible())
					column2=this.Columns[column2.Index-1];
				if(!column2) return;
				column2._insertCols(false,column.Width);
			}
		}
	}
	else
	{
		column1=this.Columns[insIndex-1];
		while(column1 && !column1.hasCells())
			column1=this.Columns[--insIndex];
		if(!column1) return;
		hAr=column.colElem;
		fAr=column.colFElem;
		hAr1=column1._getHeadTags(true);
		for(var i=0;i<hAr.length;i++)
		{
			var tr=hAr1[i].parentNode;
			tr.appendChild(hAr[i])
		}
		if(fAr)
		{
			fAr1=column1._getFootTags(true);
			for(var i=0;i<fAr.length;i++)
			{
				var tr=fAr1[i].parentNode;
				tr.appendChild(fAr[i])
			}
		}
		if(column.getVisible() && column1.getVisible())
			column1._insertCols(false,column.Width);
		else if(column.getVisible())
		{
			while(column1 && !column1.getVisible())
				column1=this.Columns[column1.Index-1];
			if(!column1) return;
			column1._insertCols(false,column.Width);
		}
	}
	this.reIdColumns();
	igtbl_dispose(hAr);
	igtbl_dispose(fAr);
	igtbl_dispose(hAr1);
	igtbl_dispose(fAr1);
	return column;
},
"reIdColumns",
function()
{
	if(!this.Node) return;
	for(var i=0;i<this.Columns.length;i++)
		if(!this.Columns[i]._reIded)
			this.Columns[i]._reId(i);
	for(var i=this.Columns.length-1;i>=0;i--)
		delete this.Columns[i]._reIded;
},
"getSelGroupByRowClass",
function()
{
	if(this.SelGroupByRowClass!="")
		return this.SelGroupByRowClass;
	return this.Grid.SelGroupByRowClass;
},
"getBorderCollapse",
function()
{
	if(this.get("BorderCollapse")=="Separate")
		return "";
	if(this.Grid.get("BorderCollapseDefault")=="Separate")
		return "";
	if(this.curTable)
		return this.curTable.style.borderCollapse;
	return this.Grid.Element.style.borderCollapse;
}
];
for(var i=0;i<igtbl_ptsBand.length;i+=2)
	igtbl_Band.prototype[igtbl_ptsBand[i]]=igtbl_ptsBand[i+1];

// Column object
igtbl_Column.prototype=new igtbl_WebObject();
igtbl_Column.prototype.constructor=igtbl_Column;
igtbl_Column.base=igtbl_WebObject.prototype;
function igtbl_Column(node,band,index,nodeIndex)
{
	if(arguments.length>0)
		this.init(node,band,index,nodeIndex);
}
var igtbl_ptsColumn=[
"init",
function(node,band,index,nodeIndex)
{
	igtbl_Column.base.init.apply(this,["column",null,node]);

	this.Band=band;
	this.Index=index;
	this.Id=(band.Grid.Id
		+"_"
		+"c_"+band.Index.toString()+"_"+index.toString());
	if(band.ColFootersVisible==1)
		this.fId=(band.Grid.Id
			+"_"
			+"f_"+band.Index.toString()+"_"+index.toString());
	var defaultProps=new Array("Key","HeaderText","DataType","CellMultiline","Hidden","AllowGroupBy","AllowColResizing","AllowUpdate",
								"Case","FieldLength","CellButtonDisplay","HeaderClickAction","IsGroupBy","MaskDisplay","Selected",
								"SortIndicator","NullText","ButtonClass","SelCellClass","SelHeadClass","ColumnType","ValueListPrompt",
								"ValueList","ValueListClass","EditorControlID","DefaultValue","TemplatedColumn","Validators",
								"CssClass","Style","Width","AllowNull","Wrap","ServerOnly","HeaderClass","ButtonStyle","Fixed","FooterClass",
								"FixedHeaderIndicator","FooterText","HeaderStyle","FooterStyle","HeaderWrap"
								,"HeaderImageUrl","HeaderImageAltText","HeaderImageHeight","HeaderImageWidth"
								,"MergeCells"
								);
	var columnArray;
	try{columnArray=eval("igtbl_"+band.Grid.Id+"_Columns_"+band.Index.toString()+"["+index.toString()+"]");}catch(e){}
	if(columnArray)
	{
		for(var i=0;i<columnArray.length;i++)
			this[defaultProps[i]]=columnArray[i];
		if(this.Key && this.Key.length>0)
		this.Key = unescape(this.Key);
		if(this.HeaderText&&this.HeaderText.length>0)
			this.HeaderText = unescape(this.HeaderText);
		if(this.HeaderImageUrl&&this.HeaderImageUrl.length>0)
			this.HeaderImageUrl = unescape(this.HeaderImageUrl);
		if(this.HeaderImageAltText&&this.HeaderImageAltText.length>0)
			this.HeaderImageAltText = unescape(this.HeaderImageAltText);
		
		this._AltCssClass==this.Band.getRowAltClassName()+(this.CssClass?" ":"")+this.CssClass;
		this.CssClass=this.Band.getRowStyleClassName()+(this.CssClass?" ":"")+this.CssClass;		
	}
	this.ensureWebCombo();
	if(node)
	{
		this.Node.setAttribute("index",index+1);
		this.Node.setAttribute("cellIndex",nodeIndex+1);
	}
	igtbl_dispose(defaultProps);
	if(this.EditorControlID)
	{
		this.editorControl=igtbl_getElementById(this.EditorControlID);
		if(this.editorControl) this.editorControl=this.editorControl.Object;
	}

	if(this.Validators && this.Validators.length>0 && typeof(Page_Validators)!="undefined")
	{
		for(var i=0;i<this.Validators.length;i++)
		{
			var val=igtbl_getElementById(this.Validators[i]);
			if(val)
				val.enabled=false;
		}
	}
	this._Changes=new Object();
},
"getAllowUpdate",
function()
{
	var g=this.Band.Grid;
	var res=g.AllowUpdate;
	if(this.Band.AllowUpdate!=0)
		res=this.Band.AllowUpdate;
	if(this.AllowUpdate!=0)
		res=this.AllowUpdate;
	if(this.TemplatedColumn&2)
		res=2;
	return res;
},
"setAllowUpdate",
function (value)
{	
	this.AllowUpdate=value;
	switch (this.DataType)
	{
		case 11:  
			igtbl_AdjustCheckboxDisabledState(this, this.Band.Index,this.Band.Grid.Rows,this.getAllowUpdate());
			break;			
	}
},
"getHidden",
function()
{
	return this.Hidden;
},
"setHidden",
function(h)
{
	if(this.Node)
	{
		if(h===false)
			this.Node.removeAttribute("hidden");
		else
			this.Node.setAttribute("hidden",true);
	}
	igtbl_hideColumn(this.Band.Grid.Rows,this,h);
	this.Hidden=h;
	if(this.Band.Index==0)
		this.Band.Grid.alignStatMargins();
	var ac=this.Band.Grid.getActiveCell();
	if(ac && ac.Column==this && h)
		this.Band.Grid.setActiveCell(null);
	else
		this.Band.Grid.alignGrid();
},
"getVisible",
function()
{
	return !this.getHidden() && this.hasCells();
},
"hasCells",
function()
{
	return !this.ServerOnly && (!this.IsGroupBy || this.Band.GroupByColumnsHidden==2);
},
"getNullText",
function()
{
	return igtbl_getNullText(this.Band.Grid.Id,this.Band.Index,this.Index);
},
"find",
function(re,back)
{
	var g=this.Band.Grid;
	if(re)
		g.regExp=re;
	if(!g.regExp || !this.hasCells())
		return null;
	g.lastSearchedCell=null;
	if(back==true || back==false)
		g.backwardSearch=back;
	var row=null;
	if(!g.backwardSearch)
	{
		row=g.Rows.getRow(0);
		if(row && row.getHidden())
			row=row.getNextRow();
		while(row && (row.Band!=this.Band || row.getCellByColumn(this).getValue(true).search(g.regExp)==-1))
			row=row.getNextTabRow(false,true);
	}
	else
	{
		var rows=g.Rows;
		while(rows)
		{
			row=rows.getRow(rows.length-1);
			if(row && row.getHidden())
				row=row.getPrevRow();
			if(row && row.Expandable)
				rows=row.Rows;
			else
			{
				if(!row)
					row=rows.ParentRow;
				rows=null;
			}
		}
		while(row && (row.Band!=this.Band || row.getCellByColumn(this).getValue(true).search(g.regExp)==-1))
			row=row.getNextTabRow(true,true);
	}
	g.lastSearchedCell=(row?row.getCellByColumn(this):null);
	return g.lastSearchedCell;
},
"findNext",
function(re,back)
{
	var g=this.Band.Grid;
	if(!g.lastSearchedCell || g.lastSearchedCell.Column!=this)
		return this.find(re,back);
	if(re)
		g.regExp=re;
	if(!g.regExp)
		return null;
	if(back==true || back==false)
		g.backwardSearch=back;
	var row=g.lastSearchedCell.Row.getNextTabRow(g.backwardSearch,true);
	while(row && (row.Band!=this.Band || row.getCellByColumn(this).getValue(true).search(g.regExp)==-1))
		row=row.getNextTabRow(g.backwardSearch,true);
	g.lastSearchedCell=(row?row.getCellByColumn(this):null);
	return g.lastSearchedCell;
},
"getFooterText",
function()
{
	var fId=this.Band.Grid.Id
		+"_"
		+"f_"+this.Band.Index+"_"+this.Index;
	var foot=igtbl_getElementById(fId);
	if(foot)
		return igtbl_getInnerText(foot);
	return "";
},
"setFooterText",
function(value,useMask)
{
	var fId=this.Band.Grid.Id
		+"_"
		+"f_"+this.Band.Index+"_"+this.Index;
	var foot=igtbl_getDocumentElement(fId);
	if(foot)
	{
		if(useMask && this.MaskDisplay)
			value=igtbl_Mask(this.Band.Grid.Id,value.toString(),this.DataType,this.MaskDisplay);
		if(igtbl_trim(value)=="")
			value="&nbsp;";
		if(!foot.length)
			foot=[foot];
		var fElem=foot[0];
		if(fElem.childNodes.length>0 && fElem.childNodes[0].tagName=="NOBR")
			value="<nobr>"+value+"</nobr>";
		for(var i=0;i<foot.length;i++)
		{
			fElem=foot[i];
			fElem.innerHTML=value;
		}
	}
},
"getSelClass",
function()
{
	if(this.SelCellClass!="")
		return this.SelCellClass;
	return this.Band.getSelClass();
},
"getHeadClass",
function()
{
	if(this.HeaderClass!="")
		return this.HeaderClass;
	return this.Band.getHeadClass();
},
"getFooterClass",
function()
{
	if(this.FooterClass!="")
		return this.FooterClass;
	return this.Band.getFooterClass();
},
"compareRows",
function(row1,row2)
{
	if(igtbl_columnCompareRows)
		return igtbl_columnCompareRows.apply(this,[row1,row2]);
	return 0;
},
"compareCells",
function(cell1,cell2)
{
	if(igtbl_columnCompareCells)
		return igtbl_columnCompareCells.apply(this,[cell1,cell2]);
	return 0;
},
"move",
function(toIndex)
{
	if(!this.Node) return;
	oldIndex=this.Index;
	this.Band.Grid._recordChange("ColumnMove",this,toIndex);
	var b=this.Band,oldSortedColumn=null;
	if (b.SortedColumns&&b.SortedColumns.length>0)
	{
		oldSortedColumn=new Array();
		for(var i=0;i<b.SortedColumns.length;i++)
			for (var j=0;j<b.Columns.length;j++)
				if(b.Columns[j].Id==b.SortedColumns[i])
				{
					oldSortedColumn[i]=b.Columns[j];
					break;
				}
	}
	this.Band.insertColumn(this.Band.removeColumn(this.Index),toIndex);
	if (oldSortedColumn)
		for(var i=0;i<oldSortedColumn.length;i++)
		{
			b.SortedColumns[i]=oldSortedColumn[i].Id;
			oldSortedColumn[i]=null;
		}
	igtbl_dispose(oldSortedColumn);
	igtbl_swapCells(this.Band.Grid.Rows,this.Band.Index,oldIndex,toIndex);
},
"getLevel",
function(s)
{
	var l=new Array();
	l[0]=this.Band.Index;
	l[1]=this.Index;
	if(s)
	{
		s=l.join("_");
		igtbl_dispose(l);
		delete l;
		return s;
	}
	return l;
},
"getFixed",
function()
{
	if(this.Band.Grid.UseFixedHeaders)
		 return this.Fixed;
},
"setFixed",
function(fixed)
{
	this.Fixed=fixed;
},
"getWidth",
function()
{
	if(typeof(this.Width)!="string")
		return this.Width;
	var e=igtbl_getElementById(this.Id);
	if(!e || !e.offsetWidth || typeof(this.Width)=="string" && this.Width.substr(this.Width.length-2,2)=="px")
		this.Width=igtbl_parseInt(this.Width);
	if(typeof(this.Width)=="string")
	{
		this.Width=e.offsetWidth;
	}
	return this.Width;
},
"setWidth",
function(width)
{
	var gs=this.Band.Grid,gn=gs.Id;
	var colObj=igtbl_getElementById(this.Id);
	var fac=this.Band.firstActiveCell;
	var c1w=width;
	if(c1w>0 && !igtbl_fireEvent(gn,gs.Events.BeforeColumnSizeChange,"(\""+gn+"\",\""+colObj.id+"\","+c1w+")"))
	{
		if(gs.UseFixedHeaders && this.Band.Index==0)
		{
			var scrw=gs._scrElem.firstChild.offsetWidth+c1w-this.getWidth();
			if(scrw>=0)
			{
				var corr=0;
				
				var colEl=this.Element;
				if(colEl && gs.IsXHTML && !this._xhtmlCorrected && ig_csom.IsIE && this.Band.Index==0)
				{					
					corr=colEl.offsetWidth-colEl.clientWidth;
					corr+=igtbl_parseInt(colEl.currentStyle.paddingLeft);
					corr+=igtbl_parseInt(colEl.currentStyle.paddingRight);
					this._xhtmlCorrected=true;
				}
				gs._scrElem.firstChild.style.width=scrw+corr;
			}
		}
		var fixed=(gs.UseFixedHeaders && !this.getFixed());
		var columns=igtbl_getDocumentElement(this.Id);
		if(!columns.length)
			columns=[columns];
		if(fixed)
		{
			for(var i=0;i<columns.length;i++)
			{
				var cells=igtbl_enumColumnCells(gn,columns[i]);
				for(var j=0;j<cells.length;j++)
				{
					var cg=cells[j].parentNode.parentNode.previousSibling;
					if(cg)
					{
						var c=cg.childNodes[cells[j].cellIndex];
						if(c)
						{
							if(c.style.width) c.style.width="";
							c.width=c1w;
						}
					}
					if(cells[j].style.width) cells[j].style.width="";
					cells[j].width=c1w;
				}
			}
			var colFoots=igtbl_getDocumentElement(this.fId);
			if(colFoots)
			{
				if(!colFoots.length)
					colFoots=[colFoots];
				for(var i=0;i<colFoots.length;i++)
				{
					var cg=colFoots[i].parentNode.parentNode.previousSibling;
					if(cg && cg.tagName=="COLGROUP")
					{
						var c=cg.childNodes[colFoots[i].cellIndex];
						if(c)
						{
							if(c.style.width) c.style.width="";
							c.width=c1w;
						}
					}
					var nfth=colFoots[i].parentNode;
					while(nfth && nfth.tagName!="TH")
						nfth=nfth.parentNode;
					if(nfth && this.Band.Index==0 && this.Band.Index==0 && gs.StatFooter)
					{
						cg=nfth.parentNode.parentNode.previousSibling;
						if(this.Band.AddNewRowView==2 && gs.Rows.AddNewRow)
						{
							cg=cg.previousSibling;
							var addRow=gs.Rows.AddNewRow;
							var c=addRow.getCell(this.Index).Element.parentNode.parentNode.previousSibling.childNodes[colFoots[i].cellIndex];
							if(c)
							{
								if(c.style.width) c.style.width="";
								c.width=c1w;
							}
						}
						if(cg)
						{
							var c=cg.childNodes[nfth.cellIndex+colFoots[i].cellIndex];
							if(c)
							{
								if(c.style.width) c.style.width="";
								c.width=c1w;
							}
						}
					}
					if(colFoots[i].style.width) colFoots[i].style.width="";
					colFoots[i].width=c1w;
				}
			}
		}
		for(var i=0;i<columns.length;i++)
		{
			var cg=columns[i].parentNode.parentNode.previousSibling;
			if(this.Band.HasHeaderLayout && cg)
			{
				var colOffs=parseInt(columns[i].getAttribute("coloffs"),10);
				if(this.getFixed()!==false)
					colOffs+=this.Band.firstActiveCell;
				var c=cg.childNodes[colOffs];
				if(c.style.width) c.style.width="";
				c.width=c1w;
				if(fixed)
				{
					var nfth=columns[i].parentNode;
					while(nfth && nfth.tagName!="TH")
						nfth=nfth.parentNode;
					if(nfth)
					{
						cg=nfth.parentNode.parentNode.previousSibling;
						if(cg)
						{
							var c=cg.childNodes[nfth.cellIndex+columns[i].cellIndex];
							if(c.style.width) c.style.width="";
							c.width=c1w;
						}
						
					}
				}
			}
			else
			{
				var c;
				if(cg)
					c=cg.childNodes[columns[i].cellIndex];
				else
					c=columns[i];
				if(c.style.width) c.style.width="";
				if(columns[i].style.width) columns[i].style.width="";
				c.width=c1w;
				columns[i].width=c1w;
				if(fixed)
				{
					var nfth=columns[i].parentNode;
					while(nfth && nfth.tagName!="TH")
						nfth=nfth.parentNode;
					if(nfth)
					{
						cg=nfth.parentNode.parentNode.previousSibling;
						if(cg)
						{
							var c=cg.childNodes[nfth.cellIndex+columns[i].cellIndex];
							if(c.style.width) c.style.width="";
							c.width=c1w;
						}
						
						if(this.Band.Index==0 && this.Band.AddNewRowView==1 && !this.Band.IsGrouped &&gs.StatHeader)
						{
							cg=cg.previousSibling;
							var addRow=gs.Rows.AddNewRow;
							var c=addRow.getCell(this.Index).Element.parentNode.parentNode.previousSibling.childNodes[columns[i].cellIndex];
							if(c.style.width) c.style.width="";
							c.width=c1w;
						}
					}
				}
				else
				{
					var table=columns[i];
					while(table && table.tagName!="TABLE")
						table=table.parentNode;
					if(table && table.style.width.length>0)
					{
						var oldWidth=table.style.width;
						if(oldWidth.length>2 && oldWidth.substr(oldWidth.length-2,2)=="px")
						{
							var tbw=table.offsetWidth+c1w-this.getWidth();
							if(tbw>0)
								table.style.width=tbw.toString()+"px";
						}
					}
					if(gs.get("StationaryMarginsOutlookGroupBy")=="True" && this.Band.Index==0 && this.Band.IsGrouped && i==0)
					{
						table=gs.getDivElement().firstChild;
						var tbw=table.offsetWidth+c1w-this.getWidth();
						if(tbw>0)
							table.style.width=tbw.toString()+"px";
					}
				}
			}
		}
		this.Width=c1w;
		if(this.Node) this.Node.setAttribute("lit:width",c1w);
		if(this.Band.Index==0)
		{
			if(gs.StatHeader)
				gs.StatHeader.ScrollTo(gs.Element.parentNode.scrollLeft);
			if(gs.StatFooter)
			{
				if(!fixed)
					gs.StatFooter.Resize(this.Index,c1w);
				gs.StatFooter.ScrollTo(gs.Element.parentNode.scrollLeft);
			}
		}
		gs.alignDivs(0,true);
		gs._removeChange("ResizedColumns",this);
		gs._recordChange("ResizedColumns",this,c1w);
		igtbl_fireEvent(gn,gs.Events.AfterColumnSizeChange,"(\""+gn+"\",\""+colObj.id+"\","+c1w+")");
		if(gs.NeedPostBack)
			igtbl_doPostBack(gn);
		return true;
	}
	return false;
},
"ensureWebCombo",
function()
{
	if(typeof(igcmbo_getComboById)!="undefined" && igcmbo_getComboById(this.EditorControlID) && !this.WebComboId)
		this.WebComboId=this.EditorControlID;
},
"getRealIndex",
function(row)
{
	if(!this.hasCells())
		return -1;
	var ri=-1;
	var colspan=1;
	var cell=null;
	if(row)
		cell=row.Element.cells[row.Band.firstActiveCell];
	var i=0;
	while(i<this.Index+1 && !this.Band.Columns[i].hasCells())
		i++;
	if(i>this.Index)
		return ri;
	ri=0;
	for(;i<this.Index;i++)
	{
		if(!this.Band.Columns[i].hasCells())
			continue;
		if(row)
		{
			if(colspan>1)
			{
				colspan--;
				continue;
			}
			var cellSplit;
			if(cell)
			{
				cellSplit=cell.id.split("_");
				if(parseInt(cellSplit[cellSplit.length-1],10)>i)
					ri--;
				else
				{
					cell=cell.nextSibling;
					if(cell)
						colspan=cell.colSpan;
				}
			}
		}
		ri++;
	}
	return ri;
},
"getFixedHeaderIndicator",
function()
{
	if(this.FixedHeaderIndicator!=0)
		return this.FixedHeaderIndicator;
	if(this.Band.FixedHeaderIndicator!=0)
		return this.Band.FixedHeaderIndicator;
	return this.Band.Grid.FixedHeaderIndicator;
},
"getValueFromString",
function(value)
{
	if(value==null || typeof(value)=="undefined")
		return null;
	value=value.toString();
	if(this.AllowNull && value==this.getNullText())
		return null;
	return igtbl_valueFromString(value,this.DataType);
}
,"_getHeadTags",
function(withAddRow)
{
	var elem=null;
	if(this.Id)
		elem=igtbl_getDocumentElement(this.Id);
	elem=igtbl_getArray(elem);
	if(withAddRow)
	{
		var addRow=this.Band.Grid.Rows.AddNewRow;
		var addNewPresent=(addRow && addRow.isFixedTop());
		if(!addNewPresent)
			return elem;

		var ri=this.Band.firstActiveCell;
		var columns=this.Band.Columns;
		for(var i=0;i<this.Index;i++)
			if(columns[i].hasCells())
				ri++;
		if(this.getFixed()===false)
		{
			var fnfRi=this.Band.firstActiveCell;
			for(var i=0;i<columns.length && columns[i].getFixed();i++)
				if(columns[i].hasCells())
					fnfRi++;
			ri=ri-fnfRi;
			var tbl=addRow.Element.cells[fnfRi].firstChild.firstChild;
			elem[elem.length]=tbl.rows[0].cells[ri];
		}
		else
			elem[elem.length]=addRow.Element.cells[ri];
	}
	return elem;
},
"_getFootTags",
function(withAddRow)
{
	var elem=null;
	if(this.fId)
		elem=igtbl_getDocumentElement(this.fId);
	elem=igtbl_getArray(elem);
	if(withAddRow)
	{
		var addRow=this.Band.Grid.Rows.AddNewRow;
		var addNewPresent=(addRow && addRow.isFixedBottom());
		if(!addNewPresent)
			return elem;

		var ri=this.Band.firstActiveCell;
		var columns=this.Band.Columns;
		for(var i=0;i<this.Index;i++)
			if(columns[i].hasCells())
				ri++;
		if(this.getFixed()===false)
		{
			var fnfRi=this.Band.firstActiveCell;
			for(var i=0;i<columns.length && columns[i].getFixed();i++)
				if(columns[i].hasCells())
					fnfRi++;
			ri=ri-fnfRi;
			var tbl=addRow.Element.cells[fnfRi].firstChild.firstChild;
			elem[elem.length]=tbl.rows[0].cells[ri];
		}
		else
			elem[elem.length]=addRow.Element.cells[ri];
	}
	return elem;
},
"_getColTags",
function(withAddRow)
{
	if(!this.hasCells())
		return null;
	var band=this.Band;
	var fac=band.firstActiveCell;
	var g=band.Grid;
	var columns=band.Columns;
	var res=new Array();
	var gColOffs=fac;
	if(!this.getHidden())
	{
		for(var i=0;i<this.Index;i++)
			if(columns[i].getVisible())
				gColOffs++;
	}
	else
	{
		for(var i=0;i<columns.length;i++)
			if(columns[i].hasCells())
				gColOffs++;
		for(var i=columns.length-1;i>=this.Index;i--)
			if(columns[i].getHidden())
				gColOffs--;
	}
	var fnfColumn=null; 
	var lColOffs=0;
	var fnfRi=fac;
	if(this.getFixed()===false)
	{
		fnfColumn=this;
		while(fnfColumn.Index>0 && !this.Band.Columns[fnfColumn.Index-1].getFixed())
			fnfColumn=this.Band.Columns[fnfColumn.Index-1];
		for(var i=0;i<fnfColumn.Index;i++)
		{
			if(columns[i].getVisible())
				lColOffs++;
			if(columns[i].hasCells())
				fnfRi++;
		}
		lColOffs=gColOffs-lColOffs-fac;
	}
	else
		lColOffs=gColOffs;
	var addRow=g.Rows.AddNewRow;
	var addNewHead=(addRow && addRow.isFixedTop());
	var addNewFoot=(addRow && addRow.isFixedBottom());
	var hAr=this._getHeadTags();
	if(hAr)
	{
		var cg;
		for(var i=0;i<hAr.length;i++)
		{
			if(this.getFixed()===false)
			{
				var nfth=hAr[i].parentNode;
				while(nfth && nfth.tagName!="TH")
					nfth=nfth.parentNode;
				if(nfth)
				{
					cg=nfth.parentNode.parentNode.previousSibling;
					if(cg)
						res[res.length]=cg.childNodes[gColOffs];
				}
			}
			cg=hAr[i].parentNode.parentNode.previousSibling;
			if(cg)
				res[res.length]=cg.childNodes[lColOffs];
		}
	}
	var fAr=this._getFootTags();
	if(fAr)
	{
		var cg;
		for(var i=0;i<fAr.length;i++)
		{
			if(this.getFixed()===false)
			{
				var nfth=fAr[i].parentNode;
				while(nfth && nfth.tagName!="TH")
					nfth=nfth.parentNode;
				if(nfth)
				{
					cg=nfth.parentNode.parentNode.previousSibling;
					if(addNewFoot)
						cg=cg.previousSibling;
					if(cg)
						res[res.length]=cg.childNodes[gColOffs];
				}
			}
			if(this.Band.Index==0 && this.Band.Grid.StatFooter)
			{
				cg=fAr[i].parentNode.parentNode.previousSibling;
				if(this.getFixed()!==false && addNewFoot)
					cg=cg.previousSibling;
				if(cg)
					res[res.length]=cg.childNodes[lColOffs];
			}
		}
	}
	if(withAddRow && (addNewHead || addNewFoot) && this.getFixed()===false)
	{
		cg=addRow.Element.cells[fnfRi].firstChild.firstChild.firstChild;
		res[res.length]=cg.childNodes[lColOffs];
	}
	if(res.length>0)
		return res;
	return null;
},
"_insertCols",
function(front,width)
{
	var cols=this._getColTags(true);
	for(var i=0;i<cols.length;i++)
	{
		if(cols[i])
		{
			var col=document.createElement("COL");
			col.width=width;
			var cg=cols[i].parentNode;
			if(front)
				cg.insertBefore(col,cols[i]);
			else
			{
				if(cols[i].nextSibling)
					cg.insertBefore(col,cols[i].nextSibling);
				else
					cg.appendChild(col);
			}
		}
	}
},
"_reId",
function(i)
{
	if(i==this.Index) return;
	this._rec=true;
	for(var j=0;j<this.Band.Columns.length;j++)
	{
		var col=this.Band.Columns[j];
		if(!col._rec && col.Index==i)
		{
			col._rec=true;
			this.Band.Columns[j]._reId(j);
			delete col._rec;
		}
	}
	delete this._rec;
	var elem=null;
	var fElem=null;
	column=this;
	if(column.hasCells())
	{
		if(this.Id)
			elem=this._getHeadTags(true);
		else
			elem=this.colElem;
		if(this.fId)
			fElem=this._getFootTags(true);
		else
			fElem=this.colFElem;
	}
	column.Id=this.Band.Grid.Id
		+"_"
		+"c_"+this.Band.Index.toString()+"_"+i.toString();
	column.Index=i;
	if(this.Band.ColFootersVisible==1)
		column.fId=this.Band.Grid.Id
			+"_"
			+"f_"+this.Band.Index.toString()+"_"+i.toString();
	if(elem)
		for(var j=0;j<elem.length;j++)
		{
			c=elem[j];
			if(c && c.tagName=="TH")
			{
				c.id=column.Id;
				c.setAttribute("columnNo",i.toString());
			}
			else if(c)
			{
				var r=c.parentNode;
				while(r && (r.tagName!="TR" || !r.getAttribute("level")))
					r=r.parentNode;
				if(r)
				{
					cid=r.id.split("_");
					cid[0]=cid[0].substr(0,cid[0].length-1)+"c";
					cid[cid.length]=i.toString();
					c.id=cid.join("_")
				}
			}
		}
	if(fElem)
		for(var j=0;j<fElem.length;j++)
		{
			c=fElem[j];
			if(c && c.tagName=="TH")
				c.id=column.fId;
			else if(c)
			{
				var r=c.parentNode;
				while(r && (r.tagName!="TR" || !r.getAttribute("level")))
					r=r.parentNode;
				if(r)
				{
					cid=r.id.split("_");
					cid[0]=cid[0].substr(0,cid[0].length-1)+"c";
					cid[cid.length]=i.toString();
					c.id=cid.join("_")
				}
			}
		}
	igtbl_dispose(elem);
	igtbl_dispose(fElem);
	this._reIded=true;
}
];
for(var i=0;i<igtbl_ptsColumn.length;i+=2)
	igtbl_Column.prototype[igtbl_ptsColumn[i]]=igtbl_ptsColumn[i+1];

// Client events object
igtbl_Events.prototype=new igtbl_WebObject();
igtbl_Events.prototype.constructor=igtbl_Events;
igtbl_Events.base=igtbl_WebObject.prototype;
function igtbl_Events(grid)
{
	if(arguments.length>0)
		this.init(grid);
}
var igtbl_ptsEvents=[
"init",
function(grid)
{
	igtbl_Events.base.init.apply(this,["events",null,grid.Node?grid.Node.selectSingleNode("ClientSideEvents"):null]);

	var defaultProps=new Array("AfterCellUpdate","AfterColumnMove","AfterColumnSizeChange","AfterEnterEditMode","AfterExitEditMode",
								"AfterRowActivate","AfterRowCollapsed","AfterRowDeleted","AfterRowTemplateClose","AfterRowTemplateOpen",
								"AfterRowExpanded","AfterRowInsert","AfterRowSizeChange","AfterSelectChange","AfterSortColumn",
								"BeforeCellChange","BeforeCellUpdate","BeforeColumnMove","BeforeColumnSizeChange","BeforeEnterEditMode",
								"BeforeExitEditMode","BeforeRowActivate","BeforeRowCollapsed","BeforeRowDeleted","BeforeRowTemplateClose",
								"BeforeRowTemplateOpen","BeforeRowExpanded","BeforeRowInsert","BeforeRowSizeChange","BeforeSelectChange",
								"BeforeSortColumn","ClickCellButton","CellChange","CellClick","ColumnDrag","ColumnHeaderClick","DblClick",
								"EditKeyDown","EditKeyUp","InitializeLayout","InitializeRow","KeyDown","KeyUp","MouseDown","MouseOver",
								"MouseOut","MouseUp","RowSelectorClick","TemplateUpdateCells","TemplateUpdateControls","ValueListSelChange",
								
								"BeforeRowUpdate","AfterRowUpdate",
								"BeforeXmlHttpRequest","AfterXmlHttpResponseProcessed",
								"XmlHTTPResponse"
								,"XmlVirtualScroll"
								);
	var eventsArray;
	try{eventsArray=eval("igtbl_"+grid.Id+"_Events");}catch(e){}
	if(eventsArray)
		for(var i=0;i<eventsArray.length;i++)
			this[defaultProps[i]]=eventsArray[i];
	igtbl_dispose(defaultProps);
}];
for(var i=0;i<igtbl_ptsEvents.length;i+=2)
	igtbl_Events.prototype[igtbl_ptsEvents[i]]=igtbl_ptsEvents[i+1];

// Rows collection object
igtbl_Rows.prototype=new igtbl_WebObject();
igtbl_Rows.prototype.constructor=igtbl_Rows;
igtbl_Rows.base=igtbl_WebObject.prototype;
function igtbl_Rows(node,band,parentRow)
{
	if(arguments.length>0)
	{
		var element=null;
		if(band.Index==0 && !parentRow)
			element=band.Grid.Element.tBodies[0];
		else if(parentRow && parentRow.Element)
		{
			if(parentRow.GroupByRow)
			{
				var tb=parentRow.Element.childNodes[0].childNodes[0].tBodies[0];
				if(tb.childNodes.length>1)
					this.Element=tb.childNodes[1].childNodes[0].childNodes[0].tBodies[0];
			}
			else if(parentRow.Element.nextSibling && parentRow.Element.nextSibling.getAttribute("hiddenRow"))
				this.Element=parentRow.Element.nextSibling.childNodes[parentRow.Band.IndentationType==2?0:parentRow.Band.firstActiveCell].childNodes[0].tBodies[0];
		}
		this.init(element,node,band,parentRow);
	}
}
var igtbl_ptsRows=[
"init",
function(element,node,band,parentRow)
{
	igtbl_Rows.base.init.apply(this,["rows",element,node]);
	
	this.Grid=band.Grid;
	this.Band=band;
	this.ParentRow=parentRow;
	this.rows=new Array();
	this.length=0;
	if(node)
	{
		this.SelectedNodes=node.selectNodes("R");
		if(!this.SelectedNodes.length)
		{
			this.SelectedNodes=node.selectNodes("Group");
			if(this.SelectedNodes.length)
				this.GroupColId=this.SelectedNodes[0].getAttribute("lit:groupRow");
		}
		this.length=this.SelectedNodes.length;
	}
	else
	{
		if(parentRow)
			this.length=parentRow.ChildRowsCount;
		else
		{
			this.length=this.Element.childNodes.length;
			for(var i=0;i<this.Element.childNodes.length;i++)
			{
				var r=this.Element.childNodes[i];
				if(r.getAttribute("hiddenRow")
				|| r.getAttribute("addNewRow")
				)
					this.length--;
			}
		}
	}
	if(this.Element)
		this.Element.Object=this;
	this.lastRowId="";
	if(!this.ParentRow || !this.ParentRow.GroupByRow)
	{
		
		var anr=igtbl_getElementById(this.Grid.Id+"_anr"+(this.ParentRow?"_"+this.ParentRow.getLevel(true):""));
		if(anr)
			this.AddNewRow=new igtbl_AddNewRow(anr,this);
	}
},
"getRow",
function(rowNo,rowElement)
{
	if(typeof(rowNo)!="number")
	{
		rowNo=parseInt(rowNo);
		if(isNaN(rowNo))
			return null;
	}
	if(rowNo<0 || !this.Element || !this.Element.childNodes)
		return null;
	if(rowNo>=this.length)
	{
		if(this.length>this.rows.length)
			this.rows[this.length-1]=null;
		return null;
	}
	if(rowNo>=this.rows.length)
		this.rows[this.length-1]=null;
	if(!this.rows[rowNo])
	{
		var row=rowElement;
		if(!row)
		{
			var cr=0;
			if(this.Grid.Bands.length==1 && !this.Grid.Bands[0].IsGrouped)
			{
				var adj=0;
				if(!igtbl_getElementById(this.Grid.Id+"_hdiv") && this.Grid.Bands[0].AddNewRowVisible==1 && this.Grid.Bands[0].AddNewRowView==1)
					adj++;
				row=this.Element.childNodes[rowNo+adj];
			}
			else
				for(var i=0;i<this.Element.childNodes.length;i++)
				{
					var r=this.Element.childNodes[i];
					if(!r.getAttribute("hiddenRow")
						&& !r.getAttribute("addNewRow")
					)
					{
						if(rowNo==cr)
						{
							row=this.Element.childNodes[i];
							break;
						}
						cr++;
					}
				}
		}
		if(!row)
			return null;
		this.rows[rowNo]=new igtbl_Row(row,(this.Node?this.SelectedNodes[rowNo]:null),this,rowNo);
	}
	return this.rows[rowNo];
},

"getRowById",
function(rowId)
{
	for(var i=0;i<this.length;i++)
	{
		var row=this.getRow(i);
		if(row.Element.id==rowId)
			return row;
	}
	return null;
},
"getColumn",
function(colNo)
{
	var thead=this.Element.previousSibling;
	if(!thead || thead.tagName!="THEAD")
		return;
	var j=-1;
	for(var i=0;i<this.Band.Columns.length;i++)
	{
		if(this.Band.Columns[i].hasCells())
			j++;
		if(i==colNo)
			break;
	}
	if(j<0 || j>=this.Band.Columns.length)
		return null;
	return thead.firstChild.cells[j+this.Band.firstActiveCell];
},
"indexOf",
function(row)
{
	if(row.IsAddNewRow)
			return -1;
	if(row.Node)
		return parseInt(row.Node.getAttribute("i"),10);
	if(this.Grid.Bands.length==1 && !this.Grid.Bands[0].IsGrouped)
	{
		var index=row.Element.sectionRowIndex;
		if(this.Band.AddNewRowVisible==1 && this.Band.AddNewRowView==1 && !this.Grid.StatHeader)
			index--;
		return index;
	}
	var level=-1;
	var rId=row.Element.id,rows=this.Element.rows;
	for(var i=0;i<rows.length;i++)
	{
		var r=rows[i];
		if(!r.getAttribute("hiddenRow")
			&& !r.getAttribute("addNewRow")
		)
			level++;
		else
			continue;
		if(r.id==rId)
			return level;
	}
	return -1;
},
"insert",
function(row,rowNo)
{
	var g=this.Grid;
	if(!row || row.OwnerCollection && row.OwnerCollection!=this)
		return false;
	if(!g._isSorting)
	{
		if(g.fireEvent(g.Events.BeforeRowInsert,[g.Id,(this.ParentRow?this.ParentRow.Element.id:""),row.Element.id,rowNo])==true)
			return false;
	}
	var row1=this.getRow(rowNo);
	if(row1)
	{
		if(this.rows.splice)
			this.rows.splice(rowNo,0,row);
		else
			this.rows=this.rows.slice(0,rowNo).concat(row,this.rows.slice(rowNo));
		this.Element.insertBefore(row.Element,row1.Element);
		if(row.Expandable && row.HiddenElement && !row.GroupByRow)
			this.Element.insertBefore(row.HiddenElement,row1.Element);
		if(this.Node)
		{
			
			var curNode=row.Node;
			var curIndex=igtbl_parseInt(row1.Node.getAttribute("i"));
			this.Node.insertBefore(row.Node,row1.Node);
			while(curNode && curNode.nodeName==
			"R"
			)
			{
				curNode.setAttribute("i",curIndex++);
				curNode=curNode.nextSibling;
			}
		}
	}
	else
	{
		this.rows[this.rows.length]=row;
		this.Element.appendChild(row.Element);
		if(row.Expandable && row.HiddenElement && !row.GroupByRow)
			this.Element.appendChild(row.HiddenElement);
		if(this.Node)
			this.Node.appendChild(row.Node);
	}
	this.length++;
	if(typeof(row._removedFrom)!="undefined")
	{
		g._removeChange("DeletedRows",row);
		g._recordChange("MoveRow",row,row._removedFrom+":"+row.getLevel(true));		
		
		if (row._Changes.MoveRow.length)
			row._Changes.MoveRow[row._Changes.MoveRow.length-1].Node.setAttribute("Level",row._removedFrom);
		else
			row._Changes.MoveRow.Node.setAttribute("Level",row._removedFrom);
		
		delete row._removedFrom;
	}
	if(!g._isSorting)
	{
		var oldNPB=g.NeedPostBack;
		g.fireEvent(g.Events.AfterRowInsert,[g.Id,row.Element.id,rowNo]);
		if(!oldNPB && g.NeedPostBack && !g.Events.AfterRowInsert[1]&2)
			g.NeedPostBack=false;
		if(g.NeedPostBack)
			igtbl_doPostBack(g.Id,"");
	}
	return true;
},
"remove",
function(rowNo,fireEvents)
{
	var row=this.getRow(rowNo);
	if(!row)
		return;
	if(typeof(fireEvents)=="undefined") fireEvents=true;
	if(!this.Grid._isSorting)
	{
		this.setLastRowId();
		if(fireEvents && this.Grid.fireEvent(this.Grid.Events.BeforeRowDeleted,[this.Grid.Id,row.Element.id])==true)
			return null;
		this.Grid._recordChange("DeletedRows",row);
		row._removedFrom=row.getLevel(true);
	}
	this.Element.removeChild(row.Element);
	if(row.Expandable && row.HiddenElement && !row.GroupByRow)
		this.Element.removeChild(row.HiddenElement);
	if(row.Node)
	{
		
		var curNode=row.Node.nextSibling;
		row.Node.parentNode.removeChild(row.Node);
		while(curNode && curNode.nodeName==
			"R"
		)
		{
			curNode.setAttribute("i",igtbl_parseInt(curNode.getAttribute("i"))-1);
			curNode=curNode.nextSibling;
		}
		var rows=row.OwnerCollection;
		rows.SelectedNodes=rows.Node.selectNodes("R");
		if(!rows.SelectedNodes.length)
			rows.SelectedNodes=rows.Node.selectNodes("Group");
	}
	if(this.rows.splice)
		this.rows.splice(rowNo,1);
	else
		this.rows=this.rows.slice(0,rowNo).concat(this.rows.slice(rowNo+1));
	this.length--;
	if(fireEvents && !this.Grid._isSorting)
		this.Grid.fireEvent(this.Grid.Events.AfterRowDeleted,[this.Grid.Id,row.Element.id]);
	return row;
},
"sort",
function(sortedCols)
{
	var issortch=false;
	if(!this.Grid._isSorting)
		this.Grid._isSorting=issortch=true;
	if(igtbl_clctnSort)
		igtbl_clctnSort.apply(this,[sortedCols]);
	if(issortch)
		delete this.Grid._isSorting;
},
"getFooterText",
function(columnKey)
{
	var tFoot;
	if(this.Band.Index==0 && this.Grid.StatFooter)
		tFoot=this.Grid.StatFooter.Element;
	else
		tFoot=this.Element.nextSibling;
	var col=this.Band.getColumnFromKey(columnKey);
	if(tFoot && tFoot.tagName=="TFOOT" && col)
	{
		var fId=this.Grid.Id
			+"_"
			+"f_"+this.Band.Index+"_"+col.Index;
		for(var i=0;i<tFoot.rows[0].childNodes.length;i++)
			if(tFoot.rows[0].childNodes[i].id==fId)
				return igtbl_getInnerText(tFoot.rows[0].childNodes[i]);
	}
	return "";
},
"setFooterText",
function(columnKey,value,useMask)
{
	var tFoot;
	if(this.Band.Index==0 && this.Grid.StatFooter)
		tFoot=this.Grid.StatFooter.Element;
	else
		tFoot=this.Element.nextSibling;
	var col=this.Band.getColumnFromKey(columnKey);
	if(tFoot && tFoot.tagName=="TFOOT" && col)
	{
		var fId=this.Grid.Id
			+"_"
			+"f_"+this.Band.Index+"_"+col.Index;
		if(useMask && col.MaskDisplay)
			value=igtbl_Mask(this.Grid.Id,value.toString(),col.DataType,col.MaskDisplay);
		var foot=igtbl_getChildElementById(tFoot,fId);
		if(foot)
		{
			if(igtbl_trim(value)=="")
				value="&nbsp;";
			if(foot.childNodes.length>0 && foot.childNodes[0].tagName=="NOBR")
				value="<nobr>"+value+"</nobr>";
			foot.innerHTML=value;
		}
	}
},
"render",
function()
{
	var strTransform=this.applyXslToNode(this.Node);
	if(strTransform)
	{
		var anId=(this.AddNewRow?this.AddNewRow.Id:null);
		this.Grid._innerObj.innerHTML=strTransform;
		var tbl=this.Element.parentNode;
		tbl.replaceChild(this.Grid._innerObj.firstChild.firstChild,this.Element);
		if(this.AddNewRow)
		{
			if(this.Band.Index>0 || this.Band.AddNewRowView==1 && !igtbl_getElementById(this.Grid.Id+"_hdiv") || this.Band.AddNewRowView==2 && !igtbl_getElementById(this.Grid.Id+"_fdiv"))
			{
				var anr=this.AddNewRow.Element;
				anr.parentNode.removeChild(anr);
				if(this.Band.AddNewRowView==1 && tbl.tBodies[0].rows.length>0)
					tbl.tBodies[0].insertBefore(anr,tbl.tBodies[0].rows[0]);
				else
					tbl.tBodies[0].appendChild(anr);
			}
			this.AddNewRow.Element=igtbl_getElementById(anId);
			this.AddNewRow.Element.Object=this.AddNewRow;
		}
		this.Element=tbl.tBodies[0];
		this.Element.Object=this;
		for(var i=0;i<this.Band.Columns.length;i++)
		{
			var column=this.Band.Columns[i];
			if(column.Selected && column.hasCells())
			{
				var col=this.getColumn(i);
				if(col)
					igtbl_selColRI(this.Grid.Id,col,this.Band.Index,i);
			}
		}
	}
},
"applyXslToNode",
function(node,rowToStart)
{
	if(!node) return "";
	if(typeof(rowToStart)=="undefined")
		rowToStart=0;
	var xslProc=this.Grid.XslProcessor;

	var oldColumns=node.selectSingleNode("Columns");
	if(oldColumns)
		node.removeChild(oldColumns);
	node.appendChild(this.Band.Columns.Node.cloneNode(true));

	xslProc.input=node;
	xslProc.addParameter("gridName",this.Grid.Id);
	if(this.SelectedNodes && (!this.SelectedNodes.length || this.SelectedNodes[0].nodeName!="Group"))
	{
		var fac=this.Band.firstActiveCell;
		xslProc.addParameter("fac",fac);
		var rs=this.Band.getRowSelectors();
		xslProc.addParameter("rs",rs);
		if(fac>1 || rs==2 && fac==1)
		{
			xslProc.addParameter("expAreaClass",this.Band.getExpAreaClass());
			xslProc.addParameter("expandImage","<img src="+this.Band.getExpandImage()+" border='0' onclick=\"igtbl_toggleRow(event);\">");
		}
		if(fac>0 && rs!=2)
		{
			xslProc.addParameter("rowLabelClass",this.Band.getRowLabelClass());
			xslProc.addParameter("blankImage","<img src='"+this.Grid.BlankImage+"' border=0 imgType='blank' style='visibility:hidden;'>");
			xslProc.addParameter("rowLabelBlankImage","<img src='"+(this.Grid.RowLabelBlankImage?this.Grid.RowLabelBlankImage:this.Grid.BlankImage)+"' border=0 imgType='blank' >");
		}
		xslProc.addParameter("itemClass",this.Band.getItemClass());
		xslProc.addParameter("altClass",this.Band.getAltClass());
		xslProc.addParameter("selClass",this.Band.getSelClass());
		if(this.Band._optSelectRow)
			xslProc.addParameter("optSelectRow",this.Band._optSelectRow);
		if(this.Grid.UseFixedHeaders)
		{
			xslProc.addParameter("useFixedHeaders","true");
			var nfspan=0;
			for(var i=0;i<this.Band.Columns.length;i++)
				if(!this.Band.Columns[i].getFixed())
					nfspan++;
			xslProc.addParameter("nfspan",nfspan);
			xslProc.addParameter("fixedScrollLeft",this.Grid._scrElem.scrollLeft?"left:"+(-this.Grid._scrElem.scrollLeft).toString()+"px;":"");
		}
	}
	else
	{
		if(this.Grid.UseFixedHeaders)
			xslProc.addParameter("useFixedHeaders","true");
		xslProc.addParameter("grpClass",this.Band.getGroupByRowClass());
		xslProc.addParameter("expandImage","<img src="+this.Band.getExpandImage()+" border='0' onclick=\"igtbl_toggleRow(event);\" onmousedown=\"return igtbl_cancelEvent(event);\" onmouseup=\"return igtbl_cancelEvent(event);\">");
		if(this.Grid.TableLayout>0)
			xslProc.addParameter("tableLayout",this.Grid.TableLayout);
		var wdth=0;
		if(this.Grid.Bands.length>0)
			wdth+=22;
		if(this.Band.getRowSelectors()==1)
			wdth+=22;
		for(var i=0;i<this.Band.Columns.length;i++)
		{
			if(this.Band.Columns[i].getVisible())
				wdth+=this.Band.Columns[i].getWidth();
		}
		var j=this.Band.Indentation;
		for(var i=this.Band.SortedColumns.length-1;i>=0;i--)
		{
			var col=igtbl_getColumnById(this.Band.SortedColumns[i]);
			if(!col.IsGroupBy)
				continue;
			if(this.GroupColId==this.Band.SortedColumns[i])
				break;
			j+=this.Band.Indentation;
		}
		wdth+=j;
		xslProc.addParameter("grpWidth",wdth>0?wdth:"100%");
	}
	var prL="";
	if(this.ParentRow)
	{
		prL=this.ParentRow.Element.id.split("_");
		prL=prL.slice(1);
		prL=prL.slice(1);
		prL=prL.join("_")+"_";
	}
	xslProc.addParameter("parentRowLevel",prL);
	xslProc.addParameter("rowHeight",this.Band.DefaultRowHeight);
	xslProc.addParameter("rowToStart",rowToStart);
	if(this.Grid.IsXHTML)
		xslProc.addParameter("isXhtml",this.Grid.IsXHTML);
	xslProc.transform();
	return xslProc.output;
},
"addNew",
function()
{
	var g=this.Grid;
	return igtbl_rowsAddNew(g.Id,this.ParentRow);
},
"dispose",
function(self)
{
	for(var i=0;i<this.rows.length;i++)
	{
		if(this.rows[i])
		{
			if(this.rows[i].Rows)
				this.rows[i].Rows.dispose(true);
			igtbl_cleanRow(this.rows[i]);
		}
	}
	igtbl_dispose(this.rows);
	delete this.rows;
	if(self)
	{
		this.Grid=null;
		this.Band=null;
		this.ParentRow=null;
		if(this.AddNewRow)
			igtbl_cleanRow(this.AddNewRow);
		igtbl_dispose(this);
	}
	else
		this.rows=new Array();
},
"reIndex",
function(sRow)
{
	for(var i=sRow;i<this.length;i++)
		this.getRow(i).Node.setAttribute("i",i.toString());
},
"repaint",
function()
{
	var strTransform=this.applyXslToNode(this.Node);
	if(strTransform)
	{
		var anId=(this.AddNewRow?this.AddNewRow.Id:null);
		this.Grid._innerObj.innerHTML=strTransform;
		var tbl=this.Element.parentNode;
		var newEl=this.Grid._innerObj.firstChild.firstChild;
		for(var i=this.rows.length-1;i>=0;i--)
			if(this.rows[i])
			{
				if(this.rows[i].HiddenElement)
				{
					if(i==newEl.rows.length-1)
						newEl.appendChild(this.rows[i].HiddenElement);
					else
						newEl.insertBefore(this.rows[i].HiddenElement,newEl.rows[i+1]);
					var img=newEl.rows[i].firstChild;
					if(this.rows[i].getExpanded() && img)
					{
						img=newEl.rows[i].firstChild.firstChild;
						if(img && img.tagName=="IMG")
							img.src=this.Band.getCollapseImage();
					}
				}
				var row=this.rows[i];
				row.Element=newEl.rows[i];
				row.Element.Object=row;
				var metFixed=false;
				var ri=0;
				for(var j=0;row.cells && j<row.cells.length;j++)
				{
					var cell=row.cells[j];
					if(this.Band.Columns[j].getFixed()===false && !metFixed)
					{
						metFixed=true;
						ri=0;
					}
					if(cell)
					{
						cell.Column=this.Band.Columns[j];
						if(cell.Column.hasCells())
						{
							if(cell.Column.getFixed()===false)
							{
								rowEl=row.Element.cells[row.Element.cells.length-1];
								cell.Element=rowEl.firstChild.firstChild.rows[0].cells[ri];
							}
							else
								cell.Element=row.Element.cells[cell.Column.getRealIndex()+this.Band.firstActiveCell];
							cell.Element.Object=cell;
							cell.Id=cell.Element.id;
							if(cell.getSelected() || row.getSelected())
								cell.selectCell();
							ri++;
						}
						else
							cell.Element=null;
					}
				}
			}
		var anr;
		if(this.AddNewRow)
		{
			if(this.Band.AddNewRowView==1 && (this.Band.Index>0 || !igtbl_getElementById(this.Grid.Id+"_hdiv")))
				anr=this.AddNewRow.Element;
		}
		if(anr)
		{
			while(anr.nextSibling)
				anr.parentNode.removeChild(anr.nextSibling)
			while(newEl.rows.length)
				anr.parentNode.appendChild(newEl.rows[0]);
		}
		else
			tbl.replaceChild(newEl,this.Element);
		
		this.Element=tbl.tBodies[0];
		this.Element.Object=this;
		if(this.AddNewRow)
		{
			if(this.Band.AddNewRowView==2 && (this.Band.Index>0 || !igtbl_getElementById(this.Grid.Id+"_fdiv")))
			{
				anr=this.AddNewRow.Element;
				tbl.tBodies[0].appendChild(anr);
			}
			this.AddNewRow.Element=igtbl_getElementById(anId);
			this.AddNewRow.Element.Object=this.AddNewRow;
		}
	}
},
"_buildSortXmlQueryString",
function()
{
	var g=this.Grid;
	var row=this.ParentRow;
	g.QueryString="Sort\x01";
	if(row)
		g.QueryString+=row.getLevel(true);
	var sqlWhere="";
	var sortOrder="";
	for(var i=0;i<=this.Band.Index;i++)
	{
		var cr=row;
		while(cr && cr.Band!=g.Bands[i])
			cr=cr.ParentRow;
		if(g.Bands[i].DataKeyField&&cr&&cr.get("lit:DataKey"))
		
			sqlWhere+=cr._generateSqlWhere(g.Bands[i].DataKeyField,cr.get("lit:DataKey"));
		sqlWhere+=(i==this.Band.Index?"":";");
	}
	for(var i=0;i<g.Bands.length;i++)
	{
		var so="";
		for(var j=0;j<g.Bands[i].SortedColumns.length;j++)
		{
			var col=igtbl_getColumnById(g.Bands[i].SortedColumns[j]);
			so+=col.Key+(col.SortIndicator==2?" DESC":"")+(j<g.Bands[i].SortedColumns.length-1?",":"");
		}
		sortOrder+=so+(i==g.Bands.length-1?"":";");
	}
	g.QueryString+="\x02"+sqlWhere;
	g.QueryString+="\x02"+sortOrder;
	if(this.Band.ColumnsOrder)
		g.QueryString+="\x02"+this.Band.ColumnsOrder;
},
"sortXml",
function(sortedCols)
{
	if(this.Band.SortedColumns.length==0)
		return;
	var g=this.Grid;
	this._buildSortXmlQueryString();
	g.RowToQuery=this.ParentRow;
	g.xmlHttpRequest(g.eReqType.Sort);
},
"getLastRowId",
function()
{
	if(!this.lastRowId)
		this.setLastRowId();
	return this.lastRowId;
},
"setLastRowId",
function(lrId)
{
	if(arguments.length==0 && !this.lastRowId)
	{
		if(this.length>0)
			this.lastRowId=this.getRow(this.length-1).Element.id;
	}
	else if(lrId)
		this.lastRowId=lrId;
}];
for(var i=0;i<igtbl_ptsRows.length;i+=2)
	igtbl_Rows.prototype[igtbl_ptsRows[i]]=igtbl_ptsRows[i+1];

// Row object
igtbl_Row.prototype=new igtbl_WebObject();
igtbl_Row.prototype.constructor=igtbl_Row;
igtbl_Row.base=igtbl_WebObject.prototype;
function igtbl_Row(element,node,rows,index)
{
	if(arguments.length>0)
		this.init(element,node,rows,index);
}
var igtbl_ptsRow=[
"init",
function(element,node,rows,index)
{
	igtbl_Row.base.init.apply(this,["row",element,node]);

	var gs=rows.Band.Grid;
	var gn=gs.Id;
	this.gridId=gs.Id;
	var row=this.Element;
	row.Object=this;
	this.OwnerCollection=rows;
	if(this.OwnerCollection)
		this.ParentRow=this.OwnerCollection.ParentRow;
	else
		this.ParentRow=null;
	this.Band=this.OwnerCollection.Band;
	this.GroupByRow=false;
	this.GroupColId=null;
	if(row.getAttribute("groupRow"))
	{
		this.GroupByRow=true;
		this.GroupColId=row.getAttribute("groupRow");
		var sTd=row.childNodes[0].childNodes[0].tBodies[0].childNodes[0].childNodes[0];
		this.MaskedValue=sTd.getAttribute("cellValue");
		this.Value=this.MaskedValue;
		if(sTd.getAttribute(igtbl_sUnmaskedValue))
			this.Value=sTd.getAttribute(igtbl_sUnmaskedValue);
		this.Value=igtbl_getColumnById(this.GroupColId).getValueFromString(this.Value);
	}
	var fr=igtbl_getFirstRow(row);
	this.Expandable=((fr.nextSibling && fr.nextSibling.getAttribute("hiddenRow") || this.Element.getAttribute("showExpand")));
	this.ChildRowsCount=0;
	this.VisChildRowsCount=0;
	if(this.Expandable)
	{
		if(fr.nextSibling && fr.nextSibling.getAttribute("hiddenRow"))
		{
			this.HiddenElement=fr.nextSibling;
			if(this.getExpanded() && !gs.ExpandedRows[this.Element.id])
				gs.ExpandedRows[this.Element.id]=this;
			this.ChildRowsCount=igtbl_rowsCount(igtbl_getChildRows(gn,row));
			this.VisChildRowsCount=igtbl_visRowsCount(igtbl_getChildRows(gn,row));
			this.Rows=new igtbl_Rows((this.Node?this.Node.selectSingleNode("Rs"):null),gs.Bands[rows.Band.Index+(this.GroupByRow?0:1)],this);
			
//* OBSOLETE*
			this.FirstChildRow=this.Rows.getRow(0);
//***********
		}
	}
	this.FirstRow=fr;

	if(!this.GroupByRow)
	{
		this.cells=new Array(this.Band.Columns.length);
		if(gs.UseFixedHeaders)
		{
			for(var i=0;i<this.Element.cells.length;i++)
			{
				if(this.Element.cells[i].childNodes.length>0 && this.Element.cells[i].firstChild.tagName=="DIV" && this.Element.cells[i].firstChild.id.substr(this.Element.cells[i].firstChild.id.length-4)=="_drs")
				{
					this.nfElement=this.Element.cells[i].firstChild.firstChild.childNodes[1].rows[0];
					this.nfElement.Object=this;
					break;
				}
			}
		}
		if(!this.IsAddNewRow)
		{
			var tr=this.Element;
			var cellId=this.Id.split("_");
			var lastIndex=cellId.length;
			cellId[1]="rc";
			var j=0;
			if(this.Band.Grid.Bands.length>1) j++;
			if(this.Band.getRowSelectors()<2) j++;
			var cols=this.Band.Columns;
			var nonFixed=false,colSpan=1;
			for(var i=0;i<cols.length;i++)
			{
				if(colSpan>1)
				{
					colSpan--;
					continue;
				}
				if(cols[i].getFixed()===false && !nonFixed)
				{
					tr=this.nfElement;
					j=0;
					nonFixed=true;
				}
				if(cols[i].hasCells())
				{
					if(tr.cells[j].id)
						break;
					cellId[lastIndex]=cols[i].Index.toString();
					tr.cells[j].id=cellId.join("_");
					colSpan=tr.cells[j].colSpan;
					j++;
				}
			}
		}
	}
	if(this.Node)
	{
		if(!this.Expandable)
		this.Expandable=this.Node.selectSingleNode("Rs")!=null || this.Node.getAttribute("showExpand")=="true";
			
	}
	if(this.Node)
	{
		var dataKey=this.get("lit:DataKey");
		this.DataKey=dataKey?dataKey:"";
	}
	else
	{
		if(this.Element.getAttribute("lit:DataKey"))
			this.DataKey=this.Element.getAttribute("lit:DataKey");
	}
	this.Expanded=this.getExpanded();
	this._Changes=new Object();
	this._dataChanged=0;
	if(gs.ExpandedRows[this.Id])
	{
		var stateChange=gs.ExpandedRows[this.Id];
		stateChange.Object=this;
		gs.ExpandedRows[this.Id]=this;
		if(this.DataKey)
		{
			var value=this.DataKey;
			if(value=="" && typeof(value)=="string") value="\x01";
			ig_ClientState.setPropertyValue(stateChange.Node,"Value",value);
		}
		this._Changes[stateChange.Type]=stateChange;
	}
},
"getDataKey",
function()
{
	 
	
	if (this.DataKey===null) return null;
	var dKey = this.DataKey.split('\x07');
	return dKey;
},
"getIndex",
function(
virtual
)
{
	if(this.Node)
	{
		var index=igtbl_parseInt(this.Node.getAttribute("i"));
		var g=this.Band.Grid;
		if(this.Band.Index==0 && !virtual && g.XmlLoadOnDemandType==2)
		{
			var de=g.getDivElement();
			var topRow=Math.floor(de.scrollTop/g.getDefaultRowHeight());
			index-=topRow;
		}
		return index;
	}
	else if(this.OwnerCollection)
		return this.OwnerCollection.indexOf(this);
	return -1;
},
"toggleRow",
function()
{
	this.setExpanded(!this.getExpanded());
},
"getExpanded",
function(expand)
{
	return (this.Expandable && this.HiddenElement && this.HiddenElement.style.display=="");
},
"setExpanded",
function(expand)
{
	if(this.Band.getExpandable()!=1 || !this.Expandable)
		return;
	if(expand!=false)
		expand=true;
	var gn=this.gridId;
	if(expand==this.getExpanded())
	{
		if(expand && !this._Changes["ExpandedRows"])
			igtbl_stateExpandRow(gn,this,expand);
		return;
	}
	var gs=igtbl_getGridById(gn);
	if(gs._scrElem && gs.IsXHTML && this.GroupByRow && expand && !this.HiddenElement)
		gs._scrElem.scrollLeft=0;
	var rcrRes=true;
	if(gs.LoadOnDemand==3 && !this.HiddenElement)
		rcrRes=this.requestChildRows();
	if(rcrRes)
		this._setExpandedComplete(expand);
},
"_setExpandedComplete",
function(expand)
{
	var gn=this.gridId;
	var gs=igtbl_getGridById(gn);
	if(this.Node)
	{
	var rsn=this.Node.selectSingleNode("Rs");
		
			if(!this.Rows)
				this.Rows=new igtbl_Rows(rsn,gs.Bands[this.Band.Index+(this.GroupByRow?0:1)],this);
			if(!this.HiddenElement)
			{
				this.prerenderChildRows();
				if(rsn)
					this.Rows.render();
			}
	}
	else if(!this.Rows)
	{
		this.Rows=new igtbl_Rows(null,gs.Bands[this.Band.Index+(this.GroupByRow?0:1)],this);
		
		if (gs.LoadOnDemand==0 || gs.LoadOnDemand==3)
			this.prerenderChildRows();
	}
	var srcRow=this.getFirstRow().id;
	var sr=igtbl_getElementById(srcRow);
	var hr=this.HiddenElement;
	var cancel=false;
	if(expand!=false) 
	{
		if(igtbl_fireEvent(gn,gs.Events.BeforeRowExpanded,"(\""+gn+"\",\""+srcRow+"\");")==true)
			cancel=true;
		if(!cancel)
		{
			if(ig_csom.IsNetscape6 && this.GroupByRow)
			{
				var cr=this;
				while(cr && cr.GroupByRow)
				{
					if(!cr._origHeight)
						cr._origHeight=cr.Element.offsetHeight;
					cr=cr.ParentRow;
				}
			}
			if(!gs.NeedPostBack || gs.LoadOnDemand!=0 && this.Rows && (this.Rows.length>0
				|| this.Rows.AddNewRow
				))
			{
				gs.NeedPostBack=false;
				if(hr)
				{
					hr.style.display="";
					hr.style.visibility="";
				}
				sr.childNodes[0].childNodes[0].src=this.Band.getCollapseImage();
			}
			igtbl_stateExpandRow(gn,this,true);
			if(!gs.NeedPostBack)
				igtbl_fireEvent(gn,gs.Events.AfterRowExpanded,"(\""+gn+"\",\""+srcRow+"\");");
		}
	}
	else
	{
		if(igtbl_fireEvent(gn,gs.Events.BeforeRowCollapsed,"(\""+gn+"\",\""+srcRow+"\")")==true)
			cancel=true;
		if(!cancel)
		{
			if(!gs.NeedPostBack)
			{
				if(hr)
				{
					hr.style.display="none";
					hr.style.visibility="hidden";
				}
				sr.childNodes[0].childNodes[0].src=this.Band.getExpandImage();
			}
			igtbl_stateExpandRow(gn,this,false);
			if(this._origHeight)
			{
				var cr=this;
				while(cr && cr.GroupByRow && cr._origHeight)
				{
					cr.Element.firstChild.firstChild.style.height=cr._origHeight;
					cr=cr.ParentRow;
				}
			}
			if(!gs.NeedPostBack)
				igtbl_fireEvent(gn,gs.Events.AfterRowCollapsed,"(\""+gn+"\",\""+srcRow+"\");");
		}
	}
	if(!cancel)
	{
		if(gs.NeedPostBack)
		{
			if(expand!=false) 
				igtbl_moveBackPostField(gn,"ExpandedRows");
			else
				igtbl_moveBackPostField(gn,"CollapsedRows");
		}
	}
	if(gs.XmlLoadOnDemandType!=2)
		gs.alignDivs();
	if(!gs.UseFixedHeaders && (gs.StatHeader || gs.StatFooter))
		gs.alignStatMargins();
	if(gs.NeedPostBack)
		igtbl_doPostBack(gn);
},
"getFirstRow",
function()
{
	return igtbl_getFirstRow(this.Element);
},
"requestChildRows",
function()
{
	if(this.Rows)
		if(this.Node)
		{
			if(this.Rows.Node)
				return true;
		}
		else
			return true;
	var g=this.Band.Grid;
	if(this.Node && this.Node.selectSingleNode("Rs"))
		return true;
	var sqlWhere="";
	var sortOrder="";
	var newLevel="";
	for(var i=0;i<=this.Band.Index;i++)
	{
		var cr=this;
		while(cr && cr.Band!=g.Bands[i])
			cr=cr.ParentRow;
		if(g.Bands[i].DataKeyField && cr.get("lit:DataKey"))
		{
			sqlWhere+=cr._generateSqlWhere(g.Bands[i].DataKeyField,cr.get("lit:DataKey"));
			if(newLevel!=null)
				newLevel+=(i>0?"_":"")+cr.getIndex().toString();
		}
		else
			newLevel=null;
		sqlWhere+=(i==this.Band.Index?"":";");
	}
	g.QueryString="LODXml\x01"+(newLevel==null?this.getLevel(true):newLevel);
	for(var i=0;i<g.Bands.length;i++)
	{
		var so="";
		for(var j=0;j<g.Bands[i].SortedColumns.length;j++)
		{
			var col=igtbl_getColumnById(g.Bands[i].SortedColumns[j]);
			so+=col.Key+(col.SortIndicator==2?" DESC":"")+(j<g.Bands[i].SortedColumns.length-1?",":"");
		}
		sortOrder+=so+(i==g.Bands.length-1?"":";");
	}
	var band=g.Bands[this.Band.Index+1],sCols;
	if(band)
	{
		sCols=band.Index;
		for(var i=0;i<band.SortedColumns.length;i++)
		{
			var col=igtbl_getColumnById(band.SortedColumns[i]);
			sCols+="|"+col.Index;
			sCols+=":"+col.IsGroupBy.toString();
			sCols+=":"+col.SortIndicator;
		}
	}
	g.QueryString+="\x02"+sqlWhere;
	g.QueryString+="\x02"+sortOrder;
	if(band && band.ColumnsOrder)
		g.QueryString+="\x02"+band.ColumnsOrder;
	g.QueryString+="\x02"+sCols;
	g.RowToQuery=this;
	g.xmlHttpRequest(g.eReqType.ChildRows);
	return false;
},
"prerenderChildRows",
function()
{
	if(!this.HiddenElement)
	{
		var g=this.Band.Grid;
		
		var band=this.Rows.Band;
		if(!band.Visible)return;
		
		var hidRow=document.createElement("tr");
		this.HiddenElement=hidRow;
		if(!this.GroupByRow)
		{
			if(this.Element.nextSibling)
				this.Element.parentNode.insertBefore(this.HiddenElement,this.Element.nextSibling);
			else
				this.Element.parentNode.appendChild(this.HiddenElement);
		}
		else
			this.getFirstRow().parentNode.appendChild(this.HiddenElement);
		var rn=this.Element.id.split("_");
		rn[0]=this.gridId+"rh";
		hidRow.id=rn.join("_");
		hidRow.setAttribute("hiddenRow",true);
		hidRow.setAttribute("groupRow",this.GroupColId);
		if(g.IsXHTML && g.UseFixedHeaders)
			hidRow.style.position="relative";
		var majCell;
		var img;		
		var tBody;		
		var childGroupRows=(this.Rows.Node && this.Rows.SelectedNodes[0].nodeName=="Group");

		if(this.GroupByRow)
		{
			var majCell=document.createElement("td");
			hidRow.appendChild(majCell);
			majCell.style.paddingLeft=band.IndentationType==2?0:this.Band.Indentation;
		}
		else
		{
			if(band.IndentationType!=2)
			{
				var ec=document.createElement("td");
				hidRow.appendChild(ec);
				ec.className=this.Band.getExpAreaClass();
				ec.style.borderWidth=0;
				ec.style.textAlign="center";
				ec.style.padding=0;
				ec.style.cursor="default";
				ec.innerHTML="&nbsp;";
				if(this.Band.getRowSelectors()==1)
				{
					var rsc=document.createElement("td");
					hidRow.appendChild(rsc);
					rsc.className=this.Band.getRowLabelClass();
					img=document.createElement("img");
					img.src=g.BlankImage;
					img.border=0;
					img.style.visibility="hidden";
					rsc.appendChild(img);
				}
			}
			majCell=document.createElement("td");
			hidRow.appendChild(majCell);
			majCell.style.overflow="auto";
			majCell.style.width="100%";
			majCell.style.border=0;
			majCell.colSpan=this.Band.VisibleColumnsCount+1+(this.Band.getRowSelectors()==1?1:0);
		}
		
		if(!childGroupRows && (band.HeaderHTML || band.FooterHTML))
		{
			var str="<table>";
			if(band.HeaderHTML)
				str+=band.HeaderHTML;
			str+="<tbody></tbody>";
			if(band.FooterHTML)
				str+=band.FooterHTML;
			str+="</table>";
			majCell.innerHTML=str;
			table=majCell.firstChild;
			tBody=table.tBodies[0];
		}
		else
			table=document.createElement("table");
		rn[0]=this.gridId+"t";
		table.id=rn.join("_");
		table.border=0;
		table.cellPadding=g.Element.cellPadding;
		table.cellSpacing=g.Element.cellSpacing;
		table.setAttribute("bandNo",band.Index);
		table.style.borderCollapse=this.Band.getBorderCollapse();
		
		table.style.tableLayout=(this.GroupColId
			&& (this.Band.Index>0 || g.get("StationaryMarginsOutlookGroupBy")!="True")
			|| g.TableLayout!=1) || (this.Rows.Node && this.Rows.Node.selectSingleNode("Group"))?"auto":"fixed";

		if(childGroupRows)
		{
			majCell.appendChild(table);
			table.width="100%";
			var tHead=document.createElement("thead");
			var tr=document.createElement("tr");
			var th=document.createElement("th");
			th.innerHTML="&nbsp;";
			tr.appendChild(th);
			tHead.appendChild(tr);
			tHead.style.display="none";
			table.appendChild(tHead);
			tBody=document.createElement("tbody");
			table.appendChild(tBody);
		}
		else
		{
			if(!band.HeaderHTML)
			{
				majCell.appendChild(table);
				var colGr=document.createElement("colgroup");
				var col;
				var tableWidth=0;
				if(g.Bands.length>1)
				{
					col=document.createElement("col");
					if(band.Indentation>0)
						col.width=band.Indentation;
					else
						col.style.display="none";
					colGr.appendChild(col);
					if(col.width)
						tableWidth+=parseInt(col.width,10);
				}

				if(band.getRowSelectors()==1)
				{
					col=document.createElement("col");
					col.width=(band.RowLabelWidth?band.RowLabelWidth:"22px");
					colGr.appendChild(col);
					if(col.width)
						tableWidth+=parseInt(col.width,10);
				}
				for(var i=0;i<band.Columns.length;i++)
				{
					var co=band.Columns[i];
					if(co.getVisible())
					{
						col=document.createElement("col");
						if(co.Node && co.Node.getAttribute("lit:width"))
							try{col.width=co.Node.getAttribute("lit:width");}catch(e){;}
						else
							try{col.width=co.getWidth();}catch(e){;}
						colGr.appendChild(col);
					}
				}
				for(var i=0;i<band.Columns.length;i++)
					if(band.Columns[i].getHidden())
					{
						col=document.createElement("col");
						col.width="1px";
						col.style.display="none";
						colGr.appendChild(col);
					}
				if(table.childNodes.length>0)
					table.insertBefore(colGr,table.childNodes[0]);
				else
					table.appendChild(colGr);
				var tHead=document.createElement("thead");
				if(this.Band.Index==0 && this.Band.Grid.StatHeader && this.GroupByRow && g.get("StationaryMarginsOutlookGroupBy")=="True")
					tHead.style.display="none";
				if(table.childNodes.length>1)
					table.insertBefore(tHead,table.childNodes[1]);
				else
					table.appendChild(tHead);
				igtbl_addEventListener(tHead,"mousedown",igtbl_headerClickDown);
				igtbl_addEventListener(tHead,"mouseup",igtbl_headerClickUp);
				igtbl_addEventListener(tHead,"mouseout",igtbl_headerMouseOut);
				igtbl_addEventListener(tHead,"mousemove",igtbl_headerMouseMove);
				igtbl_addEventListener(tHead,"mouseover",igtbl_headerMouseOver);
				igtbl_addEventListener(tHead,"contextmenu",igtbl_headerContextMenu);
				var tr=document.createElement("tr");
				tHead.appendChild(tr);
				var th;

				if(g.Bands.length>1)
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

				if(band.getRowSelectors()==1)
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
				var nfrow=null;
				var setHeight=false;
				for(var i=0;i<band.Columns.length;i++)
				{
					var column=band.Columns[i];
					if(column.hasCells())
					{
						th=document.createElement("th");
						th.id=this.gridId+"_c"+"_"+band.Index+"_"+i.toString();
						th.setAttribute("columnNo",i);
						if(column.getHidden())
							th.style.display="none";
						var headerNode=null;
						if(column.Node)
						{
							headerNode=column.Node.selectSingleNode("Header");
							var titleAttrib;
							if (headerNode && (titleAttrib=headerNode.getAttribute("lit:title")))					
								th.setAttribute("title",unescape(titleAttrib))					
						}				
						
						
						var colHeadImg = "";
						var colHeadImgUrl;
						var colHeadImgAltText;
						var colHeadImgHeight;
						var colHeadImgWidth;
						if(headerNode)
						{
							colHeadImgUrl = headerNode.getAttribute("ImageUrl");
							colHeadImgAltText = headerNode.getAttribute("ImageAltText");
							colHeadImgHeight = headerNode.getAttribute("ImageHeight");
							colHeadImgWidth = headerNode.getAttribute("ImageWidth");
						}
						else
						{
							colHeadImgUrl = column.HeaderImageUrl;
							colHeadImgAltText = column.HeaderImageAltText;
							colHeadImgHeight = column.HeaderImageHeight;
							colHeadImgWidth = column.HeaderImageWidth;
						}
						if (colHeadImgUrl || colHeadImgAltText)
						{
							colHeadImg = "<img";
							if (colHeadImgUrl)
								colHeadImg += " src="+unescape(colHeadImgUrl);
							if (colHeadImgAltText)
								colHeadImg += " alt="+unescape(colHeadImgAltText);
							if (colHeadImgHeight)
								colHeadImg += " Height="+colHeadImgHeight;
							if (colHeadImgWidth)
								colHeadImg += " Width="+colHeadImgWidth;								
							colHeadImg += ">";
						}
						var ht = "";
						if(colHeadImg.length>0)
							ht+=colHeadImg;
						
						var headerText=column.HeaderText;
						if (!column.HeaderWrap)
							ht+="<nobr>"+(headerText?headerText:"&nbsp;");
						else
							ht+=column.HeaderText;
						var sortIndImg = "";
						switch(column.SortIndicator)
						{
							case 1:
								sortIndImg="&nbsp;<img src='"+g.SortAscImg+"' border='0' imgType='sort'>";
								break;
							case 2:
								sortIndImg="&nbsp;<img src='"+g.SortDscImg+"' border='0' imgType='sort'>";
								break;
						}
						ht+=sortIndImg;																		
						if(g.UseFixedHeaders && column.getFixedHeaderIndicator()==2)
							ht+="&nbsp;<img src='"+(column.Fixed?g.FixedHeaderOnImage:g.FixedHeaderOffImage)+"' border='0' width='12' height='12' imgType='fixed' onclick='igtbl_fixedClick(event)'>";
							
						if (!column.HeaderWrap)
							ht+="</nobr>";
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
							nftd.style.textAlign="left";
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
								if(band.Columns[j].getVisible())
								{
									var nfcg=document.createElement("col");
									nfcg.width=band.Columns[j].Width;
									nfcgs.appendChild(nfcg);
								}
							}
							for(var j=column.Index;j<band.Columns.length;j++)
							{
								if(band.Columns[j].getHidden())
								{
									var nfcg=document.createElement("col");
									nfcg.width="1px";
									nfcg.style.display="none";
									nfcgs.appendChild(nfcg);
								}
							}
							if(
								!g.IsXHTML &&
								g._scrElem.scrollLeft)
								nftable.style.left=(-g._scrElem.scrollLeft).toString()+"px";
							var nftb=document.createElement("tbody");
							nftable.appendChild(nftb);
							nfrow=document.createElement("tr");
							nftb.appendChild(nfrow);
						}
						{
							th.className=column.getHeadClass();
							if(column.HeaderStyle)
								th.style.cssText=column.HeaderStyle;
							th.innerHTML=ht;
						}
						if(nfrow)
						{
							nfrow.appendChild(th);
							if(setHeight)
							{
								var nftd=nfrow.parentNode.parentNode.parentNode.parentNode;
								nftd.style.height=nftd.parentNode.offsetHeight;
								setHeight=false;
							}
						}
						else
							tr.appendChild(th);
						tableWidth+=column.getWidth();
					}
				}
				if(band.ColHeadersVisible!=1)
					tHead.style.display="none";
				
				if(table.tBodies.length==0)
				{
					tBody=document.createElement("tbody");
					table.appendChild(tBody);
				}
			}
			if(!this.GroupByRow && this.Rows.Band.AddNewRowVisible==1 && this.Rows.Band.AllowAddNew==1)
			{
				var tr=document.createElement("tr");
				tBody.appendChild(tr);
				tr.id=this.gridId+
					"_anr_"
					+this.getLevel(true);
				tr.setAttribute("addNewRow","true");
				if(band._optSelectRow)
					tr.className=band.getItemClass();
				var td;

				if(g.Bands.length>1)
				{
					td=document.createElement("td");
					tr.appendChild(td);
					td.className=igtbl_getExpAreaClass(this.gridId,band.Index);
					td.height=band.DefaultRowHeight;
					img=document.createElement("img");
					td.appendChild(img);
					img.src=g.BlankImage;
					img.border=0;
				}
				if(band.getRowSelectors()==1)
				{
					td=document.createElement("td");
					tr.appendChild(td);
					td.className=igtbl_getRowLabelClass(this.gridId,band.Index);
					td.id=this.gridId+
						"_anl_"
						+this.getLevel(true);
					td.height=band.DefaultRowHeight;
					img=document.createElement("img");
					td.appendChild(img);
					img.src=g.BlankImage;
					img.border=0;
				}
				var nfrow=null;
				setHeight=false;
				for(var i=0;i<band.Columns.length;i++)
				{
					var column=band.Columns[i];
					if(column.hasCells())
					{
						td=document.createElement("td");
						td.id=this.gridId+
							"_anc_"
							+this.getLevel(true)+"_"+i.toString();
						var ct=column.DefaultValue;
						if(band.AddNewRowStyle)
							td.style.cssText=band.AddNewRowStyle;
						if(column.getHidden())
							td.style.display="none";
						if(!column.Wrap)
							ct="<nobr>"+(ct?ct:"&nbsp;")+"</nobr>";
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
								if(band.Columns[j].getVisible())
								{
									var nfcg=document.createElement("col");
									nfcg.width=band.Columns[j].Width;
									nfcgs.appendChild(nfcg);
								}
							}
							for(var j=column.Index;j<band.Columns.length;j++)
							{
								if(band.Columns[j].getHidden())
								{
									var nfcg=document.createElement("col");
									nfcg.width="1px";
									nfcg.style.display="none";
									nfcgs.appendChild(nfcg);
								}
							}
							if(
								!g.IsXHTML &&
								g._scrElem.scrollLeft)
								nftable.style.left=(-g._scrElem.scrollLeft).toString()+"px";
							var nftb=document.createElement("tbody");
							nftable.appendChild(nftb);
							nfrow=document.createElement("tr");
		
							nfrow.id=this.gridId+"_anfr_"+this.getLevel(true);
							nftb.appendChild(nfrow);
						}
						
						if(column.CssClass
							&& !band._optSelectRow
						)
							td.className=(td.className.length>0?" ":"")+column.CssClass;
						td.innerHTML=ct;
						if(nfrow)
						{
							nfrow.appendChild(td);
							if(setHeight)
							{
								var nftd=nfrow.parentNode.parentNode.parentNode.parentNode;
								nftd.style.height=nftd.parentNode.offsetHeight;
								setHeight=false;
							}
						}
						else
							tr.appendChild(td);
					}
				}
				this.Rows.AddNewRow=new igtbl_AddNewRow(tr,this.Rows);
				igtbl_setNewRowImg(this.gridId,tr);
				g.newImg=null;
			}
			var footersNode=null;
			if(this.Rows.Node)
				footersNode=this.Rows.Node.selectSingleNode("Footers");
			if(band.ColFootersVisible==1 && !band.FooterHTML)
			{
				var tFoot=document.createElement("tfoot");
				table.appendChild(tFoot);
				if(this.Band.Index==0 && this.Band.Grid.StatFooter && this.GroupByRow && g.get("StationaryMarginsOutlookGroupBy")=="True")
					tFoot.style.display="none";
				var tr=document.createElement("tr");
				tFoot.appendChild(tr);
				var th;

				if(g.Bands.length>1)
				{
					th=document.createElement("th");
					tr.appendChild(th);
					th.className=band.getExpAreaClass();
					th.height=band.DefaultRowHeight;
					img=document.createElement("img");
					th.appendChild(img);
					img.src=band.Grid.BlankImage;
					img.border=0;
					img.style.visibility="hidden";
				}

				if(band.getRowSelectors()==1)
				{
					th=document.createElement("th");
					tr.appendChild(th);
					th.className=band.getRowLabelClass();
					th.height=band.DefaultRowHeight;
					img=document.createElement("img");
					th.appendChild(img);
					img.src=band.Grid.BlankImage;
					img.border=0;
					img.style.visibility="hidden";
				}
				var footers=null;
				if(footersNode)
					footers=footersNode.selectNodes("Footer");
				var nfrow=null;
				setHeight=false;
				for(var i=0;i<band.Columns.length;i++)
				{
					var column=band.Columns[i];
					if(column.hasCells())
					{
						th=document.createElement("th");
						th.id=this.gridId+
						"_"+
						"f"+"_"+band.Index+"_"+i.toString();
						if(column.getHidden())
							th.style.display="none";
						var ht="&nbsp;";
						if(footers)
							ht=footers[i].firstChild.text;
						if(g.UseFixedHeaders && !column.Fixed && !nfrow)
						{
							var nftd=document.createElement("th");
							nftd.colSpan=band.Columns.length-column.Index;
							nftd.style.textAlign="left";
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
								if(band.Columns[j].getVisible())
								{
									var nfcg=document.createElement("col");
									nfcg.width=band.Columns[j].Width;
									nfcgs.appendChild(nfcg);
								}
							}
							for(var j=column.Index;j<band.Columns.length;j++)
							{
								if(band.Columns[j].getHidden())
								{
									var nfcg=document.createElement("col");
									nfcg.width="1px";
									nfcg.style.display="none";
									nfcgs.appendChild(nfcg);
								}
							}
							if(
								!g.IsXHTML &&
								g._scrElem.scrollLeft)
								nftable.style.left=(-g._scrElem.scrollLeft).toString()+"px";
							var nftb=document.createElement("tbody");
							nftable.appendChild(nftb);
							nfrow=document.createElement("tr");
							nftb.appendChild(nfrow);
						}
						{
							th.className=column.getFooterClass();
							if(column.FooterStyle)
								th.style.cssText=column.FooterStyle;
							th.innerHTML=ht;
						}
						if(nfrow)
						{
							nfrow.appendChild(th);
							if(setHeight)
							{
								var nftd=nfrow.parentNode.parentNode.parentNode.parentNode;
								nftd.style.height=nftd.parentNode.offsetHeight;
								setHeight=false;
							}
						}
						else
							tr.appendChild(th);
					}
				}
			}
		}

		this.Rows.Element=tBody;
		tBody.Object=this.Rows;
	}
},
"getLevel",
function(s)
{
	var l=new Array();
	l[0]=this.getIndex(true);
	var pr=this.ParentRow;
	while(pr)
	{
		l[l.length]=pr.getIndex(true);
		pr=pr.ParentRow;
	}
	l=l.reverse();
	if(s)
	{
		s=l.join("_");
		igtbl_dispose(l);
		delete l;
		return s;
	}
	return l;
},
"getCell",
function(index)
{
	if(index<0 || !this.cells || index>=this.cells.length)
		return null;
	if(!this.cells[index])
	{
		var cell=null;
		var col=this.Band.Columns[index];
		if(col.hasCells())
		{
			if(this.Band.Grid.UseFixedHeaders && !col.getFixed())
			{
				var i=0,ci=this.Band.firstActiveCell,colspan=1;
				var cells=this.Element.cells;
				while(i<=index)
				{
					if(!this.Band.Columns[i].getFixed() && (i==0 || this.Band.Columns[i-1].getFixed()))
					{
						cells=cells[ci].firstChild.firstChild.rows[0].cells;
						ci=0;
						colspan=1;
					}
					if(this.Band.Columns[i].hasCells())
					{
						if(i==index && colspan==1)
							cell=cells[ci];
						if(colspan==1)
						{
							if(cells[ci])
								colspan=cells[ci].colSpan;
							ci++;
						}
						else
							colspan--;
					}
					i++;
				}
			}
			else
			{
				var ri=col.getRealIndex(this);
				if(ri>=0)
				{
					cell=this.Element.cells[this.Band.firstActiveCell+ri];
					if(cell)
					{
						var column=igtbl_getColumnById(cell.id);
						if(!column || !igtbl_isColEqual(column,col))
							cell=null;
					}
				}
			}
		}
		var node=null;
		if(this.Node)
		{
			var cni=-1,colNo=0;
			while(colNo<col.Node.parentNode.childNodes.length)
			{
				if(!col.Node.parentNode.childNodes[colNo].getAttribute("serverOnly"))
					cni++;
				
				if(colNo==col.Node.firstChild.getAttribute("lit:columnNo"))
					break;
				colNo++;
			}
			if(cni>=0 && cni<col.Node.parentNode.childNodes.length)
				node=this.Node.selectSingleNode("Cs").childNodes[cni];
		}
		this.cells[index]=new igtbl_Cell(cell,node,this,index);
	}
	return this.cells[index];
},
"getCellByColumn",
function(col)
{
	return this.getCell(col.Index);
},
"getCellFromKey",
function(key)
{
	var cell=null;
	var col=this.Band.getColumnFromKey(key);
	if(col)
		cell=this.getCellByColumn(col);
	return cell;
},
"getChildRow",
function(index)
{
	if(!this.Expandable)
		return null;
	if(index<0 || index>=this.ChildRowsCount || !this.FirstChildRow)
		return null;
	var i=0;
	var r=this.FirstChildRow.Element;
	while(i<index && r)
	{
		r=igtbl_getNextSibRow(this.gridId,r);
		i++;
	}
	if(!r)
		return null;
	return igtbl_getRowById(r.id);
},
"compare",
function(row)
{
	if(this.OwnerCollection!=row.OwnerCollection)
		return 0;
	if(this.GroupByRow)
		return igtbl_getColumnById(this.GroupColId).compareRows(this,row);
	else
	{
		var sc=this.OwnerCollection.Band.SortedColumns;
		for(var i=0;i<sc.length;i++)
		{
			var col=igtbl_getColumnById(sc[i]);
			if(col.hasCells())
			{
				var cell1=this.getCellByColumn(col);
				var cell2=row.getCellByColumn(col);
				var res=col.compareCells(cell1,cell2);
				if(res!=0)
				{
					return res;
				}
			}
		}
	}
	return 0;
},
"remove",
function(fireEvents)
{
	return this.OwnerCollection.remove(this.OwnerCollection.indexOf(this),fireEvents);
},
"getNextTabRow",
function(shift,ignoreCollapse
,addRow
)
{
	var row=null;
	if(shift)
	{
		row=this.getPrevRow(
		addRow
		);
		if(row)
		{
			while(row.Rows && (row.getExpanded() || ignoreCollapse && row.Expandable))
			{
				if(addRow && row.Rows.AddNewRow && (row.Band.AddNewRowView==2 || this.Rows.length==0 && this.Band.AddNewRowView==1))
					row=row.Rows.AddNewRow;
				else
					row=row.Rows.getRow(row.Rows.length-1);
			}
		}
		else if(this.ParentRow)
			row=this.ParentRow;
	}
	else
	{
		if(this.Rows && (this.getExpanded() || ignoreCollapse && this.Expandable))
		{
			if(addRow && this.Rows.AddNewRow && (this.Band.AddNewRowView==1 || this.Rows.length==0 && this.Band.AddNewRowView==2))
				row=this.Rows.AddNewRow;
			else
				row=this.Rows.getRow(0);
		}
		else
		{
			row=this.getNextRow(
			addRow
			);
			if(!row && this.ParentRow)
			{
				var pr=this.ParentRow;
				while(!row && pr)
				{
					row=pr.getNextRow(
					addRow
					);
					pr=pr.ParentRow;
				}
			}
		}
	}
	return row;
},
"getSelected",
function()
{
	if(this._Changes["SelectedRows"])
		return true;
	return false;
},
"setSelected",
function(select)
{
	var str=this.Band.getSelectTypeRow();
	if(str>1)
	{
		if(str==2)
			this.Band.Grid.clearSelectionAll();
		igtbl_selectRow(this.gridId,this,select);
	}
},
"getNextRow",
function(
	addRow
)
{
	var nr;
	if(this.IsAddNewRow)
	{
		if(this.Band.AddNewRowView==1)
		{
			if(this.Band.Index==0 && this.Band.Grid.StatHeader || this._dataChanged)
				return null;
			nr=0;
		}
		else
			if(this.Band.Index==0 && this.Band.Grid.StatFooter)
				return null;
	}
	else
		nr=this.getIndex()+1;
	while(nr<this.OwnerCollection.length && this.OwnerCollection.getRow(nr).getHidden())
		nr++;
	if(nr<this.OwnerCollection.length)
		return this.OwnerCollection.getRow(nr);
	if(addRow && this.Band.AddNewRowVisible==1 && this.Band.AddNewRowView==2 && nr==this.OwnerCollection.length)
		return this.OwnerCollection.AddNewRow;
	return null;
},
"getPrevRow",
function(
	addRow
)
{
	var pr;
	if(this.IsAddNewRow)
	{
		if(this.Band.AddNewRowView==2)
		{
			if(this.Band.Index==0 && this.Band.Grid.StatFooter || this._dataChanged)
				return null;
			pr=this.OwnerCollection.length-1;
		}
		else
			if(this.Band.Index==0 && this.Band.Grid.StatHeader)
				return null;
	}
	else
		pr=this.getIndex()-1;
	while(pr>=0 && this.OwnerCollection.getRow(pr).getHidden())
		pr--;
	if(pr>=0)
		return this.OwnerCollection.getRow(pr);
	if(addRow && this.Band.AddNewRowVisible==1 && this.Band.AddNewRowView==1 && pr==-1)
		return this.OwnerCollection.AddNewRow;
	return null;
},
"activate",
function(fireEvents)
{
	this.Band.Grid.setActiveRow(this,false,fireEvents);
},
"isActive",
function()
{
	return this.Band.Grid.getActiveRow()==this;
},
"scrollToView",
function()
{
	igtbl_scrollToView(this.gridId,this.Element);
},
"deleteRow",
function(skipRowRecalc)
{
	var gs=igtbl_getGridById(this.gridId);
	var del=false;
	var rowId=this.Element.id;
	if(this.Band.AllowDelete==1 || this.Band.AllowDelete==0 && gs.AllowDelete==1)
	{
		var rows=this.OwnerCollection;
		if(igtbl_inEditMode(this.gridId))
		{
			igtbl_hideEdit(this.gridId);
			if(igtbl_inEditMode(this.gridId))
				return false;
		}
		if(igtbl_fireEvent(this.gridId,gs.Events.BeforeRowDeleted,"(\""+this.gridId+"\",\""+rowId+"\")")==true)
			return false;
		var btn=igtbl_getElementById(this.gridId+"_bt");

		del=true;
		var prevAdded=typeof(gs.AddedRows[rowId])!="undefined";
		if(!prevAdded)
			gs.invokeXmlHttpRequest(gs.eReqType.DeleteRow,this);
		if (gs.XmlResponseObject && gs.XmlResponseObject.Cancel) return;
		if(btn && btn.style.display=="")
			btn.style.display="none";
		igtbl_scrollLeft(gs.Element.parentNode,0);		
		this.OwnerCollection.setLastRowId();
		if(this.getExpanded())
			this.toggleRow();
		igtbl_clearRowChanges(gs,this);
		for(var rid in gs.AddedRows)
			if(rid==rowId || rid.substr(0,rowId.length+1)==rowId+"_")
				igtbl_clearRowChanges(gs,igtbl_getRowById(rid));
		if(!rows.deletedRows)
			rows.deletedRows=new Array();
		var ar=this.Band.Grid.getActiveRow();
		var needPB=false;
		this.Element.setAttribute("deleted",true);
		if(typeof(this.Node)=="undefined")
		{
			var overlappingColSpan = -1;
			for(var i=0;i<this.Band.Columns.length;i++)
			{
				var cell=this.getCellByColumn(this.Band.Columns[i]);
				if(!cell && this.Band.Columns[i].hasCells())
				{
					var row=this;
					while(row.getPrevRow() && !cell)
					{
						row=row.getPrevRow();
						cell=row.getCellByColumn(this.Band.Columns[i]);
					}
					if(row==this || !cell || cell.Column.hasCells() && cell.Element!=null && cell.Element.rowSpan==1)
					{
						needPB=true;
						break;
					}
				}
				else if(cell && cell.Column.hasCells() && (!cell.Element || cell.Element.rowSpan>1))
				{
					if (overlappingColSpan>1 )
						overlappingColSpan--;
					if(cell.Element && cell.Element.rowSpan>1)
					{
						needPB=true;
						break;
					}	
				}
				if(cell && cell.Element )
				{
					if (cell.Element.rowSpan>1)
						cell.Element.rowSpan--;
					if (cell.Element.colSpan>1)
						overlappingColSpan = cell.Element.colSpan;
				}	
			}
		}
		if(!needPB)
		{
			rows.deletedRows[rows.deletedRows.length]=this.remove(false);
			
			if(gs.LoadOnDemand==3 && (!gs.Events.XmlHTTPResponse || gs.Events.XmlHTTPResponse[1] || gs.Events.AfterRowDeleted[1]))
				gs._removeChange("DeletedRows",this);
			var pr=this.ParentRow;
			if(pr)
			{
				pr.VisChildRowsCount--;
				pr.ChildRowsCount--;
			}
			while(pr)
			{
				if(pr.Expandable && pr.Rows.length==0)
				{
					if (pr.Rows.Band.AddNewRowVisible!=1)
					pr.setExpanded(false);
					if(pr.GroupByRow)
					{
						gs._removeChange("CollapsedRows",pr);
						gs.DeletedRows[pr.Element.id]=true;
						pr.Element.setAttribute("deleted",true);
						rows.deletedRows[rows.deletedRows.length]=pr.remove(false);
						gs._removeChange("DeletedRows",pr);
						delete gs.SelectedRows[pr.Element.id];
					}
					else
					{
						if (pr.Rows.Band.AddNewRowVisible!=1)
							pr.Element.childNodes[0].childNodes[0].style.display="none";
					}						
				}
				pr=pr.ParentRow;
			}
			if(this.Node && !gs.isDeletingSelected)
				rows.reIndex(this.getIndex(true));
			if(ar==this)
				this.Band.Grid.setActiveRow(null);
			else
			{
				var ac=this.Band.Grid.getActiveCell();
				if(ac && ac.Row==this)
					this.Band.Grid.setActiveCell(null);
			}
		}
		else
		{
			gs._recordChange("DeletedRows",this);
			igtbl_needPostBack(this.gridId);
		}
		if(prevAdded)
			this._Changes["DeletedRows"].setFireEvent(false);		
		gs._calculateStationaryHeader();
		
		if(!skipRowRecalc) gs._recalcRowNumbers();
		igtbl_fireEvent(this.gridId,gs.Events.AfterRowDeleted,"(\""+this.gridId+"\",\""+rowId+"\");");
		if(gs.LoadOnDemand==3)
			gs.NeedPostBack=false;
	}
	return del;
},
"getLeft",
function(offsetElement)
{
	return igtbl_getLeftPos(igtbl_getElemVis(this.Element.cells,igtbl_getBandFAC(this.gridId,this.Element)),true,offsetElement);
},
"getTop",
function(offsetElement)
{
	var t=igtbl_getTopPos(this.Element,true,offsetElement);
	return t;
},
"editRow",
function(force)
{    
	var au=igtbl_getAllowUpdate(this.gridId,this.Band.Index);
	if(igtbl_currentEditTempl!=null || !force && au!=1 && au!=3
		|| this.IsAddNewRow
	)
		return;
	var editTempl=igtbl_getElementById(this.Band.RowTemplate);
	if(!editTempl)
		return;
	var gridObj=igtbl_getGridById(this.gridId);	
	if(igtbl_fireEvent(this.gridId,gridObj.Events.BeforeRowTemplateOpen,"(\""+this.gridId+"\",\""+this.Element.id+"\",\""+this.Band.RowTemplate+"\")"))
		return;
	try
	{
		if(editTempl.style.filter!=null && this.Band.ExpandEffects)
		{
			var ee=this.Band.ExpandEffects;
			if(ee.EffectType!='NotSet')
			{
				editTempl.style.filter="progid:DXImageTransform.Microsoft."+ee.EffectType+"(duration="+ee.Duration/1000+");"
				if(ee.ShadowWidth>0)
					editTempl.style.filter+=" progid:DXImageTransform.Microsoft.Shadow(Direction=135, Strength="+ee.ShadowWidth+",color="+ee.ShadowColor+");"
				if(ee.Opacity<100)
					editTempl.style.filter+=" progid:DXImageTransform.Microsoft.Alpha(Opacity="+ee.Opacity+");"
				if(editTempl.filters[0]!=null)
					editTempl.filters[0].apply();
				if(editTempl.filters[0]!=null)
					editTempl.filters[0].play();
			}
			else
			{
				if(ee.ShadowWidth>0)
					editTempl.runtimeStyle.filter="progid:DXImageTransform.Microsoft.Shadow(Direction=135, Strength="+ee.ShadowWidth+",ee.Color="+ee.ShadowColor+");"
				if(ee.Opacity<100)
					editTempl.runtimeStyle.filter+=" progid:DXImageTransform.Microsoft.Alpha(Opacity="+ee.Opacity+");"
			}
		}
	}
	catch(ex){}
	editTempl.style.display="";
	if(!editTempl.style.width)
		editTempl.style.width=editTempl.offsetWidth;
	if(!editTempl.style.height)
		editTempl.style.height=editTempl.offsetHeight;
	editTempl.setAttribute("noHide",true);
	var fc=igtbl_getElemVis(this.Element.cells,igtbl_getBandFAC(this.gridId,this.Element));
	editTempl.style.left=igtbl_getRelativePos(this.gridId,fc,"Left");
	var tw=igtbl_clientWidth(editTempl);
	var bw=document.body.clientWidth;
	var gdw = gridObj.Element.parentNode.scrollLeft;
	
	if (gridObj.IsXHTML)
	{
	    var leftVal=gridObj.MainGrid.offsetLeft+fc.offsetLeft-gridObj.DivElement.scrollLeft;
	    if (leftVal<0) leftVal=gridObj.MainGrid.offsetLeft;
	    editTempl.style.left=leftVal+(ig_csom.IsIE ? "" :"px");
	}    
	else
	{	
	    editTempl.style.left=editTempl.offsetLeft+gdw;	
	    if(editTempl.offsetLeft+tw-igtbl_getBodyScrollLeft()>bw)
		    if(bw-tw+igtbl_getBodyScrollLeft()-gdw>0)
			    editTempl.style.left=bw-tw+igtbl_getBodyScrollLeft()-gdw;
		    else
			    editTempl.style.left=0;
    }				
	var th=igtbl_clientHeight(editTempl);
	var bh=document.body.clientHeight;
		
	if (gridObj.IsXHTML)
	{
	    var topVal=gridObj.MainGrid.offsetTop-gridObj.DivElement.scrollTop+this.Element.offsetTop+this.Element.offsetHeight;	    
	    editTempl.style.top=topVal+(ig_csom.IsIE ? "" :"px");
	}
	else
	{
	    editTempl.style.top=igtbl_getRelativePos(this.gridId,fc,"Top")+this.Element.offsetHeight;
	    if(editTempl.offsetTop+th-igtbl_getBodyScrollTop()>bh)
		    if(bh-th+igtbl_getBodyScrollTop()>0)
			    editTempl.style.top=bh-th+igtbl_getBodyScrollTop();
		    else
			    editTempl.style.top=0;
    }			
	editTempl.setAttribute("editRow",this.Element.id);
	igtbl_fillEditTemplate(this,editTempl.childNodes);
	if(igtbl_focusedElement && igtbl_isVisible(igtbl_focusedElement))
	{
		igtbl_focusedElement.focus();
		if(igtbl_focusedElement.select)
			igtbl_focusedElement.select();
		igtbl_focusedElement=null;
	}
	igtbl_currentEditTempl=this.Band.RowTemplate;
	igtbl_oldMouseDown=igtbl_addEventListener(document,"mousedown",igtbl_gRowEditMouseDown,false);
	igtbl_justAssigned=true;
	window.setTimeout(igtbl_resetJustAssigned,100);
	editTempl.removeAttribute("noHide");
	igtbl_fireEvent(this.gridId,gridObj.Events.AfterRowTemplateOpen,"(\""+this.gridId+"\",\""+this.Element.id+"\")");
},
"endEditRow",
function(saveChanges)
{
	if(arguments.length==0 || typeof(saveChanges)=="undefined")
		saveChanges=false;
	var gs=igtbl_getGridById(this.gridId);
	var editTempl=igtbl_getElementById(this.Band.RowTemplate);
	if(!editTempl || editTempl.style.display!="")
		return;
	if(editTempl.getAttribute("noHide"))
		return;
	if(igtbl_fireEvent(this.gridId,gs.Events.BeforeRowTemplateClose,"(\""+this.gridId+"\",\""+this.Element.id+"\","+saveChanges.toString()+")"))
		return;
	editTempl.style.display="none";
	igtbl_currentEditTempl=null;
	igtbl_removeEventListener(document,"mousedown",igtbl_gRowEditMouseDown,igtbl_oldMouseDown,false);
	igtbl_oldMouseDown=null;
	if(saveChanges)
		igtbl_unloadEditTemplate(this,editTempl.childNodes);
	igtbl_fireEvent(this.gridId,gs.Events.AfterRowTemplateClose,"(\""+this.gridId+"\",\""+this.Element.id+"\","+saveChanges.toString()+")");
	if(gs.NeedPostBack)
		igtbl_doPostBack(gs.Id);
},
"getHidden",
function()
{
	return (this.Element.style.display=="none");
},
"setHidden",
function(h)
{
	this.Element.style.display=(h?"none":"");
	var g=this.Band.Grid;
	if(g.UseFixedHeaders)
	{
		var drs=null;
		var row=this.Element;
		var i=0;
		while(i<row.cells.length && (!row.cells[i].firstChild || row.cells[i].firstChild.id!=g.Id+"_drs")) i++;
		if(i<row.cells.length)
		{
			var td=row.cells[i];
			drs=td.firstChild;
		}
		if(drs)
			drs.style.display=(h?"none":"");
	}
	if(this.ParentRow)
		this.ParentRow.VisChildRowsCount+=(h?-1:1);
	var ac=this.Band.Grid.getActiveCell();
	if(ac && ac.Row==this && h)
		this.Band.Grid.setActiveCell(null);
	else
	{
		var ar=this.Band.Grid.getActiveRow();
		if(ar && ar==this && h)
			this.Band.Grid.setActiveRow(null);
		else
			this.Band.Grid.alignGrid();
	}
},
"find",
function(re,back)
{
	var g=this.Band.Grid;
	if(re)
		g.regExp=re;
	if(!g.regExp)
		return null;
	g.lastSearchedCell=null;
	if(back==true || back==false)
		g.backwardSearch=back;
	var cell=null;
	if(!g.backwardSearch)
	{
		cell=this.getCell(0);
		if(cell && !cell.Column.getVisible())
			cell=cell.getNextCell();
		while(cell && cell.getValue(true).search(g.regExp)==-1)
			cell=cell.getNextCell();
	}
	else
	{
		cell=this.getCell(this.cells.length-1);
		if(cell && !cell.Column.getVisible())
			cell=cell.getPrevCell();
		while(cell && cell.getValue(true).search(g.regExp)==-1)
			cell=cell.getPrevCell();
	}
	if(cell)
		g.lastSearchedCell=cell;
	return g.lastSearchedCell;
},
"findNext",
function(re,back)
{
	var g=this.Band.Grid;
	if(!g.lastSearchedCell || g.lastSearchedCell.Row!=this)
		return this.find(re,back);
	if(re)
		g.regExp=re;
	if(!g.regExp)
		return null;
	if(back==true || back==false)
		g.backwardSearch=back;
	var cell=null;
	if(!g.backwardSearch)
	{
		cell=g.lastSearchedCell.getNextCell();
		while(cell && cell.getValue(true).search(g.regExp)==-1)
			cell=cell.getNextCell();
	}
	else
	{
		cell=g.lastSearchedCell.getPrevCell();
		while(cell && cell.getValue(true).search(g.regExp)==-1)
			cell=cell.getPrevCell();
	}
	if(cell)
		g.lastSearchedCell=cell;
	else
		g.lastSearchedCell=null;
	return g.lastSearchedCell;
},
"setSelectedRowImg",
function(hide)
{
	var gs=this.Band.Grid;
	if(this.Band.AllowRowNumbering>=2
		|| this.IsAddNewRow
	)
		return;
	var row=this.Element;
	if(gs.currentTriImg!=null)
	{
		gs._lastSelectedRow=null;
		var imgObj;
		imgObj=document.createElement("img");
		imgObj.setAttribute("imgType","blank");
		imgObj.border="0";
		if(gs.RowLabelBlankImage)
			imgObj.src=gs.RowLabelBlankImage;
		else
		{
			imgObj.src=gs.BlankImage;
			imgObj.style.visibility="hidden";
		}
		gs.currentTriImg.parentNode.appendChild(imgObj);
		gs.currentTriImg.parentNode.removeChild(gs.currentTriImg);
		gs.currentTriImg=null;
	}
	if(!hide && row && !row.getAttribute("deleted") && !row.getAttribute("groupRow") && this.Band.getRowSelectors()!=2)
	{
		var rl=row.cells[this.Band.firstActiveCell-1];
		if(rl.childNodes.length==0 || !(rl.childNodes[0].tagName=="IMG" && rl.childNodes[0].getAttribute("imgType")=="newRow"))
		{
			var imgObj;
			imgObj=document.createElement("img");
			imgObj.src=igtbl_getCurrentRowImage(this.gridId,this.Band.Index);
			imgObj.border="0";
			imgObj.setAttribute("imgType","tri");
			var cell=row.cells[this.Band.firstActiveCell-1];
			cell.innerHTML="";
			cell.appendChild(imgObj);
			gs.currentTriImg=imgObj;
		}
		gs._lastSelectedRow=row.id;
	}
},
"renderActive",
function(render)
{
	var g=this.Band.Grid;
	if(!g.Activation.AllowActivation)
		return;
	if(this.GroupByRow)
	{
		var fr=this.getFirstRow();
		fr=fr.firstChild;
		if(ig_csom.IsNetscape || ig_csom.IsNetscape6)
		{
			igtbl_changeBorder(g,fr.style,fr.style,this,"Left",render);
			igtbl_changeBorder(g,fr.style,fr.style,this,"Top",render);
			igtbl_changeBorder(g,fr.style,fr.style,this,"Right",render);
			igtbl_changeBorder(g,fr.style,fr.style,this,"Bottom",render);
		}
		else
			igtbl_changeBorder(g,fr.currentStyle,fr.runtimeStyle,this,"",render);
	}
	else
	{
		if(typeof(render)=="undefined") render=true;
		if(this.Band._optSelectRow)
		{
			var flEls=this.getCellElements(true);
			if(render)
			{
				this.Element.className+=" "+g.Activation._cssClass;
				if(this.nfElement)
					this.nfElement.className+=" "+g.Activation._cssClass;
			}
			else
			{
				var styles=this.Element.className.split(" ");
				styles=styles.slice(0,styles.length-1);
				this.Element.className=styles.join(" ");
				if(this.nfElement)
					this.nfElement.className=this.Element.className;
			}
			if(flEls && flEls.length)
			{
				if(ig_shared.IsNetscape || ig_shared.IsNetscape6)
				{
					igtbl_changeBorder(g,flEls[0].style,flEls[0].style,flEls[0],"Left",render);
					igtbl_changeBorder(g,flEls[1].style,flEls[1].style,flEls[1],"Right",render);
				}
				else
				{
					igtbl_changeBorder(g,flEls[0].currentStyle,flEls[0].runtimeStyle,flEls[0],"Left",render);
					igtbl_changeBorder(g,flEls[1].currentStyle,flEls[1].runtimeStyle,flEls[1],"Right",render);
				}
				igtbl_dispose(flEls);
			}
		}
		else
		{
			var i=0;
			var els=this.getCellElements();
			if(!els || els.length==0) return;
			var cell=els[i];
			while(cell && cell.offsetHeight==0 && i<this.cells.length)
				cell=els[++i];
			if(i<els.length)
			{
				if(ig_shared.IsNetscape || ig_shared.IsNetscape6)
					igtbl_changeBorder(g,cell.style,cell.style,cell,"Left",render);
				else
					igtbl_changeBorder(g,cell.currentStyle,cell.runtimeStyle,cell,"Left",render);
			}
			for(i=0;i<els.length;i++)
			{
				cell=els[i];
				if(ig_shared.IsNetscape || ig_shared.IsNetscape6)
				{
					igtbl_changeBorder(g,cell.style,cell.style,cell,"Top",render);
					igtbl_changeBorder(g,cell.style,cell.style,cell,"Bottom",render);
				}
				else
				{
					igtbl_changeBorder(g,cell.currentStyle,cell.runtimeStyle,cell,"Top",render);
					igtbl_changeBorder(g,cell.currentStyle,cell.runtimeStyle,cell,"Bottom",render);
				}
			}
			i=els.length-1;
			cell=els[i];
			while(cell && cell.offsetHeight==0 && i>=0)
				cell=els[--i];
			if(i>=0)
			{
				if(ig_shared.IsNetscape || ig_shared.IsNetscape6)
					igtbl_changeBorder(g,cell.style,cell.style,cell,"Right",render);
				else
					igtbl_changeBorder(g,cell.currentStyle,cell.runtimeStyle,cell,"Right",render);
			}
			igtbl_dispose(els);
		}
	}
},
"select",
function(selFlag,fireEvent)
{
	var gs=this.Band.Grid;
	if(this.Band.getSelectTypeRow()<2 || this.getSelected()==selFlag)
		return false;
	if(gs._exitEditCancel || gs._noCellChange)
		return false;
	if(fireEvent!=false)
		if(igtbl_fireEvent(gs.Id,gs.Events.BeforeSelectChange,"(\""+gs.Id+"\",\""+this.Element.id+"\")")==true)
			return false;
	if(!this.GroupByRow)
	{
		var style=null;
		if(selFlag!=false)
			style=this.Band.getSelClass();
		if(this.Band._optSelectRow)
		{
			if(style)
			{
				var aoStyle="";
				if(gs.oActiveRow==this)
				{
					var styles=this.Element.className.split(" ");
					aoStyle=" "+styles[styles.length-1];
					styles=styles.slice(0,styles.length-1);
					this.Element.className=styles.join(" ");
					if(this.nfElement)
						this.nfElement.className=this.Element.className;
				}
				this.Element.className+=" "+style+aoStyle;
				if(this.nfElement)
					this.nfElement.className+=" "+style+aoStyle;
			}
			else
			{
				var styles=this.Element.className.split(" ");
				styles=styles.slice(0,styles.length-1);
				this.Element.className=styles.join(" ");
				if(this.nfElement)
					this.nfElement.className=this.Element.className;
			}
		}
		else if(!this.Band._selClassDiffer)
		{
			var els=this.getCellElements();
			for(var i=0;i<els.length;i++)
				igtbl_changeStyle(gs.Id,els[i],style);
		}
		if(this.Band._selClassDiffer)
			for(var i=0;i<this.cells.length;i++)
				this.getCell(i).selectCell(selFlag);
	}
	else if(selFlag!=false)
		igtbl_changeStyle(gs.Id,this.FirstRow.cells[0],this.Band.getSelGroupByRowClass());
	else
		igtbl_changeStyle(gs.Id,this.FirstRow.cells[0],null);
	if(selFlag!=false)
		gs._recordChange("SelectedRows",this,gs.GridIsLoaded.toString());
	
	else if(gs.SelectedRows[this.Element.id] || gs._containsChange("SelectedRows",this))
			gs._removeChange("SelectedRows",this);
	if(this==gs.oActiveRow
		&& !this.Band._optSelectRow
	)
		this.renderActive();
	if(fireEvent!=false)
	{
		var gsNPB = gs.NeedPostBack;
		igtbl_fireEvent(gs.Id,gs.Events.AfterSelectChange,"(\""+gs.Id+"\",\""+this.Element.id+"\");");
		if(!gsNPB && !(gs.Events.AfterSelectChange[1]&2))
			gs.NeedPostBack=false;
		if(gs.NeedPostBack)
			igtbl_moveBackPostField(gs.Id,"SelectedRows");
	}
	return true;
},
"processUpdateRow",
function()
{
	return this._processUpdateRow();
},
"_processUpdateRow",
function()
{
	var result=false;
	var g=this.Band.Grid;
	if(!this._dataChanged || typeof(g.Events.BeforeRowUpdate)=="undefined")
		return result;
	for(var i=0;(this._dataChanged&2) && i<this.cells.length;i++)
		if(typeof(this.getCell(i)._oldValue)!="undefined")
			break;
	if(i<this.cells.length)
	{
		g.QueryString="";
		result=g.fireEvent(g.Events.BeforeRowUpdate,[g.Id,this.Element.id]);
		if((this._dataChanged&2))
			for(;i<this.cells.length;i++)
			{
				var cell=this.getCell(i);
				if(typeof(cell._oldValue)!="undefined")
				{
					if(result)
						cell.setValue(cell._oldValue,false);
					else if(g.LoadOnDemand==3)
						g.QueryString+=(g.QueryString&&g.QueryString.length>0?"\x04":"")+"UpdateCell\x06"+cell.Column.Key+"\x02"+igtbl_escape(cell.getValue(true));
				}
			}
		if(!result)
		{
			if(g.LoadOnDemand==3 && (g.Events.AfterRowUpdate[1] || g.Events.XmlHTTPResponse[1]))
				g.invokeXmlHttpRequest(g.eReqType.UpdateRow,this);
			else
			{
				g.fireEvent(g.Events.AfterRowUpdate,[g.Id,this.Element.id]);
				if(g.NeedPostBack)
					igtbl_doPostBack(g.Id);
			}
		}
		this._dataChanged=0;
	}
	return result;
},
"_getRowNumber",
function()
{
	var index = null;
	var oLbl= igtbl_getElementById(this.gridId+"l_"+this.getLevel(true));
	if (this.Band.getRowSelectors()<2 && this.Band.AllowRowNumbering>1 && oLbl)
			index=oLbl.innerText;
	return index;
},
"_setRowNumber",
function(value)
{	
	var oRS = this.Band.firstActiveCell-1;	
	var oLbl=-1;
	if (this.Element)
		oLbl=this.Element.childNodes[oRS];
	if (this.Band.getRowSelectors()<2 && this.Band.AllowRowNumbering>1)
	{
		if (this.Node)this.Node.setAttribute("lit:rowNumber",value);		
		if (oLbl)oLbl.innerHTML=value;
		return value;
	}
	else
		return -1;	
},
"_generateUpdateRowSemaphore",
function(clear)
{
	var cellInfo="";
	for(var j=0;j<this.cells.length;j++)
	{
		var cell=this.getCell(j);
		if(cell)
		{
			if(typeof(cell.getOldValue())!="undefined")
			{
				var oldValue=cell.getOldValue();
				if(oldValue==null)
					oldValue="";
				else
					oldValue=oldValue.toString();
				cellInfo+=(cellInfo.length>0?"\x03":"")+igtbl_escape(cell.Column.Key+"\x05"+cell.Column.Index+"\x05"+oldValue);
				if(clear)
					delete cell._oldValue;
			}
			else
				cellInfo+=(cellInfo.length>0?"\x03":"")+igtbl_escape(cell.Column.Key+"\x05"+cell.Column.Index+"\x05"+cell.getValue(true));
		}
	}
	return cellInfo;
},
"_generateSqlWhere",
function(dataKeyField,value)
{
	if (!dataKeyField)return;
	var sqlWhere = "";
	var dkfArray = dataKeyField.split(",");
	var valArray = value.split('\x07');
	for(var i = 0 ; i < dkfArray.length ; i++){
		if (i > 0) sqlWhere+=" AND ";
		if (this.Band.getColumnFromKey(dkfArray[i]).DataType==8)
			sqlWhere+=dkfArray[i]+"='"+valArray[i]+"'";
		else
			sqlWhere+=dkfArray[i]+"="+valArray[i];
	}		
	return sqlWhere;	
},
"getChildRows",
function()
{
	var rows=null;
	row=this.Element;
	if(row.getAttribute("groupRow"))
		rows=row.childNodes[0].childNodes[0].childNodes[0].rows[1].childNodes[0].childNodes[0].tBodies[0].rows;
	else
	{
		if(row.nextSibling && row.nextSibling.getAttribute("hiddenRow"))
		{
			if(this.Band.IndentationType==2)
				rows=row.nextSibling.firstChild.firstChild.tBodies[0].rows;
			else
				rows=row.nextSibling.childNodes[this.Band.firstActiveCell].firstChild.tBodies[0].rows;
		}
		else
			rows=null;
	}
	return rows;
}
,
"getCellElements",
function(flCells)
{
	var re=this.Element,nfr=false;
	
	if(!re || re.cells.length==0 || this.GroupByRow) return;
	var result=new Array();
	var start=0;
	if(this.Band.Grid.Bands.length>1) start++;
	if(this.Band.getRowSelectors()<2) start++;
	for(var i=start;i<re.cells.length;i++)
	{
		if(this.Band.Grid.UseFixedHeaders && !nfr)
		{
			if(re.cells[i].childNodes.length>0 && re.cells[i].firstChild.tagName=="DIV" && re.cells[i].firstChild.id.substr(re.cells[i].firstChild.id.length-4)=="_drs")
			{
				re=re.cells[i].firstChild.firstChild.childNodes[1].rows[0];
				i=0;
				nfr=true;
			}
		}
		if(flCells)
		{
			if(re.cells[i].offsetHeight>0)
			{
				result[result.length]=re.cells[i];
				break;
			}
		}
		else
			result[result.length]=re.cells[i];
	}
	if(flCells)
	{
		if(this.Band.Grid.UseFixedHeaders && !nfr)
		{
			re=re.cells[re.cells.length-1].firstChild.firstChild.childNodes[1].rows[0];
			i=0;
		}
		for(var j=re.cells.length-1;j>=i;j--)
			if(re.cells[j].offsetHeight>0)
			{
				result[result.length]=re.cells[j];
				break;
			}
	}
	return result;
}
];
for(var i=0;i<igtbl_ptsRow.length;i+=2)
	igtbl_Row.prototype[igtbl_ptsRow[i]]=igtbl_ptsRow[i+1];

// Add new row object. Inherited from the row object.
igtbl_AddNewRow.prototype=new igtbl_Row();
igtbl_AddNewRow.prototype.constructor=igtbl_AddNewRow;
igtbl_AddNewRow.base=igtbl_Row.prototype;
function igtbl_AddNewRow(element,rows)
{
	if(arguments.length>0)
		this.init(element,rows);
}
var igtbl_ptsAddNewRow=[
"init",
function(element,rows)
{
	this.IsAddNewRow=true;
	igtbl_AddNewRow.base.init.apply(this,[element,null,rows,-1]);
	this.Type="addNewRow";
},
"commit",
function()
{
	if(this._dataChanged)
	{
		this._dataChanged=0;
		var ac=this.Band.Grid.oActiveCell,ar=this.Band.Grid.oActiveRow;
		var newRow=igtbl_rowsAddNew(this.gridId,this.ParentRow,this);
		if(newRow)
		{
			for(var i=0;i<this.Band.Columns.length;i++)
			{
				var cellObj=this.getCell(i);
				cellObj.setValue(cellObj.Column.getValueFromString(cellObj.Column.DefaultValue));
			}
			this._dataChanged=0;
			if(ac && ac.Row.IsAddNewRow)
			{
				var acSel=ac.getSelected();
				if(acSel)
					ac.setSelected(false);
				var nac=newRow.getCell(ac.Column.Index);
				nac.activate();
				if(acSel)
					nac.setSelected();
			}
			else if(ar.IsAddNewRow)
			{
				var arSel=ar.getSelected();
				if(arSel)
					ar.setSelected(false);
				newRow.activate();
				if(arSel)
					newRow.setSelected();
			}
			newRow.processUpdateRow();
		}
		return newRow;
	}
	return null;
},
"isFixed",
function()
{
	return this.isFixedTop() || this.isFixedBottom();
},
"isFixedTop",
function()
{
	return this.Band.Index==0 && this.Band.Grid.StatHeader!=null && this.Band.AddNewRowView==1;
},
"isFixedBottom",
function()
{
	return this.Band.Index==0 && this.Band.Grid.StatFooter!=null && this.Band.AddNewRowView==2;
}
];
for(var i=0;i<igtbl_ptsAddNewRow.length;i+=2)
	igtbl_AddNewRow.prototype[igtbl_ptsAddNewRow[i]]=igtbl_ptsAddNewRow[i+1];

var igtbl_oldMouseDown=null;
var igtbl_currentEditTempl=null;
var igtbl_justAssigned=false;
var igtbl_focusedElement=null;

// Cell object
igtbl_Cell.prototype=new igtbl_WebObject();
igtbl_Cell.prototype.constructor=igtbl_Cell;
igtbl_Cell.base=igtbl_WebObject.prototype;
function igtbl_Cell(element,node,row,index)
{
	if(arguments.length>0)
		this.init(element,node,row,index);
}
var igtbl_ptsCell=[
"init",
function(element,node,row,index)
{
	igtbl_Cell.base.init.apply(this,["cell",element,node]);

	var gs=row.OwnerCollection.Band.Grid;
	this.Row=row;
	this.Band=row.Band;
	if(typeof(index)!="number")
		try{index=parseInt(index.toString(),10);}catch(e){}
	this.Column=this.Band.Columns[index];
	this.Index=index;
	var cell=this.Element;
	if(cell)
	{
		cell.Object=this;
		this.NextSibling=cell.nextSibling;
		if(cell.cellIndex==this.Band.firstaActiveCell)
			this.PrevSibling=null;
		else
			this.PrevSibling=cell.previousSibling;
		if(this.Column.MaskDisplay)
			this.MaskedValue=igtbl_getInnerText(cell);
	}
	this._Changes=new Object();
},
"getElement",
function()
{
	if(this._scrElem)
		return this._scrElem;
	return this.Element;
},
"getValue",
function(textValue,force)
{
	if(typeof(this.Value)!="undefined" && !textValue && !force)
		return this.Value;
	var value;
	if(this.Node)
		value=unescape(this.Node.selectSingleNode("V").text);
	if(this.Element)
	{
		if(!this.Node)
			value=this.Element.getAttribute(igtbl_sigCellText);
		if(typeof(value)!="string")
		{
			value=this.Element.getAttribute(igtbl_sUnmaskedValue);
			if (value) value = unescape(value);			
			if(typeof(value)=="undefined" || value==null)
			{
				var elem=this.Element;
				if(elem.childNodes.length>0 && elem.childNodes[0].tagName=="NOBR")
					elem=elem.childNodes[0];
				if(elem.childNodes.length>0 && elem.childNodes[0].tagName=="A")
					elem=elem.childNodes[0];
				value=igtbl_getInnerText(elem);
				if(value==" ") value="";
			}
			else if(textValue)
			{
				if(this.MaskedValue)
					value=this.MaskedValue;
				else
					value=value.toString();
			}
			var oCombo=null;
			this.Column.ensureWebCombo();
			if(this.Column.WebComboId)
				oCombo=igcmbo_getComboById(this.Column.WebComboId);
			if(oCombo)
			{
				if(!textValue)
				{
					var oCombo=igcmbo_getComboById(this.Column.WebComboId);
					if(oCombo && oCombo.DataTextField)
					{
						var re=new RegExp("^"+igtbl_getRegExpSafe(value)+"$","gi");
						var column=oCombo.grid.Bands[0].getColumnFromKey(oCombo.DataTextField);
						if(column)
						{
							var cell=column.find(re);
							if(cell && oCombo.DataValueField)
								value=cell.Row.getCellByColumn(oCombo.grid.Bands[0].getColumnFromKey(oCombo.DataValueField)).getValue(true);
						}
						delete re;
					}
				}
			}
			else if(this.Column.ColumnType==3 && this.Element.childNodes.length>0)
			{
				if(!this.Element.getAttribute(igtbl_sUnmaskedValue))
				{
					var chBox=this.Element.childNodes[0];
					while(chBox && chBox.tagName!="INPUT")
						chBox=chBox.childNodes[0];
					value=false;
					if(chBox)
						value=chBox.checked;
					if(textValue)
						value=value.toString();
				}
			}
			else if(this.Column.ColumnType==5 && this.Column.ValueList.length>0)
			{
				if(!textValue)
				{
				if ( this.Element.getAttribute(igtbl_sigDataValue) != null)
				{
					value = this.Element.getAttribute(igtbl_sigDataValue)
					
					for(var i=0;i<this.Column.ValueList.length;i++)
						if(this.Column.ValueList[i][1]==value)
						{
							value=this.Column.ValueList[i][0];
							break;
						}
				}		
				}		
			}
			else if(this.Column.ColumnType==7 && this.Element.childNodes.length>0)
			{
				var button=this.Element.childNodes[0];
				while(button && button.tagName!="INPUT")
					button=button.childNodes[0];
				if(button)
					value=button.value;
			}
			if(typeof(value)=="string" && this.Column.AllowNull && value==this.Column.getNullText())
			{
				if(textValue)
					value=this.Column.getNullText();
				else
					value=null;
			}
		}
	}
	
	else
	{
		if(this.Column.MergeCells)
		{
			
			var upRow=this.Row.getPrevRow();
			if (upRow)
				value=upRow.getCellByColumn(this.Column).getValue();
		}
	}
	if(typeof(value)!="undefined")
	{
		if(!textValue)
			value=this.Column.getValueFromString(value);
	}
	else if(textValue)
		value="";
	if(!textValue)
		this.Value=value;
	return value;
},
"setValue",
function(value,fireEvents)
{
	if(typeof(fireEvents)=="undefined")
		fireEvents=true;
	var gn=this.Row.gridId;
	var gs=igtbl_getGridById(gn);
	if(this.Column.DataType!=8 && typeof(value)=="string")
		value=igtbl_trim(value);
	if(!gs.insideBeforeUpdate)
	{
		gs.insideBeforeUpdate=true;
		var ev=value;
		if((ev==null || ev==this.Column.getNullText() || typeof(ev)=='undefined' )&&typeof(ev)!='number')
		{
			ev=this.Column.getNullText();
			value=null;
		} 
		else
		{
			ev=ev.toString().replace(/\r\n/g,"\\r\\n");
			ev=ev.replace(/\"/g,"\\\"");
		}
		var res=fireEvents && this.Element && igtbl_fireEvent(gn,gs.Events.BeforeCellUpdate,"(\""+gn+"\",\""+this.Element.id+"\",\""+ev+"\")");
		gs.insideBeforeUpdate=false;
		if(res==true)
			return;
	}
	var v=value;
	var oldValue=this.getValue();
	if(typeof(value)!="undefined" && value!=null)
	{
		if((oldValue && oldValue.getMonth || this.Column.DataType==7) && typeof(value)=="string")
		{
			if(this.Column.MaskDisplay.substr(0,1).toLowerCase()=="h")
				value="01/01/01 "+value;
			else
			{
				var year="";
				for(var i=value.length-1;i>=0;i--)
				{
					var y=parseInt(value.charAt(i),10);
					if(isNaN(y))
						break;
					else
						year=y.toString()+year;
				}
				if(year && year.length<3)
					value=value.substr(0,i+1)+(parseInt(year,10)+gs.DefaultCentury).toString();
			}
			value=new Date(value);
		}
		if(value.getMonth)
		{
			if(isNaN(value)) value=oldValue;
			v=value;
			if(value)
				value=(value.getMonth()+1).toString()+"/"+value.getDate().toString()+"/"+(value.getFullYear().toString().length>4?value.getFullYear().toString().substr(0,4):value.getFullYear())+" "+(value.getHours()==0?"12":(value.getHours()%12).toString())+":"+(value.getMinutes()<10?"0":"")+value.getMinutes()+":"+(value.getSeconds()<10?"0":"")+value.getSeconds()+" "+(value.getHours()<12?"AM":"PM");
		}
	}
	if(this.Element)
	{
		if(this.Element.getAttribute(igtbl_sigCellText)!=null)
			this.Element.setAttribute(igtbl_sigCellText,value==null?"":value);
		else 
		{
			var rendVal=null;
			if(this.Column.editorControl && this.Column.editorControl.getRenderedValue && (rendVal=this.Column.editorControl.getRenderedValue(v))!=null)
			{
				v=rendVal;
				if(value!=null)
				{	

					this.Element.setAttribute(igtbl_sUnmaskedValue,value.toString());
				}
				else
					this.Element.removeAttribute(igtbl_sUnmaskedValue);
				this.MaskedValue=v;
			}
			else 
			{
				if(this.Column.AllowNull && (typeof(v)=="undefined" || v==null || typeof(v)=="string" && (v=="" || v==this.Column.getNullText())))
				{
					v=this.Column.getNullText();
					value="";
				}
				else
					v=typeof(value)!="undefined" && value!=null?value.toString():"";
				if(this.Column.MaskDisplay!="")
				{
					if(this.Column.AllowNull && v==this.Column.getNullText())
					{						
						this.Element.setAttribute(igtbl_sUnmaskedValue,null);
						this.MaskedValue=(v==""?" ":v);
					}
					else
					{
						v=igtbl_Mask(gn,v,this.Column.DataType,this.Column.MaskDisplay);
						if(v=="")
						{
							var umv=this.Element.getAttribute(igtbl_sUnmaskedValue);
							if(ig_csom.notEmpty(umv))
								v=igtbl_Mask(gn,umv,this.Column.DataType,this.Column.MaskDisplay);
							else
							{
								v=this.Column.getNullText();
								value="";
							}
						}
						else
						{
							if(this.Column.MaskDisplay=="MM/dd/yyyy" || this.Column.MaskDisplay=="MM/dd/yy" || this.Column.MaskDisplay=="hh:mm" || this.Column.MaskDisplay=="HH:mm" || this.Column.MaskDisplay=="hh:mm tt")
								value=v;
							this.Element.setAttribute(igtbl_sUnmaskedValue,value);
							this.MaskedValue=v;							
						}
					}
				}
				else if(ig_csom.notEmpty(this.Element.getAttribute(igtbl_sUnmaskedValue)))
					this.Element.setAttribute(igtbl_sUnmaskedValue,value)
				if(!(this.Column.AllowNull && v==this.Column.getNullText()))
				{
					if(this.Column.MaskDisplay=="")
					{
						if(typeof(value)!="undefined" && value!=null && this.Column.DataType!=7)
						{
							v=this.Column.getValueFromString(value);
							if(v!=null)
							{
								v=v.toString();
								value=v;
							}
						}							
						if(this.Column.FieldLength>0)
						{
							v=v.substr(0,this.Column.FieldLength);
							value=v;
						}
						if(this.Column.Case==1)
							v=v.toLowerCase();
						else if(this.Column.Case==2)
							v=v.toUpperCase();
					}
				}
			}
			var setInner=true;
			this.Column.ensureWebCombo();
			if(this.Column.WebComboId && typeof(igcmbo_getComboById)!="undefined")
			{
				var oCombo=igcmbo_getComboById(this.Column.WebComboId);
				if(oCombo && oCombo.DataValueField)
				{
					var re=new RegExp("^"+igtbl_getRegExpSafe(value)+"$","gi");
					var column=oCombo.grid.Bands[0].getColumnFromKey(oCombo.DataValueField);
					if(column)
					{
						var cell=column.find(re);
						if(cell && oCombo.Prompt && cell.Row.getIndex()==0)
							cell=column.findNext();
					}
					if(cell && oCombo.DataTextField)
						v=cell.Row.getCellByColumn(oCombo.grid.Bands[0].getColumnFromKey(oCombo.DataTextField)).getValue(true);
					this.Element.setAttribute(igtbl_sigDataValue,value);
					this.Element.setAttribute(igtbl_sUnmaskedValue,value.toString());
					delete re;
				}
			}
			else if(this.Column.ColumnType==3 && this.Element.childNodes.length>0)
			{
				igtbl_dontHandleChkBoxChange=true;
				var chBox=this.Element.childNodes[0];
				while(chBox && chBox.tagName!="INPUT")
					chBox=chBox.childNodes[0];
				if(chBox)
				{
					if(!value || value.toString().toLowerCase()=="false" || v=="0")
						chBox.checked=false;
					else
						chBox.checked=true;
					this.Element.setAttribute("chkBoxState",v);
					if(this.Column.DataType!=11)
						this.Element.setAttribute(igtbl_sUnmaskedValue,v);
				}
				igtbl_dontHandleChkBoxChange=false;
				setInner=false;
			}
			else if(this.Column.ColumnType==5 && this.Column.ValueList.length>0)
			{
				for(var i=0;i<this.Column.ValueList.length;i++)
					if(this.Column.ValueList[i][0]==value)
					{
						v=this.Column.ValueList[i][1];
						this.Element.setAttribute(igtbl_sigDataValue,value);
						break;
					}
				if(i==this.Column.ValueList.length)
					this.Element.removeAttribute(igtbl_sigDataValue);
			}
			else if(this.Column.ColumnType==7 && this.Element.childNodes.length>0)
			{
				var button=this.Element.childNodes[0];
				while(button && button.tagName!="INPUT")
					button=button.childNodes[0];
				if(button)
				{
					button.value=v;
					setInner=false;
				}
				else
				{
					button=igtbl_getElementById(gn+"_bt");
					if(button)
						button.value=v;
				}
			}
			if(setInner)
			{				
				var vs=igtbl_trim(v);
				var e=this.Element;
				if(vs=="")
				{
					vs=" ";
					e.setAttribute(igtbl_sUnmaskedValue,v);
				}
				else if(e.getAttribute(igtbl_sUnmaskedValue,"")=="")
					e.removeAttribute(igtbl_sUnmaskedValue);
				e=this.getElement();
				el=e;
				if(el.firstChild && el.firstChild.tagName=="NOBR")
					el=el.firstChild;
				if(el.firstChild && el.firstChild.tagName=="A")
					el=el.firstChild;
				if(el.tagName=="A")
				{
					if((value!=" " && vs==" ")||vs=="")
					{
						igtbl_setInnerText(el,"");
						if (	el.parentNode.innerHTML.indexOf(" ")>0 
							&&	el.parentNode.innerHTML.lastIndexOf(" ") < (el.parentNode.innerHTML.length-1)
							&&	el.parentNode.innerHTML.indexOf("&nbsp;")>0 
							&&	el.parentNode.innerHTML.lastIndexOf("&nbsp;") < (el.parentNode.innerHTML.length-1-5)
							) 
						el.parentNode.innerHTML += "&nbsp;";
					}
					else
					{						
						igtbl_setInnerText(el,vs);
					}
				}
				else
						igtbl_setInnerText(el,vs);	
				if(el.tagName=="A" && this.Column.ColumnType==9)
					el.href=(v.indexOf('@')>=0?"mailto:":"")+v;
				if(this.Node)
					this.Node.selectSingleNode("Ct").firstChild.text=(e.getAttribute(igtbl_sUnmaskedValue,"")=="")?"&nbsp;":vs;				
			}
		}
	}
	if (this.Node) 
	this.Node.selectSingleNode("V").text = igtbl_escape(value==null?this.Column.getNullText():value);
	var newValue=this.getValue(false,true);
	if(!((typeof(newValue)=="undefined" || newValue==null) && (typeof(oldValue)=="undefined" || oldValue==null) || newValue!=null && oldValue!=null && newValue.valueOf()==oldValue.valueOf()))
	{
		this.Row._dataChanged|=2;
		if(typeof(this._oldValue)=="undefined")
		{
			if (oldValue&&oldValue.getMonth)
				oldValue=(oldValue.getMonth()+1).toString()+"/"+oldValue.getDate().toString()+"/"+(oldValue.getFullYear().toString().length>4?oldValue.getFullYear().toString().substr(0,4):oldValue.getFullYear())+" "+(oldValue.getHours()==0?"12":(oldValue.getHours()%12).toString())+":"+(oldValue.getMinutes()<10?"0":"")+oldValue.getMinutes()+":"+(oldValue.getSeconds()<10?"0":"")+oldValue.getSeconds()+" "+(oldValue.getHours()<12?"AM":"PM");			
			this._oldValue=oldValue;
		}
		if(!this.Row.IsAddNewRow)
			igtbl_saveChangedCell(gs,this,value);
		if(this.Node)
		{
				this.Node.selectSingleNode("V").text=value==null?"":igtbl_escape(value.toString());
	
			gs.invokeXmlHttpRequest(gs.eReqType.UpdateCell,this,value?value.toString():value);
		}
		if(fireEvents && this.Element)
		{
			igtbl_fireEvent(gn,gs.Events.AfterCellUpdate,"(\""+gn+"\",\""+this.Element.id+"\")");
			if(gs.LoadOnDemand==3)
				gs.NeedPostBack=false;
		}
	}
},
"getRow",
function()
{
	return this.Row;
},
"getNextTabCell",
function(shift
,addRow
)
{
	var g=this.Row.Band.Grid;
	var cell=null;
	switch(g.TabDirection)
	{
		case 0:
		case 1:
			if(shift && g.TabDirection==0 || !shift && g.TabDirection==1)
			{			
				
				cell=this;
				do
				{ 
					cell=this.getPrevCell();
					if (!cell) break;
				} while(!cell.Element);				
				if(!cell)
				{
					var row=this.Row.getNextTabRow(true
					,false,addRow
					);
					if(row && !row.GroupByRow)
					{
						cell=row.getCell(row.cells.length-1);
						if(!cell.Column.getVisible())
							cell=cell.getPrevCell();
					}
				}
			}
			else
			{
				
				cell=this;
				do
				{ 
					cell=cell.getNextCell();
					if (!cell) break;
				} while(!cell.Element);
				if(!cell)
				{
					var row=this.Row.getNextTabRow(false
					,false,addRow
					);
					if(row && !row.GroupByRow)
					{
						cell=row.getCell(0);
						if(!cell.Column.getVisible())
							cell=cell.getNextCell();
					}
				}
			}
			break;
		case 2:
		case 3:
			if(shift && g.TabDirection==2 || !shift && g.TabDirection==3)
			{
				var row=this.Row.getPrevRow();
				if(row && row.getExpanded())
				{
					row=this.Row.getNextTabRow(true
					,false,addRow
					);
					cell=row.getCell(row.cells.length-1);
					if(!cell.Column.getVisible())
						cell=cell.getPrevCell();
				}
				else if(row)
					cell=row.getCell(this.Index);
				else
				{
					if(this.Index==0)
					{
						row=this.Row.getNextTabRow(true
						,false,addRow
						);
						if(row && !row.GroupByRow)
						{
							cell=row.getCell(row.cells.length-1);
							if(!cell.Column.getVisible())
								cell=cell.getPrevCell();
						}
					}
					else
					{
						cell=this.Row.OwnerCollection.getRow(this.Row.OwnerCollection.length-1).getCell(this.Index-1);
						if(!cell.Column.getVisible())
							cell=cell.getPrevCell();
					}
				}
			}
			else
			{
				if(this.Row.getExpanded())
				{
					cell=this.Row.Rows.getRow(0).getCell(0);
					if(!cell.Column.getVisible())
						cell=cell.getNextCell();
				}
				else
				{
					var row=this.Row.getNextRow();
					if(row)
						cell=row.getCell(this.Index);
					else if(this.Index<this.Row.cells.length-1)
					{
						cell=this.Row.OwnerCollection.getRow(0).getCell(this.Index+1);
						if(!cell.Column.getVisible())
							cell=cell.getNextCell();
					}
					else
					{
						row=this.Row.getNextTabRow(false
						,false,addRow
						);
						if(row && !row.GroupByRow)
						{
							cell=row.getCell(0);
							if(!cell.Column.getVisible())
								cell=cell.getNextCell();
						}
					}
				}
			}
			break;
	}
	return cell;
},
"beginEdit",
function(keyCode)
{
	if(this.isEditable())
	{
		igtbl_editCell((typeof(event)!="undefined"?event:null),this.Row.gridId,this.Element,keyCode);
		var ec=this.Band.Grid._editorCurrent;
		if(ec && igtbl_isVisible(ec))
		{
			ec.setAttribute("noOnBlur",true);
			window.setTimeout("igtbl_cancelNoOnBlurTB('"+this.Band.Grid.Id+"','"+ec.id+"')",100);
		}
	}
},
"endEdit",
function()
{
	var ec=this.Column.editorControl;
	if(ec && ec.getAttribute("noOnBlur"))
		return;
	igtbl_hideEdit(this.Row.gridId);
},
"getSelected",
function()
{
	if(this._Changes["SelectedCells"])
		return true;
	return false;
},
"setSelected",
function(select)
{
	var stc=this.Band.getSelectTypeCell();
	if(stc>1)
	{
		if(stc==2)
			this.Band.Grid.clearSelectionAll();
		igtbl_selectCell(this.Row.gridId,this,select);
	}
},
"getNextCell",
function()
{
	var nc=this.Index+1;
	while(nc<this.Row.cells.length && !this.Row.getCell(nc).Column.getVisible())
		nc++;
	if(nc<this.Row.cells.length)
		return this.Row.getCell(nc);
	return null;
},
"getPrevCell",
function()
{
	var pc=this.Index-1;
	while(pc>=0 && !this.Row.getCell(pc).Column.getVisible())
		pc--;
	if(pc>=0)
		return this.Row.getCell(pc);
	return null;
},
"activate",
function()
{
	this.Row.Band.Grid.setActiveCell(this);
},
"scrollToView",
function()
{
	var g=this.Row.Band.Grid;
	if(g.UseFixedHeaders)
	{
		var c=this.Column;
		
		
		var w=0,i=0,c1=null,fixedW=0;
		while(i<c.Index)
		{
			c1=c.Band.Columns[i++];
			if(c1.getVisible())
			{
				if  (!c1.getFixed())
					w+=c1.getWidth();
				else
					fixedW+=c1.getWidth();
			}
		}
		if(!c.getFixed() && w+c.getWidth()<g._scrElem.scrollLeft)
		{
			igtbl_scrollLeft(g._scrElem,w)
		}
					
		if ((g._scrElem.clientWidth-fixedW-(w-g._scrElem.scrollLeft)<c.getWidth()) ||
				w-g._scrElem.scrollLeft<0
			)			
		igtbl_scrollToView(g.Id,this.Element,c.getWidth(),w
			,this.Row.IsAddNewRow && this.Row.isFixed()?1:0
		);
		return;
	}
	igtbl_scrollToView(g.Id,this.Element
		,null,null,this.Row.IsAddNewRow && this.Row.isFixed()?1:0
	);
},
"isEditable",
function()
{
	var attr="";
	if(this.Node)
		attr=this.Node.getAttribute("lit:allowedit");
	else if(this.Element)
		attr=this.Element.getAttribute("allowedit");
	if(attr=="yes")
		return true;
	if(attr=="no")
		return false;
	return igtbl_getAllowUpdate(this.Row.gridId,this.Column.Band.Index,this.Column.Index)==1;
},
"setEditable",
function(bEdit)
{
	if (bEdit==null || typeof(bEdit)=="undefined")
		bEdit=false;
	var attr = 	bEdit?"yes":"no";
	if(this.Node)
		this.Node.setAttribute("lit:allowedit",attr)
	if(this.Element)
		this.Element.setAttribute("allowedit",attr);
},
"renderActive",
function(render)
{
	var g=this.Row.Band.Grid;
	if(!g.Activation.AllowActivation || !this.Element)
		return;
	var e=this.getElement();
	
	
	{
		this.renderActiveLeft(render);
		this.renderActiveTop(render);
		this.renderActiveRight(render);
		this.renderActiveBottom(render);
	}
},
"renderActiveLeft",
function(render)
{
	var g=this.Row.Band.Grid;
	if(!g.Activation.AllowActivation || !this.Element)
		return;
	var e=this.getElement();
	var styleTS=e.style;
	if(!(ig_csom.IsNetscape6 || ig_csom.IsNetscape))
	{
		styleTS=e.runtimeStyle;
		igtbl_changeBorder(g,e.currentStyle,styleTS,this,"Left",render);
	}
	else
		igtbl_changeBorder(g,styleTS,styleTS,this,"Left",render);
	if(render==false && !(ig_csom.IsNetscape6 || ig_csom.IsNetscape) && styleTS.cssText.length>0)
		styleTS.cssText=styleTS.cssText.replace(/BORDER-LEFT/g,"");

},
"renderActiveTop",
function(render)
{
	var g=this.Row.Band.Grid;
	if(!g.Activation.AllowActivation || !this.Element)
		return;
	var e=this.getElement();
	var styleTS=e.style;
	if(!(ig_csom.IsNetscape6 || ig_csom.IsNetscape))
	{
		styleTS=e.runtimeStyle;
		igtbl_changeBorder(g,e.currentStyle,styleTS,this,"Top",render);
	}
	else
		igtbl_changeBorder(g,styleTS,styleTS,this,"Top",render);
	igtbl_changeBorder(g,styleTS,this,"Top",render);
	if(render==false && !(ig_csom.IsNetscape6 || ig_csom.IsNetscape) && styleTS.cssText.length>0)
		styleTS.cssText=styleTS.cssText.replace(/BORDER-TOP/g,"");
},
"renderActiveRight",
function(render)
{
	var g=this.Row.Band.Grid;
	if(!g.Activation.AllowActivation || !this.Element)
		return;
	var e=this.getElement();
	var styleTS=e.style;
	if(!(ig_csom.IsNetscape6 || ig_csom.IsNetscape))
	{
		styleTS=e.runtimeStyle;
		igtbl_changeBorder(g,e.currentStyle,styleTS,this,"Right",render);
	}
	else
		igtbl_changeBorder(g,styleTS,styleTS,this,"Right",render);
	igtbl_changeBorder(g,styleTS,this,"Right",render);
	if(render==false && !(ig_csom.IsNetscape6 || ig_csom.IsNetscape) && styleTS.cssText.length>0)
		styleTS.cssText=styleTS.cssText.replace(/BORDER-RIGHT/g,"");
},
"renderActiveBottom",
function(render)
{
	var g=this.Row.Band.Grid;
	if(!g.Activation.AllowActivation || !this.Element)
		return;
	var e=this.getElement();
	var styleTS=e.style;
	if(!(ig_csom.IsNetscape6 || ig_csom.IsNetscape))
	{
		styleTS=e.runtimeStyle;
		igtbl_changeBorder(g,e.currentStyle,styleTS,this,"Bottom",render);
	}
	else
		igtbl_changeBorder(g,styleTS,styleTS,this,"Bottom",render);
	igtbl_changeBorder(g,styleTS,this,"Bottom",render);
	if(render==false && !(ig_csom.IsNetscape6 || ig_csom.IsNetscape) && styleTS.cssText.length>0)
		styleTS.cssText=styleTS.cssText.replace(/BORDER-BOTTOM/g,"");
},
"getLevel",
function(s)
{
	var l=this.Row.getLevel();
	l[l.length]=this.Column.Index;
	if(s)
	{
		s=l.join("_");
		igtbl_dispose(l);
		delete l;
		return s;
	}
	return l;
},
"selectCell",
function(selFlag)
{
	var e=this.getElement();
	if(!e)
		return;
	var className=null;
	if(selFlag!=false)
		className=this.Column.getSelClass();
	igtbl_changeStyle(this.Row.gridId,e,className);
},
"select",
function(selFlag,fireEvent)
{
	var gs=this.Column.Band.Grid;
	var gn=gs.Id;
	var cellID=this.Element.id;
	if(gs._exitEditCancel || gs._noCellChange)
		return;
	if(this.Band.getSelectTypeCell()<2)
		return;
	if(igtbl_fireEvent(gn,gs.Events.BeforeSelectChange,"(\""+gn+"\",\""+cellID+"\")")==true)
		return;
	if(selFlag!=false)
	{
		this.selectCell();
		
		gs._recordChange("SelectedCells",this,gs.GridIsLoaded);
		if(!gs.SelectedCellsRows[this.Element.parentNode.id])
			gs.SelectedCellsRows[this.Element.parentNode.id]=new Object();
		gs.SelectedCellsRows[this.Element.parentNode.id][cellID]=true;
	}
	else
	{
		
		if(gs.SelectedCells[cellID] || gs._containsChange("SelectedCells",this))
		{
			gs._removeChange("SelectedCells",this);
			var scr=gs.SelectedCellsRows[this.Element.parentNode.id];
			if(scr && scr[cellID])
				delete scr[cellID];
		}
		if(igtbl_getLength(gs.SelectedCellsRows[this.Element.parentNode.id])==0)
			delete gs.SelectedCellsRows[this.Element.parentNode.id];
		if(!this.Column.Selected && !this.Row.getSelected())
			this.selectCell(false);
	}
	if(this==gs.oActiveCell)
		this.renderActive();
	if(fireEvent!=false)
	{
		var gsNPB = gs.NeedPostBack;
		igtbl_fireEvent(gn,gs.Events.AfterSelectChange,"(\""+gn+"\",\""+cellID+"\");");
		if(!gsNPB && !(gs.Events.AfterSelectChange[1]&1))
			gs.NeedPostBack=false;
		if(gs.NeedPostBack)
			igtbl_moveBackPostField(gn,"SelectedCells");
	}	
},
"getOldValue",
function()
{
	return this._oldValue;
},
"getTargetURL",
function()
{
	var url=null;
	if(this.Node && (url=this.Node.getAttribute("targetURL")))
		return url;
	if(this.Element && (url=this.Element.getAttribute("targetURL")))
		return url;
	if(this.Column.ColumnType==9)
		return this.getValue();
	return url;
},
"setTargetURL",
function(url)
{
	if(this.Node && this.Node.getAttribute("targetURL"))
		this.Node.setAttribute("targetURL",url);
	if(this.Element && this.Element.getAttribute("targetURL"))
		this.Element.setAttribute("targetURL",url);
	var urls=igtbl_splitUrl(url);
	var el=this.Element;
	if(el)
	{
		if(el.firstChild && el.firstChild.tagName=="NOBR")
			el=el.firstChild;
		if(el.firstChild && el.firstChild.tagName=="A")
			el=el.firstChild;
	}
	if(this.Column.ColumnType==9)
		this.setValue(urls[0]);
	if(el && el.tagName=="A")
	{
		if(this.Column.ColumnType!=9)
			el.href=urls[0];
		if(urls[1])
			el.target=urls[1];
		else
			el.target="_self";
	}
	igtbl_dispose(urls);
}
];
for(var i=0;i<igtbl_ptsCell.length;i+=2)
	igtbl_Cell.prototype[igtbl_ptsCell[i]]=igtbl_ptsCell[i+1];

// State change object
igtbl_StateChange.prototype=new igtbl_WebObject();
igtbl_StateChange.prototype.constructor=igtbl_StateChange;
igtbl_StateChange.base=igtbl_WebObject.prototype;
function igtbl_StateChange(type,grid,obj,value)
{
	if(arguments.length>0)
		this.init(type,grid,obj,value);
}
igtbl_StateChange.prototype.init=function(type,grid,obj,value)
{
	igtbl_StateChange.base.init.apply(this,[type]);
	this.Node=ig_ClientState.addNode(grid.StateChanges,"StateChange");
	
	this.Grid=grid;
	this.Object=obj;
	ig_ClientState.setPropertyValue(this.Node,"Type",this.Type);
	if(typeof(value)!="undefined" && value!=null)
	{
		if(value=="" && typeof(value)=="string") value="\x01";
		ig_ClientState.setPropertyValue(this.Node,"Value",value);
	}
	if(obj)
	{
		if(obj.getLevel)
			ig_ClientState.setPropertyValue(this.Node,"Level",obj.getLevel(true));
		if(this.Object._Changes[this.Type])
		{
			var ch=this.Object._Changes[this.Type];
			if(!ch.length)
				ch=new Array(ch);
			this.Object._Changes[this.Type]=ch.concat(this);
		}
		else
			this.Object._Changes[this.Type]=this;
	}
}
igtbl_StateChange.prototype.remove=function(lastOnly)
{
	if(lastOnly && this.Grid.StateChanges.lastChild!=this.Node)
		return;
	ig_ClientState.removeNode(this.Grid.StateChanges,this.Node);
	var ch=this.Object._Changes[this.Type];
	if(ch.length)
	{
		for(var i=0;i<ch.length;i++)
			if(ch[i]==this)
			{
				ch=this.Object._Changes[this.Type]=ch.slice(0,i).concat(ch.slice(i+1));
				break;
			}
		if(ch.length==1)
		{
			this.Object._Changes[this.Type]=ch[0];
			ch[0]=null;
			igtbl_dispose(ch);
		}
	}
	else
		delete this.Object._Changes[this.Type];
	this.Grid=null;
	this.Object=null;
	this.Node=null;
	igtbl_dispose(this);
}
igtbl_StateChange.prototype.setFireEvent=function(value)
{
	ig_ClientState.setPropertyValue(this.Node,"FireEvent",value.toString());
}


if(typeof igtbl_gridState!="object")
var igtbl_gridState=new Object();

var igtbl_bInsideigtbl_oldOnSubmit=false;
function igtbl_submit()
{
    var retVal=true;
	if(arguments.length==0 || (ig_csom.IsNetscape ||  ig_csom.IsNetscape6) && arguments.length==1)
	{
		if(this.igtbl_oldOnSubmit && !igtbl_bInsideigtbl_oldOnSubmit)
		{
			igtbl_bInsideigtbl_oldOnSubmit=true;
			if(arguments.length==0)
				retVal=this.igtbl_oldOnSubmit();
			else
				retVal=this.igtbl_oldOnSubmit(arguments[0]);
			igtbl_bInsideigtbl_oldOnSubmit=false;
		}
		igtbl_updateGridsPost(this.igtblGrid);
		
		if(window.__smartNav)
			igtbl_unloadGrid(this.igtblGrid.Id);
	}
	else if(typeof(window.__doPostBackOld)!="undefined" && !igtbl_bInsideigtbl_oldOnSubmit && window.__thisForm)
	{
		igtbl_updateGridsPost(window.__thisForm.igtblGrid);
		igtbl_bInsideigtbl_oldOnSubmit=true;
		retVal=window.__doPostBackOld(arguments[0],arguments[1]);
		igtbl_bInsideigtbl_oldOnSubmit=false;
		
	}
	return retVal;
}

function igtbl_formSubmit()
{
	igtbl_updateGridsPost(this.igtblGrid);
	var val;
	
	try
	{
		val = this.oldSubmit();
	}
	catch(e){};
	return val;
}

function igtbl_updateGridsPost(grid)
{
	if(!grid) return;
	igtbl_updateGridsPost(grid.oldIgtblGrid);
	grid.update();
}
	
function igtbl_initActivation(aa)
{
	this.AllowActivation=aa[0];
	this.BorderColor=aa[1];
	this.BorderStyle=aa[2];
	this.BorderWidth=aa[3];
	this.BorderDetails=new Object();
	var bd=this.BorderDetails;
	bd.ColorLeft=aa[4][0];
	bd.ColorTop=aa[4][1];
	bd.ColorRight=aa[4][2];
	bd.ColorBottom=aa[4][3];
	bd.StyleLeft=aa[4][4];
	bd.StyleTop=aa[4][5];
	bd.StyleRight=aa[4][6];
	bd.StyleBottom=aa[4][7];
	bd.WidthLeft=aa[4][8];
	bd.WidthTop=aa[4][9];
	bd.WidthRight=aa[4][10];
	bd.WidthBottom=aa[4][11];
	this.getValue=function(where,what)
	{
		var res="";
		if(where)
			res=this.BorderDetails[what+where];
		if(res=="" || res=="NotSet")
			res=this["Border"+what];
		return res;
	}
	this.hasBorderDetails=function()
	{
		var bd=this.BorderDetails;
		if(bd.ColorLeft || bd.ColorTop || bd.ColorRight || bd.ColorBottom ||
			bd.StyleLeft || bd.StyleTop || bd.StyleRight || bd.StyleBottom ||
			bd.WidthLeft || bd.WidthTop || bd.WidthRight || bd.WidthBottom)
			return true;
		return false;
	}
}
function igtbl_deleteSelRows(gn)
{
	var gs=igtbl_getGridById(gn);
	var ar=gs.getActiveRow();
	
	if (ar && ar.IsAddNewRow) return;
	var del=false;
	if(igtbl_inEditMode(gn))
	{
		igtbl_hideEdit(gn);
		if(igtbl_inEditMode(gn))
			return;
	}
	if(gs.Node)
	{
		var arOffs=ar?ar.getIndex():0;
		gs.isDeletingSelected=true;
		var arr=igtbl_sortRowIdsByClctn(gs.SelectedRows);
		for(var i=0;i<arr.length;i++)
		{
			var row=gs.getRowByLevel(arr[i]);
			if(row.deleteRow())
			{
				if(i==arr.length-1 || arr[i].length!=arr[i+1].length || arr[i].length>1 && arr[i][arr[i].length-2]!=arr[i+1][arr[i+1].length-2])
				{
					var rows=row.OwnerCollection;
					rows.SelectedNodes=rows.Node.selectNodes("R");
					if(!rows.SelectedNodes.length)
						rows.SelectedNodes=rows.Node.selectNodes("Group");
					rows.reIndex(row.getIndex(true));
					rows.repaint();
				}
			}
		}
		if(!arr.length && ar)
		{
			var rows=ar.OwnerCollection;
			if(ar.deleteRow())
			{
				rows.SelectedNodes=rows.Node.selectNodes("R");
				if(!rows.SelectedNodes.length)
					rows.SelectedNodes=rows.Node.selectNodes("Group");
				while(rows.length==0 && rows.ParentRow && rows.ParentRow.GroupByRow)
					rows=rows.ParentRow.OwnerCollection;
				rows.reIndex(arOffs);
				rows.repaint();
			}
		}
		if(ar && !gs.getActiveRow())
		{
			var rows=ar.OwnerCollection;
			if(arOffs<rows.length)
				rows.getRow(arOffs).activate();
			else if(rows.length>0)
				rows.getRow(rows.length-1).activate();
			else if(rows.ParentRow)
				rows.ParentRow.activate();
			ar=gs.getActiveRow();
			if(ar && ar.Band.getSelectTypeRow()==2)
				ar.setSelected();
		}
		gs.isDeletingSelected=false;
		ig_dispose(arr);
		delete arr;
	}
	else
	{
		var r=null;
		if(ar && !gs.getActiveCell())
		{
			r=ar.getNextRow();
			while(r && r.getSelected())
				r=r.getNextRow();
			if(!r)
			{
				r=ar.getPrevRow();
				while(r && r.getSelected())
					r=r.getPrevRow();
			}
			if(!r)
				r=ar.ParentRow;
		}
		for(var rowId in gs.SelectedRows)
		{
			if(gs.SelectedRows[rowId])
			{
				var row=igtbl_getRowById(rowId);
				if(row && row.deleteRow(true))
					del=true;
			}
		}
		ar=gs.getActiveRow();
		if(!del && ar && !gs.SelectedRows[ar.Element.id])
		{
			del=ar.deleteRow(true);
			if(del) ar=null;
		}
		if(del)
		{
			if(r && igtbl_getElementById(r.Element.id))
			{
				if(r.Band.getSelectTypeRow()==2)
					r.setSelected();
				r.activate();
				ar=r;
			}
			else
				ar=null;
		}
		if(!ar)
			gs.setActiveRow(null);
	}
	gs.alignStatMargins();
	if(gs.NeedPostBack)
		igtbl_doPostBack(gn);
}

function igtbl_deleteRow(gn,rowId)
{
	var row=igtbl_getRowById(rowId);
	if(!row)
		return false;
	return row.deleteRow();
}

function igtbl_gSelectArray(gn,elem,array)
{
	var gs=igtbl_getGridById(gn);
	gs._noCellChange=false;
	if(elem==0)
	{
		var oldSelCells=gs.SelectedCells;
		gs.SelectedCells=new Object();
		
		for(var i=0;i<array.length;i++)
			if(oldSelCells[array[i]])
				gs.SelectedCells[array[i]]=true;
		var fireOnUnsel=true;
		for(var i=0;i<array.length;i++)
			if(!oldSelCells[array[i]])
			{
				igtbl_selectCell(gn,array[i]);
				fireOnUnsel=false;
			}
		for(var cell in oldSelCells)
			if(!gs.SelectedCells[cell])
				igtbl_selectCell(gn,cell,false,fireOnUnsel);
		for(var cell in oldSelCells)
			delete oldSelCells[cell];
	}
	else if(elem==1)
	{
		var oldSelRows=gs.SelectedRows;
		gs.SelectedRows=new Object();
		
		for(var i=0;i<array.length;i++)
			if(oldSelRows[array[i]])
				gs.SelectedRows[array[i]]=true;
		var fireOnUnsel=true;
		for(var i=0;i<array.length;i++)
			if(!oldSelRows[array[i]])
			{
				igtbl_selectRow(gn,array[i]);
				fireOnUnsel=false;
			}
		for(var row in oldSelRows)
			if(!gs.SelectedRows[row])
				igtbl_selectRow(gn,row,false,fireOnUnsel);
		for(var row in oldSelRows)
			delete oldSelRows[row];
	}
	else
	{
		var oldSelCols=gs.SelectedColumns;
		gs.SelectedColumns=new Object();
		
		for(var i=0;i<array.length;i++)
			if(oldSelCols[array[i]])
				gs.SelectedColumns[array[i]]=true;
		var fireOnUnsel=true;
		for(var i=0;i<array.length;i++)
			if(!oldSelCols[array[i]])
			{
				igtbl_selectColumn(gn,array[i]);
				fireOnUnsel=false;
			}
		for(var col in oldSelCols)
			if(!gs.SelectedColumns[col])
				igtbl_selectColumn(gn,col,false,fireOnUnsel);
		for(var col in oldSelCols)
			delete oldSelCols[col];
	}
}

function igtbl_expandEffects(values)
{
	this.Delay=values[0];
	this.Duration=values[1];
	this.Opacity=values[2];
	this.ShadowColor=values[3];
	this.ShadowWidth=values[4];
	this.EffectType=values[5];
}

function igtbl_hideColHeader(tBody,col,hide)
{
	var realIndex=-1;
	var tr=tBody.childNodes[0];
	for(var i=0;i<tr.cells.length;i++)
	{
		var c=tr.cells[i];
		if(c.colSpan>1 && c.firstChild.tagName=="DIV" && c.firstChild.id.substr(c.firstChild.id.length-4)=="_drs")
		{
			tr=c.firstChild.firstChild.childNodes[1].rows[0];
			i=0;
			c=tr.cells[i];
		}
		if(c.style.display=="")
			realIndex++;
		if(c.id==col.Id || c.id==col.fId)
		{
			var h=(hide?"none":"");
			if(c.style.display==h)
				return;
			c.style.display=h;
			if(tBody.nextSibling.nextSibling)
				tBody.nextSibling.nextSibling.childNodes[0].childNodes[i].style.display=(hide?"none":"");
			var chn=tBody.previousSibling.childNodes;
			if(hide)
			{
				var ch=chn[realIndex];
				col.Width=ch.width;
				ch.parentNode.appendChild(ch);
				ch.width=1;
				ch.style.display="none";
				if(tBody.nextSibling.nextSibling)
					tBody.nextSibling.nextSibling.childNodes[0].childNodes[chn.length-1].width=col.Width;
			}
			else
			{
				var ch=chn[chn.length-1];
				if(chn[realIndex+1])
					ch.parentNode.insertBefore(ch,chn[realIndex+1])
				if(ch.style.display=="none")
					ch.style.display="";
				ch.style.cssText=col.Style;
				ch.width=col.Width;
				if(tBody.nextSibling.nextSibling)
					tBody.nextSibling.nextSibling.childNodes[0].childNodes[i].width=col.Width;
			}
			break;
		}
	}
}

function igtbl_hideColumn(rows,col,hide)
{
	var g=col.Band.Grid;
	igtbl_lineupHeaders(col.Id,col.Band);
	if(col.Band.Index==rows.Band.Index)
	{
		if(col.Band.Index==0)
		{
			if(g.StatHeader)
			{
				var el=g.StatHeader.getElementByColumn(col);
				igtbl_hideColHeader(g.StatHeader.Element,col,hide);
			}
			if(g.StatFooter)
			{
				var el=g.StatFooter.getElementByColumn(col);
				igtbl_hideColHeader(g.StatFooter.Element,col,hide);
			}
		}
		var tBody=rows.Element.previousSibling;
		if(tBody)
			igtbl_hideColHeader(tBody,col,hide);
	}
	for(var i=0;i<rows.length;i++)
	{
		var row=rows.getRow(i);
		if(col.Band.Index==rows.Band.Index && !row.GroupByRow)
		{
			var cell=row.getCellByColumn(col);
			if(hide)
			{
				cell.Element.style.display="none";
				if(col.Band.Grid.getActiveRow()==row)
				{
					if(typeof(cell.oldBorderLeftStyle)!="undefined")
					{
						cell.renderActiveLeft(false);
						for(var j=col.Index+1;j<col.Band.Columns.length;j++)
							if(col.Band.Columns[j].getVisible() && col.Band.Columns[j].hasCells())
							{
								row.getCellByColumn(col.Band.Columns[j]).renderActiveLeft();
								break;
							}
					}
					if(typeof(cell.oldBorderRightStyle)!="undefined")
					{
						cell.renderActiveRight(false);
						for(var j=col.Index-1;j>=0;j--)
							if(col.Band.Columns[j].getVisible() && col.Band.Columns[j].hasCells())
							{
								row.getCellByColumn(col.Band.Columns[j]).renderActiveRight();
								break;
							}
					}
				}
			}
			else
			{
				cell.Element.style.display="";
				if(col.Band.Grid.getActiveRow()==row)
				{
					var j=0;
					for(j=0;j<col.Band.Columns.length;j++)
						if(col.Band.Columns[j].getVisible() && col.Band.Columns[j].hasCells())
							break;
					if(j>col.Index)
					{
						row.getCellByColumn(col.Band.Columns[j]).renderActiveLeft(false);
						cell.renderActiveLeft();
					}
					for(j=col.Band.Columns.length-1;j>=0;j--)
						if(col.Band.Columns[j].getVisible() && col.Band.Columns[j].hasCells())
							break;
					if(j<col.Index)
					{
						row.getCellByColumn(col.Band.Columns[j]).renderActiveRight(false);
						cell.renderActiveRight();
					}
				}
			}
		}
		else if(col.Band.Index>=rows.Band.Index && row.Expandable)
		{
			if(row.GroupByRow || col.Band.Index>rows.Band.Index)
				igtbl_hideColumn(row.Rows,col,hide);
		}
	}
}

function igtbl_initGroupByBox(grid)
{
	this.Element=igtbl_getElementById(grid.Id+"_groupBox");
	this.pimgUp=igtbl_getElementById(grid.Id+"_pimgUp");
	if(this.pimgUp)
		this.pimgUp.style.zIndex=10000;
	this.pimgDn=igtbl_getElementById(grid.Id+"_pimgDn");
	if(this.pimgDn)
		this.pimgDn.style.zIndex=10000;
	this.postString="";
	this.moveString="";
	if(this.Element)
	{
		this.groups=new Array();
		var gt=this.Element.childNodes[0];
		if(gt.tagName=="TABLE")
			for(var i=0;i<gt.rows.length;i++)
				this.groups[i]=new igtbl_initGroupMember(gt.rows[i].cells[i]);
	}
}

function igtbl_initGroupMember(e)
{
	var d=e.childNodes[0];
	if(!d.getAttribute("groupInfo"))
		return null;
	this.Element=d;
	this.groupInfo=d.getAttribute("groupInfo").split(":");
	this.groupInfo[1]=parseInt(this.groupInfo[1],10);
	if(this.groupInfo[0]=="col")
		this.groupInfo[2]=parseInt(this.groupInfo[2],10);
}

function igtbl_initStatHeader(gs)
{
	this.Type="statHeader";

	this.gridId=gs.Id;
	this.Element=gs._tdContainer.parentNode.previousSibling.childNodes[0].childNodes[0].childNodes[0].childNodes[1];
	this.ScrollTo=igtbl_scrollStatHeader;
	this.getElementByColumn=igtbl_shGetElemByCol;
		
	
	if(this.Element.parentNode.offsetHeight==0)
	{
		var chn=this.Element.firstChild.firstChild;
		while(chn && !chn.height)
			chn=chn.nextSibling;
		if(chn && chn.height)
			this.Element.parentNode.parentNode.style.height=chn.height;
		else
			this.Element.parentNode.parentNode.style.height="20px";
	}	
	else
		this.Element.parentNode.parentNode.style.height=this.Element.parentNode.offsetHeight;
	var outlGB=false;
	if(gs.Rows && gs.Rows.length>0 && (row=gs.Rows.getRow(0)).GroupByRow)
		outlGB=true;
	if(!gs.UseFixedHeaders)
	{
		var row;
		if(outlGB)
		{
			while(row.GroupByRow && row.Rows && row.Rows.length>0)
				row=row.Rows.getRow(0);
			if(row.GroupByRow)
			{
				for(var i=0;i<this.Element.childNodes[0].childNodes.length;i++)
				{
					var col=this.Element.childNodes[0].childNodes[i];
					if(col.getAttribute("columnNo"))
					{
						var colNo=parseInt(col.getAttribute("columnNo"));
						gs.Bands[0].Columns[colNo].Element=col;
					}
				}
				return;
			}
		}
		for(var i=0;i<this.Element.childNodes[0].childNodes.length;i++)
		{
			var col=this.Element.childNodes[0].childNodes[i];
			if(col.getAttribute("columnNo"))
			{
				var colNo=parseInt(col.getAttribute("columnNo"));
				gs.Bands[0].Columns[colNo].Element=col;
			}
		}
	}
	else
	{
		var childNodes=this.Element.childNodes[0].childNodes;
		var i=0;
		while(i<childNodes.length)
		{
			var col=childNodes[i];
			i++;
			if(col.getAttribute("columnNo"))
			{
				var colNo=parseInt(col.getAttribute("columnNo"));
				gs.Bands[0].Columns[colNo].Element=col;
			}
			else if(col.colSpan>1 && col.firstChild.tagName=="DIV" && col.firstChild.id.substr(col.firstChild.id.length-4)=="_drs")
			{
				childNodes=col.firstChild.firstChild.childNodes[1].rows[0].childNodes;
				i=0;
			}
		}
	}
	
	var comWidth=gs.Element.offsetWidth==0?gs.Element.style.width:gs.Element.offsetWidth;
	if(	typeof(comWidth)=="number" || (typeof(comWidth)=="string" && comWidth.indexOf("%")==-1) )
	{	
		if(gs.AllowUpdate==1 || gs.Bands[0].AllowUpdate==1)
			comWidth--;
		if(outlGB)
		{
			var j=gs.Bands[0].Indentation;
			var sc=gs._AddnlProps[8].split(";");
			for(var i=0;i<sc.length;i++)
			{
				var col=igtbl_getColumnById(sc[i]);
				if(!col || col.Band.Index>0 || !col.IsGroupBy)
					break;
				j+=gs.Bands[0].Indentation;
			}
			comWidth-=j;
		}
		
		if (comWidth>-1)
		this.Element.parentNode.style.width=comWidth;
	}
	else
	{
		this.Element.parentNode.style.width=comWidth;
	}
}

function igtbl_scrollStatHeader(scrollLeft)
{
	var gs=igtbl_getGridById(this.gridId);
	this.Element.parentNode.style.left=-scrollLeft;

	var comWidth=gs.Element.offsetWidth;
	if(gs.AllowUpdate==1 || gs.Bands[0].AllowUpdate==1)
		comWidth--;
	if(gs.Rows && gs.Rows.length>0 && (row=gs.Rows.getRow(0)).GroupByRow)
	{
		var j=gs.Bands[0].Indentation;
		for(var i=0;i<gs.Bands[0].SortedColumns.length;i++)
		{
			var col=igtbl_getColumnById(gs.Bands[0].SortedColumns[i]);
			if(!col.IsGroupBy)
				break;
			j+=gs.Bands[0].Indentation;
		}
		comWidth-=j;
	}
	
	if(this.Element.parentNode.style.width)
		this.Element.parentNode.style.width=comWidth;
}

function igtbl_shGetElemByCol(col)
{
	if(!col.hasCells())
		return null;
	var j=0;
	for(var i=0;i<col.Index;i++)
	{
		if(col.Band.Columns[i].hasCells())
			j++;
	}
	return this.Element.childNodes[0].childNodes[j+col.Band.firstActiveCell];
}

function igtbl_initStatFooter(gs)
{
	this.Type="statFooter";
	this.ScrollTo=igtbl_scrollStatFooter;
	this.Resize=igtbl_resizeStatFooter;
	this.getElementByColumn=igtbl_sfGetElemByCol;

	this.gridId=gs.Id;
	var tbl=gs._tdContainer.parentNode.nextSibling.firstChild.firstChild.firstChild;
	this.Element=tbl.rows[tbl.rows.length-1].parentNode;
	this.Element.parentNode.parentNode.style.height=this.Element.parentNode.offsetHeight;

	var comWidth=gs.Element.offsetWidth;
	if(gs.AllowUpdate==1 || gs.Bands[0].AllowUpdate==1)
		comWidth--;
	if(gs.Rows && gs.Rows.length>0 && (row=gs.Rows.getRow(0)).GroupByRow)
	{
		var j=gs.Bands[0].Indentation;
		var sc=gs._AddnlProps[8].split(";");
		for(var i=0;i<sc.length;i++)
		{
			var col=igtbl_getColumnById(sc[i]);
			if(!col || col.Band.Index>0 || !col.IsGroupBy)
				break;
			j+=gs.Bands[0].Indentation;
		}
		comWidth-=j;
	}
	this.Element.parentNode.style.width=comWidth;
}

function igtbl_scrollStatFooter(scrollLeft)
{
	var gs=igtbl_getGridById(this.gridId);
	this.Element.parentNode.style.left=-scrollLeft;
	
	var comWidth=gs.Element.offsetWidth;
	if(gs.AllowUpdate==1 || gs.Bands[0].AllowUpdate==1)
		comWidth--;
	if(gs.Rows && gs.Rows.length>0 && (row=gs.Rows.getRow(0)).GroupByRow)
	{
		var j=gs.Bands[0].Indentation;
		for(var i=0;i<gs.Bands[0].SortedColumns.length;i++)
		{
			var col=igtbl_getColumnById(gs.Bands[0].SortedColumns[i]);
			if(!col.IsGroupBy)
				break;
			j+=gs.Bands[0].Indentation;
		}
		comWidth-=j;
	}
	
	if(this.Element.parentNode.style.width)
		this.Element.parentNode.style.width=comWidth;
}

function igtbl_resizeStatFooter(index,width)
{
	var c1w=width;
	var gs=igtbl_getGridById(this.gridId);
	
	
	var column=gs.Bands[0].Columns[index];
	var el=igtbl_getElementById(column.fId);
	
	var spannedFooter=false;
	if(!el)
	{
		el=igtbl_getElemVis(gs.StatFooter.Element.childNodes[0].childNodes,index);
		spannedFooter=true;
	}
	if(el)
	{
		var cg=el.parentNode.parentNode.previousSibling;
		var anCell=null;
		if(gs.Rows.AddNewRow && gs.Bands[0].AddNewRowView==2)
		{
			cg=cg.previousSibling;
			anCell=gs.Rows.AddNewRow.getCellByColumn(column);
		}
		var c;
		if(cg)
			c=cg.childNodes[anCell?anCell.getElement().cellIndex:el.cellIndex];
		else
			c=el;
		if(c.style.width) c.style.width="";
		if(el.style.width) el.style.width="";
		c.width=c1w;
		el.width=c1w;
		if(gs.UseFixedHeaders && column && !column.getFixed())
		{
			var d=c.style.display;
			c.style.display="none";
			c.style.display=d;
		}
	}
	
}

function igtbl_sfGetElemByCol(col)
{
	if(!col.hasCells())
		return null;
	var j=0;
	for(var i=0;i<col.Index;i++)
	{
		if(col.Band.Columns[i].hasCells())
			j++;
	}
	return this.Element.childNodes[0].childNodes[j+col.Band.firstActiveCell];
}

function igtbl_rowGetValue(colId)
{
	
}

function igtbl_resetJustAssigned()
{
	igtbl_justAssigned=false;
}

function igtbl_fillEditTemplate(row,childNodes)
{
	for(var i=childNodes.length-1;i>=0;i--)
	{
		var el=childNodes[i];
		if(!el.getAttribute)
			continue;
		var colKey=el.getAttribute("columnKey");
		var column=row.Band.getColumnFromKey(colKey);
		if(column)
		{
			var cell=row.getCellByColumn(column);
			if(!cell)
			{
				if(!el.isDisabled)
				{
					el.setAttribute("disabledBefore",true);
					el.disabled=true;
				}
				el.value="";
				continue;
			}
			else if(el.isDisabled && el.getAttribute("disabledBefore"))
			{
				el.disabled=false;
				el.removeAttribute("disabledBefore");
			}
			var cellValue=cell.getValue();
			var cellText="";
			var nullText="";
			if(cellValue==null)
			{
				nullText=cell.Column.getNullText();
				cellText=nullText;
			}
			else
				cellText=cellValue.toString();
			var ect=cellText.replace(/\r\n/g,"\\r\\n");
			ect=ect.replace(/\"/g,"\\\"");
			var s="(\""+row.gridId+"\",\""+el.id+"\",\""+(cell.Element?cell.Element.id:"")+"\",\""+ect+"\")";
			if(!igtbl_fireEvent(row.gridId,igtbl_getGridById(row.gridId).Events.TemplateUpdateControls,s))
			{
				if(el.tagName=="SELECT")
				{
					for(var j=0;j<el.childNodes.length;j++)
						if(el.childNodes[j].tagName=="OPTION")
							if(el.childNodes[j].value==cellText)
							{
								el.childNodes[j].selected=true;
								break;
							}
				}
				else if(el.tagName=="INPUT" && el.type=="checkbox")
				{
					if(!cellValue || cellText.toLowerCase()=="false")
						el.checked=false;
					else
						el.checked=true;
				}
				else if(el.tagName=="DIV" || el.tagName=="SPAN")
				{
					for(var j=0;j<el.childNodes.length;j++)
					{
						if(el.childNodes[j].tagName=="INPUT" && el.childNodes[j].type=="radio")
							if(el.childNodes[j].value==cellText)
							{
								el.childNodes[j].checked=true;
								break;
							}
					}
				}
				else
					el.value=cellText;
				if(!el.isDisabled)
					igtbl_focusedElement=el;
			}
		}
		else if(el.childNodes && el.childNodes.length>0)
			igtbl_fillEditTemplate(row,el.childNodes);
	}
}

function igtbl_unloadEditTemplate(row,childNodes)
{
	for(var i=0;i<childNodes.length;i++)
	{
		var el=childNodes[i];
		if(!el.getAttribute)
			continue;
		var colKey=el.getAttribute("columnKey");
		var column=row.Band.getColumnFromKey(colKey);
		if(column)
		{
			var cell=row.getCellByColumn(column);
			if(cell && !igtbl_fireEvent(row.gridId,igtbl_getGridById(row.gridId).Events.TemplateUpdateCells,"(\""+row.gridId+"\",\""+el.id+"\",\""+(cell.Element?cell.Element.id:"")+"\")"))
			{
				if(cell.isEditable() || cell.Column.getAllowUpdate()==3)
				{
					if(el.tagName=="SELECT")
						cell.setValue(el.options[el.selectedIndex].value);
					else if(el.tagName=="INPUT" && el.type=="checkbox")
						cell.setValue(el.checked);
					else if(el.tagName=="DIV" || el.tagName=="SPAN")
					{
						for(var j=0;j<el.childNodes.length;j++)
						{
							if(el.childNodes[j].tagName=="INPUT" && el.childNodes[j].type=="radio")
								if(el.childNodes[j].checked)
								{
									cell.setValue(el.childNodes[j].value);
									break;
								}
						}
					}
					else if(typeof(el.value)!="undefined")
						cell.setValue(el.value);
				}
			}
		}
		else if(el.childNodes && el.childNodes.length>0)
			igtbl_unloadEditTemplate(row,el.childNodes);
	}
}

function igtbl_gRowEditMouseDown(evnt)
{
	if(igtbl_justAssigned)
	{
		igtbl_justAssigned=false;
		return;
	}
	if(!evnt)
		evnt=event;
	var src=igtbl_srcElement(evnt);
	var editTempl=igtbl_getElementById(igtbl_currentEditTempl);
	if(editTempl && src && !igtbl_contains(editTempl,src))
	{
		var rId=editTempl.getAttribute("editRow");
		var row=igtbl_getRowById(rId);
		row.Band.Grid.event=evnt;
		row.endEditRow();
	}
}

function igtbl_contains(e1,e2)
{
	if(e1.contains)
		return e1.contains(e2);
	var contains=false;
	var p=e2;
	while(p && p!=e1)
		p=p.parentNode;
	return p==e1;
}

function igtbl_gRowEditButtonClick(evnt,saveChanges)
{
	if(!evnt)
		evnt=event;
	var src=igtbl_srcElement(evnt);
	var editTempl=igtbl_getElementById(igtbl_currentEditTempl);
	if(editTempl)
	{
		if(typeof(saveChanges)=="undefined")
			saveChanges=(src.id.substring(src.id.length-13)=="igtbl_reOkBtn") || src.value.toUpperCase()=="OK";
		var rId=editTempl.getAttribute("editRow");
		var row=igtbl_getRowById(rId);
		row.Band.Grid.event=evnt;
		row.endEditRow(saveChanges);
	}
}

function igtbl_changeBorder(g,elemFrom,elemTo,obj,attr,render)
{
	var attrStyle;
	if(attr)
		attrStyle="border"+attr+"Style";
	else
		attrStyle="borderStyle";
	var attrColor;
	if(attr)
		attrColor="border"+attr+"Color";
	else
		attrColor="borderColor";
	var attrWidth;
	if(attr)
		attrWidth="border"+attr+"Width";
	else
		attrWidth="borderWidth";
	if(render==false)
	{
		if(typeof(obj["old"+attrStyle])!="undefined"
		 && obj["old"+attrStyle]!=null
		)
		{
			elemTo[attrStyle]=obj["old"+attrStyle];
			obj["old"+attrStyle]=null;
		}
		if(typeof(obj["old"+attrColor])!="undefined"
		 && obj["old"+attrColor]!=null
		)
		{
			elemTo[attrColor]=obj["old"+attrColor];
			obj["old"+attrColor]=null;
		}
		if(typeof(obj["old"+attrWidth])!="undefined"
		 && obj["old"+attrWidth]!=null
		)
		{
			elemTo[attrWidth]=obj["old"+attrWidth];
			obj["old"+attrWidth]=null;
		}
	}
	else
	{
		if(typeof(obj["old"+attrStyle])=="undefined"
		 || obj["old"+attrStyle]==null
		)
			obj["old"+attrStyle]=elemFrom[attrStyle];
		elemTo[attrStyle]=g.Activation.getValue(attr,"Style");
		if(typeof(obj["old"+attrColor])=="undefined"
		 || obj["old"+attrColor]==null
		)
			obj["old"+attrColor]=elemFrom[attrColor];
		elemTo[attrColor]=g.Activation.getValue(attr,"Color");
		if(typeof(obj["old"+attrWidth])=="undefined"
		 || obj["old"+attrWidth]==null
		)
			obj["old"+attrWidth]=elemFrom[attrWidth];
		elemTo[attrWidth]=g.Activation.getValue(attr,"Width");
	}
}

function igtbl_valueFromString(value,dataType)
{
	if(typeof(value)=="undefined" || value==null)
		return value;
	switch(dataType)
	{
		case 2: 
		case 3:
		case 16:
		case 17:
		case 18:
		case 19:
		case 20:
		case 21:
			if(typeof(value)=="number")
				return value;
			if(typeof(value)=="boolean")
				return (value?1:0);
			if(value.toString().toLowerCase()=="true")
				return 1;
			value=parseInt(value.toString(),10);
			if(value.toString()=="NaN")
				value=0;
			break;
		case 4: 
		case 5:
		case 14:
			if(typeof(value)=="float")
				return value;
			value=parseFloat(value.toString());
			if(value.toString()=="NaN")
				value=0.0;
			break;
		case 11: 
			if(!value || value.toString()=="0" || value.toString().toLowerCase()=="false")
				value=false;
			else
				value=true;
			break;
		case 7: 
			var d=new Date(value);
			if(d.toString()!="NaN" && d.toString()!="Invalid Date")
				value=d;
			else
				value=igtbl_trim(value.toString());
			delete d;
			break;
		case 8:
			break;
		default:
			value=igtbl_trim(value.toString());
	}
	return value;
}

function igtbl_clearRowChanges(gs,row)
{
	if(!row)return;
	if(gs.SelectedRows[row.Element.id])
		gs._removeChange("SelectedRows",row);
	if(gs.SelectedCellsRows[row.Element.id])
	{
		for(var cell in gs.SelectedCellsRows[row.Element.id])
		{
			gs._removeChange("SelectedCells",igtbl_getCellById(cell));
			delete gs.SelectedCellsRows[row.Element.id][cell];
		}
		delete gs.SelectedCellsRows[row.Element.id];
	}
	if(gs.ChangedRows[row.Element.id])
	{
		for(var cell in gs.ChangedRows[row.Element.id])
		{
			gs._removeChange("ChangedCells",igtbl_getCellById(cell));
			delete gs.ChangedRows[row.Element.id][cell];
		}
		delete gs.ChangedRows[row.Element.id];
	}
	if(gs.ResizedRows[row.Element.id])
		gs._removeChange("ResizedRows",row);
	if(gs.ExpandedRows[row.Element.id])
		gs._removeChange("ExpandedRows",row);
	if(gs.CollapsedRows[row.Element.id])
		gs._removeChange("CollapsedRows",row);
	if(typeof(gs.AddedRows[row.Element.id])!="undefined")
		row._Changes["AddedRows"].setFireEvent(false);
}

function igtbl_getStyleSheet(name)
{
	var nameAr=name.split(".");
	if(nameAr.length>2)
		return null;
	else if(nameAr.length==2)
	{
		if(ig_csom.IsIE)
			nameAr[0]=nameAr[0].toUpperCase();
		else
			nameAr[0]=nameAr[0].toLowerCase();
		name=nameAr.join(".");
	}
	else
		name="."+name;
	for(var i=0;i<document.styleSheets.length;i++)
	{
		if(ig_csom.IsIE)
		{
			for(var j=0;j<document.styleSheets[i].rules.length;j++)
				if(document.styleSheets[i].rules[j].selectorText==name)
					return document.styleSheets[i].rules[j].style;
		}
		else
		{
			for(var j=0;j<document.styleSheets[i].cssRules.length;j++)
				if(document.styleSheets[i].cssRules[j].selectorText==name)
					return document.styleSheets[i].cssRules[j].style;
		}
	}
	return null;
}

function igtbl_getCurrentStyleProperty(e,propName,forceCalc)
{
	if(e && e.tagName && ig_csom.IsIE && !forceCalc)
		return e.currentStyle[propName];
	else
	{
		if(e && e.tagName && e.style[propName])
			return e.style[propName];
		var className=e;
		if(e && e.tagName)
			className=e.className;
		if(className)
		{
			var clsNames=className.split(" ");
			clsNames=clsNames.reverse();
			for(var i=0;i<clsNames.length;i++)
			{
				var style=igtbl_getStyleSheet(clsNames[i]);
				if(style && style[propName])
					return style[propName];
			}
		}
	}
	return "";
}

function igtbl_swapCells(rows,bandNo,index,toIndex)
{
	if(!rows || rows.Band.Index>bandNo)
		return;
	for(var i=0;i<rows.rows.length;i++)
	{
		var row=rows.rows[i];
		if(row)
		{
			if(!row.GroupByRow && row.Band.Index==bandNo && row.cells)
			{
				var cell=row.cells[index];
				row.cells[index]=row.cells[toIndex];
				row.cells[toIndex]=cell;
			}
			igtbl_swapCells(row.Rows,bandNo,index,toIndex);
		}
	}
}

function igtbl_getCellsByColumn(columnId)
{
	var c=igtbl_getDocumentElement(columnId);
	if(!c) return;
	if(!c.length) c=[c];
	var cells=[];
	var colSplit=columnId.split("_");
	var colIndex=parseInt(colSplit[colSplit.length-1],10);
	for(var k=0;k<c.length;k++)
	{
		var tbody=c[k].parentNode;
		while(tbody && tbody.tagName!="THEAD" && tbody.tagName!="TABLE")
			tbody=tbody.parentNode;
		if(!tbody || tbody.tagName=="TABLE")
			continue;
		tbody=tbody.nextSibling;
		if(!tbody)
			continue;
		for(var i=0;i<tbody.rows.length;i++)
		{
			if(tbody.rows[i].getAttribute("hiddenRow"))
				continue;
			var cell=tbody.rows[i].cells[c[k].cellIndex];
			while(cell)
			{
				var cellSplit=cell.id.split("_");
				var cellIndex=parseInt(cellSplit[cellSplit.length-1],10);
				if(cellIndex==colIndex)
					break;
				cell=cell.nextSibling;
			}
			if(cell)
				cells[cells.length]=cell;
		}
	}
	return cells;
}

function igtbl_getArray(elem)
{
	if(!elem) return null;
	var a=new Array();
	if(!elem.length)
		a[0]=elem;
	else
		for(var i=0;i<elem.length;i++)
			a[i]=elem[i];
	return a;
}

function igtbl_AdjustCheckboxDisabledState(column,bandIndex,rows,value)
{
	if(!rows)return;
	if (rows.Band.Index==bandIndex)
		for (var i=0;i<rows.length;i++)
		{
			var oC=rows.getRow(i).getCellByColumn(column);
			oC=igtbl_getCheckboxFromElement(oC.Element);
			if(oC)oC.disabled=!(1==value);
		}
	else if (rows.Band.Index < bandIndex) 
		for (var i=0;i<rows.length;i++) igtbl_AdjustCheckboxDisabledState(column, bandIndex,rows.getRow(i).Rows,value);
}

function igtbl_getCheckboxFromElement(oCellE)
{
	var oChk=null;
	for(var i=0;i<oCellE.childNodes.length;i++)
	{
		if (oCellE.childNodes[i].tagName=="INPUT"&&oCellE.childNodes[i].type=="checkbox")
			oChk=oCellE.childNodes[i];
		else
			oChk=igtbl_getCheckboxFromElement(oCellE.childNodes[i])		
		if(oChk)break;
	}
	return oChk;
}

function igtbl_escape(text)
{
	text=escape(text);
	return text.replace(/\+/g,"%2b");
}

function igtbl_RecalculateRowNumbers(rc,startingIndex,band,xmlNode)
{
	if(rc==null&&band==null) return startingIndex;
	
	var oRow;
	var iRowLbl=-1;
	var oFAC;		
	var returnedIndex = -1;
	var workingIndex;
	var oBand = band ? band : rc.Band;

	switch(oBand.AllowRowNumbering)
	{
		case(2):
			workingIndex=startingIndex;
			break;
		case(3):
			workingIndex=1;
			break;		
		case(4):
			workingIndex=oBand._currentRowNumber+1;
			break;		
	}	

	if(null!=rc) 
	{
		for(var i=0;i<rc.length;i++)
		{
			iRowLbl = -1;
			oRow = rc.getRow(i);
						
			if (oRow.Band.AllowRowNumbering>=2)
				iRowLbl=oRow._setRowNumber(workingIndex);
				
			if (iRowLbl>-1)
			{
				var childRows = oRow.Rows;
				var childBand = childRows ? childRows.Band : oRow.Band.Grid.Bands[oRow.Band.Index+1];
				var childXmlNode = childRows ? childRows.Node : (oRow.Node ? oRow.Node.selectSingleNode("Rs") : null);
				returnedIndex=igtbl_RecalculateRowNumbers(childRows,workingIndex+1,childBand,childXmlNode);
			}	
		
			switch(rc.Band.AllowRowNumbering)
			{
				case(2):
					workingIndex=returnedIndex;
					break;
				case(3):
					workingIndex=++workingIndex;
					break;		
				case(4):
					oRow.Band._currentRowNumber=workingIndex;
					workingIndex=++workingIndex;
					break;		
			}									
		}
	}
	else if (band!=null&&xmlNode!=null)
	{
		var oXmlRows = xmlNode.selectNodes("R");
		for(var i=0;i<oXmlRows.length;i++)
		{
			iRowLbl = -1;
			oRow = oXmlRows[i];
						
			if (band.AllowRowNumbering>=2)			
				oRow.setAttribute("lit:rowNumber",workingIndex);
				
			var childRows = null;
			var childBand = band.Grid.Bands[band.Index+1];
			var childXmlNode = oRow.selectSingleNode("Rs");
			
			returnedIndex=igtbl_RecalculateRowNumbers(childRows,workingIndex+1,childBand,childXmlNode);
			
			switch(band.AllowRowNumbering)
			{
				case(2):
					workingIndex=returnedIndex;
					break;
				case(3):
					workingIndex=++workingIndex;
					break;		
				case(4):
					band._currentRowNumber=workingIndex;
					workingIndex=++workingIndex;
					break;		
			}											
		}		
	}
	return workingIndex;
}
function igtbl_isColEqual(col1,col2)
{
	if(col1==null && col2==null)
		return true;
	if(col1==null || col2==null)
		return false;
	if(col1.Band.Index==col2.Band.Index && col1.Key==col1.Key && col1.Index==col2.Index)
		return true;
	return false;
}

function igtbl_cleanRow(row)
{
	if(row.cells)
		for(var j=0;j<row.cells.length;j++)
		{
			var cell=row.cells[j];
			if(cell)
			{
				cell.Column=null;
				cell.Band=null;
				cell.Row=null;
				for(var change in cell._Changes)
				{
					var ch=cell._Changes[change];
					try{
					if(ch.length)
						ch=ch[0];
					if(ch.Grid)
						ch.Grid._removeChange(change,cell);
					}catch(e){;}
				}
				if(cell.Element)
					cell.Element.Object=null;
			}
		}
	if(row._Changes)
		for(var change in row._Changes)
		{
			var ch=row._Changes[change];
			try{
			if(ch.length)
				ch=ch[0];
			if(ch.Grid)
				ch.Grid._removeChange(change,row);
			}catch(e){;}
		}
	row.OwnerCollection=null;
	row.Band=null;
	row.ParentRow=null;
	row.Element.Object=null;
}

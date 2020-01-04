 /*
  * Infragistics WebNavBar CSOM Script: ig_WebNavBar.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */


var igwnb_state=[];

function igwnb_initialize(nBarId,tBarId)
{
	igtbar_initialize.apply(this,[tBarId]);
	eval("o"+tBarId+"=this;");
	var props=eval("igwnb_"+nBarId+"_Props");
	this.nbId=nBarId;
	this.GridId=props[1];
	this.bScroll=props[2];
	this.insLoc=props[3];

	var events=eval("igwnb_"+nBarId+"_Events");
	this.ClientSideEvents["AfterDeleteRow"]=events[0];
	this.ClientSideEvents["AfterInsertRow"]=events[1];
	this.ClientSideEvents["AfterMoveBackward"]=events[2];
	this.ClientSideEvents["AfterMoveForward"]=events[3];
	this.ClientSideEvents["AfterMoveNext"]=events[4];
	this.ClientSideEvents["AfterMovePrev"]=events[5];
	this.ClientSideEvents["AfterMoveToEnd"]=events[6];
	this.ClientSideEvents["AfterMoveToStart"]=events[7];
	this.ClientSideEvents["BeforeDeleteRow"]=events[8];
	this.ClientSideEvents["BeforeInsertRow"]=events[9];
	this.ClientSideEvents["BeforeMoveBackward"]=events[10];
	this.ClientSideEvents["BeforeMoveForward"]=events[11];
	this.ClientSideEvents["BeforeMoveNext"]=events[12];
	this.ClientSideEvents["BeforeMovePrev"]=events[13];
	this.ClientSideEvents["BeforeMoveToEnd"]=events[14];
	this.ClientSideEvents["BeforeMoveToStart"]=events[15];
	this.ClientSideEvents["nbClick"]=events[16];
	this.ClientSideEvents["Initialize"]=events[17];
	this.ClientSideEvents["nbMouseOver"]=events[18];
	this.ClientSideEvents["nbMouseOut"]=events[19];
	
	var items=eval("igtbar_"+tBarId+"_Items");
	if(items)
	{
		for(var i=0;i<items.length;i++)
			for(var j=0;j<items[i].length;j++)
				if(j<items[i].length-1 && typeof(items[i][j])=="string" && items[i][j].charAt(0)=='&')
				{
					this.Items[i][items[i][j].substr(1)]=items[i][j+1];
					j++
				}
	}
	
	eval("g"+tBarId+"IsLoaded=true;");
	
	igwnb_state[nBarId]=this;

	if(this.GridId!=null&&this.GridId.length>0)
	{
		var grid=null;
		try
		{
			if(this.bScroll)
			{
				grid=igtbl_getGridById(this.GridId);
			
				if(typeof(grid)!="undefined" && grid.GridIsLoaded)
				{
					var row=grid.getActiveRow();
					if(!row)
					{
						var cell=grid.getActiveCell();
						if(cell)
							row=cell.Row;
					}
					if(row)
						row.scrollToView();
				}
				else
				{
					if(typeof(document.body.igwnb_wnb)!="undefined")
						this.oldDocumentWnb=document.body.igwnb_wnb;
					document.body.igwnb_wnb=this;
					if(document.body.addEventListener)
						document.body.addEventListener('load',igwnb_onload,false);
					else if(document.body.onload!=igwnb_onload)
					{
						igwnb_oldOnload=document.body.onload;
						document.body.onload=igwnb_onload;
					}
				}
			}
		}
		catch(ex){;}
	}	
	
	var eventObj=new ig_EventObject();
	ig_fireEvent(this,this.ClientSideEvents.Initialize,eventObj);
	ig_dispose(eventObj);
	delete eventObj;
}

var igwnb_oldOnload=null;
function igwnb_onload()
{
	if(typeof(document.body.igwnb_wnb)!="undefined" && document.body.igwnb_wnb!=null)
	{
		var wnb=document.body.igwnb_wnb;
		while(wnb!=null)
		{
			var grid=igtbl_getGridById(wnb.GridId);
		
			if(typeof(grid)!="undefined" && grid.GridIsLoaded)
			{
				var row=grid.getActiveRow();
				if(!row)
				{
					var cell=grid.getActiveCell();
					if(cell)
						row=cell.Row;
				}
				if(row)
					row.scrollToView();
			}
			if(typeof(wnb.oldDocumentWnb)!="undefined")
				wnb=wnb.oldDocumentWnb;
			else
				wnb=null;
		}
		document.body.igwnb_wnb=null;
	}
	if(igwnb_oldOnload)
		igwnb_oldOnload();
}

function igwnb_toolbarClick(oThis,oItem,eventObj)
{
	ig_fireEvent(oThis,oThis.ClientSideEvents.nbClick,oItem,eventObj);
	if(eventObj.cancel)
		return ig_cancelEvent(eventObj);
	var grid=null;
	try{grid=igtbl_getGridById(oThis.GridId);}catch(ex){;}
	switch(oItem.Key)
	{
	default:
		switch(oItem.navunit)
		{
			case "first":
				ig_fireEvent(oThis,oThis.ClientSideEvents.BeforeMoveToStart,oItem,eventObj);
				if(eventObj.cancel)
					return ig_cancelEvent(eventObj);
				if(!grid || oItem.AutoPostBack && !eventObj.cancelPostBack){
					ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToStart,oItem,eventObj);
					break;
				}
				eventObj.cancelPostBack=true;
				if(oItem.depthfirst=="1")
				{
					if(!grid.AllowPaging||grid.PageCount==1||grid.CurrentPageIndex==1)
					{
						var row=grid.Rows.getRow(0);
						if(row && row!=grid.getActiveRow())
						{
							row.activate();
							row.setSelected();
							row.scrollToView();
							ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToStart,oItem,eventObj);
						}
					}
					else
					{
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToStart,oItem,eventObj);
						eventObj.cancelPostBack=false;
						eventObj.needPostBack=true;
						break;
					}
				}
				else
				{
					if(!grid.AllowPaging||grid.PageCount==1)
					{
						row=grid.getActiveRow();
						if(!row&&((row=grid.getActiveCell())!=null))
						{
							row=row.Row;
						}
						if(!row||!row.ParentRow)
						{
							row=grid.Rows.getRow(0);
							if(row && row!=grid.getActiveRow())
							{
								row.activate();
								row.setSelected();
								row.scrollToView();
								ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToStart,oItem,eventObj);
							}
						}
						else
						{
							row=row.ParentRow.Rows.getRow(0);
							if(row && row!=grid.getActiveRow())
							{
								row.activate();
								row.setSelected();
								row.scrollToView();
								ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToStart,oItem,eventObj);
							}
						}
					}
					else
					{
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToStart,oItem,eventObj);
						eventObj.cancelPostBack=false;
						eventObj.needPostBack=true;
						break;
					}
				}
				break;
			case "last":
				ig_fireEvent(oThis,oThis.ClientSideEvents.BeforeMoveToEnd,oItem,eventObj);
				if(eventObj.cancel)
					return ig_cancelEvent(eventObj);
				if(!grid || oItem.AutoPostBack && !eventObj.cancelPostBack){
					ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToEnd,oItem,eventObj);
					break;
				}
				eventObj.cancelPostBack=true;
				if(oItem.depthfirst=="1")
				{
					if(!grid.AllowPaging||grid.CurrentPageIndex==grid.PageCount||grid.PageCount==1)
					{
						var row=grid.Rows.getRow(grid.Rows.length-1);
						if(row && row!=grid.getActiveRow())
						{
							row.activate();
							row.setSelected();
							row.scrollToView();
							ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToEnd,oItem,eventObj);
						}
					}
					else
					{
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToEnd,oItem,eventObj);
						eventObj.cancelPostBack=false;
						eventObj.needPostBack=true;
						break;
					}
				}
				else
				{
					if(!grid.AllowPaging||grid.PageCount==1)
					{
						row=grid.getActiveRow();
						if(!row&&((row=grid.getActiveCell())!=null))
						{
							row=row.Row;
						}
						if(!row||!row.ParentRow)
						{
							row=grid.Rows.getRow(grid.Rows.length-1);
							if(row && row!=grid.getActiveRow())
							{
								row.activate();
								row.setSelected();
								row.scrollToView();
								ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToEnd,oItem,eventObj);
							}
						}
						else
						{
							row=row.ParentRow.Rows.getRow(row.ParentRow.Rows.length-1);
							if(row && row!=grid.getActiveRow())
							{
								row.activate();
								row.setSelected();
								row.scrollToView();
								ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToEnd,oItem,eventObj);
							}
						}
					}
					else
					{
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveToEnd,oItem,eventObj);
						eventObj.cancelPostBack=false;
						eventObj.needPostBack=true;
						break;
					}			
				}
				break;
			case "page":
				var navStep=parseInt(oItem.navstep,10);
				if(navStep<0)
					ig_fireEvent(oThis,oThis.ClientSideEvents.BeforeMoveBackward,oItem,eventObj);
				else
					ig_fireEvent(oThis,oThis.ClientSideEvents.BeforeMoveForward,oItem,eventObj);
				if(eventObj.cancel)
					return ig_cancelEvent(eventObj);
				if(!grid || oItem.AutoPostBack && !eventObj.cancelPostBack){
					if(navStep<0)
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveBackward,oItem,eventObj);
					else
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveForward,oItem,eventObj);
					break;
				}
				if(grid.AllowPaging&&grid.PageCount>1)
				{
					var fro=(grid.CurrentPageIndex==1&&navStep<0);
					var bak=(grid.CurrentPageIndex==grid.PageCount&&navStep>0);
					if (!fro&&!bak||oItem.AutoPostBack&&!eventObj.cancelPostBack){
						eventObj.cancelPostBack=false;
						eventObj.needPostBack=true;
					}
					else if (fro){
						var row=grid.Rows.getRow(0);
						if(row && row!=grid.getActiveRow())
						{
							row.activate();
							row.setSelected();
							row.scrollToView();
						}
					}
					else{
						var row=grid.Rows.getRow(grid.Rows.length-1);
						if(row && row!=grid.getActiveRow())
						{
							row.activate();
							row.setSelected();
							row.scrollToView();
						}
					}
				}
				break;
			case "row":
				var navStep=parseInt(oItem.navstep,10);
				if(navStep<0)
					ig_fireEvent(oThis,oThis.ClientSideEvents.BeforeMovePrev,oItem,eventObj);
				else
					ig_fireEvent(oThis,oThis.ClientSideEvents.BeforeMoveNext,oItem,eventObj);
				if(eventObj.cancel)
					return ig_cancelEvent(eventObj);
				if(!grid || oItem.AutoPostBack && !eventObj.cancelPostBack){
					if(navStep<0)
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMovePrev,oItem,eventObj);
					else
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveNext,oItem,eventObj);
					break;
				}
				eventObj.cancelPostBack=true;
				var row=grid.getActiveRow();
				if(!row && (row=grid.getActiveCell())!=null)
					row=row.Row;
				if(row)
				{
					if(oItem.depthfirst=="0")
					{
						if((navStep==-1)&&(row.getIndex()!=0))
							row=row.getPrevRow();
						else if((navStep==1)&&(row.getIndex()!=row.OwnerCollection.length-1))
							row=row.getNextRow();
						else
						{
							var index=row.getIndex();
							index+=navStep;
							if(index<0){
								if(grid.AllowPaging&&grid.PageCount>1&&grid.CurrentPageIndex>1){
									eventObj.cancelPostBack=false;
									eventObj.needPostBack=true;
								}else
									index=0;
							}
							else if(index>=row.OwnerCollection.length){
								if(grid.AllowPaging&&grid.CurrentPageIndex<grid.PageCount){
									eventObj.cancelPostBack=false;
									eventObj.needPostBack=true;
								}else
									index=row.OwnerCollection.length-1;
							}
							else
								row=row.OwnerCollection.getRow(index);
						}
					}
					else
					{
						if(navStep==-1)
						{
							row=row.getNextTabRow(true,true);
							if(null==row)
							{
								if(grid.AllowPaging&&grid.PageCount>1&&grid.CurrentPageIndex>1){
									eventObj.cancelPostBack=false;
									eventObj.needPostBack=true;
									break;
								}
							}
						}
						else if(navStep==1)
						{
							row=row.getNextTabRow(false,true);
							if(null==row)
							{
								if(grid.AllowPaging&&grid.PageCount>1&&grid.CurrentPageIndex<grid.PageCount){
									eventObj.cancelPostBack=false;
									eventObj.needPostBack=true;
									break;
								}
							}
						}
						else
						{
							var i=0;
							var addon=(navStep<0?-1:1);
							while(row!=null && i!=navStep)
							{
								row=row.getNextTabRow(addon==-1,true);
								i+=addon;
							}
						}
						var parentRow=(row)?row.ParentRow:null;
						while(parentRow)
						{
							if(parentRow.Expandable)
								parentRow.setExpanded(true);
							parentRow=parentRow.ParentRow;
						}
					}
				}
				else row=grid.Rows.getRow(0);
				if(row && row!=grid.getActiveRow())
				{
					row.activate();
					row.setSelected();
					row.scrollToView();
					if(navStep<0)
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMovePrev,oItem,eventObj);
					else
						ig_fireEvent(oThis,oThis.ClientSideEvents.AfterMoveNext,oItem,eventObj);
				}
				break;
		}
		break;
	case "add":
		ig_fireEvent(oThis,oThis.ClientSideEvents.BeforeInsertRow,oItem,eventObj);
		if(eventObj.cancel)
			return ig_cancelEvent(eventObj);
		if(!grid || oItem.AutoPostBack && !eventObj.cancelPostBack)
			break;
		eventObj.cancelPostBack=true;
		var bOfs=0;
		var row=grid.getActiveRow();
		if(!row && (row=grid.getActiveCell())!=null)
			row=row.Row;
		if(!row){
			if(grid.Rows.length>0){
				switch(oThis.insLoc){
					case "before":
						row=grid.Rows.getRow(0);
						break;
					case "after":
						row=grid.Rows.getRow(grid.Rows.length - 1);
						break;
					case "child":
						break;
				}
			}
		}else{
			var rtmp;
			switch(oThis.insLoc){
				case "before":
					rtmp=row.getPrevRow();
					row=(rtmp!=null)?rtmp:row;
					break;
				case "after":
					rtmp=row.getNextRow();
					row=(rtmp!=null)?rtmp:row;
					break;
				case "child":
					rtmp=row.getNextTabRow();
					row=(rtmp!=null)?rtmp:row;
					if(!rtmp&&row)
						bOfs=1;
					break;
			}
		}
		var bn=(row)?row.Band.Index+bOfs:0+bOfs;
		if(!(grid.Bands[bn].AllowAddNew==2||grid.Bands[bn].AllowAddNew==0&&grid.AllowAddNew!=1||grid.Bands[bn].IsGrouped)){
			igtbl_addNew(grid.Id,bn);
			ig_fireEvent(oThis,oThis.ClientSideEvents.AfterInsertRow,oItem,eventObj);
		}else{
			eventObj.cancel=true;
			return ig_cancelEvent(eventObj);
		}
		
		break;
	case "del":
		ig_fireEvent(oThis,oThis.ClientSideEvents.BeforeDeleteRow,oItem,eventObj);
		if(eventObj.cancel)
			return ig_cancelEvent(eventObj);
		if(!grid || oItem.AutoPostBack && !eventObj.cancelPostBack)
			break;
		eventObj.cancelPostBack=true;
		var cell;
		var row=grid.getActiveRow();
		if((!row)&&(cell=grid.getActiveCell())!=null){row=cell.Row;}
		var bn=(row)?row.Band.Index:0;
		if(!(grid.Bands[bn].AllowDelete==2||grid.Bands[bn].AllowDelete==0&&grid.AllowDelete!=1||grid.Bands[bn].IsGrouped)){
			if(null!=cell)
				cell.Row.activate();
			grid.deleteSelectedRows();
			ig_fireEvent(oThis,oThis.ClientSideEvents.AfterDeleteRow,oItem,eventObj);
		}else{
			eventObj.cancel=true;
			return ig_cancelEvent(eventObj);
		}
		break;
	case "submit":
		//__doPostBack(this.nbId,"");
		break;
	}
}

function igwnb_toolbarMouseOver(oThis,oItem,eventObj)
{
	ig_fireEvent(oThis,oThis.ClientSideEvents.nbMouseOver,oItem,eventObj);
}

function igwnb_toolbarMouseOut(oThis,oItem,eventObj)
{
	ig_fireEvent(oThis,oThis.ClientSideEvents.nbMouseOut,oItem,eventObj);
}

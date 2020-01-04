 /*
  * Infragistics WebCombo CSOM Script: ig_webcombo3_1.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */


var igcmbo_displaying;
var igcmbo_currentDropped;
if(typeof igcmbo_gridState!="object")
var igcmbo_comboState=[];

// private - hides all dropdown select controls for the document.
var igcmbo_hidden=false;
function igcmbo_hideDropDowns(bHide) { 
	 if(igcmbo_dropDowns == null)
		return;
     if(bHide)
     {
		if(igcmbo_hidden)
			return;
		igcmbo_hidden = true;
         for (i=0; i<igcmbo_dropDowns.length;i++)
              igcmbo_dropDowns[i].style.visibility='hidden';
     }
     else
     {
         for (i=0; i<igcmbo_dropDowns.length;i++)
         {
              igcmbo_dropDowns[i].style.visibility='visible';
         }
         igcmbo_hidden = false;
     }
}

var wccounter=0;
function igcmbo_onmousedown(evnt,id) {
	var oCombo = igcmbo_getComboById(id);
	if(!oCombo || !oCombo.Loaded) 
		return;
	var src = igcmbo_srcElement(evnt);
	oCombo.highlightText();
	if(oCombo.Editable && src.id == id + "_input") return;
	ig_inCombo = true;	
	oCombo.Element.setAttribute("noOnBlur",true);
	if(igcmbo_currentDropped != null && igcmbo_currentDropped != oCombo)
		igcmbo_currentDropped.setDropDown(false);
	if(oCombo.getDropDown() == true) {
		oCombo.setDropDown(false);
		igcmboObject = oCombo;
		if(document.all)
			setTimeout('igcmbo_focusEdit()', 10);
	}
	else {
		igcmbo_swapImage(oCombo, 2);
		oCombo.setDropDown(true);
	}
	window.setTimeout("igtbl_cancelNoOnBlurDD()",100);
}

var igcmboObject = null;
function igcmbo_focusEdit() 
{
	igcmboObject.setFocusTop();
}

function igcmbo_onmouseup(evnt,id) {
	var oCombo = igcmbo_getComboById(id);
	if(!oCombo || !oCombo.Loaded) 
		return;
	if(oCombo.Dropped == true) {
		igcmbo_swapImage(oCombo, 1);
	}
	else {
	}
}

function igcmbo_onmouseout(evnt,id) {
	var oCombo = igcmbo_getComboById(id);
	if(!oCombo || !oCombo.Loaded) 
		return;
	if(oCombo.Dropped == true) {
		igcmbo_swapImage(oCombo, 1);
	}
	else {
	}
}

function igcmbo_swapImage(combo, imageNo) {
	var img = igcmbo_getElementById(combo.ClientUniqueId + "_img");
	if(imageNo == 1) img.src = combo.DropImage1;
	else img.src = combo.DropImage2;
}

function igcmbo_ondblclick(evnt,id) {
	var oCombo = igcmbo_getComboById(id);
	if(!oCombo || !oCombo.Loaded) 
		return;
	if(oCombo.getDropDown() == true) {
		oCombo.setDropDown(false);
	}
}


function igcmbo_onKeyDown(evnt) {
	if(evnt.keyCode == 40) { // down arrow
	}
}

// public - Retrieves the server-side unique id of the combo
function igcmbo_getUniqueId(comboName) {
	var combo = igcmbo_comboState[comboName];
	if(combo != null)
		return combo.UniqueId;
	return null;
}
function igcmbo_getElementById(id) {
        if(document.all)
			return document.all[id];
        else 
			return document.getElementById(id);
}

// public - returns the combo object for the Item Id
function igcmbo_getComboById(itemId) {
	var id = igcmbo_comboIdById(itemId);  
	return igcmbo_comboState[id];
}

// public - returns the combo object from an Item element
function igcmbo_getComboByItem(item) {
	var id = igcmbo_comboIdById(item.id);  
	return igcmbo_comboState[id];
}

// public - returns the combo Name from an itemId
function igcmbo_comboIdById(itemId) {
   var comboName = itemId;
   var strArray = comboName.split("_");
   return strArray[0];
}

function igcmbo_getLeftPos(e) {
	x = e.offsetLeft;
	if(e.style.position=="absolute")
		return x;
	tmpE = e.offsetParent;
	while (tmpE!=null && tmpE.tagName!="BODY")
	{
		if(tmpE.style.overflowX && tmpE.style.overflowX!="visible" || tmpE.style.overflow && tmpE.style.overflow!="visible")
			break;
		if((tmpE.style.position!="relative") && (tmpE.style.position!="absolute"))
			x += tmpE.offsetLeft;
		tmpE = tmpE.offsetParent;
	}
	return x;
}

function igcmbo_getTopPos(e) {
	y = e.offsetTop;
	if(e.style.position=="absolute")
		return y;
	tmpE = e.offsetParent;
	while(tmpE!=null && tmpE.tagName!="BODY")
	{
		if(tmpE.style.overflowY && tmpE.style.overflowY!="visible" || tmpE.style.overflow && tmpE.style.overflow!="visible")
			break;
		if((tmpE.style.position!="relative") && (tmpE.style.position!="absolute"))
			y += tmpE.offsetTop;
		tmpE = tmpE.offsetParent;
	}
	return y;
}

// Warning: Private functions for internal component usage only
// The functions in this section are not intended for general use and are not supported
// or documented.

// private - Fires an event to client-side script and then to the server is necessary
function igcmbo_fireEvent(id,eventObj,eventString){
	var oCombo=igcmbo_comboState[id];
	var result=false;
	if(eventObj[0]!="")
		result=eval(eventObj[0]+eventString);
	if(oCombo.Loaded && result!=true && eventObj[1]==1 && !oCombo.CancelPostBack)
		oCombo.NeedPostBack = true;
	oCombo.CancelPostBack=false;
	return result;
}

// private - Performed on page initialization
function igcmbo_initialize() 
{
	if(typeof(window.igcmbo_initialized)=="undefined")
	{
		if(typeof(ig_csom)=="undefined" || ig_csom==null)
			return;
		ig_csom.addEventListener(document, "mousedown", igcmbo_mouseDown, false);
		ig_csom.addEventListener(document, "mouseup", igcmbo_mouseUp, false);

		window.igcmbo_initialized=true;
		ig_currentCombo = null;
	}
}

var igcmbo_comboState=[];
var igcmbo_dropDowns;

// private - initializes the combo object on the client
function igcmbo_initCombo(comboId) {

   var comboElement = igcmbo_getElementById(comboId+"_Main");
   var oCombo = new igcmbo_combo(comboElement,eval("igcmbo_"+comboId+"_Props"));
   igcmbo_comboState[comboId] = oCombo;
   igcmbo_fireEvent(comboId,oCombo.Events.InitializeCombo,"(\""+comboId+"\");");
   if(document.all != null && oCombo.HideDropDowns==true && igcmbo_dropDowns==null) {
		igcmbo_dropDowns = document.all.tags("SELECT");
   }
   oCombo.Loaded = true;
   return oCombo;
}

// private - constructor for the combo object
function igcmbo_combo(comboElement,comboProps) 
{
	igcmbo_initialize();

	this.Id=comboElement.id;
	this.Element=comboElement;
	this.Type="WebCombo";
	this.UniqueId=comboProps[0];
	this.ClientUniqueId=comboProps[1];
	this.DropDownId=this.ClientUniqueId+"_main";
	this.DropImage1=comboProps[2];
	this.DropImage2=comboProps[3];
	this.ForeColor=comboProps[9];
	this.BackColor=comboProps[10];
	this.SelForeColor=comboProps[11];
	this.SelBackColor=comboProps[12];
	
	this.DataTextField= comboProps[13]&&comboProps[13].length>0?unescape(comboProps[13].replace(/&nbsp;/gi," ")):unescape(comboProps[13]);
	this.DataValueField=comboProps[15]&&comboProps[15].length>0?unescape(comboProps[15].replace(/&nbsp;/gi," ")):unescape(comboProps[15]);
	this.HideDropDowns=comboProps[17];
	this.Editable=comboProps[18];
	this.ClassName=comboProps[19];
	this.Prompt=comboProps[20];
	this.ComboTypeAhead=comboProps[22];
    
	this.Events= new igcmbo_events(eval("igcmbo_"+this.ClientUniqueId+"_Events"));	

	this.Loaded=false;
	this.Dropped = false;
	this.NeedPostBack=false;
	this.CancelPostBack=false;
	this.TopHoverStarted=false;
	
	this.getDropDown = igcmbo_getDropDown;
	this.setDropDown = igcmbo_setDropDown;
	this.getDisplayValue = igcmbo_getDisplayValue;
	this.setDisplayValue = igcmbo_setDisplayValue;
	this.getDataValue = igcmbo_getDataValue;
	this.setDataValue = igcmbo_setDataValue;
	this.setWidth = igcmbo_setWidth;
	this.getWidth = igcmbo_getWidth;
	this._setInputWidth= _igcmbo_setInputWidth;
	this.getSelectedIndex = igcmbo_getSelectedIndex;
	this.setSelectedIndex = igcmbo_setSelectedIndex;
	this._setSelectedIndex = function(newIndex)
	{
		this._oldSelectedIndex = this.selectedIndex;
		this.selectedIndex = newIndex;
	}	
	this.selectedIndex = comboProps[21];
	this._oldSelectedIndex = comboProps[21];
	
	this.setFocusTop = igcmbo_setFocusTop;
	this.updateValue = igcmbo_updateValue;
	this.updatePostField = igcmbo_updatePostField;
	this.setSelectedRow = igcmbo_setSelectedRow;
	var addOnGrid="xxGrid";
	var grid = igtbl_getElementById(this.ClientUniqueId + addOnGrid);
	if(!grid)
	{
		addOnGrid="$xGrid";
		grid = igtbl_getElementById(this.ClientUniqueId + addOnGrid);
	}
	if(grid!=null)
		grid.setAttribute("igComboId", this.ClientUniqueId);
	this.grid = igtbl_getGridById(this.ClientUniqueId + addOnGrid);
	this.getGrid = igcmbo_getGrid;
	var innerctl;
	innerctl=igcmbo_getElementById(this.ClientUniqueId + "_input");	
	this.inputBox = innerctl;
	this.displayValue = innerctl.value;
	this._setInputWidth(comboElement.offsetWidth);
	this.setDisplayValue(this.displayValue,false,true);
	//this.setWidth(this.Element.offsetWidth);
	
	// begin - editor control support
	igcmbo_getElementById(this.ClientUniqueId).Object=this;
	this.getVisible = igcmbo_getVisible;
	this.setVisible = igcmbo_setVisible;
	this.getValue = igcmbo_getValue;
	this.setValue = igcmbo_setValue;
	this.eventHandlers=new Object();
	this.addEventListener=igcmbo_addEventListener;
	this.removeEventListener=igcmbo_removeEventListener;
	// end - editor control support
	
	this.keyCount=0;
	this.typeAheadTimeout=null;
	this.highlightText=igcmbo_highlightText;
	
	this.container = igcmbo_getElementById(this.ClientUniqueId + "_container");
	this.elemCal=this.container;
	this.ExpandEffects = new igcmbo_expandEffects(comboProps[4], comboProps[5], comboProps[6], comboProps[7], comboProps[8], comboProps[9],this);
	this._relocate=function(npe1,npe2)
	{
		var pe=this.Element.parentNode,e=this.Element,ne=e.nextSibling,npe=npe1;
		pe.removeChild(e);
		pe.removeChild(ne);
		if(npe)
			try
			{
				npe.appendChild(e);
				npe.appendChild(ne);
			}
			catch(ex)
			{
				npe=null;
			}
		if(!npe)
		{
			npe2.appendChild(e);
			npe2.appendChild(ne);
		}
		e.style.zIndex=9999;
		ne.style.zIndex=9999;
	}
	this.focus=function()
	{	   
		
		try
		{
			this.inputBox.focus();
		}
		catch(e){}
	}
	this._unloadCombo=function()
	{
		var gn = this.Id
		if(gn)
		{
			igcmbo_comboState[this.Id].disposing=true;
			igtbl_dispose(igcmbo_comboState[gn]);
			delete igcmbo_comboState[gn];
		}
	}	
	this._move=function(e,par)
	{
		try
		{
			ig_csom._skipNew=true;
			e.parentNode.removeChild(e);
			par.appendChild(e);
			ig_csom._skipNew=false;
			return true;
		}catch(ex){}
		return false;
	}
	igcmbo_comboState[this.Id]=this;
}

function igcmbo_onresize(evt,comboId)
{
	var c = igcmbo_getComboById(comboId);
	if (c && !c.inComboResize)
	{
		c.inComboResize=true;
		c._setInputWidth();	
		c.inComboResize=false;
	}
}

// private
function _igcmbo_setInputWidth(width)
{
	if(typeof(width)=='undefined')
	{ 
		width=this.Element.offsetWidth;	
	}	
	
	if (width==0 && this.Element.clientWidth) width = this.Element.clientWidth;
	if (width==0) return;	
	var innerctl;
	var border = 8;
	var image = igcmbo_getElementById(this.ClientUniqueId + "_img");	
	innerctl = igcmbo_getElementById(this.ClientUniqueId + "_input");
	innerctl.style.width =  width - image.offsetWidth - border > 0 ? (width - image.offsetWidth - border)+"px" : (width - image.offsetWidth)+"px";	
}

// public - sets the width of the WebCombo to the passed in value
function igcmbo_setWidth(width) {
	if(width==0)
		return;
	this._setInputWidth(width);	
	this.Element.style.width = width+"px";
}

// public - returns the CSS width of the combo element.
function igcmbo_getWidth() {return this.Element.style.width;}

// private - event initialization for combo object
function igcmbo_getDropDown(){return this.Dropped;}

// private - event initialization for combo object
function igcmbo_setDropDown(bDrop){
	if(this.Element.style.display=="none") return;
	
	var tPan=this.transPanel,
		pan=this.container,
		edit=this.inputBox;
	
	if(bDrop == true)
	{
		if(this.Dropped == true)
			return;
 		if(igcmbo_fireEvent(this.ClientUniqueId,this.Events.BeforeDropDown,"(\""+this.ClientUniqueId+"\");"))
	 		return;

		this.grid.Element.setAttribute("mouseDown",null);

		this.focus();		
		var editH=edit.offsetHeight,
			editW=edit.offsetWidth,
			e=edit,
			x=pan.parentNode,
			body=window.document.body;
		if(editH==null)
			editH=20;
		var f=x.tagName,
			bp=body.parentNode,
			par=this.inputBox.form;
		if(f=="FORM")
		{
			par=null;
			if(x.style)
				if((f=x.style.position)!=null)
					if(f.toLowerCase()=="absolute")
						par=body;
		}
		else if(f=="BODY"||f=="HTML")
			par=null;
		if(par)
			if(!this._move(pan,par))
				if(par!=body)
					this._move(pan,body);
		this.ExpandEffects.applyFilter();
		pan.style.visibility="visible";
		pan.style.display="";		
		if(pan.offsetHeight<5&&par&&par!=body)
			this._move(pan,body);
		var panH=pan.offsetHeight,
			panW=pan.offsetWidth,
			z=0;
		if((x=this.elemCal.offsetHeight)!=panH)
			pan.style.height=(panH=x)+"px";
		if((x=this.elemCal.offsetWidth)!=panW)
			pan.style.width=(panW=x)+"px";
		if(tPan==null&&this.HideDropDowns&&ig_csom.IsIEWin)
		{	
			this.transPanel=tPan=ig_csom.createTransparentPanel();
			if(tPan){tPan.Element.style.zIndex=10002;}			
		}		
		pan.style.zIndex=10003;
		var ok=0,
			pe=e,
			y=0,
			x=0,
			passedMain=false;
		while(e!=null)
		{
			if(ok<1||e==body)
			{
				if((z=e.offsetLeft)!=null)
					x+=z;
				if((z=e.offsetTop)!=null)
					y+=z;
				if(e==this.Element)
					passedMain=true;
				if(passedMain && e.style.borderLeftWidth)
				{
					var blw=parseInt(e.style.borderLeftWidth,10);
					if(!isNaN(blw))
						x+=blw;
				}
				if(e.style.borderTopWidth)
				{
					var btw=parseInt(e.style.borderTopWidth,10);
					if(!isNaN(btw))
						y+=btw;
				}
			}
			if(e.nodeName=="HTML")
				body=e;
			if(e==body)
				break;
			z=e.scrollLeft;
			if(z==null||z==0)
				z=pe.scrollLeft;
			if(z!=null&&z>0)
				x-=z;
			z=e.scrollTop;
			if(z==null||z==0)
				z=pe.scrollTop;
			if(z!=null&&z>0)
				y-=z;
			pe=e.parentNode;
			e=e.offsetParent;
			if(pe.tagName=="TR")
				pe=e;
			if(e==body&&pe.tagName=="DIV")
			{
				e=pe;
				ok++;
			}
		}
		
		
		y+=editH;		
		if((z=this.dropDownAlignment)==1)
			x-=(panW-editW)/2;
		else if(z==2)
			x-=panW-editW;
		z=body.clientHeight;
		if(z==null||z<20)
		{
			z=pe.offsetHeight;
			f=body.offsetHeight;
			if(f>z)
				z=f;
		}
		else
		{
			if(bp&&(f=bp.offsetHeight)!=null)
				if(f>panH&&f<z)
					z=f-10;
		}
		if((f=body.scrollTop)==null)
			f=0;
		if(f==0&&bp)
			if((f=bp.scrollTop)==null)
				f=0;
		if(y-f-3>panH+editH)
			if(z<y+panH)
				y-=panH+editH;
		z=body.clientWidth;
		if(z==null||z<20)
		{
			z=pe.offsetWidth;
			f=body.offsetWidth;
			if(f>z)
				z=f;
		}
		else
		{
			if(bp&&(f=bp.offsetWidth)!=null)
				if(f>panW&&f<z)
					z=f-20;
		}
		if((f=body.scrollLeft)==null)
			f=0;
		if(f==0&&bp)
			if((f=bp.scrollLeft)==null)
				f=0;
		if(x+panW>z+f)
			x=z+f-panW;
		if(x<f)
			x=f;
		if(x<0)
			x=0;
		if(y<0)
			y=0;
		if(ig_csom.IsMac&&(ig_csom.IsIE||ig_csom.IsSafari))
		{
			x+=ig_csom.IsIE?5:-5;
			y+=ig_csom.IsIE?11:-7;
		}
		pan.style.left=x+"px";
		pan.style.top=y+"px";
		this.ExpandEffects.applyFilter(true);
		if(tPan!=null)
		{
			tPan.setPosition(y-1,x-1,panW+2,panH+2);
			tPan.show();
		}
		var addOnGrid="xxGrid";
		var dropdowngrid=igcmbo_getElementById(this.ClientUniqueId+addOnGrid+"_main");
		if(!dropdowngrid)
		{
			addOnGrid="$xGrid";
			dropdowngrid=igcmbo_getElementById(this.ClientUniqueId+addOnGrid+"_main");
		}
		if(document.all && dropdowngrid != null) {
			if(this.webGrid)
				this.webGrid.Element.setAttribute("noOnResize",true);
			igtbl_activate(this.ClientUniqueId + addOnGrid);
			if(this.webGrid)
				this.webGrid.Element.removeAttribute("noOnResize");
		}
		
		
		this.Dropped = true;
		if(this.grid.getActiveRow())
			igtbl_scrollToView(this.grid.Id,this.grid.getActiveRow().Element);
		igcmbo_currentDropped = this;
 		igcmbo_fireEvent(this.ClientUniqueId,this.Events.AfterDropDown,"(\""+this.ClientUniqueId+"\");");
 		this._internalDrop = true;
 		setTimeout(igcmbo_clearInternalDrop, 100);
	}
	else
	{
		if(this.Dropped == false)
			return;
		var grid = igcmbo_getElementById(this.ClientUniqueId + "_container");
 		if(igcmbo_fireEvent(this.ClientUniqueId,this.Events.BeforeCloseUp,"(\""+this.ClientUniqueId+"\");")) {
 			return;
		}
		if(this.webGrid)
			this.webGrid.Element.setAttribute("noOnResize",true);
		pan.style.visibility="hidden";
		pan.style.display="none";
		if(tPan!=null)
			tPan.hide();
		this.Dropped = false;		
		if(this.HideDropDowns)
			igcmbo_hideDropDowns(false);
		var inputbox = igcmbo_getElementById(this.ClientUniqueId + "_input");
		igcmbo_currentDropped = null;
 		igcmbo_fireEvent(this.ClientUniqueId,this.Events.AfterCloseUp,"(\""+this.ClientUniqueId+"\");");
		if(this.webGrid)
		{
			igcmbo_wgNoResize=this.webGrid;
	 		setTimeout(igcmbo_clearnoOnResize, 100);
		}
	}
}
function igcmbo_clearInternalDrop() {
	if(igcmbo_currentDropped) igcmbo_currentDropped._internalDrop = null;
}
var igcmbo_wgNoResize=null;
function igcmbo_clearnoOnResize() {
	if(igcmbo_wgNoResize){
		igcmbo_wgNoResize.Element.removeAttribute("noOnResize");
		igcmbo_wgNoResize=null;
	}
}

function igcmbo_editkeydown(evnt,comboId) {
	var oCombo = igcmbo_getComboById(comboId);
	if(oCombo && oCombo.Loaded) {
		var keyCode = (evnt.keyCode);
		var newValue = igcmbo_srcElement(evnt).value;
    	if(igcmbo_fireEvent(oCombo.ClientUniqueId,oCombo.Events.EditKeyDown,"('"+oCombo.ClientUniqueId+"','"+escape(newValue)+"',"+keyCode+");"))
    		return igtbl_cancelEvent(evnt);
		if(oCombo.eventHandlers["keydown"] && oCombo.eventHandlers["keydown"].length>0){
			var ig_event=new ig_EventObject();
			ig_event.event=evnt;
			for(var i=0;i<oCombo.eventHandlers["keydown"].length;i++)
				if(oCombo.eventHandlers["keydown"][i].fListener)
				{
					if(keyCode==9 || keyCode==13 || keyCode==27)
						oCombo.setDisplayValue(newValue,false);
					oCombo.eventHandlers["keydown"][i].fListener(oCombo,ig_event,oCombo.eventHandlers["keydown"][i].oThis);
					if(ig_event.cancel)
						return igtbl_cancelEvent(evnt);
				}
		}				
		if (oCombo.ComboTypeAhead!=0 && igcmbo_isCountableKey(keyCode) )
			oCombo.keyCount++;
		if (!oCombo.Editable&&oCombo.ComboTypeAhead==1)
		{
			if(oCombo.DataTextField.length>0)column=oCombo.getGrid().Bands[0].getColumnFromKey(oCombo.DataTextField)			
			else column=oCombo.getGrid().Bands[0].Columns[0];
			var s=String.fromCharCode(evnt.keyCode);			
			if (igcmbo_isCountableKey(evnt.keyCode)){
				var cell=null;
				var row;
				cell = igcmbo_typeaheadFindCell(oCombo,s, column, oCombo.lastKey);
				if(cell){
					oCombo.lastKey = s;
					text = igcmbo_processTypeAhead(oCombo,oCombo.getGrid(),cell);
					newValue=text;
				}
			}
			else{
				var oText=igcmbo_ProcessNavigationKey(oCombo,column,evnt.keyCode,evnt);
				if (oText) newValue=oText;
			}
		}
		if(oCombo.displayValue!=newValue)
		{
			oCombo.updatePostField(newValue);
			oCombo.displayValue = newValue;
		}
		if(keyCode==38 || keyCode==40)
		{
			if (!oCombo.IsDropped)			
			{
				return igtbl_cancelEvent(evnt);
			}
		}
	}
}

// private function
// used to determine what keys will trigger type ahead counter increment/decrements
function igcmbo_isCountableKey(keyCode){		
	if (keyCode<32)
		return false;
	switch(keyCode){
		//end//right//home//left
		case 35: case 39: case 36: case 37:
		//back//del
		case 8: case 46:
		//up//down
		case 38: case 40:
			return false;
			break;
	}	
	return true;
}
// private function
function igcmbo_arrowKeyNavigation(oCombo, oGrid, oRow, column){
	var text = null;
	if(oRow != null){
		oGrid.setActiveRow(oRow);
		oGrid.clearSelectionAll();
		oRow.setSelected(true);
		
		oRow.scrollToView();
		oCombo._setSelectedIndex(oRow.getIndex());		
		var cell = oRow.getCell(column.Index);
		text = cell.getValue(true);
		oCombo.updateValue(text, true);		
		if(oCombo.DataValueField) oCombo.dataValue=oRow.getCellFromKey(oCombo.DataValueField).getValue();
		igtbl_updatePostField(oGrid.Id);
	}
	return text;
}
// private function
function igcmbo_highlightText(){
	var oInput = document.getElementById(this.ClientUniqueId + "_input");
	if (null==oInput)return;
	var oInTextRange= oInput.createTextRange?oInput.createTextRange():null;
	if (this.Editable){
		if (oInTextRange){
			oInTextRange.moveStart("character",this.ComboTypeAhead==2&&this.lastKey?this.lastKey.length:0);
			oInTextRange.moveEnd("textedit");
			oInTextRange.select();
		}
		else if (oInput.selectionStart){
			oInput.selectionStart =  this.lastKey?this.lastKey.length:0;
			oInput.selectionEnd = oInput.value.length;
		}
	}
	else{
		oInput.style.backgroundColor = this.SelBackColor;
		oInput.style.color = this.SelForeColor;
	}
}
// private function
function igcmbo_typeAheadReset(comboId){
	var oCombo = igcmbo_getComboById(comboId);
	if (oCombo){
		oCombo.keyCount=0;
		oCombo.typeAheadTimeout=null;
		if (2==oCombo.ComboTypeAhead)
			oCombo.lastKey="";
	}
}
// private
function igcmbo_typeaheadFindCell(oCombo,charFromCode, column, lastKey){
		var cell=null;
		var re=new RegExp("^"+igtbl_getRegExpSafe(charFromCode),"gi");
		if(lastKey!=charFromCode) cell=column.find(re);
		else if(cell==null){
			cell=column.findNext();
			if(cell==null) cell=column.find(re);
		}
		return cell;
}
//private
function igcmbo_processTypeAhead(oCombo,oGrid,oCell){
	var text=null;
	text=oCell.getValue(true);
	var oRow=oGrid.getActiveRow();
	oGrid.clearSelectionAll();
	if(oRow) oRow.setSelected(false);
	oRow=oCell.getRow();
	oGrid.setActiveRow(oRow);
	oRow.setSelected(true);
	
	oCombo._setSelectedIndex(oRow.getIndex());
	//oCombo._oldSelectedIndex=oCombo.selectedIndex()
	//oCombo.selectedIndex=oRow.getIndex();
	
	oCombo.updateValue(text, true);
	if(oCombo.DataValueField) oCombo.dataValue=oRow.getCellFromKey(oCombo.DataValueField).getValue();
	igtbl_updatePostField(oGrid.Id);
	oCombo.highlightText();								
	return text;
}
	
//private
function igcmbo_ProcessNavigationKey(oCombo,column,keyCode,evnt){
		var oRow=null;
		var oGrid=oCombo.getGrid();
		var oText=null;
		switch(keyCode){
		case 8: case 46:
			if (oCombo.Editable){
				document.selection.createRange().text="";
				oCombo.lastKey=igcmbo_srcElement(evnt).value;
			}
			break;			
		case 40:
			oRow=oGrid.getActiveRow();
			if(oRow!=null){
				oRow.setSelected(false);
				var oRow=oRow.getNextRow();
				oText=igcmbo_arrowKeyNavigation(oCombo,oGrid,oRow,column);
			}
			else if (oGrid.Rows.length>0) oText=igcmbo_arrowKeyNavigation(oCombo,oGrid,oGrid.Rows.getRow(0),column);
			break;
		case 38:				
				oRow = oGrid.getActiveRow();
				if(oRow != null){
					oRow.setSelected(false);
					var oRow = oRow.getPrevRow();
					oText = igcmbo_arrowKeyNavigation(oCombo,oGrid,oRow,column);
				}
				else if (oGrid.Rows.length > 0) oText=igcmbo_arrowKeyNavigation(oCombo,oGrid,oGrid.Rows.getRow(oGrid.Rows.length-1),column);				
				break;
		}
	return oText;
}		
function igcmbo_editkeyup(evnt,comboId) {
	var oCombo = igcmbo_getComboById(comboId);
	if(oCombo&&oCombo.Loaded){
		var keyCode=(evnt.keyCode);
		if (keyCode==9)return;
		var charFromCode=String.fromCharCode(evnt.keyCode);
		var newValue = oCombo.Editable ? igcmbo_srcElement(evnt).value:charFromCode;
    	if(igcmbo_fireEvent(oCombo.ClientUniqueId,oCombo.Events.EditKeyUp,"(\""+oCombo.ClientUniqueId+"\",\""+escape(newValue) +"\","+keyCode+");"))
    		return igtbl_cancelEvent(evnt);		
		if (0==oCombo.ComboTypeAhead) return;		
		var bCountableKey=igcmbo_isCountableKey(keyCode);
		if (bCountableKey) --oCombo.keyCount;
		var lastKey=oCombo.lastKey;		
		if (2==oCombo.ComboTypeAhead)
			if (oCombo.Editable)charFromCode=newValue;
			else{
				charFromCode=(bCountableKey?(lastKey?lastKey:"")+newValue:null);
				oCombo.lastKey=charFromCode;
			}
		else
			oCombo.lastKey = charFromCode;				
		if (oCombo.keyCount==0){			
			var oGrid=oCombo.getGrid();
			if(oGrid==null || oGrid.Bands==null) return;
			var column=null;
			if(oCombo.DataTextField.length>0)column=oGrid.Bands[0].getColumnFromKey(oCombo.DataTextField)			
			else {
				var colNo=0;
				column=oGrid.Bands[0].Columns[colNo];
			}
			if(column==null) return;			
			var text;
			var cell;
			var oCurrentRow=null;				
			if(charFromCode&&bCountableKey){				
				cell=igcmbo_typeaheadFindCell(oCombo,charFromCode,column,lastKey);
				if(cell!=null){
					oCombo.lastKey=charFromCode;
					text=igcmbo_processTypeAhead(oCombo,oGrid,cell);
					oCombo.typeAheadTimeout = null;
					oCombo.typeAheadTimeout = setTimeout("igcmbo_typeAheadReset('"+oCombo.ClientUniqueId+"')",1000);					
					if (!oCombo.Editable) newValue=text;
				}
				else {				
					var oEditor=document.getElementById(oCombo.ClientUniqueId + "_input");
					if (!oCombo.Editable){						
						var oActRow=oGrid.getActiveRow();												
						if (oActRow) oEditor.value= oCombo.DataTextField!=null && oCombo.DataTextField!="" ? oActRow.getCellFromKey(oCombo.DataTextField).getValue() : oActRow.getCell(0).getValue(); 
						newValue=oEditor.value;										
						oCombo.highlightText();						
					}
					else  // if editable and no row is found we should move off all rows since this may be a new value
					{
						oGrid.clearSelectionAll();
						oGrid.setActiveRow(null);
						oCombo._setSelectedIndex(-1);
						newValue=charFromCode;
					}
					oCombo.typeAheadTimeout=setTimeout("igcmbo_typeAheadReset('"+oCombo.ClientUniqueId+"')",1000);
				}
			}
			else{				
				var oText=igcmbo_ProcessNavigationKey(oCombo,column,evnt.keyCode,evnt);
				if (null!=oText) newValue=oText;
			}
		}
		else
			oCombo.typeAheadTimeout=setTimeout("igcmbo_typeAheadReset('"+oCombo.ClientUniqueId+"')",500);
		if(oCombo.displayValue!=newValue)
		{
			oCombo.updatePostField(newValue);
			oCombo.displayValue=newValue;
		}
	}
}
function igcmbo_onfocus(evnt,comboId) {
	var oCombo = igcmbo_getComboById(comboId);
	if(!oCombo)
		return;
	oCombo.setFocusTop();
	oCombo.highlightText();
}

function igcmbo_onblur(evnt,comboId) {
	var oCombo = igcmbo_getComboById(comboId);
		
	if(!oCombo || !oCombo.Loaded) 
		return;
		
	// moved this outside the loop 
	var inputbox = igcmbo_getElementById(oCombo.ClientUniqueId + "_input");		
	if (inputbox)
	{
		if (!oCombo.Editable){		
			inputbox.style.backgroundColor = oCombo.BackColor;
			inputbox.style.color = oCombo.ForeColor;
		}
		else{
			var oGrid = oCombo.getGrid();
			var oEditor=document.getElementById(oCombo.ClientUniqueId + "_input");
			var oActRow=oGrid.getActiveRow();
			if (oActRow)
			{			
				var oCellValue = oCombo.DataTextField!=null && oCombo.DataTextField!="" ? oActRow.getCellFromKey(oCombo.DataTextField).getValue():oActRow.getCell(0).getValue(); 
				if (oEditor.value!=oCellValue)				
				{
					oGrid.clearSelectionAll();
					oGrid.setActiveRow(null);	
					oCombo._setSelectedIndex(-1);
					//oCombo.selectedIndex = -1;
					oCombo.updateValue(oEditor.value, true);
					igtbl_updatePostField(oGrid.Id);
							
				}
			}
			if(oCombo.getDisplayValue()!=oEditor.value)
				oCombo.updatePostField(oEditor.value);	
		}
	}
	
	if(oCombo!=igcmbo_displaying) 
		return;
	
	
	if (document.all && oCombo.Element.contains(evnt.toElement)) {		
    }
    else {	
		if(oCombo.webGrid != null) {
			var container = igcmbo_getElementById(oCombo.ClientUniqueId + "_container");
			if(oCombo._internalDrop || oCombo.Element.getAttribute("noOnBlur"))
				return;
			if(oCombo.eventHandlers["blur"] && oCombo.eventHandlers["blur"].length>0)
			{
				var ig_event=new ig_EventObject();
				ig_event.event=evnt;
				for(var i=0;i<oCombo.eventHandlers["blur"].length;i++)
					if(oCombo.eventHandlers["blur"][i].fListener)
					{
						oCombo.eventHandlers["blur"][i].fListener(oCombo,ig_event,oCombo.eventHandlers["blur"][i].oThis);
						if(ig_event.cancel)
							return igtbl_cancelEvent(evnt);
					}
			}
		}
    }
}
function igcmbo_setFocusTop() {
	var inputbox = igcmbo_getElementById(this.ClientUniqueId + "_input");
	this.focus();
	if(this.Editable)
		inputbox.select();
	else{
		inputbox.style.backgroundColor=this.SelBackColor;
		inputbox.style.color=this.SelForeColor;
	}	
}

// private - event initialization for combo object
function igcmbo_events(events){
	this.InitializeCombo=events[0];
	this.EditKeyDown=events[1];
	this.EditKeyUp=events[2];
	this.BeforeDropDown=events[3];
	this.AfterDropDown=events[4];
	this.BeforeCloseUp=events[5];
	this.AfterCloseUp=events[6];
	this.BeforeSelectChange=events[7];
	this.AfterSelectChange=events[8];
}

function igcmbo_gridmouseover(gridName, itemId) {
	var grid = igtbl_getGridById(gridName);
	var cell = igtbl_getCellById(itemId);
	if(cell == null)
		return;
	igtbl_clearSelectionAll(gridName);
	igtbl_selectRow(gridName,cell.Row.Element.id);
}

function igcmbo_gridkeydown(gridName, itemId, keyCode) {
	igtbl_clearSelectionAll(gridName);
	var oCombo = igcmbo_currentDropped;
	if(keyCode == 27 || keyCode == 10) {
		oCombo.setDropDown(false);
		oCombo.setFocusTop();
	}
}

function igcmbo_gridrowactivate(gridName, itemId) {	
	var oCombo = igcmbo_getComboByGridName(gridName);
	//var oCombo = igcmbo_currentDropped;
	var row = igtbl_getRowById(itemId);
	if(oCombo == null || row == null)
		return;
	if(oCombo.DataTextField.length > 0) {
		cell = row.getCellFromKey(oCombo.DataTextField);
	}
	else
		cell = row.getCell(0);		
		
	var valueCell = oCombo.DataValueField.length>0 ? row.getCellFromKey(oCombo.DataValueField) : row.getCell(0);
	if(cell != null) {
		if(valueCell)oCombo.dataValue = valueCell.getValue();
		
		var v = cell.getValue(true);
		
		oCombo._setSelectedIndex(row.getIndex());
		
		//oCombo.selectedIndex = row.getIndex();
		oCombo.updateValue(v, true);
		
		
		if (this.event && this.event.type=="mousedown")
			oCombo.setDropDown(false);
		oCombo.setFocusTop();
	}
}

function igcmbo_setSelectedRow(row) {
	var cell = null;
	if(this.DataValueField.length > 0) 
	{
		cell = row.getCellFromKey(this.DataValueField);
		this.setDataValue(cell, false);
		if(this.Element.style.display!="none")
			this.setFocusTop();
	}
}

function igcmbo_gridmouseup(gridName, itemId) {
	var grid = igtbl_getGridById(gridName);
	var row = igtbl_getRowById(itemId);
	if(row == null)
		return;
	var cell = igtbl_getCellById(itemId);
	if(cell == null)
		return;

	var oCombo = igcmbo_currentDropped;
	if(oCombo != null) {
		oCombo.setSelectedRow(row);
		oCombo.setDropDown(false);
		oCombo.setFocusTop();
	}
}

function igcmbo_getSelectedIndex() {
	return this.selectedIndex;
}

function igcmbo_setSelectedIndex(index)
{
	if(index>=0 && index<this.grid.Rows.length)
		this.setSelectedRow(this.grid.Rows.getRow(index));
}

function igcmbo_getVisible() {
	if(this.Element.style.display == "none" || this.Element.style.visibility == "hidden")
		return false;
	else
		return true;
}

function igcmbo_setVisible(bVisible,left,top,width,height){
	if(bVisible){
		this.Element.style.display = "";
		this.Element.style.visibility = "visible";
		igcmbo_displaying=this;
		if(top)
		{
			this.Element.style.position="absolute";
			this.Element.style.top=top+"px";
			this.Element.style.left=left+"px";
		}
		if(height)
		{
			this.Element.style.height=height;
			this.setWidth(width);
		}
		if(bVisible)
		{
			this.focus();
			this.highlightText();
		}
	}
	else
	{
		if(this.Dropped)
			this.setDropDown(false);
		this.Element.style.display = "none";
		this.Element.style.visibility = "hidden";
		igcmbo_displaying=null;
	}
}

function igcmbo_getDisplayValue()
{
	return this.displayValue;
}

function igcmbo_getDataValue()
{
	return this.dataValue;
}

function igcmbo_setDisplayValue(newValue, bFireEvent, bNoPostUpdate)
{
	var cell=newValue;
	if(cell==null || typeof(cell)!="object")
	{
		this.updateValue(newValue, bFireEvent);
		var re = new RegExp("^"+igtbl_getRegExpSafe(newValue)+"$", "g");
		var column = null;
		if(this.DataTextField.length > 0) {
			column = this.grid.Bands[0].getColumnFromKey(this.DataTextField)
		}
		else {
			//var colNo = 0;
			column = this.grid.Bands[0].Columns[0];
		}
		if(column == null)
			return;
		if (this.selectedIndex>-1 && this.grid.Rows.length>0 && this.selectedIndex < this.grid.Rows.length)		
			cell = this.grid.Rows.getRow(this.selectedIndex).getCellByColumn(column);
		else
			cell = column.find(re);
	}
	else
		this.updateValue(cell.getValue(), bFireEvent);
	if(cell != null) 
	{
				
		var dataValueCell;
		if (this.DataValueField&&this.DataValueField.length>0)
			dataValueCell=cell.Row.getCellFromKey(this.DataValueField);
		if (!dataValueCell)
			dataValueCell=cell.Row.getCell(0);
		if(!dataValueCell) return;
		var nValue=dataValueCell.getValue();
		if(this.getDataValue()!=nValue)
		{
			if(this.DataValueField)
				this.dataValue=nValue;
			igtbl_clearSelectionAll(this.grid.Id);
			this.grid.setActiveRow(cell.Row);
			cell.Row.setSelected(true);
			
			//this.selectedIndex = cell.Row.getIndex();
			this._setSelectedIndex(cell.Row.getIndex());
			
			if(!bNoPostUpdate)
			{
				igtbl_updatePostField(this.grid.Id);
				this.updatePostField(newValue,false);
			}
		}
	}
	else
	{
		if(this.getDataValue()!=null)
		{
			this.dataValue=null;
			igtbl_clearSelectionAll(this.grid.Id);
			this.grid.setActiveRow(null);
			
			//this.selectedIndex = -1;
			this._setSelectedIndex(-1);
			if(!bNoPostUpdate)
			{
				igtbl_updatePostField(this.grid.Id);
				this.updatePostField(newValue,false);
			}
		}
	}
	return this.selectedIndex;
}

function igcmbo_setDataValue(newValue, bFireEvent)
{
	var cell=newValue;
	var oldDataValue=this.dataValue;
	if(cell==null || typeof(cell)!="object")
	{
		this.dataValue=newValue;
		var re = new RegExp("^"+igtbl_getRegExpSafe(newValue)+"$", "g");
		var column = null;
		if(this.DataTextField.length > 0)
			column = this.grid.Bands[0].getColumnFromKey(this.DataValueField)
		else
			column = this.grid.Bands[0].Columns[0];
		if(column == null)
			return;
		cell = column.find(re);
	}
	else
		this.dataValue=cell.getValue();
	if(cell != null)
	{
		if(this.DataTextField)
			this.updateValue(cell.Row.getCellFromKey(this.DataTextField).getValue(true),bFireEvent);
		igtbl_clearSelectionAll(this.grid.Id);
		this.grid.setActiveRow(cell.Row);
		cell.Row.setSelected(true);
		
		this._setSelectedIndex(cell.Row.getIndex());
		//this.selectedIndex = cell.Row.getIndex();
		
		igtbl_updatePostField(this.grid.Id);
		if(oldDataValue!=newValue && !this.DataTextField)
			this.updatePostField(newValue,false);
	}
	else
	{
		if(oldDataValue!=null)
		{
			this.dataValue=null;
			igtbl_clearSelectionAll(this.grid.Id);
			if(this.Prompt)	{
				var row=this.grid.Rows.getRow(0);
				row.activate();
				row.setSelected();					
			}
			else {
				this.grid.setActiveRow(null);
				this._setSelectedIndex(-1);
				//this.selectedIndex = -1;
				igtbl_updatePostField(this.grid.Id);
				this.updatePostField(newValue,false);
			}
		}
	}
	return this.selectedIndex;
}

function igcmbo_getValue()
{
	if(!this.Prompt || this.getSelectedIndex()>0)
		return this.dataValue;
}

function igcmbo_setValue(newValue, bFireEvent)
{
	if(this.dataValue==newValue)
		return;
	var cell=newValue;
	if(cell==null || typeof(cell)!="object" || newValue.getMonth)
	{
		var oRegEx = newValue?newValue.toString():newValue;
		var re = new RegExp("^"+igtbl_getRegExpSafe(oRegEx)+"$", "g");
		var column = null;
		if(this.DataValueField.length > 0)
			column = this.grid.Bands[0].getColumnFromKey(this.DataValueField)
		else
			column = this.grid.Bands[0].Columns[0];
		if(column == null)
			return;
		cell = column.find(re);
	}
	var dispValue=this.Prompt;
	if(cell != null)
	{
		this.dataValue=newValue;
		if(this.DataValueField)
		{
			cellValue=cell.Row.getCellFromKey(this.DataValueField).getValue();
			if(cellValue!=newValue)
				this.dataValue=cellValue;
		}
		if(this.DataTextField)
		{
			dispValue=cell.Row.getCellFromKey(this.DataTextField).getValue(true);
			this.updateValue(dispValue, (typeof(bFireEvent)=="undefined" || bFireEvent));
		}
		igtbl_clearSelectionAll(this.grid.Id);
		this.grid.setActiveRow(cell.Row);
		cell.Row.setSelected(true);
		this._setSelectedIndex(cell.Row.getIndex());
		//this.selectedIndex = cell.Row.getIndex();
	}
	else
	{
		this.dataValue=null;
		this.displayValue=dispValue;
		var ib=igcmbo_getElementById(this.ClientUniqueId+"_input");
		if(ib)
			ib.value=dispValue;
		igtbl_clearSelectionAll(this.grid.Id);
		this.grid.setActiveRow(null);
		//this.selectedIndex = -1;
		this._setSelectedIndex(-1);
	}
	igtbl_updatePostField(this.grid.Id);
	this.updatePostField(dispValue,false);
	if(this.Prompt && this.selectedIndex==-1)
	{
		this._setSelectedIndex(0);
		this.setSelectedIndex(0);
		return -1;
	}
	return this.selectedIndex;
}

var igtbl_pbInited=false;
function igcmbo_updateValue(newValue, bFireEvent)
{
	if(this.getDisplayValue()==newValue && this._oldSelectedIndex==this.selectedIndex)		
		return;
	if(bFireEvent == true) {
    	if(igcmbo_fireEvent(this.ClientUniqueId,this.Events.BeforeSelectChange,"(\""+this.ClientUniqueId+"\");")) {
	    	return false;
	    }
	}
	var inputbox = igcmbo_getElementById(this.ClientUniqueId + "_input");
	inputbox.value = newValue;
	this.updatePostField(newValue);
	this.displayValue = newValue;
	if(bFireEvent == true) {
		if(igcmbo_fireEvent(this.ClientUniqueId,this.Events.AfterSelectChange,"(\""+this.ClientUniqueId+"\");"))
			return;
	}
	if(this.NeedPostBack && bFireEvent == true && !igtbl_pbInited) {
		igtbl_pbInited=true;
		window.setTimeout("__doPostBack('"+this.UniqueId+"','AfterSelChange\x02"+this.selectedIndex+"')");
	}
}


var ig_inCombo=false;
// private - Handles the mouse down event
function igcmbo_mouseDown(evnt) {
	if(igcmbo_currentDropped != null)
	{			
		var grid = igcmbo_getElementById(igcmbo_currentDropped.ClientUniqueId + "_container");
		var elem = igtbl_srcElement(evnt);
		var parent = elem;
		while(true) {
			if(parent == null)
				break;
			if(parent == grid)
			{
				if(igcmbo_currentDropped.webGrid)
				{
					igtbl_lastActiveGrid=igcmbo_currentDropped.webGrid.Id;
					igcmbo_currentDropped.Element.setAttribute("noOnBlur",true);
					window.setTimeout("igtbl_cancelNoOnBlurDD()",100);
				}
				return;
			}
			parent = parent.parentNode;
		}				
		if(ig_inCombo == true) {
			ig_inCombo = false;
			return;		
		}

		if(igcmbo_currentDropped)
			igcmbo_currentDropped.setDropDown(false);

		ig_inCombo = false;			
	}
	var combo=igcmbo_currentDropped;
	if(!combo)
		combo=igcmbo_displaying;	
	if(combo && combo.eventHandlers["blur"] && combo.eventHandlers["blur"].length>0 && !igtbl_isAChildOfB(igtbl_srcElement(evnt),combo.Element))
	{
		var ig_event=new ig_EventObject();
		ig_event.event=evnt;
		for(var i=0;i<combo.eventHandlers["blur"].length;i++)
			if(combo.eventHandlers["blur"][i].fListener)
			{
				combo.eventHandlers["blur"][i].fListener(combo,ig_event,combo.eventHandlers["blur"][i].oThis);
				if(ig_event.cancel)
					return igtbl_cancelEvent(evnt);
			}
	}
}

// private - Handles the mouse up event
function igcmbo_mouseUp(evnt) {
	return;
}

// private - Obtains the proper source element in relation to an event
function igcmbo_srcElement(evnt)
{
	var se
	if(evnt.target)
		se=evnt.target;
	else if(evnt.srcElement)
		se=evnt.srcElement;
	return se;
}

// private - Updates the PostBackData field
function igcmbo_updatePostField(value)
{
	var formControl = igcmbo_getElementById(this.ClientUniqueId);
	if(!formControl)
		return;
	var index = this.selectedIndex;
	formControl.value = "Select\x02" + index + "\x02Value\x02" + value;
}

// private
function igcmbo_getGrid() {
	return this.grid;
}

function igcmbo_addEventListener(eventName,fListener,oThis)
{
	eventName=eventName.toLowerCase();
	if(!this.eventHandlers[eventName])
		this.eventHandlers[eventName]=new Array();
	var index=this.eventHandlers[eventName].length;
	if(index>=15)
		return false;
	for(var i=0;i<this.eventHandlers[eventName].length;i++)
		if(this.eventHandlers[eventName][i]["fListener"]==fListener)
			return false;
	this.eventHandlers[eventName][index]=new Object();
	this.eventHandlers[eventName][index]["fListener"]=fListener;
	this.eventHandlers[eventName][index]["oThis"]=oThis;
	return true;
}

function igcmbo_removeEventListener(eventName,fListener)
{
	if(!this.eventHandlers)
		return false;
	var eventName=eventName.toLowerCase();
	if(!this.eventHandlers[eventName] || this.eventHandlers[eventName].length==0)
		return false;
	for(var i=0;i<this.eventHandlers[eventName].length;i++)
		if(this.eventHandlers[eventName][i]["fListener"]==fListener)
		{
			delete this.eventHandlers[eventName][i]["fListener"];
			delete this.eventHandlers[eventName][i]["oThis"];
			delete this.eventHandlers[eventName][i];
			if(this.eventHandlers[eventName].pop)
				this.eventHandlers[eventName].pop();
			else
				this.eventHandlers[eventName]=this.eventHandlers[eventName].slice(0,-1);
			return true;
		}
	return false;
}

function igcmbo_getComboByGridName(gridName)
{
	var oC = null;
	if (!igcmbo_comboState) return oC;
	for (var c in igcmbo_comboState) if (igcmbo_comboState[c].grid.Id==gridName)oC=igcmbo_comboState[c];
	return oC;
}
function igcmbo_expandEffects(duration, opacity, type, shadowColor, shadowWidth, delay,owner){
	
	this.owner=owner;	
	this.Element=owner.container;
	
	this.Duration=duration;
	this.Opacity=opacity;
	this.Type=type;
	this.ShadowColor=shadowColor;
	this.ShadowWidth=shadowWidth;
	this.Delay=delay;
	this.getDuration=function(){return this.Duration;}
	this.getOpacity=function(){return this.Opacity;}
	this.getType=function(){return this.Type;}
	this.getShadowColor=function(){return this.ShadowColor;}
	this.getShadowWidth=function(){return this.ShadowWidth;}
	this.getDelay=function(){return this.Delay;}
	this.applyFilter=function(p)
	{
		var e=this.Element;
		if(!e||!ig_csom.IsIEWin||ig_csom.AgentName.indexOf("win98")>0||ig_csom.AgentName.indexOf("windows 98")>0)return;
		var s=e.style,ms="progid:DXImageTransform.Microsoft.";
		if(!p&&this.Type!="NotSet")s.filter=ms+this.Type+"(duration="+(this.Duration/1000)+")";
		if(!p&&this.ShadowWidth>0)s.filter+=" "+ms+"Shadow(Direction=135,Strength="+this.ShadowWidth+",color='"+this.ShadowColor+"')";
		if(!p)s.filter+=" "+"Alpha(Opacity="+this.Opacity+")"
		if(e.filters[0])try{if(p)e.filters[0].play();else e.filters[0].apply();}catch(ex){}
	}	
	
}

var igcmbo_oldOnUnload;
var igcmbo_bInsideOldOnUnload=false;
function _igcmbo_unload()
{
		if(igcmbo_oldOnUnload && !igcmbo_bInsideOldOnUnload)
		{
			igcmbo_bInsideOldOnUnload=true;
			igcmbo_oldOnUnload();
			igcmbo_bInsideOldOnUnload=false;
		}
		for(var comboId in igcmbo_comboState)
		{
			try
			{
				if(typeof(document)!=='unknown')
				{
					var p=igtbl_getElementById(comboId);
					p.value=ig_ClientState.getText(igcmbo_comboState[comboId].ViewState);
				}
			}
			catch(e)	
			{		
			}
			if(igcmbo_comboState[comboId]._unloadCombo)
				igcmbo_comboState[comboId]._unloadCombo();
			else
				delete igcmbo_comboState[comboId];
		}
		igcmbo_currentDropped = igcmbo_displaying = null;
}
if(window.addEventListener)
	window.addEventListener('unload',_igcmbo_unload,false);
else if(window.onunload!=_igcmbo_unload)
{
	igcmbo_oldOnUnload=window.onunload;
	window.onunload=_igcmbo_unload;
}

igcmbo_initialize();

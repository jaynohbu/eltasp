 /*
  * Infragistics WebListBar CSOM Script: ig_weblistbarIE4.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

var ig_dom;
var ig_IE;	
var iglbar_SourceGroup;
var iglbar_CloneGroup;
var iglbar_CurrentX=0;
var iglbar_CurrentY=0;

function ig_initialize() {
	 ig_dom = (document.getElementById) ? true : false;
	 ig_IE = (document.all) ? true : false;
	 ig_IE4 = ig_IE && !ig_dom;
	 ig_IE5 = ig_IE && ig_dom;
	 ig_Mac = (navigator.appVersion.indexOf("Mac") != -1);
	 ig_IE5M = ig_IE5 && ig_Mac;
	 ig_IEW = ig_IE && !ig_Mac;
	 ig_IE4W = ig_IE4 && ig_IEW;
	 ig_IE5W = ig_IE5 && ig_IEW;
	 ig_NS = navigator.appName == ("Netscape");
	 ig_NS4 = (document.layers) ? true : false;
	 ig_NS6 = navigator.vendor == ("Netscape6");
    	if(ig_IE5M) {
		ig_DOM = false; ig_IE4 = true;
	}
}
//Return the html Element with the specified id.
function iglbar_getElementById(tagName) {
	if(ig_dom==null)ig_initialize();
	if(ig_IE)
		return document.all[tagName];
	else
	{
		return document.getElementById(tagName);
	}
}
//Return an iglbar_Group object associated with the specified id. 
function iglbar_getGroupById(id){
	var parts=id.split("_");
	var barId=parts[0];
	var bar=iglbar_getListbarById(barId);
	return bar.Groups[parts[2]];
}
//Return an iglbar_Item object associated with the specified id.
function iglbar_getItemById(id){
	var parts=id.split("_");
	var barId=parts[0];
	var bar=iglbar_getListbarById(barId);
	return bar.Groups[parts[1]].Items[parts[3]];	
}

function iglbar_adjust(lbar){
	var i=0;
	var moveToBottom=false;
	var group=new Array(2);
	while(lbar.Groups[i]!=null){
		group[0]=iglbar_getElementById(lbar.Groups[i].Id+"_top_tr");
		group[1]=iglbar_getElementById(lbar.Groups[i].Id+"_bottom_tr");
		
		iglbar_getElementById(lbar.Id+"_Items_"+i.toString()).style.display="none";
		if(!moveToBottom){
			if(lbar.Groups[i]==lbar.SelectedGroup){
				moveToBottom=true;
				iglbar_getElementById(lbar.Id+"_Items_"+i.toString()).style.display="";
			}
			group[0].style.display="";
			group[1].style.display="none";
		}
		else{
			if(ig.getElementById(lbar.Id+"_BotGroup").style.display=="none")ig.getElementById(lbar.Id+"_BotGroup").style.display="";
			group[1].style.display="";
			group[0].style.display="none";
		}
		i++; 
	}
	iglbar_getElementById(lbar.Id+"_Items").className=lbar.SelectedGroup.GroupStyleClassName;
}

function iglbar_groupHeaderMouseOver(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var group=iglbar_getGroupById(src.id);
	if(group==null||!group.getExpanded()||!group.Enabled)return;
	src.className=group.HeaderAppearance.HoverAppearance.ClassName;
}
function iglbar_groupHeaderMouseOut(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var group=iglbar_getGroupById(src.id);
	if(group==null||!group.Enabled)return;
	if(group.getExpanded())
		src.className=group.HeaderAppearance.ExpandedAppearance.ClassName;
	else src.className=group.HeaderAppearance.CollapsedAppearance.ClassName;
}
function iglbar_headerClick(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var group=iglbar_getGroupById(src.id);
	if(group.getEnabled())iglbar_navigate(group.TargetUrl,group.TargetFrame);
	if(group.Control.HeaderClickAction==0)
		iglbar_toggleGroup(e,src);
}
function iglbar_headerDoubleClick(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var group=iglbar_getGroupById(src.id);
	if(group.Control.HeaderClickAction==1)
		iglbar_toggleGroup(e,src);
}

function iglbar_groupButtonClicked(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var group=iglbar_getGroupById(src.id);
	if(group==null||group.Control==null||group==group.Control.SelectedGroup||!group.Enabled)return;
	group.setSelected(true);	
	iglbar_navigate(group.TargetUrl,group.TargetFrame);
}
function iglbar_groupButtonMouseOver(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var group=iglbar_getGroupById(src.id);
	if(group==null||group.getSelected()||!group.Enabled)return;
	src.className=group.ButtonHoverStyleClassName;
}
function iglbar_groupButtonMouseOut(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var group=iglbar_getGroupById(src.id);
	if(group==null||group.getSelected()||!group.Enabled)return;
	src.className=group.ButtonStyleClassName;
}

function iglbar_itemClicked(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var item=iglbar_getItemById(src.id);
	if(!item.Enabled||!item.Group.Enabled)return;
	if(item==null||item.getSelected())return;
	item.setSelected(true);
}
function iglbar_itemMouseOver(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var item=iglbar_getItemById(src.id);
	if(item.getSelected()||!item.Enabled||!item.Group.Enabled)return;
	if(item.SelectionStyle==1)
		item.getImage().className=item.HoverStyleClassName;
	else src.className=item.HoverStyleClassName;

}
function iglbar_itemMouseOut(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");
	var item=iglbar_getItemById(src.id);
	if(item.getSelected()||!item.Enabled||!item.Group.Enabled)return;
	if(item.SelectionStyle==1)
		item.getImage().className=item.DefaultStyleClassName;
	else src.className=item.DefaultStyleClassName;
}

function iglbar_navigate(targetUrl,targetFrame){
	if(targetUrl==null||targetUrl==""||targetUrl.length==0)return;
	if(targetFrame==null||targetFrame == ""||targetFrame.length==0)
		targetFrame=null;
	if(targetUrl.indexOf("javascript") != -1)
	    eval(targetUrl);
	else
	if(targetFrame != null){
		if(iglbar_getElementById(targetFrame) != null) {
			iglbar_getElementById(targetFrame).src = targetUrl;
		}
		else
		if(eval("parent.frames."+targetFrame) != null) {
		   eval("parent.frames."+targetFrame+".location=\""+targetUrl+"\";");
		}
		else {
		   window.open(targetUrl);
		}
	}
	else
	{
	    location.href = targetUrl;
	}
}

function UltraWebListbar(id,groups){
	var props=eval(id+"_propsArray");
	this.Id=id;
	this.uniqueID=eval(id+"UniqueID");
	this.Groups=groups;
	this.Groups.valueChanged=false;
	this.SelectedGroup=this.Groups[props[1]];
	if(this.SelectedGroup!=null)this.SelectedGroup.selected=true;
	this.SelectedItem=this.SelectedGroup.Items[props[2]];
	this.HeaderClickAction=props[3];
	this.enabled=props[4];
	this.getEnabled=iglbar_getEnabled;
	this.setEnabled=iglbar_setEnabled;
	this.PostBackOnGroupClick=props[5];
	this.PostBackOnItemClick=props[6];
	this.PostBackOnGroupExpanded=props[7];
	this.PostBackOnGroupCollapsed=props[8];
	if(this.SelectedItem!=null)this.SelectedItem.selected=true;
	var i=0;
	while(groups[i]!=null){
		groups[i].Control=this;
		i++;
	}
}
function iglbar_HeaderStyle(style,xpndImage,image){
	this.ClassName=style;
	this.ExpansionIndicatorImageUrl=xpndImage;
	this.ImageUrl=image;
}
function iglbar_Header(xpnd,clpse,hover,xpandId,imageId){
	this.ExpandedAppearance=xpnd;
	this.CollapsedAppearance=clpse;
	this.HoverAppearance=hover;
	this.ExpansionIndicator=iglbar_getElementById(xpandId);
	this.Image=iglbar_getElementById(imageId);
}
function iglbar_ExplorerBarGroup(id,text,key,enabled,groupStyle,headerAppearance,itemIconStyle,itemSelectionStyle,expanded,targetUrl,targetFrame,items){
	this.Id=id;
	this.Element=iglbar_getElementById(id+"_group");
	this.Key=key;
	this.enabled=enabled;
	this.getEnabled=iglbar_isGroupEnabled;
	this.setEnabled=iglbar_setEnabled;
	this.GroupStyleClassName=groupStyle;
	this.HeaderAppearance=headerAppearance;
	this.ItemIconStyle=itemIconStyle;
	this.ItemSelectionStyle=itemSelectionStyle;
	this.Items=items;
	this.Items.ValueChanged=false;
	this.TargetUrl=targetUrl;
	this.TargetFrame=targetFrame;
	this.expanded=expanded;
	this.getExpanded=iglbar_getExpanded;
	this.setExpanded=iglbar_expandGroup;
	var header=iglbar_getElementById(id+"_header");
	if(this.HeaderAppearance!=null&&header!=null){
		this.HeaderAppearance.Element=header;
		this.HeaderAppearance.Id=id+"_header";
	}
	this.valueChanged=false;
	var i=0;
	this.Control=null;
	if(items!=null){
		while(items[i]){
			items[i].Group=this;
			i++;
		}
	}
}
function iglbar_getExpanded(){
	return this.expanded;
}
function iglbar_ListbarGroup(id,text,key,enabled,groupStyle,buttonStyle,buttonHovStyle,buttonSelStyle,itemIconStyle,itemSelectionStyle,targetUrl,targetFrame,items){
	this.Id=id;
	this.topElement=iglbar_getElementById(id+"_top");
	this.bottomElement=iglbar_getElementById(id+"_bottom");
	this.Element=new Array(2);
	this.Element[0]=this.topElement;
	this.Element[1]=this.bottomElement;
	this.Key=key;
	this.enabled=enabled;
	this.getEnabled=iglbar_isGroupEnabled;
	this.setEnabled=iglbar_setEnabled;
	this.GroupStyleClassName=groupStyle;
	this.ButtonStyleClassName=buttonStyle;
	this.ButtonHoverStyleClassName=buttonHovStyle;
	this.ButtonSelectedStyleClassName=buttonSelStyle;
	this.ItemIconStyle=itemIconStyle;
	this.ItemSelectionStyle=itemSelectionStyle;
	this.Items=items;
	this.Items.ValueChanged=false;
	//this.SelectedItem=null;
	this.selected=false;
	this.TargetUrl=targetUrl;
	this.TargetFrame=targetFrame;
	this.setSelected=iglbar_selectGroup;
	this.getSelected=iglbar_getSelected;
	this.valueChanged=false;
	var i=0;
	this.Control=null;
	if(items!=null){
		while(items[i]){
			items[i].Group=this;
			i++;
		}
	}
}

function iglbar_Item(id,text,key,defStyle,hovStyle,selStyle,targetUrl,targetFrame,image,selectedImage,enabled){
	this.Id=id;
	this.Element=iglbar_getElementById(id);
	this.Key=key;
	this.DefaultStyleClassName=defStyle;
	this.HoverStyleClassName=hovStyle;
	this.SelectedStyleClassName=selStyle;
	this.TargetUrl=targetUrl;
	this.TargetFrame=targetFrame;
	this.Group=null;
	this.ImageUrl=image;
	this.SelectedImageUrl=selectedImage;
	this.getImage=iglbar_getImage;
	this.selected=false;
	this.setSelected=iglbar_selectItem;
	this.getSelected=iglbar_getSelected;
	this.valueChanged=false;
	this.enabled=enabled;
	this.getEnabled=iglbar_isItemEnabled;
	this.setEnabled=iglbar_setEnabled;
}
function iglbar_getSelected(){
	return this.selected;
}
function iglbar_getEnabled(){
	return this.enabled;
}
function iglbar_isGroupEnabled(){
	return this.enabled&&this.Control.getEnabled();
}
function iglbar_isItemEnabled(){
	return this.enabled&&this.Group.getEnabled();
}
function iglbar_setEnabled(enabled){
	this.enabled=enabled;
	if(enabled)this.Element.removeAttribute("disabled");
	else this.Element.setAttribute("disabled","disabled");
}

function iglbar_toggleGroup(e,src){
	e = (e) ? e : ((window.event) ? window.event : "");	
	var group=iglbar_getGroupById(src.id);
	if((src.tagName=="IMG"&&group.Control.HeaderClickAction==0)||!group.getEnabled()){
		return true;
	}
	group.setExpanded(!group.getExpanded(),true);
}
function iglbar_expandGroup(expand,byMouse){
	if((!this.Enabled)&&byMouse)return;
	this.expanded=expand;
	if(expand){
		if(this.Control!=null&&this.Control.PostBackOnGroupExpanded)__doPostBack(eval(this.Control.Id+"UniqueID"),this.Id+":GroupExpanded");		
		iglbar_getElementById(this.Id+"_items").style.display="";
		this.HeaderAppearance.ExpansionIndicator.src=this.HeaderAppearance.ExpandedAppearance.ExpansionIndicatorImageUrl;
		iglbar_getElementById(this.Id+"_header").className=this.HeaderAppearance.ExpandedAppearance.ClassName;
		if(this.HeaderAppearance.LeftCornerImage!=null)
			this.HeaderAppearance.LeftCornerImage.src=this.HeaderAppearance.ExpandedAppearance.LeftCornerImageUrl;
		if(this.HeaderAppearance.RightCornerImage!=null)
			this.HeaderAppearance.RightCornerImage.src=this.HeaderAppearance.ExpandedAppearance.RightCornerImageUrl;
		if(this.HeaderAppearance.Image!=null)
			this.HeaderAppearance.Image.src=this.HeaderAppearance.ExpandedAppearance.ImageUrl;
	}
	else{
		if(this.Control!=null&&this.Control.PostBackOnGroupCollapsed)__doPostBack(eval(this.Control.Id+"UniqueID"),this.Id+":GroupCollapsed");		
		iglbar_getElementById(this.Id+"_items").style.display="none";
		this.HeaderAppearance.ExpansionIndicator.src=this.HeaderAppearance.CollapsedAppearance.ExpansionIndicatorImageUrl;
		iglbar_getElementById(this.Id+"_header").className=this.HeaderAppearance.CollapsedAppearance.ClassName;
		if(this.HeaderAppearance.LeftCornerImage!=null)
			this.HeaderAppearance.LeftCornerImage.src=this.HeaderAppearance.CollapsedAppearance.LeftCornerImageUrl;
		if(this.HeaderAppearance.RightCornerImage!=null)
			this.HeaderAppearance.RightCornerImage.src=this.HeaderAppearance.CollapsedAppearance.RightCornerImageUrl;
		if(this.HeaderAppearance.Image!=null)
			this.HeaderAppearance.Image.src=this.HeaderAppearance.CollapsedAppearance.ImageUrl;
	}
	if(byMouse)iglbar_groupHeaderMouseOver(null,this.HeaderAppearance.Element);
}
function iglbar_getImage(){
	return iglbar_getElementById(this.Id+"_img");
}

function iglbar_getListbarById(id){
	lbarObj=eval(id.split("_")[0]+"_obj");
	if(lbarObj==null){
		lbarObj= new UltraWebListbar(id,eval(id+"_groupsArray"));
		lbarObj.Element.style.display="";	
	}
	return lbarObj;
}
function iglbar_selectGroup(select){
  
	if(select){
		if(this.Control!=null&&this.Control.PostBackOnGroupClick)__doPostBack(eval(this.Control.Id+"UniqueID"),this.Id+":GroupSelected");
		if(this.Control.SelectedGroup!=null)this.Control.SelectedGroup.setSelected(false);
		this.selected=true;
		this.Control.SelectedGroup=this;
		this.Element[0].className=this.ButtonSelectedStyleClassName;
		this.Element[1].className=this.ButtonStyleClassName; //The button may not receive the mouseout event.  In this case, we need to change the style back to the Default style manually.
		iglbar_updatePostField(this.Control);
		iglbar_adjust(this.Control);
	}else{
		this.selected=false;
		if(this.Control.SelectedGroup==this)this.Control.SelectedGroup=null;
		this.Element[0].className=this.ButtonStyleClassName;
	}
}
function iglbar_selectItem(select){
	if(select){
		if(this.Group.Control!=null&&this.Group.Control.PostBackOnItemClick)__doPostBack(eval(this.Group.Control.Id+"UniqueID"),this.Id+":ItemSelected");
		//if(this.Group!=this.Group.Control.SelectedGroup)this.Group.setSelected(true);
		if(this.Group.Control.SelectedItem!=null)this.Group.Control.SelectedItem.setSelected(false);
		this.Group.Control.SelectedItem=this;
		this.selected=true;
		iglbar_navigate(this.TargetUrl,this.TargetFrame);
		if(this.SelectionStyle==1)
			this.getImage().className=this.SelectedStyleClassName;
		else this.Element.className=this.SelectedStyleClassName;
		if(this.SelectedImageUrl!=null&&this.SelectedImageUrl.length>0)
			this.getImage().src=this.SelectedImageUrl;
	}else{
		if(this.Group.Control.SelectedItem!=this)this.Group.Control.SelectedItem=null;
		this.selected=false;
		if(this.SelectionStyle==1)
			this.getImage().className=this.DefaultStyleClassName;
		else this.Element.className=this.DefaultStyleClassName;
		if(this.ImageUrl!=null&&this.ImageUrl.length>0)
			this.getImage().src=this.ImageUrl;	
	}
	iglbar_updatePostField(this.Group.Control);
}
function iglbar_isSelectedItem(){
}
function iglbar_updatePostField(listbar){
	var postData="";
	postData="SelectGroup\02"+listbar.SelectedGroup.Id+"\01";
	if(listbar.SelectedItem!=null)postData+="SelectItem\02"+listbar.SelectedItem.Id+"\01";
	var i=0;
	if(listbar.Groups.valueChanged){
		var newOrder="GroupSwapped";
		while(listbar.Groups[i]!=null){
			newOrder+="\02"+listbar.Groups[i].getVisibleIndex().toString();
			if(listbar.Groups[i].valueChanged){
				postData+="GroupTextChanged\02"+listbar.Groups[i].Id+"\02"+listbar.Groups[i].getText()+"\01";
			}
			if(listbar.Groups[i].Items.valueChanged){
				var j=0;
				while(listbar.Groups[i].Items[j]!=null){
					if(listbar.Groups[i].Items[j].valueChanged){
						postData+="ItemTextChanged\02"+listbar.Groups[i].Items[j].Id+"\02"+listbar.Groups[i].Items[j].getText()+"\01";
					}
					j++;
				}
			}
			
			i++;
		}
		postData+=newOrder;
	}
	iglbar_getElementById(listbar.uniqueID+"_hidden").value=postData;
}


function iglbar_killEvent(evt){
	window.status="kill event";
	evt = (evt) ? evt : ((window.event) ? window.event : "");
	//evt.cancelBubble=true;
	return false;
}

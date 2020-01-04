<!--
	function ComboBox_Init() {
	
        if ( ComboBox_UplevelBrowser() ) {
            for( var i = 0; i < ComboBoxes.length; i++ ) {
                ComboBox_Load( ComboBoxes[i] );
            }
        }
    }
    function ComboBox_UplevelBrowser() {
        if( typeof( document.getElementById ) == "undefined" ) return false;
        var combo = document.getElementById( ComboBoxes[0] + "_Container" );
        if( combo == null || typeof( combo ) == "undefined" ) return false;
        if( typeof( combo.style ) == "undefined" ) return false;
        if( typeof( combo.innerHTML ) == "undefined" ) return false;
        return true;
    }
    
      function findPosX(obj){
       var curleft = 0;

      if(obj.offsetParent){
        while(obj.offsetParent){
         curleft += obj.offsetLeft;
         obj = obj.offsetParent;
        }
       }

      if(obj.offsetLeft) { 
	   	  curleft += obj.offsetLeft; 
		  }    

       return curleft;
      } 

      function findPosY(obj){
       var curtop = 0;

       if(obj.offsetParent){
        while(obj.offsetParent){
         curtop += obj.offsetTop;
         obj = obj.offsetParent;
        }
       }
      if(obj.offsetTop) { 
	   	  curtop += obj.offsetTop; 
		  }	
	   
       return curtop;
      } 

    
    function ComboBox_Load( comboId ) {
        var combo  = document.getElementById( comboId + "_Container" );
        var button = document.getElementById( comboId + "_Button" );

		var list   = document.getElementById( comboId );
        var text   = document.getElementById( comboId + "_Text" );
        var div   = document.getElementById( comboId + "_Div" );
        
// Add New 10/30/2006
        var newButton = document.getElementById( comboId + "_AddNewButton" );
        var addNewDiv   = document.getElementById( comboId + "_NewDiv" );
		try {
        combo.List = list;
        combo.Button = button;
        combo.Text = text;
// Add New 10/30/2006
        combo.Div = div;
        combo.AddNewButton = newButton;
        combo.AddNewDiv = addNewDiv;
	
		combo.style.border = "1px solid #7F9DB9";
        list.Container = combo;
        list.Show = ComboBox_ShowList;
        list.Hide = ComboBox_HideList;
        list.EnableBlur = ComboBox_ListEnableBlur;
        list.DisableBlur = ComboBox_ListDisableBlur;
        list.Select = ComboBox_ListItemSelect;
        list.ClearSelection = ComboBox_ListClearSelection;
        list.KeyAccess = ComboBox_ListKeyAccess;
        list.FireTextChange = ComboBox_ListFireTextChange;
//      list.onchange = null;
        list.onclick = function(e){ this.Select(e); this.ClearSelection(); this.FireTextChange(); };
        list.onkeyup = function(e) { this.KeyAccess(e); };
        list.EnableBlur(null);
        list.style.position = "absolute";
        list.style.zIndex = 200;
	    list.style.display = 'block';
        list.size = ComboBox_GetListSize( list );
        list.IsShowing = true;
        list.Hide();
        text.Container = combo;

        text.TypeDown = ComboBox_TextTypeDown;
        text.KeyAccess = ComboBox_TextKeyAccess;
		text.onfocus = function() { text.onblur = null;};

        text.onkeyup = function(e) { this.KeyAccess(e); this.TypeDown(e); };
        text.style.border = "none";
        text.style.margin = "0px";
        text.style.padding = "0px";
        text.style.width = ( list.offsetWidth ) + "px";
		} catch(f) {}

// Add New 10/30/2006
		try
		{
			button.style.height =	text.offsetHeight;
			button.Container = combo;
			button.Toggle = ComboBox_ToggleList;
			button.onclick = button.Toggle;

			button.onmouseover = function(e) { button.src = '/ig_common/Images/combobox_drop_over.gif';this.Container.List.DisableBlur(e); };
			button.onmouseout = function(e) { button.src = '/ig_common/Images/combobox_drop.gif';this.Container.List.EnableBlur(e); };
			button.onselectstart = function(e){ return false; };		
			var tmp_width = text.style.width.replace('px','');
			if (tmp_width) tmp_width = parseInt(tmp_width);
			div.style.height = combo.offsetHeight;
			div.style.top =  findPosY(text) + 1;
			div.style.display = 'block';
			var bo = button.offsetWidth;

			var tWidth = tmp_width - bo + findPosX(text) + 1;
			div.style.left = tWidth + 'px';
			button.src = '/ig_common/Images/combobox_drop.gif';

			newButton.style.height = '20px';
			newButton.style.width = '17px';
			newButton.Container = combo;
			newButton.onclick = ComboBox_AddNew;
			newButton.style.cursor = 'hand';
			newButton.src = '/ig_common/Images/combobox_addnew.gif';
			if (newButton.alt == "")
			{
				newButton.alt = 'Quick Add';
			}
			addNewDiv.style.height = '20px';
			addNewDiv.style.width = '17px';
			addNewDiv.Container = combo;
			var tmpTop = div.style.top.replace('px','');
			tmpTop = parseInt(tmpTop);
			addNewDiv.style.top =  tmpTop - 3;
			tWidth = tWidth + 17;
			addNewDiv.style.left = tWidth + 'px';
			
		}
		catch (f) { }

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

// Add New 10/30/2006 // remark followings if you want to block edit mode
		try
		{
			var selectOnAddNew = eval(comboId + '_OnAddNewPlus');
		
			if ( selectOnAddNew != null && typeof( selectOnAddNew ) == "function" ) {
				addNewDiv.style.display = 'block';
			}
		}
		catch(f) {}			

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

	}
    

    function ComboBox_InitEvent( e ) {
        if( typeof( e ) == "undefined" && typeof( window.event ) != "undefined" ) e = window.event;
        if( e == null ) e = new Object();
        return e;
    }
    function ComboBox_ListClearSelection() {
		if ( typeof( this.Container.Text.createTextRange ) == "undefined" ) return;
        var rNew = this.Container.Text.createTextRange();
        rNew.moveStart('character', this.Container.Text.value.length) ;
        rNew.select();
    }
    function ComboBox_GetListSize( theList ) {
        ComboBox_EnsureListSize( theList );
        return theList.listSize;
    }
    function ComboBox_EnsureListSize( theList ) {
        if ( typeof( theList.listSize ) == "undefined" ) {
            if( typeof( theList.getAttribute ) != "undefined" ) {
                if( theList.getAttribute( "listSize" ) != null && theList.getAttribute( "listSize" ) != "" ) {
                    theList.listSize = theList.getAttribute( "listSize" );
                    return;
                }
            }
            if( theList.options.length > 0 ) {
                theList.listSize = theList.options.length;
                return;
            }
            theList.listSize = 4;
        }
    }
    function ComboBox_ListKeyAccess(e) { //Make enter/space and escape do the right thing :)
        e = ComboBox_InitEvent( e );

        if( e.keyCode == 13 || e.keyCode == 32 ) {
            this.Select();
            return;
        }
        if( e.keyCode == 27 ) {
            this.Hide();
            this.Container.Text.focus();
            return;
        }
    }
    function ComboBox_TextKeyAccess(e) { //Make alt+arrow expand the list
		e = ComboBox_InitEvent( e );
		if( e.altKey && (e.keyCode == 38 || e.keyCode == 40) ) {
			this.Container.List.Show();
		}
    }


    function ComboBox_TextBlur(e) { // onBlur 10/22/2006
	e = ComboBox_InitEvent( e );
	
	var x = e.clientX;
	var y = e.clientY;
	
	var oW = this.Container.AddNewDiv.offsetWidth;
	var oH = this.Container.AddNewDiv.offsetHeight;

	var oX = findPosX(this.Container.AddNewDiv);
	var oY = findPosY(this.Container.AddNewDiv);

	var oXw = oX + oW;
	var oYh = oY + oH;

		if ( ( x >= oX && x <= oXw) && ( y >= oY && y <= oYh) )
		{

		}
		else
		{
			ComboBox_SimpleAttach(this.Container.List,this)
		}
    }



    function ComboBox_TextTypeDown(e) { //Make the textbox do a type-down on the list

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
// Add New 10/30/2006 // unremark followings if you want to disable edit mode
//this.Container.AddNewDiv.style.display = 'none';
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

	e = ComboBox_InitEvent( e );
	if(e.keyCode == 13)
	{
	ComboBox_SimpleAttach(this.Container.List,this.Container.Text)
	}

// blur ////////////////////////////////////
	if(!this.onblur) {
		this.Blur = ComboBox_TextBlur;
       		this.onblur = function(e) { this.Blur(e); };
	}

	var items = this.Container.List.options;

	if (this.value.toLowerCase() == 'select one')
	{
//		this.value = "";
	}
    
	if( this.value == "" ) 
	{ 	
		this.Container.List.selectedIndex = 0;
		// return;
	}


        var ctrlKeys = Array( 8, 46, 37, 38, 39, 40, 33, 34, 35, 36, 45, 16, 20 );
        for( var i = 0; i < ctrlKeys.length; i++ ) {
            if( e.keyCode == ctrlKeys[i] ) return;
        }

        for( var i = 0; i < items.length; i++ ) {
            var item = items[i];
// Blur 10/22/2006
//            if( item.text.toLowerCase().indexOf( this.value.toLowerCase() ) == 0 && item.text.toLowerCase() != 'select one') {
            if( item.text.toLowerCase().indexOf( this.value.toLowerCase() ) == 0) {
                this.Container.List.selectedIndex = i;
                if ( typeof( this.Container.Text.createTextRange ) != "undefined" ) {
					this.Container.List.Select();
				}

                break;
            }
        }
		if( i >= items.length )
		{
			try
			{
				var selectOnAddNew = eval(this.Container.List.id + '_OnAddNewPlus');
			
				if ( selectOnAddNew != null && typeof( selectOnAddNew ) == "function" ) {
					if( this.Container.AddNewDiv.style.display != 'block' )
					{
						this.Container.AddNewDiv.style.display = 'block';
					}
				}
			}
			catch(f)
			{
				
			}			
		}
    }

    function ComboBox_ListFireTextChange() {
        var textOnChange = this.Container.Text.onchange;
		if ( textOnChange != null && typeof(textOnChange) == "function" ) {
			textOnChange();
		}
    }
    function ComboBox_ListEnableBlur(e) {
        this.onblur = this.Hide;
    }
    function ComboBox_ListDisableBlur(e) {
        this.onblur = null;
    }
    function ComboBox_ListItemSelect(e) {
        if( this.options.length > 0 ) {
            var text = this.Container.Text;
            var oldValue = text.value;
// Modified by Joon on Feb/08/2007 ////////////////////////////////////////////
            var newValue = ""
            if(this.selectedIndex>=0)
            {
                newValue = this.options[ this.selectedIndex ].text;
            }
///////////////////////////////////////////////////////////////////////////////
			if(newValue.toLowerCase() == 'select one')
			{
//				newValue = '';	
			}
            // Modified by Joon on Mar/07/2007 class code remove
            text.value = class_code_remove(newValue);
            
            if ( typeof( text.createTextRange ) != "undefined" ) {
                if (newValue != oldValue) {
                    var rNew = text.createTextRange();
                    rNew.moveStart('character', oldValue.length) ;
                    rNew.select();
                }
				else
				{
                    var rNew = text.createTextRange();
                    rNew.moveStart('character', oldValue.length) ;
                    rNew.select();
				}
            }
        } 
        this.Hide();
        this.Container.Text.focus();
    }

    function ComboBox_ToggleList(e) {
        if( this.Container.List.IsShowing == true ) {
            this.Container.List.Hide();
        } else {
            this.Container.List.Show();
        }
    }

// Add New 10/30/2006
    function ComboBox_AddNew(e) {

		try
		{
			var selectOnAddNew = eval(this.Container.List.id + '_OnAddNewPlus');
		
			if ( selectOnAddNew != null && typeof( selectOnAddNew ) == "function" ) {
					selectOnAddNew(this.Container.Text,this.Container.List,this.Container.AddNewDiv);
			}
		}
		catch(f)
		{
			
		}			
	}

	function oScroll(oSelect,middle){
		try {
			var opt=oSelect.options;
			oSelect.multiple="multiple"	
			for (var i=0;i<opt.length;i++){
				if(opt[i].selected){

					if(( opt.length - i) < middle ) {
						opt[opt.length-1].selected=true;
						opt[opt.length-1].selected=false;				
					} else {
						opt[i+middle].selected=true;
						opt[i+middle].selected=false;								
					}
					oSelect.multiple=""	
					opt[i].selected=false;
					opt[i].selected=true;
					return;
				}
			}
		} catch(f) {}	
	}

    function ComboBox_ShowList(e) {
        if ( !this.IsShowing && !this.disabled ) {
            this.style.width = ( this.Container.offsetWidth ) + "px";
            this.style.top = ( this.Container.offsetHeight + ComboBox_RecursiveOffsetTop(this.Container,true) ) + "px";
            this.style.left = ( ComboBox_RecursiveOffsetLeft(this.Container,true) ) + "px";
			oScroll(this,7);
            ComboBox_SetVisibility(this,true);
            this.focus();
            this.IsShowing = true;
			this.style.zIndex = '-99999';
			this.style.zIndex = '99999';

        }
    }
    function ComboBox_HideList(e) {
        if( this.IsShowing ) {
			ComboBox_SetVisibility(this,false);
            this.IsShowing = false;
        }
    }
    function ComboBox_SetVisibility(theList,isVisible) {
		var isIE = ( typeof( theList.dataSrc ) != "undefined" ); // dataSrc is an IE-only property which is unlikely to be supported elsewhere
		if ( isIE ) {
			if ( isVisible ) {
				theList.style.visibility = "visible";
			} else {
				theList.style.visibility = "hidden";
			}
		} else { 
			if ( isVisible ) {
				theList.style.display = "block";
			} else {
				theList.style.display = "none";
			}
		}
    }
    function ComboBox_RecursiveOffsetTop(thisObject,isFirst) {
		if(thisObject.offsetParent) {
			if ( thisObject.style.position == "absolute" && !isFirst && typeof(document.designMode) != "undefined" ) {
				return 0;
			}
			return (thisObject.offsetTop + ComboBox_RecursiveOffsetTop(thisObject.offsetParent,false));
		} else {
			return thisObject.offsetTop;
		}
	}
    function ComboBox_RecursiveOffsetLeft(thisObject,isFirst) {
		if(thisObject.offsetParent) {
			if ( thisObject.style.position == "absolute" && !isFirst && typeof(document.designMode) != "undefined" ) {
				return 0;
			}
			return (thisObject.offsetLeft + ComboBox_RecursiveOffsetLeft(thisObject.offsetParent,false));
		} else {
			return thisObject.offsetLeft;
		}
	}
	function ComboBox_SimpleAttach(selectElement,textElement) {
        // Modifed by Joon on Dec-11-2006
        if(selectElement.options.selectedIndex >= 0)
        {
		    // Added by Joon on Mar/07/2007 class code remove
		    var textStr = selectElement.options[ selectElement.options.selectedIndex ].text;
		    textElement.value = class_code_remove(textStr);
		    
		    if(textElement.value) {
			    if (textElement.value.toLowerCase() == 'select one')
			    {
//                    textElement.value = "";
			    }	
		    }

		    var textOnChange = textElement.onchange;
		    if ( textOnChange != null && typeof( textOnChange ) == "function" ) {
			    textOnChange();
		    }
		    try
		    {
			    var selectOnChange = eval(selectElement.id + '_OnChangePlus');
    		
			    if ( selectOnChange != null && typeof( selectOnChange ) == "function" ) {
				    selectOnChange(selectElement,textElement,selectElement.options.selectedIndex);
			    }
		    }
		    catch(f)
		    {
    			
		    }
		}
	}

if ( typeof( window.addEventListener ) != "undefined" ) {
	window.addEventListener("load", ComboBox_Init, false);
} else if ( typeof( window.attachEvent ) != "undefined" ) {
	window.attachEvent("onload", ComboBox_Init);
	window.attachEvent("onresize", ComboBox_Position);
	window.attachEvent("onload", ComboBox_Init);

} else {
	ComboBox_Init();
}

function ComboBox_Position() {
	for( var i = 0; i < ComboBoxes.length; i++ ) {
		Button_Position( ComboBoxes[i] );
	}
}

function Button_Position( comboId ) {

        var combo  = document.getElementById( comboId + "_Container" );
        var button = document.getElementById( comboId + "_Button" );
        var text   = document.getElementById( comboId + "_Text" );
        var div   = document.getElementById( comboId + "_Div" );
// Add New 10/30/2006
        var newButton = document.getElementById( comboId + "_AddNewButton" );
        var addNewDiv   = document.getElementById( comboId + "_NewDiv" );
        
// Add New 10/30/2006
		try
		{

	    button.style.height =	text.offsetHeight;
	    var tmp_width = text.style.width.replace('px','');
	    if (tmp_width) tmp_width = parseInt(tmp_width);
	    div.style.height = combo.offsetHeight;
		div.style.top =  findPosY(text) + 1;
	    div.style.display = 'block';
        var bo = button.offsetWidth;
        var tWidth = tmp_width - bo + findPosX(text) + 1;
	    div.style.left = tWidth + 'px';

		newButton.style.height = '20px';
	    addNewDiv.style.height = '20px';
		var tmpTop = div.style.top.replace('px','');
		tmpTop = parseInt(tmpTop);
		addNewDiv.style.top =  tmpTop - 3;
		tWidth = tWidth + 17;
		addNewDiv.style.left = tWidth + 'px';
		}
		catch (f) { }

}

function ajust_changed_list(popAddClient,oSelect,oDiv,oText)
{

	// Add New 10/30/2006 // unremark followings if you want to disable edit mode.
	///////////////////////////////////// 	
	//	oDiv.style.display = 'none'; 
	/////////////////////////////////////	

	while(popAddClient.indexOf("^^^") != -1) { popAddClient = popAddClient.replace('^^^','\n');	}		
	var startPos = popAddClient.indexOf("-");
	var sName = popAddClient.substring(startPos+1,popAddClient.indexOf("\n"));
	var items = oSelect.options;

	for( var i = 0; i < items.length; i++ ) {
		var item = items[i];
		if( item.text.toLowerCase() == sName.toLowerCase() ) {
			oSelect.selectedIndex = i;
			item.value = popAddClient;
			break;
		}
	}
	
	if ( i >= items.length )
	{
		var oOption = document.createElement("OPTION");
		oSelect.options.add(oOption,1);
		oOption.innerText = sName;
		oOption.value = popAddClient;		
		oSelect.selectedIndex = 1;
	}

	oText.value = sName;
}
function ajust_changed_list_new(popAddClient,oSelect,oDiv,oText)
{
	while(popAddClient.indexOf("^^^") != -1) { popAddClient = popAddClient.replace('^^^','\n');	}		
	var startPos = popAddClient.indexOf("-");
	var sOrg = popAddClient.substring(0,startPos);
	var startPos2 = popAddClient.indexOf("\n");
	sName = popAddClient.substring(startPos+1,startPos2);

	var items = oSelect.options;
	for( var i = 0; i < items.length; i++ ) {
		var item = items[i];
		if( item.value == sOrg ) {
			oSelect.selectedIndex = i;
			item.value = sOrg;
			item.text = sName;
			break;
		}
	}
	if ( i >= items.length )
	{
		var oOption = document.createElement("OPTION");
		oSelect.options.add(oOption,1);
		oOption.innerText = sName;
		oOption.value = sOrg;		
		oSelect.selectedIndex = 1;
	}
    
	oText.value = class_code_remove(sName);
}
function s_trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }

// Added by Joon on Mar/07/2007 class code remove
function class_code_remove(strArg)
{
    var tempArray = new Array();
    tempArray = strArg.split("[");
	        
    if(tempArray.length >= 2)
    {
        strArg = tempArray[0];
    }
	if (s_trim(strArg.toLowerCase()) == 'select one' ) {
//		strArg = '';	
	}
    return strArg;
}

//-->
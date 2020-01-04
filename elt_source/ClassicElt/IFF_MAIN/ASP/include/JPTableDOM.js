// JScript File
// Created by Joon on Oct,9 2007


    // Table with no style, if any style is applied it will be cleared when this function is used
    // tableID has to match with caller's parameter argument.
    function AddNewTableRow(templateID,newID){
        var templateTRObj = document.getElementById(templateID);
        var newTRObj = document.getElementById(newID);
        var tableObj = findParentObjectByTag(newTRObj,"TABLE");
        
        var newRow = tableObj.insertRow(newTRObj.rowIndex);
        copyTableRow(templateTRObj,newRow);
    }
    
    // Assumed: deleting-action object is inside TR to be deleted
    function DeleteTableRow(thisObj){
        var tableObj = findParentObjectByTag(thisObj,"TABLE");
        var trObj = findParentObjectByTag(thisObj,"TR");

        var rowID = trObj.rowIndex;
        tableObj.deleteRow(rowID);
    }
    
    // Assumed: moving-action object is inside TR to be moved
    // rowIndex = 1 if header doesn't exist
    function tableRowMoveUp(thisObj){
        var tableObj = findParentObjectByTag(thisObj,"TABLE");
        var trObj = findParentObjectByTag(thisObj,"TR");
        
        // head count
        var tHeadCount = findChildObjectByTag(tableObj,"THEAD").childNodes.length;
        var rowID = trObj.rowIndex;
        
        if(rowID-tHeadCount>1){
            var newRow = tableObj.insertRow(rowID-1);
            copyTableRow(tableObj.rows[rowID+1],newRow);
            tableObj.deleteRow(rowID+1);
        }
	}
	
	// Assumed: moving-action object is inside TR to be moved
    function tableRowMoveDown(thisObj){
        var tableObj = findParentObjectByTag(thisObj,"TABLE");
        var trObj = findParentObjectByTag(thisObj,"TR");
        
        // foot count
        var tfootCount = findChildObjectByTag(tableObj,"TFOOT").childNodes.length;
        var rowID = trObj.rowIndex;
        if(rowID+tfootCount+2 < tableObj.rows.length){
            var newRow = tableObj.insertRow(rowID+2);
            copyTableRow(tableObj.rows[rowID],newRow);
            tableObj.deleteRow(rowID);
        }
	}
	
	// Recursively calls itself until object is null or object finds match
	function findParentObjectByTag(inputObj,arg){
	    var tmpObj = inputObj;
	    if(tmpObj.tagName == null){
	        tmpObj = null;
	    }
	    else if(tmpObj.tagName == arg){
	    }
	    else{
	        tmpObj = findParentObjectByTag(tmpObj.parentNode,arg);
	    }
	    return tmpObj;
	}
	
	function copyTableRow(source,target){
	    for(var i=0; i<source.cells.length; i++){
	        var newCell = target.insertCell(i);
	        newCell.innerHTML = source.cells[i].innerHTML;
	    }
	}
	
	// Recursively calls itself until object is null or object finds match
	function findChildObjectByTag(inputObj,arg){
	    var tmpObj = null;
	    if(inputObj.tagName == arg){
	        tmpObj = inputObj;
	    }
	    else{
	        if(inputObj.childNodes != null && argObj.childNodes.length > 0){
	            for(var i=0; i<inputObj.childNodes.length; i++){
	                tmpObj = findChildObjectByTag(inputObj.childNodes[i],arg);
	                if(tmpObj != null){
	                    break;
	                }
	            }
	        }
	    }
	    return tmpObj;
	}
	
    function makeAllReadOnly(argObj){
    
        try{ argObj.alt = "Read only"; }catch(e){}
        try{ argObj.style.cursor = "not-allowed"; }catch(e){}
        try{ argObj.readOnly = true; }catch(e){}
        try{ argObj.onmouseover = ""; }catch(e){}
        try{ argObj.onmouseout = ""; }catch(e){}
        try{ argObj.onmousedown = ""; }catch(e){}
        try{ argObj.onmouseup = ""; }catch(e){}
        try{ argObj.onmousemove = ""; }catch(e){}
        try{ 
            var tmpVal = argObj.selectedIndex; 
            argObj.onchange = function(){this.selectedIndex=tmpVal; return false;}; 
        }catch(e){}
        try{ argObj.onclick = function(){return false;}; }catch(e){}
        try{ argObj.onfocus = ""; }catch(e){}
        try{ argObj.ondblclick = ""; }catch(e){}
        try{ argObj.onkeypress = ""; }catch(e){}
        try{ argObj.onkeydown = ""; }catch(e){}
        try{ argObj.onkeyup = ""; }catch(e){}
        try{ argObj.href = "javascript:;"; }catch(e){}

        if(argObj.childNodes != null && argObj.childNodes.length > 0){
            for(var i=0; i<argObj.childNodes.length; i++){
                makeAllReadOnly(argObj.childNodes[i]);
            }
        }
        return;
    }
    
    function makeAllDiabled(argObj){
        
        try{ argObj.disabled = true; }catch(e){}
        try{ argObj.checked = false; }catch(e){} 
        
        if(argObj.childNodes != null && argObj.childNodes.length > 0){
            for(var i=0; i<argObj.childNodes.length; i++){
                makeAllDiabled(argObj.childNodes[i]);
            }
        }
        return;
    }
    
    function makeAllEnabled(argObj){
    
        try{ argObj.disabled = false; }catch(e){}
        try{ argObj.checked = true; }catch(e){} 
        
        if(argObj.childNodes != null && argObj.childNodes.length > 0){
            for(var i=0; i<argObj.childNodes.length; i++){
                makeAllEnabled(argObj.childNodes[i]);
            }
        }
        return;
    }
    
    function makeAllReadOnlyStyle(argObj){
    
        if (argObj.title == "skip")
        {
            return;
        }
        try{ argObj.alt = "Read only"; }catch(e){}
        try{ if(argObj.tagName.toUpperCase() == "INPUT"){ argObj.style.backgroundColor = "#cdcdcd"; } }catch(e){}
        try{ argObj.readOnly = true; }catch(e){}
        try{ argObj.onmouseover = ""; }catch(e){}
        try{ argObj.onmouseout = ""; }catch(e){}
        try{ argObj.onmousedown = ""; }catch(e){}
        try{ argObj.onmouseup = ""; }catch(e){}
        try{ argObj.onmousemove = ""; }catch(e){}
        try{ 
            var tmpVal = argObj.selectedIndex; 
            argObj.onchange = function(){this.selectedIndex=tmpVal; return false;}; 
        }catch(e){}
        try{ argObj.onclick = function(){return false;}; }catch(e){}
        try{ argObj.onfocus = ""; }catch(e){}
        try{ argObj.ondblclick = ""; }catch(e){}
        try{ argObj.onkeypress = ""; }catch(e){}
        try{ argObj.onkeydown = ""; }catch(e){}
        try{ argObj.onkeyup = ""; }catch(e){}
        try{ argObj.href = "javascript:;"; }catch(e){}

        if(argObj.childNodes != null && argObj.childNodes.length > 0){
            for(var i=0; i<argObj.childNodes.length; i++){
                makeAllReadOnlyStyle(argObj.childNodes[i]);
            }
        }
        return;
    }
    
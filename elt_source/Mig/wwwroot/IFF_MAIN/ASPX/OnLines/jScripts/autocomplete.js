
/***********************************************************************************
 In order to use this dropdown
 1) add style rule at the head as below 
     <style type="text/css">
    .mouseOut{background:#cccff; color:#000000;}
    .mouseOver{background:#60647d; color:#000000;}
     </style>
 2) create a hidden field and set the value from server in a string consists 
    of all the values delimited by '^'
 3) place  a input textbox and the dropdown button image icon, 
    /Images/dd_box.gif in a row
 4) pace a hidden filed in the row right below the textbox and set the css 
    class to be 'searchDisp'
 5) set onkeyup of textbox to LoadResults(keyword,displyDivId,hiddenField,textboxId) 
 6) set onclick of the button image to be LoadAll(displayDivId,hiddenField,textboxId)
 7) set onmousedown="ddPressed(this)"  onmouseup ="ddUp(this)" for button image
 8) call BodyLoad(iPath) with the relative path to button img (only the path) at 
    onload of the page
***********************************************************************************/

var curValues =new Array();
var imgPath;
function hasClass(obj) {
   var result = false;
   if (obj.getAttributeNode("class") != null) {
       result = obj.getAttributeNode("class").value;
   }
   return result;
}  

function BodyLoad(iPath){

    imgPath=iPath    
    var divs = document.getElementsByTagName('div');
    if (divs.length==0) { return; } 
        
    for (var k = 0; k < divs.length; k++) {        
        if (hasClass(divs[k])) {           
            if (divs[k].getAttributeNode('class').value.indexOf('searchDisp')!=-1) {
                 HideDiv(divs[k].id);                                      
            }
         }
     }  
}

function ShowDiv(divid){

	if(document.layers)document.layers[divid].visibility="show";
	else document.getElementById(divid).style.visibility="visible";
}

function HideDiv(divid){

	if(document.layers)document.layers[divid].visibility="hide";
	else document.getElementById(divid).style.visibility="hidden";
}

function ClearResults(divId){

     var resultsdiv = document.getElementById(divId);
	 var counter = resultsdiv.childNodes.length;
	
	 for(var i= counter -1; i >=0;i--){ 
	 		 resultsdiv.removeChild(resultsdiv.childNodes[i]);
	 }
}

function LoadResults(searchterm, divId, hiddenId, inputId){	
	if(searchterm.length==0){
		ClearResults(divId);
		HideDiv(divId);
	}else{
	 var results = SearchKeywordFromHidden(searchterm,hiddenId);// check if it is null
	
	 if(results!=null){
	    LoadResultsCallback(results,divId,inputId);	 
	 }
	}	
}

function ReplaceInput(tablecell,inputId,divId){
	var inputbox = document.getElementById(inputId);	
	inputbox.value=tablecell.firstChild.nodeValue;//<--this is ?	
	ClearResults(divId);	
	HideDiv(divId);
}

function LoadAll(divId,hiddenId,inputId){

    var CurValues=new Array();
    var str = document.getElementById(hiddenId).value;    
    var s_split = str.split("^");   
    for(i=0; i<s_split.length; i++){        
               
        curValues[i]=s_split[i];// check if index starts from 0
    }   
    
    if(curValues!=null){
	    LoadResultsCallback(curValues,divId,inputId);	 
	 }      
}

function LoadResultsCallback(result, divId, inputId){
    
     ShowDiv(divId);     
     ClearResults(divId);          
     var count= result.length; 
           
     var divResults= document.getElementById(divId);
     
     var tbleTable = document.createElement("table");
     var tablebody= document.createElement("tbody");
     
     var tablerow, tablecell, tablenode;
      
     for(var i=0; i<count;i++){
         var currentText = result[i];        
         	 
	     tablerow= document.createElement("tr");
	     tablecell=document.createElement("td");
    	 
	     tablecell.onmouseover= function(){ this.className='mouseOver';}
	     tablecell.onmouseout= function(){ this.className='mouseOut';}
    	
	     tablecell.setAttribute("border","0");	     
	     
	     tablecell.onclick=function(){ 
	        ReplaceInput(this,inputId,divId);
	     }
	     
	     tablenode=document.createTextNode(currentText);    	 
	     tablecell.appendChild(tablenode);
	     tablerow.appendChild(tablecell);
	     tablebody.appendChild(tablerow);
     }
     tbleTable.appendChild(tablebody);
     divResults.appendChild(tbleTable);     
 }
 
 
 
 function SearchKeywordFromHidden(keyword,hiddenId){ 
    
    var CurValues=new Array();
    var str = document.getElementById(hiddenId).value;    
    var s_split = str.split("^");   
    for(i=0; i<s_split.length; i++){        
               
        curValues[i]=s_split[i];// check if index starts from 0
    }   
     
     var capK=keyword.toUpperCase();
     var capO;
     var anOption ="";
     var result=new Array(); 
     var rIndex=0; 
     
     for(var i=0;i<curValues.length;i++){                  
        anOption=curValues[i]; 
        capO=anOption.toUpperCase();  
        capO=capO.substr(0,keyword.length);        
                      
        if(capO.match(capK)!=null){      
            result[rIndex++]=anOption;          
        }
     }
    return result;
 }
 
 function ddPressed(btnImg){
     var button=btnImg;
     btnImg.src=imgPath+'dd_box_pressed.gif' 
 }
 
 function ddUp(btnImg){
     var button=btnImg;
     btnImg.src=imgPath+'dd_box.gif' 
 }
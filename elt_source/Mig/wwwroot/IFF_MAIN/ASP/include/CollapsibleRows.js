


var W3CDOM = (document.createElement && document.getElementsByTagName);


function expanded(id){
   var theImage = document.getElementById(id);
   theImage.src="../Images/Collapse.gif";    
   
}

function hasClass(obj) {
   var result = false;
   if (obj.getAttributeNode("class") != null) {
       result = obj.getAttributeNode("class").value;
   }
   return result;
}  

function toggleVisibility(id) {

if (!W3CDOM) return;
    var tables = document.getElementsByTagName('table');
    if (tables.length==0) { return; }
    
    var theImage = document.getElementById(id);
    
    if(theImage!=null){  
            
            
            if(theImage.src.indexOf("Images/Collapse.gif")>=0){
                
                theImage.src="../Images/Expand.gif";    
                        
            }
            else {
                 theImage.src="../Images/Collapse.gif"; 
                
                       
            }
      }
   
    
    for (var k = 0; k < tables.length; k++) { 
           
        if (hasClass(tables[k])) {           
            if (tables[k].getAttributeNode('class').value.indexOf('collapsible')!=-1) {                             
                var tbodies = tables[k].getElementsByTagName('tbody');                             
                for (var h = 0; h < tbodies.length; h++) {     
                    var trs = tbodies[h].getElementsByTagName('tr'); 
                                      
                    for (var i = 0; i < trs.length; i++) {                                          
                       var theRowName = "row_" + i + "_element";                             
                       var theRow = document.getElementById(theRowName);  
                         
                        if (theRow != null)
                        {
                        
                            if (theRow.style.display=="none") {
                                theRow.style.display = "";
                               // theImage.src = "../Images/Collapse.gif";
                            } else {
                                theRow.style.display = "none";
                               // theImage.src = "../Images/Expand.gif";
                            }
                        }                                                  
                    }
                 }
             }
         }
     }   
    
}

function initCollapsingRows()
{
	if (!W3CDOM) return;
    var tables = document.getElementsByTagName('table');
    if (tables.length==0) { return; } 
        
    for (var k = 0; k < tables.length; k++) {        
        if (hasClass(tables[k])) {           
            if (tables[k].getAttributeNode('class').value.indexOf('collapsible')!=-1) {                             
                var tbodies = tables[k].getElementsByTagName('tbody');   
                                          
                for (var h = 0; h < tbodies.length; h++) {     
                    var trs = tbodies[h].getElementsByTagName('tr'); 
                                      
                    for (var i = 0; i < trs.length; i++) {                                          
                            var theRowName = "row_" + i + "_element";                           
                            trs[i].id = theRowName;  
                           // trs[i].style.display = "none";
                          
                    }
                 }
             }
         }
     }    
       
}





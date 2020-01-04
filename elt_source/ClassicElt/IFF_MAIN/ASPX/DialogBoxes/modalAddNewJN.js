 
  
  var rt=""; 
  var style="font-size:10px;dialogWidth:410px;dialogHeight:123px; help:no; status:no; scroll:no ;center:yes"; 
   
  
  
  function openAddNewModal(obj, url, returnID){
        
        var childs=obj.childNodes;  
                                
        for(i=0;i<childs.length;i++){  
                  
            if(childs[i].selected&&childs[i].value=='addnew'){                                            
                 var target=document.getElementById(returnID);                
                 var newWin=window.open(url, "name", "height=100,width=400,toolbar=no,status=no,scrollbars=n0,resizable=no");      
	            
	            
	             //var contents= target.value=window.showModalDialog(url,'',style); 	         
	            /*
	             var ar=contents.split("^");
    	         	
	             if(ar[0]!='cancel'&& ar[0]!=""&&ar[0]!='redirect'){        
	                addNewListItem(obj,ar[0],ar[1]);
	                obj.options[obj.options.length-1].selected=true;	          	            
	             } */                                  
	         }
       }      
  }
    
 function addNewListItem(obj, txt, val){           	                   
           obj.options[obj.options.length-1]=new Option(txt,val ); 
 }


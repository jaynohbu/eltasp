 
  
  var rt=""; 
  var style="font-size:10px;dialogWidth:410px;dialogHeight:123px; help:no; status:no; scroll:no ;center:yes"; 
   
  
  
  function openAddNewModal(obj, url, returnID){       
        var childs=obj.childNodes;                          
        for(i=0;i<childs.length;i++){            
            if(childs[i].selected&&childs[i].value=='addnew'){ 
                                           
                 var target=document.getElementById(returnID); 
                               
	             var contents= target.value=window.showModalDialog(url,'',style); 	         
	             var ar=contents.split("^");
    	         	
	             if(ar[0]!='cancel'&& ar[0]!=""&&ar[0]!='redirect'){        
	                addNewListItem(obj,ar[0],ar[1]);
	                obj.options[obj.options.length-1].selected=true;	          	            
	             }                                   
	         }
            }      
  }
    
 function addNewListItem(obj, txt, val){           	                   
           obj.options[obj.options.length-1]=new Option(txt,val ); 
 }

 function fbtnFullInfo(parm)
 {    
    //parent.fShowModal.hReturnValue.value = 'redirect^companyconfigcreate.aspx?newDBA='+parm;
     window.open("/IFF_MAIN/ASPX/OnLines/CompanyConfig/companyconfigcreate.aspx?newDBA="+ parm);       
     top.window.close();
        //,"+
          //  "'client configuration','width=100%,height=100%,toolbar=yes, location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes," + "resizable=yes');window.top.close();"  
 }
function divOverlap(a,b,top,left){ 
	
	var div1=document.getElementById(a);
	var div2=document.getElementById(b);
	
	div1.style.top=top;
	div1.style.left=left;
	
	div2.style.top=top;
	div2.style.lett=left;
}

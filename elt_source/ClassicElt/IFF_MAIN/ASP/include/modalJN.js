 
  
  var rt="";  
  function setReturnFromDiag(id){
      var target=document.getElementById(id);	  
	  target.value=rt;
  }
 
  function callModal(url,style){
    rt = window.showModalDialog(url,'',style); 
  }



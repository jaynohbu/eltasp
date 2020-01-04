<script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
<script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>

<link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
<style>
  
dialog {
  position: absolute;
  left: 0px;
  right: 0px;
  width: -webkit-fit-content;
  height: -webkit-fit-content;
  margin: auto;
  border: solid;
  border-image-source: initial;
  border-image-slice: initial;
  border-image-width: initial;
  border-image-outset: initial;
  border-image-repeat: initial;
  padding: 1em;
  background: white;
  color: black;
  top:80px;
}
.jped tr{
vertical-align:top;
height:20px!important;
}
</style>
<script>
$.browser.chrome = $.browser.webkit && !!window.chrome;
$.browser.safari = $.browser.webkit && !window.chrome;

function showModalDialogJN(url, arg, opt, ModalHandle) {

    url = url || ''; //URL of a dialog
    arg = arg || null; //arguments to a dialog
    opt = opt || 'dialogWidth:300px;dialogHeight:200px'; //options: dialogTop;dialogLeft;dialogWidth;dialogHeight or CSS styles
       
    var dialog = document.body.appendChild(document.createElement('dialog'));
    dialog.setAttribute('style', opt.replace(/dialog/gi, ''));
    dialog.innerHTML = '<a href="#" id="dialog-close" style="position: absolute; top: 0; right: 4px; font-size: 20px; color: #000; text-decoration: none; outline: none;">&times;</a><iframe id="dialog-body" src="' + url + '" style="border: 0; width: 100%; height: 100%;"></iframe>';
    document.getElementById('dialog-body').contentWindow.dialogArguments = arg;
    document.getElementById('dialog-close').addEventListener('click', function(e) {
    e.preventDefault();
    dialog.close();
    });
    dialog.showModal();
    ModalHandle.Modal = dialog;
        
    dialog.addEventListener('close', function() {
        var returnValue = document.getElementById('dialog-body').contentWindow.returnValue;
        document.body.removeChild(dialog);            
        ModalHandle.CallBack(returnValue);
           
    });
    throw 'Execution stopped until showModalDialog is closed';
}
var ModalHandle = {
      Modal: null,
      CallBack:null
  } ;
      
 
  
  $(function () {
    if ($(".date") != null) {
    $(".date").keyup(function (e) {
    var currentValue = $(e.target).val();
    var newValue = autocompleteMMDDYYYYDateFormat(currentValue);
    if (newValue != currentValue) {
    $(e.target).val(newValue);
    }
    });
    }
    if ($(".maxsize") != null) {
    $(".maxsize").keyup(function (e) {
    var currentValue = $(e.target).val();
    var size = $(e.target).attr("size");
    var newValue = currentValue.substring(0, size);
    if (newValue != currentValue) {
    alert('max size of input text is ' + size);
    $(e.target).val(newValue);
    }
    });
    }
  });

</script>
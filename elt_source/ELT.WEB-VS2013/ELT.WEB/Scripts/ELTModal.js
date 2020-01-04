
function ShowModalPageIframe(Url) {
   
    $("#ModalPlaceHolder").remove();
    var content = "<div id='ModalPlaceHolder'></div>";
    $('body').append(content);
    $("#ModalPlaceHolder").append($("<iframe frameborder='0' scrolling='no'  id='modalframe' onload='autoResize(''modalframe'');'   scrolling='no' style='width:100%' />").attr("src", Url)).dialog(
    {
        autoOpen: true,
        modal: true,
        resizable: "auto",
        width: "auto",
        height: "auto",
        minHeight: "auto"
    }
  );
}







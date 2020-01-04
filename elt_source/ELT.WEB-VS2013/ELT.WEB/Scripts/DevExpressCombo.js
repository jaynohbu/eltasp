

function LoadInitialSetInDevExpressCombo() {
  
    $(".ComboBoxDiv").each(
                 function () {
                     var ComboBoxDiv = this;                    
                     var FirstTextObject = $(ComboBoxDiv).find(".dxeListBoxItemRow").get(1);
                     $(ComboBoxDiv).attr("initval", $(FirstTextObject).text());
                     //alert($(FirstTextObject).text());
                     var ComboBox = $(ComboBoxDiv).find(".dxeEditArea").get(0);

                     $(ComboBoxDiv).find(".dxEditors_edtDropDown").click(function (event) {
                         $(ComboBox).val($(ComboBoxDiv).attr("initval"));
                         return aspxDDDropDown($(ComboBox).attr('name'), event);
                     });

                 });
}
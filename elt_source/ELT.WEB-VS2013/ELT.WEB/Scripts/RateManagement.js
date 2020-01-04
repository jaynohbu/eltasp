
    function AlertValidation(Msg) {
        alert(Msg);
       
    }
    function GetView() {
       
    $("#IsInit").val("Init");
    $("#h_rate_type").val($("#RateTypes").val());
    $("#CustomerAccount").val($("#CustomerID").val());
    $("#formTable").submit();
}

function GetViewFromRedirect(CustomerID) {
    //ShouuldSave
    $("#IsInit").val("Init");
    $("#h_rate_type").val(4);
    $("#CustomerAccount").val(CustomerID);
    $("#formTable").submit();
}


function AddCarrier(id) {
    $("#ActionParam").val("AddCarrier");
    $("#AddCarrierRouteID").val(id);
    $("#formTable").submit();
}

function DeleteCarrier(routeid, id) {
       
    if (confirm("Would you like to delete this item?")) {
        $("#ActionParam").val("DeleteCarrier");
        $("#DeleteCarrierRouteID").val(routeid);
        $("#DeleteCarrierID").val(id);
        $("#formTable").submit();
    }
}
function FlipAddRouteButton() {
        
    $('#spnAddRoute').html("Cancel");
    $('#btnAddRoute').unbind("click");
    $('#btnAddRoute').click(function () { CancelAddRoute(); });
}

function CancelAddRoute() {
      
    $("#ActionParam").val("CancelAddRoute");       
    $("#formTable").submit();

}
function SaveAll() {
    $("#ActionParam").val("SaveAll");
    $("#formTable").submit();
}
function AddRoute() {
    $('#btnAddRoute').attr("disabled", "disabled");
    $("#ActionParam").val("AddRoute");
    $("#formTable").submit();
}
function SaveRoute(id){
    var thead = $("#th_" + id);
    var customer = $(thead).find(".ColHeaderDropDownCustomer");
    if (customer.length == 1) {
        if (customer.find(".RateHeaderColValue").val() == "") {
            alert('Please select a customer!');
            return;
        }
    }
    var agent = $(thead).find(".ColHeaderDropDownAgent");
    if (agent.length == 1) {
        if (agent.find(".RateHeaderColValue").val() == "") {
            alert('Please select an agent!');
            return;
        }
    }
    $("#ActionParam").val("SaveRoute");      
    $("#formTable").submit();
}
function DeleteRoute() {
    $("#ActionParam").val("DeleteRoute");
    $("#DeleteRouteID").val("DeleteRoute");        
    $("#formTable").submit();
}
function ShowDropDown(obj, type) {
      
    if (type == 'Customer') {
        if ($(obj).hasClass("ComboBoxJnoh") == false) {
            $(obj).addClass("ComboBoxJnoh");
            $($(obj).children(".RateColText")).ComboBoxJnoh({ Width: "200px", TypeOfOrg: "All", ValueField: $(obj).children(".RateColValue").get(0), CallBack: function () { HideDropDown(obj, $(obj).find(".RateColText").clone()), type } });
        }
    } else if (type == 'Agent') {
        if ($(obj).hasClass("ComboBoxJnoh") == false) {
            $(obj).addClass("ComboBoxJnoh");
            $($(obj).children(".RateColText")).ComboBoxJnoh({ Width: "200px", TypeOfOrg: "Agent", ValueField: $(obj).children(".RateColValue").get(0), CallBack: function () { HideDropDown(obj, $(obj).find(".RateColText").clone()), type } });
        }
    } else if (type == 'Carrier') {
        var dropdown = $(obj).find(".RateDropHidden");
        var textBox = $(obj).find(".RateColText");
        textBox.hide();
        if (dropdown.css("display") == 'none') {
            dropdown.click(StopPropagation);
            dropdown.show();
        }

    } else if (type == 'Port') {
        var dropdown = $(obj).find(".RateDropHidden");
        var textBox = $(obj).find(".RateColValue");
        textBox.hide();
        if (dropdown.css("display") == 'none') {
            dropdown.click(StopPropagation);
            dropdown.show();
        }
    }

    //RateDropVisible
    return true;

}
function StopPropagation(e) {
      
    // e.preventDefault();
    e.stopPropagation();
}
function HideDropDown(obj, clone, type) {
       
    if (type == 'Customer') {
        
        $(obj).children().remove();
        $(obj).append(clone);
            
        $(obj).removeClass("ComboBoxJnoh");

    } else if (type == 'Agent') {
          
        $(obj).children().remove();
        $(obj).append(clone);
        
        $(obj).removeClass("ComboBoxJnoh");

    } else if (type == 'Carrier') {
           
        var dropdown = $(obj).find(".RateDropHidden");          
        var textBox = $(obj).find(".RateColText");          
        textBox.val(dropdown.find("option:selected" ).text());
        textBox.show();
        dropdown.hide();
          
    } else if (type == 'Port') {

        var dropdown = $(obj).find(".RateDropHidden");
        var textBox = $(obj).find(".RateColValue");
        textBox.val(dropdown.find("option:selected").text());
        textBox.show();
        dropdown.hide();
    }          
    return true;        
}
function ShowColHeaderEdit(obj) {
   
    obj_parent = $(obj).parent();
    obj_parent_parent = $(obj).parent().parent();
  
    if (obj_parent_parent.children('.RateHeaderColLabel').first().attr("id") == obj_parent.attr("id")) {

        var Header = $(obj_parent).find(".ColHeaderEdit");
        Header.show();
        var TextBox = $(obj_parent).find(".RateHeaderColText");
        TextBox.hide();
        $(Header).find(".ColHeaderEditBegin").val("1");
    } else {
        var Header = $(obj_parent).find(".ColHeaderEdit");
        Header.show();
        var TextBox = $(obj_parent).find(".RateHeaderColText");
        TextBox.hide();
      
    }
   
   
}



function AddColHead(obj) {

    obj = $(obj).parent().parent().parent().parent().parent().parent();
    var prev_obj = $(obj).prev();
    var next_obj = $(obj).next();
    var ColHeaderEditBegin = $(obj).find(".ColHeaderEditBegin");
    var ColHeaderEditEnd = $(obj).find(".ColHeaderEditEnd");
    var prev_exist = false;
    var next_exist = false;
    var prev_end_val = null;
    var next_begin_val = null;
    if (prev_obj.find(".ColHeaderEditEnd").length == 1) {
        prev_exist = true;
        if (prev_obj.find(".ColHeaderEditEnd").val() != undefined && prev_obj.find(".ColHeaderEditEnd").val() != "") {
            prev_end_val = parseFloat(prev_obj.find(".ColHeaderEditEnd").val());
            if (prev_end_val < 0) {
                alert("Pleae use positive value for the range!");
                prev_end_val = null;
            }
        }
    }
    if (next_obj.find(".ColHeaderEditBegin").length == 1) {
        next_exist = true;

        if (next_obj.find(".ColHeaderEditBegin").val() != undefined && next_obj.find(".ColHeaderEditBegin").val() != "") {
            next_begin_val = parseFloat(next_obj.find(".ColHeaderEditBegin").val());
            if (next_begin_val < 0) {
                alert("Pleae use positive value for the range!");
                next_begin_val = null;
            }
        }
    }

    function HideEditor() {
        $(obj).find(".RateHeaderColText").show();
        $(obj).find(".ColHeaderEdit").hide();
    }
    function ShowEditor() {
        $(obj).find(".RateHeaderColText").hide();
        $(obj).find(".ColHeaderEdit").show();
    }
    function SetValueAndText() {
        $(obj).find(".RateHeaderColText").val(ColHeaderEditBegin.val() + "~" + ColHeaderEditEnd.val());
        $(obj).find(".RateHeaderColValue").val(ColHeaderEditBegin.val());
    }

    function ValidateBegin() {
           
        //check begin is numeric
        if (isNaN(ColHeaderEditBegin.val())) {
            alert("Please input a number for the Weight Break(s)!");
            ColHeaderEditBegin.val("");
            return;
        }
        //check if end of the previous one exist and the begin is one more than the previous end
        if (prev_exist) {
            if (prev_end_val == null) {
                alert("Please complete preivious range first!");
                return;
            }              
            if (parseFloat(ColHeaderEditBegin.val()) != prev_end_val + 1) {
                alert("The begin should one more than previous end!");
                ColHeaderEditBegin.val(prev_end_val + 1);
                return;
            }
        }
        SetValueAndText();
        // HideEditor();
        return;
    }
    function ValidateEnd() {
        if (ColHeaderEditBegin.val() == undefined || ColHeaderEditBegin.val() == "") {

            alert("Please complete  weight break being first!");
            return;
        }
            
            
        //check end  is numeric
        if (isNaN(ColHeaderEditEnd.val())) {
            alert("Please input a number for the Weight Break(s)!");
            ColHeaderEditEnd.val("");
            return;
        }
        //check if begin of the next one exist and the end of this is one less than prev
        if (next_exist) {
            if (next_begin_val != null) {
                if (parseFloat(ColHeaderEditEnd.val()) != next_begin_val - 1) {
                    alert("The end should one less than previous end!");
                    ColHeaderEditEnd.val(next_begin_val - 1);
                    return;
                }
            }
        }
            
           
        SetValueAndText();
        HideEditor();
        return;
    }

    function ValidateBothEnds() {
        //check both are numeric
        if (isNaN(ColHeaderEditBegin.val()) || isNaN(ColHeaderEditEnd.val())) {
            alert("Please input a number for the Weight Break(s)!");
            if (isNaN(ColHeaderEditBegin.val())) {
                ColHeaderEditBegin.val("");
                return;
            }
            if (isNaN(ColHeaderEditEnd.val())) {
                ColHeaderEditEnd.val("");
                return;
            }
        }
        //check if begin is less than end
        if (parseFloat(ColHeaderEditBegin.val()) > parseFloat(ColHeaderEditEnd.val())) {
            alert("Weight break begin cannot exceeds or the same as weight break end!");
            ColHeaderEditBegin.val("");
            ColHeaderEditEnd.val("");
            //bring previos end +1 if exist 
            if (prev_exist) {
                alert(prev_end_val+1);
                ColHeaderEditBegin.val(prev_end_val + 1);
                    
                return;
            }
              
            
        }
        //check if end of the previous one exist and the begin is one more than the previous end
        if (prev_exist) {
            if (prev_end_val == null) {
                alert("Please complete preivious range first!");
                return;
            }
            if (parseFloat(ColHeaderEditBegin.val()) != prev_end_val + 1) {
                alert("The begin should one more than previous end!");
                ColHeaderEditBegin.val(prev_end_val + 1);
                return;
            }
        }
        //check if begin of the next one exist and the end of this is one less than prev
        if (next_exist) {
            if (next_begin_val != null) {
                if (parseFloat(ColHeaderEditEnd.val()) != next_begin_val - 1) {
                    alert("The end should one less than previous end!");
                    ColHeaderEditEnd.val(next_begin_val - 1);
                    return;
                }
            }
        }
        SetValueAndText();
        HideEditor();
        return;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //When begin and end is none.
    if (ColHeaderEditBegin.val() == undefined || ColHeaderEditBegin.val() == "") {
        if (ColHeaderEditEnd.val() == undefined || ColHeaderEditEnd.val() == "") {
            $(obj).find(".RateHeaderColText").val("Click Here to Edit.");
            HideEditor();
            return;
        }
    } else {
        //when both has values
        if (ColHeaderEditBegin.val() != undefined && ColHeaderEditBegin.val() != "" && ColHeaderEditEnd.val() != undefined && ColHeaderEditEnd.val() != "") {
            {
                ValidateBothEnds();
            }
        } else {
            //when begin has value
            if (ColHeaderEditBegin.val() != undefined && ColHeaderEditBegin.val() != "") {
                ValidateBegin();
            } else {//if (ColHeaderEditEnd.val() != undefined && ColHeaderEditEnd.val() != "")

                ValidateEnd();
            }
        }
    }
}

    function setField(xmlTag,htmlTag,xmlObj)
    {
        if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
        {
            document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
        }
        else
        {
            document.getElementById(htmlTag).value = "";
        }
    }
    
    function setSelectField(xmlTag,htmlTag,xmlObj,compareLen)
    {
        var htmlObj = document.getElementById(htmlTag);
        if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
        {
            for(var i=0;i<htmlObj.options.length;i++)
            {
                if(htmlObj.options(i).value.substring(0,compareLen) == xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue.substring(0,compareLen))
                {
                    htmlObj.options(i).selected = true;
                }
            }
        }
        else
        {
            htmlObj.selectedIndex = -1;
        }
    }
    
    function findSelect(oSelect,selVal)
    {
        oSelect.options.selectedIndex = 0;
            
        for(var i=0;i<oSelect.options.length;i++)
        {
            if(oSelect.options[i].value == selVal)
            {
                oSelect.options[i].selected = true;
                break;
            }
        }
    }
    
    function getAjaxString(form){
        var querystring = "";
        
        try{
            
            var count = form.elements.length;
            
            for(var i=0; i<count; i++) {
                if(form.elements[i].name != ""){
                    querystring += form.elements[i].name+"=";
                    if(i < count-1)
                    { 
                        querystring += encodeURIComponent(form.elements[i].value)+"&";
                    }
                    else 
                    {
                        querystring += encodeURIComponent(form.elements[i].value); 
                    }
                }
            }
        }catch(err){
            alert(err.message);
        }
        return querystring;
    }
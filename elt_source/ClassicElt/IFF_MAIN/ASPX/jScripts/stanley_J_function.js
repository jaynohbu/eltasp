


//added by stanley on 11/1/2007
    function checkNum() {
        var ValidChars = "0123456789.-";

        if(ValidChars.indexOf(String.fromCharCode(event.keyCode)) == -1){
            event.returnValue=false;
        }
        else{
            event.returnValue=true;
        }
    }
    
//added by stanley on 11/2/2007
    function checkDecimalTextMax(obj,limit)
    {
        if(obj.value.length >= limit){
            var temp = obj.value;
            var tempArray = new Array();
            tempArray = temp.split(".");
            temp = tempArray[0];
            if(temp.length >= limit){
                obj.value = temp.substring(0,limit);
            }
            else{
                obj.value = parseFloat(obj.value).toFixed(2);
            }
            return false;
        }
        else
        {
            return true;
        }
    }
    
    //Uppercase function added by stanley on 11/13/07
    function ToUpCase(obj) 
    {
	    var word=obj.value;
	    obj.value=word.toUpperCase();       
	        
    }
    
    function checkblank(obj,obj2)
    {
        var object=document.getElementById(obj);
        if( object.value=="" || object.value=="NaN")
        {
            alert("Please enter a numeric number!");
            object.value=obj2;
        }
    }
    
       //Added by stanley Limit Fumction
    function checkLimit(obj, limit,limit2)
    {
        var num=obj.value;
        var tempArray = new Array();
        tempArray = num.split(".");
        if(num <= limit)
        {
            return true;
        }
        else
        {
            if(num > limit){
                obj.value = num.substring(0,limit2);
            }
            else{
                obj.value = parseFloat(obj.value).toFixed(2);
            }

        }
    }

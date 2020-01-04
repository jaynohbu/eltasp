 
    
    
    String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };
   
    var cur_term="";  
    var cur_previous="";
    var flag=true;
   // var cursor_string="";
    /*************************************************************************************
    
    
    **************************************************************************************/
    function ClearResults(oA_select){ 
              
        var counter = oA_select.options.length; 
        try{          
            for(var i=2; i<counter;i++){                       
                oA_select.options[i]=null; 
            }
            oA_select.options.length=2;   
        }catch(exception){
             alert(exception.discription);
        }    
    }
     /*************************************************************************************
    
    
    **************************************************************************************/
    function LoadAll(oA_selectId, aHiddenFD){
    
       var obj=document.getElementById(oA_selectId);   
        
      LoadResults(obj, aHiddenFD, "Enter a Search Key");    
    }
    
    /*************************************************************************************
    
    
    **************************************************************************************/
    function LoadResults(oA_select, aHiddenFD, sSearch_term){           
        ClearResults(oA_select);  
        
        var vResult_Options = getFromSearch_on_aHiddenFD(aHiddenFD, sSearch_term);     
        var count=vResult_Options.length; 
       
        cur_term=sSearch_term;         
                     
       for(var i=0; i<count; i++){ 
            if(vResult_Options[i].nodeName=='OPTION'){
              oA_select.appendChild(vResult_Options[i]);           
            }                 
       } 
                    
       if(stringStartsWith(vResult_Options[0].innerText.toUpperCase(), sSearch_term.toUpperCase())&&
       sSearch_term!=''){       
           oA_select.options[vEditableOptionIndex_A].innerText=vResult_Options[0].innerText;            
           cur_term= vResult_Options[0].innerText;           
           try{
                       
             oA_select.options[2]=null; 
                                                                 
           }catch(exception){                                  
           }                      
        }else{
            oA_select.options[vEditableOptionIndex_A].innerText=cur_term;
        }    
        return;
    }
   
    /*************************************************************************************
    
    
    **************************************************************************************/
    function getFromSearch_on_aHiddenFD(sHiddenField, s){
          
        var hiddenField=document.getElementById(sHiddenField);    
        var sNames_and_values= hiddenField.value;
        var vPairs=sNames_and_values.split('^');           
        var aOption_Name=new Array();
        var aOption_Value=new Array();      
        var vOptions=new Array();       
        var vRemainings=new Array();            
        var capSTrm=s.toUpperCase();           
        var end, nextStart, nextEnd, capCurrent;      
        vPairs.sort();       
       
        var k=0; 
        var h=0;   
           
        for(i=0; i< vPairs.length;i++){  
                                      
            end=vPairs[i].indexOf('__');
            nextStart=vPairs[i].indexOf('__')+2;          
            nextEnd=vPairs[i].length;      
            aOption_Name[i]=vPairs[i].substring(0,end);                                             
            aOption_Value[i]=vPairs[i].substring(nextStart,nextEnd);           
            
            capCurrent=aOption_Name[i].toUpperCase();
                       
            if(stringStartsWith(capCurrent, capSTrm)){                                         
                   vOptions[h]= document.createElement('Option');
                   vOptions[h].innerText=aOption_Name[i]; 
                   vOptions[h].value=aOption_Value[i];              
                   h++;                        
             }else{               
                   vRemainings[k]= document.createElement('Option');
                   vRemainings[k].innerText=aOption_Name[i];
                   vRemainings[k].value=aOption_Value[i];  
                   k++;           
            }             
         }  
         
         for(var i=0; i<k; i++){
            vOptions[h++]=vRemainings[i];
         }            
        return vOptions;     
    } 
       
    function stringStartsWith(str, keyword){     
        return (str.substring(0,keyword.length).indexOf(keyword)!=-1);    
    }  
   /* 
   function blink(dd){      
        var temp;   
        alert(dd); 
        var dd1=dd;
        //temp=dd.options[0].innerText; 
                
       while(true){    
            setInterval("switchText(dd1);", 500);
            //setInterval("switchText(dd);", 500);            
           if(event) break; 
        } 
   }

  function switchText(){ 
      if(!flag){
        cur_previous=arguments[0].options[0].innerText;
        arguments[0].options[0].innerText=cur_term;
        flag=true;
      }else{
       cur_term=arguments[0].options[0].innerText;
       arguments[0].options[0].innerText=cur_previous;
       flag=false;      
      }
  }*/
  
  function blink(getdropdown){ 
    dd=getdropdown;   
   
    while(flag){    
        setInterval("switchText(dd);", 400);
        setInterval("switchText2(dd);", 400);
        if(event) break; 
    } 
  }
  
  function switchText2(){   
   arguments[0].options[0].innerText=cur_term; 
  }
  
  function switchText(){ arguments[0].options[0].innerText= cur_previous; }
  
  function setFlag(bl){ flag = bl; }  
    
    
    
    

    function fnKeyDownHandler(getdropdown, e){
        fnSanityCheck(getdropdown);
        // Press [ <- ] and [ -> ] arrow keys on the keyboard to change alignment/flow.
        // ...go to Start : Press  [ <- ] Arrow Key
        // ...go to End : Press [ -> ] Arrow Key
        // (this is useful when the edited-text content exceeds the ListBox-fixed-width)
        // This works best on Internet Explorer, and not on Netscape
        var vEventKeyCode = FindKeyCode(e);
        // Press left/right arrow keys
        if(vEventKeyCode == 37)
        {
        fnLeftToRight(getdropdown);
        }
        if(vEventKeyCode == 39)
        {
        fnRightToLeft(getdropdown);
        }
        // Delete key pressed
        if(vEventKeyCode == 46)
        {
        fnDelete(getdropdown);
        }
        // backspace key pressed
        if(vEventKeyCode == 8 || vEventKeyCode==127)
        {
        if(e.which) //Netscape
        {
          //e.which = ''; //this property has only a getter.
        }
        else //Internet Explorer
        {
          //To prevent backspace from activating the -Back- button of the browser
          e.keyCode = '';
          if(window.event.keyCode)
          {
          window.event.keyCode = '';
          }
        }
        return true;
        }
    // Tab key pressed, use code below to reorient to Left-To-Right flow, if needed
    //if(vEventKeyCode == 9)
    //{
    //  fnLeftToRight(getdropdown);
    //}
  }
 
  
  function fnLeftToRight(getdropdown){
    getdropdown.style.direction = "ltr";
  }
  function fnRightToLeft(getdropdown)
  {
    getdropdown.style.direction = "rtl";
  }
  
  function fnDelete(getdropdown)
  {
    if(getdropdown.options.length != 0)
    // if dropdown is not empty
    {
    if (getdropdown.options.selectedIndex == vEditableOptionIndex_A)
    // if option the Editable field
    {
      getdropdown.options[getdropdown.options.selectedIndex].innerText = '';
      getdropdown.options[getdropdown.options.selectedIndex].value = '';
      cur_term='';
      //cursor_string='';
    }
    }
  }

  /*
  Since Internet Explorer and Netscape have different
  ways of returning the key code, displaying keys
  browser-independently is a bit harder.
  However, you can create a script that displays keys
  for either browser.
  The following function will display each key
  in the status line:
  The "FindKey.." function receives the "event" object
  from the event handler and stores it in the variable "e".
  It checks whether the "e.which" property exists (for Netscape),
  and stores it in the "keycode" variable if present.
  Otherwise, it assumes the browser is Internet Explorer
  and assigns to keycode the "e.keyCode" property.
  */
  function FindKeyCode(e)
  {
    if(e.which)
    {
    keycode=e.which;  //Netscape
    }
    else
    {
    keycode=e.keyCode; //Internet Explorer
    }
    //alert("FindKeyCode"+ keycode);
    return keycode;
  }
  
  function FindKeyChar(e)
  {
    keycode = FindKeyCode(e);
    if((keycode==8)||(keycode==127))
    {
    character="backspace"
    }
    else if((keycode==46))
    {
    character="delete"
    }
    else
    {
    character=String.fromCharCode(keycode);
    }
    //alert("FindKey"+ character);
    return character;
  }
  
  function fnSanityCheck(getdropdown)
  {
    if(vEditableOptionIndex_A>(getdropdown.options.length-1))
    {
    alert("PROGRAMMING ERROR: The value of variable vEditableOptionIndex_... cannot be greater than (length of dropdown - 1)");
    return false;
    }
  }
  var vEditableOptionIndex_A = 0;
  // Give Index of Editable option in the dropdown.
  // For eg.
  // if first option is editable then vEditableOptionIndex_A = 0;
  // if second option is editable then vEditableOptionIndex_A = 1;
  // if third option is editable then vEditableOptionIndex_A = 2;
  // if last option is editable then vEditableOptionIndex_A = (length of dropdown - 1).
  // Note: the value of vEditableOptionIndex_A cannot be greater than (length of dropdown - 1)
  var vEditableOptionText_A = "Enter a search item";
  // Give the default text of the Editable option in the dropdown.
  // For eg.
  // if the editable option is <option ...>--?--</option>,
  // then set vEditableOptionText_A = "--?--";
  /*------------------------------------------------
  Global Variables required for
  fnChangeHandler_A(), fnKeyPressHandler_A() and fnKeyUpHandler_A()
  for Editable Dropdowns
  -------------------------- Subrata Chakrabarty  */
  var vPreviousSelectIndex_A = 0;
  // Contains the Previously Selected Index, set to 0 by default
  var vSelectIndex_A = 0;
  // Contains the Currently Selected Index, set to 0 by default
  var vSelectChange_A = 'MANUAL_CLICK';
  // Indicates whether Change in dropdown selected option
  // was due to a Manual Click
  // or due to System properties of dropdown.
  // vSelectChange_A = 'MANUAL_CLICK' indicates that
  // the jump to a non-editable option in the dropdown was due
  // to a Manual click (i.e.,changed on purpose by user).
  // vSelectChange_A = 'AUTO_SYSTEM' indicates that
  // the jump to a non-editable option was due to System properties of dropdown
  // (i.e.,user did not change the option in the dropdown;
  // instead an automatic jump happened due to inbuilt
  // dropdown properties of browser on typing of a character )
  /*------------------------------------------------
  Functions required for  Editable Dropdowns
  -------------------------- Subrata Chakrabarty  */
  
  function fnChangeHandler_A(getdropdown)
  {
    fnSanityCheck(getdropdown);
    
      
    vPreviousSelectIndex_A = vSelectIndex_A;
    // Contains the Previously Selected Index
    vSelectIndex_A = getdropdown.options.selectedIndex;
    // Contains the Currently Selected Index
    if ((vPreviousSelectIndex_A == (vEditableOptionIndex_A)) && (vSelectIndex_A != (vEditableOptionIndex_A))&&(vSelectChange_A != 'MANUAL_CLICK'))
    // To Set value of Index variables - Subrata Chakrabarty
    {
      getdropdown[(vEditableOptionIndex_A)].selected=true;
      vPreviousSelectIndex_A = vSelectIndex_A;
      vSelectIndex_A = getdropdown.options.selectedIndex;
      vSelectChange_A = 'MANUAL_CLICK';
      // Indicates that the Change in dropdown selected
      // option was due to a Manual Click
    }
  }
  
  
  function fnKeyPressHandler_A(getdropdown, e, hiddenField )
  {
     fnSanityCheck(getdropdown);     
     getdropdown.options[vEditableOptionIndex_A].selectedIndex=true;
    
  //  vEditString=cur_term;
    //getdropdown.options[vEditableOptionIndex_A].innerText = vEditString;
    
    keycode = FindKeyCode(e);
    keychar = FindKeyChar(e);
    // Check for allowable Characters
    // The various characters allowable for entry into Editable option..
    // may be customized by minor modifications in the code (if condition below)
    // (you need to know the keycode/ASCII value of the  character to be allowed/disallowed.
    // - Subrata Chakrabarty
    if ((keycode>47 && keycode<59)||(keycode>62 && keycode<127) ||(keycode==32))
    {
      var vAllowableCharacter = "yes";
    }
    else
    {
      var vAllowableCharacter = "no";
    }
    //alert(window); alert(window.event);
    if(getdropdown.options.length != 0)
    // if dropdown is not empty
      if (getdropdown.options.selectedIndex == (vEditableOptionIndex_A))
      // if selected option the Editable option of the dropdown
      {
        var vEditString = getdropdown[vEditableOptionIndex_A].value;
        // make Editable option Null if it is being edited for the first time
        if((vAllowableCharacter == "yes")||(keychar=="backspace"))
        {
          if (vEditString == vEditableOptionText_A)
            vEditString = "";
        }
        if (keychar=="backspace")
        // To handle backspace - Subrata Chakrabarty
        {   
        getdropdown.options[vEditableOptionIndex_A].selectedIndex=true;
          vEditString = vEditString.substring(0,vEditString.length-1);        
        
          sSearch_term=getdropdown.options[vEditableOptionIndex_A].innerText = vEditString;
          // Decrease length of string by one from right
          vSelectChange_A = 'MANUAL_CLICK';
          // Indicates that the Change in dropdown selected
          // option was due to a Manual Click
        }
        //alert("EditString2:"+vEditString);
        if (vAllowableCharacter == "yes")
        // To handle addition of a character - Subrata Chakrabarty
        {       
          
          vEditString+=String.fromCharCode(keycode);
          // Concatenate Enter character to Editable string
          // The following portion handles the "automatic Jump" bug
          // The "automatic Jump" bug (Description):
          //   If a alphabet is entered (while editing)
          //   ...which is contained as a first character in one of the read-only options
          //   ..the focus automatically "jumps" to the read-only option
          //   (-- this is a common property of normal dropdowns
          //    ..but..is undesirable while editing).
          var i=0;
          var vEnteredChar = String.fromCharCode(keycode);
          var vUpperCaseEnteredChar = vEnteredChar;
          var vLowerCaseEnteredChar = vEnteredChar;

          if(((keycode)>=97)&&((keycode)<=122))
          // if vEnteredChar lowercase
            vUpperCaseEnteredChar = String.fromCharCode(keycode - 32);
            // This is UpperCase

          if(((keycode)>=65)&&((keycode)<=90))
          // if vEnteredChar is UpperCase
            vLowerCaseEnteredChar = String.fromCharCode(keycode + 32);
            // This is lowercase
          if(e.which) //For Netscape
          {
            // Compare the typed character (into the editable option)
            // with the first character of all the other
            // options (non-editable).
            // To note if the jump to the non-editable option was due
            // to a Manual click (i.e.,changed on purpose by user)
            // or due to System properties of dropdown
            // (i.e.,user did not change the option in the dropdown;
            // instead an automatic jump happened due to inbuilt
            // dropdown properties of browser on typing of a character )
            for (i=0;i<=(getdropdown.options.length-1);i++)
            {
              if(i!=vEditableOptionIndex_A)
              {
                var vReadOnlyString = getdropdown[i].value;
                var vFirstChar = vReadOnlyString.substring(0,1);
                if((vFirstChar == vUpperCaseEnteredChar)||(vFirstChar == vLowerCaseEnteredChar))
                {
                  vSelectChange_A = 'AUTO_SYSTEM';
                  // Indicates that the Change in dropdown selected
                  // option was due to System properties of dropdown
                  break;
                }
                else
                {
                  vSelectChange_A = 'MANUAL_CLICK';
                  // Indicates that the Change in dropdown selected
                  // option was due to a Manual Click
                }
              }
            }
          }
        }
        // Set the new edited string into the Editable option
        
        sSearch_term=getdropdown.options[vEditableOptionIndex_A].innerText = vEditString;
        getdropdown.options[vEditableOptionIndex_A].value = vEditString;
        cur_term=vEditString; 
         cur_previous= arguments[0].options[0].innerText;               
        LoadResults(getdropdown, hiddenField, vEditString);
       
        blink(getdropdown);
                        
        return false;
      }
    return true;
  }
  
  
  
  function fnKeyUpHandler_A(getdropdown, e)
  {
    fnSanityCheck(getdropdown);
    
    
    if(e.which) // Netscape
    {
      if(vSelectChange_A == 'AUTO_SYSTEM')
      {
        // if editable dropdown option jumped while editing
        // (due to typing of a character which is the first character of some other option)
        // then go back to the editable option.
        getdropdown[(vEditableOptionIndex_A)].selected=true;
      }
      var vEventKeyCode = FindKeyCode(e);
      // if [ <- ] or [ -> ] arrow keys are pressed, select the editable option
      if((vEventKeyCode == 37)||(vEventKeyCode == 39))
      {
        getdropdown[vEditableOptionIndex_A].selected=true;
      }
    }  
  }
  
  
  

  



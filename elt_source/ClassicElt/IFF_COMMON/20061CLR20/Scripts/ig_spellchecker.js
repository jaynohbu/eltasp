 /*
  * Infragistics WebSpellChecker CSOM Script: ig_spellchecker.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */
function ig_CreateWebSpellChecker(props)
{
	if(!ig_WebControl.prototype.isPrototypeOf(ig_WebSpellChecker.prototype))
    {
        ig_WebSpellChecker.prototype = new ig_WebControl();
        ig_WebSpellChecker.prototype.constructor = ig_WebSpellChecker;
        ig_WebSpellChecker.prototype.base=ig_WebControl.prototype;
        
        ig_WebSpellChecker.prototype.init = function(props)
        {
            this._isInitializing = true;
            this._initControlProps(props);
            this.base.init.apply(this,[this.getClientID()]);
            this._isInitializing = false;
            this._spellChecker = this;
        }
        ig_WebSpellChecker.prototype._onLoad = function(src, evnt)
        {
			var id = this.getButtonId();
			if(id != null && id.length > 0)
			{
				var button = document.getElementById(id);
				if(button != null)
				{
					button._spellChecker = this;
					button.onclick = this._buttonClick;
				}
			}
        }
        
        ig_WebSpellChecker.prototype._onUnload = function(src, evnt)
        {
			if(this._window != null)
				this._window.close();
        }
        
        ig_WebSpellChecker.prototype._buttonClick = function()
        {
			this._spellChecker.checkTextComponent();
        }
        ig_WebSpellChecker.prototype.checkTextComponent = function(textComponentId)
        {
			if(textComponentId == null)
				textComponentId = this._spellChecker.getTextComponentId()
				
			var textToBeChecked = this._spellChecker._escQuotes(this._spellChecker._escEntities(this._spellChecker.getText(textComponentId)));
			
			this._spellChecker.checkSpelling(textToBeChecked, null, textComponentId);
        }
        
        ig_WebSpellChecker.prototype.checkSpelling = function(textToBeChecked, returnFunc, textComponentId)
        {
			if(textToBeChecked != null && textToBeChecked.length > 0)
			{
				textToBeChecked = escape(textToBeChecked);
				if(textComponentId == null && returnFunc != null)
					this._spellChecker._returnFunc = returnFunc;
				else
					this._spellChecker._returnFunc = null;
				
				if(textComponentId == null)
					textComponentId = "";
					
				var doc = "<html><meta http-equiv='Content-Type' content='text/html; charset=utf-8'>";  
				doc += "<font face='arial, helvetica' size=2>"+ this._spellChecker.getSpellCheckText()+"</font>";
				var dialogUrl = this._spellChecker.getWebSpellCheckerDialogPage();
				if(dialogUrl.length > 0)
					doc += "<form accept-charset='UTF-8' action='"+dialogUrl+"' method='post'>";  
				else
					doc += "<form accept-charset='UTF-8' action='"+ window.location.href +"' method='post'>";  
				doc += "<input type='hidden' name='textToCheck' value=\""+textToBeChecked+"\">";
				doc += "<input type='hidden' name='UserDictionaryFile' value='"+this._spellChecker.getUserDictionaryFile()+"'>";
				doc += "<input type='hidden' name='SuggestionsMethod' value='"+this._spellChecker.getSuggestionsMethod()+"'>";
				doc += "<input type='hidden' name='LanguageParser' value='"+this._spellChecker.getLanguageParser()+"'>";
				doc += "<input type='hidden' name='SeparateHyphenWords' value='"+this._spellChecker.getSeparateHyphenWords()+"'>";
				doc += "<input type='hidden' name='AllowWordsWithDigits' value='"+this._spellChecker.getAllowWordsWithDigits()+"'>"; 
				doc += "<input type='hidden' name='SuggestSplitWords' value='"+this._spellChecker.getSuggestSplitWords()+"'>";
				doc += "<input type='hidden' name='CheckCompoundWords' value='"+this._spellChecker.getCheckCompoundWords()+"'>";
				doc += "<input type='hidden' name='WebSpellCheckerId' value='"+this._spellChecker.getClientID()+"'>";
				doc += "<input type='hidden' name='AllowMixedCase' value='"+this._spellChecker.getAllowMixedCase()+"'>"; 
				doc += "<input type='hidden' name='IncludeUserDictionaryInSuggestions' value='"+this._spellChecker.getIncludeUserDictionaryInSuggestions()+"'>";
				doc += "<input type='hidden' name='CheckHyphenatedText' value='"+this._spellChecker.getCheckHyphenatedText()+"'> ";
				doc += "<input type='hidden' name='AllowXML' value='"+this._spellChecker.getAllowXML()+"'>";
				doc += "<input type='hidden' name='AllowCapitalizedWords' value='"+this._spellChecker.getAllowCapitalizedWords()+"'>";
				doc += "<input type='hidden' name='AllowCaseInsensitiveSuggestions' value='"+this._spellChecker.getAllowCaseInsensitiveSuggestions()+"'>";
				doc += "<input type='hidden' name='ConsiderationRange' value='"+this._spellChecker.getConsiderationRange()+"'>";
				doc += "<input type='hidden' name='Dictionary' value='"+this._spellChecker.getDictionary()+"'>";
				doc += "<input type='hidden' name='TextComponentId' value ='" + textComponentId + "'>";
				doc += "<input type='hidden' name='SplitWordThreshold' value='"+this._spellChecker.getSplitWordThreshold()+"'>";
				doc += "<input type='hidden' name='FormId' value='"+window.document.forms[0].id+"'>";
				doc += "</form></body>"; 
				doc += "</html>"; 
				
				var url = "";
				var left = this._spellChecker.getWindowX()> 0?"left=" + this._spellChecker.getWindowX() +", " :"";
				var top = this._spellChecker.getWindowY()> 0?"top=" + this._spellChecker.getWindowY() +", " :"";
				var width = "width=" + this._spellChecker.getWindowWidth();
				var height = "height=" + this._spellChecker.getWindowHeight();
					
				if(!this._spellChecker._onBeforeSpellCheckBegins(textToBeChecked))
				{
					if(!this._spellChecker.getModal())
					{
						var name = "WebSpellChecker";
						if(this._spellChecker.getAllowMultipleDialogs())
							name = "";
						this._spellChecker._openNonModalWindow(url, name, 'resizable=yes,scrollbars=auto,dependent=yes,toolbar=no, ' +  left + top + 'status=no,location=no,menubar=no,' + width +',' + height, doc); 
					}
					else
					{
						var pair = [this._spellChecker,doc, document];
						if(!ig_shared.IsIE55Plus)
							this._spellChecker._openNonModalWindow(url, name, 'modal=yes,resizable=yes,scrollbars=auto,dependent=yes,toolbar=no, ' +  left + top + 'status=no,location=no,menubar=no,' + width +',' + height, doc); 
						else
						{
							url = this._spellChecker.getWebSpellCheckerDialogPage();
							if(url == "" || url.length  == 0)
								url = window.location.href + "?Modal="+window.document.forms[0].id;
							
							showModalDialog(url,pair, "dialogHeight:"+ (this._spellChecker.getWindowHeight()+40) +"px; dialogWidth: "+(this._spellChecker.getWindowWidth()+15)+"px; " + (this._spellChecker.getWindowX()>=0?"dialogLeft:"+this._spellChecker.getWindowX()+"; ":"") + (this._spellChecker.getWindowY()>=0?"dialogTop:"+this._spellChecker.getWindowY()+"; ":"") + "edge: Sunken; center: Yes; help: No; resizable: No; status: No;");
						}
					}
				}
			}
			else
				return null;
        }

        
        ig_WebSpellChecker.prototype._openNonModalWindow = function(url, name, params, doc)
		{ 
			this._window = window.open(url, name, params); 
			this._window.focus();  
			this._window.document.open();  
			this._window.document.write(doc); 
			this._window.document.close(); 
			this._window.document.forms[0].submit();
		}
        
        ig_WebSpellChecker.prototype.getText = function(textComponentId)
        {
			var text = "";
			
			var textComponentDelegate = this._getTextComponentObjectDelegate()
				
			if(textComponentId == null)
				textComponentId = this.getTextComponentId();
						
			if(textComponentDelegate == null || textComponentDelegate.length == 0)
			{
				var textElement = null;
				try
				{
					textElement = igedit_getById(textComponentId);
				}
				catch(e){}
				
				if(textElement == null)
				{
					try
					{
						textElement = iged_getById(textComponentId);
					}
					catch(e){}
				}
				
					
				if(textElement != null)
					text = textElement.getText();
				else
				{
					textElement = document.getElementById(textComponentId);
				
					if(textElement != null) 
						text = textElement.value;	
				}
				
				var getText = this._onGetText(text)
				
				if(getText == "")
					return text;
				else
					return getText;
			}
			else
			{
				var getTextDelegate = this._getTextComponentGetTextDelegate();
				if(getTextDelegate != null && getTextDelegate.length > 0)
				{
					textComponentDelegate = eval(textComponentDelegate);
					if(textComponentDelegate != null)
					{
						var textElement = textComponentDelegate(textComponentId);
						
						if(textElement != null)
						{
							getTextDelegate = eval("textElement."+getTextDelegate);
							if(getTextDelegate != null)
							{
								textElement.__mygettextfunc = getTextDelegate;
								var text = textElement.__mygettextfunc();
								return text;
							}
						}
					}
				}
				return "";
			}
        }
        
        ig_WebSpellChecker.prototype.setText = function(textComponentId, value)
        {
			if(!this._onSetText(value))
			{
				var textComponentDelegate = this._getTextComponentObjectDelegate()
				
				if(textComponentId == null)
						textComponentId = this.getTextComponentId();
						
				if(textComponentDelegate == null || textComponentDelegate.length == 0)
				{
					var textElement = null;
					
					try
					{
						textElement = igedit_getById(textComponentId);
					}
					catch(e){}
					
					if(textElement == null)
					{
						try
						{
							textElement = iged_getById(textComponentId);
						}
						catch(e){}
					}
					
					if(textElement != null)
						textElement.setText(value);
					else
					{
						textElement = document.getElementById(textComponentId);
				
						if(textElement != null) 
							textElement.value = value;
					}
				}
				else
				{
					var setTextDelegate = this._getTextComponentSetTextDelegate();
					if(setTextDelegate != null && setTextDelegate.length > 0)
					{
						textComponentDelegate = eval(textComponentDelegate);
						if(textComponentDelegate != null)
						{
							var textElement = textComponentDelegate(textComponentId);
							
							if(textElement != null)
							{
								setTextDelegate = eval("textElement."+setTextDelegate);
								if(setTextDelegate != null)
								{
									textElement.__mysettextfunc = setTextDelegate;
									textElement.__mysettextfunc(value);
								}
							}
						}
					}
				}
			}
        }
        
        ig_WebSpellChecker.prototype.getCheckCompoundWords = function() 
        {
          return this._props[2];
		}
        ig_WebSpellChecker.prototype.getConsiderationRange = function() 
        {
          return this._props[3];
		}
        ig_WebSpellChecker.prototype.getAllowCapitalizedWords = function() 
        {
          return this._props[4];
		}
        ig_WebSpellChecker.prototype.getAllowWordsWithDigits = function() 
        {
          return this._props[5];
		}
        ig_WebSpellChecker.prototype.getAllowXML = function() 
        {
          return this._props[6];
		}
        ig_WebSpellChecker.prototype.getIncludeUserDictionaryInSuggestions = function() 
        {
          return this._props[7];
		}
        ig_WebSpellChecker.prototype.getLanguageParser = function() 
        {
          return this._props[8];
		}
        ig_WebSpellChecker.prototype.getCheckHyphenatedText = function() 
        {
          return this._props[9];
		}
        ig_WebSpellChecker.prototype.getModal = function() 
        {
          return this._props[10];
		}
        ig_WebSpellChecker.prototype.getWebSpellCheckerDialogPage = function() 
        {
          return this._props[11];
		}
        ig_WebSpellChecker.prototype.setWebSpellCheckerDialogPage = function(value) 
        {
		  this._props[11] = value;
        }
          ig_WebSpellChecker.prototype.getSeparateHyphenWords = function() 
        {
          return this._props[12];
		}
        ig_WebSpellChecker.prototype.getShowFinishedMessage = function() 
        {
          return this._props[13];
		}
        ig_WebSpellChecker.prototype.getShowNoErrorsMessage = function() 
        {
          return this._props[14];
		}
        ig_WebSpellChecker.prototype.getSpellCheckText = function() 
        {
          return this._props[15];
		}
        ig_WebSpellChecker.prototype.getSuggestionsMethod = function() 
        {
          return this._props[16];
		}
        ig_WebSpellChecker.prototype.getSuggestSplitWords = function() 
        {
          return this._props[17];
		}
        ig_WebSpellChecker.prototype.getTextComponentId = function() 
        {
          return this._props[18];
		}
        ig_WebSpellChecker.prototype.setTextComponentId = function(value) 
        {
		  this._props[18] = value;
        }
        ig_WebSpellChecker.prototype.getUserDictionaryFile = function() 
        {
          return this._props[19];
		}
        ig_WebSpellChecker.prototype.getWindowHeight = function() 
        {
          return this._props[20];
		}
        ig_WebSpellChecker.prototype.getWindowWidth = function() 
        {
          return this._props[21];
		}
        ig_WebSpellChecker.prototype.getWindowX = function() 
        {
          return this._props[22];
		}
        ig_WebSpellChecker.prototype.getWindowY = function() 
        {
          return this._props[23];
		}
        ig_WebSpellChecker.prototype.getAllowMixedCase = function() 
        {
          return this._props[24];
		}
        ig_WebSpellChecker.prototype.getAutoPostBackSpellCheckComplete = function() 
        {
          return this._props[25];
		}
        ig_WebSpellChecker.prototype.getAllowMultipleDialogs = function() 
        {
          return this._props[26];
		}
        ig_WebSpellChecker.prototype.getButtonId = function() 
        {
          return this._props[27];
		}
		ig_WebSpellChecker.prototype.getDictionary = function() 
        {
          return this._props[28];
		}
		ig_WebSpellChecker.prototype.getAllowCaseInsensitiveSuggestions = function() 
        {
          return this._props[29];
		}
		ig_WebSpellChecker.prototype._getTextComponentObjectDelegate = function() 
        {
          return this._props[30];
		}
		ig_WebSpellChecker.prototype._getTextComponentGetTextDelegate = function() 
        {
          return this._props[31];
		}
		ig_WebSpellChecker.prototype._getTextComponentSetTextDelegate = function() 
        {
          return this._props[32];
		}
		ig_WebSpellChecker.prototype.getSplitWordThreshold = function() 
        {
          return this._props[33];
		}
		ig_WebSpellChecker.prototype._escQuotes = function(text)
		{  
			var rx = new RegExp("\"", "g"); 
			return text.replace(rx,"&#34;");
		}
		ig_WebSpellChecker.prototype._escEntities = function(text)
		{
			var rx = new RegExp("&", "g"); 
			return text.replace(rx,"&amp;");
		}
        ig_WebSpellChecker.prototype._onGetText = function(text)
        {
        	return this._fireEvent("GetText", null, text);
        }
        ig_WebSpellChecker.prototype._onSetText = function(text)
        {
        	return this.fireEvent("SetText", null, text);
        }
        ig_WebSpellChecker.prototype._onSpellCheckComplete = function(oldText, correctedText)
        {
        	return this.fireEvent("SpellCheckComplete", null, oldText, correctedText);
        }
        ig_WebSpellChecker.prototype._onWordCorrected = function(oldWord, newWord)
        {
        	return this._fireEvent("WordCorrected", null, oldWord, newWord);
        }
        ig_WebSpellChecker.prototype._onBeforeSpellCheckBegins = function(text)
        {
        	return this.fireEvent("BeforeSpellCheckBegins", null, text);
        }
        ig_WebSpellChecker.prototype._fireEvent = function(name, evnt)
        {
			if(!name || this._isInitializing || !this._clientEvents)
				return false;
			this._postRequest = 0;
			var evt, evts = this._clientEvents[name];
			var cancel = false, post = 0, i = (evts == null) ? 0 : evts.length;
			if(i == 0)
				return false;
			if(evnt == "check")
				return true;
			var args = this._fireEvent.arguments;
			var returnVal = "";
			while(i-- > 0)
			{
				if(evts[i] == null)
					continue;
				evt = evts[i]._event;
				evt.reset();
				evt.event=evnt;
				evt.needPostBack=evts[i]._autoPostBack;
				try
				{
					returnVal = evts[i]._handler(this, evt, args[2], args[3], args[4], args[5], args[6]);
				}catch(ex){continue;}
			}
			if(returnVal == null)
				returnVal = "";
			return returnVal;
        }
     }
     return new ig_WebSpellChecker(props);
}

function ig_WebSpellChecker(props)
{
   if(arguments.length != 0)
       this.init(props);
}

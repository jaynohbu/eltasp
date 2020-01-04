 /*
  * Infragistics WebSpellChecker CSOM Script: ig_spellcheckerdialog.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */
function ig_CreateWebSpellCheckerDialog(props)
{
	if(!ig_WebControl.prototype.isPrototypeOf(ig_WebSpellCheckerDialog.prototype))
    {
        ig_WebSpellCheckerDialog.prototype = new ig_WebControl();
        ig_WebSpellCheckerDialog.prototype.constructor = ig_WebSpellCheckerDialog;
        ig_WebSpellCheckerDialog.prototype.base=ig_WebControl.prototype;
        
        ig_WebSpellCheckerDialog.prototype.init = function(props)
        {
            this._isInitializing = true;
            this._initControlProps(props);
            this.base.init.apply(this,[this.getClientID()]);
            this._isInitializing = false;
            this._spellCheckFinished = false;
            this._duplicateWord = false;
            this._showXMLTags = false;
            this._currentWordIndex = 0; 
            this._ignoreWordIndexes = new Object();
			this._dialog = this;
			this._webSpellChecker = null;
			this._openerWindow = null;
			this._oldText = "";
        }	
        
        ig_WebSpellCheckerDialog.prototype._onLoad = function(src, evnt)
        {
			if(window.dialogArguments) 
			{
				this._webSpellChecker = window.dialogArguments[0];
				this._openerWindow = window.dialogArguments[2].window;
				if(window.dialogArguments[1] != "Loaded")
				{
					document.body.removeChild(document.forms[0]);
					var iframe = document.createElement("IFRAME");
					iframe.style.height = "100%";
					iframe.style.width ="100%";
					document.body.appendChild(iframe);
					iframe.contentWindow.document.open();
					iframe.contentWindow.document.write(window.dialogArguments[1]);
					iframe.contentWindow.document.close();
					window.dialogArguments[1] = "Loaded";
					iframe.contentWindow.document.forms[0].submit();
					return;
				}
			}
			else if(window.opener != null)
			{
				this._webSpellChecker = window.opener["o"+this._dialog.getWebSpellCheckerId()];
				this._openerWindow = window.opener;
			}
	
			if(this._webSpellChecker != null)
			{
				this._oldText = this.getText();
				var element = document.getElementById(this.getChangeAllButtonId());
				if(element != null)
				{
					element._dialog = this;
					element.onclick = this.changeAll;
				}
					
				element = document.getElementById(this.getChangeButtonId());
				if(element != null)
				{
					element._dialog = this;
					element.onclick = this.change;
				}
				
				element = document.getElementById(this.getFinishButtonId());
				if(element != null)
				{
					element._dialog = this;
					element.onclick = this.finish;
				}
				element = document.getElementById(this.getIgnoreAllButtonId());
				if(element != null)
				if(element != null)
				{
					element._dialog = this;
					element.onclick = this.ignoreAll;
				}
					
				element = document.getElementById(this.getIgnoreButtonId());
				if(element != null)
				{
					element._dialog = this;
					element.onclick = this.ignoreCurrent;
				}
					
				element = document.getElementById(this.getAddButtonId());
				if(element != null)
				{
					element._dialog = this;
					element.onclick = this.addCurrent;
				}
				
				element = document.getElementById(this.getSuggestionBoxId());
				if(element != null)
				{
					element._dialog = this;
					element.ondblclick = this.change;
					element.onchange = this.changeSuggestions;
				}
				
				element = document.getElementById(this.getChangeToBoxId());
				if(element != null)
				{
					ig_shared.addEventListener(element, "keypress", this.keyPress, true);
				}
				
				this.refresh();
			}
        }
        
        ig_WebSpellCheckerDialog.prototype.keyPress = function(evnt)
        {
			if(evnt.keyCode == 13)
				return false;
        }
        
        ig_WebSpellCheckerDialog.prototype.change = function()
        {
			if(this._dialog._currentWordIndex < this._dialog.getBadWords().length)
			{
				this._dialog.changeWord(this._dialog._currentWordIndex);
				this._dialog.nextWord();
			}	
        }
        
        ig_WebSpellCheckerDialog.prototype.changeAll = function()
        {
			var badWords = this._dialog.getBadWords();
			if(this._dialog._currentWordIndex < badWords.length)
			{ 
				var currentWord = badWords.getItem(this._dialog._currentWordIndex).getText(); 
				this._dialog.changeWord(this._dialog._currentWordIndex); 
				for (var i = this._dialog._currentWordIndex + 1; i < badWords.length; i++) 
				{ 
					if (!this._dialog._ignoreWordIndexes[i] && badWords.getItem(i).getText() == currentWord) 
					{ 
						this._dialog.changeWord(i); 
						this._dialog._ignoreWordIndexes[i] = true; 
					} 
				} 
				this._dialog.nextWord(); 
			}
        }
        ig_WebSpellCheckerDialog.prototype.ignoreCurrent = function()
        {	
			if(this._dialog._currentWordIndex<this._dialog.getBadWords().length)
			{
				this._dialog.nextWord();
			}
        }
        ig_WebSpellCheckerDialog.prototype.ignoreAll = function()
        {
			var badWords = this._dialog.getBadWords();
			if(this._dialog._currentWordIndex < badWords.length)
			{ 
				var currentWord = badWords.getItem(this._dialog._currentWordIndex).getText();
				for (var i = this._dialog._currentWordIndex + 1; i < badWords.length; i++) 
				{  
					if (!this._dialog._ignoreWordIndexes[i] && badWords.getItem(i).getText() == currentWord) 
					{  
						this._dialog._ignoreWordIndexes[i] = true;  
					} 
				} 
				
				this._dialog.nextWord(); 
			}
        }
        ig_WebSpellCheckerDialog.prototype.changeSuggestions = function()
        {
			var suggestions = document.getElementById(this._dialog.getSuggestionBoxId());
			var changeToBox = document.getElementById(this._dialog.getChangeToBoxId());
			var suggestion=suggestions.options[suggestions.selectedIndex].text;
			if(suggestion!=this._dialog.getNoSuggestionsText())
			{
				changeToBox.value=suggestion;
			}
        }
        ig_WebSpellCheckerDialog.prototype.addCurrent = function()
        {
			var addButton = this;
			var badWords = this._dialog.getBadWords();
			var currentWord = badWords.getItem(this._dialog._currentWordIndex).getText();
			if(addButton)
				addButton.disabled=true;
			var addFrame = document.createElement("IFRAME");
		    addFrame.style.height = "0px";
			addFrame.style.width ="0px";
			addFrame.style.visibility ="hidden";
			document.body.appendChild(addFrame);
			addFrame.contentWindow.document.open();
			var hiddenInputs = "<input type='hidden' name='UserDictionaryFile' value='"+this._dialog.getUserDictionaryFile()+"'>";
			hiddenInputs += "<input type='hidden' name='Add' value='"+currentWord+"'>";
			addFrame.contentWindow.document.write("<html><head></head><body><form method='post' action='" + this._dialog._openerWindow.location.href + "'>"+ hiddenInputs+"</form></body></html>");
			addFrame.contentWindow.document.close();
			addFrame.contentWindow.document.forms[0].submit();
			addButton.disabled=false;
			this._dialog.ignoreAll();
        }
        ig_WebSpellCheckerDialog.prototype.finish = function()
        {
			if (this._dialog._webSpellChecker != null) 
			{
				var textComponentId = this._dialog.getTextComponentId();
				
				if(textComponentId != null && textComponentId.length > 0)
					this._dialog._webSpellChecker.setText(textComponentId, this._dialog.getText());
				else if(this._dialog._webSpellChecker._returnFunc != null)
					this._dialog._webSpellChecker._returnFunc(this._dialog.getText());
			
				this._dialog._webSpellChecker._onSpellCheckComplete(this._dialog._oldText, this._dialog.getText());
			
				var stateItem = this._dialog._webSpellChecker.addStateItem("Finished", "SpellCheck");	
				this._dialog._webSpellChecker.updateStateItem(stateItem, "OldText",			this._dialog._oldText);
				this._dialog._webSpellChecker.updateStateItem(stateItem,	"CorrectedText",	this._dialog.getText());
				
				if(this._dialog._webSpellChecker.getAutoPostBackSpellCheckComplete())
					this._dialog._webSpellChecker.fireServerEvent("SpellCheck", "Finished");
			}
			window.close();
        }
        
        ig_WebSpellCheckerDialog.prototype.moveWordOffsets = function(delta, start)
        {
			var badWords = this.getBadWords();
			for(i=start;i<badWords.length;i++)
			{
				var badWord = badWords.getItem(i);
				badWord.setStartPosition(badWord.getStartPosition()+delta);
				badWord.setEndPosition(badWord.getEndPosition()+delta);
			}
        }
        ig_WebSpellCheckerDialog.prototype.changeWord = function(index)
        {
			var newText="";
			var changeToBox = document.getElementById(this.getChangeToBoxId());
			var newWord = changeToBox.value;
			var badWords = this.getBadWords();
			var badWord = badWords.getItem(index);
			if(this._duplicateWord && changeToBox.value=='')
			{
				badWord.setStartPosition((badWord.getStartPosition()-1));
			} 
			if(this._dialog._webSpellChecker != null)
			{
				var override = this._dialog._webSpellChecker._onWordCorrected(badWord.getText(), newWord);
				if( override != "")
					newWord = override;
			}
			newText+=this.getText().substring(0,badWord.getStartPosition());
			newText+=newWord;
			newText+=this.getText().substring(badWord.getEndPosition(),this.getText().length);
			this.moveWordOffsets(newWord.length-this.getText().substring(badWord.getStartPosition(),badWord.getEndPosition()).length,index+1);
			this.setText(newText);
        }
        
    
				
        
        ig_WebSpellCheckerDialog.prototype.refresh = function()
        {
			var documentTextPanel = document.getElementById(this.getDocumentTextPanelId());
			var suggestions = document.getElementById(this.getSuggestionBoxId());
			var changeToBox = document.getElementById(this.getChangeToBoxId());
			var badWords = this.getBadWords();
			var badWord = badWords.getItem(this._currentWordIndex);
			if(documentTextPanel != null)
			{	
        		if(this._currentWordIndex<this.getBadWords().length )
				{
					documentTextPanel.innerHTML = "";
					
					var beginning = this.textToHtml(this.getText().substring(0,badWord.getStartPosition()));
					var spanHtml = "<span id='highlight' class='" + this.getBadWordsStyleClassName() +"' style='height:1px;'>";
					spanHtml += this.getText().substring(badWord.getStartPosition(),badWord.getEndPosition());
					spanHtml += "</span>";
					var end =  this.textToHtml(this.getText().substring(badWord.getEndPosition(),this.getText().length));
					documentTextPanel.innerHTML =  beginning + spanHtml + end;
					suggestions.options.length=0;
					var n= badWord.getSuggestions().count;
					if(n==0)
					{
						changeToBox.value=badWord.getText();
						suggestions.options[0]=new Option(this.getNoSuggestionsText());
					}
					else if (badWord.getSuggestions().getItem(0)=="Remove duplicate word")
					{	
						suggestions.options[0]=new Option(badWords[currentWordIndex].suggestions[0]);
						suggestions.selectedIndex=0;
						changeToBox.value='';
						this._duplicateWord=true;
					}
					else
					{	
						changeToBox.value=badWord.getSuggestions().getItem(0);	
						for(var i=0;i<n;i++)
						{
							suggestions.options[i]=new Option(badWord.getSuggestions().getItem(i));	
						}	
						
						suggestions.selectedIndex=0;
						this._duplicateWord=false;
					}
					
					changeToBox.select();
				}
				else
				{
					
					documentTextPanel.innerHTML=this.textToHtml(this.getText());
					
					changeToBox.value="";
					suggestions.options.length=0;
					suggestions.options[0]=new Option(this.getNoSuggestionsText());
					
					if(badWords.length>0)
					{
						if(this._webSpellChecker.getShowFinishedMessage())						
							alert(this.getFinishedText());
					} 
					else 
					{	
						if(this._webSpellChecker.getShowNoErrorsMessage())
							alert(this.getNoErrorsText());
					} 
					this._spellCheckFinished=true;
					this.finish();	
				}
			}
        }
        
        ig_WebSpellCheckerDialog.prototype.textToHtml = function(t) 
        {
			if(this._showXMLTags)
			{ 
				var ltexp = new RegExp("<"); 
				
				while(ltexp.test(t))
					t = t.replace(ltexp, "&lt;");
			
		 		var gtexp = new RegExp(">");
			 	
		 		while(gtexp.test(t))
		 			t = t.replace(gtexp, "&gt;"); 
			} 
			else {} 
			 
			var newlineexp = new RegExp("\n");
			 
			while(newlineexp.test(t))
				t = t.replace(newlineexp, "<br>");
			
			return t;
        
        }
        
        ig_WebSpellCheckerDialog.prototype.nextWord = function() 
        {
			var badWords = this.getBadWords();
			while(this._currentWordIndex++ < badWords.length && this._ignoreWordIndexes[this._currentWordIndex]);
			var changeButton = document.getElementById(this.getChangeButtonId());
			var changeAllButton = document.getElementById(this.getChangeAllButtonId());
			var ignoreButton = document.getElementById(this.getIgnoreButtonId());
			var ignoreAllButton = document.getElementById(this.getIgnoreAllButtonId());
		
			if(this._currentWordIndex>=badWords.length)
			{
				if(changeButton!=null)
					changeButton.disabled=true;
				
				if(changeAllButton!=null)
					changeAllButton.disabled=true;
				
				if(ignoreButton!=null)
					ignoreButton.disabled=true;
					
				if(ignoreAllButton!=null)
					ignoreAllButton.disabled=true;
			}
				
			this.refresh();
        }
        
        ig_WebSpellCheckerDialog.prototype.getDocumentTextPanelId = function() 
        {
			return this._props[2];
        }
        ig_WebSpellCheckerDialog.prototype.getChangeAllButtonId = function() 
        {
			return this._props[3];
        }
        ig_WebSpellCheckerDialog.prototype.getChangeButtonId = function() 
        {
			return this._props[4];
        }
        ig_WebSpellCheckerDialog.prototype.getChangeToBoxId = function() 
        {
			return this._props[5];
        }
        ig_WebSpellCheckerDialog.prototype.getFinishButtonId = function() 
        {
			return this._props[6];
        }
        ig_WebSpellCheckerDialog.prototype.getIgnoreAllButtonId = function() 
        {
			return this._props[7];
        }
        ig_WebSpellCheckerDialog.prototype.getIgnoreButtonId = function() 
        {
			return this._props[8];
        }
        ig_WebSpellCheckerDialog.prototype.getSuggestionBoxId = function() 
        {
			return this._props[9];
        }
        ig_WebSpellCheckerDialog.prototype.getAddButtonId = function() 
        {
			return this._props[10];
        }
        ig_WebSpellCheckerDialog.prototype.getText = function() 
        {
			return this._props[11];
        }
        ig_WebSpellCheckerDialog.prototype.setText = function(val) 
        {
			this._props[11] = val;
        }
        ig_WebSpellCheckerDialog.prototype.getNoErrorsText = function() 
        {
			return this._props[12];
        }
        ig_WebSpellCheckerDialog.prototype.getFinishedText = function() 
        {
			return this._props[13];
        }
        ig_WebSpellCheckerDialog.prototype.getNoSuggestionsText = function() 
        {
			return this._props[14];
        }
        ig_WebSpellCheckerDialog.prototype.getUserDictionaryFile = function() 
        {
			return this._props[15];
        }
        ig_WebSpellCheckerDialog.prototype.getWebSpellCheckerId = function() 
        {
			return this._props[16];
        }
        ig_WebSpellCheckerDialog.prototype.getBadWordsStyleClassName = function() 
        {
			return this._props[17];
        }
        ig_WebSpellCheckerDialog.prototype.getTextComponentId = function() 
        {
			return this._props[18];
        }
        
        ig_WebSpellCheckerDialog.prototype.getBadWords = function() 
        {
			if(this._collections[0] == null)
					return null;
			if(this._badWords == null)
				this._badWords = new ig_BadWordsCollection(this._collections[0]);
			return this._badWords;
			
			
			return this._props[10];
        }
        
        ig_WebSpellCheckerDialog.prototype._onUnload = function(src, evnt)
        {
			this._webSpellChecker = null;
        }
    }
     return new ig_WebSpellCheckerDialog(props);
}

function ig_WebSpellCheckerDialog(props)
{
   if(arguments.length != 0)
       this.init(props);
}




function ig_BadWordsCollection(props)
{
	this._props = props;
	this.length = props.length;
	this.getItem = function(index)
	{
		if(index < 0 || index > this.length)
			return null;
			
		if(this[index] == null)
			this[index] = ig_CreateBadWord(this._props[index])
			
		return(this[index]);
	}
}   

function ig_CreateBadWord(props)
{
	if(!ig_BadWord.prototype.isPrototypeOf(this.prototype))
    {
		ig_BadWord.prototype.getText = function()
		{
			return this._props[0];
		}
		
		ig_BadWord.prototype.gete = function()
		{
			return this._props[1];
		}
		
		ig_BadWord.prototype.getStartPosition = function()
		{
			return parseInt(this._props[2]);
		}
		ig_BadWord.prototype.setStartPosition = function(val)
		{
			this._props[2] = val;
		}
		ig_BadWord.prototype.getEndPosition = function()
		{
			return parseInt(this._props[3]);
		}
		ig_BadWord.prototype.setEndPosition = function(val)
		{
			this._props[3] = val;
		}
		
		ig_BadWord.prototype.getSuggestions = function()
		{
			if(this._suggestions == null)
				this._suggestions = new ig_SuggestionsCollection(this._props[4]);
			return this._suggestions; 
		}
    
    }
	 return new ig_BadWord(props);
}

function ig_BadWord(props)
{
	this._props = props;
}
   
function ig_SuggestionsCollection(props)
{
	this._props = props;
	this.count =  this._props.length;
	
	this.getItem = function(index)
	{
		if(index < 0 || index > this.count)
			return null;
			
		if(this[index] == null)
			this[index] = this._props[index]
			
		return(this[index]);
	}
}

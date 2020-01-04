simpletab={
	tabClass:'simpletab', 
	listClass:'simpletabs', 
	activeClass:'active', 
	contentElements:'div',
	init:function(){
		var temp;
		if(!document.getElementById || !document.createTextNode){return;}
		var tempelm=document.getElementsByTagName('div');		
		for(var i=0;i<tempelm.length;i++){
			if(!simpletab.cssjs('check',tempelm[i],simpletab.tabClass)){continue;}
			simpletab.initTabMenu(tempelm[i]);
			if(simpletab.cssjs('check',tempelm[i],simpletab.prevNextIndicator)){
			}
		}
	},
	initTabMenu:function(menu){
		var id;
		var lists=menu.getElementsByTagName('ul');
		for(var i=0;i<lists.length;i++){
			if(simpletab.cssjs('check',lists[i],simpletab.listClass)){
				var thismenu=lists[i];
				break;
			}
		}
		if(!thismenu){return;}
		thismenu.currentSection='';
		thismenu.currentLink='';
		var links=thismenu.getElementsByTagName('a');
		for(i=0;i<links.length;i++){
			if(!/#/.test(links[i].getAttribute('href').toString())){continue;}
			id=links[i].href.match(/#(\w.+)/)[1];
			if(document.getElementById(id)){
				simpletab.addEvent(links[i],'click',simpletab.showTab,false);
				links[i].onclick=function(){return false;} // safari hack
				simpletab.changeTab(document.getElementById(id),0);
			}
		}
		id=links[0].href.match(/#(\w.+)/)[1];
		if(document.getElementById(id)){
			simpletab.changeTab(document.getElementById(id),1);
			thismenu.currentSection=id;
			thismenu.currentLink=links[0];
			simpletab.cssjs('add',links[0].parentNode,simpletab.activeClass);
		}
	},
	changeTab:function(elm,state){
		do{
			elm=elm.parentNode;
		} while(elm.nodeName.toLowerCase()!=simpletab.contentElements)
		elm.style.display=state==0?'none':'block';
	},

	showTab:function(e){
		var o=simpletab.getTarget(e);
		if(o.parentNode.parentNode.currentSection!=''){
			simpletab.changeTab(document.getElementById(o.parentNode.parentNode.currentSection),0);
			simpletab.cssjs('remove',o.parentNode.parentNode.currentLink.parentNode,simpletab.activeClass);
		}
		var id=o.href.match(/#(\w.+)/)[1];
		o.parentNode.parentNode.currentSection=id;
		o.parentNode.parentNode.currentLink=o;
		simpletab.cssjs('add',o.parentNode,simpletab.activeClass);
		simpletab.changeTab(document.getElementById(id),1);
		document.getElementById(id).focus();
	},
/* helper methods */
	getTarget:function(e){
		var target = window.event ? window.event.srcElement : e ? e.target : null;
		if (!target){return false;}
		if (target.nodeName.toLowerCase() != 'a'){target = target.parentNode;}
		return target;
	},
	addEvent: function(elm, evType, fn, useCapture){
		if (elm.addEventListener) 
		{
			elm.addEventListener(evType, fn, useCapture);
			return true;
		} else if (elm.attachEvent) {
			var r = elm.attachEvent('on' + evType, fn);
			return r;
		} else {
			elm['on' + evType] = fn;
		}
	},
	cssjs:function(a,o,c1,c2){
		switch (a){
			case 'swap':
				o.className=!simpletab.cssjs('check',o,c1)?o.className.replace(c2,c1):o.className.replace(c1,c2);
			break;
			case 'add':
				if(!simpletab.cssjs('check',o,c1)){o.className+=o.className?' '+c1:c1;}
			break;
			case 'remove':
				var rep=o.className.match(' '+c1)?' '+c1:c1;
				o.className=o.className.replace(rep,'');
			break;
			case 'check':
				var found=false;
				var temparray=o.className.split(' ');
				for(var i=0;i<temparray.length;i++){
					if(temparray[i]==c1){found=true;}
				}
				return found;
			break;
		}
	}
}
simpletab.addEvent(window, 'load', simpletab.init, false);
	

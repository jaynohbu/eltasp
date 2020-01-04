 /*
  * Infragistics WebSchedule CSOM Script: ig_webcalendarview.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

function ig_getWebCalendarViewById(id)
{
	return ig_getWebControlById(id);
} 
function ig_WebCalendarView(prop)
{
	this._initProp(prop);
}
function ig_CreateCalendar(prop)
{
if(!ig_WebControl.prototype.isPrototypeOf(ig_WebCalendarView.prototype))
{
	ig_WebCalendarView.prototype=new ig_WebControl();
	ig_WebCalendarView.prototype.constructor=ig_WebCalendarView;
	ig_WebCalendarView.prototype.base=ig_WebControl.prototype;
	ig_WebCalendarView.prototype._initProp=function(prop)
	{
	if(!prop)return;
	this._is1st=true;
	this._initControlProps(prop);
	var id = this._clientID;
	this.init(id);
	this._infoID=prop[0][2];
	this._info=ig_getWebControlById(this._infoID);
	this._titleFormat=prop[0][3];
	this._css=new Array();
	var elem=ig_csom.getElementById(id);
	if(!elem)return;
	this._setActiveDay=function(info,evt,day,id)
	{
		var me=this._event._object;
		if(me&&day&&me._clientID!=id)me.select(day.getFullYear(),day.getMonth()+1,day.getDate(),-3);
	}
	this._info.addEventListener("InternalSetActiveDay",this._setActiveDay,this,false);
	ig_shared.addEventListener(elem,"select",ig_cancelEvent);
	ig_shared.addEventListener(elem,"selectstart",ig_cancelEvent);
	ig_shared.addEventListener(elem,"mousedown",ig_handleEvent);
	ig_shared.addEventListener(elem,"mouseup",ig_handleEvent);
	ig_shared.addEventListener(elem,"click",ig_handleEvent);
	ig_shared.addEventListener(elem,"dblclick",ig_handleEvent);
	this._element=elem;
	elem.setAttribute(ig_shared.attrID,id);
	var o,i=-1,sep=",";
	var dates = prop[0][5];
	prop=prop[0][4].split(sep);
	this._enabled=!ig_csom.isEmpty(prop[0]);
	this._dow=this.intI(prop,1);
	this._fixVis=!ig_csom.isEmpty(prop[2]);
	for(i=3;i<10;i++)if(!ig_csom.isEmpty(o=prop[i]))this._css[i-3]=o;
	this.Days=new Array(42);
	prop=dates.split(sep);
	this._date=[this.intI(prop,0),this.intI(prop,1),this.intI(prop,2),-1];
	var year=this.intI(prop,3),month=this.intI(prop,4);
	this._min=this._nd(this.intI(prop,5),this.intI(prop,6),this.intI(prop,7));
	this._max=this._nd(this.intI(prop,8),this.intI(prop,9),this.intI(prop,10));
	this._now=[this.intI(prop,11),this.intI(prop,12),this.intI(prop,13)];
	this._yearFix=this.intI(prop,14);//for not gregorian
	this._day=new Object();
	//0=500-prevMonth,1=502-nextMonth,2=504-MonthDrop,3=506-YearDrop
	//4=508-Footer,5=510-Title,6=512-Calendar,7=514-Dow
	this._elems=new Array(8);
	for(i=0;i<8;i++)
	{
		if((elem=ig_csom.getElementById(id+"_"+(500+i*2)))!=null)
		{
			this._elems[i]=elem;
			elem.setAttribute(ig_shared.attrID,id);
			elem.setAttribute("id_",500+i*2);
		}
	}
	this.repaint(year,month);
	this._is1st=false;
	this.fireEvent("initialize");
	}
	ig_WebCalendarView.prototype.valI=function(o,i){o=(o==null||o.length<=i)?null:o[i];return (o==null)?"":o;}
	ig_WebCalendarView.prototype.intI=function(o,i){return ig_csom.isEmpty(o=this.valI(o,i))?-1:parseInt(o);}
	ig_WebCalendarView.prototype._nd=function(y,m,d)
	{
		d=new Date(y,--m,d);
		if(y<100&&d.setFullYear!=null)d.setFullYear(y);
		return d;
	}
	ig_WebCalendarView.prototype._df=function(d,i)
	{
		if(i==0)return d.getFullYear();
		if(i==1)return d.getMonth()+1;
		return (i==2)?d.getDate():d.getDay();
	}
	ig_WebCalendarView.prototype._render=function(o,css,sel)
	{
		this._day.year=o.year;
		this._day.month=o.month;
		this._day.day=o.day;
		this._day.index=o.index;
		this._day.dow=(this._dow+(o.index%7))%7;
		this._day.element=o.element;
		this._day.text=""+o.day;
		this._day.activity=o.activity;
		o=this._day;
		o.css=css;
		o.selected=sel;
		return this.fireEvent("renderday",null,o);
	}
	ig_WebCalendarView.prototype.isSelected=function(year,month,day,i)
	{
		if(this._date[0]==year && this._date[1]==month && this._date[2]==day)
		{if(i>=0)this._date[3]=i;return true;}
		return false;
	}
	ig_WebCalendarView.prototype.isSel=function(i){return this._date[3]==i;}
	//already checked for old sel
	ig_WebCalendarView.prototype.select=function(year,month,day,i,e,post)
	{
		if(this._info)if(!this._info.setActiveDay(this._nd(year,month,day),post,this._clientID))return;
		//unselect
		var o,text=null,sel=this._date[3];
		if(sel>=0)
		{
			o=this.Days[sel];
			sel=o.css;
			if(this._render(o,sel,false))o=null;
			else{text=this._day.text;sel=this._day.css;}
			if(o!=null)
			{
				o.element.className=sel;
				if(text!=null)ig_shared.setText(o.element,text);
			}
		}
		this._date[0]=year;
		this._date[1]=month;
		this._date[2]=day;
		this._date[3]=-1;
		if(i<-1)//flag to calculate i
		{
			if(year!=this.Days[15].year||month!=this.Days[15].month)if(this.repaint(year,month,false,e)!=1)
				return;
			for(i=41;i>=0;i--)if(year==this.Days[i].year&&month==this.Days[i].month&&day==this.Days[i].day)
				break;
		}
		if(i>-2)if((this._date[3]=i)>=0)
		{
			o=this.Days[i];
			sel=o.css+" "+this._css[5];
			text=null;
			if(this._render(o,sel,true))o=null;
			else{text=this._day.text;sel=this._day.css;}
			if(o!=null)
			{
				o.element.className=sel;
				if(text!=null)ig_shared.setText(o.element,text);
			}
		}
	}
	ig_WebCalendarView.prototype.minMax=function(y,m,d)
	{
		m=this._nd(y,m,d);
		d=m.getTime();
		if(d>this._max.getTime())return this._max;
		if(d<this._min.getTime())return this._min;
		return null;
	}
	ig_WebCalendarView.prototype.repaint=function(year,month,check,e)
	{
		var id=(year==null);
		if(id||year<1)year=this.Days[15].year;
		if(month==null)month=this.Days[15].month;
		if(check==null)check=false;
		if(month<1){month=12;year--;}
		if(month>12){month-=12;year++;}
		var yy,i,o,d=this.minMax(year,month,1);
		if(d!=null){year=this._df(d,0);month=this._df(d,1);}
		if(e!=null)if(this.fireEvent("navigate",e,(d==null)?this._nd(year,month,1):d))
		{
			if((o=this._elems[2])!=null)o.selectedIndex=this.Days[15].month-1;
			if((o=this._elems[3])!=null)o.selectedIndex=this.Days[15].year-this.year0;
			return 1;
		}
		if((o=this._elems[2])!=null)o.selectedIndex=month-1;
		if((o=this._elems[3])!=null)if(this.year0==null)if((d=o.options)!=null)
			if((d=d[0])!=null)try{this.year0=parseInt(ig_shared.getText(d))-this._yearFix;}catch(ex){}
		if(this.year0!=null)
		{
			i=o.options.length;
			var y=year-(i>>1);
			d=this._df(this._min,0);
			if(y<d)y=d;else if(y+i>(d=this._df(this._max,0)))y=d-i+1;
			if(this.year0!=y)
			{
				while(i-->0)
				{
					yy=y+i+this._yearFix;d=(yy>999)?"":((yy>99)?"0":"00");
					ig_shared.setText(o.options[i],d+yy);
				}
				o.selectedIndex=-1;
			}
			o.selectedIndex=year-(this.year0=y);
		}
		if((o=this.Days[15])!=null)
		{
			if(o.year==year&&o.month==month){if(check)return 0;}
			else check=true;
		}
		else check=false;
		var numDays=(month==2)?28:30;
		d=this._nd(year,month,numDays+1);
		if(this._df(d,1)==month)numDays++;
		d=this._nd(year,month,1);
		i=this._df(d,3)-this._dow;
		var day1=(i<0)?i+7:i;
		if(!this._is1st)
		{
			if(this._elems[5]!=null&&(id||this.Days[15].month!=month||this.Days[15].year!=year))
			{
				d=(((yy=year+this._yearFix)<1000)?((yy<100)?"00":"0"):"")+yy;
				o=this._titleFormat.replace("##",d).replace("#",d.substring(2)).replace("%%",this._objects[month-1]).replace("%",""+month);
				ig_shared.setText(this._elems[5],o);
			}
		}
		id=this.fireEvent("renderday","check");
		d=this._nd(year,month,0);
		var day0=this._df(d,2)-day1+1;
		this._date[3]=-1;
		var iC=0,iCL=this._collections?this._collections.length:0,sun=(7-this._dow)%7;
		for(i=0;i<42;i++)
		{
			if(this._is1st)
			{
				var elem=null;
				if((elem=ig_csom.getElementById(this._id+"_d"+i))==null)continue;
				elem.setAttribute(ig_shared.attrID,this._id);
				elem.setAttribute("id_",i);
				o=this.Days[i]=new Object();
				o.element=elem;o.calendar=this;o.index=i;
			}
			else o=this.Days[i];
			o.year=year;o.month=month;o.activity=false;
			o.css=this._css[0];
			if(i%7==sun||i%7==(sun+6)%7)o.css+=" "+this._css[1];
			if(i<day1)
			{
				o.day=day0+i;
				if(--o.month<1){o.month=12;o.year--;}
				o.css+=" "+this._css[2];
			}
			else if(i<day1+numDays)o.day=i-day1+1;
			else
			{
				o.day=i+1-(day1+numDays);
				if(++o.month>12){o.month=1;o.year++;}
				o.css+=" "+this._css[2];
			}
			if(o.day==this._now[2]&&o.month==this._now[1]&&o.year==this._now[0])
				o.css+=" "+this._css[3];
			var text=o.day,sel=this.isSelected(o.year,o.month,o.day,i);
			while(iC<iCL)
			{
				var c=this._collections[iC];
				if(!c||c[0]<o.year||(c[0]==o.year&&c[1]<o.month)||(c[0]==o.year&&c[1]==o.month&&c[2]<o.day)){iC++;continue;}
				if(c[0]==o.year&&c[1]==o.month&&c[2]==o.day)
				{o.css+=" "+this._css[4];o.activity=true;iC++;}
				break;
			}
			d=o.css;
			if(sel)d+=" "+this._css[5];
			if(id)
			{
				if(this._render(o,d,sel))continue;
				o=this._day;d=this._day.css;text=this._day.text;
			}
			else if(this._is1st&&!o.activity)continue;
			o.element.className=d;
			ig_shared.setText(o.element,text);
		}
		if(!check||e==null||!this._info)return 0;
		d=this._info.getActiveDay();
		this._info.navigate(year-d.getFullYear(),month-1-d.getMonth(),0,this._id);
		return 0;
	}
	ig_WebCalendarView.prototype._onHandleEvent=function(src,e)
	{		
		if(!this._enabled)return;
		var type=e.type;
		var dbl=type=="dblclick";
		if(this.fireEvent(type, e, src))return;
		if(type.indexOf("mouse")==0){ig_cancelEvent(e);return;}
		if(!dbl&&!(type=="click"))return;
		var o=this.Days[15];
		var y=o.year,m=o.month;
		src = ig_findElemWithAttr(src, ig_shared.attrID);
		if(!src)return;
		var id = src.getAttribute("id_");
		if(id!=0)id=id?parseInt(id):-1;
		//drop
		if(id==504||id==506)
		{
			if(id==504){if((o=this._elems[2].selectedIndex+1)==m)return;m=o;}
			else
			{
				if((o=this.year0)==null)return;
				if((o+=this._elems[3].selectedIndex)==y)return;y=o;
			}
			this.repaint(y,m,true,e);
			return;
		}
		//cal
		if(id<0)return;
		//prev/next
		if(id>=500&&id<=502)this.repaint(y,m+id-501,true,e);
		//-3-request to scroll vis month
		var d,i=-3,toggle=e.ctrlKey;
		//today
		if(id==508)
		{
			y=this._now[0];m=this._now[1];d=this._now[2];toggle=false;
			if(!dbl&&this.isSelected(y,m,d))return;
			dbl=true;
		}
		else
		{
			if(id>=42)return;
			//days
			o=this.Days[id];
			y=o.year;m=o.month;d=o.day;
			if(this.isSel(o.index)){if(!dbl)return;}else toggle=false;
			if(!this._fixVis||this.Days[15].month==m)i=o.index;
		}
		if(this.minMax(y,m,d)!=null)return;
		this.select(y,m,d,i,e,dbl);//was+toggle??
	}
}
if(ig_csom._skipNew)return null;
return new ig_WebCalendarView(prop);
}

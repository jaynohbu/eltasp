 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid_ft.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// ig_WebGrid_ft.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
function igtbl_clarifyInput(gn,input,type)
{
	var result="";
	switch(type)
	{
	case 2: 
	case 3:
	case 16:
	case 20:
	case 17: 
	case 18:
	case 19:
	case 21:
	case 4: 
	case 5:
	case 14: 
		var ni="";
		for(var i=0;i<input.length;i++)
			if(input.substr(i,1)>="0" && input.substr(i,1)<="9" || input.substr(i,1)=="." || input.substr(i,1)=="-")
				ni+=input.substr(i,1);
		var number=parseFloat(ni,10);
		if(number.toString()=="NaN")
			number=0;
		if((type==17 || type==18 || type==19 || type==21) && number<0)
			number=-number;
		result=number.toString();
		break;
	default:
		result=input;
		break;
	}
	return result;
}

function igtbl_getFractionalPart(n)
{
	var s=n.toString();
	for(var i=0;i<s.length;i++)
		if(s.charAt(i)!=".")
			s=s.substr(0,i)+"0"+s.substr(i+1,s.length-i-1);
		else
			break;
	return parseFloat(s);
}

function igtbl_Mask(gn,input,type,mask)
{
	var gs=igtbl_getGridById(gn);
	var result="";
	var ignore=false;
	var months=new Array("January","February","March","April","May","June","July","August","September","October","November","December");
	var days=new Array("Sunday", "Monday", "Tuesday", "Wednesday","Thursday", "Friday", "Saturday");
	switch(type)
	{
	case 7: 
		var date=new Date(input);
		if(isNaN(date))
		{
			delete date;
			return result;
		}
		ignore=false;
		for(var i=0;i<mask.length;i++)
		{
			if(ignore)
			{
				result+=mask.substr(i,1);
				ignore=false;
				continue;
			}
			if(mask.charAt(i)=="\\")
			{
				ignore=true;
				continue;
			}
			var s=mask.substr(i,4);
			if(s=="MMMM")
			{
				result+=months[date.getMonth()];
				i+=3;
				continue;
			}
			if(s=="dddd")
			{
				result+=days[date.getDay()];
				i+=3;
				continue;
			}
			if(s=="yyyy")
			{
				result+=date.getFullYear();
				i+=3;
				continue;
			}
			s=mask.substr(i,3);
			if(s=="MMM")
			{
				result+=months[date.getMonth()].substr(0,3);
				i+=2;
				continue;
			}
			if(s=="ddd")
			{
				result+=days[date.getDay()].substr(0,3);
				i+=2;
				continue;
			}
			s=mask.substr(i,2);
			if(s=="MM")
			{
				var m=(date.getMonth()+1).toString();
				if(m.length==1)
					m="0"+m;
				result+=m;
				i+=1;
				continue;
			}
			if(s=="dd")
			{
				var d=date.getDate().toString();
				if(d.length==1)
					d="0"+d;
				result+=d;
				i+=1;
				continue;
			}
			if(s=="yy")
			{
				var y=(date.getYear()%100).toString();
				if(y.length==1)
					y="0"+y;
				result+=y;
				i+=1;
				continue;
			}
			if(s=="HH")
			{
				var h=date.getHours().toString();
				if(h.length==1)
					h="0"+h;
				result+=h;
				i+=1;
				continue;
			}
			if(s=="hh")
			{
				var hv=date.getHours();
				if(hv==0)
					hv=12;
				else if(hv>12)
					hv-=12;
				var h=hv.toString();
				if(h.length==1)
					h="0"+h;
				result+=h;
				i+=1;
				continue;
			}
			if(s=="mm")
			{
				var m=date.getMinutes().toString();
				if(m.length==1)
					m="0"+m;
				result+=m;
				i+=1;
				continue;
			}
			if(s=="ss")
			{
				var m=date.getSeconds().toString();
				if(m.length==1)
					m="0"+m;
				result+=m;
				i+=1;
				continue;
			}
			if(s=="tt")
			{
				var hv=date.getHours();
				var pm=false;
				if(hv>=12)
					pm=true;
				if(pm)
					result+="PM";
				else
					result+="AM";
				i+=1;
				continue;
			}
			s=mask.substr(i,1);
			if(s=="M")
			{
				var m=(date.getMonth()+1).toString();
				result+=m;
				continue;
			}
			if(s=="d")
			{
				var d=date.getDate().toString();
				result+=d;
				continue;
			}
			if(s=="y")
			{
				var y=(date.getYear()%100).toString();
				result+=y;
				continue;
			}
			if(s=="H")
			{
				var h=date.getHours().toString();
				result+=h;
				continue;
			}
			if(s=="h")
			{
				var hv=date.getHours();
				if(hv==0)
					hv=12;
				else if(hv>12)
					hv-=12;
				var h=hv.toString();
				result+=h;
				continue;
			}
			if(s=="m")
			{
				var m=date.getMinutes().toString();
				result+=m;
				continue;
			}
			if(s=="s")
			{
				var m=date.getSeconds().toString();
				result+=m;
				continue;
			}
			result+=mask.substr(i,1);
		}
		delete date;
		break;
	case 2: 
	case 3:
	case 16:
	case 20:
	case 17: 
	case 18:
	case 19:
	case 21:
	case 4: 
	case 5:
	case 14: 
		var ni="";
		for(var i=0;i<input.length;i++)
			if(input.substr(i,1)>="0" && input.substr(i,1)<="9" || input.substr(i,1)=="." || input.substr(i,1)=="-")
				ni+=input.substr(i,1);
		var number=parseFloat(ni,10);
		if(number.toString()=="NaN")
			number=0;
		if((type==17 || type==18 || type==19 || type==21) && number<0)
			number=-number;
		for(var numStart=0;numStart<mask.length;numStart++)
			if(mask.charAt(numStart)=="#" || mask.charAt(numStart)=="0" || mask.charAt(numStart)==".")
				break;
		mask=mask.substr(0,numStart)+"############"+mask.substr(numStart,mask.length-numStart);
		var lastChar=mask.length-1;
		if(mask.indexOf(".")!=-1)
			lastChar=mask.indexOf(".")-1;
		var negative=(number<0);
		number=Math.abs(number);
		var firstChar=mask.indexOf(".");
		var wh=0;
		var dec=0;
		var adj=0.5;
		if(firstChar!=-1)
		{
			firstChar+=1;
			for(var i=0;i<mask.length-firstChar;i++)
				adj/=10;
			wh=Math.floor(number+adj);
			dec=igtbl_getFractionalPart(number+adj);
		}
		else
			wh=Math.floor(number);
		var plCom=false;
		for(var i=lastChar;i>=0;i--)
		{
			var cs=mask.substr(i,1);
			if(cs=="#" || cs=="0")
			{
				var curDig=0;
				var leadZero=true;
				if(wh>0)
				{
					curDig=wh%10;
					wh=Math.floor(wh/10);
					leadZero=false;
				}
				if(!leadZero)
				{
					if(plCom)
						result=gs.cultureInfo[0]+result;
					result=curDig.toString()+result;
					plCom=false;
					continue;
				}
				else if(cs=="0")
				{
					if(plCom)
						result=gs.cultureInfo[0]+result;
					result="0"+result;
					plCom=false;
				}
			}
			else if(cs==",")
				plCom=true;
			else
				result=cs+result;
		}
		if(negative && mask.substr(0,1)=="+")
			result="-"+result.substr(1);
		else if(negative)
			result="-"+result;
		if(firstChar!=-1)
		{
			result+=gs.cultureInfo[1];
			for(var i=firstChar;i<mask.length;i++)
			{
				var cs=mask.substr(i,1);
				if(cs=="#" || cs=="0")
				{
					var curDig=0;
					curDig=Math.floor(dec*10+0.0000000005);
					
					if(curDig<0)curDig=0;
					dec=dec*10-curDig-adj;
					adj*=10;
					if(curDig!=0 || dec>adj)
					{
						result+=curDig.toString();
						continue;
					}
					else if(cs=="0")
						result+="0";
				}
				else if(cs=="," || cs==".")
					continue;
				else
					result+=cs;
			}
			
			if(result.indexOf(".")==result.length-1)
				result=result.substr(0,result.length-1);
		}
		if(result=="")
			result="0";
		break;
	case 11: 
		if(input.toLower()=="true")
			result="True";
		else
			result="False";
		break;
	default:
		result=input;
		break;
	}
	delete months;
	delete days;
	return result;
}

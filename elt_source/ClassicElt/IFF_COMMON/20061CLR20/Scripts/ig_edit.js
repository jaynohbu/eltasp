 /*
  * Infragistics WebDataInput CSOM Script: ig_edit.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

//js-version 5.32
//vs
if(typeof(igedit_all)!="object")
	var igedit_all=new Object();
function igedit_getById(id,elem)
{
	var o,e=elem,i1=-2;
	if(e!=null)
	{
		while(true)
		{
			if(e==null)return null;
			try{if(e.getAttribute!=null)id=e.getAttribute("editID");}catch(ex){}
			if(!ig_csom.isEmpty(id))break;
			if(++i1>4)return null;
			e=e.parentNode;
		}
		var ids=id.split(",");
		if(ig_csom.isEmpty(ids))return null;
		id=ids[0];
		i1=(ids.length>1)?parseInt(ids[1]):-1;
	}
	if((e=igedit_all)!=null)if((o=e[id])==null)for(var i in e)if((o=e[i])!=null)
		if(o.ID==id||o.ID_==id||o.uniqueId==id)break;else o=null;
	if(o!=null&&i1>-2)o.elemID=i1;
	return o;
}
function igedit_init(id,t,prop0,prop1)
{
	var o,elem=ig_csom.getElementById("igtxt"+id);
	if(!elem)return;
	prop0=prop0.split(",");
	if(t>=4)o=igedit_number(elem,id,prop0,prop1);
	else if(t==2)o=igedit_date(elem,id,prop0,prop1);
	else if(t==1)o=igedit_mask(elem,id,prop0,prop1);
	else o=new igedit_new(elem,id,prop0);
	igedit_all[id]=o;
	o.fix=1;
	o.setValue(prop1[0]);
	o.fcs=o._np=0;
	o.fireEvent(10);
	if(o._wh<1)return;
	o._onTimer=function()
	{
		var e=this.elem;var v,w=-1,p=e.parentNode;
		if((v=p.offsetHeight)<3)return;
		if((this._wh&4)!=0)if(v>e.offsetHeight){e.style.height=v+"px";w=-2;}
		if((this._wh&2)!=(v=0))while(v++<6&&e.offsetWidth-p.offsetWidth>w)p.style.paddingRight=v+"px";
		delete this._onTimer;
		if((o._wh&1)==0||(e=this.buttons[1])==null)return;e=e.elem;
		while((e=e.parentNode)!=null)if(e.tagName=="TABLE"){if((v=e.parentNode.offsetHeight)>4)e.style.height=v+"px";break;}
	}
	o._onTimer();
	if(typeof ig_handleTimer=="function")ig_handleTimer(o);
}
function igedit_number(elem,id,prop0,prop1)
{
	var i=1,me=new igedit_new(elem,id,prop0);
	var j=-1,v=me.valI(prop1,i++);
	var n=v.length;if(n<1)v=".";if(n<2){n=2;v+=v;}
	me.dec_vld=v.substring(n>>=1);
	me.decimalSeparator=v.substring(0,n);
	me.groupSeparator=me.valI(prop1,i++);
	v=me.valI(prop1,i++);
	if(v.length<1)v="-";
	me.minus=v;
	me.symbol=me.valI(prop1,i++);
	me.nullText=me.valI(prop1,i++);
	me.positivePattern=me.valI(prop1,i++);
	me.negativePattern=me.valI(prop1,i++);
	me.mode=me.valI(prop1,i++);
	me.decimals=me.valI(prop1,i++);
	me.minDecimals=me.valI(prop1,i++);
	v=me.valI(prop1,i++);
	if(v==1)me.min=me.valI(prop1,i++);
	v=me.valI(prop1,i++);
	if(v==1)me.max=me.valI(prop1,i++);
	me.clr1=me.valI(prop1,i++);
	me.clr0=me.valI(prop1,i++);
	me.groups=new Array();
	while(++j<6){if((v=me.valI(prop1,i++))>0)me.groups[j]=v;else break;}
	me.getMaxValue=function(){return this.max;}
	me.setMaxValue=function(v){this.max=this.toNum(v,false);}
	me.getMinValue=function(){return this.min;}
	me.setMinValue=function(v){this.min=this.toNum(v,false);}
	me.toNum=function(t,limit,fire)
	{
		var c,num=null,i=-1,div=1,dec=-1,iLen=0;
		if(t==="")t=null;
		if(t==null||t.length==null)num=t;
		else
		{
			var neg=false,dot=this.decimalSeparator.charCodeAt(0);
			if(t)
			{
				c=this.symbol;
				if(c.length>0)if((iLen=t.indexOf(c))>=0)t=t.substring(0,iLen)+t.substring(iLen+c.length);
				if(t.toUpperCase==null)t=t.toString();
				iLen=t.length;
			}
			while(++i<iLen)
			{
				if(this.isMinus(c=this.jpn(t.charCodeAt(i)))){if(neg)break;neg=true;}
				if(c==dot||c==12290){if(dec>=0)break;dec=0;}
				if(c<48||c>57)continue;
				if(num==null)num=0;
				if(dec<0)num=num*10+c-48;
				else{dec=dec*10+c-48;div*=10;}
			}
			if(num!=null){if(dec>0)num+=dec/div;if(neg)num=-num;}
		}
		i=limit?this.limits(num):num;
		if(fire!=true)return i;
		c="";
		if(i!=num||(i==null&&iLen>0))
		{
			fire=new Object();fire.value=i;fire.text=t;
			fire.type=(num==null)?((iLen==0)?2:0):1;
			c=String.fromCharCode(30);
			c+=t+c+fire.type;
			if(this.fireEvent(13,null,fire))c="";
			i=fire.value;
		}
		this.value=i;
		this.elemViewState.value=this.toTxt(i,true,null,"-",".")+c;
		this.valid(this.toTxt(i,true,null,"-",this.dec_vld));
		return i;
	}
	me.enter0=function(){return this.toTxt(null,true,this.elem.value,"-",".");}
	me.focusTxt=function(foc,e)
	{
		if(e!=null&&!foc)this.value=this.toNum(this.elem.value,true,true);
		return this.toTxt(this.value,foc);
	}
	me.toTxt=function(v,foc,t,m,dec)
	{
		if(t==null)
		{
			if(v==null)return foc?"":this.nullText;
			var neg=(v<0);
			if(neg)v=-v;
			try{t=v.toFixed(this.decimals);}catch(ex){t=""+v;}
			return this.toTxt(neg,foc,t.toUpperCase(),(m==null)?this.minus:m,(dec==null)?this.decimalSeparator:dec);
		}
		var c,i=-1,iL=t.length;
		if(v==null)
		{
			if(iL==0)return foc?t:this.nullText;
			if(v=this.isMinus(t.charCodeAt(0)))t=t.substring(1);
		}
		var iE=t.indexOf("E");
		if(iE<0)iE=0;
		else
		{
			iL=parseInt(t.substring(iE+1));
			t=t.substring(0,iE);
			iE=iL;
		}
		iL=t.length;
		while(++i<iL)//remove dot
		{
			c=t.charCodeAt(i);
			if(c<48||c>57){t=t.substring(0,i)+t.substring(i+1);iL--;break;}
		}
		//if dot,remove trailing 0s
		while(i<iL){if(t.charCodeAt(iL-1)!=48)break;t=t.substring(0,--iL);}
		if(iE!=0)
		{
			while(iE-->0)if(i++>=iL)t+="0";
			if(++iE<0){if(i==0)t="0"+t;while(++iE<0)t="0"+t;t="0"+t;i=1;}
		}
		iL=i;
		var iDec=0;
		if(this.decimals>0&&iL<t.length)
		{
			iDec=t.length-iL;
			t=t.substring(0,iL)+dec+t.substring(iL);
			iL+=dec.length+this.decimals;
		}
		if(iL<t.length)t=t.substring(0,iL);
		if((iL=this.minDecimals)!=0){if(iDec==0)t+=dec;while(iL-->iDec)t+="0";}
		if(foc)return v?(m+t):t;
		var g0=(this.groups.length>0)?this.groups[0]:0;
		var ig=0,g=g0;
		while(g>0&&--i>0)if(--g==0)
		{
			t=t.substring(0,i)+this.groupSeparator+t.substring(i);
			g=this.groups[++ig];
			if(g==null||g<1)g=g0;
			else g0=g;
		}
		var txt=v?this.negativePattern:this.positivePattern;
		txt=txt.replace("$",me.symbol);
		return txt.replace("n",t);
	}
	me.setText=function(v){this.sTxt=1;this.setValue(v);this.sTxt=0;}
	me.isMinus=function(k){return k==this.minus.charCodeAt(0)||k == 45||k==40||k==12540;}
	me.doKey=function(k,c,t,i,sel0,sel1,bad)
	{
		if(bad)
		{
			if(!(k<9||this.isMinus(k)||(k>=48&&k<=57)||k==this.decimalSeparator.charCodeAt(0)))
				ig_cancelEvent(e);
			return;
		}
		if(sel0!=sel1){t=t.substring(0,sel0)+t.substring(sel1);sel1=sel0;i=t.length;}
		//7-del,8-back
		else if(k==7){if(sel1++>=i||i==0)return;}
		else if(k==8){if(sel0--<1)return;}
		if(k<9||this.maxLength==0||this.maxLength>i)
		{
			var dot=k==this.decimalSeparator.charCodeAt(0);
			var ok=(k>47&&k<58)||(sel0==0&&this.isMinus(k))||(dot&&this.decimals>0);
			if(i>0&&sel0==0)if(this.isMinus(t.charCodeAt(0)))ok=false;
			if(k>8&&!ok)return;
			if(dot)if((dot=t.indexOf(this.decimalSeparator))>=0)
			{
				if(dot==sel0||dot==sel0-1)return;
				i--;
				if(dot<sel0)sel0=--sel1;
				t=t.substring(0,dot)+t.substring(dot+1);
			}
			if(k>8&&sel1>=i)t+=c;
			else t=t.substring(0,sel0)+c+t.substring(sel1);
		}
		else k=0;
		this.elem.value=t;
		this.select((k>10)?sel1+1:sel0);
	}
	me.limits=function(v,r)
	{
		if(v==null&&!this.nullable)v=0;
		if(v!=null)
		{
			var n=this.min,x=this.max;
			if(n!=null&&v<=n)return r?x:n;
			if(x!=null&&v>=x)return r?n:x;
		}
		return v;
	}
	me.getNumber=function(){return this.instant(true,true,true);}
	me.setNumber=function(v){this.setValue(v);}
	me.instant=function(num,limit,v)
	{
		v=(this.fcs==2||v)?this.toNum(this.elem.value,limit==true):this.value;
		if(this._vld==1)this.msV(this.toTxt(v,true,null,"-",this.dec_vld));
		return (num||this.mode>0)?v:this.toTxt(v,true);
	}
	me.getValue=function(num){this._ok();this._vld=1;return this.instant(num,true,true);}
	me.setValue=function(v)
	{
		this.text=this.toTxt(this.value=this.toNum(v,true,true),this.fcs==2);
		this.repaint();
		this.select(1000);
		if(this.fix==1)this.old=this.instant(true);
	}
	me.spin=function(v)
	{
		var val=this.toNum(this.elem.value);
		if(val==null)val=0;
		this.fix=0;this.setValue(val+v);this.fix=1;
	}
	me.getRenderedValue=function(v){return this.toTxt(this.toNum(v),false);}
	return me;
}
function igedit_date(elem,id,prop0,prop1)
{
	var me=igedit_mask(elem,id,prop0,prop1);
	me.mask1=me.dMask(me.valI(prop1,3),true);
	me.nullText=me.valI(prop1,4);
	me.century=prop1[5];
	me.yearFix=prop1[6];
	me.str=me.valI(prop1,7).split(",");
	me.getMaxValue=function(){return this.max;}
	me.setMaxValue=function(v){if(v!=null&&v.getTime==null)v=this.toDate(v.toString(),true);this.max=v;}
	me.getMinValue=function(){return this.min;}
	me.setMinValue=function(v){if(v!=null&&v.getTime==null)v=this.toDate(v.toString(),true);this.min=v;}
	me.getAMPM=function(am){var v=this.valI(this.str,am?0:1);return (v.length>0)?v:(am?"AM":"PM");}
	me.setAMPM=function(v,am){return this.str[am?0:1]=v;}
	me.getMonthNameAt=function(i){return this.valI(this.str,2+i%12);}
	me.setMonthNameAt=function(v,i){return this.str[2+i%12]=v;}
	me.getDowNameAt=function(i){return this.valI(this.str,14+i%7);}
	me.setDowNameAt=function(v,i){return this.str[14+i%7]=v;}
	me.setNow=function(){this.setValue(new Date());}
	me.date=new Date();
	me.isNull=false;
	me.d_s=10;
	me.setText=function(v){this.sTxt=1;this.setValue(v,true);this.sTxt=0;}
	me.fieldValue=function(field,d,e,c)
	{
		//1-y,2-yy,3-yyyy,4-M,5-MM,6-MMM,7-MMMM,8-d,9-dd
		//10-h,11-hh,12-H,13-HH,14-t,15-tt,16-m,17-mm,18-s,19-ss
		//20-ddd,21-dddd,22-f,23-ff,24-fff,25=ffff,26-fffff,27-ffffff,28-fffffff
		var v,i=(field&1)*2;
		if(field<4){v=d.getFullYear()+this.yearFix;if(field==3)i=4;else{v%=100;i=(field==2)?2:0;}}
		else if(field<8){this.d_s=2;v=d.getMonth()+1;if(field>5){field=this.getMonthNameAt(v-1);if(field.length>0)return field;}}
		else if(field<10)v=d.getDate();
		else if(field<16)
		{
			v=d.getHours();
			if(field>13)//ampm
			{
				v=this.getAMPM(v<12);
				if((field-=13)==(i=v.length))return v;
				if(i<field)v+=" ";
				return v.substring(0,field);
			}
			if(field<12){v%=12;if(v==0)v=12;}
		}
		else if(field<18)v=d.getMinutes();
		else if(field<20)v=d.getSeconds();
		else if(field<22)return this.getDowNameAt(d.getDay());
		else
		{
			v=d.getMilliseconds();
			var j=i=field-21;
			while(j-->3)v*=10;
			while(j++<2)v=Math.floor(v/10);
		}
		v=""+v;
		if(field<20)
		{
			field=v.length;
			if(e){if(i==0)i=2;else e=false;}
			if(i>0){if(i<field)v=v.substring(0,i);else while(field++<i)v=(e?c:"0")+v;}
		}
		return v;
	}
	me.limits=function(d,r)
	{
		if(d==null)return d;
		var v=d.getTime(),n=this.min,x=this.max;
		if(n!=null)n=n.getTime();if(x!=null)x=x.getTime();
		if(n!=null&&v<=n){d.setTime(r?x:n);return d;}
		if(x!=null&&v>=x){d.setTime(r?n:x);return d;}
		return null;
	}
	me.toDate=function(t,foc,limit,fire)
	{
		var fields=(foc&&fire)?this.fields0(t):this.fields1(t,foc);
		//n: 3-ymd,8-invalid,16-limit,32-lastGood
		var v,i0,n=0,i=-1,j=-1,iLen=fields.length,c,y=-1,mo=-1,day=-1,h=-2,m=-2,s=-2,ms=-2,pm=-1;
		var any=false,arg=new Object();
		while(++i<iLen)
		{
			j++;v=fields[i];i0=foc?this.field0IDs[i]:this.field1IDs[i];
			if(i0<4){if(v>100&&v>this.yearFix)v-=this.yearFix;if((arg.year=y=v)<0)n|=8;else{n++;c=this.century;if(v<100){if(i0<3&&c<0)c=29;if(c>=0)y+=(v>c)?1900:2000;}}}
			else if(i0<8){arg.month=mo=v;if(v<1||v>12)n|=8;else n++;}
			else if(i0<10){arg.day=day=v;if(v<1||v>31)n|=8;else n++;}
			else if(i0<14)
			{
				if(v==24)v=0;
				if(i0>11)pm=-4;else{if(v==12)v=0;if(v>12)n|=8;}
				arg.hours=h=v;if(v>23||v<0)n|=8;
			}
			else if(i0<16){j--;if(v>0)pm++;continue;}
			else if(i0<18){arg.minutes=m=v;if(v>59||v<0)n|=8;}
			else if(i0<20){arg.seconds=s=v;if(v>59||v<0)n|=8;}
			else if(i0<22){j--;continue;}
			else{while(i0++<24)v*=10;while(i0-->25)v=Math.floor(v/10);arg.milliseconds=ms=v;if(v>999||v<0)n|=8;}
			if(v>=0)any=true;
			if(j<this.minF&&n>7)n|=32;
		}
		if(pm==0&&h>=0&&h<12)arg.hours=(h+=12);
		var inv=fire?(":"+y+","+mo+","+day+","+h+","+m+","+s+","+ms+","):"";
		var d=null;
		if((n&3)==3){d=new Date(y,mo-1,day);if(y<100)d.setFullYear(y);}
		else if(n<30)
		{
			d=new Date();if(this.date)d.setTime(this.date.getTime());
			if(day>0)d.setDate(day);if(y>=0)d.setFullYear(y);if(mo>0)d.setMonth(mo-1);
		}
		n&=15;
		if(day>0&&d!=null)if(day!=d.getDate())n|=8;
		day=this.good;
		if(fire&&d==null&&!this.nullable)
		{
			d=day;
			if(d==null||d.getTime==null){d=new Date();n|=8;}else n|=32;
		}
		if(d!=null)
		{
			if(h>-2)d.setHours((h<0)?0:h);if(m>-2)d.setMinutes((m<0)?0:m);
			if(s>-2)d.setSeconds((s<0)?0:s);if(ms>-2)d.setMilliseconds((ms<0)?0:ms);
			if(limit){if((d=this.limits(i=d))!=null)n=16;else d=i;}
		}
		if(fire)
		{
			if(any&&d==null&&t.length>0&&day!=null&&day.getTime!=null){d=day;n=32;}
			arg.date=d;
			if(n<8||(n==8&&!any&&this.nullable))inv="";
			else
			{
				inv+=(arg.type=(n<16)?2:((n==16)?1:0));
				if(this.fireEvent(13,null,arg))inv="";
				d=arg.date;
			}
			this.updatePost(d,inv);
			if(day!=false)this.good=d;
		}
		return d;
	}
	me.updatePost=function(d,inv)
	{
		if(d!=null)inv=""+d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()+"-"+d.getHours()+"-"+d.getMinutes()+"-"+d.getSeconds()+"-"+d.getMilliseconds()+inv;
		this.elemViewState.value=inv;
		this.valid((d==null)?"":this.toTxt(d,true,""));
	}
	me.enter0=function()
	{
		var d=this.toDate(this.elem.value,true);
		return (d==null)?"":this.toTxt(d,true,"");
	}
	me.toTxt=function(d,foc,prompt,txt)
	{
		var t="",mask=foc?this.mask:this.mask1;
		if(d==null)return foc?this.getTxt(5,prompt,txt?(this.txt=mask):mask):this.nullText;
		var ids=foc?this.field0IDs:this.field1IDs;
		var c,k,i=-1,f0=0;
		this.d_s=6;//seconds
		while(++i<mask.length)
		{
			c=mask.charAt(i);
			if((k=mask.charCodeAt(i))<21)
			{
				t+=this.fieldValue(ids[f0++],d,foc,c);
				if(foc)while(i+1<mask.length)if(mask.charCodeAt(i+1)==k)i++;else break;
			}
			else t+=c;
		}
		if(!foc)return t;
		if(txt)this.txt=t;
		return this.getTxt(5,prompt,t);
	}
	me.focusTxt=function(foc,e,t)
	{
		var d=null,prompt="";
		if(t==null)
		{
			prompt=this.promptChar;
			//key-press
			if(e==null&&foc)return this.getTxt(5,prompt);
			if(e!=null&&!foc)
			{
				//""-from update=lostFocus
				d=this.toDate(this.elem.value,e==="",true,true);
				if(!(this.isNull=(d==null)))this.date=d;
			}
			else if(!this.isNull)d=this.date;
		}
		else d=this.toDate(t,foc,true);
		return this.toTxt(d,foc,prompt,e!=null);
	}
	me.fields1=function(t,foc)
	{
		var ids=foc?this.field0IDs:this.field1IDs;
		var iLen=ids.length;
		var j,i=-1,v=-1,field=0,fields=new Array(iLen);
		while(++i<iLen)fields[i]=-1;
		if(t==null)return fields;
		t=t.toUpperCase();
		i=-1;
		while(++i<t.length&&field<iLen)
		{
			var k=this.jpn(t.charCodeAt(i))-48,j=ids[field];
			if(j==20||j==21)j=ids[++field];//dow
			if(j==14||j==15)//ampm
			{
				if(k>=0&&k<=9){v=-1;field++;i--;continue;}
				if(this.getAMPM(false).charAt(0).toUpperCase()==t.charAt(i))
				{fields[field++]=1;v=-1;}
			}
			else
			{
				if(k>=0&&k<=9){if(v<0)v=k;else v=v*10+k;}
				else
				{
					if(v>=0){fields[field++]=v;v=-1;}
					else if(j==6||j==7)while(v-->-3)//MMM
					{
						for(k=0;k<12;k++)
						{
							var m=this.getMonthNameAt(k).toUpperCase();
							if((j=m.length)<1)continue;
							if(v==-3){if(j<4)continue;m=m.substring(0,3);}
							if((j=t.indexOf(m)-1)>-2)if(j<0||t.charAt(j).toLowerCase()==t.charAt(j))break;
						}
						if(k<12){fields[field++]=k+1;break;}
					}
				}
			}
		}
		if(field<iLen)fields[field]=v;
		return fields;
	}
	me.fields0=function(t)
	{
		var fields=new Array();
		if(t==null)t="";
		var x,k,i=-1,v=-1,field=-1,n=22;
		while(++i<this.mask.length)
		{
			if((x=this.mask.charCodeAt(i))>21&&n>21)continue;
			if(x>21){if(field>=0)fields[field]=v;}
			else
			{
				if(n>21){v=-1;field++;}
				if(i>=t.length)continue;
				if(x>18)
				{
					k=this.jpn(t.charCodeAt(i))-48;
					if(k>=0&&k<=9){if(v<0)v=k;else v=v*10+k;}
				}
				else if(n!=x)if(this.getAMPM(false).charAt(0).toUpperCase()==t.charAt(i).toUpperCase())
					v=1;
			}
			n=x;
		}
		fields[field]=v;
		return fields;
	}
	me.curField=function(s,mask)
	{
		var x,n=22,field=this.n0=this.n1=-1;
		for(var i=0;i<mask.length;i++)
		{
			if(((x=mask.charCodeAt(i))>21)==(n>21))continue;
			if(x>21){if(i>=s)break;}
			else{this.n0=i;field++;}
			n=x;
		}
		if(this.n0>=0)this.n1=i;
		if((field=this.field0IDs[field])==null)return -1;
		if(field<8)return (field<4)?0:1;
		if(field<20)return Math.floor((field-4)/2);
		return (field>21)?8:-1;
	}
	me.key=function(k,c,t,i,s,mask)
	{
		var n=0,v=-1,field=this.curField(s,mask);
		if(s>=this.n1)if(t.charCodeAt(--s)>21)return this.key(k,c,t,i,s+2,mask);
		if(field<0)return -1;
		if(field==5)//ampm
		{
			if(s<=this.n0)
			{
				v=this.getAMPM(false);
				if(v.charAt(0).toUpperCase()!=c.toUpperCase())v=this.getAMPM(true);
				if(this.n1==this.n0+1)v=v.charAt(0);
				else if((i=v.length)<2)v+=" ";else if(i>2)v=v.substring(0,2);
				this.txt=t.substring(0,this.n0)+v+t.substring(this.n1);
			}
			return this.n1;
		}
		if(k<48||k>57)
		{
			if(s==0||(k!=47&&k!=58&&(k<44||k>57)))return -1;
			if(mask.charCodeAt(s-1)>=21||this.n1==i)return s;
			while(s<i)
			{
				if(mask.charCodeAt(s++)>=21)break;
				t=t.substring(0,s-1)+mask.charAt(s-1)+t.substring(s);
			}
			this.txt=t;
			return s;
		}
		k-=48;
		if(this.n0==s)
		{
			v=t.charCodeAt(s+1)-48;
			//0-y,1-M,2-d,3-h,4-H,5-AMPM,6-m,7-s,8-ms
			switch(field)
			{
				case 4:k--;v-=2;
				case 3:case 1:if(k>1)n=1;else if(k==1&&v>2)n=2;break;
				case 2:if(k>3)n=1;else if(k==3&&v>1)n=2;break;
				case 6:case 7:if(k>6)n=1;else if(k==6&&v>0)n=2;break;
				default:break;
			}
		}
		if(this.n0+1==s)
		{
			v=t.charCodeAt(s-1)-48;
			switch(field)
			{
				case 4:v--;k-=2;
				case 3:case 1:if(v>1||(v==1&&k>2))n=3;break;
				case 2:if(v>3||(v==3&&k>1))n=3;break;
				case 6:case 7:if(v>6||(v==6&&k>0))n=3;break;
				default:break;
			}
		}
		if(n==1){t=t.substring(0,s)+mask.charAt(s)+t.substring(s+1);s++;}
		if(n==2)t=t.substring(0,s+1)+mask.charAt(s+1)+t.substring(s+2);
		if(n==3)
		{
			while(++s<i)if(mask.charCodeAt(s)<21)break;
			if(s>=i)return -1;
			return this.key(k+48,c,t,i,s,mask);
		}
		this.txt=t.substring(0,s)+c+t.substring(s+1);
		return ++s;
	}
	me.spin=function(v)
	{
		var x,i=this.spinF,d=new Date();
		d.setTime(this.date.getTime());
		if(i<0||i>8)
		{
			if(this.fcs==2)
			{
				this.getSelectedText();
				i=this.curField(this.sel0,this.mask);
				if((d=this.toDate(this.elem.value,true,true,true))==null)d=new Date();
				this.spinF=i;
			}
			else this.spinF=i=this.d_s;
		}
		//0-y,1-M,2-d,3-h,4-H,5-AMPM,6-m,7-s,8-ms
		if(i==5)v=(v>0)?12:-12;
		x=this.spinOnlyOneField;
		switch(i)
		{
			case 0:d.setFullYear(v+=d.getFullYear());if(x&&v!=d.getFullYear())i=-1;break;
			case 1:d.setMonth(v+=d.getMonth());if(x&&v!=d.getMonth())i=-1;break;
			case 2:d.setDate(v+=d.getDate());if(x&&v!=d.getDate())i=-1;break;
			case 3:case 4:case 5:i=d.getDate();d.setHours(v+=d.getHours());if(x&&i!=d.getDate())i=-1;break;
			case 6:d.setMinutes(v+=d.getMinutes());if(x&&v!=d.getMinutes())i=-1;break;
			case 7:d.setSeconds(v+=d.getSeconds());if(x&&v!=d.getSeconds())i=-1;break;
			case 8:for(i=this.n1-this.n0;i++<3;)v*=10;
				d.setMilliseconds(v+=d.getMilliseconds());if(x&&v!=d.getMilliseconds())i=-1;break;
		}
		if(i<0)return;
		if((v=this.limits(d))!=null)d=v;
		this.text=this.toTxt(d,this.fcs==2,this.promptChar,true);
		this.date=d;this.isNull=false;
		this.updatePost(d,"");
		this.repaint();this.select(this.sel0);
	}
	me.getDate=function(){return this.instant(true);}
	me.setDate=function(v){this.setValue(v);}
	me.getValueByMode=function(vt,limit)
	{
		this._ok();
		var d=(this.fcs<2)?(this.isNull?null:this.date):this.toDate(this.elem.value,true,limit);
		if(this._vld==1)this.msV(d?this.toTxt(d,true,""):"");
		if(vt==0)return d;
		return this.toTxt(d,vt==1,this.emptyChar);
	}
	me.instant=function(date,limit){return this.getValueByMode(date?0:this.mode,limit==true);}
	me.date_7=function(v)
	{
		if(v.length<10)return null;
		var y,o=v.split("-");
		if(o.length<7)return null;
		v=new Date(y=this.intI(o,0),this.intI(o,1),this.intI(o,2),this.intI(o,3),this.intI(o,4),this.intI(o,5),this.intI(o,6));
		if(y<100)v.setFullYear(y);
		return v;
	}
	me.getValue=function(date){this._ok();this._vld=1;return this.instant(date,true);}
	me.setValue=function(v,o)
	{
		if(v!=null&&v.getTime==null)
		{
			if(this.fcs<0)
			{
				if(v.length<8)v="";
				o=v.split(",");
				if(o.length>2)this.max=this.date_7(o[2]);
				if(o.length>1)this.min=this.date_7(o[1]);
				v=this.date_7(o[0]);
			}
			else v=this.toDate(v.toString(),this.mode<2&&o!=true);
		}
		o=v;
		if((v=this.limits(v))==null)v=o;
		this.txt=this.mask;
		if(this.isNull=(v==null))v=new Date();
		else this.toTxt(v,true,"",true);
		this.date=v;
		if(this.good!=false)this.good=v;
		this.text=this.focusTxt(this.fcs>1);
		this.updatePost(this.isNull?null:v,"");
		this.repaint();
		if(this.fix==1)this.old=this.instant(true);
	}
	me.getRenderedValue=function(v)
	{
		if(v!=null&&v.getTime==null)v=this.toDate(v.toString(),false);
		return this.toTxt(v,false,"");
	}
	return me;
}
function igedit_mask(elem,id,prop0,prop1)
{
	var me=new igedit_new(elem,id,prop0);
	var prop=me.valI(prop1,2);
	me.promptChar=prop.charAt(0);
	me.padChar=prop.charAt(1);
	me.emptyChar=prop.charAt(2);
	me.mode=parseInt(prop.charAt(3));
	me.minF=parseInt(prop.charAt(4));
	me.good=prop.length>5;
	me.flag=function(c,u)
	{
		switch(c)
		{
			case '>':return -1;case '<':return -2;
			case '&':c=1;break;case 'C':c=2;break;
			case 'A':c=7;break;case 'a':c=8;break;
			case 'L':c=13;break;case '?':c=14;break;
			case '#':case '0':return 19;
			case '9':return 20;
			default:return 0;
		}
		return c+u*2;
	}
	me.filter=function(flag,s,i,sf)
	{
		if(i>=s.length)return sf;
		var c=s.charCodeAt(i),f=Math.floor((flag-1)/6);
		s=s.charAt(i);
		if(c<21)return sf;
		if(f==1||f==3)if(c>100)if((c=this.jpn(c))<100)s=String.fromCharCode(c);
		switch(f)
		{
			case 0:break;
			case 1:if(c>47&&c<58)return s;
			case 2:if(c>255||s.toUpperCase()!=s.toLowerCase())break;return sf;
			case 3:return (c>47&&c<58)?s:sf;
		}
		if((flag=Math.floor((flag-1)/2)%3)==0)return s;
		return (flag==2)?s.toLowerCase():s.toUpperCase();
	}
	me.getTxt=function(vt,prompt,t)
	{
		var flag,mask=this.mask,o="",non=(t!=null);
		if(!non)t=(this.bad!=0&&this.fcs>1)?this.elem.value:this.txt;
		if(non||this.fcs<0)non=this.minF==0;
		if(t==null||mask==null)return o;
		for(var i=0;i<mask.length;i++)if((flag=mask.charCodeAt(i))<21)
		{
			if(i<t.length&&t.charCodeAt(i)>=21){o+=t.charAt(i);non=false;}
			else if(vt%3==2||(vt%3==1&&(flag&1)==1))o+=prompt;
		}
		else if(vt>=3)o+=mask.charAt(i);
		return non?"":o;
	}
	me.setTxt=function(v,vt,render)
	{
		var c,flag,j=0,i=-1,mask=this.mask,t=this.mask;
		if(v!=null)while(++i<mask.length)
		{
			if(vt==1000+j)vt=this.mode;
			if(j>=v.length)break;
			if((flag=mask.charCodeAt(i))<21)
			{
				if((c=this.filter(mask.charCodeAt(i),v,j))!=null)t=t.substring(0,i)+c+t.substring(i+1);
				j++;
			}
			else if(vt>=3)j++;
		}
		if(render)return t;
		this.txt=t;
		this.text=this.focusTxt(this.fcs>1," ");
		this.repaint();
	}
	me.getInputMask=function(){return this.m0;}
	me.setInputMask=function(mask)
	{
		if(mask==null)mask="";
		this.m0=mask;
		var x,c,i,i0=0,u=0,n="",t="",t0=this.getTxt(0);
		for(i=0;i<mask.length;i++)
		{
			if((x=this.flag(c=mask.charAt(i),u))!=0)
			{
				if(x<0){u=(u==-x)?0:-x;continue;}
				n+=(c=String.fromCharCode(x));
				c=this.filter(x,t0,i0++,c);
			}
			else if(c=="\\"&&i+1<mask.length&&this.flag(mask.charAt(i+1),0)!=0)
				n+=(c=mask.charAt(++i));
			else n+=c;
			t+=c;
		}
		this.txt=t;this.mask=n;
	}
	me.dMask=function(v,d)
	{
		if(this.field0IDs==null)this.field0IDs=new Array();
		if(this.field1IDs==null)this.field1IDs=new Array();
		if(v==null)v="";
		var x,i,i0=0,flag=-1,t="";
		for(i=0;i<v.length;i++)
		{
			x=v.charCodeAt(i);
			if(x<48||x>57)
			{
				if(d==true&&(flag=v.charAt(i))=="\\"&&i+1<v.length)
				{
					if((x=v.charAt(++i))=="\\")continue;
					if(x=="0"||x=="9")t+=flag;
					t+=x;
				}
				else t+=v.charAt(i);
				continue;
			}
			flag=(x-48)*10+v.charCodeAt(++i)-48;
			if(d==true){this.field1IDs[i0++]=flag;t+="\01";continue;}
			this.field0IDs[i0++]=flag;
			if(flag==14)t+="L";else if(flag==15)t+="LL";
			else if(flag==22)t+="#";
			else{t+="##";if(flag==3)t+="##";while(flag-->23)t+="#";}
		}
		return t;
	}
	prop=me.valI(prop1,1);
	if(prop1.length>3)prop=me.dMask(prop);
	me.setInputMask(prop);
	me.focusTxt=function(foc,e)
	{
		var t=null;
		if(e!=null&&!foc)
		{
			e=e!=="";
			if(e&&this.bad!=0)this.txt=this.setTxt(this.elem.value,5,true);
			t=this.txt;
			var inv=t.length;
			if(!e&&this.hadFocus)
			{
				var iL=inv-this.elem.value.length,s0=this.sel0,s1=this.sel1;
				if(iL>0&&s1-s0==iL)
					this.txt=t=t.substring(0,s0)+this.mask.substring(s0,s1)+t.substring(s1);
			}
			while(inv-->0)
			{
				var c=t.charCodeAt(inv);
				if(c<21&&(c&1)==1)break;
			}
			if(!e&&inv>=0)if(this.fireEvent(13))inv=-1;
			this.elemViewState.value=(t=this.txt)+((inv<0)?"":String.fromCharCode(30));
			this.valid(this.getTxt(this.mode,""));
		}
		return this.getTxt(foc?5:4,foc?this.promptChar:this.padChar,t);
	}
	me.enter0=function(){return this.getTxt(this.mode,"");}
	me.setText=function(v,s){this.sTxt=1;this.setTxt(v,(s==null)?5:(1000+s));this.sTxt=0;if(this.fix==1)this.old=this.instant(true);}
	me.key=function(k,c,t,i,s,mask){return -2;}
	me.doKey=function(k,c,t,i,sel0,sel1,bad)
	{
		if(i<1||k<7||(k>8&&k<32))k=0;
		if(bad)
		{
			if(k==0||(this.getAMPM!=null&&!(this.mask.indexOf(c)>0||this.getAMPM(false).indexOf(c)>=0||this.getAMPM(true).indexOf(c)>=0||(k>=48&&k<=57))))
				ig_cancelEvent(e);
			return;
		}
		if(k==0)return;
		t=this.txt;
		var mask=this.mask;
		if(sel0!=sel1){while(--sel1>=sel0)t=t.substring(0,sel1)+mask.charAt(sel1)+t.substring(sel1+1);sel1++;}
		else if(k==7)//del
		{
			while(sel1<i&&mask.charCodeAt(sel1)>=21)sel1++;
			if(sel1>=i)return;
			t=t.substring(0,sel1)+mask.charAt(sel1)+t.substring(sel1+1);
			sel1++;
		}
		else if(k==8)//back
		{
			while(sel1>0&&mask.charCodeAt(sel1-1)>=21)sel1--;
			if(sel1--<1)return;
			t=t.substring(0,sel1)+mask.charAt(sel1)+t.substring(sel1+1);
		}
		if(k>8&&sel1<i)
		{
			if(sel1>=i)return;
			if((sel0=this.key(k,c,t,i,sel1,mask))>=0){t=this.txt;sel1=sel0;}
			else{if(sel0==-1)return;while(mask.charCodeAt(sel1)>=21)if(++sel1>=i)return;}
			if(sel0>=0){t=this.txt;sel1=sel0;}
			else
			{
				if((c=this.filter(mask.charCodeAt(sel1),c,0))==null)return;
				t=t.substring(0,sel1)+c+t.substring(sel1+1);
				sel1++;
			}
		}
		this.txt=t;
		this.elem.value=this.focusTxt(true);
		this.select(sel1);
	}
	me.getValueByMode=function(vt){return this.getTxt(vt,this.emptyChar);}
	me.instant=function(){return this.getValueByMode(this.mode);}
	me.getValue=function(){this._ok();this.msV(this.getTxt(this.mode,""));return this.instant();}
	me.setValue=function(v){this.setTxt(v,(this.fcs<0)?2:this.mode);if(this.fix==1)this.old=this.instant(true);}
	me.getRenderedValue=function(v)
	{
		v=(v==null)?"":v.toString();
		return this.getTxt(4,this.padChar,(this.mode==5)?v:this.setTxt(v,this.mode,true));
	}
	return me;
}
function igedit_new(elem,id,prop0)
{
	this.fcs=-1;
	this.valI=function(o,i){o=(o==null||o.length<=i)?null:o[i];return (o==null)?"":o;}
	this.intI=function(o,i){return ig_csom.isEmpty(o=this.valI(o,i))?-1:parseInt(o);}
	this.initButElem=function(e,c)
	{
		if(e==null)return;
		if(e.nodeName.toUpperCase()=="IMG"||e.nodeName.toUpperCase()=="TD")
		if(c==null)
		{
			ig_csom.addEventListener(e,"mousedown",igedit_event);
			ig_csom.addEventListener(e,"mouseup",igedit_event);
			ig_csom.addEventListener(e,"mousemove",igedit_event);
			ig_csom.addEventListener(e,"mouseout",igedit_event);
			e.unselectable="on";
		}
		else if(!ig_csom.isEmpty(e.bgColor)){e.bgColor=c;e.style.color=c;}
		if(e.childNodes!=null)for(var i=0;i<e.childNodes.length;i++)this.initButElem(e.childNodes[i],c);
	}
	this.focusTxt=function(foc,e)
	{
		if(e!=null&&!foc)this.valid(this.elemViewState.value=this.elem.value);
		return this.elem.value;
	}
	this.elemID=-10;
	this.bad=0;
	this.Element=elem;
	elem.Object=this;
	this.eventID=function(s)
	{
		switch(s.toLowerCase())
		{
			case "keydown":return 0;
			case "keypress":return 1;
			case "keyup":return 2;
			case "mousedown":return 3;
			case "mouseup":return 4;
			case "mousemove":return 5;
			case "mouseover":return 6;
			case "mouseout":return 7;
			case "focus":return 8;
			case "blur":return 9;
			case "initialize":return 10;
			case "valuechange":return 11;
			case "textchanged":return 12;
			case "invalidvalue":return 13;
			case "custombutton":return 14;
			case "spin": return 15;
		}
		return -1;
	}
	this.events=new Array(16);
	this.evtH=function(n,fRef,add,o)
	{
		if(n<0||n>15)return;
		var e=this.events[n];
		if(e==null){if(add)e=this.events[n]=new Array();else return;}
		for(n=0;n<e.length;n++)if(e[n]!=null&&e[n].fRef==fRef)
		{if(!add){delete e[n];e[n]=null;}return;}
		if(add)for(n=0;n<=e.length;n++)if(e[n]==null)
		{e[n]=new Object();e[n].fRef=fRef;e[n].o=o;break;}
	}
	this.removeEventListener=function(name,fref){this.evtH(this.eventID(name),fref,false);}
	this.addEventListener=function(name,fref,o){this.evtH(this.eventID(name),fref,true,o);}
	this.getRenderedValue=function(v){return (v==null)?"":v.toString();}
	var o,ii,j,i=0,e=ig_csom.getElementById(id+"_p");
	if(e==null)e=new Object();
	e.value=String.fromCharCode(30);
	this.elemViewState=e;
	if((e=ig_csom.getElementById(id))==null)if((e=ig_csom.getElementById(id.substring(1)))==null)e=new Object();
	this.elemValue=e;
	this.uniqueId=prop0[i++];
	e=prop0[i++];
	if(e.length>2)
	{
		e=e.split(" ");
		for(j=0;j<e.length-1;j+=2)
			try{this.evtH(this.intI(e,j),eval(this.valI(e,j+1)),true);}catch(ex){}
	}
	this.nullable=!ig_csom.isEmpty(prop0[i++]);
	this.postValue=!ig_csom.isEmpty(prop0[i++]);
	this.postButton=!ig_csom.isEmpty(prop0[i++]);
	this.postEnter=!ig_csom.isEmpty(prop0[i++]);
	this.maxLength=this.intI(prop0,i++);
	this.spinDelta=ig_csom.isEmpty(o=this.valI(prop0,i++))?1:parseFloat(o);
	this.spinOnArrows=!ig_csom.isEmpty(prop0[i++]);
	this.spinOnlyOneField=!ig_csom.isEmpty(prop0[i++]);
	this.hideEnter=!ig_csom.isEmpty(prop0[i++]);
	this.selectionOnFocus=this.intI(prop0,i++)-1;
	this.allowAlt=!ig_csom.isEmpty(prop0[i++]);
	this.roll=!ig_csom.isEmpty(prop0[i++]);
	this.css=this.intI(prop0,i++);
	this.repaint=function(){if(this.elem.value==this.text)return;this.elem.value=this.text;}
	if((e=ig_csom.getElementById(id+"_t"))==null)e=elem;
	this.elem=e;
	if(!igedit_all._end)
	{
		igedit_all._end=true;
		ig_csom.addEventListener(window,"unload",igedit_event);
		if(e.form)ig_csom.addEventListener(e.form,"submit",igedit_event);
	}
	o=e.parentNode;
	ii=this.buttons?e.offsetHeight:0;
	if(ii&&ii>5)o.height=ii+"px";
	o.removeChild(e);
	ig_csom.addEventListener(e,"keydown",igedit_event);
	ig_csom.addEventListener(e,"keypress",igedit_event);
	ig_csom.addEventListener(e,"keyup",igedit_event);
	ig_csom.addEventListener(e,"focus",igedit_event);
	ig_csom.addEventListener(e,"blur",igedit_event);
	ig_csom.addEventListener(e,"mousedown",igedit_event);
	ig_csom.addEventListener(e,"mouseup",igedit_event);
	ig_csom.addEventListener(e,"mousemove",igedit_event);
	ig_csom.addEventListener(e,"mouseover",igedit_event);
	ig_csom.addEventListener(e,"mouseout",igedit_event);
	o.appendChild(e);
	if(ii&&ii>5)
	{
		//server flag
		if(ig_csom.notEmpty(j=elem.style.height))if(j.indexOf("%")<0){j=1;e.style.height=ii+"px";}
		o=this.buttons;
		if(o[1])if((o=o[1].elem)!=null)
		{
			if(j==1){o.style.height=(j=Math.ceil(ii/2))+"px";this.buttons[2].elem.style.height=(ii-j)+"px";}
			for(j=0;j<4;j++){o=o.parentNode;if(o.tagName=="TABLE"){o.style.height=ii+"px";break;}}
		}
	}
	this.ID=id;
	if(id.indexOf("x_")==0)this.ID_=id.substring(1);
	e.setAttribute("editID",id);
	this.k0=this.sel0=this._wh=0;
	this.getEnabled=function(){return !this.elem.disabled;}
	this.setEnabled=function(v)
	{
		if(this.elem.disabled==!v)return;this.elem.disabled=!v;
		for(var i=0;i<3;i++)this.butState(i,v?0:3);
	}
	if(this.css>=0)
	{
		this.butP=-1;this.butL=1;
		this.buttons=new Array(3);
		for(j=0;j<3;j++)
		{
			if((e=ig_csom.getElementById(id+"_b"+j))==null)i+=4;
			else
			{
				this.initButElem(e);
				e.setAttribute("editID",id+","+j);
				o=new Object();o.elem=e;o.img=new Array(4);
				for(ii=0;ii<4;ii++)o.img[ii]=this.valI(prop0,i++);
				o.state=this.getEnabled()?0:3;this.buttons[j]=o;
			}
		}
		ii=1;
		if((o=this.intI(prop0,i++))<0)ii=8;
		else{while(o++<3)ii/=2;while(o-->4)ii*=2;}
		this.spinSpeedUp=ii;
		this.spinOnReadOnly=!ig_csom.isEmpty(prop0[i++]);
		this.spinDelay=this.intI(prop0,i++);
		this.spinFocus=!ig_csom.isEmpty(prop0[i++]);
		this.ccss=new Array(4);
		for(ii=0;ii<4;ii++){o=this.valI(prop0,i++);if(o.length>0)o=" "+o;this.ccss[ii]=o;}
		this._wh=this.intI(prop0,i++);
	}
	this.getVisible=function(){return this.Element.style.display!="none";}
	this.setVisible=function(v,x,y,w,h)
	{
		var d,s0=this.Element,s1=this.elem,hd=this.hd;if(s0==s1)hd=0;
		if(!v&&this.fcs>0)s1.blur();
		s0.style.display=v?"":"none";
		s0.style.visibility=v?"visible":"hidden";
		if(!v)return;
		if(hd==null)
		{
			hd=s0.offsetHeight;d=s1.offsetHeight;
			if(hd==null||hd<5||d==null||d<5)hd=0;
			else if((hd-=d)<0)hd=0;
			this.hd=hd;
		}
		s0=s0.style;s1=s1.style;
		if(x!=null){s0.position="absolute";s0.left=x+"px";s0.top=y+"px";}
		if(w!=null){s0.width=w+"px";if(s1!=s0)s1.width="100%";}
		if(h!=null)
		{
			s0.height=h+"px";
			s1.height=(h-=hd)+"px";
			if(this.buttons!=null)
			{
				d=this.buttons[0];
				if(d!=null)if((d=d.elem)!=null)d.style.height=h+"px";
				d=this.buttons[1];
				if(d!=null)if((d=d.elem)!=null)
				{
					try{h-=parseInt(this.Element.cellSpacing);}catch(e){}
					d.style.height=Math.floor(h/2)+"px";
					this.buttons[2].elem.style.height=Math.ceil(h/2)+"px";
				}
			}
		}
		if(v)this.focus();
	}
	this.getReadOnly=function(){return this.elem.readOnly;}
	this.setReadOnly=function(v){this.elem.readOnly=v;}
	this.getText=function(){var v=this.elem.value;this.msV(v);return v;}
	this.setText=function(v){this.elemValue.value=this.elemViewState.value=this.text=v;this.repaint();if(this.fix==1)this.old=this.instant(true);}
	this.instant=function(){return this.getText();}
	this.getValue=function(){this._ok();return this.instant();}
	this.setValue=function(v){this.setText(""+((v==null)?"":v));}
	this.spinF=-1;
	this.spin_=function(v)
	{
		if(this.fireEvent(15,null,v))return;
		var t=this.elem.value;
		this.spin(v);
		if(this.elem.value==t&&this.roll&&this.min!=null&&this.max!=null)
		{
			v=this.sel0;
			this.setValue(this.limits(this.getValue(true),true));
			this.select(v);
		}
		if(this.elem.value!=t)this.fireEvent(12,null);
	}
	this.spin=function(v){}
	this.doKey=function(k,c,t,i,sel0,sel1)
	{
		if(sel0!=sel1){t=t.substring(0,sel0)+t.substring(sel1);sel1=sel0;i=t.length;}
		//7-del,8-back
		else if(k==7){if(sel1++>=i||i==0)return;}
		else if(k==8){if(sel0--<1)return;}
		if(k<9||this.maxLength==0||this.maxLength>i)
		{
			if(k>8&&sel1>=i)t+=c;
			else t=t.substring(0,sel0)+c+t.substring(sel1);
		}
		else k=0;
		this.elem.value=t;
		this.select((k>10)?sel1+1:sel0);
	}
	this.doKey0=function(e,a)
	{
		var t0=this.text,t1=this.elem.value,k=e.keyCode;
		if(a!=1)this._np=2-a;else if(this._np!=2)this._np=1;
		if(this.fcs!=2||(k==114&&a!=1)||k==9)return;
		if(k==0||k==null)if((k=e.which)==null)return;
		if(this.bad>2){if(a==0)this.bad=2;if(a==2)this.bad-=3;}
		if(a==0&&k==229)if(t0!=t1)this.bad=2;else this.bad+=3;
		if(this.bad==2)return;
		if(e.ctrlKey||e.altKey||k==17)
		{
			if(e.altKey)this.k0=-1;
			else if(t0!=t1)this.paste(t1);
			else if(k==17)this.getSelectedText();
			if(a==0&&(k==38||k==40))this.doBut(e,a,0);
			return;
		}
		if(a==0)this.k0=k;
		if(a==2){if(this.k0>0)this.k0=0;this.spinF=-1;}
		var i=t1.length,bad=this.bad!=0;
		if(k<=46)
		{
			switch(k)
			{
				case 8:case 46://back//del
					if(this.k0==k&&a==1)a=2;
					if(a==0){a=1;if(k==46)k=7;}
					break;
				case 27:ig_cancelEvent(e);return;
				case 13://enter
					if(this.hideEnter)ig_cancelEvent(e);
					else{this.valid(this.enter0());this.update();}
					if(this.postEnter&&a==0){ig_cancelEvent(e);try{window.setTimeout("try{igedit_all['"+this.ID+"'].doPost(2);}catch(e){}",0);}catch(ex){}}
					return;
				case 38:case 40://up//down
					if(a==0&&this.spinOnArrows&&!e.shiftKey)this.spin_((k==38)?this.spinDelta:-this.spinDelta);
					if(this.k0==k)a=2;
					break;
			}
		}
		if(a==1&&k==this.k0&&((k<48&&k>9&&k!=32)||k>90))return;
		if(!bad)
		{
			if(a!=0&&k!=9)ig_cancelEvent(e);
			if(a==1&&this.k0==-1){this.k0=0;if(this.allowAlt)this.getSelectedText();else return;}
			if(a==0||k<9)this.getSelectedText();
		}
		if(a==1&&k>6)
		{
			if(k>31)
			{
				if(this.fireEvent(1,e,k)){if(bad)ig_cancelEvent(e);return;}
				if((a=this.Event)!=null)if((a=a.keyCode)!=null)k=a;
			}
			this.doKey(k,(k<10)?"":String.fromCharCode(k),t1,i,this.sel0,this.sel1,bad);
		}
	}
	this.paste=function(v)
	{
		var m=this.maxLength;if(this._np==1)return;
		if(m>0&&m<v.length)v=v.substring(0,m);
		this.text="";this.fix=0;
		this.setText(v,this.sel0);//mask
		this.fix=1;this.fireEvent(12,null);
	}
	this.spin0=function(b,o)
	{
		var z=0;
		if(o!=null){o.delay=o.spinDelay;ig_csom.edit_o=o;z++;o.spinF=-1;if(o.fcs<1&&o.spinFocus){o._fcs=1;o.focus();}}
		else
		{
			if((o=ig_csom.edit_o)==null)return;
			b=o.buttons!=null&&o.buttons[1].state==2;
			if(o.spinSpeedUp>1){if(o.delay>o.spinDelay/o.spinSpeedUp)z=o.delay=Math.ceil(o.delay*6/7);}
			if(o.spinSpeedUp<1){if(o.delay<o.spinDelay/o.spinSpeedUp)z=o.delay=Math.ceil(o.delay*7/6);}
		}
		o.spin_(b?o.spinDelta:-o.spinDelta);
		if(z==0)return;
		if(ig_csom.edit_f!=null)window.clearInterval(ig_csom.edit_f);
		ig_csom.edit_f=window.setInterval(o.spin0,o.delay);
	}
	this.butState=function(b,s)
	{
		var e,i=-1,bb=this.buttons;
		if(bb!=null)bb=bb[b];
		if(bb==null||bb.state==s)return;
		while(i++<3)if(i!=b&&(e=this.buttons[i])!=null)if(e.state==1||e.state==2)
			this.butState(i,0);
		if(b>0&&(s==2||bb.state==2))
		{
			if(ig_csom.edit_f!=null){window.clearInterval(ig_csom.edit_f);ig_csom.edit_f=null;}
			if(s==2)this.spin0(b==1,this);
		}
		bb.state=s;
		if(this.css>=0)
		{
			if((i=s)>0)i=((this.css&(1<<(s-1)))==0)?0:s;
			if(bb.elem.className!=(e=this.ID+i+this.ccss[s]))bb.elem.className=e;
		}
		if(ig_csom.isEmpty(i=bb.img[s]))if(ig_csom.isEmpty(i=bb.img[0]))return;
		bb=bb.elem.childNodes;
		for(s=0;s<bb.length;s++)
		{
			e=bb[s];
			b=e.nodeName.toUpperCase();
			if(b=="IMG")if(e.src!=i)e.src=i;
			if(b=="TABLE")if(e.ig_color!=i)this.initButElem(e,ig_color=i);
		}
	}
	this.doBut=function(e,a,but)
	{
		ig_cancelEvent(e);
		if(!this.getEnabled()||but>2)return;
		if(but==0)
		{
			if(a<=3)
			{
				if(this.fireEvent(14,e))return;
				if(this.Event.needPostBack||(this.postButton&&!this.Event.cancelPostBack)){this.doPost(1);return;}
				if(a<3)return;
			}
		}
		else if(this.getReadOnly()&&!this.spinOnReadOnly)return;
		if(a==4)this.butP=-1;
		else if(a!=3&&e.button!=0&&this.butP<0)return;
		var b=this.buttons[but].elem;
		if(a==7)
		{
			//fix for inner elems
			var z,x=0,y=0,w=b.offsetWidth,h=b.offsetHeight;
			if(w!=null)
			{
				while(b!=null){x+=b.offsetLeft;y+=b.offsetTop;b=b.offsetParent;}
				z=1;
				if(e.clientX>x+z&&e.clientY>y+z&&e.clientX+z<x+w&&e.clientY+z<y+h)return;
			}
			if(this.butP==0)this.butP=-1;
		}
		b=this.butP;
		if(a==3)
		{
			if(b>=0)this.butState(b,0);
			this.butP=-2;
			if(e.button<2){this.butP=but;this.butL=e.button;this.butState(but,2);}
			return;
		}
		if(e.button==0&&b<-1)b=this.butP=-1;
		if(b>=0&&a==5)if(e.button!=this.butL){b=this.butP=-1;this.butState(but,1);return;}
		if(b<-1||(b>=0&&b!=but))return;
		this.butState(but,(a==7)?0:((b>=0)?2:1));
	}
	this.enter0=function(){return this.elem.value;}
	this.update=function(post)
	{
		this.text=this.focusTxt(false,(this.fcs==2||this.hadFocus)?"":null);//""-still focus
		var v=this.instant(true);
		if(v!=null&&this.old!=null)if(v.getTime!=null&&v.getTime()==this.old.getTime())
			v=this.old;
		if(v!=this.old)
		{
			if(this.fireEvent(11,null,this.old))
			{
				this.fix=0;this.setValue(this.old);this.fix=1;
				this.text=this.focusTxt(false,null);
			}
			else
			{
				if(ig_csom.notEmpty(this.clr1))this.elem.style.color=(v!=null&&v<0)?this.clr1:this.clr0;
				this.old=v;
				if(post&&(this.Event.id!=11||!this.Event.cancelPostBack))this.doPost(3);
			}
		}
	}
	//redirect
	this._ok=function(){if(this._fcs==null&&this.elem.value!=this.text)this.setText(this.elem.value);}
	this.doEvt=function(e)
	{
		var v=this.elemID,type=this.eventID(e.type);
		if(this._fcs==null)
		{
			this._ok();
			try{if(this.elem.selectionStart!=null)this.tr=1;}catch(ex){}
			if(this.tr!=1)this.tr=(this.elem.createTextRange!=null)?this.elem.createTextRange():null;
			this.bad=(this.tr==null)?1:0;
		}
		this._fcs=0;
		//cut from mask
		if(type==5&&this.fcs==2&&e.button==1)this.getSelectedText();
		if(type!=1)if(this.fireEvent(type,e))if(type<8){ig_cancelEvent(e);return;}
		if(v>=0){this.doBut(e,type,v);return;}
		var val=this.elem.value;
		if(type<3)this.doKey0(e,type);
		if(type>=8)
		{
			if(this.bad>2)this.bad=2;
			this.spinF=-1;
			var foc=(type==8);
			if(foc==(this.fcs>0))return;
			v=(!this.getReadOnly()&& this.getEnabled())?2:1;
			this.fcs=foc?v:0;
			if(v==1)return;
			this.hadFocus=!foc;
			if(foc)
			{
				if(val!=this.text){this.getSelectedText();this.paste(val);}
				this.text=this.focusTxt(foc,e);
			}
			else{if(this.bad!=0)this.setText(val);this.update(this.postValue);}
			this.repaint();
			this.select(this.selectionOnFocus*10000);
			this.hadFocus=false;
			return;
		}
		if(val!=this.text&&!(this.webGrid&&type==5&&this.fcs==0))
		{
			if(type>3&&this.k0==0){this.paste(val);return;}
			this.text=val;this.fireEvent(12,e);
		}
	}
	this.fireEvent=function(id,evnt,arg)
	{
		if(id==12)
		{
			if(this.lastText==(arg=this.elem.value))return false;
			this.lastText=this.text=arg;
			if(this.fcs<2&&this._fcs!=1)this.update();
		}
		var evt=this.Event;
		if(evt==null)evt=this.Event=new ig_EventObject();
		evt.id=id;
		var i=evt.srcType=this.elemID;
		evt.srcElement=(i<0)?this.elem:this.buttons[i].elem;
		var evts=this.events[id];
		i=(evts==null)?0:evts.length;
		if(i==0)return false;
		var cancel=false,once=true;
		evt.keyCode=null;
		if(arg==null)
		{
			if(id<3){arg=evnt.keyCode;if(arg==0||arg==null)arg=evnt.which;}
			else arg=this.elem.value;
		}
		while(i-->0)
		{
			if(evts[i]==null)continue;
			if(once){evt.reset();evt.event=evnt;once=false;}
			evts[i].fRef(this,arg,evt,evts[i].o);
			if(evt.cancel)cancel=true;
		}
		if(evt.needPostBack&&id!=14)this.doPost(0);
		return cancel;
	}
	//MS validators
	this.msV=function(v){this._vld=0;if(this.elemValue.value==v)return false;this.elemValue.value=v;return true;}
	this.valid=function(v)
	{
		if(this.msV(v))if(this.fcs>=0&&window.event)
			try{if(window.event.srcElement==this.elem){this.elem.Validators=this.elemValue.Validators;this.elemValue.onchange();}}catch(e){}
	}
	this.select=function(sel0,sel1)
	{
		if(this.fcs!=2||!this.getVisible())return;
		var e=this.elem;
		var i=e.value.length;
		if(sel1==null){sel1=sel0;if(sel0==null||sel0<0){sel0=0;sel1=i;}}
		if(sel1>=i)sel1=i;
		else if(sel1<sel0)sel1=sel0;
		if(sel0>sel1)sel0=sel1;
		this.sel0=sel0;this.sel1=sel1;
		if(this.tr==1){e.readOnly=true;e.selectionStart=sel0;e.selectionEnd=sel1;e.readOnly=false;return;}
		if(this.tr==null){if(sel0!=sel1)try{e.select();}catch(ex){}return;}
		sel1-=sel0;
		this.tr.move("textedit",-1);
		this.tr.move("character",sel0);
		if(sel1>0)this.tr.moveEnd("character",sel1);
		this.tr.select();
	}
	this.getSelectedText=function()
	{
		var r="";
		this.sel0=this.sel1=0;
		if(this.tr==null)return r;
		if(this.tr==1)
		{
			if((this.sel0=this.elem.selectionStart)<(this.sel1=this.elem.selectionEnd))
				r=this.elem.value.substring(this.sel0,this.sel1);
			return r;
		}
		var sel=document.selection.createRange();
		r=sel.duplicate();
		r.move("textedit",-1);
		try{while(r.compareEndPoints("StartToStart",sel)<0)
		{
			if(this.sel0++>1000)break;
			r.moveStart("character",1);
		}}catch(ex){}
		r=sel.text;
		this.sel1=this.sel0+r.length;
		return r;
	}
	this.getSelection=function(start){this.getSelectedText();return start?this.sel0:this.sel1;}
	this.doPost=function(type)
	{
		if(type!=0&&this.Event!=null&&this.Event.cancelPostBack)return;
		if(this.fcs==2)this.update();
		else if(this.fcs==0)try{if(document.activeElement!=null)document.activeElement.fireEvent("onblur");else window.blur();}catch(ex){}
		try{__doPostBack(this.uniqueId,type);}catch(ex){}
	}
	this.focus=function(){try{this.elem.focus();}catch(e){}}
	this.hasFocus=function(){return this.fcs>0;}
	this.jpn=function(k){return(this.sTxt==1&&k>65295&&k<65306)?(k-65248):k;}
}
function igedit_event(e)
{
	if(e==null)if((e=window.event)==null)return;
	var o=e.srcElement,u=e.type=="submit"||(e.type=="unload"&&igedit_all._end);
	if(u)
	{
		igedit_all._end=false;
		for(var i in igedit_all)if((o=igedit_all[i])!=null)
		{if(o.fcs==2)o.update();ig_dispose(o);delete igedit_all[i];}
		return;
	}
	if(o==null)if((o=e.target)==null)o=this;
	if((o=igedit_getById(null,o))!=null)if(o.doEvt!=null)o.doEvt(e);
}

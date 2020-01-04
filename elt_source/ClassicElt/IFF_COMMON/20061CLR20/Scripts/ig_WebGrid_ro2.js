 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid_ro2.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// ig_WebGrid_ro2.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
function igtblro_prepareColumnResize(se)
{
	var head=se.parentNode.parentNode;
	if(!head.id || head.id.length<5 || head.id.substr(head.id.length-5,5)!="_head")
		return;
	var gn=head.id.substr(0,head.id.length-5);
	var cg=new Array();
	cg[0]=igtbl_getElementById("G_"+gn).childNodes[0];
	cg[1]=head.childNodes[0];
	var foot=igtbl_getElementById(gn+"_foot");
	if(foot)
		cg[2]=foot.childNodes[0];
	for(var j=0;j<cg.length;j++)
	{
		for(var i=0;i<cg[j].childNodes.length;i++)
			cg[j].childNodes[i].oldWidth=cg[j].childNodes[i].offsetWidth;
		if(j>0)
			cg[j].parentNode.parentNode.style.width="";
		else
			cg[j].parentNode.style.width="";
		for(var i=0;i<cg[j].childNodes.length;i++)
		{
			if(cg[j].childNodes[i].oldWidth>0)
			{
				cg[j].childNodes[i].style.width="";
				cg[j].childNodes[i].width=cg[j].childNodes[i].oldWidth;
			}
		}
	}
}

function igtblro_onScrollResize(gn)
{
	var grid=igtbl_getElementById("G_"+gn);
	igtblro_scrollStat(gn,grid.parentNode.scrollLeft);
	igtblro_scrollStat(gn,grid.parentNode.scrollLeft,true);
}

function igtblro_scrollStat(gn,scrollLeft,footer)
{
	var grid=igtbl_getElementById("G_"+gn);
	var th;
	if(footer)
		th=igtbl_getElementById(gn+"_foot");
	else
		th=igtbl_getElementById(gn+"_head");
	if(!th)
		return;
	th.parentNode.style.left=-scrollLeft;
	var el=th.childNodes[0];
	var j=0;
	for(var i=0;i<el.childNodes.length;i++)
	{
		var col=el.childNodes[i];
		if(col.style.display=="")
		{
			var colW=grid.childNodes[0].childNodes[j].offsetWidth;
			if(col.offsetWidth!=colW)
				col.style.width=colW;
			j++;
		}
	}
}

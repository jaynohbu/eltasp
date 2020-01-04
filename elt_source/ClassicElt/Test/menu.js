<!--

var isie=0;
if(window.navigator.appName=="Microsoft Internet Explorer"&&window.navigator.appVersion.substring(window.navigator.appVersion.indexOf("MSIE")+5,window.navigator.appVersion.indexOf("MSIE")+8)>=5.5) {
isie=1;
}
else {
isie=0;
}
if(isie) {
var html="";
html+='<TABLE STYLE="border:0pt solid #808080" BGCOLOR="#CCCCCC"  CELLPADDING="1" CELLSPACING="0">';
html+='<ST'+'YLE TYPE="text/css">\n';
html+='a:link {text-decoration:none;font-family:Arial;font-size:8pt;}\n';
html+='a:visited {text-decoration:none;font-family:Arial;font-size:8pt;}\n';
html+='td {font-size:8pt;}\n';
html+='</ST'+'YLE>\n';
html+='<SC'+'RIPT LANGUAGE="JavaScript">\n';
html+='\n<'+'!--\n';
html+='window.onerror=null;\n';
html+='/'+' -'+'->\n';
html+='</'+'SCRIPT>\n';

//html+='<TR><TD STYLE="border:1pt solid #CCCCCC" ID="i5" ONMOUSEOVER="document.all.i5.style.background=\'#CFD6E8\';document.all.i5.style.border=\'1pt solid #737B92\';" ONMOUSEOUT="document.all.i5.style.background=\'#CCCCCC\';document.all.i5.style.border=\'1pt solid #CCCCCC\';" ONCLICK="window.parent.location=\'view-source:\'+window.parent.location.href;">&nbsp;<IMG SRC="/cals/pmis/img/menusource.gif" WIDTH="12" HEIGHT="12" BORDER="0" HSPACE="0" VSPACE="0" ALIGN="absmiddle">&nbsp;View Source</TD></TR>';

//html+='<TR><TD STYLE="border:1pt solid #CCCCCC"><IMG SRC="/cals/pmis/img/pixel.gif" WIDTH="130" HEIGHT="1"></TD></TR>';

html+='<TR><TD><IMG SRC= "print.gif"  ONMOUSEOVER="this.src=\'print_1.gif\'; this.style.cursor = \'hand\';" ONMOUSEOUT="this.src=\'print.gif\';"  ONCLICK="window.parent.focus();window.parent.fprint();"   BORDER="0" HSPACE="0" VSPACE="0" ALIGN="absmiddle" ></TD></TR>';

html+='<TR><TD><IMG SRC= "prevview.gif" ONMOUSEOVER="this.src=\'prevview_1.gif\'; this.style.cursor = \'hand\';" ONMOUSEOUT="this.src=\'prevview.gif\';" ONCLICK="window.parent.focus();window.parent.fprevview();" BORDER="0" HSPACE="0" VSPACE="0" ALIGN="absmiddle"></TD></TR>';


html+='</TABLE>';

var oPopup = window.createPopup();

}

function dopopup(x,y) {
if(isie) {
var oPopupBody = oPopup.document.body;
oPopupBody.innerHTML = html;
oPopup.show(x, y, 155, 60, document.body);
}
}

function click(e) {
if(isie) {
if(document.all) {
if(event.button==2||event.button==3) {
dopopup(event.x-1,event.y-1);
}
}
}
}

if(isie) {
document.oncontextmenu = function() { dopopup(event.x,event.y);return false; }
document.onmousedown = click;
}
// --> 

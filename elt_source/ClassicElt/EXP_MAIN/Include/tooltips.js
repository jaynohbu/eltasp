//Tooltip by MJ 02/02/2007//
var offsetxpoint=12
var offsetypoint=8
var ie=document.all
var ns6=document.getElementById && !document.all
var enabletip=false
if (ie||ns6)
var tipobj=document.all? document.all["tooltipcontent"] : document.getElementById? document.getElementById("tooltipcontent") : ""

function ietruebody(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function positiontip(e){

if (enabletip){
var curX=(ns6)?e.pageX : event.clientX+ietruebody().scrollLeft;
var curY=(ns6)?e.pageY : event.clientY+ietruebody().scrollTop;
//Find out how close the mouse is to the corner of the window
var rightedge=ie&&!window.opera? ietruebody().clientWidth-event.clientX-offsetxpoint : window.innerWidth-e.clientX-offsetxpoint-20
var bottomedge=ie&&!window.opera? ietruebody().clientHeight-event.clientY-offsetypoint : window.innerHeight-e.clientY-offsetypoint-20

var leftedge=(offsetxpoint<0)? offsetxpoint*(-1) : -1000

//if the horizontal distance isn't enough to accomodate the width of the context menu
if (rightedge<tipobj.offsetWidth)
//move the horizontal position of the menu to the left by it's width
tipobj.style.left=ie? ietruebody().scrollLeft+event.clientX-tipobj.offsetWidth+"px" : window.pageXOffset+e.clientX-tipobj.offsetWidth+"px"
else if (curX<leftedge)
tipobj.style.left="5px"
else
//position the horizontal position of the menu where the mouse is positioned
tipobj.style.left=curX+offsetxpoint+"px"

//same concept with the vertical position
if (bottomedge<tipobj.offsetHeight)
tipobj.style.top=ie? ietruebody().scrollTop+event.clientY-tipobj.offsetHeight-offsetypoint+"px" : window.pageYOffset+e.clientY-tipobj.offsetHeight-offsetypoint+"px"
else
tipobj.style.top=curY+offsetypoint+"px"
tipobj.style.visibility="visible"
}
}

// Modified by Joon on MAR/12/2007 
// Uses MS ActiveX filter:mask() function with iframe trick

function showtip(thetext, thewidth){

    try{
        if (ns6||ie)
        {
            // if (typeof thewidth!="undefined") tipobj.style.width=thewidth+"px"

            tipobj.style.zIndex = 10;
            tipobj.innerHTML=thetext + "<iframe id=\"tooltipIframe\" ></iframe>";

            var iFrame = document.getElementById("tooltipIframe");
            iFrame.style.position = "absolute";
            iFrame.style.posTop = -2;
            iFrame.style.posLeft = -2;
            iFrame.style.width = tipobj.clientWidth + 4;
            iFrame.style.height = tipobj.clientHeight + 4;
            iFrame.style.zIndex = -1;
            iFrame.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(mask=1)';
            
            enabletip=true
            return false
        }
    }catch(error){ alert(error.description); }
}

function hidetip(){
if (ns6||ie){
enabletip=false
tipobj.style.visibility="hidden"
tipobj.style.left="-1000px"
tipobj.style.width=''
}
}
document.onmousemove=positiontip
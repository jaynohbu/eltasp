
<public:property name='dragColor' />

<public:attach event=oncontentready onevent="init();" />

<script>
var tbody, headRow;
var bDragMode = false;
var objDragItem;
var arrHitTest = new Array();
var iArrayHit = false;
var ColumnCount = null;

//
// Init function.. Fills out variables with data
// loaded with oncontentready.
//
function init() 
{
  var i;

	// get TBODY - take the first TBODY for the table
	tbody = element.tBodies(0);
	if (!tbody) return;

	//Get THEAD  
	var click = element.tHead;
	if (!click)  return;

	
  headRow = click.children[0];
  
  if (headRow.tagName != "TR") return;


  headRow.runtimeStyle.cursor = "hand";
	
  ColumnCount = headRow.children.length;

  for(i=0; i < ColumnCount ; i++)
  {
    arrHitTest[i] = new Array();
  }

  
  var cx=0;
  var cy=0;
  var c;
  defaultTitleColor = headRow.children[0].currentStyle.backgroundColor;	 

  for (i=0; i<ColumnCount ; i++) {

	var clickCell = headRow.children[i];
	clickCell.selectIndex = i;
	c = clickCell.offsetParent;


	if(cx == 0 && cy == 0 )
	{
		while (c.offsetParent != null) {
                  cy += c.offsetTop;
                  cx += c.offsetLeft;
                  c = c.offsetParent;
		}
	}

	arrHitTest[i][0] = cx + clickCell.offsetLeft;
	arrHitTest[i][1] = cy + clickCell.offsetTop;
	arrHitTest[i][2] = clickCell;
	arrHitTest[i][3] = cx + clickCell.offsetLeft + eval(clickCell.width);

	clickCell.attachEvent("onmousedown",onMouseDown);
  } 

  element.document.attachEvent("onmousemove",onMouseMove);
  element.document.attachEvent("onmouseup",onMouseUp);
  element.document.attachEvent("onselectstart",onSelect);
}


function InitHeader()
{
  var cx=0;
  var cy=0;
  var c;
	 
  for (i=0; i<ColumnCount ; i++) {

	var clickCell = headRow.children[i];
	clickCell.selectIndex = i;
	c = clickCell.offsetParent;

	if(cx == 0 && cy == 0 )
	{
		while (c.offsetParent != null) {
                  cy += c.offsetTop;
                  cx += c.offsetLeft;
                  c = c.offsetParent;
		}
	}

	arrHitTest[i][0] = cx + clickCell.offsetLeft;
	arrHitTest[i][1] = cy + clickCell.offsetTop;
	arrHitTest[i][2] = clickCell;
	arrHitTest[i][3] = cx + clickCell.offsetLeft + eval(clickCell.width);
  } 
}

function onSelect()
{
	//disable selection
	return false;
}

function ChangeHeader(iChange)
{
	for(var y = 0; y < arrHitTest.length; y++)
	{
	if (arrHitTest[y][2].currentStyle.backgroundColor == dragColor)
		arrHitTest[y][2].style.backgroundColor = defaultTitleColor;
	}

	if(iChange == "-1") return; 

	arrHitTest[iChange][2].style.backgroundColor = dragColor;
}

function onMouseUp(e)
{
	if(!bDragMode)	return;
	bDragMode = false;

	var iSelected = objDragItem.selectIndex;
	
	objDragItem.removeNode(true);
	objDragItem = null;

	ChangeHeader(-1);

	if( (iArrayHit - 1) < 0 || iSelected < 0) return;	// default faliure

	CopyRow(iSelected, (iArrayHit - 1) );

	// Reset our variables
	iSelected = 0;
	iArrayHit = -1;
}

function onMouseDown(e)
{
	bDragMode 	= true;
	var src 	= e.srcElement;
	var c 	= e.srcElement;

	while (src.tagName != "TD") 
		src = src.parentElement;

	// Create our header on the fly
	objDragItem = document.createElement("DIV");
	objDragItem.innerHTML		= src.innerHTML;
	objDragItem.style.height	= src.currentStyle.height;
	objDragItem.style.width 	= src.currentStyle.width;
	objDragItem.style.background 	= src.currentStyle.backgroundColor;
	objDragItem.style.fontColor	= src.currentStyle.fontColor;
	objDragItem.style.position 	= "absolute";
	objDragItem.selectIndex		= src.selectIndex;
	while (c.offsetParent != null) 
        {
		objDragItem.style.y += c.offsetTop;
		objDragItem.style.x += c.offsetLeft;
		c = c.offsetParent;
	}
 	objDragItem.style.borderStyle	= "outset";
	objDragItem.style.display	= "none";

	src.insertBefore(objDragItem);
}

function onMouseMove(e)
{
	if(!bDragMode || !objDragItem) return;	// If we aren't dragging or our object
								// is null, we return

	// Hardcoded value for height difference
	var midWObj = objDragItem.style.posWidth / 2;
	var midHObj = 12;

	// Save mouse's position in the document
     var intTop = e.clientY + element.document.body.scrollTop;
     var intLeft = e.clientX + element.document.body.scrollLeft;


	var cx=0,cy=0;
	var elCurrent = objDragItem.offsetParent;
               while (elCurrent.offsetParent != null) {
                  cx += elCurrent.offsetTop;
                  cy += elCurrent.offsetLeft;
                  elCurrent = elCurrent.offsetParent;
               }


      objDragItem.style.pixelTop  = intTop  - cx - midHObj;
      objDragItem.style.pixelLeft = intLeft - cy - midWObj;


	if(objDragItem.style.display == "none") objDragItem.style.display = "";

	iArrayHit = CheckHit(intTop , intLeft , e);

	e.cancelBubble = false;
	e.returnValue = false;
}

function CheckHit(x,y,e)
{
	midWObj = objDragItem.style.posWidth / 2;
	midHObj = 12;

	if( ((x) > (arrHitTest[0][1] + 20) ) || ( (x) < (arrHitTest[0][1]) ) )
	{
		ChangeHeader(-1);
		return -1;
	}

	for(var i=0; i < ColumnCount; i++)
	{
		if( (y) > (arrHitTest[i][0]) && (y) < (arrHitTest[i][3] )) //+ 100))
		{
			ChangeHeader(i);
			return i + 1;
		}
	}
	return -1;
}

//
// Copy from row to row.. Does the Header also.
//
function CopyRow(from, to)
{	
	if(from == to) return;


	var origfrom = from;
	var origto = to;
	var iDiff = 0;

	if( from > to )
	{

		iDiff = from - to;

		var saveObj 	= headRow.children[from].innerHTML;
		var saveWidth 	= headRow.children[from].width;

		for(var i = 0 ; i < iDiff; i++)
		{
			headRow.children[from].innerHTML = headRow.children[from - 1].innerHTML;
			headRow.children[from].width = headRow.children[from - 1].width;
			from--;
		}
		headRow.children[to].innerHTML 	= saveObj;
		headRow.children[to].width = saveWidth;
		
	}
	else
	{

		iDiff = to - from;

		var saveObj = headRow.children[from].innerHTML;
		var saveWidth 	= headRow.children[from].width;

		for(var i = 0 ; i < iDiff; i++)
		{
			headRow.children[from].innerHTML = headRow.children[from + 1].innerHTML;
			headRow.children[from].width = headRow.children[from + 1].width;
			from++;
		}

		headRow.children[to].innerHTML 	= saveObj;
		headRow.children[to].width = saveWidth;
	}



	for(var i = 0 ; i < headRow.children.length; i++)
			headRow.children[i].selectIndex = i;



	InitHeader();
	for ( var iRowInsert = 0 ; iRowInsert < tbody.rows.length; iRowInsert++ )
	{
		from = origfrom;
		to = origto;
		if( from > to )
		{
			iDiff = from - to;
			var saveObj = tbody.children[iRowInsert].children[from].innerHTML
			for(var i = 0 ; i < iDiff; i++)
			{
				tbody.children[iRowInsert].children[from].innerHTML = tbody.children[iRowInsert].children[from - 1].innerHTML;
				from--;
			}
			tbody.children[iRowInsert].children[to].innerHTML = saveObj;

		}
		else
		{
			iDiff = to - from;
			var saveObj = tbody.children[iRowInsert].children[from].innerHTML
			for(var i = 0 ; i < iDiff; i++)
			{
				tbody.children[iRowInsert].children[from].innerHTML = tbody.children[iRowInsert].children[from + 1].innerHTML;
				from++;
			}
			tbody.children[iRowInsert].children[to].innerHTML = saveObj;
		}
	}
}

</script>

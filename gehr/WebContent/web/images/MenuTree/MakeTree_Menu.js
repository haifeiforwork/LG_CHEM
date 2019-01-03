//****************************************************************
// You are free to copy the "Folder-Tree" script as long as you
// keep this copyright notice:
// Script found in: http://www.geocities.com/Paris/LeftBank/2178/
// Author: Marcelino Alves Martins (martins@hks.com) December '97.
//****************************************************************
 //Log of changes:
//       17 Feb 98 - Fix initialization flashing problem with Netscape
//
//       27 Jan 98 - Root folder starts open; support for USETEXTLINKS;
//                   make the ftien4 a js file
//
// Definition of class Folder
// *****************************************************************

function Folder(folderDescription, hreference, key, isDoc) 
{ //constructor
  //constant data
  this.desc = folderDescription

  this.hreference = hreference
  this.id = -1
  this.navObj = 0
  this.iconImg = 0
  this.nodeImg = 0
  this.isLastNode = 0
  this.clicked = 0

  //dynamic data
  this.isOpen = true;
  this.openIconSrc = "/web/images/MenuTree/ftv2folderOpen.gif";
  this.openClickedIconSrc = "/web/images/MenuTree/ftv2folderClickedOpen.gif";

  this.closeIconSrc = "/web/images/MenuTree/ftv2folderClosed.gif";
  this.closeClickedIconSrc = "/web/images/MenuTree/ftv2folderClickedClosed.gif";

  this.docIconSrc = "/web/images/MenuTree/ftv2document.gif";
  this.docClickedIconSrc = "/web/images/MenuTree/ftv2documentClicked.gif";

  this.children = new Array
  this.nChildren = 0

  //methods
  this.initialize = initializeFolder
  this.setState = setStateFolder
  this.addChild = addChild
  this.createIndex = createEntryIndex
  this.hide = hideFolder
  this.display = display
  this.renderOb = drawFolder
  this.totalHeight = totalHeight
  this.subEntries = folderSubEntries

  //linkChk
  this.isDoc = isDoc;
  this.key = key;
}

function getDesc(folderId) {
  var clickedFolder = 0
  var state = 0

  clickedFolder = indexOfEntries[folderId]

  alert(clickedFolder);

  return clickedFolder.desc;
}

function setStateFolder(isOpen) 
{
	var subEntries
	var totalHeight
	var fIt = 0
	var i=0

	if (isOpen == this.isOpen)
		return;

	if (browserVersion == 2)  {
		totalHeight = 0
		for (i=0; i < this.nChildren; i++)
			totalHeight = totalHeight + this.children[i].navObj.clip.height

		subEntries = this.subEntries()

		if (this.isOpen)
			totalHeight = 0 - totalHeight
		for (fIt = this.id + subEntries + 1; fIt < nEntries; fIt++)
			indexOfEntries[fIt].navObj.moveBy(0, totalHeight)
	} // end if
	this.isOpen = isOpen;
	propagateChangesInState(this)
}

function propagateChangesInState(folder)
{
	var i=0

	if (folder.isOpen) {
		if (folder.nodeImg){
			if (folder.isLastNode) {
				folder.nodeImg.src = "/web/images/MenuTree/ftv2mlastnode.gif";
			} else {
				folder.nodeImg.src = "/web/images/MenuTree/ftv2mnode.gif";
			}// end if
		} // end if
		
		if ( folder.clicked ) {
			folder.iconImg.src = folder.openClickedIconSrc;
		} else {
			folder.iconImg.src = folder.openIconSrc;
		} // end if

		for(i=0; i<folder.nChildren; i++) {
			folder.children[i].display()
		} // end if
	} else {
		if (folder.nodeImg) {
			if (folder.isLastNode) {
				if(folder.nChildren == 0) {
					folder.nodeImg.src = "/web/images/MenuTree/ftv2lastnode.gif";
				} else {
					folder.nodeImg.src = "/web/images/MenuTree/ftv2plastnode.gif";
				} // end if
			} else {
				if(folder.nChildren == 0) {
					folder.nodeImg.src = "/web/images/MenuTree/ftv2node.gif";
				} else {
					folder.nodeImg.src = "/web/images/MenuTree/ftv2pnode.gif";
				} // end if
			} // end if
		} // end if

		if(folder.clicked) {
			if (folder.isDoc){
				folder.iconImg.src = folder.docClickedIconSrc;
			} else {
				folder.iconImg.src = folder.closeClickedIconSrc;
			} // end if
			
		} else {
			if (folder.isDoc){
				folder.iconImg.src = folder.docIconSrc;
			} else {
				folder.iconImg.src = folder.closeIconSrc;
			} // end if
			
		} // end if

		for(i=0; i<folder.nChildren; i++) {
			folder.children[i].hide()
		} // end for
	} // end if
}

function hideFolder()
{
	if (browserVersion == 1) {
		if (this.navObj.style.display == "none")
			return;
		this.navObj.style.display = "none"
	} else {
		if (this.navObj.visibility == "hiden")
			return;
		this.navObj.visibility = "hiden"
	} // end if
	this.setState(0)
} // end function

function display() 
{
	if (browserVersion == 1)
		this.navObj.style.display = "block"
	else
		this.navObj.visibility = "show"
}

function initializeFolder(level, lastNode, leftSide)
{
	var j=0
	var i=0
	var nc = this.nChildren

	this.createIndex();
	var auxEv = "";

	if (browserVersion > 0 && nc != 0) {
		auxEv = "<a href='javascript:clickOnNode("+this.id+")'>";
	} else {
		auxEv = "<a>";
	} // end if

	if (level>0) {
		if (lastNode) { //the last 'brother' in the children array
			this.renderOb(leftSide + auxEv + "<img name='nodeIcon" + this.id + "' src='/web/images/MenuTree/ftv2mlastnode.gif' width=16 height=22 border=0></a>")
			leftSide = leftSide + "<img src='/web/images/MenuTree/ftv2blank.gif' width=16 height=22>"
			this.isLastNode = 1
		} else {
			this.renderOb(leftSide + auxEv + "<img name='nodeIcon" + this.id + "' src='/web/images/MenuTree/ftv2mnode.gif' width=16 height=22 border=0></a>")
			leftSide = leftSide + "<img src='/web/images/MenuTree/ftv2vertline.gif' width=16 height=22>"
			this.isLastNode = 0
		} // end if
	} else {
		this.renderOb("")
	} // end if

	if (nc > 0) {
		level = level + 1
		for (i=0 ; i < this.nChildren; i++) {
			if (i == this.nChildren-1)
				this.children[i].initialize(level, 1, leftSide)
			else
				this.children[i].initialize(level, 0, leftSide)
		} // end for
	} // end if
}

function drawFolder(leftSide)
{
	if (browserVersion == 2) {
		if (!document.yPos) document.yPos=8 ;
		document.write("<layer left=" + leftmargin + " id='folder" + this.id + "' top=" + (document.yPos+topmargin) + " visibility=hiden>");
	} // end if

	if (browserVersion == 1) {
		document.write("<div  id='folder" + this.id + "' style='position:relative;left:" + leftmargin + "px;top:" + topmargin + "px' >")
	} // end if

	document.write("<table border=0 cellspacing=0 cellpadding=0>");
	document.write("<tr><td>");
	document.write(leftSide);
	document.write("<img name='folderIcon" + this.id + "' ");
	if (this.isDoc){
		document.write("src='" + this.docIconSrc+"' border=0></a>");
	} else {
		document.write("src='" + this.closeIconSrc+"' border=0></a>");
	} // end if

	document.write("</td><td valign=bottom nowrap>");

	if( this.hreference != "") {
		document.write("<a href=\"#\" onClick=\"clickOnFolder('" + this.id + "');" + this.hreference + "\">");
		document.write("<font color=\"00000\">" + this.desc + "</font>");
		document.write("</a>");
	} else {
		document.write("<font color=\"808080\">" + this.desc + "</font>");
	} // end if
	document.write("</td>");
	document.write("</table>");

	if (browserVersion == 2) {
		document.write("</layer>");
	} else if ( browserVersion == 1 ){
		document.write( "</div>" );
	}// end if

	if (browserVersion == 1) {
		this.navObj = document.all["folder"+this.id]
		this.iconImg = document.all["folderIcon"+this.id]
		this.nodeImg = document.all["nodeIcon"+this.id]
	} else if (browserVersion == 2) {
		this.navObj = document.layers["folder"+this.id]
		this.iconImg = this.navObj.document.images["folderIcon"+this.id]
		this.nodeImg = this.navObj.document.images["nodeIcon"+this.id]
		document.yPos=document.yPos+this.navObj.clip.height
	} // end if
}

function addChild(childNode) 
{
	this.children[this.nChildren] = childNode;
	this.nChildren++;
	return childNode;
}

function folderSubEntries() 
{
	var i = 0
	var se = this.nChildren

	for (i=0; i < this.nChildren; i++){
		if (this.children[i].children) //is a folder
			se = se + this.children[i].subEntries()
	} // end for

	return se
}



function createEntryIndex() {
  this.id = nEntries
  indexOfEntries[nEntries] = this
  nEntries++
}

// total height of subEntries open
function totalHeight() { //used with browserVersion == 2
  var h = this.navObj.clip.height
  var i = 0

  if (this.isOpen) //is a folder and _is_ open
    for (i=0 ; i < this.nChildren; i++)
      h = h + this.children[i].totalHeight()

  return h
}

function clickOnNode(folderId) 
{
	var clickedFolder = 0;
	var state = 0;

	clickedFolder = indexOfEntries[folderId];
	state = clickedFolder.isOpen;

	clickedFolder.setState(!state); //open<->close
}

function clickOnFolder(folderId) 
{
	var clickedFolder = 0;
	var state = 0;
	for ( i = 0; i < indexOfEntries.length ; i++){
		clickedFolder = indexOfEntries[i];
		if (i != folderId && clickedFolder.clicked){
			clickedFolder.clicked = false;
			chageStateFoler(clickedFolder);
		} // end if
	} // end for

	clickedFolder = indexOfEntries[folderId];
	clickedFolder.clicked = true;
	chageStateFoler(clickedFolder); //open<->close
}

function chageStateFoler(folder)
{
	if (folder.isDoc){
		if (folder.clicked ) {
			folder.iconImg.src = folder.docClickedIconSrc;
		} else {
			folder.iconImg.src = folder.docIconSrc;
		} // end if
	} else {
		if (folder.isOpen) {
			if (folder.clicked ) {
				folder.iconImg.src = folder.openClickedIconSrc;
			} else {
				folder.iconImg.src = folder.openIconSrc;
			} // end if
		} else {
			if (folder.clicked ) {
				folder.iconImg.src = folder.closeClickedIconSrc;
			} else {
				folder.iconImg.src = folder.closeIconSrc;
			} // end if
		} // end if
	} // end if
}

function initializeDocument() 
{
	if (document.all)
		browserVersion = 1 //IE4
	else if (document.layers)
		browserVersion = 2 //NS4
	else
		browserVersion = 0 //other

	aux0.initialize(0, 1, "");
	aux0.display();

	if (browserVersion > 0) {
		// close the whole tree
		clickOnNode(0);
		// open the root folder
		clickOnNode(0);
	} // end if
}

function setLink( id , folderId ) {
	var pre = document.formHidden.inputFolder.value
 	if ( pre != -1 ) {
 		preFolder = indexOfEntries[pre]
 		preFolder.iconImg.src = "/web/images/MenuTree/ftv2folderopen.gif"
 		preFolder.clicked = 0
 	}
    clickedFolder = indexOfEntries[folderId]
    clickedFolder.iconImg.src = "/web/images/MenuTree/ftv2folderopen1.gif"
    clickedFolder.clicked = 1
	document.formHidden.inputFolder.value = folderId
	document.formHidden.inputDeptId.value = id
	gotoURL(id, clickedFolder.desc)
//    document.write(clickedFolder.desc)
}

// Auxiliary Functions for Folder-Tree backward compatibility
// *********************************************************

function gFld(description, hreference, key, isDoc) {
  folder = new Folder(description, hreference, key, isDoc)
  return folder
}

function insFld(parentFolder, childFolder) {
  return parentFolder.addChild(childFolder)
}

// Global variables
// ****************
indexOfEntries = new Array
nEntries = 0
browserVersion = 0
leftmargin = 0
topmargin = 0

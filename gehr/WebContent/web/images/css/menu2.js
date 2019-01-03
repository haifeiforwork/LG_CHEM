var old_menu='';
var old_cellbar='';
var old_img='';

function js_sleep()
{
    for(i = 0;i < 50000;i++);
}


function menuclick(submenu,cellbar,menu)
{
    if(old_menu != "") {
        menu.bgColor = "#ECECEC";
        old_menu.style.display="none";
	    old_cellbar.src="./images/left/b_off.gif";
    }

    menu.bgColor = "#ECECEC";
    old_menu = submenu;
    old_cellbar = cellbar;
    submenu.style.display = "";

    cellbar.src = "./images/left/b_on.gif";
    menu.bgColor = "#ECECEC";
}

/**********************************************************************

    Function name : mouse_out
    Parameters    :
    Return        : ¸¶¿ì½º°¡ ¹üÀ§¸¦ ¹ù¾î³µÀ»¶§ÀÇ »ö±ò
**********************************************************************/
function mouse_out(menu)
{
    for(i = 0;i < 50000;i++) {
       	;
    }

    menu.bgColor = "#FFFFFF";
}
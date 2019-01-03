<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%
    String initMenuCode = request.getParameter("MenuCode");
    if(initMenuCode == null) {
        initMenuCode = "";
    } // end if
%>
<%!
    int depth = 0;
   
    public String writeMenuTree(Vector vc ,String topCode ,String parentID) 
    {
        depth ++;
        StringBuffer sb = new StringBuffer();
        int order = 0;
        for (int i = 0; i < vc.size(); i++) {
            hris.sys.MenuCodeData mncd   =   (hris.sys.MenuCodeData) vc.get(i);
            if (mncd.upMenuCode.equals(topCode)) {
            String selfID = "aux" + depth;
            sb.append(selfID + "  = insFld(" + parentID + ", gFld(\"" + mncd.menuName) ;
                if (mncd.menuClsf.equals("01")) {
                    sb.append("\",\"fol('" + mncd.menuCode + "')\",'" + mncd.menuCode + "' ,false)); \n");
                    sb.append(writeMenuTree(vc ,mncd.menuCode ,selfID));
                } else if (mncd.menuClsf.equals("02")) {
                    sb.append("\",\"doc('" + mncd.menuCode + "')\",'" + mncd.menuCode + "' ,true));\n");
                } // end if
            } // end if
        } // end for
        depth --;
        return sb.toString();
    }
%>
<%
    Vector vcOMenuCodeData = (Vector)request.getAttribute("vcMeneCodeData");
%>
<html>
<head>
<title>ESS 사용방법안내</title>
<link rel="stylesheet" type="text/css" href="/web/help_online/images/skin/style.css">
<script src="/web/images/MenuTree/MakeTree_Menu.js"></script>
<script language="javascript">
<!--
 //     디렉토리 폴더 보기
		aux0 = gFld("MMS 시스템", "fol('1000')", '1000' ,false);
		<%=writeMenuTree(vcOMenuCodeData ,"1000" ,"aux0")%>
        initializeDocument();
//      디렉토리 폴더 보기 

    function fol(menuCode) 
    {
        frm = document.form1;
        frm.action = "<%=WebUtil.ServletURL%>hris.sys.SysMenuDetailSV";
        frm.menuCode.value = menuCode;
        frm.menuClsf.value = "01";
        frm.target = "MenuDetail";
        frm.submit();
    }
    
    function doc(menuCode) 
    {
        frm = document.form1;
        frm.action = "<%=WebUtil.ServletURL%>hris.sys.SysMenuDetailSV";
        frm.menuCode.value = menuCode;
        frm.menuClsf.value = "02";
        frm.target = "MenuDetail";
        frm.submit();
    }
    
   
    
    var initEntries = new Array
    var nInitCount = 0;
    
    function initNode(key) 
	{
	   var i = 0;
	   var j = 0;
	   var initFolder = null;
	   
	   var clickedFolder = 0;
	   var state = 0;
	   for( i = 0 ; i < indexOfEntries.length; i ++ ) {
	       initFolder = indexOfEntries[i];
	       
           for( j = 0 ; j < initFolder.nChildren ; j++ ) {
               if( initFolder.children[j].key  ==  key) {
                   if(nInitCount == 0 ) {
                       initEntries[nInitCount] = initFolder.children[j];
                       nInitCount ++;
                   } // end if
                   
                   if(initFolder.key != "1000") {
                        initEntries[nInitCount] = initFolder;
                        nInitCount ++;
                        initNode(initFolder.key);
                        break;
                   } // end if
               } // if
           } // end for
	           
	       
	   } // end for
	}
    
    function init() 
    {
        var initFolder = null;
        
        if( "" != "<%=initMenuCode%>" ) {
            initNode("<%=initMenuCode%>");
            for( i = nInitCount - 1 ; i > 0  ; i -- ) {
                clickOnNode(initEntries[i].id);
            } // end for
            if (nInitCount > 0 ) {
	            initFolder  = initEntries[0];
	        } else {
    	        initFolder  = indexOfEntries[0];
	        } // end if
	        
	        clickOnFolder(initFolder.id);
	        if ( initFolder.isDoc) {
                doc(initFolder.key);
            } else {
                fol(initFolder.key);
            } // end if
        } // end if
    } // end function
    
//-->
</script>
</head>
<body bgcolor="#F0F0F0" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onload="init()">
<form name="form1" method="post" action="">
<input type="hidden" name="menuCode" value="">
<input type="hidden" name="jobid" value="view">
<input type="hidden" name="menuClsf">
</form>
</body>
</html>	
<%
    depth = 0;
%>


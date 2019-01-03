<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData       user            = (WebUserData)session.getAttribute("user");
    String            gubun           = request.getParameter("gubun");

    J01FuncObjListRFC rfc             = new J01FuncObjListRFC();

    Vector            j01FuncObjec_vt = rfc.getDetail(user.empNo);
%>

<html>
<head>
<title>Job Description</title>
<link rel="stylesheet" href="<%= WebUtil.JspURL %>help_online/images/skin/style.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>tree/MakeTree_help.js"></script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="8" topmargin="0" marginwidth="0" marginheight="0">
<table width="228" height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
  <td width="1" bgcolor="#cccccc"></td>
  <td valign="top">
    <table width="227" height="25" cellspacing="0" cellpadding="0" border="0">
      <tr>
        <td bgcolor="#cccccc" colspan="2"><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width="1" height="1"></td>
      </tr>
      <tr>
        <td width="10">&nbsp;</td>
        <td width="217">&nbsp;</td>
      </tr>
      <tr>
        <td width="10">&nbsp;</td>
        <td>
          <span style="height: 391px; width: 217px; overflow:auto;">
            <html>
	  	        <script language="JavaScript">
  
            aux0 = gFld("Function & Objectives", "", 0);
<%
    String old_objid = "";
    
    for( int i = 0 ; i < j01FuncObjec_vt.size() ; i++ ) {
        J01JobMatrixData data = (J01JobMatrixData)j01FuncObjec_vt.get(i);
        
        if( !data.OBJID.equals(old_objid) ) {
%>
		        aux1 = insFld(aux0, gFld("<%= data.STEXT %>", "", 0));
<%
            old_objid = data.OBJID;
        }
//      해당하는 Objective에만 링크를 걸어준다.
        if( data.LINK_CHK.equals("Y") ) {
            if( gubun.equals("C") ) {               // 생성시 BEGDA = '9999.12.31'로 한다.
%>
  		      aux2 = insFld(aux1, gFld("<%= data.STEXT_OBJ %>", "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01GetPersonsSV?i_objid=<%= data.SOBID %>&gubun=<%= gubun %>&BEGDA=99991231", 1));
<%
            } else {
%>
  		      aux2 = insFld(aux1, gFld("<%= data.STEXT_OBJ %>", "<%= WebUtil.ServletURL %>hris.J.J01JobMatrix.J01GetPersonsSV?i_objid=<%= data.SOBID %>&gubun=<%= gubun %>", 1));
<%
            }
        } else {
%>
  		      aux2 = insFld(aux1, gFld("<%= data.STEXT_OBJ %>", "", 0));
<%
        } 
    }
%>
  		      initializeDocument();
  	          </script>
            <table>  	          
                <tr><td>&nbsp;</td></tr>
            </table>      


            </html>
          </span>
      	</td>
	    </tr>
	    
	  </table>
  </td>
</tr>
</table>
<%@ include file="/web/common/commonEnd.jsp" %>

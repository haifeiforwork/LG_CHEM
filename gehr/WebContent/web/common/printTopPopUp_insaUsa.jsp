<%/***************************************************************************************/
/*   System Name  	: g-HR              																												*/
/*   1Depth Name		: Employee Data                                                  																*/
/*   2Depth Name  	: Personal Data                                                    															*/
/*   Program Name 	: Personnel File                                                    															*/
/*   Program ID   		: printTopPopUp_insaUsa.jsp                                        														*/
/*   Description  		: 사원 인사정보 출력 미리보기 화면 (USA)                                              									*/
/*   Note         		:                                                             																		*/
/*   Creation     		: 2010-10-04 jungin @v1.0 																								*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%
    WebUserData user = (WebUserData)session.getAttribute("user");
    String jobid2 = (String)request.getParameter("jobid2");
%>

<html>
<head>
<title>LG CHEM Global e-HR</title>
<script language="javascript">
    function f_print(){
        if( confirm("<spring:message code='MSG.COMMON.0077' />") ) {  //① Please select [Tools]->[Internet Options]->[Advanced]->[Printing], and check [Print background colors and images].\n\n② Open [File]->[Page Setup] and do it as followed.  \n\nSize(inchi)\t\t: Letter (8.5 * 11)\nHeaders and Footers\t: Remove all content\nOrientation\t\t: Portrait\nMargins(inchi)\t\t: Left 0.75 Right 0.75 Top 0.75 Bottom 0.75
            parent.beprintedpage.focus();
            parent.beprintedpage.print();
        }
    }
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="95%" border="0" cellspacing="0" cellpadding="0" height="25">
  <tr>
    <td align="right" valign="bottom">
      <a href="javascript:f_print();">
      <img src="<%= WebUtil.ImageURL %>btn_print.gif" border="0"></a>
      <a href="javascript:top.close();">
      <img src="<%= WebUtil.ImageURL %>btn_close.gif" border="0"></a>
    </td>
  </tr>
</table>
<%@ include file="commonEnd.jsp" %>

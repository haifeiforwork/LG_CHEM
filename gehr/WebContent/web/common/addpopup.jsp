<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보 확인                                                        */
/*   Program Name : 인사정보 확인   추가 팝업                                              */
/*   Program ID   : addpopup.jsp                                      */
/*   Description  : 인사정보 확인 추가 추가 팝업                                            */
/*   Note         :                                                             */
/*   Creation     : 2016-10-18     [CSR ID:3187400] 인사정보 확인기능 수정요청의 件 김불휘S                   */
/********************************************************************************/%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>


<head>
<title>인사정보확인</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

     <img src="<%= WebUtil.ImageURL %>addpopup.jpg" border="0">

<%@ include file="commonEnd.jsp" %>

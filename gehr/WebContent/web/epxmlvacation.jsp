<?xml version="1.0" encoding="utf-8" ?>
<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : EP 휴가정보
/*   Program ID   : epxmlvacation.jsp
/*   Description  : EP 휴가정보
/*   Note         : 없음
/*   Creation     : 2005-09-26  배민규
/*   Update       :
/*
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.G.G001Approval.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    Vector vcInit = (new InitViewRFC()).getInitViewData(user.empNo ,user.e_objid ,user.e_authorization);
    ViewEmpVacationData empVacationData = (ViewEmpVacationData)((Vector)vcInit.get(2)).get(0);
 %>
<viewentries toplevelentries="1">
<viewentry position="1">
<entrydata columnnumber="0" name="Total Vacation">
<text><%= WebUtil.printNumFormat(empVacationData.OCCUR,1) %></text>
</entrydata>
<entrydata columnnumber="1" name="Used Vacation">
<text><%= WebUtil.printNumFormat(empVacationData.ABWTG,1) %></text>
</entrydata>
<entrydata columnnumber="2" name="Unused Vacation">
<text><%= WebUtil.printNumFormat(empVacationData.ZKVRB,1) %></text>
</entrydata>
</viewentry>
</viewentries>
<% session.invalidate(); %>

<?xml version="1.0" encoding="utf-8" ?>
<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : EP 결재할문서 목록
/*   Program ID   : epxmllist.jsp
/*   Description  : EP 결재할문서 목록
/*   Note         : 없음
/*   Creation     : 2005-08-29  배민규
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
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%
//    response.setHeader("Content-Disposition","attachment;filename=ehr4ep.xml");
//    response.setContentType("text/xml;charset=utf-8");

    WebUserData user = WebUtil.getSessionUser(request);
    int appFlag = user.e_authorization.indexOf("W");    //결재권한여부.
    Vector vcInit = (new InitViewRFC()).getInitViewData(user.empNo ,user.e_objid ,user.e_authorization);
    Config conf = new Configuration();
    String ResponseURL = conf.get("com.sns.jdf.mail.ResponseURL");
%>
<viewentries toplevelentries="5">
<%
    if( appFlag > 0 ){  
      Vector vcApprovalDocList = (Vector) vcInit.get(0);  
      for (int i = 0; i < vcApprovalDocList.size() && i < 5; i++) {  
        ApprovalDocList apl = (ApprovalDocList) vcApprovalDocList.get(i); %>
<viewentry position="<%=i+1%>">
<entrydata columnnumber="0" name="Subject">
<text><%=apl.UPMU_NAME%></text>
</entrydata>
<entrydata columnnumber="1" name="Name">
<text><%=apl.ENAME%></text>
</entrydata>
<entrydata columnnumber="2" name="MailID">
<text><%=user.e_mail%></text>
</entrydata>
<entrydata columnnumber="3" name="Date">
<text><%=DataUtil.putDateGubn(DataUtil.delDateGubn(apl.BEGDA),"/")%></text>
</entrydata>
<entrydata columnnumber="4" name="Link">
<text>http://<%=ResponseURL%><%=WebUtil.ServletURL%>hris.EpApprovalLoginSV?AINF_SEQN=<%=apl.AINF_SEQN%>&amp;SSNO=<%=DataUtil.encodeEmpNo(user.empNo)%>&amp;epid=detail</text>
</entrydata>
</viewentry>
<%
      }
    } %>
</viewentries>
<% session.invalidate(); %>

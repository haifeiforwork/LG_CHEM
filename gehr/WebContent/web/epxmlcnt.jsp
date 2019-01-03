<?xml version="1.0" encoding="utf-8" ?>
<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : EP 결재할문서 갯수
/*   Program ID   : epxmlcnt.jsp
/*   Description  : EP 결재할문서 갯수
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
<%
    WebUserData user = WebUtil.getSessionUser(request);
    int appFlag = user.e_authorization.indexOf("W");    //결재권한여부.
    //Vector vcInit = (new InitViewRFC()).getInitViewData(user.empNo ,user.e_objid ,user.e_authorization);
    Config conf = new Configuration();
    String ResponseURL = conf.get("com.sns.jdf.mail.ResponseURL");

    int acount = 0;
    if( appFlag > 0 ){  
      //Vector vcApprovalDocList = (Vector)vcInit.get(0); 
      //속도땜에 변경
      Vector      vcApprovalDocList = (Vector)request.getAttribute("vcApprovalDocList");
     
      //통합결재에서 제외업무된건수만 보냄 2009.05.08
      //23:식권영업사원식대SAP신청WEB결재,04:종합검진신청:웹신청SAP결재,08:교육신청:교육지원신청EHR결재
      for( int i = 0 ; i < vcApprovalDocList.size(); i++ ) { 
          ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i); 
          if (apl.UPMU_TYPE.equals("08")||apl.UPMU_TYPE.equals("23")||apl.UPMU_TYPE.equals("04") ) {
             acount++;
          }
      }     

    }
 %>
<viewentries toplevelentries="1">
<viewentry position="1">
<entrydata columnnumber="0" name="Count">
<text><%=acount%></text>
</entrydata>
<entrydata columnnumber="1" name="Link">
<text>http://<%=ResponseURL%><%=WebUtil.ServletURL%>hris.EpApprovalLoginSV?SSNO=<%=DataUtil.encodeEmpNo(user.empNo)%>&amp;epid=list</text>
</entrydata>
</viewentry>
</viewentries>
<% session.invalidate(); %>

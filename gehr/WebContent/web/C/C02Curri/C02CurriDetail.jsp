<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 조회                                               */
/*   Program ID   : C02CurriDetail.jsp                                          */
/*   Description  : 교육 신청을 조회할 수 있도록 하는 화면                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-02-25  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.util.*" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    C02CurriApplData data     = (C02CurriApplData)request.getAttribute("c02CurriApplData");

    String RequestPageName = (String)request.getAttribute("RequestPageName");
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(data.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function go_delete() {
    if( chk_APPR_STAT(1) && confirm("교육과정 참가신청을 취소하시겠습니까?") ) {
        document.form1.jobid.value="delete";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriDetailSV';
        document.form1.method = "post";
        document.form1.submit();
    }
}

function do_list(){
    document.form1.action = "<%=RequestPageName.replace('|','&')%>";
    document.form1.submit();
}
//-->
</SCRIPT>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>교육과정 신청 조회</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->

<%
    }
%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>과정명</th>
                    <td><%= data.GWAJUNG %></td>
                    <th class="th02">교육기간</th>
                    <td> <%= WebUtil.printDate(data.GBEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(data.GBEGDA,".") + "~ " %><%= WebUtil.printDate(data.GENDDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(data.GENDDA,".") %></td>
                </tr>
                <tr>
                    <th>신청차수</th>
                    <td><%= data.CHASU %></td>
                    <th class="th02">차수ID</th>
                    <td><%= data.CHAID %></td>
                </tr>
                <tr>
                    <th>사번</th>
                    <td><%= data.PERNR %></td>
                    <th class="th02">성명</th>
                    <td><%= data.ENAME %></td>
                </tr>
                <tr>
                    <th>소속</th>
                    <td><%= data.ORGTX %></td>
                    <th class="th02">직위</th>
                    <td><%= data.TITEL %></td>
                </tr>
                <tr>
                    <th>급호/년차</th>
                    <td colspan="3"><%= data.TRFGR %><%= (data.TRFST).equals("") ? "" : "-"+data.TRFST %><%= (data.VGLST).equals("") ? "" : "/"+data.VGLST %>년차</td>
                </tr>
                <tr>
                    <th>신청사유</th>
                    <td colspan="3">
                        <textarea name="TEXT" cols="60" wrap="VIRTUAL" rows="5" readonly><%= data.TEXT %></textarea>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppDetail(data.AINF_SEQN) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%  if (docinfo.isModefy()) { %>
            <li><a href="javascript:go_delete();" ><span>삭제</span></a></li>
<%  } // end if %>
<%  if ( RequestPageName != null && !RequestPageName.equals("")) { %>
<%      if( user.e_learning.equals("") ){  %>
            <li><a href="javascript:do_list();;"><span>목록</span></a></li>
<%      } else { %>
            <li><a href="<%=RequestPageName%>"><span>목록</span></a></li>
<%      } %>
<%  } else {  %>
            <li><a href="<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoListSV"><span>목록</span></a></li>
<%  } %>
        </ul>
    </div>


<!---------- hidden ------------>
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="AINF_SEQN" value="<%= data.AINF_SEQN %>">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<!---------- hidden ------------>
  </form>
</div>

<%@ include file="/web/common/commonEnd.jsp" %>

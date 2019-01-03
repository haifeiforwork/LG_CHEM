<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금 조회                                               */
/*   Program ID   : E10PersonalDetail.jsp                                       */
/*   Description  : 개인연금을 조회할 수 있도록 하는 화면                       */
/*   Note         :                                                             */
/*   Creation     : 2002-02-03  이형석                                          */
/*   Update       : 2005-02-23  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E10Personal.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    Vector Personal_vt = (Vector)request.getAttribute("Personal_vt");
    Vector AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");

    E10PersonalData data = (E10PersonalData)Personal_vt.get(0);

    String RequestPageName = (String)request.getAttribute("RequestPageName");

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(data.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
%>
<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function go_change() {
  if(chk_APPR_STAT(0)){
      document.form1.jobid.value="";
      document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E10Personal.E10PersonalChangeSV';
      document.form1.submit();
  }
}

function go_delete() {
    if( chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value="delete";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E10Personal.E10PersonalDetailSV';
        document.form1.submit();
    }
}

function do_list(){
    document.form1.action = "<%=RequestPageName.replace('|','&')%>";
    document.form1.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>개인연금/마이라이프 가입신청 조회</h1></div>

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
                    <th>신청일자</th>
                    <td><input type="text" name="BEGDA" size="14" value="<%= WebUtil.printDate(data.BEGDA) %>" readonly></td>
                    <th class="th02">연금구분</th>
                    <td><input type="text" name="PENT_TEXT" size="10" value="<%=data.ZPENT_TEXT1 %>" readonly></td>
                </tr>
                <tr>
                    <th>가입기간</th>
                    <td><input type="text" name="ENTR_TERM" size="14" style="text-align:right" value="<%= WebUtil.printNum(data.ENTR_TERM) %>" readonly>년</td>
                    <th class="th02">가입보험사</th>
                    <td><input type="text" name="BANK_TEXT" size="14" value="<%=data.ZPENT_TEXT2 %>" readonly></td>
                </tr>
                <tr>
                    <th>개인부담금</th>
                    <td><input type="text" name="PERL_AMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.PERL_AMNT) %>" readonly>원</td>
                    <th class="th02">회사지원액</th>
                    <td><input type="text" name="CMPY_AMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.CMPY_AMNT) %>" readonly>원</td>
                </tr>
                <tr>
                    <th>월실납액</th>
                    <td colspan="3"><input type="text" name="MNTH_AMNT" size="14" style="text-align:right" value="<%= WebUtil.printNumFormat(data.MNTH_AMNT) %>" readonly>원</td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <%= hris.common.util.AppUtil.getAppDetail(data.AINF_SEQN) %>

    <div class="buttonArea">
        <ul class="btn_crud">
<%  if ( RequestPageName != null && !RequestPageName.equals("")) { %>
            <li><a href="javascript:do_list();"><span>목록</span></a><li>
<%  } // end if %>
<%  if (docinfo.isModefy()) { %>
            <li><a href="javascript:go_change()"><span>수정</span></a></li>
            <li><a href="javascript:go_delete()"><span>삭제</span></a></li>
<%  } // end if %>
        </ul>
    </div>

<input type="hidden" name="jobid" value="">
<INPUT TYPE="hidden" name="BeforeJspName" value="">
<input type="hidden" name="AINF_SEQN" value="<%= data.AINF_SEQN %>">
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">

</div>
  </form>
<%@ include file="/web/common/commonEnd.jsp" %>

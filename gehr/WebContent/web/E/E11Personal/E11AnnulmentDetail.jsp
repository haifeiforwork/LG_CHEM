<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금/마이라이프 해약신청                                */
/*   Program ID   : E11AnnulmentDetail.jsp                                      */
/*   Description  : 개인연금/마이라이프 해약신청                                */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E11Personal.*" %>

<%
    WebUserData     user       = (WebUserData)session.getAttribute("user");
    E11PersonalData applData   = (E11PersonalData)request.getAttribute("E11PersonalData");
    E11PersonalData detailData = (E11PersonalData)request.getAttribute("detailData");

    String RequestPageName = (String)request.getAttribute("RequestPageName");

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(applData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function go_delete() {
    if( chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value="delete";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E11Personal.E11AnuulmentDetailSV';
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

    <div class="title"><h1>개인연금/마이라이프 해약신청 조회</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>해약신청일</th>
                    <td><input type="text" name="BEGDA" size="14" value="<%= WebUtil.printDate( applData.BEGDA ) %>" readonly></td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>연금구분</th>
                    <td colspan="3"><input type="text" name="PENT_TEXT" size="14" value="<%= detailData.PENT_TEXT %>" readonly></td>
                </tr>
                <tr>
                    <th>가입년월</th>
                    <td colspan="3"><input type="text" name="CMPY_FROM_M" size="14" value="<%= WebUtil.printDate( applData.CMPY_FROM ).substring(0,7) %>" readonly></td>
                </tr>
                <tr>
                    <th>가입기간</th>
                    <td colspan="3"><input type="text" name="ENTR_TERM" size="14" value="<%= Integer.toString( Integer.parseInt( applData.ENTR_TERM ) ) %>" readonly></td>
                </tr>
                <tr>
                    <th>만기연월</th>
                    <td colspan="3"><input type="text" name="CMPY_TOXX_M" size="14" value="<%= WebUtil.printDate( applData.CMPY_TOXX ).substring(0,7) %>" readonly ></td>
                </tr>
                <tr>
                    <th>잔여월수</th>
                    <td><input type="text" name="LAST_MNTH" size="14" value="<%= detailData.LAST_MNTH %>" readonly ></td>
                    <th class="th02">월납입액</th>
                    <td><input type="text" name="MNTH_AMNT" size="14" value="<%= WebUtil.printNumFormat( applData.MNTH_AMNT ) %>" readonly ></td>
                </tr>
                <tr>
                    <th>가입보험사</th>
                    <td><input type="text" name="BANK_TEXT" size="14" value="<%= detailData.BANK_TEXT %>" readonly ></td>
                    <th class="th02">불입누계</th>
                    <td><input type="text" name="SUMM_AMNT" size="14" value="<%= WebUtil.printNumFormat( detailData.SUMM_AMNT ) %>" readonly >&nbsp;</td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppDetail(applData.AINF_SEQN) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">>
<%  if ( RequestPageName != null && !RequestPageName.equals("")) { %>
            <li><a href="javascript:do_list();"><span>목록</span></a></li>
<%  } // end if %>
<%  if (docinfo.isModefy()) { %>
            <li><a href="javascript:go_delete();"><span>삭제</span></a></li>
<%  } // end if %>
        </ul>
    </div>

  <input type="hidden" name="jobid"           value="">
  <input type="hidden" name="AINF_SEQN"       value="<%= applData.AINF_SEQN %>">
  <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">

  </form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>

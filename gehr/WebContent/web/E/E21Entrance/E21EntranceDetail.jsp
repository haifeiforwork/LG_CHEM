<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 입학축하금                                                  */
/*   Program Name : 입학축하금 조회                                             */
/*   Program ID   : E21EntranceDetail.jsp                                       */
/*   Description  : 입학축하금을 조회할 수 있도록 하는 화면                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-02  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E21Entrance.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    /* 자녀 레코드를 vector로 받는다*/
    Vector          e21EntranceData_vt = (Vector)request.getAttribute("e21EntranceData_vt");
    E21EntranceData data               = (E21EntranceData)e21EntranceData_vt.get(0);

    /* 입학축하금 입력된 결제정보를 vector로 받는다*/
    Vector    AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");

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
<script language="JavaScript">
<!--
function do_change(){
  if( chk_APPR_STAT(0) ){
    document.form1.jobid.value     = "";
    document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

    document.form1.action          = "<%= WebUtil.ServletURL %>hris.E.E21Entrance.E21EntranceChangeSV";
    document.form1.method          = "post";
    document.form1.submit();
  }
}

function do_delete(){
    if( chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value     = "delete";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

        document.form1.action          = "<%= WebUtil.ServletURL %>hris.E.E21Entrance.E21EntranceDetailSV";
        document.form1.method          = "post";
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>입학축하금 신청 조회</h1></div>

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
                    <td><input type="text" name="BEGDA" value="<%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>" size="14" readonly></td>
                    <th class="th02">입학년도</th>
                    <td><input type="text" name="PROP_YEAR" size="4" maxlength="4" value="<%=data.PROP_YEAR%>" readonly>년</td>
                      <input type="hidden" name="FAMSA" value="<%= data.FAMSA %>" size="5" class="input04" readonly>
                      <input type="hidden" name="ATEXT" value="<%= data.ATEXT %>" size="10" class="input04" readonly>
                </tr>
                <tr>
                    <th>이름</th>
                    <td><input type="text" name="LNMHG" value="<%= data.LNMHG %><%= data.FNMHG %>" size="14" readonly></td>
                  <%
                    String reg_no = "";
                    if( !user.empNo.equals(data.PERNR) ) {
                        reg_no = data.REGNO.substring( 0, 6 ) + "*******";
                    } else {
                        reg_no = data.REGNO;
                    }
                   %>
                    <th class="th02">주민등록번호</th>
                    <td>
                        <input type="text" name="reg_no" value="<%= DataUtil.addSeparate(reg_no) %>" size="18" readonly>
                        <input type="hidden" name="REGNO" value="<%= DataUtil.addSeparate(data.REGNO) %>" >
                    </td>
                </tr>
                <tr>
                    <th>학력</th>
                    <td>
                        <input type="text" name="ACAD_CARE" value="<%= data.ACAD_CARE %>" size="5" readonly>
                        <input type="text" name="STEXT" value="<%= data.STEXT %>" size="20" readonly>
                    </td>
                    <th class="th02">교육기관</th>
                    <td>
                        <input type="text" name="FASIN" value="<%= data.FASIN %>" size="40" readonly>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppDetail(AppLineData_vt) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%  if ( RequestPageName != null && !RequestPageName.equals("")) { %>
            <li><a href="javascript:do_list();"><span>목록</span></a></li>
<%  } // end if %>
<%  if (docinfo.isModefy()) { %>
            <li><a href="javascript:do_change();"><span>수정</span></a></li>
            <li><a href="javascript:do_delete();"><span>삭제</span></a></li>
<%  } // end if %>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid"       value="">
    <input type="hidden" name="AINF_SEQN"   value="<%= data.AINF_SEQN %>">
    <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
<!--  HIDDEN  처리해야할 부분 끝-->
</div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

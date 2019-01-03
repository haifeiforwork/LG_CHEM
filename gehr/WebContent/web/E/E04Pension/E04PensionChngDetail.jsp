<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 국민연금 자격변경                                           */
/*   Program Name : 국민연금 자격변경사항 신청 조회                             */
/*   Program ID   : E04PensionChngDetail.jsp                                    */
/*   Description  : 국민연금 자격변경을 조회/삭제할 수 있도록 하는 화면         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  최영호                                          */
/*   Update       : 2005-03-01  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E04Pension.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    /* 국민연금 자격변경사항 레코드를 vector로 받는다*/
    Vector e04PensionChngData_vt  = (Vector)request.getAttribute("e04PensionChngData_vt");

    E04PensionChngData data  = (E04PensionChngData)e04PensionChngData_vt.get(0);

    /* 결제정보를 vector로 받는다*/
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
function MM_openBrWindow(theURL,winName,features) {//v2.0
    window.open(theURL,winName,features);
}

function do_change(){
    if( chk_APPR_STAT(0) ){

        document.form1.jobid.value = "first";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E04Pension.E04PensionChngChangeSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function do_delete(){

    if(chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value = "delete";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E04Pension.E04PensionChngDetailSV";
        document.form1.method = "post";
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
<form name="form1" method="post" action="">

<div class="subWrapper">

    <div class="title"><h1>국민연금 자격변경사항 조회</h1></div>

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
                    <td><input type="text" name="BEGDA" size="14" value='<%= WebUtil.printDate(data.BEGDA,".") %>' readonly></td>
                </tr>
            </table>
        </div>
    </div>

    <h2 class="subtitle">자격사항 변경 </h2>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>변경항목</th>
                    <td colspan="3"><input type="text" name="CHNG_TEXT" size="14" value="<%= data.CHNG_TEXT %>" readonly></td>
                  </tr>
                  <tr>
                    <th>변경전 Data</th>
                    <td><input type="text" name="CHNG_BEFORE" size="20" value="<%= data.CHNG_BEFORE %>" readonly></td>
                    <th class="th02">변경후 Data</th>
                    <td><input type="text" name="CHNG_AFTER" size="20" value="<%= data.CHNG_AFTER %>" readonly></td>
                </tr>
            </table>
        </div>
    </div>
    <!--상단 입력 테이블 끝-->

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
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="AINF_SEQN" value="">
    <input type="hidden" name="CHNG_TEXT" value="">
    <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
<!--  HIDDEN  처리해야할 부분 끝-->

</div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

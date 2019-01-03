<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사내어학검정                                                */
/*   Program Name : 사내어학검정신청 조회                                       */
/*   Program ID   : C04FtestDetail.jsp                                          */
/*   Description  : 어학검정신청에 대한 상세정보 조회하는 화면                  */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C04Ftest.*" %>

<%
    WebUserData  user    = (WebUserData)session.getAttribute("user");

    Vector            C04FtestFirstData_vt = (Vector)request.getAttribute("C04FtestData_vt");
    C04FtestFirstData data                 = new C04FtestFirstData();
    if( C04FtestFirstData_vt.size() > 0 ) {
        data = (C04FtestFirstData)C04FtestFirstData_vt.get(0);
    }
    String PERNR = (String)request.getAttribute("PERNR");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function go_list() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestListSV";
    document.form1.method = "post";
    document.form1.submit();
}


function go_change() {
    if( check_data() ) {

    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestChangeSV";
    document.form1.method = "post";
    document.form1.submit();
    }
}

function go_delete(){
    if( check_data() ) {
    if(confirm("정말 삭제하시겠습니까?") ) {
    document.form1.jobid.value     = "delete";
    document.form1.REQS_DATE.value = changeChar( document.form1.REQS_DATE.value, ".", "" );
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestDetailSV";
    document.form1.method = "post";
    document.form1.submit();
    }
    }
}

function check_data() {
    def  = dayDiff(document.form1.TODATE.value,document.form1.FROM_DATE.value);
    def2 = dayDiff(document.form1.TODATE.value,document.form1.TOXX_DATE.value);

    if( def > 0 || def2 <0 ) {
      alert("신청기간에만 수정 및 삭제를 할 수 있습니다. \n\n사내어학검정 담당자에게 문의하세요");
      return false;
   }
    document.form1.REQS_DATE.value = changeChar( document.form1.REQS_DATE.value, ".", "" );
    return true;
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>사내어학검정신청 조회</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>
<%
    if( C04FtestFirstData_vt.size() > 0 ) {
%>

    <!--리스트 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일</th>
                    <td><%= WebUtil.printDate(data.REQS_DATE) %></td>
                    <th class="th02">구 분</th>
                    <td><%=data.LANG_NAME%></td>
                </tr>
                <tr>
                    <th>신청검정지역</th>
                    <td><%= data.AREA_DESC %></td>
                    <th class="th02">검정일</th>
                    <td><%= WebUtil.printDate(data.EXAM_DATE) %></td>
                </tr>
                <tr>
                    <th>신청기간</th>
                    <td><%= WebUtil.printDate(data.FROM_DATE) %> ~ <%= WebUtil.printDate(data.TOXX_DATE) %></td>
                    <th class="th02">비 고</th>
                    <td>시험 시간 : <%= data.EXIM_DTIM %><%= data.FROM_TIME %> ~ <%= data.TOXX_TIME %></td>
                </tr>
                <%
        if( data.CONF_FLAG.equals("X") ) {
%>
                <tr>
                    <th>상 태</th>
                    <td colspan="3">현재 신청중입니다.</td>
                </tr>
                <%
        } else if( data.CONF_FLAG.equals("Y") ) {
%>
                <tr>
                    <th>상 태</th>
                    <td colspan="3">사내어학검정이 확정되었습니다. (확정검정지역 : <%= data.AREA_DESC2 %> )</td>
                </tr>
                <%
        } else if( data.CONF_FLAG.equals("N") ) {
%>
                <tr>
                    <th>상 태</th>
                    <td colspan="3">사내어학검정이 취소되었습니다.<br>
                    (신청기간 이후에 취소하였으므로 검정비는 급여공제함.)</td>
                </tr>
                <%
        }
%>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%
        if( data.REQS_FLAG.equals("Y") ) {
%>
            <li><a href="javascript:go_list();"><span>목록</span></a></li>
            <li><a href="javascript:go_change();"><span>수정</span></a></li>
            <li><a href="javascript:go_delete();"><span>삭제</span></a></li>
<%
        } else {
%>
            <li><a href="<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestListSV"><span>목록</span></a></li>
<%
        }
%>
        </ul>
    </div>

<%
    }
%>

  </div>
<input type="hidden" name="jobid" value="">
<input type="hidden" name="BUKRS" value="<%= data.BUKRS %>">
<input type="hidden" name="TODATE" value="<%= DataUtil.getCurrentDate() %>">
<input type="hidden" name="REQS_DATE" value="<%= data.REQS_DATE %>">
<input type="hidden" name="EXAM_DATE" value="<%= data.EXAM_DATE %>">
<input type="hidden" name="EXIM_DTIM" value="<%= data.EXIM_DTIM %>">
<input type="hidden" name="FROM_DATE" value="<%= data.FROM_DATE %>">
<input type="hidden" name="FROM_TIME" value="<%= data.FROM_TIME %>">
<input type="hidden" name="LANG_CODE" value="<%= data.LANG_CODE %>">
<input type="hidden" name="TOXX_DATE" value="<%= data.TOXX_DATE %>">
<input type="hidden" name="TOXX_TIME" value="<%= data.TOXX_TIME %>">
<input type="hidden" name="LANG_NAME" value="<%= data.LANG_NAME %>">
<input type="hidden" name="AREA_CODE" value="<%= data.AREA_CODE %>">
<input type="hidden" name="AREA_DESC" value="<%= data.AREA_DESC %>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사내어학검정                                                */
/*   Program Name : 사내어학검정신청 수정                                       */
/*   Program ID   : C04FtestChangeSV                                            */
/*   Description  : 어학검정신청에 대한 상세정보를 가져와 수정하는 화면         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C04Ftest.*" %>
<%@ page import="hris.C.C04Ftest.rfc.*" %>

<%
    WebUserData  user    = (WebUserData)session.getAttribute("user");
    Vector C04FtestFirstData_vt = (Vector)request.getAttribute("C04FtestData_vt");
    C04FtestFirstData data = (C04FtestFirstData)C04FtestFirstData_vt.get(0);
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
function doSubmit() {
    document.form1.jobid.value = "change";
    document.form1.REQS_DATE.value = changeChar( document.form1.REQS_DATE.value, ".", "" );
    document.form1.AREA_DESC.value = document.form1.AREA_CODE.options[document.form1.AREA_CODE.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestChangeSV";
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>사내어학검정신청 수정</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
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
                    <td>
                        <select name="AREA_CODE">
                        <%= WebUtil.printOption((new PlanguageRFC()).getPlanguage(user.companyCode, data.LANG_CODE),data.AREA_CODE) %>
                        </select>
                    </td>
                    <th class="th02">검정일</th>
                    <td><%= WebUtil.printDate(data.EXAM_DATE) %></td>
                </tr>
                <tr>
                    <th>신청기간</th>
                    <td><%= WebUtil.printDate(data.FROM_DATE) %> ~ <%= WebUtil.printDate(data.TOXX_DATE) %></td>
                    <th class="th02">비 고</th>
                    <td>시험 시간 : <%= data.EXIM_DTIM %><%= data.FROM_TIME %> ~ <%= data.TOXX_TIME %></td>
                </tr>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:doSubmit()"><span>저장</span></a></li>
            <li><a href="javascript:history.back()"><span>이전화면</span></a></li>
        </ul>
    </div>

  </div>
<input type="hidden" name="jobid" value="">
<input type="hidden" name="BUKRS" value="<%= user.companyCode %>">
<input type="hidden" name="REQS_DATE" value="<%= data.REQS_DATE%>">
<input type="hidden" name="EXAM_DATE" value="<%= data.EXAM_DATE %>">
<input type="hidden" name="EXIM_DTIM" value="<%= data.EXIM_DTIM %>">
<input type="hidden" name="FROM_DATE" value="<%= data.FROM_DATE %>">
<input type="hidden" name="FROM_TIME" value="<%= data.FROM_TIME %>">
<input type="hidden" name="LANG_CODE" value="<%= data.LANG_CODE %>">
<input type="hidden" name="TOXX_DATE" value="<%= data.TOXX_DATE %>">
<input type="hidden" name="TOXX_TIME" value="<%= data.TOXX_TIME %>">
<input type="hidden" name="LANG_NAME" value="<%= data.LANG_NAME %>">
<input type="hidden" name="AREA_DESC" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

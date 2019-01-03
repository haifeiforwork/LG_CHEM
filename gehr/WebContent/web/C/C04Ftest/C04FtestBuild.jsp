<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사내어학검정                                                */
/*   Program Name : 사내어학검정신청                                            */
/*   Program ID   : C04FtestBuild.jsp                                           */
/*   Description  : 어학검정신청하는 화면                                       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.C.C04Ftest.*" %>
<%@ page import="hris.C.C04Ftest.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    C04FtestFirstData data = (C04FtestFirstData)request.getAttribute("c04FtestFirstData");
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
    if( check_data() ) {
        buttonDisabled();
        document.form1.jobid.value     = "create";
        document.form1.AREA_DESC.value = document.form1.AREA_CODE.options[document.form1.AREA_CODE.selectedIndex].text;
        document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestBuildSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function check_data() {
    document.form1.REQS_DATE.value = changeChar( document.form1.reqs_date1.value, ".", "" );
    document.form1.EXAM_DATE.value = changeChar( document.form1.EXAM_DATE.value, "-", "" );
    document.form1.FROM_DATE.value = changeChar( document.form1.FROM_DATE.value, "-", "" );
    document.form1.TOXX_DATE.value = changeChar( document.form1.TOXX_DATE.value, "-", "" );
    document.form1.FROM_TIME.value = changeChar( document.form1.FROM_TIME.value, ":", "" );
    document.form1.TOXX_TIME.value = changeChar( document.form1.TOXX_TIME.value, ":", "" );

    return true;
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=data.PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>사내어학검정 신청</h1></div>

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
                    <input type="hidden" name="reqs_date1" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>">
                    <th>신청일</th>
                    <td><%= WebUtil.printDate(DataUtil.getCurrentDate()) %></td>
                    <th class="th02">구 분</th>
                    <td><%=data.LANG_NAME%></td>
                </tr>
                <tr>
                    <th>신청검정지역</th>
                    <td>
                        <select name="AREA_CODE">
                            <%= WebUtil.printOption((new PlanguageRFC()).getPlanguage(data.BUKRS, data.LANG_CODE)) %>
                        </select>
                    </td>
                    <th class="th02">검정일 </th>
                    <td><%= WebUtil.printDate(data.EXAM_DATE) %></td>
                </tr>
                <tr>
                    <th>신청기간</th>
                    <td><%= WebUtil.printDate(data.FROM_DATE) %> ~ <%= WebUtil.printDate(data.TOXX_DATE) %></td>
                    <th class="th02">비 고 </th>
                    <td>시험 시간 : <%= data.EXIM_DTIM %><%= data.FROM_TIME %> ~ <%= data.TOXX_TIME %></td>
                </tr>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%  if( data.REQS_FLAG.equals("Y") ) { %>
            <li id="sc_button"><a href="javascript:doSubmit();"><span>신청</span></a></li>
            <li><a href="javascript:history.back()"><span>이전화면</span></a></li>
<%  } else { %>
            <li><a href="javascript:history.back()"><span>이전화면</span></a></li>
<%  } // end if%>
        </ul>
    </div>

  </div>

<input type="hidden" name="jobid" value="">
<input type="hidden" name="BUKRS" value="<%= data.BUKRS %>">
<input type="hidden" name="REQS_DATE" value="">
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


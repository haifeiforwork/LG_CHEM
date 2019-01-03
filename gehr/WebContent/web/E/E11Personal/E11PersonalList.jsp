<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금/마이라이프 조회                                    */
/*   Program ID   : E11PersonalList.jsp                                         */
/*   Description  : 개인연금/마이라이프 조회                                    */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E11Personal.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    Vector E11PersonalData_vt = (Vector)request.getAttribute("E11PersonalData_vt");
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
    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
       size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = document.form1.radiobutton[i].value;
        }
    }

    eval("document.form1.PENT_TYPE.value = document.form1.PENT_TYPE"+command+".value");
    eval("document.form1.BEGDA.value     = document.form1.BEGDA"+command+".value");
    eval("document.form1.ENTR_DATE.value = document.form1.ENTR_DATE"+command+".value");

    document.form1.jobid.value = "detail";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E11Personal.E11PersonalDetailSV";
    document.form1.method = "post";
    document.form1.submit();
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.E.E11Personal.E11PersonalDetailSV";
    frm.target = "";
    frm.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>개인연금/마이라이프 조회</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

<%
    if( E11PersonalData_vt.size() > 0 ) {
%>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:doSubmit();"><span>btn_serch02.gif</span></a></li>
        </ul>
    </div>

<%
    } else {
%>

<%
    }
%>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>선택</th>
                    <th>연금구분</th>
                    <th>가입년월</th>
                    <th>만기연월</th>
                    <th class="lastCol">해약일자</th>
                </tr>
<%
    if( E11PersonalData_vt.size() > 0 ) {
        for( int i = 0 ; i < E11PersonalData_vt.size(); i++ ) {
            E11PersonalData data = (E11PersonalData)E11PersonalData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
            <input type="hidden" name="PENT_TYPE<%= i %>" value="<%= data.PENT_TYPE %>">
            <input type="hidden" name="BEGDA<%= i %>"     value="<%= data.BEGDA %>">
            <input type="hidden" name="ENTR_DATE<%= i %>" value="<%= data.ENTR_DATE %>">

                <tr class="<%=tr_class%>">
                    <td><input type="radio" name="radiobutton" value="<%= i %>" <%= (i==0) ? "checked" : "" %>></td>
                    <td><%= data.PENT_TEXT %></td>
                    <td><%= WebUtil.printDate( data.CMPY_FROM ).substring(0,7) %></td>
                    <td><%= WebUtil.printDate( data.CMPY_TOXX ).substring(0,7) %></td>
                    <td class="lastCol"><%= WebUtil.printDate( data.ABDN_DATE ) %></td>
                </tr>
<%
        }
    } else {
%>
                <tr class="oddRow">
                    <td class="lastCol" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
<%
      }
%>
            </table>
        </div>
    </div>

</div>
<input type="hidden" name="jobid"     value="">
<input type="hidden" name="PENT_TYPE" value="">
<input type="hidden" name="BEGDA"     value="">
<input type="hidden" name="ENTR_DATE" value="">
</form>

<%@ include file="/web/common/commonEnd.jsp" %>


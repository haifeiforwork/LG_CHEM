<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사내어학검정                                                */
/*   Program Name : 사내어학검정 신청                                           */
/*   Program ID   : C04FtestList.jsp                                            */
/*   Description  : 어학검정에 대한 일정을 가져오는 화면                        */
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
    WebUserData user = WebUtil.getSessionUser(request);
    Vector  C04FtestFirstData_vt = (Vector)request.getAttribute("C04FtestFirstData_vt");
    Vector  C04FtestData_vt      = (Vector)request.getAttribute("C04FtestData_vt");
    String  paging               = (String)request.getAttribute("page");
    //PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;

    try {
        pu = new PageUtil(C04FtestFirstData_vt.size(), paging , 10, 10);
    } catch (Exception ex) {
         Logger.debug.println(DataUtil.getStackTrace(ex));
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
function doSubmit(i) {
    document.form1.jobid.value     = "detail";
    document.form1.BUKRS.value     = eval("document.form1.BUKRS"+i+".value")   ;
    document.form1.EXAM_DATE.value = eval("document.form1.EXAM_DATE"+i+".value") ;
    document.form1.EXIM_DTIM.value = eval("document.form1.EXIM_DTIM"+i+".value") ;
    document.form1.FROM_DATE.value = eval("document.form1.FROM_DATE"+i+".value") ;
    document.form1.FROM_TIME.value = eval("document.form1.FROM_TIME"+i+".value") ;
    document.form1.LANG_CODE.value = eval("document.form1.LANG_CODE"+i+".value") ;
    document.form1.TOXX_DATE.value = eval("document.form1.TOXX_DATE"+i+".value") ;
    document.form1.TOXX_TIME.value = eval("document.form1.TOXX_TIME"+i+".value") ;
    document.form1.LANG_NAME.value = eval("document.form1.LANG_NAME"+i+".value") ;
    document.form1.REQS_FLAG.value = eval("document.form1.REQS_FLAG"+i+".value") ;
    document.form1.CONF_FLAG.value = eval("document.form1.CONF_FLAG"+i+".value") ;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestListSV";
    document.form1.method = "post";
    document.form1.submit();
}

function viewDetail(i) {
    document.form1.jobid.value     = "";
    document.form1.LANG_CODE.value = eval("document.form1.LANG_CODE"+i+".value") ;
    document.form1.EXAM_DATE.value = eval("document.form1.EXAM_DATE"+i+".value") ;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestDetailSV";
    document.form1.method = "post";
    document.form1.submit();
}

function pageChange(page){
    document.form1.page.value = page;
    doSubmit();
}
// PageUtil 관련 script - page처리시 반드시 써준다...
// PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}
// PageUtil 관련 script - selectBox 사용시 - Option

function reload() {

    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action =  "<%= WebUtil.ServletURL %>hris.C.C04Ftest.C04FtestListSV";
    frm.target = "";
    frm.submit();
}

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name ="PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>사내어학검정 신청</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

    <!--리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>구분</th>
                    <th><spring:message code="MSG.C.C05.0006"/><%--검정일--%></th>
                    <th>신청기간</th>
                    <th>신청 / 확정</th>
                    <th class="lastCol">상 태</th>
                </tr>
<%
    if( C04FtestFirstData_vt.size() > 0 ) {
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            C04FtestFirstData data = (C04FtestFirstData)C04FtestFirstData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
          <input type="hidden" name="BUKRS<%= i %>"     value="<%= data.BUKRS %>">
          <input type="hidden" name="EXAM_DATE<%= i %>" value="<%= data.EXAM_DATE %>">
          <input type="hidden" name="EXIM_DTIM<%= i %>" value="<%= data.EXIM_DTIM %>">
          <input type="hidden" name="FROM_DATE<%= i %>" value="<%= data.FROM_DATE %>">
          <input type="hidden" name="FROM_TIME<%= i %>" value="<%= data.FROM_TIME %>">
          <input type="hidden" name="LANG_CODE<%= i %>" value="<%= data.LANG_CODE %>">
          <input type="hidden" name="TOXX_DATE<%= i %>" value="<%= data.TOXX_DATE %>">
          <input type="hidden" name="TOXX_TIME<%= i %>" value="<%= data.TOXX_TIME %>">
          <input type="hidden" name="LANG_NAME<%= i %>" value="<%= data.LANG_NAME %>">
          <input type="hidden" name="REQS_FLAG<%= i %>" value="<%= data.REQS_FLAG %>">
          <input type="hidden" name="CONF_FLAG<%= i %>" value="<%= data.CONF_FLAG %>">

                <tr class="<%=tr_class%>">
<%
            if( data.REQS_FLAG.equals("X") || (data.REQS_DATE.equals("0000-00-00") && data.REQS_FLAG.equals("Y"))
                                           || (data.REQS_FLAG.equals("N") && data.CONF_FLAG.equals("")) ) {
%>
                    <td><a href="javascript:doSubmit(<%= i %>);"><font color="#006699"><%= data.LANG_NAME %></font></a></td>
<%
            } else {
%>
                    <td><a href="javascript:viewDetail(<%= i %>);"><font color="#006699"><%= data.LANG_NAME %></font></a></td>
<%
            }
%>
                    <td><%= WebUtil.printDate(data.EXAM_DATE) %></td>
                    <td><%= WebUtil.printDate(data.FROM_DATE) %> ~ <%= WebUtil.printDate(data.TOXX_DATE) %></td>
                    <td><%= WebUtil.printNumFormat(data.REQS_CONT) %> / <%= WebUtil.printNumFormat(data.CONF_CONT) %></td>
<%
            if( data.CONF_FLAG.equals("") ) {             // 신청가능한 어학검정
%>
                    <td>&nbsp;</td>
<%
            } else if( data.CONF_FLAG.equals("X") ) {     // 신청완료상태
%>
                    <td><a class="inlineBtn" href="javascript:viewDetail(<%= i %>);"><span>신청완료</span></a></td>
<%
            } else if( data.CONF_FLAG.equals("Y") ) {     // 확정상태
%>
                    <td><a class="inlineBtn" href="javascript:viewDetail(<%= i %>);"><span>확정</span></a></td>
<%
            } else if( data.CONF_FLAG.equals("N") ) {     // 취소상태
%>
                    <td class="lastCol"><a class="inlineBtn" href="javascript:viewDetail(<%= i %>);"><span>취소</span></a></td>
<%
            }
%>
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
<!-- PageUtil 관련 - 반드시 써준다. -->
            <div class="align_center">
                <input type="hidden" name="page" value="">
                <%= pu == null ? "" : pu.pageControl() %>
            </div>
<!-- PageUtil 관련 - 반드시 써준다. -->
        </div>
    </div>
    <!--주소 리스트 테이블 끝-->

<input type="hidden" name="jobid" value="">
<input type="hidden" name="BUKRS" value="">
<input type="hidden" name="EXAM_DATE" value="">
<input type="hidden" name="EXIM_DTIM" value="">
<input type="hidden" name="FROM_DATE" value="">
<input type="hidden" name="FROM_TIME" value="">
<input type="hidden" name="LANG_CODE" value="">
<input type="hidden" name="TOXX_DATE" value="">
<input type="hidden" name="TOXX_TIME" value="">
<input type="hidden" name="LANG_NAME" value="">
<input type="hidden" name="REQS_FLAG" value="">
<input type="hidden" name="CONF_FLAG" value="">


</div>

</form>
<%@ include file="/web/common/commonEnd.jsp" %>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.C.C07Language.*" %>
<%@ page import="hris.C.rfc.*" %>

<%
//  defult 정렬값 신청일 역정렬
    WebUserData user               = (WebUserData)session.getAttribute("user");
    Vector      c07LanguageData_vt = (Vector)request.getAttribute("c07LanguageData_vt");
    String      paging             = (String)request.getAttribute("page");
    String      sortField          = (String)request.getAttribute("sortField");
    String      sortValue          = (String)request.getAttribute("sortValue");

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if ( c07LanguageData_vt != null && c07LanguageData_vt.size() != 0 ) {
        try {
          pu = new PageUtil(c07LanguageData_vt.size(), paging , 10, 10 );  //Page 관련사항
        } catch (Exception ex) {
          Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess4.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit() {//경조금 상세조회 페이지로
    trans_form();
    document.form2.jobid.value = "detail";

    document.form2.action = "<%= WebUtil.JspURL %>C/C08LanguageDetail.jsp";
    document.form2.method = "post";
    document.form2.submit();
}

function trans_form() {
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
    eval("document.form2.BEGDA.value     = document.form1.BEGDA"+command+".value");
    eval("document.form2.SBEG_DATE.value = document.form1.SBEG_DATE"+command+".value");
    eval("document.form2.SEND_DATE.value = document.form1.SEND_DATE"+command+".value");
    eval("document.form2.STUD_TYPE.value = document.form1.STUD_TYPE"+command+".value");
    eval("document.form2.STUD_INST.value = document.form1.STUD_INST"+command+".value");
    eval("document.form2.LECT_SBJT.value = document.form1.LECT_SBJT"+command+".value");
    eval("document.form2.LECT_TIME.value = document.form1.LECT_TIME"+command+".value");
    eval("document.form2.SELT_DATE.value = document.form1.SELT_DATE"+command+".value");
    eval("document.form2.SETL_WONX.value = document.form1.SETL_WONX"+command+".value");
    eval("document.form2.CARD_CMPY.value = document.form1.CARD_CMPY"+command+".value");
    eval("document.form2.CARD_NUMB.value = document.form1.CARD_NUMB"+command+".value");
    eval("document.form2.CMPY_WONX.value = document.form1.CMPY_WONX"+command+".value");
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form3.page.value = page;
  get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
  document.form3.action = "<%= WebUtil.ServletURL %>hris.C.C08LanguageListSV";
  document.form3.method = "post";
  document.form3.submit();
}

function sortPage( FieldName, FieldValue ){
  if(document.form3.sortField.value==FieldName){
    if(FieldName == 'BEGDA,POST_DATE') {                                     //신청일 sort시
      if(document.form3.sortValue.value == 'desc,desc') {
        document.form3.sortValue.value = 'asc,desc';
      } else {
        document.form3.sortValue.value = 'desc,desc';
      }
    } else if(FieldName == 'STUD_INST,BEGDA') {
      if(document.form3.sortValue.value == 'asc,desc') {                      //학습기관 sort시
        document.form3.sortValue.value = 'desc,desc';
      } else {
        document.form3.sortValue.value = 'asc,desc';
      }
    } else if(FieldName == 'LECT_SBJT,BEGDA') {               //수강과목 sort시
      if(document.form3.sortValue.value == 'asc,desc') {
        document.form3.sortValue.value = 'desc,desc';
      } else {
        document.form3.sortValue.value = 'asc,desc';
      }
    } else if(FieldName == 'SETL_WONX') {                //결제금액 sort시
      if(document.form3.sortValue.value == 'desc') {
        document.form3.sortValue.value = 'asc';
      } else {
        document.form3.sortValue.value = 'desc';
      }
    } else if(FieldName == 'CMPY_WONX') {                                             //회사지원금액 sort시
      if(document.form3.sortValue.value == 'desc') {
        document.form3.sortValue.value = 'asc';
      } else {
        document.form3.sortValue.value = 'desc';
      }
    } else if(FieldName == 'POST_DATE,BEGDA') {          //최종결재일 sort시
      if(document.form3.sortValue.value == 'desc,desc') {
        document.form3.sortValue.value = 'asc,desc';
      } else {
        document.form3.sortValue.value = 'desc,desc';
      }
    }
  } else {
    document.form3.sortField.value = FieldName;
    document.form3.sortValue.value = FieldValue;
  }
  get_Page();
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif','<%= WebUtil.ImageURL %>icon_Darrow_next_o.gif','<%= WebUtil.ImageURL %>icon_arrow_next_o.gif','<%= WebUtil.ImageURL %>icon_Darrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_prev_o.gif')">
<form name="form1" method="post" action="">

<div class="subWrapper">

    <div class="title"><h1>어학지원비 조회</h1></div>

<%
    if( c07LanguageData_vt.size() > 0 ) {
%>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:doSubmit();"><span>조회</span></a>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>선택</th>
                    <th onClick="javascript:sortPage('BEGDA,POST_DATE','desc,desc')" style="cursor:hand">신청일<%= sortField.equals("BEGDA,POST_DATE")     ? ( sortValue.toLowerCase() ).equals("desc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('STUD_INST,BEGDA','asc,desc')"  style="cursor:hand">학습기관<%= sortField.equals("STUD_INST,BEGDA")   ? ( sortValue.toLowerCase() ).equals("desc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('LECT_SBJT,BEGDA','asc,desc')"  style="cursor:hand">수강과목<%= sortField.equals("LECT_SBJT,BEGDA")   ? ( sortValue.toLowerCase() ).equals("desc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('SETL_WONX','desc')"            style="cursor:hand">결제금액<%= sortField.equals("SETL_WONX")         ? ( sortValue.toLowerCase() ).equals("desc")      ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th onClick="javascript:sortPage('CMPY_WONX','desc')"            style="cursor:hand">회사지원금액<%= sortField.equals("CMPY_WONX")     ? ( sortValue.toLowerCase() ).equals("desc")      ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th class="lastCol" onClick="javascript:sortPage('POST_DATE,BEGDA','desc,desc')" style="cursor:hand">최종결재일<%= sortField.equals("POST_DATE,BEGDA") ? ( sortValue.toLowerCase() ).equals("desc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                </tr>
<%
        int j = 0;//내부 카운터용
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            C07LanguageData data = (C07LanguageData)c07LanguageData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td><input type="radio" name="radiobutton" value="<%= j %>" <%=(j==0) ? "checked" : ""%>></td>
                    <td><%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA)%></td>
                    <td><%= data.STUD_INST%></td>
                    <td><%= data.LECT_SBJT%></td>
                    <td class="align_right"><%= WebUtil.printNumFormat(data.SETL_WONX) %></td>
                    <td class="align_right"><%= WebUtil.printNumFormat(data.CMPY_WONX) %></td>
                    <td class="lastCol"><%=data.POST_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.POST_DATE)%></td>
                </tr>
                    <input type="hidden" name="BEGDA<%= j %>"     value="<%= data.BEGDA     %>">
                    <input type="hidden" name="SBEG_DATE<%= j %>" value="<%= data.SBEG_DATE %>">
                    <input type="hidden" name="SEND_DATE<%= j %>" value="<%= data.SEND_DATE %>">
                    <input type="hidden" name="STUD_TYPE<%= j %>" value="<%= data.STUD_TYPE %>">
                    <input type="hidden" name="STUD_INST<%= j %>" value="<%= data.STUD_INST %>">
                    <input type="hidden" name="LECT_SBJT<%= j %>" value="<%= data.LECT_SBJT %>">
                    <input type="hidden" name="LECT_TIME<%= j %>" value="<%= data.LECT_TIME %>">
                    <input type="hidden" name="SELT_DATE<%= j %>" value="<%= data.SELT_DATE %>">
                    <input type="hidden" name="SETL_WONX<%= j %>" value="<%= data.SETL_WONX %>">
                    <input type="hidden" name="CARD_CMPY<%= j %>" value="<%= data.CARD_CMPY %>">
                    <input type="hidden" name="CARD_NUMB<%= j %>" value="<%= data.CARD_NUMB %>">
                    <input type="hidden" name="CMPY_WONX<%= j %>" value="<%= data.CMPY_WONX %>">
<%
        j++;
        }
    } else {
%>

    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table width="790" border="0" cellspacing="1" cellpadding="3" class="table02">
              <tr>
                <th>선택</th>
                <th>신청일</th>
                <th>학습기관</th>
                <th>수강과목</th>
                <th>결제금액</th>
                <th>회사지원금액</th>
                <th>최종결재일</th>
              </tr>
              <tr class="oddRow">
                <td class="lastCol" colspan="7">해당하는 데이터가 존재하지 않습니다.</td>
              </tr>
<%
    }
%>
            </table>
            <!-- PageUtil 관련 - 반드시 써준다. -->
            <div class="align_center">
                <%= pu == null ? "" : pu.pageControl() %>
            </div>
            <!-- PageUtil 관련 - 반드시 써준다. -->
        </div>
    </div>
    <!-- 조회 리스트 테이블 끝-->


</div>
</form>
<form name="form2">
<!-----   hidden field ---------->
    <input type="hidden" name="jobid"     value="">
    <input type="hidden" name="BEGDA"     value="">
    <input type="hidden" name="SBEG_DATE" value="">
    <input type="hidden" name="SEND_DATE" value="">
    <input type="hidden" name="STUD_TYPE" value="">
    <input type="hidden" name="STUD_INST" value="">
    <input type="hidden" name="LECT_SBJT" value="">
    <input type="hidden" name="LECT_TIME" value="">
    <input type="hidden" name="SELT_DATE" value="">
    <input type="hidden" name="SETL_WONX" value="">
    <input type="hidden" name="CARD_CMPY" value="">
    <input type="hidden" name="CARD_NUMB" value="">
    <input type="hidden" name="CMPY_WONX" value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page"      value="<%= paging %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

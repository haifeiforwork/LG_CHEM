<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>


<%
//  defult 정렬값 18번 field 신청일 역정렬
    WebUserData user                = (WebUserData)session.getAttribute("user");
    Vector      D03CongcondData_dis = (Vector)request.getAttribute("D03CondolHolidaysData_dis");
    String      paging              = (String)request.getAttribute("page");
    String      INX                 = (String)request.getAttribute("INX");
    String      sortField           = (String)request.getAttribute("sortField");
    String      sortValue           = (String)request.getAttribute("sortValue");
    Logger.debug.println(this, D03CongcondData_dis.toString());

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if ( D03CongcondData_dis != null && D03CongcondData_dis.size() != 0 ) {
        try {
          pu = new PageUtil(D03CongcondData_dis.size(), paging , 10, 10 );//Page 관련사항
        } catch (Exception ex) {
          Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>
<jsp:include page="/include/header.jsp" />
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D03.0001"/>
</jsp:include>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit() {//경조금 상세조회 페이지로
    trans_form();


    self.close();
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
    for (var i = 0; i < opener.document.form1.CONG_CODE<%=INX%>.length ; i++) {
       if (opener.document.form1.CONG_CODE<%=INX%>[i].value == eval("document.form1.CONG_CODE"+command+".value") ){
           opener.document.form1.CONG_CODE<%=INX%>[i].selected = true;
       }
    }
    eval("opener.document.form1.CONG_DATE"+"<%=INX%>"+".value   = addPointAtDate(document.form1.CONG_DATE"+command+".value.replace('-','').replace('-',''))");
    eval("opener.document.form1.HOLI_CONT"+"<%=INX%>"+".value   = parseInt(document.form1.HOLI_CONT"+command+".value)");
    eval("opener.document.form1.P_A024_SEQN"+"<%=INX%>"+".value = document.form1.AINF_SEQN"+command+".value");
    eval("opener.document.form1.REASON"+"<%=INX%>"+".value = document.form1.CONG_NAME"+command+".value +  '/' +document.form1.RELA_NAME"+command+".value + '/'+ addPointAtDate(document.form1.CONG_DATE"+command+".value.replace('-','').replace('-',''))" );

}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form3.page.value = page;
  get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
  document.form3.action = '<%= WebUtil.ServletURL %>hris.D.D03Vocation.D03CongraListPopSV';
  document.form3.method = "get";
  document.form3.submit();
}

function sortPage( FieldName, FieldValue ){
  if(document.form3.sortField.value==FieldName){
    if(FieldName == 'CONG_NAME,RELA_NAME,CONG_DATE') {      //신청일 sort시
      if(document.form3.sortValue.value == 'asc,asc,desc') {
        document.form3.sortValue.value = 'desc,asc,desc';
      } else {
        document.form3.sortValue.value = 'asc,asc,desc';
      }
    } else if(FieldName == 'RELA_NAME,CONG_NAME,CONG_DATE') {               //경조대상자 관계 sort시
      if(document.form3.sortValue.value == 'asc,asc,desc') {
        document.form3.sortValue.value = 'desc,asc,desc';
      } else {
        document.form3.sortValue.value = 'asc,asc,desc';
      }
    } else if(FieldName == 'CONG_DATE') {               //경조대상자 관계 sort시
      if(document.form3.sortValue.value == 'asc') {
        document.form3.sortValue.value = 'desc';
      } else {
        document.form3.sortValue.value = 'asc';
      }
    } else if(FieldName == 'HOLI_CONT') {               //경조대상자 관계 sort시
      if(document.form3.sortValue.value == 'asc') {
        document.form3.sortValue.value = 'desc';
      } else {
        document.form3.sortValue.value = 'asc';
      }
    }

  } else {
    document.form3.sortField.value = FieldName;
    document.form3.sortValue.value = FieldValue;
  }
  get_Page();
}
function openDocPOP() {
  opener.goCongraBuild();
  self.close();
}
//-->
</SCRIPT>


<form name="form1" method="post" action="">

<div class="listArea">
  <div class="table">

<%
    if( D03CongcondData_dis.size() > 0 ) {
%>
        <!-- 조회 리스트 테이블 시작-->
         <table class="listTable" >
<!--         <table width="560" border="0" cellspacing="1" cellpadding="3" class="listTable"> -->
          <tr>
            <th width="50"><spring:message code="LABEL.D.D12.0049"/><!-- 선택 --></th>
            <th width="100" onClick="javascript:sortPage('CONG_NAME,RELA_NAME,CONG_DATE','asc,asc,desc')"
            style="cursor:hand"><spring:message code="LABEL.D.D03.0004"/><!--경조구분-->
            <%= sortField.equals("CONG_NAME,RELA_NAME,CONG_DATE") ? ( sortValue.toLowerCase() ).equals("desc,asc,desc")     ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>

            <th width="100" onClick="javascript:sortPage('RELA_NAME,CONG_NAME,CONG_DATE','asc,asc,desc')"
            style="cursor:hand"><spring:message code="LABEL.D.D03.0003"/><!--관계-->
            <%= sortField.equals("RELA_NAME,CONG_NAME,CONG_DATE")     ? ( sortValue.toLowerCase() ).equals("desc,asc,desc")     ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>

            <th width="100" onClick="javascript:sortPage('CONG_DATE','asc')"
            style="cursor:hand"><spring:message code="LABEL.D.D03.0005"/><!--경조발생일-->
            <%= sortField.equals("CONG_DATE")                   ? ( sortValue.toLowerCase() ).equals("desc")                  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>

            <th class="lastCol" width="100" onClick="javascript:sortPage('HOLI_CONT','asc')"
            style="cursor:hand"><spring:message code="LABEL.D.D03.0006"/><!--경조휴가일수-->
            <%= sortField.equals("HOLI_CONT")                 ? ( sortValue.toLowerCase() ).equals("desc")                  ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>

          </tr>
<%
        int j = 0;//내부 카운터용
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            D03CondolHolidaysData data = (D03CondolHolidaysData)D03CongcondData_dis.get(i);
%>
          <tr>
            <td >
              <input type="radio" name="radiobutton" value="<%= j %>" onClick="javascript:doSubmit();">
            </td>
            <td ><%=data.CONG_NAME%></td>
            <td ><%=data.RELA_NAME%></td>
            <td ><%=data.CONG_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.CONG_DATE)%></td>
            <td class="lastCol" align="right"><%= WebUtil.printNumFormat(data.HOLI_CONT) %>&nbsp;&nbsp;
            <input type="hidden" name="AINF_SEQN<%= j %>" value="<%= data.AINF_SEQN %>">
            <input type="hidden" name="BEGDA<%= j %>"     value="<%= data.BEGDA     %>">
            <input type="hidden" name="CONG_CODE<%= j %>" value="<%= data.CONG_CODE %>">
            <input type="hidden" name="CONG_NAME<%= j %>" value="<%= data.CONG_NAME %>">
            <input type="hidden" name="RELA_CODE<%= j %>" value="<%= data.RELA_CODE %>">
            <input type="hidden" name="RELA_NAME<%= j %>" value="<%= data.RELA_NAME %>">
            <input type="hidden" name="CONG_DATE<%= j %>" value="<%= data.CONG_DATE %>">
            <input type="hidden" name="HOLI_CONT<%= j %>" value="<%= data.HOLI_CONT %>">
            </td>
          </tr>

<%
        j++;
        }
    } else {
%>
 <table class="listTable" >
        <!-- 조회 리스트 테이블 시작-->

          <tr>
            <th  width="50"><spring:message code="LABEL.D.D12.0049"/><!-- 선택 --></th>
            <th  width="100"><spring:message code="LABEL.D.D03.0004"/><!--경조구분--></th>
            <th  width="100"><spring:message code="LABEL.D.D03.0003"/><!--관계--></th>
            <th  width="100"><spring:message code="LABEL.D.D03.0005"/><!--경조발생일--></th>
            <th class="lastCol" width="100"><spring:message code="LABEL.D.D03.0006"/><!--경조휴가일수--></th>
          </tr>
          <tr align="center">
            <td  colspan="5" class="lastCol"><spring:message code="MSG.D.D03.0001"/><!--경조금 신청 후 경조휴가 신청하셔야 합니다.--></td>
          </tr>
       </table>
        <!-- 조회 리스트 테이블 끝-->
<%
    }
%>

<!-- PageUtil 관련 - 반드시 써준다. -->
<%
    if( D03CongcondData_dis.size() == 0 ) {
%>


            	<div class="buttonArea">
            		<ul class="btn_crud">
            			<li><a class="darken" href="javascript:openDocPOP()">
                           <span><spring:message code="LABEL.D.D03.0002"/></span></a>
                         </li>
                  </ul></div>


<%  } %>

<div>
<%= pu == null ? "" : pu.pageControl() %>
</div>
<!-- PageUtil 관련 - 반드시 써준다. -->

  </table>
  </div>
</div>

</form>

<form name="form2">
<!-----   hidden field ---------->
    <input type="hidden" name="jobid"     value="">
    <input type="hidden" name="AINF_SEQN" value="">
    <input type="hidden" name="BEGDA"     value="">
    <input type="hidden" name="CONG_CODE" value="">
    <input type="hidden" name="CONG_NAME" value="">
    <input type="hidden" name="RELA_CODE" value="">
    <input type="hidden" name="RELA_NAME" value="">
    <input type="hidden" name="CONG_DATE" value="">
    <input type="hidden" name="HOLI_CONT" value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>

<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page"      value="<%= paging %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

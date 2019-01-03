<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>

<%
    String paging              = (String)request.getAttribute("page");
    String sortField           = (String)request.getAttribute("sortField");
    String sortValue           = (String)request.getAttribute("sortValue");
    Vector  A06PrizDetailData_vt = (Vector)request.getAttribute("A06PrizDetailData_vt");
    PageUtil pu = new PageUtil(A06PrizDetailData_vt.size(), paging , 10, 10 );           //Page 관련사항

%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function view_detail(idx) {
    eval("document.form1.PRIZ_UNIT.value = document.form1.PRIZ_UNIT" + idx + ".value");
    p_idx="";
    priz_unit = eval("document.form1.PRIZ_UNIT"+ p_idx + ".value");
    for( i = 0; i < document.form1.PRIZ_UNIT.length; i++ ) {
        if( priz_unit == eval("document.form1.PRIZ_UNIT["+i+"].value") ) {
            eval("document.form1.PRIZ_UNIT["+i+"].checked = true");
        } else {
            eval("document.form1.PRIZ_UNIT["+i+"].checked = false");
        }
    }
    eval("document.form1.ISSU_ORGN.value = document.form1.ISSU_ORGN" + idx + ".value");
    eval("document.form1.PRIZ_RESN.value = document.form1.PRIZ_RESN" + idx + ".value");
    eval("document.form1.PRIZ_AMNT.value = document.form1.PRIZ_AMNT" + idx + ".value");
    eval("document.form1.PAID_TYPE.value = document.form1.PAID_TYPE" + idx + ".value");
    paid_type = eval("document.form1.PAID_TYPE"+ p_idx + ".value");
    for( i = 0; i < document.form1.PAID_TYPE.length; i++ ) {
        if( paid_type == eval("document.form1.PAID_TYPE["+i+"].value") ) {
            eval("document.form1.PAID_TYPE["+i+"].checked = true");
        } else {
            eval("document.form1.PAID_TYPE["+i+"].checked = false");
        }
    }
    eval("document.form1.GRAD_QNTY.value = document.form1.GRAD_QNTY" + idx + ".value");
    eval("document.form1.CMNT_DESC.value = document.form1.CMNT_DESC" + idx + ".value");
    eval("document.form1.PRIZ_DESC.value = document.form1.PRIZ_DESC" + idx + ".value");
    eval("document.form1.GRAD_TEXT.value = document.form1.GRAD_TEXT" + idx + ".value");
    eval("document.form1.BODY_NAME.value = document.form1.BODY_NAME" + idx + ".value");
}

function pageChange(page){
  document.form3.page.value = page;
  //doSubmit();
  get_Page();
}
// PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){  
  document.form3.action = '<%= WebUtil.ServletURL %>hris.A.A06PrizDetailSV';
  document.form3.method = "post";
  document.form3.submit();
}

function sortPage( FieldName, FieldValue ){
  if(document.form3.sortField.value==FieldName){
    if(FieldName == 'BEGDA') {
      if(document.form3.sortValue.value == 'desc') {           //수상일자 sort시
        document.form3.sortValue.value = 'asc';
      } else {
        document.form3.sortValue.value = 'desc';
      }
    } else if(FieldName == 'PRIZ_DESC,GRAD_TEXT,BEGDA') {      //포상항목 - 등급 sort시
      if(document.form3.sortValue.value == 'asc,asc,desc') {
        document.form3.sortValue.value = 'desc,desc,desc';
      } else {
        document.form3.sortValue.value = 'asc,asc,desc';
      }
    }
  } else {
    document.form3.sortField.value = FieldName;
    document.form3.sortValue.value = FieldValue;
  }
  get_Page();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td class="title01">포상내역 조회</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
<!-- 포상내역 리스트 테이블 시작-->
        <table width="750" border="0" cellspacing="1" cellpadding="4" class="table02">
<% 
    if( A06PrizDetailData_vt.size() > 0 ) {
%>
          <tr> 
            <td class="td03" width="180" onClick="javascript:sortPage('PRIZ_DESC,GRAD_TEXT,BEGDA','asc,asc,desc')" style="cursor:hand">포상항목 - 등급<%= sortField.equals("PRIZ_DESC,GRAD_TEXT,BEGDA") ? ( sortValue.toLowerCase() ).equals("desc,desc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></td>
            <td class="td03" width="70"  onClick="javascript:sortPage('BEGDA')"                                    style="cursor:hand">수상일자       <%= sortField.equals("BEGDA")                     ? ( sortValue.toLowerCase() ).equals("desc")           ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></td>
            <td class="td03" width="70">포상점수</td>
            <td class="td03" width="100">시상주체</td>
            <td class="td03" width="80">포상금액</td>
            <td class="td03" width="250">수상내역</td>
          </tr>
<% 
        for( int j = pu.formRow() ; j < pu.toRow(); j++ ) {
            A06PrizDetailData data = (A06PrizDetailData)A06PrizDetailData_vt.get(j); 
%>
          <tr> 
            <td class="td04"><%= data.PRIZ_DESC %>-<%= data.GRAD_TEXT %></td>
            <td class="td04"><%= WebUtil.printDate(data.BEGDA) %></td>
            <td class="td04"><%= data.GRAD_QNTY %></td>
            <td class="td04"><%= data.BODY_NAME %></td>
            <td class="td04" style="text-align:right"><%= WebUtil.printNumFormat(data.PRIZ_AMNT).equals("0") ? "" : WebUtil.printNumFormat(data.PRIZ_AMNT)+" 원" %></td>
            <td class="td04" style="text-align:left"><%= data.PRIZ_RESN %></td>
          </tr>
<%
        }
    } else {
%>
          <tr> 
            <td class="td03" width="180">포상항목 - 등급</td>
            <td class="td03" width="70">수상일자</td>
            <td class="td03" width="70">포상점수</td>
            <td class="td03" width="100">시상주체</td>
            <td class="td03" width="80">포상금액</td>
            <td class="td03" width="250">수상내역</td>
          </tr>
          <tr align="center"> 
            <td class="td04" colspan="6">해당하는 데이터가 존재하지 않습니다.</td>
          </tr>
<%
    }
%>
<!-- PageUtil 관련 - 반드시 써준다. -->
<%
    if( pu != null && !pu.pageControl().equals("") ) {
%>
          <tr>
            <td class="td04" height="25" valign="bottom" colspan="7">
              <%= pu.pageControl() %>
            </td>
          </tr>
<%
    }
%>
<!-- PageUtil 관련 - 반드시 써준다. -->
        </table>
<!-- 포상내역 리스트 테이블 끝-->
      </td>
    </tr>
  </table>
                           
</form>
<form name="form3" METHOD=POST ACTION="">
  <input type="hidden" name="page" value="<%= paging %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

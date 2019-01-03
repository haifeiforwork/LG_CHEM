<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.E.E12Stock.*" %>
<%@ page import="hris.E.E12Stock.rfc.*" %>

<%
    WebUserData      user                 = (WebUserData)session.getAttribute("user");

    /* 증권계좌 리스트를 vector로 받는다*/
    Vector  e12StockCodeData_vt = (Vector)request.getAttribute("e12StockCodeData_vt");

    /* 증권계좌 레코드를 vector로 받는다*/
    Vector              e12BankStockFeeData_vt = (Vector)request.getAttribute("e12BankStockFeeData_vt");
    E12BankStockFeeData data                   = (E12BankStockFeeData)e12BankStockFeeData_vt.get(0);

    /* 결제정보를 vector로 받는다*/
    Vector              AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess2.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function bank_get(obj) {
    var p_idx = obj.selectedIndex - 1;
    if( p_idx >= 0 ) {
        eval("document.form1.SECU_CODE.value = document.form1.SECU_CODE" + p_idx + ".value");
        eval("document.form1.SECU_NAME.value = document.form1.SECU_NAME" + p_idx + ".value");
    } else {
        document.form1.SECU_CODE.value = "";
        document.form1.SECU_NAME.value = "";
        document.form1.GAPP_CONT.value = "";
    }
}

function do_change(){
  if( check_data() ){
    document.form1.jobid.value = "change";
    document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E12Stock.E12StockChangeSV";
    document.form1.method = "post";
    document.form1.submit();
  }
}

function check_data(){
  if( checkNull(document.form1.bankcode, "증권회사를") == false ) {
    return false;
  }

  if( checkNull(document.form1.GAPP_CONT, "계좌번호를" ) == false ) {
    return false;
  } else {
    if( isNaN(document.form1.GAPP_CONT.value) ) {
      alert("숫자만 입력가능합니다.");
      document.form1.GAPP_CONT.focus();
      return false;
    }
  }

  if ( check_empNo() ){
    return false;
  }

  document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value);
  document.form1.BANK_FLAG.value = "02";      // 증권계좌

  return true;
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif')">

<div class="subWrapper">

    <div class="title"><h1>증권계좌 수정</h1></div>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일자</th>
                    <td>
                        <input type="text" name="BEGDA" value="<%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>증권회사</th>
                    <td>
                        <select name="bankcode" onChange="javascript:bank_get(this);">
                            <option value="">-------------</option>
<%
    for(int i = 0 ; i < e12StockCodeData_vt.size() ; i++){
        E12StockCodeData data_stock = (E12StockCodeData)e12StockCodeData_vt.get(i);
%>
                            <option value="<%= data_stock.SECU_CODE %>" <%= data_stock.SECU_CODE.equals( data.SECU_CODE ) ? "selected" : "" %>><%= data_stock.SECU_NAME %></option>
<%
    }
%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>계좌번호</th>
                    <td>
                        <input type="text" name="GAPP_CONT" value="<%= data.GAPP_CONT %>" size="20" maxlength="18" onfocus="javascript:GAPP_CONT.select()">
                    </td>
                </tr>
            </table>
            <div class="commentsMoreThan2">
                <div>통장사본 1부는 담당자에게 제출하시기 바랍니다.</div>
                <div><span class="textPink">*</span> 는 필수 입력사항입니다(계좌번호 입력시 '-'은 입력하지 마시기 바랍니다).</div>
            </div>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle"> 결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppChange(AppLineData_vt,data.PERNR) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:do_change();"><span>저장</span></a> </li>
            <li><a href="javascript:history.back();"><span>취소</span></a></li>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="jobid"     value="">
      <input type="hidden" name="AINF_SEQN" value="">
      <input type="hidden" name="BANK_FLAG" value="">
      <input type="hidden" name="SECU_CODE" value="<%= data.SECU_CODE %>">
      <input type="hidden" name="SECU_NAME" value="<%= data.SECU_NAME %>">

<%
    for(int i = 0 ; i < e12StockCodeData_vt.size() ; i++){
        E12StockCodeData e12StockCodedata = (E12StockCodeData)e12StockCodeData_vt.get(i);
%>
      <!--  증권계좌(코드, 명) 리스트를 저장한다. -->
      <input type="hidden" name="SECU_CODE<%= i %>" value="<%= e12StockCodedata.SECU_CODE  %>">
      <input type="hidden" name="SECU_NAME<%= i %>" value="<%= e12StockCodedata.SECU_NAME  %>">
<%
    }
%>
<%
/*  XxxDetail.jsp로 넘겨주기위해서.. */
    String ThisJspName = (String)request.getAttribute("ThisJspName");
    Logger.debug.println(this, "ThisJspName : "+ ThisJspName);
%>
      <input type="hidden" name="ThisJspName" value="<%= ThisJspName %>">
<!--  HIDDEN  처리해야할 부분 끝-->
  </form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>

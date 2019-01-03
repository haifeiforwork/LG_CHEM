<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
    Vector  HRChargeData_vt = new Vector();
    String  i_bukrs         = request.getParameter("I_BUKRS");
    String  i_grup_numb     = request.getParameter("I_GRUP_NUMB");
    String  i_upmu_code     = request.getParameter("I_UPMU_CODE");

    if( i_grup_numb == null ) {   i_grup_numb = "";   }
    if( i_upmu_code == null ) {   i_upmu_code = "";   }

    try {
        HRChargeData_vt = ( new HRChargeRFC() ).getCharge( i_bukrs, i_grup_numb, i_upmu_code );
    } catch(Exception ex) {
        HRChargeData_vt = null;
    }
%>
<html>
<head>
<title>사업장별 인사담당자 연락처</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
function init() {
<%
    if( HRChargeData_vt == null || HRChargeData_vt.size() == 0 ){
%>
//    alert("등록된 사업장별 인사담당자 연락처가 없습니다.");
//    self.close();
<%
    }
%>
}

function pers_search() {
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/HRChargePop.jsp";
    document.form1.submit();
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init()">
<table width="694" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" onsubmit="return false">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>
      <table width="660" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02" width=275>
            <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"><spring:message code='LABEL.COMMON.0023' /><!-- 사업장별 인사담당자 연락처 -->
          </td>
          <td align="right">
            <table width="385" border="0" cellspacing="1" cellpadding="2" class="table01">
              <tr>
                <td class="td03" width="70"><spring:message code='LABEL.COMMON.0017' /><!-- 사업장 --></td>
                <td class="td03" width="80">
                  <select name="I_GRUP_NUMB" class="input03">
                    <option value = ""><spring:message code='LABEL.COMMON.0024' /><!-- 전체 --></option>
<%= WebUtil.printOption( ( new HRGrupNumbRFC() ).getGrupNumb( i_bukrs ), i_grup_numb ) %>
                  </select>
                </td>
                <td class="td03" width="80"><spring:message code='LABEL.COMMON.0025' /><!-- 업무분야 --></td>
                <td class="td03" width="100">
                  <select name="I_UPMU_CODE" class="input03">
                    <option value = ""><spring:message code='LABEL.COMMON.0024' /><!-- 전체 --></option>
<%= WebUtil.printOption( ( new HRUpmuCodeRFC() ).getUpmuCode( i_bukrs ), i_upmu_code ) %>
                  </select>
                </td>
                <td class="td03" width="50" style="padding-top: 5px">
                  <input type="hidden" name="I_BUKRS" value="<%= i_bukrs %>">
                  <a href="javascript:pers_search();"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" border="0"></a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan=2>&nbsp;</td>
        </tr>
        <tr>
          <td colspan=2>
            <table width="660" border="0" cellspacing="1" cellpadding="2" class="table01">
              <tr>
                <td class="td03" width="85"><spring:message code='LABEL.COMMON.0017' /><!-- 사업장 --></td>
                <td class="td03" width="65"><spring:message code='LABEL.COMMON.0025' /><!-- 업무분야 --></td>
                <td class="td03" width="80"><spring:message code='LABEL.COMMON.0016' /><!-- 담당자 --></td>
                <td class="td03" width="65"><spring:message code='LABEL.COMMON.0018' /><!-- 연락처 --></td>
                <td class="td03" width="365"><spring:message code='LABEL.COMMON.0026' /><!-- 담당업무 --></td>
              </tr>
<%
    if( HRChargeData_vt != null && HRChargeData_vt.size() > 0 ){
//        old_GRUP_NAME = HRChargeData.GRUP_NAME;
        for( int i = 0 ; i < HRChargeData_vt.size() ; i++ ) {
            HRChargeData HRChargeData = (HRChargeData)HRChargeData_vt.get(i);
%>
              <tr align="center">
                <td class="td04"><%= HRChargeData.GRUP_NAME %></td>
                <td class="td04"><%= HRChargeData.UPMU_NAME %></td>
                <td class="td04"><%= HRChargeData.ENAME %>&nbsp;<%= HRChargeData.TITEL %></td>
                <td class="td04"><%= HRChargeData.TELNUMBER %></td>
                <td class="td04" style="text-align:left;padding-left:2px"><%= HRChargeData.UPMU_DESC %></td>
              </tr>
<%
        }
    } else {
%>
              <tr>
                <td class="td04" colspan="5"><spring:message code='LABEL.COMMON.0027' /><!-- 등록된 사업장별 인사담당자 연락처가 없습니다. --></td>
              </tr>
<%
    }
%>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan=2>&nbsp;</td>
        </tr>
        <tr>
          <td colspan=2 align="center">
            <a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>btn_close.gif" border="0"></a>
          </td>
        </tr>
        <tr>
          <td colspan=2>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</form>
</table>
<%@ include file="commonEnd.jsp" %>

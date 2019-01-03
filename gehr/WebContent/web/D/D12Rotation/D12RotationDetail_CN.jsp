<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : 신청
*   2Depth Name  : 부서근태
*   Program Name : 부서일일근태관리
*   Program ID   : D12Rotation|D12RotationDetail.jsp
*   Description  : 부서일일근태관리 화면
*   Note         :
*   Update       :
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="hris.D.D12Rotation.D12RotationCnData" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags-common" tagdir="/WEB-INF/tags/common" %>

<%
WebUserData user    = (WebUserData)session.getAttribute("user");                                          //세션.
String I_DATE  = WebUtil.nvl(request.getParameter("I_DATE"));          //기간
String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                  //부서코드
String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                                //부서명
Vector D12RotationData_vt = (Vector)request.getAttribute("D12RotationData_vt");
String disabledSubOrg = "true";

if( I_DATE == null|| I_DATE.equals("")) {
    I_DATE = DataUtil.getCurrentDate();           //1번째 조회시
}
%>
<%-- <c:set var="disabledSubOrg" value="<%=disabledSubOrg%>" /> --%>
<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
//기준일자 변경시 교대조 리스트를 다시 조회한다.
function after_listSetting(){
	listSetting(document.form1.S_DATE);
}

function listSetting(obj) {
	blockFrame();
	if( obj.value != "" && dateFormat(obj) ) {
		l_date = removePoint(obj.value);

		document.form1.I_DATE.value  = removePoint(obj.value);
		document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
		document.form1.hdn_excel.value = "";
		document.form1.target = "_self";
		document.form1.submit();
	}
}

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
	frm = document.form1;

	frm.hdn_deptId.value = deptId;
	frm.hdn_deptNm.value = deptNm;
	frm.hdn_excel.value = "";
	frm.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
	frm.target = "_self";
	frm.submit();
 }

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV";
    frm.target = "hidden";
    frm.submit();
}

$(document).ready(function(){
	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
 });

</script>

<jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="I_DATE"   value="<%= I_DATE %>">
<input type="hidden" name="I_VALUE1"  value="">
<!--   부서검색 보여주는 부분 시작   -->
<%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>
<!--   부서검색 보여주는 부분  끝    -->
<div class="tableInquiry">
  <table border="0" cellpadding="0" cellspacing="0">
    <tr>
      <th width="90"><spring:message code='LABEL.D.D14.0003'/><!-- 조회일자 --></th>
      <td>
        <input type="text" class="date" name="S_DATE" value="<%= WebUtil.printDate(I_DATE) %>" size="15">

        <div class="tableBtnSearch tableBtnSearch2">
        	<a href="javascript:after_listSetting()" class="search"><span><spring:message code='BUTTON.COMMON.SEARCH'/><!--조회--></span></a>
        </div>
      </td>
    </tr>
  </table>
</div>
<%if(D12RotationData_vt.size() > 0 || D12RotationData_vt != null){%>
<div class="buttonArea">
    <ul class="btn_mdl">
        <li><a class="unloading" href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
    </ul>
</div>
<%
}
String tempDept = "";
for( int i = 0; i < D12RotationData_vt.size(); i++ ){
	D12RotationCnData deptData = (D12RotationCnData)D12RotationData_vt.get(i);

	if( !deptData.ORGEH.equals(tempDept) ){
%>
<div class="listArea">
	<div class="listTop">
		<h2 class="subtitle"><spring:message code='LABEL.D.D12.0005'/><!-- 부서 --> : <strong><%=deptData.ORGTX%></strong></h2>
		<div class="clear"></div>
	</div>
	<div class="wideTable" style="border-top: 2px solid #c8294b;">
		<table class="listTable" >
			<colgroup>
				<col width="4%"/>
				<col width="6%"/>
				<col width="12%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="12%"/>
				<col width="4%"/>
				<col width="4%"/>
				<col width="4%"/>
				<col width="4%"/>
				<col width="8%"/>
				<col width="8%"/>
			</colgroup>
			<thead>
			<tr>
				<th><spring:message code="LABEL.D.D12.0017"/><!-- Pers.No --></th>
				<th><spring:message code="LABEL.D.D12.0018"/><!-- Name --></th>
				<th><spring:message code="LABEL.D.D12.0053"/><!-- Daily Work Schedule --></th>
				<th><spring:message code="LABEL.D.D12.0054"/><!-- DWS.Begin Time --></th>
				<th><spring:message code="LABEL.D.D12.0055"/><!-- DWS.End Time --></th>
				<th><spring:message code="LABEL.D.D12.0056"/><!-- Act.Begin Time --></th>
				<th><spring:message code="LABEL.D.D12.0057"/><!-- Act.End Time --></th>
				<th><spring:message code="LABEL.D.D12.0058"/><!-- Act.Begin Time(Gate) --></th>
				<th><spring:message code="LABEL.D.D12.0059"/><!-- Act.End Time(Gate) --></th>
				<th><spring:message code="LABEL.D.D12.0060"/><!-- Remark --></th>
				<th><spring:message code="LABEL.D.D12.0061"/><!-- O/T(Night) --></th>
				<th><spring:message code="LABEL.D.D12.0062"/><!-- O/T(Workday) --></th>
				<th><spring:message code="LABEL.D.D12.0063"/><!-- O/T(offday) --></th>
				<th><spring:message code="LABEL.D.D12.0064"/><!-- O/T(Holiday) --></th>
				<th><spring:message code="LABEL.D.D12.0065"/><!-- Absence --></th>
				<th class="lastCol"><spring:message code="LABEL.D.D12.0066"/><!-- Attendance --></th>
			</tr>
			</thead>
<%
for( int j = 0; j < D12RotationData_vt.size(); j++ ){
	D12RotationCnData data = (D12RotationCnData)D12RotationData_vt.get(j);

	if( data.ORGEH.equals(deptData.ORGEH) ){

		String tr_class = "";
		if( j % 2 == 0){
			tr_class = "oddRow";
		}else{
			tr_class = "";
		}
%>

			<tr class="<%= tr_class%>">
				<td nowrap><%= data.PERNR %> </td>
				<td nowrap><%= data.ENAME %> </td>
				<td nowrap><%= data.TPROG %> </td>
				<td nowrap><%= data.PL_BEG %> </td>
				<td nowrap><%= data.PL_END %> </td>
				<td nowrap><%= data.AC_BEG %> </td>
				<td nowrap><%= data.AC_END %> </td>
				<td nowrap><%= data.ZC_BEG %> </td>
				<td nowrap><%= data.ZC_END %> </td>
				<td nowrap><%= data.REMARK %> </td>
				<td nowrap><%= data.OT1 %> </td>
				<td nowrap><%= data.OT2 %> </td>
				<td nowrap><%= data.OT3 %> </td>
				<td nowrap><%= data.OT4 %> </td>
				<td nowrap><%= data.AB_TEXT %> </td>
				<td nowrap class="lastCol"><%= data.AT_TEXT %></td>
			</tr>
<%
	}
}
%>
			<tags:table-row-nodata list="${D12RotationData_vt}" col="16" />
		</table>
	</div>
</div>
<%
	tempDept = deptData.ORGEH;
	}
}
%>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

<%/***************************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Quota Plan/Result Status
*   Program ID   		: F79QuotaPlanResultStatus.jsp
*   Description  		: 월별/조직별 인원계획 대비 실적 현황 조회를 위한 jsp 파일 (USA - LGCPI(G400))
*   Note         		: 없음
*   Creation     		:
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.*" %>
<%
	request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");                       	// 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);		// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                 	// 부서명
    String searchYear = WebUtil.nvl((String)request.getAttribute("searchYear"));			// 대상년월

    Vector F79QuotaPlanResultStatusData_vt = (Vector)request.getAttribute("F79QuotaPlanResultStatusData_vt");   	// 내용
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

    List list = (List)request.getAttribute("metaNote");
    HashMap meta = null;
    HashMap meta1 = null;
    if (list != null) {
	    meta = (HashMap)list.get(0);
	    meta1 = (HashMap)list.get(1);
	}

    F79QuotaPlanResultStatusData total = new F79QuotaPlanResultStatusData();
    AppUtilEurp.initEntity(total,"0");
    if (F79QuotaPlanResultStatusData_vt != null && F79QuotaPlanResultStatusData_vt.size() > 0)
	    total = (F79QuotaPlanResultStatusData)F79QuotaPlanResultStatusData_vt.get(F79QuotaPlanResultStatusData_vt.size() - 1 );
    AppUtilEurp.nvlEntity(total);

	DataUtil data = new DataUtil();
%>



<jsp:include page="/include/header.jsp"/>


<SCRIPT LANGUAGE="JavaScript">
	<!--
//상세화면으로 이동.
	function goDetail(paramA, paramB, paramC, paramD, value) {
		frm = document.form1;

		if (value!= "" && value!= "0") {
			frm.hdn_gubun.value = "25";             				// 조직/월별 인원계획 대비 실적 현황
			frm.hdn_deptId.value = "<%= deptId %>";  		// 조회된 부서코드
			frm.hdn_paramA.value = paramA;           			// Org. Unit
			frm.hdn_paramB.value = paramB;						// Contract Type
			frm.hdn_paramC.value = paramC;					// Local Current Date
			frm.hdn_paramD.value = paramD;					// Cloum Name

			frm.hdn_excel.value = "";
			frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
			frm.target = "_self";
			frm.submit();
		}
	}

	// 년도별 조회
	function zocrsn_get() {
		frm = document.form1;

		if (frm.year != null) {
			frm.searchYear.value  = frm.year.options[frm.year.selectedIndex].text;
		}

		frm.hdn_excel.value = "";
		frm.target = "_self";
		frm.method = "post";
		frm.action = "<%= WebUtil.ServletURL %>hris.F.F79QuotaPlanResultStatusSV";
		frm.submit();

	}

	//Execl Down 하기
	function excelDown() {
		frm = document.form1;

		if (frm.year != null) {
			frm.searchYear.value  = frm.year.options[frm.year.selectedIndex].text;
		}

		frm.hdn_excel.value = "ED";
		frm.action = "<%= WebUtil.ServletURL %>hris.F.F79QuotaPlanResultStatusSV";
		frm.target = "hidden";
		frm.submit();
	}
	//-->
</SCRIPT>

 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>

<form name="form1" method="post" onsubmit="return false">
<!-- 상단 검색테이블 끝-->
<input type="hidden" name="hdn_deptId" value="<%= deptId %>">
<input type="hidden" name="hdn_deptNm" value="<%= deptNm %>">
<input type="hidden" name="hdn_excel" value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">
<input type="hidden" name="hdn_Popflag" value="N">

<input type="hidden" name="hdn_gubun" value="">
<input type="hidden" name="hdn_paramA" value="">
<input type="hidden" name="hdn_paramB" value="">
<input type="hidden" name="hdn_paramC" value="">
<input type="hidden" name="hdn_paramD" value="">
<input type="hidden" name="hdn_paramE" value="">
<input type="hidden" name="hdn_paramF" value="">
<input type="hidden" name="searchYear" value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<!-- 상단 검색테이블 시작-->
<div class="tableInquiry">
	<table>
		<tr>
			<td>
				<select name="year" onchange="javascript:">
				<%
				int year1;
				int currentYear = Integer.parseInt(DataUtil.getCurrentYear());
				int nextYear = Integer.parseInt(DataUtil.getCurrentYear())+1;
				for (int i = currentYear; i <= nextYear; i++) {
					year1 = Integer.parseInt(searchYear);
				%>
	        	<option value="<%= i %>" <%= year1 == i ? "selected" : " " %>><%= i %></option>
				<%
			    }
				%>
        			</select>
        			<div class="tableBtnSearch tableBtnSearch2">
					<a class="search" href="javascript:zocrsn_get();"><span><spring:message code='BUTTON.COMMON.SEARCH'/></span></a>
				</div>
			</td>
		</tr>
	</table>
</div>

<div class="listArea">
    <div class="listTop">
        <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
          <div class="buttonArea">
              <ul class="btn_mdl">
                  <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
              </ul>
          </div>
	</div>
	<div class="wideTable" style="border-top: 2px solid #c8294b;">
		<table class="listTable">
		<thead>
			<tr>
				<th rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --></th>
				<th rowspan="2"><spring:message code='LABEL.F.F79.0001'/><!-- Contract Type Text --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0002'/><!-- January --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0003'/><!-- February --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0004'/><!-- March --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0005'/><!-- April --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0006'/><!-- May --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0007'/><!-- June --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0008'/><!-- July --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0009'/><!-- August --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0010'/><!-- September --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0011'/><!-- October --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0012'/><!-- November --></th>
	          	<th colspan="2"><spring:message code='LABEL.F.F79.0013'/><!-- December --></th>
			</tr>

			<tr>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
				<th><spring:message code='LABEL.F.F79.0014'/><!-- Plan --></th>
				<th><spring:message code='LABEL.F.F79.0015'/><!-- Result --></th>
			</tr>
			</thead>
			<%
			if (F79QuotaPlanResultStatusData_vt != null && F79QuotaPlanResultStatusData_vt.size() > 0) {

        	// 전체 테이블 크기 조절.
        	int tableSize = 0;

        	String temp = "";
        	String temp1 = "";

			for (int i = 0; i < F79QuotaPlanResultStatusData_vt.size(); i ++) {
				F79QuotaPlanResultStatusData entity = (F79QuotaPlanResultStatusData)F79QuotaPlanResultStatusData_vt.get(i);
			%>
			<tr class="borderRow">
	        	<%
				if (!temp.equals(entity.ORGTX)) {
	        	%>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":""%>" rowspan="<%= meta.get(entity.ORGTX) %>" nowrap colspan="<%=  entity.ORGTX.equals("TOTAL")?"2":"0" %>" style="text-align:<%=  entity.ORGTX.equals("TOTAL")?"center":"left" %>"><%=  entity.ORGTX %></td>
	        	<%
				}
				if (!entity.ORGTX.equals("TOTAL")) {
					if (!temp.equals(entity.ORGTX) || !temp1.equals(entity.CTTXT)/*&& !temp2.equals(entity.CTTXT) */) {
						int rows = ((Integer)meta1.get(entity.ORGTX + entity.CTTXT)).intValue();
	        	%>
	        	<td class="<%=  entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" nowrap="nowrap" rowspan="<%=  rows %>" style="text-align:left"><%=  entity.CTTXT %></td>
				<%
					}
				}
				%>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN01.equals("0") ? "" : entity.PLN01 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT01', '<%= entity.RLT01 %>')" ><%=  entity.RLT01.equals("0") ? "" : entity.RLT01 %></a></td>
				<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN02.equals("0") ? "" : entity.PLN02 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT02', '<%= entity.RLT02 %>')" ><%=  entity.RLT02.equals("0") ? "" : entity.RLT02 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN03.equals("0") ? "" : entity.PLN03 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT03', '<%= entity.RLT03 %>')" ><%=  entity.RLT03.equals("0") ? "" : entity.RLT03 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN04.equals("0") ? "" : entity.PLN04 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT04', '<%= entity.RLT04 %>')" ><%=  entity.RLT04.equals("0") ? "" : entity.RLT04 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN05.equals("0") ? "" : entity.PLN05 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT05', '<%= entity.RLT05 %>')" ><%=  entity.RLT05.equals("0") ? "" : entity.RLT05 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN06.equals("0") ? "" : entity.PLN06 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT06', '<%= entity.RLT06 %>')" ><%=  entity.RLT06.equals("0") ? "" : entity.RLT06 %></a></td>
				<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN07.equals("0") ? "" : entity.PLN07 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT07', '<%= entity.RLT07 %>')" ><%=  entity.RLT07.equals("0") ? "" : entity.RLT07 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN08.equals("0") ? "" : entity.PLN08 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT08', '<%= entity.RLT08 %>')" ><%=  entity.RLT08.equals("0") ? "" : entity.RLT08 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN09.equals("0") ? "" : entity.PLN09 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT09', '<%= entity.RLT09 %>')" ><%=  entity.RLT09.equals("0") ? "" : entity.RLT09 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN10.equals("0") ? "" : entity.PLN10 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT10', '<%= entity.RLT10 %>')" ><%=  entity.RLT10.equals("0") ? "" : entity.RLT10 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN11.equals("0") ? "" : entity.PLN11 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT11', '<%= entity.RLT11 %>')" ><%=  entity.RLT11.equals("0") ? "" : entity.RLT11 %></a></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" ><%=  entity.PLN12.equals("0") ? "" : entity.PLN12 %></td>
	        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":entity.CTTXT.equals("SUM")?"td11_2":"" %>" >
	        		<a href="javascript:goDetail('<%= entity.ORGEH %>', '<%= entity.CTTYP %>', '<%= data.getCurrentDate() %>', 'RLT12', '<%= entity.RLT12 %>')" ><%=  entity.RLT12.equals("0") ? "" : entity.RLT12 %></a></td>
	        </tr>
        	<%
				temp = entity.ORGTX;
				temp1 = entity.CTTXT;
				}
			} else {
        	%>
        	<tr>
				<td class="lastCol" colspan="26"><spring:message code='MSG.F.FCOMMON.0002'/></td>
			</tr>
        <%
        	}
        %>
		</table>
	</div>
</div>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
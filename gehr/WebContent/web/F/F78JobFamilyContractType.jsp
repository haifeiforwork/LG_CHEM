<%/***************************************************************************************
*   System Name  	: g-HR
*   1Depth Name		: Organization & Staffing
*   2Depth Name  	: Headcount
*   Program Name 	: Org.Unit/Contract Type
*   Program ID   		: F78JobFamilyContractType.jsp
*   Description  		: 직군별 계약 유형 조회를 위한 jsp 파일
*   Note         		: 없음
*   Creation     		:
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.common.util.*" %>
<%
	request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");                       	// 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);		// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                 	// 부서명

    Vector F78JobFamilyContractTypeTitle_vt = (Vector)request.getAttribute("F78JobFamilyContractTypeTitle_vt");   	// 제목
    Vector F78JobFamilyContractTypeNote_vt = (Vector)request.getAttribute("F78JobFamilyContractTypeNote_vt");   	// 제목

    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

    HashMap metaTitle = (HashMap)request.getAttribute("metaTitle");

    List list = (List)request.getAttribute("metaNote");
    HashMap meta = null;
    HashMap meta1 = null;
    if (list != null) {
	    meta = (HashMap)list.get(0);
	    meta1 = (HashMap)list.get(1);
	}

    F78JobFamilyContractTypeNoteData total = new F78JobFamilyContractTypeNoteData();
    AppUtilEurp.initEntity(total,"0");
    if (F78JobFamilyContractTypeNote_vt != null && F78JobFamilyContractTypeNote_vt.size() > 0)
	    total = (F78JobFamilyContractTypeNoteData)F78JobFamilyContractTypeNote_vt.get(F78JobFamilyContractTypeNote_vt.size() - 1 );
    AppUtilEurp.nvlEntity(total);
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(paramB, paramC, paramD, paramE, paramF, value) {
    frm = document.form1;

    if (value!= "" && value!= "0") {

        paramA = "00000000";
        /*
        if (selectedItemNm == "TOTAL") {
        	paramA = "00000000";
        	paramD = "8888";
        }
		*/
        frm.hdn_gubun.value = "24";             				// 직급별 계약 유형 현황
        frm.hdn_deptId.value = "<%= deptId %>";  		// 조회된 부서코드
        frm.hdn_paramA.value = paramA;           			// 조직 '00000000' (약속되어진 코드)
        frm.hdn_paramB.value = paramB;						// 인사영역
        frm.hdn_paramC.value = paramC;					// 직군
        frm.hdn_paramD.value = paramD;					// Job
        frm.hdn_paramE.value = paramE;     				// Contract Type
        frm.hdn_paramF.value = paramF;     				// gubun (CLS)
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F78JobFamilyContractTypeSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>

 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId" value="<%= deptId %>">
<input type="hidden" name="hdn_deptNm" value="<%= deptNm %>">
<input type="hidden" name="hdn_excel" value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">
<input type="hidden" name="hdn_Popflag" value="N">

<input type="hidden" name="hdn_gubun" value="">
<input type="hidden" name="hdn_paramA" value="00000000">
<input type="hidden" name="hdn_paramB" value="">
<input type="hidden" name="hdn_paramC" value="">
<input type="hidden" name="hdn_paramD" value="">
<input type="hidden" name="hdn_paramE" value="">
<input type="hidden" name="hdn_paramF" value="">

<%
	if (F78JobFamilyContractTypeTitle_vt != null && F78JobFamilyContractTypeTitle_vt.size() > 0) {

        // 전체 테이블 크기 조절.
        int tableSize = 0;
%>
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
					<th><spring:message code='LABEL.F.F03.0002'/><!-- Pers. Area --></th>
					<th><spring:message code='LABEL.F.F04.0004'/><!-- Job Family --></th>
					<th><spring:message code='LABEL.F.F00.0012'/><!-- Job --></th>
					<%
					String tmp = "";
					// 타이틀.
					for (int k = 0; k < F78JobFamilyContractTypeTitle_vt.size(); k++) {
						F78JobFamilyContractTypeTitleData titleData = (F78JobFamilyContractTypeTitleData)F78JobFamilyContractTypeTitle_vt.get(k);
						int cols = (((Integer)metaTitle.get(titleData.CLSFY)).intValue());
					%>
					<th nowrap><%= titleData.CTTXT %></th>
					<%
					}
					%>
				</tr>
				</thead>
				<%
        		String temp = "";
        		String temp1 = "";
        		String temp2 = "";
        		String temp3 = "";

        		for (int i = 0; i < F78JobFamilyContractTypeNote_vt.size(); i ++) {
        			F78JobFamilyContractTypeNoteData entity = (F78JobFamilyContractTypeNoteData)F78JobFamilyContractTypeNote_vt.get(i);
        		%>
        		<tr class="borderRow">
					<%
        				if (!temp.equals(entity.PBTXT)) {
        			%>
        			<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":""%>" rowspan="<%= meta.get(entity.PBTXT) %>" nowrap colspan="<%=  entity.PBTXT.equals("TOTAL")?"3":"0" %>" style="text-align:<%=  entity.PBTXT.equals("TOTAL")?"center":"" %>"><%=  entity.PBTXT %></td>
        			<%
        			}
        			if (!entity.PBTXT.equals("TOTAL")) {
        				if (!temp.equals(entity.PBTXT) || !temp1.equals(entity.JIKGT)/*&& !temp2.equals(entity.STELL_TEXT) */) {
        					int rows = ((Integer)meta1.get(entity.PBTXT + entity.JIKGT)).intValue();

        			%>
        			<td class="<%=  entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" nowrap="nowrap" rowspan="<%=  rows %>" style="text-align:">&nbsp;&nbsp;&nbsp;&nbsp;<%=  entity.JIKGT %></td>
					<%
					}
					%>
        			<td class="<%=  entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" nowrap="nowrap" style="text-align:<%= entity.STELL_TEXT.equals("SUM")?"center":"" %>"	>&nbsp;&nbsp;&nbsp;&nbsp;<%=  entity.STELL_TEXT %></td>
        			<%
        			}
        			if (Integer.parseInt(total.CNT01) > 0) {
        			%>
        			<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
        				<a href="javascript:goDetail('<%=  entity.WERKS %>','<%=  entity.JIKGU %>','<%=  entity.STELL %>','<%=  entity.CTT01 %>','<%= entity.CLS01 %>','<%= entity.CNT01 %>')" title='<%=  entity.STELL_TEXT %>'><%=  WebUtil.printNumFormat(entity.CNT01) %></a>
        			</td>
 					<%
 					}
 	        		if (Integer.parseInt(total.CNT02) > 0) {
        			%>
        			<td class="<%=  entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
        				<a href="javascript:goDetail('<%=  entity.WERKS %>','<%=  entity.JIKGU %>','<%=  entity.STELL %>','<%=  entity.CTT02 %>','<%= entity.CLS02 %>','<%= entity.CNT02 %>')" title='<%=  entity.STELL_TEXT %>'><%=  WebUtil.printNumFormat(entity.CNT02) %></a>
        			</td>
 					<%
 					}
          			if (Integer.parseInt(total.CNT03) > 0) {
           			%>
        			<td class="<%=  entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>">
        				<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT03 %>','<%= entity.CLS03 %>','<%= entity.CNT03 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT03) %></a>
        			</td>
           			<%
          			}
          			if (Integer.parseInt(total.CNT04) > 0) {
           			%>
        			<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>">
        				<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT04 %>','<%= entity.CLS04 %>','<%= entity.CNT04 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT04) %></a>
        			</td>
        			<%
        			}
        			if (Integer.parseInt(total.CNT05) > 0 ) {
        			%>
        			<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>">
        				<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT05 %>','<%= entity.CLS05 %>','<%= entity.CNT05 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT05)%></a>
        			</td>
					<%
					}
					if (Integer.parseInt(total.CNT06) > 0 ) {
					%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT06 %>','<%= entity.CLS06 %>','<%= entity.CNT06 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT06) %></a>
		        	</td>
					<%
					}
					if (Integer.parseInt(total.CNT07) > 0) {
					%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT07 %>','<%= entity.CLS07 %>','<%= entity.CNT07 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT07) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT08) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT08 %>','<%= entity.CLS08 %>','<%= entity.CNT08 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT08) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT09) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT09 %>','<%= entity.CLS09 %>','<%= entity.CNT09 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT09) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT10) > 0 ) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT10 %>','<%= entity.CLS10 %>','<%= entity.CNT10 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT10) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT11) > 0 ) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT11 %>','<%= entity.CLS11 %>','<%= entity.CNT11 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT11) %></a>
		        	</td>
		        	<%
		        	}
					if (Integer.parseInt(total.CNT12) > 0) {
					%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT12 %>','<%= entity.CLS12 %>','<%= entity.CNT12 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT12) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT13) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT13 %>','<%= entity.CLS13 %>','<%= entity.CNT13 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT13) %></a>
		        	</td>
		        	<%
					}
				    if (Integer.parseInt(total.CNT14) > 0) {
					%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT14 %>','<%= entity.CLS14 %>','<%= entity.CNT14 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT14) %></a>
		        	</td>
					<%
					}
		        	if (Integer.parseInt(total.CNT15) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT15 %>','<%= entity.CLS15 %>','<%= entity.CNT15 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT15) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT16) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT16 %>','<%= entity.CLS16 %>','<%= entity.CNT16 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT16) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT17) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT17 %>','<%= entity.CLS17 %>','<%= entity.CNT17 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT17) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT18) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT18 %>','<%= entity.CLS18 %>','<%= entity.CNT18 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT18) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT19) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT19 %>','<%= entity.CLS19 %>','<%= entity.CNT19 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT19) %></a>
		        	</td>
		        	<%
		        	}
		        	if (Integer.parseInt(total.CNT20) > 0) {
		        	%>
		        	<td class="<%= entity.PBTXT.equals("TOTAL")?"td11":entity.STELL_TEXT.equals("SUM")?"td11_2":"" %>" >
		        		<a href="javascript:goDetail('<%= entity.WERKS %>','<%= entity.JIKGU %>','<%= entity.STELL %>','<%= entity.CTT20 %>','<%= entity.CLS20 %>','<%= entity.CNT20 %>')" title='<%= entity.STELL_TEXT %>'><%= WebUtil.printNumFormat(entity.CNT20) %></a>
		        	</td>
		        	<%
		        	}
		        	%>
        		</tr>
		        <%
			      	temp = entity.PBTXT;
		        	temp1 = entity.JIKGT;
		        	temp2 = entity.STELL_TEXT;
		        	}
		        %>
        	</table>
        </div>
	</div>
<%
    } else {
%>
    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
        </div>
        <div class="table">
            <table class="listTable">
                <tr>
					<th><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org. Unit --></th>
					<th><spring:message code='LABEL.F.F04.0004'/><!-- Job Family --></th>
					<th><spring:message code='LABEL.F.F00.0012'/><!-- Job --></th>
					<th><spring:message code='LABEL.F.F77.0001'/><!-- Direct --></th>
					<th><spring:message code='LABEL.F.F77.0002'/><!-- Long Term Contract --></th>
					<th><spring:message code='LABEL.F.F77.0003'/><!-- Consultant --></th>
					<th><spring:message code='LABEL.F.F77.0004'/><!-- Part time / Short term --></th>
					<th><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
				</tr>
				<tr>
			    	<td class="lastCol" colspan="8"><spring:message code='LABEL.F.FCOMMON.0002'/></td>
				</tr>
			</table>
		</div>
	</div>
<%
    } //end if...
%>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
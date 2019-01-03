<%/******************************************************************************
/*   System Name  : MSS
/*   1Depth Name  : Manaer's Desk
/*   2Depth Name  : 인원현황
/*   Program Name : 부서별 학력조회
/*   Program ID   : F22DeptScholarship.jsp
/*   Description  : 부서별 학력조회 검색을 위한 jsp 파일
/*   Note         : 없음
/*   Creation     :
/*   Update       :[CSR ID:3428660] 인사 list 화면 오류 수정 20170711 eunha
/*       			   :[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%

	// 웹로그 메뉴 코드명
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptScholarship_vt = (Vector)request.getAttribute("DeptScholarship_vt");

    HashMap empCnt1 = (HashMap)request.getAttribute("empCnt1");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F22DeptScholarshipSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>

 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >
<h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
<div class="listArea">
	<div class="listTop">
		<span class="listCnt"><<!-- 총 --><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptScholarship_vt.size()%><spring:message code='LABEL.F.FCOMMON.0007'/><!-- 건 -->></span>
           <div class="buttonArea">
               <ul class="btn_mdl">
                   <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
               </ul>
           </div>
	</div>
<%
	if( user.area == Area.KR ){
%>
	<div class="wideTable" style="border-top: 2px solid #c8294b;">
		<table class="listTable">
		<thead>
			<tr>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha start --%>
				<%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
				<th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha end --%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
				<th><spring:message code="LABEL.F.F22.0001"/><!-- 기간 --></th>
				<th><spring:message code="LABEL.F.F22.0002"/><!-- 학교명--></th>
				<th><spring:message code="LABEL.F.F22.0003"/><!-- 전공 --></th>
				<th><spring:message code="LABEL.F.F22.0004"/><!-- 졸업구분 --></th>
				<th><spring:message code="LABEL.F.F22.0005"/><!-- 소재지 --></th>
				<th class="lastCol"><spring:message code="LABEL.F.F22.0006"/><!-- 입사시 학력 --></th>
			</tr>
		</thead>
			<%
			String oldPer="";
			String sRow = "";


            for( int i = 0; i < DeptScholarship_vt.size(); i++ ){
                F22DeptScholarshipData data = (F22DeptScholarshipData)DeptScholarship_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작
                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(data.PERNR);
                }
                oldPer = data.PERNR;
			%>
			<%--[CSR ID:3428660] 인사 list 화면 오류 수정 start--%>
			<!--<tr class="borderRow"> -->
			<tr class="<%=WebUtil.printOddRow(i)%>">
			<%--[CSR ID:3428660] 인사 list 화면 오류 수정 end--%>
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><a style="cursor: pointer;" onclick="parent.popupView('orgView','1024','700','<%= PERNR %>');"><font color=blue><%= data.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.JIKCT %></td>
				<td nowrap <%= sRow %>><%= data.TRFST %></td>
				<td nowrap <%= sRow %>><%= data.VGLST %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
				<td nowrap><%= data.PERIOD %></td>
				<td nowrap><%= data.SCHTX %></td>
				<td nowrap><%= data.SLTP1X %></td>
				<td nowrap><%= data.SLATX %></td>
				<td nowrap><%= data.SOJAE %></td>
				<td nowrap class="lastCol"><%= data.EMARK %></td>
			</tr>
<%
            } //end for...
%>
		<tags:table-row-nodata list="${DeptScholarship_vt}" col="15" />
		</table>
	</div>
<%
    	}else{
%>
	<div class="wideTable" style="border-top: 2px solid #c8294b;">
		<table class="listTable">
			<thead>
			<tr>
				<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha start --%>
				<%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
				<th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
				<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha end --%>
				<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
				<th><spring:message code="LABEL.F.F22.0001"/><!-- 기간 --></th>
				<th><spring:message code="LABEL.F.F22.0002"/><!-- 학교명--></th>
				<th><spring:message code="LABEL.F.F22.0003"/><!-- 전공 --></th>
				<th><spring:message code="LABEL.F.F22.0004"/><!-- 졸업구분 --></th>
				<th><spring:message code="LABEL.F.F22.0005"/><!-- 소재지 --></th>
				<th class="lastCol"><spring:message code="LABEL.F.F22.0006"/><!-- 입사시 학력 --></th>
			</tr>
			</thead>
			<%

			String oldPer="";
			String sRow = "";


            for( int i = 0; i < DeptScholarship_vt.size(); i++ ){
            	F22DeptScholarshipGlobalData data = (F22DeptScholarshipGlobalData)DeptScholarship_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작
                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt1.get(data.PERNR);
                }
                oldPer = data.PERNR;
			%>
			<%--[CSR ID:3428660] 인사 list 화면 오류 수정 start--%>
			<!--<tr class="borderRow"> -->
			<tr class="<%=WebUtil.printOddRow(i)%>">
			<%--[CSR ID:3428660] 인사 list 화면 오류 수정 end--%>
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><%= data.NAME1 %></td>
				<td nowrap <%= sRow %>><a style="cursor: pointer;" onclick="parent.popupView('orgView','1024','700','<%= PERNR %>');"><font color=blue><%= data.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.VGLST %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
				<td nowrap><%= data.PERIOD %></td>
				<td nowrap><%= data.SCHTX %></td>
				<td nowrap><%= data.SLTP1X %></td>
				<td nowrap><%= data.SLATX %></td>
				<td nowrap><%= data.SOJAE %></td>
				<td nowrap class="lastCol"><%= data.EMARK %></td>
			</tr>
<%
            } //end for...
%>
		<tags:table-row-nodata list="${DeptScholarship_vt}" col="14" />
		</table>
	</div>
<%
    	}
%>
           <div class="buttonArea">
               <ul class="btn_mdl">
                   <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
               </ul>
           </div>
</div>

</form>

<jsp:include page="/include/body-footer.jsp"/>
<jsp:include page="/include/footer.jsp" />

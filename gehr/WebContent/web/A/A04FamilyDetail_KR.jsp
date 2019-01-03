<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 가족사항 조회                                               */
/*   Program ID   : A04FamilyDetail.jsp                                         */
/*   Description  : 가족사항 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-03-02  윤정현                                          */
/*                  2005-05-03  @v1.1가족수당폐지                               */
/*                              @v1.3가족수당삭제                               */
/*                  2008-04-21  lsa @v1.0 [CSR ID:1254077]대리신청시 정보조회안되게수정*/
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정  */
/*                  2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청*/
/*  			     2018-01-05  rdcamel  [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건*/
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="isOwner" value="${PERNR == user.empNo}"/>

<jsp:useBean id="buttonBody" class="com.common.vo.BodyContainer" scope="page" />
<jsp:useBean id="detailBody" class="com.common.vo.BodyContainer" scope="page" />

<tags:body-container bodyContainer="${buttonBody}">
    <tags:script>
        <script language="javascript">
            <!--
            //--------------------------------------------------------------------------------------------
            //종속성(세금)의 부양가족 check = false일경우만 부양가족여부 신청이 가능함.
            //종속성(세금)의 부양가족 check = true 일경우는 부양가족 변경(해지) 신청으로 한다.
            function do_support() {         // 부양가족
//  2002.10.31 부양가족이 체크되지 않은 경우에만 부양가족여부 신청가능
                if (!document.form1.DPTID.checked) {
                    document.form1.jobid.value = "first";
                    document.form1.action = "${g.servlet}hris.A.A12Family.A12SupportBuildSV";
                    document.form1.method = "post";
                    document.form1.submit();
                } else {
                    alert("<spring:message code='MSG.A.A12.0025' />");	//부양가족으로 이미 등재되어 있습니다. 부양가족 변경(해지)신청을 하시기 바랍니다.
                }
            }

			function do_medical() {
				document.form1.jobid.value = "first";
				document.form1.action = "${g.servlet}hris.E.E01Medicare.E01MedicareBuildSV";
				document.form1.method = "post";
				document.form1.submit();
			}


            //-->
        </script>
    </tags:script>
    <li><a href="javascript:;" onclick="do_support();"><span><spring:message code="LABEL.A.A12.0025" /><%--부양가족 여부 신청--%></span></a></li>
	<li><a href="javascript:;" onclick="do_medical();"><span><spring:message code="LABEL.A.A12.0045" /><%--건강보험 신청--%></span></a></li>

</tags:body-container>

<tags:body-container bodyContainer="${detailBody}">
	<div class="tableArea">
		<div class="table">
			<table width="760" border="0" cellspacing="0" cellpadding="3" class="tableGeneral perInfo">
				<colgroup>
					<col width="15%">
					<col width="35%" >
					<col width="15%">
					<col width="35%" >
				</colgroup>
				<tr>
					<th width="100"><spring:message code="LABEL.A.A12.0001" /><%--성명(한글)--%></th>
					<td width="280">
						<input type="text" name="name" size="20" style="border-width:0" readonly>
					</td>
					<th class="th02" width="100"><spring:message code="LABEL.A.A12.0002" /><%--가족유형--%></th>
					<td width="280">
						<input type="text" name="STEXT" size="10" style="border-width:0" readonly>
					</td>
				</tr>
				<tr>
					<th><spring:message code="LABEL.A.A12.0003" /><%--주민등록번호--%></th>
					<td>
						<input type="text" name="REGNO" size="18" style="border-width:0" readonly>
					</td>
					<th class="th02"><spring:message code="LABEL.A.A12.0004" /><%--관계--%></th>  
					<td>
						<input type="text" name="ATEXT" size="20" style="border-width:0" readonly>  <!--  [CSR ID:3569665] --><input type="text" name="KDBSL_TEXT" size="20" style="border-width:0" readonly>
					</td>
				</tr>
				<c:choose>
					<c:when test="${isOwner}">
						<tr>
							<th><spring:message code="LABEL.A.A12.0005" /><%--생년월일--%></th>
							<td>
								<input type="text" name="BDay" size="20" style="border-width:0" readonly>
							</td>
							<th class="th02"><spring:message code="LABEL.A.A12.0006" /><%--성별--%></th>
							<td>
								<input type="radio" id="FASEX_1" name="FASEX" value="1" disabled> <spring:message code="LABEL.A.A12.0019" /><%--남--%>
								<input type="radio" id="FASEX_2" name="FASEX" value="2" disabled> <spring:message code="LABEL.A.A12.0020" /><%--여--%>
							</td>
						</tr>
						<tr>
							<th><spring:message code="LABEL.A.A12.0007" /><%--출생지--%></th>
							<td>
								<input type="text" name="FGBOT" size="20" style="border-width:0" readonly>
							</td>
							<th class="th02"><spring:message code="LABEL.A.A12.0013" /><%--학력--%></th>
							<td>
								<input type="text" name="STEXT1" size="20" style="border-width:0" readonly>
							</td>
						</tr>
						<tr>
							<th><spring:message code="LABEL.A.A12.0008" /><%--출생국--%></th>
							<td>
								<input type="text" name="LANDX" size="20" style="border-width:0" readonly>
							</td>
							<th class="th02"><spring:message code="LABEL.A.A12.0014" /><%--교육기관--%></th>
							<td>
								<input type="text" name="FASIN" size="20" style="border-width:0" readonly>
							</td>
						</tr>
						<tr>
							<th><spring:message code="LABEL.A.A12.0009" /><%--국적--%></th>
							<td>
								<input type="text" name="NATIO" size="20" style="border-width:0" readonly>
							</td>
							<th class="th02"><spring:message code="LABEL.A.A12.0010" /><%--직업--%></th>
							<td>
								<input type="text" name="FAJOB" size="20" style="border-width:0" readonly>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<input type="hidden" name="BDay" value="">
						<input type="hidden" name="STEXT1" value="">
						<input type="hidden" name="FASIN" value="">
						<input type="hidden" name="FAJOB" value="">
						<input type="hidden" name="FASEX" value="">
						<input type="hidden" name="FGBOT" value="">
						<input type="hidden" name="LANDX" value="">
						<input type="hidden" name="NATIO" value="">
					</c:otherwise>
				</c:choose>
			</table>
		</div>
	</div>
	<h2 class="subtitle"><spring:message code="LABEL.A.A12.0040" /><%--종속성--%></h2>
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
				<tr>
					<th width="100"><spring:message code="LABEL.A.A12.0026" /><%--세금--%></th>
					<td width="280">
						<input type="checkbox" name="DPTID" disabled> <spring:message code="LABEL.A.A12.0027" /><%--부양가족--%>
						<input type="checkbox" name="BALID" disabled> <spring:message code="LABEL.A.A12.0028" /><%--수급자--%>
						<input type="checkbox" name="HNDID" disabled> <spring:message code="LABEL.A.A12.0029" /><%--장애인--%>
					</td>
					<th class="th02" width="100"><spring:message code="LABEL.A.A12.0030" /><%--기타--%></th>
					<td width="280">
						<input type="checkbox" name="LIVID" disabled> <spring:message code="LABEL.A.A12.0031" /><%--동거여부--%>
						<input type="checkbox" name="HELID" disabled> <spring:message code="LABEL.A.A12.0032" /><%--건강보험--%>
					</td>
				</tr>
			</table>
		</div>
		<span class="inlineComment"><spring:message code="LABEL.A.A12.0033" /><%--※ 종속성(세금)의 부양가족에 V표시가 되어 있으면 부양가족으로 등재되어있는 것입니다.--%></span>
	</div>
    <!-- HIDDEN으로 처리 -->
    <input type="hidden" id="jobid" name="jobid" value="">
    <input type="hidden" name="RequestPageName" value="${currentURL}">
	<input type="hidden" name="ThisJspName" value="A04FamilyDetail_KR.jsp">
    <input type="hidden" name="SUBTY" >
    <input type="hidden" name="OBJPS" >
    <input type="hidden" name="LNMHG" >
    <input type="hidden" name="FNMHG" >
    <input type="hidden" name="FGBDT" >
    <input type="hidden" name="KDSVH" >
    <input type="hidden" name="REGNO_R" >
    <input type="hidden" name="subView" value="${param.subView}">
    <!-- HIDDEN으로 처리 -->
</tags:body-container>

<tags-family:family-layout detailBody="${detailBody}" buttonBody="${buttonBody}">


<div class="tableArea">

<%-- 사원 검색 부분 --%>
	<c:if test="${user.e_representative == 'Y'}">
		<jsp:include page="/web/common/includeSearchDeptPersons.jsp"/>
	</c:if>

	<div class="table">
	    <table width="780" border="0" cellspacing="0" cellpadding="4" class="listTable">
	        <thead>
	        <tr>
	            <th width="40"><spring:message code="LABEL.A.A12.0034" /><%--선택--%></th>
	            <th width="80"><spring:message code="LABEL.A.A12.0035" /><%--가족유형--%></th>
	            <th width="130"><spring:message code="LABEL.A.A12.0036" /><%--성명--%></th>
	            <th width="150"><spring:message code="LABEL.A.A12.0037" /><%--주민등록번호--%></th>
	            <th width="200"><spring:message code="LABEL.A.A12.0038" /><%--학력/교육기관--%></th>
	            <th class="lastCol" width="180"><spring:message code="LABEL.A.A12.0039" /><%--직업--%></th>
	        </tr>
	        </thead>
	        <tbody>
	            <%--@elvariable id="a04FamilyDetailData_vt" type="java.util.Vector<hris.A.A04FamilyDetailData>"--%>
	        <c:forEach var="row" items="${a04FamilyDetailData_vt}" varStatus="status">
	            <tr class="${status.index % 2 == 0 ? 'oddRow' : ''}">
	                <td>
	                    <input type="radio" name="radiobutton" value="radiobutton" onclick="detail($(this));">
	                    <input type="hidden" name="SUBTY" value="${row.SUBTY}">
	                    <input type="hidden" name="STEXT" value="${row.STEXT}">
	                    <input type="hidden" name="OBJPS" value="${row.OBJPS}">
	                    <input type="hidden" name="name" value="${row.LNMHG} ${row.FNMHG}">
	                    <input type="hidden" name="LNMHG" value="${row.LNMHG}">
	                    <input type="hidden" name="FNMHG" value="${row.FNMHG}">
	                    <input type="hidden" name="REGNO" value="${f:printRegNo(row.REGNO, isOwner ? '' : 'FULL')}">
	                    <input type="hidden" name="REGNO_R" value="${f:printRegNo(row.REGNO, '')}">
	                    <input type="hidden" name="BDay" value="${row.BDay}">
	                    <input type="hidden" name="FGBDT" value="${row.FGBDT}">
	                    <input type="hidden" name="STEXT1" value="${row.STEXT1}">
	                    <input type="hidden" name="FASIN" value="${row.FASIN}">
	                    <input type="hidden" name="FAJOB" value="${row.FAJOB}">
	                    <input type="hidden" name="KDSVH" value="${row.KDSVH}">
	                    <input type="hidden" name="ATEXT" value="${row.ATEXT}">
	                    <input type="hidden" name="FASEX" value="${row.FASEX}">
	                    <input type="hidden" name="FGBOT" value="${row.FGBOT}">
	                    <input type="hidden" name="LANDX" value="${row.LANDX}">
	                    <input type="hidden" name="NATIO" value="${row.NATIO}">
	                    <input type="hidden" name="DPTID" value="${row.DPTID}">
	                    <input type="hidden" name="HNDID" value="${row.HNDID}">
	                    <input type="hidden" name="LIVID" value="${row.LIVID}">
	                    <input type="hidden" name="HELID" value="${row.HELID}">
	                    <input type="hidden" name="FAMID" value="${row.FAMID}">
	                    <input type="hidden" name="CHDID" value="${row.CHDID}">
	                    <%-- <input type="hidden" name="KDBSL" value="${row.KDBSL}"> --%>
	                    <input type="hidden" name="KDBSL_TEXT" value="${row.KDBSL_TEXT}"><!-- [CSR ID:3569665] -->
	                </td>
	                <td>${row.STEXT}</td>
	                <td>${row.LNMHG } ${row.FNMHG}</td>
	                <td>${f:printRegNo(row.REGNO, isOwner ? '' : 'FULL')}</td>
					<c:set var="eduText" value="${row.STEXT1}${not empty row.FASIN ? '/' : ''}${row.FASIN}"/>
	                <td>${isOwner ?  eduText : '***'}</td>
	                <td class="lastCol">${isOwner ? row.FAJOB : '***'} </td>
	            </tr>
	        </c:forEach>
	            <tags:table-row-nodata list="${a04FamilyDetailData_vt}" col="6" />
	        </tbody>
	    </table>
    </div>
</div>

</tags-family:family-layout>




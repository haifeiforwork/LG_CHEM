<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 식권/영업사원 식대 결재 완료                                */
/*   Program ID   : G045ApprovalFinishMealCharge.jsp                            */
/*   Description  : 식권/영업사원 식대 결재 완료                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-28 이승희                                           */
/*   Update       : 2003-03-28 이승희                                           */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.G.MealChargeData" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

    MealChargeData mealChargeData = (MealChargeData)request.getAttribute("mealChargeData");

    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(mealChargeData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
%>
<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
    function cancel()
    {
        if(!confirm("취소 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPR_STAT.value = "";
        frm.submit();
    }

    function goToList()
    {
        var frm = document.form1;
        frm.jobid.value ="";
    <% if (RequestPageName != null ) { %>
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
    <% } // end if %>

        frm.submit();
    }
//-->
</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');">
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="PERNR"     value="<%=mealChargeData.PERNR%>">
<input type="hidden" name="BEGDA"     value="<%=mealChargeData.BEGDA%>">
<input type="hidden" name="AINF_SEQN" value="<%=mealChargeData.AINF_SEQN%>">

<input type="hidden" name="APPR_STAT">
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<input type="hidden" name="approvalStep" value="<%=approvalStep%>">

<div class="subWrapper">
	<div class="title">
		<h1><spring:message code="LABEL.G.G45.0001"/><!-- 식권/영업 사원식대 --></h1>
	</div>

	<div class="listArea">
		<div class="buttonArea">
			<ul class="btn_crud">
				<% if (isCanGoList) {  %>
					<li><a class="darken loading" href="javascript:goToList()"><span><spring:message code="BUTTON.COMMON.LIST" /><%--목록--%></span></a></li>
				<% } // end if %>
			</ul>
		</div>

<div class="tableArea">
	<div class="table">
	  <table class="tableGeneral">
        <colgroup>
            <col width="15%">
            <col width="35%">
            <col width="15%">
            <col width="35%">
        </colgroup>
            <tr>
                <th><spring:message code="MSG.APPROVAL.0007" /><%--작성자--%></th>
                <td colspan="3">
                <%-- ${approvalHeader.ORGTX} ${approvalHeader.ENAME} ${approvalHeader.JIKWT} (${approvalHeader.PHONE_NUM}) (${approvalHeader.PERNR}) --%>
                <%-- [CSR ID:3456352] --%>
                <c:choose>
	                <c:when test="${approvalHeader.BUKRS=='C100' && approvalHeader.JIKWE=='EBA' && approvalHeader.JIKKT!=''}">
		            	${approvalHeader.ORGTX} ${approvalHeader.ENAME} ${approvalHeader.JIKKT} (${approvalHeader.PHONE_NUM}) (${approvalHeader.PERNR})
	                </c:when>
	                <c:otherwise>
	               		${approvalHeader.ORGTX} ${approvalHeader.ENAME} ${approvalHeader.JIKWT} (${approvalHeader.PHONE_NUM}) (${approvalHeader.PERNR})
	                </c:otherwise>
                </c:choose>
                <%-- [CSR ID:3456352] --%>
                </td>

            </tr>
            <tr>
                <th><spring:message code="MSG.APPROVAL.0008" /><%--작성일--%></th>
                <td>
                   <%=WebUtil.printDate(mealChargeData.BEGDA)%>
                </td>
                <th class="th02"><spring:message code="MSG.APPROVAL.0009" /><%--보존년한--%></th>
                <td>
                    <spring:message code="MSG.APPROVAL.0010" /><%--영구--%>
                </td>
            </tr>
     </table>
	</div>
</div>
        <!--  신청자 기본 정보 끝-->
		<div class="listTop">
			<h2 class="subtitle"><spring:message code="LABEL.G.G45.0002"/><!-- 신청정보 --></h2>
			<div class="clear"></div>
		</div>
		<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
				<colgroup>
				<col width=15%>
				<col width=35%>
				<col width=15%>
				<col width=35%>
				</colgroup>
				<tr>
					<th><spring:message code="LABEL.D.D15.0154"/><!-- 신청일 --></th>
					<td><%=WebUtil.printDate(mealChargeData.BEGDA)%></td>
					<th class="th02"><spring:message code="LABEL.G.G45.0003"/><!-- 신청년월 --></th>
					<td><%=mealChargeData.APLY_MNTH%></td>
				</tr>
				<tr>
					<th><spring:message code="LABEL.D.D12.0005"/><!-- 부서명 --></th>
					<td><%=mealChargeData.STEXT%></td>
					<th class="th02"><spring:message code="LABEL.D.D19.0003"/><!-- 신청구분 --></th>
					<td><%if (mealChargeData.APLY_FLAG.equals("X") ){%><spring:message code="LABEL.G.G45.0004"/><!-- 정기 --><%}else{%><spring:message code="LABEL.G.G45.0005"/><!-- 수시 --><%}%></td>
				</tr>
				<tr>
					<th><spring:message code="LABEL.G.G45.0006"/><!-- 현물지급일수 --></th>
					<td><%=mealChargeData.TKCT_CONT%><spring:message code="LABEL.G.G45.0010"/><!-- 일 --> &nbsp; <%=WebUtil.printNumFormat(mealChargeData.TKCT_WONX)%><spring:message code="LABEL.D.D15.0010"/><!-- 원 --></td>
					<th class="th02"><spring:message code="LABEL.G.G45.0007"/><!-- 현금보상일수 --></th>
					<td><%=mealChargeData.CASH_CONT%><spring:message code="LABEL.G.G45.0010"/><!-- 일 --> &nbsp; <%=WebUtil.printNumFormat(mealChargeData.CASH_WONX)%><spring:message code="LABEL.D.D15.0010"/><!-- 원 --></td>
				</tr>
				<tr>
					<th><spring:message code="LABEL.G.G45.0008"/><!-- 은행 --></th>
					<td colspan="3"><%=mealChargeData.BANKTXT%></td>
				</tr>
				<tr>
					<th><spring:message code="LABEL.D.D11.0203"/><!-- 계좌번호 --></th>
					<td colspan="3"><%=mealChargeData.BANKN%></td>
				</tr>
				<tr>
					<th><spring:message code="LABEL.E.E18.0063"/><!-- 전표번호 --></th>
					<td colspan="3"><%=mealChargeData.BELNR%></td>
				</tr>
			</table>
        </div>
        </div>
        <div class="listTop">
            <h2 class="subtitle"><spring:message code="MSG.APPROVAL.0011" /><!-- 승인자정보 --></h2>
            <div class="clear"></div>
        </div>
    <div class="listArea">
        <div class="table">
            <table class="listTable">
        	<colgroup>
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="" />
                <col width="10%" />
                <col width="10%" />
                <col width="" />
        	</colgroup>
        	<thead>
        	<tr>
        		<th><spring:message code="MSG.APPROVAL.0012"/><!-- 구분 --></th>
        		<th><spring:message code="MSG.APPROVAL.0013"/><!-- 이름 --></th>
        		<%-- <th><spring:message code="MSG.APPROVAL.0014"/><!-- 직위 --></th> --%>
        		<th>
        			<spring:message code="MSG.APPROVAL.0024"/><!-- 직책/직급호칭 -->
        		</th>
        		<th><spring:message code="MSG.APPROVAL.0015"/><!-- 부서 --></th>
        		<th><spring:message code="MSG.APPROVAL.0016"/><!-- 승인일 --></th>
        		<th><spring:message code="MSG.APPROVAL.0017"/><!-- 상태 --></th>
        		<th class="lastCol"><spring:message code="MSG.APPROVAL.0018" /><%--결재의견--%></th>
        	</tr>
        	</thead>
        	<%-- --%>
			<c:forEach var="row" items="${vcAppLineData}" varStatus="status">
        	<tr class="${f:printOddRow(status.index)}" title="${row.APPL_ENAME } ☎ ${row.APPL_TELNUMBER}">
            	<td>${row.APPL_APPU_NAME}</td>
            	<td>${row.APPL_ENAME} <span  class="textPink">${row.APPL_TELNUMBER gt '' ?'☎':'' }</span></td>
            	<td>
            	<%--//[CSR ID:3456352] ${row.APPL_TITEL } --%>
            	<c:choose>
            		<c:when test="${row.APPL_TITEL =='책임' && row.APPL_TITL2!=''}">
            			${row.APPL_TITL2 }
            		</c:when>
            		<c:otherwise>${row.APPL_TITEL }</c:otherwise>
            	</c:choose>
            	<%--//[CSR ID:3456352] --%>
            	</td>
            	<td>${row.APPL_ORGTX}</td>
            	<td>${f:printDate(row.APPL_APPR_DATE)}</td>
            	<td><c:choose><c:when test="${row.APPL_APPR_STAT eq 'A'}">승인</c:when><c:when test="${row.APPL_APPR_STAT eq 'R'}">반려</c:when><c:otherwise>미결</c:otherwise></c:choose></td>
            	<%-- <td><% if (ald.APPL_APPR_STAT.equals("A")){%><spring:message code="BUTTON.COMMON.APPROVAL"/><!-- 승인 --><%}else if(ald.APPL_APPR_STAT.equals("R")){ %><spring:message code="BUTTON.COMMON.REJECT"/><!-- 반려 --><%}else{ %><spring:message code="COMMON.APPROVAL.LIST.FINISH.NONE"/><!-- 미결 --><%} %></td> --%>
            	<td class="lastCol align_left">${row.APPL_BIGO_TEXT}
            	<input type="hidden" name="APPL_APPR_SEQN${status.index}"  value="${row.APPL_APPR_SEQN}"/>
				<input type="hidden" name="APPL_APPU_TYPE${status.index}"  value="${row.APPL_APPU_TYPE}"/>
				<input type="hidden" name="APPL_APPU_NUMB${status.index}" value="${row.APPL_PERNR}"/>    </td>
<%--                           <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(vcAppLineData) %>
                          <!--결재정보 테이블 끝--> --%>
             </tr>
			</c:forEach>
			<tags:table-row-nodata list="${vcAppLineData}" col="7" />
		</table>
		 <input type="hidden" name="RowCount" value=<%=vcAppLineData.size()%>/>
		</div>
		</div>
     	<div class="buttonArea">
     		<ul class="btn_crud">
             <% if (isCanGoList) {  %>
     			<li><a class="darken loading" href="javascript:goToList()"><span><spring:message code="BUTTON.COMMON.LIST" /><%--목록--%></span></a></li>
             <% } // end if %>
     		</ul>
     	</div>
	</div>
</div>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->


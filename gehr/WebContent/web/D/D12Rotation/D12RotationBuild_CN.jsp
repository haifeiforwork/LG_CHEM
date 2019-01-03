<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : 부서근태
*   2Depth Name  : 부서근태입력
*   Program Name : 초과근무등록
*   Program ID   : D12RotationBuild|D12RotationBuild.jsp
*   Description  : 초과근무등록 화면
*   Note         :
*   Creation     :
*   Update       :
********************************************************************************/%>
<%@ page import="com.common.constant.Area" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags-rotation" tagdir="/WEB-INF/tags/D/D12" %>
<%@ taglib prefix="language" tagdir="/WEB-INF/tags/C/C05" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<% String PERNR = (String)request.getAttribute("PERNR"); %>

    <%-- 결과 리스트  --%>
<%-- <tags-rotation:rotation-build-layout 
	              templateURL="${g.jsp}template/rotation_template_${g.locale}.xls"
	              uploadURL="${g.servlet}hris.D.D12Rotation.D12RotationCnFileUploadSV">
 </tags-rotation:rotation-build-layout> --%>

<c:set var="templateURL" value="${g.jsp}template/rotation_template_${g.locale}.xls"/>
<c:set var="uploadURL" value="${g.servlet}hris.D.D12Rotation.D12RotationCnFileUploadSV"/>

<%-- <%@ attribute name="uploadURL" type="java.lang.String" required="true" %> --%>
<%-- <%@ attribute name="templateURL" type="java.lang.String" required="true" %> --%>


<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>

<tags:layout css="ui_library_approval.css" script="dialog.js">
	<style>
        .result-msg {color: red;}
    </style>

    <script>
    function afterUploadProcess(data, successSize, msg) {
        if(data.resultList) {
            var isError = false;

            $("#-excel-result-tbody").empty();

            _.each(data.resultList, function(row) {
                if(!_.isEmpty(row.ZMSG)) {
                    $("<tr class='borderRow'/>")
                            .append($("<td/>").text(row.ZLINE))
                            .append($("<td/>").text(row.PERNR))    //사원번호
                            .append($("<td/>").text(row.ENAME))    //이름
                            .append($("<td/>").text(row.CBEGDA))    //일자
                            .append($("<td/>").text(row.VTKEN))    //전일지시자
                            .append($("<td/>").text(row.BEGUZ))    //시작시간
                            .append($("<td/>").text(row.ENDUZ))    //종료시간
                            .append($("<td/>").text(row.PBEG1))    //휴식시간1
                            .append($("<td/>").text(row.PEND1))    //휴식종료1
                            .append($("<td/>").text(row.PBEG2))    //휴식시간2
                            .append($("<td/>").text(row.PEND2))    //휴식종료2
                            .append($("<td/>").text(row.REASON))    //사유
                            .append($("<td/>").text(row.OTTIM))    //초과근무(hr)
                            .append($("<td/>").text(row.RTEXT))    //근무일정규칙
                            .append($("<td/>").text(row.TTEXT))    //일일근무일정
                            .append($("<td/>").text(row.SOBEG))    //시작시간       SOBEG
                            .append($("<td/>").text(row.SOEND))    //종료시간
                            .append($("<td/>").text(row.SOLLZ))    //근무시간
                            .append($("<td class='lastCol'/>").text(row.ZMSG).addClass("result-msg"))    //비고
                            .appendTo("#-excel-result-tbody");
                    isError = true;
                }
            });
            $("#-excel-result-cnt").empty();
            $("#-excel-result-cnt").html(successSize);
            var height = document.body.scrollHeight;
            parent.resizeIframe(height);
        }
        alert(msg);
    }

    function openExcelUpload() {
        window.open('${uploadURL}?YYYYMM=' + $("#applyYear").val() +  $("#applyMonth").val(),
        		"ScheduleExcelUpload","width=440,height=300,left=365,top=70,scrollbars=no");
//         strURL = '${uploadURL}?YYYYMM=' + $("#applyYear").val() +  $("#applyMonth").val();
//         strPos = "dialogWidth:440px;dialogHeight:300px;status:no;scroll:yes;resizable:no";// "dialogWidth:380px;dialogHeight:330px;status:no;scroll:yes;resizable:no";
//         var resultObj = window.showModalDialog(strURL, "", strPos); 
    }

    </script>
    <c:set var="buttonBody" value="${g.bodyContainer}" />
    <tags:body-container bodyContainer="${buttonBody}">
        <li><a href="${templateURL}" ><span>Excel Template</span></a></li>

        <li >
            <%--<input type="file" class="file-input" name="uploadFile" id="uploadFile">--%>
            <a onclick="openExcelUpload();" ><span><spring:message code="LABEL.D.D13.0020"/><!-- 엑셀 업로드 --></span></a>
        </li>
    </tags:body-container>

<%--  신청 button --%>
<tags-approval:button-layout buttonType="R" button="${buttonBody}" disable="true"/>

<!--리스트 테이블 시작-->
<div class="listArea">
	<div class="listTop_inner">
		<span class="listCnt" id="-excel-result-cnt"><spring:message code='COMMON.PAGE.TOTAL' arguments='0' /><!--총 건--></span>
	</div>
    <div class="table">
        <table id="-schedule-change-table" class="listTable tablesorter" >
  <colgroup>
                <col width="2%"/> <!-- 사원번호-->
                <col width="4%"/> <!-- 사원번호-->
                <col width="6%;"/><!-- 이름-->
                <col width="6%;"/><!-- 일자-->
                <col width="3%;"/><!-- 전일지시자-->
                <col width="4%;"/><!-- 시작시간-->
                <col width="4%;"/><!-- 종료시간-->
                <col width="4%;"/><!-- 휴식시간1-->
                <col width="4%;"/><!-- 휴식종료1-->
                <col width="5%;"/><!-- 휴식시간2-->
                <col width="5%;"/><!-- 휴식종료2-->
                <col width="15%;"/><!-- 사유-->
                <col width="5%;"/><!-- 초과근무(hr)-->
                <col width="6%;"/><!-- 근무일정규칙-->
                <col width="6%;"/><!-- 일일근무일정-->
                <col width="4%;"/><!-- 시작시간-->
                <col width="4%;"/><!-- 종료시간-->
                <col width="4%;"/><!-- 근무시간-->
                <col width="14%;"/><!-- 비고-->
                </colgroup>
            <thead>
            <tr>
	                <th><spring:message code="LABEL.D.D12.0084"/><!-- 라인--></th>
	                <th><spring:message code="LABEL.D.D12.0017"/> <!-- 사원번호--></th>
	                <th><spring:message code="LABEL.D.D12.0018"/> <!-- 이름--></th>
	                <th><spring:message code="LABEL.D.D15.0206"/> <!-- 일자--></th>
	                <th><spring:message code="LABEL.D.D12.0067"/> <!-- 전일지시자--></th>
	                <th><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
	                <th><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
	                <th><spring:message code="LABEL.D.D12.0068"/> <!-- 휴식시간1--></th>
	                <th><spring:message code="LABEL.D.D12.0069"/> <!-- 휴식종료1--></th>
	                <th><spring:message code="LABEL.D.D12.0070"/> <!-- 휴식시간2--></th>
	                <th><spring:message code="LABEL.D.D12.0071"/> <!-- 휴식종료2--></th>
	                <th><spring:message code="LABEL.D.D12.0072"/> <!-- 사유--></th>
	                <th><spring:message code="LABEL.D.D12.0073"/> <!-- 초과근무(hr)--></th>
	                <th><spring:message code="LABEL.D.D12.0074"/> <!-- 근무일정규칙--></th>
	                <th><spring:message code="LABEL.D.D12.0075"/> <!-- 일일근무일정--></th>
	                <th><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
	                <th><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
	                <th><spring:message code="LABEL.D.D12.0076"/> <!-- 근무시간--></th>
	                <th class="lastCol"><spring:message code="LABEL.COMMON.0015"/> <!-- 비고--></th>
            </tr>
            </thead>
            <tbody id="-excel-result-tbody">

           <%--  <tags:table-row-nodata list="${resultList}" col="19" /> --%>
            </tbody>
        </table>
        <span class="textPink">*</span><spring:message code="MSG.D.D13.0003"/><!--업로드시 바로 저장처리되며, 에러발생된 내역만 표시 됩니다.  -->
    </div>
</div>
</tags:layout>
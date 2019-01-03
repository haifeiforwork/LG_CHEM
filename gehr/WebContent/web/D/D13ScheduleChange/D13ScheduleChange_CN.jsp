<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 일일근무일정변경	등록												*/
/*   Program ID   : D13SceduleChange|D13SceduleChangeBuild_CN.jsp						*/
/*   Description  : 일일근무일정변경 화면												*/
/*   Note         : 															*/
/*   Creation     : 2016-10-20 GEHR 남경일근태엑셀등록	(김승철-C03참조함)											*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>
<%@ page import="com.common.constant.Area" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-emp-pay" tagdir="/WEB-INF/tags/D/D15" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="tags-schedule" tagdir="/WEB-INF/tags/D/D13" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
WebUserData user =  WebUtil.getSessionUser(request);
String PERNR = (String)request.getAttribute("PERNR");

%>
<c:set var="user" value="<%=user %>" />
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="uploadFileName" value="<%=request.getAttribute("uploadFileName") %>"/>

<%--@elvariable id="g" type="com.common.Global"--%>
<%-- <tags:layout css="ui_library_approval.css" script="jquery.tablesorter.min.js" > --%>
<tags:layout css="blue/style.css" script="jquery.tablesorter.min.js" >

	<style>
		.result-msg {color: red;}
	</style>

	<script>
		var lastIndex = ${fn:length(resultList)};
	</script>

	<tags:script>
		<script>

			function afterUploadProcess(data, failSize, msg) {
				console.log("---- add row -- start=---- ");
				console.log(data.resultList);
				if(data.resultList) {
					var isError = false;

//              if(data.resultList.length > 0 && $(".-search-person").length == 1 &&  _.isEmpty($(".-search-person:first").val())) {
					if(data.resultList.length > 0) {
						$("#-listTable-body").empty();
					}

					$("#-excel-result-tbody").empty();

					_.each(data.resultList, function(row) {
						addRow(row);
						
						
						var vart_value = ("${row.VTART}"=='01')? "<spring:message code='LABEL.D.D13.0028' />":"<spring:message code='LABEL.D.D13.0029' />";
						
						if(!_.isEmpty(row.ZBIGO)) {
							row.BEGDA = addPointAtDate(removePoint(row.BEGDA));
							row.ENDDA = addPointAtDate(removePoint(row.ENDDA));
						
							$("<tr/>")
									.append($("<td/>").text(row.ZLINE))
									.append($("<td/>").text(row.PERNR))
									.append($("<td/>").text(row.ENAME))
									.append($("<td/>").text(row.BEGDA).css("text-align", "center"))
									.append($("<td/>").text(row.ENDDA).css("text-align", "center"))
									.append($("<td/>").text(vart_value))
									.append($("<td/>").text(row.RTEXT))
									.append($("<td/>").text(row.TPROG))
									.append($("<td/>").text(row.TTEXT))
									.append($("<td/>").text(row.SOBEG))
									.append($("<td/>").text(row.SOEND))
									.append($("<td/>").text(row.SOLLZ))
									.append($("<td/>").text(row.ZBIGO).addClass("result-msg"))
									.appendTo("#-excel-result-tbody");

							isError = true;
						}
					});

		            $("#-excel-result-cnt").empty();
		            $("#-excel-result-cnt").html("<spring:message code='COMMON.PAGE.TOTAL' arguments='"+failSize+"' />");
					var height = document.body.scrollHeight;
					parent.resizeIframe(height);

				}
				alert(msg);
			}

			function openExcelUpload() {
				small_window = window.open('${g.servlet}hris.D.D13ScheduleChange.D13ScheduleFileUploadSV?',
						"ScheduleExcelUpload","width=440,height=300,left=365,top=70,scrollbars=no");
				small_window.focus();
			}

			function validcheck(filename) {

				if(filename.indexOf(".xlsx") > -1 || filename.indexOf(".xls") == -1){
					alert("<spring:message code='MSG.COMMON.UPLOAD.EXTFAIL' />");// 지원하지 않습니다.
					$("#uploadFile").val("");
					return false;
				}
				return true;

			}

			function upload() {
				var filename = $("#uploadFile").val();
				if (filename=="") {
					alert("<spring:message code='MSG.COMMON.UPLOAD.EMPTYNAME' />");// 파일명을 먼저 선택하십시오");
					return false;
				}
				uploadExec(filename);
			}
			function uploadExec(filename) {

				if(validcheck(filename) ==false ) return;

				if(confirm('<spring:message code="MSG.D.D15.0101" />')) {//엑셀 업로드시 기존 등록된 데이타는 삭제됩니다. 계속하시겠습니까?"
// 	                blockFrame();
					document.form2.submit();
				}
			}

	        /**
	         * 해당 로우에 데이타 셋팅
	         */
	        function setRow($row, obj, isSelectPayType) {
	            if(obj) {
	                /* input box set */
	                $row.find("input").each(function() {
	                    var $this = $(this);

	                    $this.formatVal(obj[$this.prop("name").replace("LIST_", "")]);
	                });
	            }
	        }

	        /**
	         * 로우추가
	         */
	        function addRow(obj) {
	            console.log("--- addROw -- ");
	            var $row;


	            if(!$row) {
	                var templateText = $("#template").text();
	                templateText = templateText.replace(/#idx#/g, ++lastIndex);
	                $row = $(templateText);
	            }

	            setRow($row, obj, true);

	            addMaskFilter($row);

	            $("#-listTable-body").append($row);

	        }

$(function(){

    //$("#-schedule-change-table").tablesorter();
    });


		</script>
	</tags:script>


	<!--리스트 테이블 시작-->
	<div class="listArea">

			<%--<h3><spring:message code="MSG.COMMON.UPLOAD.RESULT" /> ${uploadFileName}업로드결과 </h3>--%>

		<div class="listTop">
			<div class="listTop_inner">
				<span id="-excel-result-cnt" class="listCnt"><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(resultList)}' /><!--총 건--></span>
			</div>
			
				
			<c:set var="buttonBody" value="${g.bodyContainer}" />
		
			<tags:body-container bodyContainer="${buttonBody}">
			
				<li><a href="${g.jsp}template/schedule_template_${g.locale}.xls" ><span><spring:message code="LABEL.D.D13.0019"/><!--Excel Template--></span></a></li>
				<li >
						<%--<input type="file" class="file-input" name="uploadFile" id="uploadFile">--%>
					<a onclick="openExcelUpload();" ><span><spring:message code="LABEL.D.D13.0020"/><!-- 엑셀 업로드 --></span></a>
						<%--             <a class="darken" onclick="upload();" ><span><spring:message code="LABEL.D.D13.0020"/><!-- 엑셀 업로드 --></span></a> --%>
				</li>
				
			</tags:body-container>
		
			<%--  신청 button --%>
			<tags-approval:button-layout buttonType="R" button="${buttonBody}" disable="true"/>

		
		</div>
		
		<div class="table">
			<table id="-schedule-change-table" class="listTable tablesorter">
				<colgroup>
					<col width="3%"/>
					<col width="5%;"/>
					<col width="5%;"/>
					<col width="5%;"/>
					<col width="5%;"/>
					<col width="7%;"/>
					<col width="6%;"/>
					<col width="5%;"/><!-- 근무일정규칙-->
					<col width="8%;"/>
					<col width="5%;"/>
					<col width="5%;"/>
					<col width="4%;"/>
					<col width="10%;"/>
				</colgroup>
				<thead>
				<tr>
					<th><spring:message code="LABEL.D.D13.0018"/></th><!-- 라인 -->
					<th><spring:message code="LABEL.D.D12.0017"/> <!-- 사원번호--></th>
					<th><spring:message code="LABEL.D.D12.0018"/> <!-- 이름--></th>
					<th><spring:message code="LABEL.D.D15.0152"/> <!-- 시작일--></th>
					<th><spring:message code="LABEL.D.D15.0153"/> <!-- 종료일--></th>
					<th><spring:message code="LABEL.D.D13.0014"/> <!-- 대체유형--></th>
					<th><spring:message code="LABEL.D.D13.0015"/> <!-- 일일근무일정--></th>
					<th><spring:message code="LABEL.D.D14.0001"/> <!-- 근무일정규칙--></th>
					<th><spring:message code="LABEL.D.D13.0016"/> <!-- 근무일정명--></th>
					<th><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
					<th><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
					<th><spring:message code="LABEL.D.D13.0017"/> <!-- 근무시간--></th>
					<th class="lastCol"><spring:message code="LABEL.COMMON.0015"/> <!-- 비고--></th>
				</tr>
				</thead>
				<tbody id="-excel-result-tbody">
				<c:forEach var="row" items="${resultList}" varStatus="status">
					<c:if test='${row.ZBIGO !="" }'>
						<tr class="${f:printOddRow(status.index)}">
							<td>${status.index}</td>
							<td style="text-align:left">${row.PERNR}</td><!-- 사원번호-->
							<td>${row.ENAME}</td><!-- 이름-->
							<td style="text-align:left">${row.BEGDA}</td><!-- 시작일-->
							<td>${row.ENDDA}</td><!-- 종료일-->
							<td>${row.VTART}</td><!-- 대체유형-->
							<td>${row.RTEXT}</td> <!-- Text for Work Schedule Rule (Planned Working Time Infotype)-->
							<td>${row.TPROG}</td> <!-- 일일근무일정-->
							<td>${row.TTEXT}</td><!-- 근무일정명-->
							<td>${row.SOBEG}</td><!-- 시작시간-->
							<td>${row.SOEND}</td><!-- 종료시간-->
							<td>${row.SOLLZ}</td><!-- 근무시간-->
							<td class="lastCol" style="overflow:hidden;"><input type="text" value="${row.ZBIGO}"/></td><!-- -Deletion Indicator -->
						</tr>
					</c:if>
				</c:forEach>

				</tbody>

					<%--             <tags:table-row-nodata list="${resultList}" col="15" /> --%>
			</table>
			<span class="textPink">*</span><spring:message code="MSG.D.D13.0003"/><!--업로드시 바로 저장처리되며, 에러발생된 내역만 표시 됩니다.  -->
		</div>
	</div>
	<!-- 리스트 테이블 끝-->




</tags:layout>

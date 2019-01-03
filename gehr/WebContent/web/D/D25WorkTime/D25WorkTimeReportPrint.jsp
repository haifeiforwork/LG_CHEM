<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실 근무시간 레포트
/*   Program ID   : D25WorkTimeReportPrint.jsp
/*   Description  : 실 근무시간 레포트 출력 화면
/*   Note         : 
/*   Creation     : 2018-05-25 성환희 [WorkTime52]
/*   Update       : 
/******************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/include/header.jsp" />

<style type="text/css">
P.breakhere {
	page-break-before: always
}
</style>

<SCRIPT type="text/javascript">

<!--
function prevDetail() {
	switch (location.hash)  {
		case "#page2":
			location.hash ="#page1";
		break;
	} // end switch
}

function nextDetail() {
	switch (location.hash)  {
		case "":
		case "#page1":
			location.hash ="#page2";
		break;
	} // end switch
}

function click() {
    if (event.button==2) {
      //alert('마우스 오른쪽 버튼은 사용할수 없습니다.');
      //alert('오른쪽 버튼은 사용할수 없습니다.');
      alert('<%=g.getMessage("MSG.F.F41.0006")%>');

   return false;
    }
  }

 function keypressed() {
      //alert('키를 사용할 수 없습니다.');
       return false;
  }

  document.onmousedown=click;
  document.onkeydown=keypressed;

//-->
</SCRIPT>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	
	<form name="form1" method="post" onsubmit="return false">
		<div class="winPop">
			<div class="header">
				<span>
					<spring:message code='TAB.COMMON.0124' /><!-- 실 근무시간 레포트 -->
				</span> 
				<a href="" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
			</div>
		</div>
		<div class="subWrapper iframeWrap wideTable" style="height:550px; overflow:auto">
			<div class="body" class="iframeWrap">
			
				<c:if test="${isPop eq 'Y'}">
				<div>
					<h2 class="subtitle">${E_NAME}(${PERNR})</h2>
				</div>
				</c:if>
				
				<c:if test="${SEARCH_GUBUN eq 'W'}">
				<h2 class="subtitle"><spring:message code='LABEL.D.D25.0007' /><!-- 1.주당 실 근무시간 현황 --></h2>
				<div class="listArea">
			        <div class="table">
			            <table class="listTable">
				            <thead>
				            	<tr>
				            	<c:if test="${not empty T_HEADER}">
				            		<th class="th02"><spring:message code='LABEL.D.D25.0018' /><!-- 구분 --></th>
				            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
				            			<th class="th02 <c:if test="${fn:length(T_HEADER) eq status.count}">lastCol</c:if>">
				            			<c:choose>
				            				<c:when test="${EMPGUB eq 'H'}">
				            					${head.GUBUN}(${fn:replace(fn:substring(head.BEGDA, 5, 10), '-', '.')}~${fn:replace(fn:substring(head.ENDDA, 5, 10), '-', '.')})
				            				</c:when>
				            				<c:otherwise>
				            					${head.GUBUN}
				            				</c:otherwise>
				            			</c:choose>
	            						</th>
				            		</c:forEach>
				            	</c:if>
				            	</tr>
				            </thead>
				            <tbody>
				            	<tr>
				            	<c:if test="${not empty T_HEADER}">
				            		<th style="width:100px;" class="th02"><spring:message code='LABEL.D.D25.0022' /><!-- 실 근무시간 --></th>
				            		<fmt:parseNumber var="limitNumber" value="64" />
				            		<c:forEach var="head" items="${T_HEADER}" varStatus="status">
				            			<fmt:parseNumber var="convertRWKTM" value="${head.RWKTM}" />
				            			<c:choose>
				            				<c:when test="${EMPGUB eq 'H' && convertRWKTM ge limitNumber}"><c:set var="tdClass" value="td11" /></c:when>
				            				<c:otherwise><c:set var="tdClass" value="" /></c:otherwise>
				            			</c:choose>
				            			<td class="${tdClass} <c:if test="${fn:length(T_HEADER) eq status.count}">lastCol</c:if>" style="width:70px;">${head.RWKTM}</td>
				            		</c:forEach>
				            	</c:if>
				            	</tr>
				            </tbody>
			            </table>
					</div>
				</div>
				</c:if>
				
				<c:if test="${SEARCH_GUBUN eq 'M'}">
				<h2 class="subtitle"><spring:message code='LABEL.D.D25.0011' /><!-- 1.주당 평균 실 근무시간 현황 --></h2>
				<c:choose>
					<c:when test="${EMPGUB eq 'S'}">
					<div class="listArea" style="margin-bottom:0px;">
				        <div class="table">
				            <table class="listTable">
					            <thead>
					            	<tr>
					            		<th class="th02"><spring:message code='LABEL.D.D25.0018' /><!-- 구분 --></th>
					            		<th class="th02"><spring:message code='LABEL.D.D25.0020' /><!-- 월 합계 실 근무시간 --></th>
					            		<th class="th02 lastCol"><spring:message code='LABEL.D.D25.0021' /><!-- 주당 평균 실 근무시간 --></th>
					            	</tr>
					            </thead>
					            <tbody>
					            	<c:if test="${not empty ES_HEADER}">
					            	<tr>
					            		<th class="th02"><spring:message code='LABEL.D.D25.0022' /><!-- 실 근무시간 --></th>
					            		<td class="th02">${ES_HEADER.MONSUM}</td>
					            		<td class="th02 lastCol">${ES_HEADER.WEKAVR}</td>
					            	</tr>
					            	</c:if>
					            </tbody>
				            </table>
						</div>
					</div>
					</c:when>
					<c:otherwise>
						<c:set var="displayYear" value="${fn:substring(T_HEADER[0].YYYYMM, 0, 4)}" />
						<c:set var="displayMonth" value="${fn:substring(T_HEADER[0].YYYYMM, 4, 6)}" />
						<c:choose>
							<c:when test="${displayMonth eq '01' || displayMonth eq '02' || displayMonth eq '03'}">
								<c:set var="headerMonth1" value="LABEL.D.D04.0022" /><!-- 1월 -->
								<c:set var="headerMonth1Range" value="(${displayYear - 1}.12.21~${displayYear}.01.20)" />
								<c:set var="headerMonth2" value="LABEL.D.D04.0023" /><!-- 2월 -->
								<c:set var="headerMonth2Range" value="(${displayYear}.01.21~${displayYear}.02.20)" />
								<c:set var="headerMonth3" value="LABEL.D.D04.0024" /><!-- 3월 -->
								<c:set var="headerMonth3Range" value="(${displayYear}.02.21~${displayYear}.03.20)" />
							</c:when>
							<c:when test="${displayMonth eq '04' || displayMonth eq '05' || displayMonth eq '06'}">
								<c:set var="headerMonth1" value="LABEL.D.D04.0025" /><!-- 4월 -->
								<c:set var="headerMonth1Range" value="(${displayYear}.03.21~${displayYear}.04.20)" />
								<c:set var="headerMonth2" value="LABEL.D.D04.0026" /><!-- 5월 -->
								<c:set var="headerMonth2Range" value="(${displayYear}.04.21~${displayYear}.05.20)" />
								<c:set var="headerMonth3" value="LABEL.D.D04.0027" /><!-- 6월 -->
								<c:set var="headerMonth3Range" value="(${displayYear}.05.21~${displayYear}.06.20)" />
							</c:when>
							<c:when test="${displayMonth eq '07' || displayMonth eq '08' || displayMonth eq '09'}">
								<c:set var="headerMonth1" value="LABEL.D.D04.0028" /><!-- 7월 -->
								<c:set var="headerMonth1Range" value="(${displayYear}.06.21~${displayYear}.07.20)" />
								<c:set var="headerMonth2" value="LABEL.D.D04.0029" /><!-- 8월 -->
								<c:set var="headerMonth2Range" value="(${displayYear}.07.21~${displayYear}.08.20)" />
								<c:set var="headerMonth3" value="LABEL.D.D04.0030" /><!-- 9월 -->
								<c:set var="headerMonth3Range" value="(${displayYear}.08.21~${displayYear}.09.20)" />
							</c:when>
							<c:when test="${displayMonth eq '10' || displayMonth eq '11' || displayMonth eq '12'}">
								<c:set var="headerMonth1" value="LABEL.D.D04.0031" /><!-- 10월 -->
								<c:set var="headerMonth1Range" value="(${displayYear}.09.21~${displayYear}.10.20)" />
								<c:set var="headerMonth2" value="LABEL.D.D04.0032" /><!-- 11월 -->
								<c:set var="headerMonth2Range" value="(${displayYear}.10.21~${displayYear}.11.20)" />
								<c:set var="headerMonth3" value="LABEL.D.D04.0033" /><!-- 12월 -->
								<c:set var="headerMonth3Range" value="(${displayYear}.11.21~${displayYear}.12.20)" />
							</c:when>
						</c:choose>
						<div class="listArea" style="margin-bottom:0px;">
					        <div class="table">
					            <table class="listTable">
						            <thead>
						            	<tr>
						            		<th class="th02" style="width:20%;"><spring:message code='LABEL.D.D25.0018' /><!-- 구분 --></th>
						            		<th class="th02" style="width:20%;"><spring:message code='<c:out value="${headerMonth1}" />' /><!-- 월 --> <c:out value="${headerMonth1Range}" /></th>
						            		<th class="th02" style="width:20%;"><spring:message code='<c:out value="${headerMonth2}" />' /><!-- 월 --> <c:out value="${headerMonth2Range}" /></th>
						            		<th class="th02" style="width:20%;"><spring:message code='<c:out value="${headerMonth3}" />' /><!-- 월 --> <c:out value="${headerMonth3Range}" /></th>
						            		<th class="th02 lastCol"><spring:message code='LABEL.D.D25.0046' /><!-- 계 --></th>
						            	</tr>
						            </thead>
						            <tbody>
						            	<c:if test="${not empty T_HEADER}">
						            		<fmt:parseNumber var="limitNumber" value="52" />
							            	<c:set var="totalSum" value="${T_HEADER[0].MONSUM + T_HEADER[1].MONSUM + T_HEADER[2].MONSUM}" />
				            				<c:set var="totalWorkDay" value="${T_HEADER[0].WKDAY + T_HEADER[1].WKDAY + T_HEADER[2].WKDAY}" />
							            	<tr class="borderRow">
							            		<td><spring:message code='LABEL.D.D25.0022' /><!-- 실 근무시간 --></td>
							            		<td>${T_HEADER[0].MONSUM eq null ? 0 : T_HEADER[0].MONSUM}</td>
							            		<td>${T_HEADER[1].MONSUM eq null ? 0 : T_HEADER[1].MONSUM}</td>
							            		<td>${T_HEADER[2].MONSUM eq null ? 0 : T_HEADER[2].MONSUM}</td>
							            		<td class="lastCol"><fmt:formatNumber value="${totalSum}" pattern=".00" /></td>
							            	</tr>
							            	<tr class="borderRow">
							            		<td><spring:message code='LABEL.D.D25.0021' /><!-- 주당 평균 실 근무시간 --></td>
							            		<fmt:parseNumber var="convertWEKAVR0" value="${T_HEADER[0].WEKAVR}" />
							            		<fmt:parseNumber var="convertWEKAVR1" value="${T_HEADER[1].WEKAVR}" />
							            		<fmt:parseNumber var="convertWEKAVR2" value="${T_HEADER[0].WEKAVR}" />
							            		<fmt:parseNumber var="totalWEKAVR" value="${totalSum / totalWorkDay * 7}" />
							            		<td <c:if test="${convertWEKAVR0 ge limitNumber}">class="td11"</c:if>>${T_HEADER[0].WEKAVR eq null ? 0 : T_HEADER[0].WEKAVR}</td>
							            		<td <c:if test="${convertWEKAVR1 ge limitNumber}">class="td11"</c:if>>${T_HEADER[1].WEKAVR eq null ? 0 : T_HEADER[1].WEKAVR}</td>
							            		<td <c:if test="${convertWEKAVR2 ge limitNumber}">class="td11"</c:if>>${T_HEADER[2].WEKAVR eq null ? 0 : T_HEADER[2].WEKAVR}</td>
							            		<td class="lastCol <c:if test="${totalWEKAVR ge limitNumber}">td11</c:if>"><fmt:formatNumber value="${totalSum / totalWorkDay * 7}" pattern=".00" /></td>
							            	</tr>
						            	</c:if>
						            </tbody>
					            </table>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
				<div class="commentOne">
					<span><spring:message code='LABEL.D.D25.0017' /><!-- 주당 평균 실 근무시간 : 해당 월 근태일수를 7일(1주)로 환산하여 산출한 기준입니다.(월 합계 ÷ 근태일수 × 7일) --></span>
				</div>
				<br/>
				</c:if>
			
				<br/>
				<h2 class="subtitle"><spring:message code='LABEL.D.D25.0008' /><!-- 2.세부 현황 --></h2>
				<br/>
				<h2 class="subtitle"><spring:message code='LABEL.D.D25.0056' /><!-- 실근무시간 = 정상근무 + 초과근무 - 휴게 - 비근무 --></h2>
				<div class="listArea" style="margin-bottom:0px;">
			        <div class="table">
			            <table class="listTable">
				            <thead>
				            	<colgroup>
					        		<col style="width:8%" />
					        		<col style="width:5%" />
					        		<col style="width:5%" />
					        		<col style="width:5%" />
					        		<col style="width:5%" />
									<c:if test="${not empty T_NWKTYP}">
										<fmt:parseNumber var="colWidth" value="${68 / fn:length(T_NWKTYP)}" integerOnly="true" />
										<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
											<col style="width:${colWidth}%" />
										</c:forEach>
									</c:if>
					        		<col/>
					        	</colgroup>
				            	<tr>
				            		<th rowspan="2"><spring:message code='LABEL.D.D25.0023' /><!-- 일자 --></th>
				            		<th rowspan="2"><spring:message code='LABEL.D.D25.0024' /><!-- 정상근무시간 --></th>
				            		<th rowspan="2"><spring:message code='LABEL.D.D25.0025' /><!-- 초과근무 --></th>
				            		<th rowspan="2"><spring:message code='LABEL.D.D25.0026' /><!-- 휴게시간 --></th>
				            		<th rowspan="2"><spring:message code='LABEL.D.D25.0027' /><!-- 비근무 --></th>
				            		<c:if test="${not empty T_NWKTYP}">
				            			<th colspan="${fn:length(T_NWKTYP)}"><spring:message code='LABEL.D.D25.0028' /><!-- 비근무 --></th>
				            		</c:if>
					            	<th rowspan="2" class="lastCol"><spring:message code='LABEL.D.D25.0029' /><!-- 실 근무시간 --></th>
				            	</tr>
				            	<tr>
			            		<c:if test="${not empty T_NWKTYP}">
			            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
				            			<th style="width:50px;">${nwktyp.NWKTXT}</th>
				            		</c:forEach>
			            		</c:if>
				            	</tr>
				            </thead>
			            	<c:if test="${not empty T_BODY}">
				            <tbody>
				            	<c:set var="SUM_NORTM" value="0" scope="request" />
				            	<c:set var="SUM_OVRTM" value="0" scope="request" />
				            	<c:set var="SUM_BRKTM" value="0" scope="request" />
				            	<c:set var="SUM_NWKTM" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP1" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP2" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP3" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP4" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP5" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP6" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP7" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP8" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP9" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP10" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP11" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP12" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP13" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP14" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP15" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP16" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP17" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP18" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP19" value="0" scope="request" />
				            	<c:set var="SUM_NWKTYP20" value="0" scope="request" />
				            	<c:set var="SUM_RWKTM" value="0" scope="request" />
				            	
			            		<c:forEach var="body" items="${T_BODY}" varStatus="status">
			           			<c:choose>
			           				<c:when test="${fn:indexOf(body.DAYTX, '소계') > -1}">
			           					<c:set var="rowClass" value="sumRow" />
			           					<c:set var="tdClass" value="td11" />
			           				</c:when>
			           				<c:otherwise>
			           					<c:set var="rowClass" value="borderRow" />
			           					<c:set var="tdClass" value="" />
			           				</c:otherwise>
			           			</c:choose>
				            	<tr class="${rowClass}">
			            			<td class="${tdClass}" style="padding-top:0px;">${body.DAYTX}</td>
			            			<td class="${tdClass}" style="padding-top:0px;">${body.NORTM}</td>
			            			<td class="${tdClass}" style="padding-top:0px;">${body.OVRTM}</td>
			            			<td class="${tdClass}" style="padding-top:0px;">${body.BRKTM}</td>
			            			<td class="${tdClass}" style="padding-top:0px;">${body.NWKTM}</td>
			            			<c:if test="${not empty T_NWKTYP}">
				            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
					            			<td style="width:50px;padding-top:0px;" class="${tdClass}">${body[nwktyp.FLDNM]}</td>
					            			<c:choose>
					            				<c:when test="${status.count eq 1}"><c:set var="SUM_NWKTYP1" value="${SUM_NWKTYP1 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 2}"><c:set var="SUM_NWKTYP2" value="${SUM_NWKTYP2 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 3}"><c:set var="SUM_NWKTYP3" value="${SUM_NWKTYP3 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 4}"><c:set var="SUM_NWKTYP4" value="${SUM_NWKTYP4 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 5}"><c:set var="SUM_NWKTYP5" value="${SUM_NWKTYP5 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 6}"><c:set var="SUM_NWKTYP6" value="${SUM_NWKTYP6 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 7}"><c:set var="SUM_NWKTYP7" value="${SUM_NWKTYP7 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 8}"><c:set var="SUM_NWKTYP8" value="${SUM_NWKTYP8 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 9}"><c:set var="SUM_NWKTYP9" value="${SUM_NWKTYP9 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 10}"><c:set var="SUM_NWKTYP10" value="${SUM_NWKTYP10 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 11}"><c:set var="SUM_NWKTYP11" value="${SUM_NWKTYP11 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 12}"><c:set var="SUM_NWKTYP12" value="${SUM_NWKTYP12 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 13}"><c:set var="SUM_NWKTYP13" value="${SUM_NWKTYP13 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 14}"><c:set var="SUM_NWKTYP14" value="${SUM_NWKTYP14 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 15}"><c:set var="SUM_NWKTYP15" value="${SUM_NWKTYP15 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 16}"><c:set var="SUM_NWKTYP16" value="${SUM_NWKTYP16 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 17}"><c:set var="SUM_NWKTYP17" value="${SUM_NWKTYP17 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 18}"><c:set var="SUM_NWKTYP18" value="${SUM_NWKTYP18 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 19}"><c:set var="SUM_NWKTYP19" value="${SUM_NWKTYP19 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            				<c:when test="${status.count eq 20}"><c:set var="SUM_NWKTYP20" value="${SUM_NWKTYP20 + body[nwktyp.FLDNM]}" scope="request" /></c:when>
					            			</c:choose>
					            		</c:forEach>
				            		</c:if>
			            			<td class="lastCol td11" style="padding-top:0px;font-weight:bold;">${body.RWKTM}</td>
				            	</tr>
				            	<c:set var="SUM_NORTM" value="${SUM_NORTM +body.NORTM}" />
				            	<c:set var="SUM_OVRTM" value="${SUM_OVRTM +body.OVRTM}" />
				            	<c:set var="SUM_BRKTM" value="${SUM_BRKTM +body.BRKTM}" />
				            	<c:set var="SUM_NWKTM" value="${SUM_NWKTM +body.NWKTM}" />
				            	<c:set var="SUM_RWKTM" value="${SUM_RWKTM +body.RWKTM}" />
			            		</c:forEach>
			            		<c:if test="${SEARCH_GUBUN eq 'M'}">
				            		<tr id="total_calc_row" class="sumRow">
				            			<td class="td11" style="padding-top:0px;">합계</td>
				            			<td class="td11" style="padding-top:0px;">
				            				<c:choose>
						            			<c:when test="${SUM_NORTM eq 0}">0</c:when>
						            			<c:otherwise><fmt:formatNumber value="${SUM_NORTM}" pattern=".00" /></c:otherwise>
					            			</c:choose>
				            			</td>
				            			<td class="td11" style="padding-top:0px;">
				            				<c:choose>
						            			<c:when test="${SUM_OVRTM eq 0}">0</c:when>
						            			<c:otherwise><fmt:formatNumber value="${SUM_OVRTM}" pattern=".00" /></c:otherwise>
					            			</c:choose>
					            		</td>
				            			<td class="td11" style="padding-top:0px;">
				            				<c:choose>
						            			<c:when test="${SUM_BRKTM eq 0}">0</c:when>
						            			<c:otherwise><fmt:formatNumber value="${SUM_BRKTM}" pattern=".00" /></c:otherwise>
					            			</c:choose>
					            		</td>
				            			<td class="td11" style="padding-top:0px;">
				            				<c:choose>
						            			<c:when test="${SUM_NWKTM eq 0}">0</c:when>
						            			<c:otherwise><fmt:formatNumber value="${SUM_NWKTM}" pattern=".00" /></c:otherwise>
					            			</c:choose>
					            		</td>
				            			<c:if test="${not empty T_NWKTYP}">
					            			<c:forEach var="nwktyp" items="${T_NWKTYP}" varStatus="status">
						            			<td style="padding-top:0px;" class="td11">
							            			<c:set var="fName" value="SUM_NWKTYP${status.count}" scope="request" />
							            			<c:choose>
								            			<c:when test="${requestScope[fName] eq 0}">0</c:when>
								            			<c:otherwise><fmt:formatNumber value="${requestScope[fName]}" pattern=".00" /></c:otherwise>
							            			</c:choose>
						            			</td>
						            		</c:forEach>
					            		</c:if>
				            			<td class="lastCol td11" style="font-weight:bold;">
				            				<c:choose>
						            			<c:when test="${SUM_RWKTM eq 0}">0</c:when>
						            			<c:otherwise><fmt:formatNumber value="${SUM_RWKTM}" pattern=".00" /></c:otherwise>
					            			</c:choose>
					            		</td>
				            		</tr>
				            	</c:if>
				            </tbody>
			            	</c:if>
			            </table>
					</div>
				</div>
				<div class="commentOne">
					<span><spring:message code='LABEL.D.D25.0009' /><!--실 근무시간 산정을 위해 휴게시간(식사시간 포함) 및 비근무를 제외한 기준입니다.--></span>
				</div>
				
				<c:if test="${EMPGUB eq 'H'}">
				<br/>
				<div class="commentOne">
					<span><spring:message code='LABEL.D.D25.0055' /><!--현재일 기준으로 계획근무일정을 반영한 예상 근무시간입니다.--></span>
				</div>
				</c:if>
				
			</div>
		</div>
	</form>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="false"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="hris.common.WebUserData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    WebUserData user = (WebUserData) session.getAttribute("user");
    request.setAttribute("e_titl2", StringUtils.isBlank(user.e_titl2) ? "" : "/" + user.e_titl2);
    request.setAttribute("e_ess", user.e_ess);
%>
<script type="text/javascript">
function GetIEVersion() {
	var sAgent = window.navigator.userAgent;
	var Idx = sAgent.indexOf("MSIE");
	// If IE, return version number.
	if (Idx > 0) {
		return parseInt(sAgent.substring(Idx + 5, sAgent.indexOf(".", Idx)));
	}
	// If IE 11 then look for Updated user agent string.
	else if (!!sAgent.match(/Trident\/7\./)) {
		return 11;
	}
	// It is not IE
	else {
		return 0;
	}
}

if (GetIEVersion() > 0 || navigator.userAgent.toLowerCase().indexOf('firefox') > -1) {
	if (GetIEVersion() < 11) {
		if (confirm("GHR은 Internet Explorer 11에 최적화되어 있습니다." +
			"\nInternet Explorer 버젼을 확인하시고, 필요 시 업그레이드하시기 바랍니다." +
			"\n\n확인버튼을 클릭하시면, 해당 전사게시판 공지물로 이동합니다." +
			"\n\n※ I/E 업그레이드 관련 내용은 전사게시판을 참조하시기 바랍니다." +
			"\n(전사게시판에서 \"IE 11\"에 검색하시면 관련 내용을 찾으실 수 있습니다.)"
		))
		window.location = "http://gportal.lgmma.com/lightpack/board/boardItem/readBoardItemLinkView.do?itemId=120003403992&popupYn=true&portletYn=true&poolIdx=1";
	}
}
</script>
<!-- mainWrap start -->
<div class="mainWrap">

	<!-- 메인이미지 start -->
	<div class="mainVisual">
		<img src="/web-resource/images/main/main_visual.jpg" title="메인이미지" />
	</div>
	<!-- 메인이미지 end -->

	<!-- 컨텐츠 start -->
	<div class="mainContents">
		<div class="myInfoBox">
			<h2>
				<a href="/base/basicInfo">
					<img src="/web-resource/images/main/con_txt_01.gif" title="MYINFO" />
					<img src="/web-resource/images/main/ico_plus.gif" title="MYINFO 더보기" class="icoPlus" />
				</a>
			</h2>
			<div class="myPhoto">
				<p class="photo">
				<%-- 이미지없을경우  기본사이즈 150*190 px --%>
				<img src="${!empty photoUrl ? fn:escapeXml( photoUrl ) : '/web-resource/images/myphoto_empty.gif'}" title="${!empty photoUrl ? '증명사진' : '증명사진없음'}" />
				</p>
			</div>
			<ul class="myInfo">
				<li class="txt"><strong>${fn:escapeXml( lgday.KNAME )}</strong> ${fn:escapeXml( lgday.TITEL )}${fn:escapeXml( e_titl2 )}</li>
				<li>${fn:escapeXml( lgday.ORGTX )}</li>
				<li>LG Days <span class="colorRed">${fn:escapeXml( lgday.LGDAY )} days</span></li>
			</ul>
			<div class="btnArea"><a class="btnS" href="/base/basicInfo"><span>나의 인사정보</span></a></div>
		</div>
		<div class="myVacationBox">
			<h2>
				<a href="/work/vacationInfo?TAB_ID=2">
					<img src="/web-resource/images/main/con_txt_02.gif" title="MY휴가현황" />
					<img src="/web-resource/images/main/ico_plus.gif" title="MY휴가현황 더보기" class="icoPlus" />
				</a>
			</h2>
            <div class="listArea">
                <div class="table">
                    <table class="listTable">
                        <caption>MY 휴가현황</caption>
                        <colgroup>
                            <col class="col_33p" />
                            <col class="col_33p" />
                            <col class="col_34p" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>구분</th>
                                <th>사용률</th>
                                <th class="tdBorder">잔여일수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>연차휴가</td>
                                <td>${fn:escapeXml( vacation.USERATE )}</td>
                                <td>${fn:escapeXml( vacation.EXTAB )}</td>
                            </tr>
                            <c:if test="${e_ess ne 'N' or vacation.EXTAB2 gt 0.0}">
                            <tr>
                                <td>보상휴가</td>
                                <td>${fn:escapeXml( vacation.USERATE2 )}</td>
                                <td>${fn:escapeXml( vacation.EXTAB2 )}</td>
                            </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
			<div class="btnArea">
				<a class="btnS" href="/work/vacationInfo?TAB_ID=1"><span>휴가신청</span></a>
				<a class="btnS" href="/work/vacationInfo?TAB_ID=3"><span>휴가실적조회</span></a>
			</div>
		</div>
		<div class="myReqInfoBox">
			<h2>
				<a href="${applUrl}">
					<c:choose><c:when test="${applUrl eq '/appl/myReqInfo'}">
					<img src="/web-resource/images/main/con_txt_03.gif" title="결재진행현황" />
					</c:when><c:otherwise>
					<img src="/web-resource/images/main/con_txt_04.gif" title="MY 결재함" />
					</c:otherwise></c:choose>
					<img src="/web-resource/images/main/ico_plus.gif" title="결재진행현황 더보기" class="icoPlus" />
				</a>
			</h2>
			<!-- 결재진행현황 table start -->
			<div class="listArea">
				<div class="table">
					<table class="listTable">
					<caption>결재진행현황</caption>
					<colgroup>
						<col class="col_25p" />
						<col class="col_45p" />
						<col class="col_30p" />
					</colgroup>
					<thead>
						<tr>
							<th>일자</th>
							<th>업무구분</th>
							<th class="tdBorder">상태</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="appl" items="${applStatus}" varStatus="loop">
						<tr>
							<td><a href="${applUrl}">${fn:escapeXml( appl.BEGDA )}</a></td>
							<td>
								<a href="${applUrl}" title="${fn:escapeXml( appl.UPMU_NAME )}">
								<c:choose>
								<c:when test="${appl.UPMU_NAME.length() le 10}">${fn:escapeXml( appl.UPMU_NAME )}</c:when>
								<c:when test="${appl.UPMU_NAME.length() gt 10}">${fn:escapeXml( appl.UPMU_NAME.substring(0, 9) )}...</c:when>
								</c:choose>
								</a>
							</td>
							<td><a href="${applUrl}">${fn:escapeXml( appl.STAT_TYPE )}</a></td>
						</tr>
						</c:forEach>
					</tbody>
					</table>
				</div>
			</div>
			<!-- 결재진행현황 table end -->
		</div>
	</div>
	<!-- 컨텐츠 end -->

	<!-- quick start -->
	<div class="mainQuick">
		<h2><img src="/web-resource/images/main/quick.gif" title=" QuickMenu" /></h2>
		<ul>
			<li><a href="/salary/monthlyDetail"><img src="/web-resource/images/main/quick_ico_01.png" title="월급여조회" /><p>월급여조회</p></a></li>
			<c:if test="${OTbuildYn eq 'Y'}"><%-- 팀장미만 --%>
			<li><a href="/work/attendanceInfo"><img src="/web-resource/images/main/quick_ico_04.png" title="초과근무신청" /><p>초과근무신청</p></a></li>
			</c:if>
			<c:if test="${OTbuildYn ne 'Y'}"><%-- 팀장이상 --%>
			<li><a href="/supp/scholarshipInfo"><img src="/web-resource/images/main/quick_ico_11.png" title="장학자금" /><p>장학자금</p></a></li>
			</c:if>
			<li><a href="/work/vacationInfo?TAB_ID=1"><img src="/web-resource/images/main/quick_ico_02.png" title="휴가신청" /><p>휴가신청</p></a></li>
			<li><a href="/cert/issueInfo"><img src="/web-resource/images/main/quick_ico_03.png" title="제증명" /><p>제증명</p></a></li>
			<li><a href="/appl/myReqInfo"><img src="/web-resource/images/main/quick_ico_05.png" title="결재진행현황" /><p>결재진행현황</p></a></li>
		</ul>
	</div>
	<!-- quick end -->

	<!-- footer start -->
	<div class="mainFooter">
		<p>COPYRIGHT © 2017 LG MMA ALL RIGHTS RESERVED</p>
	</div>
	<!-- footer end -->

</div>
<!-- mainWrap end -->
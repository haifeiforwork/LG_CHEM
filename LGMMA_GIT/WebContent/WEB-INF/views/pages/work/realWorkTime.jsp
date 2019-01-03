<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${param.MSSYN ne 'Y' and FROM_PORTAL ne 'Y'}">
<!-- Page title start -->
<div class="title">
    <h1>근무시간입력</h1>
    <div class="titleRight">
        <ul class="pageLocation">
            <li><span><a href="#">Home</a></span></li>
            <li><span><a href="#">My Info</a></span></li>
            <li><span><a href="#">근태</a></span></li>
            <li class="lastLocation"><span><a href="#">근무시간입력</a></span></li>
        </ul>
    </div>
</div>
<!--// Page title end -->
</c:if>

<c:choose><c:when test="${param.MSSYN eq 'Y'}"><div></c:when><c:when test="${FROM_PORTAL eq 'Y'}"><div style="margin:30px auto; width:1035px"></c:when></c:choose>
<!-- Tab start -->
<div class="tabArea">
    <ul class="tab">
       	<li><a href="#" id="listTab">근무시간 목록</a></li>
       	<li><a href="#" id="calendarTab" class="selected">근무시간 달력</a></li>
        <li>
            <div class="buttonArea calendar-navigation">
                <ul class="btn_crud">
                    <li class="float-left"><a href="#" id="prevMonth"><span>이전 달</span></a></li>
                    <div class="year-month float-left" data-year-month="${fn:escapeXml( E_YYMON )}" data-selected="">
                        ${fn:escapeXml( yyyy )}년 ${fn:escapeXml( MM )}월
                    </div>
                    <li><a href="#" id="nextMonth"><span>다음 달</span></a></li>
                </ul>
            </div>
        </li><c:if test="${param.MSSYN ne 'Y'}">
        <li style="float:right; margin-top:2px; margin-right:0">
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:downloadPdfReader()"><span>PDF 뷰어 다운로드</span></a></li>
                    <li><a href="/download/worktimeForm/guide.pdf" target="_blank"><span>제도 운영 기준 가이드</span></a></li>
                    <li><a href="/download/worktimeForm/faq.pdf" target="_blank"><span>FAQ</span></a></li>
                </ul>
            </div>
        </li></c:if>
    </ul>
</div>
<!--// Tab end -->

<%@ include file="include/realWorkTimeHeader.jsp" %>

<form id="attForm" method="post">
    <input type="hidden" name="E_TPGUB" value="${fn:escapeXml( E_TPGUB )}" />
    <input type="hidden" name="P_PERNR" value="${fn:escapeXml( param.P_PERNR )}" />
    <input type="hidden" name="P_ORGEH" value="${fn:escapeXml( param.P_ORGEH )}" />
    <input type="hidden" name="P_RETIR" value="${fn:escapeXml( param.P_RETIR )}" /><c:if test="${param.MSSYN eq 'Y'}">
    <input type="hidden" name="MSSYN" value="Y" />
    </c:if>
</form>

<!-- 근무시간 목록 tab start -->
<div class="tabUnder listTab Lnodisplay">
<%@ include file="include/realWorkTimeList.jsp" %>
</div>
<!--// 근무시간 목록 tab end -->

<!-- 근무시간 달력 tab start -->
<div class="tabUnder calendarTab">
<%@ include file="include/realWorkTimeCalendar.jsp" %>
</div>
<!--// 근무시간 달력 tab end -->

<c:if test="${FROM_PORTAL eq 'Y'}"></div></c:if>

<!-- 비근무시간 목록 테이블 시작 -->
<div class="layerWrapper layerSizeM" id="breaktimeList" style="display:none">
    <div class="layerHeader">
        <strong></strong>
        <a href="#" class="btnClose" data-name="breaktimeClose">창닫기</a>
    </div>
    <div class="layerContainer">
        <div class="layerContent">
            <div class="listArea">
                <div class="table">
                    <table class="listTable worktime breaktime-table">
                        <colgroup>
                            <col style="width: 8%" />
                            <col style="width:30%" />
                            <col style="width:62%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>선택</th>
                                <th>시간</th>
                                <th>사유</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="oddRow" data-not-found>
                                <td colspan="3">해당하는 데이타가 존재하지 않습니다.</td>
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr class="oddRow">
                                <td>합계</td>
                                <td class="minutes-sum"></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <div class="tableComment hide-on-readonly">
                    <p><span class="prefix">비근무시간을 입력할 수 있습니다.</span></p>
                </div>
            </div>
            <div class="buttonArea hide-on-readonly">
                <ul class="btn_crud">
                    <li><a href="#" data-name="breaktimeAdd"><span>행추가</span></a></li>
                    <li><a href="#" data-name="breaktimeRemove"><span>행삭제</span></a></li>
                    <li><a href="#" data-name="breaktimeSave" class="darken"><span>저장</span></a></li>
                </ul>
            </div>
        </div>
    </div>
</div>
<!-- 비근무시간 목록 테이블 끝 -->

<!-- 업무재개시간 목록 테이블 시작 -->
<div class="layerWrapper layerSizeML" id="extratimeList" style="display:none">
    <div class="layerHeader">
        <strong></strong>
        <a href="#" class="btnClose" data-name="extratimeClose">창닫기</a>
    </div>
    <div class="layerContainer">
        <div class="layerContent">
            <div class="listArea">
                <div class="table">
                    <table class="listTable worktime breaktime-table">
                        <colgroup>
                            <col style="width:8%" />
                            <col style="width:22%" />
                            <col style="width:22%" />
                            <col style="width:48%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>선택</th>
                                <th>업무 시작</th>
                                <th>업무 종료</th>
                                <th>사유</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="align-center"><input type="checkbox" /></td>
                                <td><select name="ABEGUZ-hour" class="time"></select> <label>:</label> <select name="ABEGUZ-minute" class="time"></select></td>
                                <td><select name="AENDUZ-hour" class="time"></select> <label>:</label> <select name="AENDUZ-minute" class="time"></select></td>
                                <td><input type="text" name="DESCR" placeholder="2글자 이상 입력하세요." maxlength="50" /></td>
                            </tr>
                            <tr>
                                <td class="align-center"><input type="checkbox" /></td>
                                <td><select name="ABEGUZ-hour" class="time"></select> <label>:</label> <select name="ABEGUZ-minute" class="time"></select></td>
                                <td><select name="AENDUZ-hour" class="time"></select> <label>:</label> <select name="AENDUZ-minute" class="time"></select></td>
                                <td><input type="text" name="DESCR" placeholder="2글자 이상 입력하세요." maxlength="50" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="tableComment hide-on-readonly">
                    <p><span class="prefix">업무재개시간은 최대 2건까지 입력가능합니다.</span></p>
                </div>
            </div>
            <div class="buttonArea hide-on-readonly">
                <ul class="btn_crud">
                    <li><a class="search" href="#" data-name="extratimeClear"><span>초기화</span></a></li>
                    <li><a class="darken" href="#" data-name="extratimeSave"><span>저장</span></a></li>
                </ul>
            </div>
        </div>
    </div>
</div>
<!-- 업무재개시간 목록 테이블 끝 -->

<!-- 교육/출장 계획 입력 테이블 시작 -->
<div class="layerWrapper layerSizeM" id="plantimeTable" style="display:none">
    <div class="layerHeader">
        <strong>교육/출장 계획 입력</strong>
        <a href="#" class="btnClose" data-name="plantimeClose">창닫기</a>
    </div>
    <div class="layerContainer">
        <div class="layerContent">
            <div class="listArea">
                <div class="table">
                    <table class="listTable worktime breaktime-table">
                        <colgroup>
                            <col />
                            <col />
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>구분</th>
                                <th>시작일</th>
                                <th>종료일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><select id="WKTYP" style="width:90px"></select></td>
                                <td><input type="text" id="BEGDA" class="datetime-yyyymmdd" /></td>
                                <td><input type="text" id="ENDDA" class="datetime-yyyymmdd" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="buttonArea">
                <ul class="btn_crud">
                    <li><a class="darken" href="#" data-name="plantimeSave"><span>저장</span></a></li>
                </ul>
            </div>
            <div class="tableComment">
                <p><span class="bold">참고사항</span></p>
                <p>- 시작일은 내일 일자부터 입력 가능</p>
                <p>- 종료일은 입력된 시작일로부터 최대 한 달 후 일자까지 입력 가능</p>
                <p>- 저장 후 변경은 해당 일자 도래시 가능</p>
            </div>
        </div>
    </div>
</div>
<!-- 교육/출장 계획 입력 테이블 끝 -->

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="breaktimeTemplate">
        <tr>
            <td><input type="checkbox" data-disabled="" /></td>
            <td>
                <button type="button" class="icon-button minus" data-disabled="">
                -
                </button><input type="text" name="ABSTD" readonly="readonly" data-disabled="" data-value="" /><button type="button" class="icon-button plus" data-disabled="">
                +
                </button>
            </td>
            <td><input type="text" name="DESCR" maxlength="50" data-value="" data-disabled="" /></td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->

<!-- popup : 초과근무 실적입력 / 근무시간 사용 현황 table 상단 메뉴 start -->
<div class="layerWrapper" id="modalDialog" style="display:none">
    <div class="layerHeader">
        <strong></strong>
        <a href="#" class="btnClose" data-name="modalDialog">창닫기</a>
    </div>
    <iframe src="about:blank" style="border:0;padding:16px;overflow-x:hidden"></iframe>
</div>
<!--// popup : 초과근무 실적입력 / 근무시간 사용 현황 table 상단 메뉴 end -->

<%@ include file="include/realWorkTimeJS.jsp" %>
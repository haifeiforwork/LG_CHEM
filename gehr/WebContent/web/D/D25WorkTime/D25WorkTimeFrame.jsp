<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무시간 입력
/*   Program ID   : D25WorkTimeFrame.jsp
/*   Description  : 근무시간 입력 frame
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 2018-06-04 rdcamel [CSR ID:3704184] 유연근로제 동의 관련 기능 추가 건 - Global HR Portal
/******************************************************************************/
--%><%@ page contentType="text/html; charset=utf-8" %><%
%><%@ include file="/web/D/D25WorkTime/D25WorkTimeCommonPreprocess.jsp" %><!DOCTYPE html>
<%-- html 시작 선언 및 head 선언 --%>
<%-- * 참고 *
     아래 noCache 변수는 css와 js 파일이 browser에서 caching 되는 것을 방지하기위한 변수이다.
     운영모드에서 css와 js 파일이 안정화되어 수정될 일이 없다고 판단되는 경우 browser에서 caching 되도록 하여 server 부하를 줄이고자한다면 noCache 변수를 삭제한다.

     noCache 변수 삭제 후 운영중에 css나 js 파일이 변경되면 browser의 cache를 사용자가 직접 삭제해줘야하는데 이런 번거로움을 없애려면 noCache 변수를 다시 넣으면된다.

     주의할 점은 jsp:include tag 내부에서는 주석이 오류를 발생시키므로
     주석으로 남기고 싶은 경우 noCache 변수 line을 jsp:include tag 외부로 빼서 주석처리하거나
     변수명을 noCache에서 noCacheX 등으로 변경한다. --%>
<jsp:include page="/include/header.jsp">
    <jsp:param name="noCache" value="?${timestamp}" />
    <jsp:param name="css" value="bootstrap-3.3.2.min.css" />
    <jsp:param name="css" value="D/D25WorkTime.css" />
    <jsp:param name="script" value="moment-with-locales.min.js" />
    <jsp:param name="script" value="jquery-ext-logger.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
    <jsp:param name="script" value="D/D25WorkTimeFrame-var.jsp?JKBGB=${E_JKBGB}" />
    <jsp:param name="script" value="D/D25WorkTimeFrame.js" />
</jsp:include>
<%-- body 시작 선언 및 body title --%>
<%-- [CSR ID:3704184] 유연근무제 제도 확인 용 popCheck 값 추가 --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value='${E_TPGUB ne "C" ? "LABEL.D.D25.N1001" : "LABEL.D.D25.N1002"}' />
    <jsp:param name="popCheck" value="${popCheck}" />
</jsp:include>

<form id="urlForm" name="urlForm" target="listFrame" method="post">
    <input type="hidden" name="unblock" value="false" />
    <input type="hidden" name="subView" value="Y" />
    <input type="hidden" name="E_TPGUB" value="${E_TPGUB}" />
    <input type="hidden" name="P_PERNR" value="${param.P_PERNR}" />
    <input type="hidden" name="P_ORGEH" value="${param.P_ORGEH}" />
    <input type="hidden" name="P_RETIR" value="${param.P_RETIR}" />
</form>
<div class="contentBody">
    <!-- Tab 시작 -->
    <div class="tabArea">
        <ul class="tab">
           	<li><a href="javascript:;" onclick="tabMove(this, 0)" data-name="list"><spring:message code="TAB.COMMON.0119" /></a></li><%-- 근무시간 목록 --%>
           	<li><a href="javascript:;" onclick="tabMove(this, 1)" data-name="calendar"><spring:message code="TAB.COMMON.0120" /></a></li><%-- 근무시간 달력 --%>
            <li>
                <div class="calendar-navigation">
                    <div><button type="button" id="prevMonth"><spring:message code="BUTTON.D.D25.N0001" /></button></div>
                    <div class="year-month" data-year-month="${E_YYMON}" data-selected="">
                         ${yyyy}<spring:message code="LABEL.D.D25.N2141" /> ${MM}<spring:message code="LABEL.D.D25.N2143" />
                    </div>
                    <div><button type="button" id="nextMonth"><spring:message code="BUTTON.D.D25.N0002" /></button></div>
                </div>
            </li><c:if test="${param.MSSYN ne 'Y'}">
            <li style="float:right; margin-right:0">
                <button type="button" class="download-guide" id="guideDownload"><spring:message code="BUTTON.D.D25.N0003" /></button><%-- 제도 운영 기준 가이드 --%>
                <button type="button" class="download-guide" id="faqDownload"><spring:message code="BUTTON.D.D25.N0005" /></button><%-- FAQ --%>
            </li></c:if>
        </ul>
    </div>

    <%@ include file="/web/D/D25WorkTime/D25WorkTimeSummary.jsp" %>

    <div class="frameWrapper">
        <!-- Tab 프레임 -->
        <iframe id="listFrame" name="listFrame" onload="autoResize()" frameborder="0"></iframe>
    </div>
</div>

<!-- 비근무시간 목록 테이블 시작 -->
<div style="width:460px; padding:20px; display:none" id="breaktimeList">
<div class="listArea">
    <h2 class="subtitle" style="float:left; margin-bottom:15px; font-size:14px"></h2>
    <div class="listTop">
        <div class="buttonArea">
            <ul class="btn_crud">
                <li class="hide-on-readonly"><a class="search" href="javascript:void(0)" data-name="breaktimeAdd"><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><%-- 행추가 --%></span></a></li>
                <li class="hide-on-readonly"><a class="search" href="javascript:void(0)" data-name="breaktimeRemove"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><%-- 행삭제 --%></span></a></li>
                <li class="hide-on-readonly"><a class="darken" href="javascript:void(0)" data-name="breaktimeSave"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
                <li><a class="darken" href="javascript:void(0)" data-name="breaktimeClose"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%-- 닫기 --%></span></a></li>
            </ul>
        </div>
        <div class="clear"></div>
    </div>
    <div class="table">
        <table class="listTable breaktime-table">
            <colgroup>
                <col style="width:10%" />
                <col style="width:30%" />
                <col style="width:60%" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2161" /></th><%-- 선택 --%>
                    <th><spring:message code="LABEL.D.D25.N7001" /></th><%-- 시간 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D25.N2162" /></th><%-- 사유 --%>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow" data-not-found>
                    <td class="lastCol" colspan="3"><spring:message code="MSG.COMMON.0004" /></td><%-- 해당하는 데이타가 존재하지 않습니다. --%>
                </tr>
            </tbody>
            <tfoot>
                <tr class="oddRow">
                    <td><spring:message code="LABEL.D.D25.N2116" /></td><%-- 합계 --%>
                    <td class="minutes-sum"></td>
                    <td class="lastCol"></td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div class="buttonArea hide-on-readonly">
        <div class="commentOne float-left" style="margin-top:0"><spring:message code="MSG.D.D25.N0011" /></div><%-- 비근무시간을 입력할 수 있습니다. --%>
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:void(0)" data-name="breaktimeSave"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
            <li><a class="darken" href="javascript:void(0)" data-name="breaktimeClose"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%-- 닫기 --%></span></a></li>
        </ul>
    </div>
    <div class="clear"></div>
</div>
</div>
<!-- 비근무시간 목록 테이블 끝 -->

<!-- 업무재개시간 목록 테이블 시작 -->
<div style="width:600px; padding:20px; display:none" id="extratimeList">
<div class="listArea">
    <h2 class="subtitle" style="float:left; margin-bottom:15px; font-size:14px"></h2>
    <div class="listTop">
        <div class="buttonArea">
            <ul class="btn_crud">
                <li class="hide-on-readonly"><a class="search" href="javascript:void(0)" data-name="extratimeInit"><span><spring:message code="LABEL.COMMON.0053" /><%-- 초기화 --%></span></a></li>
                <li class="hide-on-readonly"><a class="darken" href="javascript:void(0)" data-name="extratimeSave"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
                <li><a class="darken" href="javascript:void(0)" data-name="extratimeClose"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%-- 닫기 --%></span></a></li>
            </ul>
        </div>
        <div class="clear"></div>
    </div>
    <div class="table">
        <table class="listTable breaktime-table">
            <colgroup>
                <col style="width:10%" />
                <col style="width:25%" />
                <col style="width:25%" />
                <col style="width:40%" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2161" /></th><%-- 선택 --%>
                    <th><spring:message code="LABEL.D.D25.N2122" /></th><%-- 업무 시작 --%>
                    <th><spring:message code="LABEL.D.D25.N2123" /></th><%-- 업무 종료 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D25.N2162" /></th><%-- 사유 --%>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="align-center"><input type="checkbox" /></td>
                    <td><select name="ABEGUZ-hour" class="time"></select> <label>:</label> <select name="ABEGUZ-minute" class="time"></select></td>
                    <td><select name="AENDUZ-hour" class="time"></select> <label>:</label> <select name="AENDUZ-minute" class="time"></select></td>
                    <td class="lastCol"><input type="text" name="DESCR" placeholder="<spring:message code='MSG.D.D25.N0029' />" maxlength="50" /></td><%-- 2글자 이상 입력하세요. --%>
                </tr>
                <tr>
                    <td class="align-center"><input type="checkbox" /></td>
                    <td><select name="ABEGUZ-hour" class="time"></select> <label>:</label> <select name="ABEGUZ-minute" class="time"></select></td>
                    <td><select name="AENDUZ-hour" class="time"></select> <label>:</label> <select name="AENDUZ-minute" class="time"></select></td>
                    <td class="lastCol"><input type="text" name="DESCR" placeholder="<spring:message code='MSG.D.D25.N0029' />" maxlength="50" /></td><%-- 2글자 이상 입력하세요. --%>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="buttonArea hide-on-readonly">
        <div class="commentOne float-left" style="margin-top:0"><spring:message code="MSG.D.D25.N0023" /></div><%-- 업무재개시간은 최대 2건까지 입력가능합니다. --%>
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:void(0)" data-name="extratimeSave"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
            <li><a class="darken" href="javascript:void(0)" data-name="extratimeClose"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%-- 닫기 --%></span></a></li>
        </ul>
    </div>
    <div class="clear"></div>
</div>
</div>
<!-- 업무재개시간 목록 테이블 끝 -->

<!-- 교육/출장 계획 입력 테이블 시작 -->
<div style="width:460px; padding:20px; display:none" id="plantimeTable">
<div class="listArea">
    <h2 class="subtitle" style="float:left; margin-bottom:15px; font-size:14px"><spring:message code="LABEL.D.D25.N1011" /><%-- 교육/출장 계획 입력 --%></h2>
    <div class="listTop">
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a class="darken" href="javascript:void(0)" data-name="plantimeSave"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
                <li><a class="darken" href="javascript:void(0)" data-name="plantimeClose"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%-- 닫기 --%></span></a></li>
            </ul>
        </div>
        <div class="clear"></div>
    </div>
    <div class="table">
        <table class="listTable breaktime-table">
            <colgroup>
                <col style="width:auto" />
                <col style="width:auto" />
                <col style="width:auto" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2201" /></th><%-- 구분 --%>
                    <th><spring:message code="LABEL.D.D25.N2202" /></th><%-- 시작일 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D25.N2203" /></th><%-- 종료일 --%>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><select id="WKTYP" style="width:90px"></select></td>
                    <td><input type="text" id="BEGDA" class="date datetime-yyyymmdd" /></td>
                    <td class="lastCol"><input type="text" id="ENDDA" class="date datetime-yyyymmdd" /></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:void(0)" data-name="plantimeSave"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
            <li><a class="darken" href="javascript:void(0)" data-name="plantimeClose"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%-- 닫기 --%></span></a></li>
        </ul>
    </div>
    <div class="commentImportant align-left">
        <p><span class="comment-title"><spring:message code="MSG.D.D25.N0010" /></span></p><%-- 참고사항 --%>
        <p>- <spring:message code="MSG.D.D25.N0056" /></p><%-- 시작일은 내일 일자부터 입력 가능 --%>
        <p>- <spring:message code="MSG.D.D25.N0057" /></p><%-- 종료일은 입력된 시작일로부터 최대 한 달 후 일자까지 입력 가능 --%>
        <p>- <spring:message code="MSG.D.D25.N0058" /></p><%-- 저장 후 변경은 해당 일자 도래시 가능 --%>
    </div>
    <div class="clear"></div>
</div>
</div>
<!-- 교육/출장 계획 입력 테이블 끝 -->

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="breaktimeTemplate">
        <tr>
            <td><input type="checkbox" data-disabled /></td>
            <td>
                <button type="button" class="icon-button minus" data-disabled>
                -
                </button><input type="text" name="ABSTD" readonly="readonly" data-value /><button type="button" class="icon-button plus" data-disabled>
                +
                </button>
            </td>
            <td class="lastCol"><input type="text" name="DESCR" maxlength="50" data-value data-readonly /></td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->
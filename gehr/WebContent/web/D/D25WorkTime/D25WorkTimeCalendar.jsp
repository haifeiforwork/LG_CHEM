<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무시간 입력
/*   Program ID   : D25WorkTimeCalendar.jsp
/*   Description  : 근무시간 입력 달력 화면
/*   Note         : 
/*   Creation     : 2018-05-04 [WorkTime52] 유정우
/*   Update       : 
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
    <jsp:param name="script" value="bootstrap-3.3.2.min.js" />
    <jsp:param name="script" value="jquery-ext-logger.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
    <jsp:param name="script" value="D/D25WorkTimeCalendar.js" />
</jsp:include>
<%-- body 시작 선언 및 body title --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="subView" value="Y" />
</jsp:include>

<div class="tableArea" style="padding:0">
    <div class="table">
        <table class="worktime calendar">
            <colgroup>
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
                <col style="width:12.5%" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2142" /></th><%-- 주 --%>
                    <th><spring:message code="LABEL.D.D25.N2143" /></th><%-- 월 --%>
                    <th><spring:message code="LABEL.D.D25.N2144" /></th><%-- 화 --%>
                    <th><spring:message code="LABEL.D.D25.N2145" /></th><%-- 수 --%>
                    <th><spring:message code="LABEL.D.D25.N2146" /></th><%-- 목 --%>
                    <th><spring:message code="LABEL.D.D25.N2147" /></th><%-- 금 --%>
                    <th><spring:message code="LABEL.D.D25.N2148" /></th><%-- 토 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D25.N2149" /></th><%-- 일 --%>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow" data-not-found>
                    <td class="lastCol" colspan="8"><spring:message code="MSG.COMMON.0004"/></td><%-- 해당하는 데이타가 존재하지 않습니다. --%>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="calendarTemplate">
        <tr>
            <td class="isoweek" data-week="%"><div class="week-number">W%</div>#</td>
            <td class="weekday data-color" data-date="#"><div class="date-number">#</div>#</td>
            <td class="weekday data-color" data-date="#"><div class="date-number">#</div>#</td>
            <td class="weekday data-color" data-date="#"><div class="date-number">#</div>#</td>
            <td class="weekday data-color" data-date="#"><div class="date-number">#</div>#</td>
            <td class="weekday data-color" data-date="#"><div class="date-number">#</div>#</td>
            <td class="weekend data-color" data-date="#"><div class="date-number">#</div>#</td>
            <td class="weekend data-color lastCol" data-date="#"><div class="date-number">#</div>#</td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->
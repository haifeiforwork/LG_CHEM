<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 보상휴가 발생내역
/*   Program ID   : D03CompTimeList.jsp
/*   Description  : 보상휴가 발생내역
/*   Note         : 
/*   Creation     : 2018-07-25 [WorkTime52] 유정우
/*   Update       : 
/******************************************************************************/
--%><%@ page contentType="text/html; charset=utf-8" %><%
%><%@ include file="/web/common/commonProcess.jsp" %><%
%><%@ include file="/web/common/commonResponseHeader.jsp" %><%

request.setAttribute("timestamp", new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(java.util.Calendar.getInstance().getTime()));
request.setAttribute("Draggable", "Y");

%><!DOCTYPE html>
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
    <jsp:param name="css" value="D/D03CompTime.css" />
    <jsp:param name="script" value="moment-with-locales.min.js" />
    <jsp:param name="script" value="bootstrap-3.3.2.min.js" />
    <jsp:param name="script" value="jquery-ext-logger.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
    <jsp:param name="script" value="D/D03CompTimeList-var.jsp" />
    <jsp:param name="script" value="D/D03CompTimeList.js" />
</jsp:include>
<%-- body 시작 선언 및 body title --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="subView" value="Y" />
</jsp:include>

<div class="tableInquiry">
    <table>
        <colgroup>
            <col style="width:100px" />
            <col style="width:350px" />
            <col />
        </colgroup>
        <tbody>
            <tr>
                <th class="align_center">
                    <img class="searchTitle" src="${g.image}sshr/top_box_search.gif" />
                </th>
                <th>
                    <label class="bold"><spring:message code="LABEL.D.D03.0401" /><%-- 조회년월 --%></label>
                    <select id="year"><option>----</option></select>
                    <select id="month"><option>--</option></select>
                    <label id="period">(0000.00.00 ~ 0000.00.00)</label>
                </th>
                <th>
                    <label class="bold"><spring:message code="LABEL.D.D03.0402" /></label><%-- 월 전체조회 --%>
                    <input type="checkbox" id="I_TOTAL" checked="checked" />
                    <div class="tableBtnSearch"><a class="search" href="javascript:;"><span><spring:message code="BUTTON.COMMON.SEARCH" /><%-- 조회 --%></span></a></div>
                </th>
            </tr>
        </tbody>
    </table>
</div>
<div class="commentOne"><spring:message code="MSG.D.D03.0083" /></div><%-- 당월 연장근로 내역은 익월에 표시됩니다. --%>

<!-- 상단 보상휴가 발생현황 테이블 시작 -->
<div class="tableArea">
    <div class="table">
        <table class="summary">
            <colgroup>
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="LABEL.D.D03.0403" /></th><%-- 구분 --%>
                    <th><spring:message code="LABEL.D.D03.0404" /></th><%-- 평일연장 --%>
                    <th><spring:message code="LABEL.D.D03.0405" /></th><%-- 휴일연장 --%>
                    <th><spring:message code="LABEL.D.D03.0406" /></th><%-- 야간근무 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D03.0407" /></th><%-- 휴일근무 --%>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th><spring:message code="LABEL.D.D03.0408" /></th><%-- 근무시간 --%>
                    <td data-name="T_WHEAD-ZFIELD01">-</td>
                    <td data-name="T_WHEAD-ZFIELD02">-</td>
                    <td data-name="T_WHEAD-ZFIELD03">-</td>
                    <td data-name="T_WHEAD-ZFIELD04"" class="lastCol">-</td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D03.0409" /></th><%-- 보상휴가 --%>
                    <td data-name="T_WHEAD-ZFIELD05">-</td>
                    <td data-name="T_WHEAD-ZFIELD06">-</td>
                    <td data-name="T_WHEAD-ZFIELD07">-</td>
                    <td data-name="T_WHEAD-ZFIELD08"" class="lastCol">-</td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D03.0410" /></th><%-- 합계 --%>
                    <td data-name="T_WHEAD-ZFIELD09" colspan="4"" class="worktime-sum lastCol">-</td>
                </tr>
            </tbody>
        </table>
        <div id="messages" class="commentRFC"></div>
    </div>
</div>
<!-- 상단 보상휴가 발생현황 테이블 끝 -->

<!-- 보상휴가 발생내역 테이블 시작 -->
<div class="listArea">
    <div class="table scroll-table scroll-head">
        <table class="listTable">
            <colgroup>
                <col style="width:12%" />
                <col style="width:10%" />
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width:11%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
            </colgroup>
            <thead>
                <tr>
                    <th rowspan="2"><spring:message code="LABEL.D.D03.0403" /></th><%-- 구분 --%>
                    <th rowspan="3"><spring:message code="LABEL.D.D03.0411" /></th><%-- 업무구분 --%>
                    <th rowspan="3"><spring:message code="LABEL.D.D03.0412" /></th><%-- 계획근무시간 --%>
                    <th rowspan="3"><spring:message code="LABEL.D.D03.0413" /></th><%-- 실근무시간 --%>
                    <th rowspan="3"><spring:message code="LABEL.D.D03.0414" /></th><%-- 업무재개 --%>
                    <th colspan="4" class="lastCol"><spring:message code="LABEL.D.D03.0415" /></th><%-- 추가근무(시간) --%>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D03.0404" /></th><%-- 평일연장 --%>
                    <th><spring:message code="LABEL.D.D03.0405" /></th><%-- 휴일연장 --%>
                    <th><spring:message code="LABEL.D.D03.0406" /></th><%-- 야간근무 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D03.0407" /></th><%-- 휴일근무 --%>
                </tr>
                <tr class="lastRow">
                    <th><spring:message code="LABEL.D.D03.0410" /></th><%-- 합계 --%>
                    <th data-name="T_WORKS-CZNOOT" class="worktime-sum">-</th>
                    <th data-name="T_WORKS-CZHOOT" class="worktime-sum">-</th>
                    <th data-name="T_WORKS-CZNIGT" class="worktime-sum">-</th>
                    <th data-name="T_WORKS-CZHOWK" class="worktime-sum lastCol">-</th>
                </tr>
            </thead>
        </table>
    </div>
    <div class="scroll-table scroll-body">
        <table class="worktime listTable">
            <colgroup>
                <col style="width:12%" />
                <col style="width:10%" />
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width:11%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
            </colgroup>
            <tbody>
                <tr class="oddRow" data-not-found>
                    <td class="lastCol" colspan="9"><spring:message code="MSG.COMMON.0004"/></td><%-- 해당하는 데이타가 존재하지 않습니다. --%>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 보상휴가 발생내역 테이블 끝 -->

<!-- 업무재개시간 목록 테이블 시작 -->
<div style="width:600px; padding:20px; display:none" id="extratimeList">
<div class="listArea">
    <h2 class="subtitle" style="float:left; margin-bottom:15px; font-size:14px"><spring:message code="LABEL.D.D25.N1008" /></h2>
    <div class="listTop">
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a class="darken" href="javascript:void(0)" data-name="extratimeClose"><span><spring:message code="BUTTON.COMMON.CLOSE" /></span></a></li><%-- 닫기 --%>
            </ul>
        </div>
        <div class="clear"></div>
    </div>
    <div class="table">
        <table class="listTable breaktime-table">
            <colgroup>
                <col style="width:25%" />
                <col style="width:25%" />
                <col style="width:50%" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2122" /></th><%-- 업무 시작 --%>
                    <th><spring:message code="LABEL.D.D25.N2123" /></th><%-- 업무 종료 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D25.N2162" /></th><%-- 사유 --%>
                </tr>
            </thead>
            <tbody>
                <tr class="borderRow">
                    <td data-name="ABEGUZ">-</td>
                    <td data-name="AENDUZ">-</td>
                    <td data-name="DESCR" class="align-left lastCol">-</td>
                </tr>
                <tr>
                    <td data-name="ABEGUZ">-</td>
                    <td data-name="AENDUZ">-</td>
                    <td data-name="DESCR" class="align-left lastCol">-</td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="clear"></div>
</div>
</div>
<!-- 업무재개시간 목록 테이블 끝 -->

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="comptimeTemplate">
        <tr data-date data-tr-class>
            <td>#text#<%-- 구분 --%></td>
            <td>@<spring:message code="LABEL.D.D03.0416" />@<%-- 비대상기간 --%><%-- 업무구분 --%></td>
            <td>#text#<%-- 계획근무시간 --%></td>
            <td>#text#<%-- 실근무시간 --%></td>
            <td><%-- 업무재개시간 --%>
                <div class="align-center align-middle readonly-look">#text#</div>
                <a href="javascript:;" class="icon-popup data-class"><img src="${g.image}sshr/ico_magnify.png" alt="<spring:message code='BUTTON.COMMON.SEARCH' />"></a>
            </td>
            <td>#text#<%-- 평일연장 --%></td>
            <td>#text#<%-- 휴일연장 --%></td>
            <td>#text#<%-- 야간근무 --%></td>
            <td class="lastCol">#text#<%-- 휴일근무 --%></td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->
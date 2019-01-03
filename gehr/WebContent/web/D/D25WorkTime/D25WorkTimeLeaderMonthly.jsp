<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderMonthly.jsp
/*   Description  : 월별 근무 입력 현황 목록 조회 화면
/*   Note         : 
/*   Creation     : 2018-05-09 [WorkTime52] 유정우
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
    <jsp:param name="script" value="D/D25WorkTimeLeaderMonthly.js" />
</jsp:include>
<%-- body 시작 선언 및 body title --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="subView" value="Y" />
</jsp:include>
<!-- 근무 입력 현황 테이블 시작 -->
<div class="listArea">
    <div class="listTop">
        <span class="listCnt">&lt;<spring:message code="LABEL.D.D25.N7009" /><%-- 총 --%> <span data-name="empCount">0</span><spring:message code="LABEL.D.D25.N7010" /><%-- 건 --%>&gt;</span>
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:void(0)" data-name="excelDownload"><span><spring:message code="BUTTON.D.D25.N0004" /><%-- 엑셀 다운로드 --%></span></a></li>
            </ul>
        </div>
    </div>
    <div class="table">
        <table class="listTable" style="margin-bottom:0">
            <colgroup>
                <col style="width: 90px" />
                <col style="width:185px" />
                <col style="width:100px" />
                <col />
                <col />
                <col />
                <col />
                <col />
                <col />
                <col />
                <col />
                <col />
                <col />
            </colgroup>
            <thead>
                <tr>
                    <th rowspan="3"><spring:message code="LABEL.D.D25.N2172" /></th><%-- 이름 --%>
                    <th rowspan="3"><spring:message code="LABEL.D.D25.N2173" /></th><%-- 소속 --%>
                    <th rowspan="3"><spring:message code="LABEL.D.D25.N2174" /></th><%-- 직책 --%>
                    <th colspan="7"><spring:message code="LABEL.D.D25.N2183" /></th><%-- 개인입력 --%>
                    <th><spring:message code="LABEL.D.D25.N2184" /></th><%-- 회사인정 --%>
                    <th rowspan="3"><spring:message code="LABEL.D.D25.N2186" /></th><%-- GAP<br />(개인 - 회사) --%>
                    <th rowspan="3" class="lastCol"><spring:message code="LABEL.D.D25.N2187" /></th><%-- 상태 --%>
                </tr>
                <tr>
                    <th rowspan="2"><spring:message code="LABEL.D.D25.N2175" /></th><%-- 당월근무시간<br />(유급휴가포함) --%>
                    <th colspan="2"><spring:message code="LABEL.D.D25.N2176" /></th><%-- 월 기본<br />근무시간            --%>
                    <th colspan="2"><spring:message code="LABEL.D.D25.N2177" /></th><%-- 법정 최대 한도<br />근무시간     --%>
                    <th colspan="2"><spring:message code="LABEL.D.D25.N2178" /></th><%-- 기타 시간 --%>
                    <th rowspan="2"><spring:message code="LABEL.D.D25.N2185" /></th><%-- 근무시간 --%>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D25.N2179" /></th><%-- 기본 --%>
                    <th><spring:message code="LABEL.D.D25.N2180" /></th><%-- 잔여 --%>
                    <th><spring:message code="LABEL.D.D25.N2179" /></th><%-- 기본 --%>
                    <th><spring:message code="LABEL.D.D25.N2180" /></th><%-- 잔여 --%>
                    <th><spring:message code="LABEL.D.D25.N2181" /></th><%-- 비근무 --%>
                    <th><spring:message code="LABEL.D.D25.N2182" /></th><%-- 업무재개 --%>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow">
                    <td class="lastCol" colspan="13"><spring:message code="MSG.COMMON.0004"/></td><%-- 해당하는 데이타가 존재하지 않습니다. --%>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 근무 입력 현황 테이블 끝 -->

<!-- 상태 설명 테이블 끝 -->
<div class="commentImportant" style="width:100%">
    <p><span class="comment-title"><spring:message code="MSG.D.D25.N0043" /></span></p><%-- 상태 설명 --%>
    <p>- <span class="font-bold"><spring:message code="MSG.D.D25.N0044" /></span></p><%-- 월 기본 근무시간 잔여 평균 --%>
    <p><span class="traffic-light green" >&#9899;</span><spring:message code="MSG.D.D25.N0045" /></p><%-- 7시간 이상 --%>
    <p><span class="traffic-light yellow">&#9899;</span><spring:message code="MSG.D.D25.N0046" /></p><%-- 6시간 이상 7시간 미만 --%>
    <p><span class="traffic-light red"   >&#9899;</span><spring:message code="MSG.D.D25.N0047" /></p><%-- 6시간 미만 --%>
</div>
<!-- 상태 설명 테이블 끝 -->

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="trTemplate">
        <tr class="borderRow">
            <%-- 이름                         --%><td class="ellipsis emp-name" title="%2%"><a href="javascript:void(0)" data-pernr="%1%" data-orgeh="#" style="color:blue">%2%</a></td>
            <%-- 소속                         --%><td class="ellipsis org-name" title="%3%">%3%</td>
            <%-- 직책                         --%><td class="ellipsis duty-name" title="%4%">%4%</td>
            <%-- 누적<br />실근무시간         --%><td class="worktime-sum">#</td>
            <%-- 월 기본<br />근무시간        --%><td>#</td>
            <%-- 월 기본<br />근무시간        --%><td>#</td>
            <%-- 법정 최대 한도<br />근무시간 --%><td>#</td>
            <%-- 법정 최대 한도<br />근무시간 --%><td>#</td>
            <%-- 기타 시간                    --%><td>#</td>
            <%-- 기타 시간                    --%><td>#</td>
            <%-- 근무시간                     --%><td>#</td>
            <%-- GAP<br />(개인 - 회사)       --%><td>#</td>
            <%-- 상태                         --%><td class="lastCol">#</td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->

<form name="excelDownload" method="POST" target="hidden" action="${g.servlet}hris.D.D25WorkTime.D25WorkTimeLeaderMonthlySV"></form>

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->
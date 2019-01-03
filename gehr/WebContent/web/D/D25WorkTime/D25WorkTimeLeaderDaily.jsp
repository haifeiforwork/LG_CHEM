<%--
/******************************************************************************/
/*   System Name  : MSS
/*   1Depth Name  : 조직관리
/*   2Depth Name  : 조직/인원현황
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderDaily.jsp
/*   Description  : 일별 근무 입력 현황 목록 조회 화면
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
    <jsp:param name="script" value="D/D25WorkTimeLeaderDaily.js" />
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
    <div class="table" style="position:relative">
        <div class="date-spread frozen" style="left:0; width:420px">
            <table class="listTable">
                <colgroup>
                    <col style="width: 90px" />
                    <col style="width:185px" />
                    <col style="width: 90px" />
                    <col style="width: 55px" />
                </colgroup>
                <thead>
                    <tr class="multi-line">
                        <th><spring:message code="LABEL.D.D25.N2172" /></th><%-- 이름 --%>
                        <th><spring:message code="LABEL.D.D25.N2173" /></th><%-- 소속 --%>
                        <th><spring:message code="LABEL.D.D25.N2174" /></th><%-- 직책 --%>
                        <th class="worktime-sum lastCol"><spring:message code="LABEL.D.D25.N2116" /></th><%-- 계   --%>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        <div class="date-spread scroll" style="left:421px; width:765px" data-init-width>
            <table class="worktime listTable">
                <colgroup>
                    <col />
                </colgroup>
                <thead>
                    <tr class="multi-line">
                        <th class="lastCol">&nbsp;<br />&nbsp;</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        <div class="date-spread not-found-data"><spring:message code="MSG.COMMON.0004"/></div><%-- 해당하는 데이타가 존재하지 않습니다. --%>
    </div>
</div>
<!-- 근무 입력 현황 테이블 끝 -->

<form name="excelDownload" method="POST" target="hidden" action="${g.servlet}hris.D.D25WorkTime.D25WorkTimeLeaderDailySV"></form>

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->
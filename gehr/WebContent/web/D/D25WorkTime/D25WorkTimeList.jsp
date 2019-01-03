<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무시간 입력
/*   Program ID   : D25WorkTimeList.jsp
/*   Description  : 근무시간 입력 화면
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
    <jsp:param name="script" value="D/D25WorkTimeList-var.jsp" />
    <jsp:param name="script" value="D/D25WorkTimeList${MSSYN eq 'Y' ? 'MSS' : ''}.js" />
</jsp:include>
<%-- body 시작 선언 및 body title --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="subView" value="Y" />
</jsp:include>

<!-- 근무시간 목록 테이블 시작 -->
<div class="listArea"${MSSYN eq 'Y' ? ' style="margin-top:0"' : ''}>
    <div class="listTop"${MSSYN eq 'Y' ? ' style="display:none"' : ''}>
        <div class="buttonArea" style="margin-bottom:5px">
            <div class="commentImportant notation" style="width:255px${MSSYN eq 'Y' ? '; margin:5px 0 25px 0' : ''}">
                <p><span class="comment-title"><spring:message code="LABEL.D.D25.N7002" /> : <span data-name="T_WHEAD[2]-CH01"></span></span></p><%-- 금일 기본 근무시간 --%>
            </div>
            <ul class="btn_crud">
                <li><a class="align-middle" href="javascript:void(0)" data-name="plantimeTablePopup"><span><spring:message code="BUTTON.D.D25.N0013" /><%-- 교육/출장 계획 입력 --%></span></a></li>
                <li><a class="align-middle darken" href="javascript:void(0)" data-name="worktimeSave"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
            </ul>
        </div>
        <div class="clear"></div>
    </div>
    <div class="table scroll-table scroll-head">
        <table class="listTable">
            <colgroup>
                <col style="width:12%" />
                <col style="width:10%" />
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width: 9%" />
                <col style="width: 8%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width: 6%" />
                <col style="width: 8%" />
            </colgroup>
            <thead>
                <tr class="multi-line">
                    <th><spring:message code="LABEL.D.D25.N2121" /></th><%-- 일자                   --%>
                    <th><spring:message code="LABEL.D.D25.N2101" /></th><%-- 구분                   --%>
                    <th><spring:message code="LABEL.D.D25.N2122" /></th><%-- 업무 시작              --%>
                    <th><spring:message code="LABEL.D.D25.N2123" /></th><%-- 업무 종료              --%>
                    <th><spring:message code="LABEL.D.D25.N2124" /></th><%-- 휴게 시간(법정)        --%>
                    <th><spring:message code="LABEL.D.D25.N2125" /></th><%-- 비근무                 --%>
                    <th><spring:message code="LABEL.D.D25.N2127" /></th><%-- 업무재개               --%>
                    <th><spring:message code="LABEL.D.D25.N2128" /></th><%-- 초과근무<br />신청여부 --%>
                    <th><spring:message code="LABEL.D.D25.N2129" /></th><%-- 초과근무<br />실적입력 --%>
                    <th class="lastCol"><spring:message code="LABEL.D.D25.N2126" /></th><%-- 일 근로시간 --%>
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
                <col style="width: 9%" />
                <col style="width: 8%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width: 6%" />
                <col style="width: 8%" />
            </colgroup>
            <tbody>
                <tr class="oddRow" data-not-found>
                    <td class="lastCol" colspan="10"><spring:message code="MSG.COMMON.0004"/></td><%-- 해당하는 데이타가 존재하지 않습니다. --%>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="buttonArea"${MSSYN eq 'Y' ? ' style="display:none"' : ''}>
        <ul class="btn_crud">
            <li><a class="align-middle" href="javascript:void(0)" data-name="plantimeTablePopup"><span><spring:message code="BUTTON.D.D25.N0013" /><%-- 교육/출장 계획 입력 --%></span></a></li>
            <li><a class="align-middle darken" href="javascript:void(0)" data-name="worktimeSave"><span><spring:message code="BUTTON.COMMON.SAVE" /><%-- 저장 --%></span></a></li>
        </ul>
    </div>
</div>
<!-- 근무시간 목록 테이블 끝 -->

<div class="commentImportant"${MSSYN eq 'Y' ? ' style="display:none"' : ' style="width:100%"'}>
    <p><span class="comment-title"><spring:message code="MSG.D.D25.N0010" /></span></p><%-- 참고사항 --%>
    <%-- <spring:message code="MSG.D.D25.N0017" /></p> 프로퍼티 사용 금지!!! 변경이 될 수 있음.--%>
    <p>- 업무시작/종료 시간을 저장한 후, 비근무시간을 입력할 수 있습니다.</p>
<p>- <span class="font-bold">업무시작 시간</span> : 업무를 시작할 준비가 된 시간으로서 기본적으로 "시업시간=업무시작 시간"입니다.
  <br /><span class="indent1">상사 지시·업무 등의 사유로 조기 출근하는 경우 사전에 업무시작 시간 변경이 가능합니다.</span>
  <br /><span class="indent1">(1일 단위 Flextime 시간대 변경 필요)</span></p>
<p>- <span class="font-bold">업무종료 시간</span> : 업무 마무리를 의미하는 시간으로서 기본적으로 "종업시간=업무종료 시간"입니다.
  <br /><span class="indent1">종업시간 이후에 업무를 수행하는 경우 업무 마무리 시점에 업무종료 시간을 입력하시면 됩니다.</span></p>
<p>- <span class="font-bold">비근무시간</span> : 업무시간 내 업무와 무관하게 개인적으로 이용한 시간을 의미하며, 업무 연관성 여부는 구성원 스스로 판단하시면 됩니다.
  <br /><span class="indent2">ex. 사내시설 이용(카페·편의점·헬스장 등), 외출(병원·은행·관공서 등), 조·석식 등</span>
  <br /><span class="indent2">단, 화장실 이용 및 심리상담·건강상담 등 시간은 비근무 기준에서 제외합니다.</span>
  <br /><span class="indent2">비근무 시간이 1회 10분 이상 발생 시 시스템 입력하시면 됩니다. (일 최대 2시간 제한)</span></p>
<p>- <span class="font-bold">업무재개 시간</span> : 업무종료 이후, 긴급하게 업무를 수행해야 하는 경우 입력하실 수 있습니다.</p>
<p>- <span class="font-bold">일 근무시간</span> : 휴게 시간/비근무 시간 차감 후 업무재개를 더한 당일의 근무시간을 의미합니다.</p>
</div>

<!-- 복제용 요소 시작 -->
<div style="display:none">
<table>
    <tbody id="worktimeMSSTemplate">
        <tr data-date data-tr-class data-pernr="${param.P_PERNR}">
            <td><%-- 일자 --%>
                <div class="icon-class">#text#</div>
            </td>
            <td>#text#<%-- 구분 --%></td>
            <td>#text#<%-- 업무 시작 --%></td>
            <td>#text#<%-- 업무 종료 --%></td>
            <td>#text#<%-- 휴게 시간(법정) --%></td>
            <td><%-- 비근무시간 --%>
                <div class="align-center align-middle readonly-look">#text#</div>
                <a href="javascript:;" class="icon-popup data-pdunb data-class"><img src="${g.image}sshr/ico_magnify.png" alt="<spring:message code='BUTTON.COMMON.SEARCH' />"></a>
            </td>
            <td><%-- 업무재개시간 --%>
                <div class="align-center align-middle readonly-look">#text#</div>
                <a href="javascript:;" class="icon-popup data-arewk data-class" data-editable><img src="${g.image}sshr/ico_magnify.png" alt="<spring:message code='BUTTON.COMMON.SEARCH' />"></a>
            </td>
            <td>#text#<%-- 초과근무 신청여부 --%></td>
            <td class="btn_crud">#anchor#<%-- 초과근무 실적입력 --%></td>
            <td class="lastCol">#text#<%-- 일 근로시간 --%></td>
        </tr>
    </tbody>
</table>
<table>
    <tbody id="worktimeTemplate">
        <tr data-date data-tr-class>
            <td><%-- 일자 --%>
                <div class="icon icon-class">#text#</div>
            </td>
            <td><%-- 구분 --%>
                <select name="WKTYP" style="width:90px" data-disabled>#type-options#</select>
            </td>
            <td><%-- 업무 시작 --%><%-- LABEL.COMMON.0038 시 LABEL.COMMON.0039 분 --%>
                <div style="min-width:105px">
                    <select name="BEGUZ-hour" class="time" data-beguzhh data-sobeghh data-disabled>#hh-options#</select>
                    <label>:</label>
                    <select name="BEGUZ-minute" class="time" data-beguzmm data-sobegmm data-disabled>#mm-options#</select>
                </div>
            </td>
            <td><%-- 업무 종료 --%>
                <div style="min-width:105px">
                    <select name="ENDUZ-hour" class="time" data-enduzhh data-soendhh data-disabled>#hh-options#</select>
                    <label>:</label>
                    <select name="ENDUZ-minute" class="time" data-enduzmm data-soendmm data-disabled>#mm-options#</select>
                </div>
            </td>
            <td><%-- 휴게 시간(법정) --%>
                #text#
            </td>
            <td><%-- 비근무시간 --%>
                <input type="text" name="PDUNB" class="align-center" readonly="readonly" data-value />
                <a href="javascript:;" class="icon-popup data-pdunb data-class" data-pdunb-editable><img src="${g.image}sshr/ico_magnify.png" alt="<spring:message code='BUTTON.COMMON.SEARCH' />"></a>
            </td>
            <td><%-- 업무재개시간 --%>
                <input type="text" name="AREWK" class="align-center" readonly="readonly" data-value />
                <a href="javascript:;" class="icon-popup data-arewk data-class" data-arewk-editable><img src="${g.image}sshr/ico_magnify.png" alt="<spring:message code='BUTTON.COMMON.SEARCH' />"></a>
            </td>
            <td><%-- 초과근무 신청여부 --%>
                #text#
            </td>
            <td class="btn_crud"><%-- 초과근무 실적입력 --%>
                #anchor#
            </td>
            <td class="lastCol"><%-- 일 근로시간 --%>
                #text#
            </td>
        </tr>
    </tbody>
</table>
</div>
<!-- 복제용 요소 종료 -->

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->
<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 근무 입력 현황
/*   Program ID   : D25WorkTimeLeaderFrame.jsp
/*   Description  : 근무 입력 현황 frame
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
    <jsp:param name="script" value="jquery-ext-logger.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
    <jsp:param name="script" value="D/D25WorkTimeLeaderFrame-var.jsp" />
    <jsp:param name="script" value="D/D25WorkTimeLeaderFrame.js" />
</jsp:include>
<%-- body 시작 선언 및 body title --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D25.N1009" />
</jsp:include>
<form id="urlForm" name="urlForm" target="listFrame" method="POST">
    <input type="hidden" name="unblock" value="false" />
    <input type="hidden" name="subView" value="Y" />
</form>
<div class="contentBody" style="min-width:1185px">
    <div class="tableInquiry">
        <table>
            <colgroup>
                <col style="width: 70px" />
                <col style="width:220px" />
                <col style="width:110px" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th>
                        <img class="searchTitle" src="${g.image}sshr/top_box_search.gif" />
                    </th>
                    <th>
                        <label class="bold"><spring:message code="LABEL.COMMON.0054" /></label><%-- 기준년월 --%>
                        <select name="year"></select><label><spring:message code="LABEL.D.D25.N2141" /></label><%-- 년 --%>
                        <select name="month" style="margin-left:2px"></select><label><spring:message code="LABEL.D.D25.N2143" /></label><%-- 월 --%>
                    </th>
                    <th class="divider">
                        <div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Org" checked="checked" /> <spring:message code="LABEL.D.D25.N7004" /><%-- 부서검색 --%></label></div>
                        <div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Emp" /> <spring:message code="LABEL.D.D25.N7005" /><%-- 사원검색 --%></label></div>
                    </th>
                    <th class="align-left" style="padding-left:10px">
                        <div data-name="searchOrgWrapper">
                            <form name="searchOrg" method="POST" onsubmit="return false">
                                <div>
                                    <select name="I_GBN">
                                        <option value="ORGEH"><spring:message code="LABEL.D.D25.N7006" /></option><%-- 부서명 --%>
                                        <option value="PERNR"><spring:message code="LABEL.D.D25.N7007" /></option><%-- 사원명 --%>
                                    </select>
                                    <input type="hidden" name="DEPTID" data-init="${user.e_objid}" />
                                    <input type="text" name="I_VALUE1"   maxlength="10" onfocus="this.select()" data-follow="PERNR" style="width:200px; ime-mode:active; display:none" />
                                    <input type="text" name="txt_deptNm" maxlength="10" onfocus="this.select()" data-follow="ORGEH" style="width:200px; ime-mode:active" data-init="${user.e_obtxt}" />
                                    <div class="tableBtnSearch"><a class="search" href="javascript:;" data-name="searchOrg"><span><spring:message code="LABEL.SEARCH.DEPT" /></span></a></div><%-- 부서검색 --%>
                                </div>
                                <div class="divider" style="margin-left:10px; padding-left:10px">
                                    <img class="searchIcon" src="${g.image}sshr/icon_map_g.gif" />
                                    <label><spring:message code="LABEL.D.D25.N7008" /> <input type="checkbox" name="includeSubOrg" value="Y" /></label><%-- 하위조직포함 --%>
                                    <div class="tableBtnSearch"><a class="search" href="javascript:;" data-name="searchOrgInTree"><span><spring:message code="LABEL.SEARCH.ORGEH" /></span></a></div><%-- 조직도로 부서찾기 --%>
                                </div>
                            </form>
                        </div>
                        <div data-name="searchEmpWrapper" style="display:none">
                            <form name="searchEmp" method="POST" onsubmit="return false">
                                <div>
                                    <label><spring:message code="LABEL.COMMON.0012" /> <input type="checkbox" name="retir_chk" value="X" /></label><%-- 퇴직자조회 --%>
                                </div>
                                <div style="margin-left:15px">
                                    <select name="jobid">
                                        <option value="ename"><spring:message code="LABEL.COMMON.0004" /></option><%-- 성명별 --%>
                                        <option value="pernr"><spring:message code="LABEL.COMMON.0005" /></option><%-- 사번별 --%>
                                    </select>
                                    <input type="hidden" name="PERNR" />
                                    <input type="text" name="I_VALUE1" maxlength="10" onfocus="this.select()" style="width:103px; ime-mode:active" />
                                    <div class="tableBtnSearch"><a class="search" href="javascript:;" data-name="searchEmp"><span><spring:message code="LABEL.SEARCH.PERSON" /></span></a></div><%-- 사원검색 --%>
                                </div>
                            </form>
                        </div>
                    </th>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="searchOrg_ment align-right"><spring:message code="MSG.COMMON.0078" /></div><%-- * 하위조직포함을 선택하면 하위조직까지 조회됩니다. --%>
    <!-- Tab 시작 -->
    <div class="tabArea" style="margin-top:16px">
        <ul class="tab">
           	<li><a href="javascript:;" onclick="tabMove(this, 0)"><spring:message code="TAB.COMMON.0121" /></a></li><%-- 월별 --%>
           	<li><a href="javascript:;" onclick="tabMove(this, 1)"><spring:message code="TAB.COMMON.0122" /></a></li><%-- 주별 --%>
           	<li><a href="javascript:;" onclick="tabMove(this, 2)"><spring:message code="TAB.COMMON.0123" /></a></li><%-- 일별 --%>
            <li style="float:right; margin-right:0">
                <button type="button" class="download-guide" id="guideDownload"><spring:message code="BUTTON.D.D25.N0003" /></button><%-- 제도 운영 기준 가이드 --%>
                <button type="button" class="download-guide" id="faqDownload"><spring:message code="BUTTON.D.D25.N0005" /></button><%-- FAQ --%>
            </li>
        </ul>
    </div>

    <div class="frameWrapper">
        <!-- Tab 프레임 -->
        <iframe id="listFrame" name="listFrame" onload="autoResize()" frameborder="0" style="min-width:1185px"></iframe>
    </div>
</div>
<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->
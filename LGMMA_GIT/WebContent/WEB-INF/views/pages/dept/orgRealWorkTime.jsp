<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link type="text/css" rel="stylesheet" href="/web-resource/js/jQuery/dynatree/ui.fancytree.min.css" />

<c:if test="${param.FROM_ESS_OFW_WORK_TIME ne 'Y'}"><%-- 근무시간입력 메뉴에서 popup으로 호출된 경우 Page title 영역은 숨김 --%>
<!-- Page title start -->
<div class="title">
    <h1>근무 입력현황</h1>
    <div class="titleRight">
        <ul class="pageLocation">
            <li><span><a href="#">Home</a></span></li>
            <li><span><a href="#">조직관리</a></span></li>
            <li><span><a href="#">부서 인사정보</a></span></li>
            <li class="lastLocation"><span><a href="#">근무 입력현황</a></span></li>
        </ul>
    </div>
</div>
<!--// Page title end -->
</c:if>

<div class="tableInquiry">
    <table class="worktime">
        <colgroup>
            <col style="width: 70px" />
            <col style="width:220px" />
            <col style="width:110px" />
            <col />
        </colgroup>
        <tbody>
            <tr>
                <th><img class="searchTitle" src="/web-resource/images/top_box_search.gif" /></th>
                <th><label class="bold">기준년월</label>
                    <select name="year" style="width:55px"></select><label>년</label>
                    <select name="month" style="width:40px"></select><label>월</label>
                </th>
                <th class="divider">
                    <div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Org" checked="checked" /> 부서검색</label></div>
                    <div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Emp" /> 사원검색</label></div>
                </th>
                <th class="align-left">
                    <div data-name="searchOrgWrapper">
                        <form name="searchOrg" method="POST" onsubmit="return false">
                            <div>
                                <input type="hidden" name="DEPTID" data-init="${user.e_orgeh}" />
                                <input type="text" name="txt_deptNm" onfocus="this.select()" data-follow="ORGEH" style="width:185px; ime-mode:active" data-init="${user.e_orgtx}" />
                                <div class="tableBtnSearch"><a class="search" href="#" data-name="searchOrg"><span class="icon-magnify"></span><span>부서검색</span></a></div>
                            </div>
                            <div class="divider">
                                <img class="searchIcon" src="/web-resource/images/icon_map_g.gif" />
                                <label>하위조직포함 <input type="checkbox" name="includeSubOrg" value="Y" /></label>
                                <div class="tableBtnSearch"><a class="search" href="#" data-name="searchOrgInTree"><span class="icon-magnify"></span><span>조직도로 부서찾기</span></a></div>
                            </div>
                        </form>
                    </div>
                    <div data-name="searchEmpWrapper" style="display:none">
                        <form name="searchEmp" method="POST" onsubmit="return false">
                            <div>
                                <label>퇴직자조회 <input type="checkbox" name="retir_chk" value="X" /></label>
                            </div>
                            <div style="margin-left:15px">
                                <select name="jobid" style="width:80px">
                                    <option value="ename">성명별</option>
                                    <option value="pernr">사번별</option>
                                </select>
                                <input type="hidden" name="PERNR" />
                                <input type="text" name="I_VALUE1" maxlength="10" onfocus="this.select()" style="width:185px; ime-mode:active" />
                                <div class="tableBtnSearch"><a class="search" href="#" data-name="searchEmp"><span class="icon-magnify"></span><span>사원검색</span></a></div>
                            </div>
                        </form>
                    </div>
                </th>
            </tr>
        </tbody>
    </table>
</div>
<div class="tableComment data-org" style="margin:-35px 0 30px 0">
    <p class="float-right"><span class="bold">하위조직포함을 선택하면 하위조직까지 조회됩니다.</span></p>
</div>

<!-- Tab start -->
<div class="tabArea">
    <ul class="tab">
       	<li><a href="#" id="monthlyTab" data-excel-id="M" class="selected">월별</a></li>
       	<li><a href="#" id="weeklyTab" data-excel-id="W">주별</a></li>
       	<li><a href="#" id="dailyTab" data-excel-id="D">일별</a></li>
        <li style="float:right; margin-top:2px; margin-right:0">
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:downloadPdfReader()"><span>PDF 뷰어 다운로드</span></a></li>
                    <li><a href="/download/worktimeForm/guide.pdf" target="_blank"><span>제도 운영 기준 가이드</span></a></li>
                    <li><a href="/download/worktimeForm/faq.pdf" target="_blank"><span>FAQ</span></a></li>
                </ul>
            </div>
        </li>
    </ul>
</div>
<!--// Tab end -->

<!-- 월별 tab start -->
<div class="tabUnder monthlyTab">
<%@ include file="include/orgRealWorkTimeMonthly.jsp" %>
</div>
<!--// 월별 tab end -->

<!-- 주별 tab start -->
<div class="tabUnder weeklyTab Lnodisplay">
<%@ include file="include/orgRealWorkTimeWeekly.jsp" %>
</div>
<!--// 주별 tab end -->

<!-- 일별 tab start -->
<div class="tabUnder dailyTab Lnodisplay">
<%@ include file="include/orgRealWorkTimeDaily.jsp" %>
</div>
<!--// 일별 tab end -->

<!-- popup : 근무시간입력 start -->
<div class="layerWrapper" id="modalDialog" style="width:1130px;height:750px;display:none;">
    <div class="layerHeader">
        <strong></strong>
        <a href="#" class="btnClose modalDialog_close">창닫기</a>
    </div>
    <iframe src="about:blank" frameborder="0" style="width:1100px;height:660px;padding:16px"></iframe>
</div>
<!--// popup : 근무시간입력 end -->

<!-- 부서검색, 사원검색, 조직도검색 영역 팝업 -->
<%@ include file="include/searchPopupLayers.jsp" %>
<!--// 부서검색, 사원검색, 조직도검색 영역 팝업 -->

<form name="excelDownload" method="POST" target="excelFrame" action="/excel/orgRealWorkTimeExcel"></form>
<iframe name="excelFrame" src="about:blank" frameborder="0" style="margin:0;width:0;height:0;border:0;padding:0;display:none"></iframe>

<%@ include file="include/orgRealWorkTimeJS.jsp" %>
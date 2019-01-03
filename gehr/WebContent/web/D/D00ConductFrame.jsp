<%
/******************************************************************************/
/*                                                                            */
/*   System Name  : ESS                                                       */
/*   1Depth Name  : MY HR                                                     */
/*   2Depth Name  : 휴가/근태                                                 */
/*   Program Name : 근태                                                      */
/*   Program ID   : D00ConductFrame.jsp                                       */
/*   Description  : 근태 사항을 조회 및 신청                                  */
/*   Note         :                                                           */
/*   Creation     :                                                           */
/*   Update       : 2017-11-06  eunha  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 */
/*                : 2018-05-24  성환희 [WorkTime52] 실 근로시간 레포트 탭 추가 */
/*                : 2018-06-12  강동민 [WorkTime52] 초과근로 사후신청 탭 추가 */
/*                : 2018-06-25  성환희 [WorkTime52] 실 근무시간 레포트 탭 권한처리 */
/*                : 2018-07-24  유정우 [WorkTime52] 보상휴가 발생내역 탭 추가 */
/*                                                                            */
/******************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.common.constant.Area" %>
<%@ page import="hris.D.D19Duty.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    String check_B01 = (String) request.getAttribute("check_B01");
    String check_B04 = (String) request.getAttribute("check_B04");
    String check_B05 = (String) request.getAttribute("check_B05");
    String check_B06 = (String) request.getAttribute("check_B06");

    Vector s_vt = (Vector) request.getAttribute("s_vt");
%>
<jsp:include page="/include/header.jsp" />
<script type="text/javascript">
$(function() {
    blockFrame();
    $('.tab a${empty param.TABID ? ":first" : fn:replace("[data-name=\"TAB-#\"]", "#", param.TABID)}').addClass('selected').click();
});

function tabMove(target, urlName) {
    $(".tab").find(".selected").removeClass("selected");
    $(target).addClass("selected");

    document.all.urlForm.action = urlName;
    document.all.urlForm.submit();
}

function resizeIframe(height) {
   document.all.listFrame.height = height;
}

function autoResize(target) {
      target.height = 0;
      var iframeHeight = target.contentWindow.document.body.scrollHeight;
      target.height = iframeHeight;
}
</script>

<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PT_STAT_APPL"/>
</jsp:include>

<form id="urlForm" name="urlForm" target="listFrame" method="post">
<input type="hidden" name="subView" value="Y" /><c:if test="${!empty param.FROM_ESS_OFW_WORK_TIME}"><%-- [WorkTime52] 근무 시간 입력 화면에서 popup으로 들어온 경우 결재신청 후 popup을 닫기 위한 flag --%>
<input type="hidden" name="FROM_ESS_OFW_WORK_TIME" value="${param.FROM_ESS_OFW_WORK_TIME}" /></c:if>
<div class="contentBody">
    <!-- Tab 시작 -->
    <div class="tabArea">
        <ul class="tab">
<% if (user.area == Area.KR) { %>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.jsp}common/wait.jsp?url=${g.servlet}hris.D.D01OT.D01OTBuildSV');" data-name="TAB-OTBF"${empty param.TABID or param.TABID eq 'OTBF' ? ' class="selected"' : ''}><!-- 초과근무신청 --><spring:message code="TAB.COMMON.0035" /></a></li>
<% } else if (user.area != Area.PL && user.area != Area.TH ) { %>
            <%-- 2017.11.06  eunha  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 TH추가 --%>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.jsp}common/wait.jsp?url=${g.servlet}hris.D.D01OT.D01OTBuildGlobalSV');" data-name="TAB-OTBF"${empty param.TABID or param.TABID eq 'OTBF' ? ' class="selected"' : ''}><!-- 초과근무신청 --><spring:message code="TAB.COMMON.0035" /></a></li>
<% } %>
<% if ("Y".equals(check_B05)) { %>
            <%-- WorkTime52 사후근로 신청 신규 --%>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.jsp}common/wait.jsp?url=${g.servlet}hris.D.D01OT.D01OTAfterWorkBuildSV');" data-name="TAB-OTAF"${param.TABID eq 'OTAF' ? ' class="selected"' : ''}><!-- 사후근무신청 --><spring:message code="TAB.COMMON.0125" /></a></li>
<% } %>
<% if ("Y".equals(check_B01)) { %>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.servlet}hris.D.D19EduTrip.D19EduTripBuildSV');" data-name="TAB-EDTR"${param.TABID eq 'EDTR' ? ' class="selected"' : ''}><!-- 교육/출장 신청 --><spring:message code="TAB.COMMON.0036" /></a></li>
<% } %>
<% if (user.area == Area.CN && s_vt != null) { %>
<%     if ("G110".equals(user.companyCode) || "G170".equals(user.companyCode) || "G130".equals(user.companyCode) || "G280".equals(user.companyCode) || "G370".equals(user.companyCode)) { %>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.servlet}hris.D.D19Duty.D19DutyBuildSV');"><!-- 직반 신청 --><spring:message code="TAB.COMMON.0037" /></a></li>
<%     } %>
<% } %>
<% if (user.area == Area.KR) { %>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.servlet}hris.D.D02ConductListSV');"><!-- 근태실적정보 --><spring:message code="TAB.COMMON.0038" /></a></li>
<% } else { %>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.servlet}hris.D.Global.D02ConductListSV');"><!-- 근태실적정보 --><spring:message code="TAB.COMMON.0038" /></a></li>
<% } %>
<% if ("Y".equals(check_B04)) { %>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.servlet}hris.D.D25WorkTime.D25WorkTimeReportSV');"><!-- 실 근무시간 레포트 --><spring:message code="TAB.COMMON.0124" /></a></li>
<% } %>
<% if ("Y".equals(check_B06)) { %>
            <li><a href="javascript:;" onclick="tabMove(this, '${g.servlet}hris.D.D03Vocation.D03CompTimeListSV');"><!-- 보상휴가 발생내역 --><spring:message code="TAB.COMMON.0126" /></a></li>
<% } %>
        </ul>
    </div>
    <!-- Tab 종료 -->
</div>
</form>
<div class="frameWrapper">
    <!-- Tab 프레임  -->
    <iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" ></iframe>
</div>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
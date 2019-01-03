<%
	/******************************************************************************/
	/*   System Name  : ESS                                                         													*/
	/*   1Depth Name  : MY HR 정보                                                  															*/
	/*   2Depth Name  : 휴가/근태                                                        														*/
	/*   Program Name : Flextime                                                   													*/
	/*   Program ID   :D00FlextimeFrame.jsp                                        												*/
	/*   Description  : Flextime frame                                        														*/
	/*   Note         :                                                             															*/
	/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청                                       */
	/*   Update       : 2017-11-08  eunha    [CSR ID:3525213] Flextime 시스템 변경 요청								*/
	/******************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
%>

    <jsp:include page="/include/header.jsp" />

    <!-- body header 부 title 및 body 시작 부 선언 -->
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.ESS_PT_FLEXTIME"/>
    </jsp:include>


<script type="text/javascript">

    $(function() {
        $(".tab").find("a:first").trigger("click").addClass("selected");
    });

    function tabMove(target, urlName) {
        $(".tab").find(".selected").removeClass("selected");
        $(target).addClass("selected");

        document.all.urlForm.action = urlName;
        document.all.urlForm.submit();
    }

    function autoResize(target) {
   	 target.height = 0;
        var iframeHeight =  target.contentWindow.document.body.scrollHeight;
        target.height = iframeHeight + 70;
    }

    function resizeIframe(height) {
        document.all.listFrame.height = height + 50;
 	}
</script>


<form id="urlForm" name="urlForm" target="listFrame" method="post">
    <input type="hidden" name="subView" value="Y" /><c:if test="${!empty param.FROM_ESS_OFW_WORK_TIME}"><%-- [WorkTime52] 근무 시간 입력 화면에서 popup으로 들어온 경우 결재신청 후 popup을 닫기 위한 flag --%>
    <input type="hidden" name="FROM_ESS_OFW_WORK_TIME" value="${param.FROM_ESS_OFW_WORK_TIME}" /></c:if>
</form>

<div class="contentBody">
    <!-- 탭 시작 -->
    <div class="tabArea">
        <ul class="tab">
           	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D20Flextime.D20FlextimeBuildSV');" ><%=g.getMessage("TAB.COMMON.0117")%></a></li>
           	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.D.D20Flextime.D20FlextimeListSV');" class="selected"><%=g.getMessage("TAB.COMMON.0118")%></a></li>
        </ul>
    </div>

    <div class="frameWrapper">
        <!-- TAB 프레임  -->
        <iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" scrolling="auto" frameborder=0></iframe>
    </div>

</div>
    <jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
    <jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

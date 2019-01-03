<%/******************************************************************************/
/*                                                                              																*/
/*   System Name  : ESS                                                																*/
/*   1Depth Name  : My HR                                              																*/
/*   2Depth Name  : 복리후생                                                           															*/
/*   Program Name :건강보험                                                               															*/
/*   Program ID   : E19CongraFrame.jsp                                															 */
/*   Description  : 건강보험 신청/조회                                        																     */
/*   Note         :                                                             																 */
/*   Creation     :                                                            																 */
/*   Update       :                                           																				 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
	WebUserData user_m = WebUtil.getSessionMSSUser(request);
%>
<jsp:include page="/include/header.jsp" />

<script type="text/javascript">
<!--
$(function() {
        $(".tab").find("a:first").trigger("click").addClass("selected");
    });

function tabMove(target, urlName) {
    $(".tab").find(".selected").removeClass("selected");
    $(target).addClass("selected");

    document.all.urlForm.action = urlName;
    document.all.urlForm.submit();
}

function resizeIframe(height) {
	document.all.listFrame.height = height + 20;
}

  //-->

</script>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.ESS_BE_HEAL_INSUR"/>
    </jsp:include>
<form name="urlForm" method="post" target="listFrame" method="post">
     <input type="hidden" name="subView" value="Y">

	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                <li><a href="javascript:;"  onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.E01Medicare.E01MedicareBuildSV');"  class="selected"><!-- 피부양자 등재신청 --><%=g.getMessage("TAB.COMMON.0051")%></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E02Medicare.E02MedicareBuildSV');"><!-- 건강보험증 발급 신청 --><%=g.getMessage("TAB.COMMON.0052")%></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E30HealthInsurance.E30HealthInsuranceSV');"><!-- 조회 --><%=g.getMessage("TAB.COMMON.0042")%></a></li>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" width="100%" height="" marginwidth="0" marginheight="0" frameborder="0" scrolling="no" ></iframe>
	    </div>
 </form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

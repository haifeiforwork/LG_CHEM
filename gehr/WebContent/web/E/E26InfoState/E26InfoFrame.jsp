<%/******************************************************************************/
/*                                                                              																*/
/*   System Name  : ESS                                                																*/
/*   1Depth Name  : My HR                                              																*/
/*   2Depth Name  : 복리후생                                                           															*/
/*   Program Name :추가 암 검진                                                             															*/
/*   Program ID   : E26InfoFrame.jsp                          															 */
/*   Description  : 동호회 가입현황                                        																     */
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
/*function autoResize(target) {
	 target.height = 0;
    var iframeHeight =  target.contentWindow.document.body.scrollHeight;
    target.height = iframeHeight + 80;
}*/

function resizeIframe(height) {
document.all.listFrame.height = height + 20;
}
  //-->
</script>
    <jsp:include page="/include/body-header.jsp">
      <jsp:param name="title" value="COMMON.MENU.ESS_BE_INFOMAL_STAT"/>
    </jsp:include>

<form name="urlForm" method="post" target="listFrame" method="post">
     <input type="hidden" name="subView" value="Y">
 </form>
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.E25Infojoin.E25InfoBuildSV');" class="selected"><!-- 가입 신청--><%=g.getMessage("TAB.COMMON.0054")%></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E26InfoState.E26InfoStateSV');" ><!-- 조회, 탈퇴 신청--><%=g.getMessage("TAB.COMMON.0055")%></a></li>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame"  width="100%" height="" marginwidth="0" marginheight="0" frameborder=0 ></iframe>
	    </div>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

<%/******************************************************************************/
/*                                                                              																*/
/*   System Name  : ESS                                                																*/
/*   1Depth Name  : My HR                                              																*/
/*   2Depth Name  : 복리후생                                                           															*/
/*   Program Name :경조금                                                               															*/
/*   Program ID   : E19CongraFrame.jsp                                															 */
/*   Description  : 복리후생 사항을 조회                                          																 */
/*   Note         :                                                             																 */
/*   Creation     :                                                            																 */
/*   Update       :    [CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건     20170802 eunha                           */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%
    WebUserData user = WebUtil.getSessionUser(request);
	WebUserData user_m = WebUtil.getSessionMSSUser(request);
	String   RequestPageName     = (String)request.getAttribute("RequestPageName"); //보상명세서 호출여부체크
	String   isFlower    = (String)request.getAttribute("isFlower"); 	//[CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건
%>
<jsp:include page="/include/header.jsp" />

<script type="text/javascript">

$(function() {
	//[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건
	$("<%=StringUtils.isEmpty(RequestPageName) && user.area != Area.TH ? "#tab_1" : "#tab_2"%>").trigger("click").addClass("selected");

});

function tabMove(target, urlName) {
    $(".tab").find(".selected").removeClass("selected");
    $(target).addClass("selected");

    document.all.urlForm.action = urlName;
    document.all.urlForm.submit();
}

    function resizeIframe(height) {
        document.all.listFrame.height = height + 50;

 	}
 function autoResize(target) {
	 target.height = 0;
     var iframeHeight =  target.contentWindow.document.body.scrollHeight;
     target.height = iframeHeight + 50;
 }
</script>

<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_BE_CONG_${isFlower eq 'Y' ? 'FLOWER' : 'COND'}"/>
</jsp:include>
<form name="urlForm" method="post" target="listFrame" method="post">
     <input type="hidden" name="subView" value="Y">
     <input type="hidden" name="RequestPageName" value="<%=RequestPageName %>">
 </form>
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                <%	if(user.area == Area.KR) { %>
	               	    <%	if(isFlower.equals("N")) { //[CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건 start%>
	                        <li><a id="tab_1" href="javascript:;"  onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.E19Congra.E19CongraBuildSV');" class="selected"><!-- 신청 --><%=g.getMessage("TAB.COMMON.0041")%></a></li>
	                    <%} else{ %>
	                		<li><a id="tab_1" href="javascript:;"  onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.E19Congra.E19CongraFlowerBuildSV');" class="selected"><!-- 신청 --><%=g.getMessage("TAB.COMMON.0041")%></a></li>
	                    <%} //[CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건 end%>
	                <%} else if (user.area != Area.TH){ //[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 %>
	                <li><a id="tab_1" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.E19Congra.E19CongraBuildGlobalSV');" class="selected"><!-- 신청 --><%=g.getMessage("TAB.COMMON.0041")%></a></li>
	                <%} %>
	                <li><a id="tab_2" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E20Congra.E20CongraListSV');"><!-- 조회 --><%=g.getMessage("TAB.COMMON.0042")%></a></li>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame"  width="100%" height="" marginwidth="0" marginheight="0" frameborder="0" scrolling="no" ></iframe>
	    </div>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

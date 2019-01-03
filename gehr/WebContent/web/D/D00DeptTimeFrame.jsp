<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 부서근태입력                                                */
/*   Program ID   : D00DeptTimeFrame.jsp                                     */
/*   Description  : 부서근태입력                                              */
/*   Note         :                                                             */
/*   Creation     :                                           */
/*   Update       :                                           */
/*                  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
	String sMenuCode =  (String)request.getAttribute("sMenuCode");

%>
<jsp:include page="/include/header.jsp" />
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

    function resizeIframe(height) {
        document.all.listFrame.height = height + 20;
 	}
</script>


 <jsp:include page="/include/body-header.jsp">
       <jsp:param name="title" value="COMMON.MENU.ESS_HRA_TIME_MAIN"/>
 </jsp:include>
<form id="urlForm" name="urlForm" target="listFrame" method="post">
    <input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">
</form>
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                 <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationSV');" class="selected"><!-- 일 근태관리 --><spring:message code="TAB.COMMON.0046"/></a></li>
		          <%	if(user.area == Area.CN ) { %>
		             <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationBuildCnSV');"><!-- 초과근무 등록 --><spring:message code="TAB.COMMON.0047"/></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.D.D12Rotation.D12RotationBuildDetailCnSV');"><!-- 초과근무 조회 --><spring:message code="TAB.COMMON.0048"/></a></li>
	               <%} %>

	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" width="100%" height="100%" marginwidth="0" marginheight="0" scrolling="no" frameborder=0></iframe>
	    </div>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

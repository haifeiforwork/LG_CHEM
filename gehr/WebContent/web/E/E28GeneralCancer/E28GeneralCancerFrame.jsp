<%/******************************************************************************/
/*                                                                              																*/
/*   System Name  : ESS                                                																*/
/*   1Depth Name  : My HR                                              																*/
/*   2Depth Name  : 복리후생                                                           															*/
/*   Program Name :추가 암 검진                                                             															*/
/*   Program ID   : E28GeneralFrame.jsp                           															 */
/*   Description  : 추가 암 검진 신청/조회                                        																     */
/*   Note         :                                                             																 */
/*   Creation     :                                                            																 */
/*   Update       :   2018-03-09 cykim [CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건		 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
	WebUserData user_m = WebUtil.getSessionMSSUser(request);

	//[CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건 start
	String   check_B02     = (String)request.getAttribute("check_B02"); //종합검진(이월) tab체크
	//[CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건 end
%>
<jsp:include page="/include/header.jsp" />

<script type="text/javascript">
<!--
$(function() {
        $(".tab").find("a:first").trigger("click").addClass("selected");

      	//[CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건 start
        if("<%=check_B02%>" == "Y"){
        	$("#tab_2").find(".selected").removeClass("selected");
        	$("#tab_1").addClass("selected");
        }else{
        	$("#tab_1").find(".selected").removeClass("selected");
        	$("#tab_2").trigger("click").addClass("selected");
        }
        //[CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건 end
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
   target.height = iframeHeight + 80;
}
  //-->
</script>
 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.ESS_BE_ADDI_CHECK"/>
 </jsp:include>
<form name="urlForm" method="post" target="listFrame" method="post">
     <input type="hidden" name="subView" value="Y">
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	            	<!-- [CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건 start -->
	            	<%	if("Y".equals(check_B02)) { %>
	                <li><a id="tab_1" href="javascript:;"  onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.E38Cancer.E38CancerListSV');" class="selected"><!-- 신청 --><%=g.getMessage("TAB.COMMON.0041")%> </a></li>
	                <%} %>
	                <!-- [CSR ID:3624548] e-HR 종합검진 신청화면 비활성화 요청의 건 end -->
	                <li><a id="tab_2" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E28General.E28GeneralCancerListSV');" ><!-- 조회 --><%=g.getMessage("TAB.COMMON.0042")%> </a></li>
	            </ul>
	        </div>
	    </div>
	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" frameborder="0"  scrolling="no" ></iframe>
	    </div>
 </form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

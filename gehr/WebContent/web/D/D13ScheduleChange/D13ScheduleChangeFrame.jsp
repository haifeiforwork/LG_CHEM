<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 부서근태입력                                                */
/*   Program ID   : D00DeptTimeFrame.jsp                                     */
/*   Description  : 일일근무일정변경 텝                                              */
/*   Note         :                                                             */
/*   Creation     :                                           */
/*   Update       :                                           */
/*                  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<jsp:include page="/web/common/includeLocation.jsp" />


<%
    WebUserData user = WebUtil.getSessionUser(request);
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
%>

<c:set var="is_kr_user" value='<%=(user.area==Area.KR)%>'/> 
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
-->
</script>
        
 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.ESS_HRA_DAIL_SCHE"/>
 </jsp:include>
        
    <form id="urlForm" name="urlForm" target="listFrame" method="post">
    	<input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">
    </form>
    
    <%-- 탭 영역 --%>
    <div class="contentBody">
        <!-- 탭 시작 -->
        <div class="tabArea">
            <ul class="tab">
            	<c:choose>
            	<c:when test='${is_kr_user}'>
	                <li><a href="javascript:;"  onclick="tabMove(this, '/servlet/servlet.hris.D.D13ScheduleChange.D13ScheduleChangeSV')" class="selected"><spring:message code="LABEL.D.D13.0013" /><%--등록--%></a></li>
                </c:when>
                <c:otherwise>
	                <li><a href="javascript:;"  onclick="tabMove(this, '/servlet/servlet.hris.D.D13ScheduleChange.D13ScheduleChangeSV')" ><spring:message code="LABEL.D.D13.0013" /><%--등록--%></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this, '/servlet/servlet.hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN')"><spring:message code="LABEL.D.D13.0012" /><%--조회--%></a></li>
                </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div> 

    <div class="frameWrapper">
        <!-- TAB 프레임  -->
        <iframe id="listFrame"  name="listFrame" width="100%" height="" marginwidth="0" marginheight="0" scrolling="no" frameborder=0></iframe>
    </div>
<iframe name="ifHidden" width="0" height="0" />
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

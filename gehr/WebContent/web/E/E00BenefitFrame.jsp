<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 복리후생                                                        */
/*   Program Name :근태                                                               */
/*   Program ID   : D00TimeFrame.jsp                                  */
/*   Description  : 복리후생 사항을 조회                                          */
/*   Note         :                                                             */
/*   Creation     :                                                            */
/*   Update       :                                           */
/*                  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%
    WebUserData user = WebUtil.getSessionUser(request);
	WebUserData user_m = WebUtil.getSessionMSSUser(request);
	String   check_B03     = (String)request.getAttribute("check_B03"); //의료비 tab체크
	String   RequestPageName     = (String)request.getAttribute("RequestPageName"); //보상명세서 호출여부체크
	String   tabid     = "#"+(String)request.getAttribute("tabid"); //보상명세서 호출여부체크

%>
<jsp:include page="/include/header.jsp" />
<script type="text/javascript">
<!--
$(function() {
	<% if (StringUtils.isEmpty(RequestPageName)){%>
		 $(".tab").find("a:first").trigger("click").addClass("selected");
	<%}else {	%>
		 $("<%=tabid%>").trigger("click").addClass("selected");
	 <%}%>

    });



 function tabMove(target, urlName) {
    	frm = document.all.form1;
    	frm.urlName.value = urlName;
        $(".tab").find(".selected").removeClass("selected");
        $(target).addClass("selected");
        frm.action = urlName;
        frm.target="listFrame";
        frm.submit();
    }


 function  doSearchDetail() {
     frm = document.all.form1;
     if(window.frames['listFrame']) {
         var urlName = frm.urlName.value;
         frm.method = "post";
         frm.target = "listFrame";
         $("#listFrame").attr("src", urlName);
     } else {
         frm.action = "";
         frm.target = "";
         frm.submit();
	 }
 }
  //-->

 function autoResize(target) {
	 target.height = 0;
     var iframeHeight =  target.contentWindow.document.body.scrollHeight;
     target.height = iframeHeight + 50;
 }

 function resizeIframe(height) {
     document.all.listFrame.height = height + 50;
	}
</script>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="title" value="COMMON.MENU.ESS_BE_BENE"/>
    </jsp:include>

<form name="form1" method="post" target="listFrame" method="post">
     <%--<input type="hidden" name="subView" value="Y">--%>
     <input type="hidden" name="urlName" value="">
     <input type="hidden" name="RequestPageName" value="<%=RequestPageName %>">
     <input type="hidden" name="tabid" value="<%=tabid %>">

    <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>

   </form>
<% if("X".equals(user_m.e_mss)) { %>
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	            <%	if(g.getSapType().isLocal()) { %>
	                <li><a style="padding: 0 5px;" id="tab_1" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E09House.E09HouseListSV_m');" class="selected"><!--  주택자금--><%=g.getMessage("TAB.COMMON.0060")%></a></li>
	                <%	if(user.e_authorization.indexOf("M")>-1||"Y".equals(check_B03)) { %>
	                	<li><a style="padding: 0 5px;"  id="tab_2" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E18Hospital.E18HospitalListSV_m');"><!-- 의료비 --><%=g.getMessage("TAB.COMMON.0021")%></a></li>
	             	<%} %>
	            <%} %>
                	<li><a style="padding: 0 5px;" id="tab_3" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E20Congra.E20CongraListSV_m');"><!-- 경조금 --><%=g.getMessage("TAB.COMMON.0061")%></a></li>
                <%	if(g.getSapType().isLocal()) { %>
                	<li><a  style="padding: 0 5px;" id="tab_4" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E22Expense.E22ExpenseListSV_m');"><!-- 장학자금 --><%=g.getMessage("TAB.COMMON.0062")%></a></li>
                     <li><a style="padding: 0 5px;" id="tab_5"  href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E30HealthInsurance.E30HealthInsuranceSV_m');"><!-- 건강보험 --><%=g.getMessage("TAB.COMMON.0063")%></a></li>
                	<li><a  style="padding: 0 5px;" id="tab_6" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E29PensionDetail.E29PensionListSV_m');"><!-- 국민연금 --><%=g.getMessage("TAB.COMMON.0064")%></a></li>
	                <li><a  style="padding: 0 5px;" id="tab_7" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E28General.E28GeneralListSV_m');"><!-- 종합검진 --><%=g.getMessage("TAB.COMMON.0065")%></a></li>
                	<% if (!user.e_werks.equals("AA00") && !user.e_werks.equals("AB00")&&!user.e_werks.equals("EA00") &&!user.e_werks.equals("EB00") &&!user.e_werks.equals("EC00")){ %>
                	<li><a style="padding: 0 5px;"  id="tab_8" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E28General.E28GeneralCancerListSV_m');"><!-- 추가암검진 --><%=g.getMessage("TAB.COMMON.0066")%></a></li>
                	<%} %>
                	<li><a style="padding: 0 5px;"  id="tab_9" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.E.E26InfoState.E26InfoStateSV_m');"><!-- 동호회가입현황 --><%=g.getMessage("TAB.COMMON.0067")%></a></li>
	            <%} %>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" frameborder=0 src=""></iframe>
	    </div>
<%	} %>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

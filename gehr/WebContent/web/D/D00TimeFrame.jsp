<%/******************************************************************************/
/*                                                                              																*/
/*   System Name  : MSS                                                         														*/
/*   1Depth Name  : MY HR 정보                                                  																*/
/*   2Depth Name  : 근태                                                        																	*/
/*   Program Name :근태                                                																			*/
/*   Program ID   : D00TimeFrame.jsp                                  																*/
/*   Description  : 근태 사항을 조회                                          																	*/
/*   Note         :                                                             																*/
/*   Creation     :                                           																				*/
/*   Update       :                                           																				*/
/*                  																															*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%
    WebUserData user = WebUtil.getSessionUser(request);
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String   tabid     = (String)request.getAttribute("tabid");
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
	String year =  (String)request.getAttribute("year");
	String month =  (String)request.getAttribute("month");

%>



<jsp:include page="/include/header.jsp" />

<script type="text/javascript">
<!--
    $(function() {
    <% if (StringUtils.isEmpty(tabid)){%>
		 $(".tab").find("a:first").trigger("click").addClass("selected");
	<%}else {	%>
		 $("#<%=tabid%>").trigger("click").addClass("selected");
	 <%}%>
    });

    function tabMove(target, urlName) {
    	frm = document.all.form1;
    	frm.urlName.value = urlName;
        $(".tab").find(".selected").removeClass("selected");
        $(target).addClass("selected");
        frm.action = urlName;
        frm.target="listFrame"
        frm.submit();
    }
  //조회에 의한 부서ID와 그에 따른 조회.
    function setDeptID(deptId, deptNm){
    	frm = document.all.form1;
        frm.hdn_deptId.value = deptId;
        frm.txt_deptNm.value = deptNm;
        frm.hdn_deptNm.value = deptNm;
        frm.hdn_excel.value = "";
        listFrame.form1.chck_yeno.value = document.form1.chck_yeno.value;
	    listFrame.setDeptID(deptId, deptNm);

    }

    function setPersInfo( obj ){
    	frm = document.all.form1;
        frm.hdn_deptId.value = obj.OBJID;
        frm.txt_deptNm.value = obj.STEXT;
        frm.hdn_deptNm.value = obj.STEXT;
        frm.hdn_excel.value = "";
    	listFrame.form1.chck_yeno.value = document.form1.chck_yeno.value;
    	listFrame.setDeptID(obj.OBJID, obj.STEXT);




    }

       function autoResize(target) {
           var iframeHeight =  target.contentWindow.document.body.scrollHeight;
           target.height = iframeHeight + 50;
       }


       function resizeIframe(height) {
           document.all.listFrame.height = height + 50;
    	}

       //-->
</script>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="title" value="COMMON.MENU.MSS_PT_STATE"/>
    </jsp:include>


<form name="form1" method="post" target="listFrame">
     <input type="hidden" name="subView" value="Y">
     <input type="hidden" name="urlName" value="">
     <input type="hidden" name="I_VALUE1"  value="">
     <input type="hidden" name="retir_chk"  value="">
     <input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
    <input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
    <input type="hidden" name="hdn_excel"  value="">
     <input type="hidden" name="tabid" value="<%=tabid %>">
     <input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">

    <%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>

   </form>
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                <li ><a  id="tab_1" style="padding: 0 10px;" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.F.F41DeptVacationSV');" class="selected"><!--  휴가 사용 현황--><%=g.getMessage("TAB.COMMON.0045")%></a></li>
	                <li><a  id="tab_2"   style="padding: 0 10px;" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV?year1=<%=year %>&month1=<%=month %>');"><!--  월간 근태 집계표--><%=g.getMessage("TAB.COMMON.0044")%></a></li>

	                <%	if(g.getSapType().isLocal()) { %>
	                	<li><a   style="padding: 0 10px;"  href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F43DeptDayWorkConditionSV');"><!--  일간 근태 집계표--><%=g.getMessage("TAB.COMMON.0043")%></a></li>
	                <% }else { %>
	                	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionEurpSV');"><!--  일간 근태 집계표--><%=g.getMessage("TAB.COMMON.0043")%></a></li>
	                <%} %>
	               <%	if(g.getSapType().isLocal()) { %>
	                	<li><a  style="padding: 0 10px;" id="tab_3" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F46OverTimeSV?year=<%=year %>&month=<%=month %>');"><!--  연장근로실적정보--><%=g.getMessage("TAB.COMMON.0094")%></a></li>
	                <%} %>
	                <li><a  style="padding: 0 10px;" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F44DeptWorkScheduleSV');"><!--  근무 계획표--><%=g.getMessage("TAB.COMMON.0095")%></a></li>
	             <%	if(g.getSapType().isLocal()) { %>
	                	<li><a    style="padding: 0 10px;"  href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F45DeptVacationReasonSV?i_gubun=3');"><!--  초과근무레포트--><%=g.getMessage("TAB.COMMON.0096")%></a></li>
	                	<li><a   style="padding: 0 10px;"  href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F45DeptVacationReasonSV');"><!--  휴가레포트--><%=g.getMessage("TAB.COMMON.0097")%></a></li>
		                <li><a  style="padding: 0 10px;" href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmPersInAuthSV');"><!--  부서근태담당자 --><%=g.getMessage("TAB.D.D40.0019")%></a></li>
	              <%} %>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" width="100%" height="" marginwidth="0" marginheight="0" frameborder="0" scrolling="no" onload="autoResize(this);"></iframe>
	    </div>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
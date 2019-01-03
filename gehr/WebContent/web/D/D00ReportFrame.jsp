<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : My HR                                            */
/*   2Depth Name  : 부서근태                                                       */
/*   Program Name : 근태 집계표                                               */
/*   Program ID   : D00ReportFrame.jsp                                     */
/*   Description  : 근태 집계표                                         */
/*   Note         :                                                             */
/*   Creation     :                                           */
/*   Update       :                                           */
/*                  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
%>
<jsp:include page="/include/header.jsp" />
<script type="text/javascript">
<!--
    $(function() {
        $(".tab").find("a:first").trigger("click").addClass("selected");
    });

    function tabMove(target, urlName) {
    	frm = document.all.form1;
    	frm.urlName.value = urlName;
        $(".tab").find(".selected").removeClass("selected");
        $(target).addClass("selected");
        frm.action = urlName;
        frm.submit();
    }
  //조회에 의한 부서ID와 그에 따른 조회.
    function setDeptID(deptId, deptNm){
        frm = document.all.form1;
        var urlName = frm.urlName.value;

        // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
        if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
            //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
    		alert("<%=g.getMessage("MSG.F.F41.0003")%>   ");
            return;
        }
        document.form1.txt_deptNm.value = deptNm;
        frm.hdn_deptId.value = deptId;
        frm.hdn_deptNm.value = deptNm;
        frm.action = urlName;
        frm.target="listFrame";
        frm.submit();

    }

    function setPersInfo( obj ){

    	frm = document.all.form1;
    	var urlName = frm.urlName.value;
    	frm.hdn_deptId.value = obj.OBJID;
        // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
        if ( obj.OBJID == "50000000" && frm.chk_organAll.checked == true ) {
            //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
            alert("<%=g.getMessage("MSG.F.F41.0003")%>   ");
            return;
        }
        document.form1.txt_deptNm.value = obj.STEXT;
        frm.hdn_deptNm.value = obj.STEXT;
        frm.action =urlName;
        frm.submit();
    }
  //-->

    function autoResize(target) {
      	 target.height = 0;
           var iframeHeight =  target.contentWindow.document.body.scrollHeight;
           target.height = iframeHeight + 50;
       }
</script>

 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.ESS_HRA_DAIL_STATE"/>
 </jsp:include>

<form name="form1" method="post" target="listFrame" method="post">
     <input type="hidden" name="subView" value="Y">
     <input type="hidden" name="urlName" value="">
     <input type="hidden" name="I_VALUE1"  value="">
     <input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
    <input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
    <input type="hidden" name="sMenuCode"  value="<%=sMenuCode%>">
    <input type="hidden" name="retir_chk"  value="">
    <%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>
   </form>
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                <%	if(user.area == Area.KR) { %>
	                	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.F.F43DeptDayWorkConditionSV');"><!-- 일간 근태 집계표 --><%=g.getMessage("TAB.COMMON.0043")%></a></li>
	                <% }else if (user.area==Area.CN||user.area==Area.HK||user.area==Area.TW){ %>
	                	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionSV');"><!-- 일간 근태 집계표 --><%=g.getMessage("TAB.COMMON.0043")%></a></li>
	                <%}else{ %>
	                     <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.F.Global.F43DeptDayWorkConditionEurpSV');"><!-- 일간 근태 집계표 --><%=g.getMessage("TAB.COMMON.0043")%></a></li>
	                <%} %>
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV');"><!--월간 근태 집계표 --><%=g.getMessage("TAB.COMMON.0044")%></a></li>
	                 <%	if((StringUtils.indexOf(user.e_authorization, "H")>-1)) { %>
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F41DeptVacationSV');" class="selected"><!--휴가 사용 현황 --><%=g.getMessage("TAB.COMMON.0045")%></a></li>
	                <%} %>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
	    </div>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

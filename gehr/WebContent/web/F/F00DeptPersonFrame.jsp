<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : 조직관리
*   2Depth Name  : 조직/인원현황
*   Program Name : 인원현황
*   Program ID   : F00DeptPersonFrame.jsp
*   Description  : 인원현황
*   Note         :
*   Creation     :
*   Update       : [CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha OT추가
					   [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 2017/11/06 eunha TH추가
*						//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 
********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>

<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
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
        frm.target="listFrame"
        frm.action = urlName;
        frm.submit();
    }
  //조회에 의한 부서ID와 그에 따른 조회.
    function setDeptID(deptId, deptNm){
        frm = document.all.form1;
        var urlName = frm.urlName.value;

        if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
    		alert("<spring:message code='MSG.F.F41.0003'/>");  //선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.
            return;
        }
        document.form1.txt_deptNm.value = deptNm;
        frm.hdn_deptId.value = deptId;
        frm.hdn_deptNm.value = deptNm;
        listFrame.form1.chck_yeno.value = document.form1.chck_yeno.value;
        frm.action = urlName;
        frm.target="listFrame";
        frm.submit();

    }

    function setPersInfo( obj ){

    	frm = document.all.form1;
    	var urlName = frm.urlName.value;
    	frm.hdn_deptId.value = obj.OBJID;
        if ( obj.OBJID == "50000000" && frm.chk_organAll.checked == true ) {
            alert("<spring:message code='MSG.F.F41.0003'/>");  //선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.
            return;
        }
        document.form1.txt_deptNm.value = obj.STEXT;
        frm.hdn_deptNm.value = obj.STEXT;
        listFrame.form1.chck_yeno.value = document.form1.chck_yeno.value;
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
<jsp:include page="/include/body-header.jsp" >
	<jsp:param name="title" value="COMMON.MENU.MSS_HEAD_COUNT"/>
</jsp:include>
	<form name="form1" method="post" target="listFrame" method="post">
		<input type="hidden" name="subView" value="Y">
		<input type="hidden" name="urlName" value="">
		<input type="hidden" name="I_VALUE1"  value="">
		<input type="hidden" name="retir_chk"  value="">
		<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
		<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
		<%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>
	</form>

	<div class="contentBody">
    	<!-- 탭 시작 -->
		<div class="tabArea">
    		<ul class="tab" id = "tab">
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.F.F01DeptPositionClassSV');" class="selected"><!-- 직급별 --><spring:message code='TAB.COMMON.0071'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F02DeptPositionDutySV');"><!-- 직무별 --><spring:message code='TAB.COMMON.0072'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F04DeptDutyClassSV');"><!-- 직무/직급 --><spring:message code='TAB.COMMON.0074'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F03DeptWorkareaClassSV');"><!-- 근무지별 --><spring:message code='TAB.COMMON.0073'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F05DeptGradeClassSV');"><!-- 직책별 --><spring:message code='TAB.COMMON.0075'/></a></li>
	    		<%if(user.area == Area.KR) { %>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F06DeptPositionClassServiceSV');"><!-- 평균근속 --><spring:message code='TAB.COMMON.0076'/></a></li>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F07DeptPositionClassAgeSV');"><!-- 평균연령 --><spring:message code='TAB.COMMON.0077'/></a></li>
				<%}%>
	    		<%--[CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha OT추가 --%>
	    		<%--[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 2017/11/06 eunha TH추가 --%>
	    		<%--@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32"))  2018/02/09 rdcamel --%>
	    		<%if(user.area == Area.CN || user.area == Area.TW || user.area == Area.TH || user.area == Area.HK || user.area == Area.DE || user.area == Area.PL || user.area == Area.US||user.area == Area.OT||user.area == Area.MX) { %>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F06DeptPositionClassServiceSV');"><!-- 근속기간--><spring:message code='TAB.COMMON.0080'/></a></li>
					<%--@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32"))  2018/02/09 rdcamel --%>
	    			<% if(user.area != Area.US && user.area != Area.MX){ %>
						<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F07DeptPositionClassAgeSV');"><!-- 연령 --><spring:message code='TAB.COMMON.0081'/></a></li>
					<%}%>
				<%}%>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F08DeptDutyConfirmSchoolSV');"><!-- 인정학력 --><spring:message code='TAB.COMMON.0078'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F09DeptDutyLastSchoolSV');"><!-- 최종학력 --><spring:message code='TAB.COMMON.0079'/></a></li>
				<%--[CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha OT추가 --%>
	    		<%--[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 2017/11/06 eunha TH추가 --%>
				<%if(user.area == Area.CN || user.area == Area.TW || user.area == Area.TH || user.area == Area.HK || user.area == Area.PL||user.area == Area.OT ) { %>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F10DeptRaceClassSV');"><!-- 인종/성별 --><spring:message code='TAB.COMMON.0082'/></a></li>
				<%}%>
				<%if(user.area == Area.DE || user.area == Area.PL ) { %>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F73DistanceInKilometersEurpSV');"><!--출근거리 --><spring:message code='TAB.COMMON.0083'/></a></li>
				<%}%>
			</ul>
		</div>
	</div>

	<div class="frameWrapper">
		<!-- TAB 프레임  -->
		<iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
	</div>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

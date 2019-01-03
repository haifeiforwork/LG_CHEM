<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : 조직관리
*   2Depth Name  : 조직통계
*   Program Name : 인사/교육
*   Program ID   : F20DeptPersonEducationFrame.jsp
*   Description  : 인사/교육
*   Note         :
*   Creation     :
*   Update       ://@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 
********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>

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

	$(function() {
		$(".tab").find("a:first").trigger("click").addClass("selected");
		blockFrame();
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

	function autoResize(target) {
		target.height = 0;
		var iframeHeight =  target.contentWindow.document.body.scrollHeight;
		target.height = iframeHeight + 50;
	}

	function popupView(winName, width, height, pernr) {
		var formN = document.form1;
		var screenwidth = (screen.width-width)/2;
		var screenheight = (screen.height-height)/2;
		var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=MSS_PA_LIST_INFO&ViewOrg=Y&viewEmpno="+pernr;
		var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

	}

</script>
<jsp:include page="/include/body-header.jsp" >
	<jsp:param name="title" value="COMMON.MENU.MSS_PA_LIST_INFO"/>
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
    		<ul class="tab">
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.F.F21DeptEntireEmpInfoSV');" class="selected"><!-- 연명부 --><spring:message code='TAB.COMMON.0086'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F22DeptScholarshipSV');"><!-- 학력 --><spring:message code='TAB.COMMON.0087'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F23DeptLanguageSV');"><!-- 외국어 --><spring:message code='TAB.COMMON.0088'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F24DeptQualificationSV');"><!-- 자격면허 --><spring:message code='TAB.COMMON.0003'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F26DeptExperiencedEmpSV');"><!-- 경력 --><spring:message code='TAB.COMMON.0056'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F27DeptRewardNPunishSV');"><!-- 포상/징계 --><spring:message code='TAB.COMMON.0007'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F31Dept4YearValuationSV');"><!-- 평가 --><spring:message code='TAB.COMMON.0057'/></a></li>
	    		<%if(user.area == Area.KR) { %>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F28DeptCreditSeizorSV');"><!-- 채권압류 --><spring:message code='TAB.COMMON.0115'/></a></li>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F29DeptAddressSV');"><!-- 현주소 --><spring:message code='TAB.COMMON.0091'/></a></li>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F25DeptLegalAssignmentSV');"><!-- 법정선임내역 --><spring:message code='TAB.COMMON.0092'/></a></li>
				<%} %>
				<%--//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  --%>
	    		<%if(user.area == Area.DE || user.area == Area.PL || user.area == Area.US || user.area == Area.MX) { %>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F72ExpiryOfContractUsaSV');"><!-- 계약만료현황 --><spring:message code='TAB.COMMON.0093'/></a></li>
				<%} %>
	    		<%if(user.area == Area.US || user.area == Area.MX) { %>
					<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F76DeptEmergencyContactsUsaSV');"><!-- 긴급연락처 --><spring:message code='TAB.COMMON.0116'/></a></li>
				<%} %>
			</ul>
		</div>
	</div>

	<div class="frameWrapper">
		<!-- TAB 프레임  -->
		<iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
	</div>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />


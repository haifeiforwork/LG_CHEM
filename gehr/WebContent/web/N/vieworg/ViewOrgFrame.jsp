<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ include file="/web/N/common/AESSession.jsp" %>
<%
// 웹로그 메뉴 코드명
String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
%>
<jsp:include page="/web/common/includeLocation.jsp"/>

<jsp:include page="/include/header.jsp"/>

<script type="text/javascript">


	function popup(theURL,winName,features) {
	  window.open(theURL,winName,features);
	}
	function tabMove() {
		document.all.area1Wrap.className="recoBsn_div2_hide";
		document.all.area2.className="recoBsn_div3_wide";
	}
	function tabShow() {
		document.all.area1Wrap.className="recoBsn_div2";
		document.all.area2.className="recoBsn_div3";
	}

	//조회에 의한 부서ID와 그에 따른 조회.
	function setDeptID(deptId, deptNm, uporgid){
		frm = document.form1;


		document.form1.I_ORGEH.value = deptId;
		document.form1.I_ORGEHTX.value = deptNm;
		document.form1.UP_ORGEH.value = uporgid;
		//alert(document.form1.I_ORGEH.value);
		frm.action = "<%= WebUtil.ServletURL %>hris.N.vieworg.ViewOrgListSV?sMenuCode=<%=sMenuCode%>";
		/*orgViewFrame.switchScreen();*/
		frm.target = "orgViewFrame";
		frm.submit();
	}

	function iframe_autoresize(arg) {
		arg.height = eval(arg.name+".document.body.scrollHeight");

	}

</script>

<body id="subBody" >
<form name="form1" method="post">
<input type="hidden" name="I_ORGEH">
<input type="hidden" name="UP_ORGEH">
<input type="hidden" name="I_ORGEHTX">
</form>
<%

	String returnUrl = WebUtil.JspURL+"N/vieworg/ViewOrgTreeList.jsp";
%>
<div class="subWrapper" style="margin-bottom:0;">
	<div class="title"><h1><spring:message code="COMMON.MENU.MSS_PA_OGR_CHART"/><%--인사조직도--%> </h1></div>

		<div style="width:250px;margin-right:15px;float:left;">
			<h2 class="subtitle"><spring:message code="MSG.A.MSS.ORG.SELECT"/><%--조직 선택--%></h2>
			<iframe name='orgList' id='orgList' src="<%=WebUtil.ServletURL %>hris.N.common.CommonOrgTreeListSV?isFirst=Y&returnUrl=<%=returnUrl %>&sMenuCode=<%=sMenuCode %>" width='250' height='450' frameborder='0' marginwidth='0' marginheight='0'  scrolling="auto" style="overflow:auto;border:#ddd solid 1px"></iframe>
		</div>
		<div style=" width:688px; float:left;">
			<h2 class="subtitle"><spring:message code="MSG.A.MSS.ORG.INFO"/><%--조직 정보--%></h2>
			<iframe name='orgViewFrame' id='orgViewFrame' src="<%=WebUtil.JspURL %>N/vieworg/ViewOrgList.jsp" width='688' height='450px' frameborder='0' marginwidth='0' marginheight='0'  style="overflow:hidden;overflow-x:hidden;overflow-y:auto;" ></iframe>
		</div>
		<div class="clear" /></div>

</div><!-- /subWrapper -->
</body>
<jsp:include page="/include/footer.jsp"/>
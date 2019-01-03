<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ include file="/web/N/common/AESSession.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<jsp:include page="/include/header.jsp" />
<script type="text/javascript">
	//document.body.scrollTop = 0;
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
	function setDeptID(deptId, deptNm){
		frm = document.form1;
		document.form1.I_ORGEH.value = deptId;
		document.form1.I_ORGEHTX.value = deptNm;
		//alert(document.form1.I_ORGEH.value);
		frm.action = "<%= WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendListSV";
		frm.target = "BusinListFrame";
		frm.submit();
	}

	function iframe_autoresize(arg) {
		arg.height = eval(arg.name+".document.body.scrollHeight");
	}

</script>


<body id="subBody" oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
<form name="form1" method="post">
<input type="hidden" name="I_ORGEH">
<input type="hidden" name="I_ORGEHTX">
</form>
<div class="subWrapper">
	<div class="title"><h1><spring:message code="LABEL.N.N01.0011" /><!-- 사업가 후보 추천 --> </h1></div>
	<div class="contentBody">
		<div class="recoBsn_div1" style="display:inline; width: 195px;">
			<h2 class="subtitle"><spring:message code="LABEL.N.N01.0012" /><!-- Step 1. 조직 선택 트리 --></h2>
			<iframe name='orgList' src="<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendSV?isFirst=Y" width='195' height='400' frameborder='0' marginwidth='0' marginheight='0' style="border:#ddd solid 2px"></iframe>
		</div>
		<div style="display:inline" >
			<iframe name='BusinListFrame' src="<%=WebUtil.JspURL %>N/bsnrmd/BusinRecommendList.jsp" width='800' height='990' style="margin-left:2px;" frameborder='0' marginwidth='0' marginheight='0'  scrolling="no"  onload="iframe_autoresize(this)"></iframe>
		</div>
	</div>
</div><!-- /subWrapper -->
</body>
<jsp:include page="/include/footer.jsp" />

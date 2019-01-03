<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : 조직관리
*   2Depth Name  : 조직/계약현황
*   Program Name : 계약현황
*   Program ID   : F77DeptUnitContractTypeUsaFrame.jsp
*   Description  : 계약현황
*   Note         :
*   Creation     :
*   Update       :
********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.common.constant.Area" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

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
        frm.target="listFrame";
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

		if (listFrame.form1.year != null) {
			document.form1.searchYear.value  = listFrame.form1.year.options[listFrame.form1.year.selectedIndex].text;
		}

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
     <jsp:param name="title" value="COMMON.MENU.MSS_HEAD_CONTACT"/>
</jsp:include>

	<form name="form1" method="post" target="listFrame" method="post">
		<input type="hidden" name="subView" value="Y">
		<input type="hidden" name="urlName" value="">
		<input type="hidden" name="I_VALUE1"  value="">
		<input type="hidden" name="retir_chk"  value="">
		<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
		<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
		<input type="hidden" name="searchYear"  value="">
		<%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>
	</form>
	<div class="contentBody">
    	<!-- 탭 시작 -->
		<div class="tabArea">
    		<ul class="tab">
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.F.F77DeptUnitContractTypeSV');" class="selected"><!-- 조직별 --><spring:message code='TAB.COMMON.0084'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F78JobFamilyContractTypeSV');"><!-- 직무별 --><spring:message code='TAB.COMMON.0072'/></a></li>
				<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F79QuotaPlanResultStatusSV');"><!-- 계획/실적 --><spring:message code='TAB.COMMON.0085'/></a></li>
			</ul>
		</div>
	</div>
	<div class="frameWrapper">
		<!-- TAB 프레임  -->
		<iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
	</div>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
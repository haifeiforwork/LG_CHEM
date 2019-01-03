<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   비근무/근무												*/
/*   Program Name	:   비근무/근무												*/
/*   Program ID		: D40AbscTimeExcelDown.jsp							*/
/*   Description		: 비근무/근무												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
	String E_INFO =  (String)request.getAttribute("E_INFO");

	String I_SEQNO = ( String ) request.getAttribute( "I_SEQNO" )  ;  // 월
	Vector resultList    = (Vector)request.getAttribute("resultList");


%>
<jsp:include page="/include/header.jsp" />

<c:set var="listCnt" value="${fn:length(resultList)}" />

<!-- 근무/비근무 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D40.0037" />
</jsp:include>

<form name="form1" method="post" target="listFrame" method="post">
    <input type="hidden" name="urlName" value="">
    <input type="hidden" id="ISEQNO" name="ISEQNO" value="">
    <input type="hidden" name="eInfo"  value="<%=E_INFO%>">
	<%@ include file="/web/D/D40TmGroup/common/SearchD40DeptInfoPernr.jsp" %>
</form>

<script language="JavaScript">

	var listCnt = '${listCnt}';
	$(function() {
	    $(".tab").find("a:first").trigger("click").addClass("selected");
	});

	function tabMove(target, urlName, gubun) {
		if(gubun == "C"){
			$(".searchOrg_ment").hide();
		}else{
			$(".searchOrg_ment").show();
		}
		var iSeqno = "";
		if($("#iSeqno").val() == ""){
			$("select option").each(function(){
				iSeqno += $(this).val()+",";
			});
			$("#ISEQNO").val(iSeqno.slice(0, -1));
		}else{
			$("#ISEQNO").val( $("#iSeqno").val());
		}
		if(!$('input:radio[name=orgOrTm]').is(':checked')){	//최초 진입 시 라디오 체크 안되어있을때
			if(listCnt == 0){ //근태 그룹개수가 없을때 조직도 선택
		    	$('input:radio[name=orgOrTm]:input[value=1]').attr("checked", true).trigger("click");
		    }else{	//근태그룹 선택
		    	$('input:radio[name=orgOrTm]:input[value=2]').attr("checked", true).trigger("click");
		    }
		}
		if($(':input:radio[name=orgOrTm]:checked').val() == "2"){
			$("#I_SELTAB").val("C");
		}
    	frm = document.all.form1;
    	frm.urlName.value = urlName;
        $(".tab").find(".selected").removeClass("selected");
        $(target).addClass("selected");
        frm.target = "listFrame";
        frm.action = urlName;
        frm.submit();
    }

	function saveBlockFrame() {
        $.blockUI({ message : '<spring:message code="MSG.D.D40.0001"/>' });
    }

	function autoResize(height) {
		document.all.listFrame.height = height + 20;
	}

	function resizeIframe(target) {
        var iframeHeight =  target.contentWindow.document.body.scrollHeight;
        target.height = iframeHeight + 50;
    }

</script>

<div class="searchOrg_ment" style="margin-top:5px;text-align:left; margin-bottom: 5px;">
	<div class="searchOrg_ment" id="searchOrg_ment">
		&nbsp;
	</div>
</div>

<div class="contentBody">
<!-- 탭 시작 -->
	<div class="tabArea">
		<ul class="tab">
           	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40AbscTimeEachSV', 'B');"><!-- 비근무/교육/출장 조회/변경(개별) --><spring:message code='TAB.D.D40.0012'/></a></li>
<%--         	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmDailySV', 'C');"><!-- 일일근태 입력 현황 --><spring:message code='TAB.D.D40.0018'/></a></li> --%>
           	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40AbscTimeLumpSV', 'A');"><!-- 비근무/교육/출장 입력(일괄) --><spring:message code='TAB.D.D40.0011'/></a></li>
        </ul>
   	</div>
</div>

<div class="frameWrapper">
	<!-- TAB 프레임  -->
	<iframe id="listFrame" name="listFrame" onload="resizeIframe(this);" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
</div>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

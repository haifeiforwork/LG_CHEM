<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                            */
/*   Program Name : 대학교검색 wait 창                                           */
/*   Program ID   : SearchSchoolsPopWait.jsp                        */
/*   Description  : 대학교검색 wait 창                                            */
/*   Note         : 없음                                                       			 */
/*   Creation     : 2014.10.23 SJY                                          */
/*   Update       : 최초생성  [CSR ID:2634836] 학자금 신청 시스템 개발 요청             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    String P_PERNR 		= WebUtil.nvl(request.getParameter("PERNR"));
    String nameCode 	= WebUtil.nvl(request.getParameter("full_name"));
    String i_ename 	= WebUtil.nvl(request.getParameter("LNMHG"+nameCode))+ WebUtil.nvl(request.getParameter("FNMHG"+nameCode));
    String i_shool    	= WebUtil.nvl(request.getParameter("SEARCH_ACAD"));
%>
<jsp:include page="/include/header.jsp" />

<script language="javascript">
<!--
function doSubmit(){
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchSchoolPop.jsp";
    document.form1.submit();
}
//-->
</script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="doSubmit()" >
<div class="winPop dvMinheight">
    <div class="header">
        <span><spring:message code="LABEL.COMMON.0031" /></span>
        <a href="javascript:void(0);" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" alt="팝업닫기" /></a>
    </div>
<div class="body">
<form name="form1" method="post" action="" onsubmit="return false">
<input type="hidden" name="P_PERNR"   value="<%=P_PERNR  %>">
<input type="hidden" name="i_ename"   value="<%=i_ename  %>">
<input type="hidden" name="i_shool" value="<%= i_shool %>">
</form>
<div class="listArea">
	<div class="table">
   		<table class="listTable"   >
   			<colgroup>
   			<col width="10"/>
   			<col width="40"/>
   			<col width="15"/>
   			<col width="15"/>
   			<col width="20"/>
   			</colgroup>
   			<thead>
             <tr>
                <th><spring:message code="LABEL.COMMON.0014"/><!-- 선택 --></th>
                <th><spring:message code="LABEL.COMMON.0032"/><!-- 학교명 --></th>
                <th><spring:message code="LABEL.COMMON.0033"/><!-- 본분교 --></th>
                <th><spring:message code="LABEL.COMMON.0034"/><!-- 설립구분 --></th>
                <th class="lastCol"><spring:message code="LABEL.COMMON.0035"/><!-- 지역 --></th>
			</tr>
			</thead>
			<tr class="oddRow">
				<td class="lastCol" colspan="5"><font color="#006699"><spring:message code="LABEL.APPROVAL.0009"/><!-- 검색중입니다. 잠시만 기다려주십시요. --></font></td>
			</tr>
		</table>
	</div>
</div>
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->


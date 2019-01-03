<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : OrganListFramePop.jsp                                       */
/*   Description  : 조직도 조회 PopUp                                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20  유용원                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<jsp:include page="/include/header.jsp" />

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<div class="winPop">

	<div class="header">
    	<span><spring:message code="LABEL.SEARCH.DEPT"/><%--부서검색--%></span>
    	<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
    </div>

	<div class="body">
		<IFRAME src="<%= WebUtil.ServletURL %>hris.common.ApprovalOrganListSV?isFirst=Y&hdn_popCode=A" name="iFrame1" frameborder="0" leftmargin="0" height="390" width="280" marginheight="0" marginwidth="0" topmargin="0" scrolling="auto"  style="float:left; border:1px solid #ddd; margin-right:10px;"></IFRAME>
		<IFRAME src="<%= WebUtil.JspPath %>common/ApprovalOrganListRight.jsp" name="iFrame2" frameborder="0" leftmargin="0" height="390" width="600" marginheight="0" marginwidth="0" topmargin="0" scrolling="no" style="right;  border:1px solid #ddd; "></IFRAME>
		<div class="clear"></div>
	  	<div class="buttonArea">
	  		<ul class="btn_crud">
	  			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
	  		</ul>
	  	</div>
	</div>



</div>

</body>
</html>

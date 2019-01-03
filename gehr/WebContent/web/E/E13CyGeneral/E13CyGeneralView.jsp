<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 이월종합검진                                                    */
/*   Program Name : 이월종합검진                                                    */
/*   Program ID   : E13CyGeneralView.jsp                                          */
/*   Description  : 이월종합검진 상세일정을 조회                                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String topPage = (String)request.getAttribute("topPage");
    String endPage = (String)request.getAttribute("endPage");
    //Logger.debug.println(this, topPage);
    //Logger.debug.println(this, endPage);
%>
<jsp:include page="/include/header.jsp"/>

<script type="text/javascript">
<!--
function topAutoResize(target) {
	 target.height = 0;
     var iframeHeight =  target.contentWindow.document.body.scrollHeight;
     target.height = iframeHeight ;
}

function autoResize(target) {
	 target.height = 0;
    var iframeHeight =  target.contentWindow.document.body.scrollHeight;
    target.height = iframeHeight  ;
}

//-->
</script>

<div class="subWrapper">

	    <div class="frameWrapper">
	        <iframe id="topPage" name="topPage"  onload="topAutoResize(this);" width="100%" frameborder="0" scrolling="no" src="<%= topPage %>" ></iframe>
	        <iframe id="endPage" name="endPage" onload="autoResize(this);" width="100%" frameborder="0" scrolling="no" src="<%= endPage %>" ></iframe>
	    </div>

	</div>
<jsp:include page="/include/footer.jsp"/>

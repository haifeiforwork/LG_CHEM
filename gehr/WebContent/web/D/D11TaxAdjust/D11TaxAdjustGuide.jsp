<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustGuide.jsp                                       */
/*   Description  : 연말정산 조회 메인 frame                                    */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-11-17  lsa @v1.1 frame  높이 늘림                      */
/* 					2018-01-15 cykim [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    String targetYear = (String)request.getAttribute("targetYear");
    String PERNR = (String)request.getAttribute("PERNR");
    String url  = "";
    url = WebUtil.JspURL+"D/D11TaxAdjust/" + targetYear + "/Tax_Top.htm";

%>
<script type="text/javascript">
<!--

 function resizeIframe(height) {
     document.all.inform.height = height + 12;
	}

function autoResize(target) {
	 target.height = 0;
    var iframeHeight =  target.contentWindow.document.body.scrollHeight;
    target.height = iframeHeight + 50;
}

/* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 */
function test(){
	window.open("/web/expensePopup.jsp","","toolbar=no, location=no, direction=no, width=400, height=200,left=500, top=300");
}
	-->
</script>

<jsp:include page="/include/header.jsp" />

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="test()">

		<IFRAME  name="top"   width="100%" style="height:182px;"  marginwidth="0" marginheight="0" src="<%= WebUtil.JspURL %>D/D11TaxAdjust/D11TaxAdjustGuideTop.jsp?targetYear=<%= targetYear %>&PERNR=<%= PERNR %>" scrolling="no" frameborder="NO"></IFRAME>
	    <IFRAME name="title"  width="0%" height="0%"  marginwidth="0" marginheight="0" src="" scrolling="no" frameborder="NO"></IFRAME>
	    <IFRAME  name="inform"  width="100%"  onload="autoResize(this);"  marginwidth="0"  src="<%= url %>" scrolling="no" frameborder="NO"></IFRAME>


</body>

<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

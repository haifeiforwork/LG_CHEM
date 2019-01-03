<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근태실적조회및 신청                                                */
/*   Program ID   : D00ConductFrame.jsp                                     */
/*   Description  : 근태 사항을 조회  및 신청                                          */
/*   Note         :                                                             */
/*   Creation     :                                           */
/*   Update       :                                           */
/*                  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@page import="org.apache.commons.lang.StringUtils"%>

<jsp:include page="/include/header.jsp" />

<script type="text/javascript">

    $(function() {
        $(".tab").find("a:first").trigger("click").addClass("selected");
    });

    function tabMove(target, urlName) {
        $(".tab").find(".selected").removeClass("selected");
        $(target).addClass("selected");

        document.all.urlForm.action = urlName;
        document.all.urlForm.submit();
    }
    function resizeIframe(height) {
        document.all.listFrame.height = height + 200;
 	}

     function autoResize(target) {
      	 target.height = 0;
           var iframeHeight =  target.contentWindow.document.body.scrollHeight;
           target.height = iframeHeight + 50;
       }
     function setVal(i_paydr, i_lcldt) {
    	 document.all.urlForm.I_PAYDR.value = i_paydr;
    	 document.all.urlForm.I_LCLDT.value = i_lcldt;

       }
</script>


 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.ESS_PT_TIME_SHEET"/>
 </jsp:include>
<form id="urlForm" name="urlForm" target="listFrame" method="post">
    <input type="hidden" name="subView" value="Y">
    <input type="hidden" name="I_LCLDT" value="">
    <input type="hidden" name="I_PAYDR" value="">
</form>

	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV?iframeBuildYn=true');" class="selected"><%=g.getMessage("TAB.COMMON.0041")%></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.D.D07TimeSheet.D07TimeSheetDetailUsaSV?iframeYn=true');"><%=g.getMessage("TAB.COMMON.0042")%></a></li>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" width="100%" height="870" marginwidth="0" marginheight="0" scrolling="auto" frameborder=0></iframe>
	    </div>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
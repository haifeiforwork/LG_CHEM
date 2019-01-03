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
<%
	String   RequestPageName     = (String)request.getAttribute("RequestPageName"); //보상명세서 호출여부체크
%>

<jsp:include page="/include/header.jsp" />

<script type="text/javascript">

    $(function() {
        //$(".tab").find("a:first").trigger("click").addClass("selected");
        $("<%=StringUtils.isEmpty(RequestPageName)? "#tab_1" : "#tab_2"%>").trigger("click").addClass("selected");
    });

    function tabMove(target, urlName) {
    	frm = document.all.form1;
    	frm.urlName.value = urlName;
        $(".tab").find(".selected").removeClass("selected");
        $(target).addClass("selected"); //$(event.target).addClass("selected");
        frm.target="listFrame";
        frm.action = urlName;
        frm.submit();
    }

    function autoResize(target) {
      	 target.height = 0;
           var iframeHeight =  target.contentWindow.document.body.scrollHeight;
           target.height = iframeHeight + 50;
       }
</script>

<body>
<form name="form1" method="post" method="post">
     <input type="hidden" name="subView" value="Y">
     <input type="hidden" name="urlName" value="">
     <input type="hidden" name="RequestPageName" value="<%=RequestPageName %>">

    <div class="subWrapper">
		<div class="subHead">
			<h2><!--장학자금--><%=g.getMessage("COMMON.MENU.ESS_BE_TUTI_FEE")%></h2>
		</div>
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	            	<li><a  id="tab_1" href="javascript:;" onclick="tabMove(this,'<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.E21Expense.E21ExpenseBuildSV');" class="selected"><!--신청--><%=g.getMessage("TAB.COMMON.0041")%></a></li>
	                <li><a  id="tab_2" href="javascript:;" onclick="tabMove(this,'<%= WebUtil.ServletURL %>hris.E.E22Expense.E22ExpenseListSV');" class="selected" ><!--조회--><%=g.getMessage("TAB.COMMON.0042")%></a></li>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" src="" ></iframe>
	    </div>

	</div>
</form>
</body>

</html>

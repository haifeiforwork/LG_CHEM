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

<jsp:include page="/include/header.jsp" />

<script type="text/javascript">

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
    <div class="subWrapper">
		<div class="subHead">
			<h2><!--Medical Fee--><%=g.getMessage("COMMON.MENU.ESS_BE_MEDI_EXPA")%></h2>
		</div>
	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	            	<li><a href="javascript:;" onclick="tabMove(this,'<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.Global.E17Hospital.E17HospitalBuildSV');" class="selected"><!--신청--><%=g.getMessage("TAB.COMMON.0041")%></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this,'<%= WebUtil.ServletURL %>hris.E.Global.E18Hospital.E18HospitalListSV');" ><!--조회--><%=g.getMessage("TAB.COMMON.0042")%></a></li>
	                </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="870" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" src="" ></iframe>
	    </div>

	</div>
</form>
</body>

</html>

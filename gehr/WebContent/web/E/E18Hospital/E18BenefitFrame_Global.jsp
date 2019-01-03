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
<%
	WebUserData user_m = (WebUserData)session.getValue("user_m");
	WebUserData user   = (WebUserData)session.getValue("user");
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명

	//String empNo		= WebUtil.nvl(request.getParameter("hdn_empNo"));  					//부서코드
	//String empNm		= WebUtil.nvl(request.getParameter("hdn_empNm"));  				//부서명

%>
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

    function  doSearchDetail() {
        frm = document.all.form1;

        if(window.frames['listFrame']) {
	        var urlName = frm.urlName.value;
	        frm.method = "post";
	        $("#listFrame").attr("src", urlName);
        } else {
            frm.action = "";
            frm.target = "";
            frm.submit();
   	 	}

       // frm.submit();
    }

    function autoResize(target) {
     	 target.height = 0;
          var iframeHeight =  target.contentWindow.document.body.scrollHeight;
          target.height = iframeHeight + 50;
    }

</script>

<jsp:include page="/include/body-header.jsp">
    <jsp:param name="click" value="Y"/>
    <jsp:param name="title" value="COMMON.MENU.MSS_BE_BENE_EXP"/>
</jsp:include>

<form name="form1" method="post" method="post">
     <input type="hidden" name="urlName" value="">
     <input type="hidden" name="retir_chk"  value="">
     <input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
     <input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">

		<%@ include file="/web/common/SearchDeptPersons_m.jsp" %>

		<% if("X".equals(user_m.e_mss)) { %>

	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.E.Global.E18Hospital.E18HospitalListSV_m');" class="selected"><!--Medical Fee--><%=g.getMessage("LABEL.E.E18.0002")%></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this,'<%= WebUtil.ServletURL %>hris.E.Global.E22Expense.E22ExpenseListSV_m');"><!--Tuition Fee--><%=g.getMessage("LABEL.E.E22.0002")%></a></li>
	            	<li><a href="javascript:;" onclick="tabMove(this,'<%= WebUtil.ServletURL %>hris.E.Global.E24Language.E24LanguageListSV_m');"><!--Language Fee--><%=g.getMessage("LABEL.E.E24.0002")%></a></li>
	            </ul>
	        </div>
	    </div>

	    <div class="frameWrapper">
	        <!-- TAB 프레임  -->
	        <iframe id="listFrame" name="listFrame" onload="autoResize(this);" width="100%" height="870" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" src="" ></iframe>
	    </div>
	    <%	} %>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
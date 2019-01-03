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
        var urlName = frm.urlName.value;

        frm.method = "post";
        //frm.action = "/web/E/E18Hospital/E18BenefitFrame_Global.jsp";
        //frm.target="listFrame";
        $("#listFrame").attr("src", urlName);
       // frm.submit();
    }

  //조회에 의한 부서ID와 그에 따른 조회.
    function setDeptID(deptId, deptNm){

        frm = document.all.form1;
        var urlName = frm.urlName.value;

        // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
        if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
            //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
    		alert("<%=g.getMessage("MSG.F.F41.0003")%>   ");
            return;
        }
        document.form1.txt_deptNm.value = deptNm;
        frm.txt_startDay.value = listFrame.document.form1.txt_startDay.value;
        frm.txt_endDay.value = listFrame.document.form1.txt_endDay.value;
        frm.hdn_deptId.value = deptId;
        frm.hdn_deptNm.value = deptNm;
        frm.action = urlName;
        frm.target="listFrame";
        frm.submit();

    }

    function setPersInfo( obj ){

    	frm = document.all.form1;
    	var urlName = frm.urlName.value;
    	frm.hdn_deptId.value = obj.OBJID;
        // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
        if ( obj.OBJID == "50000000" && frm.chk_organAll.checked == true ) {
            //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
            alert("<%=g.getMessage("MSG.F.F41.0003")%>   ");
            return;
        }
        document.form1.txt_deptNm.value = obj.STEXT;
        frm.hdn_deptNm.value = obj.STEXT;
        listFrame.form1.chck_yeno.value = document.form1.chck_yeno.value;
        frm.action =urlName;
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
     <input type="hidden" name="urlName" value="">
     <input type="hidden" name="retir_chk" value="">
     <input type="hidden" name="I_VALUE1"  value="">
     <input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
     <input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
     <input type="hidden" name="txt_startDay" value="">
     <input type="hidden" name="txt_endDay" value="">

    <div class="subWrapper">
		<div class="subHead">
			<h2><!--Benefit Overview-Expatriate--><%=g.getMessage("COMMON.MENU.MSS_BE_STATE_EXP")%></h2>
		</div>
	<!--	< %@ include file="/web/common/SearchDeptInfo.jsp" %>  -->
		<%@ include file="/web/common/SearchDeptInfoPernr.jsp" %>

	    <div class="contentBody">
	        <!-- 탭 시작 -->
	        <div class="tabArea">
	            <ul class="tab">
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.F.F52DeptWelfareMedicalEXPSV');" class="selected"><!--Medical Fee--><%=g.getMessage("LABEL.E.E18.0002")%></a></li>
	                <li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F52DeptWelfareSchoolEXPSV');"><!--Tuition Fee--><%=g.getMessage("LABEL.E.E22.0002")%></a></li>
	            	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.ServletURL %>hris.F.F52DeptWelfareLanguageEXPSV');"><!--Language Fee--><%=g.getMessage("LABEL.E.E24.0002")%></a></li>
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

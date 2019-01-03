<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   공통														*/
/*   Program Name	:   조직도로 부서찾기 팝업									*/
/*   Program ID		: D40OrganSmListPop.jsp								*/
/*   Description		: 조회조건 공통 조직도로 부서찾기 팝업					*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	String emp = user.empNo;
	String I_DATUM  = WebUtil.nvl(request.getParameter("I_DATUM"));          //기간
	String pageGubun  = WebUtil.nvl(request.getParameter("pageGubun"));	//페이지구분(A:근태그룹인원지정, )
	if( I_DATUM == null|| I_DATUM.equals("")) {
		I_DATUM = DataUtil.getCurrentDate();           //1번째 조회시
    }

	D40CheckDeptAhtuRFC func = new D40CheckDeptAhtuRFC();
    Object D40CheckDeptAhtu_vt = func.checkDeptAhtuRFC( emp, I_DATUM );
    String E_CHECK = DataUtil.getValue(D40CheckDeptAhtu_vt, "E_CHECK");
%>
<c:set var="E_CHECK" value="<%=E_CHECK%>"/>
<jsp:include page="/include/header.jsp" />

<style type="text/css">
.box1 {
	float:left;
	width:360px;
	height:440px;
}
.box3{
	width: 360px;
    height: 340px;
    margin-bottom: 5px;
}
.box4{
	height: 30px;
    background-color: #f4f3f3;
    padding-top: 10px;
    border-width: 1px;
    border-style: solid;
    border-color: #e0e0e0;
}

</style>
<script>

	$(function() {
	    $(".tab").find("a:first").trigger("click").addClass("selected");
	});

	function tabMove(target, urlName, gubun) {
	    $(".tab").find(".selected").removeClass("selected");
	    $(target).addClass("selected");
	    $("#I_SELTAB").val(gubun);
	    $("#deptNo").val("");
	    var frm = document.form1;
	    frm.action = urlName;
	    frm.target = "iFrame1";
	    frm.submit();
	}

    function doSearchDetail() {
        opener.doSearchDetail();
	}

    function do_search(){
    	//alert($("#I_DATUM").val());
    	//alert($("#I_SELTAB").val());
		var frm = document.form1;
    	frm.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OrganListSV";
        frm.target = "iFrame1";
        frm.submit();


    }

//     function do_searchEmp(){
// 		var frm = document.form1;
// 		frm.gubun.value = "1";
<%--         frm.action = "<%= WebUtil.JspPath %>D/D40TmGroup/D40OrganListRightIF.jsp"; --%>
//         frm.target = "iFrame2";
//         frm.submit();
// 	}

    function do_searchSawon(){

    	if($("#I_GUBUN").val() == "2"){	//이름별
    		if($("#searchText").val().length > 1){
	    		$("#I_ENAME").val($("#searchText").val());
	    		$("#I_PERNR").val("");

    		}else{
    			alert("<spring:message code='MSG.D.D40.0002'/>");/* 검색할 이름을 2글자 이상 입력해 주십시오. */
    		}
    	}else{	//사번별
    		$("#I_PERNR").val($("#searchText").val());
    		$("#I_ENAME").val("");
    	}
    	var frm = document.form1;
		frm.gubun.value = "2";
        frm.action = "<%= WebUtil.JspPath %>D/D40TmGroup/D40OrganListRightIF.jsp";
        frm.target = "iFrame2";
        frm.submit();

    }

    function goSubmit(){
    	//alert($('#iFrame2').contents().find('#foo').val());
    	if($("#deptNo").val() == ""){
    		alert("<spring:message code='MSG.D.D40.0010'/>"); /* 선택된 부서가 없습니다. */
    	}else{
    		$(opener.document).find("#searchDeptNo").val($("#deptNo").val());
    		$(opener.document).find("#searchDeptNm").val($("#deptNm").val());
    		$(opener.document).find("#I_SELTAB").val($("#I_SELTAB").val());
    		this.close();
    	}
    }

</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post" action="">
<div class="winPop">
	<input type="hidden" id="deptNo" name="deptNo">
	<input type="hidden" id="deptNm" name="deptNm">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB">
	<div class="header">
    	<span><spring:message code="LABEL.SEARCH.DEPT"/><%--부서검색--%></span>
    	<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
    </div>

	<div class="body">

		<div>
			<div class="box1">
				<div class="box4">
					<table>
						<colgroup>
							<col  />
							<col width="10%" />
			                <col width="10%"/>
			            </colgroup>
			            <tr>
				            <th>
			                    <!-- 기준일자 --><%=g.getMessage("LABEL.D.D40.0010")%> : <%= WebUtil.printDate(I_DATUM) %>
			                </th>
			                <td>
			                	<input type="hidden" id="I_DATUM" name="I_DATUM" value="<%= WebUtil.printDate(I_DATUM) %>" size="15" >
							</td>
							<td>
<!-- 								<div class="tableBtnSearch" style="text-align: center;"> -->
<%-- 				                    <a href="javascript:do_search();" class="search"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a> --%>
<!-- 				                </div> -->
			                </td>
			                </tr>
			        </table>
				</div>
				<div style="height: 5px;"> </div>
				<div class="tabArea" style="width: 360px;">
			        <ul class="tab" style="margin-bottom: 5px;">
			           	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OrganListSV', 'A');"><spring:message code='TAB.D.D40.0001'/><%-- 부서근태 권한조직--%></a></li>

			           	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OrganListSV', 'C');"><spring:message code='TAB.D.D40.0002'/><!-- 근태그룹 --></a></li>
			           	<c:if test='${ E_CHECK==("X") }'>
			           	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OrganListSV', 'B');"><spring:message code='TAB.D.D40.0003'/><!-- 인사조직 --></a></li>
			        	</c:if>
			        </ul>
			    </div>
				<div class="box3">
					<IFRAME src="" name="iFrame1" frameborder="0" leftmargin="0" height="340" width="360" marginheight="0" marginwidth="0" topmargin="0" style="float:left; border:1px solid #ddd; "></IFRAME>
				</div>
<!-- 				<div style="height: 5px;"> </div> -->
<!-- 		     	<div class="tableBtnSearch" style="text-align: center;"> -->
<%-- 	                <a href="javascript:do_searchEmp();" class="search"><span><!-- 사원찾기 --><%=g.getMessage("BUTTON.D.D40.0001")%></span></a> --%>
<!-- 	            </div> -->
			</div>
		</div>

		<div class="clear"></div>
	  	<div class="buttonArea" >
	  		<ul class="btn_crud">
	  			<li><a class="darken" href="javascript:goSubmit();"><span><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
	  			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
	  		</ul>
	  	</div>
	</div>



</div>
</form>
</body>

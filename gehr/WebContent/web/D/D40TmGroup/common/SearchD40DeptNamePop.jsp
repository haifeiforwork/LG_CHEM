<%--
/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서조회                                                   */
/*   Program ID   : SearchD40DeptNamePop.jsp                                          */
/*   Description  : 부서명 입력하여 조회                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2017-12-08 정준현                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%
    String deptNm  = WebUtil.nvl(request.getParameter("txt_deptNm")); //부서명
    String authClsf  = WebUtil.nvl(request.getParameter("authClsf"), "M"); //권한 그룹

    String I_DATUM  = WebUtil.nvl(request.getParameter("I_DATUM"));          //기간

	if( I_DATUM == null|| I_DATUM.equals("")) {
		I_DATUM = DataUtil.getCurrentDate();           //1번째 조회시
    }
%>

<jsp:include page="/include/header.jsp"/>

<style>

.box4{
	height: 40px;
	background-color: #f4f3f3;
	padding-top: 5px;
	border-width: 1px;
    border-style: solid;
    border-color: #e0e0e0;
}

</style>

<script language="JavaScript">
	<!--
	// 부서 검색
	function do_search(){
		var frm = document.form1;
		if(frm.txt_deptNm.value == ""){
			alert("<spring:message code='MSG.D.D40.0011'/>");
			return;
		}
		frm.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40SearchDeptSV";
		frm.target = "iFrame";
		frm.submit();
	}
	//확인
	function goSubmit(){
		if($('#iFrame').contents().find(".chkbox:checked").size()==0){
    		alert("<spring:message code='MSG.D.D40.0010'/>"); /* 선택된 부서가 없습니다. */
    	}else{
			var iframe = document.getElementById("iFrame");
    		var doc = iframe.contentWindow.document;
    		var checkboxes = doc.getElementsByName("chkbutton");
    		var deptGroup = "";
    		var deptGrp = "";
    		var deptNo = "";
    		var deptNm = "";
    		for (var i = 0; i < checkboxes.length; i++) {
    			if(checkboxes[i].checked == true){
    				deptGroup = checkboxes[i].value;
    				deptGrp = deptGroup.split("^");

    				deptNo += deptGrp[0]+",";
    				deptNm += deptGrp[1]+",";
				}
			}
    		$(opener.document).find("#searchDeptNo").val(deptNo.slice(0, -1));
    		$(opener.document).find("#searchDeptNm").val(deptNm.slice(0, -1));
    		$(opener.document).find("#I_SELTAB").val("A");
    		this.close();
    	}
	}
	//-->
</script>
</head>

<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" >
	<form name="form1" method="post" action="">
<%-- 		<input type="hidden" name="authClsf" value="<%=authClsf%>"> --%>

		<div class="winPop">
			<div class="header">
				<span><%=g.getMessage("LABEL.D.D12.0048")%><%--부서명 검색--%></span>
				<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
			</div>

			<div class="body">
				<div class="box4">
					<table>
						<colgroup>
							<col width="12%" />
							<col width="25%" />
							<col width="12%" />
							<col width="20%" />
							<col />
						</colgroup>
						<tr>
							<th>
								<!-- 기준일자 --><spring:message code="LABEL.D.D40.0010" />
							</th>
							<td>
<%-- 								<input type="text" id="I_DATUM" class="date" name="I_DATUM" value="<%=I_DATUM %>" size="15" > --%>
							</td>
							<th>
								<!-- 부서명 --><spring:message code="LABEL.D.D05.0004" />
							</th>
							<td>
								<input type="text" id="txt_deptNm" name="txt_deptNm" value=""  onKeyDown="if(event.keyCode == 13) do_search();">
							</td>
							<td>
								<div class="tableBtnSearch" style="text-align: center;">
									<a href="javascript:do_search();" class="search"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div style="height: 5px;"> </div>
				<div>
					<IFRAME id="iFrame" name="iFrame" frameborder="0" leftmargin="0" height="330" width="100%" marginheight="0" marginwidth="0" topmargin="0" style="float:left; border:1px solid #ddd; "></IFRAME>
				</div>
			</div>
			<div class="clear"></div>
			<div style="height: 5px;"> </div>
			<div class="buttonArea" style="padding-right: 20px;">
				<ul class="btn_crud">
					<li><a class="darken" href="javascript:goSubmit();"><span><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
					<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%--닫기--%></span></a></li>
				</ul>
			</div>
		</div>
	</form>
</body>
<jsp:include page="/include/footer.jsp"/>


<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계													*/
/*   Program Name	:   근태집계													*/
/*   Program ID		: D40StateFrame.jsp								*/
/*   Description		: 근태집계													*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/web/common/commonProcess.jsp" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
	String E_INFO =  (String)request.getAttribute("E_INFO");

	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름

	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));
	String E_BEGDA    = (String)request.getAttribute("E_BEGDA");	//리턴 조회시작일
	String E_ENDDA    = (String)request.getAttribute("E_ENDDA");	//리턴 조회종료일
	String I_BEGDA    = (String)request.getAttribute("I_BEGDA");	//조회시작날짜
	String I_ENDDA    = (String)request.getAttribute("I_ENDDA");	//조회종료날짜

	if(!"".equals(I_BEGDA) && I_BEGDA != null){
		E_BEGDA = I_BEGDA;
	}
	if(!"".equals(I_ENDDA) && I_ENDDA != null){
		E_ENDDA = I_ENDDA;
	}

	Vector resultList    = (Vector)request.getAttribute("resultList");
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무



%>
<jsp:include page="/include/header.jsp" />

<c:set var="listCnt" value="${fn:length(resultList)}" />

<!-- 근태 집계표 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D40.0051" />
</jsp:include>

<form name="form1" method="post" target="listFrame">
    <input type="hidden" name="urlName" value="">
    <input type="hidden" id="ISEQNO" name="ISEQNO" value="">
    <input type="hidden" name="eInfo"  value="<%=E_INFO%>">
<!--     <input type="hidden" id="I_GUBUN" name="I_GUBUN"  value=""> -->
    <input type="hidden" id="gubun" name="gubun"  value="">
    <input type="hidden" id="p_gubun" name="p_gubun"  value="">
	<%@ include file="/web/D/D40TmGroup/common/SearchD40DeptInfoPernr.jsp" %>

<script language="JavaScript">

	var listCnt = '${listCnt}';
	$(function() {
	    $(".tab").find("a:first").trigger("click").addClass("selected");

	});

	//사원검색 Popup.
	function organ_search2() {
	    var frm = document.form1;
	    var small_window=window.open("about:blank","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
	    small_window.focus();
	    $("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
	    $("#ISEQNO").val(parent.$("#iSeqno").val());
	    frm.target = "Organ";
	    frm.pageGubun.value = "B";
	    frm.action = "<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListFramePop.jsp";
	    frm.submit();
	}

	function dt_clear(){
		$("#I_PERNR").val("");
		$("#I_ENAME").val("");
	}

	function tabMove(target, urlName, gubun) {
		var val1 = $("#I_BEGDA").val();
		var val2 = $("#I_ENDDA").val();

		if(val1 == ""){
			alert("<spring:message code='MSG.D.D40.0034'/>");/* 조회기간 시작일은 필수 입니다. */
			return;
		}
		if(val2 == ""){
			alert("<spring:message code='MSG.D.D40.0035'/>");/* 조회기간 종료일은 필수 입니다. */
			return;
		}
		if(val1 > val2){
			alert("<spring:message code='MSG.D.D40.0036'/>");/* 조회 시작일이 종료일보다 클 수 없습니다. */
			return;
		}

		if(gubun == "B"){	//기간근태집계표는 조회기간 체크 안함
									//조회기간 체크 1년으로 변경

			var dt = Number(chkDt(val1, val2)+1);

			if(dt > 365){
				alert("조회기간 날짜의 차이는 365일 이내여야 합니다.");/* 조회기간 날짜의 차이는 365일 이내여야 합니다. */
				return;
			}else{
				$("#I_PERNR").val($("#I_PERNR").val());
	 			$("#I_ENAME").val($("#I_ENAME").val());
	 			$("#gubun").val("SEARCH");
	 			$("#p_gubun").val(gubun);
	 			var iSeqno = "";
	 			if($("#iSeqno").val() == ""){
	 				$("#iSeqno option").each(function(){
	 					iSeqno += $(this).val()+",";
	 				});
	 				$("#ISEQNO").val(iSeqno.slice(0, -1));
	 			}else{
	 				$("#ISEQNO").val( $("#iSeqno").val());
	 			}
	 			if(!$('input:radio[name=orgOrTm]').is(':checked')){	//최초 진입 시 라디오 체크 안되어있을때
	 				if(listCnt == 0){ //근태 그룹개수가 없을때 조직도 선택
	 			    	$('input:radio[name=orgOrTm]:input[value=1]').attr("checked", true).trigger("click");
	 			    }else{	//근태그룹 선택
	 			    	$('input:radio[name=orgOrTm]:input[value=2]').attr("checked", true).trigger("click");
	 			    }
	 			}
	 			if($(':input:radio[name=orgOrTm]:checked').val() == "2"){
	 				$("#I_SELTAB").val("C");
	 			}
	 	    	frm = document.all.form1;
	 	    	frm.urlName.value = urlName;
	 	        $(".tab").find(".selected").removeClass("selected");
	 	        $(target).addClass("selected");
	 	        frm.target = "listFrame";
	 	        frm.action = urlName;
	 	        frm.submit();
			}

		}else{	//일간근태 집계표,휴가사용현황은 조회기간 31일 체크

			var dt = Number(chkDt(val1, val2)+1);

			if(dt > 31){
				alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
				return;
			}else{
	 			$("#I_PERNR").val($("#I_PERNR").val());
	 			$("#I_ENAME").val($("#I_ENAME").val());
	 			$("#gubun").val("SEARCH");
	 			$("#p_gubun").val(gubun);
	 			var iSeqno = "";
	 			if($("#iSeqno").val() == ""){
	 				$("#iSeqno option").each(function(){
	 					iSeqno += $(this).val()+",";
	 				});
	 				$("#ISEQNO").val(iSeqno.slice(0, -1));
	 			}else{
	 				$("#ISEQNO").val( $("#iSeqno").val());
	 			}
	 			if(!$('input:radio[name=orgOrTm]').is(':checked')){	//최초 진입 시 라디오 체크 안되어있을때
	 				if(listCnt == 0){ //근태 그룹개수가 없을때 조직도 선택
	 			    	$('input:radio[name=orgOrTm]:input[value=1]').attr("checked", true).trigger("click");
	 			    }else{	//근태그룹 선택
	 			    	$('input:radio[name=orgOrTm]:input[value=2]').attr("checked", true).trigger("click");
	 			    }
	 			}
	 			if($(':input:radio[name=orgOrTm]:checked').val() == "2"){
	 				$("#I_SELTAB").val("C");
	 			}
	 	    	frm = document.all.form1;
	 	    	frm.urlName.value = urlName;
	 	        $(".tab").find(".selected").removeClass("selected");
	 	        $(target).addClass("selected");
	 	        frm.target = "listFrame";
	 	        frm.action = urlName;
	 	        frm.submit();
	 		}
		}

    }

	function do_search(){
		var val1 = $("#I_BEGDA").val();
		var val2 = $("#I_ENDDA").val();

		if(val1 == ""){
			alert("<spring:message code='MSG.D.D40.0034'/>");/* 조회기간 시작일은 필수 입니다. */
			return;
		}
		if(val2 == ""){
			alert("<spring:message code='MSG.D.D40.0035'/>");/* 조회기간 종료일은 필수 입니다. */
			return;
		}
		if(val1 > val2){
			alert("<spring:message code='MSG.D.D40.0036'/>");/* 조회 시작일이 종료일보다 클 수 없습니다. */
			return;
		}

		if($("#p_gubun").val() == "B"){	//기간근태집계표는 조회기간 체크 안함

			var dt = Number(chkDt(val1, val2)+1);

			if(dt > 365){
				alert("조회기간 날짜의 차이는 365일 이내여야 합니다.");/* 조회기간 날짜의 차이는 365일 이내여야 합니다. */
				return;
			}else{

				$("#I_PERNR").val($("#I_PERNR").val());
	 			$("#I_ENAME").val($("#I_ENAME").val());
	 			var iSeqno = "";
	 			if($("#iSeqno").val() == ""){
	 				$("#iSeqno option").each(function(){
	 					iSeqno += $(this).val()+",";
	 				});
	 				$("#ISEQNO").val(iSeqno.slice(0, -1));
	 			}else{
	 				$("#ISEQNO").val( $("#iSeqno").val());
	 			}
	 			if(!$('input:radio[name=orgOrTm]').is(':checked')){	//최초 진입 시 라디오 체크 안되어있을때
	 				if(listCnt == 0){ //근태 그룹개수가 없을때 조직도 선택
	 			    	$('input:radio[name=orgOrTm]:input[value=1]').attr("checked", true).trigger("click");
	 			    }else{	//근태그룹 선택
	 			    	$('input:radio[name=orgOrTm]:input[value=2]').attr("checked", true).trigger("click");
	 			    }
	 			}
	 			if($(':input:radio[name=orgOrTm]:checked').val() == "2"){
	 				$("#I_SELTAB").val("C");
	 			}
				var vObj = document.form1;
			    vObj.target = "listFrame";
			    if("C" == $("#p_gubun").val()){
				    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40HolidayStateSV";
			    }else{
				    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailStateSV";
			    }
			    vObj.method = "post";
			    vObj.submit();
			}
		}else{
			var dt = Number(chkDt(val1, val2)+1);

			if(dt > 31){
				alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
				return;
			}else{
	 			$("#I_PERNR").val($("#I_PERNR").val());
	 			$("#I_ENAME").val($("#I_ENAME").val());
	 			var iSeqno = "";
	 			if($("#iSeqno").val() == ""){
	 				$("#iSeqno option").each(function(){
	 					iSeqno += $(this).val()+",";
	 				});
	 				$("#ISEQNO").val(iSeqno.slice(0, -1));
	 			}else{
	 				$("#ISEQNO").val( $("#iSeqno").val());
	 			}
	 			if(!$('input:radio[name=orgOrTm]').is(':checked')){	//최초 진입 시 라디오 체크 안되어있을때
	 				if(listCnt == 0){ //근태 그룹개수가 없을때 조직도 선택
	 			    	$('input:radio[name=orgOrTm]:input[value=1]').attr("checked", true).trigger("click");
	 			    }else{	//근태그룹 선택
	 			    	$('input:radio[name=orgOrTm]:input[value=2]').attr("checked", true).trigger("click");
	 			    }
	 			}
	 			if($(':input:radio[name=orgOrTm]:checked').val() == "2"){
	 				$("#I_SELTAB").val("C");
	 			}
				var vObj = document.form1;
			    vObj.target = "listFrame";
			    if("C" == $("#p_gubun").val()){
				    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40HolidayStateSV";
			    }else{
				    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailStateSV";
			    }
			    vObj.method = "post";
			    vObj.submit();

	 		}
		}
	}

	function chkDt(val1, val2){
		var FORMAT = ".";
        var start_dt = val1.split(FORMAT);
        var end_dt = val2.split(FORMAT);

        start_dt[1] = (Number(start_dt[1]) - 1) + "";
        end_dt[1] = (Number(end_dt[1]) - 1) + "";

        var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
        var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

        return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;

	}

	function saveBlockFrame() {
        $.blockUI({ message : '<spring:message code="MSG.D.D40.0001"/>' });
    }

	function autoResize(height) {
		document.all.listFrame.height = height + 20;
	}

	function resizeIframe(target) {
        var iframeHeight =  target.contentWindow.document.body.scrollHeight;
        target.height = iframeHeight + 50;
    }

</script>

<div class="tableInquiry">
	<table>
		<colgroup>
			<col width="8%" /><!-- 조회기간 -->
			<col width="30%" /><!-- input -->
			<col width="7%" /><!-- 계획근무 -->
			<col width="12%" /><!--select  -->
			<col width="13%" /><!--사원선택 button  -->
	              <col /><!--search button  -->
	          </colgroup>
	          <tr>
	              <th>
	                  <spring:message code="LABEL.D.D12.0077"/><!-- 조회기간 -->
	              </th>
	              <td>
				<input type="text" id="I_BEGDA" class="date" name="I_BEGDA" value="<%=E_BEGDA%>" size="15" onBlur="javascript:dateFormat(this);"> ~
				<input type="text" id="I_ENDDA" class="date" name="I_ENDDA" value="<%=E_ENDDA%>" size="15" onBlur="javascript:dateFormat(this);" >
	              </td>
	              <th>
	                  <spring:message code='LABEL.D.D40.0025'/><!-- 계획근무 -->
	              </th>
	              <td>
				<select name="I_SCHKZ" id="I_SCHKZ" style="width: 100%;">
					<option value=""><spring:message code='LABEL.COMMON.0024'/><!-- 전체 --></option>
<%
							for( int j = 0; j < T_SCHKZ.size(); j++ ) {
								D40DailStateData vtData = (D40DailStateData)T_SCHKZ.get(j);
%>
									<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(I_SCHKZ)){ %> selected <%} %>><%=vtData.CODE%> (<%=vtData.TEXT %>)</option>
<%
							}
%>
				</select>
			</td>
			<td>
				<div class="tableBtnSearch tableBtnSearch2">
                       <a onClick="javascript:organ_search2()" class="search"><span><spring:message code='BUTTON.D.D40.0006'/><!-- 사원선택 --></span></a>
                   </div>
			</td>
			<td>
				<input type="hidden" id="I_PERNR" name="I_PERNR" value="<%=I_PERNR%>">
				<input type="text" id="I_ENAME" name="I_ENAME" readonly="readonly"  value="<%=I_ENAME%>" style="width: 120px;">
				<input type="hidden" id="pageGubun" name="pageGubun" value="">
				<a class="floatLeft" onClick="javascript:dt_clear();" style="cursor: pointer;"><img src="/web/images/eloffice/images/ico/ico_inline_reset.png" alt="초기화"/></a>
<!--                     &nbsp; &nbsp; -->
                <div class="tableBtnSearch tableBtnSearch2">
                	<a onClick="javascript:do_search();" class="search"><span><spring:message code="BUTTON.COMMON.SEARCH"/><!-- 조회 --></span></a>
                </div>
            </td>
        </tr>
    </table>
</div>

<div class="searchOrg_ment" style="margin-top:5px;text-align:left; margin-bottom: 5px;">
	<div class="searchOrg_ment" id="searchOrg_ment">
		&nbsp;
	</div>
</div>

</form>

<div class="contentBody">
<!-- 탭 시작 -->
	<div class="tabArea">
		<ul class="tab">
           	<li><a onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailStateSV', 'A');" style="cursor: pointer;"><!-- 일간근태집계표 --><spring:message code='TAB.D.D40.0015'/></a></li>
           	<li><a onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailStateSV', 'B');" style="cursor: pointer;"><!-- 기간간근태집계표 --><spring:message code='TAB.D.D40.0016'/></a></li>
           	<li><a onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40HolidayStateSV', 'C');" style="cursor: pointer;"><!-- 휴가사용현황 --><spring:message code='TAB.D.D40.0017'/></a></li>
        </ul>
   	</div>
</div>

<div class="frameWrapper">
	<!-- TAB 프레임  -->
	<iframe id="listFrame" name="listFrame" onload="resizeIframe(this);" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
</div>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

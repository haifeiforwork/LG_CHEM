<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   일일근무일정 변경(달력)								*/
/*   Program Name	:   일일근무일정 변경(달력)								*/
/*   Program ID		: D40TmSchkzPlanningChart.jsp						*/
/*   Description		: 일일근무일정 변경(달력)									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);

	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자

	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));
	String sMenuCode =  (String)request.getAttribute("sMenuCode");

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE
	Vector T_EXPORTB    = (Vector)request.getAttribute("T_EXPORTB");	//근무계획표-DATA
	Vector T_EXERR    = (Vector)request.getAttribute("T_EXERR");	//에러내역

	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름
	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜
	String I_ENDDA    = (String)request.getAttribute("I_ENDDA");	//선택날짜
	String E_BEGDA    = (String)request.getAttribute("E_BEGDA");	//리턴 조회시작일
	String E_ENDDA    = (String)request.getAttribute("E_ENDDA");	//리턴 조회종료일
	String gubun    = (String)request.getAttribute("gubun");	//선택날짜

	if("".equals(WebUtil.nvl(I_DATUM))){
		I_DATUM = E_BEGDA;
	}
	if("".equals(WebUtil.nvl(I_ENDDA))){
		I_ENDDA = E_ENDDA;
	}

%>
<jsp:include page="/include/header.jsp" />

<c:set var="size" value="<%=T_EXPORTB.size()%>"/>
<script language="JavaScript">

<%
if("SAVE".equals(gubun)){
	if("E".equals(E_RETURN)){
		if(!"".equals(E_MESSAGE) && E_MESSAGE != null){
%>
	alert('<%=E_MESSAGE%>\n<spring:message code="MSG.D.D40.0054"/>');
<%
		}
	}else{
		if(!"".equals(E_MESSAGE) && E_MESSAGE != null){
%>
		alert('<%=E_MESSAGE%>');
<%
		}
	}
}
%>

	function saveBlockFrame() {
        $.blockUI({ message : '<spring:message code="MSG.D.D40.0001"/>' });
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

	/**
	 * null 이나 빈값을 기본값으로 변경
	 * @param str       입력값
	 * @param defaultVal    기본값(옵션)
	 * @returns {String}    체크 결과값
	 */
	function nvl(str, defaultVal) {
	    var defaultValue = "";
	    if (typeof defaultVal != 'undefined') {
	        defaultValue = defaultVal;
	    }
	    if (typeof str == "undefined" || str == null || str == '' || str == "undefined") {
	        return defaultValue;
	    }
	    return str;
	}


	$(function() {

		//사원검색 Popup.
		$("#organ_search").click(function(){
			var small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
		    small_window.focus();
		    $("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		    $("#iSeqno").val(parent.$("#iSeqno").val());
		    $("#pageGubun").val("B");

		    $("#form1").attr("action","<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListFramePop.jsp");
		    $("#form1").attr("target", "Organ");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});

		//사원검색 input 초기화
		$("#dt_clear").click(function(){
			$("#I_PERNR").val("");
			$("#I_ENAME").val("");
		});

		//검색
		$("#do_search").click(function(){

			var val1 = $("#I_DATUM").val();
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

			var dt = Number(chkDt(val1, val2)+1);

			if(dt > 31){
				alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
				return;
			}else{

				//상단 공통 조회조건
				parent.blockFrame();
				$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
				$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
				$("#searchDeptNm").val(parent.$("#searchDeptNm").val());

				var iSeqno = "";
				if(parent.$("#iSeqno").val() == ""){
					parent.$("#iSeqno option").each(function(){
						if($(this).val() != ""){
							iSeqno += $(this).val()+",";
						}
					});
					$("#ISEQNO").val(iSeqno.slice(0, -1));
				}else{
					$("#ISEQNO").val( parent.$("#iSeqno").val());
				}
				if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
					$("#I_SELTAB").val("C");
				}else{
					$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
				}

				$("#I_ACTTY").val("R");
				$("#gubun").val("SEARCH");

				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzPlanningChartSV");
			    $("#form1").attr("target", "_self");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

		//저장
		$("#do_save, #save").click(function(){
			parent.saveBlockFrame();
			$("#I_ACTTY").val("I");
			$("#gubun").val("SAVE");

			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzPlanningChartSV");
		    $("#form1").attr("target", "_self");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();

		});

		//엑셀다운로드
		$("#excelDown").click(function(){
			var val1 = $("#I_DATUM").val();
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

			var dt = Number(chkDt(val1, val2)+1);

			if(dt > 31){
				alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
				return;
			}else{
				//상단 공통 조회조건
			  	$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
				$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
				$("#searchDeptNm").val(parent.$("#searchDeptNm").val());

				var iSeqno = "";
				if(parent.$("#iSeqno").val() == ""){
					parent.$("#iSeqno option").each(function(){
						if($(this).val() != ""){
							iSeqno += $(this).val()+",";
						}
					});
					$("#ISEQNO").val(iSeqno.slice(0, -1));
				}else{
					$("#ISEQNO").val( parent.$("#iSeqno").val());
				}
				if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
					$("#I_SELTAB").val("C");
				}else{
					$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
				}

				$("#I_ACTTY").val("R");
				$("#gubun").val("EXCEL");

				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzPlanningChartSV");
			    $("#form1").attr("target", "ifHidden");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

		//인쇄하기
		$("#go_Rotationprint").click(function(){
			var val1 = $("#I_DATUM").val();
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

			var dt = Number(chkDt(val1, val2)+1);

			if(dt > 31){
				alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
				return;
			}else{

				$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
				$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
				$("#searchDeptNm").val(parent.$("#searchDeptNm").val());

				var iSeqno = "";
				if(parent.$("#iSeqno").val() == ""){
					parent.$("#iSeqno option").each(function(){
						if($(this).val() != ""){
							iSeqno += $(this).val()+"-";
						}
					});
					$("#ISEQNO").val(iSeqno.slice(0, -1));
				}else{
					$("#ISEQNO").val( parent.$("#iSeqno").val());
				}
				if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
					$("#I_SELTAB").val("C");
				}else{
					$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
				}

				$("#gubun").val("PRINT");

			    var popup = window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1300,height=662,left=0,top=2");
			    popup.focus();
			    $("#form1").attr("action","<%=WebUtil.JspURL%>"+"D/D40TmGroup/common/printFrame_planning_chart.jsp");
			    $("#form1").attr("target", "essPrintWindow");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

		//PDF
		$("#go_pdf").click(function(){

			var val1 = $("#I_DATUM").val();
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

			var dt = Number(chkDt(val1, val2)+1);

			if(dt > 31){
				alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
				return;
			}else{
				//상단 공통 조회조건
			  	$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
				$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
				$("#searchDeptNm").val(parent.$("#searchDeptNm").val());

				var iSeqno = "";
				if(parent.$("#iSeqno").val() == ""){
					parent.$("#iSeqno option").each(function(){
						if($(this).val() != ""){
							iSeqno += $(this).val()+",";
						}
					});
					$("#ISEQNO").val(iSeqno.slice(0, -1));
				}else{
					$("#ISEQNO").val( parent.$("#iSeqno").val());
				}
				if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
					$("#I_SELTAB").val("C");
				}else{
					$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
				}

				$("#gubun").val("PDF");

				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzPlanningChartSV");
			    $("#form1").attr("target", "ifHidden");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

// 		var holiday = "";
// 		$('.listTabTr').each(function(i,val){
// 			if(i == 0){
// 				$(val).find('th').each(function(j,val2){
// 					if($(val2).attr("class") != ""){
// 						var tdClass = $(val2).attr("class").split(" ");
// 	    				var tdId = tdClass[1];
// 	    				if(nvl(tdId) != ""){
// 	    					holiday += tdId.replace("T","")+",";
// 	    				}
// 					}
// 				});
// 			}
// 			holiday = holiday.slice(0, -1);
// 			var chk = holiday.split(",");

// 		    $.each(chk, function(i, val){
// 		    	for(var k=0; k<listSize; k++){
// 					$("#I"+val+"_"+(k+1)).css({"color":"red"});
// 					$("#I"+val+"_"+(k+1)+" option[value = "+$("#I"+val+"_"+(k+1)).val()+"]" ).css({"color":"red"});
// 		    	}
// 		    });
// 		});

		var height = document.body.scrollHeight;
		parent.autoResize(height);
	});

// 	$(document).ready(function() {
// 		$('select option[value*=OFF]').css({'color':'red'});
// 		$("select").on("change", function(){
// 			if($(this).val() == "OFF" || $(this).val() == "OFFH"){
// 				$(this+"option[value*=OFF]").css({'color':'red'});
// 			}
// 	    }).change();

// 	});

</script>

	<jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value ="Y"/>
        <jsp:param name="help" value="X04Statistics.html'"/>
    </jsp:include>

<form id="form1" name="form1" method="post" onsubmit="return false">
	<input type="hidden" id="orgOrTm" name="orgOrTm" value="">
	<input type="hidden" id="searchDeptNo" name="searchDeptNo" value="">
	<input type="hidden" id="searchDeptNm" name="searchDeptNm" value="">
	<input type="hidden" id="iSeqno" name="iSeqno" value="">
	<input type="hidden" id="ISEQNO" name="ISEQNO" value="">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB" value="">
	<input type="hidden" id="I_ACTTY" name="I_ACTTY" value="">
	<input type="hidden" id="gubun" name="gubun" value="">
	<input type="hidden" id="pageGubun" name="pageGubun" value="">
	<input type="hidden" id="titleCnt" name="titleCnt" value="<%=T_EXPORTB.size()%>">

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
                    <%-- <spring:message code='LABEL.D.D40.0030'/><!--조회시작일 --> --%>
                    <spring:message code="LABEL.D.D12.0077"/><!-- 조회기간 -->
                </th>
                <td>
					<input type="text" id="I_DATUM" class="date" name="I_DATUM" value="<%= WebUtil.printDate(I_DATUM) %>" size="15" >
					~ <input type="text" id="I_ENDDA" class="date" name="I_ENDDA" value="<%= WebUtil.printDate(I_ENDDA) %>" size="15" >
                </td>
                <th>
                    <spring:message code='LABEL.D.D40.0025'/><!-- 계획근무 -->
                </th>
                <td>
					<select name="I_SCHKZ" id="I_SCHKZ" style="width: 100%;">
						<option value=""><spring:message code='LABEL.COMMON.0024'/><!-- 전체 --></option>
<%
						if ( T_SCHKZ != null && T_SCHKZ.size() > 0 ) {
							for( int j = 0; j < T_SCHKZ.size(); j++ ) {
								D40TmSchkzPlanningChartCodeData vtData = (D40TmSchkzPlanningChartCodeData)T_SCHKZ.get(j);
%>
									<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(I_SCHKZ)){ %> selected <%} %>><%=vtData.CODE%> (<%=vtData.TEXT %>)</option>
<%
							}
						}
%>
						</select>
				</td>
				<td>
					<div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:void(0);" id="organ_search"><span><spring:message code='BUTTON.D.D40.0006'/><!-- 사원선택 --></span></a>
                    </div>
				</td>
				<td>
					<input type="hidden" id="I_PERNR" name="I_PERNR" value="<%=I_PERNR%>">
					<input type="text" id="I_ENAME" name="I_ENAME" readonly="readonly"  value="<%=I_ENAME%>">
					<a class="floatLeft" href="javascript:void(0);" id="dt_clear"><img src="/web/images/eloffice/images/ico/ico_inline_reset.png" alt="초기화"/></a>
<!--                     &nbsp; &nbsp; -->
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:void(0);" id="do_search"><span><spring:message code="BUTTON.COMMON.SEARCH"/><!-- 조회 --></span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>
<%
	if ( T_EXPORTA != null && T_EXPORTA.size() > 0 ) {
        //타이틀 사이즈.
        int titlSize = T_EXPORTA.size();

%>

	<h2 class="subtitle withButtons"><%=E_INFO%></h2>
	<div class="buttonArea">
		<ul class="btn_mdl displayInline">
<!--             <li><a class="search" href="javascript:void(0);" id="go_pdf"><span>PDF Download</span></a></li> -->
			<li><a class="search" href="javascript:void(0);" id="excelDown"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
			<li><a class="search" href="javascript:void(0);" id="go_Rotationprint"><span><spring:message code='LABEL.F.F42.0002'/><!-- 인쇄 --></span></a></li>
			<li><a class="darken" href="javascript:void(0);" id="do_save"><span><!-- 저장 --><spring:message code="BUTTON.COMMON.SAVE" /></span></a></li>
		</ul>
	</div>
	<div class="listArea">
		<div class="listTop">
			<span class="listCnt"><spring:message code="LABEL.D.D12.0081" /><!-- 총 --> <span><%=T_EXPORTB.size() %></span><spring:message code="LABEL.D.D12.0083" /><!-- 건 --></span>
			<div style="position:relative; display:block; text-align:right; margin-right: 8px;margin-left: 2px;top:8px; ">
		  		<%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %>
		  	</div>
		</div>
		<div class="table">
   			<div class="wideTable">
	      		<table class="listTable listTab">
	      			<thead>
	        			<tr class="listTabTr">
							<th class="" rowspan="2"><!-- 이름--><spring:message code='LABEL.D.D05.0006'/></th>
							<th class="fixCol" rowspan="2"><!-- 사번--><spring:message code='LABEL.D.D05.0005'/></th>
<%
                //타이틀(일자).
				for( int h = 0; h < titlSize; h++ ){
					D40TmSchkzPlanningChartData titleData = (D40TmSchkzPlanningChartData)T_EXPORTA.get(h);
                    String tdColor = "";
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "td11";
                    }
                    if (titleData.HOLIDAY.equals("X")) {
                        tdColor = "td11 T"+(h+1);
                    }
%>
							<th class='<%=tdColor%>'><%=titleData.DD%></th>
<%
                }
%>
						</tr>
						<tr>
<%
                //타이틀(요일).
                for( int k = 0; k < titlSize; k++ ){
                	D40TmSchkzPlanningChartData titleData = (D40TmSchkzPlanningChartData)T_EXPORTA.get(k);
                    String tdColor = "";
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "td11";
                    }
                    if (titleData.HOLIDAY.equals("X")) {
                        tdColor = "td11 T"+(k+1);
                    }
%>
							<th class='<%=tdColor%>'  nowrap><%=titleData.KURZT%></th>
<%
                }//end if
%>
						</tr>
					</thead>
<%
//                 int inx = 0;
                for( int i = 0; i < T_EXPORTB.size(); i++ ){
                	D40TmSchkzPlanningChartNoteData data = (D40TmSchkzPlanningChartNoteData)T_EXPORTB.get(i);
                    String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해
                    String tr_class = "";
                    if(i%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }
// 					if( data.ORGEH.equals(deptData.ORGEH) ){
//                     	inx++;
%>
	        			<tr class="<%=tr_class%>">
							<td class="align_left" nowrap><%=data.ENAME%><input type="hidden" id="ENAME<%=i+1 %>" name="ENAME" value="<%=data.ENAME %>"></td>
							<td class="fixCol"><%=data.PERNR%><input type="hidden" id="PERNR<%=i+1 %>" name="PERNR" value="<%=data.PERNR %>"></td>
<%
					if( titlSize >= 1 ){
%>
							<td>
								<input type="hidden" id="T1_<%=i+1 %>" name="T1" value="<%=data.T1 %>">
								<input type="hidden" id="D1_<%=i+1 %>" name="D1" value="<%=data.D1 %>">
<%						if(data.T1 != null && !"".equals(data.T1)){ %>
								<select id="I1_<%=i+1 %>" name="I1" style="width: 60px"  class="T1">
								<option value="">-------</option>
<%
								String dt1 = (!"".equals(WebUtil.nvl(data.I1))) ? data.I1 : data.T1;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt1.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I1_<%=i+1 %>" name="I1" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 2 ){
%>
							<td>
								<input type="hidden" id="T2_<%=i+1 %>" name="T2" value="<%=data.T2 %>">
								<input type="hidden" id="D2_<%=i+1 %>" name="D2" value="<%=data.D2 %>">
<%						if(data.T2 != null && !"".equals(data.T2)){		%>
								<select id="I2_<%=i+1 %>" name="I2" style="width: 60px" class="T2">
								<option value="">-------</option>
<%
								String dt2 = (!"".equals(WebUtil.nvl(data.I2))) ? data.I2 : data.T2;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt2.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I2_<%=i+1 %>" name="I2" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 3 ){
%>
							<td>
								<input type="hidden" id="T3_<%=i+1 %>" name="T3" value="<%=data.T3 %>">
								<input type="hidden" id="D3_<%=i+1 %>" name="D3" value="<%=data.D3 %>">
<%						if(data.T3 != null && !"".equals(data.T3)){		%>
								<select id="I3_<%=i+1 %>" name="I3" style="width: 60px"  class="T3">
								<option value="">-------</option>
<%
								String dt3 = (!"".equals(WebUtil.nvl(data.I3))) ? data.I3 : data.T3;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt3.equals(data2.CODE)){ %> selected <%} %>><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I3_<%=i+1 %>" name="I3" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 4 ){
%>
							<td>
								<input type="hidden" id="T4_<%=i+1 %>" name="T4" value="<%=data.T4 %>">
								<input type="hidden" id="D4_<%=i+1 %>" name="D4" value="<%=data.D4 %>">
<%						if(data.T4 != null && !"".equals(data.T4)){		%>
								<select id="I4_<%=i+1 %>" name="I4" style="width: 60px" class="T4">
								<option value="">-------</option>
<%
								String dt4 = (!"".equals(WebUtil.nvl(data.I4))) ? data.I4 : data.T4;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt4.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I4_<%=i+1 %>" name="I4" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 5 ){
%>
							<td>
								<input type="hidden" id="T5_<%=i+1 %>" name="T5" value="<%=data.T5 %>">
								<input type="hidden" id="D5_<%=i+1 %>" name="D5" value="<%=data.D5 %>">
<%						if(data.T5 != null && !"".equals(data.T5)){		%>
								<select id="I5_<%=i+1 %>" name="I5" style="width: 60px" class="T5">
								<option value="">-------</option>
<%
								String dt5 = (!"".equals(WebUtil.nvl(data.I5))) ? data.I5 : data.T5;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt5.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I5_<%=i+1 %>" name="I5" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 6 ){
%>
							<td>
								<input type="hidden" id="T6_<%=i+1 %>" name="T6" value="<%=data.T6 %>">
								<input type="hidden" id="D6_<%=i+1 %>" name="D6" value="<%=data.D6 %>">
<%						if(data.T6 != null && !"".equals(data.T6)){		%>
								<select id="I6_<%=i+1 %>" name="I6" style="width: 60px" class="T6">
								<option value="">-------</option>
<%
								String dt6 = (!"".equals(WebUtil.nvl(data.I6))) ? data.I6 : data.T6;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt6.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I6_<%=i+1 %>" name="I6" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 7 ){
%>
							<td>
								<input type="hidden" id="T7_<%=i+1 %>" name="T7" value="<%=data.T7 %>">
								<input type="hidden" id="D7_<%=i+1 %>" name="D7" value="<%=data.D7 %>">
<%						if(data.T7 != null && !"".equals(data.T7)){		%>
								<select id="I7_<%=i+1 %>" name="I7" style="width: 60px" class="T7">
								<option value="">-------</option>
<%
								String dt7 = (!"".equals(WebUtil.nvl(data.I7))) ? data.I7 : data.T7;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt7.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I7_<%=i+1 %>" name="I7" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 8 ){
%>
							<td>
								<input type="hidden" id="T8_<%=i+1 %>" name="T8" value="<%=data.T8 %>">
								<input type="hidden" id="D8_<%=i+1 %>" name="D8" value="<%=data.D8 %>">
<%						if(data.T8 != null && !"".equals(data.T8)){		%>
								<select id="I8_<%=i+1 %>" name="I8" style="width: 60px" class="T8">
								<option value="">-------</option>
<%
								String dt8 = (!"".equals(WebUtil.nvl(data.I8))) ? data.I8 : data.T8;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt8.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I8_<%=i+1 %>" name="I8" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 9 ){
%>
							<td>
								<input type="hidden" id="T9_<%=i+1 %>" name="T9" value="<%=data.T9 %>">
								<input type="hidden" id="D9_<%=i+1 %>" name="D9" value="<%=data.D9 %>">
<%						if(data.T9 != null && !"".equals(data.T9)){		%>
								<select id="I9_<%=i+1 %>" name="I9" style="width: 60px" class="T9">
								<option value="">-------</option>
<%
								String dt9 = (!"".equals(WebUtil.nvl(data.I9))) ? data.I9 : data.T9;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt9.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I9_<%=i+1 %>" name="I9" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 10 ){
%>
							<td>
								<input type="hidden" id="T10_<%=i+1 %>" name="T10" value="<%=data.T10 %>">
								<input type="hidden" id="D10_<%=i+1 %>" name="D10" value="<%=data.D10 %>">
<%						if(data.T10 != null && !"".equals(data.T10)){		%>
								<select id="I10_<%=i+1 %>" name="I10" style="width: 60px" class="T10">
								<option value="">-------</option>
<%
								String dt10 = (!"".equals(WebUtil.nvl(data.I10))) ? data.I10 : data.T10;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt10.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I10_<%=i+1 %>" name="I10" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 11 ){
%>
							<td>
								<input type="hidden" id="T11_<%=i+1 %>" name="T11" value="<%=data.T11 %>">
								<input type="hidden" id="D11_<%=i+1 %>" name="D11" value="<%=data.D11 %>">
<%						if(data.T11 != null && !"".equals(data.T11)){		%>
								<select id="I11_<%=i+1 %>" name="I11" style="width: 60px" class="T11">
								<option value="">-------</option>
<%
								String dt11 = (!"".equals(WebUtil.nvl(data.I11))) ? data.I11 : data.T11;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt11.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I11_<%=i+1 %>" name="I11" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 12 ){
%>
							<td>
								<input type="hidden" id="T12_<%=i+1 %>" name="T12" value="<%=data.T12 %>">
								<input type="hidden" id="D12_<%=i+1 %>" name="D12" value="<%=data.D12 %>">
<%						if(data.T12 != null && !"".equals(data.T12)){		%>
								<select id="I12_<%=i+1 %>" name="I12" style="width: 60px" class="T12">
								<option value="">-------</option>
<%
								String dt12 = (!"".equals(WebUtil.nvl(data.I12))) ? data.I12 : data.T12;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt12.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I12_<%=i+1 %>" name="I12" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 13 ){
%>
							<td>
								<input type="hidden" id="T13_<%=i+1 %>" name="T13" value="<%=data.T13 %>">
								<input type="hidden" id="D13_<%=i+1 %>" name="D13" value="<%=data.D13 %>">
<%						if(data.T13 != null && !"".equals(data.T13)){		%>
								<select id="I13_<%=i+1 %>" name="I13" style="width: 60px" class="T13">
								<option value="">-------</option>
<%
								String dt13 = (!"".equals(WebUtil.nvl(data.I13))) ? data.I13 : data.T13;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt13.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I13_<%=i+1 %>" name="I13" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 14 ){
%>
							<td>
								<input type="hidden" id="T14_<%=i+1 %>" name="T14" value="<%=data.T14 %>">
								<input type="hidden" id="D14_<%=i+1 %>" name="D14" value="<%=data.D14 %>">
<%						if(data.T14 != null && !"".equals(data.T14)){		%>
								<select id="I14_<%=i+1 %>" name="I14" style="width: 60px" class="T14">
								<option value="">-------</option>
<%
								String dt14 = (!"".equals(WebUtil.nvl(data.I14))) ? data.I14 : data.T14;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt14.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I14_<%=i+1 %>" name="I14" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 15 ){
%>
							<td>
								<input type="hidden" id="T15_<%=i+1 %>" name="T15" value="<%=data.T15 %>">
								<input type="hidden" id="D15_<%=i+1 %>" name="D15" value="<%=data.D15 %>">
<%						if(data.T15 != null && !"".equals(data.T15)){		%>
								<select id="I15_<%=i+1 %>" name="I15" style="width: 60px" class="T15">
								<option value="">-------</option>
<%
								String dt15 = (!"".equals(WebUtil.nvl(data.I15))) ? data.I15 : data.T15;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt15.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I15_<%=i+1 %>" name="I15" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 16 ){
%>
							<td>
								<input type="hidden" id="T16_<%=i+1 %>" name="T16" value="<%=data.T16 %>">
								<input type="hidden" id="D16_<%=i+1 %>" name="D16" value="<%=data.D16 %>">
<%						if(data.T16 != null && !"".equals(data.T16)){		%>
								<select id="I16_<%=i+1 %>" name="I16" style="width: 60px" class="T16">
								<option value="">-------</option>
<%
								String dt16 = (!"".equals(WebUtil.nvl(data.I16))) ? data.I16 : data.T16;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt16.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I16_<%=i+1 %>" name="I16" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 17 ){
%>
							<td>
								<input type="hidden" id="T17_<%=i+1 %>" name="T17" value="<%=data.T17 %>">
								<input type="hidden" id="D17_<%=i+1 %>" name="D17" value="<%=data.D17 %>">
<%						if(data.T17 != null && !"".equals(data.T17)){		%>
								<select id="I17_<%=i+1 %>" name="I17" style="width: 60px" class="T17">
								<option value="">-------</option>
<%
								String dt17 = (!"".equals(WebUtil.nvl(data.I17))) ? data.I17 : data.T17;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt17.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I17_<%=i+1 %>" name="I17" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 18 ){
%>
							<td>
								<input type="hidden" id="T18_<%=i+1 %>" name="T18" value="<%=data.T18 %>">
								<input type="hidden" id="D18_<%=i+1 %>" name="D18" value="<%=data.D18 %>">
<%						if(data.T18 != null && !"".equals(data.T18)){		%>
								<select id="I18_<%=i+1 %>" name="I18" style="width: 60px" class="T18">
								<option value="">-------</option>
<%
								String dt18 = (!"".equals(WebUtil.nvl(data.I18))) ? data.I18 : data.T18;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt18.equals(data2.CODE)){ %> selected <%} %>><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I18_<%=i+1 %>" name="I18" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 19 ){
%>
							<td>
								<input type="hidden" id="T19_<%=i+1 %>" name="T19" value="<%=data.T19 %>">
								<input type="hidden" id="D19_<%=i+1 %>" name="D19" value="<%=data.D19 %>">
<%						if(data.T19 != null && !"".equals(data.T19)){		%>
								<select id="I19_<%=i+1 %>" name="I19" style="width: 60px" class="T19">
								<option value="">-------</option>
<%
								String dt19 = (!"".equals(WebUtil.nvl(data.I19))) ? data.I19 : data.T19;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt19.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I19_<%=i+1 %>" name="I19" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 20 ){
%>
							<td>
								<input type="hidden" id="T20_<%=i+1 %>" name="T20" value="<%=data.T20 %>">
								<input type="hidden" id="D20_<%=i+1 %>" name="D20" value="<%=data.D20 %>">
<%						if(data.T20 != null && !"".equals(data.T20)){		%>
								<select id="I20_<%=i+1 %>" name="I20" style="width: 60px" class="T20">
								<option value="">-------</option>
<%
								String dt20 = (!"".equals(WebUtil.nvl(data.I20))) ? data.I20 : data.T20;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt20.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I20_<%=i+1 %>" name="I20" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 21 ){
%>
							<td>
								<input type="hidden" id="T21_<%=i+1 %>" name="T21" value="<%=data.T21 %>">
								<input type="hidden" id="D21_<%=i+1 %>" name="D21" value="<%=data.D21 %>">
<%						if(data.T21 != null && !"".equals(data.T21)){		%>
								<select id="I21_<%=i+1 %>" name="I21" style="width: 60px" class="T21">
								<option value="">-------</option>
<%
								String dt21 = (!"".equals(WebUtil.nvl(data.I21))) ? data.I21 : data.T21;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt21.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I21_<%=i+1 %>" name="I21" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 22 ){
%>
							<td>
								<input type="hidden" id="T22_<%=i+1 %>" name="T22" value="<%=data.T22 %>">
								<input type="hidden" id="D22_<%=i+1 %>" name="D22" value="<%=data.D22 %>">
<%						if(data.T22 != null && !"".equals(data.T22)){		%>
								<select id="I22_<%=i+1 %>" name="I22" style="width: 60px" class="T22">
								<option value="">-------</option>
<%
								String dt22 = (!"".equals(WebUtil.nvl(data.I22))) ? data.I22 : data.T22;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt22.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I22_<%=i+1 %>" name="I22" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 23 ){
%>
							<td>
								<input type="hidden" id="T23_<%=i+1 %>" name="T23" value="<%=data.T23 %>">
								<input type="hidden" id="D23_<%=i+1 %>" name="D23" value="<%=data.D23 %>">
<%						if(data.T23 != null && !"".equals(data.T23)){		%>
								<select id="I23_<%=i+1 %>" name="I23" style="width: 60px" class="T23">
								<option value="">-------</option>
<%
								String dt23 = (!"".equals(WebUtil.nvl(data.I23))) ? data.I23 : data.T23;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt23.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I23_<%=i+1 %>" name="I23" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 24 ){
%>
							<td>
								<input type="hidden" id="T24_<%=i+1 %>" name="T24" value="<%=data.T24 %>">
								<input type="hidden" id="D24_<%=i+1 %>" name="D24" value="<%=data.D24 %>">
<%						if(data.T24 != null && !"".equals(data.T24)){		%>
								<select id="I24_<%=i+1 %>" name="I24" style="width: 60px" class="T24">
								<option value="">-------</option>
<%
								String dt24 = (!"".equals(WebUtil.nvl(data.I24))) ? data.I24 : data.T24;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt24.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I24_<%=i+1 %>" name="I24" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 25 ){
%>
							<td>
								<input type="hidden" id="T25_<%=i+1 %>" name="T25" value="<%=data.T25 %>">
								<input type="hidden" id="D25_<%=i+1 %>" name="D25" value="<%=data.D25 %>">
<%						if(data.T25 != null && !"".equals(data.T25)){		%>
								<select id="I25_<%=i+1 %>" name="I25" style="width: 60px" class="T25">
								<option value="">-------</option>
<%
								String dt25 = (!"".equals(WebUtil.nvl(data.I25))) ? data.I25 : data.T25;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt25.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I25_<%=i+1 %>" name="I25" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 26 ){
%>
							<td>
								<input type="hidden" id="T26_<%=i+1 %>" name="T26" value="<%=data.T26 %>">
								<input type="hidden" id="D26_<%=i+1 %>" name="D26" value="<%=data.D26 %>">
<%						if(data.T26 != null && !"".equals(data.T26)){		%>
								<select id="I26_<%=i+1 %>" name="I26" style="width: 60px" class="T26">
								<option value="">-------</option>
<%
								String dt26 = (!"".equals(WebUtil.nvl(data.I26))) ? data.I26 : data.T26;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt26.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I26_<%=i+1 %>" name="I26" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 27 ){
%>
							<td>
								<input type="hidden" id="T27_<%=i+1 %>" name="T27" value="<%=data.T27 %>">
								<input type="hidden" id="D27_<%=i+1 %>" name="D27" value="<%=data.D27 %>">
<%						if(data.T27 != null && !"".equals(data.T27)){		%>
								<select id="I27_<%=i+1 %>" name="I27" style="width: 60px" class="T27">
								<option value="">-------</option>
<%
								String dt27 = (!"".equals(WebUtil.nvl(data.I27))) ? data.I27 : data.T27;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt27.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I27_<%=i+1 %>" name="I27" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 28 ){
%>
							<td>
								<input type="hidden" id="T28_<%=i+1 %>" name="T28" value="<%=data.T28 %>">
								<input type="hidden" id="D28_<%=i+1 %>" name="D28" value="<%=data.D28 %>">
<%						if(data.T28 != null && !"".equals(data.T28)){		%>
								<select id="I28_<%=i+1 %>" name="I28" style="width: 60px" class="T28">
								<option value="">-------</option>
<%
								String dt28 = (!"".equals(WebUtil.nvl(data.I28))) ? data.I28 : data.T28;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt28.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I28_<%=i+1 %>" name="I28" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 29 ){
%>
							<td>
								<input type="hidden" id="T29_<%=i+1 %>" name="T29" value="<%=data.T29 %>">
								<input type="hidden" id="D29_<%=i+1 %>" name="D29" value="<%=data.D29 %>">
<%						if(data.T29 != null && !"".equals(data.T29)){		%>
								<select id="I29_<%=i+1 %>" name="I29" style="width: 60px" class="T29">
								<option value="">-------</option>
<%
								String dt29 = (!"".equals(WebUtil.nvl(data.I29))) ? data.I29 : data.T29;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt29.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I29_<%=i+1 %>" name="I29" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 30 ){
%>
							<td>
								<input type="hidden" id="T30_<%=i+1 %>" name="T30" value="<%=data.T30 %>">
								<input type="hidden" id="D30_<%=i+1 %>" name="D30" value="<%=data.D30 %>">
<%						if(data.T30 != null && !"".equals(data.T30)){		%>
								<select id="I30_<%=i+1 %>" name="I30" style="width: 60px" class="T30">
								<option value="">-------</option>
<%
								String dt30 = (!"".equals(WebUtil.nvl(data.I30))) ? data.I30 : data.T30;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt30.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I30_<%=i+1 %>" name="I30" value="">
<%						}	%>
							</td>
<%
					}

					if( titlSize >= 31 ){
%>
							<td>
								<input type="hidden" id="T31_<%=i+1 %>" name="T31" value="<%=data.T31 %>">
								<input type="hidden" id="D31_<%=i+1 %>" name="D31" value="<%=data.D31 %>">
<%						if(data.T31 != null && !"".equals(data.T31)){		%>
								<select id="I31_<%=i+1 %>" name="I31" style="width: 60px" class="T31">
									<option value="">-------</option>
<%
								String dt31 = (!"".equals(WebUtil.nvl(data.I31))) ? data.I31 : data.T31;
								for( int v = 0; v < T_TPROG.size(); v++ ){
									D40TmSchkzPlanningChartCodeData data2 = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(v);
%>
							 		<option value="<%=data2.CODE%>" <%if(dt31.equals(data2.CODE)){ %> selected <%} %> ><%=data2.CODE%></option>
<%							}	%>
								</select>
<%						}else{	%>
								<input type="hidden" id="I31_<%=i+1 %>" name="I31" value="">
<%						}	%>
							</td>
<%
					}
%>

						</tr>
<%
// 					}//end if
				} //end for...
%>
	      			</table>
				</div>
			</div>
			<div class="buttonArea">
		        <ul class="btn_crud">
		            <li><a class="darken" href="javascript:void(0);" id="save"><span><spring:message code="BUTTON.COMMON.SAVE" /><!-- 저장 --></span></a></li>
		        </ul>
		    </div>
		</div>
<%
                //부서코드 비교를 위한 값.
//                 tempDept = deptData.ORGEH;
// 			}//end if
// 		}//end for
%>
		<div class="listArea">
			<div class="listTop">
		  		<span class="listCnt">
		  			<h2 class="subtitle"><spring:message code='LABEL.D.D40.0026'/><!-- 일일근무일정 설명 --></h2>
		  		</span>
			</div>
			<div class="table">
   				<div class="wideTable">
	      			<table class="listTable">
	      				<thead>
	        			<tr>
							<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
							<th><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
							<th><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
							<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
							<th><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
							<th class="lastCol"><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
						</tr>
						</thead>
<%
						if(T_TPROG.size()%2 != 0){
							D40TmSchkzPlanningChartCodeData addDt = new D40TmSchkzPlanningChartCodeData();
							addDt.CODE = "";
							addDt.TEXT = "";
							addDt.DESC = "";
							T_TPROG.addElement(addDt);
						}
						for( int i = 0; i < T_TPROG.size(); i++ ){
							D40TmSchkzPlanningChartCodeData data = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(i);
							String tr_class = "";
		                    if(i%4 == 0){
		                        tr_class="oddRow";
		                    }else{
		                        tr_class="";
		                    }
%>
						<%if(i%2 == 0){ %>
						<tr class="<%=tr_class%>">
							<td><%=data.CODE %></td>
							<td><%=data.TEXT %></td>
							<td><%=data.DESC %></td>
						<%}else{ %>
							<td><%=data.CODE %></td>
							<td><%=data.TEXT %></td>
							<td class="lastCol"><%=data.DESC %></td>
						</tr>
						<%} %>

<%
						}
%>

					</table>
				</div>
			</div>
		</div>


<%
    }else{
%>
	<div class="listArea">
        <div class="table">
	        <div class="wideTable" >
	            <table class="listTable">
	    			 <tr>
	    			 	<td class="lastCol"><spring:message code="MSG.COMMON.0004"/></td><!-- 해당하는 데이타가 존재하지 않습니다 -->
	    			 </tr>
	            </table>
	        </div>
        </div>
    </div>
<%
    } //end if...
%>

<%
	if ( T_EXERR != null && T_EXERR.size() > 0 ) {
%>
	<div class="listArea">
		<div class="listTop">
	  		<span class="listCnt">
	  			<h2 class="subtitle">오류내역<!-- 오류내역 --></h2>
	  		</span>
		</div>
		<div class="table">
  				<div class="wideTable">
      			<table class="listTable">
      				<thead>
      				<colgroup>
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
		                <col />
		            </colgroup>
        			<tr>
						<th><!-- 사번--><spring:message code='LABEL.D.D05.0005'/></th>
						<th><!-- 이름--><spring:message code='LABEL.D.D05.0006'/></th>
						<th><!-- 일자--><spring:message code='LABEL.D.D15.0206'/></th>
						<th><!-- 오류메세지--><spring:message code='LABEL.D.D40.0023'/></th>
					</tr>
					</thead>
<%
					for( int i = 0; i < T_EXERR.size(); i++ ){
						D40TmSchkzPlanningChartNoteData data = (D40TmSchkzPlanningChartNoteData)T_EXERR.get(i);
						String tr_class = "";
	                    if(i%2 == 0){
	                        tr_class="oddRow";
	                    }else{
	                        tr_class="";
	                    }
%>
						<tr class="<%=tr_class%>">
							<td><%=data.PERNR %></td>
							<td><%=data.ENAME %></td>
							<td><%=data.DATUM.replace("-",".") %></td>
							<td class="align_left"><%=data.MSGTX %></td>
						</tr>
<%
					}
%>
					</table>
				</div>
			</div>
		</div>
<%
    } //end if...
%>


</form>

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

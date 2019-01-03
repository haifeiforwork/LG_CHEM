<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   비근무/근무, 초과근무, 사원지급정보				*/
/*   Program Name	:   일일근태 입력 현황										*/
/*   Program ID		: D40TmDaily.jsp											*/
/*   Description		: 일일근태 입력 현황										*/
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
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
	String E_INFO =  (String)request.getAttribute("E_INFO");

	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름
	String I_SCHKZ 	=  (String)request.getAttribute("I_SCHKZ");
	String E_BEGDA    = (String)request.getAttribute("E_BEGDA");	//리턴 조회시작일
	String E_ENDDA    = (String)request.getAttribute("E_ENDDA");	//리턴 조회종료일
	String I_BEGDA    = (String)request.getAttribute("I_BEGDA");	//조회시작날짜
	String I_ENDDA    = (String)request.getAttribute("I_ENDDA");	//조회종료날짜

	String searchExinfty		= (String)request.getAttribute("searchExinfty");
	String searchExinftycd	= (String)request.getAttribute("searchExinftycd");
	String searchExwtmnm	= (String)request.getAttribute("searchExwtmnm");
	String searchExwtmcd	= (String)request.getAttribute("searchExwtmcd");
	String searchExwtmpcd	= (String)request.getAttribute("searchExwtmpcd");

	if(!"".equals(I_BEGDA) && I_BEGDA != null){
		E_BEGDA = I_BEGDA;
	}
	if(!"".equals(I_ENDDA) && I_ENDDA != null){
		E_ENDDA = I_ENDDA;
	}

	Vector resultList    = (Vector)request.getAttribute("resultList");
	Vector T_EXLIST    = (Vector)request.getAttribute("T_EXLIST");	//입력현황조회
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_EXINFTY    = (Vector)request.getAttribute("T_EXINFTY");	//선택된 인포타입
	Vector T_EXWTMCD    = (Vector)request.getAttribute("T_EXWTMCD");	//선택된 유형

%>
<jsp:include page="/include/header.jsp" />

<c:set var="arrExinftycd" value="${fn:split(searchExinftycd, ',')}"/>
<c:set var="arrExwtmcd" value="${fn:split(searchExwtmcd, ',')}"/>
<c:set var="arrExwtmpcd" value="${fn:split(searchExwtmpcd, ',')}"/>

<style type="text/css">
	.pop-layer {display:none; position: absolute; top: 50%; left: 50%; width: 510px; height:auto;  background-color:#fff; border: 1px solid #DBDBDB; z-index: 10;}
	.pop-layer .pop-container {padding: 20px 25px;}
	.pop-layer p.ctxt {color: #666; line-height: 25px;}
	.pop-layer .btn-r {width: 100%; margin:10px 0 0px; padding-top: 10px; border-top: 1px solid #DDD; text-align:right;}
	.bgBlack {filter: alpha(opacity=75);opacity: 0.75;-moz-opacity: 0.75;background-color: #ffffff;height: 100%;left: 0;position: fixed;text-align: left;top: 0;width: 100%;z-index: 5;}
</style>

<script language="JavaScript">

	$(function() {

		//'닫기'버튼을 클릭하면 레이어가 사라진다.
		$('.cbtn').on("click", function(e){
			$("#layer1").hide();
			$(".bgBlack").hide();
		});

		//'확인'버튼을 클릭하면 레이어가 사라진다.
		$('.pbtn').on("click", function(e){
			proCheck();
			$("#layer1").hide();
			$(".bgBlack").hide();
		});

		var height = document.body.scrollHeight;
		parent.autoResize(height+30);

		if(height < 500){
			$("#listArea").css("height","300px");
		}

	});

	//구분 체크박스 클릭 이벤트
	$(document).on("click",".exinftyClass",function(){

		//유형 데이터를 비운다
		$("#searchExwtmnm").val("");
		$("#searchExwtmcd").val("");
		$("#searchExwtmpcd").val("");
		$("input[name=exwtmcd]:checkbox").removeProp("checked");

		//구분 text 세팅
		$("#searchExinfty").val("");
		var textval = $("#searchExinfty").val();
		var val = "";
		$('input:checkbox[name="exinfty"]').each(function() {
			if(this.checked){
				val += $(this).val()+",";								//체크박스 체크된 값들 ,로 연결
				textval += $(this).next('label').text()+",";	//체크박스 체크된 글자들 ,로 연결
			}
		});
		$("#searchExinfty").val(textval.slice(0, -1));	//구분  input text값 채우기
		$("#searchExinftycd").val(val.slice(0, -1));	//구분  input hidden값 채우기

		var html = "";
		//구분 checkbox가 체크가 되어있지 않다면 전체 검색의 의미
		//유형 레이어 팝업에 전체 항목을 세팅한다
		if($('input:checkbox[name="exinfty"]:checked').length == 0){
			$("#pop_exwtmcd").html("");
			'<c:forEach var="row" items="${T_EXWTMCD}" varStatus="status">';
				'<c:if test="${status.index%3 eq 0}">';	//레이어 팝업에 3줄씩 보여준다
			html += "<tr>";
				'</c:if>';
			html += "<td>";
			var index = '<c:out value="${status.index}" />';
			var value = '<c:out value="${row.PKEY}^${row.CODE}"/>';
			html += "	<input type='checkbox' id='exwtmcd"+index+"' name='exwtmcd' class='exwtmcdClass' value='"+value+"' ><label for='exwtmcd"+index+"'> <c:out value='${row.TEXT}'/></label>";
			html += "</td>";
				'<c:if test="${status.index%3 eq 2}">';
			html += "</tr>";
				'</c:if>';
			'</c:forEach>';
			$("#pop_exwtmcd").html(html);
		}else{	//구분 checkbox가 체크가 되어있다면 체크된 항목만 유형을 세팅한다
			var cnt = 0;
			$("#pop_exwtmcd").html("");
			'<c:forEach var="row" items="${T_EXWTMCD}" varStatus="status">';
			var index = '<c:out value="${status.index}" />';
			var value = '<c:out value="${row.PKEY}^${row.CODE}"/>';
			//val 은 위에  구분 체크박스 체크된 값들 ,로 연결된 값
			//val 에서 PKEY 가 존재하면 화면에 그려준다
			if(val.indexOf('<c:out value="${row.PKEY}"/>') > -1){
				if(cnt%3 == 0){
					html += "<tr>";
				}
				html += "<td>";
				html += "	<input type='checkbox' id='exwtmcd"+index+"' name='exwtmcd' class='exwtmcdClass' value='"+value+"' ><label for='exwtmcd"+index+"'> <c:out value='${row.TEXT}'/></label>";
				html += "</td>";
				if(cnt%3 == 2){
					html += "</tr>";
				}
				cnt++;
			}
			'</c:forEach>';
			if(cnt%3 != 0){
				html += "</tr>";
			}
			$("#pop_exwtmcd").html(html);
		}
	});

	//유형 선택 후 확인 눌렀을때
	function proCheck(){
		var exwtmcd = "";
		var searchExwtmnm = "";
		var searchExwtmpcd = "";
		var searchExwtmcd = "";
		$('input:checkbox[name="exwtmcd"]').each(function() {
			if(this.checked){
				exwtmcd = $(this).val().split("^");
				searchExwtmpcd += exwtmcd[0]+",";
				searchExwtmcd += exwtmcd[1]+",";
				searchExwtmnm += $(this).next('label').text()+",";
			}
		});
		$("#searchExwtmnm").val(searchExwtmnm.slice(0, -1));
		$("#searchExwtmpcd").val(searchExwtmpcd.slice(0, -1));
		$("#searchExwtmcd").val(searchExwtmcd.slice(0, -1));
	}

	//부서명 검색 사용안함
	function dept_search() {

		var frm = document.form1;
	    var dept_search_window=window.open("","DeptNm","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=550,height=550,left=100,top=100");
	    dept_search_window.focus();
	    frm.target = "DeptNm";
	    frm.action = "${g.jsp}"+"D/D40TmGroup/common/SearchD40DeptNamePop.jsp";
	    frm.submit();
	}


	//조직도 Popup.
	function organ_search() {

	    var frm = document.form1;
	    var organ_search_window = window.open("","organList","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=400,height=550,left=100,top=100");
	    organ_search_window.focus();
	    frm.target = "organList";
	    frm.action = "<%=WebUtil.JspURL%>"+"D/D40TmGroup/common/D40OrganSmListPop.jsp";
	    frm.submit();
	}

	//사원검색 Popup.
	function organ_search2() {
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
	}

	//사원선택 초기화
	function dt_clear(){
		$("#I_PERNR").val("");
		$("#I_ENAME").val("");
	}

	//조회
	function do_search(){

		//상단 공통 조회조건

		$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
		$("#searchDeptNm").val(parent.$("#searchDeptNm").val());

		var iSeqno = "";
		if(parent.$("#iSeqno").val() == ""){
			parent.$("#iSeqno option").each(function(){
				iSeqno += $(this).val()+",";
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

		var dt = Number(chkDt(val1, val2)+1);

		if(dt > 31){
			alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
			return;
		}else{

			parent.blockFrame();
			var vObj = document.form1;
			$("#gubun").val("SEARCH");
		    vObj.target = "_self";
		    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmDailySV";
		    vObj.method = "post";
		    vObj.submit();
		}

	}

	//val1과 val2 날짜의 차이를 구함
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

	//엑셀 다운로드
	function excelDown(){

		//상단 공통 조회조건
// 		parent.blockFrame();
		$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
		$("#searchDeptNm").val(parent.$("#searchDeptNm").val());
// 		$("#iSeqno").val(parent.$("#iSeqno").val());
// 		$("#I_SELTAB").val(parent.$("#I_SELTAB").val());

		var iSeqno = "";
		if(parent.$("#iSeqno").val() == ""){
			parent.$("#iSeqno option").each(function(){
				iSeqno += $(this).val()+",";
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
		var dt = Number(chkDt(val1, val2)+1);

		if(dt > 31){
			alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
			return;
		}else{
			var vObj = document.form1;
			$("#gubun").val("EXCEL");
		    vObj.target = "ifHidden";
		    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmDailySV";
		    vObj.method = "post";
		    vObj.submit();
		}
	}

	//잠시만 기다려주십시오.
	function waitBlockFrame() {
        $.blockUI({ message : '<spring:message code="MSG.COMMON.WAIT"/>' });
    }

	//구분 select
	function exinftyBox() {
	 	if( Div4.style.visibility == 'visible' ){
			Div4.style.visibility = 'hidden';
		} else  {
			Div4.style.visibility = 'visible';
		}
	}

	//사용안함
	function exwtmcdBox() {
	 	if( winPop.style.visibility == 'visible' ){
	 		winPop.style.visibility = 'hidden';
		} else  {
			winPop.style.visibility = 'visible';
		}
	}

	//레이어 팝업 open
	function layer_open(el){
		var temp = $('#' + el);

		$(".bgBlack").show();
		temp.show();

		if (temp.outerWidth() < $(document).width() ){ temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
		}else {temp.css('left', '0px');};
	}

</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<!-- 일일 근태 입력 현황 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D40.0096" />
</jsp:include>

<form id="form1" name="form1" method="post" target="listFrame">
    <input type="hidden" name="urlName" value="">
    <input type="hidden" name="eInfo"  value="<%=E_INFO%>">
<!--     <input type="hidden" id="I_GUBUN" name="I_GUBUN"  value=""> -->
    <input type="hidden" id="gubun" name="gubun"  value="">
	<input type="hidden" id="ISEQNO" name="ISEQNO" value="">
    <input type="hidden" id="orgOrTm" name="orgOrTm" value="">
	<input type="hidden" id="searchDeptNo" name="searchDeptNo" value="">
	<input type="hidden" id="searchDeptNm" name="searchDeptNm" value="">
	<input type="hidden" id="iSeqno" name="iSeqno" value="">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB" value="">

<div class="tableInquiry">
	<table>
		<colgroup>
			<col width="7%" /><!-- 조회기간 -->
			<col width="28%" /><!-- input -->
			<col width="7%" /><!-- 계획근무 -->
			<col width="22%" /><!--select  -->
			<col width="13%" /><!--사원선택 button  -->
			<col width="auto" /><!--조회 button  -->
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
				<select name="I_SCHKZ" id="I_SCHKZ" style="width: 90%;">
					<option value=""><spring:message code='LABEL.COMMON.0024'/><!-- 전체 --></option>
					<c:forEach  var="row" items="${T_SCHKZ}" varStatus="status">
						<option value='<c:out value="${row.CODE}"/>' <c:if test="${row.CODE eq  I_SCHKZ}">selected</c:if> ><c:out value="${row.CODE}"/> (<c:out value="${row.TEXT}"/>)</option>
					</c:forEach>
				</select>
			</td>
			<td>
				<div class="tableBtnSearch tableBtnSearch2">
            	    <a onClick="javascript:organ_search2()" class="search"><span><spring:message code='BUTTON.D.D40.0006'/><!-- 사원선택 --></span></a>
                </div>
			</td>
			<td>
				<input type="hidden" id="I_PERNR" name="I_PERNR" value="<c:out value="${I_PERNR }"/>">
				<input type="text" id="I_ENAME" name="I_ENAME" readonly="readonly"  value="<c:out value="${I_ENAME }"/>" style="width: 45%;">
				<input type="hidden" id="pageGubun" name="pageGubun" value="">
				<a class="floatLeft" onClick="javascript:dt_clear();" style="cursor: pointer;"><img src="/web/images/eloffice/images/ico/ico_inline_reset.png" alt="초기화"/></a>
                <div class="tableBtnSearch tableBtnSearch2">
                	<a href="javascript:do_search();" class="search"><span><spring:message code="BUTTON.COMMON.SEARCH"/><!-- 조회 --></span></a>
                </div>
            </td>
        </tr>
        <tr>
        	<th>
	        	<spring:message code="LABEL.D.D02.0003"/><!-- 구분 -->
	        </th>
	        <td>
				<table cellpadding='0' cellspacing='0' style='cursor:hand'>
					<tr>
						<td width='160' height='20'>
							<input type="text" id="searchExinfty" name="searchExinfty" style="width:150;height:20px; background-color: #ffffff" value="<%=searchExinfty %>" readonly>
							<input type="hidden" id="searchExinftycd" name="searchExinftycd" value="<%=searchExinftycd%>">
                         		<input type="button" style="background:url(<%= WebUtil.ImageURL %>/ehr_common/select_btbg.gif);width:18px;height:23px;margin-left:-5px;border:0;cursor:hand" value="" onClick="exinftyBox()" >
                         	</td>
                        </tr>
				</table>
				<div id='Div4'  style='margin-left:5px; width:140px; position:absolute;visibility:hidden;border:1px solid #DBDBDB; background-color:#ffffff; z-index: 1;' >
					<c:forEach var="row" items="${T_EXINFTY}" varStatus="status">
						<input type='checkbox' id='exinfty<c:out value="${status.index}"/>' name='exinfty' class="exinftyClass" value='<c:out value="${row.CODE}"/>'
						<c:forEach var="arr" items="${arrExinftycd}" varStatus="i">
							 <c:if test="${row.CODE eq arr }">checked</c:if>
						</c:forEach>
						><label for='exinfty<c:out value="${status.index}"/>'> <c:out value="${row.TEXT}"/></label><br/>
					</c:forEach>
				</div>
			</td>
        	<th>
	        	<spring:message code="LABEL.D.D40.0052"/><!-- 유형 -->
	        </th>
	        <td>
				<table cellpadding='0' cellspacing='0' style='cursor:hand'>
					<tr>
						<td width='160' height='20'>
							<input type="text" id="searchExwtmnm" name="searchExwtmnm" style="width:150;height:20px; background-color: #ffffff" value="<%=searchExwtmnm %>" readonly>
							<input type="hidden" id="searchExwtmcd" name="searchExwtmcd" value="<%=searchExwtmcd %>" >
							<input type="hidden" id="searchExwtmpcd" name="searchExwtmpcd" value="<%=searchExwtmpcd %>" >
                        	<input type="button" style="background:url(<%= WebUtil.ImageURL %>/ehr_common/select_btbg.gif);width:18px;height:23px;margin-left:-5px;border:0;cursor:hand" value="" onclick="layer_open('layer1');return false;" >
                        </td>
                	</tr>
				</table>
				<div class="bgBlack" style="display: none;"></div>
				<div id="layer1" class="pop-layer">
					<div class="pop-container">
						<div class="pop-conts">
							<table id="pop_exwtmcd">
								<c:set var="count" value="0"/>

								<c:forEach var="row" items="${T_EXWTMCD}" varStatus="status">
									<c:if test="${not empty searchExinftycd}">
										<c:forEach var="arrPkey" items="${arrExinftycd}" varStatus="j">
											<c:if test="${row.PKEY eq arrPkey}">
												<c:if test="${count%3 eq 0}"><tr></c:if>
												<td>
													<input type='checkbox' id='exwtmcd<c:out value="${status.index}"/>' name='exwtmcd' class='exwtmcdClass' value='<c:out value="${row.PKEY}^${row.CODE}"/>'
													<c:forEach var="arr" items="${arrExwtmcd}" varStatus="i">
														<c:if test="${row.CODE eq arr }">checked</c:if>
													</c:forEach>
													><label for='exwtmcd<c:out value="${status.index}"/>'> <c:out value="${row.TEXT}"/></label>
												</td>
												<c:if test="${count%3 eq 2}"></tr></c:if>
												<c:set var="count" value="${count + 1}"/>
											</c:if>
										</c:forEach>
									</c:if>
									<c:if test="${empty searchExinftycd}">
										<c:if test="${count%3 eq 0}"><tr></c:if>
										<td>
											<input type='checkbox' id='exwtmcd<c:out value="${status.index}"/>' name='exwtmcd' class='exwtmcdClass' value='<c:out value="${row.PKEY}^${row.CODE}"/>'
											<c:forEach var="arr" items="${arrExwtmcd}" varStatus="i">
												<c:if test="${row.CODE eq arr }">checked</c:if>
											</c:forEach>
											><label for='exwtmcd<c:out value="${status.index}"/>'> <c:out value="${row.TEXT}"/></label>
										</td>
										<c:if test="${count%3 eq 2}"></tr></c:if>
										<c:set var="count" value="${count + 1}"/>
									</c:if>
								</c:forEach>
								<c:if test="${count%3 ne 0}"></tr></c:if>
							</table>
							<div class="btn-r">
							<div class="buttonArea" >
						  		<ul class="btn_crud">
						  			<li><a href="javascript:void(0);" class="darken pbtn"><span><spring:message code="BUTTON.COMMON.CONFIRM" /></span></a></li>
						  			<li><a href="javascript:void(0);" class="cbtn"><span><spring:message code="BUTTON.COMMON.CLOSE"/></span></a></li>
						  		</ul>
						  	</div>
							</div>
<!-- 								<a href="#" class="pbtn">확인</a> -->
<!-- 								<a href="#" class="cbtn">닫기</a> -->
<!-- 							</div> -->
							<!--// content-->
						</div>
					</div>
				</div>
			</td>
			<td>
			</td>
        </tr>
    </table>
</div>


<div class="listArea" id="listArea">
	<div class="listTop">
		<span class="listCnt"><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(T_EXLIST)}' /></span>
        <div class="buttonArea">
	    	<ul class="btn_mdl displayInline" style="margin-left: 10px;">
	       		<li><a href="javascript:excelDown();"><span><!-- 엑셀다운로드 --><spring:message code="BUTTON.D.D40.0002" /></span></a></li>
	        </ul>
		</div>
	</div>

    <div class="table">
    	<table class="listTable" id="tmGroupTable">
      		<colgroup>
            	<col width=6%/>
				<col width=6%/>
				<col width=10%/>
				<col width=6%/>
				<col width=6%/>
				<col width=5%/>
				<col width=5%/>
				<col width=5%/>
				<col width=5%/>
				<col width=5%/>
				<col width=5%/>
				<col width=5%/>
				<col width=10%/>
				<col width=9%/>
				<col width=6%/>
				<col width=6%/>
			</colgroup>
            <thead>
            	<tr>
                	<th><!-- 사번--><spring:message code="LABEL.D.D12.0017"/></th>
					<th><!-- 이름--><spring:message code="LABEL.D.D12.0018"/></th>
           			<th><!-- 유형 --><spring:message code='LABEL.D.D40.0052' /></th>
           			<th><!-- 시작일--><spring:message code="LABEL.D.D15.0152"/></th>
					<th><!-- 종료일--><spring:message code="LABEL.D.D15.0153"/></th>
           			<th><!-- 시작시간--><spring:message code="LABEL.D.D12.0020"/></th>
					<th><!-- 종료시간--><spring:message code="LABEL.D.D12.0021"/></th>
					<th><!-- 휴식시간1--><spring:message code="LABEL.D.D12.0068"/></th>
					<th><!-- 휴식종료1--><spring:message code="LABEL.D.D12.0069"/></th>
					<th><!-- 휴식시간2--><spring:message code="LABEL.D.D12.0070"/></th>
					<th><!-- 휴식종료2--><spring:message code="LABEL.D.D12.0071"/></th>
					<th><!-- 근무시간 수--><spring:message code="LABEL.D.D40.0162"/></th>
					<th><!-- 사유--><spring:message code="LABEL.D.D12.0024"/></th>
					<th><!-- 상세사유--><spring:message code="LABEL.D.D40.0053"/></th>
					<th><!-- 최종변경일--><spring:message code="LABEL.D.D40.0054"/></th>
          			<th class="lastCol"><spring:message code="LABEL.D.D40.0055"/><!-- 최종변경자 --></th>
                </tr>
            </thead>
<%
	if(T_EXLIST.size() > 0){
	   for ( int i = 0 ; i < T_EXLIST.size() ; i++ ) {
		   D40TmDailyData data = ( D40TmDailyData ) T_EXLIST.get( i ) ;

		   String BEGUZ = "";
			if(!"".equals(data.BEGUZ)){
				if(data.BEGUZ.length() > 3){
					String bun = (!"24".equals(data.BEGUZ.substring(0,2)))?data.BEGUZ.substring(0,2):"00";
					BEGUZ = bun+":"+data.BEGUZ.substring(2,4);
				}
			}
			String ENDUZ = "";
			if(!"".equals(data.ENDUZ)){
				if(data.ENDUZ.length() > 3){
					String bun = (!"24".equals(data.ENDUZ.substring(0,2)))?data.ENDUZ.substring(0,2):"00";
					ENDUZ = bun+":"+data.ENDUZ.substring(2,4);
				}
			}
			String PBEG1 = "";
			if(!"".equals(data.PBEG1)){
				if(data.PBEG1.length() > 3){
					String bun = (!"24".equals(data.PBEG1.substring(0,2)))?data.PBEG1.substring(0,2):"00";
					PBEG1 = bun+":"+data.PBEG1.substring(2,4);
				}
			}
			String PEND1 = "";
			if(!"".equals(data.PEND1)){
				if(data.PEND1.length() > 3){
					String bun = (!"24".equals(data.PEND1.substring(0,2)))?data.PEND1.substring(0,2):"00";
					PEND1 = bun+":"+data.PEND1.substring(2,4);
				}
			}
			String PBEG2 = "";
			if(!"".equals(data.PBEG2)){
				if(data.PBEG2.length() > 3){
					String bun = (!"24".equals(data.PBEG2.substring(0,2)))?data.PBEG2.substring(0,2):"00";
					PBEG2 = bun+":"+data.PBEG2.substring(2,4);
				}
			}
			String PEND2 = "";
			if(!"".equals(data.PEND2)){
				if(data.PEND2.length() > 3){
					String bun = (!"24".equals(data.PEND2.substring(0,2)))?data.PEND2.substring(0,2):"00";
					PEND2 = bun+":"+data.PEND2.substring(2,4);
				}
			}
%>
			<tr class="<%=WebUtil.printOddRow(i)%>" >
            	<td><%=data.PERNR %></td>
                <td><%=data.ENAME %></td>
                <td><%=data.WTMCODE_TX %></td>
                <td>
                	<%if(!"0000-00-00".equals(data.BEGDA)){ %>
                  		<%=data.BEGDA.replace("-",".") %>
                  	<%} %>
                </td>
                <td>
                	<%if(!"0000-00-00".equals(data.ENDDA)){ %>
                  		<%=data.ENDDA.replace("-",".") %>
                  	<%} %>
                </td>
                <td><%=BEGUZ%></td>
                <td><%=ENDUZ%></td>
                <td><%=PBEG1%></td>
                <td><%=PEND1%></td>
                <td><%=PBEG2%></td>
                <td><%=PEND2%></td>
                <td>
                	<%if(!"0".equals(data.STDAZ)){ %>
                		<%=data.STDAZ%>
                	<%}else{ %>
                		-
                	<%} %>
                </td>
                <td><%=data.REASON_TX %></td>
                <td><%=data.DETAIL%></td>
                <td>
                	<%if(!"0000-00-00".equals(data.AEDTM_TX)){ %>
                		<%=data.AEDTM_TX.replace("-",".")%>
                	<%} %>
                </td>
               	<td class="lastCol"><%=data.UNAME_TX %></td>
            </tr>
<%
		}
	}else{
%>
			<tr class="oddRow" >
				<td class="lastCol" colspan="16"><spring:message code="MSG.COMMON.0004"/></td>
			</tr>
<%
	}
%>
		</table>
	</div>
</div>
        <!-- 조회 리스트 테이블 끝-->

<!-- <div class="frameWrapper">
	TAB 프레임
	<iframe id="listFrame" name="listFrame" onload="resizeIframe(this);" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
</div> -->

</form>

<iframe name="ifHidden" width="0" height="0" /></iframe>
</body>
<jsp:include page="/include/footer.jsp" />

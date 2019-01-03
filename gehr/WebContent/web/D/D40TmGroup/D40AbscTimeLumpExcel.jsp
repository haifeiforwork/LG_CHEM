<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   비근무/근무												*/
/*   Program Name	:   비근무/근무(일괄)										*/
/*   Program ID		: D40AbscTimeLumpExcel.jsp							*/
/*   Description		: 비근무,근무(일괄) 										*/
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

<%@ include file="/web/common/commonProcess.jsp" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명

	Vector vt    = (Vector)request.getAttribute("OBJPS_OUT3");		//유형	코드-텍스트
	Vector vt1    = (Vector)request.getAttribute("OBJPS_OUT4");		//사유	코드-텍스트
	Vector dataList    = (Vector)request.getAttribute("OBJPS_OUT1");		//조회된정보

	String E_INFO    = WebUtil.nvl((String)request.getAttribute("E_INFO"));	//리턴코드
	if("".equals(E_INFO)){
		E_INFO = "&nbsp;";
	}
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_SAVE_CNT    = WebUtil.nvl((String)request.getAttribute("E_SAVE_CNT"));	//저장메세지
	String textChange    = WebUtil.nvl((String)request.getAttribute("textChange"));	//저장메세지

	String gubun		= WebUtil.nvl(request.getParameter("gubun"));

%>
<jsp:include page="/include/header.jsp" />
<c:set var="eInfo" value="<%=E_INFO%>"/>

<script language="JavaScript">

<%
	if("Y".equals(textChange)){
%>
	parent.$("#searchOrg_ment").html('<font color="red"><strong><c:out value="${eInfo }"/></strong></font>');
<%
	}
%>

<%
if("SAVE".equals(gubun)){
	if(!"".equals(E_SAVE_CNT) && E_SAVE_CNT != null){
%>
		alert('<%=E_SAVE_CNT%>');
<%
	}
}
%>

	var regExp = new RegExp(/^([1-9]|[01][0-9]|2[0-3])([0-5][0-9])$/);


	function selectSearchList( index, value1, value2){	//no, PKEY, WTMCODE
<%
	if( vt1 != null && vt1.size() > 0 ){
%>
		var selectList = '<option value=""><spring:message code="LABEL.D.D11.0047"/></option>';
		var code;
		var text;
<%
		for( int i = 0; i < vt1.size(); i++ ) {
			D40AbscTimeFrameData data = (D40AbscTimeFrameData)vt1.get(i);
%>
		if(value1 == '<%=data.PKEY%>'){
			code = '<%=data.CODE%>';
			text = '<%=data.TEXT%>';
			if(value2 == code){
// 				selectList += '<option value="'+code+'" selected>'+code+' ('+text+')</option>';
				selectList += '<option value="'+code+'" selected>'+text+'</option>';
			}else{
// 				selectList += '<option value="'+code+'">'+code+' ('+text+')</option>';
				selectList += '<option value="'+code+'">'+text+'</option>';
			}
		}
<%
		}
	}else{
%>
		var selectList = '<option value=""><spring:message code="LABEL.D.D11.0047"/></option>';
<%
	}
%>
		return selectList;
	}


	function selectList2( index, value1, value2, display){	//no, PKEY, WTMCODE, REASON_YN
	<%
		if( vt1 != null && vt1.size() > 0 ){
	%>
			var dis = "";
			if(display != "Y"){
				dis = 'disabled="disabled"';
			}

			var selectList = '<select id="REASON'+index+'" name="REASON" '+dis+' style="width: 50%; margin-top: 5px;"><option value=""><spring:message code="LABEL.D.D11.0047"/></option>';
			var code;
			var text;
	<%
			for( int i = 0; i < vt1.size(); i++ ) {
				D40AbscTimeFrameData data = (D40AbscTimeFrameData)vt1.get(i);
	%>
				if(value1 == '<%=data.PKEY%>'){
					code = '<%=data.CODE%>';
					text = '<%=data.TEXT%>';
					if(value2 == code){
// 						selectList += '<option value="'+code+'" selected>'+code+' ('+text+')</option>';
						selectList += '<option value="'+code+'" selected>'+text+'</option>';
					}else{
// 						selectList += '<option value="'+code+'">'+code+' ('+text+')</option>';
						selectList += '<option value="'+code+'">'+text+'</option>';
					}
				}
	<%
			}
	%>
			selectList += '</select>';
	<%
		}else{
	%>
	var selectList = '<select id="REASON'+index+'" name="REASON" style="width: 50%; margin-top: 5px;"><option value="">선택</option></select>';
	<%
		}
	%>
		return selectList;
	}

	function selectList1(index, value){
		<%
			if( vt != null && vt.size() > 0 ){
		%>
				var selectList = '<select id="WTMCODE'+index+'" name="WTMCODE" style="width: 95%; margin-top: 5px;"><option value=""><spring:message code="LABEL.D.D11.0047"/></option>';
				var code;
				var text;
		<%
				for( int i = 0; i < vt.size(); i++ ) {
					D40AbscTimeFrameData data = (D40AbscTimeFrameData)vt.get(i);
		%>
						code = '<%=data.CODE%>';
						text = '<%=data.TEXT%>';
						if(value == code){
// 							selectList += '<option value="'+code+'" selected>'+code+' ('+text+')</option>';
							selectList += '<option value="'+code+'" selected>'+text+'</option>';
						}else{
// 							selectList += '<option value="'+code+'">'+code+' ('+text+')</option>';
							selectList += '<option value="'+code+'">'+text+'</option>';
						}
		<%
				}
		%>
						selectList+='</select>';
		<%
			}else{
		%>
				var selectList = '<select id="WTMCODE'+index+'" name="WTMCODE" style="width: 50%; margin-top: 5px;"><option value=""><spring:message code="LABEL.D.D03.0033"/></option></select>';
		<%
			}
		%>
			return selectList;
	}

	function textCh(val, id){

		if(id == "END" && val == "2400"){
			val = "0000";
		}
		val = val + "";
		var point = val.length % 2;
        var len = val.length;
		str = val.substring(0, point);
        while (point < len) {
            if (str != "") str += ":";
            str += val.substring(point, point + 2);
            point += 2;
        }
		return str;
	}

	function afterUploadProcess(data, state, msg) {
		data = JSON.parse(data);
		$("#-excel-result-tbody").html("");
		alert(msg);
		var html = "";
		var index = 1;
		var end = "END";
		_.each(data.resultList, function(row) {
			var chk = "";
			var cls = index % 2 == 1 ? "oddRow" : "";
			var select1 = selectList1(index, row.WTMCODE);
			var select2 = selectList2(index, row.WTMCODE, row.REASON, row.REASON_YN);

			html += '<tr class="'+cls+'">';
			html +=		'<td>'+index+'<input type="hidden" id="TIME_YN'+index+'" name="TIME_YN" value="'+row.TIME_YN+'"></td>';
			html +=		'<td>'+row.PERNR+'<input type="hidden" id="PERNR'+index+'" name="PERNR" value="'+row.PERNR+'"></td>';
			html +=		'<td>'+row.ENAME+'<input type="hidden" id="ENAME'+index+'" name="ENAME" value="'+row.ENAME+'"></td>';
			html +=		'<td>'+select1+'</td>';
						if("0000-00-00" == row.BEGDA){
			html +=		'<td><input type="text"  class="date" id="BEGDA'+index+'" name="BEGDA" value="" size="15" style="margin-right: 4px"></td>';
						}else{
			html +=		'<td><input type="text"  class="date" id="BEGDA'+index+'" name="BEGDA" value="'+row.BEGDA.replace(/-/g, '.')+'" size="15" style="margin-right: 4px"></td>';
						}
						if("0000-00-00" == row.ENDDA){
			html +=		'<td><input type="text"  class="date" id="ENDDA'+index+'" name="ENDDA" value="" size="15" style="margin-right: 4px"></td>';
						}else{
			html +=		'<td><input type="text"  class="date" id="ENDDA'+index+'" name="ENDDA" value="'+row.ENDDA.replace(/-/g, '.')+'" size="15" style="margin-right: 4px"></td>';
						}
			html +=		'<td id="td_TPROG'+index+'">'+row.TPROG+'</td>';
						if(row.TIME_YN == "Y"){	//시간입력 필수
			html +=		'<td><input type="text" class="eTime" id="BEGUZ'+index+'" name="BEGUZ" value="'+textCh(row.BEGUZ)+'" style="width: 35px;" maxlength="4"></td>';
			html +=		'<td><input type="text" class="eTime" id="ENDUZ'+index+'" name="ENDUZ" value="'+textCh(row.ENDUZ, end)+'" style="width: 35px;" maxlength="4"></td>';
						}else{
			html +=		'<td>'+
								'<input type="text" class="eTime" id="BEGUZ'+index+'" name="BEGUZ" disabled="disabled" value="'+textCh(row.BEGUZ)+'" style="width: 35px;" maxlength="4">'+
							'</td>';
			html +=		'<td>'+
								'<input type="text" class="eTime" id="ENDUZ'+index+'" name="ENDUZ" disabled="disabled" value="'+textCh(row.ENDUZ, end)+'" style="width: 35px;" maxlength="4">'+
							'</td>';
						}
		if(row.DETAIL_YN == "Y"){	//상세사유 필수
			html +=		'<td style="text-align: left;" id="td'+index+'">'+
								select2+' <input type="text" id="DETAIL'+index+'" name="DETAIL"  value="'+row.DETAIL+'" style="width: 44%; margin-bottom: 6px;">'+
								'<input type="hidden" id="REASON_YN'+index+'" name="REASON_YN"  value="'+row.REASON_YN+'">'+
								'<input type="hidden" id="DETAIL_YN'+index+'" name="DETAIL_YN"  value="'+row.DETAIL_YN+'">'+
							'</td>';

		}else{
			html +=		'<td style="text-align: left;" id="td'+index+'">'+
								select2+' <input type="text" id="DETAIL'+index+'" name="DETAIL" disabled="disabled" value="'+row.DETAIL+'" style="width: 44%; margin-bottom: 6px;">'+
								'<input type="hidden" id="REASON_YN'+index+'" name="REASON_YN"  value="'+row.REASON_YN+'">'+
								'<input type="hidden" id="DETAIL_YN'+index+'" name="DETAIL_YN"  value="'+row.DETAIL_YN+'">'+
							'</td>';
		}
			html +=		'<td id="td_REASON'+index+'" style="display:none;">';
		if(row.REASON_YN != "Y"){
			html +=		'<input type="hidden" id="REASON'+index+'" name="REASON"  value="'+row.REASON+'">';
		}
			html +=		'</td>';
			html +=		'<td id="td_DETAIL'+index+'" style="display:none;">';
		if(row.DETAIL_YN != "Y"){
			html +=			'<input type="hidden" id="DETAIL'+index+'" name="DETAIL"  value="'+row.DETAIL+'">';
		}
			html +=		'</td>';
			html +=		'<td id="td_TIME'+index+'" style="display:none;">';
		if(row.TIME_YN != "Y"){
			html +=			'<input type="hidden" id="BEGUZ'+index+'" name="BEGUZ" value="'+textCh(row.BEGUZ)+'" >';
			html +=			'<input type="hidden" id="ENDUZ'+index+'" name="ENDUZ" value="'+textCh(row.ENDUZ)+'" >';
		}
			html +=		'</td>';
			html +=		'<td style="display:none;">';
			html +=			'<input type="hidden" id="EDIT'+index+'" name="EDIT"  value="'+row.EDIT+'">';
			html +=			'<input type="hidden" id="AWART'+index+'" name="AWART"  value="'+row.AWART+'">';
			html +=			'<input type="hidden" id="INFTY'+index+'" name="INFTY"  value="'+row.INFTY+'">';
			html += '			<input type="hidden" id="CHKDT'+index+'" name="CHKDT" value="X">';
			html += '			<input type="hidden" id="TPROG'+index+'" name="TPROG" value="'+row.TPROG+'">';
			html += '			<input type="hidden" id="MSG'+index+'" name="MSG" value="">';
			html +=		'</td>';
			html +=		'<td class="lastCol" style="text-align : left">'+row.MSG+'</td>';
			html +=	'</tr>';
			index++;
		});
		if(state == "M"){
			html = '<tr><td class="lastCol" colspan="11"><spring:message code="MSG.D.D40.0012"/></td></tr>';	/* 전체 데이터가 성공적으로 처리되었습니다. */
		}
		$("#-excel-result-tbody").append(html);

		afterChk();
	}

	function afterChk(){

		$('.date').each(function(){
			addDatePicker($('.date'));
			$(this).mask("9999.99.99");
		});

		$(".eTime").blur(function(){
			if($.trim($(this).val()) == ""){
				return;
			}
			if($.trim($(this).val()).length < 4){
				alert('<spring:message code="MSG.D.D40.0016"/>'); /* 올바른 시간을 입력해주십시오.(예 0930, 0030) */
				return;
			}
	        var isValidrunningTime = regExp.test($.trim($(this).val()).replace(/\:/g,''));
	        if( isValidrunningTime == false ){
	        	alert('<spring:message code="MSG.D.D40.0016"/>'); /* 올바른 시간을 입력해주십시오.(예 0930, 0030) */
	        }else{
	        	$(this).val(textCh($.trim($(this).val()).replace(/\:/g,'')));
	        }
		});

		$(".eTime").focus(function(){
			$(this).val($(this).val().replace(/\:/g,''));
			$(this).select();
		});

		//REASON
		$("select[name=REASON]").on("change", function(){
			var cnt = 0;
			var id = $(this).attr("id");
			var no = $(this).attr("id").substring(6);

			var code = $("#WTMCODE"+no).val()+$(this).val();
			//기타인 경우 상세사유 입력하게
			'<c:forEach var="row" items="${OBJPS_OUT5}" varStatus="i">';
				if('<c:out value="${row.PKEY}"/>'+'<c:out value="${row.CODE}"/>' == code){
					cnt++;
				}
			'</c:forEach>';

			if($("#EDIT"+no).val() == "X"){
				if(cnt != 0){
					$("#DETAIL"+no).attr('disabled', false);
					$("#td_DETAIL"+no).html("");
				}else{
					if($("#DETAIL_YN"+no).val() == "N"){
						$("#DETAIL"+no).attr('disabled', true);
						$("#td_DETAIL"+no).html("<input type='hidden' id='DETAIL"+no+"' name='DETAIL'  value='' >");
					}else{
						$("#DETAIL"+no).attr('disabled', false);
						$("#td_DETAIL"+no).html("");
					}
				}
			}
		}).change();

		$('select[name="WTMCODE"]').change(function(e) {
 			if($(this).val() == ""){return;}
			var no = $(this).attr("id").substring(7);
			if($("#BEGDA"+no).val() == ""){return;}
			if($("#PERNR"+no).val() != ""){
				parent.blockFrame();
				$("#gubun").val("SEARCHONE");
				$("#searchPERNR").val($("#PERNR"+no).val());
				$("#searchBEGDA").val($("#BEGDA"+no).val());
				$("#searchWTMCODE").val($(this).val());
				$("#no").val(no);
				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40AbscTimeLumpSV");
			    $("#form1").attr("target", "ifHidden");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
	 		}
		});

		$(".date").change(function(){
  			var id = $(this).attr("id").substring(0,5);
			var no = $(this).attr("id").substring(5);

			if(id == "BEGDA"){
  				$("#ENDDA"+no).val($(this).val());
  			}
  			if($(this).val()==""){return;}
  			if(id == "ENDDA"){return;}
  			if($("#WTMCODE"+no).val()==""){return;}
			if($("#PERNR"+no).val() != ""){
				parent.blockFrame();
				$("#gubun").val("SEARCHONE");
				$("#searchPERNR").val($("#PERNR"+no).val());
				$("#searchBEGDA").val($(this).val());
				$("#searchWTMCODE").val($("#WTMCODE"+no).val());
				$("#no").val(no);
				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40AbscTimeLumpSV");
			    $("#form1").attr("target", "ifHidden");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
	 		}
		});

		var height = document.body.scrollHeight;
		parent.autoResize(height);

	}



	function validation(){

		var chk = true;
		if($("input[name=PERNR]").length == 0){
			alert('<spring:message code="MSG.D.D40.0028"/>');	/* 저장할 내역이 존재하지 않습니다. */
			chk = false;
			return false;
		}

		$("input[name=PERNR]").each(function(idx){
			var no = $(this).attr("id").substring(5);

			var ename = $("#ENAME"+no).val() !="" ? "("+$("#ENAME"+no).val()+")" : "";
			var target = $("#PERNR"+no).val()+ename;

			if($.trim($("#WTMCODE"+no).val()) == ""){
				alert(target+'<spring:message code="MSG.D.D40.0030"/>');	/* 의 유형선택은 필수입니다. */
				$("#WTMCODE"+no).focus();
				chk = false;
				return false;
			}
			if($.trim($("#BEGDA"+no).val()) == ""){
				alert(target+'<spring:message code="MSG.D.D40.0031"/>');	/* 의 시작일은 필수입니다. */
				$("#BEGDA"+no).focus();
				chk = false;
				return false;
			}
			if($.trim($("#ENDDA"+no).val()) == ""){
				alert(target+'<spring:message code="MSG.D.D40.0032"/>');	/* 의 종료일은 필수입니다. */
				$("#ENDDA"+no).focus();
				chk = false;
				return false;
			}
			if($.trim($("#TIME_YN"+no).val()) == "Y"){
				if($.trim($("#BEGUZ"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0020"/>');	/* 의 시작시간은 필수입니다. */
					$("#BEGUZ"+no).focus();
					chk = false;
					return false;
				}
				if($.trim($("#ENDUZ"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0021"/>');	/* 의 종료시간은 필수입니다. */
					$("#ENDUZ"+no).focus();
					chk = false;
					return false;
				}
			}

			if($.trim($("#BEGUZ"+no).val()) != "" && $("#BEGUZ"+no).val().length != 5){
				alert(target+'<spring:message code="MSG.D.D40.0041"/>');		/* 의 시작시간을 정확히 입력해 주십시오(예 0930, 0030) */
				chk = false;
				return false;
			}
			if($.trim($("#ENDUZ"+no).val()) != "" && $("#ENDUZ"+no).val().length != 5){
				alert(target+'<spring:message code="MSG.D.D40.0042"/>');		/* 의 종료시간을 정확히 입력해 주십시오(예 0930, 0030) */
				chk = false;
				return false;
			}

			if($.trim($("#REASON_YN"+no).val()) == "Y"){
				if($.trim($("#REASON"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0026"/>');	/* 의 사유코드는 필수입니다. */
					$("#REASON"+no).focus();
					chk = false;
					return false;
				}
			}
			if($.trim($("#DETAIL_YN"+no).val()) == "Y"){
				if($.trim($("#DETAIL"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0027"/>');	/* 의 상세사유는 필수입니다. */
					$("#DETAIL"+no).focus();
					chk = false;
					return false;
				}
			}else{
				//상세사유가 필수는 아니지만... 사유를 특정한 기타 선택 시  상세 사유 필수 입력 체크
				var cnt = 0;
				var code = $("#WTMCODE"+no).val()+$("#REASON"+no).val();
				'<c:forEach var="row" items="${OBJPS_OUT5}" varStatus="i">';
					if('<c:out value="${row.PKEY}"/>'+'<c:out value="${row.CODE}"/>' == code){
						cnt++;
					}
				'</c:forEach>';

				if(cnt > 0){
					if($.trim($("#DETAIL"+no).val()) == ""){
						alert(target+'<spring:message code="MSG.D.D40.0027"/>');	/* 의 상세사유는 필수 입니다. */
						$("#DETAIL"+no).focus();
						chk = false;
						return false;
					}
				}
			}

		});
		return chk;
	}

	$(function() {

		afterChk();

		//엑셀다운로드
		$("#excelDown").click(function(){
			$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
			$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
			$("#searchDeptNm").val(parent.$("#searchDeptNm").val());
			var iSeqno = "";
			if(parent.$("#iSeqno").val() == ""){
				parent.$("select option").each(function(){
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

			$("#I_ACTTY").val("T");
			$("#gubun").val("EXCEL");

			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40AbscTimeLumpSV");
		    $("#form1").attr("target", "ifHidden");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});

		//엑셀업로드팝업
		$("#excelUpload").click(function(){
			var small_window = window.open('<c:out value="${g.servlet}"/>hris.D.D40TmGroup.D40AbscTimeFileUploadSV?',
					"ScheduleExcelUpload","width=440,height=300,left=365,top=70,scrollbars=no");
			small_window.focus();
		});

		//저장
		$("#do_save, #save").click(function(){
			if(validation()){
				parent.saveBlockFrame();
				$("#gubun").val("SAVE");

				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40AbscTimeLumpSV");
			    $("#form1").attr("target", "_self");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

	});

</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<form id="form1" name="form1" method="post" onsubmit="return false">
	<input type="hidden" id="orgOrTm" name="orgOrTm" value="">
	<input type="hidden" id="searchDeptNo" name="searchDeptNo" value="">
	<input type="hidden" id="searchDeptNm" name="searchDeptNm" value="">
	<input type="hidden" id="searchPERNR" name="searchPERNR" value="">
	<input type="hidden" id="searchBEGDA" name="searchBEGDA" value="">
	<input type="hidden" id="searchWTMCODE" name="searchWTMCODE" value="">
	<input type="hidden" id="no" name="no" value="">
	<input type="hidden" id="iSeqno" name="iSeqno" value="">
	<input type="hidden" id="ISEQNO" name="ISEQNO" value="">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB" value="">
	<input type="hidden" id="I_ACTTY" name="I_ACTTY" value="">
	<input type="hidden" id="gubun" name="gubun" value="">

	<div class="listArea">
		<div class="listTop">
			<span class="listCnt"><font color="red"><strong><spring:message code="LABEL.D.D40.0022"/></strong></font></span>
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a class="search" href="javascript:void(0);" id="excelDown"><span><!-- Excel Template --><spring:message code="BUTTON.D.D40.0005"/></span></a></li>
					<li><a class="search" href="javascript:void(0);" id="excelUpload"><span><!-- 엑셀업로드--><spring:message code="LABEL.D.D13.0020"/></span></a></li>
					<li><a class="darken" href="javascript:void(0);" id="do_save"><span><!-- 저장 --><spring:message code="BUTTON.COMMON.SAVE" /></span></a></li>
				</ul>
			</div>
			<div class="clear"> </div>
		</div>

		<div class="table">
			<div class="wideTable" >
				<table class="listTable">
					<colgroup>
						<col width="3%" />
						<col width="6%" />
						<col width="5%" />
						<col width="14%" />
						<col width="13%" />
						<col width="13%" />
						<col width="7%" />
						<col width="5%" />
						<col width="5%" />
						<col />
						<col width="10%" />
					</colgroup>
					<thead>
					<tr>
						<th><!-- 라인--><spring:message code="LABEL.D.D12.0084"/></th>
						<th><!-- 사번--><spring:message code="LABEL.D.D12.0017"/></th>
						<th><!-- 이름--><spring:message code="LABEL.D.D12.0018"/></th>
						<th><!-- 유형선택--><spring:message code="LABEL.D.D12.0019"/></th>
						<th><!-- 시작일--><spring:message code="LABEL.D.D15.0152"/></th>
						<th><!-- 종료일--><spring:message code="LABEL.D.D15.0153"/></th>
						<th><!-- 일일근무일정(시작일기준)--><spring:message code="LABEL.D.D40.0066"/></th>
						<th><!-- 시작시간--><spring:message code="LABEL.D.D12.0020"/></th>
						<th><!-- 종료시간--><spring:message code="LABEL.D.D12.0021"/></th>
						<th><!-- 사유--><spring:message code="LABEL.D.D12.0024"/></th>
						<th class="lastCol" " ><!-- 오류메세지--><spring:message code="LABEL.D.D40.0023"/></th>
					</tr>
					</thead>
					<tbody id="-excel-result-tbody">
<%
					if( dataList != null && dataList.size() > 0 ){
						for( int i = 0; i < dataList.size(); i++ ) {
							D40AbscTimeFrameData data = (D40AbscTimeFrameData)dataList.get(i);

							String BEGUZ = "";
							if(!"".equals(data.BEGUZ)){
								if(data.BEGUZ.length() == 4){
									if("24".equals(data.BEGUZ.substring(0,2))){
										BEGUZ = "00:"+data.BEGUZ.substring(2);
									}else{
										BEGUZ = data.BEGUZ.substring(0,2)+":"+data.BEGUZ.substring(2);
									}
								}
							}
							String ENDUZ = "";
							if(!"".equals(data.ENDUZ)){
								if(data.ENDUZ.length() == 4){
									if("24".equals(data.ENDUZ.substring(0,2))){
										ENDUZ = "00:"+data.ENDUZ.substring(2);
									}else{
										ENDUZ = data.ENDUZ.substring(0,2)+":"+data.ENDUZ.substring(2);
									}
								}
							}

%>
						<tr class="<%=WebUtil.printOddRow(i)%>">
							<td>
								<%=i+1 %>
								<input type="hidden" id="TIME_YN<%=i+1 %>" name="TIME_YN"  value="<%=data.TIME_YN%>">
							</td>

							<td><%=data.PERNR%><input type="hidden" id="PERNR<%=i+1 %>" name="PERNR" value="<%=data.PERNR%>"></td>
							<td><%=data.ENAME%><input type="hidden" id="ENAME<%=i+1 %>"  name="ENAME" value="<%=data.ENAME%>"></td>
							<td>
								<select  id="WTMCODE<%=i+1 %>" name="WTMCODE"  style="width: 95%; margin-top: 5px;">
									<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
<%
									for( int j = 0; j < vt.size(); j++ ) {
										D40AbscTimeFrameData vtData = (D40AbscTimeFrameData)vt.get(j);
%>
<%-- 											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.WTMCODE)){ %> selected <%} %>><%=vtData.CODE%> (<%=vtData.TEXT %>)</option> --%>
											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.WTMCODE)){ %> selected <%} %>><%=vtData.TEXT %></option>
<%
									}
%>
								</select>
							</td>
							<td>
								<% if(!"0000-00-00".equals(data.BEGDA)){ %>
									<input type="text"  class="date" id="BEGDA<%=i+1 %>" name="BEGDA" value="<%=data.BEGDA%>" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%}else{ %>
									<input type="text"  class="date" id="BEGDA<%=i+1 %>" name="BEGDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%} %>
							</td>
							<td>
								<% if(!"0000-00-00".equals(data.ENDDA)){ %>
									<input type="text"  class="date" id="ENDDA<%=i+1 %>" name="ENDDA" value="<%=data.ENDDA%>" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%}else{ %>a
									<input type="text"  class="date" id="ENDDA<%=i+1 %>" name="ENDDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%} %>
							</td>
							<td id="td_TPROG<%=i+1 %>"><%=data.TPROG%></td>
							<td>
						<%if("Y".equals(WebUtil.nvl(data.TIME_YN))){ %>
								<input type="text" class="eTime" id="BEGUZ<%=i+1 %>" name="BEGUZ" value="<%=BEGUZ%>"  style="width: 35px;" maxlength="4">
						<%}else{ %>
								<input type="text" class="eTime" id="BEGUZ<%=i+1 %>" name="BEGUZ" value="<%=BEGUZ%>" disabled="disabled" style="width: 35px;" maxlength="4">
						<%} %>
							</td>
							<td>
						<%if("Y".equals(WebUtil.nvl(data.TIME_YN))){ %>
								<input type="text" class="eTime" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=ENDUZ%>" style="width: 35px;" maxlength="4">
						<%}else{ %>
								<input type="text" class="eTime" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=ENDUZ%>" disabled="disabled" style="width: 35px;" maxlength="4">
						<%} %>
							</td>

							<%
								String view = "";
								if(!"Y".equals(data.REASON_YN)){
									view = "disabled='disabled'";
								}
							%>
							<td style="text-align: left;" id="td<%=i+1 %>">
								<input type="hidden" id="REASON_YN<%=i+1 %>" name="REASON_YN"  value="<%=data.REASON_YN%>">
								<select  id="REASON<%=i+1 %>" name="REASON"  <%=view %> style="width: 50%; margin-top: 5px;">
									<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
<%
									for( int j = 0; j < vt1.size(); j++ ) {
										D40AbscTimeFrameData vtData = (D40AbscTimeFrameData)vt1.get(j);
										if(vtData.PKEY.equals(data.WTMCODE)){
%>
<%-- 											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.REASON)){ %> selected <%} %>><%=vtData.CODE%> (<%=vtData.TEXT %>)</option> --%>
											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.REASON)){ %> selected <%} %>><%=vtData.TEXT %></option>
<%
										}
									}
%>
								</select>
							<%if("Y".equals(WebUtil.nvl(data.DETAIL_YN))){ %>
									<input type=text id="DETAIL<%=i+1 %>" name="DETAIL" value="<%=data.DETAIL%>"  style="width: 44%; margin-bottom: 6px;">
							<%}else{ %>
									<input type=text id="DETAIL<%=i+1 %>" name="DETAIL" disabled="disabled" value="<%=data.DETAIL%>"  style="width: 44%; margin-bottom: 6px;">
							<%} %>
								<input type="hidden" id="DETAIL_YN<%=i+1 %>" name="DETAIL_YN"  value="<%=data.DETAIL_YN%>">
							</td>
							<td id="td_REASON<%=i+1 %>" style="display: none;">
						<%if(!"Y".equals(data.REASON_YN)){ %>
								<input type=hidden id="REASON<%=i+1 %>" name="REASON"  value="<%=data.REASON%>" >
						<%} %>
							</td>
							<td id="td_DETAIL<%=i+1 %>" style="display: none;">
						<%if(!"Y".equals(data.DETAIL_YN)){ %>
								<input type=hidden id="DETAIL<%=i+1 %>" name="DETAIL" value="<%=data.DETAIL%>" >
						<%} %>
							</td>
							<td id="td_TIME<%=i+1 %>" style="display: none;">
						<%if(!"Y".equals(data.TIME_YN)){ %>
								<input type="hidden" id="BEGUZ<%=i+1 %>" name="BEGUZ" value="<%=data.BEGUZ%>" >
								<input type="hidden" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=data.BEGUZ%>" >
						<%} %>
							</td>
							<td id="td_EDIT<%=i+1 %>" style="display: none;">
								<input type="hidden" id="EDIT<%=i+1 %>"  name="EDIT"  value="<%=data.EDIT%>">
								<input type="hidden" id="AWART<%=i+1 %>" name="AWART"  value="<%=data.AWART%>">
								<input type="hidden" id="INFTY<%=i+1 %>" name="INFTY"  value="<%=data.INFTY%>">
								<input type="hidden" id="CHKDT<%=i+1 %>" name="CHKDT" value="Y">
								<input type="hidden" id="MSG<%=i+1 %>" name="MSG" value="">
								<input type="hidden" id="TPROG<%=i+1 %>" name="TPROG" value="<%=data.TPROG%>">
							</td>
							<td class="lastCol" style="text-align : left"><%=data.MSG%></td>
						</tr>
<%
							} //end for
						}else{
							if("SAVE".equals(gubun) && "M".equals(E_RETURN) ){
%>
						<tr class="oddRow">
							<td class="lastCol" colspan="11"><spring:message code="MSG.D.D40.0012"/><!-- 전체 데이터가 성공적으로 처리되었습니다. --></td>
						</tr>

<%
							}
						}
%>
					</tbody>
				</table>
			</div>
		</div>
		<div class="buttonArea">
	        <ul class="btn_crud">
	            <li><a class="darken" href="javascript:void(0);" id="save"><span><!-- 저장 --><%=g.getMessage("BUTTON.COMMON.SAVE")%></span></a></li>
	        </ul>
	    </div>
	</div>
</form>
</body>

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

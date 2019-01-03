<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   초과근무													*/
/*   Program Name	:   초과근무(일괄)											*/
/*   Program ID		: D40DailScheEach.jsp									*/
/*   Description		: 초과근무(일괄) 											*/
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

	Vector vt    = (Vector)request.getAttribute("OBJPS_OUT3");		//근태사유	코드-텍스트
	Vector vt1    = (Vector)request.getAttribute("OBJPS_OUT4");		//근태사유	코드-텍스트
	Vector dataList    = (Vector)request.getAttribute("OBJPS_OUT1");		//조회된정보
	Vector OBJPS_OUT5    = (Vector)request.getAttribute("OBJPS_OUT5");		//기타 상세사유 입력여부

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

	function selectList2(value, index, key, display, reason){
	<%
		if( vt != null && vt.size() > 0 ){
	%>
			var dis = "";
			if(reason != "Y"){
				dis = 'disabled="disabled"';
			}
			var selectList = '<select id="REASON'+index+'" name="REASON" '+dis+' style="width: 90%; margin-top: 5px;"><option value=""><spring:message code="LABEL.D.D11.0047"/></option>';
			var code;
			var text;
	<%
			for( int i = 0; i < vt.size(); i++ ) {
				D40OverTimeFrameData data = (D40OverTimeFrameData)vt.get(i);
	%>
					code = '<%=data.CODE%>';
					text = '<%=data.TEXT%>';
					if(value == code){
						selectList += '<option value="'+code+'" selected>'+text+'</option>';
					}else{
						selectList += '<option value="'+code+'">'+text+'</option>';
					}
	<%
			}
	%>
			selectList += '</select>';
	<%
		}else{
	%>

	if(reason != "Y"){
		dis = 'disabled="disabled"';
	}

	var selectList = '<select id="REASON'+index+'" '+dis+' name="REASON" style="width: 90%; margin-top: 5px;"><option value="">선택</option></select>';
	<%
		}
	%>
		return selectList;
	}

	function selectList(index, PKEY){
		<%
			if( vt != null && vt.size() > 0 ){
		%>
				var selectList = '<option value=""><spring:message code="LABEL.D.D03.0033"/></option>';
				var code;
				var text;
		<%
				for( int i = 0; i < vt.size(); i++ ) {
					D40OverTimeFrameData data = (D40OverTimeFrameData)vt.get(i);
		%>
						code = '<%=data.CODE%>';
						text = '<%=data.TEXT%>';
						selectList += '<option value="'+code+'">'+text+'</option>';
		<%
				}
			}else{
		%>
				var selectList = '<option value=""><spring:message code="LABEL.D.D03.0033"/></option>';
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
		_.each(data.resultList, function(row) {
			var chk = "";
			var cls = index % 2 == 1 ? "oddRow" : "";
			var select = selectList2(row.REASON, index, row.PKEY, row.EDIT, row.REASON_YN);
			var end = "END";
// 			if("X" == row.EDIT){	//수정가능
				html += '<tr class="'+cls+'">';
				html += 		'<td>'+index+'<input type="hidden" id="CHKDT'+index+'" name="CHKDT" value="X">';
				html +=			'<input type="hidden" id="MSG'+index+'" name="MSG" value="">';
				html +=			'<input type="hidden" id="TPROG'+index+'" name="TPROG" value="">';
				html +=			'<input type="hidden" id="REASON_YN'+index+'" name="REASON_YN"  value="'+row.REASON_YN+'">';
				html +=			'<input type="hidden" id="DETAIL_YN'+index+'" name="DETAIL_YN"  value="'+row.DETAIL_YN+'">';
				html +=			'<input type="hidden" id="EDIT'+index+'" name="EDIT"  value="'+row.EDIT+'">';
				html +=		'</td>';
				html +=		'<td>'+row.PERNR+'<input type="hidden" id="PERNR'+index+'" name="PERNR" value="'+row.PERNR+'"></td>'+
								'<td>'+row.ENAME+'<input type="hidden" id="ENAME'+index+'" name="ENAME" value="'+row.ENAME+'"></td>';
								if("0000-00-00" == row.BEGDA){
				html +=			'<td><input type="text"  class="date inputDt" id="BEGDA'+index+'" name="BEGDA" value="" size="15" style="margin-right: 4px"></td>';
								}else{
				html +=			'<td><input type="text"  class="date inputDt" id="BEGDA'+index+'" name="BEGDA" value="'+row.BEGDA.replace(/-/g, '.')+'" size="15" style="margin-right: 4px"></td>';
								}
								if("0000-00-00" == row.ENDDA){
				html +=			'<td><input type="text"  class="date inputDt" id="ENDDA'+index+'" name="ENDDA" value="" size="15" style="margin-right: 4px"></td>';
								}else{
				html +=			'<td><input type="text"  class="date inputDt" id="ENDDA'+index+'" name="ENDDA" value="'+row.ENDDA.replace(/-/g, '.')+'" size="15" style="margin-right: 4px"></td>';
								}
				html +=		'<td id="td_TPROG'+index+'">'+row.TPROG+'</td>';
				html +=		'<td><input type="text" class="eTime" id="BEGUZ'+index+'" name="BEGUZ" value="'+textCh(row.BEGUZ)+'" style="width: 35px;" maxlength="4"></td>'+
								'<td><input type="text" class="eTime" id="ENDUZ'+index+'" name="ENDUZ" value="'+textCh(row.ENDUZ, end )+'" style="width: 35px;" maxlength="4"></td>'+
								'<td><input type="text" class="eTime" id="PBEG1'+index+'" name="PBEG1" value="'+textCh(row.PBEG1)+'" style="width: 35px;" maxlength="4"></td>'+
								'<td><input type="text" class="eTime" id="PEND1'+index+'" name="PEND1" value="'+textCh(row.PEND1, end )+'" style="width: 35px;" maxlength="4"></td>'+
								'<td><input type="text" class="eTime" id="PBEG2'+index+'" name="PBEG2" value="'+textCh(row.PBEG2)+'" style="width: 35px;" maxlength="4"></td>'+
								'<td><input type="text" class="eTime" id="PEND2'+index+'" name="PEND2" value="'+textCh(row.PEND2, end )+'" style="width: 35px;" maxlength="4"></td>';
								if("X" == row.VTKEN){
									chk = "checked";
								}
				html +=		'<td><input type="checkbox" name="chk_VTKEN" '+chk+' value="'+index+'"><input type="hidden" id="VTKEN'+index+'" name="VTKEN"  value="'+row.VTKEN+'"></td>';
			if(row.REASON_YN == "Y"){
				if(row.DETAIL_YN == "Y"){	//사유와 상세사유 둘다 필수
					html +=		'<td style="text-align: left;">'+
										select+' <input type="text" id="DETAIL'+index+'" name="DETAIL"  value="'+row.DETAIL+'" title="'+row.DETAIL+'" style="width: 90%; margin-top: 6px; margin-bottom: 6px;">'+
									'</td>';
					html += 		'<td id="td_REASON'+index+'" style="display: none;"></td>';
					html += 		'<td id="td_DETAIL'+index+'" style="display: none;"></td>';

				}else{	//사유만 필수
					html +=		'<td style="text-align: left;">'+
										select+' <input type="text" id="DETAIL'+index+'" name="DETAIL" disabled="disabled" value="'+row.DETAIL+'" title="'+row.DETAIL+'" style="width: 90%; margin-top: 6px; margin-bottom: 6px;">'+
									'</td>';
					html += 		'<td id="td_REASON'+index+'" style="display: none;"></td>';
					html += 		'<td id="td_DETAIL'+index+'" style="display: none;"><input type="hidden" id="DETAIL'+index+'" name="DETAIL"  value="'+row.DETAIL+'" ></td>';
				}
			}else{
				if(row.DETAIL_YN == "Y"){ //상세사유만 필수
					html +=		'<td style="text-align: left;">'+
										select+' <input type="text" id="DETAIL'+index+'" name="DETAIL"  value="'+row.DETAIL+'" style="width: 90%; title="'+row.DETAIL+'" margin-top: 6px; margin-bottom: 6px;">'+
									'</td>';
					html += 		'<td id="td_REASON'+index+'" style="display: none;"><input type="hidden" id="REASON'+index+'" name="REASON"  value="'+row.REASON+'" ></td>';
					html += 		'<td id="td_DETAIL'+index+'" style="display: none;"></td>';
				}else{	//둘다 필수 아님
					html +=		'<td style="text-align: left;">'+
										select+' <input type="text" id="DETAIL'+index+'" name="DETAIL" disabled="disabled" value="'+row.DETAIL+'" title="'+row.DETAIL+'" style="width: 90%; margin-top: 6px; margin-bottom: 6px;">'+
									'</td>';
					html += 		'<td id="td_REASON'+index+'" style="display: none;"><input type="hidden" id="REASON'+index+'" name="REASON"  value="'+row.REASON+'" ></td>';
					html += 		'<td id="td_DETAIL'+index+'" style="display: none;"><input type="hidden" id="DETAIL'+index+'" name="DETAIL"  value="'+row.DETAIL+'" ></td>';
				}
			}

				html +=		'<td class="lastCol" style="text-align : left">'+row.MSG+'</td>'+
							'</tr>';
			index++;
		});
		if(state == "M"){
			html = '<tr><td class="lastCol" colspan="15"><spring:message code="MSG.D.D40.0012"/></td></tr>';	/* 전체 데이터가 성공적으로 처리되었습니다. */
		}else if(state == "N"){
			html = '<tr><td class="lastCol" colspan="15"><spring:message code="MSG.D.D40.0028"/></td></tr>';	/* 저장할 내역이 존재하지 않습니다. */
		}
		$("#-excel-result-tbody").append(html);

		$('.date').each(function(){
			addDatePicker($('.date'));
			$(this).mask("9999.99.99");
		});

		afterChk();

	}

	function validation(){

		var chk = true;
		if($("input[name=PERNR]").length == 0){
			alert('<spring:message code="MSG.D.D40.0015"/>');
			return false;
		}

		var ids = "";
		$("input[name=PERNR]").each(function(idx){
			ids = (idx+1);

			var ename = $("#ENAME"+ids).val() !="" ? "("+$("#ENAME"+ids).val()+")" : "";
			var target = $("#PERNR"+ids).val()+ename;

			if($.trim($("#BEGDA"+ids).val()) == ""){
				alert(target+'<spring:message code="MSG.D.D40.0031"/>');	/* 의 시작일은 필수 입니다. */
				$("#BEGDA"+ids).focus();
				chk = false;
				return false;
			}

			if($.trim($("#ENDDA"+ids).val()) == ""){
				alert(target+'<spring:message code="MSG.D.D40.0032"/>');	/* 의 종료일은 필수 입니다. */
				$("#ENDDA"+ids).focus();
				chk = false;
				return false;
			}

			if($.trim($("#BEGUZ"+ids).val()) == ""){
				alert(target+'<spring:message code="MSG.D.D40.0020"/>');	/* 의 시작시간은 필수 입니다. */
				$("#BEGUZ"+ids).focus();
				chk = false;
				return false;
			}
			if($.trim($("#ENDUZ"+ids).val()) == ""){
				alert(target+'<spring:message code="MSG.D.D40.0021"/>');	/* 의 종료시간은 필수 입니다. */
				$("#ENDUZ"+ids).focus();
				chk = false;
				return false;
			}
			if($.trim($("#PBEG1"+ids).val()) != ""){
				if($.trim($("#PEND1"+ids).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0022"/>');	/* 의 휴식종료1은 필수 입니다. */
					$("#PEND1"+ids).focus();
					chk = false;
					return false;
				}
			}
			if($.trim($("#PEND1"+ids).val()) != ""){
				if($.trim($("#PBEG1"+ids).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0023"/>');	/* 의 휴식시작1은 필수 입니다. */
					$("#PBEG1"+ids).focus();
					chk = false;
					return false;
				}
			}
			if($.trim($("#PBEG2"+ids).val()) != ""){
				if($.trim($("#PEND2"+ids).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0024"/>');	/* 의 휴식종료2은 필수 입니다. */
					$("#PEND2"+ids).focus();
					chk = false;
					return false;
				}
			}
			if($.trim($("#PEND2"+ids).val()) != ""){
				if($.trim($("#PBEG2"+ids).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0025"/>');	/* 의 휴식시작2은 필수 입니다. */
					$("#PBEG2"+ids).focus();
					chk = false;
					return false;
				}
			}

			if($.trim($("#BEGUZ"+ids).val()) != "" && $("#BEGUZ"+ids).val().length != 5){
				alert(target+'<spring:message code="MSG.D.D40.0041"/>');		/* 의 시작시간을 정확히 입력해 주십시오(예 0930, 0030) */
				chk = false;
				return false;
			}
			if($.trim($("#ENDUZ"+ids).val()) != "" && $("#ENDUZ"+ids).val().length != 5){
				alert(target+'<spring:message code="MSG.D.D40.0042"/>');		/* 의 종료시간을 정확히 입력해 주십시오(예 0930, 0030) */
				chk = false;
				return false;
			}
			if($.trim($("#PBEG1"+ids).val()) != "" && $("#PBEG1"+ids).val().length != 5){
				alert(target+'<spring:message code="MSG.D.D40.0045"/>');		/* 의 휴식시간1을 정확히 입력해 주십시오(예 0930, 0030) */
				chk = false;
				return false;
			}
			if($.trim($("#PEND1"+ids).val()) != "" && $("#PEND1"+ids).val().length != 5){
				alert(target+'<spring:message code="MSG.D.D40.0046"/>');		/* 의 휴식종료1을 정확히 입력해 주십시오(예 0930, 0030) */
				chk = false;
				return false;
			}
			if($.trim($("#PBEG2"+ids).val()) != "" && $("#PBEG2"+ids).val().length != 5){
				alert(target+'<spring:message code="MSG.D.D40.0047"/>');		/* 의 휴식시간2을 정확히 입력해 주십시오(예 0930, 0030) */
				chk = false;
				return false;
			}
			if($.trim($("#PEND2"+ids).val()) != "" && $("#PEND2"+ids).val().length != 5){
				alert(target+'<spring:message code="MSG.D.D40.0048"/>');		/* 의 휴식종료2을 정확히 입력해 주십시오(예 0930, 0030) */
				chk = false;
				return false;
			}

			if($("#REASON_YN"+ids).val() == "Y"){		//REASON 코드선택 필수
				if($.trim($("#REASON"+ids).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0026"/>');	/* 의 사유코드는 필수 입니다. */
					$("#REASON"+ids).focus();
					chk = false;
					return false;
				}
			}
			if($("#DETAIL_YN"+ids).val() == "Y"){		//DETAIL 입력 필수
				if($.trim($("#DETAIL"+ids).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0027"/>');	/* 의 상세사유는 필수 입니다. */
					$("#DETAIL"+ids).focus();
					chk = false;
					return false;
				}
			}else{
				//상세사유가 필수는 아니지만 사유를 기타 선택 시 상세 사유 필수 입력 체크
				var cnt = 0;
				'<c:forEach var="row" items="${OBJPS_OUT5}" varStatus="i">';
					if('<c:out value="${row.CODE}"/>' == $("#REASON"+ids).val()){
						cnt++;
					}
				'</c:forEach>';
				if(cnt > 0){
					if($.trim($("#DETAIL"+ids).val()) == ""){
						alert(target+'<spring:message code="MSG.D.D40.0027"/>');	/* 의 상세사유는 필수 입니다. */
						$("#DETAIL"+ids).focus();
						chk = false;
						return false;
					}
				}
			}

		});

		return chk;
	}

	function afterChk(){

		$(".eTime").blur(function(){
			if($(this).val().length == 0){
				return;
			}
			if($(this).val().length < 4){
				alert('<spring:message code="MSG.D.D40.0016"/>'); /* 올바른 시간을 입력해주십시오.(예 0930, 0030) */
				return;
			}
	        var isValidrunningTime = regExp.test($(this).val());
	        if( isValidrunningTime == false ){
	        	alert('<spring:message code="MSG.D.D40.0016"/>'); /* 올바른 시간을 입력해주십시오.(예 0930, 0030) */
	        }else{
	        	$(this).val(textCh($(this).val()));
	        }
		});
		$(".eTime").focus(function(){
			$(this).val($(this).val().replace(":",""));
			$(this).select();
		});

		$('input[name="chk_VTKEN"]').click(function() {
			var val = $(this).val();
			if($('input:checkbox[name="chk_VTKEN"]').is(":checked")){
				$("#VTKEN"+val).val("X");
			}else{
				$("#VTKEN"+val).val("");
			}
		});

		$('.inputDt').each(function(){
			addDatePicker($('.inputDt'));
			$(this).mask("9999.99.99");
		});

		$(".inputDt").change(function(){
			var id = $(this).attr("id").substring(0,5);
			var no = $(this).attr("id").substring(5);

  			if(id == "BEGDA"){
  				$("#ENDDA"+no).val($(this).val());
  			}
  			if($(this).val()==""){return;}
  			if(id == "ENDDA"){return;}

			if($("#PERNR"+no).val() != ""){
				parent.blockFrame();

				$("#gubun").val("SEARCHONE");
				$("#searchPERNR").val($("#PERNR"+no).val());
				$("#searchBEGDA").val($(this).val());
				$("#no").val(no);
				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OverTimeEachSV");
			    $("#form1").attr("target", "ifHidden");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
	 		}
		});

		//REASON
		$("select[name=REASON]").on("change", function(){
			var cnt = 0;
			var id = $(this).attr("id");
			var no = $(this).attr("id").substring(6);
			//초과근무는 유형이 없으므로 사유만 가지고 확인한다(기타인 경우 상세사유 입력하게)
			'<c:forEach var="row" items="${OBJPS_OUT5}" varStatus="i">';
				if('<c:out value="${row.CODE}"/>' == $(this).val()){
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

		var height = document.body.scrollHeight;
		parent.autoResize(height+30);

	}

	$(function() {

		afterChk();

		var height = document.body.scrollHeight;
		parent.autoResize(height+30);

		//엑셀다운로드
		$("#excelDown").click(function() {
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

			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OverTimeLumpSV");
		    $("#form1").attr("target", "ifHidden");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();

		});

		//저장
		$("#do_save, #save").click(function(){
			if(validation()){
				parent.saveBlockFrame();
				$("#gubun").val("SAVE");

				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OverTimeLumpSV");
			    $("#form1").attr("target", "_self");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

		//엑셀업로드
		$("#excelUpload").click(function(){
			var small_window = window.open('<c:out value="${g.servlet}"/>hris.D.D40TmGroup.D40OverTimeFileUploadSV?',
					"ScheduleExcelUpload","width=440,height=300,left=365,top=70,scrollbars=no");
			small_window.focus();
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
	<input type="hidden" id="no" name="no" value="">
	<input type="hidden" id="iSeqno" name="iSeqno" value="">
	<input type="hidden" id="ISEQNO" name="ISEQNO" value="">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB" value="">
	<input type="hidden" id="I_ACTTY" name="I_ACTTY" value="">
	<input type="hidden" id="gubun" name="gubun" value="">

	<div class="listArea">
<%-- 		<h2 class="subtitle"><font color="red"><spring:message code="LABEL.D.D40.0121"/></font></h2> --%>
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
						<col width="13%" />
						<col width="13%" />
						<col width="4%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="3%" />
						<col />
						<col width="10%" />
					</colgroup>
					<thead>
					<tr>
						<th><!-- 라인--><spring:message code="LABEL.D.D12.0084"/></th>
						<th><!-- 사번--><spring:message code="LABEL.D.D12.0017"/></th>
						<th><!-- 이름--><spring:message code="LABEL.D.D12.0018"/></th>
						<th><!-- 시작일--><spring:message code="LABEL.D.D15.0152"/></th>
						<th><!-- 종료일--><spring:message code="LABEL.D.D15.0153"/></th>
						<th><!-- 일일근무일정--><spring:message code="LABEL.D.D12.0053"/></th>
						<th><!-- 시작시간--><spring:message code="LABEL.D.D12.0020"/></th>
						<th><!-- 종료시간--><spring:message code="LABEL.D.D12.0021"/></th>
						<th><!-- 휴식시간1--><spring:message code="LABEL.D.D12.0068"/></th>
						<th><!-- 휴식종료1--><spring:message code="LABEL.D.D12.0069"/></th>
						<th><!-- 휴식시간2--><spring:message code="LABEL.D.D12.0070"/></th>
						<th><!-- 휴식종료2--><spring:message code="LABEL.D.D12.0071"/></th>
						<th><!-- 이전일--><spring:message code="LABEL.D.D12.0023"/></th>
						<th><!-- 사유--><spring:message code="LABEL.D.D12.0024"/></th>
						<th class="lastCol" " ><!-- 오류메세지--><spring:message code="LABEL.D.D40.0023"/></th>
					</tr>
					</thead>
					<tbody id="-excel-result-tbody">
<%
					if( dataList != null && dataList.size() > 0 ){
						for( int i = 0; i < dataList.size(); i++ ) {
							D40OverTimeFrameData data = (D40OverTimeFrameData)dataList.get(i);

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

							String PBEG1 = "";
							if(!"".equals(data.PBEG1)){
								if(data.PBEG1.length() == 4){
									if("24".equals(data.PBEG1.substring(0,2))){
										PBEG1 = "00:"+data.PBEG1.substring(2);
									}else{
										PBEG1 = data.PBEG1.substring(0,2)+":"+data.PBEG1.substring(2);
									}
								}
							}
							String PEND1 = "";
							if(!"".equals(data.PEND1)){
								if(data.PEND1.length() == 4){
									if("24".equals(data.PEND1.substring(0,2))){
										PEND1 = "00:"+data.PEND1.substring(2);
									}else{
										PEND1 = data.PEND1.substring(0,2)+":"+data.PEND1.substring(2);
									}
								}
							}
							String PBEG2 = "";
							if(!"".equals(data.PBEG2)){
								if(data.PBEG2.length() == 4){
									if("24".equals(data.PBEG2.substring(0,2))){
										PBEG2 = "00:"+data.PBEG2.substring(2);
									}else{
										PBEG2 = data.PBEG2.substring(0,2)+":"+data.PBEG2.substring(2);
									}
								}
							}
							String PEND2 = "";
							if(!"".equals(data.PEND2)){
								if(data.PEND2.length() == 4){
									if("24".equals(data.PEND2.substring(0,2))){
										PEND2 = "00:"+data.PEND2.substring(2);
									}else{
										PEND2 = data.PEND2.substring(0,2)+":"+data.PEND2.substring(2);
									}
								}
							}
							String EDIT = WebUtil.nvl( data.EDIT);
							//항상수정할수 있게
							EDIT = "X";
%>
						<tr class="<%=WebUtil.printOddRow(i)%>">
							<td>
								<%=i+1 %>
								<input type="hidden" name="SELECT"  value="">
								<input type="hidden" id="EDIT<%=i+1 %>"  name="EDIT"  value="<%=data.EDIT%>">
								<input type="hidden" name="PKEY"  value="<%=data.PKEY%>">
								<input type="hidden" id="CHKDT<%=i+1 %>" name="CHKDT" value="Y">
								<input type="hidden" id="MSG<%=i+1 %>" name="MSG" value="">
								<input type="hidden" id="TPROG<%=i+1 %>" name="TPROG" value="<%=data.TPROG%>">
								<input type="hidden" id="REASON_YN<%=i+1 %>" name="REASON_YN"  value="<%=data.REASON_YN%>">
								<input type="hidden" id="DETAIL_YN<%=i+1 %>" name="DETAIL_YN"  value="<%=data.DETAIL_YN%>">
								<input type="hidden" id="OREASON<%=i+1 %>" name="OREASON"  value="<%=data.REASON%>">
								<input type="hidden" id="ODETAIL<%=i+1 %>" name="ODETAIL"  value="<%=data.DETAIL%>">
							</td>
							<td><%=data.PERNR%><input type="hidden" id="PERNR<%=i+1 %>" name="PERNR" value="<%=data.PERNR%>"></td>
							<td><%=data.ENAME%><input type="hidden" id="ENAME<%=i+1 %>"  name="ENAME" value="<%=data.ENAME%>"></td>
							<%if("X".equals(WebUtil.nvl(EDIT))){ %>
							<td>
								<% if(!"0000-00-00".equals(data.BEGDA)){ %>
									<input type="text"  class="date inputDt" id="BEGDA<%=i+1 %>" name="BEGDA" value="<%=data.BEGDA%>" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%}else{ %>
									<input type="text"  class="date inputDt" id="BEGDA<%=i+1 %>" name="BEGDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%} %>
							</td>
							<%}else{ %>
							<td>
								<input type="text"  id="BEGDA<%=i+1 %>" disabled="disabled" name="BEGDA" value="<%=data.BEGDA.replace("-",".")%>" style="width: 105px; ">
								<input type="hidden"  id="BEGDA<%=i+1 %>" name="BEGDA" value="<%=data.BEGDA%>">
							</td>
							<%} %>
							<%if("X".equals(WebUtil.nvl(EDIT))){ %>
							<td>
								<% if(!"0000-00-00".equals(data.ENDDA)){ %>
									<input type="text"  class="date inputDt" id="ENDDA<%=i+1 %>" name="ENDDA" value="<%=data.ENDDA%>" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%}else{ %>
									<input type="text"  class="date inputDt" id="ENDDA<%=i+1 %>" name="ENDDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%} %>
							</td>
							<%}else{ %>
							<td>
								<input type="text"  id="ENDDA<%=i+1 %>" disabled="disabled" name="ENDDA" value="<%=data.ENDDA.replace("-",".")%>" style="width: 105px; ">
								<input type="hidden"  id="ENDDA<%=i+1 %>" name="ENDDA" value="<%=data.ENDDA%>">
							</td>
							<%} %>
							<td id="td_TPROG<%=i+1 %>"><%=data.TPROG%></td>
							<td>
								<%if("X".equals(WebUtil.nvl(EDIT))){ %>
									<input type="text" class="eTime" id="BEGUZ<%=i+1 %>" name="BEGUZ" value="<%=BEGUZ%>"  style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="BEGUZ<%=i+1 %>" name="BEGUZ" disabled="disabled" value="<%=BEGUZ%>"  style="width: 35px;" maxlength="4">
									<input type="hidden" class="eTime" id="BEGUZ<%=i+1 %>" name="BEGUZ" value="<%=BEGUZ%>"  style="width: 35px;" maxlength="4">
								<%} %>
							</td>
							<td>
								<%if("X".equals(WebUtil.nvl(EDIT))){ %>
									<input type="text" class="eTime" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=ENDUZ%>" style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="ENDUZ<%=i+1 %>" name="ENDUZ" disabled="disabled" value="<%=ENDUZ%>"  style="width: 35px;" maxlength="4">
									<input type="hidden" class="eTime" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=ENDUZ%>"  style="width: 35px;" maxlength="4">
								<%} %>
							</td>
							<td>
								<%if("X".equals(WebUtil.nvl(EDIT))){ %>
									<input type="text" class="eTime" id="PBEG1<%=i+1 %>" name="PBEG1" value="<%=PBEG1%>"  style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="PBEG1<%=i+1 %>" disabled="disabled" name="PBEG1" value="<%=PBEG1%>"  style="width: 35px;" maxlength="4">
									<input type="hidden" class="eTime" id="PBEG1<%=i+1 %>" name="PBEG1" value="<%=PBEG1%>"  style="width: 35px;" maxlength="4">
								<%} %>
							</td>
							<td>
								<%if("X".equals(WebUtil.nvl(EDIT))){ %>
									<input type="text" class="eTime" id="PEND1<%=i+1 %>" name="PEND1" value="<%=PEND1%>"  style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="PEND1<%=i+1 %>" name="PEND1" disabled="disabled" value="<%=PEND1%>"  style="width: 35px;" maxlength="4">
									<input type="hidden" class="eTime" id="PEND1<%=i+1 %>" name="PEND1" value="<%=PEND1%>"  style="width: 35px;" maxlength="4">
								<%} %>
							</td>
							<td>
								<%if("X".equals(WebUtil.nvl(EDIT))){ %>
									<input type="text" class="eTime" id="PBEG2<%=i+1 %>" name="PBEG2" value="<%=PBEG2%>"  style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="PBEG2<%=i+1 %>" name="PBEG2" disabled="disabled" value="<%=PBEG2%>"  style="width: 35px;" maxlength="4">
									<input type="hidden" class="eTime" id="PBEG2<%=i+1 %>" name="PBEG2" value="<%=PBEG2%>"  style="width: 35px;" maxlength="4">
								<%} %>
							</td>
							<td>
								<%if("X".equals(WebUtil.nvl(EDIT))){ %>
									<input type="text" class="eTime" id="PEND2<%=i+1 %>" name="PEND2" value="<%=PEND2%>"  style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="PEND2<%=i+1 %>" disabled="disabled" name="PEND2" value="<%=PEND2%>"  style="width: 35px;" maxlength="4">
									<input type="hidden" class="eTime" id="PEND2<%=i+1 %>" name="PEND2" value="<%=PEND2%>"  style="width: 35px;" maxlength="4">
								<%} %>
							</td>
							<td>
								<input type="checkbox" name="chk_VTKEN" <%if("X".equals(data.VTKEN)){ %> checked <%} %> <%if(!"X".equals(WebUtil.nvl(EDIT))){ %> disabled='disabled' <%} %> value="<%=i+1 %>">
								<input type="hidden" id="VTKEN<%=i+1 %>" name="VTKEN"  value="<%=data.VTKEN%>">
							</td>
							<%
								String view = "";
								if(!"Y".equals(data.REASON_YN)){
									view = "disabled='disabled'";
								}
							%>
							<td style="text-align: left;">
								<select  id="REASON<%=i+1 %>" name="REASON"  <%=view %> <%if(!"X".equals(WebUtil.nvl(EDIT)) ){ %> disabled='disabled' <%} %> style="width: 90%; margin-top: 5px;">
									<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
<%
									for( int j = 0; j < vt.size(); j++ ) {
										D40OverTimeFrameData vtData = (D40OverTimeFrameData)vt.get(j);
// 										if(vtData.PKEY.equals(data.PKEY)){
%>
<%-- 											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.REASON)){ %> selected <%} %>><%=vtData.CODE%> (<%=vtData.TEXT %>)</option> --%>
											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.REASON)){ %> selected <%} %>><%=vtData.TEXT %></option>
<%
// 										}
									}
%>
								</select>
							<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<%if("Y".equals(WebUtil.nvl(data.DETAIL_YN))){ %>
									<input type=text id="DETAIL<%=i+1 %>" name="DETAIL" value="<%=data.DETAIL%>"  title="<%=data.DETAIL%>" style="width: 90%; margin-top: 6px; margin-bottom: 6px;">
								<%}else{ %>
									<input type=text id="DETAIL<%=i+1 %>" name="DETAIL" disabled="disabled" value="<%=data.DETAIL%>" title="<%=data.DETAIL%>" style="width: 90%; margin-top: 6px; margin-bottom: 6px;">
								<%} %>
							<%}else{ %>
								<input type=text id="DETAIL<%=i+1 %>" name="DETAIL" disabled="disabled" value="<%=data.DETAIL%>" title="<%=data.DETAIL%>" style="width: 90%; margin-top: 6px; margin-bottom: 6px;">
							<%} %>

							</td>
							<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<%if("Y".equals(WebUtil.nvl(data.REASON_YN))){ %>
									<td id="td_REASON<%=i+1 %>" style="display: none;"></td>
								<%}else{ %>
									<td id="td_REASON<%=i+1 %>" style="display: none;"><input type=hidden id="REASON<%=i+1 %>" name="REASON" value="<%=data.REASON%>" ></td>
								<%} %>
							<%}else{ %>
								<td id="td_REASON<%=i+1 %>" style="display: none;"><input type=hidden id="REASON<%=i+1 %>" name="REASON" value="<%=data.REASON%>" ></td>
							<%} %>
							<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<%if("Y".equals(WebUtil.nvl(data.DETAIL_YN))){ %>
									<td id="td_DETAIL<%=i+1 %>" style="display: none;"></td>
								<%}else{ %>
									<td id="td_DETAIL<%=i+1 %>" style="display: none;"><input type=hidden id="DETAIL<%=i+1 %>" name="DETAIL" value="<%=data.DETAIL%>" ></td>
								<%} %>
							<%}else{ %>
								<td id="td_DETAIL<%=i+1 %>" style="display: none;"><input type=hidden id="DETAIL<%=i+1 %>" name="DETAIL" value="<%=data.DETAIL%>" ></td>
							<%} %>
							<td class="lastCol" style="text-align : left"><%=data.MSG%></td>
						</tr>
<%
							} //end for
						}else{
							if("SAVE".equals(gubun) && "M".equals(E_RETURN) ){
%>
						<tr class="oddRow">
							<td class="lastCol" colspan="15"><spring:message code="MSG.D.D40.0012"/><!-- 전체 데이터가 성공적으로 처리되었습니다. --></td>
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

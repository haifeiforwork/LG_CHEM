<%--
/********************************************************************************/
/*																				*/
/*   System Name	:  MSS														*/
/*   1Depth Name	:   부서근태													*/
/*   2Depth Name	:   사원지급정보												*/
/*   Program Name	:   사원지급정보(개별)										*/
/*   Program ID		: D40RemeInfoEach.jsp										*/
/*   Description	: 사원지급정보(개별) 조회/저장									*/
/*   Note			:             												*/
/*   Creation		: 2017-12-08  정준현                                          		*/
/*   Update			: 2017-12-08  정준현                                          		*/
/*   				: 2018-06-18  성환희 [WorkTime52]                            */
/*                                                                              */
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름
	String E_BEGDA    = (String)request.getAttribute("E_BEGDA");	//리턴 조회시작일
	String E_ENDDA    = (String)request.getAttribute("E_ENDDA");	//리턴 조회종료일
	String I_BEGDA    = (String)request.getAttribute("I_BEGDA");	//조회시작날짜
	String I_ENDDA    = (String)request.getAttribute("I_ENDDA");	//조회종료날짜

	String gubun    = (String)request.getAttribute("gubun");	//구분
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	String E_SAVE_CNT    = WebUtil.nvl((String)request.getAttribute("E_SAVE_CNT"));	//저장메세지
	String textChange    = WebUtil.nvl((String)request.getAttribute("textChange"));	//

	if(!"".equals(I_BEGDA) && I_BEGDA != null){
		E_BEGDA = I_BEGDA;
	}
	if(!"".equals(I_ENDDA) && I_ENDDA != null){
		E_ENDDA = I_ENDDA;
	}

	Vector vt1    = (Vector)request.getAttribute("OBJPS_OUT1");	//계획근무
 	Vector vt2    = (Vector)request.getAttribute("OBJPS_OUT2");	//조회된 내용
	Vector vt3    = (Vector)request.getAttribute("OBJPS_OUT3");	//근태사유 코드-텍스트
	Vector vt4    = (Vector)request.getAttribute("OBJPS_OUT4");	//유형 코드-텍스트


%>
<c:set var="count" value="<%=vt2.size()%>"/>
<c:set var="eInfo" value="<%=E_INFO%>"/>

<jsp:include page="/include/header.jsp" />

<script language="JavaScript">

	var ovtime50Data = [];
	var rowCnt = '<c:out value="${count }"/>';
	var dbClick = false;
	var regExp = new RegExp(/^([1-9]|[01][0-9]|2[0-3])([0-5][0-9])$/);
	var orgVal = "";

<%
	if("Y".equals(textChange)){
%>
	parent.$("#searchOrg_ment").html('<font color="red"><strong><c:out value="${eInfo }"/></strong></font>');
<%
	}
%>

	//인원추가 후 행추가 생성
	function makeInput(){
		var arrPERNR = $("#popPERNR").val().split(',');
		var arrENAME = $("#popENAME").val().split(',');

		var D_WTMCODE = $("#D_WTMCODE").val();	//유형
		var D_BEGDA = $("#D_BEGDA").val();				//일자
		var D_BEGUZ = $("#D_BEGUZ").val();				//시작시간
		var D_ENDUZ = $("#D_ENDUZ").val();				//종료시간
		var D_PBEG1 = $("#D_PBEG1").val();				//휴식시작
		var D_PEND1 = $("#D_PEND1").val();				//휴식종료
		var D_REASON = $("#D_REASON").val();			//사유
		var D_DETAIL = $("#D_DETAIL").val();				//상세사유
		var D_REASON_YN = $("#D_REASON_YN").val();	//사유 필수여부
		var D_DETAIL_YN = $("#D_DETAIL_YN").val();		//상세사유 필수여부
		var D_TIME_YN = $("#D_TIME_YN").val();			//시간 필수여부
		var D_STDAZ_YN = $("#D_STDAZ_YN").val();		//수 입력 가능여부
		var D_PTIME_YN = $("#D_PTIME_YN").val();			//시간 입력가능 여부
		var repeatCnt = nvl($("#repeatCnt").val(),1);		//반복회수

		if(rowCnt == 0){
			$("#lastMessage").remove();
		}

		var html = "";

		$.each( arrPERNR, function( i, val ) {
			for(var k = 0; k < repeatCnt; k++) {
				rowCnt++;
				var select1 = defultSelectList1(rowCnt, D_WTMCODE);
				var select2 = defultSelectList2(rowCnt, D_WTMCODE, D_REASON, D_REASON_YN);

				html += '<tr  id="tr'+rowCnt+'">';
				html += '		<td>';
				html += '			<input type="checkbox" name="chkSELECT"  value="'+rowCnt+'">';
				html += '			<input type="hidden" name="SELECT"  value="">';
				html += '			<input type="hidden" id="PKEY'+rowCnt+'" name="PKEY"  value="">';
				html += '			<input type="hidden" id="ENAME'+rowCnt+'" name="ENAME" value="'+arrENAME[i]+'" >';
				html += '			<input type="hidden" id="WWKTM'+rowCnt+'" name="WWKTM" value="0" >';
				html += '			<input type="hidden" id="TIME_YN'+rowCnt+'" name="TIME_YN"  value="'+D_TIME_YN+'">';
				html += '			<input type="hidden" id="REASON_YN'+rowCnt+'" name="REASON_YN"  value="'+D_REASON_YN+'">';
				html += '			<input type="hidden" id="DETAIL_YN'+rowCnt+'" name="DETAIL_YN"  value="'+D_DETAIL_YN+'">';
				html += '			<input type="hidden" id="PTIME_YN'+rowCnt+'" name="PTIME_YN"  value="'+D_PTIME_YN+'">';
				html += '			<input type="hidden" id="STDAZ_YN'+rowCnt+'" name="STDAZ_YN"  value="'+D_STDAZ_YN+'">';
				html += '			<input type="hidden" id="CHKDT'+rowCnt+'" name="CHKDT" value="">';
				html += '			<input type="hidden" id="LGART'+rowCnt+'" name="LGART" value="">';
				html += '			<input type="hidden" id="BETRG'+rowCnt+'" name="BETRG" value="">';
				html += '			<input type="hidden" id="MSG'+rowCnt+'" name="MSG" value="">';
				html += '			<input type="hidden" id="OBEGDA'+rowCnt+'" name="OBEGDA" value="">';
				html += '			<input type="hidden" id="OSEQNR'+rowCnt+'" name="OSEQNR" value="">';
				html += '			<input type="hidden" id="OWTMCODE'+rowCnt+'" name="OWTMCODE" value="">';
				html += '			<input type="hidden" id="OLGART'+rowCnt+'" name="OLGART" value="">';
				html += '			<input type="hidden" id="OBETRG'+rowCnt+'" name="OBETRG" value="">';
				html += '			<input type="hidden" id="OBEGUZ'+rowCnt+'" name="OBEGUZ" value="">';
				html += '			<input type="hidden" id="OENDUZ'+rowCnt+'" name="OENDUZ" value="">';
				html += '			<input type="hidden" id="OPBEG1'+rowCnt+'" name="OPBEG1" value="">';
				html += '			<input type="hidden" id="OPEND1'+rowCnt+'" name="OPEND1" value="">';
				html += '			<input type="hidden" id="OSTDAZ'+rowCnt+'" name="OSTDAZ" value="">';
				html += '			<input type="hidden" id="OREASON'+rowCnt+'" name="OREASON" value="">';
				html += '			<input type="hidden" id="ODETAIL'+rowCnt+'" name="ODETAIL" value="">';
				html += '			<input type="hidden" id="ACTIO'+rowCnt+'" name="ACTIO"  value="INS">';
				html += '		</td>';
				html += '		<td><input type="text" id="PERNR'+rowCnt+'" name="PERNR" value="'+val+'" style="width: 60px;" maxlength="8"></td>';
				html += '		<td id="td_ENAME'+rowCnt+'">'+arrENAME[i]+'</td>';
				html += '		<td id="td_WWKTM'+rowCnt+'">0</td>';
				html += '		<td>'+select1+'</td>';
				html += '		<td><input type="text" class="date inputDt" id="BEGDA'+rowCnt+'" name="BEGDA" value="'+D_BEGDA+'" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px"></td>';
				html += '		<td id="td_TPROG'+rowCnt+'"></td>';
			if(D_TIME_YN == "Y" || D_TIME_YN == ""){
				html += '		<td><input type="text" class="eTime" id="BEGUZ'+rowCnt+'" name="BEGUZ" value="'+D_BEGUZ+'" style="width: 35px;" maxlength="4"></td>';
				html += '		<td><input type="text" class="eTime" id="ENDUZ'+rowCnt+'" name="ENDUZ" value="'+D_ENDUZ+'" style="width: 35px;" maxlength="4"></td>';
				html += '		<td id="td_TIME'+rowCnt+'" style="display: none;"></td>';
			}else{
				html += '		<td><input type="text" class="eTime" id="BEGUZ'+rowCnt+'" name="BEGUZ" value="" disabled="disabled" style="width: 35px;" maxlength="4"></td>';
				html += '		<td><input type="text" class="eTime" id="ENDUZ'+rowCnt+'" name="ENDUZ" value="" disabled="disabled" style="width: 35px;" maxlength="4"></td>';
				html += '		<td id="td_TIME'+rowCnt+'" style="display: none;"><input type=hidden id="BEGUZ'+rowCnt+'" name="BEGUZ"  value="" ><input type=hidden id="ENDUZ'+rowCnt+'" name="ENDUZ"  value="" ></td>';
			}
			if(D_PTIME_YN == "Y" || D_PTIME_YN == ""){
				html += '		<td><input type="text" class="eTime" id="PBEG1'+rowCnt+'" name="PBEG1" value="'+D_PBEG1+'" style="width: 35px;" maxlength="4"></td>';
				html += '		<td><input type="text" class="eTime" id="PEND1'+rowCnt+'" name="PEND1" value="'+D_PEND1+'" style="width: 35px;" maxlength="4"></td>';
				html += '		<td id="td_PTIME'+rowCnt+'" style="display: none;"></td>';
			}else{
				html += '		<td><input type="text" class="eTime" id="PBEG1'+rowCnt+'" name="PBEG1" value="" disabled="disabled" style="width: 35px;" maxlength="4"></td>';
				html += '		<td><input type="text" class="eTime" id="PEND1'+rowCnt+'" name="PEND1" value="" disabled="disabled" style="width: 35px;" maxlength="4"></td>';
				html += '		<td id="td_PTIME'+rowCnt+'" style="display: none;"><input type=hidden id="PBEG1'+rowCnt+'" name="PBEG1"  value="" ><input type=hidden id="PEND1'+rowCnt+'" name="PEND1"  value="" ></td>';
			}
			if(D_STDAZ_YN == "Y" || D_STDAZ_YN == ""){
				html += '		<td><input type="text" id="STDAZ'+rowCnt+'" name="STDAZ" value="" style="width: 35px;" maxlength="5"></td>';
				html += '		<td id="td_STDAZ'+rowCnt+'" style="display: none;"></td>';
			}else{
				html += '		<td><input type="text" id="STDAZ'+rowCnt+'" name="STDAZ" value="" disabled="disabled" style="width: 35px;" maxlength="5"></td>';
				html += '		<td id="td_STDAZ'+rowCnt+'" style="display: none;"><input type=hidden id="STDAZ'+rowCnt+'" name="STDAZ"  value=""</td>';
			}
				html += '		<td style="text-align: left;" id="td'+rowCnt+'">';
				html +=			select2;
			if(D_DETAIL_YN == "Y" || D_DETAIL_YN == ""){
				html += '			<input type="text" id="DETAIL'+rowCnt+'" name="DETAIL" value="'+D_DETAIL+'" style="width: 43%; margin-bottom: 6px;">';
			}else{
				html += '			<input type="text" id="DETAIL'+rowCnt+'" name="DETAIL" value="'+D_DETAIL+'" disabled="disabled" style="width: 43%; margin-bottom: 6px;">';
			}
				html += '		</td>';
			if(D_REASON_YN == "Y" || D_REASON_YN == ""){
				html += '		<td id="td_REASON'+rowCnt+'" style="display: none;"></td>';
			}else{
				html += '		<td id="td_REASON'+rowCnt+'" style="display: none;"><input type=hidden id="REASON'+rowCnt+'" name="REASON"  value="" ></td>';
			}
			if(D_DETAIL_YN == "Y" || D_DETAIL_YN == ""){
				html += '		<td id="td_DETAIL'+rowCnt+'" style="display: none;"></td>';
			}else{
				html += '		<td id="td_DETAIL'+rowCnt+'" style="display: none;"><input type=hidden id="DETAIL'+rowCnt+'" name="DETAIL"  value="" ></td>';
			}
				html += '		<td id="td_EDIT'+rowCnt+'" style="display: none;">';
				html += '			<input type="hidden" id="EDIT'+rowCnt+'" name="EDIT"  value="X">';
				html += '			<input type="hidden" id="AWART'+rowCnt+'" name="AWART"  value="">';
				html += '			<input type="hidden" id="INFTY'+rowCnt+'" name="INFTY"  value="">';
				html += '			<input type="hidden" id="TPROG'+rowCnt+'" name="TPROG"  value="">';
				html += '		</td>';
				html += '		<td class="lastCol" style="text-align : left"></td>';
				html += '</tr>';
			}
		});

		var trHtml = $( "tr[name=trStaff]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출

		trHtml.after(html); //마지막 trStaff명 뒤에 붙인다.

		afterChk();

	}

	//저장 validation 체크
	function validation(){
		var chk = true;
		if($("input[name=PERNR]").length == 0){
			alert('<spring:message code="MSG.D.D40.0028"/>');	/* 저장할 내역이 존재하지 않습니다. */
			chk = false;
			return false;
		}

		$("input[name=PERNR]").each(function(idx){
			var no = $(this).attr("id").substring(5);
			if($("#ACTIO"+no).val() != "DEL"){ //삭제 플래그는 validation 제외한다
				if($.trim($("#PERNR"+no).val()) == ""){
					alert('<spring:message code="MSG.D.D40.0017"/>');	/* 사번은 필수 입니다. */
					$("#PERNR"+no).focus();
					chk = false;
					return false;
				}
				var ename = $("#ENAME"+no).val() !="" ? "("+$("#ENAME"+no).val()+")" : "";
				var target = $("#PERNR"+no).val()+ename;

				var no = $(this).attr("id").substring(5);
				if($.trim($("#WTMCODE"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0052"/>'+' <spring:message code="MSG.D.D40.0053"/>');	/* 의 임금유형은 필수입니다. */
					$("#WTMCODE"+no).focus();
					chk = false;
					return false;
				}
				if($.trim($("#BEGDA"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0052"/>'+' <spring:message code="MSG.D.D40.0018"/>');	/* 의 일자는 필수입니다. */
					$("#BEGDA"+no).focus();
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
				if($.trim($("#PBEG1"+no).val()) != ""){
					if($.trim($("#PEND1"+no).val()) == ""){
						alert(target+'<spring:message code="MSG.D.D40.0050"/>');	/* 의 휴식종료시간은 필수 입니다. */
						$("#PEND1"+no).focus();
						chk = false;
						return false;
					}
				}
				if($.trim($("#PEND1"+no).val()) != ""){
					if($.trim($("#PBEG1"+no).val()) == ""){
						alert(target+'<spring:message code="MSG.D.D40.0049"/>');	/* 의 휴식시작시간은 필수 입니다. */
						$("#PBEG1"+no).focus();
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
				if($.trim($("#PBEG1"+no).val()) != "" && $("#PBEG1"+no).val().length != 5){
					alert(target+'<spring:message code="MSG.D.D40.0043"/>');		/* 의 휴식시작시간을 정확히 입력해 주십시오(예 0930, 0030) */
					chk = false;
					return false;
				}
				if($.trim($("#PEND1"+no).val()) != "" && $("#PEND1"+no).val().length != 5){
					alert(target+'<spring:message code="MSG.D.D40.0044"/>');		/* 의 휴식종료시간을 정확히 입력해 주십시오(예 0930, 0030) */
					chk = false;
					return false;
				}
				if($.trim($("#STDAZ_YN"+no).val()) == "Y"){
					if($.trim($("#STDAZ"+no).val()) != ""){
						var num = $.trim($("#STDAZ"+no).val());
						if (isNaN(num)) {
							alert(target+'<spring:message code="MSG.D.D40.0040"/>');	/* 의 근무시간 수는 숫자만 입력 하십시오. */
							$("#STDAZ"+no).focus();
							chk = false;
							return false;
						}
					}
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
					//상세사유가 필수는 아니지만 사유를 기타 선택 시 상세 사유 필수 입력 체크
					var cnt = 0;
					'<c:forEach var="row" items="${OBJPS_OUT5}" varStatus="i">';
						if('<c:out value="${row.CODE}"/>' == $("#REASON"+no).val()){
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

				if($.trim($("#CHKDT"+no).val()) == "X"){
					alert(target+'<spring:message code="MSG.D.D40.0051"/> '+$("#MSG"+no).val() );
					chk = false;
					return false;
				}
			}
		});
		return chk;
	}

	//시간 입력 뒤  : 표시
	function textCh(val){
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

	//유형선택 option 조회
	function selectSearchList( index, value1, value2){	//no, PKEY, WTMCODE
<%
	if( vt3 != null && vt3.size() > 0 ){
%>
		var selectList = '<option value=""><spring:message code="LABEL.D.D11.0047"/></option>';
		var code;
		var text;
<%
		for( int i = 0; i < vt3.size(); i++ ) {
			D40RemeInfoFrameData data = (D40RemeInfoFrameData)vt3.get(i);
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

	//유형선택 select  (index, 유형)
	function defultSelectList1(index, value){

		var selectList = '<select id="WTMCODE'+index+'" name="WTMCODE" style="width: 95%;" >';
			selectList += '<option value=""><spring:message code="LABEL.D.D03.0033"/></option>';
		var code;
		var text;
<%
			for( int j = 0; j < vt4.size(); j++ ) {
				D40RemeInfoFrameData vtData = (D40RemeInfoFrameData)vt4.get(j);
%>
				code = '<%=vtData.CODE%>';
				text = '<%=vtData.TEXT%>';
				if(code == value){
					selectList += '<option value="'+code+'" selected>'+text+'</option>';
				}else{
					selectList += '<option value="'+code+'">'+text+'</option>';
				}
<%
			}
%>
			selectList += '</select>';
		return selectList;
	}

	//defultSelect
	function defultSelectList2(index, value1, value2, value3){

		var selectList = "";
		if(value1 == ""){
			if(value3 == "N"){
				selectList += '<select id="REASON'+index+'" name="REASON" disabled="disabled" style="width: 50%; margin-top: 5px;"><option value=""><spring:message code="LABEL.D.D03.0033"/></option></select>';
			}else{
				selectList += '<select id="REASON'+index+'" name="REASON" style="width: 50%; margin-top: 5px;"><option value=""><spring:message code="LABEL.D.D03.0033"/></option></select>';
			}
		}else{
			if(value3 == "N"){
				selectList += '<select id="REASON'+index+'" name="REASON" disabled="disabled" style="width: 50%; margin-top: 5px;">';
				selectList += selectSearchList( index, value1, value2);
				selectList += '</select>';
			}else{
				selectList += '<select id="REASON'+index+'" name="REASON" style="width: 50%; margin-top: 5px;">';
				selectList += selectSearchList( index, value1, value2);
				selectList += '</select>';
			}
		}

		return selectList;
	}

	//날짜 차이 체크 함수
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

	//이벤트 활성화
	function afterChk(){

		$('.inputDt').each(function(){
			addDatePicker($('.inputDt'));
			$(this).mask("9999.99.99");
		});

		$('select[name="WTMCODE"]').change(function(e) {
			if($(this).val() == ""){return;}
			var no = $(this).attr("id").substring(7);
			if($("#BEGDA"+no).val() == ""){return;}
			if($("#PERNR"+no).val() != ""){
				if ($("#PERNR"+no).val().match(/^\d+$/gi) == null) {
			    	alert('<spring:message code="MSG.D.D40.0004"/>'); /* 사번은 숫자만 넣으세요! */
			        return;
			    }
				parent.blockFrame();
				$("#gubun").val("SEARCHONE");
				$("#searchPERNR").val($("#PERNR"+no).val());
				$("#searchBEGDA").val($("#BEGDA"+no).val());
				$("#searchWTMCODE").val($(this).val());
				$("#no").val(no);
				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40RemeInfoLumpSV");
			    $("#form1").attr("target", "ifHidden");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

		$(".inputDt").change(function(){
  			if($(this).val()==""){return;}
  			var id = $(this).attr("id").substring(0,5);
  			if(id == "ENDDA"){return;}
			var no = $(this).attr("id").substring(5);
  			if($("#WTMCODE"+no).val()==""){return;}
			if($("#PERNR"+no).val() != ""){
				if ($("#PERNR"+no).val().match(/^\d+$/gi) == null) {
			    	alert('<spring:message code="MSG.D.D40.0004"/>'); /* 사번은 숫자만 넣으세요! */
			        return;
			    }
				parent.blockFrame();
				$("#gubun").val("SEARCHONE");
				$("#searchPERNR").val($("#PERNR"+no).val());
				$("#searchBEGDA").val($(this).val());
				$("#searchWTMCODE").val($("#WTMCODE"+no).val());
				$("#no").val(no);
				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40RemeInfoLumpSV");
			    $("#form1").attr("target", "ifHidden");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
	 		}
		});

		//시간입력 blur
		$(".eTime").blur(function(){
			if($(this).val() == ""){
				return;
			}
			if($(this).val().length < 4){
				alert('<spring:message code="MSG.D.D40.0016"/>'); /* 올바른 시간을 입력해주십시오.(예 0930, 0030) */
				return;
			}
	        var isValidrunningTime = regExp.test($(this).val().replace(/\:/g,''));
	        if( isValidrunningTime == false ){
	        	alert('<spring:message code="MSG.D.D40.0016"/>'); /* 올바른 시간을 입력해주십시오.(예 0930, 0030) */
	        }else{
	        	$(this).val(textCh($(this).val().replace(/\:/g,'')));
	        }
		});
		//시간입력 focus
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

		var height = document.body.scrollHeight;
		parent.autoResize(height+30);

	}

	//사번 blur 이벤트
	$(document).on('blur', "input:text[name='PERNR']",function(){
 		if($(this).val()==""){return;}
 		if(orgVal == $(this).val()){return;}
 		if ($(this).val().match(/^\d+$/gi) == null) {
	    	alert('<spring:message code="MSG.D.D40.0004"/>'); /* 사번은 숫자만 넣으세요! */
	        return;
	    }
 		var no = $(this).attr("id").substring(5);
 		if($("#BEGDA"+no).val() == ""){return;}
 		if($("#WTMCODE"+no).val()==""){return;}

		parent.blockFrame();
		$("#gubun").val("SEARCHONE");
		$("#searchPERNR").val($(this).val());
		$("#searchBEGDA").val($("#BEGDA"+no).val());
		$("#searchWTMCODE").val($("#WTMCODE"+no).val());
		$("#no").val(no);
		$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40RemeInfoLumpSV");
	    $("#form1").attr("target", "ifHidden");
	    $("#form1").attr("method", "post");
	    $("#form1").attr("onsubmit", "true");
	    $("#form1").submit();
	});

	//사번 click 이벤트 (단순 클릭일 경우 P모드 조회 안하게처리)
	$(document).on('click', "input:text[name='PERNR']",function(){
		if($(this).val()==""){return;}
		orgVal = $(this).val();
	});

	$(function() {

		afterChk();

		//조회
		$("#do_search").click(function(){

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
				//상단 공통 조회조건
				parent.blockFrame();
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

				$("#I_ACTTY").val("R");
				$("#gubun").val("SEARCH");
				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40RemeInfoEachSV");
			    $("#form1").attr("target", "_self");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

		//저장
		$("#do_save, #save").click(function(){
			if(validation()){
				parent.saveBlockFrame();
				$("#gubun").val("SAVE");
				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40RemeInfoEachSV");
			    $("#form1").attr("target", "_self");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

		//사원검색 Popup.
		$("#organ_search").click(function(){
			var small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
		    small_window.focus();
		    $("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		    $("#iSeqno").val(parent.$("#iSeqno").val());
		    $("#pageGubun").val("B");
		    $("#I_SCREEN").val("");

		    $("#form1").attr("action","<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListFramePop.jsp");
		    $("#form1").attr("target", "Organ");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});

		//인원추가
		$("#organ_search2").click(function(){
			var small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
		    small_window.focus();
		    $("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		    $("#iSeqno").val(parent.$("#iSeqno").val());
		    $("#pageGubun").val("C");
		    $("#I_SCREEN").val("C");

		    $("#form1").attr("action","<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListFramePop.jsp");
		    $("#form1").attr("target", "Organ");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});

		//엑셀다운로드
		$("#excelDown").click(function(){
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
			  	//상단 공통 조회조건
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

				var vObj = document.form1;
				$("#I_ACTTY").val("R");
				$("#gubun").val("EXCEL");
				$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40RemeInfoEachSV");
			    $("#form1").attr("target", "ifHidden");
			    $("#form1").attr("method", "post");
			    $("#form1").attr("onsubmit", "true");
			    $("#form1").submit();
			}
		});

		//행삭제
		$("#deleteRow").click(function(){
			if($("input:checkbox[name=chkSELECT]:checked").length == 0){
				alert('<spring:message code="MSG.D.D11.0021"/>'); /* 삭제할 건을 선택하세요. */
				return;
			}

			$("input:checkbox[name=chkSELECT]:checked").each(function () {

				if($("#OBEGDA"+$(this).val()).val() == "" || $("#OBEGDA"+$(this).val()).val() == "0000.00.00"){
					$("#tr"+$(this).val()).remove();
				}else{
					$("#tr"+$(this).val()).hide();
					$("#ACTIO"+$(this).val()).val("DEL");
				}
			});
		});

		//행추가
		$("#addRow").click(function(){

			if(rowCnt == 0){
				$("#lastMessage").remove();
			}
			rowCnt++;
			var select1 = defultSelectList1(rowCnt);
			var select2 = defultSelectList2(rowCnt);
			var html = "";

			html += '<tr  id="tr'+rowCnt+'">';
			html += '		<td>';
			html += '			<input type="checkbox" name="chkSELECT"  value="'+rowCnt+'">';
			html += '			<input type="hidden" name="SELECT"  value="">';
			html += '			<input type="hidden" id="PKEY'+rowCnt+'" name="PKEY"  value="">';
			html += '			<input type="hidden" id="TIME_YN'+rowCnt+'" name="TIME_YN"  value="">';
			html += '			<input type="hidden" id="PTIME_YN'+rowCnt+'" name="PTIME_YN"  value="">';
			html += '			<input type="hidden" id="STDAZ_YN'+rowCnt+'" name="STDAZ_YN"  value="">';
			html += '			<input type="hidden" id="REASON_YN'+rowCnt+'" name="REASON_YN"  value="">';
			html += '			<input type="hidden" id="DETAIL_YN'+rowCnt+'" name="DETAIL_YN"  value="">';
			html += '			<input type="hidden" id="OSEQNR'+rowCnt+'" name="OSEQNR" value="">';
			html += '			<input type="hidden" id="CHKDT'+rowCnt+'" name="CHKDT" value="X">';
			html += '			<input type="hidden" id="MSG'+rowCnt+'" name="MSG" value="">';
			html += '			<input type="hidden" id="OBEGDA'+rowCnt+'" name="OBEGDA" value="">';
			html += '			<input type="hidden" name="OWTMCODE" value="">';
			html += '			<input type="hidden" name="OLGART" value="">';
			html += '			<input type="hidden" name="LGART" value="">';
			html += '			<input type="hidden" name="BETRG" value="">';
			html += '			<input type="hidden" name="OBETRG" value="">';
			html += '			<input type="hidden" name="OBEGUZ" value="">';
			html += '			<input type="hidden" name="OENDUZ" value="">';
			html += '			<input type="hidden" name="OPBEG1" value="">';
			html += '			<input type="hidden" name="OPEND1" value="">';
			html += '			<input type="hidden" name="OSTDAZ" value="">';
			html += '			<input type="hidden" name="OREASON" value="">';
			html += '			<input type="hidden" name="ODETAIL" value="">';
			html += '			<input type="hidden" id="ENAME'+rowCnt+'" name="ENAME" value="" >';
			html += '			<input type="hidden" id="WWKTM'+rowCnt+'" name="WWKTM" value="" >';
			html += '			<input type="hidden" id="ACTIO'+rowCnt+'" name="ACTIO"  value="INS">';
			html += '		</td>';
			html += '		<td><input type="text" id="PERNR'+rowCnt+'" name="PERNR" value="" style="width: 60px;" maxlength="8"></td>';
			html += '		<td id="td_ENAME'+rowCnt+'"></td>';
			html += '		<td id="td_WWKTM'+rowCnt+'">0</td>';
			html += '		<td>'+select1+'</td>';
			html += '		<td><input type="text" class="date inputDt" id="BEGDA'+rowCnt+'" name="BEGDA" value="" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px"></td>';
			html += '		<td id="td_TPROG'+rowCnt+'"></td>';
			html += '		<td><input type="text" class="eTime" id="BEGUZ'+rowCnt+'" name="BEGUZ" value="" style="width: 35px;" maxlength="4"></td>';
			html += '		<td><input type="text" class="eTime" id="ENDUZ'+rowCnt+'" name="ENDUZ" value="" style="width: 35px;" maxlength="4"></td>';
			html += '		<td id="td_TIME'+rowCnt+'" style="display: none;"></td>';
			html += '		<td><input type="text" class="eTime" id="PBEG1'+rowCnt+'" name="PBEG1" value="" style="width: 35px;" maxlength="4"></td>';
			html += '		<td><input type="text" class="eTime" id="PEND1'+rowCnt+'" name="PEND1" value="" style="width: 35px;" maxlength="4"></td>';
			html += '		<td id="td_PTIME'+rowCnt+'" style="display: none;"></td>';
			html += '		<td><input type="text" id="STDAZ'+rowCnt+'" name="STDAZ" value="" style="width: 35px;" maxlength="5"></td>';
			html += '		<td id="td_STDAZ'+rowCnt+'" style="display: none;"></td>';
			html += '		<td style="text-align: left;" id="td'+rowCnt+'">';
			html +=			select2;
			html += '			<input type="text" id="DETAIL'+rowCnt+'" name="DETAIL" value="" style="width: 43%; margin-bottom: 6px;">';
			html += '		</td>';
			html += '		<td id="td_REASON'+rowCnt+'" style="display: none;"></td>';
			html += '		<td id="td_DETAIL'+rowCnt+'" style="display: none;"></td>';
			html += '		<td id="td_EDIT'+rowCnt+'" style="display: none;">';
			html += '			<input type="hidden" id="EDIT'+rowCnt+'" name="EDIT"  value="">';
			html += '			<input type="hidden" id="AWART'+rowCnt+'" name="AWART"  value="">';
			html += '			<input type="hidden" id="INFTY'+rowCnt+'" name="INFTY"  value="">';
			html += '			<input type="hidden" id="TPROG'+rowCnt+'" name="TPROG"  value="">';
			html += '		</td>';
			html += '		<td class="lastCol" style="text-align : left"></td>';
			html += '</tr>';

			var trHtml = $( "tr[name=trStaff]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출

			trHtml.after(html); //마지막 trStaff명 뒤에 붙인다.

			afterChk();
		});

		//사원선택 초기화
		$("#dt_clear").click(function(){
			$("#I_PERNR").val("");
			$("#I_ENAME").val("");
		});

		//행복사
		$("#copyRow").click(function(){

			if(!dbClick){
				dbClick = true;

				var html = "";

				$("input:checkbox[name=chkSELECT]:checked").each(function () {

					var chkNo = $(this).val();										//체크된 아이디 넘버

					var D_PERNR = $("#PERNR"+chkNo).val();					//사번
					var D_ENAME = $("#ENAME"+chkNo).val();				//이름
					var D_WWKTM = $("#WWKTM"+chkNo).val();				//총근무시간(주)
					var D_WTMCODE = $("#WTMCODE"+chkNo).val();		//유형
					var D_BEGDA = $("#BEGDA"+chkNo).val();				//일자
					var D_TPROG = $("#TPROG"+chkNo).val();				//일일근무일정
					var D_BEGUZ = $("#BEGUZ"+chkNo).val();				//시작시간
					var D_ENDUZ = $("#ENDUZ"+chkNo).val();				//종료시간
					var D_PBEG1 = $("#PBEG1"+chkNo).val();					//휴식시작
					var D_PEND1 = $("#PEND1"+chkNo).val();				//휴식종료
					var D_REASON = $("#REASON"+chkNo).val();			//사유
					var D_DETAIL = $("#DETAIL"+chkNo).val();				//상세사유
					var D_REASON_YN = $("#REASON_YN"+chkNo).val();	//사유 필수여부
					var D_DETAIL_YN = $("#DETAIL_YN"+chkNo).val();	//상세사유 필수여부
					var D_TIME_YN = $("#TIME_YN"+chkNo).val();			//시간 필수여부
					var D_STDAZ_YN = $("#STDAZ_YN"+chkNo).val();		//수 입력 가능여부
					var D_PTIME_YN = $("#PTIME_YN"+chkNo).val();		//시간 입력가능 여부
					var D_EDIT = $("#EDIT"+chkNo).val();			//수정여부

					rowCnt++;
					var select1 = defultSelectList1(rowCnt, D_WTMCODE);
					var select2 = defultSelectList2(rowCnt, D_WTMCODE, D_REASON, D_REASON_YN);

					html += '<tr  id="tr'+rowCnt+'">';
					html += '		<td>';
					html += '			<input type="checkbox" name="chkSELECT"  value="'+rowCnt+'">';
					html += '			<input type="hidden" name="SELECT"  value="">';
					html += '			<input type="hidden" id="PKEY'+rowCnt+'" name="PKEY"  value="">';
					html += '			<input type="hidden" id="ENAME'+rowCnt+'" name="ENAME" value="'+D_ENAME+'" >';
					html += '			<input type="hidden" id="WWKTM'+rowCnt+'" name="WWKTM" value="'+D_WWKTM+'" >';
					html += '			<input type="hidden" id="TIME_YN'+rowCnt+'" name="TIME_YN"  value="'+D_TIME_YN+'">';
					html += '			<input type="hidden" id="REASON_YN'+rowCnt+'" name="REASON_YN"  value="'+D_REASON_YN+'">';
					html += '			<input type="hidden" id="DETAIL_YN'+rowCnt+'" name="DETAIL_YN"  value="'+D_DETAIL_YN+'">';
					html += '			<input type="hidden" id="PTIME_YN'+rowCnt+'" name="PTIME_YN"  value="'+D_PTIME_YN+'">';
					html += '			<input type="hidden" id="STDAZ_YN'+rowCnt+'" name="STDAZ_YN"  value="'+D_STDAZ_YN+'">';
					html += '			<input type="hidden" id="CHKDT'+rowCnt+'" name="CHKDT" value="">';
					html += '			<input type="hidden" id="LGART'+rowCnt+'" name="LGART" value="">';
					html += '			<input type="hidden" id="BETRG'+rowCnt+'" name="BETRG" value="">';
					html += '			<input type="hidden" id="MSG'+rowCnt+'" name="MSG" value="">';
					html += '			<input type="hidden" id="OBEGDA'+rowCnt+'" name="OBEGDA" value="">';
					html += '			<input type="hidden" id="OSEQNR'+rowCnt+'" name="OSEQNR" value="">';
					html += '			<input type="hidden" id="OWTMCODE'+rowCnt+'" name="OWTMCODE" value="">';
					html += '			<input type="hidden" id="OLGART'+rowCnt+'" name="OLGART" value="">';
					html += '			<input type="hidden" id="OBETRG'+rowCnt+'" name="OBETRG" value="">';
					html += '			<input type="hidden" id="OBEGUZ'+rowCnt+'" name="OBEGUZ" value="">';
					html += '			<input type="hidden" id="OENDUZ'+rowCnt+'" name="OENDUZ" value="">';
					html += '			<input type="hidden" id="OPBEG1'+rowCnt+'" name="OPBEG1" value="">';
					html += '			<input type="hidden" id="OPEND1'+rowCnt+'" name="OPEND1" value="">';
					html += '			<input type="hidden" id="OSTDAZ'+rowCnt+'" name="OSTDAZ" value="">';
					html += '			<input type="hidden" id="OREASON'+rowCnt+'" name="OREASON" value="">';
					html += '			<input type="hidden" id="ODETAIL'+rowCnt+'" name="ODETAIL" value="">';
					html += '			<input type="hidden" id="ACTIO'+rowCnt+'" name="ACTIO"  value="INS">';
					html += '		</td>';
					html += '		<td><input type="text" id="PERNR'+rowCnt+'" name="PERNR" value="'+D_PERNR+'" style="width: 60px;" maxlength="8"></td>';
					html += '		<td id="td_ENAME'+rowCnt+'">'+D_ENAME+'</td>';
					html += '		<td id="td_WWKTM'+rowCnt+'">'+D_WWKTM+'</td>';
					html += '		<td>'+select1+'</td>';
					html += '		<td><input type="text" class="date inputDt" id="BEGDA'+rowCnt+'" name="BEGDA" value="'+D_BEGDA+'" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px"></td>';
					html += '		<td id="td_TPROG'+rowCnt+'">'+D_TPROG+'</td>';
				if(D_TIME_YN == "Y" || D_TIME_YN == ""){
					html += '		<td><input type="text" class="eTime" id="BEGUZ'+rowCnt+'" name="BEGUZ" value="'+D_BEGUZ+'" style="width: 35px;" maxlength="4"></td>';
					html += '		<td><input type="text" class="eTime" id="ENDUZ'+rowCnt+'" name="ENDUZ" value="'+D_ENDUZ+'" style="width: 35px;" maxlength="4"></td>';
					html += '		<td id="td_TIME'+rowCnt+'" style="display: none;"></td>';
				}else{
					html += '		<td><input type="text" class="eTime" id="BEGUZ'+rowCnt+'" name="BEGUZ" value="" disabled="disabled" style="width: 35px;" maxlength="4"></td>';
					html += '		<td><input type="text" class="eTime" id="ENDUZ'+rowCnt+'" name="ENDUZ" value="" disabled="disabled" style="width: 35px;" maxlength="4"></td>';
					html += '		<td id="td_TIME'+rowCnt+'" style="display: none;"><input type=hidden id="BEGUZ'+rowCnt+'" name="BEGUZ"  value="" ><input type=hidden id="ENDUZ'+rowCnt+'" name="ENDUZ"  value="" ></td>';
				}
				if(D_PTIME_YN == "Y" || D_PTIME_YN == ""){
					html += '		<td><input type="text" class="eTime" id="PBEG1'+rowCnt+'" name="PBEG1" value="'+D_PBEG1+'" style="width: 35px;" maxlength="4"></td>';
					html += '		<td><input type="text" class="eTime" id="PEND1'+rowCnt+'" name="PEND1" value="'+D_PEND1+'" style="width: 35px;" maxlength="4"></td>';
					html += '		<td id="td_PTIME'+rowCnt+'" style="display: none;"></td>';
				}else{
					html += '		<td><input type="text" class="eTime" id="PBEG1'+rowCnt+'" name="PBEG1" value="" disabled="disabled" style="width: 35px;" maxlength="4"></td>';
					html += '		<td><input type="text" class="eTime" id="PEND1'+rowCnt+'" name="PEND1" value="" disabled="disabled" style="width: 35px;" maxlength="4"></td>';
					html += '		<td id="td_PTIME'+rowCnt+'" style="display: none;"><input type=hidden id="PBEG1'+rowCnt+'" name="PBEG1"  value="" ><input type=hidden id="PEND1'+rowCnt+'" name="PEND1"  value="" ></td>';
				}
				if(D_STDAZ_YN == "Y" || D_STDAZ_YN == ""){
					html += '		<td><input type="text" id="STDAZ'+rowCnt+'" name="STDAZ" value="" style="width: 35px;" maxlength="5"></td>';
					html += '		<td id="td_STDAZ'+rowCnt+'" style="display: none;"></td>';
				}else{
					html += '		<td><input type="text" id="STDAZ'+rowCnt+'" name="STDAZ" value="" disabled="disabled" style="width: 35px;" maxlength="5"></td>';
					html += '		<td id="td_STDAZ'+rowCnt+'" style="display: none;"><input type=hidden id="STDAZ'+rowCnt+'" name="STDAZ"  value=""</td>';
				}
					html += '		<td style="text-align: left;" id="td'+rowCnt+'">';
					html +=			select2;
				if(D_DETAIL_YN == "Y" || D_DETAIL_YN == ""){
					html += '			<input type="text" id="DETAIL'+rowCnt+'" name="DETAIL" value="'+D_DETAIL+'" style="width: 43%; margin-bottom: 6px;">';
				}else{
					html += '			<input type="text" id="DETAIL'+rowCnt+'" name="DETAIL" value="'+D_DETAIL+'" disabled="disabled" style="width: 43%; margin-bottom: 6px;">';
				}
					html += '		</td>';
				if(D_REASON_YN == "Y" || D_REASON_YN == ""){
					html += '		<td id="td_REASON'+rowCnt+'" style="display: none;"></td>';
				}else{
					html += '		<td id="td_REASON'+rowCnt+'" style="display: none;"><input type=hidden id="REASON'+rowCnt+'" name="REASON"  value="" ></td>';
				}
				if(D_DETAIL_YN == "Y" || D_DETAIL_YN == ""){
					html += '		<td id="td_DETAIL'+rowCnt+'" style="display: none;"></td>';
				}else{
					html += '		<td id="td_DETAIL'+rowCnt+'" style="display: none;"><input type=hidden id="DETAIL'+rowCnt+'" name="DETAIL"  value="" ></td>';
				}
					html += '		<td id="td_EDIT'+rowCnt+'" style="display: none;">';
					html += '			<input type="hidden" id="EDIT'+rowCnt+'" name="EDIT"  value="'+D_EDIT+'">';
					html += '			<input type="hidden" id="AWART'+rowCnt+'" name="AWART"  value="">';
					html += '			<input type="hidden" id="INFTY'+rowCnt+'" name="INFTY"  value="">';
					html += '			<input type="hidden" id="TPROG'+rowCnt+'" name="TPROG"  value="'+D_TPROG+'">';
					html += '		</td>';
					html += '		<td class="lastCol" style="text-align : left"></td>';
					html += '</tr>';

				});

				var trHtml = $( "tr[name=trStaff]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출

				trHtml.after(html); //마지막 trStaff명 뒤에 붙인다.

				afterChk();

			}

			dbClick = false;

		});


		//전체선택
		$("#allChk").click(function(){
			if(this.checked == true){
				$('input:checkbox[name="chkSELECT"]').each(function(){
					if($(this).attr("disabled") != "disabled"){
						this.checked = true;
					}
				});
			}else{
				$('input:checkbox[name="chkSELECT"]').each(function(){
					this.checked = false;
				});
			}
		});
		
		$('a[data-name="overtime50LayerClose"]').click(function(e) {
			e.preventDefault();
		    $.unblockUI();
		    return false;
		});
		
		<c:if test="${not empty OBJPS_OUT6}">
			setTimeout(function() {
	            var left = ($(document).width() / 2 - 200) + 'px';
	            $.blockUI({
	                message: $('div#overtime50Layer').show(),
	                css: {
	                    top: '5%',
	                    left: left,
	                    width: '610px',
	                    cursor: 'default'
	                },
	                onUnblock: function(e, o) {
	                    $('div#overtime50Layer').hide();
	                }
	            });
	        }, 500);
		</c:if>
		
	});

</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

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
	<input type="hidden" id="searchPERNR" name="searchPERNR" value="">
	<input type="hidden" id="searchBEGDA" name="searchBEGDA" value="">
	<input type="hidden" id="searchWTMCODE" name="searchWTMCODE" value="">
	<input type="hidden" id="popPERNR" name="popPERNR" value="">
	<input type="hidden" id="popENAME" name="popENAME" value="">
	<input type="hidden" id="no" name="no" value="">
	<input type="hidden" id="I_SCREEN" name="I_SCREEN" value="">

	<!-- 기본값설정 hidden -->
	<input type="hidden" id="D_WTMCODE" name="D_WTMCODE">
	<input type="hidden" id="D_BEGDA" name="D_BEGDA">
	<input type="hidden" id="D_BEGUZ" name="D_BEGUZ">
	<input type="hidden" id="D_ENDUZ" name="D_ENDUZ">
	<input type="hidden" id="D_PBEG1" name="D_PBEG1">
	<input type="hidden" id="D_PEND1" name="D_PEND1">
	<input type="hidden" id="D_REASON" name="D_REASON">
	<input type="hidden" id="D_DETAIL" name="D_DETAIL">
	<input type="hidden" id="D_REASON_YN" name="D_REASON_YN">
	<input type="hidden" id="D_DETAIL_YN" name="D_DETAIL_YN">
	<input type="hidden" id="D_TIME_YN" name="D_TIME_YN">
	<input type="hidden" id="D_STDAZ_YN" name="D_STDAZ_YN">
	<input type="hidden" id="D_PTIME_YN" name="D_PTIME_YN">
	<input type="hidden" id="repeatCnt" name="repeatCnt">

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
					<select name="I_SCHKZ" id="I_SCHKZ" style="width: 100%">
						<option value=""><spring:message code='LABEL.COMMON.0024'/><!-- 전체 --></option>
<%
							for( int j = 0; j < vt1.size(); j++ ) {
								D40RemeInfoFrameData vtData = (D40RemeInfoFrameData)vt1.get(j);
%>
									<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(I_SCHKZ)){ %> selected <%} %>><%=vtData.CODE%> (<%=vtData.TEXT %>)</option>
<%
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
					<input type="text" id="I_ENAME" name="I_ENAME" readonly="readonly"  value="<%=I_ENAME%>" style="width: 120px;">
					<a class="floatLeft" href="javascript:void(0);" id="dt_clear"><img src="/web/images/eloffice/images/ico/ico_inline_reset.png" alt="초기화"/></a>
<!--                     &nbsp; &nbsp; -->
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:void(0);" id="do_search" ><span><spring:message code="BUTTON.COMMON.SEARCH"/><!-- 조회 --></span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>
	<div class="listArea">
		<div class="listTop">
		<span class="listCnt"><spring:message code="LABEL.D.D12.0081" /><!-- 총 --> <span><%=vt2.size() %></span><spring:message code="LABEL.D.D12.0083" /><!-- 건 --></span>
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a class="search" href="javascript:void(0);" id="organ_search2"><span><spring:message code="BUTTON.D.D40.0003" /><%-- 인원추가 --%></span></a></li>
					<li><a class="search" href="javascript:void(0);" id="copyRow"><span><spring:message code="BUTTON.D.D40.0008" /><%-- 행복사 --%></span></a></li>
					<li><a class="search" href="javascript:void(0);" id="addRow"><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><%-- 행추가 --%></span></a></li>
	                <li><a class="search" href="javascript:void(0);" id="deleteRow"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><%-- 행삭제 --%></span></a></li>
					<li><a class="search" href="javascript:void(0);" id="excelDown"><span><!-- 엑셀다운로드 --><spring:message code="BUTTON.D.D40.0002" /></span></a></li>
					<li><a class="darken" href="javascript:void(0);" id="do_save"><span><!-- 저장 --><spring:message code="BUTTON.COMMON.SAVE" /></span></a></li>
				</ul>
			</div>
			<div class="clear"> </div>
		</div>

		<div class="table">
			<div class="wideTable" >
				<table class="listTable">
					<colgroup>
						<col width="4%" />
						<col width="6%" />
						<col width="5%" />
						<col width="5%" />
						<col width="14%" />
						<col width="13%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col />
						<col width="10%" />
					</colgroup>
					<thead>
					<tr name="trStaff">
						<th><input type="checkbox" id="allChk" name="allChk" class="chkbox" ></th>
						<th><!-- 사번--><spring:message code="LABEL.D.D12.0017"/></th>
						<th><!-- 이름--><spring:message code="LABEL.D.D12.0018"/></th>
						<th><!-- 실근무시간(주)--><spring:message code="LABEL.D.D12.0085"/></th>
						<th><!-- 임금유형--><spring:message code="LABEL.D.D08.0004"/></th>
						<th><!-- 일자--><spring:message code="LABEL.D.D15.0206"/></th>
						<th><!-- 일일근무일정--><spring:message code="LABEL.D.D12.0053"/></th>
						<th><!-- 시작시간--><spring:message code="LABEL.D.D12.0020"/></th>
						<th><!-- 종료시간--><spring:message code="LABEL.D.D12.0021"/></th>
						<th><!-- 휴식시작시간--><spring:message code="LABEL.D.D40.0122"/></th>
						<th><!-- 휴식종료시간--><spring:message code="LABEL.D.D40.0123"/></th>
						<th><!-- 근무시간 수--><spring:message code="LABEL.D.D40.0124"/></th>
						<th><!-- 사유--><spring:message code="LABEL.D.D12.0024"/></th>
						<%if("SAVE".equals(gubun)){ %>
						<th class="lastCol" " ><!-- 오류메세지--><spring:message code="LABEL.D.D40.0023"/></th>
						<%}else{ %>
						<th class="lastCol" " ><!-- 비고--><spring:message code='LABEL.D.D14.0017'/></th>
						<%} %>
					</tr>
					</thead>
					<tbody id="-excel-result-tbody">
<%
					if( vt2 != null && vt2.size() > 0 ){
						for( int i = 0; i < vt2.size(); i++ ) {
							D40RemeInfoFrameData data = (D40RemeInfoFrameData)vt2.get(i);
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

							if(data.STDAZ.startsWith(".")){
								data.STDAZ = "0"+data.STDAZ;
							}

							String EDIT = WebUtil.nvl( data.EDIT);
// 							EDIT = "X";

%>
						<tr class="<%=WebUtil.printOddRow(i)%>" id="tr<%=i+1 %>">
							<td>
							<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<input type="checkbox" name="chkSELECT"  value="<%=i+1 %>">
							<%}else{ %>
								<input type="checkbox" name="chkSELECT" disabled="disabled"  value="<%=i+1 %>">
							<%} %>
								<input type="hidden" id="TIME_YN<%=i+1 %>" name="TIME_YN"  value="<%=data.TIME_YN%>">
								<input type="hidden" id="PTIME_YN<%=i+1 %>" name="PTIME_YN"  value="<%=data.PTIME_YN%>">
								<input type="hidden" id="STDAZ_YN<%=i+1 %>" name="STDAZ_YN"  value="<%=data.STDAZ_YN%>">
								<input type="hidden" id="OSEQNR<%=i+1 %>" name="OSEQNR" value="<%=data.OSEQNR%>">
								<input type="hidden" id="CHKDT<%=i+1 %>" name="CHKDT" value="Y">
								<input type="hidden" id="MSG<%=i+1 %>" name="MSG" value="">
								<input type="hidden" id="OBEGDA<%=i+1 %>" name="OBEGDA"  value="<%=data.OBEGDA.replace("-",".")%>">
								<input type="hidden" name="OWTMCODE"  value="<%=data.OWTMCODE%>">
								<input type="hidden" name="LGART"  value="<%=data.LGART%>">
								<input type="hidden" name="OLGART"  value="<%=data.OLGART%>">
								<input type="hidden" name="BETRG"  value="<%=data.BETRG%>">
								<input type="hidden" name="OBETRG"  value="<%=data.OBETRG%>">
								<input type="hidden" name="OBEGUZ"  value="<%=data.OBEGUZ%>">
								<input type="hidden" name="OPBEG1"  value="<%=data.OPBEG1%>">
								<input type="hidden" name="OPEND1"  value="<%=data.OPEND1%>">
								<input type="hidden" name="OSTDAZ"  value="<%=data.OSTDAZ%>">
								<input type="hidden" name="OENDUZ"  value="<%=data.OENDUZ%>">
								<input type="hidden" name="OREASON"  value="<%=data.OREASON%>">
								<input type="hidden" name="ODETAIL"  value="<%=data.ODETAIL%>">
								<input type="hidden" id="ENAME<%=i+1 %>"  name="ENAME" value="<%=data.ENAME%>">
								<input type="hidden" id="WWKTM<%=i+1 %>"  name="WWKTM" value="<%=Math.floor(Double.parseDouble(data.WWKTM) * 10) / 10%>">
								<input type="hidden" id="ACTIO<%=i+1 %>" name="ACTIO"  value="<%=data.ACTIO%>">
							</td>
							<td><%=data.PERNR%><input type="hidden" id="PERNR<%=i+1 %>" name="PERNR" value="<%=data.PERNR%>"></td>
							<td id="td_ENAME<%=i+1 %>"><%=data.ENAME%></td>
							<td id="td_WWKTM<%=i+1 %>"><%=Math.floor(Double.parseDouble(data.WWKTM) * 10) / 10%></td>
							<td>
						<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<select  id="WTMCODE<%=i+1 %>" name="WTMCODE"  style="width: 95%;">
									<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
<%
									for( int j = 0; j < vt4.size(); j++ ) {
										D40RemeInfoFrameData vtData = (D40RemeInfoFrameData)vt4.get(j);
%>
											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.WTMCODE)){ %> selected <%} %>><%=vtData.TEXT %></option>
<%
									}
%>
								</select>
						<%}else{ %>
								<select  id="WTMCODE<%=i+1 %>" name="WTMCODE" disabled="disabled"  style="width: 95%;">
									<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
<%
									for( int j = 0; j < vt4.size(); j++ ) {
										D40RemeInfoFrameData vtData = (D40RemeInfoFrameData)vt4.get(j);
%>
											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.WTMCODE)){ %> selected <%} %>><%=vtData.TEXT %></option>
<%
									}
%>
								</select>
								<input type="hidden" id="WTMCODE<%=i+1 %>" name="WTMCODE"  value="<%=data.WTMCODE%>">
						<%} %>
							</td>
							<td>
						<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<% if(!"0000-00-00".equals(data.BEGDA)){ %>
									<input type="text"  class="date inputDt" id="BEGDA<%=i+1 %>" name="BEGDA" value="<%=data.BEGDA.replace("-",".")%>" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%}else{ %>
									<input type="text"  class="date inputDt" id="BEGDA<%=i+1 %>" name="BEGDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
								<%} %>
						<%}else{ %>
								<% if(!"0000-00-00".equals(data.BEGDA)){ %>
									<input type="text" id="BEGDA<%=i+1 %>" name="BEGDA" disabled="disabled"  value="<%=data.BEGDA.replace("-",".")%>"  style="width: 105px; ">
								<%}else{ %>
									<input type="text" id="BEGDA<%=i+1 %>" name="BEGDA" disabled="disabled"  value=""   style="width: 105px; ">
								<%} %>
								<input type="hidden" id="BEGDA<%=i+1 %>" name="BEGDA"  value="<%=data.BEGDA.replace("-",".")%>">
						<%} %>
							</td>
							<td id="td_TPROG<%=i+1%>"><%=data.TPROG%></td>
							<td>
						<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<%if("Y".equals(WebUtil.nvl(data.PTIME_YN))){ %>
									<input type="text" class="eTime" id="BEGUZ<%=i+1 %>" name="BEGUZ" value="<%=BEGUZ%>"  style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="BEGUZ<%=i+1 %>" name="BEGUZ" disabled="disabled" value="<%=BEGUZ%>"  style="width: 35px;" maxlength="4">
								<%} %>
						<%}else{ %>
								<input type="text" class="eTime" id="BEGUZ<%=i+1 %>" name="BEGUZ" disabled="disabled" value="<%=BEGUZ%>"  style="width: 35px;" maxlength="4">
						<%} %>
							</td>
							<td>
						<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<%if("Y".equals(WebUtil.nvl(data.PTIME_YN))){ %>
									<input type="text" class="eTime" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=ENDUZ%>" style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=ENDUZ%>" disabled="disabled" style="width: 35px;" maxlength="4">
								<%} %>
						<%}else{ %>
								<input type="text" class="eTime" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=ENDUZ%>" disabled="disabled" style="width: 35px;" maxlength="4">
						<%} %>
							</td>
							<td id="td_TIME<%=i+1 %>" style="display: none;">
						<%if(!"Y".equals(data.PTIME_YN) || !"X".equals(EDIT)){ %>
								<input type="hidden" id="BEGUZ<%=i+1 %>" name="BEGUZ" value="<%=BEGUZ%>" >
								<input type="hidden" id="ENDUZ<%=i+1 %>" name="ENDUZ" value="<%=ENDUZ%>" >
						<%} %>
							</td>
							<td>
						<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<%if("Y".equals(WebUtil.nvl(data.PTIME_YN))){ %>
									<input type="text" class="eTime" id="PBEG1<%=i+1 %>" name="PBEG1" value="<%=PBEG1%>"  style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="PBEG1<%=i+1 %>" name="PBEG1" disabled="disabled" value="<%=PBEG1%>"  style="width: 35px;" maxlength="4">
								<%} %>
						<%}else{ %>
								<input type="text" class="eTime" id="PBEG1<%=i+1 %>" name="PBEG1" disabled="disabled" value="<%=PBEG1%>"  style="width: 35px;" maxlength="4">
						<%} %>
							</td>
							<td>
						<%if("X".equals(WebUtil.nvl(EDIT))){ %>
								<%if("Y".equals(WebUtil.nvl(data.PTIME_YN))){ %>
									<input type="text" class="eTime" id="PEND1<%=i+1 %>" name="PEND1" value="<%=PEND1%>" style="width: 35px;" maxlength="4">
								<%}else{ %>
									<input type="text" class="eTime" id="PEND1<%=i+1 %>" name="PEND1" value="<%=PEND1%>" disabled="disabled" style="width: 35px;" maxlength="4">
								<%} %>
						<%}else{ %>
								<input type="text" class="eTime" id="PEND1<%=i+1 %>" name="PEND1" value="<%=PEND1%>" disabled="disabled" style="width: 35px;" maxlength="4">
						<%} %>
							</td>
							<td id="td_PTIME<%=i+1 %>" style="display: none;">
						<%if(!"Y".equals(data.PTIME_YN) || !"X".equals(EDIT)){ %>
								<input type="hidden" id="PBEG1<%=i+1 %>" name="PBEG1" value="<%=PBEG1%>" >
								<input type="hidden" id="PEND1<%=i+1 %>" name="PEND1" value="<%=PEND1%>" >
						<%} %>
							</td>
							<td>
								<%if("X".equals(WebUtil.nvl(EDIT))){ %>
									<%if("Y".equals(WebUtil.nvl(data.STDAZ_YN))){ %>
										<input type="text" id="STDAZ<%=i+1 %>" name="STDAZ" value="<%=data.STDAZ%>" style="width: 35px;" maxlength="5">
									<%}else{ %>
										<input type="text" id="STDAZ<%=i+1 %>" name="STDAZ" value="<%=data.STDAZ%>" disabled="disabled" style="width: 35px;" maxlength="5">
									<%} %>
								<%}else{ %>
									<input type="text" id="STDAZ<%=i+1 %>" name="STDAZ" value="<%=data.STDAZ%>" disabled="disabled" style="width: 35px;" maxlength="5">
								<%} %>
							</td>
							<td id="td_STDAZ<%=i+1 %>" style="display: none;">
						<%if(!"Y".equals(data.STDAZ_YN)){ %>
								<input type="hidden" id="STDAZ<%=i+1 %>" name="STDAZ" value="<%=data.STDAZ%>" >
						<%} %>
							</td>
							<%
								String view = "";
								if(!"Y".equals(data.REASON_YN)){
									view = "disabled='disabled'";
								}
								if(!"X".equals(EDIT)){
									view = "disabled='disabled'";
								}
							%>
							<td style="text-align: left;" id="td<%=i+1 %>">
								<input type="hidden" id="REASON_YN<%=i+1 %>" name="REASON_YN"  value="<%=data.REASON_YN%>">
								<select  id="REASON<%=i+1 %>" name="REASON"  <%=view %> style="width: 50%; margin-top: 5px;">
									<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
<%
									for( int j = 0; j < vt3.size(); j++ ) {
										D40RemeInfoFrameData vtData = (D40RemeInfoFrameData)vt3.get(j);
										if(vtData.PKEY.equals(data.WTMCODE)){
%>
											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.REASON)){ %> selected <%} %>><%=vtData.TEXT %></option>
<%
										}
									}
%>
								</select>
						<%if("X".equals(WebUtil.nvl(EDIT))){ %>
							<%if("Y".equals(WebUtil.nvl(data.DETAIL_YN))){ %>
									<input type=text id="DETAIL<%=i+1 %>" name="DETAIL" value="<%=data.DETAIL%>"  title="<%=data.DETAIL%>" style="width: 43%; margin-bottom: 6px;">
							<%}else{ %>
									<input type=text id="DETAIL<%=i+1 %>" name="DETAIL" disabled="disabled" value="<%=data.DETAIL%>" title="<%=data.DETAIL%>" style="width: 43%; margin-bottom: 6px;">
							<%} %>
						<%}else{ %>
								<input type=text id="DETAIL<%=i+1 %>" name="DETAIL" disabled="disabled" value="<%=data.DETAIL%>" title="<%=data.DETAIL%>"  style="width: 43%; margin-bottom: 6px;">
						<%} %>
								<input type="hidden" id="DETAIL_YN<%=i+1 %>" name="DETAIL_YN"  value="<%=data.DETAIL_YN%>">
							</td>
							<td id="td_REASON<%=i+1 %>" style="display: none;">
						<%if(!"Y".equals(data.REASON_YN) || !"X".equals(EDIT)){ %>
								<input type=hidden id="REASON<%=i+1 %>" name="REASON"  value="<%=data.REASON%>" >
						<%} %>
							</td>
							<td id="td_DETAIL<%=i+1 %>" style="display: none;">
						<%if(!"Y".equals(data.DETAIL_YN) || !"X".equals(EDIT)){ %>
								<input type=hidden id="DETAIL<%=i+1 %>" name="DETAIL" value="<%=data.DETAIL%>" >
						<%} %>
							</td>
							<td id="td_EDIT<%=i+1 %>" style="display: none;">
								<input type="hidden" id="EDIT<%=i+1 %>"  name="EDIT"  value="<%=EDIT%>">
								<input type="hidden" id="AWART<%=i+1 %>" name="AWART"  value="<%=data.AWART%>">
								<input type="hidden" id="INFTY<%=i+1 %>" name="INFTY"  value="<%=data.INFTY%>">
								<input type="hidden" id="TPROG<%=i+1 %>" name="TPROG" value="<%=data.TPROG%>">
							</td>
						<%if("SAVE".equals(gubun)){ %>
							<td class="lastCol" style="text-align : left"><%=data.MSG%></td>
						<%}else{ %>
							<td class="lastCol" style="text-align : left"><%=data.ETC%></td>
						<%} %>
						</tr>
<%
			} //end for
		}else{
			if("SAVE".equals(gubun) && "M".equals(E_RETURN) ){
%>
			<tr class="oddRow" id="lastMessage">
				<td class="lastCol" colspan="14"><spring:message code="MSG.D.D40.0012"/><!-- 전체 데이터가 성공적으로 처리되었습니다. --></td>
			</tr>

<%
			}else{
%>
			<tr class="oddRow" id="lastMessage">
				<td class="lastCol" colspan="14"><spring:message code="MSG.COMMON.0004"/></td>
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
	            <li><a class="darken" href="javascript:void(0);" id="save"><span><spring:message code="BUTTON.COMMON.SAVE" /><!-- 저장 --></span></a></li>
	        </ul>
	    </div>
	</div>
</form>

<!-- 50시간 초과 경고 Layer -->
<div style="width:600px;height:370px; padding:5px; display:none" id="overtime50Layer">
	<div class="winPop">
		<div class="header" style="text-align:left;">
	    	<span><spring:message code="LABEL.D.D12.0086"/><%--주간 실근무시간 50시간 초과자--%></span>
	    	<a href="#" data-name="overtime50LayerClose"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
	    </div>
	
		<div class="body" style="text-align:left;">
			<h2 class="subtitle"><spring:message code='LABEL.D.D12.0087' /><!-- 주 50시간 초과 근무자입니다. 법정한도 초과시 입력불가하오니 기준 준수될 수 있도록 관리 바랍니다. --></h2>
			<div class="tableArea">
    			<div class="table" style="overflow-x:hidden;overflow-y:scroll;margin-bottom:5px; min-height:175px; max-height:175px;">
      				<table class="listTable" style="table-layout:fixed; margin-bottom:0; border-bottom:0;">
						<colgroup>
							<col width="15%" />
							<col width="15%" />
							<col width="35%" />
							<col />
						</colgroup>
						<thead>
							<th><spring:message code="LABEL.D.D12.0017"/><!-- 사번 --></th>
							<th><spring:message code="LABEL.D.D12.0018"/><!-- 이름 --></th>
							<th><spring:message code="LABEL.D.D12.0088"/><!-- 주간 --></th>
							<th><spring:message code="LABEL.D.D12.0089"/><!-- 주간 실근무시간 --></th>
						</thead>
						<tbody id="listData">
							<c:if test="${not empty OBJPS_OUT6}">
								<c:forEach var="result" varStatus="varStatus" items="${OBJPS_OUT6}">
									<tr <c:if test="${(i % 2) == 0}">class="oddRow"</c:if>>
										<td>${result.PERNR}</td>
										<td>${result.ENAME}</td>
										<td>${result.BEGDA} ~ ${result.ENDDA}</td>
										<td>
											<fmt:formatNumber var="decimalPoint" value="${(result.WWKTM % 1) % 0.1}" />
		            						<fmt:formatNumber value="${result.WWKTM - (decimalPoint eq 0.1 ? 0 : decimalPoint)}" pattern="0.0" />
										</td>
									</tr>
								</c:forEach>
							</c:if>
						</tbody>
					</table>
				</div>
			</div>
	
			<div class="clear"></div>
		  	<div class="buttonArea" style="padding-right: 40px;">
		  		<ul class="btn_crud">
		  			<li><a href="#" data-name="overtime50LayerClose"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
		  		</ul>
		  	</div>
		</div>
	</div>
</div>
<!-- 50시간 초과 경고 Layer 끝 -->

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

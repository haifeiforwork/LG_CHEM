<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   일일근무일정												*/
/*   Program Name	:   일일근무일정 조회/변경(개별)							*/
/*   Program ID		: D40DailScheEach.jsp									*/
/*   Description		: 일일근무일정 (개별) 조회/저장							*/
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
	Vector vt3    = (Vector)request.getAttribute("OBJPS_OUT3");	//계획근무

%>
<jsp:include page="/include/header.jsp" />
<c:set var="count" value="<%=vt2.size()%>"/>
<c:set var="eInfo" value="<%=E_INFO%>"/>

<script language="JavaScript">


<%
	if("Y".equals(textChange)){
%>
	parent.$("#searchOrg_ment").html('<font color="red"><strong><c:out value="${eInfo }"/></strong></font>');
<%
	}
%>

	var rowCnt = '<c:out value="${count }"/>';
	var orgVal = "";

	function validation(){
		var chk = true;
		if($("input[name=PERNR]").length == 0){
			alert('<spring:message code="MSG.D.D40.0015"/>');
			chk = false;
			return false;
		}

		$("input[name=PERNR]").each(function(idx){
			var no = $(this).attr("id").substring(5);

			if($("#ACTIO"+no).val() != "DEL"){ //삭제 플래그는 validation 제외한다
				if($.trim($("#PERNR"+no).val()) == ""){
					alert('<spring:message code="MSG.D.D40.0017"/>');
					$("#PERNR"+no).focus();
					chk = false;
					return false;
				}

				var ename = $("#ENAME"+no).val() !="" ? "("+$("#ENAME"+no).val()+")" : "";
				var target = $("#PERNR"+no).val()+ename;

				if($.trim($("#BEGDA"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0031"/>');	/* 의 시작일은 필수 입니다. */
					$("#BEGDA"+no).focus();
					chk = false;
					return false;
				}

				if($.trim($("#ENDDA"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0032"/>');	/* 의 종료일은 필수 입니다. */
					$("#ENDDA"+no).focus();
					chk = false;
					return false;
				}

				if($.trim($("#TPROG"+no).val()) == ""){
					alert(target+'<spring:message code="MSG.D.D40.0039"/>');	/* 의 일일근무일정은 필수 입니다. */
					$("#TPROG"+no).focus();
					chk = false;
					return false;
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

	function makeInput(){
		var arrPERNR = $("#popPERNR").val().split(',');
		var arrENAME = $("#popENAME").val().split(',');

		if(rowCnt == 0){
			$("#lastMessage").remove();
		}
		var html = "";

		$.each( arrPERNR, function( i, val ) {
			rowCnt++;

			var selList = selectList(rowCnt);

			html += '<tr id="tr'+rowCnt+'">';
			html += '		<td>';
			html += '			<input type="checkbox" name="chkbutton"  value="'+rowCnt+'">';
			html += '			<input type="hidden" name="ACTIO" id="ACTIO'+rowCnt+'" value="INS">';
			html += '			<input type="hidden" name="OBEGDA" value="">';
			html += '			<input type="hidden" name="OENDDA" value="">';
			html += '			<input type="hidden" name="OSEQNR" id="OSEQNR'+rowCnt+'" value="">';
			html += '			<input type="hidden" name="OTPROG" value="">';
			html += '			<input type="hidden" name="EDIT" id="EDIT'+rowCnt+'" value="">';
			html += '			<input type="hidden" name="ENAME" id="ENAME'+rowCnt+'" value="'+arrENAME[i]+'">';
			html += '			<input type="hidden" id="CHKDT'+rowCnt+'" name="CHKDT" value="X">';
			html += '			<input type="hidden" id="MSG'+rowCnt+'" name="MSG" value="">';
			html += '		</td>';
			html += '		<td><input type="text" id="PERNR'+rowCnt+'" name="PERNR" value="'+val+'" style="width: 90%;" maxlength="8"></td>';
			html += '		<td id="td_ENAME'+rowCnt+'">'+arrENAME[i]+'</td>';
			html += '		<td><input type="text" class="date inputDt" id="BEGDA'+rowCnt+'" name="BEGDA" value="" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px"></td>';
			html += '		<td><input type="text" class="date inputDt" id="ENDDA'+rowCnt+'" name="ENDDA" value="" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px"></td>';
			html += '		<td>'+selList+'</td>';
			html += '		<td class="lastCol" style="text-align : left"></td>';
			html += '</tr>';

		});

		var trHtml = $( "tr[name=trStaff]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출

		trHtml.after(html); //마지막 trStaff명 뒤에 붙인다.

		afterChk();

	}

	function selectList(index){

		var selectList = '<select id="TPROG'+index+'" name="TPROG" style="width: 90%;">';
			selectList += '<option value=""><spring:message code="LABEL.D.D03.0033"/></option>';
<%
			for( int j = 0; j < vt3.size(); j++ ) {
				D40DailScheFrameData vtData = (D40DailScheFrameData)vt3.get(j);
%>
			selectList += '<option value="<%=vtData.CODE%>" ><%=vtData.TEXT %></option>';
<%
			}
%>
			selectList += '</select>';
		return selectList;
	}

	//이벤트 활성화
	function afterChk(){

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
				if ($("#PERNR"+no).val().match(/^\d+$/gi) == null) {
			    	alert('<spring:message code="MSG.D.D40.0004"/>'); /* 사번은 숫자만 넣으세요! */
			        return;
			    }
				parent.blockFrame();
				var frm = document.form1;
				frm.gubun.value = "SEARCHONE";
				frm.searchPERNR.value = $("#PERNR"+no).val();
				frm.searchBEGDA.value = $(this).val();
				frm.no.value = no;
		        frm.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailScheEachSV";
		        frm.target = "ifHidden";
		        frm.submit();
	 		}
		});

		var height = document.body.scrollHeight;
		parent.autoResize(height);

	}


	$(document).on('blur', "input:text[name='PERNR']",function(){
 		if($(this).val()==""){return;}
 		if(orgVal == $(this).val()){return;}
 		if ($(this).val().match(/^\d+$/gi) == null) {
	    	alert('<spring:message code="MSG.D.D40.0004"/>'); /* 사번은 숫자만 넣으세요! */
	        return;
	    }
 		var no = $(this).attr("id").substring(5);
 		if($("#BEGDA"+no).val() == ""){return;}

		parent.blockFrame();
		var frm = document.form1;
		frm.gubun.value = "SEARCHONE";
		frm.searchPERNR.value = $(this).val();
		frm.searchBEGDA.value = $("#BEGDA"+no).val();
		frm.no.value = no;
        frm.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailScheEachSV";
        frm.target = "ifHidden";
        frm.submit();
	});

	$(document).on('click', "input:text[name='PERNR']",function(){
		if($(this).val()==""){return;}
		orgVal = $(this).val();
	});

	$(function() {

		//행추가
		$("#addRow").click(function(){

			if(rowCnt == 0){
				$("#lastMessage").remove();
			}
			rowCnt++;
			var selList = selectList(rowCnt);
			var html = "";

			html += '<tr id="tr'+rowCnt+'">';
			html += '		<td>';
			html += '			<input type="checkbox" name="chkbutton"  value="'+rowCnt+'">';
			html += '			<input type="hidden" name="ACTIO" id="ACTIO'+rowCnt+'" value="INS">';
			html += '			<input type="hidden" name="OBEGDA" value="">';
			html += '			<input type="hidden" name="OENDDA" value="">';
			html += '			<input type="hidden" name="OSEQNR" id="OSEQNR'+rowCnt+'" value="">';
			html += '			<input type="hidden" name="OTPROG" value="">';
			html += '			<input type="hidden" name="EDIT" id="EDIT'+rowCnt+'" value="">';
			html += '			<input type="hidden" name="ENAME" id="ENAME'+rowCnt+'" value="">';
			html += '			<input type="hidden" id="CHKDT'+rowCnt+'" name="CHKDT" value="X">';
			html += '			<input type="hidden" id="MSG'+rowCnt+'" name="MSG" value="">';
			html += '		</td>';
			html += '		<td><input type="text" id="PERNR'+rowCnt+'" name="PERNR" value="" style="width: 90%;" maxlength="8"></td>';
			html += '		<td id="td_ENAME'+rowCnt+'"></td>';
			html += '		<td><input type="text" class="date inputDt" id="BEGDA'+rowCnt+'" name="BEGDA" value="" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px"></td>';
			html += '		<td><input type="text" class="date inputDt" id="ENDDA'+rowCnt+'" name="ENDDA" value="" size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px"></td>';
			html += '		<td>'+selList+'</td>';
			html += '		<td class="lastCol" style="text-align : left"></td>';
			html += '</tr>';

			var trHtml = $( "tr[name=trStaff]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출

			trHtml.after(html); //마지막 trStaff명 뒤에 붙인다.

			afterChk();
		});

		//조회
		$("#do_search").click(function(){
			//상단 공통 조회조건
			parent.blockFrame();
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

			var vObj = document.form1;
			$("#I_ACTTY").val("R");
			$("#gubun").val("SEARCH");
		    vObj.target = "_self";
		    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailScheEachSV";
		    vObj.method = "post";
		    vObj.submit();

		});

		//엑셀다운로드
		$("#excelDown").click(function(){
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

			var vObj = document.form1;
			$("#I_ACTTY").val("R");
			$("#gubun").val("EXCEL");
		    vObj.target = "ifHidden";
		    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailScheEachSV";
		    vObj.method = "post";
		    vObj.submit();
		});

		//사원선택 input삭제
		$("#dt_clear").click(function(){
			$("#I_PERNR").val("");
			$("#I_ENAME").val("");
		});

		//행삭제
		$("#deleteRow").click(function(){
			if($("input:checkbox[name=chkbutton]:checked").length == 0){
				alert('<spring:message code="MSG.D.D11.0021"/>'); /* 삭제할 건을 선택하세요. */
				return;
			}

			$("input:checkbox[name=chkbutton]:checked").each(function () {

				if($("#OSEQNR"+$(this).val()).val() == ""){
					$("#tr"+$(this).val()).remove();
				}else{
					$("#tr"+$(this).val()).hide();
					$("#ACTIO"+$(this).val()).val("DEL");
				}
			});
		});

		//전체선택
		$("#allChk").click(function(){
			if(this.checked == true){
				$('input:checkbox[name="chkbutton"]').each(function(){
					if($(this).attr("disabled") != "disabled"){
						this.checked = true;
					}
				});
			}else{
				$('input:checkbox[name="chkbutton"]').each(function(){
					this.checked = false;
				});
			}
		});

		//저장
		$("#do_save, #save").click(function(){
			if(validation()){
				parent.saveBlockFrame();
				$("#gubun").val("SAVE");
				document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailScheEachSV";
				document.form1.method = "post";
				document.form1.target = "_self";
				document.form1.submit();
			}
		});

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

		//사원검색 Popup.
		$("#organ_search2").click(function(){

			var small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
		    small_window.focus();
		    $("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		    $("#iSeqno").val(parent.$("#iSeqno").val());
		    $("#pageGubun").val("C");

		    $("#form1").attr("action","<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListFramePop.jsp");
		    $("#form1").attr("target", "Organ");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();
		});

		//시작일 P모드 조회
		$(".inputDt").change(function(){
			var id = $(this).attr("id").substring(0,5);
			var no = $(this).attr("id").substring(5);

  			if(id == "BEGDA"){
  				$("#ENDDA"+no).val($(this).val());
  			}
  			if($(this).val()==""){return;}
  			if(id == "ENDDA"){return;}

			if($("#PERNR"+no).val() != ""){
				if ($("#PERNR"+no).val().match(/^\d+$/gi) == null) {
			    	alert('<spring:message code="MSG.D.D40.0004"/>'); /* 사번은 숫자만 넣으세요! */
			        return;
			    }
				parent.blockFrame();
				var frm = document.form1;
				frm.gubun.value = "SEARCHONE";
				frm.searchPERNR.value = $("#PERNR"+no).val();
				frm.searchBEGDA.value = $(this).val();
				frm.no.value = no;
		        frm.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailScheEachSV";
		        frm.target = "ifHidden";
		        frm.submit();
	 		}
		});

		var height = document.body.scrollHeight;
		parent.autoResize(height+30);
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
	<input type="hidden" id="popPERNR" name="popPERNR" value="">
	<input type="hidden" id="popENAME" name="popENAME" value="">
	<input type="hidden" id="no" name="no" value="">

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
                    <spring:message code='LABEL.D.D12.0077'/><!-- 조회기간 -->
                </th>
                <td>
					<input type="text" id="I_BEGDA" class="date" name="I_BEGDA" value="<%= WebUtil.printDate(E_BEGDA) %>" size="15" > ~
					<input type="text" id="I_ENDDA" class="date" name="I_ENDDA" value="<%= WebUtil.printDate(E_ENDDA) %>" size="15" >
                </td>
                <th>
                    <spring:message code='LABEL.D.D40.0025'/><!-- 계획근무 -->
                </th>
                <td>
					<select name="I_SCHKZ" id="I_SCHKZ" style="width: 100%">
						<option value=""><spring:message code='LABEL.COMMON.0024'/><!-- 전체 --></option>
<%
							for( int j = 0; j < vt1.size(); j++ ) {
								D40DailScheFrameData vtData = (D40DailScheFrameData)vt1.get(j);
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
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:void(0);" id="do_search"><span><spring:message code="BUTTON.COMMON.SEARCH"/><!-- 조회 --></span></a>
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
					<li><a class="search" href="javascript:void(0);" id="organ_search2" style="cursor: pointer;"><span><spring:message code="BUTTON.D.D40.0003" /><%-- 인원추가 --%></span></a></li>
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
				<table class="listTable" >
					<colgroup>
<!-- 						<col width="4%" /> -->
						<col width="5%" />
						<col width="10%" />
						<col width="10%" />
						<col width="15%" />
						<col width="15%" />
						<col width="20%" />
						<col />
					</colgroup>
					<thead>
					<tr name="trStaff">
<%-- 						<th><!-- 구분--><spring:message code='LABEL.F.F42.0055'/></th> --%>
						<th><input type="checkbox" id="allChk" name="allChk" class="chkbox" ></th>
						<th><!-- 사번--><spring:message code='LABEL.D.D05.0005'/></th>
						<th><!-- 이름--><spring:message code='LABEL.D.D05.0006'/></th>
						<th><!-- 시작일--><spring:message code="LABEL.D.D15.0152"/></th>
						<th><!-- 종료일--><spring:message code="LABEL.D.D15.0153"/></th>
						<th><!-- 일일근무일정--><spring:message code="LABEL.D.D12.0053"/></th>
					<%if("SAVE".equals(gubun)){ %>
						<th class="lastCol"><!-- 오류메세지--><spring:message code='LABEL.D.D40.0023'/></th>
					<%}else{ %>
						<th class="lastCol"><!-- 비고--><spring:message code='LABEL.D.D14.0017'/></th>
					<%} %>
					</tr>
					</thead>
					<tbody id="-excel-result-tbody">

<%
					if( vt2 != null && vt2.size() > 0 ){
						for( int i = 0; i < vt2.size(); i++ ) {
							D40DailScheFrameData data = (D40DailScheFrameData)vt2.get(i);
					        String tr_class = "";
					        if(i%2 == 0){
					            tr_class="oddRow";
					        }else{
					            tr_class="";
					        }
%>
						<tr class="<%=tr_class%>"  id="tr<%=i+1 %>">
<%-- 							<td><%=i+1 %></td> --%>
							<td>
								<input type="checkbox" name="chkbutton" class="chkbox" value="<%=i+1 %>" >
								<input type="hidden" name="ACTIO" id="ACTIO<%=i+1 %>"   value="<%=data.ACTIO%>">
								<input type="hidden" name="OBEGDA"  value="<%=data.OBEGDA.replace("-",".")%>">
								<input type="hidden" name="OENDDA"  value="<%=data.OENDDA.replace("-",".")%>">
								<input type="hidden" name="OSEQNR" id="OSEQNR<%=i+1 %>"  value="<%=data.OSEQNR%>">
								<input type="hidden" name="OTPROG" id="OTPROG<%=i+1 %>"  value="<%=data.OTPROG%>">
								<input type="hidden" name="EDIT" id="EDIT<%=i+1 %>" value="<%=data.EDIT%>">
								<input type="hidden" name="ENAME" id="ENAME<%=i+1 %>"  value="<%=data.ENAME%>">
								<input type="hidden" id="CHKDT<%=i+1 %>" name="CHKDT" value="Y">
								<input type="hidden" id="MSG<%=i+1 %>" name="MSG" value="">
							</td>
							<td>
								<%=data.PERNR%>
								<input type="hidden" id="PERNR<%=i+1 %>" name="PERNR" value="<%=data.PERNR%>">
							</td>
							<td>
								<%=data.ENAME%>
							</td>
							<td>
								<% if(!"0000-00-00".equals(data.BEGDA)){ %>
									<input type="text"  class="date inputDt" id="BEGDA<%=i+1 %>" name="BEGDA" value="<%=data.BEGDA.replace("-",".")%>" size="15"  style="margin-right: 4px">
								<%}else{ %>
									<input type="text"  class="date inputDt" id="BEGDA<%=i+1 %>" name="BEGDA" value=""  size="15" style="margin-right: 4px">
								<%} %>
							</td>
							<td>
								<% if(!"0000-00-00".equals(data.ENDDA)){ %>
									<input type="text"  class="date inputDt" id="ENDDA<%=i+1 %>" name="ENDDA" value="<%=data.ENDDA.replace("-",".")%>" size="15"  style="margin-right: 4px">
								<%}else{ %>
									<input type="text"  class="date inputDt" id="ENDDA<%=i+1 %>" name="ENDDA" value=""  size="15" style="margin-right: 4px">
								<%} %>
							</td>
							<td>
							<% if("X".equals(data.EDIT)){ %>
								<select id="TPROG<%=i+1 %>" name="TPROG" style="width: 90%;" >
							<%}else{ %>
								<input type="hidden" id="TPROG<%=i+1 %>" name="TPROG" value="<%=data.TPROG%>">
								<select id="TPROG<%=i+1 %>" name="TPROG" style="width: 140px;" disabled="disabled" >
							<%} %>
									<option value=""><spring:message code='LABEL.D.D03.0033'/><!-- 선택 --></option>
<%
							for( int j = 0; j < vt3.size(); j++ ) {
								D40DailScheFrameData vtData = (D40DailScheFrameData)vt3.get(j);
%>
									<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.TPROG)){ %> selected <%} %> ><%=vtData.TEXT %></option>
<%
							}
%>
								</select>
							</td>
						<%if("SAVE".equals(gubun)){ %>
							<td class="lastCol" style="text-align : left"><%=data.MSG%></td>
						<%}else{ %>
							<td class="lastCol"><%=data.ETC%></td>
						<%} %>
						</tr>
<%
			} //end for
		}else{
			if("SAVE".equals(gubun) && "M".equals(E_RETURN) ){
%>
			<tr class="oddRow" id="lastMessage">
				<td class="lastCol" colspan="7"><spring:message code="MSG.D.D40.0012"/><!-- 전체 데이터가 성공적으로 처리되었습니다. --></td>
			</tr>

<%
			}else{
%>
			<tr class="oddRow" id="lastMessage">
				<td class="lastCol" colspan="7"><spring:message code="MSG.COMMON.0004"/></td>
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

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

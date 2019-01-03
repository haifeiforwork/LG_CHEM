<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   일일근무일정												*/
/*   Program Name	:   일일근무일정(일괄)										*/
/*   Program ID		: D40DailScheLumpExcel.jsp							*/
/*   Description		: 일일근무일정(일괄) 										*/
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
	String sMenuCode =  (String)request.getAttribute("sMenuCode");
	Vector vt    = (Vector)request.getAttribute("OBJPS_OUT");
	Vector dataList    = (Vector)request.getAttribute("T_EXLIST");

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
	parent.$("#searchOrg_ment").html('<font color="red"><strong><c:out value="${eInfo }" /></strong></font>');
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

	function excelDown(){
		$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
		$("#searchDeptNm").val(parent.$("#searchDeptNm").val());
// 		alert($("#searchDeptNo").val());
// 		alert($("#searchDeptNm").val());
// 		$("#iSeqno").val(parent.$("#iSeqno").val());
// 		$("#I_SELTAB").val(parent.$("#I_SELTAB").val());

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
		$("#I_ACTTY").val("T");
		$("#gubun").val("EXCEL");
	    vObj.target = "ifHidden";
	    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailScheLumpSV";
// 	    vObj.action = "${g.jsp}D/D40TmGroup/D40TmGroupPersExcel.jsp";
	    vObj.method = "post";
	    vObj.submit();
	}

	function excelUpload(){
		small_window = window.open('${g.servlet}hris.D.D40TmGroup.D40DailScheFileUploadSV?',
				"ScheduleExcelUpload","width=440,height=300,left=365,top=70,scrollbars=no");
		small_window.focus();
	}

	function selectList(value, index){
	<%
		if( vt != null && vt.size() > 0 ){
	%>
			var selectList = '<select id="TPROG'+index+'" name="TPROG"><option value="">선택</option>';
			var code;
			var text;
	<%
			for( int i = 0; i < vt.size(); i++ ) {
				D40DailScheFrameData data = (D40DailScheFrameData)vt.get(i);
	%>
				code = '<%=data.CODE%>';
				text = '<%=data.TEXT%>';
				if(value == code){
					selectList += '<option value="'+code+'" selected>'+text+'</option>'
				}else{
					selectList += '<option value="'+code+'">'+text+'</option>'
				}
	<%
			}
	%>
			selectList += '</select>';
	<%
		}
	%>
		return selectList;
	}

	function afterUploadProcess(data, state, msg) {
		data = JSON.parse(data);
		$("#-excel-result-tbody").html("");
		alert(msg);
		var html = "";
		var index = 1;
		_.each(data.resultList, function(row) {
			var select = selectList(row.TPROG, index);
			html += '<tr>'+
							'<td>'+index+'<input type="hidden" id="CHKDT'+index+'" name="CHKDT" value="X"><input type="hidden" id="MSG'+index+'" name="MSG" value=""></td>'+
							'<td>'+row.PERNR+'<input type="hidden" id="PERNR'+index+'" name="PERNR" value="'+row.PERNR+'"></td>'+
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
			html +=		'<td>'+select+'</td>'+
							'<td class="lastCol" style="text-align : left">'+row.MSG+'</td>'+
						'</tr>';
			index++;
		});
		if(state == "M"){
			html = '<tr><td class="lastCol" colspan="6"><spring:message code="MSG.D.D40.0012"/></td></tr>';	/* 전체 데이터가 성공적으로 처리되었습니다. */
		}
		$("#-excel-result-tbody").append(html);

		$('.date').each(function(){
			addDatePicker($('.date'));
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
	}

	function do_save(){
		if($("input[name=PERNR]").length == 0){
			alert('<spring:message code="MSG.D.D40.0014"/>');	/* 저장할 일일근무일정이 없습니다. */
			return;
		}
		if(validation()){
			parent.saveBlockFrame();
			$("#gubun").val("SAVE");
			document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailScheLumpSV";
			document.form1.method = "post";
			document.form1.target = "_self";
			document.form1.submit();
		}
	}

	function validation(){
		var chk = true;
		if($("input[name=PERNR]").length == 0){
			alert('<spring:message code="MSG.D.D40.0015"/>');
			chk = false;
			return false;
		}

		$("input[name=PERNR]").each(function(idx){
			var no = $(this).attr("id").substring(5);

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
// 			if($.trim($("#CHKDT"+no).val()) == "X"){
// 				alert(target+'<spring:message code="MSG.D.D40.0051"/> '+$("#MSG"+no).val() );
// 				chk = false;
// 				return false;
// 			}
		});
		return chk;
	}

	$(function() {

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
	});

</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<form name="form1" method="post" onsubmit="return false">
	<input type="hidden" id="orgOrTm" name="orgOrTm" value="">
	<input type="hidden" id="searchDeptNo" name="searchDeptNo" value="">
	<input type="hidden" id="searchDeptNm" name="searchDeptNm" value="">
	<input type="hidden" id="searchPERNR" name="searchPERNR" value="">
	<input type="hidden" id="searchBEGDA" name="searchBEGDA" value="">
	<input type="hidden" id="iSeqno" name="iSeqno" value="">
	<input type="hidden" id="ISEQNO" name="ISEQNO" value="">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB" value="">
	<input type="hidden" id="I_ACTTY" name="I_ACTTY" value="">
	<input type="hidden" id="gubun" name="gubun" value="">
	<input type="hidden" id="no" name="no" value="">

	<div class="listArea">
		<div class="listTop">
			<span class="listCnt"><font color="red"><strong><spring:message code="LABEL.D.D40.0022"/></strong></font></span>
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a href="javascript:excelDown();"><span><!-- Excel Template --><spring:message code="BUTTON.D.D40.0005"/></span></a></li>
					<li><a href="javascript:excelUpload();"><span><!-- 엑셀업로드--><spring:message code="LABEL.D.D13.0020"/></span></a></li>
					<li><a class="darken" href="javascript:do_save();"><span><!-- 저장 --><spring:message code="BUTTON.COMMON.SAVE" /></span></a></li>
				</ul>
			</div>
			<div class="clear"> </div>
		</div>

		<div class="table">
			<div class="wideTable" >
				<table class="listTable">
					<colgroup>
						<col width="4%" />
						<col width="8%" />
						<col width="12%" />
						<col width="15%" />
						<col width="15%" />
						<col width="20%" />
						<col />
					</colgroup>
					<thead>
					<tr>
						<th><!-- 라인--><spring:message code="LABEL.D.D12.0084"/></th>
						<th><!-- 사번--><spring:message code="LABEL.D.D12.0017"/></th>
						<th><!-- 이름--><spring:message code="LABEL.D.D12.0018"/></th>
						<th><!-- 시작일--><spring:message code="LABEL.D.D15.0152"/></th>
						<th><!-- 종료일--><spring:message code="LABEL.D.D15.0153"/></th>
						<th><!-- 일일근무일정--><spring:message code="LABEL.D.D12.0053"/></th>
						<th class="lastCol" " ><!-- 오류메세지--><spring:message code="LABEL.D.D40.0023"/></th>
					</tr>
					</thead>
					<tbody id="-excel-result-tbody">
<%
					if( dataList != null && dataList.size() > 0 ){
						for( int i = 0; i < dataList.size(); i++ ) {
							D40DailScheFrameData data = (D40DailScheFrameData)dataList.get(i);
					        String tr_class = "";
					        if(i%2 == 0){
					            tr_class="oddRow";
					        }else{
					            tr_class="";
					        }
%>
						<tr>
							<td>
								<%=i+1 %>
								<input type="hidden" id="CHKDT<%=i+1 %>" name="CHKDT" value="Y">
								<input type="hidden" id="MSG<%=i+1 %>" name="MSG" value="">
							</td>
							<td><%=data.PERNR%><input type="hidden" id="PERNR<%=i+1 %>" name="PERNR" value="<%=data.PERNR%>"></td>
							<td><%=data.ENAME%><input type="hidden" name="ENAME" value="<%=data.ENAME%>"></td>
							<td>
								<% if(!"0000-00-00".equals(data.BEGDA)){ %>
									<input type="text"  class="date inputDt" id="BEGDA<%=i+1 %>" name="BEGDA" value="<%=data.BEGDA%>" size="15" style="margin-right: 4px">
								<%}else{ %>
									<input type="text"  class="date inputDt" id="BEGDA<%=i+1 %>" name="BEGDA" value="" size="15" style="margin-right: 4px">
								<%} %>
							</td>
							<td>
								<% if(!"0000-00-00".equals(data.ENDDA)){ %>
									<input type="text"  class="date inputDt" id="ENDDA<%=i+1 %>" name="ENDDA" value="<%=data.ENDDA%>" size="15" style="margin-right: 4px">
								<%}else{ %>
									<input type="text"  class="date inputDt" id="ENDDA<%=i+1 %>" name="ENDDA" value="" size="15" style="margin-right: 4px">
								<%} %>
							</td>
							<td>
								<select id="TPROG<%=i+1 %>" name="TPROG">
									<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
<%
									for( int j = 0; j < vt.size(); j++ ) {
										D40DailScheFrameData vtData = (D40DailScheFrameData)vt.get(j);
%>
											<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.TPROG)){ %> selected <%} %>><%=vtData.TEXT %></option>
<%
									}
%>
								</select>
							</td>
							<td class="lastCol" style="text-align : left"><%=data.MSG%></td>
						</tr>
<%
							} //end for
						}else{
							if("SAVE".equals(gubun) && "M".equals(E_RETURN) ){
%>
						<tr class="oddRow">
							<td class="lastCol" colspan="7"><spring:message code="MSG.D.D40.0012"/><!-- 전체 데이터가 성공적으로 처리되었습니다. --></td>
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
	            <li><a class="darken" href="javascript:do_save();"><span><!-- 저장 --><%=g.getMessage("BUTTON.COMMON.SAVE")%></span></a></li>
	        </ul>
	    </div>
	</div>
</form>
</body>

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

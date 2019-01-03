<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정												*/
/*   Program Name	:   계획근무일정 조회/변경(개별)							*/
/*   Program ID		: D40DailScheSearch.jsp								*/
/*   Description		: 계획근무일정 (개별) 조회/저장							*/
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
	String sMenuCode =  (String)request.getAttribute("sMenuCode");


	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름
	String E_DATUM    = (String)request.getAttribute("E_DATUM");	//날짜
	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜
	String gubun    = (String)request.getAttribute("gubun");	//선택날짜
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	String E_SAVE_CNT    = WebUtil.nvl((String)request.getAttribute("E_SAVE_CNT"));	//저장메세지
	if(!"".equals(I_DATUM) && I_DATUM != null){
		E_DATUM = I_DATUM;
	}

	Vector vt    = (Vector)request.getAttribute("OBJPS_OUT");	//계획근무
	Vector dataList = new Vector();
	if("SAVE".equals(gubun)){
		dataList    = (Vector)request.getAttribute("T_EXLIST");	//리스트데이터
	}else{
		dataList    = (Vector)request.getAttribute("OBJPS_OUT2");	//리스트데이터
	}

%>
<jsp:include page="/include/header.jsp" />

<script language="JavaScript">

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

	  //상단 공통 조회조건
		$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
		$("#searchDeptNm").val(parent.$("#searchDeptNm").val());
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
		$("#I_ACTTY").val("R");
		$("#gubun").val("EXCEL");
	    vObj.target = "ifHidden";
	    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzSearchSV";
	    vObj.method = "post";
	    vObj.submit();
	}

	function excelUpload(){
		small_window = window.open('${g.servlet}hris.D.D40TmGroup.D40TmSchkzFileUploadSV?',
				"ScheduleExcelUpload","width=440,height=300,left=365,top=70,scrollbars=no");
		small_window.focus();
	}

	function selectList(value){
	<%
		if( vt != null && vt.size() > 0 ){
	%>
			var selectList = '<select name="SCHKZ"><option value="">선택</option>';
			var code;
			var text;
	<%
			for( int i = 0; i < vt.size(); i++ ) {
				D40TmSchkzFrameData data = (D40TmSchkzFrameData)vt.get(i);
	%>
				code = '<%=data.CODE%>';
				text = code+' '+ '(<%=data.TEXT%>)';
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

	function afterUploadProcess(data, failSize, msg) {
		data = JSON.parse(data);
		$("#-excel-result-tbody").html("");
		var html = "";
		var index = 1;
		_.each(data.resultList, function(row) {
			var select = selectList(row.SCHKZ);
			html += '<tr>'+
			'<td>'+index+'</td>'+
			'<td>'+row.PERNR+'<input type="hidden" name="PERNR" value="'+row.PERNR+'"></td>'+
			'<td>'+row.ENAME+'<input type="hidden" name="ENAME" value="'+row.ENAME+'"></td>'+
			'<td><input type="text"  class="date" name="BEGDA" value="'+row.BEGDA+'" size="15" style="margin-right: 4px"></td>'+
			'<td><input type="text"  class="date" name="ENDDA" value="'+row.ENDDA+'" size="15" style="margin-right: 4px"></td>'+
			'<td>'+select+'</td>'+
			'<td class="lastCol" style="text-align : left">'+row.MSG+'</td>'+
		'</tr>';
			index++;
		});
		$("#-excel-result-tbody").append(html);

		$('.date').each(function(){
			addDatePicker($('.date'));
			$(this).mask("9999.99.99");
		});

		var height = document.body.scrollHeight;
		//alert(height);
		parent.autoResize(height);
	}

	//사원검색 Popup.
	function organ_search() {
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

	function dt_clear(){
		$("#I_PERNR").val("");
		$("#I_ENAME").val("");
	}

	function do_save(){
		parent.saveBlockFrame();
		$("#gubun").val("SAVE");
		document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzSearchSV";
		document.form1.method = "post";
		document.form1.target = "_self";
		document.form1.submit();
	}

	function do_search(){
		//상단 공통 조회조건
		parent.blockFrame();
		$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
		$("#searchDeptNm").val(parent.$("#searchDeptNm").val());
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
		$("#I_ACTTY").val("R");
		$("#gubun").val("SEARCH");
	    vObj.target = "_self";
	    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmSchkzSearchSV";
	    vObj.method = "post";
	    vObj.submit();

	}


	$(function() {
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

	<div class="tableInquiry">
		<table>
			<colgroup>
				<col width="18%" /><!-- 현근무일정 조회 기준일 -->
				<col width="15%" /><!-- input -->
				<col width="7%" /><!-- 계획근무 -->
				<col width="10%" /><!--select  -->
				<col width="13%" /><!--사원선택 button  -->
                <col /><!--search button  -->
            </colgroup>
            <tr>
                <th>
                    <spring:message code='LABEL.D.D40.0024'/><!-- 현근무일정 조회 기준일 -->
                </th>
                <td>
					<input type="text" id="I_DATUM" class="date" name="I_DATUM" value="<%= WebUtil.printDate(E_DATUM) %>" size="15" >
                </td>
                <th>
                    <spring:message code='LABEL.D.D40.0025'/><!-- 계획근무 -->
                </th>
                <td>
					<select name="I_SCHKZ" id="I_SCHKZ" style="width: 100%;">
						<option value=""><spring:message code='LABEL.COMMON.0024'/><!-- 전체 --></option>
<%
							for( int j = 0; j < vt.size(); j++ ) {
								D40TmSchkzFrameData vtData = (D40TmSchkzFrameData)vt.get(j);
%>
									<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(I_SCHKZ)){ %> selected <%} %>><%=vtData.CODE%> (<%=vtData.TEXT %>)</option>
<%
							}
%>
						</select>
				</td>
				<td>
					<div class="tableBtnSearch tableBtnSearch2">
                        <a href="javascript:organ_search();" class="search"><span><spring:message code='BUTTON.D.D40.0006'/><!-- 사원선택 --></span></a>
                    </div>
				</td>
				<td>
					<input type="hidden" id="I_PERNR" name="I_PERNR" value="<%=I_PERNR%>">
					<input type="text" id="I_ENAME" name="I_ENAME" readonly="readonly"  value="<%=I_ENAME%>">
					<a class="floatLeft" href="javascript:dt_clear();"><img src="/web/images/eloffice/images/ico/ico_inline_reset.png" alt="초기화"/></a>
<!--                     &nbsp; &nbsp; -->
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a href="javascript:do_search();" class="search"><span><spring:message code="BUTTON.COMMON.SEARCH"/><!-- 조회 --></span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>
	<div class="listArea">
		<div class="listTop">
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a href="javascript:excelDown();"><span><!-- 엑셀다운로드 --><spring:message code="BUTTON.D.D40.0002" /></span></a></li>
					<li><a class="darken" href="javascript:do_save();"><span><!-- 저장 --><spring:message code="BUTTON.COMMON.SAVE" /></span></a></li>
				</ul>
			</div>
			<div class="clear"> </div>
		</div>

		<div class="table">
			<div class="wideTable" >
				<table class="listTable" >
					<colgroup>
						<col width="2%" />
						<col width="8%" />
						<col width="8%" />

						<col width="8%" />
						<col width="8%" />
						<!-- <col width="8%" /> -->
						<col width="10%" />

						<col width="14%" />
						<col width="14%" />
						<col width="8%" />
<!-- 						<col width="10%" /> -->

						<col width="10%" />
						<col width="10%" />
					</colgroup>
					<thead>
					<tr>
						<th rowspan="2"><!-- 구분--><spring:message code='LABEL.F.F42.0055'/></th>
						<th rowspan="2"><!-- 사번--><spring:message code='LABEL.D.D05.0005'/></th>
						<th rowspan="2"><!-- 이름--><spring:message code='LABEL.D.D05.0006'/></th>
						<th colspan="3"><!-- 기준일--><spring:message code='LABEL.D.D40.0031'/></th>
						<th colspan="3"><!-- 변경--><spring:message code='LABEL.D.D40.0032'/></th>
						<th rowspan="2"><!-- 비고--><spring:message code='LABEL.D.D14.0017'/></th>
						<th rowspan="2" class="lastCol" " ><!-- 오류메세지--><spring:message code='LABEL.D.D40.0023'/></th>
					</tr>
					<tr>
						<th><!-- 시작일--><spring:message code='LABEL.D.D15.0152'/></th>
						<th><!-- 종료일--><spring:message code='LABEL.D.D15.0153'/></th>
						<th><!-- 근무일정명--><spring:message code='LABEL.D.D13.0016'/></th>
						<th><!-- 시작일--><spring:message code='LABEL.D.D15.0152'/></th>
						<th><!-- 종료일--><spring:message code='LABEL.D.D15.0153'/></th>
						<th><!-- 근무일정--><spring:message code='LABEL.D.D40.0033'/></th>
					</tr>
					</thead>
					<tbody id="-excel-result-tbody">

<%
					if( dataList != null && dataList.size() > 0 ){
						for( int i = 0; i < dataList.size(); i++ ) {
							D40TmSchkzFrameData data = (D40TmSchkzFrameData)dataList.get(i);
					        String tr_class = "";
					        if(i%2 == 0){
					            tr_class="oddRow";
					        }else{
					            tr_class="";
					        }
%>
						<tr class="<%=tr_class%>">
							<td><%=i+1 %></td>
							<td><%= data.PERNR%><input type="hidden" name="PERNR" value="<%= data.PERNR%>"></td>
							<td><%= data.ENAME%><input type="hidden" name="ENAME" value="<%= data.ENAME%>"></td>
							<td><%= data.BEGDA.replace("-",".")%><input type="hidden" name="BEGDA" value="<%= data.BEGDA.replace("-",".")%>"></td>
							<td><%= data.ENDDA.replace("-",".")%><input type="hidden" name="ENDDA" value="<%= data.ENDDA.replace("-",".")%>"></td>
							<%-- <td><%=data.SCHKZ%></td> --%>
							<td>
								<%=data.SCHKZ_TX%>
								<input type="hidden" name="SCHKZ" value="<%=data.SCHKZ%>">
								<input type="hidden" name="SCHKZ_TX" value="<%=data.SCHKZ_TX%>">
							</td>
							<td>
							<% if(!"0000-00-00".equals(data.NBEGDA)){ %>
								<input type="text"  class="date" name="NBEGDA" value="<%= data.NBEGDA.replace("-",".")%>" size="15" style="margin-right: 4px">
							<%}else{ %>
								<input type="text"  class="date" name="NBEGDA" value="" size="15" style="margin-right: 4px">
							<%} %>
							</td>
							<td>
							<% if(!"0000-00-00".equals(data.NENDDA)){ %>
								<input type="text"  class="date" name="NENDDA" value="<%= data.NENDDA.replace("-",".")%>" size="15" style="margin-right: 4px">
							<%}else{ %>
								<input type="text"  class="date" name="NENDDA" value="" size="15" style="margin-right: 4px">
							<%} %>
							</td>
							<td>
								<select name="NSCHKZ" style="width: 50px;" >
									<option value=""><spring:message code='LABEL.D.D03.0033'/><!-- 선택 --></option>
<%
							for( int j = 0; j < vt.size(); j++ ) {
								D40TmSchkzFrameData vtData = (D40TmSchkzFrameData)vt.get(j);
%>
									<option value="<%=vtData.CODE%>" <%if(vtData.CODE.equals(data.NSCHKZ)){ %> selected <%} %> ><%=vtData.CODE%> (<%=vtData.TEXT %>)</option>
<%
							}
%>
								</select>
							</td>
							<td><%=data.ETC%></td>
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
			}else{
%>
			<tr class="oddRow">
				<td class="lastCol" colspan="11"><spring:message code="MSG.COMMON.0004"/></td>
			</tr>
<%
			}
		}
%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</form>

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

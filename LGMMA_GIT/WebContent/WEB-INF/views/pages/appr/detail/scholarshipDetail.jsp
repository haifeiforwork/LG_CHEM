<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.A.rfc.A04FamilyDetailRFC"%>
<%@ page import="hris.E.E22Expense.rfc.E22ExpenseListRFC"%>
<%@ page import="hris.E.E22Expense.E22ExpenseListData"%>
<%@ page import="hris.E.E21Expense.E21ExpenseChkData"%>
<%@ page import="hris.A.A04FamilyDetailData"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
	String PERNR = request.getParameter("PERNR");
	Vector A04FamilyDetailData_vt = (new A04FamilyDetailRFC()).getFamilyDetail(PERNR);
	Vector E22ExpenseListData_vt = (new E22ExpenseListRFC()).getExpenseList(userData.empNo);
	Vector E21ExpenseChkData_vt = new Vector();
	
	//  현재년도 기준으로 일년전부터, 일년후까지 (3년간)
	int i_date = Integer.parseInt( DataUtil.getCurrentDate().substring(0,4) );
	
	Vector CodeEntity_vt = new Vector();
	for( int i = i_date - 1 ; i <= i_date + 1 ; i++ ){
		CodeEntity entity = new CodeEntity();
		entity.code  = Integer.toString(i);
		entity.value = Integer.toString(i);
		CodeEntity_vt.addElement(entity);
	}
	
%>
<div class="tableArea">	
	<h2 class="subtitle withButtons">장학금/학자금 신청 상세내역</h2>
	<div class="buttonArea">
	</div>
	<div class="clear"></div>
	<div class="table">
		<form id='detailForm'>
		<table class="tableGeneral">
		<caption>장학자금 신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="detailDay">신청일</label></th>
			<td class="tdDate">
				<input class="readOnly" type="text" id="detailDay" name="BEGDA" readonly />
			</td>
			<th><label for="a1">결재일</label></th>
            <td class="tdDate"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
		</tr>
		<tr>
			<th><label for="detailFamsa">가족선택</label></th>
			<td colspan="3">
				<input class="readOnly w40" type="text" id="detailFamsa" name="FAMSA" readonly />
				<input class="readOnly w100" type="text" id="detailAtext" name="ATEXT" readonly />
			</td>
		</tr>
		
		<tr>
			<th><label for="detailStext">지급유형</label></th>
			<td>
				<select class="readOnly" id="detailSubfType" name="SUBF_TYPE" disabled> 
					<option value="">---------선택---------</option>
					<option value="2">학자금(중/고등학교)</option>
					<option value="3">장학금(대학교)</option>
				</select>
			</td>
			<th><label for="detailPropYear">신청년도</label></th>
			<td>
				<select class="readOnly" id="detailPropYear" name="PROP_YEAR" disabled > 
					<option value="">------선택------</option>
					<%= WebUtil.printOption(CodeEntity_vt)%>
				</select>
			</td>
		</tr>
		<tr>
			<th><label for="detailPay1Type">지급구분</label></th>
			<td>
				<input class="checkbox" type="radio" id="detailPay1Type" name="PAY_TYPE" value="1" disabled /> 신규분
				<input class="checkbox" type="radio" id="detailPay2Type" name="PAY_TYPE" value="2" disabled /> 추가분
			</td>
			<th><label class="type2" for="detailType">신청분기ㆍ학기</label></th>
			<td>
				<select class="readOnly" id="detailSelType" name="selType" vname="신청분기ㆍ학기" disabled>
					<option value="">------선택------</option>
				</select>
			</td>
		</tr>
		<tr>
			<th><label for="detailFullName">이름</label></th>
			<td colspan="3">
				<select class="readOnly" id="detailFullName" name="full_name" vname="이름" disabled>
					<option value="">------선택------</option>
<%
	for ( int i = 0 ; i < A04FamilyDetailData_vt.size() ; i++ ) {
		A04FamilyDetailData data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
		if( data.SUBTY.equals("2") ) {
%>
					<option value ="<%=data.LNMHG.trim()%><%=data.FNMHG.trim()%>" 
							SUBTY="<%=data.SUBTY%>" 
							OBJC_CODE="<%=data.OBJPS%>" 
							LNMHG="<%=data.LNMHG%>" 
							FNMHG="<%=data.FNMHG%>" 
							ACAD_CARE="<%=data.FASAR%>" 
							STEXT="<%=data.STEXT1%>" 
							FASIN="<%=data.FASIN%>" >
							<%=data.LNMHG.trim()%> <%=data.FNMHG.trim()%></option>
<%
		}
	}
%>
				</select>
			</td>
		</tr>
		<tr>
			<th><label for="detailAcadCare">학력</label></th>
			<td colspan="3">
				<input class="readOnly w40" type="text" id="detailAcadCare" name="ACAD_CARE" readonly />
				<input class="readOnly w100" type="text" id="detailStext" name="STEXT" readonly />
			</td>
		</tr>
		
		<tr>
			<th><label for="detailFasin">교육기관</label></th>
			<td>
				<input class="readOnly w250" type="text" id="detailFasin" name="FASIN" readonly />
			</td>
			<th><label for="detailAcadYear">학년</label></th>
			<td>
				<input class="readOnly w150" type="text" id="detailAcadYear" name="ACAD_YEAR" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="detailPropAmnt">신청액</label></th>
			<td>
				<input class="inputMoney readOnly w150" type="text" id="detailPropAmnt" name="PROP_AMNT" readonly />
				<select class="readOnly" id="detailWaers" name="WAERS" disabled>
					<option value="KRW">KRW</option>
				</select>
				<a class="inlineBtn" href="#" id="detailBillBtn"><span>등록금 고지서 내역</span></a>
			</td>
			<th><label for="detailPCount">수혜횟수</label></th>
			<td>
				<input class="inputMoney readOnly w150" type="text" id="detailPCount" name="P_COUNT" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="detailEntrFiag">입학금</label></th>
			<td colspan="3"><input class="checkbox" type="checkbox" id="detailEntrFiag" name="ENTR_FIAG" value="X" disabled></td>
		</tr>
		</tbody>
		</table>
		
		<input type="hidden" id="detailSubty" name="SUBTY" /> <!-- 가족유형 -->
		<input type="hidden" id="detailObjcCode" name="OBJC_CODE" /> <!-- 하부유형 -->
		<input type="hidden" id="detailLnmhg" name="LNMHG" />
		<input type="hidden" id="detailFnmhg" name="FNMHG" />
		<input type="hidden" id="pay1Type" name="PAY1_TYPE" />
		<input type="hidden" id="pay2Type" name="PAY2_TYPE" />
		<input type="hidden" id="detailPerdType" name="PERD_TYPE" /> <!-- 분기 -->
		<input type="hidden" id="detailHalfType" name="HALF_TYPE" /> <!-- 반기 -->
		<input type="hidden" id="detailRegiFee" name="REGI_FEE" />
		<input type="hidden" id="detailSchoFee" name="SCHO_FEE" />
		<input type="hidden" id="detailMrmbFee" name="MRMB_FEE" />
		<input type="hidden" id="detailEntrFee" name="ENTR_FEE" />
		<input type="hidden" id="detailMembFee" name="MEMB_FEE" />
		</form>
	</div>
</div>

<!-- popup : 등록금 고지서 입력 start -->
<div class="layerWrapper layerSizeS" id="popLayerBill" style="display:inherit !important">
	<form id="popupBillForm">
	<div class="layerHeader">
		<strong>등록금 고지서 내역</strong>
		<a href="#" class="btnClose popLayerBill_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="tableArea tablePopup">
				<div class="table">
					<table class="tableGeneral">
					<caption>등록금 고지서 입력</caption>
					<colgroup>
						<col class="col_40p" />
						<col class="col_60p" />
					</colgroup>
					<tbody>
						<tr>
							<th><label for="popupRegiFee">등록금(수업료)</label></th>
							<td>
								<input class="inputMoney wPer readOnly" type="text" id="popupRegiFee" name="REGI_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" readonly>
							</td>
						</tr>
						<tr>
							<th><label for="popupSchoFee">장학금</label></th>
							<td>
								<input class="inputMoney wPer readOnly" type="text" id="popupSchoFee" name="SCHO_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" readonly>
							</td>
						</tr>
						<tr>
							<th><label for="popupMrmbFee">학생회비</label></th>
							<td>
								<input class="inputMoney wPer readOnly" type="text" id="popupMrmbFee" name="MRMB_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" readonly>
							</td>
						</tr>
						<tr>
							<th><label for="popupMembFee">기성회비</label></th>
							<td>
								<input class="inputMoney wPer readOnly" type="text" id="popupMembFee" name="MEMB_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" readonly>
							</td>
						</tr>
						<tr>
							<th><label for="popupEntrFee">입학금</label></th>
							<td>
								<input class="inputMoney wPer readOnly" type="text" id="popupEntrFee" name="ENTR_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" readonly>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="popupTotalFee">합계</label></th>
							<td>
								<input class="inputMoney wPer readOnly" type="text" id="popupTotalFee" name="TOTAL_FEE" onkeyup="cmaComma(this);" onchange="cmaComma(this);"  readonly>
							</td>
						</tr>
					</tbody>
					</table>
				</div>
			</div>
			<div class="buttonArea buttonCenter">
				<ul class="btn_crud">
					<li><a href="#" id="popupCanselBtn" class="popLayerBill_close"><span>닫기</span></a></li>
				</ul>
			</div>
			<!--// Content end  -->
		</div>
	</div>
	</form>
</div>
<!-- //팝업 : 등록금 고지서 입력 end -->
<script type="text/javascript">
	var detailSearch = function() {
		var param = new Array();
		param.push({name:"AINF_SEQN", value:"<c:out value="${AINF_SEQN}"/>"});
		param.push({name:"PERNR", value:"<c:out value="${PERNR}"/>"});
		$.ajax({
			type : "get",
			url : "/appl/getScholarshipDetail.json",
			dataType : "json",
			//data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
			data : param
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
			}
			else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
		
		var setDetail = function(item){
			setTableText(item, "detailForm");
			
			if(item.PAY1_TYPE == 'X'){
				$("#detailPay1Type").prop("checked",true)
			}else{
				$("#detailPay1Type").prop("checked",false)
			};
			
			if(item.PAY2_TYPE == 'X'){
				$("#detailPay2Type").prop("checked",true)
			}else{
				$("#detailPay2Type").prop("checked",false)
			};
			
			$("#detailSelType").empty();//selType
			$("#detailSelType").append($("<option value=''>").text("------선택------"));
			
			if( $("#detailSubfType option:selected").val() == "2" ) { //신청유형
				for( var i = 1 ; i <= 4 ; i++ ) {
					$("#detailSelType").append($("<option>").text(i+"분기").val(i));
				}
				
			}else if( $("#detailSubfType option:selected").val() == "3" ) { //장학금
				for( var i = 1 ; i <= 4 ; i++ ) {
					$("#detailSelType").append($("<option>").text(i+"학기").val(i));
				}
			}
			$("#detailFullName").val(item.LNMHG + item.FNMHG);
			$("#detailSubty").val($("#detailFullName option:selected").attr("SUBTY"));
			
			if(item.SUBF_TYPE == "2"){
				$("#detailSelType").val(item.PERD_TYPE);
			}else if(item.SUBF_TYPE == "3"){
				$("#detailSelType").val(item.HALF_TYPE);
			}
			
			$("#detailPropAmnt").val(insertComma(banolim(item.PROP_AMNT,0).toString()));
			$("#detailPaidAmnt").val(insertComma(parseInt(item.PAID_AMNT).toString()));
			$("#detailPCount").val(insertComma(parseInt(item.P_COUNT).toString()));
			if(item.ENTR_FIAG == "X") { $("#detailEntrFiag").prop("checked", true); }else{ $("#detailEntrFiag").prop("checked", false); }
			
			$("#detailRegiFee").val(item.REGI_FEE == "" ? "0" : banolim(item.REGI_FEE,0) );
			$("#detailSchoFee").val(item.SCHO_FEE == "" ? "0" : banolim(item.SCHO_FEE,0) );
			$("#detailMrmbFee").val(item.MRMB_FEE == "" ? "0" : banolim(item.MRMB_FEE,0) );
			$("#detailEntrFee").val(item.ENTR_FEE == "" ? "0" : banolim(item.ENTR_FEE,0) );
			$("#detailMembFee").val(item.MEMB_FEE == "" ? "0" : banolim(item.MEMB_FEE,0) );
		}
	};
	
	$("#detailBillBtn").click(function(){
		$("#popupRegiFee").val( removeComma($("#detailRegiFee").val()) == "" ? "0" : insertComma(banolim($("#detailRegiFee").val(),0).toString()) );
		$("#popupSchoFee").val( removeComma($("#detailSchoFee").val()) == "" ? "0" : insertComma(banolim($("#detailSchoFee").val(),0).toString()) );
		$("#popupMrmbFee").val( removeComma($("#detailMrmbFee").val()) == "" ? "0" : insertComma(banolim($("#detailMrmbFee").val(),0).toString()) );
		$("#popupEntrFee").val( removeComma($("#detailEntrFee").val()) == "" ? "0" : insertComma(banolim($("#detailEntrFee").val(),0).toString()) );
		$("#popupMembFee").val( removeComma($("#detailMembFee").val()) == "" ? "0" : insertComma(banolim($("#detailMembFee").val(),0).toString()) );
		$("#popupTotalFee").val( removeComma($("#detailPropAmnt").val()) == "" ? "0" : insertComma($("#detailPropAmnt").val().toString()) );
		
		$("#popLayerBill").popup("show");
	});
	$(document).ready(function(){
		if($(".layerWrapper").length){
			$("#popLayerBill").popup();
		};
		detailSearch();
	});
	
</script>
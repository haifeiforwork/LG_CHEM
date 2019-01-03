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
	Vector A04FamilyDetailData_vt = (new A04FamilyDetailRFC()).getFamilyDetail(userData.empNo);
	Vector E22ExpenseListData_vt = (new E22ExpenseListRFC()).getExpenseList(userData.empNo);
	Vector E21ExpenseChkData_vt = new Vector();
	
	
	for( int i = 0 ; i < A04FamilyDetailData_vt.size(); i++ ) {
		A04FamilyDetailData ja_data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
		String subty = ja_data.SUBTY;
		String objps = ja_data.OBJPS;
		
		String gubn = "";
		String hak = "";
		
		if( ja_data.FASAR.equals("D1") ){ //중고생
			gubn = "2";
			hak = "중";
		} else if( ja_data.FASAR.equals("E1") ) {
			gubn = "2";
			hak = "고";
		} else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1")
				|| ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1")) { //대학생
			gubn = "3";
			hak = "대";
		}
		
		//  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게
		if( userData.e_oversea.equals("X") ) {
			if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ){ //유치원, 초등학생
				gubn = "2";
				hak = "중";       // 임시적처리
			}
		}
		//  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게
		
		String count = "";
		String enter = "";
		
		for( int j = 0; j < E22ExpenseListData_vt.size(); j++ ) {
			E22ExpenseListData data = (E22ExpenseListData)E22ExpenseListData_vt.get(j);
			
			if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) { //유치원, 초등학생
				
				if(	subty.equals(data.FAMSA) && 
					objps.equals(data.OBJC_CODE) && 
					gubn.equals(data.SUBF_TYPE) && 
					(data.ACAD_CARE.equals("B1") || data.ACAD_CARE.equals("C1")) ) {
					
					if( !data.ENTR_FIAG.equals("X") ) {  //입학금이 아닌 경우
						count = data.P_COUNT;
						break;
					}
				}
			} else if( ja_data.FASAR.equals("D1") || ja_data.FASAR.equals("E1") ) { //중학생, 고등학생
				
				if(	subty.equals(data.FAMSA) && 
					objps.equals(data.OBJC_CODE) && 
					gubn.equals(data.SUBF_TYPE) && 
					(data.ACAD_CARE.equals("D1") || data.ACAD_CARE.equals("E1")) ) {
					
					if( !data.ENTR_FIAG.equals("X") ) {  //입학금이 아닌 경우
						count = data.P_COUNT;
						break;
					}
				}
			} else if(	ja_data.FASAR.equals("F1") || 
						ja_data.FASAR.equals("G1") || 
						ja_data.FASAR.equals("G2") || 
						ja_data.FASAR.equals("H1") ) { //대학생
				
				if(	subty.equals(data.FAMSA) && 
					objps.equals(data.OBJC_CODE) && 
					gubn.equals(data.SUBF_TYPE) && 
					(data.ACAD_CARE.equals("F1") || data.ACAD_CARE.equals("G1") || data.ACAD_CARE.equals("G2") || data.ACAD_CARE.equals("H1")) ) {
					
					if( !data.ENTR_FIAG.equals("X") ) { //입학금이 아닌 경우
						count = data.P_COUNT;
						break;
					}
				}
			}
		}
		
		for( int j = 0; j < E22ExpenseListData_vt.size(); j++ ) {
			E22ExpenseListData data = (E22ExpenseListData)E22ExpenseListData_vt.get(j);
			
			if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) { //유치원, 초등학생
				
				if(	subty.equals(data.FAMSA) && 
					objps.equals(data.OBJC_CODE) && 
					gubn.equals(data.SUBF_TYPE) && 
					(data.ACAD_CARE.equals("B1") || data.ACAD_CARE.equals("C1")) ) {
					
					if( data.ENTR_FIAG.equals("X") ) {  //입학금인 경우
						enter = data.P_COUNT;
						break;
					}
				}
			} else if( ja_data.FASAR.equals("D1") || ja_data.FASAR.equals("E1") ) { //중학생, 고등학생
				
				if(	subty.equals(data.FAMSA) && 
					objps.equals(data.OBJC_CODE) && 
					gubn.equals(data.SUBF_TYPE) && 
					(data.ACAD_CARE.equals("D1") || data.ACAD_CARE.equals("E1")) ) {
					
					if( data.ENTR_FIAG.equals("X") ) {  //입학금인 경우
						enter = data.P_COUNT;
						break;
					}
				}
			} else if(	ja_data.FASAR.equals("F1") || 
						ja_data.FASAR.equals("G1") || 
						ja_data.FASAR.equals("G2") || 
						ja_data.FASAR.equals("H1") ) { //대학생
				
				if(	subty.equals(data.FAMSA) && 
					objps.equals(data.OBJC_CODE) && 
					gubn.equals(data.SUBF_TYPE) && 
					(data.ACAD_CARE.equals("F1") || data.ACAD_CARE.equals("G1") || data.ACAD_CARE.equals("G2") || data.ACAD_CARE.equals("H1")) ) {
					
					if( data.ENTR_FIAG.equals("X") ) {  //입학금인 경우
						enter = data.P_COUNT;
						break;
					}
				}
			}
		}
		E21ExpenseChkData ret_data = new E21ExpenseChkData();
		ret_data.subty = subty;
		ret_data.objps = objps;
		ret_data.grade = hak;
		ret_data.subf_type = gubn;
		ret_data.count = count;
		ret_data.enter = enter;
		E21ExpenseChkData_vt.addElement(ret_data);
	}
	
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
	<h2 class="subtitle withButtons">장학금/학자금 상세내역</h2>
	<div class="buttonArea">
		<ul class="btn_mdl">
			<li><a class="inlineBtn" href="#" id="detailPrintBtn"><span>장학금/학자금 신청서 프린트</span></a></li>
		</ul>
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
			<td colspan="3" class="tdDate">
				<input class="readOnly" type="text" id="detailDay" name="BEGDA" readonly />
			</td>
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
				<a class="inlineBtn" href="#" id="detailBillBtn"><span>등록금 고지서 입력</span></a>
			</td>
			<th><label for="detailPCount">수혜횟수</label></th>
			<td>
				<input class="inputMoney readOnly w150" type="text" id="detailPCount" name="P_COUNT" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="detailEntrFiag">입학금</label></th>
			<td colspan="3"><input class="checkbox" type="radio" id="detailEntrFiag" name="ENTR_FIAG" value="X" disabled></td>
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
		<strong>등록금 고지서 입력</strong>
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
				<div class="tableComment">
					<p><span class="bold">장학금을 수령한 경우 등록금(수업료)은 장학금을 제외한 금액을 입력하여 주시기 바랍니다.</span></p>
				</div>
			</div>
			<div class="buttonArea buttonCenter">
				<ul class="btn_crud">
					<li><a href="#" id="popupInsertFeeBtn" class="darken"><span>확인</span></a></li>
					<li><a href="#" id="popupCanselBtn" ><span>취소</span></a></li>
				</ul>
			</div>
			<!--// Content end  -->
		</div>
	</div>
	</form>
</div>
<!-- //팝업 : 등록금 고지서 입력 end -->


<!-- 프린트 영역 팝업-->
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>장학금/학자금 신청서</strong>
		<a href="#" class="btnClose popLayerPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer">
			<div id="printBody">
				<iframe name="billWritePopup" id="billWritePopup" src="" frameborder="0" scrolling="no" style="float:left; height:1000px; width:700px;"></iframe>
			</div>
		</div>
	</div>
	<div class="buttonArea buttonPrint">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="printPopBillWriteBtn"><span>프린트</span></a></li>
		</ul>
	</div>
	<div class="clear"></div>
</div>



<script type="text/javascript">
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getScholarshipDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
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
			
			$("#popupRegiFee").val( item.REGI_FEE == "" ? "0" : insertComma(banolim(item.REGI_FEE,0).toString()) );
			$("#popupSchoFee").val( item.SCHO_FEE == "" ? "0" : insertComma(banolim(item.SCHO_FEE,0).toString()) );
			$("#popupMrmbFee").val( item.MRMB_FEE == "" ? "0" : insertComma(banolim(item.MRMB_FEE,0).toString()) );
			$("#popupEntrFee").val( item.ENTR_FEE == "" ? "0" : insertComma(banolim(item.ENTR_FEE,0).toString()) );
			$("#popupMembFee").val( item.MEMB_FEE == "" ? "0" : insertComma(banolim(item.MEMB_FEE,0).toString()) );
			$("#popupTotalFee").val( item.PROP_AMNT == "" ? "0" : insertComma(banolim(item.PROP_AMNT,0).toString()) );
			
			$("#detailRegiFee").val(item.REGI_FEE == "" ? "0" : banolim(item.REGI_FEE,0) );
			$("#detailSchoFee").val(item.SCHO_FEE == "" ? "0" : banolim(item.SCHO_FEE,0) );
			$("#detailMrmbFee").val(item.MRMB_FEE == "" ? "0" : banolim(item.MRMB_FEE,0) );
			$("#detailEntrFee").val(item.ENTR_FEE == "" ? "0" : banolim(item.ENTR_FEE,0) );
			$("#detailMembFee").val(item.MEMB_FEE == "" ? "0" : banolim(item.MEMB_FEE,0) );
		}
	};
	
	$(document).ready(function(){
		if($(".layerWrapper").length){
			$("#popLayerBill").popup();
		};
		
		$("#popupInsertFeeBtn").hide();
		$("#popupCanselBtn").hide();
		
		detailSearch();
	});
	
	//
	$("#detailBillBtn").click(function(){
		$("#popupRegiFee").val( removeComma($("#detailRegiFee").val()) == "" ? "0" : insertComma(banolim($("#detailRegiFee").val(),0).toString()) );
		$("#popupSchoFee").val( removeComma($("#detailSchoFee").val()) == "" ? "0" : insertComma(banolim($("#detailSchoFee").val(),0).toString()) );
		$("#popupMrmbFee").val( removeComma($("#detailMrmbFee").val()) == "" ? "0" : insertComma(banolim($("#detailMrmbFee").val(),0).toString()) );
		$("#popupEntrFee").val( removeComma($("#detailEntrFee").val()) == "" ? "0" : insertComma(banolim($("#detailEntrFee").val(),0).toString()) );
		$("#popupMembFee").val( removeComma($("#detailMembFee").val()) == "" ? "0" : insertComma(banolim($("#detailMembFee").val(),0).toString()) );
		$("#popupTotalFee").val( removeComma($("#detailPropAmnt").val()) == "" ? "0" : insertComma($("#detailPropAmnt").val().toString()) );
		
		$("#popLayerBill").popup("show");
	});
	
	// 등록금 고지서 내역 입력
	$("#popupInsertFeeBtn").click(function(){
		popupTotalSumCalc();
		$("#detailRegiFee").val( removeComma($("#popupRegiFee").val()) == "" ? "0" : removeComma($("#popupRegiFee").val() ) );
		$("#detailSchoFee").val( removeComma($("#popupSchoFee").val()) == "" ? "0" : removeComma($("#popupSchoFee").val() ) );
		$("#detailMrmbFee").val( removeComma($("#popupMrmbFee").val()) == "" ? "0" : removeComma($("#popupMrmbFee").val() ) );
		$("#detailEntrFee").val( removeComma($("#popupEntrFee").val()) == "" ? "0" : removeComma($("#popupEntrFee").val() ) );
		$("#detailMembFee").val( removeComma($("#popupMembFee").val()) == "" ? "0" : removeComma($("#popupMembFee").val() ) );
		$("#detailPropAmnt").val( removeComma($("#popupTotalFee").val()) == "" ? "0" : removeComma($("#popupTotalFee").val() ) );
		
		$("#detailPropAmnt").val( removeComma($("#popupTotalFee").val()) == "" ? "0" : insertComma($("#popupTotalFee").val().toString()) );
		$("#popupBillForm").each(function() {
			this.reset();
		});
		$("#popLayerBill").popup("hide");
	});
	
	//
	$("#popupCanselBtn").click(function(){
		$("#popLayerBill").popup("hide");
	});
	
	// 장학자금 대상 이름 변경
	$("#detailFullName").change(function(){
		$("#detailSubty").val($("#detailFullName option:selected").attr("SUBTY"));
		$("#detailObjcCode").val($("#detailFullName option:selected").attr("OBJC_CODE"));
		$("#detailLnmhg").val($("#detailFullName option:selected").attr("LNMHG"));
		$("#detailFnmhg").val($("#detailFullName option:selected").attr("FNMHG"));
		$("#detailAcadCare").val($("#detailFullName option:selected").attr("ACAD_CARE"));
		$("#detailStext").val($("#detailFullName option:selected").attr("STEXT"));
		$("#detailFasin").val($("#detailFullName option:selected").attr("FASIN"));
		
		if(detailChkLogic()){
			detailSetCnt();
		}
	});
	
	
	var detailChkLogic = function(){
		var subfType = $("#detailfType option:selected").val();
		var type1    = $("#detailFullName option:selected").attr("ACAD_CARE");
		
<% if (userData.e_oversea.equals("X") ) { %> 
		if(subfType=="2" && type1!="" && type1!="B1" && type1!="C1" && type1!="D1" && type1!="E1" ){
			alert("학자금신청은 유치원, 초.중.고등학생만 가능합니다.\n\n 가족사항을 확인하세요.");
			return false;
		}
<%
	} else {
%>
		if(subfType=="2" && type1!="" && type1!="D1" && type1!="E1" ){
			alert("학자금신청은 중.고등학생만 가능합니다.\n\n 가족사항을 확인하세요.");
			return false;
		}
<%
	}
%>
		if(subfType=="3" && type1!="" && type1!="F1" && type1!="G1" && type1!="G2"){
			alert("장학금신청은 대학생만 가능합니다.\n\n 가족사항을 확인하세요.");
			return false;
		}
		return true;
	}
	
	
	var detailSetCnt = function(){
		$("#detailPCount").val("");
		
		var subfType = $("#detailSubfType option:selected").val();
		var type1    = $("#detailFullName option:selected").attr("ACAD_CARE");
		
		if(type1=="" || subfType==""){
			$("#detailPCount").val("");
			return;
		}
		
		simp_type = null;
		if( type1 == "D1"){
			simp_type = "중";
		} else if( type1 == "E1" ){
			simp_type = "고";
		} else if( type1 == "F1" || type1 == "G1" || type1 == "G2" || type1 == "H1" ){
			simp_type = "대";
		} else{
			simp_type = "";
		}
		// 2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
		<%
			if( userData.e_oversea.equals("X") ) { // 해외근무자
		%>
				if( type1 == "B1" || type1 == "C1" ){
					simp_type = "중";
				}
<%
	}
	for(int i = 0 ; i < E21ExpenseChkData_vt.size() ; i++){
		E21ExpenseChkData dataE21 = (E21ExpenseChkData)E21ExpenseChkData_vt.get(i);
%>
		if( ("<%=dataE21.subty%>" == $("#detailFullName option:selected").attr("SUBTY") )
			&& ("<%=dataE21.objps%>" == $("#detailFullName option:selected").attr("OBJC_CODE") ) ){
			
			if(subfType=="2"){ // 학자금일때
				if( "<%=dataE21.grade%>" == "중" || "<%=dataE21.grade%>" == "고") {
					$("#detailPCount").val($("#detailPCount").val() + parseInt("<%=dataE21.count == "" ? 0 : dataE21.count%>"));
					return;
				}
			}else if(subfType=="3" && simp_type=="대"){ // 장학금일때
				if( "<%=dataE21.grade%>" == simp_type ) {
					$("#detailPCount").val(parseInt("<%=dataE21.count == "" ? 0 : dataE21.count%>"));
					return;
				}
			}else{
				$("#detailPCount").val("");
				return;
			}
		}
<%
	}
%>
		$("#detailPCount").val("");
		return;
	}
	
	// 장학자금 대상 신청 유형 변경
	$("#detailSubfType").change(function(){
		//change_type
		if(detailChkLogic()){
			detailSetCnt();
		}
		
		// 2002.10.18. 분기일경우 보여줌.
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
	});
	
	// 등록금 합산
	var popupTotalSum = function(obj){
		if(checkNum(removeComma($(obj).val())) ){
			popupTotalSumCalc();
		}
	}
	
	var popupTotalSumCalc = function(){
		var feeSum = Number(removeComma($("#popupRegiFee").val()))
				     + Number(removeComma($("#popupSchoFee").val()))
					 + Number(removeComma($("#popupMrmbFee").val()))
					 + Number(removeComma($("#popupMembFee").val()))
					 + Number(removeComma($("#popupEntrFee").val()));
		$("#popupTotalFee").val(insertComma(feeSum));
	}
	
	// 수정 버튼 클릭
	var reqModifyActionCallBack = function(){
		$("#detailSubfType").removeClass("readOnly").prop("disabled",false);
		$("#detailPropYear").removeClass("readOnly").prop("disabled",false);
		$("#detailPay1Type").prop("disabled",false);
		$("#detailPay2Type").prop("disabled",false);
		$("#detailSelType").removeClass("readOnly").prop("disabled",false);
		$("#detailFullName").removeClass("readOnly").prop("disabled",false);
		$("#detailAcadYear").removeClass("readOnly").prop("readOnly",false);
		$("#detailWaers").removeClass("readOnly").prop("disabled",false);
		$("#detailEntrFiag").prop("disabled",false);
		
		$("#popupRegiFee").removeClass("readOnly").prop("readOnly",false);
		$("#popupSchoFee").removeClass("readOnly").prop("readOnly",false);
		$("#popupMrmbFee").removeClass("readOnly").prop("readOnly",false);
		$("#popupMembFee").removeClass("readOnly").prop("readOnly",false);
		$("#popupEntrFee").removeClass("readOnly").prop("readOnly",false);
		$("#popupInsertFeeBtn").show();
		$("#popupCanselBtn").show();
	};
	
	// 삭제 버튼 클릭
	var reqDeleteActionCallBack = function(){
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			var param = $("#detailForm").serializeArray();
			param.push({name:"AINF_SEQN", value:'${AINF_SEQN}'});
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteScholarship',
				cache : false,
				dataType : 'json',
				data : param,
				async : false,
				success : function(response) {
					if(response.success) {
						alert("삭제되었습니다.");
						$('#applDetailArea').html('');
						$("#reqApplGrid").jsGrid("search");
					} else {
						alert("삭제시 오류가 발생하였습니다. " + response.message);
					}
					$("#reqDeleteBtn").prop("disabled", false);
				}
			});
		}
	};
	
	// 취소(수정 취소) 버튼 클릭
	var reqCancelActionCallBack = function(){
		$("#detailForm").each(function(){
			this.reset();
		});
		
		$("#detailSubfType").addClass("readOnly").prop("disabled",true);
		$("#detailPropYear").addClass("readOnly").prop("disabled",true);
		$("#detailPay1Type").prop("disabled",true);
		$("#detailPay2Type").prop("disabled",true);
		$("#detailSelType").addClass("readOnly").prop("disabled",true);
		$("#detailFullName").addClass("readOnly").prop("disabled",true);
		$("#detailAcadYear").addClass("readOnly").prop("readOnly",true);
		$("#detailWaers").addClass("readOnly").prop("disabled",true);
		$("#detailEntrFiag").prop("disabled",true);
		
		$("#popupRegiFee").addClass("readOnly").prop("readOnly",true);
		$("#popupSchoFee").addClass("readOnly").prop("readOnly",true);
		$("#popupMrmbFee").addClass("readOnly").prop("readOnly",true);
		$("#popupMembFee").addClass("readOnly").prop("readOnly",true);
		$("#popupEntrFee").addClass("readOnly").prop("readOnly",true);
		
		$("#popupInsertFeeBtn").hide();
		$("#popupCanselBtn").hide();

		detailSearch();
		
	};
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(scholarshipCheck()){
			if(confirm("저장 하시겠습니까?")) {
				$("#detailPropAmnt").val(removeComma($("#detailPropAmnt").val()));
				$("#detailPaidAmnt").val(removeComma($("#detailPaidAmnt").val()));
				$("#detailPCount").val(removeComma($("#detailPCount").val()));
				
				$("#reqSaveBtn").prop("disabled", true);
				var param = $("#detailForm").serializeArray();
				param.push({name:"AINF_SEQN", value:'${AINF_SEQN}'});
				$("#detailDecisioner").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateScholarship',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
					success : function(response) {
						if(response.success) {
							alert("저장되었습니다.");
							$('#applDetailArea').html('');
							$("#reqApplGrid").jsGrid("search");
							return true;
						} else {
							alert("저장시 오류가 발생하였습니다. " + response.message);
							return false;
						}
						$("#reqSaveBtn").prop("disabled", false);
					}
				});
			}
		}else{
			return false;
		}
	};
	
	var scholarshipCheck = function(){
		if(!checkNullField("detailForm")){
			return false;
		}
		
		if( $("#detailPay1Type").is(":checked") ) {
			//기입력된 년도-분기ㆍ학기가 있는지 체크하고 있으면 신청을 막는다
<%
		for( int i = 0 ; i < E22ExpenseListData_vt.size() ; i++ ) {
		E22ExpenseListData e22_data = (E22ExpenseListData)E22ExpenseListData_vt.get(i);
%>
			if( ("<%= e22_data.SUBF_TYPE %>" == $("#detailSubfType option:selected").val() ) &&
				("<%= e22_data.FAMSA     %>" == $("#detailFullName option:selected").attr("SUBTY") ) &&
				("<%= e22_data.OBJC_CODE %>" == $("#detailFullName option:selected").attr("OBJC_CODE") ) &&
				("<%= e22_data.PROP_YEAR %>" == $("#detailPropYear").val() ) ) {
				
				if($("#detailSubfType option:selected").val() == "2"){
					$("#detailPerdType").val($("#detailSelType option:selected").val());
					if( "<%= e22_data.PERD_TYPE %>" == $("#detailSelType option:selected").val() ){
						alert("현재 분기에 이미 지급 받았습니다");
						return false;
					}
				}else if($("#detailSubfType option:selected").val() == "3"){
					$("#detailHalfType").val($("#detailSelType option:selected").val());
					if( "<%= e22_data.HALF_TYPE %>" == $("#detailSelType option:selected").val() ){
						alert("현재 학기에 이미 지급 받았습니다");
						return false;
					}
				}
			}
<%
		}
%>
			$("#pay1Type").val("X");
			$("#pay2Type").val("");
		}else if( $("#detailPay2Type").is(":checked") ){
			$("#pay1Type").val("");
			$("#pay2Type").val("X");
		}else{
			alert("지급구분을 선택하세요");
			return false;
		}
		if($("#detailSubfType option:selected").val() == "2"){
			$("#detailPerdType").val($("#detailSelType option:selected").val());
		}else if($("#detailSubfType option:selected").val() == "3"){
			$("#detailHalfType").val($("#detailSelType option:selected").val());
		}
		
		// 학자금 수혜한도(중학=>12, 고교=>12) 장학금 수혜한도(8회), 입학금수혜한도(1회)
		type1 = $("#detailFullName option:selected").attr("ACAD_CARE");
		
		//  R3 에 학력에 관한 데이타가 없음을 경고...
		if( type1 == "" ){
			alert("시스템에 해당자녀에 대한 학력정보가 없습니다. \n\n 먼저 R/3 Data를 확인해 주세요");
			return false;
		}
		
		simp_type = null;
		if( type1 == "D1" ) {
			simp_type = "중";
		} else if( type1 == "E1" ) {
			simp_type = "고";
		} else if( type1 == "F1" || type1 == "G1" || type1 == "G2" || type1 == "H1" ) {
			simp_type = "대";
		} else {
			simp_type = "";
		}
		
		//  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
<%
	if( userData.e_oversea.equals("X") ) {         // 해외근무자
%>
		if( type1 == "B1" || type1 == "C1" ){
			simp_type = "중";
		}
<%
	}
%>
		count = "";
		enter = "";
		
<%
	for(int i = 0 ; i < E21ExpenseChkData_vt.size() ; i++){
		E21ExpenseChkData dataE21 = (E21ExpenseChkData)E21ExpenseChkData_vt.get(i);
%>
		if( ("<%=dataE21.subty%>" == $("#detailFullName option:selected").attr("SUBTY") ) && 
			("<%=dataE21.objps%>" == $("#detailFullName option:selected").attr("OBJC_CODE") ) && 
			("<%=dataE21.grade%>" == simp_type ) ){
			count = "<%=dataE21.count%>";
			enter = "<%=dataE21.enter%>";
		}
<%
	}
%>
		
		if( $("#detailPay1Type").is(":checked") ){  //신규분
			if( parseInt(enter) >= 1 && $("#detailEntrFiag").is(":checked") ){
				alert("입학금은 1회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
				return false;      
			}else if( ( simp_type == "중" || simp_type == "고" ) && parseInt(count) >= 24 ){
				alert("학자금은 24회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
				return false;
			}else if( simp_type == "대" && parseInt(count) >= 8 ){
				alert("대학 장학금은 8회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
				return false;
			}
		}
		
		
		return true;
	}
	

	$("#detailPrintBtn").click(function(){
		$("#billWritePopup").attr("src","/appl/print/scholarshipPrint/?AINF_SEQN=${AINF_SEQN}");
		$("#billWritePopup").load(function(){
			$('#popLayerPrint').popup("show");
		});
	});
	
	$("#printPopBillWriteBtn").click(function() {
		$("#printContentsArea").print();
	});
	
	
</script>
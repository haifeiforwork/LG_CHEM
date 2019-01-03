<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.A.rfc.A04FamilyDetailRFC"%>
<%@ page import="hris.A.A04FamilyDetailData"%>
<%@ page import="hris.E.E21Entrance.rfc.E21EntranceDupCheckRFC"%>
<%@ page import="hris.E.E21Entrance.E21EntranceDupCheckData"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.WebUserData"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
	Vector A04FamilyDetailData_vt = (new A04FamilyDetailRFC()).getFamilyDetail(userData.empNo);
	Vector e21EntranceDupCheck_vt = (new E21EntranceDupCheckRFC()).getCheckList( userData.empNo, "4" );
	
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
	<h2 class="subtitle withButtons">유치원비 상세내역</h2>
	<div class="buttonArea">
		<ul class="btn_mdl">
			<li><a href="#" id="detailPrintBtn"><span>유치원비 신청서 프린트</span></a></li>
		</ul>
	</div>
	<div class="clear"></div>	
	<div class="table">
		<form id='detailForm'>
		<table class="tableGeneral">
		<caption>장학자금 신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_85p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="detailBegda">신청일</label></th>
			<td class="tdDate">
				<input class="readOnly" type="text" id="detailBegda" name="BEGDA" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="detailFamsa">가족선택</label></th>
			<td>
				<input class="readOnly w40" type="text" id="detailFamsa" name="FAMSA" readonly />
				<input class="readOnly w100" type="text" id="detailAtext" name="ATEXT" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailLfname">이름</label></th>
			<td>
				<select id="detailLfname" name="LFname" vname="이름" class="readOnly" disabled > 
					<option value="" >------선택------</option>
<%
				for(int i = 0 ; i < A04FamilyDetailData_vt.size() ; i++){
					A04FamilyDetailData data_name = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
					if( data_name.SUBTY.equals("2") ) {
%>

					<option value ="<%=data_name.LNMHG.trim()%><%=data_name.FNMHG.trim()%>" 
							SUBTY="<%=data_name.SUBTY%>" 
							OBJC_CODE="<%=data_name.OBJPS%>" 
							LNMHG="<%=data_name.LNMHG%>" 
							FNMHG="<%=data_name.FNMHG%>" 
							ACAD_CARE="<%=data_name.FASAR%>" 
							STEXT="<%=data_name.STEXT1%>" 
							ATEXT="<%=data_name.ATEXT%>"
							REGNO="<%=data_name.REGNO%>"
							FASIN="<%=data_name.FASIN%>" >
							<%=data_name.LNMHG.trim()%><%=data_name.FNMHG.trim()%></option>
<%
					}
				}
%>
				</select>
			</td>
		</tr>
		<tr>
			<th><label for="detailRegno">주민등록번호</label></th>
			<td>
				<input class="readOnly w150" type="text" id="detailRegno" name="REGNO" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="detailAcadCare">학력</label></th>
			<td>
				<input class="readOnly w40" type="text" id="detailAcadCare" name="ACAD_CARE" readonly />
				<input class="readOnly w100" type="text" id="detailStext" name="STEXT" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="detailFasin">교육기관</label></th>
			<td>
				<input class="readOnly w250" type="text" id="detailFasin" name="FASIN" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailPropAmnt">유치원비</label></th>
			<td>
				<input class="inputMoney readOnly w100" type="text" id="requestKinderPropAmnt" name="PROP_AMNT" vname="유치원비" required format="emptyCur" readonly />
				<select id="detailWaers" name="WAERS" class="readOnly" disabled>
					<option value="KRW">KRW</option>
				</select>
				<span class="pl20">		
					<input type="radio" id="detailRequMnth1" name="REQU_MNTH" value="01" class="readOnly" disabled /><label for="detailRequMnth1">1개월</label>
					<input type="radio" id="detailRequMnth2" name="REQU_MNTH" value="02" class="readOnly" disabled /><label for="detailRequMnth2">2개월</label>	
					<input type="radio" id="detailRequMnth3" name="REQU_MNTH" value="03" class="readOnly" disabled /><label for="detailRequMnth3">3개월</label>
				</span>
				<table class="innerTable mt5">
					<colgroup>
					<col width="90px" />
					<col width="*" />
					<col width="90px" />
					<col width="*" />
					<col width="90px" />
					<col width="*" />
					</colgroup>
					<tbody>
					<tr>
						<th>1개월</th>
						<td><input class="inputMoney w145 readOnly" type="text" id="PROP_AMT1" name="PROP_AMT1" value=""  format="emptyCur" readonly></td>
						<th>2개월</th>
						<td><input class="inputMoney w145 readOnly" type="text" id="PROP_AMT2" name="PROP_AMT2" value=""  format="emptyCur" readonly></td>
						<th>3개월</th>
						<td><input class="inputMoney w145 readOnly" type="text" id="PROP_AMT3" name="PROP_AMT3" value=""  format="emptyCur" readonly></td>
					</tr>
					</tbody>
				</table>	
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="detailRequDate">시작일 </label></th>
			<td>
				<input class="w80 readOnly" type="text" id="inputDateDay" name="REQU_DATE" vname="시작일" readOnly />
			</td>
		</tr>
		<tr>
			<th><label for="detailPaidAmnt">회사지원액</label></th>
			<td>
				<input class="inputMoney readOnly w100" type="text" id="detailPaidAmnt" name="PAID_AMNT" format="emptyCur" readonly />
				<table class="innerTable mt5">
					<colgroup>
					<col width="90px" />
					<col width="*" />
					<col width="90px" />
					<col width="*" />
					<col width="90px" />
					<col width="*" />
					</colgroup>
					<tbody>
					<tr>
						<th>1개월</th>
						<td><input class="inputMoney w145 readOnly" type="text" id="PAID_AMT1" name="PAID_AMT1" value="" format="emptyCur" readonly></td>
						<th>2개월</th>
						<td><input class="inputMoney w145 readOnly" type="text" id="PAID_AMT2" name="PAID_AMT2" value="" format="emptyCur" readonly></td>
						<th>3개월</th>
						<td><input class="inputMoney w145 readOnly" type="text" id="PAID_AMT3" name="PAID_AMT3" value="" format="emptyCur" readonly></td>
					</tr>
					</tbody>
				</table>	
			</td>
		</tr>
		</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
		<input type="hidden" id="detailLnmhg" name="LNMHG" />
		<input type="hidden" id="detailFnmhg" name="FNMHG" />
		</form>
	</div>
</div>

<!-- 프린트 영역 팝업-->
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>유치원비 신청서</strong>
		<a href="#" class="btnClose popLayerPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer">
			<div id="printBody">
				<iframe name="billWritePopup" id="billWritePopup" src="" frameborder="0" scrolling="no" style="float:left; height:800px; width:700px;"></iframe>
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

<script>
	var REQU_MNTH;
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getKindergartenDetail.json",
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
			fncSetFormReadOnly($("#detailForm"), true);
			
			$("#detailLfname").val(item.LNMHG + item.FNMHG);
			$("input:radio[name='REQU_MNTH']:input[value="+item.REQU_MNTH+"]").prop("checked", true);
			$("#detailRegno").val(item.REGNO.substring(0,6)+"-"+item.REGNO.substring(6));
			
			$("#detailFullName").val(item.LNMHG + item.FNMHG);
			$("#detailPrintBtn").show();
			REQU_MNTH = item.REQU_MNTH
		}
	};
	
	$(document).ready(function(){
		detailSearch();
		$("#PROP_AMT1, #PROP_AMT2, #PROP_AMT3").blur(function(){
			copyMoney();
		});
		// 개월수 체크시 회사 지원액 계산
		$("#detailRequMnth1, #detailRequMnth2, #detailRequMnth3").click(function(){
			setMonthField(this);
			copyMoney();
		});
	});
	
	// 이름 변경시
	$("#detailLfname").change(function(){
		if( $("#detailLfname option:selected").attr("ACAD_CARE") != "B1" ) {
			alert("자녀의 학력이 유치원일 경우에만 신청가능합니다.");
			$("#detailLfname").val("");
			$("#detailLnmhg").val("");
			$("#detailFnmhg").val("");
			$("#detailRegno").val("");
			$("#detailAcadCare").val("");
			$("#detailStext").val("");
			$("#detailFasin").val("");
			return false;
		}
		$("#detailLnmhg").val($("#detailLfname option:selected").attr("LNMHG"));
		$("#detailFnmhg").val($("#detailLfname option:selected").attr("FNMHG"));
		$("#detailRegno").val($("#detailLfname option:selected").attr("REGNO").substring(0,6)+"-"+$("#detailLfname option:selected").attr("REGNO").substring(6));
		
		$("#detailSubty").val($("#detailLfname option:selected").attr("SUBTY"));
		$("#detailObjcCode").val($("#detailLfname option:selected").attr("OBJC_CODE"));
		$("#detailAcadCare").val($("#detailLfname option:selected").attr("ACAD_CARE"));
		$("#detailStext").val($("#detailLfname option:selected").attr("STEXT"));
		$("#detailFasin").val($("#detailLfname option:selected").attr("FASIN"));
	})
	
	
	
	var setMonthField = function(obj){
		//초기화 후 지정
		$("#PROP_AMT1").val("");
		$("#PROP_AMT2").val("");
		$("#PROP_AMT3").val("");
		
		if($(obj).val() == "01"){
			setObjReadOnly($("#PROP_AMT2"), true);
			setObjReadOnly($("#PROP_AMT3"), true);
		} else if($(obj).val() == "02"){
			setObjReadOnly($("#PROP_AMT2"), false);
			setObjReadOnly($("#PROP_AMT3"), true);
		} else if($(obj).val() == "03"){
			setObjReadOnly($("#PROP_AMT2"), false);
			setObjReadOnly($("#PROP_AMT3"), false);
		}
	};

	
	// 회사 지원액 입력
	var copyMoney = function(){
		//지원액 초기화
		$("#requestKinderPropAmnt").val("");
		$("#PAID_AMT1").val("");
		$("#PAID_AMT2").val("");
		$("#PAID_AMT3").val("");
		$("#detailPaidAmnt").val("");
		
		//값이 있으면...
		if($("#PROP_AMT1").val()!="" || $("#PROP_AMT2").val()!="" || $("#PROP_AMT3").val()!=""){
			var PROP_AMT1 = removeComma($("#PROP_AMT1").val());
			var PROP_AMT2 = removeComma($("#PROP_AMT2").val());
			var PROP_AMT3 = removeComma($("#PROP_AMT3").val());
			var TOT_PROP_AMT = Number(PROP_AMT1)+Number(PROP_AMT2)+Number(PROP_AMT3);
			$("#requestKinderPropAmnt").val(insertComma(TOT_PROP_AMT));
			//회사지원액 계산
			var PAID_AMT1 = 0;
			var PAID_AMT2 = 0;
			var PAID_AMT3 = 0;
			// 유치원비를 넣으면 유치원비의 50%와 52,500원중 작은 금액을 회사지원액에 Display
			if(PROP_AMT1 > 0){
				PAID_AMT1 = parseInt(PROP_AMT1/2);
				if( PAID_AMT1 > 52500 ) PAID_AMT1 = 52500;
				$("#PAID_AMT1").val(insertComma(PAID_AMT1));
			}
			
			if(PROP_AMT2 > 0){
				var PAID_AMT2 = parseInt(PROP_AMT2/2);
				if( PAID_AMT2 > 52500 ) PAID_AMT2 = 52500;
				$("#PAID_AMT2").val(insertComma(PAID_AMT2));
			}
			
			if(PROP_AMT3 > 0){
				var PAID_AMT3 = parseInt(PROP_AMT3/2);
				if( PAID_AMT3 > 52500 ) PAID_AMT3 = 52500;
				$("#PAID_AMT3").val(insertComma(PAID_AMT3));
			}
			
			var TOT_PAID_AMT = PAID_AMT1 + PAID_AMT2 + PAID_AMT3;
			if(TOT_PAID_AMT>157500) TOT_PAID_AMT = 157500;
			$("#detailPaidAmnt").val(insertComma(TOT_PAID_AMT));
			
		}
	};
	
	// 유치원비 신청 check
	var requestKindergartenCheck = function(){
		copyMoney();
		if(!checkNullField("detailForm")){
			return false;
		}
		
		var l_r3_data = 0;
		if( $("#detailLfname option:selected").attr("ACAD_CARE") == "B1" ) {
<%
		for( int i = 0 ; i < e21EntranceDupCheck_vt.size() ; i++ ) {
			E21EntranceDupCheckData c_Data = (E21EntranceDupCheckData)e21EntranceDupCheck_vt.get(i);
%>
			if( ("<%= c_Data.SUBF_TYPE %>" == "4") &&
				("<%= c_Data.ACAD_CARE %>" == $("#detailLfname option:selected").attr("ACAD_CARE") ) &&
				("<%= c_Data.REGNO     %>" == $("#detailLfname option:selected").attr("REGNO") ) ) {
				if( "<%= c_Data.INFO_FLAG %>" == "I" ) {
					l_r3_data = Number("<%= c_Data.REQU_MNTH %>");
				} else if( "<%= c_Data.INFO_FLAG %>" == "T" && "<%= c_Data.AINF_SEQN %>" != "<c:out value='${AINF_SEQN}'/>" ) {
					alert("현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
					return false;
				}
			}
<%
		}
%>
			var l_requ_mnth = $("#detailForm input:radio[name='REQU_MNTH']  ").filter(":checked").val();
			//1개월은 픽스
			if(Number($("#PROP_AMT1").val())==0) {
				alert("금액을 입력하세요.");
				return false;
			}
			if(l_requ_mnth=="02"){
				if(Number($("#PROP_AMT2").val())==0) {
					alert("금액을 입력하세요.");
					return false;
				}
			} else if(l_requ_mnth=="03"){
				if(Number($("#PROP_AMT2").val())==0 || Number($("#PROP_AMT3").val())==0) {
					alert("금액을 입력하세요.");
					return false;
				}
			}
			
			l_requ_mnth = Number(l_requ_mnth) + Number(l_r3_data);
			if( l_requ_mnth > 12 ) {
				alert("해당 자녀에 대해 12개월 지급만 가능합니다.\n\n현재 지급 횟수 : " + l_r3_data);
				return false;
			}
		} else {
			alert("자녀의 학력이 유치원일 경우에만 신청가능합니다.");
			return false;
		}
		
		return true;
	};
	
	// 수정 버튼 클릭(모드전환)
	var reqModifyActionCallBack = function(){
		
		fncSetFormReadOnly($("#detailForm"), false, new Array("detailBegda", "detailFamsa", "detailAtext", "detailRegno", "detailAcadCare", "detailStext", "detailFasin", "detailPaidAmnt", "requestKinderPropAmnt", "PAID_AMT1","PAID_AMT2","PAID_AMT3"));
		if(REQU_MNTH=="01"){
			setObjReadOnly($("#PROP_AMT2"), true);
			setObjReadOnly($("#PROP_AMT3"), true);
		} else if(REQU_MNTH=="02"){
			setObjReadOnly($("#PROP_AMT2"), false);
			setObjReadOnly($("#PROP_AMT3"), true);
		} else {
			setObjReadOnly($("#PROP_AMT2"), false);
			setObjReadOnly($("#PROP_AMT3"), false);
		}
		
		$("#inputDateDay").datepicker();
		
		$("#detailPrintBtn").hide();
	};
	
	// 삭제 버튼 클릭
	var reqDeleteActionCallBack = function(){
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		
		if(confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteKindergarten',
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
						alert("신청시 오류가 발생하였습니다. " + response.message);
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
		destroydatepicker("detailForm");
		detailSearch();
	};
	
	// 저장(수정내용 저장) 버튼 클릭
	var reqSaveActionCallBack = function(){
		if($("#detailDecisioner").jsGrid("dataCount") <1 ){
			alert("결재자 정보가 없습니다.");
			return;
		}
		if(requestKindergartenCheck()){
			if(confirm("신청 하시겠습니까?")){
				$("#reqSaveBtn").prop("disabled", true);
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'POST',
					url : '/appl/updateKindergarten',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							$('#applDetailArea').html('');
							$("#reqApplGrid").jsGrid("search");
							return true;
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
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
	
	
	$("#detailPrintBtn").click(function(){
		$("#billWritePopup").attr("src","/appl/print/kindergartenPrint/?AINF_SEQN=" + $("#AINF_SEQN").val());
		$("#billWritePopup").load(function(){
			$('#popLayerPrint').popup("show");
		});
	});
	
	$("#printPopBillWriteBtn").click(function() {
		$("#printContentsArea").print();
	});
	
	
</script>
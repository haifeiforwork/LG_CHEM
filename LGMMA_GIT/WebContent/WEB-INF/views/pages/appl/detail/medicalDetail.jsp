<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>
<%@ page import="hris.E.E17Hospital.rfc.E17GuenCodeRFC" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%
WebUserData 	user					= (WebUserData)session.getValue("user");
E17MedicCheckYNRFC checkYN = new E17MedicCheckYNRFC();
String             E_FLAG  = checkYN.getE_FLAG( DataUtil.getCurrentYear(), user.empNo );
%>
	<div class="tabUnder tab1">
		<!--// Table start -->
		<form id ="detailForm" name ="detailForm">
		<div class="tableArea">
			<h2 class="subtitle withButtons">진료 기본사항</h2>
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a href="#" id="BillPrintBtn" name="BillPrintBtn"><span>의료비 지원 신청서</span></a></li>
				</ul>
			</div>
			<div class="clear"></div>
			<div class="table">
				<table class="tableGeneral">
				<caption>진료 기본사항</caption>
				<colgroup>
					<col class="col_15p"/>
					<col class="col_85p"/>
				</colgroup>
				<tbody>
				<tr>
					<th><label for="inputText01-1">신청일</label></th>
					<td class="tdDate">
						<input class="readOnly" type="text" name="BEGDA" value="" id="BEGDA" readonly />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="input-radio01-1">관리번호 </label></th>
					<td>
						<input class="readOnly" type="text" name="CTRL_NUMB" id="CTRL_NUMB" />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="inputSelect01-2">구분 </label></th>
					<td>
						<input class="readOnly" type="text" name="GUEN_NAME" id="GUEN_NAME" />
						<input class="readOnly" type="hidden" name="GUEN_CODE" id="GUEN_CODE" />
						<input class="readOnly" type="checkbox" name="PROOF" id="PROOF" value="" readOnly>연말정산반영여부
					</td>
				</tr>
				<tr id="child">
					<th><span class="textPink">*</span><label for="inputSelect01-3">자녀이름</label></th>
					<td>
						<input class="readOnly" type="text" name="ENAME" id="ENAME" />
						<input class="w150 readOnly" type="text" id="REGNO_dis" name="REGNO_dis" value="" readonly />
						<input class="w150 readOnly" type="text" id="Message" name="Message" value="" readonly style="display:'none'" />
					</td>
					<input type="hidden" id="OBJPS_21" name="OBJPS_21" value="">
					<input type="hidden" id="REGNO_21" name="REGNO_21" value="">
					<input type="hidden" id="DATUM_21" name="DATUM_21" value="">
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="inputText01-4">상병명</label></th>
					<td>
						<input class="wPer" type="text" id="SICK_NAME" name="SICK_NAME" value="" />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="inputText01-5">구체적증상 </label></th>
					<td>
						<textarea id="SICK_DESC" name="SICK_DESC" rows="4" value=""></textarea>
						<input type="hidden" name="SICK_DESC1" id="SICK_DESC1" value=""><!-- 구체적증상 -->
						<input type="hidden" name="SICK_DESC2" id="SICK_DESC2" value=""><!-- 구체적증상 -->
						<input type="hidden" name="SICK_DESC3" id="SICK_DESC3" value=""><!-- 구체적증상 -->
						<input type="hidden" name="SICK_DESC4" id="SICK_DESC4" value="">
					</td>
				</tr>
				</tbody>
				</table>
			</div>
		</div>
		<!--// Table end -->
		<!--// list start -->
		<div class="listArea">
			<h2 class="subtitle withButtons">의료비 등록</h2>
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a href="#" id="popLayerMedicalCreate"><span>등록/추가</span></a></li>
					<li><a href="#" id="popLayerMedicalUpdate" ><span>수정</span></a></li>
					<li><a href="#" id="popLayerMedicalDelete" ><span>삭제</span></a></li>
<!-- 					<li><a href="#" id="popLayerWriteBill"><span>진료비 계산서</span></a></li> -->
				</ul>
			</div>
			<div id="MedicalListGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
			<input type="hidden" id="medi_count" name="medi_count" />
			<input type="hidden" name="AINF_SEQN"  id="AINF_SEQN"  value="">
			<input type="hidden" name="CTRL_NUMB"  id="CTRL_NUMB"  value=""><!-- 관리번호   -->
			<input type="hidden" name="RCPT_NUMB"  id="RCPT_NUMB"  value="">
			<input type="hidden" name="RCPT_CODE_Check"  id="RCPT_CODE_Check"  value="">
			<input type="hidden" name="YTAX_WONX"  id="YTAX_WONX"  value="">
			<input type="hidden" name="MAX_CHK"  id="MAX_CHK"  value="">		
		</form>
		
			<form id="totalWaersForm" name="totalWaersForm">				
				<table class="tableGeneral tableBT mt10">
				<colgroup>
					<col class="col_15p" align="right"/>
					<col class="col_35p" align="right"/>
					<col class="col_15p" align="right"/>
					<col class="col_35p" align="right"/>
				</colgroup>
				<tbody>
				<c:if test="${STAT_TYPE == '03'}">
				<tr>
					<th><label for="inputText03-1">회사지원총액</label></th>
					<td>
						<input class="inputMoney readOnly w100" type="text" name="COMP_sum" value="" id="COMP_sum" readonly />  KRW
					</td>
					<th><label for="inputText03-1">계</label></th>
					<td>
						<input class="inputMoney readOnly w100" type="text" name="EMPL_WONX_tot" value="" id="EMPL_WONX_tot" readonly /> KRW
					</td>
				</tr>
				<tr>
					<th><label for="inputText03-1">연말정산반영액</label></th>
					<td>
						<input class="inputMoney readOnly w100" type="text" name="YTAX_WONX" value="" id="YTAX_WONX" readonly />  KRW
					</td>
					<th><label for="inputText03-1">회사지원액</label></th>
					<td>
						<input class="inputMoney readOnly w100" type="text" name="COMP_WONX" value="" id="COMP_WONX" readonly />  KRW
					</td>
				</c:if>
				<c:if test="${STAT_TYPE == '01'}">
				<div class="totalArea">
						<strong>계</strong>
						<input class="inputMoney readOnly" type="text" name="EMPL_WONX_tot" id="EMPL_WONX_tot" value="" readonly />  KRW
					</div>
				</c:if>
				</tr>
				</tbody>
				</table>				
				<div class="tableComment">
					<p><span class="bold">안내사항</li>
					<ul>
						<li>진료 기본사항 입력 후, 증빙별 의료비 등록 후 일괄 신청하세요. (진료비 세부항목 입력 불필요)</li>
						<li>제출 서류 : 진료비 계산서(진료비 납입확인서는 불가), 약국영수증(의사처방전 첨부)</li>
						<li>세부 항목에 대한 의료비 지원 여부는 우측상단의 <span class="colorOrg">'의료비 지원/제외 기준'</span>을  참조하세요. </li>
					</ul>
				</div>
			</form>
			<form id="form3"name="form3" method="post">
				<input type="hidden" name="CTRL_YEAR" id="CTRL_YEAR" value="">
				<input type="hidden" name="GUEN_CODE" id="GUEN_CODE" value="">
				<input type="hidden" name="OBJPS_21"  id="OBJPS_21"  value="">
				<input type="hidden" name="REGNO_21"  id="REGNO_21"  value="">
			</form>
		</div>
		<!--// Table end -->
	</div>
<!-- popup : 의료비 목록 start -->
<div class="layerWrapper layerSizeM" id="popLayerMedical">
	<div class="layerHeader">
		<strong>의료비 목록</strong>
		<a href="#" class="btnClose popLayerMedical_close">창닫기</a>
	</div>
	<div class="layerContainer">
	<form id ="popLayerMedicalForm" name ="popLayerMedicalForm">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="tableArea tablePopup">
				<div class="table">
				
					<table class="tableGeneral">
					<caption>의료비 목록</caption>
					<colgroup>
						<col class="col_30p" />
						<col class="col_70p" />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-1">의료기관</label></th>
							<td>
								<input class="w200" type="text" name="MEDI_NAME" value="" id="MEDI_NAME" />
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-2">사업자등록번호</label></th>
							<td>
								<input class="w200" type="text" name="MEDI_NUMB" value="" id="MEDI_NUMB" onkeyup="businoFormat();"/>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-3">전화번호</label></th>
							<td>
								<input class="w200" type="number" name="TELX_NUMB" value="" id="TELX_NUMB" onBlur="phone_1(this);"/>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-4">진료일</label></th>
							<td>
							   <input class="datepicker" type="text" id="EXAM_DATE" name="EXAM_DATE" onBlur="dateFormat(this);"/>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-5">입원/외래</label></th>
							<td>
								<select id="MEDI_CODE" name="MEDI_CODE" required>
									<option value="0001" >입원</option>
						 			<option value="0002" >외래</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-6">영수증 구분</label></th>
							<td>
								<select id="RCPT_CODE" name="RCPT_CODE" >
									<option value="0002" >진료비계산서</option>
						 			<option value="0003" >약국영수증</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-7">결재수단</label></th>
							<td>
								<select id="MEDI_MTHD" name="MEDI_MTHD">
									<option value="2"  >신용카드</option>
									<option value="3"  >현금영수증</option>
									<option value="1"  >현금</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-8">본인실납부액</label></th>
							<td>
								<input class="inputMoney w200" type="text" id="EMPL_WONX" name = "EMPL_WONX" value="" onkeyup="addComma(this)" >원	
							</td>
						</tr>
					</tbody>
					</table>
				</div>
			</div>
			<div class="buttonArea buttonCenter">
				<ul class="btn_crud">
					<li><a class="darken" id="popLayerMedicalCreateBtn" href="#"><span>확인</span></a></li>
					<li><a href="#" id="popLayerMedicalCreatCansel" ><span>취소</span></a></li>
					<input type="hidden" id ="medicalMode" name ="medicalMode" vlaue="">
				</ul>
			</div>
			<!--// Content end  -->
			</form>
		</div>
	</div>
</div>
<!-- //popup: 의료비 목록 end -->

<!-- popup : 진료비 계산서 입력 start -->
<div class="layerWrapper layerSizeS" id="popLayerBillWrite" style="display:inherit !important">
	<div class="layerHeader">
		<strong>진료비 계산서 입력</strong>
		<a href="#" class="btnClose popLayerBillWrite_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
		<form id="BillWriteForm" name="BillWriteForm">
			<!--// Content start  -->
			<div class="layerScroll">
				<div class="tableArea tablePopup">
					<h2 class="subtitle">보험급여</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>보험급여</caption>
						<colgroup>
							<col class="col_34p" />
							<col class="col_66p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-1">총 진료비</label></th>
								<td><input class="inputMoney" type="text" id="TOTL_WONX" name="TOTL_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><label for="inputText01-2">조합부담금</label></th>
								<td><input class="inputMoney" type="text" id="ASSO_WONX" name="ASSO_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><label for="inputText01-3">본인부담금①</label></th>
								<td><input class="inputMoney readOnly" type="text" id="x_EMPL_WONX" name="x_EMPL_WONX" value="" onkeyup=" BillWritemultiple_won();" readonly></td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div class="tableArea tablePopup">
					<h2 class="subtitle">보험 비급여</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>보험 비급여</caption>
						<colgroup>
							<col class="col_34p" />
							<col class="col_66p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-4">식대</label></th>
								<td><input class="inputMoney" type="text" id="MEAL_WONX" name="MEAL_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><label for="inputText01-5">지정진료비</label></th>
								<td><input class="inputMoney" type="text" id="APNT_WONX"  name="APNT_WONX"  value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><label for="inputText01-6">입원료</label></th>
								<td><input class="inputMoney" type="text" id="ROOM_WONX" name="ROOM_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><label for="inputText01-7">CT</label></th>
								<td><input class="inputMoney" type="text" id="CTXX_WONX" name="CTXX_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><label for="inputText01-8">MRI</label></th>
								<td><input class="inputMoney" type="text" id="MRIX_WONX" name="MRIX_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><label for="inputText01-9">초음파</label></th>
								<td><input class="inputMoney" type="text" id="SWAV_WONX" name="SWAV_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC1_TEXT" name="ETC1_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC1_WONX" name="ETC1_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC2_TEXT" name="ETC2_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC2_WONX" name="ETC2_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC3_TEXT" name="ETC3_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC3_WONX" name="ETC3_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC4_TEXT" name="ETC4_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC4_WONX" name="ETC4_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC5_TEXT"  name="ETC5_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC5_WONX" name="ETC5_WONX" value="" onkeyup=" BillWritemultiple_won();" ></td>
							</tr>
							<tr>
								<th><label for="inputText01-15">소 계②</label></th>
								<td><input class="inputMoney readOnly" type="text" id="EMPL_WONX_sub" name="EMPL_WONX_sub" value="" onkeyup=" BillWritemultiple_won();" readonly></td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div class="tableArea tablePopup">
					<h2 class="subtitle">할인금액</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>할인금액</caption>
						<colgroup>
							<col class="col_34p" />
							<col class="col_66p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-16">할인금액③</label></th>
								<td><input class="inputMoney" type="text" name="DISC_WONX" id="DISC_WONX" value="" onkeyup=" BillWritemultiple_won();"></td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div class="tableArea tablePopup">
					<h2 class="subtitle">본인부담금 총액</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>본인부담금 총액</caption>
						<colgroup>
							<col class="col_34p" />
							<col class="col_66p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-17">① + ② - ③</label></th>
								<td>
									<input class="inputMoney readOnly" type="text" name="bill_EMPL_WONX_tot" id="bill_EMPL_WONX_tot"  value="" readonly> KRW
								</td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="buttonArea buttonCenter mt10">
				<ul class="btn_crud">
					<li><a class="darken" id="BillWriteBtn" href="#"><span>확인</span></a></li>
					<li><a href="#" id="popLayerBillWriteCansel"><span>취소</span></a></li>
					<li><a href="#" id="BillDetailPrintBtn" ><span>진료비 프린트</span></a></li>
				</ul>
			</div>
			<!--// Content end  -->
			<input type="hidden" id="index" name="index" />
			</form>
		</div>
	</div>
</div>
<!-- //popup : 진료비 계산서 입력 end -->

<!-- 프린트 영역 팝업-->
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>의료비 지원 신청서</strong>
		<a href="#" class="btnClose popLayerPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer">
			<div id="printBody">
				<iframe name="billWritePopup" id="billWritePopup" src="" frameborder="0" scrolling="no" style="float:left; height:1800px; width:700px;"></iframe>
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

		<!-- 프린트 영역 팝업-->
<div class="layerWrapper layerSizeP" id="popLayerBillPrint">
	<div class="layerHeader">
		<strong>진료비게산서</strong>
		<a href="#" class="btnClose popLayerBillPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printDetailArea" class="layerContainer">
			<div id="printBody">
				<iframe name="billDetailPopup" id="billDetailPopup" src="" frameborder="0" scrolling="no" style="float:left; height:1000px; width:700px;"></iframe>
			</div>
		</div>
	</div>
	<div class="buttonArea buttonPrint">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="printPopBillDetailBtn"><span>프린트</span></a></li>
		</ul>
	</div>
	<div class="clear"></div>
</div>

<!-- // script -->
<script type="text/javascript">
var orgItem;
	//main print
	$("#printPopBillWriteBtn").click(function() {
		//$("#billWritePopup").print();
		top.billWritePopup.focus();
		window.print();
	
	});
	$("#BillPrintBtn").click(function(){
			var AINF_SEQN = $("#AINF_SEQN").val();
			$("#billWritePopup").attr("src","/supp/medicalPrint/requestPrint/?AINF_SEQN="+AINF_SEQN);
			$("#billWritePopup").load(function(){
				$('#popLayerPrint').popup("show");
			});
	});
	
	//bill print
	$("#printPopBillDetailBtn").click(function() {
		$("#billDetailPopup").print();
	});
	$("#BillDetailPrintBtn").click(function(){
			var AINF_SEQN = $("#AINF_SEQN").val();
			var RCPT_NUMB = $("#RCPT_NUMB").val();
			$("#billDetailPopup").attr("src","/supp/medicalPrint/after/?AINF_SEQN="+AINF_SEQN+" ?RCPT_NUMB="+RCPT_NUMB);
			$("#billDetailPopup").load(function(){
				$('#popLayerBillPrint').popup("show");
			});
	});
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getMedicalDetail.json",
			dataType : "json",
			data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
		}).done(function(response) {
			if(response.success) {
				setDetail(response.storeData);
				$("#SICK_DESC").val(response.storeData.SICK_DESC1 +"\n"+ response.storeData.SICK_DESC2 +"\n"+ response.storeData.SICK_DESC3 +"\n"+ response.storeData.SICK_DESC4);
				$("#GUEN_NAME").val(response.storeData.GUEN_CODE=="0001" ? "본인" : response.storeData.GUEN_CODE=="0002" ? "배우자" : "자녀");
				if(response.storeData.GUEN_CODE=="0003"){
					var begin_date = removePoint(response.storeData.BEGDA);
					var d_datum	= addSlash(response.storeData.DATUM_21);
					dif = dayDiff(addSlash(begin_date), d_datum);
					if( dif < 0 ) {
						$("#Message").show();
						$("#Message").val($("#ENAME").val() + "는 " + d_datum.substring(0,4) + "년 " + d_datum.substring(5,7) + "월 부터 자녀의료비지원 대상에서 제외되며, " + d_datum.substring(5,7) + "월 전월 의료비까지 지원 가능합니다.");
					} else {
						$("#Message").hide();
						$("#Message").val("");
					}
					$("#child").show();
					$("#REGNO_dis").val(response.storeData.REGNO_21.substring(0, 6) + "-*******");
				}else{
					$("#child").hide();
					$("#Message").hide();
					$("#Message").val("");
				}
				
				if(response.storeData.PROOF=="X"){
					$("#PROOF").val("X").prop("checked", true);
				}else{
					$("#PROOF").val("").prop("checked", false);
				}
				$("#PROOF").prop("disabled", true);
				$("#totalWaersForm #YTAX_WONX").val(banolim(response.storeData.YTAX_WONX, 0).format());
				$("#totalWaersForm #COMP_WONX").val(banolim(response.storeData.COMP_WONX, 0).format());
				$("#form3 #CTRL_YEAR").val(response.storeData.CTRL_NUMB.substring(0, 4));
				$("#form3 #GUEN_CODE").val(response.storeData.GUEN_CODE);
				$("#form3 #OBJPS_21").val(response.storeData.OBJPS_21);
				$("#form3 #REGNO_21").val(response.storeData.REGNO_21);
				$("#popLayerMedicalCreate").hide();
				$("#popLayerMedicalUpdate").hide();
				$("#popLayerMedicalDelete").hide();
				$("#BillWriteBtn").hide();
				$("#popLayerBillWriteCansel").hide();
				$("#bigoTr").show();
				$("#AINF_SEQN").val('${AINF_SEQN}');
				fncSetFormReadOnly($("#detailForm"), true);
				fncSetFormReadOnly($("#BillWriteForm"), true);
			}else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
	}
	
	var setDetail = function(item){
		setTableText(item, "detailForm");
		fncSetFormReadOnly($("#detailForm"), true);
		fncSetFormReadOnly($("#BillWriteForm"), true);
		MedicalListGrid();
	}
	
	$(document).ready(function(){
		detailSearch();
		$("#popLayerBillWrite").hide();
	});
	
	var reqModifyActionCallBack = function() {
		fncSetFormReadOnly($("#detailForm"), false, new Array("BEGDA","CTRL_NUMB","GUEN_NAME","ENAME","REGNO_dis","Message"));
		fncSetFormReadOnly($("#BillWriteForm"), false, new Array("x_EMPL_WONX","EMPL_WONX_sub","bill_EMPL_WONX_tot") );
		fncSetFormReadOnly($("#totalWaersForm"), true);
		
		$("#EXAM_DATE").datepicker();
		
		$("#popLayerMedicalCreate").show();
		$("#popLayerMedicalUpdate").show();
		$("#popLayerMedicalDelete").show();
		$("#BillWriteBtn").show();
		$("#popLayerBillWriteCansel").show();
		$("#bigoTr").hide();
	}
	
	// 취소(수정 취소) 버튼 클릭
	var reqCancelActionCallBack = function(){
		$("#detailForm").each(function(){
			this.reset();
		});
		detailSearch();
	};
	
	var reqSaveActionCallBack = function() {
		if(check_data()){
			if (confirm("저장하시겠습니까?")) {
				$("#detailForm #PROOF").prop("disabled", false); 
				if ($("#detailForm #PROOF").is(':checked')) {
					$("#detailForm #PROOF").val("X");
				} else {
					 $("#detailForm #PROOF").val("");
				}
				$("#detailForm #medi_count").val($("#MedicalListGrid").jsGrid("dataCount"));
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				$("#MedicalListGrid").jsGrid("serialize", param);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				jQuery.ajax({
					type : 'POST',
					url : '/appl/updateMedical.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if (response.success) {
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
		} else {
			$("#requestForm #EMPL_WONX_tot").val(insertComma($("#requestForm #EMPL_WONX_tot").val()));
			return false;
		}
	};
	
	
	// 삭제 버튼 클릭
	var reqDeleteActionCallBack = function(){
		if(confirm("삭제 하시겠습니까?")) {
			
			$("#reqDeleteBtn").prop("disabled", true);
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			$("#MedicalListGrid").jsGrid("serialize", param);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteMedical',
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
	}
	
	var businoFormat = function(){
		var tempStr= $("#MEDI_NUMB").val();
		
		if( tempStr.length == 10 ) {
			tempStr = tempStr.substring(0,3) + "-" + tempStr.substring(3,5) + "-" + tempStr.substring(5,10);
		}
		$("#MEDI_NUMB").val(tempStr);
		return true;
	}
	
	function addComma(x){
		x = insertComma(x.value);
		return $("#popLayerMedicalForm #EMPL_WONX").val(x);
	};
	
	//의료비목록 grid
	var MedicalListGrid = function() {
		$("#MedicalListGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : true,
			controller : {
				loadData : function() {
				var d = $.Deferred();
				$.ajax({
					type : "GET",
					url : "/appl/getMedicalListDetail.json",
					dataType : "json",
					data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'},
				}).done(function(response) {
					if(response.success)
						d.resolve(response.storeData);
					else
						alert("조회시 오류가 발생하였습니다. " + response.message);
					});
					return d.promise();
				}
			},
			fields: [
					{
					title: "선택", name: "th1", align: "center", width: "8%" ,
					itemTemplate: function(_, item) {
						return $("<input name='chk' id='chk'>")
								.attr("type", "radio")
								.on("click", function(e) {
									orgItem = item;
								$("#popLayerMedicalForm #MEDI_NAME").val(item.MEDI_NAME);
								$("#popLayerMedicalForm #MEDI_NUMB").val(item.MEDI_NUMB);
								$("#popLayerMedicalForm #TELX_NUMB").val(item.TELX_NUMB);
								$("#popLayerMedicalForm #EXAM_DATE").val(item.EXAM_DATE);
								$("#popLayerMedicalForm #MEDI_CODE").val(item.MEDI_CODE);
								$("#popLayerMedicalForm #RCPT_CODE").val(item.RCPT_CODE);
								$("#popLayerMedicalForm #MEDI_MTHD").val(item.MEDI_MTHD);
								$("#popLayerMedicalForm #EMPL_WONX").val(banolim(item.EMPL_WONX,0).format());
								$("#BillWriteForm #TOTL_WONX").val(item.TOTL_WONX); 
								$("#BillWriteForm #ASSO_WONX").val(item.ASSO_WONX); 
								$("#BillWriteForm #x_EMPL_WONX").val(item.x_EMPL_WONX); 
								$("#BillWriteForm #MEAL_WONX").val(item.MEAL_WONX); 
								$("#BillWriteForm #APNT_WONX").val(item.APNT_WONX); 
								$("#BillWriteForm #ROOM_WONX").val(item.ROOM_WONX); 
								$("#BillWriteForm #CTXX_WONX").val(item.CTXX_WONX); 
								$("#BillWriteForm #MRIX_WONX").val(item.MRIX_WONX); 
								$("#BillWriteForm #SWAV_WONX").val(item.SWAV_WONX); 
								$("#BillWriteForm #ETC1_WONX").val(item.ETC1_WONX); 
								$("#BillWriteForm #ETC1_TEXT").val(item.ETC1_TEXT); 
								$("#BillWriteForm #ETC2_WONX").val(item.ETC2_WONX); 
								$("#BillWriteForm #ETC2_TEXT").val(item.ETC2_TEXT); 
								$("#BillWriteForm #ETC3_WONX").val(item.ETC3_WONX); 
								$("#BillWriteForm #ETC3_TEXT").val(item.ETC3_TEXT); 
								$("#BillWriteForm #ETC4_WONX").val(item.ETC4_WONX); 
								$("#BillWriteForm #ETC4_TEXT").val(item.ETC4_TEXT); 
								$("#BillWriteForm #ETC5_WONX").val(item.ETC5_WONX); 
								$("#BillWriteForm #ETC5_TEXT").val(item.ETC5_TEXT); 
								$("#BillWriteForm #EMPL_WONX_sub").val(item.EMPL_WONX_sub);
								$("#BillWriteForm #DISC_WONX").val(item.DISC_WONX);
								$("#BillWriteForm #bill_EMPL_WONX_tot").val(item.bill_EMPL_WONX_tot);
								$("#detailForm #RCPT_CODE_Check").val(item.RCPT_CODE);
								$("#BillWriteForm #CTRL_NUMB").val(item.CTRL_NUMB);
								$("#detailForm #RCPT_NUMB").val(item.RCPT_NUMB);
								rowNumber();
							});
						}
					},
				{ title: "<span class='textPink'>*</span>의료기관", name: "MEDI_NAME", type: "text", align: "center", width: "16%" },
				{ title: "사업자<br>등록번호", name: "MEDI_NUMB", type: "text", align: "center", width: "10%", 
					itemTemplate: function(value, storeData) {
						if(value != ""){
							 if( value.substring(3, 4) == "-" && value.substring(6, 7) == "-" ) {
								 return value;
							 } else {
								 return ( value.substring(0, 3)+"-"+value.substring(3,5)+"-"+value.substring(5) );
							 }
						}else{
							return value;
						}
					}
				},
				{ title: "<span class='textPink'>*</span>전화번호", name: "TELX_NUMB", type: "number", align: "center", width: "12%" },
				{ title: "<span class='textPink'>*</span>진료일", name: "EXAM_DATE", type: "number", align: "center", width: "10%" },
				{ title: "<span class='textPink'>*</span>입원<br>/외래", name: "MEDI_CODE", type: "text", align: "center", width: "7%"
					,itemTemplate: function(value, item) {
						if(value == "0001"){
							return "입원";
						}else{
							return "외래";
						}
					}
				},
				{ title: "<span class='textPink'>*</span>영수증구분", name: "RCPT_CODE", type: "text", align: "center", width: "11%",
					itemTemplate: function(value, item) {
						if(value == "0002"){
							return "진료비계산서";
						}else{
							return "약국영수증";
						}
					}
				},
				{ title: "<span class='textPink'>*</span>결재수단", name: "MEDI_MTHD", type: "text", align: "center", width: "11%",
					itemTemplate: function(value, item) {
						if(value == "2"){
							return "신용카드";
						}else if(value == "3"){
							return "현금영수증";
						}else{
							return "현금";
						}
					}
				},
				{ title: "<span class='textPink'>*</span>본인실납부액", name: "EMPL_WONX", type: "number", align: "right", width: "11%" 
					,itemTemplate: function(value, item) {
						return banolim(value,0).format();
					}
				},
				{ name: "MEDI_TEXT", type: "text", visible: false },
				{ name: "RCPT_TEXT", type: "text", visible: false },
				{ name: "TOTL_WONX", type: "text", visible: false },
				{ name: "ASSO_WONX", type: "text", visible: false },
				{ name: "x_EMPL_WONX", type: "text", visible: false },
				{ name: "MEAL_WONX", type: "text", visible: false },
				{ name: "APNT_WONX", type: "text", visible: false },
				{ name: "ROOM_WONX", type: "text", visible: false },
				{ name: "CTXX_WONX", type: "text", visible: false },
				{ name: "MRIX_WONX", type: "text", visible: false },
				{ name: "SWAV_WONX", type: "text", visible: false },
				{ name: "ETC1_WONX", type: "text", visible: false },
				{ name: "ETC1_TEXT", type: "text", visible: false },
				{ name: "ETC2_WONX", type: "text", visible: false },
				{ name: "ETC2_TEXT", type: "text", visible: false },
				{ name: "ETC3_WONX", type: "text", visible: false },
				{ name: "ETC3_TEXT", type: "text", visible: false },
				{ name: "ETC4_WONX", type: "text", visible: false },
				{ name: "ETC4_TEXT", type: "text", visible: false },
				{ name: "ETC5_WONX", type: "text", visible: false },
				{ name: "ETC5_TEXT", type: "text", visible: false },
				{ name: "EMPL_WONX_sub", type: "text", visible: false },
				{ name: "DISC_WONX", type: "text", visible: false },
				{ name: "bill_EMPL_WONX_tot", type: "text", visible: false }
			],
			onItemInserted: function(){
				var data = $("#MedicalListGrid").jsGrid("option", "data");
				var nub2 = 0;
				$.each(data, function(i, $item) {
					nub2 += eval(banolim($item.EMPL_WONX == "" ? 0 : $item.EMPL_WONX, 0));
					$("#totalWaersForm #EMPL_WONX_tot").val(nub2.format());
				});
			},
			onItemUpdated: function(){
				var data = $("#MedicalListGrid").jsGrid("option", "data");
				var nub2 = 0;
				$.each(data, function(i, $item) {
					nub2 += eval(banolim($item.EMPL_WONX == "" ? 0 : $item.EMPL_WONX, 0));
					$("#totalWaersForm #EMPL_WONX_tot").val(nub2.format());
				});
			},
			onItemDeleted: function(){
				var data = $("#MedicalListGrid").jsGrid("option", "data");
				var nub2 = 0;
				$.each(data, function(i, $item) {
					nub2 += eval(banolim($item.EMPL_WONX == "" ? 0 : $item.EMPL_WONX, 0));
					$("#totalWaersForm #EMPL_WONX_tot").val(nub2.format());
				});
			},
			onDataLoaded: empltotal
		});
	};
	
	var empltotal = function(){
		var data = $("#MedicalListGrid").jsGrid("option", "data");
		var nub2 = 0;
		$.each(data, function(i, item) {
			nub2 += eval(banolim(item.EMPL_WONX == "" ? 0 : item.EMPL_WONX, 0));
			$("#totalWaersForm #EMPL_WONX_tot").val(nub2.format());
			item.TOTL_WONX          = '';
			item.ASSO_WONX          = '';
			item.x_EMPL_WONX        = '';
			item.MEAL_WONX          = '';
			item.APNT_WONX          = '';
			item.ROOM_WONX          = '';
			item.CTXX_WONX          = '';
			item.MRIX_WONX          = '';
			item.SWAV_WONX          = '';
			item.ETC1_WONX          = '';
			item.ETC1_TEXT          = '';
			item.ETC2_WONX          = '';
			item.ETC2_TEXT          = '';
			item.ETC3_WONX          = '';
			item.ETC3_TEXT          = '';
			item.ETC4_WONX          = '';
			item.ETC4_TEXT          = '';
			item.ETC5_WONX          = '';
			item.ETC5_TEXT          = '';
			item.EMPL_WONX_sub      = '';
			item.DISC_WONX          = '';
			item.bill_EMPL_WONX_tot = '';
		});
		totalBill();
		billDetailFirst();
	}
	
	var totalBill = function (){
		jQuery.ajax({
			type : 'GET',
			url : '/appl/getTotalBill.json',
			cache : false,
			dataType : 'json',
			data : {
				"CTRL_YEAR" : $("#form3 #CTRL_YEAR").val(),
				"GUEN_CODE" : $("#form3 #GUEN_CODE").val(),
				"OBJPS_21" : $("#form3 #OBJPS_21").val(),
				"REGNO_21" : $("#form3 #REGNO_21").val()
			},
			async :false,
			success : function(response) {
				if(response.success){
					var COMP_sum =  response.COMP_sum;
					$("#totalWaersForm #COMP_sum").val(banolim(COMP_sum == 0 ? "" : COMP_sum).format());
				}else{
					alert("조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	$("#popLayerMedicalCreateBtn").click(function(){
		if($("#medicalMode").val() == "Create"){
			MedicalCreateClient();
		}else if($("#medicalMode").val() == "Update"){
			MedicalUpdateClient();
		}
	});
	
	$("#popLayerMedicalCreatCansel").click(function(){
		$("#popLayerMedical").popup('hide');
	});
	
	// 의료비목록 등록
	$("#popLayerMedicalCreate").click(function(){
		$("#popLayerMedicalForm").each(function() {
			this.reset();
		});
		$("#medicalMode").val("Create");
		$("#popLayerMedical").popup('show');
	});
	
	// 의료비목록 수정
	$("#popLayerMedicalUpdate").click(function(){
		if( !$("input:radio[name='chk']").is(":checked")) {
			alert("수정 대상을 선택하세요.");
			return false;
		}
		$("#medicalMode").val("Update");
		$("#popLayerMedical").popup('show');
	});
	
	// 의료비목록 삭제
	
	$("#popLayerMedicalDelete").click(function(){
		if( !$("input:radio[name='chk']").is(":checked")) {
			alert("삭제 대상을 선택하세요.");
			return false;
		}
		MedicalDeleteClient();
	});
	
	$("#popLayerWriteBill").click(function(){
		if( !$("input:radio[name='chk']").is(":checked")) {
			alert("진료비입력 대상을 선택하세요.");
			return false;
		}
		if( $("#detailForm #RCPT_CODE_Check").val() != "0002" ){ /* 영수증 구분이 진료비계산서(0002) 가 아니면 에러 */
			alert("선택한 항목의 영수증은 진료비계산서가 아닙니다. \n\n  '영수증 구분'을 확인해 주세요");
			return false;
		}
		$("#popLayerBillWrite").popup('show');
		billDetail();
		BillWritemultiple_won();
	});
	
	var rowNumber = function(){
		var data = $("#MedicalListGrid").jsGrid("option", "data");
		$.each(data, function(i, item) {
			var $row = $("#MedicalListGrid").jsGrid("rowByItem", item);
			if($row.find('input[name="chk"]').is(":checked")) {
				$("#index").val($("#MedicalListGrid").jsGrid("option", "data").indexOf(item) + 1);
			}
		});
	}
	
	//진료비 계산서 입력
	$("#BillWriteBtn").click(function(){
		BillWritemultiple_won();
		BillWriteCreate();
	});
	
	$("#popLayerBillWriteCansel").click(function(){
		$("#popLayerBillWrite").popup('hide');
	});
	
	var BillWritemultiple_won = function () {
		var hap = 0;
		var gap1 = 0;
		var gap2 = 0;

		gap1 = Number(removeComma($("#BillWriteForm #TOTL_WONX").val())) -
			   Number(removeComma($("#BillWriteForm #ASSO_WONX").val()));
		
		gap2 = Number(removeComma($("#BillWriteForm #MEAL_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #APNT_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ROOM_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #CTXX_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #MRIX_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #SWAV_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC1_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC2_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC3_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC4_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC5_WONX").val()));

		hap = gap1 + gap2 - Number(removeComma($("#BillWriteForm #DISC_WONX").val()));
		
		if( gap1 >0 ) {
			$("#BillWriteForm #x_EMPL_WONX").val(gap1);
		}else{
			$("#BillWriteForm #x_EMPL_WONX").val("");
		}
		
		if( gap2 >0 ) {
			$("#BillWriteForm #EMPL_WONX_sub").val(gap2);
		}else{
			$("#BillWriteForm #EMPL_WONX_sub").val("");
		}
		if( hap >0 ) {
			$("#BillWriteForm #bill_EMPL_WONX_tot").val(hap);
		}else{
			 $("#BillWriteForm #bill_EMPL_WONX_tot").val("");
		}
		insertComma_setting_bill_data();
	}
	
	var insertComma_setting_bill_data = function (){
		$("#BillWriteForm #TOTL_WONX").val(insertComma($("#BillWriteForm #TOTL_WONX").val()));
		$("#BillWriteForm #ASSO_WONX").val(insertComma($("#BillWriteForm #ASSO_WONX").val()));
		$("#BillWriteForm #MEAL_WONX").val(insertComma($("#BillWriteForm #MEAL_WONX").val()));
		$("#BillWriteForm #x_EMPL_WONX").val(insertComma($("#BillWriteForm #x_EMPL_WONX").val()));
		$("#BillWriteForm #APNT_WONX").val(insertComma($("#BillWriteForm #APNT_WONX").val()));
		$("#BillWriteForm #ROOM_WONX").val(insertComma($("#BillWriteForm #ROOM_WONX").val()));
		$("#BillWriteForm #CTXX_WONX").val(insertComma($("#BillWriteForm #CTXX_WONX").val()));
		$("#BillWriteForm #MRIX_WONX").val(insertComma($("#BillWriteForm #MRIX_WONX").val()));
		$("#BillWriteForm #SWAV_WONX").val(insertComma($("#BillWriteForm #SWAV_WONX").val()));
		$("#BillWriteForm #ETC1_WONX").val(insertComma($("#BillWriteForm #ETC1_WONX").val()));
		$("#BillWriteForm #ETC1_TEXT").val($("#BillWriteForm #ETC1_TEXT").val());
		$("#BillWriteForm #ETC2_WONX").val(insertComma($("#BillWriteForm #ETC2_WONX").val()));
		$("#BillWriteForm #ETC2_TEXT").val($("#BillWriteForm #ETC2_TEXT").val());
		$("#BillWriteForm #ETC3_WONX").val(insertComma($("#BillWriteForm #ETC3_WONX").val()));
		$("#BillWriteForm #ETC3_TEXT").val($("#BillWriteForm #ETC3_TEXT").val());
		$("#BillWriteForm #ETC4_WONX").val(insertComma($("#BillWriteForm #ETC4_WONX").val()));
		$("#BillWriteForm #ETC4_TEXT").val($("#BillWriteForm #ETC4_TEXT").val());
		$("#BillWriteForm #ETC5_WONX").val(insertComma($("#BillWriteForm #ETC5_WONX").val()));
		$("#BillWriteForm #ETC5_TEXT").val($("#BillWriteForm #ETC5_TEXT").val());
		$("#BillWriteForm #DISC_WONX").val(insertComma($("#BillWriteForm #DISC_WONX").val()));
		$("#BillWriteForm #EMPL_WONX_sub").val(insertComma($("#BillWriteForm #EMPL_WONX_sub").val()));
		$("#BillWriteForm #bill_EMPL_WONX_tot").val(insertComma($("#BillWriteForm #bill_EMPL_WONX_tot").val()));
	}
	
	var MedicalCreateClient = function() {
		if(medicalPopCheck_data()){
			$("#MedicalListGrid").jsGrid( "insertItem", 
				{ "CHECK_ITEM": "", 
				  "MEDI_NAME": $('#popLayerMedicalForm #MEDI_NAME').val(), 
				  "MEDI_NUMB": $('#popLayerMedicalForm #MEDI_NUMB').val(), 
				  "TELX_NUMB": $('#popLayerMedicalForm #TELX_NUMB').val(), 
				  "EXAM_DATE": $('#popLayerMedicalForm #EXAM_DATE').val(), 
				  "MEDI_CODE": $('#popLayerMedicalForm #MEDI_CODE option:selected').val(),
				  "RCPT_CODE": $('#popLayerMedicalForm #RCPT_CODE option:selected').val(),
				  "MEDI_TEXT": $('#popLayerMedicalForm #MEDI_CODE option:selected').text(),
				  "RCPT_TEXT": $('#popLayerMedicalForm #RCPT_CODE option:selected').text(),
				  "MEDI_MTHD": $('#popLayerMedicalForm #MEDI_MTHD option:selected').val(),
				  "EMPL_WONX": $('#popLayerMedicalForm #EMPL_WONX').val(),
				  "TOTL_WONX": $('#BillWriteForm #TOTL_WONX').val(), 
				  "ASSO_WONX": $('#BillWriteForm #ASSO_WONX').val(), 
				  "x_EMPL_WONX": $('#BillWriteForm #x_EMPL_WONX').val(), 
				  "MEAL_WONX": $('#BillWriteForm #MEAL_WONX').val(), 
				  "APNT_WONX": $('#BillWriteForm #APNT_WONX').val(), 
				  "ROOM_WONX": $('#BillWriteForm #ROOM_WONX').val(), 
				  "CTXX_WONX": $('#BillWriteForm #CTXX_WONX').val(), 
				  "MRIX_WONX": $('#BillWriteForm #MRIX_WONX').val(), 
				  "SWAV_WONX": $('#BillWriteForm #SWAV_WONX').val(), 
				  "ETC1_WONX": $('#BillWriteForm #ETC1_WONX').val(), 
				  "ETC1_TEXT": $('#BillWriteForm #ETC1_TEXT').val(), 
				  "ETC2_WONX": $('#BillWriteForm #ETC2_WONX').val(), 
				  "ETC2_TEXT": $('#BillWriteForm #ETC2_TEXT').val(), 
				  "ETC3_WONX": $('#BillWriteForm #ETC3_WONX').val(), 
				  "ETC3_TEXT": $('#BillWriteForm #ETC3_TEXT').val(), 
				  "ETC4_WONX": $('#BillWriteForm #ETC4_WONX').val(), 
				  "ETC4_TEXT": $('#BillWriteForm #ETC4_TEXT').val(), 
				  "ETC5_WONX": $('#BillWriteForm #ETC5_WONX').val(), 
				  "ETC5_TEXT": $('#BillWriteForm #ETC5_TEXT').val(), 
				  "EMPL_WONX_sub": $('#BillWriteForm #EMPL_WONX_sub').val(),
				  "DISC_WONX": $('#BillWriteForm #DISC_WONX').val(),
				  "bill_EMPL_WONX_tot": $('#BillWriteForm #bill_EMPL_WONX_tot').val()
			  });
			 $("#popLayerMedicalForm").each(function(){
					this.reset();
				});
			 $("#BillWriteForm").each(function(){
					this.reset();
				});
		$("#popLayerMedical").popup('hide');
		}
	};
	
	var MedicalUpdateClient = function() {
		if(medicalPopCheck_data()){
			$("#MedicalListGrid").jsGrid( "updateItem",orgItem, 
				{ 
				  "MEDI_NAME": $('#popLayerMedicalForm #MEDI_NAME').val(), 
				  "MEDI_NUMB": $('#popLayerMedicalForm #MEDI_NUMB').val(), 
				  "TELX_NUMB": $('#popLayerMedicalForm #TELX_NUMB').val(), 
				  "EXAM_DATE": $('#popLayerMedicalForm #EXAM_DATE').val(), 
				  "MEDI_CODE": $('#popLayerMedicalForm #MEDI_CODE option:selected').val(),
				  "RCPT_CODE": $('#popLayerMedicalForm #RCPT_CODE option:selected').val(),
				  "MEDI_TEXT": $('#popLayerMedicalForm #MEDI_CODE option:selected').text(),
				  "RCPT_TEXT": $('#popLayerMedicalForm #RCPT_CODE option:selected').text(),
				  "MEDI_MTHD": $('#popLayerMedicalForm #MEDI_MTHD option:selected').val(),
				  "EMPL_WONX": $('#popLayerMedicalForm #EMPL_WONX').val()
				});
			$('#detailForm #EMPL_WONX').val($('#popLayerMedicalForm #EMPL_WONX').val());
			 $("#popLayerMedicalForm").each(function(){
					this.reset();
				});
			$("#popLayerMedical").popup('hide');
		}
	};
	
	var check_data = function () {
		//  배우자, 자녀일 경우 해당년도 회사지원총액이 300만원을 넘으면 에러처리함.(본인은 2000만원을 넘으면 에러처리함)
		//@V1.0 한도 500으로수정
		if( ($("#detailForm #GUEN_CODE").val() == "0002" && <%= !E_FLAG.equals("Y") %>) || $("#detailForm #GUEN_CODE").val() == "0003" ) {
			if( $("#totalWaersForm #COMP_sum").val() >= 5000000 ) {
				alert("해당년도 의료비 지원총액은 500만원입니다.");
				return false;
			}
		 } else if($("#detailForm #GUEN_CODE").val() == "0001" ) {
			if( $("#totalWaersForm #COMP_sum").val() >= 20000000 ) {
				alert("해당년도 의료비 지원총액은 2,000만원입니다.");
				return false;
			}
		 }
	//  상병명-30 입력시 길이 제한 
		if($("#detailForm #SICK_NAME").val() == "") {
			alert("상병명을 입력하세요.");
			 $("#detailForm #SICK_NAME").focus();
			return false;
		} else {
			if( $("#detailForm #SICK_NAME").val() != "" && checkLength($("#detailForm #SICK_NAME").val()) >30 ){
				alert("상병명은 한글 15자, 영문 30자 이내여야 합니다.");
				$("#detailForm #SICK_NAME").focus();
				$("#detailForm #SICK_NAME").select();
				return false;
			}
		}
	//[CSR ID:2589455] *(42) 제거 로직 추가----------------------------
		var tmpText="";
		for ( var i = 0; i < $("#detailForm #SICK_NAME").val().length; i++ ){
			if($("#detailForm #SICK_NAME").val().charCodeAt(i) != 42){
			  tmpText = tmpText+$("#detailForm #SICK_NAME").val().charAt(i);
		  }
		}
		$("#detailForm #SICK_NAME").val(tmpText);
	//-----------------------------------------------------------------

	//  구제적증상 필수입력
		textArea_to_TextFild($("#detailForm #SICK_DESC").val());
		if( $("#detailForm #SICK_DESC1").val() == "" && $("#detailForm #SICK_DESC2").val() == "" &&
			$("#detailForm #SICK_DESC3").val() == "" && $("#detailForm #SICK_DESC4").val() == "" ) {
			alert("구체적증상을 입력하세요.");
			$("#detailForm #SICK_DESC1").focus();
			return false;
		}
		/* 최초 진료시 본인부담액이 10만원 이하인 경우 Error처리함 */
		int_tt_wonx = Number($("#detailForm #EMPL_WONX_tot").val());
	
		if($("#detailForm #WAERS").val() == "KRW" ) {		 // 원화일경우만..
			l_ctrl_numb = $("#detailForm #CTRL_NUMB").val();
			if((l_ctrl_numb.substring(7,9) == "01") && (int_tt_wonx <= 100000) ){
				alert(" 최초 진료시 본인부담액이 10만원초과일 경우에 의료비 신청이 가능합니다. ");
				return false;
			}
		}
		
		var valid = true;
// 		var data = $("#MedicalListGrid").jsGrid("option", "data");
// 		$.each(data, function(i, $item) {
// 			if($item.RCPT_CODE =="0002" && i == $("#MedicalListGrid").jsGrid("option", "data").indexOf($item)){
// 				if(removeComma($item.EMPL_WONX) != $item.bill_EMPL_WONX_tot) {
// 					alert("진료계산서의 본인부담금액과 입력한 본인실납부액이 다릅니다. \n\n \"진료비계산서 입력\" 버튼을 눌러 다시한번 확인해 주세요");
// 					valid = false
// 				}else if($item.bill_EMPL_WONX_tot == 0 ||$item.bill_EMPL_WONX_tot == null) {
// 					alert(" \"진료비계산서\"가 입력되지 않았습니다.\n\n \"진료비계산서 입력\" 버튼을 눌러 \"진료비계산서\"를 입력해주세요");
// 					valid = false
// 				}
// 			}
// 		});
		return valid;
		setting_bill_data();
		$("#requestForm #EMPL_WONX_tot").val(removeComma($("#requestForm #EMPL_WONX_tot").val()));
		$("#popLayerMedicalForm #EMPL_WONX").val(removeComma($("#popLayerMedicalForm #EMPL_WONX").val()));
	};
	
	var medicalPopCheck_data = function () {
		/* 필수 입력값 .. 의료기관, 사업자등록번호, 진료일, 영수증 구분, 본인 실납부액 */
			   medi_name = $("#popLayerMedicalForm #MEDI_NAME").val();
			   medi_numb = removeResBar2($("#popLayerMedicalForm #MEDI_NUMB").val());
			   exam_date = removePoint($("#popLayerMedicalForm #EXAM_DATE").val());
			   empl_wonx = removeComma($("#popLayerMedicalForm #EMPL_WONX").val());
			if(medi_name != "" && medi_numb != "" && exam_date != "" && empl_wonx != ""){

//				  2002.05.10. 의료기관 길이 제한 - 20자
				   if( checkLength(medi_name) >20 ){
					   alert("의료기관명은 한글 10자, 영문 20자 이내여야 합니다.");
//						 eval("document.detailForm.radiobutton["+inx+"].checked = true;");
					   return false;
				   }
			   }else{
				   alert("\"의료기관\", \"사업자등록번호\", \"진료일\", \"본인 실납부액\"은 필수 항목입니다.\n\n 누락된 값을 입력해주세요");
//					 eval("document.detailForm.radiobutton["+inx+"].checked = true;");
				   if(medi_name == ""){
					$("#popLayerMedicalForm #MEDI_NAME").focus();
				   }else if(medi_numb == ""){
					$("#popLayerMedicalForm #MEDI_NUMB").focus();
				   }else if(exam_date == ""){
					$("#popLayerMedicalForm #EXAM_DATE").focus();
				   }else if(empl_wonx == ""){
					$("#popLayerMedicalForm #EMPL_WONX").focus();
				   }
				   return false;
			   }
	   //  진료일을 기준으로 3개월까지만 신청이 가능하도록 한다. 2002.05.02. 확인자:성경호, 수정자:김도신  -> 12개월(1년)까지로 수정 이동엽
	   //  마지막에 입력한 진료일에 대해서만 체크한다. 
			   begin_date = removePoint($("#detailForm #BEGDA").val());		   // 신청일..
			   betw = getAfterMonth(addSlash(exam_date), 12);
			   diff = dayDiff(addSlash(begin_date), addSlash(betw));
			   if(diff < 0) {  
					 alert('진료일을 기준으로 1년까지만 신청이 가능합니다.');
					 return false; 
			   }
			if(!check_busino()){
					return false;
				}
	   //  진료일을 기준으로 3개월까지만 신청이 가능하도록 한다. 2002.05.02. 확인자:성경호, 수정자:김도신
	   //  마지막에 입력한 진료일에 대해서만 체크한다.
	   $("#popLayerMedicalForm #EMPL_WONX").val(removeComma($("#popLayerMedicalForm #EMPL_WONX").val()));
		  return true;
	   };
	   
//사업자등록번호 체크 로직 추가 (2005.03.07)
	var checkDetail_busino= function(businoStr) {
		var sum = 0;
		var getlist =new Array(10);
		var chkvalue =new Array("1","3","7","1","3","7","1","3","5");
		
		for(var i=0; i<10; i++) { getlist[i] = businoStr.substring(i, i+1); }
		for(var i=0; i<9; i++) { sum += getlist[i]*chkvalue[i]; }
		sum = sum + parseInt((getlist[8]*5)/10);
		sidliy = sum % 10;
		sidchk = 0;
		if(sidliy != 0) { sidchk = 10 - sidliy; }
		else { sidchk = 0; }
		if(sidchk != getlist[9]) { 
//		alert("사업자등록번호가 유효하지 않습니다.");
			return false; 
		}
	return true;
	}
		
//사업자등록번호 포맷 (2005.03.07)
	var check_busino = function(){
		var tempStr="";
		valid_chk = true;
		
		t = $("#MEDI_NUMB").val();
		if(t.length == 10) {
			tempStr = t.substring(0,3) + t.substring(3,5) + t.substring(5,10);
		}else if(t.length == 12) {
			if( t.substring(3,4) != "-" || t.substring(6,7) != "-" ) {
			valid_chk = false;
			}
			tempStr = t.substring(0,3) + t.substring(4,6) + t.substring(7,12);
		} else {
		  tempStr = t;
		}

		if( (!checkDetail_busino(tempStr) && tempStr.length != 0) || (valid_chk == false) ) {
			alert("사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요.");
			$("#MEDI_NUMB").focus();
			$("#MEDI_NUMB").select();
			return false;
		// 사업자등록번호 "-"으로 구분 3자리-2자리-5자리
		}else{
			if( tempStr.length != 0 ) {
			tempStr = tempStr.substring(0,3) + "-" + tempStr.substring(3,5) + "-" + tempStr.substring(5,10);
			}
	}
	$("#MEDI_NUMB").val(tempStr);
		return true;
	}
	
	var textArea_to_TextFild = function (text) {
		for(var i = 1 ; i < 5 ; i++) {
			$("#detailForm #SICK_DESC"+i).val(""); 
		}
		var tmpText="";
		var tmplength = 0;
		var count = 1;
		var flag = true;
	    for ( var i = 0; i < text.length; i++ ){
			tmplength = checkLength(tmpText);
			if( (text.charCodeAt(i) != 13 && text.charCodeAt(i) != 10) && Number( tmplength ) < 60 ){
				tmpText = tmpText+text.charAt(i);
				flag = true
			} else {
				flag = false;
				tmpText.trim;
				$("#detailForm #SICK_DESC"+count).val(tmpText); 
				tmpText=text.charAt(i);
				count++;
				if( count > 4 ){
					break;
				}
			}
		}
		if( flag ) {
			$("#detailForm #SICK_DESC"+count).val(tmpText);
		}
	}
	
	var billDetailFirst = function (){
		var j =0;
		var data = $("#MedicalListGrid").jsGrid("option", "data");
		$.each(data, function(i, item) {
			if(item.RCPT_CODE=="0001"){
				j = j + 1;
				if(i == $("#MedicalListGrid").jsGrid("option", "data").indexOf(item)){
					jQuery.ajax({
						type : 'GET',
						url : '/appl/getMedicalBill.json',
						cache : false,
						dataType : 'json',
						data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>',
								"index" : j
								},
						async :false,
						success : function(response) {
							if(response.success){
								var storeData = response.storeData;
								item.TOTL_WONX = (storeData.TOTL_WONX == 0 ? "" : banolim(storeData.TOTL_WONX, 0));
								item.ASSO_WONX = (storeData.ASSO_WONX == 0 ? "" : banolim(storeData.ASSO_WONX, 0));
								item.x_EMPL_WONX = (storeData.EMPL_WONX == 0 ? "" : banolim(storeData.EMPL_WONX, 0));
								item.MEAL_WONX = (storeData.MEAL_WONX == 0 ? "" : banolim(storeData.MEAL_WONX, 0));
								item.APNT_WONX = (storeData.APNT_WONX == 0 ? "" : banolim(storeData.APNT_WONX, 0));
								item.ROOM_WONX = (storeData.ROOM_WONX == 0 ? "" : banolim(storeData.ROOM_WONX, 0));
								item.CTXX_WONX = (storeData.CTXX_WONX == 0 ? "" : banolim(storeData.CTXX_WONX, 0));
								item.MRIX_WONX = (storeData.MRIX_WONX == 0 ? "" : banolim(storeData.MRIX_WONX, 0));
								item.SWAV_WONX = (storeData.SWAV_WONX == 0 ? "" : banolim(storeData.SWAV_WONX, 0));
								item.ETC1_TEXT = storeData.ETC1_TEXT;
								item.ETC1_WONX = (storeData.ETC1_WONX == 0 ? "" : banolim(storeData.ETC1_WONX, 0));
								item.ETC2_TEXT = storeData.ETC2_TEXT;
								item.ETC2_WONX = (storeData.ETC2_WONX == 0 ? "" : banolim(storeData.ETC2_WONX, 0));
								item.ETC3_TEXT = storeData.ETC3_TEXT;
								item.ETC3_WONX = (storeData.ETC3_WONX == 0 ? "" : banolim(storeData.ETC3_WONX, 0));
								item.ETC4_TEXT = storeData.ETC4_TEXT;
								item.ETC4_WONX = (storeData.ETC4_WONX == 0 ? "" : banolim(storeData.ETC4_WONX, 0));
								item.ETC5_TEXT = storeData.ETC5_TEXT;
								item.ETC5_WONX = (storeData.ETC5_WONX == 0 ? "" : banolim(storeData.ETC5_WONX, 0));
								item.DISC_WONX = (storeData.DISC_WONX == 0 ? "" : banolim(storeData.DISC_WONX, 0));
								$("#MedicalListGrid").jsGrid( "updateItem",item, 
										{ "TOTL_WONX": item.TOTL_WONX,
										  "ASSO_WONX": item.ASSO_WONX,
										  "x_EMPL_WONX" : item.x_EMPL_WONX,
										  "MEAL_WONX": item.MEAL_WONX,
										  "APNT_WONX": item.APNT_WONX,
										  "ROOM_WONX": item.ROOM_WONX,
										  "CTXX_WONX": item.CTXX_WONX,
										  "MRIX_WONX": item.MRIX_WONX,
										  "SWAV_WONX": item.SWAV_WONX,
										  "ETC1_WONX": item.ETC1_WONX,
										  "ETC1_TEXT": item.ETC1_TEXT,
										  "ETC2_WONX": item.ETC2_WONX,
										  "ETC2_TEXT": item.ETC2_TEXT,
										  "ETC3_WONX": item.ETC3_WONX,
										  "ETC3_TEXT": item.ETC3_TEXT,
										  "ETC4_WONX": item.ETC4_WONX,
										  "ETC4_TEXT": item.ETC4_TEXT,
										  "ETC5_WONX": item.ETC5_WONX,
										  "ETC5_TEXT": item.ETC5_TEXT,
										  "DISC_WONX": item.DISC_WONX
										});
							}else{
								alert("조회시 오류가 발생하였습니다. " + response.message);
							}
						}
					});
				}
			}
		});
	}
				
	var billDetail = function (){
		var data = $("#MedicalListGrid").jsGrid("option", "data");
		$.each(data, function(i, item) {
			if($("#index").val()==$("#MedicalListGrid").jsGrid("option", "data").indexOf(item) + 1){
				$("#BillWriteForm #TOTL_WONX").val(item.TOTL_WONX);
				$("#BillWriteForm #ASSO_WONX").val(item.ASSO_WONX);
				$("#BillWriteForm #x_EMPL_WONX").val(item.x_EMPL_WONX);
				$("#BillWriteForm #MEAL_WONX").val(item.MEAL_WONX);
				$("#BillWriteForm #APNT_WONX").val(item.APNT_WONX);
				$("#BillWriteForm #ROOM_WONX").val(item.ROOM_WONX);
				$("#BillWriteForm #CTXX_WONX").val(item.CTXX_WONX);
				$("#BillWriteForm #MRIX_WONX").val(item.MRIX_WONX);
				$("#BillWriteForm #SWAV_WONX").val(item.SWAV_WONX);
				$("#BillWriteForm #ETC1_WONX").val(item.ETC1_WONX);
				$("#BillWriteForm #ETC1_TEXT").val(item.ETC1_TEXT);
				$("#BillWriteForm #ETC2_WONX").val(item.ETC2_WONX);
				$("#BillWriteForm #ETC2_TEXT").val(item.ETC2_TEXT);
				$("#BillWriteForm #ETC3_WONX").val(item.ETC3_WONX);
				$("#BillWriteForm #ETC3_TEXT").val(item.ETC3_TEXT);
				$("#BillWriteForm #ETC4_WONX").val(item.ETC4_WONX);
				$("#BillWriteForm #ETC4_TEXT").val(item.ETC4_TEXT);
				$("#BillWriteForm #ETC5_WONX").val(item.ETC5_WONX);
				$("#BillWriteForm #ETC5_TEXT").val(item.ETC5_TEXT);
				$('#BillWriteForm #EMPL_WONX_sub').val(item.EMPL_WONX_sub);
				$('#BillWriteForm #DISC_WONX').val(item.DISC_WONX);
				$('#BillWriteForm #bill_EMPL_WONX_tot').val(item.bill_EMPL_WONX_tot);
			}
		});
	}
	
	var BillWriteCreate = function (item){
		if(BillWritecheck_data()){
		 $("#MedicalListGrid").jsGrid( "updateItem",orgItem, 
					{ "TOTL_WONX": $('#BillWriteForm #TOTL_WONX').val(), 
					  "ASSO_WONX": $('#BillWriteForm #ASSO_WONX').val(), 
					  "x_EMPL_WONX": $('#BillWriteForm #x_EMPL_WONX').val(), 
					  "MEAL_WONX": $('#BillWriteForm #MEAL_WONX').val(), 
					  "APNT_WONX": $('#BillWriteForm #APNT_WONX').val(), 
					  "ROOM_WONX": $('#BillWriteForm #ROOM_WONX').val(), 
					  "CTXX_WONX": $('#BillWriteForm #CTXX_WONX').val(), 
					  "MRIX_WONX": $('#BillWriteForm #MRIX_WONX').val(), 
					  "SWAV_WONX": $('#BillWriteForm #SWAV_WONX').val(), 
					  "ETC1_WONX": $('#BillWriteForm #ETC1_WONX').val(), 
					  "ETC1_TEXT": $('#BillWriteForm #ETC1_TEXT').val(), 
					  "ETC2_WONX": $('#BillWriteForm #ETC2_WONX').val(), 
					  "ETC2_TEXT": $('#BillWriteForm #ETC2_TEXT').val(), 
					  "ETC3_WONX": $('#BillWriteForm #ETC3_WONX').val(), 
					  "ETC3_TEXT": $('#BillWriteForm #ETC3_TEXT').val(), 
					  "ETC4_WONX": $('#BillWriteForm #ETC4_WONX').val(), 
					  "ETC4_TEXT": $('#BillWriteForm #ETC4_TEXT').val(), 
					  "ETC5_WONX": $('#BillWriteForm #ETC5_WONX').val(), 
					  "ETC5_TEXT": $('#BillWriteForm #ETC5_TEXT').val(), 
					  "EMPL_WONX_sub": $('#BillWriteForm #EMPL_WONX_sub').val(),
					  "DISC_WONX": $('#BillWriteForm #DISC_WONX').val(),
					  "bill_EMPL_WONX_tot": $('#BillWriteForm #bill_EMPL_WONX_tot').val(),
					  "EMPL_WONX": $('#BillWriteForm #bill_EMPL_WONX_tot').val()
					});
		 $("#detailForm #EMPL_WONX").val($("#BillWriteForm #bill_EMPL_WONX_tot").val());
		 $("#BillWriteForm").each(function(){
				this.reset();
			});
		 $("#popLayerBillWrite").popup('hide');
		}
	};
	
	var MedicalDeleteClient = function() {
		$("#MedicalListGrid").jsGrid( "deleteItem", orgItem);
	};
	
	var BillWritecheck_data = function () {
//		if(document.detailForm.x_EMPL_WONX.value == ""){
//			alert("본인부담금①이 계산되지 않았습니다.\n\n해당 항목에 금액을 입력해 주세요");
//			return false;
//		}
		gap1 = Number(removeComma($("#BillWriteForm #TOTL_WONX").val())) -
			   Number(removeComma($("#BillWriteForm #ASSO_WONX").val())) ;
		if(gap1 < 0){
			alert("조합부담금이 총 진료비를 초과할수 없습니다. 다시 입력해 주세요.");
			$("#BillWriteForm #TOTL_WONX").focus();
			return false;
		}
		if( ($("#BillWriteForm #ETC1_WONX").val() != "" && $("#BillWriteForm #ETC1_TEXT").val() == "") || 
			($("#BillWriteForm #ETC2_WONX").val() != "" && $("#BillWriteForm #ETC2_TEXT").val() == "") || 
			($("#BillWriteForm #ETC3_WONX").val() != "" && $("#BillWriteForm #ETC3_TEXT").val() == "") || 
			($("#BillWriteForm #ETC4_WONX").val() != "" && $("#BillWriteForm #ETC4_TEXT").val() == "") || 
			($("#BillWriteForm #ETC5_WONX").val() != "" && $("#BillWriteForm #ETC5_TEXT").val() == "") ){
			
			alert("'보험비급여' 항목의 금액에 대한 항목 설명이 빠져있습니다.");
			return false;
		}
		
		setting_bill_data();
		return true;
	}
	
	var setting_bill_data = function (){
		$("#BillWriteForm #TOTL_WONX").val(removeComma($("#BillWriteForm #TOTL_WONX").val()));
		$("#BillWriteForm #ASSO_WONX").val(removeComma($("#BillWriteForm #ASSO_WONX").val()));
		$("#BillWriteForm #x_EMPL_WONX").val(removeComma($("#BillWriteForm #x_EMPL_WONX").val()));
		$("#BillWriteForm #MEAL_WONX").val(removeComma($("#BillWriteForm #MEAL_WONX").val()));
		$("#BillWriteForm #APNT_WONX").val(removeComma($("#BillWriteForm #APNT_WONX").val()));
		$("#BillWriteForm #ROOM_WONX").val(removeComma($("#BillWriteForm #ROOM_WONX").val()));
		$("#BillWriteForm #CTXX_WONX").val(removeComma($("#BillWriteForm #CTXX_WONX").val()));
		$("#BillWriteForm #MRIX_WONX").val(removeComma($("#BillWriteForm #MRIX_WONX").val()));
		$("#BillWriteForm #SWAV_WONX").val(removeComma($("#BillWriteForm #SWAV_WONX").val()));
		$("#BillWriteForm #ETC1_WONX").val(removeComma($("#BillWriteForm #ETC1_WONX").val()));
		$("#BillWriteForm #ETC1_TEXT").val(removeComma($("#BillWriteForm #ETC1_TEXT").val()));
		$("#BillWriteForm #ETC2_WONX").val(removeComma($("#BillWriteForm #ETC2_WONX").val()));
		$("#BillWriteForm #ETC2_TEXT").val(removeComma($("#BillWriteForm #ETC2_TEXT").val()));
		$("#BillWriteForm #ETC3_WONX").val(removeComma($("#BillWriteForm #ETC3_WONX").val()));
		$("#BillWriteForm #ETC3_TEXT").val(removeComma($("#BillWriteForm #ETC3_TEXT").val()));
		$("#BillWriteForm #ETC4_WONX").val(removeComma($("#BillWriteForm #ETC4_WONX").val()));
		$("#BillWriteForm #ETC4_TEXT").val(removeComma($("#BillWriteForm #ETC4_TEXT").val()));
		$("#BillWriteForm #ETC5_WONX").val(removeComma($("#BillWriteForm #ETC5_WONX").val()));
		$("#BillWriteForm #ETC5_TEXT").val(removeComma($("#BillWriteForm #ETC5_TEXT").val()));
		$("#BillWriteForm #DISC_WONX").val(removeComma($("#BillWriteForm #DISC_WONX").val()));
		$("#BillWriteForm #EMPL_WONX_sub").val(removeComma($("#BillWriteForm #EMPL_WONX_sub").val()));
		$("#BillWriteForm #bill_EMPL_WONX_tot").val(removeComma($("#BillWriteForm #bill_EMPL_WONX_tot").val()));
	}
</script>
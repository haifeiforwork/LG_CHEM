<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.A.A04FamilyDetailData"%>
<%@ page import="hris.common.rfc.CurrencyCodeRFC"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E22Expense.E22ExpenseListData"%>
<%@ page import="hris.E.E21Expense.E21ExpenseChkData"%>
<%@ page import="hris.E.E21Entrance.E21EntranceDupCheckData"%>
<%@ page import="hris.common.WebUserData"%>
<!--// Page Title start -->
<div class="title">
	<h1>장학자금</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">장학자금</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
<!--------------- layout body start --------------->
	<!--// list start -->
	
	<div class="listArea">
		<h2 class="subtitle withButtons">장학자금.유치원비 지원내역</h2>
		<div class="clear"></div>
		<div id="scholarshipListGrid" class="jsGridPaging"/>
	</div>
	<!--// list end -->
	
	<!--// Table start -->
	<div class="tableArea">	
		<h2 class="subtitle">장학자금.유치원비 상세내역</h2>	
		<div class="table">
			<form id="ListForm">
			<table class="tableGeneral" id="scholarshipTB">
			<caption>장학자금 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th>지급일</th>
				<td colspan="3" name="PAID_DATE"></td>
			</tr>
			<tr>
				<th>가족선택</th>
				<td colspan="3" name="FAMSA" addValue="ATEXT" addformat="blank"></td>
			</tr>			
			<tr>
				<th>지급유형</th>
				<td name="STEXT"></td>
				<th>신청년도</th>
				<td name="PROP_YEAR"></td>
			</tr>
			<tr>
				<th>지급구분</th>
				<td id="DETAIL_PAY_TYPE"></td>
				<th>신청분기ㆍ학기</th>
				<td id="detailType"></td>
			</tr>
			<tr>
				<th>이름</th>
				<td colspan="3" name="LNMHG" addValue="FNMHG"></td>
			</tr>
			<tr>
				<th><label for="detailAcadCare">학력</label></th>
				<td colspan="3" name="ACAD_CARE" addValue="TEXT4" addformat="blank"></td>
			</tr>
			<tr>
				<th>교육기관</th>
				<td name="FASIN"></td>
				<th>학년</th>
				<td name="ACAD_YEAR"></td>
			</tr>
			<tr>
				<th>신청액</th>
				<td>
					<label name="PROP_AMNT" addValue="WAERS" addformat="blank" format="currency"></label>
					<a class="inlineBtn" href="#" id="detailBillBtn"><span>등록금 고지서</span></a>
				</td>
				<th>수혜횟수</th>
				<td name="P_COUNT" format="currency"></td>
			</tr>
			<tr>
				<th>입학금</th>
				<td colspan="3"><input type="radio" class="checkbox" name="ENTR_FIAG" value="X" disabled></td>
			</tr>
			<tr>
				<th>회사지급액</th>
				<td colspan="3" name="PAID_AMNT" addValue="WAERS" addformat="blank" format="currency"></td>
			</tr>
			<tr>
				<th>연말정산반영액</th>
				<td colspan="3" name="YTAX_WONX" addValue="WAERS" addformat="blank" format="currency"></td>
			</tr>
			<tr>
				<th>반납일자</th>
				<td name="RFUN_DATE"></td>
				<th>반납액</th>
				<td name="RFUN_AMNT" addValue="WAERS" addformat="blank" format="emptyCur"></td>
			</tr>
			<tr>
				<th>반납사유</th>
				<td colspan="3" name="RFUN_RESN"></td>
			</tr>
			<tr>
				<th>비고</th>
				<td colspan="3" name="BIGO_TEXT1" addValue="BIGO_TEXT2" addformat="enter"></td>
			</tr>
			</tbody>
			</table>
			<table class="tableGeneral" id="kindergartenTB" style="display:none;">
			<caption>유치원비 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th>신청일</th>
				<td colspan="3" name="PAID_DATE"></td>
			</tr>
			<tr>
				<th>가족선택</th>
				<td colspan="3" name="FAMSA" addValue="ATEXT" addformat="blank"></td>	
			</tr>
			<tr>
				<th>지급유형</th>
				<td colspan="3" name="STEXT"></td>
			</tr>
			<tr>
				<th>이름</th>
				<td colspan="3" name="LNMHG" addValue="FNMHG"></td>
			</tr>
			<tr>
				<th>학력</th>
				<td colspan="3" name="ACAD_CARE" addValue="TEXT4" addformat="blank"></td>
			</tr>
			<tr class="kinderTr">
				<th>유치원비</th>
				<td colspan="3">
					<label name="PROP_AMNT" addValue="WAERS" addformat="blank" format="currency"></label>
					<label id="reqMNTH"></label>
					<table class="innerTable mt5">
						<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<th>1개월</th>
							<td class="alignRight" name="PROP_AMT1" format="currency"></td>
							<th>2개월</th>
							<td class="alignRight" name="PROP_AMT2" format="currency"></td>
							<th>3개월</th>
							<td class="alignRight" name="PROP_AMT3" format="currency"></td>
						</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr class="kinderTr">
				<th>시작일</th>
				<td colspan="3" name="REQU_DATE"></td>
			</tr>
			<tr>
				<th>회사지급액</th>
				<td colspan="3">
					<label name="PAID_AMNT" addValue="WAERS1" addformat="blank" format="currency"></label>
					<table class="innerTable mt5 kinderTr">
						<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<th>1개월</th>
							<td class="alignRight" name="PAID_AMT1" format="currency"></td>
							<th>2개월</th>
							<td class="alignRight" name="PAID_AMT2" format="currency"></td>
							<th>3개월</th>
							<td class="alignRight" name="PAID_AMT3" format="currency"></td>
						</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th><label for="detailBigoText1">비고</label></th>
				<td colspan="3" name="BIGO_TEXT1" addValue="BIGO_TEXT2" addformat="enter"></td>
			</tr>
			</tbody>
			</table>
			</form>
		</div>
	</div>
	<!--// Table end -->
<!--------------- layout body end --------------->

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
					<caption>등록금 고지서</caption>
					<colgroup>
						<col class="col_40p" />
						<col class="col_60p" />
					</colgroup>
					<tbody>
						<tr>
							<th><label for="popupRegiFee">등록금(수업료)</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupRegiFee" name="REGI_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><label for="popupSchoFee">장학금</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupSchoFee" name="SCHO_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><label for="popupMrmbFee">학생회비</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupMrmbFee" name="MRMB_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><label for="popupMembFee">기성회비</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupMembFee" name="MEMB_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><label for="popupEntrFee">입학금</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupEntrFee" name="ENTR_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
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
			<div class="buttonArea buttonCenter" id="popupBtnDiv">
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



<script type="text/javascript">
	$(document).ready(function(){
		$("#scholarshipListGrid").jsGrid("search");
	
	});
	
	
	// 등록금 고지서 팝업 호출
	$("#requestBillBtn").click(function(){
		$("#popLayerBill").popup("show");
	});
	
	// 등록금 고지서 팝업 호출
	$("#detailBillBtn").click(function(){
		$("#popupRegiFee").addClass("readOnly").prop("readOnly",true);
		$("#popupSchoFee").addClass("readOnly").prop("readOnly",true);
		$("#popupMrmbFee").addClass("readOnly").prop("readOnly",true);
		$("#popupMembFee").addClass("readOnly").prop("readOnly",true);
		$("#popupEntrFee").addClass("readOnly").prop("readOnly",true);
		$("#popupInsertFeeBtn").hide();
		$("#popupCanselBtn").hide();
		
		$("#popLayerBill").popup("show");
	});

	// 장학금,유치원비 지원 내역 grid
	$(function() {
		$("#scholarshipListGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: true,
			autoload: true,
			pageSize: 10,
			pageButtonCount: 10,
			rowClick: function(args){
			},
			controller: {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "get",
						url : "/manager/supp/getScholarshipList.json",
						dataType : "json",
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
					title: "선택", name: "th1", align: "center", width: "8%"
					,itemTemplate: function(_, item) {
						return	$("<input name='chk'>")
								.attr("type", "radio")
								.on("click",function(e){
									if( (item.SUBF_TYPE != "1") && (item.SUBF_TYPE != "4") ){  // 2, 3
										$("#scholarshipTB").show();
										$("#kindergartenTB").hide();
										setTableText(item, "scholarshipTB");
										$("#detailType").html(item.SUBF_TYPE == "2" ? (item.PERD_TYPE == "0" ? "" : item.PERD_TYPE + " 분기") : (item.HALF_TYPE == "0" ? "" : item.HALF_TYPE + " 학기"));
										$("#DETAIL_PAY_TYPE").text("신규분");
										if(item.PAY2_TYPE=="X"){
											$("#DETAIL_PAY_TYPE").text("추가분");
										}
									}else{  // 1, 4

										$("#scholarshipTB").hide();
										$("#kindergartenTB").show();
										
										setTableText(item, "kindergartenTB");
										if(item.SUBF_TYPE == "4") {
											$(".kinderTr").show();
											$("#reqMNTH").text("[ " + Number(item.REQU_MNTH) + "개월 ]");
										} else {
											$(".kinderTr").hide();
										}
									}
									
									setTableText(item, "popupBillForm");
									popupTotalSumCalc();
									
								});
					}
				},
				{	title: "신청일", name: "BEGDA", type: "text", align: "center", width: "10%" 
					,itemTemplate : function(value, item){
						return value == "0000.00.00" ? "과거수혜이력" : value;
					}
				},
				{	title: "지급유형", name: "STEXT", type: "text", align: "center", width: "12%" },
				{	title: "지급구분", name: "PAY1_TYPE", type: "text", align: "center", width: "14%" 
					,itemTemplate : function(value,item){
						if(item.SUBF_TYPE!="1" || item.SUBF_TYPE!="4"){
							var val = "신규분";
							if(item.PAY2_TYPE=="X") val = "추가분";
							return val;
						}
					}
				},
				{	title: "성명", name: "LNMHG", type: "text", align: "center", width: "13%" 
					,itemTemplate : function(value,item){
						return value + item.FNMHG;
					}
				},
				{	title: "신청액", name: "SUBF_TYPE", type: "text", align: "right", width: "15%" 
					,itemTemplate : function(value,item){
						if(value =="1"){
							return "";
						}else{
							if(item.PROP_AMNT == "0"){
								return "";
							}else{
								return parseInt(item.PROP_AMNT).format() + " <font color='#0000FF'>" + item.WAERS + "</font>";
							}
						}
					}
				},
				{	title: "회사지급액", name: "PAID_AMNT", type: "number", align: "right", width: "15%" 
					,itemTemplate : function(value,item){
						if(value =="0"){
							return "";
						}else{
							return parseInt(value).format() + " <font color='#0000FF'>" + item.WAERS1 + "</font>";
						}
						
					}
				},
				{	title: "최종결재일", name: "POST_DATE", type: "text", align: "center", width: "13%" 
					,itemTemplate : function(value, item){
						return value == "0000.00.00" ? "" : value;
					}
				}
			]
		});
	});
</script>



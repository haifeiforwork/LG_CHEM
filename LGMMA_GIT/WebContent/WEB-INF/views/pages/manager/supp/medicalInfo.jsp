<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>
<%@ page import="hris.E.E17Hospital.rfc.E17GuenCodeRFC" %>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.SortUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%
WebUserData 	user					= (WebUserData)session.getValue("managedUser");
E17SickData 	e17SickData     		= (E17SickData)request.getAttribute("e17SickData");
Vector      	E17ChildData_vt 		= (Vector)request.getAttribute("E17ChildData_vt");
Vector      	MediCode_vt     		= (Vector)request.getAttribute("MediCode_vt");
E17HospitalData e17HospitalData_vt  	= (E17HospitalData)request.getAttribute("e17HospitalData_vt");
E17BillData 	e17BillData 			= (E17BillData)request.getAttribute("e17BillData");

E17MedicCheckYNRFC checkYN 				= new E17MedicCheckYNRFC();
String             E_FLAG  				= checkYN.getE_FLAG( DataUtil.getCurrentYear(), user.empNo );
// String      radio_index        = (String)request.getAttribute("radio_index");

//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
    	CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
    	if( e17SickData.WAERS == codeEnt.code ){
    		currencyDecimalSize = Double.parseDouble(codeEnt.value);
    	}
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다

%>
<!--// Page Title start -->
<div class="title">
	<h1>의료비</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">의료비</a></span></li>
		</ul>						
	</div>
</div>
<!--// Page Title end -->
<!--------------- layout body start --------------->				
				<!--// Tab2 start -->
				<div class="tabUnder tab2">	
				<form id ="MedicalListForm" name="MedicalListForm">
					<!--// list start -->
					<div class="listArea">		
						<h2 class="subtitle withButtons">의료비 지원내역</h2>
						<div class="clear"></div>
						<div id="medicalListGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
					</div>	
					<!--// list end -->		
					<!----------------------- 상세내역 start ----------------------->
					<!--// Table start -->	
					<div class="tableArea">	
						<h2 class="subtitle">의료비 지원 상세내역</h2>	
						<div class="table">
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
								<th><label for="inputText03-1">관리번호</label></th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" name="CTRL_NUMB" value="" id="CTRL_NUMB" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-2">구분</label></th>
								<td colspan="3">
									<input class="readOnly w150" type="text" name="GUEN_NAME" value="" id="GUEN_NAME" readonly />
									<input type="checkbox" id="PROOF" name="PROOF" value="X" size="20" class="input03" disabled><span id="PROOFNAME">배우자 연말정산반영여부</span>                         
                            </tr>
                            <tr id="child">
			                  <th><label for="inputText03-2">자녀이름</label></th>
			                  <td class="td02" colspan="3">
			                    <input class="readOnly w150" type="text" name="ENAME" value="" id="ENAME" readonly />
			                    <input class="readOnly w150" type="text" name="REGNO_dis" value="" id="REGNO_dis" readonly />
			                  </td>
			                </tr>
                            <tr>
								<th><label for="inputText03-3">상병명</label></th>
								<td colspan="3">
									<input class="readOnly w150" type="text" name="SICK_NAME" value="" id="SICK_NAME" readonly />									
								</td>
							</tr>													
							<tr>
								<th><label for="inputText03-4">구체적증상</label></th>
								<td colspan="3">
									<textarea class="readOnly wPer" name="SICK_DESC" id="SICK_DESC" rows="" readonly></textarea>			
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-5">비고</label></th>
								<td colspan="3">
									<input class="readOnly wPer" type="text" name="BIGO_TEXT1" value="" id="BIGO_TEXT1" readonly />
								</td>
							</tr>
							<tr> 
			                  <th><label for="inputText03-5"></label></th>
								<td colspan="3">
			                    <input class="readOnly wPer" type="text" name="BIGO_TEXT2" value="" id="BIGO_TEXT2" readonly />
			                  </td>
			                </tr>
							<tr>
								<th><label for="inputText03-6">반납일자</label></th>
								<td>
									<input class="readOnly w100" type="text" name="RFUN_DATE" value="" id="RFUN_AMNT" readonly />					
								</td>
								<th><label for="inputText03-7">반납액</label></th>
								<td>
									<input class="inputMoney readOnly w100" type="text" name="RFUN_AMNT" value="" id="RFUN_AMNT" readonly />					
								</td>
							</tr>														
							<tr>
								<th><label for="inputText03-8">반납사유</label></th>
								<td colspan="3">
                                    <input class="readOnly wPer" type="text" name="RFUN_RESN" value="" id="RFUN_RESN" readonly />  		
                                </td>
							</tr>					
							</tbody>
							</table>
						</div>	
					</div>	
				</form>
					<!--// list start -->
					<!-- 진료비계산서 조회 클릭시 팝업레이어 popupLayer.html '진료비 계산서 조회' -->
					<div class="listArea">		
						<h2 class="subtitle withButtons">진료비 계산서 조회</h2>
						<div class="buttonArea">
							<ul class="btn_mdl">
<!-- 								<li><a href="#" id="billDetailBtn"><span>조회</span></a></li> -->
							</ul>
						</div>
						<div class="clear"></div>
						<div id="medicalDetailGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>		
					</div>	
					<!--// list end -->	
					<div class="tableArea">	
						<form id="totalWaers" name="totalWaers">
							<h2 class="subtitle">의료비 총액</h2>	
							<div class="table">
								<table class="tableGeneral">
								<caption>의료비 총액</caption>
								<colgroup>
									<col class="col_15p"/>
									<col class="col_35p"/>
									<col class="col_15p"/>
									<col class="col_35p"/>
								</colgroup>
								<tbody>
								<tr>
									<th><label for="inputText03-1">회사지원총액</label></th>
									<td>
										<input class="inputMoney readOnly w100" type="text" name="COMP_sum" value="" id="COMP_sum" readonly /> 
									</td>
									<th><label for="inputText03-1">계</label></th>
									<td>
										<input class="inputMoney readOnly w100" type="text" name="EMPL_WONX" value="" id="EMPL_WONX" readonly /> 
									</td>
								</tr>
								<tr>
									<th><label for="inputText03-1">연말정산반영액</label></th>
									<td>
										<input class="inputMoney readOnly w100" type="text" name="YTAX_WONX" value="" id="YTAX_WONX" readonly /> 
									</td>
									<th><label for="inputText03-1">회사지원액</label></th>
									<td>
										<input class="inputMoney readOnly w100" type="text" name="COMP_WONX" value="" id="COMP_WONX" readonly /> 
									</td>
								</tr>			
								</tbody>
								</table>
							</div>	
						</form>
					</div>	
					<!--// Table end -->
					<form id="MedicalDetailForm" name = "MedicalDetailForm">
							<input type="hidden" name="CTRL_NUMB"  id="CTRL_NUMB"  value="">
							<input type="hidden" name="GUEN_CODE"  id="GUEN_CODE"  value="">
							<input type="hidden" name="PROOF"      id="PROOF"      value="">
							<input type="hidden" name="SICK_NAME"  id="SICK_NAME"  value="">
							<input type="hidden" name="SICK_DESC1" id="SICK_DESC1" value="">
							<input type="hidden" name="SICK_DESC2" id="SICK_DESC2" value="">
							<input type="hidden" name="SICK_DESC3" id="SICK_DESC3" value="">
							<input type="hidden" name="EMPL_WONX"  id="EMPL_WONX"  value="">
							<input type="hidden" name="COMP_WONX"  id="COMP_WONX"  value="">
							<input type="hidden" name="YTAX_WONX"  id="YTAX_WONX"  value="">
							<input type="hidden" name="BIGO_TEXT1" id="BIGO_TEXT1" value="">
							<input type="hidden" name="BIGO_TEXT2" id="BIGO_TEXT2" value="">
							<input type="hidden" name="WAERS"      id="WAERS"      value="">
							<input type="hidden" name="RFUN_DATE"  id="RFUN_DATE"  value="">
							<input type="hidden" name="RFUN_RESN"  id="RFUN_RESN"  value="">
							<input type="hidden" name="RFUN_AMNT"  id="RFUN_AMNT"  value="">
							<input type="hidden" name="ENAME"      id="ENAME"      value="">
							<input type="hidden" name="OBJPS_21"   id="OBJPS_21"   value="">
							<input type="hidden" name="REGNO_21"   id="REGNO_21"   value="">
						</form>
						<form id="form2" name="form2">
						<!-----   hidden field ---------->
						  <input type="hidden" name="CTRL_NUMB" id="CTRL_NUMB" value="">
						  <input type="hidden" name="GUEN_CODE" id="GUEN_CODE" value="">
						  <input type="hidden" name="OBJPS_21"  id="OBJPS_21"  value="">
						  <input type="hidden" name="REGNO_21"  id="REGNO_21"  value="">
						  <input type="hidden" name="PROOF"     id="PROOF"     value="">
						  <input type="hidden" name="RCPT_NUMB" id="RCPT_NUMB" value="">
						  <input type="hidden" name="RCPT_CODE" id="RCPT_CODE" value="">
						<!--  HIDDEN  처리해야할 부분 끝-->
						</form>
						<form id="form3"name="form3" method="post">
						    <input type="hidden" name="CTRL_YEAR" id="CTRL_YEAR" value="">
						    <input type="hidden" name="GUEN_CODE" id="GUEN_CODE" value="">
						    <input type="hidden" name="OBJPS_21"  id="OBJPS_21"  value="">
						    <input type="hidden" name="REGNO_21"  id="REGNO_21"  value="">
						    <input type="hidden" name="jobChk"    id="jobChk"    value="Detail">
						</form>
				</div>
				<!--// Tab2 end -->		
				<!--------------- layout body end --------------->						
			
			</div>
			<!-- innerContent end -->
		</div>
		<!--// contents end -->		
	</div>
	<!--// container end -->
</div>
<!-- //wrapper end -->

<!-- popup : 진료비 계산서 조회 start -->
<div class="layerWrapper layerSizeS" id="popLayerBillDetail">
	<div class="layerHeader">
		<strong>진료비 계산서 조회</strong>
		<a href="#" class="btnClose popLayerBillDetail_close">창닫기</a>
	</div>
	<div class="layerContainer">
	<form id="billDetail" name="billDetail">
			<div class="layerContent">			
				<!--// Content start  -->
				<div class="layerScroll">
					<div class="tableArea tablePopup">
						<h2 class="subtitle">보험급여</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>보험급여</caption>
							<colgroup>
								<col class="col_40p" />
								<col class="col_60p" />
							</colgroup>
							<tbody>
								<tr>
									<th>총 진료비</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="TOTL_WONX" id="TOTL_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th>조합부담금</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ASSO_WONX" id="ASSO_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th>본인부담금①</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="EMPL_WONX" id="EMPL_WONX" value="" readonly>
                                	</td>
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
								<col class="col_40p" />
								<col class="col_60p" />
							</colgroup>
							<tbody>
								<tr>
									<th>식대</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="MEAL_WONX" id="MEAL_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th>지정진료비</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="APNT_WONX" id="APNT_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th>입원료</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ROOM_WONX" id="ROOM_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th>CT</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="CTXX_WONX" id="CTXX_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th>MRI</th>
									<<td>
										<input class="inputMoney w120 readOnly" type="text" name="MRIX_WONX" id="MRIX_WONX" value="" readonly>
                               		</td>
								</tr>
								<tr>
									<th>초음파</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="SWAV_WONX" id="SWAV_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC1_TEXT_th" id="ETC1_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC1_WONX" id="ETC1_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC2_TEXT_th" id="ETC2_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC2_WONX" id="ETC2_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC3_TEXT_th" id="ETC3_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC3_WONX" id="ETC3_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC4_TEXT_th" id="ETC4_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC4_WONX" id="ETC4_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC5_TEXT_th" id="ETC5_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC5_WONX" id="ETC5_WONX" value="" readonly>
                                	</td>
								</tr>
								<tr>
									<th>소 계②</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="CNT1_WONX" id="CNT1_WONX" value="" readonly>
                                	</td>
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
								<col class="col_40p" />
								<col class="col_60p" />
							</colgroup>
							<tbody>
								<tr>
									<th>할인금액③</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="DISC_WONX" id="DISC_WONX" value="" readonly>
                                	</td>
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
								<col class="col_40p" />
								<col class="col_60p" />
							</colgroup>
							<tbody>
								<tr>
									<th>① + ② - ③</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="CNT2_WONX" id="CNT2_WONX" value="" readonly>
                                	</td>
								</tr>										
							</tbody>
							</table>
						</div>
					</div>
				</div>
				<!--// Content end  -->							
			</div>	
		</form>	
	</div>		
</div>
<!-- //popup : 진료비 계산서 조회 end -->	
<!-- 프린트 영역 팝업-->		
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>진료비게산서</strong>
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
	<div class="clear"> </div>	
</div>


<!-- // script -->
<script type="text/javascript">
var orgItem;
	$(function(){
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=03&gridDivId=decisionerGrid');
    	$("#printPopBillWriteBtn").click(function() {
    		$("#printContentsArea").print();
    	});
		
       	$("#BillPrintBtn").click(function(){
        	$("#billWritePopup").attr("src","/manager/supp/medicalPrint/before/");// + year + "?BEGDA=" + begda
    		$("#billWritePopup").load(function(){
    			$('#popLayerPrint').popup("show");
    		});
    	});
	});
	$(document).ready(function(){
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=03&gridDivId=decisionerGrid');
		if($(".layerWrapper").length){
			$('#popLayerMedical').popup();
			$("#MedicalListForm #PROOF").hide();
			$("#child").hide();
			$("#requestForm #Message").hide();
			$("#MedicalListForm #PROOF").hide();
			$("#MedicalListForm #PROOFNAME").hide();
			medicalDetailGrid();
		};
		
		$("#tab2").click(function(){
			$("#MedicalListForm #PROOF").hide();
			$("#medicalListGrid").jsGrid("search");
			medicalDetailGrid();
		});
		
		$("#popLayerMedicalCreatCansel").click(function(){
			$("#popLayerMedical").popup('hide');
		});
		
		$("#billDetailBtn").click(function(){
			if( !$("input:radio[name='chkBill']").is(":checked")) {
				alert("진료비 계산서 조회 대상을 선택하세요.");
				return false;
			}
			if( $("#form2 #RCPT_CODE").val() != "0002" ){ /* 영수증 구분이 진료비계산서(0002) 가 아니면 에러 */
				alert("선택한 항목의 영수증은 진료비계산서가 아닙니다. \n\n  '영수증 구분'을 확인해 주세요");
				return false;
			}
			billDetail();
			$("#popLayerBillDetail").popup('show');
		});
		$("#requestMedicalBtn").click(function(){
			requestMedical();
		});
		
	});
	
	var requestPrint = function(){
		
		var AINF_SEQN = $("#requestForm #AINF_SEQN").val();
    	$("#billWritePopup").attr("src","/manager/supp/medicalPrint/requestPrint/?AINF_SEQN="+AINF_SEQN);
		$("#billWritePopup").load(function(){
			$('#popLayerPrint').popup("show");
		});
	};
	
    $(function() {
        $("#medicalListGrid").jsGrid({
        	height: "auto",
            width: "100%",
            sorting: true,
            paging: true,
            pageSize: 10,
            pageButtonCount: 10,
			autoload: true,
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/manager/supp/getMedicalList.json",
   						dataType : "json"
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
	           			title: "선택",
	           			name: "th1",
	           			itemTemplate: function(value, storeData) {
	                         return $("<input name='chk' id='chk' >")
	                           .attr("type", "radio")
	     					  .on("click", function(e) {
	           						$("#MedicalDetailForm #CTRL_NUMB").val(storeData.CTRL_NUMB);
									$("#MedicalDetailForm #GUEN_CODE").val(storeData.GUEN_CODE);
									$("#GUEN_NAME").val(storeData.GUEN_CODE == "0001" ? "본인" : storeData.GUEN_CODE == "0002" ? "배우자" : "자녀");
									$("#MedicalDetailForm #PROOF").val(storeData.PROOF);
									$("#MedicalDetailForm #SICK_NAME").val(storeData.SICK_NAME);
									$("#MedicalDetailForm #SICK_DESC1").val(storeData.SICK_DESC1);
									$("#MedicalDetailForm #SICK_DESC2").val(storeData.SICK_DESC2);
									$("#MedicalDetailForm #SICK_DESC3").val(storeData.SICK_DESC3);
									$("#MedicalDetailForm #EMPL_WONX").val(storeData.EMPL_WONX);
									$("#MedicalDetailForm #COMP_WONX").val(storeData.COMP_WONX); 
						     		$("#MedicalDetailForm #YTAX_WONX").val(storeData.YTAX_WONX); 
						     		$("#MedicalDetailForm #BIGO_TEXT1").val(storeData.BIGO_TEXT1); 
						     		$("#MedicalDetailForm #BIGO_TEXT2").val(storeData.BIGO_TEXT2); 
						     		$("#MedicalDetailForm #WAERS").val(storeData.WAERS); 
						     		$("#MedicalDetailForm #RFUN_DATE").val(storeData.RFUN_DATE); 
						     		$("#MedicalDetailForm #RFUN_RESN").val(storeData.RFUN_RESN); 
						     		$("#MedicalDetailForm #RFUN_AMNT").val(storeData.RFUN_AMNT); 
						     		$("#MedicalDetailForm #ENAME").val(storeData.ENAME); 
						     		$("#MedicalDetailForm #OBJPS_21").val(storeData.OBJPS_21); 
						     		$("#MedicalDetailForm #REGNO_21").val(storeData.REGNO_21);
			   						$('#MedicalListForm #CTRL_NUMB').val(storeData.CTRL_NUMB);
			   						$('#MedicalListForm #GUEN_CODE').val(storeData.GUEN_CODE);
			   						$('#MedicalListForm #SICK_NAME').val(storeData.SICK_NAME);
			   						$('#MedicalListForm #SICK_DESC1').val(storeData.SICK_DESC1);
			   						$('#MedicalListForm #BIGO_TEXT1').val(storeData.BIGO_TEXT1);
			   						$('#MedicalListForm #BIGO_TEXT2').val(storeData.BIGO_TEXT2);
			   						$('#MedicalListForm #RFUN_DATE').val(storeData.RFUN_DATE);
			   						$('#MedicalListForm #RFUN_AMNT').val(storeData.RFUN_AMNT);
			   						$("#form2 #CTRL_NUMB").val(storeData.CTRL_NUMB);
									$("#form2 #GUEN_CODE").val(storeData.GUEN_CODE);
									$("#form2 #OBJPS_21").val(storeData.OBJPS_21);
									$("#form2 #REGNO_21").val(storeData.REGNO_21);
									$("#form2 #PROOF").val(storeData.PROOF);
									$("#form3 #CTRL_YEAR").val(storeData.CTRL_NUMB.substring(0,4));
									$("#form3 #GUEN_CODE").val(storeData.GUEN_CODE);
									$("#form3 #OBJPS_21").val(storeData.OBJPS_21);
									$("#form3 #REGNO_21").val(storeData.REGNO_21);
									$("#totalWaers #EMPL_WONX").val(storeData.EMPL_WONX == 0 ? "" : banolim(storeData.EMPL_WONX).format()+" "+storeData.WAERS);
									$("#totalWaers #YTAX_WONX").val(storeData.YTAX_WONX == 0 ? "" : banolim(storeData.YTAX_WONX).format()+" "+storeData.WAERS);
									$("#totalWaers #COMP_WONX").val(storeData.COMP_WONX == 0 ? "" : banolim(storeData.COMP_WONX).format()+" "+storeData.WAERS);
			   						detailAction();
			   						medicalDetailGrid();
			   						totalBill();
	           					   });
		           			},
		           			align: "center",
		           			width: "8%"
		           		},
                { title: "신청일", name: "BEGDA", type: "text", align: "center", width: "11%" ,
                	itemTemplate: function(value, storeData) {
                		return value == "0000.00.00" ? "" : value;
                	}
                },
                { title: "관리번호", name: "CTRL_NUMB", type: "text", align: "center", width: "13%" },
                { title: "구분", name: "GUEN_CODE", type: "text", align: "center", width: "10%",
                	itemTemplate: function(value, storeData) {
                		if(value == "0001"){
							return "본인";
						}else if(value == "0002"){
							return "배우자";
						}else{
							return "자녀";
						}
                	}
                },
                { title: "상병명", name: "SICK_NAME", type: "text", align: "center", width: "19%" },
                { title: "본인 납부액", name: "EMPL_WONX", type: "text", align: "right", width: "15%",
                	itemTemplate: function(value, storeData) {
                		if(value == 0){
                			return "";
                		}else{
                			return banolim(value,0).format() + " <font color='#0000FF'>" + storeData.WAERS + "</font>";
                		}
                	}
                },
                { title: "회사 지원액", name: "COMP_WONX", type: "text", align: "right", width: "15%" ,
                	itemTemplate: function(value, storeData) {
                		if(value == 0){
                			return "";
                		}else{
                			return banolim(value,0).format() + " <font color='#0000FF'>" + storeData.WAERS + "</font>";
                		}
                	}
                },
                { title: "최종결재일", name: "POST_DATE", type: "text", align: "center", width: "11%", 
                	itemTemplate: function(value, storeData) {
                		return value == "0000.00.00" ? "" : value;
                	}
                },
            ]
        });
    });
	
	// tab2 라디오버튼 상세
        var detailAction = function(){
        	if($("#MedicalDetailForm #GUEN_CODE").val()=="0002"){
				$("#MedicalListForm #PROOF").show();
				$("#child").hide();
				$("#MedicalListForm #PROOFNAME").show();
        	}else if($("#MedicalDetailForm #GUEN_CODE").val()=="0003"){
				$("#MedicalListForm #PROOF").hide();
				$("#child").show();
				$("#MedicalListForm #PROOF").hide();
				$("#MedicalListForm #PROOFNAME").hide();
				$("#MedicalListForm #ENAME").val($("#MedicalDetailForm #ENAME").val());
				$("#MedicalListForm #REGNO_dis").val($("#MedicalDetailForm #REGNO_21").val().substring(0, 6) + "-*******");
        	}else{
        		$("#MedicalListForm #PROOF").hide();
				$("#child").hide();
				$("#MedicalListForm #PROOFNAME").hide();
        	}
        	
			if($("#MedicalDetailForm #PROOF").val() == "X") {
				$("#MedicalListForm #PROOF").prop("checked", true); 
			}else{
				$("#MedicalListForm #PROOF").prop("checked", false); 
			}
			$("#MedicalListForm #SICK_DESC").val($("#MedicalDetailForm #SICK_DESC1").val()+'\n'+$("#MedicalDetailForm #SICK_DESC2").val()+'\n'+$("#MedicalDetailForm #SICK_DESC3").val());
			
			$("#MedicalListForm #RFUN_DATE").val() == "0000-00-00" ? "" : $("#MedicalListForm #RFUN_DATE").val();
			if($("#MedicalListForm #RFUN_AMNT").val() == "0.0"){
				$("#MedicalListForm #RFUN_AMNT").val("");
			}else{
				$("#MedicalListForm #RFUN_AMNT").val()+$("#MedicalDetailForm #WAERS").val();
			}
        };
        
        // 진료비 계산서 조회 
      var medicalDetailGrid = function(){
            $("#medicalDetailGrid").jsGrid({
            	height: "auto",
                width: "100%",
                sorting: true,
                autoload: true,
                controller : {
                	loadData : function() {
       					var d = $.Deferred();
       					$.ajax({
       						type : "POST",
       						url : "/manager/supp/getMedicalDetail.json",
       						dataType : "json",
       		                data : {
       		                	"CTRL_NUMB" : $("#MedicalDetailForm #CTRL_NUMB").val()
       							,"GUEN_CODE" : $("#MedicalDetailForm #GUEN_CODE").val()
       							,"OBJPS_21" : $("#MedicalDetailForm #OBJPS_21").val()
       				     		,"REGNO_21" : $("#MedicalDetailForm #REGNO_21").val()
       		                },
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
    	           			title: "선택",
    	           			name: "th1",
    	           			itemTemplate: function(value, storeData) {
    	                         return $("<input name='chkBill' id='chkBill' checked>")
    	                           .attr("type", "radio")
    	     					  .on("click", function(e) {
										$("#form2 #RCPT_NUMB").val(storeData.RCPT_NUMB);
										$("#form2 #RCPT_CODE").val(storeData.RCPT_CODE);
    	           					   });
    		           			},
    		           			align: "center",
    		           			width: "8%"
    		           		},
                    { title: "의료기관", name: "MEDI_NAME", type: "text", align: "center", width: "15%" },
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
                    { title: "전화번호", name: "TELX_NUMB", type: "text", align: "center", width: "9%"},
                    { title: "진료일", name: "EXAM_DATE", type: "text", align: "center", width: "9%",
                    	itemTemplate: function(value, storeData) {
                    		return value == "0000.00.00" ? "" : value;
                    	}
                    },
                    { title: "입원<br>/외래", name: "MEDI_TEXT", type: "text", align: "center", width: "6%" },
                    { title: "영수증구분", name: "RCPT_TEXT", type: "text", align: "center", width: "10%" },
                    { title: "No.", name: "RCPT_NUMB", type: "text", align: "center", width: "6%" },
                    { title: "결재수단", name: "MEDI_MTHD_TEXT", type: "text", align: "center", width: "9%",
                    	itemTemplate: function(value, storeData) {
                    		if(storeData.MEDI_MTHD == "1"){
    							return "현금";
    						}else if(storeData.MEDI_MTHD == "2"){
    							return "신용카드";
    						}else{
    							return "";
    						}
                    	}
                    },
                    { title: "본인실납부액", name: "EMPL_WONX", type: "text", align: "right", width: "10%",
                    	itemTemplate: function(value, storeData) {
                    		if(value == 0){
                    			return "";
                    		}else{
                    			return banolim(value,0).format();
                    		}
                    	}
                    },
                    { title: "연말정산<br>반영액", name: "YTAX_WONX", type: "text", align: "right", width: "10%",
                    	itemTemplate: function(value, storeData) {
                    			return banolim(value,0).format();
                    	}
                    }
                ]
            });
        };
        
        var totalBill = function (){
       		jQuery.ajax({
       			type : 'GET',
       			url : '/manager/supp/getTotalBill.json',
       			cache : false,
       			dataType : 'json',
       			data : $('#form3').serialize(),
       			async :false,
       			success : function(response) {
       				if(response.success){
       					var COMP_sum =  response.COMP_sum;
       					$("#totalWaers #COMP_sum").val(COMP_sum == 0 ? "" : banolim(COMP_sum).format()+" "+$("#MedicalDetailForm #WAERS").val());
       					$("#requestHiddenForm #COMP_sum").val(COMP_sum == 0 ? "" : banolim(COMP_sum).format());
       				}else{
       					alert("조회시 오류가 발생하였습니다. " + response.message);
       				}
       			}
       		});
       		
       	};
        
        var billDetail = function (){
       		jQuery.ajax({
       			type : 'GET',
       			url : '/manager/supp/getMedicalBill.json',
       			cache : false,
       			dataType : 'json',
       			data : $('#form2').serialize(),
       			async :false,
       			success : function(response) {
       				if(response.success){
       					var storeData =  response.storeData[0];
       					var CNT1_WONX =  response.CNT1_WONX;
       					var CNT2_WONX =  response.CNT2_WONX;
       					$("#billDetail #TOTL_WONX").val(storeData.TOTL_WONX == 0 ? "" : banolim(storeData.TOTL_WONX).format());
       					$("#billDetail #ASSO_WONX").val(storeData.ASSO_WONX == 0 ? "" : banolim(storeData.ASSO_WONX).format());
       					$("#billDetail #EMPL_WONX").val(storeData.EMPL_WONX == 0 ? "" : banolim(storeData.EMPL_WONX).format());
       					$("#billDetail #MEAL_WONX").val(storeData.MEAL_WONX == 0 ? "" : banolim(storeData.MEAL_WONX).format());
       					$("#billDetail #APNT_WONX").val(storeData.APNT_WONX == 0 ? "" : banolim(storeData.APNT_WONX).format());
       					$("#billDetail #ROOM_WONX").val(storeData.ROOM_WONX == 0 ? "" : banolim(storeData.ROOM_WONX).format());
       					$("#billDetail #CTXX_WONX").val(storeData.CTXX_WONX == 0 ? "" : banolim(storeData.CTXX_WONX).format());
       					$("#billDetail #MRIX_WONX").val(storeData.MRIX_WONX == 0 ? "" : banolim(storeData.MRIX_WONX).format());
       					$("#billDetail #SWAV_WONX").val(storeData.SWAV_WONX == 0 ? "" : banolim(storeData.SWAV_WONX).format());
       					$("#ETC1_TEXT_th").val(storeData.ETC1_TEXT);
       					$("#billDetail #ETC1_WONX").val(storeData.ETC1_WONX == 0 ? "" : banolim(storeData.ETC1_WONX).format());
       					$("#ETC2_TEXT_th").val(storeData.ETC2_TEXT);
       					$("#billDetail #ETC2_WONX").val(storeData.ETC2_WONX == 0 ? "" : banolim(storeData.ETC2_WONX).format());
       					$("#ETC3_TEXT_th").val(storeData.ETC3_TEXT);
       					$("#billDetail #ETC3_WONX").val(storeData.ETC3_WONX == 0 ? "" : banolim(storeData.ETC3_WONX).format());
       					$("#ETC4_TEXT_th").val(storeData.ETC4_TEXT);
       					$("#billDetail #ETC4_WONX").val(storeData.ETC4_WONX == 0 ? "" : banolim(storeData.ETC4_WONX).format());
       					$("#ETC5_TEXT_th").val(storeData.ETC5_TEXT);
       					$("#billDetail #ETC5_WONX").val(storeData.ETC5_WONX == 0 ? "" : banolim(storeData.ETC5_WONX).format());
       					$("#billDetail #CNT1_WONX").val(CNT1_WONX == 0 ? "" : banolim(CNT1_WONX).format());
       					$("#billDetail #DISC_WONX").val(storeData.DISC_WONX == 0 ? "" : banolim(storeData.DISC_WONX).format());
       					$("#billDetail #CNT2_WONX").val(CNT2_WONX == 0 ? "" : banolim(CNT2_WONX).format()+" " +$("#MedicalDetailForm #WAERS").val());
       				}else{
       					alert("조회시 오류가 발생하였습니다. " + response.message);
       				}
       			}
       		});
       		
       	};
</script>
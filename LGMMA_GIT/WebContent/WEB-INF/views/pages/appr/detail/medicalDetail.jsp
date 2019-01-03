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
			<h2 class="subtitle withButtons">의료비 신청 상세내역</h2>
			<div class="clear"></div>
			<div class="table">
				<table class="tableGeneral">
				<caption>진료 기본사항</caption>
				<colgroup>
					<col class="col_15p">
                    <col class="col_35p">
                    <col class="col_15p">
                    <col class="col_35p">
				</colgroup>
				<tbody>
				<tr>
					<th><label for="inputText01-1">신청일</label></th>
					<td class="tdDate"><input class="readOnly" type="text" name="BEGDA" value="" id="BEGDA" readonly />
					</td>
					<th><label for="a1">결재일</label></th>
					<td class="tdDate"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="input-radio01-1">관리번호 </label></th>
					<td colspan="3">
						<input class="readOnly" type="text" name="CTRL_NUMB" id="CTRL_NUMB" />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="inputSelect01-2">구분 </label></th>
					<td colspan="3">
						<input class="readOnly" type="text" name="GUEN_NAME" id="GUEN_NAME" />
						<input class="readOnly" type="hidden" name="GUEN_CODE" id="GUEN_CODE" />
						<input class="readOnly" type="checkbox" name="PROOF" id="PROOF" value="" readOnly>연말정산반영여부
					</td>
				</tr>
				<tr id="child">
					<th><span class="textPink">*</span><label for="inputSelect01-3">자녀이름</label></th>
					<td colspan="3">
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
					<td colspan="3">
						<input class="wPer" type="text" id="SICK_NAME" name="SICK_NAME" value="" />
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="inputText01-5">구체적증상 </label></th>
					<td colspan="3">
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
			<h2 class="subtitle withButtons">의료비 상세내역</h2>
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
			<c:if test="${APPR_STAT == 'A'}">
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
			<c:if test="${APPR_STAT == ''}">
			<div class="totalArea">
					<strong>계</strong>
					<input class="inputMoney readOnly" type="text" name="EMPL_WONX_tot" id="EMPL_WONX_tot" value="" readonly />  KRW
				</div>
			</c:if>
			</tr>
			</tbody>
			</table>				
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

<script type="text/javascript">
	var orgItem;
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
				fncSetFormReadOnly($("#detailForm"), false);
				fncSetFormReadOnly($("#detailForm"), true, new Array("labelReturn"));
				$("#rejectTxt").css("background", "white");
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
	});
	
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
	};
</script>
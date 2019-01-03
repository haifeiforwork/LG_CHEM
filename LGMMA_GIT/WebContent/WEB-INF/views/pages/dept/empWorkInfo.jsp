<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="java.lang.String"%>

<%
	WebUserData user = (WebUserData)session.getValue("user");
	String E_OTEXT = (String)request.getAttribute("E_OTEXT");
	
	String E_STATUS  = WebUtil.nvl(request.getParameter("E_STATUS")); //승인완료=A 은, 수정 및 저장 불가
	
	String t_deptNm = (String)request.getAttribute("deptNm");
	
	if(t_deptNm == null)
		t_deptNm = "";
	
	String deptNm        = WebUtil.nvl(request.getParameter("hdn_deptNm")); //부서명
	
// 	out.println(", hdn_deptNm : "+deptNm);
// 	out.println(", E_OTEXT : "+E_OTEXT);
// 	out.println(", main_vt : "+main_vt);

	
%>
	<!--// Page Title start -->
	<div class="title">
		<h1>부서근태 일괄입력</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">조직관리</a></span></li>
				<li class="lastLocation"><span><a href="#">부서근태</a></span></li>
			</ul>
		</div>
	</div>
	<!--// Page Title end -->

	<!--------------- layout body start --------------->
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
			<caption>부서근태 일괄입력</caption>
			<colgroup>
				<col class="col_15p" />
				<col class="col_35p" />
				<col class="col_15p" />
				<col class="col_35p" />
			</colgroup>
			<tbody>
				<form id="requestForm">
				<tr>
					<th><label for="inputText01-1">신청일</label></th>
					<td class="tdDate">
						<input type="text" class="readOnly" id="BEGDA" name="BEGDA" value="<%=WebUtil.printDate(DataUtil.getCurrentDate(), ".")%>" readonly />
					</td>
					<th><label for="inputText01-2">부서명</label></th>
					<td>
						<input type="text" class="readOnly" id="E_OTEXT" name="E_OTEXT" value="<%=E_OTEXT%>" readonly />
					</td>
				</tr>
				<tr>
					<th><label for="inputDate">기간</label></th>
					<td colspan="2" class="tdDate">
						<input type="text" class="datepicker" id="inputDate" name="I_DATE" value="<%=WebUtil.printDate(DataUtil.getCurrentDate(), ".")%>" /></td>
					<td>
						<div class="buttonArea">
							<ul class="btn_mdl">
								<li><a href="#" id="searchBtn"><span>조회</span></a></li>
							</ul>
						</div>
					</td>
				</tr>
				<input type="hidden" id="hdn_deptNm" name="hdn_deptNm" >
				<input type="hidden" id="rowCount" name="rowCount" >
				</form>
			</tbody>
			</table>
		</div>
		<input type="hidden" id="E_STATUS" name="E_STATUS" value="<%= E_STATUS%>">
	</div>
	<!--// Table start -->
	<div class="listArea">
		<div class="tblBackground">
			<div id="empWorkGrid" class="thSpan"></div>
		</div>
		<div class="tableComment">
			<p><span class="bold">안전교육 및 혁신활동(분임조)은 [초과근로→교육] 유형으로 입력해주시기 바랍니다. </span></p>
		</div>
	</div>
	<!--// Table end -->
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="requestBtn"><span>입력</span></a></li>
		</ul>
	</div>
	<!--------------- layout body end --------------->
	
	
<!-- popup : 등록금 고지서 입력 start -->
<div class="layerWrapper layerSizeM" id="popLayer" style="display:inherit !important">
	<form id="popupForm">
	<div class="layerHeader">
		<strong>경조금 조회</strong>
		<a href="#" class="btnClose popLayer_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="listArea">
				<div id="congDisplayGrid"></div>
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
	
<script type="text/javascript">
	$(function() {
		
		if($(".layerWrapper").length){
			$("#popLayer").popup();
		};
		
		
		var sbutyCode;
		var OvtmCode;
		
		$(document).ready(function(){
			
			jQuery.ajax({
				type : 'POST',
				url : '/dept/getSbutyCode.json',
				cache : false,
				dataType : 'json',
				async :false,
				success : function(response) {
					if(response.success){
						sbutyCode = response.sbutyCode;
					}else{
						alert("실패");
					}
				}
			});
			
			$("#empWorkGrid").jsGrid("search");
			
		});
		
		$("#searchBtn").click(function(){
			$("#empWorkGrid").jsGrid("search");
		});
		
		var setDisabledFalse = function(item){
			var $row = $("#empWorkGrid").jsGrid("rowByItem", item);
			$row.find('input[name="PernrText"]').prop("disabled", true); 
			$row.find('input[name="EnameText"]').prop("disabled", true);
			
		};
		var setDisabledTrue = function(item){
			var $row = $("#empWorkGrid").jsGrid("rowByItem", item);
			$row.find('input[name="PernrText"]').prop("disabled", false);
			$row.find('input[name="EnameText"]').prop("disabled", false);
		};
		
		var setSubtyFalse = function(item){
			var $row = $("#empWorkGrid").jsGrid("rowByItem", item);
			$row.find('select[name="subtySelect"]').prop("disabled", true);
			$row.find('select[name="VtkenCheck"]').prop("disabled", true);
		};
		
		var setSubtyTrue = function(item){
			var $row = $("#empWorkGrid").jsGrid("rowByItem", item);
			$row.find('select[name="subtySelect"]').prop("disabled", false);
			$row.find('select[name="VtkenCheck"]').prop("disabled", false);
		};
		
		function disableType(gubun, item) {
			var $row = $("#empWorkGrid").jsGrid("rowByItem", item);
			var SUBTY = $row.find('select[name="subtySelect"]').val();
			var OVTM_CODE = $row.find('select[name="OvtmCode"]').val(); //CSR ID:1546748
			var MINTG = $row.find('select[name="subtySelect"]  option:selected').attr("MINTG");
			
			// Type ① : HFLAG = "X"인경우 모든 Filed는 입력불가능
			if( gubun == "1" ) {   
			}
			
			// Type ② : 휴가유형 선택시 전일(0110),경조(0130),하계(0140),보건(0150),전일공가(0170),유급결근(0200), 유휴(휴일비근무)(0340)일 경우 모든 Field는 입력불가능
			if( gubun == "2" ||gubun == "1") {
				if(MINTG=="1"){
					if(SUBTY=="0110"){//전일휴가  사유필드 활성화
						objDisplay(gubun,$row, false, false, false, false, true);
					}else if(SUBTY=="0130"){//경조휴가시 사유필드 비활성화
						objDisplay(gubun,$row, false, false, false, false, false);
					}else{
						objDisplay(gubun,$row, false, false, false, false, true);
					}
					  	
				}else if(MINTG==""){
					objDisplay(gubun,$row, false, false, false, false, false);
				}else{
					if(SUBTY=="2005"){ // 초과근로일 경우에만 시작시간,종료시간,휴게시작시간,휴게종료시간, 사유 필드OPEN
						objDisplay(gubun,$row, true, true, true, true, true);
					}else if(SUBTY=="0130"){ // 경조휴가시 사유필드 비활성화
						objDisplay(gubun,$row, false, false, false, false, false);
					}else{ // 시작시간 종료시간 사유 필드OPEN
						objDisplay(gubun,$row, true, true, false, false, true);
					}
				}
				if( gubun != "1") {
					if(SUBTY == "" || "<%=E_STATUS%>" =="A"){
						$row.find('select[name="VtkenCheck"]').prop("checked", false);
						$row.find('select[name="VtkenCheck"]').prop("disabled", true);
					}else{
						$row.find('select[name="VtkenCheck"]').prop("checked", false);
						$row.find('select[name="VtkenCheck"]').prop("disabled", false);
					}
				}
			}
		};
		
		function objDisplay(gubun,index, BEGUZ, ENDUZ, PBEG1, PEND1,REASON){
			
			//value를 빈문자열로 초기화
			if (gubun !="1") {
				index.find('input[name="BeguzText"]').val("00:00");
				index.find('input[name="Enduzext"]').val("00:00");
				index.find('input[name="Pbeg1Text"]').val("00:00");
				index.find('input[name="Pend1Text"]').val("00:00");
				index.find('input[name="reasonText"]').val("");
			}
			if(BEGUZ==true){
				index.find('input[name="BeguzText"]').prop("disabled", false);
			}else{
				index.find('input[name="BeguzText"]').prop("disabled", true);
			}
			
			if(ENDUZ==true){
				index.find('input[name="Enduzext"]').prop("disabled", false);
			}else{
				index.find('input[name="Enduzext"]').prop("disabled", true);
			}
			
			if(PBEG1==true){
				index.find('input[name="Pbeg1Text"]').prop("disabled", false);
			}else{
				index.find('input[name="Pbeg1Text"]').prop("disabled", true);
			}
			
			if(PEND1==true){
				index.find('input[name="Pend1Text"]').prop("disabled", false);
			}else{
				index.find('input[name="Pend1Text"]').prop("disabled", true);
			}
			
			if(REASON==true){
				index.find('input[name="reasonText"]').prop("disabled", false);
			}else{
				index.find('input[name="reasonText"]').prop("disabled", true);
			}
		};
		
		$("#inputDate").change(function(){
			if($("#inputDate").val() != "") {
				if(removePoint($("#inputDate").val()) < "20160900"){
					alert("2016/09/01 이후 내용만 입력가능합니다.");
					$("#inputDate").val("2016.09.01");
					return false;
				}else{
					$("#empWorkGrid").jsGrid("search");
				}
			}else{
				alert("조회기간이 잘못도었습니다");
				return false;
			}
		});
		
		// 부서원 목록
		$("#empWorkGrid").jsGrid({
			height: "auto",
			sorting: false,
			paging: false,
			autoload: false,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "POST",
						url : "/dept/getEmpWorkList.json",
						dataType : "json",
						data : {
							"I_DATE" : $('input[name="I_DATE"]').val(),
							"E_OTEXT" : $("#E_OTEXT").val()
						},
					}).done(function(response) {
						if(response.success){
							$.each(response.storeData, function(i, item){
								item.changeFlag = 'N';
							});
							
							d.resolve(response.storeData);
							
							$("#hdn_deptNm").val(response.deptNm);
							
						}else{
							alert("조회시 오류가 발생하였습니다. " + response.message);
						}
					});
					return d.promise();
				}
			},
			headerRowRenderer: function() {
				var arr = new Array(new Array(4,7,"휴게시간"));
				return setGridHeader(this, arr);
			},
			fields : [
				{ title: "사원번호", name: "PERNR", type: "text", align: "center", width: "8%",
					itemTemplate: function(value, item) {
						var $input = $("<input name='PernrText' type='text' disabled>").width("60px").val(value);
						return $input.on("change", function(e) {
							item.PERNR = $input.val()
							if(item.ADDYN == "N"){
								setDisabledFalse(item);
							}else{
								setDisabledTrue(item); 
							}
						});
					}
				},
				{ title: "성명", name: "ENAME", type: "text", align: "center", width: "8%",
					itemTemplate: function(value, item) {
						var $input = $("<input name='EnameText' type='text' disabled>").width("50px").val(value);
						return $input.on("change", function(e) {
							item.ENAME = $input.val()
							if(item.ADDYN == "N"){
								setDisabledFalse(item);
							}else{
								setDisabledTrue(item); 
							}
						});
					}
				},
				{ title: "유형선택", name: "SUBTY", type: "text", align: "center", width: "12%",
					itemTemplate: function(value, item) {
						var $select  =  $("<select name='subtySelect'>").width("100px")
										.append($("<option>").val("").text("-----------"));
						$.each(sbutyCode, function(key, value) {			  
							if(item.SUBTY == value.SUBTY){
								$('<option selected MINTG= ' + value.MINTG+'>').val(value.SUBTY).text(value.ATEXT).appendTo($select);
							}else{
								$('<option MINTG= ' + value.MINTG+'>').val(value.SUBTY).text(value.ATEXT).appendTo($select);
							}
						});
						return $select.on("change", function(e) {
							item.SUBTY = $(this).find("option:selected").val();
							checkVtken(item);
							disableType(2 , item);
							
							if(item.APPR_STAT=="A" || $("#E_STATUS").val()=="A"){
								setSubtyFalse(item);
							}else{
								setSubtyTrue(item);
							}
							
							item.CONG_CODE = "";
							item.OVTM_CODE = "";
							item.REASON = "";
							
							checkChangeFlag(item);
						});
					}
				},
				{ title: "시작시간", name: "BEGUZ", type: "text", align: "center", width: "6%", 
					itemTemplate: function(value, item) {
						var $input = $("<input name='BeguzText' type='text' disabled>")
									 .width("50px")
									 .val(value)
									 .on("change", function(e) {
										if(validCheck($(this).val(), "시작시간의 "))
											item.BEGUZ = $(this).val().replace(":","");
									 });
						if(value==""){
							return $input.val("00:00");
						}else{
							return $input.val($input.val() == null ? "00:00" : $input.val().substring(2,3) != ":" || $input.val().length != 8 ? $input.val().substring(0,2)+":"+$input.val().substring(3,5): $input.val().substring(0,5));
						}
					}
				},
				{ title: "종료시간", name: "ENDUZ", type: "text", align: "center", width: "6%", 
					itemTemplate: function(value, item) {
						var $input = $("<input name='Enduzext' type='text' disabled>")
									 .width("50px")
									 .val(value)
									 .on("change", function(e) {
										if(validCheck($(this).val(),"종료시간의 "))
											item.ENDUZ = $(this).val().replace(":","");
									 });
						if(value==""){
							return $input.val("00:00");
						}else{
							return $input.val($input.val() == null ? "00:00" : $input.val().substring(2,3) != ":" || $input.val().length != 8 ? $input.val().substring(0,2)+":"+$input.val().substring(3,5): $input.val().substring(0,5));
						}
					}
				},
				{ title: "시작시간", name: "PBEG1", type: "text", align: "center", width: "6%", 
					itemTemplate: function(value, item) {
						var $input = $("<input name='Pbeg1Text' type='text' disabled>")
									 .width("50px")
									 .val(value)
									 .on("change", function(e) {
										if(validCheck($(this).val(), "휴게시작시간의 "))
											item.PBEG1 = $(this).val().replace(":","");
									 });
						if(value==""){
							return $input.val("00:00");
						}else{
							return $input.val($input.val() == null ? "00:00" : $input.val().substring(2,3) != ":" || $input.val().length != 8 ? $input.val().substring(0,2)+":"+$input.val().substring(3,5): $input.val().substring(0,5));
						}
					}
				},
				{ title: "종료시간", name: "PEND1", type: "text", align: "center", width: "6%", 
					itemTemplate: function(value, item) {
						var $input = $("<input name='Pend1Text' type='text' disabled>")
									 .width("50px")
									 .val(value)
									 .on("change", function(e) {
										if(validCheck($(this).val(), "휴게종료시간의 "))
											item.PEND1 = $(this).val().replace(":","");
									 });
						if(value==""){
							return $input.val("00:00");
						}else{
							return $input.val($input.val() == null ? "00:00" : $input.val().substring(2,3) != ":" || $input.val().length != 8 ? $input.val().substring(0,2)+":"+$input.val().substring(3,5): $input.val().substring(0,5));
						}
					}
				},
				{ title: "이전일", name: "VTKEN", type: "text", align: "center", width: "6%" ,
					itemTemplate: function(value,item) {
						var $checkBox = $("<input name='VtkenCheck' type='checkBox' disabled>").val(value);
						if(value == "X") {
							return $checkBox.prop({checked:true});
						} else {
							return $checkBox.prop({checked:false});
						}
						if(item.APPR_STAT=="A" || $("#E_STATUS").val()=="A"){
							setSubtyFalse(item);
						}else{
							setSubtyTrue(item);
						}
					}
				},
				{ title: "사유", name: "REASON", type: "text", align: "center", width: "20%",
					itemTemplate: function(value, item) {
						var $select = "";
						var $input = $("<input name='reasonText' type='text' disabled>")
									.width("100px")
									.on("change", function(e){
										item.REASON = $(this).val();
										checkChangeFlag(item);
									})
									.val(value);
						
						if(item.SUBTY != '' && item.SUBTY != "0130"){
							jQuery.ajax({
								type : 'GET',
								url : '/dept/getSbutyCode.json',
								cache : false,
								dataType : 'json',
								async :false,
								data : {
									"PERNR" : item.PERNR,
									"SUBTY" : item.SUBTY
								},
								success : function(response) {
									if(response.success){
										$select = $("<select name='ovtmSelect'>").width("100px")
													.append($("<option>").val("").text("---------")
													)
													.on("change", function(e) {
														item.OVTM_CODE = $(this).find("option:selected").val();
														item.MINTG = $(this).find("option:selected").attr("MINTG");
														checkChangeFlag(item);
													});
										$.each(response.OvtmCode, function(key, value) {
											if(item.OVTM_CODE == value.code){
												$('<option selected>').val(value.code).text(value.value).appendTo($select);
											}else{
												$('<option >').val(value.code).text(value.value).appendTo($select);
											}
										});
										if(response.OvtmCode.length == 0) $select = "";
									}else{
										$select = "";
									}
								}
							});
						}else if( item.SUBTY == "0130"){
							jQuery.ajax({
								type : 'GET',
								url : '/dept/getCongCode.json',
								cache : false,
								dataType : 'json',
								async :false,
								success : function(response) {
									if(response.success){
										$select = $("<select name='congCodeSelect'>").width("100px")
												.append($("<option>").val("").text("---------"))
												.on("change", function(e) {
													item.CONG_CODE = $(this).find("option:selected").val();
													item.REASON = $(this).find("option:selected").text();
													checkChangeFlag(item);
												})
												.add($("<img>")
													.attr({
														src:"/web-resource/images/ico/ico_magnify.png",
														alt:'검색'
													})
													.on("click", function(e) {
														popupShow(item);
													})
												);
										$.each(response.congCode, function(key, value) {
											if(item.CONG_CODE == value.code){
												$('<option selected>').val(value.code).text(value.value).appendTo($select);
											}else{
												$('<option >').val(value.code).text(value.value).appendTo($select);
											}
										});
									}else{
									}
								}
							});
						}else{
							$select = "";
						}
						
						
						return $input.on("change", function(e) {
									item.REASON = $input.val();
								}).add($select);
					}
				},
				{ title: "결재", name: "APPR_STAT", type: "text", align: "center", width: "8%" 
					,itemTemplate: function(value,item){
						return (value == "A") ? "Y" : "N";
					}
				},
				{ name: "ATEXT", type: "text", visible: false },
				{ name: "SOLLZ", type: "text", visible: false },
				{ name: "A002_SEQN", type: "text", visible: false },
				{ name: "CONG_DATE", type: "text", visible: false },
				{ name: "HOLI_CONT", type: "text", visible: false },
				{ name: "AEDTM", type: "text", visible: false },
				{ name: "UNAME", type: "text", visible: false },
				{ name: "ZPERNR", type: "text", visible: false },
				{ name: "OVTM_NAME", type: "text", visible: false },
				{ name: "AINF_SEQN", type: "text", visible: false },
				{ name: "MINTG", type: "text", visible: false },
				{ name: "ADDYN", type: "text", visible: false },
				{ name: "CONG_CODE", type: "text", visible: false },
				{ name: "OVTM_CODE", type: "text", visible: false },
				{ name: "changeFlag",type: "text", visible: false }
			]
		});
		
		// 이전일 chekcbox validation
		var checkVtken = function(item){
			var orgItem = item;
			if( item.SUBTY == "0110" || item.SUBTY == "0130" || item.SUBTY == "0140" ||
					item.SUBTY == "0150" || item.SUBTY == "0170" || item.SUBTY == "0200" || item.SUBTY == "0340"){
				item.VTKEN = "X";
			}else{
				item.VTKEN = "";
			}
			
			$("#empWorkGrid").jsGrid("updateItem",orgItem, item);
			
		};
		
		var checkChangeFlag = function(item){
			if( item.SUBTY !=""  ||  item.REASON != "" ) 
				return item.changeFlag = 'Y';
			else
				return item.changeFlag = 'N';
		};
		
		// 입력 버튼 클릭
		$("#requestBtn").click(function(){
			if($("#empWorkGrid").jsGrid("dataCount") <1 ){
				alert("작업할 DATA가 없습니다.");
				return;
			}
			
			if(requestChk()){
				if(confirm("저장 하시겠습니까?")) {
					$("#requestBtn").prop("disabled", true);
					
					var data = $("#empWorkGrid").jsGrid("option", "data");
					$.each(data, function(i, $item) {
						if( $item.SUBTY !=""  &&  $item.REASON != "" ){
							$item.changeFlag = 'Y';
						}else{
							$item.changeFlag = 'N';
						}
					});
					
					var param = $("#requestForm").serializeArray();
					$("#empWorkGrid").jsGrid("serialize", param);
					
					jQuery.ajax({
						type : 'post',
						url : '/dept/saveEmpWork',
						cache : false,
						dataType : 'json',
						data : param,
						async : false,
						success : function(response) {
							if(response.success) {
								alert("저장 되었습니다.");
								return true;
							} else {
								alert("저장시 오류가 발생하였습니다. " + response.message);
								return false;
							}
							$("#requestBtn").prop("disabled", false);
						}
					});
				}
			}
		});
		
		var requestChk = function(){
			var chkFlag = true;
			var data = $("#empWorkGrid").jsGrid("option", "data");
			
			$.each(data, function(i, item) {
				var $row = $("#empWorkGrid").jsGrid("rowByItem", item);
				
				if( $row.find('select[name="ovtmSelect"]').length > 0 && $row.find('select[name="ovtmSelect"]').val() == "" ){//신청사유항목
					alert("신청사유항목은 필수 입력사항입니다.");
					$row.find('select[name="ovtmSelect"]').focus();
					chkFlag = false;
					return;
				}
				
				if( item.SUBTY !=""  &&  item.REASON == "" ){
					alert("신청사유를 입력하세요");
					if  ( item.SUBTY == "0130" ) {//경조휴가
						if ( item.CONG_CODE == "9000" || item.CONG_CODE == "9001" || item.CONG_CODE == "9002" ) { //경조휴가:탈상,자녀출
							$row.find('input[name="reasonText"]').prop("disabled", false).focus();
						}else{
							$row.find('select[name="congCodeSelect"]').focus();
						}
					}else{
						$row.find('input[name="reasonText"]').prop("disabled", false).focus();
					}
					chkFlag = false;
					return;
				}
				
			});
			
			return chkFlag;
		}
		
		function validCheck(target, alertMsg){  
			var msg = "";
			if (Number(target.split(":")[0]) > 24){
				alert(alertMsg + "시간은 24이하로 입력하세요.!");
				return false;
			}
			
			if (Number(target.split(":")[1]) > 59){
				alert(alertMsg + "분은 60미만으로 입력하세요.!");
				return false;
			}
			
			return true;
			
		}
		
	});
	
	var popupShow = function(target){
		$("#congDisplayGrid").jsGrid({"data":$.noop});
		
		$("#congDisplayGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: false,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/dept/getCongDisplayList.json",
						dataType : "json",
						data : {"PERNR" : target.PERNR }
					}).done(function(response) {
						if(response.success){
							d.resolve(response.storeData);
						}
						else{
							alert("조회시 오류가 발생하였습니다. " + response.message);
						}
					});
					return d.promise();
				}
			},
			fields: [
				{ title: "선택", name: "th1", type: "text", align: "center"
					,itemTemplate: function(_, item) {
						return $("<input name='congCodeRadio' disabled>")
								.attr("type", "radio")
								.on("click", function(e) {
									target.CONG_CODE = item.CONG_CODE;
									target.CONG_DATE = item.CONG_DATE;
									target.HOLI_CONT = item.HOLI_CONT;
									target.A002_SEQN = item.AINF_SEQN;
									target.REASON = item.CONG_NAME + "/" + item.RELA_NAME + "/" + item.CONG_DATE;
								});
					}
				},
				{ title: "경조구분", name: "CONG_NAME", type: "text", align: "center" },
				{ title: "관계", name: "RELA_NAME", type: "text", align: "center" },
				{ title: "경조발생일", name: "CONG_DATE", type: "text", align: "center" },
				{ title: "경조휴가일수", name: "HOLI_CONT", type: "text", align: "center" },
				
				{ name: "PERNR", type: "text", visible: false },
				{ name: "AINF_SEQN", type: "text", visible: false },
				{ name: "BEGDA", type: "text", visible: false },
				{ name: "CONG_CODE", type: "text", visible: false },
				{ name: "RELA_CODE", type: "text", visible: false }
			]

		});
		$("#congDisplayGrid").jsGrid("search");
		$("#popLayer").popup('show');
	}
	
</script>

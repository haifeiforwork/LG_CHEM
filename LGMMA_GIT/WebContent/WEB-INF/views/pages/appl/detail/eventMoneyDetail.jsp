<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="tableArea">
	<h2 class="subtitle">경조금 신청 조회</h2>
	<div class="buttonArea">
		<ul class="btn_mdl">
		<!-- 	<li><a href="#" id="popLayerPrintBtn"><span>경조금 신청 프린트</span></a></li>		 -->			
		</ul>
	</div>
	<!--// Table start -->
	<form id="detailForm" name="detailForm">
	<div class="table mb10">
		<table class="tableGeneral">
		<caption>신청서 신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>	
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText01-1">신청일</label></th>
			<td colspan="3" class="tdDate">
				<input class="readOnly" type="text" name="BEGDA" value="" id="BEGDA" readonly />
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="CONG_CODE">경조내역</label></th>
			<td colspan="3">
				<select class="w150" id="CONG_CODE" name="CONG_CODE" required vname="경조내역">
					<option value=""></option>
				</select>
                </td>
            </tr>
            <tr>
			<th><span class="textPink">*</span><label for="RELA_CODE">경조대상자 관계</label></th>
			<td>
				<select class="w150" id="RELA_CODE" name="RELA_CODE" required vname="경조대상자 관계"> 
					<option value=""></option>
				</select>
			</td>
			<th><span class="textPink">*</span><label for="EREL_NAME">경조대상자 성명</label></th>
			<td><input class="w150" type="text" name="EREL_NAME" value="" id="EREL_NAME" required vname="경조대상자 성명" /></td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="CONG_DATE">경조발생일자</label></th>
			<td colspan="3">
               <input id="CONG_DATE" class="datepicker" name="CONG_DATE"  type="text" size="5"  value="" required vname="경조발생일자"/>
            </td>
		</tr>						
		</tbody>
		</table>
	</div>
	<div class="table" id="readTable">
		<table class="tableGeneral">
		<caption>신청서 자동출력</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText02-1">月 기준급</label></th>
			<td colspan="3">
				<input class="inputMoney w120" type="text" id="WAGE_WONX" name="WAGE_WONX" value="" format="currency"/> 원
			</td>
		</tr>
		<tr>
			<th><label for="inputText02-2">지급율</label></th>
			<td colspan="3">
				<input class="alignRight w120" type="text" id="CONG_RATE" name="CONG_RATE" value=""/> %
                           </td>
                       </tr>
                       <tr>
			<th><label for="inputText02-3">경조금액</label></th>
			<td colspan="3">
				<input class="inputMoney w120" type="text" id="CONG_WONX" name="CONG_WONX" value="" format="currency"/> 원
			</td>
		</tr>
		<tr>
			<th><label for="inputText02-4">이체은행명</label></th>
			<td>
				<input class="w120" type="text" id="BANK_NAME" name="BANK_NAME" value=""/>
			</td>
			<th><label for="inputText02-5">은행계좌번호</label></th>
			<td>
				<input class="w120" type="text" name="BANKN" value="" id="BANKN"/>
			</td>
		</tr>
		<tr>
			<th><label for="HOLI_CONT">경조휴가일수</label></th>
			<td colspan="3">
				<div id="HOLI_CONT1" style="display:block;">
				<input class="alignRight w120" type="text" name="HOLI_CONT" value="" id="HOLI_CONT"/> 일
				</div>
				<div id="HOLI_CONT2" style="display:none;">
					Help 참조
				</div>
			</td>
		</tr>
		<tr>
			<th><label for="inputText02-7">근속년수</label></th>
			<td colspan="3">
                <input class="alignRight w50" type="text" name="WORK_YEAR" value="6" id="WORK_YEAR" value="" /> 년
                <input class="alignRight w50" type="text" name="WORK_MNTH" value="5" id="WORK_MNTH" value=""/> 개월
             </td>
		</tr>						
		</tbody>
		</table>
	</div>
	<!--// Table end -->
	</form>	
</div>
<!-- 프린트 영역 팝업-->	
<div id="hiddenPrint" style="width:700px;"></div>	
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>경조금 신청서</strong>
		<a href="#" class="btnClose popLayerPrint_close" onClick="setHidden(true);">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer">
			<div id="printBody">
				<iframe name="eventMoneyPrintPopup" id="eventMoneyPrintPopup" src="" frameborder="0" scrolling="no" style="float:left; height:1000px; width:700px;"></iframe>
			</div>
		</div>
	</div>
	<div class="buttonArea buttonPrint">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="printPopBtn"><span>프린트</span></a></li>								
		</ul>
	</div>	
	<div class="clear"> </div>	
</div>
<!-- 프린트 영역 -->
				
<script type="text/javascript">
	var relationType;
	var AINF_SEQN = "<c:out value="${AINF_SEQN}"/>";
	var E19CongcondData_rate;
	var getEventMoneyComboList = function() {
		$.ajax({
			type : "get",
			url : "/supp/getEventMoneyComboList",
			dataType : "json",
			data : {}
		}).done(function(response) {
			if (response.success) {
				//콤보옵션셋팅
				setSelectOption("CONG_CODE", response.E19CongCode, "code", "value", true);
				setSelectOption("RELA_CODE", response.E19CongcondData_opt, "RELA_CODE", "RELA_NAME", true);
				relationType = response.E19CongcondData_opt;
				E19CongcondData_rate = response.E19CongcondData_rate;
				
				detailSearch();
			}
		});
		
		return true;
	};
	
	var detailSearch = function() {

		$.ajax({
			type : "get",
			url : "/appl/getEventMoneyDetail.json",
			dataType : "json",
			data : {
				"AINF_SEQN" : AINF_SEQN
			}
		}).done(function(response) {
			if (response.success) {
				setTableText(response.storeData, "detailForm");
				changeRELA_CODE();
				//setTableText(response.user, "printForm");
				//setTableText(response.storeData, "printForm");
				fncSetFormReadOnly($("#detailForm"), true);
				fncSetFormReadOnly($("#readTable"), true);
				setHoli(response.storeData.CONG_CODE, response.storeData.RELA_CODE);
			} else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		
	};
	
	var changeRELA_CODE = function(rst) {
		var CONG_CODE = $("#CONG_CODE").val();
		var RELA_CODE = $("#RELA_CODE").val();
		
		var arr = new Array({RELA_CODE:"", RELA_NAME:""});
		$.each(relationType, function(i, data){
			if(CONG_CODE == data.CONG_CODE) {
				arr.push(data);
			}
		});
		setSelectOption("RELA_CODE", arr, "RELA_CODE", "RELA_NAME", true);
		
		$("#RELA_CODE").val(RELA_CODE);
		if(rst){$("#RELA_CODE").val("")}
	};
	
	var setHoli = function(CONG_CODE, RELA_CODE) {
//      2002.07.03. 조위이면서 부모, 배우자부모일경우에는 일수가 아닌 text를 보여준다. 요청자 : 성경호, 수정자 : 김도신
		//2017.01.06 불필요한 로직이라 삭제요청. 요청자 : LGMMA 홍성민
		/*
		if( CONG_CODE == "0003" && (RELA_CODE == "0002" || RELA_CODE == "0003") ) {
			$("#HOLI_CONT1").hide();
        	$("#HOLI_CONT2").show();
        	
		} else {
			$("#HOLI_CONT1").show();
        	$("#HOLI_CONT2").hide();
		}
		*/
	};
	
	$(document).ready(function(){
		
		getEventMoneyComboList();
		
		
		$("#CONG_CODE").change(function(){changeRELA_CODE(true);rela_action();});
		$("#RELA_CODE").change(function(){rela_action();});
		$("#CONG_DATE").change(function(){event_CONG_DATE();});
		$("#popLayerPrintBtn").click(function(){
			$("#eventMoneyPrintPopup").attr("src","/supp/eventMoneyPrint?AINF_SEQN=" + AINF_SEQN);
    		$("#eventMoneyPrintPopup").load(function(){
    			$('#popLayerPrint').popup("show");
    		});
			
    	});
		
		$("#printPopBtn").click(function(){
			setHidden(false);
			$("#hiddenPrint").print();
		});

	});
	
	//경조대상자 관계코드
	var rela_action = function() {
		var RELA_CODE = $("#RELA_CODE").val();
		var CONG_CODE = $("#CONG_CODE").val();

		$.each(E19CongcondData_rate, function(i, data){
			if(data.RELA_CODE == RELA_CODE && CONG_CODE==data.CONG_CODE){
				$("#CONG_RATE").val(data.CCON_RATE);
				$("#HOLI_CONT").val(data.HOLI_CONT);
				$("#CONG_WONX").val(cal_money());
				return false;
			}
		});
		
		setHoli(CONG_CODE, RELA_CODE);

		
	};
	

	
	//경조금 계산(근속년수가 LG MMA-1년미만시 지급율의 50%를 지급)
	var cal_money = function() {
	    var money = 0 ;
	    var rate = 0;
	    var wage = 0;
	    var compCode = 0;

	    rate = Number($("#CONG_RATE").val());
	    wage = Number(numberOnly($("#WAGE_WONX").val()));           // @v1.1

	    money = ( rate * wage )/100;

	    
	    WORK_YEAR = Number($("#WORK_YEAR").val());
	    WORK_MNTH = Number($("#WORK_MNTH").val());
		
	    if( WORK_YEAR < 1 ){//LG MMA-1년미만
	      money = money * 0.5 ;
	      $("#CONG_RATE").val(Number($("#CONG_RATE").val()) * 0.5) ; //지급율 % 도 50%로
	    }
	    
	    money = money_olim(money);
	    money = money.format();
	    return money;
	};
	
	//LG MMA 1000 미만 단수절상
	var money_olim = function(val_int){
	    var money = 0;
	    var compCode = 0;
	    var rate = 0;

	    money = olim(val_int, -3);

	    return money;
	};
	
	var event_CONG_DATE = function() {
		var rtn = true;
		jQuery.ajax({
    		type : "POST",
    		url : "/supp/getServiceYearMonth.json",
    		cache : false,
    		dataType : "json",
    		data : {				
				 "CONG_DATE" : numberOnly($("#CONG_DATE").val())
			},
    		async :false,
    		success : function(response) {
    			if(response.success){
    				var item = response.storeData[0];
    				$('#WORK_YEAR').val(item.WORK_YEAR);
    				$('#WORK_MNTH').val(item.WORK_MNTH);
    				$('#WAGE_WONX').val(item.WAGE_WONX.format());
    				
    				rela_action();
    			}
    			else{
    				alert(response.message);
    				rtn = false;
    			}
    		}
		});
		
		return rtn;
		
    };
    
    //경조금 신청시 중복신청을 체크
	var congraDupCheck = function() {
		var rtn = true;
		jQuery.ajax({
    		type : "POST",
    		url : "/supp/getCongraDupCheckList.json",
    		cache : false,
    		dataType : "json",
    		async :false,
    		success : function(response) {
    			if(response.success){
    				var items = response.storeData;
    				var WORK_YEAR = $('#WORK_YEAR').val();
    				var RELA_CODE = $('#RELA_CODE').val();
    				var EREL_NAME = $.trim($('#EREL_NAME').val());	//공백제거
    				var CONG_CODE =  $('#CONG_CODE').val();
    				for(var i=0;i<items.length;i++){
    					var item = items[0];
    					//  2003.02.20 - 경조금 신청시 중복신청을 체크하는 로직 추가
						//             - 신청사번에 대하여 동일 경조내역 & 동일 경조대상자 성명이 있는경우 신청하지 못한다
    					if(item.CONG_CODE == CONG_CODE && item.RELA_CODE == RELA_CODE && item.EREL_NAME == EREL_NAME){
							//lg MMA : 본인 재혼은 제외 - Temp Table만 체크한다.
    						if( CONG_CODE != "0009" || RELA_CODE != "0001"){
    							if(item.INFO_FLAG == "I"){
    								alert("해당 경조내역에 이미 동명의 경조대상자가 있습니다.");
    								rtn = false;
    								break;
    							}	
    						}
    						/*
    						if(item.INFO_FLAG == "T"){
    							alert("현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
    							rtn = false;
								break;
    						}*/
    					}
    				}

    			}
    			else{
    				alert(response.message);
    				rtn = false;
    			}
    		}
		});
		
		return rtn;
		
    };
    
	var reqModifyActionCallBack = function() {
		$("#popLayerPrintBtn").hide();
		changeRELA_CODE();
		fncSetFormReadOnly($("#detailForm"), false, new Array("BEGDA"));
		fncSetFormReadOnly($("#readTable"), true);
		$('#CONG_DATE').datepicker();
	};

	var reqDeleteActionCallBack = function() {
		$("#popLayerPrintBtn").hide();
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			param.push({name:"AINF_SEQN", value:AINF_SEQN});
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteEventMoney',
				cache : false,
				dataType : 'json',
				data : param,
				async : false,
				success : function(response) {
					if (response.success) {
						alert("삭제 되었습니다.");
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

	var reqCancelActionCallBack = function() {
		
		$("#detailForm").each(function() {
			this.reset();
		});
		
		destroydatepicker("detailForm");
		
		getEventMoneyComboList();
		
		$("#CONG_CODE").change(function(){changeRELA_CODE();});
		$("#popLayerPrintBtn").show();
	};

	var reqSaveActionCallBack = function() {
	
		if (checkDetailFormValid()) {
			if (confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				param.push({name:"AINF_SEQN", value:AINF_SEQN});
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateEventMoney',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
					success : function(response) {
						alert("저장되었습니다.");
						$('#applDetailArea').html('');
						$("#reqApplGrid").jsGrid("search");
						return true;
						
						$("#reqSaveBtn").prop("disabled", false);
					}
				});
			}
		} else {
			return false;
		}
		
		
	};
	
	var checkDetailFormValid = function() {
		//필수값 체크

		if(!checkNullField("detailForm")) return false;
		
		//중복체크... 필요한가...
		//if(!congraDupCheck()) return false;

		if($("#BANK_NAME").val() == "" || $("#BANKN").val() == "") {
			alert("입금될 계좌정보가 명확하지 않습니다.\n\n  인사담당자에게 문의해 주세요");
		    return false;
		}
		
		//결제체크
		//check_empNo()
		

		//  C2004042001000000069 - 돌반지 신청 시 금액을 입력하지 못하게 하고, 결재 시 담당자가 금액 입력 하도록 함. 이 때 자동전표는 생성되지 않고 이력만 관리하도록 함
		var CONG_WONX = Number(numberOnly($("#CONG_WONX").val()));
		var disa = $("#CONG_CODE").val();
		
		if(disa != "0006" && CONG_WONX == 0){
			alert(" 입력값이 적합하지 않습니다. ");
			$("#CONG_WONX").focus();
			return false;
		}
		
		//경조사 발생 3개월초과시 에러처리
		var begin_date = numberOnly($("#BEGDA").val());
	    var congra_date = numberOnly($("#CONG_DATE").val());
		
	    betw = getAfterMonth(addSlash(congra_date), 3);
	    dif = dayDiff(addSlash(begin_date), addSlash(betw));

	    betw2 = getAfterMonth(addSlash(begin_date), 3);
	    dif2 = dayDiff(addSlash(congra_date), addSlash(betw2));

	    if(dif < 0){
	        str = '경조를 신청할수 없습니다.\n\n경조발생일로부터 3개월 이전부터 신청할수 있습니다.';
	        alert(str);
	        return false;
	    }
	    if(dif2 < 0) {
	        str = '경조를 신청할수 없습니다.\n\n경조발생일로부터 3개월 이후에는 신청할수 없습니다.';
	        alert(str);
	        return false;
	    }
		
		
		
		// 경조발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다. -->필요한가...
		
		//데이터 포맷 모두 지우고 다시 넣음... 금액 활성화함...
		
		
		
		
		return true;
	}
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="tableArea">
	<h2 class="subtitle">경조금 신청 상세내역</h2>
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
			<td class="tdDate">
				<input class="readOnly" type="text" name="BEGDA" value="" id="BEGDA" readonly />
			</td>
			<th><label for="a1">결재일</label></th>
            <td colspan="3" class="tdDate"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
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
			data : {"AINF_SEQN" : AINF_SEQN}
		}).done(function(response) {
			if (response.success) {
				setTableText(response.storeData, "detailForm");
				changeRELA_CODE();
				fncSetFormReadOnly($("#detailForm"), true);
				fncSetFormReadOnly($("#readTable"), false);
				fncSetFormReadOnly($("#readTable"), true, new Array("labelReturn"));
				$("#rejectTxt").css("background", "white");
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
	};
	
	$(document).ready(function(){
		
		getEventMoneyComboList();
		
		$("#CONG_CODE").change(function(){changeRELA_CODE(true);rela_action();});
		$("#RELA_CODE").change(function(){rela_action();});
		$("#CONG_DATE").change(function(){event_CONG_DATE();});
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
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="tableArea">
	<h2 class="subtitle">콘도이용 신청 조회</h2>
	<div class="table">
		<form id="detailForm" name="detailForm">
			<table class="tableGeneral">
				<caption>콘도이용 신청</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_85p" />
				</colgroup>
				<tbody>
					<tr>
						<th><label for="inputText01-1">신청일</label></th>
						<td class="tdDate"><input class="readOnly" type="text"
							name="BEGDA" value="" id="BEGDA" readonly /></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputDateFrom">사용기간</label></th>
						<td class="periodpicker"><input name="DAY_IN" id="DAY_IN"
							type="text" placeholder="입실일" /> ~ <input name="DAY_OUT"
							id="DAY_OUT" type="text" placeholder="퇴실일" /></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputText01-3">사용일수</label></th>
						<td><input class="readOnly w80" type="text" name="DAY_USE"
							id="DAY_USE" value="" id="inputText01-3" readonly /> 박</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputText01-4">콘도명</label></th>
						<td><select name="CODE_CONDO" id="CODE_CONDO">
						</select> <select id="LOCA_CONDO" name="LOCA_CONDO">
						</select> <select id="SIZE_ROOM" name="SIZE_ROOM">
						</select> <select id="CUNT_ROOM" name="CUNT_ROOM">
								<option value="01">1실</option>
						</select></td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputText01-5">연락처</label></th>
						<td><input class="w150" type="text" name="TEL_NUM" value=""
							id="TEL_NUM" /><span class="noteItem colorRed">※ 해당 연락처로 예약정보 등이 발송됩니다. </span></td>
					</tr>
				</tbody>
				<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
			</table>
		</form>
	</div>
	<div class="tableComment">
		<p><span class="bold">2박신청시 1박씩 2건으로 신청하시기 바랍니다. </span></p>
	</div>
</div>
<!--// Table end -->
<script>
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getCondoDetail.json",
			dataType : "json",
			data : {
				"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'
			}
		}).done(function(response) {
			if (response.success) {
				setDetail(response.storeData);
			} else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});
		var setDetail = function(item) {
			item.DAY_USE = parseInt(item.DAY_USE);
		   	getCondoCode(0, true, item.CODE_CONDO, item.LOCA_CONDO, item.SIZE_ROOM, "", "");
		   	getCondoCode(1, false, item.CODE_CONDO, item.LOCA_CONDO, item.SIZE_ROOM, "", "");
		   	getCondoCode(2, false, item.CODE_CONDO, item.LOCA_CONDO, item.SIZE_ROOM, "", "");
			setTableText(item, "detailForm");

			if(item.CODE_CONDO == "08") { //생활연수원일 경우 뒤에 selectbox 못하게
	        	$("#LOCA_CONDO").hide();
	        	$("#SIZE_ROOM").hide();
	        	$("#CUNT_ROOM").hide();
			}
			fncSetFormReadOnly($("#detailForm"), true);
		}
	};

    var getCondoCode = function(level, empty, CODE_CONDO, LOCA_CONDO, SIZE_ROOM, DAY_IN, DAY_OUT) {
		$.ajax({
				type : "get",
				url : "/common/getCondoCodeList.json",
				dataType : "json",
        		async : false,
				data : {"CODE_CONDO" : CODE_CONDO,
					"LOCA_CONDO" : LOCA_CONDO,
					"SIZE_ROOM" : SIZE_ROOM,
					"DAY_IN" : DAY_IN,
					"DAY_OUT" : DAY_OUT}
			}).done(function(response) {
				if(response.success) {
					var res = response.storeData[level];
					if(level == 0 ) {
						if(empty) $("#LOCA_CONDO").empty();
		            	$("#LOCA_CONDO").append('<option value="">------선택------</option>');
		            	if(empty) $("#SIZE_ROOM").empty();
		            	$("#SIZE_ROOM").append('<option value="">------선택------</option>');
		            	$("#CODE_CONDO").append('<option value="">------선택------</option>');
				        $.each(res, function (index, item) {
				        	if(CODE_CONDO == item.CODE_CONDO)
				        		$("#CODE_CONDO").append('<option value=' + item.CODE_CONDO + ' selected>' + item.NAME_CONDO + '</option>');
				        	else
					        	$("#CODE_CONDO").append('<option value=' + item.CODE_CONDO + '>' + item.NAME_CONDO + '</option>');
				        });
					} else if (level == 1) {
						if(empty) { 
							$("#LOCA_CONDO").empty();
		            		$("#LOCA_CONDO").append('<option value="">------선택------</option>');
						}
		            	if(empty) {
		            		$("#SIZE_ROOM").empty();
			            	$("#SIZE_ROOM").append('<option value="">------선택------</option>');
		            	}
				        $.each(res, function (index, item) {
				        	if(LOCA_CONDO == item.LOCA_CONDO)
				        		$("#LOCA_CONDO").append('<option value=' + item.LOCA_CONDO + ' selected>' + item.NAME_LOCA + '</option>');
				        	else
					        	$("#LOCA_CONDO").append('<option value=' + item.LOCA_CONDO + '>' + item.NAME_LOCA + '</option>');
				        });
					} else if (level == 2) {
						if(empty) {
							$("#SIZE_ROOM").empty();
			            	$("#SIZE_ROOM").append('<option value="">------선택------</option>');
						}
				        $.each(res, function (index, item) {
				        	if(SIZE_ROOM == item.SIZE_ROOM)
					        	$("#SIZE_ROOM").append('<option value=' + item.SIZE_ROOM + ' selected>' + item.NAME_SIZE + '</option>');
				        	else
					        	$("#SIZE_ROOM").append('<option value=' + item.SIZE_ROOM + '>' + item.NAME_SIZE + '</option>');
				        });
					}
				}
	    		else
	    			alert("콘도코드 조회시 오류가 발생하였습니다. " + response.message);
		});
    }
	$(document).ready(function() {
		detailSearch();
	});

	var reqModifyActionCallBack = function() {
		var periodpicker = $('.periodpicker');
		
		for(var i=0;i<periodpicker.length;i++){
			//date 찾아오기
			var dateInput = $(periodpicker[i]).find('input');
			$.each(dateInput, function(i, data){
				var fid = dateInput[0].id;
				var tid = dateInput[1].id;
				$(data).datepicker({
					defaultDate: "+1w",
		            onClose: function (selectedDate) {
		            	if(i==0){
		            		$("#"+tid).datepicker('option', 'minDate', selectedDate);
		            	} else {
		            		$("#"+fid).datepicker('option', 'maxDate', selectedDate);
		            	}
		            }
		        });
			});
		}
		fncSetFormReadOnly($("#detailForm"), false, new Array("BEGDA", "DAY_USE"));
		if($("#detailForm #CODE_CONDO option:selected").val() == "08") { //생활연수원일 경우 뒤에 selectbox 못하게
        	$("#LOCA_CONDO").hide();
        	$("#SIZE_ROOM").hide();
        	$("#CUNT_ROOM").hide();
		}
	}

	var reqDeleteActionCallBack = function() {
		if (confirm("삭제 하시겠습니까?")) {
			$("#reqDeleteBtn").prop("disabled", true);
			$("#AINF_SEQN").val('${AINF_SEQN}');
			var param = $("#detailForm").serializeArray();
			$("#detailDecisioner").jsGrid("serialize", param);
			jQuery.ajax({
				type : 'post',
				url : '/appl/deleteCondo',
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
	}

	var reqCancelActionCallBack = function() {
		$("#detailForm").each(function() {
			this.reset();
		});
		$("#CODE_CONDO").empty();
		$("#LOCA_CONDO").empty();
    	$("#SIZE_ROOM").empty();
		destroydatepicker("detailForm");
		detailSearch();
	}

	$("#detailForm #CODE_CONDO").change(function() {
		if($("#detailForm #CODE_CONDO option:selected").val() == "08") { //생활연수원일 경우 뒤에 selectbox 못하게
        	$("#LOCA_CONDO").hide();
        	$("#SIZE_ROOM").hide();
        	$("#CUNT_ROOM").hide();
		} else {
        	$("#LOCA_CONDO").show();
        	$("#SIZE_ROOM").show();
        	$("#CUNT_ROOM").show();
    		getCondoCode(1, true, $("#detailForm #CODE_CONDO option:selected").val(), "", "", "");
		}
	});

	$("#detailForm #LOCA_CONDO").change(function() {
    	getCondoCode(2, true, $("#detailForm #CODE_CONDO option:selected").val(), $("#detailForm #LOCA_CONDO option:selected").val(), "", "");
	});
	//사용일수 DAY_IN, DAY_OUT
    $("#detailForm #DAY_IN, #detailForm #DAY_OUT").change(function() {
    	$("#detailForm #DAY_USE").val("");
        if($("#detailForm #DAY_IN").val() != "" && $("#detailForm #DAY_OUT").val() != "" && isDate($("#detailForm #DAY_IN").val()) && isDate($("#detailForm #DAY_OUT").val())){
            var begd = removePoint($("#detailForm #DAY_IN").val());
            var endd = removePoint($("#detailForm #DAY_OUT").val());
            var diff = parseInt(endd) - parseInt(begd);
            
            if (diff >0) {
               bday = new Date(begd.substring(0,4),begd.substring(4,6)-1,begd.substring(6,8));
               eday = new Date(endd.substring(0,4),endd.substring(4,6)-1,endd.substring(6,8));
               var betday = getDayInterval(bday,eday);
	        		$("#detailForm #DAY_USE").val((betday-1));
            }
        } 
	});

	var reqSaveActionCallBack = function() {
		if (checkDetailFormValid()) {
			if (confirm("저장하시겠습니까?")) {
				$("#reqSaveBtn").prop("disabled", true);
				$("#AINF_SEQN").val('${AINF_SEQN}');
				var param = $("#detailForm").serializeArray();
				$("#detailDecisioner").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'post',
					url : '/appl/updateCondo',
					cache : false,
					dataType : 'json',
					data : param,
					async : false,
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
			return false;
		}

	};
	var checkDetailFormValid = function() {
		if($("#detailForm #DAY_IN").val() == "" || !isDate($("#detailForm #DAY_IN").val())) {
			alert("입실일을 입력하세요.");
			$("#inputDateFrom").focus();
			return false;
		}
		if($("#detailForm #DAY_OUT").val() == "" || !isDate($("#detailForm #DAY_OUT").val())) {
			alert("퇴실일을 입력하세요.");
			$("#inputDateTo").focus();
			return false;
		}
	    //신청년도와 여행시작년도만비교
	    var begin_date = removePoint($("#detailForm #BEGDA").val());
	    var trvl_begd = removePoint($("#detailForm #DAY_IN").val());
	    var trvl_endd = removePoint($("#detailForm #DAY_OUT").val());

	    be = begin_date.substring(0,4);
	    tr = trvl_begd.substring(0,4);

	    if (trvl_begd != "" && trvl_endd != "") {
	       //if(be != tr){
		//		alert("현재년도만 신청가능합니다.");
		//	return false;
	     //  }              
	       if(trvl_begd > trvl_endd){
				alert("입실일이 퇴실일보다 먼저 입니다.");
			return false;
	       }  
	    }
		if($("#detailForm #CODE_CONDO").prop("selectedIndex")==0){
			alert("콘도를 선택하세요.");
			$("#detailForm #CODE_CONDO").focus();
			return false;
		}
		if($("#detailForm #CODE_CONDO option:selected").val() != "08"){
			if($("#detailForm #LOCA_CONDO").prop("selectedIndex")==0){
				alert("지역을 선택하세요.");
				$("#detailForm #LOCA_CONDO").focus();
				return false;
			} 
			if($("#detailForm #SIZE_ROOM").prop("selectedIndex")==0){
				alert("평형을 선택하세요.");
				$("#detailForm #SIZE_ROOM").focus();
				return false;
			}
		}
			 
		if($("#detailForm #TEL_NUM").val()==0){
			alert("연락처를 입력하세요. (- 포함)");
			$("#detailForm #TEL_NUM").focus();
			return false;
		}
		if(!mobileCheck($("#detailForm #TEL_NUM").val()) && !phoneCheck($("#detailForm #TEL_NUM").val())){
			alert("연락처를 정확히 입력하세요. (- 포함)");
			$("#detailForm #TEL_NUM").focus();
			return false;
		}
		return true;
	}
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="tableArea">
	<h2 class="subtitle">콘도지원비 신청 상세내역</h2>
	<div class="table">
		<form id="detailForm" name="detailForm">
			<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
			<input type="hidden" id="CODE_CONDO" name="CODE_CONDO">
			<input type="hidden" id="LOCA_CONDO" name="LOCA_CONDO">
			<input type="hidden" id="SIZE_ROOM" name="SIZE_ROOM">
			<table class="tableGeneral">
				<caption>콘도지원비 신청</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_35p" />
					<col class="col_15p" />
					<col class="col_35p" />
				</colgroup>
				<tbody>
					<tr>
						<th><label for="inputText02-1">신청일</label></th>
						<td class="tdDate"><input class="readOnly"
							type="text" name="BEGDA"
							value=""
							id="BEGDA" readonly /></td>
						<th><label for="a1">결재일</label></th>
						<td colspan="3" class="tdDate">
							<input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly">
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputDateFrom">사용기간</label></th>
						<td colspan="3" class="tdDate"><input class="readOnly"
							type="text" value="" id="DAY_IN" name="DAY_IN" readonly /> ~ <input
							class="readOnly" type="text" value="" id="DAY_OUT" name="DAY_OUT"
							readonly /> <input class="readOnly w40" type="text"
							name="DAY_USE" value="" id="DAY_USE" readonly /> 박</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputText02-3">콘도명</label></th>
						<td colspan="3"><input class="readOnly w80" type="text"
							name="NAME_CONDO" value="" id="NAME_CONDO" readonly /> <input
							class="readOnly w80" type="text" name="NAME_LOCA" value=""
							id="NAME_LOCA" readonly /> <input class="readOnly w80"
							type="text" name="NAME_SIZE" value="" id="NAME_SIZE" readonly />
							<input class="readOnly w40" type="text" name="CUNT_ROOM" value=""
							id="CUNT_ROOM" readonly /> (객실수)</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="inputText02-4">신청금액</label></th>
						<td><input class="inputMoney w150" type="text" name="MONEY"
							id="MONEY" onkeyup="cmaComma(this);" onchange="cmaComma(this);"
							value=""></td>
						<th><span class="textPink">*</span><label for="inputDate01">결제일</label></th>
						<td class="mydatepicker"><input type="text" id="DATE_CARD"
							name="DATE_CARD" /></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>
<!--// Table end -->
<script>
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getCondoFeeDetail.json",
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
			item.MONEY = parseInt(item.MONEY).format();
			setTableText(item, "detailForm");
			if (item.CODE_CONDO == "08") { //생활연수원일 경우 뒤에 selectbox 못하게
				$("#LOCA_CONDO").hide();
				$("#SIZE_ROOM").hide();
				$("#CUNT_ROOM").hide();
			}
			setCondoName(item);
			fncSetFormReadOnly($("#detailForm"), true);
		}
	};

	$(document).ready(function() {
		detailSearch();
	});

	var setCondoName = function(item) {
		$.ajax({
			type : "get",
			url : "/common/getCondoCodeList.json",
			dataType : "json",
			data : {"CODE_CONDO" : item.CODE_CONDO,
				"LOCA_CONDO" : item.LOCA_CONDO,
				"SIZE_ROOM" : item.SIZE_ROOM,
				"DAY_IN" : item.DAY_IN,
				"DAY_OUT" : item.DAY_OUT}
			}).done(function(response) {
				if(response.success) {
					var res = response.storeData;
					var result = $.grep(res[0], function(element, index) {
						   return (element.CODE_CONDO === item.CODE_CONDO);
					});
					$("#detailForm #NAME_CONDO").val(result[0].NAME_CONDO);

					var result = $.grep(res[1], function(element, index) {
						   return (element.LOCA_CONDO === item.LOCA_CONDO);
					});
					$("#detailForm #NAME_LOCA").val(result[0].NAME_LOCA);

					var result = $.grep(res[2], function(element, index) {
						   return (element.SIZE_ROOM === item.SIZE_ROOM);
					});
					if(result.length > 0)
						$("#detailForm #NAME_SIZE").val(result[0].NAME_SIZE);
				}
				else
					alert("콘도코드 조회시 오류가 발생하였습니다. " + response.message);
			});
	}
	
</script>

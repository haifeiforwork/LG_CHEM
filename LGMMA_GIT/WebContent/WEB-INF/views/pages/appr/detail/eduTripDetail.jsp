<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="tableArea">
<form id="detailForm">
	<input type="hidden" name="TAB_F01" id="TAB_F01" />
	<h2 class="subtitle">교육/출장 신청 상세내역</h2>
	<div class="table">
		<table class="tableGeneral">
		<caption>교육,출장 신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_85p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText02-1">신청일</label></th>
			<td class="tdDate">
				<input type="text" id="BEGDA" name="BEGDA" value="" />
			</td>
		</tr>	
		<tr>
			<th><label for="a1">결재일</label></th>
            <td class="tdDate"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
		</tr>
		<tr id="awartArea1">
			<th><span class="textPink">*</span><label for="input_radio01_1">신청구분</label></th>
			<td>
				<input type="radio" name="AWART" id="AWART"   value="0010" checked="checked"/><label for="input_radio01_1">교육</label>
				<input type="radio" name="AWART" id="AWART"   value="0020" /><label for="input_radio01_1">출장</label>
			</td>
		</tr>
		<tr id="awartArea2" style="display:none;">
			<th><span class="textPink">*</span><label for="input_radio01_1">신청구분</label></th>
			<td>
				<input type="radio" name="AWART" id="AWART"   value="0010" /><label for="input_radio01_1">필수교육</label>
				<input type="radio" name="AWART" id="AWART"   value="0011" /><label for="input_radio01_1">선택교육</label>
				<input type="radio" name="AWART" id="AWART"   value="0020" /><label for="input_radio01_1">출장</label>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="inputText02-3">구분</label></th>
			<td>
			<select  name="OVTM_CODE" id="OVTM_CODE" required>
					<option value="">-------------</option>
			</select>
			
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="inputText02-3">신청사유</label></th>
			<td>
				<input class="wPer" type="text" name="REASON" id="REASON"/>
			</td>
		</tr>
		<tr>
			<th><label for="inputText02-2">대근자</label></th>
			<td>
				<input class="w300" type="text" name="OVTM_NAME"  size="40" maxlength="40" value="" /> 
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="inputDateFrom">신청기간</label></th>
			<td class="mydatepicker">
				<input id="APPL_FROM" name="APPL_FROM" type="text" size="10" required/>
				~
				<input id="APPL_TO"   name="APPL_TO"  type="text" size="10"required/>
			</td>
		</tr>
        <tr id="inputTimeArea" style="display:none;">
            <th><label>신청시간</label></th>
            <td class="tdDate">
                <select class="w50" id="BEGUZ_HH" name="BEGUZ_HH">
<%
      for( int i = 0 ; i < 24 ; i++) {
          String temp = Integer.toString(i);
%>
              <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
      }
%>
          </select>
          :
          <select class="w50" id="BEGUZ_MM" name="BEGUZ_MM" >
<%
      for( int i = 0 ; i < 60 ; i+=10) {
          String temp = Integer.toString(i);
%>
              <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
      }
%>
          </select>
          ~
          <select class="w50" id="ENDUZ_HH" name="ENDUZ_HH" >
<%
      for( int i = 0 ; i < 24 ; i++) {
          String temp = Integer.toString(i);
%>
              <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
      }
%>
          </select>
          :
          <select class="w50" id="ENDUZ_MM" name="ENDUZ_MM" >
<%
      for( int i = 0 ; i < 60 ; i+=10) {
          String temp = Integer.toString(i);
%>
              <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
      }
%>
          </select>
            </td>
        </tr>
		</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
		<input type="hidden" id="PERNR" name="PERNR">
		<div class="tableComment">
			<p><span class="bold">안내사항</span></p>
			<ul>
				<li>근무 OFF시, 교육인 경우에는 교육시간만큼 초과근무 신청하시기 바랍니다. (O/T 자동발생 안됨)</li>
				<li>전일 교육 및 출장의 경우, 교육, 출장 근태 신청 바랍니다.</li>
			</ul>
		</div>
	</div>
	</form>
</div>
<script type="text/javascript">
	
	var detailSearch = function() {
		$.ajax({
			type : "get",
			url : "/appl/getEduTripDetail.json",
			dataType : "json",
			data : {
					"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>',
					"PERNR" : '<c:out value="${PERNR}" />'
					}
		}).done(function(response) {
			if(response.success) {
				var arr = response.storeData[0]
				var tabFlag = response.tabFlag;
				
				if(tabFlag == 'Y') {
					$("#awartArea1").remove();
					$("#awartArea2").show();
					
					$('#BEGUZ_HH').val(arr.BEGUZ.substring(0, 2));
					$('#BEGUZ_MM').val(arr.BEGUZ.substring(2, 4));
					$('#ENDUZ_HH').val(arr.ENDUZ.substring(0, 2));
					$('#ENDUZ_MM').val(arr.ENDUZ.substring(2, 4));
				} else {
					$("#awartArea2").remove();
					$("#awartArea1").show();
				}
				
				$("#PERNR").val(arr.PERNR);
				$("#TAB_F01").val(tabFlag);
				
				setDetail(arr);
				getEduWorkCode(arr.AWART,arr.PERNR,arr.OVTM_CODE);
			}else{
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
			}
		});
	}
	
	var setDetail = function(item){
		setTableText(item, "detailForm");
		fncSetFormReadOnly($("#detailForm"), false);
		fncSetFormReadOnly($("#detailForm"), true, new Array("labelReturn"));
		$("#rejectTxt").css("background", "white");
	}
	
	$(document).ready(function(){
		detailSearch();
	});
	
	$('input[name="AWART"]').change(function(){
		var AWART = $(':radio[name="AWART"]:checked').val();
		var PERNR = $("#PERNR").val();
		getEduWorkCode(AWART,PERNR);
	});
	
	var getEduWorkCode = function(AWART,PERNR,OVTM_CODE) {
		var tabFlag = $("#TAB_F01").val();
		if(tabFlag == 'Y' && (AWART == '0010' || AWART == '0011')) {
			$('#inputTimeArea').show();
		} else {
			$('#BEGUZ_HH').val('00');
			$('#BEGUZ_MM').val('00');
			$('#ENDUZ_HH').val('00');
			$('#ENDUZ_MM').val('00');
			
			$('#inputTimeArea').hide();
		}
		
		jQuery.ajax({
			type : 'POST',
			url : '/work/getEduWorkCode.json',
			cache : false,
			dataType : 'json',
			data : {
				"AWART" : AWART,
				"PERNR" : PERNR
			},
			async :false,
			success : function(response) {
				if(response.success){
					setEduCodeOption(response.storeData, OVTM_CODE);
					
				}else{
					alert("신청사유코드 조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	var setEduCodeOption = function(jsonData,OVTM_CODE) {
		$('#OVTM_CODE').empty();
		$('#OVTM_CODE').append('<option value=\"\">-------------</option>');
		$.each(jsonData, function (key, value) {
			if(OVTM_CODE == value.SCODE){
				$('#OVTM_CODE').append('<option value=' + value.SCODE + ' selected>' + value.STEXT + '</option>');
			}else{
				$('#OVTM_CODE').append('<option value=' + value.SCODE + '>' + value.STEXT + '</option>');
			}
		});
	}
	
</script>
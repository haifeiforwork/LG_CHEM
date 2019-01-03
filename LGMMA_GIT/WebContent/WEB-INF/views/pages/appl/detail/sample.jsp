<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!--// Table start -->	
<div class="tableArea">
	<h2 class="subtitle">휴가신청 조회</h2>
	<div class="table">
		<table class="tableGeneral">
		<caption>휴가신청</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_85p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText01-1">신청일</label></th>
			<td class="tdDate">
				<input type="text" name="" value="2016.10.19" id="inputText01-1" readonly />
			</td>
		</tr>	
		<tr>
			<th><span class="textPink">*</span><label for="input_radio01_1">휴가구분</label></th>
			<td>
				<ul class="tdRadioList">
                    <li><input type="radio" name="radio01" value="" id="input_radio01_1" checked="checked" disabled /><label for="input_radio01_1">전일휴가</label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_2" disabled /><label for="input_radio01_2" >반일휴가(전반)</label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_3" disabled /><label for="input_radio01_3">반일휴가(후반)</label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_4" disabled /><label for="input_radio01_4">모성보호휴가</label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_5" disabled /><label for="input_radio01_5">유휴</label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_6" disabled /><label for="input_radio01_6">하계휴가</label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_7" disabled /><label for="input_radio01_7">경조공가</label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_8" disabled /><label for="input_radio01_8">전일공가</label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_8" disabled /><label for="input_radio01_9">시간공가 </label></li>
					<li><input type="radio" name="radio01" value="" id="input_radio01_10" disabled /><label for="input_radio01_10">보건휴가</label></li>
				</ul>
            </td>
        </tr>
        <tr>
			<th><span class="textPink">*</span><label for="inputText01-2">신청사유</label></th>
			<td>		
				<input class="wPer" type="text" name="" value="개인사정" id="inputText01-2" />
			</td>
		</tr>
		<tr>
			<th><label for="inputText01-3">대근자</label></th>
			<td>
				<input type="text" name="" value="" id="inputText01-3" />
				<span class="noteItem colorRed">※ 교대조는 필수입력 사항입니다. </span>
			</td>
		</tr>
		<tr>
			<th><label for="inputText01-4">잔여휴가일수</label></th>
			<td>
				<input class="alignCenter" type="text" name="" value="9.5/0" id="inputText01-4" readonly/> 일
				<span class="noteItem colorBlue">(연월차/하계)</span>
			</td>
		</tr>
                       <tr>
			<th><span class="textPink">*</span><label for="inputDateFrom">휴가기간</label></th>
			<td class="tdDate">
				<input id="inputDateFrom" type="text" readonly />
				~
				<input id="inputDateTo" type="text" readonly />
			</td>
		</tr>							
		<tr>
			<th><label for="inputHour">신청시간</label></th>
			<td class="tdDate">								
				<input id="inputHour" type="text" readonly />
				~
				<input id="inputHour" type="text" readonly />
                <span class="noteItem colorRed">※ 신청시간은 반일휴가 또는 시간공가의 경우에만 입력 가능합니다.</span>
			</td>
		</tr>
		<tr>
			<th><label for="inputDay">휴가공제일수</label></th>
			<td>								
				<input class="alignRight" id="inputDay" type="text" value="1.0" readonly />
				일
			</td>
		</tr>	
		</tbody>
		</table>
	</div>
	<div class="tableComment">
		<p><span class="bold">유휴(휴일비근무)는 전문기술직 전용 휴가구분입니다. </span></p>
	</div>							
</div>	
<!--// Table end -->	

<!--// list end -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.DateTime"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="hris.D.D03Vocation.rfc.D03VocationAReasonRFC"%>
<%@ page import="hris.D.D03Vocation.D03RemainVocationData"%>
<%@ page import="hris.E.E19Congra.rfc.E19CongCodeRFC"%>
<%@ page import="hris.D.D03Vocation.D03VocationReasonData"%>

<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("managedUser"));
	D03RemainVocationData dataRemain = (D03RemainVocationData)request.getAttribute("d03RemainVocationData");
	String tabId = (String)request.getAttribute("TAB_ID");
	
	Vector CodeEntity_vt = new Vector();
	int endYear         = Integer.parseInt( DataUtil.getCurrentYear() );
	for( int i = endYear-9 ; i <= endYear+1 ; i++ ){
		CodeEntity entity = new CodeEntity();
		entity.code  = Integer.toString(i);
		entity.value = Integer.toString(i);
		CodeEntity_vt.addElement(entity);
	}

%>
<!--// Page Title start -->
<div class="title">
	<h1>휴가</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">근태</a></span></li>
			<li class="lastLocation"><span><a href="#">휴가</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
<!--------------- layout body start --------------->
<!--// Tab2 start -->
<div class="tabUnder tab2">
	<div class="tableArea">
		<h2 class="subtitle">휴가실적조회</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>휴가실적조회</caption>
			<colgroup>
				<col class="col_10p" />
				<col class="col_15p" />
				<col class="col_10p" />
				<col class="col_15p" />
				<col class="col_10p" />
				<col class="col_15p" />
				<col class="col_10p" />
				<col class="col_15p" />
			</colgroup>
			<tbody>
				<tr>
					<th><label for="year">조회년도</label></th>
					<td>
						<select class="w90" id="year" name="year"> 
							<%= WebUtil.printOption(CodeEntity_vt, Integer.toString(endYear)) %>
						</select>
					</td>
					<th><label for="BALSENG_ILSU">발생일수</label></th>
					<td>
						<input class="readOnly alignRight" type="text" name="BALSENG_ILSU" id="BALSENG_ILSU" readonly="readonly" />
					</td>
					<th><label for="ABRTG_SUM">사용일수</label></th>
					<td>
						<input class="readOnly alignRight" type="text" name="ABRTG_SUM" id="ABRTG_SUM" readonly="readonly" />
					</td>
					<th><label for="JAN_ILSU">잔여일수</label></th>
					<td>
						<input class="readOnly alignRight" type="text" name="JAN_ILSU" id="JAN_ILSU" readonly="readonly" />
					</td>
				</tr>
			</tbody>
			</table>
		</div>
	</div>
	<!--// list start -->
	<div class="listArea">	
		<h2 class="subtitle">휴가발생내역</h2>	
		<div id="balSengListGrid"></div>
	</div>
	<!--// list end -->	
	<!--// list start -->
	<div class="listArea">	
		<h2 class="subtitle">휴가사용내역</h2>
		<div id="saYongListGrid"></div>
	</div>
	<!--// list end -->
	
	<!--// list start -->
	<div class="listArea" id="sajunListArea">
		<h2 class="subtitle">사전부여휴가내역</h2>
		<div id="saJunListGrid"></div>
		<div class="totalArea">
			<strong>사전부여휴가 잔여일수</strong>
			<span class="number"><input type="text" id="ABRTG_SUM3" class="alignRight readOnly wPer" readonly ></span>
		</div>
	</div>
	
	<!--// list end -->
	
	<div class="listArea" id="selectListArea">
		<h2 class="subtitle">선택적보상휴가내역</h2>
		<div id="selectListGrid"></div>
		<div class="totalArea" >
			<strong>선택적보상휴가 보상일수</strong>
			<span class="number"><input type="text" id="ABRTG_SUM1" class="alignRight readOnly wPer" readonly ></span>
			<strong>선택적보상휴가 잔여일수</strong>
			<span class="number"><input type="text" id="ABRTG_SUM2" class="alignRight readOnly wPer" readonly ></span>
		</div>
	</div>
	
	<div class="tableComment" id="saJuntableComment">
		<p><span class="bold">용어설명</span></p>
		<ul>
			<li class="saJunComment selectComment"><strong>잔여일수</strong> : 발생한 휴가중 미사용 휴가일수로서 당해년도 말에 보상 가능한 휴가 일수</li> 
			
			<li class="saJunComment"><strong>사전부여휴가</strong> : 근속1년 미만자에게 부여되는 휴가로서 매월 만근한 자에 한하여 발생하며, 당해년도 12월21일에 발생할 년차휴가의 일부를 미리 발생시킨 휴가</li>
			<li class="saJunComment"><strong>사전부여휴가 잔여일수</strong> : 발생한 사전부여휴가중 미사용한 휴가일수로서 당해년도에는 보상하지 않음</li> 
			
			<li class="selectComment"><strong>선택적보상휴가</strong> : 4조3교대 근무자의 주단위 40시간을 초과하는 2시간 근무에 대해서 월 단위로 부여하는 휴가</li>
			<li class="selectComment"><strong>선택적보상휴가 잔여일수</strong> : 매월 근태마감시 사용하지 않은 잔여휴가에 대해 고정O/T로 보상</li> 
		</ul>
	</div>
</div>
<!--// Tab2 end -->

<script type="text/javascript">
	
	$(document).ready(function(){
		$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=18&gridDivId=tab1ApplGrid');
		$("#OVTM_CODE1").hide();
		$("#OVTM_CODE2").hide();
		$("#CONG_CODE").hide();
		$("#BEGUZ_MM").val("00").prop("disabled",true).addClass('readOnly');
		$("#BEGUZ_HH").val("00").prop("disabled",true).addClass('readOnly');
		$("#ENDUZ_MM").val("00").prop("disabled",true).addClass('readOnly');
		$("#ENDUZ_HH").val("00").prop("disabled",true).addClass('readOnly');
		
		$("#Message_1").hide();
		
		$("#tab1").bind("click", function(){
			$("#OVTM_CODE1").hide();
			$("#OVTM_CODE2").hide();
			$("#CONG_CODE").hide();
			$("#BEGUZ_MM").val("00").prop("disabled",true).addClass('readOnly');
			$("#BEGUZ_HH").val("00").prop("disabled",true).addClass('readOnly');
			$("#ENDUZ_MM").val("00").prop("disabled",true).addClass('readOnly');
			$("#ENDUZ_HH").val("00").prop("disabled",true).addClass('readOnly');
			$("#Message_1").hide();

			$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=18&gridDivId=tab1ApplGrid');
		});
		
//		$("#tab2").bind("click", function(){
			$("#sajunListArea").show();
			$(".saJunComment").show();
			$("#selectListArea").show();
			$(".selectComment").show();
			
			$("#balSengListGrid").jsGrid({data: []});
			$("#saYongListGrid").jsGrid({data: []});
			$("#saJunListGrid").jsGrid({data: []});
			$("#selectListGrid").jsGrid({data: []});
			
			searchTab2();
//		});

		if('<%=tabId%>' == "1"){
			$("#tab1").click();
		}
		if('<%=tabId%>' == "2"){
			$("#tab2").click();
		}
	});
	
	var searchTab2 = function(){
		jQuery.ajax({
			type : 'POST',
			url : '/manager/work/getVacationList.json',
			cache : false,
			dataType : 'json',
			data : {
				"year" : $("#year option:selected").val()
			},
			async :false,
			success : function(response) {
				if(response.success){
					var eAuth = response.E_AUTH;
		            var nonAbsence = response.NON_ABSENCE;
		            var longService = response.LONG_SERVICE;
		            var flexible = response.FLEXIBLE;
		            var comptime = response.COMPTIME;
		            var compenCnt = response.COMPEN_CNT;
		            var occurResult = response.OCCUR_RESULT;   // 발생내역
		            var occurResult1 = response.OCCUR_RESULT1; // 사전부여 발생내역
		            var occurResult2 = response.OCCUR_RESULT2; // 선택적보상 발생내역
		            var occurResult3 = response.OCCUR_RESULT3; // 보상 발생내역
		            var usedResult = response.USED_RESULT ;    // 사용내역
		            var usedResult1 = response.USED_RESULT1;   // 사전부여 사용내역
		            var usedResult2 = response.USED_RESULT2;   // 선택적보상 사용내역
		            var usedResult3 = response.USED_RESULT3;   // 보상 사용내역(사용)
		            var usedResult4 = response.USED_RESULT4;   // 보상 사용내역(보상)
		            var sWork = response.S_WORK;
					
		         	// 발생일수
		            $("#BALSENG_ILSU").val(parseFloat(sWork.OCCUR).toFixed(2));
		            // 사용일수
		            $("#ABRTG_SUM").val(parseFloat(sWork.ABWTG).toFixed(2));
		            // 잔여일수
		            $("#JAN_ILSU").val(parseFloat(sWork.ZKVRB).toFixed(2));
					
		            $("#balSengListGrid").jsGrid( "insertItem", { th00 : "개근연차", th01 : "", th02 : "", th03 : "", th04 : "", th05 : "", th06 : "", th07 : "", th08 : "", th09 : "", th10 : "", th11 : "", th12 : "", th13 : nonAbsence.format() } );
		            $("#balSengListGrid").jsGrid( "insertItem", { th00 : "근속연차", th01 : "", th02 : "", th03 : "", th04 : "", th05 : "", th06 : "", th07 : "", th08 : "", th09 : "", th10 : "", th11 : "", th12 : "", th13 : longService.format() } );
		            // 보상휴가
		            if (eAuth == 'Y') {
		                $("#balSengListGrid").jsGrid("insertItem", {
		                    th00 : "보상휴가",
		                    th01 : (occurResult3.ANZHL01 == "" || occurResult3.ANZHL01 == "0") ? "" : parseFloat(occurResult3.ANZHL01).toFixed(2),
		                    th02 : (occurResult3.ANZHL02 == "" || occurResult3.ANZHL02 == "0") ? "" : parseFloat(occurResult3.ANZHL02).toFixed(2),
		                    th03 : (occurResult3.ANZHL03 == "" || occurResult3.ANZHL03 == "0") ? "" : parseFloat(occurResult3.ANZHL03).toFixed(2),
		                    th04 : (occurResult3.ANZHL04 == "" || occurResult3.ANZHL04 == "0") ? "" : parseFloat(occurResult3.ANZHL04).toFixed(2),
		                    th05 : (occurResult3.ANZHL05 == "" || occurResult3.ANZHL05 == "0") ? "" : parseFloat(occurResult3.ANZHL05).toFixed(2),
		                    th06 : (occurResult3.ANZHL06 == "" || occurResult3.ANZHL06 == "0") ? "" : parseFloat(occurResult3.ANZHL06).toFixed(2),
		                    th07 : (occurResult3.ANZHL07 == "" || occurResult3.ANZHL07 == "0") ? "" : parseFloat(occurResult3.ANZHL07).toFixed(2),
		                    th08 : (occurResult3.ANZHL08 == "" || occurResult3.ANZHL08 == "0") ? "" : parseFloat(occurResult3.ANZHL08).toFixed(2),
		                    th09 : (occurResult3.ANZHL09 == "" || occurResult3.ANZHL09 == "0") ? "" : parseFloat(occurResult3.ANZHL09).toFixed(2),
		                    th10 : (occurResult3.ANZHL10 == "" || occurResult3.ANZHL10 == "0") ? "" : parseFloat(occurResult3.ANZHL10).toFixed(2),
		                    th11 : (occurResult3.ANZHL11 == "" || occurResult3.ANZHL11 == "0") ? "" : parseFloat(occurResult3.ANZHL11).toFixed(2),
		                    th12 : (occurResult3.ANZHL12 == "" || occurResult3.ANZHL12 == "0") ? "" : parseFloat(occurResult3.ANZHL12).toFixed(2),
		                    th13 : (comptime == "" || comptime == "0") ? "0" : parseFloat(comptime).toFixed(2)
		                });
		            }
		            $("#balSengListGrid").jsGrid( "insertItem", { th00 : "유연휴가", th01 : "", th02 : "", th03 : "", th04 : "", th05 : "", th06 : "", th07 : "", th08 : "", th09 : "", th10 : "", th11 : "", th12 : "", th13 : flexible.format() } );

		            //휴가사용내역
		            if (usedResult.ABRTG_SUM != null && usedResult.ABRTG_SUM != '') {
		                $("#saYongListGrid").jsGrid("insertItem", {
		                    th00 : "연차",
		                    th01 : usedResult.ABRTG01 == "0" ? "" : parseFloat(usedResult.ABRTG01).toFixed(2),
		                    th02 : usedResult.ABRTG02 == "0" ? "" : parseFloat(usedResult.ABRTG02).toFixed(2),
		                    th03 : usedResult.ABRTG03 == "0" ? "" : parseFloat(usedResult.ABRTG03).toFixed(2),
		                    th04 : usedResult.ABRTG04 == "0" ? "" : parseFloat(usedResult.ABRTG04).toFixed(2),
		                    th05 : usedResult.ABRTG05 == "0" ? "" : parseFloat(usedResult.ABRTG05).toFixed(2),
		                    th06 : usedResult.ABRTG06 == "0" ? "" : parseFloat(usedResult.ABRTG06).toFixed(2),
		                    th07 : usedResult.ABRTG07 == "0" ? "" : parseFloat(usedResult.ABRTG07).toFixed(2),
		                    th08 : usedResult.ABRTG08 == "0" ? "" : parseFloat(usedResult.ABRTG08).toFixed(2),
		                    th09 : usedResult.ABRTG09 == "0" ? "" : parseFloat(usedResult.ABRTG09).toFixed(2),
		                    th10 : usedResult.ABRTG10 == "0" ? "" : parseFloat(usedResult.ABRTG10).toFixed(2),
		                    th11 : usedResult.ABRTG11 == "0" ? "" : parseFloat(usedResult.ABRTG11).toFixed(2),
		                    th12 : usedResult.ABRTG12 == "0" ? "" : parseFloat(usedResult.ABRTG12).toFixed(2),
		                    th13 : parseFloat(usedResult.ABRTG_SUM).toFixed(2)
		                });
		            } else {
		                $("#saYongListGrid").jsGrid("insertItem", {
		                    th00 : "연차", th01 : "", th02 : "", th03 : "", th04 : "", th05 : "", th06 : "", th07 : "", th08 : "", th09 : "", th10 : "", th11 : "", th12 : "", th13 : "0"
		                });
		            }
					
		            var month ="00";
		            var sum =0;
		            var vacationTh01 = "";
		            var vacationTh02 = "";
		            var vacationTh03 = "";
		            var vacationTh04 = "";
		            var vacationTh05 = "";
		            var vacationTh06 = "";
		            var vacationTh07 = "";
		            var vacationTh08 = "";
		            var vacationTh09 = "";
		            var vacationTh10 = "";
		            var vacationTh11 = "";
		            var vacationTh12 = "";

		            for (var i = 0; i < response.d03Vacation_vt.length; i++) {
		                var item9 = response.d03Vacation_vt[i];
		                var years = (item9.DATUM+'').substring(5,7);

		                if (month == years) {
		                    sum += parseFloat(item9.ABRTG);
		                } else {
		                    if (month != 00) {
		                        if (month == 01) vacationTh01 = parseFloat(sum).toFixed(2);
		                        if (month == 02) vacationTh02 = parseFloat(sum).toFixed(2);
		                        if (month == 03) vacationTh03 = parseFloat(sum).toFixed(2);
		                        if (month == 04) vacationTh04 = parseFloat(sum).toFixed(2);
		                        if (month == 05) vacationTh05 = parseFloat(sum).toFixed(2);
		                        if (month == 06) vacationTh06 = parseFloat(sum).toFixed(2);
		                        if (month == 07) vacationTh07 = parseFloat(sum).toFixed(2);
		                        if (month == 08) vacationTh08 = parseFloat(sum).toFixed(2);
		                        if (month == 09) vacationTh09 = parseFloat(sum).toFixed(2);
		                        if (month == 10) vacationTh10 = parseFloat(sum).toFixed(2);
		                        if (month == 11) vacationTh11 = parseFloat(sum).toFixed(2);
		                        if (month == 12) vacationTh12 = parseFloat(sum).toFixed(2);
		                    }
		                    sum = parseFloat(item9.ABRTG);
		                    month = years;
		                }
		                if (i == response.d03Vacation_vt.length-1) {
		                    if (month == 01) vacationTh01 = parseFloat(sum).toFixed(2);
		                    if (month == 02) vacationTh02 = parseFloat(sum).toFixed(2);
		                    if (month == 03) vacationTh03 = parseFloat(sum).toFixed(2);
		                    if (month == 04) vacationTh04 = parseFloat(sum).toFixed(2);
		                    if (month == 05) vacationTh05 = parseFloat(sum).toFixed(2);
		                    if (month == 06) vacationTh06 = parseFloat(sum).toFixed(2);
		                    if (month == 07) vacationTh07 = parseFloat(sum).toFixed(2);
		                    if (month == 08) vacationTh08 = parseFloat(sum).toFixed(2);
		                    if (month == 09) vacationTh09 = parseFloat(sum).toFixed(2);
		                    if (month == 10) vacationTh10 = parseFloat(sum).toFixed(2);
		                    if (month == 11) vacationTh11 = parseFloat(sum).toFixed(2);
		                    if (month == 12) vacationTh12 = parseFloat(sum).toFixed(2);
		                }
		            }

		            // 보상휴가 사용내역
		            if (eAuth == 'Y') {
		                $("#saYongListGrid").jsGrid("insertItem", {
		                    th00 : "보상휴가(사용)",
		                    th01 : (usedResult3.ABRTG01 == "" || usedResult3.ABRTG01 == "0") ? "" : parseFloat(usedResult3.ABRTG01).toFixed(2),
		                    th02 : (usedResult3.ABRTG02 == "" || usedResult3.ABRTG02 == "0") ? "" : parseFloat(usedResult3.ABRTG02).toFixed(2),
		                    th03 : (usedResult3.ABRTG03 == "" || usedResult3.ABRTG03 == "0") ? "" : parseFloat(usedResult3.ABRTG03).toFixed(2),
		                    th04 : (usedResult3.ABRTG04 == "" || usedResult3.ABRTG04 == "0") ? "" : parseFloat(usedResult3.ABRTG04).toFixed(2),
		                    th05 : (usedResult3.ABRTG05 == "" || usedResult3.ABRTG05 == "0") ? "" : parseFloat(usedResult3.ABRTG05).toFixed(2),
		                    th06 : (usedResult3.ABRTG06 == "" || usedResult3.ABRTG06 == "0") ? "" : parseFloat(usedResult3.ABRTG06).toFixed(2),
		                    th07 : (usedResult3.ABRTG07 == "" || usedResult3.ABRTG07 == "0") ? "" : parseFloat(usedResult3.ABRTG07).toFixed(2),
		                    th08 : (usedResult3.ABRTG08 == "" || usedResult3.ABRTG08 == "0") ? "" : parseFloat(usedResult3.ABRTG08).toFixed(2),
		                    th09 : (usedResult3.ABRTG09 == "" || usedResult3.ABRTG09 == "0") ? "" : parseFloat(usedResult3.ABRTG09).toFixed(2),
		                    th10 : (usedResult3.ABRTG10 == "" || usedResult3.ABRTG10 == "0") ? "" : parseFloat(usedResult3.ABRTG10).toFixed(2),
		                    th11 : (usedResult3.ABRTG11 == "" || usedResult3.ABRTG11 == "0") ? "" : parseFloat(usedResult3.ABRTG11).toFixed(2),
		                    th12 : (usedResult3.ABRTG12 == "" || usedResult3.ABRTG12 == "0") ? "" : parseFloat(usedResult3.ABRTG12).toFixed(2),
		                    th13 : (usedResult3.ABRTG_SUM == "" || usedResult3.ABRTG_SUM == "0") ? "0" : parseFloat(usedResult3.ABRTG_SUM).toFixed(2)
		                });
		                
		                $("#saYongListGrid").jsGrid("insertItem", {
		                    th00 : "보상휴가(보상)",
		                    th01 : (usedResult4.ABRTG01 == "" || usedResult4.ABRTG01 == "0") ? "" : parseFloat(usedResult4.ABRTG01).toFixed(2),
		                    th02 : (usedResult4.ABRTG02 == "" || usedResult4.ABRTG02 == "0") ? "" : parseFloat(usedResult4.ABRTG02).toFixed(2),
		                    th03 : (usedResult4.ABRTG03 == "" || usedResult4.ABRTG03 == "0") ? "" : parseFloat(usedResult4.ABRTG03).toFixed(2),
		                    th04 : (usedResult4.ABRTG04 == "" || usedResult4.ABRTG04 == "0") ? "" : parseFloat(usedResult4.ABRTG04).toFixed(2),
		                    th05 : (usedResult4.ABRTG05 == "" || usedResult4.ABRTG05 == "0") ? "" : parseFloat(usedResult4.ABRTG05).toFixed(2),
		                    th06 : (usedResult4.ABRTG06 == "" || usedResult4.ABRTG06 == "0") ? "" : parseFloat(usedResult4.ABRTG06).toFixed(2),
		                    th07 : (usedResult4.ABRTG07 == "" || usedResult4.ABRTG07 == "0") ? "" : parseFloat(usedResult4.ABRTG07).toFixed(2),
		                    th08 : (usedResult4.ABRTG08 == "" || usedResult4.ABRTG08 == "0") ? "" : parseFloat(usedResult4.ABRTG08).toFixed(2),
		                    th09 : (usedResult4.ABRTG09 == "" || usedResult4.ABRTG09 == "0") ? "" : parseFloat(usedResult4.ABRTG09).toFixed(2),
		                    th10 : (usedResult4.ABRTG10 == "" || usedResult4.ABRTG10 == "0") ? "" : parseFloat(usedResult4.ABRTG10).toFixed(2),
		                    th11 : (usedResult4.ABRTG11 == "" || usedResult4.ABRTG11 == "0") ? "" : parseFloat(usedResult4.ABRTG11).toFixed(2),
		                    th12 : (usedResult4.ABRTG12 == "" || usedResult4.ABRTG12 == "0") ? "" : parseFloat(usedResult4.ABRTG12).toFixed(2),
		                    th13 : (usedResult4.ABRTG_SUM == "" || usedResult4.ABRTG_SUM == "0") ? "0" : parseFloat(usedResult4.ABRTG_SUM).toFixed(2)
		                });
		            }
		            
		         	// 하계 휴가
		            if ($("#year option:selected").val() == <%=DateTime.getYear()%>) {
		                $("#saYongListGrid").jsGrid("insertItem", {
		                    th00 : "하계휴가",
		                    th01 : vacationTh01,
		                    th02 : vacationTh02,
		                    th03 : vacationTh03,
		                    th04 : vacationTh04,
		                    th05 : vacationTh05,
		                    th06 : vacationTh06,
		                    th07 : vacationTh07,
		                    th08 : vacationTh08,
		                    th09 : vacationTh09,
		                    th10 : vacationTh10,
		                    th11 : vacationTh11,
		                    th12 : vacationTh12,
		                    th13 : parseFloat(response.E_ABRTG).toFixed(2)
		                });
		            }

		            // 사전부여휴가 발생 내역
		            if (occurResult1.ANZHL_SUM) {
		                $("#saJunListGrid").jsGrid("insertItem", {
		                    th00 : "발생일수",
		                    th01 : occurResult1.ANZHL01 == "0" ? "" : parseFloat(occurResult1.ANZHL01).toFixed(2),
		                    th02 : occurResult1.ANZHL02 == "0" ? "" : parseFloat(occurResult1.ANZHL02).toFixed(2),
		                    th03 : occurResult1.ANZHL03 == "0" ? "" : parseFloat(occurResult1.ANZHL03).toFixed(2),
		                    th04 : occurResult1.ANZHL04 == "0" ? "" : parseFloat(occurResult1.ANZHL04).toFixed(2),
		                    th05 : occurResult1.ANZHL05 == "0" ? "" : parseFloat(occurResult1.ANZHL05).toFixed(2),
		                    th06 : occurResult1.ANZHL06 == "0" ? "" : parseFloat(occurResult1.ANZHL06).toFixed(2),
		                    th07 : occurResult1.ANZHL07 == "0" ? "" : parseFloat(occurResult1.ANZHL07).toFixed(2),
		                    th08 : occurResult1.ANZHL08 == "0" ? "" : parseFloat(occurResult1.ANZHL08).toFixed(2),
		                    th09 : occurResult1.ANZHL09 == "0" ? "" : parseFloat(occurResult1.ANZHL09).toFixed(2),
		                    th10 : occurResult1.ANZHL10 == "0" ? "" : parseFloat(occurResult1.ANZHL10).toFixed(2),
		                    th11 : occurResult1.ANZHL11 == "0" ? "" : parseFloat(occurResult1.ANZHL11).toFixed(2),
		                    th12 : occurResult1.ANZHL12 == "0" ? "" : parseFloat(occurResult1.ANZHL12).toFixed(2),
		                    th13 : parseFloat(occurResult1.ANZHL_SUM).toFixed(2)
		                });
		            }

		            //사전부여휴가 사용 내역
		            if (usedResult1.ABRTG_SUM) {
		                $("#saJunListGrid").jsGrid("insertItem", {
		                    th00 : "사용일수",
		                    th01 : usedResult1.ABRTG01 == "0" ? "" : parseFloat(usedResult1.ABRTG01).toFixed(2),
		                    th02 : usedResult1.ABRTG02 == "0" ? "" : parseFloat(usedResult1.ABRTG02).toFixed(2),
		                    th03 : usedResult1.ABRTG03 == "0" ? "" : parseFloat(usedResult1.ABRTG03).toFixed(2),
		                    th04 : usedResult1.ABRTG04 == "0" ? "" : parseFloat(usedResult1.ABRTG04).toFixed(2),
		                    th05 : usedResult1.ABRTG05 == "0" ? "" : parseFloat(usedResult1.ABRTG05).toFixed(2),
		                    th06 : usedResult1.ABRTG06 == "0" ? "" : parseFloat(usedResult1.ABRTG06).toFixed(2),
		                    th07 : usedResult1.ABRTG07 == "0" ? "" : parseFloat(usedResult1.ABRTG07).toFixed(2),
		                    th08 : usedResult1.ABRTG08 == "0" ? "" : parseFloat(usedResult1.ABRTG08).toFixed(2),
		                    th09 : usedResult1.ABRTG09 == "0" ? "" : parseFloat(usedResult1.ABRTG09).toFixed(2),
		                    th10 : usedResult1.ABRTG10 == "0" ? "" : parseFloat(usedResult1.ABRTG10).toFixed(2),
		                    th11 : usedResult1.ABRTG11 == "0" ? "" : parseFloat(usedResult1.ABRTG11).toFixed(2),
		                    th12 : usedResult1.ABRTG12 == "0" ? "" : parseFloat(usedResult1.ABRTG12).toFixed(2),
		                    th13 : parseFloat(usedResult1.ABRTG_SUM).toFixed(2)
		                });
		            }

		            //사전부여휴가내역
		            var ABRTG_SUM3_CNT = 0;
		            if (occurResult1.ANZHL_SUM && usedResult1.ABRTG_SUM) {
		                ABRTG_SUM3_CNT = parseFloat(!occurResult1.ANZHL_SUM ? "0.00" : occurResult1.ANZHL_SUM) - parseFloat(!usedResult1.ABRTG_SUM ? "0.00" : usedResult1.ABRTG_SUM);
		                $("#ABRTG_SUM3").val(ABRTG_SUM3_CNT.toFixed(2));
		            } else if (occurResult1.ANZHL_SUM) {
		                $("#ABRTG_SUM3").val(parseFloat(occurResult1.ANZHL_SUM).toFixed(2));
		            } else {
		                $("#ABRTG_SUM3").val(parseFloat("0.00").toFixed(2));
		            }

		            //선택적 보상휴가 발생 내역
		            if (occurResult2.ANZHL_SUM) {
		                $("#selectListGrid").jsGrid("insertItem", {
		                    th00 : "발생일수",
		                    th01 : occurResult2.ANZHL01 == "0" ? "" : parseFloat(occurResult2.ANZHL01).toFixed(2),
		                    th02 : occurResult2.ANZHL02 == "0" ? "" : parseFloat(occurResult2.ANZHL02).toFixed(2),
		                    th03 : occurResult2.ANZHL03 == "0" ? "" : parseFloat(occurResult2.ANZHL03).toFixed(2),
		                    th04 : occurResult2.ANZHL04 == "0" ? "" : parseFloat(occurResult2.ANZHL04).toFixed(2),
		                    th05 : occurResult2.ANZHL05 == "0" ? "" : parseFloat(occurResult2.ANZHL05).toFixed(2),
		                    th06 : occurResult2.ANZHL06 == "0" ? "" : parseFloat(occurResult2.ANZHL06).toFixed(2),
		                    th07 : occurResult2.ANZHL07 == "0" ? "" : parseFloat(occurResult2.ANZHL07).toFixed(2),
		                    th08 : occurResult2.ANZHL08 == "0" ? "" : parseFloat(occurResult2.ANZHL08).toFixed(2),
		                    th09 : occurResult2.ANZHL09 == "0" ? "" : parseFloat(occurResult2.ANZHL09).toFixed(2),
		                    th10 : occurResult2.ANZHL10 == "0" ? "" : parseFloat(occurResult2.ANZHL10).toFixed(2),
		                    th11 : occurResult2.ANZHL11 == "0" ? "" : parseFloat(occurResult2.ANZHL11).toFixed(2),
		                    th12 : occurResult2.ANZHL12 == "0" ? "" : parseFloat(occurResult2.ANZHL12).toFixed(2),
		                    th13 : parseFloat(occurResult2.ANZHL_SUM).toFixed(2)
		                });
		            }

		            // 선택적 보상 휴가 사용 내역
		            if (usedResult2.ABRTG_SUM) {
		                $("#selectListGrid").jsGrid("insertItem", {
		                    th00 : "사용일수",
		                    th01 : usedResult2.ABRTG01 == "0" ? "" : parseFloat(usedResult2.ABRTG01).toFixed(2),
		                    th02 : usedResult2.ABRTG02 == "0" ? "" : parseFloat(usedResult2.ABRTG02).toFixed(2),
		                    th03 : usedResult2.ABRTG03 == "0" ? "" : parseFloat(usedResult2.ABRTG03).toFixed(2),
		                    th04 : usedResult2.ABRTG04 == "0" ? "" : parseFloat(usedResult2.ABRTG04).toFixed(2),
		                    th05 : usedResult2.ABRTG05 == "0" ? "" : parseFloat(usedResult2.ABRTG05).toFixed(2),
		                    th06 : usedResult2.ABRTG06 == "0" ? "" : parseFloat(usedResult2.ABRTG06).toFixed(2),
		                    th07 : usedResult2.ABRTG07 == "0" ? "" : parseFloat(usedResult2.ABRTG07).toFixed(2),
		                    th08 : usedResult2.ABRTG08 == "0" ? "" : parseFloat(usedResult2.ABRTG08).toFixed(2),
		                    th09 : usedResult2.ABRTG09 == "0" ? "" : parseFloat(usedResult2.ABRTG09).toFixed(2),
		                    th10 : usedResult2.ABRTG10 == "0" ? "" : parseFloat(usedResult2.ABRTG10).toFixed(2),
		                    th11 : usedResult2.ABRTG11 == "0" ? "" : parseFloat(usedResult2.ABRTG11).toFixed(2),
		                    th12 : usedResult2.ABRTG12 == "0" ? "" : parseFloat(usedResult2.ABRTG12).toFixed(2),
		                    th13 : parseFloat(usedResult2.ABRTG_SUM).toFixed(2)
		                });
		            } else {
		                if (occurResult2.ANZHL_SUM) {
		                    $("#selectListGrid").jsGrid("insertItem", {
		                        th00 : "사용일수", th01 : "" , th02 : "" , th03 : "" , th04 : "" , th05 : "" , th06 : "" , th07 : "" , th08 : "" , th09 : "" , th10 : "" , th11 : "" , th12 : "" , th13 : "0"
		                    });
		                }
		            }

		            //선택적 보상휴가 보상일수
		            var ABRTG_SUM_CNT = 0;
		            if (compenCnt.length > 0) {
		                ABRTG_SUM_CNT = parseFloat(!compenCnt ? "0.00" : compenCnt);
		                $("#ABRTG_SUM1").val(ABRTG_SUM_CNT.toFixed(2));
		            } else {
		                $("#ABRTG_SUM1").val(parseFloat("0.00").toFixed(2));
		            }

		            var ABRTG_SUM2_CNT = 0;
		            if (occurResult2.ANZHL_SUM && usedResult2.ABRTG_SUM) {
		                ABRTG_SUM2_CNT  = parseFloat(!occurResult2.ANZHL_SUM ? "0.00" : occurResult2.ANZHL_SUM) - parseFloat(!usedResult2.ABRTG_SUM ? "0.00" : usedResult2.ABRTG_SUM) - parseFloat(compenCnt);
		                $("#ABRTG_SUM2").val(ABRTG_SUM2_CNT.toFixed(2))
		            } else if (occurResult2.ANZHL_SUM != "") {
		                ABRTG_SUM2_CNT =  parseFloat(!occurResult2.ANZHL_SUM ? "0.00" : occurResult2.ANZHL_SUM) - parseFloat(compenCnt);
		                $("#ABRTG_SUM2").val(ABRTG_SUM2_CNT.toFixed(2));
		            } else {
		                ABRTG_SUM2_CNT =  parseFloat("0.00") - parseFloat(compenCnt);
		                $("#ABRTG_SUM2").val(ABRTG_SUM2_CNT.toFixed(2));
		            }

		            // 없으면 Hide
		            var isSajunCommentHide = false;
		            if (!$("#saJunListGrid").jsGrid("dataCount")) {
		                $("#sajunListArea, .saJunComment").hide();
		                isSajunCommentHide = true;
		            }

		            if (!$("#selectListGrid").jsGrid("dataCount")) {
		                $("#selectListArea, .selectComment").hide();
		                
		                if(isSajunCommentHide) $('#saJuntableComment').hide();
		            }
		            if (!$("#saJunListGrid").jsGrid("dataCount") && !$("#selectListGrid").jsGrid("dataCount")) {
		                $(".janyeoComment").hide();
		            }
					
				}else{
					alert("휴가실적 조회시 오류가 발생하였습니다.\n\n" + response.message);
				}
			}
		});
	}
	
	
	$("#year").change(function(){
		$("#balSengListGrid").jsGrid({data: []});
		$("#saYongListGrid").jsGrid({data: []});
		$("#saJunListGrid").jsGrid({data: []});
		$("#selectListGrid").jsGrid({data: []});
		
		searchTab2();
	});
	
	
	// 휴가구분 변경시
	$("input:radio[name='awartRadio']").change(function(){
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		$("#REASON").val("");

		// 경조공가
		if(radioCheck == '0130'){
			$("#CONG_CODE").show();
			$("#Message_1").show();
		}else{
			$("#CONG_CODE").hide().val("");
			$("#Message_1").hide();
		}
		
		// 전일공가
		if(radioCheck == '0170'){
			$("#OVTM_CODE1").show();
		}else{
			$("#OVTM_CODE1").hide().val("");
		}
		
		// 시간공가
		if(radioCheck == '0180'){
			$("#OVTM_CODE2").show();
		}else{
			$("#OVTM_CODE2").hide().val("");
		}
		
		// 신청시간 체크
		if( radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' ) { // 반일휴가(전반, 후반), 시간공가
			$("#BEGUZ_MM").prop("disabled",false).removeClass('readOnly');
			$("#BEGUZ_HH").prop("disabled",false).removeClass('readOnly');
			$("#ENDUZ_MM").prop("disabled",false).removeClass('readOnly');
			$("#ENDUZ_HH").prop("disabled",false).removeClass('readOnly');
		} else {       // 나머지 휴가구분의 경우
			$("#BEGUZ_MM").val("00").prop("disabled",true).addClass('readOnly');
			$("#BEGUZ_HH").val("00").prop("disabled",true).addClass('readOnly');
			$("#ENDUZ_MM").val("00").prop("disabled",true).addClass('readOnly');
			$("#ENDUZ_HH").val("00").prop("disabled",true).addClass('readOnly');
			
		}
		
		$("#AWART").val(radioCheck);
		
		
		// 공제일수
		if( radioCheck =='0110' ) { // 전일휴가
			$("#DEDUCT_DATE").val('1');
		} else if( radioCheck == '0123' || radioCheck == '0124' ){   // 반일휴가(전반, 후반)
			$("#DEDUCT_DATE").val('0.5');
		}else if( radioCheck == '0180' ){   // 시간공가
			$("#DEDUCT_DATE").val('0');
		} else {
			$("#DEDUCT_DATE").val('0');
		}
		
	});
	
	
	// 결조공가 사유 선택시
	$("#CONG_CODE").change(function(){
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		if (radioCheck == '0130' && $("#CONG_CODE option:selected").val() == "9001" ) {//자녀출산(유급)
			$("#AWART").val("0131");                    
		} else if (radioCheck == '0130' && $("#CONG_CODE option:selected").val() == "9002" ) {//자녀출산(무급)
			$("#AWART").val("0132");                    
		} else if (radioCheck == '0130' ) {//경조공가
			$("#AWART").val("0130");
		}
	});
	
	
	$("#BEGUZ_HH, #BEGUZ_MM").change(function(){
		$("#BEGUZ").val($("#BEGUZ_HH").val() + $("#BEGUZ_MM").val());
	});
	
	$("#ENDUZ_HH, #ENDUZ_MM").change(function(){
		$("#ENDUZ").val($("#ENDUZ_HH").val() + $("#ENDUZ_MM").val());
	});

	
	// 휴가 신청 처리
	$("#requestVacationBtn").click(function(){
		if(requestVacationChk()){
			if(confirm("신청 하시겠습니까?")){
				$("#requestVacationBtn").prop("disabled", true);
				
				var param = $("#vacationForm").serializeArray();
				$("#tab1ApplGrid").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'POST',
					url : '/manager/work/requestVacation.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							$("#vacationForm").each(function() {
								this.reset();
							});
							$('#decisionerTab1').load('/common/getDecisionerGrid?upmuType=18&gridDivId=tab1ApplGrid');
							
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#requestVacationBtn").prop("disabled", false);
					}
				});
			}
		}
	});
	
	var requestVacationChk = function(){
		if(!$("input:radio[name='awartRadio']").is(":checked")){
			alert("휴가구분을 선택하세요.");
			return false;
		}
			
		if(!checkNullField("vacationForm")){
			return false;
		}
		
		var radioCheck = $("input:radio[name='awartRadio']").filter(":checked").val();
		
		
		//하계휴가 신청시 잔여 하계휴가일수를 check한다. (2004.03.08)
		if( radioCheck == '0140' ) {
			if( $("#VACATI_DATE").val() == "0" ) {
				alert("하계휴가 잔여일수가 존재하지 않습니다.");
				return false;
			}
		}
		
		
		if( radioCheck == '0130'){
			if($("#CONG_CODE option:selected").val()==""){
				alert("경조공가 신청사유를 선택해주세요.");
				return false;
			}
		}else if( radioCheck == '0170'){
			if($("#OVTM_CODE1 option:selected").val()==""){
				alert("전일공가 신청사유를 선택해주세요.");
				return false;
			}
		}else if( radioCheck == '0180'){
			if($("#OVTM_CODE2 option:selected").val()==""){
				alert("시간공가 신청사유를 선택해주세요.");
				return false;
			}
		}
		
		// 전일 공가와 시간 공가  선택한 경우  ( 이동엽D)
		if ( radioCheck == '0170' ) {
			$("#OVTM_CODE").val($("#OVTM_CODE1 option:selected").val());
		}
		if ( radioCheck == '0180' ) {
			$("#OVTM_CODE").val($("#OVTM_CODE2 option:selected").val()); 
		}
		
		// 신청사유-80 입력시 길이 제한 
		if( $("#REASON").val() != "" && checkLength($("#REASON").val()) > 80 ){
			$("#REASON").val(limitKoText($("#REASON").val(), 80));
			alert("신청사유는 한글 40자, 영문 80자 이내여야 합니다.");
			$("#REASON").focus();
			$("#REASON").select();
			return false;
		}
		
		date_from  = removePoint($("#inputDateFrom").val());
		date_to    = removePoint($("#inputDateTo").val());
		
		if( radioCheck == '0123' || radioCheck == '0124' || radioCheck == '0180' ) { // 반일휴가(전반, 후반), 시간공가
			if( date_from != date_to ) {
				alert("반일휴가는 신청기간이 하루입니다.");
				return false;
			}
			
			//  반일휴가일경우 신청시간 체크..??
			if( $("#BEGUZ").val() > $("#ENDUZ").val() ) {
				alert("신청시작 시간이 신청종료 시간보다 큽니다.");
				return false;
			}

<%
	//  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다.
	if( !userData.e_regno.equals("") && userData.e_regno.substring(6,7).equals("2") ) {
%>
		}else if( radioCheck == '0150'){
			if( date_from != date_to ) {
				alert("잔여(보건) 휴가는 신청기간이 하루입니다.");
				return false;
			}
<%
	}
%>
		}else{
			if( date_from > date_to ) {
				alert("신청시작일이 신청종료일보다 큽니다.");
				return false;
			}
		}
		
		return true;
	}
	
	// 휴가 발생 내역 그리드
	$(function() {
		$("#balSengListGrid").jsGrid({
			height: "auto",
			width: "100%",
			autoload : false,
			paging: false,
			fields: [
				{ title: "구분", name: "th00", type: "text", align: "center", width:   "9%" },
				{ title: "1월", name: "th01", type: "number", align: "center", width: "7%" },
				{ title: "2월", name: "th02", type: "number", align: "center", width: "7%" },
				{ title: "3월", name: "th03", type: "number", align: "center", width: "7%" },
				{ title: "4월", name: "th04", type: "number", align: "center", width: "7%" },
				{ title: "5월", name: "th05", type: "number", align: "center", width: "7%" },
				{ title: "6월", name: "th06", type: "number", align: "center", width: "7%" },
				{ title: "7월", name: "th07", type: "number", align: "center", width: "7%" },
				{ title: "8월", name: "th08", type: "number", align: "center", width: "7%" },
				{ title: "9월", name: "th09", type: "number", align: "center", width:  "7%" },
				{ title: "10월", name: "th10", type: "number", align: "center", width: "7%" },
				{ title: "11월", name: "th11", type: "number", align: "center", width: "7%" },
				{ title: "12월", name: "th12", type: "number", align: "center", width: "7%" },
				{ title: "계", name: "th13", type: "number", align: "center", width:   "7%" }
			]
		});
	});
	
	// 휴가 사용 내역 그리드
	$(function() {
		$("#saYongListGrid").jsGrid({
			height: "auto",
			width: "100%",
			autoload : false,
			paging: false,
			fields: [
				{ title: "구분", name: "th00", type: "text", align: "center", width:   "9%" },
				{ title: "1월", name: "th01", type: "number", align: "center", width: "7%" },
				{ title: "2월", name: "th02", type: "number", align: "center", width: "7%" },
				{ title: "3월", name: "th03", type: "number", align: "center", width: "7%" },
				{ title: "4월", name: "th04", type: "number", align: "center", width: "7%" },
				{ title: "5월", name: "th05", type: "number", align: "center", width: "7%" },
				{ title: "6월", name: "th06", type: "number", align: "center", width: "7%" },
				{ title: "7월", name: "th07", type: "number", align: "center", width: "7%" },
				{ title: "8월", name: "th08", type: "number", align: "center", width: "7%" },
				{ title: "9월", name: "th09", type: "number", align: "center", width:  "7%" },
				{ title: "10월", name: "th10", type: "number", align: "center", width: "7%" },
				{ title: "11월", name: "th11", type: "number", align: "center", width: "7%" },
				{ title: "12월", name: "th12", type: "number", align: "center", width: "7%" },
				{ title: "계", name: "th13", type: "number", align: "center", width:   "7%" }
			]
		});
	});
	
	// 사전부여 휴가내역 그리드
	$(function() {
		$("#saJunListGrid").jsGrid({
			height: "auto",
			width: "100%",
			autoload : false,
			paging: false,
			fields: [
				{ title: "구분", name: "th00", type: "text", align: "center", width:   "9%" },
				{ title: "1월", name: "th01", type: "number", align: "center", width: "7%" },
				{ title: "2월", name: "th02", type: "number", align: "center", width: "7%" },
				{ title: "3월", name: "th03", type: "number", align: "center", width: "7%" },
				{ title: "4월", name: "th04", type: "number", align: "center", width: "7%" },
				{ title: "5월", name: "th05", type: "number", align: "center", width: "7%" },
				{ title: "6월", name: "th06", type: "number", align: "center", width: "7%" },
				{ title: "7월", name: "th07", type: "number", align: "center", width: "7%" },
				{ title: "8월", name: "th08", type: "number", align: "center", width: "7%" },
				{ title: "9월", name: "th09", type: "number", align: "center", width:  "7%" },
				{ title: "10월", name: "th10", type: "number", align: "center", width: "7%" },
				{ title: "11월", name: "th11", type: "number", align: "center", width: "7%" },
				{ title: "12월", name: "th12", type: "number", align: "center", width: "7%" },
				{ title: "계", name: "th13", type: "number", align: "center", width:   "7%" }
			]
		});
	});
	
	// 선택적 보상 휴가 내역 그리드 
	$(function() {
		$("#selectListGrid").jsGrid({
			height: "auto",
			width: "100%",
			autoload : false,
			paging: false,
			fields: [
				{ title: "구분", name: "th00", type: "text", align: "center", width:   "9%" },
				{ title: "1월", name: "th01", type: "number", align: "center", width: "7%" },
				{ title: "2월", name: "th02", type: "number", align: "center", width: "7%" },
				{ title: "3월", name: "th03", type: "number", align: "center", width: "7%" },
				{ title: "4월", name: "th04", type: "number", align: "center", width: "7%" },
				{ title: "5월", name: "th05", type: "number", align: "center", width: "7%" },
				{ title: "6월", name: "th06", type: "number", align: "center", width: "7%" },
				{ title: "7월", name: "th07", type: "number", align: "center", width: "7%" },
				{ title: "8월", name: "th08", type: "number", align: "center", width: "7%" },
				{ title: "9월", name: "th09", type: "number", align: "center", width:  "7%" },
				{ title: "10월", name: "th10", type: "number", align: "center", width: "7%" },
				{ title: "11월", name: "th11", type: "number", align: "center", width: "7%" },
				{ title: "12월", name: "th12", type: "number", align: "center", width: "7%" },
				{ title: "계", name: "th13", type: "number", align: "center", width:   "7%" }
			]
		});
	});
	
</script>
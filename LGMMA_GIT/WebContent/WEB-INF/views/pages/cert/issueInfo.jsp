<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A13Address.A13AddressListData" %>
<%@ page import="hris.A.A18Deduct.rfc.A18GuenTypeRFC" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%
	Vector a13AddressListData_vt = (Vector) request.getAttribute("a13AddressListData_vt");

	String e_stras = "";
	String e_locat = "";

	if (a13AddressListData_vt.size() > 0) {
		A13AddressListData data = (A13AddressListData) a13AddressListData_vt.get(0);
		e_stras = data.STRAS;
		e_locat = data.LOCAT;
	} else {
		e_stras = "";
		e_locat = "";
	}
	
	String curYear = DataUtil.getCurrentYear();
	String curMonth = DataUtil.getCurrentMonth();
%>
				<!--// Page Title start -->
				<div class="title">
					<h1>제증명 신청</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">제증명</a></span></li>
							<li class="lastLocation"><span><a href="#">제증명 신청</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->
				
				<!--------------- layout body start --------------->
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" onclick="switchTabs(this, 'tab1');" class="selected">재직증명서</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab2');" >근로소득·갑근세 원천징수 영수증</a></li>
						<li id="certHistoryTab"><a href="#" onclick="switchTabs(this, 'tab3');" >제증명 발행이력</a></li>
					</ul>
				</div>
				<!--// Tab end -->
				
				<!--// Tab1 start -->
				<div class="tabUnder tab1">
				<form name="empProofForm" id="empProofForm" method="post" action="">
					<!--// Table start -->	
					<div class="tableArea">
						<h2 class="subtitle withButtons">재직증명서 신청</h2>
							<div class="buttonArea">
								<ul class="btn_mdl">
									<li><a href="#" id="printAgreement"><span>보증용 발급합의서</span></a></li>
								</ul>
							</div>
							<div class="clear"> </div>
						<div class="table">
							<table class="tableGeneral">
							<caption>제증명 신청서 작성</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th>신청일</th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" id="emp_begda" size="20" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>" readonly="readonly" />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span>구분</th>
								<td>
									<select name="LANG_TYPE" id="emp_lang_type" class="w100" vname="구분" required>
										<option value="1">한글</option>
										<option value="2">영문</option>
									</select>
									<span class="noteItem">※  비자발급용은 국문으로 신청하셔도 가능합니다.</span>
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span>발행부수</th>
								<td>
								<select name="PRINT_NUM" id="emp_print_num" class="w100" vname="발행부수" required>
									<option value="1" selected>1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
									<option value="7">7</option>
									<option value="8">8</option>
									<option value="9">9</option>
									<option value="10">10</option>
								</select>
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span>발행방법</th>
								<td>
								<input type="radio" name="PRINT_CHK" value="1" id="emp_print_chk1" /><label for="input-radio01-1">본인 발행</label>
								<input type="radio" name="PRINT_CHK" value="2" id="emp_print_chk2" checked="checked"/><label for="input-radio01-2">담당부서 요청발행</label>
								</td>
							</tr>					
							<tr>
								<th><span class="textPink">*</span>현주소</th>
								<td>
									<input class="w400" type="text" name="ADDRESS1" id="address1" value="<%= e_stras %>" vname="현주소" required/>
									<input class="w400" type="text" name="ADDRESS2" id="address2" value="<%= e_locat %>"/>
									<p class="noteItem">※ 영문증명서를 신청하실 경우 현주소에 영문으로 입력해주세요.</p>				
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span>제출처</th>
								<td>
									<input class="w200" type="text" name="SUBMIT_PLACE" id="emp_submit_place" value="" vname="제출처" required/>
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span>용도</th>
								<td>
									<input class="w200" type="text" name="USE_PLACE" id="emp_use_place" value="" vname="용도" required/>
									<span class="noteItem">※ 보증용의 경우 배우자 또는 배우자 부재시 부모 합의서 제출요망</span>
								</td>
							</tr>	
							<tr>
								<th>특기사항</th>
								<td>
									<textarea name="SPEC_ENTRY" id="emp_spec_entry" cols="40" rows="4"> </textarea>
				                    <input type="hidden" name="SPEC_ENTRY1" id="emp_spec_entry1" >
				                    <input type="hidden" name="SPEC_ENTRY2" id="emp_spec_entry2" >
				                    <input type="hidden" name="SPEC_ENTRY3" id="emp_spec_entry3" >
				                    <input type="hidden" name="SPEC_ENTRY4" id="emp_spec_entry4" >
				                    <input type="hidden" name="SPEC_ENTRY5" id="emp_spec_entry5" >
								</td>
							</tr>	
							</tbody>
							</table>
						</div>
					</div>
					</form>	
					<!--// Table end -->		
					<!--// list start -->
					<div class="listArea" id="decisionerEmpProof">	
					</div>	
					<!--// list end -->				
					<div class="buttonArea">
						<ul class="btn_crud">
							<li><a class="darken" href="#" id="empProofBtn"><span>신청</span></a></li>
						</ul>
					</div>	
				</div>		
				
				<!--// Tab2 start -->
				
				<div class="tabUnder tab2 Lnodisplay">	
					<!--// Table start -->	
					<div class="tableArea">
						<h2 class="subtitle">근로소득·갑근세 원천징수 영수증</h2>							
						<div class="table">
							<form name="incomeTaxForm" id="incomeTaxForm">
							<table class="tableGeneral">
							<caption>근로소득·갑근세 원천징수 영수증 작성</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th>신청일</th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" id="inc_begda" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>" readonly="readonly" />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span>구분</th>
								<td>
									<select name="TYPE" id="inc_type" vname="구분" required>
				                      <option value="">--------------------------</option>
										<%= WebUtil.printOption((new A18GuenTypeRFC()).getGuenType()) %>
									</select>									
                  					<input type="hidden" name="GUEN_TYPE" id="inc_guen_type" value="">
								</td>
								<th><span class="textPink">*</span>발행부수</th>
								<td>
									<select name="PRINT_NUM" id="inc_print_num" class="w100" vname="발행부수" required>
				                      <option value="1" selected>1</option>
				                      <option value="2">2</option>
				                      <option value="3">3</option>
				                      <option value="4">4</option>
				                      <option value="5">5</option>
				                      <option value="6">6</option>
				                      <option value="7">7</option>
				                      <option value="8">8</option>
				                      <option value="9">9</option>
				                      <option value="10">10</option>
									</select>
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span>발행방법</th>
								<td colspan="3">
								<input type="radio" name="PRINT_CHK" value="1" id="inc_print_chk1" /><label for="input-radio01-1">본인 발행</label>
								<input type="radio" name="PRINT_CHK" value="2" id="inc_print_chk2" checked="checked"/><label for="input-radio01-2">담당부서 요청발행</label>
								</td>
							</tr>					
							<tr>
								<th><span class="textPink">*</span>제출처</th>
								<td>
									<input class="w200" type="text" name="SUBMIT_PLACE" id="inc_submit_place" value="" vname="제출처" required/>
								</td>
								<th><span class="textPink">*</span>사용목적</th>
								<td>
									<input class="w200" type="text" name="USE_PLACE" id="inc_use_place" value="" vname="사용목적" required/>
								</td>
							</tr>	
							<tr id="duringLayer1">
								<th><span class="textPink">*</span>선택기간</th>
								<td colspan="3">
                                   <input type="text" class="readOnly" size="6" name="EBEGDA" id="inc_ebegda" readonly/> 
                                   ~
                                   <input type="text" size="6" class="monthpicker" name="EENDDA" id="inc_eendda" readonly/>
								   <span class="noteItem">※  선택기간은 출력하기를 원하는 1년 단위의 기간을 입력한다. </span>
								</td>
							</tr>
							<tr>
								<th>특기사항</th>
								<td colspan="3">
									<textarea name="SPEC_ENTRY" id="inc_spec_entry" cols="40" rows="4"> </textarea>
				                    <input type="hidden" name="SPEC_ENTRY1" id="inc_spec_entry1" />
				                    <input type="hidden" name="SPEC_ENTRY2" id="inc_spec_entry2" />
				                    <input type="hidden" name="SPEC_ENTRY3" id="inc_spec_entry3" />
				                    <input type="hidden" name="SPEC_ENTRY4" id="inc_spec_entry4" />
				                    <input type="hidden" name="SPEC_ENTRY5" id="inc_spec_entry5" />
								</td>
							</tr>	
							</tbody>
							</table>
							</form>
						</div>
					</div>
					
					<!--// Table end -->		
					<!--// list start -->
					<div class="listArea" id="decisionerIncomeTax">	
					</div>	
					<!--// list end -->				
					<div class="buttonArea">
						<ul class="btn_crud">
							<li><a class="darken" href="#" id="incomeTaxBtn"><span>신청</span></a></li>
						</ul>
					</div>	
				</div>
				
				<!--// Tab2 end -->
				<!--// Tab3 start -->
				<div class="tabUnder tab3 Lnodisplay">	
				<h2 class="subtitle">제증명 발행이력</h2>
					<div id="certificateHistoryGrid" class="jsGridPaging"></div>
					<div class="tableComment">
						<p><span class="bold">
						본인발행 프린트 기능은 신청일로부터 1개월까지만 발행이 가능합니다.<br>
						본인발행 프린트 기능은 인쇄여부와 상관없이 인쇄창을 닫으면 발행기능이 사라집니다.<br>
						추가발행이 필요한 경우, 재신청하시기 바랍니다.
						</span></p>
					</div>	
				</div>
				<!--// Tab3 end -->		
				<!--------------- layout body end --------------->								
<!-- //print start -->
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>보증용 발급합의서</strong>
		<a href="#" class="btnClose popLayerPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer formPrintArea">
			<!-- 프린트 내용 -->
			<div class="printForm">
				<div class="printTitle">보증용 재직증명서 발급합의서</div>				
				<p class="centerTitle"><br><br>본인은 아래 합의자의 합의하에 보증용 재직증명서 발급을 신청합니다. </p>
				<p class="centerTitle">▣&nbsp;&nbsp;아&nbsp;&nbsp;&nbsp;&nbsp;래&nbsp;&nbsp;▣</p>
				<table class="printTB">
			      <tr>
			        <th width="6%" rowspan="4">보<br>증<br>인</th>
			        <th width="23%">사&nbsp;&nbsp;번</th>
			        <th width="24%">성&nbsp;&nbsp;명</th>
			        <th width="24%">주민등록번호</th>
			        <th width="23%">연락처</th>
			      </tr>
			      <tr>
			        <td>&nbsp;</td>
			        <td>&nbsp;</td>
			        <td>&nbsp;</td>
			        <td>&nbsp;</td>
			      </tr>
			      <tr>
			        <th>본&nbsp;&nbsp;적</th>
			        <td colspan="2">&nbsp;</td>
			        <th>발급매수</th>
			      </tr>
			      <tr>
			        <th>현주소</th>
			        <td colspan="2">&nbsp;</td>
			        <td>&nbsp;</td>
			      </tr>
			    </table>
			    <table class="printTB">
			      <tr>
			        <th width="6%" rowspan="4"> 합<br>의<br>자</th>
			        <th width="23%">관&nbsp;&nbsp;계</th>
			        <th width="24%">성&nbsp;&nbsp;명</th>
			        <th width="24%">주민등록번호</th>
			        <th width="23%">연락처</th>
			      </tr>
			      <tr>
			        <td>&nbsp;</td>
			        <td>&nbsp;</td>
			        <td>&nbsp;</td>
			        <td>&nbsp;</td>
			      </tr>
			    </table>
			    <table class="printSG">
			      <tr>
			        <td colspan="2" style="padding:140px 0 50px 0;">
			        	<table class="printTBIN">
			        		<tr>
			        		 <td width="76%" class="txtright">년</td>
			        		 <td width="12%" class="txtright">월</td>
			        		 <td width="12%" class="txtright">일</td>
			        		</tr>
			        	</table>			       	 
			        </td>
			      </tr>
			      <tr>
			        <td width="70%" class="txtright" style="padding:30px 0;">보 증 인 : </td>
			        <td width="30%">(印)</td>
			      </tr>
			      <tr>
			        <td class="txtright" style="padding:30px 0;">합 의 자 : </td>
			        <td>(印)</td>
			      </tr>
			      <tr>
			        <td colspan="2" style="padding-top:50px;" class="txtleft">* 합의자 자격 : 기혼자 - 배우자, 미혼자 - 부모<br>* 보증인과 합의자란은 서명 또는 날인함.</td>
			      </tr>
			    </table>
			</div>
			<!-- 프린트 영역 -->		
		</div>	
	</div>
	<div class="buttonArea buttonPrint">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="innerPrintAgreement"><span>프린트</span></a></li>								
			</ul>
		</div>	
		<div class="clear"> </div>	
</div>


<!-- 제증명 발행 -->
<!-- //print start -->
<div class="layerWrapper layerSizePdf" id="popLayerPrint2">
	<div class="layerHeader">
		<strong>제증명 출력</strong>
		<div class="tableComment">
		<p><span class="bold">
		PDF Viewer의 인쇄버튼을 클릭하여 인쇄하세요. 인쇄여부와 상관없이 인쇄창을 닫으면 발행기능이 사라집니다.
		</span></p>
		</div>
		<a href="#" class="btnClose popLayerPrint2_close" id="closePrint">창닫기</a>
	</div>
	
	<iframe id="iframeprint" name="iframeprint" src="" width="100%" height="100%">
	</iframe>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		$('#decisionerEmpProof').load('/common/getDecisionerGrid?upmuType=16&gridDivId=empProofDecisionerGrid');
    	$('#decisionerIncomeTax').load('/common/getDecisionerGrid?upmuType=28&gridDivId=incomeTaxDecisionerGrid');
    	$('.monthpicker').monthpicker();
		//empProofForm start
		$("#empProofBtn").click(function(){
			if(checkEmpProofFormValid()) {
				if(confirm("신청하시겠습니까?")) {
					setObjReadOnly($("#emp_print_num"), false);
					$("#empProofBtn").prop("disabled", true);
					var param = $("#empProofForm").serializeArray();
					param.push({name:"RowCount",value:$("#empProofDecisionerGrid").jsGrid("dataCount")});
					$("#empProofDecisionerGrid").jsGrid("serialize", param);
					jQuery.ajax({
		        		type : 'POST',
		        		url : '/cert/requestEmpProof',
		        		cache : false,
		        		dataType : 'json',
		        		data : param,
		        		async : false,
		        		success : function(response) {
		        			if(response.success) {
		        				alert("신청되었습니다.");
								$("#empProofForm").each(function() {  
									this.reset();  
								});  
		        			} else {
		        				alert("신청시 오류가 발생하였습니다. " + response.message);
		        			}
							$("#empProofBtn").prop("disabled", false);
		        		}
		        	});
				}
			}
		});

		var checkEmpProofFormValid = function() {
			//필수체크
			if(!checkNullField("empProofForm")) return false;	
			
			var address1 = $("#empProofForm #address1").val();//주소
			var address2 = $("#empProofForm #address2").val();
			var spec_entry = $("#empProofForm #emp_spec_entry").val();

			if( $("#empProofForm #emp_lang_type option:selected").val() == 2 ){
				if( !checkEnglish( $("#empProofForm #address1").val() ) ){
					alert("영문 주소 입력만 가능합니다.");
					$("#empProofForm #address1").focus();
					$("#empProofForm #address1").select();
					return false;
				}
				if( $("#empProofForm #address2").val() != "" ){
					if( !checkEnglish( $("#empProofForm #address2").val() ) ){
						alert("영문 주소 입력만 가능합니다.");
						$("#empProofForm #address2").focus();
						$("#empProofForm #address2").select();
						return false;
					}
				}
			}
			 
			
			if ( spec_entry != "" ) {
				textArea_to_TextFild( spec_entry, "#emp_spec_entry" );
			}
			return true;
		}
		// 글자수입력제한
		$("#address1, #address2").keyup(function(event){
		    val = $(this).val();
		    nam = this.name;
		    len = checkLength($(this).val());

		    if (event.keyCode ==13 )  {
				if(nam=="ADDRESS1"){
					$("#empProofForm #address2").focus();
		        }else if(nam=="ADDRESS2"){
		            this.blur();
		        }
			}

		    if( len > 79 ) {
		        vala = limitKoText(val,79);
		        this.blur();
		        $(this).val(vala);
		        $(this).focus();
		    }
		});

		
		var textArea_to_TextFild = function(text, devStr) {
		    var tmpText="";
		    var tmplength = 0;
		    var count = 1;
		    var flag = true;
		    for ( var i = 0; i < text.length; i++ ){
				tmplength = checkLength(tmpText);
				if( text.charCodeAt(i) != 13 && Number( tmplength ) < 60 ){
					tmpText = tmpText+text.charAt(i);
					flag = true
				} else {
					flag = false;
					tmpText.trim;
					$(devStr + count).val(tmpText); 
					tmpText=text.charAt(i);
					count++;
					if( count > 5 ){
						break;
					}
				}
			}

		   if( flag ) {
				$(devStr + count).val(tmpText); 
		   }
		}
		
		//empProofForm end
		//incomeTaxForm start
		$("#incomeTaxBtn").click(function(){
			if(checkIncomeTaxFormValid()) {
				if(confirm("신청하시겠습니까?")) {
					setObjReadOnly($("#inc_print_num"), false);
					$("#incomeTaxBtn").prop("disabled", true);
					var param = $("#incomeTaxForm").serializeArray();
					param.push({name:"RowCount",value:$("#incomeTaxDecisionerGrid").jsGrid("dataCount")});
					$("#incomeTaxDecisionerGrid").jsGrid("serialize", param);
					jQuery.ajax({
		        		type : 'POST',
		        		url : '/cert/requestIncomeTax',
		        		cache : false,
		        		dataType : 'json',
		        		data : param,
		        		async : false,
		        		success : function(response) {
		        			if(response.success) {
		        				alert("신청되었습니다.");
								$("#incomeTaxForm").each(function() {  
									this.reset();  
								});  
		        			} else {
		        				alert("신청시 오류가 발생하였습니다. " + response.message);
		        			}
							$("#incomeTaxBtn").prop("disabled", false);
		        		}
		        	});
				}
			}
		});
		
		$("#duringLayer1").hide();
		
		$("#inc_eendda").change(function() {
			chkCurDate();
		});
		
		var chkCurDate = function(){
			var toYear = $("#inc_eendda").val();
			var year = toYear.substr(0,4);
			var month = toYear.substr(5,7);
			
			if(Number(year)>Number("<%=curYear%>")||(Number(year)==Number("<%=curYear%>") && Number(month)>Number("<%=curMonth%>"))) {
				alert("현재일 이후는 입력하실 수 없습니다.");
				$("#inc_eendda").val("");
				$("#inc_eendda").focus();
			}
			
			calEbegda();
		}
		
		
		var calEbegda = function(){
			$("#inc_ebegda").val("");
			//1년계산함
			var toYear = $("#inc_eendda").val();
			if(toYear=="") return;
			var year = toYear.substr(0,4);
			var month = toYear.substr(5,7);
			month = Number(month)+1;
			
			if(month==13) {
				month = "01";
			} else {
				year = Number(year)-1;
				if(month<10) month = "0"+month;
			}
			
			$("#inc_ebegda").val(year+"."+month);
		}
		
		
		var checkIncomeTaxFormValid = function() {
			//필수체크
			if(!checkNullField("incomeTaxForm")) return false;	
			
			if($("#inc_type").val()=="0002"){ 
				calEbegda();
				if($("#inc_ebegda").val() == "" || $("#inc_eendda").val() == ""){
			 		alert("선택기간은 필수입력 항목입니다.");
					$("#inc_eendda").focus();
					return false;
				}
				chkCurDate();
			}
			
			
			
			//R3에서 필드 길이의 원인모를 에러로 도메인의 데이터 타입, 길이를 테이블과 맞출수가 없어서.. 이 방법으로 처리함.
			guen_type = $("#incomeTaxForm #inc_type option:selected").val();
			$("#incomeTaxForm #inc_guen_type").val(guen_type.substring(2, 4));

			if ( $("#incomeTaxForm #inc_spec_entry").val() != "" ) {
				textArea_to_TextFild( $("#incomeTaxForm #inc_spec_entry").val(), "#inc_spec_entry" );
			}
			return true;
		}

		$("#inc_type").change(this, function() {
			$("#inc_ebegda").val("");
			$("#inc_eendda").val("");
			
			if($(this).val() == "0002"){ //갑근세 원천징수 증명서
				$("#duringLayer1").show();
			} else {
				$("#duringLayer1").hide();
			}			
		});

		//incomeTaxForm end
		//팝업 띄우기
		$(function(){
			if($(".layerWrapper").length){
				//팝업 : 합의서 프린트
				$('#popLayerPrint').popup();
			}
		});
		
		//프린트 팝업 영역 설정
		$("#popLayerPrint").dialog({
		    autoOpen: false,
		    close: function() {
		    }
		});

		$("#printAgreement, #innerPrintAgreement").click(function() {
			$('#popLayerPrint').popup("show");
			$("#printContentsArea").print();
		});
		
		
		//제증명 이력조회
		$("#certHistoryTab").click(function() {
			//그리드
			$("#certificateHistoryGrid").jsGrid({
            	height: "auto",
                width: "100%",
                sorting: true,
                paging: true,
                autoload: true,
                pageSize: 10,
                pageButtonCount: 10,
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "GET",
							url : "/cert/getCertificateHistory.json",
							dataType : "json"
						}).done(function(response) {
							if(response.success) {
								d.resolve(response.storeData);
							}
			    			else
			    				alert("조회시 오류가 발생하였습니다. " + response.message);
						});
						return d.promise();
					}
				},
                fields: [
                    { title: "신청일", name: "REQS_DATE", type: "text", align: "center", width: "10%" },
                    { title: "업무구분", name: "UPMU_NAME", type: "text", align: "left", width: "20%" },
                    { title: "구분", name: "GUBUNTX", type: "text", align: "left", width: "16%" },
                    { title: "발행<br>부수", name: "PRINT_NUM", type: "text", align: "center", width: "6%" ,
                    	itemTemplate: function(value, item) {
    						return Number(value);
    					}
                    },
                    { title: "발행유형", name: "PRINT_CHK", type: "text", align: "left", width: "12%", 
                    	itemTemplate: function(value, item) {
    						return value=="1"?"본인 발행":"담당부서 요청발행";
    					}
                    },
                    { title: "제출처", name: "SUBMIT_PLACE", type: "text", align: "left", width: "14%" },
                    { title: "용도", name: "USE_PLACE", type: "text", align: "left", width: "14%" },
                    { title: "출력여부", name: "PRINT_END", type: "text", align: "center", width: "8%" ,
                    	itemTemplate: function(value, item) {
                    		if(value=="" && item.PRINT_CHK=="1" && chkDate(item.REQS_DATE)){
                				return "<div class=\"btn_mdl\"><a class=\"darken\" href=\"#\" onClick=\"certPrint('" + item.AINF_SEQN +"');\"><span>출력</span></a></div>";
                			} else {
                    			return "발행";
                			}
    					}
                    }
                ]
            });
		});
		
		
		var chkDate = function(reqDate){
			var begd  = removePoint(reqDate);
			var endd  = removePoint("<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>");
			//신청일 이전에는 못뽑음...
			if(Number(endd)<Number(begd)) return false;
			//신청일 한달 후는 못뽑음
			if(Number(endd)!=Number(begd)){
				var bday = new Date(begd.substring(0,4),begd.substring(4,6)-1,begd.substring(6,8));
				var eday = new Date(endd.substring(0,4),endd.substring(4,6)-1,endd.substring(6,8));
				var betday     = getDayInterval(bday,eday);
				if(betday> 31) return false; 
			}
			
			return true;
		}
		
		
		
		$("#closePrint").click(function(){
			$("#certificateHistoryGrid").jsGrid("search");
		});
		
		
		$("#emp_print_chk1, #emp_print_chk2").click(this, function() {
			var obj = $('#emp_print_num');
			setPRINT_CHK($(this).val(), obj);
		});
		
		$("#inc_print_chk1, #inc_print_chk2").click(this, function() {
			var obj = $('#inc_print_num');
			setPRINT_CHK($(this).val(), obj);
		});
		
		
		var setPRINT_CHK =  function(val, obj){
			var stat = false;
			//본인발행
			if(val=="1") stat = true;
			$(obj).val("1");
			setObjReadOnly(obj, stat);
		};
	
});

var certPrint = function(AINF_SEQN){
	$("#iframeprint").attr("src","/cert/certPdfPrint?AINF_SEQN=" + AINF_SEQN);
	$("#iframeprint").load(function(){
		$('#popLayerPrint2').popup("show");
	});
}
</script>

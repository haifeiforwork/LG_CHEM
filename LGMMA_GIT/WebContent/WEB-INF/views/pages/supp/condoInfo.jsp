<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
%>
				<!--// Page Title start -->
				<div class="title">
					<h1>콘도</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">복리후생</a></span></li>
							<li class="lastLocation"><span><a href="#">콘도</a></span></li>
						</ul>
					</div>
				</div>
				<!--// Page Title end -->
				
				<!--------------- layout body start --------------->
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" onclick="switchTabs(this, 'tab1');" class="selected">콘도이용 신청</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab2');">콘도지원비 신청</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab3');">콘도이용내역</a></li>
					</ul>
				</div>
				<!--// Tab end -->
				<div class="tabUnder tab1">
<%
	if(!request.getAttribute("OpenYn").equals("OK")) {
%>
				<div class="errorArea">
					<div class="errorMsg">	
						<div class="errorImg"><!-- 에러이미지 --></div>
						<div class="alertContent">
							<p>신청기간이 아닙니다.</p>
						</div>
					</div>
				</div>
<%
	} else {
%>
				<!--// Tab1 start -->
					
				<form name="reqCondoForm" id="reqCondoForm" method="post" action="">
				<input type="hidden" name="ZBIGO" size="100" class="input03">
					<!--// Table start -->	
					<div class="tableArea">
						<h2 class="subtitle">콘도이용 신청</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>콘도이용 신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" id="BEGDA" readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputDateFrom">사용기간</label></th>
                                <td class="tdDate">
									<input name="DAY_IN" id="inputDateFrom" type="text" placeholder="입실일" required vname="입실일"/>
									~
									<input name="DAY_OUT" id="inputDateTo" type="text" placeholder="퇴실일" required vname="퇴실일"/>
								</td>
                            </tr>
                            <tr>
								<th><span class="textPink">*</span><label for="inputText01-3">사용일수</label></th>
								<td>
									<input class="readOnly w80" type="text" name="DAY_USE" id="DAY_USE" value="" id="inputText01-3" readonly required vname="사용일수"/> 박
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputText01-4">콘도명</label></th>
								<td>	
									<select name="CODE_CONDO" id="CODE_CONDO">
									</select>  	
									<select id="LOCA_CONDO" name="LOCA_CONDO">
									</select>  
									<select id="SIZE_ROOM" name="SIZE_ROOM">
									</select>  
									<select id="CUNT_ROOM" name="CUNT_ROOM">
										<option value="01">1실</option>	
									</select>
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputText01-5">연락처</label></th>
								<td>
									<input class="w150" type="text" name="TEL_NUM" value="" id="TEL_NUM" required vname="연락처"/>
									<span class="noteItem colorRed">※ 해당 연락처로 예약정보 등이 발송됩니다. </span>
								</td>
							</tr>
							</tbody>
							</table>
						</div>
						<div class="tableComment">
							<p><span class="bold">2박신청시 1박씩 2건으로 신청하시기 바랍니다. </span></p>
							<p><span class="bold">콘도별 업무담당자</li>
							<ul>
								<li>강촌 / 곤지암 / 생활연수원 : 경영지원팀 박진희 (02-6930-3811)</li>
								<li>금호 / 대명 / 디오션 / 한화 : 인사노경팀 이혜정 (061-688-2521)</li>
							</ul>
						</div>
					</div>
					</form>
					<!--// list start -->
					<div class="listArea" id="decisioner" >
					</div>	
					<!--// Table end -->
					<div class="buttonArea">
						<ul class="btn_crud">
							<li><a class="darken" href="#" id="reqCondoBtn"><span>신청</span></a></li>
						</ul>
					</div>		
				
<%
	}
%>
				</div>
				<!--// Tab1 end -->
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">
					<!--// list start -->
					<div class="listArea">		
						<h2 class="subtitle">콘도이용 신청내역</h2>
						<div class="clear"></div>
						<div id="condoUsedForFeeGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
					</div>	
					<!--// list end -->
					<!------------------ 상세내역 start ------------------>
					<!--// Table start -->
					<form id="reqCondoFeeForm" name="reqCondoFeeForm">
					<input type="hidden" name="AINF_SEQN" id="AINF_SEQN">
					<input type="hidden" name="P_SEQN" id="P_SEQN">
					<input type="hidden" name="CODE_CONDO" name="CODE_CONDO">
					<input type="hidden" name="LOCA_CONDO" name="LOCA_CONDO">  
					<input type="hidden" name="SIZE_ROOM" name="SIZE_ROOM">  
					<div class="tableArea">
						<h2 class="subtitle">콘도지원비 신청</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>콘도지원비 신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText02-1">신청일</label></th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" id="BEGDA" readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputDateFrom">사용기간</label></th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" value="" id="DAY_IN" name="DAY_IN" readonly />
									~
									<input class="readOnly" type="text" value="" id="DAY_OUT" name="DAY_OUT" readonly />
									<input class="readOnly w40" type="text" name="DAY_USE" value="" id="DAY_USE" readonly /> 박 	
								</td>
                            </tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputText02-3">콘도명</label></th>
								<td colspan="3">	
									<input class="readOnly w80" type="text" name="NAME_CONDO" value="" id="NAME_CONDO" readonly />
									<input class="readOnly w80" type="text" name="NAME_LOCA" value="" id="NAME_LOCA" readonly />
									<input class="readOnly w80" type="text" name="NAME_SIZE" value="" id="NAME_SIZE" readonly />									 
									<input class="readOnly w40" type="text" name="CUNT_ROOM" value="" id="CUNT_ROOM" readonly /> (객실수)									 
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputText02-4">신청금액</label></th>
								<td>
									<input class="inputMoney w150" type="text" name="MONEY" id="MONEY" onkeyup="cmaComma(this);" onchange="cmaComma(this);" value="">																
								</td>
								<th><span class="textPink">*</span><label for="inputDate01">결제일</label></th>
								<td>
									<input type="text" class="datepicker" id="DATE_CARD" name="DATE_CARD"/>																	
								</td>
							</tr>
							<!-- tr>
								<th><label for="input_radio02_1">결제구분</label></th>
								<td>
									<input type="radio" name="METHOD" id="input_radio02_1" value="1" checked="checked" /><label for="input_radio02_1">개인카드</label>
									<input type="radio" name="METHOD" id="input_radio02_2" value="2" /><label for="input_radio02_1">현금</label>																	
								</td>
								<th><label for="inputText02-6">카드번호</label></th>
								<td>
									<input class="w150" type="text" name="NUMBER_CARD" value="" id="NUMBER_CARD" />
									<span class="noteItem">('-' 표시 없이)</span>
								</td>
							</tr-->
							</tbody>
							</table>
						</div>
						<div class="tableComment">
							<p><span class="bold">신청 후 각 사업장 담당자에게 증빙 제출 바랍니다.</span></p>
							<p><span class="bold">사업장 업무담당자</li>
							<ul>
								<li>여수 / 대전 : 인사노경팀 이혜정 (061-688-2521)</li>
								<li>서울 : 경영지원팀 박진희 (02-6930-3811)</li>
							</ul>
						</div>
					</form>
					</div>	
					<!--// Table end -->
					<!--// list start -->
					<div class="listArea" id="feeDecisioner">	
					</div>	
					<!--// list end -->	
					<div class="buttonArea">
						<ul class="btn_crud">
						<c:if test="${selfApprovalEnable == 'Y'}">
							<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
						</c:if>
							<li><a class="darken" href="#" id="reqCondoFeeBtn"><span>신청</span></a></li>
						</ul>
					</div>
				</div>
				<!--// Tab2 end -->
				
				<!--// Tab3 start -->
				<div class="tabUnder tab3 Lnodisplay">	
					<!--// list start -->
					<div class="listArea">
						<h2 class="subtitle">콘도이용내역</h2>
						<div class="clear"></div>
						<div id="condoUsedGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
					</div>	
					<!--// list end -->
					<!------------------ 상세내역 start ------------------>
					<!--// Table start -->	
					<div class="tableArea">
					<form id="condoDetailForm" name="condoDetailForm">
						<h2 class="subtitle">콘도이용 상세내역</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>콘도이용 상세내역</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText03-1">신청일</label></th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" value="" id="BEGDA" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="inputDateFrom">사용기간</label></th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" value="" id="DAY_IN" name="DAY_IN" readonly />
									~
									<input class="readOnly" type="text" value="" id="DAY_OUT" name="DAY_OUT" readonly />
									<input class="readOnly w40" type="text" name="DAY_USE" value="" id="DAY_USE" readonly /> 박 	
								</td>
                            </tr>
							<tr>
								<th><label for="inputText03-3">콘도명</label></th>
								<td colspan="3">	
									<input class="readOnly w80" type="text" name="NAME_CONDO" value="" id="NAME_CONDO" readonly />
									<input class="readOnly w80" type="text" name="NAME_LOCA" value="" id="NAME_LOCA" readonly />
									<input class="readOnly w80" type="text" name="NAME_SIZE" value="" id="NAME_SIZE" readonly />
									<input class="readOnly w40" type="text" name="CUNT_ROOM" value="" id="CUNT_ROOM" readonly /> (객실수)
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-4">신청금액</label></th>
								<td>
									<input class="inputMoney readOnly w150" type="text" name="MONEY" value="" id="MONEY" readonly />
								</td>
								<th><label for="inputText03-5">결제일</label></th>
								<td>
									<input class="readOnly w150" type="text" name="DATE_CARD" value="" id="DATE_CARD" readonly />
								</td>
							</tr>
							<!-- tr>
								<th><label for="input_radio03_1">결제구분</label></th>
								<td>
									<input type="radio" name="METHOD_1" id="input_radio03_1" disabled /><label for="input_radio03_1">개인카드</label>
									<input type="radio" name="METHOD_2" id="input_radio03_2" disabled /><label for="input_radio03_2">현금</label>
								</td>
								<th><label for="inputText03-6">카드번호</label></th>
								<td>
									<input class="readOnly w150" type="text" name="NUMBER_CARD" value="" id="NUMBER_CARD" readonly />
								</td>
							</tr-->
							</tbody>
							</table>
						</div>
					</form>	
					</div>
					<!--// Table end -->
					<!------------------ 상세내역 end ------------------>
				</div>
	<script>
        $(function() {
    		$("#reqCondoFeeBtn").click(function(){
    			reqCondoFee(false);
    		});
    		$("#requestNapprovalBtn").click(function(){
    			reqCondoFee(true);
    		});
        	$('#decisioner').hide();
        	$('#decisioner').load('/common/getDecisionerGrid?upmuType=43&gridDivId=decisionerGrid');
        	$('#feeDecisioner').load('/common/getDecisionerGrid?upmuType=32&gridDivId=feeDecisionerGrid');
	        // 콘도코드 rfc에서 사용기간을 파라미터로 받기는 하는데 신청청때는 필요없다. 지원비 신청할때 필요하다.
	        var getCondoCode = function(level, CODE_CONDO, LOCA_CONDO, SIZE_ROOM, DAY_IN, DAY_OUT) {
	    		$.ajax({
						type : "get",
						url : "/common/getCondoCodeList.json",
						dataType : "json",
						data : {"CODE_CONDO" : CODE_CONDO,
							"LOCA_CONDO" : LOCA_CONDO,
							"SIZE_ROOM" : SIZE_ROOM,
							"DAY_IN" : DAY_IN,
							"DAY_OUT" : DAY_OUT}
					}).done(function(response) {
						if(response.success) {
							var res = response.storeData[level];
							if(level == 0 ) {
				            	$("#LOCA_CONDO").empty();
				            	$("#LOCA_CONDO").append('<option value="">------선택------</option>');
				            	$("#SIZE_ROOM").empty();
				            	$("#SIZE_ROOM").append('<option value="">------선택------</option>');
				            	$("#CODE_CONDO").append('<option value="">------선택------</option>');
						        $.each(res, function (index, item) {
						        	$("#CODE_CONDO").append('<option value=' + item.CODE_CONDO + '>' + item.NAME_CONDO + '</option>');
						        });
							} else if (level == 1) {
				            	$("#LOCA_CONDO").empty();
				            	$("#LOCA_CONDO").append('<option value="">------선택------</option>');
				            	$("#SIZE_ROOM").empty();
				            	$("#SIZE_ROOM").append('<option value="">------선택------</option>');
						        $.each(res, function (index, item) {
						        	$("#LOCA_CONDO").append('<option value=' + item.LOCA_CONDO + '>' + item.NAME_LOCA + '</option>');
						        });
							} else if (level == 2) {
				            	$("#SIZE_ROOM").empty();
				            	$("#SIZE_ROOM").append('<option value="">------선택------</option>');
						        $.each(res, function (index, item) {
						        	$("#SIZE_ROOM").append('<option value=' + item.SIZE_ROOM + '>' + item.NAME_SIZE + '</option>');
						        });
							}
						}
			    		else
			    			alert("콘도코드 조회시 오류가 발생하였습니다. " + response.message);
				});
	        }
           	getCondoCode(0, "", "", "", "");

        	$("#reqCondoForm #CODE_CONDO").change(function() {
        		if($("#reqCondoForm #CODE_CONDO option:selected").val() == "08") { //생활연수원일 경우 뒤에 selectbox 못하게
	            	$("#LOCA_CONDO").hide();
	            	$("#SIZE_ROOM").hide();
	            	$("#CUNT_ROOM").hide();
        		} else {
	            	$("#LOCA_CONDO").show();
	            	$("#SIZE_ROOM").show();
	            	$("#CUNT_ROOM").show();
            		getCondoCode(1, $("#reqCondoForm #CODE_CONDO option:selected").val(), "", "", "");
        		}
        	});

        	$("#reqCondoForm #LOCA_CONDO").change(function() {
            	getCondoCode(2, $("#reqCondoForm #CODE_CONDO option:selected").val(), $("#reqCondoForm #LOCA_CONDO option:selected").val(), "", "");
        	});
			//사용일수
	        $("#inputDateFrom, #inputDateTo").change(function() {
	        	$("#DAY_USE").val("");
	            if($("#inputDateFrom").val() != "" && $("#inputDateTo").val() != "" && isDate($("#inputDateFrom").val()) && isDate($("#inputDateTo").val())){
	                var begd = removePoint($("#inputDateFrom").val());
	                var endd = removePoint($("#inputDateTo").val());
	                var diff = parseInt(endd) - parseInt(begd);
	                
	                if (diff >0) {
	                   bday = new Date(begd.substring(0,4),begd.substring(4,6)-1,begd.substring(6,8));
	                   eday = new Date(endd.substring(0,4),endd.substring(4,6)-1,endd.substring(6,8));
	                   var betday = getDayInterval(bday,eday);
	   	        		$("#DAY_USE").val((betday-1));
	                }
	            } 
        	});
    		//reqCondoForm start
    		$("#reqCondoBtn").click(function(){
    			if(checkReqCondoFormValid()) {
    				if(confirm("신청하시겠습니까?")) {
    					$("#reqCondoBtn").prop("disabled", true);
    					var param = $("#reqCondoForm").serializeArray();
    					$("#decisionerGrid").jsGrid("serialize", param);
    					jQuery.ajax({
    		        		type : 'POST',
    		        		url : '/supp/requestCondo',
    		        		cache : false,
    		        		dataType : 'json',
    		        		data : param,
    		        		async : false,
    		        		success : function(response) {
    		        			if(response.success) {
    		        				alert("신청되었습니다.");
    								$("#reqCondoForm").each(function() {  
    									this.reset();
    								});  
    		        			} else {
    		        				alert("신청시 오류가 발생하였습니다. " + response.message);
    		        			}
    							$("#reqCondoBtn").prop("disabled", false);
    		        		}
    		        	});
    				}
    			}
    		});
    		var checkReqCondoFormValid = function() {
    			if(!checkNullField("reqCondoForm")) return false;	
    			/*
    			if($("#inputDateFrom").val() == "" || !isDate($("#inputDateFrom").val())) {
    				alert("입실일을 입력하세요.");
    				$("#inputDateFrom").focus();
    				return false;
   				}
   				if($("#inputDateTo").val() == "" || !isDate($("#inputDateTo").val())) {
    				alert("퇴실일을 입력하세요.");
    				$("#inputDateTo").focus();
    				return false;
   				}*/
   			    //신청년도와 여행시작년도만비교
   			    var begin_date = removePoint($("#reqCondoForm #BEGDA").val());
   			    var trvl_begd = removePoint($("#reqCondoForm #inputDateFrom").val());
   			    var trvl_endd = removePoint($("#reqCondoForm #inputDateTo").val());

   			    be = begin_date.substring(0,4);
   			    tr = trvl_begd.substring(0,4);

   			    if (trvl_begd != "" && trvl_endd != "") {
   			    //   if(be != tr){
       			//		alert("현재년도만 신청가능합니다.");
				//		return false;
   			    //   }              
   			       if(trvl_begd > trvl_endd){
       					alert("입실일이 퇴실일보다 먼저 입니다.");
						return false;
   			       }  
   			    }
   				if($("#reqCondoForm #CODE_CONDO").prop("selectedIndex")==0){
    				alert("콘도를 선택하세요.");
    				$("#reqCondoForm #CODE_CONDO").focus();
    				return false;
   				}
   				if($("#reqCondoForm #CODE_CONDO option:selected").val() != "08"){
   	   				if($("#reqCondoForm #LOCA_CONDO").prop("selectedIndex")==0){
	    				alert("지역을 선택하세요.");
	    				$("#reqCondoForm #LOCA_CONDO").focus();
	    				return false;
    				} 
   	   				if($("#reqCondoForm #SIZE_ROOM").prop("selectedIndex")==0){
	    				alert("평형을 선택하세요.");
	    				$("#reqCondoForm #SIZE_ROOM").focus();
	    				return false;
    				}
   				}
    				 
   				if($("#reqCondoForm #TEL_NUM").val()==0){
    				alert("연락처를 입력하세요. (- 포함)");
    				$("#reqCondoForm #TEL_NUM").focus();
    				return false;
   				}
   				if(!mobileCheck($("#reqCondoForm #TEL_NUM").val()) && !phoneCheck($("#reqCondoForm #TEL_NUM").val())){
    				alert("연락처를 정확히 입력하세요. (- 포함)");
    				$("#reqCondoForm #TEL_NUM").focus();
    				return false;
   				}
        		return true;
    		}
    		//지원비신청용
    		/*
    		$('#reqCondoFeeForm input:radio[name="METHOD"]').change(function() {
    			if(this.value == "2") {
    				$("#reqCondoFeeForm #NUMBER_CARD").prop("disabled", true );
    				$("#reqCondoFeeForm #NUMBER_CARD").val("");
    			} else {
    				$("#reqCondoFeeForm #NUMBER_CARD").prop("disabled", false );
    			}
        	});
			*/
    		$("#condoUsedForFeeGrid").jsGrid({
            	height: "auto",
                width: "100%",
                sorting: true,
                paging: false,
                autoload: true,
                pageSize: 10,
                pageButtonCount: 10,
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "GET",
							url : "/supp/getCondoUsedList.json",
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
                    {
                    	title: "선택",
                    	name: "AINF_SEQN",
    					itemTemplate: function(value, item) {
    						return $("<input name='AINF_SEQN'>")
    								.attr("type", "radio")
    								.on("click",function(e){
    									setCondoFeeForm(item);
    								});
    					},
                        align: "center",
                        width: "8%"
                    },
                    { title: "신청일", name: "BEGDA", type: "text", align: "center", width: "12%" },
                    { title: "사용기간", name: "DAY_IN", type: "text", align: "center", width: "20%",
    					itemTemplate: function(value, item) {
    						return value + " - " + item.DAY_OUT;
    					}
                    },
                    { title: "이용일수", name: "DAY_USE", type: "text", align: "center", width: "11%",
    					itemTemplate: function(value, item) {
                        	return parseInt(value);
    					}
                    },
                    { title: "지역", name: "NAME_LOCA", type: "text", align: "center", width: "14%" },
                    { title: "콘도명", name: "NAME_CONDO", type: "text", align: "center", width: "14%" },
                    { title: "평수", name: "NAME_SIZE", type: "text", align: "center", width: "10%" },
                    { title: "객실수", name: "CUNT_ROOM", type: "text", align: "center", width: "11%" }
                ]
            });
    		var setCondoFeeForm = function(item){
				setTableText(item, "reqCondoFeeForm");
				$("#reqCondoFeeForm #DAY_USE").val(parseInt(item.DAY_USE));
				$("#reqCondoFeeForm #P_SEQN").val(item.AINF_SEQN);
				$("#reqCondoFeeForm #BEGDA").val('<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>');
    		}
    		//reqCondoFeeForm start
    		var reqCondoFee = function(self) {
    			if(checkReqCondoFeeFormValid()) {
    				//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
    				var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
    				feeDecisionerGridChangeAppLine(self);
    				if(confirm(msg + "신청 하시겠습니까?")){
    					$("#reqCondoFeeBtn").prop("disabled", true);
    					$("#requestNapprovalBtn").prop("disabled", true);
    					var param = $("#reqCondoFeeForm").serializeArray();
    					$("#feeDecisionerGrid").jsGrid("serialize", param);
    					param.push({name:"METHOD", value:"2"});
    					param.push({"name":"selfAppr", "value" : self});
    					jQuery.ajax({
    		        		type : 'POST',
    		        		url : '/supp/requestCondoFee',
    		        		cache : false,
    		        		dataType : 'json',
    		        		data : param,
    		        		async : false,
    		        		success : function(response) {
    		        			if(response.success) {
    		        				alert("신청되었습니다.");
    								$("#reqCondoFeeForm").each(function() {
    									$("#condoUsedForFeeGrid").jsGrid("search");
    				    				//$("#reqCondoFeeForm #NUMBER_CARD").prop("disabled", false );
    									this.reset();
    								});  
    		        			} else {
    		        				alert("신청시 오류가 발생하였습니다. " + response.message);
    		        			}
    							$("#reqCondoFeeBtn").prop("disabled", false);
    							$("#requestNapprovalBtn").prop("disabled", false);
    		        		}
    		        	});
    				} else {
    					feeDecisionerGridChangeAppLine(false);
    				}
    			}
    		}
    		var checkReqCondoFeeFormValid = function() {
    			if($("#reqCondoFeeForm #AINF_SEQN").val() == "") {
    				alert("신청할 이용내역을 선택하세요");
    				return false;
   				}
    			if($("#reqCondoFeeForm #MONEY").val() == "" ) {
    				alert("신청금액을 입력하세요.");
    				$("#reqCondoFeeForm #MONEY").focus();
    				return false;
   				}
   				if(removeComma($("#reqCondoFeeForm #MONEY").val()) > 200000){
    				alert("200,000 원이 초과 하였습니다. 신청금액을 확인하시기 바랍니다.");
    				return false;
   				}
				if($("#reqCondoFeeForm #DATE_CARD").val() == "" ) {
					alert("결재일을 입력하세요.");
					$("#reqCondoFeeForm #DATE_CARD").focus();
					return false;
				}
				
				if(!isDate($("#reqCondoFeeForm #DATE_CARD").val())) {
					alert("결재일을 입력하세요.");
					$("#reqCondoFeeForm #DATE_CARD").focus();
					return false;
				}
				/*
   				if($('#reqCondoFeeForm input:radio[name="METHOD"]:checked').val() == "1"){
   					if($("#reqCondoFeeForm #NUMBER_CARD").val() == "" ) {
   						alert("카드번호를 입력하세요.");
   						$("#reqCondoFeeForm #NUMBER_CARD").focus();
   						return false;
					}
   					if( !isCardNumber($("#reqCondoFeeForm #NUMBER_CARD").val()) ) {
   						alert("카드번호를 정확히 입력하세요.");
   						$("#reqCondoFeeForm #NUMBER_CARD").focus();
   						return false;
   					} 
   				}
				*/
        		return true;
    		}
    		//상세조회용
            $("#condoUsedGrid").jsGrid({
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
							url : "/supp/getCondoList.json",
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
                    {
                    	title: "선택",
                    	name: "AINF_SEQN",
    					itemTemplate: function(value, item) {
    						return $("<input name='AINF_SEQN'>")
    								.attr("type", "radio")
    								.on("click",function(e){
    									setDetailView(item);
    								});
    					},
                        align: "center",
                        width: "8%"
                    },
                    { title: "신청일", name: "BEGDA", type: "text", align: "center", width: "11%" },
                    { title: "이용콘도", name: "BIGO", type: "text", align: "center", width: "16%" },
                    { title: "입실일", name: "DAY_IN", type: "text", align: "center", width: "11%" },
                    { title: "퇴실일", name: "DAY_OUT", type: "text", align: "center", width: "11%" },
                    { title: "이용일수", name: "DAY_USE", type: "text", align: "center", width: "8%",
    					itemTemplate: function(value, item) {
                        	return parseInt(value);
    					}
                    },
                    { title: "신청금액", name: "MONEY", type: "text", align: "right", width: "12%",
		                itemTemplate: function(value) {
		                    return (parseInt(value) * 100).format();
						}
                   	},
                    { title: "지원금액", name: "MONEY2", type: "text", align: "right", width: "12%",
		                itemTemplate: function(value) {
		                    return (parseInt(value) * 100).format();
						}
                   	},
                    { title: "최종결재일", name: "POST_DATE", type: "text", align: "center", width: "11%",
		                itemTemplate: function(value) {
		                    return value == "0000.00.00" ? "" : value;
						}
                    }
                ]
            });
        	var setDetailView = function(item) {
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
        					$("#condoDetailForm #NAME_CONDO").val(result[0].NAME_CONDO);

        					var result = $.grep(res[1], function(element, index) {
        						   return (element.LOCA_CONDO === item.LOCA_CONDO);
       						});
        					$("#condoDetailForm #NAME_LOCA").val(result[0].NAME_LOCA);

        					var result = $.grep(res[2], function(element, index) {
        						   return (element.SIZE_ROOM === item.SIZE_ROOM);
       						});
        					if(result.length > 0)
        						$("#condoDetailForm #NAME_SIZE").val(result[0].NAME_SIZE);
       					}
        				else
        					alert("콘도코드 조회시 오류가 발생하였습니다. " + response.message);
       			});
				setTableText(item, "condoDetailForm");
				$("#condoDetailForm #DAY_USE").val(parseInt(item.DAY_USE));
				$("#condoDetailForm #MONEY").val((parseInt(item.MONEY) * 100).format());
				//$('#condoDetailForm input:radio[name="METHOD_1"]').prop("checked", false);
				//$('#condoDetailForm input:radio[name="METHOD_2"]').prop("checked", false);
				//$('#condoDetailForm input:radio[name="METHOD_'+item.METHOD+'"]').prop("checked", true);
        	}
		});
    </script>

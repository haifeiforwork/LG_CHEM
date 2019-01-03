<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E19Disaster.*" %>
<%@ page import="hris.E.E19Disaster.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%
	WebUserData user = (WebUserData)session.getValue("user");
	//E19CongcondData  e19CongcondData      = (E19CongcondData)request.getAttribute("e19CongcondData");
    /* 재해피해신고서 입력된 vector를 받는다*/
    Vector          E19DisasterData_vt    = (Vector)request.getAttribute("E19DisasterData_vt");
    Vector          AppLineData_vt        = (Vector)request.getAttribute("AppLineData_vt");
    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    Vector          AccountData_pers_vt   = (Vector)request.getAttribute("AccountData_pers_vt");
    AccountData     AccountData_hidden    = (AccountData)request.getAttribute("AccountData_hidden");
    E19CongcondData e19CongcondData		  = (E19CongcondData)request.getAttribute("e19CongcondData");
    
    Vector          E19DisasterData_opt = (new E19DisaRelaRFC()).getDisaRela(user.companyCode); 
    Vector			E19DisasterData_rate = (new E19DisaRateRFC()).getDisaRate(user.companyCode);
%>
<div class="tableArea">
	<h2 class="subtitle">재해 신청 상세내역</h2>
	<div class="clear"> </div>
	<div class="table">
		<form id="detailForm" name="detailForm" method="post" action="">
			<table class="tableGeneral">
			<caption>재해신청</caption>
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
					<input class="readOnly" type="text"  value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" id="BEGDA" name="BEGDA" readonly />
				</td>
				<th><label for="a1">결재일</label></th>
				<td class="tdDate"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputDate01">재해발생일자</label></th>
				<td colspan="3" class="tdDate datepicker">
					<input type="text" class="readOnly" id="CONG_DATE" name="CONG_DATE" required vname="재해발생일자" readonly/>
				</td>
			</tr>	
			<tr>
				<th><label for="inputText02-1">통상임금</label></th>
				<td colspan="3">
					<input class="inputMoney w120 readOnly" type="text" id="WAGE_WONX" name="WAGE_WONX"  readonly /> 원
					<input type="hidden" name="COUNT_NO" id="COUNT_NO"  >
					<input type="hidden" name="CONG_CODE"  id="CONG_CODE"     >									
					<input type="hidden" name="AINF_SEQN" id="AINF_SEQN"      >
				</td>
			</tr>
			<tr>
				<th><label for="inputText02-2">지급율</label></th>
				<td colspan="3">
					<input class="alignRight w120 readOnly" type="text" name="CONG_RATE" id="CONG_RATE" readonly required vname="지급율" /> %
					<input type="hidden" name="xCONG_RATE" >
				</td>
			</tr>
			<tr>
				<th><label for="inputText02-3">재해위로금액</label></th>
				<td colspan="3">
					<input class="inputMoney w120 readOnly" type="text" id="CONG_WONX" name="CONG_WONX"  readonly required vname="재해위로금액"/> 원
					<input type="hidden" name="xCONG_WONX" >
				</td>
			</tr>
			<tr>
				<th><label for="inputText02-4">이체은행명</label></th>
				<td>
					<input class="w120 readOnly" type="text" id="BANK_NAME" name="BANK_NAME" readonly required vname="이체은행명"/>
				</td>
				<th><label for="inputText02-5">은행계좌번호</label></th>
				<td>
					<input class="w120 readOnly" type="text" name="BANKN"  id="BANKN" readonly required vname="은행계좌번호"/>
				</td>
			</tr>
			<tr>
				<th><label for="inputText02-7">근속년수</label></th>
				<td colspan="3">
					<input class="alignRight w50 readOnly" type="text" id="WORK_YEAR" name="WORK_YEAR" readonly /> 년
					<input class="alignRight w50 readOnly" type="text" id="WORK_MNTH" name="WORK_MNTH" readonly /> 개월
				</td>
			</tr>	
			</tbody>
			</table>
		</form>
	</div>
</div>	
<div class="listArea">	
	<h2 class="subtitle withButtons">재해피해 신고서</h2>
	<div id="disasterList" class="thSpan"></div>
</div>	
	<input type="hidden" id="disaster_count" name="disaster_count" />
	<input type="hidden" id="RowCount_report" name="RowCount_report" value="" />

<!-- popup : 재해피해 신고서 start -->
<div class="layerWrapper layerSizeL" id="popLayerDisaster">
<form id="disasterDamageForm" name="disasterDamageForm" method="post" action="">	
	<div class="layerHeader">
		<strong>재해피해 신고서</strong>
		<a href="#" class="btnClose popLayerDisaster_close">창닫기</a>
	</div>
	<div class="layerContainer">		
		<div class="layerContent">			
			<!--// Content start  -->
			<!--// Content start  -->
			<div class="tableArea tablePopup">
				<div class="table">
					<table class="tableGeneral">
					<caption>재해피해 신고서  입력</caption>
					<colgroup>
						<col class="col_5p" />
						<col class="col_16p" />
						<col class="col_78p" />
					</colgroup>
					<tbody>
						<tr>
							<th colspan="2"><span class="textPink">*</span><label for="label-01">재해내역</label></th>
							<td>
								<select id="xDISA_RESN" name="xDISA_RESN" class="clearTarget"  required vname="재해내역"> 
									<option>-----선택-----</option>
									<!-- 재해내역 option -->
									<%= WebUtil.printOption((new E19DisaResnRFC()).getDisaResn(user.companyCode)) %>
									<!-- 재해내역 option -->
								</select>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span class="textPink">*</span><label for="label-02">재해구분 </label></th>
							<td>
								<select id="xDISA_CODE" name="xDISA_CODE" class="clearTarget" required vname="재해구분"> 
									<option>-----선택-----</option>
									<!-- 재해구분 option -->
									<%= WebUtil.printOption((new E19DisaCodeRFC()).getDisaCode(user.companyCode)) %>
									<!-- 재해구분 option -->
								</select>
							</td>
						</tr>
						<tr>
							<th rowspan="4">재<br>해<br>피<br>해<br>자</th>
							<th><span class="textPink">*</span><label for="label-03">구분</label></th>
							<td>
								<select id="xDREL_CODE" name="xDREL_CODE" class="clearTarget"  required vname="구분"> 
									<option>-----선택-----</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="label-04">성명</label></th>
							<td>
								<input  type="text" id="xEREL_NAME" name="xEREL_NAME" class="clearTarget"  required vname="성명"/> 
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="label-05">생년월일</label></th>
							<td class="tdDate">
								<input class="w80" type="text" value="" id="xGBDAT" name="xGBDAT" required vname="생년월일"/> (YYYY.MM.DD)
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="PSTLZ">주소</label></th>
							<td>
								<!-- <input id="addrsPSTLZ" name="PSTLZ" type="text" value="" class="w50" readonly/> -->
								<div class="br">											
									<input id="addrsSTRAS" name="STRAS" type="text" class="wPer" readonly required vname="주소"/>
								</div>
								<div class="br">
									<input id="addrsLOCAT" name="LOCAT" type="text" class="wPer" placeholder="상세주소 입력" required vname="상세주소"/>
								</div>
							</td>
						</tr>
						
						<tr>
							<th colspan="2"><label for="label-06">재해내용</label></th>
							<td>
								<div class="br">
									<input id="xDISA_DESC1" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
								<div class="br">
									<input id="xDISA_DESC2" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
								<div class="br">
									<input id="xDISA_DESC3" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
								<div class="br">
									<input id="xDISA_DESC4" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
								<div class="br">
									<input id="xDISA_DESC5" name="DISA_DESC" type="text" class="wPer" size="60" maxlength="60"  />
								</div>
              						<input type="hidden" name="xDISA_RATE" id="xDISA_RATE" value="" class="clearTarget" >
              						<input type="hidden" name="xDISA_NAME" id="xDISA_NAME" value="" class="clearTarget" >
              						<input type="hidden" name="xRESN_NAME" id="xRESN_NAME" value="" class="clearTarget" >
              						<input type="hidden" name="xDREL_NAME" id="xDREL_NAME" value="" class="clearTarget" >
							</td>
						</tr>
					</tbody>
					</table>
				</div>
			</div>
			<!--// Content end  -->							
		</div>		
	</div>		
</form>
</div>
<!-- //팝업: 재해피해 신고서 end -->
<script>
var orgItem;
var E19DisasterData_rat2;
var hideFlag = true;
var drelCodeCopy;
var detailSearch= function() {
	$.ajax({
		type : "get",
		url : "/appl/getDisasterDetail.json",
		dataType : "json",
		data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
	}).done(function(response) {
		if(response.success) {
			setDetail(response.storeData);
			setDetail(response.E19DisasterData_vt);
		}
		else
			alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
	});
	var setDetail = function(item){
		setTableText(item, "detailForm");
		$("#disasterList").jsGrid("search");
		$("input:radio[name='chk']").prop("disabled",true);
	}
};

$(document).ready(function(){
	detailSearch();
});

$(function() {
	$("#disasterList").jsGrid({
		width : "100%",
		sorting : true,
		autoload : false,
		paging : true,
		controller : {
			loadData : function() {
				var d = $.Deferred();
				$.ajax({
					type : "GET",
					url : "/appl/getDisasterDetail.json",
					dataType : "json" ,
					data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
				}).done(function(response) {
					if(response.success){
						d.resolve(response.E19DisasterData_vt);
					}else{
						alert("조회시 오류가 발생하였습니다. " + response.message);
					}
				});
				return d.promise();
			}
		},
        headerRowRenderer: function() {
            var $result = $("<tr>").height(0)
            	.append($("<th width='6%'>"))
            	.append($("<th width='24%'>"))
            	.append($("<th width='17%'>"))
            	.append($("<th width='17%'>"))
            	.append($("<th width='18%'>"))
    	        .append($("<th width='10%'>"));

            $result = $result.add($("<tr>")
            	.append($("<th>").attr("rowspan", 2).text("선택"))
            	.append($("<th>").attr("rowspan", 2).text("재해구분"))
            	.append($("<th>").attr("colspan", 3).text("재해피해자"))
            	.append($("<th>").attr("rowspan", 2).text("지급율")));
            
            var $tr = $("<tr>");
            
            var grid = this;
            
            grid._eachField(function(field, index) {
                if (index>1 && index<5) {
                var $th = $("<th>").text(field.title).width(field.width).appendTo($tr);
                
                if(grid.sorting && field.sorting) {
            		$th.on("click", function() {
                    	grid.sort(index);
                	});
                }
                }
            });
            return $result.add($tr);
        },
		fields: [
	            	{
	                	title: "선택",
	                	name: "CHECK_ITEM",
	                    itemTemplate: function(_, item) {
	                        return $("<input name='chk'>")
							.attr("type", "radio")
							.on("click", function(e) {
								orgItem = item;
						  		$("#xDISA_CODE").val(item.DISA_CODE);
								$("#xDISA_DESC1").val(item.DISA_DESC1);
								$("#xDISA_DESC2").val(item.DISA_DESC2);
								$("#xDISA_DESC3").val(item.DISA_DESC3);
								$("#xDISA_DESC4").val(item.DISA_DESC4);
								$("#xDISA_DESC5").val(item.DISA_DESC5);
								$("#xDISA_NAME").val(item.DISA_NAME);
								$("#xDISA_RATE").val(item.DISA_RATE);
								$("#xDISA_RESN").val(item.DISA_RESN);
								$("#xDREL_CODE").val(item.DREL_CODE);
								$("#xDREL_NAME").val(item.DREL_NAME);
								$("#xEREL_NAME").val(item.EREL_NAME);
								$("#addrsLOCAT").val(item.LOCAT);
								$("#xGBDAT").val(item.GBDAT);
								$("#xRESN_NAME").val(item.RESN_NAME);
								$("#addrsSTRAS").val(item.STRAS);
								drelCodeCopy = item.DREL_CODE;
								
								view_DisaRela();
					   		});
	                    },
	                    align: "center",
	                    width: "6%"
	                },

	            	{ title: "재해구분", name: "DISA_NAME", type: "text", align: "center", width: "24%" },
	                
	            	{ title: "구분", name: "DREL_NAME", type: "text", align: "center", width: "17%" },
	                { title: "성명", name: "EREL_NAME", type: "text", align: "center", width: "17%" },
	                { title: "생년월일", name: "GBDAT", type: "number", align: "center", width: "18%" },				                    
	                { title: "지급율", name: "DISA_RATE", type: "number", align: "center", width: "10%",
	                	itemTemplate: function(val, item) {
	                		return val + " %";
	                	}
	                },
	            	{ title: "재해내역(code)", name: "DISA_RESN", type: "text", align: "center", visible:false },
	            	{ title: "재해내역", name: "RESN_NAME", type: "text", align: "center", visible:false },
	            	{ title: "구분(code)", name: "DREL_CODE", type: "text", align: "center", visible:false },
	            	{ title: "재해구분(code)", name: "DISA_CODE", type: "text", align: "center", visible:false },
	                { title: "주소", name: "STRAS", type: "text", align: "center", visible: false},
	                { title: "상세주소", name: "LOCAT", type: "text", align: "center", visible: false},
	                
	                { title: "재해내용1", name: "DISA_DESC1", type: "text", align: "center", visible: false},
	                { title: "재해내용2", name: "DISA_DESC2", type: "text", align: "center", visible: false},
	                { title: "재해내용3", name: "DISA_DESC3", type: "text", align: "center", visible: false},
	                { title: "재해내용4", name: "DISA_DESC4", type: "text", align: "center", visible: false},
	                { title: "재해내용5", name: "DISA_DESC5", type: "text", align: "center", visible: false},
	                
	                { title: "경조발생일", name: "CONG_DATE", type: "text", align: "center", visible: false}
		]
	});
});
var view_DisaRela = function(){ 	
	  // var val1 = obj[obj.selectedIndex].value;
	   var val = $("#xDISA_CODE").val();//DISA_CODE 값
	   $('#xDREL_CODE').find("option").remove().end();
	$('#xDREL_CODE').append('<option>-----선택-----</option>');
	  
<%
  E19DisasterData data1 = (E19DisasterData)E19DisasterData_opt.get(0);
	  int inx = 0;
  String before = "";
  for( int i = 0 ; i < E19DisasterData_opt.size() ; i++ ) {
      E19DisasterData data = (E19DisasterData)E19DisasterData_opt.get(i);
%>
		var drelFromData ='000'+ <%=data.DREL_CODE%>;
	
		if(val=='<%=data.DISA_CODE%>'){
		   if(drelCodeCopy == drelFromData ){
				$('#xDREL_CODE').append('<option value=' + '<%=data.DREL_CODE%>' + ' selected >' + '<%=data.DREL_NAME%>' + '</option>');
			}else{
				$('#xDREL_CODE').append('<option value=' + '<%=data.DREL_CODE%>' + '>' + '<%=data.DREL_NAME%>' + '</option>');
			}
		}

<%  }  %>

$("#popLayerDisaster").popup('show');
fncSetFormReadOnly($("#disasterDamageForm"), true);
};

</script>

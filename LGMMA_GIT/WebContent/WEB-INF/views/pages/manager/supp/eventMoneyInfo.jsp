<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<form name="form1" id="form1" method="post" action="">
<!-- contents start -->
	<!--// Page Title start -->
	<div class="title">
		<h1>경조금</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">My Info</a></span></li>
				<li><span><a href="#">복리후생</a></span></li>
				<li class="lastLocation"><span><a href="#">경조금</a></span></li>
			</ul>						
		</div>
	</div>
<!--// Page Title end -->			
				<!--// Tab2 start -->
				<div class="tabUnder tab2">
					<!--// list start -->
					<div class="listArea">
						<h2 class="subtitle">경조금 지원내역</h2>
						<div id="eventMoneyGrid" class="jsGridPaging"></div>
					</div>
					<!--// list end -->
					
					<!--// Table start -->	
					<div class="tableArea">	
						<h2 class="subtitle">경조금 상세내역</h2>		
						<div class="table">
							<table class="tableGeneral">
							<caption>경조금 상세내역</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="DETAIL_CONG_DATE">경조발생일자</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_CONG_DATE" readonly />
								</td>
								<th><label for="DETAIL_CONG_NAME">경조내역</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_CONG_NAME" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="DETAIL_RELA_NAME">경조대상자 관계</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_RELA_NAME" readonly />
								</td>
								<th><label for="DETAIL_EREL_NAME">경조대상자 성명</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_EREL_NAME" readonly />
								</td>
                            </tr>
							<tr>
								<th><label for="DETAIL_WAGE_WONX">月 기준급</label></th>
								<td colspan="3">
									<input class="inputMoney w120 readOnly" type="text" id="DETAIL_WAGE_WONX" readonly /> 원
								</td>
							</tr>
							<tr>
								<th><label for="DETAIL_CONG_RATE">지급율</label></th>
								<td colspan="3">
									<input class="alignRight w120 readOnly" type="text" id="DETAIL_CONG_RATE" readonly /> %
                                </td>
                            </tr>
                            <tr>
								<th><label for="DETAIL_CONG_WONX">경조금액</label></th>
								<td colspan="3">
									<input class="inputMoney w120 readOnly" type="text" id="DETAIL_CONG_WONX" readonly /> 원
								</td>
							</tr>
							<tr>
								<th><label for="DETAIL_BANK_NAME">이체은행명</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_BANK_NAME" readonly />
								</td>
								<th><label for="DETAIL_BANKN">은행계좌번호</label></th>
								<td>
									<input class="w120 readOnly" type="text" id="DETAIL_BANKN" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="DETAIL_HOLI_CONT">경조휴가일수</label></th>
								<td colspan="3">
									<div id="HOLI_CONT1" style="display:block;">
									<input class="alignRight w120 readOnly" type="text" id="DETAIL_HOLI_CONT" readonly /> 일
									</div>
									<div id="HOLI_CONT2" style="display:none;">
										Help 참조
									</div>
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-11">근속년수</label></th>
								<td colspan="3">
                                   <input class="alignRight w50 readOnly" type="text" id="DETAIL_WORK_YEAR" readonly /> 년
                                   <input class="alignRight w50 readOnly" type="text" id="DETAIL_WORK_MNTH" readonly /> 개월
                                </td>
							</tr>						
							</tbody>
							</table>
						</div>
					</div>
					<!--// Table end -->
				</div>
				<!--// Tab2 end -->
				
</form>

<script type="text/javascript">
$(document).ready(function(){
	$(function() {
		$("#eventMoneyGrid").jsGrid({
			height: "auto",
	        width: "100%",
	        sorting: true,
	        paging: true,
	        autoload: true,
			controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/manager/supp/getEventMoneyList.json",
   						dataType : "json"
  					}).done(function(response) {
   						if(response.success)
   							d.resolve(response.storeData);
   		    			else
   		    				alert("조회시 오류가 발생하였습니다. " + response.message);
   					});
   					return d.promise();
   				}
   			},
			fields: [
           		{
           			title: "선택",
           			name: "th1",
           			itemTemplate: function(_, item) {
           				return $("<input name='chk'>")
           					   .attr("type", "radio")
           					   .on("click", function(e) {
           						    $('#DETAIL_CONG_DATE').val(item.CONG_DATE);
	           						$('#DETAIL_CONG_NAME').val(item.CONG_NAME);
	           						$('#DETAIL_RELA_NAME').val(item.RELA_NAME);
	           						$('#DETAIL_EREL_NAME').val(item.EREL_NAME);
	           						$('#DETAIL_WAGE_WONX').val(item.WAGE_WONX.format());
	           						$('#DETAIL_CONG_RATE').val(item.CONG_RATE);
	           						$('#DETAIL_CONG_WONX').val(item.CONG_WONX.format());
	           						$('#DETAIL_BANK_NAME').val(item.BANK_NAME);
	           						$('#DETAIL_BANKN').val(item.BANKN);
	           						$('#DETAIL_HOLI_CONT').val(item.HOLI_CONT);
	           						$('#DETAIL_WORK_YEAR').val(item.WORK_YEAR);
	           						$('#DETAIL_WORK_MNTH').val(item.WORK_MNTH);
	           						setHoli(item.CONG_CODE, item.RELA_CODE);
           						  
           					   });
           			},
           			align: "center",
           			width: "8%"
           		},
           		{ title: "신청일", name: "BEGDA", type: "text", align: "center", width: "10%" },
           		{ title: "경조내역", name: "CONG_NAME", type: "text", align: "left", width: "13%" },
           		{ title: "경조대상자 관계", name: "RELA_NAME", type: "text", align: "left", width: "16%" },
           		{ title: "대상자", name: "EREL_NAME", type: "text", align: "left", width: "13%" },
           		{ title: "경조발생일", name: "CONG_DATE", type: "text", align: "center", width: "13%" },
           		{ title: "경조금액", name: "CONG_WONX", type: "text", align: "right", width: "13%" ,
           		 	itemTemplate: function(value) {
	                    return value.format();}
           		},
           		{ title: "최종결재일", name: "POST_DATE", type: "text", align: "center", width: "14%" }
       		]
		});
	});
	
	
	var setHoli = function(CONG_CODE, RELA_CODE) {
	//2002.07.03. 조위이면서 부모, 배우자부모일경우에는 일수가 아닌 text를 보여준다. 요청자 : 성경호, 수정자 : 김도신
	//2017.01.06 불필요한 로직이라 삭제요청. 요청자 : LGMMA 홍성민
	/*
		if( CONG_CODE == "0003" && (RELA_CODE == "0002" || RELA_CODE == "0003") ) {
			$("#HOLI_CONT1").hide();
        	$("#HOLI_CONT2").show();
		} else {
			$("#HOLI_CONT1").show();
        	$("#HOLI_CONT2").hide();
		}
	};
	*/
	}
});
</script>


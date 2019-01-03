<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>

<%
	Vector      E11PersonalData_vt    = (Vector)request.getAttribute("E11PersonalData_vt");
%>

<!--// Page Title start -->
<div class="title">
	<h1>개인연금</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">개인연금</a></span></li>
		</ul>						
	</div>
</div>
<!--// Page Title end -->	

<!--------------- layout body start --------------->	
<!--// list start -->
<div class="listArea">		
	<h2 class="subtitle withButtons">개인연금내역</h2>
	<div class="clear"></div>
	<div id="personalPensionInfo" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>								
</div>	
<!--// list end -->		
<!--// Table start -->	
<div class="tableArea">	
	<form action="" id="personalPensionInfoForm" name="personalPensionInfoForm" method="post"> 
	<input class="readOnly w150" type="hidden" name="STATUS" value="" id="STATUS" />									
	<h2 class="subtitle">개인연금 상세내역</h2>	
	<div class="table">
		<table class="tableGeneral">
		<caption>개인연금 상세내역</caption>
		<colgroup>
			<col class="col_15p"/>
			<col class="col_35p"/>
			<col class="col_15p"/>
			<col class="col_35p"/>
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText01-1">연금구분</label></th>
			<td colspan="3">
			    <input class="readOnly w150" type="hidden" name="PENT_TYPE" id="PENT_TYPE" value=""/>
			    <input class="readOnly w150" type="hidden" name="ENTR_DATE" id="ENTR_DATE" value=""/>
				<input class="readOnly w150" type="text" name="PENT_TEXT"  id="PENT_TEXT" value=""  readonly />
			</td>
		</tr>
		<tr>
			<th><label for="inputText01-2">가입년월</label></th>
			<td>
				<input class="readOnly w150" type="text" name="CMPY_FROM_M" id="CMPY_FROM_M" value=""  readonly />                                
                           </td>
			<th><label for="inputText01-3">월납입액</label></th>
			<td>
				<input class="alignRight readOnly w150" type="text" name="MNTH_AMNT" value="" id="MNTH_AMNT" readonly />									
			</td>
		</tr>													
		<tr>
			<th><label for="inputText01-4">가입기간</label></th>
			<td>
				<input class="readOnly w150" type="text" name="ENTR_TERM" value="" id="ENTR_TERM" readonly />		
			</td>
			<th><label for="inputText01-5">불입누계</label></th>
			<td>
				<input class="alignRight readOnly w150" type="text" name="SUMM_AMNT" value="" id="SUMM_AMNT" readonly />
			</td>
		</tr>
		<tr>
			<th><label for="inputText01-6">만기연월</label></th>
			<td>
				<input class="readOnly w150" type="text" name="CMPY_TOXX_M" value="" id="CMPY_TOXX_M" readonly />									
			</td>
			<th><label for="inputText01-7">해약일자</label></th>
			<td colspan="3">
				<input class="inputMoney readOnly w150" type="text" name="ABDN_DATE" value="" id="ABDN_DATE" readonly />					
			</td>
		</tr>
		<tr>
			<th><label for="inputText01-8">잔여월수</label></th>
			<td>
				<input class="readOnly w150" type="text" name="LAST_MNTH" value="" id="LAST_MNTH" readonly />				
			</td>
			<th><label for="inputText01-9">가입보험사</label></th>
			<td>
				<input class="readOnly w150" type="text" name="BANK_TEXT" value="" id="BANK_TEXT" readonly />				
			</td>
		</tr>						
		</tbody>
		</table>
	</div>	
  </form>								
</div>	
<!--// Table end -->
<!--------------- layout body end --------------->		
<script type="text/javascript">
	
	// 개인연금 조회
	var getPensionSearchList = function() {
		   	jQuery.ajax({
		   		type : 'POST',
		   		url : '/manager/supp/getPersonalPensionList.json',
		   		cache : false,
		   		dataType : 'json',
	    		data : {
	    		    "PENT_TYPE" : $("#PENT_TYPE").val(),
	    		    "ENTR_DATE" : $("#ENTR_DATE").val()
				},
		   		async :false,
		   		success : function(response) {
		   			if(response.success){
							var item = response.storeData[0];
							$("#PENT_TEXT").val(item.PENT_TEXT);    //연금구분
							$("#CMPY_FROM_M").val(item.CMPY_FROM.substring(0,7));  //가입년월
							$("#ENTR_TERM").val(parseInt(item.ENTR_TERM));    //가입기간
							$("#CMPY_TOXX_M").val(item.CMPY_TOXX.substring(0,7));  //만기연월
							$("#LAST_MNTH").val(item.LAST_MNTH);   //잔여월수
							$("#BANK_TEXT").val(item.BANK_TEXT);   //가입보험사
							$("#MNTH_AMNT").val(item.MNTH_AMNT.format());   //월납입액
							$("#SUMM_AMNT").val(item.SUMM_AMNT.format());   //불입누계
							$("#ABDN_DATE").val(item.ABDN_DATE);   //혜약일자
			    		    $("#STATUS").val(item.STATUS);
							
		   			}else{
		   				alert("개인 연금 조회시 오류가 발생하였습니다. " + response.message);
		   			}
		   		}
		   	});
		 };
		// 개인연금 상세내역 조회
        $(function() {
            $("#personalPensionInfo").jsGrid({
            	height: "auto",
                width: "100%",
                paging: true,
                autoload: true,
        		controller : {
        			loadData : function() {
        				var d = $.Deferred();
        				$.ajax({
        					type : "GET",
        					url : "/manager/supp/getPersonalPensionList.json",
        					dataType : "json",
        				}).done(function(response) {
        					if(response.success){
        						d.resolve(response.storeData);
        					}else{
        	    				alert("조회시 오류가 발생하였습니다. " + response.message);
        	    			}
        				});
        				return d.promise();
        			}
        		},
                fields: [
            		{
               			title: "선택", name: "th1", align: "center", width: "8%",
               			itemTemplate: function(_, item) {
               				return $("<input name='pensionRadio'>")
               					   .attr("type", "radio")
               					   .on("click", function(e) {
               						$("#PENT_TYPE").val(item.PENT_TYPE);
               						$("#ENTR_DATE").val(item.ENTR_DATE);
               						getPensionSearchList();
               					   });
               			}
               		},
                    { title: "연금구분", name: "PENT_TEXT", type: "text", align: "center", width: "23%" },
                    { title: "가입년월", name: "CMPY_FROM", type: "text", align: "center", width: "23%" },
                    { title: "만기연월", name: "CMPY_TOXX", type: "text", align: "center", width: "23%" },
                    { title: "해약일자", name: "ABDN_DATE", type: "text", align: "center", width: "23%" }
                ]
            });					
        });
</script>					

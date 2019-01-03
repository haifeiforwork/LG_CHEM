<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E25InfoJoin.*" %>
<%@ page import="hris.E.E25InfoJoin.rfc.* "%>

<%
    Vector  InfoListData_vt = (Vector)request.getAttribute("InfoListData_vt");
%>

<!--// Page Title start -->
<div class="title">
	<h1>인포멀</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">인포멀</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">인포멀 가입신청</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">인포멀 가입내역</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">	
	<!--// Table start -->	
<form id="informalJoinForm" name="informalJoinForm" method="post">
<input type="hidden" name="MEMBER" id="MEMBER" />
<input type="hidden" name="MGART" id="MGART" />
<input type="hidden" name="STEXT" id="STEXT" />
<input type="hidden" name="PERN_NUMB" id="PERN_NUMB" />
<input type="hidden" name="TITEL" id="TITEL" />
	<div class="tableArea">
		<h2 class="subtitle">인포멀 가입신청</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>인포멀 가입신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="inputText01-1">신청일</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-2">인포멀회</label></th>
				<td colspan="3">
					<select id="informal" name="informal" vname="인포멀회" required> 
						<option value="">---------선택---------</option>
<%
					for( int i = 0; i < InfoListData_vt.size(); i++ ) {
						E25InfoListData infolistdata = (E25InfoListData)InfoListData_vt.get(i);
%>
						<option value="<%= infolistdata.MGART %>"  ENAME="<%= infolistdata.ENAME%>"  USRID="<%= infolistdata.USRID%>"  MEMBER="<%= infolistdata.MEMBER%>" MGART="<%= infolistdata.MGART%>" STEXT="<%= infolistdata.STEXT%>" PERN_NUMB="<%= infolistdata.PERN_NUMB%>" TITEL="<%= infolistdata.TITEL%>"><%= infolistdata.STEXT %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<th><label for="inputText01-3">간사</label></th>
				<td>
					<input class="readOnly w150" type="text" name="ENAME" id="ENAME" readonly vname="간사" required />
				</td>
				<th><label for="inputText01-4">연락처</label></th>
				<td>
					<input class="readOnly w150" type="text" name="USRID" id="USRID" readonly vname="연락처" required/>
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">가입안내</span></p>
			<ul>
				<li>신청 시 신청내용이 간사에게 전송됩니다.</li>
				<li>회비는 가입월부터 급여공제 됩니다. </li>
			</ul>
		</div>
	</div>
	<!--// Table end -->
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a class="darken" href="javascript:InformalJoinClient();" id="informalJoinBtn"><span>가입신청</span></a></li>
		</ul>
	</div>
	</form>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
<form id="secessionForm" name="secessionForm" method="post">
<input type="hidden" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" name="BEGDA0" id="BEGDA0" />
<input type="hidden" value="" name="STEXT0" id="STEXT0" />
<input type="hidden" value="" name="BETRG0" id="BETRG0" />
<input type="hidden" value="" name="ENAME0" id="ENAME0" />
<input type="hidden" value="" name="APPL_DATE0" id="APPL_DATE0" />
<input type="hidden" value="" name="MGART0" id="MGART0" />
<input type="hidden" value="" name="LGART0" id="LGART0" />
<input type="hidden" value="" name="PERN_NUMB0" id="PERN_NUMB0" />
<input type="hidden" value="" name="TITEL0" id="TITEL0" />
<input type="hidden" value="" name="USRID0" id="USRID0" />
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">인포멀 가입내역</h2>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a href="javascript:InformalDeleteClient();" id="secessionBtn" class="popLayerAddress_open"><span>탈퇴신청</span></a></li>
			</ul>
		</div>
		<div class="clear"></div>
		<div id="informalList"></div>
	</div>	
	<!--// list end -->
	</form>
</div>
<!--// Tab2 end -->	
<!--------------- layout body end --------------->

<script type="text/javascript">

	$("#tab1").click(function(){
		$("#informalJoinForm").each(function() {
			this.reset();
		});
		$("#informalJoinBtn").prop("disabled", false);
	});
	
	$("#tab2").click(function(){
		$("#informalList").jsGrid("search");
	});
	
	$("#informal").change(function(){
		//인포멀회에 대한 데이터 가져오기
		jQuery.ajax({
			type : "POST",
			url : "/supp/getInformalInfoList.json",
			cache : false,
			dataType : "json",
			autoload: true,
			async :false,
			success : function(response) {
				if(response.success){
					// 교육과정 옵션 설정
					$('#ENAME').val($('#informal option:selected').attr("ENAME"));
					$('#USRID').val($('#informal option:selected').attr("USRID"));
					$('#MEMBER').val($('#informal option:selected').attr("MEMBER"));
					$('#MGART').val($('#informal option:selected').attr("MGART"));
					$('#STEXT').val($('#informal option:selected').attr("STEXT"));
					$('#PERN_NUMB').val($('#informal option:selected').attr("PERN_NUMB"));
					$('#TITEL').val($('#informal option:selected').attr("TITEL"));
				}
				else{
					alert("인포멀회 조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	});
	
	// 인포멀 가입 신청 validation
	var InformalJoinClientCheck = function() {
		if(!checkNullField("informalJoinForm")){
			return false;
		}
		if( $("#MEMBER").val() == "1") {
			alert("이미 회원입니다.");
			return false;
		}
		return true;
	}
	
	// 인포멀 가입신청
	var InformalJoinClient = function() {
		if(confirm("가입 신청 하시겠습니까?")){
			$("#informalJoinBtn").prop("disabled", true);
			if( InformalJoinClientCheck() ) { 
				var param = $("#informalJoinForm").serializeArray();
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestInformalJoin.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("가입 신청 되었습니다.");
							// 초기화
							$("#informalJoinForm").each(function() {
								this.reset();
							});
						}else{
							alert("가입 신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#informalJoinBtn").prop("disabled", false);
					}
				}); 
			}
		}
	}
	
	// 인포멀 가입내역 리스트
	$(function() {
		$("#informalList").jsGrid({
			height: "auto",
			width: "100%",
			paging: true,
			autoload: false,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/supp/getInformalList.json",
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
						return $("<input name='CHECK_ITEM'>")
								.attr("type", "checkbox")
								.on("click", function(e) {
									$("#STEXT0").val(item.STEXT);
									$("#BETRG0").val(item.BETRG);
									$("#ENAME0").val(item.ENAME);
									$("#APPL_DATE0").val(item.BEGDA);
									$("#MGART0").val(item.MGART);
									$("#LGART0").val(item.LGART);
									$("#PERN_NUMB0").val(item.PERN_NUMB);
									$("#TITEL0").val(item.TITEL);
									$("#USRID0").val(item.USRID);
								});
					}
				},
				{ title: "가입일", name: "BEGDA", type: "text", align: "center", width: "19%" },
				{ title: "인포멀회", name: "STEXT", type: "text", align: "center", width: "18%" },
				{ title: "회비(원)", name: "BETRG", type: "text", align: "center", width: "18%" ,
					itemTemplate: function(value,storeData) {
						return value.format();
					}
				},
				{ title: "간사", name: "ENAME", type: "text", align: "center", width: "18%" ,
					itemTemplate: function(value,storeData) {
						return value + " " + storeData.TITEL;
					}
				},
				{ title: "연락처", name: "USRID", type: "text", align: "center", width: "19%" },
			]
		});
	});
	
	
	// 인포멀 가입내역 탈퇴신청
	var InformalDeleteClient = function() {
		if(confirm("탈퇴 신청 하시겠습니까?")){
			$("#secessionBtn").prop("disabled", true);
			jQuery.ajax({
				type : 'POST',
				url : '/supp/requestInformalLeave.json',
				cache : false,
				dataType : 'json',
				data : $("#secessionForm").serialize(),
				async :false,
				success : function(response) {
					if(response.success){
						alert("탈퇴 신청 되었습니다.");
					}else{
						alert("탈퇴 신청시 오류가 발생하였습니다. " + response.message);
					}
					$("#informalList").jsGrid("search");
					$("#secessionBtn").prop("disabled", false);
				}
			}); 
		}
	} 
</script>
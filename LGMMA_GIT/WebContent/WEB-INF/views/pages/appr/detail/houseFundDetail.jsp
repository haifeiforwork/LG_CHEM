<%@page import="com.lgmma.ess.app.controller.ApplController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>

<%
	WebUserData user = (WebUserData)session.getValue("user");
	E05PersInfoData E05PersInfoData    = (E05PersInfoData)request.getAttribute("E05PersInfoData");
	Vector          E05MaxMoneyData_vt = null ;
	String          E_WERKS            = (String)request.getAttribute("E_WERKS");
    String 			temp_ainf_seqn = (String)request.getAttribute("AINF_SEQN");

    E05HouseRequestRFC  rfc              = new E05HouseRequestRFC();
    
    Vector              E05HouseData1_vt = new Vector();
    Vector              E05HouseData2_vt = new Vector();
    E05HouseData        E05HouseData     = new E05HouseData();
    
    E05HouseData1_vt = rfc.getDetail(temp_ainf_seqn);
    if( E05HouseData1_vt.size() > 0 ) {
        E05HouseData2_vt = (Vector)E05HouseData1_vt.get(0);
        E05HouseData     = (E05HouseData)E05HouseData2_vt.get(0);
    }    
    
    E05PersInfoData = (E05PersInfoData)(new E05PersInfoRFC()).getPersInfo(user.empNo);
    E05MaxMoneyData_vt = (new ApplController()).getMaxMoney(E05PersInfoData, user.companyCode);
%>

<div class="tableArea">
	<h2 class="subtitle">주택자금 신규 신청 상세내역</h2>
	<div class="table">
	<form id="detailForm" name="detailForm">	
		<table class="tableGeneral">
		<caption>주택자금 신규신청</caption>
		<colgroup>
			<col class="col_15p">
            <col class="col_35p">
            <col class="col_15p">
            <col class="col_35p">
		</colgroup>
		<tbody>
		<tr>
			<th><label for="inputText01-1">신청일</label></th>
			<td class="tdDate">
				<input class="readOnly" type="text" name="BEGDA"  id="BEGDA" readonly />
			</td>
			<th><label for="a1">결재일</label></th>
            <td class="tdDate"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="DLART">주택융자유형</label></th>
			<td colspan="3">
				<select class="w150 readOnly" id="DLART" name="DLART" required vname="주택융자유형" disabled>
					<option value="" selected>------------</option>
					<%= WebUtil.printOption((new E05LoanCodeRFC()).getLoanType()) %>
				</select>
			</td>
		</tr>
		<tr>
			<th><label for="inputText01-3">현주소</label></th>
			<td colspan="3">
				<input class="readOnly wPer" type="text" name="E_STRAS" id="E_STRAS"  readonly />
			</td>
		</tr>
		<tr>
			<th><label for="E_YEARS">근속년수</label></th>
			<td colspan="3">
				<input class="alignRight w120 readOnly" type="text" name="E_YEARS" id="E_YEARS" readonly /> 년
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="REQU_MONY">신청금액</label></th>
			<td colspan="3">
				<input class="inputMoney w120 readOnly" type="text" id="REQU_MONY" name="REQU_MONY" onkeyup="cmaComma(this);" onchange="cmaComma(this);"  required vname="신청금액" /> 원
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="GUBN_FLAG">상환방법</label></th>
			<td colspan="3">
				<input type="radio" name="GUBN_FLAG" id="GUBN_FLAG1" value="P" checked/><label for="GUBN_FLAG1">정기급여</label> 
                   <% if ( user.e_persk.equals("31")){  %>
                      <input type="radio" name="GUBN_FLAG" id="GUBN_FLAG2" value="B"/><label for="GUBN_FLAG2">정기급여 + 정기상여 상환</label>
                   <% } %>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="ZZFUND_CODE">자금용도</label></th>
			<td colspan="3">
				<select class="w150 readOnly" id="ZZFUND_CODE" name="ZZFUND_CODE" required vname="자금용도" disabled>
					<option value="">------------</option>
<%= WebUtil.printOption((new E05FundCodeRFC()).getFundCode(E05HouseData.DLART), E05HouseData.ZZFUND_CODE) %>				
				</select>
			</td>
		</tr>
		<tr>
			<th><span class="textPink">*</span><label for="input-radio02-1">보증여부</label></th>
			<td colspan="3">
				<input type="radio" name="ZZSECU_FLAG" value="Y" id="ZZSECU_FLAG1"  /><label for="ZZSECU_FLAG1" disabled >연대보증인 입보</label>
				<input type="radio" name="ZZSECU_FLAG" value="N" id="ZZSECU_FLAG2" /><label for="ZZSECU_FLAG2" disabled >보증보험가입희망</label>
			</td>
		</tr>
		</tbody>
		</table>
		<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">		
		</form>
	</div>
</div>

<script>
var detailSearch= function() {
	$.ajax({
		type : "get",
		url : "/appl/getHouseFundDetail.json",
		dataType : "json",
		data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
	}).done(function(response) {
		if(response.success) {
			setDetail(response.E05PersInfoData);
			setDetail(response.E05HouseData);
			setDetail(response.E05MaxMoneyData_vt);
		}
		else
			alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
	});
	var setDetail = function(item){
		setTableText(item, "detailForm");
		
		if(item.ZZSECU_FLAG=='Y'){
			$('#ZZSECU_FLAG1').prop({"checked": true , "disabled" : true});
			$('#ZZSECU_FLAG2').prop({"checked": false , "disabled" : true});
			$('#ZZSECU_FLAG3').prop({"checked": false , "disabled" : true});
		}else if(item.ZZSECU_FLAG=='N'){
			$('#ZZSECU_FLAG1').prop({"checked": false , "disabled" : true});
			$('#ZZSECU_FLAG2').prop({"checked": true , "disabled" : true});
			$('#ZZSECU_FLAG3').prop({"checked": false , "disabled" : true});
		}else if(item.ZZSECU_FLAG=='R'){
			$('#ZZSECU_FLAG1').prop({"checked": false , "disabled" : true});
			$('#ZZSECU_FLAG2').prop({"checked": false , "disabled" : true});
			$('#ZZSECU_FLAG3').prop({"checked": true , "disabled" : true});			
		}
	}
};

$(document).ready(function(){
	detailSearch();
});
</script>









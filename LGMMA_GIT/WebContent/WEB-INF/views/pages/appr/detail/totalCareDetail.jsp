<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E15General.rfc.*" %>
<%@ page import="hris.E.E15General.*" %>

<%
    String year       = DataUtil.getCurrentYear();
	WebUserData user = (WebUserData)session.getValue("user");
	//E15GeneralData     gdata          = (E15GeneralData)request.getAttribute("e15general");
	E15SexyFlagRFC     func2    = new E15SexyFlagRFC();
	
    E15GeneralData     gdata    = (E15GeneralData)func2.getSexyFlag(user.empNo, year); 
	Vector             Area_vt        = (Vector)request.getAttribute("Area_vt");
	E15GeneralFlagData flagdata       = (E15GeneralFlagData)request.getAttribute("E15GeneralFlagData");
%>

	<div class="tableArea">
		<h2 class="subtitle">종합검진 신청 상세내역</h2>
		<div class="table">
			<form id="detailForm" name="detailForm">
			<table class="tableGeneral">
			<caption>종합검진 신청 상세내역</caption>
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
					<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
				</td>
				<th><label for="a1">결재일</label></th>
				<td class="tdDate"><input class="readOnly" type="text" value="${APPR_DATE}" id="a1" readonly="readonly"></td>
			</tr>
			<tr>
				<th><label for="inputText01-2">검진년도</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" name="EXAM_YEAR" value="<%= DataUtil.getCurrentYear() %>" id="EXAM_YEAR" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-3">구분</label></th>
				<td>
					<input class="readOnly" type="text" name="GUEN_NAME" value="" id="GUEN_NAME" readonly />
					<select name="GUEN_CODE" id="GUEN_CODE" vname="구분" required>
						<option value="">-------선택-------</option>
<%
	if( gdata.M_FLAG.equals("Y") ) {
%> 						
						<option value="0001">본인</option>
<%
	}if( gdata.F_FLAG.equals("Y") ) {
%>
						<option value="0002">배우자</option>
<%
	}
%>
					</select>
				</td>
				<th><span class="textPink">*</span><label for="inputDate01">검진희망일자 </label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" name="EZAM_DATE" value="" id="EZAM_DATE" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="inputText01-5">검진지역</label></th>
				<td>

                    <input type="hidden" name="AREA_CODE" value="">
					<input class="readOnly" type="text" name="AREA_NAME" value="" id="AREA_NAME" readonly />
				</td>
				<th><span class="textPink">*</span><label for="inputText01-6">검진희망병원 </label></th>
				<td>
					<input class="readOnly" type="text" name="HOSP_NAME" value="" id="HOSP_NAME" readonly />
					<select name="HOSP_CODE" class="input03" id="HOSP_CODE" vname="검진희망병원" required>
						<option value="">-------선택-------</option>

					</select>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="inputText01-7">전화(휴대폰)</label></th>
				<td>
					<input class="readOnly" type="text" name="ZHOM_NUMB" value="" id="ZHOM_NUMB" vname="전화(휴대폰)" readonly/>
				</td>
				<th><label for="inputText01-8">전화(회사)</label></th>
				<td>
					<input class="readOnly" type="text" name="COMP_NUMB" value="" id="COMP_NUMB" readonly />
				</td>
			</tr>
<%
	if( user.e_werks.equals("AA00") ) {
%>
			<tr>
				<th><label for="inputText01-9">소화기 검사항목<br>본인 선택사항<font color="#0000FF"><b>*</b></font></td>
				<td class="td02" colspan="3"> 
					<input type="radio" name="EXAM_GUEN" value="1" disabled>위내시경&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="EXAM_GUEN" value="2" disabled>위 수면내시경 (일정금액 본인부담함)&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="EXAM_GUEN" value="3" disabled>위투시X-선검사
				</td>
			</tr>
<%
	}
%>
			<tr>
				<th><label for="inputText01-9">대장내시경 여부</label></th>
				<td colspan="3">
					<input type="checkbox" id="SCOPE_APPLY_CHECK" name="SCOPE_APPLY_CHECK" >
				</td>
			</tr>
			<tr>
				<th><label for="inputText01-9">선택검사 및<br>기타요구사항</label></th>
				<td colspan="3">
					<input type="text" class="readOnly wPer" name="REQUIRE" id="REQUIRE" maxlength="100" readonly/>
				</td>
			</tr>
			</tbody>
			</table>
			<input type="hidden" id="AINF_SEQN" name="AINF_SEQN">
			<input type="hidden" id="EZAM_DATE"  name="EZAM_DATE" value=""/>
			<input type="hidden" id="GUEN_NAME"  name="GUEN_NAME" value=""/>
			<input type="hidden" id="HOSP_NAME"  name="HOSP_NAME" value=""/>
			<input type="hidden" id="SCOPE_APPLY"  name="SCOPE_APPLY"  value="">
			<input type="hidden" name="M_FLAG"    value="<%= gdata.M_FLAG %>">
			<input type="hidden" name="F_FLAG"    value="<%= gdata.F_FLAG %>">
			</form>
		</div>
	</div>
<script>
var detailSearch= function() {

	$('#GUEN_CODE').hide();
	$('#HOSP_CODE').hide();
	
	$.ajax({
		type : "get",
		url : "/appl/getTotalCareDetail.json",
		dataType : "json",
		data : {"AINF_SEQN" : '<c:out value="${AINF_SEQN}"/>'}
	}).done(function(response) {
		if(response.success) {
			setDetail(response.storeData);
		}
		else
			alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
	});
	var setDetail = function(item){
		setTableText(item, "detailForm");
		if(item.SCOPE_APPLY=='X'){
			$('#SCOPE_APPLY_CHECK').prop({"checked": true, "disabled" : true});
		}else{
			$('#SCOPE_APPLY_CHECK').prop({"checked": false, "disabled" : true});
		}
		
	}
};

$(document).ready(function(){
	detailSearch();
});
</script>
	
	
	
	
	
	
	
	

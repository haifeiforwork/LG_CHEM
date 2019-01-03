<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.A.A04FamilyDetailData"%>
<%@ page import="hris.common.rfc.CurrencyCodeRFC"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E22Expense.E22ExpenseListData"%>
<%@ page import="hris.E.E21Expense.E21ExpenseChkData"%>
<%@ page import="hris.E.E21Entrance.E21EntranceDupCheckData"%>
<%@ page import="hris.common.WebUserData"%>
<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
	Vector A04FamilyDetailData_vt = (Vector)request.getAttribute("A04FamilyDetailData_vt");
	Vector E21ExpenseChkData_vt = (Vector)request.getAttribute("E21ExpenseChkData_vt");
	Vector E22ExpenseListData_vt = (Vector)request.getAttribute("E22ExpenseListData_vt");
	Vector e21EntranceDupCheck_vt = (Vector)request.getAttribute("e21EntranceDupCheck_vt");
	
	//  현재년도 기준으로 일년전부터, 일년후까지 (3년간)
	int i_date = Integer.parseInt( DataUtil.getCurrentDate().substring(0,4) );
	
	Vector CodeEntity_vt = new Vector();
	for( int i = i_date - 1 ; i <= i_date + 1 ; i++ ){
		CodeEntity entity = new CodeEntity();
		entity.code  = Integer.toString(i);
		entity.value = Integer.toString(i);
		CodeEntity_vt.addElement(entity);
	}
	
%>
<!--// Page Title start -->
<div class="title">
	<h1>장학자금</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">장학자금</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">장학자금 신청</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');">유치원비 신청</a></li>
		<li><a href="#" id="tab3" onclick="switchTabs(this, 'tab3');">장학자금.유치원비 지원내역</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
<%
	if(A04FamilyDetailData_vt.size() == 0){
%>
	<div class="errorArea">
		<div class="errorMsg">	
			<div class="errorImg"><!-- 에러이미지 --></div>
			<div class="alertContent">
				<p><%=request.getAttribute("MESSAGE") %></p>
			</div>
		</div>
	</div>
<%
	}else{
%>
	<!--// Table start -->
	<form id="requestScholarshipForm">
	<div class="tableArea">
		<h2 class="subtitle">장학자금 신청</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>장학자금 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="requestScholarshipBegda">신청일</label></th>
				<td colspan="3" class="tdDate">
					<input class="readOnly" type="text" id="requestScholarshipBegda" name="BEGDA" value='<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>' readonly />
				</td>
			</tr>
			<tr>
				<th><label for="requestScholarshipFamsa">가족선택</label></th>
				<td colspan="3">
					<input class="readOnly w40" type="text" id="requestScholarshipFamsa" name="FAMSA" value="<%= ((A04FamilyDetailData)A04FamilyDetailData_vt.get(0)).SUBTY%>" readonly />
					<input class="readOnly w100" type="text" id="requestScholarshipAtext" name="ATEXT" value="<%= ((A04FamilyDetailData)A04FamilyDetailData_vt.get(0)).STEXT%>" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestScholarshipSubfType">신청유형</label></th>
				<td>
					<select id="requestScholarshipSubfType" name="SUBF_TYPE" vname="신청유형" required> 
						<option value="">---------선택---------</option>
						<option value="2">학자금(중/고등학교)</option>
						<option value="3">장학금(대학교)</option>
					</select>
				</td>
				<th><span class="textPink">*</span><label for="requestScholarshipPropYear">신청년도</label></th>
				<td>
					<select id="requestScholarshipPropYear" name="PROP_YEAR" vname="신청년도" required> 
						<option value="">------선택------</option>
						<%= WebUtil.printOption(CodeEntity_vt)%>
					</select>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestScholarshipPay1Type">신청구분</label></th>
				<td>
					<input type="radio" id="requestScholarshipPay1Type" name="PAY_TYPE" value="1" checked="checked" /><label for="requestScholarshipPay1Type">신규분</label>
					<input type="radio" id="requestScholarshipPay2Type" name="PAY_TYPE" value="2" /><label for="requestScholarshipPay2Type">추가분</label>
				</td>
				<th><span class="textPink">*</span><label for="requestScholarshipSelType">신청분기ㆍ학기</label></th>
				<td>
					<select id="requestScholarshipSelType" name="selType" vname="신청분기ㆍ학기" required>
						<option value="">------선택------</option>
					</select>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestScholarshipFullName">이름</label></th>
				<td colspan="3">
					<select id="requestScholarshipFullName" name="full_name" vname="이름" required>
						<option value="">------선택------</option>
<%
	for ( int i = 0 ; i < A04FamilyDetailData_vt.size() ; i++ ) {
		A04FamilyDetailData data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
%>
						<option value ="<%= i %>" 
								SUBTY="<%=data.SUBTY%>" 
								OBJC_CODE="<%=data.OBJPS%>" 
								LNMHG="<%=data.LNMHG%>" 
								FNMHG="<%=data.FNMHG%>" 
								ACAD_CARE="<%=data.FASAR%>" 
								STEXT="<%=data.STEXT1%>" 
								FASIN="<%=data.FASIN%>" >
								<%=data.LNMHG.trim()%> <%=data.FNMHG.trim()%></option>
<%
	}
%>
					</select>
				</td>
			</tr>
			<tr>
				<th><label for="requestScholarshipAcadCare">학력</label></th>
				<td colspan="3">
					<input class="readOnly w40" type="text" id="requestScholarshipAcadCare" name="ACAD_CARE" readonly />
					<input class="readOnly w100" type="text" id="requestScholarshipStext" name="STEXT" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="requestScholarshipFasin">교육기관</label></th>
				<td>
					<input class="readOnly w250" type="text" id="requestScholarshipFasin" name="FASIN" readonly />
				</td>
				<th><span class="textPink">*</span><label for="requestScholarshipAcadYear">학년 </label></th>
				<td>
					<input class="w60" type="text" name="ACAD_YEAR" id="requestScholarshipAcadYear" vname="학년" required/> 학년
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestScholarshipPropAmnt">신청액</label></th>
				<td>
					<input class="inputMoney readOnly w100" type="text" id="requestScholarshipPropAmnt" name="PROP_AMNT" vname="신청액" required readonly />
					<select id="requestScholarshipWaers" name="WAERS">
						<option value="KRW">KRW</option>
						<!-- 통화키 가져오기-->
<%-- 						<%= WebUtil.printOption((new CurrencyCodeRFC()).getCurrencyCode(), "KRW") %> --%>
						<!-- 통화키 가져오기-->
					</select>
					<a class="inlineBtn" href="#" id="requestBillBtn"><span>등록금 고지서 입력</span></a>
				</td>
				<th><span class="textPink">*</span><label for="requestScholarshipPCount">수혜횟수</label></th>
				<td>
					<input class="readOnly w60" type="text" id="requestScholarshipPCount" name="P_COUNT" readonly />	회
				</td>
			</tr>
			<tr>
				<th><label for="requestScholarshipEntrFiag">입학금</label></th>
				<td colspan="3">
					<input type="checkbox" id="requestScholarshipEntrFiag" name="ENTR_FIAG" value="X" />
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">추가분은 등록금 인상시 선택하여 신청함.</span></p>
		</div>
	</div>
	<input type="hidden" id="requestScholarshipSubty" name="SUBTY" /> <!-- 가족유형 -->
	<input type="hidden" id="requestScholarshipObjcCode" name="OBJC_CODE" /> <!-- 하부유형 -->
	<input type="hidden" id="requestScholarshipLnmhg" name="LNMHG" /> <!-- 성(이름) -->
	<input type="hidden" id="requestScholarshipFnmhg" name="FNMHG" /> <!-- 이름 -->
	<input type="hidden" id="requestPay1Type" name="PAY1_TYPE" />
	<input type="hidden" id="requestPay2Type" name="PAY2_TYPE" />
	<input type="hidden" id="requestPerdType" name="PERD_TYPE" /> <!-- 분기 -->
	<input type="hidden" id="requestHalfType" name="HALF_TYPE" /> <!-- 반기 -->
	<!-- input type="hidden" id="requestScholarshipRegiFee" name="REGI_FEE" />
	<input type="hidden" id="requestScholarshipSchoFee" name="SCHO_FEE" />
	<input type="hidden" id="requestScholarshipMrmbFee" name="MRMB_FEE" />
	<input type="hidden" id="requestScholarshipEntrFee" name="ENTR_FEE" />
	<input type="hidden" id="requestScholarshipMembFee" name="MEMB_FEE" /-->
	</form>
	<!--// Table end -->
	<!--// list start -->
	<div class="listArea" id="decisioner">
	</div>
	<!--// list end -->
	<div class="buttonArea">
		<ul class="btn_crud">
		<c:if test="${selfApprovalEnable == 'Y'}">
			<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
		</c:if>
			<li><a href="#" id="requestScholarshipBtn" class="darken" ><span>신청</span></a></li>
		</ul>
	</div>
	
<%
	}
%>
	
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
<%
	if(A04FamilyDetailData_vt.size() == 0){
%>
	<div class="errorArea">
		<div class="errorMsg">	
			<div class="errorImg"><!-- 에러이미지 --></div>
			<div class="alertContent">
				<p><%=request.getAttribute("MESSAGE") %></p>
			</div>
		</div>
	</div>
<%
	}else{
%>
	<!--// Table start -->
	<form id="requestKinderForm">
	<div class="tableArea">
		<h2 class="subtitle">유치원비 신청</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>유치원비 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_85p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="requestKinderBegda">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" id="requestKinderBegda" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="requestKinderFamsa">가족선택</label></th>
				<td colspan="3">
					<input class="readOnly w40" type="text" id="requestKinderFamsa" name="FAMSA" value="<%= ((A04FamilyDetailData)A04FamilyDetailData_vt.get(0)).SUBTY%>" readonly />
					<input class="readOnly w100" type="text" id="requestKinderAtext" name="ATEXT" value="<%= ((A04FamilyDetailData)A04FamilyDetailData_vt.get(0)).STEXT%>" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestKinderLfname">이름</label></th>
				<td colspan="3">
					<select id="requestKinderLfname" name="LFname" vname="이름" required> 
						<option value="" >------선택------</option>
<%
					for(int i = 0 ; i < A04FamilyDetailData_vt.size() ; i++){
						A04FamilyDetailData data_name = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
%>

						<option value ="<%=i%>" 
								SUBTY="<%=data_name.SUBTY%>" 
								OBJC_CODE="<%=data_name.OBJPS%>" 
								LNMHG="<%=data_name.LNMHG%>" 
								FNMHG="<%=data_name.FNMHG%>" 
								ACAD_CARE="<%=data_name.FASAR%>" 
								STEXT="<%=data_name.STEXT1%>" 
								ATEXT="<%=data_name.ATEXT%>"
								REGNO="<%=data_name.REGNO%>"
								FASIN="<%=data_name.FASIN%>" >
								<%=data_name.LNMHG.trim()%><%=data_name.FNMHG.trim()%></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<th><label for="requestKinderRegno">주민등록번호</label></th>
				<td>
					<input class="readOnly w150" type="text" id="requestKinderRegno" name="REGNO" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="requestKinderAcadCare">학력</label></th>
				<td colspan="3">
					<input class="readOnly w40" type="text" id="requestKinderAcadCare" name="ACAD_CARE" readonly />
					<input class="readOnly w100" type="text" id="requestKinderStext" name="STEXT" readonly />
				</td>
			</tr>
			<tr>
				<th><label for="requestKinderFasin">교육기관</label></th>
				<td>
					<input class="readOnly w250" type="text" id="requestKinderFasin" name="FASIN" readonly />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestKinderPropAmnt">유치원비</label></th>
				<td>
					<input class="inputMoney readOnly w100" type="text" id="requestKinderPropAmnt" name="PROP_AMNT" vname="유치원비" required readonly />
					KRW
					<input type="hidden" name="WAERS" value="KRW"/>
					<span class="pl20">		
						<input type="radio" id="requestKinderRequMnth1" name="REQU_MNTH" value="01" checked/><label for="requestKinderRequMnth1">1개월</label>
						<input type="radio" id="requestKinderRequMnth2" name="REQU_MNTH" value="02" /><label for="requestKinderRequMnth2">2개월</label>	
						<input type="radio" id="requestKinderRequMnth3" name="REQU_MNTH" value="03" /><label for="requestKinderRequMnth3">3개월</label>
					</span>
					<table class="innerTable mt5">
						<colgroup>
						<col width="90px" />
						<col width="*" />
						<col width="90px" />
						<col width="*" />
						<col width="90px" />
						<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<th>1개월</th>
							<td><input class="inputMoney w145" type="text" id="PROP_AMT1" name="PROP_AMT1" onkeyup="cmaComma(this);" onchange="cmaComma(this);" value=""></td>
							<th>2개월</th>
							<td><input class="inputMoney readOnly w145" type="text" id="PROP_AMT2" name="PROP_AMT2" onkeyup="cmaComma(this);" onchange="cmaComma(this);" value="" readonly></td>
							<th>3개월</th>
							<td><input class="inputMoney readOnly w145" type="text" id="PROP_AMT3" name="PROP_AMT3" onkeyup="cmaComma(this);" onchange="cmaComma(this);" value="" readonly></td>
						</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="requestKinderRequDate">시작일 </label></th>
				<td>
					<input class="datepicker w80" type="text" id="requestKinderRequDate" name="REQU_DATE" vname="시작일" required />
				</td>
			</tr>
			<tr>
				<th><label for="requestKinderPaidAmnt">회사지원액</label></th>
				<td>
					<input class="inputMoney readOnly w100" type="text" id="requestKinderPaidAmnt" name="PAID_AMNT" readonly /> KRW
					<table class="innerTable mt5">
						<colgroup>
						<col width="90px" />
						<col width="*" />
						<col width="90px" />
						<col width="*" />
						<col width="90px" />
						<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<th>1개월</th>
							<td><input class="inputMoney w145 readOnly" type="text" id="PAID_AMT1" name="PAID_AMT1" value="" readonly></td>
							<th>2개월</th>
							<td><input class="inputMoney w145 readOnly" type="text" id="PAID_AMT2" name="PAID_AMT2" value="" readonly></td>
							<th>3개월</th>
							<td><input class="inputMoney w145 readOnly" type="text" id="PAID_AMT3" name="PAID_AMT3" value="" readonly></td>
						</tr>
						</tbody>
					</table>	
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<div class="tableComment">
			<p><span class="bold">자녀의 학력사항이 등재되어 있지 않은 경우 신청이 되지 않으므로 자녀 이름 선택시 <br>학력사항이 보이지 않는 경우에는 가족사항 조회에서 자녀를 선택한 후 학력사항을 변경하고 다시 신청하시기 바랍니다. </span></p>
		</div>
	</div>
	<!--// Table end -->
	<input type="hidden" id="requestKinderLnmhg" name="LNMHG" />
	<input type="hidden" id="requestKinderFnmhg" name="FNMHG" />
	</form>
	<!--// Table end -->
	<div class="listArea" id="kinderdecisioner">
		
	</div>
	<!--// list end -->
	<div class="buttonArea">
		<ul class="btn_crud">
		<c:if test="${selfApprovalEnable == 'Y'}">
			<li><a href="#" id="requestNapprovalKindergartenBtn"><span>자가승인</span></a></li>
		</c:if>
			<li><a href="#" id="requestKindergartenBtn" class="darken" ><span>신청</span></a></li>
		</ul>
	</div>
	
<%
	}
%>
	
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 Lnodisplay">
	<!--// list start -->
	
	<div class="listArea">
		<h2 class="subtitle withButtons">장학자금.유치원비 지원내역</h2>
		<div class="clear"></div>
		<div id="scholarshipListGrid" class="jsGridPaging"/>
	</div>
	<!--// list end -->
	
	<!--// Table start -->
	<div class="tableArea">	
		<h2 class="subtitle">장학자금.유치원비 상세내역</h2>	
		<div class="table">
			<form id="ListForm">
			<table class="tableGeneral" id="scholarshipTB">
			<caption>장학자금 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th>지급일</th>
				<td colspan="3" name="PAID_DATE"></td>
			</tr>
			<tr>
				<th>가족선택</th>
				<td colspan="3" name="FAMSA" addValue="ATEXT" addformat="blank"></td>
			</tr>			
			<tr>
				<th>지급유형</th>
				<td name="STEXT"></td>
				<th>신청년도</th>
				<td name="PROP_YEAR"></td>
			</tr>
			<tr>
				<th>지급구분</th>
				<td id="DETAIL_PAY_TYPE"></td>
				<th>신청분기ㆍ학기</th>
				<td id="detailType"></td>
			</tr>
			<tr>
				<th>이름</th>
				<td colspan="3" name="LNMHG" addValue="FNMHG"></td>
			</tr>
			<tr>
				<th><label for="detailAcadCare">학력</label></th>
				<td colspan="3" name="ACAD_CARE" addValue="TEXT4" addformat="blank"></td>
			</tr>
			<tr>
				<th>교육기관</th>
				<td name="FASIN"></td>
				<th>학년</th>
				<td name="ACAD_YEAR"></td>
			</tr>
			<tr>
				<th>신청액</th>
				<td>
					<label name="PROP_AMNT" addValue="WAERS" addformat="blank" format="currency"></label>
					<a class="inlineBtn" href="#" id="detailBillBtn"><span>등록금 고지서</span></a>
				</td>
				<th>수혜횟수</th>
				<td name="P_COUNT" format="currency"></td>
			</tr>
			<tr>
				<th>입학금</th>
				<td colspan="3"><input type="radio" class="checkbox" name="ENTR_FIAG" value="X" disabled></td>
			</tr>
			<tr>
				<th>회사지급액</th>
				<td colspan="3" name="PAID_AMNT" addValue="WAERS" addformat="blank" format="currency"></td>
			</tr>
			<tr>
				<th>연말정산반영액</th>
				<td colspan="3" name="YTAX_WONX" addValue="WAERS" addformat="blank" format="currency"></td>
			</tr>
			<tr>
				<th>반납일자</th>
				<td name="RFUN_DATE"></td>
				<th>반납액</th>
				<td name="RFUN_AMNT" addValue="WAERS" addformat="blank" format="emptyCur"></td>
			</tr>
			<tr>
				<th>반납사유</th>
				<td colspan="3" name="RFUN_RESN"></td>
			</tr>
			<tr>
				<th>비고</th>
				<td colspan="3" name="BIGO_TEXT1" addValue="BIGO_TEXT2" addformat="enter"></td>
			</tr>
			</tbody>
			</table>
			<table class="tableGeneral" id="kindergartenTB" style="display:none;">
			<caption>유치원비 신청</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th>신청일</th>
				<td colspan="3" name="PAID_DATE"></td>
			</tr>
			<tr>
				<th>가족선택</th>
				<td colspan="3" name="FAMSA" addValue="ATEXT" addformat="blank"></td>	
			</tr>
			<tr>
				<th>지급유형</th>
				<td colspan="3" name="STEXT"></td>
			</tr>
			<tr>
				<th>이름</th>
				<td colspan="3" name="LNMHG" addValue="FNMHG"></td>
			</tr>
			<tr>
				<th>학력</th>
				<td colspan="3" name="ACAD_CARE" addValue="TEXT4" addformat="blank"></td>
			</tr>
			<tr class="kinderTr">
				<th>유치원비</th>
				<td colspan="3">
					<label name="PROP_AMNT" addValue="WAERS" addformat="blank" format="currency"></label>
					<label id="reqMNTH"></label>
					<table class="innerTable mt5">
						<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<th>1개월</th>
							<td class="alignRight" name="PROP_AMT1" format="currency"></td>
							<th>2개월</th>
							<td class="alignRight" name="PROP_AMT2" format="currency"></td>
							<th>3개월</th>
							<td class="alignRight" name="PROP_AMT3" format="currency"></td>
						</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr class="kinderTr">
				<th>시작일</th>
				<td colspan="3" name="REQU_DATE"></td>
			</tr>
			<tr>
				<th>회사지급액</th>
				<td colspan="3">
					<label name="PAID_AMNT" addValue="WAERS1" addformat="blank" format="currency"></label>
					<table class="innerTable mt5 kinderTr">
						<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<th>1개월</th>
							<td class="alignRight" name="PAID_AMT1" format="currency"></td>
							<th>2개월</th>
							<td class="alignRight" name="PAID_AMT2" format="currency"></td>
							<th>3개월</th>
							<td class="alignRight" name="PAID_AMT3" format="currency"></td>
						</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th><label for="detailBigoText1">비고</label></th>
				<td colspan="3" name="BIGO_TEXT1" addValue="BIGO_TEXT2" addformat="enter"></td>
			</tr>
			</tbody>
			</table>
			</form>
		</div>
	</div>
	<!--// Table end -->
	
</div>
<!--// Tab3 end -->
<!--------------- layout body end --------------->

<!-- popup : 등록금 고지서 입력 start -->
<div class="layerWrapper layerSizeS" id="popLayerBill" style="display:inherit !important">
	<form id="popupBillForm">
	<div class="layerHeader">
		<strong>등록금 고지서 입력</strong>
		<a href="#" class="btnClose popLayerBill_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="tableArea tablePopup">
				<div class="table">
					<table class="tableGeneral">
					<caption>등록금 고지서 입력</caption>
					<colgroup>
						<col class="col_40p" />
						<col class="col_60p" />
					</colgroup>
					<tbody>
						<tr>
							<th><label for="popupRegiFee">등록금(수업료)</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupRegiFee" name="REGI_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><label for="popupSchoFee">장학금</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupSchoFee" name="SCHO_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><label for="popupMrmbFee">학생회비</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupMrmbFee" name="MRMB_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><label for="popupMembFee">기성회비</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupMembFee" name="MEMB_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><label for="popupEntrFee">입학금</label></th>
							<td>
								<input class="inputMoney wPer" type="text" id="popupEntrFee" name="ENTR_FEE" onkeyup="javascript:cmaComma(this);popupTotalSum(this);" onchange="cmaComma(this);" format="emptyCur">
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="popupTotalFee">합계</label></th>
							<td>
								<input class="inputMoney wPer readOnly" type="text" id="popupTotalFee" name="TOTAL_FEE" onkeyup="cmaComma(this);" onchange="cmaComma(this);"  readonly>
							</td>
						</tr>
					</tbody>
					</table>
				</div>
				<div class="tableComment">
					<p><span class="bold">장학금을 수령한 경우 등록금(수업료)은 장학금을 제외한 금액을 입력하여 주시기 바랍니다.</span></p>
				</div>
			</div>
			<div class="buttonArea buttonCenter" id="popupBtnDiv">
				<ul class="btn_crud">
					<li><a href="#" id="popupInsertFeeBtn" class="darken"><span>확인</span></a></li>
					<li><a href="#" id="popupCanselBtn" ><span>취소</span></a></li>
				</ul>
			</div>
			<!--// Content end  -->
		</div>
	</div>
	</form>
</div>
<!-- //팝업 : 등록금 고지서 입력 end -->

<!-- 프린트 영역 팝업-->		
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong id="printTitle"></strong>
		<a href="#" class="btnClose popLayerPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer">
			<div id="printBody">
				<iframe name="billWritePopup" id="billWritePopup" src="" frameborder="0" scrolling="no" style="float:left; height:1000px; width:700px;"></iframe>
			</div>
		</div>
	</div>
	<div class="buttonArea buttonPrint">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="printPopBillWriteBtn"><span>프린트</span></a></li>
		</ul>
	</div>
	<div class="clear"></div>
</div>
<!-- 프린트 영역 -->


<script type="text/javascript">
	$(document).ready(function(){
		// 신청 버튼
		$("#requestScholarshipBtn").click(function(){
			requestScholarship(false);
		});
		// 자가신청 버튼
		$("#requestNapprovalBtn").click(function(){
			requestScholarship(true);
		});
		$("#requestKindergartenBtn").click(function(){
			requestKindergarten(false);
		});
		$("#requestNapprovalKindergartenBtn").click(function(){
			requestKindergarten(true);
		});

		$('#decisioner').load('/common/getDecisionerGrid?upmuType=06&gridDivId=decisionerGrid');
		
		if($(".layerWrapper").length){
			$("#popLayerBill").popup();
		};
		
		$("#tab1").click(function(){
			$("#requestScholarshipForm").each(function() {
				this.reset();
			});
			
			fncSetFormReadOnly("popupBillForm", false, new Array("popupTotalFee"));
			
			$("#popupBtnDiv").show();
			
			$("#popupBillForm").each(function(){
				this.reset();
			});
			
			$('#decisioner').load('/common/getDecisionerGrid?upmuType=06&gridDivId=decisionerGrid');
		});
		
		$("#tab2").click(function(){
			$("#requestKinderForm").each(function() {
				this.reset();
			});
			$('#kinderdecisioner').load('/common/getDecisionerGrid?upmuType=85&gridDivId=kinderdecisionerGrid');
		});
		
		$("#tab3").click(function(){
			$("#scholarshipListGrid").jsGrid("search");
		});
		
		$("#PROP_AMT1, #PROP_AMT2, #PROP_AMT3").blur(function(){
			copyMoney();
		});
		
		
	
	});
	// 등록금 고지서 팝업 호출
	$("#requestBillBtn").click(function(){
		$("#popLayerBill").popup("show");
	});
	
	// 등록금 고지서 팝업 호출
	$("#detailBillBtn").click(function(){
		fncSetReadOnly("popupBillForm", true);
		$("#popupBtnDiv").hide();		
		$("#popLayerBill").popup("show");
	});
	
	
	// 등록금 고지서 내역 입력
	$("#popupInsertFeeBtn").click(function(){
		popupTotalSumCalc();
		$("#requestScholarshipPropAmnt").val($("#popupTotalFee").val());
		$("#popLayerBill").popup("hide");
	});
	
	//
	$("#popupCanselBtn").click(function(){
		$("#popLayerBill").popup("hide");
	});
	
	// 신청 구분의 추가분 선택시 주의 사항 고지
	$("#requestScholarshipPay2Type").click(function(){
		if($("#requestScholarshipPay2Type").is(":checked"))
		alert("추가분은 등록금 인상시 선택하여 신청함");
	});
	
	// 장학자금 대상 신청 유형 변경
	$("#requestScholarshipSubfType").change(function(){
		//change_type
		if(requestScholarshipChkLogic()){
			requestScholarshipSetCnt();
		}
		
		// 2002.10.18. 분기일경우 보여줌.
		$("#requestScholarshipSelType").empty();//selType
		$("#requestScholarshipSelType").append($("<option value=''>").text("------선택------"));
		
		if( $("#requestScholarshipSubfType option:selected").val() == "2" ) { //신청유형
			for( var i = 1 ; i <= 4 ; i++ ) {
				$("#requestScholarshipSelType").append($("<option>").text(i+"분기").val(i));
			}
			
		}else if( $("#requestScholarshipSubfType option:selected").val() == "3" ) { //장학금
			for( var i = 1 ; i <= 4 ; i++ ) {
				$("#requestScholarshipSelType").append($("<option>").text(i+"학기").val(i));
			}
			
		}
	});
	
	// 장학자금 대상 이름 변경
	$("#requestScholarshipFullName").change(function(){
		$("#requestScholarshipSubty").val($("#requestScholarshipFullName option:selected").attr("SUBTY"));
		$("#requestScholarshipObjcCode").val($("#requestScholarshipFullName option:selected").attr("OBJC_CODE"));
		$("#requestScholarshipLnmhg").val($("#requestScholarshipFullName option:selected").attr("LNMHG"));
		$("#requestScholarshipFnmhg").val($("#requestScholarshipFullName option:selected").attr("FNMHG"));
		$("#requestScholarshipAcadCare").val($("#requestScholarshipFullName option:selected").attr("ACAD_CARE"));
		$("#requestScholarshipStext").val($("#requestScholarshipFullName option:selected").attr("STEXT"));
		$("#requestScholarshipFasin").val($("#requestScholarshipFullName option:selected").attr("FASIN"));
		
		if(requestScholarshipChkLogic()){
			requestScholarshipSetCnt();
		}
	});
	
	// 2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
	var requestScholarshipChkLogic = function(){
		var subfType = $("#requestScholarshipSubfType option:selected").val();
		var type1    = $("#requestScholarshipFullName option:selected").attr("ACAD_CARE");
		
<% if (userData.e_oversea.equals("X") ) { %> 
		if(subfType=="2" && type1!="" && type1!="B1" && type1!="C1" && type1!="D1" && type1!="E1" ){
			alert("학자금신청은 유치원, 초.중.고등학생만 가능합니다.\n\n 가족사항을 확인하세요.");
			return false;
		}
<%
	} else {
%>
		if(subfType=="2" && type1!="" && type1!="D1" && type1!="E1" ){
			alert("학자금신청은 중.고등학생만 가능합니다.\n\n 가족사항을 확인하세요.");
			return false;
		}
<%
	}
%>
		if(subfType=="3" && type1!="" && type1!="F1" && type1!="G1" && type1!="G2"){
			alert("장학금신청은 대학생만 가능합니다.\n\n 가족사항을 확인하세요.");
			return false;
		}
		return true;
	};
	
	// 자녀당 수혜횟수 계산해오는 함수
	var requestScholarshipSetCnt= function(){
		
		$("#requestScholarshipPCount").val("");
		
		var subfType = $("#requestScholarshipSubfType option:selected").val();
		var type1    = $("#requestScholarshipFullName option:selected").attr("ACAD_CARE");
		
		if(type1=="" || subfType==""){
			$("#requestScholarshipPCount").val("");
			return;
		}
		
		simp_type = null;
		if( type1 == "D1"){
			simp_type = "중";
		} else if( type1 == "E1" ){
			simp_type = "고";
		} else if( type1 == "F1" || type1 == "G1" || type1 == "G2" || type1 == "H1" ){
			simp_type = "대";
		} else{
			simp_type = "";
		}
		// 2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
<%
	if( userData.e_oversea.equals("X") ) { // 해외근무자
%>
		if( type1 == "B1" || type1 == "C1" ){
			simp_type = "중";
		}
<%
	}
	for(int i = 0 ; i < E21ExpenseChkData_vt.size() ; i++){
		E21ExpenseChkData dataE21 = (E21ExpenseChkData)E21ExpenseChkData_vt.get(i);
%>
		if( ("<%=dataE21.subty%>" == $("#requestScholarshipFullName option:selected").attr("SUBTY") )
			&& ("<%=dataE21.objps%>" == $("#requestScholarshipFullName option:selected").attr("OBJC_CODE") ) ){
			
			if(subfType=="2"){ // 학자금일때
				if( "<%=dataE21.grade%>" == "중" || "<%=dataE21.grade%>" == "고") {
					$("#requestScholarshipPCount").val($("#requestScholarshipPCount").val() + parseInt("<%=dataE21.count == "" ? 0 : dataE21.count%>"));
					return;
				}
			}else if(subfType=="3" && simp_type=="대"){ // 장학금일때
				if( "<%=dataE21.grade%>" == simp_type ) {
					$("#requestScholarshipPCount").val(parseInt("<%=dataE21.count == "" ? 0 : dataE21.count%>"));
					return;
				}
			}else{
				$("#requestScholarshipPCount").val("");
				return;
			}
		}
<%
	}
%>
		$("#requestScholarshipPCount").val("");
		return;
	};
	
	// 장학자금 신청 check
	var requestScholarshipCheck = function(){
		if(!checkNullField("requestScholarshipForm")){
			return false;
		}
		
		if( $("#requestScholarshipPay1Type").is(":checked") ) { // 신규분 체크
			
			//기입력된 년도-분기ㆍ학기가 있는지 체크하고 있으면 신청을 막는다
<%
		for( int i = 0 ; i < E22ExpenseListData_vt.size() ; i++ ) {
		E22ExpenseListData e22_data = (E22ExpenseListData)E22ExpenseListData_vt.get(i);
%>



			if( ("<%= e22_data.SUBF_TYPE %>" == $("#requestScholarshipSubfType option:selected").val() ) &&
				("<%= e22_data.FAMSA     %>" == $("#requestScholarshipFullName option:selected").attr("SUBTY") ) &&
				("<%= e22_data.OBJC_CODE %>" == $("#requestScholarshipFullName option:selected").attr("OBJC_CODE") ) &&
				("<%= e22_data.PROP_YEAR %>" == $("#requestScholarshipPropYear").val() ) ) {
				
				if($("#requestScholarshipSubfType option:selected").val() == "2"){
					
						
					if( "<%= e22_data.PERD_TYPE %>" == $("#requestScholarshipSelType option:selected").val() && "<%= e22_data.P_COUNT%>" != "000"){
						alert("현재 분기에 이미 지급 받았습니다");
						return false;
					}
				}else if($("#requestScholarshipSubfType option:selected").val() == "3"){
					if( "<%= e22_data.HALF_TYPE %>" == $("#requestScholarshipSelType option:selected").val() && "<%= e22_data.P_COUNT%>" != "000" ){
						alert("현재 학기에 이미 지급 받았습니다");
						return false;
					}
				}
			}
<%
		}
%>
			$("#requestPay1Type").val("X");
			$("#requestPay2Type").val("");
		}else if( $("#requestScholarshipPay2Type").is(":checked") ){
			$("#requestPay1Type").val("");
			$("#requestPay2Type").val("X");
		}else{
			alert("지급구분을 선택하세요");
			return false;
		}
		
		if($("#requestScholarshipSubfType option:selected").val() == "2"){
			$("#requestPerdType").val($("#requestScholarshipSelType option:selected").val());
		}else if($("#requestScholarshipSubfType option:selected").val() == "3"){
			$("#requestHalfType").val($("#requestScholarshipSelType option:selected").val());
		}
		
		// 학자금 수혜한도(중학=>12, 고교=>12) 장학금 수혜한도(8회), 입학금수혜한도(1회)
		type1 = $("#requestScholarshipFullName option:selected").attr("ACAD_CARE");
		
		//  R3 에 학력에 관한 데이타가 없음을 경고...
		if( type1 == "" ){
			alert("시스템에 해당자녀에 대한 학력정보가 없습니다. \n\n 먼저 R/3 Data를 확인해 주세요");
			return false;
		}
		
		simp_type = null;
		if( type1 == "D1" ) {
			simp_type = "중";
		} else if( type1 == "E1" ) {
			simp_type = "고";
		} else if( type1 == "F1" || type1 == "G1" || type1 == "G2" || type1 == "H1" ) {
			simp_type = "대";
		} else {
			simp_type = "";
		}
		//  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
<%
	if( userData.e_oversea.equals("X") ) { // 해외근무자
%>
		if( type1 == "B1" || type1 == "C1" ){
			simp_type = "중";
		}
<%
	}
%>
		count = "";
		enter = "";
<%
for(int i = 0 ; i < E21ExpenseChkData_vt.size() ; i++){
	E21ExpenseChkData dataE21 = (E21ExpenseChkData)E21ExpenseChkData_vt.get(i);
%>
		if( ("<%=dataE21.subty%>" == $("#requestScholarshipFullName option:selected").attr("SUBTY") ) && 
			("<%=dataE21.objps%>" == $("#requestScholarshipFullName option:selected").attr("OBJC_CODE") ) && 
			("<%=dataE21.grade%>" == simp_type ) ){
			count = "<%=dataE21.count%>";
			enter = "<%=dataE21.enter%>";
		}
<%
	}
%>
		if( $("#requestScholarshipPay1Type").is(":checked") ){  //신규분
			if( parseInt(enter) >= 1 && $("#requestScholarshipEntrFiag").is(":checked") ){
				alert("입학금은 1회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
				return false;      
			}else if( ( simp_type == "중" || simp_type == "고" ) && parseInt(count) >= 24 ){
				alert("학자금은 24회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
				return false;
			}else if( simp_type == "대" && parseInt(count) >= 8 ){
				alert("대학 장학금은 8회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
				return false;
			}
		}
		return true;
	}
	
	// 장학자금 신청 버튼
	var requestScholarship = function(self) {
		if( requestScholarshipCheck() ){
			
			if(!requestScholarshipChkLogic()){
				return false;
			}
			
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			decisionerGridChangeAppLine(self);
			if(confirm(msg + "신청 하시겠습니까?")){
				$("#requestScholarshipBtn").prop("disabled", true);
				$("#requestNapprovalBtn").prop("disabled", true);
				var param = $("#requestScholarshipForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				param = $.merge(param, $("#popupBillForm").serializeArray());
				param.push({"name":"selfAppr", "value" : self});
				
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestScholarship.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							$("#printTitle").text("학자금/장학금 신청서");
							$("#billWritePopup").attr("src","/appl/print/scholarshipPrint/?AINF_SEQN=" + response.AINF_SEQN);
							$("#billWritePopup").load(function(){
								$('#popLayerPrint').popup("show");
							});
							
							$("#requestScholarshipForm").each(function() {
								this.reset();
							});
						}else{
							alert("신청시 오류가 발생하였습니다. 상세이유 : " + response.message);
						}
						$("#requestScholarshipBtn").prop("disabled", false);
						$("#requestNapprovalBtn").prop("disabled", false);
					}
				});
			} else {
				decisionerGridChangeAppLine(false);
			}
		}
	}
	// 개월수 체크시 회사 지원액 계산
	$("#requestKinderRequMnth1, #requestKinderRequMnth2, #requestKinderRequMnth3").click(function(){
		setMonthField(this);
		copyMoney();
	});
	
	
	var setMonthField = function(obj){
		//초기화 후 지정
		$("#PROP_AMT1").val("");
		$("#PROP_AMT2").val("");
		$("#PROP_AMT3").val("");
		
		if($(obj).val() == "01"){
			setObjReadOnly($("#PROP_AMT2"), true);
			setObjReadOnly($("#PROP_AMT3"), true);
		} else if($(obj).val() == "02"){
			setObjReadOnly($("#PROP_AMT2"), false);
			setObjReadOnly($("#PROP_AMT3"), true);
		} else if($(obj).val() == "03"){
			setObjReadOnly($("#PROP_AMT2"), false);
			setObjReadOnly($("#PROP_AMT3"), false);
		}
	};
	
	// 유치원비 대상 이름 변경시 체크
	$("#requestKinderLfname").change(function(){
		if($("#requestKinderLfname").val() == ""){
			$("#requestKinderLnmhg").val("");
			$("#requestKinderFnmhg").val("");
			$("#requestKinderRegno").val("");
			$("#requestKinderAcadCare").val("");
			$("#requestKinderStext").val("");
			$("#requestKinderFasin").val("");
		}else{
			if( $("#requestKinderLfname option:selected").attr("ACAD_CARE") != "B1" ) {
				alert("자녀의 학력이 유치원일 경우에만 신청가능합니다.");
				$("#requestKinderLfname").val("");
				return false;
			}
			
			$("#requestKinderAtext").val($("#requestKinderLfname option:selected").attr("ATEXT"));
			$("#requestKinderLnmhg").val($("#requestKinderLfname option:selected").attr("LNMHG"));
			$("#requestKinderFnmhg").val($("#requestKinderLfname option:selected").attr("FNMHG"));
			$("#requestKinderRegno").val($("#requestKinderLfname option:selected").attr("REGNO").substring(0,6)+"-"+$("#requestKinderLfname option:selected").attr("REGNO").substring(6));
			$("#requestKinderAcadCare").val($("#requestKinderLfname option:selected").attr("ACAD_CARE"));
			$("#requestKinderStext").val($("#requestKinderLfname option:selected").attr("STEXT"));
			$("#requestKinderFasin").val($("#requestKinderLfname option:selected").attr("FASIN") );
		}
		
	});
	
	
	var requestKindergarten = function(self) {
		if(requestKindergartenCheck()){
			//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
			var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
			kinderdecisionerGridChangeAppLine(self);
			if(confirm(msg + "신청 하시겠습니까?")){
				//$("#requestKinderPropAmnt").val(removeComma($("#requestKinderPropAmnt").val()));
				//$("#requestKinderPaidAmnt").val(removeComma($("#requestKinderPaidAmnt").val()));
				
				$("#requestKindergartenBtn").prop("disabled", true);
				$("#requestNapprovalKindergartenBtn").prop("disabled", true);
				var param = $("#requestKinderForm").serializeArray();
				$("#kinderdecisionerGrid").jsGrid("serialize", param);
				param.push({"name":"selfAppr", "value" : self});
				
				jQuery.ajax({
					type : 'POST',
					url : '/supp/requestKindergarten.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
						if(response.success){
							alert("신청 되었습니다.");
							$("#printTitle").text("유치원비 신청서");
							$("#billWritePopup").attr("src","/appl/print/kindergartenPrint/?AINF_SEQN=" + response.AINF_SEQN);
							$("#billWritePopup").load(function(){
								$('#popLayerPrint').popup("show");
							})
							
							$("#requestKinderForm").each(function() {
								this.reset();
							});
						}else{
							alert("신청시 오류가 발생하였습니다. " + response.message);
						}
						$("#requestKindergartenBtn").prop("disabled", false);
						$("#requestNapprovalKindergartenBtn").prop("disabled", false);
					}
				});
			} else {
				kinderdecisionerGridChangeAppLine(false);
			}
		}
	}
	
	// 유치원비 신청 check
	var requestKindergartenCheck = function(){
		copyMoney();
		
		if(!checkNullField("requestKinderForm")){
			return false;
		}
		
		var l_r3_data = 0;
		if( $("#requestKinderLfname option:selected").attr("ACAD_CARE") == "B1" ) {
<%
		for( int i = 0 ; i < e21EntranceDupCheck_vt.size() ; i++ ) {
			E21EntranceDupCheckData c_Data = (E21EntranceDupCheckData)e21EntranceDupCheck_vt.get(i);
%>
			if( ("<%= c_Data.SUBF_TYPE %>" == "4") &&
				("<%= c_Data.ACAD_CARE %>" == $("#requestKinderLfname option:selected").attr("ACAD_CARE") ) &&
				("<%= c_Data.REGNO     %>" == $("#requestKinderLfname option:selected").attr("REGNO") ) ) {
				if( "<%= c_Data.INFO_FLAG %>" == "I" ) {
					l_r3_data = Number("<%= c_Data.REQU_MNTH %>");
				} else if( "<%= c_Data.INFO_FLAG %>" == "T" ) {
					alert("현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
					return false;
				}
			}
<%
		}
%>
			var l_requ_mnth = $("#requestKinderForm input:radio[name='REQU_MNTH']  ").filter(":checked").val();
			
			//1개월은 픽스
			if(Number($("#PROP_AMT1").val())==0) {
				alert("금액을 입력하세요.");
				return false;
			}
			
			if(l_requ_mnth=="02"){
				if(Number($("#PROP_AMT2").val())==0) {
					alert("금액을 입력하세요.");
					return false;
				}
			} else if(l_requ_mnth=="03"){
				if(Number($("#PROP_AMT2").val())==0 || Number($("#PROP_AMT3").val())==0) {
					alert("금액을 입력하세요.");
					return false;
				}
			}
			
			l_requ_mnth = Number(l_requ_mnth) + Number(l_r3_data);
			if( l_requ_mnth > 12 ) {
				alert("해당 자녀에 대해 12개월 지급만 가능합니다.\n\n현재 지급 횟수 : " + l_r3_data);
				return false;
			}
			
			
			
		} else {
			alert("자녀의 학력이 유치원일 경우에만 신청가능합니다.");
			return false;
		}
		
		return true;
	};
	
	// 회사 지원액 입력
	var copyMoney = function(){
		//지원액 초기화
		$("#requestKinderPropAmnt").val("");
		$("#PAID_AMT1").val("");
		$("#PAID_AMT2").val("");
		$("#PAID_AMT3").val("");
		$("#requestKinderPaidAmnt").val("");
		
		//값이 있으면...
		if($("#PROP_AMT1").val()!="" || $("#PROP_AMT2").val()!="" || $("#PROP_AMT3").val()!=""){
			var PROP_AMT1 = removeComma($("#PROP_AMT1").val());
			var PROP_AMT2 = removeComma($("#PROP_AMT2").val());
			var PROP_AMT3 = removeComma($("#PROP_AMT3").val());
			var TOT_PROP_AMT = Number(PROP_AMT1)+Number(PROP_AMT2)+Number(PROP_AMT3);
			$("#requestKinderPropAmnt").val(insertComma(TOT_PROP_AMT));
			//회사지원액 계산
			var PAID_AMT1 = 0;
			var PAID_AMT2 = 0;
			var PAID_AMT3 = 0;
			// 유치원비를 넣으면 유치원비의 50%와 52,500원중 작은 금액을 회사지원액에 Display
			if(PROP_AMT1 > 0){
				PAID_AMT1 = parseInt(PROP_AMT1/2);
				if( PAID_AMT1 > 52500 ) PAID_AMT1 = 52500;
				$("#PAID_AMT1").val(insertComma(PAID_AMT1));
			}
			
			if(PROP_AMT2 > 0){
				var PAID_AMT2 = parseInt(PROP_AMT2/2);
				if( PAID_AMT2 > 52500 ) PAID_AMT2 = 52500;
				$("#PAID_AMT2").val(insertComma(PAID_AMT2));
			}
			
			if(PROP_AMT3 > 0){
				var PAID_AMT3 = parseInt(PROP_AMT3/2);
				if( PAID_AMT3 > 52500 ) PAID_AMT3 = 52500;
				$("#PAID_AMT3").val(insertComma(PAID_AMT3));
			}
			
			var TOT_PAID_AMT = PAID_AMT1 + PAID_AMT2 + PAID_AMT3;
			if(TOT_PAID_AMT>157500) TOT_PAID_AMT = 157500;
			$("#requestKinderPaidAmnt").val(insertComma(TOT_PAID_AMT));
			
		}
	};
	
	// 등록금 합산
	var popupTotalSum = function(obj){
		if(checkNum(removeComma($(obj).val())) ){
			popupTotalSumCalc();
		}
	}
	
	var popupTotalSumCalc = function(){
		var feeSum = Number(removeComma($("#popupRegiFee").val()))
				     + Number(removeComma($("#popupSchoFee").val()))
					 + Number(removeComma($("#popupMrmbFee").val()))
					 + Number(removeComma($("#popupMembFee").val()))
					 + Number(removeComma($("#popupEntrFee").val()));
		$("#popupTotalFee").val(insertComma(feeSum));
	}
	
	// 장학금,유치원비 지원 내역 grid
	$(function() {
		$("#scholarshipListGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: true,
			autoload: false,
			pageSize: 10,
			pageButtonCount: 10,
			rowClick: function(args){
			},
			controller: {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "get",
						url : "/supp/getScholarshipList.json",
						dataType : "json",
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
					title: "선택", name: "th1", align: "center", width: "8%"
					,itemTemplate: function(_, item) {
						return	$("<input name='chk'>")
								.attr("type", "radio")
								.on("click",function(e){
									if( (item.SUBF_TYPE != "1") && (item.SUBF_TYPE != "4") ){  // 2, 3
										$("#scholarshipTB").show();
										$("#kindergartenTB").hide();
										setTableText(item, "scholarshipTB");
										$("#detailType").html(item.SUBF_TYPE == "2" ? (item.PERD_TYPE == "0" ? "" : item.PERD_TYPE + " 분기") : (item.HALF_TYPE == "0" ? "" : item.HALF_TYPE + " 학기"));
										$("#DETAIL_PAY_TYPE").text("신규분");
										if(item.PAY2_TYPE=="X"){
											$("#DETAIL_PAY_TYPE").text("추가분");
										}
									}else{  // 1, 4

										$("#scholarshipTB").hide();
										$("#kindergartenTB").show();
										
										setTableText(item, "kindergartenTB");
										if(item.SUBF_TYPE == "4") {
											$(".kinderTr").show();
											$("#reqMNTH").text("[ " + Number(item.REQU_MNTH) + "개월 ]");
										} else {
											$(".kinderTr").hide();
										}
									}
									
									setTableText(item, "popupBillForm");
									popupTotalSumCalc();
									
								});
					}
				},
				{	title: "신청일", name: "BEGDA", type: "text", align: "center", width: "10%" 
					,itemTemplate : function(value, item){
						return value == "0000.00.00" ? "과거수혜이력" : value;
					}
				},
				{	title: "지급유형", name: "STEXT", type: "text", align: "center", width: "12%" },
				{	title: "지급구분", name: "PAY1_TYPE", type: "text", align: "center", width: "14%" 
					,itemTemplate : function(value,item){
						if(item.SUBF_TYPE!="1" || item.SUBF_TYPE!="4"){
							var val = "신규분";
							if(item.PAY2_TYPE=="X") val = "추가분";
							return val;
						}
					}
				},
				{	title: "성명", name: "LNMHG", type: "text", align: "center", width: "13%" 
					,itemTemplate : function(value,item){
						return value + item.FNMHG;
					}
				},
				{	title: "신청액", name: "SUBF_TYPE", type: "text", align: "right", width: "15%" 
					,itemTemplate : function(value,item){
						if(value =="1"){
							return "";
						}else{
							if(item.PROP_AMNT == "0"){
								return "";
							}else{
								return parseInt(item.PROP_AMNT).format() + " <font color='#0000FF'>" + item.WAERS + "</font>";
							}
						}
					}
				},
				{	title: "회사지급액", name: "PAID_AMNT", type: "number", align: "right", width: "15%" 
					,itemTemplate : function(value,item){
						if(value =="0"){
							return "";
						}else{
							return parseInt(value).format() + " <font color='#0000FF'>" + item.WAERS1 + "</font>";
						}
						
					}
				},
				{	title: "최종결재일", name: "POST_DATE", type: "text", align: "center", width: "13%" 
					,itemTemplate : function(value, item){
						return value == "0000.00.00" ? "" : value;
					}
				}
			]
		});
	});
	
	$("#printPopBillWriteBtn").click(function() {
		$("#printContentsArea").print();
	});
	
</script>



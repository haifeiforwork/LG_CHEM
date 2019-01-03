<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.File"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>
<%@ page import="hris.E.E17Hospital.rfc.E17GuenCodeRFC" %>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.SortUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%
WebUserData 	user					= (WebUserData)session.getValue("user");
E17SickData 	e17SickData	 		= (E17SickData)request.getAttribute("e17SickData");
Vector	  	E17ChildData_vt 		= (Vector)request.getAttribute("E17ChildData_vt");
Vector	  	E17BillData_vt  		= (Vector)request.getAttribute("E17BillData_vt");
Vector	  	MediCode_vt	 			= (Vector)request.getAttribute("MediCode_vt");
E17HospitalData e17HospitalData_vt  	= (E17HospitalData)request.getAttribute("e17HospitalData_vt");
E17BillData 	e17BillData 			= (E17BillData)request.getAttribute("e17BillData");

E17MedicCheckYNRFC checkYN 				= new E17MedicCheckYNRFC();
String			 E_FLAG  				= checkYN.getE_FLAG( DataUtil.getCurrentYear(), user.empNo );
// String	  radio_index		= (String)request.getAttribute("radio_index");

//  통화키에 따른 소수자리수를 가져온다
	double currencyDecimalSize = 2;
	int	currencyValue = 0;
	Vector currency_vt = (new CurrencyDecimalRFC()).getCurrencyDecimal();
	for( int j = 0 ; j < currency_vt.size() ; j++ ) {
		CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
		if( e17SickData.WAERS == codeEnt.code ){
			currencyDecimalSize = Double.parseDouble(codeEnt.value);
		}
	}
	currencyValue = (int)currencyDecimalSize; //???  KRW ->0, USDN ->5
//  통화키에 따른 소수자리수를 가져온다
%>
<!--// Page Title start -->
<div class="title">
	<h1>의료비</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">복리후생</a></span></li>
			<li class="lastLocation"><span><a href="#">의료비</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
<!--------------- layout body start --------------->
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" id ="tab1" onclick="switchTabs(this, 'tab1');" class="selected">의료비 신청</a></li>
						<li><a href="#" id ="tab2" onclick="switchTabs(this, 'tab2');">의료비 지원내역</a></li>
					</ul>
				</div>
				<!--// Tab end -->
				
				<!--// Tab1 start -->
				<div class="tabUnder tab1">
					<!--// Table start -->
					<form id ="requestForm" name ="requestForm">
					<div class="tableArea">
						<h2 class="subtitle withButtons">진료 기본사항</h2>
						<div class="buttonArea">
							<ul class="btn_mdl">
								<li><a href="#popLayerMedicalInfo" class="popLayerMedicalInfo_open"><span>의료비 지원/제외 기준</span></a></li>
								<!-- <li><a href="#" id="popUpText" name="popUpText"><span>의료비 지원/제외 기준</span></a></li> -->
								<li><a href="javascript:showList();"><span>진료비 영수증 서식(참조)</span></a></li>
							</ul>
						</div>
						<!-- 진료비 영수증 서식 레이어 띄우기 -->
						<div class="layerMBF" id="userList" onClick="hideList()" onMouseOver="listOver(this)" onMouseOut="listOut(this)">
							<ul>
								<li><a href="/download/medicalForm/form_No_01.doc" >입원(퇴원·중간) 진료비 계산서·영수증</a></li>
								<li><a href="/download/medicalForm/form_No_02.doc">입원(퇴원·중간) 진료비 계산서·영수증(질병군별 포괄진료비)</a></li>
								<li><a href="/download/medicalForm/form_No_03.doc" >외래 진료비 계산서·영수증</a></li>
								<li><a href="/download/medicalForm/form_No_04.doc" >간이 외래 진료비 계산서·영수증</a></li>
								<li><a href="/download/medicalForm/form_No_05.doc" >한방 입원(퇴원·중간) 진료비 계산서·영수증</a></li>
								<li><a href="/download/medicalForm/form_No_06.doc" >한방 외래 진료비 계산서·영수증</a></li>
								<li><a href="/download/medicalForm/form_No_07.doc" >약제비 계산서·영수증</a></li>
							</ul>
						</div>
						<div class="clear"></div>
						<div class="table">
						
							<table class="tableGeneral">
							<caption>진료 기본사항</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_85p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate()) %>" id="BEGDA" readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="input-radio01-1">관리번호 </label></th>
								<td>
									<input type="radio" name="is_new_num" value="Y" id="is_new_num" onClick="javascript:click_radio(this);" checked="checked" /><label for="input-radio01-1">최초진료</label>
									<input type="radio" name="is_new_num" value="N" id="is_new_num" onClick="javascript:click_radio(this);" /><label for="input-radio01-2">동일진료 </label>
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputSelect01-2">구분<%=(e17SickData.GUEN_CODE == null) ? "" : " ["+e17SickData.GUEN_CODE+"]"%></label></th>
								<td>
								   <select class="w100" id="GUEN_CODE" name="GUEN_CODE" required>
								   <%= WebUtil.printOption((new E17GuenCodeRFC()).getGuenCode(user.empNo), (e17SickData.GUEN_CODE == null) ? "": e17SickData.GUEN_CODE) %>
									</select>
									<input type="checkbox" name="PROOF" id="PROOF" value="X" checked>연말정산반영여부
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputSelect01-3">자녀이름</label></th>
								<td>
									<select class="w100" id="ENAME" name="ENAME" required>
										<option value="">--------</option>
									</select>
									<input class="w150 readOnly" type="text" id="REGNO_dis" name="REGNO_dis" value="" readonly />
									<input class="w150 readOnly" type="text" id="Message" name="Message" value="" readonly />
								</td>
							</tr>
							<input type="hidden" id="OBJPS_21" name="OBJPS_21" value="">
							<input type="hidden" id="REGNO_21" name="REGNO_21" value="">
							<input type="hidden" id="DATUM_21" name="DATUM_21" value="">
							<tr>
								<th><span class="textPink">*</span><label for="inputText01-4">상병명</label></th>
								<td>
									<input class="wPer" type="text" id="SICK_NAME" name="SICK_NAME" value="" />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputText01-5">구체적증상 </label></th>
								<td>
									<textarea class="wPer" id="SICK_DESC" name="SICK_DESC" rows="4" value=""></textarea>
								</td>
							</tr>
							</tbody>
							</table>
						</div>
					</div>
					<!--// Table end -->
					<!--// list start -->
					<div class="listArea">
						<h2 class="subtitle withButtons">의료비 등록</h2>
						<div class="buttonArea">
							<ul class="btn_mdl">
								<li><a class="darken popLayerMedical_open " href="#popLayerMedical" id="popLayerMedicalCreate"><span>등록/추가</span></a></li>
								<li><a href="#" id="popLayerMedicalUpdate" ><span>수정</span></a></li>
								<li><a href="#" id="popLayerMedicalDelete" ><span>삭제</span></a></li>
<!-- 								<li><a href="#" id="popLayerWriteBill"><span>진료비 계산서 입력</span></a></li> -->
							</ul>
						</div>
						<div class="clear"></div>
						<div id="MedicalCreateListGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
						<input type="hidden" id="medi_count" name="medi_count" />
						
						<div class="totalArea">
							<strong>계</strong>
							<span><input class="inputMoney readOnly" type="text" name="EMPL_WONX_tot" id="EMPL_WONX_tot" value="0" readonly /></span>							
							<select id="WAERS" name="WAERS">
								<option value ='KRW' selected>KRW</option>
							</select>
						</div>
						<div class="tableComment">
							<p><span class="bold">안내사항</li>
							<ul>
								<li>진료 기본사항 입력 후, 증빙별 의료비 등록 후 일괄 신청하세요. (진료비 세부항목 입력 불필요)</li>
								<li>제출 서류 : 진료비 계산서(진료비 납입확인서는 불가), 약국영수증(의사처방전 첨부)</li>
								<li>세부 항목에 대한 의료비 지원 여부는 우측상단의 <span class="colorOrg">'의료비 지원/제외 기준'</span>을  참조하세요. </li>
							</ul>
						</div>
					</div>
					<!--// list start -->
					<!--// list end -->
					
						<input type="hidden" name="COMP_sum"   id="COMP_sum"   value=""><!-- 신청구분별 회사지원 총액 -->
						<input type="hidden" name="AINF_SEQN"  id="AINF_SEQN"  value="">
						<input type="hidden" name="CTRL_NUMB"  id="CTRL_NUMB"  value=""><!-- 관리번호   -->
						<input type="hidden" name="SICK_DESC1" id="SICK_DESC1" value=""><!-- 구체적증상 -->
						<input type="hidden" name="SICK_DESC2" id="SICK_DESC2" value=""><!-- 구체적증상 -->
						<input type="hidden" name="SICK_DESC3" id="SICK_DESC3" value=""><!-- 구체적증상 -->
						<input type="hidden" name="SICK_DESC4" id="SICK_DESC4" value="">
						<input type="hidden" name="RCPT_NUMB"  id="RCPT_NUMB"  value="">
						<input type="hidden" name="RCPT_CODE_Check"  id="RCPT_CODE_Check"  value="">
						<input type="hidden" name="MAX_CHK"  id="MAX_CHK"  value="">
<!-- 						<input type="hidden" name="EMPL_WONX"  id="EMPL_WONX"  value="">-->
					</form>
					<form id="requestHiddenForm" name="requestHiddenForm" method="post">
						<input type="hidden" id="CTRL_YEAR"name="CTRL_YEAR" value="">
						<input type="hidden" id="GUEN_CODE"name="GUEN_CODE" value="">
						<input type="hidden" id="OBJPS_21" name="OBJPS_21"  value="">
						<input type="hidden" id="REGNO_21" name="REGNO_21"  value="">
						<input type="hidden" id="jobChk"   name="jobChk"	value="">
					</form>
					<div class="listArea" id="decisioner"></div>
					<div class="buttonArea">
						<ul class="btn_crud">
						<c:if test="${selfApprovalEnable == 'Y'}">
							<li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
						</c:if>
							<li><a class="darken" id="requestMedicalBtn" name="requestMedicalBtn" href="#"><span>신청</span></a></li>
						</ul>
					</div>
				</div>
				<!--// Tab1 end -->
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">
				<form id ="MedicalListForm" name="MedicalListForm">
					<!--// list start -->
					<div class="listArea">
						<h2 class="subtitle withButtons">의료비 지원내역</h2>
						<div class="clear"></div>
						<div id="medicalListGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
					</div>
					<!--// list end -->
					<!----------------------- 상세내역 start ----------------------->
					<!--// Table start -->
					<div class="tableArea">
						<h2 class="subtitle">의료비 지원 상세내역</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>의료비 지원 상세내역</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText03-1">관리번호</label></th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" name="CTRL_NUMB" value="" id="CTRL_NUMB" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-2">구분</label></th>
								<td colspan="3">
									<input class="readOnly w150" type="text" name="GUEN_NAME" value="" id="GUEN_NAME" readonly />
									<input type="checkbox" id="PROOF" name="PROOF" value="X" size="20" class="input03" disabled><span id="PROOFNAME">배우자 연말정산반영여부</span>
							</tr>
							<tr id="child">
							  <th><label for="inputText03-2">자녀이름</label></th>
							  <td class="td02" colspan="3">
								<input class="readOnly w150" type="text" name="ENAME" value="" id="ENAME" readonly />
								<input class="readOnly w150" type="text" name="REGNO_dis" value="" id="REGNO_dis" readonly />
							  </td>
							</tr>
							<tr>
								<th><label for="inputText03-3">상병명</label></th>
								<td colspan="3">
									<input class="readOnly w150" type="text" name="SICK_NAME" value="" id="SICK_NAME" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-4">구체적증상</label></th>
								<td colspan="3">
									<textarea class="readOnly wPer" name="SICK_DESC" id="SICK_DESC" rows="" readonly></textarea>
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-5">비고</label></th>
								<td colspan="3">
									<input class="readOnly wPer" type="text" name="BIGO_TEXT1" value="" id="BIGO_TEXT1" readonly />
								</td>
							</tr>
							<tr>
							  <th><label for="inputText03-5"></label></th>
								<td colspan="3">
								<input class="readOnly wPer" type="text" name="BIGO_TEXT2" value="" id="BIGO_TEXT2" readonly />
							  </td>
							</tr>
							<tr>
								<th><label for="inputText03-6">반납일자</label></th>
								<td>
									<input class="readOnly w100" type="text" name="RFUN_DATE" value="" id="RFUN_AMNT" readonly />
								</td>
								<th><label for="inputText03-7">반납액</label></th>
								<td>
									<input class="inputMoney readOnly w100" type="text" name="RFUN_AMNT" value="" id="RFUN_AMNT" readonly />
								</td>
							</tr>
							<tr>
								<th><label for="inputText03-8">반납사유</label></th>
								<td colspan="3">
									<input class="readOnly wPer" type="text" name="RFUN_RESN" value="" id="RFUN_RESN" readonly />		
								</td>
							</tr>
							</tbody>
							</table>
						</div>
					</div>
				</form>
					<!--// list start -->
					<!-- 진료비계산서 조회 클릭시 팝업레이어 popupLayer.html '진료비 계산서 조회' -->
					<div class="listArea">
						<h2 class="subtitle withButtons">진료비 계산서 조회</h2>
						<div class="buttonArea">
							<ul class="btn_mdl">
<!-- 								<li><a href="#" id="billDetailBtn"><span>조회</span></a></li> -->
							</ul>
						</div>
						<div class="clear"></div>
						<div id="medicalDetailGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
					</div>
					<!--// list end -->
					<div class="tableArea">
						<form id="totalWaers" name="totalWaers">
							<h2 class="subtitle">의료비 총액</h2>
							<div class="table">
								<table class="tableGeneral">
								<caption>의료비 총액</caption>
								<colgroup>
									<col class="col_15p"/>
									<col class="col_35p"/>
									<col class="col_15p"/>
									<col class="col_35p"/>
								</colgroup>
								<tbody>
								<tr>
									<th><label for="inputText03-1">회사지원총액</label></th>
									<td>
										<input class="inputMoney readOnly w100" type="text" name="COMP_sum" value="" id="COMP_sum" readonly />
									</td>
									<th><label for="inputText03-1">계</label></th>
									<td>
										<input class="inputMoney readOnly w100" type="text" name="EMPL_WONX" value="" id="EMPL_WONX" readonly />
									</td>
								</tr>
								<tr>
									<th><label for="inputText03-1">연말정산반영액</label></th>
									<td>
										<input class="inputMoney readOnly w100" type="text" name="YTAX_WONX" value="" id="YTAX_WONX" readonly />
									</td>
									<th><label for="inputText03-1">회사지원액</label></th>
									<td>
										<input class="inputMoney readOnly w100" type="text" name="COMP_WONX" value="" id="COMP_WONX" readonly />
									</td>
								</tr>
								</tbody>
								</table>
							</div>
						</form>
					</div>
					<!--// Table end -->
					<form id="MedicalDetailForm" name = "MedicalDetailForm">
							<input type="hidden" name="CTRL_NUMB"  id="CTRL_NUMB"  value="">
							<input type="hidden" name="GUEN_CODE"  id="GUEN_CODE"  value="">
							<input type="hidden" name="PROOF"	  id="PROOF"	  value="">
							<input type="hidden" name="SICK_NAME"  id="SICK_NAME"  value="">
							<input type="hidden" name="SICK_DESC1" id="SICK_DESC1" value="">
							<input type="hidden" name="SICK_DESC2" id="SICK_DESC2" value="">
							<input type="hidden" name="SICK_DESC3" id="SICK_DESC3" value="">
							<input type="hidden" name="EMPL_WONX"  id="EMPL_WONX"  value="">
							<input type="hidden" name="COMP_WONX"  id="COMP_WONX"  value="">
							<input type="hidden" name="YTAX_WONX"  id="YTAX_WONX"  value="">
							<input type="hidden" name="BIGO_TEXT1" id="BIGO_TEXT1" value="">
							<input type="hidden" name="BIGO_TEXT2" id="BIGO_TEXT2" value="">
							<input type="hidden" name="WAERS"	  id="WAERS"	  value="">
							<input type="hidden" name="RFUN_DATE"  id="RFUN_DATE"  value="">
							<input type="hidden" name="RFUN_RESN"  id="RFUN_RESN"  value="">
							<input type="hidden" name="RFUN_AMNT"  id="RFUN_AMNT"  value="">
							<input type="hidden" name="ENAME"	  id="ENAME"	  value="">
							<input type="hidden" name="OBJPS_21"   id="OBJPS_21"   value="">
							<input type="hidden" name="REGNO_21"   id="REGNO_21"   value="">
						</form>
						<form id="form2" name="form2">
						<!-----   hidden field ---------->
						  <input type="hidden" name="CTRL_NUMB" id="CTRL_NUMB" value="">
						  <input type="hidden" name="GUEN_CODE" id="GUEN_CODE" value="">
						  <input type="hidden" name="OBJPS_21"  id="OBJPS_21"  value="">
						  <input type="hidden" name="REGNO_21"  id="REGNO_21"  value="">
						  <input type="hidden" name="PROOF"	 id="PROOF"	 value="">
						  <input type="hidden" name="RCPT_NUMB" id="RCPT_NUMB" value="">
						  <input type="hidden" name="RCPT_CODE" id="RCPT_CODE" value="">
						<!--  HIDDEN  처리해야할 부분 끝-->
						</form>
						<form id="form3"name="form3" method="post">
							<input type="hidden" name="CTRL_YEAR" id="CTRL_YEAR" value="">
							<input type="hidden" name="GUEN_CODE" id="GUEN_CODE" value="">
							<input type="hidden" name="OBJPS_21"  id="OBJPS_21"  value="">
							<input type="hidden" name="REGNO_21"  id="REGNO_21"  value="">
							<input type="hidden" name="jobChk"	id="jobChk"	value="Detail">
						</form>
				</div>
				<!--// Tab2 end -->
				<!--------------- layout body end --------------->
			
			</div>
			<!-- innerContent end -->
		</div>
		<!--// contents end -->
	</div>
	<!--// container end -->
</div>
<!-- //wrapper end -->


<!-- popup : 의료비 목록 start -->
<div class="layerWrapper layerSizeM" id="popLayerMedical">
	<div class="layerHeader">
		<strong>의료비 상세</strong>
		<a href="#" class="btnClose popLayerMedical_close">창닫기</a>
	</div>
	<div class="layerContainer">
	<form id ="popLayerMedicalForm" name ="popLayerMedicalForm">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="tableArea tablePopup">
				<div class="table">
				
					<table class="tableGeneral">
					<caption>의료비 상세</caption>
					<colgroup>
						<col class="col_30p" />
						<col class="col_70p" />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-1">의료기관</label></th>
							<td>
								<input class="w200" type="text" name="MEDI_NAME" value="" id="MEDI_NAME" />
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-2">사업자등록번호</label></th>
							<td>
								<input class="w200" type="text" name="MEDI_NUMB" value="" id="MEDI_NUMB" onkeyup="businoFormat();"/>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-3">전화번호</label></th>
							<td>
								<input class="w200" type="number" name="TELX_NUMB" value="" id="TELX_NUMB" onBlur="phone_1(this);"/>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-4">진료일</label></th>
							<td class="tdDate">
							   <input class="datepicker" type="text" id="EXAM_DATE" name="EXAM_DATE" onBlur="dateFormat(this);"/>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-5">입원/외래</label></th>
							<td>
								<select id="MEDI_CODE" name="MEDI_CODE" required>
									<%= WebUtil.printOption(MediCode_vt)%>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-6">영수증 구분</label></th>
							<td>
								<select id="RCPT_CODE" name="RCPT_CODE" >
									<option value="0002" >진료비계산서</option>
						 			<option value="0003" >약국영수증</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-7">결재수단</label></th>
							<td>
								<select id="MEDI_MTHD" name="MEDI_MTHD">
									<option value="2"  >신용카드</option>
									<option value="3"  >현금영수증</option>
									<option value="1"  >현금</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="textPink">*</span><label for="inputText05-8">본인실납부액</label></th>
							<td>
								<input class="inputMoney w200" type="text" id="EMPL_WONX" name = "EMPL_WONX" value="" onkeyup="addComma(this)">원	
							</td>
						</tr>
					</tbody>
					</table>
				</div>
			</div>
			<div class="buttonArea buttonCenter">
				<ul class="btn_crud">
					<li><a class="darken" id="popLayerMedicalCreateBtn" href="#"><span>확인</span></a></li>
					<li><a href="#" id="popLayerMedicalCreatCansel" ><span>취소</span></a></li>
					<input type="hidden" id ="medicalMode" name ="medicalMode" vlaue="">
				</ul>
			</div>
			<!--// Content end  -->
			</form>
		</div>
	</div>
</div>
<!-- //popup: 의료비 목록 end -->

<!-- popup : 진료비 계산서 입력 start -->
<div class="layerWrapper layerSizeS" id="popLayerBillWrite" style="display:inherit !important">
	<div class="layerHeader">
		<strong>진료비 계산서 입력</strong>
		<a href="#" class="btnClose popLayerBillWrite_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
		<form id="BillWriteForm" name="BillWriteForm">
			<!--// Content start  -->
			<div class="layerScroll">
				<div class="tableArea tablePopup">
					<h2 class="subtitle">보험급여</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>보험급여</caption>
						<colgroup>
							<col class="col_34p" />
							<col class="col_66p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-1">총 진료비</label></th>
								<td><input class="inputMoney" type="text" id="TOTL_WONX" name="TOTL_WONX" onkeyup=" BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><label for="inputText01-2">조합부담금</label></th>
								<td><input class="inputMoney" type="text" id="ASSO_WONX" name="ASSO_WONX" onkeyup=" BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><label for="inputText01-3">본인부담금①</label></th>
								<td><input class="inputMoney readOnly" type="text" id="x_EMPL_WONX" name="x_EMPL_WONX" value="" readonly></td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div class="tableArea tablePopup">
					<h2 class="subtitle">보험 비급여</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>보험 비급여</caption>
						<colgroup>
							<col class="col_34p" />
							<col class="col_66p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-4">식대</label></th>
								<td><input class="inputMoney" type="text" id="MEAL_WONX" name="MEAL_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><label for="inputText01-5">지정진료비</label></th>
								<td><input class="inputMoney" type="text" id="APNT_WONX"  name="APNT_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><label for="inputText01-6">입원료</label></th>
								<td><input class="inputMoney" type="text" id="ROOM_WONX" name="ROOM_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><label for="inputText01-7">CT</label></th>
								<td><input class="inputMoney" type="text" id="CTXX_WONX" name="CTXX_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><label for="inputText01-8">MRI</label></th>
								<td><input class="inputMoney" type="text" id="MRIX_WONX" name="MRIX_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><label for="inputText01-9">초음파</label></th>
								<td><input class="inputMoney" type="text" id="SWAV_WONX" name="SWAV_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC1_TEXT" name="ETC1_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC1_WONX" name="ETC1_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC2_TEXT" name="ETC2_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC2_WONX" name="ETC2_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC3_TEXT" name="ETC3_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC3_WONX" name="ETC3_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC4_TEXT" name="ETC4_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC4_WONX" name="ETC4_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><input class="w80 alignCenter" type="text" id="ETC5_TEXT"  name="ETC5_TEXT" value=""></th>
								<td><input class="inputMoney" type="text" id="ETC5_WONX" name="ETC5_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
							<tr>
								<th><label for="inputText01-15">소 계②</label></th>
								<td><input class="inputMoney readOnly" type="text" id="EMPL_WONX_sub" name="EMPL_WONX_sub" value="" readonly></td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div class="tableArea tablePopup">
					<h2 class="subtitle">할인금액</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>할인금액</caption>
						<colgroup>
							<col class="col_34p" />
							<col class="col_66p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-16">할인금액③</label></th>
								<td><input class="inputMoney" type="text" name="DISC_WONX" id="DISC_WONX" onkeyup="BillWritemultiple_won();"  value=""></td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div class="tableArea tablePopup">
					<h2 class="subtitle">본인부담금 총액</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>본인부담금 총액</caption>
						<colgroup>
							<col class="col_34p" />
							<col class="col_66p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-17">① + ② - ③</label></th>
								<td>
									<input class="inputMoney readOnly" type="text" name="bill_EMPL_WONX_tot" id="bill_EMPL_WONX_tot"  value="" readonly>
									<select>
										<option value="KRW" selected="">KRW</option>
									</select>
								</td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="buttonArea buttonCenter mt10">
				<ul class="btn_crud">
					<li><a class="darken" id="BillWrite" href="#"><span>확인</span></a></li>
					<li><a href="#" id="popLayerBillWriteCansel"><span>취소</span></a></li>
				</ul>
			</div>
			<!--// Content end  -->
			</form>
		</div>
	</div>
</div>
<!-- //popup : 진료비 계산서 입력 end -->

<!-- popup : 진료비 계산서 조회 start -->
<div class="layerWrapper layerSizeS" id="popLayerBillDetail">
	<div class="layerHeader">
		<strong>진료비 계산서 조회</strong>
		<a href="#" class="btnClose popLayerBillDetail_close">창닫기</a>
	</div>
	<div class="layerContainer">
	<form id="billDetail" name="billDetail">
			<div class="layerContent">
				<!--// Content start  -->
				<div class="layerScroll">
					<div class="tableArea tablePopup">
						<h2 class="subtitle">보험급여</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>보험급여</caption>
							<colgroup>
								<col class="col_40p" />
								<col class="col_60p" />
							</colgroup>
							<tbody>
								<tr>
									<th>총 진료비</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="TOTL_WONX" id="TOTL_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>조합부담금</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ASSO_WONX" id="ASSO_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>본인부담금①</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="EMPL_WONX" id="EMPL_WONX" value="" readonly>
									</td>
								</tr>
							</tbody>
							</table>
						</div>
					</div>
					<div class="tableArea tablePopup">
						<h2 class="subtitle">보험 비급여</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>보험 비급여</caption>
							<colgroup>
								<col class="col_40p" />
								<col class="col_60p" />
							</colgroup>
							<tbody>
								<tr>
									<th>식대</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="MEAL_WONX" id="MEAL_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>지정진료비</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="APNT_WONX" id="APNT_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>입원료</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ROOM_WONX" id="ROOM_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>CT</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="CTXX_WONX" id="CTXX_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>MRI</th>
									<<td>
										<input class="inputMoney w120 readOnly" type="text" name="MRIX_WONX" id="MRIX_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>초음파</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="SWAV_WONX" id="SWAV_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC1_TEXT_th" id="ETC1_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC1_WONX" id="ETC1_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC2_TEXT_th" id="ETC2_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC2_WONX" id="ETC2_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC3_TEXT_th" id="ETC3_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC3_WONX" id="ETC3_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC4_TEXT_th" id="ETC4_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC4_WONX" id="ETC4_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th><input class="w80 alignCenter readOnly" type="text" name="ETC5_TEXT_th" id="ETC5_TEXT_th" value="" readOnly></th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="ETC5_WONX" id="ETC5_WONX" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>소 계②</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="CNT1_WONX" id="CNT1_WONX" value="" readonly>
									</td>
								</tr>
							</tbody>
							</table>
						</div>
					</div>
					<div class="tableArea tablePopup">
						<h2 class="subtitle">할인금액</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>할인금액</caption>
							<colgroup>
								<col class="col_40p" />
								<col class="col_60p" />
							</colgroup>
							<tbody>
								<tr>
									<th>할인금액③</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="DISC_WONX" id="DISC_WONX" value="" readonly>
									</td>
								</tr>
							</tbody>
							</table>
						</div>
					</div>
					<div class="tableArea tablePopup">
						<h2 class="subtitle">본인부담금 총액</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>본인부담금 총액</caption>
							<colgroup>
								<col class="col_40p" />
								<col class="col_60p" />
							</colgroup>
							<tbody>
								<tr>
									<th>① + ② - ③</th>
									<td>
										<input class="inputMoney w120 readOnly" type="text" name="CNT2_WONX" id="CNT2_WONX" value="" readonly>
									</td>
								</tr>
							</tbody>
							</table>
						</div>
					</div>
				</div>
				<!--// Content end  -->
			</div>
		</form>
	</div>
</div>
<!-- //popup : 진료비 계산서 조회 end -->

<!-- popup : 동일진료 start -->
<div class="layerWrapper layerSizeM" id="popLayerLastSick" style="display:inherit !important">
	<div class="layerHeader">
		<strong>동일진료</strong>
		<a href="#" class="btnClose popLayerLastSick_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="listArea">
				<div id="lastSickPopupGrid"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
			</div>
			<!--// Content end  -->
		</div>
	</div>
</div>

<!-- 프린트 영역 팝업-->
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>진료비게산서</strong>
		<a href="#" class="btnClose popLayerPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer">
			<div id="printBody">
				<iframe name="billWritePopup" id="billWritePopup" src="" frameborder="0" scrolling="no" style="float:left; height:1100px; width:700px;"></iframe>
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
<!-- //popup : 의료비 지원/제외 기준 start -->
<div class="layerWrapper layerSizeL" id="popLayerMedicalInfo">
	<div class="layerHeader">
		<strong>의료비 지원/제외 기준</strong>
		<a href="#" class="btnClose popLayerMedicalInfo_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="layerScroll">
				<div class="txtInfo">				
	           		<ul>
		           		<li><h2>1. 적용대상 의료비: 치료 목적으로 지출된 비용 중 건강보험 급여대상 의료비의 본인부담금에 대해서 지원함</h2>
		           			<ul>
		           				<li>① 식대, 지정진료비</li>
		           				<li>② 입원 시 상급 병실료는 차액의 50% 지원</li>
		           				<li>③ CT, MRI, 초음파 검사료 (단. 검사후 치료가 병행된 경우에 한하며, MRI는 진단서에 함께 제출)</li>
		           			</ul>
		           		</li>
		           		<li>
		           			<h2>2. 의료비 지원적용 제외 항목</h2>
		           			<ul>
								<li>① 전액 비급여로 분류되는 의료비</li>
								<li>② 치과, 한의원, 한방병원의 경우 건강보험 비급여 대상의 본인부담금액</li>
								<li>③ 업무나 일상생활에 지장이 없는 치료 및 수술 (성형, 예방접종, 영양제, 건강진단, 검사 등)</li>
								<li>④ 약국의 경우 의사처방전에 근거하지 않은 단순투약, 영양제 복용 등</li>
								<li>⑤ 단순 피로 및 권태</li>
								<li>⑥ 불임치료, 인공수정, 인공유산, 친자확인을 위한 진단</li>
								<li>⑦ 보조기, 보청기, 의수/족, 의안, 콘택트렌즈 등의 재료비</li>
								<li>⑧ 마약중독 등 향정신성 의약품 중독증</li>
								<li>⑨ 산재, 자동차사고, 제3자의 가해행위 등</li>
								<li>※ 기타 급여 치료내역 병행 시 질병, 부상 치료를 직접 목적으로 하지 않는 것으로 판단되는 항목 예시
									<!--// table start -->
									<div class="tableArea tablePopup tdLine mt10 pb0">
										<div class="table">
											<table class="tableGeneral">
											<caption>사업장별 주관부서 담당자 현황</caption>
											<colgroup>
												<col class="col_15p" />
												<col class="col_55p" />
												<col class="col_30p" />
											</colgroup>
											<thead>
												<tr>
													<th class="alignCenter">구분</th>
													<th class="alignCenter">항목</th>
													<th class="alignCenter">비고</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th class="alignCenter">투약/조제료</th>
													<td>비타민제, 비만치료제, 비아그라</td>
													<td></td>
												</tr>
												<tr>
													<th rowspan="2" class="alignCenter">주사료</th>
													<td>영양제, 예방접종, 면역주사제, 유착방지제, 호르몬제, <br>프롤로 주사제, 피부재생주사, 히알루로니나제(=하이렉스 주)</td>
													<td></td>
												</tr>
												<tr>
													<td>철분주사제</td>
													<td>*임신으로 인한 빈혈수치 저하 <br>(성상치/측정치 기재)로<br> 의사소견서 첨부時 지원</td>
												</tr>
												<tr>
													<th class="alignCenter">마취료</th>
													<td>무통주사(PCA)</td>
													<td></td>
												</tr>
												<tr>
													<th rowspan="7" class="alignCenter">처치/수술료</th>
													<td>로봇수술</td>
													<td rowspan="7" >*치료 세부 내역에 처치/수술료와<br> 치료재료대가 합산되어 있는 경우<br> 치료재료대 항목 확인 후 제외</td>
												</tr>
												<tr>
													<td class="bdRight">디스크수술 (경막 외 신경성형술, 수핵 감압술 등)</td>
												</tr>
												<tr>
													<td class="bdRight">고주파수술 (고주파 설근부 축소술/내시경 술 등)</td>
												</tr>
												<tr>
													<td class="bdRight">맘모톰</td>
												</tr>
												<tr>
													<td class="bdRight">레이저, 체외충격파 시술, 근육내자극술 등</td>
												</tr>
												<tr>
													<td class="bdRight">라식 수술</td>
												</tr>
												<tr>
													<td class="bdRight">교육P/G, 상담비용, 장치기구</td>
												</tr>
												<tr>
													<td class="alignCenter" colspan="2">재활 및 물리치료 중 비급여 항목</td>
													<td></td>
												</tr>
											</tbody>
											</table>
										</div>
									</div>	
									<!--// table end -->
								</li>
							</ul>
						</li>
						<li>
							<h2>※ 기타사항</h2>
							<ul>
								<li>① 의료비 청구는 의료비를 지급한 날로부터 1년 이내에 신청하여야 함.</li>
								<li>② 입원 시 진료비 청구는 퇴원할 때까지의 본인부담 총 진료비를 기준으로 함.<br>&nbsp;&nbsp;&nbsp;&nbsp;(단, 장기입원시의 분할 신청 가능)</li>
								<li>③ 휴직 중에 발생한 의료비도 지원함.</li>
								<li>④ 본인부담액 상환제 사후환급금<br>&nbsp;&nbsp;&nbsp;&nbsp;(6개월간 보험적용 본인부담금이 200만원을 초과한 경우 초과한 금액을 공단이 부담) 과의 이중수혜 불가</li>
							</ul>
						</li>
					</ul>
				 </div>
			 </div>
			<!--// Content end  -->
		</div>
	</div>
</div>
<!-- popup : 의료비신청 주의사항 start -->
<div class="layerWrapper layerSizeML" id="popLayerMedicalAlert" style="display:none;">
	<div class="layerHeader">
		<strong><span class="colorRed">의료비 신청 시 <span class="colorRed">주의사항</span></strong>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="hometaxInfo pd0">
           		<ul>
					<li>
						<ul>
							<li>
								1. 병원영수증은 진료일자 및 수납금액만 기재된 진료비납입확인서로는 의료비 승인이 되지않습니다.
								<br>&nbsp;&nbsp;&nbsp;&nbsp;진찰료, 검사료, 주사료 등 세부내역이 기재된 정식영수증을 첨부하여 주십시오.
								
							</li>
							<li>
								2. 약국영수증은 의사처방전을 필수 첨부하셔야만 승인이 가능합니다.
						    </li>
						    <li>
						    	3. 최초 진료시, 본인 부담금 10만원 초과금액이 지원 가능합니다.
						    </li>
						    <li>
						    	4. 치료가 병행되지 않은 검사료는 의료비 지원대상이 아닙니다.
						    </li>
						</ul>
					</li>
				</ul>
			 </div>
			<!--// Content end  -->
		</div>	
		<div class="buttonArea buttonCenter mt10">
			<ul class="btn_crud">
				<li><a class="darken" id="MedicalAlertConfirmBtn" href="#"><span>확인</span></a></li>
			</ul>
		</div>		
	</div>		
</div>
<!-- //popup: 의료비신청 주의사항  end -->



<!-- // script -->
<script type="text/javascript">
var self = false;
var orgItem;
	$(function(){
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=03&gridDivId=decisionerGrid');
		$("#printPopBillWriteBtn").click(function() {
			$("#printContentsArea").print();
		});
		
		$("#BillPrintBtn").click(function(){
			$("#billWritePopup").attr("src","/supp/medicalPrint/before/");// + year + "?BEGDA=" + begda
			$("#billWritePopup").load(function(){
				$('#popLayerPrint').popup("show");
			});
		});
	});
	
	var requestPrint = function(){
		var AINF_SEQN = $("#requestForm #AINF_SEQN").val();
		$("#billWritePopup").attr("src","/supp/medicalPrint/requestPrint/?AINF_SEQN="+AINF_SEQN);
		$("#billWritePopup").load(function(){
			$('#popLayerPrint').popup("show");
		});
	};
	
	var businoFormat = function(){
		var tempStr= $("#MEDI_NUMB").val();
		
		if( tempStr.length == 10 ) {
			tempStr = tempStr.substring(0,3) + "-" + tempStr.substring(3,5) + "-" + tempStr.substring(5,10);
		}
		$("#MEDI_NUMB").val(tempStr);
		return true;
	}
	
	function addComma(x){
		x = insertComma(x.value);
		return $("#popLayerMedicalForm #EMPL_WONX").val(x);
	};
	
	$(document).ready(function(){
		$('#decisioner').load('/common/getDecisionerGrid?upmuType=03&gridDivId=decisionerGrid');
		if($(".layerWrapper").length){
			$('#popLayerLastSick').popup();
			change_guen();
			$('#popLayerMedical').popup();
			$("#MedicalListForm #PROOF").hide();
			$("#child").hide();
			$("#requestForm #Message").hide();
			
		};
		
		$("#tab2").click(function(){
			$("#MedicalListForm #PROOF").hide();
			$("#MedicalListForm #PROOFNAME").hide();
			$("#medicalListGrid").jsGrid("search");
			medicalDetailGrid();
		});
		
		$("#tab1").click(function(){
			$("#requestForm #GUEN_CODE").val("").prop("disabled", false);
			$("#requestForm #Message").hide();
			change_guen();
		});
	
		$("#requestForm #GUEN_CODE").change(function(){
			change_guen();
			changeChild();
		});
		
		// 의료비목록 등록/수정 버튼
		$("#popLayerMedicalCreateBtn").click(function(){
			if($("#medicalMode").val() == "Create"){
				MedicalCreateClient();
			}else if($("#medicalMode").val() == "Update"){
				MedicalUpdateClient();
			}
		});
		
		$("#popLayerMedicalCreatCansel").click(function(){
			$("#popLayerMedical").popup('hide');
		});
		
		// 의료비목록 등록
		$("#popLayerMedicalCreate").click(function(){
			$("#popLayerMedicalForm").each(function() {
				this.reset();
			});
			$("#medicalMode").val("Create");
		});
		
		// 의료비목록 수정
		$("#popLayerMedicalUpdate").click(function(){
			if( !$("input:radio[name='chk']").is(":checked")) {
				alert("수정 대상을 선택하세요.");
				return false;
			}
			
		$("#medicalMode").val("Update");
		$("#popLayerMedical").popup('show');
		});
		
		// 의료비목록 삭제
		
		$("#popLayerMedicalDelete").click(function(){
			if( !$("input:radio[name='chk']").is(":checked")) {
				alert("삭제 대상을 선택하세요.");
				return false;
			}
			MedicalDeleteClient();
		});
		
		$("#popLayerWriteBill").click(function(){
			if( !$("input:radio[name='chk']").is(":checked")) {
				alert("진료비입력 대상을 선택하세요.");
				return false;
			}
			if( $("#requestForm #RCPT_CODE_Check").val() != "0002" ){ /* 영수증 구분이 진료비계산서(0002) 가 아니면 에러 */
				alert("선택한 항목의 영수증은 진료비계산서가 아닙니다. \n\n  '영수증 구분'을 확인해 주세요");
				return false;
			}
			$("#popLayerBillWrite").popup("show");
		});
		
		//진료비 계산서 입력
		$("#BillWrite").click(function(){
			BillWriteCreate();
		});
		
		$("#popLayerBillWriteCansel").click(function(){
			$("#popLayerBillWrite").popup('hide');
		});
		
		$("#billDetailBtn").click(function(){
			if( !$("input:radio[name='chkBill']").is(":checked")) {
				alert("진료비 계산서 조회 대상을 선택하세요.");
				return false;
			}
			if( $("#form2 #RCPT_CODE").val() != "0002" ){ /* 영수증 구분이 진료비계산서(0002) 가 아니면 에러 */
				alert("선택한 항목의 영수증은 진료비계산서가 아닙니다. \n\n  '영수증 구분'을 확인해 주세요");
				return false;
			}
			billDetail();
			$("#popLayerBillDetail").popup('show');
		});
		$("#requestMedicalBtn").click(function(){
			self = false;
			chkrequestMedical();
		});
		$("#requestNapprovalBtn").click(function(){
			self = true;
			chkrequestMedical();
		});
		
		$("#MedicalAlertConfirmBtn").click(function(){
			$("#popLayerMedicalAlert").popup('hide');
			requestMedical();
		});
		
		
	});
	var chkrequestMedical = function(){
		if(!check_data()) return;
		$("#popLayerMedicalAlert").popup('show');
	}
	var requestMedical = function(){
		//자가승인이면 1차 신청부서 결재자를 본인으로 changeAppLine 메소드는 decisionerGrid.jsp 에 구현
		var msg = self ? "자가승인의 경우 신청과 동시에 승인이 완료됩니다.\n" : "";
		decisionerGridChangeAppLine(self);
		if(confirm(msg + "신청 하시겠습니까?")){
			$("#requestForm #PROOF").prop("disabled", false); 
			if ($("#requestForm #PROOF").is(':checked')) {
				$("#requestForm #PROOF").val("X");
			} else {
				 $("#requestForm #PROOF").val("");
			}
			$("#requestForm #medi_count").val($("#MedicalCreateListGrid").jsGrid("dataCount"));
			var param = $("#requestForm").serializeArray();
			$("#decisionerGrid").jsGrid("serialize", param);
			$("#MedicalCreateListGrid").jsGrid("serialize", param);
			param.push({"name":"selfAppr", "value" : self});
			
			jQuery.ajax({
				type : 'POST',
				url : '/supp/requestMedical.json',
				cache : false,
				dataType : 'json',
				data : param,
				async :false,
				success : function(response) {
		  			if(response.success){
		  				$("#requestForm #AINF_SEQN").val(response.AINF_SEQN);
		  				requestPrint();
		  				alert("신청 되었습니다.");
		  				$("#requestForm").each(function() {
							this.reset();
							$("#MedicalCreateListGrid").jsGrid({data: []});
						});
		  			}else{
		  				alert("신청시 오류가 발생하였습니다. " + response.message);
		  			}
		  		}
			});
		} else {
			decisionerGridChangeAppLine(false);
		}

		$("#requestForm #PROOF").prop("disabled", true);
		$("#requestForm #EMPL_WONX_tot").val(insertComma($("#requestForm #EMPL_WONX_tot").val()));
	};
	
	function click_radio(obj) {
		if($("#requestForm #is_new_num")[0].checked == true){		/* 최초진료 */
			$("#SICK_NAME").removeClass("readOnly");
			if( $("#requestForm #CTRL_NUMB").val() != "" ) {			//동일진료가 선택된 경우에만 Clear한다.
				$("#requestForm #CTRL_NUMB").val("");
				$("#requestForm #SICK_NAME").val("");
				$("#requestForm #SICK_DESC").val("");
			}
		} else if($("#requestForm #is_new_num")[1].checked == true){ /* 동일진료 */
			if($("#requestForm #GUEN_CODE").val() == "0003" && ($("#requestForm #OBJPS_21").val() == "" || $("#requestForm #REGNO_21").val() == "") ) {			//자녀의 동일진료 조회시 자녀이름 입력 여부 check
				alert("구분이 \"자녀\"일 경우 \"자녀이름\"을 선택하세요.");
				$("#requestForm #is_new_num")[0].checked = true;
				return;
			}
			$("#popLayerLastSick").popup('show');
			popLastSick();
			
			//$("#SICK_NAME")
			//		$("#detailPromise").addClass("readOnly").prop("disabled",true);
			$("#SICK_NAME").addClass("readOnly");
			
		}
	}
	
	var popLastSick =function(){
		$("#lastSickPopupGrid").jsGrid({
		 	height: "auto",
			width: "100%",
			autoload : true,
			sorting: true,
			paging: true,
			pageSize: 10,
			pageButtonCount: 10,
			controller : {
			loadData : function() {
  					var d = $.Deferred();
  					$.ajax({
  						type : "POST",
  						url : "/supp/getLastSickList.json",
  						dataType : "json",
						data : {
							"GUEN_CODE" : $("#requestForm #GUEN_CODE").val(),
							"OBJPS_21"  : $("#requestForm #OBJPS_21").val(),
							"REGNO_21"  : $("#requestForm #REGNO_21").val()
						}
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
					itemTemplate: function(value, storeData) {
							 return $("<input name='lastchk' id='lastchk'>")
							   .attr("type", "radio")
		 					  .on("click", function(e) {
									   $("#requestForm #CTRL_NUMB").val(storeData.CTRL_NUMB);
									   $("#requestForm #SICK_NAME").val(storeData.SICK_NAME);
									   $("#requestForm #SICK_DESC").val(storeData.SICK_DESC1+storeData.SICK_DESC2+storeData.SICK_DESC3+storeData.SICK_DESC4);
									   $("#requestForm #GUEN_CODE").val(storeData.GUEN_CODE);
									   $("#requestForm #SICK_DESC1").val(storeData.SICK_DESC1);
									   $("#requestForm #SICK_DESC2").val(storeData.SICK_DESC2);
									   $("#requestForm #SICK_DESC3").val(storeData.SICK_DESC3);
									   $("#requestForm #SICK_DESC4").val(storeData.SICK_DESC4);
									   $("#requestForm #RCPT_NUMB").val(storeData.RCPT_NUMB);
									   $("#requestForm #OBJPS_21").val(storeData.OBJPS_21);
									   $("#requestForm #REGNO_21").val(storeData.REGNO_21);
									   $("#requestForm #DATUM_21").val(storeData.DATUM_21);
									   $("#requestForm #MAX_CHK").val(storeData.MAX_CHK);
									   $("#popLayerLastSick").popup('hide');
						  });
					},
					align: "center",
					width: "8%"
				},
				{ title: "구분", name: "GUEN_CODE", type: "text", align: "center", width: "10%", 
					itemTemplate: function(value, storeData) {
						if(value == "0001"){
							return "본인";
						}else if(value == "0002"){
							return "배우자";
						}else{
							return "자녀";
						}
					}
				},
				{ title: "관리번호", name: "CTRL_NUMB", type: "text", align: "center", width: "10%" },
				{ title: "상병명", name: "SICK_NAME", type: "text", align: "center", width: "20%"}
			]
		});					
	};

	/*=====중복신청 방지 20160801 이동엽D ===*/
	
	function do_build(){
		var sendFlag = true;

		if(sendFlag==true){
			do_build_ok();
			sendFlag = false;
		}else{
			alert("저장 중입니다. 기다려주십시요.");
			sendFlag = false;
		}
	}
	

	var check_data = function () {
	//  최초진료 신청시 관리번호가 CTRL_NUMB.substring(5,6) == "Z"일때 더이상 new는 발생시킬수가 없다.
		
		if($("#requestForm #is_new_num")[0].checked == true) {
			CTRL_NUMB = $("#requestForm #CTRL_NUMB").val();

			if( CTRL_NUMB.substring(5,6) == "Z" ) {
				alert("최초진료 신청시 더이상 생성 가능한 관리번호가 없습니다.\n\n관리자에게 문의하세요.");
				return false;
			}
	//  동일진료일경우 선택된 관리번호가 있는지 check한다.
		} else {
			CTRL_NUMB = $("#requestForm #CTRL_NUMB").val();

			if( CTRL_NUMB == "" ) {
				alert("동일진료 관리번호를 선택하세요.");
				return false;
			}
		}
	//  자녀 의료비 신청시 자녀이름 필수입력.
		if( $("#requestForm #GUEN_CODE").val() == "0003" && $("#requestForm #ENAME").selectedIndex == 0 ){
			alert("자녀이름을 선택하세요");
			$("#requestForm #ENAME").focus();
			return false;
		}
	//  배우자, 자녀일 경우 해당년도 회사지원총액이 300만원을 넘으면 에러처리함.(본인은 2000만원을 넘으면 에러처리함)
	//@V1.0 한도 500으로수정
		if( ($("#requestForm #GUEN_CODE").val() == "0002" && <%= !E_FLAG.equals("Y") %>) || $("#requestForm #GUEN_CODE").val() == "0003" ) {
			if( $("#requestHiddenForm #COMP_sum").val() >= 5000000 ) {
				alert("해당년도 의료비 지원총액은 500만원입니다.");
				return false;
			}
		 } else if($("#requestForm #GUEN_CODE").val() == "0001" ) {
			if( $("#requestHiddenForm #COMP_sum").val() >= 20000000 ) {
				alert("해당년도 의료비 지원총액은 2,000만원입니다.");
				return false;
			}
		 }
	//  상병명-30 입력시 길이 제한 
		if($("#requestForm #SICK_NAME").val() == "") {
			alert("상병명을 입력하세요.");
			 $("#requestForm #SICK_NAME").focus();
			return false;
		} else {
			if( $("#requestForm #SICK_NAME").val() != "" && checkLength($("#requestForm #SICK_NAME").val()) >30 ){
				alert("상병명은 한글 15자, 영문 30자 이내여야 합니다.");
				$("#requestForm #SICK_NAME").focus();
				$("#requestForm #SICK_NAME").select();
				return false;
			}
		}
	//[CSR ID:2589455] *(42) 제거 로직 추가----------------------------
		var tmpText="";
		for ( var i = 0; i < $("#requestForm #SICK_NAME").val().length; i++ ){
			if($("#requestForm #SICK_NAME").val().charCodeAt(i) != 42){
			  tmpText = tmpText+$("#requestForm #SICK_NAME").val().charAt(i);
		  }
		}
		$("#requestForm #SICK_NAME").val(tmpText);
	//-----------------------------------------------------------------

	//  구제적증상 필수입력
		textArea_to_TextFild($("#requestForm #SICK_DESC").val());
		if( $("#requestForm #SICK_DESC1").val() == "" && $("#requestForm #SICK_DESC2").val() == "" &&
			$("#requestForm #SICK_DESC3").val() == "" && $("#requestForm #SICK_DESC4").val() == "" ) {
			alert("구체적증상을 입력하세요.");
			$("#requestForm #SICK_DESC1").focus();
			return false;
		}
		/* 최초 진료시 본인부담액이 10만원 이하인 경우 Error처리함 */
		int_tt_wonx = Number(removeComma($("#requestForm #EMPL_WONX_tot").val()));
	
		if($("#requestForm #WAERS").val() == "KRW" ) {		 // 원화일경우만..
			
			//alert("금액 : " + int_tt_wonx);
			
			if(($("#requestForm #is_new_num")[0].checked == true) && (int_tt_wonx <= 100000) ){
				alert(" 최초 진료시 본인부담액이 10만원초과일 경우에 의료비 신청이 가능합니다. ");
				return false;
			}
		}
		
		var valid = true;
// 		var data = $("#MedicalCreateListGrid").jsGrid("option", "data");
// 		$.each(data, function(i, $item) {
// 			if($item.RCPT_CODE =="0002"){
// 				if(removeComma($item.EMPL_WONX) != $item.bill_EMPL_WONX_tot) {
// 					alert("진료계산서의 본인부담금액과 입력한 본인실납부액이 다릅니다. \n\n \"진료비계산서 입력\" 버튼을 눌러 다시한번 확인해 주세요");
// 					valid = false;
// 				}else if($item.bill_EMPL_WONX_tot == 0 ||$item.bill_EMPL_WONX_tot == null) {
// 					alert(" \"진료비계산서\"가 입력되지 않았습니다.\n\n \"진료비계산서 입력\" 버튼을 눌러 \"진료비계산서\"를 입력해주세요");
// 					valid = false;
// 				}
// 			}
// 		});
		return valid;
		setting_bill_data();
		$("#requestForm #EMPL_WONX_tot").val(removeComma($("#requestForm #EMPL_WONX_tot").val()));
		$("#popLayerMedicalForm #EMPL_WONX").val(removeComma($("#popLayerMedicalForm #EMPL_WONX").val()));
	};
	   
//팝업 등록/수정 필수값 체크 ==============================================================================================================
	   
	var medicalPopCheck_data = function () {
	/* 필수 입력값 .. 의료기관, 사업자등록번호, 진료일, 영수증 구분, 본인 실납부액 */
		   medi_name = $("#popLayerMedicalForm #MEDI_NAME").val();
		   medi_numb = removeResBar2($("#popLayerMedicalForm #MEDI_NUMB").val());
		   exam_date = removePoint($("#popLayerMedicalForm #EXAM_DATE").val());
		   empl_wonx = removeComma($("#popLayerMedicalForm #EMPL_WONX").val());
		if(medi_name != "" && medi_numb != "" && exam_date != "" && empl_wonx != ""){

//			  2002.05.10. 의료기관 길이 제한 - 20자
			   if( checkLength(medi_name) >20 ){
				   alert("의료기관명은 한글 10자, 영문 20자 이내여야 합니다.");
//					 eval("document.requestForm.radiobutton["+inx+"].checked = true;");
				   return false;
			   }
		   }else{
			   alert("\"의료기관\", \"사업자등록번호\", \"진료일\", \"본인 실납부액\"은 필수 항목입니다.\n\n 누락된 값을 입력해주세요");
//				 eval("document.requestForm.radiobutton["+inx+"].checked = true;");
			   if(medi_name == ""){
				$("#popLayerMedicalForm #MEDI_NAME").focus();
			   }else if(medi_numb == ""){
				$("#popLayerMedicalForm #MEDI_NUMB").focus();
			   }else if(exam_date == ""){
				$("#popLayerMedicalForm #EXAM_DATE").focus();
			   }else if(empl_wonx == ""){
				$("#popLayerMedicalForm #EMPL_WONX").focus();
			   }
			   return false;
		   }
   //  진료일을 기준으로 3개월까지만 신청이 가능하도록 한다. 2002.05.02. 확인자:성경호, 수정자:김도신 -> 12개월(1년)까지로 수정 이동엽
   //  마지막에 입력한 진료일에 대해서만 체크한다. 
		begin_date = removePoint($("#requestForm #BEGDA").val());		// 신청일..
		betw = getAfterMonth(addSlash(exam_date), 12);
		diff = dayDiff(addSlash(begin_date), addSlash(betw));
		if(diff < 0) {
				alert('진료일을 기준으로 1년까지만 신청이 가능합니다.');
				return false; 
		}
		if(!check_busino()){
			return false;
		}
   //  진료일을 기준으로 3개월까지만 신청이 가능하도록 한다. 2002.05.02. 확인자:성경호, 수정자:김도신
   //  마지막에 입력한 진료일에 대해서만 체크한다. 
	$("#popLayerMedicalForm #EMPL_WONX").val(removeComma($("#popLayerMedicalForm #EMPL_WONX").val()));
		return true;
	};
	
	//사업자등록번호 체크 로직 추가 (2005.03.07)
	var checkDetail_busino= function(businoStr) {
		var sum = 0;
		var getlist =new Array(10);
		var chkvalue =new Array("1","3","7","1","3","7","1","3","5");
		
		for(var i=0; i<10; i++) { getlist[i] = businoStr.substring(i, i+1); }
		for(var i=0; i<9; i++) { sum += getlist[i]*chkvalue[i]; }
		sum = sum + parseInt((getlist[8]*5)/10);
		sidliy = sum % 10;
		sidchk = 0;
		if(sidliy != 0) { sidchk = 10 - sidliy; }
		else { sidchk = 0; }
		if(sidchk != getlist[9]) { 
//	alert("사업자등록번호가 유효하지 않습니다.");
		return false; 
		}
	return true;
	}
	
	//사업자등록번호 포맷 (2005.03.07)
	var check_busino = function(){
		var tempStr="";
		valid_chk = true;
		
		t = $("#MEDI_NUMB").val();
		if(t.length == 10) {
			tempStr = t.substring(0,3) + t.substring(3,5) + t.substring(5,10);
		}else if(t.length == 12) {
			if( t.substring(3,4) != "-" || t.substring(6,7) != "-" ) {
			valid_chk = false;
			}
			tempStr = t.substring(0,3) + t.substring(4,6) + t.substring(7,12);
		} else {
		  tempStr = t;
		}

		if( (!checkDetail_busino(tempStr) && tempStr.length != 0) || (valid_chk == false) ) {
			alert("사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요.");
			$("#MEDI_NUMB").focus();
			$("#MEDI_NUMB").select();
			return false;
		// 사업자등록번호 "-"으로 구분 3자리-2자리-5자리
		}else{
			if( tempStr.length != 0 ) {
			tempStr = tempStr.substring(0,3) + "-" + tempStr.substring(3,5) + "-" + tempStr.substring(5,10);
			}
	}
	$("#MEDI_NUMB").val(tempStr);
		return true;
	}
	
	var textArea_to_TextFild = function (text) {
		for(var i = 1 ; i < 5 ; i++) {
			$("#requestForm #SICK_DESC"+i).val(""); 
		}
		var tmpText="";
		var tmplength = 0;
		var count = 1;
		var flag = true;
	    for ( var i = 0; i < text.length; i++ ){
			tmplength = checkLength(tmpText);
			if( (text.charCodeAt(i) != 13 && text.charCodeAt(i) != 10) && Number( tmplength ) < 60 ){
				tmpText = tmpText+text.charAt(i);
				flag = true
			} else {
				flag = false;
				tmpText.trim;
				$("#requestForm #SICK_DESC"+count).val(tmpText); 
				tmpText=text.charAt(i);
				count++;
				if( count > 4 ){
					break;
				}
			}
		}
		if( flag ) {
			$("#requestForm #SICK_DESC"+count).val(tmpText);
		}
	}
	
	var change_guen = function() {
		$("#requestForm #CTRL_NUMB").val("");
		$("#requestForm #SICK_NAME").val("");
		$("#requestForm #SICK_DESC").val("");
		
		set_default();
	};
	
	var changeChild = function() {
		jQuery.ajax({
			type : "POST",
			url : "/supp/getChangeChildList.json",
			cache : false,
			dataType : "json",
			async :false,
			success : function(response) {
				if(response.success){
					setChildOption(response.storeData)
				}
				else{
					alert("급여사유 조회시 오류가 발생하였습니다. " + response.message);
				}
			}
		});
	};
	
	var setChildOption = function(jsonData) {
		$("#requestForm #ENAME").empty();
		$.each(jsonData, function (key, value) {
			if(value.GUEN_CODE != "0003"){
		 		$("#requestForm #ENAME").find("option").remove().end().append("<option value='' >-----</option>");
			}
			if(value.GUEN_CODE == "0003"){
				$("#requestForm #ENAME").append('<option OBJPS_21= ' + value.OBJPS_21 + ' REGNO_21= ' + value.REGNO_21 + ' DATUM_21= ' + value.DATUM_21 + ' value=' + value.ENAME + '>' + value.ENAME + '</option>');
			}
		});
	}
	
	//  자녀일때 자녀를 선택할 수 있도록 한다.
	$("#requestForm #ENAME").change(function(){
		if($("#requestForm #ENAME").val() !="" ) {
			$("#requestForm #OBJPS_21").val($("#requestForm #ENAME option:selected").attr("OBJPS_21"));
			$("#requestForm #REGNO_21").val($("#requestForm #ENAME option:selected").attr("REGNO_21"));
			$("#requestForm #DATUM_21").val($("#requestForm #ENAME option:selected").attr("DATUM_21"));
			
			var d_regno = $("#requestForm #REGNO_21").val();
			$("#requestForm #REGNO_dis").val(d_regno.substring(0, 6) + "-*******");
			
			var begin_date = removePoint( $("#requestForm #BEGDA").val());
			var d_datum	= addSlash( $("#requestForm #DATUM_21").val());
			
				dif = dayDiff(addSlash(begin_date), d_datum);
		
				if( dif < 0 ) {
					$("#requestForm #Message").show();
					$("#requestForm #Message").val($("#requestForm #ENAME").val() + "는 " + d_datum.substring(0,4) + "년 " + d_datum.substring(5,7) + "월 부터 자녀의료비지원 대상에서 제외되며, " + d_datum.substring(5,7) + "월 전월 의료비까지 지원 가능합니다.");
				} else {
					$("#requestForm #Message").hide();
					$("#requestForm #Message").val("");
				}
		} else {
			$("#requestForm #REGNO_dis").val("");
			$("#requestForm #Message").val("");
		}
	});
	
	var set_default = function() {
		if( $("#requestForm #GUEN_CODE").val() == "0002" ||$("#requestForm #GUEN_CODE").val() == "0003" ) {
			$("#requestForm #PROOF").val("").prop("disabled", false); 
			$("#requestForm #PROOF").prop("checked", false);
		} else { 
			$("#requestForm #PROOF").val("X").prop("disabled", true); 
			$("#requestForm #PROOF").prop("checked", true);
		}
		if( $("#requestForm #GUEN_CODE").val() == "0003" ) {
			$("#requestForm #ENAME").val("").prop("disabled", false); 
		} else {
			$("#requestForm #ENAME").val("").prop("disabled", true); 
	
			$("#requestForm #ENAME").val("");
			$("#requestForm #REGNO_dis").val("");
			$("#requestForm #Message").val("");
			
			$("#requestForm #OBJPS_21").val("");
			$("#requestForm #REGNO_21").val("");
			$("#requestForm #DATUM_21").val("");
		}
	
		$("#form3 #GUEN_CODE").val($("#requestForm #GUEN_CODE").val());
		$("#form3 #OBJPS_21").val($("#requestForm #OBJPS_21").val());
		$("#form3 #REGNO_21").val($("#requestForm #REGNO_21").val());
// 	   totalBill(); 
	};

	var MedicalCreateClient = function() {
		if(medicalPopCheck_data()){
			$("#MedicalCreateListGrid").jsGrid( "insertItem", 
				{ "CHECK_ITEM": "", 
				  "MEDI_NAME": $('#popLayerMedicalForm #MEDI_NAME').val(), 
				  "MEDI_NUMB": $('#popLayerMedicalForm #MEDI_NUMB').val(), 
				  "TELX_NUMB": $('#popLayerMedicalForm #TELX_NUMB').val(), 
				  "EXAM_DATE": $('#popLayerMedicalForm #EXAM_DATE').val(), 
				  "MEDI_CODE": $('#popLayerMedicalForm #MEDI_CODE option:selected').val(),
				  "RCPT_CODE": $('#popLayerMedicalForm #RCPT_CODE option:selected').val(),
				  "MEDI_TEXT": $('#popLayerMedicalForm #MEDI_CODE option:selected').text(),
				  "RCPT_TEXT": $('#popLayerMedicalForm #RCPT_CODE option:selected').text(),
				  "MEDI_MTHD": $('#popLayerMedicalForm #MEDI_MTHD option:selected').val(),
				  "EMPL_WONX": $('#popLayerMedicalForm #EMPL_WONX').val(),
				  "TOTL_WONX": $('#BillWriteForm #TOTL_WONX').val(), 
				  "ASSO_WONX": $('#BillWriteForm #ASSO_WONX').val(), 
				  "x_EMPL_WONX": $('#BillWriteForm #x_EMPL_WONX').val(), 
				  "MEAL_WONX": $('#BillWriteForm #MEAL_WONX').val(), 
				  "APNT_WONX": $('#BillWriteForm #APNT_WONX').val(), 
				  "ROOM_WONX": $('#BillWriteForm #ROOM_WONX').val(), 
				  "CTXX_WONX": $('#BillWriteForm #CTXX_WONX').val(), 
				  "MRIX_WONX": $('#BillWriteForm #MRIX_WONX').val(), 
				  "SWAV_WONX": $('#BillWriteForm #SWAV_WONX').val(), 
				  "ETC1_WONX": $('#BillWriteForm #ETC1_WONX').val(), 
				  "ETC1_TEXT": $('#BillWriteForm #ETC1_TEXT').val(), 
				  "ETC2_WONX": $('#BillWriteForm #ETC2_WONX').val(), 
				  "ETC2_TEXT": $('#BillWriteForm #ETC2_TEXT').val(), 
				  "ETC3_WONX": $('#BillWriteForm #ETC3_WONX').val(), 
				  "ETC3_TEXT": $('#BillWriteForm #ETC3_TEXT').val(), 
				  "ETC4_WONX": $('#BillWriteForm #ETC4_WONX').val(), 
				  "ETC4_TEXT": $('#BillWriteForm #ETC4_TEXT').val(), 
				  "ETC5_WONX": $('#BillWriteForm #ETC5_WONX').val(), 
				  "ETC5_TEXT": $('#BillWriteForm #ETC5_TEXT').val(), 
				  "ETC5_WONX": $('#BillWriteForm #ETC5_WONX').val(),
				  "EMPL_WONX_sub": $('#BillWriteForm #EMPL_WONX_sub').val(),
				  "DISC_WONX": $('#BillWriteForm #DISC_WONX').val(),
				  "bill_EMPL_WONX_tot": $('#BillWriteForm #bill_EMPL_WONX_tot').val()
			  });
		$("#popLayerMedical").popup('hide');
		}
	};
	
		var MedicalUpdateClient = function() {
			if(medicalPopCheck_data()){
		$("#MedicalCreateListGrid").jsGrid( "updateItem",orgItem, 
				{ 
				  "MEDI_NAME": $('#popLayerMedicalForm #MEDI_NAME').val(), 
				  "MEDI_NUMB": $('#popLayerMedicalForm #MEDI_NUMB').val(), 
				  "TELX_NUMB": $('#popLayerMedicalForm #TELX_NUMB').val(), 
				  "EXAM_DATE": $('#popLayerMedicalForm #EXAM_DATE').val(), 
				  "MEDI_CODE": $('#popLayerMedicalForm #MEDI_CODE option:selected').val(),
				  "RCPT_CODE": $('#popLayerMedicalForm #RCPT_CODE option:selected').val(),
				  "MEDI_TEXT": $('#popLayerMedicalForm #MEDI_CODE option:selected').text(),
				  "RCPT_TEXT": $('#popLayerMedicalForm #RCPT_CODE option:selected').text(),
				  "MEDI_MTHD": $('#popLayerMedicalForm #MEDI_MTHD option:selected').val(),
		  		  "EMPL_WONX": $('#popLayerMedicalForm #EMPL_WONX').val()
			  });
		$('#requestForm #EMPL_WONX').val($('#popLayerMedicalForm #EMPL_WONX').val());
		$("#popLayerMedical").popup('hide');
			}
	};
	
	var BillWriteCreate = function (){
		if(BillWritecheck_data()){
		 $("#MedicalCreateListGrid").jsGrid( "updateItem",orgItem, 
					{ "TOTL_WONX": $('#BillWriteForm #TOTL_WONX').val(), 
					  "ASSO_WONX": $('#BillWriteForm #ASSO_WONX').val(), 
					  "x_EMPL_WONX": $('#BillWriteForm #x_EMPL_WONX').val(), 
					  "MEAL_WONX": $('#BillWriteForm #MEAL_WONX').val(), 
					  "APNT_WONX": $('#BillWriteForm #APNT_WONX').val(), 
					  "ROOM_WONX": $('#BillWriteForm #ROOM_WONX').val(), 
					  "CTXX_WONX": $('#BillWriteForm #CTXX_WONX').val(), 
					  "MRIX_WONX": $('#BillWriteForm #MRIX_WONX').val(), 
					  "SWAV_WONX": $('#BillWriteForm #SWAV_WONX').val(), 
					  "ETC1_WONX": $('#BillWriteForm #ETC1_WONX').val(), 
					  "ETC1_TEXT": $('#BillWriteForm #ETC1_TEXT').val(), 
					  "ETC2_WONX": $('#BillWriteForm #ETC2_WONX').val(), 
					  "ETC2_TEXT": $('#BillWriteForm #ETC2_TEXT').val(), 
					  "ETC3_WONX": $('#BillWriteForm #ETC3_WONX').val(), 
					  "ETC3_TEXT": $('#BillWriteForm #ETC3_TEXT').val(), 
					  "ETC4_WONX": $('#BillWriteForm #ETC4_WONX').val(), 
					  "ETC4_TEXT": $('#BillWriteForm #ETC4_TEXT').val(), 
					  "ETC5_WONX": $('#BillWriteForm #ETC5_WONX').val(), 
					  "ETC5_TEXT": $('#BillWriteForm #ETC5_TEXT').val(), 
					  "ETC5_WONX": $('#BillWriteForm #ETC5_WONX').val(),
					  "EMPL_WONX_sub": $('#BillWriteForm #EMPL_WONX_sub').val(),
					  "DISC_WONX": $('#BillWriteForm #DISC_WONX').val(),
					  "bill_EMPL_WONX_tot": $('#BillWriteForm #bill_EMPL_WONX_tot').val(),
					  "EMPL_WONX": $('#BillWriteForm #bill_EMPL_WONX_tot').val()
					});
		 $("#requestForm #EMPL_WONX").val($("#BillWriteForm #bill_EMPL_WONX_tot").val());
		 $("#BillWriteForm").each(function() {
				this.reset();
			});
		 $("#popLayerBillWrite").popup('hide');
		}
	};
	
	var MedicalDeleteClient = function() {
		$("#MedicalCreateListGrid").jsGrid( "deleteItem", orgItem);
	};
	
	// 의료비목록 grid
	$(function() {
		var clients = [];
		$("#MedicalCreateListGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : true,
			data : clients,
			 fields: [
						{
							title: "선택", name: "th1", align: "center", width: "8%" ,
							itemTemplate: function(_, item) {
								return $("<input name='chk' id='chk'>")
										.attr("type", "radio")
										.on("click", function(e) {
											orgItem = item;
										$("#popLayerMedicalForm #MEDI_NAME").val(item.MEDI_NAME);
										$("#popLayerMedicalForm #MEDI_NUMB").val(item.MEDI_NUMB);
										$("#popLayerMedicalForm #TELX_NUMB").val(item.TELX_NUMB);
										$("#popLayerMedicalForm #EXAM_DATE").val(item.EXAM_DATE);
										$("#popLayerMedicalForm #MEDI_CODE").val(item.MEDI_CODE);
										$("#popLayerMedicalForm #RCPT_CODE").val(item.RCPT_CODE);
										$("#popLayerMedicalForm #MEDI_MTHD").val(item.MEDI_MTHD);
										$("#popLayerMedicalForm #EMPL_WONX").val(item.EMPL_WONX.format());
										$("#BillWriteForm #TOTL_WONX").val(item.TOTL_WONX == 0 ? "" : item.TOTL_WONX.format()); 
								 		$("#BillWriteForm #ASSO_WONX").val(item.ASSO_WONX == 0 ? "" : item.ASSO_WONX.format()); 
								 		$("#BillWriteForm #x_EMPL_WONX").val(item.x_EMPL_WONX == 0 ? "" : item.x_EMPL_WONX.format()); 
								 		$("#BillWriteForm #MEAL_WONX").val(item.MEAL_WONX == 0 ? "" : item.MEAL_WONX.format()); 
								 		$("#BillWriteForm #APNT_WONX").val(item.APNT_WONX == 0 ? "" : item.APNT_WONX.format()); 
								 		$("#BillWriteForm #ROOM_WONX").val(item.ROOM_WONX == 0 ? "" : item.ROOM_WONX.format()); 
								 		$("#BillWriteForm #CTXX_WONX").val(item.CTXX_WONX == 0 ? "" : item.CTXX_WONX.format()); 
								 		$("#BillWriteForm #MRIX_WONX").val(item.MRIX_WONX == 0 ? "" : item.MRIX_WONX.format()); 
								 		$("#BillWriteForm #SWAV_WONX").val(item.SWAV_WONX == 0 ? "" : item.SWAV_WONX.format()); 
								 		$("#BillWriteForm #ETC1_WONX").val(item.ETC1_WONX == 0 ? "" : item.ETC1_WONX.format()); 
								 		$("#BillWriteForm #ETC1_TEXT").val(item.ETC1_TEXT); 
								 		$("#BillWriteForm #ETC2_WONX").val(item.ETC2_WONX == 0 ? "" : item.ETC2_WONX.format()); 
								 		$("#BillWriteForm #ETC2_TEXT").val(item.ETC2_TEXT); 
								 		$("#BillWriteForm #ETC3_WONX").val(item.ETC3_WONX == 0 ? "" : item.ETC3_WONX.format()); 
								 		$("#BillWriteForm #ETC3_TEXT").val(item.ETC3_TEXT); 
								 		$("#BillWriteForm #ETC4_WONX").val(item.ETC4_WONX == 0 ? "" : item.ETC4_WONX.format()); 
								 		$("#BillWriteForm #ETC4_TEXT").val(item.ETC4_TEXT); 
								 		$("#BillWriteForm #ETC5_WONX").val(item.ETC5_WONX == 0 ? "" : item.ETC5_WONX.format()); 
								 		$("#BillWriteForm #ETC5_TEXT").val(item.ETC5_TEXT); 
										$("#BillWriteForm #ETC5_WONX").val(item.ETC5_WONX == 0 ? "" : item.ETC5_WONX.format());
										$("#BillWriteForm #EMPL_WONX_sub").val(item.EMPL_WONX_sub == 0 ? "" : item.EMPL_WONX_sub.format());
										$("#BillWriteForm #DISC_WONX").val(item.DISC_WONX == 0 ? "" : item.DISC_WONX.format());
										$("#BillWriteForm #bill_EMPL_WONX_tot").val(item.bill_EMPL_WONX_tot == 0 ? "" : item.bill_EMPL_WONX_tot.format());
										$("#requestForm #RCPT_CODE_Check").val(item.RCPT_CODE);
// 										$("#requestForm #EMPL_WONX").val(item.EMPL_WONX);
									});
							}
						},
				{ title: "<span class='textPink'>*</span>의료기관", name: "MEDI_NAME", type: "text", align: "center", width: "16%" },
				{ title: "<span class='textPink'>*</span>사업자<br>등록번호", name: "MEDI_NUMB", type: "number", align: "center", width: "14%" },
				{ title: "<span class='textPink'>*</span>전화번호", name: "TELX_NUMB", type: "number", align: "center", width: "12%" },
				{ title: "<span class='textPink'>*</span>진료일", name: "EXAM_DATE", type: "number", align: "center", width: "10%" },
				{ title: "<span class='textPink'>*</span>입원<br>/외래", name: "MEDI_CODE", type: "text", align: "center", width: "7%"
					,itemTemplate: function(value, item) {
						if(value == "0001"){
							return "입원";
						}else{
							return "외래";
						}
					}
				},
				{ title: "<span class='textPink'>*</span>영수증구분", name: "RCPT_CODE", type: "text", align: "center", width: "11%",
					itemTemplate: function(value, item) {
						if(value == "0002"){
							return "진료비계산서";
						}else{
							return "약국영수증";
						}
					}
				},
				{ title: "<span class='textPink'>*</span>결재수단", name: "MEDI_MTHD", type: "text", align: "center", width: "11%",
					itemTemplate: function(value, item) {
						if(value == "2"){
							return "신용카드";
						}else if(value == "3"){
							return "현금영수증";
						}else{
							return "현금";
						}
					}
				},
				{ title: "<span class='textPink'>*</span>본인실납부액", name: "EMPL_WONX", type: "number", align: "right", width: "11%" 
					,itemTemplate: function(value, item) {
						return parseInt(value).format();
					}
				},
				
				 { name: "MEDI_TEXT", type: "text", visible: false },
				 { name: "RCPT_TEXT", type: "text", visible: false },
				 
				 { name: "TOTL_WONX", type: "text", visible: false },
				 { name: "ASSO_WONX", type: "text", visible: false },
				 { name: "x_EMPL_WONX", type: "text", visible: false },
				 { name: "MEAL_WONX", type: "text", visible: false },
				 { name: "APNT_WONX", type: "text", visible: false },
				 { name: "ROOM_WONX", type: "text", visible: false },
				 { name: "CTXX_WONX", type: "text", visible: false },
				 { name: "MRIX_WONX", type: "text", visible: false },
				 { name: "SWAV_WONX", type: "text", visible: false },
				 { name: "ETC1_WONX", type: "text", visible: false },
				 { name: "ETC1_TEXT", type: "text", visible: false },
				 { name: "ETC2_WONX", type: "text", visible: false },
				 { name: "ETC2_TEXT", type: "text", visible: false },
				 { name: "ETC3_WONX", type: "text", visible: false },
				 { name: "ETC3_TEXT", type: "text", visible: false },
				 { name: "ETC4_WONX", type: "text", visible: false },
				 { name: "ETC4_TEXT", type: "text", visible: false },
				 { name: "ETC5_WONX", type: "text", visible: false },
				 { name: "ETC5_TEXT", type: "text", visible: false },
				 { name: "ETC5_WONX", type: "text", visible: false },
				 { name: "EMPL_WONX_sub", type: "text", visible: false },
				 { name: "DISC_WONX", type: "text", visible: false },
				 { name: "bill_EMPL_WONX_tot", type: "text", visible: false }
			],
			onItemInserted: function(){
				var data = $("#MedicalCreateListGrid").jsGrid("option", "data");
				var nub2 = 0;
				$.each(data, function(i, $item) {
					nub2 += eval($item.EMPL_WONX == "" ? 0 : $item.EMPL_WONX);
					$("#requestForm #EMPL_WONX_tot").val(nub2.format());
				});
			},
			onItemUpdated: function(){
				var data = $("#MedicalCreateListGrid").jsGrid("option", "data");
				var nub2 = 0;
				$.each(data, function(i, $item) {
					nub2 += eval($item.EMPL_WONX == "" ? 0 : $item.EMPL_WONX);
					$("#requestForm #EMPL_WONX_tot").val(nub2.format());
				});
			},
			onItemDeleted: function(){
				var data = $("#MedicalCreateListGrid").jsGrid("option", "data");
				var nub2 = 0;
				$.each(data, function(i, $item) {
					nub2 += eval($item.EMPL_WONX == "" ? 0 : $item.EMPL_WONX);
					$("#requestForm #EMPL_WONX_tot").val(nub2.format());
				});
			}
		});
	});

	var BillWritecheck_data = function () {
//		if(document.requestForm.x_EMPL_WONX.value == ""){
//			alert("본인부담금①이 계산되지 않았습니다.\n\n해당 항목에 금액을 입력해 주세요");
//			return false;
//		}
		gap1 = Number(removeComma($("#BillWriteForm #TOTL_WONX").val())) -
			   Number(removeComma($("#BillWriteForm #ASSO_WONX").val())) ;
		if(gap1 < 0){
			alert("조합부담금이 총 진료비를 초과할수 없습니다. 다시 입력해 주세요.");
			$("#BillWriteForm #TOTL_WONX").focus();
			return false;
		}
		if( (removeComma($("#BillWriteForm #ETC1_WONX").val()) != "" && $("#BillWriteForm #ETC1_TEXT").val() == "") || 
			(removeComma($("#BillWriteForm #ETC2_WONX").val()) != "" && $("#BillWriteForm #ETC2_TEXT").val() == "") || 
			(removeComma($("#BillWriteForm #ETC3_WONX").val()) != "" && $("#BillWriteForm #ETC3_TEXT").val() == "") || 
			(removeComma($("#BillWriteForm #ETC4_WONX").val()) != "" && $("#BillWriteForm #ETC4_TEXT").val() == "") || 
			(removeComma($("#BillWriteForm #ETC5_WONX").val()) != "" && $("#BillWriteForm #ETC5_TEXT").val() == "") ){
			
			alert("'보험비급여' 항목의 금액에 대한 항목 설명이 빠져있습니다.");
			return false;
		}
		
		setting_bill_data();
	//진료비계산서 입력시 본인 부담금액이 10만원 이상인 경우만 허용함.
	//int_tt_wonx = Number(removeComma(document.requestForm.EMPL_WONX_tot.value));
	//if( int_tt_wonx < 100000 ){
	//alert(" 본인부담금 총액은 10만원이상일 경우에만 신청이 가능합니다. ");
	//return false;
	//}
		
		return true;
	}
	
	var setting_bill_data = function (){
		$("#BillWriteForm #TOTL_WONX").val(removeComma($("#BillWriteForm #TOTL_WONX").val()));
		$("#BillWriteForm #ASSO_WONX").val(removeComma($("#BillWriteForm #ASSO_WONX").val()));
		$("#BillWriteForm #x_EMPL_WONX").val(removeComma($("#BillWriteForm #x_EMPL_WONX").val()));
		$("#BillWriteForm #MEAL_WONX").val(removeComma($("#BillWriteForm #MEAL_WONX").val()));
		$("#BillWriteForm #APNT_WONX").val(removeComma($("#BillWriteForm #APNT_WONX").val()));
		$("#BillWriteForm #ROOM_WONX").val(removeComma($("#BillWriteForm #ROOM_WONX").val()));
		$("#BillWriteForm #CTXX_WONX").val(removeComma($("#BillWriteForm #CTXX_WONX").val()));
		$("#BillWriteForm #MRIX_WONX").val(removeComma($("#BillWriteForm #MRIX_WONX").val()));
		$("#BillWriteForm #SWAV_WONX").val(removeComma($("#BillWriteForm #SWAV_WONX").val()));
		$("#BillWriteForm #ETC1_WONX").val(removeComma($("#BillWriteForm #ETC1_WONX").val()));
		$("#BillWriteForm #ETC1_TEXT").val(removeComma($("#BillWriteForm #ETC1_TEXT").val()));
		$("#BillWriteForm #ETC2_WONX").val(removeComma($("#BillWriteForm #ETC2_WONX").val()));
		$("#BillWriteForm #ETC2_TEXT").val(removeComma($("#BillWriteForm #ETC2_TEXT").val()));
		$("#BillWriteForm #ETC3_WONX").val(removeComma($("#BillWriteForm #ETC3_WONX").val()));
		$("#BillWriteForm #ETC3_TEXT").val(removeComma($("#BillWriteForm #ETC3_TEXT").val()));
		$("#BillWriteForm #ETC4_WONX").val(removeComma($("#BillWriteForm #ETC4_WONX").val()));
		$("#BillWriteForm #ETC4_TEXT").val(removeComma($("#BillWriteForm #ETC4_TEXT").val()));
		$("#BillWriteForm #ETC5_WONX").val(removeComma($("#BillWriteForm #ETC5_WONX").val()));
		$("#BillWriteForm #ETC5_TEXT").val(removeComma($("#BillWriteForm #ETC5_TEXT").val()));
		$("#BillWriteForm #DISC_WONX").val(removeComma($("#BillWriteForm #DISC_WONX").val()));
		$("#BillWriteForm #EMPL_WONX_sub").val(removeComma($("#BillWriteForm #EMPL_WONX_sub").val()));
		$("#BillWriteForm #bill_EMPL_WONX_tot").val(removeComma($("#BillWriteForm #bill_EMPL_WONX_tot").val()));
	}
	
	/* 본인 부담금 총액 합계구하기 */
	var BillWritemultiple_won = function () {
		var hap = 0;
		var gap1 = 0;
		var gap2 = 0;

		gap1 = Number(removeComma($("#BillWriteForm #TOTL_WONX").val())) -
			   Number(removeComma($("#BillWriteForm #ASSO_WONX").val()));
		
		gap2 = Number(removeComma($("#BillWriteForm #MEAL_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #APNT_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ROOM_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #CTXX_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #MRIX_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #SWAV_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC1_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC2_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC3_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC4_WONX").val())) +
			   Number(removeComma($("#BillWriteForm #ETC5_WONX").val()));

		hap = gap1 + gap2 - Number(removeComma($("#BillWriteForm #DISC_WONX").val()));
		
		if( gap1 >0 ) {
			$("#BillWriteForm #x_EMPL_WONX").val(gap1);
		}else{
			$("#BillWriteForm #x_EMPL_WONX").val("");
		}
		
		if( gap2 >0 ) {
			$("#BillWriteForm #EMPL_WONX_sub").val(gap2);
		}else{
			$("#BillWriteForm #EMPL_WONX_sub").val("");
		}
		if( hap >0 ) {
			$("#BillWriteForm #bill_EMPL_WONX_tot").val(hap);
		}else{
			 $("#BillWriteForm #bill_EMPL_WONX_tot").val("");
		}
		insertComma_setting_bill_data()
	}
	
	var insertComma_setting_bill_data = function (){
		$("#BillWriteForm #TOTL_WONX").val(insertComma($("#BillWriteForm #TOTL_WONX").val()));
		$("#BillWriteForm #ASSO_WONX").val(insertComma($("#BillWriteForm #ASSO_WONX").val()));
		$("#BillWriteForm #MEAL_WONX").val(insertComma($("#BillWriteForm #MEAL_WONX").val()));
		$("#BillWriteForm #x_EMPL_WONX").val(insertComma($("#BillWriteForm #x_EMPL_WONX").val()));
		$("#BillWriteForm #APNT_WONX").val(insertComma($("#BillWriteForm #APNT_WONX").val()));
		$("#BillWriteForm #ROOM_WONX").val(insertComma($("#BillWriteForm #ROOM_WONX").val()));
		$("#BillWriteForm #CTXX_WONX").val(insertComma($("#BillWriteForm #CTXX_WONX").val()));
		$("#BillWriteForm #MRIX_WONX").val(insertComma($("#BillWriteForm #MRIX_WONX").val()));
		$("#BillWriteForm #SWAV_WONX").val(insertComma($("#BillWriteForm #SWAV_WONX").val()));
		$("#BillWriteForm #ETC1_WONX").val(insertComma($("#BillWriteForm #ETC1_WONX").val()));
		$("#BillWriteForm #ETC1_TEXT").val($("#BillWriteForm #ETC1_TEXT").val());
		$("#BillWriteForm #ETC2_WONX").val(insertComma($("#BillWriteForm #ETC2_WONX").val()));
		$("#BillWriteForm #ETC2_TEXT").val($("#BillWriteForm #ETC2_TEXT").val());
		$("#BillWriteForm #ETC3_WONX").val(insertComma($("#BillWriteForm #ETC3_WONX").val()));
		$("#BillWriteForm #ETC3_TEXT").val($("#BillWriteForm #ETC3_TEXT").val());
		$("#BillWriteForm #ETC4_WONX").val(insertComma($("#BillWriteForm #ETC4_WONX").val()));
		$("#BillWriteForm #ETC4_TEXT").val($("#BillWriteForm #ETC4_TEXT").val());
		$("#BillWriteForm #ETC5_WONX").val(insertComma($("#BillWriteForm #ETC5_WONX").val()));
		$("#BillWriteForm #ETC5_TEXT").val($("#BillWriteForm #ETC5_TEXT").val());
		$("#BillWriteForm #DISC_WONX").val(insertComma($("#BillWriteForm #DISC_WONX").val()));
		$("#BillWriteForm #EMPL_WONX_sub").val(insertComma($("#BillWriteForm #EMPL_WONX_sub").val()));
		$("#BillWriteForm #bill_EMPL_WONX_tot").val(insertComma($("#BillWriteForm #bill_EMPL_WONX_tot").val()));
	}
	
	//tab2 =================================================================================
	$(function() {
		$("#medicalListGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: true,
			pageSize: 10,
			pageButtonCount: 10,
				
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/supp/getMedicalList.json",
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
						itemTemplate: function(value, storeData) {
							 return $("<input name='chk' id='chk' checked>")
							   .attr("type", "radio")
		 					  .on("click", function(e) {
									$("#MedicalDetailForm #CTRL_NUMB").val(storeData.CTRL_NUMB);
									$("#MedicalDetailForm #GUEN_CODE").val(storeData.GUEN_CODE);
									$("#GUEN_NAME").val(storeData.GUEN_CODE == "0001" ? "본인" : storeData.GUEN_CODE == "0002" ? "배우자" : "자녀");
									$("#MedicalDetailForm #PROOF").val(storeData.PROOF);
									$("#MedicalDetailForm #SICK_NAME").val(storeData.SICK_NAME);
									$("#MedicalDetailForm #SICK_DESC1").val(storeData.SICK_DESC1);
									$("#MedicalDetailForm #SICK_DESC2").val(storeData.SICK_DESC2);
									$("#MedicalDetailForm #SICK_DESC3").val(storeData.SICK_DESC3);
									$("#MedicalDetailForm #EMPL_WONX").val(storeData.EMPL_WONX);
									$("#MedicalDetailForm #COMP_WONX").val(storeData.COMP_WONX); 
							 		$("#MedicalDetailForm #YTAX_WONX").val(storeData.YTAX_WONX); 
							 		$("#MedicalDetailForm #BIGO_TEXT1").val(storeData.BIGO_TEXT1); 
							 		$("#MedicalDetailForm #BIGO_TEXT2").val(storeData.BIGO_TEXT2); 
							 		$("#MedicalDetailForm #WAERS").val(storeData.WAERS); 
							 		$("#MedicalDetailForm #RFUN_DATE").val(storeData.RFUN_DATE); 
							 		$("#MedicalDetailForm #RFUN_RESN").val(storeData.RFUN_RESN); 
							 		$("#MedicalDetailForm #RFUN_AMNT").val(storeData.RFUN_AMNT); 
							 		$("#MedicalDetailForm #ENAME").val(storeData.ENAME); 
							 		$("#MedicalDetailForm #OBJPS_21").val(storeData.OBJPS_21); 
							 		$("#MedicalDetailForm #REGNO_21").val(storeData.REGNO_21);
									$('#MedicalListForm #CTRL_NUMB').val(storeData.CTRL_NUMB);
									$('#MedicalListForm #GUEN_CODE').val(storeData.GUEN_CODE);
									$('#MedicalListForm #SICK_NAME').val(storeData.SICK_NAME);
									$('#MedicalListForm #SICK_DESC1').val(storeData.SICK_DESC1);
									$('#MedicalListForm #BIGO_TEXT1').val(storeData.BIGO_TEXT1);
									$('#MedicalListForm #BIGO_TEXT2').val(storeData.BIGO_TEXT2);
									$('#MedicalListForm #RFUN_DATE').val(storeData.RFUN_DATE);
									$('#MedicalListForm #RFUN_AMNT').val(storeData.RFUN_AMNT);
									$("#form2 #CTRL_NUMB").val(storeData.CTRL_NUMB);
									$("#form2 #GUEN_CODE").val(storeData.GUEN_CODE);
									$("#form2 #OBJPS_21").val(storeData.OBJPS_21);
									$("#form2 #REGNO_21").val(storeData.REGNO_21);
									$("#form2 #PROOF").val(storeData.PROOF);
									$("#form3 #CTRL_YEAR").val(storeData.CTRL_NUMB.substring(0,4));
									$("#form3 #GUEN_CODE").val(storeData.GUEN_CODE);
									$("#form3 #OBJPS_21").val(storeData.OBJPS_21);
									$("#form3 #REGNO_21").val(storeData.REGNO_21);
									$("#totalWaers #EMPL_WONX").val(storeData.EMPL_WONX == 0 ? "" : banolim(storeData.EMPL_WONX).format()+" "+storeData.WAERS);
									$("#totalWaers #YTAX_WONX").val(storeData.YTAX_WONX == 0 ? "" : banolim(storeData.YTAX_WONX).format()+" "+storeData.WAERS);
									$("#totalWaers #COMP_WONX").val(storeData.COMP_WONX == 0 ? "" : banolim(storeData.COMP_WONX).format()+" "+storeData.WAERS);
									detailAction();
									medicalDetailGrid();
									totalBill();
								   });
							},
							align: "center",
							width: "8%"
						},
				{ title: "신청일", name: "BEGDA", type: "text", align: "center", width: "11%" ,
					itemTemplate: function(value, storeData) {
						return value == "0000.00.00" ? "" : value;
					}
				},
				{ title: "관리번호", name: "CTRL_NUMB", type: "text", align: "center", width: "13%" },
				{ title: "구분", name: "GUEN_CODE", type: "text", align: "center", width: "10%",
					itemTemplate: function(value, storeData) {
						if(value == "0001"){
							return "본인";
						}else if(value == "0002"){
							return "배우자";
						}else{
							return "자녀";
						}
					}
				},
				{ title: "상병명", name: "SICK_NAME", type: "text", align: "center", width: "19%" },
				{ title: "본인 납부액", name: "EMPL_WONX", type: "text", align: "right", width: "15%",
					itemTemplate: function(value, storeData) {
						if(value == 0){
							return "";
						}else{
							return banolim(value,0).format() + " <font color='#0000FF'>" + storeData.WAERS + "</font>";
						}
					}
				},
				{ title: "회사 지원액", name: "COMP_WONX", type: "text", align: "right", width: "15%" ,
					itemTemplate: function(value, storeData) {
						if(value == 0){
							return "";
						}else{
							return banolim(value,0).format() + " <font color='#0000FF'>" + storeData.WAERS + "</font>";
						}
					}
				},
				{ title: "최종결재일", name: "POST_DATE", type: "text", align: "center", width: "11%", 
					itemTemplate: function(value, storeData) {
						return value == "0000.00.00" ? "" : value;
					}
				},
			]
		});
	});
	
	// tab2 라디오버튼 상세
		var detailAction = function(){
			if($("#MedicalDetailForm #GUEN_CODE").val()=="0002"){
				$("#MedicalListForm #PROOF").show();
				$("#child").hide();
				$("#MedicalListForm #PROOFNAME").show();
			}else if($("#MedicalDetailForm #GUEN_CODE").val()=="0003"){
				$("#MedicalListForm #PROOF").hide();
				$("#child").show();
				$("#MedicalListForm #PROOF").hide();
				$("#MedicalListForm #PROOFNAME").hide();
				$("#MedicalListForm #ENAME").val($("#MedicalDetailForm #ENAME").val());
				$("#MedicalListForm #REGNO_dis").val($("#MedicalDetailForm #REGNO_21").val().substring(0, 6) + "-*******");
			}else{
				$("#MedicalListForm #PROOF").hide();
				$("#child").hide();
				$("#MedicalListForm #PROOFNAME").hide();
			}
			
			if($("#MedicalDetailForm #PROOF").val() == "X") {
				$("#MedicalListForm #PROOF").prop("checked", true);
			}else{
				$("#MedicalListForm #PROOF").prop("checked", false);
			}
			$("#MedicalListForm #SICK_DESC").val($("#MedicalDetailForm #SICK_DESC1").val()+'\n'+$("#MedicalDetailForm #SICK_DESC2").val()+'\n'+$("#MedicalDetailForm #SICK_DESC3").val());
			
			$("#MedicalListForm #RFUN_DATE").val() == "0000-00-00" ? "" : $("#MedicalListForm #RFUN_DATE").val();
			if($("#MedicalListForm #RFUN_AMNT").val() == "0.0"){
				$("#MedicalListForm #RFUN_AMNT").val("");
			}else{
				$("#MedicalListForm #RFUN_AMNT").val()+$("#MedicalDetailForm #WAERS").val();
			}
		};
		
		// 진료비 계산서 조회  수정
	  var medicalDetailGrid = function(){
			$("#medicalDetailGrid").jsGrid({
				height: "auto",
				width: "100%",
				sorting: true,
				autoload: true,
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "POST",
							url : "/supp/getMedicalDetail.json",
							dataType : "json",
							data : {
								"CTRL_NUMB" : $("#MedicalDetailForm #CTRL_NUMB").val()
								,"GUEN_CODE" : $("#MedicalDetailForm #GUEN_CODE").val()
								,"OBJPS_21" : $("#MedicalDetailForm #OBJPS_21").val()
						 		,"REGNO_21" : $("#MedicalDetailForm #REGNO_21").val()
							},
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
							itemTemplate: function(value, storeData) {
								 return $("<input name='chkBill' id='chkBill' checked>")
								   .attr("type", "radio")
			 					  .on("click", function(e) {
										$("#form2 #RCPT_NUMB").val(storeData.RCPT_NUMB);
										$("#form2 #RCPT_CODE").val(storeData.RCPT_CODE);
									   });
								},
								align: "center",
								width: "8%"
							},
					{ title: "의료기관", name: "MEDI_NAME", type: "text", align: "center", width: "15%" },
					{ title: "사업자<br>등록번호", name: "MEDI_NUMB", type: "text", align: "center", width: "10%", 
						itemTemplate: function(value, storeData) {
							if(value != ""){
								 if( value.substring(3, 4) == "-" && value.substring(6, 7) == "-" ) {
									 return value;
								 } else {
									 return ( value.substring(0, 3)+"-"+value.substring(3,5)+"-"+value.substring(5) );
								 }
							}else{
								return value;
							}
						}
					},
					{ title: "전화번호", name: "TELX_NUMB", type: "text", align: "center", width: "9%"},
					{ title: "진료일", name: "EXAM_DATE", type: "text", align: "center", width: "9%",
						itemTemplate: function(value, storeData) {
							return value == "0000.00.00" ? "" : value;
						}
					},
					{ title: "입원<br>/외래", name: "MEDI_TEXT", type: "text", align: "center", width: "6%" },
					{ title: "영수증구분", name: "RCPT_TEXT", type: "text", align: "center", width: "10%" },
					{ title: "No.", name: "RCPT_NUMB", type: "text", align: "center", width: "6%" },
					{ title: "결재수단", name: "MEDI_MTHD_TEXT", type: "text", align: "center", width: "9%",
						itemTemplate: function(value, storeData) {
							if(storeData.MEDI_MTHD == "1"){
								return "현금";
							}else if(storeData.MEDI_MTHD == "2"){
								return "신용카드";
							}else{
								return "";
							}
						}
					},
					{ title: "본인실납부액", name: "EMPL_WONX", type: "text", align: "right", width: "10%",
						itemTemplate: function(value, storeData) {
							if(value == 0){
								return "";
							}else{
								return banolim(value,0).format();
							}
						}
					},
					{ title: "연말정산<br>반영액", name: "YTAX_WONX", type: "text", align: "right", width: "10%",
						itemTemplate: function(value, storeData) {
								return banolim(value,0).format();
						}
					}
				]
			});
		};
		
		var totalBill = function (){
			jQuery.ajax({
				type : 'GET',
				url : '/supp/getTotalBill.json',
				cache : false,
				dataType : 'json',
				data : $('#form3').serialize(),
				async :false,
				success : function(response) {
					if(response.success){
						var COMP_sum =  response.COMP_sum;
						$("#totalWaers #COMP_sum").val(COMP_sum == 0 ? "" : banolim(COMP_sum).format()+" "+$("#MedicalDetailForm #WAERS").val());
						$("#requestHiddenForm #COMP_sum").val(COMP_sum == 0 ? "" : banolim(COMP_sum).format());

					}else{
						alert("조회시 오류가 발생하였습니다. " + response.message);
					}
				}
			});
			
		};
		
		var billDetail = function (){
			jQuery.ajax({
				type : 'GET',
				url : '/supp/getMedicalBill.json',
				cache : false,
				dataType : 'json',
				data : $('#form2').serialize(),
				async :false,
				success : function(response) {
					if(response.success){
						var storeData =  response.storeData[0];
						var CNT1_WONX =  response.CNT1_WONX;
						var CNT2_WONX =  response.CNT2_WONX;
						$("#billDetail #TOTL_WONX").val(storeData.TOTL_WONX == 0 ? "" : banolim(storeData.TOTL_WONX).format());
						$("#billDetail #ASSO_WONX").val(storeData.ASSO_WONX == 0 ? "" : banolim(storeData.ASSO_WONX).format());
						$("#billDetail #EMPL_WONX").val(storeData.EMPL_WONX == 0 ? "" : banolim(storeData.EMPL_WONX).format());
						$("#billDetail #MEAL_WONX").val(storeData.MEAL_WONX == 0 ? "" : banolim(storeData.MEAL_WONX).format());
						$("#billDetail #APNT_WONX").val(storeData.APNT_WONX == 0 ? "" : banolim(storeData.APNT_WONX).format());
						$("#billDetail #ROOM_WONX").val(storeData.ROOM_WONX == 0 ? "" : banolim(storeData.ROOM_WONX).format());
						$("#billDetail #CTXX_WONX").val(storeData.CTXX_WONX == 0 ? "" : banolim(storeData.CTXX_WONX).format());
						$("#billDetail #MRIX_WONX").val(storeData.MRIX_WONX == 0 ? "" : banolim(storeData.MRIX_WONX).format());
						$("#billDetail #SWAV_WONX").val(storeData.SWAV_WONX == 0 ? "" : banolim(storeData.SWAV_WONX).format());
						$("#ETC1_TEXT_th").val(storeData.ETC1_TEXT);
						$("#billDetail #ETC1_WONX").val(storeData.ETC1_WONX == 0 ? "" : banolim(storeData.ETC1_WONX).format());
						$("#ETC2_TEXT_th").val(storeData.ETC2_TEXT);
						$("#billDetail #ETC2_WONX").val(storeData.ETC2_WONX == 0 ? "" : banolim(storeData.ETC2_WONX).format());
						$("#ETC3_TEXT_th").val(storeData.ETC3_TEXT);
						$("#billDetail #ETC3_WONX").val(storeData.ETC3_WONX == 0 ? "" : banolim(storeData.ETC3_WONX).format());
						$("#ETC4_TEXT_th").val(storeData.ETC4_TEXT);
						$("#billDetail #ETC4_WONX").val(storeData.ETC4_WONX == 0 ? "" : banolim(storeData.ETC4_WONX).format());
						$("#ETC5_TEXT_th").val(storeData.ETC5_TEXT);
						$("#billDetail #ETC5_WONX").val(storeData.ETC5_WONX == 0 ? "" : banolim(storeData.ETC5_WONX).format());
						$("#billDetail #CNT1_WONX").val(CNT1_WONX == 0 ? "" : banolim(CNT1_WONX).format());
						$("#billDetail #DISC_WONX").val(storeData.DISC_WONX == 0 ? "" : banolim(storeData.DISC_WONX).format());
						$("#billDetail #CNT2_WONX").val(CNT2_WONX == 0 ? "" : banolim(CNT2_WONX).format()+" " +$("#MedicalDetailForm #WAERS").val());

					}else{
						alert("조회시 오류가 발생하였습니다. " + response.message);
					}
				}
			});
			
		};
</script>
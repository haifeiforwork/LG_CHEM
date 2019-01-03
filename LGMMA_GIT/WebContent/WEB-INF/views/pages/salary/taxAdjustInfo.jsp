<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.TaxAdjustFlagData"%>

<%
	String targetYear = (String)request.getAttribute("targetYear");
	String taxAdjustPeriod = (String)request.getAttribute("taxAdjustPeriod");
	String prev_YN = (String)request.getAttribute("prev_YN");
	TaxAdjustFlagData taxAdjustFlagData   = (TaxAdjustFlagData)request.getAttribute("taxAdjustFlagData");
	
	System.out.println("데이터확인 ::: "  + targetYear + "//");
	
	
	String title = "조회";
	if(taxAdjustFlagData.canBuild) title = "입력";
	String detailTargetYear = targetYear;
	boolean canDetail = taxAdjustFlagData.canDetail;
	if(!canDetail) detailTargetYear = String.valueOf(Integer.parseInt(detailTargetYear) - 1);
	
	//신용카드용
	//직전년도
	String lastYear1 = String.valueOf(Integer.parseInt(detailTargetYear) - 1);
	//전전년도
	String lastYear2 = String.valueOf(Integer.parseInt(detailTargetYear) - 2);
%>

<!-- contents start -->
<!--// Page Title start -->
<div class="title">
	<h1>
		<span class="colorRed"><%=targetYear%></span>&nbsp;연말정산
		<span class="sText font12 pl10">						
			<%=taxAdjustPeriod %>
		</span> 
	</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">급여</a></span></li>
			<li class="lastLocation"><span><a href="#">연말정산</a></span></li>
		</ul>						
	</div>
</div>
<!--// Page Title end -->

<!--------------- layout body start --------------->
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="personTab" class="selected">기본정보</a></li>
		<% if(taxAdjustFlagData.canBuild){ %>
		<li><a href="#" id="pdfTab">PDF업로드</a></li>
		<% } %>
		<li><a href="#" id="taxAdjustTab">소득공제내역 <%=title %></a></li>
		<li><a href="#" id="familyTab">신청현황</a></li>
		<% if(taxAdjustFlagData.canDetail){ %>
		<li><a href="#" id="detailTab">연말정산내역조회</a></li>					
		<% } %>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a href='#popLayerHometax' class='popLayerHometax_open hue'><span>신청안내</span></a></li>
				<li><a class="darken" href="/download/taxAdjustForm/TaxGuide.ppt" target="_blank"><span>연말정산입력방법</span></a></li>
				<% if(taxAdjustFlagData.canBuild){ %>
				<li><a href="#" class="popLayerTaxPrint_open" id="taxPrintBtn"><span>소득공제신고서발행</span></a></li>
				<% } %>					
			</ul>
		</div>	
	</ul>					
</div>
<!--// Tab end -->			

<!--// Tab1 personTab start -->
<div class="tabUnder personTabDiv">
<form id="personForm"  name="personForm">
	<div class="selectArea">
		<input type="checkbox" name="P_CHG" id="P_CHG" value="X" disabled/>인적공제 변동여부
		<!--span class="pl20" id="pfstidSpan" style="display:none;"><input type="checkbox" name="PFSTID" id="PSN_FSTID" value="X" disabled/>세대주 여부</span-->
		<span class="pl20" id="firstSpan">
			<b>★ 세대주 여부 :</b>
			<input type="radio" name="PFSTID_R" id="PFSTID_Y" value="X"/>세대주
			<input type="radio" name="PFSTID_R" id="PFSTID_N" value=""/>세대원
		</span>
	</div>	
	
	<!--// list start -->
	<div class="listArea">
		<div id="personGrid" class="thSpan"></div>
	</div>
	<!--// list end -->
			
	
	<div class="buttonArea" name="taxAdjustBtnDiv">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="personSaveBtn"><span>저장</span></a></li>
			<li><a href="#" id="personCancelBtn"><span>취소</span></a></li>
		</ul>
	</div>	
	
	<div class="tableComment">
		<p><span class="bold">안내사항</span></p>
		<ul>
			<li>부녀자 : 근로소득금액 3,000만원이하(총급여 4,000만원 수준)인 배우자가 있는 여성(맞벌이 부부)은 부녀자란 "○"표시 후 주민등록등본 및 가족관계증명서를 첨부해야 함</li> 
			<li>한부모 : 배우자가 없는 자로서 기본공제대상 직계비속이 있는 경우 부모란에 수기로 “○” 표시후 가족관계증명서 첨부해야 함 <br>
	 		<span class="bold">※ 부녀자 공제와 한부모 공제는 중복공제가 안되므로 한부모 공제만 적용됨</span></li>
			<li>위탁아동 : 올해에 6개월 이상(만 18세 미만) 직접 양육한 위탁아동일 경우 "□"에 체크 후 저장</li> 
		</ul>
		<br>
		<p><span class="bold colorOrg">주의사항</span></p>
		<ul>
			<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>
		</ul>
	</div>							
</form>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder pdfTabDiv Lnodisplay" id="pdfTabDiv">	
<form name="pdfForm" id="pdfForm" enctype="multipart/form-data">
	<div class="selectArea">
		<input type="checkbox" id="PDF_P_CHG" name="P_CHG" value="X" disabled>인적공제 변동여부
		<span class="pl20"><input type="checkbox" id="PDF_FSTID" name="PFSTID" value="X" disabled>세대주 여부</span>
		<p class="mt5 bold colorRed"> ※  PDF 업로드를 하게 되면 기존에 PDF업로드로 반영한 모든 데이터가 삭제 되오니 이점 주의 하시기 바랍니다.</p>
	</div>
	<!-- file upload start -->
	<div class="fileUploadArea">
		<div class="uploadBox">
			
			<!-- title start -->
			<div class="titleArea boxTitle">
				<h2 class="subtitle withButtons">파일 업로드</h2>
				<div class="buttonArea" name="taxAdjustBtnDiv">
					<ul class="btn_crud">										
						<li><a href="#" id="resetBtn"><span>새로고침</span></a></li>	
						<li><a href="#" id="uploadBtn" class="darken lastBtn"><span>파일저장</span></a></li>							
					</ul>
				</div>							
				<div class="clear"></div>
			</div>
			<!-- title end -->
			
			<div class="boxInner">
				<p class="multiUpload" id="multiUploaddiv">
					<!-- 개발서버에 있는 swf 그대로 사용해주세요 -->
					<script language="javascript">
						makeSwfMultiUpload(
							movie_id='smu03', //파일폼 고유ID
							flash_width='508', //파일폼 너비 (기본값 400, 권장최소 300)
							list_rows='12', // 파일목록 행 (기본값:3)
							limit_size='30', // 업로드 제한용량 (기본값 10)
							file_type_name='PDF 파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
							allow_filetype='*.pdf', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
							deny_filetype='*.cgi *.pl', // 업로드 불가형식
							upload_exe='/taxAdjust/pdfTempFileUpload.json', // 업로드 담당프로그램
							browser_id='<%=session.getId()%>'
						);
					</script>
				</p>				
				
			</div>
		</div>
		<div class="resultBox">							
			<!-- title start -->
			<div class="titleArea boxTitle">
				<h2 class="subtitle">처리결과</h2>								
			</div>
			<!-- title end -->
			
			<div class="boxInner" id="SAPMSG">
				
			</div>
		</div>
	</div>
	<!-- file upload end -->
	 
	<div class="tableComment">		
		<p><span class="bold">파일 업로드 창이 보이지 않을 경우 Adobe Flash Player 를 최신 버전으로 설치해 주시기 바랍니다.</span></p>			
		<br>	
		<p><span class="bold colorOrg">파일 업로드 시 주의사항</span></p>
		<ul class="decimal">
			<li>국세청 PDF 파일만 업로드하실 수 있습니다. (ex. 홍길동(700101)-<%=targetYear%>년도자료.pdf)</li> 
			<li>파일에 비밀번호가 설정된 경우 업로드가 불가능하니 국세청에서 <span class="colorOrg">비밀번호 설정을 해제</span>한 후 파일을 다시 다운로드하셔야 합니다. </li>
			<li>파일 업로드 시 연말정산 공제에 반영 처리되며 연말정산 기간 내에 파일을 다시 업로드 하게 되면 <span class="bold colorOrg">이전 자료는 삭제되고 업로드한 파일로 반영</span>됩니다. </li>
			<li>파일 업로드 후 [처리결과]에서 연말정산 반영내역을 확인하실 수 있습니다. </li> 
			<li>파일을 다시 업로드해야 할 경우 [새로고침] 버튼을 클릭하세요. 단, 클릭시 이전 [처리결과]는 보이지 않게 됩니다.</li>
		</ul>
	</div>	
	</form>				
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder taxAdjustTabDiv Lnodisplay">	

	<!--// Inner Tab start -->
	<div class="tabInside mt25">
		<ul>
			<li class="on"><a href="#" id="insureTab">보험료</a></li>
			<li><a href="#" id="medicalTab">의료비</a></li>
			<li><a href="#" id="educationTab">교육비</a></li>
			<li><a href="#" id="fourInsTab">4대보험</a></li>
			<li><a href="#" id="donationTab">기부금</a></li>
			<li><a href="#" id="pensionTab">연금/저축공제</a></li>
			<li><a href="#" id="houseLoanTab">주택자금상환</a></li>
			<li><a href="#" id="creditCardTab">신용카드</a></li>
			<li><a href="#" id="monthlyRentTab">월세공제</a></li>
			<li><a href="#" id="etcTaxTab">기타/세액공제</a></li>
			<% if(prev_YN.equals("Y")){ %>
			<li><a href="#" id="preWorkTab">전근무지</a></li>
			<% } %>
		</ul>
		<div class="clear"> </div>
	</div>
	<div class="selectArea">
		<input type="checkbox" id="IN_P_CHG" name="P_CHG" value="X" disabled>인적공제 변동여부
		<span class="pl20"><input type="checkbox" id="IN_FSTID" name="PFSTID" value="X" disabled>세대주 여부</span>
		<span class="pl30"></span>
		<p class="mt10 txtPoint" id="companySupp"></p>
	</div>
	
	<!--// Inner Tab end -->
	
	<!--// Inner tab1 start -->
	<div class="tabInsideUnder insureTabDiv">
	<form id="insureForm" name="insureForm">	
		<div class="listArea">	
			<!-- jsGrid start -->		
			<div id="insureGrid"></div>	
		    <!-- jsGrid end -->	
		</div>	
		
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="insureSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="insureCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>
		
		<div class="tableComment">						
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>	
				<li>PDF를 통하여 업로드 된 경우에는 “PDF”열에 체크 표시됩니다.</li>
			</ul>
		</div>					
	</form>
	</div>
	
	<!--// Inner tab1 end -->
	
	<!--// Inner tab2 start -->
	<div class="tabInsideUnder medicalTabDiv Lnodisplay">
	<form id="medicalForm" name="medicalForm">	
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="medicalGrid" class="thSpan"></div>	
		    <!-- jsGrid end -->	
		</div>	
	
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="medicalSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="medicalCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>	
	
		<div class="tableComment">						
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>	
				<li>PDF를 통하여 업로드 된 경우에는 “PDF”열에 체크 표시됩니다.</li>
				<li>연말정산 간소화 서비스를 통한 증빙 제출시에는 요양기관(사업자번호 및 상호) 입력없이 건수와 금액만 입력하세요.</li>
				<li>회사에서 지원 받은 의료비 내역이 보여지며 “회사지원분”열에 체크 표시됩니다.</li>
				<li>시력보정용 안경 또는 콘택트렌즈 구입시 발생한 비용은 “안경콘택트”에 반드시 체크해야 합니다.</li>	
				<li>난임시술비 의료비의 경우 난임시술비용만 별도로 입력후 "난임시술비"에 반드시 체크해야 합니다.</li>
				<li class="colorOrg">국세청 PDF로 올릴 경우 난임시술비로 자동으로 체크가 안되므로 난임시술비용이 있는 경우에는 PDF로 입력하지 마시고 직접 입력하여 주시기 바랍니다.</li>
			</ul>
		</div>						
	</form>
	</div>
	<!--// Inner tab2 end -->
	
	<!--// Inner tab3 start -->
	<div class="tabInsideUnder educationTabDiv Lnodisplay">
	<form id="educationForm" name="educationForm">
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="educationGrid"></div>	
		    <!-- jsGrid end -->	
		</div>
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="educationSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="educationCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>	
	
		<div class="tableComment">						
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>	
				<li>PDF를 통하여 업로드 된 경우에는 “PDF”열에 체크 표시됩니다.</li>
				<li>회사에서 지원 받은 교육비 내역이 보여지며 “회사지원분”열에 체크 표시됩니다.</li>
				<li>중/고등학교의 교복(체육복)구입비 입력시 “교복구입비”체크란에 반드시 체크해야 합니다.</li>
				
				<li>체험학습비 입력시 "체험학습비" 항목에 반드시 체크해야 합니다.</li>
				<li>본인학자금대출 원금상환액 입력시 "본인학자금대출" 항목에 반드시 체크해야 합니다.</li>
												
			</ul>
		</div>
	</form>	
	</div>
	<!--// Inner tab3 end -->
	
	<!--// Inner tab4 start -->
	<div class="tabInsideUnder fourInsTabDiv Lnodisplay">
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="fourInsGrid" class="thSpan"></div>	
		    <!-- jsGrid end -->	
		</div>
		<!-- //20170110 전근무지 의료보험 조회되지 않게 막음 - 전근무지주석
		<% if(prev_YN.equals("Y")){ %>
		
		<div class="tableArea  tdLineBold" >
			<h3 class="subsubtitle">국세청 자료</h3>
			<div class="table">
				<table class="tableGeneral" id="preFourInsTB">
				<caption>전근무지</caption>
				<colgroup>
					<col width="30%" />
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
				</colgroup>
				<thead>
					<th colspan=2 class="alignCenter">건강보험</th>
					<th colspan=2 class="alignCenter">국민연금</th>
				</thead>
				<tbody>
					<tr>
						<th>건강보험 연말정산 금액</th>
						<td class="alignRight bgWhite" name="SUM_HI_YRS" format="curWon"></td>
						<th>추납보험료 납부금액</th>
						<td class="alignRight bgWhite" name="SUM_SPYM" format="curWon"></td>
					</tr>
					<tr>
						<th>장기요양 연말정산 금액</th>
						<td class="alignRight bgWhite" name="SUM_LTRM_YRS" format="curWon"></td>
						<th>실업크레딧 납부금액</th>
						<td class="alignRight bgWhite" name="SUM_JLC" format="curWon"></td>
					</tr>
					<tr>
						<th>건강보험 (보수월액) 고지금액 합계</th>
						<td class="alignRight bgWhite" name="SUM_HI_NTF" format="curWon"></td>
						<th>직장가입자 고지금액 합계</th>
						<td class="alignRight bgWhite" name="SUM_NTF" format="curWon"></td>
					</tr>
					<tr>
						<th>장기요양 (보수월액) 고지금액 합계</th>
						<td class="alignRight bgWhite" name="SUM_LTRM_NTF" format="curWon"></td>
						<th>지역가입자 등 납부금액 합계</th>
						<td class="alignRight bgWhite" name="SUM_PMT" format="curWon"></td>
					</tr>
					<tr>
						<th>건강보험 (소득월액) 납부금액 합계</th>
						<td class="alignRight bgWhite" name="SUM_HI_PMT" format="curWon"></td>
						<th>총합계</th>
						<td class="alignRight bgWhite" name="SUM_AMT" format="curWon"></td>
					</tr>
					<tr>
						<th>장기요양 (소득월액) 납부금액 합계</th>
						<td class="alignRight bgWhite" name="SUM_LTRM_PMT" format="curWon"></td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>총합계</th>
						<td class="alignRight bgWhite" name="SUM" format="curWon"></td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
				</table>
			</div>
		</div>
		<% } %>
		 //-->
		 <div class="tableComment">						
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li>4대보험 공제금액은 당사 근무기간 중 발생분에 한함 (중도입사자의 경우, 국세청 PDF자료와 상이할 수 있음)</li>							
			</ul>
		</div>
	</div>
	<!--// Inner tab4 end -->
	
	<!--// Inner tab5 start -->
	<div class="tabInsideUnder donationTabDiv Lnodisplay">
	<form id="donationForm" name="donationForm">	
		<div class="buttonArea" style="display:none;">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="donationTest"><span>그리드조정</span></a></li>
			</ul>
		</div>
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="donationGrid" class="thSpan"></div>	
		    <!-- jsGrid end -->	
		</div>	
	
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="donationSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="donationCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>	
	
		<div class="tableComment">						
			<p><span class="bold colorOrg">기부금 허위공제 금지 안내</span></p>
			<ul>
				<li>실제기부금보다 과다 기재 또는 임의 작성된 영수증, 기도비용 지출로 받은 영수증 등은 기부금 허위공제에 해당되며,<br>
				LG Way에 대한 심각한 위반행위로서 허위공제 사례가 발생될 경우, 사규에 따라 조치를 취할 예정이오니 각별히 주의해주시기 바랍니다.</li>								
			</ul>
			<br>
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>	
				<li>PDF를 통하여 업로드 된 경우에는 “PDF”열에 체크 표시됩니다.</li>
			</ul>
		</div>	
	</form>	
	</div>
	<!--// Inner tab5 end -->
	
	<!--// Inner tab6 start -->
	<div class="tabInsideUnder pensionTabDiv Lnodisplay">
	<form id="pensionForm" name="pensionForm">	
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="pensionGrid"></div>	
		    <!-- jsGrid end -->	
		</div>
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="pensionSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="pensionCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>
		<div class="tableComment">
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>	
				<li>PDF를 통하여 업로드 된 경우에는 “PDF”열에 체크 표시됩니다.</li>
				<li>청약저축/주택청약종합저축을 입력하고자 하는 경우 구분을 "청약저축"으로 선택 후 유형에서 해당저축을 선택하여 주시기 바랍니다.</li>
				<li>개인연금저축/연금저축을 입력하고자 하는 경우 구분을 "연금저축"으로 선택 후 유형에서 해당저축을 선택하여 주시기 바랍니다.</li>									
			</ul>
		</div>	
	</form>	
	</div>
	<!--// Inner tab6 end -->
	
	<!--// Inner tab7 start -->
	<div class="tabInsideUnder houseLoanTabDiv Lnodisplay">
	<form id="houseLoanForm" name="houseLoanForm">	
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="houseLoanGrid"></div>	
		    <!-- jsGrid end -->	
		</div>
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="houseLoanSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="houseLoanCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>
		<div class="tableComment">						
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>	
				<li>PDF를 통하여 업로드 된 경우에는 “PDF”열에 체크 표시됩니다.</li>
				<li>
					연말정산 최초 신청시 증빙서류 제출
					<ul>
						<li>임차차입금 원리금상환액 : 주민등록등본</li>
						<li>장기주택저당차입금 이자상환액 : 주민등록등본, 건물등기부등본, 개별(공동)주택가격확인서 또는 분양계약서사본</li>
					</ul>
				</li>
				<li>회사에서 대출 받은 주택구입 자금의 원리금 상환액은 상기 공제 대상에 포함되지 않음</li>									
			</ul>
		</div>	
	</form>	
	</div>
	<!--// Inner tab7 end -->
	
	<!--// Inner tab8 start -->
	<div class="tabInsideUnder creditCardTabDiv Lnodisplay">
	<form id="creditCardForm" name="creditCardForm">	
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="creditCardGrid"></div>	
		    <!-- jsGrid end -->	
		</div>
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="creditCardSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="creditCardCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>
		<div class="tableComment">						
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>	
				<li>PDF를 통하여 업로드 된 경우에는 “PDF”열에 체크 표시됩니다.</li>
				<li>
					입력하는 방법
					<ul>
						<li><strong>구분</strong> : 신용카드/직불(선불카드)/현금영수증을 정확하게 입력해야 함</li>
						<li><strong>공제대상액</strong> : 신용카드 영수증 및 현금영수증은 일반 공제 대상 금액이라고 나와있는 부분을 그대로 입력</li>
						<li class="colorOrg"><strong>전통시장/대중교통</strong> : 신용카드 영수증 및 현금영수증에 전통시장으로 구분 되어 있는 경우 반드시 체크<br>
						→ 하나의 영수증에 일반공제/전통시장/대중교통으로 구분되어 있는 경우 각각 구분해서 입력해야 함</li>
						<%-- <li class="colorOrg"><strong>사용기간</strong> : 본인이 사용한 신용카드, 직불카드, 현금영수증은 반드시 <%=lastYear2%>년, <%=lastYear1%>년 사용액, 올해 사용액으로 구분하여 입력<br>해야하고
						<strong>추가공제율사용분은 본인만 입력 가능</strong>합니다.
						</li> --%>
						<li><strong>회사비용 정리금</strong> : 개인카드 사용 후 회사비용으로 정리한 경우 관할 부서에서 일괄 반영한 금액임</li>
						<li>중도입사자의 경우, 근로기간(종/전근무지 포함) 중 사용금액에 대해서만 세액공제 가능 (국세청 월별자료 참조)</li>
					</ul>
				</li>
				<li>신용카드가 연급여(GHR > 급여 > 연급여)에서 지급계의 25% 이하인 경우 공제 안되므로 입력할 필요 없음<br>
				※  온누리 상품권 사용만으로는 공제 불가능하며, 반드시 현금영수증으로 처리해야 함
				</li>									
			</ul>
		</div>
		<div class="clear"></div>	
	</form>
	</div>
	<!--// Inner tab8 end -->
					
	<!--// Inner tab9 start -->
	<div class="tabInsideUnder monthlyRentTabDiv Lnodisplay">
	<form id="monthlyRentForm" name="monthlyRentForm">
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="monthlyRentGrid"></div>	
		    <!-- jsGrid end -->	
		</div>
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="monthlyRentSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="monthlyRentCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>
		<div class="tableComment">		
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>
				<li>금액은 계약기간에 납부한 월세액 총액을 입력해야 함</li>
			</ul>
		</div>	
	</form>	
	</div>
	<!--// Inner tab9 end -->
	
	<!--// Inner tab10 start -->
	<div class="tabInsideUnder etcTaxTabDiv Lnodisplay">
	<form id="etcTaxForm" name="etcTaxForm">
		<div class="listArea">	
			<!-- jsGrid start -->	
			<div id="etcTaxGrid" class="thSpan"></div>	
		    <!-- jsGrid end -->	
		</div>
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="etcTaxSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="etcTaxCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>
		<div class="tableComment">		
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>
			</ul>
		</div>
	</form>
	</div>
	<!--// Inner tab10 end -->
	<!--// Inner tab11 start -->
	<div class="tabInsideUnder preWorkTabDiv Lnodisplay">
	<form id="preWorkForm" name="preWorkForm">
		<div class="tableArea  tdLineBold" >
			<div class="table">
				<table class="tableGeneral" id="preWorkTable">
				<caption>전근무지</caption>
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<thead>
					<th></th>
					<th class="alignCenter">전근무지 1</th>
				</thead>
				<tbody>
					<tr>
						<th>사업자번호</th>
						<td>
							<input type="text" name="BIZNO" value="" id="BIZNO1" class="w100" format="bizNo"/>	
							<span class="floatRight txtright">
							<input type="checkbox" name="TXPAS" value="Z">납세조합	
							</span>
							<input type="hidden" name="SEQNR">
							<input type="hidden" name="BEGDA">
							<input type="hidden" name="ENDDA">												
						</td>						
					</tr>
					<tr>
						<th>회사이름</th>
						<td>
							<input type="text" name="COMNM" value="" id="COMNM1" class="wPer" />											
						</td>
					</tr>
					<tr>
						<th>근무기간</th>
						<td>
							<input name="PABEG" id="PABEG1" type="text" size="5" readonly class="readOnly"/>
							~
							<input name="PAEND" id="PAEND1" type="text" size="5" readonly class="readOnly"/>
						</td>
					</tr>
					<tr>
						<th>감면기간</th>
						<td>
							<input name="EXBEG" id="EXBEG1" type="text" size="5" readonly class="readOnly"/>
							~
							<input name="EXEND" id="EXEND1" type="text" size="5" readonly class="readOnly"/>
						</td>
					</tr>
					<tr>
						<th><font name="LGTXT"></font><input type="hidden" name="LGART"></th>
						<td>
							<input type="text" name="BET01" value="" class="wPer inputMoney" onkeyup="cmaComma(this);" onchange="cmaComma(this);" format="currency" />											
						</td>
					</tr>
				</tbody>
				</table>
			</div>
		</div>		
					
		<div class="buttonArea" name="taxAdjustBtnDiv">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="preWorkSaveBtn"><span>저장</span></a></li>
				<li><a href="#" id="preWorkCancelBtn"><span>취소</span></a></li>
			</ul>
		</div>	
		
		<div class="tableComment">
			<p><span class="bold">안내사항</span></p>
			<ul>
				<li>
					<%=targetYear%>년 자매사 전입자, 경력입사자, 신규입사자 중 전근무지 소득이 있었던 해당자는 전근무지에서 발급받은 
					근로소득원천징수영수증에 표시된 각 항목에 대하여 <br>입력 후 저장하시기 바랍니다.
				</li>
				<li>
					입력시 주의사항
					<ul>
						<li><strong>사업자 번호/회사이름</strong> : 근로소득원천징수영수증의 <b>1.법인명 / 3.사업자등록번호</b> 입력</li>
						<li><strong>근무기간</strong> : 근로소득원천징수영수증의 <b>11.근무기간</b> 입력</li>
						<li><strong>정규급여/상여/인정상여</strong> : 근로소득원천징수영수증의 <b>13.급여 / 14.상여 / 15.인정상여</b> 해당금액 입력</li>
						<li><strong>결정세액 소득세/지방소득세</strong> : 근로소득원천징수영수증의 <b>64.결정세액 소득세/지방소득세</b> 각 해당금액 입력</li>
						<li><strong>국민연금보험료</strong> : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>국민연금</b> 금액 입력 (또는 32.국민연금보험료공제 금액 입력)</li>
						<li><strong>건강보험료</strong> : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>건강보험</b> 금액 입력</li>
						<li><strong>고용보험료</strong> : 근로소득원천징수영수증의 왼쪽하단부분 표시된 <b>고용보험</b> 금액 입력</li>
					</ul>
				</li>
				<li>각 항목별 금액 입력 후 전근무지 근로소득원천징수영수증을 첨부하여 주시기 바랍니다.
					<ul>
						<li>국민연금/건강보험/고용보험이 근로소득원천징수영수증의 왼쪽하단부분에 표시가 안되어있는 경우 근로소득원천징수부도 첨부하여 주시기 바랍니다.</li>
					</ul>
				</li>									
			</ul>
			<br>
			<p><span class="bold colorOrg">주의사항</span></p>
			<ul>
				<li><span class="bold">항목 변경 후 반드시 [저장] 버튼을 클릭하셔야 반영이 됩니다. [취소] 버튼 클릭 시 변경된 항목이 초기화됩니다.</span></li>
			</ul>
		</div>
	</form>
	</div>
	<!--// Inner tab11 end -->
</div>
<!--// Tab3 end -->	

<!--// Tab4 start -->
<div class="tabUnder familyTabDiv Lnodisplay">
	<div class="selectArea">
		<input type="checkbox" name="P_CHG" id="F_P_CHG" disabled>인적공제 변동여부
		<span class="pl20"><input type="checkbox" id ="F_FSTID" name="PFSTID" disabled>세대주 여부</span>
	</div>
	<div class="listArea">	
		<!-- jsGrid start -->	
		<div id="familyGrid" class="thSpan"></div>	
	    <!-- jsGrid end -->	
	</div>
</div>
<!--// Tab4 end -->

<!--// tab5 start -->
<div class="tabUnder detailTabDiv Lnodisplay">
<form name="detailForm" id="detailForm">
	<h2 class="subtitle">
		<label for="input_select01"><strong>연도</strong></label>
		<select class="w70" id="detailTargetYear" name="select"> 
			<option><%=detailTargetYear %></option>
		</select>		
	</h2>			
	<!--// Table start -->
	<div class="errorArea" id="detailMsgDiv">
		<div class="errorMsg">
			<div class="errorImg"><!-- 에러이미지 --></div>			
			<div class="alertContent">
				<p id="detailMsgSpan"></p>
			</div>
		</div>
	</div>





<div class="tableArea tdLine" id="detailTableDiv">
	<div class="table ">
		<table class="tableGeneral borderBottom  noHover">
		<caption>연말정산내역조회</caption>
		<colgroup>
			<col class="col_16p"/>
			<col class="col_15p"/>
			<col class="col_15p"/>
			<col class="col_15p"/>
			<col class="col_15p"/>
			<col class="col_24p"/>
		</colgroup>
		<thead>
		<tr>
		  <th colspan="4" class="alignCenter">항목</td>
		  <!-- @2014 연말정산 <th  class="alignCenter">< %=titleText[j]%>-->
		  <th class="alignCenter">금액</th>
		  </th>
		  <th class="alignCenter">비고</th>
		</tr>
		</thead>
		<tbody class="bgTbody">
		<tr>
		  <td rowspan="4" class="alignCenter">전근무지</td>
		  <td colspan="3">급여총액</td>
		  <td class="alignRight bgWhite" name="_전근무지_급여총액" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">상여총액</td>
		  <td class="alignRight bgWhite" name="_전근무지_상여총액" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">인정상여</td>
		  <td class="alignRight bgWhite" name="_전근무지_인정상여" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">비과세소득</td>
		  <td class="alignRight bgWhite" name="_전근무지_비과세소득" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td rowspan="4" class="alignCenter">현근무지</td>
		  <td colspan="3">급여총액</td>
		  <td class="alignRight bgWhite" name="_급여총액" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">상여총액</td>
		  <td class="alignRight bgWhite" name="_상여총액" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">인정상여</td>
		  <td class="alignRight bgWhite" name="_인정상여" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">비과세소득</td>
		  <td class="alignRight bgWhite" name="_비과세소득" format="curWon"></td>
		  <td></td>
		</tr>
		<tr class="bgPoint">
		  <td colspan="4" class="alignCenter">총급여 </td>
		  <td class="alignRight bgWhite" name="_총급여"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="4" class="alignCenter">근로소득공제</td>
		  <td class="alignRight bgWhite" name="_근로소득공제"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr class="bgPoint">
		  <td colspan="4" class="alignCenter">근로소득금액</td>
		  <td class="alignRight bgWhite" name="_과세대상근로소득금액"  format="curWon"></td>
		  <td>총급여 - 근로소득공제</td>
		</tr>
		<tr>
		  <td rowspan="3" class="alignCenter">기본공제</td>
		  <td colspan="3">본인</td>
		  <td class="alignRight bgWhite" name="_기본공제_본인"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">배우자</td>
		  <td class="alignRight bgWhite" name="_기본공제_배우자"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">부양가족</td>
		  <td class="alignRight bgWhite" name="_기본공제_부양가족"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td rowspan="4" class="alignCenter">추가공제</td>
		  <td colspan="3">경로우대</td>
		  <td class="alignRight bgWhite" name="_추가공제_경로우대70"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">장애인</td>
		  <td class="alignRight bgWhite" name="_추가공제_장애인"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">부녀자</td>
		  <td class="alignRight bgWhite" name="_추가공제_부녀자"  format="curWon"></td>							  
		  <!--@2015 연말정산 <td>근로소득금액이 3,000만원 이하인 경우에만 가능</td> -->
		  <td>총급여 4,147만원 이하인 경우에만 가능</td>
		</tr>							
		<!--CSR ID:C20140106_63914  한부모가족 /YSP -->
		<tr>
		  <td colspan="3">한부모가족</td>
		  <td class="alignRight bgWhite" name="_추가공제_한부모가족"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td rowspan="2" class="alignCenter">연금보험료공제</td>
		  <td colspan="3">국민연금보험료</td>
		  <td class="alignRight bgWhite" name="_연금보험료공제"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">기타연금보험료공제</td>
		  <td class="alignRight bgWhite" name="_연금보험료공제_기타"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td rowspan="4" class="alignCenter">특별공제</td>
		  <td colspan="3">건강보험료</td>
		  <td class="alignRight bgWhite" name="_특별공제_건강보험료"  format="curWon"></td>
		  <td></td>
		</tr>
		<td colspan="3">고용보험료</td>
		  <td class="alignRight bgWhite" name="_특별공제_고용보험료"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">주택자금(주택임차차입원리금상환액,<br>저당차입금이자상환액)</td>
		  <td class="alignRight bgWhite" name="_특별공제_주택자금"  format="curWon"></td>
		  <td>임차차입원리금상환액:납입액×40% <br>(임차차입원리금상환액에 한하여, 주택마련저축공제포함 300만원한도)</td>
		</tr>
		<tr>
		  <td colspan="3">기부금(이월분) </td>
		  <td class="alignRight bgWhite" name="_특별공제_기부금"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td rowspan="5" class="alignCenter">그밖의 소득공제</td>
		  <td colspan="3">개인연금저축</td>
		  <td class="alignRight bgWhite" name="_개인연금저축소득공제"  format="curWon"></td>
		  <td>납입액×40%(72만원한도)</td>
		</tr>
		<tr>
		  <td colspan="3">소기업 소상공인 공제부금 소득공제</td>
		  <td class="alignRight bgWhite" name="_소기업등소득공제"  format="curWon"></td>
		  <td>300만원 한도</td>
		</tr>
		<tr>
		  <td colspan="3">주택마련저축소득공제(청약저축,주택청약종합저축)</td>
		  <td class="alignRight bgWhite" name="_특별공제_주택마련저축소득공제"  format="curWon"></td>
		  <td>납입액×40%(임차차입원리금상환액 포함 300만원한도)</td>
		</tr>
		<tr>
		  <td colspan="3">투자조합출자 소득공제</td>
		  <td class="alignRight bgWhite" name="_투자조합출자등소득공제"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">신용카드 등 소득공제 </td>
		  <td class="alignRight bgWhite" name="_신용카드공제"  format="curWon"></td>
		  <td>총급여 25% 초과 시 소득공제 가능 </td>
		</tr>
		<tr>
		  <td colspan="4" class="alignCenter">장기집합투자증권저축</td>
		  <td class="alignRight bgWhite" name="_그밖의_장기집합투자증권저축"  format="curWon"></td>
		  <td>납입액×40%(240만원한도) 단, 총급여 8,000만원 이하</td>
		</tr>
		
		<!--CSR ID:C20140106_63914  특별공제 종합한도 초과액  -->
		<tr>
		  <td colspan="4" class="alignCenter">종합한도 초과액</td>
		  <td class="alignRight bgWhite" name="_특별공제_종합한도_초과액"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr class="bgPoint">
		  <td colspan="4" class="alignCenter">종합소득 과세표준</td>
		  <td class="alignRight bgWhite" name="_종합소득과세표준"  format="curWon"></td>
		  <td>근로소득금액－기본－추가－연금－특별－그밖의소득공제</td>
		</tr>
		<tr class="bgPoint">
		  <td colspan="4" class="alignCenter">산출세액</td>
		  <td class="alignRight bgWhite" name="_산출세액"  format="curWon"></td>
		  <td>과세표준×세율－누진공제율</td>
		</tr>
		<tr>
		  <td rowspan="15" class="alignCenter">세액공제</td>
		  <td colspan="3">근로소득</td>
		  <td class="alignRight bgWhite" name="_세액공제_근로소득"  format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">자녀 - 공제대상</td>
		  <td class="alignRight bgWhite" name="_세액공제_자녀" format="curWon"></td>
		  <td>2명 이하 : 1명당 연 15만원<br>
		    3명 이상 : 연 30만원 ＋ 2명을 초과하는 1명당 연 30만원</td>
		</tr>
		<!--------------------------------------2014연말정산 재정산 시작---------------------------------------------------->
		<tr>
		  <td colspan="3">자녀 - 6세 이하</td>
		  <td class="alignRight bgWhite" name="_추가공제_자녀양육비" format="curWon"></td>
		  <td>1명을 초과하는 1명당 연 15만원</td>
		</tr>
		<tr>
		  <td colspan="3">자녀 - 출산/입양자</td>
		  <td class="alignRight bgWhite" name="_추가공제_출산입양" format="curWon"></td>
		  <td>첫째 : 연 30만원<br>
			 둘째 : 연 50만원<br>
 			셋째 이상 : 연 70만원<br>
			⇒ ‘17.1.1 이후 출생 · 입양 신고한 기본공제대상 자녀의 경우 </td>
		</tr>							
		<!--------------------------------------2014연말정산 재정산 끝---------------------------------------------------->							
		<tr>
		  <td colspan="3">과학기술인공제 및 퇴직연금소득공제</td>
		  <td class="alignRight bgWhite" name="_세액공제_퇴직연금소득공제" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td colspan="3">연금저축소득공제</td>
		  <td class="alignRight bgWhite" name="_세액공제_연금저축소득공제" format="curWon"></td>
		  <td>납입액(400만원한도)×12% <br>
		  총급여액 1억2천만원 초과자는 연간300만원</td>
		</tr>
		<tr>
		  <td colspan="3">보험료 - 보장성</td>
		  <td class="alignRight bgWhite" name="_세액공제_보장성보험료" format="curWon"></td>
		  <td>납입액(100만원한도)×12%</td>
		</tr>
		<tr>
		  <td colspan="3">보험료 - 장애인전용 보장성</td>
		  <td class="alignRight bgWhite" name="_세액공제_보장성보험료_장애인전용" format="curWon"></td>
		  <td>납입액(100만원한도)×15%</td>
		</tr>
		<tr>
		  <td colspan="3">의료비 </td>
		  <td class="alignRight bgWhite" name="_세액공제_의료비" format="curWon"></td>
		  <td><!-- @2014 연말정산 국내인원만 조회되도록 --> 
		<!-- @2015 연말정산 (근로소득3%초과된 의료비(700만원한도)＋추가공제)×15% --> 
		    (총급여 3%초과된 의료비(700만원한도)＋추가공제)×15% <br>
		    난임시술비×20% 추가 </td>
		</tr>
		<tr>
		  <td colspan="3">교육비 </td>
		  <td class="alignRight bgWhite" name="_세액공제_교육비" format="curWon"></td>
		  <td><!-- @2014 연말정산 국내인원만 조회되도록 --> 
		    교육비납입액(학력한도)×15% <br>
		    현장체험 학습비추가(학생 1인당 연 30만원 한도)<br>
		    본인학자금대출의 원리금 상환액 추가
		    </td>
		</tr>
		<tr>
		  <td colspan="3">기부금 </td>
		  <td class="alignRight bgWhite" name="_세액공제_기부금" format="curWon"></td>
		  <td><!-- @2014 연말정산 국내인원만 조회되도록 --> 
		    공제금액×15%(3,000만원 초과분은 25%) </td>
		</tr>
		<tr>
		  <td colspan="3">정치기부금</td>
		  <td class="alignRight bgWhite" name="_세액공제_정치기부금" format="curWon"></td>
		  <td><!-- @2014 연말정산 국내인원만 조회되도록 --> 
		    10만원이하:100/110<br>
		    10만원초과:10만원초과액×15%(3,000만원 초과분 25%) </td>
		</tr>
		<tr>
		  <td colspan="3">주택차입금</td>
		  <td class="alignRight bgWhite" name="_세액공제_주택차입금" format="curWon"></td>
		  <td>이자상환액×30%</td>
		</tr>
		<tr>
		  <td colspan="3">표준세액공제</td>
		  <td class="alignRight bgWhite" name="_세액공제_표준세액공제" format="curWon"></td>
		  <td>특별공제 및 세액공제가 "0"원일 때 12만원 공제<br>
		    (단, 근로소득. 자녀공제 제외) </td>
		</tr>
		<tr>
		  <td colspan="3">월세액</td>
		  <td class="alignRight bgWhite" name="_세액공제_월세액" format="curWon"></td>
		  <td>월세액(750만원한도)×10% 단, 총급여 7,000만원 이하<br>
		  	 본인 또는 기본공제대상자(배우자·부양가족) 명의로 임대차계약을 체결하고, 본인이 지급한 월세액</td>
		</tr>
		<tr>
		  <td></td>
		  <td class="alignCenter">갑근세</td>
		  <td class="alignCenter">주민세</td>
		  <td class="alignCenter">농특세</td>
		  <td class="alignCenter">계</td>
		  <td></td>
		</tr>
		<tr class="bgPoint">
		  <td class="alignCenter">결정세액 </td>
		  <td class="alignRight bgWhite" name="_결정세액_갑근세" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_결정세액_주민세" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_결정세액_농특세" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_결정세액합계" format="curWon"></td>
		  <td>산출세액－세액공제</td>
		</tr>
		<tr>
		  <td class="alignCenter">기납부세액(전)</td>
		  <td class="alignRight bgWhite" name="_전근무지_납부소득세" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_전근무지_납부주민세" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_전근무지_납부특별세" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_전근무지기납부세액합계" format="curWon"></td>
		  <td></td>
		</tr>
		<tr>
		  <td class="alignCenter">기납부세액(현)</td>
		  <td class="alignRight bgWhite" name="_기납부세액_갑근세1" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_기납부세액_주민세1" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_기납부세액_농특세1" format="curWon"></td>
		  <td class="alignRight bgWhite" name="_기납부세액합계1" format="curWon"></td>
		  <td></td>
		</tr>
		<tr class="bgPoint">
		  <td class="alignCenter">차감징수세액</td>
		 	<!-- 원단위 절사 -->							    
			    <td class="alignRight bgWhite" name="_차감징수세액_갑근세" format="curWon"></td>
			    <td class="alignRight bgWhite" name="_차감징수세액_주민세" format="curWon"></td>
			    <td class="alignRight bgWhite" name="_차감징수세액_농특세" format="curWon"></td>
			    <td class="alignRight bgWhite" name="_차감징수세액합계" format="curWon"></td>
			    <td>결정세액－기납부세액(전/현)</td>
			  </tr>
			  </tbody>
			</table>													
		</div>
	</div>
</form>										
</div>
<!--// tab5 end -->

<!-- popup : 연말정산 신청안내 start -->
<div class="layerWrapper layerSizeL" id="popLayerHometax" style="display:none !important">
	<div class="layerHeader">
		<strong>연말정산 신청안내</strong>
		<a href="#" class="btnClose popLayerHometax_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">			
			<!--// Content start  -->			
			<div class="hometaxInfo">					
           		<ul>
	           		<li><h2><a href="/download/taxAdjustForm/TaxInfoGuide.ppt" target="_blank">1. <%=targetYear%> 연말정산<span class="icoFormdown">다운로드 아이콘</span></a></h2></li>
	           		<li>
	           			<h2>2. 연말정산 양식</h2>
	           			<ul class="formList">
							<li><a href="/download/taxAdjustForm/family.xls" target="_blank">① 부양가족해지신청서<span class="icoFormdown">다운로드 아이콘</span></a></li>
							<li><a href="/download/taxAdjustForm/certificate.rtf" target="_blank">② 장애인증명서<span class="icoFormdown">다운로드 아이콘</span></a></li>
							<li><a href="/download/taxAdjustForm/together.doc" target="_blank">③ 일시퇴거자동거가족상황표<span class="icoFormdown">다운로드 아이콘</span></a></li>  
							<li><a href="/download/taxAdjustForm/eduform.doc" target="_blank">④ 교육비 및 교복구입 납입 증명서<span class="icoFormdown">다운로드 아이콘</span></a></li>
							<li><a href="/download/taxAdjustForm/schoolbookform.doc" target="_blank">⑤ 방과후학교수업용도서구입증명서(학교외구입분)<span class="icoFormdown">다운로드 아이콘</span></a></li>
							<li><a href="/download/taxAdjustForm/gibuform.doc" target="_blank">⑥ 기부금명세서<span class="icoFormdown">다운로드 아이콘</span></a></li>
						</ul>
					</li>
					<li>
						<h2>3. 제출기한 및 신고서 작성방법</h2>
						<ul>
							<li>
								① 주요 일정
								<!--// table start -->
								<div class="tableArea tablePopup tdLine mt10">
									<div class="table alignCenter">
										<table class="tableGeneral">
										<caption>연말정산 주요 일정</caption>
										<colgroup>
											<col class="col_50p" />
											<col class="col_50p" />
										</colgroup>
										<thead>
											<tr>
												<th class="alignCenter">일 정</th>
												<th class="alignCenter">내 용</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td> `18. 1. 05(금) ~  1. 12(금)</td>
												<td>부양가족 등록/해지 신청 및 관련서류 제출</td>
											</tr>
											<tr>
												<td>`18. 1. 16(화) ~ 1. 22(월)</td>
												<td>연말정산 시스템 입력</td>
											</tr>
											<tr class="bgYellow">
												<td >`18. 1. 19(금) ~ 1. 26(금)</td>
												<td>연말정산 관련 증빙서류 제출</td>
											</tr>
										</tbody>
										</table>
									</div>
								</div>	
								<!--// table end -->
							</li>
							<li class="mb15">
								② 작성방법 및 제출 
								<ul>
							        <li>공제받고자 하는 항목의 금액 총액을 입력 후 저장</li>
							        <li>소득공제신고서를 발행하고 서명 날인 후 증빙서류(원본)를 유첨 및 주관부서 제출 </li>
							        <li>단, PDF로 업로드 한 경우에는 증빙서류 제출 필요 없음</li>
						        </ul>
						    </li>
						    <li>
						    	③ 사업장별 주관부서 담당자 현황
						    	<!--// table start -->
								<div class="tableArea tablePopup tdLine mt10">
									<div class="table alignCenter">
										<table class="tableGeneral">
										<caption>사업장별 주관부서 담당자 현황</caption>
										<colgroup>
											<col class="col_28p" />
											<col class="col_36p" />
											<col class="col_36p" />
										</colgroup>
										<thead>
											<tr>
												<th class="alignCenter">사업장</th>
												<th class="alignCenter">담당자</th>
												<th class="alignCenter">연락처</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th rowspan="2" class="alignCenter">서울</th>
												<td>경영지원팀 김남주</td>
												<td>02)-6930-3837</td>
											</tr>
											<tr>
												<td>경영지원팀 박진희</td>
												<td>02)-6930-3811</td>
											</tr>
											<tr>
												<th rowspan="2" class="alignCenter">여수 및 대전</th>
												<td>인사노경팀 이병위</td>
												<td>061)-688-2523</td>
											</tr>
											<tr>
												<td>인사노경팀 차효윤</td>
												<td>061)-688-2522</td>
											</tr>
										</tbody>
										</table>
									</div>
								</div>	
								<!--// table end -->							    	
						    </li>
						</ul>
					</li>
				</ul>
			 </div>
			<!--// Content end  -->							
		</div>		
	</div>		
</div>
<!-- //popup: 연말정산 신청안내  end -->
<style type="text/css">
.printCenter { width: 700px; margin: 0 auto }
.fontTitle { font-size: 18pt; font-weight: bold; text-align:center; height:50px;padding-top:20px;}
.font01 { font-size: 10pt; font-weight: bold;height:28px; padding-top:10px;}
.printTB {width:100%;}
.printTB th{ font-size: 8pt; background-color: #CBE0FD !important;-webkit-print-color-adjust: exact; color:#000; font-weight: normal; text-align: center; line-height: 14pt}
.printTB td{ font-size: 8pt; background-color: #FFFFFF;text-align: left; color:#000; padding-left:4px;word-break: break-all;}
.printTB .txtleft{text-align: left;padding-left:4px;}
.printTB .txtcenter{text-align: center;padding-left:0px;padding-right:0px;}
.printTB .txtright{text-align: right;padding-left:0px;padding-right:4px;}
.printTB .txtTab{text-align: left;padding-left:20px;padding-right:0px;}
.printbd {border-collapse:separate !important;border-spacing:0;border-right:1px solid #000;border-bottom:1px solid #000;}
.printbd th{border-left:1px solid #000;border-top:1px solid #000;border-right:0;border-bottom:0;}
.printbd td{border-left:1px solid #000;border-top:1px solid #000;border-right:0;border-bottom:0;}
</style>
<!-- //popup : 소득공제신고서발행 start -->
<div class="layerWrapper layerSizeP" id="popLayerTaxPrint" style="display:none !important">
	<div class="layerHeader">
		<strong>소득공제신고서발행</strong> <font id="closeTaxPrintBtn"><a href="#" class="btnClose popLayerTaxPrint_close">창닫기</a></font>
	</div>
	<div class="layerContainer">
		<div class="layerContent" id="printHtml">
		<!--// Content start  -->
			<!--// Tab start -->
			<div class="tabArea poptabArea">
				<ul class="tab" id="printTab">
					<li id="firstPrintTab"><a href="#" onclick="chgPopupTabs(this, 'poptab0');" class="selected">동의서</a></li>
					<li id="incomePrintTab"><a href="#" onclick="chgPopupTabs(this, 'poptab1');"><%=targetYear%> 근로소득자 소득공제 신고서</a></li>
					<li id="cardPrintTab"><a href="#" onclick="chgPopupTabs(this, 'poptab2');">신용카드지급명세서</a></li>
					<li id="medicalPrintTab"><a href="#" onclick="chgPopupTabs(this, 'poptab3');">의료비지급명세서</a></li>
					<li id="donationPrintTab"><a href="#" onclick="chgPopupTabs(this, 'poptab4');">기부금지급명세서</a></li>
				</ul>
			</div>
			<!-- //poptab0 start -->
			<div id="firstPrint" class="poptabUnder poptab0" style="height:558px;">
					<div class="printCenter">
						<div class="printForm">
							<div class="printTitle"><%=targetYear%> 연말정산 확인</div>
							<ul class="checkList">
								<li>
									1. 부양가족 신청 및 인적공제(기본공제, 추가공제) 항목 변동 확인
									<span class="checkRight">확인함<input type="checkbox" name="printChkYn"></span>
								</li>
								<li>
									2. 동일 과세기간(<%=targetYear%>년도) 내 종근무지 또는 전근무지 유무 확인
									<span class="checkRight">확인함<input type="checkbox" name="printChkYn"></span>
								</li>
								<li>
									3. 본인이 신청한 기본공제 대상자는 타인의 기본공제 대상자가 아니며,<br>&nbsp;&nbsp;&nbsp;연간 소득금액(퇴직소득 및 양도소득 포함)이 100만원 이하임을 확인
									<span class="checkRight">확인함<input type="checkbox" name="printChkYn"></span>
								</li>
							</ul>
							<br>						
							<p class="pTxt">제출자 본인은 위 내용이 사실과 다름 없음을 확인하며, 소득/세액 공제 신청 오류 및 허위공제 등에 대한<br>사후 조치 의무 및 효과는 제출자 본인에게 귀속됨을 확인합니다.</p>
							<br>
							<div class="buttonArea" name="">
								<ul class="btn_crud">
									<li><a class="" href="#" onclick="printChkAll();"><span>모두 확인함</span></a></li>
								</ul>
							</div>
						</div>
					</div>
			</div>
			
			<!-- //poptab0 end -->
			<div id="printMain" style="display:none;">
			<!-- //스크롤 start -->
			<div class="printScroll">
			
			<!-- //poptab1 start -->
			<div id="incomePrint" class="poptabUnder poptab1 Lnodisplay">
			<div class="printCenter">
	  			<div class="fontTitle"><%=targetYear%> 근로소득자 소득공제 신고서</div>

        <!--개인정보 테이블 시작-->
        <table id="userTB" class="printTB printbd">
        <colgroup>
			<col width="60"/>
			<col width="60"/>
			<col width="150"/>
			<col width="60"/>
			<col width="80"/>
			<col width="104"/>
			<col width="130"/>
		</colgroup>
          <tr>
          	<th rowspan="3">소득자</th>
          	<th>부서명</th>
          	<td colspan="3" name="e_orgtx"></td>
          	<th>성명</th>
          	<td name="ename" class="txtcenter"></td>
          </tr>
          <tr>
            <th>입사일자</th>
            <td name="e_dat03" format="dateKR"></td>
            <th>사번</th>
            <td name="empNo" class="txtcenter"></td>
            <th>주민등록번호</th>
            <td name="e_regno" format="resNo" class="txtcenter"></td>
          </tr>
          <tr>
            <th>주소</th>
            <td colspan="5" name="e_stras" addValue="e_locat" addformat="blank"></td>
          </tr>
        </table>
        <!--개인정보 테이블 끝-->
        <div class="font01"><input type="checkbox" id="PRINT_P_CHG" disabled>인적공제 변동여부
            &nbsp;&nbsp;&nbsp;
            <input type="checkbox" id="PRINT_PFSTID" disabled>세대주 여부
        </div>
        <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 인적공제</div>
        <!--인적공제 테이블 시작-->
        <table id="personTB" class="printTB printbd">
        <colgroup>
			<col width="80"/>
			<col width="65"/>
			<col width="100"/>
			<col width="60"/>
			<col width="70"/>
			<col width="59"/>
			<col width="59"/>
			<col width="59"/>
			<col width="53"/>
			<col width="30"/>
		</colgroup>
          <tr>
            <th rowspan="2">관계</th>
            <th rowspan="2">성명</th>
            <th rowspan="2">주민등록번호</th>
            <th rowspan="2">기본공제</th>
            <th colspan="5">추가공제</th>
          </tr>
          <tr>
            <th>경로우대</th>
            <th>장애자<br>(코드)</th><!--CSR ID: 2013_9999 -->
            <th>부녀자</th>
            <th>한부모<br>가족</th><!--CSR ID: 2013_9999 -->
            <th>위탁<br>아동</th>
          </tr>
          <tr>
          	<td name="STEXT" class="txtcenter"></td>
          	<td name="ENAME" class="txtcenter"></td>
          	<td name="REGNO" class="txtcenter" format="resNo"></td>
          	<td name="BETRG01" format="emptyCur" class="txtright"></td>
          	<td name="BETRG02" format="emptyCur" class="txtright"></td>
          	<td name="BETRG03" format="emptyCur" class="txtright" addValue="HNDCD" addformat="bracket"></td>
          	<td name="BETRG04" format="emptyCur" class="txtright"></td>
          	<td name="BETRG07" format="emptyCur" class="txtright"></td>
          	<td name="FSTID" format="replace" code="code" codeNm="value" class="txtcenter"></td>
          </tr>
        </table>
        <!--인적공제 테이블 끝-->
        <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 보험금/의료비/기부금</div>
        <!--특별공제 테이블 시작-->
        <table id="specialTB" class="printTB printbd">
	        <colgroup>
				<col width="290"/>
				<col width="70"/>
				<col width="70"/>
				<col width="70"/>
				<col width="180"/>
			</colgroup>
          <tr>
            <th rowspan="2">구분</th>
            <th rowspan="2">개인추가분</th>
            <th rowspan="2">PDF</th>
            <th colspan="2">자동반영분</th>
          </tr>
          <tr>
          	<th>금액</th>
          	<th>내용</th>
          </tr>
          <tr>
            <td name="GUBN_TEXT"></td>
            <td name="ADD_BETRG" format="emptyCur" class="txtright"></td>
            <td name="ACT_BETRG" format="emptyCur" class="txtright"></td>
            <td name="AUTO_BETRG" format="emptyCur" class="txtright"></td>
            <td name="AUTO_TEXT"></td>
          </tr>
        </table>
		<!--특별공제 테이블 끝-->
    

 		<!-- @2015 연말정산 주택자금공제 항목 추가 -->
		<div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 주택자금 공제</div>    
        <!--주택자금공제  테이블 시작-->
        <table id="houseLoanTB" class="printTB printbd">
	        <colgroup>
				<col width="30%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="15%"/>
				<col width="11%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
			</colgroup>
			<tr>
				<th>구분</th>
				<th>최초차입일</th>
				<th>최종상환예정일</th>
				<th>금액</th>
				<th>대출기간(년)</th>
				<th>고정<br>금리</th>
				<th>비거치</th>
				<th>PDF</th>
			</tr>
			<tr>
				<td name="SUBTY" format="replace" code="code" codeNm="value"></td>
				<td name="RCBEG" class="txtcenter"></td>
				<td name="RCEND" class="txtcenter"></td>
				<td name="NAM01" format="emptyCur" class="txtright"></td>
				<td name="LNPRD" format="emptyCur" class="txtright"></td>
				<td name="FIXRT" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				<td name="NODEF" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				<td name="GUBUN" format="replace" code="code" codeNm="value" class="txtcenter"></td>
			</tr>
        </table>
        <!--주택자금공제 테이블 끝-->
        <!-- @2015 연말정산 주택자금공제 항목 추가 끝 -->
        <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 교육비</div> 
        <!--특별공제 교육비 테이블 시작-->
        <table id="educationTB" class="printTB printbd">
	        <colgroup>
				<col width="100"/>
				<col width="100"/>
				<col width="120"/>
				<col width=""/>
				<col width="80"/>
				<col width="40"/>
				<col width="40"/>
				<col width="40"/>
				<col width="40"/>
				<col width="40"/>
			</colgroup>
          <tr>
            <th>관계</th>
            <th>성명</th>
            <th>주민등록번호</th>
            <th>학력</th>
            <th>금액</th>
            <th>교복<br>구입비</th>
            <th>체험<br>학습비</th>
            <th>본인<br>학자금<br>대출</th>
            <th>장애인<br>교육비</th>
            <th>자동<br>반영분</th>
            <th>국세청<br>자료</th>
            <th>PDF</th>
          </tr>
          <tr>
            <td name="SUBTY" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="F_ENAME" class="txtcenter"></td>
            <td name="F_REGNO" class="txtcenter" format="resNo"></td>
            <td name="FASAR" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="BETRG" format="emptyCur" class="txtright"></td>
            <td name="EXSTY" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="EDUFT" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="LOAN" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="ACT_CHECK" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="AUTO_GUBUN" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="CHNTS" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="GUBUN" format="replace" code="code" codeNm="value" class="txtcenter"></td>
          </tr>
        </table>
        <!--특별공제 교육비 테이블 끝-->
        <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 연금/저축 공제</div>
        <table id="pensionTB" class="printTB printbd">
	        <colgroup>
				<col width="125"/>
				<col width="125"/>
				<col width=""/>
				<col width="65"/>
				<col width="105"/>
				<col width="70"/>
				<col width="40"/>
				<col width="30"/>
			</colgroup>
          <tr>
            <th>구분</th>
            <th>유형</th>
            <th>금융기관</th>
            <th>가입일</th><!-- @2015 연말정산 추가 -->
            <th>증권보험/계좌번호</th>
            <th>금액</th>
            <th>종(전)<br>근무지</th>
            <th>PDF</th>
          </tr>
		  <tr>
		  	<td name="SUBTY" format="replace" code="code" codeNm="value"></td>
		  	<td name="GUBN_TEXT"></td>
		  	<td name="FINCO" format="replace" code="code" codeNm="value"></td>
		  	<td name="RCBEG" class="txtcenter"></td>
		  	<td name="ACCNO"></td>
		  	<td name="NAM01" format="emptyCur" class="txtright"></td>
		  	<td name="PREIN" format="replace" code="code" codeNm="value" class="txtcenter"></td>
		  	<td name="PDF_FLAG" format="replace" code="code" codeNm="value" class="txtcenter"></td>
		  </tr>
        </table>

        <!--연금/저축 테이블 끝-->
        <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 신용카드 등 및 기타</div>
        <!--기타/세액공제 테이블 시작-->
        <table id="etcTaxTB" class="printTB printbd">
	        <colgroup>
				<col width="170"/>
				<col width="80"/>
				<col width="80"/>
				<col width="80"/>
				<col width="234"/>
			</colgroup>
          <tr>
            <th rowspan="2">구분</th>
            <th rowspan="2">개인추가분</th>
            <th rowspan="2">PDF</th>
            <th colspan="2">자동반영분</th>
          </tr>
          <tr>
          	<th>금액</th>
          	<th>내용</th>
          </tr>
          <tr>
            <td name="GUBN_TEXT"></td>
            <td name="ADD_BETRG" format="emptyCur" class="txtright"></td>
            <td name="ACT_BETRG" format="emptyCur" class="txtright"></td>
            <td name="AUTO_BETRG" format="emptyCur" class="txtright"></td>
            <td name="AUTO_TEXT"></td>
          </tr>
        </table>
        <!--기타/세액공제 테이블 끝-->
        <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 부양가족공제자 명세</div>      
        <!--부양가족공제자 테이블 시작-->
        <table id="familyTB" class="printTB printbd">
	        <colgroup>
				<col width="45"/>
				<col width="48"/>
				<col width="57"/>
				<col width="28"/>
				<col width="28"/>
				<col width="28"/>
				<col width="51"/>
				<col width="51"/>
				<col width="51"/>
				<col width="51"/>
				<col width="51"/>
				<col width="51"/>
				<col width="51"/>
			</colgroup>
          <tr>
            <th>관계</th>
            <th>성명</th>
            <th>구분</th>
            <th>기본<br>공제</th>
            <th>장애</th>
            <th>자녀<br>양육</th>
            <th>보험료</th>
            <th>의료비</th>
            <th>교육비</th>
            <th>신용<br>카드</th>
            <th>직불<br>카드등</th>
            <th>현금<br>영수증</th>
            <th>기부금</th>
          </tr>
          <tr>
            <td name="FAMI_RLNM" class="txtcenter"></td>
            <td name="FAMI_NAME" class="txtcenter"></td>
            <td name="E_GUBUN" class="txtcenter"></td>
            <td name="FAMI_B001" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="FAMI_B002" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="FAMI_B003" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="INSUR" format="emptyCur" class="txtright"></td>
            <td name="MEDIC" format="emptyCur" class="txtright"></td>
            <td name="EDUCA" format="emptyCur" class="txtright"></td>
            <td name="CREDIT" format="emptyCur" class="txtright"></td>
            <td name="DEBIT" format="emptyCur" class="txtright"></td>
            <td name="CASHR" format="emptyCur" class="txtright"></td>
            <td name="GIBU" format="emptyCur" class="txtright"></td>
          </tr>
        </table>
        <!--부양가족공제자 테이블 끝-->
      	<div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 월세 공제</div>
        <!--//월세공제 테이블 시작-->
        <table id="monthlyRentTB" class="printTB printbd">
	        <colgroup>
				<col width="70"/>
				<col width="90"/>
				<col width="65"/>
				<col width="45"/>
				<col width=""/>
				<col width="65"/>
				<col width="65"/>
				<col width="80"/>
			</colgroup>
          <tr>
			<th>임대인성명</th>
			<th>등록번호</th>
			<th>주택유형</th>
			<th>면적</th>
			<th>주소지</th>
			<th>계약시작일</th>
			<th>계약종료일</th>
			<th>금액</th>
          </tr>
          <tr>
            <td name="LDNAM" class="txtcenter"></td>
            <td name="LDREG" class="txtcenter"></td>
            <td name="HOUTY" format="replace" code="code" codeNm="value" class="txtcenter"></td>
            <td name="FLRAR" class="txtright"></td>
            <td name="ADDRE"></td>
            <td name="RCBEG" class="txtcenter"></td>
            <td name="RCEND" class="txtcenter"></td>
            <td name="NAM01" format="emptyCur" class="txtright"></td>
          </tr>
        </table>

        <!--//월세공제 테이블 끝-->
      <div id="preWorkDiv">
		<% if(prev_YN.equals("Y")) { %>
		
		<div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 전근무지</div>
      	<!--//전근무지 테이블 시작-->
        <table id="preWorkTB" class="printTB printbd">
	        <colgroup>
				<col width="50%"/>
				<col width="50%"/>
			</colgroup>
          <thead>
				<th></th>
				<th>전근무지 1</th>
			</thead>
			<tbody>
				<tr>
					<th class="txtleft">사업자번호</th>
					<td><font name="BIZNO" format="bizNo"></font>
						<span class="floatRight txtright">
						<input type="checkbox" name="TXPAS" disabled>납세조합	
						</span>												
					</td>
				</tr>
				<tr>
					<th class="txtleft">회사이름</th>
					<td name="COMNM" class="txtcenter"></td>
				</tr>
				<tr>
					<th class="txtleft">근무기간</th>
					<td name="PABEG" class="txtcenter" addValue="PAEND" addformat="period"></td>
				</tr>
				<tr>
					<th class="txtleft">감면기간</th>
					<td name="EXBEG" class="txtcenter" addValue="EXEND" addformat="period"></td>
				</tr>
				<tr>
					<th name="LGTXT" class="txtleft"></th>
					<td name="BET01"  format="emptyCur" class="txtright"></td>
				</tr>
			</tbody>
        </table>
        <!--//전근무지 테이블 끝-->
      	<div class="font01">* 전근무지 원천징수 영수증 첨부 
      		<input type="checkbox">
              Y
            <input type="checkbox">
              N
        </div>
    	<% } %>
    	</div>
    	<!-- //전근무지 end -->
    	
    	<!-- //동의서 start -->
    	<div class="printForm">
			<ul class="checkList">
				<li>
					1. 부양가족 신청 및 인적공제(기본공제, 추가공제) 항목 변동 확인
					<span class="checkRight">확인함<input type="checkbox" checked disabled/></span>
				</li>
				<li>
					2. 동일 과세기간(<%=targetYear%>년도) 내 종근무지 또는 전근무지 유무 확인
					<span class="checkRight">확인함<input type="checkbox" checked disabled/></span>
				</li>
				<li>
					3. 본인이 신청한 기본공제 대상자는 타인의 기본공제 대상자가 아니며,<br>&nbsp;&nbsp;&nbsp;연간 소득금액(퇴직소득 및 양도소득 포함)이 100만원 이하임을 확인
					<span class="checkRight">확인함<input type="checkbox" checked disabled/></span>
				</li>
			</ul>
			<p class="pTxt">제출자 본인은 위 내용이 사실과 다름 없음을 확인하며, 소득/세액 공제 신청 오류 및 허위공제 등에 대한<br>사후 조치 의무 및 효과는 제출자 본인에게 귀속됨을 확인합니다.</p>
		</div>
    	<!-- //동의서 end -->
    	
    	<div class="font01" align="right">
    		<%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;일 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b id="signName"></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 서명 또는 인 )
    	</div>
	</div>
	</div>
	<!-- //poptab1 end -->
				<!-- //poptab2 start -->
				<div id="cardPrint" class="poptabUnder poptab2 Lnodisplay">
				<div class="printCenter">
					<div class="fontTitle">신용카드지급명세서</div>
				
				        <!--개인정보 테이블 시작-->
				        <table id="userTB1" class="printTB printbd">
				        <colgroup>
							<col width="70"/>
							<col width="240"/>
							<col width="90"/>
							<col width="240"/>
						</colgroup>
				          <tr>
				            <th>성명</th>
				          	<td name="ename"></td>
				            <th>주민등록번호</th>
				            <td name="e_regno" format="resNo"></td>
				          </tr>
				          <tr>
				            <th>주소</th>
				            <td colspan="3" name="e_stras" addValue="e_locat" addformat="blank"></td>
				          </tr>
				        </table>
				        <!--개인정보 테이블 끝-->
				      
				      <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> <%=targetYear%> 년도 신용카드 지급내역</div>     
				    
				        <!--특별공제신용카드 테이블 시작-->
				
				        <table id="cardTB" class="printTB printbd">
					        <colgroup>
								<col width="25"/>
								<col width="47"/>
								<col width="60"/>
								<col width="90"/>
								<col width=""/>
								<col width="65"/>
								<col width="30"/>
								<col width="30"/>
								<%-- <col width="105"/> --%>
								<col width="30"/>
								<col width="65"/>
							</colgroup>
				            <tr>
				              <th>No.</th>
				              <th>관계</th>
				              <th>성명</th>
				              <th>주민등록번호</th>
				              <th>구분</th>
				              <th>공제대상액</th>
				              <th>전통<br>시장</th>
				              <th>대중<br>교통</th>
				             <!--  <th>사용기간</th> -->
				              <th>PDF</th>
				              <th>사업관련<br>비용</th>
				            </tr>
				            <tr>
				            	<td name="autoNumbering" class="txtcenter"></td>
				            	<td name="SUBTY" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="F_ENAME" class="txtcenter"></td>
				            	<td name="F_REGNO" format="resNo" class="txtcenter"></td>
				            	<td name="GU_NAME"></td>
				            	<td name="BETRG" format="currency" class="txtright"></td>
				            	<td name="TRDMK" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="CCTRA" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<!-- <td name="EXPRD" format="replace" code="code" codeNm="value"></td> -->
				            	<td name="GUBUN" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="BETRG_B" format="currency" class="txtright"></td>
				            </tr>
				          </table>
				        <!--특별공제신용카드 테이블 끝-->
				      
				      
				      <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> 추가공제율 상반기 사용액</div>     
				    
				        <!--추가공제율 테이블 시작-->
				
				        <%-- <table id="cardAddTB" class="printTB printbd">
					        <colgroup>
								<col width="25"/>
								<col width="47"/>
								<col width="60"/>
								<col width="90"/>
								<col width=""/>
								<col width="65"/>
								<col width="30"/>
								<col width="30"/>
								<col width="105"/>
								<col width="30"/>
								<col width="65"/>
							</colgroup>
				            <tr>
				              <th>No.</th>
				              <th>관계</th>
				              <th>성명</th>
				              <th>주민등록번호</th>
				              <th>구분</th>
				              <th>공제대상액</th>
				              <th>전통<br>시장</th>
				              <th>대중<br>교통</th>
				              <th>사용기간</th>
				              <th>PDF</th>
				              <th>사업관련<br>비용</th>
				            </tr>
				            <tr>
				            	<td name="autoNumbering" class="txtcenter"></td>
				            	<td name="SUBTY" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="F_ENAME" class="txtcenter"></td>
				            	<td name="F_REGNO" format="resNo" class="txtcenter"></td>
				            	<td name="GU_NAME"></td>
				            	<td name="BETRG" format="currency" class="txtright"></td>
				            	<td name="TRDMK" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="CCTRA" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="EXPRD" format="replace" code="code" codeNm="value"></td>
				            	<td name="GUBUN" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="BETRG_B" format="currency" class="txtright"></td>
				            </tr>
				          </table> --%>
				        <!--추가공제율 테이블 끝-->
				        
				    <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> <%=targetYear%> 년도 사용액</div> 
				   
				          <table class="printTB printbd" id="cardSumTB">
				          <colgroup>
				          	<col width="21%"/>
							<col width="13%"/>
							<col width="21%"/>
							<col width="13%"/>
							<col width="21%"/>
							<col width=""/>
				          </colgroup>
				          <tr>
				          <th>신 용 카 드 (일반)</th>
				          <td name="total_card" format="currency" class="txtright"></td>
				          <th>신 용 카 드 (전통시장)</th>
				          <td name="total_card_trdmk" format="currency" class="txtright"></td>
				          <th>신 용 카 드 (대중교통)</th>
				          <td name="total_card_cctra" format="currency" class="txtright"></td>
				          </tr>
				          <tr>
				          <th>현금영수증 (일반)</th>
				          <td name="total_money" format="currency" class="txtright"></td>
				          <th>현금영수증 (전통시장)</th>
				          <td name="total_money_trdmk" format="currency" class="txtright"></td>
				          <th>현금영수증 (대중교통)</th>
				          <td name="total_money_cctra" format="currency" class="txtright"></td>
				          </td>
				          </tr>   
				          <tr>
				          <th>직 불 체 크 (일반)</th>
				          <td name="total_check" format="currency" class="txtright"></td>
				          <th>직 불 체 크 (전통시장)</th>
				          <td name="total_check_trdmk" format="currency" class="txtright"></td>
				          <th>직 불 체 크 (대중교통)</th>
				          <td name="total_check_cctra" format="currency" class="txtright"></td>
				          </td>
				          </tr>          
				
				          </table>
				     <br>
				            <div class="font01" align="right"><%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;일
				                    <br>제출자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b id="signName1"></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 서명 또는 인 )</div>
				           
				            <!-- div class="font01" align="center">귀하</div-->
							<div class="font01">구비서류 : 신용카드지급영수증&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매</div>
				          
				</div>
				</div>
				<!-- //poptab2 end -->
				<!-- //poptab3 start -->
				<div id="medicalPrint" class="poptabUnder poptab3 Lnodisplay">
				<div class="printCenter">
				  <div class="fontTitle">의료비지급명세서</div>
				        <!--개인정보 테이블 시작-->
				        <table id="userTB2" class="printTB printbd">
				        <colgroup>
							<col width="70"/>
							<col width="240"/>
							<col width="90"/>
							<col width="240"/>
						</colgroup>
				          <tr>
				            <th>성명</th>
				          	<td name="ename"></td>
				            <th>주민등록번호</th>
				            <td name="e_regno" format="resNo"></td>
				          </tr>
				          <tr>
				            <th>주소</th>
				            <td colspan="3" name="e_stras" addValue="e_locat" addformat="blank"></td>
				          </tr>
				        </table>
				        <!--개인정보 테이블 끝-->
				     
				      <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> <%=targetYear%> 년도 의료비 지급내역</div>
				        <!--특별공제의료비 테이블 시작-->
				        <table id="mediTB" class="printTB printbd">
					        <colgroup>
								<col width="20"/>
								<col width="30"/>
								<col width="30"/>
								<col width="60"/>
								<col width=""/>
								<col width="80"/>
								<col width="170"/>
								<col width="35"/>
								<col width="35"/>
								<col width="47"/>
								<col width="60"/>
								<col width="30"/>
							</colgroup>
				            <tr>
				              <th rowspan="2">No.</th>
				              <th rowspan="2">구분</th>
				              <th rowspan="2">건수</th>
				              <th rowspan="2">지급금액</th>
				              <th rowspan="2">의료비<br>내용</th>
				              <th rowspan="2">지급처<br>(상호)</th>
				              <th rowspan="2">의료증빙유형</th>
				              <th rowspan="2">안경<br>콘택트</th>
				              <th rowspan="2">난임<br>시술비</th>
				              <th colspan="3">대상자</th>
				            </tr>
				            <tr>
				            	<th>관계</th>
				            	<th>성명</th>
				            	<th>장애<BR>경로</th>
				            </tr>
				            <tr>
				            	<td name="autoNumbering" class="txtcenter"></td>
				            	<td name="GUBUN" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="CA_CNT" format="currency" class="txtright"></td>
				            	<td name="CA_BETRG" format="currency" class="txtright"></td>
				            	<td name="CONTENT"></td>
				            	<td name="BIZ_NAME"></td>
				            	<td name="METYP_NAME"></td>
				            	<td name="GLASS_CHK" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="DIFPG_CHK" format="replace" code="code" codeNm="value" class="txtcenter"></td>
				            	<td name="SUBTY" format="replace" code="code" codeNm="value"  class="txtcenter"></td>
				            	<td name="F_ENAME" class="txtcenter"></td>
				            	<td name="PR_OO" class="txtcenter"></td>
				            </tr>
				          </table>
				        <!--특별공제의료비 테이블 끝-->
				      
				        <br>
				          <div class="font01">
				                 소득세법 제 52조 및 소득세법 시행령 제113조 제1항의 규정에 의하여 의료비를 공제 받고자
				            <br>
				            의료비지급명세서를 제출합니다.</div>
				            <div class="font01" align="right">
				            	<%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;일
				            	<br>
				            	제출자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b id="signName2"></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 서명 또는 인 )
				            </div>
				            
				            <!--div class="font01" align="center">귀하</div-->
				          
				            <div class="font01">구비서류 : 의료비지급영수증&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매</div>
				         
				</div>
				
				</div>
				<!-- //poptab3 end -->
				
				<!-- //poptab4 start -->
				<div id="donationPrintTab" class="poptabUnder poptab4 Lnodisplay">
				<div class="printCenter">
				  <div class="fontTitle">기부금명세서</div>
				  
				        <!--개인정보 테이블 시작-->
				        <table id="userTB3" class="printTB printbd">
				        <colgroup>
							<col width="70"/>
							<col width="240"/>
							<col width="90"/>
							<col width="240"/>
						</colgroup>
				          <tr>
				            <th>성명</th>
				          	<td name="ename"></td>
				            <th>주민등록번호</th>
				            <td name="e_regno" format="resNo"></td>
				          </tr>
				          <tr>
				            <th>주소</th>
				            <td colspan="3" name="e_stras" addValue="e_locat" addformat="blank"></td>
				          </tr>
				        </table>
				        <!--개인정보 테이블 끝-->
				      
				      <div class="font01"><img src="/web-resource/images/ico/ico_o.gif"> <%=targetYear%> 년도 기부금 지급내역</div>    
				    
				        <!--특별공제기부금 테이블 시작-->
				
				        <table id="donationTB" class="printTB printbd">
					        <colgroup>
								<col width="20"/>
								<col width="80"/>
								<col width="18"/>
								<col width="30"/>
								<col width="45"/>
								<col width=""/>
								<col width="65"/>
								<col width="75"/>
								<col width="50"/>
								<col width="90"/>
								<col width="60"/>
								<% if(prev_YN.equals("Y")){ %>
								<col width="30"/>
								<col width="60"/>
								<%} %>
							</colgroup>
				            <tr>
				              <th rowspan="2">No.</th>
				              <th rowspan="2">기부금유형</th>
				              <th rowspan="2">코드</th>
				              <th rowspan="2">구분</th>
				              <th rowspan="2">기부<br>년월</th>
				              <th rowspan="2">기부금<br>내용</th>
				              <th colspan="2">기부처</th>
				              <th colspan="2">기부자</th>
				              <th rowspan="2">금액</th>
				              <% if(prev_YN.equals("Y")){ %>
				              <th colspan="2">이월공제</th>
				              <%} %>
				            </tr>
				            <tr>
				            	<th>상호<br>(법인명)</th>
				            	<th>사업자번호</th>
				            	<th>성명</th>
				            	<th>주민등록번호</th>
				            	<% if(prev_YN.equals("Y")){ %>
				            	<th>년도</th>
				            	<th>전년까지<br>공제액</th>
				            	<%} %>
				            </tr>
				            <tr>
				            	<td name="autoNumbering" class="txtcenter"></td>
				            	<td name="DONA_NAME"></td>
				            	<td name="DONA_CODE" class="txtcenter"></td>
				            	<td name="GUBUN" format="replace" code="code" codeNm="value"  class="txtcenter"></td>
				            	<td name="DONA_YYMM" format="yearMonth" class="txtcenter"></td>
				            	<td name="DONA_DESC"></td>
				            	<td name="DONA_COMP"></td>
				            	<td name="DONA_NUMB" format="bizNo" class="txtcenter"></td>
				            	<td name="F_ENAME" class="txtcenter"></td>
				            	<td name="F_REGNO" format="resNo" class="txtcenter"></td>
				            	<td name="DONA_AMNT" format="emptyCur" class="txtright"></td>
				            	<% if(prev_YN.equals("Y")){ %>
				            	<td name="DONA_CRVYR" format="year" class="txtcenter"></td>
				            	<td name="DONA_DEDPR" format="emptyCur" class="txtright"></td>
				            	<%} %>
				            </tr>
				          </table>
				        <!--특별공제기부금 테이블 끝-->
				        
				        <br>
				          <div class="font01">
				                 소득세법 제 52조 및 소득세법 시행령 제113조 제1항의 규정에 의하여 기부금을 공제 받고자
				            <br>
				            기부금명세서를 제출합니다.</div>
				            <div class="font01" align="right">
				            	<%= DataUtil.getCurrentDate().substring(0, 4) %>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(4, 6) %>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%= DataUtil.getCurrentDate().substring(6, 8) %>&nbsp;일
				            	<br>
				            	제출자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b id="signName3"></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( 서명 또는 인 )
				            </div>
				            
				            <!--div class="font01" align="center">귀하</div-->
				          
				            <div class="font01">구비서류 : 기부금영수증&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;매</div>
				     		
				</div>
				</div>
				<!-- //poptab4 end -->
				</div>
				<!-- //스크롤 end -->
				<div class="buttonArea buttonPrint">
					<ul class="btn_crud">
						<li><a class="darken" href="#" id="printPopBtn" onclick="printPopPage();"><span>프린트</span></a></li>								
					</ul>
				</div>
			</div>
	</div>
</div>
<!-- //popup: 소득공제신고서발행  end -->

<script type="text/javascript">
var o_flag = "";//연말정산 확정여부
var E_HOLD = "";//세대주여부
var E_CHG = "";//인적공제변동여부
var E_CHECK = "";//세대주여부 필수여부
var H_SAVE = ""; //세대주 지정여부
var paramArr;//저장 데이터셋
var prev_YN = "<%=prev_YN%>";
var chgData = false; //데이터 변경여부

	$(document).ready(function(){
		//첫화면 불러오기(기본정보:personTab)
		getFirstPages();
		
		//기본정보(personTab)
		$("#personTab").click(function(){getTaxAdjustPerson();});
		$("#personCancelBtn").click(function(){getTaxAdjustPerson();});	
		
		//PDF업로드(pdfTab)
		$("#pdfTab").click(function(){getTaxAdjustPdf();});	
		$("#resetBtn").click(function(){pdfReset();});	
		
		//소득공제내역입력(taxAdjustTab) 첫화면 불러오기(보험료:insureTab)
		$("#taxAdjustTab").click(function(){ getTaxAdjust();});
		
		//보험료(insureTab)
		$("#insureTab").click(function(){getTaxAdjustInsure();});
		$("#insureCancelBtn").click(function(){getTaxAdjustInsure();});
		
		//의료비(medicalTab)
		$("#medicalTab").click(function(){getTaxAdjustMedical();});
		$("#medicalCancelBtn").click(function(){getTaxAdjustMedical();});
		
		//교육비(educationTab)
		$("#educationTab").click(function(){getTaxAdjustEducation();});
		$("#educationCancelBtn").click(function(){getTaxAdjustEducation();});
		
		//4대보험(fourInsTab)
		$("#fourInsTab").click(function(){getTaxAdjustFourIns();});
		
		//기부금(donationTab)
		$("#donationTab").click(function(){getTaxAdjustDonation();});
		$("#donationCancelBtn").click(function(){getTaxAdjustDonation();});
		
		//연금/저축공제(pensionTab)
		$("#pensionTab").click(function(){getTaxAdjustPension();});
		$("#pensionCancelBtn").click(function(){getTaxAdjustPension();});
		
		//주택자금상환(houseLoanTab)
		$("#houseLoanTab").click(function(){getTaxAdjustHouseLoan();});
		$("#houseLoanCancelBtn").click(function(){getTaxAdjustHouseLoan();});	
		
		//신용카드(creditCardTab)
		$("#creditCardTab").click(function(){getTaxAdjustCreditCard();});
		$("#creditCardCancelBtn").click(function(){getTaxAdjustCreditCard();});		
		
		//월세공제(monthlyRentTab)
		$("#monthlyRentTab").click(function(){getTaxAdjustMonthlyRent();});
		$("#monthlyRentCancelBtn").click(function(){getTaxAdjustMonthlyRent();});
		
		//기타/세액공제(etcTaxTab)
		$("#etcTaxTab").click(function(){getTaxAdjustEtcTax();});
		$("#etcTaxCancelBtn").click(function(){getTaxAdjustEtcTax();});
		
		//전근무지(preWorkTab)
		$("#preWorkTab").click(function(){getTaxAdjustPreWork();});
		$("#preWorkCancelBtn").click(function(){getTaxAdjustPreWork();});
		
		//신청현황(familyTab)
		$("#familyTab").click(function(){getTaxAdjustFamily();});
		
		//연말정산내역조회(detailTab)
		$("#detailTab").click(function(){getTaxAdjustDetail();});
		
		//소득공제신고서발행(taxPrintBtn)
		$("#taxPrintBtn").click(function(){if(!chkHouseHold()) return false;getTaxAdjustPrint();});
		$("#closeTaxPrintBtn").click(function(){setTaxPrintBtn();});
		$("#printPopBtn").click(function(){
			printPopPage();
		});
	});
	
	//첫화면 불러오기
	var getFirstPages = function(){
		getTaxAdjustPerson(false, true);
	};
	
	
	var getTaxAdjust = function(){
		//데이터변경사항체크
		if(!chgDataCheck()) return false;
		
		//의료비, 카드비 코멘트
		$("#companySupp").html("");
		if(o_flag != "X") {
			$("#companySupp").html("<img src=\"/web-resource/images/ico/ico_twinkle.gif\" class=\"txtPointimg\"/>회사 지원분은 연말정산 미반영 상태입니다. 국세청 자료로 입력 또는 업로드 해주시고, 차액 발생시 「연말정산삭제」란의 \"√\"를 해제해 주시면 자동반영됩니다.");
		}
		
		chgData = false;
		switchTabs($("#taxAdjustTab"), 'taxAdjustTabDiv');
		$("#insureTab").trigger("click");
		
	};
	
	//화면공통정보(확정여부, 인적공제, 세대주, 연말정산기간)
	var setBaseInfo = function(tabid, first){
		$("#companySupp").hide();
		//데이터변경사항체크
		if(!chgDataCheck(first)) return false;
		
		chgData = false;
		
		//탭바꾸기
		if(tabid=="personTab"||tabid=="pdfTab"||tabid=="familyTab"||tabid=="detailTab"){
			switchTabs($("#"+tabid), tabid+'Div');
		} else {
			switchShuttle($("#"+tabid), tabid+'Div');
		}
		
		jQuery.ajax({
			type : 'get',
			url : '/taxAdjust/getBaseInfo.json',
			cache : false,
			dataType : 'json',
			data : {"targetYear" : "<%=targetYear%>"},
			async :false,
			success : function(response) {
    			if(response.success){
    				o_flag = response.o_flag;
    				//o_flag = "X";
    				E_HOLD = response.E_HOLD;
    				E_CHG = response.E_CHG;
    				E_CHECK = response.E_CHECK;
    				H_SAVE = response.H_SAVE;
    				setTaxAdjustInfo();
    			}else{
    				alert("조회시 오류가 발생하였습니다. " + response.message);
    			}
    		}
		});
		
		return true;
	};
	
	//연말정산 입력 조정
	var setTaxAdjustInfo = function(){		
		$("[name='taxAdjustBtnDiv']").show();
		$(".tableComment").show();
		$("[name='P_CHG']").prop("checked",false);
		$("[name='PFSTID']").prop("checked",false);
		
		if(o_flag == "X") {
			$("[name='taxAdjustBtnDiv']").hide();
			$(".tableComment").hide();
		}
		if(E_CHG == "X") $("[name='P_CHG']").prop("checked",true);		
		if(E_HOLD == "X") $("[name='PFSTID']").prop("checked",true);
		
		$("[name='PFSTID']").prop("disabled",true);
		$("#PFSTID_Y").prop("disabled",true);
		$("#PFSTID_N").prop("disabled",true);
		
		if(o_flag != "X" && H_SAVE!="X"){
			//$("#firstSpan").show();
			//$("#pfstidSpan").hide();
			$("#PFSTID_Y").prop("checked",false);
			$("#PFSTID_N").prop("checked",false);
		} else {
			if(E_HOLD == "X") {
				$("#PFSTID_Y").prop("checked",true);
			} else {
				$("#PFSTID_N").prop("checked",true);
			}
			//$("#firstSpan").hide();
			//$("#pfstidSpan").show();
		}
		
	};
	
	//이름에 맞는 관계 찾아오기
	var getSubty = function(args, pePersonArr){
		//이름에 맞는 관계 찾아오기
    	var KDSVH = "";
    	var REGNO = "";
    	var HNDID = "";
    	for(var i=0; i<pePersonArr.length;i++){
    		if(pePersonArr[i].ENAME == args.item.F_ENAME){
    			KDSVH = pePersonArr[i].KDSVH;
    			REGNO = pePersonArr[i].REGNO;
    			HNDID = pePersonArr[i].HNDID;
    			break;
    		}
    	}
    	
    	if(KDSVH=="" || REGNO=="") {
    		alert("이름을 다시 선택하세요.");
    		return false;
    	}
    	
    	args.item.SUBTY = KDSVH;
    	args.item.F_REGNO = REGNO;
    	args.item.OBST = HNDID;
    	return true;
	};
	
	
	//데이터 변경체크
	var chgDataCheck = function(first){
		if(chgData) {
			if(confirm("현재 화면에서 변경된 데이터가 존재합니다.\n계속 진행하시겠습니까?")) return true;
			return false;
		}
		
		if(!chkHouseHold(first)) return false;
		
		return true;
	}
	
	//세대주체크여부 검사
	var chkHouseHold = function(first){
		if(!first && o_flag!="X"&& H_SAVE!="X" && $("#personTab").hasClass('selected')){
			jQuery.ajax({
				type : 'get',
				url : '/taxAdjust/getHouseHoldSaveYn.json',
				cache : false,
				dataType : 'json',
				data : {"targetYear" : "<%=targetYear%>"},
				async :false,
				success : function(response) {
	    			if(response.success){
	    				H_SAVE = response.H_SAVE;
	    			}else{
	    				alert("조회시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
			
			if(H_SAVE!="X"){
				alert("세대주 여부에 반드시 체크해 주셔야 합니다.\n세대주 여부를 확인하시고 세대주나 세대원 중\n해당 항목에 체크하고 저장해 주세요.");
				return false;
			}
		}
		
		return true;
	}
	
	//그리드 수정상태 체크
    var chkModify = function(gridId) {
    	//그리드 입력항목 체크
		var insChk = false;
		$.each($("#"+gridId+" .jsgrid-insert-row").find("input, select"), function(i, ins){
    		if($(ins).val()!="" && $(ins).val()!="on") {
    			//입력항목에 값을 넣으면 저장여부 체크
    			insChk = true;
    			return false;
    		}
    	});
    	
		if(insChk){
			if(!confirm("추가 항목이 반영되지 않았습니다.\n추가 항목은 [추가] 버튼을 클릭 후 반영됩니다.\n계속 진행하시겠습니까?")){
				return false;
			}
    	}
		
		if($("#"+gridId+" .jsgrid-edit-row").length>0) {
    		alert("항목 수정 상태에서 저장하실 수 없습니다.\n수정하신 항목의 [확인] 이나 [취소] 버튼을 클릭하세요.");
    		return false;
    	}
    	return true;
    };
    
	//의료비사업자번호 명칭 조회
	var getBizName = function(item) {
		var rtn = false;

		if(item.BIZNO!="" && numberOnly(item.BIZNO).length==10) {
			jQuery.ajax({
				type : 'get',
				url : '/taxAdjust/getBizName.json',
				cache : false,
				dataType : 'json',
				data : {bizNo : item.BIZNO},
				async :false,
				success : function(response) {
	    			if(response.success){
	    				if(response.BizName==""){
	    					//alert("사업자번호를 다시 입력하세요.");
	    					if(item.BIZ_NAME==""){
	    						alert("상호를 입력하세요.");
	    					} else {
	    						rtn = true;
	    					}
	    				} else {
	    					item.BIZ_NAME = response.BizName;
	    					rtn = true;
	    				}
	    			}else{
	    				alert("실패!");
	    			}
	    		}
			});
		} else {
			alert("사업자번호는 필수 입력항목입니다.");
		}
		
		return rtn;
		
	}
	
	//금액체크
	var checkBETRG = function(BETRG){
		//금액체크
    	if(!checkNum(BETRG)){
    		alert("금액에는 숫자만 입력하세요.");
    		return false;
    	}
		
		return true;
	};
	
	//나이계산
	var getAgeByRegNo = function(F_REGNO){
		var age = 0;
		if(F_REGNO==""){return age;}		
		var birthYear  = F_REGNO.substr(0, 2);		
		if( F_REGNO.charAt(6) == '1' || F_REGNO.charAt(6) == '2' ||
				F_REGNO.charAt(6) == '5' || F_REGNO.charAt(6) == '6' ){
	        birthYear = "19" + birthYear;
	    } else {
	        birthYear = "20" + birthYear;
	    }
		age = Number('<%=targetYear%>') - Number(birthYear);
		return age;
	};

	//그리드필드설정(DATE)
	var DateField = function(config) {
	    jsGrid.Field.call(this, config);
	};
	
	DateField.prototype = new jsGrid.Field({
	    itemTemplate: function(value) {
	        if(value!="0000.00.00"){
	    		return value;
	        } else {
	        	return "";
	        }
	        //new Date(value).format('yyyy.MM.dd');
	    },
	
	    insertTemplate: function(value) {
	    	return this._insertPicker = $("<input type=\"text\" readonly>").datepicker();
	    },
	
	    editTemplate: function(value) {
	    	var val = "";
	    	if(value) val = new Date(value);
	    	return this._editPicker = $("<input type=\"text\" readonly>").datepicker().val(value);
	    },
	
	    insertValue: function() {
	    	var val = this._insertPicker.datepicker("getDate");
	    	if(val!=null){
	        	return val.format('yyyy.MM.dd');
	    	}
	    },
	
	    editValue: function() {
	        var val = this._editPicker.datepicker("getDate");
	    	if(val!=null){
	        	return val.format('yyyy.MM.dd');
	    	}
	    }
	});
	
	jsGrid.fields.dateField = jsGrid.DateField = DateField;
	
	//그리드필드설정(MONTH)
	var YearMonthField = function(config) {
        jsGrid.Field.call(this, config);
    };
 
    YearMonthField.prototype = new jsGrid.Field({
        itemTemplate: function(value) {
           var val = numberOnly(value);
           return new Date(val.substring(0,4), val.substring(4,7), -1).format('yyyy.MM');
        },
        insertTemplate: function(value) {
            return this._insertPicker = $("<input type=\"text\" readonly>").monthpicker({year:<%=targetYear%>});
        },
 
        editTemplate: function(value) {
            return this._editPicker = $("<input type=\"text\" readonly>").monthpicker({year:<%=targetYear%>}).val(value);
        },
 
        insertValue: function() {
        	var val = this._insertPicker.monthpicker("getDate");
        	if(val!=null){
            	return this._insertPicker.monthpicker("getDate").format('yyyy.MM');
        	}
        },
 
        editValue: function() {
        	var val = this._editPicker.monthpicker("getDate");
        	if(val!=null){
            	return this._editPicker.monthpicker("getDate").format('yyyy.MM');
        	}
        }
    });
 
    jsGrid.fields.yearMonth = YearMonthField;
    
    //연말정산삭제여부체크
    var setOmitFlag = function(obj, item) {
    	chgData=true;
    	
    	if($(obj).is(":checked")){
    		item.OMIT_FLAG = "X";
    	} else {
    		item.OMIT_FLAG = "";
    	}
    };
    
    //Grid insert 시 구분자값 셋팅
	var setGubun = function(args){
		args.item.GUBUN = "2";
    	args.item.OMIT_FLAG = "";
	};
	
	//personTab : 기본정보 ------------------------------------------------------ START
	var getTaxAdjustPerson = function(msgPop, first) {
		if(!setBaseInfo("personTab", first)) return;
		$setPersonGrid();
		if(o_flag != "X") {
			$("#PFSTID_Y").prop("disabled", false);
			$("#PFSTID_N").prop("disabled", false);
			if(!msgPop){
				var msg ="※ 연간 소득금액의 합계액이 100 만원 이하\n";
				msg += "① 해당소득 : 양도/근로/퇴직/사업/연금/이자배당/기타 소득\n";
				msg += "② 근로소득이자 : 총급여의 합계액 2,000 만원\n";//@2015 연말정산 MMA
				msg += "③ 근로소득만 있는 경우 총급여액 500 만원 이하\n";//@2015 연말정산 MMA
				msg += "☞ ’<%=targetYear%>년의 연간 소득유무 여부를 반드시 확인하여 주시기 바랍니다.";
				alert(msg);
			}
		}
		
		$("#personSaveBtn").off('click');
		$("#personSaveBtn").on('click', function(){personSave();});
	};
	
	var personItemChanging = function(args) {
		//체크되었을때 위탁아동여부 체크
		var chk = args.item.FSTID;
		if(args.item.SUBTY != "S"){
			if(args.item.SUBTY == "8" || args.item.STEXT=="위탁아동"){
				if(chk) {
					args.item.BETRG01 = "150000";
        			args.item.FSTID = "X";
				} else {
					args.item.BETRG01 = "";
        			args.item.FSTID = "";
				}
			} else {
				if(chk) {
					alert("위탁아동에 체크하실 수 없습니다.");
					args.item.FSTID = "";
        			return false;
				} else {
					if(Number(args.item.BETRG03)>0 && args.item.HNDCD == ""){
						//장애코드필수
						alert("장애코드를 입력하세요");
						return false;
					}
				}
				args.item.FSTID = "";
			}
		}
		console.log(args.item.BETRG03);
		
		//자녀일경우
		if(args.item.SUBTY == "2"){
			var year = args.item.REGNO.substring(0,2);
			var sex = args.item.REGNO.substring(6,7);
			//2017년생 이상만
			if(Number(year) > 16){
				if(Number(sex) > 2){
					if(args.item.KDBSL == ""){
						alert("자녀구분을 입력하세요");
						return false;             					
					}
				}else{
					if(args.item.KDBSL != ""){
						alert("자녀구분을 입력하실 수 없습니다.");
						return false;           					
					}
				}
			}else{
				if(args.item.KDBSL != ""){
					alert("자녀구분을 입력하실 수 없습니다.");
					return false;           					
				}
				
			}
		}else{
			if(args.item.KDBSL != ""){
				alert("자녀구분을 입력하실 수 없습니다.");
				return false;           					
			}
		}
		
		if(Number(args.item.BETRG03) == 0 && args.item.HNDCD != ""){
			alert("장애인코드를 입력하실 수 없습니다.");
			return false;
		}
		
		return true;
	};
	
	var setSUMBETRG01 = function(args) {
		var sum = 0;
    	$.each(args.grid.data, function(i, item){
    		if(item.SUBTY!="S"){
    			sum += Number(item.BETRG01);
    		} else {
    			item.BETRG01 = sum;
    		}
    	});
	};
	
	//인적정보 그리드
	$setPersonGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		var type_vt = fnPushArr([{code:"1",name:"장애인복지법에 따른 장애인"},{code:"2",name:"상이자 및 이와 유사한 자로서 근로능력이 없는 자"},
		 		                {code:"3",name:"그 밖에 항시 치료를 요하는 중증환자"}],"code", "name");
		
		var KDBSL_vt = fnPushArr([{code:"01",name:"첫째"},{code:"02",name:"둘째"},
             {code:"03",name:"셋째이상"}],"code", "name");
		
		$("#personGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            editing:ctrl,
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustPerson.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success)
   							d.resolve(response.storeData);
   		    			else
   		    				alert("조회시 오류가 발생하였습니다. " + response.message);
   					});
   					return d.promise();
   				}
   			},
			rowClick: function(args) {},
			onItemUpdating: function(args) {if(!personItemChanging(args)) args.cancel = true;},
            onItemUpdated: function(args) {setSUMBETRG01(args);chgData=true;},
   			headerRowRenderer: function() {
   				var arr = new Array(new Array(3, 9,"추가공제"));
   				return setGridHeader(this, arr);
   			},
            fields: [
                
                {title:"관계", name: "STEXT", align: "center", width: "6%" },
                {title:"성명", name: "ENAME", align: "center", width: "6%" },
                {title:"주민등록번호", name: "REGNO", align: "center", width: "13%", 
                	itemTemplate: function(value) {return addResBar(value);}
                },
                {title:"기본공제", name: "BETRG01", align: "right", width: "7%",
                	itemTemplate: function(value) {if(value!="0") return Math.floor(value).format();}
                },
                {title:"경로우대", name: "BETRG02", align: "right", width: "7%",
                	itemTemplate: function(value) {if(value!="0") return Math.floor(value).format();}
                },
                {title:"장애자", name: "BETRG03", align: "right", width: "7%" ,
                	itemTemplate: function(value) {if(value!="0") return Math.floor(value).format();}
                },
                {title:"장애인코드", name: "HNDCD",type: "select", align: "left", width: "20%", 
                	type:"select", items: type_vt, valueField: "code", textField: "name"
                },
                {title:"부녀자",name: "BETRG04", align: "right", width: "7%" ,
                	itemTemplate: function(value) {if(value!="0") return Math.floor(value).format();}
                },
                {title:"한부모",name: "BETRG07", align: "right", width: "7%" ,
                	itemTemplate: function(value) {if(value!="0") return Math.floor(value).format();}
                },
                {title: "위탁<br>아동", name: "FSTID", align: "center", width: "4%", type: "checkbox", sorting: false, 
                	itemTemplate: function(_, item) {
                		if(item.SUBTY != "S"){
	                		if(item.FSTID != "X") { 		
	                			return this._createCheckbox().prop({checked:false, disabled:true});
	                		} else {
	                			return this._createCheckbox().prop({checked:true, disabled:true});
	                		}
                		}
                	}
                },
                {title:"자녀구분", name: "KDBSL",type: "select", align: "left", width: "7%",
                	type:"select", items: KDBSL_vt, valueField: "code", textField: "name"
                },
                { type: "control", name: "control", editButton: true, modeSwitchButton: false, deleteButton:false, width: "8%", visible: ctrl,
                	itemTemplate: function(_, item) {
                		if(item.SUBTY != "S" && ((item.SUBTY == "8" && item.STEXT=="위탁아동") || item.BETRG03 > 0 )){
                			return this._createEditButton(item);
                		}
                		//자녀일경우
                		if(item.SUBTY == "2"){
                			var year = item.REGNO.substring(0,2);
                			var sex = item.REGNO.substring(6,7);
                			//2017년생 이상만
                			if(Number(year) > 16){
                				if(Number(sex) > 2){
                					return this._createEditButton(item);                					
                				}
                			}
                			
                		}
                	}
                },
                { name: "SUBTY", type: "text", visible: false }
            ]
        });					
    };
    
	var personSave = function() {
		paramArr = null;
		if(!chkModify("personGrid")) return;
		if(!personCheck()) return;
		
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#personSaveBtn").off('click');

			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/savePerson.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");
	    				getTaxAdjustPerson(true);
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var personCheck = function() {
		//var fstidChk = $("#PSN_FSTID").prop("checked");
		//if(o_flag != "X" && H_SAVE!="X"){
			if(!$("#PFSTID_Y").prop("checked")&&!$("#PFSTID_N").prop("checked")){
				alert("세대주 여부에 반드시 체크해 주셔야 합니다.\n세대주 여부를 확인하시고 세대주나 세대원 중\n해당 항목에 체크하고 저장해 주세요.");
				return false;
			}
			var fstidChk = 	$("#PFSTID_Y").prop("checked");
		//}
		
		if(E_CHECK=="X" && !fstidChk){
			alert("주택자금 관련공제는 세대주이어야 합니다.\n(단, 주택자금 저당차입금 이자상환액은 반드시 세대주가 아니여도 됨)\n다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
	        return false;
		}
		
		paramArr = $("#personForm").serializeArray();
		$("#personGrid").jsGrid("serialize", paramArr);
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		paramArr.push({name:"PFSTID", value:fstidChk?"X":""});
		return true;
	};
	
	//personTab : 기본정보 ------------------------------------------------------ END
	
	//pdfTab : PDF업로드 ------------------------------------------------------- START
	var getTaxAdjustPdf = function() {
		pdfReset();
		if(!setBaseInfo("pdfTab")) return;
		if(o_flag != "X") {
			$("#PDF_FSTID").prop("disabled", false);
		}
	}	
	
	var pdfReset = function() {
		var htm = $("#smu03").html();
		$("#smu03").html("");
		$("#smu03").html(htm);
		$("#SAPMSG").html("");
		$("#uploadBtn").off('click');
		$("#uploadBtn").on('click', function(){pdfUpload();});
	};
	
	var pdfUpload = function() {
		var movie = document.getElementById('multi_upload');
		if(movie.GetVariable("totalSize") == 0){
			alert("[파일선택] 버튼을 클릭하시고 업로드할 파일을 선택하세요.");
			return;
		} else {
			if(confirm("저장 하시겠습니까?")){
				$("#pdfTabDiv").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
				callSwfUpload('pdfForm');
				$("#uploadBtn").off('click');
			}
		}
	};
	
	var pdfTransXml = function(pdfUpErrMsg) {
		if(pdfUpErrMsg!="") {
			$("#pdfTabDiv").loader('hide');
			return false;
		}
		
		paramArr = $("#pdfForm").serializeArray();
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/pdfTransXml.json',
			cache : false,
			dataType : 'json',
			data : paramArr,
			async :false,
			success : function(response) {
    			if(response.success){
    				alert(response.msg);
    				$("#SAPMSG").html(response.result);
    			}else{
    				alert(response.msg);
    			}
    		}
		});
		
		$("#pdfTabDiv").loader('hide');
	};
	
	//pdfTab : PDF업로드 ------------------------------------------------------- END
	
	//insureTab : 보험료 ------------------------------------------------------- START
	var getTaxAdjustInsure = function() {
		if(!setBaseInfo("insureTab")) return;
		$("#insureSaveBtn").off('click');
		$("#insureSaveBtn").on('click', function(){insureSave();});
		$setInsureGrid();
	};
	
	var insureItemChanging = function(args, pePersonArr) {
		//금액체크
    	if(!checkBETRG(args.item.BETRG)) return false;
    	
		//이름에 맞는 관계 찾아오기
    	if(!getSubty(args, pePersonArr)) return false;            	
    	
    	//장애인체크
    	if(args.item.OBST!="X"&& args.item.E_GUBUN=="4"){
    		alert("장애인보험료는 장애 대상자만 선택 가능합니다");
    		return false;
    	}
    	
    	var chk = args.item.CHNTS;
    	
    	if(args.item.CHNTS) { 
    		args.item.CHNTS = "X";
    	} else {
    		args.item.CHNTS = "";
    	}
    	return true;
	
	};
	
	
	
	//화면 로드시 조회를 막기 위해 처리
	$setInsureGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		var familyRelation
		var pePersonArr;
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getFamilyRelation.json',
			cache : false,
			dataType : 'json',
			data : {targetYear : "<%=targetYear%>", I_GUBUN : "1"},
			async :false,
			success : function(response) {
    			if(response.success){
    				familyRelation = fnPushArr(response.familyRelation, "code", "value");
    				pePersonArr = fnPushArr(response.pePerson_vt, "ENAME", "ENAME");
    			}
    		}
		});
		
		var type_vt = fnPushArr([{code:"3",name:"보장성보험료"},
		                {code:"4",name:"장애인보험료"}],"code", "name");
		
        $("#insureGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            inserting: ctrl,
            editing: ctrl,
            rowClick: function(args) {},
            onItemDeleted: function(args) { setPdfDelete(args.item);},
            onItemInserting: function(args) { if(!insureItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemInserted : function(args) {setGubun(args);chgData=true;},
            onItemUpdating: function(args) { if(!insureItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            onItemDeleted : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustInsure.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.card_vt);
   						} else {
   							alert("실패");
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
            fields: [
                {title: "관계", name: "SUBTY", align: "center", width: "10%",inserting:false, editing: false,
                	type:"select", items: familyRelation, valueField: "code", textField: "value", readOnly:true	
                },
                {title: "성명", name: "F_ENAME",  align: "center", width: "10%",
                	type:"select", items: pePersonArr, valueField: "ENAME", textField: "ENAME", validate: "required"
                },
                {title: "주민등록번호", name: "F_REGNO", align: "center", width: "15%", 
                	itemTemplate: function(value) {return addResBar(value);}
                },
                {title: "구분", name: "E_GUBUN", align: "center", width: "17%",
                	type:"select", items: type_vt, valueField: "code", textField: "name", validate: "required"
                },
                {title: "금액", name: "BETRG", type: "text", align: "right", width: "10%" , validate: ["required",{validator:"maxLength", param:[9]},{validator:"min", param:[1]}],
                	itemTemplate: function(value) {return value.format();}
                },
                {title: "국세청자료", name: "CHNTS", align: "center", width: "10%", type: "checkbox"},
                {title: "PDF", name: "GUBUN", align: "center", width: "10%", type: "checkbox", editing: false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "9") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {title: "연말정산삭제", name: "OMIT_FLAG", align: "center", width: "10%", type: "checkbox", inserting:false, editing: false,
                	itemTemplate: function(_, item) {
               			if(item.OMIT_FLAG!="X"){
               				if(item.GUBUN == 9) return this._createCheckbox().prop({checked:false, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
                		} else {
                			if(item.GUBUN == 9) return this._createCheckbox().prop({checked:true, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
                		}
                	},
                	editTemplate: function(_, item) {}
                },
                {type: "control", name: "control", editButton: true, modeSwitchButton: false,  width: "8%", visible:ctrl,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN != "9"){
                			var $result = $([]);
                			$result = $result.add(this._createEditButton(item)).add(this._createDeleteButton(item));
                			return $result;
                		}
                	}
                }
            ]
        });					
    };
    
    var insureSave = function() {
		paramArr = null;
		if(!chkModify("insureGrid")) return;
		if(!insureCheck()) return;
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#insureSaveBtn").off('click');

			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/saveInsure.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");
	    				getTaxAdjustInsure();
	    				
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var insureCheck = function() {
		paramArr = $("#insureForm").serializeArray();
		$("#insureGrid").jsGrid("serialize", paramArr);
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		return true;
	}
	//tab3 : 보험료 ------------------------------------------------------- END
	
	//tab3 : 의료비 ------------------------------------------------------- START
	var getTaxAdjustMedical = function() {
		if(!setBaseInfo("medicalTab")) return;
		if(o_flag!="X") $("#companySupp").show();
		$("#medicalSaveBtn").off('click');
		$("#medicalSaveBtn").on('click', function(){medicalSave();});
		$setMedicalGrid();
	};
	
	
    
    function chkMedi(item){
		if(item.CONTENT==""){
			alert("의료비내용은 필수 항목입니다.");
			return false;
		}
		
		if(item.CA_CNT==""){
			alert("건수는 필수 항목입니다.");
			return false;
		}
		
		if(!checkNum(item.CA_CNT)){
    		alert("건수는 숫자만 입력하세요.");
    		return false;
    	} else {
    		if(Number(item.CA_CNT)<0){
    			alert("건수를 입력하세요.");
    			return false;
    		}
    	}
		
		return true;
	};
	
	var medicalItemChanging = function(args, pePersonArr){
		//금액체크
    	if(!checkBETRG(args.item.CA_BETRG)) return false;
    	//이름에 맞는 관계 찾아오기
    	if(!getSubty(args, pePersonArr)) return false;
    	
    	//건수체크
    	if(args.item.METYP!="1"){
    		//사업자찾아오기
    		if(!getBizName(args.item)) return false;
    		if(!chkMedi(args.item)) return false;
    	}
    	//@2015연말정산 안경콘택트, 난임시술비 중복 불가
    	if(args.item.GLASS_CHK && args.item.DIFPG_CHK){
    		alert("안경콘택트, 난임시술비 중복 불가합니다.");
    		return false;
    	}
    	
    	args.item.CHNTS = "";
    	args.item.OLDD = "";
    	
    	if(args.item.METYP=="1"){
    		args.item.CHNTS = "X";
    		args.item.BIZNO = "";
    		args.item.BIZ_NAME = "";
    		args.item.CONTENT = "";
    		args.item.CA_CNT = "";
		}
    	
    	//나이체크
    	var age = getAgeByRegNo(args.item.F_REGNO);
    	if(age>=65) args.item.OLDD = "X";
    	if(args.item.GLASS_CHK) {
    		args.item.GLASS_CHK = "X";
    	} else {
    		args.item.GLASS_CHK = "";
    	}
    	
    	if(args.item.DIFPG_CHK) {
    		args.item.DIFPG_CHK = "X";
    	} else {
    		args.item.DIFPG_CHK = "";
    	}
    	
    	return true;
	};
	
	//화면 로드시 조회를 막기 위해 처리
	$setMedicalGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		var familyRelation;
		var pePersonArr;
		var type_vt;
		
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getFamilyRelation.json',
			cache : false,
			dataType : 'json',
			data : {targetYear : "<%=targetYear%>", I_GUBUN : "2"},
			async :false,
			success : function(response) {
    			if(response.success){
    				familyRelation = fnPushArr(response.familyRelation, "code", "value");
    				pePersonArr = fnPushArr(response.pePerson_vt, "ENAME", "ENAME");
    				type_vt = fnPushArr(response.type_vt, "code", "value");
    			}
    		}
		});
		
        $("#medicalGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            inserting: ctrl,
            editing: ctrl,
            rowClick: function(args) {},
            onItemInserting: function(args) {if(!medicalItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemInserted : function(args) {setGubun(args);chgData=true;},
            onItemUpdating: function(args) {if(!medicalItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            onItemDeleted : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustMedical.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.medi_vt);
   						}
   					});
   					return d.promise();
   				}
   			},
   			headerRowRenderer: function() {
   				var arr = new Array(new Array(6, 9,"요양기관"));
   				return setGridHeader(this, arr);
   			},
            fields: [
                { title: "관계", name: "SUBTY", align: "center", width: "5%",inserting:false, editing: false,
                	type:"select", items: familyRelation, valueField: "code", textField: "value", readOnly:true	
                },
                { title: "성명", name: "F_ENAME",  align: "center", width: "5%",
                	type:"select", items: pePersonArr, valueField: "ENAME", textField: "ENAME", validate: "required"
                },
                { title: "주민등록번호", name: "F_REGNO", align: "center", width: "11%", 
                	itemTemplate: function(value) {return addResBar(value);}
                },
                { title: "의료비내용", name: "CONTENT", type: "text", align: "left", width: "7%", validate: [{validator:"maxLength", param:[20]}]},
                { title: "의료증빙유형", name: "METYP", align: "left", width: "14%", validate: "required", 
                	type:"select", items: type_vt, valueField: "code", textField: "value"
                },
                {  title: "안경<br>콘택트", name: "GLASS_CHK", align: "center", width: "3%", type: "checkbox",
	                itemTemplate: function(value) {
	            		if(value != "X") { 		
	            			return this._createCheckbox().prop({checked:false, disabled:true});
	            		} else {
	            			return this._createCheckbox().prop({checked:true, disabled:true});
	            		}
	            	}
        		},
                {  title: "난임<br>시술비", name: "DIFPG_CHK", align: "center", width: "3%", type: "checkbox",
	                itemTemplate: function(value) {
	            		if(value != "X") { 		
	            			return this._createCheckbox().prop({checked:false, disabled:true});
	            		} else {
	            			return this._createCheckbox().prop({checked:true, disabled:true});
	            		}
	            	}
        		},
                { title: "사업자번호", name: "BIZNO", type: "text", align: "center", width: "9%", validate: [{validator:"maxLength", param:[10]}],
                	itemTemplate: function(value) {return (value);}
                },
                { title: "상호", name: "BIZ_NAME", type: "text", align: "left", width: "6%", validate: [{validator:"maxLength", param:[20]}]},
                { title: "건수", name: "CA_CNT", type: "text", align: "right", width: "4%", validate: [{validator:"maxLength", param:[5]}],
                	itemTemplate: function(value) {
                		if(value!=null) return value.format();
                	}
                },
                { title: "금액", name: "CA_BETRG", type: "text", align: "right", width: "7%" , validate: ["required",{validator:"maxLength", param:[9]},{validator:"min", param:[1]}],
                	itemTemplate: function(value) {return value.format();}
                },
                {  title: "만<br>65세<br>이상자", name: "OLDD", align: "center", width: "3%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "X") {
                			$rtn = this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			$rtn = this._createCheckbox().prop({checked:true, disabled:true});
                		}
                		return $rtn;
                	}
                },
                {  title: "장애자", name: "OBST", align: "center", width: "3%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "X") {
                			$rtn = this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			$rtn = this._createCheckbox().prop({checked:true, disabled:true});
                		}
                		return $rtn;
                	}
                },
                {  title: "국세청<br>자료", name: "CHNTS", align: "center", width: "3%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value == "X") {
                			$rtn = this._createCheckbox().prop({checked:true, disabled:true});
                		} else {
                			$rtn = this._createCheckbox().prop({checked:false, disabled:true});
                		}
                		return $rtn;
                	}
                },
                {  title: "PDF", name: "GUBUN", align: "center", width: "3%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "9") { 	
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {  title: "회사<br>지원분", name: "GUBUN", align: "center", width: "3%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "1") {
                			$rtn = this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			$rtn = this._createCheckbox().prop({checked:true, disabled:true});
                		}
                		return $rtn;
                	}
                },
                {  title: "연말<br>정산<br>삭제", name: "OMIT_FLAG", align: "center", width: "3%", type: "checkbox", sorting: false, editing: false, inserting:false,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN == "1" || item.GUBUN == "9") { 
                			if(item.OMIT_FLAG!="X"){
                				return this._createCheckbox().prop({checked:false, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		} else {
	                			return this._createCheckbox().prop({checked:true, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		}
                		}
                	},
                	editTemplate: function(_, item) {}
                },
                { type: "control", editButton: true, modeSwitchButton: false, width: "8%", visible:ctrl,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN != "1" && item.GUBUN != "9"){
                			var $result = $([]);
                			$result = $result.add(this._createEditButton(item)).add(this._createDeleteButton(item));
                			return $result;
                		}
                	}
                }
            ]
        });					
    };
    
    var medicalSave = function() {
		paramArr = null;
		if(!chkModify("medicalGrid")) return;
		if(!medicalCheck()) return;
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#medicalSaveBtn").off('click');
			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/saveMedical.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");
	    				getTaxAdjustMedical();
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var medicalCheck = function() {
		paramArr = $("#medicalForm").serializeArray();
		$("#medicalGrid").jsGrid("serialize", paramArr);
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		return true;
	}
	
	//tab3 : 의료비 ------------------------------------------------------- END
	
	//tab4 : 교육비 ------------------------------------------------------- START
	var getTaxAdjustEducation = function() {
		if(!setBaseInfo("educationTab")) return;
		if(o_flag!="X")$("#companySupp").show();
		$("#educationSaveBtn").off('click');
		$("#educationSaveBtn").on('click', function(){educationSave();});
		$setEducationGrid();
	};
	
	var educationItemChanging = function(args, pePersonArr){
		//금액체크
    	if(!checkBETRG(args.item.BETRG)) return false;
    	//이름에 맞는 관계 찾아오기
		if(!getSubty(args, pePersonArr)) return false;
    	
    	// 관계코드 인경우 금액 비활성처리(직계존속은 교육비 공제 안됨): 
		// 01-부, 02-모, 11-조부, 12-조모, 13-장인, 14-장모, 22-시부, 23-시모, 
		// 26-처조부, 27-처조모, 30-외조부, 31-외조모, 45-시조모, 46-시조부
    	var notValue = new Array("01","02","11","12","13","14","22","23","26","27","30","31","45","46");
		$.each(notValue, function(i, data){
			if(args.item.SUBTY == data && args.item.OBST!="X"){
				alert("직계존속은 공제대상이 아닙니다.");
				return false;
			}
		});
    	
		//장애인교육비체크
		if(args.item.OBST!="X"){
			if(args.item.ACT_CHECK) {
				alert("장애인교육비는 장애인 경우만 가능합니다.");
				return false;
			}
			
			if(args.item.FASAR == "I1"){
				alert("장애인 특수교육은 장애인 경우만 가능합니다.");
				return false;
			}
		}
		
		//교복체크
		if(args.item.EXSTY && args.item.FASAR!="D1" && args.item.FASAR!="E1"){
			alert("교복구입비 중학생, 고등학생인 경우만 가능합니다.");
			return false;
		}
		
		//대학원교육비
		if(args.item.SUBTY!="35" && args.item.FASAR=="H1"){
			alert("대학원 교육비 공제는 본인만 가능합니다.");
			return false;
		}
		
		
		if(args.item.EXSTY) {
			args.item.EXSTY = "X";
		} else {
			args.item.EXSTY = "";
		}
		
		if(args.item.EDUFT) {
			args.item.EDUFT = "X";
		} else {
			args.item.EDUFT = "";
		}
		
		if(args.item.LOAN) {
			args.item.LOAN = "X";
		} else {
			args.item.LOAN = "";
		}
		
		if(args.item.EXSTY != "" && args.item.EDUFT != ""){
			alert("교복교육비와 체험학습비 둘중 하나만 선택 가능합니다. ");
			return false;
		}
		
		if(args.item.ACT_CHECK) {
			args.item.ACT_CHECK = "X";
		} else {
			args.item.ACT_CHECK = "";
		}
		
		if(args.item.CHNTS) {
			args.item.CHNTS = "X";
		} else {
			args.item.CHNTS = "";
		}
		
		return true;
		
		
	};
	
	//화면 로드시 조회를 막기 위해 처리
	$setEducationGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		var familyRelation;
		var pePersonArr;
		var type_vt;
		
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getFamilyRelation.json',
			cache : false,
			dataType : 'json',
			data : {targetYear : "<%=targetYear%>", I_GUBUN : "3"},
			async :false,
			success : function(response) {
    			if(response.success){
    				familyRelation = fnPushArr(response.familyRelation, "code", "value");
    				pePersonArr = fnPushArr(response.pePerson_vt, "ENAME", "ENAME");
    				type_vt = fnPushArr(response.type_vt, "code", "value");
    			}else{
    				alert("실패");
    			}
    		}
		});
		
        $("#educationGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            inserting: ctrl,
            editing: ctrl,
            rowClick: function(args) {},
            onItemInserting: function(args) {if(!educationItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemInserted : function(args) {setGubun(args);chgData=true;},
            onItemUpdating: function(args) {if(!educationItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            onItemDeleted : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustEducation.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.edu_vt);
   						}
   					});
   					return d.promise();
   				}
   			},
            fields: [
                { title: "관계", name: "SUBTY", align: "center", width: "8%",inserting:false, editing: false,
                	type:"select", items: familyRelation, valueField: "code", textField: "value", readOnly:true	
                },
                { title: "성명", name: "F_ENAME",  align: "center", width: "8%", validate: "required", 
                	type:"select", items: pePersonArr, valueField: "ENAME", textField: "ENAME", validate: "required"
                },
                { title: "주민등록번호", name: "F_REGNO", align: "center", width: "12%", 
                	itemTemplate: function(value) {return addResBar(value);}
                },
                { title: "학력", name: "FASAR", align: "left", width: "14%", validate: "required", 
                	type:"select", items: type_vt, valueField: "code", textField: "value"
                },
                { title: "금액", name: "BETRG", type: "text", align: "right", width: "10%" , validate: ["required",{validator:"maxLength", param:[9]},{validator:"min", param:[1]}],
                	itemTemplate: function(value) {return value.format();}
                },
                {title: "교복<br>구입비", name: "EXSTY", align: "center", width: "6%", type: "checkbox",
	                itemTemplate: function(value) {
	            		if(value != "X") { 		
	            			return this._createCheckbox().prop({checked:false, disabled:true});
	            		} else {
	            			return this._createCheckbox().prop({checked:true, disabled:true});
	            		}
	            	}
        		},
        		 {title: "체험<br>학습비", name: "EDUFT", align: "center", width: "6%", type: "checkbox",
	                itemTemplate: function(value) {
	            		if(value != "X") { 		
	            			return this._createCheckbox().prop({checked:false, disabled:true});
	            		} else {
	            			return this._createCheckbox().prop({checked:true, disabled:true});
	            		}
	            	}
        		},
        		 {title: "본인<br>학자금<br>대출", name: "LOAN", align: "center", width: "6%", type: "checkbox",
	                itemTemplate: function(value) {
	            		if(value != "X") { 		
	            			return this._createCheckbox().prop({checked:false, disabled:true});
	            		} else {
	            			return this._createCheckbox().prop({checked:true, disabled:true});
	            		}
	            	}
        		},
                {title: "장애인<br>교육비", name: "ACT_CHECK", align: "center", width: "6%", type: "checkbox",
	                itemTemplate: function(value) {
	            		if(value != "X") { 		
	            			return this._createCheckbox().prop({checked:false, disabled:true});
	            		} else {
	            			return this._createCheckbox().prop({checked:true, disabled:true});
	            		}
	            	}
        		},
                {  title: "국세청<br>자료", name: "CHNTS", align: "center", width: "6%", type: "checkbox",
                	itemTemplate: function(value) {
                		if(value != "X") {
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {  title: "PDF", name: "GUBUN", align: "center", width: "6%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "9") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {title: "회사<br>지원분", name: "GUBUN", align: "center", width: "6%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "1") {
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {  title: "연말정산<br>삭제", name: "OMIT_FLAG", align: "center", width: "6%", type: "checkbox", sorting: false, editing: false, inserting:false,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN == "1" || item.GUBUN == "9") { 
                			if(item.OMIT_FLAG!="X"){
                				return this._createCheckbox().prop({checked:false, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		} else {
	                			return this._createCheckbox().prop({checked:true, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		}
                		}
                	},
                	editTemplate: function(_, item) {}
                },
                { type: "control", editButton: true, modeSwitchButton: false, width: "12%", visible:ctrl,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN != "1" && item.GUBUN != "9"){
                			var $result = $([]);
                			$result = $result.add(this._createEditButton(item)).add(this._createDeleteButton(item));
                			return $result;
                		}
                	}
                }
            ]
        });					
    };
	
    var educationSave = function() {
		paramArr = null;
		if(!chkModify("educationGrid")) return;
		if(!educationCheck()) return;		
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#educationSaveBtn").off('click');
			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/saveEducation.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");
	    				getTaxAdjustEducation();
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var educationCheck = function() {
		paramArr = $("#educationForm").serializeArray();
		$("#educationGrid").jsGrid("serialize", paramArr);
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		return true;
	}
	
	//tab4 : 교육비 ------------------------------------------------------- END
	
	//tab5 : 4대보험(단순조회) ------------------------------------------------------ START
	var getTaxAdjustFourIns = function() {
		if(!setBaseInfo("fourInsTab")) return;
		$setFourInsGrid();
		//20170110 전근무지 의료보험 조회되지 않게 막음 -전근무지주석
		/*****************************************************************
		if(prev_YN == 'Y') {
			//올해입사자만 전년도자료 보여줌
			
			$.ajax({
				type : "get",
				url : "/taxAdjust/getTaxAdjustNationalHNP.json",
				dataType : "json",
				data : {targetYear : '<%=targetYear%>'}
			}).done(function(response) {
				if(response.success){
					setTableText(response.natHealth, "preFourInsTB");
					setTableText(response.natPension, "preFourInsTB");
				} else {
					alert("조회시 오류가 발생하였습니다. " + response.message);
				}
	  				
			});
			
		}
		********************************************************************/
		
	};
	
	//화면 로드시 조회를 막기 위해 처리
	$setFourInsGrid = function() {
        $("#fourInsGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustFourIns.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.ins_vt);
   						} else {
   							alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
   			headerRowRenderer: function() {
   				var arr = new Array(new Array(0, 3,"자동반영분"));
   				return setGridHeader(this, arr);
   			},
            fields: [
                { title: "구분", name: "GUBN_TEXT", align: "left", width: "20%"},
                { title: "금액", name: "AUTO_BETRG", align: "right", width: "15%" ,
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "내용", name: "AUTO_TEXT", align: "left", width: "65%"}
            ]
        });					
    };
	//tab5 : 4대보험 ------------------------------------------------------ END
	
	//tab6 : 기부금 ------------------------------------------------------- START
	var getTaxAdjustDonation = function() {
		if(!setBaseInfo("donationTab")) return;
		$("#donationSaveBtn").off('click');
		$("#donationSaveBtn").on('click', function(){donationSave();});
		$setDonationGrid();
	};
	
	var donationItemChanging = function(args, pePersonArr) {
		if(args.item.DONA_YYMM==undefined){
			alert("기부년월은 필수입력값입니다.");
			return false;
		}
		//금액체크
    	if(!checkBETRG(args.item.DONA_AMNT)) return false;
    	//이름에 맞는 관계 찾아오기
		if(!getSubty(args, pePersonArr)) return false;
    	var donaCode = args.item.DONA_CODE;
    	var donaYear = args.item.DONA_YYMM.substring(0,4);
    	
    	//C20121213_34842 '31' 신탁기부금 '30' 특례기부금 은 이전년도 입력가능
    	if(donaCode != "30" && donaCode != "31"){
    		if(donaYear!="<%=targetYear%>"){
    			alert("해당 년도만 입력가능합니다!");
    			return false;
    		}
    	}
    	
    	if(donaCode != "20"){
    	//if(donaCode != "20" && donaCode != "42" ){
    		//사업자번호, 상호
    		if(args.item.DONA_NUMB==""||args.item.DONA_COMP==""){
    			alert("기부처는 필수입력값입니다.");
    			return false;
    		}
    		
    		if(!checkBusino(args.item.DONA_NUMB)) return false;
    		
    		var rtn = checkBusiName(numberOnly(args.item.DONA_NUMB));
    		if(rtn){
	    		if(rtn.eFlag == "Y"){
	    			alert("입력하신 해당 기부처는 이전에 기부금 부당공제 관련 기부처로 확인된 바 있으므로,\n기부금액 및 주무관청 등록여부를 다시 확인하여 주시기 바랍니다.");
	    			return false;
	    		}
    		}
    	} else {
    		args.item.DONA_NUMB = "";
    		//정치기부금 20  ,42 우리사주기부금 은 본인이 기부한것만 입력이 가능
    		var donaName = "정치기부금";
    		if(donaCode == "42") donaName = "우리사주기부금";
    		if(args.item.SUBTY!="35"){
    			alert(donaName+"은 본인이 기부한 것만 입력 가능합니다.");
    			return false;
    		}
    	}
    	
    	
    	//@2011 전월공제 가능년도 체크 
    	if(prev_YN == 'Y') {
    		if(args.item.DONA_CRVIN) {
    			args.item.DONA_CRVIN = "X";
    			args.item.DONA_CRVYR = donaYear;
    			
    			var rtn = chkDonaCrvyr(args.item.DONA_CODE, args.item.DONA_CRVYR);
    			if(rtn){
	    			if(rtn.code = "E") args.item.DONA_CRVYR = "";
	    			if(rtn.message != "") {
	    				args.item.DONA_CRVYR = "";
	    				alert(rtn.message);
	    				return false;
	    			}
    			}
    			if(!checkBETRG(args.item.DONA_DEDPR)) return false;
    			//금액체크
    			if(Number(args.item.DONA_DEDPR)>Number(args.item.DONA_AMNT)){
    				alert("전년까지 공제액은 금액을 초과해서 입력할 수 없습니다.");
    				return false;
    			}
    			
    		} else {
    			args.item.DONA_CRVIN = "";
    			args.item.DONA_CRVYR = "";
    			args.item.DONA_DEDPR = "";
    		}
    	} else {
    		args.item.DONA_CRVIN = "";
			args.item.DONA_CRVYR = "";
			args.item.DONA_DEDPR = "";
    	}
    	
    	args.item.CHNTS = "";
    	return true;
    	
	};
	
	var chkDonaCrvyr = function(DONA_CODE, DONA_CRVYR){
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/checkDonation.json',
			cache : false,
			dataType : 'json',
			data : {"targetYear" : "<%=targetYear%>", "DONA_CODE" : DONA_CODE, "DONA_CRVYR":DONA_CRVYR},
			async :false,
			success : function(response) {
    			if(response.success){
    				return response;
    			}
    		}
		});
	};
	
	//부당공제처여부 CSR ID:2013_9999 
	var checkBusiName = function(DONA_NUMB){
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/checkDonationBusiName.json',
			cache : false,
			dataType : 'json',
			data : {"DONA_NUMB" : DONA_NUMB},
			async :false,
			success : function(response) {
    			if(response.success){
    				return response;
    			}
    		}
		});
	}
	
	
	//화면 로드시 조회를 막기 위해 처리
	$setDonationGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		//전근무지 표시
		var preW = false;
		if(prev_YN == 'Y') preW = true;
		var familyRelation;
		var pePersonArr;
		var type_vt;
		
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getFamilyRelation.json',
			cache : false,
			dataType : 'json',
			data : {targetYear : "<%=targetYear%>", I_GUBUN : "5"},
			async :false,
			success : function(response) {
    			if(response.success){
    				familyRelation = fnPushArr(response.familyRelation, "code", "value");
    				pePersonArr = fnPushArr(response.pePerson_vt, "ENAME", "ENAME");
    				type_vt = fnPushArr(response.type_vt, "code", "value");
    			}else{
    				alert("실패");
    			}
    		}
		});
		
        $("#donationGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            inserting: ctrl,
            editing: ctrl,
            rowClick: function(args) {},
            onItemInserting: function(args) {if(!donationItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemInserted : function(args) {setGubun(args);chgData=true;},
            onItemUpdating: function(args) {if(!donationItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            onItemDeleted : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustDonation.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.don_vt);
   						} else {
   							alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
   			headerRowRenderer: function() {
 	   			var arr = new Array(new Array(-1, 3,"기부자"), new Array(5, 8,"기부처"));
 	   			return setGridHeader(this, arr);
   			},
            fields: [
                { title: "관계", name: "SUBTY", align: "center", width: "5%",inserting:false, editing: false,
                	type:"select", items: familyRelation, valueField: "code", textField: "value", readOnly:true	
                },
                { title: "성명", name: "F_ENAME",  align: "center", width: "6%",
                	type:"select", items: pePersonArr, valueField: "ENAME", textField: "ENAME", validate: "required"
                },
                { title: "주민등록번호", name: "F_REGNO", align: "center", width: "10%", 
                	itemTemplate: function(value) {return addResBar(value);}
                },
                { title: "기부금유형", name: "DONA_CODE", align: "left", width: "8%", validate: "required", 
                	type:"select", items: type_vt, valueField: "code", textField: "value"
                },
                { title: "기부년월", name: "DONA_YYMM", type: "yearMonth", align:"center", width: "6%", validate: "required"},
                { title: "기부금내용", name: "DONA_DESC", type: "text", align: "left", width: "9%", validate: ["required",{validator:"maxLength", param:[20]}]},
                { title: "사업자번호", name: "DONA_NUMB", type: "text", align: "center", width: "9%", validate: [{validator:"maxLength", param:[10]}],
                	itemTemplate: function(value) {if($.trim(value)!="") return (value);}
        		},
                { title: "상호(법인명)", name: "DONA_COMP", type: "text", align: "left", width: "8%", validate: ["required",{validator:"maxLength", param:[20]}]},
                { title: "금액", name: "DONA_AMNT", type: "text", align: "right", width: "6%" , validate: ["required",{validator:"maxLength", param:[9]},{validator:"min", param:[1]}],
                	itemTemplate: function(value) {return value.format();}
                },
                {  title: "이월<BR>공제", name: "DONA_CRVIN", align: "center", width: "5%", type: "checkbox", sorting: false,  visible:preW,
                	itemTemplate: function(value) {
                		if(value != "X") {
                			$rtn = this._createCheckbox().prop({checked:false, disabled:true}).val("");
                		} else {
                			$rtn = this._createCheckbox().prop({checked:true, disabled:true}).val("X");
                		}
                		return $rtn;
                	}
                },
                { title: "이월<BR>공제<BR>년도", name: "DONA_CRVYR", align: "center", width: "4%", visible:preW,
                	itemTemplate: function(value) {
                		if(value=="0000") value=="";
                		return value;
                	}
                },
                { title: "전년까지<BR>공제액", name: "DONA_DEDPR", type: "text", align: "right", width: "6%", visible:preW,
                	itemTemplate: function(value) {return Math.floor(value).format();}
                },
                {  title: "PDF", name: "GUBUN", align: "center", width: "4%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "9") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {  title: "연말<br>정산<br>삭제", name: "OMIT_FLAG", align: "center", width: "4%", type: "checkbox", sorting: false, editing: false, inserting:false,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN == "9") { 
                			if(item.OMIT_FLAG!="X"){
                				return this._createCheckbox().prop({checked:false, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		} else {
	                			return this._createCheckbox().prop({checked:true, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		}
                		}
                	},
                	editTemplate: function(_, item) {}
                },
                { type: "control", editButton: true, modeSwitchButton: false, width: "8%", visible:ctrl,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN != "1" && item.GUBUN != "9"){
                			var $result = $([]);
                			$result = $result.add(this._createEditButton(item)).add(this._createDeleteButton(item));
                			return $result;
                		}
                	}
                },
                { name: "CHNTS", visible:false}
            ]
        });					
    };
	
    var donationSave = function() {
		paramArr = null;
		if(!chkModify("donationGrid")) return;
		if(!donationCheck()) return;
		
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#donationSaveBtn").off('click');

			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/saveDonation.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");
	    				getTaxAdjustDonation();
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var donationCheck = function() {
		paramArr = $("#donationForm").serializeArray();
		$("#donationGrid").jsGrid("serialize", paramArr);
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		return true;
	}
	//tab6 : 기부금 ------------------------------------------------------- END
	
	//tab7 : 연금저축 ------------------------------------------------------ START
	var getTaxAdjustPension = function() {
		if(!setBaseInfo("pensionTab")) return;
		$("#pensionSaveBtn").off('click');
		$("#pensionSaveBtn").on('click', function(){pensionSave();});
		if(o_flag!="X") $("#IN_FSTID").prop("disabled", false);
		$setPensionGrid();
	};
	
	var getHouseHoleRequired = function(subty, pnsty){
		var rtn = "";
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getHouseHoleRequired.json',
			cache : false,
			dataType : 'json',
			data : {targetYear : '<%=targetYear%>', SUBTY : subty, PNSTY:pnsty},
			async :false,
			success : function(response) {
    			if(response.success){
    				rtn =  response.REQ_H;
    			}
    		}
		});
		
		return rtn;
	}	
	
	var pensionItemChanging = function(args) {
		//유형체크
		if (args.item.SUBTY != "98"){
			if(args.item.PNSTY == ""){
				alert("유형은 필수 항목입니다.");
				return false;
			}
		}
		//금액체크
    	if(!checkBETRG(args.item.NAM01)) return false;
		
		//@2015 연말정산 추가, 구분 값이 청약저축(E3)일 경우, 가입일 필수
		if (args.item.SUBTY == "E3"){
			if(args.item.RCBEG == "" || args.item.RCBEG == "0000.00.00" || args.item.RCBEG == undefined){
				alert("가입일은 필수 항목입니다.");
				return false;
			}
		} else {
			args.item.RCBEG = "";
		}
		
		var PREIN_FLAG="";//종(전)근무지필수 체크
		var FINCO_FLAG="";//금융기관코드필수 체크
		var ACCNO_FLAG="";//계좌번호필수 체크
		
		$.each(getPNSTY(args.item.SUBTY), function(i, data){
			if(args.item.PNSTY == data.GOJE_CODE){
				PREIN_FLAG = data.PREIN_FLAG;
				FINCO_FLAG = data.FINCO_FLAG;
				ACCNO_FLAG = data.ACCNO_FLAG;
			}
		});
		
		if(PREIN_FLAG=="X" && args.item.PREIN){
			//종(전)근무지
			args.item.PREIN = "X";
		} else {
			args.item.PREIN = "";
		}
		
		if(FINCO_FLAG=="X" && args.item.FINCO==""){
			alert("금융기관은 필수 항목입니다.");
			return false;
		}
		
		if(ACCNO_FLAG=="X" && args.item.ACCNO==""){
			alert("계좌번호는 필수 항목입니다.");
			return false;
		}
		
		var houseHoldReq = getHouseHoleRequired(args.item.SUBTY, args.item.PNSTY);
		if(houseHoldReq=="X"){
			if(!$("#IN_FSTID").prop("checked")){
				alert("이 항목은 세대주이어야 합니다.\n세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
				return false;
			}
		}
		
		return true;
	};
	
	
	//연금저축은 구분이 존재하지 않고 PDF_FLAG 만 존재
	var setPdfFlag = function(args){
		args.item.PDF_FLAG = "";
    	args.item.OMIT_FLAG = "";
	};
	//화면 로드시 조회를 막기 위해 처리
	$setPensionGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		var codeArr1;
		var codeArr2;
		var type_vt;
		
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getPensionCode.json',
			cache : false,
			dataType : 'json',
			data : {"targetYear" : "<%=targetYear%>", "code" : "1"},
			async :false,
			success : function(response) {
    			if(response.success){
    				codeArr1 = fnPushArr(response.code1, "code", "value");
    				codeArr2 = fnPushArr(response.code2, "code", "value");
    			}else{
    				alert("실패");
    			}
    		}
		});
		
        $("#pensionGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            inserting: ctrl,
            editing: ctrl,
            rowClick: function(args) {},
            onItemInserting: function(args) {if(!pensionItemChanging(args)) args.cancel = true;},
            onItemInserted : function(args) {setPdfFlag(args);chgData=true;},
            onItemUpdating: function(args) {if(!pensionItemChanging(args)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            onItemDeleted : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustPension.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.pension_vt);
   						} else {
   							alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
            fields: [
                { title: "구분", name: "SUBTY", align: "left", width: "16%", chgCombo:true, mCombo:true, chgFunc:"setPNSTY", validate: "required",
                	type:"select", items: codeArr1, valueField: "code", textField: "value"
                },
                { title: "유형", name: "PNSTY",  align: "left", width: "16%", chgCombo:true, cCombo:true, chgFunc:"getPNSTY",
                	type:"select", items: {}, valueField: "GOJE_CODE", textField: "GOJE_TEXT"
                },
                { title: "금융기관", name: "FINCO", align: "left", width: "18%",
                	type:"select", items: codeArr2, valueField: "code", textField: "value"
                },
                { title: "가입일", name: "RCBEG", type: "dateField", align: "center", width: "8%"},
                { title: "증권보험/계좌번호", name: "ACCNO", type: "text", align: "left", width: "13%", validate: [{validator:"maxLength", param:[20]}]},
                { title: "금액", name: "NAM01", type: "text", align: "right", width: "11%", validate: ["required",{validator:"maxLength", param:[9]},{validator:"min", param:[1]}],
                	itemTemplate: function(value) {if(value!="") return value.format();}
                },
                {  title: "종(전)<br>근무지", name: "PREIN", align: "center", width: "5%", type: "checkbox",
                	itemTemplate: function(value) {
                		if(value != "X") {
                			$rtn = this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			$rtn = this._createCheckbox().prop({checked:true, disabled:true});
                		}
                		return $rtn;
                	}
                },
                {  title: "PDF", name: "PDF_FLAG", align: "center", width: "4%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "X") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {  title: "연말<br>정산<br>삭제", name: "OMIT_FLAG", align: "center", width: "4%", type: "checkbox", sorting: false, editing: false, inserting:false,
                	itemTemplate: function(_, item) {
                		if(item.PDF_FLAG == "X") { 
                			if(item.OMIT_FLAG!="X"){
                				return this._createCheckbox().prop({checked:false, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		} else {
	                			return this._createCheckbox().prop({checked:true, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		}
                		}
                	},
                	editTemplate: function(_, item) {}
                },
                { type: "control", editButton: true, modeSwitchButton: false, width: "8%", visible:ctrl,
                	itemTemplate: function(_, item) {
                		if(item.PDF_FLAG != "X"){
                			var $result = $([]);
                			$result = $result.add(this._createEditButton(item)).add(this._createDeleteButton(item));
                			return $result;
                		}
                	}
                }
            ]
        });					
    };
    
    var getPNSTY = function(val) {    	
    	var dataArr = {"targetYear" : "<%=targetYear%>", "SUBTY": val, "code":"2"};
    	var rtn;
    	jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getPensionGubn.json',
			cache : false,
			dataType : 'json',
			data : dataArr,
			async : false,
			success : function(response) {
    			if(response.success){
    				//$("#pensionGrid").jsGrid("fieldOption", "PNSTY", "items", response.storeData);
    				//fieldOption 사용하여 items 변경 시 Grid refresh 됨
    				rtn = fnPushArr(response.storeData,"GOJE_CODE","GOJE_TEXT");
    			}
    		}
		});
    	return rtn;
    };
    
    var setPNSTY = function(obj) {
    	
    	var val = $(obj).val();
    	var chgSelect = $(obj).parent().parent().find("select").eq(1);
    	chgSelect.empty();
    	
    	if(val=="") return;
    	
    	var arr = getPNSTY(val);		
    	if(arr==null) return;

    	$.each(arr, function(i){
			chgSelect.append($("<option>").val(arr[i].GOJE_CODE).text(arr[i].GOJE_TEXT));
		});
    };
    
    var pensionSave = function() {
		paramArr = null;
		if(!chkModify("pensionGrid")) return;
		if(!pensionCheck()) return;
		
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#pensionSaveBtn").off('click');
			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/savePension.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");	    				
	    				getTaxAdjustPension();	    				
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var pensionCheck = function() {
		if(E_CHECK=="X" && !$("#IN_FSTID").prop("checked")){
			alert("주택자금 관련공제는 세대주이어야 합니다.\n(단, 주택자금 저당차입금 이자상환액은 반드시 세대주가 아니여도 됨)\n다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
	        return false;
		}
		
		paramArr = $("#pensionForm").serializeArray();
		$("#pensionGrid").jsGrid("serialize", paramArr);		
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});		
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		
		
		return true;
	}
	//tab7 : 연금저축 ------------------------------------------------------ END
	
	//tab8 : 주택자금상환 ---------------------------------------------------- START
	var getTaxAdjustHouseLoan = function() {
		if(!setBaseInfo("houseLoanTab")) return;
		$("#houseLoanSaveBtn").off('click');
		$("#houseLoanSaveBtn").on('click', function(){houseLoanSave();});
		$setHouseLoanGrid();
	};
	var houseLoanItemChanging = function(args) {
		//2. 구분이 E6인 경우에는 주민등록번호/최초차입일/최종상환예정일/금액/이자율 /이자 입력 가능(필수입력 사항으로 처리 - 이자 제외)
		//3. 구분이 96인 경우에는 금액 입력 가능(필수입력 사항으로 처리)
		//4. 구분이 E8인 경우에는 최초차입일/최종상환예정일/금액/고정금리(체크박스)/비거치(체크박스)  입력 가능(필수입력 사항으로 처리 - 체크박스 제외)
		if(!checkBETRG(args.item.NAM01)) return false;
		
		if(args.item.SUBTY=="E8") {
			if ( $.trim(args.item.RCBEG) == ""  ) {
				alert("최초차입일은 필수 항목입니다.");
				return false;
			}
			if ( $.trim(args.item.RCEND) == ""  ) {
				alert("최종상환예정일은 필수 항목입니다.");
				return false;
			}
			
			if ( $.trim(args.item.LNPRD) == ""  ) {
				alert("대출기간은 필수 항목입니다.");
				return false;
			}
			
			//금액체크
	    	if(!checkNum(args.item.LNPRD)){
	    		alert("대출기간에는 숫자만 입력하세요.");
	    		return false;
	    	} else {
	    		if(Number(args.item.LNPRD)<=0){
	    			alert("대출기간을 입력하세요.");
	    			return false;
	    		}
	    	}
			
			//날짜 확인
			if(numberOnly(args.item.RCEND)-numberOnly(args.item.RCBEG)<0){
				alert("최종상환예정일은 최초차입일 이후여야 합니다.");
				return false;
			}
		}

		if(args.item.SUBTY != "96"){
			if(args.item.FIXRT){
				args.item.FIXRT = "X";
			} else {
				args.item.FIXRT = "";
			}
			
			if(args.item.NODEF){
				args.item.NODEF = "X";
			} else {
				args.item.NODEF = "";
			}
		} else {
			args.item.FIXRT = "";
			args.item.NODEF = "";
		}
		
		
		return true;
	};
	//화면 로드시 조회를 막기 위해 처리
	$setHouseLoanGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		var type_vt;
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getHouseLoanType.json',
			cache : false,
			dataType : 'json',
			data : {targetYear : "<%=targetYear%>", code : "3"},
			async :false,
			success : function(response) {
    			if(response.success){
    				type_vt = fnPushArr(response.storeData, "code", "value");
    			}else{
    				alert("실패");
    			}
    		}
		});
        $("#houseLoanGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            inserting: ctrl,
            editing: ctrl,
            rowClick: function(args) {},
            onItemInserting: function(args) {if(!houseLoanItemChanging(args)) args.cancel = true;},
            onItemInserted : function(args) {setGubun(args);chgData=true;},
            onItemUpdating: function(args) {if(!houseLoanItemChanging(args)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            onItemDeleted : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustHouseLoan.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.ret_vt);
   						} else {
   							alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
            fields: [
                { title: "구분", name: "SUBTY", align: "left", width: "22%", validate: "required",
                	type:"select", items: type_vt, valueField: "code", textField: "value"
                },
                { title: "최초차입일", name: "RCBEG", type: "dateField", align: "center", width: "10%"},
                { title: "최종상환예정일", name: "RCEND", type: "dateField", align: "center", width: "10%"},
                { title: "금액", name: "NAM01", type: "text", align: "right", width: "10%", validate: ["required",{validator:"maxLength", param:[9]},{validator:"min", param:[1]}],
                	itemTemplate: function(value) {if(value!="")return value.format();}
                },
                { title: "대출기간<br>(년)", name: "LNPRD", type: "text", align: "right", width: "8%", validate: [{validator:"maxLength", param:[3]}],
                	itemTemplate: function(value) {if(value!="")return Number(value).format();}
                },
                {  title: "고정금리", name: "FIXRT", align: "center", width: "5%", type: "checkbox",
	                itemTemplate: function(value) {
	            		if(value != "X") { 		
	            			return this._createCheckbox().prop({checked:false, disabled:true});
	            		} else {
	            			return this._createCheckbox().prop({checked:true, disabled:true});
	            		}
	            	}
        		},
                {  title: "비거치", name: "NODEF", align: "center", width: "5%", type: "checkbox",
	                itemTemplate: function(value) {
	            		if(value != "X") { 		
	            			return this._createCheckbox().prop({checked:false, disabled:true});
	            		} else {
	            			return this._createCheckbox().prop({checked:true, disabled:true});
	            		}
	            	}
        		},
                {  title: "PDF", name: "GUBUN", align: "center", width: "4%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "9") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {  title: "연말<br>정산<br>삭제", name: "OMIT_FLAG", align: "center", width: "4%", type: "checkbox", sorting: false, editing: false, inserting:false,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN == "1" || item.GUBUN == "9") { 
                			if(item.OMIT_FLAG!="X"){
                				return this._createCheckbox().prop({checked:false, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		} else {
	                			return this._createCheckbox().prop({checked:true, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		}
                		}
                	},
                	editTemplate: function(_, item) {}
                },
                { type: "control", editButton: true, modeSwitchButton: false, width: "8%", visible:ctrl,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN != "1" && item.GUBUN != "9"){
                			var $result = $([]);
                			$result = $result.add(this._createEditButton(item)).add(this._createDeleteButton(item));
                			return $result;
                		}
                	}
                }
            ]
        });					
    };
    
    var houseLoanSave = function() {
		paramArr = null;
		if(!chkModify("houseLoanGrid")) return;
		if(!houseLoanCheck()) return;
		
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#houseLoanSaveBtn").off('click');
			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/saveHouseLoan.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");	    				
	    				getTaxAdjustHouseLoan();	    				
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var houseLoanCheck = function() {
		paramArr = $("#houseLoanForm").serializeArray();
		$("#houseLoanGrid").jsGrid("serialize", paramArr);		
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		return true;
	}
	//tab8 : 주택자금상환 ---------------------------------------------------- END
	
	//tab9 : 신용카드 ------------------------------------------------------- START
	var getTaxAdjustCreditCard = function() {
		if(!setBaseInfo("creditCardTab")) return;
		if(o_flag!="X"){
			//alert("신용카드/직불카드/현금영수증은 반드시 \"일반\" 과 \"전통시장\" 과 \n\"대중교통\"으로 구분하여 입력해주시기 바랍니다.\n\n영수증상에 전통시장 및 대중교통으로 표시되는 금액은 반드시 \n\"전통시장\" 또는 \"대중교통\" 체크박스에 \"V\"체크 해주시기 바랍니다.");
		}
		$("#creditCardSaveBtn").off('click');
		$("#creditCardSaveBtn").on('click', function(){creditCardSave();});
		$setCreditCardGrid();
	};
	
	var creditCardItemChanging = function(args, pePersonArr) {
		//이름에 맞는 관계 찾아오기
		if(!getSubty(args, pePersonArr)) return false;
		
		//추가공제율사용분:6 --> 본인만 입력가능
		var EXPRD = args.item.EXPRD;
		if(EXPRD == "6"){
			if(args.item.SUBTY!="35"){
				alert("추가공제율사용분은 본인만 입력 가능합니다.");
				return false;
			}
			//전통시장, 대중교통 둘 다 체크
			args.item.TRDMK = true;
			args.item.CCTRA = true;
		}
		
		// 2. 금액비활성화: 신용카드:1/현금영수증공제:2 인 경우에 형제자매인 경우 금액 입력 안되도록 비활성화
	    //관계코드 : 07-형(오빠), 08-제(남동생), 09-자(누나/언니), 10-매(여동생), 28-처형제, 29-처자매
	    var notValue = new Array("07","08","09","10","28","29");
	    var E_GUBUN = args.item.E_GUBUN;
	    
	    var chk = true;
		if(E_GUBUN=="1"||E_GUBUN=="2"||E_GUBUN=="5"||E_GUBUN=="6"){
			$.each(notValue, function(i, data){
				if(args.item.SUBTY == data){
					chk = false;
					if(args.item.BETRG!=""){
						alert("형제자매는 공제대상이 아닙니다.");
						return false;
					}
				
				}
			});
		}
		
		//금액체크
    	if(chk){
			if(!checkBETRG(args.item.BETRG)) return false;
    	}
    	
    	//CSR ID:C20140106_63914 전통시장과 대중교통중 한가지만 체크
    	if(EXPRD!="6" && args.item.TRDMK && args.item.CCTRA){
    		alert("전통시장과 대중교통중 한 가지만 체크하세요.");
    		return false;
    	}
    	var year1 = Number('<%=targetYear%>')-1;
    	var year2 = Number('<%=targetYear%>')-2;
    	//@2014 연말정산 사용기간의 경우 2013은 본인일 경우만 선택 가능함
    	if(args.item.SUBTY!="35" && (args.item.EXPRD=="1"||args.item.EXPRD=="4")){
    		alert(year2 + "년, " + year1 +"년도 신용카드 등은 본인만 입력가능합니다.");//@2015 연말정산
    		return false;
    	}
    	
    	if(args.item.CHNTS){
			args.item.CHNTS = "X";
		} else {
			args.item.CHNTS = "";
		}
		
		if(args.item.TRDMK){
			args.item.TRDMK = "X";
		} else {
			args.item.TRDMK = "";
		}
		
		if(args.item.CCTRA){
			args.item.CCTRA = "X";
		} else {
			args.item.CCTRA = "";
		}
		
		
		if(args.item.E_GUBUN == "2"){// 1. 현금영수증공제:2 인 경우 자동으로 체크되어 비활성화
			args.item.CHNTS = "X";
		} else if(args.item.E_GUBUN == "5"){//지로영수증
			args.item.CHNTS = "";
			args.item.TRDMK = "";
			args.item.CCTRA = "";
		}
		
		return true;
	};
	
	//화면 로드시 조회를 막기 위해 처리
	$setCreditCardGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		var familyRelation
		var pePersonArr;
		var exprdArr;
		
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getFamilyRelation.json',
			cache : false,
			dataType : 'json',
			data : {targetYear : "<%=targetYear%>", I_GUBUN : "4"},
			async :false,
			success : function(response) {
    			if(response.success){
    				familyRelation = fnPushArr(response.familyRelation, "code", "value");
    				pePersonArr = fnPushArr(response.pePerson_vt, "ENAME", "ENAME");
    				exprdArr = fnPushArr(response.type_vt, "code", "value");
    			}
    		}
		});
		
		var type_vt = fnPushArr([{code:"1",name:"신용카드"},{code:"2",name:"현금영수증"},{code:"6",name:"직불/선불카드"}],"code", "name");

        $("#creditCardGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            inserting: ctrl,
            editing: ctrl,
            rowClick: function(args) {},
            onItemInserting: function(args) {if(!creditCardItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemInserted : function(args) {setGubun(args);chgData=true;},
            onItemUpdating: function(args) {if(!creditCardItemChanging(args, pePersonArr)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            onItemDeleted : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustCreditCard.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.card_vt);
   						} else {
   							alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
            fields: [
                { title: "관계", name: "SUBTY", align: "center", width: "8%",inserting:false, editing: false,
                	type:"select", items: familyRelation, valueField: "code", textField: "value", readOnly:true	
                },
                { title: "성명", name: "F_ENAME",  align: "center", width: "8%",
                	type:"select", items: pePersonArr, valueField: "ENAME", textField: "ENAME", validate: "required"
                },
                { title: "주민등록번호", name: "F_REGNO", align: "center", width: "11%", 
                	itemTemplate: function(value) {return addResBar(value);}
                },
                { title: "구분", name: "E_GUBUN", align: "left", width: "11%", validate: "required",
                	type:"select", items: type_vt, valueField: "code", textField: "name"
                },
                { title: "공제대상액", name: "BETRG", type: "text", align: "right", width: "8%" , validate: ["required",{validator:"maxLength", param:[9]},{validator:"min", param:[1]}],
                	itemTemplate: function(value) {return Math.floor(value).format();}
                },
                {  title: "전통<br>시장", name: "TRDMK", align: "center", width: "5%", type: "checkbox", sorting: false,
                	itemTemplate: function(value) {
                		if(value != "X") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true}).val("");
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true}).val("X");
                		}
                	}
                },
                {  title: "대중<br>교통", name: "CCTRA", align: "center", width: "5%", type: "checkbox", sorting: false,
                	itemTemplate: function(value) {
                		if(value != "X") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true}).val("");
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true}).val("X");
                		}
                	}
                },
                 { title: "사용기간", name: "EXPRD", align: "left", width: "15%",
                	type:"hidden", items: exprdArr, valueField: "code", textField: "value" //validate: "required"
                }, 
                { title: "회사비용<br>정리금", name: "BETRG_B", align: "right", width: "8%" , 
                	itemTemplate: function(value) {return Math.floor(value).format();}
                },
                {  title: "국세청<br>자료", name: "CHNTS", align: "center", width: "5%", type: "checkbox", sorting: false,
                	itemTemplate: function(value) {
                		if(value != "X") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true}).val("");
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true}).val("X");
                		}
                	}
                },
                {  title: "PDF", name: "GUBUN", align: "center", width: "4%", type: "checkbox", sorting: false, editing: false, selecting :false, inserting:false,
                	itemTemplate: function(value) {
                		if(value != "9") { 		
                			return this._createCheckbox().prop({checked:false, disabled:true});
                		} else {
                			return this._createCheckbox().prop({checked:true, disabled:true});
                		}
                	}
                },
                {  title: "연말<br>정산<br>삭제", name: "OMIT_FLAG", align: "center", width: "4%", type: "checkbox", sorting: false, editing: false, inserting:false,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN == "9") { 
                			if(item.OMIT_FLAG!="X"){
                				return this._createCheckbox().prop({checked:false, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		} else {
	                			return this._createCheckbox().prop({checked:true, disabled:ctrl?false:true}).on("click", function(){setOmitFlag(this, item)});
	                		}
                		}
                	},
                	editTemplate: function(_, item) {}
                },
                { type: "control", editButton: true, modeSwitchButton: false, width: "8%", visible:ctrl,
                	itemTemplate: function(_, item) {
                		if(item.GUBUN != "1" && item.GUBUN != "9"){
                			var $result = $([]);
                			$result = $result.add(this._createEditButton(item)).add(this._createDeleteButton(item));
                			return $result;
                		}
                	}
                }
            ]
        });					
    };
    var creditCardSave = function() {
		paramArr = null;
		if(!chkModify("creditCardGrid")) return;
		if(!creditCardCheck()) return;		
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#creditCardSaveBtn").off('click');
			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/saveCreditCard.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");	    				
	    				getTaxAdjustCreditCard();	    				
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}	    			
	    		}
			});
		}
		
	};
	
	var creditCardCheck = function() {
		paramArr = $("#creditCardForm").serializeArray();
		var gridArray = $("#creditCardGrid").jsGrid("option", "data");
		var temp = 0;
		var temp1 = 0;
		var temp2 = 0;
		$.each(gridArray, function(i, data){
			if(data.SUBTY=="35" && data.OMIT_FLAG == ""){
				if(data.EXPRD == "1") temp += 1;//본인 이면서 전년도 사용액을 입력한 case
				if(data.EXPRD == "4") temp1 += 1;//본인 이면서 전전년도 사용액을 입력한 case
				if(data.EXPRD == "2" || data.EXPRD == "3") temp2 += 1;
			}
			for (var key in data) {
				if (data.hasOwnProperty(key)) {
					paramArr.push({name:key, value:data[key]});
				}
			}
		});
		
		//@2014 연말정산 값이 있으면서 본인 & 2013년도 항목이 없는 경우
		var year1 = Number('<%=targetYear%>')-1;
		var year2 = Number('<%=targetYear%>')-2;
		if(temp2>0 && (temp==0 || temp1==0)) {
			alert("본인 명의로 되어 있는 "+year1+"년, "+year2+"년 신용카드, 직불카드,\n현금영수증 사용분을 반드시 입력해 주시기 바랍니다.");//@2015 연말정산
	     	return false;
		}
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		return true;
	}
	//tab9 : 신용카드 ------------------------------------------------------- END
	//tab10 : 월세공제 ------------------------------------------------------ START
	var getTaxAdjustMonthlyRent = function() {
		if(!setBaseInfo("monthlyRentTab")) return;
		$("#monthlyRentSaveBtn").off('click');
		$("#monthlyRentSaveBtn").on('click', function(){monthlyRentSave();});
		$setMonthlyRentGrid();
		//if(o_flag!="X") $("#IN_FSTID").prop("disabled", false);		
	};
	
	var monthlyRentItemChanging = function(args) {
		//금액체크
    	if(!checkBETRG(args.item.NAM01)) return false;
    	
		//고시원이 아닐때만 체크
		if(args.item.HOUTY != "7"){
			if(numberOnly(args.item.FLRAR) <= 0){
				alert("주택계약 면적(m²)은 필수 항목 입니다.");
				return false;
			}
		}
		
		if($.trim(args.item.RCEND)==""||$.trim(args.item.RCBEG)==""){
			alert("계약일은 필수입력 값입니다.");
			return false;
		}
		
    	if(numberOnly(args.item.RCEND)-numberOnly(args.item.RCBEG)<0){
			alert("날짜 입력 오류입니다.");
			return false;
		}
    	
    	var RCBEGYear = args.item.RCBEG.substring(0,4);
        var RCENDYear = args.item.RCEND.substring(0,4);
        
        if (Number(RCBEGYear)>Number('<%=targetYear%>') ||  Number(RCENDYear) <Number('<%=targetYear%>')) { 
            alert("계약년도는 [<%=targetYear%>]년도가 포함되어야 합니다.");
            return false;
        }
        
        if(!checkMaxNum(args.item.FLRAR)) return false;
        
		return true;
	};
	

	//@2014 연말정산 소수점 체크 ###.## 으로 입력
	function checkMaxNum(_value) {

	    var _pattern = /^(\d{1,3}([.]\d{0,2})?)?$/;
	    var _rslt = "";

	    if (!_pattern.test(_value)&&_value!="") {

	      alert("주택계약면적은 1,000 이하의 숫자만 입력가능하며,\n소수점 둘째자리까지만 허용됩니다.");
				//event.srcElement 이벤트를 발생한 변수
	      return false;

	    }
	     return true;

	}
	
	//화면 로드시 조회를 막기 위해 처리
	$setMonthlyRentGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		var type_vt;
		
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getRentType.json',
			cache : false,
			dataType : 'json',
			async :false,
			success : function(response) {
    			if(response.success){
    				type_vt = fnPushArr(response.storeData, "code", "value");
    			}
    		}
		});

        $("#monthlyRentGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            inserting: ctrl,
            editing: ctrl,
            rowClick: function(args) {},
            onItemInserting: function(args) {if(!monthlyRentItemChanging(args)) args.cancel = true;},
            onItemInserted : function(args) {chgData=true;},
            onItemUpdating: function(args) {if(!monthlyRentItemChanging(args)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            onItemDeleted : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustMonthlyRent.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.ret_vt);
   						} else {
   							alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
            fields: [
                { title: "임대인성명", name: "LDNAM",  type:"text",  align: "center", width: "8%", validate: "required"},
                { title: "등록번호", name: "LDREG",  type:"text",  align: "left", width: "11%", validate: ["required", {validator:"maxLength", param:[13]}]},
                { title: "임대계약서 상 주소지", name: "ADDRE",  type:"text",  align: "left", width: "27%", validate:["required",{validator:"maxLength", param:[50]}]}, 
                { title: "주택유형", name: "HOUTY", align: "left", width: "10%", validate: "required",
                	type:"select", items: type_vt, valueField: "code", textField: "value"
                },
                { title: "주택계약<br>면적(m²)", name: "FLRAR",  type:"text",  align: "right", width: "6%", validate: [{validator:"maxLength", param:[6]}]},
                { title: "계약시작일", name: "RCBEG", type: "dateField", align: "center", width: "8%", validate: "required"},
                { title: "계약종료일", name: "RCEND", type: "dateField", align: "center", width: "8%", validate: "required"},
                { title: "금액", name: "NAM01", type: "text", align: "right", width: "10%" , validate: ["required",{validator:"maxLength", param:[9]},{validator:"min", param:[1]}],
                	itemTemplate: function(value) {return value.format();}
                },
                { type: "control", name: "control", editButton: true, modeSwitchButton: false, width: "8%", visible:ctrl}
            ]
        });					
    };
    
    var monthlyRentSave = function() {
		paramArr = null;
		if(!chkModify("monthlyRentGrid")) return;
		if(!monthlyRentCheck()) return;
		
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#monthlyRentSaveBtn").off('click');
			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/saveMonthlyRent.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");
	    				
	    				getTaxAdjustMonthlyRent();
	    				
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var monthlyRentCheck = function() {
		paramArr = $("#monthlyRentForm").serializeArray();
		$("#monthlyRentGrid").jsGrid("serialize", paramArr);
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		return true;
	}
	//tab10 : 월세공제 ------------------------------------------------------ END
	//tab11 : 기타세액 ------------------------------------------------------ START
	var getTaxAdjustEtcTax = function() {
		if(!setBaseInfo("etcTaxTab")) return;
		$("#etcTaxSaveBtn").off('click');
		$("#etcTaxSaveBtn").on('click', function(){etcTaxSave();});
		$setEtcTaxGrid();
	};
	
	var etcTaxItemChanging = function(args) {
		//금액체크
		if($.trim(args.item.AUTO_BETRG) != ""){
			if(Number(args.item.AUTO_BETRG)>0){
    			if(!checkBETRG(args.item.AUTO_BETRG)) return false;
			}
		}
		
		return true;
	}
	
	//화면 로드시 조회를 막기 위해 처리
	$setEtcTaxGrid = function() {
		var ctrl = true;
		if(o_flag=="X") ctrl = false;
		
		$("#etcTaxGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            editing: ctrl,
            rowClick: function(args) {},
            onItemUpdating: function(args) {if(!etcTaxItemChanging(args)) args.cancel = true;},
            onItemUpdated : function(args) {chgData=true;},
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustEtcTax.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.ret_vt);
   						} else {
   							alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
   			headerRowRenderer: function() {
   				var arr = new Array(new Array(1, 4,"자동반영분"));
   				return setGridHeader(this, arr);
   			},
            fields: [
                
                { title: "구분", name: "GUBN_TEXT",  align: "left", width: "25%"},
                { title: "개인추가분", name: "ADD_BETRG", type: "text", align: "right", width: "10%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "금액", name: "AUTO_BETRG", align: "right", width: "10%", validate: [{validator:"maxLength", param:[9]}],
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "내용", name: "AUTO_TEXT",  align: "left", width: "47%"},
                { type: "control", name: "control", editButton: true, modeSwitchButton: false, deleteButton:false, width: "8%", visible:ctrl},
                {name: "GUBN_CODE", visible:false},
                {name: "GOJE_CODE", visible:false},
                {name: "GOJE_FLAG", visible:false}
            ]
        });					
    };
    var etcTaxSave = function() {
		paramArr = null;
		if(!chkModify("etcTaxGrid")) return;
		if(!etcTaxCheck()) return;
		
		if(confirm("저장 하시겠습니까?")){
			chgData=false;
			$("#etcTaxSaveBtn").off('click');
			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/saveEtcTax.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");
	    				getTaxAdjustEtcTax();
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var etcTaxCheck = function() {
		paramArr = $("#etcTaxForm").serializeArray();
		$("#etcTaxGrid").jsGrid("serialize", paramArr);
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		return true;
	}
	//tab11 : 기타세액 ------------------------------------------------------ END
	//tab12 : 전근무지 ------------------------------------------------------ START
	var getTaxAdjustPreWork = function() {
		if(!setBaseInfo("preWorkTab")) return;		
		$("#preWorkForm").each(function() {this.reset();});
		$("#preWorkSaveBtn").off('click');
		$("#preWorkSaveBtn").on('click', function(){preWorkSave();});
		if(o_flag == "X"){
			setReadOnlyText($("#preWorkForm").find("input"), true);
			destroydatepicker("preWorkForm");
		}
		$setPreWork();
	};
	
	//화면 로드시 조회를 막기 위해 처리
	$setPreWork = function() {		
		$.ajax({
				type : "get",
				url : "/taxAdjust/getTaxAdjustPreWork.json",
				dataType : "json",
				data : {"targetYear" : '<%=targetYear%>'}
			}).done(function(response) {
				if(response.success){
					var preWork_vt= response.preWork_vt;
					var preWorkHeadNm_vt= response.preWorkHeadNm_vt;
					addTableTd(preWork_vt.length, preWorkHeadNm_vt.length,"preWorkTable",true);
					if(o_flag!="X"){
						setPeriodpicker("preWorkTable");
					}
					setTableText(preWork_vt, "preWorkForm");
					setTableText(preWorkHeadNm_vt, "preWorkForm");
				} else {
					alert("조회시 오류가 발생하였습니다. " + response.message);
				}
		});	
    };
    
    //기본 3개 생성
    var addTableTd = function(len, titleLen, tableId, useDate) {
    	//td 이미 추가 되어 있으면 생성하지 않음
    	if($("#"+tableId+" col").length>3) return;
    	//먼저...LGTXT 추가
    	var lgtxt = $("#"+tableId+" tr:eq(5)");
    	var nm = titleLen;
    	for(var i=0;i<titleLen-1;i++){
    		var add = lgtxt.clone();
    		if(nm<10) nm = "0"+ nm;
    		$(add).find("[name='BET01']").attr("name","BET"+nm);
    		lgtxt.after(add);
    		nm--;
    	}
    	
    	if(len<3) len = 3;
		
    	for(var k=0;k<len-1;k++){
    		//col추가
    		var col = $("#"+tableId+" col:last");
    		col.after(col.clone());
    		//title추가
    		var title = $("#"+tableId+" thead th:last");
    		title.after(title.clone().text("전근무지 "+(k+2)));
    		
    		$.each($("#"+tableId+" tr"), function(j, target){
    			var tds = $(target).find("td:last");
    			var addTd = tds.clone();
    			
    			//회사명 id
    			if(j==1||j==2) {
    				$.each(	$(addTd).find("input"), function(l, inp){
    					if($(inp).attr("id")!=undefined){
    						$(inp).attr("id", $(inp).attr("name")+(k+2));
    					}
    				});
    			}
    			
    			//기간달력
    			if(useDate && (j==3||j==4)){
    				if(k==0){
    					//최초에 함 넣기
    					$(tds).addClass("periodpicker");
    				}
    				
    				$.each(addTd.find("input"), function(m, inp){
    					$(inp).attr("id", $(inp).attr("name")+(k+2));
    					
    				});
    				$(addTd).addClass("periodpicker");
    			}
    			
    			tds.after(addTd);
    		});
    	}
    	
    	//width setting
    	$("#"+tableId+" col").attr("width", parseInt(100/(len+1))+"%");
    	
    	$("input[name='BIZNO']").on('change', function(){getPreWorkName(this);});
    }
    
    var preWorkSave = function() {
		paramArr = null;
		if(!preWorkCheck()) return;
		
		if(confirm("저장 하시겠습니까?")){
			$("#preWorkSaveBtn").off('click');
			jQuery.ajax({
				type : 'POST',
				url : '/taxAdjust/savePreWork.json',
				cache : false,
				dataType : 'json',
				data : paramArr,
				async :false,
				success : function(response) {
	    			if(response.success){
	    				alert("저장 되었습니다.");
	    				getTaxAdjustPreWork();
	    			}else{
	    				alert("저장시 오류가 발생하였습니다. " + response.message);
	    			}
	    		}
			});
		}
		
	};
	
	var preWorkCheck = function() {
		paramArr = $("#preWorkForm").serializeArray();
		
		var reqChk = true;
		
		var bizno = $("#preWorkForm input[name='BIZNO']");
		var comnm = $("#preWorkForm input[name='COMNM']");
		var pabeg = $("#preWorkForm input[name='PABEG']");
		var paend = $("#preWorkForm input[name='PAEND']");
		$.each(bizno, function(i, data){
			//데이터체크
			if($(data).val()=="" && $(comnm[i]).val()!=""){
				alert("사업자번호는 필수 항목입니다.");
				reqChk = false;
				return false;
			}
			
			if($(data).val()!=""){
				if($(comnm[i]).val()==""){
					alert("회사이름은 필수 항목입니다.");
					reqChk = false;
					return false;
				}
				
				//근무기간체크
				if($(pabeg[i]).val()==""||$(paend[i]).val()==""){
					alert("근무기간은 필수 항목입니다.");
					reqChk = false;
					return false;
				}
			}
		});
		
		if(!reqChk) return false;
		
		var chk =  $("#preWorkForm input[name='TXPAS']");
		
		$.each(chk, function(i){
			if($(chk[i]).prop("checked")){
				paramArr.push({name:"TXPASCHK", value:"Z"});
			} else {
				paramArr.push({name:"TXPASCHK", value:""});
			}
		});
		
		var headerLen = $("#preWorkForm input[name='LGART']").length;
		var PFSTID = "";
		if($("#IN_FSTID").prop("checked")) PFSTID="X";
		paramArr.push({name:"PFSTID", value:PFSTID});
		paramArr.push({name:"targetYear", value:"<%=targetYear%>"});
		paramArr.push({name:"headerLen", value:headerLen});
		return true;
	};
	
	var getPreWorkName = function(obj) {
		var objId = obj.id;
		
		var obj2;
		
		var bizno = $("#preWorkForm input[name='BIZNO']");
		var comnm = $("#preWorkForm input[name='COMNM']");
		
		$.each(comnm, function(i, comnmInput){
			if(bizno[i].id == objId){
				obj2 = comnmInput;
				return false;
			}
		});
		
		
		//회사이름 리셋
		$(obj2).val("");
		
		if(!checkBusino($(obj).val())) {
			$(obj).val("");
			obj.focus();
			return;
		}
		var bizNo = ($(obj).val());
		$.ajax({
			type : "post",
			url : "/taxAdjust/getPreWorkName.json",
			dataType : "json",
			data : {"bizNo" : numberOnly($(obj).val())}
		}).done(function(response) {
			if(response.success){
				$(obj).val(bizNo);
				$(obj2).val(response.bizName);
			} else {
				alert("조회시 오류가 발생하였습니다.");
				return;
			}
		});
	};
	//tab12 : 전근무지 ------------------------------------------------------ END
	
	//신청현황조회 ------------------------------------------------------------ START
	var getTaxAdjustFamily = function() {
		if(!setBaseInfo("familyTab")) return;	
		$setFamilyGrid();
	};
	
	$setFamilyGrid = function() {
		$("#familyGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: false,
   			paging: false,
            autoload: true,
            controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/taxAdjust/getTaxAdjustFamily.json",
   						dataType : "json",
   						data : {targetYear : '<%=targetYear%>'}
  					}).done(function(response) {
   						if(response.success){
   							d.resolve(response.ret_vt);
   						} else {
   							alert("조회시 오류가 발생하였습니다. " + response.message);
   						}
   		    				
   					});
   					return d.promise();
   				}
   				
   			},
   			headerRowRenderer: function() {
   				var arr = new Array(new Array(3, 13,"공제대상"));
   				return setGridHeader(this, arr);
            },
            fields: [
				{ title: "관계", name: "FAMI_RLNM", type: "text", align: "center", width: "7%" },
               	{ title: "성명", name: "FAMI_NAME", type: "text", align: "center", width: "8%" },
               	{ title: "주민등록번호", name: "FAMI_REGN", type: "text", align: "center", width: "13%", 
                	itemTemplate: function(value) {return addResBar(value);}
                },
                { title: "구분", name: "E_GUBUN", type: "text", align: "center", width: "9%" },
                { title: "보험료", name: "INSUR", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "의료비", name: "MEDIC", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "교육비", name: "EDUCA", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "신용카드등", name: "CREDIT", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "직불카드등", name: "DEBIT", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "현금영수증", name: "CASHR", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "전통시장분", name: "CCREDIT", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "대중교통분", name: "PCREDIT", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                },
                { title: "기부금", name: "GIBU", type: "text", align: "right", width: "7%", 
                	itemTemplate: function(value) {return value.format();}
                }
            ]
        });					
	};
	//신청현황조회 ------------------------------------------------------------ END
	
	//연말정산내역조회 --------------------------------------------------------- START
	var getTaxAdjustDetail = function() {
		if(!setBaseInfo("detailTab")) return;
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getTaxAdjustDetail.json',
			cache : false,
			dataType : 'json',
			data : {"targetYear":"<%=detailTargetYear%>"},
			async :false,
			success : function(response) {
				if(response.success){
    				if(response.ret_vt){
    					var arr = response.ret_vt[0];
    					if(response.msg!=""){
    						$("#detailMsgSpan").text(response.msg);
    						$("#detailMsgDiv").show();
    						$("#detailTableDiv").hide();
    					} else {
    						if(arr.isUsableData == "NO"){
    							$("#detailMsgSpan").text("해당연도에 연말정산 내역 데이터가 없습니다.");
        						$("#detailMsgDiv").show();
        						$("#detailTableDiv").hide();
    						} else {
    							$("#detailMsgDiv").hide();
        						$("#detailTableDiv").show();
    							setTableText(arr, "detailForm");
    						}
    					}
    				}
    				
    			}else{
    				alert("조회시 오류가 발생하였습니다. " + response.message);
    			}
    		}
		});
	};
	//연말정산내역조회 --------------------------------------------------------- END
	
	//소득공제신고서발행 -------------------------------------------------------- START
	var printHTML = $("#printHtml").html();
	
	var printChkAll = function(){
		$("[name='printChkYn']").prop("checked", true);
	};
	
	var printPopPage = function(){
		$.each($(".poptabUnder"), function(i, prt){
			if(!$(prt).hasClass('Lnodisplay')) {
				$(prt).print();
			}
		});
	};
	
	var chgPopupTabs = function(obj, popName) {
		//확인서 체크 안하면 안넘겨줌
		if(popName=="poptab0"){
			$("#firstPrint").show();
			$("#printMain").hide();
		} else {
			/*
			if(!$("#printChk1").is(":checked") || !$("#printChk2").is(":checked") || !$("#printChk3").is(":checked")){
				
			}
			*/
			var chkAll = false;
			$.each($("[name='printChkYn']"), function(i, prt){
				if(!$(prt).is(":checked")){
					
					chkAll = true;
					return false;
				}
			});
			
			if(chkAll) {
				alert("확인여부에 체크하여 주시기 바랍니다.");
				return false;
			}
			
			
			$("#firstPrint").hide();
			$("#printMain").show();
		}
		popupTabs(obj, popName);
	};
	
	var getTaxAdjustPrint = function() {
		$('#popLayerTaxPrint').popup();
		$("#taxPrintBtn").off('click');
		//데이터 초기화
		$("#printHtml").html(printHTML);
		$("#printTab a").removeClass("selected");
		$("#firstPrintTab a").addClass("selected");

		//로딩바
		$("#popLayerTaxPrint").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');		
		jQuery.ajax({
			type : 'POST',
			url : '/taxAdjust/getTaxAdjustPrint.json',
			cache : false,
			dataType : 'json',
			data : {"targetYear":"<%=targetYear%>"},
			
			success : function(response) {
    			if(response.success){
					//프린트
					
					var chkArr = $.makeArray({"code":"X","value":"○"});
					var pdfArr = $.makeArray({"code":"9","value":"○"});
					
					setTableText(response.user, "userTB");
					
					var personArr = $.makeArray({"FSTID":chkArr});
					setArrTableText(response.person, "personTB", 2, personArr);
					setSumTr("personTB", new Array(0,2));
					
					setArrTableText(response.special, "specialTB", 2);
					
					var houseLoanArr = $.makeArray({"SUBTY":response.houseLoanType,"FIXRT":chkArr, "NODEF":chkArr,"GUBUN":pdfArr});
					setArrTableText(response.houseLoan, "houseLoanTB", 1, houseLoanArr);
					
					var educationArr = $.makeArray({"SUBTY":response.relation_vt,"FASAR":response.scholarship_vt,"EXSTY":chkArr, "ACT_CHECK":chkArr, "AUTO_GUBUN":chkArr, "CHNTS":chkArr,"GUBUN":pdfArr,"LOAN":chkArr, "EDUFT":chkArr});
					setArrTableText(response.education, "educationTB", 1, educationArr);
					
					var pensionArr = $.makeArray({"SUBTY":response.pen_vt,"FINCO":response.fin_vt,"PREIN":chkArr, "PDF_FLAG":chkArr});
					setArrTableText(response.pension, "pensionTB", 1, pensionArr);
					
					setArrTableText(response.etcTax, "etcTaxTB", 2);
					var familyArr = $.makeArray({"FAMI_B001":chkArr,"FAMI_B002":chkArr,"FAMI_B003":chkArr});
					setArrTableText(response.family, "familyTB", 1, familyArr);
					
					var rentArr = $.makeArray({"HOUTY":response.rent_vt});
					setArrTableText(response.monthlyRent, "monthlyRentTB", 1, rentArr);					

					$("#signName").text(response.user.ename);
					
					
					if(prev_YN == "Y"){
						//테이블 추가...
						if(response.preWork.length>0){
							addTableTd(response.preWork.length, response.preWorkHeadNm.length,"preWorkTB",false);			
							setTableText(response.preWork, "preWorkTB");
							setTableText(response.preWorkHeadNm, "preWorkTB");
							$("#preWorkDiv").show();
						} else {
							$("#preWorkDiv").hide();
						}
					}
					
					if(response.creditCard.length==0){
    					$("#cardPrintTab").hide();
    				} else {
    					
    					setTableText(response.user, "userTB1");
    					var cardArr = $.makeArray({"SUBTY":response.relation_vt,"TRDMK":chkArr,"CCTRA":chkArr,"EXPRD":response.cardUseYear,"GUBUN":pdfArr});
    					setArrTableText(response.creditCard, "cardTB", 1, cardArr);
    					setSumTr("cardTB", new Array(0,4));
    					$("#cardTB tr:last td:eq(0)").text("합계");
    					setTableText(response.cardSum,"cardSumTB");
    					//추가공제분
    					setArrTableText(response.cardAdd, "cardAddTB", 1, cardArr);
    					$("#signName1").text(response.user.ename);
    					
    				}
					
					//의료비 합계가 같이 내려옴
					if(response.medical.length<2){
    					$("#medicalPrintTab").hide();
    				} else {
    					setTableText(response.user, "userTB2");
    					var gubunArr = $.makeArray({"code":"1","value":"회사지원"});
    					gubunArr.push({"code":"2","value":"추가입력"});
    					gubunArr.push({"code":"9","value":"PDF"});
    					var mediArr = $.makeArray({"GUBUN":gubunArr,"GLASS_CHK":chkArr,"DIFPG_CHK":chkArr,"SUBTY":response.relation_vt});
    					setArrTableText(response.medical, "mediTB", 2, mediArr);
    					setSumTr("mediTB", new Array(0,1));
    					$("#mediTB tr:last td:eq(0)").text("합계");
    					$("#signName2").text(response.user.ename);
    				}
					
					if(response.donation.length==0){
						$("#donationPrintTab").hide();
    				} else {
    					setTableText(response.user, "userTB3");
    					var dgubunArr = $.makeArray({"code":"1","value":"자동반영"});
    					dgubunArr.push({"code":"2","value":"추가입력"});
    					dgubunArr.push({"code":"9","value":"PDF"});
    					var donArr = $.makeArray({"GUBUN":dgubunArr});
    					setArrTableText(response.donation, "donationTB", 2, donArr);
    					setSumDonation();
    					$("#signName3").text(response.user.ename);
    				}
					
    			}
    			
    			$("#popLayerTaxPrint").loader('hide');
    		}
			
		});
		
		if(E_CHG == "X") $("#PRINT_P_CHG").prop("checked",true);		
		if(E_HOLD == "X") $("#PRINT_PFSTID").prop("checked",true);
		
	};
	
	var setSumTr = function(tb, merge){
		var obj = $("#" + tb + " tr:last td");
		for(var i=merge[0];i<merge[1]+1;i++){
			if(i==merge[0]) {
				$(obj[i]).attr("colspan", merge[1]+1-merge[0]);
			} else {
				$(obj[i]).remove();
			}
		}
	};
	
	var setSumDonation = function(){
		var ddx = $("#donationTB tr").length;
		
		for(var i=ddx-6;i<ddx;i++){
			if(i==ddx-6){
				$("#donationTB tr:eq("+i+") td:eq(0)").attr("rowspan", 5).text("소계");
			}
			
			if(i==ddx-1){
				$("#donationTB tr:eq("+i+") td:eq(0)").attr("colspan", 10).text("합계");
			} else {
				$("#donationTB tr:eq("+i+") td:eq(1)").attr("colspan", 9);
			}
			
			$("#donationTB tr:eq("+i+") td:eq(12)").attr("colspan", 2);
			
			var tds = $("#donationTB tr:eq("+i+") td");
			$.each(tds, function(j,tdo){
				if(i==ddx-6){
					if(j>1 && j<10) $(tdo).remove();
				} else if(i>ddx-6 && i<ddx-1){
					if(j==0) $(tdo).remove();
					if(j>1 && j<10) $(tdo).remove();
				} else {
					if(j>0 && j<10) $(tdo).remove();
				}
				
				if(j==11) $(tdo).remove();
				
			});
			
			//들여쓰기
			if(i==ddx-3) $("#donationTB tr:eq("+i+") td:eq(0)").addClass("txtTab");
			
		}
	};
	
	var setTaxPrintBtn = function(){
		$("#taxPrintBtn").off('click');
		$("#taxPrintBtn").on('click', function(){getTaxAdjustPrint();});
	};
	//소득공제신고서발행 -------------------------------------------------------- END
</script>
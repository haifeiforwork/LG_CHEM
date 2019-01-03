<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.A.*"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.A.rfc.*"%>
<%@ page import="hris.A.A13Address.rfc.A13AddressNationRFC"%>
<%@ page import="hris.A.A13Address.rfc.A13AddressLiveTypeRFC"%>
<%@ page import="hris.A.A13Address.rfc.A13AddressTypeRFC"%>
<%@ page import="hris.A.A12Family.rfc.A12FamilyRelationRFC"%>
<%@ page import="hris.A.A12Family.rfc.A12FamilySubTypeRFC"%>
<%@ page import="hris.A.A12Family.rfc.A12FamilyScholarshipRFC"%>
<%@ page import="hris.A.A12Family.rfc.A12FamilyNationRFC"%>
<%@ page import="hris.A.A12Family.rfc.A12HandicapRFC"%>
<%@ page import="hris.A.A12Family.rfc.A12FamilySubTypeCountRFC"%>
<%@ page import="hris.A.A12Family.A12FamilySubTypeCountData"%>

<%@ page import="hris.A.A17Licence.rfc.A17LicenceGradeRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.SortUtil"%>

<%
	WebUserData user   = (WebUserData)session.getValue("user");
	Vector a01SelfDetailData_vt = (Vector) request.getAttribute("A01SelfDetailData_vt");

	String photoUrl = (String) request.getAttribute("photoUrl");
	String e_trfar = (String) request.getAttribute("e_trfar");
	A01SelfDetailData data = (A01SelfDetailData) a01SelfDetailData_vt.get(0);
	
	//부양가족표시기간
	String periodYN = (String) request.getAttribute("periodYN");
	
%>
<!--// Page Title start -->
<div class="title">
	<h1>개인인사정보</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">개인인적사항</a></span></li>
			<li class="lastLocation"><span><a href="#">개인인사정보</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
<!--------------- layout body start --------------->
<!--// myInfo start -->
<div class="myInfoArea">
	<div class="myPhoto">
		<p class="photo">
			<c:if test="${photoUrl != ''}">
			<img src="<c:out value='${photoUrl}'/>" alt="증명사진"/>
			</c:if>
			<c:if test="${photoUrl == ''}">
			<!-- 이미지없을경우  기본사이즈 150*190 px -->
			<img src="/web-resource/images/myphoto_empty.gif" alt="증명사진없음"/>
			</c:if>
		</p>
		<p class="txt"><strong><%=data.KNAME%></strong> 
			<% if (data.PERNR.equals("00008")) { %>
				사장&nbsp; 
			<% } else { %>
				<%=data.TITEL%>&nbsp;
			<% } %></p>
	</div>
	<div class="myInfo">
		<div class="">
			<table class="tableGuide">
				<caption>개인인적사항</caption>
				<colgroup>
					<col class="col_10p" />
					<col class="col_25p" />
					<col class="col_15p" />
					<col class="col_40p" />
				</colgroup>
				<tbody>
				<tr>
					<th>소속</th>
					<td colspan="3"><%=data.ORGTX%></td>
				</tr>
				<tr>
					<th>성명</th>
					<td><%=data.KNAME%> / <%=data.CNAME%> </td>
					<th>성명(영어)</th>
					<td><%=data.YNAME%></td>
				</tr>
				<tr>
					<th>입사구분</th>
					<td><%=data.MGTXT%></td>
					<th>입사시학력</th>
					<td><%=data.SLABS%></td>
				</tr>
				<tr>
					<th>사원구분</th>
					<td><%=data.PTEXT%></td>
					<th>근무지</th>
					<td><%=data.BTEXT%></td>
				</tr>
				<tr>
					<th>직위</th>
					<td>
					<% if (data.PERNR.equals("00008")) { %>
						사장&nbsp; 
					<% } else { %>
						<%=data.TITEL%>&nbsp;
					<% } %>
					</td>
					<th>그룹입사일</th>
					<td><%=(data.DAT02).equals("0000.00.00") ? "" : WebUtil.printDate(data.DAT02)%></td>
				</tr>
				<tr>
					<th>직무</th>
					<td><%=data.STLTX%></td>
					<th>자사입사일</th>
					<td><%=(data.DAT03).equals("0000.00.00") ? "" : WebUtil.printDate(data.DAT03)%></td>
				</tr>
				<tr>
					<th>직책</th>
					<td><%=(data.TITL2).equals("") ? "-" :data.TITL2%></td>
					<th>현직급승진일</th>
					<td><%=(data.BEGDA).equals("0000.00.00") ? "" : WebUtil.printDate(data.BEGDA)%></td>
				</tr>
				<tr>
					<th>급호</th>
					<td><%=data.VGLST%></td>
					<th>근속기준일</th>
					<td><%=(data.DAT01).equals("0000.00.00") ? "" : WebUtil.printDate(data.DAT01)%></td>
				</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!--// myInfo end -->
	<div class="tableComment">
	<p><span class="bold">개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며, <br/>이를 위반시에는
    	취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려드립니다.</span></p>
	</div>
	<br>
<!--// Tab start -->
<div class="tabArea">
	<ul class="tab">
		<li><a href="#" id="tab1" onclick="switchTabs(this, 'tab1');" class="selected">인사기본</a></li>
		<li><a href="#" id="tab2" onclick="switchTabs(this, 'tab2');" >가족</a></li>
		<li><a href="#" id="tab3" onclick="switchTabs(this, 'tab3');" >발령</a></li>
		<li><a href="#" id="tab4" onclick="switchTabs(this, 'tab4');" >학력</a></li>
		<li><a href="#" id="tab5" onclick="switchTabs(this, 'tab5');" >자격면허</a></li>
		<li><a href="#" id="tab6" onclick="switchTabs(this, 'tab6');" >포상징계</a></li>
		<li><a href="#" id="tab7" onclick="switchTabs(this, 'tab7');" >경력</a></li>
		<li><a href="#" id="tab8" onclick="switchTabs(this, 'tab8');" >어학</a></li>
	</ul>
</div>
<!--// Tab end -->

<!--// Tab1 start -->
<div class="tabUnder tab1">
	<div class="tableArea">
		<h3 class="subsubtitle">개인신상</h3>
		<div class="table">
			<table class="tableGeneral">
				<caption>개인신상</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_35p" />
					<col class="col_15p" />
					<col class="col_35p" />
				</colgroup>
				<tbody>
				<tr>
					<th>국적</th>
					<td><%=data.LANDX%></td>
					<th>결혼상태</th>
					<td><%=data.FTEXT%></td>
				</tr>
				<tr>
					<th>생년월일</th>
					<td><%=data.GBDAT%></td>
					<th>종교</th>
					<td><%=data.KTEXT%></td>
				</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="listArea">	
		<h3 class="subsubtitle withButtons">주소</h3>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a class="darken popLayerAddr_open" href="#popLayerAddr" id="addrListCreateBtn"><span>등록</span></a></li>
			</ul>
		</div>
		<div class="clear"> </div>
		
		<!-- // 주소 grid -->
		<div id="addrListGrid"></div>
	</div>
	
	<div class="tableArea">	
		<h3 class="subsubtitle withButtons">연락처</h3>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a class="darken popLayerContact" href="#popLayerContact" id="contactCreateBtn"><span>수정</span></a></li>
			</ul>
		</div>
		<div class="clear"> </div>
		
		<!-- // 연락처 grid -->
		<div id="contactListGrid"></div>
	</div>
</div>
<!--// Tab1 end -->

<!--// Tab2 start -->
<div class="tabUnder tab2 Lnodisplay">
	<div class="listArea">
		<h3 class="subsubtitle">가족사항</h3>
		
		<!-- // 가족사항 grid -->
		<div id="familyListGrid" ></div>
	</div>
	<form id="familyDetailForm">
	<div class="familyDetailArea">	
		<h3 class="subsubtitle">가족사항 상세</h3>
		<div class="table pb30">
			<table class="tableGeneral">
				<caption>가족사항 테이블</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_35p" />
					<col class="col_15p" />
					<col class="col_35p" />
				</colgroup>
				<tbody>
				<tr>
					<th><span class="textPink">*</span><label for="familyDetailName">성명</label></th>
					<td>
						<input id="familyDetailLNMHG" name="LNMHG" type="text" class="w50 readOnly" readOnly/>
						<input id="familyDetailFNMHG" name="FNMHG" type="text" class="w100 readOnly" readOnly />
					</td>
					<th><span class="textPink">*</span><label for="familyDetailSUBTY">가족유형</label></th>
					<td>
						<select id="familyDetailSUBTY" name="SUBTY" class="input03 readOnly" readOnly>
						<option value="">------------</option>
						<%= WebUtil.printOption((new A12FamilySubTypeRFC()).getFamilySubType()) %>
						</select>
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="familyDetailREGNO">주민등록번호</label></th>
					<td><input id="familyDetailREGNO" name="REGNO" type="text" onBlur="javascript:formatResno('familyDetailREGNO');" class="readOnly" readOnly /></td>
					<th><span class="textPink">*</span><label for="familyDetailKDSVH">관계</label></th>
					<td>
						<select id="familyDetailKDSVH" name="KDSVH" class="input03 readOnly" disabled>
						<option value="">------------</option>
							<%= WebUtil.printOption((new A12FamilyRelationRFC()).getFamilyRelation("")) %>
						</select>
					</td>
				</tr>
				<tr>
					<th><span class="textPink">*</span><label for="familyDetailFGBDT">생년월일</label></th>
					<td>
						<input id="familyDetailFGBDT" name="FGBDT" type="text" class="w70" class="readOnly" readOnly />
						
						<span id="detailspanKDBSL" style="display: none">
							<select id="familyDetailKDBSL" name="KDBSL" class="input03" style="width:91px">
								<option value="">------------</option>
								<%
								Vector vet1 = (new A12FamilySubTypeCountRFC()).getFamilySubCountType();
								for ( int i=0 ; i < vet1.size() ; i++ )
						        {
									A12FamilySubTypeCountData a12FamilySubTypeCountData1 = (A12FamilySubTypeCountData)vet1.get(i);
								%>
									<option value="<%= a12FamilySubTypeCountData1.getAUSPR() %>"  ><%= a12FamilySubTypeCountData1.getATEXT() %></option>
								<%
						        }
								%>
							</select>
						</span>
					
					</td>
					<th><label>성별</label></th>
					<td>
						<input type="radio" name="FASEX" value=1 class="readOnly" disabled /> 남
						<input type="radio" name="FASEX" value=2 class="readOnly" disabled /> 여
					</td>
				</tr>
				<tr>
					<th><label for="familyDetailFGBOT">출생지</label></th>
					<td><input id="familyDetailFGBOT" name="FGBOT" type="text" class="readOnly" readOnly/></td>
					<th><span class="textPink">*</span><label for="familyDetailFASAR">학력</label></th>
					<td>
						<select id="familyDetailFASAR" name="FASAR" class="input03 readOnly" disabled >
						<option value="">------------</option>
							<%= WebUtil.printOption((new A12FamilyScholarshipRFC()).getFamilyScholarship("")) %>
						</select>
					</td>
				</tr>
				<tr>
					<th><label for="familyDetailFGBLD">출생국</label></th>
					<td>
						<select id="familyDetailFGBLD" name="FGBLD" class="input03 readOnly" readOnly>
						<option value="">------------</option>
							<%= WebUtil.printOption((new A12FamilyNationRFC()).getFamilyNation()) %>
							
							
						</select>
					</td>
					<th><label for="familyDetailFASIN">교육기관</label></th>
					<td><input id="familyDetailFASIN" name="FASIN" type="text" class="readOnly" readOnly /></td>
				</tr>
				<tr>
					<th><label for="familyDetailFANAT">국적</label></th>
					<td>
						<select id="familyDetailFANAT" name="FANAT" class="input03 readOnly" disabled >
						<option value="">------------</option>
							<%= WebUtil.printOption((new A12FamilyNationRFC()).getFamilyNation()) %>
						</select>
					</td>
					<th><label for="familyDetailFAJOB">직업</label></th>
					<td><input id="familyDetailFAJOB" name="FAJOB" type="text" class="readOnly" readOnly /></td>
				</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="tableArea">
		<h3 class="subsubtitle">종속성</h3>
		<div class="table">
			<table class="tableGeneral">
				<caption>가족사항 테이블</caption>
				<colgroup>
					<col class="col_15p" />
					<col class="col_35p" />
					<col class="col_15p" />
					<col class="col_35p" />
				</colgroup>
				<tbody>
				<tr>
					<th>세금</th>
					<td>
						<input type="checkbox" name="DPTID" id="familyCheckDPTID" disabled="disabled" /><label for="familyCheckDPTID">부양가족</label>
						<input type="checkbox" name="BALID" id="familyCheckBALID" disabled="disabled" /><label for="familyCheckBALID">수급자</label>
						<input type="checkbox" name="HNDID" id="familyCheckHNDID" disabled="disabled" /><label for="familyCheckHNDID">장애인</label>
						<!-- <input type="checkbox" name="CHDID" id="familyCheckCHDID" disabled="disabled" /><label for="familyCheckCHDID">자녀보호</label> -->
					</td>
					<th>기타</th>
					<td>
						<input type="checkbox" name="LIVID" id="familyCheckLIVID" disabled="disabled" /><label for="familyCheckLIVID">동거여부</label>
						<input type="checkbox" name="HELID" id="familyCheckHELID" disabled="disabled" /><label for="familyCheckHELID">건강보험</label>
						<div style="display:none"><input type="checkbox" name="FAMID" id="familyCheckFAMID" disabled="disabled" /><label for="familyCheckFAMID">가족수당</label></div>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
	</div>
	<input type="hidden" id="familyDetailORGREGNO"  name="orgRegno" />
	<input type="hidden" id="familyDetailJOBID"  name="jobid" />
	<input type="hidden" id="familyDetailOBJPS"  name="OBJPS" />
	<input type="hidden" id="familyDetailSTEXT"  name="STEXT" />
	<input type="hidden" id="familyDetailATEXT"  name="ATEXT" />
	<input type="hidden" id="familyDetailSTEXT1" name="STEXT1" />
	<input type="hidden" id="familyDetailLANDX"  name="LANDX" />
	<input type="hidden" id="familyDetailNATIO"  name="NATIO" />
	</form>
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="#" class="darken" id="popLayerCreateFamilyBtn"><span>등록</span></a></li>
			<li><a href="#" id="updateFamilyClientBtn"><span>수정</span></a></li>
			<li><a href="#" id="deleteFamilyClientBtn"><span>삭제</span></a></li>
			<li><a href="#" id="supportStateCheckBtn" class="darken"><span>부양가족여부 신청</span></a></li>
<%
	// LG MMA이면서 급여유형이 01,02,06,07,""이 아닌경우만 가족수당 신청 가능
	// 가족수당 신청가능
	if(!(e_trfar.equals("01") || e_trfar.equals("02") || e_trfar.equals("06") || e_trfar.equals("07") || e_trfar.equals(""))) {
%>
			<li><a href="javascript:allowanceFamily();" class="darken"><span>가족수당 신청</span></a></li>
			<li><a href="javascript:allowanceFamilyCancel();" class="darken"><span>가족수당상실 신청</span></a></li>
<%
	}
%>
		</ul>
	</div>
</div>
<!--// Tab2 end -->

<!--// Tab3 start -->
<div class="tabUnder tab3 Lnodisplay">
	<div class="listArea">
		<h3 class="subsubtitle">발령사항</h3>
		<!-- // 발령사항 grid -->
		<div id="rankChangeGrid" class="jsGridMiniPaging"></div>
	</div>
	<div class="listArea">
		<h3 class="subsubtitle">승급사항</h3>
		<!-- // 승급사항 grid -->
		<div id="statusChangeGrid" class="jsGridMiniPaging"></div>
	</div>
</div>
<!--// Tab3 end -->

<!--// Tab4 start -->
<div class="tabUnder tab4 Lnodisplay">
	<div class="listArea">
		<h3 class="subsubtitle">학력사항</h3>
		<!-- // 학력사항 grid -->
		<div id="schoolGrid" class="jsGridPaging"></div>
	</div>
</div>
<!--// Tab4 end -->

<!--// Tab5 start -->
<div class="tabUnder tab5 Lnodisplay">
	<form id="licenseForm">
	<div class="listArea">
		<h3 class="subsubtitle">자격면허</h3>
		<!-- // 자격면허 grid -->
		<div id="licenseGrid" class="jsGridMiniPaging"></div>
	</div>
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a id ="createLicensePopupBtn" href="#" class="darken"><span>등록</span></a></li>
		</ul>
	</div>
	
	<!-- 작업 진행중 --> 
	<div id = "createLicense" class="tableArea">
		<h2 class="subtitle">자격면허등록</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>자격면허등록</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_85p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="licenseBegda">신청일</label></th>
				<td class="tdDate">
					<input class="readOnly" type="text" id="licenseBegda" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="licenseLicnName">자격증</label></th>
				<td>
					<input class="readOnly"  type="text" id="licenseLicnName" name="LICN_NAME" vname="자격증" required  readonly="readonly" />
					<a class="icoSearch" href="#" id="searchLicensePopupBtn"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
					<span class="noteItem colorRed">※ 직접 입력 마시고, 검색버튼 눌러서 입력하시기 바랍니다. </span>
					<input type="hidden" id="licenseLicnCode" name="LICN_CODE" >
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="licenseLicnGrad">자격등급</label></th>
				<td>
					<select id="licenseLicnGrad" name="LICN_GRAD" vname="자격등급" required >
						<option value="">--------선택--------</option>
						<%= WebUtil.printOption((new A17LicenceGradeRFC()).getLicenceGrade()) %>
					</select>
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="licensePublOrgh">발행처</label></th>
				<td>
					<input class="w250" type="text" id="licensePublOrgh" name="PUBL_ORGH" vname="발행처" required />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="licenseLicnNumb">자격증번호</label></th>
				<td>
					<input class="w250" type="text" id="licenseLicnNumB" name="LICN_NUMB" vname="자격증번호" required />
				</td>
			</tr>
			<tr>
				<th><span class="textPink">*</span><label for="licenseObnDate">취득일</label></th>
				<td class="tdDate">
					<input type="text" class="datepicker" id="licenseObnDate" name="OBN_DATE" vname="취득일" required />
				</td>
			</tr>
			</tbody>
			</table>
		</div>	
		<div class="tableComment pb30">
			<p><span class="bold">안내사항</span></p>
			<ul>
				<li>자격증 종류가 미등록된 경우는 각 지역 인사부서로 자격증 종류 등록을 요청하신 후 재신청하시기 바랍니다.</li>
				<li>법정선임 대상 자격증은 안전환경팀으로 제출바랍니다.</li>
			</ul>
		</div>
		<div class="listArea">
			<h2 class="subtitle">결재정보</h2>	
			<div id="licenseAppLineGrid"></div>
			<input type="hidden" id="licenseRowCount" name="RowCount" />

		</div>
		<!--// list end -->
		<div class="buttonArea">
			<ul class="btn_crud">
				<li><a id="createLicenseBtn" href="#" class="darken" ><span>신청</span></a></li>
			</ul>
		</div>
		<input type="hidden" id="LicenseGradName" name="GRAD_NAME" />
		<input type="hidden" id="LicenseUpmuType" name="UPMUTYPE" value="14" />
	</div>
	</form>
</div>
<!--// Tab5 end -->

<!--// Tab6 start -->
<div class="tabUnder tab6 Lnodisplay">
	<div class="listArea">
		<h3 class="subsubtitle">포상내역</h3>
		<!-- // 포상내역 grid -->
		<div id="rewardGrid" class="jsGridMiniPaging"></div>
	</div>	
	<div class="listArea">
		<h3 class="subsubtitle">징계내역</h3>
		<div id="punishGrid" class="jsGridMiniPaging"></div>
	</div>
</div>
<!--// Tab6 end -->

<!--// Tab7 start -->
<div class="tabUnder tab7 Lnodisplay">
	<div class="listArea">
		<h3 class="subsubtitle">경력</h3>
		<!--// 경력 grid -->
		<div id="careerGrid" class="jsGridPaging"></div>
	</div>
</div>
<!--// Tab7 end -->

<!--// Tab8 start -->
<div class="tabUnder tab8 Lnodisplay">
	<div id="langTest0001List" class="listArea">
		<h3 class="subsubtitle">TOEIC</h3>
		<!--// TOEIC grid -->
		<div id="langTest0001Grid" class="jsGridMiniPaging"></div>
	</div>	
	<div id="langTest0002List" class="listArea">
		<h3 class="subsubtitle">JPT</h3>
		<!--// JPT grid -->
		<div id="langTest0002Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0003List" class="listArea">
		<h3 class="subsubtitle">TOEFL</h3>
		<!--// TOEFL grid -->
		<div id="langTest0003Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0004List" class="listArea">
		<h3 class="subsubtitle">한어수평고시</h3>
		<!--// 한어수평고시 grid -->
		<div id="langTest0004Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0008List" class="listArea">
		<h3 class="subsubtitle">신 HSK</h3>
		<!--// 신 HSK grid -->
		<div id="langTest0008Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0005List" class="listArea">
		<h3 class="subsubtitle">LGA-LAP Oral Test</h3>
		<!--// LGA-LAP Oral Test grid -->
		<div id="langTest0005Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0006List" class="listArea">
		<h3 class="subsubtitle">LGA-LAP Written</h3>
		<!--// LGA-LAP Written grid -->
		<div id="langTest0006Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0007List" class="listArea">
		<h3 class="subsubtitle">SEPT</h3>
		<!--// SEPT grid -->
		<div id="langTest0007Grid" class="jsGridMiniPaging"></div>
	</div>
	
	<!-- 추가 20171108 -->
	<div id="langTest0009List" class="listArea">
		<h3 class="subsubtitle">TOEIC SPEAKING</h3>
		<!--// SEPT grid -->
		<div id="langTest0009Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0010List" class="listArea">
		<h3 class="subsubtitle">TOEIC WRITING</h3>
		<!--// SEPT grid -->
		<div id="langTest0010Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0011List" class="listArea">
		<h3 class="subsubtitle">OPIC</h3>
		<!--// SEPT grid -->
		<div id="langTest0011Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0012List" class="listArea">
		<h3 class="subsubtitle">SJPT</h3>
		<!--// SEPT grid -->
		<div id="langTest0012Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0013List" class="listArea">
		<h3 class="subsubtitle">TSC</h3>
		<!--// SEPT grid -->
		<div id="langTest0013Grid" class="jsGridMiniPaging"></div>
	</div>
	<div id="langTest0014List" class="listArea">
		<h3 class="subsubtitle">OPIC(Chinese)</h3>
		<!--// SEPT grid -->
		<div id="langTest0014Grid" class="jsGridMiniPaging"></div>
	</div>	
	
	
</div>
<!--// Tab8 end -->

<!-- // 주소 popup start -->
<div class="layerWrapper layerSizeM" id="popLayerAddr">
	<div class="layerHeader">
		<strong>주소 상세</strong>
		<a href="#" class="btnClose popLayerAddr_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<form id="addrsForm">
			<!--// Content start  -->
			<div class="tableArea tablePopup">
				<div class="table">
					<table class="tableGeneral">
					<caption>주소입력</caption>
					<colgroup>
						<col class="col_20p" />
						<col class="col_80p" />
					</colgroup>
					<tbody>
						<tr>
							<th><label for="addrsSUBTY">유형</label></th>
							<td>
								<select id="addrsSUBTY" name="SUBTY" class="input03" > 
									<%= WebUtil.printOption((new A13AddressTypeRFC()).getAddressType()) %>
								</select>
							</td>
						</tr>
						<tr>
							<th><label for="addrsLAND1">국가</label></th>
							<td>
								<select id="addrsLAND1" name="LAND1" class="input03" vname="국가" required >
									<option value="">------------</option>
									<%= WebUtil.printOption((new A13AddressNationRFC()).getAddressNation()) %>
								</select>
							</td>
						</tr>
						<tr>
							<th><label for="addrsPSTLZ"><span class="textPink">*</span>주소</label></th>
							<td>
								<input id="addrsPSTLZ" name="PSTLZ" type="text" class="w50" placeholder="우편번호" vname="우편번호" required />
								<a class="inlineBtn" href="javascript:sample4_execDaumPostcode('addrsPSTLZ','addrsSTRAS','addrsLOCAT');"><span>우편번호 검색</span></a>				
								<div class="br">
									<input id="addrsSTRAS" name="STRAS" type="text" class="wPer" vname="주소" required/>
								</div>
								<div class="br">
									<input id="addrsLOCAT" name="LOCAT" type="text" class="wPer" vname="상세주소" required placeholder="상세주소 입력" />
								</div>
								<p class="noteItem font11">세부 주소 입력 부탁드립니다. <br/>(아파트 : 동, 호수까지 기입, 주택 및 기타 : 층수까지 상세 주소 기입)</p>
							</td>
						</tr>
						<tr>
							<th><label for="addrsLiveType">주거형태</label></th>
							<td>
								<select id="addrsLiveType" name="LIVE_TYPE" class="input03">
								<option value="">------------</option>
									<%= WebUtil.printOption((new A13AddressLiveTypeRFC()).getAddressLiveType()) %>
								</select>
							</td>
						</tr>
						<tr>
							<th><label for="addrsTELNR">전화번호</label></th>
							<td>
								<input id="addrsTELNR" name="TELNR" type="text" class="w150" vname="전화번호"/>
								<p class="noteItem font11">입력예제 : 02-123-4567</p>
							</td>
						</tr>
					</tbody>
					</table>
				</div>
			</div>
			<div class="buttonArea buttonCenter">
				<ul class="btn_crud">
					<li><a href="#" id="addrSave" class="darken" ><span>확인</span></a></li>
					<li><a href="#" id="addrCansel"><span>취소</span></a></li>
				</ul>
			</div>
			<input type="hidden" id="LANDX" name="LANDX" />
			<input type="hidden" id="LIVE_TEXT" name="LIVE_TEXT" />
			<input type="hidden" id="STEXT" name="STEXT" />
			<input type="hidden" id="addrcount" name="addrcount" />
			</form>
			<!--// Content end  -->
		</div>
	</div>
</div>
<!-- // 주소 popup end -->

<!-- // 연락처 상세 popup -->
<div class="layerWrapper layerSizeS" id="popLayerContact">
	<div class="layerHeader">
		<strong>연락처 상세</strong>
		<a href="#" class="btnClose popLayerContact_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<form id="contactForm">
				<div class="tableArea tablePopup">
					<div class="table">
					<table class="tableGeneral">
					<caption>주소입력</caption>
					<colgroup>
						<col class="col_30p" />
						<col class="col_70p" />
					</colgroup>
					<tbody>
						<tr>
							<th><label for="contactTELNR1">자택전화</label></th>
							<td><input id="contactTELNR1" name="TELNR" type="text" /></td>
						</tr>
						<tr>
							<th><label for="contactUSRID">회사전화번호</label></th>
							<td><input id="contactUSRID" name="USRID" type="text" /></td>
						</tr>
						<tr>
							<th><label for="contactMPHNID">핸드폰번호</label></th>
							<td><input id="contactMPHNID" name="MPHNID" type="text" /></td>
						</tr>
					</tbody>
					</table>
					</div>
				</div>
				<div class="buttonArea buttonCenter">
					<ul class="btn_crud">
						<li><a class="darken" href="#" id="contactSave"><span>확인</span></a></li>
						<li><a href="#" id="contactCansel"><span>취소</span></a></li>
					</ul>
				</div>
			</form>
		</div>
	</div>
</div>

<!-- popup : 가족사항 등록 start -->
<div class="layerWrapper layerSizeL" id="popLayerCreateFamily">
	<div class="layerHeader">
		<strong>가족사항 등록</strong>
		<a href="#" class="btnClose popLayerCreateFamily_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<form id="createFamilyForm">
			<div class="tableArea">
				<div class="table">
				<table class="tableGeneral">
					<caption>가족사항 테이블</caption>
					<colgroup>
						<col class="col_15p" />
						<col class="col_35p" />
						<col class="col_15p" />
						<col class="col_35p" />
					</colgroup>
					<tbody>
					<tr>
						<th><span class="textPink">*</span><label for="createFamilyLNMHG">성명</label></th>
						<td>
						    <div class="buttonArea">
						    <ul class="btn_crud">
							<input id="createFamilyLNMHG" name="LNMHG" type="text" class="w50"/>
							<input id="createFamilyFNMHG" name="FNMHG" type="text" class="w70"/>
							<li><a class="darken" href="#" id="checkREGNOBtn"><span>실명확인</span></a></li>
							</ul>
							</div>						
						
						</td>
						<th><span class="textPink">*</span><label for="createFamilySUBTY">가족유형</label></th>
						<td>
							<select id="createFamilySUBTY" name="SUBTY" class="input03">
								<option value="">------------</option>
								<%= WebUtil.printOption((new A12FamilySubTypeRFC()).getFamilySubType()) %>
							</select>
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="createFamilyREGNO">주민등록번호</label></th>
						<td><input id="createFamilyREGNO" name="REGNO" type="text" onBlur="javascript:formatResno('createFamilyREGNO');" readonly  class="readOnly"/></td>
						<th><span class="textPink">*</span><label for="createFamilyKDSVH">관계</label></th>
						<td>
							<select id="createFamilyKDSVH" name="KDSVH" class="input03">
								<option value="">------------</option>
								<%= WebUtil.printOption((new A12FamilyRelationRFC()).getFamilyRelation("")) %>
							</select>
						</td>
					</tr>
					<tr>
						<th><span class="textPink">*</span><label for="createFamilyFGBDT">생년월일</label></th>
						<td>
						<input id="createFamilyFGBDT" name="FGBDT" type="text" class="w70"/>
						<span id="spanKDBSL" style="display: none">
							<select id="createFamilyKDBSL" name="KDBSL" class="input03" style="width:91px">
								<option value="">------------</option>
								<%
								Vector vet = (new A12FamilySubTypeCountRFC()).getFamilySubCountType();
								for ( int i=0 ; i < vet.size() ; i++ )
						        {
									A12FamilySubTypeCountData a12FamilySubTypeCountData = (A12FamilySubTypeCountData)vet.get(i);
								%>
									<option value="<%= a12FamilySubTypeCountData.getAUSPR() %>"  ><%= a12FamilySubTypeCountData.getATEXT() %></option>
								<%
						        }
								%>
							</select>
						</span>
						</td>
						<th><label for="createFamilyFASEX">성별</label></th>
						<td>
							<input type="radio" id="FASEX1" name="FASEX" value=1 /> 남
							<input type="radio" id="FASEX2" name="FASEX" value=2 /> 여
						</td>
					</tr>
					<tr>
						<th><label for="createFamilyFGBOT">출생지</label></th>
						<td><input id="createFamilyFGBOT" name="FGBOT" type="text"/></td>
						<th><span class="textPink">*</span><label for="createFamilyFASAR">학력</label></th>
						<td>
							<select id="createFamilyFASAR" name="FASAR" class="input03">
								<option value="">------------</option>
								<%= WebUtil.printOption((new A12FamilyScholarshipRFC()).getFamilyScholarship("")) %>
							</select>
						</td>
					</tr>
					<tr>
						<th><label for="createFamilyFGBLD">출생국</label></th>
						<td>
							<select id="createFamilyFGBLD" name="FGBLD" class="input03">
								<option value="">------------</option>
								<%= WebUtil.printOption( SortUtil.sort( (new A12FamilyNationRFC()).getFamilyNation(), "value", "asc" ), "KR") %>
							</select>
						</td>
						<th><label for="createFamilyFASIN">교육기관</label></th>
						<td><input id="createFamilyFASIN" name="FASIN" type="text"/></td>
					</tr>
					<tr>
						<th><label for="createFamilyFANAT">국적</label></th>
						<td>
							<select id="createFamilyFANAT" name="FANAT" class="input03">
								<option value="">------------</option>
								<%= WebUtil.printOption( SortUtil.sort( (new A12FamilyNationRFC()).getFamilyNation(), "value", "asc" ), "KR") %>
							</select>
						</td>
						<th><label for="createFamilyFAJOB">직업</label></th>
						<td><input id="createFamilyFAJOB" name="FAJOB" type="text"/></td>
					</tr>
					</tbody>
				</table>
				</div>
			</div>
			<!--// Content end  -->
			<div class="buttonArea buttonCenter">
				<ul class="btn_crud">
					<li><a href="javascript:createFamilyClient();" class="darken" ><span>신청</span></a></li>
					<li><a href="#" class="popLayerCreateFamily_close"><span>취소</span></a></li>
				</ul>
			</div>
			<input type="hidden" id="createFamilyOBJPS"  name="OBJPS"  />
			<input type="hidden" id="createFamilyBEGDA"  name="BEGDA"  value="<%= DataUtil.getCurrentDate() %>">
			<input type="hidden" id="createFamilyENDDA"  name="ENDDA"  value="99991231">
			<input type="hidden" id="createFamilySTEXT"  name="STEXT"  />
			<input type="hidden" id="createFamilyATEXT"  name="ATEXT"  />
			<input type="hidden" id="createFamilySTEXT1" name="STEXT1" />
			<input type="hidden" id="createFamilyLANDX"  name="LANDX"  />
			<input type="hidden" id="createFamilyNATIO"  name="NATIO"  />
			<input type="hidden" id="createFamilyJOBID"  name="jobid"  />
			</form>
		</div>
	</div>
</div>
<!-- popup : 가족사항 등록 end -->

<!-- popup : 부양가족여부 신청 start -->
<div class="layerWrapper layerSizeL" id="popLayerSupportFamily">
	<div class="layerHeader">
		<strong>가족사항</strong>
		<a href="#" class="btnClose popLayerSupportFamily_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<form id="SupportFamilyForm">
			<!--// Content start  -->
			<div class="tableArea">
				<h3 class="subsubtitle">대상자</h3>
				<div class="table">
					<table class="tableGeneral">
						<caption>연락처 수정</caption>
						<colgroup>
							<col class="col_15p" />
							<col class="col_35p" />
							<col class="col_15p" />
							<col class="col_35p" />
						</colgroup>
						<tbody>
						<tr>
							<th><label for="supportFamilyLNMHG">성명(한글)</label></th>
							<td>
								<input id="supportFamilyLNMHG" name="LNMHG" type="text" readonly class="w50" />
								<input id="supportFamilyFNMHG" name="FNMHG" type="text" readonly class="w100" />
							</td>
							<th><label for="supportFamilySTEXT">가족유형</label></th>
							<td><input id="supportFamilySTEXT" name="STEXT" type="text" readonly /></td>
						</tr>
						<tr>
							<th><label for="supportFamilyREGNO">주민등록번호</label></th>
							<td>
							<input id="supportFamilyREGNO" name="REGNO" type="text" class="w90" readonly />
							<span id="spanSupportFamilyKDBSL" style="display: none">
							
							<input id="supportFamilyKDBSL" name="KDBSL" type="text" style="width:60px" readonly />
						</span>
							
							</td>
							<th><label for="supportFamilyATEXT">관계</label></th>
							<td><input id="supportFamilyATEXT" name="ATEXT" type="text" readonly /></td>
						</tr>
						<tr>
							<th><label for="supportFamilyFGBDT">생년월일</label></th>
							<td>
								<input id="supportFamilyYEAR" name="year" type="text" readonly class="w40" /> 년
								<span class="pl5"><input id="supportFamilyMONTH" name="month" type="text" readonly class="w20" /> 월</span>
								<span class="pl5"><input id="supportFamilyDAY" name="day" type="text" readonly class="w20" /> 일</span>
							</td>
							<th><label>성별</label></th>
							<td>
								<input type="radio" name="FASEX" value=1 disabled="disabled" /> 남
								<input type="radio" name="FASEX" value=2 disabled="disabled" /> 여
							</td>
						</tr>
						<tr>
							<th><label for="supportFamilyFGBOT">출생지</label></th>
							<td><input id="supportFamilyFGBOT" name="FGBOT" type="text" readonly /></td>
							<th><label for="supportFamilySTEXT1">학력</label></th>
							<td><input id="supportFamilySTEXT1" name="STEXT1" type="text" readonly /></td>
						</tr>
						<tr>
							<th><label for="supportFamilyLANDX">출생국</label></th>
							<td><input id="supportFamilyLANDX" name="LANDX" type="text" readonly /></td>
							<th><label for="supportFamilyFASIN">교육기관</label></th>
							<td><input id="supportFamilyFASIN" name="FASIN" type="text" readonly /></td>
						</tr>
						<tr>
							<th><label for="supportFamilyNATIO">국적</label></th>
							<td><input id="supportFamilyNATIO" name="NATIO" type="text" readonly /></td>
							<th><label for="supportFamilyFAJOB">직업</label></th>
							<td><input id="supportFamilyFAJOB" name="FAJOB" type="text" readonly /></td>
						</tr>
						<tr id="TrLossDate">
							<th><label for="supportFamilyLOSSDATE">상실일자&nbsp;<font color="#0000FF"><b>*</b></font></label></th>
							<td colspan="3"><input id="supportFamilyLOSSDATE" name="LOSS_DATE" type="text" size="20"></td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="tableComment supportFamily">
					<p><span class="bold">부양가족여부는 연말정산자료로서 자격요건에 해당하는 경우에만 신청하시기 바랍니다.</span></p>
					<p>신청하시기전에 [사용방법안내] 에서 자격요건과 제출서류를 반드시 확인해 주시기 바랍니다.</p>
				</div>
				<div class="tableArea supportFamily">
					<h3 class="subsubtitle">종속성</h3>
					<div class="table">
						<table class="tableGeneral">
							<caption>종속성 테이블</caption>
							<colgroup>
								<col class="col_15p" />
								<col class="col_35p" />
								<col class="col_15p" />
								<col class="col_35p" />
							</colgroup>
							<tbody>
							<tr>
								<th>세금</th>
								<td>
									<input type="checkbox" name="DPTID" id="supportFamilyDPTID" /><label for="supportFamilyDPTID">부양가족</label>
									<input type="checkbox" name="BALID" id="supportFamilyBALID" /><label for="supportFamilyBALID">수급자</label>
									<input type="checkbox" name="HNDID" id="supportFamilyHNDID" /><label for="supportFamilyHNDID">장애인</label>
									<!--  <input type="checkbox" name="CHDID" id="supportFamilyCHDID" /><label for="supportFamilyCHDID">자녀보호</label> -->
								</td>
								<th>기타</th>
								<td>
									<input type="checkbox" name="LIVID" id="supportFamilyLIVID" /><label for="supportFamilyLIVID">동거여부</label>
									<input type="checkbox" name="HELID" id="supportFamilyHELID" /><label for="supportFamilyHELID">건강보험</label>
								</td>
								
							</tr>
							<tr>
								<th>장애코드</th>
								<td >
									<select  id = "supportFamilyHNDCD" name = "HNDCD">
										<option value="">------------</option>
										<%= WebUtil.printOption((new A12HandicapRFC()).getFamilyRelation("")) %>
									</select>
								</td>
							
								<th><label for="inputDateFrom">장애(예상)기간</label></th>
								<td class="tdDate" >
									<input id="inputDateFrom" name="HNBEG" type="text" value="" />
									~
									<input id="inputDateTo" name="HNEND" type="text" value="" />
								</td>
								
							</tr>
							<% if(periodYN.equals("Y")){ %>
							<tr>
								<th>적용시기</th>
								<td colspan="3">
									<select name="PERIOD" id="popPeriod">
										<option value="">현재년도</option>
										<option value="X">직전년도</option>
									</select>
								</td>
							</tr>
							
							
							
							<% } else {%>
								<input type="hidden" name="PERIOD" value=""/>
							<% } %>

							</tbody>
						</table>
					</div>
					<div class="tableComment supportFamily">
					<p>※ 연말정산 부양가족 등록을 위해서는 「직전년도」를 선택 후 신청해 주시기 바랍니다.</p>
				</div>
					
				</div>
				<!--// list start -->
				<div class="listArea">	
					<h3 class="subsubtitle">결재정보</h3>
					<div id="appLineGrid"></div>
				</div>	
				<!--// list end -->	
				<div class="buttonArea buttonCenter">
					<ul class="btn_crud">
						<li><a href="javascript:requestSupportClient();" class="darken" ><span>신청</span></a></li>
						<li><a href="#" class="popLayerSupportFamily_close"><span>취소</span></a></li>
					</ul>
				</div>
				<input type="hidden" id="supportFamilyJOBID"     name="jobid" />
				<input type="hidden" id="supportFamilyGUBUN"     name="GUBUN" /> <!-- 구분 'X':부양가족, ' ':가족수당 -->
				<input type="hidden" id="supportFamilyBEGDA"     name="BEGDA" value="<%= DataUtil.getCurrentDate() %>" />
				<input type="hidden" id="supportFamilySUBTY"     name="SUBTY" />
				<input type="hidden" id="supportFamilyOBJPS"     name="OBJPS" />
				<input type="hidden" id="supportFamilyUPMUTYPE"  name="UPMUTYPE" />
				<input type="hidden" id="supportFamilyFAMID"     name="FAMID" />
				<input type="hidden" id="supportFamilyRowCount"  name="RowCount" />
			</div>
			<!--// Content end  -->
			</form>
		</div>
	</div>
</div>
<!-- //팝업 : 가족사항 end -->

<!-- popup : 결재자 선택 start -->
<div class="layerWrapper layerSizeM" id="popLayerAppl" style="display:inherit !important">
	<form id="popLayerForm">
	<div class="layerHeader">
		<strong>결재자 조회</strong>
		<a href="#" class="btnClose popLayerAppl_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="tableInquiry item1">
				결재자
				<input type="text" id="I_ENAME" name="I_ENAME" class="w50" placeholder="성" onkeyup="javascript:if ( event.keyCode == 13){ $('#applPopupGrid').jsGrid('search'); }" />
				<input type="text" id="I_ENAME1" name="I_ENAME1" class="w80" placeholder="이름" onkeyup="javascript:if ( event.keyCode == 13){ $('#applPopupGrid').jsGrid('search'); }" />
				<a href="#" id="applPopupSearchbtn"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
				<input type="hidden" id="objid" name="objid" />
				<input type="hidden" id="clickRow" name="clickRow" />
				<input type="hidden" id="popupMode" name="popupMode" />
			</div>
			<div class="listArea pb10">
				<div id="applPopupGrid"></div>
			</div>
			<!--// Content end  -->
		</div>
	</div>
	</form>
</div>
<!-- //팝업: 결재자 선택 end -->

<!-- popup : 자격증 검색start -->
<div class="layerWrapper layerSizeS" id="popLayerLicense" style="display:inherit !important">
	<form id="popupLicenseForm">
	<div class="layerHeader">
		<strong>자격증 검색</strong>
		<a href="#" class="btnClose popLayerLicense_close">창닫기</a>
	</div>
	<div class="layerContainer">
		<div class="layerContent">
			<!--// Content start  -->
			<div class="tableInquiry item1">
				관련 검색어
				<input type="text" id="popupLicnName" name="LICN_NAME" class="w155" onkeyup="javascript:if ( event.keyCode == 13){ $('#licensePopupGrid').jsGrid('search'); }" />
				<a href="#" id="searchLicenseBtn"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
			</div>
			<div class="listArea pb10">
				<div id="licensePopupGrid"></div>
			</div>
			<!--// Content end  -->
		</div>
	</div>
	</form>
</div>
<!-- //팝업: 자격증 검색 end -->
	
<!-- // script -->
<script type="text/javascript">
	var targetItem;
	var callType;

	var HNFlag = false;
	
	$(function(){
		if($(".layerWrapper").length){
			// 주소
			$('#popLayerAddr').popup();
			// 연락처
			$('#popLayerContact').popup();
			// 가족사항 등록
			$('#popLayerCreateFamily').popup();
			// 부양가족여부 신청
			$('#popLayerSupportFamily').popup();
			// 결재자 검색
			$('#popLayerAppl').popup();
			//
			$('#popLayerLicense').popup();
		}
		
		$("#createLicense").hide();
		
		$("#tab1").click(function(){
			$("#addrListGrid").jsGrid("search");
			$("#contactListGrid").jsGrid("search");
		});
		$("#tab2").click(function(){
			$("#familyDetailForm").each(function(){
				this.reset();
			})
			
			$("#familyDetailLNMHG").addClass("readOnly").prop("readOnly",true);
			$("#familyDetailFNMHG").addClass("readOnly").prop("readOnly",true);
			//$("#familyDetailSUBTY").addClass("readOnly").prop("disabled",true);
			$("#familyDetailREGNO").addClass("readOnly").prop("readOnly",true);
			$("#familyDetailKDSVH").addClass("readOnly").prop("disabled",true);
			$("#familyDetailFGBDT").addClass("readOnly").prop("readOnly",true);
			$('input:radio[name="FASEX"]').addClass("readOnly").prop("disabled",true);
			$("#familyDetailFGBOT").addClass("readOnly").prop("readOnly",true);
			$("#familyDetailFASAR").addClass("readOnly").prop("disabled",true);
			$("#familyDetailFGBLD").addClass("readOnly").prop("disabled",true);
			$("#familyDetailFASIN").addClass("readOnly").prop("readOnly",true);
			$("#familyDetailFANAT").addClass("readOnly").prop("disabled",true);
			$("#familyDetailFAJOB").addClass("readOnly").prop("readOnly",true);
			
			$("#familyListGrid").jsGrid("search");
		});
		$("#tab3").click(function(){
			$("#rankChangeGrid").jsGrid("search");
			$("#statusChangeGrid").jsGrid("search");
		});
		$("#tab4").click(function(){
			$("#schoolGrid").jsGrid("search");
		});
		$("#tab5").click(function(){
			$("#createLicense").hide();
			$("#licenseGrid").jsGrid("search");
		});
		$("#tab6").click(function(){
			$("#rewardGrid").jsGrid("search");
			$("#punishGrid").jsGrid("search");
		});
		$("#tab7").click(function(){
			$("#careerGrid").jsGrid("search");
		});
		$("#tab8").click(function(){
			$.ajax({
				type : "get",
				url : "/base/c05FtestResultList.json",
				dataType : "json",
			}).done(function(response) {
				if(response.storeData1.length > 0){
					$("#langTest0001Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData1); return d.promise(); } } });
					$("#langTest0001Grid").jsGrid("search");
				}else{
					$("#langTest0001List").hide();
				}
				if(response.storeData2.length > 0){
					$("#langTest0002Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData2); return d.promise(); } } });
					$("#langTest0002Grid").jsGrid("search");
				}else{
					$("#langTest0002List").hide();
				}
				if(response.storeData3.length > 0){
					$("#langTest0003Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData3); return d.promise(); } } });
					$("#langTest0003Grid").jsGrid("search");
				}else{
					$("#langTest0003List").hide();
				}
				if(response.storeData4.length > 0){
					$("#langTest0004Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData4); return d.promise(); } } });
					$("#langTest0004Grid").jsGrid("search");
				}else{
					$("#langTest0004List").hide();
				}
				if(response.storeData8.length > 0){
					$("#langTest0008Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData8); return d.promise(); } } });
					$("#langTest0008Grid").jsGrid("search");
				}else{
					$("#langTest0008List").hide();
				}
				if(response.storeData5.length > 0){
					$("#langTest0005Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData5); return d.promise(); } } });
					$("#langTest0005Grid").jsGrid("search");
				}else{
					$("#langTest0005List").hide();
				}
				if(response.storeData6.length > 0){
					$("#langTest0006Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData6); return d.promise(); } } });
					$("#langTest0006Grid").jsGrid("search");
				}else{
					$("#langTest0006List").hide();
				}
				if(response.storeData7.length > 0){
					$("#langTest0007Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData7); return d.promise(); } } });
					$("#langTest0007Grid").jsGrid("search");
				}else{
					$("#langTest0007List").hide();
				}
	
				
				//추가 20171108
				if(response.storeData9.length > 0){
					$("#langTest0009Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData9); return d.promise(); } } });
					$("#langTest0009Grid").jsGrid("search");
				}else{
					$("#langTest0009List").hide();
				}
				if(response.storeData10.length > 0){
					$("#langTest0010Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData10); return d.promise(); } } });
					$("#langTest0010Grid").jsGrid("search");
				}else{
					$("#langTest0010List").hide();
				}
				if(response.storeData11.length > 0){
					$("#langTest0011Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData11); return d.promise(); } } });
					$("#langTest0011Grid").jsGrid("search");
				}else{
					$("#langTest0011List").hide();
				}
				if(response.storeData12.length > 0){
					$("#langTest0012Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData12); return d.promise(); } } });
					$("#langTest0012Grid").jsGrid("search");
				}else{
					$("#langTest0012List").hide();
				}
				if(response.storeData13.length > 0){
					$("#langTest0013Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData13); return d.promise(); } } });
					$("#langTest0013Grid").jsGrid("search");
				}else{
					$("#langTest0013List").hide();
				}


				//추가 20180514				
				if(response.storeData14.length > 0){
					$("#langTest0014Grid").jsGrid({ controller : { loadData : function(){ var d = $.Deferred(); d.resolve(response.storeData14); return d.promise(); } } });
					$("#langTest0014Grid").jsGrid("search");
				}else{
					$("#langTest0014List").hide();
				}
				
				
			});
		});
		
		// 자격면허 등록 입력창 show
		$("#createLicensePopupBtn").click(function(){
			$("#licenseAppLineGrid").jsGrid("search");
			$("#createLicense").show();
		});
		
		// 가족사항 등록 입력창 show
		$("#popLayerCreateFamilyBtn").click(function(){
			$("#createFamilyForm").each(function() {
				this.reset();
			});
			$("#createFamilyFNMHG").removeClass("readOnly").prop("readonly",false);
			$("#createFamilyLNMHG").removeClass("readOnly").prop("readonly",false);
			$("#popLayerCreateFamily").popup("show");
			
			$("#spanKDBSL").hide();
			$("#createFamilyKDBSL").val("");
		});
		
		// 자격면허 등록 신청 클릭
		$("#createLicenseBtn").click(function(){
			
			if($("#licenseAppLineGrid").jsGrid("dataCount") <1 ){
				alert("결재자 정보가 없습니다.");
				return;
			}
			
			if(confirm("신청 하시겠습니까?")){
				$("#createLicenseBtn").prop("disabled", true);
				
				$("#LicenseGradName").val($("#licenseLicnGrad option:selected").text());
				
				var param = $("#licenseForm").serializeArray();
				$("#licenseAppLineGrid").jsGrid("serialize", param);
				
				if( checkNullField("licenseForm") ) {
					jQuery.ajax({
						type : 'POST',
						url : '/base/createLicense.json',
						cache : false,
						dataType : 'json',
						data : param,
						async :false,
						success : function(response) {
							if(response.success){
								alert("신청 되었습니다.");
								$("#licenseForm").each(function(){
									this.reset();
								});
								$("#createLicense").hide();
							}else{
								alert("신청시 오류가 발생하였습니다. " + response.message);
							}
							$("#createLicenseBtn").prop("disabled", false);
						}
					});
				};
			}
		});
		
		// 결재자 조회 popup 검색
		$("#applPopupSearchbtn").click(function(){
			$("#applPopupGrid").jsGrid("search");
		});
		
		$("#searchLicensePopupBtn").click(function(){
			$("#popupLicenseForm").each(function() {
				this.reset();
			});
			$("#licensePopupGrid").jsGrid({"data":$.noop}); //초기화 방안 재확인 필요
			
			$("#popLayerLicense").popup('show');
		});
		
		$("#searchLicenseBtn").click(function(){
			$("#licensePopupGrid").jsGrid("search");
		});
		
		
		//실명확인 팝업  checkREGNOBtn
		$("#checkREGNOBtn").click(function(){
			
			var familyNm = $("#createFamilyLNMHG").val();
			var realNm = $("#createFamilyFNMHG").val();
			//var regNo = $("#createFamilyREGNO").val();
			
			if(familyNm=="" || realNm==""  ){
				alert("성명 입력 후 실명확인 버튼을 눌러주세요.");
				return false;
			}
			
			var URL = "/nc.jsp?familyNm="+familyNm+"&realNm="+realNm;
			window.open(URL, "실명확인", "width=650, height=520, scrollbars=no, resiable=no");
			
		});		
		
		
		//이동엽D 20170725

		$("#supportFamilyHNDID").click(function(){
			if($("#supportFamilyHNDID").is(':checked')){
				HNFlag = true;
			}else{
				HNFlag = false;
				
			}
		});
		
		$("#createFamilyREGNO").change(function(){
			regno_bit = $("#createFamilyREGNO").val();
			if(regno_bit.length==13){
				if( regno_bit.substring(6, 7) == "1" || regno_bit.substring(6, 7) == "3" ) {
					$("#FASEX1").prop("checked", true);
					$("#FASEX2").prop("checked", false);
				} else if( regno_bit.substring(6, 7) == "2" || regno_bit.substring(6, 7) == "4" ) {
					$("#FASEX1").prop("checked", false);
					$("#FASEX2").prop("checked", true);
				}
			}else if(regno_bit.length==14){
				if( regno_bit.substring(7, 8) == "1" || regno_bit.substring(7, 8) == "3" ) {
					$("#FASEX1").prop("checked", true);
					$("#FASEX2").prop("checked", false);
				} else if( regno_bit.substring(7, 8) == "2" || regno_bit.substring(7, 8) == "4" ) {
					$("#FASEX1").prop("checked", false);
					$("#FASEX2").prop("checked", true);
				}
			}
		});
		
		//가족유형 선택시
		$("#createFamilySUBTY").change(function(){
			var SUBTY = $("#createFamilySUBTY").val();
			//자녀
			if(SUBTY == "2"){
				$("#spanKDBSL").show();
			}else{
				$("#spanKDBSL").hide();
				$("#createFamilyKDBSL").val("");
			}
				
		
		});
		
		$("#familyDetailFGBDT").change(function(){
			$("#detailspanKDBSL").hide();
			$("#familyDetailKDBSL").val("");
			console.log($("#familyDetailFGBDT").val());
			
			var year = $("#familyDetailFGBDT").val().substring(0,4);
			//2017년생 이상만
			if(Number(year) > 2016){
				$("#detailspanKDBSL").show();       					
			}
		
		});
		
		
	});
	
	
	var RegNoSet = function(jumin1 , jumin2){
		$('#createFamilyREGNO').val(jumin1+'-'+jumin2);
		//createFamilyLNMHG
		//createFamilyFNMHG
		$("#createFamilyLNMHG").addClass("readOnly").prop("readonly",true);
		$("#createFamilyFNMHG").addClass("readOnly").prop("readonly",true);
	};	
	
	
	// 주소 grid
	$(function() {
		$("#addrListGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : true,
			paging : true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getAddrList.json",
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
			fields : [
				{ title: "선택", name: "th1", align: "center", width: "5%"
					,itemTemplate: function(_, item) {
						return	$("<input name='chk'>")
								.attr("type", "radio")
								.on("click",function(e){
									showAddrsView("Edit", item);
								});
					}
				},
				{ name : "STEXT", title : "유형", align : "center", type : "text", width: "7%"},
				{ name : "PSTLZ", title : "우편번호", align : "center", type : "text", width: "7%"},
				{ name : "STRAS", title : "주소", align : "left", type : "text", width: "55%"
					,itemTemplate : function(value,storeData){
						return value + " " +storeData.LOCAT
					}
				},
				{ name : "LIVE_TEXT", title : "주거형태", align : "center", type : "text", width: "9%"},
				{ name : "TELNR", title : "전화번호", align : "center", type : "text", width: "12%"}
			]
		});
		
		$("#addrListCreateBtn").click(function(){
			showAddrsView("Add", {});
		});
	});
	
	// 주소 등록/상세 popup
	var showAddrsView = function(dialogType, client) {
		$("#addrsForm").each(function() {
			this.reset();
		})
		$("#addrsSUBTY").val(client.SUBTY);
		$("#addrsLAND1").val(client.LAND1);
		$("#addrsSTEXT").val(client.STEXT);
		$("#addrsPSTLZ").val(client.PSTLZ);
		$("#addrsSTRAS").val(client.STRAS);
		$("#addrsLOCAT").val(client.LOCAT);
		$("#addrsLiveType").val(client.LIVE_TYPE);
		$("#addrsTELNR").val(client.TELNR);
		
		targetItem = client;
		callType = dialogType;
		
		$('#popLayerAddr').popup('show');

	};
	
	$("#addrSave").click(function(){
		if(checkNullField("addrsForm")){
			saveAddrsClient(targetItem, callType === "Add");
			targetItem = null;
			callType = null;
		}
	});

	$("#addrCansel").click(function(){
		$("#popLayerAddr").popup('hide');
	});

	// 주소 등록/수정
	var saveAddrsClient = function(client, isNew) {
	if(addrValidation()){
			$("#LANDX").val = $("#LAND1 option:selected").text();
			$("#LIVE_TEXT").val =  $("#LIVE_TYPE option:selected").text();
			$("#STEXT").val =  $("#SUBTY option:selected").text();
			jQuery.ajax({
				type : 'POST',
				url : '/base/updateAddr.json',
				cache : false,
				dataType : 'json',
				data : $('#addrsForm').serialize(),
				async :true,
				success : function(response) {
					if(response.success){
						alert("저장 되었습니다.");
						$("#addrListGrid").jsGrid("search");
					}else{
						alert("주소상세 저장시 오류가 발생하였습니다. " + response.message);
					}
				}
			});
			$("#addrListGrid").jsGrid("search");
			$("#popLayerAddr").popup('hide');
		}
	};
	
	var addrValidation = function() {
		// 상위주소-60 입력시 길이 제한 
		if( $("#addrsSTRAS").val() != "" && $("#addrsSTRAS").val().length > 60 ){
			$("#addrsSTRAS").value = limitKoText($("#addrsSTRAS").val(), 60);
			alert("상위주소는 한글 30자, 영문 60자 이내여야 합니다.");
			$("#addrsSTRAS").focus();
			$("#addrsSTRAS").select();
			return false;
		}
		
		// 하위주소-40 입력시 길이 제한 
		if( $("#addrsLOCAT").val() != "" && $("#addrsLOCAT").val().length > 40 ){
			$("#addrsLOCAT").val() = limitKoText($("#addrsLOCAT").val(), 40);
			alert("상세주소는 한글 20자, 영문 40자 이내여야 합니다.");
			$("#addrsLOCAT").focus();
			$("#addrsLOCAT").select();
			return false;
		}
		
		if(!phone_check("addrsTELNR")){
			return false;
		}
		
		return true;
	}

	// 연락처 grid
	$(function() {
		$("#contactListGrid").jsGrid({
			height: "auto",
			width: "100%",
			autoload : true,
			paging: false,
			fields: [
				{ title: "자택전화", name: "TELNR", type: "text", align: "center", width: "31%" },
				{ title: "회사전화번호", name: "USRID", type: "text", align: "center", width: "32%" },
				{ title: "핸드폰번호", name: "MPHNID", type: "text", align: "center", width: "32%" }
			],
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getContactList.json",
						dataType : "json"
					}).done(function(response) {
						if(response.success)
							d.resolve(response.storeData);
						else
							alert("조회시 오류가 발생하였습니다. " + response.message);
					});
					return d.promise();
				}
			}
		});
		
		$("#contactCreateBtn").click(function(){
			showContactView();
		});
	});
	
	$("#popLayerContact").dialog({
		autoOpen: false,
		width: 400,
		close: function() {
			$("#contactForm").validate().resetForm();
			$("#contactForm").find(".error").removeClass("error");
		}
	});
	
	// 연락처 등록/상세 popup
	var showContactView = function() {
		var data = $("#contactListGrid").jsGrid("option", "data");
		if(data.length > 0) {
			$("#contactTELNR1").val(data[0].TELNR);
			$("#contactUSRID").val(data[0].USRID);
			$("#contactMPHNID").val(data[0].MPHNID);
		}
		$("#popLayerContact").popup('show');
	};
	
	$("#contactSave").click(function(){
		saveContactClient();
	});
	$("#contactCansel").click(function(){
		$("#popLayerContact").popup('hide');
	});
	
	// 연락처 등록/상세 
	var saveContactClient = function(client, isNew) {
		if(contactValidation()){
			jQuery.ajax({
				type : 'POST',
				url : '/base/updateContact.json',
				cache : false,
				dataType : 'json',
				data : $('#contactForm').serialize(),
				async :false,
				success : function(response) {
					if(response.success){
						alert("저장 되었습니다.");
						$("#contactListGrid").jsGrid("search");
					}else{
						alert("연락처 저장시 오류가 발생하였습니다. " + response.message);
					}
				}
			});
			$("#contactListGrid").jsGrid("search");
			$("#popLayerContact").popup('hide');
		}
	};
	
	var contactValidation = function() {
		if(!phone_check("contactTELNR1")){
			return false;
		}
		if($("#contactUSRID").val() == "") {
			alert("회사전화번호를 입력하시기 바랍니다.");
			$("#contactUSRID").focus();
			return false;
		}
		if(!phone_check("contactUSRID")){
			return false;
		}
		if($("#contactMPHNID").val() == "") {
			alert("핸드폰번호를 입력하시기 바랍니다.");
			$("#contactMPHNID").focus();
			return false;
		}
//		if(!phone_check("contactMPHNID")){
//			return false;
//		}
		return true;
	}

	// 가족사항 grid
	$(function() {
		$("#familyListGrid").jsGrid({
			height: "auto",
			width: "100%",
			autoload : true,
			paging: false,
			fields: [
				{ title: "선택", name: "th1", align: "center", width: "6%"
					,itemTemplate: function(_, item) {
						return	$("<input name='familyChk'>")
						.attr("type", "radio")
						.on("click",function(e){
							showFamilyDetailView(item);
							$("#appLineGrid").jsGrid("search");
						});
					}
				},
				{ title: "유형", name: "ATEXT", type: "text", align: "center", width: "16%" },
				{ title: "성명", name: "LNMHG", type: "text", align: "center", width: "16%"
					, itemTemplate: function(value, storeData) { 
						return value + " " + storeData.FNMHG; 
					}
				},
				{ title: "주민번호", name: "REGNO", type: "text", align: "center", width: "20%"
					,itemTemplate: function(value, storeData) { 
						return addResBar(value);
					}
				},
				{ title: "학력 / 교육기관", name: "STEXT1", type: "text", align: "center", width: "20%"
					,itemTemplate: function(value, storeData) { 
						if(storeData.FASIN == "")
							return value;
						else
							return value + " / " + storeData.FASIN;
					}
				},
				{ title: "직업", name: "FAJOB", type: "text", align: "center", width: "22%" }
			],
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getFamilyList.json",
						dataType : "json"
					}).done(function(response) {
						if(response.success)
							d.resolve(response.storeData);
						else
							alert("조회시 오류가 발생하였습니다. " + response.message);
					});
					return d.promise();
				}
			}
		});
		
		// 가족사항 그리드 상세 클릭시 바인딩
		var showFamilyDetailView = function(client) {
			$("familyDetailForm").each(function(){
				this.reset();
			})
			$("#familyDetailLNMHG").prop("readOnly",true).val(client.LNMHG);
			$("#familyDetailFNMHG").prop("readOnly",true).val(client.FNMHG);
			$("#familyDetailSUBTY").val(client.SUBTY);
			$("#familyDetailREGNO").prop("readOnly",true).val(addResBar(client.REGNO));
			$("#familyDetailKDSVH").removeClass("readOnly").prop("disabled",false).val(client.KDSVH);
			$("#familyDetailFGBDT").removeClass("readOnly").prop("readOnly",false).val(client.FGBDT);
			$('input:radio[name="FASEX"]').removeClass("readOnly").prop("disabled",false);
			$('input:radio[name="FASEX"]:input[value='+client.FASEX+']').prop("checked", true);
			$("#familyDetailFGBOT").removeClass("readOnly").prop("readOnly",false).val(client.FGBOT);
			$("#familyDetailFASAR").removeClass("readOnly").prop("disabled",false).val(client.FASAR);
			$("#familyDetailFGBLD").removeClass("readOnly").prop("disabled",false).val(client.FGBLD);
			$("#familyDetailFASIN").removeClass("readOnly").prop("readOnly",false).val(client.FASIN);
			$("#familyDetailFANAT").removeClass("readOnly").prop("disabled",false).val(client.FANAT);
			$("#familyDetailFAJOB").removeClass("readOnly").prop("readOnly",false).val(client.FAJOB);
			if(client.DPTID == "X") { $("#familyCheckDPTID").prop("checked", true); }else{ $("#familyCheckDPTID").prop("checked", false); }
			if(client.BALID == "X") { $("#familyCheckBALID").prop("checked", true); }else{ $("#familyCheckBALID").prop("checked", false); }
			if(client.HNDID == "X") { $("#familyCheckHNDID").prop("checked", true); }else{ $("#familyCheckHNDID").prop("checked", false); }
			//if(client.CHDID == "X") { $("#familyCheckCHDID").prop("checked", true); }else{ $("#familyCheckCHDID").prop("checked", false); }
			if(client.LIVID == "X") { $("#familyCheckLIVID").prop("checked", true); }else{ $("#familyCheckLIVID").prop("checked", false); }
			if(client.HELID == "X") { $("#familyCheckHELID").prop("checked", true); }else{ $("#familyCheckHELID").prop("checked", false); }
			if(client.FAMID == "X") { $("#familyCheckFAMID").prop("checked", true); }else{ $("#familyCheckFAMID").prop("checked", false); }
			
			$("#familyDetailORGREGNO").val(client.REGNO);
			$("#familyDetailOBJPS").val(client.OBJPS);
			
			$("#supportFamilyLNMHG").val(client.LNMHG);
			$("#supportFamilyFNMHG").val(client.FNMHG);
			$("#supportFamilySUBTY").val(client.SUBTY);
			$("#supportFamilyOBJPS").val(client.OBJPS);
			$("#supportFamilySTEXT").val(client.STEXT);
			$("#supportFamilyREGNO").val(addResBar(client.REGNO));
			$("#supportFamilyATEXT").val(client.ATEXT);
			$("#supportFamilyYEAR").val(client.FGBDT.substring(0, 4));
			$("#supportFamilyMONTH").val(client.FGBDT.substring(5, 7));
			$("#supportFamilyDAY").val(client.FGBDT.substring(8, 10));
			$('input:radio[name="FASEX"]:input[value='+client.FASEX+']').prop("checked", true);
			$("#supportFamilyFGBOT").val(client.FGBOT);
			$("#supportFamilySTEXT1").val(client.STEXT1);
			$("#supportFamilyLANDX").val(client.LANDX);
			$("#supportFamilyFASIN").val(client.FASIN);
			$("#supportFamilyNATIO").val(client.NATIO);
			$("#supportFamilyFAJOB").val(client.FAJOB);
			if(client.DPTID == "X") { $("#supportFamilyDPTID").prop("checked", true); }else{ $("#supportFamilyDPTID").prop("checked", false); }
			if(client.BALID == "X") { $("#supportFamilyBALID").prop("checked", true); }else{ $("#supportFamilyBALID").prop("checked", false); }
			if(client.HNDID == "X") { $("#supportFamilyHNDID").prop("checked", true); }else{ $("#supportFamilyHNDID").prop("checked", false); }
			//if(client.CHDID == "X") { $("#supportFamilyCHDID").prop("checked", true); }else{ $("#supportFamilyCHDID").prop("checked", false); }
			if(client.LIVID == "X") { $("#supportFamilyLIVID").prop("checked", true); }else{ $("#supportFamilyLIVID").prop("checked", false); }
			
			//if(client.SUBTY !="2")  { $("#supportFamilyCHDID").prop("disabled", true); }else{ $("#supportFamilyCHDID").prop("disabled", false); }
			
			//자녀일경우만
			if(client.SUBTY == "2"){
				
				var year = $("#familyDetailFGBDT").val().substring(0,4);
				//2017년생 이상만
				if(Number(year) > 2016){
					$("#detailspanKDBSL").show();
					$("#spanSupportFamilyKDBSL").show();
					$("#familyDetailKDBSL").val(client.KDBSL);
					$("#supportFamilyKDBSL").val($("#familyDetailKDBSL option:selected").text());				
				}else{
					$("#detailspanKDBSL").hide();
					$("#spanSupportFamilyKDBSL").hide();
					$("#familyDetailKDBSL").val("");
					$("#supportFamilyKDBSL").val("");
				}
				
			}else{
				$("#detailspanKDBSL").hide();
				$("#spanSupportFamilyKDBSL").hide();
				$("#familyDetailKDBSL").val("");
				$("#supportFamilyKDBSL").val("");
			}
		};
	});

	// 가족사항 등록
	var createFamilyClient = function() {
		if(createFamilyPopupCheck()){
			if(confirm("신청 하시겠습니까?")){
				$("#createFamilySTEXT").val($("#createFamilySUBTY option:selected").val());
				$("#createFamilyATEXT").val($("#createFamilyKDSVH option:selected").val());
				$("#createFamilySTEXT1").val($("#createFamilyFASAR option:selected").val());
				$("#createFamilyLANDX").val($("#createFamilyFGBLD option:selected").val());
				$("#createFamilyNATIO").val($("#createFamilyFANAT option:selected").val());
				$("#createFamilyJOBID").val("create");
				
				jQuery.ajax({
					type : 'POST',
					url : '/base/createFamily.json',
					cache : false,
					dataType : 'json',
					data : $("#createFamilyForm").serialize(),
					async :false,
					success : function(response) {
						if(response.success){
							alert("저장 되었습니다.");
							$("#createFamilyForm").each(function() {
								this.reset();
							});
						}else{
							alert("가족사항 등록시 오류가 발생하였습니다. " + response.message);
						}
					}
				});
				$("#familyListGrid").jsGrid("search");
				$("#popLayerCreateFamily").popup('hide');
			}
		}
	};
	var checkExistSubty = function(subty) {
		var data = $("#familyListGrid").jsGrid("option", "data");
		for(var i = 0 ; i < data.length ; i ++) {
			if(data[i].SUBTY == subty) {
				return true;
			}
		}
		return false;
	}
	
	var checkExistRegno = function(regno) {
		var data = $("#familyListGrid").jsGrid("option", "data");
		for(var i = 0 ; i < data.length ; i ++) {
			if(data[i].REGNO == regno) {
				return true;
			}
		}
		return false;
	}
	
	// 수정시 원래 주민번호를 제외하고 체크
	var checkExistExcludeOrgRegno = function(regno, orgRegno) {
		var data = $("#familyListGrid").jsGrid("option", "data");
		for(var i = 0 ; i < data.length ; i ++) {
			if(data[i].REGNO != orgRegno && data[i].REGNO == regno) {
				return true;
			}
		}
		return false;
	}
	
	var createFamilyPopupCheck = function() {
		if( checkNull($("#createFamilyForm [name='LNMHG']"), "성(한글)을") == false ) {
			$("#createFamilyForm [name='LNMHG']").focus();
			return false;
		}
		// 성(한글)-40 입력시 길이 제한 
		x_obj = $("#createFamilyForm [name='LNMHG']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 40 ){
			x_obj.value = limitKoText(xx_value, 40);
			alert("성은 한글 20자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		if( checkNull($("#createFamilyForm [name='FNMHG']"), "이름(한글)을") == false ) {
			return false;
		}
		// 이름(한글)-40 입력시 길이 제한 
		x_obj = $("#createFamilyForm [name='FNMHG']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 40 ){
			x_obj.value = limitKoText(xx_value, 40);
			alert("이름은 한글 20자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		if( $("#createFamilyForm [name='SUBTY']")[0].selectedIndex==0 ) {
			alert("가족유형을 선택하세요.");
			$("#createFamilyForm [name='SUBTY']").focus();
			return false;
		} else {
			//배우자, 아버지, 어머니의 경우 동일한 가족유형이 존재할경우 error를 발생시킨다.
			if( $("#createFamilyForm [name='SUBTY']").val() == "1" || $("#createFamilyForm [name='SUBTY']").val() == "11" || $("#createFamilyForm [name='SUBTY']").val() == "12" ) {
				if(checkExistSubty($("#createFamilyForm [name='SUBTY']").val())) {
					alert("기존의 가족 Data 중 동일한 가족유형이 이미 존재합니다.");
					$("#createFamilyForm [name='SUBTY']").focus();
					return false;
				}
			}
		}

		if( checkNull($("#createFamilyForm [name='REGNO']"), "주민등록번호를") == false ) {
			return false;
		}

		if( resno_chk('createFamilyREGNO') == false ) {
			return false;
		}

		//-----------------------------------------------------------------------------------------------------------
		//2002.08.07. 가족사항을 입력시 기존에 등록되어 있는 사람인지를 check하도록 한다.
		//저장 시 주민등록번호를 check하여 동일한 주민등록번호를 가진 가족데이타가 있으면 error를 발생시킨다.
		if(checkExistRegno($("#createFamilyForm [name='REGNO']").val().replace('-', ''))) {
			alert("동일한 주민등록번호를 가진 가족이 이미 존재합니다.");
			$("#createFamilyForm [name='REGNO']").focus();
			$("#createFamilyForm [name='REGNO']").select();
			return false;
		}
		//-----------------------------------------------------------------------------------------------------------

		if( $("#createFamilyForm [name='SUBTY']")[0].selectedIndex != 0 ) { // 배우자일경우 현재 사원과 같은 성별이면 에러메시지..
			if( $("#createFamilyForm [name='SUBTY']").val() == "1" ) {
				chk_bit = "<%= user.e_regno.substring(6, 7) %>";

				regno_bit = $("#createFamilyForm [name='REGNO']").val();
				if( chk_bit == "1" || chk_bit == "3" ) {
					if( regno_bit.substring(7, 8) == "1" || regno_bit.substring(7, 8) == "3" ) {
						alert("배우자의 성별이 본인의 성별과 같아서는 안됩니다.");
						return false;
					}
				} else if( chk_bit == "2" || chk_bit == "4" ) {
					if( regno_bit.substring(7, 8) == "2" || regno_bit.substring(7, 8) == "4" ) {
						alert("배우자의 성별이 본인의 성별과 같아서는 안됩니다.");
						return false;
					}
				}
			}
		}

		if( $("#createFamilyForm [name='KDSVH']")[0].selectedIndex==0 ) {
			alert("관계를 선택하세요.");
			$("#createFamilyForm [name='KDSVH']").focus();
			return false;
		}

		if( checkNull($("#createFamilyForm [name='FGBDT']"), "생년월일을") == false ) {
			return false;
		}
		
		//자녀일경우만
		if($("#createFamilySUBTY").val() == "2"){
			if( checkNull($("#createFamilyForm [name='KDBSL']"), "몇번째 자녀인지") == false ) {
				return false;
			}	
		}

		if(!checkdate($("#createFamilyForm [name='FGBDT']"))) {
			$("#createFamilyForm [name='FGBDT']").focus();
			return false;
		}

		// 출생지-40 입력시 길이 제한 
		x_obj = $("#createFamilyForm [name='FGBOT']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 40 ){
			x_obj.value = limitKoText(xx_value, 40);
			alert("출생지는 한글 20자, 영문 40자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		if( $("#createFamilyForm [name='FASAR']")[0].selectedIndex==0 ) {
			alert("학력을 선택하세요.");
			$("#createFamilyForm [name='FASAR']").focus();
			return false;
		}

		if( $("#createFamilyForm [name='FGBLD']")[0].selectedIndex==0 ) {
			alert("출생국을 선택하세요.");
			$("#createFamilyForm [name='FGBLD']").focus();
			return false;
		}

		// 교육기관-20 입력시 길이 제한 
		x_obj = $("#createFamilyForm [name='FASIN']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 20 ){
			x_obj.value = limitKoText(xx_value, 20);
			alert("교육기관은 한글 10자, 영문 20자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		if( $("#createFamilyForm [name='FANAT']")[0].selectedIndex==0 ) {
			alert("국적을 선택하세요.");
			$("#createFamilyForm [name='FANAT']").focus();
			return false;
		}

		// 직업-24 입력시 길이 제한 
		x_obj = $("#createFamilyForm [name='FAJOB']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 24 ){
			x_obj.value = limitKoText(xx_value, 24);
			alert("직업은 한글 12자, 영문 24자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		// 생년월일
		$("#createFamilyForm [name='FGBDT']").val(removePoint($("#createFamilyForm [name='FGBDT']").val()))
		return true;
	}
	
	// 가족사항 수정
	$("#updateFamilyClientBtn").click(function(){
		if( $("input:radio[name='familyChk']").is(":checked") ){
			if(updateFamilyPopupCheck()){
				if(confirm("수정 하시겠습니까?")){
					// 관계, 학력, 출생국, 국적명을 가져간다.
					$("#familyDetailSTEXT").val($("#familyDetailSUBTY option:selected").val());
					$("#familyDetailATEXT").val($("#familyDetailKDSVH option:selected").val());
					$("#familyDetailSTEXT1").val($("#familyDetailFASAR option:selected").val());
					$("#familyDetailLANDX").val($("#familyDetailFGBLD option:selected").val());
					$("#familyDetailNATIO").val($("#familyDetailFANAT option:selected").val());
					
					jQuery.ajax({
						type : 'POST',
						url : '/base/updateFamily.json',
						cache : false,
						dataType : 'json',
						data : $('#familyDetailForm').serialize(),
						async :false,
						success : function(response) {
							if(response.success){
								alert("저장 되었습니다.");
								$("#familyListGrid").jsGrid("search");
								$("#familyDetailForm").each(function() {
									this.reset();
								});
							}else{
								alert("가족사항 수정시 오류가 발생하였습니다. " + response.message);
							}
						}
					});
				}
			}
		}else{
			alert("수정 대상을 선택하세요");
		}
	});

	var updateFamilyPopupCheck = function() {
		if( checkNull($("#familyDetailForm [name='LNMHG']"), "성(한글)을") == false ) {
			$("#familyDetailForm [name='LNMHG']").focus();
			return false;
		}
		// 성(한글)-40 입력시 길이 제한 
		x_obj = $("#familyDetailForm [name='LNMHG']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 40 ){
			x_obj.value = limitKoText(xx_value, 40);
			alert("성은 한글 20자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		if( checkNull($("#familyDetailForm [name='FNMHG']"), "이름(한글)을") == false ) {
			return false;
		}
		// 이름(한글)-40 입력시 길이 제한 
		x_obj = $("#familyDetailForm [name='FNMHG']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 40 ){
			x_obj.value = limitKoText(xx_value, 40);
			alert("이름은 한글 20자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		if( checkNull($("#familyDetailForm [name='REGNO']"), "주민등록번호를") == false ) {
			return false;
		}

		if( resno_chk('familyDetailREGNO') == false ) {
			return false;
		}

		//-----------------------------------------------------------------------------------------------------------
		//2002.08.07. 가족사항을 입력시 기존에 등록되어 있는 사람인지를 check하도록 한다.
		//저장 시 주민등록번호를 check하여 동일한 주민등록번호를 가진 가족데이타가 있으면 error를 발생시킨다.
		if(checkExistExcludeOrgRegno($("#familyDetailForm [name='REGNO']").val().replace('-', ''), $("#familyDetailForm [name='orgRegno']").val().replace('-', ''))) {
			alert("동일한 주민등록번호를 가진 가족이 이미 존재합니다.");
			$("#familyDetailForm [name='REGNO']").focus();
			$("#familyDetailForm [name='REGNO']").select();
			return false;
		}
		//-----------------------------------------------------------------------------------------------------------

		if( $("#familyDetailForm [name='SUBTY']")[0].selectedIndex != 0 ) { // 배우자일경우 현재 사원과 같은 성별이면 에러메시지..
			if( $("#familyDetailForm [name='SUBTY']").val() == "1" ) {
				chk_bit = "<%= user.e_regno.substring(6, 7) %>";

				regno_bit = $("#familyDetailForm [name='REGNO']").val();
				if( chk_bit == "1" || chk_bit == "3" ) {
					if( regno_bit.substring(7, 8) == "1" || regno_bit.substring(7, 8) == "3" ) {
						alert("배우자의 성별이 본인의 성별과 같아서는 안됩니다.");
						return false;
					}
				} else if( chk_bit == "2" || chk_bit == "4" ) {
					if( regno_bit.substring(7, 8) == "2" || regno_bit.substring(7, 8) == "4" ) {
						alert("배우자의 성별이 본인의 성별과 같아서는 안됩니다.");
						return false;
					}
				}
			}
		}

		if( $("#familyDetailForm [name='KDSVH']")[0].selectedIndex==0 ) {
			alert("관계를 선택하세요.");
			$("#familyDetailForm [name='KDSVH']").focus();
			return false;
		}

		if( checkNull($("#familyDetailForm [name='FGBDT']"), "생년월일을") == false ) {
			return false;
		}

		if(!checkdate($("#familyDetailForm [name='FGBDT']"))) {
			$("#familyDetailForm [name='FGBDT']").focus();
			return false;
		}

		// 출생지-40 입력시 길이 제한 
		x_obj = $("#familyDetailForm [name='FGBOT']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 40 ){
			x_obj.value = limitKoText(xx_value, 40);
			alert("출생지는 한글 20자, 영문 40자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		if( $("#familyDetailForm [name='FASAR']")[0].selectedIndex==0 ) {
			alert("학력을 선택하세요.");
			$("#familyDetailForm [name='FASAR']").focus();
			return false;
		}

		if( $("#familyDetailForm [name='FGBLD']")[0].selectedIndex==0 ) {
			alert("출생국을 선택하세요.");
			$("#familyDetailForm [name='FGBLD']").focus();
			return false;
		}

		// 교육기관-20 입력시 길이 제한 
		x_obj = $("#familyDetailForm [name='FASIN']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 20 ){
			x_obj.value = limitKoText(xx_value, 20);
			alert("교육기관은 한글 10자, 영문 20자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		if( $("#familyDetailForm [name='FANAT']")[0].selectedIndex==0 ) {
			alert("국적을 선택하세요.");
			$("#familyDetailForm [name='FANAT']").focus();
			return false;
		}

		// 직업-24 입력시 길이 제한 
		x_obj = $("#familyDetailForm [name='FAJOB']")[0];
		xx_value = x_obj.value;
		if( xx_value != "" && checkLength(xx_value) > 24 ){
			x_obj.value = limitKoText(xx_value, 24);
			alert("직업은 한글 12자, 영문 24자 이내여야 합니다.");
			x_obj.focus();
			x_obj.select();
			return false;
		}

		// 생년월일
		$("#familyDetailForm [name='FGBDT']").val(removePoint($("#familyDetailForm [name='FGBDT']").val()))
		return true;
	}

	// 가족사항 수정
	$("#deleteFamilyClientBtn").click(function(){
		if( $("input:radio[name='familyChk']").is(":checked") ){
			if( confirm("정말 삭제하시겠습니까?") ) {
				jQuery.ajax({
					type : 'POST',
					url : '/base/deleteFamily.json',
					cache : false,
					dataType : 'json',
					data : $('#familyDetailForm').serialize(),
					async :false,
					success : function(response) {
						if(response.success){
							alert("삭제 되었습니다.");
							$("#familyListGrid").jsGrid("search");
							$("#familyDetailForm").each(function() {
								this.reset();
							});
						}else{
							alert("가족사항 삭제시 오류가 발생하였습니다. " + response.message);
						}
					}
				});
			}
		}else{
			alert("삭제 대상을 선택하세요");
		}
		
	});
	
	// 부양가족여부 신청 팝업
	$("#supportStateCheckBtn").click(function(){
		if( $("input:radio[name='familyChk']").is(":checked") ){
			if( $("#familyCheckDPTID").is(':checked')) {
				alert("부양가족으로 이미 등재되어 있습니다.");
			}else{
				$("#TrLossDate").hide();
				$(".supportFamily").show();
				$('#supportFamilyGUBUN').val("X");
				$('#supportFamilyFAMID').val("");
				$('#supportFamilyUPMUTYPE').val("07");
				$('#popLayerSupportFamily').popup('show');
			}
		}else{
			alert("부양가족 신청 대상을 선택하세요");
		}
		
	});
	
	// 가족수당신청 팝업
	var allowanceFamily = function() {       // 가족수당
		if( $("#familyDetailSUBTY").val() == "1" || 
			( $("#familyDetailSUBTY").val() == "2" && getAge($("#familyDetailREGNO").val()) <= 19 ) ) {    // 배우자, 자녀의 경우만 신청가능..
			
			//  2002.10.31 가족수당이 체크되지 않은 경우에만 가족수당 신청가능
			if( !($("#familyCheckFAMID").is(':checked')) ) {
				$("#TrLossDate").hide();
				$(".supportFamily").hide();
				$('#supportFamilyGUBUN').val(" ");
				$('#supportFamilyFAMID').val("X");
				$('#supportFamilyUPMUTYPE').val("24");
				$('#popLayerSupportFamily').popup('show');
			} else {
				alert("가족수당 신청을 이미 하셨습니다.")
			}
		} else {
			alert("가족수당은 배우자, 자녀(만 20세 미만)의 경우만 신청가능합니다.");
		}
	};
	
	// 가족수당상실 팝업
	var allowanceFamilyCancel = function() {  // 가족수당
		//  2002.10.31 가족수당이 체크된 경우에만 가족수당상실 신청가능
		if( $("#familyCheckFAMID").is(':checked') ) {
			$("#TrLossDate").show();
			$(".supportFamily").hide();
			$('#supportFamilyGUBUN').val(" ");
			$('#supportFamilyFAMID').val("X");
			$('#supportFamilyUPMUTYPE').val("29");
			$('#popLayerSupportFamily').popup('show');
		} else {
			alert("가족수당을 신청한 경우에만 상실신청이 가능합니다.")
		}
	};
	
	// 결재자 목록 grid
	$(function() {
		$("#appLineGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: true,
			autoload: false,
			onDataLoaded: function(args) {
				$("#supportFamilyRowCount").val(this.option("data").length);
			},
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/common/getAppLineList.json",
						dataType : "json",
						data : { "OUPMU_TYPE" : "07" }
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
				{ title: "결제자 구분", name: "APPL_APPU_NAME", type: "text", align: "center", width: "20%" },
				{ title: "<span class='textPink'>*</span>성명", name: "APPL_ENAME", type: "text", align: "center", width: "20%"
					,itemTemplate: function(value, storeData) {
						if(storeData.APPL_APPU_TYPE=="01")
							return $("<input class='jsInputSearch' id='Family"+storeData.APPL_OBJID+"' disabled=true>")
									.attr("type", "text")
									.val(value)
									.add($("<img>")
											.attr({
												src:"/web-resource/images/ico/ico_magnify.png",
												alt:'검색'
											})
											.on("click", function(e) {
												$("#popupMode").val("Family");
												$("#objid").val(storeData.APPL_OBJID);
												showPopLayerAppl(storeData); 
											})
									);
						else
							return value;
					}
				},
				{ title: "부서명", name: "APPL_ORGTX", type: "text", align: "center", width: "20%" },
				{ title: "직 책", name: "APPL_TITL2", type: "text", align: "center", width: "20%" },
				{ title: "연락처", name: "APPL_TELNUMBER", type: "number", align: "center", width: "20%" },
				
				{ name:"APPL_UPMU_FLAG", type: "text", visible: false },
				{ name:"APPL_APPU_TYPE", type: "text", visible: false },
				{ name:"APPL_APPR_TYPE", type: "text", visible: false },
				{ name:"APPL_APPR_SEQN", type: "text", visible: false },
				{ name:"APPL_PERNR", type: "text", visible: false },
				{ name:"APPL_OTYPE", type: "text", visible: false },
				{ name:"APPL_OBJID", type: "text", visible: false },
				{ name:"APPL_STEXT", type: "text", visible: false },
				{ name:"APPL_TITEL", type: "text", visible: false },
				{ name:"APPL_APPU_NUMB", type: "text", visible: false }
			]
		});
	});

	// 부양가족여부 신청
	var requestSupportClient = function() {
		if( requestSupportCheck() ) {
			if($("#supportFamilyDPTID").is(':checked')) $("#supportFamilyDPTID").val("X");
			if($("#supportFamilyBALID").is(':checked')) $("#supportFamilyBALID").val("X");
			if($("#supportFamilyHNDID").is(':checked')) $("#supportFamilyHNDID").val("X");
			if($("#supportFamilyLIVID").is(':checked')) $("#supportFamilyLIVID").val("X");
			//if($("#supportFamilyCHDID").is(':checked')) $("#supportFamilyCHDID").val("X");
			
			if($("#supportFamilyHELID").is(':checked')) $("#supportFamilyHELID").val("X");
			
			$("#supportFamilyREGNO").val(removeResBar($("#supportFamilyREGNO").val()));
			var param = $("#SupportFamilyForm").serializeArray();
			$("#appLineGrid").jsGrid("serialize", param);
			
			
			jQuery.ajax({
				type : 'POST',
				url : '/base/requestSupportFamily.json',
				cache : false,
				dataType : 'json',
				data : param,
				async :false,
				success : function(response) {
					if(response.success){
						alert("신청 되었습니다.");
						$("#familyListGrid").jsGrid("search");
					}else{
						alert("신청시 오류가 발생하였습니다. " + response.message);
					}
				}
			});
			$("#popLayerSupportFamily").popup('hide');
		}
	}
	
	// 부양가족 및 가족수당 신청 관련 validation
	var requestSupportCheck = function() {
		if($('#supportFamilyUPMUTYPE').val() =="29"){
			if($("supportFamilyLOSSDATE").val() == ""){
				return false;
			}
		}
		
		if( $("#supportFamilyRowCount").val() < 1 ){
			alert("결재자 정보가 없습니다.");
			return false;
		}
		
		if(HNFlag){
			//alert("장애인체크됨");
			if($("#supportFamilyHNDCD").val()=="" ){
				alert("장애코드를 선택해주세요.");
				return false;
			}
			if($("#inputDateFrom").val()=="" || $("#inputDateTo").val()=="" ){
				alert("장애(예상)기간을 입력해주세요.");
				return false;
			}  
			
		}else{
			$("#supportFamilyHNDCD").val("");
			$("#inputDateFrom").val("");
			$("#inputDateTo").val("");
		}
		
		return true; 
	}

	// 발령 목록 grid
	$(function() {
		$("#rankChangeGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getRankChangeList.json",
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
				{ title: "발령유형", name: "MNTXT", type: "text", align: "center", width: "12%" },
				{ title: "발령일자", name: "BEGDA", type: "text", align: "center", width: "9%" },
				{ title: "근무지", name: "BTEXT", type: "text", align: "center", width: "15%" },
				{ title: "소속", name: "ORGTX", type: "text", align: "center", width: "21%" },
				{ title: "사원구분", name: "PTEXT", type: "text", align: "center", width: "10%" },
				{ title: "직위", name: "TITEL", type: "text", align: "center", width: "7%" },
				{ title: "직급", name: "TRFGR", type: "text", align: "center", width: "8%" },
				{ title: "직책", name: "TITL2", type: "text", align: "center", width: "8%" },
				{ title: "직무", name: "STLTX", type: "text", align: "center", width: "10%" }
			]
		});
	});

	// 승급사항 grid
	$(function() {
		$("#statusChangeGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getStatusChangeList.json",
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
				{ title: "승급구분", name: "RTEXT", type: "text", align: "center", width: "30%" },
				{ title: "승급일자", name: "BEGDA", type: "text", align: "center", width: "15%" },
				{ title: "직급", name: "TRFGR", type: "text", align: "center", width: "25%" },
				{ title: "호봉", name: "TRFST", type: "text", align: "center", width: "15%" },
				{ title: "년차/생활급", name: "VGLST", type: "text", align: "center", width: "15%" }
			]
		});
	});

	// 학력 grid
	$(function() {
		$("#schoolGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getSchoolList.json",
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
				{ title: "기간", name: "PERIOD", type: "text", align: "center", width: "18%" },
				{ title: "학교명", name: "LART_TEXT", type: "text", align: "center", width: "18%" },
				{ title: "전공", name: "FTEXT", type: "text", align: "center", width: "20%" },
				{ title: "졸업구분", name: "STEXT", type: "text", align: "center", width: "10%" },
				{ title: "소재지", name: "SOJAE", type: "text", align: "left", width: "24%" },
				{ title: "입사시 학력", name: "EMARK", type: "text", align: "center", width: "10%" }
			]
		});
	});

	// 자격면허 grid
	$(function() {
		$("#licenseGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getLicenseList.json",
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
				{ title: "자격면허", name: "LICN_NAME", type: "text", align: "center", width: "19%" },
				{ title: "취득일", name: "OBN_DATE", type: "text", align: "center", width: "12%" },
				{ title: "등급", name: "GRAD_NAME", type: "text", align: "center", width: "12%" },
				{ title: "발행기관", name: "PUBL_ORGH", type: "text", align: "center", width: "16%" },
				{ title: "법정선임사유", name: "ESTA_AREA", type: "text", align: "left", width: "41%" },
				{ name: "LICN_CODE", type: "text", visible: false },
				{ name: "FLAG", type: "text", visible: false }
			]
		});
	});
	
	// 자격면허 등록 결재자 grid
	$(function() {
		$("#licenseAppLineGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: true,
			onDataLoaded: function(args) {
				$("#licenseRowCount").val(this.option("data").length);
			},
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/common/getAppLineList.json",
						dataType : "json",
						data : { "OUPMU_TYPE" : "14" }
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
					{ title: "결제자 구분", name: "APPL_APPU_NAME", type: "text", align: "center", width: "20%" },
					{ title: "<span class='textPink'>*</span>성명", name: "APPL_ENAME", type: "text", align: "center", width: "20%"
						,itemTemplate: function(value, storeData) {
							if(storeData.APPL_APPU_TYPE=="01")
								return $("<input  class='jsInputSearch' id='license"+storeData.APPL_OBJID+"' disabled=true>")
										.attr("type", "text")
										.val(value)
										.add($("<img>")
												.attr({
													src:"/web-resource/images/ico/ico_magnify.png",
													alt:'검색'
												})
												.on("click", function(e) {
													$("#popupMode").val("license");
													$("#objid").val(storeData.APPL_OBJID);
													showPopLayerAppl(storeData); 
												})
										);
							else
								return value;
						}
					},
					{ title: "부서명", name: "APPL_ORGTX", type: "text", align: "center", width: "20%" },
					{ title: "직 책", name: "APPL_TITL2", type: "text", align: "center", width: "20%" },
					{ title: "연락처", name: "APPL_TELNUMBER", type: "number", align: "center", width: "20%" },
					{ name:"APPL_UPMU_FLAG", type: "text", visible: false },
					{ name:"APPL_APPU_TYPE", type: "text", visible: false },
					{ name:"APPL_APPR_TYPE", type: "text", visible: false },
					{ name:"APPL_APPR_SEQN", type: "text", visible: false },
					{ name:"APPL_PERNR", type: "text", visible: false },
					{ name:"APPL_OTYPE", type: "text", visible: false },
					{ name:"APPL_OBJID", type: "text", visible: false },
					{ name:"APPL_STEXT", type: "text", visible: false },
					{ name:"APPL_TITEL", type: "text", visible: false },
					{ name:"APPL_APPU_NUMB", type: "text", visible: false }
					
				]
		});
	});
	
	// 포상 grid
	$(function() {
		$("#rewardGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getRewardList.json",
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
				{ title: "포상항목 - 등급", name: "PRIZ_DESC", type: "text", align: "center", width: "26%"
					,itemTemplate: function(value, storeData) { 
						return value + ((storeData.GRAD_TEXT == "") ? "" : "-"+storeData.GRAD_TEXT); 
					}
				},
				{ title: "수상일자", name: "BEGDA", type: "text", align: "center", width: "10%" },
				{ title: "포상점수", name: "GRAD_QNTY", type: "text", align: "center", width: "14%" },
				{ title: "시상주체", name: "BODY_NAME", type: "text", align: "center", width: "14%" },
				{ title: "포상금액", name: "PRIZ_AMNT", type: "number", align: "right", width: "16%" 
					,itemTemplate: function(value) { 
						return value.format();
					}
				},
				{ title: "수상내역", name: "PRIZ_RESN", type: "text", align: "left", width: "20%" }
			]
		});
	});

	// 징계 grid
	$(function() {
		$("#punishGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getPunishList.json",
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
				{ title: "징계유형", name: "PUNTX", type: "text", align: "center", width: "12%" },
				{ title: "징계일자", name: "BEGDA", type: "text", align: "center", width: "12%" },
				{ title: "징계내역", name: "PUNRS", type: "text", align: "left", width: "76%"
					,itemTemplate: function(value, storeData) { 
						var descText = "<br>" + storeData.TEXT1 + storeData.TEXT2 + storeData.TEXT3;
						return value + descText; 
					}
				}
			]
		});
	});
	
	// 경력 grid
	$(function() {
		$("#careerGrid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/base/getCareerList.json",
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
				{	title: "근무기간", name: "BEGDA", type: "text", align: "center", width: "25%" 
					,itemTemplate: function(value,item) {
						return value + " ~ " + item.ENDDA;
					}
				},
				{	title: "근무처", name: "ARBGB", type: "text", align: "center", width: "25%" },
				{	title: "직위", name: "TITL_TEXT", type: "text", align: "center", width: "25%" },
				{	title: "직무", name: "JOBB_TEXT", type: "text", align: "center", width: "25%" }
			]
		});
	});
	
	
	
	// 어학 grid - TOEIC
	$(function() {
		$("#langTest0001Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0001List").hide();
				}else{
					$("#langTest0001List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "L/C", name: "LISN_SCOR", type: "text", align: "center", width: "25%" },
				{ title: "R/C", name: "READ_SCOR", type: "text", align: "center", width: "25%" },
				{ title: "TOTAL", name: "LAST_FLAG", type: "text", align: "center", width: "25%" 
					,itemTemplate: function(value, item) {
						return "<font color='" + (value == "Y" ? "#FF0000" : "#000000")  + "' >"  + item.TOTL_SCOR + "</font>";
					}
				}
			]
		});
	});

	// 어학 grid - JPT
	$(function() {
		$("#langTest0002Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0002List").hide();
				}else{
					$("#langTest0002List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "L/C", name: "LISN_SCOR", type: "text", align: "center", width: "25%" },
				{ title: "R/C", name: "READ_SCOR", type: "text", align: "center", width: "25%" },
				{ title: "TOTAL", name: "LAST_FLAG", type: "text", align: "center", width: "25%" 
					,itemTemplate: function(value, item) {
						return "<font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.TOTL_SCOR + "</font>";
					}
				}
			]
		});
	});

	// 어학 grid - TOEFL
	$(function() {
		$("#langTest0003Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0003List").hide();
				}else{
					$("#langTest0003List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "Structure", name: "STRU_SCOR", type: "text", align: "center", width: "25%" },
				{ title: "Writing", name: "WRIT_SCOR", type: "text", align: "center", width: "25%" },
				{ title: "TOTAL", name: "LAST_FLAG", type: "text", align: "center", width: "25%" 
					,itemTemplate: function(value, item) {
						return "<font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.TOTL_SCOR + "</font>";
					}
				}
			]
		});
	});

	// 어학 grid - 한어수평고시
	$(function() {
		$("#langTest0004Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0004List").hide();
				}else{
					$("#langTest0004List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "10%" },
				{ title: "청력", name: "HEAR_SCOR", type: "text", align: "center", width: "11%" },
				{ title: "어법", name: "EXPR_SCOR", type: "text", align: "center", width: "11%" },
				{ title: "독해", name: "UNDR_SCOR", type: "text", align: "center", width: "11%" },
				{ title: "종합", name: "SUMM_SCOR", type: "text", align: "center", width: "11%" },
				{ title: "작문", name: "COMP_SCOR", type: "text", align: "center", width: "11%" },
				{ title: "구술", name: "ORAL_SCOR", type: "text", align: "center", width: "11%" },
				{ title: "TOTAL", name: "TOTL_SCOR", type: "text", align: "center", width: "12%" },
				{ title: "등급", name: "LAST_FLAG", type: "text", align: "center", width: "11%" 
					,itemTemplate: function(value, item) {
						return "<font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.LANG_LEVL + "</font>";
					}
				}
			]
		});
	});

	// 어학 grid - 신 HSK
	$(function() {
		$("#langTest0008Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0008List").hide();
				}else{
					$("#langTest0008List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "20%" },
				{ title: "청력", name: "HEAR_SCOR", type: "text", align: "center", width: "16%" },
				{ title: "독해", name: "UNDR_SCOR", type: "text", align: "center", width: "16%" },
				{ title: "작문", name: "COMP_SCOR", type: "text", align: "center", width: "16%" },
				{ title: "TOTAL", name: "TOTL_SCOR", type: "text", align: "center", width: "16%" },
				{ title: "등급", name: "LAST_FLAG", type: "text", align: "center", width: "16%" 
					,itemTemplate: function(value, item) {
						return "<font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.LANG_LEVL + "</font>";
					}
				}
			]
		});
	});

	// 어학 grid - LGA-LAP Oral Test
	$(function() {
		$("#langTest0005Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0005List").hide();
				}else{
					$("#langTest0005List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "Oral Score", name: "STEXT", type: "text", align: "center", width: "75%"
					,itemTemplate: function(value, item) {
						return value + " ( " + "<font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.LGAX_SCOR + "</font>" + " )" ;
					}
				}
			]
		});
	});

	// 어학 grid - LGA-LAP Written
	$(function() {
		$("#langTest0006Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0006List").hide();
				}else{
					$("#langTest0006List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "Written Score", name: "STEXT", type: "text", align: "center", width: "75%"
					,itemTemplate: function(value, item) { 
						return value + " (<font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.LAPX_SCOR + "</font>)";
					}
				}
			]
		});
	});

	// 어학 grid - SEPT
	$(function() {
		$("#langTest0007Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0007List").hide();
				}else{
					$("#langTest0007List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "15%" },
				{ title: "Weighted", name: "SEPT_SCOR", type: "text", align: "center", width: "20%" },
				{ title: "레벨", name: "STEXT", type: "text", align: "center", width: "65%"
					,itemTemplate: function(value, item) { 
						return value + " (<font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.SEPT_LEVL + "</font>)";
					}
				}
			]
		});
	});

	// 어학 grid - TOEIC SPEAKING
	$(function() {
		$("#langTest0009Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0009List").hide();
				}else{
					$("#langTest0009List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "15%" },
				{ title: "점수", name: "TWRI_SCOR", type: "text", align: "center", width: "20%" },
				{ title: "등급", name: "LAST_FLAG", type: "text", align: "center", width: "65%"
					,itemTemplate: function(value, item) { 
						return  " <font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.LANG_LEVL + "</font>";
					}
				}
			]
		});
	});
	
	// 어학 grid - TOEIC WRITING
	$(function() {
		$("#langTest0010Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0010List").hide();
				}else{
					$("#langTest0010List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "15%" },
				{ title: "점수", name: "TSPE_SCOR", type: "text", align: "center", width: "20%" },
				{ title: "등급", name: "LAST_FLAG", type: "text", align: "center", width: "65%"
					,itemTemplate: function(value, item) { 
						return value + " <font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.LANG_LEVL + "</font>";
					}
				}
			]
		});
	});	

	// 어학 grid - OPIC
	$(function() {
		$("#langTest0011Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0011List").hide();
				}else{
					$("#langTest0011List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "등급", name: "LAST_FLAG", type: "text", align: "center", width: "75%"
					,itemTemplate: function(value, item) { 
						return " <font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.OPIC_LEVL + "</font>";
					}
				}
			]
		});
	});

	// 어학 grid - SJPT
	$(function() {
		$("#langTest0012Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0012List").hide();
				}else{
					$("#langTest0012List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "등급", name: "LAST_FLAG", type: "text", align: "center", width: "75%"
					,itemTemplate: function(value, item) { 
						return " <font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.LANG_LEVL + "</font>";
					}
				}
			]
		});
	});
	
	// 어학 grid - TSC
	$(function() {
		$("#langTest0013Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0013List").hide();
				}else{
					$("#langTest0013List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "등급", name: "LAST_FLAG", type: "text", align: "center", width: "75%"
					,itemTemplate: function(value, item) { 
						return  " <font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.LANG_LEVL + "</font>";
					}
				}
			]
		});
	});
	
	
	// 어학 grid - OPIC(chinese)
	$(function() {
		$("#langTest0014Grid").jsGrid({
			width : "100%",
			sorting : true,
			autoload : false,
			paging : true,
			pageSize: 5,
			onDataLoaded: function(args) {
				if(this.option("data").length == 0){
					$("#langTest0014List").hide();
				}else{
					$("#langTest0014List").show();
				}
			},
			fields: [
				{ title: "검정일", name: "BEGDA", type: "text", align: "center", width: "25%" },
				{ title: "등급", name: "LAST_FLAG", type: "text", align: "center", width: "75%"
					,itemTemplate: function(value, item) { 
						return " <font color='" + (value == "Y" ? "#FF0000" : "#000000") + "' >"  + item.OPIC_LEVL + "</font>";
					}
				}
			]
		});
	});
	
	
	
	// 결재자 변경
	var showPopLayerAppl = function(item) {
		$("#popLayerForm").each(function() {
			this.reset();
		});
		$("#applPopupGrid").jsGrid({"data":$.noop}); //초기화 방안 재확인 필요
		
		$("#popLayerAppl").popup('show');
		$("#applPopupGrid").jsGrid({
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "get",
						url : "/common/searchDecisionerList.json",
						dataType : "json",
						data : { 
							 "I_ENAME" : $("#I_ENAME").val()
							,"I_ENAME1" : $("#I_ENAME1").val()
							,"objid" : item.APPL_OBJID
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
			rowClick : function(args){
				var newItem = {
						"APPL_PERNR": args.item.PERNR,
						"APPL_APPU_NUMB": args.item.APPU_NUMB,
						"APPL_APPU_NAME": args.item.APPU_NAME,
						"APPL_ENAME": args.item.ENAME,
						"APPL_ORGTX": args.item.ORGTX,
						"APPL_TITEL": args.item.TITEL,
						"APPL_TITL2": args.item.TITL2,
						"APPL_TELNUMBER": args.item.TELNUMBER
					};
				
				if($("#popupMode").val() == "Family" ){ //부양가족 여부 신청시
					$("#appLineGrid").jsGrid("updateItem", item, newItem).done(function() {
						$("#popLayerAppl").popup('hide');
					});
				}else if($("#popupMode").val() == "Licenses" ){ // 자격면허 등록시
					$("#licenseAppLineGrid").jsGrid("updateItem", item, newItem).done(function() {
						$("#popLayerAppl").popup('hide');
					});
				}
			}
		});
	};
	
	// 결재자 popup 검색 grid
	$(function() {
		$("#applPopupGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: false,
			fields: [
				{
					title: "선택",
					name: "radiobutton",
					itemTemplate: function(_, item) {
						return $("<input>").attr("type", "radio");
					},
					align: "center",
					width: 1
				},
				{ title: "사번",  name: "PERNR", type: "text", align: "center", width: "18%" },
				{ title: "성명",  name: "ENAME", type: "text", align: "center", width: "18%" },
				{ title: "부서명", name: "ORGTX", type: "text", align: "center", width: "28%" },
				{ title: "직위명", name: "TITEL", type: "text", align: "center", width: "18%" },
				{ title: "직책명", name: "TITL2", type: "text", align: "center", width: "18%" }
			]
		});
	});
	
	// 자격면허증 popup 검색
	$(function() {
		$("#licensePopupGrid").jsGrid({
			height: "auto",
			width: "100%",
			paging: true,
			sorting: true,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "post",
						url : "/base/getLicensePopupList.json",
						dataType : "json",
						data : { "LICN_NAME" : $("#popupLicnName").val() }
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
					title: "선택", name: "th1", align: "center", width: "10%",
					itemTemplate: function(_, item) {
						return $("<input>")
								.attr("type", "radio")
								.on("click",function(e){
									$("#licenseLicnCode").val(item.LICN_CODE);
									$("#licenseLicnName").val(item.LICN_NAME);
									$("#popLayerLicense").popup('hide');
								});
					}
				},
				{ title: "자격증 종류", name: "LICN_NAME", type: "text", align: "left", width: "90%" },
				{ name:"LICN_CODE", type:"text", visible: false },
				{ name:"LICN_NAME", type:"text", visible: false }
			]
		});
	});
</script>
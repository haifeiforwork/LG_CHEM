<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>LG MMA</title>
<!-- basic -->
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_jquery.css" />
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-1.9.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-ui-1.10.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/common.js"></script>
<script type="text/javascript">
var AINF_SEQN = "<c:out value="${AINF_SEQN}"/>";

$(document).ready(function(){
		$.ajax({
			type : "get",
			url : "/appl/getEventMoneyDetail.json",
			dataType : "json",
			data : {
				"AINF_SEQN" : AINF_SEQN
			}
		}).done(function(response) {
			if (response.success) {
				var arr = $.makeArray({"CONG_CODE":response.E19CongCode});
				setTableText(response.user, "printForm");
				setTableText(response.storeData, "printForm", arr);
				//2017.01.06 불필요한 로직이라 삭제요청. 요청자 : LGMMA 홍성민
				/*
				if( response.storeData.CONG_CODE == "0003" && (response.storeData.RELA_CODE == "0002" || response.storeData.RELA_CODE == "0003") ) {
		        	$("[name='HOLI_CONT']").text("Help 참조");
				}*/
				
				$("#hiddenPrint",parent.document.body).html($(document.body).html());
			} else
				alert("상세정보 조회시 오류가 발생하였습니다. " + response.message);
		});

});
</script>
</head>
<body>
<div class="printForm" id="printForm">
<table class="appTB">
  <tr>
    <th>담당자</th>
    <th>책임자</th>
  </tr>
  <tr>
    <td></td>
    <td></td>
  </tr>
</table>
<div class="clear"> </div>
<div class="printTitle">경조금 신청서</div>
<div class="tableTitle">1. 신청자</div>
<table class="printTB printbd">
  <colgroup>
  <col width="25%"/>
  <col width="25%"/>
  <col width="25%"/>
  <col width="25%"/>
  </colgroup>
  <tr>
    <th>사번</th>
    <th>성명</th>
    <th>소속</th>
    <th>전화번호</th>
  </tr>
  <tr>
    <td name="empNo" class="txtcenter"></td>
    <td name="ename" class="txtcenter"></td>
    <td name="e_orgtx" class="txtcenter"></td>
    <td name="e_phone_num" class="txtcenter"></td>
</table>
<div class="tableTitle">2. 신청 내역</div>
<table class="printTB printbd">
  <colgroup>
  <col width="25%"/>
  <col width="25%"/>
  <col width="25%"/>
  <col width="25%"/>
  </colgroup>
  <tr>
    <th>신청 일자</th>
    <td colspan="3" name="BEGDA" format="dateB"></td>
  </tr>
  <tr>
    <th>경조내역</th>
    <td name="CONG_CODE" format="replace" code="code" codeNm="value"></td>
    <th>지급금액</th>
    <td name="CONG_WONX" format="curWon"></td>
  </tr>
  <tr>
    <th>경조 대상자</th>
    <td name="EREL_NAME"></td>
    <th>경조휴가</th>
    <td name="HOLI_CONT" format="daysKR"></td>
  </tr>
  <tr>
    <th>경조 발생일자</th>
    <td name="CONG_DATE"></td>
    <th>근속년수</th>
    <td><font name="WORK_YEAR"></font>년 <font name="WORK_MNTH"></font>개월</td>
  </tr>
</table>
<div class="tableTitle">3. 지급기준</div>
<div class="numberList">
  <ul>
    <li>① 계산상에 있어서 1,000원 미만의 단수는 절상함.</li>
    <li>② 경조사 발생 3개월 이내에 청구한 자에 한해서 경조비를 지급토록 함.</li>
    <li>③ 여자사원으로서 결혼을 이유로 퇴사한 자가 2개월 이내에 결혼할 때에는 이 기준에 의하여<br>
    &nbsp;&nbsp;&nbsp;&nbsp;지급을 받을 수 있음.</li>
    <li>④ 근속년수 1년 미만자에게는 지급율의 50%를 지급함.</li>
    <li>⑤ 경조휴가 사용은 경조사유 발생일 기준으로 사용함을 원칙으로 하며, 개인 사정이 있을 경우<br>
    &nbsp;&nbsp;&nbsp;&nbsp;<font color="red">부서장 승인 후</font> 1개월 이내에 사용토록 함.</li>
    <li>⑥ 휴가기간 중의 휴일은 휴가일수에 산입하지 아니한다. <u>단, 6일 이상의 경조휴가 기간 중</u><br>
    &nbsp;&nbsp;&nbsp;&nbsp;유급 휴일인 <u>토요일이 포함되어 있을 때에는</u> 이를 <u>경조휴가일수에 포함하므로</u><br>
    &nbsp;&nbsp;&nbsp;&nbsp;휴가기간 입력 시 반드시 토요일을 포함하여 시작일, 종료일을 입력해야 함.</li>
    <li>⑦ 본인 재혼시의 경조금 지급율은 초혼시 기준에 준한다.</li>
  </ul>
</div>
<div class="tableTitle">4. 제출서류</div>
<table class="printTB">
  <colgroup>
  <col width="25%"/>
  <col width="75%"/>
  </colgroup>
  <tr>
    <th>구분</td>
    <th>제출서류</th>
  </tr>
  <tr>
    <td rowspan="2" class="txtcenter">결혼</td>
    <td>* 가족관계증명서 또는 주민등록등본</td>
  </tr>
  <tr>
    <td>* 청첩장</td>
  </tr>
  <tr>
    <td class="txtcenter">회갑</td>
    <td>* 가족관계증명서 또는 주민등록등본</td>
  </tr>
  <tr>
    <td rowspan="2" class="txtcenter">조위</td>
    <td>* 가족관계증명서 또는 주민등록등본</td>
  </tr>
  <tr>
    <td>* 부고장 또는 사망진단서</td>
  </tr>
</table>
<div class="tableTitle">5. 담당자</div>
<div class="numberList">
  <ul>
    <li>인사노경팀 이혜정 사원 (061-688-2521)</li>
    <li>경영지원팀 박진희 사원 (02-6930-3811)</li>
  </ul>
</div>
</body>
</html>
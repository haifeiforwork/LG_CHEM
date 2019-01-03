<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="hris.E.E21Expense.E21ExpenseData"%>

<%
	WebUserData userData = (WebUserData) (request.getSession().getValue("user"));
	E21ExpenseData e21ExpenseData = (E21ExpenseData)request.getAttribute("e21ExpenseData");
	
	double currencyDecimalSize  = 2;
    double currencyDecimalSize1 = 2;
    int    currencyValue  = 0;
    int    currencyValue1 = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e21ExpenseData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
        
        if( e21ExpenseData.WAERS1.equals(codeEnt.code) ){
            currencyDecimalSize1 = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue  = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
    currencyValue1 = (int)currencyDecimalSize1; //???  KRW -> 0, USDN -> 5

%>

<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<body>
<div class="printForm">
<div class="printTitle">학자금·장학금 신청서</div>
<div class="tableTitle">1. 신청자</div>
<table class="printTB">
  <tr> 
    <th width="25%">사번</th>
    <th width="25%">성명</th>
    <th width="25%">소속</th>
    <th width="25%">전화번호</th>
  </tr>
  <tr> 
    <td class="txtcenter"><%= userData.empNo %>&nbsp;</td>
    <td class="txtcenter"><%= userData.ename %>&nbsp;</td>
    <td class="txtcenter"><%= userData.e_orgtx %>&nbsp;</td>
    <td class="txtcenter"><%= userData.e_phone_num %>&nbsp;</td>
  </tr>
</table>
<div class="tableTitle">2. 지급대상자</div>
<table class="printTB">
  <tr> 
    <th>신청일자</th>
    <td colspan="3"> 
      <%= e21ExpenseData.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(e21ExpenseData.BEGDA) %>
    </td>
  </tr>
  <tr> 
    <th>가족선택</th>
    <td colspan="3">
        <%= e21ExpenseData.ATEXT %>
    </td>
  </tr>
  <tr> 
    <th width="15%">신청유형</th>
    <td width="35%"><%= e21ExpenseData.SUBF_TYPE.equals("2")? "학자금(중/고등학교)" : "장학금(대학교)" %></td>
    <th width="15%">신청년도</th>
    <td width="35%"><%= e21ExpenseData.PROP_YEAR %></td>
  </tr>
  <tr> 
    <th>신청구분</th>
    <td>
      <input type="radio" name="radiobutton" value="신규분" <%= e21ExpenseData.PAY1_TYPE.equals("X") ? "checked" : "" %> disabled>
      신규분 
      <input type="radio" name="radiobutton" value="추가분" <%= e21ExpenseData.PAY2_TYPE.equals("X") ? "checked" : "" %> disabled>
      추가분
    </td>
    <th>신청분기ㆍ학기</th>
    <td><%= e21ExpenseData.SUBF_TYPE.equals("2") ? (e21ExpenseData.PERD_TYPE.equals("0") ? "" : e21ExpenseData.PERD_TYPE + "분기") : (e21ExpenseData.HALF_TYPE.equals("0") ? "" : e21ExpenseData.HALF_TYPE + "학기") %></td>
  </tr>
  <tr> 
    <th>이름</th>
    <td colspan="3"><%=e21ExpenseData.LNMHG.trim()%><%=e21ExpenseData.FNMHG.trim()%></td>
  </tr>
  <tr> 
    <th>학력</th>
    <td colspan="3">
      <%= e21ExpenseData.STEXT %>
    </td>
  </tr>
  <tr> 
    <th>교육기관</th>
    <td>
      <%= e21ExpenseData.FASIN %>
    </td>
    <th>학년</th>
    <td><%= e21ExpenseData.ACAD_YEAR.equals("0") ? "" : e21ExpenseData.ACAD_YEAR + "학년" %></td>
  </tr>
  <tr> 
    <th>신청액</th>
    <td>
      <%= WebUtil.printNumFormat(e21ExpenseData.PROP_AMNT,currencyValue) %> 
      <%= e21ExpenseData.WAERS %>
    </td>
    <th>수혜횟수</th>
    <td><%= WebUtil.printNumFormat(e21ExpenseData.P_COUNT).equals("0") ? "" : WebUtil.printNumFormat(e21ExpenseData.P_COUNT) + "회" %></td>
  </tr>
  <tr> 
    <th>입학금</th>
    <td colspan="3">
      <input type="checkbox" name="ENTR_FIAG" value="X" size="20" class="input04" <%= e21ExpenseData.ENTR_FIAG.equals("X") ? "checked" : "" %> disabled>
    </td>
  </tr>
</table>
<div class="tableTitle">3. 지급기준 및 범위</div>
<div class="numberList">
   <ul>
		<li>1) 학자금(중, 고)
			<ul>
				<li>① 지급내역 : 입학금, 수업료, 학교운영지원비, 학생회비</li>
				<li>② 증빙서류 : 등록금 납입영수증 원본</li>
				<li>③ 수혜회수 : 자녀 1인당 잔여학기 범위내 중.고 포함해서 총 24회로 함</li>
			</ul>
		</li>
		<li>2) 장학금(대학교)
			<ul>
				<li>① 지급내역 : 입학금(1회만 지급), 수업료, 기성회비, 학생회비</li>
				<li>② 대상자녀 : 전문대이상(방통대, 개방대, 각종대학 제외, 전국정규 4년제 대학교<br>&nbsp;&nbsp;&nbsp;&nbsp;(야간분교만 포함)의 재학생으로서 해당학기 평균성적이 D0 이상인 자녀</li>
				<li>③ 수혜회수 : 자녀 1인당 잔여학기 범위내 최대 8회로 함</li>
				<li>④ 장학금을 수령한 후 학기중 해당학기 이수가 인정되지 않는 휴학, 퇴학, 정학,<br>&nbsp;&nbsp;&nbsp;&nbsp;성적미달(D0이하)인 경우 사유발생일 30일 이내에 회사에 해당사실 통보 및 <br>&nbsp;&nbsp;&nbsp;&nbsp;장학금 전액을 반납하여야 하며 이를 위반할 시 징계위원회 회부 및 장학금 지급을 중지함</li>
				<li>⑤ 증빙서류 : 등록금(입학금)납입영수증 원본, 성적증명서</li>
			</ul>
		</li>
	</ul>
</div>
<table class="printSG">
  <tr>
    <td>신청일 : <%= e21ExpenseData.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate((e21ExpenseData.BEGDA)).substring(0,4) %> 년 <%= e21ExpenseData.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate((e21ExpenseData.BEGDA)).substring(5,7) %> 월 <%= e21ExpenseData.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate((e21ExpenseData.BEGDA)).substring(8,10) %> 일 </td>
  </tr>
  <tr>
    <td>신청자 : <%= userData.ename %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</td>
  </tr>
</table>
</div>
</body>
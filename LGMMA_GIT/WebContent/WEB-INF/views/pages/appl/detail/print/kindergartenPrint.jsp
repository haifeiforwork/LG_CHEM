<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="hris.E.E21Entrance.E21EntranceData"%>
<%
	WebUserData user = (WebUserData) (request.getSession().getValue("user"));
	
	/* 자녀 레코드를 vector로 받는다*/
	Vector          e21EntranceData_vt = (Vector)request.getAttribute("e21EntranceData_vt");
	E21EntranceData data               = (E21EntranceData)e21EntranceData_vt.get(0);
	
	/* 입학축하금 입력된 결제정보를 vector로 받는다*/
	Vector    AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
	
	String Currency = data.WAERS;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>LG MMA</title>
<!-- basic -->
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_jquery.css" />
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-1.9.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-ui-1.10.0.js"></script>
</head>
<div class="printForm">
<div class="printTitle">유치원비 신청서</div>
<div class="tableTitle">1. 신청자</div>
<table class="printTB">
  <tr> 
    <th width="25%">사&nbsp;&nbsp;번</th>
    <th width="25%">성&nbsp;&nbsp;명</th>
    <th width="25%">소&nbsp;&nbsp;속</th>
    <th width="25%">전화번호</th>
  </tr>
  <tr> 
    <td class="txtcenter"><%= user.empNo %>&nbsp;</td>
    <td class="txtcenter"><%= user.ename %>&nbsp;</td>
    <td class="txtcenter"><%= user.e_orgtx %>&nbsp;</td>
    <td class="txtcenter"><%= user.e_phone_num %>&nbsp;</td>
  </tr>
</table>
<div class="tableTitle">2. 지급대상자</div>
<table class="printTB">
  <tr> 
    <th width="20%">신청일자</th>
    <td width="80%"> 
      <%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>
    </td>
  </tr>
  <tr> 
    <th>가족선택</th>
    <td>
       <%= data.ATEXT %>
    </td>
  </tr>
  <tr> 
    <th>이름</th>
    <td><%= data.LNMHG.trim() %><%= data.FNMHG.trim() %></td>
  </tr>
  <tr>
    <th>주민등록번호</th>
    <td><%= DataUtil.addSeparate(data.REGNO) %></td>
  </tr>
  <tr> 
    <th>학력</th>
    <td>
      <%= data.STEXT %>
    </td>
  </tr>

  <tr> 
    <th>교육기관</th>
    <td>
      <%= data.FASIN %>
    </td>
  </tr>

  <tr> 
    <th>유치원비</th>
    <td>
      <%= WebUtil.printNumFormat(data.PROP_AMNT) %> &nbsp;&nbsp;
      <%= Currency %>    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type="radio" name="REQU_MNTH" value="1" <%= data.REQU_MNTH.equals("01") ? "checked" : "" %> disabled>1개월
    <input type="radio" name="REQU_MNTH" value="2" <%= data.REQU_MNTH.equals("02") ? "checked" : "" %> disabled>2개월
    <input type="radio" name="REQU_MNTH" value="3" <%= data.REQU_MNTH.equals("03") ? "checked" : "" %> disabled>3개월
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
			<td class="txtright"><%= WebUtil.printNumFormat(data.PROP_AMT1) %></td>
			<th>2개월</th>
			<td class="txtright"><%= WebUtil.printNumFormat(data.PROP_AMT2) %></td>
			<th>3개월</th>
			<td class="txtright"><%= WebUtil.printNumFormat(data.PROP_AMT3) %></td>
		</tr>
		</tbody>
	</table>
    </td>
  </tr>
  <tr> 
    <th>시작일</th>
    <td><%= data.REQU_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.REQU_DATE) %>

    </td>
  </tr>
  <tr> 
    <th>회사지원액</th>
    <td>
    <%= WebUtil.printNumFormat(data.PAID_AMNT) %> &nbsp;&nbsp;
    <%= Currency %>
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
			<td class="txtright"><%= WebUtil.printNumFormat(data.PAID_AMT1) %></td>
			<th>2개월</th>
			<td class="txtright"><%= WebUtil.printNumFormat(data.PAID_AMT2) %></td>
			<th>3개월</th>
			<td class="txtright"><%= WebUtil.printNumFormat(data.PAID_AMT3) %></td>
		</tr>
		</tbody>
	</table>
    </td>
  </tr>
</table>	
<div class="tableTitle">3. 지급기준 및 범위</div>
<div class="numberList">
   <ul>
    <li>① 지급내역 : 수업료</li>
    <li>② 증빙서류 : 교육비 납입영수증 원본</li>
    <li>③ 지급시기 : 자녀 1인당 한해만 지원</li>
    <li>④ 지급금액 : 신청금액의 50% 지원 (월 52,520원 한도)</li>
  </ul>
</div>
<table class="printSG">
  <tr> 
    <td>신청일 : <%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate((data.BEGDA)).substring(0,4) %> 년 <%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate((data.BEGDA)).substring(5,7) %> 월 <%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate((data.BEGDA)).substring(8,10) %> 일 </td>
  </tr>
  <tr> 
    <td>신청자 : <%= user.ename %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</td>
  </tr>
</table>
</div>
</body>
</html>
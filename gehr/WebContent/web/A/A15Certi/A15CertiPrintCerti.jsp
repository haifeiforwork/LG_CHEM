<%/********************************************************************************/
/*   Update       : 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/**********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.A.A15Certi.*" %>

<%@ page import="hris.common.*" %>
<%
	WebUserData user = WebUtil.getSessionUser(request);

	PersonData phonenum  = (PersonData) request.getAttribute("PersInfoData");
	//out.println("phonenum:"+phonenum.toString());
	Vector T_RESULT    = (Vector)request.getAttribute("T_RESULT");
	String E_JUSO_TEXT = (String)request.getAttribute("E_JUSO_TEXT");
	String E_KR_REPRES = (String)request.getAttribute("E_KR_REPRES");

	A15CertiData data = (A15CertiData)T_RESULT.get(0);
%>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=8">
	<title>LG화학-On-Line 재직증명서</title>
	<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
	<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
	<SCRIPT LANGUAGE="JavaScript">
		function setDefault() {
			//factory.printing.header       = "";
			//factory.printing.footer       = "";
			//factory.printing.portrait     = true;
			//factory.printing.leftMargin   = 1.5;
			//factory.printing.topMargin    = 30;
			//factory.printing.rightMargin  = 1.5;
			//factory.printing.bottomMargin = 3;
		}

		function f_print(){
			//factory.printing.Print(false, window);

			parent.beprintedpage.focus();
			parent.beprintedpage.print();
//  본인발행 1회 인쇄 여부를 설정한다.
			parent.opener.document.form1.PRINT_END.value = "X";
			parent.close();

		}
		function close() {
			parent.opener.document.form1.PRINT_END.value = "X";
			parent.close();
		}
	</SCRIPT>
	<style>
		body {background:#e2e2e2;   font: 12px/1.5em dotum, '돋움', Arial, Helvetica, sans-serif; color: #222; line-height:1.4; padding-bottom:20px;}
		.mainWrapper {margin:20px; padding:40px; border:1px solid #ccc; background:#fff;}
		.innerBox {border:2px solid #bbb; padding:30px 40px;}
		.title {font-size:30px; text-align:center; font-weight:bold; padding:45px 0 30px;}
		.header {position:relative;}
		.header img {position:absolute; top:0; left:0px;}
		.header span {position:absolute; top:40px; left:0; text-align:right; color:#666; font-size:11px; }
		table.info {width:100%; margin:20px auto 40px; font-size:12px; line-height:2;}
		table.info th, table.info td {padding:10px 0; vertical-align:top; line-height:1.4;}
		table.info th {width:100px; text-align:right; font-weight:bold; padding-right:8px;}
		table.info td {padding-left:20px; word-break:keep-all; color:#555;}

		.footer {text-align:center;}
		.footer p {margin:5px 0;}
		.footer .coInfo {text-align:right; }
		.footer .coInfo div {margin-top:25px; position:relative;}
		.footer .coInfo div p {font-size:14px;}
		.footer .coInfo div img {position:absolute; right:-42px; bottom:-26px;}
		span.lgRed {color:#c8294b !important;}
		span.comment {font-size:11px; letter-spacing:-1; color:#777; position:relative; top:6px;}
	</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"   oncontextmenu="return true" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()" onload="//setDefault();//f_print();">

<form name="form1" method="post" action="">

	<div class="mainWrapper" style="margin-top: 50px;">
		<div class="innerBox">
			<!--제목부분-->
			<div class="header">
				<h1 class="title">재직증명서</h1>
				<img src="<%= WebUtil.ImageURL %>img_logopay_hwahak.gif" style="text-align: left;">
				<div class="logo">
					<span>엘화 제 <%= data.PUBLIC_NUM.equals("") ? "" : data.PUBLIC_NUM.substring(0,4) + "-" + data.PUBLIC_NUM.substring(4,9) %> 호</span>
				</div>
			</div>

			<!--본문-->
			<div>
				<table class="info" cellspacing="0">
					<tr>
						<th>성명</th>
						<td><%= phonenum.E_ENAME %></td>
					</tr>
					<tr>
						<th>생년월일</th>
						<td><%= phonenum.E_GBDAT.equals("") ? "" : WebUtil.printDate(phonenum.E_GBDAT, ".") %></td>
					</tr>
					<tr>
						<th>주소</th>
						<td>
							<%= data.ADDRESS1 %>
							<%
								if( !data.ADDRESS2.equals("") ) {
							%>
							&nbsp;<%= data.ADDRESS2 %>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<th>소속</th>
						<td>
							<%
								if( !data.ORGTX_E2.equals("") ) {
							%>
							<%= data.ORGTX_E %><%=data.ORGTX_E2.equals("")? "" :"<br><br>"+data.ORGTX_E2 %>
							<%  }else{
							%>
							<%= data.ORGTX_E %>
							<%
								}
							%>
						</td>
					</tr>
                     <tr>
						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
						<%--<th>직위</th>
						      <td><%= data.TITEL %></td>
						--%>
							<th>직책/직급호칭</th>
							<td><%=data.TITEL.equals("책임") &&  !data.TITL2.equals("") ? data.TITL2 : data.TITEL %></td>
						<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                    </tr>
					<tr>
						<th>담당업무</th>
						<td><%= data.STELLTX %></td>
					</tr>
					<tr>
						<th>입사일자</th>
						<td><%= data.ENTR_DATE.equals("") ? "" : WebUtil.printDate(data.ENTR_DATE,". ") %></td>
					</tr>
					<tr>
						<th>용도</th>
						<td><%= data.USE_PLACE %></td>
					</tr>
				</table>
			</div>

			<!-- 하단 -->
			<div class="footer">
				<p>상기 사실을 증명함</p>
				<%= DataUtil.getCurrentDate().substring(0,4) + "년 " + DataUtil.getCurrentDate().substring(4,6) + "월 " + DataUtil.getCurrentDate().substring(6,8) + "일" %>
				<div class="coInfo">
					<div>
						<span><%= E_JUSO_TEXT %></span>
						<p>주식회사 LG화학</p>
						<%
							String l_ename = "";
							if( E_KR_REPRES.length() == 3 ) {
								l_ename = E_KR_REPRES.substring(0,1) + "&nbsp;&nbsp;" + E_KR_REPRES.substring(1,2) +  "&nbsp;&nbsp;" + E_KR_REPRES.substring(2,3);
							} else {
								l_ename = E_KR_REPRES;
							}
						%>
						<p>대표이사 <strong><%= l_ename %></strong></p>
						<img src="<%= WebUtil.ImageURL %>doDojang.png;" />
					</div>
				</div>
			</div>
		</div>
		<span class="comment">※ 본 서류는 외부기관 제출용 증빙서류로서, 당사의 On-Line 인사 시스템을 통해 발급되었습니다.</span><br/>
		<span class="comment lgRed">※ 용도 외 사용을 금합니다.</span>
	</div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
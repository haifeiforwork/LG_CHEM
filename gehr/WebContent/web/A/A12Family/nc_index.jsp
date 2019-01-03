<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.Vector" %>
<%
	String sJumin1 = request.getParameter("jumin1");
	String sJumin2 = request.getParameter("jumin2");
	//String sName = new String(request.getParameter("name").getBytes("8859_1"),"KSC5601");
	String sName =  request.getParameter("name") ;
%>
<html>
<head>
<title>▒ <spring:message code="LABEL.A.A12.0048" /><!-- 실명확인 페이지 -->2 </title>
<meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
</head>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<table width=650 height=470 cellpadding=0 cellspacing=0 border=0>
	<form name="form1" method="post">
		<tr>
			<td height="20" align=center valign=top bgcolor=#FFFFFF>&nbsp;</td>
		</tr>

		<tr>
		    <td align=center valign=top bgcolor=#FFFFFF>
				<table width="583" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td  height="20" ></td>
					</tr>

					<tr>
						<td colspan = 2 style='font-size:15pt'>
							<b><회원가입></b>
						</td>
					</tr>

					<tr>
						<td  height="20" ></td>
					</tr>

					<tr>
						<td style='width:100;font-size:9pt;height:18'>
							*<spring:message code="LABEL.A.A12.0003" /><!-- 주민등록번호 -->
						</td>
						<td>
							<input name="juminid1" type="text"  size="6" maxlength=6  style='font-size:9pt;height:18' readonly value="<%=sJumin1%>"> - <input name="juminid2" type="text" size="7"  maxlength=7  style='width:68;font-size:9pt;height:18' readonly value="<%=sJumin2%>">
						</td>
					</tr>
					<tr>
						<td style='font-size:9pt;height:18'>
							*<spring:message code="LABEL.COMMON.0010" /><!-- 이름 -->
						</td>
						<td>
							<input name="name" type="text"  size="20"  maxlength=6 style='font-size:9pt;height:18' readonly value="<%=sName%>">
						</td>
					</tr>

					<tr>
						<td>
							*<spring:message code="LABEL.A.A12.0049" /><!-- 아이디 -->
						</td>
						<td>
							<input name="id" type="text" size="10"  maxlength=6 style='font-size:9pt;height:18'>
						</td>
					</tr>

					<tr>
						<td>
							*<spring:message code="LABEL.A.A12.0050" /><!-- 패스워드 -->
						</td>
						<td>
							<input name="passwd" type="text" size="10"  maxlength=6 style='font-size:9pt;height:18'>
						</td>
					</tr>

					<tr>
						<td>
							*<spring:message code="TAB.COMMON.0004" /><!-- 주소 -->
						</td>
						<td>
							<input name="addr" type="text"  size="30"  maxlength=30 style='font-size:9pt;height:18'>
						</td>
					</tr>

					<tr>
						<td>
							*<spring:message code="MSG.A.A13.014" /><!-- 전화번호 -->
						</td>
						<td>
							<input name="tel" type="text"  size="15" maxlength=15 style='font-size:9pt;height:18'>
						</td>
					</tr>

				</table>
			</td>
		</tr>

		<tr>
		  	<td height="20"></td>
		</tr>
	</form>
</table>
</body>
</html>


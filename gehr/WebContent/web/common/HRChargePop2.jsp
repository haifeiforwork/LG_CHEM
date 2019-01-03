<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사담당자 확인                                                        */
/*   Program Name : 인사담당자 확인                                                 */
/*   Program ID   : HRChargePopup.jsp                                      */
/*   Description  : 인사담당자 확인                                            */
/*   Note         :                                                             */
/*   Creation     : 2016-04-12     [CSR ID:3035111] 인사정보 확인기능 수정요청의 件                                         */
/*                                                    */
/********************************************************************************/%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>


<head>
<title>사업장별 인사담당자 List</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init()">
<form name="form1" method="post" onsubmit="return false">
<div class="winPop dvMinheight">
	<div class="header">
		<span><spring:message code='LABEL.COMMON.0028' /><!-- 각 사업장 담당자 List --> </span>
		<a href="javascript:window.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" alt="팝업닫기" /></a>
	</div>
	<div class="body">
			<div class="content">
				<div class="listArea">
					<div class="table">
						<table class="listTable">
							<thead>
								<tr>
									<th width="20%"><spring:message code='MSG.APPROVAL.0012' /><!-- 구분 --></th>
									<th width="50%"><spring:message code='LABEL.COMMON.0029' /><!-- 소속 --></th>
									<th width="30%" class="lastCol" ><spring:message code='LABEL.COMMON.0016' />/<spring:message code='MSG.APPROVAL.0014' /><!-- 담당자/직위 --></th>
								</tr>
							</thead>
							<tbody>
							<tr align="center">
								<td class="td04" rowspan="2">본사/해외<br>지방영업소</td>
								<td class="td04">인사기획팀</td>
								<!-- [CSR ID:3187400] 인사정보 확인기능 수정요청의 件  -->
								<td class="td04">박난이 대리</td>
							</tr>
							<tr align="center">
								<td class="td04">인재확보팀</td>
								<td class="td04">유혜미 사원</td>
							</tr>
							<tr align="center">
								<td class="td04" rowspan="2">대전</td>
								<td class="td04" rowspan="2">기술연구원.대전.인사지원팀</td>
								<td class="td04">김진경 사원</td>
							</tr>
							<tr align="center">
								<td class="td04">장유리 사원</td>
							</tr>
							<tr align="center">
								<td class="td04" rowspan="2">오창</td>
								<td class="td04" rowspan="2">오창.인사지원팀</td>
								<td class="td04">지선혜 대리</td>
							</tr>
							<tr align="center">
								<td class="td04">함나경 사원</td>
							</tr>
							<tr align="center">
								<td class="td04">청주</td>
								<td class="td04">청주.인사지원팀</td>
								<td class="td04">최은숙 사원</td>
							</tr>
							<tr align="center">
								<td class="td04">과천</td>
								<td class="td04">기술연구원.과천.인사지원P</td>
								<td class="td04">김선주 사원</td>
							</tr>
							<tr align="center">
								<td class="td04">파주</td>
								<td class="td04">LCD유리.경영지원.인사지원P</td>
								<td class="td04">윤미라 사원</td>
							</tr>
							<tr align="center">
								<td class="td04">익산</td>
								<td class="td04">EP.익산.총무팀</td>
								<td class="td04">유경심 사원</td>
							</tr>
							<tr align="center">
								<td class="td04">여수</td>
								<td class="td04">여수.인사지원팀(인사P)</td>
								<td class="td04">손혜경 사원</td>
							</tr>
							<tr align="center">
								<td class="td04">대산</td>
								<td class="td04">대산.인사지원팀(인사P)</td>
								<td class="td04">전영화 사원</td>
							</tr>
							</tbody>
						</table>
					</div>
				</div>
		</div>
		<ul class="btn_crud close">
			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
		</ul>
		<div class="clear"> </div>
	</div>
</div>

</form>
</table>
<%@ include file="commonEnd.jsp" %>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.N.EHRCommonUtil" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%

	String searchPrsn = request.getParameter("searchPrsn");
	String I_ORGEH= WebUtil.nvl(request.getParameter("I_ORGEH"));

	HashMap resultMap = (HashMap)request.getAttribute("resultVT");

	String ORGTX = (String)resultMap.get("E_ORGTX");
	Vector qkVT = (Vector)resultMap.get("T_QK");
	//
	Vector spVT = (Vector)resultMap.get("T_SP");
%>

<jsp:include page="/include/header.jsp">
	<jsp:param name="modal" value="true"/>
</jsp:include>
<%-- 가중치 점수 산출내역 --%>
<jsp:include page="/include/pop-body-header.jsp">
	<jsp:param name="title" value="LABEL.N.N01.0001"/>
</jsp:include>
<script type="text/javascript">

	function popup(theURL,winName,features) {
		window.open(theURL,winName,features);
	}
	function pageMove(command){
		var aForm = document.ehrForm;
		aForm.command.value = command;
		aForm.action ="<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendPTSV";
		aForm.submit();
	}
</script>
<style type="text/css" >
	.contentBody h3 {padding-bottom:7px;}
	.tb_def th, .tb_def td {padding-top:3px;padding-bottom:3px;}
</style>
<form name="ehrForm" method="post">
	<input type= "hidden" name="searchPrsn" value="<%=searchPrsn %>">
	<input type= "hidden" name="I_ORGEH" value="<%=I_ORGEH %>">
	<input type= "hidden" name="command" value="">


	<h3><spring:message code="LABEL.N.N01.0002" /><!-- Post 필요역량 현황 --></h3>

	<div class="listArea">
		<div class="table">
			<table class="listTable">
				<thead>
				<!-- 테이블 시작 -->
				<caption></caption>
				<col  width=""/><col width="160" /><col  width="110"/><col  width="100"/><col  width="50"/><col  width="160"/><col  width="110"/><col  width="100"/><col  width="40"/>
				<thead>
				<tr>
					<th rowspan="3"><spring:message code="LABEL.N.N01.0003" /><!-- Post --></th>
					<th colspan="8" class="lastCol"><spring:message code="LABEL.N.N01.0004" /><!-- 필요역량 --></th>
				</tr>
				<tr>
					<th colspan="4"><spring:message code="LABEL.N.N01.0005" /><!-- 필수 조건 --></th>
					<th colspan="4" class="lastCol"><spring:message code="LABEL.N.N01.0006" /><!-- 선택 조건 --></th>
				</tr>
				<tr>
					<th><spring:message code="LABEL.N.N01.0007" /><!-- 항목 --></th>
					<th><spring:message code="LABEL.N.N01.0008" /><!-- 기준 --></th>
					<th><spring:message code="LABEL.N.N01.0009" /><!-- 개인 현황 --></th>
					<th><spring:message code="LABEL.N.N01.0010" /><!-- 점수 --></th>
					<th><spring:message code="LABEL.N.N01.0007" /><!-- 항목 --></th>
					<th><spring:message code="LABEL.N.N01.0008" /><!-- 기준 --></th>
					<th><spring:message code="LABEL.N.N01.0009" /><!-- 개인 현황 --></th>
					<th class="lastCol"><spring:message code="LABEL.N.N01.0010" /><!-- 점수 --></th>
				</tr>
				<%
					if(qkVT.size() > 0 ){
						HashMap<String, String> qkinfo = new HashMap<String, String>();
						for(int k = 0 ; k < qkVT.size() ; k++){
							qkinfo = (HashMap)qkVT.get(k);
							String QK_ITEM_TX1 = qkinfo.get("QK_ITEM_TX1");
							String GUBUN_TX1  = qkinfo.get("GUBUN_TX1");
							String PTEXT1      = qkinfo.get("PTEXT1");
							String QK_ITEM_TX2      = qkinfo.get("QK_ITEM_TX2");
							String GUBUN_TX2     = qkinfo.get("GUBUN_TX2");
							String PTEXT2      = qkinfo.get("PTEXT2");
							String POINT1 = qkinfo.get("POINT1");
							String POINT2 = qkinfo.get("POINT2");
				%>
				<tr>
					<%if(k ==0){ %>
					<td rowspan="<%=qkVT.size() %>"><%=ORGTX %></td>
					<%} %>
					<td><%= QK_ITEM_TX1%></td>
					<td><%= GUBUN_TX1%></td>
					<td><%= PTEXT1%></td>
					<td><%= POINT1%></td>
					<td><%= QK_ITEM_TX2%></td>
					<td><%= GUBUN_TX2%></td>
					<td><%= PTEXT2%></td>
					<td class="lastCol"><%= POINT2%></td>
				</tr>



				<%
						}
					}
				%>

				</thead>
			</table>
			<!-- 테이블 끝 -->

		</div>
		<div class="buttonArea">
			<ul class="btn_crud">
				<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
			</ul>
		</div>
	</div>
</form>
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>
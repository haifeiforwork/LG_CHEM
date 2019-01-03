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

<jsp:include page="/include/pop-body-header.jsp">
	<jsp:param name="title" value="LABEL.N.N01.0032"/>
</jsp:include>

<form name="ehrForm" method="post">
	<input type= "hidden" name="searchPrsn" value="<%=searchPrsn %>">
	<input type= "hidden" name="I_ORGEH" value="<%=I_ORGEH %>">
	<input type= "hidden" name="command" value="">

	<div class="tabArea">
		<ul class="tab">
			<li><a id="tab_1" class="-tab-link " href="javascript:void(0);" onclick="pageMove('INIT', 'tab_1')" ><spring:message code="LABEL.N.N01.0033" /><%--인적사항--%></a></li>
			<li><a id="tab_2" class="-tab-link" href="javascript:void(0);" onclick="pageMove('SUP', 'tab_2')" ><spring:message code="LABEL.N.N01.0034" /><%--인재육성--%></a></li>
			<li><a id="tab_3" class="-tab-link selected" href="javascript:void(0);" onclick="pageMove('PST', 'tab_3')" ><spring:message code="LABEL.N.N01.0035" /><%--Post 필요역량--%></a></li>
		</ul>
	</div>

	<h2 class="subtitle"><spring:message code="LABEL.N.N01.0002" /><!-- Post 필요역량 현황 --></h2>

	<!-- 테이블 시작 -->
	<table class="tb_def fixed" summary="" >
		<caption></caption>
		<col width="" /><col  width="160"/><col  width="130"/><col  width="130"/><col  width="160"/><col  width="130"/><col  width="130"/>
		<thead>
		<tr>
			<th rowspan="3"><spring:message code="LABEL.N.N01.0003" /><!-- Post --></th>
			<th colspan="6"><spring:message code="LABEL.N.N01.0004" /><!-- 필요역량 --></th>
		</tr>
		<tr>
			<th colspan="3"><spring:message code="LABEL.N.N01.0005" /><!-- 필수 조건 --></th>
			<th colspan="3"><spring:message code="LABEL.N.N01.0006" /><!-- 선택 조건 --></th>
		</tr>
		<tr>
			<th><spring:message code="LABEL.N.N01.0007" /><!-- 항목 --></th>
			<th><spring:message code="LABEL.N.N01.0008" /><!-- 기준 --></th>
			<th><spring:message code="LABEL.N.N01.0009" /><!-- 개인 현황 --></th>
			<th><spring:message code="LABEL.N.N01.0007" /><!-- 항목 --></th>
			<th><spring:message code="LABEL.N.N01.0008" /><!-- 기준 --></th>
			<th><spring:message code="LABEL.N.N01.0009" /><!-- 개인 현황 --></th>
		</tr>
		</thead>
		<tbody>
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
		%>
		<tr>
			<%if(k ==0){ %>
			<td rowspan="<%=qkVT.size() %>"><%=ORGTX %></td>
			<%} %>
			<td><%= QK_ITEM_TX1%></td>
			<td><%= GUBUN_TX1%></td>
			<td><%= PTEXT1%></td>
			<td><%= QK_ITEM_TX2%></td>
			<td><%= GUBUN_TX2%></td>
			<td><%= PTEXT2%></td>
		</tr>



		<%
				}
			}
		%>

		</tbody>
	</table>
	<!-- 테이블 끝 -->

	<h3><spring:message code="LABEL.N.N01.0081" /><!-- S/P 현황 --></h3>
	<h4> <spring:message code="LABEL.N.N01.0082" /><!-- Post 명 --> : <%=ORGTX %></h4>
	<!-- 테이블 시작 -->
	<table class="tb_def fixed" summary="" >
		<caption></caption>
		<col width="50" /><col width="80" /><col width="60" /><col width="50" /><col width="" /><col width="70" /><col  width="100"/><col  width="80"/><col width="80" /><col  width="80"/><col  width="60"/>
		<thead>
		<tr>
			<th rowspan="2"><spring:message code="LABEL.N.N01.0020" /><!-- 순위 --></th>
			<th rowspan="2"><spring:message code="LABEL.N.N01.0022" /><!-- 성명 --></th>
			<th rowspan="2"><%-- //[CSR ID:3456352]<spring:message code="LABEL.N.N01.0037" /><!-- 직위 --> --%>
			<spring:message code="LABEL.N.N01.0094" /><!-- 직위/직급호칭 -->
			</th>
			<th rowspan="2"><spring:message code="LABEL.N.N01.0038" /><!-- 연차 --></th>
			<th rowspan="2"><spring:message code="LABEL.N.N01.0021" /><!-- 소속 --></th>
			<th rowspan="2"><spring:message code="LABEL.N.N01.0024" /><!-- 직책 --></th>
			<th colspan="3"><spring:message code="LABEL.N.N01.0083" /><!-- 사업가 후보 이력 --></th>
			<th rowspan="2"><spring:message code="LABEL.N.N01.0040" /><!-- 그룹입사일 --></th>
			<th rowspan="2"><spring:message code="LABEL.N.N01.0044" /><!-- 연령 --></th>
		</tr>
		<tr>
			<th><spring:message code="LABEL.N.N01.0084" /><!-- 사업부장후보 --></th>
			<th><spring:message code="LABEL.N.N01.0085" /><!-- 차세대 --></th>
			<th><spring:message code="LABEL.N.N01.0086" /><!-- HPI --></th>
		</tr>
		</thead>
		<tbody>
		<%
			if(spVT.size() > 0 ){
				HashMap<String, String> spinfo = new HashMap<String, String>();
				for(int k = 0 ; k < spVT.size() ; k++){
					spinfo = (HashMap)spVT.get(k);
					String ORANK       = spinfo.get("ORANK");
					String ENAME       = spinfo.get("ENAME");
					String TITEL       = spinfo.get("TITEL");
					String TITLE_YEAR  = spinfo.get("TITLE_YEAR");
					String STEXT       = spinfo.get("STEXT");
					String TITL2       = spinfo.get("TITL2");
					String S0014       = spinfo.get("S0014");
					String S0011       = spinfo.get("S0011");
					String S0001       = spinfo.get("S0001");
					String GDAT        = spinfo.get("GDAT");
					String OLDS        = spinfo.get("OLDS");
		%>
		<tr>
			<td><%=ORANK %></td>
			<td><%=ENAME %></td>
			<td><%=TITEL %></td>
			<td><%=EHRCommonUtil.reIntString(TITLE_YEAR) %></td>
			<td><%=STEXT %></td>
			<td><%=TITL2 %></td>
			<td><%=S0014 %></td>
			<td><%=S0011 %></td>
			<td><%=S0001 %></td>
			<td><%=WebUtil.printDate(GDAT)  %></td>
			<td><%=OLDS  %></td>
		</tr>
		<%	}
		}
		%>

		</tbody>
	</table>
	<!-- 테이블 끝 -->
	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="javascript:pageMove('INIT', 'tab_1')"><span><spring:message code="LABEL.N.N01.0033"/><%--인적사항--%></span></a></li>
			<li><a href="javascript:pageMove('SUP', 'tab_2')"><span><spring:message code="LABEL.N.N01.0034"/><%--인재육성--%></span></a></li>
			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
		</ul>
	</div>


</form>
<jsp:include page="/include/pop-body-footer.jsp"/>

<jsp:include page="/include/footer.jsp"/>

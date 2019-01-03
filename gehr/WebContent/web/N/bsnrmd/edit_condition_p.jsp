<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	//     T_IMPORT	1
//     OPTIO		CHAR	 1 	필수/선택
//   	QK_ITEM_TX		 CHAR 	 50 	자격요건 header
//	    GUBUN_TX		CHAR	 50 	자격요건 detail

	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	String I_ORGEH= WebUtil.nvl(request.getParameter("I_ORGEH"));

	Vector qlVT = (Vector)qlHM.get("T_QK"); //검색조건 List
	int qlSize = qlVT.size();

%>

<jsp:include page="/include/header.jsp" />

<jsp:include page="/include/pop-body-header.jsp">
	<jsp:param name="title" value="LABEL.N.N01.0087"/>
</jsp:include>
<script type="text/javascript">

	function popup(theURL,winName,features) {
		window.open(theURL,winName,features);
	}

	function optionSave(){
		document.form1.action = "<%=WebUtil.ServletURL %>hris.N.bsnrmd.BusinRecommendListSV?command=SAVE";
		//document.target ="opener.BusinListFrame";
		document.form1.target= opener.window.name;

		document.form1.submit();
		self.close();
	}
</script>
<form name="form1" method="post">

	<input type="hidden" name="I_ORGEH" value="<%=I_ORGEH %>">

	<div class="listArea">
		<div class="table">
			<table class="listTable">

				<!-- 테이블 시작 -->
				<caption></caption>
				<col  /><col  /><col  /><col  />
				<thead>
				<tr>
					<th colspan="2"><spring:message code="LABEL.N.N01.0088" /><!-- 자격요건 --></th>
					<th><spring:message code="LABEL.N.N01.0089" /><!-- 초기값 --></th>
					<th class="lastCol"><spring:message code="LABEL.N.N01.0090" /><!-- 개인설정값 --></th>
				</tr>
				</thead>
				<tbody>
				<%
					if(qlSize > 0 ){
						HashMap<String, String> qlhm = new HashMap<String, String>();

						for(int k = 0 ; k < qlSize ; k++){
							qlhm = (HashMap)qlVT.get(k);
							String OPTIO = qlhm.get("OPTIO");
							String optext = "미지정";
							if(OPTIO.equals("1")){
								optext = "필수";
							}else if(OPTIO.equals("2")){
								optext = "선택";
							}
							String QK_ITEM_TX = qlhm.get("QK_ITEM_TX");
							String GUBUN_TX = qlhm.get("GUBUN_TX");

				%>
				<tr>
					<input type="hidden" name="QK_ITEM_TX" value ="<%=QK_ITEM_TX %>">
					<input type="hidden" name="GUBUN_TX" value ="<%=GUBUN_TX  %>">

					<td><%= QK_ITEM_TX%></td>
					<td class="left">
						<ul class="dotBull">
							<li><%= GUBUN_TX %></li>
						</ul>
					</td>
					<td><%=optext %></td>
					<td class="lastCol">
						<select name="OPTIO">
							<option value="" <%if(OPTIO.equals("")){ %> selected <%} %>><spring:message code="LABEL.N.N01.0091" /><!-- 미지정 --></option>
							<option value="1" <%if(OPTIO.equals("1")){ %> selected <%} %>><spring:message code="LABEL.N.N01.0092" /><!-- 필수 --></option>
							<option value="2" <%if(OPTIO.equals("2")){ %> selected <%} %>><spring:message code="LABEL.N.N01.0093" /><!-- 선택 --></option>
						</select>
					</td >
				</tr>
				<%		}
				}%>

				</tbody>
			</table>
			<!-- 테이블 끝 -->
		</div>
		<div class="buttonArea">
			<ul class="btn_crud">
				<li><a href="javascript:optionSave()"><span><spring:message code="BUTTON.COMMON.SAVE"/><%--저장--%></span></a></li>
				<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
			</ul>
		</div>
	</div><!-- /subWrapper -->
</form>
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>
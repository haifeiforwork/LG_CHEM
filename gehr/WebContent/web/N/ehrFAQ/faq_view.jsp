<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	String searchText = WebUtil.nvl(request.getParameter("I_BIZTY"));
    String I_SEARCH = WebUtil.nvl(request.getParameter("I_SEARCH"));
    String paging =   WebUtil.nvl((String)request.getParameter("page"));
	HashMap qlHM = (HashMap)request.getAttribute("resultVT");

	int dtSize = 0;

	String CODTX = "";
	String SUBTX = "";
	String TITLE = "";
	String REGDT = "";
	String LINKADDR = "";
	String FURL = "";
	String FILEN ="";
	String GURL = "";

	Vector dtVT = (Vector)qlHM.get("T_EXPORT"); //
	dtSize = dtVT.size();
	HashMap<String, String> sphm = new HashMap<String, String>();

	if(dtSize >0){
		sphm = (HashMap)dtVT.get(0);
		CODTX = sphm.get("CODTX");
		SUBTX = sphm.get("SUBTX");
		TITLE = sphm.get("TITLE");
		REGDT = sphm.get("REGDT");
		FURL = sphm.get("FURL");
		FILEN = sphm.get("FILEN");
		GURL = sphm.get("GURL");
		LINKADDR = sphm.get("LINKADDR");
	}

	Vector listVT = (Vector)qlHM.get("T_TEXT");

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>LG화학 e-HR 시스템</title>
	<link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL %>css/ehr_style.css" />
	<link rel="stylesheet" href="<%=WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
    <link rel="stylesheet" href="<%=WebUtil.ImageURL %>css/ui_jquery.css" type="text/css">
	<script type="text/javascript">
	function returnPage(){
		    frm = document.form1;
		    frm.action = "<%= WebUtil.ServletURL%>hris.N.ehrFAQ.EHRfaqSV?I_PFLAG=X";
		    frm.submit();
	}
	</script>
</head>

<body id="subBody">
<form name="form1" method="post">
<input type="hidden" name="I_BIZTY" value="<%= searchText%>">
<input type="hidden" name="I_SEARCH" value="<%= I_SEARCH%>">
<input type="hidden" name="page" value="<%= paging %>">
<div class="subWrapper">
	<div class="subHead"><h2>FAQ List </h2></div>
	<div class="contentBody">
		<!-- 테이블 시작 -->
		<table class="tb_brd_view fixed" summary="" >
			<caption></caption>
			<col width="95" /><col  /><col width="55" /><col /><col width="75" /><col />
			<tbody>
				<tr>
					<th scope="row" class="title" colspan="6"><%=TITLE %></th>
				</tr>
				<tr>
					<th scope="row" class="first"><spring:message code="LABEL.COMMON.0041" /><!--업무분류 --></th>
					<td><%=CODTX %></td>
					<th scope="row"><spring:message code="LABEL.COMMON.0043" /><!--구분 --></th>
					<td><%=SUBTX %></td>
					<th scope="row"><spring:message code="LABEL.COMMON.0045" /><!--등록일자 --></th>
					<td><%= REGDT %></td>
				</tr>
				<tr class="darkRow01">
					<th scope="row" class="first"><spring:message code="LABEL.COMMON.0044" /><!--문의내용 --></th>
					<td class="view" colspan="5">
						<%=TITLE %>
					</td>
				</tr>
				<tr>
					<th scope="row" class="first"><spring:message code="LABEL.COMMON.0048" /><!--상세내용 --></th>
					<td class="view" colspan="5">
					<%
					StringBuffer content = new StringBuffer();
					int ctSize = listVT.size() ;
				 	HashMap<String, String> T_TEXT = new HashMap<String, String>();
				 	for(int k = 0 ; k < ctSize ; k ++){
				 		T_TEXT = (HashMap)listVT.get(k);
				 			content.append(T_TEXT.get("TDLINE")+"<br/>");
				 	}
					%>
					<%= content %>

					<%if(!GURL.equals("")){ %>
					<br /><img src="<%=GURL %>" /><br />
					<%} %>
					</td>
				</tr>
				<tr class="darkRow01">
					<th scope="row" class="first"><spring:message code="LABEL.COMMON.0046" /><!--관련 사이트 Link --></th>
					<td class="view" colspan="5">
						<a href="<%=LINKADDR.toLowerCase() %>" target="_new"><%=LINKADDR.toLowerCase() %></a>
					</td>
				</tr>
				<tr>
					<th scope="row" class="first"><spring:message code="LABEL.COMMON.0047" /><!--첨부파일 --></th>
					<td class="view" colspan="5">
						<a href="<%=FURL %>" target="_newlink"><%=FILEN %>
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 테이블 끝 -->

		<!-- 버튼 시작 -->
		<div class="buttonArea">
	        <ul class="btn_crud">
	            <li><a href="javascript:returnPage()"><span><!--목록--><spring:message code="BUTTON.COMMON.LIST" /></span></a></li>
	        </ul>
    	</div>
		<!-- 버튼 끝 -->

	</div><!-- /contentBody -->
</div><!-- /subWrapper -->
</form>
</body>
</html>
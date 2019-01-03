<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
	
    
    String paging =   WebUtil.nvl((String)request.getParameter("page"));
	HashMap qlHM = (HashMap)request.getAttribute("resultVT"); 
	
	int dtSize = 0;
	String TITLE = "";
	String GURL = "";

	Vector dtVT = (Vector)qlHM.get("T_EXPORT"); //
	dtSize = dtVT.size();
	HashMap<String, String> sphm = new HashMap<String, String>();
		
	if(dtSize > 0){
		sphm = (HashMap)dtVT.get(0);
		TITLE = sphm.get("TITLE");
		GURL = sphm.get("GURL");
	}
	
	Vector listVT = (Vector)qlHM.get("T_TEXT");

%>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>LG화학 e-HR 시스템</title>
	<link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL %>css/ehr_style.css" /> 
	<script type="text/javascript">
	function returnPage(){
		    frm = document.form1; 
		    var returnUrl ="<%=WebUtil.JspURL%>N/EAP/mental/greenLetter_list.jsp";
		  	frm.action = "<%= WebUtil.ServletURL %>hris.N.common.CommonFAQListSV?I_CODE=0002&I_PFLAG=X&returnUrl="+returnUrl;
		    frm.submit();
	}
	</script>
</head>

<body id="subBody">  
<form name="form1" method="post">

<input type="hidden" name="page" value="<%= paging %>">
<div class="subWrapper"> 
	<div class="subHead"><h2>Green Letter </h2></div>
	<div class="contentBody">
		<!-- 테이블 시작 -->
		<table class="tb_brd_view fixed" summary="" >
			<caption></caption>
			<tbody>
				<tr>
					<th scope="row" class="title"><%=TITLE %></th> 
				</tr> 
					<td class="view">
				<%
				StringBuffer content = new StringBuffer();
				int ctSize = listVT.size() ; 
			 	HashMap<String, String> T_TEXT = new HashMap<String, String>();
			 	for(int k = 0 ; k < ctSize ; k ++){
			 		T_TEXT = (HashMap)listVT.get(k);
			 			content.append(T_TEXT.get("TDLINE")+"<br/>");
			 	}
				%>
				
				<br /><img src="<%=GURL %>" /><br />
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 테이블 끝 -->	
		
		
				<!-- 버튼 시작 -->
				<div class="btnCenter">
					<a href="javascript:returnPage()"><img src="<%=WebUtil.ImageURL %>btn_list.gif" alt="목록" /></a> 
					<a href="javascript:window.close();"><img src="<%= WebUtil.ImageURL %>btn_close.gif" alt="닫기" border="0" /></a>
				</div>
				<!-- 버튼 끝 -->
		
	</div><!-- /contentBody -->
</div><!-- /subWrapper -->
</form>
</body>
</html>
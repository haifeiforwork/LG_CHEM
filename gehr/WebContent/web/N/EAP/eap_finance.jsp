<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
	
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	
	<title>LG화학 e-HR 시스템</title>
	<meta name="description" content="LG화학 e-HR 시스템" />
	<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>css/ehr_style.css" />
	<script type="text/javascript">
	
		function popupP(theURL) { 
		   var width=910;
		   var height = 750;
		   var screenwidth = (screen.width-width)/2;
           var screenheight = (screen.height-height)/2;
          
		  pop_window = window.open(theURL,"_newfin","toolbar=yes,location=yes,resizable=yes,scrollbars=yes,top="+screenheight+",left="+screenwidth);
		  	pop_window.focus();
		}	
	</script>
</head>

<body id="subBody" class="eapSubBody" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">  

<div class="subWrapper eapSub"> 
	<div class="financeTop"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_finance_top.jpg" alt="EAP 서비스" /></div>
	<div class="financeTopMent"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_finance_ment.jpg" alt="EAP 서비스 - 재무상담" /></div>			
	<div class="financeLink">
		<a href="#"><a href="javascript:popupP('http://b2b.podofp.com:8080/lgmall/')" ><img src="<%= WebUtil.ImageURL %>/ehr_common/btn_eap_finance2.gif" alt="재무상담 신청하기" /></a>
	</div> 
	
	<div class="contentBody">
		<img src="<%= WebUtil.ImageURL %>/ehr_common/finance_01.jpg" /><br /><br /><br /><br /> 
		
		<h3><img src="<%= WebUtil.ImageURL %>/ehr_common/finance_title_01.gif" alt="제공 프로그램" /></h3> 
		<img src="<%= WebUtil.ImageURL %>/ehr_common/finance_02.jpg" /><br /><br /><br /><br />
		 
		
		
	</div><!-- /contentBody -->
</div><!-- /subWrapper --> 
</body>
</html>
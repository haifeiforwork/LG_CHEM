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
          
		   pop_window = window.open(theURL,"_newlaw","toolbar=yes,location=yes,resizable=yes,scrollbars=yes,top="+screenheight+",left="+screenwidth);
		   pop_window.focus();
		}	
	</script>
</head>

<body id="subBody" class="eapSubBody" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">  
 
<div class="subWrapper eapSub">  
	<div class="lawTop"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_law_top.jpg" alt="EAP 서비스" /></div>
	<div class="lawTopMent"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_law_ment.jpg" alt="EAP 서비스 - 법률상담" /></div>			
	<div class="lawLink">
		<a href="javascript:popupP('http://gportal.lgchem.com/portal/common/legacy/legacyLink.do?url=http://legaladv.lgchem.com/lgcl/ssoLoginInfo.dev')"><img src="<%= WebUtil.ImageURL %>/ehr_common/btn_eap_law2.gif" alt="법률상담 신청하기" /></a>
	</div> 
	<div class="contentBody">
		<h3><img src="<%= WebUtil.ImageURL %>/ehr_common/law_title_01.gif" alt="이용 방법" /></h3>
		
		<ul class="lawSec01">
			<li class="item01"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_law_sec01_img_01.jpg" alt="비공개상담" /></li>
			<li class="item02"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_law_sec01_img_02.jpg" alt="답변기한" /></li>
			<li class="item03"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_law_sec01_img_03.jpg" alt="답변의활용" /></li>
		</ul>
		<div class="clear"></div> 
	</div><!-- /contentBody --> 
</div><!-- /subWrapper -->  
</body>
</html>
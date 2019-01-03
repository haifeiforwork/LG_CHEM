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
		  var width=1024;
		  var height = 750;
		  var screenwidth = (screen.width-width)/2;
          var screenheight = (screen.height-height)/2;
          
		  pop_window = window.open(theURL,"_newtax","width="+width+",height="+height+",toolbar=yes,location=yes,resizable=yes,scrollbars=yes,top="+screenheight+",left="+screenwidth);
		  pop_window.focus();
		}	
		
		function init(){
			
			

		}
	</script>
</head>

<body id="subBody" class="eapSubBody" onload="init()" >  
<form name="form1" method="post">
<div class="subWrapper eapSub">  
	<div class="taxTop"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_tax_top.jpg" alt="EAP 서비스" /></div>
	<div class="taxTopMent"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_tax_ment.jpg" alt="EAP 서비스 - 세무상담" /></div>			
	<div class="taxLink" style="margin-left:213px;width:516px;height:39px;background:url(<%= WebUtil.ImageURL %>/ehr_common/eap_link_bg.jpg) no-repeat;">
		<a href="javascript:popupP('eap_taxP.jsp')" ><img src="<%= WebUtil.ImageURL %>/ehr_common/btn_eap_tax2.gif" alt="세무상담 신청하기" /></a>
	</div> 
	<div class="contentBody">
		<img src="<%= WebUtil.ImageURL %>/ehr_common/tax_01.jpg" /><br /><br /><br /><br /> 
		
		<h3><img src="<%= WebUtil.ImageURL %>/ehr_common/tax_title_01.gif" alt="제공 프로그램" /></h3> 
		<img src="<%= WebUtil.ImageURL %>/ehr_common/tax_02.jpg" /><br /><br /><br /><br />
		 
		
	</div><!-- /contentBody --> 
</div><!-- /subWrapper -->   


</form>
</body>
</html>
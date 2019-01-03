<%@ page contentType="text/html; charset=utf-8" %>
<%-- @ include file="/web/common/commonProcess.jsp" --%>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.G.G001Approval.*" %>
<%@ page import="hris.A.A16Appl.rfc.*" %>
<%@ page import="hris.A.A16Appl.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<title></title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/hrService.css" type="text/css">
</head>
<body>

    <!-- HR Service Start -->
    <div class="HR_wrapper">

    	<!-- HR Service top Contents Start -->
		<div style="height: 269px; width:100%;">
		
    	<iframe  NAME="lgchemHRServiceVacationBox" width="100%" height="100%" BORDER="0" VSPACE="0" FRAMESPACING="0"  FRAMEBORDER="0" MARGINWIDTH="0" src="http://ehr.lgchem.com/servlet/servlet.hris.EPLoginSV?SServer=portal.lgchem.com&returnUrl=/ep/leaveResult_gPortal.jsp&laf=&_view=true" SCROLLING="NO"></iframe>
    	<!--<iframe  NAME="lgchemHRServiceVacationBox" width="100%" height="100%" BORDER="0" VSPACE="0" FRAMESPACING="0"  FRAMEBORDER="0" MARGINWIDTH="0" src="/web/ep/leaveResult_gPortal.jsp" SCROLLING="NO"></iframe>-->
    	
    	
 		</div> 
        <!--// HR Service top Contents End -->
        
	<div class="HR_bottomC">
   		    <div style="float:left; width:40%;" >
        	<iframe NAME="lgchemHRServiceApprovalBox" BORDER="0" VSPACE="0" FRAMESPACING="0"  FRAMEBORDER="0" MARGINWIDTH="0" WIDTH="100%" src="http://ehr.lgchem.com/servlet/servlet.hris.EPLoginSV?SServer=portal.lgchem.com&returnUrl=/ep/AStsADoc_gPortal.jsp&laf=&_view=true" SCROLLING="NO"></iframe>
        	<!--<iframe NAME="lgchemHRServiceApprovalBox" BORDER="0" VSPACE="0" FRAMESPACING="0"  FRAMEBORDER="0" MARGINWIDTH="0" WIDTH="100%" src="/web/ep/AStsADoc_gPortal.jsp" SCROLLING="NO"></iframe>-->
        		<!-- <h4>결재 신청정보</h4>
        		<div style="font-size:14px; color:#ca3442; margin:0 0 25px 1px;">
            		<span>신청 진행현황1</span>
            		<span>신청 진행현황2</span>
            	</div>
                -->
            </div>
            <div class="HR_bottomC_link">
            	<h4>Hot Link</h4>
                <div>
                	<h5>조회</h5>
                	<ul>
                    	<li><a href="http://gportal.lgchem.com/portal/lgchemMenu/lgchemHrMenu.do?menu=hrEmpInfo&url=/servlet/servlet.hris.A.A01SelfDetailSV_m">개인인적사항 조회</a></li>
                        <li><a href="http://gportal.lgchem.com/portal/lgchemMenu/lgchemHrMenu.do?menu=hrInfo&url=/servlet/servlet.hris.D.D05Mpay.D05MpayDetailSV">월급여</a></li>
                        <li><a href="http://gportal.lgchem.com/portal/lgchemMenu/lgchemHrMenu.do?menu=hrInfo&url=/servlet/servlet.hris.D.D06Ypay.D06YpayDetail_to_yearSV">연급여</a></li>
                        <li><a href="http://gportal.lgchem.com/portal/lgchemmenu/lgchemMenuLink.do?menu=HRD&hrdparam=9">교육이력 조회</a></li>
                    </ul>
                </div>
                <div>
                	<h5>신청</h5>
                	<ul>
                    	<li><a href="http://gportal.lgchem.com/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url=/servlet/servlet.hris.D.D01OT.D01OTBuildSV ">초과근무신청</a></li>
                        <li><a href="http://gportal.lgchem.com/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url=/servlet/servlet.hris.D.D03Vocation.D03VocationBuildSV ">휴가신청</a></li>
                        <li><a href="http://gportal.lgchem.com/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url=/servlet/servlet.hris.A.A15Certi.A15CertiBuildSV ">제증명신청</a></li>
                        <li><a href="http://gportal.lgchem.com/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url=/servlet/servlet.hris.D.D11TaxAdjust.D11TaxFirstSV ">연말정산</a></li>
                    </ul>
                </div>
            </div>
            <div class="HR_bottomC_banner">
            	<h4>Banner</h4>
            	<ul>
                	<li><a href="http://ehr.lgchem.com/servlet/servlet.hris.EPLoginSV?returnUrl=/help_online/rule.jsp?param=contents.html ">HR 제도안내</a></li>
                    <li><a href="http://gportal.lgchem.com/portal/lgchemmenu/lgchemAppLink.do?app=HRQnA">HR QnA</a></li>
                    <li><a href="http://ehr.lgchem.com/servlet/servlet.hris.EPLoginSV?returnUrl=/help_online/rule.jsp?param=Rule02Benefits15.html">작은결혼식</a></li>
                </ul>
            	<ul style="float:right;">
                	<li><a href="http://gportal.lgchem.com/portal/lgchemmenu/lgchemAppLink.do?app=lifecare">선택적복리후생</a></li>
                    <li><a href="http://intra.lgchem.com:6103/jsp/adminNewFrm.jsp">리조트 예약</a></li>
                    <li><a href="http://165.244.5.10/login.aspx?ReturnUrl=%2fGuide.aspx">사원카드 내역보기</a></li>
                </ul>
            </div>
            
        </div>

    <!--// HR Service End -->
</body>
</html>
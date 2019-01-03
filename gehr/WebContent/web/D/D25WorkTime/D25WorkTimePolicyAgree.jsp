<%--
/******************************************************************************/
/*   System Name  : ESS
/*   1Depth Name  : My HR
/*   2Depth Name  : 휴가/근태
/*   Program Name : 실근무시간 관리 제도 동의(합의)
/*   Program ID   : D25WorkTimePolicyAgree.jsp
/*   Description  : 실근무시간 유연근무제도 동의 화면
/*   Note         : 
/*   Creation     : 2018-06-04 rdcamel [CSR ID:3704184] 유연근로제 동의 관련 기능 추가 건 - Global HR Portal
/*   Update       : 
/******************************************************************************/
--%><%@ page contentType="text/html; charset=utf-8" %><%
%><%@ include file="/web/D/D25WorkTime/D25WorkTimeCommonPreprocess.jsp" %><!DOCTYPE html>
<%-- html 시작 선언 및 head 선언 --%>
<%-- * 참고 *
     아래 noCache 변수는 css와 js 파일이 browser에서 caching 되는 것을 방지하기위한 변수이다.
     운영모드에서 css와 js 파일이 안정화되어 수정될 일이 없다고 판단되는 경우 browser에서 caching 되도록 하여 server 부하를 줄이고자한다면 noCache 변수를 삭제한다.

     noCache 변수 삭제 후 운영중에 css나 js 파일이 변경되면 browser의 cache를 사용자가 직접 삭제해줘야하는데 이런 번거로움을 없애려면 noCache 변수를 다시 넣으면된다.

     주의할 점은 jsp:include tag 내부에서는 주석이 오류를 발생시키므로
     주석으로 남기고 싶은 경우 noCache 변수 line을 jsp:include tag 외부로 빼서 주석처리하거나
     변수명을 noCache에서 noCacheX 등으로 변경한다. --%>
<jsp:include page="/include/header.jsp">
    <jsp:param name="noCache" value="?${timestamp}" />
    <jsp:param name="css" value="bootstrap-3.3.2.min.css" />
    <jsp:param name="css" value="D/D25WorkTime.css" />
    <jsp:param name="css" value="ui_library.css" />
    <jsp:param name="css" value="ui_library_approval.css" />
    <jsp:param name="script" value="moment-with-locales.min.js" />
    <jsp:param name="script" value="jquery-ext-logger.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
</jsp:include>

<%-- body 시작 선언 및 body title --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D25.0058" />
</jsp:include>

<!-- 근무시간 목록 테이블 시작 -->
<div class="listArea">

        <div ${param.agreeYN eq 'Y' ? ' style="display:none"' : ''} style="margin-bottom:5px;text-align:center;">
            
                <a href="javascript:workTimeAgreeSave();" data-name="worktimeAgreeSave" style="text-align:center"><img src="/web/images/btn_agree.png"></a><br>
                
        
        </div>
        <div class="clear"></div>

    
<div class="winPop_appl">
		
	
	<div class="body">
		
			<p class="lgsmart f16" style="font-size:15px"> 
				근로자  <b><u>${user.ename}</u></b>         (이하 ‘사원’이라 한다)은/는 <b><u>2018년 7월 1일자로 근로기준법에 규정된 유연근무제(제51조, 제52조, 제58조) 및 보상휴가제(제57조)를 도입/시행</u></b>함에 <b><u>동의</u></b>한다.</br></br>
				또한, <b><u>근로기준법 조항의 요건에 따른 근로자 대표와의 서면 합의 및 취업규칙 개정 관련</u></b>하여 <b><u>근로자 소속 사업본부/사업장 사원협의체 대표가 사무기술직 근로자 대표로서 근로자를 대리하며, 추인하는 것에 동의</u></b>한다.
				 </br></br>
			</p>

			<img src="/web/images/40workAgreement.PNG" >

	</div>
</div>
<br>
<!-- // Window Popup end -->
    <!-- 내용 입력 부분 끝-->
    <div ${param.agreeYN eq 'Y' ? ' style="display:none"' : ''} style="margin-bottom:5px;text-align:center;">
            
                <a href="javascript:workTimeAgreeSave();" data-name="worktimeAgreeSave" style="text-align:center"><img src="/web/images/btn_agree.png"></a><br>
                
        
        </div>
</div>
<!-- 근무시간 목록 테이블 끝 -->

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->
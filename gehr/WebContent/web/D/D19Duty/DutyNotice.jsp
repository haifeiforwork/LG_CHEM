<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무 신청                                               */
/*   Program ID   : D01OTBuild.jsp                                              */
/*   Description  : 초과근무(OT/특근)신청을 하는 화면                           */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D19Duty.*" %>

<jsp:include page="/include/header.jsp"/>
<script language="javascript">
<!--
jQuery(function(){
	parent.resizeIframe(document.body.scrollHeight);
});

//-->
</script>

<div class="subWrapper">

    <div style="text-align: center;">
        <img src="/web/images/page_stop.gif">
    </div>

</div>


<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

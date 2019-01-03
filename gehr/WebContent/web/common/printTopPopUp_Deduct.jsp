<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
// update 2016-03-02 rdcamel [CSR ID:2999302] 원천징수 영수증 출력 관련
    WebUserData  user = (WebUserData)session.getAttribute("user");
    String jobid2 = (String)request.getParameter("jobid2");

    String  AINF_SEQN = (String)request.getParameter("AINF_SEQN");
    String  PERNR = (String)request.getParameter("PERNR");
    String  sTargetYear = (String)request.getParameter("sTargetYear");
    String  MENU = (String)request.getParameter("MENU");
    String  GUEN_TYPE = (String)request.getParameter("GUEN_TYPE");
    int insaFlag = user.e_authorization.indexOf("H");    //인사담당
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<script language="javascript">
    function f_print(){
        if(parent.opener.document.form1.PRINT_CHK[0].checked== true && parent.opener.document.form1.PRINT_END.value == "X" ) {
            alert("<spring:message code='MSG.COMMON.0070' />"); //발행은 1회만 인쇄 가능합니다.
            return;
        }
        if( parent.opener.document.form1.PRINT_CHK[0].checked ==true ){//본인
           msg ="<spring:message code='MSG.COMMON.0070' /> <spring:message code='MSG.COMMON.0071' />";  //발행은 1회만 인쇄 가능합니다. 인쇄 하시겠습니까?
        }else { //담당자
           msg ="<spring:message code='MSG.COMMON.0071' />";  //인쇄 하시겠습니까?
        }
        if( confirm(msg) ) {
           //if( confirm("① [도구]->[인터넷 옵션]->[고급]->[인쇄]의 [배경색 및 이미지 인쇄]를 체크하시기 바랍니다.\n\n② [파일]->[페이지 설정]에서 다음과 같이 설정하시기 바랍니다.  \n\n용지크기\t\t: A4\n머리글/바닥글\t: 내용 삭제\n방향\t\t: 세로\n여백(밀리미터)\t: 왼쪽 17 오른쪽 19 위쪽 19 아래쪽 19") ) {
           if( confirm("<spring:message code='MSG.COMMON.0073' />") ) {  //① [도구]->[인터넷 옵션]->[고급]->[인쇄]의 [배경색 및 이미지 인쇄]를 체크하시기 바랍니다.\n\n② [파일]->[페이지 설정]에서 다음과 같이 설정하시기 바랍니다.  \n\n용지크기\t\t: A4\n머리글/바닥글\t: 내용 삭제\n방향\t\t: 세로
               parent.beprintedpage.focus();
               if ("<%=GUEN_TYPE%>"=="01"  ) { //01:근로소득 원천징수 영수증
                  parent.frames[0].printDocument("pdfDocument");
               }else if ("<%=GUEN_TYPE%>"=="02"  ) {  //02:갑근세 원천징수 증명서
                  parent.frames[0].printDocument("pdfDocument");
                  //parent.beprintedpage.print();
               }
               document.form1.target = "ifHidden";
               document.form1.action = "<%=WebUtil.JspURL%>common/PrintCntUpdate.jsp";
               document.form1.submit();
           }
        }
    }
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
<div style="margin:0 20px; padding:7px 0; border-top:1px solid #ddd;">
	<div class="buttonArea">
		<ul class="btn_crud">
<%  if ( GUEN_TYPE.equals("01")  ) { //01:근로소득 원천징수 영수증
%>
<!--  [CSR ID:2999302] 원천징수 영수증 출력 관련 -->
    		<li>
    			<a href="<%= WebUtil.ImageURL %>AcroRdrDC1500720033_ko_KR.exe" target="_blankTOP">
    				<span>Adobe Reader DC <spring:message code='LABEL.COMMON.0030' /><!-- 다운로드 --></span>
    			</a>
    		</li>
<%  } %>
			<li><a href="javascript:f_print();"><span><spring:message code='LABEL.COMMON.0001' /><!-- 인쇄하기 --></span></a></li>
			<li><a href="javascript:top.close();"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
		</ul>
	</div>
</div>
</table>
<input type="hidden" name="PERNR"     value="<%=PERNR%>">
<input type="hidden" name="AINF_SEQN" value="<%=AINF_SEQN%>">
<input type="hidden" name="sTargetYear" value="<%=sTargetYear%>">
<input type="hidden" name="MENU" value="<%=MENU%>">
</form>
<iframe name="ifHidden" width="0" height="0" />
<%@ include file="commonEnd.jsp" %>

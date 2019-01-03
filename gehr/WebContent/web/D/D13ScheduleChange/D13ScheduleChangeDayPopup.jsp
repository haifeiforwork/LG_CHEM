<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 일일근무일정 변경	(개인별 일일근무목록)											*/
/*   Program ID   : D13ScheduleChangeDayPopup|D13ScheduleChangePopup.jsp			*/
/*   Description  : 일일근무일정 변경 화면											*/
/*   Note         : 															*/
/*   Creation     : 2009-03-23  김종서												*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D13ScheduleChange.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>

    <%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%

	Vector dayschedule_vt       = (Vector)request.getAttribute("dayschedule_vt"); //일일근무일정 데이터
	
%>
<c:set var="rowNum" value = "<%= (String)request.getAttribute("rowNum")%>"/>
<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D13.0001"/>
    <jsp:param name="help" value="D05Mpay.html"/>
</jsp:include>

<script language="JavaScript">
<!--


function handleError (err, url, line) {
   alert('오류 : '+err + '\nURL : ' + url + '\n줄 : '+line);
   return true;
}

function init(){
	var ob = document.createElement('<img src="<%= WebUtil.ImageURL %>btn_close.gif" name="image" align="absmiddle" border="0" style="cursor:hand;">');
	ob.onclick =  function() {
		var retVal = new Object();

		var idx = null;
		for(var i=0; i<<%=dayschedule_vt.size()%>; i++){
			if(eval("document.form1.chk["+i+"].checked")){
				idx = i;
			}
		}
		window.returnValue = retVal;
		window.close();
	};
// 	document.getElementById("closeButton").appendChild(ob);
}


$(function(){
	init();	
	var w = 900;
	var h = 662;
	var offset = $(".bottonX").offset();
	resizeTo( w, offset.top + 100);
})

-->
</script>

<form name="form1" method="post" onsubmit="return false">

      <div class="tableArea" >
      	<div class="table">
                  <table class="listTable" >
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
                    <tr>
                      		
		                <th><spring:message code="LABEL.D.D12.0017"/> <!-- 사원번호--></th>
		                <th><spring:message code="LABEL.D.D12.0018"/> <!-- 이름--></th>
		                <th><spring:message code="LABEL.D.D15.0206"/> <!-- 일자--></th>
		                <th><spring:message code="LABEL.D.D13.0022"/> <!-- 요일--></th>
		                <th><spring:message code="LABEL.D.D13.0023"/> <!-- DWS--></th>
		                <th><spring:message code="LABEL.D.D13.0024"/> <!-- DWS변형--></th>
		                <th><spring:message code="LABEL.D.D13.0025"/> <!-- 일일WS--></th>
		                <th><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
		                <th><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
		                <th><spring:message code="LABEL.D.D13.0017"/> <!-- 근무시간--></th>
		                <th><spring:message code="LABEL.D.D13.0026"/> <!-- 기간근무일정--></th>
		                <th class="lastCol"><spring:message code="LABEL.D.D13.0027"/> <!-- 기간근무일정명 --></th>
		             </tr>
                   
                    <c:forEach var="row" items="${dayschedule_vt}" varStatus="status">
                        <tr id="-row-${status.index}" class="${f:printOddRow(status.index)}" height=25 >
		                      
		                      <td>${ row.PERNR }</td>
		                      <td>${ row.ENAME }</td>
		                      <td>${ row.BEGDA }</td>
		                      <td>${ row.KURZT }</td>
		                      <td>${ row.TPROG }</td>
		                      <td>${ row.VARIA }</td>
		                      <td>${ row.TTEXT }</td>
		                      <td>${ f:printTime(row.SOBEG) }</td>
		                      <td>${ f:printTime(row.SOEND) }</td>
		                      <td>${ f:printTime(row.STDAZ) }</td>
		                      <td>${ row.ZMODN }</td>
		                      <td class="lastCol">${ row.ZTEXT }</td>
                    	</tr>
                    
				   </c:forEach>


                  </table>
			</div>
           <div class="buttonArea">
			
			    <ul class="btn_crud">
<!-- 			        <li><a href="javascript:parent.hidePop();"> -->
			        <li><a href="javascript:close();">
			        	<span><spring:message code="BUTTON.COMMON.CLOSE"></spring:message></span></a></li>
			    </ul>
			
			</div>

       </div>
      

<!-- HIDDEN  처리해야할 부분 시작 -->
<!-- HIDDEN  처리해야할 부분 끝   -->
</form>
<div class="bottonX"></div>
<!-------hidden------------>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

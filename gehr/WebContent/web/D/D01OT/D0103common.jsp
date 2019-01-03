<%--/*
 * 		Name: D0103common.jsp
		Desc: 근태, 휴가 공통 js
		 <jsp:include page="${g.jsp }D/D01OT/D0103common.jsp"/>
*/
 --%>
 
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
function setApp(originalRequest){
	var resTxt = originalRequest; 
	 $.unblockUI();

	if(resTxt != ''){
		
		$('#-approvalLine-layout').html(unescape(resTxt));
    	if(parent.resizeIframe){
			parent.resizeIframe(document.body.scrollHeight);
     	}
	}

    $("a,.unloading").click(function() {			/* 동적결재란을 위해 재호출 */
        if(!$(this).hasClass("loading")) {
            window.onbeforeunload = null;
            setTimeout(setBeforeUnload, 1000);
        }
    });

}

</script>

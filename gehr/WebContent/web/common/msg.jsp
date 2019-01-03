<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="org.apache.commons.lang.ObjectUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/include/includeCommon.jsp"%>
<!-- header 부 선언 html js, css, header 부 선언 -->
<jsp:include page="/include/header.jsp" />
<%
    String message = null;

    String msg = ObjectUtils.toString(request.getAttribute("msg"));
    if (StringUtils.isNotBlank(msg)) {
	    String code = msg.toLowerCase();
	    if (code.startsWith("msg")) {
	             if ("msg001".equals(code)) message = g.getMessage("MSG.COMMON.0001"); // 신청 되었습니다.
	        else if ("msg002".equals(code)) message = g.getMessage("MSG.COMMON.0002"); // 수정 되었습니다.
	        else if ("msg003".equals(code)) message = g.getMessage("MSG.COMMON.0003"); // 삭제 되었습니다.
	        else if ("msg004".equals(code)) message = g.getMessage("MSG.COMMON.0004"); // 해당하는 데이타가 존재하지 않습니다.
	        else if ("msg005".equals(code)) message = g.getMessage("MSG.COMMON.0005"); // 결재가 진행중 입니다.
	        else if ("msg006".equals(code)) message = g.getMessage("MSG.COMMON.0006"); // 계좌번호가 등록되지 있지 않습니다.
	        else if ("msg007".equals(code)) message = g.getMessage("MSG.COMMON.0007"); // 입력 되었습니다.
	        else if ("msg008".equals(code)) message = g.getMessage("MSG.COMMON.0008"); // 저장 되었습니다.
	        else if ("msg009".equals(code)) message = g.getMessage("MSG.COMMON.0009"); // 결재 되었습니다.
	        else if ("msg010".equals(code)) message = g.getMessage("MSG.COMMON.0010"); // 반려 되었습니다.
	        else if ("msg011".equals(code)) message = g.getMessage("MSG.COMMON.0011"); // 결재 취소 되었습니다.
	        else if ("msg012".equals(code)) message = g.getMessage("MSG.COMMON.0012"); // 확정 처리되었습니다.
	        else if ("msg013".equals(code)) message = g.getMessage("MSG.COMMON.0013"); // 확정 실패입니다.
            else if ("msg014".equals(code)) message = g.getMessage("MSG.COMMON.0014"); // 확정 실패입니다. //"부서구분 번호가 없습니다. 인사담당자에게 문의하시기 바랍니다.";//@2014 연말정산 추가(송현우K 요청)
    	} else {
    	    message = msg;
    	}
    }

    String msg2 = ObjectUtils.toString(request.getAttribute("msg2"));
    if (StringUtils.isNotBlank(msg2)) {
        message += "\\n" + msg2;
    }

    request.setAttribute("message", message);
%>
<script language="javascript">
var msg = '${!empty message ? fn:replace(message, "'", "\"") : ""}';
if (msg) {
    alert(msg);
}

${url};
</script>
<jsp:include page="/include/footer.jsp" />
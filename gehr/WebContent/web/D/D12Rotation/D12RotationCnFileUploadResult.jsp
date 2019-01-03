<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-emp-pay" tagdir="/WEB-INF/tags/D/D15" %>

<tags:layout-pop title="LABEL.COMMON.FILEUPLOAD" unblock="false">
    <script>
        blockFrame();
    </script>
    <tags:script>
    <script>
         var result = ${resultData};
         var successSize = ${successSize};
         var failSize = ${failSize};
         var successSizeResult = "<spring:message code='COMMON.PAGE.TOTAL' arguments='${failSize}' />";
         var msg = "<spring:message code='LABEL.D.D12.0081'/> : "+ successSize + " <spring:message code='LABEL.D.D12.0083'/> <spring:message code='LABEL.D.D12.0082'/> : "+ failSize + "<spring:message code='LABEL.D.D12.0083'/>";
         opener.afterUploadProcess(result, successSizeResult, msg);
         top.close();
//          this.close();
    </script>
    </tags:script>
</tags:layout-pop>



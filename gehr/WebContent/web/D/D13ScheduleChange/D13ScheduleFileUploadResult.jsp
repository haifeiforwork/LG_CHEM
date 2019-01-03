<%--
  Created by IntelliJ IDEA.
  User: manyjung
  Date: 2016-10-24
  Time: 오후 2:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-emp-pay" tagdir="/WEB-INF/tags/D/D15" %>

<tags:layout-pop title="LABEL.COMMON.FILEUPLOAD">
    <script>
        try{
            var result = ${resultData};
            var successSize = ${successSize};
            var failSize = ${failSize};
            var msg = "<spring:message code='LABEL.D.D12.0081'/> : "+ successSize + " <spring:message code='LABEL.D.D12.0083'/> <spring:message code='LABEL.D.D12.0082'/> : "+ failSize + "<spring:message code='LABEL.D.D12.0083'/>${msg2}";
            opener.afterUploadProcess(result, failSize, msg);
//             parent.alert();
//             window.parent.close();
            this.close();
        } catch(e) {
            alert("<spring:message code='MSG.COMMON.UPLOAD.FAIL'/>" );//업로드에 실패하였습니다.");
        }

    </script>
</tags:layout-pop>



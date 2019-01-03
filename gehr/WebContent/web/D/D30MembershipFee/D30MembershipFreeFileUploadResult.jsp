<%--
  Created by IntelliJ IDEA.
  User: manyjung
  Date: 2016-10-24
  Time: 오후 2:02
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-memebership" tagdir="/WEB-INF/tags/D/D30" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<tags:layout-pop title="LABEL.COMMON.FILEUPLOAD" unblock="false">
    <script>
        blockFrame();
    </script>
    <tags:script>
    <script>

        $(function() {
            try{
                <%--var result = ${resultData};--%>
                <%--opener.afterUploadProcess(result);--%>
                opener.afterUploadProcess($("#-listTable-body"));
                window.close();
            } catch(e) {
                alert("<spring:message code='MSG.COMMON.UPLOAD.FAIL'/>" );//업로드에 실패하였습니다.");
                window.close();
            }
        });
    </script>
    </tags:script>

    <div id="excelUploadResult" style="display: none; top: -99999; ">
    <tags-memebership:membership-build-list />
    </div>
</tags:layout-pop>



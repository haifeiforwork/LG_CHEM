<%@ page import="com.common.Utils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="g" value="<%=Utils.getBean("global")%>"/>
<tags:layout-pop title="LABEL.COMMON.FILEUPLOAD">
    <tags:script>
        <script>
            function save() {
                blockFrame();
                document.form1.submit();
            }
        </script>
    </tags:script>

    <div class="tableArea">
        <div class="table">
            <table id="-search-table" class="tableGeneral tableApproval">
                <form name="form1" method="post" enctype="multipart/form-data" action="${g.servlet}hris.D.D12Rotation.D12RotationCnExcelUpload">
                <tr>
                    <td>
                        <input type="file" name="uploadFile" id="uploadFile" style="width: 90%;" />
                        <input type="hidden" name="I_YYYYMM" id="I_YYYYMM" value="${param.YYYYMM}"/>
                    </td>
                </tr>
                </form>
            </table>
        </div>
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:;" onclick="save();"><span><spring:message code="BUTTON.COMMON.SAVE" /><%--저장--%></span></a></li>
            </ul>
        </div>
    </div>

</tags:layout-pop>
<%@ tag import="com.common.Utils" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="uploadURL" type="java.lang.String" required="true" %>

<tags:layout-pop title="LABEL.COMMON.FILEUPLOAD">
    <tags:script>
        <script>
            function save() {
                if(confirm("<spring:message code='MSG.D.D15.0101' />")) {//엑셀 업로드시 기존 등록된 데이타는 삭제됩니다. 계속하시겠습니까?"
                    blockFrame();
                    document.form1.submit();
                }
            }
        </script>
    </tags:script>

    <div class="tableArea">
        <div class="table">
            <table id="-search-table" class="tableGeneral tableApproval">
                <form name="form1" method="post" enctype="multipart/form-data" action="${uploadURL}">
                    <tr>
                        <td>
                           <input type= "file" name="uploadFile" id="uploadFile" style="width: 90%;" />
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
        <div class="commentsMoreThan2">
            <div><spring:message code="MSG.D.D15.0100" /><%--엑셀 업로드시 기존 등록된 데이타는 삭제 됩니다.--%></div>
        </div>
    </div>

</tags:layout-pop>
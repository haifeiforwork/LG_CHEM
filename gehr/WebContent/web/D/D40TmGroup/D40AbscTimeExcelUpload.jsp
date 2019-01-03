<%@ page import="com.common.Utils" %><%--
  Created by jjh IDEA.
  User: manyjung
  Date: 2017-12-08
  Time: 오후 2:02
  To change this template use File | Settings | File Templates.
--%>
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
//                 if(confirm('<spring:message code="MSG.D.D15.0101" />')) {//엑셀 업로드시 기존 등록된 데이타는 삭제됩니다. 계속하시겠습니까?"
                if(confirm('<spring:message code="MSG.COMMON.SAVE.CONFIRM" />')) {//저장하시겠습니까?"
	                blockFrame();
	                document.form1.submit();
                }
            }
        </script>
    </tags:script>

    <div class="tableArea">
        <div class="table">
            <table id="-search-table" class="tableGeneral tableApproval">
                <form name="form1" method="post" enctype="multipart/form-data" action="${g.servlet}hris.D.D40TmGroup.D40AbscTimeExcelUpload">
                <tr>
                    <td>
                        <input type="file" name="uploadFile" id="uploadFile"  style="width: 90%;" />
                    </td>
                </tr>
                </form>
            </table>
        </div>
        <div class="buttonArea">
            <ul class="btn_crud">
<%--                 <li><a href="javascript:;" onclick="opener.upload();"><span><spring:message code="BUTTON.COMMON.SAVE" /></span></a></li> --%>
                <li><a href="javascript:;" onclick="save();"><span><spring:message code="BUTTON.COMMON.SAVE" /></span></a></li>
            </ul>
        </div>
        <%--
        <div class="commentsMoreThan2">
            <div><spring:message code="MSG.D.D15.0100" />엑셀 업로드시 기존 등록된 데이타는 삭제 됩니다.</div>
        </div>
         --%>
    </div>

</tags:layout-pop>
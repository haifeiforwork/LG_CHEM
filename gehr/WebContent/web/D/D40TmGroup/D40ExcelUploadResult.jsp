<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   공통														*/
/*   Program Name	:   엑셀 업로드 결과										*/
/*   Program ID		: D40DailScheSearch.jsp								*/
/*   Description		: 엑셀 업로드 결과 부모창으로 전달						*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<tags:layout-pop title="LABEL.COMMON.FILEUPLOAD">
    <script>
        try{
            var result = '<c:out value="${resultData }" escapeXml="false"/>';
            var failSize = '<c:out value="${E_RETURN }"/>';
            var msg = '<c:out value="${E_SAVE_CNT }"/>';

            opener.afterUploadProcess(result, failSize, msg);
//             parent.alert();
//             window.parent.close();
             this.close();
        } catch(e) {
            alert("<spring:message code='MSG.COMMON.UPLOAD.FAIL'/>" );//업로드에 실패하였습니다.");
        }

    </script>
</tags:layout-pop>



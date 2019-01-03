<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색 wait 창                                            */
/*   Program ID   : SearchDeptPersonsWait.jsp                                   */
/*   Description  : 사원검색 wait 창                                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/web/common/includeLocation.jsp"/>
<tags:layout >
    <meta http-equiv='cache-control' content='no-cache'>
    <meta http-equiv='expires' content='0'>
    <meta http-equiv='pragma' content='no-cache'>
    <tags:script>
        <script>
            $(function() {
                blockFrame();
                document.form1.submit();
            });
        </script>
    </tags:script>
    <form name="form1" method="post" action="${param.url}">
        <c:forEach var="paramMap" items="${paramValues}">
            <input type="hidden" name="${paramMap.key}" value="${paramMap.value[0]}"/>
        </c:forEach>
    </form>
</tags:layout>



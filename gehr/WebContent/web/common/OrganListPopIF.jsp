<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : OrganListPopIF.jsp                                          */
/*   Description  : 조직도 조회 PopUp의 iFrame                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20  유용원                                          */
/*   Update       : 2018-05-14  [WorkTime52] 유정우 하위조직선택 alert 추가     */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/common" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<tags:layout >
    <common:mss-tree-layout url="${g.servlet}hris.common.OrganListSV"/>
    <tags:script>
        <script>
            var includeSubOrg = '${param.includeSubOrg}';<%-- 2018.05.14 [WorkTime52] 유정우 --%>

            // 폴더 선택시
            function fol(deptId, deptNm) {

                <%-- 2018.05.14 [WorkTime52] 유정우 --%>
                if (deptId === '50000000' && includeSubOrg === 'Y') {
                    alert('<spring:message code="MSG.D.D25.N0021" />'); // 선택하신 조직은 데이터가 너무 많습니다.\n\n하위조직을 선택하여 조회하시기 바랍니다.
                    return;
                }

                // opener에 함수 호출
                parent.opener.setDeptID(deptId, deptNm);
            }
        </script>
    </tags:script>
</tags:layout>
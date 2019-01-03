<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : OrganListLeftIF.jsp                                         */
/*   Description  : 조직도 조회 iFrame                                          */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20  유용원                                          */
/*   Update       :                                                             */
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
            //폴더 선택시.
            function fol(deptId, deptNm) {
                var frm = document.form1;

                frm.action = "${g.jsp}"+"common/OrganListRightIF.jsp";
                frm.hdn_deptId.value = deptId;
                frm.hdn_deptNm.value = deptNm;
                frm.target = "iFrame2";
                frm.submit();
            }


        </script>
    </tags:script>
    <form name="form1" method="post" action="">
            <%--            <input type="hidden" name="deptCount" value="<%=deptCount%>">
                        <input type="hidden" name="hdn_popCode" value="A">--%>
        <input type="hidden" name="hdn_deptId" value="">
        <input type="hidden" name="hdn_deptNm" value="">
        <input type="hidden" name="I_IMWON" value="${param.I_IMWON}">

    </form>
</tags:layout>




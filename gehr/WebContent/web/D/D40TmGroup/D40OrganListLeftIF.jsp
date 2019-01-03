<%--
/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : OrganListLeftIF.jsp                                         */
/*   Description  : 조직도 조회 iFrame                                          */
/*   Note         : 없음                                                        */
/*   Creation     : 2017-12-08  정준현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>


<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="d40" tagdir="/WEB-INF/tags/D/D40" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<tags:layout >
    <d40:mss-tree-layout url="${g.servlet}hris.D.D40TmGroup.D40OrganListSV"/>
    <tags:script>
        <script>
            //폴더 선택시.
            function fol(deptId, deptNm) {
                var frm = document.form1;

                frm.action = '<c:out value="${g.servlet}"/>'+"D/D40TmGroup/D40OrganListRightIF.jsp";
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
        <input type="hidden" name="I_IMWON" value='<c:out value="${param.I_IMWON}"/>'>

    </form>
</tags:layout>




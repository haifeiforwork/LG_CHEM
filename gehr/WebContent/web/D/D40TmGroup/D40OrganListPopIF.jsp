<%--
/******************************************************************************/
/*                                                                          			    */
/*   System Name  : MSS                                               	      */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :  근태그룹정의                                                           */
/*   Program Name : 근태그룹인원지정 팝업                                                 */
/*   Program ID   : D40OrganListPopIF.jsp                                       */
/*   Description  : 근태그룹인원지정 PopUp의 iFrame                                           */
/*   Note         : 사용안함 페이지 이동으로 처리                                                        */
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
            //폴더 선택시.
            function fol(deptId, deptNm)
            {
                var frm = document.form1;

                //opener에 함수 호출
                parent.opener.setDeptID(deptId, deptNm);
                //parent.close();
            }


        </script>
    </tags:script>
</tags:layout>



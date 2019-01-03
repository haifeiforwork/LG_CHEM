<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : OrganListPop.jsp                                            */
/*   Description  : 조직도 조회 PopUp                                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20  유용원                                          */
/*   Update       : 2018-05-14  [WorkTime52] 유정우 includeSubOrg parameter 추가*/
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="g" value="<%=g%>"/>
<tags:layout-pop title="LABEL.SEARCH.DEPT">

        <div style="border:1px solid #ddd; overflow: hidden; padding-right: 10px;">
            <IFRAME src="${g.servlet}hris.common.OrganListSV?isFirst=Y&popCode=B&includeSubOrg=${param.includeSubOrg}" name="iFrame" frameborder="0" leftmargin="0" height="350" width="340px" marginheight="0" marginwidth="0" topmargin="0" scrolling="auto" style="margin:10px;" ></IFRAME>
        </div>

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
            </ul>
        </div>
</tags:layout-pop>

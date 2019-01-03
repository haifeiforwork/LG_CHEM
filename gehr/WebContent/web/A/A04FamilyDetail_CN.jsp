<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 가족사항 조회                                               */
/*   Program ID   : A04FamilyDetail.jsp                                         */
/*   Description  : 가족사항 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-03-02  윤정현                                          */
/*                  2005-05-03  @v1.1가족수당폐지                               */
/*                              @v1.3가족수당삭제                               */
/*                  2008-04-21  lsa @v1.0 [CSR ID:1254077]대리신청시 정보조회안되게수정*/
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정  */
/*                  2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청                                                             */
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="isOwner" value="${PERNR == user.empNo}"/>


<jsp:useBean id="detailBody" class="com.common.vo.BodyContainer" scope="page" />

<tags:body-container bodyContainer="${detailBody}">

	<div class="tableArea">
		<div class="table">
            <table class="tableGeneral">
                <colgroup>
                    <col width="15%">
                    <col width="35%" >
                    <col width="15%">
                    <col width="35%" >
                </colgroup>
                <tr style="display:none">
                    <th><spring:message code="LABEL.A.A04.0002" /><!-- Title --></th>
                    <td colspan="3">
                        <input type="text" name="avalue28" value=""  size="20" readonly>
                    </td>
                </tr>
                <tr style="display:none">
                    <th><spring:message code="MSG.A.A14.0014" /><!-- Last Name --></th>
                    <td> <input type="text" name="FANAM" value="" size="20" readonly>
                    </td>
                </tr>
                <tr style="display:none">
                    <th><spring:message code="MSG.A.A14.0015" /><!-- First Name --></th>
                    <td colspan="3"> <input type="text" name="FAVOR"  value="" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A01.0002" /><!-- Name --></th>
                    <td><input type="text" name="ENAME" value=""  size="20" readonly> </td>
                    <th class="th02"><spring:message code="LABEL.A.A04.0001" /><!-- Family&nbsp;Type --></th>
                    <td>
                        <input type="text" name="FAMSA" value="" size="20" readonly>
                        <input type="hidden" name="SUBTY" >
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A01.0028" /><!-- Gender --></th>
                    <td >
                        <input type="radio" id="FASEX_2" name="FASEX" value="2" disabled> <spring:message code="LABEL.A.A12.0020" /><%--여--%>
                        <input type="radio" id="FASEX_1" name="FASEX" value="1" disabled> <spring:message code="LABEL.A.A12.0019" /><%--남--%>
                    </td>
                    <th class="th02"><spring:message code="LABEL.A.A04.0003" /><!-- Corporation Name --></th>
                    <td><input type="text" name="ERNAM2"  value="" size="20" readonly></td>

                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A01.0026" /><!-- Birth Date --></th>
                    <td> <input type="text" name="FGBDT"  value=""  size="20" readonly></td>
                    <th class="th02"><spring:message code="MSG.A.A01.0025" /><!-- Birth Place --></th>
                    <td> <input type="text" name="FGBOT"  value=""  size="20" readonly>
                    </td>
                    <!--
                      <th>Age</th>
                      <td ></td>
                    -->
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A01.0024" /><!-- Nationality --></th>
                    <td >
                        <input type="text" name="LANDX" size="20"    readonly>
                    </td>
                    <th class="th02"><spring:message code="LABEL.A.A12.0010" /><!-- Occupation --></th>
                    <td >
                        <input type="text" name="OCCUPS"  value="" size="20" readonly>
                        <input type="hidden" name="OCCUP"  value="" size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.A.A04.0004" /><!-- City of Birth --></th>
                    <td >
                        <input type="text" name="F28address" value="" size="20" readonly>
                    </td>
                    <th class="th02"><spring:message code="MSG.A.A01.0033" /><!-- Political Status --></th>
                    <td> <input type="text" name="PSTXT" value="" size="30" readonly>
                    </td>
                </tr>
                <tr>
            <c:choose>
                <c:when test="${PersonData.e_PERSG == 'A'}">
                    <%--begin 2012-08-06 lixinxin@v1.9 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                    <th><spring:message code="LABEL.A.A12.0041" /><!-- Entry Date --></th>
                    <td> <input type="text" name="ENTDT"  value="" size="20" readonly></td>
                    <!-- // 2012-07-09 lixinxin@v1.7 [C20120710_44214] Family 添加详细信息 联系方式电话号 和邮箱  TELNR   NUMMAIL -->
                    <th class="th02"><spring:message code="LABEL.A.A04.0005" /><!-- Tel. Number --></th>
                    <td> <input type="text" name="TELNR"  value="" size="20" readonly></td>
                </c:when>
                <c:otherwise>
                    <th><spring:message code="LABEL.A.A04.0005" /><!-- Tel. Number --></th>
                    <td   colspan="3"> <input type="text" name="TELNR"  value=""  size="20" readonly></td>
                </c:otherwise>
            </c:choose>
                    <%--end 2012-08-06 lixinxin@v1.9 [C20120802_58605] Family Entry Date只有在本地出差的韩国人才能显示 --%>
                </tr>
                <tr>
                    <th><spring:message code="MSG.A.A01.0043" /><!-- Current home address --></th>
                    <td  colspan="3"> <input type="text" name="FAMIADDR"  value="" size="90" readonly></td>
                </tr>
            </table>
        </div>
	</div>

    <!-- HIDDEN으로 처리 -->
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="ThisJspName" value="A04FamilyDetail.jsp">

    <input type="hidden" name="subView" value="${param.subView}">
    <!-- HIDDEN으로 처리 -->
</tags:body-container>

<tags-family:family-layout-global detailBody="${detailBody}"/>




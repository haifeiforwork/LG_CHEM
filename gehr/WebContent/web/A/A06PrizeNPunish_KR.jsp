<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 포상/징계                                                   */
/*   Program Name : 포상 및 징계내역 조회                                       */
/*   Program ID   : A06PrizeNPunish.jsp                                         */
/*   Description  : 포상 및 징계내역 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-26  윤정현                                          */
/*   Update       : RequestPageName 보상명세서에서 이전가기 추가                */
/*                  2013.04.26 [CSR ID:2319361] 징계종료일자   추가              */
/*   Update       : C20130425_19315징계종료일자 추가 요청                       */
/*   Update       : C20130611_47348 징계기간추가                                */
/*                  2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)     */
/*                  2018-05-15 rdcamel [CSR ID:3688934] 부서원 개인인적사항 "포상징계" 탭 오류 수정요청                                                            */
/*                                                                              */
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector prizeList = (Vector) request.getAttribute("prizeList");
    String paging = (String) request.getAttribute("page");
    String sortField = (String) request.getAttribute("sortField");
    String sortValue = (String) request.getAttribute("sortValue");
    //[CSR ID:3688934] pageType(M : 타인 조회) 추가
    String pageType = WebUtil.nvl( (String) request.getAttribute("pageType")).toLowerCase();
    PageUtil pu = new PageUtil(prizeList.size(), paging, 10, 10);  //Page 관련사항

    //[CSR ID:2995203]
    String RequestPageName = (String) request.getAttribute("RequestPageName");
    // 2015- 06-08 개인정보 통합시 subView ="Y";
%>

<jsp:include page="/include/header.jsp"/>
<form name="form1" method="post">

    <h2 class="subtitle"><spring:message code="MSG.A.A06.0001"/><%--포상--%></h2>

    <!-- 포상내역 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
            <thead>
                <%
                    if (prizeList.size() > 0) {
                %>
                <tr>
                    <th onClick="javascript:sortPage('PRIZ_DESC,GRAD_TEXT,BEGDA','asc,asc,desc')" style="cursor:hand">
                        <spring:message code="MSG.A.A06.0002"/><%--포상항목 - 등급--%>
                        <%= sortField.equals("PRIZ_DESC,GRAD_TEXT,BEGDA") ? (sortValue.toLowerCase()).equals("desc,desc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                    </th>
                    <th onClick="javascript:sortPage('BEGDA')" style="cursor:hand">
                        <spring:message code="MSG.A.A06.0003"/><%--수상일자--%>
                        <%= sortField.equals("BEGDA") ? (sortValue.toLowerCase()).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                    </th>
                    <th><spring:message code="MSG.A.A06.0004"/><%--포상점수--%></th>
                    <th><spring:message code="MSG.A.A06.0005"/><%--시상주체--%></th>
                    <th><spring:message code="MSG.A.A06.0006"/><%--포상금액--%></th>
                    <th class="lastCol"><spring:message code="MSG.A.A06.0007"/><%--수상내역--%></th>
                </tr>
                </thead>
                <%
                    for (int j = pu.formRow(); j < pu.toRow(); j++) {
                        A06PrizDetailData data = (A06PrizDetailData) prizeList.get(j);
                        String amt = DataUtil.changeLocalAmount(data.PRIZ_AMNT, user.area);
                %>
                <tbody>
                <tr class="<%=WebUtil.printOddRow(j) %>">
                    <td><%= data.PRIZ_DESC %><%=StringUtils.isNotEmpty(data.GRAD_TEXT) ? "-" : ""%><%= data.GRAD_TEXT %></td>
                    <td><%= WebUtil.printDate(data.BEGDA) %></td>
                    <td><%= data.GRAD_QNTY %></td>
                    <td><%= data.BODY_NAME %></td>
                    <td style="text-align:right"><%= WebUtil.printNumFormat(amt).equals("0") ? "" : WebUtil.printNumFormat(amt) + " 원" %></td>
                    <td class="lastCol" >&nbsp;<%= data.PRIZ_RESN %></td>
                </tr>
                </tbody>
                <%
                    }
                } else {
                %>
                <thead>
                <tr>
                    <th><spring:message code="MSG.A.A06.0002"/><%--포상항목 - 등급--%></th>
                    <th><spring:message code="MSG.A.A06.0003"/><%--수상일자--%></th>
                    <th><spring:message code="MSG.A.A06.0004"/><%--포상점수--%></th>
                    <th><spring:message code="MSG.A.A06.0005"/><%--시상주체--%></th>
                    <th><spring:message code="MSG.A.A06.0006"/><%--포상금액--%></th>
                    <th class="lastCol"><spring:message code="MSG.A.A06.0007"/><%--수상내역--%></th>
                </tr>
                </thead>
                <tbody>
                <tr align="center">
                    <td class="lastCol" colspan="6"><spring:message code="MSG.COMMON.0004"/><%--해당하는 데이터가 존재하지 않습니다.--%></td>
                </tr>
                </tbody>
            </table>
            <%
                }
            %>
            </table>
            <!-- PageUtil 관련 - 반드시 써준다. -->
            <%
                if (pu != null && !pu.pageControl().equals("")) {
            %>
            <div><%= pu.pageControl() %>
            </div>
            <%
                }
            %>
            <!-- PageUtil 관련 - 반드시 써준다. -->
        </div>
    </div>

    <!-- 포상내역 리스트 테이블 끝-->


    <!--징계내역 리스트 테이블 시작-->
    <self:self-punish punishList="${punishList}" />
    <!--징계내역 리스트 테이블 끝-->

    <% //[CSR ID:2995203] 보상명세서 용 뒤로가기.
        boolean isCanGoList;
        if (RequestPageName == null || RequestPageName.equals("")) {
            isCanGoList = false;
        } else {
            isCanGoList = true;
        } // end if
        if (isCanGoList) { %>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back()"><span><spring:message code="BUTTON.COMMON.BACK" /><%--뒤로가기--%></span></a></li>
        </ul>
    </div>
    <% } %>
    </div>

    <input type="hidden" name="test" value="<%= user.webUserId %>">
</form>
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp" />
<script language="JavaScript">
    <!--

    function pageChange(page) {
        document.form3.page.value = page;
        //doSubmit();
        get_Page();
    }
    // PageUtil 관련 script - page처리시 반드시 써준다...
    function get_Page() {
    	// [CSR ID:3688934] A06PrizeNPunishSV_m 도 호출할 수 있도록 수정
        document.form3.action = '<%= WebUtil.ServletURL %>hris.A.A06PrizeNPunishSV<%=pageType.equals("m") ? "_"+pageType : ""  %>';
        document.form3.method = "post";
        document.form3.submit();
    }

    function sortPage(FieldName, FieldValue) {
        if (document.form3.sortField.value == FieldName) {
            if (FieldName == 'BEGDA') {
                if (document.form3.sortValue.value == 'desc') {     //수상일자 sort시
                    document.form3.sortValue.value = 'asc';
                } else {
                    document.form3.sortValue.value = 'desc';
                }
            } else if (FieldName == 'PRIZ_DESC,GRAD_TEXT,BEGDA') {  //포상항목 - 등급 sort시
                if (document.form3.sortValue.value == 'asc,asc,desc') {
                    document.form3.sortValue.value = 'desc,desc,desc';
                } else {
                    document.form3.sortValue.value = 'asc,asc,desc';
                }
            }
        } else {
            document.form3.sortField.value = FieldName;
            document.form3.sortValue.value = FieldValue;
        }
        get_Page();
    }
    //-->
</script>
<form name="form3" METHOD=POST ACTION="">
    <input type="hidden" name="page" value="<%= paging %>">
    <input type="hidden" name="sortField" value="<%= sortField %>">
    <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

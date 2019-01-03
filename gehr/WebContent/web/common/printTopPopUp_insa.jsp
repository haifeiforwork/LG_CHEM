<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.common.WebUserData" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<!-- ************************** 인사기록부 출력 Top. jsp ************************-->

<!------------------------------------------------------------------------------>

<!-- Program ID : printTopPopUp_insa.jsp -->

<!-- Description : 인사기록부 출력화면(PopUp) Top -->

<!-- Note : 없음 -->

<!-- Creation : 2015/05/30 -->

<!-- --------------------------------------------------------------------------->

<!-- DATE AUTHOR DESCRIPTION -->

<!-- --------------------------------------------------------------------------->

<!-- 2014/06/09 이지은D [CSR ID:2553584] 인사기록부 출력 포맷 변경 -->
<!-- 2017/07/13 eunha [CSR ID:3475164] 인사기록부 수정 요청 -->
<!------------------------------------------------------------------------------>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>"/>
<c:set var="user_m" value="<%=WebUtil.getSessionMSSUser(request)%>"/>
<tags:layout-pop title="MSG.A.MSS.CARD.VIEW">
    <c:if test="${fn:indexOf(user.e_authorization, 'H') > 0}">
        <tags:script>
            <script language="javascript">
                function f_print() {
                    if (confirm("<spring:message code="MSG.COMMON.0082"/>")) {

                    	//2017/07/13 eunha [CSR ID:3475164] 인사기록부 수정 요청 start
                    	var viewYN = "N" ;
                        if( $(".viewYn").is(":checked")){
                        	viewYN = "Y" ;
                        }
                      //2017/07/13 eunha [CSR ID:3475164] 인사기록부 수정 요청 end
                        parent.beprintedpage.focus();
                        //CSR ID:2553584
                        parent.beprintedpage.insaPrint(viewYN);


                        //parent.frames[1].printDocument("pdfDocument");
                    }
                }

                function changePerson(empNo) {
                    /*parent.location.href = "${g.jsp}common/printFrame_insa.jsp?viewEmpno=" + empNo;*/
                    document.location.href = "${g.servlet}hris.A.A01PersonalCardPrintButtonSV_m?reload=true&viewEmpno=" + empNo;
                }

                $(function() {
                    <c:if test="${param.reload == true}">
                    parent.loadFrame();
                    </c:if>
                });
            </script>
        </tags:script>

        <div class="buttonArea">
            <ul class="btn_crud">
               <%--2017/07/13 eunha [CSR ID:3475164] 인사기록부 수정 요청 start --%>
				<span name = "yearView" id = "yearView" style="display:none;">
				<c:if test="${user.area == 'KR'}">
				연차포함
				<input type="checkbox"  id ="viewYn"  name="viewYn" class = "viewYn" />
				</c:if>
				</span>
				<%--2017/07/13 eunha [CSR ID:3475164] 인사기록부 수정 요청 end --%>
                    <%--@elvariable id="interfaceData" type="hris.A.PersonalCardInterfaceData"--%>
                <c:if test="${not empty interfaceData}">
                    <div style="float:left">
                        <c:if test="${not empty interfaceData.personDataList and fn:length(interfaceData.personDataList) > 1}">
                            <li><a href="javascript:changePerson('${prevPerson}');"><span><spring:message code="BUTTON.COMMON.PREVIOUS" /><!-- 이전 --></span></a></li>
                            <select name="selectPerson" onchange="changePerson(this.value);" style="vertical-align:middle;">
                                <c:forEach var="row" items="${interfaceData.personDataList}">
                                    <option value="${f:encrypt(row.PERNR)}" ${row.PERNR == user_m.empNo ? 'selected' : ''} >${row.ENAME}</option>
                                </c:forEach>
                            </select>
                            <li><a href="javascript:changePerson('${nextPerson}');"><span><spring:message code="BUTTON.COMMON.NEXT" /><!-- 다음 --></span></a></li>
                        </c:if>
                    </div>
                </c:if>
                <li><a onclick="f_print();"><span><spring:message code="BUTTON.COMMON.PRINT"/><%--인쇄--%></span></a></li>

                    <%--<li><a onclick="top.close();"><span><spring:message code="BUTTON.COMMON.CLOSE" />&lt;%&ndash;닫기&ndash;%&gt;</span></a></li>--%>
            </ul>
        </div>
    </c:if>
</tags:layout-pop>




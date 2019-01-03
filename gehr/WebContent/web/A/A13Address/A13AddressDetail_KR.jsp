<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주소                                                        */
/*   Program Name : 주소                                                        */
/*   Program ID   : A13AddressDetail_KR.jsp                                        */
/*   Description  : 주소 조회                                                   */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-27  윤정현                                          */
/*   Update       : 2005-01-27  윤정현                                          */
/*   Update       : 2017-02-23 [CSR ID:3309431] 창립70주년 기념품 색상 파악 내역 화면 미표시 요청 | [요청번호]C20170222_09431  */
/********************************************************************************/
%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-address" tagdir="/WEB-INF/tags/A/A13Address" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<jsp:useBean id="buttonBody" class="com.common.vo.BodyContainer" scope="page"/>
<jsp:useBean id="resultData" class="hris.A.A13Address.A13AddressListData" scope="request"/>

<%--@elvariable id="g" type="com.common.Global"--%>
<%-- 하단 버튼 부 추가 버튼 부분만 (기본값: 목록)--%>
<tags:body-container bodyContainer="${buttonBody}">
    <c:if test="${resultData.SUBTY != '1' and resultData.SUBTY != '2'}">
        <tags:script>
            <script>
                function doSubmit_Change() {
                    document.form1.jobid.value = "first";
                    document.form1.action = '${g.servlet}hris.A.A13Address.A13AddressChangeSV';
                    document.form1.submit();
                }
            </script>
        </tags:script>
        <li><a href="javascript:;" onclick="doSubmit_Change();"><span><spring:message code="BUTTON.COMMON.UPDATE"/><!-- 수정 --></span></a></li>
    </c:if>
</tags:body-container>
<%-- 내용 부 --%>
<tags-address:address-detail-layout data="${resultData}" buttonBody="${buttonBody}">
<div class="tableArea">
	<div class="table">
	    <table class="tableGeneral">
	        <colgroup>
	            <col width="100">
	            <col>
	        </colgroup>
	        <form name="form1" method="post">
	            <input type="hidden" name="subView" value="${param.subView}"/>
	            <input type="hidden" name="jobid" value="">
	            <input type="hidden" name="I_SUBTY" value="${resultData.SUBTY }">
				<input type="hidden" name="idx" value="${param.idx}">
	            <tr>
	                <th><spring:message code="MSG.A.A13.010"/><%--주소유형--%></th>
	                <td>
						<input type="text" name="ANSTX" size="8" value="${resultData.ANSTX}" readonly>

						<input type="hidden" name="SUBTY" value='${resultData.SUBTY}'>
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code="MSG.A.A13.011"/><%--국가--%></th>
	                <td>
	                    <input type="text" name="LANDX" size="20" value="${resultData.LANDX }" readonly>
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code="MSG.A.A13.012"/><%--우편번호--%></th>
	                <td>
	                    <input type="text" name="PSTLZ" size="10" value="${resultData.PSTLZ }" readonly>
	                </td>
	            </tr>
	            <tr>
	                <th rowspan="2"><spring:message code="MSG.A.A13.013"/><%--주소--%></th>
	                <td>
	                    <input type="text" name="STRAS" size="120" value="${resultData.STRAS }" readonly>
	                </td>
	            </tr>
	            <tr>
	                <td>
	                    <input type="text" name="LOCAT" size="120" value="${resultData.LOCAT }" readonly>
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code="MSG.A.A13.014"/><%--전화번호--%></th>
	                <td>
	                    <input type="text" name="TELNR" size="20" value="${resultData.TELNR }" readonly>
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code="MSG.A.A13.015"/><%--주거형태--%></th>
	                <td>
	                    <input type="text" name="LIVE_TEXT" size="10" value="${resultData.LIVE_TEXT }" readonly>
	                </td>
	            </tr>
	            <%--2017-02-23 [CSR ID:3309431] 창립70주년 기념품 색상 파악 내역 화면 미표시 요청으로 색상 막음 begin
				<c:if test="${resultData.SUBTY == '4'}">
					<tr>
						<th>색상</th>
						<td>
							<select name="ACOLOR" disabled >
								<option value="1" ${resultData.ACOLOR == '1' ? 'selected' : ''}>블루</option>
								<option value="2" ${resultData.ACOLOR == '2' ? 'selected' : ''}>화이트</option>
								<option value="3" ${resultData.ACOLOR == '3' ? 'selected' : ''}>핑크</option>
							</select>
						</td>
					</tr>
				</c:if>
					2017-02-23 [CSR ID:3309431] 창립70주년 기념품 색상 파악 내역 화면 미표시 요청으로 색상 막음 end
					 --%>
	        </form>
	    </table>
	</div>
</div>
</tags-address:address-detail-layout>

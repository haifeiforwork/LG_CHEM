<%/*****************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 검색한 include 파일                                    */
/*   Program ID   : PersonInfo.jsp                                              */
/*   Description  : 사원 검색한 include 파일                                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-15  윤정현                                          */
/*   Update       :   :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건  */
/*                                                                              */
/*******************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    PersonData oPersonData = (PersonData)request.getAttribute("PersonData");
%>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <colgroup>
                    <col width="7%" />
                    <col width="18%" />
                    <col width="7%" />
                    <col width="18%" />
                    <col width="7%" />
                    <col width="10%" />
                    <col width="7%" />
                    <col width="26%" />
                </colgroup>
                <tr>
                  <th><spring:message code='LABEL.COMMON.0007' /><!-- 부서 --></th>
                  <td><input class="noBorder" size="30" type="text"  value="<%=oPersonData.E_ORGTX%>" readonly></td>
	              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    	          <%--<th class="th02"><spring:message code='LABEL.COMMON.0008' /><!-- 직위 --></th> --%>
        	      <th class="th02"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
            	  <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                  <td><input class="noBorder" size="20" type="text"  value="<%=oPersonData.E_JIKWT%>" readonly></td>
                  <th class="th02"><spring:message code='LABEL.COMMON.0009' /><!-- 직책 --></th>
                  <td><input class="noBorder" size="20" type="text"  value="<%=oPersonData.E_JIKKT%>" readonly></td>
                  <th class="th02"><spring:message code='MSG.APPROVAL.0013' /><!-- 성명 --></th>
                  <td>
                    <input class="noBorder" size="18" type="text"  value="<%=oPersonData.E_ENAME%>" readonly>
                    <input class="noBorder" size="8" type="text"  value="<%=oPersonData.E_PERNR%>" readonly>
                  </td>
                </tr>
                <input type="hidden" name="I_DEPT"   value="<%=oPersonData.E_PERNR%>">
                <input type="hidden" name="retir_chk" value="">
            </table>
        </div>
    </div>
  <!--   사원검색 보여주는 부분  끝    -->
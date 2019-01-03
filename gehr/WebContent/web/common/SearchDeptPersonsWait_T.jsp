<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색 wait 창                                            */
/*   Program ID   : SearchDeptPersonsWait.jsp                                   */
/*   Description  : 사원검색 wait 창                                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    String jobid     = request.getParameter("jobid");
    String i_dept    = user.empNo;
    String e_retir   = user.e_retir;
    String retir_chk = request.getParameter("retir_chk");

    String i_value1  = request.getParameter("I_VALUE1");
    String i_gubun   = request.getParameter("I_GUBUN");
%>

<jsp:include page="/include/header.jsp"/>

<script language="javascript">
    <!--
    $(function() {
        document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsPop_T.jsp";
        document.form1.submit();
    });

    //-->
</script>

<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.SEARCH.PERSON"/>
</jsp:include>
<form name="form1" method="post" action="" onsubmit="return false">
    <!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid"     value="<%= jobid    %>">
    <input type="hidden" name="I_DEPT"    value="<%= user.empNo   %>">
    <input type="hidden" name="E_RETIR"   value="<%= user.e_retir  %>">
    <input type="hidden" name="retir_chk" value="<%= retir_chk %>">
    <input type="hidden" name="I_VALUE1"  value="<%= i_value1 %>">
    <input type="hidden" name="I_GUBUN"   value="<%= i_gubun  %>">
    <!--  HIDDEN  처리해야할 부분 시작-->
</form>
<div class="listArea">
    <div class="table">
        <table class="listTable">
            <tr>
                <th width="30"><spring:message code="LABEL.COMMON.0014"/><%--선택--%></th>
                <th width="60"><spring:message code="MSG.A.A01.0005"/><%--사번--%></th>
                <th width="70"><spring:message code="MSG.A.A01.0002"/><%--성명--%></th>
                <th width="170"><spring:message code="MSG.A.A01.0006"/><%--부서--%></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              	<%--<th><spring:message code='LABEL.F.F00.0007'/><!-- 직위 --></th> --%>
              	<th width="70"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                <th width="70"><spring:message code="MSG.A.A05.0009"/><%--직책--%></th>
                <th width="80"><spring:message code="MSG.A.A05.0010"/><%--직무--%></th>
                <th class="lastCol" width="80"><spring:message code="MSG.A.A05.0004"/><%--근무지--%></th>
            </tr>
            <tr>
                <td align="center" class="lastCol" colspan="8"><font color="#006699"><spring:message code="LABEL.APPROVAL.0009"/><!-- 검색중입니다. 잠시만 기다려주십시요. --></font></td>
            </tr>
        </table>
    </div>
</div>
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>

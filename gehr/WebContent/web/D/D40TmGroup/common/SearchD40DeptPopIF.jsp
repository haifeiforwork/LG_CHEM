<%--
/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서조회                                                   */
/*   Program ID   : SearchD40DeptNamePop.jsp                                          */
/*   Description  : 부서명 입력하여 조회한 결과 화면                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2017-12-08 정준현                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");

	Vector DeptName_vt    = (Vector)request.getAttribute("DeptName_vt");

    String E_RETURN       = (String)request.getAttribute("E_RETURN");   //부서명
    String E_MESSAGE       = (String)request.getAttribute("E_MESSAGE");                //권한 그룹
%>

<jsp:include page="/include/header.jsp"/>
<script LANGUAGE="JavaScript">

</script>
<body>
<form name="form1" method="post" onsubmit="return false">

    <div class="listArea">
        <div class="table">
            <table class="listTable" >
                <colgroup>
                    <col width="30"/>
                    <col />
                </colgroup>
                <tr>
                    <th width="15%"  ><spring:message code='LABEL.COMMON.0014' /><!-- 선택 --></th>
                    <th width="85%" class="lastCol" ><spring:message code='LABEL.SEARCH.ORGEH.NAME' /><!-- 부서명 --></th>
                </tr>
                <%
                    //부서명, 조회된 건수.
                    if ( DeptName_vt != null && DeptName_vt.size() > 0 ) {
                        for( int i = 0; i < DeptName_vt.size(); i++ ){
                            SearchDeptNameData data = (SearchDeptNameData)DeptName_vt.get(i);
                            String tr_class = "";
                            if(i%2 == 0){
                                tr_class="oddRow";
                            }else{
                                tr_class="";
                            }
                %>
                <tr class="<%=tr_class%>">
                    <td class="td04">
                    	 <input type="checkbox" id="chkbutton<%=i %>" name="chkbutton" class="chkbox" value="<%= data.OBJID %>^<%= data.OBJTXT %>" >
                    </td>
                    <td class="align_left lastCol">
                    	<label for="chkbutton<%=i %>"><%= data.OBJTXT %></label>
                    </td>
                </tr>
                <%
                    } //end for...
                }else{
                %>
                <tr>
                    <td colspan="2" class="td04"><spring:message code='MSG.COMMON.0004' /><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
                </tr>
                <%
                    } //end if...
                %>
            </table>
        </div>
    </div>
</form>
</body>
<jsp:include page="/include/footer.jsp"/>




<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : SearchDeptNamePopIF.jsp                                     */
/*   Description  : 조직도 조회 PopUp                                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20  유용원                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>

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
    String deptNm       = WebUtil.nvl(request.getParameter("txt_deptNm"));   //부서명
    String authClsf       = request.getParameter("authClsf");                //권한 그룹
    Vector DeptName_vt = new Vector();
    String E_RETURN     = "";
    String E_MESSAGE    = "";

    try{
        Vector ret      = ( new SearchDeptNameRFC() ).getDeptName(user.empNo, deptNm, "M"); //권한 Set!!!
        E_RETURN        = WebUtil.nvl((String)ret.get(0));
        E_MESSAGE       = WebUtil.nvl((String)ret.get(1));
        DeptName_vt     = (Vector)ret.get(2);
    }catch(Exception ex){
        DeptName_vt     = null;
    }

    //RFC Logger....
    Logger.debug.println(this, "E_RETURN  : "+E_RETURN);
    Logger.debug.println(this, "E_MESSAGE : "+E_MESSAGE);
%>

<jsp:include page="/include/header.jsp"/>
<script LANGUAGE="JavaScript">
<!--
<%
    //RFC 성공여부.
    if( E_RETURN.equals("E") ){
%>
        alert("RFC에러 : "+"<%=E_MESSAGE%>");
        parent.close();
<%
    }
%>

//단건인 경우.
function init(){
<%

    if( DeptName_vt != null && DeptName_vt.size() == 1 ) {
        SearchDeptNameData data = (SearchDeptNameData)DeptName_vt.get(0);
%>
        selectDept('<%= data.OBJID %>', '<%= data.OBJTXT %>');
<%
    }
%>
}

//부서명 Set.
function selectDept(deptId, deptNm){
    //opener에 함수 호출
    parent.opener.setDeptID(deptId, deptNm);
    parent.close();
}
//-->
</script>
<body  onLoad="javascript:init();">
<form name="form1" method="post" onsubmit="return false">
    <input type="hidden" name="txt_deptNm"  value="<%=deptNm%>">
    <input type="hidden" name="authClsf"  value="<%=authClsf%>">

    <div class="listArea">
        <div class="table">
            <table class="listTable">
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
                %>
                <tr>
                    <td class="td04"><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:selectDept('<%= data.OBJID %>', '<%= data.OBJTXT %>');"></td>
                    <td class="align_left lastCol"><%= data.OBJTXT %></td>
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




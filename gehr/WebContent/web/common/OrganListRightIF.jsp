<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 조회                                                   */
/*   Program ID   : OrganListRightIF.jsp                                        */
/*   Description  : 조직도 조회 시 나타나는 사원리스트 iFrame                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-21  유용원                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@page import="org.apache.commons.lang.StringUtils"%>

<%
    WebUserData user     = (WebUserData)session.getAttribute("user");
    String deptId        = WebUtil.nvl(request.getParameter("hdn_deptId"));     //부서ID
    String deptNm        = WebUtil.nvl(request.getParameter("hdn_deptNm"));     //부서명
    String paging        = WebUtil.nvl(request.getParameter("hdn_page"));       //page 처리
    String E_RETURN      = WebUtil.nvl(request.getParameter("hdn_return"));     //E_RETURN 처리
    String E_MESSAGE     = WebUtil.nvl(request.getParameter("hdn_message"));    //E_MESSAGE 처리
    long  count         = Long.parseLong(WebUtil.nvl(request.getParameter("hdn_count"), "0"));

    String I_IMWON = StringUtils.defaultString(request.getParameter("I_IMWON"));

    Vector OrganPersList_vt = new Vector();
    //
    //조직도에 의한 첫 조회.
    if( !deptId.equals("") && paging.equals("") ) {
        try{
            Vector ret       = ( new OrganPersListRFC() ).getPersonList(deptId,user.empNo, I_IMWON);
            E_RETURN         = WebUtil.nvl((String)ret.get(0));
            E_MESSAGE        = WebUtil.nvl((String)ret.get(1));
            OrganPersList_vt = (Vector)ret.get(2);

            count = OrganPersList_vt.size();
        }catch(Exception ex){
            OrganPersList_vt = null;
        }
    //paging에 의한 조회
    }else if( !deptId.equals("") && !paging.equals("") ) {
        for( int i = 0 ; i < count ; i++ ) {
            OrganPersListData persListData = new OrganPersListData();

            persListData.PERNR = request.getParameter("PERNR"+i);    // 사번
            persListData.ENAME = request.getParameter("ENAME"+i);    // 사원이름
            persListData.ORGTX = request.getParameter("ORGTX"+i);    // 조직명
            persListData.JIKWT = request.getParameter("TITEL"+i);    // 직위
            persListData.JIKKT = request.getParameter("TITL2"+i);    // 직책
            persListData.STLTX = request.getParameter("STLTX"+i);    // 직무
            persListData.BTEXT = request.getParameter("BTEXT"+i);    // 근무지
            persListData.STAT2 = request.getParameter("STAT2"+i);    // 재직자,퇴직자 구분

            OrganPersList_vt.addElement(persListData);
        }
    }

    // PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;

    if( !deptId.equals("") ) {
        try {
            pu = new PageUtil(OrganPersList_vt.size(), paging , 10, 10);
            Logger.debug.println(this, "page : "+paging);
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>

<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">
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

//라디오 선택시 실행.
function changeAppData(PERNR, eName,oRgtx, titel, titl2){
    document.form1.empNo.value = PERNR; //검색할 사번
    <%
    //@웹보안 진단 marco257
    %>
    //document.form1.action = "<%=WebUtil.JspURL%>"+"common/NewSession.jsp";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.common.MSSPersonValCheckSV";

    try {

        top.opener.$("#n_e_orgtx").val(oRgtx); // 부서
        top.opener.$("#n_e_titel").val(titel); // 직위
        top.opener.$("#n_e_titl2").val(titl2); // 직책
        top.opener.$("#view_ename").text(eName+ "("+PERNR+")"); // 사번
        top.opener.$("#n_ename").val(eName); // 이름
        top.opener.$("#n_empNo").val("("+PERNR+")"); // 사번

    } catch(e) {
    }

    document.form1.target="ifHidden";
    document.form1.submit();
}

//paging시 실행.
function PageMove() {
    frm = document.form1;
    frm.action = "<%=WebUtil.JspURL%>"+"common/OrganListRightIF.jsp";
    frm.submit();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.hdn_page.value = page;
    PageMove();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}
//-->
</SCRIPT>
<style>
	a {position:relative; top:-2px; left:5px;}
</style>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_return"  value="<%=E_RETURN%>">
<input type="hidden" name="hdn_message" value="<%=E_MESSAGE%>">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_count"   value="<%=count %>">
<input type="hidden" name="hdn_page"    value="">
<input type="hidden" name="empNo"       value="">




    <!-- 화면에 보여줄 영역 시작-->
    <div class="listArea">
<%
    if ( OrganPersList_vt != null && OrganPersList_vt.size() > 0 ) {
%>
        <div class="listTop" style="padding: 0 5px">
            <div style="float: left; width: 70%">
                <h2 class="subtitle"><spring:message code="LABEL.SEARCH.ORGEH.NAME"/><%--부서명--%> : <%=deptNm%></h2>
            </div>
            <div style="float: left; width: 30%; text-align: right">
                <span ><%= pu == null ? "" : pu.pageInfo() %></span>
            </div>
        </div>
<%
    }
%>
        <div class="wideTable" style="border-top: 2px solid #c8294b; overflow: auto; width: 600px; height:360px;">
          <table class="listTable">
            <tr>
              <th><spring:message code="LABEL.COMMON.0014"/><%--선택--%></th>
              <th><spring:message code="MSG.A.A01.0005"/><%--사번--%></th>
              <th><spring:message code="MSG.A.A01.0002"/><%--성명--%></th>
              <th><%-- //[CSR ID:3456352]<spring:message code="MSG.APPROVAL.0014"/>직위 --%>
              <spring:message code="LABEL.COMMON.0051"/><%--직위/직급호칭--%>
              </th>
              <th><spring:message code="LABEL.COMMON.0009"/><%--직책--%></th>
              <th><spring:message code="MSG.A.A01.0013"/><%--직무--%></th>
              <th class="lastCol"><spring:message code="MSG.A.A01.0018"/><%--근무지--%></th>
            </tr>
<%
    // RFC로부터 검색 성공일 경우.
    if ( E_RETURN != null && !E_RETURN.equals("E") ){
        //조회된 데이터가 존재할 경우.
        if( OrganPersList_vt != null && OrganPersList_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                OrganPersListData persData = (OrganPersListData)OrganPersList_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
            <tr class="<%=tr_class%>">
              <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%=persData.PERNR%>','<%=persData.ENAME%>','<%=persData.ORGTX%>','<%=persData.JIKWT%>','<%=persData.JIKKT%>');"></td>
              <td><%=WebUtil.printString( persData.PERNR )%></td>
              <td><%=WebUtil.printString( persData.ENAME )%></td>
              <td><%=StringUtils.replace(WebUtil.printString(persData.JIKWT ), "/", "/<br/>")%></td>
              <td><%=WebUtil.printString( persData.JIKKT )%></td>
              <td><%=WebUtil.printString( persData.STLTX )%></td>
              <td class="lastCol"><%=WebUtil.printString( persData.BTEXT )%></td>
            </tr>
<%
            } //end for

            //페이징을 위한 데이터.
            for( int i = 0 ; i < OrganPersList_vt.size(); i++ ) {
                OrganPersListData persInfoData = (OrganPersListData)OrganPersList_vt.get(i);
%>
              <input type="hidden" name="PERNR<%= i %>" value="<%= persInfoData.PERNR %>">
              <input type="hidden" name="ENAME<%= i %>" value="<%= persInfoData.ENAME %>">
              <input type="hidden" name="TITEL<%= i %>" value="<%= persInfoData.JIKWT %>">
              <input type="hidden" name="TITL2<%= i %>" value="<%= persInfoData.JIKKT %>">
              <input type="hidden" name="STLTX<%= i %>" value="<%= persInfoData.STLTX %>">
              <input type="hidden" name="BTEXT<%= i %>" value="<%= persInfoData.BTEXT %>">
<%
            }//end for
%>

            </table>
            <div class="align_center">
                <%= pu == null ? "" : pu.pageControl() %>
            </table>
        </div>
    </div>
    <!-- 화면에 보여줄 영역 끝 -->


<%
        //조회된 데이터가 존재하지 않을경우.
        } else {
%>
        <tr class="oddRow">
          <td class="lastCol" colspan="7"><spring:message code="MSG.COMMON.0004"/></td>
        </tr>
<%
        } // end if ~
    // RFC에서 조회된 결과가 실패일 경우.
    }else{
%>
        <tr class="oddRow">
          <td class="lastCol" colspan="7"><%=E_MESSAGE%></td>
        </tr>
<%
    }
%>
            </table>
        </div>
    </div>

</form>
<!--<iframe name='userPv' src="<%=WebUtil.JspURL%>common/onTop.html" width='0' height='0' frameborder='0' marginwidth='0' marginheight='0'><\/iframe>-->
<iframe name="ifHidden" width="0" height="0" />


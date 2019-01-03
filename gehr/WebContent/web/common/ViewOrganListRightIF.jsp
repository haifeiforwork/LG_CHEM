<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 조회                                                   */
/*   Program ID   : ViewOrganListRightIF.jsp                                    */
/*   Description  : 초기화면 조직도 조회 시 나타나는 사원리스트 iFrame          */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-21  유용원                                          */
/*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user     = (WebUserData)session.getAttribute("user");
    String deptId        = WebUtil.nvl(request.getParameter("hdn_deptId"));     //부서ID
    String deptNm        = WebUtil.nvl(request.getParameter("hdn_deptNm"));     //부서명
    String paging        = WebUtil.nvl(request.getParameter("hdn_page"));       //page 처리
    String E_RETURN      = WebUtil.nvl(request.getParameter("hdn_return"));     //E_RETURN 처리
    String E_MESSAGE     = WebUtil.nvl(request.getParameter("hdn_message"));    //E_MESSAGE 처리
    long  count         = Long.parseLong(WebUtil.nvl(request.getParameter("hdn_count"), "0"));

    Vector OrganPersList_vt = new Vector();

    //조직도에 의한 첫 조회.
    if( !deptId.equals("") && paging.equals("") ) {
	    try{
	        Vector ret       = ( new OrganPersListRFC() ).getPersonList(deptId,user.empNo);
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
            pu = new PageUtil(OrganPersList_vt.size(), paging , 5, 10);
            Logger.debug.println(this, "page : "+paging);
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>

<html>
<head>
<title></title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
<%
    //RFC 성공여부.
    if( E_RETURN.equals("E") ){
%>
        alert("RFC에러 : "+"<%=E_MESSAGE%>");
<%
    }
%>

//라디오 선택시 실행.
function changeAppData(PERNR){
    var frm = document.form1;

    //초기화면에서 사원인사정보의 인사정보 조회로 이동을 위한 값.
    frm.hdn_viewFlag.value = "Y";
    frm.empNo.value = PERNR;
    frm.action = "<%=WebUtil.JspURL%>"+"common/NewSession.jsp";
    frm.target="menuContentIframe";
    frm.submit();
}

//paging시 실행.
function PageMove() {
    var frm = document.form1;

    frm.action = "<%=WebUtil.JspURL%>"+"common/ViewOrganListRightIF.jsp";
    frm.submit();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.hdn_page.value = page;
    PageMove();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    var val = obj[obj.selectedIndex].value;
    pageChange(val);
}
//-->
</SCRIPT>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_return"  value="<%=E_RETURN%>">
<input type="hidden" name="hdn_message" value="<%=E_MESSAGE%>">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_count"   value="<%=count %>">
<input type="hidden" name="hdn_page"    value="">
<input type="hidden" name="empNo"       value="">
<input type="hidden" name="hdn_viewFlag" value="">

      <table width="460" border="0" cellspacing="0" cellpadding="0" align="center" >
<%
    if ( OrganPersList_vt != null && OrganPersList_vt.size() > 0 ) {
%>
        <tr>
          <td width="50%" height="28" class="td09" >&nbsp;<spring:message code="LABEL.SEARCH.ORGEH.NAME"/><!-- 부서명 --> : <%=deptNm%></td>
          <td width="50%" height="28" class="td02" ><%= pu == null ? "" : pu.pageInfo() %>&nbsp;</td>
        </tr>
<%
    }
%>
        <tr>
          <td colspan="2">

          <!-- 화면에 보여줄 영역 시작-->
	      <table width="100%" border="0" cellspacing="1" cellpadding="0" align="center" class="table02">
	        <tr>
	          <td class="td03" width="7%" height="24"><spring:message code="LABEL.COMMON.0014"/><!-- 선택 --></td>
	          <td class="td03" width="15%"><spring:message code="MSG.A.A01.0005"/><!-- 사번 --></td>
	          <td class="td03" width="13%"><spring:message code="MSG.A.A01.0002"/><!-- 성명 --></td>
              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              <%--<td class="td03" width="13%"><spring:message code="MSG.APPROVAL.0014"/><!-- 직위 --></td> --%>
              <td class="td03" width="13%"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></td>
              <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
	          <td class="td03" width="13%"><spring:message code="LABEL.COMMON.0009"/><!-- 직책 --></td>
	          <td class="td03" width="19%"><spring:message code="MSG.A.A01.0013"/><!-- 직무 --></td>
	          <td class="td03" width="20%"><spring:message code="MSG.A.A01.0018"/><!-- 근무지 --></td>
	        </tr>
<%
    // RFC로부터 검색 성공일 경우.
	if ( E_RETURN != null && !E_RETURN.equals("E") ){
	    //조회된 데이터가 존재할 경우.
	    if( OrganPersList_vt != null && OrganPersList_vt.size() > 0 ){
	        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
	            OrganPersListData persData = (OrganPersListData)OrganPersList_vt.get(i);
%>
	        <tr align="center">
	          <td class="td04" height="24"><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= persData.PERNR %>');"></td>
	          <td class="td04"><%=WebUtil.printString( persData.PERNR )%></td>
	          <td class="td04"><%=WebUtil.printString( persData.ENAME )%></td>
	          <td class="td04"><%=WebUtil.printString( persData.JIKWT )%></td>
	          <td class="td04"><%=WebUtil.printString( persData.JIKKT )%></td>
	          <td class="td04"><%=WebUtil.printString( persData.STLTX )%></td>
	          <td class="td04"><%=WebUtil.printString( persData.BTEXT )%></td>
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
          <!-- 화면에 보여줄 영역 끝 -->

          </td>
        </tr>

        <!-- PageUtil 관련 - 반드시 써준다. -->
        <tr>
          <td colspan="2" align="center" height="25" valign="bottom" class="td04">
			<%= pu == null ? "" : pu.pageControl() %>
          </td>
        </tr>
        <!-- PageUtil 관련 - 반드시 써준다. -->

<%
        //조회된 데이터가 존재하지 않을경우.
        } else {
%>
        <tr align="center">
          <td class="td04" align="center" height="25" colspan="7"><spring:message code="LABEL.APPROVAL.0008"/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
        </tr>
<%
        } // end if ~
    // RFC에서 조회된 결과가 실패일 경우.
    }else{
%>
        <tr align="center">
          <td class="td04" align="center" height="25" colspan="7"><%=E_MESSAGE%></td>
        </tr>
<%
    }
%>
      </table>
</form>
</table>
</body>
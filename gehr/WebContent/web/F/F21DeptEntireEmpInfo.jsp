<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 연명부
*   Program ID   : F21DeptEntireEmpInfo.jsp
*   Description  : 부서별 연명부 검색을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   update	:  2018-06-07  LGCLC 생명과학 북경법인(G610)  Rollout  프로젝트 적용_ 개발 프로그램 목록에 포함은 안되었지만 G610이 사용하는 메뉴로 테스트시 페이징 오류 발견하여 수정함.
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="self-tag" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>


<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A01SelfDetailData" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);         //세션.
    String paging    = (String)request.getAttribute("page" ) ;
    String deptId    = (String)request.getAttribute("hdn_deptId" ) ;
    String deptNm    = (String)request.getAttribute("hdn_deptNm" ) ;
    String hdn_count = (String)request.getAttribute("hdn_count" ) ;
    long  count      = Long.parseLong(WebUtil.nvl(hdn_count, "0"));
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

    Vector DeptEntireEmpInfo_vt = null;
    DeptEntireEmpInfo_vt = (Vector)request.getAttribute("DeptEntireEmpInfo_vt");

    // PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;

    if ( DeptEntireEmpInfo_vt != null && DeptEntireEmpInfo_vt.size() != 0 ) {
        try {
            pu = new PageUtil( DeptEntireEmpInfo_vt.size(), paging, 3, 10 ) ;
            Logger.debug.println( this, "page : " + paging ) ;
        } catch( Exception ex ) {
            Logger.debug.println( DataUtil.getStackTrace( ex ) ) ;
        }
    }
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form2.page.value = page;
    get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
    document.form2.action = "<%= WebUtil.ServletURL %>hris.F.F21DeptEntireEmpInfoSV";
    document.form2.method = 'get';
    document.form2.submit();
}

//-->
</SCRIPT>


 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_count"   value="<%=count%>">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">
<input type="hidden" name="hdn_page"    value="">



<%
    //부서명, 조회된 건수.
    if ( DeptEntireEmpInfo_vt.size() > 0 ) {
        A01SelfDetailData deptData = (A01SelfDetailData)DeptEntireEmpInfo_vt.get(0);
%>

<h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
<div class="listArea">
	<div class="listTop">
           <span class="listCnt" align="right"><%= pu == null ? "" : pu.pageInfo() %></span>
	</div>
<%
        int k = 0;//내부 카운터용
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            A01SelfDetailData data = (A01SelfDetailData)DeptEntireEmpInfo_vt.get(i);
%>
<c:set var="resultData" value="<%=data%>" />
<self-tag:self-header personData="${resultData}" />

<%
            k++;
        } //end for
%>
</div>
  <!-- 화면에 보여줄 영역 끝 -->

  <!-- PageUtil 관련 - 반드시 써준다. -->
      <%= pu == null ? "" : pu.pageControl() %>
  <!-- PageUtil 관련 - 반드시 써준다. -->
<%}else{ %>
<h2><spring:message code="MSG.F.FCOMMON.0002"/><!-- 해당하는 데이터가 존재하지 않습니다. --></h2>
<%} %>
</form>
<form name="form2">
  <input type="hidden" name="page" value="<%= paging %>">
  <input type="hidden" name="checkYN" value="<%= WebUtil.nvl((String)request.getAttribute("checkYn")) %>">
  <input type="hidden" name="hdn_deptId" value="<%= deptId %>">
  <input type="hidden" name="hdn_deptNm" value="<%= deptNm %>">
  <!--LGCLC 생명과학 북경법인(G610)  Rollout  프로젝트 적용_ 개발 프로그램 목록에 포함은 안되었지만 G610이 사용하는 메뉴로 테스트시 페이징 오류 발견하여 수정함. start  -->
  <input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">
  <!--페이징 오류로 chck_yeno 추가함 end  -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

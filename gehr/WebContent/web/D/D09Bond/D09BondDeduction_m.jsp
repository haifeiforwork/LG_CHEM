<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondDeduction_m.jsp                                      */
/*   Description  : 채권 압류 공제 현황을 조회                                  */
/*   Note         :                                                             */
/*   Creation     : 2002-02-27  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D09Bond.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector D09BondDeductionData_vt = (Vector) request.getAttribute( "D09BondDeductionData_vt" ) ;

    String TOTA1    = (String) request.getAttribute( "TOTA1" );     // 정규급여
    String TOTA2    = (String) request.getAttribute( "TOTA2" );     // 정규상여
    String TOTA4    = (String) request.getAttribute( "TOTA4" );     // 비정규상여
    String TOTA3    = (String) request.getAttribute( "TOTA3" );     // 퇴직금
    String TOTA_SUM = (String) request.getAttribute( "TOTA_SUM" );  // 공제액계
%>
<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function doSearchDetail() {

    document.form1.action = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondListSV_m' ;
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

-->
</script>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D15.0037"/>
    <jsp:param name="click" value="Y"/>
</jsp:include>
<form name="form1" method="post">
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>
           <div class="listArea">
    		<div class="table">
      			<table class="listTable">
      			<colgroup>
                    <col width="10%" />
                    <col width="18%" />
                    <col width="18%" />
                    <col width="18%" />
                    <col width="18%" />
                    <col width="18%" />
                </colgroup>
                <thead>
                      <tr>
                        <th><!--공제월--><%=g.getMessage("LABEL.D.D15.0038")%></td>
                        <th><!--정규급여--><%=g.getMessage("LABEL.D.D15.0039")%></td>
                        <th><!--정규상여--><%=g.getMessage("LABEL.D.D15.0040")%></td>
                        <th><!--비정규상여--><%=g.getMessage("LABEL.D.D15.0041")%></td>
                        <th><!--퇴직금--><%=g.getMessage("LABEL.D.D15.0042")%></td>
                        <th class="lastCol"><!--공제액계--><%=g.getMessage("LABEL.D.D15.0043")%></td>
                      </tr>
                </thead>
<%
    for ( int i = 0 ; i < D09BondDeductionData_vt.size() ; i++ ) {
        D09BondDeductionData data = ( D09BondDeductionData ) D09BondDeductionData_vt.get( i ) ;
%>
                <tr class="<%=WebUtil.printOddRow(i)%>">
                  <td ><%= WebUtil.printDate( data.BEGDA ).substring( 0, 7 ) %></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( data.BETRG01 ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( data.BETRG02 ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( data.BETRG04 ) %><!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( data.BETRG03 ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right lastCol" ><%= WebUtil.printNumFormat( data.G_SUM   ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                </tr>
<%
    }
%>
                 	   </table>
                    </div>
                 </div>
  <div class="listArea">
    <div class="table">
      <table class="listTable">
               <colgroup>
                    <col width="10%" />
                    <col width="18%" />
                    <col width="18%" />
                    <col width="18%" />
                    <col width="18%" />
                    <col width="18%" />
                </colgroup>
              <thead>
              <tr>
                  <td ><!-- 소계 --> <%=g.getMessage("LABEL.D.D15.0170")%></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( TOTA1 ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( TOTA2 ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( TOTA4 ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( TOTA3 ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right lastCol"><%= WebUtil.printNumFormat( TOTA_SUM ) %> <!-- 원 --> <%=g.getMessage("LABEL.D.D15.0010")%></td>
                </tr>
               </thead>
        </table>
     </div>
  </div>
        <!-- 조회 리스트 테이블 끝-->

 			    <div class="buttonArea">
			        <ul class="btn_crud">
			            <li><a href="javascript:history.back();"><span><!-- 목록보기 --><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
			        </ul>
			    </div>
<%
}
%>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

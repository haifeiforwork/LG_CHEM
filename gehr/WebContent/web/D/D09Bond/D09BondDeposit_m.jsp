<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondDeposit_m.jsp                                        */
/*   Description  : 채권 압류 공탁 현황을 조회                                  */
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

    Vector D09BondDepositData_vt = (Vector)request.getAttribute("D09BondDepositData_vt");
           D09BondDepositData_vt = com.sns.jdf.util.SortUtil.sort( D09BondDepositData_vt, "1", "desc" );

    String DPOT_TOTA = (String)request.getAttribute("DPOT_TOTA");  // 공탁총액
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

function goDetail( i ) {
    eval("document.form2.BEGDA.value      = document.form1.BEGDA" + i + ".value");
    document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondDepositSV_1_m' ;
    document.form2.method = 'post' ;
    document.form2.submit() ;
}
-->
</script>

<%-- html body 안 헤더부분 - 타이틀 등 --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D15.0111"/>
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

        <!-- 조회 리스트 테이블 시작-->
  <div class="listArea">
    <div class="table">
      <table class="listTable">
           <thead>
                <tr>
	                        <th ><!--공탁일--><%=g.getMessage("LABEL.D.D15.0113")%></th>
	                        <th><!--실공탁액--><%=g.getMessage("LABEL.D.D15.0114")%></th>
	                        <th ><!--공탁수수료--><%=g.getMessage("LABEL.D.D15.0105")%></th>
	                        <th ><!--배당정리액(수수료포함)--><%=g.getMessage("LABEL.D.D15.0115")%></th>
	                        <th ><!--공탁법원--><%=g.getMessage("LABEL.D.D15.0116")%></th>
                </tr>
             </thead>
<%
    for ( int i = 0 ; i < D09BondDepositData_vt.size() ; i++ ) {
        D09BondDepositData data = ( D09BondDepositData ) D09BondDepositData_vt.get( i ) ;
%>
                <tr class="<%=WebUtil.printOddRow(i)%>">
                  <td ><%= WebUtil.printDate( data.BEGDA ) %></td>
                  <td  class="align_right"><%= WebUtil.printNumFormat( data.DPOT_AMNT ) %> <!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="align_right"><%= WebUtil.printNumFormat( data.DPOT_CHRG ) %> <!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td  class="align_right"><a href="javascript:goDetail(<%= i %>);"><font color="#006699"><%= WebUtil.printNumFormat( data.GIVE_AMNT ) %><!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></font></a></td>
                  <td  align="left">&nbsp;<%= data.CORT_TITL %>
                  <input type="hidden" name="BEGDA<%=i%>"      value="<%= data.BEGDA  %>">
                  </td>
                </tr>

<%
    }
%>
                  </table>
                </div>
             </div>

						<div align="right">
						     <table class="amount">
						     	<colgroup>
						     		<col width="60%" />
						     		<col  />
						     	</colgroup>
			                      <tr>
			                        <th style=""><!--미배당공탁액계--><%=g.getMessage("LABEL.D.D15.0112")%></th>
			                        <td class="align_right"><%= WebUtil.printNumFormat( DPOT_TOTA ) %> <!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
			                      </tr>
		                    </table>
						</div>

        <!-- 조회 리스트 테이블 끝-->
      		    <div class="buttonArea">
				        <ul class="btn_crud">
				            <li><a href="javascript:history.back();""><span><!-- 목록보기 --><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
				        </ul>
				    </div>
</form>
<form name="form2">
<!-----   hidden field ---------->
  <input type="hidden" name="BEGDA" value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%
}
%>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
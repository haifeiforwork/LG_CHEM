<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondDeposit_1_m.jsp                                      */
/*   Description  : 배당정리액 내역현황을 조회                                  */
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

    Vector D09BondDepositDetail_vt = (Vector)request.getAttribute("D09BondDepositDetail_vt");
    String DPOT_TOTA               = (String)request.getAttribute("DPOT_TOTA");  // 공탁액계
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
    <jsp:param name="title" value="LABEL.D.D15.01165"/>
    <jsp:param name="click" value="Y"/>
</jsp:include>
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
	                        <th ><!-- 구분 --><%=g.getMessage("LABEL.D.D15.0076")%></th>
	                        <th><!-- 지급(공탁)일 --><%=g.getMessage("LABEL.D.D15.0109")%></th>
	                        <th><!-- 채권자 --><%=g.getMessage("LABEL.D.D15.0024")%></th>
	                        <th><!-- 번호 --><%=g.getMessage("LABEL.D.D15.0103")%></th>
	                        <th><!-- 지급(배정)액 --><%=g.getMessage("LABEL.D.D15.0104")%></th>
	                        <th><!-- 공탁수수료 --><%=g.getMessage("LABEL.D.D15.0105")%></th>
	                        <th><!-- 수령자 --><%=g.getMessage("LABEL.D.D15.0106")%></th>
                      </tr>
                      </thead>
<%
    for ( int i = 0 ; i < D09BondDepositDetail_vt.size() ; i++ ) {
        D09BondProvisionData data = ( D09BondProvisionData ) D09BondDepositDetail_vt.get( i ) ;
%>
                <tr>
                  <td class="td04"><%= data.BOND_TYPE %></td>
                  <td class="td04" class="align_right"><%= WebUtil.printDate( data.BEGDA ) %></td>
                  <td class="td04" class="align_right"><%= data.CRED_NAME %></td>
                  <td class="td04" class="align_right"><%= data.SEQN_NUMB %></td>
                  <td class="tr01" class="align_right"><%= WebUtil.printNumFormat( data.GIVE_AMNT ) %><!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="tr01" class="align_right"><%= WebUtil.printNumFormat( data.DPOT_CHRG ) %> <!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td class="td04" class="align_right"><%= data.RECV_NAME %></td>
                </tr>
<%
    }
%>
                    	</table>
                    </div>
                   </div>
              <!-- 조회 리스트 테이블 끝-->

				    <div class="buttonArea underList">
				        <ul class="btn_crud">
				            <li><a href="javascript:history.back();""><span><%=g.getMessage("BUTTON.COMMON.BACK.PREVIOUS")%></span></a></li>
				        </ul>
				    </div>
<%
}
%>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />


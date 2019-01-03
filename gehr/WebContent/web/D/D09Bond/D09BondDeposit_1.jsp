<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
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
<%@ page import="hris.D.D09Bond.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector D09BondDepositDetail_vt = ( Vector ) request.getAttribute( "D09BondDepositDetail_vt" ) ;

    String DPOT_TOTA  = ( String ) request.getAttribute( "DPOT_TOTA" ) ;  // 공탁액계
%>

<jsp:include page="/include/header.jsp" />


<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D15.01165"/>
</jsp:include>

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
	                      <tr class="<%=WebUtil.printOddRow(i)%>">
	                        <td><%= data.BOND_TYPE %></td>
	                        <td align="right"><%= WebUtil.printDate( data.BEGDA ) %></td>
	                        <td align="right"><%= data.CRED_NAME %></td>
	                        <td align="right"><%= data.SEQN_NUMB %></td>
	                        <td class="align_right"><%= WebUtil.printNumFormat( data.GIVE_AMNT ) %> <!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
	                        <td class="align_right"><%= WebUtil.printNumFormat( data.DPOT_CHRG ) %> <!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
	                        <td class="lastCol"><%= data.RECV_NAME %></td>
	                      </tr>
<%
    }
%>
                    	</table>
                    </div>
                   </div>
              <!-- 조회 리스트 테이블 끝-->

				    <div class="buttonArea">
				        <ul class="btn_crud">
				            <li><a href="javascript:history.back();""><span><%=g.getMessage("BUTTON.COMMON.BACK.PREVIOUS")%></span></a></li>
				        </ul>
				    </div>

</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

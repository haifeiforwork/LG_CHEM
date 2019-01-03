<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondDetail_m.jsp                                         */
/*   Description  : 채권가압류 내역을 조회                                      */
/*   Note         :                                                             */
/*   Creation     : 2002-02-27  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D09Bond.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    String BEGDA     = ( String ) request.getAttribute( "BEGDA"     );  // 접수일
    String CRED_NAME = ( String ) request.getAttribute( "CRED_NAME" );  // 채권자 성명
    String MGTT_NUMB = ( String ) request.getAttribute( "MGTT_NUMB" );  // 관리번호
    String CRED_ADDR = ( String ) request.getAttribute( "CRED_ADDR" );  // 주소
    String CRED_AMNT = ( String ) request.getAttribute( "CRED_AMNT" );  // 가압류액
    String CRED_TEXT = ( String ) request.getAttribute( "CRED_TEXT" );  // 채권사유
    String CRED_NUMB = ( String ) request.getAttribute( "CRED_NUMB" );  // 채권자 ID
    String SEQN_NUMB = ( String ) request.getAttribute( "SEQN_NUMB" );  // 일련번호

    Vector D09BondCortData_vt = ( Vector ) request.getAttribute( "D09BondCortData_vt" );
    D09BondCortData onedata = ( D09BondCortData ) D09BondCortData_vt.get(0) ;
%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
function  doSearchDetail() {

    document.form1.action = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondListSV_m' ;
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
-->
</script>



<%-- html body 안 헤더부분 - 타이틀 등 --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D15.0086"/>
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
<%
    if ( D09BondCortData_vt != null && D09BondCortData_vt.size() == 1 ) {
%>
          <tr>
            <td>
            <!-- 조회 리스트 테이블 시작-->
  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
		                <tr>
		                  <th ><!-- 접수일 --><%=g.getMessage("LABEL.D.D15.0087")%></th>
		                  <td colspan="3"><%= WebUtil.printDate( BEGDA ) %>
		                   <input type="hidden" name="CRED_NUMB"  value="<%= CRED_NUMB %>">
		                    <input type="hidden" name="SEQN_NUMB"  value="<%= SEQN_NUMB %>">

		                  </td>
		                </tr>
		                <tr>
		                  <th ><!-- 채권자 성명 --><%=g.getMessage("LABEL.D.D15.0088")%></th>
		                  <td ><%= CRED_NAME %></td>
		                  <th  width="100"><!-- 관리번호 --><%=g.getMessage("LABEL.D.D15.0089")%></th>
		                  <td ><%= SEQN_NUMB %></td>
		                </tr>
		                <tr>
		                  <th><!-- 주소 --><%=g.getMessage("LABEL.D.D15.0090")%></th>
		                  <td colspan="3"><%= CRED_ADDR %></td>
		                </tr>
		                <tr>
		                  <th><!-- 송달처 --><%=g.getMessage("LABEL.D.D15.0091")%></th>
		                  <td colspan="3"><%= onedata.DEVY_ADDR %></td>
		                </tr>
		                <tr>
		                  <th><!-- 가압류 금액 --><%=g.getMessage("LABEL.D.D15.0092")%></th>
		                  <td align=right><%= WebUtil.printNumFormat( CRED_AMNT ) %> <!--원  --><%=g.getMessage("LABEL.D.D15.0010")%></td>
		                  <th class="th02"><!-- 채권사유 --><%=g.getMessage("LABEL.D.D15.0093")%></th>
		                  <td><%= CRED_TEXT %></td>
		                </tr>
		                <tr>
		                  <th><!-- 법원/사건번호 --><%=g.getMessage("LABEL.D.D15.0094")%></th>
		                  <td colspan="3"><%= onedata.CORT_IDXX %></td>
		                </tr>
              		</table>
					</div>
			</div>
        <!-- 조회 리스트 테이블 끝-->

<%
    } else if ( D09BondCortData_vt != null && D09BondCortData_vt.size() > 1 ) {
%>

        <!-- 조회 리스트 테이블 시작-->
  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">

		                <tr>
		                  <th ><!-- 접수일 --><%=g.getMessage("LABEL.D.D15.0095")%></th>
		                  <td colspan="3">
      		                <input type="hidden" name="CRED_NUMB"  value="<%= CRED_NUMB %>">
		                    <input type="hidden" name="SEQN_NUMB"  value="<%= SEQN_NUMB %>">
 		                  <%= WebUtil.printDate( BEGDA ) %></td>
		                </tr>
		                <tr>
		                  <th ><!-- 채권자 성명 --><%=g.getMessage("LABEL.D.D15.0096")%></th>
		                  <td ><%= CRED_NAME %></td>
		                  <th ><!-- 관리번호 --><%=g.getMessage("LABEL.D.D15.0097")%></th>
		                  <td><%= SEQN_NUMB %></td>
		                </tr>
		                <tr>
		                  <th><!-- 주소 --><%=g.getMessage("LABEL.D.D15.0098")%></th>
		                  <td ><%= CRED_ADDR %></td>
		                </tr>
		                <tr>
		                  <th><!-- 가압류 금액 --><%=g.getMessage("LABEL.D.D15.0099")%></th>
		                  <td align=right><%= WebUtil.printNumFormat( CRED_AMNT ) %> <!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
		                  <th ><!-- 채권사유--><%=g.getMessage("LABEL.D.D15.0093")%></td>
		                  <td><%= CRED_TEXT %></td>
		                </tr>
	              </table>
			</div>
		</div>
        <!-- 조회 리스트 테이블 끝-->


    <tr>
      <td>
        <!-- 조회 리스트 테이블 시작-->
  <div class="listArea">
    <div class="table">
      <table class="listTable">
      <thead>
	          <tr>
	            <th  ><!-- 접수일 --><%=g.getMessage("LABEL.D.D15.0023")%></th>
	            <th ><!-- 법원/사건번호 --><%=g.getMessage("LABEL.D.D15.0094")%></th>
	            <th ><!-- 송달처 --><%=g.getMessage("LABEL.D.D15.0091")%></th>
	            <th class="lastCol" ><!-- 법원결정 내용 --><%=g.getMessage("LABEL.D.D15.0100")%></th>
	          </tr>
	   </thead>
<%
        for ( int i = 0 ; i < D09BondCortData_vt.size() ; i++ ) {
            D09BondCortData data = ( D09BondCortData ) D09BondCortData_vt.get( i ) ;

%>
	           <tr class="<%=WebUtil.printOddRow(i)%>">
	            <td><%= WebUtil.printDate( data.LRIV_DATE ) %></td>
	            <td><%= data.CORT_IDXX %></td>
	            <td><%= data.DEVY_ADDR %></td>
	            <td class="lastCol"><%= data.ATTA_TEXT %></td>
	          </tr>
<%
        }
%>
     	   </table>
        </div>
      </div>

<%
    }
%>

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

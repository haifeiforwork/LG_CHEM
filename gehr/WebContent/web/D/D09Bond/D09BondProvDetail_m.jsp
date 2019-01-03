<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondProvDetail_m.jsp                                     */
/*   Description  : 채권 압류 지급 현황을 조회                                  */
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

    Vector D09BondProvision_sub = (Vector)request.getAttribute("D09BondProvision_sub");
    String GIVE_SUBA = (String)request.getAttribute("GIVE_SUBA"); // 지급액계
    String MGTT_NUMB = (String)request.getAttribute("MGTT_NUMB");
    String jobid_m   = (String)request.getAttribute("jobid_m");
    String sortField = (String)request.getAttribute("sortField");
    String sortValue = (String)request.getAttribute("sortValue");
%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {

    document.form1.action = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondListSV_m' ;
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function get_Page(){
    document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondProvisionSV_m';
    document.form2.method = "post";
    document.form2.submit();
}

function sortPage( FieldName, FieldValue ){
    if(document.form2.sortField.value==FieldName){
        if( FieldName == 'CRED_NAME,CRED_NUMB,BEGDA' ) {
            if(document.form2.sortValue.value=='asc,asc,desc'){
                document.form2.sortValue.value = 'desc,desc,desc';
            } else {
                document.form2.sortValue.value = 'asc,asc,desc';
            }
        } else if( FieldName == 'BEGDA' ) {
            if(document.form2.sortValue.value=='desc'){
                document.form2.sortValue.value = 'asc';
            } else {
                document.form2.sortValue.value = 'desc';
            }
        }
    } else {
        document.form2.sortField.value = FieldName;
        document.form2.sortValue.value = FieldValue;
    }
    get_Page();
}

function do_Back() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondListSV_m";
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</script>

<%-- html body 안 헤더부분 - 타이틀 등 --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D15.0101"/>
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
            <thead>
                <tr>
                  <th><!--  구분 --><%=g.getMessage("LABEL.D.D15.0076")%></td>
                  <th onClick="javascript:sortPage('CRED_NAME,CRED_NUMB,BEGDA', 'asc,asc,desc')" style="cursor:hand"><!--  채권자 --><%=g.getMessage("LABEL.D.D15.0024")%>       <%= sortField.equals("CRED_NAME,CRED_NUMB,BEGDA") ? ( sortValue.toLowerCase() ).equals("desc,desc,desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></td>
                  <th><!--  번호 --><%=g.getMessage("LABEL.D.D15.0103")%></td>
                  <th onClick="javascript:sortPage('BEGDA', 'desc')"                              style="cursor:hand"><!--  지급(공탁)일 --><%=g.getMessage("LABEL.D.D15.0109")%><%= sortField.equals("BEGDA")                     ? ( sortValue.toLowerCase() ).equals("desc")           ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></td>
                  <th><!--  지급(배정)액< --><%=g.getMessage("LABEL.D.D15.0104")%></td>
                  <th><!--  공탁수수료 --><%=g.getMessage("LABEL.D.D15.0105")%></td>
                  <th><!--  수령자 --><%=g.getMessage("LABEL.D.D15.0106")%></td>
                  <th><!-- 수령은행 --><%=g.getMessage("LABEL.D.D15.0107")%></td>
                  <th class="lastCol"><!--  지급계좌 --><%=g.getMessage("LABEL.D.D15.0108")%></td>
                </tr>
             </thead>
<%
    for( int i = 0 ; i < D09BondProvision_sub.size() ; i++ ) {
        D09BondProvisionData data = ( D09BondProvisionData ) D09BondProvision_sub.get(i);
%>
                <tr class="<%=WebUtil.printOddRow(i)%>">
                  <td ><%= data.BOND_TYPE %></td>
                  <td ><%= data.CRED_NAME %></td>
                  <td ><%= data.SEQN_NUMB %></td>
                  <td><%= WebUtil.printDate( data.BEGDA ) %></td>
                  <td  align="right"><%= WebUtil.printNumFormat( data.GIVE_AMNT ) %><!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td  align="right"><%= WebUtil.printNumFormat( data.DPOT_CHRG ) %><!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
                  <td><%= data.RECV_NAME %></td>
                  <td><%= data.BANK_TEXT %></td>
                  <td><%= data.BANK_NUMB %></td>
                </tr>
<%
    }
%>
            </table>
						<div align="right">
						     <table class="amount">
						     	<colgroup>
						     		<col width="45%" />
						     		<col  />
						     	</colgroup>
			                      <tr>
			                        <th style=""><!-- 지급액계 --><%=g.getMessage("LABEL.D.D15.0102")%></th>
			                        <td class="align_right"><%= WebUtil.printNumFormat( GIVE_SUBA ) %> <!--  원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
			                      </tr>
		                    </table>
						</div>
            </div>
          </div>

        <!-- 조회 리스트 테이블 끝-->
				    <div class="buttonArea">
				        <ul class="btn_crud">
				            <li><a href="javascript:do_Back();""><span><!-- 목록보기 --><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
				        </ul>
				    </div>

</form>
<form name="form2" METHOD=POST ACTION="">
  <input type="hidden" name="jobid_m"     value="<%= jobid_m %>">
  <input type="hidden" name="MGTT_NUMB" value="<%= MGTT_NUMB %>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
<%
}
%>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

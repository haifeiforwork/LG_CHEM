<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 계좌 정보                                                   */
/*   Program Name : 계좌 정보                                                   */
/*   Program ID   : A03AccountDetail.jsp                                        */
/*   Description  : 계좌 정보를 조회하는 화면                                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-07 김도신                                           */
/*   Update       : 2005-03-03 윤정현                                           */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.A.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.E.Global.E24Language.*" %>

<%
    WebUserData user = (WebUserData)session.getAttribute("user");

    Vector e24LanguageData_vt = (Vector)request.getAttribute("e24LanguageData_vt");
    String PERNR = (String)request.getAttribute("PERNR");
%>

<jsp:include page="/include/header.jsp" />

   <jsp:include page="/include/body-header.jsp">
       <jsp:param name="click" value="Y"/>
   </jsp:include>
<form name="form1" method="post">


<%if(e24LanguageData_vt.size() > 0) {%>

    <h2 class="subtitle"><!--Currency--><%=g.getMessage("LABEL.E.COMMON.0001")%>:<%=((E24LanguageData)e24LanguageData_vt.get(0)).REIM_WAR %></h2>

<%}%>

    <!--주소 리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
            	<thead>
                <tr>
                  <th><!--Payment&nbsp;Date--><%=g.getMessage("LABEL.E.E24.0004")%></th>
                  <th><!--Pers.&nbsp;Type--><%=g.getMessage("LABEL.E.E24.0005")%></th>
                  <th><!--Family&nbsp;Type--><%=g.getMessage("LABEL.E.E24.0006")%></th>
                  <th><!--Name--><%=g.getMessage("LABEL.E.E24.0007")%></th>
                  <th><!--Education&nbsp;Institute--><%=g.getMessage("LABEL.E.E24.0008")%></th>
                  <th><!--Payment Period--><%=g.getMessage("LABEL.E.E24.0009")%></th>
                  <th><!--Payment&nbsp;Amount--><%=g.getMessage("LABEL.E.E24.0010")%></th>
                  <th><!--회사 지급--><%=g.getMessage("LABEL.E.E21.0030")%></th>
                  <th class="lastCol"><!--Refund&nbsp;Amt.--><%=g.getMessage("LABEL.E.E24.0011")%></th>
                </tr>
                </thead>
                <%  if( e24LanguageData_vt.size() > 0 ) {
      for(int i=0;i<e24LanguageData_vt.size();i++){
        E24LanguageData data1 = (E24LanguageData)e24LanguageData_vt.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>
                <tr class="<%=tr_class%>">
                  <td><%= data1.PDATE.equals("0000-00-00") ? "" :WebUtil.printDate(data1.PDATE) %></td>
                  <td><%= data1.PERS_TEXT %></td>
                  <td><%= data1.FAMI_TEXT %></td>
                  <td><%= data1.ENAME %></td>
                  <td><%= data1.SCHL_NAME %></td>
                  <td><%= data1.COUR_PRID %>&nbsp;months</td>
                  <td><%= data1.REIM_CAL.equals("0")?"":WebUtil.printNumFormat(data1.REIM_CAL,2)%></td>
                  <td><%= data1.CERT_BETG.equals("0")?"":WebUtil.printNumFormat(data1.CERT_BETG,2)%></td>
                  <td class="lastCol"><%= data1.RFAMT.equals("0")?"":WebUtil.printNumFormat(data1.RFAMT,2) %></td>
                </tr>

                <%
               }
    }else{
%>
                <tr class="oddRow"><td class="lastCol" colspan="9"><!--No data--><%=g.getMessage("MSG.E.ECOMMON.0002")%></td></tr>
<%  } %>
            </table>
        </div>
    </div>
    <!--주소 리스트 테이블 끝-->

<!-- HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="jobid"       value="">

      <input type="hidden" name="ThisJspName" value="E24LanguageList.jsp">
<!-- HIDDEN  처리해야할 부분 끝-->

</div>

</form>

</body>
<jsp:include page="/include/footer.jsp"/>

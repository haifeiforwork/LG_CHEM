<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 동호회가입현황                                              */
/*   Program Name : 동호회가입현황                                              */
/*   Program ID   : E26InfoState_m.jsp                                          */
/*   Description  : 개인이 가입한 동호회에 대한 정보를 조회                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-01-25  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E26InfoState.E26InfoStateData" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector E26InfofirstData_vt = (Vector)request.getAttribute("E26InfofirstData_vt");
%>
<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E26InfoState.E26InfoStateSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
$(function() {
	 if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
});
//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="X03PersonInfo.html'"/>
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">
<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

    <!--동호회 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
             <thead>
              <tr>
                <th><!--가입일--><%=g.getMessage("LABEL.E.E26.0001")%></th>
                <th><!--동호회--><%=g.getMessage("LABEL.E.E26.0002")%></th>
                <th><!--회비(원)--><%=g.getMessage("LABEL.E.E26.0003")%></th>
                <th><!--간사--><%=g.getMessage("LABEL.E.E26.0004")%></th>
                <th class="lastCol"><!--연락처--><%=g.getMessage("LABEL.E.E26.0005")%></th>
              </tr>
              </thead>
<%
    if( E26InfofirstData_vt.size() > 0 ) {
        for ( int i = 0 ; i < E26InfofirstData_vt.size() ; i++ ) {
            E26InfoStateData data = (E26InfoStateData)E26InfofirstData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>


               <tr class="<%=tr_class%>">
                <td><%= WebUtil.printDate(data.BEGDA) %>
          <input type="hidden" name="BEGDA<%= i %>"     value="<%= data.BEGDA %>">
          <input type="hidden" name="STEXT<%= i %>"     value="<%= data.STEXT %>">
          <input type="hidden" name="BETRG<%= i %>"     value="<%= data.BETRG %>">
          <input type="hidden" name="ENAME<%= i %>"     value="<%= data.ENAME %>">
          <input type="hidden" name="APPL_DATE<%= i %>" value="<%= data.APPL_DATE %>">
          <input type="hidden" name="MGART<%= i %>"     value="<%= data.MGART %>">
          <input type="hidden" name="LGART<%= i %>"     value="<%= data.LGART %>">
          <input type="hidden" name="PERN_NUMB<%= i %>" value="<%= data.PERN_NUMB %>">
          <input type="hidden" name="TITEL<%= i %>"     value="<%= data.TITEL %>">
          <input type="hidden" name="USRID<%= i %>"     value="<%= data.USRID %>">

                </td>
                <td><%= data.STEXT %></td>
                <td><%= WebUtil.printNumFormat(data.BETRG) %></td>
                <td><%= data.ENAME %>&nbsp;&nbsp;<%= data.TITEL %></td>
                <td class="lastCol"><%= data.USRID %></td>
              </tr>
<%
        }
%>
            </table>
        </div>
    </div>
<%
    } else {
%>
              <tr class="oddRow">
                <td class="lastCol align_center" colspan="6"><!--해당하는 데이터가 존재하지 않습니다.--><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
              </tr>
            </table>
        </div>
    </div>
<%
    }
%>
        <!--동호회 테이블 끝-->

<input type="hidden" name="jobid_m" value="">
<input type="hidden" name="BEGDA" value="">
<input type="hidden" name="STEXT" value="">
<input type="hidden" name="BETRG" value="">
<input type="hidden" name="ENAME" value="">
<input type="hidden" name="TITEL" value="">
<input type="hidden" name="APPL_DATE" value="">
<input type="hidden" name="MGART" value="">
<input type="hidden" name="LGART" value="">
<input type="hidden" name="PERN_NUMB" value="">
<input type="hidden" name="USRID" value="">
<%
}
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
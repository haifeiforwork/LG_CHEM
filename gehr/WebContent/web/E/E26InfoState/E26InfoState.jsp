<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회가입현황                                              */
/*   Program Name : 동호회 현황조회                                             */
/*   Program ID   : E26InfoState.jsp                                            */
/*   Description  : 동호회 현황조회                                             */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E26InfoState.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    Vector  E26InfofirstData_vt = (Vector)request.getAttribute("E26InfofirstData_vt");
    String PERNR = (String)request.getAttribute("PERNR");
%>
<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
$(function() {
	parent.resizeIframe(document.body.scrollHeight);
});
function doSubmit(i) {
    document.form1.BEGDA.value     = eval("document.form1.BEGDA"+i+".value");
    document.form1.STEXT.value     = eval("document.form1.STEXT"+i+".value");
    document.form1.BETRG.value     = eval("document.form1.BETRG"+i+".value");
    document.form1.ENAME.value     = eval("document.form1.ENAME"+i+".value");
    document.form1.APPL_DATE.value = eval("document.form1.APPL_DATE"+i+".value");
    document.form1.MGART.value     = eval("document.form1.MGART"+i+".value");
    document.form1.LGART.value     = eval("document.form1.LGART"+i+".value");
    document.form1.PERN_NUMB.value = eval("document.form1.PERN_NUMB"+i+".value");
    document.form1.TITEL.value     = eval("document.form1.TITEL"+i+".value");
    document.form1.USRID.value     = eval("document.form1.USRID"+i+".value");

    document.form1.jobid.value  = "first";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E26InfoState.E26InfosecessionBuildSV";
    document.form1.method = "post";
    document.form1.submit();
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.E.E26InfoState.E26InfoStateSV";
    frm.target = "";
    frm.submit();
}
$(function() {
	 if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
});
//-->
</script>
    <jsp:include page="/include/body-header.jsp">
      <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">
<%
    if ("Y".equals(user.e_representative) ) {
%>
  <!--   사원검색 보여주는 부분 시작   -->
  <%@ include file="/web/common/SearchDeptPersons.jsp" %>
  <!--   사원검색 보여주는 부분  끝    -->

<%
    }
%>

<input type="hidden" name = "PERNR" value="<%=PERNR%>">
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
          <th><!--연락처--><%=g.getMessage("LABEL.E.E26.0005")%></th>
          <th class="lastCol"><!--연락처--><%=g.getMessage("LABEL.E.E26.0011")%></th>
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


        <tr class="<%=tr_class %>">
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
          <td><%= data.USRID %></td>
<%
            if( data.ENDDA.equals("9999-12-31") ) {
%>
          <td class="lastCol"><a class="inlineBtn unloading" href="javascript:doSubmit(<%= i %>)"><span><!--탈퇴신청--><%=g.getMessage("BUTTON.COMMON.OUT")%></span></a></td>
<%
            } else {
%>
          <td>&nbsp;</td>
<%
            }
%>
        </tr>
<%
        }
%>
      </table>
    </div>
    <span class="commentOne"><%--탈퇴는 "탈퇴신청" 버튼을 클릭하여 신청합니다. --%><%=g.getMessage("MSG.E.E26.0010")%> </span>
  </div>


<%
    } else {
%>
        <tr align="center">
          <td colspan="6" class="lastCol"><%--해당하는 데이터가 존재하지 않습니다. --%><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
        </tr>
      </table>
    </div>
  </div>

<%
      }
%>
<!--동호회 테이블 끝-->

</div>
<input type="hidden" name="jobid" value="">
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
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 경조금지원내역                                              */
/*   Program Name : 경조금지원내역                                              */
/*   Program ID   : E20ReportDetail_m.jsp                                       */
/*   Description  : 재해내역 상세 조회                                          */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  박영락                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E20Congra.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector E20DisasterData_vt = (Vector)request.getAttribute("E20DisasterData_vt");
%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E20Congra.E20CongraListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function change_Value(index){
    eval("document.form1.CONG_NAME.value = document.form2.CONG_NAME"+index+".value");
    eval("document.form1.RELA_NAME.value = document.form2.RELA_NAME"+index+".value");
    eval("document.form1.EREL_NAME.value = document.form2.EREL_NAME"+index+".value");
    eval("document.form1.REGNO.value     = document.form2.REGNO"+index+".value"    );
    eval("document.form1.STRAS.value     = document.form2.STRAS"+index+".value"    );
    eval("document.form1.DESC.value      = document.form2.DESC"+index+".value"     );
}

//-->
</script>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">
          <%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>


<!-- 첫번째 백터를 디폴트로 표시 -->

            <table >
              <tr>
                <td>
<!--신고서 Tab 시작    여기서 백터수만큼 그림을 표시해주어야 한다.-->
<%
    int size = E20DisasterData_vt.size();
    for( int i = 0; i < size ; i++ ) {
%>
                  <a href="#" onClick="javascript:MM_swapImage(<%for( int j = 0; j < size; j++ ){ out.print("'"+ (j==0 ? "img01" : "Image"+(j+3) ) +"','','" + WebUtil.ImageURL + (j==i ? "btn_report_tap.gif'" : "btn_report_tap_o.gif'")+",");}%>1);change_Value(<%= i %>);">
                  <img name="<%= i==0 ? "img01" : "Image"+(i+3) %>"  border="0" src="<%= WebUtil.ImageURL %><%= i==0 ? "btn_report_tap.gif" : "btn_report_tap_o.gif" %>" align="absmiddle"></a>
<%
    }
%>
<!--신고서 Tab 끝-->
                </td>
              </tr>
            </table>

<%
    E20DisasterData value = (E20DisasterData)E20DisasterData_vt.get(0);
%>

	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
				<tr>
                	<th colspan="2"><!-- 재해구분 --><%=g.getMessage("LABEL.E.E20.0020")%></th>
                	<td><input type="text" name="CONG_NAME" value="<%= value.CONG_NAME %>" size="20" readonly></td>
              	</tr>
              	<tr>
                	<th rowspan="4"><!-- 재해피해자 --><%=g.getMessage("LABEL.E.E20.0021")%></th>
                	<th><!-- 구분 --><%=g.getMessage("LABEL.E.E20.0022")%></th>
                	<td><input type="text" name="RELA_NAME" value="<%= value.RELA_NAME %>" size="20" readonly></td>
              	</tr>
              	<tr>
                	<th><!-- 성명 --><%=g.getMessage("LABEL.E.E20.0023")%></th>
                	<td><input type="text" name="EREL_NAME" value="<%= value.EREL_NAME %>" size="20" readonly></td>
              	</tr>
              	<tr>
                	<th><!-- 주민등록번호 --><%=g.getMessage("LABEL.E.E20.0024")%></th>
                	<td><input type="text" name="REGNO" value="<%= DataUtil.addSeparate(value.REGNO) %>" size="20" readonly></td>
              	</tr>
              	<tr>
                	<th><!-- 주소 --><%=g.getMessage("LABEL.E.E20.0025")%></th>
                	<td><input type="text" name="STRAS" value="<%= value.STRAS %>" size="60" readonly></td>
              	</tr>
              	<tr>
                	<th colspan="2"><!-- 재해내용 --><%=g.getMessage("LABEL.E.E20.0026")%></th>
                	<td><textarea name="DESC" cols="100" wrap="VIRTUAL" rows="5" readonly><%= value.DISA_DESC1+"\n"+value.DISA_DESC2+"\n"+value.DISA_DESC3+"\n"+value.DISA_DESC4+"\n"+value.DISA_DESC5 %></textarea></td>
              	</tr>
            </table>
		</div>
	</div>

	<div class="buttonArea">
		<ul class="btn_crud">
			<li><a href="javascript:history.back()"><span><!-- 목록 --><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
        </ul>
	</div>

</div>
</form>
<form name="form2" method="post" action="">
<%
    for( int i = 0; i < size; i++ ) {
      E20DisasterData data = (E20DisasterData)E20DisasterData_vt.get(i);
%>
  <input type="hidden" name="CONG_NAME<%= i %>"  value="<%= data.CONG_NAME %>">
  <input type="hidden" name="RELA_NAME<%= i %>"  value="<%= data.RELA_NAME %>">
  <input type="hidden" name="EREL_NAME<%= i %>"  value="<%= data.EREL_NAME %>">
  <input type="hidden" name="REGNO<%= i %>"      value="<%= DataUtil.addSeparate(value.REGNO) %>">
  <input type="hidden" name="STRAS<%= i %>"      value="<%= data.STRAS     %>">
  <input type="hidden" name="DISA_DESC1<%= i %>" value="<%= data.DISA_DESC1%>">
  <input type="hidden" name="DISA_DESC2<%= i %>" value="<%= data.DISA_DESC2%>">
  <input type="hidden" name="DISA_DESC3<%= i %>" value="<%= data.DISA_DESC3%>">
  <input type="hidden" name="DISA_DESC4<%= i %>" value="<%= data.DISA_DESC4%>">
  <input type="hidden" name="DISA_DESC5<%= i %>" value="<%= data.DISA_DESC5%>">
  <input type="hidden" name="DESC<%= i %>"       value="<%= data.DISA_DESC1+"\n"+data.DISA_DESC2+"\n"+data.DISA_DESC3+"\n"+data.DISA_DESC4+"\n"+data.DISA_DESC5 %>">
<%
    }
%>
<%
}
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
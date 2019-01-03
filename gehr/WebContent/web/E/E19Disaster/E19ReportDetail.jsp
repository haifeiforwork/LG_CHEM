<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해피해신고서                                              */
/*   Program ID   : E19ReportDetail.jsp                                         */
/*   Description  : 재해피해신고서를 조회할수 있도록 하는 화면                  */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-28  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Disaster.*" %>
<%@ page import="hris.E.E19Disaster.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector E19DisasterData_vt = (Vector)request.getAttribute("E19DisasterData_vt");
    E19CongcondData e19CongcondData = (E19CongcondData)request.getAttribute("e19CongcondData");

    String retPage = (String)request.getAttribute("retPage");
%>

<jsp:include page="/include/header.jsp"/>
<script language="JavaScript">
<!--
function MM_reloadPage(init) {//reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

function MM_preloadImages() {//v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) {//v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() {//v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function change_Value(index){
    eval("document.form1.DISA_NAME.value  = document.form2.DISA_NAME"+index+".value");
    eval("document.form1.DREL_NAME.value  = document.form2.DREL_NAME"+index+".value");
    eval("document.form1.EREL_NAME.value  = document.form2.EREL_NAME"+index+".value");

    eval("document.form1.REGNO.value      = document.form2.REGNO"+index+".value"    );
    eval("document.form1.STRAS.value      = document.form2.STRAS"+index+".value"    );
    eval("document.form1.DESC.value       = document.form2.DESC"+index+".value"     );
}

    function go_back()
    {
     <% if (retPage == null || retPage.equals("")) { %>
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19CongraDetailSV";
    <% } else { %>
        document.form1.action = "<%=retPage%>";
    <% } // end if %>
        document.form1.method = "post";
        document.form1.submit();
    }
//-->
</script>


 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="LABEL.E.E19.0006"/>
 </jsp:include>
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=e19CongcondData.PERNR%>">

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>


                    <table>
                      <tr>
                        <td>
<!--신고서 Tab 시작    여기서 백터수만큼 그림을 표시해주어야 한다.-->
<%
    int size = E19DisasterData_vt.size();
    for( int i = 0; i < size ; i++ ) {
%>
                          <a href="#" onClick="javascript:MM_swapImage(<%for( int j = 0; j < size; j++ ){ out.println("'"+ (j==0 ? "img01" : "Image"+(j+3) ) +"','','" + WebUtil.ImageURL + (j==i ? "btn_report_tap.gif'" : "btn_report_tap_o.gif'")+",");}%>1);change_Value(<%= i %>);">
                          <img name="<%= i==0 ? "img01" : "Image"+(i+3) %>"  border="0" src="<%= WebUtil.ImageURL %><%= i==0 ? "btn_report_tap.gif" : "btn_report_tap_o.gif" %>"  align="absmiddle"></a>
<%
    }
%>
<!--신고서 Tab 시작-->
                        </td>
                      </tr>
                    </table>

<%
    E19DisasterData value = (E19DisasterData)E19DisasterData_vt.get(0);
%>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">

                <tr>
                  <th colspan="2"><!-- 재해내역 --><%=g.getMessage("LABEL.E.E19.0002")%></th>
                  <td>
                    <input type="text" name="RESN_NAME" value="<%= WebUtil.printOptionText((new E19DisaResnRFC()).getDisaResn(user.companyCode), value.DISA_RESN ) %>" size="15" readonly></td>
                </tr>
                <tr>
                  <th colspan="2"><!-- 재해구분 --><%=g.getMessage("LABEL.E.E20.0020")%></th>
                  <td>
                    <input type="text" name="DISA_NAME" value="<%= value.DISA_NAME %>" size="15" readonly></td>
                </tr>
                <tr>
                  <th rowspan="4"><!-- 재해피해자 --><%=g.getMessage("LABEL.E.E20.0021")%></th>
                  <th><!-- 구분 --><%=g.getMessage("LABEL.E.E20.0022")%></th>
                  <td>
                    <input type="text" name="DREL_NAME" value="<%= value.DREL_NAME %>" size="15"  readonly></td>
                </tr>
                <tr>
                  <th><!-- 성명 --><%=g.getMessage("LABEL.E.E20.0023")%></th>
                  <td>
                    <input type="text" name="EREL_NAME" value="<%= value.EREL_NAME %>" size="15" readonly></td>
                </tr>
                <tr>
                  <th><!-- 주민등록번호 --><%=g.getMessage("LABEL.E.E20.0024")%></th>
                  <td>

<%        String REGNO_dis = value.REGNO.substring(0, 6) + "-*******";
%>
                    <input type="text" name="REGNO" value="<%= REGNO_dis %>" size="15" readonly></td>
                </tr>
                <tr>
                  <th><!-- 주소 --><%=g.getMessage("LABEL.E.E20.0025")%></th>
                  <td>
                    <input type="text" name="STRAS" value="<%= value.STRAS %>" size="60" readonly></td>
                </tr>
                <tr>
                  <th colspan="2"><!-- 재해내용 --><%=g.getMessage("LABEL.E.E20.0026")%></th>
                    <td>
                    <textarea name="DESC" cols="60" wrap="VIRTUAL" rows="5" readonly><%= value.DISA_DESC1+"\n"+value.DISA_DESC2+"\n"+value.DISA_DESC3+"\n"+value.DISA_DESC4+"\n"+value.DISA_DESC5 %></textarea>
                  </td>
                </tr>
            </table>
        </div>
    </div>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:go_back()"><span><!-- 목록보기 --><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
        </ul>
    </div>

  </div>
<%
    E19DisasterData data_back = (E19DisasterData)E19DisasterData_vt.get(0);
%>
  <input type="hidden" name="AINF_SEQN"          value="<%= data_back.AINF_SEQN %>">
  <input type="hidden" name="jobid"              value="">
  <input type="hidden" name="UPMU_TYPE"          value="09">
</form>
<form name="form2" method="post" action="">
<%
    for( int i = 0; i < size; i++ ) {
        E19DisasterData data = (E19DisasterData)E19DisasterData_vt.get(i);
        REGNO_dis = data.REGNO.substring(0, 6) + "-*******";

%>
  <input type="hidden" name="DISA_NAME<%= i %>"  value="<%= data.DISA_NAME %>">
  <input type="hidden" name="DREL_NAME<%= i %>"  value="<%= data.DREL_NAME %>">
  <input type="hidden" name="EREL_NAME<%= i %>"  value="<%= data.EREL_NAME %>">
  <input type="hidden" name="REGNO<%= i %>"      value="<%= REGNO_dis   %>">
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
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

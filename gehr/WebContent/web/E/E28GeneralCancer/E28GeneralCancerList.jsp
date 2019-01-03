<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 7종암검진                                                    */
/*   Program Name : 7종암검진실시내역                                            */
/*   Program ID   : E28GeneralCancerList.jsp                                      */
/*   Description  : 7종암검진실시내역                                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2013-08-05  lsa           C20130805_81825                   */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E28General.*" %>

<%
  Vector E28GeneralCancerData_vt = (Vector)request.getAttribute("E28GeneralCancerData_vt");
  String paging           = (String)request.getAttribute("page");
    PageUtil pu = null;
  try {
    if( E28GeneralCancerData_vt.size() != 0 ){
      pu = new PageUtil(E28GeneralCancerData_vt.size(), paging , 10, 10);
      Logger.debug.println(this, "page : "+paging);
    }
  } catch (Exception ex) {
    Logger.debug.println(DataUtil.getStackTrace(ex));
  }
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value = page;
  doSubmit();
}

function doSubmit() {//연봉계약서 page로 이동한다.
    document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E28General.E28GeneralCancerListSV';
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">
        <div class="listTop">
            <span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
        </div>

  <!-- 조회 리스트 테이블 시작-->
  <div class="listArea">
    <div class="table">
      <table class="listTable">
       <thead>
        <tr>
                <th><!-- 검진년도 --><%=g.getMessage("LABEL.E.E28.0001")%></th>
                <th><!-- 구분 --><%=g.getMessage("LABEL.E.E28.0002")%></th>
                <th><!-- 검진희망일 --><%=g.getMessage("LABEL.E.E28.0003")%></th>
                <th><!-- 검진확정일 --><%=g.getMessage("LABEL.E.E28.0004")%></th>
                <th><!-- 검진완료일 --><%=g.getMessage("LABEL.E.E28.0005")%></th>
                <th><!-- 검진지역 --><%=g.getMessage("LABEL.E.E28.0006")%></th>
                <th class="lastCol"><!-- 검진병원 --><%=g.getMessage("LABEL.E.E28.0007")%></td>
        </tr>
        </thead>

<%
    E28GeneralCancerData_vt = SortUtil.sort_num(E28GeneralCancerData_vt ,"EXAM_YEAR,GUEN_CODE", "desc,asc");

    if( E28GeneralCancerData_vt.size() > 0 ) {
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            E28GeneralCancerData data = (E28GeneralCancerData)E28GeneralCancerData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

%>
        <tr class="<%=tr_class%>">
          <td><%= data.EXAM_YEAR %></td>
          <td><%= data.GUEN_NAME %></td>
          <td><%= (data.EZAM_DATE).equals("0000-00-00") ? "" : WebUtil.printDate( data.EZAM_DATE ) %></td>
          <td><%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate( data.BEGDA ) %></td>
          <td><%= (data.REAL_DATE).equals("0000-00-00") ? "" : WebUtil.printDate( data.REAL_DATE ) %></td>
          <td><%= data.AREA_NAME %></td>
          <td class="lastCol"><%= data.HOSP_NAME %></td>
         <!--   <td class="td04"><%= (data.ZCONFIRM).equals("X") ? "V" : "" %></td>-->
        </tr>
<%
        }
    } else {
%>
        <tr class="oddRow">
          <td class="lastCol" colspan="8"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
        </tr>
<%
    }
%>
      </table>
    </div>
  </div>
  <!-- 조회 리스트 테이블 끝-->

  <div class="align_center">
    <%= pu == null ? "" : pu.pageControl() %>
  </div>
<%
    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
    if (isCanGoList) {  %>

  <div class="buttonArea">
    <ul class="btn_crud">
      <li><a class="unloading" href="javascript:history.back()"><span><!-- 목록 --><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
    </ul>
  </div>

<%  }  %>
    <input type="hidden" name="page" value="<%= paging %>">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
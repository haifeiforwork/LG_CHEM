<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진실시내역                                            */
/*   Program ID   : E28GeneralList.jsp                                          */
/*   Description  : 종합검진실시내역                                            */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*   Update       : 2012-10-31  보상명세서 이전가기추가                         */
/*   Update       : 2013-04-18  이선아 동의서여부삭제 C20130410_09624           */
/*                  2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)     */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E28General.*" %>

<%
  Vector E28GeneralData_vt = (Vector)request.getAttribute("E28GeneralData_vt");
  String paging           = (String)request.getAttribute("page");
    PageUtil pu = null;
  try {
    if( E28GeneralData_vt.size() != 0 ){
      pu = new PageUtil(E28GeneralData_vt.size(), paging , 10, 10);
      Logger.debug.println(this, "page : "+paging);
    }
  } catch (Exception ex) {
    Logger.debug.println(DataUtil.getStackTrace(ex));
  }

  //[CSR ID:2995203]
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
    document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E28General.E28GeneralListSV';
    document.form1.method = "post";
    document.form1.submit();
}
$(function() {
	 if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
});
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
          <th><!-- 검진병원 --><%=g.getMessage("LABEL.E.E28.0007")%></th>
          <th class="lastCol"><!-- 동의서 --><%=g.getMessage("LABEL.E.E28.0008")%></th>
        </tr>
       </thead>

<%
    E28GeneralData_vt = SortUtil.sort_num(E28GeneralData_vt ,"EXAM_YEAR,GUEN_CODE", "desc,asc");

    if( E28GeneralData_vt.size() > 0 ) {
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            E28GeneralData data = (E28GeneralData)E28GeneralData_vt.get(i);
            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

%>
        <tr class="<%=tr_class %>">
          <td><%= data.EXAM_YEAR %></td>
          <td><%= data.GUEN_NAME %></td>
          <td><%= (data.EZAM_DATE).equals("0000-00-00") ? "" : WebUtil.printDate( data.EZAM_DATE ) %></td>
          <td><%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate( data.BEGDA ) %></td>
          <td><%= (data.REAL_DATE).equals("0000-00-00") ? "" : WebUtil.printDate( data.REAL_DATE ) %></td>
          <td><%= data.AREA_NAME %></td>
          <td><%= data.HOSP_NAME %></td>
          <td class="lastCol"><%= (data.ZCONFIRM).equals("X") ? "V" : "" %></td>
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

  <div class="align_center"><%= pu == null ? "" : pu.pageControl() %></div>

<% //[CSR ID:2995203] 보상명세서 용 뒤로가기.
    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
    if (isCanGoList) {  %>

  <div class="buttonArea">
    <ul class="btn_crud">
      <li><a class="unloading" href="javascript:history.back()"><span><!-- 목록 --><%=g.getMessage("BUTTON.COMMON.BACK")%></span></a></li>
    </ul>
  </div>

<%  }  %>
    <input type="hidden" name="page" value="<%= paging %>">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
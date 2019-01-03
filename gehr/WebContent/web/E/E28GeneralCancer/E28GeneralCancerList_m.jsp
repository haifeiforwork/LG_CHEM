<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 7종암검진실시내역                                            */
/*   Program Name : 7종암검진실시내역                                            */
/*   Program ID   : E28GeneralCancerList_m.jsp                                   */
/*   Description  : 7종암검진 실시 내역 조회                                     */
/*   Note         :                                                             */
/*   Creation     : 2013-08-05  lsa           C20130805_81825                   */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E28General.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector E28GeneralCancerData_vt = (Vector)request.getAttribute("E28GeneralCancerData_vt");
    String paging_m          = (String)request.getAttribute("page_m");

    PageUtil pu_m = null;
    try {
        if( E28GeneralCancerData_vt.size() != 0 ){
            pu_m = new PageUtil(E28GeneralCancerData_vt.size(), paging_m , 10, 10);
            Logger.debug.println(this, "page_m : "+paging_m);
        }
    } catch (Exception ex) {
          Logger.debug.println(DataUtil.getStackTrace(ex));
    }
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E28General.E28GeneralCancerListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}


//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page_m){
    document.form1.page_m.value = page_m;
    doSubmit();
}

function doSubmit() {//연봉계약서 page로 이동한다.
    document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E28General.E28GeneralCancerListSV_m';
    document.form1.method = "post";
    document.form1.submit();
}
//-->
</SCRIPT>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="help" value="X03PersonInfo.html'"/>
    </jsp:include>
<form name="form1" method="post">
<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>


    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu_m == null ?  "" : pu_m.pageInfo() %></span>
        </div>
        <div class="table">
            <table class="listTable">
              <tr>
                <th><!-- 검진년도 --><%=g.getMessage("LABEL.E.E28.0001")%></th>
                <th><!-- 구분 --><%=g.getMessage("LABEL.E.E28.0002")%></th>
                <th><!-- 검진희망일 --><%=g.getMessage("LABEL.E.E28.0003")%></th>
                <th><!-- 검진확정일 --><%=g.getMessage("LABEL.E.E28.0004")%></th>
                <th><!-- 검진완료일 --><%=g.getMessage("LABEL.E.E28.0005")%></th>
                <th><!-- 검진지역 --><%=g.getMessage("LABEL.E.E28.0006")%></th>
                <th class="lastCol"><!-- 검진병원 --><%=g.getMessage("LABEL.E.E28.0007")%></td>
              </tr>

<%
    E28GeneralCancerData_vt = SortUtil.sort_num(E28GeneralCancerData_vt ,"EXAM_YEAR,GUEN_CODE", "desc,asc");

    if( E28GeneralCancerData_vt.size() > 0 ) {
        for( int i = pu_m.formRow() ; i < pu_m.toRow(); i++ ) {
            E28GeneralCancerData data = (E28GeneralCancerData)E28GeneralCancerData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

%>
             <tr class="<%=tr_class%>">
                <td><%= data.EXAM_YEAR %>&nbsp;</td>
                <td><%= data.GUEN_NAME %>&nbsp;</td>
                <td><%= (data.EZAM_DATE).equals("0000-00-00") ? "" : WebUtil.printDate( data.EZAM_DATE ) %></td>
                <td><%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate( data.BEGDA ) %></td>
                <td><%= (data.REAL_DATE).equals("0000-00-00") ? "" : WebUtil.printDate( data.REAL_DATE ) %></td>
                <td><%= data.AREA_NAME %>&nbsp;</td>
                <td class="lastCol"><%= data.HOSP_NAME %>&nbsp;</td>
               <!-- <td><%= (data.ZCONFIRM).equals("X") ? "V" : "" %>&nbsp;</td>-->
             </tr>
<%
        }
    } else {
%>
              <tr class="oddRow">
                <td class="lastCol align_center" colspan="8"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
              </tr>
<%
    }
%>
            </table>
        </div>

        <div class="align_center">
            <%= pu_m == null ? "" : pu_m.pageControl() %>
        </div>

    </div>
    <!-- 조회 리스트 테이블 끝-->

</div>

    <input type="hidden" name="page_m" value="<%= paging_m %>">
<%
}
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
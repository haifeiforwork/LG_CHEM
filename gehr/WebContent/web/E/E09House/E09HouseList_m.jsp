<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 주택지원                                                    */
/*   Program Name : 주택지원                                                    */
/*   Program ID   : E09HouseList_m.jsp                                          */
/*   Description  : 개인의 주택자금 융자정보를 조회                             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-29  이형석                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                  2005-12-05  lsa @v1.1                                       */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                  2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)     */
/*                  2016-05-27 김불휘S [CSR ID:C20160526_74869] 주택자금 융자 조회 화면 문구 추가      */
/*                  2017-07-12  eunha  [CSR ID:3430087] 담당자 변경 수정 건      */
/********************************************************************************/%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E09House.E09HouseData" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector E09House_vt = (Vector)request.getAttribute("E09House_vt");
    String radio_check = "F";

    //[CSR ID:2995203]
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");
%>
<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E09House.E09HouseListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function doSubmit() {
    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
       size = 1;

    } else {
      size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = document.form1.radiobutton[i].value;
        }
    }

//  리스트의 size가 1보다 크고 모두가 완료일 경우..
    if( command == "" || command == null ) {
        command = 0;
    }
    var flag = eval("document.form1.FLAG"+command+".value");

    if( flag == "Y" ) {
        alert("<%=g.getMessage("MSG.E.E09.0001")%>"); //대출 진행중인 건 중 주택자금(기타)가 아닌 융자형태에 대해서만 상세조회가 가능합니다.
        return;
    }
    eval("document.form2.DATBW.value      = document.form1.DATBW"+command+".value");
    eval("document.form2.STEXT.value      = document.form1.STEXT"+command+".value");
    eval("document.form2.DARBT.value      = document.form1.DARBT"+command+".value");
    eval("document.form2.BETRG.value      = document.form1.BETRG"+command+".value");
    eval("document.form2.REDEMPTION.value = document.form1.REDEMPTION"+command+".value");
    eval("document.form2.SUBTY.value      = document.form1.SUBTY"+command+".value");
    eval("document.form2.ENDDA.value      = document.form1.ENDDA"+command+".value");
    eval("document.form2.BEGDA.value      = document.form1.BEGDA"+command+".value");

    document.form2.jobid_m.value = "detail";
    document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E09House.E09HouseListSV_m';
    document.form2.method = "post";
    document.form2.submit();

}

<!-- [CSR ID:C20160526_74869] 주택자금 융자 조회 화면 문구 및 담당자 버튼 추가 -->
function contact_to() {
    var frm = document.form1;
    //2017-07-12  eunha  [CSR ID:3430087] 담당자 변경 수정 건 start
    //small_window=window.open("","Contact","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=450,left=100,top=100");
    small_window=window.open("","Contact","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=570,left=100,top=100");
    //2017-07-12  eunha  [CSR ID:3430087] 담당자 변경 수정 건 end
    small_window.focus();
    frm.target = "Contact";
    frm.action = "<%=WebUtil.JspURL%>"+"common/ContactListPop.jsp";
    frm.submit();

}
//-->
</script>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="X03PersonInfo.html'"/>
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">

<%
// 우선 조회를 막음.
if ( true ) {

%>

<%
// 사원 검색한 사람이 있을때
if ( user_m != null ) {
%>


    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
<%
    if( E09House_vt.size() > 0 ) {
%>
        <div class="listTop">
            <div class="buttonArea clearfix">
                <ul class="btn_mdl">
                    <li><a href="javascript:doSubmit();"><span><!--조회--><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a></li>
                </ul>
            </div>
        </div>
<%
    }
%>

        <div class="table">
            <table class="listTable">
            <thead>
                <tr>
                  <th><!--선택--><%=g.getMessage("LABEL.E.E09.0004")%></th>
                  <th><!--융자일자--><%=g.getMessage("LABEL.E.E09.0005")%></th>
                  <th><!--융자형태--><%=g.getMessage("LABEL.E.E09.0006")%></th>
                  <th><!--융자원금--><%=g.getMessage("LABEL.E.E09.0007")%></th>
                  <th><!--상환원금--><%=g.getMessage("LABEL.E.E09.0008")%></th>
                  <th><!--잔여원금--><%=g.getMessage("LABEL.E.E09.0009")%></th>
                  <th><!--상환완료일자--><%=g.getMessage("LABEL.E.E09.0010")%></th>
                  <th><!--일시상환금액--><%=g.getMessage("LABEL.E.E09.0011")%></th>
                  <th><!--이자지원액--><%=g.getMessage("LABEL.E.E09.0012")%></th><!-- [CSR ID:2995203] -->
                  <th class="lastCol"><!--이자지원액--><%=g.getMessage("LABEL.E.E09.0012")%><br/>(<!--당해--><%=g.getMessage("LABEL.E.E09.0013")%>)</th><!-- [CSR ID:2995203] -->
                </tr>
                </thead>
<%
    if( E09House_vt.size() > 0 ) {
        int j = 0;
        for( int i = 0 ; i < E09House_vt.size(); i++ ) {
            E09HouseData housedata = (E09HouseData)E09House_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
            // @v1.1 start
            if (housedata.SUBTY.equals("0010") || housedata.SUBTY.equals("0020")||housedata.SUBTY.equals("0080") || housedata.SUBTY.equals("0090")) {
%>
                 <input type="hidden" name="DATBW<%= j %>"      value="<%= DataUtil.removeStructur( housedata.DATBW, "-" ) %>">
                 <input type="hidden" name="STEXT<%= j %>"      value="<%= housedata.STEXT %>">
                 <input type="hidden" name="DARBT<%= j %>"      value="<%= WebUtil.printNum( housedata.DARBT ) %>">
                 <input type="hidden" name="BETRG<%= j %>"      value="<%= WebUtil.printNum( housedata.BETRG ) %>">
                 <input type="hidden" name="REDEMPTION<%= j %>" value="<%= housedata.REDEMPTION %>">
                 <input type="hidden" name="SUBTY<%= j %>"      value="<%= housedata.SUBTY %>">
                 <input type="hidden" name="ENDDA<%= j %>"      value="<%= DataUtil.removeStructur( housedata.ENDDA , "-" ) %>">
                 <input type="hidden" name="BEGDA<%= j %>"      value="<%= DataUtil.removeStructur( housedata.BEGDA , "-" ) %>">
                 <input type="hidden" name="FLAG<%= j %>"       value="<%= housedata.FLAG %>">
                 <input type="hidden" name="INTSP<%= i %>"      value="<%= WebUtil.printNum( housedata.INTSP ) %>">
                 <input type="hidden" name="INTSP_YR<%= i %>"      value="<%= WebUtil.printNum( housedata.INTSP_YR ) %>">
                <tr class="<%=tr_class%>">
                  <td>
<%
            if( housedata.FLAG.equals("Y") ) {
%>
                    <input type="radio" name="radiobutton" value="<%= j %>" disabled>
<%
            } else {
                if( radio_check.equals("F") ) {
                    radio_check = "T";
%>
                    <input type="radio" name="radiobutton" value="<%= j %>" checked>
<%
                } else if( radio_check.equals("T") ) {
%>
                    <input type="radio" name="radiobutton" value="<%= j %>">
<%
                }
            }
%>
                  </td>
                  <td><%= WebUtil.printDate(housedata.DATBW) %></td>
                  <td><%= housedata.STEXT %></td>
                  <td><%= WebUtil.printNumFormat(housedata.DARBT) %></td>
                  <td><%= WebUtil.printNumFormat(housedata.REDEMPTION) %></td>
                  <td><%= WebUtil.printNumFormat(housedata.BETRG) %></td>
                  <td><%= housedata.FLAG.equals("Y") ? (housedata.ZAHLD.equals("0000-00-00") ? "" : WebUtil.printDate(housedata.ZAHLD)) : "" %></td>
                  <td><%= housedata.FLAG.equals("Y") ? WebUtil.printNumFormat(housedata.REDARBT) : "" %></td>
                  <td><%= WebUtil.printNumFormat(housedata.INTSP) %></td>
                  <td class="lastCol"><%= WebUtil.printNumFormat(housedata.INTSP_YR) %></td>
                </tr>
<%
               j++;
            } //@v1.1 end

        }
    } else {
%>
                <tr class="oddRow">
                  <td class="lastCol align_center" colspan="10"><!--해당하는 데이터가 존재하지 않습니다.--><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
                </tr>
<%
      }
%>

<%
}
%>

<%
} else {
%>
          <tr class="oddRow">
            <td class="lastCol align_center" colspan="8">
                <p><!--주택지원현황 조회 화면의 변경 작업 실시로 인해 메뉴의 사용을 일시 중지합니다.--><%=g.getMessage("MSG.E.E09.0002")%> <br><br>
                    <!--주택 지원 현황 관련하여 문의 사항은 노경관리팀 임규용 과장(3-3197), 박난이사원(3-7814)에게 해주시기 바랍니다.--><%=g.getMessage("MSG.E.E09.0003")%><br><br>
                </p>
            </td>
          </tr>
<%
}
// 우선 조회를 막음.
%>
            </table>
        </div>
    </div>
    <!-- 조회 리스트 테이블 끝-->

    <!-- [CSR ID:C20160526_74869] 주택자금 융자 조회 화면 문구 및 담당자 버튼 추가 -->

    <div class="commentsMoreThan2">
        <div><!--매월 21일부터 말일까지는 주택자금을 상환할 수 없습니다.--><%=g.getMessage("MSG.E.E09.0004")%></div>
        <div><!--융자잔액을 임의로 상환할 경우 급여공제와 중복 상환처리될 수 있사오니 반드시 일시상환 예정일을 각 사업장 담당자에게 확인하여 진행하시기 바랍니다.--><%=g.getMessage("MSG.E.E09.0005")%></div>
        <br><br></font></td>
    </div>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:contact_to();"><span><!--담당자 안내--><%=g.getMessage("BUTTON.COMMON.PERSONINFO")%></span></a></li>

<% //[CSR ID:2995203] 보상명세서 용 뒤로가기.
    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
    if (isCanGoList) {  %>
            <li><a href="javascript:history.back()"><span><!-- 뒤로가기 --><%=g.getMessage("BUTTON.COMMON.BACK")%></span></a></li>
<%  }  %>
        </ul>
    </div>
</div>


</form>
<form name="form2">
<input type="hidden" name="jobid_m" value="">
<input type="hidden" name="DATBW" value="">
<input type="hidden" name="STEXT" value="">
<input type="hidden" name="DARBT" value="">
<input type="hidden" name="BETRG" value="">
<input type="hidden" name="REDEMPTION" value="">
<input type="hidden" name="SUBTY" value="">
<input type="hidden" name="ENDDA" value="">
<input type="hidden" name="BEGDA" value="">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
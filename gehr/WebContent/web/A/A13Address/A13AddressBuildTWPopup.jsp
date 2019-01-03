<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색창                                                  */
/*   Program ID   : SearchDeptPersonsPop.jsp                                    */
/*   Description  : 사원검색창(대리신청)                                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.*" %>

<%
    request.setCharacterEncoding("utf-8");
    String queryflag = request.getParameter("queryflag")==null?"0":request.getParameter("queryflag");
    String  paging              = queryflag.equals("1")?null:request.getParameter("page");
    WebUserData user                   = (WebUserData)session.getAttribute("user");
    String BEZEI3 = request.getParameter("BEZEI3")==null ? "" : request.getParameter("BEZEI3");

    boolean isFirst             = true;
    Vector  ZipCodeData_vt = new Vector();

    String  count               = request.getParameter("count");
    long    l_count             = 0;
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }
//  page 처리

    if(paging == null ) {

        try{
            ZipCodeData_vt = ( new SearchAddrRFCTw() ).getAddrDetail(BEZEI3);
            l_count = ZipCodeData_vt.size();
        }catch(Exception ex){
            ZipCodeData_vt = null;
        }

        isFirst = false;

    } else if(paging != null ) {

        isFirst = false;

        for( int i = 0 ; i < l_count ; i++ ) {
            SearchAddrDataTW searchDataTW = new SearchAddrDataTW();

            searchDataTW.ZIP03 = request.getParameter("ZIP03"+i) ;    // 사번
            searchDataTW.STATE = request.getParameter("STATE"+i);    // 사원이름
            searchDataTW.COUNC = request.getParameter("COUNC"+i) ;    // 조직명
            searchDataTW.BEZEI2 = request.getParameter("BEZEI2"+i) ;    // 직위
            searchDataTW.BEZEI1 = request.getParameter("BEZEI1"+i) ;    // 직책

            ZipCodeData_vt.addElement(searchDataTW);
        }
    }
//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;

        try {
            pu = new PageUtil(ZipCodeData_vt.size(), paging , 10, 10);
          Logger.debug.println(this, "page : "+paging);
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }

%>
<html>
<head>
<title>Zip Code Search</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
<%
    if( ZipCodeData_vt != null ) {
        if( ZipCodeData_vt.size() == 1 ) {
            SearchAddrDataTW data = (SearchAddrDataTW)ZipCodeData_vt.get(0);
%>

    changeAppData("<%= data.ZIP03 %>", "<%= data.STATE%>", "<%= data.COUNC%>", "<%= data.BEZEI1%>", "<%= data.BEZEI2%>");

<%
        }
    }
%>
}

function PageMove() {
    document.form1.action = "/web/A/A13Address/A13AddressBuildTWPopup.jsp";
    document.form1.submit();
}

function changeAppData(ZIP03,STATE,COUNC,BEZEI1,BEZEI2){

    opener.document.form1.PSTLZ.value   = ZIP03;
    opener.document.form1.STATE.value   = STATE;
    opener.document.form1.COUNC.value   = COUNC;
    opener.document.form1.BEZEI1.value   = BEZEI2;
    opener.document.form1.BEZEI2.value   = BEZEI1;
    opener.display();
    window.close();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    PageMove();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}
function f_zipcode(){
    form1.queryflag.value="1";
    form1.submit();
}
//-->
</SCRIPT>
<script>
//    window.resizeTo(690,490);
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init();">
<div class="winPop">
<form name="form1" method="post" onsubmit="return false">

    <div class="header">
        <span><spring:message code="LABEL.A.A13.0002" /><!-- Zip Code Search --></span>
        <a href=""><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" ></a>
    </div>

    <div class="body">

<!--
    <table>
        <tr>
            <td>County:
                <input type="text" name="BEZEI3" size="8"   class="input03"   value="<%=BEZEI3 %>"  >
                <input type="hidden" name="queryflag" value="0">
            </td>
            <td><img src="/web/images/btn_serch.gif" onclick="f_zipcode()" style="cursor:hand;"/></td>
        </tr>
    </table>
-->
        <div class="listArea">
            <div class="listTop">
<%
    if ( ZipCodeData_vt != null && ZipCodeData_vt.size() > 0 ) {
%>

                <span class="listCnt"><%= pu == null ? "" : pu.pageInfo() %></span>

<%
    } else {
%>

<%
    }
%>
                <div class="buttonArea">
                    <span><spring:message code="LABEL.A.A13.0003" /><!-- County -->:</span>
                    <input type="text" name="BEZEI3" size="10" value="<%=BEZEI3 %>"  >
                    <input type="hidden" name="queryflag" value="0">
                    <ul class="btn_mdl displayInline"style="padding-left:3px;">
                        <li><a onclick="f_zipcode()" style="cursor:hand;"><span><spring:message code="BUTTON.COMMON.SEARCH" /><%-- 조회 --%></span></a></li>
                    </ul>
                </div>
                <div class="clear"></div>
            </div>
            <div class="table">
                <table class="listTable">
                    <tr>
                        <th><spring:message code="LABEL.A.A12.0034" /><!-- Selection --></th>
                        <th><spring:message code="LABEL.A.A13.0007" /><!-- Zip --></th>
                        <th><spring:message code="LABEL.A.A13.0008" /><!-- State --></th>
                        <th><spring:message code="LABEL.A.A13.0008" /><!-- State --></th>
                        <th><spring:message code="LABEL.A.A13.0003" /><!-- County --></th>
                        <th class="lastCol"><spring:message code="LABEL.A.A13.0003" /><!-- County --></th>
                    </tr>
<%
   if( !isFirst ){
        if( ZipCodeData_vt != null && ZipCodeData_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                SearchAddrDataTW searchAddrDataTW = (SearchAddrDataTW)ZipCodeData_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
                    <tr class="<%=tr_class%>">
                        <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= searchAddrDataTW.ZIP03 %>', '<%= searchAddrDataTW.STATE%>', '<%= searchAddrDataTW.COUNC%>', '<%= searchAddrDataTW.BEZEI2%>','<%= searchAddrDataTW.BEZEI1%>');"></td>
                        <td><%=WebUtil.printString( searchAddrDataTW.ZIP03 )%></td>
                        <td><%=WebUtil.printString( searchAddrDataTW.STATE )%></td>
                        <td><%=WebUtil.printString( searchAddrDataTW.BEZEI1 )%></td>
                        <td><%=WebUtil.printString( searchAddrDataTW.COUNC )%></td>
                        <td class="lastCol"><%=WebUtil.printString( searchAddrDataTW.BEZEI2 )%></td>
                    </tr>
<%
            }
            for( int i = 0 ; i < ZipCodeData_vt.size(); i++ ) {
                SearchAddrDataTW searchAddrDataTW = (SearchAddrDataTW)ZipCodeData_vt.get(i);
%>
              <input type="hidden" name="ZIP03<%= i %>" value="<%= searchAddrDataTW.ZIP03 %>">
              <input type="hidden" name="STATE<%= i %>" value="<%= searchAddrDataTW.STATE %>">
              <input type="hidden" name="BEZEI1<%= i %>" value="<%= searchAddrDataTW.BEZEI1 %>">
              <input type="hidden" name="COUNC<%= i %>" value="<%= searchAddrDataTW.COUNC %>">
              <input type="hidden" name="BEZEI2<%= i %>" value="<%= searchAddrDataTW.BEZEI2 %>">
 <%
            }
%>
                </table>
<!-- PageUtil 관련 - 반드시 써준다. -->
                <div class="align_center">
                    <%= pu == null ? "" : pu.pageControl() %>
                </div>
<!-- PageUtil 관련 - 반드시 써준다. -->
            </div>
        </div>

<%
        } else {

%>
                    <tr class="oddRow">
                        <td class="lastCol" colspan="8"><spring:message code="MSG.A.A20.0011" /><!-- no data -->.</td>
                    </tr>
                </table>
            </div>
        </div>
<%
        }
%>

<%
    }
%>

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><span><spring:message code="BUTTON.COMMON.CLOSE" /><%-- 닫기 --%></span></a></li>
            </ul>
        </div>

    </div>
</div>

   <input type="hidden" name="page"     value="">
  <input type="hidden" name="count"    value="<%= l_count %>">


</body>
</html>

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
<%@ page import="hris.A.A13Address.rfc.*" %>
<%
    request.setCharacterEncoding("utf-8");
    String  paging = request.getParameter("page");
    String  BEZEI4 = request.getParameter("BEZEI4");
    WebUserData user                   = (WebUserData)session.getAttribute("user");
    boolean isFirst             = true;
    Vector   CodeDataHk_vt = new Vector();

    String  count               = request.getParameter("count");
    long    l_count             = 0;
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }
//  page 처리

    if(paging == null ) {

        try{
            if(BEZEI4.equals("")){
             CodeDataHk_vt = ( new A13AddressAreaTypeRFC1()).getAddressType();
            }else{
                CodeDataHk_vt = ( new A13AddressAreaTypeRFC1()).getAddressType(request.getParameter("BEZEI4"));
            }

            l_count = CodeDataHk_vt.size();
        }catch(Exception ex){
            CodeDataHk_vt = null;
        }

        isFirst = false;

    } else if(paging != null ) {

        isFirst = false;

        for( int i = 0 ; i < l_count ; i++ ) {
            SearchAddrDataHk searchDataHk = new SearchAddrDataHk();

            searchDataHk.COUNC = request.getParameter("COUNC"+i) ;    // 사번
            searchDataHk.BEZEI = request.getParameter("BEZEI"+i) ;    // 사원이름


            CodeDataHk_vt.addElement(searchDataHk);
        }
    }
//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;

        try {
            pu = new PageUtil(CodeDataHk_vt.size(), paging , 10, 10);
          Logger.debug.println(this, "page : "+paging);
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }

%>
<html>
<head>
<title>District Search</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
<%
    if( CodeDataHk_vt != null ) {
        if( CodeDataHk_vt.size() == 1 ) {
            SearchAddrDataHk data = (SearchAddrDataHk)CodeDataHk_vt.get(0);
%>

    changeAppData("<%= data.COUNC %>", "<%= data.BEZEI%>");

<%
        }
    }
%>
}

function PageMove() {
    document.form1.action = "/web/A/A13Address/A13AddressBuildHkPopup.jsp";
    document.form1.submit();
}

function changeAppData(COUNC,BEZEI){

    opener.document.form1.COUNC.value   = COUNC;
    opener.document.form1.BEZEI.value   = BEZEI;

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
        <span><spring:message code="LABEL.A.A13.0005" /><!-- District Search --></span>
        <a href=""><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" ></a>
    </div>

    <div class="body">

        <div class="listArea">
<%
    if ( CodeDataHk_vt != null && CodeDataHk_vt.size() > 0 ) {
%>
            <div class="listTop">
                <span class="listCnt"><%= pu == null ? "" : pu.pageInfo() %></span>
            </div>
<%
    } else {
%>

<%
    }
%>

            <div class="table">
                <table class="listTable">
                    <tr>
                        <th><spring:message code="LABEL.A.A12.0034" /><!-- Selection --></th>
                        <th><spring:message code="MSG.A.A13.018" /><!-- County code --></th>
                        <th class="lastCol"><spring:message code="LABEL.A.A13.0006" /><!-- Discription --></th>
                    </tr>
<%
   if( !isFirst ){
        if( CodeDataHk_vt != null && CodeDataHk_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                SearchAddrDataHk searchAddrDataHk = (SearchAddrDataHk)CodeDataHk_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
                    <tr class="<%=tr_class%>">
                        <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= searchAddrDataHk.COUNC %>', '<%= searchAddrDataHk.BEZEI%>');"></td>
                        <td><%=WebUtil.printString( searchAddrDataHk.COUNC )%></td>
                        <td class="lastCol"><%=WebUtil.printString( searchAddrDataHk.BEZEI )%></td>
                    </tr>
<%
            }
            for( int i = 0 ; i < CodeDataHk_vt.size(); i++ ) {
                SearchAddrDataHk searchAddrDataHk = (SearchAddrDataHk)CodeDataHk_vt.get(i);
%>

                <input type="hidden" name="COUNC<%= i %>" value="<%= searchAddrDataHk.COUNC %>">
                <input type="hidden" name="BEZEI<%= i %>" value="<%= searchAddrDataHk.BEZEI %>">
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
                        <td class="lastCol" colspan="3"><spring:message code="MSG.A.A20.0011" /><!-- No Data -->.</td>
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
                <li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%--닫기--%></span></a></li>
            </ul>
        </div>

    </div>
</div>


   <input type="hidden" name="page"     value="">
  <input type="hidden" name="count"    value="<%= l_count %>">

</body>
</html>

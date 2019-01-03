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
<%@ page import="com.common.Utils" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
    request.setCharacterEncoding("utf-8");
    String queryflag = request.getParameter("queryflag")==null?"0":request.getParameter("queryflag");
    String name = request.getParameter("name")==null?"0":request.getParameter("name");
    String  paging              = queryflag.equals("1")?null:request.getParameter("page");
    String gubun = request.getParameter("gubun")==null ? "1" : request.getParameter("gubun");
    String cname = request.getParameter("cname")==null ? "" : request.getParameter("cname");

    boolean isFirst             = true;
    Vector  ZipCodeData_vt = new Vector();

    long    l_count             = 0;
//  page 처리
    String PRVNCD1="";
    String CITYCD1="";
    String CNTYCD1="";
    String code  = name.equals("search") ? null:"";

    if(code == null){
        PRVNCD1 = request.getParameter("PRVNCD1");
        CITYCD1 = request.getParameter("CITYCD1");
        CNTYCD1 = request.getParameter("CNTYCD1");
        ZipCodeData_vt = ( new SearchAddrRFCCn() ).getAddrDetail("4",cname,PRVNCD1,CITYCD1,CNTYCD1);
    }else{
        //ZipCodeData_vt = ( new SearchAddrRFCCn() ).getAddrDetail(gubun,"","","","");
    }

    l_count = ZipCodeData_vt.size();
    isFirst = false;
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


function PageMove() {
    document.form1.action = "/web/A/A13Address/A13Address.jsp";
    document.form1.submit();
}

function changeAppData(ZIPCODE,ADDRESS,PRVNCX,CITYTX,CNTYTX,PRVNCD){

    parent.opener.document.form1.PSTLZ.value   = ZIPCODE;
    parent.opener.document.form1.ADDRESS.value   = ADDRESS;
    parent.opener.document.form1.PRVNCX.value   = PRVNCX;
    parent.opener.document.form1.CITYTX.value   = CITYTX;
    parent.opener.document.form1.CNTYTX.value   = CNTYTX;
    parent.opener.document.form1.STATE.value   = PRVNCD;
    if((PRVNCD=="011")||(PRVNCD=="031")||(PRVNCD=="012")||(PRVNCD=="050")){

        parent.opener.display1();
    }else{

        parent.opener.display();
    }
    parent.opener.document.form1.LOCAT.focus();
    parent.window.close();
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

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<iframe name="hidden" id="hidden" src="" width="0" height="0"></iframe>

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="jobid" value="">
<input type="hidden" name="PRVNCD1" value="<%=PRVNCD1 %>">
<input type="hidden" name="CITYCD1" value="<%=CITYCD1 %>">
<input type="hidden" name="CNTYCD1" value="<%=CNTYCD1 %>">
<input type="hidden" name="name" value="<%=name %>">


   <input type="hidden" name="queryflag"     value="">
   <input type="hidden" name="gubun"     value="<%=gubun %>">
   <input type="hidden" name="cname"     value="<%=cname %>">
   <input type="hidden" name="page"     value="">
  <input type="hidden" name="count"    value="<%= l_count %>">


    <div class="listArea">
<%
    if (Utils.getSize(ZipCodeData_vt) > 0 ) {
%>
        <div class="listTop">
            <span class="listCnt"><%= pu == null ? "" : pu.pageInfo() %></span>
        </div>
<%
    }
%>
        <div class="table">
            <table class="listTable">
                <tr>
                    <th><spring:message code="LABEL.COMMON.0003"/><!-- Selection --></th>
                    <th><spring:message code="MSG.A.A13.007"/><!-- Zip Code --></th>
                    <th><spring:message code="MSG.A.A13.011"/><!-- County --></th>
                    <th class="lastCol"><spring:message code="MSG.A.A13.013"/><!-- Address --></th>
                </tr>
<%
   if(!isFirst ){
        if(ZipCodeData_vt != null && ZipCodeData_vt.size() > 0 ){

                for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                    SearchAddrDataCn searchAddrDataCN = (SearchAddrDataCn)ZipCodeData_vt.get(i);
    %>
                <tr class="<%=WebUtil.printOddRow(i)%>">
                    <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= searchAddrDataCN.ZIPCODE %>', '<%= searchAddrDataCN.ADDRESS%>', '<%= searchAddrDataCN.PRVNCX%>', '<%= searchAddrDataCN.CITYTX%>', '<%= searchAddrDataCN.CNTYTX%>', '<%= searchAddrDataCN.PRVNCD%>');"></td>
                    <td><%=WebUtil.printString( searchAddrDataCN.ZIPCODE)%></td>
                    <td><%=WebUtil.printString( searchAddrDataCN.CNTYTX)%></td>
                    <td class="lastCol align_left"><%=WebUtil.printString( searchAddrDataCN.ADDRESS)%></td>

                </tr>
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
                    <td class="lastCol" colspan="4"><spring:message code="MSG.A.A20.0011"/><!-- No data --></td>
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
</form>

</body>
</html>

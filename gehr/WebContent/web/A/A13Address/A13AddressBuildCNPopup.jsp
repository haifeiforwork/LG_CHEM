<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    /******************************************************************************/
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
/********************************************************************************/
%>
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
    String queryflag = request.getParameter("queryflag") == null ? "0" : request.getParameter("queryflag");
    String name = request.getParameter("name") == null ? "0" : request.getParameter("name");
    String paging = queryflag.equals("1") ? null : request.getParameter("page");
    WebUserData user = (WebUserData) session.getAttribute("user");
    String gubun = request.getParameter("gubun") == null ? "1" : request.getParameter("gubun");
    String cname = request.getParameter("cname") == null ? "" : request.getParameter("cname");

    boolean isFirst = true;
    String isdata = "true";
    Vector ZipCodeData_vt = new Vector();

    String count = request.getParameter("count");
    long l_count = 0;
    if (count != null) {
        l_count = Long.parseLong(count);
    }
//  page 처리
    Vector prvncd = new Vector();
    Vector citycd = new Vector();
    Vector cntycd = new Vector();
    Vector zipcode = new Vector();

    if (paging == null) {

        try {
            String code = name.equals("search") ? null : "";
            if (code == null) {
                String PRVNCD1 = request.getParameter("PRVNCD1");
                String CITYCD1 = request.getParameter("CITYCD1");
                String CNTYCD1 = request.getParameter("CNTYCD1");
                ZipCodeData_vt = (new SearchAddrRFCCn()).getAddrDetail("4", cname, PRVNCD1, CITYCD1, CNTYCD1);
            } else {
                ZipCodeData_vt = (new SearchAddrRFCCn()).getAddrDetail(gubun, "", "", "", "");
            }

            if("1".equals(gubun))  prvncd = ZipCodeData_vt;
            else if("2".equals(gubun))  citycd = ZipCodeData_vt;
            else if("3".equals(gubun))  cntycd = ZipCodeData_vt;
            else if("4".equals(gubun))  zipcode = ZipCodeData_vt;

            l_count = zipcode.size();
        } catch (Exception ex) {
            zipcode = null;
        }
        isFirst = false;

    } else if (paging != null) {

        isFirst = false;

        for (int i = 0; i < l_count; i++) {
            SearchAddrDataCn searchDataCN = new SearchAddrDataCn();

            searchDataCN.ZIPCODE = request.getParameter("ZIPCODE" + i);
            searchDataCN.ADDRESS = request.getParameter("ADDRESS" + i);


            zipcode.addElement(searchDataCN);
        }
    }
//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;

    try {
        pu = new PageUtil(zipcode.size(), paging, 10, 10);
        Logger.debug.println(this, "page : " + paging);
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
            document.form1.action = "/web/A/A13Address/A13AddressBuildCNPopup.jsp";
            document.form1.submit();
        }

        /*function changeAppData(ZIP03,STATE,COUNC,BEZEI1,BEZEI2){

         opener.document.form1.PSTLZ.value   = ZIP03;
         opener.document.form1.STATE.value   = STATE;
         opener.document.form1.COUNC.value   = COUNC;
         opener.document.form1.BEZEI1.value   = BEZEI2;
         opener.document.form1.BEZEI2.value   = BEZEI1;
         opener.display();
         window.close();
         }*/

        //PageUtil 관련 script - page처리시 반드시 써준다...
        function pageChange(page) {
            document.form1.page.value = page;
            PageMove();
        }

        //PageUtil 관련 script - selectBox 사용시 - Option
        function selectPage(obj) {
            val = obj[obj.selectedIndex].value;
            pageChange(val);
        }
        function f_zipcode() {
            if (document.form1.PRVNCD.value == "") {
                alert('<spring:message code="MSG.A.A13.041" />'); //Please select Province.
                document.form1.PRVNCD.focus();
                return;
            }
            if (document.form1.CITYCD.value == "") {
                alert('<spring:message code="MSG.A.A13.042" />'); //Please select City.
                document.form1.CITYCD.focus();
                return;
            }

            form1.queryflag.value = "1";
            form1.name.value = "search";
            document.form1.PRVNCD1.value = document.form1.PRVNCD.value;
            document.form1.CITYCD1.value = document.form1.CITYCD.value;
            document.form1.CNTYCD1.value = document.form1.CNTYCD.value;
            document.form1.action = "<%=WebUtil.JspURL%>A/A13Address/A13Address.jsp";
            document.form1.target = "list";
            document.form1.method = "post";
            form1.submit();
        }

        function get1() {
            document.form1.jobid.value = "getcode1";
            document.form1.PRVNCD1.value = document.form1.PRVNCD.value;
            document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A13Address.A13AddressCnSV";
            document.form1.target = "hidden";
            document.form1.method = "post";
            document.form1.submit();
        }
        function get2() {

            document.form1.jobid.value = "getcode2";
            document.form1.PRVNCD1.value = document.form1.PRVNCD.value;
            document.form1.CITYCD1.value = document.form1.CITYCD.value;
            document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A13Address.A13AddressCnSV";
            document.form1.target = "hidden";
            document.form1.method = "post";
            document.form1.submit();
        }
        function EnterCheck() {
            if (event.keyCode == 13) {
                f_zipcode();
            }
        }
        //-->
    </SCRIPT>
    <script>
        //    window.resizeTo(690,490);
    </script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="winPop">
<iframe name="hidden" id="hidden" src="" width="0" height="0"></iframe>

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="jobid" value="">
<input type="hidden" name="PRVNCD1" value="">
<input type="hidden" name="CITYCD1" value="">
<input type="hidden" name="CNTYCD1" value="">
<input type="hidden" name="name" value="">

    <div class="header">
        <span><spring:message code="LABEL.A.A13.0002" /><!-- Zip Code Search --></span>
        <a href=""><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" ></a>
    </div>

    <div class="body">
        <span class="commentOne"><spring:message code="MSG.A.A13.043" /><!-- Please input an Area name or District. --></span>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                    <tr>
                        <th><span class="textPink">*</span><spring:message code="MSG.A.A14.0012" /><!-- Province --></th>
                        <td>
                            <select name="PRVNCD" onChange="javascript:get1();">
                                <option value="">Select</option>
                                <%
                                    for (int i = 0; i < prvncd.size(); i++) {
                                        SearchAddrDataCn data1 = (SearchAddrDataCn) prvncd.get(i);
                                %>
                                <option value="<%= data1.PRVNCD%>"><%= data1.PRVNCX%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                        <th class="th02"><span class="textPink">*</span><spring:message code="MSG.A.A01.050" /><!-- City --></th>
                        <td>
                            <select name="CITYCD" onChange="javascript:get2();">
                                <option value=""><spring:message code="MSG.A.A03.0020" /><!-- Select --></option>
                            </select>
                        </td>
                        <th class="th02"><spring:message code="LABEL.A.A13.0003" /><!-- County --></th>
                        <td>
                            <select name="CNTYCD">
                                <option value=""><spring:message code="MSG.A.A03.0020" /><!-- Select --></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="LABEL.A.A13.0004" /><!-- Search --></th>
                        <td colspan="5">
                            <input type="text" name="cname" size="30" value="<%=cname %>" onKeyPress="javascript:EnterCheck();">
                            <input type="hidden" name="queryflag" value="0">
                            <a class="inlineBtn" href="javascript:;" onclick="f_zipcode();"><span><spring:message code="BUTTON.COMMON.SEARCH" /><%-- 조회 --%></span></a><!--<img src="/web/images/btn_serch.gif" onclick="f_zipcode()" style="cursor:hand;"/>-->
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <iframe name="list" id="list" src="<%=WebUtil.JspURL%>A/A13Address/A13Address.jsp" width="100%" frameborder="0" height="330" style="overflow: hidden"></iframe>

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%--닫기--%></span></a></li>
            </ul>
        </div>

    </div>
    </form>
</div>

</body>
</html>

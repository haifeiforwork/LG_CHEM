<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인재개발 협의결과 조회                                      */
/*   Program Name : 인재개발 협의결과 조회                                      */
/*   Program ID   : B03DevelopList_m.jsp                                        */
/*   Description  : 사원의 인재개발 협의결과 조회List                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2002-01-29  이형석                                          */
/*   Update       : 2003-06-23  최영호                                          */
/*                  2005-01-11  윤정현                                          */
/*                  013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector B03Develop_vt = (Vector)request.getAttribute("B03Develop_vt") ;
    String paging2       = (String)request.getAttribute("page2");

    PageUtil pu2 = null;
    try {
        if( B03Develop_vt.size() != 0 ){
            pu2 = new PageUtil(B03Develop_vt.size(), paging2 , 10, 10);
            Logger.debug.println(this, "page2 : "+paging2);
        }
    } catch (Exception ex) {
        Logger.debug.println(this, DataUtil.getStackTrace(ex));
    }
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--

function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.B.B03DevelopListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function goDetail(){
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
    document.form2.jobid2.value = "detail";
    eval("document.form2.begDa.value = document.form1.BEGDA"+command+".value;");
    document.form2.command.value = command;
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopListSV_m' ;
    document.form2.method = 'get' ;
    document.form2.submit() ;
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page2){
    document.form3.page2.value = page2;
    //doSubmit();
    get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
    document.form3.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopListSV_m';
    document.form3.method = 'get';
    document.form3.submit();
}

function sortPage( FieldName ){
    if(document.form3.sortField.value==FieldName){
        if(document.form3.sortValue.value=='desc'){
            document.form3.sortValue.value = 'asc';
        } else {
            document.form3.sortValue.value = 'desc';
        }
    } else {
        document.form3.sortField.value = FieldName;
        document.form3.sortValue.value = 'desc';
    }
    get_Page();
}

function print(){
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
    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,width=900,height=700,left=50,top=20");
    document.form2.jobid.value = "print";
    document.form2.target = "essPrintWindow";
    eval("document.form2.begDa.value = document.form1.BEGDA"+command+".value;");
    document.form2.command.value = command;
    document.form2.empNo.value = "<%= user_m != null ? user_m.empNo : "" %>";
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV_m' ;
    document.form2.method = 'post' ;
    document.form2.submit() ;
}

//-->
</SCRIPT>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<!-- 2013-08-21 [CSR ID:2389767] [정보보안] 화면캡쳐방지  -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과</h1></div>

    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
          <%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

    <!--리스트 테이블 시작-->
    <div class="listArea">

<% if( B03Develop_vt.size() > 0 ) { %>

        <div class="listTop">
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:goDetail();"><span>조회</span></a></li>
                </ul>
            </div>
        </div>

<% } %>

        <div class="table">
            <table class="listTable">
                <tr>
                    <th>선택</th>
                    <th name="BEGDA">협의일</th>
                    <th>위원장</th>
                    <th class="lastCol">인재개발위원회</th>
                </tr>
                <%
    if( B03Develop_vt.size() > 0 ) {
        int k = 0;//내부 카운터용
        for ( int i = pu2.formRow() ; i < pu2.toRow() ; i++ ) {
            B03DevelopData developData = (B03DevelopData)B03Develop_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td>
                        <input type="radio" name="radiobutton" value="<%= k %>" <%=(k==0) ? "checked" : ""%>>
                        <input type="hidden" name="BEGDA<%= k %>"  value="<%= DataUtil.removeStructur(developData.BEGDA,"-","") %>">
                    </td>
                    <td><%= DataUtil.removeStructur( developData.BEGDA , "-", "." ) %></td>
                    <td><%= developData.COMM_NAME %></td>
                    <td class="lastCol"><%= developData.SECT_TEXT %></td>
                </tr>
<%
        k++;
        }
%>
            </table>
            <div class="align_center">
                <input type="hidden" name="page2" value="<%= paging2 %>">
                <%= pu2 == null ?  "" : pu2.pageControl() %>
            </div>
          <!-- PageUtil 관련 - 반드시 써준다. -->
        </div>
    </div>
    <!--리스트 테이블 끝-->


<%
    } else {
%>

                <tr class="oddRow">
                    <td colspan="5" class="lastCol">해당하는 데이터가 존재하지 않습니다.</td>
                </td>

<%
    }
%>
            </table>
        </div>
    </div>

  </div>
<%
}
%>
  <input type="hidden" name="jobid2" value="">
</form>
<form name="form2">
  <input type="hidden" name="jobid2" value="">
  <input type="hidden" name="begDa" value="">
  <input type="hidden" name="command" value="">
  <input type="hidden" name="empNo" value="">
  <input type="hidden" name="seqnr" value="">
</form>

<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page2" value="<%= paging2 %>">
</form>
</body>
</html>

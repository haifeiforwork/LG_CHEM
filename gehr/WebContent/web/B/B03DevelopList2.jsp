<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인재개발협의결과 입력                                       */
/*   Program Name : 인재개발협의결과 입력                                       */
/*   Program ID   : B03DevelopList2.jsp                                         */
/*   Description  : 인재개발 협의결과 조회                                      */
/*   Note         :                                                             */
/*   Creation     : 최영호                                                      */
/*   Update       : 2005-01-26  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector B03Develop_vt = (Vector)request.getAttribute("B03Develop_vt") ;

    String paging = (String)request.getAttribute("page");
    String empNo  = (String)request.getAttribute("empNo");
    String ORGTX  = (String)request.getAttribute("ORGTX");
    String TITEL  = (String)request.getAttribute("TITEL");
    String TITL2  = (String)request.getAttribute("TITL2");
    String ENAME  = (String)request.getAttribute("ENAME");

    PageUtil pu = null;
    try {
        if( B03Develop_vt.size() != 0 ){
            pu = new PageUtil(B03Develop_vt.size(), paging , 10, 10);
            Logger.debug.println(this, "page : "+paging);
        }
    } catch (Exception ex) {
        Logger.debug.println(this, DataUtil.getStackTrace(ex));
    }

    WebUserData user = WebUtil.getSessionUser(request);
    int m = 0;
    for(int j = 0; j < B03Develop_vt.size(); j++) {
        B03DevelopData developData = (B03DevelopData)B03Develop_vt.get(j);
         if(developData.BEGDA.equals(WebUtil.printDate(DataUtil.getCurrentDate(),"-"))){
            m++;
        }
    }
   String m2 = Integer.toString(m);
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--

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

    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.jobid.value = "detail";
    eval("document.form2.begDa.value = document.form1.BEGDA"+command+".value;");
    document.form2.command.value = command;
    document.form2.empNo.value = '<%= empNo %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'get' ;
    document.form2.target = "menuContentIframe";
    document.form2.submit() ;
}

function print(){
    var command = "";
    var size = "";

<%
    if( B03Develop_vt.size() == 0 ) {
%>
    alert("프린트할 내용이 없습니다.");
    return;
<%
    }
%>

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
    document.form2.empNo.value = '<%= empNo %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'post' ;
    document.form2.submit() ;
}
function goChange(){
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

    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.jobid.value = "change";
    eval("document.form2.begDa.value = document.form1.BEGDA"+command+".value;");
    document.form2.command.value = command;
    document.form2.empNo.value = '<%= empNo %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'get' ;
    document.form2.target = "menuContentIframe";
    document.form2.submit() ;
}

function doSubmit(){
    var command = "";
        command = '<%= m2 %>';

    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    buttonDisabled();
    document.form2.jobid.value = "build";
    document.form2.command.value = command;
    document.form2.empNo.value = '<%= empNo %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'get' ;
    document.form2.target = "menuContentIframe";
    document.form2.submit();
}

function goDelete(){
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

    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.jobid.value = "delete";
    eval("document.form2.begDa.value = document.form1.BEGDA"+command+".value;");
    eval("document.form2.seqnr.value = document.form1.SEQNR"+command+".value;");
    document.form2.command.value = command;
    document.form2.empNo.value = '<%= empNo %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'get' ;
    document.form2.target = "menuContentIframe";
    document.form2.submit();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form3.page.value = page;
//doSubmit();
    get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
    document.form3.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV';
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

function opensawon() {
    i_gubun = document.form1.I_GUBUN[document.form1.I_GUBUN.selectedIndex].value;

    if( i_gubun == "1" ) {                   //사번검색
        val = document.form1.I_VALUE1.value;
        val = rtrim(ltrim(val));

        if ( val == "" ) {
            alert("검색할 부서원 사번을 입력하세요!")
            document.form1.I_VALUE1.focus();
            return;
        } else {
            document.form1.jobid.value = "pernr";
        }
    } else if( i_gubun == "2" ) {            //성명검색
        val1 = document.form1.I_VALUE1.value;
        val1 = rtrim(ltrim(val1));

        if ( val1 == "" ) {
            alert("검색할 부서원 성명을 입력하세요!")
            document.form1.I_VALUE1.focus();
            return;
        } else {
            if( val1.length < 2 ) {
                alert("검색할 성명을 한 글자 이상 입력하세요!")
                document.form1.I_VALUE1.focus();
                return;
            } else {
                document.form1.jobid.value = "ename";
            }
        }
    }

    small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=<%= user.e_retir.equals("Y") ? "740" : "680" %>,height=500,left=100,top=100");
    small_window.focus();

    document.form1.target = "DeptPers";
    document.form1.action = "/web/common/DeptPersonsPopWait2.jsp";
    document.form1.submit();
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        opensawon();
    }
}

function gubun_change() {
    document.form1.I_VALUE1.value    = "";
    document.form1.I_VALUE1.focus();
}

//-->
</SCRIPT></head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과 조회</h1></div>

    <div class="buttonArea">
        <ul class="btn_mdl">
            <li><a href="javascript:print();"><span>인쇄하기</span></a></li>
        </ul>
    </div>

    <div class="tableInquiry">
        <table>
            <tr>
                <th>선택구분</th>
                <td>
                    <select name="I_GUBUN" onChange="javascript:gubun_change()">
                        <option value="2" >성명별</option>
                        <option value="1" >사번별</option>
                    </select>
                    <input type="text"   name="I_VALUE1" size="10"  maxlength="10" value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                    <input type="hidden" name="jobid" value="">
                    <input type="hidden" name="empNo" value="">
                    <input type="hidden" name="I_DEPT"    value="">
                    <input type="hidden" name="E_RETIR"   value="">
                    <input type="hidden" name="retir_chk" value="">
                    <input type="hidden" name="page"      value="">
                    <input type="hidden" name="count"     value="">
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:opensawon();"><span>사원찾기</span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>부서</th>
                    <td><input size="30" style="border-width:0;text-align:left" type="text" name="ORGTX" value="<%= ORGTX %>" readonly></td>
                    <th class="th02">직위</th>
                    <td><input size="20" style="border-width:0;text-align:left" type="text" name="TITEL" value="<%= TITEL %>" readonly></td>
                    <th class="th02">직책</th>
                    <td><input size="20" style="border-width:0;text-align:left" type="text" name="TITL2" value="<%= TITL2 %>" readonly></td>
                    <th class="th02">성명</th>
                    <td>
                        <input size="8" style="border-width:0;text-align:left" type="text" name="ENAME" value="<%= ENAME %>" readonly>
                        <input size="9" style="border-width:0;text-align:left" type="text" name="EMPNO2" value="<%= !empNo.equals("") ? "(" : "" %><%= empNo %><%= !empNo.equals("") ? ")" : "" %>" readonly>
                    </td>
                </tr>
            </table>
<%
    if( B03Develop_vt.size() > 0 ) {
%>

            <div class="align_center">
                <%= pu == null ?  "" : pu.pageInfo() %>
            </div>

<%
    }
%>

    <!--리스트 테이블 시작-->
    <div class="listArea">
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
        for ( int i = pu.formRow() ; i < pu.toRow() ; i++ ) {
            B03DevelopData developData = (B03DevelopData)B03Develop_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td><input type="radio" name="radiobutton" value="<%= k %>" <%=(k==0) ? "checked" : ""%>>
                                   <input type="hidden" name="BEGDA<%= k %>"  value="<%= DataUtil.removeStructur(developData.BEGDA,"-","") %>">
                                   <input type="hidden" name="SEQNR<%= k %>"  value="<%= developData.SEQNR %>">
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
<!-- PageUtil 관련 - 반드시 써준다. -->
            <div class="align_center">
                <input type="hidden" name="page" value="<%= paging %>">
                <%= pu == null ?  "" : pu.pageControl() %>
            </div>
<!-- PageUtil 관련 - 반드시 써준다. -->
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_mdl">
            <li><a href="javascript:goDetail();"><span>조회</span></a></li>
            <li id="sc_button"><a href="javascript:doSubmit();"><span>생성</span></a></li>
            <li><a href="javascript:goChange();"><span>수정</span></a></li>
            <li><a href="javascript:goDelete();"><span>삭제</span></a></li>
        </ul>
    </div>


<%
    } else {
%>
                <tr class="oddRow">
                    <td class="lastCol" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
            </table>
        </div>
    </div>

<%
        if ( !ENAME.equals("") ) {
%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a href="javascript:doSubmit();"><span>신청</span></a></li>
        </ul>
    </div>
<%
        }
%>

<%
    }
%>

  </div>
</form>
<form name="form2">
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="begDa" value="">
  <input type="hidden" name="command" value="">
  <input type="hidden" name="empNo" value="">
  <input type="hidden" name="seqnr" value="">
  <input type="hidden" name="ORGTX" value="">
  <input type="hidden" name="TITEL" value="">
  <input type="hidden" name="TITL2" value="">
  <input type="hidden" name="ENAME" value="">
</form>

<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="page" value="<%= paging %>">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

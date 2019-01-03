<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인재개발협의결과입력                                        */
/*   Program Name : 인재개발 협의결과 관리                                      */
/*   Program ID   : B03DevelogBuild.jsp                                         */
/*   Description  : 인재개발 협의결과 관리 입력 화면                            */
/*   Note         : 없음                                                        */
/*   Creation     : 최영호                                                      */
/*   Update       : 2005-01-26  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>
<%@ page import="hris.B.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector B03DevelopChiefInfo_vt  = (Vector)request.getAttribute("B03DevelopChiefInfo_vt") ;
    Vector B03DevelopChiefInfo2_vt = (Vector)request.getAttribute("B03DevelopChiefInfo2_vt") ;
    Vector B03DevelopChiefInfo3_vt = (Vector)request.getAttribute("B03DevelopChiefInfo3_vt") ;
    Vector B03DevelopSectInfo_vt   = (Vector)request.getAttribute("B03DevelopSectInfo_vt") ;

    String com_num   = (String)request.getAttribute("com_num");
    String com_nam   = (String)request.getAttribute("com_nam");
    String com_typ   = (String)request.getAttribute("com_typ");

    String com1_nam1 = (String)request.getAttribute("com1_nam1");
    String com2_nam2 = (String)request.getAttribute("com2_nam2");
    String com3_nam3 = (String)request.getAttribute("com3_nam3");
    String com4_nam4 = (String)request.getAttribute("com4_nam4");

    String com1_num1 = (String)request.getAttribute("com1_num1");
    String com2_num2 = (String)request.getAttribute("com2_num2");
    String com3_num3 = (String)request.getAttribute("com3_num3");
    String com4_num4 = (String)request.getAttribute("com4_num4");

    String empNo     = (String)request.getAttribute("empNo");
    String seqnr     = (String)request.getAttribute("seqnr");
    String auth      = (String)request.getAttribute("auth");

    String ORGTX     = (String)request.getAttribute("ORGTX");
    String TITEL     = (String)request.getAttribute("TITEL");
    String TITL2     = (String)request.getAttribute("TITL2");
    String ENAME     = (String)request.getAttribute("ENAME");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--

function goSave(){
    if( check_data() ) {
        document.form1.jobid.value = "creat";
        document.form1.perno.value = '<%= empNo %>';
        document.form1.begda.value = document.form1.BEGDA.value;
        document.form1.seqnr.value = '<%= seqnr %>';
        document.form1.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
        document.form1.method = 'post' ;
        document.form1.submit();
    }
}

function goDevelop(){

    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.jobid.value = "develop";
    document.form2.perno.value = '<%= empNo %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'post' ;
    document.form2.submit();
}

function getename(obj){
    var company = '<%= user.companyCode %>';
/*
  if( company == 'C100' ){
    var perno = document.form1.COMM_NUMB[document.form1.COMM_NUMB.selectedIndex].text;

<%
    for ( int i = 0 ; i < B03DevelopChiefInfo_vt.size() ; i++ ) {
      B03DevelopChiefInfoData data = (B03DevelopChiefInfoData)B03DevelopChiefInfo_vt.get(i);
%>
      if(perno == <%= WebUtil.printNum(data.PERNR) %>){
         document.form1.COMM_NAME.value = "<%= data.ENAME %>";
      }
<%  }  %>
  }else{
*/
    var perno  = document.form1.COMM_NUMB[document.form1.COMM_NUMB.selectedIndex].text;
    var perno2 = document.form1.COM1_NUMB[document.form1.COM1_NUMB.selectedIndex].text;
    var perno3 = document.form1.COM2_NUMB[document.form1.COM2_NUMB.selectedIndex].text;
    var perno4 = document.form1.COM3_NUMB[document.form1.COM3_NUMB.selectedIndex].text;
    var perno5 = document.form1.COM4_NUMB[document.form1.COM4_NUMB.selectedIndex].text;

     if(obj == 01) {
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo_vt.size() ; i++ ) {
      B03DevelopChiefInfoData data = (B03DevelopChiefInfoData)B03DevelopChiefInfo_vt.get(i);
%>
      if(perno == <%= WebUtil.printNum(data.PERNR) %>){
         document.form1.COMM_NAME.value = "<%= data.ENAME %>";
      }
<%  }  %>
     }else if(obj == 02) {
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
      B03DevelopChiefInfoData data3 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);
%>
      if(perno2 == <%= WebUtil.printNum(data3.PERNR) %>){
         document.form1.COM1_NAME.value = "<%= data3.ENAME %>";
      }
<%  }  %>
     }else if(obj == 03) {
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
      B03DevelopChiefInfoData data4 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);
%>
      if(perno3 == <%= WebUtil.printNum(data4.PERNR) %>){
         document.form1.COM2_NAME.value = "<%= data4.ENAME %>";
      }
<%  }  %>
     }else if(obj  == 04) {
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
      B03DevelopChiefInfoData data5 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);
%>
      if(perno4 == <%= WebUtil.printNum(data5.PERNR) %>){
         document.form1.COM3_NAME.value = "<%= data5.ENAME %>";
      }
<%  }  %>
     }else if(obj == 05) {
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo3_vt.size() ; i++ ) {
      B03DevelopChiefInfoData data6 = (B03DevelopChiefInfoData)B03DevelopChiefInfo3_vt.get(i);
%>
      if(perno5 == <%= WebUtil.printNum(data6.PERNR) %>){
         document.form1.COM4_NAME.value = "<%= data6.ENAME %>";
      }
<%  }  %>
     }
//  }
}

function getsect(obj){
    var sect = document.form1.COMM_TYPE[document.form1.COMM_TYPE.selectedIndex].value;
    var comp = '<%= user.companyCode %>';

    document.form2.jobid.value = "sect";
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.sect.value = sect;
    document.form2.com_num.value = document.form1.COMM_NUMB[document.form1.COMM_NUMB.selectedIndex].value;
//    document.form2.com_nam.value = document.form1.COMM_NAME.value;
    document.form2.com_typ.value = document.form1.COMM_TYPE[document.form1.COMM_TYPE.selectedIndex].value;

//    if( comp == 'N100' ){
      document.form2.com1_num1.value = document.form1.COM1_NUMB[document.form1.COM1_NUMB.selectedIndex].value;
      document.form2.com2_num2.value = document.form1.COM2_NUMB[document.form1.COM2_NUMB.selectedIndex].value;
      document.form2.com3_num3.value = document.form1.COM3_NUMB[document.form1.COM3_NUMB.selectedIndex].value;
      document.form2.com4_num4.value = document.form1.COM4_NUMB[document.form1.COM4_NUMB.selectedIndex].value;
//    }
    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.empNo.value  = '<%= empNo %>';
    document.form2.seqnr.value  = '<%= seqnr %>';
    document.form2.auth.value  = '<%= auth %>';
    document.form2.method = 'post' ;
    document.form2.submit();
}

function check_data(){
    var comp = '<%= user.companyCode %>';

    if( checkNull(document.form1.BEGDA,"협의날짜를") == false ) {
      return false;
    }
    if(document.form1.COMM_NUMB.selectedIndex==0){
        alert("위원장을 선택하세요");
        document.form1.COMM_NUMB.focus();
        return false;
    }
  if(comp == 'C100'){
//    if( checkNull(document.form1.UPBR_NUMB,"육성책임자를") == false ) {
//      return false;
//    }
    if( checkNull(document.form1.UPBR_POST,"육성POST를") == false ) {
      return false;
    }
  }
    if(document.form1.COMM_TYPE.selectedIndex==0){
        alert("인재위 구분을 선택하세요");
        document.form1.COMM_TYPE.focus();
        return false;
    }
    if(document.form1.SECT_COMM.selectedIndex==0){
        alert("인재위를 선택하세요");
        document.form1.SECT_COMM.focus();
        return false;
    }
    if(comp == 'N100'){
        if( checkNull(document.form1.FUP1_TEXT,"육성책협의결과F/U를") == false ) {
            return false;
        }
    }

    if(comp == 'N100'){
        obj_1  = document.form1.EXL1_PONT;
        obj_2  = document.form1.EXL2_PONT;
        obj_3  = document.form1.SPL1_PONT;
        obj_4  = document.form1.SPL2_PONT;

        obj_value1  = obj_1.value;
        obj_value2  = obj_2.value;
        obj_value3  = obj_3.value;
        obj_value4  = obj_4.value;
    }
    if(comp == 'C100'){
        obj_14  = document.form1.UPBR_POST;

        obj_value14  = obj_14.value;
    }
    obj_5  = document.form1.UPB1_CRSE;
    obj_6  = document.form1.UPB2_CRSE;
    obj_7  = document.form1.CMT1_TEXT;
    obj_8  = document.form1.CMT2_TEXT;
    obj_9  = document.form1.CMT3_TEXT;
    obj_10 = document.form1.ETC1_TEXT;
    obj_11 = document.form1.ETC2_TEXT;
    obj_12 = document.form1.FUP1_TEXT;
    obj_13 = document.form1.FUP2_TEXT;
    obj_15 = document.form1.CMT4_TEXT;
    obj_16 = document.form1.CMT5_TEXT;
    obj_17 = document.form1.CMT6_TEXT;

    obj_value5  = obj_5.value;
    obj_value6  = obj_6.value;
    obj_value7  = obj_7.value;
    obj_value8  = obj_8.value;
    obj_value9  = obj_9.value;
    obj_value10 = obj_10.value;
    obj_value11 = obj_11.value;
    obj_value12 = obj_12.value;
    obj_value13 = obj_13.value;
    obj_value15 = obj_15.value;
    obj_value16 = obj_16.value;
    obj_value17 = obj_17.value;

    if(comp == 'N100'){
        if( checkLength(obj_value1) > 70 ){
             alert("우수한점은 한글 35자, 영문 70자 이내여야 합니다.");
             obj_1.focus();
             obj_1.select();
             return false;
        }
        if( checkLength(obj_value2) > 70 ){
             alert("우수한점은 한글 35자, 영문 70자 이내여야 합니다.");
             obj_2.focus();
             obj_2.select();
             return false;
        }
        if( checkLength(obj_value3) > 70 ){
             alert("보완할점은 한글 35자, 영문 70자 이내여야 합니다.");
             obj_3.focus();
             obj_3.select();
             return false;
        }
         if( checkLength(obj_value4) > 70 ){
             alert("보완할점은 한글 35자, 영문 70자 이내여야 합니다.");
             obj_4.focus();
             obj_4.select();
             return false;
        }
    }

    if(comp == 'C100'){
        if( checkLength(obj_value14) > 70 ){
            alert("육성POST은 한글 35자, 영문 70자 이내여야 합니다.");
            obj_14.focus();
            obj_14.select();
            return false;
        }
    }
    if( checkLength(obj_value5) > 70 ){
        alert("육성방향은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_5.focus();
        obj_5.select();
        return false;
    }
    if( checkLength(obj_value6) > 70 ){
        alert("육성방향은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_6.focus();
        obj_6.select();
        return false;
    }
    if( checkLength(obj_value7) > 70 ){
        alert("종합의견은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_7.focus();
        obj_7.select();
        return false;
    }
    if( checkLength(obj_value8) > 70 ){
        alert("종합의견은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_8.focus();
        obj_8.select();
        return false;
    }
    if( checkLength(obj_value9) > 70 ){
        alert("종합의견은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_9.focus();
        obj_9.select();
        return false;
    }
    if( checkLength(obj_value15) > 70 ){
        alert("종합의견은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_14.focus();
        obj_14.select();
        return false;
    }
    if( checkLength(obj_value16) > 70 ){
        alert("종합의견은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_15.focus();
        obj_15.select();
        return false;
    }
    if( checkLength(obj_value17) > 70 ){
        alert("종합의견은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_16.focus();
        obj_16.select();
        return false;
    }
    if( checkLength(obj_value10) > 70 ){
        alert("기타사항은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_10.focus();
        obj_10.select();
        return false;
    }
    if( checkLength(obj_value11) > 70 ){
        alert("기타사항은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_11.focus();
        obj_11.select();
        return false;
    }
    if( checkLength(obj_value12) > 70 ){
        alert("육성책 협의결과F/U은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_12.focus();
        obj_12.select();
        return false;
    }
    if( checkLength(obj_value13) > 70 ){
        alert("육성책 협의결과F/U은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_13.focus();
        obj_13.select();
        return false;
    }

    return true;
}

function gubun_change() {
    document.form1.I_VALUE1.value    = "";
    document.form1.I_VALUE1.focus();
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        pers_search();
    }
}

function pers_search() {
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
//-->
</SCRIPT></head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과 관리</h1></div>

    <div class="tableInquiry">
        <table>
            <colgroup>
                <col width="15%" />
                <col />
            </colgroup>
            <tr>
                <th>선택구분</th>
                <td>
                    <select name="I_GUBUN" onChange="javascript:gubun_change()">
                        <option value="2" >성명별</option>
                        <option value="1" >사번별</option>
                    </select>
                    <input type="text"   name="I_VALUE1" size="10"  maxlength="10"  value=""  onKeyUp = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                    <input type="hidden" name="jobid" value="">
                    <input type="hidden" name="empNo" value="">
                    <input type="hidden" name="I_DEPT"    value="">
                    <input type="hidden" name="E_RETIR"   value="">
                    <input type="hidden" name="retir_chk" value="">
                    <input type="hidden" name="page"      value="">
                    <input type="hidden" name="count"     value="">
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:pers_search();"><span>사원찾기</span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral perInfo">
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
        </div>
    </div>

    <!--리스트 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
<%
    if(user.companyCode.equals("C100")) {
%>
                <tr>
                    <th>협의일</th>
                    <td name="BEGDA" id="BEGDA"><input type="text" name="BEGDA" value=""  size="20"></td>
                    <th class="th02">본인F/B여부</th>
                    <td><input type="checkbox" name="SELF_FLAG" value="X"></td>
                </tr>
                <tr>
                    <th>위원장</th>
                    <td colspan='3'>
                        <select name="COMM_NUMB" onChange="javascript:getename('01');">
                            <option value="">--선택하세요--</option>
<%
        for ( int i = 0 ; i < B03DevelopChiefInfo_vt.size() ; i++ ) {
            B03DevelopChiefInfoData data = (B03DevelopChiefInfoData)B03DevelopChiefInfo_vt.get(i);
//          int com_num2 = Integer.parseInt(com_num.equals("") ? "0" : com_num);
%>
                            <option value="<%= data.PERNR %>"<%= com_num.equals(data.PERNR) ? "selected" : ""%>><%= data.ENAME %></option>

<%
        }
%>
                        </select>
                    </td>
                </tr>
<%
    }else{
%>
                <tr>
                    <th>협의일</th>
                    <td name="BEGDA" id="BEGDA" colspan='3'>
                        <input type="text" name="BEGDA" value=""  size="20">
                    </td>
                </tr>
                <tr>
                    <th>위원장</th>
                    <td colspan='3'>
                        <select name="COMM_NUMB" onChange="javascript:getename('01');">
                            <option value="">--선택하세요--</option>
<%
        for ( int i = 0 ; i < B03DevelopChiefInfo_vt.size() ; i++ ) {
            B03DevelopChiefInfoData data = (B03DevelopChiefInfoData)B03DevelopChiefInfo_vt.get(i);
//          int com_num2 = Integer.parseInt(com_num.equals("") ? "0" : com_num);
%>
                            <option <var></var>alue="<%= data.PERNR %>"<%= com_num.equals(data.PERNR) ? "selected" : ""%>><%= data.ENAME %></option>

<%
        }
%>
                        </select>
                    </td>
                </tr>
<%
    }
%>
                <tr>
                  <th>인재위구분</th>
                  <td>
                        <select name="COMM_TYPE" onChange="javascript:getsect(this);">
                            <option value="">----선택하세요----</option>
<%
    if(auth.equals("1")){
%>
                            <option value="01"<%= com_typ.equals("01") ? "selected" : ""%>>전사인재개발위원회</option>
                            <option value="02"<%= com_typ.equals("02") ? "selected" : ""%>>인재개발소위원회</option>
                            <option value="03"<%= com_typ.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
    }else if(auth.equals("2")) {
%>
                            <option value="02"<%= com_typ.equals("02") ? "selected" : ""%>>인재개발소위원회</option>
                            <option value="03"<%= com_typ.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
    }else if(auth.equals("3")) {
%>
                            <option value="03"<%= com_typ.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
    }
%>
                        </select>
                    </td>
                    <th class="th02">인재위</th>
                    <td>
                        <select name="SECT_COMM" onChange="">
                            <option value="">---선택하세요-----</option>
<%
    for ( int j = 0 ; j < B03DevelopSectInfo_vt.size() ; j++ ) {
        B03DevelopSectInfoData data2 = (B03DevelopSectInfoData)B03DevelopSectInfo_vt.get(j);
%>
                            <option value="<%= data2.OBJID %>"><%= data2.MC_STEXT %></option>

<%
    }
%>
                        </select>
                    </td>
                </tr>
<%
    if (user.companyCode.equals("N100")) {
%>
                <tr>
                    <th rowspan='2'>우수한점</th>
                    <td colspan="3"><input type="text" name="EXL1_PONT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="EXL2_PONT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <th rowspan='2'>보완할점</th>
                    <td colspan="3"><input type="text" name="SPL1_PONT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="SPL2_PONT"  size="90" maxlength='70'></td>
                </tr>
<%
    }
%>
<%
    if (user.companyCode.equals("C100")) {
%>
                <tr>
                    <th>육성POST</th>
                    <td colspan="3"><input type="text" name="UPBR_POST"  size="90" maxlength='70'></td>
                </tr>
<%
    }
%>
                <tr>
                    <th rowspan='2' valign='top'>육성방향</th>
                    <td colspan="3"><input type="text" name="UPB1_CRSE"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="UPB2_CRSE"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <th rowspan='6'>종합의견</th>
                    <td colspan="3"><input type="text" name="CMT1_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="CMT2_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="CMT3_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="CMT4_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="CMT5_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="CMT6_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <th rowspan='2'>기타사항</th>
                    <td colspan="3"><input type="text" name="ETC1_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="ETC2_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <th rowspan='2'>육성책<br>협의결과F/U</th>
                    <td colspan="3"><input type="text" name="FUP1_TEXT"  size="90" maxlength='70'></td>
                </tr>
                <tr>
                    <td colspan="3"><input type="text" name="FUP2_TEXT"  size="90" maxlength='70'></td>
                </tr>
        <%-- if (user.companyCode.equals("N100")) { --%>
                <tr>
                    <th>위 원</th>
                    <td>
                        <select name="COM1_NUMB" onChange="javascript:getename('02');">
                            <option value="">--선택하세요--</option>
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
        B03DevelopChiefInfoData data3 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);
%>
                            <option value="0<%= data3.PERNR %>"<%= com1_num1.equals(data3.PERNR) ? "selected" : ""%>><%= data3.ENAME %></option>

<%
    }
%>
                        </select>
                    </td>
                    <th class="th02">위 원</th>
                    <td>
                        <select name="COM2_NUMB" onChange="javascript:getename('03');">
                            <option value="">--선택하세요--</option>
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
        B03DevelopChiefInfoData data4 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);
%>
                            <option value="0<%= data4.PERNR %>"<%= com2_num2.equals(data4.PERNR) ? "selected" : ""%>><%= data4.ENAME %></option>

<%
    }
%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>위 원</th>
                    <td>
                        <select name="COM3_NUMB" onChange="javascript:getename('04');">
                            <option value="">--선택하세요--</option>
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
        B03DevelopChiefInfoData data5 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);
%>
                            <option value="0<%= data5.PERNR %>"<%= com3_num3.equals(data5.PERNR) ? "selected" : ""%>><%= data5.ENAME %></option>

<%
    }
%>
                        </select>
                    </td>
                    <th class="th02">간 사</th>
                    <td>
                        <select name="COM4_NUMB" onChange="javascript:getename('05');">
                            <option value="">--선택하세요--</option>
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo3_vt.size() ; i++ ) {
        B03DevelopChiefInfoData data6 = (B03DevelopChiefInfoData)B03DevelopChiefInfo3_vt.get(i);
%>
                            <option value="<%= data6.PERNR %>"<%= com4_num4.equals(data6.PERNR) ? "selected" : ""%>><%= data6.ENAME %></option>

<%
    }
%>
                        </select>
                    </td>
                </tr>
<%-- } --%>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back();"><span>목록</span></a></li>
            <li><a class="darken" href="javascript:goSave();"><span>저장</span></a></li>
        </ul>
    </div>


</div>
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="perno" value="">
  <input type="hidden" name="begda" value="">
  <input type="hidden" name="seqnr" value="">
</form>
<form name="form2">
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="begDa" value="">
  <input type="hidden" name="seqnr" value="">
  <input type="hidden" name="sect" value="">
  <input type="hidden" name="com_num" value="">
  <input type="hidden" name="com_nam" value="">
  <input type="hidden" name="com_typ" value="">
  <input type="hidden" name="com1_nam1" value="">
  <input type="hidden" name="com2_nam2" value="">
  <input type="hidden" name="com3_nam3" value="">
  <input type="hidden" name="com4_nam4" value="">
  <input type="hidden" name="com1_num1" value="">
  <input type="hidden" name="com2_num2" value="">
  <input type="hidden" name="com3_num3" value="">
  <input type="hidden" name="com4_num4" value="">
  <input type="hidden" name="perno" value="">
  <input type="hidden" name="empNo" value="">
  <input type="hidden" name="auth" value="">
  <input type="hidden" name="ORGTX" value="">
  <input type="hidden" name="TITEL" value="">
  <input type="hidden" name="TITL2" value="">
  <input type="hidden" name="ENAME" value="">
</form>

<%@ include file="/web/common/commonEnd.jsp" %>

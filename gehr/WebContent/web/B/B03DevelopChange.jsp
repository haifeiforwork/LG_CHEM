<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인재개발협의결과입력                                        */
/*   Program Name : 인재개발 협의결과 상세조회                                  */
/*   Program ID   : B03DevelogChange.jsp                                        */
/*   Description  : 인재개발 협의결과 상세조회 수정 화면                        */
/*   Note         : 없음                                                        */
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
    WebUserData user = WebUtil.getSessionUser(request);

    Vector B03DevelopChiefInfo_vt  = (Vector)request.getAttribute("B03DevelopChiefInfo_vt") ;
    Vector B03DevelopChiefInfo2_vt = (Vector)request.getAttribute("B03DevelopChiefInfo2_vt") ;
    Vector B03DevelopChiefInfo3_vt = (Vector)request.getAttribute("B03DevelopChiefInfo3_vt") ;
    Vector B03DevelopSectInfo_vt   = (Vector)request.getAttribute("B03DevelopSectInfo_vt") ;
    Vector B03DevelopDetail_vt     = (Vector)request.getAttribute("B03DevelopDetail_vt") ;

    String BEGDA     = (String)request.getAttribute("begDa");
    String command   = (String)request.getAttribute("command");
    String empNo     = (String)request.getAttribute("empNo");
    String auth      = (String)request.getAttribute("auth");
    String seqnr     = (String)request.getAttribute("seqnr");

    String com1_num1 = (String)request.getAttribute("com1_num1");
    String com2_num2 = (String)request.getAttribute("com2_num2");
    String com3_num3 = (String)request.getAttribute("com3_num3");
    String com4_num4 = (String)request.getAttribute("com4_num4");
    String comm_numb = (String)request.getAttribute("comm_numb");
    String sect      = (String)request.getAttribute("sect");
    String sect2     = (String)request.getAttribute("sect2");

    String self_flag = (String)request.getAttribute("self_flag");
//  String upbr_numb = (String)request.getAttribute("upbr_numb");
    String exl1_pont = (String)request.getAttribute("exl1_pont");
    String exl2_pont = (String)request.getAttribute("exl2_pont");
    String spl1_pont = (String)request.getAttribute("spl1_pont");
    String spl2_pont = (String)request.getAttribute("spl2_pont");
    String upbr_post = (String)request.getAttribute("upbr_post");
    String upb1_crse = (String)request.getAttribute("upb1_crse");
    String upb2_crse = (String)request.getAttribute("upb2_crse");
    String cmt1_text = (String)request.getAttribute("cmt1_text");
    String cmt2_text = (String)request.getAttribute("cmt2_text");
    String cmt3_text = (String)request.getAttribute("cmt3_text");
    String cmt4_text = (String)request.getAttribute("cmt4_text");
    String cmt5_text = (String)request.getAttribute("cmt5_text");
    String cmt6_text = (String)request.getAttribute("cmt6_text");
    String etc1_text = (String)request.getAttribute("etc1_text");
    String etc2_text = (String)request.getAttribute("etc2_text");
    String fup1_text = (String)request.getAttribute("fup1_text");
    String fup2_text = (String)request.getAttribute("fup2_text");

    String ORGTX     = (String)request.getAttribute("ORGTX");
    String TITEL     = (String)request.getAttribute("TITEL");
    String TITL2     = (String)request.getAttribute("TITL2");
    String ENAME     = (String)request.getAttribute("ENAME");

    B03DevelopData data = (B03DevelopData)B03DevelopDetail_vt.get(Integer.parseInt(command));
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function goDetail_change(){
    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.jobid.value = "develop_change";
    document.form2.begDa.value = document.form1.BEGDA.value;
    document.form2.empNo.value = '<%= empNo %>';
    document.form2.seqnr.value = '<%= data.SEQNR %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'get' ;
    document.form2.submit() ;
}

function goSave(){
    if( check_data() ) {
        document.form1.jobid.value = "change_save";
        document.form1.empNo.value  = '<%= empNo %>';
        document.form1.seqnr.value  = '<%= data.SEQNR %>';
        document.form1.command.value  = '<%= command %>';
        document.form1.auth.value  = '<%= auth %>';
        document.form1.begDa.value  = document.form1.BEGDA.value;
        document.form1.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
        document.form1.method = 'get' ;
        document.form1.submit() ;
    }
}

function getsect(obj){
    var sect  = document.form1.COMM_TYPE[document.form1.COMM_TYPE.selectedIndex].value;
    var sect2 = document.form1.SECT_COMM[document.form1.SECT_COMM.selectedIndex].value;
    var comp  = '<%= user.companyCode %>';

    document.form2.jobid.value = "sect1";
    document.form2.sect.value = sect;
    document.form2.sect2.value = sect2;

    document.form2.com1_num1.value = document.form1.COM1_NUMB[document.form1.COM1_NUMB.selectedIndex].value;
    document.form2.com2_num2.value = document.form1.COM2_NUMB[document.form1.COM2_NUMB.selectedIndex].value;
    document.form2.com3_num3.value = document.form1.COM3_NUMB[document.form1.COM3_NUMB.selectedIndex].value;
    document.form2.com4_num4.value = document.form1.COM4_NUMB[document.form1.COM4_NUMB.selectedIndex].value;

    if( comp == 'N100' ){
        document.form2.exl1_pont.value = document.form1.EXL1_PONT.value;
        document.form2.exl2_pont.value = document.form1.EXL2_PONT.value;
        document.form2.spl1_pont.value = document.form1.SPL1_PONT.value;
        document.form2.spl2_pont.value = document.form1.SPL1_PONT.value;
    }
    if( comp == 'C100' ){
        document.form2.upbr_post.value = document.form1.UPBR_POST.value;
//      document.form2.upbr_numb.value = document.form1.UPBR_NUMB.value;
    }

    document.form2.upb1_crse.value = document.form1.UPB1_CRSE.value;
    document.form2.upb2_crse.value = document.form1.UPB2_CRSE.value;
    document.form2.cmt1_text.value = document.form1.CMT1_TEXT.value;
    document.form2.cmt2_text.value = document.form1.CMT2_TEXT.value;
    document.form2.cmt3_text.value = document.form1.CMT3_TEXT.value;
    document.form2.etc1_text.value = document.form1.ETC1_TEXT.value;
    document.form2.etc2_text.value = document.form1.ETC2_TEXT.value;
    document.form2.fup1_text.value = document.form1.FUP1_TEXT.value;
    document.form2.fup2_text.value = document.form1.FUP2_TEXT.value;

    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.empNo.value  = '<%= empNo %>';
    document.form2.seqnr.value  = '<%= data.SEQNR %>';
    document.form2.auth.value  = '<%= auth %>';
    document.form2.command.value  = '<%= command %>';
    document.form2.begDa.value  = document.form1.BEGDA.value;
    document.form2.comm_numb.value = document.form1.COMM_NUMB[document.form1.COMM_NUMB.selectedIndex].value;
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'get' ;
    document.form2.submit();
}

function moklok(){
  document.form2.jobid.value = "first";
  document.form2.empNo.value = '<%= empNo %>';
  document.form2.action = "<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV";
  document.form2.method = "post";
  document.form2.submit();
}

function check_data(){
    var company = '<%= user.companyCode %>';

    if( checkNull(document.form1.BEGDA,"협의날짜를") == false ) {
        return false;
    }
    if(document.form1.COMM_NUMB.selectedIndex==0){
        alert("위원장을 선택하세요");
        document.form1.COMM_NUMB.focus();
        return false;
    }
    if(company == 'C100'){
//      if( checkNull(document.form1.UPBR_NUMB,"육성책임자를") == false ) {
//          return false;
//      }
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
    if(company == 'N100'){
        if( checkNull(document.form1.FUP1_TEXT,"육성책협의결과F/U를") == false ) {
            return false;
        }
    }

    if(company == 'N100'){
        obj_1 = document.form1.EXL1_PONT;
        obj_2 = document.form1.EXL2_PONT;
        obj_3 = document.form1.SPL1_PONT;
        obj_4 = document.form1.SPL2_PONT;

        obj_value1 = obj_1.value;
        obj_value2 = obj_2.value;
        obj_value3 = obj_3.value;
        obj_value4 = obj_4.value;
    }
    if(company == 'C100'){
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

    if(company == 'N100'){
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
    if(company == 'C100'){
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
        obj_15.focus();
        obj_15.select();
        return false;
    }
    if( checkLength(obj_value16) > 70 ){
        alert("종합의견은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_16.focus();
        obj_16.select();
        return false;
    }
    if( checkLength(obj_value17) > 70 ){
        alert("종합의견은 한글 35자, 영문 70자 이내여야 합니다.");
        obj_17.focus();
        obj_17.select();
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

//-->
</SCRIPT></head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과 상세조회</h1></div>

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
    B03DevelopData developDetailData = (B03DevelopData)B03DevelopDetail_vt.get(Integer.parseInt(command));

    if(user.companyCode.equals("N100")) {
%>
                <tr>
                    <th>협의일</th>
                    <td name="BEGDA" id="BEGDA" colspan="3">
                        <input type="text" name="BEGDA" value="<%= WebUtil.printDate(developDetailData.BEGDA,".")%>"  size="20" readonly>
                    </td>
                </tr>
                <tr>
                    <th>위원장</th>
                    <td colspan='3'>
                        <select name="COMM_NUMB" onChange="javascript:getename('01');">
                            <option value="">--선택하세요--</option>
<%
        for ( int i = 0 ; i < B03DevelopChiefInfo_vt.size() ; i++ ) {
            B03DevelopChiefInfoData data1 = (B03DevelopChiefInfoData)B03DevelopChiefInfo_vt.get(i);

            if(comm_numb.equals("")) {
%>
                            <option value="<%= data1.PERNR %>"<%= data.COMM_NUMB.equals(data1.PERNR) ? "selected" : ""%>><%= data1.ENAME %></option>
<%
            }else{
%>
                            <option value="<%= data1.PERNR %>"<%= comm_numb.equals(data1.PERNR) ? "selected" : ""%>><%= data1.ENAME %></option>
<%
            }
%>
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
                    <td name="BEGDA" id="BEGDA">
                        <input type="text" name="BEGDA" value="<%= WebUtil.printDate(developDetailData.BEGDA,".")%>"  size="20" readonly>
                    </td>
                    <th class="th02">본인F/B여부</th>
                    <td>
                        <input type="checkbox" name="SELF_FLAG" value="X"   <%= developDetailData.SELF_FLAG.equals("X") ? "checked" : "" %>>
                    </td>
                </tr>
                <tr>
                    <th>위원장</th>
                    <td colspan='3'>
                        <select name="COMM_NUMB" onChange="javascript:getename('01');">
                            <option value="">--선택하세요--</option>
<%
        for ( int i = 0 ; i < B03DevelopChiefInfo_vt.size() ; i++ ) {
            B03DevelopChiefInfoData data1 = (B03DevelopChiefInfoData)B03DevelopChiefInfo_vt.get(i);

            if(comm_numb.equals("")) {
%>
                            <option value="<%= data1.PERNR %>"<%= data.COMM_NUMB.equals(data1.PERNR) ? "selected" : ""%>><%= data1.ENAME %></option>
<%
            }else{
%>
                            <option value="<%= data1.PERNR %>"<%= comm_numb.equals(data1.PERNR) ? "selected" : ""%>><%= data1.ENAME %></option>
<%
            }
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
    if(sect.equals("")) {

        if(auth.equals("1")){
%>
                            <option value="01"<%= data.COMM_TYPE.equals("01") ? "selected" : ""%>>전사인재개발위원회</option>
                            <option value="02"<%= data.COMM_TYPE.equals("02") ? "selected" : ""%>>인재개발소위원회</option>
                            <option value="03"<%= data.COMM_TYPE.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
        }else if(auth.equals("2")) {
%>
                            <option value="02"<%= data.COMM_TYPE.equals("02") ? "selected" : ""%>>인재개발소위원회</option>
                            <option value="03"<%= data.COMM_TYPE.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
        }else if(auth.equals("3")) {
%>
                            <option value="03"<%= data.COMM_TYPE.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
        }
%>
<%
    }else{
%>
<%
        if(auth.equals("1")){
%>
                            <option value="01"<%= sect.equals("01") ? "selected" : ""%>>전사인재개발위원회</option>
                            <option value="02"<%= sect.equals("02") ? "selected" : ""%>>인재개발소위원회</option>
                            <option value="03"<%= sect.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
        }else if(auth.equals("2")) {
%>
                            <option value="02"<%= sect.equals("02") ? "selected" : ""%>>인재개발소위원회</option>
                            <option value="03"<%= sect.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
        }else if(auth.equals("3")) {
%>
                            <option value="03"<%= sect.equals("03") ? "selected" : ""%>>인재개발분과위원회</option>
<%
        }
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

        if(sect2.equals("")) {
%>
                            <option value="<%= data2.OBJID %>"<%= data.SECT_COMM.equals(data2.OBJID) ? "selected" : ""%>><%= data2.MC_STEXT %></option>
<%
        }else{
%>
                            <option value="<%= data2.OBJID %>"<%= sect2.equals(data2.OBJID) ? "selected" : ""%>><%= data2.MC_STEXT %></option>
<%
        }
    }
%>
                        </select>
                    </td>
                </tr>
<%
    if (user.companyCode.equals("N100")) {
%>
                <tr>
                    <td rowspan='2'>우수한점</td>
                    <td colspan="3">
<%
        if(exl1_pont.equals("")) {
%>
                        <input type="text" name="EXL1_PONT"  size="90" maxlength='60' value='<%= developDetailData.EXL1_PONT == null ? "" : developDetailData.EXL1_PONT %>'>
<%
        }else{
%>
                        <input type="text" name="EXL1_PONT"  size="90" maxlength='60' value='<%= exl1_pont.equals("") ? "" : exl1_pont %>'>
<%
        }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
        if(exl2_pont.equals("")) {
%>
                        <input type="text" name="EXL2_PONT"  size="90" maxlength='60' value='<%= developDetailData.EXL2_PONT == null ? "" : developDetailData.EXL2_PONT %>'>
<%
        }else{
%>
                        <input type="text" name="EXL2_PONT"  size="90" maxlength='60' value='<%= exl2_pont.equals("") ? "" : exl2_pont %>'>
<%
        }
%>
                    </td>
                </tr>
                <tr>
                    <th rowspan='2'>보완할점</th>
                    <td colspan="3">
<%
        if(spl1_pont.equals("")) {
%>
                        <input type="text" name="SPL1_PONT"  size="90" maxlength='60' value='<%= developDetailData.SPL1_PONT == null ? "" :  developDetailData.SPL1_PONT %>'>
<%
        }else{
%>
                        <input type="text" name="SPL1_PONT"  size="90" maxlength='60' value='<%= spl1_pont.equals("") ? "" : spl1_pont %>'>
<%
        }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
        if(spl2_pont.equals("")) {
%>
                        <input type="text" name="SPL2_PONT"  size="90" maxlength='60' value='<%= developDetailData.SPL2_PONT == null ? "" :  developDetailData.SPL2_PONT %>'>
<%
        }else{
%>
                        <input type="text" name="SPL2_PONT"  size="90" maxlength='60' value='<%= spl2_pont.equals("") ? "" : spl2_pont %>'>
<%
        }
%>
                    </td>
                </tr>
<%
    }
%>
<%
    if (user.companyCode.equals("C100")) {
%>
                <tr>
                    <th>육성POST</th>
                    <td colspan="3">
<%
        if(upbr_post.equals("")) {
%>
                        <input type="text" name="UPBR_POST"  size="90" maxlength='60' value='<%= developDetailData.UPBR_POST == null ? "" : developDetailData.UPBR_POST %>'>
<%
        }else{
%>
                        <input type="text" name="UPBR_POST"  size="90" maxlength='60' value='<%= upbr_post.equals("") ? "" : upbr_post %>'>
<%
        }
%>
                    </td>
                </tr>
<%
    }
%>
                <tr>
                    <td rowspan='2'>육성방향</td>
                    <td colspan="3">
<%
    if(upb1_crse.equals("")) {
%>
                    <input type="text" name="UPB1_CRSE"  size="90" maxlength='60' value='<%= developDetailData.UPB1_CRSE == null ? "" : developDetailData.UPB1_CRSE %>'>
<%
    }else{
%>
                    <input type="text" name="UPB1_CRSE"  size="90" maxlength='60' value='<%= upb1_crse.equals("") ? "" : upb1_crse %>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
    if(upb2_crse.equals("")) {
%>
                    <input type="text" name="UPB2_CRSE"  size="90" maxlength='60' value='<%= developDetailData.UPB1_CRSE == null ? "" : developDetailData.UPB2_CRSE %>'>
<%
    }else{
%>
                    <input type="text" name="UPB2_CRSE"  size="90" maxlength='60' value='<%= upb2_crse.equals("") ? "" : upb2_crse %>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <th rowspan='6'>종합의견</th>
                    <td colspan="3">
<%
    if(cmt1_text.equals("")) {
%>
                        <input type="text" name="CMT1_TEXT"  size="90" maxlength='70' value='<%= developDetailData.CMT1_TEXT == null ? "" : developDetailData.CMT1_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="CMT1_TEXT"  size="90" maxlength='70' value='<%= cmt1_text.equals("") ? "" : cmt1_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
    if(cmt2_text.equals("")) {
%>
                        <input type="text" name="CMT2_TEXT"  size="90" maxlength='70' value='<%= developDetailData.CMT2_TEXT == null ? "" : developDetailData.CMT2_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="CMT2_TEXT"  size="90" maxlength='70' value='<%= cmt2_text.equals("") ? "" : cmt2_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
    if(cmt3_text.equals("")) {
%>
                        <input type="text" name="CMT3_TEXT"  size="90" maxlength='70' value='<%= developDetailData.CMT3_TEXT == null ? "" : developDetailData.CMT3_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="CMT3_TEXT"  size="90" maxlength='70' value='<%= cmt3_text.equals("") ? "" : cmt3_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
    if(cmt4_text.equals("")) {
%>
                        <input type="text" name="CMT4_TEXT"  size="90" maxlength='70' value='<%= developDetailData.CMT4_TEXT == null ? "" : developDetailData.CMT4_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="CMT4_TEXT"  size="90" maxlength='70' value='<%= cmt4_text.equals("") ? "" : cmt4_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
    if(cmt5_text.equals("")) {
%>
                        <input type="text" name="CMT5_TEXT"  size="90" maxlength='70' value='<%= developDetailData.CMT5_TEXT == null ? "" : developDetailData.CMT5_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="CMT5_TEXT"  size="90" maxlength='70' value='<%= cmt5_text.equals("") ? "" : cmt5_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
    if(cmt6_text.equals("")) {
%>
                        <input type="text" name="CMT6_TEXT"  size="90" maxlength='70' value='<%= developDetailData.CMT6_TEXT == null ? "" : developDetailData.CMT6_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="CMT6_TEXT"  size="90" maxlength='70' value='<%= cmt6_text.equals("") ? "" : cmt6_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <th rowspan='2'>기타사항</th>
                    <td colspan="3">
<%
    if(etc1_text.equals("")) {
%>
                        <input type="text" name="ETC1_TEXT"  size="90" maxlength='60' value='<%= developDetailData.ETC1_TEXT == null ? "" : developDetailData.ETC1_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="ETC1_TEXT"  size="90" maxlength='60' value='<%= etc1_text.equals("") ? "" : etc1_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
    if(etc2_text.equals("")) {
%>
                        <input type="text" name="ETC2_TEXT"  size="90" maxlength='60' value='<%= developDetailData.ETC2_TEXT == null ? "" : developDetailData.ETC2_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="ETC2_TEXT"  size="90" maxlength='60' value='<%= etc2_text.equals("") ? "" : etc2_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <th rowspan='2'>육성책<br>협의결과F/U</th>
                    <td colspan="3">
<%
    if(fup1_text.equals("")) {
%>
                        <input type="text" name="FUP1_TEXT"  size="90" maxlength='60' value='<%= developDetailData.FUP1_TEXT == null ? "" : developDetailData.FUP1_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="FUP1_TEXT"  size="90" maxlength='60' value='<%= fup1_text.equals("") ? "" : fup1_text%>'>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
<%
    if(fup2_text.equals("")) {
%>
                        <input type="text" name="FUP2_TEXT"  size="90" maxlength='60' value='<%= developDetailData.FUP2_TEXT == null ? "" : developDetailData.FUP2_TEXT %>'>
<%
    }else{
%>
                        <input type="text" name="FUP2_TEXT"  size="90" maxlength='60' value='<%= fup2_text.equals("") ? "" : fup2_text%>'>
<%
    }
%>
                    </td>
                </tr>
<%-- if (user.companyCode.equals("N100")) { --%>
                <tr>
                    <th>위 원</th>
                    <td>
                        <select name="COM1_NUMB" onChange="">
                            <option value="">--선택하세요--</option>
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
        B03DevelopChiefInfoData data3 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);
%>
<%
        if(com1_num1.equals("")) {
%>
                            <option value="<%= data3.PERNR %>"<%= developDetailData.COM1_NUMB.equals(data3.PERNR) ? "selected" : ""%>><%= data3.ENAME %></option>
<%
        }else{
%>
                            <option value="<%= data3.PERNR %>"<%= com1_num1.equals(data3.PERNR) ? "selected" : ""%>><%= data3.ENAME %></option>
<%
        }
%>
<%
    }
%>
                        </select>
                    </td>
                    <th class="th02">위 원</th>
                    <td>
                        <select name="COM2_NUMB" onChange="">
                            <option value="">--선택하세요--</option>
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
        B03DevelopChiefInfoData data4 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);

        if(com2_num2.equals("")) {
%>
                            <option value="<%= data4.PERNR %>"<%= developDetailData.COM2_NUMB.equals(data4.PERNR) ? "selected" : ""%>><%= data4.ENAME %></option>
<%
        }else{
%>
                            <option value="<%= data4.PERNR %>"<%= com2_num2.equals(data4.PERNR) ? "selected" : ""%>><%= data4.ENAME %></option>
<%
        }
    }
%>
                        </select>

                    </td>
                </tr>
                <tr>
                    <th>위 원</th>
                    <td>
                        <select name="COM3_NUMB" onChange="">
                            <option value="">--선택하세요--</option>
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo2_vt.size() ; i++ ) {
        B03DevelopChiefInfoData data5 = (B03DevelopChiefInfoData)B03DevelopChiefInfo2_vt.get(i);

        if(com3_num3.equals("")) {
%>
                            <option value="<%= data5.PERNR %>"<%= developDetailData.COM3_NUMB.equals(data5.PERNR) ? "selected" : ""%>><%= data5.ENAME %></option>
<%
        }else{
%>
                            <option value="<%= data5.PERNR %>"<%= com3_num3.equals(data5.PERNR) ? "selected" : ""%>><%= data5.ENAME %></option>
<%
        }
    }
%>
                        </select>

                    </td>
                    <th class="th02">간 사</th>
                    <td>
                        <select name="COM4_NUMB" onChange="">
                            <option value="">--선택하세요--</option>
<%
    for ( int i = 0 ; i < B03DevelopChiefInfo3_vt.size() ; i++ ) {
        B03DevelopChiefInfoData data6 = (B03DevelopChiefInfoData)B03DevelopChiefInfo3_vt.get(i);
%>
<%
        if(com4_num4.equals("")) {
%>
                            <option value="<%= data6.PERNR %>"<%= developDetailData.COM4_NUMB.equals(data6.PERNR) ? "selected" : ""%>><%= data6.ENAME %></option>
<%
        }else{
%>
                            <option value="<%= data6.PERNR %>"<%= com4_num4.equals(data6.PERNR) ? "selected" : ""%>><%= data6.ENAME %></option>
<%
        }
%>
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
            <li><a href="javascript:moklok();"><span>목록</span></a></li>
            <li><a href="javascript:goSave();"><span>저장</span></a></li>
            <li><a href="javascript:goDetail_change();"><span>경력/교육개발</span></a></li>
        </ul>
    </div>

  </div>
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="begDa" value="">
  <input type="hidden" name="seqnr" value="">
  <input type="hidden" name="command" value="">
  <input type="hidden" name="empNo" value="">
  <input type="hidden" name="auth" value="">
</form>
<form name="form2">
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="begDa" value="">
  <input type="hidden" name="seqnr" value="">
  <input type="hidden" name="sect" value="">
  <input type="hidden" name="sect2" value="">
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
  <input type="hidden" name="command" value="">
  <input type="hidden" name="perno" value="">
  <input type="hidden" name="empNo" value="">
  <input type="hidden" name="auth" value="">
  <input type="hidden" name="comm_numb" value="">
  <input type="hidden" name="upbr_numb" value="">
  <input type="hidden" name="exl1_pont" value="">
  <input type="hidden" name="exl2_pont" value="">
  <input type="hidden" name="spl1_pont" value="">
  <input type="hidden" name="spl2_pont" value="">
  <input type="hidden" name="upbr_post" value="">
  <input type="hidden" name="upb1_crse" value="">
  <input type="hidden" name="upb2_crse" value="">
  <input type="hidden" name="cmt1_text" value="">
  <input type="hidden" name="cmt2_text" value="">
  <input type="hidden" name="cmt3_text" value="">
  <input type="hidden" name="etc1_text" value="">
  <input type="hidden" name="etc2_text" value="">
  <input type="hidden" name="fup1_text" value="">
  <input type="hidden" name="fup2_text" value="">
  <input type="hidden" name="ORGTX" value="">
  <input type="hidden" name="TITEL" value="">
  <input type="hidden" name="TITL2" value="">
  <input type="hidden" name="ENAME" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

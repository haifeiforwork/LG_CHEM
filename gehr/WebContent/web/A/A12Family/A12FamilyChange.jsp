<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 가족사항                                                    */
/*   Program ID   : A12FamilyChange.jsp                                         */
/*   Description  : 가족사항수정입력                                            */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-02  윤정현                                          */
/*                  2009-08-25  lsa                                             */
/*                   미사용 소스(2018/01/07 rdcamel)                                                           */
/********************************************************************************/%>



<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.A12Family.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector a04FamilyDetailData_vt = (Vector)request.getAttribute("a04FamilyDetailData_vt");
    Vector a12FamilyListData_vt   = (Vector)request.getAttribute("a12FamilyListData_vt");
    A12FamilyListData data = (A12FamilyListData)a12FamilyListData_vt.get(0);

    String PERNR = (String)request.getAttribute("PERNR");
    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
//  2015- 06-08 개인정보 통합시 subView ="Y";
    String subView = WebUtil.nvl(request.getParameter("subView"));
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--

// 달력 사용
function fn_openCal(obj){
    var lastDate;
    lastDate = eval("document.form1." + obj + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+obj+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    small_window.focus();
}

function do_input() {
    if( check_data() ) {
        document.form1.jobid.value = "change";

        // 관계, 학력, 출생국, 국적명을 가져간다.
        document.form1.ATEXT.value  = document.form1.KDSVH.options[document.form1.KDSVH.selectedIndex].text;
        document.form1.STEXT1.value = document.form1.FASAR.options[document.form1.FASAR.selectedIndex].text;
        document.form1.LANDX.value  = document.form1.FGBLD.options[document.form1.FGBLD.selectedIndex].text;
        document.form1.NATIO.value  = document.form1.FANAT.options[document.form1.FANAT.selectedIndex].text;
        document.form1.REGNO.disabled = 0;
        document.form1.LNMHG.disabled = 0;
        document.form1.FNMHG.disabled = 0;
        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12FamilyChangeSV?subView=<%=subView%>";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function do_preview(){
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A04FamilyDetailSV?subView=<%=subView%>";
    document.form1.method = "post";
    document.form1.submit();
}

function check_data(){
    if( checkNull(document.form1.LNMHG, "성(한글)을") == false ) {
        return false;
    }
    // 성(한글)-40 입력시 길이 제한
    x_obj = document.form1.LNMHG;
    xx_value = x_obj.value;
    if( xx_value != "" && checkLength(xx_value) > 40 ){
        x_obj.value = limitKoText(xx_value, 40);
        alert("성은 한글 20자 이내여야 합니다.");
        x_obj.focus();
        x_obj.select();
        return false;
    }

    if( checkNull(document.form1.FNMHG, "이름(한글)을") == false ) {
        return false;
    }
    // 이름(한글)-40 입력시 길이 제한
    x_obj = document.form1.FNMHG;
    xx_value = x_obj.value;
    if( xx_value != "" && checkLength(xx_value) > 40 ){
        x_obj.value = limitKoText(xx_value, 40);
        alert("이름은 한글 20자 이내여야 합니다.");
        x_obj.focus();
        x_obj.select();
        return false;
    }

    if( checkNull(document.form1.REGNO, "주민등록번호를") == false ) {
        return false;
    }

//  -----------------------------------------------------------------------------------------------------------
//  2002.08.07. 가족사항을 입력시 기존에 등록되어 있는 사람인지를 check하도록 한다.
//              저장 시 주민등록번호를 check하여 동일한 주민등록번호를 가진 가족데이타가 있으면 error를 발생시킨다.
<%
    for ( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
        A04FamilyDetailData data_regno = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);
%>
    if( "<%= DataUtil.addSeparate(data_regno.REGNO) %>" == document.form1.REGNO.value &&
                                         ("<%= data_regno.SUBTY %>" != document.form1.SUBTY.value ||
                                          "<%= data_regno.OBJPS %>" != document.form1.OBJPS.value) ) {
        alert("동일한 주민등록번호를 가진 가족이 이미 존재합니다.");
        document.form1.REGNO.focus();
        document.form1.REGNO.select();
        return false;
    }
<%
    }
%>
//  -----------------------------------------------------------------------------------------------------------

    if( document.form1.SUBTY.value == "1" ) {   // 배우자일경우 현재 사원과 같은 성별이면 에러메시지..
        chk_bit = "<%= PERNR_Data.E_REGNO.substring(6, 7) %>";

        regno_bit = document.form1.REGNO.value;
        if( chk_bit == "1" || chk_bit == "3" || chk_bit == "5" || chk_bit == "7" || chk_bit == "9" ) {
            if( regno_bit.substring(7, 8) == "1" || regno_bit.substring(7, 8) == "3" || regno_bit.substring(7, 8) == "5" || regno_bit.substring(7, 8) == "7" || regno_bit.substring(7, 8) == "9" ) {
                alert("배우자의 성별이 본인의 성별과 같아서는 안됩니다.");

                return false;
            }
        } else if( chk_bit == "2" || chk_bit == "4" || chk_bit == "6" || chk_bit == "8" || chk_bit == "0" ) {
            if( regno_bit.substring(7, 8) == "2" || regno_bit.substring(7, 8) == "4" || regno_bit.substring(7, 8) == "6" || regno_bit.substring(7, 8) == "8" || regno_bit.substring(7, 8) == "0" ) {
                alert("배우자의 성별이 본인의 성별과 같아서는 안됩니다.");

                return false;
            }
        }
    }

    if( document.form1.KDSVH.selectedIndex==0 ) {
        alert("관계를 선택하세요.");
        document.form1.KDSVH.focus();
        return false;
    }

    if( checkNull(document.form1.FGBDT, "생년월일을") == false ) {
        return false;
    }

    // 출생지-40 입력시 길이 제한
    x_obj = document.form1.FGBOT;
    xx_value = x_obj.value;
    if( xx_value != "" && checkLength(xx_value) > 40 ){
        x_obj.value = limitKoText(xx_value, 40);
        alert("출생지는 한글 20자, 영문 40자 이내여야 합니다.");
        x_obj.focus();
        x_obj.select();
        return false;
    }

    //if( document.form1.FASAR.selectedIndex==0 ) {
    //    alert("학력을 선택하세요.");
    //    document.form1.FASAR.focus();
    //    return false;
    //}

    if( document.form1.FGBLD.selectedIndex==0 ) {
        alert("출생국을 선택하세요.");
        document.form1.FGBLD.focus();
        return false;
    }

    // 교육기관-20 입력시 길이 제한
    x_obj = document.form1.FASIN;
    xx_value = x_obj.value;
    if( xx_value != "" && checkLength(xx_value) > 20 ){
        x_obj.value = limitKoText(xx_value, 20);
        alert("교육기관은 한글 10자, 영문 20자 이내여야 합니다.");
        x_obj.focus();
        x_obj.select();
        return false;
    }

    // 교육기관명 체크. 2005.3.25. mkbae.
    var val = document.form1.FASAR.options[document.form1.FASAR.selectedIndex].value;
    if(val=='B1'||val=='C1'){
      if(xx_value==""||xx_value == null){
        alert("교육기관명을 입력해주십시오.");
        x_obj.focus();
        return false;
      }
    }

    if( document.form1.FANAT.selectedIndex==0 ) {
        alert("국적을 선택하세요.");
        document.form1.FANAT.focus();
        return false;
    }

    // 직업-24 입력시 길이 제한
    x_obj = document.form1.FAJOB;
    xx_value = x_obj.value;
    if( xx_value != "" && checkLength(xx_value) > 24 ){
        x_obj.value = limitKoText(xx_value, 24);
        alert("직업은 한글 12자, 영문 24자 이내여야 합니다.");
        x_obj.focus();
        x_obj.select();
        return false;
    }

    // 생년월일
    document.form1.FGBDT.value = removePoint(document.form1.FGBDT.value);
    // 성별..
    if( document.form1.FASEX1.checked == true ) {
        document.form1.FASEX.value = "1";
    } else if( document.form1.FASEX2.checked == true ) {
        document.form1.FASEX.value = "2";
    }

    return true;
}

function resno_chk(obj){
  if( chkResnoObj_1(obj) == false ) {
    return false;
  }

//  -----------------------------------------------------------------------------------------------------------
//  2002.08.07. 가족사항을 입력시 기존에 등록되어 있는 사람인지를 check하도록 한다.
//              저장 시 주민등록번호를 check하여 동일한 주민등록번호를 가진 가족데이타가 있으면 error를 발생시킨다.
<%
    for ( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
        A04FamilyDetailData data_regno = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);
%>
    if( "<%= DataUtil.addSeparate(data_regno.REGNO) %>" == obj.value &&
                                         ("<%= data_regno.SUBTY %>" != document.form1.SUBTY.value ||
                                          "<%= data_regno.OBJPS %>" != document.form1.OBJPS.value) ) {
        alert("주민번호가 이미 등록되어 있습니다.");
        obj.value = "";
        //obj.focus();
        obj.select();
        return false;
    }
<%
    }
%>
//  -----------------------------------------------------------------------------------------------------------

    // 생년월일..
    if( obj.value != "" ){
        birthday = getBirthday(document.form1.REGNO.value)
        document.form1.FGBDT.value = birthday.substring(0, 4) + "." + birthday.substring(4, 6) + "." + birthday.substring(6, 8);
    }

    // 성별..
    if( obj.value != "" ){
        regno_bit = document.form1.REGNO.value;
        if( regno_bit.substring(7, 8) == "1" || regno_bit.substring(7, 8) == "3" || regno_bit.substring(7, 8) == "5" || regno_bit.substring(7, 8) == "7" || regno_bit.substring(7, 8) == "9" ) {
            document.form1.FASEX1.checked = true;
            document.form1.FASEX2.checked = false;
        } else if( regno_bit.substring(7, 8) == "2" || regno_bit.substring(7, 8) == "4" || regno_bit.substring(7, 8) == "6" || regno_bit.substring(7, 8) == "8" || regno_bit.substring(7, 8) == "0" ) {
            document.form1.FASEX1.checked = false;
            document.form1.FASEX2.checked = true;
        }
    }
}

// 2005.3.25. mkbae.
function scha_Check(obj,flag){
parent.window.scroll(0,0);
  var doc = document.all;
  if(flag==1){
    if(obj=='B1'||obj=='C1'){
      doc.scha.innerHTML='교육기관&nbsp;<font color=\"#0000FF\"><b>*</b></font>';
    } else {
      doc.scha.innerHTML='교육기관';
    }
  } else if(flag==2){
    var val = obj[obj.selectedIndex].value;
    doc.FASIN.value = "";
    doc.FASIN.focus();
    if(val=='B1'||val=='C1'){
      doc.scha.innerHTML='교육기관&nbsp;<font color=\"#0000FF\"><b>*</b></font>';
    } else {
      doc.scha.innerHTML='교육기관';
    }
  }
}
function subty_action(obj) {
  if (document.form1.SUBTY.value=="2" ) {
      document.form1.LNMHG.disabled=0;
      document.form1.FNMHG.disabled=0;
      document.form1.REGNO.disabled=0;
      NameCheck.style.display='none';
  }else {
      document.form1.LNMHG.disabled = 1;
      document.form1.FNMHG.disabled = 1;
      document.form1.REGNO.disabled = 1;
      NameCheck.style.display='block';
  }
  var subty  = obj.value;
  var sIndex = obj.selectedIndex;
  document.form1.target = "ifHidden";
  document.form1.action = "<%=WebUtil.JspURL%>A/A12Family/A12HiddenSubtyChange.jsp";
  document.form1.submit();
}
function do_NameCheck() {

               var URL ="<%=WebUtil.JspURL%>A/A12Family/nc.jsp";
               var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no, width= 640, height= 530, top=0,left=20";
               //ret = window.showModalDialog(URL, window, status);
               window.open(URL,"",status);
}
//@csr 주민번호실명인증
function JuminSetting(obj,name){
  document.form1.REGNO.value = obj;
  document.form1.LNMHG.value = name.substring(0, 1);
  document.form1.FNMHG.value = name.substring(1, name.length);

  resno_chk( document.form1.REGNO);
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="scha_Check('<%=data.FASAR%>',1)" oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">
<div class="subwrapper">

  <h2 class="subtitle">가족사항수정입력</h2>

<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/PersonInfo.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

  <h2 class="subtitle">대상자</h2>
  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
        <tr>
          <th width="100"><span class="textPink">*</span>성명(한글)</th>
          <td>
            <input type="text" name="LNMHG" value="<%= data.LNMHG %>" <%=data.SUBTY.equals("2")? "":"disabled"%> size="6"  maxlength="40" style="ime-mode:active">
            <input type="text" name="FNMHG" value="<%= data.FNMHG %>" <%=data.SUBTY.equals("2")? "":"disabled"%> size="12" maxlength="40" style="ime-mode:active">
          </td>
          <th class="th02" width="100"><span class="textPink">*</span>가족유형</th>
          <td><input type="text" name="STEXT" value="<%= data.STEXT %>" size="20" readonly></td>
        </tr>
        <tr>
          <th><span class="textPink">*</span>주민등록번호</th>
          <td>
            <input type="password" name="REGNO" class="input04" size="20" <%=data.SUBTY.equals("2")? "":"disabled"%> value="<%= DataUtil.addSeparate(data.REGNO) %>" size="20" maxlength="14" onBlur="javascript:resno_chk(this);"></td>
          </td>
          <th class="th02"><span class="textPink">*</span>관계</th>
          <td>
            <select name="KDSVH">
              <option value="">---------------</option>
              <%= WebUtil.printOption((new A12FamilyRelationRFC()).getFamilyRelation(""), data.KDSVH) %>
            </select>
          </td>
        </tr>
        <tr>
          <th>생년월일</th>
          <td>
            <input type="text" name="FGBDT" value="<%= data.FGBDT.equals("0000-00-00") ? "" : WebUtil.printDate(data.FGBDT) %>" size="20" readonly>
            <!--<a href="javascript:fn_openCal('FGBDT')">
              <img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0" alt="날짜검색"></a>-->
          </td>
          <th class="th02">성 별</th>
          <td>
            <input type="radio" name="FASEX1" value="1" <%= data.FASEX.equals("1") ? "checked" : "" %> disabled>
            남
            <input type="radio" name="FASEX2" value="2" <%= data.FASEX.equals("2") ? "checked" : "" %> disabled>
            여
          </td>
        </tr>
        <tr>
          <th>출생지</th>
          <td>
            <input type="text" name="FGBOT" value="<%= data.FGBOT %>" size="20" maxlength="40" style="ime-mode:active">
          </td>
          <th class="th02">학력</th>
          <td>
            <select name="FASAR" onChange="javascript:scha_Check(this,2);">
              <option value="">-------------</option>
              <%= WebUtil.printOption((new A12FamilyScholarshipRFC()).getFamilyScholarship(), data.FASAR) %>
            </select>
          </td>
        </tr>
        <tr>
          <th>출생국</th>
          <td>
            <select name="FGBLD">
              <option value="">-------------</option>
              <%= WebUtil.printOption( SortUtil.sort( (new A12FamilyNationRFC()).getFamilyNation(), "value", "asc" ), data.FGBLD) %>
            </select>
          </td>
          <th class="th02" id="scha">교육기관</th>
          <td>
            <input type="text" name="FASIN" value="<%= data.FASIN %>" size="20" maxlength="20" style="ime-mode:active">
          </td>
        </tr>
        <tr>
          <th>국 적</th>
          <td>
            <select name="FANAT">
              <option value="">-------------</option>
              <%= WebUtil.printOption( SortUtil.sort( (new A12FamilyNationRFC()).getFamilyNation(), "value", "asc" ), data.FANAT) %>
            </select>
          </td>
          <th class="th02">직 업</th>
          <td>
            <input type="text" name="FAJOB" value="<%= data.FAJOB %>" size="20" maxlength="24" style="ime-mode:active">
          </td>
        </tr>
      </table>
      <span class="commentOne"><span class="textPink">*</span>는 필수 입력사항입니다.</span>
    </div>
  </div>
  <!--상단 입력 테이블 끝-->

  <div class="buttonArea">
    <ul class="btn_crud">
      <li><a class="darken" href="javascript:do_input();"><span>저장</span></a></li>
      <li><a href="javascript:do_preview();"><span>취소</span></a></li>
    </ul>
  </div>

</div>

<!-- HIDDEN으로 처리 -->
  <input type="hidden" name="jobid"  value="">
  <input type="hidden" name="SUBTY"  value="<%= data.SUBTY %>">
  <input type="hidden" name="OBJPS"  value="<%= data.OBJPS %>">
  <input type="hidden" name="BEGDA"  value="<%= data.BEGDA %>">
  <input type="hidden" name="ENDDA"  value="<%= data.ENDDA %>">
  <input type="hidden" name="FASEX"  value="<%= data.FASEX %>">
  <input type="hidden" name="ATEXT"  value="<%= data.ATEXT %>">
  <input type="hidden" name="STEXT1" value="<%= data.STEXT1 %>">
  <input type="hidden" name="LANDX"  value="<%= data.LANDX %>">
  <input type="hidden" name="NATIO"  value="<%= data.NATIO %>">
  <input type="hidden" name="DPTID"  value="<%= data.DPTID %>">
  <input type="hidden" name="HNDID"  value="<%= data.HNDID %>">
  <input type="hidden" name="LIVID"  value="<%= data.LIVID %>">
  <input type="hidden" name="HELID"  value="<%= data.HELID %>">
  <input type="hidden" name="FAMID"  value="<%= data.FAMID %>">
  <input type="hidden" name="CHDID"  value="<%= data.CHDID %>">
<!-- HIDDEN으로 처리 -->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

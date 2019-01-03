<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 입학축하금                                                  */
/*   Program Name : 입학축하금 수정                                             */
/*   Program ID   : E21EntranceChange.jsp                                       */
/*   Description  : 입학축하금을 수정할 수 있도록 하는 화면                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.E.E21Entrance.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");

    /* 신청관련 정보를 vector로 받는다*/
    Vector a04FamilyDetailData_vt = (Vector)request.getAttribute("a04FamilyDetailData_vt");
    Vector e21EntranceDupCheck_vt = (Vector)request.getAttribute("e21EntranceDupCheck_vt");
    String msgFLAG                = (String)request.getAttribute("msgFLAG")==null ? "" :  (String)request.getAttribute("msgFLAG");
    String msgTEXT                = (String)request.getAttribute("msgTEXT")==null ? "" :  (String)request.getAttribute("msgTEXT");

    /* 자녀 레코드를 vector로 받는다*/
    Vector e21EntranceData_vt = (Vector)request.getAttribute("e21EntranceData_vt");
    E21EntranceData data = (E21EntranceData)e21EntranceData_vt.get(0);

    /* 입학축하금 입력된 결제정보를 vector로 받는다*/
    Vector AppLineData_vt = (Vector)request.getAttribute("AppLineData_vt");
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>
<html>
<head>
<title>e-HR</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function family_get(obj) {
    var p_idx = obj.selectedIndex - 1;
    if( p_idx >= 0 ) {
        eval("document.form1.FAMSA.value     = document.form1.FAMSA"    + p_idx + ".value");
        eval("document.form1.ATEXT.value     = document.form1.ATEXT"    + p_idx + ".value");
        eval("document.form1.LNMHG.value     = document.form1.LNMHG"    + p_idx + ".value");
        eval("document.form1.FNMHG.value     = document.form1.FNMHG"    + p_idx + ".value");
        eval("document.form1.REGNO.value     = document.form1.REGNO"    + p_idx + ".value");
        eval("document.form1.reg_no.value     = document.form1.REGNO"    + p_idx + ".value");
        eval("document.form1.ACAD_CARE.value = document.form1.ACAD_CARE"+ p_idx + ".value");
        eval("document.form1.STEXT.value     = document.form1.STEXT"    + p_idx + "_1.value");
        eval("document.form1.FASIN.value     = document.form1.FASIN"    + p_idx + ".value");
<%
    if( !user.empNo.equals(data.PERNR) ) {
%>
        var d_regno =  document.form1.reg_no.value;
        document.form1.reg_no.value = d_regno.substring( 0, 6 ) + "-*******";
<%
    }
%>
    } else {
        //document.form1.FAMSA.value     = "";
        //document.form1.ATEXT.value     = "";
        document.form1.LNMHG.value     = "";
        document.form1.FNMHG.value     = "";
        document.form1.reg_no.value    = "";
        document.form1.REGNO.value     = "";
        document.form1.ACAD_CARE.value = "";
        document.form1.STEXT.value     = "";
        document.form1.FASIN.value     = "";
    }
}

function do_change(){
    if( check_data() ){
        document.form1.jobid.value = "change";
        document.form1.AINF_SEQN.value = "<%= data.AINF_SEQN %>";

        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E21Entrance.E21EntranceChangeSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function check_data(){

    var PROP_YEAR_v = document.form1.PROP_YEAR.value;
    if(PROP_YEAR_v==""){
      alert("입학년도를 입력하세요");
      document.form1.PROP_YEAR.focus();
      return false;
    } else if(PROP_YEAR_v!="<%=(DataUtil.getCurrentDate()).substring(0,4)%>") {
      alert("입학 당해년도만 신청가능합니다");
      document.form1.PROP_YEAR.focus();
      return false;
    } else if("0531"<"<%=(DataUtil.getCurrentDate()).substring(4,8)%>"||"0310">"<%=(DataUtil.getCurrentDate()).substring(4,8)%>") {
      alert("3월1일부터 5월31일까지 3개월간만 신청가능합니다");
      document.form1.PROP_YEAR.focus();
      return false;
    }

    if(document.form1.LFname.selectedIndex==0){
        alert("자녀 이름을 선택하세요");
        document.form1.LFname.focus();
        return false;
    }
    if( document.form1.ACAD_CARE.value == "B1" || document.form1.ACAD_CARE.value == "C1" ) {
<%
    for( int i = 0 ; i < e21EntranceDupCheck_vt.size() ; i++ ) {
        E21EntranceDupCheckData c_Data = (E21EntranceDupCheckData)e21EntranceDupCheck_vt.get(i);
%>
      if( ("<%= c_Data.SUBF_TYPE %>" == "1")                            &&
          ("<%= c_Data.ACAD_CARE %>" == document.form1.ACAD_CARE.value) &&
          ("<%= c_Data.REGNO     %>" == removeResBar(document.form1.REGNO.value)) ) {
<%
        if( c_Data.INFO_FLAG.equals("I") ) {
%>
        alert("입학축하금은 1회에 한합니다.");
        return false;
<%
        } else if( c_Data.INFO_FLAG.equals("T") && !c_Data.AINF_SEQN.equals(data.AINF_SEQN) ) {
%>
        alert("현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
        return false;
<%
        }
%>
      }
<%
    }
%>
    } else {
        alert("자녀의 학력이 유치원, 초등학교일 경우에만 신청가능합니다.");
        return false;
    }


    if ( check_empNo() ){
        return false;
    }


    //default값 setting..
    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);

    return true;
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>입학축하금 신청 수정</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>
<%
    if ( !msgFLAG.equals("") ) { // 에러메시지 보여줌
%>

    <div class="align_center">
        <p><%= msgTEXT %></p>
    </div>

<%
    } else {
%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일자</th>
                    <td><input type="text" name="BEGDA" value="<%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>" size="14" readonly></td>
                    <th class="th02">입학년도</th>
                    <td><input type="text" name="PROP_YEAR" size="4" maxlength="4" onKeyUp="if(!onlyNumber(document.form1.PROP_YEAR,'입학년도')){this.value='';this.focus();this.select()};" value="<%=data.PROP_YEAR%>">년</td>
                    <input type="hidden" name="FAMSA" value="<%= data.FAMSA %>" size="5" class="input04" readonly>
                    <input type="hidden" name="ATEXT" value="<%= data.ATEXT %>" size="10" class="input04" readonly>
                </tr>
                <tr>
                    <th><span class="textPink">*</span>이름</th>
                    <td>
                        <select name="LFname" onChange="javascript:family_get(this);">
                            <option value="">------------</option>
<%
    for(int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++){
        A04FamilyDetailData data_name = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);
%>
                            <option value="<%= data_name.LNMHG %>" <%= data_name.FNMHG.equals( data.FNMHG ) ? "selected" : "" %>><%= data_name.LNMHG %><%= data_name.FNMHG %></option>
<%
    }
%>
                        </select>
                    </td>
                      <%
                        String reg_no = "";
                        if( !user.empNo.equals(data.PERNR) ) {
                            reg_no = data.REGNO.substring( 0, 6 ) + "*******";
                        } else {
                            reg_no = data.REGNO;
                        }
                       %>
                    <th class="th02">주민등록번호</th>
                    <td>
                        <input type="text" name="reg_no"  value="<%= DataUtil.addSeparate(reg_no) %>" size="18" readonly>
                        <input type="hidden" name="REGNO" value="<%= DataUtil.addSeparate(data.REGNO) %>" >
                    </td>
                </tr>
                <tr>
                    <th>학력</th>
                    <td>
                        <input type="text" name="ACAD_CARE" value="<%= data.ACAD_CARE %>" size="5" readonly>
                        <input type="text" name="STEXT" value="<%= data.STEXT %>" size="20" readonly>
                    </td>
                    <th class="th02">교육기관</th>
                    <td><input type="text" name="FASIN" value="<%= data.FASIN %>" size="40" readonly></td>
                </tr>
                <tr>
                          <td class="td09" colspan="4"> &nbsp;※  </td>
                </tr>
            </table>
            <div class="commentsMoreThan2">
                <div>자녀의 학력사항이 등재되어 있지 않은 경우 신청이 되지 않으므로 자녀 이름 선택시 학력사항이 보이지 않는 경우에는 가족사항 조회에서 자녀를 선택한 후 학력사항을 변경하고 다시 신청하시기 바랍니다.</div>
                <div><span class="textPink">*</span> 는 필수 입력사항입니다.</div>
            </div>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <!-- 결재자 입력 테이블 시작-->
    <%= hris.common.util.AppUtil.getAppChange(AppLineData_vt,data.PERNR) %>
    <!-- 결재자 입력 테이블 시작-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:do_change();"><span>저장</span></a></li>
            <li><a href="javascript:history.back();"><span>취소</span></a></li>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 시작          -->
    <input type="hidden" name="LNMHG"       value="<%= data.LNMHG %>">
    <input type="hidden" name="FNMHG"       value="<%= data.FNMHG %>">
    <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
<%
    for(int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++){
        A04FamilyDetailData a04FamilyDetaildata = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);
%>
    <input type="hidden" name="FAMSA<%= i %>"     value="<%= a04FamilyDetaildata.SUBTY  %>">
    <input type="hidden" name="ATEXT<%= i %>"     value="<%= a04FamilyDetaildata.STEXT  %>">
    <input type="hidden" name="LNMHG<%= i %>"     value="<%= a04FamilyDetaildata.LNMHG  %>">
    <input type="hidden" name="FNMHG<%= i %>"     value="<%= a04FamilyDetaildata.FNMHG  %>">
    <input type="hidden" name="REGNO<%= i %>"     value="<%= DataUtil.addSeparate(a04FamilyDetaildata.REGNO) %>">
    <input type="hidden" name="ACAD_CARE<%= i %>" value="<%= a04FamilyDetaildata.FASAR  %>">
    <input type="hidden" name="STEXT<%= i %>_1"   value="<%= a04FamilyDetaildata.STEXT1 %>">
    <input type="hidden" name="FASIN<%= i %>"     value="<%= a04FamilyDetaildata.FASIN  %>">
<%
    }
%>
<%
    } // end if  // 에러메시지 보여줌
%>
<!--  HIDDEN  처리해야할 부분 끝             -->
    <input type="hidden" name="jobid"       value="">
    <input type="hidden" name="AINF_SEQN"   value="">
  </div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

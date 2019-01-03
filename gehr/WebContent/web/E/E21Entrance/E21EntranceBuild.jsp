<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 입학축하금                                                  */
/*   Program Name : 입학축하금 신청                                             */
/*   Program ID   : E21EntranceBuild.jsp                                        */
/*   Description  : 입학축하금을 신청할 수 있도록 하는 화면                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*                  2005-12-13  lsa @v1.1 C2005121301000000397 ,C2005122101000000147 */
/*                  2005-12-26  lsa @v1.2 C2005122601000000422  */
/*                  2005-12-26  lsa @v1.3 C2005122701000000485  */
/*                  2006-01-13  lsa @v1.4 기능직만 신청가능     */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.E.E21Entrance.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    /* 신청관련 정보를 vector로 받는다*/
    Vector a04FamilyDetailData_vt = (Vector)request.getAttribute("a04FamilyDetailData_vt");
    Vector e21EntranceDupCheck_vt = (Vector)request.getAttribute("e21EntranceDupCheck_vt");
    String msgFLAG                = (String)request.getAttribute("msgFLAG");
    String msgTEXT                = (String)request.getAttribute("msgTEXT");

    /* 입학축하금 입력된 결제정보를 vector로 받는다*/
    Vector AppLineData_vt       = (Vector)request.getAttribute("AppLineData_vt");

    A04FamilyDetailData tmpData = new A04FamilyDetailData();

    if ( a04FamilyDetailData_vt.size() > 0 ) {
        tmpData = (A04FamilyDetailData)a04FamilyDetailData_vt.get(0);//화면정보를 보이기 위해
    }
    String PERNR = (String)request.getAttribute("PERNR");
    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");

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
        eval("document.form1.reg_no.value    = document.form1.REGNO"    + p_idx + ".value");
        eval("document.form1.ACAD_CARE.value = document.form1.ACAD_CARE"+ p_idx + ".value");
        eval("document.form1.STEXT.value     = document.form1.STEXT"    + p_idx + "_1.value");
        eval("document.form1.FASIN.value     = document.form1.FASIN"    + p_idx + ".value");


<%
    if( !user.empNo.equals(PERNR) ) {
%>
        var d_regno =  document.form1.REGNO.value;
        document.form1.reg_no.value = d_regno.substring( 0, 6 ) + "-*******";
<%
    }
%>
    } else {
        // document.form1.FAMSA.value    = "";
        // document.form1.ATEXT.value    = "";
        document.form1.LNMHG.value     = "";
        document.form1.FNMHG.value     = "";
        document.form1.REGNO.value     = "";
        document.form1.reg_no.value    = "";
        document.form1.ACAD_CARE.value = "";
        document.form1.STEXT.value     = "";
        document.form1.FASIN.value     = "";
    }
}

function doSubmit() {
    if( check_data() ) {
        buttonDisabled();
        document.form1.jobid.value = "create";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E21Entrance.E21EntranceBuildSV";
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
  //} else if(( "<%=PERNR%>" =="00008773" || "<%=PERNR%>" =="00031571" || "<%=PERNR%>" =="00087709" || "<%=PERNR%>" =="00061506"|| "<%=PERNR%>" =="00061185"|| "<%=PERNR%>" =="00049005") && (PROP_YEAR_v =="2005") ) {
  //  var flag = true; //@v1.1
  //} else if(( "<%=PERNR%>" =="00060696" || "<%=PERNR%>" =="00062615" || "<%=PERNR%>" =="00083197" || "<%=PERNR%>" =="00060330") ) {
  //  var flag = true; //@v1.2
  } else if( ("<%=PERNR%>" =="00059234" )  && (PROP_YEAR_v =="2006") ) {
    var flag = true; //@v1.3
  } else if( (document.form1.ACAD_CARE.value != "B1") && ( "1231"<"<%=(DataUtil.getCurrentDate()).substring(4,8)%>"||"0301">"<%=(DataUtil.getCurrentDate()).substring(4,8)%>" )) {
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
<%
        } else if( c_Data.INFO_FLAG.equals("T") ) {
%>
        alert("현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.");
<%
        }
%>
        return false;
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

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.E.E21Entrance.E21EntranceBuildSV";
    frm.target = "";
    frm.submit();
}

//-->
</script>
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>입학축하금 신청</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>
<%
    if ( PERNR_Data.E_WERKS.equals("EC00") ) {  // 2005.04.13 수정 - 해외법인(EC00)일 경우는 본인신청, 대리신청 못하도록 함.
%>

    <div class="align_center">
        <p>해외법인의 경우 해당 인사부서를 통해 신청하시기 바랍니다.</p>
    </div>

<%
    } else {
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
<%           //@v1.4 기능직만 입학축하금사용 가능 , [CSR ID:2583929] 생산기술직 38 추가
             if ((PERNR_Data.E_PERSK.equals("33") || PERNR_Data.E_PERSK.equals("38")) && Integer.parseInt(DataUtil.getCurrentDate()) <= 20060630) {
%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>신청일자</th>
                    <td><input type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" size="14" readonly></td>
                    <th class="th02">입학년도</th>
                    <td><input type="text" name="PROP_YEAR" size="4" maxlength="4" onKeyUp="if(!onlyNumber(document.form1.PROP_YEAR,'입학년도')){this.value='';this.focus();this.select()};">년</td>
                    <input type="hidden" name="FAMSA" size="5" class="input04" value="<%= tmpData.SUBTY %>" readonly>
                    <input type="hidden" name="ATEXT" size="10" class="input04" value="<%= tmpData.STEXT %>" readonly>
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
                            <option value="<%= data_name.LNMHG %>"><%= data_name.LNMHG %><%= data_name.FNMHG %></option>
<%
            }
%>
                        </select>
                    </td>

                      <%
                        String reg_no = "";
                        if( !user.empNo.equals(PERNR) ) {
                            reg_no = tmpData.REGNO.substring( 0, 6 ) + "*******";
                        } else {
                            reg_no = tmpData.REGNO;
                        }
                       %>
                    <th class="th02">주민등록번호</th>
                    <td>
                        <input type="text" name="reg_no" value="" size="18" readonly>
                        <input type="hidden" name="REGNO" value="">
                    </td>
                </tr>
                <tr>
                    <th>학력</th>
                    <td>
                        <input type="text" name="ACAD_CARE" size="5" readonly>
                        <input type="text" name="STEXT" size="20" readonly>
                    </td>
                    <th class="th02">교육기관</th>
                    <td>
                        <input type="text" name="FASIN" size="40" readonly>
                    </td>
                </tr>
                <tr>
                    <td class="td09" colspan="4"> &nbsp;※ </td>
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
    <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,PERNR) %>
    <!-- 결재자 입력 테이블 End-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a href="javascript:doSubmit();"><span>신청</span></a></li>
        </ul>
    </div>

    <!--  HIDDEN  처리해야할 부분 시작-->
<%
            for(int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++){
                A04FamilyDetailData data = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);
%>
    <input type="hidden" name="FAMSA<%= i %>"     value="<%= data.SUBTY  %>">
    <input type="hidden" name="ATEXT<%= i %>"     value="<%= data.STEXT  %>">
    <input type="hidden" name="LNMHG<%= i %>"     value="<%= data.LNMHG  %>">
    <input type="hidden" name="FNMHG<%= i %>"     value="<%= data.FNMHG  %>">
    <input type="hidden" name="REGNO<%= i %>"     value="<%= DataUtil.addSeparate(data.REGNO) %>">
    <input type="hidden" name="ACAD_CARE<%= i %>" value="<%= data.FASAR  %>">
    <input type="hidden" name="STEXT<%= i %>_1"   value="<%= data.STEXT1 %>">
    <input type="hidden" name="FASIN<%= i %>"     value="<%= data.FASIN  %>">
<%
            }
%>
<%        //@v1.4 기능직만 입학축하금사용 가능 end
          }
          else {
%>

    <div class="align_center">
        <p>선택적복리후생 제도 도입으로 인해 입학축하금 제도는 폐지되어 사용 중지합니다.</p>
    </div>

<%
          } //@v1.4 기능직만 입학축하금사용 가능 end
%>
<%
        } // end if  // 에러메시지 보여줌
%>
<%
    }  // end if 2005.04.13 수정 - 해외법인(EC00)일 경우는 본인신청, 대리신청 못하도록 함.
%>
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="LNMHG" value="">
    <input type="hidden" name="FNMHG" value="">
    <!--  HIDDEN  처리해야할 부분 끝-->

</div>

</form>
<%@ include file="/web/common/commonEnd.jsp" %>


<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항 추가입력                                           */
/*   Program Name : 가족수당 신청                                               */
/*   Program ID   : A12AllowanceBuild.jsp                                       */
/*   Description  : 가족수당을 신청할 수 있도록 하는 화면                       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A12Family.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    // 신청할 가족 데이터
    Vector            a12FamilyListData_vt = (Vector)request.getAttribute("a12FamilyListData_vt");
    A12FamilyListData data_list            = (A12FamilyListData)a12FamilyListData_vt.get(0);

    /* 결제정보를 vector로 받는다*/
    Vector            AppLineData_vt       = (Vector)request.getAttribute("AppLineData_vt");

    String PERNR = (String)request.getAttribute("PERNR");
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function doSubmit() {
  if( check_data() ) {
    buttonDisabled();
    document.form1.jobid.value = "create";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12AllowanceBuildSV";
    document.form1.method = "post";
    document.form1.submit();
  }
}

function check_data(){
  // 신청관련 단위 모듈에서 필히 넣어야?l 항목...
  if ( check_empNo() ){
    return false;
  }
  // 신청관련 단위 모듈에서 필히 넣어야?l 항목...

  return true;
}

function do_preview(){
  document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A04FamilyDetailSV";
  document.form1.method = "post";
  document.form1.submit();
}

function do_preview_1(){
  document.form1.jobid.value = "first";
  document.form1.SUBTY.value = "<%= data_list.SUBTY %>";
  document.form1.OBJPS.value = "<%= data_list.OBJPS %>";

  document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12FamilyBuild01SV";
  document.form1.method = "post";
  document.form1.submit();
}

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">
  <input type="hidden" name = "PERNR" value="<%=PERNR%>">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="780"> <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td height="5" colspan="2"></td>
                </tr>
                <tr> 
                 <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">가족수당 신청</td>
                  <td class="titleRight"></td>
              </table></td>
          </tr>
          <tr> 
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/PersonInfo.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
<%
    }
%>
        <tr> 
            <td> 
              <!-- 상단 입력 테이블 시작-->
              <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    대상자</td>
                </tr>
                <tr> 
                  <td class="font01"> <table width="630" border="0" cellspacing="1" cellpadding="3" class="table02">
                      <tr> 
                        <td class="td01" width="90">성명(한글)</td>
                        <td class="td09" width="222"> <input type="text" name="name" value="<%= data_list.LNMHG %> <%= data_list.FNMHG %>" class="input04" readonly> 
                        </td>
                        <td class="td01" width="80">가족유형</td>
                        <td class="td09" width="221"> <input type="text" name="STEXT"  value="<%= data_list.STEXT %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                      <%
                        String reg_no = "";
                        if( !user.empNo.equals(PERNR) ) {
                            reg_no = data_list.REGNO.substring( 0, 6 ) + "*******";
                        } else {
                            reg_no = data_list.REGNO;
                        }
                       %>                      
                      <tr> 
                        <td class="td01">주민등록번호</td>
                        <td class="td09" width="222"> <input type="text" name="regno"  value="<%= DataUtil.addSeparate(reg_no) %>" class="input04" size="20" readonly> 
                        </td>
                        <td width="80" class="td01">관 계</td>
                        <td class="td09" width="221"> <input type="text" name="atext"  value="<%= data_list.ATEXT %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">생년월일</td>
                        <td class="td09"> <input type="text" name="year"  value="<%= data_list.FGBDT.substring(0, 4) %>" class="input04" size="4" readonly>
                          년 
                          <input type="text" name="month" value="<%= data_list.FGBDT.substring(5, 7) %>" class="input04" size="2" readonly>
                          월 
                          <input type="text" name="day"   value="<%= data_list.FGBDT.substring(8, 10) %>" class="input04" size="2" readonly>
                          일 </td>
                        <td class="td01">성 별</td>
                        <td class="td09"> <input type="radio" name="fasex" value="1" <%= data_list.FASEX.equals("1") ? "checked" : "" %> disabled>
                          남 
                          <input type="radio" name="fasex" value="2" <%= data_list.FASEX.equals("2") ? "checked" : "" %> disabled>
                          여 </td>
                      </tr>
                      <tr> 
                        <td class="td01">출생지</td>
                        <td class="td09"> <input type="text" name="fgbot" value="<%= data_list.FGBOT %>" class="input04" size="20" readonly> 
                        </td>
                        <td class="td01">학 력</td>
                        <td class="td09"> <input type="text" name="stext1"  value="<%= data_list.STEXT1 %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">출생국</td>
                        <td class="td09"> <input type="text" name="landx"  value="<%= data_list.LANDX %>" class="input04" size="20" readonly> 
                        </td>
                        <td class="td01">교육기관</td>
                        <td class="td09"> <input type="text" name="fasin"  value="<%= data_list.FASIN %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">국 적</td>
                        <td class="td09"> <input type="text" name="natio"  value="<%= data_list.NATIO %>" class="input04" size="20" readonly> 
                        </td>
                        <td class="td01">직 업</td>
                        <td class="td09"> <input type="text" name="FAJOB"  value="<%= data_list.FAJOB %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!--상단 입력 테이블 끝-->
            </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    결재정보</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td> 
              <!-- 결재자 입력 테이블 시작-->
              <%= hris.common.util.AppUtil.getAppBuild(AppLineData_vt,PERNR) %> 
              <!-- 결재자 입력 테이블 시작-->
            </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td> <table width="750" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td align="center">
                    <span id="sc_button"><a href="javascript:doSubmit();"><img src="<%= WebUtil.ImageURL %>btn_build.gif" align="absmiddle" border="0"></a></span>
                    <%
/*  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분   */
    String ThisJspName = (String)request.getAttribute("ThisJspName");
    Logger.debug.println(this, "ThisJspName : "+ ThisJspName);
    if ( ThisJspName.equals("A04FamilyDetail.jsp")  ) {

%> <a href="javascript:do_preview();"> <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" align="absmiddle" border="0"></a> 
                    <%
    }
%> <%
    if ( ThisJspName.equals("A12FamilyBuild01.jsp")  ) {

%> <a href="javascript:do_preview_1();"> <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" align="absmiddle" border="0"></a> 
                    <%
    }
/*  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분   */
%> </td>
                </tr>
              </table></td>
          </tr>
        </table>
      </td>  
    </tr>    
</table>     
      
<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="jobid" value="">
      <input type="hidden" name="GUBUN" value=" ">    <!-- 구분 'X':부양가족, ' ':가족수당 -->
      <input type="hidden" name="BEGDA" value="<%= DataUtil.getCurrentDate() %>">
      <input type="hidden" name="SUBTY" value="<%= data_list.SUBTY %>">
      <input type="hidden" name="OBJPS" value="<%= data_list.OBJPS %>">
      <input type="hidden" name="LNMHG" value="<%= data_list.LNMHG %>">
      <input type="hidden" name="FNMHG" value="<%= data_list.FNMHG %>">
      <input type="hidden" name="REGNO" value="<%= data_list.REGNO %>">
      <input type="hidden"   name="FAMID" value="X">
      <input type="hidden" name="ThisJspName" value="<%= ThisJspName %>">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>


<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항 추가입력                                           */
/*   Program Name : 가족사항 추가입력                                           */
/*   Program ID   : A12FamilyBuild01.jsp                                        */
/*   Description  : 가족사항 신청을 조회할 수 있도록 하는 화면                  */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  김도신                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A12Family.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    
    // 입력된 가족사항 정보 조회..
    Vector            a12FamilyListData_vt = (Vector)request.getAttribute("a12FamilyListData_vt");
    A12FamilyListData data                 = (A12FamilyListData)a12FamilyListData_vt.get(0);
    
    String PERNR = (String)request.getAttribute("PERNR");
    String SCREEN = (String)request.getAttribute("SCREEN");
    PersonData PERNR_Data = (PersonData)request.getAttribute("personData2");
    // 2015- 06-08 개인정보 통합시 subView ="Y";
    String subView = WebUtil.nvl(request.getParameter("subView"));
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function do_support() {         // 부양가족
  document.form1.jobid.value = "first";
  document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12SupportBuildSV";
  document.form1.method = "post";
  document.form1.submit();
}

function do_allowance() {       // 가족수당
  age_value = getAge(document.form1.REGNO.value);
  
  if( document.form1.SUBTY.value == "1" || 
              ( document.form1.SUBTY.value == "2" && age_value <= 19 ) ) {    // 배우자, 자녀의 경우만 신청가능..
    document.form1.jobid.value = "first";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A12Family.A12AllowanceBuildSV";
    document.form1.method = "post";
    document.form1.submit();
  } else {
    alert("가족수당은 배우자, 자녀(만 20세 미만)의 경우만 신청가능합니다.");
  }
}

function do_medical() {
  document.form1.jobid.value = "first";
  document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E01Medicare.E01MedicareBuildSV";
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
<%if(subView.equals("Y")){ %>                   
                <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">가족사항추가입력확인</td>
                  <td class="titleRight"></td>
                </tr>
<%}else{ %>                
				<tr>
                  <td height="10" colspan="2"></td>
                </tr>     
                <tr>
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">가족사항추가입력확인</td>
                  <td class="titleRight"></td>
                </tr>

<%} %>
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
                        <td class="td09" width="222"> <input type="text" name="LNMHG" value="<%= data.LNMHG %> <%= data.FNMHG %>" class="input04" size="20" readonly> 
                        </td>
                        <td class="td01" width="80">가족유형</td>
                        <td class="td09" width="221"> <input type="text" name="STEXT"  value="<%= data.STEXT %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">주민등록번호</td>
                        <td class="td09" width="222"> <input type="text" name="REGNO"  value="<%= DataUtil.addSeparate(data.REGNO) %>" class="input04" size="20" readonly> 
                        </td>
                        <td width="80" class="td01">관 계</td>
                        <td class="td09" width="221"> <input type="text" name="ATEXT"  value="<%= data.ATEXT %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">생년월일</td>
                        <td class="td09"> <input type="text" name="year"  value="<%= data.FGBDT.substring(0, 4) %>" class="input04" size="4" readonly>
                          년 
                          <input type="text" name="month" value="<%= data.FGBDT.substring(5, 7) %>" class="input04" size="2" readonly>
                          월 
                          <input type="text" name="day"   value="<%= data.FGBDT.substring(8, 10) %>" class="input04" size="2" readonly>
                          일 </td>
                        <td class="td01">성 별</td>
                        <td class="td09"> <input type="radio" name="FASEX" value="1" <%= data.FASEX.equals("1") ? "checked" : "" %> disabled>
                          남 
                          <input type="radio" name="FASEX" value="2" <%= data.FASEX.equals("2") ? "checked" : "" %> disabled>
                          여 </td>
                      </tr>
                      <tr> 
                        <td class="td01">출생지</td>
                        <td class="td09"> <input type="text" name="FGBOT" value="<%= data.FGBOT %>" class="input04" size="20" readonly> 
                        </td>
                        <td class="td01">학 력</td>
                        <td class="td09"> <input type="text" name="STEXT1"  value="<%= data.STEXT1 %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">출생국</td>
                        <td class="td09"> <input type="text" name="LANDX"  value="<%= data.LANDX %>" class="input04" size="20" readonly> 
                        </td>
                        <td class="td01">교육기관</td>
                        <td class="td09"> <input type="text" name="FASIN"  value="<%= data.FASIN %>" class="input04" size="20" readonly> 
                        </td>
                      </tr>
                      <tr> 
                        <td class="td01">국 적</td>
                        <td class="td09"> <input type="text" name="NATIO"  value="<%= data.NATIO %>" class="input04" size="20" readonly> 
                        </td>
                        <td class="td01">직 업</td>
                        <td class="td09"> <input type="text" name="FAJOB"  value="<%= data.FAJOB %>" class="input04" size="20" readonly> 
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
<%  if (!SCREEN.equals("E19")){    %>            
                  <td align="center"> <a href="javascript:do_support();"> <img src="<%= WebUtil.ImageURL %>btn_support.gif" border="0" align="absmiddle"></a> 
                    <%
    // LG화학이면서 급여유형이 01,02,06,07,""이 아닌경우만 가족수당 신청 가능
    // 석유화학 가족수당 신청불가(C2004011901000000429) 및 가족수당상실 신청불가(C2004012001000000484)
    if(PERNR_Data.E_BUKRS.equals("C100") && !(PERNR_Data.E_TRFAR.equals("01") || PERNR_Data.E_TRFAR.equals("02") || 
                                            PERNR_Data.E_TRFAR.equals("06") || PERNR_Data.E_TRFAR.equals("07") ||
                                            PERNR_Data.E_TRFAR.equals(""))) {
%> <!--a href="javascript:do_allowance();"> <img src="<%= WebUtil.ImageURL %>btn_allowance.gif" border="0" align="absmiddle"></a--> 
                    <%
    }
%> 
              <a href="javascript:do_medical();">
                <img src="<%= WebUtil.ImageURL %>btn_Medical.gif" border="0" align="absmiddle"></a> 
                  </td>
<% }%>                  
                </tr>
              </table></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
<!--  HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="jobid"       value="">
      <input type="hidden" name="SUBTY"       value="<%= data.SUBTY %>">
      <input type="hidden" name="OBJPS"       value="<%= data.OBJPS %>">
      <input type="hidden" name="ThisJspName" value="A12FamilyBuild01.jsp">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>


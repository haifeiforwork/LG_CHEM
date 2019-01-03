<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항                                                    */
/*   Program Name : 가족사항 조회                                               */
/*   Program ID   : A04FamilyDetail_m.jsp                                         */
/*   Description  : 가족사항 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-03-02  윤정현                                          */
/*                  2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청                                                             */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);

    // 가족사항 조회..
    Vector      a04FamilyDetailData_vt = (Vector)request.getAttribute("a04FamilyDetailData_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess1.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function Detail_Show(p_idx){
    // 선택된 row의 상세정보를 상세정보란에 설정해준다.
    eval("document.form1.SUBTY.value  = document.form1.SUBTY" + p_idx + ".value");
    eval("document.form1.STEXT.value  = document.form1.STEXT" + p_idx + ".value");
    eval("document.form1.OBJPS.value  = document.form1.OBJPS" + p_idx + ".value");
    eval("document.form1.name.value  = document.form1.name" + p_idx + ".value");
    eval("document.form1.LNMHG.value  = document.form1.LNMHG" + p_idx + ".value");
    eval("document.form1.FNMHG.value  = document.form1.FNMHG" + p_idx + ".value");
    eval("document.form1.REGNO.value  = document.form1.REGNO" + p_idx + ".value");
    eval("document.form1.FGBDT.value  = document.form1.FGBDT" + p_idx + ".value");
    eval("document.form1.BDay.value   = document.form1.BDay"  + p_idx + ".value");
    eval("document.form1.STEXTA.value = document.form1.STEXTA"+ p_idx + ".value");
    eval("document.form1.FASIN.value  = document.form1.FASIN" + p_idx + ".value");
    eval("document.form1.FAJOB.value  = document.form1.FAJOB" + p_idx + ".value");
    eval("document.form1.KDSVH.value  = document.form1.KDSVH" + p_idx + ".value");
    eval("document.form1.ATEXT.value  = document.form1.ATEXT" + p_idx + ".value");

    // 성별 radio 버튼 처리..
    fasex = eval("document.form1.FASEX"+ p_idx + ".value");
    for( i = 0; i < document.form1.FASEX.length; i++ ) {
        if( fasex == eval("document.form1.FASEX["+i+"].value") ) {
            eval("document.form1.FASEX["+i+"].checked = true");
        } else {
            eval("document.form1.FASEX["+i+"].checked = false");
        }
    }
    eval("document.form1.FGBOT.value = document.form1.FGBOT"+ p_idx + ".value");
    eval("document.form1.LANDX.value = document.form1.LANDX"+ p_idx + ".value");
    eval("document.form1.NATIO.value = document.form1.NATIO"+ p_idx + ".value");

    // check 버튼 처리(종속성)..
    dptid = eval("document.form1.DPTID"+ p_idx + ".value");
    if( dptid == "X" ) {
        document.form1.DPTID.checked = true;
    } else {
        document.form1.DPTID.checked = false;
    }
    hndid = eval("document.form1.HNDID"+ p_idx + ".value");
    if( hndid == "X" ) {
        document.form1.HNDID.checked = true;
    } else {
        document.form1.HNDID.checked = false;
    }
    livid = eval("document.form1.LIVID"+ p_idx + ".value");
    if( livid == "X" ) {
        document.form1.LIVID.checked = true;
    } else {
        document.form1.LIVID.checked = false;
    }
    helid = eval("document.form1.HELID"+ p_idx + ".value");
    if( helid == "X" ) {
        document.form1.HELID.checked = true;
    } else {
        document.form1.HELID.checked = false;
    }
    famid = eval("document.form1.FAMID"+ p_idx + ".value");
    if( famid == "X" ) {
        document.form1.FAMID.checked = true;
    } else {
        document.form1.FAMID.checked = false;
    }
    /*  [CSR ID:2654794] 부양가족 신청화면 변경요청
    chdid = eval("document.form1.CHDID"+ p_idx + ".value");
    if( chdid == "X" ) {
        document.form1.CHDID.checked = true;
    } else {
        document.form1.CHDID.checked = false;
    }
    */

    // 자녀일 경우만 자녀양육을 보여준다.
    var val = document.form1.SUBTY.value;     // 가족유형..
    MM_showHideLayers('document.layers[\'layer1\']','document.all[\'layer1\']',val);
}

//MM_showHideLayers('document.layers[\'layer1\']','document.all[\'layer1\']',value)
function MM_showHideLayers() { //v2.0
  var i, visStr, args, theObj;
  args = MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) { //with arg triples (objNS,objIE,visStr)
    visStr   = args[i+2];
    if (navigator.appName == 'Netscape' && document.layers != null)
   {
      theObj = eval(args[i]);
      if (theObj) theObj.visibility = visStr;
   } else if (document.all != null) { //IE
      if (visStr == '2') { visStr = 'visible'; } // 자녀일 경우만..
      else { visStr = 'hidden'; }
      theObj = eval(args[i+1]);
      if (theObj) theObj.style.visibility = visStr;
   }
  }
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="36">
      <td width="15">&nbsp;</td>
      <td class="td02">

        <font color="#0000FF"><%= "▶ " + g.getMessage("LABEL.A.A04.0011", user_m.ename + " " + user_m.e_titel) + ( user_m.i_stat2.equals("0") ? " (" + g.getMessage("LABEL.SEARCH.POP.0002") + ")" : "" ) %></font>
        <%-- <font color="#0000FF"><%= "▶ " + user_m.ename + " " + user_m.e_titel + "의 HR정보입니다." + ( user_m.i_stat2.equals("0") ? " (퇴직자)" : "" ) %></font> --%>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="title01"><spring:message code='LABEL.A.A04.0012' /><!-- 가족사항 조회 --></td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--가족사항 리스트 테이블 시작-->
        <table width="656" border="0" cellspacing="1" cellpadding="4" class="table02">
        <tr>
          <td class="td03" width="30"><spring:message code='LABEL.A.A12.0034' /><!-- 선 택 --></td>
          <td class="td03" width="60"><spring:message code='LABEL.A.A12.0035' /><!-- 가족유형 --></td>
          <td class="td03" width="90"><spring:message code='LABEL.A.A12.0036' /><!-- 성 명 --></td>
          <td class="td03" width="150"><spring:message code='LABEL.A.A12.0037' /><!-- 주민등록번호 --></td>
          <td class="td03" width="200"><spring:message code='LABEL.A.A12.0038' /><!-- 학력 / 교육기관 --></td>
          <td class="td03" width="100"><spring:message code='LABEL.A.A12.0039' /><!-- 직업 --></td>
        </tr>
<%
    if( a04FamilyDetailData_vt.size() > 0 ) {
        for ( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
            A04FamilyDetailData data = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);
%>

        <input type="hidden" name="SUBTY<%= i %>"  value="<%= data.SUBTY %>">
        <input type="hidden" name="STEXT<%= i %>"  value="<%= data.STEXT %>">
        <input type="hidden" name="OBJPS<%= i %>"  value="<%= data.OBJPS %>">
        <input type="hidden" name="name<%= i %>"  value="<%= data.LNMHG %> <%= data.FNMHG %>">
        <input type="hidden" name="LNMHG<%= i %>"  value="<%= data.LNMHG %>">
        <input type="hidden" name="FNMHG<%= i %>"  value="<%= data.FNMHG %>">
        <input type="hidden" name="REGNO<%= i %>"  value="<%= data.REGNO.substring(0, 6) + "-*******" %>">
        <input type="hidden" name="BDay<%= i %>"   value="<%= data.FGBDT.substring(0, 4) + " 년 " + data.FGBDT.substring(5, 7) + " 월 " + data.FGBDT.substring(8, 10) + " 일" %>">
        <input type="hidden" name="FGBDT<%= i %>"  value="<%= data.FGBDT %>">
        <input type="hidden" name="STEXTA<%= i %>" value="<%= data.STEXT1 %>">
        <input type="hidden" name="FASIN<%= i %>"  value="<%= data.FASIN %>">
        <input type="hidden" name="FAJOB<%= i %>"  value="<%= data.FAJOB %>">
        <input type="hidden" name="KDSVH<%= i %>"  value="<%= data.KDSVH %>">
        <input type="hidden" name="ATEXT<%= i %>"  value="<%= data.ATEXT %>">
        <input type="hidden" name="FASEX<%= i %>"  value="<%= data.FASEX %>">
        <input type="hidden" name="FGBOT<%= i %>"  value="<%= data.FGBOT %>">
        <input type="hidden" name="LANDX<%= i %>"  value="<%= data.LANDX %>">
        <input type="hidden" name="NATIO<%= i %>"  value="<%= data.NATIO %>">
        <input type="hidden" name="DPTID<%= i %>"  value="<%= data.DPTID %>">
        <input type="hidden" name="HNDID<%= i %>"  value="<%= data.HNDID %>">
        <input type="hidden" name="LIVID<%= i %>"  value="<%= data.LIVID %>">
        <input type="hidden" name="HELID<%= i %>"  value="<%= data.HELID %>">
        <input type="hidden" name="FAMID<%= i %>"  value="<%= data.FAMID %>">
        <input type="hidden" name="CHDID<%= i %>"  value="<%= data.CHDID %>">

        <tr>
          <td class="td04">
            <input type="radio" name="radiobutton" value="radiobutton" <%= i == 0 ? "checked" : "" %> onclick="javascript:Detail_Show(<%= i %>)">
          </td>
          <td class="td04"><%= data.STEXT %>                      </td>
          <td class="td04"><%= data.LNMHG %> <%= data.FNMHG %>    </td>
          <td class="td04"><%= data.REGNO.substring(0, 6) + "-*******" %></td>
          <td class="td04"><%= data.STEXT1 %><%= data.FASIN.equals("") ? "" : " / " + data.FASIN %> </td>
          <td class="td04"><%= data.FAJOB %>                      </td>
        </tr>

<%
        }
%>

        </table>
        <!--가족사항 리스트 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp; </td>
      <td>
    <!--가족 상세 사항 테이블시작 -->
<%
//      가족사항 상세 정보에 보여질 default data(첫번째 data(0))를 설정한다.
        A04FamilyDetailData temp = (A04FamilyDetailData)a04FamilyDetailData_vt.get(0);
%>
        <table width="656" border="0" cellspacing="1" cellpadding="0" class="table01">
        <tr>
          <td class="tr01">
            <table width="630" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr>
              <td class="font01"><font color="#7897FC">■</font><spring:message code='MSG.A.A04.0001' /><!-- 가족사항 --></td>
            </tr>
            <tr>
              <td class="font01">
                <table width="630" border="0" cellspacing="1" cellpadding="3" class="table02">
                <tr>
                  <td class="td01" width="90"><spring:message code='LABEL.A.A12.0001' /><!-- 성명(한글) --></td>
                  <td class="td02" width="227">
                    <input type="text" name="name" size="20" class="input03" value="<%= temp.LNMHG %> <%= temp.FNMHG %>" style="border-width:0" readonly>
                  </td>
                  <td class="td01" width="80"><spring:message code='LABEL.A.A12.0002' /><!-- 가족유형 --></td>
                  <td class="td02" width="226">
                    <input type="text" name="STEXT" size="10" class="input03" value="<%= temp.STEXT %>" style="border-width:0" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code='LABEL.A.A12.0003' /><!-- 주민등록번호 --></td>
                  <td class="td02" width="227">
                    <input type="text" name="REGNO" size="18" class="input03" value="<%= temp.REGNO.substring(0, 6) + "-*******" %>" style="border-width:0" readonly>
                  </td>
                  <td class="td01" width="80"><spring:message code='LABEL.A.A12.0004' /><!-- 관 계 --></td>
                  <td class="td02" width="226">
                    <input type="text" name="ATEXT" size="20" class="input03" value="<%= temp.ATEXT %>" style="border-width:0" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code='LABEL.A.A12.0005' /><!-- 생년월일 --></td>
                  <td class="td02">
                    <input type="text" name="BDay"  size="20" class="input03" value="<%= temp.FGBDT.substring(0, 4) + " 년 " + temp.FGBDT.substring(5, 7) + " 월 " + temp.FGBDT.substring(8, 10) + " 일" %>" style="border-width:0" readonly>
                  </td>
                  <td class="td01"><spring:message code='LABEL.A.A12.0006' /><!-- 성 별 --></td>
                  <td class="td02">
                    <input type="radio" name="FASEX" value="1" <%= temp.FASEX.equals("1") ? "checked" : "" %> disabled>남
                    <input type="radio" name="FASEX" value="2" <%= temp.FASEX.equals("2") ? "checked" : "" %> disabled>여
                  </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code='LABEL.A.A12.0007' /><!-- 출생지 --></td>
                  <td class="td02">
                    <input type="text" name="FGBOT" size="20" class="input03" value="<%= temp.FGBOT %>" style="border-width:0" readonly>
                  </td>
                  <td class="td01"><spring:message code='LABEL.A.A12.0013' /><!-- 학 력 --></td>
                  <td class="td02">
                    <input type="text" name="STEXTA" size="20" class="input03" value="<%= temp.STEXT1 %>" style="border-width:0" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code='LABEL.A.A12.0008' /><!-- 출생국 --></td>
                  <td class="td02">
                    <input type="text" name="LANDX" size="20" class="input03" value="<%= temp.LANDX %>" style="border-width:0" readonly>
                  </td>
                  <td class="td01"><spring:message code='LABEL.A.A12.0014' /><!-- 교육기관 --></td>
                  <td class="td02">
                    <input type="text" name="FASIN" size="20" class="input03" value="<%= temp.FASIN %>" style="border-width:0" readonly>
                  </td>
                </tr>
                <tr>
                  <td class="td01"><spring:message code='LABEL.A.A12.0009' /><!-- 국 적 --></td>
                  <td class="td02">
                    <input type="text" name="NATIO" size="20" class="input03" value="<%= temp.NATIO %>" style="border-width:0" readonly>
                  </td>
                  <td class="td01"><spring:message code='LABEL.A.A12.0010' /><!-- 직 업 --></td>
                  <td class="td02">
                    <input type="text" name="FAJOB" size="20" class="input03" value="<%= temp.FAJOB %>" style="border-width:0" readonly>
                  </td>
                </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td class="font01">&nbsp;</td>
            </tr>
            <tr>
              <td class="font01">
                <table width="630" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="315" class="font01"><font color="#7897FC">■</font>
                    <spring:message code='LABEL.A.A12.0040' />(<spring:message code='LABEL.A.A12.0026' />)<!-- 종속성(세금) -->
                  </td>
                  <td width="315" class="font01"><font color="#7897FC">■</font>
                    <spring:message code='LABEL.A.A12.0040' />(<spring:message code='LABEL.A.A12.0030' />)<!-- 종속성(기타) -->
                  </td>
                </tr>
                <tr>
                  <td valign="top">
                    <table width="305" border="0" cellspacing="1" cellpadding="0" class="table02">
                    <tr>
                      <td bgcolor="#FFFFFF">
                        <table width="303" border="1" cellspacing="1" cellpadding="3">
                        <tr>
                          <td class="td02">
                            <input type="checkbox" name="DPTID" <%= temp.DPTID.equals("X") ? "checked" : "" %> disabled>
                            <spring:message code='LABEL.A.A12.0027' /><!-- 부양가족 --></td>
                          <td class="td09"><input type="checkbox" name="BALID" <%= temp.BALID.equals("X") ? "checked" : "" %> disabled>
                            <spring:message code='LABEL.A.A12.0028' /><!-- 수급자 --></td>
                        </tr>
                        <tr>
                          <td class="td02">
                            <input type="checkbox" name="HNDID" <%= temp.HNDID.equals("X") ? "checked" : "" %> disabled>
                            <spring:message code='LABEL.A.A12.0029' /><!-- 장애인 -->
                          </td>
                        </tr>
<!-- 20141202 박난이S 요청(연말정산) [CSR ID:2654794] 부양가족 신청화면 변경요청
                        <tr>
                          <td class="td02">
                            <div id="layer1" style="position:relative; left:-5px; top:0px; visibility:<%= temp.SUBTY.equals("2") ? "show" : "hidden" %>; width:140px; height:17px; z-index:1" class="td02">
                              <input type="checkbox" name="CHDID" <%= temp.CHDID.equals("X") ? "checked" : "" %> disabled>
                              자녀양육
                            </div>
                          </td>
                        </tr>
-->
                        </table>
                      </td>
                    </tr>
                    </table>
                  </td>
                  <td valign="top">
                    <table width="314" border="0" cellspacing="1" cellpadding="0" class="table02">
                    <tr>
                      <td bgcolor="#FFFFFF">
                        <table width="315" border="0" cellspacing="1" cellpadding="3">
                        <tr>
                          <td class="td02">
                            <input type="checkbox" name="LIVID" <%= temp.LIVID.equals("X") ? "checked" : "" %> disabled>
                            <spring:message code='LABEL.A.A12.0031' /><!-- 동거여부 -->
                          </td>
                        </tr>
                        <tr>
                          <td class="td02">
                            <input type="checkbox" name="HELID" <%= temp.HELID.equals("X") ? "checked" : "" %> disabled>
                            <spring:message code='LABEL.A.A12.0032' /><!-- 건강보험 -->
                          </td>
                        </tr>
                        <tr>
                          <td class="td02">
                            <input type="checkbox" name="FAMID" <%= temp.FAMID.equals("X") ? "checked" : "" %> disabled>
                            <spring:message code='LABEL.A.A04.0013' /><!-- 가족수당 -->
                          </td>
                        </tr>
                        </table>
                      </td>
                    </tr>
                    </table>
                  </td>
                </tr>
                </table>
              </td>
            </tr>
            </table>
          </td>
        </tr>
        </table>
        <!--가족 상세 사항 테이블끝-->
      </td>
    </tr>
    </table>
<!-- HIDDEN으로 처리 -->
        <input type="hidden" name="jobid"       value="">
        <input type="hidden" name="ThisJspName" value="A04FamilyDetail_m.jsp">
        <input type="hidden" name="SUBTY"       value="<%= temp.SUBTY %>">
        <input type="hidden" name="OBJPS"       value="<%= temp.OBJPS %>">
        <input type="hidden" name="LNMHG"       value="<%= temp.LNMHG %>">
        <input type="hidden" name="FNMHG"       value="<%= temp.FNMHG %>">
        <input type="hidden" name="FGBDT"       value="<%= temp.FGBDT %>">
        <input type="hidden" name="KDSVH"       value="<%= temp.KDSVH %>">
<!-- HIDDEN으로 처리 -->
<%
    } else {
%>
        <tr align="center">
          <td class="td04" colspan="6"><spring:message code='LABEL.A.A04.0014' /><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
        </tr>
        </table>
    <!--가족사항 리스트 테이블 끝-->
      </td>
    </tr>
  </table>
<%
    }
%>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>


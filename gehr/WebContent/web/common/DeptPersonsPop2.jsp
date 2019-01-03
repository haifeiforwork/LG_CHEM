<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사원인사정보검색                                            */
/*   Program Name : 사원인사정보검색                                            */
/*   Program ID   : DeptPersonsPop2.jsp                                         */
/*   Description  : 인재개발협의결과 입력 부분 사원인사정보검색                 */
/*   Note         : 없음                                                        */
/*   Creation     : 최영호                                                      */
/*   Update       : 2005-01-26  윤정현                                          */
/*                     2017-08-30 이지은 안쓰는 화면임.                                                         */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    boolean isFirst = true;
    Vector DeptPersInfoData_vt = new Vector();

    String count   = request.getParameter("count");
    long   l_count = 0;
    if( count != null ) {
        l_count = Long.parseLong(count);
    }

//  page 처리
    String paging    = request.getParameter("page");
    String jobid     = request.getParameter("jobid");
    String i_dept    = user.empNo;
    String e_retir   = user.e_retir;
    String retir_chk = request.getParameter("retir_chk");
    String i_value1  = request.getParameter("I_VALUE1");
    String i_gubun   = request.getParameter("I_GUBUN");

    if( i_gubun == null || i_gubun.equals("") ) {
        i_gubun = "2";
    }

    if( jobid != null && paging == null ) {
        try{
            if( jobid.equals("pernr") ) {
                DeptPersInfoData_vt = ( new DeptPersInfo2RFC() ).getPersons(i_dept, i_value1, "", "1", retir_chk);
            } else if( jobid.equals("ename") ) {
                DeptPersInfoData_vt = ( new DeptPersInfo2RFC() ).getPersons(i_dept, "", i_value1, "2", retir_chk);
            } else {
                i_value1 = "";
            }

            l_count = DeptPersInfoData_vt.size();
        }catch(Exception ex){
            DeptPersInfoData_vt = null;
        }

        isFirst = false;

    } else if( jobid != null && paging != null ) {

        isFirst = false;

        for( int i = 0 ; i < l_count ; i++ ) {
            DeptPersInfoData deptData = new DeptPersInfoData();

            deptData.PERNR = request.getParameter("PERNR"+i);    // 사번
            deptData.ENAME = request.getParameter("ENAME"+i);    // 사원이름
            deptData.ORGTX = request.getParameter("ORGTX"+i);    // 조직명
            deptData.TITEL = request.getParameter("TITEL"+i);    // 직위
            deptData.TITL2 = request.getParameter("TITL2"+i);    // 직책
            deptData.STLTX = request.getParameter("STLTX"+i);    // 직무
            deptData.BTEXT = request.getParameter("BTEXT"+i);    // 근무지
            deptData.STAT2 = request.getParameter("STAT2"+i);    // 재직자,퇴직자 구분

            DeptPersInfoData_vt.addElement(deptData);
        }
    }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if( jobid != null ) {
        try {
            pu = new PageUtil(DeptPersInfoData_vt.size(), paging , 10, 10);
          Logger.debug.println(this, "page : "+paging);
        } catch (Exception ex) {
            Logger.debug.println(DataUtil.getStackTrace(ex));
        }
    }
%>
<html>
<head>
<title>사원 검색</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--

function init(){
<%
    if( DeptPersInfoData_vt != null ) {
        if( DeptPersInfoData_vt.size() == 1 ) {
            DeptPersInfoData data = (DeptPersInfoData)DeptPersInfoData_vt.get(0);
%>
    changeAppData( "<%= data.PERNR %>", "<%= data.STAT2 %>",  "<%= data.ORGTX %>", "<%= data.TITEL %>",  "<%= data.TITL2 %>",  "<%= data.ENAME %>");
<%
        }
    }
%>
}

function PageMove() {
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/DeptPersonsPop2.jsp";
    document.form1.submit();
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        pers_search();
    }
}

function changeAppData(PERNR, i_stat2, ORGTX, TITEL, TITL2, ENAME){
//    alert(PERNR, i_stat2);

    opener.document.form1.empNo.value = PERNR;
    opener.document.form1.ORGTX.value = ORGTX;
    opener.document.form1.TITEL.value = TITEL;
    opener.document.form1.TITL2.value = TITL2;
    opener.document.form1.ENAME.value = ENAME;

    opener.document.form1.jobid.value = "first";
    opener.document.form1.action = "<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV";
    opener.document.form1.method = "post";
    opener.document.form1.target = "menuContentIframe";
    opener.document.form1.submit();

    self.close();
}

function gubun_change() {
    document.form1.I_VALUE1.value    = "";
    document.form1.I_VALUE1.focus();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    PageMove();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}
//-->
</SCRIPT>
<script>
//    window.resizeTo(690,529);
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init();">
<table width="<%= e_retir.equals("Y") ? "720" : "660" %>" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" onsubmit="return false">
  <tr>
    <td><br>
      <table width="<%= e_retir.equals("Y") ? "680" : "620" %>" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif"><spring:message code="LABEL.SEARCH.PERSON" /><!-- 사원검색 --></td>
              </tr>
            </table></td>
        </tr>
<%
    if ( DeptPersInfoData_vt != null && DeptPersInfoData_vt.size() > 0 ) {
%>
        <tr>
          <td align="right" class="td02"><%= pu == null ? "" : pu.pageInfo() %></td>
        </tr>
<%
    } else {
%>
        <tr>
          <td align="right" class="td02">&nbsp;</td>
        </tr>
<%
    }
%>
        <tr>
          <td>
            <table width="<%= e_retir.equals("Y") ? "690" : "630" %>" border="0" cellspacing="1" cellpadding="2" class="table01">
              <tr>
                <td class="td03" width="30"><spring:message code="LABEL.COMMON.0014" /><!-- 선택 --></td>
                <td class="td03" width="60"><spring:message code="MSG.A.A01.0005" /><!-- 사번 --></td>
                <td class="td03" width="70"><spring:message code="MSG.APPROVAL.0013" /><!-- 성명 --></td>
                <td class="td03" width="170"><spring:message code="MSG.APPROVAL.0015" /><!-- 부서 --></td>
                <td class="td03" width="70"><%-- <spring:message code="MSG.APPROVAL.0014" /><!-- 직위 --> --%>
                <spring:message code="LABEL.COMMON.0051" /><!-- 직위/직급호칭 -->
                </td>
                <td class="td03" width="70"><spring:message code="LABEL.COMMON.0009" /><!-- 직책 --></td>
                <td class="td03" width="80"><spring:message code="MSG.A.A01.0013" /><!-- 직무 --></td>
                <td class="td03" width="80"><spring:message code="MSG.A.A01.0018" /><!-- 근무지 --></td>
<%
    if( e_retir.equals("Y") ) {
%>
                <td class="td03" width="60"><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></td>
<%
    }
%>

              </tr>
<%
    if( !isFirst ){
        if( DeptPersInfoData_vt != null && DeptPersInfoData_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                DeptPersInfoData deptPersInfoData = (DeptPersInfoData)DeptPersInfoData_vt.get(i);
%>
              <tr align="center">
                <td class="td04"><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= deptPersInfoData.PERNR %>', '<%= deptPersInfoData.STAT2 %>', '<%= deptPersInfoData.ORGTX %>','<%= deptPersInfoData.TITEL %>','<%=  deptPersInfoData.TITL2%>','<%= deptPersInfoData.ENAME %>');"></td>
                <td class="td04"><%=WebUtil.printString( deptPersInfoData.PERNR )%></td>
                <td class="td04"><%=WebUtil.printString( deptPersInfoData.ENAME )%></td>
                <td class="td09"><%=WebUtil.printString( deptPersInfoData.ORGTX )%></td>
                <td class="td04"><%=WebUtil.printString( deptPersInfoData.TITEL )%></td>
                <td class="td04"><%=WebUtil.printString( deptPersInfoData.TITL2 )%></td>
                <td class="td04"><%=WebUtil.printString( deptPersInfoData.STLTX )%></td>
                <td class="td04"><%=WebUtil.printString( deptPersInfoData.BTEXT )%></td>
<%
                if( e_retir.equals("Y") ) {
%>
                <td class="td04"><%= deptPersInfoData.STAT2.equals("0") ? g.getMessage("LABEL.SEARCH.POP.0002") : g.getMessage("LABEL.SEARCH.POP.0001") %></td>
<%
                }
%>
              </tr>
<%
            }

            for( int i = 0 ; i < DeptPersInfoData_vt.size(); i++ ) {
                DeptPersInfoData deptPersInfoData = (DeptPersInfoData)DeptPersInfoData_vt.get(i);
%>
              <input type="hidden" name="PERNR<%= i %>" value="<%= deptPersInfoData.PERNR %>">
              <input type="hidden" name="ENAME<%= i %>" value="<%= deptPersInfoData.ENAME %>">
              <input type="hidden" name="ORGTX<%= i %>" value="<%= deptPersInfoData.ORGTX %>">
              <input type="hidden" name="TITEL<%= i %>" value="<%= deptPersInfoData.TITEL %>">
              <input type="hidden" name="TITL2<%= i %>" value="<%= deptPersInfoData.TITL2 %>">
              <input type="hidden" name="STLTX<%= i %>" value="<%= deptPersInfoData.STLTX %>">
              <input type="hidden" name="BTEXT<%= i %>" value="<%= deptPersInfoData.BTEXT %>">
              <input type="hidden" name="STAT2<%= i %>" value="<%= deptPersInfoData.STAT2 %>">
<%
            }
%>
            </table>
          </td>
        </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
        <tr>
          <td align="center" height="25" valign="bottom" class="td02" colspan="<%= e_retir.equals("Y") ? "9" : "8" %>">
<%= pu == null ? "" : pu.pageControl() %>
          </td>
        </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
<%
        } else {

%>
              <tr align="center">
                <td class="td04" align="center" colspan="<%= e_retir.equals("Y") ? "9" : "8" %>"><spring:message code="LABEL.APPROVAL.0010" /><!-- 인사정보 조회대상이 아니거나 사원마스터가 없습니다. --></td>
              </tr>
            </table>
          </td>
        </tr>
<%
        }
%>
        <tr>
          <td>&nbsp;</td>
        </tr>
<%
    }
%>
      </table>
    </td>
  </tr>
  <input type="hidden" name="jobid"     value="">
  <input type="hidden" name="I_DEPT"    value="<%= i_dept %>">
  <input type="hidden" name="E_RETIR"   value="<%= e_retir  %>">
  <input type="hidden" name="retir_chk" value="">
  <input type="hidden" name="page"      value="">
  <input type="hidden" name="count"     value="<%= l_count %>">
</form>
<form name="form2" method="post">
    <input type="hidden" name="jobid"   value="">
    <input type="hidden" name="empNo"   value="">
    <input type="hidden" name="i_dept"  value="">
    <input type="hidden" name="e_retir" value="">
    <input type="hidden" name="i_stat2" value="">
</form>
</table>
<%@ include file="commonEnd.jsp" %>

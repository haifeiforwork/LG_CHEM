<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색창                                                  */
/*   Program ID   : SearchDeptPersonsPop_m.jsp                                  */
/*   Description  : 사원검색창(부서인사정보)                                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%--@ include file="/web/common/popupPorcess.jsp" --%>

<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%
    WebUserData user                   = (WebUserData)session.getAttribute("epuser");
    boolean isFirst             = true;
    Vector  DeptPersInfoData_vt = new Vector();

    String  count               = request.getParameter("count");
    long    l_count             = 0;
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }
//  page 처리
    String  paging              = request.getParameter("page");

    String  jobid               = request.getParameter("jobid");
    String  i_dept              = user.empNo;
    String  e_retir             = user.e_retir;
    String  retir_chk           = request.getParameter("retir_chk");
    String  i_value1            = request.getParameter("I_VALUE1");
    String  i_gubun             = request.getParameter("I_GUBUN");

//    if ( e_retir.equals("Y") ) {
//        retir_chk = "X";
//    }

    if( i_gubun == null || i_gubun.equals("") ) {
        i_gubun = "2";
    }

    if( jobid != null && paging == null ) {

        try{
            if( jobid.equals("pernr") ) {
                DeptPersInfoData_vt = ( new DeptPersInfoRFC() ).getPersons(i_dept, i_value1, "",       "1", retir_chk);
            } else if( jobid.equals("ename") ) {
                DeptPersInfoData_vt = ( new DeptPersInfoRFC() ).getPersons(i_dept, "",       i_value1, "2", retir_chk);
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
<link href="<%= WebUtil.ImageURL %>css/ehr.css" rel="stylesheet" type="text/css">

<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
<%
    if( DeptPersInfoData_vt != null ) {
        if( DeptPersInfoData_vt.size() == 1 ) {
            DeptPersInfoData data = (DeptPersInfoData)DeptPersInfoData_vt.get(0);
%>
    changeAppData("<%= data.PERNR %>", "<%= data.STAT2%>");
<%
        }
    }
%>
}

function PageMove_m() {
    document.form1.action = "<%=WebUtil.JspPath%>ep/SearchDeptPersonsPop_ep.jsp";
    document.form1.submit();
}

function changeAppData(PERNR, i_stat2){
    document.form1.empNo.value   = PERNR;
    document.form1.action = "<%=WebUtil.JspPath%>ep/NewSession.jsp";
    document.form1.submit();
}

function gubun_change() {
    document.form1.I_VALUE1.value    = "";
    document.form1.I_VALUE1.focus();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    PageMove_m();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}
//-->
</SCRIPT>
<script>
//    window.resizeTo(690,490);
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
                <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">사원검색</td>
              </tr>
            </table></td>
        </tr>
        <%
    if ( DeptPersInfoData_vt != null && DeptPersInfoData_vt.size() > 0 ) {
%>
        <tr>
          <td align="right" class="td08"><%= pu == null ? "" : pu.pageInfo() %></td>
        </tr>
        <%
    } else {
%>
        <tr>
          <td align="right" class="td08">&nbsp;</td>
        </tr>
        <%
    }
%>
        <tr>
          <td> <table width="<%= e_retir.equals("Y") ? "690" : "630" %>" border="0" cellspacing="1" cellpadding="2" class="table01">
              <tr>
                <td class="td03" width="30">선택</td>
                <td class="td03" width="60">사번</td>
                <td class="td03" width="70">성명</td>
                <td class="td03" width="170">부서</td>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
                <%--<td class="td03" width="70">직위</td> --%>
                <td class="td03" width="70">직위/직급호칭</td>
                <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                <td class="td03" width="70">직책</td>
                <td class="td03" width="80">직무</td>
                <td class="td03" width="80">근무지</td>
                <%
    if( e_retir.equals("Y") ) {
%>
                <td class="td03" width="60">구분</td>
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
                <td class="td04"><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= deptPersInfoData.PERNR %>', '<%= deptPersInfoData.STAT2 %>');"></td>
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
            </table></td>
        </tr>
        <!-- PageUtil 관련 - 반드시 써준다. -->
        <tr>
          <td align="center" height="25" valign="bottom" class="td04" colspan="<%= e_retir.equals("Y") ? "9" : "8" %>">
            <%= pu == null ? "" : pu.pageControl() %> </td>
        </tr>
        <!-- PageUtil 관련 - 반드시 써준다. -->
        <%
        } else {

%>
        <tr align="center">
          <td class="td04" align="center" colspan="<%= e_retir.equals("Y") ? "9" : "8" %>">인사정보
            조회대상이 아니거나 사원마스터가 없습니다.</td>
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
        <tr>
          <td align="center">
            <a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>btn_close.gif" border="0"></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>

  <input type="hidden" name="I_VALUE1" value="<%= ( i_value1 == null || i_value1.equals("") ) ? "" : i_value1 %>">
  <input type="hidden" name="jobid"    value="">
  <input type="hidden" name="I_DEPT"   value="<%= user.empNo %>">
  <input type="hidden" name="E_RETIR"  value="<%= e_retir  %>">
  <input type="hidden" name="page"     value="">
  <input type="hidden" name="count"    value="<%= l_count %>">
  <input type="hidden" name="empNo"   value="">
</form>
<form name="form2" method="post">
    <input type="hidden" name="empNo"   value="">
    <input type="hidden" name="i_dept"  value="">
    <input type="hidden" name="e_retir" value="">
    <input type="hidden" name="i_stat2" value="">
</form>
</table>
<%@ include file="/web/common/commonEnd.jsp" %>

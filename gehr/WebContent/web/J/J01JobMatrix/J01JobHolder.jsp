<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %> 
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
//  Job Holder의 성명을 click시 사원인사정보를 띄워준다. - Job Profile
    WebUserData user                 = (WebUserData)session.getAttribute("user");

    Vector j01Result_P_vt = new Vector();
    String i_objid        = request.getParameter("i_objid");
    int    l_count        = Integer.parseInt(request.getParameter("l_count"));
//  Job Holder 정보
    for( int i = 0 ; i < l_count ; i++ ) {
        J01JobProfileData data = new J01JobProfileData();

        data.SOBID     = request.getParameter("SOBID"+i);        // Position ID           
        data.PERNR     = request.getParameter("PERNR"+i);        // 사번
        data.TITEL     = request.getParameter("TITEL"+i);        // 직급호칭(직위)
        data.ENAME     = request.getParameter("ENAME"+i);        // 성명
        data.BEGDA     = request.getParameter("BEGDA"+i);        // 현 보직 발령일

        j01Result_P_vt.addElement(data);
    }
    
//  page 처리
    String  paging              = request.getParameter("J_page");

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    try {
        pu = new PageUtil(j01Result_P_vt.size(), paging , 10, 10);
        Logger.debug.println(this, "J_page : "+paging);
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }
%>
 
<html>
<head>
<title>Main Job Holder</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<script language="JavaScript">
<!-- 
//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.J_page.value = page;
    PageMove();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}

function PageMove() {
    document.form1.action = "<%= WebUtil.JspURL %>J/J01JobMatrix/J01JobHolder.jsp?i_objid=<%= i_objid %>";
    document.form1.submit();
}

//Job Holder의 성명을 click시 사원인사정보를 띄워준다.
function open_dept(pernr){
    document.form1.I_DEPT.value   = "<%= user.empNo   %>";
    document.form1.I_GUBUN.value  = "1";                    //사번조회
    document.form1.I_VALUE1.value = pernr;
    document.form1.E_RETIR.value  = "<%= user.e_retir %>";
    document.form1.jobid.value    = "pernr";

    window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=<%= user.e_retir.equals("Y") ? "740" : "680" %>,height=500,left=100,top=100");
    document.form1.action         = "<%= WebUtil.JspURL %>common/DeptPersonsPopWait_m.jsp";
    document.form1.target         = "DeptPers";
    document.form1.submit();
}

//-->
</script>
  
<form name="form1" method="post" action="">
  <input type="hidden" name="J_page"   value="">
  <input type="hidden" name="l_count"  value="<%= l_count %>">

<!-- 사원인사정보검색 Popup -->
  <input type="hidden" name="I_DEPT"   value="">
  <input type="hidden" name="I_GUBUN"  value="">
  <input type="hidden" name="I_VALUE1" value="">
  <input type="hidden" name="E_RETIR"  value="">
  <input type="hidden" name="jobid"    value="">

<%
//  Page 이동을 위해서 정보를 저장함.
    for( int i = 0 ; i < j01Result_P_vt.size(); i++ ) {
        J01JobProfileData data_P = (J01JobProfileData)j01Result_P_vt.get(i);
%>
           <input type="hidden" name="SOBID<%= i %>"     value="<%= data_P.SOBID     %>">
           <input type="hidden" name="PERNR<%= i %>"     value="<%= data_P.PERNR     %>">
           <input type="hidden" name="TITEL<%= i %>"     value="<%= data_P.TITEL     %>">
           <input type="hidden" name="ENAME<%= i %>"     value="<%= data_P.ENAME     %>">
           <input type="hidden" name="BEGDA<%= i %>"     value="<%= data_P.BEGDA     %>">
<%
    }
%>
<table cellspacing=0 cellpadding=0 border=0 width=283>
  <tr>
    <td width=10><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=273 valign=top>
      <!-- 테이블 시작-->
      <table cellpadding=0 cellspacing=0 border=0 width=273>
<% 
    if ( j01Result_P_vt != null && j01Result_P_vt.size() > 0 ) {
%>
		    <tr> 
          <td colspan=5 align="right" class="cc"><%= pu == null ? "" : pu.pageInfo() %></td>
		    </tr>         
<%
    } else {
%>
		    <tr> 
          <td colspan=5 align="right" class="cc">&nbsp;</td>
		    </tr>         
<%
    } 
%>
        <tr bgcolor=#999999 height=2>
          <td width=90></td>
          <td width=1></td>
          <td width=90></td>
          <td width=1></td>
          <td width=90></td>
        </tr>
        <tr>
          <td class=ct1 align="center">직위</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1 align="center">성명</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1 align="center">Job 시작일</td>
        </tr>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
<%     
    if( j01Result_P_vt.size() > 0 ) {
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            J01JobProfileData data_P = (J01JobProfileData)j01Result_P_vt.get(i);
%>
        <tr>
          <td class=cc align="center"><%= data_P.TITEL %></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
    if ( i_objid.equals("") ) {
%>
          <td class=cc align="center"><%= data_P.ENAME %></td>
<%
    } else {
%>
          <td class=cc align="center"><a href="javascript:open_dept('<%= data_P.PERNR %>');"><%= data_P.ENAME %></a></td>
<%
    }
%>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align="center"><%= data_P.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data_P.BEGDA, ".") %></td>
        </tr>
<%
        }
    }
%>
        <tr>
          <td colspan=5 bgcolor=#999999></td>
        </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
        <tr> 
          <td align="center" height="25" valign="bottom" class="cc" colspan="5">
<%= pu == null ? "" : pu.pageControl() %>
          </td>
        </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
        <tr><td colspan=5 align="center">&nbsp;</td></tr>
        <tr>
          <td colspan=5 align="center"><a href="javascript:self.close();"><img src="<%= WebUtil.ImageURL %>btn_close.gif" border="0"></a></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

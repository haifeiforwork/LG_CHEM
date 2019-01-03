<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 초기화면에서 사원 검색하는 include 파일              */
/*   Program ID   : SearchDeptPersons_f.jsp                                     */
/*   Description  : 사원 검색하는 include 파일                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-04-29  배민규                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.Vector" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    boolean isFirst             = true;

    Vector  DeptPersInfoData_vt = new Vector();

    String  count   = request.getParameter("count");

    long    l_count = 0;

    if( count != null ) {
        l_count = Long.parseLong(count);
    }

//  page 처리
    String  paging    = request.getParameter("page");
    String  jobid     = request.getParameter("jobid");
    String  i_dept    = user.empNo;
    String  e_retir   = user.e_retir;
    String  retir_chk = request.getParameter("retir_chk");
    String  i_value1  = request.getParameter("I_VALUE1");
    String  i_gubun   = request.getParameter("I_GUBUN");

    if( retir_chk == null || retir_chk.equals("") ) {
        retir_chk = "";
    }

    if( e_retir == null || e_retir.equals("") ) {
        e_retir = "";
    }

    if( i_gubun == null || i_gubun.equals("") ) {
        i_gubun = "2";
    }

    if( jobid != null && paging == null ) {
        try{
            if( jobid.equals("pernr") ) {
                DeptPersInfoData_vt = ( new DeptPersInfoRFC() ).getPersons(i_dept, i_value1, "",        "1", retir_chk);
            } else if( jobid.equals("ename") ) {
                DeptPersInfoData_vt = ( new DeptPersInfoRFC() ).getPersons(i_dept, "",       i_value1 , "2", retir_chk);
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

<SCRIPT LANGUAGE="JavaScript">
<!--
function pers_search() {
    i_gubun = document.form1.I_GUBUN[document.form1.I_GUBUN.selectedIndex].value;

    if( i_gubun == "1" ) {                   //사번검색
        val = document.form1.I_VALUE1.value;
        val = rtrim(ltrim(val));

        if ( val == "" ) {
            alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED' />"); //검색할 부서원 사번을 입력하세요!
            document.form1.I_VALUE1.focus();

            return;
        } else {
            document.form1.jobid.value = "pernr";
        }
    } else if( i_gubun == "2" ) {            //성명검색
        val1 = document.form1.I_VALUE1.value;
        val1 = rtrim(ltrim(val1));

        if ( val1 == "" ) {
            alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.REQUIRED' />"); //검색할 부서원 성명을 입력하세요!
            document.form1.I_VALUE1.focus();

            return;
        } else {
            if( val1.length < 2 ) {
                alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.MIN' />"); //검색할 성명을 한 글자 이상 입력하세요!
                document.form1.I_VALUE1.focus();

                return;
            } else {
                document.form1.jobid.value = "ename";
            }
        }
    }

//  2002.08.20. 퇴직자 검색이 check되었는지 여부 ---------------
    document.form1.retir_chk.value = "";
<%
    if( e_retir.equals("Y") ) {
%>
    if( document.form1.RETIR.checked ) {
        document.form1.retir_chk.value = "X";
    }
<%
    }
%>
//  ------------------------------------------------------------

<%
    if( user_m != null && user_m.e_retir.equals("Y") ) {
%>
    small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=100,top=100");
<%
    } else {
%>
    small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
<%
    }
%>
    small_window.focus();
    document.form1.target = "DeptPers";
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsWait_m.jsp";
    document.form1.submit();
}


//조직도 검사Popup.
function organ_search() {

    small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=500,left=100,top=100");
    small_window.focus();

    document.form1.target = "Organ";
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/OrganListFramePop.jsp";
    document.form1.submit();
}

function EnterCheck(){
    if (event.keyCode == 13)  {
        pers_search();
    }
}

function gubun_change() {
    document.form1.I_VALUE1.value    = "";
    document.form1.I_VALUE1.focus();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange_m(page){
    document.form1.page.value = page;
    PageMove_m();
}

function PageMove_m() {
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersons_m.jsp";
    document.form1.submit();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange_m(val);
}
//-->

</SCRIPT>

<tr><td>
<table width="780" height="29" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td background="<%= WebUtil.ImageURL %>bg_search.gif">
      <table width="780" height="29" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="<%= e_retir.equals("Y") ? "90" : "152" %>" align="center"><img src="<%= WebUtil.ImageURL %>search03.gif"></td>
<%
    if( e_retir.equals("Y") ) {
%>
          <td width="82" style="vertical-align:top;padding-top:2px">
            <font color="#585858"><spring:message code='LABEL.COMMON.0012' /><!-- 퇴직자조회 --></font><input type="checkbox" name="RETIR" <%= retir_chk.equals("X") ? "checked" : "" %> size="20"></td>
<%
    }
%>
          <td width="1"><img src="../images/line_dot.gif" width="1" height="28"></td>
          <td width="<%= e_retir.equals("Y") ? "60" : "70" %>" align="center"><font color="#585858"><spring:message code='LABEL.COMMON.0003' /><!-- 선택구분 --></font></td>
          <td width="<%= e_retir.equals("Y") ? "60" : "70" %>"><select name="I_GUBUN" class="input03" onChange="javascript:gubun_change()">
              <option value="2"><spring:message code='LABEL.COMMON.0020' /><!-- 성명별 --></option>
              <option value="1"><spring:message code='LABEL.COMMON.0005' /><!-- 사번별 --></option>
            </select></td>
          <td width="80">
	      <input type="text"   name="I_VALUE1" size="10"  maxlength="10"  class="input03" value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
          <input type="hidden" name="jobid"     value=""></td>
          <td width="95"><a href="javascript:pers_search();"><img src="<%= WebUtil.ImageURL %>btn_serch04.gif" border="0"></a></td>
          <td width="1"><img src="<%= WebUtil.ImageURL %>line_dot.gif"></td>
          <td width="34" align="center"><img src="<%= WebUtil.ImageURL %>icon_map.gif"></td>
          <td width="142" align="center"><a href="javascript:organ_search();"><img src="<%= WebUtil.ImageURL %>btn_serch03.gif" border="0"></a></td>
        </tr>
		<input type="hidden" name="I_DEPT"   value="<%= user.empNo  %>">
         <input type="hidden" name="E_RETIR"  value="<%= user.e_retir %>">
         <input type="hidden" name="page"     value="">
         <input type="hidden" name="count"    value="<%= l_count %>">
         <input type="hidden" name="retir_chk" value="<%=retir_chk%>">
      </table>
    </td>
  </tr>
</table>
<table width="780" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#b7a68a"><img src="<%= WebUtil.ImageURL %>ehr/space.gif" width="1" height="1"></td>
  </tr>
</table>
    <table width="780" height="4" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="3"></td>
        <td><img src="<%= WebUtil.ImageURL %>ehr/space.gif" height="4"></td>
        <td width="3"></td>
      </tr>
    </table>
    </td></tr>

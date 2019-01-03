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
    String  i_dept              = request.getParameter("I_DEPT");
    String  e_retir             = request.getParameter("E_RETIR");
    String  retir_chk           = request.getParameter("retir_chk");

    String  i_value1            = request.getParameter("I_VALUE1");
    String  i_value2            = request.getParameter("I_VALUE2");

    String  i_gubun             = request.getParameter("I_GUBUN");

    if( i_gubun == null || i_gubun.equals("") ) {
        i_gubun = "2";
    }

    if( jobid != null && paging == null ) {

        try{
            if( jobid.equals("pernr") ) {
                DeptPersInfoData_vt = ( new DeptPersInfoRFC() ).getPersons(i_dept, i_value2, "",                        "1", retir_chk);
            } else if( jobid.equals("ename") ) {
                DeptPersInfoData_vt = ( new DeptPersInfoRFC() ).getPersons(i_dept, "",       i_value1 + " " + i_value2, "2", retir_chk);
            } else {
                i_value1 = "";
                i_value2 = "";
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
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
<%
    if( DeptPersInfoData_vt != null ) {
        if( DeptPersInfoData_vt.size() == 1 ) {
            DeptPersInfoData data = (DeptPersInfoData)DeptPersInfoData_vt.get(0);
%>
    width  = screen.width*8/10;
	  height = screen.height*6/10;
    vleft  = screen.width*1/10;
	  vtop   = screen.height*1/10;

    document.form2.empNo.value   = "<%= data.PERNR %>";
    document.form2.i_dept.value  = "<%= i_dept     %>";
    document.form2.e_retir.value = "<%= e_retir    %>";
    document.form2.i_stat2.value = "<%= data.STAT2 %>";

    window.open("","newDeptPers","toolbar=1,directories=1,menubar=1,status=1,resizable=1,location=0,scrollbars=1,left="+vleft+",top="+vtop+",width="+width+",height="+height);
    document.form2.action="<%= WebUtil.ServletURL %>hris.AdminLoginSV_m";
    document.form2.target="newDeptPers";
    document.form2.submit();

	  //self.close();
<%
        }
    }

    if( DeptPersInfoData_vt != null && DeptPersInfoData_vt.size() == 1 ) {
        //----------------------------
    } else {
        if( jobid != null && jobid.equals("pernr") ) {
%>
        document.form1.I_VALUE1.disabled = 1;
        document.form1.I_VALUE1.readonly = 1;
        document.form1.I_VALUE1.value    = "";
        document.form1.I_VALUE1.style.backgroundColor = "#C0C0C0";
        document.form1.I_VALUE2.focus();
<%
        } else {
%>
        document.form1.I_VALUE1.disabled = 0;
        document.form1.I_VALUE1.readonly = 0;
        document.form1.I_VALUE1.style.backgroundColor = "#FFFFFF";
        document.form1.I_VALUE1.focus();
<%
        }
    }
%>
}

function pers_search() {
    i_gubun = document.form1.I_GUBUN[document.form1.I_GUBUN.selectedIndex].value;

    if( i_gubun == "1" ) {                   //사번검색
        val = document.form1.I_VALUE2.value;
        val = rtrim(ltrim(val));

        if ( val == "" ) {
            alert('<spring:message code="MSG.APPROVAL.SEARCH.PERNR.REQUIRED" />'); //검색할 부서원 사번을 입력하세요!
            document.form1.I_VALUE2.focus();

            return;
        } else {
            document.form1.jobid.value = "pernr";
        }
    } else if( i_gubun == "2" ) {            //성명검색
        val1 = document.form1.I_VALUE1.value;
        val2 = document.form1.I_VALUE2.value;
        val1 = rtrim(ltrim(val1));
        val2 = rtrim(ltrim(val2));

        if ( val1 == "" && val2 == "" ) {
            alert('<spring:message code="MSG.APPROVAL.SEARCH.NAME.REQUIRED" />'); //검색할 부서원 성명을 입력하세요!
            document.form1.I_VALUE1.focus();

            return;
        } else {
            if( val1.length < 1 ) {
                alert('<spring:message code="MSG.COMMON.0065" />'); //검색할 성명의 성을 입력하세요!
                document.form1.I_VALUE1.focus();

                return;
            } else if( val2.length < 1 ) {
                alert('<spring:message code="MSG.COMMON.0066" />'); //검색할 성명의 이름을 한 글자 이상 입력하세요!
                document.form1.I_VALUE2.focus();

                return;
            } else {
                document.form1.jobid.value = "ename";
            }
        }
    }

//  2002.08.20. 퇴직자 검색이 check되었는지 여부 -----------------------------------
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
//  -------------------------------------------------------------------------------

    document.form1.action = "<%=WebUtil.JspURL%>"+"common/DeptPersonsPopWait.jsp";
    document.form1.submit();
}

function PageMove() {
    i_gubun = document.form1.I_GUBUN[document.form1.I_GUBUN.selectedIndex].value;

    if( i_gubun == "1" ) {                   //사번검색
        val = document.form1.I_VALUE2.value;
        val = rtrim(ltrim(val));

        if ( val == "" ) {
            alert('<spring:message code="MSG.APPROVAL.SEARCH.PERNR.REQUIRED" />'); //검색할 부서원 사번을 입력하세요!
            document.form1.I_VALUE2.focus();

            return;
        } else {
            document.form1.jobid.value = "pernr";
        }
    } else if( i_gubun == "2" ) {            //성명검색
        val1 = document.form1.I_VALUE1.value;
        val2 = document.form1.I_VALUE2.value;
        val1 = rtrim(ltrim(val1));
        val2 = rtrim(ltrim(val2));

        if ( val1 == "" && val2 == "" ) {
            alert('<spring:message code="MSG.APPROVAL.SEARCH.NAME.REQUIRED" />'); //검색할 부서원 성명을 입력하세요!
            document.form1.I_VALUE1.focus();

            return;
        } else {
            if( val1.length < 1 ) {
                alert('<spring:message code="MSG.COMMON.0065" />'); //검색할 성명의 성을 입력하세요!
                document.form1.I_VALUE1.focus();

                return;
            } else if( val2.length < 1 ) {
                alert('<spring:message code="MSG.COMMON.0066" />'); //검색할 성명의 이름을 한 글자 이상 입력하세요!
                document.form1.I_VALUE2.focus();

                return;
            } else {
                document.form1.jobid.value = "ename";
            }
        }
    }
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/DeptPersonsPop.jsp";
    document.form1.submit();
}

function EnterCheck(){
	if (event.keyCode == 13)  {
		pers_search();
	}
}

function changeAppData(PERNR, i_stat2){
    width  = screen.width*8/10;
	  height = screen.height*6/10;
    vleft  = screen.width*1/10;
	  vtop   = screen.height*1/10;

    document.form2.empNo.value   = PERNR;
    document.form2.i_dept.value  = "<%= i_dept     %>";
    document.form2.e_retir.value = "<%= e_retir    %>";
    document.form2.i_stat2.value = i_stat2;

    window.open("","newDeptPers","toolbar=1,directories=1,menubar=1,status=1,resizable=1,location=0,scrollbars=1,left="+vleft+",top="+vtop+",width="+width+" height="+height);
    document.form2.action="<%= WebUtil.ServletURL %>hris.AdminLoginSV_m";
    document.form2.target="newDeptPers";
    document.form2.submit();

	  self.close();
}

function gubun_change() {
    i_gubun = document.form1.I_GUBUN[document.form1.I_GUBUN.selectedIndex].value;

    if( i_gubun == 2 ) {                          //성명검색

        document.form1.I_VALUE1.disabled = 0;
        document.form1.I_VALUE1.readonly = 0;
        document.form1.I_VALUE1.style.backgroundColor = "#FFFFFF";
        document.form1.I_VALUE1.focus();

    } else if( i_gubun == 1 ) {                   //사번검색

        document.form1.I_VALUE1.disabled = 1;
        document.form1.I_VALUE1.readonly = 1;
        document.form1.I_VALUE1.value    = "";
        document.form1.I_VALUE1.style.backgroundColor = "#C0C0C0";
        document.form1.I_VALUE2.focus();

    }
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

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init()">
<table width="<%= e_retir.equals("Y") ? "720" : "660" %>" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" onsubmit="return false">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>
      <table width="<%= e_retir.equals("Y") ? "680" : "620" %>" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="p_find01"><spring:message code="LABEL.SEARCH.PERSON" /><!-- 사원 검색 --></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="<%= e_retir.equals("Y") ? "680" : "620" %>" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="315">
                  <table width="315" border="0" cellspacing="1" cellpadding="2" class="table01">
                    <tr>
                      <td class="td03" width="60"><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></td>
                      <td class="td03" width="70">
                        <select name="I_GUBUN" class="input03" onChange="javascript:gubun_change()">
                          <option value="2" <%= i_gubun.equals("2") ? "selected" : "" %>><spring:message code="LABEL.COMMON.0020" /><!-- 성명별 --></option>
                          <option value="1" <%= i_gubun.equals("1") ? "selected" : "" %>><spring:message code="LABEL.COMMON.0005" /><!-- 사번별 --></option>
                        </select>
                      </td>
                      <td class="td03" width="135">
                        <input type="text"   name="I_VALUE1" size="5"  maxlength="5"  class="input03" value="<%= ( i_value1 == null || i_value1.equals("") ) ? "" : i_value1 %>"  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                        <input type="text"   name="I_VALUE2" size="10" maxlength="10" class="input03" value="<%= ( i_value2 == null || i_value2.equals("") ) ? "" : i_value2 %>"  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                        <input type="hidden" name="jobid"     value="">
                        <input type="hidden" name="I_DEPT"    value="<%= i_dept %>">
                        <input type="hidden" name="E_RETIR"   value="<%= e_retir  %>">
                        <input type="hidden" name="retir_chk" value="">
                        <input type="hidden" name="page"      value="">
                        <input type="hidden" name="count"     value="<%= l_count %>">
                      </td>
                      <td class="td03" width="50" style="padding-top: 5px">
                        <a href="javascript:pers_search();"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" border="0"></a>
                      </td>
                    </tr>
                  </table>
                </td>
<%
    if( e_retir.equals("Y") ) {
%>
                <td class="td02" width="100">
                  <input type="checkbox" name="RETIR" <%= retir_chk != null && retir_chk.equals("X") ? "checked" : "" %> size="20">&nbsp;<font color="#0000FF"><spring:message code="LABEL.COMMON.0021" /><!-- 퇴직자 포함 --></font>
                </td>
<%
    } else {
%>
                <td class="td02" width="100">&nbsp;</td>
<%
    }
%>
                <td align="right" valign="bottom">
                  <a href="javascript:self.close()">
                    <img src="<%= WebUtil.ImageURL %>btn_close.gif" width="49" height="20" border="0">
                  </a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="td02" height="30" align="bottom"><spring:message code="LABEL.COMMON.0022" /><!-- 성명별로 검색시 성과 이름을 구분하여 입력하시기 바랍니다.(선우 혁신 -> "선우", "혁신") --></td>
        </tr>
        <tr>
          <td background="<%= WebUtil.ImageURL %>bg_pixel02.gif">&nbsp;</td>
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
                <td class="td03" width="70"><%-- //[CSR ID:3456352]<spring:message code="MSG.APPROVAL.0014" /><!-- 직위 --> --%>
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
                <td class="td02"><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= deptPersInfoData.PERNR %>', '<%= deptPersInfoData.STAT2 %>');"></td>
                <td class="td02"><%=WebUtil.printString( deptPersInfoData.PERNR )%></td>
                <td class="td02"><%=WebUtil.printString( deptPersInfoData.ENAME )%></td>
                <td class="td02" style="text-align:left"><%=WebUtil.printString( deptPersInfoData.ORGTX )%></td>
                <td class="td02"><%=WebUtil.printString( deptPersInfoData.TITEL )%></td>
                <td class="td02"><%=WebUtil.printString( deptPersInfoData.TITL2 )%></td>
                <td class="td02"><%=WebUtil.printString( deptPersInfoData.STLTX )%></td>
                <td class="td02"><%=WebUtil.printString( deptPersInfoData.BTEXT )%></td>
<%
    if( e_retir.equals("Y") ) {
%>
                <td class="td02"><%= deptPersInfoData.STAT2.equals("0") ? g.getMessage("LABEL.SEARCH.POP.0002") : g.getMessage("LABEL.SEARCH.POP.0001") %></td>

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
                <td class="td02" align="center" colspan="<%= e_retir.equals("Y") ? "9" : "8" %>"><spring:message code="LABEL.APPROVAL.0010" /><!-- 인사정보 조회대상이 아니거나 사원마스터가 없습니다. --></td>
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
</form>
<form name="form2" method="post">
    <input type="hidden" name="empNo"   value="">
    <input type="hidden" name="i_dept"  value="">
    <input type="hidden" name="e_retir" value="">
    <input type="hidden" name="i_stat2" value="">
</form>
</table>
<%@ include file="commonEnd.jsp" %>

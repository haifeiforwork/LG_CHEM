<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
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

<%
    WebUserData user = WebUtil.getSessionUser(request);
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

<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
<%
    if( DeptPersInfoData_vt != null ) {
        if( DeptPersInfoData_vt.size() == 1 ) {
            DeptPersInfoData data = (DeptPersInfoData)DeptPersInfoData_vt.get(0);
%>
    changeAppData("<%= data.PERNR %>");
<%
        }
    }
%>
}

function PageMove() {
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsPop.jsp";
    document.form1.submit();
}


function changeAppData(PERNR) {
    top.opener.document.form1.PERNR.value   = PERNR;
    top.opener.reload();
    top.close();

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
//    window.resizeTo(690,490);
</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init();">
<div width="<%= e_retir.equals("Y") ? "720" : "660" %>" class="winPop">
<form name="form1" method="post" onsubmit="return false">

	<div class="header">
		<span><spring:message code="LABEL.SEARCH.PERSON" /><!-- 사원검색 --></span>
		<a href="" onclick="top.close();"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png"></a>
	</div>



	<div class="body">
		<div class="listArea">
<%
    if ( DeptPersInfoData_vt != null && DeptPersInfoData_vt.size() > 0 ) {
%>
		<div class="listTop">
			<span class="listCnt"><%= pu == null ? "" : pu.pageInfo() %></span>
		</div>
<%
    }
%>
			<div class="table">
	          <table class="listTable">
	              <tr>
	                <th><spring:message code="LABEL.COMMON.0014" /><!-- 선택 --></th>
	                <th><spring:message code="MSG.A.A01.0005" /><!-- 사번 --></th>
	                <th><spring:message code="MSG.APPROVAL.0013" /><!-- 성명 --></th>
	                <th><spring:message code="MSG.APPROVAL.0015" /><!-- 부서 --></th>
	                <th><%-- //[CSR ID:3456352]<spring:message code="MSG.APPROVAL.0014" /><!-- 직위 --> --%>
	                <spring:message code="LABEL.COMMON.0051" /><!-- 직위/직급호칭 --></th>
	                <th><spring:message code="LABEL.COMMON.0009" /><!-- 직책 --></th>
	                <th><spring:message code="MSG.A.A01.0013" /><!-- 직무 --></th>
	                <th class="lastCol"><spring:message code="MSG.A.A01.0018" /><!-- 근무지 --></th>
<%
    if( e_retir.equals("Y") ) {
%>
                <th class="lastCol"><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></th>
<%
    }
%>
              </tr>
              <%
   if( !isFirst ){
        if( DeptPersInfoData_vt != null && DeptPersInfoData_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                DeptPersInfoData deptPersInfoData = (DeptPersInfoData)DeptPersInfoData_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
              <tr class="<%=tr_class %>">
                <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%=deptPersInfoData.PERNR%>');"></td>
                <td><%=WebUtil.printString( deptPersInfoData.PERNR )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.ENAME )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.ORGTX )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.TITEL )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.TITL2 )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.STLTX )%></td>
                <td class="lastCol"><%=WebUtil.printString( deptPersInfoData.BTEXT )%></td>
                <%
    if( e_retir.equals("Y") ) {
%>
                <td class="lastCol"><%= deptPersInfoData.STAT2.equals("0") ? g.getMessage("LABEL.SEARCH.POP.0002") : g.getMessage("LABEL.SEARCH.POP.0001") %></td>
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
				<div class="align_center">
					<%= pu == null ? "" : pu.pageControl() %>
				</div>
			</div>
		</div>
<%
        } else {

%>
        <tr>
          <td class="lastCol" colspan="<%= e_retir.equals("Y") ? "9" : "8" %>"><spring:message code="LABEL.APPROVAL.0010" /><!-- 인사정보 조회대상이 아니거나 사원마스터가 없습니다. --></td>
        </tr>
      </table>
	</div>
	</div>
<%
        }
%>
<%
    }
%>

        	<div class="buttonArea">
        		<ul class="btn_crud">
        			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
        		</ul>
        	</div>
	</div>

  <input type="hidden" name="I_VALUE1" value="<%= ( i_value1 == null || i_value1.equals("") ) ? "" : i_value1 %>">
  <input type="hidden" name="jobid"    value="">
  <input type="hidden" name="I_DEPT"   value="<%= user.empNo %>">
  <input type="hidden" name="E_RETIR"  value="<%= e_retir  %>">
  <input type="hidden" name="page"     value="">
  <input type="hidden" name="count"    value="<%= l_count %>">
  <input type="hidden" name="hdn_viewFlag" value="CLOSE">
  <input type="hidden" name="empNo"   value="">
  <input type="hidden" name="I_RETIR"   value="">
</form>
<form name="form2" method="post">
    <input type="hidden" name="empNo"   value="">
    <input type="hidden" name="i_dept"  value="">
    <input type="hidden" name="e_retir" value="">
    <input type="hidden" name="i_stat2" value="">
</form>
</div><iframe name="ifHidden" width="0" height="0" />
<%@ include file="commonEnd.jsp" %>

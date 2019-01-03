<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원검색창                                                  */
/*   Program ID   : SearchDeptPersonsPop.jsp                                    */
/*   Description  : 사원검색창(대리신청)                                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>

<%
    WebUserData user                   = (WebUserData)session.getAttribute("user");
    boolean isFirst             = true;
    Vector  DeptPersInfoData_vt = new Vector();

    String  count               = request.getParameter("count");
    int    l_count             = 0;
    if( count != null ) {
        l_count                 = NumberUtils.toInt(count);
    }
//  page 처리
    String  paging              = request.getParameter("page");

    String  jobid               = request.getParameter("jobid");
    String  i_dept              = user.empNo;
    String  e_retir             = user.e_retir;
    String  retir_chk           = request.getParameter("retir_chk");
    String  i_value1            = request.getParameter("I_VALUE1");
    String  i_gubun             = request.getParameter("I_GUBUN");

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

            l_count = Utils.getSize(DeptPersInfoData_vt);
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
            deptData.JIKWT = request.getParameter("JIKWT"+i);    // 직위
            deptData.JIKKT = request.getParameter("JIKKT"+i);    // 직책
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
      		pu = new PageUtil(l_count, paging , 10, 10);
          Logger.debug.println(this, "page : "+paging);
      	} catch (Exception ex) {
      		Logger.debug.println(DataUtil.getStackTrace(ex));
      	}
    }
%>
<jsp:include page="/include/header.jsp"/>


<SCRIPT LANGUAGE="JavaScript">
<!--
$(function() {
    init();
});
function init(){
<%
    if( DeptPersInfoData_vt != null ) {
        if( DeptPersInfoData_vt.size() == 1 ) {
            DeptPersInfoData data = (DeptPersInfoData)DeptPersInfoData_vt.get(0);
%>
    changeAppData("0");

<%
        }
    }
%>
}

function PageMove() {
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsPop_T.jsp";
    document.form1.submit();
}
/*
function changeAppData(PERNR, i_stat2){
    document.form1.empNo.value   = PERNR;
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/NewSession.jsp";
    document.form1.submit();
}
*/

function changeAppData( idx ){
    obj = new Object();
    obj.PERNR = eval("document.form1.PERNR"+idx+".value");
    obj.ENAME = eval("document.form1.ENAME"+idx+".value");
    obj.ORGTX = eval("document.form1.ORGTX"+idx+".value");
    obj.JIKWT = eval("document.form1.JIKWT"+idx+".value");
    obj.JIKKT = eval("document.form1.JIKKT"+idx+".value");
    obj.STLTX = eval("document.form1.STLTX"+idx+".value");
    obj.BTEXT = eval("document.form1.BTEXT"+idx+".value");
    obj.STAT2 = eval("document.form1.STAT2"+idx+".value");
    opener.setPersInfo(obj);
    close();
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


<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.SEARCH.PERSON"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">

<div class="listArea">
    <div class="listTop">
        <span class="listCnt"><%=l_count == 0 || pu == null ? "" : pu.pageInfo() %></span>
    </div>
    <div class="wideTable" style="border-top: 2px solid #c8294b;">
        <table class="listTable">
            <thead>
            <tr>
                <th width="30"><spring:message code="LABEL.COMMON.0014"/><%--선택--%></th>
                <th width="60"><spring:message code="MSG.A.A01.0005"/><%--사번--%></th>
                <th width="70"><spring:message code="MSG.A.A01.0002"/><%--성명--%></th>
                <th width="*"><spring:message code="MSG.A.A01.0006"/><%--부서--%></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              	<%--<th width="70"><spring:message code="MSG.A.A05.0007"/></th> --%>
              	<th width="70"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                <th width="70"><spring:message code="MSG.A.A05.0009"/><%--직책--%></th>
                <th width="80"><spring:message code="MSG.A.A05.0010"/><%--직무--%></th>
                <th class="<%=!"Y".equals(e_retir) ? "lastCol" : ""%>" width="80"><spring:message code="MSG.A.A05.0004"/><%--근무지--%></th>
                <%
                    if( e_retir.equals("Y") ) {
                %>
                <th class="lastCol" width="60"><spring:message code="LABEL.SEARCH.POP.GUBUN"/> <%--구분--%></th>
                <%
                    }
                %>
            </tr>
            </thead>
            <%
                if( !isFirst ){
                    if( DeptPersInfoData_vt != null && DeptPersInfoData_vt.size() > 0 ){
                        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                            DeptPersInfoData deptPersInfoData = (DeptPersInfoData)DeptPersInfoData_vt.get(i);
            %>
            <tr class="<%=WebUtil.printOddRow(i)%>">
                <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= i %>');"></td>
                <td><%=WebUtil.printString( deptPersInfoData.PERNR )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.ENAME )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.ORGTX )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.JIKWT )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.JIKKT )%></td>
                <td><%=WebUtil.printString( deptPersInfoData.STLTX )%></td>
                <td class="<%=!"Y".equals(e_retir) ? "lastCol" : ""%>"><%=WebUtil.printString( deptPersInfoData.BTEXT )%></td>
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
            <input type="hidden" name="JIKWT<%= i %>" value="<%= deptPersInfoData.JIKWT %>">
            <input type="hidden" name="JIKKT<%= i %>" value="<%= deptPersInfoData.JIKKT %>">
            <input type="hidden" name="STLTX<%= i %>" value="<%= deptPersInfoData.STLTX %>">
            <input type="hidden" name="BTEXT<%= i %>" value="<%= deptPersInfoData.BTEXT %>">
            <input type="hidden" name="STAT2<%= i %>" value="<%= deptPersInfoData.STAT2 %>">
            <%
                }
            %>
            <%
            } else {

            %>
            <tr>
                <td class="lastCol" colspan="<%= e_retir.equals("Y") ? "9" : "8" %>"><spring:message code="MSG.D.D12.0024"/> <%--인사정보 조회대상이 아니거나 사원마스터가 없습니다.--%></td>
            </tr>
            <%
                }
            %>
        </table>
        <div class="align_center">
            <%= pu == null ? "" : pu.pageControl() %>
        </div>
        <%
            }
        %>
    </div>
</div>

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
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>




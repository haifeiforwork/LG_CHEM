<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 검색하는 include 파일                                  */
/*   Program ID   : SearchDeptPersons_m.jsp                                     */
/*   Description  : 사원 검색하는 include 파일                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :   2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.Vector" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--@ include file="/include/includeCommon.jsp"--%>
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

<c:set var="e_retir" value="<%=e_retir%>"/>

<SCRIPT LANGUAGE="JavaScript">
<!--
function pers_search() {
    var i_gubun = document.form1.I_GUBUN[document.form1.I_GUBUN.selectedIndex].value;

    if( i_gubun == "1" ) {                   //사번검색
        var val = document.form1.I_VALUE1.value;
        val = rtrim(ltrim(val));

        if ( val == "" ) {
            alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED'/>");   // 검색할 부서원 사번을 입력하세요
            document.form1.I_VALUE1.focus();

            return;
        } else {
            document.form1.jobid.value = "pernr";
        }
    } else if( i_gubun == "2" ) {            //성명검색
    	var val1 = document.form1.I_VALUE1.value;
        val1 = rtrim(ltrim(val1));

        if ( val1 == "" ) {
            alert("<spring:message code='MSG.F.FCOMMON.0004'/>");   // 검색할 부서원 성명을 입력하세요
            document.form1.I_VALUE1.focus();

            return;
        } else {
            if( val1.length < 2 ) {
                alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.MIN'/>");    //검색할 성명을 한 글자 이상 입력하세요
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
    small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=450,top=0");
<%
    } else {
%>
    small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=450,top=00");
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
    small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=500,left=450,top=0");
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


    <div class="tableInquiry">
      <table>
		<colgroup>
			<col width="4%" />
			${ e_retir eq ("Y") ? '<col width="7%" />':''}
			<col width="20%" />
			<col width="20%" />
			<col  />
		</colgroup>

        <tr>
        	<th><img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" /></th>

<%    if( e_retir.equals("Y") ) {%>
          <th >
           	<span><!--퇴직자조회--><%=g.getMessage("LABEL.COMMON.0012")%></span>
           	<input type="checkbox" name="RETIR" <%= retir_chk.equals("X") ? "checked" : "" %> >
          </th>
<%    }%>

          <td>
            <select name="I_GUBUN" onChange="javascript:gubun_change()">
              <option value="2"><!--성명별--><%=g.getMessage("LABEL.COMMON.0004")%></option>
              <option value="1"><!--사번별--><%=g.getMessage("LABEL.COMMON.0005")%></option>
            </select>
          	<input type="text"  name="I_VALUE1" size="17"  maxlength="10"  value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
            <input type="hidden" name="jobid"     value="">
				<div class="tableBtnSearch tableBtnSearch2">
              		<a class="search unloading" onclick="pers_search();"><span><!--사원찾기-->
              		<%=g.getMessage("LABEL.COMMON.0006")%></span></a>
				</div>
          </td>

          <td>
          		<img class="searchIcon" src="<%= WebUtil.ImageURL %>sshr/icon_map_g.gif" />
				<div class="tableBtnSearch tableBtnSearch2" >
              		<a class="search unloading" onclick="organ_search();"><span><!--조직도로 찾기-->
              		<%=g.getMessage("LABEL.COMMON.0011")%></span></a>
				</div>
          </td>

        </tr>
      </table>
         <input type="hidden" name="I_DEPT"   value="<%= user.empNo  %>">
         <input type="hidden" name="E_RETIR"  value="<%= user.e_retir %>">
         <input type="hidden" name="page"     value="">
         <input type="hidden" name="count"    value="<%= l_count %>">
         <input type="hidden" name="retir_chk" value="<%=retir_chk%>">

    </div>

<% if("X".equals(user_m.e_mss)) { %>
    <c:if test="${param.hideHeader != true}">
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral perInfo">
				<colgroup>
					<col width="12%" />
					<col  />

					<col width="15%" />
					<col width="15%" />

					<col width="11%" />
					<col width="8%" />

					<col width="10%" />
					<col width="18%" />
				</colgroup>
			  <tr>
			    <th><!--부서--><%=g.getMessage("LABEL.COMMON.0007")%></th>
			    <td><input class="noBorder" size="35" type="text" id="n_e_orgtx" name="n_e_orgtx" value="<%= user_m != null ? user_m.e_orgtx : " " %>" readonly></td>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              	<%--<th class="th02"><!--직위--><%=g.getMessage("LABEL.COMMON.0008")%></th> --%>
              	<th class="th02"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
			   	<td><input class="noBorder" size="16" type="text" id="n_e_titel"  name="n_e_titel" value="<%= user_m != null ? user_m.e_titel : " " %>" readonly></td>
			   	<th class="th02"><!--직책--><%=g.getMessage("LABEL.COMMON.0009")%></th>
			  	<td><input class="noBorder" size="12"  type="text" id="n_e_titl2" name="n_e_titl2" value="<%= user_m != null ? user_m.e_titl2 : " " %>" readonly></td>
			  	<th class="th02"><!--성명--><%=g.getMessage("LABEL.COMMON.0010")%></th>
			  	<td>
			  	<div id="view_ename" >
			  	<%= user_m != null ? user_m.ename : " " %><%= user_m != null ? "(" : "" %><%= user_m != null ? user_m.empNo : " " %><%= user_m != null ? ")" : "" %>
			  	</div>

			  		<input class="noBorder"  type="hidden" id="n_ename" name="n_ename" value="<%= user_m != null ? user_m.ename : " " %>" readonly>
					<input class="noBorder"  type="hidden" id="n_empNo" name="n_empNo" value="<%= user_m != null ? "(" : "" %><%= user_m != null ? user_m.empNo : " " %><%= user_m != null ? ")" : "" %>" readonly>
				</td>
			  </tr>
			</table>
		</div>
	</div>
    </c:if>
<%  } %>
<%--*****************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 검색하는 include 파일                                  */
/*   Program ID   : SearchDeptPersons.jsp                                       */
/*   Description  : 사원 검색하는 include 파일                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-26  이승희                                          */
/*   Update       : 2005-02-14  윤정현                                          */
/*                      2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건  */
/*******************************************************************************--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.common.*"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.rfc.PersonInfoRFC" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function pers_search()
    {
        i_gubun = document.form1.I_GUBUN.value;

        if( i_gubun == "1" ) {                   //사번검색

            val = document.form1.I_VALUE1.value;
            val = rtrim(ltrim(val));

            if ( val == "" ) {
                alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED' />"); //검색할 부서원 사번을 입력하세요!
                document.form1.I_VALUE1.focus();
                return;
            } else {
                document.form1.jobid.value = "pernr";
            } // end if
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
                } // end if
            } // end if
        } // end if

        //  2002.08.20. 퇴직자 검색이 check되었는지 여부 ---------------
        document.form1.retir_chk.value = "";
        //  ------------------------------------------------------------
        small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=100,top=100");
        small_window.focus();

        document.form1.target = "DeptPers";
        document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsWait.jsp";
        document.form1.submit();
    } // end function


    //조직도 검사Popup.
    function organ_search()
    {
        //세션에 권한코드가 준비되지 않아 권한 코드값 입력으로 임시처리함.
        if( document.form1.hdn_popCode.value == "A" ){ //조직도와 상세.
            small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=800,height=500,left=100,top=100");
            small_window.focus();
            document.form1.target = "Organ";
            document.form1.action = "<%=WebUtil.JspURL%>"+"common/OrganListFramePop.jsp";
            document.form1.submit();
        } else {  //조직도만...
            small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=320,height=500,left=100,top=100");
            small_window.focus();
            document.form1.target = "Organ";
            document.form1.action = "<%=WebUtil.JspURL%>"+"common/OrganListPop.jsp";
            document.form1.submit();
        } // end if
    }

    function EnterCheck()
    {
        if (event.keyCode == 13)  {
            pers_search();
        } // end if
    } // end function

    function gubun_change()
    {
        document.form1.I_VALUE1.value    = "";
        document.form1.I_VALUE1.focus();
    } // end function
//-->
</SCRIPT>
<%
    String pernr  = (String)request.getParameter("PERNR");
    if (pernr == null || pernr.equals("")) {
        pernr = user.empNo;
    } // end if

    // 대리 신청 추가
    PersonInfoRFC  onumfunc = new PersonInfoRFC();
    PersonData oPersonData;
    oPersonData = (PersonData)onumfunc.getPersonInfo(pernr);
%>
   <tr>
    <td>
      <table width="780" height="29" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td background="<%= WebUtil.ImageURL %>bg_search.gif">
            <table width="468" height="29" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="152" align="center"><img src="<%= WebUtil.ImageURL %>search01.gif"></td>
                <td width="1"><img src="../images/line_dot.gif" width="1" height="28"></td>
                <td width="70" align="center"><font color="#585858"><spring:message code='LABEL.COMMON.0003' /><!-- 선택구분 --></font></td>
                <td width="70"><select name="I_GUBUN" class="input03" onChange="javascript:gubun_change()">
                    <option value="2" ><spring:message code='LABEL.COMMON.0020' /><!-- 성명별 --></option>
                    <option value="1" ><spring:message code='LABEL.COMMON.0005' /><!-- 사번별 --></option>
                  </select></td>
                <td width="80"> <input type="text"   name="I_VALUE1" size="10"  maxlength="10"  class="input03" value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                <td width="95"><a href="javascript:pers_search();"><img src="<%= WebUtil.ImageURL %>btn_serch04.gif" border="0"></a></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <table width="780" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td style="padding-left:40px;padding-top:3px;padding-bottom:3px;">
          </td>
        </tr>
        <tr>
        </tr>
        <input type="hidden" name="retir_chk" value="">
    </table>
      <table width="780" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td style="padding-left:40px;padding-top:3px;padding-bottom:3px;">
            <spring:message code='LABEL.COMMON.0007' /><!-- 부서 --> : <input class="input03" size="30" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_ORGTX%>" readonly>
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
            <%--<spring:message code='LABEL.COMMON.0008' /><!-- 직위 --> --%>
            <spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 -->
            <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
            : <input class="input03" size="20" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_TITEL%>" readonly>
            <spring:message code='LABEL.COMMON.0009' /><!-- 직책 --> : <input class="input03" size="20" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_TITL2%>" readonly>
            <spring:message code='MSG.APPROVAL.0013' /><!-- 성명 --> : <input class="input03" size="8" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_ENAME%>" readonly>
            <input class="input03" size="9" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_PERNR%>" readonly>
          </td>
        </tr>
        <tr>
          <td bgcolor="#b7a68a"><img src="<%= WebUtil.ImageURL %>ehr/space.gif" width="1" height="1"></td>
        </tr>
        <input type="hidden" name="I_DEPT"   value="<%=oPersonData.E_PERNR%>">
        <input type="hidden" name="retir_chk" value="">
    </table>
    <table width="780" height="4" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="3"></td>
        <td><img src="<%= WebUtil.ImageURL %>ehr/space.gif" height="4"></td>
        <td width="3"></td>
      </tr>
    </table>
    </td></tr>
  <!--   사원검색 보여주는 부분  끝    -->
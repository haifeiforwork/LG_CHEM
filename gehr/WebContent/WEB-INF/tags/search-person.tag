<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag import="hris.common.PersonData" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="extraData" required="true" type="hris.A.A01SelfDetailArmyData" %>
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
/*                                                                              */
/*******************************************************************************--%>
<SCRIPT LANGUAGE="JavaScript">
    <!--
    function pers_search() {
        //  ------------------------------------------------------------
        var win = window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=100,top=100");
        document.form1.target = "DeptPers";
        document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchDeptPersonsWait.jsp";
        document.form1.submit();
        win.focus();
    } // end function

    //조직도 검사Popup.
    function organ_search() {
        //세션에 권한코드가 준비되지 않아 권한 코드값 입력으로 임시처리함.
        if( document.form1.hdn_popCode.value == "A" ){ //조직도와 상세.
            small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=500,left=100,top=100");
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
    PersonData oPersonData = (PersonData)request.getAttribute("PersonData");
%>
<tr>
    <td>
        <style type="text/css">
            .tb_box1 td, .tb_box1 td input, .tb_box1 td img {vertical-align:middle;}
            .tb_box1  {margin-top:0px;color:#888}
        </style>

        <div class="tableInquiry">
            <table >
                <tr>
                    <th><!--선택구분--><spring:message code="LABEL.COMMON.0003" /></th>
                    <td width="40">
                        <select name="I_GUBUN" onChange="javascript:gubun_change()">
                            <option value="2" ><!--성명별--><spring:message code="LABEL.COMMON.0004" /></option>
                            <option value="1" ><!--사번별--><spring:message code="LABEL.COMMON.0005" /></option>
                        </select>
                    </td>
                    <td>
                        <input type="text"  name="I_VALUE1" size="16"  maxlength="10"  value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                        <div class="tableBtnSearch tableBtnSearch2" >
                            <a class="search" href="javascript:pers_search();"><span><!--사원찾기--><spring:message code="LABEL.COMMON.0006" /></span></a>
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                    <colgroup>
                        <col width="10%" />
                        <col width="15%" />
                        <col width="10%" />
                        <col width="15%" />
                        <col width="10%" />
                        <col width="15%" />
                        <col width="13%" />
                        <col width="12%" />
                    </colgroup>

                    <tr>
                        <th><spring:message code="MSG.APPROVAL.0007" /><!-- 작성자 --></th>
                        <td>${PersonData}</td>
                        <th><spring:message code="MSG.APPROVAL.0009" /><!-- 보존년한 --></th>
                        <td><spring:message code="MSG.APPROVAL.0010" /><!-- 영구 --></td>

                        <th><!--부서--><spring:message code="LABEL.COMMON.0007" /></th>
                        <td><input class="" size="25" style="border-width:0;" type="text" value="<%=oPersonData.E_ORGTX%>" readonly><td>
	                	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    		        	<%--<th class="th02"><!--직위--><spring:message code="LABEL.COMMON.0008" /></th> --%>
    		        	<th class="th02"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
                    	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                        <td><input class="" size="12" style="border-width:0;" type="text" value="<%=oPersonData.E_JIKWT%>" readonly></td>
                        <th class="th02"><!--직책--><spring:message code="LABEL.COMMON.0009" /></th>
                        <td><input class="" size="12" style="border-width:0;" type="text" value="<%=oPersonData.E_JIKKT%>" readonly></td>
                        <th class="th02"><!--성명--><spring:message code="LABEL.COMMON.0010" /></th>
                        <td><input class="" size="8" style="border-width:0;" type="text" value="<%=oPersonData.E_ENAME%>" readonly></td>
                        <td><input class="" size="9" style="border-width:0;text-align:left" type="text" value="<%=oPersonData.E_PERNR%>" readonly></td>
                        </td>
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
            </div>
        </div>
        <!--   사원검색 보여주는 부분  끝    -->
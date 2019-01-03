<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 4개년 상대화 평가                                    */
/*   Program ID   : F31Dept4YearValuation.jsp                                   */
/*   Description  : 부서별 4개년 상대화 평가 조회를 위한 jsp 파일               */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-01 유용원                                           */
/*   Update       :                                                             */
/*                  2013-05-24  CSR ID:99999 현장직( 전문기술직(실장 포함) 31 , 기능직33)은 무조건 조회   */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정  */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/*					 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.common.constant.Area" %>
<%@ page import="hris.B.db.B01ValuateDetailDB" %>
<%@ page import="hris.F.F23DeptLanguageData" %>
<%@ page import="hris.F.F31Dept4YearValuationData" %>
<%@ page import="hris.N.AES.AESgenerUtil" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector Dept4YearValuation_vt = (Vector)request.getAttribute("Dept4YearValuation_vt");
    B01ValuateDetailDB valuateDetailDB = new B01ValuateDetailDB();
    String StartDate  = valuateDetailDB.getBossStartDate();
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

%>


<jsp:include page="/include/header.jsp"/>

<SCRIPT LANGUAGE="JavaScript">
<!--

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
        alert("<%=g.getMessage("MSG.F.F41.0003")%> "); //선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.
        return;
    }

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F31Dept4YearValuationSV";
    frm.target = "_self";
    frm.submit();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F31Dept4YearValuationSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>
<jsp:include page="/include/body-header.jsp"/>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >

    <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!--부서명  --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
<%
    //부서명, 조회된 건수.
    if ( Dept4YearValuation_vt != null && Dept4YearValuation_vt.size() > 0 ) {
%>
    <div class="listArea">
        <div class="listTop">
            <div class="listCnt"><<!--총--><spring:message code='LABEL.F.FCOMMON.0006'/> <%=Dept4YearValuation_vt.size()%><!--건--><spring:message code='LABEL.F.FCOMMON.0007'/>></div>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a  onClick="javascript:excelDown();" class="unloading"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <%
            if( user.area == Area.KR ){
        %>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
                <thead>
                <tr>
                    <th nowrap><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
                    <th nowrap><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
                    <th nowrap><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
                    <th nowrap><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
				    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    	            <%--<th nowrap><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
        	        <th nowrap><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
            	    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                    <th nowrap><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
                    <th nowrap><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
                    <th nowrap><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
                    <th nowrap><spring:message code="LABEL.F.F41.0012"/><!-- 입사일자 --></th>
                    <th nowrap>P</th>
                    <th nowrap>P-1</th>
                    <th nowrap>P-2</th>
                    <th nowrap class="lastCol">P-3</th>
                </tr>
                </thead>

                <%
                    for( int i = 0; i < Dept4YearValuation_vt.size(); i++ ){
                        F31Dept4YearValuationData data = (F31Dept4YearValuationData)Dept4YearValuation_vt.get(i);
                %>
                <tr class="<%=WebUtil.printOddRow(i)%>">
                    <td nowrap>&nbsp;<a style="cursor: pointer;" onclick="parent.popupView('orgView','1024','700','<%= AESgenerUtil.encryptAES(data.PERNR, request) %>');"><font color=blue><%= data.PERNR %></font></a></td>
                    <td nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.ORGTX %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JIKKT %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JIKWT %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JIKCT %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.TRFST %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.VGLST %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>


                    <%--<%          //CSR ID:99999 전무기술직,기능직은 무조건 조회하기, [CSR ID:2583929] 생산기술직 38 추가--%>
                        <%--if( ( data.PERSK.equals("31")||data.PERSK.equals("33") ||data.PERSK.equals("38") ) || ( Long.parseLong(StartDate) <= Long.parseLong(DataUtil.getCurrentDate()) ) ) {--%>
                    <%--%>--%>
                    <td nowrap>&nbsp;<%= data.D1 %>&nbsp;</td>
                    <%--<%          } else {--%>
                    <%--%>--%>
                    <%--<td nowrap>&nbsp;&nbsp;</td>--%>
                    <%--<%          }--%>
                    <%--%>--%>

                    <td nowrap>&nbsp;<%= data.D2 %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.D3 %>&nbsp;</td>
                    <td nowrap class="lastCol">&nbsp;<%= data.D4 %>&nbsp;</td>
                </tr>
                <%
                    } //end for...
                %>
            </table>
        </div>
        <%
        }else{
        %>


        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
                <thead>
                <tr>
                    <th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
                    <th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
                    <th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
                    <th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
                    <th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
				    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    	            <%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
        	        <th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
            	    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
                    <th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
                    <th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
                    <th nowrap>P-1</th>
                    <th nowrap>P-2</th>
                    <th nowrap>P-3</th>
                    <th class="lastCol" nowrap>P-4</th>
                </tr>
                </thead>

                <%
                    for( int i = 0; i < Dept4YearValuation_vt.size(); i++ ){
                        F31Dept4YearValuationData data = (F31Dept4YearValuationData) Dept4YearValuation_vt.get(i);
                %>
                <tr class="<%=WebUtil.printOddRow(i)%>">
                    <td nowrap>&nbsp;<%= data.NAME1 %>&nbsp;</td>
                    <td nowrap><a style="cursor: pointer;" onclick="parent.popupView('orgView','1024','700','<%= AESgenerUtil.encryptAES(data.PERNR, request) %>');"><font color=blue><%= data.PERNR %></font></a></td>
                    <td nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.ORGTX %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JIKKT %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JIKWT %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.VGLST %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= (data.DAT01).replace("-","").replace(".","").equals("00000000") ? "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
                    <td nowrap >&nbsp;<%= data.D1 %>&nbsp;</td>
                    <td nowrap >&nbsp;<%= data.D2 %>&nbsp;</td>
                    <td nowrap >&nbsp;<%= data.D3%>&nbsp;</td>
                    <td nowrap >&nbsp;<%= data.D4 %>&nbsp;</td>
                </tr>
                <%
                    } //end for...
                %>

            </table>
        </div>
        <%
            }
        %>
        <div class="buttonArea">
            <ul class="btn_mdl">
                <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
            </ul>
        </div>
    </div>

<%
    }else{
%>
    <div class="align_center">
        <p><spring:message code="MSG.F.FCOMMON.0002"/><!-- 해당하는 데이터가 존재하지 않습니다. --></p>
    </div>
<%
    } //end if...
%>
</form>
<jsp:include page="/include/body-footer.jsp"/>

<jsp:include page="/include/footer.jsp"/>
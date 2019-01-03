<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 어학 인정점수 조회                                   */
/*   Program ID   : F23DeptLanguage.jsp                                         */
/*   Description  : 부서별 어학 인정점수 조회를 위한 jsp 파일                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-28 유용원                                           */
/*   Update       : 2012-12-20 신HSK추가  C20121218_37795                       */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정  */
/*                  2015-01-13 [CSR ID:2680133] 조직 통계 內 외국어 기준 삭제 요청                                                             */
/*                  2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건   */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.common.constant.Area" %>
<%@ page import="hris.F.F23DeptLanguageData" %>
<%@ page import="hris.N.AES.AESgenerUtil" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptLanguage_vt = (Vector)request.getAttribute("DeptLanguage_vt");
    String sortField       = WebUtil.nvl((String)request.getAttribute("sortField"));
    String sortValue       = WebUtil.nvl((String)request.getAttribute("sortValue"));
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
            alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
            return;
        }

        frm.hdn_deptId.value = deptId;
        frm.hdn_deptNm.value = deptNm;
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F23DeptLanguageSV";
        frm.target = "_self";
        frm.submit();
    }

    //Execl Down 하기.
    function excelDown() {
        frm = document.form1;

        frm.hdn_excel.value = "ED";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F23DeptLanguageSV";
        frm.target = "hidden";
        frm.submit();
    }
    //PageUtil 관련 script - page처리시 반드시 써준다...
    function get_Page(){

        document.form3.hdn_deptId.value = document.form1.hdn_deptId.value;
        document.form3.hdn_deptNm.value = document.form1.hdn_deptNm.value;
//  document.form3.chck_yeno.value   = document.form1.chck_yeno.value;
        document.form3.action = '<%= WebUtil.ServletURL %>hris.F.F23DeptLanguageSV';
        document.form3.method = 'get';
        document.form3.submit();
    }

    function sortPage( FieldName ){
        if(document.form3.sortField.value==FieldName){
            if(document.form3.sortValue.value=='desc'){
                document.form3.sortValue.value = 'asc';
            } else {
                document.form3.sortValue.value = 'desc';
            }
        } else {
            document.form3.sortField.value = FieldName;
            document.form3.sortValue.value = 'desc';
        }
        get_Page();
    }
    //-->
</SCRIPT>
<!--[CSR ID:2389767] [정보보안] e-HR MSS시스템 수정-->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="click" value="Y"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >

    <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!--부서명  --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>

    <%
    //부서명, 조회된 건수.
    if ( DeptLanguage_vt != null && DeptLanguage_vt.size() > 0 ) {
%>

    <div class="listArea">

        <div class="listTop">
            <div class="listCnt"><<!--총--><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptLanguage_vt.size()%><!--건--><spring:message code='LABEL.F.FCOMMON.0007'/>></div>
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
                    <th nowrap onClick="javascript:sortPage('ENAME')"        style="cursor:hand">이름<%=        sortField.equals("ENAME")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('ORGTX')"        style="cursor:hand">소속<%=        sortField.equals("ORGTX")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('JIKKT')"        style="cursor:hand">직책<%=        sortField.equals("JIKKT")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha start --%>
					<%--<th nowrap onClick="javascript:sortPage('JIKWT')"        style="cursor:hand">직위<%=        sortField.equals("TITEL")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th> --%>
					<th nowrap onClick="javascript:sortPage('TITEL')"        style="cursor:hand"><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --><%=        sortField.equals("TITEL")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
					<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha end --%>
                    <th nowrap onClick="javascript:sortPage('JIKCT')"        style="cursor:hand">직급<%=        sortField.equals("JIKCT")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('TRFST')"        style="cursor:hand">호봉<%=        sortField.equals("TRFST")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('VGLST')"        style="cursor:hand">연차<%=        sortField.equals("VGLST")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('DAT01')"        style="cursor:hand">입사일자<%=    sortField.equals("DAT01")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('LGA_LAP_ORAL')" style="cursor:hand">LAP ORA<%= sortField.equals("LGA_LAP_ORAL") ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('LGA_LAP_WR')"   style="cursor:hand">LAP WR<%=  sortField.equals("LGA_LAP_WR")   ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('TOEIC')"        style="cursor:hand">TOEIC<%=       sortField.equals("TOEIC")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('TOEFL')"        style="cursor:hand">TOEFL<%=       sortField.equals("TOEFL")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('JPT')"          style="cursor:hand">JPT<%=         sortField.equals("JPT")          ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('HSK')"          style="cursor:hand">HSK<%=         sortField.equals("HSK")          ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th nowrap onClick="javascript:sortPage('SEPT')"         style="cursor:hand">SEPT<%=        sortField.equals("SEPT")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th>
                    <th class="lastCol" nowrap onClick="javascript:sortPage('NHSK')"         style="cursor:hand">신HSK<%=        sortField.equals("NHSK")         ? ( sortValue.toLowerCase() ).equals("desc") ? "<font color='#FF0000'><b>▼</b></font>" : "<font color='#FF0000'><b>▲</b></font>" : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %></th><!--C20121218_37795-->
                </tr>
                </thead>

                <%
                    for( int i = 0; i < DeptLanguage_vt.size(); i++ ){
                        F23DeptLanguageData data = (F23DeptLanguageData)DeptLanguage_vt.get(i);
                %>
                <tr class="<%=WebUtil.printOddRow(i)%>">
                    <td nowrap><a style="cursor: pointer;" onclick="parent.popupView('orgView','1024','700','<%= AESgenerUtil.encryptAES(data.PERNR, request) %>');"><font color=blue><%= data.ENAME %></font></a></td>
                    <td nowrap>&nbsp;<%= data.ORGTX %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JIKKT %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JIKWT %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JIKCT %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.TRFST %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.VGLST %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.LGA_LAP_ORAL%>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.LGA_LAP_WR  %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.TOEIC %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.TOEFL %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.JPT   %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.HSK.equals("") ? "" : Integer.parseInt( data.HSK )  %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.SEPT  %>&nbsp;</td>
                    <td class="lastCol" nowrap>&nbsp;<%= data.NHSK.equals("") ? "" : Integer.parseInt(data.NHSK)   %>&nbsp;</td> <!--C20121218_37795-->
                </tr>

                <%
                    } //end for...
                %>

            </table>
        </div>
        <div class="buttonArea">
            <ul class="btn_mdl">
                <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
            </ul>
        </div>
    <%
    }else{
    %>


        <div class="table">
            <table class="listTable">
                <thead>
                <tr>
                    <th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
                    <th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
                    <th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
                    <th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
                    <th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
                    <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha start --%>
					<%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
					<th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
					<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 20170828 eunha end --%>
                    <th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
                    <th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
                    <th nowrap>CET</th>
                    <th nowrap>TOEIC</th>
                    <th nowrap>JLPT</th>
                    <th nowrap>NSS</th>
                    <th nowrap>KPT</th>
                    <th class="lastCol" nowrap>TOPIK</th>  <!--2013-05-10 dongxiaomian@v1.0 [C20130503_24510] 显示TOPIK数据   -->
                </tr>
                </thead>

                <%
                    for( int i = 0; i < DeptLanguage_vt.size(); i++ ){
                        F23DeptLanguageData data = (F23DeptLanguageData)DeptLanguage_vt.get(i);
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
                    <td nowrap>&nbsp;<%= data.LGT01 %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.LGT03 %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.LGT07 %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.LGT08 %>&nbsp;</td>
                    <td nowrap>&nbsp;<%= data.LGT09 %>&nbsp;</td>
                    <td class="lastCol" nowrap>&nbsp;<%= data.LGT12 %>&nbsp;</td> <!-- 2013-05-10 dongxiaomian@v1.0 [C20130503_24510] 显示TOPIK数据 -->
                </tr>
                <%
                    } //end for...
                %>

            </table>
        </div>
        <div class="buttonArea">
            <ul class="btn_mdl">
                <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
            </ul>
        </div>
<%
    }
%>
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

<!-- 페이지 처리를 위한 FORM -->
<form name="form3">
  <input type="hidden" name="chck_yeno"  value="">
  <input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
  <input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
</form>
<jsp:include page="/include/body-footer.jsp"/>

<jsp:include page="/include/footer.jsp"/>
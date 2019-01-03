<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 직무별/최종학력별
*   Program ID   : F09DeptDutyLastSchool.jsp
*   Description  : 직무별/최종학력별 조회를 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");                                    //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);            //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                          //부서명
    Vector DeptDutySchoolTitle_vt = (Vector)request.getAttribute("F09DeptDutySchoolTitle_vt");         //제목
    Vector DeptDutySchoolNote_vt  = (Vector)request.getAttribute("F09DeptDutySchoolNote_vt");          //내용

    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(paramA, paramB, paramC, paramD, paramE, value){
    frm = document.form1;

    if( value!= "" && value!= "0"){
        frm.hdn_gubun.value  = "09";             //직무별/최종학력별
        frm.hdn_deptId.value = "<%= deptId %>";  //조회된 부서코드.
        frm.hdn_paramA.value = paramA;           //선택된 부서코드.
        frm.hdn_paramB.value = paramB;           //선택된 부서명
        frm.hdn_paramC.value = paramC;
        frm.hdn_paramD.value = paramD;
        frm.hdn_paramE.value = paramE;
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV?sMenuCode=<%=sMenuCode%>";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F09DeptDutyLastSchoolSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>
<jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_sText"   value="">
<input type="hidden" name="hdn_paramA"  value="">
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="">
<input type="hidden" name="hdn_paramE"  value="">

<%
    if ( DeptDutySchoolTitle_vt != null && DeptDutySchoolTitle_vt.size() > 0 ) {
%>


    <div class="listArea">
    	<div class="listTop">
    		<h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
    		<div class="buttonArea">
    			<ul class="btn_mdl">
    				<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
    			</ul>
    		</div>
    	</div>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
            	<thead>
                <tr>
                    <th colspan="2"><spring:message code='LABEL.F.F04.0001'/></th>
<%
            //타이틀.
            for( int k = 0; k < DeptDutySchoolTitle_vt.size()-1; k++ ){
            	F09DeptDutyLastSchoolTitleData titleData = (F09DeptDutyLastSchoolTitleData)DeptDutySchoolTitle_vt.get(k);
%>
                    <th nowrap width="75"><%=titleData.STYPE_TEXT%></th>
<%
            }//end for
%>
                    <th><spring:message code='LABEL.F.F04.0002'/></th>
                </tr>
<%
            //타이틀에 맞추어 내용영역 보여주기위한 개수.
            int noteSize    = DeptDutySchoolTitle_vt.size();
            int setCnt      = 0;
            String titlClass = "";
            String noteClass = "";

            //내용.
            for( int i = 0; i < DeptDutySchoolNote_vt.size(); i++ ){
            	F09DeptDutyLastSchoolNoteData data = (F09DeptDutyLastSchoolNoteData)DeptDutySchoolNote_vt.get(i);

                //클래스 설정.
                if (i != DeptDutySchoolNote_vt.size()-1) {
                    titlClass = "";
                    noteClass = "";
                } else {  //합계부분을 위해.
                    titlClass = "class=td11";
                    noteClass = "class=td12";
                }
%>
				</thead>
                <tr class="borderRow">
<%
                //내용 타이틀 병합.
                int noteCnt     = 1;
                String noteCode  = "";
                //병합이 끝나고 마지막(합계) 부분이 아닐 때
                if ( setCnt == i && i < DeptDutySchoolNote_vt.size()-1) {
                    for( int inx = i; inx < DeptDutySchoolNote_vt.size(); inx++ ){
                    	F09DeptDutyLastSchoolNoteData dataTitl = (F09DeptDutyLastSchoolNoteData)DeptDutySchoolNote_vt.get(inx);

                        //병합을 위한 비교.
                        if( dataTitl.JIKK_TYPE.equals(noteCode) ){
                            noteCnt++;
                        }else{
                            //병합부분 보여줌.(소계를 포함하여 적어도 2건 이상)
                            if( noteCnt>1 ){
%>
                    <td nowrap <%=titlClass%> rowspan="<%=noteCnt%>" ><%=data.JIKK_TEXT%></td>
<%
                                setCnt = setCnt+noteCnt;
                                break;
                            }

                        } //end if
                        noteCode = dataTitl.JIKK_TYPE;
                    } //end for.
                } //end if

                //마지막 합계 부분일 경우 colspan 실시.
                if (i>0 && i == DeptDutySchoolNote_vt.size()-1) {
%>
                    <td class="td11" colspan="2" ><%=data.JIKK_TEXT%></td>
<%
                //병합 후 다음 타이틀 리스트 보여줌.
                }else{
                    if(data.JIKK_TEXT.equals("소 계")){
                        titlClass = "class=td04";
                    }
%>
                    <td nowrap <%=titlClass%> ><%=data.JIKL_TEXT%></td>
<%
                }
%>
          <td <%=noteClass%> ><a href="javascript:goDetail('<%=data.JIKK_TYPE%>','<%=data.JIKK_TEXT%>','<%=data.JIKL_TYPE%>','<%=data.TITLACD1%>','<%=data.F1%>');"><%=WebUtil.printNumFormat(data.F1)%></a></td>
          <td <%=noteClass%> ><a href="javascript:goDetail('<%=data.JIKK_TYPE%>','<%=data.JIKK_TEXT%>','<%=data.JIKL_TYPE%>','<%=data.TITLACD2%>','<%=data.F2%>');"><%=WebUtil.printNumFormat(data.F2)%></a></td>
          <% if( noteSize >= 3 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD3 +"','"+data.F3+"');\">" +WebUtil.printNumFormat(data.F3) +"</a></td>"); %>
          <% if( noteSize >= 4 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD4 +"','"+data.F4+"');\">" +WebUtil.printNumFormat(data.F4) +"</a></td>"); %>
          <% if( noteSize >= 5 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD5 +"','"+data.F5+"');\">" +WebUtil.printNumFormat(data.F5) +"</a></td>"); %>
          <% if( noteSize >= 6 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD6 +"','"+data.F6+"');\">" +WebUtil.printNumFormat(data.F6) +"</a></td>"); %>
          <% if( noteSize >= 7 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD7 +"','"+data.F7+"');\">" +WebUtil.printNumFormat(data.F7) +"</a></td>"); %>
          <% if( noteSize >= 8 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD8 +"','"+data.F8+"');\">" +WebUtil.printNumFormat(data.F8) +"</a></td>"); %>
          <% if( noteSize >= 9 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD9 +"','"+data.F9+"');\">" +WebUtil.printNumFormat(data.F9) +"</a></td>"); %>
          <% if( noteSize >= 10 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD10+"','"+data.F10+"');\">"+WebUtil.printNumFormat(data.F10)+"</a></td>"); %>
          <% if( noteSize >= 11 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD11+"','"+data.F11+"');\">"+WebUtil.printNumFormat(data.F11)+"</a></td>"); %>
          <% if( noteSize >= 12 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD12+"','"+data.F12+"');\">"+WebUtil.printNumFormat(data.F12)+"</a></td>"); %>
          <% if( noteSize >= 13 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD13+"','"+data.F13+"');\">"+WebUtil.printNumFormat(data.F13)+"</a></td>"); %>
          <% if( noteSize >= 14 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD14+"','"+data.F14+"');\">"+WebUtil.printNumFormat(data.F14)+"</a></td>"); %>
          <% if( noteSize >= 15 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD15+"','"+data.F15+"');\">"+WebUtil.printNumFormat(data.F15)+"</a></td>"); %>
          <% if( noteSize >= 16 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD16+"','"+data.F16+"');\">"+WebUtil.printNumFormat(data.F16)+"</a></td>"); %>
          <% if( noteSize >= 17 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD17+"','"+data.F17+"');\">"+WebUtil.printNumFormat(data.F17)+"</a></td>"); %>
          <% if( noteSize >= 18 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD18+"','"+data.F18+"');\">"+WebUtil.printNumFormat(data.F18)+"</a></td>"); %>
          <% if( noteSize >= 19 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD19+"','"+data.F19+"');\">"+WebUtil.printNumFormat(data.F19)+"</a></td>"); %>
          <% if( noteSize >= 20 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD20+"','"+data.F20+"');\">"+WebUtil.printNumFormat(data.F20)+"</a></td>"); %>
          <% if( noteSize >= 21 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD21+"','"+data.F21+"');\">"+WebUtil.printNumFormat(data.F21)+"</a></td>"); %>
          <% if( noteSize >= 22 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD22+"','"+data.F22+"');\">"+WebUtil.printNumFormat(data.F22)+"</a></td>"); %>
          <% if( noteSize >= 23 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD23+"','"+data.F23+"');\">"+WebUtil.printNumFormat(data.F23)+"</a></td>"); %>
          <% if( noteSize >= 24 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD24+"','"+data.F24+"');\">"+WebUtil.printNumFormat(data.F24)+"</a></td>"); %>
          <% if( noteSize >= 25 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD25+"','"+data.F25+"');\">"+WebUtil.printNumFormat(data.F25)+"</a></td>"); %>
          <% if( noteSize >= 26 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD26+"','"+data.F26+"');\">"+WebUtil.printNumFormat(data.F26)+"</a></td>"); %>
          <% if( noteSize >= 27 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD27+"','"+data.F27+"');\">"+WebUtil.printNumFormat(data.F27)+"</a></td>"); %>
          <% if( noteSize >= 28 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD28+"','"+data.F28+"');\">"+WebUtil.printNumFormat(data.F28)+"</a></td>"); %>
          <% if( noteSize >= 29 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD29+"','"+data.F29+"');\">"+WebUtil.printNumFormat(data.F29)+"</a></td>"); %>
          <% if( noteSize >= 30 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD30+"','"+data.F30+"');\">"+WebUtil.printNumFormat(data.F30)+"</a></td>"); %>
          <% if( noteSize >= 31 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD31+"','"+data.F31+"');\">"+WebUtil.printNumFormat(data.F31)+"</a></td>"); %>
          <% if( noteSize >= 32 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD32+"','"+data.F32+"');\">"+WebUtil.printNumFormat(data.F32)+"</a></td>"); %>
          <% if( noteSize >= 33 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD33+"','"+data.F33+"');\">"+WebUtil.printNumFormat(data.F33)+"</a></td>"); %>
          <% if( noteSize >= 34 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD34+"','"+data.F34+"');\">"+WebUtil.printNumFormat(data.F34)+"</a></td>"); %>
          <% if( noteSize >= 35 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD35+"','"+data.F35+"');\">"+WebUtil.printNumFormat(data.F35)+"</a></td>"); %>
          <% if( noteSize >= 36 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD36+"','"+data.F36+"');\">"+WebUtil.printNumFormat(data.F36)+"</a></td>"); %>
          <% if( noteSize >= 37 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD37+"','"+data.F37+"');\">"+WebUtil.printNumFormat(data.F37)+"</a></td>"); %>
          <% if( noteSize >= 38 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD38+"','"+data.F38+"');\">"+WebUtil.printNumFormat(data.F38)+"</a></td>"); %>
          <% if( noteSize >= 39 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD39+"','"+data.F39+"');\">"+WebUtil.printNumFormat(data.F39)+"</a></td>"); %>
          <% if( noteSize >= 40 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD40+"','"+data.F40+"');\">"+WebUtil.printNumFormat(data.F40)+"</a></td>"); %>
          <% if( noteSize >= 41 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD41+"','"+data.F41+"');\">"+WebUtil.printNumFormat(data.F41)+"</a></td>"); %>
          <% if( noteSize >= 42 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD42+"','"+data.F42+"');\">"+WebUtil.printNumFormat(data.F42)+"</a></td>"); %>
          <% if( noteSize >= 43 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD43+"','"+data.F43+"');\">"+WebUtil.printNumFormat(data.F43)+"</a></td>"); %>
          <% if( noteSize >= 44 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD44+"','"+data.F44+"');\">"+WebUtil.printNumFormat(data.F44)+"</a></td>"); %>
          <% if( noteSize >= 45 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD45+"','"+data.F45+"');\">"+WebUtil.printNumFormat(data.F45)+"</a></td>"); %>
          <% if( noteSize >= 46 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD46+"','"+data.F46+"');\">"+WebUtil.printNumFormat(data.F46)+"</a></td>"); %>
          <% if( noteSize >= 47 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD47+"','"+data.F47+"');\">"+WebUtil.printNumFormat(data.F47)+"</a></td>"); %>
          <% if( noteSize >= 48 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD48+"','"+data.F48+"');\">"+WebUtil.printNumFormat(data.F48)+"</a></td>"); %>
          <% if( noteSize >= 49 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD49+"','"+data.F49+"');\">"+WebUtil.printNumFormat(data.F49)+"</a></td>"); %>
          <% if( noteSize >= 50 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.JIKK_TYPE+"','"+data.JIKK_TEXT+"','"+data.JIKL_TYPE+"','"+data.TITLACD50+"','"+data.F50+"');\">"+WebUtil.printNumFormat(data.F50)+"</a></td>"); %>             </tr>
<%
                } //end for...
%>
            </table>
        </div>
    </div>

</div>

<%
    }else{
%>

    <div class="align_center">
        <p><spring:message code='MSG.F.FCOMMON.0002'/></p>
    </div>

</div>
<%
    } //end if...
%>
</form>
</body>
</html>


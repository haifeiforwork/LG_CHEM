<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 직책별/직급별 인원현황
*   Program ID   : F05DeptGradeClass.jsp
*   Description  : 직책별/직급별 인원현황 조회를 위한 jsp 파일
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
    Vector F05DeptGradeClassTitle_vt = (Vector)request.getAttribute("F05DeptGradeClassTitle_vt");   //제목
    Vector F05DeptGradeClassNote_vt  = (Vector)request.getAttribute("F05DeptGradeClassNote_vt");    //내용

    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(paramA, paramB, paramC, value){
    frm = document.form1;

    if( value!= "" && value!= "0"){
        if(paramB!= ""){
            paramB = paramB.substring(6,8);
        }
        frm.hdn_gubun.value  = "05";             //직책별/직급별 인원현황
        frm.hdn_deptId.value = "<%= deptId %>";  //조회된 부서코드.
        frm.hdn_paramA.value = paramA;           //선택된 부서코드.
        frm.hdn_paramB.value = paramB;           //선택된 부서명
        frm.hdn_paramC.value = paramC;
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
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F05DeptGradeClassSV";
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
    if ( F05DeptGradeClassTitle_vt != null && F05DeptGradeClassTitle_vt.size() > 0 ) {
%>

    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
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
                    <th rowspan="2" rowspan="2"><spring:message code='LABEL.F.F04.0001'/></th>
<%
            String tempTitleCode = ""; //임시 타이틀코드
            String tempTitleName = ""; //임시 타이틀명
            int    tempCnt       = 1;

            //상위 타이틀.
            for( int h = 0; h < F05DeptGradeClassTitle_vt.size(); h++ ){
                F05DeptGradeClassTitleData titleData = (F05DeptGradeClassTitleData)F05DeptGradeClassTitle_vt.get(h);

                if( titleData.PERSK.equals(tempTitleCode) ){
                    tempCnt++;
                }else{
                    if( h > 0 ){
%>
                    <th colspan="<%=tempCnt%>"><%=tempTitleName%></th>
<%                          tempCnt = 1;
                    }
                }
                tempTitleCode = titleData.PERSK;
                tempTitleName = titleData.PTEXT;
            }//end for
%>
                    <th rowspan="2"><spring:message code='LABEL.F.F04.0002'/></th>
                </tr>
                <tr>
<%
            //하위 타이틀.
            for( int k = 0; k < F05DeptGradeClassTitle_vt.size()-1; k++ ){
                F05DeptGradeClassTitleData titleData = (F05DeptGradeClassTitleData)F05DeptGradeClassTitle_vt.get(k);
%>
                    <th width="50" nowrap><%=titleData.TRFGR%></th>
<%
            }//end for

            //타이틀에 맞추어 내용영역 보여주기위한 개수.
            int noteSize = F05DeptGradeClassTitle_vt.size();
            //내용.
            for( int i = 0; i < F05DeptGradeClassNote_vt.size(); i++ ){
                F05DeptGradeClassNoteData data = (F05DeptGradeClassNoteData)F05DeptGradeClassNote_vt.get(i);

                String titlClass = "";
                String noteClass = "";
                //클래스 설정.
                if ( i < F05DeptGradeClassNote_vt.size()-1) {
                    titlClass = "";
                    noteClass = "";
                } else {
                    titlClass = "class=td11";
                    noteClass = "class=td12";
                }
%>
		</tr>
		</thead>
        <tr class="borderRow">
          <td nowrap <%=titlClass%> nowrap>&nbsp;&nbsp;<%=data.TITL2%>&nbsp;&nbsp;</td>
          <td <%=noteClass%> ><a href="javascript:goDetail('<%=data.TITL2%>','<%=data.TITLACD1%>','<%=data.TITLBCD1%>','<%=data.F1%>');"><%=WebUtil.printNumFormat(data.F1)%></a></td>
          <td <%=noteClass%> ><a href="javascript:goDetail('<%=data.TITL2%>','<%=data.TITLACD2%>','<%=data.TITLBCD2%>','<%=data.F2%>');"><%=WebUtil.printNumFormat(data.F2)%></a></td>
          <td <%=noteClass%> ><a href="javascript:goDetail('<%=data.TITL2%>','<%=data.TITLACD3%>','<%=data.TITLBCD3%>','<%=data.F3%>');"><%=WebUtil.printNumFormat(data.F3)%></a></td>
          <% if( noteSize >= 4 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD4 +"','"+data.TITLBCD4 +"','"+data.F4+"');\">" +WebUtil.printNumFormat(data.F4) +"</a></td>"); %>
          <% if( noteSize >= 5 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD5 +"','"+data.TITLBCD5 +"','"+data.F5+"');\">" +WebUtil.printNumFormat(data.F5) +"</a></td>"); %>
          <% if( noteSize >= 6 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD6 +"','"+data.TITLBCD6 +"','"+data.F6+"');\">" +WebUtil.printNumFormat(data.F6) +"</a></td>"); %>
          <% if( noteSize >= 7 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD7 +"','"+data.TITLBCD7 +"','"+data.F7+"');\">" +WebUtil.printNumFormat(data.F7) +"</a></td>"); %>
          <% if( noteSize >= 8 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD8 +"','"+data.TITLBCD8 +"','"+data.F8+"');\">" +WebUtil.printNumFormat(data.F8) +"</a></td>"); %>
          <% if( noteSize >= 9 )   out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD9 +"','"+data.TITLBCD9 +"','"+data.F9+"');\">" +WebUtil.printNumFormat(data.F9) +"</a></td>"); %>
          <% if( noteSize >= 10 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD10+"','"+data.TITLBCD10+"','"+data.F10+"');\">"+WebUtil.printNumFormat(data.F10)+"</a></td>"); %>
          <% if( noteSize >= 11 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD11+"','"+data.TITLBCD11+"','"+data.F11+"');\">"+WebUtil.printNumFormat(data.F11)+"</a></td>"); %>
          <% if( noteSize >= 12 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD12+"','"+data.TITLBCD12+"','"+data.F12+"');\">"+WebUtil.printNumFormat(data.F12)+"</a></td>"); %>
          <% if( noteSize >= 13 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD13+"','"+data.TITLBCD13+"','"+data.F13+"');\">"+WebUtil.printNumFormat(data.F13)+"</a></td>"); %>
          <% if( noteSize >= 14 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD14+"','"+data.TITLBCD14+"','"+data.F14+"');\">"+WebUtil.printNumFormat(data.F14)+"</a></td>"); %>
          <% if( noteSize >= 15 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD15+"','"+data.TITLBCD15+"','"+data.F15+"');\">"+WebUtil.printNumFormat(data.F15)+"</a></td>"); %>
          <% if( noteSize >= 16 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD16+"','"+data.TITLBCD16+"','"+data.F16+"');\">"+WebUtil.printNumFormat(data.F16)+"</a></td>"); %>
          <% if( noteSize >= 17 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD17+"','"+data.TITLBCD17+"','"+data.F17+"');\">"+WebUtil.printNumFormat(data.F17)+"</a></td>"); %>
          <% if( noteSize >= 18 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD18+"','"+data.TITLBCD18+"','"+data.F18+"');\">"+WebUtil.printNumFormat(data.F18)+"</a></td>"); %>
          <% if( noteSize >= 19 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD19+"','"+data.TITLBCD19+"','"+data.F19+"');\">"+WebUtil.printNumFormat(data.F19)+"</a></td>"); %>
          <% if( noteSize >= 20 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD20+"','"+data.TITLBCD20+"','"+data.F20+"');\">"+WebUtil.printNumFormat(data.F20)+"</a></td>"); %>
          <% if( noteSize >= 21 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD21+"','"+data.TITLBCD21+"','"+data.F21+"');\">"+WebUtil.printNumFormat(data.F21)+"</a></td>"); %>
          <% if( noteSize >= 22 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD22+"','"+data.TITLBCD22+"','"+data.F22+"');\">"+WebUtil.printNumFormat(data.F22)+"</a></td>"); %>
          <% if( noteSize >= 23 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD23+"','"+data.TITLBCD23+"','"+data.F23+"');\">"+WebUtil.printNumFormat(data.F23)+"</a></td>"); %>
          <% if( noteSize >= 24 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD24+"','"+data.TITLBCD24+"','"+data.F24+"');\">"+WebUtil.printNumFormat(data.F24)+"</a></td>"); %>
          <% if( noteSize >= 25 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD25+"','"+data.TITLBCD25+"','"+data.F25+"');\">"+WebUtil.printNumFormat(data.F25)+"</a></td>"); %>
          <% if( noteSize >= 26 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD26+"','"+data.TITLBCD26+"','"+data.F26+"');\">"+WebUtil.printNumFormat(data.F26)+"</a></td>"); %>
          <% if( noteSize >= 27 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD27+"','"+data.TITLBCD27+"','"+data.F27+"');\">"+WebUtil.printNumFormat(data.F27)+"</a></td>"); %>
          <% if( noteSize >= 28 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD28+"','"+data.TITLBCD28+"','"+data.F28+"');\">"+WebUtil.printNumFormat(data.F28)+"</a></td>"); %>
          <% if( noteSize >= 29 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD29+"','"+data.TITLBCD29+"','"+data.F29+"');\">"+WebUtil.printNumFormat(data.F29)+"</a></td>"); %>
          <% if( noteSize >= 30 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD30+"','"+data.TITLBCD30+"','"+data.F30+"');\">"+WebUtil.printNumFormat(data.F30)+"</a></td>"); %>
          <% if( noteSize >= 31 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD31+"','"+data.TITLBCD31+"','"+data.F31+"');\">"+WebUtil.printNumFormat(data.F31)+"</a></td>"); %>
          <% if( noteSize >= 32 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD32+"','"+data.TITLBCD32+"','"+data.F32+"');\">"+WebUtil.printNumFormat(data.F32)+"</a></td>"); %>
          <% if( noteSize >= 33 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD33+"','"+data.TITLBCD33+"','"+data.F33+"');\">"+WebUtil.printNumFormat(data.F33)+"</a></td>"); %>
          <% if( noteSize >= 34 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD34+"','"+data.TITLBCD34+"','"+data.F34+"');\">"+WebUtil.printNumFormat(data.F34)+"</a></td>"); %>
          <% if( noteSize >= 35 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD35+"','"+data.TITLBCD35+"','"+data.F35+"');\">"+WebUtil.printNumFormat(data.F35)+"</a></td>"); %>
          <% if( noteSize >= 36 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD36+"','"+data.TITLBCD36+"','"+data.F36+"');\">"+WebUtil.printNumFormat(data.F36)+"</a></td>"); %>
          <% if( noteSize >= 37 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD37+"','"+data.TITLBCD37+"','"+data.F37+"');\">"+WebUtil.printNumFormat(data.F37)+"</a></td>"); %>
          <% if( noteSize >= 38 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD38+"','"+data.TITLBCD38+"','"+data.F38+"');\">"+WebUtil.printNumFormat(data.F38)+"</a></td>"); %>
          <% if( noteSize >= 39 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD39+"','"+data.TITLBCD39+"','"+data.F39+"');\">"+WebUtil.printNumFormat(data.F39)+"</a></td>"); %>
          <% if( noteSize >= 40 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD40+"','"+data.TITLBCD40+"','"+data.F40+"');\">"+WebUtil.printNumFormat(data.F40)+"</a></td>"); %>
          <% if( noteSize >= 41 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD41+"','"+data.TITLBCD41+"','"+data.F41+"');\">"+WebUtil.printNumFormat(data.F41)+"</a></td>"); %>
          <% if( noteSize >= 42 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD42+"','"+data.TITLBCD42+"','"+data.F42+"');\">"+WebUtil.printNumFormat(data.F42)+"</a></td>"); %>
          <% if( noteSize >= 43 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD43+"','"+data.TITLBCD43+"','"+data.F43+"');\">"+WebUtil.printNumFormat(data.F43)+"</a></td>"); %>
          <% if( noteSize >= 44 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD44+"','"+data.TITLBCD44+"','"+data.F44+"');\">"+WebUtil.printNumFormat(data.F44)+"</a></td>"); %>
          <% if( noteSize >= 45 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD45+"','"+data.TITLBCD45+"','"+data.F45+"');\">"+WebUtil.printNumFormat(data.F45)+"</a></td>"); %>
          <% if( noteSize >= 46 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD46+"','"+data.TITLBCD46+"','"+data.F46+"');\">"+WebUtil.printNumFormat(data.F46)+"</a></td>"); %>
          <% if( noteSize >= 47 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD47+"','"+data.TITLBCD47+"','"+data.F47+"');\">"+WebUtil.printNumFormat(data.F47)+"</a></td>"); %>
          <% if( noteSize >= 48 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD48+"','"+data.TITLBCD48+"','"+data.F48+"');\">"+WebUtil.printNumFormat(data.F48)+"</a></td>"); %>
          <% if( noteSize >= 49 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD49+"','"+data.TITLBCD49+"','"+data.F49+"');\">"+WebUtil.printNumFormat(data.F49)+"</a></td>"); %>
          <% if( noteSize >= 50 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD50+"','"+data.TITLBCD50+"','"+data.F50+"');\">"+WebUtil.printNumFormat(data.F50)+"</a></td>"); %>
          <% if( noteSize >= 51 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD51+"','"+data.TITLBCD51+"','"+data.F51+"');\">"+WebUtil.printNumFormat(data.F51)+"</a></td>"); %>
          <% if( noteSize >= 52 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD52+"','"+data.TITLBCD52+"','"+data.F52+"');\">"+WebUtil.printNumFormat(data.F52)+"</a></td>"); %>
          <% if( noteSize >= 53 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD53+"','"+data.TITLBCD53+"','"+data.F53+"');\">"+WebUtil.printNumFormat(data.F53)+"</a></td>"); %>
          <% if( noteSize >= 54 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD54+"','"+data.TITLBCD54+"','"+data.F54+"');\">"+WebUtil.printNumFormat(data.F54)+"</a></td>"); %>
          <% if( noteSize >= 55 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD55+"','"+data.TITLBCD55+"','"+data.F55+"');\">"+WebUtil.printNumFormat(data.F55)+"</a></td>"); %>
          <% if( noteSize >= 56 )  out.println("<td "+noteClass+"><a href=\"javascript:goDetail('"+data.TITL2+"','"+data.TITLACD56+"','"+data.TITLBCD56+"','"+data.F56+"');\">"+WebUtil.printNumFormat(data.F56)+"</a></td>"); %>
        </tr>
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
        <p><spring:message code='MSG.F.FCOMMON.0002'/><!-- 해당하는 데이터가 존재하지 않습니다. --></p>
    </div>
</div>
<%
    } //end if...
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->


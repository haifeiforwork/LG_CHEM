<%/***************************************************************************************
*   System Name    : g-HR
*   1Depth Name        : Organization & Staffing
*   2Depth Name    : Headcount
*   Program Name   : Org.Unit/Job Family
*   Program ID         : F02DeptPositionDuty_Global.jsp
*   Description        : 소속별/직무별 인원현황 조회를 위한 jsp 파일
*   Note               :
*   Creation           :
*    Update                :
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%
    request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");                           // 세션
    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);      // 부서코드
    String deptNm = WebUtil.nvl(request.getParameter("hdn_deptNm"));                    // 부서명

    Vector F02DeptPositionDutyTitle_vt = (Vector)request.getAttribute("F02DeptPositionDutyTitle_vt");   // 제목
    Vector F02DeptPositionDutyNote_vt = (Vector)request.getAttribute("F02DeptPositionDutyNote_vt"); // 내용

    HashMap meta = (HashMap)request.getAttribute("meta");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
    //F02DeptPositionDutyNote_vt.removeAllElements();
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(paramA, paramB, paramC, paramD, value) {
    frm = document.form1;

    if (value!= "" && value!= "0") {
        frm.hdn_gubun.value  = "10";                        //소속별/직무별 인원현황
        frm.hdn_deptId.value = "<%= deptId %>";     //조회된 부서코드.
        frm.hdn_paramA.value = paramA;                  //선택된 부서코드.
        frm.hdn_paramB.value = paramB;                  //선택된 부서명
        frm.hdn_paramC.value = paramC;
        frm.hdn_paramD.value = paramD;
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F02DeptPositionDutySV";
    frm.target = "hidden";
    frm.submit();
}

//-->
</SCRIPT>

<jsp:include page="/include/header.jsp" />
 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId" value="<%= deptId %>">
<input type="hidden" name="hdn_deptNm" value="<%= deptNm %>">
<input type="hidden" name="hdn_excel" value="">
<input type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >

<input type="hidden" name="hdn_gubun" value="">
<input type="hidden" name="hdn_sText" value="">
<input type="hidden" name="hdn_paramA" value="">
<input type="hidden" name="hdn_paramB" value="">
<input type="hidden" name="hdn_paramC" value="">
<input type="hidden" name="hdn_paramD" value="">
<input type="hidden" name="hdn_paramE" value="">

<%
    if (F02DeptPositionDutyNote_vt !=null && F02DeptPositionDutyNote_vt.size() > 0 && F02DeptPositionDutyTitle_vt != null && F02DeptPositionDutyTitle_vt.size() > 0) {
%>

    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %></h2>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
            	<thead>
                <tr>
                    <th rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- <Team> --></th>
<%
        String tmp = "";
        for (int k = 0; k < F02DeptPositionDutyTitle_vt.size(); k++ ) {
            F02DeptPositionDutyTitleGlobalData entity = (F02DeptPositionDutyTitleGlobalData)F02DeptPositionDutyTitle_vt.get(k);
            int cols = ((Integer)meta.get(entity.PERST)).intValue();
            if (!tmp.equals(entity.PERST))
                if (entity.PERST.equals("EXP.")) {
%>
                    <th colspan="<%=cols %>"><spring:message code='LABEL.F.F01.0001'/><!-- EXP. --></th>
<%
                }else if(entity.PERST.equals("Office Worker")){
%>
                    <th colspan="<%=cols %>"><spring:message code='LABEL.F.F01.0002'/><!-- Office Worker --></th>
<%
                }else if(entity.PERST.equals("Plant Operator")){
%>
                    <th colspan="<%=cols %>"><spring:message code='LABEL.F.F01.0003'/><!-- Plant Operator --></th>
<%
                }else if(entity.PERST.equals("Intern")){
%>
                    <th colspan="<%=cols %>"><spring:message code='LABEL.F.F01.0004'/><!-- Intern --></th>
<%
                }else if (cols == 1) {
                    String temp = "";
                    if (entity.JIKGT.equals("EMP.SUM")) {
%>
                    <th rowspan="2" width="55" nowrap>&nbsp;&nbsp;<spring:message code='LABEL.F.F01.0043'/><!-- EMP. -->&nbsp;<br>&nbsp;<spring:message code='LABEL.F.F04.0002'/><!-- SUM -->&nbsp;&nbsp;</th>
<%
                    } else if(entity.PERST.equals("Others")){
%>
                    <th rowspan="2" width="55" nowrap><spring:message code='LABEL.F.F01.0005'/><!-- Others --></th>
<%
                    } else if(entity.PERST.equals("TOTAL")){
%>
                    <th rowspan="2" width="55" nowrap><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
<%
                    }
                }
            tmp = entity.PERST;
        }
%>
                </tr>
                <tr>
<%
        // 타이틀.
        for (int k = 0; k < F02DeptPositionDutyTitle_vt.size(); k++) {
            F02DeptPositionDutyTitleGlobalData titleData = (F02DeptPositionDutyTitleGlobalData)F02DeptPositionDutyTitle_vt.get(k);
            int cols = ((Integer)meta.get(titleData.PERST)).intValue();
            if (cols != 1 || titleData.PERST.equals("EXP.")) {
%>
                    <th width="120" nowrap><%=titleData.JIKGT%></th>
<%
            }
        }//end for
%>
        </tr>
<%
        int tok = 0;
        for (int i = 0 ; i < F02DeptPositionDutyNote_vt.size() ; i ++) {
            F02DeptPositionDutyNoteGlobalData entity = (F02DeptPositionDutyNoteGlobalData)F02DeptPositionDutyNote_vt.get(i);

            if ((entity.ZLEVEL != null && !entity.ZLEVEL.equals("") && Integer.parseInt(entity.ZLEVEL) != 0 && Integer.parseInt(entity.ZLEVEL) < tok) || i == 0) {
                tok = Integer.parseInt(entity.ZLEVEL);
            }

        }

        // 타이틀에 맞추어 내용영역 보여주기위한 개수.
        int noteSize = F02DeptPositionDutyTitle_vt.size();

        // 내용.
        for (int i = 0; i < F02DeptPositionDutyNote_vt.size(); i++) {
            F02DeptPositionDutyNoteGlobalData data = (F02DeptPositionDutyNoteGlobalData)F02DeptPositionDutyNote_vt.get(i);

            String strBlank = "";
            String titlClass = "";
            String noteClass = "";
            int blankSize = Integer.parseInt(WebUtil.nvl(data.ZLEVEL, "0"));

            int bstyle = 0 ;
            if (blankSize >= tok)
                bstyle = 5 * (blankSize - tok) + 10;

            // 클래스 설정.
            if (!data.STEXT.equals("TOTAL")) {
                titlClass = "";
                noteClass = "";
            } else {
                titlClass = "class=td11";
                noteClass = "class=td11";
            }
            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
            // 부서명 앞에 공백넣기.
%>
		</thead>
        <tr class=<%= tr_class %>>
          <td <%= titlClass %> nowrap><%= strBlank %><%= data.STEXT %>&nbsp;&nbsp;</td>
          <td <%= noteClass %> ><a title='<%= data.STEXT %>' href="javascript:goDetail('<%= data.OBJID %>','<%= data.STEXT %>','<%= data.TITLACD1 %>','<%= data.TITLBCD1 %>', '<%= data.F1 %>');"><%= WebUtil.printNumFormat(data.F1) %></a></td>
          <td <%= noteClass %> ><a title='<%= data.STEXT %>' href="javascript:goDetail('<%= data.OBJID %>','<%= data.STEXT %>','<%= data.TITLACD2 %>','<%= data.TITLBCD2 %>', '<%= data.F2 %>');"><%= WebUtil.printNumFormat(data.F2) %></a></td>
          <% if (noteSize >= 3)   out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD3 +"','"+data.TITLBCD3 +"','"+data.F3+"');\">" +WebUtil.printNumFormat(data.F3) +"</a></td>"); %>
          <% if (noteSize >= 4)   out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD4 +"','"+data.TITLBCD4 +"','"+data.F4+"');\">" +WebUtil.printNumFormat(data.F4)+"</a></td>"); %>
          <% if (noteSize >= 5)   out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD5 +"','"+data.TITLBCD5 +"','"+data.F5+"');\">" +WebUtil.printNumFormat(data.F5)+"</a></td>"); %>
          <% if (noteSize >= 6)   out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD6 +"','"+data.TITLBCD6 +"','"+data.F6+"');\">" +WebUtil.printNumFormat(data.F6)+"</a></td>"); %>
          <% if (noteSize >= 7)   out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD7 +"','"+data.TITLBCD7 +"','"+data.F7+"');\">" +WebUtil.printNumFormat(data.F7)+"</a></td>"); %>
          <% if (noteSize >= 8)   out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD8 +"','"+data.TITLBCD8 +"','"+data.F8+"');\">" +WebUtil.printNumFormat(data.F8) +"</a></td>"); %>
          <% if (noteSize >= 9)   out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD9 +"','"+data.TITLBCD9 +"','"+data.F9+"');\">" +WebUtil.printNumFormat(data.F9) +"</a></td>"); %>
          <% if (noteSize >= 10)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD10+"','"+data.TITLBCD10+"','"+data.F10+"');\">"+WebUtil.printNumFormat(data.F10)+"</a></td>"); %>
          <% if (noteSize >= 11)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD11+"','"+data.TITLBCD11+"','"+data.F11+"');\">"+WebUtil.printNumFormat(data.F11)+"</a></td>"); %>
          <% if (noteSize >= 12)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD12+"','"+data.TITLBCD12+"','"+data.F12+"');\">"+WebUtil.printNumFormat(data.F12)+"</a></td>"); %>
          <% if (noteSize >= 13)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD13+"','"+data.TITLBCD13+"','"+data.F13+"');\">"+WebUtil.printNumFormat(data.F13)+"</a></td>"); %>
          <% if (noteSize >= 14)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD14+"','"+data.TITLBCD14+"','"+data.F14+"');\">"+WebUtil.printNumFormat(data.F14)+"</a></td>"); %>
          <% if (noteSize >= 15)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD15+"','"+data.TITLBCD15+"','"+data.F15+"');\">"+WebUtil.printNumFormat(data.F15)+"</a></td>"); %>
          <% if (noteSize >= 16)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD16+"','"+data.TITLBCD16+"','"+data.F16+"');\">"+WebUtil.printNumFormat(data.F16)+"</a></td>"); %>
          <% if (noteSize >= 17)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD17+"','"+data.TITLBCD17+"','"+data.F17+"');\">"+WebUtil.printNumFormat(data.F17)+"</a></td>"); %>
          <% if (noteSize >= 18)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD18+"','"+data.TITLBCD18+"','"+data.F18+"');\">"+WebUtil.printNumFormat(data.F18)+"</a></td>"); %>
          <% if (noteSize >= 19)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD19+"','"+data.TITLBCD19+"','"+data.F19+"');\">"+WebUtil.printNumFormat(data.F19)+"</a></td>"); %>
          <% if (noteSize >= 20)  out.println("<td "+noteClass+"><a title='"+data.STEXT +"' href=\"javascript:goDetail('"+data.OBJID+"','"+data.STEXT+"','"+data.TITLACD20+"','"+data.TITLBCD20+"','"+data.F20+"');\">"+WebUtil.printNumFormat(data.F20)+"</a></td>"); %>
        </tr>
<%
                } //end for...
%>
            </table>
        </div>
    </div>

</div>

<%
    } else {
%>

                &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- Org.Unit --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %>
                &nbsp;&nbsp;
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team --></th>
                    <th colspan="2"><spring:message code='LABEL.F.F01.0001'/><!-- EXP. --></th>
                    <th colspan="5"><spring:message code='LABEL.F.F01.0002'/><!-- Office Worker --></th>
                    <th colspan="4"><spring:message code='LABEL.F.F01.0003'/><!-- Plant Operator --></th>
                    <th colspan="3"><spring:message code='LABEL.F.F01.0004'/><!-- Intern --></th>
                    <th rowspan="2"><spring:message code='LABEL.F.F01.0005'/><!-- Others --></th>
                    <th rowspan="2"><spring:message code='LABEL.F.F01.0043'/><!-- EMP. --> <br><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                    <th class="lastCol" rowspan="2"><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
                </tr>
                <tr>
                  <th><spring:message code='LABEL.F.F01.0007'/><!-- KR --></th>
                  <th><spring:message code='LABEL.F.F01.0008'/><!-- Partner --></th>
                  <th><spring:message code='LABEL.F.F01.0039'/><!-- Management --></th>
                  <th><spring:message code='LABEL.F.F01.0040'/><!-- Sales --></th>
                  <th><spring:message code='LABEL.F.F01.0041'/><!-- Production --></th>
                  <th><spring:message code='LABEL.F.F01.0042'/><!-- Research&Development --></th>
                  <th><spring:message code='LABEL.F.F04.0002'/><!-- Sum --></th>
                  <th><spring:message code='LABEL.F.F01.0039'/><!-- Management --></th>
                  <th><spring:message code='LABEL.F.F01.0040'/><!-- Sales --></th>
                  <th><spring:message code='LABEL.F.F01.0041'/><!-- Production --></th>
                  <th><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                  <th><spring:message code='LABEL.F.F01.0027'/><!-- O/W --></th>
                  <th><spring:message code='LABEL.F.F01.0028'/><!-- P/O --></th>
                  <th class="lastCol"><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                </tr>
                <tr>
                  <td class="lastCol" colspan="18"><spring:message code='MSG.F.FCOMMON.0002'/><!-- There is no data that match. --></td>
                </tr>
            </table>
        </div>
    </div>

</div>
<%
    } //end if
%>
</form>
</body>
</html>


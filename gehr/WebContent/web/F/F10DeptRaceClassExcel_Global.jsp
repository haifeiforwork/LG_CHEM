<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 직무별/최종학력별
*   Program ID   : F09DeptDutyLastSchoolExcel.jsp
*   Description  : 직무별/최종학력별 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/%>
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
    WebUserData user    = (WebUserData)session.getAttribute("user");                            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드


    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  //부서명
    Vector DeptRaceClassTitle_vt = (Vector)request.getAttribute("DeptRaceClassTitle_vt");         //제목
    HashMap meta = (HashMap)request.getAttribute("meta");          //내용
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Org_Unit_Ethnic_Group.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
    Integer total = (Integer)request.getAttribute("total_sum");
    int han_sum = ((Integer)request.getAttribute("han_sum")).intValue();
    int chosen_sum = ((Integer)request.getAttribute("chosen_sum")).intValue();
    int man_sum = ((Integer)request.getAttribute("man_sum")).intValue();
    int other_sum = ((Integer)request.getAttribute("other_sum")).intValue();
    int total_sum = total == null ? 0 :total.intValue();
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<%
    if ( DeptRaceClassTitle_vt != null && DeptRaceClassTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="500" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="2" class="title02">* <spring:message code='LABEL.F.FCOMMON.0001'/>/Ethnic Group</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="2" class="td09">
            &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td ></td>
        </tr>
        <tr><td height="17">&nbsp;※ <spring:message code='MSG.F.F00.0003'/><!-- Expatriate is not included. -->   </td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
    <%
    	int signal = 0;
    	if(han_sum > 0)
    		signal ++;
    	if(chosen_sum > 0)
    		signal ++;
    	if(man_sum > 0)
    		signal ++;
    	if(other_sum > 0)
    		signal ++;
        	if(total_sum > 0)
    		signal ++;

     %>
      <table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
		<tr>
          <td class="td03" style="width: 60;text-align: center;" colspan="2" rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/></td>
          <td class="td03" style="width: 60;text-align: center;" colspan="<%=signal %>"><spring:message code='LABEL.F.F10.0001'/><!-- Ethnic --></td>
          <td class="td03" colspan="3" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F10.0002'/><%-- Gender --%></td>
          <!-- td class="td03" style="width: 60;text-align: center;" rowspan="2" width="60px;">TOTAL</td -->
        </tr>
        <tr>
          <%
          	if(han_sum>0){
          %>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F10.0003'/><!-- Han Zu --></td>
          <%
          }if(chosen_sum>0){
           %>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F10.0009'/><!-- Chaoxian Zu --></td>
          <%
          }if(man_sum>0){
          %>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F10.0005'/><!-- Man Zu --></td>
          <%
          }if(other_sum>0){
          %>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F42.0069'/><!-- Others --></td>
          <%
          }
          if(total_sum>0){
          %>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></td>
          <%
          }
          %>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F10.0007'/><!-- Male --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F10.0008'/><!-- Female --></td>
          <td class="td03" style="width: 60;text-align: center;"><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></td>
		</tr>
<%
	String temp = "";
	String tmpCode = "";
	for(int i = 0 ; i < DeptRaceClassTitle_vt.size() ; i ++){
		F10DeptRaceClassTitleGlobalData entity = (F10DeptRaceClassTitleGlobalData) DeptRaceClassTitle_vt.get(i);
%>
	<tr>
		<%
			if(!temp.equals(entity.STEXT) || !tmpCode.equals(entity.OBJID)){
		%>
		<td rowspan="<%=meta.get(entity.STEXT + entity.OBJID) %>" class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"td05" %>' <%=entity.STEXT.equals("TOTAL")?"colspan='2'":""%> style="text-align: <%=entity.STEXT.equals("TOTAL")?"center":"left"%>;vertical-align: text-top;" nowrap="nowrap">
			<%
				if(entity.ZLEVEL.equals(""))
					entity.ZLEVEL = "0";
			%>
			<%=entity.STEXT %>
		</td>
		<%
			}if(!entity.STEXT.equals("TOTAL")){
		%>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: left">
		<%=entity.JIKGT%>
		</td>
		<%}
			if(han_sum>0){
		%>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F1)%>
		</td>
		<%
			}if(chosen_sum>0){
		%>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F2)%>
		</td>
		<%
		 	}if(man_sum>0){
		 %>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F3)%>
		</td>
		<%
			}if(other_sum>0){
		%>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F4)%>
		</td>
		<%
			}
			if(total_sum>0){
		%>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":entity.JIKGT.equals("Sub-sum")?"td11_2":"td05" %>'>
		<%=WebUtil.printNumFormat(entity.F5)%>
		</td>
		<%
			}
		%>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F6)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F7)%>
		</td>
		<td class='<%=entity.STEXT.equals("TOTAL")?"td11":"td05" %>' style="text-align: right;">
		<%=WebUtil.printNumFormat(entity.F8)%>
		</td>
	</tr>
<%
		temp = entity.STEXT;
		tmpCode = entity.OBJID;
          }
%>
	  </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.F.FCOMMON.0002'/></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>



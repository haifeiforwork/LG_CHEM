<%/**********************************************************************************/
/*	  System Name  	: g-HR																													*/
/*   1Depth Name		: Organization & Staffing                                                 											*/
/*   2Depth Name		: Time Management                                                													*/
/*   Program Name	: Daily Time Statement                                             													*/
/*   Program ID   		: F43DeptMonthWorkConditionExcelDe.jsp                               											*/
/*   Description  		: 부서별 일간 근태 집계표 Excel 저장을 위한 jsp 파일[독일]                												*/
/*   Note         		: 없음                                                        																		*/
/*   Creation     		: 2010-07-25  yji                                           																*/
/***********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.common.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
	WebUserData user	= (WebUserData) session.getAttribute("user"); 								// 세션.

    String deptId       	= WebUtil.nvl(request.getParameter("hdn_deptId"));                  		//부서코드
    String deptNm       	= (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  	//부서명
    String searchDay    	= WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));           	//대상년월
    String year      		= "";
    String month     		= "";
    String dayCnt       	= WebUtil.nvl((String)request.getAttribute("E_DAY_CNT"), "28");     	//일자수

    Vector detailDataAll_vt			= (Vector)request.getAttribute("detailDataAll_vt");
    Vector F43DeptDayTitle_vt 	= (Vector)request.getAttribute("F43DeptDayTitle_vt");      	//제목
    Vector F43DeptDayData_vt 	= (Vector)request.getAttribute("F43DeptDayData_vt");      	//내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Daily_Time_Statement.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
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


<table width="2040" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">* <!--Daily Time Statement--><%=g.getMessage("LABEL.F.F43.0009")%></td>
        </tr>
	    <tr><td colspan="15" height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="15" class="td09">

            &nbsp;Date : <%=searchDay.substring(0,6)%>
          </td>
<%
    if(deptNm == null || deptNm.equals(""))
    	deptNm = user.e_obtxt ;
%>
          </tr>
          <tr>
    		<td class="td09">&nbsp;<!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%=deptNm%></td>
    		<td class="td08">&nbsp;</td>
        </tr>
      </table>
    </td>
    <td  width="16">&nbsp;</td>
  </tr>
 <tr>
 	 <td width="16">&nbsp;</td>
     <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
			<tr class="td07_1">
				<td width="50"><!--Seq No.--><%=g.getMessage("LABEL.F.F43.0011")%> </td>
				<td width="100"><!--Pers.No--><%=g.getMessage("LABEL.F.F43.0012")%></td>
				<td width="120"><!--Name--><%=g.getMessage("LABEL.F.F43.0013")%> </td>
				<td width="100"><!--Quata<br>Balance<br>(Days)--><%=g.getMessage("LABEL.F.F43.0014")%></td>

				<!-- column head -->
				<%
					for( int i = 0 ; i < detailDataAll_vt.size() ; i ++){
					BetweenDateData time = (BetweenDateData)detailDataAll_vt.get(i);
				%>
					<td width="100"><%=Integer.parseInt(time.CAL_DATE.substring(8)) %></td>
				<%
					}
				%>
			</tr>

				<%
				String tmp = "";
				int no = 0 ;
				for( int i = 0 ; i < F43DeptDayTitle_vt.size() ; i ++){
					no ++;
					F43DeptDayTitleWorkConditionData data = (F43DeptDayTitleWorkConditionData)F43DeptDayTitle_vt.get(i);
					if(i != 0 && !data.STEXT.equals(tmp)){
					no = 0 ;
					no ++;
				%>
						</table></td></tr>
					  <tr><td height="10" colspan=4>&nbsp;</td></tr>
					  <tr>
					    <td width="16" nowrap>&nbsp;&nbsp;</td>
					    <td class="td09_1">&nbsp;<!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%=data.STEXT %></td>
					  </tr>
					  <tr>
					 	 <td width="10">&nbsp;&nbsp;&nbsp;</td>
					  	<td>

							<table  border="1" cellpadding="0" cellspacing="1" class="table01_1" align="left" style="width: 2000px;">
							<tr class="td03">
								<td width="60"><!-- Seq No.--><%=g.getMessage("LABEL.F.F43.0011")%> </td>
								<td width="115"><!--Pers.No--><%=g.getMessage("LABEL.F.F43.0012")%> </td>
								<td width="120"><!--Name--><%=g.getMessage("LABEL.F.F43.0013")%> </td>
								<td width="114"><!--Quata<br>Balance<br>(Days)--><%=g.getMessage("LABEL.F.F43.0014")%>

								<!-- column head -->
								<%
									for( int j = 0 ; j < detailDataAll_vt.size() ; j ++){
									BetweenDateData time = (BetweenDateData)detailDataAll_vt.get(j);
								%>
									<td width="100"><%=Integer.parseInt(time.CAL_DATE.substring(8)) %></td>
								<%
									}
								%>
							</tr>

				<%
					}
				%>
				<tr>
				<td  class="td09_1"><%=no%></td>
				<td  class="td09_1"><%=data.PERNR %></td>
				<td class="td09_1"><%=data.ENAME %></td>
				<td class="td05"><%=WebUtil.printNumFormat(data.QU_BAL,2)%></td>
					<%
					for( int j = 0 ; j < detailDataAll_vt.size() ; j ++){
						BetweenDateData time = (BetweenDateData)detailDataAll_vt.get(j);
					%>
						<td class="td09_1"><%=data.MAP.get(time.CAL_DATE)==null?"":data.MAP.get(time.CAL_DATE)%></td>
					<%
					}
					%>
				</tr>
				<%
					tmp = data.STEXT;
				}
				if(F43DeptDayTitle_vt.size() == 0)
				{
				%>
					<tr>
						<td colspan="<%=detailDataAll_vt.size() + 4%>" class="td09_1"><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%></td>
					</tr>
				<%
				}
				%>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>


  <tr><td colspan="15" height="15"></td></tr>
  <tr>
	<td width="16">&nbsp;</td>
	<td colspan="15" >
       <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td colspan="15" style="padding-bottom:2px">＊Time Type</td>
        </tr>
        <tr>
          <td colspan="35">
           <table width="100%" border="1" cellpadding="0" cellspacing="1" class="table01_1" align="left">
              <tr class="td07_1">

                <td width="100"><!--Category--><%=g.getMessage("LABEL.F.F43.0016")%></td>
                <td align="center"><!--Type--><%=g.getMessage("LABEL.F.F43.0049")%></td>

              </tr>
              <tr>
                <td class="td07_1"><!--Absence--><%=g.getMessage("LABEL.F.F43.0017")%></td>
                <td class="td09">
                	<table>
                        <tr>
                           <td width="160">A&nbsp;:&nbsp;<!-- Annual Leave--><%=g.getMessage("LABEL.F.F43.0052")%></td>
                           <td width="160">B&nbsp;:&nbsp;<!--Annual Leave 1/2 day--><%=g.getMessage("LABEL.F.F43.0053")%></td>
                           <td width="160">C&nbsp;:&nbsp;<!--Illness(Paid)--><%=g.getMessage("LABEL.F.F43.0054")%></td>
                           <td width="160">D&nbsp;:&nbsp;<!--Illness(Unpaid)--><%=g.getMessage("LABEL.F.F43.0055")%></td>
                        </tr>
                        <tr>
	                       <td>E&nbsp;:&nbsp;<!--Doctor's appointment--><%=g.getMessage("LABEL.F.F43.0056")%></td>
                           <td>F&nbsp;:&nbsp;<!--Paid leave of absence--><%=g.getMessage("LABEL.F.F43.0057")%></td>
                           <td>G&nbsp;:&nbsp;<!--Wedding--><%=g.getMessage("LABEL.F.F43.0058")%></td>
                           <td>H&nbsp;:&nbsp;<!--Birth--><%=g.getMessage("LABEL.F.F43.0059")%></td>
                        </tr>
                        <tr>
	                        <td>I&nbsp;:&nbsp;<!--Relocation--><%=g.getMessage("LABEL.F.F43.0060")%></td>
                            <td>J&nbsp;:&nbsp;<!--Jury duty--><%=g.getMessage("LABEL.F.F43.0061")%></td>
                            <td>K&nbsp;:&nbsp;<!--Divorce--><%=g.getMessage("LABEL.F.F43.0062")%></td>
                            <td>L&nbsp;:&nbsp;<!--Death--><%=g.getMessage("LABEL.F.F43.0063")%></td>
                        </tr>
                        <tr>
                            <td>M&nbsp;:&nbsp;<!--Special Leave--><%=g.getMessage("LABEL.F.F43.0064")%></td>
                            <td>N&nbsp;:&nbsp;<!--Military reserves--><%=g.getMessage("LABEL.F.F43.0065")%></td>
                            <td>O&nbsp;:&nbsp;<!--Maternity protection--><%=g.getMessage("LABEL.F.F43.0066")%></td>
                            <td>P&nbsp;:&nbsp;<!--Sick child(unpaid)--><%=g.getMessage("LABEL.F.F43.0067")%></td>
                         </tr>
                         <tr>
                            <td>Q&nbsp;:&nbsp;<!--Parental leave--><%=g.getMessage("LABEL.F.F43.0068")%></td>
                            <td>R&nbsp;:&nbsp;<!--Unpaid leave--><%=g.getMessage("LABEL.F.F43.0069")%></td>
                            <td>N&nbsp;:&nbsp;<!--Unpaid absence/lateness--><%=g.getMessage("LABEL.F.F43.0070")%></td>
                         </tr>
                	</table>
                </td>
              </tr>
              <tr>
                <td class="td03"><!--Attendance--><%=g.getMessage("LABEL.F.F43.0050")%></td>
                <td class="td09_1">
                    <table>
                       <tr>
                           <td width="120"> 1&nbsp;:&nbsp;<!--Business Trip--><%=g.getMessage("LABEL.F.F43.0037")%> </td>
                           <td width="120"> 2&nbsp;:&nbsp;<!--Education--><%=g.getMessage("LABEL.F.F43.0038")%> </td>
                       </tr>
                    </table>

                </td>
              </tr>
              <tr>
                <td class="td03">Overtime</td>
                <td class="td09_1">

                    <table>
                       <tr>
                           <td width="120">OA&nbsp;:&nbsp;<!--Workday--><%=g.getMessage("LABEL.F.F43.0051")%></td>
                           <td width="120">OD&nbsp;:&nbsp;<!--Off day--><%=g.getMessage("LABEL.F.F43.0043")%> </td>
                           <td width="120">OE&nbsp;:&nbsp;<!--Holiday--><%=g.getMessage("LABEL.F.F43.0044")%> </td>
                       </tr>
                    </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    <td colspan="15"  width="16">&nbsp;</td>
  </tr>
  <tr><td colspan="15"  height="16"></td></tr>
</table>

</form>
</body>
</html>
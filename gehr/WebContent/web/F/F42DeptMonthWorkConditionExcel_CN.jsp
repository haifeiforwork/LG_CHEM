<%/**********************************************************************************/
/*	  System Name  	: g-HR																													*/
/*   1Depth Name		: Organization & Staffing                                                 											*/
/*   2Depth Name		: Time Management                                                													*/
/*   Program Name	: Monthly Time Statement                                             												*/
/*   Program ID   		: F42DeptMonthWorkConditionExcel.jsp                          												*/
/*   Description  		: 부서별 월간 근태 집계표 Excel 저장을 위한 jsp 파일          														*/
/*   Note         		: 없음                                                        																		*/
/*   Creation     		: 2005-02-18  유용원                                           																*/
/*   Update       		: 2007-09-21  heli  global hr update                                                            					*/
/*   			       		: 2008-11-12  김정인  @v 1.0  [C20081110_55600] data 출력 소수점 첫째자리수(반올림)로 변경 	*/
/***********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
    String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
    String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
    String searchDay	= WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));   		//대상년월

    Vector F42DeptMonthWorkCondition_vt = (Vector)request.getAttribute("F42DeptMonthWorkCondition_vt");
    Vector F42DeptMonthWorkConditionTotal = (Vector)request.getAttribute("F42DeptMonthWorkConditionTotal");
    F42DeptMonthWorkConditionData todata  = new F42DeptMonthWorkConditionData();
    if(F42DeptMonthWorkConditionTotal.size()>0){
    	todata =(F42DeptMonthWorkConditionData)F42DeptMonthWorkConditionTotal.get(0);
    }
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Monthly_Time_Statement.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*-------------------------------------------------------------------------- */

    DecimalFormat f1 = new DecimalFormat("0.0");		// 반올림후 첫째자리수까지.

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
    //부서명, 조회된 건수.
    if ( F42DeptMonthWorkCondition_vt != null && F42DeptMonthWorkCondition_vt.size() > 0 ) {
        //대상년월 폼 변경.
        if( !searchDay.equals("") )
            searchDay = searchDay.substring(0, 4)+"."+searchDay.substring(4, 6);
%>
<table width="1380" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">* <!--Monthly Time Statement--><%=g.getMessage("LABEL.F.F42.0059")%></td>
        </tr>
	    <tr><td colspan="15" height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="15" class="td09" >
            &nbsp;<!--Division--><%=g.getMessage("LABEL.F.F42.0078")%> :<!-- Month total--><%=g.getMessage("LABEL.F.F42.0079")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;<!--Year--><%=g.getMessage("LABEL.F.F42.0080")%> : <%=searchDay%>
          </td>
          <td colspan="15"></td>
        </tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td width="16">&nbsp;</td><td class="td09_1"  align="right">&nbsp;<%= todata.STEXT  %>:&nbsp;<%= todata.ENAME %></td><td width="16">&nbsp;</td></tr>
  <tr>
  <td width="16">&nbsp;</td>
  	<td colspan="2" valign="top">
    	<table border="1" cellpadding="0" cellspacing="1" width="100" class="table02" align="left">
      <colgroup>
      	<col width="8%"/>
      	<col width="8%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      	<col width="7%"/>
      </colgroup>
          <tr>
          <td  class="td03" colspan="3"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></td>
          <td  class="td03" rowspan="2"><!--Duty<br>(Account)--><%=g.getMessage("LABEL.F.F42.0060")%></td>
          <td  class="td03" colspan="2"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></td>
          <td  class="td03" colspan="2"><!--Leave(Hours)--><%=g.getMessage("LABEL.F.F42.0062")%></td>
          <td  class="td03" rowspan="2"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></td>
          <td  class="td03" colspan="3"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></td>
          <!-- td class="td03" rowspan="2">Confirm</td -->
        </tr>
        <tr>
          <td  class="td03" align="center"><!--Workday--><%=g.getMessage("LABEL.F.F42.0065")%></td>
          <td  class="td03" align="center"><!--Offday--><%=g.getMessage("LABEL.F.F42.0066")%></td>
          <td  class="td03" align="center"><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></td>
          <td  class="td03" align="center"><!--Annual--><%=g.getMessage("LABEL.F.F42.0068")%></td>
          <td  class="td03" align="center"><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></td>
          <td  class="td03" align="center"><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></td>
          <td  class="td03" align="center"><!--Personal--><%=g.getMessage("LABEL.F.F42.0071")%></td>
          <td  class="td03" align="center"><!--Absence--><%=g.getMessage("LABEL.F.F42.0072")%></td>
          <td  class="td03" align="center"><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></td>
          <td  class="td03" align="center"><!--Early<br>Dismissal--><%=g.getMessage("LABEL.F.F42.0085")%></td>
        </tr>
        <tr>
          <td class="td05"><%= todata.OT_WOR.equals("") ? "0"	: f1.format(Double.parseDouble(todata.OT_WOR))  %></td>
          <td class="td05"><%= todata.OT_OFF.equals("") ? "0"	: f1.format(Double.parseDouble(todata.OT_OFF))   %></td>
          <td class="td05"><%= todata.OT_HOL.equals("") ? "0"	: f1.format(Double.parseDouble(todata.OT_HOL))   %></td>
          <td class="td05"><%= todata.DUTY.equals("") ? "0"		: f1.format(Double.parseDouble(todata.DUTY))      %></td>
          <td class="td05"><%= todata.LE_ANN.equals("") ? "0"	: f1.format(Double.parseDouble(todata.LE_ANN))   %></td>
          <td class="td05"><%= todata.LE_OTH.equals("") ? "0"	: f1.format(Double.parseDouble(todata.LE_OTH))   %></td>
          <td class="td05"><%= todata.LE_SIC.equals("") ? "0"	: f1.format(Double.parseDouble(todata.LE_SIC))    %></td>
          <td class="td05"><%= todata.LE_PER.equals("") ? "0"	: f1.format(Double.parseDouble(todata.LE_PER))    %></td>

          <td class="td05"><%= todata.ATTEN.equals("") ? "0"	: f1.format(Double.parseDouble(todata.ATTEN))    %></td>
          <td class="td05"><%= todata.AB_ABS.equals("") ? "0"	: f1.format(Double.parseDouble(todata.AB_ABS))   %></td>
          <td class="td05"><%= todata.AB_TAR.equals("") ? "0"	: f1.format(Double.parseDouble(todata.AB_TAR))   %></td>
          <td class="td05"><%= todata.AB_EAR.equals("") ? "0"	: f1.format(Double.parseDouble(todata.AB_EAR))   %></td>
        </tr>
    	</table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
<%
	String tempDept = "";
	int i=0;
	int j=0;
	int k=0;

	for(i=0;i<F42DeptMonthWorkCondition_vt.size();){

 %>
  <tr><td height="10"></td></tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td class="td09_1">&nbsp;Org.Unit : <%= ((F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(i)).STEXT%></td>
    <td class="td08">&nbsp;</td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
          <td  rowspan="2"	class="td03"><!--Pers.No--><%=g.getMessage("LABEL.F.F42.0075")%></td>
          <td  rowspan="2"	class="td03"><!--Name--><%=g.getMessage("LABEL.F.F42.0076")%></td>
          <td  colspan="3"	class="td03"><!--Overtime(Hours)--><%=g.getMessage("LABEL.F.F42.0074")%></td>
          <td  rowspan="2"	class="td03"><!--Duty<br>(Account)--><%=g.getMessage("LABEL.F.F42.0060")%></td>
          <td  colspan="2"	class="td03"><!-- Leave(Days)--><%=g.getMessage("LABEL.F.F42.0061")%></td>
          <td  colspan="2"	class="td03"><!--Leave(Hours)--><%=g.getMessage("LABEL.F.F42.0062")%></td>
          <td  rowspan="2"	class="td03"><!--Attendance<br>(Days)--><%=g.getMessage("LABEL.F.F42.0063")%></td>
          <td  colspan="3"	class="td03"><!--Absence(Account)--><%=g.getMessage("LABEL.F.F42.0064")%></td>
          <!-- td class="td03" rowspan="2">Confirm</td -->

        </tr>
        <tr>
          <td  class="td03" align="center"><!--Workday--><%=g.getMessage("LABEL.F.F42.0065")%></td>
          <td  class="td03" align="center"><!--Offday--><%=g.getMessage("LABEL.F.F42.0066")%></td>
          <td  class="td03" align="center"><!--Holiday--><%=g.getMessage("LABEL.F.F42.0067")%></td>
          <td  class="td03" align="center"><!--Annual--><%=g.getMessage("LABEL.F.F42.0068")%></td>
          <td  class="td03" align="center"><!--Others--><%=g.getMessage("LABEL.F.F42.0069")%></td>
          <td  class="td03" align="center"><!--Sick--><%=g.getMessage("LABEL.F.F42.0070")%></td>
          <td  class="td03" align="center"><!--Personal--><%=g.getMessage("LABEL.F.F42.0071")%></td>
          <td  class="td03" align="center"><!--Absence--><%=g.getMessage("LABEL.F.F42.0072")%></td>
          <td  class="td03" align="center"><!--Tardiness--><%=g.getMessage("LABEL.F.F42.0073")%></td>
          <td  class="td03" align="center"><!--Early<br>Dismissal--><%=g.getMessage("LABEL.F.F42.0085")%></td>
        </tr>
<%
		int tem = j;
        for(; j < F42DeptMonthWorkCondition_vt.size(); j++ ){
            F42DeptMonthWorkConditionData deptData = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(j);
            if(tempDept.equals("")){
            	tempDept = deptData.ORGEH;
            }
			if(!(deptData.ORGEH.equals(tempDept))){
				tempDept = deptData.ORGEH;
				break ;
			}
			i=j+1;
%>
        <tr>
          <td class="td04" style="text-align:center">&nbsp;&nbsp;<%= deptData.PERNR     %>&nbsp;&nbsp;</td>
          <td class="td04" style="text-align:left">&nbsp;&nbsp;<%= deptData.ENAME    %></td>
          <td class="td05"><%= deptData.OT_WOR.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.OT_WOR)) %></td>
          <td class="td05"><%= deptData.OT_OFF.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.OT_OFF))  %></td>
          <td class="td05"><%= deptData.OT_HOL.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.OT_HOL))  %></td>
          <td class="td05"><%= deptData.DUTY.equals("") ? "0"		: f1.format(Double.parseDouble(deptData.DUTY))     %></td>
          <td class="td05"><%= deptData.LE_ANN.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.LE_ANN))  %></td>
          <td class="td05"><%= deptData.LE_OTH.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.LE_OTH))  %></td>
          <td class="td05"><%= deptData.LE_SIC.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.LE_SIC))   %></td>
          <td class="td05"><%= deptData.LE_PER.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.LE_PER))   %></td>

          <td class="td05"><%= deptData.ATTEN.equals("") ? "0"		: f1.format(Double.parseDouble(deptData.ATTEN))   %></td>
          <td class="td05"><%= deptData.AB_ABS.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.AB_ABS))  %></td>
          <td class="td05"><%= deptData.AB_TAR.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.AB_TAR))  %></td>
          <td class="td05"><%= deptData.AB_EAR.equals("") ? "0"	: f1.format(Double.parseDouble(deptData.AB_EAR))   %></td>
        </tr>
<%
        }//end for
%>
<%
            double	 	OT_WOR=0;
            double		OT_OFF=0;
            double		OT_HOL=0;
            double		DUTY  =0;
            double		LE_ANN=0;
            double	    LE_SIC=0;
            double		LE_PER=0;
            double	    LE_OTH=0;
            double		ATTEN =0;
            double		AB_ABS=0;
            double		AB_TAR=0;
            double		AB_EAR=0;

                for(k = tem; k < j; k++ ){
                    F42DeptMonthWorkConditionData data = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(k);
				 	OT_WOR	+= data.OT_WOR.equals("") ? 0 :  Double.parseDouble(data.OT_WOR);
					OT_OFF	+= data.OT_OFF.equals("") ? 0 :  Double.parseDouble(data.OT_OFF);
					OT_HOL	+= data.OT_HOL.equals("") ? 0 :  Double.parseDouble(data.OT_HOL);
					DUTY  	+= data.DUTY.equals("") ? 0 :  Double.parseDouble(data.DUTY);
					LE_ANN	+= data.LE_ANN.equals("") ? 0 :  Double.parseDouble(data.LE_ANN);
					LE_SIC	+= data.LE_SIC.equals("") ? 0 :  Double.parseDouble(data.LE_SIC);
					LE_PER	+= data.LE_PER.equals("") ? 0 :  Double.parseDouble(data.LE_PER);
					LE_OTH	+= data.LE_OTH.equals("") ? 0 :  Double.parseDouble(data.LE_OTH);
					ATTEN 	+= data.ATTEN.equals("") ? 0 :  Double.parseDouble(data.ATTEN);
					AB_ABS	+= data.AB_ABS.equals("") ? 0 :  Double.parseDouble(data.AB_ABS);
					AB_TAR	+= data.AB_TAR.equals("") ? 0 :  Double.parseDouble(data.AB_TAR);
					AB_EAR	+= data.AB_EAR.equals("") ? 0 :  Double.parseDouble(data.AB_EAR);
				}
%>
        <tr>
          <td class="td04">TOTAL</td>
          <td class="td04"><%=j-tem %> person</td>
          <td class="td11"><%= f1.format(OT_WOR) %></td>
          <td class="td11"><%= f1.format(OT_OFF) %></td>
          <td class="td11"><%= f1.format(OT_HOL) %></td>
          <td class="td11"><%= f1.format(DUTY) %></td>
          <td class="td11"><%= f1.format(LE_ANN) %></td>
          <td class="td11"><%= f1.format(LE_OTH) %></td>
          <td class="td11"><%= f1.format(LE_SIC) %></td>
          <td class="td11"><%= f1.format(LE_PER) %></td>

          <td class="td11"><%= f1.format(ATTEN) %></td>
          <td class="td11"><%= f1.format(AB_ABS) %></td>
          <td class="td11"><%= f1.format(AB_TAR) %></td>
          <td class="td11"><%= f1.format(AB_EAR) %></td>
        </tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
<%
	}
 %>
  <tr><td colspan="15" height="16"></td></tr>

</table>

<%
    } else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><!--No data--><%=g.getMessage("LABEL.F.F51.0029")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>
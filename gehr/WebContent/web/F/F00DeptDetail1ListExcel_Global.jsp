<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 인원현황 각각의 상세화면                                    */
/*   Program ID   : F00DeptDetailListExcel.jsp                                  */
/*   Description  : 인원현황 각각의 상세화면 Excel 저장을 위한 jsp 파일         */
/*   Note        : 없음                                                        */
/*   Creation   : 2005-03-09 유용원                                           */
/*   Update		:                                                             */
/*   Update		: 2008-02-18 김정인                                                     	*/
/*                   추가된 각 항목에 대한 엑셀다운로드 필드 추가.               */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.F.rfc.Global.*" %>
<%@ page import="hris.common.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");                            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  //부서명
    Vector F00DeptDetailListData_vt  = (Vector)request.getAttribute("F00DeptDetailListData_vt");    //내용
    String gubun = request.getParameter("hdn_gubun");
    String paramA 			= WebUtil.nvl(request.getParameter("hdn_paramA"));          //파라메타
    String paramB 			= WebUtil.nvl(request.getParameter("hdn_paramB"));          //파라메타
    String paramC			= WebUtil.nvl(request.getParameter("hdn_paramC"));          //파라메타
    String paramD			= WebUtil.nvl(request.getParameter("hdn_paramD"));          //파라메타
    String paramE			= WebUtil.nvl(request.getParameter("hdn_paramE"));          //파라메타

    out.println("gubun : " + gubun);
    out.println(paramD);
    out.println(paramE);
    String fileName = "";

    String [][]hardList = {
    						{"19","HPI"},
    					   	{"20","SP"},
    					   };

    for(int i = 0 ; i < hardList.length ; i ++ ){
    	if(hardList[i][0].equals(gubun)){
    		fileName = hardList[i][1];
    	}
    }
    fileName += "_DetailList";

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename="+ fileName +".xls");
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

<%
    if ( F00DeptDetailListData_vt != null && F00DeptDetailListData_vt.size() > 0 ) {
%>
<table width="900" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="title02">* Staff Present State Detail</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="19" class="td09">
            &nbsp;Org.Unit : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td class="td08">&lt;Total Count <%=F00DeptDetailListData_vt.size()%>&gt;&nbsp;</td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Corp.</td>
          <%
          	if((paramE.equals("") || paramE == null) && (paramD.equals("") || paramD == null)){		//상세보기시, SP일 경우.
          %>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">SP-Org.Unit.</td>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">SP-Position. </td>
          <%
          	}
          %>
          <%
          	if(paramE.equals("N") && paramE != null){			//상세보기시, POSITION일 경우.
          %>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Position</td>
          <%
          	}
          %>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Pers.No</td>
          <%
          	if(paramE.equals("N") && paramE != null){			//상세보기시, POSITION일 경우.
          %>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Emp.Subgroup</td>
          <%
          	}
          %>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Name</td>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Res. of Office</td>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Title of Level</td>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Level/Annual</td>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Job</td>
          <%
          	if(paramD.equals("H")){		//HPI일 경우.
           %>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">HPI-Start Date</td>
          <%
          	}
          %>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Hiring Date</td>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Continuous<br>(Y / M)</td>
          <td rowspan = 2 class="td03" nowrap style="text-align:center">Age</td>
          <td colspan="2" class="td03" nowrap style="text-align:center">Academic Background</td>
          <td colspan="5" class="td03" nowrap style="text-align:center">Foreign Language Ability</td>
          <td colspan="3" class="td03" nowrap style="text-align:center">Relative Evaluation</td>
        </tr>
		<tr>
		  <td class="td03" nowrap style="text-align:center">University<br>(Major)</td>
		  <td class="td03" nowrap style="text-align:center">Master`s<br>(Branch of Study)</td>
		  <td class="td03" nowrap style="text-align:center">CET</td>
		  <td class="td03" nowrap style="text-align:center">TOEIC</td>
		  <td class="td03" nowrap style="text-align:center">JLPT</td>
		  <td class="td03" nowrap style="text-align:center">NSS</td>
		  <td class="td03" nowrap style="text-align:center">KPT</td>
		  <td class="td03" nowrap style="text-align:center">P</td>
		  <td class="td03" nowrap style="text-align:center">P1</td>
		  <td class="td03" nowrap style="text-align:center">P2</td>
		</tr>
<%
        //내용.
        for( int i = 0; i < F00DeptDetailListData_vt.size(); i++ ){
            F00DeptDetail1ListData data = (F00DeptDetail1ListData)F00DeptDetailListData_vt.get(i);
%>
        <tr align="center">
          <td class="td09" nowrap>&nbsp;<%= data.PBTXT %>&nbsp;</td>
          <%
          	if((paramE.equals("") || paramE == null) && (paramD.equals("") || paramD == null)){		//상세보기시, SP일 경우.
          %>
          <td class="td09" nowrap>&nbsp;<%= data.ORGTX_SP %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.POSIX_SP %>&nbsp;</td>
          <%
          	}
          %>
          <%
          	if(paramE.equals("N") && paramE != null){			//상세보기시, POSITION일 경우.
          %>
          <td class="td09" nowrap>&nbsp;<%= data.POSIX %>&nbsp;</td>
          <%
          	}
          %>
          <td class="td09" nowrap>&nbsp;<%= data.PERNR.equals("00000000") ? "Vacancy" : data.PERNR %>&nbsp;</td>
          <%
          	if(paramE.equals("N") && paramE != null){			//상세보기시, POSITION일 경우.
          %>
          <td class="td09" nowrap>&nbsp;<%= data.PTEXT %>&nbsp;</td>
          <%
          	}
          %>
          <td class="td09" nowrap style="text-align:left">&nbsp;<%= data.ENAME %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:left">&nbsp;<%= data.JIKKT %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:left">&nbsp;<%= data.JIKWT %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:left">&nbsp;<%= data.JIKCT_ANN %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:left">&nbsp;<%= data.STLTX %>&nbsp;</td>
          <%
          	if(paramD.equals("H")){		//HPI일 경우.
           %>
          <td class="td09" nowrap>&nbsp;<%= (data.HPI_DATE).equals("0000-00-00") ?  "" : WebUtil.printDate(data.HPI_DATE) %>&nbsp;</td>
          <%
          	}
          %>
          <td class="td09" nowrap>&nbsp;<%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.GUNSOK %>&nbsp;</td>
          <td class="td04" nowrap>&nbsp;<%= WebUtil.printNumFormat(data.OLDS) %>&nbsp;</td>
          <td class="td04" nowrap style="text-align:left">&nbsp;<%= data.UNIV %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:left">&nbsp;<%= data.MAST %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:right">&nbsp;<%= data.CET %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:right">&nbsp;<%= data.TOEIC %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:right">&nbsp;<%= data.JLPT %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:right">&nbsp;<%= data.NSS %>&nbsp;</td>
          <td class="td09" nowrap style="text-align:right">&nbsp;<%= data.KPT %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.RTEXT1%>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.RTEXT2 %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.RTEXT3 %>&nbsp;</td>
        </tr>
<%
                } //end for...
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
    <td  class="td04" align="center" height="25" >No data</td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>


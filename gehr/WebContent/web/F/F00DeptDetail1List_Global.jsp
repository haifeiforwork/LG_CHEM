<%/******************************************************************************/
/*                                                                              				*/
/*   System Name	: MSS                                                         	*/
/*   1Depth Name		: Manaer's Desk                                               */
/*   2Depth Name		: 인원현황                                                    				*/
/*   Program Name	: 인원현황 각각의 상세화면                                    		*/
/*   Program ID   	: F00DeptDetailList.jsp                                       	*/
/*   Description  	: 인원현황 각각의 상세화면 조회를 위한 jsp 파일              	*/
/*   Note			: 없음                                                        					*/
/*   Creation		: 2005-03-07 유용원                                           			*/
/*   Update			: 2008-01-22 김정인                                                     	*/
/*                                                                              				*/
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
    WebUserData user	= (WebUserData)session.getAttribute("user");                     //세션.
    String deptId 			= WebUtil.nvl(request.getParameter("hdn_deptId"));            //부서코드
    String deptNm			= (WebUtil.nvl(request.getParameter("hdn_deptNm")));        //부서명
    String gubun			= WebUtil.nvl(request.getParameter("hdn_gubun"));           	 //구분값.
    String checkYN		= WebUtil.nvl(request.getParameter("chck_yeno"));           	 //하위부서여부.
    String paramA 			= WebUtil.nvl(request.getParameter("hdn_paramA"));          //파라메타
    String paramB 			= WebUtil.nvl(request.getParameter("hdn_paramB"));          //파라메타
    String paramC			= WebUtil.nvl(request.getParameter("hdn_paramC"));          //파라메타
    String paramD			= WebUtil.nvl(request.getParameter("hdn_paramD"));          //파라메타
    String paramE			= WebUtil.nvl(request.getParameter("hdn_paramE"));          //파라메타

    //out.println("[F00DeptDetail1List.jsp] paramE	=  " + paramE);

    Vector F00DeptDetailListData_vt  = (Vector)request.getAttribute("F00DeptDetailListData_vt");    //내용

    int    l_count             = 0;
	//page 처리
    String  paging              = request.getParameter("page");
    String num = request.getParameter("history");
    String chkAll = request.getParameter("chek_all");
    if(chkAll==null){
    	chkAll = "";
    }
    if(num==null || num.equals("")){
    	num="-1";
    }
    boolean isFirst             = false;
    l_count = F00DeptDetailListData_vt.size();

	//PageUtil 관련 - Page 사용시 반드시 써줄것.
  	PageUtil pu = null;
  	if(chkAll.equals("")){
	   	try {
			pu = new PageUtil(l_count, paging , 14, 10);
			Logger.debug.println(this, "page : "+paging);
	   	} catch (Exception ex) {
	   		Logger.debug.println(DataUtil.getStackTrace(ex));
	   	}
   	}
%>

<SCRIPT LANGUAGE="JavaScript">
<!--

//목록으로 가기.
function do_list(){
    history.go(<%=num%>);
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    //alert(<%= paramD %>);
        //alert(<%= paramE %>);

    frm.hdn_gubun.value  = "<%= gubun %>";      //구분값
    frm.hdn_deptId.value = "<%= deptId %>";     //부서코드
    frm.chck_yeno.value  = "<%= checkYN %>";    //하위부서여부
    frm.hdn_paramA.value = "<%= paramA %>";     //파라메타
    frm.hdn_paramB.value = "<%= paramB %>";     //파라메타
    frm.hdn_paramC.value = "<%= paramC %>";     //파라메타
    frm.hdn_paramD.value = "<%= paramD %>";     //파라메타
    frm.hdn_paramE.value = "<%= paramE %>";     //파라메타
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetail1ListSV";
    frm.target = "hidden";
    frm.submit();
    frm.hdn_excel.value = "";
}

function go_Insaprint(pernr){

    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1010,height=662,left=0,top=2");

    document.form1.target = "essPrintWindow";
    document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_insa.jsp?pernr=" + pernr;
    document.form1.method = "post";
    document.form1.submit();
}

function PageMove_m() {
    frm = document.form1;

    frm.hdn_gubun.value  = "<%= gubun %>";      //구분값
    frm.hdn_deptId.value = "<%= deptId %>";     //부서코드
    frm.chck_yeno.value  = "<%= checkYN %>";    //하위부서여부
    frm.hdn_paramA.value = "<%= paramA %>";     //파라메타
    frm.hdn_paramB.value = "<%= paramB %>";     //파라메타
    frm.hdn_paramC.value = "<%= paramC %>";     //파라메타
    frm.hdn_paramD.value = "<%= paramD %>";     //파라메타
    frm.hdn_paramE.value = "<%= paramE %>";     //파라메타
    document.form1.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetail1ListSV";
    frm.target = "_self";
    document.form1.submit();
}

function fnc_all(){
    frm = document.form1;
    if ( frm.chk_All.checked == true )
        frm.chek_all.value = 'Y';
    else
        frm.chek_all.value = '';
    document.form1.history.value -=1;
    frm.hdn_gubun.value  = "<%= gubun %>";      //구분값
    frm.hdn_deptId.value = "<%= deptId %>";     //부서코드
    frm.chck_yeno.value  = "<%= checkYN %>";    //하위부서여부
    frm.hdn_paramA.value = "<%= paramA %>";     //파라메타
    frm.hdn_paramB.value = "<%= paramB %>";     //파라메타
    frm.hdn_paramC.value = "<%= paramC %>";     //파라메타
    frm.hdn_paramD.value = "<%= paramD %>";     //파라메타
    frm.hdn_paramE.value = "<%= paramE %>";     //파라메타
    document.form1.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetail1ListSV";
    frm.target = "_self";
    document.form1.submit();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    document.form1.history.value -=1;
    PageMove_m();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}

//-->
</SCRIPT>

<html>
<head>
<title>MSS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="chck_yeno"   value="">
<input type="hidden" name="hdn_paramA"  value="">
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="<%= paramD %>">
<input type="hidden" name="hdn_paramE"  value="<%= paramE %>">

<table width="780" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="764" border="0" cellpadding="0" cellspacing="0" align="left">
        <tr>
          <td height="5" ></td>
        </tr>
        <tr>
          <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">Staff Present State Detail</td>
        </tr>
        <tr>
            <td  colspan="1" height="3" align="left" valign="top" background="/web/images/maintitle_line.gif"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
        </tr>
      </table>
    </td>
  </tr>

  <tr>
    <td height="10" >&nbsp;</td>
  </tr>
</table>

<%
    if ( F00DeptDetailListData_vt != null && F00DeptDetailListData_vt.size() > 0 ) {
%>
<table width="900" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
	      <td width="50%" class="td09_1">
	        &nbsp;Org.Unit: <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
            &nbsp;&nbsp;<a href="javascript:excelDown();"><img src="<%= WebUtil.ImageURL %>btn_EXCELdownload.gif" border="0" align="absmiddle"></a>
          <span style="display:<%=l_count<=14?"none":"inline" %>"><input type="checkbox" name="chk_All" value="" onClick="javaScript:fnc_all();" <%=(chkAll.equals("")?"":"checked") %> >Show All<input type="hidden" name="chek_all" value="<%=chkAll %>"></span>
          </td>
	      <td width="50%" class="td08" style="text-align:left"><%= (chkAll.equals(""))?(pu == null ? "" : pu.pageInfo()):"&lt;Total Count "+l_count+"&gt;" %> &nbsp;</td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16" nowrap="nowrap">&nbsp;&nbsp;&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="0" cellpadding="0" cellspacing="1" class="table02">
        <tr>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Corp.&nbsp;</td>
          <%
          	if((paramE.equals("") || paramE == null) && (paramD.equals("") || paramD == null)){		//상세보기시, SP일 경우.
           %>
          <td rowspan = 2 class="td03" nowrap>&nbsp;SP-Org.Unit.&nbsp;</td>
          <td rowspan = 2 class="td03" nowrap>&nbsp;SP-Position.&nbsp;</td>
          <%
          	}
          %>
          <%
          	if(paramE.equals("N") && paramE != null){			//상세보기시, POSITION일 경우.
          %>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Position&nbsp;</td>
          <%
          	}
          %>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Pers.No&nbsp;</td>
          <%
          	if(paramE.equals("N") && paramE != null){			//상세보기시, POSITION일 경우.
          %>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Emp.Subgroup&nbsp;</td>
          <%
          	}
          %>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Name&nbsp;</td>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Res. of Office&nbsp;</td>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Title of Level&nbsp;</td>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Level/Annual&nbsp;</td>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Job&nbsp;</td>
          <%
          	if(paramD.equals("H")){		//HPI일 경우.
           %>
          <td rowspan = 2 class="td03" nowrap>&nbsp;HPI-Start Date&nbsp;</td>
          <%
          	}
           %>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Hiring Date&nbsp;</td>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Continuous&nbsp;<br>&nbsp;(Y / M)&nbsp;</td>
          <td rowspan = 2 class="td03" nowrap>&nbsp;Age&nbsp;</td>
          <td colspan="2" class="td03" nowrap>&nbsp;Academic Background&nbsp;</td>
          <td colspan="5" class="td03" nowrap>&nbsp;Foreign Language Ability&nbsp;</td>
          <td colspan="3" class="td03" nowrap>&nbsp;Relative Evaluation&nbsp;</td>
        </tr>
		<tr>
		  <td class="td03" nowrap>&nbsp;University&nbsp;<br>&nbsp;(Major)&nbsp;</td>
		  <td class="td03" nowrap>&nbsp;Master`s&nbsp;<br>&nbsp;(Branch of Study)&nbsp;</td>
		  <td class="td03" nowrap width="50">&nbsp;CET&nbsp;</td>
		  <td class="td03" nowrap width="50">&nbsp;TOEIC&nbsp;</td>
		  <td class="td03" nowrap width="50">&nbsp;JLPT&nbsp;</td>
		  <td class="td03" nowrap width="50">&nbsp;NSS&nbsp;</td>
		  <td class="td03" nowrap width="50">&nbsp;KPT&nbsp;</td>
		  <td class="td03" nowrap width="50">&nbsp;P-1&nbsp;</td>
		  <td class="td03" nowrap width="50">&nbsp;P-2&nbsp;</td>
		  <td class="td03" nowrap width="50">&nbsp;P-3&nbsp;</td>
        </tr>

<%
        //내용.
        int ifrom = chkAll.equals("")?pu.formRow():0;
        int ito = chkAll.equals("")?pu.toRow():l_count;
        for( int i = ifrom ; i < ito; i++ ){
            F00DeptDetail1ListData data = (F00DeptDetail1ListData)F00DeptDetailListData_vt.get(i);
%>
        <tr align="center">
          <td class="td09" nowrap><%= data.PBTXT %></td>
          <%
          	if((paramE.equals("") || paramE == null) && (paramD.equals("") || paramD == null)){		//상세보기시, SP일 경우.
           %>
          <td class="td09" nowrap><%= data.ORGTX_SP %></td>
          <td class="td09" nowrap><%= data.POSIX_SP %></td>
          <%
          	}
          %>
          <%
          	if(paramE.equals("N") && paramE != null){		//상세보기시, POSITION일 경우.
          %>
          <td class="td09" nowrap><%= data.POSIX %></td>
          <%
          	}
          %>
          <td class="td09" nowrap>&nbsp;<% if(!data.PERNR.equals("00000000")){ %><a href="javascript:go_Insaprint('<%=data.PERNR%>');"><% } %><%= data.PERNR.equals("00000000") ? "Vacancy" : data.PERNR %></a>&nbsp;</td>
          <%
          	if(paramE.equals("N") && paramE != null){			//상세보기시, POSITION일 경우.
          %>
          <td class="td09" nowrap>&nbsp;<%= data.PTEXT %>&nbsp;</td>
          <%
          	}
          %>
          <td class="td09" nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.JIKKT %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.JIKWT %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.JIKCT_ANN %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.STLTX %>&nbsp;</td>
          <%
          	if(paramD.equals("H")){		//HPI일 경우.
           %>
          <td class="td09" nowrap>&nbsp;<%= (data.HPI_DATE).equals("0000-00-00") ?  "" : WebUtil.printDate(data.HPI_DATE) %>&nbsp;</td>
          <%
	      	}
	      %>
          <td class="td09" nowrap>&nbsp;<%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.GUNSOK.replace(".","/") %>&nbsp;</td>
          <td class="td04" nowrap>&nbsp;<%= WebUtil.printNumFormat(data.OLDS) %>&nbsp;</td>
          <td class="td04" nowrap>&nbsp;<%= data.UNIV %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.MAST %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.CET %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.TOEIC %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.JLPT %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.NSS %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.KPT %>&nbsp;</td>
          <td class="td09" nowrap>&nbsp;<%= data.RTEXT1 %>&nbsp;</td>
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
  <tr>
    <td colspan="3" align="left" style="text-indent: 350"><%= chkAll.equals("")?(pu == null ? "" : pu.pageControl()):"" %>
    </td>
  </tr>   <tr><td height="16"></td></tr>
  <tr>
    <td colspan="3" align="left" style="text-indent: 350">
      <a href="javascript:do_list();"><img src="<%= WebUtil.ImageURL %>btn_list.gif" name="image3" border="0" align="absmiddle"></a>
    </td>
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
  <input type="hidden" name="jobid2"   value="printGlobal">
  <input type="hidden" name="page"     value="">
  <input type="hidden" name="history"     value="<%=num %>">
</form>
</body>
</html>


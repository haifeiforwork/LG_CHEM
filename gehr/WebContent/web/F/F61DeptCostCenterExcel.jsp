<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 코스트센터                                                  */
/*   Program Name : 부서별 코스트센터 조회                                      */
/*   Program ID   : F61DeptCostCenterExcel.jsp                                  */
/*   Description  : 부서별 코스트센터 조회 Excel 저장을 위한 jsp 파일           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/commonProcess.jsp" %> 

<%@ page import="java.util.Vector" %> 
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>  
          
<%    
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptCostCenter_vt = (Vector)request.getAttribute("DeptCostCenter_vt");
    
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptCostCenter.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */        
%>
 
<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=ks_c_5601-1987">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">      
  
<% 
    //부서명, 조회된 건수.
    if ( DeptCostCenter_vt != null && DeptCostCenter_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02">* 부서별 코스트센터 조회</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="4" class="td09">&nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
          <td colspan="1"  class="td08">(총 <%=DeptCostCenter_vt.size()%> 건)&nbsp;</td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>         
  <tr>
    <td width="16">&nbsp;</td>
    <td >
        <table  border="1" cellspacing="1" cellpadding="4" class="table02">
          <tr> 
            <td class="td03" >부서명</td>
            <td class="td03" >코스트센터명</td>
            <td class="td03" >코스트센터ID</td>
            <td class="td03" >시작일자</td>
            <td class="td03" >효력만료일</td>
          </tr>
<%
            for( int i = 0; i < DeptCostCenter_vt.size(); i++ ){
                F61DeptCostCenterData data = (F61DeptCostCenterData)DeptCostCenter_vt.get(i);
%>
          <tr align="center"> 
            <td class="td04"><%= data.STEXT %></td>                                                                 
            <td class="td04"><%= data.KTEXT %></td>                                                             
            <td class="td04"><%= data.KOSTL %></td>                                                             
            <td class="td04"><%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %></td>    
            <td class="td04"><%= (data.ENDDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.ENDDA) %></td>    
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
    <td  class="td04" align="center" height="25" >해당하는 데이터가 존재하지 않습니다.</td>
  </tr>
</table>  
<%
    } //end if...
%>      
</form>

</body>
</html>

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : PDF 조회                                             	*/
/*   Program Name : PDF 조회                                             	*/
/*   Program ID   : D11TaxAdjustPdfDetail.jsp                                   */
/*   Description  : 담당자가 PDF 조회                     			*/
/*   Note         :                                                             */
/*   Creation     : 2014-01-14  lsa  [CSR ID:1263333] 				*/
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);


            String PERNR;
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            }
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

    //String UPMU_TYPE = "16";
    //
    //PersonData pData = (PersonData)request.getAttribute("PersonData");
    //String company = pData.E_BUKRS;
    //String e_stras = pData.E_STRAS;
    //String e_locat = pData.E_LOCAT;
    //
    //String PERNR = (String)request.getAttribute("PERNR");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">
  <input type="hidden" name = "PERNR" value="<%=PERNR%>">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780"> <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif"><spring:message code="LABEL.D.D11.0198" /><!-- PDF 조회 --></td>
                  <td class="titleRight"><a href="javascript:open_help('A15Certi.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    }
%>

          <tr>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <input type="hidden" name="jobid" value="" >
</form>

<%@ include file="/web/common/commonEnd.jsp" %>
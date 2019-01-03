<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 국민연금 자격 변경 결재                                     */
/*   Program ID   : G040ApprovalFinishMedicare.jsp                              */
/*   Description  : 국민연금 자격 변경 결재                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-28 이승희                                           */
/*   Update       : 2003-03-28 이승희                                           */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E04Pension.E04PensionChngData" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    
    E04PensionChngData e04PensionChngData = (E04PensionChngData)request.getAttribute("e04PensionChngData");

    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e04PensionChngData.AINF_SEQN ,user.empNo ,false);
    int approvalStep = docinfo.getApprovalStep();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

  
   
    function approval()
    {   
        var frm = document.form1;
        
        if(!confirm("결재 하시겠습니까.")) {
            return;
        } // end if

        frm.APPR_STAT.value = "A";
        frm.submit();
    }
   
    function reject()
    {
        if(!confirm("반려 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPR_STAT.value = "R";
        frm.submit();
    }
    
    function goToList() 
    {
        var frm = document.form1;
    <% if (isCanGoList) { %>
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
    <% } // end if %>
        frm.jobid.value ="";
        frm.submit();
    }


//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');">
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="PERNR"     value="<%=e04PensionChngData.PERNR%>">
<input type="hidden" name="BEGDA"     value="<%=e04PensionChngData.BEGDA%>">
<input type="hidden" name="AINF_SEQN" value="<%=e04PensionChngData.AINF_SEQN%>">

<input type="hidden" name="APPR_STAT">
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<input type="hidden" name="approvalStep" value="<%=approvalStep%>">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td height="5" colspan="2"></td>
                </tr>
                <tr> 
                  <td width="624" class="title02">
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 국민연금 자격 변경 결재해야 할 문서 
                  </td>
                  <td align="right" style="padding-bottom:4px">&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
          <tr> 
            <td height="10">
             <!-- 신청자 기본 정보 시작 -->
             <%@ include file="/web/common/ApprovalIncludePersInfo.jsp" %>
             <!--  신청자 기본 정보 끝-->
            </td>
          </tr>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
          <tr> 
            <td> 
              <!-- 상단 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr> 
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td width="100" class="td01">신청일자</td>
                              <td class="td09"> <%= WebUtil.printDate(e04PensionChngData.BEGDA) %></td>
                            </tr>
                          </table></td>
                      </tr>
                       <tr> 
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                          자격사항 변경 </td>
                      </tr>
                      <tr> 
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td class="td01" width="100">변경항목 <font color="#006699">*</font></td>
                              <td width="220" class="td09" colspan="3"> <%= e04PensionChngData.CHNG_TEXT %> </td>
                            </tr>
                            <tr> 
                              <td class="td01">변경전 Data <font color="#006699">*</font></td>
                              <td class="td09"> <%= e04PensionChngData.CHNG_BEFORE %></td>
                              <td class="td01"  width="100" >변경후 Data <font color="#006699">*</font></td>
                              <td class="td09"> <%= e04PensionChngData.CHNG_AFTER %></td>
                            </tr>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
            </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td>
          </tr>
        <%
            String tmpBigo = "";
        %>
        <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
           <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
           <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                <% if (ald.APPL_PERNR.equals(user.empNo)) { %>
                    <% tmpBigo = ald.APPL_BIGO_TEXT; %>
                <% } else { %>
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                
                    <tr> 
                       <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                       <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
                    </tr>
                </table>
            </td>
          </tr>
                <% } // end if %>
            <% } // end if %>
        <% } // end for %>
          <tr> 
            <td class="td03" style="padding-top:5px;padding-bottom:5px">
                <textarea name="BIGO_TEXT" cols="80" rows="2"><%=tmpBigo%></textarea>
            </td>
          </tr>
          <tr> 
            <td> 
              <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 결재정보</td>
                </tr>
                <tr> 
                  <td>
                    <table width="780" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td> 
                          <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(vcAppLineData) %>
                          <!--결재정보 테이블 끝-->
                        </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">
                  <!--버튼 들어가는 테이블 시작 -->
                      <table width="780" border="0" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td class="td04">
                          <% if (isCanGoList) {  %>
                            <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                          <% } // end if %>
                            <a href="javascript:approval()"><img src="<%= WebUtil.ImageURL %>btn_submit.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                            <a href="javascript:reject()"><img src="<%= WebUtil.ImageURL %>btn_return.gif" border="0"></a>
                          </td>
                        </tr>
                      </table>
                  <!--버튼 들어가는 테이블 끝 -->
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

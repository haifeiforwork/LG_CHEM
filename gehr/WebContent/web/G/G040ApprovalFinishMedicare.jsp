<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 건강보험 재발급 결재 완료                                   */
/*   Program ID   : G040ApprovalFinishMedicare.jsp                              */
/*   Description  : 건강보험 재발급 결재 완료                                   */
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
<%@ page import="hris.E.E02Medicare.E02MedicareData" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    E02MedicareData e02MedicareData = (E02MedicareData)request.getAttribute("e02MedicareData");

    
    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e02MedicareData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

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
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="PERNR"     value="<%=e02MedicareData.PERNR%>">
<input type="hidden" name="BEGDA"     value="<%=e02MedicareData.BEGDA%>">
<input type="hidden" name="AINF_SEQN" value="<%=e02MedicareData.AINF_SEQN%>">

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
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 건강보험 재 발급 결재해야 할 문서 
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
                              <td width="200" class="td09"> <%= WebUtil.printDate(e02MedicareData.BEGDA) %></td>
                              <td width="100" class="td01">신청구분</td>
                              <td class="td09"> <%= e02MedicareData.APPL_TEXT2 %></td>
                            </tr>
                            <tr> 
                              <td class="td01" width="100">대상자성명<font color="#006699"><b></b></font></td>
                              <td colspan="3" class="td09"> <%= e02MedicareData.ENAME %></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td class="font01" style="padding-bottom:2px">
                          <input type="radio" <%= e02MedicareData.APPL_TEXT3.equals("") ? "" : "checked" %> disabled> 기재사항변경
                        </td>
                      </tr>
                      <tr> 
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td class="td01" width="100">변경항목&nbsp;<font color="#006699"><b>*</b></font></td>
                              <td class="td09" colspan="3"> <%= e02MedicareData.APPL_TEXT3.equals("기타") ? e02MedicareData.ETC_TEXT3 : e02MedicareData.APPL_TEXT3 %></td>
                            </tr>
                            <tr> 
                              <td class="td01">변경전Data&nbsp;<font color="#0000FF"><font color="#006699"><b>*</b></font></font></td>
                              <td width="200" class="td09"> <%= e02MedicareData.CHNG_BEFORE %></td>
                              <td width="100" class="td01">변경후Data&nbsp;<font color="#006699"><b>*</b></font></td>
                              <td class="td09"> <%= e02MedicareData.CHNG_AFTER %></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td class="font01" style="padding-bottom:2px">
                            <input type="radio" <%= e02MedicareData.APPL_TEXT4.equals("") ? "" : "checked" %> disabled> 추가발급
                        </td>
                      </tr>
                      <tr> 
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td class="td01" width="100">발급사유&nbsp;<font color="#006699"><b>*</b></font></td>
                              <td class="td09" width="200"> <%= e02MedicareData.APPL_TEXT4.equals("기타") ? e02MedicareData.ETC_TEXT4 : e02MedicareData.APPL_TEXT4 %></td>
                              <td class="td01" width="100">발행부수</td>
                              <td class="td09"> <%=WebUtil.printNum(e02MedicareData.ADD_NUM)%></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td class="font01" style="padding-bottom:2px">
                            <input type="radio" <%= e02MedicareData.APPL_TEXT5.equals("") ? "" : "checked" %> disabled> 재발급 
                        </td>
                      </tr>
                      <tr> 
                        <td>
                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td class="td01" width="100">신청사유<font color="#006699"><b>*</b></font></td>
                              <td class="td09" width="200"> <%= e02MedicareData.APPL_TEXT5.equals("기타") ? e02MedicareData.ETC_TEXT5 : e02MedicareData.APPL_TEXT5 %></td>
                              <td class="td01" width="100">발행부수</td>
                              <td class="td09"> <%=WebUtil.printNum(e02MedicareData.ADD_NUM1) %></td>
                            </tr>
                          </table>
                          
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
            </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        <% 
            boolean visible = false;
            for (int i = 0; i < vcAppLineData.size(); i++) {
                AppLineData ald = (AppLineData) vcAppLineData.get(i);
                if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { 
                    visible = true;
                    break;
                } // end if 
            } // end for 
       %>
       <%   if (visible) { %>
          <tr> 
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td>
          </tr>  
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
                    <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
                    <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr> 
                       <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                       <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
                    </tr>
                    <% } // end if %>
                <% } // end for %>
                </table>
            </td>
          </tr>
        <% } // end if %>
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

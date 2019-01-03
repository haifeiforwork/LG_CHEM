<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 재해 결재 완료                                              */
/*   Program ID   : G021ApprovalFinishDisaster.jsp                              */
/*   Description  : 재해 결재 완료                                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Disaster.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    
    E19CongcondData  e19CongcondData  = (E19CongcondData)request.getAttribute("e19CongcondData");
    
    Vector  vcE19DisasterData  = (Vector)request.getAttribute("vcE19DisasterData");
    
    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");
   
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e19CongcondData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

    function open_report()
    {
	    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19ReportDetailSV";
	    document.form1.method = "post";
	    document.form1.submit();
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
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

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
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 재해신청 결재완료 문서 
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
              <!-- 상단 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr> 
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td>
                          <!--신청일 테이블 시작-->
                          <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                              <td width="100" class="td01">신청일</td>
                              <td width="200" class="td09"> <%=WebUtil.printDate(e19CongcondData.BEGDA)%></td>
                              <td width="110" class="td01">경조내역</td>
                              <td class="td09"> <input type="text" name="disa_name" value="재해" size="20" class="input04" readonly> 
                              </td>
                            </tr>
                            <tr> 
                              <td class="td01">재해발생일자&nbsp;<font color="#006699">*</font></td>
                              <td class="td09"> <%=WebUtil.printDate(e19CongcondData.CONG_DATE)%></td>
                              <td>
                                <a href="javascript:open_report();">
	                               <img src="<%= WebUtil.ImageURL %>btn_report_serch.gif" align="absmiddle" border="0">
	                            </a>
                              </td>
                              <td class="td09"><font color="#6666FF">&nbsp;<%= vcE19DisasterData.size() %>&nbsp;건</font></td>
                            </tr>
                          </table>
                          <!--신청일 테이블 끝-->
                        </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td> 
                          <!--통상임금 테이블 시작-->
                          <table width="100%" border="0" cellspacing="1" cellpadding="0">
<!--                           
                            <tr> 
                              <td width="100" class="td01">통상임금</td>
                              <td class="td09" colspan="3"> <%= WebUtil.printNumFormat(Double.parseDouble(e19CongcondData.WAGE_WONX)*100) %>원 </td>
                            </tr>
                           
                            <tr> 
                              <td class="td01">지급율</td>
                              <td class="td09" colspan="3"> <%= e19CongcondData.CONG_RATE %>% </td>
                            </tr>
-->                              
                            <tr> 
                              <td class="td01">경조금액</td>
                              <td class="td09" width="255" colspan="3"> <%= WebUtil.printNumFormat(Double.parseDouble(e19CongcondData.CONG_WONX)*100) %>원 </td>
                            </tr>
                          
                            <tr> 
                              <td class="td01">이체은행명</td>
                              <td class="td09" width="200"> <%= e19CongcondData.BANK_NAME %></td>
                              <td class="td01" width="100">은행계좌번호</td>
                              <td class="td09"> <%= e19CongcondData.BANKN %></td>
                            </tr>
                            <tr> 
                              <td class="td01">근속년수</td>
                              <td class="td09" colspan="3"> 
                                <%=WebUtil.printNum(e19CongcondData.WORK_YEAR) %>년 
                                <%=WebUtil.printNum(e19CongcondData.WORK_MNTH) %>개월 
                              </td>
                            </tr>
                            <tr>
                              <td class="td01">증빙확인유무</td>
                              <td class="td09"><input name="chPROOF" type="checkbox" <%= e19CongcondData.PROOF.equals("X") ? "checked" : "" %> value="X" disabled></td>
                              <td class="td09">회계전표번호</td>
                              <td class="td09"><%=e19CongcondData.BELNR%></td>
                            </tr>
                          </table>      <!--통상임금 테이블 끝-->
                        </td>
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
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    결재정보</td>
                </tr>
                <tr> 
                  <td><table width="780" border="0" cellspacing="0" cellpadding="0">
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
              </table></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  
  <input type="hidden" name="RowCount_report" value="<%=vcE19DisasterData.size()%>">
  <input type="hidden" name="retPage" value="<%=WebUtil.ServletURL%>hris.G.G021ApprovalFinishDisasterSV">
<%
    for(int i = 0 ; i < vcE19DisasterData.size() ; i++){
        E19DisasterData e19DisasterData = (E19DisasterData)vcE19DisasterData.get(i);
%>
    <input type="hidden" name="DISA_RESN<%= i %>"  value="<%= e19DisasterData.DISA_RESN   %>">
    <input type="hidden" name="DISA_CODE<%= i %>"  value="<%= e19DisasterData.DISA_CODE   %>">
    <input type="hidden" name="DREL_CODE<%= i %>"  value="<%= e19DisasterData.DREL_CODE   %>">
    <input type="hidden" name="DISA_RATE<%= i %>"  value="<%= e19DisasterData.DISA_RATE   %>">
    <input type="hidden" name="CONG_DATE<%= i %>"  value="<%= e19DisasterData.CONG_DATE   %>">
    <input type="hidden" name="DISA_DESC1<%= i %>" value="<%= e19DisasterData.DISA_DESC1  %>">
    <input type="hidden" name="DISA_DESC2<%= i %>" value="<%= e19DisasterData.DISA_DESC2  %>">
    <input type="hidden" name="DISA_DESC3<%= i %>" value="<%= e19DisasterData.DISA_DESC3  %>">
    <input type="hidden" name="DISA_DESC4<%= i %>" value="<%= e19DisasterData.DISA_DESC4  %>">
    <input type="hidden" name="DISA_DESC5<%= i %>" value="<%= e19DisasterData.DISA_DESC5  %>">
    <input type="hidden" name="EREL_NAME<%= i %>"  value="<%= e19DisasterData.EREL_NAME   %>">
    <input type="hidden" name="INDX_NUMB<%= i %>"  value="<%= e19DisasterData.INDX_NUMB   %>">
    <input type="hidden" name="PERNR<%= i %>"      value="<%= e19DisasterData.PERNR       %>">
    <input type="hidden" name="REGNO<%= i %>"      value="<%= e19DisasterData.REGNO       %>">
    <input type="hidden" name="STRAS<%= i %>"      value="<%= e19DisasterData.STRAS       %>">
    <input type="hidden" name="AINF_SEQN<%= i %>"  value="<%= e19DisasterData.AINF_SEQN   %>">
<%
    } // end for
%>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

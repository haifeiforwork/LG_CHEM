<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 진행중 문서                                            */
/*   Program Name : 교육/출장 신청 결재 진행중/취소                             */
/*   Program ID   : G069ApprovalIngEduTrip.jsp                                  */
/*   Description  : 교육/출장 신청 결재 진행중/취소                             */
/*   Note         :                                                             */
/*   Creation     : 2010-03-08  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D19EduTrip.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    D19EduTripData   data  = (D19EduTripData)request.getAttribute("D19EduTripData"); 
    Vector vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String RequestPageName = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(data.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
  //근태유형추가
  Vector D03VocationAReason0010_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR, "0010",DataUtil.getCurrentDate());
  Vector D03VocationAReason0020_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR, "0020",DataUtil.getCurrentDate());
 
  Vector D03OvertimeCodeData0010_vt  = new Vector(); 
  for( int i = 0 ; i < D03VocationAReason0010_vt.size() ; i++ ){
      D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0010_vt.get(i);
      CodeEntity code_data = new CodeEntity();
      code_data.code = old_data.SCODE ;
      code_data.value = old_data.STEXT ;
      D03OvertimeCodeData0010_vt.addElement(code_data);
  }   
 
  Vector D03OvertimeCodeData0020_vt  = new Vector(); 
  for( int i = 0 ; i < D03VocationAReason0020_vt.size() ; i++ ){
      D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0020_vt.get(i);
      CodeEntity code_data = new CodeEntity();
      code_data.code = old_data.SCODE ;
      code_data.value = old_data.STEXT ;
      D03OvertimeCodeData0020_vt.addElement(code_data);
  }     
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

    function cancel()
    {
        if(!confirm("취소 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPR_STAT.value = "";
        frm.submit();
    }

    function goToList()
    {
        var frm = document.form1;
        frm.jobid.value ="";
    <% if (RequestPageName != null ) { %>
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
    <% } // end if %>

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

<input type="hidden" name="PERNR"        value="<%=data.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=data.BEGDA%>">
<input type="hidden" name="AINF_SEQN"    value="<%=data.AINF_SEQN%>">

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
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 교육/출장 결재진행 중 문서
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
                  <td class="tr01">
                  <table width="730" border="0" cellspacing="1" cellpadding="2">
                    <tr>
                      <td width="95" class="td01">신청일</td>
                      <td class="td09">
                        <input type="text" name="BEGDA" value="<%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>" size="20" class="input04" readonly>
                      </td>
                    </tr>
                    <tr>
                      <td class="td01" width="95">휴가구분</td>
                      <td class="td09">
                        <input type="radio" name="awart" value="0010" onClick="javascript:return;click_radio(this);" <%= data.AWART.equals("0010") ? "checked" : "" %>>
                        교육
                        <input type="radio" name="awart" value="0020" onClick="javascript:return;click_radio(this);" <%= data.AWART.equals("0020") ? "checked" : "" %>>
                        출장
                      </td>
                    </tr>
                    <tr id="gntaegubun">
                      <td class="td01" width="95">구분&nbsp;</td>
                      <td class="td09" align=left>
                        <table border=0 cellspacing=0 cellpadding=0>
                        <tr> 
                        <td>   
                        <select  name="OVTM_CODE" class="input04" disabled>
                        <%= data.AWART.equals("0010") ?  WebUtil.printOption( D03OvertimeCodeData0010_vt,data.OVTM_CODE) : WebUtil.printOption( D03OvertimeCodeData0020_vt,data.OVTM_CODE)%>   
                        </select>    

                        </td>
                        </tr>
                        </table>                               
                      </td>
                    </tr>              
                    <tr>
                      <td class="td01" width="95">신청사유</td>
                      <td class="td09">
                        <input type="text" name="REASON" value="<%= data.REASON %>" class="input04" size="80" readonly>
                      </td>
                    </tr>
                    <!--@v1.2-->
                    <tr>
                      <td class="td01" width="95">대근자</td>
                      <td class="td09">
                        <input type="text" name="OVTM_NAME" value="<%= data.OVTM_NAME %>" class="input04" size="10" maxlength="10" style="ime-mode:active" readonly>
                      </td>
                    </tr>
                   
                    <tr>
                      <td class="td01" width="95">신청기간</td>
                      <td class="td09">
                        <input type="text" name="APPL_FROM" value="<%= data.APPL_FROM.equals("0000-00-00") ? "" : WebUtil.printDate(data.APPL_FROM) %>" size="20" class="input04" readonly>
                        부터
                        <input type="text" name="APPL_TO"   value="<%= data.APPL_TO.equals("0000-00-00")   ? "" : WebUtil.printDate(data.APPL_TO)   %>" size="20" class="input04" readonly>
                        까지 
                      </td>
                    </tr>
<!--                    
                    <tr>
                      <td class="td01" width="95">신청시간</td>
                      <td class="td09">
                        <input type="text" name="BEGUZ" value="<%= data.BEGUZ.equals("") ? "" : WebUtil.printTime(data.BEGUZ) %>" size="20" class="input04" readonly>
                        부터
                        <input type="text" name="ENDUZ" value="<%= data.ENDUZ.equals("") ? "" : WebUtil.printTime(data.ENDUZ) %>" size="20" class="input04" readonly>
                        까지 <%= data.BEGUZ.equals("") && data.ENDUZ.equals("") ? "" : WebUtil.printNumFormat(DataUtil.getBetweenTime(data.BEGUZ, data.ENDUZ), 2) + " 시간" %>
                      </td>
                    </tr>
-->
                <input type="hidden" name="BEGUZ" value="<%=  data.BEGUZ  %>">
                <input type="hidden" name="ENDUZ" value="<%=  data.ENDUZ  %>">
                    
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
                          <% if (docinfo.isHasCancel()) {  %>
                            <a href="javascript:cancel()"><img src="<%= WebUtil.ImageURL %>btn_cancel01.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
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

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 건강보험 피 부양자 결재                                     */
/*   Program ID   : G037ApprovalMedicare.jsp                                    */
/*   Description  : 건강보험 피 부양자 결재                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-28 이승희                                           */
/*   Update       : 2003-03-28 이승희                                           */
/*                  2006-11-13  @v1.0 lsa 관계추가                              */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E01Medicare.E01HealthGuaranteeData" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    
    /* 현재 레코드를 vector로 받는다*/
    Vector vcE01HealthGuaranteeData = (Vector)request.getAttribute("vcE01HealthGuaranteeData");
    E01HealthGuaranteeData e01HealthGuaranteeData = (E01HealthGuaranteeData)vcE01HealthGuaranteeData.get(0);
    
    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e01HealthGuaranteeData.AINF_SEQN ,user.empNo ,false);
    int approvalStep = docinfo.getApprovalStep();

    //@v1.0 가족사항detail data get
    A04FamilyDetailRFC   rfcF   = new A04FamilyDetailRFC();
    Vector family_vt = new Vector();
    family_vt = rfcF.getFamilyDetail( e01HealthGuaranteeData.PERNR );
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

<input type="hidden" name="PERNR"     value="<%=e01HealthGuaranteeData.PERNR%>">
<input type="hidden" name="BEGDA"     value="<%=e01HealthGuaranteeData.BEGDA%>">
<input type="hidden" name="AINF_SEQN" value="<%=e01HealthGuaranteeData.AINF_SEQN%>">

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
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 건강보험 피부양자  결재해야 할 문서 
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
              <!--신청일자 상단 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr> 
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td width="110" class="td01">신청일자</td>
                              <td class="td09"> <%=WebUtil.printDate(e01HealthGuaranteeData.BEGDA)%></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><table width="100%" border="0" cellspacing="1" cellpadding="0" class="table02">
                            <tr> 
                              <td class="td03" width="20" >No</td>
                              <td width="70" class="td03">신청구분</td>
                              <td width="120" class="td03" >대상자<br>성명,관계</td>
                              <td width="70" class="td03" >취득일자<br>/상실일자</td>
                              <td class="td03" >취득사유/상실사유</td>
                              <td width="60" class="td03">원격지<br>발급여부</td>
                              <td width="70" class="td03" >장애인<br>종별부호</td>
                              <td width="60" class="td03" >장애인<br>등급</td>
                              <td width="70" class="td03" >장애인<br>등록일</td>
                            </tr>
                          <% for (int i = 0; i < vcE01HealthGuaranteeData.size(); i++) { %>
                            <% e01HealthGuaranteeData = (E01HealthGuaranteeData)vcE01HealthGuaranteeData.get(i); %>
                            <tr> 
                              <td class="td04"> <%=i + 1%></td>
                              <td class="td09"> <%= e01HealthGuaranteeData.APPL_TEXT %></td>
                              <td class="td09"> <%= e01HealthGuaranteeData.ENAME %>
<%  //@v1.0
    for ( int j = 0 ; j < family_vt.size() ; j++ ) {
        A04FamilyDetailData fdata = (A04FamilyDetailData)family_vt.get(j);
        String   fname      = fdata.LNMHG.trim() + ' ' + fdata.FNMHG.trim();
        String	   SUBTY		 = fdata.SUBTY;
        if (fname.equals(e01HealthGuaranteeData.ENAME)&& SUBTY.equals(e01HealthGuaranteeData.SUBTY)) {
%>
                   (<%=fdata.ATEXT%>)
<%      }
    } %>                    
                              </td>
                              <td class="td09"> <%= WebUtil.printDate(e01HealthGuaranteeData.ACCQ_LOSS_DATE) %></td>
                              <td class="td09"> <%= e01HealthGuaranteeData.ACCQ_LOSS_TEXT %></td>
                              <td class="td09" style="text-align : center;"> <input type="checkbox" class="input03" <%= e01HealthGuaranteeData.APRT_CODE.equals("X") ? "checked" : "" %> disabled></td>
                              <td class="td09"> <%= e01HealthGuaranteeData.HITCH_TEXT %></td>
                              <td class="td09"> <%= e01HealthGuaranteeData.HITCH_GRADE.equals("00") ? "" : e01HealthGuaranteeData.HITCH_GRADE %></td>
                              <td class="td09"> <%= e01HealthGuaranteeData.HITCH_DATE.equals("0000-00-00")||e01HealthGuaranteeData.HITCH_DATE.equals("") ? "" : e01HealthGuaranteeData.HITCH_DATE %></td>
                            </tr>
						  <% } // end for %>                            
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!-- 신청일자 상단 테이블 끝-->
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

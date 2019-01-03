<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 가족수당 상실 결재 완료                                     */
/*   Program ID   : G051ApprovalFinishAllowanceCancel.jsp                       */
/*   Description  : 가족수당 상실 결재 완료                                     */
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
<%@ page import="    hris.A.A12Family.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

    A12FamilyBuyangData a12FamilyBuyangData = (A12FamilyBuyangData)request.getAttribute("a12FamilyBuyangData");
    A12FamilyListData   a12FamilyListData = (A12FamilyListData)request.getAttribute("a12FamilyListData");

                    
    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(a12FamilyBuyangData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
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
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 가족수당 상실 결재완료 문서 
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
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 가족사항</td>
                      </tr>
                      <tr> 
                        <td> 
                          <!--가족사항 테이블 시작-->
                          <table width="100%" border="0" cellspacing="1" cellpadding="0" >
                            <tr> 
                              <td width="100" class="td01">신청일</td>
                              <td colspan="3" class="td09"> <%= WebUtil.printDate(a12FamilyBuyangData.BEGDA) %></td>
                            </tr>
                            <tr> 
                              <td class="td01">성명(한글)&nbsp;<font color="#006699">*</font></td>
                              <td class="td09" width="250"> <%= a12FamilyListData.LNMHG %> <%= a12FamilyListData.FNMHG %></td>
                              <td class="td01" width="100">가족유형&nbsp;<font color="#006699">*</font></td>
                              <td class="td09">  <%= a12FamilyListData.STEXT %></td>
                            </tr>
                            <tr> 
                              <td class="td01">주민등록번호&nbsp;<font color="#006699">*</font></td>
                              <td class="td09" width="250"> <%= DataUtil.addSeparate(a12FamilyListData.REGNO) %></td>
                              <td class="td01">관 계&nbsp;<font color="#006699">*</font></td>
                              <td class="td09"> <%= a12FamilyListData.ATEXT %></td>
                            </tr>
                            <tr> 
                              <td class="td01">생년월일&nbsp;<font color="#006699">*</font></td>
                              <td class="td09"> <%= WebUtil.printDate(a12FamilyListData.FGBDT)%></td>
                              <td class="td01">성 별</td>
                              <td class="td09">
                                <input type="radio" name="fasex" value="1" <%= a12FamilyListData.FASEX.equals("1") ? "checked" : "" %> disabled> 남
                                <input type="radio" name="fasex" value="2" <%= a12FamilyListData.FASEX.equals("2") ? "checked" : "" %> disabled> 여  
                              </td>
                            </tr>
                            <tr> 
                              <td class="td01">출생지</td>
                              <td class="td09"> <%= a12FamilyListData.FGBOT %></td>
                              <td class="td01">학 력&nbsp;<font color="#006699">*</font></td>
                              <td class="td09"> <%= a12FamilyListData.STEXT1 %></td>
                            </tr>
                            <tr> 
                              <td class="td01">출생국</td>
                              <td class="td09"> <%= a12FamilyListData.LANDX %></td>
                              <td class="td01">교육기관</td>
                              <td class="td09"> <%= a12FamilyListData.FASIN %></td>
                            </tr>
                            <tr> 
                              <td class="td01">국 적</td>
                              <td class="td09"> <%= a12FamilyListData.NATIO %></td>
                              <td class="td01">직 업</td>
                              <td class="td09"> <%= a12FamilyListData.FAJOB %></td>
                            </tr>
                            <tr> 
                              <td class="td01">상실 일자</td>
                              <td class="td09" colspan="3"> <%= WebUtil.printDate(a12FamilyBuyangData.LOSS_DATE) %></td>
                            </tr>
                          </table>
                          <!--가족사항 테이블 끝-->
                        </td>
                      </tr>
                    </table>
                    <br>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 업무 담당자 입력</td>
                      </tr>
                      <tr> 
                        <td>
                          <!--가족수당 적용일자 테이블 시작-->
			              <table width="780" border="0" cellpadding="0" cellspacing="" class="table03">
			                <tr> 
			                  <td width="150" class="td01">가족수당  상실 적용일자</td>
			                  <td class="td09">
			                    <%=WebUtil.printDate(a12FamilyBuyangData.APPL_DATE)%>
                              </td>
			                </tr>
			              </table>
			              <!--가족수당 적용일자 테이블 끝-->
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

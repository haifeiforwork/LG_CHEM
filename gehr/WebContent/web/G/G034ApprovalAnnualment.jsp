<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 개인연금 해약 결재                                          */
/*   Program ID   : G034ApprovalAnnualment.jsp                                  */
/*   Description  : 개인연금 해약 결재                                          */
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
<%@ page import="hris.E.E11Personal.E11PersonalData" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    
    E11PersonalData  e11PersonalData  = (E11PersonalData)request.getAttribute("e11PersonalData");
    E11PersonalData  appendData  = (E11PersonalData)request.getAttribute("appendData");
    
    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e11PersonalData.AINF_SEQN ,user.empNo ,false);
    int approvalStep = docinfo.getApprovalStep();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

    //달력 사용 시작
    function fn_openCal(Objectname)
    {
       var lastDate;
       lastDate = eval("document.form1." + Objectname + ".value");
       small_window=window.open("/web/common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    }
   
    function approval()
    {   
        var frm = document.form1;
        if(frm.CLOSE_DATE.value == "") {
            alert("해지 시작일을 입력하세요");
            return;
        } // end if
        
        if(!confirm("결재 하시겠습니까.")) {
            return;
        } // end if
        frm.CLOSE_DATE.value = removePoint(frm.CLOSE_DATE.value);
        frm.APPR_STAT.value = "A";
        frm.submit();
    }
   
    function reject()
    {
        if(!confirm("반려 하시겠습니까.")) {
            return;
        } // end if
        
        var frm = document.form1;
        frm.CLOSE_DATE.value = "";
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

<input type="hidden" name="PERNR"    value="<%=e11PersonalData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=e11PersonalData.BEGDA%>">
<input type="hidden" name="AINF_SEQN"    value="<%=e11PersonalData.AINF_SEQN%>">
<input type="hidden" name="APPL_TYPE"    value="<%=e11PersonalData.APPL_TYPE%>">
<input type="hidden" name="PENT_TYPE"    value="<%=e11PersonalData.PENT_TYPE%>">
<input type="hidden" name="BANK_TYPE"    value="<%=e11PersonalData.BANK_TYPE%>">
<input type="hidden" name="ENTR_DATE"    value="<%=e11PersonalData.ENTR_DATE%>">
<input type="hidden" name="ENTR_TERM"    value="<%=e11PersonalData.ENTR_TERM%>">
<input type="hidden" name="MNTH_AMNT"    value="<%=e11PersonalData.MNTH_AMNT%>">
<input type="hidden" name="PERL_AMNT"    value="<%=e11PersonalData.PERL_AMNT%>">
<input type="hidden" name="CMPY_AMNT"    value="<%=e11PersonalData.CMPY_AMNT%>">
<input type="hidden" name="CMPY_FROM"    value="<%=e11PersonalData.CMPY_FROM%>">
<input type="hidden" name="CMPY_TOXX"    value="<%=e11PersonalData.CMPY_TOXX%>">
<input type="hidden" name="CMPY_DATE"    value="<%=e11PersonalData.CMPY_DATE%>">
<input type="hidden" name="ZPENT_TEXT1"  value="<%=e11PersonalData.ZPENT_TEXT1%>">
<input type="hidden" name="ZPENT_TEXT2"  value="<%=e11PersonalData.ZPENT_TEXT2%>">
<input type="hidden" name="ZPERNR"       value="<%=e11PersonalData.ZPERNR%>">
<input type="hidden" name="ZUNAME"       value="<%=e11PersonalData.ZUNAME%>">

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
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 개인연금/마이라이프 해약신청 결재해야 할 문서 
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
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                          신청정보</td>
                      </tr>
			          <tr>
			            <td bgcolor="#FFFFFF">
			              <!-- 상단 입력 테이블 시작-->
			              <table border="0" cellpadding="0" cellspacing="1">
			                <tr>
                              <td width="100" class="td01">해약신청일</td>
                              <td class="td09" colspan="3"><%= WebUtil.printDate( e11PersonalData.BEGDA ) %></td>
                            </tr>
			                <tr>
			                  <td class="td01">연금구분</td>
			                  <td class="td09" width="200" ><%= appendData.PENT_TEXT %></td>
			                  <td class="td01" width="100">가입보험사</td>
                              <td class="td09"><%= appendData.BANK_TEXT %></td>
			                </tr>
			                <tr>
			                  <td width="100" class="td01">가입년월</td>
			                  <td class="td09"><%= WebUtil.printDate( e11PersonalData.CMPY_FROM ).substring(0,7) %></td>
			                  <td class="td01">가입기간</td>
			                  <td class="td09"><%= Integer.toString( Integer.parseInt( e11PersonalData.ENTR_TERM ) ) %></td>
			                </tr>
			                <tr>
			                  <td class="td01">만기연월</td>
			                  <td class="td09"><%= WebUtil.printDate( e11PersonalData.CMPY_TOXX ).substring(0,7) %></td>
			               
			                  <td class="td01">잔여월수</td>
			                  <td class="td09"><%= appendData.LAST_MNTH %></td>
			                 </tr>
                            <tr>
			                  <td width="100" class="td01">월납입액</td>
			                  <td class="td09"><%= WebUtil.printNumFormat( e11PersonalData.MNTH_AMNT ) %></td>
			                  <td class="td01">불입누계</td>
			                  <td class="td09"><%= WebUtil.printNumFormat( appendData.SUMM_AMNT ) %></td>
			                </tr>
			              </table>
			            <!-- 상단 입력 테이블 끝-->
			            </td>
			          </tr>
			          <tr> 
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                          담당자 정보</td>
                      </tr>
                      <tr> 
                        <td> 
                          <!--담당자정보 테이블 시작-->
                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td class="td01" width="100">해약 일자<font color="#006699"><b></b></font></td>
                              <td class="td09">
                               <% if (approvalStep == DocumentInfo.DUTY_CHARGER) {%>
                                <!-- 날짜검색-->
                                <input type="text" name="CLOSE_DATE" size="10" maxlength="10" class="input03" onBlur="dateFormat(this);">
                                <a href="javascript:fn_openCal('CLOSE_DATE')">
                                   <img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="날짜검색">
                                </a>
                              <!-- 날짜검색-->
                              <% } else if (approvalStep == DocumentInfo.DUTY_MANGER) {%>
                                <%=WebUtil.printDate(e11PersonalData.CLOSE_DATE)%>
                                <input type="hidden" name="CLOSE_DATE"     value="<%=e11PersonalData.CLOSE_DATE%>">
                              <% } // end if %>
                              
                              </td>
                            </tr>
                          </table>
                          <!--담당자정보 테이블 끝-->
                        </td>
                      </tr>
			        </table>
			      </td>
                </tr>
              </table>
              <!-- 상단 테이블 시작-->
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
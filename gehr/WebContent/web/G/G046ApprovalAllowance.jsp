<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 가족수당 결재                                               */
/*   Program ID   : G046ApprovalAllowance.jsp                                   */
/*   Description  : 가족수당 결재                                               */
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
    DocumentInfo docinfo = new DocumentInfo(a12FamilyBuyangData.AINF_SEQN ,user.empNo ,false);
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
    <% if (approvalStep == DocumentInfo.DUTY_CHARGER) { %>
        if(frm.APPL_DATE.value == "") {
            alert("적용 일자를 입력하세요");
            return;
        } // end if
    <% } // end if %>

        if(!confirm("결재 하시겠습니까.")) {
            return;
        } // end if
        
	<% if (approvalStep == DocumentInfo.DUTY_CHARGER) { %>
       frm.APPL_DATE.value = removePoint(frm.APPL_DATE.value);
    <% } // end if %>

        frm.APPR_STAT.value = "A";
        frm.submit();
    }
   
    function reject()
    {
        if(!confirm("반려 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
    <% if (approvalStep == DocumentInfo.DUTY_CHARGER) { %>
       frm.APPL_DATE.value = "";
    <% } // end if %>
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

<input type="hidden" name="PERNR"    value="<%=a12FamilyBuyangData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=a12FamilyBuyangData.BEGDA%>">
<input type="hidden" name="AINF_SEQN"    value="<%=a12FamilyBuyangData.AINF_SEQN%>">
<input type="hidden" name="GUBUN"        value="<%=a12FamilyBuyangData.GUBUN%>">
<input type="hidden" name="SUBTY"        value="<%=a12FamilyBuyangData.SUBTY%>">
<input type="hidden" name="OBJPS"        value="<%=a12FamilyBuyangData.OBJPS%>">
<input type="hidden" name="FNMHG"        value="<%=a12FamilyBuyangData.FNMHG%>">
<input type="hidden" name="LNMHG"        value="<%=a12FamilyBuyangData.LNMHG%>">
<input type="hidden" name="REGNO"        value="<%=a12FamilyBuyangData.REGNO%>">
<input type="hidden" name="FAJOB"        value="<%=a12FamilyBuyangData.FAJOB%>">
<input type="hidden" name="DPTID"        value="<%=a12FamilyBuyangData.DPTID%>">
<input type="hidden" name="LIVID"        value="<%=a12FamilyBuyangData.LIVID%>">
<input type="hidden" name="HNDID"        value="<%=a12FamilyBuyangData.HNDID%>">
<input type="hidden" name="CHDID"        value="<%=a12FamilyBuyangData.CHDID%>">
<input type="hidden" name="HELID"        value="<%=a12FamilyBuyangData.HELID%>">
<input type="hidden" name="FAMID"        value="<%=a12FamilyBuyangData.FAMID%>">
<input type="hidden" name="DPTYP"        value="<%=a12FamilyBuyangData.DPTYP%>">
<input type="hidden" name="ZPERNR"       value="<%=a12FamilyBuyangData.ZPERNR%>">
<input type="hidden" name="ZUNAME"       value="<%=a12FamilyBuyangData.ZUNAME%>">
<input type="hidden" name="AEDTM"        value="<%=a12FamilyBuyangData.AEDTM%>">
<input type="hidden" name="UNAME"       value="<%=a12FamilyBuyangData.UNAME%>">

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
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 가족수당 결재해야 할 문서 
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
			                  <td width="100" class="td01">가족수당적용일자</td>
			                  <td class="td09">
			                  <% if (approvalStep == DocumentInfo.DUTY_CHARGER) { %>
                                <input type="text" name="APPL_DATE" size="10" maxlength="10" class="input03" onBlur="dateFormat(this);">
                                <a href="javascript:fn_openCal('APPL_DATE')"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" alt="날짜검색" border="0"></a>
                              <% } else if (approvalStep == DocumentInfo.DUTY_MANGER) { %>
                                <%=WebUtil.printDate(a12FamilyBuyangData.APPL_DATE)%>
                                <input type="hidden" name="APPL_DATE" value="<%=a12FamilyBuyangData.APPL_DATE%>">
                              <% } // end if %>
			                    
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

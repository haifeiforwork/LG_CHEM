<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 급여계좌 결재 완료                                          */
/*   Program ID   : G023ApprovalFinishBank.jsp                                  */
/*   Description  : 급여계좌 결재 완료                                          */
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
<%@ page import="hris.A.A14Bank.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

    A14BankStockFeeData  a14BankStockFeeData  = (A14BankStockFeeData)request.getAttribute("a14BankStockFeeData");

    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(a14BankStockFeeData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

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

<input type="hidden" name="AINF_SEQN"    value="<%=a14BankStockFeeData.AINF_SEQN%>">
<input type="hidden" name="PERNR"        value="<%=a14BankStockFeeData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=a14BankStockFeeData.BEGDA%>">

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
                  <td class="subtitle"><h2>급여계좌 결재완료 문서</h2></td>
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
	          	<div class="buttonArea">
	           		<ul class="btn_crud">
	                   <% if (isCanGoList) {  %>
	           			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
	                   <% } // end if %>
	           		</ul>
	           	</div>
          	</td>
          </tr>
          <tr>
            <td>
              <!-- 상단 입력 테이블 시작-->
					<div class="tableArea">
		              <table class="tableGeneral">
		                <tr>
		                  <th width="100">신청일자</th>
		                  <td colspan="3"><%= WebUtil.printDate(a14BankStockFeeData.BEGDA) %></td>
		                </tr>
		                <tr>
		                  <th>은행코드</th>
		                  <td width="260"><%= a14BankStockFeeData.BANK_NAME %></td>
		                  <th class="th02" width="100">계좌번호</th>
		                  <td><%= a14BankStockFeeData.BANKN %></td>
		                </tr>
		              </table>
					</div>
              <!-- 상단 입력 테이블 끝-->
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
            <td><h2 stile="subtitle">적요</h2></td>
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
                  <td><h2 class="subtitle">결재정보</h2></td>
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
	              	<div class="buttonArea">
	               		<ul class="btn_crud">
	                       <% if (isCanGoList) {  %>
	               			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
	                       <% } // end if %>
	               		</ul>
	               	</div>
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
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

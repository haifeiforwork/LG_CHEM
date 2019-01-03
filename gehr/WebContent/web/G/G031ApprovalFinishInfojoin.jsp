<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 동호회 가입 결재 완료                                       */
/*   Program ID   : G031ApprovalFinishInfojoin.jsp                                       */
/*   Description  : 동호회 가입 결재 완료                                       */
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
<%@ page import="hris.E.E25Infojoin.E25InfoJoinData" %>
<%@ page import="hris.E.E25Infojoin.E25InfoSettData" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

    E25InfoJoinData   e25InfoJoinData  = (E25InfoJoinData)request.getAttribute("e25InfoJoinData");

    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e25InfoJoinData.AINF_SEQN ,user.empNo);
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
                  <td class="subhead"><h2>동호회 신청 가입 결재완료 문서</h2></td>
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
              <table width="780" border="0" cellspacing="1" cellpadding="5">
                <tr>
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  	<tr>
	                  	<div class="buttonArea">
	                  		<ul class="btn_crud">
	                          <% if (isCanGoList) {  %>
	                  			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
	                          <% } // end if %>
	                  		</ul>
	                  	</div>
                  	</tr>
                      <tr>
                        <td><h2 class="subtitle">신청정보</h2></td>
                      </tr>
                      <tr>
                        <td>
                          <!--신청정보 테이블 시작-->
                          <div class="tableArea">
	                          <table class="tableGeneral">
	                            <tr>
	                              <th width="100">동호회</th>
	                              <td width="260"><%=e25InfoJoinData.STEXT%></td>
	                              <th class="th02" width="100">신청일</th>
	                              <td><%=WebUtil.printDate(e25InfoJoinData.BEGDA)%></td>
	                            </tr>
	                            <tr>
	                              <th>간사성명</th>
	                              <td><%=e25InfoJoinData.ENAME%></td>
	                              <th class="th02">신청자사번</td>
	                              <td><%=e25InfoJoinData.PERNR%></td>
	                            </tr>
	                          </table>
                          </div>
                          <!--신청정보 테이블 끝-->
                        </td>
                      </tr>
                      <tr>
                        <td><h2 class="subtitle">간사입력</h2></td>
                      </tr>
                      <tr>
                        <td>
                          <!--간사입력 테이블 시작-->
                          <div class="tableArea">
	                          <table class="tableGeneral">
	                            <tr>
	                              <th width="100">가입일&nbsp;<font color="#006699">*</font></th>
	                              <td width="260"> <%=WebUtil.printDate(e25InfoJoinData.APPL_DATE)%></td>
	                              <th width="100">회비 <font color="#006699">*</font></th>
	                              <td> <%=WebUtil.printNumFormat(e25InfoJoinData.BETRG)%> <%=e25InfoJoinData.WAERS%></td>
	                            </tr>
	                          </table>
	                          <span class="inlineComment">※ 회비는 가입월부터 급여공제됩니다.</span>
                          </div>
                          <!--간사입력 테이블 끝-->
                        </td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
            </td>
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
            <td><h2 class="subtitle">적요</h2></td>
          </tr>
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1">
                <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
                    <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
                    <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr>
                    	<td>
                    		<div class="tableArea">
                    			<table class="tableGeneral">
                    				<tr>
                    					<th width="100"><%=ald.APPL_ENAME%></th>
                    					<td><%=ald.APPL_BIGO_TEXT%></td>
                    				</tr>
                    			</table>
                    		</div>
                    	</td>
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
                      <table width="780" border="0" cellpadding="0" cellspacing="0">
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

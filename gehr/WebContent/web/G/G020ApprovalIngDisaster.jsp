<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 진행 중 문서                                           */
/*   Program Name : 재해 결재 진행중/취소                                       */
/*   Program ID   : G020ApprovalIngDisaster.jsp                                 */
/*   Description  : 재해 결재 진행중/취소                                       */
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
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

    function open_report()
    {
	    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19ReportDetailSV";
	    document.form1.method = "post";
	    document.form1.submit();
    }

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
<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="AINF_SEQN"    value="<%=e19CongcondData.AINF_SEQN%>">
<input type="hidden" name="BANKN"        value="<%=e19CongcondData.BANKN%>">
<input type="hidden" name="BANK_NAME"    value="<%=e19CongcondData.BANK_NAME%>">
<input type="hidden" name="CONG_CODE"    value="<%=e19CongcondData.CONG_CODE%>">
<input type="hidden" name="CONG_DATE"    value="<%=e19CongcondData.CONG_DATE%>">
<input type="hidden" name="CONG_RATE"    value="<%=e19CongcondData.CONG_RATE%>">
<input type="hidden" name="CONG_WONX"    value="<%=e19CongcondData.CONG_WONX%>">
<input type="hidden" name="EREL_NAME"    value="<%=e19CongcondData.EREL_NAME%>">
<input type="hidden" name="HOLI_CONT"    value="<%=e19CongcondData.HOLI_CONT%>">
<input type="hidden" name="PROV_DATE"    value="<%=e19CongcondData.PROV_DATE%>">
<input type="hidden" name="RELA_CODE"    value="<%=e19CongcondData.RELA_CODE%>">
<input type="hidden" name="RTRO_MNTH"    value="<%=e19CongcondData.RTRO_MNTH%>">
<input type="hidden" name="RTRO_WONX"    value="<%=e19CongcondData.RTRO_WONX%>">
<input type="hidden" name="WAGE_WONX"    value="<%=e19CongcondData.WAGE_WONX%>">
<input type="hidden" name="WORK_MNTH"    value="<%=e19CongcondData.WORK_MNTH%>">
<input type="hidden" name="WORK_YEAR"    value="<%=e19CongcondData.WORK_YEAR%>">
<input type="hidden" name="PERNR"        value="<%=e19CongcondData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=e19CongcondData.BEGDA%>">
<input type="hidden" name="LIFNR"        value="<%=e19CongcondData.LIFNR%>">
<input type="hidden" name="BANKL"        value="<%=e19CongcondData.BANKL%>">
<input type="hidden" name="PROOF"        value="<%=e19CongcondData.PROOF%>">
<input type="hidden" name="POST_DATE"    value="<%=e19CongcondData.POST_DATE%>">
<input type="hidden" name="BELNR"        value="<%=e19CongcondData.BELNR%>">
<input type="hidden" name="ZPERNR"       value="<%=e19CongcondData.ZPERNR%>">
<input type="hidden" name="ZUNAME"       value="<%=e19CongcondData.ZUNAME%>">
<input type="hidden" name="DISA_RESN"    value="<%=e19CongcondData.DISA_RESN%>">

<INPUT TYPE="HIDDEN" NAME="BIGO_TEXT">
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
                  <td class="subhead"><h2>재해신청 결재해야 할 문서</h2></td>
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
              <table width="780" border="0" cellspacing="1" cellpadding="5">
                <tr>
                  <td class="tr01">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  	<tr>
                  		<td>
		                  	<div class="buttonArea">
		                  		<ul class="btn_crud" id="sc_button">
		                  			<li><a class="darken" href="javascript:cancel()"><span>결재취소</span></a></li>
		                          <% if (isCanGoList) {  %>
		                          	<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
		                  			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
		                          <% } // end if %>
		                  		</ul>
		                  	</div>
                  		</td>
                  	</tr>
                      <tr>
                        <td>
                          <!--신청일 테이블 시작-->
                          <div class="tableArea">
	                          <table class="tableGeneral">
	                            <tr>
	                              <th width="100">신청일</th>
	                              <td width="250"> <%=WebUtil.printDate(e19CongcondData.BEGDA)%></td>
	                              <th class="th02" width="100">경조내역</th>
	                              <td> <input type="text" name="disa_name" value="재해" size="20" readonly>
	                              </td>
	                            </tr>
	                            <tr>
	                              <th>재해발생일자&nbsp;<font color="#006699">*</font></th>
	                              <td colspan="3">
	                              	<%=WebUtil.printDate(e19CongcondData.CONG_DATE)%>&nbsp;
	                                <a class="inlineBtn" href="javascript:open_report();"><span>재해 피해 신고서</span></a>
	                                <font color="#6666FF">&nbsp;<%= vcE19DisasterData.size() %>&nbsp;건</font>
	                              </td>
	                            </tr>
	                          </table>
                          </div>
                          <!--신청일 테이블 끝-->
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <!--통상임금 테이블 시작-->
                          <div class="tableArea">
	                          <table class="tableGeneral">
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
	                              <th width="100">경조금액</th>
	                              <td colspan="3"><%= WebUtil.printNumFormat(Double.parseDouble(e19CongcondData.CONG_WONX)*100) %>원 </td>
	                            </tr>
	                            <tr>
	                              <th>이체은행명</th>
	                              <td width="250"> <%= e19CongcondData.BANK_NAME %></td>
	                              <th class="th02" width="100">은행계좌번호</th>
	                              <td> <%= e19CongcondData.BANKN %></td>
	                            </tr>
	                            <tr>
	                              <th>근속년수</th>
	                              <td colspan="3">
	                                <%=WebUtil.printNum(e19CongcondData.WORK_YEAR) %>년
	                                <%=WebUtil.printNum(e19CongcondData.WORK_MNTH) %>개월
	                              </td>
	                            </tr>
	                            <tr>
	                              <th>증빙확인유무</th>
	                              <td colspan="3">
	                                <input type="checkbox" <%=e19CongcondData.PROOF.equals("X") ? "checked" : ""%>>
	                              </td>
	                            </tr>
	                          </table>
	                          <font color="#006699"><b>*</b> 는 필수 입력사항입니다.</font>
                          </div>
                        </td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
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
                <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
                    <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
                    <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr>
                       <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                       <td width="700" class="td09"><%=ald.APPL_BIGO_TEXT%></td>
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
	                  		<ul class="btn_crud" id="sc_button">
	                  			<li><a class="darken" href="javascript:cancel()"><span>결재취소</span></a></li>
	                          <% if (isCanGoList) {  %>
	                          	<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
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

  <input type="hidden" name="RowCount_report" value="<%=vcE19DisasterData.size()%>">
  <input type="hidden" name="retPage" value="<%=WebUtil.ServletURL%>hris.G.G020ApprovalDisasterSV">
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

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 진행 중 문서                                           */
/*   Program Name : 장학금/학자금 결재 진행중/취소                              */
/*   Program ID   : G016ApprovalIngExpense.jsp                                  */
/*   Description  : 장학금/학자금 결재 진행중/취소                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*				        2014-10-24  @v.1.2 SJY 신청유형:장학금인 경우에만 시스템 수정 	[CSR ID:2634836] 학자금 신청 시스템 개발 요청	*/
/* 					2018-01-11  cykim  [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E21Expense.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    E21ExpenseData e21ExpenseData        = (E21ExpenseData)request.getAttribute("e21ExpenseData");

    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");

    //  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize  = 2;
    double currencyDecimalSize1 = 2;
    int    currencyValue  = 0;
    int    currencyValue1 = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e21ExpenseData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }

        if( e21ExpenseData.WAERS1.equals(codeEnt.code) ){
            currencyDecimalSize1 = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue  = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
    currencyValue1 = (int)currencyDecimalSize1; //???  KRW -> 0, USDN -> 5
    //  통화키에 따른 소수자리수를 가져온다


    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e21ExpenseData.AINF_SEQN ,user.empNo);
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

//신청유형:장학금인 경우에만 시스템 수정 START
function init(){
<%
    if(e21ExpenseData.SUBF_TYPE.equals("3")){
%>
			document.getElementById("TYPE_3").style.display="block";
	        document.getElementById("TYPE_3_1").style.display="block";
	        /* [CSR ID:3569058] 신청유형:장학금인 경우에만 학과필드 display */
			$("#FRTXT").show();
<%
    }
%>
}
//신청유형:장학금인 경우에만 시스템 수정 END

//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');javascript:init();">
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="AINF_SEQN"    value="<%=e21ExpenseData.AINF_SEQN%>">
<input type="hidden" name="PERNR"        value="<%=e21ExpenseData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=e21ExpenseData.BEGDA%>">
<input type="hidden" name="FAMSA"        value="<%=e21ExpenseData.FAMSA%>">
<input type="hidden" name="ATEXT"        value="<%=e21ExpenseData.ATEXT%>">
<input type="hidden" name="SUBF_TYPE"    value="<%=e21ExpenseData.SUBF_TYPE%>">
<input type="hidden" name="PAY1_TYPE"    value="<%=e21ExpenseData.PAY1_TYPE%>">
<input type="hidden" name="PAY2_TYPE"    value="<%=e21ExpenseData.PAY2_TYPE%>">
<input type="hidden" name="PERD_TYPE"    value="<%=e21ExpenseData.PERD_TYPE%>">
<input type="hidden" name="HALF_TYPE"    value="<%=e21ExpenseData.HALF_TYPE%>">
<input type="hidden" name="PROP_YEAR"    value="<%=e21ExpenseData.PROP_YEAR%>">
<input type="hidden" name="LNMHG"        value="<%=e21ExpenseData.LNMHG%>">
<input type="hidden" name="FNMHG"        value="<%=e21ExpenseData.FNMHG%>">
<input type="hidden" name="ACAD_CARE"    value="<%=e21ExpenseData.ACAD_CARE%>">
<input type="hidden" name="STEXT"        value="<%=e21ExpenseData.STEXT%>">
<input type="hidden" name="FASIN"        value="<%=e21ExpenseData.FASIN%>">
<input type="hidden" name="ACAD_YEAR"    value="<%=e21ExpenseData.ACAD_YEAR%>">
<input type="hidden" name="PROP_AMNT"    value="<%=e21ExpenseData.PROP_AMNT%>">
<input type="hidden" name="WAERS"        value="<%=e21ExpenseData.WAERS%>">
<input type="hidden" name="ENTR_FIAG"    value="<%=e21ExpenseData.ENTR_FIAG%>">
<input type="hidden" name="BIGO_TEXT1"   value="<%=e21ExpenseData.BIGO_TEXT1%>">
<input type="hidden" name="BIGO_TEXT2"   value="<%=e21ExpenseData.BIGO_TEXT2%>">
<input type="hidden" name="OBJC_CODE"    value="<%=e21ExpenseData.OBJC_CODE%>">
<input type="hidden" name="P_COUNT"      value="<%=e21ExpenseData.P_COUNT%>">
<input type="hidden" name="GESC2"        value="<%=e21ExpenseData.GESC2%>">
<input type="hidden" name="KDSVH"        value="<%=e21ExpenseData.KDSVH%>">
<input type="hidden" name="REGNO"        value="<%=e21ExpenseData.REGNO%>">
<input type="hidden" name="POST_DATE"    value="<%=e21ExpenseData.POST_DATE%>">
<input type="hidden" name="BELNR"        value="<%=e21ExpenseData.BELNR%>">
<input type="hidden" name="ZPERNR"       value="<%=e21ExpenseData.ZPERNR%>">
<input type="hidden" name="ZUNAME"       value="<%=e21ExpenseData.ZUNAME%>">
<input type="hidden" name="AEDTM"        value="<%=e21ExpenseData.AEDTM%>">
<input type="hidden" name="UNAME"       value="<%=e21ExpenseData.UNAME%>">

<!-- 신청유형:장학금인 경우에만 시스템 수정 START  -->
<input type="hidden" name="SCHCODE"       value="<%=e21ExpenseData.SCHCODE%>">
<input type="hidden" name="ABRSCHOOL"       value="<%=e21ExpenseData.ABRSCHOOL%>">
<!-- 신청유형:장학금인 경우에만 시스템 수정 END -->

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
                  <td class="subhead"><h2>장학자금 결재진행 중 문서</h2></td>
                </tr>
              </table>
              </td>
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
                  <td class="tr01">
                  	<div class="buttonArea">
                  		<ul class="btn_crud">
                  		<% if (docinfo.isHasCancel()) {  %>
                  			<li><a href="javascript:approval()"><span>결재취소</span></a></li>
                  			<% } // end if %>
                          <% if (isCanGoList) {  %>
                          	<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
                  			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
                          <% } // end if %>
                  		</ul>
                  	</div>
                  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><h2 class="subtitle">신청정보</h2></td>
                      </tr>
                      <tr>
                        <td>
                          <!--신청정보 테이블 시작-->
                          <div class="tableArea">
                          <table class="tableGeneral" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <th width="100">신청일</th>
                              <td width="240"><%=WebUtil.printDate(e21ExpenseData.BEGDA)%></td>
                              <th width="100" class="th02">가족선택</th>
                              <td> <%= e21ExpenseData.ATEXT %></td>
                            </tr>
                            <tr>
                              <th>신청유형<font color="#0000FF"><font color="#006699">* </font></font></td>
                              <td> <%= e21ExpenseData.SUBF_TYPE.equals("2") ? "학자금" : "장학금" %></td>
                              <th class="th02">신청년도<font color="#006699">*<b> </b></font></th>
                              <td> <%= e21ExpenseData.PROP_YEAR %></td>
                            </tr>
                            <tr>
                              <th>신청구분 <font color="#006699">*</font></th>
                              <td>
                                <% if (e21ExpenseData.PAY1_TYPE.equals("X")) {%>
                                    신규분
                                <% } else if (e21ExpenseData.PAY2_TYPE.equals("X")) {%>
                                    추가분
                                <% } else { %>
                                    &nbsp;
                                <% } // end if %>
                              </td>
                              <th class="th02">신청분기.학기 <font color="#006699">*</font></th>
                              <td>
							  <% if (e21ExpenseData.SUBF_TYPE.equals("2")) { %>
	                              <%=e21ExpenseData.PERD_TYPE + "분기"%>
	                          <% } else { %>
	                              <%=e21ExpenseData.HALF_TYPE + "학기"%>
	                          <% } // end if %>
                              </td>
                            </tr>
                            <tr>
                              <th>이름 <font color="#006699">*</font></th>
                              <td><%=e21ExpenseData.LNMHG.trim()%><%=e21ExpenseData.FNMHG.trim()%></td>
                              <th class="th02">주민등록번호</th>
                              <td>
<%        String REGNO_dis = e21ExpenseData.REGNO.substring(0, 6) + "-*******";
%>
                              <%=REGNO_dis%>
                              </td>
                            </tr>
                            <tr>
                              <th>교육기관</th>
                              <td> <%= e21ExpenseData.FASIN %> </td>
                              <th class="th02">학력 <font color="#006699">*</font></th>
                              <td> <%= e21ExpenseData.STEXT %></td>
                            </tr>
                            <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 start -->
							<tr id="FRTXT" style="display:none;">
								<th>학과</th>
			                    <td colspan="3">
									<%= e21ExpenseData.FRTXT %>
				               	</td>
			                </tr>
							<!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 end -->
                            <tr>
                              <th>신청액 <font color="#006699">*</font></th>
                              <td> <%= WebUtil.printNumFormat(e21ExpenseData.PROP_AMNT,currencyValue) %> <%= e21ExpenseData.WAERS %></td>
                              <th class="th02">수혜횟수</th>
                              <td><%= WebUtil.printNumFormat(e21ExpenseData.P_COUNT) %>회</td>
                            </tr>
                            <tr>
                              <th>입학금</th>
                              <td><input type="checkbox" <%= e21ExpenseData.ENTR_FIAG.equals("X") ? "checked" : "" %> disabled></td>

                              <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
		                        <th class="th02" id="TYPE_3" style="display:none;">유학 학자금</th>
			                    <td id="TYPE_3_1" style="display:none;">
									<input type="checkbox" <%= e21ExpenseData.ABRSCHOOL.equals("X") ? "checked" : "" %> disabled>
								</td>
								<!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                            </tr>
                          </table>
                          </div>
                          <!--신청정보 테이블 끝-->
                        </td>
                      </tr>
                      <tr>
                        <td><h2 class="subtitle">담당자 정보</h2></td>
                      </tr>
                       <tr>
                        <td>
                          <!--담당자정보 테이블 시작-->
                          <div class="tableArea">
	                          <table class="tableGeneral" border="0" cellpadding="0" cellspacing="0">
	                            <tr>
	                              <th width="100">지급액</th>
	                              <td width="240"> <%= WebUtil.printNumFormat(e21ExpenseData.PAID_AMNT,currencyValue1) %> <%=e21ExpenseData.WAERS1%></td>
	                              <th width="100" class="th02">연말정산반영액</th>
	                              <td><%= WebUtil.printNumFormat(e21ExpenseData.YTAX_WONX) %></td>
	                            </tr>
	                            <tr>
	                              <th>증빙제출일<font color="#006699"><b></b></font></th>
	                              <td colspan="3"><%=WebUtil.printDate(e21ExpenseData.PAID_DATE)%></td>
	                            </tr>
	                          </table>
                          </div>
                          <!--담당자정보 테이블 끝-->
                        </td>
                      </tr>
                        <input type="hidden" name="PAID_AMNT"    value="<%=e21ExpenseData.PAID_AMNT%>">
                        <input type="hidden" name="WAERS1"       value="<%=e21ExpenseData.WAERS1%>">
                        <input type="hidden" name="YTAX_WONX"    value="<%=e21ExpenseData.YTAX_WONX%>">
                        <input type="hidden" name="PAID_DATE"    value="<%=e21ExpenseData.PAID_DATE%>">
                    </table>
                   </td>
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
            <td>
            <table width="780" border="0" cellspacing="0" cellpadding="0">

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
                  <td>
                  <!--버튼 들어가는 테이블 시작 -->
                  	<div class="buttonArea">
                  		<ul class="btn_crud">
                  		<% if (docinfo.isHasCancel()) {  %>
                  			<li><a href="javascript:approval()"><span>결재취소</span></a></li>
                  			<% } // end if %>
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
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

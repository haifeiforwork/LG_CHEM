<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 장학금/학자금 결재 완료                                     */
/*   Program ID   : G017ApprovalFinishExpense.jsp                               */
/*   Description  : 장학금/학자금 결재 완료                                     */
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
        frm.jobid.value ="";
    <% if (isCanGoList) { %>
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
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="APPR_STAT">
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
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
                  <td class="subhead"><h2>장학자금 결재완료 문서</h2></td>
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
                  <td class="tr01">
                  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                              <th>신청유형<font color="#0000FF"><font color="#006699">* </font></font></th>
                              <td> <%= e21ExpenseData.SUBF_TYPE.equals("2") ? "학자금" : "장학금" %></td>
                              <th class="th02">신청년도<font color="#006699">*<b> </b></font></td>
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
	                              <th class="th02" width="100">연말정산반영액</th>
	                              <td><%= WebUtil.printNumFormat(e21ExpenseData.YTAX_WONX) %></td>
	                            </tr>
	                            <tr>
	                              <th >증빙제출일</th>
	                              <td><%=WebUtil.printDate(e21ExpenseData.PAID_DATE)%></td>
	                              <th class="th02">회계전표번호</th>
	                              <td><%=e21ExpenseData.BELNR%></td>
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
                  <td><h2 class="subtitle">결재정보</td>
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
                  <!--버튼끝-->
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

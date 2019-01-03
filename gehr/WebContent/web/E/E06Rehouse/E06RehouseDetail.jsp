<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 상환신청                                           */
/*   Program Name : 주택자금 상환신청 조회                                      */
/*   Program ID   : E06ReHouseDetail.jsp                                        */
/*   Description  : 주택자금 상환신청을 조회할 수 있도록 하는 화면              */
/*   Note         :                                                             */
/*   Creation     : 2001-12-26  이형석                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E06Rehouse.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector e06RehouseData_vt  = (Vector)request.getAttribute("e06RehouseData_vt");
    E06RehouseData e06RehouseData = (E06RehouseData)e06RehouseData_vt.get(0);

    String REMAIN_AMNT  = Double.toString(Double.parseDouble(e06RehouseData.DARBT)-Double.parseDouble(e06RehouseData.ALREADY_AMNT));
    String RequestPageName = (String)request.getAttribute("RequestPageName");

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e06RehouseData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ui_library_approval" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function go_delete() {
  if( chk_APPR_STAT(1) && confirm("정말 삭제하시겠습니까?") ) {
        document.form1.jobid.value ="delete";
        document.form1.action      ="<%= WebUtil.ServletURL %>hris.E.E06Rehouse.E06RehouseDetailSV";
        document.form1.submit();
    }
}

function do_list(){
    document.form1.action = "<%=RequestPageName.replace('|','&')%>";
    document.form1.submit();
}
//-->
</SCRIPT>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>주택자금 상환신청 조회</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

    <div class="buttonArea">
        <ul class="btn_crud">
<%  if (docinfo.isModefy()) { %>
            <li><a href="javascript:go_delete();"><span>삭제</span></a></li>
<%  } // end if %>
<%  if ( RequestPageName != null && !RequestPageName.equals("")) { %>
            <li><img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif" /></li>
            <li><a href="javascript:do_list();"><span>목록보기</span></a></li>
<%  } // end if %>
        </ul>
    </div>

    <!-- 상단 입력 테이블 시작-->
    <!--신청정보 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral tableApproval">
                <tr>
                    <th>신청일</th>
                    <td><input type="text" name="BEGDA_read" size="14" value='<%= WebUtil.printDate(e06RehouseData.BEGDA) %>' readonly></td>
                    <th class="th02">주택융자유형</th>
                    <td>
                        <select name="DLART" disabled>
                            <option value="">------------</option>
<%
//  2003.02.12 - 주택자금(기타)일경우 신청을 ESS상에서는 받지 않고 조회만 보여주므로 따로 처리한다.
    if( e06RehouseData.DLART.equals("0070") ) {
%>
                            <option value="0070" selected>주택자금(기타)</option>
<%
    } else {
%>
                                  <%= WebUtil.printOption((new E05LoanCodeRFC()).getLoanType(),e06RehouseData.DLART) %>
<%
    }
%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>상환원금</th>
                    <td><input type="text" name="RPAY_AMNT" size="20" value='<%=WebUtil.printNumFormat(Double.parseDouble(e06RehouseData.RPAY_AMNT)*100) %>' style="text-align:right" readonly>원</td>
                    <th class="th02">주택자금이자</th>
                    <td><input type="text" name="INTR_AMNT" size="20" value='<%=WebUtil.printNumFormat(Double.parseDouble(e06RehouseData.INTR_AMNT)*100) %>' style="text-align:right" readonly>원</td>
                </tr>
                <tr>
                    <th><font color="#cc3300">총상환금액</font></th>
                    <td>
<%
//  2003.02.12 - 주택자금(기타)일경우 상환원금을 총상환원금으로 보여준다.
    if( e06RehouseData.DLART.equals("0070") ) {
%>
                        <input type="text" name="TOTAL_AMNT" size="20" value='<%=WebUtil.printNumFormat(Double.parseDouble(e06RehouseData.RPAY_AMNT)*100) %>' style="text-align:right;color:#006699" readonly>
<%
    } else {
%>
                        <input type="text" name="TOTAL_AMNT" size="20" value='<%=WebUtil.printNumFormat(Double.parseDouble(e06RehouseData.TOTL_AMNT)*100) %>' style="text-align:right;color:#006699" readonly>
<%
    }
%>
                    원</td>
                    <th class="th02">상환액 입금일자</th>
                    <td><input type="text" name="REPT_DATE" size="14" value='<%= WebUtil.printDate(e06RehouseData.REPT_DATE) %>' readonly></td>
                </tr>
                <tr>
                    <th>대출금액</th>
                    <td><input type="text" name="DARBT" size="20" value='<%=WebUtil.printNumFormat(Double.parseDouble(e06RehouseData.DARBT)*100) %>' style="text-align:right" readonly>원</td>
                    <th class="th02">대출일자</th>
                    <td><input type="text" name="DATBW" size="14" value='<%= WebUtil.printDate(e06RehouseData.DATBW) %>' readonly></td>
                </tr>
                <tr>
                    <th>기상환액</th>
                    <td><input type="text" name="ALREADY_AMNT" size="20" value='<%=WebUtil.printNumFormat(Double.parseDouble(e06RehouseData.ALREADY_AMNT)*100) %>' style="text-align:right" readonly>원</td>
                    <th class="th02">대출잔액</th>
                    <td><input type="text" name="REMAIN_AMNT" size="20" value='<%= WebUtil.printNumFormat(Double.parseDouble(REMAIN_AMNT)*100)%>' style="text-align:right" readonly>원</td>
                </tr>
                <tr>
                    <th>보증여부</th>
                    <td colspan="3">
<%
    if( e06RehouseData.ZZSECU_FLAG.equals("Y") ) {
%>
                        <input type="text" name="ZZSECU_FLAG" size="20" value="연대보증인 입보" readonly>
<%
    } else if( e06RehouseData.ZZSECU_FLAG.equals("N") ) {
%>
                        <input type="text" name="ZZSECU_FLAG" size="20" value="보증보험가입희망" readonly>
<%
    } else {
%>
                        <input type="text" name="ZZSECU_FLAG" size="20" value="" readonly>
<%
    }
%>
                    </td>
                </tr>
            </table>
        </div>
        <div class="commentsMoreThan2">
            <div>주택자금을 입금할 경우 본인임을 확인할 수 있도록 무통장 입금증에 본인의 실명을 입력하여 주십시오.</div>
<%
    if( user.companyCode.equals("C100") ) {         // LG화학
%>
            <div>매월 21일부터 말일까지는 주택자금을 상환할 수 없습니다.</div>
<%
    }
%>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <h2 class="subtitle">결재정보</h2>

    <%= hris.common.util.AppUtil.getAppDetail(e06RehouseData.AINF_SEQN) %>

    <div class="buttonArea">
        <ul class="btn_crud">
<%  if (docinfo.isModefy()) { %>
            <li><a href="javascript:go_delete();"><span>삭제</span></a></li>
<%  } // end if %>
<%  if ( RequestPageName != null && !RequestPageName.equals("")) { %>
            <li><img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif" /></li>
            <li><a href="javascript:do_list();"><span>목록보기</span></a></li>
<%  } // end if %>
        </ul>
    </div>

<!-----   hidden field ---------->
    <INPUT TYPE="hidden" name="BeforeJspName" value="">
    <input type="hidden" name="jobid"         value="">
    <input type="hidden" name="BEGDA"         value="<%= e06RehouseData.BEGDA %>">
    <input type="hidden" name="AINF_SEQN"     value="<%= e06RehouseData.AINF_SEQN %>">
    <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
  </div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

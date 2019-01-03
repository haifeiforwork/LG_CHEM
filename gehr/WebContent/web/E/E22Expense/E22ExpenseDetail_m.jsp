<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 장학자금/입학축하금지원내역                                 */
/*   Program Name : 장학자금/입학축하금지원내역                                 */
/*   Program ID   : E22ExpenseDetail_m.jsp                                      */
/*   Description  : 입학축하금/학자금/장학금 상세조회                           */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  최영호                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                        2014-10-24  @v.1.2 SJY 신청유형:장학금인 경우에만 시스템 수정  [CSR ID:2634836] 학자금 신청 시스템 개발 요청   */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.E.E22Expense.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    E22ExpenseListData data   = new E22ExpenseListData();

    Box box = WebUtil.getBox(request);
    box.copyToEntity(data);
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
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E22Expense.E22ExpenseListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

//신청유형:장학금인 경우에만 시스템 수정 START
function init(){
<%
        //신청유형:장학금인 경우에만 시스템 수정
    if(data.SUBF_TYPE.equals("3")){
%>
            document.getElementById("TYPE_3").style.display="block";
            document.getElementById("TYPE_3_1").style.display="block";
<%
            if(!WebUtil.nvl(data.ABRSCHOOL).equals("X")){
%>
                document.getElementsByName("SCHCODE")[0].style.display="inline-block";
<%
            }
%>
<%
    }
%>
}
//신청유형:장학금인 경우에만 시스템 수정 END
-->
</script>
</head>
<!--[CSR ID:2389767] [정보보안] e-HR MSS시스템 수정-->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  oncontextmenu="return true" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()" onLoad="javascript:init();">
<form name="form1" method="post">
<div class="subWrapper">

<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th><!--신청일--><%=g.getMessage("LABEL.E.E22.0014")%></th>
                    <td colspan="3"><input type="text" name="day" value="<%= data.PAID_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.PAID_DATE) %>" size="18" readonly></td>
                </tr>
                <tr>
                    <th><!--가족선택--><%=g.getMessage("LABEL.E.E22.0021")%></th>
                    <td colspan="3">
                        <input type="text" name="FAMSA" size="5" value="<%= data.FAMSA %>" readonly>
                        <input type="text" name="ATEXT" size="10" value="<%= data.ATEXT %>" readonly>
                    </td>
                </tr>
                <tr>
                    <th><!--지급유형--><%=g.getMessage("LABEL.E.E22.0015")%></th>
                    <td><input type="text" name="STEXT" value="<%= data.STEXT %>" size="18" readonly></td>
<%
    if( !data.SUBF_TYPE.equals("1") ) {
%>
                    <th><!--신청년도--><%=g.getMessage("LABEL.E.E22.0024")%></th>
                    <td><input type="text" name="PROP_YEAR" value="<%= data.PROP_YEAR %>" style="text-align:center" size="10" readonly></td>
<%
    } else {
%>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
<%
    }
%>
                </tr>
<%
    if( !data.SUBF_TYPE.equals("1") ) {
%>
                <tr>
                    <th><!--지급구분--><%=g.getMessage("LABEL.E.E22.0016")%></th>
                    <td>
                        <input type="radio" name="PAY1_TYPE" value="X"<%= data.PAY1_TYPE.equals("X") ? "checked" : "" %> disabled>
                        <!--신규분--><%=g.getMessage("LABEL.E.E22.0022")%>
                        <input type="radio" name="PAY2_TYPE" value=""<%= data.PAY2_TYPE.equals("X") ? "checked" : "" %> disabled>
                        <!--추가분--><%=g.getMessage("LABEL.E.E22.0023")%>
                    </td>
                    <th class="th02"><!--신청분기ㆍ학기--><%=g.getMessage("LABEL.E.E22.0025")%></th>
                    <td>
                        <input type="text" name="TYPE" value="<%= data.SUBF_TYPE.equals("2") ? (data.PERD_TYPE.equals("0") ? "" : data.PERD_TYPE + "분기") : (data.HALF_TYPE.equals("0") ? "" : data.HALF_TYPE + "학기") %>" style="text-align:center" size="10" readonly>
                    </td>
                </tr>
<%
    }
%>
                <tr>
                    <th><!--이름--><%=g.getMessage("LABEL.E.E22.0017")%></th>
                    <td colspan="3"><input type="text" name="LNMHG"  value="<%= data.LNMHG %> <%= data.FNMHG %>" size="18" readonly></td>
                </tr>
                <tr>
                    <th><!--학력--><%=g.getMessage("LABEL.E.E22.0026")%></th>
                    <td colspan="3">
                        <input type="text" name="ACAD_CARE" value="<%= data.ACAD_CARE %>" size="5" readonly>
                        <input type="text" name="TEXT4" value="<%= data.TEXT4 %>" size="22" readonly>
                    </td>
                </tr>
                <tr>
                    <th><!--교육기관--><%=g.getMessage("LABEL.E.E22.0027")%></th>
                    <td>
                        <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                        <input type="text" name="SCHCODE" value="<%= WebUtil.nvl(data.SCHCODE).equals("")? "": data.SCHCODE%>" size="9" readonly style="display:none">
                        <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                        <input type="text" name="FASIN" value="<%= data.FASIN %>" size="30" readonly>
                    </td>
<%
    if( data.SUBF_TYPE.equals("1") ) {
%>
                </tr>
                <tr>
                    <th><!--회사지급액--><%=g.getMessage("LABEL.E.E22.0019")%></th>
                    <td>
                        <input type="text" name="PAID_AMNT" value="<%= data.PAID_AMNT.equals("0") ? "" : data.PAID_AMNT %>&nbsp;&nbsp;" size="18" style="text-align:right" readonly>
                        <%= data.PAID_AMNT.equals("0") ? "" : data.WAERS1 %>
                    </td>
                </tr>
<%
    } else {
%>
                    <th class="th02"><!--학년--><%=g.getMessage("LABEL.E.E22.0029")%></th>
                    <td>
                        <input type="text" name="ACAD_YEAR" size="10" value="<%= data.ACAD_YEAR.equals("0") ? "" : data.ACAD_YEAR %>" style="text-align:center" readonly>
                        <!--학년--><%=g.getMessage("LABEL.E.E22.0029")%>
                    </td>
                </tr>
                <tr>
                    <th><!--신청액--><%=g.getMessage("LABEL.E.E22.0018")%></th>
                    <td>
                        <input type="text" name="PROP_AMNT" value="<%= data.PROP_AMNT %>&nbsp;&nbsp;" size="18" style="text-align:right" readonly>
                        <%= data.WAERS %>
                    </td>
                    <th class="th02"><!--수혜횟수--><%=g.getMessage("LABEL.E.E22.0030")%></th>
                    <td>
                        <input type="text" name="P_COUNT" value="<%= data.P_COUNT %>" size="10" style="text-align:center" readonly>
                        <!--회--><%=g.getMessage("LABEL.E.E22.0037")%>
                    </td>
                </tr>
                <tr>
                    <th><!--입학금--><%=g.getMessage("LABEL.E.E22.0028")%></th>
                    <td><input type="checkbox" name="ENTR_FIAG" readonly <%= data.ENTR_FIAG.equals("X") ? "checked" : "" %> disabled></td>
                    <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                    <th class="th02" id="TYPE_3" style="display:none;"><!--유학 학자금--><%=g.getMessage("LABEL.E.E22.0031")%></th>
                    <td id="TYPE_3_1" style="display:none;">
                        <input type="checkbox" name="ABRSCHOOL" value="X" size="20"<%= WebUtil.nvl(data.ABRSCHOOL).equals("X") ? "checked" : "" %> disabled>
                    </td>

                            <!--
                            <td class="td02">&nbsp;</td>
                            <td class="td02">&nbsp;</td>
                             -->
                            <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                </tr>
                <tr>
                    <th><!--회사지급액--><%=g.getMessage("LABEL.E.E22.0019")%></th>
                    <td colspan="3">
                        <input type="text" name="PAID_AMNT" value="<%= data.PAID_AMNT.equals("0") ? "" : data.PAID_AMNT %>&nbsp;&nbsp;" size="18" style="text-align:right" readonly>
                        <%= data.PAID_AMNT.equals("0") ? "" : data.WAERS1 %>
                    </td>
                </tr>
                <tr>
                    <th><!--연말정산반영액--><%=g.getMessage("LABEL.E.E22.0032")%></th>
                    <td colspan="3">
                        <input type="text" name="YTAX_WONX" value="<%= data.YTAX_WONX.equals("0") ? "" : data.YTAX_WONX %>&nbsp;&nbsp;" style="text-align:right" size="18" readonly>
                        <%= data.YTAX_WONX.equals("0") ? "" : "&nbsp;KRW" %>
                    </td>
                </tr>
                <tr>
                    <th><!--반납일자--><%=g.getMessage("LABEL.E.E22.0033")%></th>
                    <td><input type="text" name="RFUN_DATE" value="<%= data.RFUN_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.RFUN_DATE) %>" style="text-align:left" size="18" readonly></td>
                    <th class="th02"><!--반납액--><%=g.getMessage("LABEL.E.E22.0034")%></th>
                    <td>
                        <input type="text" name="RFUN_AMNT" value="<%= data.RFUN_AMNT.equals("0") ? "" : data.RFUN_AMNT %>&nbsp;&nbsp;" size="18" style="text-align:right" readonly>
                        <%= data.RFUN_AMNT.equals("0") ? "" : data.WAERS1 %>
                    </td>
                </tr>
                <tr>
                    <th><!--반납사유--><%=g.getMessage("LABEL.E.E22.0035")%></th>
                    <td colspan="3"><input type="text" name="RFUN_RESN" value="<%= data.RFUN_RESN %>" style="text-align:left" size="70" readonly></td>
                </tr>
<%
    }
%>
                <tr>
                    <th rowspan="2"><!--비고--><%=g.getMessage("LABEL.E.E22.0036")%></th>
                    <td colspan=3><input type="text" name="BIGO_TEXT1" value="<%= data.BIGO_TEXT1 %>" style="text-align:left" size="70" readonly></td>
                </tr>
                <tr>
                    <td colspan=3><input type="text" name="BIGO_TEXT2" value="<%= data.BIGO_TEXT2 %>" style="text-align:left" size="70" readonly></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back();"><span><!-- 목록 --><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
        </ul>
    </div>

  </form>
<%
}
%>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>

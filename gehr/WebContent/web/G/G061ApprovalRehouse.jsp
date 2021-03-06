<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 상환신청 결재                                      */
/*   Program Name : 주택자금 상환신청 결재                                      */
/*   Program ID   : G061ApprovalRehouse.jsp                                     */
/*   Description  : 주택자금 상환신청 결재할 수 있도록 하는 화면                */
/*   Note         :                                                             */
/*   Creation     : 2005-03-11  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E06Rehouse.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    E06RehouseData e06ReHouseData = (E06RehouseData)request.getAttribute("e06RehouseData");
    Vector       vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String       RequestPageName = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if


    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e06ReHouseData.AINF_SEQN ,user.empNo, false);
    int approvalStep = docinfo.getApprovalStep();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

function approval()
{
    var frm = document.form1;

<%  if ( approvalStep == DocumentInfo.DUTY_CHARGER ) { %>

    if ( frm.REPT_DATE.value == ""  ) {
        alert("상환액 입금일자를 입력해 주시기 바랍니다.");
        return;
    }

    if ( frm.BUDAT.value == ""  ) {
        alert("전기일자를 입력해 주시기 바랍니다.");
        return;
    }

    if ( frm.NEWKO.value == ""  ) {
        alert("은행계정을 입력해 주시기 바랍니다.");
        return;
    }

        if ( frm.BELNR.value == ""  ) {
        alert("전표번호를 입력해 주시기 바랍니다.");
        return;
    }

    frm.SLIP_NUMB.value = frm.BELNR.value;
    frm.REPT_DATE.value = changeChar( frm.REPT_DATE.value, ".", "-" );
    frm.BUDAT.value     = changeChar( frm.BUDAT.value, ".", "-" );
<%  } %>

    if(!confirm("결재 하시겠습니까.")) {
        return;
    } // end if

    frm.APPR_STAT.value = "A";
    frm.submit();
}

function reject()
{
    if(!confirm("반려 하시겠습니까.")) {
        return;
    } // end if
    var frm = document.form1;
    frm.SLIP_NUMB.value = frm.BELNR.value;
    frm.REPT_DATE.value = changeChar( frm.REPT_DATE.value, ".", "-" );
    frm.BUDAT.value     = changeChar( frm.BUDAT.value, ".", "-" );
    
    frm.APPR_STAT.value = "R";

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

// 달력 사용
function fn_openCal(Objectname){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    small_window.focus();
}
//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid" value="save">
  <input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
  <input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
  <input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

  <input type="hidden" name="PERNR"        value="<%= e06ReHouseData.PERNR        %>" >
  <input type="hidden" name="BEGDA"        value="<%= e06ReHouseData.BEGDA        %>" >
  <input type="hidden" name="AINF_SEQN"    value="<%= e06ReHouseData.AINF_SEQN    %>" >
  <INPUT TYPE="hidden" name="DLART"        value="<%= e06ReHouseData.DLART        %>" >
  <INPUT TYPE="hidden" name="RPAY_AMNT"    value="<%= e06ReHouseData.RPAY_AMNT    %>" >
  <INPUT TYPE="hidden" name="INTR_AMNT"    value="<%= e06ReHouseData.INTR_AMNT    %>" >
  <INPUT TYPE="hidden" name="TOTL_AMNT"    value="<%= e06ReHouseData.TOTL_AMNT    %>" >
  <INPUT TYPE="hidden" name="DARBT"        value="<%= e06ReHouseData.DARBT        %>" >
  <input type="hidden" name="DATBW"        value="<%= e06ReHouseData.DATBW        %>" >
  <input type="hidden" name="ALREADY_AMNT" value="<%= e06ReHouseData.ALREADY_AMNT %>" >
  <input type="hidden" name="ZZSECU_FLAG"  value="<%= e06ReHouseData.ZZSECU_FLAG  %>" >
  <INPUT TYPE="hidden" name="POST_DATE"    value="<%= e06ReHouseData.POST_DATE    %>" >
  <input type="hidden" name="ZPERNR"       value="<%= e06ReHouseData.ZPERNR       %>" >
  <input type="hidden" name="ZUNAME"       value="<%= e06ReHouseData.ZUNAME       %>" >
  <input type="hidden" name="AEDTM"        value="<%= e06ReHouseData.AEDTM        %>" >
  <INPUT TYPE="hidden" name="UNAME"        value="<%= e06ReHouseData.UNAME        %>" >

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
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">주택자금상환신청
                    결재해야 할 문서 </td>
                  <td align="right" style="padding-bottom:4px"><a href="javascript:open_help('E06Rehouse.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
                  </td>
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
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          신청정보</td>
                      </tr>
                      <tr>
                        <td>
                          <!--신청정보 테이블 시작-->
                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                              <td width="100" class="td01">신청일</td>
                              <td class="td09">
                                <%= e06ReHouseData.BEGDA.equals("0000-00-00")||e06ReHouseData.BEGDA.equals("") ? "" : WebUtil.printDate(e06ReHouseData.BEGDA, ".") %>
                              <td width="100" class="td01">주택융자유형</td>
                              <td class="td09"><%= WebUtil.printOption((new E05LoanCodeRFC()).getLoanType(),e06ReHouseData.DLART) %></td>
                            </tr>
                            <tr>
                              <td class="td01">상환원금</td>
                              <td width="220" class="td09">
                               <%= WebUtil.printNumFormat(Double.parseDouble(e06ReHouseData.RPAY_AMNT)*100) %> 원 </td>
                              <td class="td01">주택자금이자</td>
                              <td class="td09">
                                <%= WebUtil.printNumFormat(Double.parseDouble(e06ReHouseData.INTR_AMNT)*100) %> 원 </td>
                            </tr>
                            <tr>
                              <td class="td01">총상환금액</td>
                              <td width="220" class="td09">
                                <%= WebUtil.printNumFormat(Double.parseDouble(e06ReHouseData.TOTL_AMNT)*100) %> 원 </td>
                              <td class="td01">상환액입금일자</td>
                              <%  if( approvalStep == DocumentInfo.DUTY_CHARGER ) {  %>
                              <td class="td09">
                                <input name="REPT_DATE" type="text" value="<%= e06ReHouseData.REPT_DATE.equals("0000-00-00")||e06ReHouseData.REPT_DATE.equals("") ? "" : WebUtil.printDate(e06ReHouseData.REPT_DATE, ".") %>" size="12" onBlur="dateFormat(this);" class="input03" >
                                <!-- 날짜검색-->
                                <a href="javascript:fn_openCal('REPT_DATE')"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="날짜검색"></a>
                              </td>
                              <%  } else { %>
                              <td class="td09">
                                <%= e06ReHouseData.REPT_DATE.equals("0000-00-00")||e06ReHouseData.REPT_DATE.equals("") ? "" : WebUtil.printDate(e06ReHouseData.REPT_DATE, ".") %></td>
                                <INPUT TYPE="hidden" name="REPT_DATE"    value="<%= e06ReHouseData.REPT_DATE    %>" >
                              <%  } %>
                            </tr>
                          </table>
                          <!--신청정보 테이블 끝-->
                        </td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          대출정보</td>
                      </tr>
                      <tr>
                        <td>
                          <!--대출정보 테이블 시작-->
                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                              <td width="100" class="td01">대출금액</td>
                              <td width="220" class="td09">
                                <%= WebUtil.printNumFormat(Double.parseDouble(e06ReHouseData.DARBT)*100) %> 원 </td>
                              <td width="100" class="td01">대출일자</td>
                              <td class="td09">
                                <%= e06ReHouseData.DATBW.equals("0000-00-00")||e06ReHouseData.DATBW.equals("") ? "" : WebUtil.printDate(e06ReHouseData.DATBW, ".") %> </td>
                            </tr>
                            <tr>
                              <td class="td01">기상환액</td>
                              <td class="td09">
                                <%= WebUtil.printNumFormat(Double.parseDouble(e06ReHouseData.ALREADY_AMNT)*100) %> 원 </td>
                              <td class="td01">대출잔액</td>
                              <td class="td09">
                                <%  double sum = (Double.parseDouble(e06ReHouseData.DARBT)*100) - (Double.parseDouble(e06ReHouseData.ALREADY_AMNT)*100) ; %>
                                <%= WebUtil.printNumFormat(sum) %> 원 </td>
                            </tr>
                            <tr>
                              <td class="td01">보증여부</td>
                              <td colspan="3" class="td09">
                                <%  if( e06ReHouseData.ZZSECU_FLAG.equals("Y") ) {  %>
                                연대보증인 입보
                                <%  } else if( e06ReHouseData.ZZSECU_FLAG.equals("N") ) {  %>
                                보증보험가입희망
                                <%  } else if( e06ReHouseData.ZZSECU_FLAG.equals("C") ) {  %>
                                신용보증
                                <%  } %>
                              </td>
                            </tr>
                          </table>
                          <!--대출정보 테이블 끝-->
                        </td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          입금정보</td>
                      </tr>
                      <tr>
                        <td>
                          <!--입금정보 테이블 시작-->
                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                              <td width="100" class="td01">전기일자</td>
                              <td colspan="3" class="td09">
                                <%  if( approvalStep == DocumentInfo.DUTY_CHARGER ) {  %>
                                <input name="BUDAT" type="text" value="<%= e06ReHouseData.BUDAT.equals("0000-00-00")||e06ReHouseData.BUDAT.equals("") ? "" : WebUtil.printDate(e06ReHouseData.BUDAT, ".") %>" size="12" onBlur="dateFormat(this);" class="input03" >
                                <!-- 날짜검색-->
                                <a href="javascript:fn_openCal('BUDAT')"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="날짜검색"></a>
                                <%  } else { %>
                                <%= e06ReHouseData.BUDAT.equals("0000-00-00")||e06ReHouseData.BUDAT.equals("") ? "" : WebUtil.printDate(e06ReHouseData.BUDAT, ".") %>
                                <INPUT TYPE="hidden" name="BUDAT" value="<%= e06ReHouseData.BUDAT %>" >
                                <%  } %>
                              </td>
                            </tr>
                            <tr>
                              <td class="td01">은행계정</td>
                              <td width="220" class="td09">
                                <%  if( approvalStep == DocumentInfo.DUTY_CHARGER ) {  %>
                                <input name="NEWKO" type="text" value="<%= e06ReHouseData.NEWKO.equals("0") ? "" : e06ReHouseData.NEWKO %>" size="20" onBlur="javascript:usableChar(this, '0123456789');" class="input03" >
                                <%  } else { %>
                                <%= e06ReHouseData.NEWKO.equals("0") ? "" : e06ReHouseData.NEWKO %>
                                <INPUT TYPE="hidden" name="NEWKO"    value="<%= e06ReHouseData.NEWKO    %>" >
                                <%  } %>
                              </td>
                              <td width="100" class="td01">전표번호</td>
                              <td class="td09">
                                <%  if( approvalStep == DocumentInfo.DUTY_CHARGER ) {  %>
                                <input name="BELNR" type="text" value="<%= e06ReHouseData.BELNR.equals("0") ? "" : e06ReHouseData.BELNR %>" size="20" onBlur="javascript:usableChar(this, '0123456789');" class="input03" >
                                <INPUT TYPE="hidden" name="SLIP_NUMB"    value="<%= e06ReHouseData.BELNR %>" >
                                <%  } else { %>
                                <%= e06ReHouseData.BELNR.equals("0") ? "" : e06ReHouseData.BELNR %>
                                <INPUT TYPE="hidden" name="BELNR"    value="<%= e06ReHouseData.BELNR %>" >
                                <INPUT TYPE="hidden" name="SLIP_NUMB"    value="<%= e06ReHouseData.BELNR %>" >
                                <%  } %>
                              </td>
                            </tr>
                          </table>
                          <!--입금정보 테이블 끝-->
                        </td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
              적요</td>
          </tr>
<%
    String tmpBigo = "";

    for (int i = 0; i < vcAppLineData.size(); i++) {
        AppLineData ald = (AppLineData) vcAppLineData.get(i);

        if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) {
            if (ald.APPL_PERNR.equals(user.empNo)) {
                tmpBigo = ald.APPL_BIGO_TEXT;
            } else {
%>
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
<%
            } // end if
        } // end if
    } // end for
%>
          <tr>
            <td class="td03" style="padding-top:5px;padding-bottom:5px">
                <textarea name="BIGO_TEXT" cols="80" rows="2" class="input03"><%=tmpBigo%></textarea>
            </td>
          </tr>
          <tr>
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                    결재정보</td>
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
                          <td class="td04">
                          <% if (isCanGoList) { %>
                            <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                          <%  } // end if %>
                            <a href="javascript:approval()"><img src="<%= WebUtil.ImageURL %>btn_submit.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                            <a href="javascript:reject()"><img src="<%= WebUtil.ImageURL %>btn_return.gif" border="0"></a>
                          </td>
                        </tr>
                      </table>
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

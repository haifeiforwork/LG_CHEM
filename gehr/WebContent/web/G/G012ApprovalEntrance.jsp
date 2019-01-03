<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 입학 축하금 결재                                            */
/*   Program ID   : G012ApprovalEntrance.jsp                                    */
/*   Description  : 입학 축하금 결재                                            */
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
<%@ page import="hris.E.E21Entrance.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    
    E21EntranceData e21EntranceData        = (E21EntranceData)request.getAttribute("e21EntranceData");
    
    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");
//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e21EntranceData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        } // end if
    } // end for
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다

   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e21EntranceData.AINF_SEQN ,user.empNo ,false);
    int approvalStep = docinfo.getApprovalStep();

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--
    //메시지
    function show_waiting_smessage(div_id ,message)
    {
        // alert(document.body.scrollLeft + "\t ," + document.body.scrollTop);
        var _x = document.body.clientWidth/2 + document.body.scrollLeft-120;
        var _y = document.body.clientHeight/2 + document.body.scrollTop+5;
        job_message.innerHTML = message;
        document.all[div_id].style.posLeft=_x;
        document.all[div_id].style.posTop=_y;
        document.all[div_id].style.visibility='visible';
    }
    function approval()
    {   
        var frm = document.form1;
    <% if (approvalStep == 5) { %>
        if(frm.PAID_AMNT.value == "" ) {
            alert("지급액을 입력하세요");
            return;
        } // end if
    <% } // end if %>
        if(!confirm("결재 하시겠습니까.")) {
            return;
        } // end if
    <% if (approvalStep == 5) { %>
        frm.PAID_AMNT.value = removeComma(frm.PAID_AMNT.value);
    <% } // end if %>
        frm.APPR_STAT.value = "A";
	buttonDisabled();
	show_waiting_smessage("waiting","결재 중입니다...");            
        
        frm.submit();
    }
    
    function reject()
    {
        if(!confirm("반려 하시겠습니까.")) {
            return;
        } // end if
        
        var frm = document.form1;
        frm.APPR_STAT.value = "R";
    <% if (approvalStep == 5) { %>
        frm.PAID_AMNT.value = "0";
    <% } // end if %>
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

//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');">
<!---- waiting message start-->
<DIV id="waiting" style="Z-INDEX: 1; LEFT: 50px; VISIBILITY: hidden; WIDTH: 250px; POSITION: absolute; TOP: 120px; HEIGHT: 45px">
<TABLE cellSpacing=1 cellPadding=0 width="98%" bgColor=black border=0>
  <TBODY>
  <TR bgColor=white>
    <TD>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD class=icms align=middle height=70 id = "job_message">... 잠시만 기다려주십시요 </TD>
        </TR>
        </TBODY>
      </TABLE>
    </TD>
  </TR>
  </TBODY>
</TABLE>
</DIV>
<!---- waiting message end-->
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="AINF_SEQN"   value="<%=e21EntranceData.AINF_SEQN%>">
<input type="hidden" name="PERNR"       value="<%=e21EntranceData.PERNR%>">
<input type="hidden" name="SUBF_TYPE"   value="<%=e21EntranceData.SUBF_TYPE%>">
<input type="hidden" name="BEGDA"       value="<%=e21EntranceData.BEGDA%>">
<input type="hidden" name="PAID_DATE"   value="<%=e21EntranceData.PAID_DATE%>">
<input type="hidden" name="FAMSA"       value="<%=e21EntranceData.FAMSA%>">
<input type="hidden" name="ATEXT"       value="<%=e21EntranceData.ATEXT%>">
<input type="hidden" name="LNMHG"       value="<%=e21EntranceData.LNMHG%>">
<input type="hidden" name="FNMHG"       value="<%=e21EntranceData.FNMHG%>">
<input type="hidden" name="REGNO"       value="<%=e21EntranceData.REGNO%>">
<input type="hidden" name="ACAD_CARE"   value="<%=e21EntranceData.ACAD_CARE%>">
<input type="hidden" name="STEXT"       value="<%=e21EntranceData.STEXT%>">
<input type="hidden" name="FASIN"       value="<%=e21EntranceData.FASIN%>">
<input type="hidden" name="GESC2"       value="<%=e21EntranceData.GESC2%>">
<input type="hidden" name="KDSVH"       value="<%=e21EntranceData.KDSVH%>">
<input type="hidden" name="WAERS"       value="KRW">
<input type="hidden" name="POST_DATE"   value="<%=e21EntranceData.POST_DATE%>">
<input type="hidden" name="BELNR"       value="<%=e21EntranceData.BELNR%>">
<input type="hidden" name="ZPERNR"      value="<%=e21EntranceData.ZPERNR%>">
<input type="hidden" name="ZUNAME"      value="<%=e21EntranceData.ZUNAME%>">
<input type="hidden" name="AEDTM"       value="<%=e21EntranceData.AEDTM%>">
<input type="hidden" name="UNAME"       value="<%=e21EntranceData.UNAME%>">
<input type="hidden" name="PROP_YEAR" value="<%=e21EntranceData.PROP_YEAR%>">

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
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">입학 축하금
                    결재해야 할 문서 </td>
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
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td width="100" class="td01">신청일자</td>
                              <td width="200" class="td09"><%=WebUtil.printDate(e21EntranceData.BEGDA)%></td>
                              <td width="100" class="td01">입학년도<font color="#006699">&nbsp;</font></td>
                              <td class="td09"><%= e21EntranceData.PROP_YEAR %> 년</td>
                            </tr>
                            <tr> 
                              <td class="td01" width="100">이름 <font color="#006699">*</font></td>
                              <td class="td09"><%= e21EntranceData.LNMHG %><%= e21EntranceData.FNMHG %></td>
                              <td class="td01">주민등록번호<font color="#006699">&nbsp;</font></td>
                              <td class="td09"><%= DataUtil.addSeparate(e21EntranceData.REGNO) %></td>
                            </tr>
                            <tr> 
                              <td class="td01">학력</td>
                              <td class="td09"><%= e21EntranceData.STEXT %></td>
                              <td class="td01">교육기관</td>
                              <td class="td09"><%= e21EntranceData.FASIN %></td>
                            </tr>
                            <tr> 
                              <td class="td01">지급액</td>
                              <td colspan="3" class="td09">
                              <% if (approvalStep == DocumentInfo.DUTY_CHARGER) {%>
                                <input type="text" NAME="PAID_AMNT" value="50,000" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEvent(this,'<%= e21EntranceData.WAERS %>');" onBlur="if (this.value == '') this.value = '0' ;" class="input03">
                                KRW
                              <% } else if (approvalStep == DocumentInfo.DUTY_MANGER) {%>
                                <%=WebUtil.printNumFormat(e21EntranceData.PAID_AMNT ,currencyValue)%>
                                <input type="hidden" name="PAID_AMNT"   value="<%=e21EntranceData.PAID_AMNT%>">
                              <% } // end if %>
                              </td>
                            </tr>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
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
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
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
                          <span id="sc_button">  
                          <% if (isCanGoList) {  %>
                            <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                          <% } // end if %>
                            <a href="javascript:approval()"><img src="<%= WebUtil.ImageURL %>btn_submit.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                            <a href="javascript:reject()"><img src="<%= WebUtil.ImageURL %>btn_return.gif" border="0"></a>
                          </span>                             
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

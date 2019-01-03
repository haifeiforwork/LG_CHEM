<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 교육/출장 결재                                              */
/*   Program ID   : G068ApprovalEduTrip.jsp                                     */
/*   Description  : 교육/출장 결재                                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-03-08  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D19EduTrip.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

    D19EduTripData   data  = (D19EduTripData)request.getAttribute("d19EduTripData");

    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(data.AINF_SEQN ,user.empNo ,false);
    int approvalStep = docinfo.getApprovalStep();

  //근태유형추가
  Vector D03VocationAReason0010_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR, "0010",DataUtil.getCurrentDate());
  Vector D03VocationAReason0020_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR, "0020",DataUtil.getCurrentDate());

  Vector D03OvertimeCodeData0010_vt  = new Vector();
  for( int i = 0 ; i < D03VocationAReason0010_vt.size() ; i++ ){
      D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0010_vt.get(i);
      CodeEntity code_data = new CodeEntity();
      code_data.code = old_data.SCODE ;
      code_data.value = old_data.STEXT ;
      D03OvertimeCodeData0010_vt.addElement(code_data);
  }

  Vector D03OvertimeCodeData0020_vt  = new Vector();
  for( int i = 0 ; i < D03VocationAReason0020_vt.size() ; i++ ){
      D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0020_vt.get(i);
      CodeEntity code_data = new CodeEntity();
      code_data.code = old_data.SCODE ;
      code_data.value = old_data.STEXT ;
      D03OvertimeCodeData0020_vt.addElement(code_data);
  }
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr2.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

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
        if(!confirm("결재 하시겠습니까.")) {
            return;
        } // end if
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

<input type="hidden" name="PERNR"        value="<%=data.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=data.BEGDA%>">
<input type="hidden" name="AINF_SEQN"    value="<%=data.AINF_SEQN%>">

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
                  <td class="subhead"><h2>교육/출장 결재해야 할 문서</h2></td>
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
	           			<li><a class="darken" href="javascript:approval()"><span>결재</span></a></li>
	           			<li><a href="javascript:reject()"><span>반려</span></a></li>
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
              <!-- 상단 테이블 시작-->
             	<div class="tableArea">
                  <table class="tableGeneral">
                    <tr>
                      <th width="100">신청일</th>
                      <td width="260">
                        <input type="text" name="BEGDA" value="<%= data.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>" size="20" readonly>
                      </td>
                      <th class="th02" width="100">휴가구분</th>
                      <td>
                        <input type="radio" name="awart" value="0010" <%= data.AWART.equals("0010") ? "checked" : "" %>>
                        교육
                        <input type="radio" name="awart" value="0020" <%= data.AWART.equals("0020") ? "checked" : "" %>>
                        출장
                      </td>
                    </tr>
                    <tr id="gntaegubun">
                      <th>구분</th>
                      <td colspan="3">
	                        <select  name="OVTM_CODE" disabled>
	                        <%= data.AWART.equals("0010") ?  WebUtil.printOption( D03OvertimeCodeData0010_vt,data.OVTM_CODE) : WebUtil.printOption( D03OvertimeCodeData0020_vt,data.OVTM_CODE)%>
	                        </select>
                      </td>
                    </tr>
                    <tr>
                      <th>신청사유</th>
                      <td colspan="3">
                        <input type="text" name="REASON" value="<%= data.REASON %>" size="80" readonly>
                      </td>
                    </tr>
                    <!--@v1.2-->
                    <tr>
                      <th>대근자</th>
                      <td>
                        <input type="text" name="OVTM_NAME" value="<%= data.OVTM_NAME %>" size="10" maxlength="10" style="ime-mode:active" readonly>
                      </td>
                      <th class="th02">신청기간</th>
                      <td>
                        <input type="text" name="APPL_FROM" value="<%= data.APPL_FROM.equals("0000-00-00") ? "" : WebUtil.printDate(data.APPL_FROM) %>" size="10" readonly>
                        부터
                        <input type="text" name="APPL_TO"   value="<%= data.APPL_TO.equals("0000-00-00")   ? "" : WebUtil.printDate(data.APPL_TO)   %>" size="10" readonly>
                        까지
                      </td>
                    </tr>
<!--
                    <tr>
                      <td class="td01" width="95">신청시간</td>
                      <td class="td09">
                        <input type="text" name="BEGUZ" value="<%= data.BEGUZ.equals("") ? "" : WebUtil.printTime(data.BEGUZ) %>" size="20" class="input04" readonly>
                        부터
                        <input type="text" name="ENDUZ" value="<%= data.ENDUZ.equals("") ? "" : WebUtil.printTime(data.ENDUZ) %>" size="20" class="input04" readonly>
                        까지 <%= data.BEGUZ.equals("") && data.ENDUZ.equals("") ? "" : WebUtil.printNumFormat(DataUtil.getBetweenTime(data.BEGUZ, data.ENDUZ), 2) + " 시간" %>
                      </td>
                    </tr>
-->
                <input type="hidden" name="BEGUZ" value="<%=  data.BEGUZ  %>">
                <input type="hidden" name="ENDUZ" value="<%=  data.ENDUZ  %>">

                  </table>
				</div>
              <!-- 상단 테이블 끝-->
            </td>
          </tr>
          <tr>
            <td><h2 class="subtitle">적요</h2></td>
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
                </table>
            </td>
          </tr>
                <% } // end if %>
            <% } // end if %>
        <% } // end for %>
          <tr>
            <td>
           		<div class="tableArea">
           			<table class="tableGeneral">
           				<tr>
           					<td><textarea name="BIGO_TEXT" cols="100" rows="4"><%=tmpBigo%></textarea></td>
           				</tr>
           			</table>
           		</div>
            </td>
          </tr>
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
                  <td align="center">
                  <!--버튼 들어가는 테이블 시작 -->
	                  	<div class="buttonArea">
	                  		<ul class="btn_crud">
	                  			<li><a class="darken" href="javascript:approval()"><span>결재</span></a></li>
	                  			<li><a href="javascript:reject()"><span>반려</span></a></li>
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
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

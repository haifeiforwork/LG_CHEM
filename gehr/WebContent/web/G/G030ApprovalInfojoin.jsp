<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 동호회 가입 결재                                            */
/*   Program ID   : G030ApprovalInfojoin.jsp                                       */
/*   Description  : 동호회 가입 결재                                            */
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
    DocumentInfo docinfo = new DocumentInfo(e25InfoJoinData.AINF_SEQN ,user.empNo ,false);
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

    //달력 사용 시작
    function fn_openCal(Objectname)
    {
       var lastDate;
       lastDate = eval("document.form1." + Objectname + ".value");
       small_window=window.open("/web/common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    }

    function approval()
    {
        var frm = document.form1;
        source = frm.APPL_DATE;
        if(source.value == "") {
            alert("가입일을 입력하세요");
            source.focus();
            return;
        } // end if

        source = frm.BETRG;
        if(source.value == "") {
            alert("회비를 입력하세요");
            source.focus();
            return;
        } // end if

        if(!confirm("결재 하시겠습니까.")) {
            return;
        } // end if
        frm.APPL_DATE.value = removePoint(frm.APPL_DATE.value);
        frm.BETRG.value = removeComma(frm.BETRG.value);
        frm.APPR_STAT.value = "A";
        frm.submit();
    }

    function reject()
    {
        if(!confirm("반려 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPL_DATE.value = "";
        frm.BETRG.value=0;
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
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="AINF_SEQN"    value="<%=e25InfoJoinData.AINF_SEQN%>">
<input type="hidden" name="PERNR"        value="<%=e25InfoJoinData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=e25InfoJoinData.BEGDA%>">
<input type="hidden" name="ENDDA"        value="<%=e25InfoJoinData.ENDDA%>">
<input type="hidden" name="MGART"        value="<%=e25InfoJoinData.MGART%>">
<input type="hidden" name="STEXT"        value="<%=e25InfoJoinData.STEXT%>">
<input type="hidden" name="LGART"        value="<%=e25InfoJoinData.LGART%>">
<input type="hidden" name="PERN_NUMB"    value="<%=e25InfoJoinData.PERN_NUMB%>">
<input type="hidden" name="ENAME"        value="<%=e25InfoJoinData.ENAME%>">
<input type="hidden" name="TITEL"        value="<%=e25InfoJoinData.TITEL%>">
<input type="hidden" name="USRID"        value="<%=e25InfoJoinData.USRID%>">
<input type="hidden" name="WAERS"        value="<%=e25InfoJoinData.WAERS%>">
<input type="hidden" name="INFO_TYPE"    value="<%=e25InfoJoinData.INFO_TYPE%>">
<input type="hidden" name="ZPERNR"       value="<%=e25InfoJoinData.ZPERNR%>">
<input type="hidden" name="ZUNAME"       value="<%=e25InfoJoinData.ZUNAME%>">

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
                  <td class="subhead"><h2>동호회 신청 가입 결재해야 할 문서</h2></td>
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
	                              <th class="th02">신청자사번</th>
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
	                              <td width="260">
	                              	<input type="text" name="APPL_DATE" size="10" maxlength="10" onBlur="dateFormat(this);">
	                                <a href="javascript:fn_openCal('APPL_DATE')">
	                                   <img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" align="absmiddle" border="0" alt="날짜검색">
	                                </a>
	                              </td>
	                              <th width="100" class="th02">회비 <font color="#006699">*</font></th>
	                              <td>
	                                <input type="text" NAME="BETRG" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEvent(this,'KRW');" onBlur="if(this.value=='') this.value = 0;" class="input03"> 원
	                              </td>
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
                <table width="780" border="0" cellpadding="0" cellspacing="1">
                    <tr>
                    	<td>
			            	<div class="tableArea">
			            		<table class="tableGeneral">
			            			<tr>
			            				<th><%=ald.APPL_ENAME%></th>
			            				<td><%=tmpBigo%></textarea></td>
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

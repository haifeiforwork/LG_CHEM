<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 부양가족  결재                                              */
/*   Program ID   : G018ApprovalSupport.jsp                                     */
/*   Description  : 부양가족 결재                                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*                      2014-12-02 2014-12-02 [CSR ID:2654794] 부양가족 신청화면 변경요청                                                         */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A12Family.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    A12FamilyBuyangData  a12FamilyBuyangData  = (A12FamilyBuyangData)request.getAttribute("a12FamilyBuyangData");
    A12FamilyListData    a12FamilyListData  = (A12FamilyListData)request.getAttribute("a12FamilyListData");

    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(a12FamilyBuyangData.AINF_SEQN ,user.empNo ,false);
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
function fn_openCal(Objectname){
   var lastDate;
   lastDate = eval("document.form1." + Objectname + ".value");
   small_window=window.open("/web/common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
}
//달력 사용 시작

    function approval()
    {
        var frm = document.form1;

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

<input type="hidden" name="PERNR"        value="<%=a12FamilyBuyangData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=a12FamilyBuyangData.BEGDA%>">
<input type="hidden" name="AINF_SEQN"    value="<%=a12FamilyBuyangData.AINF_SEQN%>">
<input type="hidden" name="GUBUN"        value="<%=a12FamilyBuyangData.GUBUN%>">
<input type="hidden" name="SUBTY"        value="<%=a12FamilyBuyangData.SUBTY%>">
<input type="hidden" name="STEXT"        value="<%=a12FamilyBuyangData.STEXT%>">
<input type="hidden" name="OBJPS"        value="<%=a12FamilyBuyangData.OBJPS%>">
<input type="hidden" name="FNMHG"        value="<%=a12FamilyBuyangData.FNMHG%>">
<input type="hidden" name="LNMHG"        value="<%=a12FamilyBuyangData.LNMHG%>">
<input type="hidden" name="REGNO"        value="<%=a12FamilyBuyangData.REGNO%>">
<input type="hidden" name="FAJOB"        value="<%=a12FamilyBuyangData.FAJOB%>">
<input type="hidden" name="DPTID"        value="<%=a12FamilyBuyangData.DPTID%>">
<input type="hidden" name="LIVID"        value="<%=a12FamilyBuyangData.LIVID%>">
<input type="hidden" name="HNDID"        value="<%=a12FamilyBuyangData.HNDID%>">
<input type="hidden" name="CHDID"        value="<%=a12FamilyBuyangData.CHDID%>">
<input type="hidden" name="HELID"        value="<%=a12FamilyBuyangData.HELID%>">
<input type="hidden" name="FAMID"        value="<%=a12FamilyBuyangData.FAMID%>">
<input type="hidden" name="DPTYP"        value="<%=a12FamilyBuyangData.DPTYP%>">
<input type="hidden" name="LOSS_DATE"    value="<%=a12FamilyBuyangData.LOSS_DATE%>">
<input type="hidden" name="ZPERNR"       value="<%=a12FamilyBuyangData.ZPERNR%>">
<input type="hidden" name="ZUNAME"       value="<%=a12FamilyBuyangData.ZUNAME%>">
<input type="hidden" name="AEDTM"        value="<%=a12FamilyBuyangData.AEDTM%>">
<input type="hidden" name="UNAME"        value="<%=a12FamilyBuyangData.UNAME%>">
<input type="hidden" name="CANC_DATE"    value="<%=a12FamilyBuyangData.CANC_DATE%>">
<input type="hidden" name="CANC_CODE"    value="<%=a12FamilyBuyangData.CANC_CODE%>">
<input type="hidden" name="CANC_ETCD"    value="<%=a12FamilyBuyangData.CANC_ETCD%>">

<input type="hidden" name="BALID"        value="<%=a12FamilyBuyangData.BALID%>">

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
                  <td class="subhead"><h2>부양가족 여부 결재해야 할 문서</h2></td>
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
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                        <td><h2 class="subtitle">대상자</h2></td>
                      </tr>
                      <tr>
                        <td>
                          <!--대상자 테이블 시작-->
                          <div class="tableArea">
                          <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0" >
                            <tr>
                              <th width="100">성명(한글)&nbsp;<font color="#006699">*</font></th>
                              <td width="250"> <%= a12FamilyBuyangData.LNMHG %> <%= a12FamilyBuyangData.FNMHG %></td>
                              <th class="th02" width="100">가족유형&nbsp;<font color="#006699">*</font></th>
                              <td><%= a12FamilyListData.STEXT %></td>
                            </tr>
                            <tr>
                              <th>주민등록번호&nbsp;<font color="#006699">*</font></th>
                              <td>
<%        String REGNO_dis = a12FamilyBuyangData.REGNO.substring(0, 6) + "-*******";
%>
                              <%=REGNO_dis%>
                               </td>
                              <th class="th02">관 계&nbsp;<font color="#006699">*</font></th>
                              <td> <%= a12FamilyListData.ATEXT %></td>
                            </tr>
                            <tr>
                              <th>생년월일&nbsp;<font color="#006699">*</font></th>
                              <td> <%= WebUtil.printDate(a12FamilyListData.FGBDT) %></td>
                              <th class="th02">성 별</th>
                              <td>
							  <% if (a12FamilyListData.FASEX.equals("1")) {%>
                                   남
                              <% }  else if (a12FamilyListData.FASEX.equals("2")) {%>
                                   여
                              <% } // end if %>
                              </td>
                            </tr>
                            <tr>
                              <th>출생지</th>
                              <td> <%= a12FamilyListData.FGBOT %></td>
                              <th class="th02">학 력&nbsp;<font color="#006699">*</font></th>
                              <td> <%=a12FamilyListData.STEXT1%></td>
                            </tr>
                            <tr>
                              <th>출생국</th>
                              <td> <%= a12FamilyListData.LANDX %></td>
                              <th class="th02">교육기관</th>
                              <td> <%= a12FamilyListData.FASIN %></td>
                            </tr>
                            <tr>
                              <th>국 적</th>
                              <td> <%= a12FamilyListData.NATIO %></td>
                              <th class="th02">직 업</th>
                              <td> <%= a12FamilyListData.FAJOB %></td>
                            </tr>
                          </table>
                          </div>
                          <!--대상자 테이블 끝-->
                        </td>
                      </tr>

                      <tr>
                        <td>
                        <div class="tableArea">
                        	<table class="tableGeneral">
                        		<tr>
                        			<th width="100">세금</th>
                        			<td width="250">
                        				<input type="checkbox" <%= a12FamilyBuyangData.DPTID.equals("X") ? "checked" : "" %> disabled>부양가족
                        				<input type="checkbox" name="BALID1" <%= a12FamilyBuyangData.BALID.equals("X") ? "checked" : "" %> disabled>수급자
                        				<input type="checkbox" <%= a12FamilyBuyangData.HNDID.equals("X") ? "checked" : "" %> disabled>장애인
                        			</td>
									<th class="th02" width="100">기타</th>
                        			<td>
										<input type="checkbox" <%= a12FamilyBuyangData.LIVID.equals("X") ? "checked" : "" %> disabled>동거여부
                        			</td>
                        		</tr>
                        	</table>
                        </div>
                        </td>
                      </tr>
                    </table>
                    </td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
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

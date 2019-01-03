<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 초과근무 결재 완료                                          */
/*   Program ID   : G029ApprovalFilnishiOT.jsp                                       */
/*   Description  : 초과근무 결재 완료                                          */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-28 이승희                                           */
/*   Update       : 2003-03-28 이승희                                           */
/*                      2015-06-18 [CSR ID:2803878] 초과근무 신청 Process 변경 요청                                                        */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.G.rfc.ApprovalCancelCheckRFC" %>
<%@ page import="hris.D.rfc.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    
    D01OTData   d01OTData  = (D01OTData)request.getAttribute("d01OTData");
    
    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
    //CSR ID:1546748 
    String OVTM_CDNM = "";
    if (!d01OTData.OVTM_CODE.equals("")){
         
         String DATUM     = DataUtil.getCurrentDate();    
         Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, d01OTData.PERNR, "2005",d01OTData.BEGDA);
         for( int i = 0 ; i < D03VocationAReason_vt.size() ; i++ ){
             D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(i);
             if (d01OTData.OVTM_CODE.equals(old_data.SCODE)) {
                 OVTM_CDNM = old_data.STEXT ;  
             }
         } 
    }        
    String chkApp = "N";
    //결재취소가능여부
    ApprovalCancelCheckRFC chkRfc = new ApprovalCancelCheckRFC();
    Vector vt = new Vector();
    vt = chkRfc.get(d01OTData.PERNR, d01OTData.AINF_SEQN);
    chkApp = (String)vt.get(0);
    
    
//  [CSR ID:2803878] 초과근무 관련 현황 조회
    D02KongsuHourRFC rfcH       = new D02KongsuHourRFC();
    String yymm = DataUtil.getCurrentYear()+DataUtil.getCurrentMonth();
    Vector ovtmKongsuHour = rfcH.getOvtmHour(d01OTData.PERNR,yymm,"C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재
    
    String YUNJANG = (String)ovtmKongsuHour.get(1); 
    String HTKGUN = (String)ovtmKongsuHour.get(2); 
    String HYUNJANG = (String)ovtmKongsuHour.get(3); 
    String YAGAN = (String)ovtmKongsuHour.get(4); 
    String NOAPP = (String)ovtmKongsuHour.get(5);
    //  [CSR ID:2803878] 초과근문 수정 (월 받아오기/소수점 처리)
    String MONTH = (String)ovtmKongsuHour.get(6);
    if(YUNJANG != null && YUNJANG.indexOf(".") > -1 ) { YUNJANG = YUNJANG.substring(0, (YUNJANG.indexOf(".")+2)); }
    if(HTKGUN != null && HTKGUN.indexOf(".") > -1 ) { HTKGUN = HTKGUN.substring(0, (HTKGUN.indexOf(".")+2)); }
    if(HYUNJANG != null && HYUNJANG.indexOf(".") > -1 ) { HYUNJANG = HYUNJANG.substring(0, (HYUNJANG.indexOf(".")+2)); }
    if(YAGAN != null && YAGAN.indexOf(".") > -1 ) { YAGAN = YAGAN.substring(0, (YAGAN.indexOf(".")+2)); }
    if(NOAPP != null && NOAPP.indexOf(".") > -1 ) { NOAPP = NOAPP.substring(0, (NOAPP.indexOf(".")+2)); }
    
    //[CSR ID:2803878] 사무직의 경우 원근무자(대근시) 의 입력 field 가 조회되지 않도록 하기위한 조건
    String officerYN = "";
    if(user.e_persk.equals("31")||user.e_persk.equals("32")||user.e_persk.equals("33")||user.e_persk.equals("34")||user.e_persk.equals("35")||user.e_persk.equals("38")){
    	officerYN = "N";
    }else{
    	officerYN = "Y";
    }
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery.js"></script>

<script language="JavaScript">
<!--
	//결재취소버튼 ctrl
	function btnCtrl(){
		$('#btn').hide();
		//값받아오기
		var tbody = $('#table tbody');	//id가 table인 obj 의 tbody obj를 찾는다.
		var rows = tbody.find('tr').length-2;	//tbody obj의 갯수를 찾는다.	
		if(rows>-1){			
			var stat = eval("document.form1.APPL_APPR_STAT"+rows+".value");
			var num1 = document.form1.persInfo_PERNR.value;
			var num2 = "<%=user.empNo%>";
			var chkApp = document.form1.chkApp.value;
			if(stat=="승인"&&num1==num2&&chkApp=="Y"){
				$('#btn').show();				
			} else {
				$('#btn').hide();
			}
		}
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
	
	 //결재취소로직
    function appCancel(){
    	//팝업띄우기
    	window.open("<%= WebUtil.ServletURL %>hris.D.D01OT.D01OTCancelBuildSV?AINF_SEQN=<%=d01OTData.AINF_SEQN%>","결재취소","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=830,height=675,left=100,top=10");
    }
	
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');btnCtrl();">
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="PERNR"        value="<%=d01OTData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=d01OTData.BEGDA%>">
<input type="hidden" name="AINF_SEQN"    value="<%=d01OTData.AINF_SEQN%>">
<input type="hidden" name="chkApp" value="<%=chkApp%>">
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
                  <td width="624" class="title02">
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 초과근무 결재완료  문서 
                  </td>
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
                  <td class="tr01">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td>
                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                              <td width="100" class="td01">신청일</td>
                              <td class="td09"> <%= WebUtil.printDate( d01OTData.BEGDA) %></td>
                            
                            <!-- [CSR ID:2803878] 초과근무 신청 화면 수정 -->
                        <td rowspan = "5" width="180">
                        <table border="0" cellspacing="1" cellpadding="5" class="table01">
                        	<tr>
                        		<td colspan="2" width="180" class="td03" align="center"><%=MONTH %>월 초과근무 현황
                        			<!-- [CSR ID:2803878] 초과근무 문구수정 -->
                        			<br/>(전월 21일 ~ 당월 20일 기준)                        		
                        		</td>
                        	</tr>
                        	<tr>
                        		<td class="td09" width="50%" >평일연장</td>
                        		<td class="td09" width="50%" ><%=YUNJANG %>&nbsp;시간</td>
                        	</tr>
                        	<tr>
                        		<td class="td09">휴일근로</td>
                        		<td class="td09"><%=HTKGUN %>&nbsp;시간</td>
                        	</tr>
                        	<tr>
                        		<td class="td09">휴일연장</td>
                        		<td class="td09"><%=HYUNJANG %>&nbsp;시간</td>
                        	</tr>
                        	<tr>
                        		<td class="td09">야간근로</td>
                        		<td class="td09"><%=YAGAN %>&nbsp;시간</td>
                        	</tr>
                        	<tr>
                        		<td class="td09">결재 진행 중<br>초과근로</td>
                        		<td class="td09"><%=NOAPP %>&nbsp;시간</td>
                        	</tr>                        	
                        </table>
                        </td>
                            
                            
                            
                            
                            
                            
                            
                            
                            </tr>
                            <tr> 
                              <td class="td01" width="95">초과근무일&nbsp;<font color="#006699"><b>*</b></font></td>
                              <td class="td09"> 
								<%= WebUtil.printDate( d01OTData.WORK_DATE) %> 
								<input type="checkbox" <%= (d01OTData.VTKEN).equals("X") ? "checked" : "" %> disabled >
                                    前日 근태에 포함
                                </td>
                            </tr>
                            <tr> 
                              <td class="td01" width="95">시간&nbsp;<font color="#006699"><b>*</b></font></td>
                              <td class="td09"> 
								<%= WebUtil.printTime( d01OTData.BEGUZ )%> ~  <%= WebUtil.printTime( d01OTData.ENDUZ ) %> 
                                <%= WebUtil.printNum(d01OTData.STDAZ) %>시간
                              </td>
                            </tr>
                            <tr> 
                              <td class="td01" width="95">신청사유&nbsp;<font color="#006699"><b>*</b></font></td>
                              <td class="td09"> <%= OVTM_CDNM %>  <%= d01OTData.REASON %> </td>
                            </tr>
                            <!-- [CSR ID:2803878] 초과근무 수정 -->
                            <% if ( ((d01OTData.OVTM_CODE).equals("01") && officerYN.equals("N")) || !(d01OTData.OVTM_NAME).equals("") ) { %>
                            <tr>
                              <td class="td01" width="105">원근무자(대근시)&nbsp;</td>
                              <td class="td09"> <%= d01OTData.OVTM_NAME %>
                              </td>
                            </tr>  
                            <% } %> 
                      <!-- [CSR ID:2803878] 초과근무 수정 -->                                          
                            <tr>
                      <td class="td01" width="105">상세업무일정&nbsp;</td>
                      <td class="td09"><textarea name="OVTM_DESC" wrap="HAND" cols="70" class="input04" rows="4" readonly><%=d01OTData.OVTM_DESC1 +"\n"+ d01OTData.OVTM_DESC2 +"\n"+ d01OTData.OVTM_DESC3 +"\n"+ d01OTData.OVTM_DESC4 %></textarea>
                      </td>
                      </tr> 
                <tr>                              
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>
                          <table width="661" border="0" cellspacing="1" cellpadding="0" class="table02">
                            <tr> 
                              <td class="td01" width="100">&nbsp;</td>
                              <td class="td03" width="170">시작시간</td>
                              <td class="td03" width="170">종료시간</td>
                              <td class="td03">무급</td>
                              <td class="td03">유급</td>
                            </tr>
                            <tr> 
                              <td class="td01">휴게시간1</td>
                              <td class="td04"> <%= WebUtil.printTime( d01OTData.PBEG1 ) %></td>
                              <td class="td04"> <%= WebUtil.printTime( d01OTData.PEND1 ) %></td>
                              <td class="td04"> <%=  (d01OTData.PUNB1).equals("0") ? "" : WebUtil.printNumFormat(d01OTData.PUNB1) %></td>
                              <td class="td04"> <%=  (d01OTData.PBEZ1).equals("0") ? "" : WebUtil.printNumFormat(d01OTData.PBEZ1) %></td>
                            </tr>
                            <tr> 
                              <td class="td01">휴게시간2</td>
                              <td class="td04"> <%= WebUtil.printTime( d01OTData.PBEG2 ) %></td>
                              <td class="td04"> <%= WebUtil.printTime( d01OTData.PEND2 ) %></td>
                              <td class="td04"> <%=  (d01OTData.PUNB2).equals("0") ? "" : WebUtil.printNumFormat(d01OTData.PUNB2) %></td>
                              <td class="td04"> <%=  (d01OTData.PBEZ2).equals("0") ? "" : WebUtil.printNumFormat(d01OTData.PBEZ2) %></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
            </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
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
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td>
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
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 결재정보</td>
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
                          <% if (isCanGoList) {  %>
                            <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>
                          <% } // end if %>
                          <a href="javascript:appCancel()"><img id="btn" src="<%= WebUtil.ImageURL %>btn_app_cancel.gif" border="0"></a>
                          </td>
                        </tr>
                      </table>
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

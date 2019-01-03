<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야 할 문서                                           */
/*   Program Name : 초과근무 결재                                               */
/*   Program ID   : G026ApprovalCerti.jsp                                       */
/*   Description  : 초과근무 결재                                               */
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
<%@ page import="hris.D.rfc.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");
    
    D01OTData   d01OTData  = (D01OTData)request.getAttribute("d01OTData");
    
    Vector      vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String      RequestPageName = (String)request.getAttribute("RequestPageName");
    
    PersInfoData    persInfoTemp            = (PersInfoData) request.getAttribute("PersInfoData"); 
   
    boolean isCanGoList ; 
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if
   
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(d01OTData.AINF_SEQN ,user.empNo ,false);
    int approvalStep = docinfo.getApprovalStep();
    //CSR ID:1546748 
    String OVTM_CDNM = "";
    if (!d01OTData.OVTM_CODE.equals("")){
         
         Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, d01OTData.PERNR, "2005",d01OTData.BEGDA);
         for( int i = 0 ; i < D03VocationAReason_vt.size() ; i++ ){
             D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(i);
             if (d01OTData.OVTM_CODE.equals(old_data.SCODE)) {
                 OVTM_CDNM = old_data.STEXT ;  
             }
         } 
    }
    
//  [CSR ID:2803878] 초과근무 관련 현황 조회
    D02KongsuHourRFC rfcH       = new D02KongsuHourRFC();
    String yymm = DataUtil.getCurrentYear()+DataUtil.getCurrentMonth();
    Vector ovtmKongsuHour = rfcH.getOvtmHour(d01OTData.PERNR,yymm,"C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재
    
    String YUNJANG = (String)ovtmKongsuHour.get(1); 
    String HTKGUN = (String)ovtmKongsuHour.get(2); 
    String HYUNJANG = (String)ovtmKongsuHour.get(3); 
    String YAGAN = (String)ovtmKongsuHour.get(4); 
    String NOAPP = (String)ovtmKongsuHour.get(5); 
    
    //[CSR ID:2803878] 사무직의 경우 원근무자(대근시) 의 입력 field 가 조회되지 않도록 하기위한 조건
    String officerYN = "";
    if(user.e_persk.equals("31")||user.e_persk.equals("32")||user.e_persk.equals("33")||user.e_persk.equals("34")||user.e_persk.equals("35")||user.e_persk.equals("38")){
    	officerYN = "N";
    }else{
    	officerYN = "Y";
    }
    
    //[CSR ID:2803878] 최종 승인 난 건들 + 현재 승인 요청 한 건의 1주 당 12시간 초과 여부 N은 넘은거, Y 는 안넘은거.
    Vector approvalData_vt = rfcH.getOvtmHour(d01OTData.PERNR,yymm,d01OTData.WORK_DATE,"G", d01OTData.AINF_SEQN, d01OTData.STDAZ, d01OTData.PBEG1, d01OTData.PEND1, d01OTData.PBEG2, d01OTData.PEND2);
    //Vector ovtmKongsuHour = rfcH.getOvtmHour(user.empNo,yymm,"C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재
    
    
    String sum = null;
    String OTDTMonth = null;
    String person_flag = null;
    D01OTData D01OTData = null;
     if(approvalData_vt != null){
    	sum         = approvalData_vt.get(1).toString(); 
    	int temp_int = sum.indexOf(".");
    	sum = sum.substring(0,temp_int);
    	person_flag = approvalData_vt.get(2).toString(); 
    	OTDTMonth = approvalData_vt.get(4).toString();
    }
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
		//[CSR ID:2803878] 메시지 형식 추가
	if("<%=person_flag%>" == "O"){//사무직
	     if(!confirm("<%=persInfoTemp.ENAME%>님은 금번 초과근무 신청 건을 포함하여\n<%=OTDTMonth%>월 휴일근로를 <%=sum%> 시간 실시하였습니다.\n불필요한 초과근로가 발생하지 않도록 적극적으로\n관리하여 주시기 바랍니다.\n결재하시겠습니까?")){  
	     	return;
	     }else{
	     	frm.APPR_STAT.value = "A";
	        frm.submit();
	     }
     }else if("<%=person_flag%>" == "P"){//생산직
     	 if(!confirm("<%=persInfoTemp.ENAME%>님은 금번 초과근무 신청 건을 포함하여\n1주간 초과근로를 <%=sum%> 시간 실시하였습니다.\n결재하시겠습니까?")){
     	 	return;
     	 }else{
	     	frm.APPR_STAT.value = "A";
	        frm.submit();
	     }
     }        
   // }else{
	    //    var frm = document.form1;
	    //    if(!confirm("결재 하시겠습니까.")) {
	    //        return;
	   //     } // end if
	       
	     //   frm.APPR_STAT.value = "A";
	     //   frm.submit();
        //}
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

<input type="hidden" name="PERNR"        value="<%=d01OTData.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=d01OTData.BEGDA%>">
<input type="hidden" name="AINF_SEQN"    value="<%=d01OTData.AINF_SEQN%>">

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
                  <td width="624" class="title02">
                    <img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 초과근무 결재해야 할 문서 
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
                        		<td colspan="2" class="td03" align="center"><%=DataUtil.getCurrentMonth() %>월 초과근무 현황
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
                              <td class="td09"> <%= OVTM_CDNM %> <%= d01OTData.REASON %> </td>
                            </tr>
                            <% if ( ((d01OTData.OVTM_CODE).equals("01") && officerYN.equals("N")) || !(d01OTData.OVTM_NAME).equals("") ) { %>
                            <tr>
                              <td class="td01" width="105">원근무자(대근시)&nbsp;</td>
                              <td class="td09"> <%= d01OTData.OVTM_NAME %>
                              </td>
                            </tr>  
                            <% } %>  
                            
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
                            <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                          <% } // end if %>
                            <a href="javascript:approval()"><img src="<%= WebUtil.ImageURL %>btn_submit.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                            <a href="javascript:reject()"><img src="<%= WebUtil.ImageURL %>btn_return.gif" border="0"></a>
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

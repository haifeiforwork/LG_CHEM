<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 진행중 문서                                            */
/*   Program Name : 휴가 결재 진행중/취소                                       */
/*   Program ID   : G055ApprovalIngVacation.jsp                                 */
/*   Description  : 휴가 결재 진행중/취소                                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-10 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.G.ApprovalCancelData" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

     /* 휴가신청 */
    Vector  d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
    D03VocationData       data = (D03VocationData)d03VocationData_vt.get(0);

    D03GetWorkdayRFC func = new D03GetWorkdayRFC();
    Object D03GetWorkdayData_vt = func.getWorkday( data.PERNR, data.BEGDA );
    // 사전부여휴가 잔여일수
    String ZKVRB1 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB1");
    // 선택적보상휴가 잔여일수
    String ZKVRB2 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB2");
    
    Vector      orgVcAppLineData    = (Vector)request.getAttribute("orgVcAppLineData");
    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");
    Vector  appCancelVt = (Vector)request.getAttribute("appCancelVt");
    ApprovalCancelData appdata = (ApprovalCancelData)appCancelVt.get(0);
    
    String      RequestPageName   = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(appdata.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
    //CSR ID:1546748 
    String OVTM_CDNM = "";
    if (!data.OVTM_CODE.equals("")){
         
         Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR,  data.AWART,data.BEGDA);
         for( int i = 0 ; i < D03VocationAReason_vt.size() ; i++ ){
             D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(i);
             if (data.OVTM_CODE.equals(old_data.SCODE)) {
                 OVTM_CDNM = old_data.STEXT ;  
             }
         } 
    }        
    //CSR ID:1546748 
    String E_BTRTL  = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode, data.PERNR, data.AWART,data.BEGDA);
    String YaesuYn = "";  
    if ( E_BTRTL.equals("BAAA")||E_BTRTL.equals("BAAB")||E_BTRTL.equals("BAAC")||
         E_BTRTL.equals("BAAD")||E_BTRTL.equals("BAAE")||E_BTRTL.equals("BAAF")||
         E_BTRTL.equals("BAEA")||E_BTRTL.equals("BAEB")||E_BTRTL.equals("BAEC")||E_BTRTL.equals("CABA")||
         E_BTRTL.equals("BBIA")){
         YaesuYn ="Y";         
    }         
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--
    function cancel()
    {
        if(!confirm("취소 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPR_STAT.value = "";
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
<form name="form1" method="post" action="">
<input type="hidden" name="jobid" value="save">
<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="AINF_SEQN"    value="<%=appdata.AINF_SEQN%>">
<input type="hidden" name="PERNR"        value="<%=appdata.PERNR%>">
<input type="hidden" name="BEGDA"        value="<%=appdata.BEGDA%>">

<input type="hidden" name="APPR_STAT">
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<input type="hidden" name="approvalStep" value="<%=approvalStep%>">
  <table width="806" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
      	<table width="780" border="0" cellspacing="0" cellpadding="0">
      		<tr> 
                 <td height="5"></td>
           	</tr>
         		<tr> 
           		<td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif"> 휴가 결재취소 결재진행 중 문서</td>
         		</tr>
	        <tr>
	        	<td>
	        		<table width="100%" border="0" cellspacing="0" cellpadding="0">
             				<tr> 
               				<td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
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
              <!-- 상단 입력 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr> 
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td>
                        
                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                              <td width="95" class="td01">신청일</td>
                              <td class="td09">
                                <input type="text" name="BEGDA" value="<%= data.BEGDA.equals("0000-00-00")||data.BEGDA.equals("") ? "" : WebUtil.printDate(data.BEGDA) %>" size="20" class="input04" readonly>
                              </td>
                            </tr>
                            <tr>
                              <td class="td01" width="95">휴가구분</td>
                              <td class="td09">
                                <input type="text" name="AWART" value="<%= data.AWART %>" class="input04" size="10" readonly>
                                <%
                                    String strAwrt = "";
                                    if( data.AWART.equals("0110") ) {
                                        strAwrt = "전일휴가";
                                    }else if( data.AWART.equals("0120") ) {
                                        strAwrt = "반일휴가(전반)";
                                    }else if( data.AWART.equals("0121") ) {
                                        strAwrt = "반일휴가(후반)";
                                    }else if( data.AWART.equals("0122") ) {
                                        strAwrt = "토요휴가";    
                                    }else if( data.AWART.equals("0340") ) {
                                        strAwrt = "휴일비근무";
                                    }else if( data.AWART.equals("0360") ) {
                                        strAwrt = "근무면제";
                                    }else if( data.AWART.equals("0140") ) {
                                        strAwrt = "하계휴가";
                                    }else if( data.AWART.equals("0130")||data.AWART.equals("0370") ) {
                                        strAwrt = "경조휴가";
                                    }else if( data.AWART.equals("0170") ) {
                                        strAwrt = "전일공가";
                                    }else if( data.AWART.equals("0180") ) {
                                        strAwrt = "시간공가";
                                    }else if( data.AWART.equals("0190") ) { //※CSR ID:C20111025_86242 모성보호휴가
                                        strAwrt = "모성보호휴가";
                                    }else if( data.AWART.equals("0150") ) {
                                        strAwrt = "보건휴가";  
                                    }  
                                %>
                                <%= strAwrt %>
                              </td>
                            </tr>
                            <tr>
                              <td class="td01" width="95">신청사유</td>
                              <td class="td09">
<% if( (data.AWART.equals("0130")||data.AWART.equals("0370")) && !data.CONG_CODE.equals("") ) { %>                     
                               <!--CSR ID:1225704--> 
                               <select name="CONG_CODE" class="input04" disabled>
                                 <option value="">-------------</option>
                                 <%= WebUtil.printOption((new E19CongCodeNewRFC()).getCongCode(user.companyCode,"X"), data.CONG_CODE) %>
                               </select> 
<% } %> 
                                <input type="text" name="REASON" value="<%= OVTM_CDNM %> <%= data.REASON %>" class="input04" size="80" readonly>
                              </td>
                            </tr>
                            <% if( YaesuYn.equals("Y") ) { //CSR ID:1546748 %> 
                            <tr id="OvtmName" > 
                              <td class="td01" width="105">대근자&nbsp;</td>
                              <td class="td09"> 
                              <input type="text" name="OVTM_NAME" value="<%= data.OVTM_NAME %>" class="input04" size="20" readonly>
                              </td>
                            </tr>  
                            <%} %>                            
                            <tr>
                              <td class="td01" width="95">잔여휴가일수</td>
                              <td style="padding:0px">
                                <table border="0" cellpadding="0" cellspacing="0">
                                  <tr style="padding:0px">
                                    <td class="td09">
                                      <% if( Double.parseDouble(data.REMAIN_DATE) < 0.0 ) { %>
                                      <input type="text" name="P_REMAIN" size="10" class="input04" value="0.0" style="text-align:right" readonly> 일
                                      <% }else { %>
                                      <input type="text" name="P_REMAIN" size="10" class="input04" value="<%= data.REMAIN_DATE.equals("0") ? "0" : WebUtil.printNumFormat(data.REMAIN_DATE, 1) %>" style="text-align:right" readonly> 일
                                      <% } %>
                                      </td>
                                <%
                                    if( user.companyCode.equals("N100") ) {
                                        if( !ZKVRB2.equals("0") ) { 
                                %>
                                    <td width="30"> </td>
                                    <td class="td01" width="125">교대휴가 잔여일수</td>
                                    <td class="td09">
                                      <input type="text" name="P_REMAIN3" size="10" class="input04" value="<%= ZKVRB2.equals("0") ? "0" : WebUtil.printNumFormat(ZKVRB2, 1) %>" style="text-align:right" readonly> 일
                                    </td>
                                <%
                                        }
                                        if( !ZKVRB1.equals("0") ) {
                                %>
                                    <td width="30"> </td>
                                    <td class="td01" width="125">사전부여휴가 잔여일수</td>
                                    <td class="td09">
                                      <input type="text" name="P_REMAIN2" size="10" class="input04" value="<%= ZKVRB1.equals("0") ? "0" : WebUtil.printNumFormat(ZKVRB1, 1) %>" style="text-align:right" readonly> 일
                                    </td>
                                <%
                                        }
                                    } else {
                                        if( !ZKVRB1.equals("0") ) { 
                                %>
                                    <td width="60"> </td>
                                    <td class="td01" width="95">사전부여휴가</td>
                                    <td class="td09">
                                      <input type="text" name="P_REMAIN2" size="10" class="input04" value="<%= ZKVRB1.equals("0") ? "0" : WebUtil.printNumFormat(ZKVRB1, 1) %>" style="text-align:right" readonly> 일
                                    </td>
                                <% 
                                    } 
                                        if( !ZKVRB2.equals("0") ) { 
                                %>
                                    <td width="60"> </td>
                                    <td class="td01" width="95">선택적보상휴가</td>
                                    <td class="td09">
                                      <input type="text" name="P_REMAIN3" size="10" class="input04" value="<%= ZKVRB2.equals("0") ? "0" : WebUtil.printNumFormat(ZKVRB2, 1) %>" style="text-align:right" readonly> 일
                                    </td>
                                <% 
                                        } 
                                    } 
                                %>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr>
                              <td class="td01" width="95">신청기간</td>
                              <td class="td09">
                                <input type="text" name="APPL_FROM" value="<%= data.APPL_FROM.equals("0000-00-00")||data.APPL_FROM.equals("") ? "" : WebUtil.printDate(data.APPL_FROM) %>" size="20" class="input04" readonly>
                                부터
                                <!--// 경조금의 경우, 일시적으로 막음. 2004.7.14. mkbae.-->
                                <% if( data.AWART.equals("0130")||data.AWART.equals("0370") ) { %>
                                <input type="text" name="APPL_TO"   value="<%= data.APPL_TO.equals("0000-00-00")||data.APPL_TO.equals("")   ? "" : WebUtil.printDate(data.APPL_TO)   %>" size="20" class="input04" readonly>
                                까지
                                <% }else { %>
                                <input type="text" name="APPL_TO"   value="<%= data.APPL_TO.equals("0000-00-00")||data.APPL_TO.equals("")   ? "" : WebUtil.printDate(data.APPL_TO)   %>" size="20" class="input04" readonly>
                                까지 <%= data.PBEZ4.equals("0") || data.PBEZ4.equals("") ? "" : WebUtil.printNumFormat(data.PBEZ4, 0) + " 일간" %>
                                <% } %>
                              </td>
                            </tr>
                            <tr>
                              <td class="td01" width="95">신청시간</td>
                              <td class="td09">
                                <input type="text" name="BEGUZ" value="<%= data.BEGUZ.equals("") ? "" : WebUtil.printTime(data.BEGUZ) %>" size="20" class="input04" readonly>
                                부터
                                <input type="text" name="ENDUZ" value="<%= data.ENDUZ.equals("") ? "" : WebUtil.printTime(data.ENDUZ) %>" size="20" class="input04" readonly>
                                까지 <%= data.BEGUZ.equals("") && data.ENDUZ.equals("") ? "" : WebUtil.printNumFormat(DataUtil.getBetweenTime(data.BEGUZ, data.ENDUZ), 2) + " 시간" %>
                              </td>
                            </tr>
                            <tr>
                              <td class="td01" width="95">휴가공제일수</td>
                              <td class="td09">
                                <input type="text" name="DEDUCT_DATE" value="<%= data.DEDUCT_DATE.equals("0") ? "" : WebUtil.printNumFormat(data.DEDUCT_DATE, 1) %>" size="20" class="input04" style="text-align:right" readonly>
                                일
                             </td>
				           </tr>
						</table>
						<!-- 휴가결재정보테이블 끝 -->
					</td>
				</tr>
                            
       <% 
            boolean visible = false;
            for (int i = 0; i < orgVcAppLineData.size(); i++) {
                AppLineData ald = (AppLineData) orgVcAppLineData.get(i);
                if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { 
                    visible = true;
                    break;
                } // end if 
            } // end for 
        %>
        <%   if (visible) { %>
        <tr> 
            <td>&nbsp;</td>
          </tr>
        <tr><td class="font01" style="padding-bottom:2px"> <img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td></tr>
        <tr>
		 	<td>
		 		<table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
        <% for (int i = 0; i < orgVcAppLineData.size(); i++) { %>
                    <% AppLineData ald = (AppLineData) orgVcAppLineData.get(i); %>
                    <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr> 
                       <td class="td01" width="95"><%=ald.APPL_ENAME%></td>
                       <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
				      </tr>
				    		<% } // end if %>
						<% } // end for %>
				</table>
			</td>
		</tr>
		<% } // end if %>
       						<tr> 
    				<td>&nbsp;</td>
  			</tr>
 <tr><td class="font01" style="padding-bottom:2px" colspan="2"> <img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 결재정보</td></tr>
 <tr> 
                  <td>
                    <!--결재정보 테이블 시작-->
                    <%= AppUtil.getAppOrgDetail(orgVcAppLineData) %>
                    <!--결재정보 테이블 끝-->
              </td>
		</tr>
		</table>
		<!-- 상단 입력 테이블 끝 -->
	   </td>
			</tr>
		</table>
		<!-- 상단 입력 라인 테이블 끝-->
	  </td>
	</tr>
	<tr> 
	  <td>&nbsp;</td>
	</tr>
       <tr> 
            <td>
            	<table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
            		<tr>
            			<td width="95" class="td01">취소신청일</td>
                        <td class="td09"><%=appdata.BEGDA.equals("0000-00-00")||appdata.BEGDA.equals("") ? "" : WebUtil.printDate(appdata.BEGDA)%></td>
            		</tr>
            		<tr>
            			<td width="95" class="td01">취소사유</td>
                        <td class="td09">
                        	<%=appdata.CANC_REASON %>                     	
                        </td>
            		</tr>
            	</table>
            </td>
          </tr>
          <tr> 
             <td>&nbsp;</td>
           </tr>
          <tr> 
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td>
          </tr>
          <tr>
            <td>
            <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
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
                       <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                       <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
                    </tr>
                <% } // end if %>
            <% } // end if %>
        <% } // end for %>
        </table></td>
        </tr>
          <tr> 
            <td class="td03" style="padding-top:5px;padding-bottom:5px">
                <%=tmpBigo%>
            </td>
          </tr>
			<tr>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td class="font01"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 결재정보</td>
			</tr>
                <tr>
                  <td>
                          <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(vcAppLineData) %>
                          <!--결재정보 테이블 끝-->
                        </td>
					</tr>
					<tr> 
			    		<td>&nbsp;</td>
					</tr>
       		</table>
       <!-- 컨텐츠 전체 테이블 끝-->
      </td>
      <!-- 컨텐츠 끝-->
   </tr>
   <!-- 버튼시작-->
    <tr> 
		<td align="center" colspan="2">
             <% if (isCanGoList) {  %>
               <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
             <% } // end if %>
             <% if (docinfo.isHasCancel()) {  %>
               <a href="javascript:cancel()"><img src="<%= WebUtil.ImageURL %>btn_cancel01.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
             <% } // end if %>
        </td>
    </tr>    
   <!-- 버튼끝-->
     <tr> 
        <td>&nbsp;</td>
     </tr>
</table>
<!-- 전체테이블 끝 -->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

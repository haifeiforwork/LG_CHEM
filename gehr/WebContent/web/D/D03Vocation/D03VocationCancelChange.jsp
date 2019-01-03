<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 결재진행중 문서                                             		*/
/*   2Depth Name  :                                                             */
/*   Program Name : 휴가취소 결재                                                   	*/
/*   Program ID   : G056ApprovalFinishVacation.jsp                              */
/*   Description  : 휴가취소 결재를 위한 jsp 파일                          			*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2013-09-23 손혜영                                           		*/
/*                : 2016-10-10 FD-038 GEHR통합작업-KSC 							*/
/*				  : 2017-07-20 eunha [CSR ID:3438118] flexible time 시스템 요청	*/
/*				  : 2018-05-17 성환희 [WorkTime52] 보상휴가 추가 건				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils"%>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.G.ApprovalCancelData" %>
<%

    WebUserData      user    = (WebUserData)session.getAttribute("user");
    String jobid = (String)request.getAttribute("jobid")==null?"":(String)request.getAttribute("jobid");
     /* 휴가신청 */
    Vector  d03VocationData_vt = (Vector)request.getAttribute("d03VocationData_vt");
     
    String E_AUTH = (String) request.getAttribute("E_AUTH")==null?"":(String) request.getAttribute("E_AUTH");

    D03VocationData       data = (D03VocationData)Utils.indexOf(d03VocationData_vt, 0);

    D03GetWorkdayRFC func = new D03GetWorkdayRFC();
    Object D03GetWorkdayData_vt = func.getWorkday( user.empNo, data.BEGDA );
    // 사전부여휴가 잔여일수
    String ZKVRB1 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB1");
    // 선택적보상휴가 잔여일수
    String ZKVRB2 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB2");
    Vector      orgVcAppLineData    = (Vector)request.getAttribute("orgVcAppLineData");
    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");
    Vector  appCancelVt = (Vector)request.getAttribute("appCancelVt");
    ApprovalCancelData appdata = (ApprovalCancelData)Utils.indexOf(appCancelVt, 0);
    // 현재 결재자 구분
    DocumentInfo docinfo = null;// new DocumentInfo(appdata.AINF_SEQN ,user.empNo);

    int approvalStep = 1;//docinfo.getApprovalStep();
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

    String strAwrt = "";
    if(data != null){
        strAwrt = g.getMessage("LABEL.D.D03."+data.AWART);
    }

    boolean visible = false;

//     for (int i = 0; i < orgVcAppLineData.size(); i++) {
//         AppLineData ald = (AppLineData) orgVcAppLineData.get(i);
//         if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) {
//             visible = true;
//             break;
//         } // end if
//     } // end for


	            boolean avisible = false;
// 	            for (int i = 0; i < vcAppLineData.size(); i++) {
// 	                AppLineData ald = (AppLineData) vcAppLineData.get(i);
// 	                if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) {
// 	                	avisible = true;
// 	                    break;
// 	                } // end if
// 	            } // end for


    E19CongCodeNewRFC e19rfc = new E19CongCodeNewRFC();
    Vector congVT = e19rfc.getCongCode(user.companyCode,"X");
    D03RemainVocationData dataRemain = (D03RemainVocationData)request.getAttribute("d03RemainVocationData");
	String remainDays = dataRemain.ANZHL_GEN.equals("0")?"0":Float.toString(NumberUtils.toFloat(dataRemain.ANZHL_USE)  / NumberUtils.toFloat(dataRemain.ANZHL_GEN) * 100);

%>


<c:set var="user" value="<%=user%>"/>
<c:set var="data" value="<%=data%>"/>
<c:set var="appdata" value="<%=appdata%>"/>
<c:set var="E_BTRTL" value="<%=E_BTRTL%>"/>
<c:set var="ZKVRB1" value="<%=ZKVRB1%>"/>
<c:set var="ZKVRB2" value="<%=ZKVRB2%>"/>
<c:set var="YaesuYn" value="<%=YaesuYn%>"/>
<c:set var="OVTM_CDNM" value="<%=OVTM_CDNM%>"/>
<c:set var="visible" value="<%=visible%>"/>
<c:set var="avisible" value="<%=avisible%>"/>
<c:set var="congVT" value="<%=congVT%>"/>
<c:set var="data_remain_date " value="<%=Double.parseDouble(data.REMAIN_DATE) %>"/>
<c:set var="dataRemain" value="<%=dataRemain%>"/>
<c:set var="remainDays" value="<%=remainDays%>"/>

<c:set var="E_AUTH" value="<%=E_AUTH%>"/>
<c:set var="strAwrt" value="<%=strAwrt%>"/>

<tags:layout css="ui_library_approval.css"  script="dialog.js" >

    <tags-approval:cancel-layout titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO"   updateUrl="${g.servlet}hris.D.D03Vocation.D03VocationChangeChangeSV" 	>

        <!-- 상단 입력 테이블 시작-->

        <tags:script>


<script language="JavaScript">
<!-- 버튼-->
//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha start
  $(function(){
	 if (${PersonData.e_PERSK==("21")||PersonData.e_PERSK==("22") }){
	    	if ( "${data.AWART}"=="0120"  || "${data.AWART}"=="0121" ){
	    		$('#requestTime').attr('style','display:none');
	    	}else{
	    		$('#requestTime').attr('style','display:inline-blobk');
	    	}
	 }
  });
//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha end
<c:choose>
<c:when test="${I_APGUB == '2' }">
	$(".btn_crud").html(" <li><a  href='${RequestPageName}'><span><spring:message code='BUTTON.COMMON.LIST'/></span></a></li> ");
	/* 신청자본이이 조회할때 완료건(승인)인경우 */
	if (${data.PERNR eq user.empNo and  approvalHeader.AFSTAT < '03' }){
        <c:if test="${approvalHeader.MODFL == 'X' && disable != true}">
			$(".btn_crud").html(" <li><a class=darken href='javascript:do_delete();'><span><spring:message code='BUTTON.COMMON.DELETE'/></span></a></li> "+$(".btn_crud").html());
            <c:if test="${disableUpdate != true}">
			$(".btn_crud").html(" <li><a href='javascript:chg_modify(1);'><span><spring:message code='BUTTON.COMMON.UPDATE'/></span></a></li> "+$(".btn_crud").html());
	        </c:if>
        </c:if>
	}
</c:when>
</c:choose>

<c:if test="${isUpdate==true}">
	$(".btn_crud").html(" <li><a href='javascript:do_back(\"\");'><span><spring:message code='BUTTON.COMMON.CANCEL'/></span></a></li> ");
	$(".btn_crud").html(" <li><a class=darken href='javascript:do_change();'><span><spring:message code='BUTTON.COMMON.REQUEST'/></span></a></li> "+$(".btn_crud").html());
	$("#CANC_REASON").removeAttr("readonly");
	$("#CANC_REASON").attr("class","input03");
	$("#table1").hide();
	$("#table2").show();
	document.form1.CANC_REASON.focus();
</c:if>

//:if>

<!-- 버튼끝-->

<!--
    //삭제
    function do_delete(){
		if(!confirm("<spring:message code='MSG.D.D03.0100'/>")) return;		//휴가결재취소 신청을 삭제하시겠습니까?
		document.form1.jobid.value = "delete";
        document.form1.target = "_self";
        document.form1.AINF_SEQN.value = "<c:out value='${appdata.AINF_SEQN}'/>"; // 기본결재 프로세스에서 원본결재번호로 되어있어서 교체해야됨-KSc
        document.form1.action = "<c:out value='${ g.servlet }' />hris.D.D03Vocation.D03VocationCancelChangeSV";
        document.form1.method = "post";
        document.form1.submit();
    }

    //수정상태로 변경
    function chg_modify(stat){
    	do_back( "changeMode" );
    	/*
    	if(stat==1){
    		$(".btn_crud").html(" <li><a href='javascript:do_back('');'><span><spring:message code='BUTTON.COMMON.CANCEL'/></span></a></li> ");
    		$(".btn_crud").html(" <li><a class=darken href='javascript:do_change();'><span><spring:message code='BUTTON.COMMON.REQUEST'/></span></a></li> "+$(".btn_crud").html());
	    	$("#CANC_REASON").removeAttr("readonly");
	    	$("#CANC_REASON").attr("class","input03");
	    	$("#table1").hide();
	    	$("#table2").show();
	    	document.form1.CANC_REASON.focus();
    	} else {
	    	$("#table2").hide();
    	}
    	*/
    }

    //재조회
    function do_back( _jobid ){
    	document.form1.jobid.value = _jobid ;
        document.form1.target = "_self";
        document.form1.AINF_SEQN.value = "<c:out value='${appdata.AINF_SEQN}'/>"; // 기본결재 프로세스에서 원본결재번호로 되어있어서 교체해야됨-KSc
        document.form1.action = "<c:out value='${ g.servlet }' />hris.D.D03Vocation.D03VocationCancelChangeSV";
        document.form1.method = "post";
        document.form1.submit();
        blockFrame();
    }

    //목록보기
	function goToList()
    {
        var frm = document.form1;
	    <c:if test='${isCanGoList }'>
	        frm.action = '<c:out value="${RequestPageName}" />';
	    </c:if>
        frm.jobid.value ="";
        frm.submit();
    }

    //취소사유입력
    function bfCheck(){
    	if(document.form1.CANC_REASON.value==""){
    		alert("<spring:message code='MSG.D.D03.0101'/>");	//"<!--취소사유를 입력하세요.");
    		return false;
    	}
    	return true;
    }

    //수정
    function do_change(){
    	if(!bfCheck) return;
    	//if(!confirm("수정하시겠습니까?")) return;
    	document.form1.jobid.value = "change";
        document.form1.target = "_self";
        document.form1.AINF_SEQN.value = "<c:out value='${appdata.AINF_SEQN}'/>";
        document.form1.action = "<c:out value='${ g.servlet }' />hris.D.D03Vocation.D03VocationCancelChangeSV";
        document.form1.method = "post";
        document.form1.submit();
    }

    //chg_modify(2);
    function beforeAccept(){
    	document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
    	return true;
    }

//-->
</script>
</tags:script>


<div class="tableArea">
    <div class="table">
        <table class="tableGeneral">
            	<colgroup>
            	<col width=15%/>
            	<col width=85%/>
            	</colgroup>

			<input type="hidden" name="BUKRS" value="<c:out value='${user.companyCode}' />">
			<!-- 결재취소정보 -->
			<input type="hidden" name="BEGDA"        value="<c:out value='${appdata.BEGDA}' />">
			<!-- 결재취소정보 -->
			<!-- 원결재정보 -->
			<input type="hidden" name="ORG_AINF_SEQN"    value="<c:out value='${data.AINF_SEQN}' />">
			<input type="hidden" name="ORG_BEGDA"        value="<c:out value='${data.BEGDA}' />">
			<input type="hidden" name="ORG_UPMU_TYPE"        value="<c:out value='${appdata.ORG_UPMU_TYPE}' />">
			<!-- 원결재정보 -->


								<c:if test="${E_AUTH eq 'Y'}">
					            <tr>
						             <th width="95"><spring:message code='LABEL.D.D03.0043'/><!-- 휴가유형 --></th>
						             <td>
						             	<c:choose>
						             		<c:when test="${data.AWART eq '0111' || data.AWART eq '0112' || data.AWART eq '0113'}">
						             			<spring:message code='LABEL.D.D03.0045'/><!-- 보상휴가 -->
						             		</c:when>
						             		<c:otherwise>
						             			<spring:message code='LABEL.D.D03.0046'/><!-- 휴가(연차,경조,공가 등) -->
						             		</c:otherwise>
						             	</c:choose>
						             </td>
								</tr>
								</c:if>
	                            <tr>
	                              <th  width="95"><spring:message code='LABEL.D.D19.0016'/><!-- 휴가구분 --></th>
	                              <td >
	                                <input type="text" name="AWART" value="<c:out value='${ data.AWART }' />" class="input04" size="10" readonly>

	                                <c:out value='${ strAwrt }' />
	                              </td>
	                            </tr>
	                            <tr>
	                              <th  width="95"><spring:message code='LABEL.D.D19.0005'/><!--신청사유--></th>
	                              <td >

								  <c:if test='${(data.AWART==("0130")||data.AWART==("0370")) && !data.CONG_CODE==("") }' >

		                               <!--CSR ID:1225704-->
		                               <select name="CONG_CODE" class="input04" disabled>
		                                 <option value="">-------------</option>
		                                 <c:out value='${ f:printCodeOption(congVT, data.CONG_CODE) }' />
		                               </select>

									</c:if>

	                                <input type="text" name="REASON" value="<c:out value='${ OVTM_CDNM }' /> <c:out value='${ data.REASON }' />" class="input04" size="80" readonly>
	                              </td>
	                            </tr>

 	                            <c:if test='${YaesuYn==("Y") }'> <%--//CSR ID:1546748 %>  --%>
		                            <tr id="OvtmName" >
		                              <th  width="105"><spring:message code='LABEL.D.D15.0161'/><!--대근자-->&nbsp;</th>
		                              <td >
		                              <input type="text" name="OVTM_NAME" value="<c:out value='${ data.OVTM_NAME }' />" class="input04" size="20" readonly>
		                              </td>
		                            </tr>
	                            </c:if>


	                            <tr>
	                              <th  width="95"><spring:message code='LABEL.D.D05.0085'/><!--잔여휴가일수--></th>
	                              <td style="padding:0px">


	                                <table border="0" cellpadding="0" cellspacing="0">
	                                <colgroup>
	                                <col width=40%/>
	                                <col width=30%/>
	                                <col />
	                                </colgroup>
	                                  <tr style="padding:0px">
	                                    <td class="noBtBorder">
	                                      <c:choose>
	                                      <c:when test='${ data_remain_date < 0.0  }' >
	                                      		<input type="text" name="P_REMAIN" size="10" class="input04" value="0.0" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
	                                      </c:when>
	                                      <c:otherwise>

	                                      		<input type="text" name="P_REMAIN" size="10" class="input04" value="<c:out value='${ data.REMAIN_DATE==("0") ? "0" : f:printNumFormat(data.REMAIN_DATE, 1) }' />" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
												<span>${dataRemain.ZKVRBTX}</span>
	                                      </c:otherwise>
	                                      </c:choose>

	                                      </td>

                                    <c:choose>
	                                <c:when test='${ user.companyCode==("N100") }'>
	                                        <c:if test='${ !ZKVRB2==("0") }' >

			                                    <td width="30"> </td>
			                                    <td  width="125"><spring:message code='LABEL.D.D03.0018'/><!--교대휴가 잔여일수--></td>
			                                    <td >
			                                      <input type="text" name="P_REMAIN3" size="10" class="input04" value="<c:out value='${ f:printNumFormat(ZKVRB2, 1) }' />" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
			                                    </td>
	                                		</c:if>

	                                        <c:if test='${ !ZKVRB1==("0") }'>

			                                    <td width="30"> </td>
			                                    <td  width="125"><spring:message code='LABEL.D.D03.0019'/><!--사전부여휴가 잔여일수--></td>
			                                    <td >
			                                      <input type="text" name="P_REMAIN2" size="10" class="input04" value="<c:out value='${f:printNumFormat(ZKVRB1, 1) }' />" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
			                                    </td>
	                                		</c:if>


	                                  </c:when>
	                                  <c:otherwise>

	                                        <c:if test='${ !ZKVRB1==("0") }'>

			                                    <td width="60"> </td>
			                                    <td  width="95"><spring:message code='LABEL.D.D03.0020'/><!--사전부여휴가--></td>
			                                    <td >
			                                      <input type="text" name="P_REMAIN2" size="10" class="input04" value="<c:out value='${  f:printNumFormat(ZKVRB1, 1) }' />" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
			                                    </td>
		                                    </c:if>

	                                        <c:if test='${ !ZKVRB2==("0") }'>

			                                    <td width="60"> </td>
			                                    <td  width="95"><spring:message code='LABEL.D.D03.0021'/><!--선택적보상휴가--></td>
			                                    <td >
			                                      <input type="text" name="P_REMAIN3" size="10" class="input04" value="<c:out value='${  f:printNumFormat(ZKVRB2, 1) }' />" style="text-align:right" readonly> <spring:message code='LABEL.D.D03.0022'/><!--일-->
			                                    </td>

	                                		</c:if>

                                    </c:otherwise>
   	                                </c:choose>


					                  <th class="noBtBorder th02 " width=90px>
					                  		<spring:message code='LABEL.D.D03.0200'/><!-- Use rate(%) -->
					                	</th>
					                	<td class="noBtBorder">
					                		 <input class="noBorder" type="text" name="REMAINDAYS" size="4" value="${f:printNumFormat(dataRemain.ABWTG /  dataRemain.OCCUR * 100, 2 )}" />(
					                		 <input class="noBorder" type="text" name="ABWTG" size="4" value="${dataRemain.ABWTG}" />/
					                		 <input class="noBorder" type="text" name="OCCUR" size="4" value="${dataRemain.OCCUR}" />)
					                  </td>

	                                  </tr>
	                                </table>
	                              </td>
	                            </tr>
	                            <tr>
	                              <th  width="95"><spring:message code='LABEL.D.D12.0003'/><!--신청기간--></th>
	                              <td >
	                                <input type="text" name="APPL_FROM" value="<c:out value='${  f:printDate(data.APPL_FROM) }' />"
	                                	size="20" class="input04" readonly>
	                                		<spring:message code='LABEL.D.D19.0024'/><!--부터-->
	                                <!--// 경조금의 경우, 일시적으로 막음. 2004.7.14. mkbae.-->
	                                <c:choose>
	                                <c:when test='${ data.AWART==("0130")||data.AWART==("0370")  }'>
	                                		<input type="text" name="APPL_TO"   value="<c:out value='${  f:printDate(data.APPL_TO)   }' />"
	                                	size="20" class="input04" readonly>
	                                		<spring:message code='LABEL.D.D19.0025'/><!--까지-->
	                                </c:when>
	                                <c:otherwise>

			                                <input type="text" name="APPL_TO"   value="<c:out value='${  f:printDate(data.APPL_TO)   }' />"
			                                	size="20" class="input04" readonly>
	                                		<spring:message code='LABEL.D.D19.0025'/><!--까지-->
	                                		<c:out value='${ f:printNumFormat(data.PBEZ4, 0)  }' />
	                                		<spring:message code='LABEL.D.D03.0036'/><!-- 일간 -->
	                                </c:otherwise>
	                                </c:choose>

	                              </td>
	                            </tr>
	                            <tr id = "requestTime"><!--//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha-->
	                              <th  width="95"><spring:message code='LABEL.D.D03.0023'/><!--신청시간--></th>
	                              <td >
	                                <input type="text" name="BEGUZ" value="<c:out value='${ f:printTime(data.BEGUZ) }' />" size="20" class="input04" readonly>
	                                <spring:message code='LABEL.D.D19.0024'/><!--부터-->
	                                <input type="text" name="ENDUZ" value="<c:out value='${  f:printTime(data.ENDUZ) }' />" size="20" class="input04" readonly>
	                                <spring:message code='LABEL.D.D19.0025'/><!--까지-->
	                                 <c:out value='${ (data.BEGUZ == null ||  data.ENDUZ == null || data.BEGUZ == "" || data.ENDUZ == "" )? "": f:printNumFormat(f:getBetweenTime(data.BEGUZ, data.ENDUZ), 2) }' /> <spring:message code='LABEL.D.D07.0005'/><!-- 시간 -->
	                              </td>
	                            </tr>
	                            <tr>
	                              <th  width="95"><spring:message code='LABEL.D.D03.0035'/><!--휴가공제일수--></th>
	                              <td >
	                                <input type="text" name="DEDUCT_DATE" value="<c:out value='${  f:printNumFormat(data.DEDUCT_DATE, 1) }' />"
	                                size="20" class="input04" style="text-align:right" readonly>
	                                <spring:message code='LABEL.D.D03.0022'/><!--일-->
	                              </td>
	                            </tr>
	                          </table>
	                       </td>
	                    </tr>

				        <c:if test='${visible}'>
					        <tr>
					            <td>&nbsp;</td>
					        </tr>
		  					<tr>
		  						<th class="font01" style="padding-bottom:2px"> <spring:message code='LABEL.D.D03.0100'/><!-- 적요--></th>
		  				    </tr>
		  				    <tr>
					        	<td>
					        		<table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
		        					< % for (int i = 0; i < orgVcAppLineData.size(); i++) { %>
					                    < % AppLineData ald = (AppLineData) orgVcAppLineData.get(i); %>
					                    < % if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT==("")) { %>
					                    <tr>
					                       <td  width="95"><c:out value='${ald.APPL_ENAME}' /></td>
					                       <td ><c:out value='${ald.APPL_BIGO_TEXT}' /></td>
					                    </tr>
				                   		< % } // end if %>
		                			< % } // end for %>
		                			</table>
		                		</td>
		                	</tr>
	                	</c:if>

<%--
	                    <tr>
	            			<td>&nbsp;</td>
	          			</tr>
	 					<tr>
	 						<td class="font01" style="padding-bottom:2px"> <img src="<c:out value='${ g.image }' />ehr/icon_o.gif"> 결재정보</td>
	 					</tr>
	 					<tr>
	 						<td>
		                    <!--결재정보 테이블 시작-->
<!-- 		                    < %= AppUtil.getAppOrgDetail(orgVcAppLineData) %> -->
		                    <!--결재정보 테이블 끝-->
<!--
		                   </td>
								     </tr>
							</table>
 --%>
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

	</div>
    <div class="table">
            <table class="tableGeneral">

	            		<tr>
	            			<th width="95" ><spring:message code='LABEL.D.D03.0039'/><!--취소신청일--></th>
	                        <td ><c:out value='${ f:printDate(appdata.BEGDA)}' /></td>
	            		</tr>
	            		<tr>
	            			<th width="95" ><spring:message code='LABEL.D.D03.0007'/><!--취소사유--></th>
	                        <td >
	                        	<input type="text" id="CANC_REASON" name="CANC_REASON" value="<c:out value='${appdata.CANC_REASON }' />"
	                        	class="input04" size="100" maxlength="80" readonly>
	                        </td>
	            		</tr>


	      <c:if test='${ (avisible) }'>
	        <tr>
	            <td>&nbsp;</td>
	          </tr>
	        <tr>
	        	<th class="font01" style="padding-bottom:2px">  <spring:message code='LABEL.D.D03.0100'/><!-- 적요--></th>
	        </tr>
	        <tr>
	        	<td>
	        		<table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
		        	<%-- for (int i = 0; i < vcAppLineData.size(); i++) { %>
		                    < % AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
		                    < % if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT==("")) { %>
		                    <tr>
		                       <td  width="95"><c:out value='${ald.APPL_ENAME}' /></td>
		                       <td ><c:out value='${ald.APPL_BIGO_TEXT}' /></td>
		                    </tr>
		                    < % } // end if %>
	                < % } // end for --%>
	                </table>
	            </td>
	        </tr>
	      </c:if>


       </table>
       <!-- 컨텐츠 전체 테이블 끝-->
      </td>
      <!-- 컨텐츠 끝-->
   </tr>

     <tr>
        <td>&nbsp;</td>
     </tr>
</table>
<!-- 전체테이블 끝 -->
</div>
</div>

</tags-approval:cancel-layout>

</tags:layout>


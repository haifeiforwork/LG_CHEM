<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청 조회                                            */
/*   Program ID   : E19CongraDetail.jsp                                         */
/*   Description  : 경조금 신청 조회                                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-14  이승희                                          */
/*                  2005-02-24  윤정현                                          */
/*                  2012-04-23  [CSR ID:C20130304_83585] 경조금 쌀화환:0010 추가요청 */
/*                  2014-04-24  [CSR ID:C20140416_24713]  화환신청시 주문업체 정보추가    */
/*                  2014-04-24  [CSR ID:C20140416_24713]  화환신청시 0007 주문업체 정보추가 , 통상임금정보삭제 , 배송업체메일발송,sms추가,초기구분자 추가    */
/*                  2014-07-31  [CSR ID:2584987] HR Center 경조금 신청 화면 문구 수정                                            */
/*					 [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S							*/
/*					[CSR ID:3398245] 경조화환 복리후생 메뉴 추가   2017.06.30  eunha							*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="hris.G.rfc.G004CongraReasonRFC" %>
<%@ page import="hris.G.G004CongraReasonData" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.A04FamilyDetailData" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ include file="/web/common/commonProcess.jsp" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    E19CongcondData e19CongcondData = (E19CongcondData)request.getAttribute("e19CongcondData");
    String firstYn = (String)request.getAttribute("firstYn");  //C20140416_24713   신청에서 조회시 Y

    Vector E19CongcondData_opt = (new E19CongRelaRFC()).getCongRela(e19CongcondData.PERNR);
    Vector          vcA04FamilyData       = (Vector) request.getAttribute("vcA04FamilyData");   //신청대상자 상세정보

    A04FamilyDetailData A04FamilyData =(A04FamilyDetailData)Utils.indexOf(vcA04FamilyData, 0) ;

    Vector newOpt = new Vector();
    for( int i = 0 ; i < E19CongcondData_opt.size() ; i++ ){
        E19CongcondData old_data = (E19CongcondData)E19CongcondData_opt.get(i);
        if( e19CongcondData.CONG_CODE.equals(old_data.CONG_CODE) ){
            CodeEntity code_data = new CodeEntity();
            code_data.code = old_data.RELA_CODE ;
            code_data.value = old_data.RELA_NAME ;
            newOpt.addElement(code_data);
        }
    }
	//대상자정보  C20140416_24713
    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
    //근무지리스트
    Vector E19CongraGrubNumb_vt  = (new E19CongraGrubNumbRFC()).getGrupCode(user.companyCode,"010");
    String ZGRUP_NUMB_O_NM="";
    String ZGRUP_NUMB_R_NM="";
    for( int i = 0 ; i < E19CongraGrubNumb_vt.size() ; i++ ){
 	   E19CongGrupData  data = (E19CongGrupData)E19CongraGrubNumb_vt.get(i);
 	   if (e19CongcondData.ZGRUP_NUMB_O.equals( data.GRUP_NUMB)){
 		   ZGRUP_NUMB_O_NM=data.GRUP_NAME;
 	   }
 	   if (e19CongcondData.ZGRUP_NUMB_R.equals( data.GRUP_NUMB)){
 		   ZGRUP_NUMB_R_NM=data.GRUP_NAME;
 	   }
    }
    Vector E19CongcondData0020_vt  = (new E19CongCodeRFC()).getCongCode(user.companyCode, "");
    long dateLong =Long.parseLong(DataUtil.removeStructur(e19CongcondData.CONG_DATE, "-"));
    String dateCheck ="Y" ;
    if( dateLong < 20020101 ) {
        dateCheck = "N";
    }

    String Lifnr = e19CongcondData.LIFNR;
    try{
    	Lifnr = WebUtil.printOptionText((new E19CongLifnrRFC()).getLifnr(user.companyCode, e19CongcondData.PERNR, "1"), e19CongcondData.LIFNR );
    }catch(Exception e){
    	 Lifnr = e19CongcondData.LIFNR;
    }
    Vector e19CongFlowerInfoData_vt = (new E19CongraFlowerInfoRFC()).getFlowerInfoCode(e19CongcondData.CONG_CODE);

    String sCONG_DATE =DataUtil.delDateGubn(e19CongcondData.CONG_DATE );
    Vector G004CongraReason_vt  = (new G004CongraReasonRFC()).getCode( "ZREASON_CD");
    G004CongraReasonData  g004CongraReasonData = new G004CongraReasonData();
    for( int i = 0 ; i < G004CongraReason_vt.size() ; i++ ){
    	g004CongraReasonData = (G004CongraReasonData)G004CongraReason_vt.get(i);
     }
    String SIXTH_DATE             = (String)request.getAttribute("SIXTH_DATE");
    String check_SIXTH_DATE = DataUtil.delDateGubn(e19CongcondData.CONG_DATE );
    String WORK_YEAR_TEXT = WebUtil.printNum(e19CongcondData.WORK_YEAR)+"년"+WebUtil.printNum(e19CongcondData.WORK_MNTH) +"개월";
   //[CSR ID:3398245] 경조화환 복리후생 메뉴 추가 20170630 eunha start
    String isFlower = "N";
    if (e19CongcondData.CONG_CODE.equals("0007") || e19CongcondData.CONG_CODE.equals("0010")){
    	isFlower = "Y";
    }
  //[CSR ID:3398245] 경조화환 복리후생 메뉴 추가 20170630 eunha end

%>
<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="E19CongcondData0020_vt" value="<%=E19CongcondData0020_vt %>"/>
<c:set var="dateCheck" value="<%=dateCheck %>"/>
<c:set var="dateLong" value="<%=dateLong %>"/>
<c:set var="Lifnr" value="<%=Lifnr%>"/>
<c:set var="ZGRUP_NUMB_O_NM" value="<%=ZGRUP_NUMB_O_NM%>"/>
<c:set var="ZGRUP_NUMB_R_NM" value="<%=ZGRUP_NUMB_R_NM%>"/>
<c:set var="e19CongFlowerInfoData_vt" value="<%=e19CongFlowerInfoData_vt%>"/>
<c:set var="newOpt" value="<%=newOpt%>"/>
<c:set var="sCONG_DATE" value="<%=sCONG_DATE%>"/>
<c:set var="A04FamilyData" value="<%=A04FamilyData%>"/>
<c:set var="PERNR_Data" value="<%=PERNR_Data%>"/>
<c:set var="SIXTH_DATE" value="<%=SIXTH_DATE%>"/>
<c:set var="check_SIXTH_DATE" value="<%=check_SIXTH_DATE%>"/>
<c:set var="G004CongraReason_vt" value="<%=G004CongraReason_vt%>"/>
<c:set var="WORK_YEAR_TEXT" value="<%=WORK_YEAR_TEXT %>"/>
<c:set var="isFlower" value="<%=isFlower %>"/>





<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <%--[CSR ID:3398245] 경조화환 복리후생 메뉴 추가 20170630 eunha  --%>
    <tags-approval:detail-layout  titlePrefix ="COMMON.MENU.ESS_BE_CONG_${isFlower eq 'Y' ? 'FLOWER' : 'COND'}" updateUrl="${g.servlet}hris.E.E19Congra.E19CongraChangeSV">

        <tags:script>
            <script>
function first(){
 	if ("${e19CongcondData.CONG_CODE}"=="0007" && "${firstYn}"=="Y"  ){ //화환이고 신청후 첫  조회로 온경우
 		alert("<spring:message code='MSG.E.E19.0043' />"); //배송업체에 직접  [배송업체메일/SMS발송] 버튼을 클릭하여\n메일을 보내야 합니다
 	}
}

$(function() {
	first();
});


//onClick="MM_openBrWindow('E19ReportDetail.htm','','width=550,height=350')"
function MM_openBrWindow(theURL,winName,features) {//v2.0
    window.open(theURL,winName,features);
}
//CSR ID:C20140416_24713]  화환신청시 0007 주문업체 배송업체메일 SMS발송
function do_MailSend(){
    if( chk_APPR_STAT(1) && confirm("<spring:message code='MSG.E.E19.0044' />") ) { //주문 배송업체에 메일/SMS 발송하시겠습니까?
        document.form1.jobid.value = "mail";
        document.form1.AINF_SEQN.value = "${e19CongcondData.AINF_SEQN }";

        document.form1.target="ifHidden";
        document.form1.action = "${g.servlet}hris.E.E19Congra.E19CongraDetailSV";
        document.form1.method = "post";
        document.form1.submit();
    }
}


function goToList_pop() {

    var url= "${g.jsp}G/G004ApprovalCongra_pop.jsp?PERNR=${e19CongcondData.PERNR}&sortField=BEGDA&select=BEGDA";
    //var url = "/servlet/hris.E.E20Congra.E20CongraListSV_m"
    var win = window.open(url,"","width=830,height=480,left=365,top=70,scrollbars=yes");
    win.focus();
}
</script>
</tags:script>
<input type="hidden" name="SIXTH_DATE" value=""><!--대상자회갑생년월일-->
<input type="hidden" name="PROOF">

				<div class="tableArea">
			      <div class="table">
           			<table class="tableGeneral">
            	<colgroup>
            		<col width="15%" />
            		<col width="35%" />
            		<col width="15%" />
            		<col width="35%" />
            	</colgroup>
                      <tr>
                        <th><spring:message code='LABEL.E.E20.0002' /><!-- 경조내역 --></th>
                        <td>
                          <select name="CONG_CODE" disabled>
                            <option value="">-------------</option>
                            <!-- 경조내역 option -->
                            ${f:printCodeOption( E19CongcondData0020_vt , e19CongcondData.CONG_CODE) }
                            <!-- 경조내역 option -->
                          </select>
                        </td>
                        <th class="th02" ><spring:message code='LABEL.E.E20.0003' /><!-- 경조대상자 관계 --></th>
                        <td>
                          <select name="RELA_CODE" disabled>
                            <option value="">-------------</option>
                            <!-- 경조대상 관계 option -->
                             ${f:printCodeOption( newOpt , e19CongcondData.RELA_CODE) }
                            <!-- 경조대상 관계 option -->
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <th><spring:message code='LABEL.E.E19.0029' /><!-- 경조대상자 성명 --></th>

                        <c:choose>
                        <c:when test="${approvalHeader.editManagerArea}">
                        <td>${e19CongcondData.EREL_NAME }
                        <c:if  test="${!empty e19CongcondData.REGNO }">
                        [${fn:substring(e19CongcondData.REGNO,0,6)}-*******]
                        </c:if>
                        <input type="hidden" name="EREL_NAME" value="${e19CongcondData.EREL_NAME }" size="16" readonly>
                        </td>
                        </c:when>
                        <c:otherwise>
                        <td><input type="text" name="EREL_NAME" value="${e19CongcondData.EREL_NAME }" size="16" readonly></td>
                        </c:otherwise>
                        </c:choose>
                      	<th class="th02"><spring:message code='LABEL.E.E19.0030' /><!-- 경조발생일자 --></th>
                      	<td><input type="text" name="CONG_DATE" value="${f:printDate(e19CongcondData.CONG_DATE)}"  size="16" readonly></td>
                      </tr>
                    </table>
				</div>
			</div>


<!--[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
	 화환의 경우와 같도록 쌀화환도 수정
  -->
  <c:choose>
  <c:when test="${e19CongcondData.CONG_CODE !=  '0007' and e19CongcondData.CONG_CODE != '0010'  }">

				<div class="tableArea">
			      <div class="table">
           			<table class="tableGeneral">

            	<colgroup>
            		<col width="15%" />
            		<col width="35%" />
            		<col width="15%" />
            		<col width="35%" />
            	</colgroup>

	<c:if test = "${user.empNo  eq  e19CongcondData.PERNR or app}">
                <tr>
                  <!--[CSR ID:2584987] 통상임금 -> 기준급  -->
                  <!-- <td width="100" class="td01">통상임금</td> -->
                  <th class="th02" ><spring:message code='LABEL.E.E20.0010' /><!-- 기준급 --></th>
               <td>

	  <c:choose>
	   	<c:when  test="${dateCheck eq  'Y'}" >
        	 <input type="text" name="WAGE_WONX" value="${f:printNumFormat(e19CongcondData.WAGE_WONX,0)}"  style="text-align:right" size="20" readonly> <spring:message code='LABEL.E.E19.0009' /><!-- 원 -->
		</c:when>
		<c:otherwise>
			<input type="text" name="WAGE_WONX" value="" style="text-align:right" size="20" readonly>
		</c:otherwise>
	 </c:choose>
               </td>
                  <th class="th02"><spring:message code='LABEL.E.E20.0011' /><!-- 지급율 --></th>
                  <td>
                    <input type="text" name="CONG_RATE" value="${e19CongcondData.CONG_RATE } " style="text-align:right"  size="20" readonly> %
                  </td>
                </tr>
                <tr>
                  <th><spring:message code='LABEL.E.E20.0006' /><!-- 경조금액 --></th>
                  <td colspan="3">
	  				<c:choose>
	   					<c:when  test="${dateCheck eq  'Y'}" >
        	 				<input type="text" name="CONG_WONX" value="${f:printNumFormat(e19CongcondData.CONG_WONX,0)}" style="text-align:right" size="20" readonly> <spring:message code='LABEL.E.E19.0009' /><!-- 원 -->
						</c:when>
						<c:otherwise>
							<input type="text" name="CONG_WONX" value="" style="text-align:right" size="30" readonly>
						</c:otherwise>
	 				</c:choose>
	 			  </td>
	 			</tr>
	          </c:if>
                <tr>
                  <th><spring:message code='LABEL.E.E20.0012' /><!-- 이체은행명 --></th>
                  <td >
                    <input type="text" name="BANK_NAME" value="${e19CongcondData.BANK_NAME}" size="20" readonly>
                  </td>
                  <th class="th02" ><spring:message code='LABEL.E.E20.0013' /><!-- 은행계좌번호 --></th>
                  <td >
                    <input type="text" name="BANKN" value="${e19CongcondData.BANKN}" size="20" readonly>
                  </td>
                </tr>
                <tr>
                  <th><spring:message code='LABEL.E.E20.0014' /><!-- 경조휴가일수 --></th>
                  <td>
	  			<c:choose>
	   				<c:when  test="${e19CongcondData.CONG_CODE eq  '0003' and (e19CongcondData.RELA_CODE eq '0002' or e19CongcondData.RELA_CODE  eq '0003')}" >
        	 			<input type="text" name="HOLI_CONT" value="Help 참조" style="text-align:left" size="20"  readonly>
					</c:when>
					<c:otherwise>
			 			<input type="text" name="HOLI_CONT" value="${e19CongcondData.HOLI_CONT eq '' ? '' : f:printNum(e19CongcondData.HOLI_CONT) }" style="text-align:right" size="20" readonly> <spring:message code='LABEL.E.E20.0016' /><!-- 일 -->
					</c:otherwise>
	 			</c:choose>
                  </td>
                  <th class="th02"><spring:message code='LABEL.E.E20.0015' /><!-- 근속년수 --></th>
                  <td>
                    <input type="text" name="WORK_YEAR" value="${f:printDate(e19CongcondData.WORK_YEAR) }" style="text-align:right" size="7" readonly> <spring:message code='LABEL.E.E20.0017' /><!-- 년 -->
                    <input type="text" name="WORK_MNTH" value="${f:printDate(e19CongcondData.WORK_MNTH) }" style="text-align:right" size="7" readonly> <spring:message code='LABEL.E.E20.0018' /><!-- 개월 -->
                  </td>
                </tr>
                <c:if test="${approvalHeader.ACCPFL eq 'X'}">
                <tr>
                    <th><!--@v2.0증빙유무확인--><spring:message code='LABEL.E.E19.0047' /><!-- 사실여부확인 --></th>
                        <tags:script>
                            <script>
                            function beforeAccept()
                            {
                                var frm = document.form1;
                                //@v2.1 CSR ID:1299570 회갑 로직체크

                                //주민번호를 생년월일로 변경
                                var CheckYy = "${empty A04FamilyData.FGBDT ? '':  fn:substring(A04FamilyData.FGBDT,0,4)}";
                                var CheckMm = "${empty A04FamilyData.FGBDT ? '':  fn:substring(A04FamilyData.FGBDT,5,7)}";
                                var CheckDd = "${empty A04FamilyData.FGBDT ? '':  fn:substring(A04FamilyData.FGBDT,8,10)}";

                                document.form1.CONG_WONX.value = removeComma(document.form1.CONG_WONX.value);   // 경조금액의 콤마를 없앤다.
                                document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value); //@v1.4

                                var CheckYear =   (parseInt(CheckYy)+60) ;
                                var CheckYMDB =  f_getDateAdd((parseInt(CheckYy)+60),CheckMm,CheckDd,-30,"") ;
                                var CheckYMDA =  f_getDateAdd((parseInt(CheckYy)+60),CheckMm,CheckDd,+30,"") ;
                                frm.SIXTH_DATE.value = (parseInt(CheckYy)+60)+CheckMm+CheckDd;


                                if ( "${e19CongcondData.CONG_CODE}" == "0002" && "${e19CongcondData.REGNO}" != "" && ("${check_SIXTH_DATE}"  != "${SIXTH_DATE}"  ) ) {
                                       if ( frm.REASON_CD.value == "" ) {
                                           //alert("회갑경조일차이사유를 입력하세요");
                                           alert("<spring:message code='MSG.E.E19.0059' />");
                                           document.form1.REASON_CD.focus();
                                           return;
                                       }
                                       $("#-accept-info").text("<spring:message code='MSG.E.E19.0061' />");
                                       //$("#-accept-info").text("경조발생일이 주민등록번호상 생년월일과 차이가 있으므로\n결재자께서는 사실 확인을 하여, 확인내용을 [적요]란에 상세히 기재 바랍니다.\n※ 기재내용을 기준으로 경조금 Data Monitoring을 실시\n하오니 정확한 확인 및 기재 부탁드립니다.");

                                       frm.REASON_TEXT.value=frm.REASON_CD[frm.REASON_CD.selectedIndex].text;
                                   }

                                //조위:0003 주민번호 뒷자리가 1이면서 백숙부상  임직원의 姓과 차이 있는 경우
                                if ( "${e19CongcondData.CONG_CODE}" == "0003" && "${fn:substring(PERNR_Data.e_REGNO,6,7)}" == "1" &&  "${fn:substring(PERNR_Data.e_ENAME,0,fn:length(A04FamilyData.LNMHG))}"  != "${A04FamilyData.LNMHG}"  ) {
                                     var msg1="<spring:message code='MSG.E.E19.0045' />"; //백숙부모상은 본인기준 큰아버지, 큰어머니, 작은아버지, 작은어머니만 해당되며, 그외 가족(외숙부모등)은 신청 불가합니다\n대상조건에 맞음을 확인하셨으면 결재를 진행 하시겠습니까?

                                     if(!confirm(msg1)) {
                                         return;
                                     }
                                }
                                if(!frm.chPROOF.checked) {
                                    //@v2.0
	   							 if ( "${e19CongcondData.CONG_CODE}" == "0002" && "${e19CongcondData.REGNO}" != "" && ("${check_SIXTH_DATE}"  != "${SIXTH_DATE}"  ) ) {
	        						//alert("회갑 대상자의 주민등록상 생일과 경조일자가 상이하므로 증빙 등을 통해 사실 관계를 확인 후에 결재하여 지급하시기 바랍니다.");
	   								alert("<spring:message code='MSG.E.E19.0060' />");
            					}else{
            						alert("<spring:message code='MSG.E.E19.0048' />");  //사실여부를 확인하세요
            					}

                                    //alert("중빙유무를 확인하세요");
                                    return;
                                } else {
                                    frm.PROOF.value = frm.chPROOF.value;
                                } // end if

                            		return true;
                            }

                            function beforeReject() {
                                $("#-accept-info").text("");
                                return true;
                            }
                            </script>
                          </tags:script>

                    <td><input name="chPROOF" type="checkbox" value="X"></td>
                    <td><!--[CSR ID:1225704]@v2.0-->
                        	<a class="inlineBtn" href="javascript:goToList_pop()"><span><spring:message code='LABEL.E.E19.0048' /><!-- 경조지원현황 --></span></a>
                    </td>
                   <td>&nbsp;</td>
                   </tr>
			<c:choose>
				<c:when test="${e19CongcondData.CONG_CODE eq '0002' and   SIXTH_DATE ne check_SIXTH_DATE}" >
                      <tr id="Reason">
                        <th ><span class="textPink">*</span><spring:message code='LABEL.E.E19.0061' /><!-- 회갑경조일차이사유 --></th>
                        <td  colspan=3>
                             <select name="REASON_CD" class="input03">
                              <option value="">-------------</option>
                     <c:forEach var="row" items="${G004CongraReason_vt}" varStatus="status">
                      <option value="${row.DOMVALUE }" <c:if  test="${ e19CongcondData.REASON_CD eq  row.DOMVALUE }" >
					     selected disabled </c:if>  > ${row.DDTEXT}</option>
                    </c:forEach>
                             </select>
                         </td>
                       </tr>
   							<input type=hidden name="REASON_TEXT" value="">
   							<input type=hidden name="RELA_TEXT" value="${f:printOptionValueText(newOpt,e19CongcondData.RELA_CODE)}">
   							<input type=hidden name="WORK_YEAR_TEXT" value="${WORK_YEAR_TEXT}">
 				</c:when>
 				<c:otherwise>
   							<input type=hidden name="RELA_TEXT" value="${f:printOptionValueText(newOpt,e19CongcondData.RELA_CODE)}">
   							<input type=hidden name="REASON_CD" value="">
   							<input type=hidden name="REASON_TEXT" value="">
   							<input type=hidden name="WORK_YEAR_TEXT" value="${WORK_YEAR_TEXT}">
				</c:otherwise>
		</c:choose>
               </c:if>

               <c:if test="${approvalHeader.showManagerArea and approvalHeader.ACCPFL ne 'X'}">
                  <tr>
                    <th><!--@v2.0증빙유무확인--><spring:message code='LABEL.E.E19.0047' /><!-- 사실여부확인 --></th>
                    <td <c:if  test="${ !approvalHeader.finish }" >
					     colspan="3"
					    </c:if>
					   >
                        <input name="chPROOF" type="checkbox" value="X"  <c:if  test="${ e19CongcondData.PROOF eq  'X' }" >
					     checked
					    </c:if>
					   disabled>
                         </td>
                      <c:if test="${approvalHeader.finish}">
                      <c:if  test="${e19CongcondData.CONG_CODE != '0007' and  e19CongcondData.CONG_CODE != '0010'   }" >
                        <th class="th02"><spring:message code='LABEL.E.E19.0049' /><!-- 회계전표번호 --></th>
                        <td colspan="3">${ e19CongcondData.BELNR}</td>
                      </c:if>
                      </c:if>
                    </tr>
				</c:if>




                <c:if test="${user.e_representative eq 'Y' and  (e19CongcondData.CONG_CODE eq '0007'  or  e19CongcondData.CONG_CODE eq '0010')}">
                <tr>
                  <th><spring:message code='LABEL.E.E19.0031' /><!-- 부서계좌번호 --></th>
                  <td colspan="3">
                    <input type="text" name="LIFNR" value="${Lifnr }" size="20" readonly>
                  </td>
                </tr>
                </c:if>
              </table>
              </div>
             </div>

	</c:when>  <%--C20140416_24713 화환인경우 통상임금 이하부분 제거 start --%>
	<c:otherwise>
	<c:if test = "${user.empNo  eq  e19CongcondData.PERNR or app}">
		<input type="hidden" name="CONG_WONX" value="${f:printNumFormat(e19CongcondData.CONG_WONX,0)}" >
		<input type="hidden" name="WAGE_WONX" value="${f:printNumFormat(e19CongcondData.WAGE_WONX,0)}" >
</c:if>
	</c:otherwise>
	</c:choose>


	<c:if test="${e19CongcondData.CONG_CODE eq '0007' or  e19CongcondData.CONG_CODE eq '0010'}"> <%-- C20140416_24713 화환인경우만 주문정보 조회  start --%>
    <h2 class="subtitle"><spring:message code='LABEL.E.E19.0032' /><!-- 주문자 정보 --></h2>
    <div class="tableArea"  id="jumunINFO">
        <div class="table">
            <table class="tableGeneral">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
            <tr>

	                <tr>
	                  <th><spring:message code='LABEL.E.E19.0033' /><!-- 신청자 --></th>
	                  <td >${e19CongcondData.ZUNAME2}
	            	<input type="hidden" name="ZPERNR2"   value="${e19CongcondData.ZPERNR2 }"> <!-- 신청자사번 -->
	            	<input type="hidden" name="ZUNAME2"   value="${e19CongcondData.ZUNAME2 }"> <!-- 신청자사번 -->
	            	<input type="hidden" name="ZGRUP_NUMB_O"   value="${e19CongcondData.ZGRUP_NUMB_O  }"><!-- 신청자근무지코드 -->
	                  </td>
	                  <th class="th02" ><spring:message code='LABEL.E.E19.0034' /><!-- 근무지명 --></th>
	                  <td >${ZGRUP_NUMB_O_NM}</td>
	                </tr>
	                 <tr>
	                  <th><spring:message code='LABEL.E.E18.0030' /><!-- 전화번호 --></th>
	                  <td><input type="text" name="ZPHONE_NUM" value="${e19CongcondData.ZPHONE_NUM}" size="20" maxsize=20 style="text-align:left" readonly></td>
	                  <th class="th02"><spring:message code='LABEL.E.E19.0035' /><!-- 핸드폰 --><font color="#006699"><b>*</b></font></th>
	                  <td><input type="text" name="ZCELL_NUM" value="${e19CongcondData.ZCELL_NUM}"  size="20" maxsize=20 style="text-align:left" readonly></td>
	                </tr>
	 			</table>
	 		</div>
	 	</div>
    <h2 class="subtitle"><spring:message code='LABEL.E.E19.0036' /><!-- 배송정보 --></h2>
    <div class="tableArea"  id="jumunINFO">
        <div class="table">
            <table class="tableGeneral">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
	                <tr>
	                  <th><spring:message code='LABEL.E.E19.0037' /><!-- 대상자(직원명) --></th>
	                  <td >${PERNR_Data.e_ENAME }
	                            <input type="hidden" name="ZUNAME_R"   value="${e19CongcondData.ZUNAME_R }"><!-- 대상자(직원명) -->
            					<input type="hidden" name="ZUNION_FLAG"   value="${e19CongcondData.ZUNION_FLAG }"><!-- 대상자(조합원) -->

	                  </td>
	                  <th class="th02"><spring:message code='LABEL.E.E19.0038' /><!-- 대상자 연락처 --><font color="#006699"><b>*</b></font></th>
	                  <td ><input type="text" name="ZCELL_NUM_R" value="${e19CongcondData.ZCELL_NUM_R  }" class="input04" size="20" maxsize=20 style="text-align:left" readonly>
	                  </td>
	                </tr>
	                <tr>
	                  <th><spring:message code='LABEL.E.E19.0039' /><!-- 근무지 --><font color="#006699"><b>*</b></font></th>
	                  <td> ${ZGRUP_NUMB_R_NM }</td>
	                  <th class="th02"><spring:message code='LABEL.E.E19.0040' /><!-- 대상자 부서 --></th>
	                  <td> ${PERNR_Data.e_ORGTX}</td>
	                </tr>
	                <%--
	                <tr>
	                  <td class="td01">신분</td>
	                  <td class="td09" colspan=3>${PERNR_Data.e_PTEXT} ${e19CongcondData.ZUNION_FLAG.equals("X") ? "조합원:Y" : "" }
	                  </td>
	                </tr>
	                --%>
	                <tr>
	                  <th><spring:message code='LABEL.E.E19.0041' /><!-- 배송일자 --><font color="#006699"><b>*</b></font></th>
	                  <td colspan=3>${f:printDate(e19CongcondData.ZTRANS_DATE)} &nbsp; &nbsp;
						                  ${f:printTime(e19CongcondData.ZTRANS_TIME)}

	                  </td>
	                </tr>
	                <tr>
	                  <th><spring:message code='LABEL.E.E19.0042' /><!-- 배송지주소 --><font color="#006699"><b>*</b></font></th>
	                  <td colspan=3><input type="text" name="ZTRANS_ADDR" value="${e19CongcondData.ZTRANS_ADDR }" size="80"  maxsize="100" style="text-align:left" readonly></td>
	                </tr>
	                <tr>
	                  <th><spring:message code='LABEL.E.E19.0043' /><!-- 기타 요구사항 --></th>
	                  <td colspan=3><input type="text" name="ZTRANS_ETC" value="${e19CongcondData.ZTRANS_ETC }" size="80" maxsize="100"  style="text-align:left" readonly></td>
	                </tr>
	              </table>
              </div>
             </div>
    <h2 class="subtitle"><spring:message code='LABEL.E.E19.0044' /><!-- 업체정보 --></h2>
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>

                <c:forEach var="row" items="${e19CongFlowerInfoData_vt}" varStatus="status">
                	<c:if test= "${status.index ==0}">
                	        <input type="hidden" name="ZTRANS_SEQ"   value="${row.ZTRANS_SEQ }"><!--업체 SEQ-->
            				<input type="hidden" name="ZTRANS_PSEQ"   value="${row.ZTRANS_PSEQ }"><!--담당자 SEQ-->
                			<tr>
                  			<th><spring:message code='LABEL.E.E19.0045' /><!-- 업체명 --></th>
                  			<td >${row.ZTRANS_NAME }</td>
                  			<th class="th02" ><spring:message code='LABEL.E.E20.0025' /><!-- 주소 --></th>
                  			<td >${row.ZTRANS_ADDR }</td>
                			</tr>

                <!-- [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
                	  for문 밖의 <tr>을 for문 안으로 넣음
                 -->
                <tr>
                  <th><spring:message code='LABEL.E.E19.0046' /><!-- 담당자 --></th>
                  <td>${row.ZTRANS_UNAME }</td>
                  <th class="th02"><spring:message code='LABEL.E.E26.0005' /><!-- 연락처 --></th>
                  <td>T e l : ${row.ZPHONE_NUM  }
                  <BR>H .P : ${row.ZCELL_NUM  }
                  <!-- [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
                  		비어있던 팩스란을 빼버림
                  <BR>FAX : ${row.ZFAX_NUM  }
                  -->
                   </td>
                </tr>
                </c:if>
				</c:forEach>

              </table>
           </div>
		</div>
            <!-- C20140416_24713 주문업체정보 END -->

</c:if> <%--C20140416_24713 화환인경우만 주문정보 조회  start --%>

    </tags-approval:detail-layout>
</tags:layout>
<iframe name="ifHidden" width="0" height="0" /></iframe>
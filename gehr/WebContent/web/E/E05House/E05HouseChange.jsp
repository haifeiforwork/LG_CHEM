<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 신규신청                                           */
/*   Program Name : 주택자금 신규신청 수정                                      */
/*   Program ID   : E05HouseChange.jsp                                          */
/*   Description  : 주택자금 신청을 수정할 수 있도록 하는 화면                  */
/*   Note         :                                                             */
/*   Creation     : 2001-12-13  김성일                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                  2012-04-26  lsa [CSR ID:2097388] 주택자금 신규신청 화면 은행코드 추가 요청 */
/*                  2013-04-18  lsa [CSR ID:C20130416_12646]  신용보증선택규제제거  */
/*                  2013-06-25  lsa C20130625_56559  차액지원 임차도 가능하게 처리  */
/*                   2016-05-27  김불휘S [CSR ID:C20160526_74869] 주택자금 신청화면 문구 추가 요청  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ page import="hris.E.E05House.E05HouseData" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    //E05PersInfoData E05PersInfoData    = (E05PersInfoData)request.getAttribute("E05PersInfoData");
    Vector          PersLoanData_vt    = (Vector)request.getAttribute("PersLoanData_vt");
    E05HouseData e05HouseData  = (E05HouseData)request.getAttribute("e05HouseData");
    String          E_WERKS            = (String)request.getAttribute("E_WERKS");

    String RequestPageName = (String)request.getAttribute("RequestPageName");

    String requ_mony = ""+( Double.parseDouble(e05HouseData.REQU_MONY)*100 ) ;

    //※ 진행중인건 대출금액목록[C20110808_41085]
    //Vector  IngPersLoanData_vt    = (Vector)request.getAttribute("IngPersLoanData_vt");
    //String          FLAG          = (String)request.getAttribute("FLAG");
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="requ_mony" value="<%=requ_mony%>" />
<c:set var="PersLoanDataSize" value="<%=PersLoanData_vt.size()%>" />
<c:set var="userCompanyCode" value="<%=user.companyCode%>" />
<c:set var="requ_mony" value="<%=requ_mony%>" />


<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_TUTI_FEE">
<tags:script>
	<script>

	<!--
	/****** 원화일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWon(this);" *******/
	function moneyChkEventForWon(obj){
	    val = obj.value;
	    if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
	        addComma(obj);
	    }
	    /*C2004021001000000943. mkbae. 신청금액이 퇴직금의 1/2 이하일 경우, 신용보증 보이게함.*/
	    //if(< %=user.companyCode.equals("C100")%>){
	    //    requ_money = removeComma(document.form1.requmony.value);
	    //    if( requ_money > < %= data.GRNT_RSGN%>/2 ) {
	    //        document.form1.ZZSECU_FLAG[0].checked = true;
	    //        credit.style.display = "none";
	    //    } else {
	    //        credit.style.display = "block";
	    //    }
	    //}
	    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
	}
	/**************************************************************** 문의 :  김성일 ****/

	//function doSubmit() {
	function beforeSubmit() {
	    if( check_data() ) {
	        document.form1.BEGDA.value     =  removePoint(document.form1.BEGDA.value); //changeChar( document.form1.fromdate.value, ".", "" );
	        document.form1.REQU_MONY.value = removeComma(document.form1.REQUMONY.value);
	        document.form1.REQU_MONY.value = document.form1.REQU_MONY.value/100;

	        return true;

	    }
	}

	function check_data(){
	    //begdate = removePoint(document.form1.BEGDA.value);
	    //document.form1.BEGDA.value = begdate;
	    var years = document.form1.E_YEARS.value;
	    var loantype = document.form1.DLART.value;
	    var validText = "";
	    if( loantype == "" ) {
	    	validText = "<spring:message code='LABEL.E.E05.0001' />";
           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("주택융자유형을 선택하세요.");
	        document.form1.DLART.focus();
	        return false;
	    }

	    if( document.form1.BANK_CODE.value == "" ) { //@v1.0
	    	validText = "<spring:message code='LABEL.E.E05.0004' />";
           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("신청은행을 선택하세요.");
	        document.form1.BANK_CODE.focus();
	        return false;
	    }
	    count = document.form1.loantypecount.value;
	    requ_money = removeComma(document.form1.requmony.value);

	    if( document.form1.requmony.value == "") {

	    	validText = "<spring:message code='LABEL.E.E05.0005' />";
       		alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //신청금액을
	    	document.form1.requmony.focus();
	        return false;
	    }

	    check_zero = document.form1.requmony.value
	    if( check_zero <= 0 ) {
	    	alert("<spring:message code='MSG.E.E05.0008' />"); // alert("신청금액은 0 원보다 커야합니다.");
	        return;
	    }

	    max_money = max_amount(loantype);

	    if( requ_money > max_money ) {
	        comma_money = insertComma(max_money+"");
	        if (document.form1.ingcount.value > 0){
	        	alert("<spring:message code='MSG.E.E05.0009' arguments='"+ comma_money +"' />");
	        	//alert("신청진행중 금액도 기대출금액으로 환산하여 \n신청 가능금액은 " + comma_money + "원이하 입니다."); //  MSG.E.E05.0009
	        }else{
	        	alert("<spring:message code='MSG.E.E05.0010' arguments='"+ comma_money +"' />");
	        	//alert("신청금액이 너무 많습니다.\n신청 가능금액은 " + comma_money + "원이하 입니다."); // MSG.E.E05.0010
	        }
	        return false;
	    }

	    if( document.form1.ZZFUND_CODE.value == "" ) {
	    	validText = "<spring:message code='LABEL.E.E05.0006' />";
       		alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("자금용도를 선택하세요.");
	        document.form1.ZZFUND_CODE.focus();
	        return false;
	    }

	    for (var i = 0; i < document.form1.ZZSECU_FLAG.length ; i++) {
	        if (document.form1.ZZSECU_FLAG[i].checked == true){
	            document.form1.ZZSECU_FLAG.value = document.form1.ZZSECU_FLAG[i].value;
	        }
	    }
	    document.form1.REQUMONY.value = requ_money;

	    return true;
	}

	function max_amount(loantype) {
	    count = document.form1.loantypecount.value;
	    oldcount = document.form1.oldcount.value;
	    max_money = 0;
	    old_money = 0;

	    for( i = 0; i < count; i++) {
	        loancode = eval("document.form1.LOAN_CODE" + i + ".value");

	        if( (loancode == loantype) ){
	            max_money = parseFloat(eval("document.form1.LOAN_MONY" + i + ".value"));
	        }
	    }

	    <c:choose>
		<c:when test="${userCompanyCode eq 'C900' }">

		if( loantype == "0010" ) {
            for( i = 0; i < oldcount; i++) {
                loancode = eval("document.form1.OLD_DLART" + i + ".value");

                <c:choose>
				<c:when test="${E_WERKS eq 'BA00' }">

				old_money = old_money + parseFloat(eval("document.form1.OLD_DARBT" + i + ".value"));

				</c:when>
				<c:otherwise>
					  if( (loancode == "0020") ){
	                      old_money = parseFloat(eval("document.form1.OLD_DARBT" + i + ".value"));
	                  }

				</c:otherwise>
				</c:choose>

            }
            max_money = max_money - old_money;
        }
		</c:when>

		<c:when test="${userCompanyCode eq 'C100' }">

		 if( loantype == "0020" ) {
	            for( i = 0; i < oldcount; i++) {
	                loancode = eval("document.form1.OLD_DLART" + i + ".value");
	                old_money = old_money + parseFloat(eval("document.form1.OLD_DARBT" + i + ".value"));
	            }
	            max_money = max_money - old_money;
	        } else if( loantype == "0010" ) {
	            for( i = 0; i < oldcount; i++) {
	                loancode = eval("document.form1.OLD_DLART" + i + ".value");
	                old_money = old_money + parseFloat(eval("document.form1.OLD_DARBT" + i + ".value"));
	            }
	            max_money = max_money - old_money;
	        }

	        //※ 진행중인건 대출금액목록[C20110808_41085]
	        ING_money = 0; //신청진행중인 금액
	        if( loantype == "0010" || loantype == "0020" ) {
	            for( i = 0; i < document.form1.ingcount.value; i++) {
	                loancode = eval("document.form1.ING_DLART" + i + ".value");
	                ING_money = ING_money + parseFloat(eval("document.form1.ING_DARBT" + i + ".value"));
	            }
	            max_money = max_money - ING_money;
	        }

		</c:when>

		</c:choose>

	    //수정화면에서의 한도체크시 현재 신청한 금액을 포함해준다.
	    curr_money = "${requ_mony}"; //< %=Double.parseDouble(E05HouseData.REQU_MONY)*100%>;
	    max_money = max_money + parseFloat(curr_money);

	    if(max_money < 0) {
	        max_money = 0;
	    }
	    return max_money;
	}

	function set_LoanMony(obj){
	    val = obj[obj.selectedIndex].value;


	//  전세자금을 대출받은 상태에서 전세자금을 신청할경우 - 신청 못함(LG화학)
	<c:if test="${userCompanyCode eq 'C100' }">

	    /* 장치공장의 경우, 대출종료일 이전에 신청불가. 2005.4.22 mkbae */
	    //if( val == "0010"&& < %=user.e_werks.equals("BA00")%>) {
	    if( val == "0010" ) {
	        oldcount = document.form1.oldcount.value;
	        for( i = 0; i < oldcount; i++) {
	            loancode = eval("document.form1.OLD_DLART" + i + ".value");
	            l_endda  = eval("document.form1.OLD_ENDDA" + i + ".value");
	            // 2011.07.28:기존 대출 상환없이  구입차액대출 추가 신청
	            //if( loancode == "0010" && < %=DataUtil.getCurrentDate()%> < changeChar(l_endda,"-","") ){
	            //    alert("주택자금 대출종료일 이전입니다.");
	            //    document.form1.requmony.value = "";
	            //    obj.options[0].selected = true;
	            //    return;
	            //}
	        }
	    } else if( val == "0020" ) {
	        oldcount = document.form1.oldcount.value;
	        //C20130625_56559
	        //for( i = 0; i < oldcount; i++) {
	        //    loancode = eval("document.form1.OLD_DLART" + i + ".value");
	        //    if( (loancode == "0010") ){
	        //        alert("이미 주택자금 지원을 받으셨습니다.");
	        //        document.form1.requmony.value = "";
	        //        obj.options[0].selected = true;
	        //        return;
	        //    } else if( (loancode == "0020") ){
	        //        alert("이미 전세자금 지원을 받으셨습니다.");
	        //        document.form1.requmony.value = "";
	        //        obj.options[0].selected = true;
	        //        return;
	        //    }
	        //}
	    }

	    money = max_amount(val)
	    int_money = parseFloat(money);
	    /*C2004021001000000943. mkbae. 신청금액이 퇴직금의 1/2 이하일 경우, 신용보증 보이게함.*/
	    //if( money > < %= data.GRNT_RSGN%>/2 ) {
	    //  document.form1.ZZSECU_FLAG[0].checked = true;
	    //  credit.style.display = "none";
	    //  } else {
	    //  credit.style.display = "block";
	    //}
	    money = insertComma(int_money+"");
	    document.form1.requmony.value = money;
	    </c:if>

	}

	//CSR ID:1327268
	function zzfund_Change(obj) {

	    var val = obj[obj.selectedIndex].value;//DLART_CODE 값
	    var index =1;
	    document.form1.ZZFUND_CODE.length = 1;
	    document.form1.ZZFUND_CODE[0].value = "";
	    document.form1.ZZFUND_CODE[0].text  = "------------";

	    <c:forEach var="row" items="${E05FundCode_vt}" varStatus="inx">
		<c:set var="index" value="${inx.index}"/>
			if(   val=="${row.DLART}"   ) {
		        index++;
		        document.form1.ZZFUND_CODE.length = index;
		        document.form1.ZZFUND_CODE[index-1].value = "${row.FUND_CODE}";
		        document.form1.ZZFUND_CODE[index-1].text  = "${row.FUND_TEXT}";
		    }
		</c:forEach>

	}

	//-->

	</script>
</tags:script>

	<!-- 상단 입력 테이블 시작-->
	<%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>
	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
				<colgroup>
            		<col width="15%" />
            		<col width="30%" />
            		<col width="15%" />
            		<col width="" />
            	</colgroup>

				<tr>
                    <th><span class="textPink">*</span><!--주택융자유형--><spring:message code="LABEL.E.E05.0001" /></th>
                    <td colspan="3">
                    	<input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}"  />

                        <select name="DLART" style="width:135px;" onChange="javascript:set_LoanMony(this);zzfund_Change(this);">
                            <option value="" selected>------------</option>
                            ${f:printCodeOption(getLoanTypeList, resultData.DLART)}
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><!--현주소--><spring:message code="LABEL.E.E05.0002" /></th>
                    <td colspan="3"><input type="text" name="E_STRAS" size="105" value="<c:out value='${E05PersInfoData.e_STRAS}'/>" readonly></td>
                </tr>
                <tr>
                    <th><!--근속년수--><spring:message code="LABEL.E.E05.0003" /></th>
                    <td><input type="text" name="E_YEARS" size="18" value="<c:out value='${E05PersInfoData.e_YEARS}'/>" style="text-align:right" readonly /></td>
                    <th class="th02"><span class="textPink">*</span><!--신청은행--><spring:message code="LABEL.E.E05.0004" /></th>
                    <td>
                        <select name="BANK_CODE"  style="width:135px;">
                            <option value="">-------------</option>

                            <c:forEach var="row" items="${e05BankCodeData_vt}" varStatus="inx">
                         	<c:set var="index" value="${inx.index}"/>
                         	<option value="<c:out value='${row.BANK_CODE}'/>"  <c:if test = "${row.BANK_CODE eq resultData.BANK_CODE }" >selected</c:if>><c:out value='${row.BANK_NAME}'/></option>
							</c:forEach>

                        </select>
                    </td>
                </tr>

                <tr>
                    <th><span class="textPink">*</span><!--신청금액 --><spring:message code="LABEL.E.E05.0005" /></th>
                    <td>
                        <input type="hidden" name="REQU_MONY" value="">
                        <input type="hidden" name="REQUMONY" value="">
                        <input type="text" name="requmony" size="18" value="${f:printNumFormat( requ_mony, 0)}" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right">원
                    </td>
                    <th class="th02"><span class="textPink">*</span><!--자금용도--><spring:message code="LABEL.E.E05.0006" /></th>
                    <td>
                        <select name="ZZFUND_CODE" style="width:135px;">
                            <option value="">------------</option>
                            <c:forEach var="row" items="${E05FundCode_vt}" varStatus="inx">
							<c:set var="index" value="${inx.index}"/>
								<c:if test = "${resultData.DLART eq row.DLART }" >
									<option value="<c:out value='${row.FUND_CODE}'/>" <c:if test = "${resultData.ZZFUND_CODE eq row.FUND_CODE }" >selected</c:if> ><c:out value='${row.FUND_TEXT}'/></option>
								</c:if>
							</c:forEach>
                        </select>

                    </td>
                </tr>

                <tr>
                    <th><span class="textPink">*</span><!--보증여부--><spring:message code="LABEL.E.E05.0007" /></th>
                    <td colspan="3">
                        <div id=credit name=credit style="display:block">
                          <input type="radio" name="ZZSECU_FLAG" value="C" <c:if test="${resultData.ZZSECU_FLAG eq 'C' }">checked</c:if>>
                          <!--신용보증--><spring:message code="LABEL.E.E05.0008" /> </div>
                        <input type="radio" name="ZZSECU_FLAG" value="N"  <c:if test="${resultData.ZZSECU_FLAG eq 'N' }">checked</c:if>>
                        <!--보증보험가입희망--><spring:message code="LABEL.E.E05.0009" />

                          <!--[CSR ID:C20160526_74869] 주택자금 신청화면 문구 추가 요청건
                          <br> &nbsp;&nbsp;&nbsp; ( 보증보험가입희망 시 대출액에 따른 보증보험료를 본인이 추가 부담하여야 함 )-->
                          <!-- [CSR ID:3193136] 주택자금 신청화면 수정의 건 -->
                          <br> &nbsp; (<!--위 대출은 신용대출로 개인신용한도 등 별도 관리가 필요한 경우 보증보험 가입 문의 바람--><spring:message code="LABEL.E.E05.0018" /><br/>
                              &nbsp; <!--단, 보증보험가입희망 시 대출액에 따른 보증보험료를 본인이 추가 부담하여야 함--><spring:message code="LABEL.E.E05.0019" />)

                        <!--[CSR ID:1411665] 주택자금 신청화면 변경 요청건
                        <input type="radio" name="ZZSECU_FLAG" value="Y" < %= E05HouseData.ZZSECU_FLAG.equals("Y") ? "checked" : "" %> >
                        연대보증인 입보-->

                    </td>
                </tr>
                <!--[CSR ID:1411665] 주택자금 신청화면 변경 요청건-->
                <tr>
                    <th><span class="textPink">*</span><!--본인확인사항--><spring:message code="LABEL.E.E05.0014" /></th>
                    <td colspan="3">
                        <table>
                            <tr>
                                <td>
                                <!--본인은 신청일 현재 무주택자 임을 확인합니다.--><spring:message code="LABEL.E.E05.0011" /><br>
                                <!--상기 사항이 사실이 아닌 경우 규정에 따른 조치(대출액 환수 등)에 이의가 없음을 확인합니다.--><spring:message code="LABEL.E.E05.0012" />
                                </td>
                            </tr>

                            <tr>
                                <td><!--본인동의--><spring:message code="LABEL.E.E05.0013" /> :
                                <c:if test = "${resultData.ZCONF eq 'Y' }" ><!--예--><spring:message code="LABEL.E.E05.0015" /></c:if>
                                <c:if test = "${resultData.ZCONF eq 'N' }" ><!--아니오--><spring:message code="LABEL.E.E05.0016" /></c:if>
                        		<input type="hidden" name="ZCONF" value="<c:out value='${resultData.ZCONF}'/>" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

       		</table>
		</div><!-- end class="table" -->

		<div class="commentsMoreThan2">
        	<div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
        </div>
		<!-- 상단 입력 테이블 끝-->

		<!-- Hidden Field -->

		<input type="hidden" name="MANDT"     value="<c:out value='${resultData.MANDT}'/>">
	    <input type="hidden" name="PERNR"     value="<c:out value='${resultData.PERNR}'/>">
	    <input type="hidden" name="loantypecount" value="${fn:length(E05MaxMoneyData_vt) }">

		<c:forEach var="row" items="${E05MaxMoneyData_vt}" varStatus="inx">
		<c:set var="index" value="${inx.index}"/>
	        <input type="hidden" name="LOAN_CODE${index}" value='${row.LOAN_CODE}'>
	        <input type="hidden" name="LOAN_MONY${index}" value='${row.LOAN_MONY}' >
		</c:forEach>

		<input type="hidden" name="oldcount" value="${fn:length(PersLoanData_vt) }">

		<c:forEach var="row" items="${PersLoanData_vt}" varStatus="inx">
		<c:set var="index" value="${inx.index}"/>
	    <input type="hidden" name="OLD_DLART${index}" value='${row.DLART}'>
	    <input type="hidden" name="OLD_DARBT${index}" value='${f:printNum(row.DARBT) }' >
	    <input type="hidden" name="OLD_ENDDA${index}" value='${row.ENDDA}'>
	    </c:forEach>

<!-- //※ 진행중인건 대출금액목록[C20110808_41085]-->
        <input type="hidden" name="ingcount" value="${fn:length(IngPersLoanData_vt) }">

        <c:forEach var="row" items="${IngPersLoanData_vt}" varStatus="inx">
		<c:set var="index" value="${inx.index}"/>
	    <input type="hidden" name="ING_DLART${index}" value='${row.DLART}'>
	    <input type="hidden" name="ING_DARBT${index}" value='${f:printNum(row.DARBT) }>' >
	    </c:forEach>

	    <!-- Hidden Field -->

	</div>

</tags-approval:request-layout>
</tags:layout>

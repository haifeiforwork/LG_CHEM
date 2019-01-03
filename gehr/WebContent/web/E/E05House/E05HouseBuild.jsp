<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 신규신청                                           */
/*   Program Name : 주택자금 신규신청                                           */
/*   Program ID   : E05HouseBuild.jsp                                           */
/*   Description  : 주택자금 신청을 할수 있도록 하는 화면                       */
/*   Note         :                                                             */
/*   Creation     : 2001-12-13  김성일                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                  2008-09-11  lsa  CSR ID:1327268                             */
/*                  2012-04-26  lsa [CSR ID:2097388] 주택자금 신규신청 화면 은행코드 추가 요청 */
/*                  2013-04-18  lsa [CSR ID:C20130416_12646]  신용보증 선택규제제거  */
/*                  2013-06-11  lsa [CSR ID:C20130605_45075]  주택자금신규신청 "은행대출비교표" 삭제   */
/*                  2013-06-25  lsa C20130625_56559  신청 최소근속요건 1년으로 수정 ,차액지원 임차도 가능하게 처리  */
/*                  2014-05-16  이지은D  CSRID : 2545905 시간선택제 사무직>금액 조정하여 신청 가능, 계약직> 신청불가   */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/*                  2014-09-19  이지은D [CSR ID:2611199] 대산공장 복리후생>주택자금신규신청 제한 요청                  */
/*                   2015-04-16  이지은D [CSR ID:2753943] 고문실 복리후생 신청 권한 제한 요청  */
/*                  2016-05-19  이지은D [CSR ID:3059290] HR제도 팝업 관련 개선 요청의 건  */
/*                   2016-05-27  김불휘S [CSR ID:C20160526_74869] 주택자금 신청화면 문구 추가 요청  */
/*					  2017-11-06  eunha    [CSR ID:3523913] 주택자금 신청 화면 수정요청의 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="hris.common.PersonData" %>
<%@ page import="hris.E.E05House.E05PersInfoData" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    E05PersInfoData E05PersInfoData    = (E05PersInfoData)request.getAttribute("E05PersInfoData");
    Vector          E05MaxMoneyData_vt = (Vector)request.getAttribute("E05MaxMoneyData_vt");
    Vector          PersLoanData_vt    = (Vector)request.getAttribute("PersLoanData_vt");
    String          E_WERKS            = (String)request.getAttribute("E_WERKS");
    //D15RetirementSimulData data = (D15RetirementSimulData)request.getAttribute("R_GRNT_RSGN") ;
    String          FLAG            = (String)request.getAttribute("FLAG");

    String PERNR =  (String)request.getAttribute("PERNR");
    String E_BTRTL = (String)request.getAttribute("E_BTRTL");  //인사하위영역

    //※ 진행중인건 대출금액목록[C20110808_41085]
    //Vector  IngPersLoanData_vt = (Vector)request.getAttribute("IngPersLoanData_vt");
    PersonData PERNR_Data   = (PersonData)request.getAttribute("PersonData");

    //Logger.debug.println(this, "E05PersInfoData.E_YEARS  : "+ E05PersInfoData.E_YEARS);

    String    Msg = "";
    /*[CSR ID:3523913] 주택자금 신청 화면 수정요청의 건
   if ( E_BTRTL.equals("BACA") ) {  //[CSR ID:2611199]
        Msg = g.getMessage("MSG.E.E05.0003");//"해당 사업장은 주택자금 신청이 불가능합니다.  기타 문의는 대산.인사지원팀으로 문의하시기 바랍니다.";
    }*/

    if ( PERNR_Data.E_WERKS.equals("EC00") || PERNR_Data.E_WERKS.equals("EB00") ) {  //해외는 현지에서 지급하므로 웹신청막음
        Msg = g.getMessage("MSG.E.E05.0004");//"해외법인의 경우 해당 인사부서를 통해 신청하시기 바랍니다.";
    }

    if (!Msg.equals("") ||  FLAG.equals("Y") ) {                           //&&!user.e_werks.equals("BA00") ) { <-- 2005.05.30(KDS) : 지원 기준 변경사항 반영
        if ( FLAG.equals("Y") ) {
           Msg = g.getMessage("MSG.E.E05.0005");//"이미 주택자금을 대출 받으셨거나, 대출 가능금액이 0원입니다.";
        }
	    if ( Double.parseDouble(E05PersInfoData.E_YEARS) < 1 ) { //C20130625_56559
	       Msg = g.getMessage("MSG.E.E05.0006");//"융자신청 대상은 만 1년 이상 근속한 자로 신청일 현재 무주택인 임직원입니다.";
	    }
	    if ( PERNR_Data.E_PERSK.equals("36") ||  PERNR_Data.E_PERSK.equals("37") ||  PERNR_Data.E_PERSK.equals("43")) { //CSRID :2545905 시간선택제 계약직의 경우 신청 불가
	        Msg = g.getMessage("MSG.E.E05.0007");//"시간선택제 계약직의 경우 주택자금 신청이 불가합니다.";
	    }
    }

    String reqDisable = ""; //신청 불가 상태 확인.
    if ( !Msg.equals("") ){
    	reqDisable = "true";
    }

	//  [CSR ID:2753943] 고문실 복리후생 신청 권한 제한 요청 @20150415 계약직(자문/고문)의 경우 복리후생 쪽 신청이 불가하도록(건강보험피부양자, 건강보험재발급 빼고 다)
    if( user.e_persk.equals("14") ){
    	reqDisable = "true";
    }
    //Logger.debug.println( "reqDisable========"+ user.companyCode );
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="PERNR" value="<%=PERNR%>" />
<c:set var="reqDisable" value="<%=reqDisable%>" />
<c:set var="Msg" value="<%=Msg%>" />
<c:set var="PersLoanDataSize" value="<%=PersLoanData_vt.size()%>" />
<c:set var="userCompanyCode" value="<%=user.companyCode%>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_HOUS_FUND" disable="${reqDisable}">
	<tags:script>
	<script>

	//alert('aaaaa='+'${PersLoanDataSize}');
	// document.form1.fromdate    삭제

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
	        document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value); //changeChar( document.form1.fromdate.value, ".", "" );
	        document.form1.REQU_MONY.value = removeComma(document.form1.REQUMONY.value);
	        document.form1.REQU_MONY.value = document.form1.REQU_MONY.value/100;

	        return true;
	    }
	}

	function check_data(){

	   // begdate  = document.form1.fromdate.value
	    var years    = document.form1.E_YEARS.value;
	    var loantype = document.form1.DLART.value;
	    document.form1.BEGDA.value     = removePoint(document.form1.BEGDA.value);
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
	    if( document.form1.ZCONF[0].checked != true ) {
	    	alert("<spring:message code='MSG.E.E05.0011' />"); // alert("주택자금 대출 대상이 아니므로 신청이 되지 않습니다.");
	        return false;
	    }

	    for (var i = 0; i < document.form1.ZZSECU_FLAG.length ; i++) {
	        if (document.form1.ZZSECU_FLAG[i].checked == true){
	            document.form1.ZZSECU_FLAG.value = document.form1.ZZSECU_FLAG[i].value;
	        }
	    }
	    if( document.form1.ZZSECU_FLAG.value == "" ||document.form1.ZZSECU_FLAG.value == undefined) {
	    	validText = "<spring:message code='LABEL.E.E05.0007' />";
   			alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("보증여부가 선택되지 않습니다.");
	        return false;
	    }

	    document.form1.REQUMONY.value = requ_money;
	    return true;
	}
	function max_amount(loantype) {
	    var count = document.form1.loantypecount.value;
	    var oldcount = document.form1.oldcount.value;
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

	    if(max_money < 0) {
	        max_money = 0;
	    }
	    return max_money;
	}

	function set_LoanMony(obj){

		val = obj[obj.selectedIndex].value;

//  전세자금을 대출받은 상태에서 전세자금을 신청할경우 - 신청 못함(LG화학)
	<c:if test="${userCompanyCode eq 'C100' }">

	    money = max_amount(val);
	    /* 장치공장의 경우, 대출종료일 이전에 신청불가. 2005.4.22 mkbae */
	    //if( val == "0010"&& < %=user.e_werks.equals("BA00")%>) {
	    if( val == "0010" ) {
	        oldcount = document.form1.oldcount.value;
	        for( i = 0; i < oldcount; i++) {
	            loancode = eval("document.form1.OLD_DLART" + i + ".value");
	            l_endda  = eval("document.form1.OLD_ENDDA" + i + ".value");
	           // 2011.07.28:기존 대출 상환없이  구입차액대출 추가 신청
	            //if( loancode == "0010" && < %=DataUtil.getCurrentDate()%> < changeChar(l_endda,"-","") ){
	            //    //alert("주택자금 대출종료일 이전입니다.");
	            //    alert("기 대출금 잔액 상환완료 시 지원 가능합니다.");
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
	        //진행중인건도 체크
	        ingcount = document.form1.ingcount.value;
	        for( i = 0; i < ingcount; i++) {
	            loancode = eval("document.form1.ING_DLART" + i + ".value");
	            if( (loancode == "0020") ){
	            	alert("<spring:message code='MSG.E.E05.0012' />"); // alert("이미 전세자금 신청건이 있습니다.");
	                document.form1.requmony.value = "";
	                obj.options[0].selected = true;
	                return;
	            }
	        }

	    }

	    money = max_amount(val);
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
			if(   val=="${row.DLART}"      ) {
		        index++;
		        document.form1.ZZFUND_CODE.length = index;
		        document.form1.ZZFUND_CODE[index-1].value = "${row.FUND_CODE}";
		        document.form1.ZZFUND_CODE[index-1].text  = "${row.FUND_TEXT}";
		    }
		</c:forEach>
	}

	</script>
	</tags:script>

	<!-- 상단 입력 테이블 시작-->
	<%--@elvariable id="resultData" type="hris.E.E17Hospital.E17HospitalDetailData1"--%>

	<div class="tableArea">

		<div class="table">
			<table class="tableGeneral">

				<colgroup>
            		<col width="15%" />
            		<col width="30%" />
            		<col width="15%" />
            		<col width="" />
            	</colgroup>

				<c:choose>

                	<c:when test="${reqDisable eq 'true'}">
					<tr>
		                <td align="center" colspan="4">
		                   <br/>${Msg}<br/><br/>
		                </td>
	                </tr>
                	</c:when>

                	<c:otherwise>

                	<tr>
                		<th><span class="textPink">*</span><!--주택융자유형--><spring:message code="LABEL.E.E05.0001" /></th>
                    	<td colspan="2">
                			<input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}"  />

                			<select name="DLART" style="width:135px;" onChange="javascript:set_LoanMony(this);zzfund_Change(this);">
                            <option value="" selected>------------</option>

                            <c:choose>
                            	<c:when test="${PersLoanDataSize eq '0' }">
                            		${f:printCodeOption(getLoanTypeList, "")}
                            	</c:when>
                            	<c:otherwise>
                            		<c:forEach var="row" items="${vcCodeData}" varStatus="inx">
		                         	<c:set var="index" value="${inx.index}"/>
		                         	<option value ="<c:out value='${row.code}'/>" ><c:out value='${row.value}'/></option> <!-- 데이터 확인 index 및 trim -->
									</c:forEach>
                            	</c:otherwise>
                            </c:choose>

                            </select>

                		</td>
	                    <td>
	                        <a class="inlineBtn" href="javascript:open_rule('Rule02Benefits04.html');" style="float: right"><span><!--주택자금지원기준--><spring:message code="LABEL.E.E05.0020" /></span></a>
	                    </td>
                	</tr>

                	<tr>
	                    <th><!--현주소--><spring:message code="LABEL.E.E05.0002" /></th>
	                    <td colspan="3"><input type="text" name="E_STRAS" size="105" value='${E05PersInfoData.e_STRAS}' readonly></td>
	                </tr>

	                <tr>
	                    <th><!--근속년수--><spring:message code="LABEL.E.E05.0003" /></th>
	                    <td><input type="text" name="E_YEARS" size="18" value='${E05PersInfoData.e_YEARS}' style="text-align:right" readonly></td>
	                    <!--[CSR ID:2097388]-->
	                    <th class="th02"><span class="textPink">*</span><!--신청은행--><spring:message code="LABEL.E.E05.0004" /></th>
	                    <td>
	                        <select name="BANK_CODE" style="width:135px;" onChange="javascript:return;bank_get(this);">
	                            <option value="">-------------</option>

	                            <c:forEach var="row" items="${e05BankCodeData_vt}" varStatus="inx">
	                         	<c:set var="index" value="${inx.index}"/>
	                         	<option value="<c:out value='${row.BANK_CODE}'/>"  ><c:out value='${row.BANK_NAME}'/></option>
								</c:forEach>
	                        </select>&nbsp;&nbsp;&nbsp;
	                          <!-- C20130605_45075
	                          <img src="/web/images/ppt.gif" border="0" valign=bottom><a href="/web/E/E05House/LoanBankcomparisontable.ppt" target="_blank"><font color=blue>대출은행 비교표</font></a>
	                          -->
	                    </td>
	                </tr>

	                <tr>
	                    <th><span class="textPink">*</span><!--신청금액 --><spring:message code="LABEL.E.E05.0005" /></th>
	                    <td>
	                        <input type="hidden" name="REQU_MONY" value="">
	                        <input type="hidden" name="REQUMONY" value="">
	                        <input type="text" name="requmony" size="18" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right">
	                    </td>
	                    <th class="th02"><span class="textPink">*</span><!--자금용도--><spring:message code="LABEL.E.E05.0006" /></th>
	                    <td>
	                        <select name="ZZFUND_CODE" style="width:135px;" >
	                            <option value="">------------</option>
	                        </select>
	                    </td>
	                </tr>
	                <tr>
	                    <th><span class="textPink">*</span><!--보증여부--><spring:message code="LABEL.E.E05.0007" /></th>
	                    <td colspan="3">
	                        <div id=credit name=credit style="display:block">
	                        <input type="radio" name="ZZSECU_FLAG" value="C"><!--신용보증--><spring:message code="LABEL.E.E05.0008" /></div>
	                        <input type="radio" name="ZZSECU_FLAG" value="N"><!--보증보험가입희망--><spring:message code="LABEL.E.E05.0009" />

	                        <!--[CSR ID:C20160526_74869] 주택자금 신청화면 문구 추가 요청건
                            <br> &nbsp;&nbsp;&nbsp; ( 보증보험가입희망 시 대출액에 따른 보증보험료를 본인이 추가 부담하여야 함 )-->
                            <!-- [CSR ID:3193136] 주택자금 신청화면 수정의 건 -->
                            <br> &nbsp; (<!--위 대출은 신용대출로 개인신용한도 등 별도 관리가 필요한 경우 보증보험 가입 문의 바람--><spring:message code="LABEL.E.E05.0018" /><br/>
                                &nbsp; <!--단, 보증보험가입희망 시 대출액에 따른 보증보험료를 본인이 추가 부담하여야 함--><spring:message code="LABEL.E.E05.0019" />)

	                        <!--[CSR ID:1411665] 주택자금 신청화면 변경 요청건
	                        <input type="radio" name="ZZSECU_FLAG" value="Y"> 연대보증인 입보-->
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
	                                    <input type="radio" name="ZCONF" value="Y" checked><!--예--><spring:message code="LABEL.E.E05.0015" />&nbsp;&nbsp;
	                                    <input type="radio" name="ZCONF" value="N"><!--아니오--><spring:message code="LABEL.E.E05.0016" />
	                                </td>
	                            </tr>
	                        </table>
	                    </td>
	                </tr>

                	</c:otherwise>
               	</c:choose>

           	</table>
       	</div> <!-- end class="table" -->

		<c:if test="${reqDisable ne 'true'}">
		<div class="commentsMoreThan2">
        	<div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
        </div>
		</c:if>
		<!-- 상단 입력 테이블 끝-->

   	<!-- Hidden Field -->
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

	</div> <!-- end class="tableArea" -->

</tags-approval:request-layout>
</tags:layout>
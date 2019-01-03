<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 의료비 결재                                                 */
/*   Program ID   : G006ApprovalHospital.jsp                                    */
/*   Description  : 의료비 결재                                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*                  2005-10-28  LSA   자녀인 경우에 300만원한도체크로직이 빠져 있어 추가함CSR:C2005102601000000764  */
/*                  2005-12-08  LSA  @v1.1 C2005120801000000710  2005년 조영준(35008) 인경우만 배우자한도 300만원체크로직 제외함 */
/*                  2005-12-14  LSA  @v1.2 KRW아닌 단위인 경우 소숫점입력 안되어 추가함  */
/*                  2005-12-28  LSA  @v1.3 C2005121301000001097 결재수단,연말정산반영여부추가 */
/*                  2006-01-02  LSA  @v1.4 에러                                 */
/*                  2006-01-04  LSA  @v1.5 에러                                 */
/*                                   본인 :최초진료시 10만언 차감하고 지원/ 동일진료시 전액지원... */
/*                                   배우자및자녀:최초진료시 10만언차감하고 50%지원/ 동일진료시 50%지원*/
/*                  2006-01-17  LSA  @v1.7 연말정산반영액추가                   */
/*                : 2008-07-01  @v1.5 CSR ID:1290227 배우자/자녀한도 300만원 → 500만원 */
/*                  2008-11-13  CSR ID:1357074 의료비담당자결재관련 보완        */
/*                  2012-06-28  ※C20120620_30404 담당자인경우 1. 상병명 2. 신청액  가능하게 */
/*                  2013-12-18  ※C2013_9999 사내커플인경우도 중복여부확인 메세지 추가 */
/*                  2014/05/19 cSRID : 203485  이지은D @CSR1 시간선택제 (사무직(4H), 사무직(6H), 계약직(4H), 계약직(6H)) 의료비/학자금 신청 시 알림 popup 추가 */
/*                  2014-08-26  이지은D [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원 */
/*                  2015-08-19  이지은D [CSR ID:2849361] 사내부부 의료비관룐의 건 */
/*					 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="medi_count" value="${f:getSize(E17HospitalData_vt)}" />

<%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>


<c:set var="editable" value="${approvalHeader.charger}"/>
<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_BE_MEDI_FEE" updateUrl="${g.servlet}hris.E.E17Hospital.E17HospitalChangeSV">
        <tags:script>
            <script language="JavaScript">
                <!--
                ///////////// 숫자 포맷 ////////////////
                function chFrm() {
                    var frm = document.form1;
                    if (frm.COMP_WONX.value == "" || parseFloat(removeComma(frm.COMP_WONX.value)) == 0) {
                        alert('<spring:message code="MSG.G.G06.0001" />'); //회사 지원금을 입력하세요.
                        return false;
                    } // end if

                    var totEMPL_WONX  = Math.round(parseFloat(removeComma(frm.totEMPL_WONX.value)));
                    var COMP_WONX   =   Math.round(parseFloat(removeComma(frm.COMP_WONX.value)));
                    if(totEMPL_WONX - COMP_WONX < 0) {
                        alert('<spring:message code="MSG.G.G06.0002" />'); //회사 지원금이 실 납부액 보다 많습니다.
                        return false;
                    } // end if

                    if(frm.GUEN_CODE.value == "0001") {
                        if(${SCOMP_SUM} > 20000000) {
                            var ChagamAmt = 20000000- ${SCOMP_SUM};
                            /*alert("<spring:message code='MSG.G.G06.0003' arguments='ChagamAmt'/>");*/
                             alert("해당년도 의료비 지원총액은 2,000만원입니다.\n현재 지원가능 금액은 "+ChagamAmt +" 입니다");
                            return false;
                        }

                        if(${SCOMP_SUM} == 0) {

                        } // end if
                    } else  {//배우자, 자녀
                        var dFlag = 10000000;// [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원
                        if("Y" != "${P_Flag}" ) {
                            if((parseFloat(COMP_WONX)  +  parseFloat(${WCOMP_SUM}) + parseFloat(${ICOMP_SUM})) > parseFloat(dFlag)) {
                                alert('<spring:message code="MSG.G.G06.0004" />'); //년간 배우자 및 자녀 지원은 배우자 자녀 합산 1000만원 이하입니다.
                                return false;
                            }
                        }
                    }
                    return true;
                } // end function

                function beforeReject() {
                    $("#-accept-info").text("");
                    return true;
                }

                function beforeAccept() {
                    var frm = document.form1;

                    if(!check_data()) return false;
                    <c:if test="${approvalHeader.departManager}">
                    //부서장 결재시
                        <c:if test="${E_COUPLEYN == 'Y'}">
                        //Y: 사내커플인 경우 담당자 결재시 자녀 확인 메세지
                        //※C2013_9999
                        //@CSR1 사내커플이랑 시간제랑 동시에 사용하기 위해 "+"중복 지원 여부를 확인하셨습니까? 이부분 지웠음.
                        //자녀 결제시
                        if(frm.GUEN_CODE.value == "0003") {
                            if (!confirm("${E_MESSAGE}")) {
                                return false;
                            }
                        }
                        </c:if>
                    </c:if>

                    <c:if test="${approvalHeader.charger}">
                        //업무담당자 결재시
                        <c:if test="${E_COUPLEYN == 'Y'}">
                        //Y: 사내커플인 경우 담당자 결재시 자녀 확인 메세지
                        //※C2013_9999
                        //@CSR1 사내커플이랑 시간제랑 동시에 사용하기 위해 "+"중복 지원 여부를 확인하셨습니까? 이부분 지웠음.
                        //배우자, 자녀 결제시
                        if(frm.GUEN_CODE.value == "0002") {
                            alert("${E_MESSAGE}");
                            return false;
                        }else if(frm.GUEN_CODE.value == "0003") {
                            if (!confirm("${E_MESSAGE}")) {
                                return false;
                            }
                        }
                        </c:if>

                        <c:if test="${E_YEARS >= 20}">

                        alert('<spring:message code="MSG.G.G06.0005" />'); //의료비 신청 대상자가 만 20세 이상입니다. 관련 증빙 서류를 확인하여 처리하세요
                        </c:if>
                    </c:if>

                    <c:if test="${approvalHeader.charger or approvalHeader.chargeManager}">
                    if(!chFrm()) {
                        return ;
                    } // end if
                    </c:if>

                    <c:if test="${approvalHeader.chargeManager}">
                    $("#-accept-info").text("회사지원 금액이 ${f:printNumFormat(e17SickData.COMP_WONX ,currencyValue)} 입니다.");
                    <%--if (!confirm("<spring:message code='MSG.G.G06.0006' arguments='frm.COMP_WONX.value'/>")) return false;  //회사지원 금액이 "+frm.COMP_WONX.value+" 입니다. 결재 하시겠습니까.--%>
                    frm.COMP_WONX.value = "${f:printNumFormat(e17SickData.COMP_WONX ,currencyValue)}";
                    </c:if>

                    <c:if test="${approvalHeader.charger}">
                    frm.COMP_WONX.value = removeComma(frm.COMP_WONX.value);
                    frm.YTAX_WONX.value = removeComma(frm.YTAX_WONX.value);

                    if (frm.GUEN_CODE.value != "0001") {
                        if ( document.form1.PROOF.checked == true ) {
                            document.form1.PROOF.value = "X";
                        } else {
                            document.form1.PROOF.value = "";
                        }
                    }
                    </c:if>

                    //@v1.7
                    for ( r=0; r< ${medi_count}; r++) {
                        eval("document.form1.EMPL_WONX"+ r + ".value = removeComma(document.form1.EMPL_WONX"+r+".value);");
                        eval("document.form1.YTAX_WONX"+ r + ".value = removeComma(document.form1.YTAX_WONX"+r+".value);");
                        eval("document.form1.EXAM_DATE"+ r + ".value = removePoint(document.form1.EXAM_DATE"+r+".value);");
                    }

                    return true;
                }


                /* check_data ********************************************************************************************* */
                function check_data() {
                    //@v1.3
                    if( checkNull(document.form1.TREA_CODE, "<spring:message code='LABEL.G.G06.0001' />") == false )  //진료과를
                        return false;

                    /* 필수 입력값 .. 의료기관, 사업자등록번호, 전화번호, 진료일, 영수증 구분, 본인 실납부액 */
                    hasNoData = true;
                    chk_inx   = -1;
                    for( inx = 0 ; inx < ${medi_count} ; inx++ ){
                        medi_name =             eval("document.form1.MEDI_NAME"+inx+".value");
                        medi_numb = removeResBar2(eval("document.form1.MEDI_NUMB"+inx+".value"));
                        telx_numb = eval("document.form1.TELX_NUMB"+inx+".value");
                        exam_date = removePoint(eval("document.form1.EXAM_DATE"+inx+".value"));
                        if( medi_name == "" && medi_numb == "" && telx_numb == "" && exam_date == ""   ){
//          마지막에 입력한 의료기관 정보를 얻기위해서
                            if( chk_inx < 0 && hasNoData == false ) {
                                chk_inx = inx - 1;
                            }
                        }else if(medi_name != ""  && medi_numb != "" && telx_numb != "" && exam_date != ""  ){
                            hasNoData = false;

//          2002.05.10. 의료기관 길이 제한 - 20자
                            if( checkLength(medi_name) > 20 ){
                                alert("<spring:message code='MSG.G.G06.0007' />"); //의료기관명은 한글 10자, 영문 20자 이내여야 합니다.
                                return false;
                            }
//          2002.05.10. 의료기관 길이 제한 - 20자
                            if( checkLength(telx_numb) < 5 ){
                                alert("<spring:message code='MSG.G.G06.0008' />"); //전화번호는 5자 이상 입력 하셔야 합니다.
                                return false;
                            }
                        }else{
                            alert('<spring:message code='MSG.G.G06.0009' />'); //\"의료기관\", \"사업자등록번호\", \"전화번호\", \"진료일\", \"본인 실납부액\"은 필수 항목입니다.\n\n 누락된 값을 입력해주세요
                            if(medi_name == ""){
                                eval("document.form1.MEDI_NAME"+inx+".focus();");
                            }else if(medi_numb == ""){
                                eval("document.form1.MEDI_NUMB"+inx+".focus();");
                            }else if(telx_numb == ""){
                                eval("document.form1.TELX_NUMB"+inx+".focus();");
                            }else if(exam_date == ""){
                                eval("document.form1.EXAM_DATE"+inx+".focus();");
                            }
                            return false;
                        }
                    }
                    for(var inxx = 0 ; inxx< ${medi_count} ; inxx++){
                        eval("document.form1.MEDI_NUMB"+inxx+".value = removeResBar2(document.form1.MEDI_NUMB"+inxx+".value);");
                        eval("document.form1.EXAM_DATE"+inxx+".value = removePoint(document.form1.EXAM_DATE"+inxx+".value);");
                        eval("document.form1.EMPL_WONX"+inxx+".value = removeComma(document.form1.EMPL_WONX"+inxx+".value);");
                    }

                    return true;
                }
                /* check_data ********************************************************************************************* */


                function sumCalc(obj, inx) //@v1.3 연말정산반영액이 연말정산sum금액에 적용
                {
                    var frm = document.form1;
                    var YTAX_WONX = 0;
                    // 자녀,배우자가 년말 정산 반영하지 않으면 이로직 필요없슴


                    for ( r=0; r< ${medi_count}; r++) {
                        if (eval("document.form1.YTAX_WONX"+r+".value") != "0" ||
                                eval("document.form1.YTAX_WONX"+r+".value") != ""     ) {
                            YTAX_WONX = YTAX_WONX + parseFloat(removeComma(eval("document.form1.YTAX_WONX"+r+".value")));
                        }
                    }

                    frm.YTAX_WONX.value = YTAX_WONX ;
                    var Oytax_wonx =  eval( "document.form1.YTAX_WONX");

                    if (frm.WAERS.value == "KRW" ||frm.WAERS.value == "\\") {
                        addComma(Oytax_wonx) ;
                    }
                    else {
                        addComma_1(Oytax_wonx) ;
                    }


                }
                //연말정산체크시
                function check_PROOF(obj) {
                    if (obj.checked ==false ) {
                        for ( r=0; r< ${medi_count}; r++) {
                            eval("document.form1.YTAX_WONX"+ r + ".value = \"0\";");
                        }
                        document.form1.YTAX_WONX.value = "0" ;
                    } else {
                        var YTAX_WONX = 0;
                        var EMPL_WONX = "";

                        for ( r=0; r< ${medi_count}; r++) {
                            EMPL_WONX = 0;
                            if (eval("document.form1.EMPL_WONX"+r+".value") != "0" ||
                                    eval("document.form1.EMPL_WONX"+r+".value") != ""     ) {
                                YTAX_WONX = YTAX_WONX + Math.round(parseFloat(removeComma(eval("document.form1.EMPL_WONX"+r+".value"))));
                                eval("document.form1.YTAX_WONX"+ r + ".value = document.form1.EMPL_WONX"+r+".value;");

                            }
                        }

                        document.form1.YTAX_WONX.value = insertComma(YTAX_WONX+"") ;

                    }

                }


                /* 본인 실부담액 합계구하기 */
                function multiple_won() {
                    var hap = 0;      //신청총금액
                    var Limitamt = 0; //년간지원한도
                    var PreEndamt = 0; //이미지원받은금액
                    var l_exam_date = 0;
                    l_exam_date_max = 0;
                    for( k = 0 ; k < ${medi_count} ; k++){
                        val = eval("removeComma(document.form1.EMPL_WONX"+k+".value)");
                        hap = hap + Number(val);

                    }

                    if( hap > 0 ) {
                        if( document.form1.WAERS.value == "KRW" ) {
                            hap = pointFormat(hap, 0);
                        } else {
                            hap = pointFormat(hap, 2);
                        }
                        //if( hap <= 100000 ){
                        //    alert(" 최초 진료시 본인부담액이 10만원 초과일 경우에 의료비 신청이 가능합니다. ");
                        //    document.form1.COMP_WONX.value = ""; //회사지원액
                        //    return false;
                        //}

                        document.form1.totEMPL_WONX.value = insertComma(hap+"");
                        //(1) 본  인: 동일 질병 본인부담금 10만원 초과분 전액, 년간 2,000만원 한도
                        //(2) 배우자: 동일 질병 본인부담금 10만원 초과분 전액, 년간 500만원 한도
                        //(3) 자  녀: 동일 질병 본인부담금 10만원 초과분의 50%, 자녀간 합산 년간 500만원 한도
                        <c:if test="${isFirst}">
                        hap = hap - 100000;
                        </c:if>
                        <c:if test="${e17SickData.GUEN_CODE == '0001'}"><%-- 본인:년간 2,000만원한도 --%>
                        Limitamt = 20000000;
                        PreEndamt = ${SCOMP_SUM};
                        </c:if>
                        <c:if test="${e17SickData.GUEN_CODE == '0002'}"><%-- 배우자:년간500만원한도 --%>
                        Limitamt = 10000000;
                        PreEndamt = ${WCOMP_SUM} + ${ICOMP_SUM};
                        </c:if>
                        <c:if test="${e17SickData.GUEN_CODE == '0003'}"><%-- 자녀:초과분의50%지원,자녀간합산년간500만원한도 --%>
                        hap = hap/2;
                        Limitamt = 10000000;
                        PreEndamt = ${WCOMP_SUM} + ${ICOMP_SUM};
                        </c:if>

                        <c:if test="${!(e17SickData.GUEN_CODE == '0002' and P_Flag == 'Y')}">//배우자지원한도미적용
                        if ( ( Number(hap)+Number(PreEndamt))> Limitamt ) {
                            hap= Number(Limitamt)-Number(PreEndamt);
                        }
                        </c:if>
                        document.form1.COMP_WONX.value = insertComma(hap+""); //회사지원액
                    }else if( hap == 0 ){
                        document.form1.totEMPL_WONX.value = "";
                        document.form1.COMP_WONX.value = ""; //회사지원액
                    }
                    check_PROOF(document.form1.PROOF);

                }


                $(function() {
                    <c:if test="${!approvalHeader.chargeManager}">
                    //multiple_won();
                    </c:if>
                });
                //-->
            </script>
        </tags:script>
        <!-- 상단 입력 테이블 시작-->
        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral  tableApproval">

                    <colgroup>
                        <c:if test="${e17SickData.GUEN_CODE == '0003'}">
                        <col width="15%"/>
                        <col width="35%"/>
                        <col width="15%"/>
                        <col width="35%"/>
                        </c:if>
                        <c:if test="${e17SickData.GUEN_CODE != '0003'}">
                            <col width="15%"/>
                            <col width="85%"/>
                        </c:if>
                    </colgroup>

                    <tr>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0002' /><!-- 관리번호 --></th>
                        <td colspan="3">
                            ${e17SickData.CTRL_NUMB}
                            <INPUT TYPE="HIDDEN" NAME="PERNR"        VALUE="${e17SickData.PERNR}">
                            <INPUT TYPE="HIDDEN" NAME="BEGDA"        VALUE="${e17SickData.BEGDA}">
                            <INPUT TYPE="HIDDEN" NAME="CTRL_NUMB"    VALUE="${e17SickData.CTRL_NUMB}">
                            <INPUT TYPE="HIDDEN" NAME="SICK_DESC1"   VALUE="${e17SickData.SICK_DESC1}">
                            <INPUT TYPE="HIDDEN" NAME="SICK_DESC2"   VALUE="${e17SickData.SICK_DESC2}">
                            <INPUT TYPE="HIDDEN" NAME="SICK_DESC3"   VALUE="${e17SickData.SICK_DESC3}">
                            <INPUT TYPE="HIDDEN" NAME="SICK_DESC4"   VALUE="${e17SickData.SICK_DESC4}">
                            <INPUT TYPE="HIDDEN" NAME="WAERS"        VALUE="${e17SickData.WAERS}">
                            <INPUT TYPE="HIDDEN" NAME="BIGO_TEXT1"   VALUE="${e17SickData.BIGO_TEXT1}">
                            <INPUT TYPE="HIDDEN" NAME="BIGO_TEXT2"   VALUE="${e17SickData.BIGO_TEXT2}">
                            <INPUT TYPE="HIDDEN" NAME="BIGO_TEXT3"   VALUE="${e17SickData.BIGO_TEXT3}">
                            <INPUT TYPE="HIDDEN" NAME="BIGO_TEXT4"   VALUE="${e17SickData.BIGO_TEXT4}">
                            <INPUT TYPE="HIDDEN" NAME="GUEN_CODE"    VALUE="${e17SickData.GUEN_CODE}">
                            <INPUT TYPE="HIDDEN" NAME="ENAME"        VALUE="${e17SickData.ENAME}">
                            <INPUT TYPE="HIDDEN" NAME="RFUN_DATE"    VALUE="${e17SickData.RFUN_DATE}">
                            <INPUT TYPE="HIDDEN" NAME="RFUN_RESN"    VALUE="${e17SickData.RFUN_RESN}">
                            <INPUT TYPE="HIDDEN" NAME="RFUN_AMNT"    VALUE="${e17SickData.RFUN_AMNT}">
                            <INPUT TYPE="HIDDEN" NAME="BELNR1"       VALUE="${e17SickData.BELNR1}">
                            <INPUT TYPE="HIDDEN" NAME="OBJPS_21"     VALUE="${e17SickData.OBJPS_21}">
                            <INPUT TYPE="HIDDEN" NAME="REGNO"        VALUE="${e17SickData.REGNO}">
                            <INPUT TYPE="HIDDEN" NAME="DATUM_21"     VALUE="${e17SickData.DATUM_21}">
                            <INPUT TYPE="HIDDEN" NAME="POST_DATE"    VALUE="${e17SickData.POST_DATE}">
                            <INPUT TYPE="HIDDEN" NAME="BELNR"        VALUE="${e17SickData.BELNR}">
                            <INPUT TYPE="HIDDEN" NAME="ZPERNR"       VALUE="${e17SickData.ZPERNR}">
                            <INPUT TYPE="HIDDEN" NAME="ZUNAME"       VALUE="${e17SickData.ZUNAME}">
                            <input type="hidden" name="ORG_CTRL"   value="${e17SickData.ORG_CTRL }"> <!-- 동일진료시 선택한원래관리번호CSR ID:1361257  -->
                            <input type="hidden" name="LAST_CTRL"  value="${e17SickData.LAST_CTRL }"> <!-- 동일진료시 선택한원래관리번호의 마지막번호CSR ID:1361257  -->

                            <input type="hidden" name="HospitalRowCount" value="${medi_count }">
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code='MSG.APPROVAL.0012' /><!-- 구분 --></th>
                        <td colspan="3">
                            ${f:printOptionValueText(guenCodeList, e17SickData.GUEN_CODE) }&nbsp;&nbsp;&nbsp;
                            <c:choose>
                                <c:when test="${e17SickData.GUEN_CODE == '0002'}">
                                    <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF == "X" ? "checked" : "" } ${editable ? "onClick='check_PROOF(this);'" : "disabled" }>
                                    <spring:message code='LABEL.G.G06.0003' /><!-- 배우자 연말정산반영 여부 -->
                                </c:when>
                                <c:when test="${e17SickData.GUEN_CODE == '0003'}">
                                    <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF == "X" ? "checked" : "" } ${editable ? "onClick='check_PROOF(this);'" : "disabled" }>
                                    <spring:message code='LABEL.G.G06.0004' /><!-- 자녀 연말정산반영 여부 -->
                                </c:when>
                                <c:when test="${e17SickData.GUEN_CODE == '0001'}">
                                    <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF == "X" ? "checked" : "" } ${editable ? "onClick='this.checked=true;'" : "disabled" }>
                                    <spring:message code='LABEL.G.G06.0005' /><!-- 본인 연말정산반영 여부 -->
                                </c:when>
                                <c:otherwise>
                                    <INPUT TYPE="HIDDEN" NAME="PROOF"        VALUE="${e17SickData.PROOF}">
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <c:if test="${e17SickData.GUEN_CODE == '0003'}">
                        <tr>
                            <th><spring:message code='LABEL.G.G06.0006' /><!-- 자녀이름 --></th>
                            <td>${e17SickData.ENAME }</td>
                            <th><spring:message code='LABEL.G.G06.0007' /><!-- 자녀주민번호 --></th>
                            <td>${f:printRegNo(e17SickData.REGNO, "LAST")  }</td>
                        </tr>
                        <tr>
                            <td colspan="4"><b><font color=blue><c:if test="${E_YEARS >= 20}"><spring:message code='MSG.G.G06.0005' /><!-- 의료비 신청 대상자가 만 20세 이상입니다. 관련 증빙 서류를 확인하여 처리하세요 --></c:if></font></b></td>
                        </tr>
                        <!--@v1.3-->
                    </c:if>
                    <tr >
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0008' /><!-- 진료과 --></th>
                        <td colspan="3">
                            <c:choose>
                                <c:when test="${editable}">
                                    <select name="TREA_CODE" onChange="javascript:document.form1.TREA_TEXT.value = this.options[this.selectedIndex].text;">
                                        <option value="">--------</option>
                                            ${f:printCodeOption(MedicTrea_vt, e17SickData.TREA_CODE)}
                                    </select>
                                    <input type="hidden" name="TREA_TEXT" value="${e17SickData.TREA_TEXT }">
                                </c:when>
                                <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
                                <c:when test="${approvalHeader.departManager and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                	<input type="hidden" name="TREA_CODE" value="${e17SickData.TREA_CODE }">
                                </c:when>
                                <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                                <c:otherwise>
                                    ${f:printOptionValueText(MedicTrea_vt, e17SickData.TREA_CODE)}
                                 <input type="hidden" name="TREA_CODE" value="${e17SickData.TREA_CODE }">
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th><spring:message code='LABEL.G.G06.0009' /><!-- 상병명 --></th>
                        <td colspan="3">
                            <c:choose>
                                <c:when test="${editable}">
                                    <input type="text" name="SICK_NAME" value="${e17SickData.SICK_NAME }" size="40">
                                </c:when>
                                <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
                                <c:when test="${approvalHeader.departManager and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                <INPUT TYPE="HIDDEN" NAME="SICK_NAME"    VALUE="${e17SickData.SICK_NAME}">
                                </c:when>
                                <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                                <c:otherwise>
                                    <INPUT TYPE="HIDDEN" NAME="SICK_NAME"    VALUE="${e17SickData.SICK_NAME}">
                                    ${e17SickData.SICK_NAME }
                               </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='LABEL.G.G06.0010' /><!-- 구체적증상 --></th>
                        <td colspan="3">
                        <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
                          	<c:choose>
                                <c:when test="${approvalHeader.departManager and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                  	<INPUT TYPE="HIDDEN" NAME="SICK_DESC"    VALUE="${e17SickData.SICK_DESC1}${e17SickData.SICK_DESC2}${e17SickData.SICK_DESC3}${e17SickData.SICK_DESC4}">
                        		</c:when>
                        		<c:otherwise>
                        			<textarea name="SICK_DESC" wrap="VIRTUAL" cols="70" rows="4" readonly>${e17SickData.SICK_DESC1}${e17SickData.SICK_DESC2}${e17SickData.SICK_DESC3}${e17SickData.SICK_DESC4}</textarea>
                        		</c:otherwise>
                        	</c:choose>
                        <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='LABEL.COMMON.0015' /><!-- 비고 --></th>
                        <td colspan="3">${e17SickData.BIGO_TEXT1}<br>${e17SickData.BIGO_TEXT2}</td>
                    </tr>
                </table>
            </div>
        </div>

       <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
               <c:if test="${approvalHeader.departManager and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                  <div class="commentsMoreThan2">
                     <div><spring:message code='MSG.E.E17.0030' /><!-- 개인정보보호 차원에서 배우자 및 자녀에 대한 진료세부사항을 제공하지 않습니다. --></div>
                   </div>
                </c:if>
       <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end--%>
        <!-- 상단 입력 테이블 시작-->
        <div class="listArea">
            <div class="table">
                <table class="listTable">
                    <thead>
                    <tr>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0011' /><!-- 의료기관 --></th>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0012' /><!-- 사업자등록번호 --></th>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0013' /><!-- 전화번호 --></th>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0014' /><!-- 진료일 --></th>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0015' /><!-- 입원/외래 --></th>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0016' /><!-- 영수증 구분 --></th>
                        <th><spring:message code='LABEL.G.G06.0020' /><!-- No. --></th>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0017' /><!-- 결재수단 --></th>
                        <th><span class="textPink">*</span><spring:message code='LABEL.G.G06.0018' /><!-- 본인 실납부액 --></th>
                        <th class="lastCol"><span class="textPink">*</span><spring:message code='LABEL.G.G06.0019' /><!-- 연말정산 반영액 --></th>
                    </tr>
                    </thead>
                    <c:forEach var="e17HospitalData" items="${E17HospitalData_vt}" varStatus="status">
                        <tr>
                            <td>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
                          	<c:choose>
                                <c:when test="${approvalHeader.departManager and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                  	<input type="hidden" name="MEDI_NAME${status.index}" value="${e17HospitalData.MEDI_NAME}" >
                        		</c:when>
                        		<c:otherwise>
                        			<input type="text" name="MEDI_NAME${status.index}" value="${e17HospitalData.MEDI_NAME}" size="16" ${editable ? "" : "readonly"}>
                        		</c:otherwise>
                        	<%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                        	</c:choose>
                                <input type="hidden" name="BEGDA${status.index}"        value="${e17HospitalData.BEGDA}">
                                <input type="hidden" name="PERNR${status.index}"        value="${e17HospitalData.PERNR}">
                                <input type="hidden" name="CTRL_NUMB${status.index}"    value="${e17HospitalData.CTRL_NUMB}">
                                <input type="hidden" name="AINF_SEQN${status.index}"    value="${e17HospitalData.AINF_SEQN}">
                                <!--<input type="hidden" name="EXAM_DATE${status.index}"    value="${e17HospitalData.EXAM_DATE}">-->
                                <input type="hidden" name="RCPT_NUMB${status.index}"    value="${e17HospitalData.RCPT_NUMB}">
                                <input type="hidden" name="WAERS${status.index}"        value="${e17HospitalData.WAERS}">
                                <input type="hidden" name="COMP_WONX${status.index}"    value="${e17HospitalData.COMP_WONX}">
                            </td>
                            <td>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
                          	<c:choose>
                                <c:when test="${approvalHeader.departManager and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                  	<input type="hidden" name="MEDI_NUMB${status.index}" value="${f:companyCode(e17HospitalData.MEDI_NUMB)}" >
                        		</c:when>
                        		<c:otherwise>
                        			<input type="text" name="MEDI_NUMB${status.index}" value="${f:companyCode(e17HospitalData.MEDI_NUMB)}" size="11" maxlength="12" ${editable ? "" : "readonly"}>
                        		</c:otherwise>
                        	</c:choose>
                        	<%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                            </td>
                            <td>
                            <%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 start --%>
                          	<c:choose>
                                <c:when test="${approvalHeader.departManager and  (e17SickData.GUEN_CODE == '0002'  or e17SickData.GUEN_CODE == '0003')}">
                                  	<input type="hidden" name="TELX_NUMB${status.index}" value="${e17HospitalData.TELX_NUMB}" >
                        		</c:when>
                        		<c:otherwise>
									<input type="text" name="TELX_NUMB${status.index}" value="${e17HospitalData.TELX_NUMB}" size="12" maxlength="13"  ${editable ? "" : "readonly"}>
                        		</c:otherwise>
                        	</c:choose>
                        	<%-- 2017-06-09  eunha [CSR ID:3399619] 소속 팀장 의료비 결재화면 수정요청의 건 end --%>
                            </td>
                            <td>
									<input type="text" name="EXAM_DATE${status.index}" value="${f:printDate(e17HospitalData.EXAM_DATE)}" size="10" class="${editable ? "date" : ""}" ${editable ? "" : "readonly"}>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${editable}">
                                        <select name="MEDI_CODE${status.index}">
                                            <!--  option -->
                                                ${f:printCodeOption(MediCode_vt, e17HospitalData.MEDI_CODE)}
                                            <!--  option -->
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        ${e17HospitalData.MEDI_TEXT }
                                        <input type="hidden" name="MEDI_CODE${status.index}"    value="${e17HospitalData.MEDI_CODE}">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>

                                <c:choose>
                                    <c:when test="${editable}">
                                        <select name="RCPT_CODE${status.index}" onChange="javascript:chg_opt(this);">
                                            <!--  option -->
                                                ${f:printCodeOption(RcptCode_vt, e17HospitalData.RCPT_CODE)}
                                            <!--  option -->
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        ${e17HospitalData.RCPT_TEXT }
                                        <input type="hidden" name="RCPT_CODE${status.index}"    value="${e17HospitalData.RCPT_CODE}">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                    ${e17HospitalData.RCPT_NUMB }
                            </td>
                            <td><!--@v1.1-->
                                <c:choose>
                                    <c:when test="${editable}">
                                        <select name="MEDI_MTHD${status.index}">
                                            <option value="2" ${e17HospitalData.MEDI_MTHD == "2" ? "selected" : "" }><spring:message code="TAB.COMMON.0027" /><!-- 신용카드 --></option>
                                            <option value="3" ${e17HospitalData.MEDI_MTHD == "3" ? "selected" : "" }><spring:message code="LABEL.G.G06.0021" /><!-- 현금영수증 --></option>
                                            <option value="1" ${e17HospitalData.MEDI_MTHD == "1" ? "selected" : "" }><spring:message code="LABEL.G.G06.0022" /><!-- 현금 --></option>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${e17HospitalData.MEDI_MTHD == '1'}"><spring:message code="LABEL.E.E18.0040"/></c:when>
                                            <c:when test="${e17HospitalData.MEDI_MTHD == '2'}"><spring:message code="LABEL.E.E18.0041"/></c:when>
                                            <c:when test="${e17HospitalData.MEDI_MTHD == '3'}"><spring:message code="LABEL.E.E18.0042"/></c:when>
                                        </c:choose>
                                        <input type="hidden" name="MEDI_MTHD${status.index}"    value="${e17HospitalData.MEDI_MTHD}">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${editable}">
                                        <input type="text" name="EMPL_WONX${status.index}" value="${f:printNumFormat(e17HospitalData.EMPL_WONX, currencyValue) }" size="10" style="text-align:right"
                                               onKeyUp="${e17SickData.WAERS == 'KRW' or  e17SickData.WAERS == '\\' ? 'moneyChkEventForWon(this);' : 'moneyChkEventForWorld(this)'}" onBlur="javascript:multiple_won();">
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="EMPL_WONX${status.index}"    value="${f:printNumFormat(e17HospitalData.EMPL_WONX,currencyValue) }">
                                        ${f:printNumFormat(e17HospitalData.EMPL_WONX,currencyValue) }
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="lastCol"><!--@v1.3-->
                                <c:choose>
                                    <c:when test="${editable}">
                                        <c:set var="ytaxValue" value="${f:printNumFormat(e17HospitalData.YTAX_WONX, currencyValue)}"/>
                                        <c:if test="${(!(e17SickData.PROOF == '' and !e17SickData.GUEN_CODE == '0001') and f:parseFloat(e17HospitalData.YTAX_WONX) == 0)}">
                                            <c:set var="ytaxValue" value="${f:printNumFormat(e17HospitalData.EMPL_WONX, currencyValue)}"/>
                                        </c:if>

                                        <input type="input" size=9 name="YTAX_WONX${status.index}"
                                       value="${ytaxValue}" style="text-align:right"
                                       onKeyUp="${e17SickData.WAERS == 'KRW' or  e17SickData.WAERS == '\\' ? 'moneyChkEventForWon(this);' : 'moneyChkEventForWorld(this)'}" onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0; sumCalc(this,${status.index});">
                                    </c:when>
                                    <c:otherwise>
                                        <input type="input" size=9 name="YTAX_WONX${status.index}" value="${f:printNumFormat(e17HospitalData.YTAX_WONX, currencyValue) }"  readonly style="text-align:right" >
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <c:set var="totEMPL_WONX" value="${totEMPL_WONX + e17HospitalData.EMPL_WONX}"/>
                        </tr>
                    </c:forEach>
                </table>
            </div>
<%--
            TempCompanySum_1 = Double.parseDouble(SCOMP_SUM)-Double.parseDouble(SCOMPING_SUM);
            TempCompanySum_2 = Double.parseDouble( WCOMP_SUM)-Double.parseDouble(WCOMPING_SUM);
            TempCompanySum_3 = Double.parseDouble(ICOMP_SUM)-Double.parseDouble(ICOMPING_SUM);
--%>

           <%-- <div class="buttonArea ">
                <div style="float:right; position:relative; top:8px; margin-right:10px;" style="line-height: 30px;">
                    <input type="text" name="totEMPL_WONX" size="11" style="text-align:right" value="${f:printNumFormat(totEMPL_WONX,currencyValue)}" readonly>${e17SickData.WAERS }
                </div>
            </div>--%>


        <%--<tr>
            <td width="760">
                <div class="tableArea">
                    <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="40" class="td04"/>
                            <td width="100" class="td04"></td>
                            <td width="90" class="td04"></td>

                            <th>연말정산반영액</th>
                            <td>
                                <% if (e17SickData.WAERS.equals("KRW") ||e17SickData.WAERS.equals("\\") ) { // @v1.2 %>
                                <input type="text" NAME="YTAX_WONX" value="${WebUtil.printNumFormat(e17SickData.YTAX_WONX ,currencyValue)}" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEventForWon(this);"  onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03" readonly>
                                <% } else { %>
                                <input type="text" NAME="YTAX_WONX" value="${WebUtil.printNumFormat(e17SickData.YTAX_WONX ,currencyValue)}" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEventForWorld(this);"  onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03" readonly>
                                <% }%>

                                    ${e17SickData.WAERS }
                            </td>
                            <td width="30">&nbsp;</td>
                            <th>회사지원액</th>
                            <td>
                                <% if (e17SickData.WAERS.equals("KRW") ||e17SickData.WAERS.equals("\\") ) { // @v1.2 %>
                                <input type="text" NAME="COMP_WONX" value="${WebUtil.printNumFormat(e17SickData.COMP_WONX ,currencyValue) }" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEventForWon(this);" onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03">
                                <% } else { %>
                                <input type="text" NAME="COMP_WONX" value="${WebUtil.printNumFormat(e17SickData.COMP_WONX ,currencyValue) }" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEventForWorld(this);" onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03">
                                <% }%>
                                    ${e17SickData.WAERS }
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <%  } else if (approvalStep == DocumentInfo.DUTY_MANGER) { %>
        <tr>
        <td width="760">
        <div class="tableArea">
            <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="40" class="td04"/>
                    <td width="100" class="td04"></td>
                    <td width="90" class="td04"></td>
                    <th>연말정산반영액</th>
                    <td>
                            ${WebUtil.printNumFormat(e17SickData.YTAX_WONX ,currencyValue) %> <%= e17SickData.WAERS }
                                            <INPUT TYPE="HIDDEN" NAME="YTAX_WONX"    VALUE="${e17SickData.YTAX_WONX}">
                                        </td>
                                        <td width="30"  class="td04">&nbsp;</td>
                                        <th class="th02">회사지원액</th>
                                        <td>
                                            ${WebUtil.printNumFormat(e17SickData.COMP_WONX ,currencyValue) %> <%= e17SickData.WAERS }
                                            <INPUT TYPE="HIDDEN" NAME="COMP_WONX"    VALUE="${e17SickData.COMP_WONX}">
                                        </td>
                                      </tr>
                                    </table>
                                    </div>
                                  </td>
                                </tr>
                            <%  } // end if %>--%>

        </div>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                <c:choose>
                    <c:when test="${e17SickData.GUEN_CODE == '0001'}">
                    <tr>
                        <th>진행중 회사지원액</th>
                        <td>${f:printNumFormat(SCOMPING_SUM,currencyValue)} ${e17SickData.WAERS}</td>
                        <th class="th02">회사지원총액</th>
                        <td>${f:printNumFormat(TempCompanySum_1,currencyValue)} ${e17SickData.WAERS}</td>
                        <th class="th02">계</th>
                        <td>
                            <input type="text" name="totEMPL_WONX" size="11" style="text-align:right" value="${f:printNumFormat(totEMPL_WONX,currencyValue)}" readonly> ${e17SickData.WAERS }
                        </td>
                    </tr>
                    </c:when>
                    <c:otherwise>
                    <tr>
                        <th>배우자</th>
                        <th class="th02">진행중 회사지원액</th>
                        <td>${f:printNumFormat(WCOMPING_SUM,currencyValue)} ${e17SickData.WAERS}</td>
                        <th class="th02">회사지원총액</td>
                        <td>${f:printNumFormat(TempCompanySum_2,currencyValue)} ${e17SickData.WAERS}</td>
                        <td></td>
                        <th class="th02" rowspan="2">계</th>
                        <td rowspan="2">
                            <!--%=WebUtil.printNumFormat(totEMPL_WONX,currencyValue)%-->
                            <input type="text" name="totEMPL_WONX" size="11" style="text-align:right" value="${f:printNumFormat(totEMPL_WONX,currencyValue)}" readonly> ${e17SickData.WAERS }
                        </td>
                    </tr>
                    <tr>
                        <th>자녀</th>
                        <th class="th02">진행중 회사지원액</th>
                        <td>${f:printNumFormat(ICOMPING_SUM,currencyValue) } ${e17SickData.WAERS }</td>
                        <th class="th02">회사지원총액</th>
                        <td>${f:printNumFormat(TempCompanySum_3,currencyValue)} ${e17SickData.WAERS}</td>
                        <td>&nbsp;</td>
                    </tr>
                    </c:otherwise>
                </c:choose>
                </table>
            </div>
        </div>

        <c:choose>
            <c:when test="${approvalHeader.departManager}">
                <input type="hidden" name="YTAX_WONX" value="${e17SickData.YTAX_WONX}">
                <input type="hidden" name="COMP_WONX" value="${e17SickData.COMP_WONX}">
            </c:when>
            <c:when test="${approvalHeader.charger}">
                <div class="tableArea">
                    <div class="table">
                        <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <th>연말정산반영액</th>
                                <td>
                                    <input type="text" NAME="YTAX_WONX" value="${f:printNumFormat(e17SickData.YTAX_WONX ,currencyValue)}" size="13" style="text-align:right"
                                          onKeyUp="${e17SickData.WAERS == 'KRW' or  e17SickData.WAERS == '\\' ? 'moneyChkEventForWon(this);' : 'moneyChkEventForWorld(this)'}"
                                          onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03" readonly>
                                    ${e17SickData.WAERS }
                                </td>
                                <td width="30">&nbsp;</td>
                                <th>회사지원액</th>
                                <td>
                                    <input type="text" NAME="COMP_WONX" value="${f:printNumFormat(e17SickData.COMP_WONX ,currencyValue) }" size="13" style="text-align:right"
                                          onKeyUp="${e17SickData.WAERS == 'KRW' or  e17SickData.WAERS == '\\' ? 'moneyChkEventForWon(this);' : 'moneyChkEventForWorld(this)'}"
                                          onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03">
                                        ${e17SickData.WAERS }
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:when test="${approvalHeader.chargeManager}">
                <div class="tableArea">
                    <div class="table">
                        <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <th>연말정산반영액</th>
                                <td>
                                    ${f:printNumFormat(e17SickData.YTAX_WONX ,currencyValue)} ${e17SickData.WAERS }
                                    <INPUT TYPE="HIDDEN" NAME="YTAX_WONX"    VALUE="${e17SickData.YTAX_WONX}">
                                </td>
                                <th>회사지원액</th>
                                <td>
                                    ${f:printNumFormat(e17SickData.COMP_WONX ,currencyValue)} ${e17SickData.WAERS }
                                    <INPUT TYPE="HIDDEN" NAME="COMP_WONX"    VALUE="${e17SickData.COMP_WONX}">
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </c:when>
        </c:choose>


    </tags-approval:detail-layout>
</tags:layout>



<%--



<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

    E17SickData e17SickData        = (E17SickData)request.getAttribute("e17SickData");
    Vector      E17HospitalData_vt = (Vector)request.getAttribute("vcE17HospitalData");
    //Logger.debug.println(E17HospitalData_vt);
    Vector      vcAppLineData     = (Vector)request.getAttribute("vcAppLineData");

    String      SCOMP_SUM           = (String)request.getAttribute("SCOMP_SUM");  //본인
    String      WCOMP_SUM           = (String)request.getAttribute("WCOMP_SUM");  //배우자
    String      ICOMP_SUM           = (String)request.getAttribute("ICOMP_SUM");  //자녀05.10.28추가
    String      SCOMPING_SUM        = (String)request.getAttribute("SCOMPING_SUM");  //본인 진행중금액
    String      WCOMPING_SUM        = (String)request.getAttribute("WCOMPING_SUM");  //배우자 진행중금액
    String      ICOMPING_SUM        = (String)request.getAttribute("ICOMPING_SUM");  //자녀 진행중금액
    String      RequestPageName     = (String)request.getAttribute("RequestPageName");
    String      P_Flag              = (String)request.getAttribute("P_Flag");     //배우자지원한도예외자
    String      E_YEARS             = (String)request.getAttribute("E_YEARS");    //자녀나이년도
    String      E_MNTH              = (String)request.getAttribute("E_MNTH");     //자녀나이월수
    int medi_count = medi_count;
    String      E_COUPLEYN          = (String)request.getAttribute("E_COUPLEYN");   //Y: 사내커플인 경우 담당자 결재시 자녀 확인 메세지 처리 &시간제 근무 메시지 추가
    String      E_MESSAGE           = (String)request.getAttribute("E_MESSAGE");   //Y: 사내커플인 경우 담당자 결재시 자녀 확인 메세지 처리 &시간제 근무 메시지 추가
    //  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e17SickData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        } // end if
    } // end for
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
    //  통화키에 따른 소수자리수를 가져온다

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if


    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e17SickData.AINF_SEQN ,user.empNo ,false);
    int approvalStep = docinfo.getApprovalStep();

    Vector MediCode_vt = (new E17MediCodeRFC()).getMediCode();
    MediCode_vt = SortUtil.sort_num(MediCode_vt ,"code", "desc");

    Vector RcptCode_vt = (new E17RcptCodeRFC()).getRcptCode();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="${WebUtil.ImageURL }css/ehr.css" type="text/css">
<link rel="stylesheet" href="${WebUtil.ImageURL }css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="${WebUtil.ImageURL }css/ehr_wsg.css" type="text/css">

<script language="javascript" src="${WebUtil.ImageURL }js/snsscript.js"></script>


</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('${WebUtil.ImageURL }btn_help_on.gif');">
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
<input type="hidden" name="APPU_TYPE" value="${docinfo.getAPPU_TYPE()}">
<input type="hidden" name="APPR_SEQN" value="${docinfo.getAPPR_SEQN()}">

<input type="hidden" name="BUKRS" value="${user.companyCode}">

<INPUT TYPE="HIDDEN" NAME="PERNR"        VALUE="${e17SickData.PERNR}">
<INPUT TYPE="HIDDEN" NAME="BEGDA"        VALUE="${e17SickData.BEGDA}">
<INPUT TYPE="HIDDEN" NAME="AINF_SEQN"    VALUE="${e17SickData.AINF_SEQN}">
<INPUT TYPE="HIDDEN" NAME="CTRL_NUMB"    VALUE="${e17SickData.CTRL_NUMB}">
<INPUT TYPE="HIDDEN" NAME="SICK_DESC1"   VALUE="${e17SickData.SICK_DESC1}">
<INPUT TYPE="HIDDEN" NAME="SICK_DESC2"   VALUE="${e17SickData.SICK_DESC2}">
<INPUT TYPE="HIDDEN" NAME="SICK_DESC3"   VALUE="${e17SickData.SICK_DESC3}">
<INPUT TYPE="HIDDEN" NAME="SICK_DESC4"   VALUE="${e17SickData.SICK_DESC4}">
<INPUT TYPE="HIDDEN" NAME="WAERS"        VALUE="${e17SickData.WAERS}">
<INPUT TYPE="HIDDEN" NAME="BIGO_TEXT1"   VALUE="${e17SickData.BIGO_TEXT1}">
<INPUT TYPE="HIDDEN" NAME="BIGO_TEXT2"   VALUE="${e17SickData.BIGO_TEXT2}">
<INPUT TYPE="HIDDEN" NAME="BIGO_TEXT3"   VALUE="${e17SickData.BIGO_TEXT3}">
<INPUT TYPE="HIDDEN" NAME="BIGO_TEXT4"   VALUE="${e17SickData.BIGO_TEXT4}">
<INPUT TYPE="HIDDEN" NAME="GUEN_CODE"    VALUE="${e17SickData.GUEN_CODE}">
<INPUT TYPE="HIDDEN" NAME="ENAME"        VALUE="${e17SickData.ENAME}">
<INPUT TYPE="HIDDEN" NAME="RFUN_DATE"    VALUE="${e17SickData.RFUN_DATE}">
<INPUT TYPE="HIDDEN" NAME="RFUN_RESN"    VALUE="${e17SickData.RFUN_RESN}">
<INPUT TYPE="HIDDEN" NAME="RFUN_AMNT"    VALUE="${e17SickData.RFUN_AMNT}">
<INPUT TYPE="HIDDEN" NAME="BELNR1"       VALUE="${e17SickData.BELNR1}">
<INPUT TYPE="HIDDEN" NAME="OBJPS_21"     VALUE="${e17SickData.OBJPS_21}">
<INPUT TYPE="HIDDEN" NAME="REGNO"        VALUE="${e17SickData.REGNO}">
<INPUT TYPE="HIDDEN" NAME="DATUM_21"     VALUE="${e17SickData.DATUM_21}">
<INPUT TYPE="HIDDEN" NAME="POST_DATE"    VALUE="${e17SickData.POST_DATE}">
<INPUT TYPE="HIDDEN" NAME="BELNR"        VALUE="${e17SickData.BELNR}">
<INPUT TYPE="HIDDEN" NAME="ZPERNR"       VALUE="${e17SickData.ZPERNR}">
<INPUT TYPE="HIDDEN" NAME="ZUNAME"       VALUE="${e17SickData.ZUNAME}">
    <input type="hidden" name="ORG_CTRL"   value="${e17SickData.ORG_CTRL }"> <!-- 동일진료시 선택한원래관리번호CSR ID:1361257  -->
    <input type="hidden" name="LAST_CTRL"  value="${e17SickData.LAST_CTRL }"> <!-- 동일진료시 선택한원래관리번호의 마지막번호CSR ID:1361257  -->

<input type="hidden" name="HospitalRowCount" value="${medi_count }">
<input type="hidden" name="APPR_STAT">
<input type="hidden" name="RequestPageName"   value="${RequestPageName}">
<input type="hidden" name="approvalStep" value="${approvalStep}">
  <table width="791" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="subhead"><h2>의료비 결재 해야 할 문서</h2></td>
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
               	<div class="buttonArea">
               		<ul class="btn_crud">
               			<li><a class="darken" href="javascript:approval()"><span>결재</span></a></li>
               			<li><a href="javascript:reject()"><span>반려</span></a></li>
                       <% if (isCanGoList) {  %>
                       	<img src="${WebUtil.ImageURL }sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
               			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
                       <% } // end if %>
               		</ul>
               	</div>
            </td>
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
                        <div class="tableArea">
                        <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <th width="100" >신청일자</th>
                              <td width="261">${e17SickData.BEGDA.equals("0000-00-00")||e17SickData.BEGDA.equals("") ? "" : WebUtil.printDate(e17SickData.BEGDA)}</td>
                              <th class="th02" width="100">관리번호</th>
                              <td width="317">${e17SickData.CTRL_NUMB }</td>
                            </tr>
                            <tr>
                              <th>구분</th>
                              <td colspan="3">${WebUtil.printOptionText((new E17GuenCodeRFC()).getGuenCode(e17SickData.PERNR), e17SickData.GUEN_CODE) }&nbsp;&nbsp;&nbsp;

                              <% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { //담당자인 경우 수정가능 %>
                                   <%  if( e17SickData.GUEN_CODE.equals("0002") ) { %>
                                         <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF.equals("X") ? "checked" : "" } onClick="javascript:check_PROOF(this);">
                                          배우자 연말정산반영 여부
                                   <%  } else if( e17SickData.GUEN_CODE.equals("0003") ) { %>
                                         <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF.equals("X") ? "checked" : "" } onClick="javascript:check_PROOF(this);">
                                          자녀 연말정산반영 여부
                                   <%  } else if( e17SickData.GUEN_CODE.equals("0001") ) { %>
                                         <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF.equals("X") ? "checked" : "" }  onclick="javascript:this.checked=true;">
                                          본인 연말정산반영 여부
                                   <%  } else { %>
                                   <INPUT TYPE="HIDDEN" NAME="PROOF"        VALUE="${e17SickData.PROOF}">
                                   <%  } // end if %>
                              <% } else { %>
                                   <%  if( e17SickData.GUEN_CODE.equals("0002") ) { %>
                                         <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF.equals("X") ? "checked" : "" } disabled>
                                          배우자 연말정산반영 여부
                                   <%  } else if( e17SickData.GUEN_CODE.equals("0003") ) { %>
                                         <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF.equals("X") ? "checked" : "" } disabled>
                                          자녀 연말정산반영 여부
                                   <%  } else if( e17SickData.GUEN_CODE.equals("0001") ) { %>
                                         <input type="checkbox" name="PROOF" value="X" size="20" ${e17SickData.PROOF.equals("X") ? "checked" : "" }  onclick="javascript:this.checked=true;">
                                          본인 연말정산반영 여부

                                   <%  }   %>
                                   <INPUT TYPE="HIDDEN" NAME="PROOF"        VALUE="${e17SickData.PROOF}">
                              <% } %>

                              </td>
                            </tr>
<%
//  자녀일때 자녀를 선택할 수 있도록 한다.
    if( e17SickData.GUEN_CODE.equals("0003") ) {
        String REGNO_dis = e17SickData.REGNO.substring(0, 6) + "-*******";
        String Message   = "";
        int    dif       = 0;

        dif = DataUtil.getBetween(DataUtil.removeStructur(e17SickData.BEGDA,"-"), DataUtil.removeStructur(e17SickData.DATUM_21,"-"));

        //if( dif < 0 ) {
        if( Integer.valueOf(E_YEARS) >= 20 ) {
            //Message = e17SickData.ENAME + "는 " + e17SickData.DATUM_21.substring(0,4) + "년 " + e17SickData.DATUM_21.substring(5,7) + "월 부터 자녀의료비지원 대상에서 제외되며, " + e17SickData.DATUM_21.substring(5,7) + "월 전월 의료비까지 지원 가능합니다.";
            Message = "의료비 신청 대상자가 만 20세 이상입니다. 관련 증빙 서류를 확인하여 처리하세요";
        }
%>
                            <tr>
                              <th rowspan="2">자녀이름</th>
                              <td>${e17SickData.ENAME }</td>
                              <th class="th02">자녀주민번호</th>
                              <td>${f:printRegNo(e17SickData.REGNO, "LAST")  }</td>
                            </tr>
                            <tr>
                              <td colspan="3"><b><font color=blue>${Message }</b></font></td>
                            </tr>
<%
    }
%>

<% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { %>
                      <tr>
                        <th>진료과&nbsp;<font color="#006699"><b>*</b></font></th>
                        <td>
                          <select name="TREA_CODE" onChange="javascript:document.form1.TREA_TEXT.value = this.options[this.selectedIndex].text;">
                          <option value="">--------</value>
${WebUtil.printOption((new E17MedicTreaRFC()).getMedicTrea(), e17SickData.TREA_CODE) }
                          </select>
                        </td>
                      </tr>
<% } else { %>
                      <tr>
                        <th>진료과</th>
                        <td colspan="3">${WebUtil.printOptionText((new E17MedicTreaRFC()).getMedicTrea(), e17SickData.TREA_CODE) }</td>
                      </tr>
                      <input type="hidden" name="TREA_CODE" value="${e17SickData.TREA_CODE }">
<% } %>
                      <input type="hidden" name="TREA_TEXT" value="${e17SickData.TREA_TEXT }">
                            <tr>
                              <th>상병명</th>
                              <td colspan="3">
<% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { %>
                               <input type="text" name="SICK_NAME" value="${e17SickData.SICK_NAME }" size="40">

<% } else { %>

<INPUT TYPE="HIDDEN" NAME="SICK_NAME"    VALUE="${e17SickData.SICK_NAME}">
                              ${e17SickData.SICK_NAME }
<% } %>
                              </td>
                            </tr>
                            <tr>
                              <th>구체적증상</th>
                              <td colspan="3">
                                ${e17SickData.SICK_DESC1}<br>
                                ${e17SickData.SICK_DESC2}<br>
                                ${e17SickData.SICK_DESC3}<br>
                                ${e17SickData.SICK_DESC4}
                            </td>
                            </tr>
                            <tr>
                              <th>비고</th>
                              <td colspan="3">${e17SickData.BIGO_TEXT1%><br><%=e17SickData.BIGO_TEXT2%>
                              </td>
                            </tr>
                          </table>
                          </div>
                          </td>
                      </tr>
                      <tr>
                        <td>
                        	<div class="tableArea">
                            <table border="0" cellspacing="0" cellpadding="0" class="listTable">
                                <tr>

                            <th width="75">의료기관</th>
                            <th width="75">사업자<br>등록번호</th>
                            <th width="75">전화번호</th>
                            <th width="130">진료일</th>
                            <th width="55">입원<br>/외래</th>
                            <th width="110">영수증 구분</th>
                            <th width="30" >No.</th>
                            <th width="70">결재수단</th>
                            <th width="70">본인<br>실납부액</th>
                            <th class="lastCol" width="75">연말정산<br>반영액</th>
                                </tr>
                            <%
                               double totEMPL_WONX = 0;
                            %>
                            <%  String MEDI_MTHD_TEXT = "";//@v1.3
                                for( int i = 0 ; i < medi_count ; i++ ){ %>
                                <% E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
                                   //@v1.3
                                   if (e17HospitalData.MEDI_MTHD.equals("1"))
                                       MEDI_MTHD_TEXT = "현금";
                                   else if (e17HospitalData.MEDI_MTHD.equals("2"))
                                       MEDI_MTHD_TEXT = "신용카드";
                                   else if (e17HospitalData.MEDI_MTHD.equals("3"))
                                       MEDI_MTHD_TEXT = "현금영수증";
                                   else  MEDI_MTHD_TEXT = "";

                                   String tr_class = "";

                                   if(i%2 == 0){
                                       tr_class="oddRow";
                                   }else{
                                       tr_class="";
                                   }
                                %>
                                <tr class="${tr_class}">
                                    <input type="hidden" name="BEGDA${status.index}"        value="<%=e17HospitalData.BEGDA}">
                                    <input type="hidden" name="PERNR${status.index}"        value="<%=e17HospitalData.PERNR}">
                                    <input type="hidden" name="CTRL_NUMB${status.index}"    value="<%=e17HospitalData.CTRL_NUMB}">
                                    <input type="hidden" name="AINF_SEQN${status.index}"    value="<%=e17HospitalData.AINF_SEQN}">
                                    <!--<input type="hidden" name="EXAM_DATE${status.index}"    value="<%=e17HospitalData.EXAM_DATE}">-->
                                    <input type="hidden" name="RCPT_NUMB${status.index}"    value="<%=e17HospitalData.RCPT_NUMB}">
                                    <input type="hidden" name="WAERS${status.index}"        value="<%=e17HospitalData.WAERS}">
                                    <input type="hidden" name="COMP_WONX${status.index}"    value="<%=e17HospitalData.COMP_WONX}">
                                    <td>
<% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { //CSR ID:1357074 %>
                                          <input type="text" name="MEDI_NAME${i}" value="${e17HospitalData.MEDI_NAME.trim() }" size="10">
<% } else { %>
                                          ${e17HospitalData.MEDI_NAME.trim() }
                                          <input type="hidden" name="MEDI_NAME${status.index}"    value="<%=e17HospitalData.MEDI_NAME}">
<% }  %>
                                    </td>
                                    <td>
<% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { //CSR ID:1357074 %>
                                          <input type="text" name="MEDI_NUMB${i}" value="${e17HospitalData.MEDI_NUMB.equals("") ? "" : DataUtil.addSeparate2(e17HospitalData.MEDI_NUMB) }" size="10"  maxlength="12" onBlur="businoFormat(this);">
<% } else { %>
                                          ${e17HospitalData.MEDI_NUMB.equals("") ? "" : DataUtil.addSeparate2(e17HospitalData.MEDI_NUMB) }
                                          <input type="hidden" name="MEDI_NUMB${status.index}"    value="<%=e17HospitalData.MEDI_NUMB}">
<% }  %>
                                    </td>
                                    <td>
<% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { //CSR ID:1357074 %>
                                        <input type="text" name="TELX_NUMB${i}" value="${e17HospitalData.TELX_NUMB }" size="10" maxlength="13" onBlur="phone_1(this);">
 <% } else { %>
                                        ${e17HospitalData.TELX_NUMB }
                                        <input type="hidden" name="TELX_NUMB${status.index}"    value="<%=e17HospitalData.TELX_NUMB}">
<% }  %>
                                    </td>
                                    <td>
                                      <% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { %>
                                        <input type="text" name="EXAM_DATE${i}" onBlur="dateFormat(this);" value="${ e17HospitalData.EXAM_DATE.equals("0000-00-00")||e17HospitalData.EXAM_DATE.equals("") ? "" : WebUtil.printDate(e17HospitalData.EXAM_DATE) }" size="9">
                                        <!-- 날짜검색-->
                                        <a href="javascript:fn_openCal('EXAM_DATE${i}')">
                                        <img src="${WebUtil.ImageURL }btn_serch.gif" align="absmiddle" border="0" alt="날짜검색"></a>
                                        <!-- 날짜검색-->
                                      <% } else { %>
                                         <input type="hidden" name="EXAM_DATE${status.index}"    value="<%=e17HospitalData.EXAM_DATE}">
                                        ${ e17HospitalData.EXAM_DATE.equals("0000-00-00")||e17HospitalData.EXAM_DATE.equals("") ? "" : WebUtil.printDate(e17HospitalData.EXAM_DATE) }
                                      <% } %>
                                    </td>
                                    <td>
                                      <!-- 영수증 구분   -->
<% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { //CSR ID:1357074 %>
                                      <select name="MEDI_CODE${i}" >
                                        <!--  option -->
                                        ${WebUtil.printOption(MediCode_vt, e17HospitalData.MEDI_CODE)}
                                        <!--  option -->
                                      </select>
 <% } else { %>
                                      ${e17HospitalData.MEDI_TEXT.trim() }
                                    <input type="hidden" name="MEDI_CODE${status.index}"    value="<%=e17HospitalData.MEDI_CODE}">

<% }  %>
                                    </td>
                                    <td>
<% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { //CSR ID:1357074 %>
                                         <!-- 영수증 구분   -->
                                         <select name="RCPT_CODE${i}" onChange="javascript:return;chg_opt(this);">
                                           <!--  option -->
                                           ${WebUtil.printOption(RcptCode_vt, e17HospitalData.RCPT_CODE)}
                                           <!--  option -->
                                         </select>
 <% } else { %>
                                         <input type="hidden" name="RCPT_CODE${status.index}"    value="<%=e17HospitalData.RCPT_CODE}">
                                         ${e17HospitalData.RCPT_TEXT.trim() }
<% }  %>
                                    </td>
                                    <td>
                                         ${e17HospitalData.RCPT_NUMB }
                                    </td>
                                    <td><!--@v1.3-->
                                      <% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { %>
                              <select name="MEDI_MTHD${i}">
                              <option value="2" ${e17HospitalData.MEDI_MTHD.equals("2") ? "selected" : "" }>신용카드</option>
                              <option value="3" ${e17HospitalData.MEDI_MTHD.equals("3") ? "selected" : "" }>현금영수증</option>
                              <option value="1" ${e17HospitalData.MEDI_MTHD.equals("1") ? "selected" : "" }>현금</option>
                              </select>
                                      <% } else { %>
                                         ${MEDI_MTHD_TEXT }
                                         <input type="hidden" name="MEDI_MTHD${status.index}"    value="<%=e17HospitalData.MEDI_MTHD}">
                                      <% } %>
                                    </td>
                                    <td>
                                      <% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) { %>
                                          <%  if (e17SickData.WAERS.equals("KRW") ||e17SickData.WAERS.equals("\\") ) {   %>

                                       <input type="text" name="EMPL_WONX${i}" value="${e17HospitalData.EMPL_WONX.equals("") ? "" : WebUtil.printNumFormat(DataUtil.removeStructur(e17HospitalData.EMPL_WONX,","),currencyValue) }" size="10" style="text-align:right" onKeyUp="javascript:moneyChkEventForWon(this);" onBlur="javascript:multiple_won();">
                                          <%  } else { %>
                                       <input type="text" name="EMPL_WONX${i}" value="${e17HospitalData.EMPL_WONX.equals("") ? "" : WebUtil.printNumFormat(DataUtil.removeStructur(e17HospitalData.EMPL_WONX,","),currencyValue) }" size="10" style="text-align:right" onKeyUp="javascript:moneyChkEventForWorld(this);" onBlur="javascript:multiple_won();">

                                          <%  }  %>
                                      <% } else { %>
                                    <input type="hidden" name="EMPL_WONX${status.index}"    value="<%=e17HospitalData.EMPL_WONX}">
                                         ${WebUtil.printNumFormat(e17HospitalData.EMPL_WONX,currencyValue) }
                                      <% } %>
                                    </td>
                                    <td class="lastCol"><!--@v1.3-->

                                      <% if ( DocumentInfo.DUTY_CHARGER ==approvalStep  ) {
                                            if (e17SickData.WAERS.equals("KRW") ||e17SickData.WAERS.equals("\\") ) { // @v1.2 %>
                                             <input type="input" size=9 name="YTAX_WONX${status.index}" value="${ !(e17SickData.PROOF.equals("")&&!e17SickData.GUEN_CODE.equals("0001")) && (e17HospitalData.YTAX_WONX.equals("0.0")||e17HospitalData.YTAX_WONX.equals("0")) ? WebUtil.printNumFormat(e17HospitalData.EMPL_WONX,currencyValue) : WebUtil.printNumFormat(e17HospitalData.YTAX_WONX,currencyValue) }" style="text-align:right" onKeyUp="javascript:moneyChkEventForWon(this);"  onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0; else sumCalc(this,<%=i});">
                                     <%     } else { %>
                                             <input type="input" size=9 name="YTAX_WONX${status.index}" value="${!(e17SickData.PROOF.equals("")&&!e17SickData.GUEN_CODE.equals("0001")) && (e17HospitalData.YTAX_WONX.equals("0.0")||e17HospitalData.YTAX_WONX.equals("0")) ? WebUtil.printNumFormat(e17HospitalData.EMPL_WONX,currencyValue) : WebUtil.printNumFormat(e17HospitalData.YTAX_WONX,currencyValue) }" style="text-align:right" onKeyUp="javascript:moneyChkEventForWorld(this);"  onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0; else sumCalc(this,<%=i});">
                                     <%     }
                                         } else { %>
                                      <input type="input" size=9 name="YTAX_WONX${i}" value="${ e17HospitalData.YTAX_WONX.equals("") ? "" : WebUtil.printNumFormat(e17HospitalData.YTAX_WONX,currencyValue) }"  readonly style="text-align:right" >
                                      <% } %>
                                    </td>
                                    <%
                                         totEMPL_WONX += Double.parseDouble(e17HospitalData.EMPL_WONX);
                                    %>
                                </tr>
                            <% } // end for %>
                            </table>
                            </div>
                          </td>
                      </tr>
                      <tr>
                        <td>
                            <table width="760" border="0" cellspacing="0" cellpadding="2">
                                <tr>
                                  <!--<td width="180"> &nbsp; </td>-->
                                  <td>
                                  	<div class="tableArea">
                                    <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
<%
    double   TempCompanySum_1=0.0;
	double   TempCompanySum_2=0.0;
    double   TempCompanySum_3=0.0;


  /*  if ( e17SickData.GUEN_CODE.equals("0001") ) {
    	 TempCompanySum = Double.parseDouble(SCOMP_SUM)-Double.parseDouble(SCOMPING_SUM);
    }
    else  if (e17SickData.GUEN_CODE.equals("0002")) {
        TempCompanySum = Double.parseDouble( WCOMP_SUM)-Double.parseDouble(WCOMPING_SUM);
    }else  if (e17SickData.GUEN_CODE.equals("0003") ) {
        TempCompanySum = Double.parseDouble(ICOMP_SUM)-Double.parseDouble(ICOMPING_SUM);
    }  */
    TempCompanySum_1 = Double.parseDouble(SCOMP_SUM)-Double.parseDouble(SCOMPING_SUM);
    TempCompanySum_2 = Double.parseDouble( WCOMP_SUM)-Double.parseDouble(WCOMPING_SUM);
    TempCompanySum_3 = Double.parseDouble(ICOMP_SUM)-Double.parseDouble(ICOMPING_SUM);

    // [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원
    if ( e17SickData.GUEN_CODE.equals("0001") ) { // 본인 신청 시 본인의 진행금액만 보임
%>
                                        <th>진행중 회사지원액</th>
                                        <td width="100">${e17SickData.GUEN_CODE.equals("0001") ?  WebUtil.printNumFormat(SCOMPING_SUM,currencyValue)  :e17SickData.GUEN_CODE.equals("0002") ?  WebUtil.printNumFormat(WCOMPING_SUM,currencyValue) :  WebUtil.printNumFormat(ICOMPING_SUM,currencyValue)  %> <%= e17SickData.WAERS }</td>
                                        <th class="th02">회사지원총액</th>
                                        <td>${e17SickData.GUEN_CODE.equals("0001") ? WebUtil.printNumFormat(String.valueOf (TempCompanySum_1) ,currencyValue)   :e17SickData.GUEN_CODE.equals("0002") ? WebUtil.printNumFormat(String.valueOf (TempCompanySum_2) ,currencyValue) : WebUtil.printNumFormat(String.valueOf (TempCompanySum_3) ,currencyValue)  %> <%= e17SickData.WAERS }</td>                                      <td width="30"  class="td04">&nbsp;</td>
                                        <th class="th02">계</th>
                                        <td >
                                            <!--%=WebUtil.printNumFormat(totEMPL_WONX,currencyValue)%-->
                                            <input type="text" name="totEMPL_WONX" size="11" style="text-align:right" value="${WebUtil.printNumFormat(totEMPL_WONX,currencyValue)}" readonly>${e17SickData.WAERS }
                                        </td>
<%}else{ //배우자 또는 자녀 신청 시 두개 합산금액의 1000만원 한도이므로 둘 다 보여준다. %>
										<th>배우자</th>
										<th width="100">진행중<br>회사지원액&nbsp;</th>
                                        <td width="90">${ WebUtil.printNumFormat(WCOMPING_SUM,currencyValue)  %> <%= e17SickData.WAERS }</td>
                                        <th class="t02">회사지원총액&nbsp;</td>
                                        <td>${WebUtil.printNumFormat(String.valueOf (TempCompanySum_2) ,currencyValue) %> <%= e17SickData.WAERS }</td>                                      <td width="30"  class="td04">&nbsp;</td>
                                        <th rowspan="2">계</hd>
                                        <td rowspan="2">
                                            <!--%=WebUtil.printNumFormat(totEMPL_WONX,currencyValue)%-->
                                            <input type="text" name="totEMPL_WONX" size="11" style="text-align:right" value="${WebUtil.printNumFormat(totEMPL_WONX,currencyValue)}" readonly>${e17SickData.WAERS }
                                        </td>
                                        </tr>
                                        <tr>
                                        <th width="40" >자녀</th>
                                        <th class="th02" width="100">진행중<br>회사지원액&nbsp;</th>
                                        <td width="90">${WebUtil.printNumFormat(ICOMPING_SUM,currencyValue) } ${e17SickData.WAERS }</td>
                                        <th class="th02">회사지원총액&nbsp;</th>
                                        <td>${WebUtil.printNumFormat(String.valueOf (TempCompanySum_3) ,currencyValue) } ${e17SickData.WAERS }</td>                                      <td width="30"  class="td04">&nbsp;</td>
                                        </tr>


<%} %>
                                      </tr>
                                    </table>
                                    </td>
                                  </td>
                                </tr>

                            <%  if (approvalStep == DocumentInfo.POST_MANGER) { %>
                                <input type="hidden" name="YTAX_WONX" value="${e17SickData.YTAX_WONX}">
                                <input type="hidden" name="COMP_WONX" value="${e17SickData.COMP_WONX}">
                            <%  } else if (approvalStep == DocumentInfo.DUTY_CHARGER ) { %>
                                <%
                                    double  dSCOMP_SUM = Double.parseDouble(SCOMP_SUM);
                                    double  dWCOMP_SUM = Double.parseDouble(WCOMP_SUM);
                                    double  dICOMP_SUM = Double.parseDouble(ICOMP_SUM);
                                    //out.println("e17SickData.CTRL_NUMB.substring(7,9):"+e17SickData.CTRL_NUMB.substring(7,9));
                                    if (e17SickData.GUEN_CODE.equals("0001")) {
                                        // 본인
                                        //@v1.5 if (dSCOMP_SUM == 0) {
                                        if (e17SickData.CTRL_NUMB.substring(7,9).equals("01")) {
                                            // 최초 신청
                                            if (totEMPL_WONX< 100000)  //@v1.4
                                                e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                                            else
                                                e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX - 100000);
                                        } else {

                                            e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                                        } // end if
                                        e17SickData.YTAX_WONX = String.valueOf(totEMPL_WONX);
                                    } else {
                                        if (P_Flag.equals("Y") && e17SickData.GUEN_CODE.equals("0002")) {
                                            // 배우자 지원 한도 미 적용
                                                if (e17SickData.CTRL_NUMB.substring(7,9).equals("01")) {

                                                    // 최초 신청
                                                    //e17SickData.COMP_WONX = String.valueOf((totEMPL_WONX - 100000)/2);
                                                    //@1.6 배우자본인과 똑같이 100%지원으로 변경
                                                    if (totEMPL_WONX< 100000)
                                                        e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                                                    else
                                                        e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX - 100000);

                                                } else {
                                                    e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                                                } // end if

                                        } else {
                                            // [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원
                                            //double dFlag = 5000000; //@v1.5
                                            double dFlag = 10000000;//배우자+자녀
                                            double dTemp = 0;
                                            double totEMPL_WONXH = totEMPL_WONX; //@v1.5
                                            double dWICOMP_SUM;
                                           //if (e17SickData.GUEN_CODE.equals("0002") )
                                            //    dWICOMP_SUM = dWCOMP_SUM;
                                           // else
                                            //    dWICOMP_SUM = dICOMP_SUM;
                                                dWICOMP_SUM = dWCOMP_SUM + dICOMP_SUM;

                                            //@1.6 배우자본인과 똑같이 100%지원으로 변경
                                            if (e17SickData.GUEN_CODE.equals("0002")) {
                                                if (e17SickData.CTRL_NUMB.substring(7,9).equals("01")) {
                                                    // 최초 신청
                                                    if ( (totEMPL_WONX - 100000) > dFlag)
                                                        dTemp = dFlag;
                                                    else {
                                                        if (totEMPL_WONX < 100000) //@v1.4
                                                           dTemp = totEMPL_WONX;
                                                        else
                                                           dTemp = (totEMPL_WONX - 100000);
                                                    }
                                                    //out.println("dTemp배우자최초 신청:"+dTemp);

                                                    if ( (dTemp+dWICOMP_SUM) > dFlag) {
                                                        dTemp = dFlag - dWICOMP_SUM;
                                                    }

                                                } else {
                                                    dTemp = (dWICOMP_SUM + totEMPL_WONXH); //이미사용한금액+신청금액합
                                                    if (dTemp > dFlag) {
                                                        dTemp = dFlag - dWICOMP_SUM;
                                                    } else {
                                                        dTemp = totEMPL_WONXH;//@v1.5
                                                    } // end if
                                                } // end if
                                            }
                                            //배우자 와 자녀 로직 분리: 2005.10.28일추가(제도 미반영에러로 인하여)
                                            else if (e17SickData.GUEN_CODE.equals("0003")) { //자녀
                                                //@v1.5 if (dWICOMP_SUM == 0) {
                                                if (e17SickData.CTRL_NUMB.substring(7,9).equals("01")) {
                                                    // 최초 신청
                                                    if ( (totEMPL_WONX - 100000)/2 > dFlag)
                                                        dTemp = dFlag;
                                                    else {
                                                        if (totEMPL_WONX < 100000) //@v1.4
                                                           dTemp = totEMPL_WONX/2;
                                                        else
                                                           dTemp = (totEMPL_WONX - 100000)/2;
                                                    }
                                                    //out.println("dTemp배우자최초 신청:"+dTemp);

                                                    if ( (dTemp+dWICOMP_SUM) > dFlag) {
                                                        dTemp = dFlag - dWICOMP_SUM;
                                                    }

                                                } else {
                                                    dTemp = (dWICOMP_SUM + totEMPL_WONXH/2); //이미사용한금액+신청금액합
                                                    if (dTemp > dFlag) {
                                                        dTemp = dFlag - dWICOMP_SUM;
                                                    } else {
                                                        dTemp = totEMPL_WONXH/2;//@v1.5
                                                    } // end if
                                                } // end if
                                            }

                                            if (dTemp < 0) //@v1.4
                                                e17SickData.COMP_WONX = String.valueOf(totEMPL_WONXH);
                                            else
                                                e17SickData.COMP_WONX = String.valueOf(dTemp); //회사지원최종금액
                                            if (e17SickData.PROOF.equals("X")) {
                                                e17SickData.YTAX_WONX = String.valueOf(totEMPL_WONX);
                                            } else {
                                                e17SickData.YTAX_WONX = "0";
                                            } // end if

                                            e17SickData.COMP_WONX = String.valueOf(Double.parseDouble(e17SickData.COMP_WONX) / 1);

                                        } // end if
                                    } // end if
                                %>
                                <tr>
                                  <td width="760">
                                  	<div class="tableArea">
	                                    <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
	                                      <tr>
	                                      	<td width="40" class="td04"/>
	                                        <td width="100" class="td04"></td>
	                                        <td width="90" class="td04"></td>

	                                        <th>연말정산반영액</th>
	                                        <td>
	                                            <% if (e17SickData.WAERS.equals("KRW") ||e17SickData.WAERS.equals("\\") ) { // @v1.2 %>
	                                            <input type="text" NAME="YTAX_WONX" value="${WebUtil.printNumFormat(e17SickData.YTAX_WONX ,currencyValue)}" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEventForWon(this);"  onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03" readonly>
	                                            <% } else { %>
	                                            <input type="text" NAME="YTAX_WONX" value="${WebUtil.printNumFormat(e17SickData.YTAX_WONX ,currencyValue)}" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEventForWorld(this);"  onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03" readonly>
	                                            <% }%>

	                                            ${e17SickData.WAERS }
	                                        </td>
	                                        <td width="30">&nbsp;</td>
	                                        <th>회사지원액</th>
	                                        <td>
	                                            <% if (e17SickData.WAERS.equals("KRW") ||e17SickData.WAERS.equals("\\") ) { // @v1.2 %>
	                                            <input type="text" NAME="COMP_WONX" value="${WebUtil.printNumFormat(e17SickData.COMP_WONX ,currencyValue) }" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEventForWon(this);" onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03">
	                                            <% } else { %>
	                                            <input type="text" NAME="COMP_WONX" value="${WebUtil.printNumFormat(e17SickData.COMP_WONX ,currencyValue) }" size="13" style="text-align:right" onKeyUp="javascript:moneyChkEventForWorld(this);" onFocus="this.select();" onBlur="if(this.value == '' ) this.value = 0;" class="input03">
	                                            <% }%>
	                                            ${e17SickData.WAERS }
	                                        </td>
	                                      </tr>
	                                    </table>
                                    </div>
                                  </td>
                                </tr>
                            <%  } else if (approvalStep == DocumentInfo.DUTY_MANGER) { %>
                                <tr>
                                  <td width="760">
                                  	<div class="tableArea">
                                    <table class="tableGeneral" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                      	<td width="40" class="td04"/>
                                        <td width="100" class="td04"></td>
                                        <td width="90" class="td04"></td>
                                        <th>연말정산반영액</th>
                                        <td>
                                            ${WebUtil.printNumFormat(e17SickData.YTAX_WONX ,currencyValue) %> <%= e17SickData.WAERS }
                                            <INPUT TYPE="HIDDEN" NAME="YTAX_WONX"    VALUE="${e17SickData.YTAX_WONX}">
                                        </td>
                                        <td width="30"  class="td04">&nbsp;</td>
                                        <th class="th02">회사지원액</th>
                                        <td>
                                            ${WebUtil.printNumFormat(e17SickData.COMP_WONX ,currencyValue) %> <%= e17SickData.WAERS }
                                            <INPUT TYPE="HIDDEN" NAME="COMP_WONX"    VALUE="${e17SickData.COMP_WONX}">
                                        </td>
                                      </tr>
                                    </table>
                                    </div>
                                  </td>
                                </tr>
                            <%  } // end if %>
                            </table>
                          </td>
                      </tr>
                    </table></td>
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
                       <td width="80" class="td03">${ald.APPL_ENAME}</td>
                       <td class="td09">${ald.APPL_BIGO_TEXT}</td>
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
            				<td><textarea name="BIGO_TEXT" cols="100" rows="4">${tmpBigo}</textarea></td>
            			</tr>
                	</table>
                </div>
            </td>
          </tr>
          <tr>
            <td>
            	<table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td><h2 class="subtitle">결재정보</h2></td>
                </tr>
                <tr>
                  <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>
                          <!--결재정보 테이블 시작-->
                          ${AppUtil.getAppDetail(vcAppLineData) }
                          <!--결재정보 테이블 끝-->
                        </td>
                      </tr>
                    </table></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>
                  <!--버튼 들어가는 테이블 시작 -->
                  	<div class="buttonArea">
                  		<ul class="btn_crud">
                  			<li><a class="darken" href="javascript:approval()"><span>결재</span></a></li>
                  			<li><a href="javascript:reject()"><span>반려</span></a></li>
                          <% if (isCanGoList) {  %>
                          	<img src="${WebUtil.ImageURL }sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
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
<!-- hidden field : common -->
</form>
<script>

</script>
<%@ include file="/web/common/commonEnd.jsp" %>
--%>

<%--
/******************************************************************************/
/*                                                                            */
/*   System Name  : MSS                                                       */
/*   1Depth Name  : MY HR 정보                                                */
/*   2Depth Name  : 초과근무                                                  */
/*   Program Name : 초과근무 신청                                             */
/*   Program ID   : D01OTBuild.jsp                                            */
/*   Description  : 초과근무(OT/특근)신청을 하는 화면                         */
/*   Note         :                                                           */
/*   Creation     : 2002-01-15  박영락
/*   Update       : 2005-03-03  윤정현
/*                  2008-06-10  CSR ID:1279434 간부사원이상만 신청가능
/*                  2009-10-26  CSR ID:1546748 여수공장 사유 목록화처리
/*                              사원서브그룹 사무직  시작시간은 무조건 9시 이전, 종료시간은 무조건 18시 이후만입력가능하게 추가
/*                              PERNR_Data.E_PERSK :22
/*                  2009-12-08  CSR ID:1574196 BACA 대산공장은   8시~17시 이후만입력가능하게 변경
/*                  2010-10-13  33 기능직도 사후신청 가능하게 품 C20101011_51420
/*                              사무직외에 PL미만(직책:FO0미만) 사무직 전원
/*                  2011-11-30  BBIA 파주공장은 휴게시간 로직 제외하기
/*                  2013-06-28  휴게시간1시간이상 입력 체크 ,자기자신은 수정가능하게
/*                  2014-02-07  C20140203_79594  인사하위영역 BA00, BACA 인 경우 일근직인 경우만 휴게시간 셋팅
/*                  2015-03-13  [CSR ID:2727336] HR-근태신청 오류 수정요청의 건
/*                  2015-06-18  [CSR ID:2803878] 초과근무 신청 Process 변경 요청
/*                  2015-12-16  [CSR ID:2941146] 여수공장 근무시간 관련
/*                  2016-09-20  GEHR통합작업 -KSC
/*                  2016-09-20  통합구축 - 김승철
/*                  2017-04-06  eunha  기 신청건과의 중복체크로직 오류조치
/*                  2018-02-12  rdcamel [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청
/*                  2018-03-05  rdcamel [CSR ID:3620968] 사무직 e-HR 초과근로 신청 가능시간 Logic 수정 요청
/*                  2018-05-15  Kang    [WorkTime52]    주52시간 근로시간 단축 대응 PJT
/******************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="org.apache.commons.lang.ObjectUtils" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%
    // browser에서 CSS를 caching하지 못하도록 처리하기 위한 변수
    request.setAttribute("noCache", "?" + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(java.util.Calendar.getInstance().getTime()));

    WebUserData user = (WebUserData) session.getAttribute("user");
    String jobid = (String) request.getAttribute("jobid");
    Vector OTHDDupCheckData_vt = (Vector) request.getAttribute("OTHDDupCheckData_vt");
    String PRECHECK = (String) request.getAttribute("PRECHECK");//[CSR ID:2803878] 초과근무 전일근태 체크 가능 여부
    String PERNR = (String) request.getAttribute("PERNR");

    Vector D01OTData_vt = (Vector) request.getAttribute("D01OTData_vt");
    D01OTData data = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

    //[CSR ID:2803878] 초과근무
    String sum 			= null;
    String OTDTMonth 	= null;
    String person_flag	= null;

    Vector SubmitData_vt = (Vector) request.getAttribute("submitData_vt");
    if (SubmitData_vt != null) {
        sum = SubmitData_vt.get(1).toString();
        // 2015-10-21  @marco
        // 소수점 둘째자리에서 반올림
        sum = DataUtil.banolim(sum, 1);
        person_flag = SubmitData_vt.get(2).toString();
        OTDTMonth = SubmitData_vt.get(4).toString();
    }

    String message = ObjectUtils.toString(request.getAttribute("message"), "");    // 결재의뢰 점검메시지처리를 위해

//  2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
    String E_RRDAT = new GetTimmoRFC().GetTimmo(user.companyCode);
    long   D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT, "-"));

    PersonData PERNR_Data = (PersonData) request.getAttribute("PersonData");

  //[WorkTime52] --------------------------------------------------------------------------
    String W_DUEDT_F = "";
    String W_DUEDT_T = "";
    String E_BASTM = "";
    String E_MAXTM = "";
    String E_PWDWK = "";
    String E_PWEWK = "";
    String E_CWDWK = "";
    String E_CWEWK = "";
    String E_SUMPW = "";
    String E_SUMCW = "";
    String E_RWKTM = "";

    String E_MSTOT = ""; //초과근로 메세지용 시간

    String E_HOLID = "";
    String E_SOLLZ = "";
    String E_SHIFT = "";

    String H_BASTM = "";	//현장직 법정최대한도
    String H_RWSUM = "";    //현장직 총근로시간:누적근로시간
    String H_RWTOT = "";    //현장직 총근로시간:계획근로시간
    String H_RWWEK = "";    //주단위 근로시간
    String H_WKDAY = "";    //일수
    String H_RTSUM = "";    //계산용..

    String HolidayYN = "";
    //------------------------------------------------//
    String EMPGUB  = (String) request.getAttribute("EMPGUB");	// 사원구분(S:사무직 H:현장직)
    String TPGUB   = (String) request.getAttribute("TPGUB");	// 근무구분(A:사무직일반 / B:현장직일반 / C:사무직선택근무제 / D:현장직선택근로제 / X:비대상)
    String R_DATUM = (String) request.getAttribute("DATUM");

    // 실근로시간 조회
    if (EMPGUB.equals("S")) {
        D01OTRealWorkDATA Work_Data_S = (D01OTRealWorkDATA) request.getAttribute("WorkData");
        E_BASTM	= Work_Data_S.BASTM; //기본근무
        E_MAXTM	= Work_Data_S.MAXTM; //법정최대근무시간
        E_PWDWK	= Work_Data_S.PWDWK; //평일 근무시간-개인입력
        E_PWEWK	= Work_Data_S.PWEWK; //평일 근무시간-회사인정
        E_CWDWK	= Work_Data_S.CWDWK; //주말/휴일 근무시간-개인입력
        E_CWEWK	= Work_Data_S.CWEWK; //주말/휴일 근무시간-회사인정
        E_SUMPW	= Work_Data_S.PWTOT;
        E_SUMCW	= Work_Data_S.CWTOT;
        E_RWKTM	= Work_Data_S.RWKTM; //실근무시간

    } else {
        W_DUEDT_F = ((String) request.getAttribute("BEGDA")).substring(5,7)+"/"+ ((String)request.getAttribute("BEGDA")).substring(8,10);
        W_DUEDT_T = ((String) request.getAttribute("ENDDA")).substring(5,7)+"/"+ ((String)request.getAttribute("ENDDA")).substring(8,10);

        H_RWSUM = (String) request.getAttribute("RWSUM");
        H_RWTOT = (String) request.getAttribute("RWTOT");
    }
    //[WorkTime52] --------------------------------------------------------------------------

    //CSR ID:1546748
    String DATUM = DataUtil.getCurrentDate();

    Vector D03VocationAReason_vt = new D03VocationAReasonRFC().getSubtyCode(user.companyCode, data.PERNR, "2005",DATUM);
    Vector newOpt = new Vector();
    for (int i = 0; i < D03VocationAReason_vt.size(); i++) {
        D03VocationReasonData old_data = (D03VocationReasonData) D03VocationAReason_vt.get(i);
        CodeEntity code_data = new CodeEntity();
        code_data.code = old_data.SCODE ;
        code_data.value = old_data.STEXT ;
        newOpt.addElement(code_data);
    }

    String Display_yn = "Y";
    if (PERNR_Data.E_PERSK.equals("11")||PERNR_Data.E_PERSK.equals("12")||PERNR_Data.E_PERSK.equals("13")||
        PERNR_Data.E_PERSK.equals("14")||PERNR_Data.E_PERSK.equals("21")) {  // CSR ID:1279434 @v1.0 간부사원은 신청하지못한다
        Display_yn = "N";
    }

    //C20100812_18478 휴일근무 신청 대상자 조정 :팀장미만 신청가능
    String OTbuildYn = new D03VocationAReasonRFC().getE_OVTYN(PERNR_Data.E_BUKRS, PERNR_Data.E_PERNR, "2005", DATUM);
    String E_BTRTL   = new D03VocationAReasonRFC().getE_BTRTL(PERNR_Data.E_BUKRS, PERNR_Data.E_PERNR, "2005", DATUM);
    //※C20120113_33260 휴일근무,반일특근 및 체크로직 대상자GET 사무지도직(S):휴일특근,반일특근신청가능 ,전문기능(T) : 사전신청가능
    String E_PERSKG  = new D03VocationAReasonRFC().getE_PERSKG(PERNR_Data.E_BUKRS, PERNR_Data.E_PERNR, "2005", DATUM);

    //C20140203_79594 일근직체크
    D03ShiftCheckRFC func_shift = new D03ShiftCheckRFC();
    String shiftCheck = func_shift.check(PERNR_Data.E_PERNR, DATUM);    //D:일근직,1:장치교대조

//  [CSR ID:2803878] 초과근무 관련 현황 조회
    D02KongsuHourRFC rfcH = new D02KongsuHourRFC();
    String yymm = DataUtil.getCurrentYear()+DataUtil.getCurrentMonth();

    //[CSR ID:2803878] 사무직의 경우 원근무자(대근시) 의 입력 field 가 조회되지 않도록 하기위한 조건
    String officerYN = "";
//     if (user.e_persk.equals("31")||user.e_persk.equals("32")||user.e_persk.equals("33")||user.e_persk.equals("34")||user.e_persk.equals("35")||user.e_persk.equals("38")) {
    if (PERNR_Data.E_PERSK.equals("31") || PERNR_Data.E_PERSK.equals("32") || PERNR_Data.E_PERSK.equals("33") ||
        PERNR_Data.E_PERSK.equals("34") || PERNR_Data.E_PERSK.equals("35") || PERNR_Data.E_PERSK.equals("38")) {
        officerYN = "N";
    } else {
        officerYN = "Y";
    }

    if (!"C".equals(TPGUB)
     && !("D".equals(ObjectUtils.toString(request.getAttribute("TPGUB"))) && !user.empNo.equals(data.PERNR))) {
        // 2015-10-21  @marco
        // 초과근무 현황에서  대리신청 사번일 경우 처리
        // PERNR_Data.E_PERNR
        Vector ovtmKongsuHour = rfcH.getOvtmHour(PERNR_Data.E_PERNR, yymm, "C");  //'C' = 현황, 'R' = 신청, 'M' = 수정, 'G' = 결재
        String curdate = DataUtil.getCurrentDate();
        curdate = (R_DATUM == null || R_DATUM.equals("")) ? curdate : R_DATUM;

        String  YUNJANG = (String) Utils.indexOf(ovtmKongsuHour, 1);
        String   HTKGUN = (String) Utils.indexOf(ovtmKongsuHour, 2);
        String HYUNJANG = (String) Utils.indexOf(ovtmKongsuHour, 3);
        String    YAGAN = (String) Utils.indexOf(ovtmKongsuHour, 4);
        String    NOAPP = (String) Utils.indexOf(ovtmKongsuHour, 5);
        String    MONTH = (String) Utils.indexOf(ovtmKongsuHour, 6);

        // 2015-10-21  @marco
        // [CSR ID:2803878] 초과근문 수정 (월 받아오기/소수점 처리) 소수점 둘째자리에서 반올림 banolim
        if ( YUNJANG != null &&  YUNJANG.indexOf(".") > -1)  YUNJANG = DataUtil.banolim( YUNJANG, 1);
        if (  HTKGUN != null &&   HTKGUN.indexOf(".") > -1)   HTKGUN = DataUtil.banolim(  HTKGUN, 1);
        if (HYUNJANG != null && HYUNJANG.indexOf(".") > -1) HYUNJANG = DataUtil.banolim(HYUNJANG, 1);
        if (   YAGAN != null &&    YAGAN.indexOf(".") > -1)    YAGAN = DataUtil.banolim(   YAGAN, 1);
        if (   NOAPP != null &&    NOAPP.indexOf(".") > -1)    NOAPP = DataUtil.banolim(   NOAPP, 1);

        request.setAttribute( "YUNJANG",  YUNJANG);
        request.setAttribute(  "HTKGUN",   HTKGUN);
        request.setAttribute("HYUNJANG", HYUNJANG);
        request.setAttribute(   "YAGAN",    YAGAN);
        request.setAttribute(   "NOAPP",    NOAPP);
        request.setAttribute(   "MONTH", Integer.parseInt(MONTH));
    }

    // 결재실패시 rollback처리에 필요
    if (data.BEGUZ.length() == 6) {
        data.BEGUZ = (data.BEGUZ + "00000").substring(0,4);
        data.ENDUZ = (data.ENDUZ + "00000").substring(0,4);
    }
    if (data.PBEG1.length() == 6) {
        data.PBEG1 = (data.PBEG1 + "00000").substring(0,4);
        data.PEND1 = (data.PEND1 + "00000").substring(0,4);
    }
    if (data.PBEG2.length() == 6) {
        data.PBEG2 = (data.PBEG2 + "00000").substring(0,4);
        data.PEND2 = (data.PEND2 + "00000").substring(0,4);
    }

    Boolean isUpdate = (Boolean) request.getAttribute("isUpdate");
    if (isUpdate == null) isUpdate = false;
%>
<c:set var="user" value="<%=user%>" />
<c:set var="data" value="<%=data%>" />
<c:set var="ename" value="<%=PERNR_Data.E_ENAME%>" />
<c:set var="PERNR" value="<%=PERNR%>" />
<c:set var="OTbuildYn" value="<%=OTbuildYn%>" />
<c:set var="shiftCheck" value="<%=shiftCheck%>" />
<c:set var="E_RRDAT" value="<%=E_RRDAT%>" />
<c:set var="D_RRDAT" value="<%=D_RRDAT%>" />
<c:set var="PERNR_Data" value="<%=PERNR_Data%>" />
<c:set var="Display_yn" value="<%=Display_yn%>" />
<c:set var="E_BTRTL" value="<%=E_BTRTL%>" />
<c:set var="E_PERSKG" value="<%=E_PERSKG%>" />
<c:set var="officerYN" value="<%=officerYN%>" />
<c:set var="isDeputy" value="${ (data.OVTM_CODE eq '01' and officerYN eq 'N') or !empty data.OVTM_NAME }" />

<c:set var="OTHDDupCheckData_vt" value="<%=OTHDDupCheckData_vt%>" />
<c:set var="D03VocationAReason_vt_size" value="<%=D03VocationAReason_vt.size()%>" />
<c:set var="OTHDDupCheckData_vt_size" value="<%=OTHDDupCheckData_vt.size()%>" />

<c:set var="PRECHECK" value="<%=PRECHECK%>" />
<c:set var="sum" value="<%=sum%>" />
<c:set var="OTDTMonth" value="<%=OTDTMonth%>" />
<c:set var="person_flag" value="<%=person_flag%>" />
<c:set var="SubmitData_vt" value="<%=SubmitData_vt%>" />
<c:set var="newOpt" value="<%=newOpt%>" />

<c:set var="isUpdate" value="<%=isUpdate%>" />

<%-- [WorkTime52] Begin --%>
<c:set var="TPGUB" 	 value="<%=TPGUB%>" />
<c:set var="EMPGUB"  value="<%=EMPGUB%>" />
<c:set var="E_BASTM" value="<%=E_BASTM%>" />
<c:set var="E_MAXTM" value="<%=E_MAXTM%>" />
<c:set var="E_PWDWK" value="<%=E_PWDWK%>" />
<c:set var="E_PWEWK" value="<%=E_PWEWK%>" />
<c:set var="E_CWDWK" value="<%=E_CWDWK%>" />
<c:set var="E_CWEWK" value="<%=E_CWEWK%>" /><%-- CWEKW --%>
<c:set var="E_SUMPW" value="<%=E_SUMPW%>" />
<c:set var="E_SUMCW" value="<%=E_SUMCW%>" />
<c:set var="E_MSTOT" value="<%=E_MSTOT%>" />
<c:set var="H_RWSUM" value="<%=H_RTSUM%>" /><%-- H_RTSUM --%>
<c:set var="W_DUEDT_F" value="<%=W_DUEDT_F%>" />
<c:set var="W_DUEDT_T" value="<%=W_DUEDT_T%>" />
<%-- [WorkTime52] End --%>

<tags:layout css="ui_library_approval.css, D/D01OverTime.css" script="dialog.js, moment-with-locales.min.js, D/D-common.js">
<script type="text/javascript">
//msg 를 보여준다.
function msg() {

    $('#BEGUZ').val(addColon($('#BEGUZ').val()));
    $('#ENDUZ').val(addColon($('#ENDUZ').val()));
    $('#PBEG1').val(addColon($('#PBEG1').val()));
    $('#PEND1').val(addColon($('#PEND1').val()));
    $('#PBEG2').val(addColon($('#PBEG2').val()));
    $('#PEND2').val(addColon($('#PEND2').val()));

    if ('${OTbuildYn}' == 'Y') {
        $('.timeRest').timepicker({
            controlType: 'select',
            oneLine: true,
            defaultValue: '00:00',
            showButtonPanel: false,
            buttonImage: '/web/images/icon_time.gif',
            timeFormat: 'HH:mm',
            onSelect: doCheck
        });
    }

//[CSR ID:3608185]
//[worktime52 PJT] SAP에서 신청을 제한함
//    var dayCount = dayDiff(document.form1.BEGDA.value, document.form1.WORK_DATE.value);
//    var OT_late_text = '';
//    if (dayCount < 0) {
//        OT_late_text = "<spring:message code='MSG.D.D01.0060'/>";//초과근무(휴일근무) 사후 신청 건 입니다.\n근태 담당부서에서 실제 근무 관련 모니터링 할 수 있으며,\n향후에는 반드시 사전 신청하시기 바랍니다.\n\n
//    }
    var OT_late_text = '';

<c:choose><c:when test="${!empty message}">
    alert('${ message }');
</c:when><c:otherwise>

    if ('${PRECHECK}' == 'N' && document.form1.VTKEN.checked) {
        alert("<spring:message code='MSG.D.D01.0001'/>");//前日 근태에 포함 체크를 해제 하시기 바랍니다.(대상아님)

    } else {
        <%--
        //  2015-10-21  @marco
        // 대리신청자이름 (user.ename)->  대리신청해준 이름(PERNR_Data.E_ENAME)으로 수정
        --%>
        //[CSR ID:2803878] 메시지 형식 추가
        //[CSR ID:3608185]초과근무 사후신청 사무직만 문구 추가됨(생산/사무직 구분 없이)

        // [WorkTime52] 사후신청 못하게 함.

        if ('${person_flag}' == 'O') { //사무직
            if ('${EMPGUB}' == 'S') {
            	//[worktime52 PJT] SAP에서 신청을 제한함
                //if (OT_late_text != '') {
                //	if ('${TPGUB}' == 'C') {
				//		alert('초과근무(휴일근무) 사후 신청 건 입니다.\n초과근무 사후신청 탭에서 신청하시기 바랍니다.');
				//		return;
				//	} else {
				//		alert('초과근무(휴일근무) 사후 신청 건 입니다.\n반드시 사전 신청하시기 바랍니다.');
				//		return;
				//	}
                //}

                if ('${TPGUB}' == 'C') {
                    var THISWK = Number(${E_SUMCW}) + Number(document.form1.STDAZ.value);
                    var WORK_DATE_MONTH = moment($('input[name="WORK_DATE"]').val(), 'YYYY.MM.DD').month() +1 ;
                    THISWK = THISWK.toFixed(2);	// 소수점 길이만큼만 반올림하여서 반환
                    if (!confirm(OT_late_text + '${ename} 님은 금번 초과근무 신청 건을 포함하여 '+ WORK_DATE_MONTH +'월 총 근무시간이 ' + THISWK + '시간입니다.\n신청하시겠습니까?')) {
                        return;
                    } else {
                        document.form1.OVTM12YN.value = 'N';
                        //doSubmit();//바로 신청 다시 되도록.
                        setTimeout(triggerSubmit, 500);
                    }
                } else {
                    if (!confirm(OT_late_text + "<spring:message code='MSG.D.D01.0066' arguments='${ename},${OTDTMonth},${sum}' /><spring:message code='MSG.D.D01.0103' />")) {
                        //님은 금번 초과근무 신청 건을 포함하여\n${OTDTMonth}월 휴일근로를 ${sum} 시간 실시하였습니다.\n신청하시겠습니까?        MSG.D.D01.0002
                        return;
                    } else {
                        document.form1.OVTM12YN.value = 'N';
                        //doSubmit();//바로 신청 다시 되도록.
                        setTimeout(triggerSubmit, 500);
                    }
                }
            } else {	// 2018-07-03 현장인데 사무직이면서 계약직(전문직) 인 인원
           		if (!confirm(OT_late_text + "<spring:message code='MSG.D.D01.0003' arguments='${ename},${sum}'/><spring:message code='MSG.D.D01.0103' />")) {
                       //님은 금번 초과근무 신청 건을 포함하여\n1주간 초과근로를 ${sum} 시간 실시하였습니다.\n신청하시겠습니까?
                       return;
                   } else {
                       document.form1.OVTM12YN.value = 'N';
                       //doSubmit();//바로 신청 다시 되도록.
                       setTimeout(triggerSubmit, 500);
                   }
           	}

        // [WorkTime52] 사후신청 못하게 함.
        } else if ('${person_flag}' == 'P') { //생산직
            if ('${EMPGUB}' == 'H') {
            	//[worktime52 PJT] SAP에서 신청을 제한함
                //if (OT_late_text != '' && dayCount < -1) { // D-1일(어제일자) 초과근무신청은 신청 가능하게
                //    alert('초과근무(휴일근무) 사후 신청 건 입니다.\n반드시 사전 신청하시기 바랍니다.');
                //    return;
                //}

                if (!confirm(OT_late_text + "<spring:message code='MSG.D.D01.0003' arguments='${ename},${sum}'/><spring:message code='MSG.D.D01.0103' />")) {
                    //님은 금번 초과근무 신청 건을 포함하여\n1주간 초과근로를 ${sum} 시간 실시하였습니다.\n신청하시겠습니까?
                    return;
                } else {
                    document.form1.OVTM12YN.value = 'N';
                    //doSubmit();//바로 신청 다시 되도록.
                    setTimeout(triggerSubmit, 500);
                }
            }
        }
    }
</c:otherwise></c:choose>
}

////[CSR ID:2803878] trim 만들어서 validation 체크
String.prototype.trim = function() {
    return this.replace(/\s/g, '');
}

//[CSR ID:2941146]
function init() {
    if ('${jobid}' == 'first') {//최초에만
        //여수 사업장의 경우에 한하여 (여수공장, 여수아크릴, 여수VCM, 여수 SM, 여수 OXO, 여수 카본, 여수PC공장, 여수(기술원))
        if ('${E_BTRTL}'=='BAAA' || '${E_BTRTL}'=='BAAB' || '${E_BTRTL}'=='BAAC' || '${E_BTRTL}'=='BAAD' ||
            '${E_BTRTL}'=='BAAE' || '${E_BTRTL}'=='BAAF' || '${E_BTRTL}'=='BAGA' || '${E_BTRTL}'=='CABA') {
            if ('${PERNR_Data.e_PERSK}'=='31'||'${PERNR_Data.e_PERSK}'=='21'||'${PERNR_Data.e_PERSK}'=='22') {//전문기술직,간부사원, 사무직
                window.open('${ g.jsp}D/D01OT/D01OTBuildGuidepopup.jsp', 'cardInfo', 'width=500,height=350,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100');
            }
        }
    }
}

function triggerSubmit() {
    $('.-request-button').triggerHandler('click');
}

//[worktime52] TPGUB 추가
//휴게시간 자동입력 (12:00~13:00) 막음.
function OVTM_Sel(obj) {   //CSR ID:1546748
	if (${TPGUB != 'C'}) {
    	if (${OTbuildYn == 'Y'}) {
            //CSR ID:1546748
            if (${D03VocationAReason_vt_size} > 0) {
                // 휴게시간 셋팅 제외
                //C20140203_79594 인사하위영역 BA00, BACA:대산공장  인 경우 일근직:D 아닌 경우
                //BBIA:파주사업장제외
                if ('${E_BTRTL}' == 'BBIA' || ('${E_BTRTL}' == 'BACA' && '${shiftCheck}' != 'D')) {
                    null;
                } else {
                    if (obj.value == '01') { //대근
                        document.form1.PBEG1.value='';
                        document.form1.PEND1.value='';
                    } else if (obj.value != '') {
                        var BEGUZ = document.form1.BEGUZ.value.replace(':','');
                        var ENDUZ = document.form1.ENDUZ.value.replace(':','');

                        // [CSR ID:2803878] 휴게시간 자동 입력 하루가 넘을경우도 자동입력
                        if ((Number(BEGUZ) <= 1200 && Number(ENDUZ) >= 1300) ||
                            (Number(BEGUZ) <= 1200 && Number(BEGUZ) > Number(ENDUZ))) {
                            document.form1.PBEG1.value='12:00';
                            document.form1.PEND1.value='13:00';
                        } else {
                            document.form1.PBEG1.value='';
                            document.form1.PEND1.value='';
                        }
                    } else {
                        document.form1.PBEG1.value='';
                        document.form1.PEND1.value='';
                    }
                }
            }
		}
    }
}

//날짜 변경해서 보낸다.
//달력사용
function beforeSubmit() {

    if (!check_Data()) return false;

    // 2004.2.11 - 중복을 체크하는 로직 추가. 같은 날짜와 시간일 경우 중복경고.
    var c_WORK_DATE, c_BEGUZ, c_ENDUZ;
    c_WORK_DATE = document.form1.WORK_DATE.value;
    c_WORK_DATE = c_WORK_DATE.replace('.','-').replace('.','-');
    c_BEGUZ     = document.form1.BEGUZ.value.replace(':','');
    c_ENDUZ     = document.form1.ENDUZ.value.replace(':','');
    c_AINF_SEQN = document.form1.AINF_SEQN.value;

    var workday = removePoint(document.form1.WORK_DATE.value);

    //-------   START LOOP
    <c:forEach var="c_Data" items="${OTHDDupCheckData_vt}" varStatus="status">
        <c:set var="s_BEGUZ1" value="${fn:substring(c_Data.BEGUZ,0,2)}${fn:substring(c_Data.BEGUZ,3,5)}" />
        <c:set var="s_ENDUZ1" value="${fn:substring(c_Data.ENDUZ,0,2)}${fn:substring(c_Data.ENDUZ,3,5)}" />
        <c:if test='${s_ENDUZ1=="0000"}'><c:set var="s_ENDUZ1" value="2400" /></c:if>
        <c:set var="s_BEGUZ" value="${f:parseFloat(s_BEGUZ1)}" />
        <c:set var="s_ENDUZ" value="${f:parseFloat(s_ENDUZ1)}" />

    if (("${ c_Data.WORK_DATE }" == c_WORK_DATE) &&
        (${isUpdate == false} || "${c_Data.AINF_SEQN}" != c_AINF_SEQN && ${isUpdate == true})) { //check Requested
        if ("${ c_Data.APPR_STAT}" != "R" && ${s_BEGUZ} == c_BEGUZ && ${s_ENDUZ} == c_ENDUZ) {
            alert("<spring:message code='MSG.D.D01.0004'/>");//현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.
            document.form1.BEGUZ.select();
            return false;
        }
        //ENDUZ가 다음날로 넘어가지 않을 경우.
        else if ("${c_Data.APPR_STAT}" != "R" &&
                  ${s_BEGUZ} < ${s_ENDUZ} &&
                ((${s_BEGUZ} <= c_BEGUZ && ${s_ENDUZ} >  c_BEGUZ) ||
                 (${s_BEGUZ} <  c_ENDUZ && ${s_ENDUZ} >= c_ENDUZ) ||
                 (${s_BEGUZ} >= c_BEGUZ && ${s_ENDUZ} <= c_ENDUZ))) {
            alert("<spring:message code='MSG.D.D01.0005'/>");//이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.
            document.form1.BEGUZ.select();
            return false;
        }
        //ENDUZ가 다음날로 넘어가는 경우.
        //[CSR ID:2727336] 기 신청일이 현재 신청일보다 나중 날짜일 경우 조건이 추가되어야 함.
        else if ("${ c_Data.APPR_STAT}"  != "R" &&
                  ${s_BEGUZ} >  ${s_ENDUZ}  &&
               (((${s_BEGUZ} <= c_BEGUZ && c_BEGUZ < 2400) ||
                 (c_BEGUZ >= 0000   && ${s_ENDUZ} >  c_BEGUZ && ${s_BEGUZ} < c_ENDUZ) ||
                 (c_BEGUZ >= 0000   && ${s_BEGUZ} <  c_ENDUZ && ${s_BEGUZ} > c_ENDUZ)) ||
                ((c_ENDUZ <= 2400   && ${s_BEGUZ} <  c_ENDUZ) ||
                 (c_ENDUZ >  0000   && ${s_ENDUZ} >= c_ENDUZ)) ||
                 (c_BEGUZ > c_ENDUZ && ${s_BEGUZ} >= c_BEGUZ && ${s_ENDUZ} <= c_ENDUZ))) {
            alert("<spring:message code='MSG.D.D01.0005'/>"); //이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.
            document.form1.BEGUZ.select();
            return false;
        }
    }
</c:forEach>
    return copy_Entity();
}

function getBetweenTime(currentTime, intervalTime) {
    var hh1 = 0, mm1 = 0;
    var hh2 = 0, mm2 = 0;
    var d_hh = 0, d_mm = 0, interval_time = 0;

    hh1 = currentTime.substring(0,2);
    mm1 = currentTime.substring(2,4);

    hh2 = intervalTime.substring(0,2);
    mm2 = intervalTime.substring(3,5);

    d_hh = hh2 - hh1;
    d_mm = mm2 - mm1;

    if (d_mm >= 0) {
        d_mm = d_mm / 60;
    } else {
        d_hh = d_hh - 1;
        d_mm = (60 + d_mm) /60;
    }
    interval_time = d_hh + d_mm;

    return interval_time;
}

function doCheck() {
    if (check_Data()) {
        if (copy_Entity()) {
            document.form1.jobid.value = "check";
            // [WorkTime52] START
            document.form1.action = "${ g.servlet }hris.D.D01OT.${isUpdate == true?'D01OTChangeSV':'D01OTBuildSV'}?isUpdate=${isUpdate}&DATUM="+document.form1.WORK_DATE.value+"";
            // [WorkTime52] End
            document.form1.method = "post";
            document.form1.submit();
        }
    }
}

function copy_Entity() {
    textArea_to_TextFild(document.form1.OVTM_DESC.value);
    if (document.form1.BEGUZ.value.length == 5) { //09:00 형식의 시간일때만 수행해야 함. 090000 일 때 수행하면 버그 발생 [CSR ID:2803878]
        document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
        document.form1.WORK_DATE.value = removePoint(document.form1.WORK_DATE.value);
        document.form1.BEGUZ.value = addSec(document.form1.BEGUZ.value);
        document.form1.ENDUZ.value = addSec(document.form1.ENDUZ.value);
        document.form1.PBEG1.value = addSec(document.form1.PBEG1.value);
        document.form1.PEND1.value = addSec(document.form1.PEND1.value);
        document.form1.PBEG2.value = addSec(document.form1.PBEG2.value);
        document.form1.PEND2.value = addSec(document.form1.PEND2.value);
//--> Sevlet단으로 이동처리 *ksc
    }
    return true;
}

// 시간 선택
function fn_openTime(Objectname) {
    var scrleft = screen.width / 3;
    var scrtop = screen.height / 2 - 100;
    small_window = window.open("${g.jsp}common/time.jsp?formname=form1&fieldname=" + Objectname ,"essTime","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=250,top=" + scrtop + ",left=" + scrleft);
    small_window.focus();
}

function addSec(text) {
    if (text != "") {
        time = removeColon(text);
        return time + "00";
    } else {
        return "";
    }
}

function removeSec(text) {
    if (text != "") {
        if (text.length == 6) {
            text = text.substring(0,4);
        }
    }
    return text;
}

function addColon(text) {//형식 체크후 문자형태의 시간 0000을 00:00으로 바꾼다 값이 없을시는 0을 리턴
    text = $.trim(text);
    if (text) {
        if (text.length == 6) {
            text = text.substring(0,4);
        }
        if (text.length == 4) {
            return text.substring(0,2) + ":" + text.substring(2,4);
        }
    } else {
        return "";
    }
}

function cal_time(time1, time2) {
    var tmp_HH1 = 0;//이것이 문제다....
    var tmp_MM1 = 0;
    var tmp_HH2 = 0;
    var tmp_MM2 = 0;
    if (time1.length == 4) {
        tmp_HH1 = time1.substring(0,2);
        tmp_MM1 = time1.substring(2,4);
    } else if (time1.length == 3) {
        tmp_HH1 = time1.substring(0,1);
        tmp_MM1 = time1.substring(1,3);
    }
    if (time2.length == 4) {
        tmp_HH2 = time2.substring(0,2);
        tmp_MM2 = time2.substring(2,4);
    } else if (time2.length == 3) {
        tmp_HH2 = time2.substring(0,1);
        tmp_MM2 = time2.substring(1,3);
    }

    var tmp_hour = tmp_HH2 - tmp_HH1;
    var tmp_min  = tmp_MM2 - tmp_MM1;
    var interval_time = 0;

    if (tmp_hour < 0) {
        tmp_hour = 24+tmp_hour;
    }
    if (tmp_min >= 0) {
        tmp_min = banolim((tmp_min / 60), 2);
    } else {
        tmp_hour = tmp_hour - 1;
        tmp_min  = banolim((60 + tmp_min) / 60, 2);
    }
    interval_time = tmp_hour + tmp_min + "";
    return interval_time;
}

//메인시간 계산용(총 초과 근무시간 계산용)
function cal_time2(time1, time2) {
    var tmp_HH1 = 0;//이것이 문제다....
    var tmp_MM1 = 0;
    var tmp_HH2 = 0;
    var tmp_MM2 = 0;
    if (time1.length == 4) {
        tmp_HH1 = time1.substring(0,2);
        tmp_MM1 = time1.substring(2,4);
    } else if (time1.length == 3) {
        tmp_HH1 = time1.substring(0,1);
        tmp_MM1 = time1.substring(1,3);
    }
    if (time2.length == 4) {
        tmp_HH2 = time2.substring(0,2);
        tmp_MM2 = time2.substring(2,4);
    } else if (time2.length == 3) {
        tmp_HH2 = time2.substring(0,1);
        tmp_MM2 = time2.substring(1,3);
    }

    var tmp_hour = tmp_HH2 - tmp_HH1;
    var tmp_min  = tmp_MM2 - tmp_MM1;
    var interval_time = 0;

    if (tmp_hour < 0) {
        tmp_hour = 24 + tmp_hour;
    }
    if (tmp_min >= 0) {
        tmp_min = banolim((tmp_min / 60), 2);
    } else {
        tmp_hour = tmp_hour - 1;
        tmp_min  = banolim((60 + tmp_min) / 60, 2);
    }
    interval_time = tmp_hour + tmp_min + "";
    if (interval_time == 0) {
        interval_time = 24;
    }

    return interval_time;
}

function check_Data() {
<%--
    1. 前日 근태에 포함 체크  ==> flag
    2. 각 필드의 형식 첵크 날짜 타입이 맞는지 시간 타입이 맞는지 첵크
    3. 형식 check와 동시에 해당 필드 특성에 맞게 값 변환 ex) 00:00 ==> 24:00
    4. 시간필드 colon제거 : 계산하기 위해 : 제거와 초 "00"을 같이 제거
    5. 필수 입력사항 체크  초과근무 일자, 초과근무 시작시간, 종료시간
    6. 前日 근태에 포함 타입에 맞는 시간 인지를 첵크
    7. 휴식시간이 초과 근무 시간 내에 있는지를 첵크
    8. 휴식 시작시간 종료시간이 다 있는지를 첵크 단 (00:00 ~ 00:00 은 "" ""로 변환)
    9. 휴식시간 무결성 체크
   10. 휴식시간 계산
   11. 공란 제거(필드 이동)
   12. 다시 화면에 보일수 있는 형식으로 변환 addColon(text) 및 화면에 보임
   13. 초과근무 신청 시 "상세업무일정" 항목 추가에 따른 필수 입력 체크 추가(20150318 [CSR ID:2803878])
   14. 주당 12시간 넘어가면 Alert
   15. OVTM_DESC 230 byte로 제한
   16. 사후신청 시 1개월 전 1일 이전에 신청한 건 신청 못하도록 alert 뜨도록 조건 추가@이지은
--%>

    if (isNaN(Number($("#PBEZ1").val())) ||
        isNaN(Number($("#PUNB1").val())) ||
        isNaN(Number($("#PBEZ2").val())) ||
        isNaN(Number($("#PUNB2").val()))) {
        alert("<spring:message code='MSG.COMMON.0026' />");//숫자가 아닙니다");
        return false;
    }

    $("#BEGUZ").val(removeSec($("#BEGUZ").val()));
    $("#ENDUZ").val(removeSec($("#ENDUZ").val()));
    $("#PBEG1").val(removeSec($("#PBEG1").val()));
    $("#PEND1").val(removeSec($("#PEND1").val()));
    $("#PBEG2").val(removeSec($("#PBEG2").val()));
    $("#PEND2").val(removeSec($("#PEND2").val()));

    //C20100812_18478   적용일자 : 2010.08.15 휴일특근 로직
    if ("${Display_yn}" != "Y" && "${OTbuildYn}" == "Y") {
        if (Number(removePoint(document.form1.WORK_DATE.value)) < 20100815) {
            alert("<spring:message code='MSG.D.D01.0020'/>");//휴일특근 신청은 2010.08.15일 부터 가능합니다.
            return false;
        }
    }

    //  필수 필드의 형식 체크
    if (!dateFormat(document.form1.WORK_DATE)) {
        return false;
    }
    if (!timeFormat(document.form1.BEGUZ)) {//24:00일때 00:00으로 변환 필요
        return false;
    } else {
        if (document.form1.BEGUZ.value == "24:00") {
            document.form1.BEGUZ.value = "00:00";
        }
    }
    if (!timeFormat(document.form1.ENDUZ)) {//00:00일때 24:00으로 변환 필요
        return false;
    } else {
        if (document.form1.ENDUZ.value == "00:00") {
            document.form1.ENDUZ.value = "24:00";
        }
    }

    //  필수 입력사항 이외의 필드 값에 대한 값첵크 //휴식시간첵크  //휴식시간에서는 24:00을 00:00으로 변환필요
    if (!timeFormat(document.form1.PBEG1)) {
        return false;
    } else {
        if (document.form1.PBEG1.value == "24:00") {
            document.form1.PBEG1.value = "00:00" ;
        }
    }
    if (!timeFormat(document.form1.PEND1)) {
        return false;
    } else {
        if (document.form1.PEND1.value == "24:00") {
            document.form1.PEND1.value = "00:00" ;
        }
    }
    if (!timeFormat(document.form1.PBEG2)) {
        return false;
    } else {
        if (document.form1.PBEG2.value == "24:00") {
            document.form1.PBEG2.value = "00:00" ;
        }
    }
    if (!timeFormat(document.form1.PEND2)) {
        return false;
    } else {
        if (document.form1.PEND2.value == "24:00") {
            document.form1.PEND2.value = "00:00" ;
        }
    }

    var WORK_DATE = document.form1.WORK_DATE.value;
    var BEGUZ = removeColon(document.form1.BEGUZ.value);
    var ENDUZ = removeColon(document.form1.ENDUZ.value);
    var STDAZ = document.form1.STDAZ.value;
    var PBEG1 = removeColon(document.form1.PBEG1.value);
    var PEND1 = removeColon(document.form1.PEND1.value);
    var PUNB1 = document.form1.PUNB1.value;
    var PBEZ1 = document.form1.PBEZ1.value;
    var PBEG2 = removeColon(document.form1.PBEG2.value);
    var PEND2 = removeColon(document.form1.PEND2.value);
    var PUNB2 = document.form1.PUNB2.value;
    var PBEZ2 = document.form1.PBEZ2.value;
    var curDate = "${f:currentDate()}";//현재일자

    //초과 근무에서 휴식시간의 유효범위 체크
    if (freetime_check(BEGUZ, ENDUZ, PBEG1)) {
        alert("<spring:message code='MSG.D.D01.0019'/>");    //휴식시간이 초과근무시간에 해당하지 않습니다.
        document.form1.PBEG1.focus();
        document.form1.PBEG1.select();
        return false;
    }
    if (freetime_check(BEGUZ, ENDUZ, PEND1)) {
        alert("<spring:message code='MSG.D.D01.0019'/>");    //휴식시간이 초과근무시간에 해당하지 않습니다.
        document.form1.PEND1.focus();
        document.form1.PEND1.select();
        return false;
    }
    if (freetime_check(BEGUZ, ENDUZ, PBEG2)) {
        alert("<spring:message code='MSG.D.D01.0019'/>.");    //휴식시간이 초과근무시간에 해당하지 않습니다.
        document.form1.PBEG2.focus();
        document.form1.PBEG2.select();
        return false;
    }
    if (freetime_check(BEGUZ, ENDUZ, PEND2)) {
        alert("<spring:message code='MSG.D.D01.0019'/>");    //휴식시간이 초과근무시간에 해당하지 않습니다.
        document.form1.PEND2.focus();
        document.form1.PEND2.select();
        return false;
    }

    //박난이S 요청 근태 3개월 이상 벌어지면 Alert
    var today = '${ f:currentDate() }';
    today = today + "";
    var today_3month = getAfterMonth(addSlash(today),3);
    var from_num = Number(removePoint(WORK_DATE));
    if (from_num>today_3month) {
        alert("<spring:message code='MSG.D.D01.0018'/>");//초과근무일자를 다시 확인하시기 바랍니다.
        document.form1.WORK_DATE.focus();
        document.form1.WORK_DATE.select();
        return false;
    }

    //시작시간과 종료시간이 둘다 있는지를 첵크 and 0000 0000 일때 공백으로 표시
    if (PBEG1 == "" && PEND1 != "") {
        alert("<spring:message code='MSG.D.D01.0017'/>");//시작시간이 없습니다.
        document.form1.PBEG1.focus();
        return false;
    } else if (PBEG1 != "" && PEND1 == "") {
        alert("<spring:message code='MSG.D.D01.0016'/>");//종료시간이 없습니다.
        document.form1.PEND1.focus();
        return false;
    } else {
        if (PBEG1 == 0 && PEND1 == 0) {
            PBEG1 = "";
            PEND1 = "";
        }
    }

    if (PBEG2 == "" && PEND2 != "") {
        alert("<spring:message code='MSG.D.D01.0017'/>");//시작시간이 없습니다.
        document.form1.PBEG2.focus();
        return false;
    } else if (PBEG2 != "" && PEND2 == "") {
        alert("<spring:message code='MSG.D.D01.0016'/>");//종료시간이 없습니다.
        document.form1.PEND2.focus();
        return false;
    } else {
        if (PBEG2 == 0 && PEND2 == 0) {
            PBEG2 = "";
            PEND2 = "";
        }
    }


    //  휴게시간이 정확한지 여부 첵크
    //  시간+날짜
    var D_BEGUZ = "";    //시작시간
    var D_ENDUZ = "";    //종료시간
    var D_PBEG1 = "";    //휴게1 시작
    var D_PEND1 = "";    //휴게1 종료
    var D_PBEG2 = "";    //휴게2 시작
    var D_PEND2 = "";    //휴게2 종료

    if (PBEG1 != "" && PEND1 != "") {
        //시간설정
        if (BEGUZ <= PBEG1) {
            D_PBEG1 = "1"+PBEG1;
        } else {
            D_PBEG1 = "2"+PBEG1;
        }
        if (BEGUZ <= PEND1) {
            D_PEND1 = "1"+PEND1;
        } else {
            D_PEND1 = "2"+PEND1;
        }
        //시간여부 첵크
        if (D_PBEG1 > D_PEND1) {
            alert("<spring:message code='MSG.D.D01.0015'/>");    //휴식시간이 설정이 잘못되었습니다.
            document.form1.PEND1.focus();
            return false;
        }
    }

    if (PBEG2 != "" && PEND2 != "") {
        if (BEGUZ <= PBEG2) {
            D_PBEG2 = "1" + PBEG2;
        } else {
            D_PBEG2 = "2" + PBEG2;
        }
        if (BEGUZ <= PEND2) {
            D_PEND2 = "1" + PEND2;
        } else {
            D_PEND2 = "2" + PEND2;
        }
        //
        if (D_PBEG2 > D_PEND2) {
            alert("<spring:message code='MSG.D.D01.0015'/>");    //휴식시간이 설정이 잘못되었습니다.
            document.form1.PEND2.focus();
            return false;
        }
    }

    //  휴식값이 모두 있는경우  //좀더 생각
    if (PBEG1 != "" && PEND1 != "" && PBEG2 != "" && PEND2 != "") {
        if (D_PEND1 <= D_PBEG2 && D_PEND1 <= D_PEND2) {
            //정상적인경우
        } else if (D_PEND2 <= D_PBEG1 && D_PBEG2 <= D_PBEG1) {
            //정상적인경우
        } else {
            alert("<spring:message code='MSG.D.D01.0015'/>");    //휴식시간이 설정이 잘못되었습니다.
            document.form1.PBEG1.focus();
            return false;
        }
    }

    //휴식시간 계산  //잘못된 값 억제..
    tmpSTDAZ = cal_time2(BEGUZ, ENDUZ) + "";

    // 휴게시간 1
    if (PBEG1 != "" && PEND1 != "") {
        if (PUNB1 == "" && PBEZ1 == "") {
            PUNB1 = cal_time(PBEG1, PEND1);
            PBEZ1 = "";
        }

/* [worktime52] 주석처리 시작
        if (PUNB1 != "" && PBEZ1 == "") {
            if (PUNB1 > cal_time(PBEG1, PEND1)) {
                alert(" <spring:message code='MSG.D.D01.0013'/> "+ cal_time(PBEG1, PEND1) +" <spring:message code='MSG.D.D01.0014'/> ");    //최대 입력값은 00 입니다
                document.form1.PUNB1.focus();
                document.form1.PUNB1.select();
                return false;
            }
        }
        if (PUNB1 != "" && PBEZ1 != "") {
            if ((Number(PUNB1)+ Number (PBEZ1)) > cal_time(PBEG1, PEND1)) {
                alert(" <spring:message code='MSG.D.D01.0013'/> "+ cal_time(PBEG1, PEND1) +" <spring:message code='MSG.D.D01.0014'/> ");    //최대 입력값은 00 입니다
                document.form1.PUNB1.focus();
                document.form1.PUNB1.select();
                return false;
            }
        }
        if (PUNB1 == "" && PBEZ1 != "") {
            if (Number (PBEZ1) >  cal_time(PBEG1, PEND1)) {
              alert(" <spring:message code='MSG.D.D01.0013'/> "+ cal_time(PBEG1, PEND1) +" <spring:message code='MSG.D.D01.0014'/> ");    //최대 입력값은 00 입니다
              document.form1.PUNB1.focus();
              document.form1.PUNB1.select();
              return false;
주석 끝*/

        tmpSTDAZ = tmpSTDAZ - PUNB1;

    } else {
        if (PUNB1 != "") {
            PUNB1 = "";
        }
        if (PBEZ1 != "") {
            PBEZ1 = "";
        }
    }

    // 휴게시간 2
    if (PBEG2 != "" && PEND2 != "") {
        if (PUNB2 == "" && PBEZ2 == "") {
            PUNB2 = cal_time(PBEG2, PEND2);
            PBEZ2 = "";
        }
        if (PUNB2 != "" && PBEZ2 == "") {
            if (PUNB2 > cal_time(PBEG2, PEND2)) {
                alert(" <spring:message code='MSG.D.D01.0013'/> "+ cal_time(PBEG2, PEND2) +" <spring:message code='MSG.D.D01.0014'/> ");    //최대 입력값은 00 입니다.
                document.form1.PUNB2.focus();
                document.form1.PUNB2.select();
                return false;
            }
        }
        if (PUNB2 != "" && PBEZ2 != "") {
            if ((Number(PUNB2)+ Number (PBEZ2)) > cal_time(PBEG2, PEND2)) {
                alert(" <spring:message code='MSG.D.D01.0013'/> "+ cal_time(PBEG2, PEND2) +" <spring:message code='MSG.D.D01.0014'/> ");    //최대 입력값은 00 입니다.
                document.form1.PUNB2.focus();
                document.form1.PUNB2.select();
                return false;
            }
        }
        if (PUNB2 == "" && PBEZ2 != "") {
            if (Number (PBEZ2) >  cal_time(PBEG2, PEND2)) {
              alert(" <spring:message code='MSG.D.D01.0013'/> "+ cal_time(PBEG2, PEND2) +" <spring:message code='MSG.D.D01.0014'/> ");    //최대 입력값은 00 입니다.
              document.form1.PUNB2.focus();
              document.form1.PUNB2.select();
              return false;

            }
        }
        tmpSTDAZ = tmpSTDAZ - PUNB2;
    } else {
        if (PUNB2 != "") {
            PUNB2 = "";
        }
        if (PBEZ2 != "") {
            PBEZ2 = "";
        }
    }

    //이동로직
    if (PBEG1 == "") {
        if (PBEG2 != "") {
            PBEG1 = PBEG2;
            PEND1 = PEND2;
            PUNB1 = PUNB2;
            PBEZ1 = PBEZ2;
            PBEG2 = "";
            PEND2 = "";
            PUNB2 = "";
            PBEZ2 = "";
        }
    }

    if (tmpSTDAZ == 0) {
        STDAZ = "";
    } else {
        STDAZ = banolim(tmpSTDAZ,2);
    }

    //[WorkTime52] 시작 : 2018-07-10 TPGUB X 추가 (D와 같은 로직.)
    if (${TPGUB == "A" || TPGUB == "B" || TPGUB == "D" || TPGUB == "X" || shiftCheck == "1"}) {
        document.form1.STDAZ.value = STDAZ;
        document.form1.PBEG1.value = addColon(PBEG1);
        document.form1.PEND1.value = addColon(PEND1);
        document.form1.PUNB1.value = (PUNB1 == 0 ? "" : PUNB1);
        document.form1.PBEZ1.value = (PBEZ1 == 0 ? "" : PBEZ1);
    }

    document.form1.PBEG2.value = addColon(PBEG2);
    document.form1.PEND2.value = addColon(PEND2);
    document.form1.PUNB2.value = (PUNB2 == 0 ? "" : PUNB2);
    document.form1.PBEZ2.value = (PBEZ2 == 0 ? "" : PBEZ2);
<%--
    //CSR ID:1546748 사무직 시작시간은 무조건 9시 이전, 종료시간은 무조건 18시 이후만입력가능
    //C20101011_51420    적용일자 : 2010.10.12 사무직외에 PL미만(직책:FO0미만) 사무직 전원
    //(31    전문기술직,32    지도직,33    기능직,34    계약직(기능직)) 제외  초과근무신청대상자 모두 체크
    //지도직,33은 사무직과 동일하게 체크(예외에서 제외함)
    //사무직반일특근 도입
    //※C20120113_33260 2012.01.26 하드코딩삭제 사무지도직(S):휴일특근,반일특근신청가능
    //[WorkTime52] --------------------------------------------------------------------------
--%>
<c:if test='${E_PERSKG=="S" || EMPGUB =="S"}'>

	//[WorkTime52] 사무직 일반 || 사무직 주재원(비대상)
    <c:if test='${TPGUB == "A" || TPGUB == "X"}'>
    	var tmpSTD    = cal_time2(BEGUZ, ENDUZ) + "";

        //if (document.form1.HOLID.value != "X" && document.form1.SOLLZ.value != "0") {    // 휴일아님
        //    alert("평일 초과근로를  신청하실 수 없습니다.");
        //  return false;
        //}
        // 반일특근은 4시간 근무만을 인정
        if (Number(BEGUZ) < 0900 || Number(BEGUZ) > 1800) {
            alert("<spring:message code='MSG.D.D01.0012'/>");//시작시간, 종료시간 인정 기준시간은 9:00 ~ 18:00 입니다 [old : 시작시간 인정 기준시간은 9:00 ~ 18:00 입니다 ]
            return false;
        }
        if (Number(ENDUZ) < 0900 || Number(ENDUZ) > 1800) {
            alert("<spring:message code='MSG.D.D01.0012'/>");//시작시간, 종료시간 인정 기준시간은 9:00 ~ 18:00 입니다 [old : 종료시간 인정 기준시간은 9:00 ~ 18:00 입니다 ]
            return false;
        }

        if (STDAZ < 4) {
            alert("<spring:message code='MSG.D.D01.0062'/>");//휴일근로는 09시~18시 사이의 근로시간만 인정되며,\\n휴일근로로 인정되는 시간은 반일특근(4시간) 또는 전일특근(8시간)임\\n관련하여 문의사항은 사업장 관할 근태부서에 문의하시기 바랍니다.
            return false;
        }

        if ((Number(BEGUZ) <= 1200 && Number(ENDUZ) >= 1300) ||
            (Number(BEGUZ) <= 1200 && Number(BEGUZ) > Number(ENDUZ))) {
            document.form1.PBEG1.value="12:00";
            document.form1.PEND1.value="13:00";
            document.form1.PUNB1.value="1";
            document.form1.STDAZ.value= tmpSTD - 1;
        }else{
            document.form1.STDAZ.value= tmpSTD;
        }
        if (document.form1.STDAZ.value >= 5 && (document.form1.PBEG1.value == "" && document.form1.PEND1.value == "") &&
           (document.form1.PBEG2.value == "" || document.form1.PEND2.value == "")) {
        	alert("<spring:message code='MSG.D.D01.0010'/>");//5시간 이상 근무시 휴게시간을 입력하세요.
            document.form1.PBEG1.focus();
            return false;
        }
        if (document.form1.STDAZ.value >= 5 && (document.form1.PBEG1.value == "" || document.form1.PEND1.value=="")) {
        	alert("<spring:message code='MSG.D.D01.0010'/>");//5시간 이상 근무시 휴게시간을 입력하세요.
            document.form1.PBEG1.focus();
            return false;
        }
        //2013-06-28  휴게시간1시간이상 입력 체크
        var PUNB = Number(document.form1.PUNB1.value) + Number(document.form1.PUNB2.value);
        if (document.form1.STDAZ.value >= 5 && PUNB < 1) {
            alert("<spring:message code='MSG.D.D01.0009'/>");//5시간 이상 근무시 휴게시간 1시간 이상을 입력하세요.
            document.form1.PBEG1.focus();
            return false;
        }
        //[CSR ID:3620968] 사무직 4 or 8만 입력 가능하도록.
        var STDAZ = document.form1.STDAZ.value;
        if (!(STDAZ == 4 || STDAZ == 8)) {
        	alert("<spring:message code='MSG.D.D01.0062'/>");//휴일근로는 09시~18시 사이의 근로시간만 인정되며,\\n휴일근로로 인정되는 시간은 반일특근(4시간) 또는 전일특근(8시간)임\\n관련하여 문의사항은 사업장 관할 근태부서에 문의하시기 바랍니다.
            document.form1.PBEG1.focus();
            return false;
        }
        if (document.form1.STDAZ.value < 4) {
        	//alert("<spring:message code='MSG.D.D01.0011'/>");//휴게시간제외한 최소신청 4시간 기준입니다.////[CSR ID:3620968] 사무직 4 or 8만 입력 가능하도록. 문구 통일화
            alert("<spring:message code='MSG.D.D01.0062'/>");//휴일근로는 09시~18시 사이의 근로시간만 인정되며,\\n휴일근로로 인정되는 시간은 반일특근(4시간) 또는 전일특근(8시간)임\\n관련하여 문의사항은 사업장 관할 근태부서에 문의하시기 바랍니다.
            return false;
        }
        if (BEGUZ.substring(2,4) != ENDUZ.substring(2,4)) {
            alert("초과근로의 시작 및 종료 시간은 한 시간 단위로 신청 가능 합니다.\n단, 입력 시각은 10분 단위로 입력하여 주시기를 바랍니다.\n예) 시작 09:30 ~ 종료 13:30 (○)\n     시작 09:31 ~ 종료 13:31 (Ｘ)");
            return false;
        }
        if (BEGUZ.substring(3,4) != "0" || ENDUZ.substring(3,4) != "0") {
            alert("초과근로의 시작 및 종료 시간은 한 시간 단위로 신청 가능 합니다.\n단, 입력 시각은 10분 단위로 입력하여 주시기를 바랍니다.\n예) 시작 09:30 ~ 종료 13:30 (○)\n     시작 09:31 ~ 종료 13:31 (Ｘ)");
            return false;
        }
    </c:if>

// 사무직 선택근로제
    <c:if test='${TPGUB == "C"}'>

    if (${shiftCheck == "1"}) {    // 4조3교대인 경우
        if (document.form1.HOLID.value == "X" ) {    // 공휴일일때만 (|| document.form1.SOLLZ.value == "0" 삭제.2018-07-12)
        	alert("(장치)교대조인 직원은 공휴일에 초과근로를 신청하실 수 없습니다.\n담당부서에 문의하시기 바랍니다.");
            return false;
        }
    // 4조3교대 아닌 경우
    } else {
        if (document.form1.HOLID.value == "X" || document.form1.SOLLZ.value == "0") {    // 휴일
        	// 휴일근무 시간 제한 막음...2018-07-05
            //if (Number(BEGUZ) <  700 || Number(ENDUZ)  > 1900) {
            //    alert("휴일근로의 시작시간, 종료시간 인정 기준시간은 07:00 ~ 19:00 입니다.");
            //    return false;
            //}
        	if (BEGUZ.substring(2,4) != ENDUZ.substring(2,4)) {
                alert("초과근로의 시작 및 종료 시간은 한 시간 단위로 신청 가능 합니다.\n단, 입력 시각은 10분 단위로 입력하여 주시기를 바랍니다.\n예) 시작 09:30 ~ 종료 13:30 (○)\n     시작 09:31 ~ 종료 13:31 (Ｘ)");
                return false;
            }
            if (BEGUZ.substring(3,4) != "0" || ENDUZ.substring(3,4) != "0") {
                alert("초과근로의 시작 및 종료 시간은 한 시간 단위로 신청 가능 합니다.\n단, 입력 시각은 10분 단위로 입력하여 주시기를 바랍니다.\n예) 시작 09:30 ~ 종료 13:30 (○)\n     시작 09:31 ~ 종료 13:31 (Ｘ)");
                return false;
            }

            // 휴게시간 셋팅
            var STDAZ = cal_time2(BEGUZ, ENDUZ) + "";

            if (STDAZ < 5) {
                document.form1.STDAZ.value = STDAZ;
            }
            if (STDAZ >= 5 && STDAZ < 9) {
                var tmpBEGhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpENDhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpBEGmm= Number(BEGUZ.substring(2,4));
                var tmpSTD    = cal_time2(BEGUZ, ENDUZ) + "";

                if (Number(tmpBEGmm+30) >= 60) {
                    tmpBEGmm = Number(tmpBEGmm + 30) - 60;
                    tmpENDhh = tmpENDhh +1;
                } else {
                    tmpBEGmm = Number(tmpBEGmm + 30);
                    tmpENDhh = tmpENDhh;
                }
                if (tmpBEGmm == 60 || tmpBEGmm == 0) tmpBEGmm = "00";

                if (tmpBEGhh >= 24) {
                    tmpBEGhh = tmpBEGhh - 24;
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                } else {
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                }
                if (tmpBEGhh == 24 || tmpBEGhh == 0) tmpBEGhh = "00";

                if (tmpENDhh >= 24) {
                    tmpENDhh = tmpENDhh - 24;
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                } else {
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                }
                if (tmpENDhh == 24 || tmpENDhh == 0) tmpBEGhh = "00";


                document.form1.PBEG1.value = tmpBEGhh + ":" + BEGUZ.substring(2,4);
                document.form1.PEND1.value = tmpENDhh + ":" + tmpBEGmm;
                document.form1.PUNB1.value = "0.5";
                document.form1.STDAZ.value = STDAZ - 0.5;

            } else if (STDAZ >= 9 && STDAZ < 13) {
                var tmpBEGhh = Number(BEGUZ.substring(0,2)) + 4 ;
                var tmpENDhh = Number(BEGUZ.substring(0,2)) + 4 ;
                var tmpBEGmm = Number(BEGUZ.substring(2,4)) ;

                if (tmpBEGhh > 24) {
                    tmpBEGhh = tmpBEGhh - 24;
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                } else {
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                }
                if (tmpBEGhh == 24) tmpBEGhh = "00";

                //분계산
                if (Number(tmpBEGmm+60) >= 60) {
                    tmpBEGmm = Number(tmpBEGmm + 60) - 60;
                    tmpENDhh = tmpENDhh + 1;
                } else {
                    tmpBEGmm = Number(tmpBEGmm + 60);
                    tmpENDhh = tmpENDhh;
                }
                if (tmpBEGmm == 60 || tmpBEGmm == 0) tmpBEGmm = "00";

                if (tmpENDhh > 24) {
                    tmpENDhh = tmpENDhh - 24;
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                } else {
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                }
                if (tmpENDhh == 24) tmpENDhh = "00";

                document.form1.PBEG1.value = tmpBEGhh + ":" + BEGUZ.substring(2,4);
                document.form1.PEND1.value = tmpENDhh + ":" + tmpBEGmm;
                document.form1.PUNB1.value = "1";
                document.form1.STDAZ.value = STDAZ - 1;
            } else if (STDAZ >= 13 && STDAZ < 17) {
                var tmpBEGhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpENDhh = Number(BEGUZ.substring(0,2)) + 5;
                var tmpBEGmm = Number(BEGUZ.substring(2,4));
                var tmpSTD   = cal_time2(BEGUZ, ENDUZ) + "";

                //분 계산
                if (Number(tmpBEGmm+30) >= 60) {
                    tmpBEGmm = Number(tmpBEGmm + 30) - 60;
                    tmpENDhh = tmpENDhh +1;
                } else {
                    tmpBEGmm = Number(tmpBEGmm + 30);
                    tmpENDhh = tmpENDhh;
                }
                if (tmpBEGmm == 60 || tmpBEGmm == 0) tmpBEGmm = "00";

                if (tmpBEGhh >= 24) {
                    tmpBEGhh = tmpBEGhh - 24;
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                } else {
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                }
                if (tmpBEGhh == 24 || tmpBEGhh == 0) tmpBEGhh = "00";

                if (tmpENDhh >= 24) {
                    tmpENDhh = tmpENDhh - 24;
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                } else {
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                }
                if (tmpENDhh == 24 || tmpENDhh == 0) tmpENDhh = "00";

                document.form1.PBEG1.value = tmpBEGhh + ":" + BEGUZ.substring(2,4);
                document.form1.PEND1.value = tmpENDhh + ":" + tmpBEGmm;
                document.form1.PUNB1.value = "1.5";
                document.form1.STDAZ.value = tmpSTD - 1.5;

            } else if (STDAZ >= 17) {
                var tmpBEGhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpENDhh = Number(BEGUZ.substring(0,2)) + 6;
                var tmpBEGmm = BEGUZ.substring(2,4);
                var tmpSTD   = cal_time2(BEGUZ, ENDUZ) + "";

                if (tmpBEGhh >= 24) {
                    tmpBEGhh = tmpBEGhh - 24;
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                } else {
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                }
                if (tmpBEGhh == 24 || tmpBEGhh == 0) tmpBEGhh = "00";

                if (tmpENDhh >= 24) {
                    tmpENDhh = tmpENDhh - 24;
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                } else {
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                }
                if (tmpENDhh == 24 || tmpENDhh == 0) tmpENDhh = "00";

                document.form1.PBEG1.value = tmpBEGhh + ":" + tmpBEGmm;
                document.form1.PEND1.value = tmpENDhh + ":" + tmpBEGmm;
                document.form1.PUNB1.value = "2";
                document.form1.STDAZ.value = tmpSTD - 2;
            }

            //2013-06-28  휴게시간1시간이상 입력 체크
            // [Worktime52]
            var PUNB = Number(document.form1.PUNB1.value) + Number(document.form1.PUNB2.value);
          	//if (STDAZ >= 5 &&  (PUNB < 1)) {
          	if ( document.form1.STDAZ.value >= 5 && (PUNB < 1)) {
	            if (PUNB == null || PUNB == 0) {
	                alert("<spring:message code='MSG.D.D01.0009'/>");//5시간 이상 근무시 휴게시간 1시간 이상을 입력하세요.
	                document.form1.PBEG1.focus();
	                return false;
	            }
          	}

			// [worktime52] 휴일근로는 최대 8시간만 가능.2018-07-06
        	if (document.form1.STDAZ.value > 8) {
                alert("휴일근로는 최대 8시간 신청가능합니다.");	//휴일근로는 최대 8시간 신청가능합니다.
                document.form1.PBEG1.focus();
                return false;
            }

        ////////////////////////////////////////             평일                    ////////////////////////////////////////////////
        } else {
            if (BEGUZ.substring(2,4) != ENDUZ.substring(2,4)) {
                alert("초과근로의 시작 및 종료 시간은 한 시간 단위로 신청 가능 합니다.\n단, 입력 시각은 10분 단위로 입력하여 주시기를 바랍니다.\n예) 시작 09:30 ~ 종료 13:30 (○)\n     시작 09:31 ~ 종료 13:31 (Ｘ)");
                return false;
            }
            if (BEGUZ.substring(3,4) != "0" || ENDUZ.substring(3,4) != "0") {
                alert("초과근로의 시작 및 종료 시간은 한 시간 단위로 신청 가능 합니다.\n단, 입력 시각은 10분 단위로 입력하여 주시기를 바랍니다.\n예) 시작 09:30 ~ 종료 13:30 (○)\n     시작 09:31 ~ 종료 13:31 (Ｘ)");
                return false;
            }
            // 휴게시간 셋팅
            var STDAZ = cal_time2(BEGUZ, ENDUZ) + "";
            if (STDAZ < 5) {
                document.form1.STDAZ.value = STDAZ;
            }
            if (STDAZ >= 5 && STDAZ < 9) {
                var tmpBEGhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpENDhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpBEGmm = Number(BEGUZ.substring(2,4));
                var tmpSTD   = cal_time2(BEGUZ, ENDUZ) + "";
                //분 계산
                if (Number(tmpBEGmm+30) >= 60) {
                    tmpBEGmm = Number(tmpBEGmm + 30) - 60;
                    tmpENDhh = tmpENDhh + 1;
                } else {
                    tmpBEGmm = Number(tmpBEGmm + 30);
                    tmpENDhh = tmpENDhh;
                }
                if (tmpBEGmm == 60 || tmpBEGmm == 0) tmpBEGmm = "00";

                if (tmpBEGhh >= 24) {
                    tmpBEGhh = tmpBEGhh - 24;
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                } else {
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                }
                if (tmpBEGhh == 24 || tmpBEGhh == 0) tmpBEGhh = "00";

                if (tmpENDhh >= 24) {
                    tmpENDhh = tmpENDhh - 24;
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                } else {
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                }
                if (tmpENDhh == 24 || tmpENDhh == 0) tmpBEGhh = "00";

                document.form1.PBEG1.value = tmpBEGhh + ":" + BEGUZ.substring(2,4);
                document.form1.PEND1.value = tmpENDhh + ":" + tmpBEGmm;
                document.form1.PUNB1.value = "0.5";
                document.form1.STDAZ.value = tmpSTD - 0.5;

            } else if (STDAZ >= 9 && STDAZ < 13) {
                var tmpBEGhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpENDhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpBEGmm = Number(BEGUZ.substring(2,4));
                var tmpSTD   = cal_time2(BEGUZ, ENDUZ) + "";

                if (tmpBEGhh >= 24) {
                    tmpBEGhh = tmpBEGhh - 24;
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                } else {
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                }
                if (tmpBEGhh == 24 || tmpBEGhh == 0) tmpBEGhh = "00";

                //분계산
                if (Number(tmpBEGmm+60) >= 60) {
                    tmpBEGmm = Number(tmpBEGmm + 60) - 60;
                    tmpENDhh = tmpENDhh +1;
                } else {
                    tmpBEGmm = Number(tmpBEGmm + 60);
                    tmpENDhh = tmpENDhh;
                }
                if (tmpBEGmm == 60 || tmpBEGmm == 0) tmpBEGmm = "00";

                if (tmpENDhh >= 24) {
                    tmpENDhh = tmpENDhh - 24;
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                } else {
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                }
                if (tmpENDhh == 24 || tmpENDhh == 0) tmpENDhh = "00";

                document.form1.PBEG1.value = tmpBEGhh + ":" + BEGUZ.substring(2,4);
                document.form1.PEND1.value = tmpENDhh + ":" + tmpBEGmm;
                document.form1.PUNB1.value = "1";
                document.form1.STDAZ.value = tmpSTD - 1;

            } else if (STDAZ >= 13 && STDAZ < 17) {
                var tmpBEGhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpENDhh = Number(BEGUZ.substring(0,2)) + 5;
                var tmpBEGmm = Number(BEGUZ.substring(2,4));
                var tmpSTD   = cal_time2(BEGUZ, ENDUZ) + "";

                //분 계산
                if (Number(tmpBEGmm+30) >= 60) {
                    tmpBEGmm = Number(tmpBEGmm + 30) - 60;
                    tmpENDhh = tmpENDhh +1;
                } else {
                    tmpBEGmm = Number(tmpBEGmm + 30);
                    tmpENDhh = tmpENDhh;
                }
                if (tmpBEGmm == 60 || tmpBEGmm == 0) tmpBEGmm = "00";

                if (tmpBEGhh >= 24) {
                    tmpBEGhh = tmpBEGhh - 24;
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                } else {
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                }
                if (tmpBEGhh == 24 || tmpBEGhh == 0) tmpBEGhh = "00";

                if (tmpENDhh >= 24) {
                    tmpENDhh = tmpENDhh - 24;
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                } else {
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                }
                if (tmpENDhh == 24 || tmpENDhh == 0) tmpENDhh = "00";

                document.form1.PBEG1.value = tmpBEGhh + ":" + BEGUZ.substring(2,4);
                document.form1.PEND1.value = tmpENDhh + ":" + tmpBEGmm;
                document.form1.PUNB1.value = "1.5";
                document.form1.STDAZ.value = tmpSTD - 1.5;

            } else if (STDAZ >= 17) {
                var tmpBEGhh = Number(BEGUZ.substring(0,2)) + 4;
                var tmpENDhh = Number(BEGUZ.substring(0,2)) + 6;
                var tmpBEGmm = BEGUZ.substring(2,4);
                var tmpSTD   = cal_time2(BEGUZ, ENDUZ) + "";

                if (tmpBEGhh >= 24) {
                    tmpBEGhh = tmpBEGhh - 24;
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                } else {
                    if (tmpBEGhh < 10) {
                        tmpBEGhh = "0" + tmpBEGhh;
                    }
                }
                if (tmpBEGhh == 24 || tmpBEGhh == 0) tmpBEGhh = "00";

                if (tmpENDhh >= 24) {
                    tmpENDhh = tmpENDhh - 24;
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                } else {
                    if (tmpENDhh < 10) {
                        tmpENDhh = "0" + tmpENDhh;
                    }
                }
                if (tmpENDhh == 24 || tmpENDhh == 0) tmpENDhh = "00";

                document.form1.PBEG1.value = tmpBEGhh + ":" + tmpBEGmm;
                document.form1.PEND1.value = tmpENDhh + ":" + tmpBEGmm;
                document.form1.PUNB1.value = "2";
                document.form1.STDAZ.value = tmpSTD - 2;
            }
        }
    }

	</c:if>
</c:if>


	//휴게시간2 자동
	if( document.form1.PBEG2.value != "" && document.form1.PEND2.value != ""){
		if (PUNB2 != "" || PUNB2 != 0){
			tmpSTDAZ = document.form1.STDAZ.value;
			document.form1.STDAZ.value = (tmpSTDAZ - PUNB2) ;
		}
	}

    var curDate = "${f:currentDate()}";//현재일자
    var temp_1mon = getAfterMonth(addSlash(curDate), -1);//1개월 전
    var before_1month1day = temp_1mon.substring(0,6) + "01";//1개월 전 1일
    var dayCount = dayDiff(before_1month1day, document.form1.WORK_DATE.value);

    if (dayCount < 0) {
        alert("초과근무 사후신청 시 초과근무일자는 전 월 1일 이후로 신청이 가능합니다.");
        document.form1.WORK_DATE.focus();
        return false;
    }

    return true;
}

//휴식시간 첵크 로직
function freetime_check(BEGUZ, ENDUZ, CHECKTIME) {
    if (CHECKTIME != "") {
        if (BEGUZ > ENDUZ) {
            if (Number(CHECKTIME) < Number(BEGUZ)) {//경우 잘못된값  true 리턴
                if (Number(CHECKTIME) > Number(ENDUZ)) {
                    return true;
                }
            }
            return false;
        } else if (BEGUZ < ENDUZ) {    //주의  flag에 따라 체크 방법이 틀림
            if (Number(BEGUZ) <= Number(CHECKTIME)) {
                if (Number(CHECKTIME) <= Number(ENDUZ)) {
                    return false;
                }
            } else if (CHECKTIME == 0 && ENDUZ == 2400) {
                return false;
            }
            return true;
        }
    }
    return false;
}

function EnterCheck2() {
    if (event.keyCode == 13)  {
        doCheck();
    }
}

function onlyFloat() {
    if (event.keyCode == 13 || event.keyCode == 46 || event.keyCode == 37 || event.keyCode == 39)  {
        //enter , backspace, delete, left right arrow pass
        event.returnValue= true;
    } else  if (event.keyCode < 48 || event.keyCode > 57)  {
        event.returnValue= false;
    }
}

function EnterChecktest() {//사용안함
    if (event.keyCode == 13) {
        var testvar = document.form1.OVTM_DESC.value;
        var testvar2 = testvar.replace(/\r\n/g, "^@");
        alert(testvar2);
        var testvar3 = testvar2.replace(/\^@/g, "\n");
        alert(testvar3);
    }
}

function f_timeFormat(obj) {
    valid_chk = true;

    t = obj.value;
    if (t == "" || t == 0) {
        return true;
    } else {
        if (!isNaN (t)) {
            if (99.99 > t && t > 0) {
                t = t + "";
                d_index = t.indexOf(".");
                if (d_index != -1) {
                    tmpstr = t.substring(d_index + 1, t.length);
                    if (tmpstr.length > 2) { //소수점 2제자리가 넘는경우
                        alert("<spring:message code='MSG.D.D01.0008' />");
                        obj.focus();
                        obj.select();
                        return false;
                    }
                }
                return true;
            }
        }
        alert("<spring:message code='MSG.D.D01.0008' />");//" 입력 형식이 틀립니다.\n \'##.## \'형식으로 입력하세요 "
        obj.focus();
        obj.select();
        return false;
    }
}

function check_Time() {
    if (document.form1.WORK_DATE.value != "") {
        if (document.form1.BEGUZ.value != "" && document.form1.ENDUZ.value != "") {
            if (document.form1.PBEG1.value == "" && document.form1.PEND1.value == "") {
                if (document.form1.PBEG2.value == "" && document.form1.PEND2.value == "") {
                    doCheck();
                } else if (document.form1.PBEG2.value != "" && document.form1.PEND2.value != "") {
                    doCheck();
                }
            } else if (document.form1.PBEG1.value != "" && document.form1.PEND1.value != "") {
                if (document.form1.PBEG2.value == "" && document.form1.PEND2.value == "") {
                    doCheck();
                } else if (document.form1.PBEG2.value != "" && document.form1.PEND2.value != "") {
                    doCheck();
                }
            }
        }
    }
    OVTM_Sel(document.form1.OVTM_CODE);
}

// 2003.01.17 - 초과근무신청을 막는다. //////////////////////////////
function after_fn_openCal() {
    on_Blur(document.form1.WORK_DATE);
}

function on_Blur(obj) {
    if (obj.value != "" && dateFormat(obj)) {
        date_n = Number(removePoint(obj.value));
        if (date_n < "${ D_RRDAT }") {
            alert("<spring:message code='MSG.D.D01.0007' arguments='${ E_RRDAT=="" ? "" : f:printDate(E_RRDAT) }'/>");//일 이후에만 신청 가능합니다.
            obj.focus();
            return false;
        }
    }
}

//[WorkTime52] --------------------------------------------------------------------------
function on_Change(obj) {
    var curMonth = '${ f:currentDate() }'.substring(4,6);
    if ('${EMPGUB}' == "S") {		// 사무직
    	if ('${TPGUB}' == "C") {	//  A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제), X(주재원 및 비대상)
	        if (obj.value != "" && dateFormat(obj)) {
	            var url  = '/servlet/servlet.hris.D.D01OT.D01OTBuildSV';
	            var pars = 'jobid=ajax&I_EMPGUB=S&DATUM=' + removePoint(obj.value);

	            blockFrame();
	            $.ajax({type:'GET', url: url, data: pars, cache: false, dataType: 'html', success: showResponse_S});
	        }
    	}
    }
}

//사무직
function showResponse_S(originalRequest)    {

    if (originalRequest != "") {
        var O = JSON.parse(originalRequest);
        $('#E_BASTM').text (Number(O.E_BASTM));
        $('#E_MAXTM').text (Number(O.E_MAXTM));
        $('#E_PWDWK').text (Number(O.E_PWDWK) + " (" + Number(O.E_CWDWK) + ")");
        $('#E_PWEWK').text (Number(O.E_PWEWK) + " (" + Number(O.E_CWEWK) + ")");
        $('#E_SUMPW').text (Number(O.E_PWTOT) + " (" + Number(O.E_CWTOT) + ")");

        document.form1.HOLID.value = O.E_HOLID;
        document.form1.SOLLZ.value = O.E_SOLLZ;
        document.form1.SHIFT.value = O.E_SHIFT;
    }
    $.unblockUI();
}
// 현장직
function showResponse_H(O) {

    if ($.isPlainObject(O)) {
        $('#GIGAN').text("(" + O.BEGDA + " ~ " + O.ENDDA + ")");
        $('#H_BASTM').text(Number(O.BASTM));
        $('#H_RWSUM').text(Number(O.RWSUM) + "/" + Number(O.RWTOT));
        $('#H_RWWEK').text(Number(O.RWWEK));

        document.form1.HOLID.value = O.Holidycheck01;
        document.form1.SOLLZ.value = O.Holidycheck02;
    }
    $.unblockUI();
}

//[WorkTime52] --------------------------------------------------------------------------

//20150318 [CSR ID:2803878] 초과근무 신청화면 수정
function ovtmDescFill(obj) {
    if (obj.value.trim() == "※ 초과근무일에 수행할 업무에 대하여 상세히 기재하여 주시기 바랍니다.") {
        obj.value = "";
    }
}

function ovtmDescClear(obj) {
    var tt = obj.value;
    tt = tt.replace(/\r\n/gi, "");
    tt = tt.replace(/ /gi, "");

    if (tt.length == 0) {
        obj.value = obj.defaultValue;
    } else {
        obj.value = obj.value;
    }
}

function replaceOvtm1() {//사용안함
    var orgvar = document.form1.OVTM_DESC.value;
    var chgvar = orgvar.replace(/\r\n/g, "^@");
    document.form1.OVTM_DESC.value = chgvar;
}

function replaceOvtm2() {//사용안함
    var orgvar = document.form1.OVTM_DESC.value;
    var chgvar = orgvar.replace(/\^@/g, "\n");
    document.form1.OVTM_DESC.value = chgvar;
}

function textArea_to_TextFild(text) {
    var tmpText = "";
    var tmplength = 0;
    var count = 1;
    var flag = true;

//[CSR ID:2589455] *(42) 제거 로직 추가----------------------------
    for (var i = 0; i < text.length; i++) {
        if (text.charCodeAt(i) != 42) {
            tmpText += text.charAt(i);
        }
    }
    text = tmpText;
    tmpText = "";
//-----------------------------------------------------------------

    for (var i = 0; i < text.length; i++) {
        tmplength = checkLength(tmpText);

/*    enter 키 입력시 값에 엔터키 코드(13)을 제거하기 위한 부분 추가.. 김성일 */
//    2003.04.16 << text.charCodeAt(i) != 10 >> 추가함 13과 10을 동시에 check해야함 - 김도신

        if (Number(tmplength) < 70) {
            tmpText += text.charAt(i);
            flag = true
        } else {
            flag = false;
            tmpText.trim;

//           if (text.charCodeAt(i) == 13) {
//               eval("document.form1.OVTM_DESC"+count+".value="+"tmpText");
//               count++;
//           }
//           else
            if (Number(tmplength) >= 70) { // @v1.4
                eval("document.form1.OVTM_DESC" + count + ".value=tmpText");
                count++;
                i--;
            }
            tmpText="";   //text.charAt(i);

            if (count > 4) {
                break;
            }
        }
/*    enter 키 입력시 값에 엔터키 코드(13)을 제거하기 위한 부분 추가.. 김성일 */
    }

    if (flag) {
        eval("document.form1.OVTM_DESC" + count + ".value=tmpText");
    }
}

//[CSR ID:2803878] textarea 4줄 이상 입력 못하게 막음.
function areaMax(area) {
    var value = $.trim(area.value);
    if (!value) {
        return;
    }

    var str = value;
    var enter_num = 0;

    for (var i = 0; i < str.length; i++) {
        var ascii = str.charCodeAt(i);

        if (ascii == 13) { // 아스키값이 13번 엔터값일때
            enter_num++;                                       // 엔터값 count 증가
        }
    }

    value = value.split("\n");

    line = Number(area.getAttribute('rows'));

    if (3 < enter_num) {
        alert("<spring:message code='MSG.D.D01.0006'/>");//한 줄당 35자 총 4줄까지 작성할 수 있습니다.\n(글자 잘림이 발생할 수 있습니다.
        area.value = value.splice(0, 4).join("\n");
        area.focus();
    }
}

// [WorkTime52]
function popupWorkTime(EmpGubun, Pernr) {
    var WorkDate = removePoint(document.form1.WORK_DATE.value);
    if (WorkDate == "") {
        WorkDate = "${f:currentDate()}";//현재일자
    }

    popupView(EmpGubun, Pernr, WorkDate);
}

function popupView (EmpGubun, Pernr, WorkDate) {
    var datum = WorkDate;
    var year  = datum.substring(0, 4);
    var month = datum.substring(4, 6);
    var day   = datum.substring(7, 10);

    if (EmpGubun == 'H' && day > 20) {
        month = Number(month) + 1;
    }

    var paramString = "?isPop=Y&PARAM_PERNR=" + Pernr + "&SEARCH_GUBUN=M&SEARCH_YEAR=" + year + "&SEARCH_MONTH=" + month;
    var theURL = "${g.servlet}hris.D.D25WorkTime.D25WorkTimeReportSV" + paramString;
    var retData = showModalDialog(theURL, window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:1200px;dialogHeight:700px");
}

// 처음 load
$(function() {
    <c:if test="${isUpdate != true}">parent.resizeIframe(document.body.scrollHeight);</c:if>
    $('#WORK_DATE').datepicker('option','numberOfMonths', 1);
    msg();

    // [WorkTime52]
    on_Change(document.getElementById('WORK_DATE'));

});
</script>

<tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_STAT_APPL" representative="true" disable="${ OTbuildYn !='Y'}" disableApprovalLine="${ OTbuildYn !='Y'}">

<jsp:include page="${g.jsp }D/timepicker-include.jsp" />

<input type="hidden" name="BEGDA" value="${isUpdate ? data.BEGDA : f:printDate(f:currentDate())}" />

<c:choose><c:when test='${ OTbuildYn != "Y"}'>

<div class="align_center">
    <p><spring:message code="MSG.D.D15.0211" /></p><!-- 대상자가 아닙니다. -->
</div>

</c:when><c:otherwise>

<!-- 상단 입력 테이블 시작-->
<div class="tableArea">
    <div class="table">
        <table class="tableGeneral" style="table-layout:fixed">
            <colgroup>
                <col style="width:15%" />
                <col />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D01.0001" /><!-- 초과근무일 --></th>
                    <td>
                        <input type="text" id="WORK_DATE" name="WORK_DATE" class="date required datetime-yyyymmdd" style="margin-right:5px"
                            placeholder="<spring:message code='LABEL.D.D01.0001' />"
                            value="${ f:printDate(data.WORK_DATE) }" onchange="on_Change(this);" /><!-- onBlur="javascript:on_Blur(this);"-->

                        <c:if test='${ user.companyCode=="C100" }'>   <!--  LG화학 -->
                        <input type="checkbox" name="VTKEN" value="X"${ data.VTKEN eq "X" ? " checked" : "" } style="margin-left:8px" />
                        <spring:message code="MSG.D.D01.0051" /><!-- 前日 근태에 포함-->
                        <div class="commentOne" style="margin-top:3px; margin-left:6px; display:block"><spring:message code="MSG.D.D01.0052" /></div>
                        </c:if>
                    </td>
                    <!-- [CSR ID:2803878] 초과근무 신청 화면 수정 -->
<!-- [WorkTime52] PJT 시작 -->
<c:choose><c:when test='${TPGUB eq "C"}'><!-- 사무직 선택근무제의 경우 -->
                    <td rowspan="5" style="box-sizing:border-box; width:525px; padding:15px">
                        <div class="commentImportant real-worktime-list">
                            <table class="infoTable">
                                <colgroup>
                                    <col style="width: 60px" />
                                    <col style="width:100px" />
                                    <col style="width:125px" />
                                    <col style="width:180px" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th colspan="4" class="lastCol"><spring:message code="LABEL.D.D01.0031" /></th><%-- 초과근무 신청 가능여부(시간) --%>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th rowspan="2"><spring:message code="LABEL.D.D01.0023" /><!-- 기준 --></th>
                                        <td><spring:message code="LABEL.D.D01.0024" /><!-- 기본근무 --></td>
                                        <td><span id="E_BASTM">${f:printNum(E_BASTM)}</span></td>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0034" /></td><!-- 주중 평일 x 8시간 -->
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0025" /><!-- 법정최대한도 --></td>
                                        <td><span id="E_MAXTM">${f:printNum(E_MAXTM)}</span></td>
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0036" /></td><!-- 달력 일수 / 7 x 52시간 -->
                                    </tr>
                                    <tr>
                                        <th rowspan="3"><spring:message code="LABEL.D.D01.0037" /><!-- 실적 --></th>
                                        <td><spring:message code="LABEL.D.D01.0038" /></td><!-- 주중근로 -->
                                        <td><span id="E_PWDWK">${f:printNum(E_PWDWK)} (${f:printNum(E_CWDWK)})</span><spring:message code="LABEL.D.D01.0044" /></td><!-- <sup>주)</sup> -->
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0043" /></td><!-- 유급휴가 포함 기준 -->
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0039" /></td><!-- 주말/휴일 -->
                                        <td><span id="E_PWEWK">${f:printNum(E_PWEWK)} (${f:printNum(E_CWEWK)})</span><spring:message code="LABEL.D.D01.0044" /></td><!-- <sup>주)</sup> -->
                                        <td class="lastCol"></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0040" /></td><!-- 계 -->
                                        <td><span id="E_SUMPW">${f:printNum(E_SUMPW)} (${f:printNum(E_SUMCW)})</span><spring:message code="LABEL.D.D01.0044" /></td><!-- <sup>주)</sup> -->
                                        <td class="lastCol"><spring:message code="LABEL.D.D01.0041" /></td><!-- 법정최대한도시간 초과 불가 -->
                                    </tr>
                                </tbody>
                            </table>
                            <div class="commentOne"><spring:message code="LABEL.D.D01.0042" /></div><!-- 주) 실적의 ()안의 시간은 품의/승인을 받은 실근로시간입니다.-->
                        </div>
                    </td>
</c:when><c:otherwise>
                    <td rowspan="5" style="box-sizing:border-box; width:280px; padding:15px">
                        <div class="commentImportant real-worktime-list">
                            <table class="infoTable" style="width:100%">
                                <colgroup>
                                    <col style="width:50%" />
                                    <col />
                                </colgroup>
                                <tbody>
                                    <tr> <!-- //[WorkTime52]  -->
                                        <td colspan="2" class="lastCol align_center">
                                            ${MONTH}<spring:message code="LABEL.D.D01.0009" /> <!-- 월 초과근무 현황-->
                                            <!-- [CSR ID:2803878] 초과근무 문구수정 -->
                                            <br /><spring:message code="LABEL.D.D01.0010" /> <!--(전월 21일 ~ 당월 20일 기준)-->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0011" /><!-- 평일연장--></td>
                                        <td class="lastCol"><span id="span0">${YUNJANG}</span> <spring:message code="LABEL.D.D01.0008" /><!--&nbsp;시간--></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0012" /><!-- 휴일근로--></td>
                                        <td class="lastCol"><span id="span1">${HTKGUN}</span> <spring:message code="LABEL.D.D01.0008" /><!--&nbsp;시간--></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0013" /><!-- 휴일연장--></td>
                                        <td class="lastCol"><span id="span2">${HYUNJANG}</span> <spring:message code="LABEL.D.D01.0008" /><!--&nbsp;시간--></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0014" /><!-- 야간근로--></td>
                                        <td class="lastCol"><span id="span3">${YAGAN}</span> <spring:message code="LABEL.D.D01.0008" /><!--&nbsp;시간--></td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="LABEL.D.D01.0015" /><!-- 결재 진행 중<br>초과근로--></td>
                                        <td class="lastCol"><span id="span4">${NOAPP}</span> <spring:message code="LABEL.D.D01.0008" /><!--&nbsp;시간--></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
</c:otherwise></c:choose>
<!-- [WorkTime52] PJT 추가 끝-->
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D12.0043" /><!-- 시간 --></th>
                    <td>
                        <input type="text" class="required datetime-hhmm" id="BEGUZ" name="BEGUZ"
                            placeholder="<spring:message code='LABEL.D.D12.0043' />"
                            value="${  f:printTime(data.BEGUZ) }"
<%--                        onfocus=' if ($(this).val()=="")$(this).val("0000");' --%>
                            onkeypress="EnterCheck2();"
                            onchange="OVTM_Sel(document.form1.OVTM_CODE);"><a href="javascript:fn_openTime('BEGUZ');"><img src="${ g.image }/sshr/ico_magnify.png"></a>
                        ~
                        <input type="text" class="required datetime-hhmm" id="ENDUZ" name="ENDUZ"
                            placeholder="<spring:message code='LABEL.D.D12.0043' />"
                            value="${ f:printTime(data.ENDUZ) }"
<%--                        onfocus=' if ($(this).val()=="")$(this).val("0000");' --%>
                            onkeypress="EnterCheck2();"
                            onchange="OVTM_Sel(document.form1.OVTM_CODE);"><a href="javascript:fn_openTime('ENDUZ');"><img src="${ g.image }/sshr/ico_magnify.png"></a>

                        <input type="text" name="STDAZ" value="${ data.STDAZ eq '' ? '' : (data.STDAZ eq '0' ? '' : f:printNum(data.STDAZ)) }" class="datetime-hours" readonly="readonly" />
                        <spring:message code="LABEL.D.D01.0008" /><!-- 시간 -->
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D15.0157" /><!-- 신청사유--></th>
                    <td class="reason-box">
                        <table>
                            <colgroup>
                                <col style="width:170px" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td id="Reason" style="padding-right:8px${OTbuildYn eq 'Y' and D03VocationAReason_vt_size > 0 ? '' : '; display:none'}"><%-- CSR ID:1546748 --%>
                                        <!-- CSR ID:1546748 -->
                                        <select name="OVTM_CODE" class="required" onchange="OVTM_Sel(this)" placeholder="<spring:message code='LABEL.D.D15.0157' />">
                                            <option value="">-------------</option>
                                            ${ f:printOption(newOpt,'code','value', data.OVTM_CODE) }
                                        </select>
                                    </td>
                                    <td>
                                        <input type="text" name="REASON" class="required" value="${ data.REASON }"
                                            placeholder="<spring:message code='LABEL.D.D15.0157' />" onkeypress="EnterCheck2();">
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr id="OvtmName"${OTbuildYn eq 'Y' and D03VocationAReason_vt_size > 0 and officerYN eq 'N' ? '' : ' style="display:none"'}><%-- CSR ID:1546748 --%>
                    <th><spring:message code="LABEL.D.D01.0002" /><!--원근무자(대근시)--></th>
                    <td style="box-sizing:border-box">
                        <input type="text" name="OVTM_NAME" value="${ data.OVTM_NAME }" style="box-sizing:border-box; width:100%; max-width:none"
                            maxlength="10" style="ime-mode:active" onkeypress="EnterCheck2();">
                    </td>
                </tr>
                <!-- 초과근무 신청 화면 추가 사항 [CSR ID:2803878]-->
                <tr>
                    <th><span class="textPink">*</span><spring:message code="LABEL.D.D01.0003" /><!--상세업무일정--></th>
                    <!-- [CSR ID:2803878] 상세업무일정문구수정 -->
                    <td class="work-detail-box">
<c:choose><c:when test='${data.OVTM_DESC1=="" and data.OVTM_DESC2=="" and data.OVTM_DESC3=="" and data.OVTM_DESC4==""}'>
                        <textarea name="OVTM_DESC" class="required" wrap="hard" placeholder="<spring:message code='LABEL.D.D01.0003' />"
                            onblur="ovtmDescClear(this)" onfocus="ovtmDescFill(this)" onchange="areaMax(this)">
1. 업무 수행 장소 :
2. 수행할 업무(상세히 기재)
    </textarea>
</c:when><c:otherwise>
                        <textarea name="OVTM_DESC" class="required" wrap="hard" placeholder="<spring:message code='LABEL.D.D01.0003' />"
                            onblur="ovtmDescClear(this)" onfocus="ovtmDescFill(this)" onchange="areaMax(this)">${data.OVTM_DESC1}${data.OVTM_DESC2}${data.OVTM_DESC3}${data.OVTM_DESC4}</textarea>
</c:otherwise></c:choose>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- 상단 입력 테이블 끝-->

<div class="listArea">
    <div class="table">
        <table class="listTable">
            <colGroup>
                <col style="width:15%" />
                <col style="width:21.25%" />
                <col style="width:21.25%" />
                <col style="width:21.25%" />
                <col style="width:21.25%" />
            </colGroup>
            <thead>
                <tr>
                    <th>&nbsp;</th>
                    <th><spring:message code="LABEL.D.D15.0162" /><!--시작시간--></th>
                    <th><spring:message code="LABEL.D.D15.0163" /><!--종료시간--></th>
                    <th><spring:message code="LABEL.D.D01.0004" /><!--무급--></th>
                    <th class="lastCol"><spring:message code="LABEL.D.D01.0005" /><!--유급--></th>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow">
                    <td><spring:message code="LABEL.D.D01.0006" /><!--휴게시간1--></td>
                    <td>
                        <input type="text" class="timeRestx datetime-hhmm" id="PBEG1" name="PBEG1" value="${ f:printTime(data.PBEG1) }" onkeypress="EnterCheck2();" /><!-- onChange="check_Time();" -->
                        <a href="javascript:fn_openTime('PBEG1');"><img src="${ g.image }/sshr/ico_magnify.png"></a>
                    </td>
                    <td>
                        <input type="text" class="timeRestx datetime-hhmm" id="PEND1" name="PEND1" value="${ f:printTime(data.PEND1) }" onkeypress="EnterCheck2();" /><!-- onChange="check_Time();" -->
                        <a href="javascript:fn_openTime('PEND1');"><img src="${ g.image }/sshr/ico_magnify.png"></a>
                    </td>
                    <td>
                        <input type="text" class="datetime-hours" id="PUNB1" name="PUNB1" value="${ empty data.PUNB1 ? '' : data.PUNB1 eq '0' ? '' : f:printNum(data.PUNB1) }" onkeypress="EnterCheck2(); onlyFloat();" />
                    </td>
                    <td class="lastCol">
                        <input type="text" class="datetime-hours" id="PBEZ1" name="PBEZ1" value="${ empty data.PBEZ1 ? '' : data.PBEZ1 eq '0' ? '' : f:printNum(data.PBEZ1) }" onkeypress="EnterCheck2(); onlyFloat();" />
                    </td>
                </tr>
                <tr>
                    <td><spring:message code="LABEL.D.D01.0007" /><!--휴게시간2--></td>
                    <td>
                        <input type="text" class="timeRestx datetime-hhmm" id="PBEG2" name="PBEG2" value="${ f:printTime(data.PBEG2) }" onkeypress="EnterCheck2();" /><!-- onChange="check_Time();" -->
                        <a href="javascript:fn_openTime('PBEG2');"><img src="${ g.image }/sshr/ico_magnify.png"></a>
                    </td>
                    <td>
                        <input type="text" class="timeRestx datetime-hhmm" id="PEND2" name="PEND2" value="${ f:printTime(data.PEND2) }" onkeypress="EnterCheck2();" /><!-- onChange="check_Time();" -->
                        <a href="javascript:fn_openTime('PEND2');"><img src="${ g.image }/sshr/ico_magnify.png"></a>
                    </td>
                    <td>
                        <input type="text" class="datetime-hours" id="PUNB2" name="PUNB2" value="${ empty data.PUNB2 ? '' : data.PUNB2 eq '0' ? '' : f:printNum(data.PUNB2) }" onkeypress="EnterCheck2(); onlyFloat();" />
                    </td>
                    <td class="lastCol">
                        <input type="text" class="datetime-hours" id="PBEZ2" name="PBEZ2" value="${ empty data.PBEZ2 ? '' : data.PBEZ2 eq '0' ? '' : f:printNum(data.PBEZ2) }" onkeypress="EnterCheck2(); onlyFloat();" />
                    </td>
                </tr>
            </tbody>
        </table>
        <span class="commentOne"><spring:message code="MSG.COMMON.0061" /></span><!-- <span class="textPink">*</span> 는 필수 입력사항입니다.  -->
    </div>
</div>
</c:otherwise></c:choose>

<input type="hidden" name="OVTM12YN" /><!-- [CSR ID:2803878] 초과근무 신청 화면 수정 confirm 값을 yes로 하면 Y로... -->
<input type="hidden" name="OVTM_DESC1" />
<input type="hidden" name="OVTM_DESC2" />
<input type="hidden" name="OVTM_DESC3" />
<input type="hidden" name="OVTM_DESC4" />
<input type="hidden" name="initCount" value="0">
<!-- [WorkTime52 : 평일/공휴일 -->
<input type="hidden" name="HOLID" /><!-- 휴일체크1 -->
<input type="hidden" name="SOLLZ" /><!-- 휴일체크2 -->
<input type="hidden" name="SHIFT" /><!-- 일근직 4조 3교대 여부 -->

</tags-approval:request-layout>
</tags:layout>
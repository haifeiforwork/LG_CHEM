<%
	/******************************************************************************/
	/*                                                                              */
	/*   System Name  : MSS                                                         */
	/*   1Depth Name  : MY HR 정보                                                  */
	/*   2Depth Name  : 휴가                                                        */
	/*   Program Name : 휴가 신청                                                   */
	/*   Program ID   : D03VocationBuild.jsp                                        */
	/*   Description  : 휴가를 신청하는 화면                                        */
	/*   Note         :                                                             */
	/*   Creation     : 2002-01-03  김도신                                          */
	/*   Update       : 2005-02-16  윤정현                                          */
	/*                  2008-03-14  CSR ID:1225704 경조선택시 경조내역조회팝업추가  */
	/*                  2009-10-26  CSR ID:1546748 여수공장 사유 목록화처리       */
	/*                  2011-09-16  CSR ID:C20110915_62868   인사하위영역이 파주공장(BBIA) 이고 기능직인 경우 휴일비근무 신청가능하게  */
	/*                  2011-10-25  ※CSR ID:C20111025_86242   모성보호휴가 유형추가 :0190 */
	/*                  2013-02-01  [※CSR ID:C20130130_63372]반일휴가 신청 변경요청 */
	/*                               1. 반일(전반)종료시간이 14:00 이후 불가          */
	/*                               2. 반일(후반)시작시간이 13:00 이전 불가          */
	/*                  2013-06-18  [※CSR ID:C20130617_50756 ] 하계휴가 신청 기간 조정요청  */
	/*                  2013-09-03  [※CSR ID:@@@ ] 유급휴일 토요일은 경조휴가일수에 미산입(단, 6일 이상의 경조휴가에 한해 토요일 산입)  */
	/*                      경조휴가  조위 : 0003 인 경우 경조발생일 이전 신청시 오류 */
	/*                  2013-12-10   경조일포함 체크로직 :9001:자녀출산(유급)9002:자녀출산(무급) ,9000:탈상 제외   */
	/*                  2014-02-21   C20140219_89877 공가문구변경   */
	/*                  2014-05-13  C20140515_40601 E_PERSK - 27 ,28 사무직시간선택제(4H,6H) 반일은 비활성화 처리 */
	/*                  2014-07-11  [CSR ID:2574241] 하계휴가 사용기간 관련 시스템 수정요청                                        */
	/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
	/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
	/*                  2014-12-10 이지은D [CSR ID:2659869] HR Center 공가신청時 일부 사유(전출 공가) 제외 요청의 건   */
	/*                  2015-05-19 이지은D [CSR ID:2779214] 전일공가 신청시 문구 수정 요청  */
	/*                  2015-06-18 이지은D 2015-06-18 [CSR ID:2803878] 초과근무 신청 Process 변경 요청 */
	/*                  2015-06-18 이지은D 2015-07-18  [CSR ID:2827544] 하계휴가 신청기한 설정요청 */
	/*               2016-06-07 김불휘S [CSR ID:3083608 ] 하계휴가 신청 기간 조정요청      */
	/*               2016-07-27 김불휘S [CSR ID:3129048] 하계휴가사용기간 한계결정 수정      */
	/*                  : 2016-09-20 통합구축 - 김승철                     */
	 /*				2017-04-10 eunha [CSR ID:3351729] 전지재료 익산공장 야간 교대조 휴가신청 Error
	 /*				2017-06-08 eunha [CSR ID:3400943] 하계휴가 신청기간 셋팅 요청의 건
	 /*				2017-07-03 eunha [CSR ID:3420919] 연차휴가 신청사유 필수사항 삭제 요청의 건*/
	 /*				2017-07-20 eunha [CSR ID:3438118] flexible time 시스템 요청*/
	 /*				2017-08-21 eunha  [CSR ID:3462893] 잔여연차 오류 수정요청의 건*/
	 /*				2017-10-12 eunha [CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청*/
	 /*				2017-02-22 rdcamel [CSR ID:3612320] 20년 근속/정년퇴직 여행 공가 생성 요청 */
	 /* 				2018-04-16 cykim [CSR ID:3659836] 20년 근속/정년퇴직 여행 공가 생성 요청  */
	 /*				2018-05-16 성환희 [WorkTime52] 보상휴가 추가 건  */
	 /* 				2018-06-11 cykim [CSR ID:3708353] [긴급] 2018 하계휴가 신청 가능 기간 셋팅 요청의 건 */
	 /* 				2018-07-20 cykim [CSR ID:3745810] 20년 근속 여행휴가 사용 오류 건  */
	/********************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/web/common/commonProcess.jsp"%>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval"%>
<%@ page import="org.apache.commons.lang.math.NumberUtils"%>

<%@ page import="java.util.Vector"%>
<%@ page import="hris.D.D03Vocation.*"%>
<%@ page import="hris.D.D03Vocation.rfc.*"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="hris.D.*"%>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="hris.E.E19Congra.rfc.*"%>

<%
	WebUserData user = (WebUserData) session.getAttribute("user");
	String jobid = (String) request.getAttribute("jobid");
	String message = (String) request.getAttribute("message");
	String E_AUTH = (String) request.getAttribute("E_AUTH");

	/* 장치교대근무자 체크 */
	D03RemainVocationData dataRemain = (D03RemainVocationData) request.getAttribute("d03RemainVocationData");

	String E_COMP = DataUtil.getValue(dataRemain, "E_COMP");

	/* 휴가신청 */
	Vector d03VocationData_vt = null;
	D03VocationData data = null;
	d03VocationData_vt = (Vector) request.getAttribute("d03VocationData_vt");
	data = (D03VocationData) d03VocationData_vt.get(0);

	if (message == null) {
		message = "";
	}

	//  2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
	GetTimmoRFC rfc = new GetTimmoRFC();

	String E_RRDAT = rfc.GetTimmo(user.companyCode);
	long D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT, "-"));

	Vector OTHDDupCheckData_vt = (Vector) request.getAttribute("OTHDDupCheckData_vt");

	Object D03GetWorkdayData_vt = null;
	//if("Y".equals(E_AUTH)) {
	String vocaType = (data.AWART.equals("0111")
					|| data.AWART.equals("0112")
					|| data.AWART.equals("0113")) ? "B" : "A";
	D03GetWorkdayOfficeRFC func = new D03GetWorkdayOfficeRFC();
	D03GetWorkdayData_vt = func.getWorkday(data.PERNR, DataUtil.getCurrentDate(), vocaType);
//	} else {
//		D03GetWorkdayRFC func = new D03GetWorkdayRFC();
//		D03GetWorkdayData_vt = func.getWorkday(data.PERNR, DataUtil.getCurrentDate());
//	}

	// 사전부여휴가 잔여일수
	String ZKVRB1 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB1");
	// 선택적보상휴가 잔여일수
	String ZKVRB2 = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB2");
	// 잔여휴가일수
	String ZKVRB = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB");
	String E_REMAIN = DataUtil.getValue(D03GetWorkdayData_vt, "E_REMAIN");
	PersonData PERNR_Data = (PersonData) request.getAttribute("PersonData");

	//CSR ID:1546748
	String DATUM = DataUtil.getCurrentDate();
	String E_BTRTL = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode, data.PERNR, data.AWART, DATUM);
	String YaesuYn = "";

	if (E_BTRTL.equals("BAAA") || E_BTRTL.equals("BAAB") || E_BTRTL.equals("BAAC") || E_BTRTL.equals("BAAD")
			|| E_BTRTL.equals("BAAE") || E_BTRTL.equals("BAAF") || E_BTRTL.equals("BAEA")
			|| E_BTRTL.equals("BAEB") || E_BTRTL.equals("BAEC") || E_BTRTL.equals("CABA")
			|| E_BTRTL.equals("BBIA")) {
		YaesuYn = "Y";
	}
	// 2007.12.20. 전LG석유화학 휴일비근무 전문기술직만 신청 추가
	// C20110915_62868 인사하위영역이 파주공장(BBIA) 이고 기능직인 경우 휴일비근무 신청가능하게
	// [CSR ID:2583929] 생산기술직 38 추가
	String H0340_Yes = "";
	if (PERNR_Data.E_PERSK.equals("31") || (E_BTRTL.equals("BBIA")
			&& (PERNR_Data.E_PERSK.equals("33") || PERNR_Data.E_PERSK.equals("38")))) {
		H0340_Yes = "Y";
	}
	String WOMAN_YN = "";

	if (!(PERNR_Data.E_REGNO.equals("")) && (PERNR_Data.E_REGNO.substring(6, 7).equals("2")
			|| PERNR_Data.E_REGNO.substring(6, 7).equals("4") || PERNR_Data.E_REGNO.substring(6, 7).equals("6")
			|| PERNR_Data.E_REGNO.substring(6, 7).equals("8")
			|| PERNR_Data.E_REGNO.substring(6, 7).equals("0"))) {
		WOMAN_YN = "Y";
	}

	String CONG_DATE = (String) request.getAttribute("CONG_DATE"); // @@@ 경조일자
	String HOLI_CONT = (String) request.getAttribute("HOLI_CONT"); // @@@ 경조일수
	String P_A024_SEQN = (String) request.getAttribute("P_A024_SEQN"); // @@@

	E19CongCodeNewRFC e19rfc = new E19CongCodeNewRFC();
	Vector congVT = e19rfc.getCongCode(user.companyCode, "X");

	//CSR ID:1546748
	Vector D03VocationAReason_vt = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR,
			data.AWART, data.BEGDA);
	Vector newOpt = new Vector();
	for (int i = 0; i < D03VocationAReason_vt.size(); i++) {
		D03VocationReasonData old_data = (D03VocationReasonData) D03VocationAReason_vt.get(i);
		CodeEntity code_data = new CodeEntity();
		code_data.code = old_data.SCODE;
		code_data.value = old_data.STEXT;
		newOpt.addElement(code_data);
	}

	//     Logger.debug.println(this, "-------newOpt: "+newOpt);

	String remainDays = dataRemain.OCCUR.equals("0")
			? "0"
			: Float.toString(
					NumberUtils.toFloat(dataRemain.ABWTG) / NumberUtils.toFloat(dataRemain.OCCUR) * 100);
	Boolean isUpdate = (Boolean) request.getAttribute("isUpdate");
	if (isUpdate == null)
		isUpdate = false;
%>

<c:set var="user" value="<%=user%>" />
<c:set var="data" value="<%=data%>" />
<c:set var="ename" value="<%=PERNR_Data.E_ENAME%>" />
<c:set var="E_RRDAT" value="<%=E_RRDAT%>" />
<c:set var="D_RRDAT" value="<%=D_RRDAT%>" />
<c:set var="PERNR_Data" value="<%=PERNR_Data%>" />
<c:set var="E_BTRTL" value="<%=E_BTRTL%>" />
<c:set var="OTHDDupCheckData_vt" value="<%=OTHDDupCheckData_vt%>" />
<c:set var="OTHDDupCheckData_vt_size" value="<%=Utils.getSize(OTHDDupCheckData_vt) %>" />
<c:set var="message" value="<%=message%>" />
<c:set var="dataRemain" value="<%=dataRemain%>" />
<c:set var="remainDays" value="<%=remainDays%>" />
<c:set var="ZKVRB" value="<%=ZKVRB%>" />
<c:set var="ZKVRB1" value="<%=ZKVRB1%>" />
<c:set var="ZKVRB2" value="<%=ZKVRB2%>" />
<c:set var="YaesuYn" value="<%=YaesuYn%>" />
<c:set var="H0340_Yes" value="<%=H0340_Yes%>" />
<c:set var="WOMAN_YN" value="<%=WOMAN_YN%>" />
<c:set var="CONG_DATE" value="<%=CONG_DATE%>" />
<c:set var="HOLI_CONT" value="<%=HOLI_CONT%>" />
<c:set var="P_A024_SEQN" value="<%=P_A024_SEQN%>" />
<c:set var="congVT" value="<%=congVT%>" />
<c:set var="newOpt" value="<%=newOpt%>" />
<c:set var="E_AUTH" value="<%=E_AUTH%>" />
<c:set var="E_COMP" value="<%=E_COMP%>" />

<c:set var="isUpdate" value="<%=isUpdate%>" />
<c:set var="locale" value="<%=g.getLocale()%>" />


<tags:layout css="ui_library_approval.css" script="dialog.js">

	<jsp:include page="${g.jsp }D/timepicker-include.jsp" />

	<script>
        $(function(){
        	msg();
//         	load_reason_list();

	    //[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 start
	    <c:choose>
	    	<c:when test='${WOMAN_YN==("Y") }'>
			    if( ! (document.form1.awart[1].checked || document.form1.awart[2].checked ||
			    	document.form1.awart[11].checked || document.form1.awart[12].checked ||
			        document.form1.awart[6].checked || document.form1.h0190.checked) ){ // 반일휴가(전반), 반일휴가(후반), 시간공가,모성보호휴가
	   		</c:when>
	   		<c:otherwise>
			    if( ! (document.form1.awart[1].checked || document.form1.awart[2].checked ||
			    	document.form1.awart[10].checked || document.form1.awart[11].checked ||
			        document.form1.awart[6].checked)){ // 반일휴가(전반), 반일휴가(후반), 시간공가

	    	</c:otherwise>
		</c:choose>
				    	$('#requestTime').attr('style','display:none');
			    }
		//[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청	end



		//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha start

   		 if (${ PERNR_Data.e_PERSK==("21")||PERNR_Data.e_PERSK==("22") }){

		    	if ( "${data.AWART}"=="0120"  || "${data.AWART}"=="0121" || "${data.AWART}"=="0112" || "${data.AWART}"=="0113" ){
		    		$('#requestTime').attr('style','display:none');

		    	}
		 }
    	//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha end

    		// [WorkTime52] 보상휴가 추가 건 20180516 성환희 start
    		$.initView = function() {
    			$.changeVocaTypeRadioHandler();	// 휴가유형 Change 이벤트 핸들러

    			$.viewControl();
    		}

    		$.viewControl = function() {

    			if(!${isUpdate}) {
	    			if('${E_AUTH}' == 'Y') {
		     			$('#voca_gubun_line1').hide();
		    			$('#voca_gubun_line2').hide();
	    				$('#voca_gubun_line3').hide();

	    				form1.E_REMAIN.value  		= '';
	    				form1.E_ZKVRB.value  		= '';
	    				form1.OCCUR.value    		= '';
	    				form1.ABWTG.value    		= '';
	    				form1.REMAIN_DATE.value = '';
	    				form1.REMAINDAYS.value 	= '';
	    			}
    			} else {
    				if('${data.AWART}' == '0111' || '${data.AWART}' == '0112' || '${data.AWART}' == '0113') {
    					$('[name=vocaType]').eq(0).prop('checked', true);

    					$('#voca_gubun_line1').hide();
            			$('#voca_gubun_line2').hide();
            			$('#voca_gubun_line3').show();
    				} else {
    					$('[name=vocaType]').eq(1).prop('checked', true);
    				}
    			}

    			parent.autoResizeNonArg();
    		}

    		$.toggleVocaGubun = function(voca_type) {
    			if(voca_type == 'A') {
	    			$('#voca_gubun_line3').hide();
	     			$('#voca_gubun_line1').show();
	    			$('#voca_gubun_line2').show();
	    			$('.extVocaText').show();
    			} else {
    				$('#voca_gubun_line1').hide();
        			$('#voca_gubun_line2').hide();
        			$('#voca_gubun_line3').show();
        			$('.extVocaText').hide();
    			}

    			$('#REASON').val('');
    			$('[name=APPL_FROM]', 'form[name="form1"]').val('');
    			$('[name=APPL_FROM]', 'form[name="form3"]').val('');
    			$('[name=APPL_TO]').val('');

    			$('[name=awart]:visible').each(function(index) {
    				if(index == 0) {
    					$(this).prop('checked', true);
    					$(this).trigger('click');
    				} else {
    					$(this).prop('checked', false);
    				}
    			});

    			parent.autoResizeNonArg();
    		}

    		// 휴가유형 Change 이벤트 핸들러
    		$.changeVocaTypeRadioHandler = function() {
    			$('[name=vocaType]').click(function() {
    				if($(this).is(':checked')) {
    					$.toggleVocaGubun($(this).val());

    					var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildSV';
    					var pars = {};
    					pars.jobid = 'check';
    					pars.MODE = $(this).val();
    					pars.PERNR = '${data.PERNR}';

    					blockFrame();
    				    $.ajax({type:'GET', url: url, data: pars, cache: false, dataType: 'html', success: function(data){showResponse(data)}});
    				}
    			});
    		}

    		$.initView();
    		// [WorkTime52] 보상휴가 추가 건 20180516 성환희 end

        });

function timeStartFocus(){
	if ($('#BEGUZ').attr('readonly')){
           $('.timeStart').timepicker('hide');
     }else{
            $('.timeStart').timepicker('show');
     }
}

function timeEndFocus(){
	if ($('#ENDUZ').attr('readonly')){
           $('.timeEnd').timepicker('hide');
     }else{
            $('.timeEnd').timepicker('show');
     }
}
        //2002.12.20. - 잔여휴가일수 다시 계산에서 보여주기
function after_remainSetting(){
    remainSetting(document.form1.APPL_FROM);
}
function after_remainSetting1(){
    remainSetting(document.form1.APPL_TO);
}

function remainSetting(obj) {
    if( obj.value != "" && dateFormat(obj) ) {
        document.form3.APPL_FROM.value = removePoint(obj.value);
        date_n = Number(document.form3.APPL_FROM.value);
        if( date_n < "${ D_RRDAT }" ) {

            alert("${ f:printDate(E_RRDAT) }" + "<spring:message code='MSG.D.D03.0002'/>"  );
            //일 이후에만 휴가 신청 가능합니다.
            obj.focus();
            return false;
        } else {
        	<%--
            document.form3.action = "${g.jsp}D/D03Vocation/D03VocationRemainDate.jsp";
            document.form3.target = "ifHidden";
            document.form3.PERNR.value = "${PersonData.e_PERNR}";
            document.form3.submit();
            --%>

	        var url = '/servlet/servlet.hris.D.D03Vocation.D03VocationBuildSV';
			var pars = {};
			pars.jobid = 'check';
			pars.PERNR = '${data.PERNR}';
			pars.APPL_FROM = document.form1.APPL_FROM.value;

			// 연차,보상 구분
			if($('[name=vocaType]').eq(1).is(':checked')) {
				pars.MODE = 'A';
			} else if($('[name=vocaType]').eq(0).is(':checked')) {
				pars.MODE = 'B';
			}

			blockFrame();
		    $.ajax({type:'GET', url: url, data: pars, cache: false, dataType: 'html', success: function(data){showResponse(data)}});

        }
        //C20101104_67443
        if ((document.form1.AWART.value=="0120"||document.form1.AWART.value=="0121"||document.form1.AWART.value=="0112"||document.form1.AWART.value=="0113") && obj.name== "APPL_FROM"  )
            document.form1.APPL_TO.value = obj.value;

        if ((document.form1.AWART.value=="0120"||document.form1.AWART.value=="0121"||document.form1.AWART.value=="0112"||document.form1.AWART.value=="0113") && obj.name=="APPL_TO"  )
            document.form1.APPL_FROM.value = obj.value;

       	//[CSR ID:3659836] 20년 근속/정년퇴직 여행 공가 생성 요청  START
		if ((document.form1.AWART.value=="0280"||document.form1.AWART.value=="0290") && (obj.name== "APPL_FROM" || obj.name== "APPL_TO") ){
			//[CSR ID:3745810] 20년 근속 여행휴가 사용 오류 건 start @날짜차이 계산 오류
			var appl_from = removePoint(document.form1.APPL_FROM.value);
	        var appl_to = removePoint(document.form1.APPL_TO.value);

	       	//날짜차이 계산
	       	if(appl_from != "" && appl_to !=""){
			   	var betweenDay = dayDiff(addSlash(appl_from), addSlash(appl_to));

		        if( betweenDay > 5){
				//[CSR ID:3745810] 20년 근속 여행휴가 사용 오류 건 end
					alert("<spring:message code='MSG.D.D03.0075'/>"); //20년근속 여행공가 및 정년퇴직 여행공가 휴가신청 시 7일 미만 신청가능합니다.

					document.form1.APPL_FROM.value="";
					document.form1.APPL_TO.value="";

					return false;
				}
	       	}
		}
       	//[CSR ID:3659836] 20년 근속/정년퇴직 여행 공가 생성 요청 END

      //[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha start
     <c:if test='${ PERNR_Data.e_PERSK==("21")||PERNR_Data.e_PERSK==("22") }'>
      if (removePoint(document.form1.APPL_FROM.value) < "20170801"){
	   				if ( document.form1.AWART.value=="0120"   )
		    	        document.form1.BEGUZ.value = "09:00";
		    	    if ( document.form1.AWART.value=="0120"   )
		    	        document.form1.ENDUZ.value = "14:00";
		    	    if ( document.form1.AWART.value=="0121"   )
		    	        document.form1.BEGUZ.value = "14:00";
		    	    if ( document.form1.AWART.value=="0121"  )
		    	        document.form1.ENDUZ.value = "18:00";
		    	    if ( document.form1.AWART.value=="0112"   )
		    	        document.form1.BEGUZ.value = "09:00";
		    	    if ( document.form1.AWART.value=="0112"   )
		    	        document.form1.ENDUZ.value = "14:00";
		    	    if ( document.form1.AWART.value=="0113"   )
		    	        document.form1.BEGUZ.value = "14:00";
		    	    if ( document.form1.AWART.value=="0113"  )
		    	        document.form1.ENDUZ.value = "18:00";
	   }
      </c:if>
      //[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha end
    }
}

/**
 * 웹취약점 보완을 위해 global처럼 ajax로 구현 (2017.1.5 ksc)
 */
function showResponse(originalRequest)	{

	 $.unblockUI();

	//put returned XML in the textarea
//	if (originalRequest.responseText!='')
//		arr = originalRequest.responseText.split(',');
	if (originalRequest != ""){
		arr = originalRequest.split(',');
		if (arr[0]=="N" ||  arr[0]=="E" ) {
			alert(arr[1]);
			return ;
		}

		form1.E_REMAIN.value  		= arr[1]; //arr[2];
		form1.E_ZKVRB.value  		= arr[2];
		form1.OCCUR.value    		= arr[3];
		form1.ABWTG.value    		= arr[4];
		form1.REMAIN_DATE.value = arr[1];
		form1.REMAINDAYS.value 	= arr[0];//parent.document.form1.E_REMAIN.value ;

		$('#remainTimeText').text(arr[5]);
	}
}


function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "${ g.servlet }hris.D.D03Vocation.D03VocationBuildSV";
    frm.target = "";
    frm.submit();
}

// CSR ID:1225704]  경조내역조회

function doSearch(){
  small_window=window.open("${ g.servlet }hris.D.D03Vocation.D03CongraListPopSV?PERNR=${data.PERNR}","essCalendar","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=680,height=400,top=300,left=300");
//   small_window=window.showModalDialog("${ g.servlet }hris.D.D03Vocation.D03CongraListPopSV?PERNR=${data.PERNR}",
// 		  	"","dialogWidth=680,dialogHeight=400");
  small_window.focus();
}

function gubun_click( val ) {
    if (val == "0130"|| val == "0370") {
    	$('#Congjo2').attr('style', 'display:inline-blobk');
    	$('#Congjo1').attr('style', 'display:inline-blobk');
    } else {
    	$('#Congjo2').attr('style', 'display:none; vertical-align:top;');
    	$('#Congjo1').attr('style', 'display:none; vertical-align:top;');
    }
//     $('#OVTM_CODE').attr('style', 'display:none; vertical-align:top;');  //CSR ID:1546748

}

function reason_show( cnt ) {   //CSR ID:1546748
	// D03HiddenReason.jsp에서 목록갱신후 호출됨
	var val = document.form1.AWART.value;

    if (cnt >0) {
    	$('#OVTM_CODE').attr('style', 'display:inline-blobk');
    	$('#OVTM_CODE').attr('readonly', true);
    	if(val != '0180' && val != '0170'){ // 전일, 시간공가 제외
    		$('#REASON').attr('readonly', true);
    	}
        $('#REASON').attr('OVTM_CODE', false);
    } else {
    	$('#OVTM_CODE').attr('style', 'display:none; vertical-align:top;');
		$('#REASON').attr('readonly', false);
    }
}

function goCongraBuild() {
	  //운영
	/*  epReturnUrl = "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url=";
	  //개발
	  //epReturnUrl = "http://epdev.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url=";

	  var url= epReturnUrl+"${g.servlet}hris.E.E19Congra.E19CongraBuildSV";
	  frm = document.form1;
	  frm.action = url;
	  frm.target = "_parent";
	  frm.submit();
	  */
	  moveMenu("ESS_BE_CONG_COND","${g.servlet}hris.E.E19Congra.E19CongraBuildSV");
}

//msg 를 보여준다.
function msg(){

    if ('${message}' >""){		    alert('${ message }');    }

    //CSR ID:1225704 경조휴가
    var Val = document.form1.AWART.value;

//    gubun_click( Val);
	if(Val=="0130" ||Val == "0370") {

//     $('#OVTM_CODE').attr('style', 'display:none; vertical-align:top;');
	    $('#OVTM_CODE').attr('readonly', 'true');
	}else{
	    $('#OVTM_CODE').attr('readonly', 'false');
	}

	if(${isUpdate}){
	    if(document.form1.awart[4].checked ==true) {
		    $("#Congjo1").attr('style', 'display:inline-blobk');

	    }
	}

}


// 시간 선택
function fn_openTime(Objectname){
    if( document.form1.timeopen.value == 'T' ) {
        small_window=window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname,
        		"","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=200,top=300,left=400");
        small_window.focus();
    } else {
        alert("<spring:message code='MSG.D.D03.0003'/>");//신청시간은 반일휴가(전반), 반일휴가(후반), 시간공가, 모성보호휴가의 경우에만 입력 가능합니다.
    }
}



 //경조내역선택시 CSR ID:1225704
function Cong_Sel(obj) {

    if  (document.form1.awart[4].checked ==true && (obj.value == "9000" ||obj.value == "9001"||obj.value == "9002" )) { //경조휴가:탈상,자녀출산
         $('#REASON').attr('CONG_CODE', false);
         $('#REASON').attr('readonly', false);
         document.form1.REASON.value= document.form1.CONG_CODE[obj.selectedIndex].text;
    }else if (document.form1.awart[4].checked ==true ) {
         $('#REASON').attr('CONG_CODE', true);
         document.form1.REASON.value= "";
         $('#REASON').attr('readonly', true);
    }
}

//시간입력시 호출하는 펑션 - 꼭 필요함.
function check_Time(objname){
//	fn_openTime(objname);
}

// 휴가구분 체크 변경에 따른 작업 변경
function click_radio(obj) {
    // CSR ID:1225704
    gubun_click( obj.value);

    //[CSR ID:3420919] 연차휴가 신청사유 필수사항 삭제 요청의 건 start
	if  (document.form1.awart[0].checked ==true
			||document.form1.awart[1].checked ==true
			||document.form1.awart[2].checked ==true
			||document.form1.awart[3].checked ==true
			||document.form1.awart[9].checked ==true
			||document.form1.awart[10].checked ==true
			||document.form1.awart[11].checked ==true) {
		$('#reasonPink').attr('style', 'display:none;');
	}else{
		$('#reasonPink').attr('style', 'display:inline-blobk;');
	}
	//[CSR ID:3420919] 연차휴가 신청사유 필수사항 삭제 요청의 건 end



//  08.02.29 추가
    if  (document.form1.awart[1].checked ==true || document.form1.awart[10].checked ==true) { //반일휴가(전반)

    	$('.timeStart').timepicker('option','hourMin',9);
    	$('.timeStart').timepicker('option','hourMax',14);

    	$('.timeEnd').timepicker('option','hourMin',9);
    	$('.timeEnd').timepicker('option','hourMax',14);


    }else if(document.form1.awart[2].checked ==true || document.form1.awart[11].checked ==true) { //반일휴가(전반)

    	$('.timeStart').timepicker('option','hourMin',14);
    	$('.timeStart').timepicker('option','hourMax',18);

    	$('.timeEnd').timepicker('option','hourMin',14);
    	$('.timeEnd').timepicker('option','hourMax',18);

    }else if(document.form1.awart[4].checked ==true) { //경조휴가
         //alert("유급휴무일인 토요일은 경조휴가일수에 포함해야\n하므로 경조휴가기간에 토요일이 있을 경우에는\n휴가기간 입력시 토요일을 포함하여 시작일/종료일을\n입력해야함");
         //alert("경조휴가가 6일 이상인 경우에는 유급휴무일인 토요일은 경조휴가일수에 포함하며,\n경조휴가가 6일 미만인 경우에는 유급휴무일인 토요일은 미포함함");
         //[CSR ID:2915325] 경조휴가 신청 시 안내 문구 수정 요청의 건
         //-.경조휴가 6일 이상 : 총 사용일수에서 토요일 포함, 휴일 미포함\\n-.경조휴가 6일 미만 : 총 사용일수에서 토요일 및 휴일 미포함
         alert("<spring:message code='MSG.D.D03.0004'/>");
         // CSR ID:1225704
         $('#REASON').attr('readonly', true);
         $("#Congjo1").attr('style', 'display:inline-blobk');
         $('#Congjo2').attr('style','display:inline-blobk');
         $('#OVTM_CODE').attr('style','display:none');

         document.form1.OVTM_CODE.length = 1;
    } else {
         $('#REASON').attr('CONG_CODE', false);
         $('#REASON').attr('readonly', false);
         $('#Congjo2').attr('style', 'display:none; vertical-align:top;');
         $('#Congjo1').attr('style', 'display:none; vertical-align:top;');
         $(".table").hide();
         $(".table").show(); // Refrash for IE7

    }

    //if  (document.form1.awart[5].checked ==true||document.form1.awart[6].checked ==true) { //전일공가
    if  (document.form1.awart[5].checked ==true) { //전일공가
        //C20140219_89877 //[CSR ID:2645243] HR Center 전일공가 신청에 따른 사유 추가 및 문구 수정 요청
        //[CSR ID:2659869] HR Center 공가신청時 일부 사유(전출 공가) 제외 요청의 건
        //[CSR ID:2779214] 전일공가 신청시 문구 수정 요청
        //     (공가 사용가능한 경우)\n\n1)근속기념일 휴가(10년, 15년, 25년, 30년, 35년)\n2)본인의 출두를 요하는 공권의 행사로 근무할 수 없는 경우\n3)병사 관계로 근무할 수 없는 경우(예비군, 민방위 등)\n4)천재 지변 기타 불가항력적 상태로 근무할 수 없는 경우\n5)타 지역 전출의 경우(2일)\n6)종합검진\n7)기타(취업규칙 제53조 참고)
         alert("<spring:message code='MSG.D.D03.0005'/>");

    } else if(document.form1.awart[6].checked ==true){
    	$('.timeStart').timepicker('option','hourMin', 9);
    	$('.timeStart').timepicker('option','hourMax',18);
    	$('.timeEnd').timepicker('option','hourMin',9);
    	$('.timeEnd').timepicker('option','hourMax',18);
        //[CSR ID:2659869] HR Center 공가신청時 일부 사유(전출 공가) 제외 요청의 건
        alert("<spring:message code='MSG.D.D03.0006'/>");
    }//[CSR ID:3659836] 20년 근속/정년퇴직 여행 공가 생성 요청  start
    else if(document.form1.awart[7].checked ==true){ //20년근속 여행공가
    	alert("<spring:message code='MSG.D.D03.0076'/>"); //공휴일 및 교대조 off일 포함하여 6일 연속 사용해야 합니다.\n(분할 사용 불가)
    	//[CSR ID:3745810] 20년 근속 여행휴가 사용 오류 건 start @날짜차이 계산 오류
    	document.form1.AWART.value = "0280";
		var appl_from = removePoint(document.form1.APPL_FROM.value);
        var appl_to = removePoint(document.form1.APPL_TO.value);
        //날짜차이 계산
	    var betweenDay = dayDiff(addSlash(appl_from), addSlash(appl_to));

		if( betweenDay > 5){
		//[CSR ID:3745810] 20년 근속 여행휴가 사용 오류 건 end
			alert("<spring:message code='MSG.D.D03.0075'/>"); //20년근속 여행공가 및 정년퇴직 여행공가 휴가신청 시 7일 미만 신청가능합니다.

			document.form1.APPL_FROM.value="";
			document.form1.APPL_TO.value="";

			return;
		}
    }else if(document.form1.awart[8].checked ==true){ //정년퇴직 여행공가
    	alert("<spring:message code='MSG.D.D03.0076'/>"); //공휴일 및 교대조 off일 포함하여 6일 연속 사용해야 합니다.\n(분할 사용 불가)
    	//[CSR ID:3745810] 20년 근속 여행휴가 사용 오류 건 start @날짜차이 계산 오류
		document.form1.AWART.value = "0290";
    	var appl_from = removePoint(document.form1.APPL_FROM.value);
        var appl_to = removePoint(document.form1.APPL_TO.value);
        //날짜차이 계산
        var betweenDay = dayDiff(addSlash(appl_from), addSlash(appl_to));

		if( betweenDay > 5){
		//[CSR ID:3745810] 20년 근속 여행휴가 사용 오류 건 end
			alert("<spring:message code='MSG.D.D03.0075'/>"); //20년근속 여행공가 및 정년퇴직 여행공가 휴가신청 시 7일 미만 신청가능합니다.

			document.form1.APPL_FROM.value="";
			document.form1.APPL_TO.value="";

			return;
		}
    }
    //[CSR ID:3659836] 20년 근속/정년퇴직 여행 공가 생성 요청  end


    if  ( "${WOMAN_YN}"=="Y" && document.form1.h0190.checked ==true) { //모성보호휴가
    	//임신 중인 여자 사원이 검진을 위해 본인이 청구하는 경우 월 1회 검진시간을 부여한다
         alert("<spring:message code='MSG.D.D03.0007'/>");
    }
//  2002.09.03. LG석유화학일경우 근무면제 시간 입력가능하도록한다. 단, 필수입력사항은 아니다.

	<c:choose>
	<c:when test='${ user.companyCode==("N100") }'>

    if( document.form1.awart[1].checked || document.form1.awart[2].checked ||
    	document.form1.awart[10].checked || document.form1.awart[11].checked ||
        document.form1.awart[6].checked || document.form1.h0360.checked){ //반일(전),반일(후),시간공가
	</c:when>
	<c:otherwise>

// 		    if( document.form1.awart[4].checked ) {
		//       document.all.kjg.style.visibility='visible';
// 		    }else {
		//       document.all.kjg.style.visibility='hidden';
// 		    }

	    <c:choose>
	    <c:when test='${WOMAN_YN==("Y") }'>
			    if( document.form1.awart[1].checked || document.form1.awart[2].checked ||
			    	document.form1.awart[11].checked || document.form1.awart[12].checked ||
			        document.form1.awart[6].checked || document.form1.h0190.checked ){ // 반일휴가(전반), 반일휴가(후반), 시간공가,모성보호휴가
	   	</c:when>
	   	<c:otherwise>
			    if( document.form1.awart[1].checked || document.form1.awart[2].checked ||
			    	document.form1.awart[10].checked || document.form1.awart[11].checked ||
			        document.form1.awart[6].checked  ){ // 반일휴가(전반), 반일휴가(후반), 시간공가

	    </c:otherwise>
	    </c:choose>

	</c:otherwise>
	</c:choose>

      //시간입력 비활성화  전일휴가:0110,하계휴가:0140,경조휴가:0130, 전일공가:0170 보건휴가:0150 //[CSR ID:3612320] 0280 (20년근속 여행공가) / 0290 (정년퇴직 여행공가)

      document.form1.BEGUZ.readOnly = 0;
      document.form1.ENDUZ.readOnly = 0;
      document.form1.timeopen.value = 'T';
     //[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 start
      $('#requestTime').attr('style','display:inline-blobk');
      document.form1.BEGUZ.value    = "";
      document.form1.ENDUZ.value    = "";
      //[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 end

    } else {       // 나머지 휴가구분의 경우

      document.form1.BEGUZ.readOnly = 1;
      document.form1.ENDUZ.readOnly = 1;
      document.form1.BEGUZ.value    = "";
      document.form1.ENDUZ.value    = "";
      document.form1.timeopen.value = 'F';
      ////[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 start
      $('#requestTime').attr('style','display:none');
      //[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 end
    }

    document.form1.AWART.value = obj.value;

    // CSR ID:1225704
    if  (document.form1.awart[4].checked==true && document.form1.CONG_CODE.value=="9002"){//경조휴가: 자녀출산(무급)
         document.form1.AWART.value = "0370";
    }else if  (document.form1.awart[4].checked==true ){//경조휴가: 자녀출산(유급)
         document.form1.AWART.value = "0130";

    <c:if test='${WOMAN_YN==("Y")  }' >
    }else if  (document.form1.h0190.checked==true ){//모성보호휴가
         document.form1.AWART.value = "0190";
    </c:if>
    }else
         document.form1.AWART.value = obj.value;

//C20140515_40601 반일휴가(전반):0120,후반:0121
<c:if test='${ PERNR_Data.e_PERSK==("27") ||	PERNR_Data.e_PERSK==("28")|| 	PERNR_Data.e_PERSK==("36") || 	PERNR_Data.e_PERSK==("37") }'>
        if( document.form1.AWART.value=="0120" || document.form1.AWART.value=="0112"){
        	eval("document.form1.awart[1].checked = 0");
            alert("<spring:message code='MSG.D.D03.0008'/>");//사무직 시간선택제 사원은 반일휴가(전반), 반일휴가(후반)은 선택할 수 없습니다.
            document.form1.AWART.value="";

            return;
        }
        if( document.form1.AWART.value=="0121" || document.form1.AWART.value=="0113"){
        	eval("document.form1.awart[2].checked = 0");
            alert("<spring:message code='MSG.D.D03.0008'/>");//사무직 시간선택제 사원은 반일휴가(전반), 반일휴가(후반)은 선택할 수 없습니다.
            document.form1.AWART.value="";

            return;
        }
</c:if>


    // 공제일수
    if( document.form1.awart[0].checked || document.form1.awart[9].checked ) {                                          // 전일휴가
      document.form1.DEDUCT_DATE.value = '1';

	<c:choose>
	<c:when test='${ user.companyCode==("N100") }'>
    } else if( document.form1.awart[1].checked || document.form1.awart[2].checked
    			|| document.form1.awart[10].checked || document.form1.awart[11].checked){ // 반일(전/후)
      document.form1.DEDUCT_DATE.value = '0.5';
	</c:when>

	<c:otherwise>
    } else if( document.form1.awart[1].checked || document.form1.awart[2].checked
    			|| document.form1.awart[10].checked || document.form1.awart[11].checked){ // 반일(전/후)
      document.form1.DEDUCT_DATE.value = '0.5';
	</c:otherwise>
	</c:choose>
    } else {
      document.form1.DEDUCT_DATE.value = '0';
    }

    //CSR ID:1546748 여수공장 사유 목록화처리
    document.form1.REASON.value="";
    load_reason_list();

     //  C20101104_67443 21:간부사원,22:사무직
    if (${ PERNR_Data.e_PERSK==("21")||PERNR_Data.e_PERSK==("22") }){
	    if ( document.form1.AWART.value=="0120"   )
	        document.form1.BEGUZ.value = "09:00";
	    if ( document.form1.AWART.value=="0120"   )
	        document.form1.ENDUZ.value = "14:00";
	    if ( document.form1.AWART.value=="0121"   )
	        document.form1.BEGUZ.value = "14:00";
	    if ( document.form1.AWART.value=="0121"  )
	        document.form1.ENDUZ.value = "18:00";
	    if ( document.form1.AWART.value=="0112"   )
	        document.form1.BEGUZ.value = "09:00";
	    if ( document.form1.AWART.value=="0112"   )
	        document.form1.ENDUZ.value = "14:00";
	    if ( document.form1.AWART.value=="0113"   )
	        document.form1.BEGUZ.value = "14:00";
	    if ( document.form1.AWART.value=="0113"  )
	        document.form1.ENDUZ.value = "18:00";

		//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha start
    	if ( document.form1.AWART.value=="0120"  || document.form1.AWART.value=="0121" || document.form1.AWART.value=="0112" || document.form1.AWART.value=="0113" ){
    		$('#requestTime').attr('style','display:none');

    	}
    	//[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 start
    	/*else{
    		$('#requestTime').attr('style','display:inline-blobk');
    	}*/
    	//[CSR ID:3497053] Global HR Portal 휴가 신청 화면 수정 요청 end
    	//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha end
    }





}

/*	사유코드 목록갱신	*/
function load_reason_list(){

    if  (document.form1.awart[4].checked !=true) { //경조휴가아닌경우 사유코드 목록갱신
	    document.form1.target = "ifHidden";
	    document.form1.action = "${g.jsp}D/D03Vocation/D03HiddenReason.jsp";
	    document.form1.submit();
    }

}


// 신청..
function beforeSubmit() {
      //2017-06-08 eunha [CSR ID:3400943] 하계휴가 신청기간 셋팅 요청의 건 CABL(안양(기술원)) /CABM(강동(기술원)) 추가 start
       //시스템화전 우선 하드코딩함 하계휴가 체크  AA00 LG화학 서울, AB00 LG화학 지방
    <%--<c:if test='${PERNR_Data.e_WERKS==("AA00")||PERNR_Data.e_WERKS==("AB00") }'>--%>
    <c:if test='${PERNR_Data.e_WERKS==("AA00")||PERNR_Data.e_WERKS==("AB00")||PERNR_Data.e_BTRTL==("CABL")||PERNR_Data.e_BTRTL==("CABM") }'>
     //2017-06-08 eunha [CSR ID:3400943] 하계휴가 신청기간 셋팅 요청의 건 CABL(안양(기술원)) /CABM(강동(기술원)) 추가 end

        //if( (document.form1.awart[3].checked ==true) && ( Number(removePoint(document.form1.BEGDA.value))  > 20131001 ) ) {
        //    alert("하계휴가 신청 기간이 아닙니다.");
        //    return;
        //}

        //[CSR ID:2574241] 날짜 변경
        // [CSR ID:2827544] 하계휴가 신청기한 설정요청
        //var checkfrom_0140="<//%=DataUtil.getCurrentYear()%>.07.20";checkto_0140="<//%=DataUtil.getCurrentYear()%>.08.21"; //C20130617_50756

        // [CSR ID:3083608] 하계휴가 신청기한 설정요청 (2016.06.07 김불휘)
         //2017-06-08 eunha [CSR ID:3400943] 하계휴가 신청기간 셋팅 요청의 건 start
         //2018-06-11 cykim [CSR ID:3708353] [긴급] 2018 하계휴가 신청 가능 기간 셋팅 요청의 건 start
        //var checkfrom_0140="${f:getCurrentYear()}.07.18"; checkto_0140="${f:getCurrentYear()}.08.19";
        //var checkfrom_0140="${f:getCurrentYear()}.07.17"; checkto_0140="${f:getCurrentYear()}.08.18";
		var checkfrom_0140="${f:getCurrentYear()}.07.01"; checkto_0140="${f:getCurrentYear()}.08.31";
     	 //2018-06-11 cykim [CSR ID:3708353] [긴급] 2018 하계휴가 신청 가능 기간 셋팅 요청의 건 end
        //2017-06-08 eunha [CSR ID:3400943] 하계휴가 신청기간 셋팅 요청의 건 end

        var appl_from1 = Number(removePoint(document.form1.APPL_FROM.value));
        var appl_to1 = Number(removePoint(document.form1.APPL_TO.value));
      //2017-06-08 eunha [CSR ID:3400943] 하계휴가 신청기간 셋팅 요청의 건 start
        // [CSR ID:3129048] 하계휴가사용기간 한계결정 수정
        if( (document.form1.awart[3].checked ==true) && (appl_from1 < Number(removePoint(checkfrom_0140)) ||appl_to1 > Number(removePoint(checkto_0140))  ) ) {
        //if( (document.form1.awart[3].checked ==true) && appl_from1 > Number(removePoint(checkto_0140))   ) {
       //2017-06-08 eunha [CSR ID:3400943] 하계휴가 신청기간 셋팅 요청의 건 end

            // [CSR ID:2574241] alert("하계휴가 기간(( "+checkfrom_0140+" ~ "+ checkto_0140+ " )이 아니오니 \n확인후 재신청 바랍니다.");
            //alert("하계휴가 기간(( "+checkfrom_0140+" ~ "+ checkto_0140+ " )이 아니오니 \nHR서비스팀 박난이 사원(02-3773-7814)으로 연락주시기 바랍니다.");
            //alert("신청일자는 하계휴가 기간이 아니므로 해당부서에 문의하시기 바랍니다.");

             // [CSR ID:3083608] 하계휴가 신청기한 설정요청 (2016.06.07 김불휘)
            alert("<spring:message code='MSG.D.D03.0009'/>");
            return false;
       }
    </c:if>

    if(! check_data() ) { return false;}

	    // 2004.2.11 - 중복을 체크하는 로직 추가. 같은 날짜와 시간일 경우 중복경고.
	    var c_APPL_FROM, c_APPL_TO, c_BEGUZ, c_ENDUZ, c_AWART;
	    c_APPL_FROM = document.form1.APPL_FROM.value;
	    c_APPL_FROM = c_APPL_FROM.substring(0, 4)+"-"+c_APPL_FROM.substring(4, 6)+"-"+c_APPL_FROM.substring(6, 8);
	    c_APPL_TO = document.form1.APPL_TO.value;
	    c_APPL_TO = c_APPL_TO.substring(0, 4)+"-"+c_APPL_TO.substring(4, 6)+"-"+c_APPL_TO.substring(6, 8);
	    c_AWART   = document.form1.AWART.value;
	    c_BEGUZ     = document.form1.BEGUZ.value.replace(":","");
	    c_BEGUZ   = c_BEGUZ.substring(0, 4);
	    c_ENDUZ     = document.form1.ENDUZ.value.replace(":","");
	    c_ENDUZ   = c_ENDUZ.substring(0, 4);
	    c_AINF_SEQN = document.form1.AINF_SEQN.value;
	    w_h0190 = "";



	    //※C20120622_32696 2012.06.25 모성보호휴가 매월1회에서 => 근태일 기준 전월21~당월20일 1회기준으로 체크로직 변경
	    var Women_CheckFrom, Women_CheckTo;
	    if (parseInt(c_APPL_FROM.substring(8, 10)) > 20 ) {
	     	IMSI = getAfterMonth(c_APPL_FROM ,1);
	        Women_CheckFrom = c_APPL_FROM.substring(0, 4)+c_APPL_FROM.substring(5, 7)+"21";
	        Women_CheckTo   = IMSI.substring(0, 6)+ "20";

	    } else {
	     	IMSI = getAfterMonth(c_APPL_FROM ,-1);
	        Women_CheckFrom = IMSI.substring(0, 6)+"21";
	        Women_CheckTo   = c_APPL_FROM.substring(0, 4)+c_APPL_FROM.substring(5, 7)+"20";
	    }	    //alert("c_APPL_FROM:"+c_APPL_FROM+"::"+IMSI.substring(0, 6)+"########IMSI:"+IMSI+"Women_CheckFrom:"+ Women_CheckFrom+ "Women_CheckTo:"+ Women_CheckTo);

<%-- 서블릿에서 처리 2016/12/27
		<c:forEach var="c_Data" items="${OTHDDupCheckData_vt}" varStatus="status" >

//	    for( int i = 0 ; i < OTHDDupCheckData_vt.size() ; i++ ) {
	//        D16OTHDDupCheckData2 c_Data = (D16OTHDDupCheckData2)OTHDDupCheckData_vt.get(i);
	        //    String s_BEGUZ1 = c_Data.BEGUZ.substring(0,2) + c_Data.BEGUZ.substring(3,5);
	        //    String s_ENDUZ1 = c_Data.ENDUZ.substring(0,2) + c_Data.ENDUZ.substring(3,5);
	        //int s_BEGUZ = Integer.parseInt(s_BEGUZ1);
	        //int s_ENDUZ = Integer.parseInt(s_ENDUZ1);
	        //@was6.1로 upgrade시 data가 null넘어와 수정함
// 		    String s_BEGUZ1 = "";
// 		    String s_ENDUZ1 = "";
// 	        int s_BEGUZ = 0;
// 	        int s_ENDUZ = 0;

				<c:choose>
			    <c:when test='${c_Data.BEGUZ==("")}'>
			        <c:set var="s_BEGUZ1" value= ""/>
			       	<c:set var="s_BEGUZ" value= "0"/>
			    </c:when>
			    <c:otherwise>
			        <c:set var="s_BEGUZ1" value= "${fn:substring(c_Data.BEGUZ,0,2)}${fn:substring(c_Data.BEGUZ,3,5)}"/><!--c_Data.BEGUZ.substring(0,2) + c_Data.BEGUZ.substring(3,5)-->
			       	<c:set var="s_BEGUZ"  value= "${fn:substring(c_Data.BEGUZ,0,2)}${fn:substring(c_Data.BEGUZ,3,5)}"/><!--Integer.parseInt(s_BEGUZ1)-->
		        </c:otherwise>
		        </c:choose>

				<c:choose>
			    <c:when test='${c_Data.ENDUZ==("")}'>
			        <c:set var="s_ENDUZ1" value= ""/>
			       	<c:set var="s_ENDUZ" value= "0"/>
			    </c:when>
			    <c:otherwise>
			        <c:set var="s_ENDUZ1" value= "${fn:substring(c_Data.ENDUZ,0,2)}${fn:substring(c_Data.ENDUZ,3,5)}"/>
			       	<c:set var="s_ENDUZ" value=  "${fn:substring(c_Data.ENDUZ,0,2)}${fn:substring(c_Data.ENDUZ,3,5)}"/><!--Integer.parseInt(s_BEGUZ1)-->
		        </c:otherwise>
		        </c:choose>



		     if("${ c_Data.AWART }" == c_AWART) {
			//alert(" c_APPL_FROM.substring(0,7):"+ c_APPL_FROM.substring(0,7)+ " [[["+"${ c_Data.APPL_FROM }".substring(0,7));
			       //※CSR ID:C20111025_86242 모성보호휴가 월1회 dup 체크로직 추가
			       //if ( "${ c_Data.AWART }" == "0190" && c_APPL_FROM.substring(0,7) =="${ c_Data.APPL_FROM }".substring(0,7) ) {
			       //     w_h0190 = "Y";
			       //}
			       //※CSR ID:C20120622_32696  모성보호휴가 근태일 기준 전월21~당월20일 월1회  체크로 변경
			       if ( "${ c_Data.AWART }" == "0190" && ( "${ c_Data.APPL_FROM }"  >= addbar(Women_CheckFrom)  && "${ c_Data.APPL_FROM }"  <= addbar(Women_CheckTo) ) ) {
			            w_h0190 = "Y";
			       }
			      // alert(  "Women_CheckFrom :"+addbar(Women_CheckFrom)+"  Women_CheckTo:"+addbar(Women_CheckTo)+" w_h0190 :"+w_h0190+" repl:"+  "${ c_Data.APPL_FROM }" );
			       if (  w_h0190  == "Y" ) {
			            alert("<spring:message code='MSG.D.D03.0010'/>");//모성보호휴가는 월 1회(전월21~당월20일, 근태 월기준) 신청가능 하며 당월의 신청건은 결재진행현황에서 확인하시기 바랍니다.
			            return false;
			       }
			      // 반일휴가(전반), 반일휴가(후반), 시간공가의 경우
			      if( ${s_BEGUZ != 0 || s_ENDUZ != 0} ) {
			          if( "${ c_Data.APPL_FROM }" == c_APPL_FROM && "${ c_Data.APPL_TO }" == c_APPL_TO &&
			  			 	(${isUpdate==false} || "${c_Data.AINF_SEQN}" != c_AINF_SEQN && ${isUpdate==true} )) {//check Requested
			              if( '${ s_BEGUZ }' == c_BEGUZ && "${ s_ENDUZ }" == c_ENDUZ ) {
		                      //if( "${c_Data.AINF_SEQN}" != "${data.AINF_SEQN}" && ${isUpdate} ) {
				                alert("<spring:message code='MSG.D.D03.0011'/>"); //현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.
					            document.form1.BEGUZ.value = c_BEGUZ.substring(0, 2)+":"+c_BEGUZ.substring(2, 4);
					            document.form1.ENDUZ.value = c_ENDUZ.substring(0, 2)+":"+c_ENDUZ.substring(2, 4);
				                document.form1.BEGUZ.select();
				                return false;
			              }else if( ('${ s_BEGUZ }' <= c_BEGUZ && '${ s_ENDUZ }' > c_BEGUZ) || ('${ s_BEGUZ }' < c_ENDUZ && '${ s_ENDUZ }' >= c_ENDUZ) || ('${ s_BEGUZ }' >= c_BEGUZ && '${ s_ENDUZ }' <= c_ENDUZ) ) {
				                 alert("<spring:message code='MSG.D.D03.0012'/>");//이미 결재신청된 시간과 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.
					            document.form1.BEGUZ.value = c_BEGUZ.substring(0, 2)+":"+c_BEGUZ.substring(2, 4);
					            document.form1.ENDUZ.value = c_ENDUZ.substring(0, 2)+":"+c_ENDUZ.substring(2, 4);
				                document.form1.BEGUZ.select();
				                return false;
			              }
				      }
			      } else  if( "${ c_Data.APPL_FROM }" == c_APPL_FROM && "${ c_Data.APPL_TO }" == c_APPL_TO ) {
		              recoverData()
		              alert("<spring:message code='MSG.D.D03.0013'/>");//현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.
		              document.form1.APPL_FROM.select();
		              return false;
// 	          	 } else if( ("${ c_Data.APPL_FROM }" <= c_APPL_FROM && "${ c_Data.APPL_TO }" > c_APPL_FROM) ||
// 	          			 ("${ c_Data.APPL_FROM }" < c_APPL_TO && "${ c_Data.APPL_TO }" >= c_APPL_TO) ||
// 	          			 ("${ c_Data.APPL_FROM }" >= c_APPL_FROM && "${ c_Data.APPL_TO }" <= c_APPL_TO) ) {
	          	 } else if( ( "${ c_Data.APPL_TO }" >= c_APPL_FROM) && ("${ c_Data.APPL_FROM }" <= c_APPL_TO ) ) {
	                  recoverData()
	                  alert("<spring:message code='MSG.D.D03.0014'/>");//이미 결재신청된 날짜와 중복됩니다. 결재진행현황에서 확인하시기 바랍니다.
	                  document.form1.APPL_FROM.select();
	              	  return false;

	          }

	     	}

			 </c:forEach>

서블릿에서 처리 2016/12/27 --%>

	    // 2004.2.11

	   //buttonDisabled();
	   //CSR ID:1225704
	   //document.form1.CONG_CODE.disabled=0;
	   //document.form1.REASON.disabled=0;

		return true ;

}




// data check..
function check_data(){


    //CSR ID:1225704
    if  (document.form1.awart[4].checked ==true) { //경조휴가
         if( checkNull(document.form1.CONG_CODE, "<spring:message code='MSG.D.D03.0015'/>") == false ) {//경조내역을
             return false;
         }

    }
  //C20140515_40601
  if( document.form1.AWART.value=="") {
    alert("<spring:message code='MSG.D.D03.0016'/>");//휴가구분을 선택하세요.
    return;
  }
    //////////////////////////////////////////////////////////////////////////////
    if( document.form1.OVTM_CODE.length >1 && document.form1.OVTM_CODE.value == "" ){//신청사유항목
        alert("<spring:message code='MSG.D.D03.0017'/>"); //신청사유항목은 필수 입력사항입니다.
        document.form1.OVTM_CODE.focus();
        return;
    }

  //[CSR ID:3420919] 연차휴가 신청사유 필수사항 삭제 요청의 건 start
    if  (document.form1.awart[0].checked ==false && document.form1.awart[1].checked == false && document.form1.awart[2].checked == false && document.form1.awart[3].checked == false && document.form1.awart[9].checked == false && document.form1.awart[10].checked == false && document.form1.awart[11].checked == false){
  //[CSR ID:3420919] 연차휴가 신청사유 필수사항 삭제 요청의 건 end
    	if( document.form1.REASON.value == ""  ){//신청사유 && document.form1.REASON.disabled==0
       		 alert("<spring:message code='MSG.D.D03.0017'/>");
        	//document.form1.REASON.focus();
        	return;
    	}
    }
    // 신청사유-80 입력시 길이 제한
    x_obj = document.form1.REASON;
    xx_value = x_obj.value;

    if( xx_value != "" && checkLength(xx_value) > 80 ){
        x_obj.value = limitKoText(xx_value, 80);
        alert("<spring:message code='MSG.D.D03.0018'/>");//신청사유는 한글 40자, 영문 80자 이내여야 합니다.
        x_obj.focus();
        x_obj.select();
        return false;
    }
    if( checkNull(document.form1.APPL_FROM, "<spring:message code='MSG.D.D03.0019'/>") == false ) {//신청기간을
        return false;
    }

    if( checkNull(document.form1.APPL_TO, "<spring:message code='MSG.D.D03.0019'/>") == false ) {
        return false;
    }

    //[CSR ID:2803878] 근태 3개월 이상 벌어지면 Alert
    var today = '${ f:printDate(f:currentDate()) }';
    today = today+"";
    var today_3month = getAfterMonth(addSlash(today),3);
    var from_num = Number(removePoint(document.form1.APPL_FROM.value));
    if ( from_num>today_3month ){
        alert("<spring:message code='MSG.D.D03.0020'/>");//휴가일을 다시 확인하시기 바랍니다.
        document.form1.APPL_FROM.focus();
        document.form1.APPL_FROM.select();
        return false;
    }

// 반일휴가(전반), 반일휴가(후반), 시간공가일경우 시간 입력 체크..
// 2002.09.03. LG석유화학일경우 근무면제 시간 입력가능하도록한다. 단, 필수입력사항은 아니다.

if( '${user.companyCode}'==("N100") ) {
  if( document.form1.timeopen.value == 'T' && !document.form1.h0360.checked ) {
    if( checkNull(document.form1.BEGUZ, "<spring:message code='MSG.D.D03.0019'/>") == false ) {
      return false;
    }

    if( checkNull(document.form1.ENDUZ, "<spring:message code='MSG.D.D03.0019'/>") == false ) {
      return false;
    }
  } else if( document.form1.timeopen.value == 'T' && document.form1.h0360.checked ) {
    if( (document.form1.BEGUZ.value == '' && document.form1.ENDUZ.value != '') || (document.form1.BEGUZ.value != '' && document.form1.ENDUZ.value == '') ) {
      alert("<spring:message code='MSG.D.D03.0021'/>");//신청시간 From ~ To를 모두 입력하세요.
      return false;
    }
  }
} else {
  if( document.form1.timeopen.value == 'T' ) {
    if( checkNull(document.form1.BEGUZ, "<spring:message code='MSG.D.D03.0036'/>") == false ) {
      return false;
    }

    if( checkNull(document.form1.ENDUZ, "<spring:message code='MSG.D.D03.0036'/>") == false ) {
      return false;
    }
  }
}

  //--------------------------------------------------------------------------------------//
  //--------------------------------------------------------------------------------------//
  date_from  = removePoint(document.form1.APPL_FROM.value);
  date_to    = removePoint(document.form1.APPL_TO.value);

//  2002.09.03. LG석유화학일경우 근무면제 시간 입력가능하도록한다. 단, 필수입력사항은 아니다.

<c:choose>
<c:when test='${user.companyCode==("N100") }'>
	  if( document.form1.timeopen.value == 'T' ) {    // 반일휴가(전반), 반일휴가(후반), 시간공가
	    	if( date_from != date_to && !document.form1.h0360.checked ) {
			      alert("<spring:message code='MSG.D.D03.0022'/>");//반일휴가(전반), 반일휴가(후반), 시간공가는 신청기간이 하루입니다.
			      return false;
	    	} else if( date_from != date_to && document.form1.h0360.checked ) {
	//      alert("근무면제는 신청기간이 하루입니다.");
	//      return false;
	    	}
</c:when>
<c:otherwise>
			  if( document.form1.timeopen.value == 'T' ) {    // 반일휴가(전반), 반일휴가(후반), 시간공가
			   	 if( date_from != date_to ) {
			    	  	alert("<spring:message code='MSG.D.D03.0022'/>");//반일휴가(전반), 반일휴가(후반), 시간공가는 신청기간이 하루입니다.
			      		return false;
			    }
</c:otherwise>
</c:choose>


	//  반일휴가(전반), 반일휴가(후반), 시간공가일경우 신청시간 체크..
	    if( document.form1.timeopen.value == 'T' ) {
	      if( document.form1.BEGUZ.value != '' ) {
	        time_from = removeColon(document.form1.BEGUZ.value);
	      }
	      if( document.form1.ENDUZ.value != '' ) {
	        time_to   = removeColon(document.form1.ENDUZ.value);
	      }
	    }


	//  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다.
	<c:if test='  ${WOMAN_YN==("Y")} '>
		<c:choose>
		<c:when test='${ user.companyCode==("N100") }'>
		  } else if( document.form1.awart[7].checked ) {      // 보건휴가 신청 일수 하루
		</c:when>
		<c:otherwise>
		  } else if( document.form1.awart[7].checked ) {      // 보건휴가 신청 일수 하루(화학)
		</c:otherwise>
		</c:choose>
	    if( date_from != date_to ) {
	      alert("<spring:message code='MSG.D.D03.0023'/>");//잔여(보건) 휴가는 신청기간이 하루입니다.
	      return false;
	    }
	</c:if>
	}else{
	    if( date_from > date_to ) {
	      alert("<spring:message code='MSG.D.D03.0024'/>");//신청시작일이 신청종료일보다 큽니다.
	      return false;
	    }
    }
  //--------------------------------------------------------------------------------------//
  //--------------------------------------------------------------------------------------//

  // 신청관련 단위 모듈에서 필히 넣어야?l 항목...
//  if ( check_empNo() ){
//    return false;
//  }
  // 신청관련 단위 모듈에서 필히 넣어야?l 항목...


  // CSR ID:1225704
  if  (document.form1.awart[4].checked==true && document.form1.CONG_CODE.value=="9002"){//경조휴가: 자녀출산(무급)
       document.form1.AWART.value = "0370";
  }else if  (document.form1.awart[4].checked==true ){//경조휴가: 자녀출산(유급)
       document.form1.AWART.value = "0130";
  }else
       document.form1.AWART.value = document.form1.AWART.value;


  //CSR ID:@@@  경조발생일을 포함하여 신청 (9001:자녀출산(유급)9002:자녀출산(무급)은 제외)
  if  (document.form1.awart[4].checked ==true ) {

      if  ( (document.form1.CONG_CODE.value=="9001"|| document.form1.CONG_CODE.value=="9002" ||document.form1.CONG_CODE.value=="9000") ) { // 9001:자녀출산(유급)9002:자녀출산(무급) ,9000:탈상 제외

        document.form1.HOLI_CONT.value="0";
        document.form1.CONG_DATE.value="";

      }else{
          cong_date  = removePoint(document.form1.CONG_DATE.value);
          //cong_checkDt = getAfterDate(cong_date,+1); //조위 익일 신청가능
          cong_checkDt = getAfterDate(document.form1.CONG_DATE.value,+1); //20151005 경조휴가 신청시 "날짜가 아닙니다." 나와서 수정함.
//           cong_checkDt = DataUtil.addDays(document.form1.CONG_DATE.value,1);

          //CSR ID:@@@ 경조휴가  조위 : 0003 인 경우 경조발생일 이전 신청시 오류, 조위은 당일 못한 경우 익일까지는 신청가능
          if  (document.form1.awart[4].checked ==true && document.form1.CONG_CODE.value=="0003" ) { //조위
               if(  date_from < cong_date ||  date_from> cong_checkDt ) {
                   alert("<spring:message code='MSG.D.D03.0025'/>");//조위 신청시작일은 발생일 당일 또는 발생일 익일 부터만 신청 가능합니다.
                   return false;
               }
          }else if  (document.form1.awart[4].checked ==true) { //경조휴가

                   if( cong_date<  date_from || cong_date> date_to ) {
                   alert("<spring:message code='MSG.D.D03.0026'/>");//경조발생일을 포함하여 신청해야 합니다.
                   return false;
               }
          }
      }
  }

  //C20130130_63372
  //1. 반일(전반):0120 종료시간이 14:00 이후 불가
  //2. 반일(후반):0121 시작시간이 13:00 이전 불가
  var beguz = document.form1.BEGUZ.value.replace(":","");
  var enduz = document.form1.ENDUZ.value.replace(":","");
  //20140113 0000 입력안되어 수정
  if (enduz=="0000") {
     enduz="2400";
  }
  awart_temp  = document.form1.AWART.value;

  //[CSR ID:3351729] 전지재료 익산공장 야간 교대조 휴가신청 Error start (사원하위그룹 39 운영직과 40 계약직(운영직)은 반휴전반인 경우 시작/종료일체크 예외)
  <c:if test='${ PERNR_Data.e_PERSK!="39" && PERNR_Data.e_PERSK!="40" }'>
  if ( (awart_temp=='0121'  ||  awart_temp=='0120' ||  awart_temp=='0112' ||  awart_temp=='0113' ) && ( beguz >= enduz) ) {
      alert("<spring:message code='MSG.D.D03.0027'/>");//시작시간을 확인하세요.
      return false;
  }
  </c:if>


  <c:if test='${ PERNR_Data.e_PERSK=="39" || PERNR_Data.e_PERSK=="40" }'>
  if ( (awart_temp=='0121'  ) && ( beguz >= enduz) ) {
      alert("<spring:message code='MSG.D.D03.0027'/>");//시작시간을 확인하세요.
      return false;
  }
  </c:if>
  //[CSR ID:3351729] 전지재료 익산공장 야간 교대조 휴가신청 Error end
  //21:간부사원,22:사무직
 if (date_from < "20170801"){  //[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha
  <c:if test='${ PERNR_Data.e_PERSK==("21")||PERNR_Data.e_PERSK==("22") }'>

		  if ( (awart_temp=='0120' || awart_temp=='0112')  &&   enduz > "1400" ) {
		      alert("<spring:message code='MSG.D.D03.0028'/>"); //반일휴가(전반) 종료시간을 14:00 이후로 입력할수 없습니다.
		      return false;
		  }
		  if ( (awart_temp=='0121' || awart_temp=='0113')  &&   beguz < "1300" ) {
		      alert("<spring:message code='MSG.D.D03.0029'/>");//반일휴가(후반) 시작시간을 13:00 이전으로 입력할수 없습니다.
		      return false;
		  }
  </c:if>
 } //[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha




  // default값 setting..
  document.form1.BEGDA.value       = removePoint(document.form1.BEGDA.value);
  document.form1.APPL_FROM.value   = date_from;
  document.form1.APPL_TO.value     = date_to;

  //반일휴가(전반), 반일휴가(후반), 시간공가일경우 시간 입력 체크..
  if( document.form1.timeopen.value == 'T' ) {
    if( document.form1.BEGUZ.value != '' ) {
        document.form1.BEGUZ.value  = time_from + '00';
    }
    if( document.form1.ENDUZ.value != '' ) {
        document.form1.ENDUZ.value  = time_to   + '00';
    }
  }
  return true;
}



function recoverData(){
     document.form1.BEGUZ.value = addColon( document.form1.BEGUZ.value );
     document.form1.ENDUZ.value = addColon( document.form1.ENDUZ.value );
//      document.form1.BEGDA.value = addPointAtDate( document.form1.BEGDA.value );
//      document.form1.WORK_DATE.value = addPointAtDate( document.form1.WORK_DATE.value );
 }

function addColon(text){//형식 체크후 문자형태의 시간 0000을 00:00으로 바꾼다 값이 없을시는 0을 리턴

    if( text!="" ){
  	    if(text.length==6){
	        text = text.substring(0,4);
  	    }
        if( text.length == 4 ){
            var tmpTime = text.substring(0,2)+":"+text.substring(2,4);
            return tmpTime;
        }
    } else {
        return "";
    }
}



	//2002.08.17. 휴일비근무 신청 추가로직
	function chk_del(gubun) {

		if( gubun == 1 ) {                      //control array 체크시 - 휴일비근무의 처리
		//  2002.08.16. LG석유화학 휴일비근무 신청 추가
			  if( ${user.companyCode==("N100") }){
			      document.form1.h0340.checked = 0;
			      document.form1.h0360.checked = 0;
			  }

			  if( ${WOMAN_YN==("Y") }) {
			        eval("document.form1.h0190.checked = 0"); //※CSR ID:C20111025_86242 모성보호휴가
			  }

			//2007.12.20. 전LG석유화학 휴일비근무 전문기술직만 신청 추가
			<c:if test='${ PERNR_Data.e_PERSK==("31") && H0340_Yes =="Y" }'>
			      document.form1.h0340.checked = 0;
			</c:if>

		} else if( gubun == 2 ) {               //휴일비근무 체크시 - control array의 처리
			  //  2002.08.17. 여사원일경우 보건휴가를 신청가능하도록 한다.
			  if( ${user.companyCode==("N100") }) {
				     if( ${WOMAN_YN==("Y")} ) {
					        for( i = 0 ; i < 8 ; i++ ) {
					          eval("document.form1.awart[" + i + "].checked = 0");
					        }
				     }else {
					        for( i = 0 ; i < 7 ; i++ ) {
					          eval("document.form1.awart[" + i + "].checked = 0");
					        }
				     }
				    //  LG석유화학 근무면제 선택 해제
				    document.form1.h0360.checked = 0;

			  }else {

				     if( ${WOMAN_YN==("Y") }) {
					        for( i = 0 ; i < 8 ; i++ ) {
						          eval("document.form1.awart[" + i + "].checked = 0");
					        }
				     }else {
					        for( i = 0 ; i < 7 ; i++ ) {
						          eval("document.form1.awart[" + i + "].checked = 0");
					        }
				     }
			   }

		} else if( gubun == 3 ) {               //근무면제 체크시 - control array의 처리
				  //  2002.08.17. 여사원일경우 보건휴가를 신청가능하도록 한다.
				   if( ${user.companyCode==("N100")} ) {
					     if( ${WOMAN_YN==("Y") }) {
					        for( i = 0 ; i < 8 ; i++ ) {
						          eval("document.form1.awart[" + i + "].checked = 0");
					        }
					     }else {
						        for( i = 0 ; i < 7 ; i++ ) {
							         eval("document.form1.awart[" + i + "].checked = 0");
						        }
					     }
					    //  LG석유화학 휴일비근무 선택 해제
					    document.form1.h0340.checked = 0;
				   }else {
					     if( ${WOMAN_YN==("Y") }) {
						        for( i = 0 ; i < 8 ; i++ ) {
							          eval("document.form1.awart[" + i + "].checked = 0");
						        }

					     }else {
						        for( i = 0 ; i < 7 ; i++ ) {
							          eval("document.form1.awart[" + i + "].checked = 0");
						        }
					     }
				   }
			}

	}


</script>



	<tags-approval:request-layout
		titlePrefix="COMMON.MENU.ESS_PT_LEAV_INFO" representative="true">

		<!-- 상단 입력 테이블 시작-->
		<div class="tableArea">
			<div class="table">
				<table class="tableGeneral">
					<colgroup>
						<col width=15% />
						<col width=40% />
						<col width=15% />
						<col width=30% />
					</colgroup>

					<c:if test="${E_AUTH eq 'Y'}">
						<tr>
							<th>
								<span class="textPink">*</span>
								<spring:message code='LABEL.D.D03.0043' /><!-- 휴가유형 -->
							</th>
							<td colspan=3>
								<input type="radio" name="vocaType" value="B" /> <spring:message code='LABEL.D.D03.0045' /><!-- 보상휴가 -->
								<input type="radio" name="vocaType" value="A" /> <spring:message code='LABEL.D.D03.0046' /><!-- 휴가(연차,경조,공가 등) -->
							</td>
						</tr>
					</c:if>
					<tr id="voca_gubun_line1">
						<th rowspan="2">
							<span class="textPink">*</span>
							<spring:message code='LABEL.D.D19.0016' /><!-- 휴가구분 -->
						</th>
						<td colspan=3>
							<input type="radio" name="awart" value="0110" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0110") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0110' /><!--전일휴가-->
							<input type="radio" name="awart" value="0120" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0120") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0120' /><!--반일휴가(전반)-->
							<input type="radio" name="awart" value="0121" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0121") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0121' /><!--반일휴가(후반)-->
							<!-- //  2007.12.20. 전LG석유화학 휴일비근무 전문기술직만 신청 추가 , 또는 파주공장BBIA 이고 기능직33 인경우 가능 -->
							<c:if test='${ H0340_Yes==("Y") }'>
								<input type="radio" name="h0340" value="0340" onClick="chk_del(2);click_radio(this);" ${ data.AWART==("0340") ? "checked" : "" }>
								<spring:message code='LABEL.D.D03.0340' /><!--휴일비근무-->
							</c:if> <!-- //  ※CSR ID:C20111025_86242 2011.10.25. 여사원일경우 모성보호휴가  신청 -->

							<c:if test='${ WOMAN_YN=="Y" }'>
								<input type="radio" name="h0190" value="0190" onClick="chk_del(2);click_radio(this);" ${ data.AWART==("0190") ? "checked" : "" }>
								<spring:message code='LABEL.D.D03.0190' /><!--모성보호휴가-->
							</c:if>
						</td>
					</tr>

					<tr id="voca_gubun_line2">
						<td colspan=3>
							<input type="radio" name="awart" value="0140" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0140") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0140' /><!--하계휴가-->
							<input type="radio" name="awart" value="0130" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0130")||data.AWART==("0370") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0130' /><!--경조휴가-->
							<input type="radio" name="awart" value="0170" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0170") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0170' /><!--전일공가-->
							<input type="radio" name="awart" value="0180" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0180") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0180' /><!--시간공가-->

							<!-- [CSR ID:3612320] 20년 근속/정년퇴직 여행 공가 생성 요청 -->
							<input type="radio" name="awart" value="0280" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0280") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0280' /><!--20년근속 여행공가-->
							<input type="radio" name="awart" value="0290" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0290") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0290' /><!--정년퇴직 여행공가-->
							<!-- [CSR ID:3612320] 20년 근속/정년퇴직 여행 공가 생성 요청 -->

							<!-- //  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다. -->
							<c:if test='${ WOMAN_YN==("Y") }'>
								<input type="radio" name="awart" value="0150" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0150") ? "checked" : "" }>
								<spring:message code='LABEL.D.D03.0150' /><!--보건휴가-->
							</c:if>
						</td>
					</tr>

					<tr id="voca_gubun_line3" style="display:none;">
						<th>
							<span class="textPink">*</span>
							<spring:message code='LABEL.D.D19.0016' /><!-- 휴가구분 -->
						</th>
						<td colspan=3>
							<input type="radio" name="awart" value="0111" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0111") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0111' /><!--전일휴가-->
							<input type="radio" name="awart" value="0112" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0112") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0112' /><!--반일휴가(전반)-->
							<input type="radio" name="awart" value="0113" onClick="chk_del(1);click_radio(this);" ${ data.AWART==("0113") ? "checked" : "" }>
							<spring:message code='LABEL.D.D03.0113' /><!--반일휴가(후반)-->
						</td>
					</tr>

					<tr>
						<th>
							<%--//[CSR ID:3420919] 연차휴가 신청사유 필수사항 삭제 요청의 건 start
							<span class="textPink">
							 --%>
							<span class="textPink"  id = "reasonPink" style="display:${(data.AWART==('0110') ||data.AWART==('0120')||data.AWART==('0121')||data.AWART==('0111')||data.AWART==('0112')||data.AWART==('0113')||data.AWART==('0140'))?'none':'inline-blobk'}">
							<%--//[CSR ID:3420919] 연차휴가 신청사유 필수사항 삭제 요청의 건 end--%>
							*</span>
							<spring:message code='LABEL.D.D19.0005' /><!--신청사유-->
						</th>
						<td colspan=3>
							<select id="OVTM_CODE" name="OVTM_CODE" style="display:${( data.OVTM_CODE=='')?'none':'inline-block'}; vertical-align:top;">
								<option value="">-------------</option>
								${  f:printCodeOption(newOpt,  data.OVTM_CODE) }
							</select>
							<span id="Congjo2" style="display:${(data.AWART==('0130') ||data.AWART==('0370'))?'inline-block':'none'}; vertical-align:top;">
								<select name="CONG_CODE" onChange="Cong_Sel(this)">
									<option value="">-------------</option>
									${  f:printCodeOption(congVT,  data.CONG_CODE) }
								</select>
							</span>
						 	<input type="text" id="REASON" name="REASON" value="${data.REASON}" size="50%" maxlength="80" style="ime-mode: active;" />
						 	<a id="Congjo1" style="display: none; vertical-align: top;" class="inlineBtn" href="javascript:doSearch();">
							 	<span>
							 		<spring:message code='LABEL.D.D03.0001' />
							 	</span>
						 	</a>
						<!--경조금신청--> <%--
									                    <table  border="0" cellspacing="0" cellpadding="0">
									                       <tr>
									                         <td id="Reason" >
									                         <!-- CSR ID:1546748
									                         <select name="OVTM_CODE">
									                          <option value="">-------------</option>
									                         </select>
									                         </td>
									                         <td id="Congjo2" >
									                         <!-- CSR ID:1225704
									                         <select name="CONG_CODE" onChange="Cong_Sel(this)">
									                          <option value="">-------------</option>
															${ data.CONG_CODE==("") ? f:printOption((new E19CongCodeNewRFC()).getCongCode(user.companyCode,"X") ) : f:printOption((new E19CongCodeNewRFC()).getCongCode(user.companyCode,"X"), data.CONG_CODE) }
									                         </select>
									                         </td>
									                         <td><input type="text" name="REASON" value="${ data.REASON }"  size="45" maxlength="80" style="ime-mode:active"></td>
									                         <td id="Congjo1" valing=top height=20 width=113>
									                             <a class="inlineBtn" href="javascript:doSearch();"><span>경조금신청</span></a>
									                         </td>
									                       </tr>
									                    </table>
--%></td>
					</tr>

					<c:if test='${ YaesuYn==("Y") }'>
						<!-- //CSR ID:1546748 -->
						<tr id="OvtmName">
							<th><span class="textPink">*</span> <spring:message
									code='LABEL.D.D15.0161' />
								<!--대근자--></th>
							<td colspan=3><input type="text" name="OVTM_NAME"
								value="${ data.OVTM_NAME }" size="20" maxlength="10"
								style="ime-mode: active"></td>
						</tr>
					</c:if>

					<tr>
						<th>
							<spring:message code='LABEL.D.D05.0085' /><!--잔여휴가일수-->
						</th>
						<td>
							<c:choose>
								<c:when test='${ZKVRB =="0" }'>
									<!-- Double.parseDouble(ZKVRB) < 0.0 -->
									<!--  [CSR ID:3462893] 잔여연차 오류 수정요청의 건 -->
									<input type="hidden" name="E_REMAIN" size="5" value="0.0">
								    <input type="text" name="E_ZKVRB" size="5" value="0.0" style="text-align: right; " readonly>
									<spring:message code='LABEL.D.D03.0022' /><!--일-->
									<span id="remainTimeText"></span>
								</c:when>
								<c:otherwise>
									<input type="hidden" name="E_REMAIN" size="5" value="${ dataRemain.e_REMAIN==(" 0") ? "0" :	f:printNumFormat(dataRemain.e_REMAIN , 1) }">
									<input type="text" name="E_ZKVRB" size="5" value="${ ZKVRB==(" 0") ? "0" : f:printNumFormat(ZKVRB , 1) }" style="text-align: right;" readonly>
									<spring:message code='LABEL.D.D03.0022' /><!--일-->
									<span id="remainTimeText">${dataRemain.ZKVRBTX}</span>
								</c:otherwise>
							</c:choose>

							<c:choose>
								<c:when test='${ user.companyCode==("N100") }'>
								<span class="extVocaText">
									<c:if test='${ ZKVRB2!=("0") }'>

										<span style="margin-left: 20px;"> <spring:message
												code='LABEL.D.D03.0018' />
											<!--교대휴가 잔여일수--></span>
										<input type="text" name="E_REMAIN3" size="5"
											value="${ ZKVRB2==(" 0") ? "0" :
											f:printNumFormat(ZKVRB2, 1) }" style="text-align: right"
											readonly>
										<spring:message code='LABEL.D.D03.0022' />
										<!--일-->
									</c:if>

									<c:if test='${ ZKVRB1!=("0")  }'>


										<span style="margin-left: 20px;"> <spring:message
												code='LABEL.D.D03.0019' />
											<!--사전부여휴가 잔여일수--></span>
										<input type="text" name="E_REMAIN2" size="5"
											value="${ ZKVRB1==(" 0") ? "0" :
											f:printNumFormat(ZKVRB1, 1) }" style="text-align: right"
											readonly>
										<spring:message code='LABEL.D.D03.0022' />
										<!--일-->
									</c:if>
								</span>
								</c:when>

								<c:otherwise>
									<span class="extVocaText">
									<c:if test='${ZKVRB1!=("0") }'>

										<span style="margin-left: 20px;">
											<spring:message code='LABEL.D.D03.0020' /><!--사전부여휴가-->
										</span>
										<input type="text" name="E_REMAIN2" size="5" value="${ ZKVRB1==(" 0") ? "0" : f:printNumFormat(ZKVRB1, 1) }" style="text-align: right" readonly>
										<spring:message code='LABEL.D.D03.0022' /><!--일-->
									</c:if>
									<c:if test='${ZKVRB2!=("0") }'>

										<span style="margin-left: 20px;">
											<spring:message	code='LABEL.D.D03.0021' /><!--선택적보상휴가-->
										</span>
										<input type="text" name="E_REMAIN3" size="5" value="${ ZKVRB2==(" 0") ? "0" : f:printNumFormat(ZKVRB2, 1) }" style="text-align: right" readonly>
										<spring:message code='LABEL.D.D03.0022' /><!--일-->
									</c:if>
									</span>
								</c:otherwise>
							</c:choose>
							<%--
						                    <table border="0" cellpadding="0" cellspacing="0">
						                    <tr style="padding:0px">
						                      <td>
						<% if( Double.parseDouble(ZKVRB) < 0.0 ) { %>
											<input type="text" name="E_REMAIN" size="10" value="0.0" style="text-align:right" readonly>일
						<% }else { %>
											<input type="text" name="E_REMAIN" size="10" value="${ ZKVRB==("0") ? "0" : f:printNumFormat(ZKVRB, 1) }" style="text-align:right" readonly>일
						<% } %>
												</td>
						<%
						    if( user.companyCode==("N100") ) {
						        if( !ZKVRB2==("0") ) {
						%>
						                      <td width="30"> </td>
						                      <td width="125">교대휴가 잔여일수</td>
						                      <td > <input type="text" name="E_REMAIN3" size="10" value="${ ZKVRB2==("0") ? "0" : f:printNumFormat(ZKVRB2, 1) }" style="text-align:right" readonly>
						                        일 </td>
						                      <%
						        }
						        if( !ZKVRB1==("0") ) {
						%>
						                      <td width="30"> </td>
						                      <td width="125">사전부여휴가 잔여일수</td>
						                      <td> <input type="text" name="E_REMAIN2" size="10" value="${ ZKVRB1==("0") ? "0" : f:printNumFormat(ZKVRB1, 1) }" style="text-align:right" readonly>
						                        일 </td>
						                      <%
						        }
						    } else {
						%>
						                      <% if( !ZKVRB1==("0") ) { %>
						                      <td width="60"> </td>
						                      <td width="95">사전부여휴가</td>
						                      <td > <input type="text" name="E_REMAIN2" size="10" value="${ ZKVRB1==("0") ? "0" : f:printNumFormat(ZKVRB1, 1) }" style="text-align:right" readonly>
						                        일 </td>
						                      <% } %>
						                      <% if( !ZKVRB2==("0") ) { %>
						                      <td width="60"> </td>
						                      <td width="95">선택적보상휴가</td>
						                      <td > <input type="text" name="E_REMAIN3" size="10" value="${ ZKVRB2==("0") ? "0" : f:printNumFormat(ZKVRB2, 1) }" style="text-align:right" readonly>
						                        일 </td>
						                      <% } %>
						                      <%
						    }
						%>
						                    </tr>
						                  </table>
						 --%>
						</td>
						<th class="th02">
							<spring:message code='LABEL.D.D03.0200' /><!-- 휴가사용율 Use rate(%) -->
						</th>
						<td>
							<input class="noBorder" type="text" name="REMAINDAYS" size="5" value="${f:printNumFormat(remainDays,2)}" />
							( <input class="noBorder" type="text" name="ABWTG" size="4" value="${dataRemain.ABWTG}" />
							/ <input class="noBorder" type="text" name="OCCUR" size="4" value="${dataRemain.OCCUR}" />)
						</td>

					</tr>
					<tr>
						<th><span class="textPink">*</span> <spring:message
								code='LABEL.D.D12.0003' />
							<!--신청기간--></th>

						<!-- @rdcamel colspan 제어 -->
						<td colspan="${dataRemain.OCCUR3 !='0' ? '1':'3' }">
							<!-- @rdcamel colspan 제어  end --> <input type="text"
							name="APPL_FROM" class="date required"
							value="${  f:printDate(data.APPL_FROM) }" size="10"
							onChange="javascript:after_remainSetting();"
							onBlur="javascript:dateFormat(this);">
						<!--onBlur="javascript:remainSetting(this);"  --> <spring:message
								code='LABEL.D.D19.0024' />
							<!--부터-->&nbsp; <input type="text" name="APPL_TO" class="date"
							value="${  f:printDate(data.APPL_TO)   }" size="10"
							onChange="javascript:after_remainSetting1();"
							onBlur="javascript:dateFormat(this);">
						<!--   --> <spring:message code='LABEL.D.D19.0025' />
							<!--까지-->

						</td>

						<!-- @rdcamel 추가 -->
						<c:if test='${ dataRemain.OCCUR3 !="0" }'>
							<th class="th02">유연 휴가</th>
							<td><input class="noBorder" type="text" name="ABWTG3"
								size="3" value="${f:printNumFormat(dataRemain.ABWTG3,1)}" />/ <input
								class="noBorder" type="text" name="OCCUR3" size="3"
								value="${f:printNumFormat(dataRemain.OCCUR3,1)}" />일</td>
						</c:if>
						<!-- @rdcamel 추가 end-->
					</tr>
					<tr id = "requestTime"><!--//[CSR ID:3438118] flexible time 시스템 요청 20170720 eunha-->
						<th><spring:message code='LABEL.D.D03.0023' />
							<!--신청시간--></th>
						<td colspan=3><input type="text" id="BEGUZ" name="BEGUZ"
							value="${ f:printTime(data.BEGUZ) }" size="11"
							onBlur="timeFormat(this);" onFocus="timeStartFocus();"
							${ data.AWART==("0120") || data.AWART==("0121") || data.AWART==("0112") || data.AWART==("0113") || data.AWART==("0180") ? "" : "readonly" }>
							<a href="javascript:fn_openTime('BEGUZ');" style="padding:0"><img
								src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>
							<spring:message code='LABEL.D.D19.0024' />
							<!--부터-->&nbsp;
							<input type="text" id="ENDUZ" name="ENDUZ"
							value="${ f:printTime(data.ENDUZ) }" size="11"
							onBlur="timeFormat(this);" onFocus="timeEndFocus();"
							${ data.AWART==("0120") || data.AWART==("0121") || data.AWART==("0112") || data.AWART==("0113") || data.AWART==("0180")|| data.AWART==("0190") ? "" : "readonly" }>
							<a href="javascript:fn_openTime('ENDUZ');" style="padding:0"><img
								src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>
							<spring:message code='LABEL.D.D19.0025' />
							<!--까지-->	</td>
					</tr>

				</table>

			</div>


			<%--[CSR ID:3438118] flexible time 시스템 요청(문구삭제)

			   <div class="commentsMoreThan2">
				<div>
					<span class="textPink">*</span>
					<spring:message code='MSG.D.D03.0030' />
				</div>
				<!-- 는 필수 입력사항입니다.(신청시간은 반일휴가(전반), 반일휴가(후반), 시간공가의 경우에만 필수 입력사항) -->
				<c:if test='${ user.companyCode==("N100") &&  ZKVRB2!=("0") }'>

					<div>
						<spring:message code='MSG.D.D03.0031' />
						<!-- 휴가 사용 시 교대휴가 잔여일수가 우선 공제되며 추가로사용 시 연차휴가가 공제됩니다. -->
					</div>
				</c:if>

			</div>
			 --%>
			<!-- 상단 입력 테이블 끝-->



			<!--CSR ID:1225704 start								     -->
			<input type="hidden" name="CONG_DATE" value="${ CONG_DATE }">
			<!-- 경조일자 -->
			<input type="hidden" name="HOLI_CONT" value="${ HOLI_CONT }">
			<input type="hidden" name="P_A024_SEQN" value="${ P_A024_SEQN }"
				size=10>

			<!--CSR ID:1225704 end-->
		</div>


		<!-- HIDDEN  처리해야할 부분 시작 (default = 전일휴가), frdate, todate는 선택된 기간에 개인의 근무일정을 가져오기 위해서.. -->
		<input type="hidden" name="BEGDA"
			value="${isUpdate == true ? data.BEGDA : f:currentDate() }">
		<input type="hidden" name="timeopen"
			value='${ data.AWART=="0120" || data.AWART==("0121") || data.AWART==("0112") || data.AWART==("0113") || data.AWART==("0180")|| data.AWART==("0190") ? "T" : "F" }'>
		<input type="hidden" name="AWART" value="${ data.AWART }">
		<input type="hidden" name="REMAIN_DATE" value="${ dataRemain.e_REMAIN }">
		<input type="hidden" name="DEDUCT_DATE" value="${ data.DEDUCT_DATE }">
		<!-- HIDDEN  처리해야할 부분 끝   -->

	</tags-approval:request-layout>


	<form name="form3" method="post">
		<input type="hidden" name="APPL_FROM" value="" /> <input type="hidden" name="PERNR" value="${data.PERNR}" />
	</form>


</tags:layout>


<iframe name="ifHidden" width="0" height="0" />
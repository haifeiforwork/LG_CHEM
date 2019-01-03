<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 신청                                                 */
/*   Program ID   : E17HospitalBuild.jsp                                        */
/*   Description  : 의료비를 신청할 수 있도록 하는 화면                         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김성일                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                  2005-12-26  @v1.1 C2005121301000001097 신용카드/현금구분추가*/
/*                  2006-01-03  @v1.2 C2006010301000000913 최초진료시 차감금액 변경 */
/*                  2006-02-23  @v1.3 C2006022001000000648 진료과추가  */
/*                : 2007-02-23  @v1.4 구체적증상 체크로직에 추가                */
/*                : 2008-07-01  @v1.5 CSR ID:1290227 배우자/자녀한도 300만원 → 500만원 */
/*                  2008-11-13  CSR ID:1357074 의료비담당자결재관련 보완        */
/*                  2014-06-03  [CSR ID:2548667] 의료비관련 개선 요청의 건        */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/*                  2014-08-08  이지은D [CSR ID:2589455] (SAP DB 암호화 관련) e-HR 임직원 신청 정보 중 '질병' 정보 입력 시 [*] 입력방지 시스템 로직 보완 건   */
/*                  2014-08-26  이지은D [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원 */
/*                  2015-07-31  이지은D [CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가 */
/*                  2015-08-19  이지은D [CSR ID:2849361] 사내부부 의료비관룐의 건 */
/*                  2016-05-19  이지은D [CSR ID:3059290] HR제도 팝업 관련 개선 요청의 건 */
/*                  2017-06-21  eunha   [CSR ID:3413378] Globa HR Portal내 의료비 지원신청관련 내용입니다 */
/*                  2017-06-22  eunha   [CSR ID:3414160] 의료비 신청 화면 변경요청의 건
/*					 2017-10-13  eunha   [CSR ID:3504138] 의료비신청 화면 수정요청의 건
/*                  2018-01-11 rdcamel  [CSR ID:3578534] 의료비 및 학자금 신청에 대한 일시 조치 요청   */
/* 				 2018-04-23 cykim  	  [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 start-->
<%@ page import="hris.E.E17Hospital.E17ChildData" %>
<%
	Vector E17FAMDate = (Vector)request.getAttribute("E17FAMDate");

	E17ChildData e17FAMDate = (E17ChildData)E17FAMDate.get(0);

	String E_BEGDA = e17FAMDate.BEGDA.replace("-",	"");
	String E_FAMDT = e17FAMDate.FAMDT.replace("-", "");

%>
<c:set var="E_BEGDA" value="<%=E_BEGDA%>"/>
<c:set var="E_FAMDT" value="<%=E_FAMDT%>"/>
<!-- [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 end-->

<!-- [CSR ID:3578534]임시로 사번으로 대체 이후에는 servlet 에서 request에 담아 YN으로 체크함.-->
<c:set var="ESS_EXCPT_CHK" value="00206335X"/>


<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="medi_count" value="${fn:length(E17HospitalData_vt) < 5 and !isUpdate ? 5 : fn:length(E17HospitalData_vt)}" />

<c:if test="${not empty e17SickData.medi_count}">
    <c:set var="medi_count" value="${f:parseLong(e17SickData.medi_count)}"/>
</c:if>

<%--
int medi_count = 5;
if( E17HospitalData_vt.size() > medi_count ) {
medi_count = E17HospitalData_vt.size();
}
if( e17SickData.medi_count != null && ! e17SickData.medi_count.equals("") ){
medi_count = Integer.parseInt(e17SickData.medi_count) ;
}--%>

<c:set var="buttonBody" value="${g.bodyContainer}" />

<tags:body-container bodyContainer="${buttonBody}">
    <li><a href="javascript:open_rule('Rule02Benefits09.html');" ><span><spring:message code="LABEL.E.E17.0001" /><!-- 의료비 지원기준 --></span></a></li>
</tags:body-container>

<%--@elvariable id="personInfo" type="hris.common.PersInfoData"--%>


<tags:layout css="ui_library_approval.css">

    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_BE_MEDI_FEE"  >
        <tags:script>
            <script language="JavaScript">
                <!--
				//[CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 start
				var E_BEGDA = '<c:out value="${E_BEGDA }"/>';
				var E_FAMDT = '<c:out value="${E_FAMDT }"/>';
				//[CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 end

                function chg_opt(obj){
                    va = obj.name;
                    val = Number(va.substring(9));
                    eval("document.form1.x_EMPL_WONX"+val+".value = '';");
                }

                // 진료일중 가장 큰 건을 찾기위한 로직 (2005.06.01 이후 건에 대해서는 최초진료 금액한도를 10만원으로 처리하기 위한 작업)
                var l_exam_date_max = 0;

                /* 본인 실부담액 합계구하기 */
                function multiple_won(gubun) {
                    var hap = 0;
                    var l_exam_date = 0;
                    l_exam_date_max = 0;
                    for( k = 0 ; k < ${medi_count} ; k++){
                        val = eval("removeComma(document.form1.EMPL_WONX"+k+".value)");

                        hap = hap + Number(val);

// 진료일중 가장 큰 건을 찾기위한 로직 (2005.06.01 이후 건에 대해서는 최초진료 금액한도를 10만원으로 처리하기 위한 작업)
                        if( gubun == "Chk" ) {
                            l_exam_date = eval("removePoint(document.form1.EXAM_DATE"+k+".value)");
                            if( l_exam_date_max < l_exam_date ) {
                                l_exam_date_max = l_exam_date;
                            }
                        }
// 진료일중 가장 큰 건을 찾기위한 로직 (2005.06.01 이후 건에 대해서는 최초진료 금액한도를 10만원으로 처리하기 위한 작업)
                    }

                    if( hap > 0 ) {
                        if( document.form1.WAERS.value == "KRW" ) {
                            hap = pointFormat(hap, 0);
                        } else {
                            hap = pointFormat(hap, 2);
                        }

                        document.form1.EMPL_WONX_tot.value = insertComma(hap+"");
                    }else if( hap == 0 ){
                        document.form1.EMPL_WONX_tot.value = "";
                    }
                }

                /* 최초 동일 진료 버튼 선택시 처리 */
                function click_radio(obj) {
                    document.form1.ORG_CTRL.value  = "";

                    if(document.form1.is_new_num[0].checked){ /* 최초진료 */
                        document.form1.CTRL_NUMB.value  = "";
                        document.form1.SICK_NAME.value  = "";
                        document.form1.SICK_DESC.value  = "";
                        document.form1.SICK_NAME.disabled = false ;
                    }else if(document.form1.is_new_num[1].checked){ /* 동일진료 */
                        document.form1.SICK_NAME.disabled = true ;

                        if( document.form1.hidden_CTRL_NUMB.value == '' ) {         //신청한 의료비가 존재하지 않을경우 동일진료 신청을 막는다.
                            alert('<spring:message code="MSG.E.E17.0001" />'); //신청된 의료비가 존재하지 않습니다.\n\n[최초진료]로 신청하세요.
                            document.form1.is_new_num[0].checked = true;
                            document.form1.SICK_NAME.disabled = false ;
                            return;
                        }
                        //document.form1.CTRL_NUMB.value  = document.form1.hidden_CTRL_NUMB.value;
                        //document.form1.SICK_NAME.value  = document.form1.hidden_SICK_NAME.value;
                        //document.form1.SICK_DESC.value  = document.form1.hidden_SICK_DESC1.value +"\n"+
                        //                                  document.form1.hidden_SICK_DESC2.value +"\n"+
                        //                                  document.form1.hidden_SICK_DESC3.value +"\n"+
                        //                                  document.form1.hidden_SICK_DESC4.value ;
                        //CSR ID:1357074
                        GUEN_CODE = document.form1.GUEN_CODE.value;
                        OBJPS_21  = document.form1.OBJPS_21.value;
                        REGNO_21  = document.form1.REGNO.value;
                        var win =window.open('', 'LastSick', "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=530,height=420,left=200,top=150");
                        document.form1.target = "LastSick";
                        document.form1.action = '${g.jsp}E/E17Hospital/E17LastSickList.jsp';
                        document.form1.method = "post";
                        win.focus();
                        document.form1.submit();

                    }
                }

                /* 신청 */
                function beforeSubmit() {
                    if( check_data() ) {
                        document.form1.SICK_NAME.disabled = false ;
                        alert('<spring:message code="MSG.E.E17.0002" />'); //의료비지원 신청서와 관련 영수증을 주관부서로 보내주셔야만 승인이 이루어 집니다.
                        return true;
                    }

                    return false;
                }
                /* onChange event 입원/외래
                 function chg_medi_code(num){
                 inx = eval("document.form1.MEDI_CODE"+num+".selectedIndex;");
                 eval("document.form1.MEDI_TEXT"+num+".value = document.form1.opt_MEDI_TEXT"+inx+".value;");
                 }
                 */
                /* onChange event 영수증 구분
                 function chg_rcpt_code(num){
                 inx = eval("document.form1.RCPT_CODE"+num+".selectedIndex;");
                 eval("document.form1.RCPT_TEXT"+num+".value = document.form1.opt_RCPT_TEXT"+inx+".value;");
                 }
                 */

                /* 의료비 입력항목 1개 추가 */
                function more_hospital_field(){
                    siz = Number(document.form1.medi_count.value);

                    if(siz >= 19) {
                        alert('<spring:message code="MSG.E.E17.0003" />'); //의료비 신청 입력항목을 더이상 늘일수 없습니다. \n\n 지금까지의 항목을 신청하시고 동일진료로 다시 추가해 주세요
                        return;
                    }
                    document.form1.RowCount_hospital.value = siz + 1;
                    document.form1.medi_count.value = siz + 1 ;

                    document.form1.SICK_NAME.disabled = false ;
                    document.form1.jobid.value = "AddOrDel";
                    document.form1.action = "";
                    document.form1.method = "post";

                    document.form1.target = "menuContentIframe";
                    document.form1.submit();
                }


                /* 라디오버튼 선택된 의료비 입력항목 지우기 */
                function remove_hospital_item(){
                    siz = Number(document.form1.medi_count.value);
                    if(siz <= 1) {
                        alert('<spring:message code="MSG.E.E17.0004" />'); //의료비 신청 입력항목을 더이상 줄일수 없습니다.
                        return;
                    }

                    var command = "";
                    var size = "";
                    flag = false;
                    if( isNaN( document.form1.radiobutton.length ) ){
                        size = 1;
                    } else {
                        size = document.form1.radiobutton.length;
                    }

                    for (i = 0; i < size ; i++) {
                        if ( size == 1 ){
                            command = "0";
                            flag = true;
                        } else if ( document.form1.radiobutton[i].checked == true ) {
                            command = i+"";
                            flag = true;
                        }
                    }
                    if( ! flag ){
                        alert('<spring:message code="MSG.E.E17.0005" />'); //삭제할 항목을 먼저 선택하세요
                        return;
                    }else{
                        document.form1.RowCount_hospital.value = siz;
                        document.form1.medi_count.value = siz - 1 ;
                        eval("document.form1.use_flag"+command+".value = 'N'");
                    }

                    document.form1.SICK_NAME.disabled = false ;
                    document.form1.jobid.value = "AddOrDel";
                    document.form1.action = "";
                    document.form1.method = "post";

                    document.form1.target = "menuContentIframe";
                    document.form1.submit();
                }


                /* 진료비계산서 입력으루 가기 */
                function go_bill(){
                    var command = "";
                    var size = "";
                    flag = false;
                    if( isNaN( document.form1.radiobutton.length ) ){
                        size = 1;
                    } else {
                        size = document.form1.radiobutton.length;
                    }
                    for (inx = 0 ; inx < size ; inx++) {
                        if ( size == 1 ){
                            command = "0";
                            flag = true;
                        } else if ( document.form1.radiobutton[inx].checked == true ) {
                            command = inx+"";
                            flag = true;
                        }
                    }
                    if( ! flag ){
                        alert('<spring:message code="MSG.E.E17.0006" />'); //입력할 진료비계산서 항목을 먼저 선택하세요
                        return;
                    }else{
                        siz = Number(document.form1.medi_count.value);
                        document.form1.RowCount_hospital.value = siz;
                        document.form1.radio_index.value = command;
                    }

                    gubun = eval("document.form1.RCPT_CODE"+command+".value;");
                    if( gubun != "0002" ){ /* 영수증 구분이 진료비계산서(0002) 가 아니면 에러 */
                        alert("<spring:message code="MSG.E.E17.0007" />"); //선택한 항목의 영수증은 진료비계산서가 아닙니다. \n\n  '영수증 구분'을 확인해 주세요
                        return;
                    }

                    document.form1.jobid.value = "build_first";
                    document.form1.action = "${g.servlet}hris.E.E17Hospital.E17BillControlSV";
                    document.form1.method = "post";
                    document.form1.submit();
                }

                /* check_data ********************************************************************************************* */
                function check_data() {

//  2002.06.28. 최초진료 신청시 관리번호가 CTRL_NUMB.substring(5,6) == "Z"일때 더이상 new는 발생시킬수가 없다.
                    if( document.form1.is_new_num[0].checked ) {
                        hidden_CTRL_NUMB = document.form1.hidden_CTRL_NUMB.value;

                        if( hidden_CTRL_NUMB.substring(5,6) == "Z" ) {
                            alert('<spring:message code="MSG.E.E17.0008" />'); //최초진료 신청시 더이상 생성 가능한 관리번호가 없습니다.\n\n관리자에게 문의하세요.
                            return false;
                        }
                    }
                    <c:if test="${!isUpdate}">
                    if( document.form1.is_new_num[1].checked && document.form1.ORG_CTRL.value =="" && document.form1.LAST_CTRL.value =="") {
                        alert('<spring:message code="MSG.E.E17.0009" />'); //동일진료 List 팝업에서 관리번호를 선택하세요.
                        //document.form1.is_new_num[0].checked = true;
                        //document.form1.SICK_NAME.disabled = false ;
                        return false;
                    }
                    </c:if>

                    if (document.form1.GUEN_CODE.value == "0003" ){
                        if( checkNull(document.form1.ENAME, "<spring:message code='MSG.E.E17.0010' />") == false )  //자녀이름을
                            return false;
                    }
//  2002.06.28. 최초진료 신청시 관리번호가 CTRL_NUMB.substring(5,6) == "Z"일때 더이상 new는 발생시킬수가 없다.

                    //@v1.3
                    if( checkNull(document.form1.TREA_CODE, "<spring:message code='MSG.E.E17.0011' />") == false )  //진료과를
                        return false;

//  상병명-30 입력시 길이 제한
                    x_obj = document.form1.SICK_NAME;
                    xx_value = x_obj.value;

                    if( checkNull(x_obj, "<spring:message code='MSG.E.E17.0012' />") == false ) {  //상병명을
                        return false;
                    } else {
                        if( xx_value != "" && checkLength(xx_value) > 30 ){
                            alert("<spring:message code='MSG.E.E17.0013' />");  //상병명은 한글 15자, 영문 30자 이내여야 합니다.
                            x_obj.focus();
                            x_obj.select();
                            return false;
                        }
                    }

//[CSR ID:2589455] *(42) 제거 로직 추가----------------------------
                    var tmpText="";
                    for ( var i = 0; i < xx_value.length; i++ ){
                        if(xx_value.charCodeAt(i) != 42){
                            tmpText = tmpText+xx_value.charAt(i);
                        }
                    }
                    x_obj.value = tmpText;
//-----------------------------------------------------------------

                    /* 필수 입력값 .. 의료기관, 사업자등록번호, 전화번호, 진료일, 영수증 구분, 본인 실납부액 */
                    hasNoData = true;
                    chk_inx   = -1;
                    for( inx = 0 ; inx < ${medi_count} ; inx++ ){
                        medi_name =             eval("document.form1.MEDI_NAME"+inx+".value");
                        medi_numb = removeResBar2(eval("document.form1.MEDI_NUMB"+inx+".value"));
                        telx_numb = eval("document.form1.TELX_NUMB"+inx+".value");
                        exam_date = $("#form1 input[name=EXAM_DATE" + inx + "]").stripVal();
                        empl_wonx =             eval("document.form1.EMPL_WONX"+inx+".value");
                        if( medi_name == "" && medi_numb == "" && telx_numb == "" && exam_date == "" && empl_wonx == "" ){
//          마지막에 입력한 의료기관 정보를 얻기위해서
                            if( chk_inx < 0 && hasNoData == false ) {
                                chk_inx = inx - 1;
                            }
                        }else if(medi_name != ""  && medi_numb != "" && telx_numb != "" && exam_date != "" && empl_wonx != ""){
                            hasNoData = false;

//          2002.05.10. 의료기관 길이 제한 - 20자
                            if( checkLength(medi_name) > 20 ){
                                alert("<spring:message code='MSG.E.E17.0014' />"); //의료기관명은 한글 10자, 영문 20자 이내여야 합니다.
                                if(typeof(document.form1.radiobutton.length) != 'undefined'){
                                	eval("document.form1.radiobutton["+inx+"].checked = true;");
                                }
                                return false;
                            }
//          2002.05.10. 의료기관 길이 제한 - 20자
							// [CSR ID:3413378] Globa HR Portal내 의료비 지원신청관련 내용입니다 2017-06-21  eunha  start
							//전화번호 자리수 5->7로 체크길이 늘임
                            //if( checkLength(telx_numb) < 5 ){
                           if( checkLength(telx_numb) < 7 ){
                                alert("<spring:message code='MSG.E.E17.0015' />"); //전화번호는 7자 이상 입력 하셔야 합니다.
                                return false;
                            }


                            /* 진료계산서의 본인부담금액과 입력한 본인부담금액이 다르면 Error처리함 */
                            gubunja = eval("document.form1.RCPT_CODE"+inx+".value;");
                            /* alert(gubunja); */
                            if( gubunja == "0002" ){
                                int_empl_wonx     = eval("Number(removeComma(document.form1.EMPL_WONX"+inx+".value))");
                                int_empl_wonx_tot = eval("Number(removeComma(document.form1.x_EMPL_WONX"+inx+".value))") +
                                        eval("Number(removeComma(document.form1.MEAL_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.APNT_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.ROOM_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.CTXX_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.MRIX_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.SWAV_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.ETC1_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.ETC2_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.ETC3_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.ETC4_WONX"+inx+".value))")   +
                                        eval("Number(removeComma(document.form1.ETC5_WONX"+inx+".value))")   -
                                        eval("Number(removeComma(document.form1.DISC_WONX"+inx+".value))");
                                if( int_empl_wonx_tot == 0 ){
                                    alert('<spring:message code='MSG.E.E17.0016' />'); //\"진료비계산서\"가 입력되지 않았습니다.\n\n \"진료비계산서 입력\" 버튼을 눌러 \"진료비계산서\"를 입력해주세요
                                    if(typeof(document.form1.radiobutton.length) != 'undefined'){
                                    	eval("document.form1.radiobutton["+inx+"].checked = true;");
                                    }
                                    return false;
                                }
                                if(int_empl_wonx_tot != int_empl_wonx){
                                    alert('<spring:message code='MSG.E.E17.0017' />'); //진료계산서의 본인부담금액과 입력한 본인실납부액이 다릅니다. \n\n \"진료비계산서 입력\" 버튼을 눌러 다시한번 확인해 주세요
                                    if(typeof(document.form1.radiobutton.length) != 'undefined'){
                                    	eval("document.form1.radiobutton["+inx+"].checked = true;");
                                    }
                                    eval("document.form1.EMPL_WONX"+inx+".focus();");
                                    eval("document.form1.EMPL_WONX"+inx+".select();");
                                    return false;
                                }
                            }
                            //2017-10-13  eunha   [CSR ID:3504138] 의료비신청 화면 수정요청의 건 START
                            //현재, 본인/배우자/자녀 의료비 신청시 마지막 진료일자가 3개월이 경과된 경우에는 신청이 안되도록 되어 있습니다.
							//지금 제도변경된 내용은 신청시 각각의 진료일자로부터 1년 이내까지는 지원하는것으로 변경되었습니다. 따라서 각각 진료일자별로
							//1년이내를 체크해서 1년이 경과된 건이 있으면 에러창이 뜨도록 추가 로직 수정을 해주셔야 합니다.(박난이선임)

                            begin_date = removePoint(document.form1.BEGDA.value);           // 신청일..
                            exam_date  = removePoint(eval("document.form1.EXAM_DATE"+inx+".value"));

                            betw = getAfterMonth(addSlash(exam_date), 12);
                            diff = dayDiff(addSlash(begin_date), addSlash(betw));
                            if(diff < 0) {
                            	alert("<spring:message code='MSG.E.E17.0022' />"); //진료일을 기준으로 1년까지만 신청이 가능합니다.
                            	 if(typeof(document.form1.radiobutton.length) != 'undefined'){
                            	       eval("document.form1.radiobutton["+inx+"].checked = true;");
                                }
                                return false;
                            }
                            //2017-10-13  eunha   [CSR ID:3504138] 의료비신청 화면 수정요청의 건 END

                            //[CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 start
                            var vExamDate = Number(exam_date);
                            if (document.form1.GUEN_CODE.value == "0002" ){ //배우자인 경우:: 진료일자가 결혼기념일 and 입사일자 전일 경우 신청 안됨.
                            	if( vExamDate < Number(E_FAMDT)){
									alert("<spring:message code='MSG.E.E17.0032' />"); //결혼전 발생한 배우자의 의료비는 지원 대상이 되지 않습니다.
									return false;
                            	}
                            }
                            if(document.form1.GUEN_CODE.value == "0001" || document.form1.GUEN_CODE.value == "0002" || document.form1.GUEN_CODE.value == "0003"){
          						if( vExamDate < Number(E_BEGDA)){  // 본인/배우자/자녀 의료비 신청 시 진료일자가 입사일자 전일 경우 신청 안됨.
									alert("<spring:message code='MSG.E.E17.0033' />"); //입사전 발생한 의료비는 지원 대상이 되지 않습니다.
									return false;
          						}
                            }
                            //[CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 end
                        }else{
                        	// 주석해제[CSR ID:3413378] Globa HR Portal내 의료비 지원신청관련 내용입니다 2017-06-21  eunha  start
                            alert('<spring:message code='MSG.E.E17.0018' />'); //\"의료기관\", \"사업자등록번호\", \"전화번호\", \"진료일\", \"본인 실납부액\"은 필수 항목입니다.\n\n 누락된 값을 입력해주세요

                            if(typeof(document.form1.radiobutton.length) != 'undefined'){
                            	eval("document.form1.radiobutton["+inx+"].checked = true;");
                            }
                            if(medi_name == ""){
                                eval("document.form1.MEDI_NAME"+inx+".focus();");
                            }else if(medi_numb == ""){
                                eval("document.form1.MEDI_NUMB"+inx+".focus();");
                            }else if(telx_numb == ""){
                                eval("document.form1.TELX_NUMB"+inx+".focus();");
                            }else if(exam_date == ""){
                                eval("document.form1.EXAM_DATE"+inx+".focus();");
                            }else if(empl_wonx == ""){
                                eval("document.form1.EMPL_WONX"+inx+".focus();");
                            }
                            return false;
                         // 주석해제[CSR ID:3413378] Globa HR Portal내 의료비 지원신청관련 내용입니다 2017-06-21  eunha  end
                        }


                    }
                    if(hasNoData){
                        alert('<spring:message code='MSG.E.E17.0019' />'); //입력된 의료비 영수증이 없습니다. \n\n \"의료기관\", \"사업자등록번호\", \"전화번호\", \"진료일\", \"본인 실납부액\"은 필수 항목입니다.
                        return false;
                    }
                    //  배우자, 자녀일 경우 해당년도 회사지원총액이 300만원을 넘으면 에러처리함.(본인은 2000만원을 넘으면 에러처리함)
                    if( (document.form1.GUEN_CODE.value == "0002" && ${e_FLAG != "Y"}) || document.form1.GUEN_CODE.value == "0003" ) {
                        if( "${COMP_sum}" >= 10000000 ) {
                            alert("<spring:message code='MSG.E.E17.0020' />");//[CSR ID:2598080] 의료비 지원한도 적용 수정  //해당년도 의료비 지원총액은 배우자 및 자녀 합산 1000만원입니다.
                            return false;
                        }
                    } else if( document.form1.GUEN_CODE.value == "0001" ) {
                        if(  "${COMP_sum}"   >= 20000000 ) {
                            alert("<spring:message code='MSG.E.E17.0021' />"); //해당년도 의료비 지원총액은 2,000만원입니다.
                            return false;
                        }
                    }
//2017-10-13  eunha   [CSR ID:3504138] 의료비신청 화면 수정요청의 건 주석처리
//  진료일을 기준으로 3개월까지만 신청이 가능하도록 한다. 2002.05.02. 확인자:성경호, 수정자:김도신
//  마지막에 입력한 진료일에 대해서만 체크한다.
/*
					if( chk_inx >= 0 ) {
                        begin_date = removePoint(document.form1.BEGDA.value);           // 신청일..
                        exam_date  = removePoint(eval("document.form1.EXAM_DATE"+chk_inx+".value"));

                        betw = getAfterMonth(addSlash(exam_date), 3);
                        diff = dayDiff(addSlash(begin_date), addSlash(betw));

                        if(diff < 0) {
                            alert("<spring:message code='MSG.E.E17.0022' />"); //진료일을 기준으로 3개월까지만 신청이 가능합니다.
                            eval("document.form1.radiobutton["+chk_inx+"].checked = true;");
                            return false;
                        }
                    }
*/
//  진료일을 기준으로 3개월까지만 신청이 가능하도록 한다. 2002.05.02. 확인자:성경호, 수정자:김도신
//  마지막에 입력한 진료일에 대해서만 체크한다.

                    /* 최초 진료시 본인부담액이 5만원 이하인 경우 Error처리함 ▶ 2005.06.01 이후 신청분에 대해서는 10만원 이하인 경우 Error처리함 */

                    <%-- 2005.09.15 수정 - 인사영역이 EA00(지사), EB00(J/V)인 경우는 예외로 함. --%>
                    <c:if test="${personInfo.e_WERKS != 'EA00' and personInfo.e_WERKS != 'EB00'}">
                    if( document.form1.is_new_num[0].checked && document.form1.WAERS.value == "KRW" ) {         // 최초진료이면서 원화일경우만..
                        multiple_won("Chk");
                        int_tt_wonx = Number(removeComma(document.form1.EMPL_WONX_tot.value));

                        if( l_exam_date_max >= "20050601" ) {
                            if( "${personInfo.e_PERNR}"=="00030960"){ //@v1.2
                                if( int_tt_wonx <= 50000 ){ //@v1.2
                                    alert("<spring:message code='MSG.E.E17.0023' />");  //최초 진료시 본인부담액이 5만원 초과일 경우에 의료비 신청이 가능합니다.
                                    return false;
                                }
                            }
                            else if( int_tt_wonx <= 100000 ){
                                alert("<spring:message code='MSG.E.E17.0024' />");  //최초 진료시 본인부담액이 10만원 초과일 경우에 의료비 신청이 가능합니다.
                                return false;
                            }
                        } else {
                            if( int_tt_wonx <= 50000 ){
                                alert("<spring:message code='MSG.E.E17.0023' />"); //최초 진료시 본인부담액이 5만원 초과일 경우에 의료비 신청이 가능합니다.
                                return false;
                            }
                        }
                    }
                    </c:if>

                    /* ?????? 회사 지원액이 본인부담금액을 초과시 Error처리함 */
                    /* 진료비계산서 입력시 본인 부담금액이 10만원 이상인 경우만 허용함. */
                    textArea_to_TextFild(document.form1.SICK_DESC.value);

//  2003.04.17 구제적증상 필수입력 - edskim
                    if( document.form1.SICK_DESC1.value == "" && document.form1.SICK_DESC2.value == "" &&
                            document.form1.SICK_DESC3.value == "" && document.form1.SICK_DESC4.value == "" ) {
                        alert("<spring:message code='MSG.E.E17.0025' />"); //구체적증상을 입력하세요.
                        document.form1.SICK_DESC.focus();
                        return false;
                    }

                    //[CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가
                    if( "Y"== "${CompanyCoupleYN}") {
                        if (document.form1.GUEN_CODE.value == "0002" ){
                            alert("<spring:message code='MSG.E.E17.0026' />");  //사내부부 입니다.\n\n배우자 의료비 신청은 불가하며,임직원 본인의 의료비는 본인이 신청하시길 바랍니다.
                            return false;
                        }
                        if (document.form1.GUEN_CODE.value == "0003" ){
                            alert("<spring:message code='MSG.E.E17.0027' />"); //사내배우자가 있습니다.\n\n의료비는 중복지원이 불가하오니 기신청내역여부 확인바랍니다.
                        }
                    }

                    for(var inxx = 0 ; inxx< ${medi_count} ; inxx++){
                        eval("document.form1.MEDI_NUMB"+inxx+".value = removeResBar2(document.form1.MEDI_NUMB"+inxx+".value);");
                        eval("document.form1.EXAM_DATE"+inxx+".value = removePoint(document.form1.EXAM_DATE"+inxx+".value);");
                        eval("document.form1.EMPL_WONX"+inxx+".value = removeComma(document.form1.EMPL_WONX"+inxx+".value);");
                    }

                    if(document.form1.is_new_num[1].checked){ /* 동일진료 */
                        document.form1.CTRL_NUMB.value  = document.form1.hidden_CTRL_NUMB.value;
                    }

                    return true;
                }
                /* check_data ********************************************************************************************* */

                function textArea_to_TextFild(text) {
                    var tmpText="";
                    var tmplength = 0;
                    var count = 1;
                    var flag = true;

//[CSR ID:2589455] *(42) 제거 로직 추가----------------------------
                    for ( var i = 0; i < text.length; i++ ){
                        if(text.charCodeAt(i) != 42){
                            tmpText = tmpText+text.charAt(i);
                        }
                    }
                    text = tmpText;
                    tmpText = "";
//-----------------------------------------------------------------

                    for ( var i = 0; i < text.length; i++ ){
                        tmplength = checkLength(tmpText);

                        /*    enter 키 입력시 값에 엔터키 코드(13)을 제거하기 위한 부분 추가.. 김성일 */
//    2003.04.16 << text.charCodeAt(i) != 10 >> 추가함 13과 10을 동시에 check해야함 - 김도신
                        if( /*(text.charCodeAt(i) != 13 && text.charCodeAt(i) != 10) && */Number( tmplength ) < 70 ){
                            tmpText = tmpText+text.charAt(i);
                            flag = true
                        } else {
                            flag = false;
                            tmpText.trim;

                            if( text.charCodeAt(i) == 13 ) {
                                eval("document.form1.SICK_DESC"+count+".value="+"tmpText");
                                count++;
                            }
                            else if (Number( tmplength ) >= 70) { // @v1.4
                                eval("document.form1.SICK_DESC"+count+".value="+"tmpText");
                                count++;
                                i=i-1;
                            }
                            tmpText="";   //text.charAt(i);

                            if( count > 4 ){
                                break;
                            }
                        }
                        /*    enter 키 입력시 값에 엔터키 코드(13)을 제거하기 위한 부분 추가.. 김성일 */
                    }

                    if( flag ) {
                        eval("document.form1.SICK_DESC"+count+".value="+"tmpText");
                    }
                    /* debug(); */
                }

                function go_print(){
                    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650,left=100,top=60");
                    document.form1.jobid.value = "print_form";
                    document.form1.target = "essPrintWindow";
                    document.form1.action = '${g.servlet}hris.E.E17Hospital.E17BillControlSV';
                    document.form1.method = "post";
                    document.form1.submit();
                }

                // 진료비 영수증 서식 목록. 2003.7.4. mkbae.
                var listOn = false;
                var overList = false;

                function showList() {
                    var oList = document.all.userList;
                    oList.style.visibility = "visible";

                    if (document.onmousedown != null) {
                        document.onmousedown();
                    }
                    document.onmousedown = pageClick;
                }

                function hideList() {
                    listOn = false;
                    document.all.userList.style.visibility = "hidden";
                    document.onmousedown = null;
                }

                function listOver() {
                    listOn = true;
                    overList = true;
                }

                function listOut() {
                    /*if (event.srcElement.contains(event.toElement)) return;*/
                    overList = false;
                }

                function pageClick() {
                    if (listOn == true && overList == false) {
                        hideList();
                    }
                }

                // 통화키가 변경되었을경우 금액을 재 설정해준다.
                function moneyChkReSetting() {
                    moneyChkForLGchemR3(document.form1.EMPL_WONX_tot,'WAERS');

                    for( inx = 0 ; inx < ${medi_count} ; inx++ ){
                        empl_wonx_obj = eval("document.form1.EMPL_WONX"+inx);
                        moneyChkForLGchemR3_onBlur(empl_wonx_obj, 'WAERS');
                    }
                    multiple_won("");                 // 본인 실납부액 합계 구하기..
                }
                // 통화키가 변경되었을경우 금액을 재 설정해준다.

                function change_guen(obj,obj2) {
                    var size = "";
                    if( isNaN( document.form1.radiobutton.length ) ){
                        size = 1;
                    } else {
                        size = document.form1.radiobutton.length;
                    }

                    siz = Number(document.form1.medi_count.value);
                    document.form1.RowCount_hospital.value = siz;


                    //[CSR ID:2849361] 사내부부 의료비관룐의 건 시작
                    if((obj2=="1")&&("Y"=="${CompanyCoupleYN}")) {
                        if (document.form1.GUEN_CODE.value == "0002" ){
                            alert("<spring:message code='MSG.E.E17.0026' />"); //사내부부 입니다.\n\n배우자 의료비 신청은 불가하며,임직원 본인의 의료비는 본인이 신청하시길 바랍니다.
                        }
                        if (document.form1.GUEN_CODE.value == "0003" ){
                            alert("<spring:message code='MSG.E.E17.0027' />"); //사내배우자가 있습니다.\n\n의료비는 중복지원이 불가하오니 기신청내역여부 확인바랍니다.
                        }
                    }
                    //[CSR ID:2849361] 사내부부 의료비관룐의 건 끝
                    document.form1.target = "menuContentIframe";
                    document.form1.jobid.value = "change_guen";
                    document.form1.action = "${g.servlet}hris.E.E17Hospital.E17HospitalBuildSV";
                    document.form1.method = "post";
                    document.form1.submit();
                }

                function change_child(obj) {
                    <%--
                    //  자녀일때 자녀를 선택할 수 있도록 한다.
                        //if( e17SickData.GUEN_CODE.equals("0003") ) {
                    --%>
                    if (document.form1.GUEN_CODE.value=="0003") {

                        var p_idx = obj.selectedIndex - 1;

                        if( p_idx >= 0 ) {
                            eval("document.form1.OBJPS_21.value = document.form1.OBJPS_21" + p_idx + ".value");
                            eval("document.form1.REGNO.value    = document.form1.REGNO"    + p_idx + ".value");
                            eval("document.form1.DATUM_21.value = document.form1.DATUM_20" + p_idx + ".value");

                            var d_regno = document.form1.REGNO.value;
                            document.form1.REGNO_dis.value = d_regno.substring(0, 6) + "-*******";

                            var begin_date = removePoint(document.form1.BEGDA.value);
                            var d_datum    = addSlash(document.form1.DATUM_21.value);

                            dif = dayDiff(addSlash(begin_date), d_datum);

                            if( dif < 0 ) {
                                document.form1.Message.value = document.form1.ENAME.value + "는 " + d_datum.substring(0,4) + "년 " + d_datum.substring(5,7) + "월 부터 자녀의료비지원 대상에서 제외되며, " + d_datum.substring(5,7) + "월 전월 의료비까지 지원 가능합니다."
                            } else {
                                document.form1.Message.value = "";
                            }
                        }
                    }else {
                        eval("document.form1.OBJPS_21.value = ''");
                        eval("document.form1.REGNO.value    = ''");
                        eval("document.form1.DATUM_21.value = ''");
                    }
                }

                $(function() {
                    //[CSR ID:2849361] 사내부부 의료비관룐의 건 시작
                    if( "Y"=="${CompanyCoupleYN}") {
                        if (document.form1.GUEN_CODE.value == "0002" ){
                            document.all.SubmitButton.style.display = "none";
                        }
                    }

                    <c:if test="${isUpdate}">
                        <c:if test="${e17SickData.GUEN_CODE == '0003' and not empty e17SickData.REGNO}">
                        document.form1.REGNO_dis.value = "${f:printRegNo(e17SickData.REGNO, 'LAST')}";

                        var begin_date = removePoint(document.form1.BEGDA.value);
                        var d_datum    = addSlash("${e17SickData.DATUM_21}");

                        dif = dayDiff(addSlash(begin_date), d_datum);

                        if( dif < 0 ) {
                            document.form1.Message.value = document.form1.ENAME.value + "는 " + d_datum.substring(0,4) + "년 " + d_datum.substring(5,7) + "월 부터 자녀의료비지원 대상에서 제외되며, " + d_datum.substring(5,7) + "월 전월 의료비까지 지원 가능합니다."
                        }
                        </c:if>
                    </c:if>
                    <c:if test="${!isUpdate}">
                        change_child(document.form1.ENAME);
                    </c:if>



                    //[CSR ID:2849361] 사내부부 의료비관룐의 건 끝

                    moneyChkReSetting();

                    multiple_won('');
                });

                function checkCouple(){
                    if( "Y"=="${CompanyCoupleYN}"){
                        if(document.form1.GUEN_CODE.value == '0002'){
                            alert("<spring:message code='MSG.E.E17.0026' />"); //사내부부 입니다.\n\n배우자 의료비 신청은 불가하며,임직원 본인의 의료비는 본인이 신청하시길 바랍니다.
                        }
                    }
                }

                function go_bill_detail(){

                    var command = "";
                    var size = "";
                    flag = false;
                    if( isNaN( document.form1.radiobutton.length ) ){
                        size = 1;
                    } else {
                        size = document.form1.radiobutton.length;
                    }
                    for (var i = 0; i < size ; i++) {
                        if ( size == 1 ){
                            command = "0";
                            flag = true;
                        } else if ( document.form1.radiobutton[i].checked == true ) {
                            command = i+"";
                            flag = true;
                        }
                    }
                    if( ! flag ){
                        alert("<spring:message code='MSG.E.E17.0029' />"); //조회할 진료비계산서 항목을 먼저 선택하세요
                        return;
                    }
                    gubun = eval("document.form1.RCPT_CODE"+command+".value;");
                    if( gubun != "0002" ){//영수증 구분이 진료비계산서(0002) 가 아니면 에러
                        alert("<spring:message code='MSG.E.E17.0007' />"); //선택한 항목의 영수증은 진료비계산서가 아닙니다. \n\n  '영수증 구분'을 확인해 주세요
                        return;
                    }

                    for(var ii = 0 ; ii < ${fn:length(E17BillData_vt)} ; ii++){
                        val = eval("document.form1.RCPT_NUMB"+command+".value;");
                        x_val = eval("document.form1.x_RCPT_NUMB"+ii+".value;");
                        if(val == x_val){
                            document.form1.radio_index.value = ii+"";
                        }
                    }

                    document.form1.jobid.value = "detail_first";
                    document.form1.AINF_SEQN.value = "${e17SickData.AINF_SEQN }";
                    document.form1.action = '${g.servlet}hris.E.E17Hospital.E17BillControlSV';
                    document.form1.target = "menuContentIframe";
                    document.form1.method = "post";
                    document.form1.submit();
                }

                //-->
            </script>
        </tags:script>

        <c:choose>
            <c:when test="${(personInfo.e_WERKS == 'EC00' or personInfo.e_WERKS == 'EB00' ) and ESS_EXCPT_CHK != '00206335'}"><!-- [CSR ID:3578534] 수정예정 -->
                <div class="align_center">
                    <p><spring:message code="MSG.E.E05.0004" /><!-- 해외법인의 경우 해당 인사부서를 통해 신청하시기 바랍니다. --></p>
                </div>
            </c:when>
            <c:otherwise>
                <%--@elvariable id="e17SickData" type="hris.E.E17Hospital.E17SickData"--%>
                <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>
                <tags:script>
                    <script>
                        $(function() {
                            <c:if test="${empty e17SickData.GUEN_CODE}">
                            //[CSR ID:2548667] 의료비관련 개선 요청의 건
                            alert("<spring:message code='MSG.E.E17.0028' />"); //① 병원영수증은 진료일자 및 수납금액만 기재된 진료비납입 확인서\n    로는 의료비 승인이 되지않습니다.\n    진찰료, 검사료, 주사료등 세부내역이 기재된 정식영수증을 \n    첨부하여 주십시오.\n② 약국영수증은 의사처방전을 필수 첨부하셔야만 승인이 가능합니다.\n③ 최초 진료시, 본인 부담금 10만원 초과금액이 지원 가능합니다.\n④ 치료가 병행되지 않은 검사료는 의료비 지원대상이 아닙니다.
                            </c:if>
                        });
                    </script>
                </tags:script>
                <!-- 상단 입력 테이블 시작-->
                <div class="tableArea">
                    <div class="table">

                        <input type="hidden" name="BEGDA" value="${approvalHeader.RQDAT}" >
                        <table class="tableGeneral  tableApproval">
                            <colgroup>
                                <col width="15%"/>
                                <col width="85%"/>
                            </colgroup>
                            <c:choose>
                                <c:when test="${isUpdate}">
                                    <%-- 수정 시 --%>

                                    <tr>
                                        <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0016" /><!-- 관리번호 --></th>
                                        <td class="td09">
                                            <input type="radio" name="is_new_num_view" disabled value="Y" ${fn:substring(e17SickData.CTRL_NUMB, 7, 9) == "01" ? "checked" : ""} > <spring:message code="LABEL.E.E17.0002" /><!-- 최초진료 -->
                                            <input type="radio" name="is_new_num_view" disabled value="N" ${fn:substring(e17SickData.CTRL_NUMB, 7, 9) == "01" ? "" : "checked"} > <spring:message code="LABEL.E.E17.0003" /><!-- 동일진료 -->&nbsp;&nbsp;

                                            <input type="radio" name="is_new_num" value="Y" ${fn:substring(e17SickData.CTRL_NUMB, 7, 9) == "01" ? "checked" : ""} style="display:none;" >
                                            <input type="radio" name="is_new_num" value="N" ${fn:substring(e17SickData.CTRL_NUMB, 7, 9) == "01" ? "" : "checked"} style="display:none;">
                                            <input type="text" name="CTRL_NUMB"  value="${e17SickData.CTRL_NUMB}" size="20" class="input04" readonly>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><span class="textPink">*</span><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></th>
                                        <td class="td09">
                                            <input type="text"   name="GUEN_TEXT"  value="${f:printOptionValueText(guenCodeList, e17SickData.GUEN_CODE)}" size="20" class="input04" readonly>
                                            <input type="hidden" name="GUEN_CODE"  value="${e17SickData.GUEN_CODE}" size="20" class="input04" readonly>
                                            &nbsp;&nbsp;&nbsp;<input type="checkbox" name="PROOF" value="X" size="20" class="input03" ${e17SickData.PROOF == "X" ? "checked" : "" }>&nbsp;<font color="#006699"><spring:message code="LABEL.E.E18.0021" /><!-- 연말정산반영여부 --></font>
                                        </td>
                                    </tr>
                                    <c:if test="${e17SickData.GUEN_CODE == '0003'}">
                                        <tr>
                                            <th><spring:message code="LABEL.E.E17.0011" /><!-- 자녀이름 --></th>
                                            <td>
                                                <input type="text" name="ENAME"     value="${e17SickData.ENAME }" size="14" readonly>
                                                <input type="text" name="REGNO_dis" value="" size="14" class="input04" readonly><br>
                                                <input type="text" name="Message"   value="" size="100" class="input04" readonly>
                                            </td>
                                        </tr>
                                        <!--@v1.3-->
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <%-- 등록 시 --%>
                                     <%-- [CSR ID:3414160] 의료비 신청 화면 변경요청의 건 start
                                      <tr>
                                        <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0016" /><!-- 관리번호 --></th>
                                        <td>
                                            <input type="radio" name="is_new_num" value="Y" ${e17SickData.is_new_num == "N" ? "" : "checked" } onClick="javascript:click_radio(this);" ><spring:message code="LABEL.E.E17.0002" /><!-- 최초진료 -->&nbsp;
                                            <input type="radio" name="is_new_num" value="N" ${e17SickData.is_new_num == "N" ? "checked" : "" } onClick="javascript:click_radio(this);" ><spring:message code="LABEL.E.E17.0003" /><!-- 동일진료 -->&nbsp;
                                            <a class="inlineBtn" href="javascript:showList();"><span><spring:message code="LABEL.E.E17.0004" /><!-- 진료비 영수증 서식 --></span></a>
                                            <div id="userList" style="font:11px;position:absolute;left:310px;top:100px;color:black;background-color:#e6e6e6;border:1 solid #939393;z-index:2;visibility:hidden" onClick="hideList()" onMouseOver="listOver(this)" onMouseOut="listOut(this)">
                                                <table style="font:9pt;background-color:#e6e6e6;border:1 solid #939393">
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('6.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0005" /><!-- 입원(퇴원·중간) 진료비 계산서·영수증 --></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('7.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0006" /><!-- 입원(퇴원·중간) 진료비 계산서·영수증(질병군별 포괄진료비) --></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('8.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0007" /><!-- 외래 진료비 계산서·영수증 --></a></td>
                                                    <tr>
                                                        <!--                                  <tr>
                                                                                        <td><a href="/web/E/E17Hospital/form/9호.doc" target="_blank">간이 외래 진료비 계산서·영수증</a></td>
                                                                                      </tr>-->
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('10.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0008" /><!-- 한방 입원(퇴원·중간) 진료비 계산서·영수증 --></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('11.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0009" /><!-- 한방 외래 진료비 계산서·영수증 --></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('12.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0010" /><!-- 약제비 계산서·영수증 --></a></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <a class="inlineBtn" onclick="open_rule('Rule02Benefits09.html');" style="float: right"><span><spring:message code="LABEL.E.E17.0001" /><!-- 의료비 지원기준 --></span></a>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th><span class="textPink">*</span><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></th>
                                        <td>
                                            <select name="GUEN_CODE" onChange="javascript:change_guen(this,'1');"> <!-- [CSR ID:2849361] 사내부부 의료비관룐의 건  -->
                                                    ${f:printCodeOption(guenCodeList, e17SickData.GUEN_CODE)}
                                            </select>
                                            &nbsp;&nbsp;&nbsp;<input type="checkbox"   name="PROOF" value="X"  size="20" checked>&nbsp;<spring:message code="LABEL.E.E18.0021" /><!-- 연말정산반영여부 -->
                                        </td>
                                    </tr>
                                    <c:if test="${e17SickData.GUEN_CODE == '0003'}">
                                        <tr>
                                            <th><span class="textPink">*</span><spring:message code="LABEL.E.E17.0011" /><!-- 자녀이름 --></th>
                                            <td>
                                                <select name="ENAME" onChange="javascript:change_child(this);change_guen(this,'2');"><!-- [CSR ID:2849361] 사내부부 의료비관룐의 건  -->
                                                    <option value="">--------</option>
                                                    <c:forEach var="e17ChildData" items="${E17ChildData_vt}" varStatus="status">
                                                        <option value="${e17ChildData.ENAME}" ${e17SickData.OBJPS_21 == e17ChildData.OBJPS_21 && e17SickData.REGNO == e17ChildData.REGNO ? "selected" : "" }>${e17ChildData.ENAME} </option>
                                                    </c:forEach>
                                                </select>
                                                <input type="text" name="REGNO_dis" value="" size="14" readonly><br>
                                                <input type="text" name="Message"   value="" size="100" readonly>

                                                <c:forEach var="e17ChildData" items="${E17ChildData_vt}" varStatus="status">
                                                    <input type="hidden" name="OBJPS_21${status.index}" value="${e17ChildData.OBJPS_21}">
                                                    <input type="hidden" name="REGNO${status.index}"    value="${e17ChildData.REGNO}">
                                                    <input type="hidden" name="DATUM_20${status.index}" value="${e17ChildData.DATUM_20}">
                                                </c:forEach>
                                            </td>
                                        </tr>
                                        <!--@v1.3-->
                                    </c:if>
                                     --%>
									<tr>
										<th><span class="textPink">*</span><spring:message code="MSG.APPROVAL.0012" /><!-- 구분 --></th>
                                        <td>
                                            <select name="GUEN_CODE" onChange="javascript:change_guen(this,'1');"> <!-- [CSR ID:2849361] 사내부부 의료비관룐의 건  -->
                                                    ${f:printCodeOption(guenCodeList, e17SickData.GUEN_CODE)}
                                            </select>
                                                <%--<%
                                                    if( e17SickData.GUEN_CODE.equals("0002")||e17SickData.GUEN_CODE.equals("0003") ) {
                                                %>
                                                &nbsp;&nbsp;&nbsp;<input type="checkbox" name="PROOF" value="" size="20" ${e17SickData.PROOF.equals("X") ? "checked" : "checked" } >&nbsp;연말정산반영여부--%>
                                            &nbsp;&nbsp;&nbsp;<input type="checkbox"   name="PROOF" value="X"  size="20" checked>&nbsp;<spring:message code="LABEL.E.E18.0021" /><!-- 연말정산반영여부 -->
<%--[CSR ID:3504138] 의료비신청 화면 수정요청의 건 (진료비 영수증 서식 버튼삭제)--%>
<%--<a class="inlineBtn" href="javascript:showList();"><span><spring:message code="LABEL.E.E17.0004" /><!-- 진료비 영수증 서식 --></span></a> --%>
                                            <div id="userList" style="font:11px;position:absolute;left:310px;top:100px;color:black;background-color:#e6e6e6;border:1 solid #939393;z-index:2;visibility:hidden" onClick="hideList()" onMouseOver="listOver(this)" onMouseOut="listOut(this)">
                                                <table style="font:9pt;background-color:#e6e6e6;border:1 solid #939393">
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('6.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0005" /><!-- 입원(퇴원·중간) 진료비 계산서·영수증 --></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('7.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0006" /><!-- 입원(퇴원·중간) 진료비 계산서·영수증(질병군별 포괄진료비) --></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('8.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0007" /><!-- 외래 진료비 계산서·영수증 --></a></td>
                                                    <tr>
                                                        <!--                                  <tr>
                                                                                        <td><a href="/web/E/E17Hospital/form/9호.doc" target="_blank">간이 외래 진료비 계산서·영수증</a></td>
                                                                                      </tr>-->
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('10.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0008" /><!-- 한방 입원(퇴원·중간) 진료비 계산서·영수증 --></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('11.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0009" /><!-- 한방 외래 진료비 계산서·영수증 --></a></td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="/web/E/E17Hospital/form/${f:encodeURL('12.doc')}" target="_blank"><spring:message code="LABEL.E.E17.0010" /><!-- 약제비 계산서·영수증 --></a></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <a class="inlineBtn" onclick="open_rule('Rule02Benefits09.html');" style="float: right"><span><spring:message code="LABEL.E.E17.0001" /><!-- 의료비 지원기준 --></span></a>

                                        </td>
                                    </tr>
                                    <%-- [CSR ID:3414160] 의료비 신청 화면 변경요청의 건 end  --%>
                                    <c:if test="${e17SickData.GUEN_CODE == '0003'}">
                                        <tr>
                                            <th><span class="textPink">*</span><spring:message code="LABEL.E.E17.0011" /><!-- 자녀이름 --></th>
                                            <td>
                                                <select name="ENAME" onChange="javascript:change_child(this);change_guen(this,'2');"><!-- [CSR ID:2849361] 사내부부 의료비관룐의 건  -->
                                                    <option value="">--------</option>
                                                    <c:forEach var="e17ChildData" items="${E17ChildData_vt}" varStatus="status">
                                                        <option value="${e17ChildData.ENAME}" ${e17SickData.OBJPS_21 == e17ChildData.OBJPS_21 && e17SickData.REGNO == e17ChildData.REGNO ? "selected" : "" }>${e17ChildData.ENAME} </option>
                                                    </c:forEach>
                                                </select>
                                                <input type="text" name="REGNO_dis" value="" size="14" readonly><br>
                                                <input type="text" name="Message"   value="" size="100" readonly>

                                                <c:forEach var="e17ChildData" items="${E17ChildData_vt}" varStatus="status">
                                                    <input type="hidden" name="OBJPS_21${status.index}" value="${e17ChildData.OBJPS_21}">
                                                    <input type="hidden" name="REGNO${status.index}"    value="${e17ChildData.REGNO}">
                                                    <input type="hidden" name="DATUM_20${status.index}" value="${e17ChildData.DATUM_20}">
                                                </c:forEach>
                                            </td>
                                        </tr>
                                        <!--@v1.3-->
                                    </c:if>
                                    <tr>
                                        <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0016" /><!-- 관리번호 --></th>
                                        <td>
                                            <input type="radio" name="is_new_num" value="Y" ${e17SickData.is_new_num == "N" ? "" : "checked" } onClick="javascript:click_radio(this);" ><spring:message code="LABEL.E.E17.0002" /><!-- 최초진료 -->&nbsp;
                                            <input type="radio" name="is_new_num" value="N" ${e17SickData.is_new_num == "N" ? "checked" : "" } onClick="javascript:click_radio(this);" ><spring:message code="LABEL.E.E17.0003" /><!-- 동일진료 -->&nbsp;
                                          </td>
                                    </tr>

                                </c:otherwise>
                            </c:choose>




                            <tr>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0022" /><!-- 진료과 --></th>
                                <td>
                                    <select name="TREA_CODE" onChange="javascript:document.form1.TREA_TEXT.value = this.options[this.selectedIndex].text;checkCouple();" style="width: 200px;"><!-- [CSR ID:2849361] 사내부부 의료비관룐의 건  -->
                                        <option value="">--------</option>
                                        ${f:printCodeOption(MedicTrea_vt, e17SickData.TREA_CODE)}
                                    </select>
                                </td>
                            </tr>
                            <input type="hidden" name="TREA_TEXT" value="">
                            <!--//CSR ID:1357074-->
                            <input type="hidden" name="OBJPS_21" value="${e17SickData.OBJPS_21}">
                            <input type="hidden" name="REGNO" value="${e17SickData.REGNO}">
                            <input type="hidden" name="DATUM_21" value="${e17SickData.DATUM_21}">


                            <tr>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E17.0012" /><!-- 상병명 --></th>
                                <td>
                                    <input type="text" ${e17SickData.is_new_num == "N" ? "disabled" : "" } name="SICK_NAME" value="${e17SickData.SICK_NAME }" size="40" style="width: 700px;">
                                </td>
                            </tr>

                            <c:set var="reason" value="${e17SickData.SICK_DESC1}${e17SickData.SICK_DESC2}${e17SickData.SICK_DESC3}${e17SickData.SICK_DESC4}"/>

                            <c:if test="${not empty e17SickData.is_new_num and not empty e17SickData.SICK_DESC}">
                                    <c:set var="reason" value="${e17SickData.SICK_DESC}"/>
                            </c:if>

                            <tr>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0023" /><!-- 구체적증상 --></th>
                                <td>
                                    <textarea name="SICK_DESC" wrap="VIRTUAL" cols="70" rows="4" style="width: 700px;">${fn:trim(reason)}</textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <!-- 상단 입력 테이블 시작-->
                <div class="listArea">
                    <div class="table">
                        <table class="listTable">
                            <thead>
                            <tr>
                                <th><spring:message code="LABEL.E.E18.0014" /><!-- 선택 --></th>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0028" /><!-- 의료기관 --></th>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E17.0013" /><!-- 사업자등록번호 --></th>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0030" /><!-- 전화번호 --></th>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0031" /><!-- 진료일 --></th>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E17.0014" /><!-- 입원/외래 --></th>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0033" /><!-- 영수증 구분 --></th>
                                <th><span class="textPink">*</span><spring:message code="LABEL.E.E18.0035" /><!-- 결재수단 --></th>
                                <th class="lastCol"><span class="textPink">*</span><spring:message code="LABEL.E.E18.0036" /><!-- 본인 실납부액 --></th>
                            </tr>
                            </thead>
                            <c:forEach var="e17HospitalData" items="${E17HospitalData_vt}" varStatus="status">

                            <input type="hidden" name="use_flag${status.index}"  value="Y">
                            <input type="hidden" name="RCPT_NUMB${status.index}" value="${last_num + 1 + status.index}"> <!-- No. 영수증번호    -->

                            <tr class="${f:printOddRow(status.index)}">
                                <td>
                                    <input type="radio" name="radiobutton" value="${status.index}" ${status.index == 0 ? "checked" : ""}>
                                </td>
                                <td>
                                    <input type="text" class="fill" name="MEDI_NAME${status.index}" value="${e17HospitalData.MEDI_NAME}" >
                                </td>
                                <td>
                                    <input type="text" name="MEDI_NUMB${status.index}" value="${f:companyCode(e17HospitalData.MEDI_NUMB)}" size="11" maxlength="12" onBlur="businoFormat(this);">
                                </td>
                                <td>
                                    <input type="text" name="TELX_NUMB${status.index}" value="${e17HospitalData.TELX_NUMB}" size="12" maxlength="13" onchange="phone_1(this);">
                                </td>
                                <td>
                                    <input type="text" name="EXAM_DATE${status.index}" value="${e17HospitalData.EXAM_DATE}" size="10" class="date">
                                </td>
                                <td>
                                    <select name="MEDI_CODE${status.index}" >
                                        ${f:printCodeOption(MediCode_vt, e17HospitalData.MEDI_CODE)}
                                    </select>
                                </td>
                                <td>
                                    <select name="RCPT_CODE${status.index}" onChange="javascript:chg_opt(this);" >
                                        ${f:printCodeOption(RcptCode_vt, e17HospitalData.RCPT_CODE)}
                                    </select>
                                </td>
                                <td><!--@v1.1-->
                                    <select name="MEDI_MTHD${status.index}" >
                                        <option value="2" ${e17HospitalData.MEDI_MTHD == "2" ? "selected" : "" } ><spring:message code="LABEL.E.E18.0041" /><!-- 신용카드 --></option>
                                        <option value="3" ${e17HospitalData.MEDI_MTHD == "3" ? "selected" : "" } ><spring:message code="LABEL.E.E18.0042" /><!-- 현금영수증 --></option>
                                        <option value="1" ${e17HospitalData.MEDI_MTHD == "1" ? "selected" : "" } ><spring:message code="LABEL.E.E18.0040" /><!-- 현금 --></option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="EMPL_WONX${status.index}" value="${empty e17HospitalData.EMPL_WONX ? '' : f:printNumFormat(e17HospitalData.EMPL_WONX, currencyDecimalSize)}" size="10" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS');javascript:multiple_won('');" >
                                </td>
                            </tr>
                            </c:forEach>
                            <c:if test="${!isUpdate}">
                            <c:forEach begin="${fn:length(E17HospitalData_vt)}" end="${medi_count - 1}" varStatus="status">
                            <input type="hidden" name="use_flag${status.index}" value="Y">
                            <input type="hidden" name="RCPT_NUMB${status.index}" value="${last_num + 1 + status.index}<%--<%= (last_num + 1) + i %>--%>"> <!-- No. 영수증번호    -->
                            <tr class="${f:printOddRow(status.index)}">
                                <td>
                                    <input type="radio" name="radiobutton" value="${status.index}">
                                </td>
                                <td>
                                    <input type="text" class="fill" name="MEDI_NAME${status.index}" value="" size="13">
                                </td>
                                <td>
                                    <input type="text" name="MEDI_NUMB${status.index}" value="" size="11" maxlength="12" onBlur="businoFormat(this);">
                                <td>
                                    <input type="text" name="TELX_NUMB${status.index}" value="" onBlur="phone_1(this);" size="12" maxlength="13">
                                </td>
                                <td>
                                    <input type="text" name="EXAM_DATE${status.index}" class="date" value="" size="10">
                                </td>
                                <td>
                                    <select name="MEDI_CODE${status.index}">
                                        <!--  option -->
                                        ${f:printCodeOption(MediCode_vt, "")}
                                        <!--  option -->
                                    </select>
                                </td>
                                <td>
                                    <select name="RCPT_CODE${status.index}" onChange="javascript:chg_opt(this);">
                                        <!--  option -->
                                        ${f:printCodeOption(RcptCode_vt, "")}
                                        <!--  option -->
                                    </select>
                                </td>
                                <td><!--@v1.1-->
                                    <select name="MEDI_MTHD${status.index}" >
                                        <option value="2"><spring:message code="LABEL.E.E18.0041" /><!-- 신용카드 --></option>
                                        <option value="3"><spring:message code="LABEL.E.E18.0042" /><!-- 현금영수증 --></option>
                                        <option value="1"><spring:message code="LABEL.E.E18.0040" /><!-- 현금 --></option>
                                    </select>
                                </td>
                                <td class="lastCol">
                                    <input type="text" name="EMPL_WONX${status.index}" value="" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS');javascript:multiple_won('');" size="10" >
                                </td>
                            </tr>
                            </c:forEach>
                            </c:if>
                        </table>
                    </div>
                    <div class="buttonArea ">

                        <ul class="btn_crud">
                            <c:if test="${isUpdate}">
                            <li><a class="unloading" href="javascript:go_bill_detail();"><span><spring:message code="LABEL.E.E17.0019" /><!-- 진료비 계산서 조회 --></span></a></li>
                            </c:if>
                            <li><a href="javascript:more_hospital_field();"><span><spring:message code="LABEL.E.E17.0015" /><!-- 추가 --></span></a></li>
                            <li><a href="javascript:remove_hospital_item();"><span><spring:message code="BUTTON.COMMON.DELETE" /><!-- 삭제 --></span></a></li>
                        </ul>
                        <div style="float:right; position:relative; top:8px; margin-right:10px;">
                            <span>계 :</span>
                            <input type="text" name="EMPL_WONX_tot" size="17" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" style="text-align:right" readonly>
                            <select name="WAERS" onChange="javascript:moneyChkReSetting();" style="vertical-align:middle;">
                                ${f:printCodeOption(currencyList, e17SickData.WAERS)}
                            </select>
                        </div>
                    </div>
                    <div class="commentsMoreThan2">
                        <div><spring:message code="LABEL.E.E17.0016" /><!-- 약국영수증인 경우 처방전을 첨부하세요. --></div>
                        <div><spring:message code="MSG.COMMON.0061" /><!-- <span class="textPink">*</span>는 필수 입력사항입니다. --></div>
                        <c:if test="${e17SickData.GUEN_CODE == '0002'}">
                            <div><spring:message code="LABEL.E.E17.0017" /><!-- 배우자의 의료비를 연말정산에 반영해야 할 경우 반드시 배우자 연말정산반영여부를 체크하여 주시기 바랍니다. --></div>
                            <div><spring:message code="LABEL.E.E17.0018" /><!-- 배우자의 의료비 연말정산과 관련하여 각각 배우자 공제(이중공제)로 신청할 경우<br/>세금추징 등의 불이익을 받게 되므로 이점 양지하시기 바랍니다. --></div>
                        </c:if>
                    </div>
                </div>

                <!-- hidden field : common -->
                <input type="hidden" name="radio_index"       value="">
                <input type="hidden" name="last_RCPT_NUMB"    value="${last_RCPT_NUMB}">
                <!--    <input type="hidden" name="P_Flag"            value="P_Flag"> -->
                <input type="hidden" name="COMP_sum"          value="${COMP_sum}">
                <input type="hidden" name="RowCount_hospital" value="${fn:length(E17HospitalData_vt)}" >
                <input type="hidden" name="RowCount_report"   value="${fn:length(E17BillData_vt)}">
                <input type="hidden" name="CompanyCoupleYN"   value="${CompanyCoupleYN}">

                <!-- hidden field : common -->
                <!-- hidden field : E17SickData -->
                <input type="hidden" name="hidden_CTRL_NUMB"  value="${hidden_e17SickData.CTRL_NUMB}"> <!-- 관리번호   -->
                <%--    <input type="hidden" name="hidden_SICK_NAME"  value="<%= hidden_e17SickData.SICK_NAME  %>"> <!-- 상병명     -->
                    <input type="hidden" name="hidden_SICK_DESC1" value="<%= hidden_e17SickData.SICK_DESC1 %>"> <!-- 구체적증상 -->
                    <input type="hidden" name="hidden_SICK_DESC2" value="<%= hidden_e17SickData.SICK_DESC2 %>"> <!-- 구체적증상 -->
                    <input type="hidden" name="hidden_SICK_DESC3" value="<%= hidden_e17SickData.SICK_DESC3 %>"> <!-- 구체적증상 -->
                    <input type="hidden" name="hidden_SICK_DESC4" value="<%= hidden_e17SickData.SICK_DESC4 %>"> <!-- 구체적증상 -->--%>

                <input type="hidden" name="medi_count" value="${medi_count}">
                <input type="hidden" name="AINF_SEQN"  value="">
                <input type="hidden" name="CTRL_NUMB"  value=""> <!-- 관리번호   -->
                <input type="hidden" name="SICK_DESC1" value=""> <!-- 구체적증상 -->
                <input type="hidden" name="SICK_DESC2" value=""> <!-- 구체적증상 -->
                <input type="hidden" name="SICK_DESC3" value=""> <!-- 구체적증상 -->
                <input type="hidden" name="SICK_DESC4" value=""> <!-- 구체적증상 -->
                <input type="hidden" name="ORG_CTRL"   value=""> <!-- 동일진료시 선택한원래관리번호CSR ID:1361257  -->
                <input type="hidden" name="LAST_CTRL"   value=""> <!-- 동일진료시 선택한원래관리번호의 마지막번호CSR ID:1361257  -->
                <!-- hidden field : E17SickData -->

                <!-- hidden field : E17BillData -->

                <c:forEach var="e17BillData" items="${E17BillData_vt}" varStatus="status">
                <input type="hidden" name="CTRL_NUMB${status.index}"   value="${e17BillData.CTRL_NUMB }"> <!-- 관리번호          -->
                <input type="hidden" name="x_RCPT_NUMB${status.index}" value="${e17BillData.RCPT_NUMB }"> <!-- 영수증번호        -->
                <input type="hidden" name="AINF_SEQN${status.index}"   value="${e17BillData.AINF_SEQN }"> <!-- 결재정보 일련번호 -->
                <input type="hidden" name="TOTL_WONX${status.index}"   value="${e17BillData.TOTL_WONX }"> <!-- 총 진료비         -->
                <input type="hidden" name="ASSO_WONX${status.index}"   value="${e17BillData.ASSO_WONX }"> <!-- 조합 부담금       -->
                <input type="hidden" name="x_EMPL_WONX${status.index}" value="${e17BillData.EMPL_WONX }"> <!-- 본인 부담금       -->
                <input type="hidden" name="MEAL_WONX${status.index}"   value="${e17BillData.MEAL_WONX }"> <!-- 식대              -->
                <input type="hidden" name="APNT_WONX${status.index}"   value="${e17BillData.APNT_WONX }"> <!-- 지정 진료비       -->
                <input type="hidden" name="ROOM_WONX${status.index}"   value="${e17BillData.ROOM_WONX }"> <!-- 상급 병실료 차액  -->
                <input type="hidden" name="CTXX_WONX${status.index}"   value="${e17BillData.CTXX_WONX }"> <!-- C T 검사비        -->
                <input type="hidden" name="MRIX_WONX${status.index}"   value="${e17BillData.MRIX_WONX }"> <!-- M R I 검사비      -->
                <input type="hidden" name="SWAV_WONX${status.index}"   value="${e17BillData.SWAV_WONX }"> <!-- 초음파 검사비     -->
                <input type="hidden" name="DISC_WONX${status.index}"   value="${e17BillData.DISC_WONX }"> <!-- 할인금액          -->
                <input type="hidden" name="ETC1_WONX${status.index}"   value="${e17BillData.ETC1_WONX }"> <!-- 기타1 의 금액     -->
                <input type="hidden" name="ETC1_TEXT${status.index}"   value="${e17BillData.ETC1_TEXT }"> <!-- 기타1 의 항목명   -->
                <input type="hidden" name="ETC2_WONX${status.index}"   value="${e17BillData.ETC2_WONX }"> <!-- 기타2 의 금액     -->
                <input type="hidden" name="ETC2_TEXT${status.index}"   value="${e17BillData.ETC2_TEXT }"> <!-- 기타2 의 항목명   -->
                <input type="hidden" name="ETC3_WONX${status.index}"   value="${e17BillData.ETC3_WONX }"> <!-- 기타3 의 금액     -->
                <input type="hidden" name="ETC3_TEXT${status.index}"   value="${e17BillData.ETC3_TEXT }"> <!-- 기타3 의 항목명   -->
                <input type="hidden" name="ETC4_WONX${status.index}"   value="${e17BillData.ETC4_WONX }"> <!-- 기타4 의 금액     -->
                <input type="hidden" name="ETC4_TEXT${status.index}"   value="${e17BillData.ETC4_TEXT }"> <!-- 기타4 의 항목명   -->
                <input type="hidden" name="ETC5_WONX${status.index}"   value="${e17BillData.ETC5_WONX }"> <!-- 기타5 의 금액     -->
                <input type="hidden" name="ETC5_TEXT${status.index}"   value="${e17BillData.ETC5_TEXT }"> <!-- 기타5 의 항목명   -->
                </c:forEach>

                <c:if test="${!isUpdate}">
                <c:forEach var="e17BillData" begin="${fn:length(E17BillData_vt)}" end="${medi_count - 1}" varStatus="status">
                    <input type="hidden" name="CTRL_NUMB${status.index}"   value=""> <!-- 관리번호          -->
                    <input type="hidden" name="x_RCPT_NUMB${status.index}" value=""> <!-- 영수증번호        -->
                    <input type="hidden" name="AINF_SEQN${status.index}"   value=""> <!-- 결재정보 일련번호 -->
                    <input type="hidden" name="TOTL_WONX${status.index}"   value=""> <!-- 총 진료비         -->
                    <input type="hidden" name="ASSO_WONX${status.index}"   value=""> <!-- 조합 부담금       -->
                    <input type="hidden" name="x_EMPL_WONX${status.index}" value=""> <!-- 본인 부담금       -->
                    <input type="hidden" name="MEAL_WONX${status.index}"   value=""> <!-- 식대              -->
                    <input type="hidden" name="APNT_WONX${status.index}"   value=""> <!-- 지정 진료비       -->
                    <input type="hidden" name="ROOM_WONX${status.index}"   value=""> <!-- 상급 병실료 차액  -->
                    <input type="hidden" name="CTXX_WONX${status.index}"   value=""> <!-- C T 검사비        -->
                    <input type="hidden" name="MRIX_WONX${status.index}"   value=""> <!-- M R I 검사비      -->
                    <input type="hidden" name="SWAV_WONX${status.index}"   value=""> <!-- 초음파 검사비     -->
                    <input type="hidden" name="DISC_WONX${status.index}"   value=""> <!-- 할인금액          -->
                    <input type="hidden" name="ETC1_WONX${status.index}"   value=""> <!-- 기타1 의 금액     -->
                    <input type="hidden" name="ETC1_TEXT${status.index}"   value=""> <!-- 기타1 의 항목명   -->
                    <input type="hidden" name="ETC2_WONX${status.index}"   value=""> <!-- 기타2 의 금액     -->
                    <input type="hidden" name="ETC2_TEXT${status.index}"   value=""> <!-- 기타2 의 항목명   -->
                    <input type="hidden" name="ETC3_WONX${status.index}"   value=""> <!-- 기타3 의 금액     -->
                    <input type="hidden" name="ETC3_TEXT${status.index}"   value=""> <!-- 기타3 의 항목명   -->
                    <input type="hidden" name="ETC4_WONX${status.index}"   value=""> <!-- 기타4 의 금액     -->
                    <input type="hidden" name="ETC4_TEXT${status.index}"   value=""> <!-- 기타4 의 항목명   -->
                    <input type="hidden" name="ETC5_WONX${status.index}"   value=""> <!-- 기타5 의 금액     -->
                    <input type="hidden" name="ETC5_TEXT${status.index}"   value=""> <!-- 기타5 의 항목명   -->
                </c:forEach>
                </c:if>
                <!-- hidden field : E17BillData -->
                <!--상단 입력 테이블 끝-->
            </c:otherwise>
        </c:choose>


    </tags-approval:request-layout>
</tags:layout>



 <%--/*
    String      last_RCPT_NUMB     = (String)request.getAttribute("last_RCPT_NUMB");
    Vector      E17HospitalData_vt = (Vector)request.getAttribute("E17HospitalData_vt");
    Vector      E17BillData_vt     = (Vector)request.getAttribute("E17BillData_vt");
    Vector      AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");
//    Vector      E17ChildData_vt    = (Vector)request.getAttribute("E17ChildData_vt");
    E17SickData e17SickData        = (E17SickData)request.getAttribute("e17SickData");
    E17SickData hidden_e17SickData = (E17SickData)request.getAttribute("hidden_e17SickData");
//    String      P_Flag             = (String)request.getAttribute("P_Flag"); <-- 2005.05.30(KDS) : 지원 기준 변경사항 반영
    String      COMP_sum           = (String)request.getAttribute("COMP_sum");
    String      CompanyCoupleYN           = (String)request.getAttribute("CompanyCoupleYN");    //[CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가

    DataUtil.fixNull(e17SickData);

    if( e17SickData.WAERS.equals("") ) {
        e17SickData.WAERS = "KRW";
    }

//////////////////////////////////////////////////////////////////////////////////////////////////// 2005.05.31
//  자녀리스트 조회 - 모든 jobid에 따라 페이지마다 가지고 다니는 어려움으로 리스트는 매번 조회함.
    Vector         E17ChildData_vt = new Vector();
    E17GuenCodeRFC child_rfc       = new E17GuenCodeRFC();

    E17ChildData_vt = child_rfc.getChildList(e17SickData.PERNR);
//////////////////////////////////////////////////////////////////////////////////////////////////// 2005.05.31

//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e17SickData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
//  통화키에 따른 소수자리수를 가져온다

    int last_num = 0;
    if( last_RCPT_NUMB != null && !last_RCPT_NUMB.equals("") ) {
        last_num = Integer.parseInt(last_RCPT_NUMB);
    }
    int medi_count = 5;
    if( E17HospitalData_vt.size() > medi_count ) {
        medi_count = E17HospitalData_vt.size();
    }
    if( e17SickData.medi_count != null && ! e17SickData.medi_count.equals("") ){
        medi_count = Integer.parseInt(e17SickData.medi_count) ;
    }

//  2003.03.14 배우자 공제한도 예외자 CHECK 로직 추가 - 예외자(E_FLAG = 'Y')는 공제한도를 CHECK하지 않는다.
//             - PAGE이동시마다 데이터를 가지고 다녀야해서 .JSP에서 조회함.
    E17MedicCheckYNRFC checkYN = new E17MedicCheckYNRFC();

    String E_FLAG = checkYN.getE_FLAG( DataUtil.getCurrentYear(), e17SickData.PERNR );

    PersonData personInfo = (PersonData)request.getAttribute("PersonData");*/--%>

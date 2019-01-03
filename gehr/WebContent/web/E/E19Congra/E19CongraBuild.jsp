<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : E19CongraBuild.jsp  최종                                        */
/*   Description  : 경조금 신청                                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-14  이승희                                          */
/*   Update       : 2005-02-24  윤정현                                          */
/*                  2005-12-07  @v1.1 lsa C2005112301000000543 경조화환 신청시 부서계좌 정보 조회기능 추가 */
/*                  2005-12-29  @v1.2 lsa C2005122801000000122 돌반지제외       */
/*                  2006-01-18  @v1.3 lsa C2006011801000000150 경조금 신청 제한 한시적 오픈 요청 */
/*                              @v1.4 lsa 통상금액(경조일 기준으로변경)         */
/*                              @v1.5 lsa 급여작업으로 막음                     */
/*                              @v1.5 lsa 5월급여작업으로 막음  전문기술직만    */
/*                              @v1.6 해외법인 임시로 품 71246:박선화           */
/*                  2006-06-14  @v1.8 경조대상자 조회                           */
/*                              @v1.9 -조부모 회갑 경조금 폐지                  */
/*                                    -배우자 형제자매상 50% 지급 추가 (2006/6월/21일 오픈으로 이전 경조일data는 체크함)*/
/*                              @v2.0 [CSR ID:1225704] -프로세스개선 임시 막음  */
/*                  2012-03-30  [CSR ID:C20120323_76012 ] 경조대상자 관계 변경시 대상자명칭 CLEAR  */
/*                  2012-04-23  [CSR ID:2094498] 문구 삭제,변경의건 */
/*                  2013-02-23  [CSR ID:C20130304_83585] 경조금 쌀화환:0010 추가요청 */
/*                  2013-03-13  [CSR ID:C20130304_83585] 경조금 쌀화환:0010 추가요청 */
/*                  2013-12-04  [CSR ID:C20131203_47673] 문구변경 */
/*                  2013-12-24  [CSR ID:Q20131223_42307] 화환 DUPCHECK 로직 제외 (결혼 화환신청후 본인조위 화환) */
/*                  2013-12-24  [CSR ID:C20131220_57130] 쌀화환 문구변경   */
/*                  2014-04-24  [CSR ID:C20140416_24713]  화환신청시 주문업체 정보추가 , 통상임금정보삭제       */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/*                  2014-07-31  [CSR ID:2584987] HR Center 경조금 신청 화면 문구 수정                                            */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/*                  2014-08-22  LSA 문구삭제 :※ 동일 경조사유에 대한 중복 신청 건은 확인하여 1건의 화환으로 배송 조치됨  */
/*                  2014-08-25  [CSR ID:2597246] 경조화환 시스템 추가 수정요청     */
/*                  2014-08-27  [CSR ID:2599072] 경조화환 신청시 계좌등록 사항 미적용 반영의 건   */
/*                   2015-04-08  [CSR ID:2748092] 경조금 신청화면 로직 변경 요청의 건 */
/*                  2015-04-15  [CSR ID:2753943] 고문실 복리후생 신청 권한 제한 요청 */
/*                  2015-04-20  [CSR ID:2757077] 경조금 추가로직 삭제요청 */
/*                  2016-04-14  [CSR ID:3036899] 경조금 신청화면 기준 추가 요청   */
/*                  2016-05-19  이지은D [CSR ID:3059290] HR제도 팝업 관련 개선 요청의 건 */
/*                  [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S*/
/*                  [CSR ID:3105340] 회갑 경조금 신청시 로직 추가 요청의 건 2016.07.21 김불휘S */
/*                  2016-08-09  [CSR ID:3137937] 경조금 예외 신청 요청 건  김불휘S   */
/*                  2016-08-09  [CSR ID:3138883] 경조금 예외신청자 신청화면 조정 요청의 건  김불휘S*/
/*                 2016-10-20  [CSR ID:3197606] 경조금 신청 관련  김불휘S  */
/*				 	2017-05-26  [CSR ID:3389498] 경조금 신청화면 수정요청의 건 eunha*/
/*					 2017-07-03  eunha [CSR ID:3423281] 경조화환 복리후생 메뉴 추가  */
/*					 2017-07-26  eunha [CSR ID:3444623] 경조금 신청 화면 스크립트 오류 수정  */
/*					 2017-08-02  eunha [CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건  */
/* 				2017-12-01   이지은D[CSR ID:3546961] 경조화환 신청 관련의 건 */
/*  				2018-01-03   cykim  [CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.common.rfc.PersonInfoRFC" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    E19CongcondData  e19CongcondData = (E19CongcondData)request.getAttribute("e19CongcondData");
    String essExcept = (String)request.getAttribute("ESS_EXCPT_CHK");//[CSR ID:3546961]

    Vector E19CongcondData_opt  = (new E19CongRelaRFC()).getCongRela(e19CongcondData.PERNR);
    Vector E19CongcondData_rate = (new E19CongRateRFC()).getCongRate(e19CongcondData.PERNR);
    Vector e19CongraDupCheck_vt = (Vector)request.getAttribute("e19CongraDupCheck_vt");
    Vector e19CongraLifnr_vt    = (Vector)request.getAttribute("e19CongraLifnr_vt");

   //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
    String isFlower   = (String)request.getAttribute("isFlower");
  	Vector E19CongcondData0010_vt  = (new E19CongCodeNewRFC()).getCongCode(user.companyCode,"", isFlower);
  	//Vector E19CongcondData0020_vt  = (new E19CongCodeRFC()).getCongCode(user.companyCode, "",isFlower);
  	Vector E19CongcondData0020_vt  = (new E19CongCodeNewRFC()).getCongCode(user.companyCode,"", isFlower);
   //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end

    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    Vector      AccountData_pers_vt = (Vector)request.getAttribute("AccountData_pers_vt");
    AccountData AccountData_hidden  = (AccountData)request.getAttribute("AccountData_hidden");
    int AccountData_pers_rowCount = AccountData_pers_vt.size();

    //@v1.7
    String webUserID = "";
    if (user.webUserId == null ||user.webUserId.equals("") )
        webUserID = "";
    else
        webUserID = user.webUserId.substring(0,6).toUpperCase();


    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");

    String Except3Month = "";

    if ( essExcept.equals("S") ) {//[CSR ID:3546961]
        Except3Month = "Y";
    }
    /* //사번 : 31779  성명 : 박기성 상무
    if ( PERNR_Data.E_PERNR.equals("00031779") && Integer.parseInt(DataUtil.getCurrentDate()) <20130824 ) {
        Except3Month = "Y";
    }

    //////////임시로 쌀화환 신청되도록 20151217
    if ( PERNR_Data.E_PERNR.equals("00212814") && Integer.parseInt(DataUtil.getCurrentDate()) <20130824 ) {
        Except3Month = "Y";
    }
    if ( PERNR_Data.E_PERNR.equals("00214202") && Integer.parseInt(DataUtil.getCurrentDate()) <20130824 ) {
        Except3Month = "Y";
    }
    if ( PERNR_Data.E_PERNR.equals("00209056") && Integer.parseInt(DataUtil.getCurrentDate()) <20130824 ) {
        Except3Month = "Y";
    }
    if ( PERNR_Data.E_PERNR.equals("00211844") && Integer.parseInt(DataUtil.getCurrentDate()) <20130824 ) {
        Except3Month = "Y";
    }
    //박난이선임요청
    if ( PERNR_Data.E_PERNR.equals("00222794") && Integer.parseInt(DataUtil.getCurrentDate()) <20171030 ) {
        Except3Month = "Y";
    } */


    //Dup checke 제외 Q20131223_42307
    String ExceptDupCheck = "";
    //본인 조위화환, 본인 결혼화환 2개신청 (조위인경우는 극히 일부이므로 예외처리함)
    if ( PERNR_Data.E_PERNR.equals("00080774") ) {
        ExceptDupCheck = "Y";
    }

    //CSR ID: 20140416_24713 화환업체
    Vector e19CongFlowerInfoData_vt = (new E19CongraFlowerInfoRFC()).getFlowerInfoCode(e19CongcondData.CONG_CODE);

    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    // 서블릿에서 넘어온 경조내역이 쌀화환인 경우 경조업체를 조정해준다
    String CONG_CODE_SV = (String)request.getAttribute("CONG_CODE_SV");

    if(CONG_CODE_SV != null) {//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S , 서블릿 타고 왔을 때
        e19CongFlowerInfoData_vt = (new E19CongraFlowerInfoRFC()).getFlowerInfoCode(CONG_CODE_SV);
    }
    String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( e19CongcondData.PERNR);

    E19CongLifnrRFC rfc_List         = new E19CongLifnrRFC();
    Vector E19CongLifnr_vt = null;
    try{
    	if (e19CongcondData.PERNR!=null||!e19CongcondData.PERNR.equals("")) {
      		E19CongLifnr_vt = rfc_List.getLifnr(user.companyCode, e19CongcondData.PERNR, "2");
    	} else {
      		E19CongLifnr_vt = rfc_List.getLifnr(user.companyCode, user.empNo, "2");
    	}
    }catch(Exception e){

    }


    PersonInfoRFC numfunc = new PersonInfoRFC();
    PersonData loginData;
    loginData    =   (PersonData)numfunc.getPersonInfo(user.empNo); //신청자 근무지명GET
    //근무지리스트
    Vector E19CongraGrubNumb_vt  = (new E19CongraGrubNumbRFC()).getGrupCode(user.companyCode,"010");
    String ZGRUP_NUMB_O_NM="";
    for( int i = 0 ; i < E19CongraGrubNumb_vt.size() ; i++ ){
 	   E19CongGrupData  data = (E19CongGrupData)E19CongraGrubNumb_vt.get(i);
 	   if (e19CongcondData.ZGRUP_NUMB_O.equals( data.GRUP_NUMB)){
 		   ZGRUP_NUMB_O_NM=data.GRUP_NAME;
 	   }
    }
    Vector newOpt = new Vector();
    for( int i = 0 ; i < E19CongraGrubNumb_vt.size() ; i++ ){
        E19CongGrupData  data = (E19CongGrupData)E19CongraGrubNumb_vt.get(i);
        CodeEntity code_data = new CodeEntity();
        code_data.code =  data.GRUP_NUMB ;
        code_data.value =  data.GRUP_NAME ;
        newOpt.addElement(code_data);
    }

    Vector newOpt_rela = new Vector();
    String RELA_NAME = "";
    for( int i = 0 ; i < E19CongcondData_opt.size() ; i++ ){
        E19CongcondData old_data = (E19CongcondData)E19CongcondData_opt.get(i);
        if( e19CongcondData.CONG_CODE.equals(old_data.CONG_CODE) ){
            CodeEntity code_data = new CodeEntity();
            code_data.code = old_data.RELA_CODE ;
            code_data.value = old_data.RELA_NAME ;
            RELA_NAME= old_data.RELA_NAME ;
            newOpt_rela.addElement(code_data);
        }
    }
%>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<c:set var="O_CHECK_FLAG" value="<%=O_CHECK_FLAG %>"/>
<c:set var="ExceptDupCheck" value="<%=ExceptDupCheck %>"/>
<c:set var="flowerInfoSize" value="<%=e19CongFlowerInfoData_vt.size()  %>"/>
<c:set var="E19CongLifnr_vt" value="<%=E19CongLifnr_vt %>"/>
<c:set var="Except3Month" value="<%=Except3Month %>"/>
<c:set var="loginData" value="<%=loginData %>"/>
<c:set var="newOpt" value="<%=newOpt %>"/>
<c:set var="AccountData_pers_rowCount" value="<%=AccountData_pers_rowCount %>"/>
<c:set var="E19CongcondData0010_vt" value="<%=E19CongcondData0010_vt %>"/>
<c:set var="E19CongcondData0020_vt" value="<%=E19CongcondData0020_vt %>"/>
<c:set var="E19CongcondData_opt" value="<%=E19CongcondData_opt %>"/>
<c:set var="E19CongcondData_rate" value="<%=E19CongcondData_rate %>"/>
<c:set var="e19CongraDupCheck_vt" value="<%=e19CongraDupCheck_vt %>"/>
<c:set var="e19CongraLifnr_vt" value="<%=e19CongraLifnr_vt %>"/>
<c:set var="PERNR_Data" value="<%=PERNR_Data %>"/>
<c:set var="newOpt_rela" value="<%=newOpt_rela %>"/>
<c:set var="e19CongFlowerInfoData_vt" value="<%=e19CongFlowerInfoData_vt %>"/>
<c:set var="ZGRUP_NUMB_O_NM" value="<%=ZGRUP_NUMB_O_NM%>"/>


<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css">
<%--   //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
<tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_BE_CONG_COND" >
--%>
    <tags-approval:request-layout  titlePrefix ="COMMON.MENU.ESS_BE_CONG_${isFlower eq 'Y' ? 'FLOWER' : 'COND'}"  >
<%--   //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end--%>

                    <tags:script>

                    <script>

    //@v1.9 start
    var epUrl = new Array("","","","","");
    //인사정보
    epUrl[0]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url=";
    //신청
    epUrl[1]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url=";
    //사원인사정보
    epUrl[2]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHROrgStatMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHROrgStatMenu%2Fbegin&_windowLabel=portlet_EHROrgStatMenu_1&_pageLabel=Menu03_Book04_Page01&portlet_EHROrgStatMenu_1url=";
    //조직통계
    epUrl[3]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url=";
    //결재함
    epUrl[4]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url=";

    var docUpid = new Array("0_1006","0_1088","0_1089","0_1090","0_1091","0_1092","0_1285","1_1007","1_1066","1_1134","1_1163","1_1168","1_1222","1_1281","2_1033","2_1053","2_1056","2_1060","2_1063","3_1094","3_1137","3_1138","3_1139","3_1140","3_1141","4_1003");
    function openDoc(docID, upID, realPath)
    {
        var epReturnUrl = "";
        for (r=0;r<docUpid.length;r++) {
           if (upID == docUpid[r].substring(2,6)) {
              epReturnUrl = epUrl[docUpid[r].substring(0,1)]+realPath;
           }
        }
        clickDoc(docID,epReturnUrl);

    }

    function clickDoc(docID,epReturnUrl)
    {
       frm = document.form1;
       frm.action = epReturnUrl;
       frm.target = "_parent";
       frm.submit();
    } // end function

/****** 원화일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWon(this);" *******/
function moneyChkEventForWon(obj){
    val = obj.value;
    if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
        addComma(obj);
    }
    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}

/**************************************************************** 문의 :  김성일 ****/
//달력 사용
function fn_openCal(Objectname, moreScriptFunction){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window=window.open("${g.jsp}common/calendar.jsp?moreScriptFunction="+moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
}
//달력 사용

//[CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건 start
//enable 처리
function setEnable(){
	/* var tbody = $('#table tbody');
	tbody.find(':select').each(function(){
		this.disabled = false;
	}); */
	$("#CONG_CODE").attr("disabled", false);
}
//[CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건 end

function doSubmit() {
    document.form1.checkSubmit.value = "Y";
    if( !check_data() ){

        document.form1.checkSubmit.value = "";
        return;
    } else{

        document.form1.CONG_DATE.value = removePoint(document.form1.CONG_DATE.value) ; //20140416_24713
        document.form1.ZTRANS_DATE.value = removePoint(document.form1.ZTRANS_DATE.value) ; //20140416_24713
        if (document.form1.ZTRANS_TIME.value=="")
            document.form1.ZTRANS_TIME.value = "010100";
        else
            document.form1.ZTRANS_TIME.value = document.form1.ZTRANS_TIME.value.replace(":","")+"00";//20140416_24713
    }

  	//[CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건 start
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;

    if(disa == "0007" || disa == "0010"){
		alert("<spring:message code='MSG.E.E19.0070' />");//결재의뢰 하시겠습니까?\\n취소시 반드시 해당 업체에 연락하여 취소처리 하시기 바랍니다.
    }

  	//필드 enable처리
    setEnable();
  	//[CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건 end

    doSubmit_save();

    return true;
}

function doSubmit_save() {
    //--------------------------------------------------------------------------------------------------------
    document.form1.CONG_WONX.value = removeComma(document.form1.CONG_WONX.value);   // 경조금액의 콤마를 없앤다.
    //--------------------------------------------------------------------------------------------------------
    document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value); //@v1.4

   /* document.form1.jobid.value = "create";
    document.form1.target = "menuContentIframe";

    document.form1.action = "${g.servlet}hris.E.E19Congra.E19CongraBuildSV";

    document.form1.method = "post";

    document.form1.submit();
    */

}

function beforeSubmit() {
	if ( doSubmit()) 	{
		return true;
	}
}

function onload_rela_chk(){
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    var val  = document.form1.RELA_CODE[document.form1.RELA_CODE.selectedIndex].value;
    //돌반지, 화환일경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
    //C20130304_83585 경조쌀화환
    if( disa == "0006" || disa == "0007"||  disa == "0010" ){
        document.form1.CONG_WONX.disabled = 0; //경조금액 활성화
        document.form1.CONG_WONX.style.border = "1 solid #CCCCCC";
        document.form1.CONG_WONX.style.backgroundColor = "#FFFFFF";

        //document.form1.CONG_WONX.value = "         금액을 입력해 주세요         ";
    } else if( disa == "0003" && (val == "0002" || val == "0003") ) {
        document.form1.HOLI_TEXT.value  = "Help 참조　　　　";
        document.form1.HOLI_TEXT1.value = "";
    }

  	//[CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건 start
	if("${isUpdate}" == "true"){
		if(disa == "0007" || disa == "0010"){
			$("#CONG_CODE").attr("disabled", true);
		}else{
			$("#CONG_CODE").attr("disabled", false);
		}
	}else{
		$("#CONG_CODE").attr("disabled", false);
	}
	//[CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건 end
}

//경조대상자 관계코드 값에 따른 Action
function rela_action(obj) {
    var val = obj[obj.selectedIndex].value;//DREL_CODE
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;

    if ( "${PERNR_Data.e_RECON}" == "D" && !(val == "0001" && (disa == "0003"||disa == "0007"))  ) {  // 사망퇴직이고 조위-본인이 아닐경우는 신청 못하도록 함.
        alert("<spring:message code='MSG.E.E19.0020' />"); //사망 퇴직자는 조위-본인과 화환-본인만 경조금 신청할 수 있습니다.
        document.form1.RELA_CODE[0].selected = true;

        return false;
    }

    if ( "${ PERNR_Data.e_RECON }" == "S" && !(val == "0001" && disa == "0001")  ) {  // 여사원퇴직이고 결혼-본인이 아닐경우는 신청 못하도록 함.
        alert("<spring:message code='MSG.E.E19.0021' />"); //미혼 여사원 퇴직자는 결혼-본인만 경조금 신청할 수 있습니다.
        document.form1.RELA_CODE[0].selected = true;

        return false;
    }
    //C20130304_83585 경조쌀화환:0010


    if( disa == "0006" || disa == "0007"|| disa == "0010"  ){  //돌반지,  화환일 경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
        document.form1.CONG_WONX.disabled = 0;//경조금액 활성화
        document.form1.CONG_WONX.style.border = "1 solid #CCCCCC";
        document.form1.CONG_WONX.style.backgroundColor = "#FFFFFF";
        if( disa == "0007" ){ //화환
          //document.form1.CONG_WONX.value = insertComma("120000"+"");
          document.form1.CONG_WONX.value = "0";
        }else if( disa == "0010" ){ //경조쌀화환
          document.form1.CONG_WONX.value = insertComma("160000"+"");


        }else {
          document.form1.CONG_WONX.value = " 금액을 입력해 주세요         ";
        }

      <c:forEach var="row" items="${E19CongcondData_rate}" varStatus="status2">


    } else if( val == "${row.RELA_CODE}" && disa == "${row.CONG_CODE}" ){
        document.form1.CONG_RATE.value = "${row.CCON_RATE}";//지급율 %

//      2002.07.03. 조위이면서 부모, 배우자부모일경우에는 일수가 아닌 text를 보여준다. 요청자 : 성경호, 수정자 : 김도신
        if( disa == "0003" && (val == "0002" || val == "0003") ) {
            document.form1.HOLI_TEXT.value  = "Help 참조　　　　";
            document.form1.HOLI_TEXT1.value = "";
//      2002.07.03. 조위이면서 부모, 배우자부모일경우에는 일수가 아닌 text를 보여준다. 요청자 : 성경호, 수정자 : 김도신
        } else {
            document.form1.HOLI_TEXT.value  = "${f:printNumFormat( row.HOLI_CONT, 0)}";
            document.form1.HOLI_TEXT1.value = "일";
        }
          document.form1.HOLI_CONT.value = "${row.HOLI_CONT eq ''  ? ''  : f:printNumFormat(row.HOLI_CONT,0)}";//경조휴가일수
        document.form1.CONG_WONX.value = cal_money();//계산된 경조금
        </c:forEach>
    }

    document.form1.EREL_NAME.value=""; //[CSR ID:C20120323_76012 ]
    //@v1.9
    //if( document.form1.RELA_CODE.value != "" ){
    //   check1.style.display = "block";
    //} else{
    //   check1.style.display = "none";
    //}
}

// 경조발생일자 변경에 따른 Action - 돌반지는 재계산하지 않는다.
function rela_action_1(obj) {
    var val = obj[obj.selectedIndex].value;//DREL_CODE
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;

    //돌반지, 화환일 경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
    //C20130304_83585 경조쌀화환:0010 160000만원고정
    if( disa == "0006" || disa == "0007" || disa == "0010"  ){
        // -------------
<c:forEach var="row" items="${E19CongcondData_rate}" varStatus="status">

    } else if( val == "${row.RELA_CODE}" && disa == "${row.CONG_CODE}" ){
        document.form1.CONG_RATE.value ="${row.CCON_RATE}";//지급율 %
        document.form1.HOLI_CONT.value ="${row.HOLI_CONT eq '' ? '' : f:printNum(row.HOLI_CONT)}";//경조휴가일수
        document.form1.CONG_WONX.value = cal_money();//계산된 경조금
</c:forEach>
    }
}

function chk_limit(obj) {
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    var val = removeComma(obj.value);
    var val_int = Number(val);
    if( isNaN(val_int) ) {
        //obj.value = "";
        return;
    }

    if ( disa == "0006" ) {
        if( val_int > 100000 ) {
            alert("<spring:message code='MSG.E.E19.0022' />"); //돌반지의 경조금액은 100,000 원을 넘지 못합니다.
            obj.focus();
            obj.select();
            return;
        }
    } else if ( disa == "0007" ) {
        if( val_int > 120000 ) {
            alert("<spring:message code='MSG.E.E19.0023' />"); //화환은 120,000 원을 넘지 못합니다.
            obj.focus();
            obj.select();
            return;
        }
    } else if ( disa == "0010" ) { //C20130304_83585 경조쌀화환:0010
        if( val_int > 160000 ) {
            alert("<spring:message code='MSG.E.E19.0024' />"); //쌀화환은 160,000 원을 넘지 못합니다.
            obj.focus();
            obj.select();
            return;
        }
    }

    obj.value = insertComma(money_olim(val_int)+"");
}

//LG화학, LG석유화학 구분없이 1000 미만 단수절상
function money_olim(val_int){
    var money = 0;
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    //C2004011301000000544. mkbae.
    if(disa == "0006") {
        money = val_int;
    } else {
        money = olim(val_int, -3);
    }
    return money;
}

//경조금 계산(근속년수가 LG화학-1년미만, LG석유화학-6개월미만 시 지급율의 50%를 지급)
function cal_money(){
    var money = 0 ;
    var rate = 0;
    var wage = 0;
    var compCode = 0;

    rate = Number(document.form1.CONG_RATE.value);
    //wage = Number(document.form1.WAGE_WONX.value);
    //@v1.4
    wage = Number(removeComma(document.form1.WAGE_WONX.value));

    //wage = Number("${resultDate.WAGE_WONX}");

    money = ( rate * wage )/100;
    compCode = "${user.companyCode}";
    WORK_YEAR = Number(document.form1.WORK_YEAR.value);
    WORK_MNTH = Number(document.form1.WORK_MNTH.value);

    if( WORK_YEAR < 1){//LG화학-1년미만
        money = money * 0.5 ;
        r_val = document.form1.CONG_RATE.value;
        document.form1.CONG_RATE.value = Number(document.form1.CONG_RATE.value) * 0.5 ;//지급율 % 도 50%로
    }
    /*} else if( (compCode=="N100") && (WORK_YEAR < 1) && (WORK_MNTH < 6) ){//LG석유화학-6개월미만
        money = money * 0.5 ;
        document.form1.CONG_RATE.value = Number(document.form1.CONG_RATE.value) * 0.5 ;//지급율 % 도 50%로
    } else if(compCode != "C100" && compCode != "N100" ) {
        alert("회사코드를 얻지 못했습니다. 관리자에게 문의해주세요.");
        history.back();
    }*/
    money = money_olim(money);
    money = insertComma(money+"");
    return money;
}

function reset_Rate() {//
    document.form1.CONG_RATE.value  = "";//지급율 %
    document.form1.CONG_WONX.value  = "";//경조금액
    document.form1.HOLI_CONT.value  = "";//경조휴가일수
    document.form1.HOLI_TEXT.value  = "";//경조휴가일수 TEXT
    document.form1.HOLI_TEXT1.value = "";//경조휴가일수 일 TEXT

    document.form1.CONG_WONX.disabled = 1;
    document.form1.CONG_WONX.style.backgroundColor = "#EDEDED";
    document.form1.CONG_WONX.style.border = "1 solid #ECECEC";
}



function view_Lifnr(obj) {
  var Lifnr_V = obj.value;
  var sIndex = obj.selectedIndex;
  var SearchFlag = false;

   <c:forEach var="row" items="${E19CongLifnr_vt}" varStatus="status">

        if( Lifnr_V == "${row.LIFNR}" ) {
          document.form1.BANK_NAME.value = "${row.BANKA}";
          document.form1.BANKN.value = "${row.BANKN}";
          SearchFlag = true;
        } else if( Lifnr_V =="" ) {
          document.form1.BANK_NAME.value = "";
          document.form1.BANKN.value = "";
        }
  </c:forEach>
//    if (!SearchFlag)
//   <%-- if (<%=E19CongLifnr_vt.size()+1%>!=obj.length)--%>
    if (document.form1.p_BANKN_SEARCHGUBN.value == "SEARCH")
       ifHidden.view_LifnrDept(obj.value,sIndex); //@v1.1

}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";

    //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
    //frm.action = "${g.servlet}hris.E.E19Congra.E19CongraBuildSV";
    <c:choose>
    <c:when test=    "${ isFlower  eq  'Y'}" >
    frm.action = "${g.servlet}hris.E.E19Congra.E19CongraFlowerBuildSV";
    </c:when>
    <c:otherwise>
    frm.action = "${g.servlet}hris.E.E19Congra.E19CongraBuildSV";
    </c:otherwise>
    </c:choose>
    //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end
   //[CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건 start(주석처리)
    //frm.target = "menuContentIframe";
    //[CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건 end
    frm.submit();
}

//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
//처음화면에 들어왔을 경우와 화환 또는 쌀화환을 선택하여 서블릿을 타고 돌아온 경우를 구분하도록 수정


function firstHideshow() {
	<c:if test="${isUpdate}">
	document.form1.EXCEP.value = "X";
	</c:if>
	//  C20140416_24713 화환 통상임금,지급율    삭제
	//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
	//경조내역 수정하기 위해 서블릿 갔다가 다시 온 경우를 포함하여 수정함
	<c:choose>
	<c:when test="${empty e19CongcondData.CONG_CODE}">
    if("${CONG_CODE_SV}" == null || "${CONG_CODE_SV}" == "") { //처음 화면에 들어온 경우
    	//[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
    	if ("${isFlower}" =="Y"){
    		jumunINFO.style.display = "block"; //C20140416_24713 주문정보
   			wage_0007.style.display = "none"; //C20140416_24713 통상임금,지급율    삭제
    		bubank.style.display = "none"; //C20140416_24713 부서계좌  삭제
           // view_Rela(document.form1.CONG_CODE);
    	}else{
    	//[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end
    	bubank.style.display = "none";
        jumunINFO.style.display = "none"; //C20140416_24713

    	}
    } else if("0007"== "${CONG_CODE_SV}") { //화환 선택하고 서블릿 탔다가 돌아온 경우
        //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
        document.form1.CONG_CODE[1].selected = true;
        //document.form1.CONG_CODE[5].selected = true;
        //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end
        bubank.style.display = "none";
        jumunINFO.style.display = "block";
        view_Rela(document.form1.CONG_CODE);
    } else if("0010"== "${CONG_CODE_SV}") { //쌀화환 선택하고 서블릿 탔다가 돌아온 경우
        //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
        document.form1.CONG_CODE[2].selected = true;
        //document.form1.CONG_CODE[7].selected = true;
        //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end
        bubank.style.display = "none";
        jumunINFO.style.display = "block";
        view_Rela(document.form1.CONG_CODE);

    }
	</c:when>
	<c:otherwise>


	<c:choose>

	<c:when  test="${e19CongcondData.CONG_CODE =='0010' and empty CONG_CODE_SV  }" > // [CSR ID:3389498] 경조금 신청화면 수정요청의 건(임직원 본인의 경우는 직접 화환 및 쌀화환을 신청도 가능하도록 로직 추가)
	        //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
	        //CONG_CODE_SV 가 null 이면 서블릿을 안갔다 온것
	        wage_0007.style.display = "none";

	        //wage_0007.style.display = "block"; //C20140416_24713 화환일때 통상임금,지급율    삭제
	        //jumunINFO.style.display = "none"; //C20140416_24713

	        //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
	        jumunINFO.style.display = "block";

	    	bubank.style.display = "none"; //부서계좌
	    </c:when>
	    <c:when  test="${e19CongcondData.CONG_CODE =='0007' and empty CONG_CODE_SV  }" >  // [CSR ID:3389498] 경조금 신청화면 수정요청의 건(임직원 본인의 경우는 직접 화환 및 쌀화환을 신청도 가능하도록 로직 추가)
	    	bubank.style.display = "none";
	        wage_0007.style.display = "none"; //C20140416_24713 화환일때 통상임금,지급율    삭제
	        jumunINFO.style.display = "block"; //C20140416_24713  화환일때만 주문정보 보임
	     </c:when>
	     <c:when test="${e19CongcondData.CONG_CODE !='0007' and e19CongcondData.CONG_CODE !='0010' }" >
	        jumunINFO.style.display = "none"; //C20140416_24713
	        wage_0007.style.display = "block"; //C20140416_24713 통상임금,지급율    삭제
	    	bubank.style.display = "none";
	      </c:when>
	      <c:when test="${( e19CongcondData.CONG_CODE =='0007' or e19CongcondData.CONG_CODE =='0001')  and !empty CONG_CODE_SV  }" >// [CSR ID:3389498] 경조금 신청화면 수정요청의 건(임직원 본인의 경우는 직접 화환 및 쌀화환을 신청도 가능하도록 로직 추가)
		//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
		//경조내역에서 화환 또는 쌀화환 선택 시 경조관계를 초기화하도록 수정
		document.form1.RELA_CODE[0].selected = true;
		bubank.style.display = "none";
	    wage_0007.style.display = "none"; //C20140416_24713 화환일때 통상임금,지급율    삭제
	    jumunINFO.style.display = "block"; //C20140416_24713  화환일때만 주문정보 보임
	</c:when>
	</c:choose>

	</c:otherwise>
	</c:choose>

	}


//@v1.1 start부서계좌를 가지고 있는 사람 검색
function deptbank_search()
{
    val1 = document.form1.DEPT_NAME.value;
    val1 = rtrim(ltrim(val1));

    if ( val1 == "" ) {
        alert("<spring:message code='MSG.E.E19.0025' />"); //검색할 성명을 입력하세요!
        document.form1.DEPT_NAME.focus();
        return;
    } else {
        if( val1.length < 2 ) {

            alert("<spring:message code='MSG.E.E16.0001' />"); //검색할 성명을 한 글자 이상 입력하세요!
            document.form1.DEPT_NAME.focus();
            return;
        } // end if
    } // end if

    document.form1.target = "ifHidden";
    document.form1.action = "${g.jsp}E/E19Congra/E19HiddenLifnrByEname.jsp";
    document.form1.submit();
} // @v1.1 end function

//@v1.9[CSR ID:1225704]
function fn_relaNmPOP() {

    //var win = window.open("","family","width=550,height=400,left=365,top=70,scrollbars=yes");
    var win = window.open("","family","width=1000,height=400,left=365,top=70,scrollbars=yes");

    frm =  document.family;
    frm.PERNR.value = "${e19CongcondData.PERNR}";
    frm.OBJ.value   = "form1.EREL_NAME";
    frm.CONG_CODE.value = document.form1.CONG_CODE.value ;
    frm.RELA_CODE.value = document.form1.RELA_CODE.value ;

    frm.action = "${g.jsp}"+"E/E19Congra/E19CongraFamily_pop.jsp";
    frm.target = "family";
    frm.submit();
    win.focus();

  //var url="${g.jsp}"+"E/E19Congra/E19CongraFamily_pop.jsp?PERNR="+"${e19CongcondData.PERNR}";
  var win = window.open("","family","width=680,height=480,left=365,top=70,scrollbars=auto");
  win.focus();

}
function openDocPOP() {
  //var url="${g.jsp}"+"E/E19Congra/E19CongraFamily_pop.jsp?PERNR="+"${e19CongcondData.PERNR}";
  //var url="${g.jsp}"+"A/A12Family/A12FamilyBuild.jsp";
  var url= "${g.servlet}hris.A.A12Family.A12FamilyBuildSV?SCREEN=E19" ;
  var win = window.open(url,"family","width=1000,height=400,left=365,top=70,scrollbars=yes");
  //openDoc('1012','1007','/servlet/hris.A.A12Family.A12FamilyBuildSV')
  win.focus();

}

function view_Rela(obj) {


    reset_Rate();//계산부분 reset
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;

    if(disa == "") {
        reload();
    }
    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    //쌀화환도 화환과 같게 수정
    if ( disa == "0007" || disa == "0010"   ) {  // 화환일 경우만 부서계좌번호를 보여주고 입력할 수 있도록 함.
    	// [CSR ID:3389498] 경조금 신청화면 수정요청의 건 20170526 eunha start
    	   <%--<c:choose>
    	   <c:when  test="${ user.e_representative  eq  'Y'}" > // 부서서무 담당일때
       			 //alert("서버이전 작업중입니다.\n화환업체로 SMS 발송기능 불가로, 개별 연락 부탁드립니다.\n*작업일시 : 2015-12-11 21:00~24:00");
        		jumunINFO.style.display = "block"; //C20140416_24713 주문정보
       			wage_0007.style.display = "none"; //C20140416_24713 통상임금,지급율    삭제
        		bubank.style.display = "none"; //C20140416_24713 부서계좌  삭제
        		document.form1.LIFNR[0].selected = true;
        	</c:when>
        	<c:otherwise>
       		    alert("<spring:message code='MSG.E.E19.0026' />"); //화환 및 쌀화환은 부서담당이 대행 신청합니다.
        		jumunINFO.style.display = "none";
        		bubank.style.display = "none";
        		document.form1.CONG_CODE.focus();
        		document.form1.CONG_CODE[0].selected = true;
        		document.form1.RELA_CODE[0].selected = true;
        	  return;
        	 </c:otherwise>
        	 </c:choose>
        	 --%>
     		jumunINFO.style.display = "block"; //C20140416_24713 주문정보
   			wage_0007.style.display = "none"; //C20140416_24713 통상임금,지급율    삭제
    		bubank.style.display = "none"; //C20140416_24713 부서계좌  삭제
    		document.form1.LIFNR[0].selected = true;
    		// [CSR ID:3389498] 경조금 신청화면 수정요청의 건 20170526 eunha end
    } else {
        jumunINFO.style.display = "none"; //C20140416_24713
        wage_0007.style.display = "block"; //C20140416_24713 통상임금,지급율    삭제
        bubank.style.display = "none"; //C20140416_24713 부서계좌  삭제
    }

    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    // 쌀화환 별도 적용하던 것을 주석 처리함
    //if ( disa == "0010" ) {  // 쌀화환일 경우만 부서계좌번호를 보여주고 입력할 수 있도록 함.
    //    bubank.style.display = "block";
    //    jumunINFO.style.display = "block";
   // }

    //[CSR ID:C20130304_83585]
//    if ( disa == "0010" ) {  // 쌀화환일 경우
//      text1.style.display = "none";
//      text2.style.display = "block";
//    } else {
//       text1.style.display = "block";
//       text2.style.display = "none";
//    }
//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S


    //경조관계 보여주는 부분
    var val = obj[obj.selectedIndex].value;//DISA_CODE 값
    <c:forEach var="row" items="${E19CongcondData_opt}" varStatus="status">
	  <c:choose>
	   	<c:when  test="${before eq  row.CONG_CODE}" >
	   		<c:set var="index" value="${index+1}"/>
	    	document.form1.RELA_CODE.length = ${index};
    		document.form1.RELA_CODE[${index-1}].value = "${row.RELA_CODE}";
    		document.form1.RELA_CODE[${index-1}].text  = "${row.RELA_NAME}";
    	</c:when>
    	<c:otherwise>
    	    <c:set var="index" value="2"/>
    	    <c:choose>
    	    <c:when test="${status.index eq '0'}">
				if( val == "${row.CONG_CODE}" ) {
    				document.form1.RELA_CODE.length = ${index};
    				document.form1.RELA_CODE[${index-1}].value = "${row.RELA_CODE}";
    				document.form1.RELA_CODE[${index-1}].text  = "${row.RELA_NAME}";
    		</c:when>
    		<c:otherwise>
			    }else if( val == "${row.CONG_CODE}" ) {
			        document.form1.RELA_CODE.length = ${index};
			        document.form1.RELA_CODE[${index-1}].value = "${row.RELA_CODE}";
			        document.form1.RELA_CODE[${index-1}].text  = "${row.RELA_NAME}";

    		</c:otherwise>
    		</c:choose>
    		<c:set var="before" value="${row.CONG_CODE}"/>
    	</c:otherwise>
    	</c:choose>
  </c:forEach>
			    }
    if( val == "" ) {
        document.form1.RELA_CODE.length = 1;
    }
    document.form1.RELA_CODE[0].selected = true;
}

<!-- 경조발생일자 기준의 근속년월을 가져오기 ------------------------------------------>

function after_event_CONG_DATE(){
    event_CONG_DATE(document.form1.CONG_DATE);

    //C20140416_24713
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    if ( disa == "0007" ) { //화환
        document.form1.ZTRANS_DATE.value =  document.form1.CONG_DATE.value ;
    }
}
//[CSR ID:3444623] 경조금 신청 화면 스크립트 오류 수정 20170726 eunha start
/*function event_CONG_DATE(obj){
//[CSR ID:2757077] 경조금 추가로직 삭제요청
    //if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() &&chkInvalidRegno() ){
    if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() ){
        document.form3.CONG_DATE.value = removePoint(document.form1.CONG_DATE.value);

        //@v1.9
        document.form3.CONG_CODE.value = removePoint(document.form1.CONG_CODE.value);
        document.form3.RELA_CODE.value = removePoint(document.form1.RELA_CODE.value);
       // alert( removePoint(document.form1.CONG_DATE.value));

        document.form3.action="${g.jsp}E/E19Congra/E19Hidden4WorkYear.jsp";
        document.form3.target="ifHidden";
        document.form3.submit();
    }


}*/

function event_CONG_DATE(obj){
//[CSR ID:2757077] 경조금 추가로직 삭제요청
    //if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() &&chkInvalidRegno() ){
   try{
    if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() ){
        var url = '/servlet/servlet.hris.E.E19Congra.E19CongraBuildSV';
		var pars = 'PERNR=${e19CongcondData.PERNR}&CONG_DATE=' + removePoint(document.form1.CONG_DATE.value) +'&CONG_CODE=' + removePoint(document.form1.CONG_CODE.value)+'&RELA_CODE=' + removePoint(document.form1.RELA_CODE.value)+"&jobid=check"
		blockFrame();
		$.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){
			showResponse(data);
			rela_action_1(document.form1.RELA_CODE);
			}
		});
    }else{
    	obj.value ="";
    }
   }catch(e){
	   alert("<spring:message code='MSG.E.E19.0068' />");
	   obj.value ="";
   }
}

function showResponse(originalRequest)	{

	 $.unblockUI();
	if (originalRequest != ""){
		arr = originalRequest.split('||');
		if (arr[0]!="Y"  ) {
			alert(arr[1]);
			return ;
		}
		form1.WORK_YEAR.value  			= arr[2];
		form1.WORK_MNTH.value    		= arr[3];
		form1.WAGE_WONX.value    		= arr[4];

	}
}
//[CSR ID:3444623] 경조금 신청 화면 스크립트 오류 수정 20170726 eunha end

function chkInvalidDate(){
    //경조사 발생 3개월초과시 에러처리

    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);

    betw = getAfterMonth(addSlash(congra_date), 3);//경조발생+3month
    dif = dayDiff(addSlash(begin_date), addSlash(betw));//신청일~경조발생+3month 의 day수

    betw2 = getAfterMonth(addSlash(begin_date), 1);//신청일+1month
    dif2 = dayDiff(addSlash(congra_date), addSlash(betw2));

    dif3 = begin_date - congra_date;

    var reg_no_v1 ="";
    var limit_day_v1 ="";
    var dif4 ="";
    var c_CONG_CODE = document.form1.CONG_CODE.value;

//[CSR ID:3444623] 경조금 신청 화면 스크립트 오류 수정 20170726 eunha start
    if( checkNull(document.form1.CONG_CODE, "<spring:message code='MSG.E.E19.0055' />") == false ) {
    	document.form1.CONG_DATE.value="";
    	return false;
    }
    //if( checkNull(document.form1.RELA_CODE, "경조대상자를") == false ) {
    if( checkNull(document.form1.RELA_CODE, "<spring:message code='MSG.E.E19.0056' />") == false ) {
    	document.form1.CONG_DATE.value="";
         return false;
    }
    // if( checkNull(document.form1.EREL_NAME, "경조대상자 성명을") == false ) {
    if( checkNull(document.form1.EREL_NAME, "<spring:message code='MSG.E.E19.0057' />") == false ) {
    	document.form1.CONG_DATE.value="";
    	return false;
    }

    if(document.form1.REGNO.value ==""||document.form1.REGNO.value.length< 6 ) {
        alert("<spring:message code='MSG.E.E19.0068' />");
        document.form1.CONG_DATE.value="";
    	return false;
    }
//[CSR ID:3444623] 경조금 신청 화면 스크립트 오류 수정 20170726 eunha end

    if(c_CONG_CODE == "0002" ){
        //[CSR ID:2748092] 박난이S 요청 경조금 신청 시 회갑의 경우 경조대상자 생일+3month 까지가 경조발생일자여야 하며 그걸 넘어서면 신청이 불가하도록 함.
        reg_no_v1 = getAfterMonth(addSlash("19"+document.form1.REGNO.value.substring(0,6)), 3);//경조대상자 회갑생일+3month
        limit_day_v1 = getAfterYear(addSlash(reg_no_v1), 60);//60년 이후(올해) 신청기한날짜
        dif4 = dayDiff(addSlash(congra_date), addSlash(limit_day_v1));//신청일~경조발생+3month 의 day수
    }

    if ( "${ PERNR_Data.e_RECON }" == "" ) {  // 퇴직자가 아닐때
        //[CSR ID:3189675] 경조금 회갑 예외신청 개선
        // 특정 컬럼 값에 x가 들어있지 않으면 회갑신청시 추가 로직을 타게 만든다. x값이 있으면 하기의 로직을 타지 않고 그 다음 로직으로 간다.
        var EXCEP = document.form1.EXCEP.value;
        if(( EXCEP != "X" || EXCEP == "") && "${Except3Month}" !="Y") {//[CSR ID:3546961]



			if(c_CONG_CODE == "0002" ){
        	if(getAfterYear(addSlash("19"+document.form1.REGNO.value.substring(0,6)),60).substring(0,4) != congra_date.substring(0,4) ){ // 생일+60년과 경조신청일 연도가 다를 때

            if( (	getAfterYear(addSlash("19"+document.form1.REGNO.value.substring(0,6)),60).substring(0,4) - congra_date.substring(0,4) ==1 )||( getAfterYear(addSlash("19"+document.form1.REGNO.value.substring(0,6)),60).substring(0,4) - congra_date.substring(0,4) == -1)  ){//'경조대상자 생일+60년' 과 '경조발생일' 간 연도가 1년 차이일 때

            	if( (getAfterYear(addSlash("19"+document.form1.REGNO.value.substring(0,6)),60).substring(4,6) - congra_date.substring(4,6) == 11) || (getAfterYear(addSlash("19"+document.form1.REGNO.value.substring(0,6)),60).substring(4,6) - congra_date.substring(4,6) == -11) ){ // '경조대상자 생일+60년' 과 '경조발생일' 간 월의 차이가 1개월인 경우
    				// 한달 차이는 일단 계속 프로세스를 진행하도록 함.

            		} else { // '경조대상자 생일+60년' 과 '경조발생일' 간 월의 차이가 2개월 이상일 경우
            			alert("<spring:message code='MSG.E.E19.0027' />"); //경조대상자의 주민등록상 올해 대상년도가 아니므로\n신청이 불가능합니다.\n\n관련하여 문의사항이 있는 경우에는 각 사업장 관할부서에\n연락주시기 바랍니다.
            			return false;
            			}

            	} else{ //연도가 2년 이상 차이날 경우
            		alert("<spring:message code='MSG.E.E19.0027' />"); //경조대상자의 주민등록상 올해 대상년도가 아니므로\n신청이 불가능합니다.\n\n관련하여 문의사항이 있는 경우에는 각 사업장 관할부서에\n연락주시기 바랍니다.
            		return false;
            	}

        	}
        }

        } //[CSR ID:3189675] 경조금 회갑 예외신청 개선  끝
	 /* <c:if  test="${!( PERNR_Data.e_PERNR eq  '00203430' or PERNR_Data.e_PERNR eq  '00214482')  }" >   [CSR ID:3546961] 하드코딩 삭제*/
        if( "${Except3Month}" != "Y" &&  dif < 0){ // 신청일로 부터 3달 전에 발생한 회갑까지만 신청 가능, 경조발생일이 과거이고 회갑일 때는 이리로 옴
        	str = "<spring:message code='MSG.E.E19.0028' />"; // 신청일이 경조발생일로부터 3개월이 넘었을 경우  //        경조를 신청할수 없습니다.\n\n 경조발생일 이후 3개월까지만 신청할 수 있습니다.
            alert(str);
            return false;
        }
   /*  </c:if> */

        /*[CSR ID:2757077] 경조금 추가로직 삭제요청

        else{
            if(c_CONG_CODE == "0002" && "< %=Except3Month%>" != "Y" && dif4 < 0){
                str = '        경조를 신청할수 없습니다.\n\n 관련 문의사항은 관할부서에 연락해주시기 바랍니다. ';//경조대상자 생일 기준 3개월 이전에 발생일자 넣으면 에러
                alert(str);
                return false;
            }
        }*/
    } else { // 퇴직자 일 경우
        var reday = "${ PERNR_Data.e_REDAY }";
        betwR = getAfterMonth(addSlash(reday), 3);
        difR  = dayDiff(addSlash(congra_date), betwR);
        if("${Except3Month}" != "Y" && difR < 0){
            str = "<spring:message code='MSG.E.E19.0029' />"; //        경조를 신청할수 없습니다.\n\n 퇴직일 이후 3개월까지만 신청할 수 있습니다.
            alert(str);
            return false;
        }

    }
    <c:choose>
    <c:when  test="${ user.companyCode eq  'C100'}" >
	    var disadif = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    	dif9 = dayDiff(addSlash(congra_date), addSlash(begin_date)); //CSR ID:1225704
        if( "${PERNR_Data.e_RECON }" != "D" && "${ PERNR_Data.e_RECON }" != "S" && disadif != "0007" && dif9 < -7 ){
        str = "<spring:message code='MSG.E.E19.0030' />"; //신청일보다 경조발생일자가 8일 이상 미래인 경우, 즉 사전신청은 7일까지 밖에 안됨.  //        경조를 신청할수 없습니다.\n\n 경조발생일 이전에 신청할 수 없습니다.
        alert(str);
        return false;
    }
 </c:when>
 <c:otherwise>
    if(dif2 < 0) { //위의 경우가 아닐 때, 경조발생일이 미래인 경우
        str = "<spring:message code='MSG.E.E19.0031' />"; //        경조를 신청할수 없습니다.\n\n 경조발생일 이전 1개월 내에 신청할 수 있습니다.
        //str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
        alert(str);
        return false;
    }
    </c:otherwise>
    </c:choose>
    return true;
}

//[CSR ID:2748092] 박난이S 요청 경조금 신청 시 회갑의 경우 경조대상자 생일+3month 까지가 경조발생일자여야 하며 그걸 넘어서면 신청이 불가하도록 함.
function chkInvalidRegno(){//[CSR ID:2757077] 경조금 추가로직 삭제요청으로 더 이상 적용되지는 않음
    var c_CONG_CODE = document.form1.CONG_CODE.value;

    if(c_CONG_CODE == "0002"){//회갑
        var congra_date_v1 = removePoint(document.form1.CONG_DATE.value);//경조일자
        var reg_no_v1 = getAfterMonth(addSlash("19"+document.form1.REGNO.value.substring(0,6)), 3);//3개월 이후의 경조대상자 생일
        var limit_day_v1 = getAfterYear(addSlash(reg_no_v1), 60);//60년 이후(올해) 신청기한날짜

        if(congra_date_v1>limit_day_v1){
            alert("<spring:message code='MSG.E.E19.0032' />");//경조대상자 생일 기준 3개월 이전에 발생일자 넣으면 에러   //경조금을 신청할수 없습니다./n/n관련 문의사항은 관할부서에 연락해주시기 바랍니다.
            return false;
        }
    }
    return true;
}


//가족목록 팝업이 닫힐때
function openerPutLNMHG(LNMHG){
document.form1.LNMHG.value = LNMHG;
}
//[CSR ID:3189675] 경조금 회갑 예외신청 개선
///가족목록 팝업이 닫힐때
function openerPutEXCEP(EXCEP){
	document.form1.EXCEP.value = EXCEP;
}

//배송일자추가 C20140416_24713
function after_fn_openCal(){
    on_Blur(document.form1.ZTRANS_DATE);
}
function on_Blur(obj) {
    if( obj.value != "" && dateFormat(obj) ) {
        date_n = Number(removePoint(obj.value));

    }
}
// 시간 선택 C20140416_24713
function fn_openTime(Objectname){
  small_window=window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname,"essTime","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=200");
  small_window.focus();
}
//function EnterCheck2(){
//    if (event.keyCode == 13)  {
//        doCheck();
//    }
//}
//시간선택 팝업에서  call C20140416_24713
function check_Time(){
    return;
}

//[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
//경조내역을 바꿀 때, 조건에 맞게 작동하도록 새로 펑션을 만듦
function change_CONG_CODE() {
    if(document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value == "0007" || document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value == "0010") {
    	document.form1.jobid.value = "change_code";
        //[CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건 start(주석처리)
        //document.form1.target = "menuContentIframe";
        //[CSR ID:3443440] 경조화환 신청 메뉴 수정요청의 건 end
        //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
        //document.form1.action = "${g.servlet}hris.E.E19Congra.E19CongraBuildSV";
        document.form1.action = "${g.servlet}hris.E.E19Congra.E19CongraFlowerBuildSV";
        //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end
        document.form1.method = "post";
        document.form1.submit();
    } else {
    	view_Rela(document.form1.CONG_CODE);
    }

}



$(function() {
	firstHideshow();
	onload_rela_chk();
	if( "${user.e_persk}"== "14" ) $(".-request-button").hide();
    if(parent.resizeIframe)   {
    	parent.resizeIframe(document.body.scrollHeight);
    }


});




function check_data(){
	 //if( checkNull(document.form1.CONG_CODE, "경조내역을") == false ) {
    if( checkNull(document.form1.CONG_CODE, "<spring:message code='MSG.E.E19.0055' />") == false ) {
        return false;
    }
    //if( checkNull(document.form1.RELA_CODE, "경조대상자를") == false ) {
    if( checkNull(document.form1.RELA_CODE, "<spring:message code='MSG.E.E19.0056' />") == false ) {
        return false;
    }
    // if( checkNull(document.form1.EREL_NAME, "경조대상자 성명을") == false ) {
    if( checkNull(document.form1.EREL_NAME, "<spring:message code='MSG.E.E19.0057' />") == false ) {
        return false;
    }
    //  2003.02.20 - 경조금 신청시 중복신청을 체크하는 로직 추가
    //             - 신청사번에 대하여 동일 경조내역 & 동일 경조대상자 성명이 있는경우 신청하지 못한다
    var re, c_CONG_CODE, c_RELA_CODE, c_EREL_NAME;

    re = / /g;       //정규식 패턴을 만듭니다.

    c_CONG_CODE = document.form1.CONG_CODE.value;
    c_RELA_CODE = document.form1.RELA_CODE.value;
    c_EREL_NAME = document.form1.EREL_NAME.value;

    c_EREL_NAME = c_EREL_NAME.replace(re, "");    //re를 ""로 바꿉니다.
    document.form1.EREL_NAME.value = c_EREL_NAME;

    var LNMHG = document.form1.LNMHG.value; //대상자 성
    var PER_LNMHG = document.form1.PER_LNMHG.value.substring(0,document.form1.LNMHG.value.length); //본인 성

    //@@@조위:0003 주민번호 뒷자리가 1이면서 백숙부상  임직원의 姓과 차이 있는 경우
    if ( c_CONG_CODE == "0003" && c_RELA_CODE =="0008" && "${fn:substring(PERNR_Data.e_REGNO,6,7)}" == "1" && PER_LNMHG!=  LNMHG   ) {
         var msg1="<spring:message code='MSG.E.E19.0033' />"; //백숙부모상은 본인기준 큰아버지, 큰어머니, 작은아버지, 작은어머니만 해당되며, 그외 가족(외숙부모등)은 신청 불가합니다\n신청하시겠습니까?

         if(!confirm(msg1)) {
             return;
         }
    }

    // Q20131223_42307본인 조위화환, 본인 결혼화환 2개신청
    if( "${ExceptDupCheck}" != "Y"  ) {


    <c:forEach var="row" items="${e19CongraDupCheck_vt}" varStatus="status">

            if( "${ user.companyCode}" == "C100" && c_CONG_CODE == "0009" && c_RELA_CODE == "0001" ) {
                //      lg화학(C100) : 본인 재혼은 제외 - Temp Table만 체크한다.
                if( "${row.CONG_CODE }" == c_CONG_CODE && "${row.RELA_CODE }" == c_RELA_CODE && "${row.EREL_NAME }" == c_EREL_NAME ) {
                	<c:if  test="${row.INFO_FLAG  eq  'T' and  row.AINF_SEQN ne e19CongcondData.AINF_SEQN}" >
                        alert("<spring:message code='MSG.E.E19.0034' />"); //현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.
                        return false;
                     </c:if>
                 }
            } else if( "${ user.companyCode }" == "N100" && c_CONG_CODE == "0001" ) {
            //      lg석유화학(N100) : 결혼은 제외
            } else {

                if( "${row.CONG_CODE }" == c_CONG_CODE && "${row.RELA_CODE }" == c_RELA_CODE
                    && c_RELA_CODE=="0001"   && c_CONG_CODE=="0001" ) { //결혼,본인인경우만 대상자명체크안함
                	<c:if  test="${ row.INFO_FLAG  eq  'I' }" >
                	  alert("<spring:message code='MSG.E.E19.0035' />"); //해당 경조내역에 이미 동명의 경조대상자가 있습니다.
                	  return false;
                   </c:if>
               		<c:if  test="${ row.INFO_FLAG  eq  'T' and  row.AINF_SEQN ne e19CongcondData.AINF_SEQN}" >
                		alert("<spring:message code='MSG.E.E19.0034' />"); //현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.
                		return false;
             		</c:if>


                }else if("${row.CONG_CODE }" == c_CONG_CODE && "${row.RELA_CODE }"  == c_RELA_CODE
                                                             && "${row.EREL_NAME }" == c_EREL_NAME ) {
                	<c:if  test="${ row.INFO_FLAG  eq  'I' }" >
              	  alert("<spring:message code='MSG.E.E19.0035' />"); //해당 경조내역에 이미 동명의 경조대상자가 있습니다.
              	  return false;
                 </c:if>
             		<c:if  test="${ row.INFO_FLAG  eq  'T'  and  row.AINF_SEQN ne e19CongcondData.AINF_SEQN}" >
              		alert("<spring:message code='MSG.E.E19.0034' />"); //현재 결재신청이 되어 있으므로 결재진행현황에서 확인하시기 바랍니다.
              	  return false;
           		</c:if>

                }
            }  //end if
          </c:forEach>
     } //end if ExceptDupCheck
//  2003.02.20 - 경조금 신청시 중복신청을 체크하는 로직 추가

//[CSR ID:3197606] 경조금 신청 관련  성명 길이제한을 주석처리함
//    //경조대상자 성명-10 입력시 길이 제한
//    x_obj = document.form1.EREL_NAME;
//    xx_value = x_obj.value;
//    if( checkLength(xx_value) > 10 ){
//        x_obj.value = limitKoText(xx_value, 10);
//        alert("경조대상자 성명은 한글 5자, 영문 10자 이내여야 합니다.");
//        x_obj.focus();
//        x_obj.select();
//        return false;
//    }
//[CSR ID:3197606] 경조금 신청 관련 주석처리 끝
//  if( checkNull(document.form1.CONG_DATE, "경조발생일자를") == false ) {
    if( checkNull(document.form1.CONG_DATE, "<spring:message code='MSG.E.E19.0058' />") == false ) {
      return false;
    }
    var disa = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
    <%--//C20140416_24713 화환은 부서계좌 입력 제거
    //if( disa == "0007" || disa == "0010"){  //돌반지,  화환일 경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함

    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    // 화환가 마찬가지로 쌀화환도 부서계좌번호를 입력하지 않아도 되도록 주석처리한다
        //    if(   disa == "0010"){  //돌반지,  화환일 경우 통상입금,지급율을 계산하지 않고 경조금액을 입력하도록함
<%//  if ("Y".equals(user.e_representative) ) {  // 부서서무 담당일때  %>
     //   if( checkNull(document.form1.LIFNR, "부서계좌번호를") == false ) {
      //    return false;
      //  }
<%//  }  %>
  //  }
    //은행 관련자료도 필수 항목이다
    //[CSR ID:2599072] 경조화환 신청시 계좌등록 사항 미적용 반영의 건
    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    // 화환과 같게 쌀화화도 수정--%>
    if(   disa != "0007" && disa != "0010"){
        if( document.form1.BANK_NAME.value == "" || document.form1.BANKN.value == "" ) {
          alert("<spring:message code='MSG.E.E19.0036' />"); //입금될 계좌정보가 명확하지 않습니다.\n\n  인사담당자에게 문의해 주세요
          return false;
        }
    }
    //은행 관련자료도 필수 항목이다


/*    if ( check_empNo() ){
        return false;
    }*/

    x_CONG_WONX = removeComma(document.form1.CONG_WONX.value);
    if( isNaN(x_CONG_WONX) ){
        alert(" <spring:message code='MSG.E.E19.0008' />"); //입력값이 적합하지 않습니다.
        document.form1.CONG_WONX.focus();
        return false;
    } else if( x_CONG_WONX == "0" && c_CONG_CODE != "0007"){
        alert(" <spring:message code='MSG.E.E19.0008' />"); //입력값이 적합하지 않습니다.
        document.form1.CONG_WONX.focus();
        return false;
    }else{
        document.form1.CONG_WONX.value = x_CONG_WONX;
        document.form1.WAGE_WONX.value = removeComma(document.form1.WAGE_WONX.value);
    }

//[CSR ID:3105340] 회갑 경조금 신청시 로직 추가 요청의 건 - 김불휘

    var begin_date = removePoint(document.form1.BEGDA.value);
    var congra_date = removePoint(document.form1.CONG_DATE.value);

    if(chkInvalidDate()==false){
        return false;
    }

<%--
    //경조사 발생 3개월초과시 에러처리
    //chkInvalidDate() 와 내용이 중복되므로 전부 주석 처리함
//    var begin_date = removePoint(document.form1.BEGDA.value);
//    var congra_date = removePoint(document.form1.CONG_DATE.value);
//
//    betw = getAfterMonth(addSlash(congra_date), 3);
//    dif = dayDiff(addSlash(begin_date), addSlash(betw));
//
//    betw2 = getAfterMonth(addSlash(begin_date), 1);
//    dif2 = dayDiff(addSlash(congra_date), addSlash(betw2));
//
//    dif3 = begin_date - congra_date;
//
//   var reg_no_v1 = "";
//    var limit_day_v1 = "";
//    var dif4 = "";
//
//    //[CSR ID:2748092] 박난이S 요청 경조금 신청 시 회갑의 경우 경조대상자 생일+3month 까지가 경조발생일자여야 하며 그걸 넘어서면 신청이 불가하도록 함.
//    if(c_CONG_CODE == "0002" ){
//      reg_no_v1 = getAfterMonth(addSlash("19"+document.form1.REGNO.value.substring(0,6)), 3);//경조대상자 회갑생일+3month
//      limit_day_v1 = getAfterYear(addSlash(reg_no_v1), 60);//60년 이후(올해) 신청기한날짜
//      dif4 = dayDiff(addSlash(congra_date), addSlash(limit_day_v1));//신청일~경조발생+3month 의 day수
//  }
//
//    if ( "<%= PERNR_Data.E_RECON %>" == "" ) {  // 퇴직자가 아닐때
//        //@v1.3
//        <%        if(!(PERNR_Data.E_PERNR.equals("00203430") ||PERNR_Data.E_PERNR.equals("00214482")) ){%>
//        if(  ("<%=Except3Month%>" != "Y") && dif < 0){
//            str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이후 3개월까지만 신청할 수 있습니다. ';
//            alert(str);
//            return false;
//        }
//        <%}%>
//        /*[CSR ID:2757077] 경조금 추가로직 삭제요청
//        else{
//          if(c_CONG_CODE == "0002" && "< %=Except3Month%>" != "Y" && dif4 < 0){
//              str = '        경조를 신청할수 없습니다.\n\n 관련 문의사항은 관할부서에 연락해주시기 바랍니다. ';//경조대상자 생일 기준 3개월 이전에 발생일자 넣으면 에러
//              alert(str);
//              return false;
//          }
//       }*/
//   } else {
//       var reday = "<%= PERNR_Data.E_REDAY %>";
//       betwR = getAfterMonth(addSlash(reday), 3);
//        difR  = dayDiff(addSlash(congra_date), betwR);
//        if(  "<%=Except3Month%>" != "Y" && difR < 0){
//            str = '        경조를 신청할수 없습니다.\n\n 퇴직일 이후 3개월까지만 신청할 수 있습니다. ';
//            alert(str);
//            return false;
//        }
//    }
//<%
//    if( user.companyCode.equals("C100") ) {
//%>
//    var disadif = document.form1.CONG_CODE[document.form1.CONG_CODE.selectedIndex].value;
//
//    dif9 = dayDiff(addSlash(congra_date), addSlash(begin_date)); //CSR ID:1225704
//
//
//
//    //if( "<%= PERNR_Data.E_RECON %>" != "D" && "<%= PERNR_Data.E_RECON %>" != "S" && disadif != "0007" && dif3 < 0 ){
//    if( "<%= PERNR_Data.E_RECON %>" != "D" && "<%= PERNR_Data.E_RECON %>" != "S" && disadif != "0007" && dif9 < -7 ){
//        str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이전에 신청할 수 없습니다. ';
//        alert(str);
//        return false;
//    }
//<%
//    } else {
//%>
//    if(dif2 < 0) {
//        str = '        경조를 신청할수 없습니다.\n\n 경조발생일 이전 1개월 내에 신청할 수 있습니다. ';
//        //str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
//        alert(str);
//        return false;
//    }
//<%
//    }
//%>
//////////////주석처리 끝
--%>

    // C20140416_24713 화환인경우
    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
    // 쌀화환도 화환과 같게 수정
    if ( c_CONG_CODE == "0007" || c_CONG_CODE == "0010"     ) {

        // C20140416_24713  배송정보 필수체크
        if( checkNull(document.form1.ZCELL_NUM, "<spring:message code='MSG.E.E19.0049' />") == false ) {
          return false;
        }
        if( checkNull(document.form1.ZCELL_NUM_R, "<spring:message code='MSG.E.E19.0050' />") == false ) {
          return false;
        }
        if( checkNull(document.form1.ZGRUP_NUMB_R, "<spring:message code='MSG.E.E19.0051' />") == false ) {
          return false;
        }
        if( checkNull(document.form1.ZTRANS_DATE, "<spring:message code='MSG.E.E19.0052' />") == false ) {
          return false;
        }
        if( checkNull(document.form1.ZTRANS_TIME, "<spring:message code='MSG.E.E19.0053' />") == false ) {
          return false;
        }
        if( checkNull(document.form1.ZTRANS_ADDR, "<spring:message code='MSG.E.E19.0054' />") == false ) {
          return false;
        }

        if(${flowerInfoSize} <1 ) {
            alert("<spring:message code='MSG.E.E19.0037' />"); //주문업체 정보가 없습니다. HR서비스팀에 문의하세요
            return false;
        }else{
            if( document.form1.ZTRANS_ZPHONE_NUM.value == "" ) {
                alert("<spring:message code='MSG.E.E19.0038' />"); //주문업체 핸드폰번호가 없습니다. HR서비스팀에 문의하세요
                return false;
            }
        }

    }
    // 경조발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다.
    event_CONG_DATE(document.form1.CONG_DATE);
    // 경조발생일자의 onBlur가 수행되지 않을수 있는 상황에서 근속년수를 다시 계산한다.

    document.form1.BEGDA.value = begin_date;
    document.form1.CONG_DATE.value = congra_date;
    document.form1.CONG_WONX.disabled = 0;//경조금액 활성화
    document.form1.RELA_CODE.disabled = 0;//경조대상자 관계 활성화
    document.form1.EREL_NAME.disabled = 0;//경조대상자성명 활성화
    document.form1.RELA_NAME.value=document.form1.RELA_CODE[document.form1.RELA_CODE.selectedIndex].text;   //20140416_24713

    return true;
}



                    </script>

                </tags:script>
<jsp:include page="${g.jsp }D/timepicker-include.jsp"/>

   <c:choose>

   <c:when  test="${ O_CHECK_FLAG  eq  'N'}" >
    <div class="align_center">
        <p><spring:message code='LABEL.E.E19.0019' /><!-- ※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다. --></p><!--@v1.1-->
        <!--  HIDDEN  처리해야할 부분 시작-->
        <input type="hidden" name = "reloadYN" value="Y">
        <input type="hidden" name="fromJsp"     value="E19CongraBuild.jsp">
        <input type="hidden" name="checkSubmit" value="">
        <input type="hidden" name="ESS_EXCPT_CHK" value="${essExcept }">
    </div>
   </c:when>
   <c:otherwise>
		<c:if  test="${PERNR_Data.e_RECON  eq 'Y'}" >
    		<div class="align_center">
        		<p><spring:message code='LABEL.E.E19.0020' /><!-- 퇴직자는 신청할 수 없습니다. --></p>
    		</div>
    	</c:if>
    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            	<colgroup>
            		<col width="15%" />
            		<col width="35%" />
            		<col />
            	</colgroup>
                <tr>
                  <td colspan="2" style="height: 30px;border-bottom: 0px" ></td>
                    <td rowspan="6" style="border-left:1px solid #ddd;">
                    <div class="innerComment" >
   				<c:choose>
               <c:when  test="${ isFlower  eq  'Y'}" >
							<p><strong><spring:message code='MSG.E.E19.0062' /></strong></p>
				            <p><strong><spring:message code='MSG.E.E19.0063' /></strong></p>
				             <ul>
				            <p><spring:message code='MSG.E.E19.0064' /></p>
				            <p><spring:message code='MSG.E.E19.0065' /></p>
				             <p>&nbsp;&nbsp;&nbsp;<spring:message code='MSG.E.E19.0066' /></p>
				            <p>&nbsp;&nbsp;&nbsp;<spring:message code='MSG.E.E19.0067' /></p>
				            <!--[CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건 start  -->
				            <p>&nbsp;&nbsp;&nbsp;<spring:message code='MSG.E.E19.0069' /></p><!-- 신청과 동시에 해당업체에 접수가 되므로 취소시에는 반드시 해당 업체에 전화하여 취소해야 함. -->
				            <!--[CSR ID:3568671] 경조화환 신청 메뉴 변경요청의 건 end  -->
				            </ul>
                 </c:when>
                 <c:otherwise>
							<p><strong><spring:message code='LABEL.E.E19.0021' /><!-- ※ 경조금 신청은 경조사 발생 7일 이전부터 이후 3개월까지 신청하고, 경조휴가는 경조일을 포함하여 연속해 사용하시기 바랍니다. --></strong></p>
				            <p><strong><spring:message code='LABEL.E.E19.0022' /><!-- ※ 회갑의 경우 경조대상자의 경조일자는 주민등록상 생일을 원칙으로 적용함. --></strong></p>
				            <p><strong><spring:message code='LABEL.E.E19.0023' /><!-- 경조금 지급기준 적용시 유의사항 --></strong></p>
				            <ul>
					            <li><spring:message code='LABEL.E.E19.0024' /><!-- 경조대상은 생부/생모를 원칙으로 하되, 생부/생모 대신 계부/계모를 지급대상자로 할 수 있음.(단, 동일 경조사유에 대해 1회 지원 원칙) --></li>
					            <li><spring:message code='LABEL.E.E19.0025' /><!-- 조부모상/백숙부모상(큰아버지,큰어머니,작은아버지,작은어머니)의 경우 친가에 한하여 지원하며, 외가에는 지원되지 않음. --></li>
					            <li><spring:message code='LABEL.E.E19.0026' /><!-- 재혼인 경우 본인에 한해서 가능함. --></li>
				            </ul>

                   </c:otherwise>
                   </c:choose>
                          </div>
				        <div class="buttonArea">
				            <ul class="btn_mdl">
				            	<li><a href="javascript:open_rule('Rule02Benefits06.html');"><span><spring:message code='LABEL.E.E19.0027' /><!-- 경조금 지원 기준 --></span></a></li>
				                <li><a href="javascript:openDocPOP()"><span><spring:message code='LABEL.E.E19.0028' /><!-- 경조대상자 등록 --></span></a></li>
				            </ul>
				        </div>
                    </td>
                </tr>
                <tr>
                    <th style="border-bottom: 1px solid #ffffff  ;border-right: 0px"><span class="textPink">*</span><spring:message code='LABEL.E.E20.0002' /><!-- 경조내역 --></th>
                    <td style="border-bottom: 0px">
                    <input type="hidden" name="BEGDA" value="${isUpdate? e19CongcondData.BEGDA : approvalHeader.RQDAT}">
                      <!-- [CSR ID:3568671] 경조화환 신청건 수정시 경조내역 타입은 수정불가 start -->
	                      <select id="CONG_CODE" name="CONG_CODE" onChange="javascript:change_CONG_CODE();"  disabled="">
	                  <!-- [CSR ID:3568671] 경조화환 신청건 수정시 경조내역 타입은 수정불가 end -->
	                        <option value="">----------------------</option>
	                          <!-- 경조내역 option @v1.2 , [CSR ID:2583929] 생산기술직 38 추가  -->
	                          <c:choose>
	                          <c:when test="${ !(PERNR_Data.e_PERSK eq '33' or PERNR_Data.e_PERSK eq '38')}">
	                           ${ f:printCodeOption( E19CongcondData0010_vt , e19CongcondData.CONG_CODE) }
	                           </c:when>
	                          <c:otherwise>
	                          ${ f:printCodeOption( E19CongcondData0020_vt , e19CongcondData.CONG_CODE) }
	                          </c:otherwise>
	                          </c:choose>
	                          <!-- 경조내역 option -->
	                      </select>
                    </td>
                 </tr>
				<tr>
                    <th style="border-bottom: 1px solid #ffffff ;border-right: 0px"><span class="textPink">*</span><spring:message code='LABEL.E.E20.0003' /><!-- 경조대상자 관계 --></th>
                    <td style="border-bottom: 0px">
                        <select name="RELA_CODE" onChange="javascript:rela_action(this);" >
                            <option value="">----------------------</option>
                            ${ f:printCodeOption( newOpt_rela , e19CongcondData.RELA_CODE) }
                        </select>
                    </td>
                </tr>
                <tr>
                    <th style="border-bottom: 1px solid #ffffff ;border-right: 0px"><span class="textPink">*</span><spring:message code='LABEL.E.E19.0029' /><!-- 경조대상자 성명 --></th>
                    <td style="border-bottom: 0px">
                        <input type="text" name="EREL_NAME" value="${e19CongcondData.EREL_NAME }" size="20" readonly style="ime-mode:active" >
                        <a href="javascript:fn_relaNmPOP();" class="inlineBtn unloading"><span><!-- 대상자 선택/등록 --><spring:message code="LABEL.E.E19.0060"/></span></a>
                    </td>
                </tr>
                <tr>
                    <th style="border-bottom: 1px solid #ffffff ;border-right: 0px"><span class="textPink">*</span><spring:message code='LABEL.E.E19.0030' /><!-- 경조발생일자 --></th>
                    <td style="border-bottom: 0px">
                        <input type="text" name="CONG_DATE"  class="date" value="${f:printDate(e19CongcondData.CONG_DATE) }" size="20" onChange="event_CONG_DATE(this);" >
                    </td>
                </tr>
                <tr><td colspan="2" style="height: 30px;"></td></tr>
            </table>
        </div>
      </div>
    <div class="tableArea" id="wage_0007">
        <div class="table">
            <table class="tableGeneral">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
	  <c:choose>
      <c:when  test="${ user.empNo  eq  PERNR_Data.e_PERNR}" >
                <tr>
                  <!--[CSR ID:2584987] 통상임금 -> 기준급  -->
                  <!-- <td width="100" class="td01">통상임금</td> -->
                  <th><spring:message code='LABEL.E.E20.0010' /><!-- 기준급 --></th>
                  <td><input type="text" name="WAGE_WONX" value="${empty e19CongcondData.WAGE_WONX? '': f:printNumFormat(e19CongcondData.WAGE_WONX,0)}" style="text-align:right" size="20" readonly><spring:message code='LABEL.E.E19.0009' /><!-- 원 --> </td>
                  <th class="th02"><spring:message code='LABEL.E.E20.0011' /><!-- 지급율 --></th>
                  <td><input type="hidden" name="xCONG_RATE" value="${e19CongcondData.CONG_RATE }" >
                    <input type="text" name="CONG_RATE" value="${e19CongcondData.CONG_RATE }" size="20" style="text-align:right" readonly>% </td>
                </tr>
                <tr>
                  <th><spring:message code='LABEL.E.E20.0006' /><!-- 경조금액 --></th>
                  <td colspan="3">
                    <input type="text" name="CONG_WONX" value="${empty e19CongcondData.CONG_WONX? '': f:printNumFormat(e19CongcondData.CONG_WONX,0)}" size="20" style="text-align:right"
                    onKeyUp="javascript:moneyChkEventForWon(this);" onBlur="javascript:chk_limit(this);" onFocus="this.select();" disabled><spring:message code='LABEL.E.E19.0009' /><!-- 원 --> </td>
                </tr>
                   <tr>
                  <th><spring:message code='LABEL.E.E20.0012' /><!-- 이체은행명 --></th>
                  <td colspan="3"> <input type="text" name="BANK_NAME" value="${e19CongcondData.BANK_NAME }" size="20" readonly></td>
                  </tr>
	</c:when>
	<c:otherwise>

                   <tr>
                  <th><spring:message code='LABEL.E.E20.0012' /><!-- 이체은행명 --></th>
                  <td colspan="3"> <input type="text" name="BANK_NAME" value="${e19CongcondData.BANK_NAME }" size="20" readonly>
                  <input type="hidden" name="WAGE_WONX" value="${empty e19CongcondData.WAGE_WONX? '' : f:printNumFormat(e19CongcondData.WAGE_WONX,0)}" style="text-align:right" size="20" class="input04" readonly>
                  <input type="hidden" name="xCONG_RATE" value="${e19CongcondData.CONG_RATE }" >
                  <input type="hidden" name="CONG_RATE" value="${e19CongcondData.CONG_RATE }" class="input04" size="20" style="text-align:right" readonly>
                  <input type="hidden" name="CONG_WONX" value="${e19CongcondData.CONG_WONX }" class="input04" size="20" style="text-align:right" readonly>
                  <input type="hidden" name="xCONG_WONX" value="${e19CongcondData.CONG_WONX }" >
                  </td></tr>
	</c:otherwise>
	</c:choose>


				<tr>
                  <th><spring:message code='LABEL.E.E20.0013' /><!-- 은행계좌번호 --></th>
                  <td colspan="3"><input type="text" name="BANKN" value="${e19CongcondData.BANKN }" size="20" readonly></td>
                </tr>
                <tr>
                  <th><spring:message code='LABEL.E.E20.0014' /><!-- 경조휴가일수 --></th>
                  <td>
                    <input type="text" name="HOLI_TEXT" value="${empty e19CongcondData.HOLI_CONT ? '' : f:printNum(e19CongcondData.HOLI_CONT)}"  size="20" style="text-align:right" readonly>
                    <input type="text" name="HOLI_TEXT1" value="${empty e19CongcondData.HOLI_CONT ? '' : '일'}"  size="20" style="text-align:left;border:0;background-color:#FFFFFF" readonly>
                    <input type="hidden" name="HOLI_CONT" value="${empty e19CongcondData.HOLI_CONT ? '' : f:printNum(e19CongcondData.HOLI_CONT)}"  size="10" style="text-align:right" readonly>
                  </td>
                  <th class="th02"><spring:message code='LABEL.E.E20.0015' /><!-- 근속년수 --></th>
                  <td><input type="text" name="WORK_YEAR" value="${empty e19CongcondData.WORK_YEAR ? '' : f:printNum(e19CongcondData.WORK_YEAR)}"   size="7" style="text-align:right" readonly>
                    <spring:message code='LABEL.E.E20.0017' /><!-- 년 -->
                    <input type="text" name="WORK_MNTH" value="${empty e19CongcondData.WORK_MNTH? '' : f:printNum(e19CongcondData.WORK_MNTH)}"  size="8" style="text-align:right" readonly>
                    <spring:message code='LABEL.E.E20.0018' /><!-- 개월 --></td>
                </tr>
                <tr id="bubank">
                  <th><span class="textPink">*</span><spring:message code='LABEL.E.E19.0031' /><!-- 부서계좌번호 --></th>
                  <td colspan="3">
                    <!-- @v1.1 -->
                    <input type="text" name="DEPT_NAME" value="" size="16" style="ime-mode:active">
                    &nbsp;<a href="javascript:deptbank_search()">
                    <img src="${g.image}sshr/ico_magnify.png" alt="부서계좌검색">
                    </a>&nbsp;
                    <select name="LIFNR" onChange="javascript:view_Lifnr(this);">
                      <option value="">-------------------</option>
  	<c:forEach var="row" items="${E19CongLifnrByEname_vt}" varStatus="status">
  			<option value="${row.LIFNR}" "${row.LIFNR eq e19CongcondData.LIFNR? 'selected' : '' }">${row.LIFNR }${row.NAME1}(${row.BVTXT })</option>
	</c:forEach>
        </select>
                  </td>
                </tr>
            </table>
            <span class="commentOne"><spring:message code='MSG.COMMON.0061' /><!-- <span class="textPink">*</span>는 필수 입력사항입니다. --></span>
        </div>
    </div>

    <!--C20140416_24713 주문업체 정보  START-->

<div  id="jumunINFO">
    <h2 class="subtitle"><spring:message code='LABEL.E.E19.0032' /><!-- 주문자 정보 --></h2>

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
              <th><spring:message code='LABEL.E.E19.0033' /><!-- 신청자 --></th>
              <td>${ user.ename }</td>
              <th class="th02"><spring:message code='LABEL.E.E19.0034' /><!-- 근무지명 --></th>
              <td>${isUpdate?ZGRUP_NUMB_O_NM : loginData.e_BTEXT}
            <input type="hidden" name="ZPERNR2"   value="${isUpdate?e19CongcondData.ZPERNR2 : user.empNo}"> <!-- 신청자사번 -->
            <input type="hidden" name="ZUNAME2"   value="${isUpdate?e19CongcondData.ZUNAME2 : user.ename}"> <!-- 신청자사번 -->
            <input type="hidden" name="ZGRUP_NUMB_O"   value="${ isUpdate?e19CongcondData.ZGRUP_NUMB_O : user.e_grup_numb}"><!-- 신청자근무지코드 -->

              </td>
            </tr>
            <tr>
              <th><spring:message code='LABEL.E.E18.0030' /><!-- 전화번호 --></th>
              <td><input type="text" name="ZPHONE_NUM" value="${isUpdate?e19CongcondData.ZPHONE_NUM : user.e_phone_num }"  size="20" maxsize=20 style="text-align:left"></td>
              <th class="th02"><span class="textPink">*</span><spring:message code='LABEL.E.E19.0035' /><!-- 핸드폰 --></th>
              <td><input type="text" name="ZCELL_NUM" value="${isUpdate? e19CongcondData.ZCELL_NUM : user.e_cell_phone }"  size="20" maxsize=20 style="text-align:left"></td>
            </tr>
          </table>
          <span class="commentOne"><spring:message code='MSG.COMMON.0061' /><!-- <span class="textPink">*</span>는 필수 입력사항입니다. --></span>
        </div>
    </div>

    <h2 class="subtitle"><spring:message code='LABEL.E.E19.0036' /><!-- 배송정보 --></h2>
    <input type="hidden" name="ZUNAME_R"   value="${isUpdate?e19CongcondData.ZUNAME_R : PERNR_Data.e_ENAME }"><!-- 대상자(직원명) -->
    <input type="hidden" name="ZUNION_FLAG"   value="${isUpdate? e19CongcondData.ZUNION_FLAG : '' }"><!-- 대상자(조합원) -->

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
                  <th><spring:message code='LABEL.E.E19.0037' /><!-- 대상자(직원명) --></th>
                  <td>${ PERNR_Data.e_ENAME}</td>
                  <th class="th02"><span class="textPink">*</span><spring:message code='LABEL.E.E19.0038' /><!-- 대상자 연락처 --></th>
                  <td><input type="text" name="ZCELL_NUM_R" value="${isUpdate?e19CongcondData.ZCELL_NUM_R : PERNR_Data.e_CELL_PHONE}" size="20" maxsize=20 style="text-align:left"></td>
                </tr>
                <tr>
                  <th><span class="textPink">*</span><spring:message code='LABEL.E.E19.0039' /><!-- 근무지 --></th>
                  <td>
                        <select name="ZGRUP_NUMB_R">
                         <option value="">-------------</option>
                        ${isUpdate? f:printCodeOption( newOpt, e19CongcondData.ZGRUP_NUMB_R  ) : f:printCodeOption( newOpt, PERNR_Data.e_GRUP_NUMB ) }
                        </select>
                  </td>
                  <th class="th02"><spring:message code='LABEL.E.E19.0040' /><!-- 대상자 부서 --></th>
                  <td>${ PERNR_Data.e_ORGTX }</td>
                </tr>

                <tr>
                  <th><span class="textPink">*</span><spring:message code='LABEL.E.E19.0041' /><!-- 배송일자 --></th>
                  <td colspan=3>
                    <input type="text" name="ZTRANS_DATE" size="10"  value="${isUpdate? f:printDate(e19CongcondData.ZTRANS_DATE) : f:printDate(f:currentDate())}" onBlur="javascript:on_Blur(this);" class="date">
                           시간 : <input type="text" name="ZTRANS_TIME" class="time required" size="10"  value="${isUpdate? f:printTime(e19CongcondData.ZTRANS_TIME ) :  '00:00'}"  readonly>
                  </td>
                </tr>
                <tr>
                  <!-- [CSR ID:2597246] 자동세팅되던 배송지주소 삭제 "${PERNR_Data.e_STRAS}" -->
                  <th><span class="textPink">*</span><spring:message code='LABEL.E.E19.0042' /><!-- 배송지주소 --></th>
                  <td colspan=3><input type="text" name="ZTRANS_ADDR" value="${e19CongcondData.ZTRANS_ADDR }" size="80"  maxsize="100" style="text-align:left"></td>
                </tr>
                <tr>
                  <th><spring:message code='LABEL.E.E19.0043' /><!-- 기타 요구사항 --></th>
                  <td colspan=3><input type="text" name="ZTRANS_ETC" value="${e19CongcondData.ZTRANS_ETC }" size="80" maxsize="100"  style="text-align:left"></td>
                </tr>
            </table>
            <span class="commentOne"><spring:message code='MSG.COMMON.0061' /><!-- <span class="textPink">*</span>는 필수 입력사항입니다. --></span>
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
    <%--<c:if test="${status.index eq '0' }"> --%>

    <tr>
                  <th><spring:message code='LABEL.E.E19.0045' /><!-- 업체명 --></th>
                  <td>${row.ZTRANS_NAME}</td>
                  <th class="th02"><spring:message code='LABEL.E.E20.0025' /><!-- 주소 --></th>
                  <td>${row.ZTRANS_ADDR}</td>
                </tr>
    <!-- [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
          for문 밖에 있던 <tr>을 for문 안쪽으로 수정
      -->
                <tr>
                  <th><spring:message code='LABEL.E.E19.0046' /><!-- 담당자 --></th>
                  <td>${row.ZTRANS_UNAME}</td>
                  <th class="th02"><spring:message code='LABEL.E.E26.0005' /><!-- 연락처 --></th>
                  <td>T e l : ${row.ZPHONE_NUM}
                  <BR>H .P : ${row.ZCELL_NUM}
                 <input type="hidden" name="ZTRANS_SEQ"   value="${isUpdate? e19CongcondData.ZTRANS_SEQ : row.ZTRANS_SEQ}"><!--업체 SEQ-->
                 <input type="hidden" name="ZTRANS_PSEQ"   value="${isUpdate? e19CongcondData.ZTRANS_PSEQ : row.ZTRANS_PSEQ}"><!--담당자 SEQ-->
                 <input type="hidden" name="ZTRANS_ZPHONE_NUM"   value="${row.ZPHONE_NUM}"><!--담당자 PHONE_NUM-->
                   </td>
                </tr>
     <%--</c:if> --%>
     </c:forEach>

            </table>

        </div>
    </div>
  </div>

    <!-- C20140416_24713 주문업체정보 END -->
           <!--  HIDDEN  처리해야할 부분 시작-->
            <input type="hidden" name="fromJsp"     value="E19CongraBuild.jsp">
            <input type="hidden" name="checkSubmit" value="">
            <input type="hidden" name="AccountData_pers_RowCount" value="${AccountData_pers_rowCount}">

   <c:forEach var="row" items="${AccountData_pers_vt}" varStatus="status">
      <input type="hidden" name="p_LIFNR${status.index}" value="${row.LIFNR}">
      <input type="hidden" name="p_BANKN${status.index}" value="${row.BANKN}">
      <input type="hidden" name="p_BANKA${status.index}" value="${row.BANKA}">
      <input type="hidden" name="p_BANKL${status.index}" value="${row.BANKL}">
</c:forEach>

    <!--  HIDDEN  처리해야할 부분 끝-->

   </c:otherwise>
  </c:choose>

      <input type="hidden" name = "p_BANKN"  value="">
      <input type="hidden" name = "p_SWITCH" value="1">
      <input type="hidden" name = "P_PERNR" value="${e19CongcondData.PERNR }">
      <input type="hidden" name = "p_BANKN_SEARCHGUBN"  value="">
      <input type="hidden" name = "REGNO"   value="${e19CongcondData.REGNO}">
      <input type="hidden" name="LNMHG" value=""><!--대상자姓:가족목록팝업에서선택한대상자의성 -->
      <input type="hidden" name="PER_LNMHG" value="${fn:substring(PERNR_Data.e_ENAME,6,7)}"><!--신청자성-->
	<!-- [CSR ID:3189675] 경조금 회갑 예외신청 개선  -->
	<input type="hidden" name="EXCEP"   value="">
    <input type="hidden" name="RELA_NAME"   value="">


   </tags-approval:request-layout>
  <form name="form3" method="post">
      <input type="hidden" name = "CONG_DATE" value="">
      <!--@v1.9-->
      <input type="hidden" name = "CONG_CODE" value="">
      <input type="hidden" name = "RELA_CODE" value="">
      <!--@v1.9-->
      <input type="hidden" name = "PERNR" value="${e19CongcondData.PERNR}">
  </form>

  <!--@v1.9-->
  <form name="family" method="post">
      <input type="hidden" name = "PERNR" value="">
      <input type="hidden" name = "OBJ"   value="">
      <input type="hidden" name = "CONG_CODE" value="">
      <input type="hidden" name = "RELA_CODE"   value="">
      <input type="hidden" name = "PersonData"   value="${PERNR_Data}">
  </form>
  <!--@v1.9-->

  <form name="test" method="post">
      <input type="hidden" name = "user" value="${user.empNo}">
      <input type="hidden" name = "user" value="${user.e_persk}">
      <input type="hidden" name = "E_ENAME" value="${PERNR_Data.e_ENAME}">
      <input type="hidden" name = "E_PERSK" value="${PERNR_Data.e_PERSK}">
      <input type="hidden" name = "reload" value="Y">
  </form>

</tags:layout>

<iframe name="ifHidden" width="0" height="0" /></iframe>

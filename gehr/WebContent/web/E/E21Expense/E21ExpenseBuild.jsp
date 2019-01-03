<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 장학자금 신청                                               */
/*   Program ID   : E21ExpenseBuild.jsp                                         */
/*   Description  : 학자금/장학금 신청할 수 있도록 하는 화면                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-01  윤정현                                          */
/*                  2005-12-13  @v1.1 lsa C2005121201000000126                  */
/*                  2006-01-04  @v1.2 lsa C2006010401000000276 장학자금 신청화면에서 신청년도 1월만 2005년도 신청처리 */
/*                  2006-11-30  @v1.3 lsa 예외처리                              */
/*                  2008-09-01  @v1.4 lsa acad_학금 추가분은 1회신청 제어 year 학년체크로직추가            */
/*                  2011-10-31  ※CSR ID:C20111025_86242 EB00, EC00 는 해외 현지지급으로 신청에서 제외함 */
/*                  2013-01-18  [CSR ID:2261367] 예외자  초등생 학자금 신청 가능하게  */
/*                  2013-09-23  [CSR ID:@999] 동일학년, 동일분기에 기 신규분으로 지원을 받은 경우에만 추가분 신청가능  */
/*                  2014-05-19 CSRID : 2545905 이지은D 시간선택제 (사무직(4H), 사무직(6H), 계약직(4H), 계약직(6H)) 중 계약직의 경우 신청 불가, 단 예외자의 경우 가능 */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/*                   2014-10-16  @v.1.10 SJY 신청유형:장학금인 경우에만 시스템 수정   [CSR ID:2634836] 학자금 신청 시스템 개발 요청                                          */
/*                  2015-07-31  이지은D [CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청 */
/*                  2016-05-19  이지은D [CSR ID:3059290] HR제도 팝업 관련 개선 요청의 건  */
/*                  2017-04-03  김은하C [CSR ID:3393142] 학자금 신청 관련 로직 수정요청의 건  */
/*                  2018-01-11 rdcamel  [CSR ID:3578534] 의료비 및 학자금 신청에 대한 일시 조치 요청   */
/* 				 2018-01-11  cykim   [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>

<%@ page import="hris.common.PersonData" %>

<%
    Vector A04FamilyDetailData_vt = (Vector)request.getAttribute("A04FamilyDetailData_vt");
    //Vector    = (Vector)request.getAttribute("E21ExpenseChkData_vt");
    //Vector E22ExpenseListData_vt  = (Vector)request.getAttribute("E22ExpenseListData_vt");
    Vector E22ExpenseListDataFull_vt  = (Vector)request.getAttribute("E22ExpenseListDataFull_vt");
    String msgFLAG                = (String)request.getAttribute("msgFLAG");
    String msgTEXT                = (String)request.getAttribute("msgTEXT");
    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");

    // @v1.1장학자금 예외자 CHECK - FLAG 가 'X'는 예외자로 장학자금신청되도록 함. -2004.09.06
    String eflag = (String)request.getAttribute("eflag");// except_rfc.getExceptFLAG( PERNR, "" );

    String PERNR = (String)request.getAttribute("PERNR");
    String      CompanyCoupleYN = (String)request.getAttribute("CompanyCoupleYN");    //[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청

    //  현재년도 기준으로 일년전부터, 일년후까지 (2년간)
    int i_date = Integer.parseInt( DataUtil.getCurrentDate().substring(0,4) );
    int basic_date = Integer.parseInt(DataUtil.getCurrentDate());

    Vector CodeEntity_vt = new Vector();
    for( int i = i_date - 1 ; i <= i_date  ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    //[CSR ID:2261367]
    String[] exC1_Numb = {"00213366"}; //장학자금 초등생 예외자사번
    String exC1_FLAG=""; //장학자금 초등생 예외여부
    for ( int i=0; i< 1 ;i++) {

        if ( PERNR.equals(exC1_Numb[i]) ) {
           exC1_FLAG="X";
        }
    }

    String    Msg = "";
    if (( PERNR_Data.E_WERKS.equals("EC00") || PERNR_Data.E_WERKS.equals("EB00") )&&   !eflag.equals("X") ) {  // 2005.04.13 수정 - 해외법인(EC00)일 경우는 본인신청, 대리신청 못하도록 함.
        Msg = g.getMessage("MSG.E.E05.0004");//"해외법인의 경우 해당 인사부서를 통해 신청하시기 바랍니다.";
        msgFLAG = "N";
    }else if (( PERNR_Data.E_PERSK.equals("36") ||  PERNR_Data.E_PERSK.equals("37") )&&  !eflag.equals("X") ) { //CSRID :2545905 시간선택제 계약직의 경우 신청 불가
        Msg = g.getMessage("MSG.E.E22.0018");//"시간선택제 계약직의 경우 장학자금 신청이 불가합니다.";
        msgFLAG = "N";
    }

    String reqDisable = ""; //신청 불가 상태 확인.
    String ESS_EXCPT_CHK = "00044527"; // [CSR ID:3578534] 삭제예정
    if ( !msgFLAG.equals("") &&  !ESS_EXCPT_CHK.equals("00044527") ){ //[CSR ID:3578534] 수정예정
    	reqDisable = "true";
    }

%>
<!-- [CSR ID:3578534]임시로 사번으로 대체 이후에는 servlet 에서 request에 담아 YN으로 체크함.-->
<c:set var="ESS_EXCPT_CHK" value="00044527X"/>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="CompanyCoupleYN" value="<%=CompanyCoupleYN %>" />
<c:set var="Msg" value="<%=Msg %>" />
<c:set var="msgFLAG" value="<%=msgFLAG %>" />
<c:set var="exC1_FLAG" value="<%=exC1_FLAG %>" />
<c:set var="i_date" value="<%=i_date %>" />
<c:set var="basic_date" value="<%=basic_date %>" />
<c:set var="CodeEntity_vt" value="<%=CodeEntity_vt %>" />
<c:set var="reqDisable" value="<%=reqDisable %>" />
<c:set var="E_OVERSEA" value="<%=PERNR_Data.E_OVERSEA %>" />
<c:set var="E_WERKS" value="<%=PERNR_Data.E_WERKS %>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_TUTI_FEE" disable="${reqDisable}">
	<tags:script>
	<script>

	//자녀당 수혜횟수 계산해오는 함수
	function set_CNT(){
	    var count = document.form1.Row_Count.value;
	    var type1 = document.form1.ACAD_CARE.value;
	    subtype = document.form1.SUBF_TYPE[document.form1.SUBF_TYPE.selectedIndex].value;

	    if(count=="" || type1=="" || subtype==""){
	        document.form1.P_COUNT.value = "" ;
	        return;
	    }

	    simp_type = null;
	    if( type1 == "D1"){
	        simp_type = "중";
	    } else if( type1 == "E1" ){
	        simp_type = "고";
	    } else if( type1 == "F1" || type1 == "G1" || type1 == "G2" || type1 == "H1" ){
	        simp_type = "대";
	    } else{
	        simp_type = "";
	    }

		//  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
		// 해외근무자 또는 [CSR ID:2261367]:예외자인경우([CSR ID:2261367]:)
		<c:if test="${(E_OVERSEA eq 'X' ) || exC1_FLAG eq 'X' }">
	    if( type1 == "B1" || type1 == "C1" ){
	        simp_type = "중";
	    }
		</c:if>

	    if(subtype=="2"){ // 학자금일때
	        var P_COUNT = 0;
	        for( var i = 0 ; i < count ; i++ ){
	            subty = eval("document.form1.subty"+i+".value");
	            objps = eval("document.form1.objps"+i+".value");
	            grade = eval("document.form1.grade"+i+".value");
	            if( subty == document.form1.SUBTY.value && objps == document.form1.OBJC_CODE.value
	                                                    && (grade == "중")   ) {
	                P_COUNT = P_COUNT + Number(eval("document.form1.count"+i+".value"));
	            }
	            if( subty == document.form1.SUBTY.value && objps == document.form1.OBJC_CODE.value
	                                                    && ( grade == "고") ) {
	                P_COUNT = P_COUNT + Number(eval("document.form1.count"+i+".value"));
	            }

	        }
	        document.form1.P_COUNT.value = P_COUNT;
	        return;

	    }else if(subtype=="3" && simp_type=="대"){ // 장학금일때
	        var P_COUNT = 0;
	        for( var i = 0 ; i < count ; i++ ){
	            subty = eval("document.form1.subty"+i+".value");
	            objps = eval("document.form1.objps"+i+".value");
	            grade = eval("document.form1.grade"+i+".value");

	            if( subty == document.form1.SUBTY.value && objps == document.form1.OBJC_CODE.value
	                                                    && grade == simp_type ) {
	                P_COUNT = Number(eval("document.form1.count"+i+".value"));
	            }
	        }
	        document.form1.P_COUNT.value = P_COUNT;
	        return;

	    }else{
	        document.form1.P_COUNT.value = "" ;
	        return;
	    }

	    document.form1.P_COUNT.value = "" ; //해당사항없을경우 공백 세팅
	    return;
	}

	function change_type(obj){
	    if( !chk_logic() ){
	        obj[0].selected=true;
	    }else{
	        set_CNT();
	    }

	//  2002.10.18. 분기일경우 보여줌.
	    var val = obj.value;     //신청유형

	//  리스트를 모두 비운다.
	    for( var i = 4 ; i >= 1 ; i-- ) {
	        document.form1.selType.remove(i);
	    }

	    document.form1.selType.options[0] = new Option("------", "", "");

	    if( val == "2" ) {            //학자금
	        for( var i = 1 ; i <= 4 ; i++ ) {
	            document.form1.selType.options[i] = new Option(i+"분기", i, i);
	        }
	        /* [CSR ID:3569058] 신청유형:장학금인 경우에만 학과필드 display */
	        $("#FRTXT").hide();
	    } else if( val == "3" ) {     //장학금
	        for( var i = 1 ; i <= 3 ; i++ ) {
	            document.form1.selType.options[i] = new Option(i+"학기", i, i);
	        }
	        /* [CSR ID:3569058] 신청유형:장학금인 경우에만 학과필드 display */
	        $("#FRTXT").show();
	    }

	    //신청유형:장학금인 경우에만 시스템 수정 START
	    change_typeChk(val);
	    //신청유형:장학금인 경우에만 시스템 수정 END

	}

	function chk_logic(){
	    var inx = document.form1.SUBF_TYPE[document.form1.SUBF_TYPE.selectedIndex].value;
	    var type1 = document.form1.ACAD_CARE.value;

	//  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.

	// 해외근무자
	<c:choose>
		<c:when test="${E_OVERSEA eq 'X' }">

		if(inx=="2" && type1!="" && type1!="B1" && type1!="C1" && type1!="D1" && type1!="E1" ){                     // 학자금은 중.고등학생만..
			alert("<spring:message code='MSG.E.E22.0001' />"); // alert("학자금신청은 유치원, 초.중.고등학생만 가능합니다.\n\n 가족사항을 확인하세요.");
	        return false;
	    }else if(inx=="3" && type1!="" && type1!="F1" && type1!="G1" && type1!="G2"){ // 장학금은 대학생만..
	    	alert("<spring:message code='MSG.E.E22.0002' />"); //alert("장학금신청은 대학생만 가능합니다.\n\n 가족사항을 확인하세요.");
	        return false;
	    }else{
	        return true;
	    }

		</c:when>

		<c:otherwise>
		if(inx=="2" && type1!="" && type1!="D1" && type1!="E1" ){    // 학자금은 중.고등학생만..
	        if("${exC1_FLAG}"=="X" &&  type1 =="C1" ){   // [CSR ID:2261367]:학자금은 예외자인경우 초등학생가능
	            return true;
	        }else  if(inx=="2" && type1!="" && type1!="D1" && type1!="E1"  ){ // 학자금은 중.고등학생만..
	        	alert("<spring:message code='MSG.E.E22.0003' />"); // alert("학자금신청은 중.고등학생만 가능합니다.\n\n 가족사항을 확인하세요.");
	            return false;
	        }

	    }else if(inx=="3" && type1!="" && type1!="F1" && type1!="G1" && type1!="G2"){ // 장학금은 대학생만..
	    	alert("<spring:message code='MSG.E.E22.0002' />");  //alert("장학금신청은 대학생만 가능합니다.\n\n 가족사항을 확인하세요.");
	        return false;
	    }else{
	        return true;
	    }
		</c:otherwise>
	</c:choose>

	}

	function on_changed(obj){
	    inx = obj[obj.selectedIndex].value;
	    if(inx==""){
	      document.form1.SUBTY.value     = "";
	      document.form1.OBJC_CODE.value = "";
	      document.form1.LNMHG.value     = "";
	      document.form1.FNMHG.value     = "";
	      document.form1.ACAD_CARE.value = "";
	      document.form1.STEXT.value     = "";
	      document.form1.FASIN.value     = "";
	      return;
	    }

	    eval("document.form1.SUBTY.value     = document.form1.SUBTY_FA"+inx+".value;");   //가족유형
	    eval("document.form1.OBJC_CODE.value = document.form1.OBJPS_FA"+inx+".value;");   //하부유형
	    eval("document.form1.LNMHG.value     = document.form1.LNMHG"+inx+".value;");      //성 (한글)
	    eval("document.form1.FNMHG.value     = document.form1.FNMHG"+inx+".value;");      //이름 (한글)
	    eval("document.form1.ACAD_CARE.value = document.form1.FASAR"+inx+".value;");      //학력
	    eval("document.form1.STEXT.value     = document.form1.STEXT1"+inx+".value;");     //학교유형텍스트
	    eval("document.form1.FASIN.value     = document.form1.FASIN"+inx+".value;");      //교육기관

	     //신청유형:장학금인 경우에만 시스템 수정 START
	    type1 = document.form1.ACAD_CARE.value;
	    if(type1 == "F1" || type1 == "G1" || type1 == "G2" || type1 == "H1"){ //대학교는 교육기관을표시안함
	        document.form1.FASIN.value     = "";
	    }
	    //신청유형:장학금인 경우에만 시스템 수정 END

	    if( !chk_logic() ){
	        obj[0].selected=true;
	        document.form1.SUBTY.value     = "";
	        document.form1.OBJC_CODE.value = "";
	        document.form1.LNMHG.value     = "";
	        document.form1.FNMHG.value     = "";
	        document.form1.ACAD_CARE.value = "";
	        document.form1.STEXT.value     = "";
	        document.form1.FASIN.value     = "";
	        return;
	    }

	    set_CNT(); //수혜횟수 뿌려주기
	}

	function beforeSubmit() {
	//function do_submit() {
	    if( check_data() ) {
	    	return true;

	    }
	}

	function check_data(){
		var validText = "" ;
	    if(document.form1.SUBF_TYPE.selectedIndex==0){
	    	validText = "<spring:message code='LABEL.E.E22.0039' />";
           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("신청유형을 선택하세요");
	        document.form1.SUBF_TYPE.focus();
	        return false;
	    }

	    command ="" ;
	    size ="" ;
	    if( isNaN( document.form1.radiobutton.length ) ){
	      size = 1;
	    } else {
	      size = document.form1.radiobutton.length;
	    }
	    for (var i = 0; i < size ; i++) {
	        if ( size == 1 ){
	            command = 0;
	        } else if ( document.form1.radiobutton[i].checked == true ) {
	            command = document.form1.radiobutton[i].value;
	        }
	    }
	    if( command == "신규분" ) {
	        document.form1.PAY1_TYPE.value ="X";
	        document.form1.PAY2_TYPE.value ="";
	    }else if( command == "추가분" ){
	        document.form1.PAY1_TYPE.value ="";
	        document.form1.PAY2_TYPE.value ="X";
	    }else{
	        alert("지급구분을 선택하세요");
	        return false;
	    }

	//  2002.10.18. 신청년도, 신청분기ㆍ학기 선택
	    if(document.form1.selType.selectedIndex==0){
	    	validText = "<spring:message code='LABEL.E.E22.0025' />";
           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("신청분기ㆍ학기를 선택하세요");
	        document.form1.selType.focus();
	        return false;
	    }

	//  기입력된 년도-분기ㆍ학기가 있는지 체크하고 있으면 신청을 막는다.    /////////////////
	    if( command == "신규분" ) {
	        if( document.form1.SUBF_TYPE.value == "2") {              //학자금 - 분기

				<c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
				<c:set var="index" value="${inx.index}"/>

	            if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) &&  //@v1.4
	                ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
	                ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
	                ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
	                ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
	                ("${row.PERD_TYPE}" == document.form1.selType.value) ) {

	            	alert("<spring:message code='MSG.E.E22.0004' />"); // alert("해당 분기에 이미 지급 받았거나  신청중인 건이 있습니다.");
	                return false;
	            }

            	</c:forEach>

	            document.form1.PERD_TYPE.value = document.form1.selType.value;
	        } else if( document.form1.SUBF_TYPE.value == "3") {       //장학금 - 학기

	        	<c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
				<c:set var="index" value="${inx.index}"/>

				 if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) && //@v1.4
                        ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
                        ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
                        ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
                        ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
                        ("${row.HALF_TYPE}" == document.form1.selType.value) ) {
                        //alert("현재 학기에 이미 지급 받았습니다");
                        alert("<spring:message code='MSG.E.E22.0005' />"); // alert("해당 학기에 이미 지급 받았거나  신청중인 건이 있습니다.");
                        return false;
                    }
				</c:forEach>

	            document.form1.HALF_TYPE.value = document.form1.selType.value;
	        }
	    }
	/////////////////////////////////////////////////////////////////////////////////////
	    var PRE_count =0;
	    var PRE_NEW_count =0;   //동일분기,동일학기의 신규분 신청건수

	    // 장학금 추가분" 신청은 1회까지로 제한  C20101022_59637
	    if( command == "추가분" ) {
	        if( document.form1.SUBF_TYPE.value == "2") {              //학자금 - 분기
	            document.form1.PERD_TYPE.value = document.form1.selType.value;
	            //@999  학자금 동일분기,동일학기 신규분 신청내역건수 확인

	        	<c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
				<c:set var="index" value="${inx.index}"/>
				 if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) &&  //@v1.4
                        ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
                        ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
                        ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
                        ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
                        ("${row.PERD_TYPE}" == document.form1.selType.value)   &&
                        ("${row.PAY1_TYPE}" == "X") ) {
                        PRE_NEW_count++;
	                    }
				</c:forEach>

	        } else if( document.form1.SUBF_TYPE.value == "3") {       //장학금 - 학기
	            document.form1.HALF_TYPE.value = document.form1.selType.value;

	        	<c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
				<c:set var="index" value="${inx.index}"/>

				if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) && //@v1.4
                        ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
                        ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
                        ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
                        ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
                        ("${row.HALF_TYPE}" == document.form1.selType.value) &&
                        ("${row.PAY2_TYPE}" == "X") ) {
                        PRE_count++;
                    }
				</c:forEach>

	    	//@999  장학금

	        <c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
			<c:set var="index" value="${inx.index}"/>

			if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) && //@v1.4
                    ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
                    ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
                    ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
                    ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
                    ("${row.HALF_TYPE}" == document.form1.selType.value) &&
                    ("${row.PAY1_TYPE}" == "X") ) {
                    PRE_NEW_count++;
                }
			</c:forEach>


	        }
	    //@999  장학금
	    if ( PRE_NEW_count < 1 ) {
	    	alert("<spring:message code='MSG.E.E22.0006' />"); // alert("장학자금 추가분은 신규분 신청된건에 대하여만 신청 가능합니다.!\n동일학년 동일분기 신규분을 먼저 신청하세요");
	        return false;
	    }
	    }
		// [CSR ID:3393142] 학자금 신청 관련 로직 수정요청의 건 2017/04/03 by eunha  start
	   /* if ( PRE_count>= 1 ) {
	    	alert("<spring:message code='MSG.E.E22.0007' />"); // alert("장학금 추가분은 1회만 신청 가능합니다.!");
	        return false;
	    }*/
	   // [CSR ID:3393142] 학자금 신청 관련 로직 수정요청의 건 2017/04/03 by eunha  end
	    if(document.form1.full_name.selectedIndex==0){
	    	validText = "<spring:message code='LABEL.E.E22.0017' />";
           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("자녀 이름을 선택하세요");
	        document.form1.full_name.focus();
	        return false;
	    }

	//  학자금 수혜한도(중학=>12, 고교=>12) 장학금 수혜한도(8회), 입학금수혜한도(1회)
	    rowcount = document.form1.Row_Count.value;
	    type1 = document.form1.ACAD_CARE.value;

	//  R3 에 학력에 관한 데이타가 없음을 경고...
	    if( type1=="" ){
	    	alert("<spring:message code='MSG.E.E22.0008' />"); // alert("시스템에 해당자녀에 대한 학력정보가 없습니다. \n\n 먼저 R/3 Data를 확인해 주세요");
	        return false;
	    }
	//  R3 에 학력에 관한 데이타가 없음을 경고...

	    simp_type = null;
	    if( type1 == "D1" ) {
	        simp_type = "중";
	    } else if( type1 == "E1" ) {
	        simp_type = "고";
	    } else if( type1 == "F1" || type1 == "G1" || type1 == "G2" || type1 == "H1" ) {
	        simp_type = "대";
	    } else {
	        simp_type = "";
	    }

	    //[CSR ID:1611012]
	    if(document.form1.FASIN.value==""){

	        //신청유형:장학금인 경우에만 시스템 수정 START
	        var val = document.getElementsByName("SUBF_TYPE")[0].value;
	        if(val == "3"){
	            if(document.getElementsByName("ABRSCHOOL")[0].checked == true){
	            	validText = "<spring:message code='LABEL.E.E22.0027' />";
	               	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("교육기관을 입력하세요.");
	                document.form1.FASIN.focus();
	            }else{
	            	validText = "<spring:message code='LABEL.E.E22.0027' />";
	               	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("교육기관을 선택하세요.");
	                document.form1.SEARCH_ACAD.focus();
	            }
	        }else{
	        	alert("<spring:message code='MSG.E.E22.0009' />"); //  alert("교육기관이 입력되어 있지 않습니다.\n인사정보-개인사항-가족사항에서 학력,교육기관 수정 후 신청하시기 바랍니다.!");
	             document.form1.FASIN.focus();
	        }
	        //신청유형:장학금인 경우에만 시스템 수정 END


	        return false;
	    }

	// 학년입력을 필수로 변경.2003.07.02.mkbae.
	    if(document.form1.ACAD_YEAR.value==""){
	    	validText = "<spring:message code='LABEL.E.E22.0029' />";
           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("학년을 입력하세요");
	        document.form1.ACAD_YEAR.focus();
	        return false;
	    }

		//[CSR ID:3569058] 학과입력 필수 체크
	    if(document.form1.FRTXT.value==""){
	    	//신청유형:장학금인 경우에만 시스템 수정 START
	        var val = document.getElementsByName("SUBF_TYPE")[0].value;
	        if(val == "3"){
		    	validText = "<spring:message code='LABEL.E.E22.0047' />";
	           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("학과를 입력하세요");
		        document.form1.FRTXT.focus();
	        	return false;
	        }
	    }

	 //  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
	 // 해외근무자
		<c:if test="${(E_OVERSEA eq 'X' ) || (exC1_FLAG eq 'X') }">

	    if( type1 == "B1" || type1 == "C1" ){
	        simp_type = "중";
	    }
	    </c:if>

	    grade = "";
	    count = "";
	    enter = "";

	    for( var i = 0 ; i < rowcount ; i++ ){
	        subty = eval("document.form1.subty"+i+".value");
	        objps = eval("document.form1.objps"+i+".value");
	        grade = eval("document.form1.grade"+i+".value");

	        if( subty == document.form1.SUBTY.value && objps == document.form1.OBJC_CODE.value
	                                                && grade == simp_type ){
	            count = eval("document.form1.count"+i+".value");
	            enter = eval("document.form1.enter"+i+".value");
	        }
	    }

	    if( command == "신규분" ) { //============================================================
	        if( Number(enter) >= 1 && document.form1.ENTR_FIAG.checked ){
	        	alert("<spring:message code='MSG.E.E22.0010' />"); //  alert("입학금은 1회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
	            return false;
//	        }else if( ( simp_type == "중" || simp_type == "고" ) && Number(count) >= 24 ){
//	            alert("학자금은 24회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
//	            return false;
	        }else if( ( simp_type == "중"  ) && Number(count) >= 12 ){
	        	alert("<spring:message code='MSG.E.E22.0011' />"); // alert("중학 학자금은 12회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
	            return false;
	        }else if( ( simp_type == "고"  ) && Number(count) >= 12 ){
	        	alert("<spring:message code='MSG.E.E22.0012' />"); // alert("고등 학자금은 12회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
	            return false;
	        }else if( simp_type == "대" && Number(count) >= 8 ){
	        	alert("<spring:message code='MSG.E.E22.0013' />"); // alert("대학 장학금은 8회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
	            return false;
	        }
//	      학자금 수혜한도(24) 장학금 수혜한도(8회), 입학금수혜한도(1회)
	    } //============================================================

	    if( checkNull(document.form1.PROP_AMNT,"신청액을") == false ) {
	      return false;
	    }
	//  금액포멧 다시 확인
	    if( ! usableChar(document.form1.PROP_AMNT,'0123456789,.') ){
	        document.form1.PROP_AMNT.focus();
	        document.form1.PROP_AMNT.select();
	        return false;
	    }

	    //[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청
	    if( "Y"=="${CompanyCoupleYN}") {
	    	alert("<spring:message code='MSG.E.E22.0014' />"); // alert("사내배우자가 있습니다.\n\n학자금은 중복지원이 불가하오니 기신청내역여부 확인바랍니다.");
	    }

	    if( !chk_logic() ){
	        document.form1.SUBF_TYPE[0].selected=true;
	        return false;
	    }

	    document.form1.BEGDA.value = removePoint(document.form1.BEGDA.value);
	    document.form1.PROP_AMNT.value = removeComma(document.form1.PROP_AMNT.value);
	    return true;
	}

	function MM_openBrWindow(theURL,winName,features) { // v2.0
	    window.open(theURL,winName,features);
	}

	// 통화키가 변경되었을경우 금액을 재 설정해준다.
	function moneyChkReSetting() {
	    moneyChkForLGchemR3(document.form1.PROP_AMNT,'WAERS');
	    moneyChkForLGchemR3_onBlur(document.form1.PROP_AMNT, 'WAERS');
	}

	//신청유형:장학금인 경우에만 시스템 수정 START

	function EnterAcademyPop(){
	     if (event.keyCode == 13)  {
	            pop_academy();
	    }
	}

	/*대학교 검색 팝업*/
	function pop_academy(){
	    var val = document.getElementsByName("SUBF_TYPE")[0].value;
	    if(val != "3"){
	    	alert("<spring:message code='MSG.E.E22.0015' />"); // alert("신청유형이 장학금일때만 검색할수 있습니다.");
	        return;
	    }

	    if(document.form1.SEARCH_ACAD.value == ""){
	    	alert("<spring:message code='MSG.E.E22.0016' />"); // alert("○○대학교에서 “○○”을 입력하세요");
	        document.form1.SEARCH_ACAD.focus();
	        return;
	    }

	    small_window=window.open("","AcademyPop","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");
	    small_window.focus();

	    document.form1.target = "AcademyPop";
	    document.form1.action = "${g.jsp}common/SearchSchoolsPopWait.jsp";
	    document.form1.submit();

	}

	//신청유형에 따른 화면 컨트롤
	function change_typeChk(val){
	    if(val == "3"){
	         document.getElementById("TYPE_3").style.display="block";
	         document.getElementById("TYPE_3_1").style.display="";
	         document.getElementById("ABRSCHOOL").checked = false;
	         document.getElementById("SCHCODE").style.display="inline-block";
	         document.getElementById("ACAD_TYPE1").style.display="block";
	         document.getElementsByName("FASIN")[0].className = "noBorder";
	         document.getElementsByName("FASIN")[0].readOnly = true;
	        change_student();
	    }else{
	        document.getElementById("ABRSCHOOL").checked = false;
	        document.getElementById("TYPE_3").style.display="none";
	        document.getElementById("TYPE_3_1").style.display="none";
	        document.getElementById("SCHCODE").style.display="none";
	        document.getElementById("ACAD_TYPE1").style.display="none";
	        document.getElementsByName("FASIN")[0].className = "noBorder";
	        document.getElementsByName("FASIN")[0].readOnly = true;
	    }
	}

	/*유학 학자금 체크여부에 따른 화면 컨트롤*/
	function change_student(){
	    if(document.getElementsByName("ABRSCHOOL")[0].checked==true){
	        document.getElementById("ACAD_TYPE1").style.display="none";
	        document.getElementsByName("FASIN")[0].readOnly = false;
	        document.getElementById("SCHCODE").style.display="none";
	        document.getElementsByName("FASIN")[0].className = "";
	        document.form1.FASIN.value="";
	        document.form1.SCHCODE.value="";
	    }else{
	        document.getElementById("ACAD_TYPE1").style.display="block";
	        document.getElementsByName("FASIN")[0].readOnly = true;
	        document.getElementById("SCHCODE").style.display="inline-block";
	        document.getElementsByName("FASIN")[0].className = "noBorder";
	        document.form1.FASIN.value="";
	        document.form1.SCHCODE.value="";
	    }
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
                	<c:when test="${msgFLAG eq 'N' and ESS_EXCPT_CHK != '00044527' }"><!-- [CSR ID:3578534] 수정예정 -->
					<tr>
		                <td align="center" colspan="4">
		                   <br/>${Msg}<br/><br/>
		                </td>
	                </tr>
                	</c:when>
                	<c:when test="${msgFLAG eq 'C' and ESS_EXCPT_CHK != '00044527' }"><!-- [CSR ID:3578534] 수정예정 -->
					<tr>
		                <td align="center" colspan="4">
		                   <br/>${msgTEXT}<br/><br/>
		                </td>
	                </tr>
                	</c:when>
                	<c:otherwise>

                	<tr>
                		<th><span class="textPink">*</span><!-- 가족선택 --><spring:message code="LABEL.E.E22.0038" /></th>
                		<td colspan="2">
                			<input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}"  />
                			<input type="text" name="FAMSA" value="2" size="5" readonly />
                          	<input type="text" name="ATEXT" value="자녀" size="10" readonly />
                		</td>
                		<td>
	                        <a class="inlineBtn" href="javascript:open_rule('Rule02Benefits05.html');" style="float: right"><span><!-- 장학자금 지원 기준 --><spring:message code="LABEL.E.E22.0043" /></span></a>
	                    </td>
                	</tr>

                	<tr>
                		<th><span class="textPink">*</span><!-- 신청유형 --><spring:message code="LABEL.E.E22.0039" /></th>
                		<td>
                			<select name="SUBF_TYPE" style="width:135px;" onChange="javascript:change_type(this);">
                            <option>-------------</option>
                            <option value="2"><!-- 학자금 --><spring:message code="LABEL.E.E22.0040" /></option>
                            <option value="3"><!-- 장학금 --><spring:message code="LABEL.E.E22.0041" /></option>
                          	</select>
                		</td>
                		<th class="th02"><span class="textPink">*</span><!-- 신청년도 --><spring:message code="LABEL.E.E22.0024" /></th>
                		<td>
               				<input type="text" name="PROP_YEAR" class="noBorder" value="${i_date}" size="5" readonly> 년
                		</td>
                	</tr>

                	<tr>
                        <th><span class="textPink">*</span><!-- 신청구분 --><spring:message code="LABEL.E.E22.0042" /></th>
                        <td>
                          <input type="radio" name="radiobutton" value="신규분" checked>
                          	<!-- 신규분 --><spring:message code="LABEL.E.E22.0022" />
                          <input type="radio" name="radiobutton" value="추가분">
                          	<!-- 추가분 --><spring:message code="LABEL.E.E22.0023" />
                        </td>
                        <th class="th02"><span class="textPink">*</span><!-- 신청분기ㆍ학기 --><spring:message code="LABEL.E.E22.0025" /></th>
                        <td>
                            <select name="selType" style="width:135px;">
                            <option>-----------</option>
                            </select>
                         </td>
                     </tr>

                     <tr>
                         <th><span class="textPink">*</span><!-- 이름 --><spring:message code="LABEL.E.E22.0017" /></th>
                         <td colspan="3">
                         	<select name="full_name" style="width:135px;" onChange="javascript:on_changed(this)">
                         	<option>-------------</option>

                         	<c:forEach var="row" items="${A04FamilyDetailData_vt}" varStatus="inx">
                         	<c:set var="index" value="${inx.index}"/>

                         	<option value ="${index}" ><c:out value='${fn:trim(row.LNMHG)}'/> <c:out value='${fn:trim(row.FNMHG)}'/></option> <!-- 데이터 확인 index 및 trim -->

							</c:forEach>

                          	</select>
                          </td>
                      </tr>
                      <tr>
                		  <th><span class="textPink">*</span><!-- 학력 --><spring:message code="LABEL.E.E22.0026" /></th>
                		  <td colspan="3">
                		  	  <input type="text" name="ACAD_CARE" value="" size="5" readonly />
                          	  <input type="text" name="STEXT" value="" size="22" readonly />
                		  </td>
               		  </tr>

               		  <tr>
                		  <th><span class="textPink">*</span><!-- 교육기관 --><spring:message code="LABEL.E.E22.0027" /></th>
                		  <td>
                		  	  <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                              <span id="ACAD_TYPE1" style="display:none;">
                              <input type="text" name="SEARCH_ACAD" value="" size="31" style="ime-mode:active;" onKeyDown = "javascript:EnterAcademyPop();">
                              <a href="javascript:pop_academy();"> <img src="/web/images/btn_serch.gif"  align="absmiddle" border="0" alt="교육기관 검색"></a></span>
                              <input type="text" id="SCHCODE" name="SCHCODE" value="" size="9" readonly style="display:none">
                              <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                              <input type="text" name="FASIN" value=""  size="31" readonly>
                		  </td>
                		  <th  class="th02"><span class="textPink">*</span><!-- 학년 --><spring:message code="LABEL.E.E22.0029" /></th>
                		  <td>
                		  	  <input type="text" name="ACAD_YEAR" value="" onBlur="javascript:usableChar(this,'1234567890');" style="text-align:center" size="10" maxlength="1">
                		  	  <!-- 학년 --><spring:message code="LABEL.E.E22.0029" />
                		  </td>
               		  </tr>
					  <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 start -->
					  <tr id="FRTXT" style="display:none;">
	                      <th><span class="textPink">*</span><!-- 학과 --><spring:message code="LABEL.E.E22.0047" /></th>
	                      <td colspan="3">
		               	  		<input type="text" name="FRTXT" value="${resultData.FRTXT}" style="text-align:left" size="31"/> ${resultData.FRTXT}
	                      </td>
	                  </tr>
					  <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 end -->
               		  <tr>
                          <th><span class="textPink">*</span><!-- 신청액 --><spring:message code="LABEL.E.E22.0018" /></th>
                          <td>
                          <input type="text" name="PROP_AMNT" value="" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS');" style="text-align:right" size="20">
	                          <select name="WAERS" onChange="javascript:moneyChkReSetting();">
	                            <!-- 통화키 가져오기-->
	                            ${f:printCodeOption(currencyCodeList, "KRW")}
	                            <!-- 통화키 가져오기-->
	                          </select>
                          </td>
                          <th class="th02"><!-- 수혜횟수 --><spring:message code="LABEL.E.E22.0030" /></th>
                          <td>
                          	  <input type="text" name="P_COUNT" value="" style="text-align:center" size="10" readonly> <!-- 회 --><spring:message code="LABEL.E.E22.0037" />
                          </td>
                      </tr>

                      <tr>
                          <th><!-- 입학금 --><spring:message code="LABEL.E.E22.0028" /></th>
                          <td>
                          	  <input type="checkbox" name="ENTR_FIAG" value="X" size="20">
                          </td>

                          <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
                          <th  class="th02" ><div  id="TYPE_3" style="display:none;"><!-- 유학 학자금 --><spring:message code="LABEL.E.E22.0031" /></div> </th>
                          <td>
                          	  <div id="TYPE_3_1" style="display:none;" >
                          	  <input type="checkbox" name="ABRSCHOOL" id="ABRSCHOOL" value="X" size="20" onClick="javascript:change_student();">
                          	  </div>
                          </td>
                        <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                      </tr>

					</c:otherwise>
               	</c:choose>
			</table>
		</div><!-- end class="table" -->


		<c:if test="${msgFLAG eq '' }">
		<div class="commentsMoreThan2">
        	<div><!-- 추가분은 등록금 인상시 선택하여 신청함 --><spring:message code="LABEL.E.E22.0044" /></div>
        	<div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
        </div>
		</c:if>
		<!-- 상단 입력 테이블 끝-->

	<c:forEach var="row" items="${A04FamilyDetailData_vt}" varStatus="inx">
	<c:set var="index" value="${inx.index}"/>
    <input type="hidden" name="SUBTY_FA${index}"  value="${row.SUBTY}">
    <input type="hidden" name="OBJPS_FA${index}"  value="${row.OBJPS}">
    <input type="hidden" name="LNMHG${index}"     value="${row.LNMHG}">
    <input type="hidden" name="FNMHG${index}"     value="${row.FNMHG}">
    <input type="hidden" name="FASAR${index}"     value="${row.FASAR}">
    <input type="hidden" name="STEXT1${index}"    value="${row.STEXT1}">
    <input type="hidden" name="FASIN${index}"     value="${row.FASIN}">
    </c:forEach>


	<c:forEach var="row" items="${E21ExpenseChkData_vt}" varStatus="inx">
	<c:set var="index" value="${inx.index}"/>
    <input type="hidden" name="subty${index}" value="${row.subty}">
    <input type="hidden" name="objps${index}" value="${row.objps}">
    <input type="hidden" name="grade${index}" value="${row.grade}">
    <input type="hidden" name="count${index}" value="${row.count}">
    <input type="hidden" name="enter${index}" value="${row.enter}">
	</c:forEach>


	<input type="hidden" name="Row_Count" value="${fn:length(E21ExpenseChkData_vt)}">

	<!-- Hidden Field -->
    <input type="hidden" name="SUBTY"     value="">    <!-- 가족유형 -->
    <input type="hidden" name="OBJC_CODE" value="">    <!-- 하부유형 -->
    <input type="hidden" name="LNMHG"     value="">    <!-- 성(이름) -->
    <input type="hidden" name="FNMHG"     value="">    <!-- 이름 -->
    <input type="hidden" name="PAY1_TYPE" value="">
    <input type="hidden" name="PAY2_TYPE" value="">
    <input type="hidden" name="PERD_TYPE" value="">    <!-- 분기 -->
    <input type="hidden" name="HALF_TYPE" value="">    <!-- 반기 -->

<!-- Hidden Field -->
	</div>

</tags-approval:request-layout>
</tags:layout>




<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 장학자금 수정                                               */
/*   Program ID   : E21ExpenseChange.jsp                                        */
/*   Description  : 학자금/장학금 수정할 수 있도록 하는 화면                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-01  윤정현                                          */
/*                  2006-01-04  @v1.2 lsa C2006010401000000276 장학자금 신청화면에서 신청년도 1월만 2005년도 신청처리 */
/*                  2008-09-01  @v1.4 lsa acad_year 학년체크로직추가            */
/*                  2013-09-23  [CSR ID:@999] 동일학년, 동일분기에 기 신규분으로 지원을 받은 경우에만 추가분 신청가능  */
/*					 2014-10-24  @v.1.5 SJY 신청유형:장학금인 경우에만 시스템 수정 		[CSR ID:2634836] 학자금 신청 시스템 개발 요청										*/
/*                  2015-07-31  이지은D [CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청 */
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

<%@ page import="hris.common.PersonData" %>
<%@ page import="hris.E.E21Expense.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");

    E21ExpenseData e21ExpenseData         = (E21ExpenseData)request.getAttribute("e21ExpenseData");
    Vector         E21ExpenseChkData_vt   = (Vector)request.getAttribute("E21ExpenseChkData_vt");
    Vector         E22ExpenseListData_vt  = (Vector)request.getAttribute("E22ExpenseListData_vt");
    Vector         E22ExpenseListDataFull_vt  = (Vector)request.getAttribute("E22ExpenseListDataFull_vt");
    //Vector         A04FamilyDetailData_vt = (Vector)request.getAttribute("A04FamilyDetailData_vt");
    String      CompanyCoupleYN           = (String)request.getAttribute("CompanyCoupleYN");	//[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청
    String         subty                  = (String)request.getAttribute("subty");
    String         objps                  = (String)request.getAttribute("objps");
    String         subf_type              = (String)request.getAttribute("subf_type");
    String         selType                = "";

    String PERNR = (String)e21ExpenseData.PERNR;

    PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");
    String RequestPageName = (String)request.getAttribute("RequestPageName");

    long print_count = 0;
    for ( int i = 0 ; i < E21ExpenseChkData_vt.size() ; i++ ) {
        E21ExpenseChkData data = (E21ExpenseChkData)E21ExpenseChkData_vt.get(i);

        if( subty.equals(data.subty) && objps.equals(data.objps) && subf_type.equals(data.subf_type) ) {
            if( data.count == null || (data.count != null && data.count.equals("")) ) {
                print_count = 0;
            } else {
                print_count = Long.parseLong(data.count);
            }
        }
    }

    //  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e21ExpenseData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
    //  통화키에 따른 소수자리수를 가져온다

    //  현재년도 기준으로 일년전부터, 일년후까지 (2년간)
    int i_date          = Integer.parseInt( DataUtil.getCurrentDate().substring(0,4) );

    Vector CodeEntity_vt = new Vector();
    for( int i = i_date - 1 ; i <= i_date  ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    //  신청유형을 체크하여 신청분기ㆍ학기를 설정해준다.
    Vector CodeEntityType_vt = new Vector();
    if( e21ExpenseData.SUBF_TYPE.equals("2") ) {          //학자금
        // 분기 - CodeEntity구성하기
        for( int i = 1 ; i <= 4 ; i++ ){
            CodeEntity entity = new CodeEntity();
            entity.code  = Integer.toString(i);
            entity.value = Integer.toString(i) + "분기";
            CodeEntityType_vt.addElement(entity);
        }

        selType = e21ExpenseData.PERD_TYPE;
    } else if( e21ExpenseData.SUBF_TYPE.equals("3") ) {   //장학금
        // 학기 - CodeEntity구성하기
        for( int i = 1 ; i <= 3 ; i++ ){
            CodeEntity entity = new CodeEntity();
            entity.code  = Integer.toString(i);
            entity.value = Integer.toString(i) + "학기";
            CodeEntityType_vt.addElement(entity);
        }

        selType = e21ExpenseData.HALF_TYPE;
    }
   // out.println("d:"+E22ExpenseListDataFull_vt.toString());
%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="currencyValue" value="<%=currencyValue%>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="CompanyCoupleYN" value="<%=CompanyCoupleYN %>" />
<c:set var="i_date" value="<%=i_date %>" />
<c:set var="CodeEntityType_vt" value="<%=CodeEntityType_vt %>" />
<c:set var="selType" value="<%=selType %>" />
<c:set var="print_count" value="<%=print_count %>" />
<c:set var="E_OVERSEA" value="<%=PERNR_Data.E_OVERSEA %>" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css"  >
	<tags-approval:request-layout  titlePrefix="COMMON.MENU.ESS_BE_TUTI_FEE">
	<tags:script>
		<script>

		<!--

		jQuery(function(){
			on_Load();
		});

		//자녀당 수혜횟수 계산해오는 함수
		function set_CNT(){
		    var count = document.form1.Row_Count.value;
		    var type1 = document.form1.ACAD_CARE.value;
		    var subtype = document.form1.SUBF_TYPE[document.form1.SUBF_TYPE.selectedIndex].value;

		    if(count=="" || type1=="" || subtype==""){
		        document.form1.P_COUNT.value = "" ;
		        return;
		    }

		    var simp_type = null;
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
		<c:if test="${E_OVERSEA eq 'X'}">
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
		            //if( subty == document.form1.SUBTY.value && objps == document.form1.OBJC_CODE.value
		            //                                        && (grade == "중" || grade == "고") ) {
		            //    P_COUNT = P_COUNT + Number(eval("document.form1.count"+i+".value"));
		            //}
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

		//
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

		     //v.1.5
		     change_typeChk(val, false);
		}

		function chk_logic(){
		    inx = document.form1.SUBF_TYPE[document.form1.SUBF_TYPE.selectedIndex].value;
		    type1 = document.form1.ACAD_CARE.value;

		//  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
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

		    eval("document.form1.SUBTY.value     = document.form1.SUBTY_FA"+inx+".value;"); //가족유형
		    eval("document.form1.OBJC_CODE.value = document.form1.OBJPS_FA"+inx+".value;"); //하부유형
		    eval("document.form1.LNMHG.value     = document.form1.LNMHG"+inx+".value;"); //성 (한글)
		    eval("document.form1.FNMHG.value     = document.form1.FNMHG"+inx+".value;"); //이름 (한글)
		    eval("document.form1.ACAD_CARE.value = document.form1.FASAR"+inx+".value;"); //학력
		    eval("document.form1.STEXT.value     = document.form1.STEXT1"+inx+".value;"); //학교유형텍스트
		    eval("document.form1.FASIN.value     = document.form1.FASIN"+inx+".value;"); //교육기관

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
		//function do_change() {
		    if( check_data() ) {
		    	return true;

		    }
		}

		function check_data(){
		    if(document.form1.SUBF_TYPE.selectedIndex==0){
		    	validText = "<spring:message code='LABEL.E.E22.0039' />";
	           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("신청유형을 선택하세요");
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
		    if( command =="신규분" ) {
		        document.form1.PAY1_TYPE.value ="X";
		        document.form1.PAY2_TYPE.value ="";
		    }else if( command =="추가분" ){
		        document.form1.PAY1_TYPE.value ="";
		        document.form1.PAY2_TYPE.value ="X";
		    }else{
		        alert("지급구분을 선택하세요");
		        return false;
		    }

		//  2002.10.18. 신청년도, 신청분기ㆍ학기 선택
		    if(document.form1.selType.selectedIndex==0){
		    	validText = "<spring:message code='LABEL.E.E22.0025' />";
	           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("신청분기ㆍ학기를 선택하세요");
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
		                ("${row.PERD_TYPE}" == document.form1.selType.value) &&
		                ("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}" )  &&
		                ("${row.PAY1_TYPE}" == "X") ) {

		            	alert("<spring:message code='MSG.E.E22.0004' />"); // alert("현재 분기에 이미 지급 받았거나 신청중입니다.");
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
	                        ("${row.HALF_TYPE}" == document.form1.selType.value) &&
			                ("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}" )  &&
			                ("${row.PAY1_TYPE}" == "X") ) {

	                        alert("<spring:message code='MSG.E.E22.0005' />"); // alert("해당 학기에 이미 지급 받았거나  신청중인 건이 있습니다.");
	                        return false;
	                    }
					</c:forEach>

		            document.form1.HALF_TYPE.value = document.form1.selType.value;
		        }
		    }
		////////////////////////////////////////////////////////////////
		    var PRE_count =0;

		    var PRE_NEW_count =0;	//@999 동일분기,동일학기의 신규분 신청건수

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
                        ("${row.PAY1_TYPE}" == "X") &&
    		       		("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}") ) {
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
	                        ("${row.PAY2_TYPE}" == "X") &&
	    		       		("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}") ) {
	                        PRE_count++;
	                    }
					</c:forEach>

			//@999  장학금 동일분기,동일학기 신규분 신청내역확인

					<c:forEach var="row" items="${E22ExpenseListDataFull_vt}" varStatus="inx">
					<c:set var="index" value="${inx.index}"/>

					if( ("${row.ACAD_YEAR}" == document.form1.ACAD_YEAR.value) && //@v1.4
		                    ("${row.SUBF_TYPE}" == document.form1.SUBF_TYPE.value) &&
		                    ("${row.FAMSA}" == document.form1.SUBTY.value)     &&
		                    ("${row.OBJC_CODE}" == document.form1.OBJC_CODE.value) &&
		                    ("${row.PROP_YEAR}" == document.form1.PROP_YEAR.value) &&
		                    ("${row.HALF_TYPE}" == document.form1.selType.value) &&
		                    ("${row.PAY1_TYPE}" == "X") &&
	    		       		("${row.AINF_SEQN}" != "${resultData.AINF_SEQN}") ) {
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

		    if ( PRE_count>= 1 ) {
		    	alert("<spring:message code='MSG.E.E22.0007' />"); // alert("장학금 추가분은 1회만 신청 가능합니다.!");
		        return false;
		    }
		    if(document.form1.full_name.selectedIndex==0){
		    	validText = "<spring:message code='LABEL.E.E22.0017' />";
	           	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); // alert("자녀 이름을 선택하세요");
		        document.form1.full_name.focus();
		        return false;
		    }

		//학자금 수혜한도(중학=>12, 고교=>12) 학자금 수혜한도(8회), 입학금수혜한도(1회)
		    rowcount = document.form1.Row_Count.value;
		    type1 = document.form1.ACAD_CARE.value;
		//R3 에 학력에 관한 데이타가 없음을 경고...
		    if( type1=="" ){
		    	alert("<spring:message code='MSG.E.E22.0008' />"); // alert("시스템에 해당자녀에 대한 학력정보가 없습니다. \n\n 먼저 R/3 Data를 확인해 주세요");
		        return false;
		    }
		//R3 에 학력에 관한 데이타가 없음을 경고...

		    var subtype = document.form1.SUBF_TYPE[document.form1.SUBF_TYPE.selectedIndex].value;
		    /* if(subtype==""){
		        alert("지급유형을 선택해 주세요");
		        document.form1.SUBF_TYPE.focus();
		        return false;
		    }*/

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

			//  2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게 풀어준다.
			<c:if test="${E_OVERSEA eq 'X'}">
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
		        	alert("<spring:message code='MSG.E.E22.0010' />"); //alert("입학금은 1회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
		            return false;
		//        }else if( (simp_type == "중" || simp_type == "고") && Number(count) >= 24 ){
		//            alert("학자금은 24회에 한해 수혜받을수 있습니다.\n\n 더이상 신청할 수 없습니다.");
		//            return false;
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
		//      학자금 수혜한도(24) 장학금 수혜한도(8회), 입학금수혜한도(1회)

		//      ---------------------------------------------------------------------------------------
		//      2002.07.15. 학자금은 1,2,3,4분기별 1회만 신청가능
		//                 장학금은 1(1월~6월),2(7월~12월)분기별 1회만 신청가능
		//      신청일자로 분기를 찾는다.
		        begda_chk = removePoint(document.form1.BEGDA.value);

		        if( document.form1.SUBF_TYPE.value == "2" ) {            // 학자금
		            if( begda_chk.substring(4, 8) >= "0101" && begda_chk.substring(4, 8) <= "0331" ) {           // 1분기
		                date_fr = begda_chk.substring(0, 4) + "0101";
		                date_to = begda_chk.substring(0, 4) + "0331";
		            } else if( begda_chk.substring(4, 8) >= "0401" && begda_chk.substring(4, 8) <= "0630" ) {    // 2분기
		                date_fr = begda_chk.substring(0, 4) + "0401";
		                date_to = begda_chk.substring(0, 4) + "0630";
		            } else if( begda_chk.substring(4, 8) >= "0701" && begda_chk.substring(4, 8) <= "0930" ) {    // 3분기
		                date_fr = begda_chk.substring(0, 4) + "0701";
		                date_to = begda_chk.substring(0, 4) + "0930";
		            } else if( begda_chk.substring(4, 8) >= "1001" && begda_chk.substring(4, 8) <= "1231" ) {    // 4분기
		                date_fr = begda_chk.substring(0, 4) + "1001";
		                date_to = begda_chk.substring(0, 4) + "1231";
		            }
		        } else if( document.form1.SUBF_TYPE.value == "3" ) {       // 장학금
		            if( begda_chk.substring(4, 8) >= "0101" && begda_chk.substring(4, 8) <= "0630" ) {           // 1분기, 2분기
		                date_fr = begda_chk.substring(0, 4) + "0101";
		                date_to = begda_chk.substring(0, 4) + "0630";
		            } else if( begda_chk.substring(4, 8) >= "0701" && begda_chk.substring(4, 8) <= "1231" ) {    // 3분기, 4분기
		                date_fr = begda_chk.substring(0, 4) + "0701";
		                date_to = begda_chk.substring(0, 4) + "1231";
		            }
		        }


		//      ---------------------------------------------------------------------------------------
		    } //============================================================
		    //[CSR ID:1611012]
		    if(document.form1.FASIN.value==""){
		       //신청유형:장학금인 경우에만 시스템 수정 START
		    	var val = document.getElementsByName("SUBF_TYPE")[0].value;
				if(val == "3"){
					if(document.getElementsByName("ABRSCHOOL")[0].checked == true){
						validText = "<spring:message code='LABEL.E.E22.0039' />";
		               	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("교육기관을 입력하세요.");
						document.form1.FASIN.focus();
						return false;
					}else{
						validText = "<spring:message code='LABEL.E.E22.0039' />";
		               	alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />"); //alert("교육기관을 선택하세요.");
						document.form1.SEARCH_ACAD.focus();
						return false;
					}
				}else{
					 alert("<spring:message code='MSG.E.E22.0009' />"); //  alert("교육기관이 입력되어 있지 않습니다.\n인사정보-개인사항-가족사항에서 학력,교육기관 수정 후 신청하시기 바랍니다.!");
					 document.form1.FASIN.focus();
					 return false;
				}
		        //신청유형:장학금인 경우에만 시스템 수정 END
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

		    if( checkNull(document.form1.PROP_AMNT,"신청액을") == false ) {
		      return false;
		    }

		//금액포멧 다시 확인
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
		// 통화키가 변경되었을경우 금액을 재 설정해준다.

		/*
		*	v.1.5 START
		*/

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

		function on_Load(){
			change_typeChk("${resultData.SUBF_TYPE}", true);
		}

		//신청유형에 따른 화면 컨트롤
		function change_typeChk(val, initFlag){
			//alert("val="+val);

			if(val == "3"){
		    	 document.getElementById("TYPE_3").style.display="";
		         document.getElementById("TYPE_3_1").style.display="";
		         /* [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 */
		         document.getElementById("FRTXT").style.display="";

		         document.getElementById("SCHCODE").style.display="inline-block";
		         document.getElementById("ACAD_TYPE1").style.display="block";
		         document.getElementsByName("FASIN")[0].className = "noBorder";
		         document.getElementsByName("FASIN")[0].readOnly = true;
			    change_student(initFlag);

		    }else{
		    	document.getElementById("TYPE_3").style.display="none";
		        document.getElementById("TYPE_3_1").style.display="none";
		        /* [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 */
		         document.getElementById("FRTXT").style.display="none";

		        document.getElementById("SCHCODE").style.display="none";
		        document.getElementById("ACAD_TYPE1").style.display="none";
		        document.getElementsByName("FASIN")[0].className = "noBorder";
				document.getElementsByName("FASIN")[0].readOnly = true;
		    }

		     if(!initFlag){
			    	document.getElementById("ABRSCHOOL").checked = false;
			 }
		}

		/*유학 학자금 체크여부에 따른 화면 컨트롤*/
		function change_student(initFlag){
			if(document.getElementsByName("ABRSCHOOL")[0].checked==true){
				document.getElementById("ACAD_TYPE1").style.display="none";
				document.getElementsByName("FASIN")[0].readOnly = false;
				document.getElementById("SCHCODE").style.display="none";
				document.getElementsByName("FASIN")[0].className = "";
				if(!initFlag){
					document.form1.FASIN.value="";
					document.form1.SCHCODE.value="";
				}
			}else{
				document.getElementById("ACAD_TYPE1").style.display="block";
				document.getElementsByName("FASIN")[0].readOnly = true;
				document.getElementById("SCHCODE").style.display="inline-block";
				document.getElementsByName("FASIN")[0].className = "noBorder";
				if(!initFlag){
					document.form1.FASIN.value="";
					document.form1.SCHCODE.value="";
				}
			}
		}
		/*
		*	v.1.5 END
		*/
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

            	<c:choose>
                	<c:when test="${msgFLAG ne '' }">
					<tr>
		                <td align="center" colspan="4">
		                   <br/>${msgTEXT}<br/><br/>
		                </td>
	                </tr>
                	</c:when>
                	<c:otherwise>
                	<tr>
                		<th><!-- 가족선택 --><spring:message code="LABEL.E.E22.0038" /></th>
                		<td colspan="3">
                			<input type="hidden" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}"  />
                          	<input type="text" name="FAMSA" value="${resultData.FAMSA}" size="5" class="noBorder" readonly/>
                          	<input type="text" name="ATEXT" value="${resultData.ATEXT}" size="10" class="noBorder" readonly/>
                		</td>
                	</tr>

                	<tr>
                		<th><span class="textPink">*</span><!-- 신청유형 --><spring:message code="LABEL.E.E22.0039" /></th>
                		<td>
                			<select name="SUBF_TYPE" style="width:135px;" onChange="javascript:change_type(this);">
                            <option>-------------</option>
                            <option value="2" <c:if test = "${resultData.SUBF_TYPE eq '2' }" >selected</c:if>><!-- 학자금 --><spring:message code="LABEL.E.E22.0040" /></option>
                            <option value="3" <c:if test = "${resultData.SUBF_TYPE eq '3' }" >selected</c:if>><!-- 장학금 --><spring:message code="LABEL.E.E22.0041" /></option>
                          	</select>
                		</td>
                		<th  class="th02"><span class="textPink">*</span><!-- 신청년도 --><spring:message code="LABEL.E.E22.0024" /></th>
                		<td>
                			<input type="text" name="PROP_YEAR" class="noBorder" value="${i_date}" size="5" readonly> 년
                		</td>
                	</tr>

                	<tr>
                        <th><span class="textPink">*</span><!-- 신청구분 --><spring:message code="LABEL.E.E22.0042" /></th>
                        <td>
                          <input type="radio" name="radiobutton" value="신규분" <c:if test = "${resultData.PAY1_TYPE eq 'X' }" >checked</c:if>>
                          	<!-- 신규분 --><spring:message code="LABEL.E.E22.0022" />
                          <input type="radio" name="radiobutton" value="추가분" <c:if test = "${resultData.PAY2_TYPE eq 'X' }" >checked</c:if>>
                          	<!-- 추가분 --><spring:message code="LABEL.E.E22.0023" />
                        </td>
                        <th class="th02"><span class="textPink">*</span><!-- 신청분기ㆍ학기 --><spring:message code="LABEL.E.E22.0025" /></th>
                        <td>
                            <select name="selType" style="width:135px;">
                            <option>-----------</option>
                                 ${f:printCodeOption(CodeEntityType_vt, selType)}
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

                         	<option value ="${index}" <c:if test = "${( row.SUBTY eq subty) && (row.OBJPS eq objps) }" >selected</c:if> ><c:out value='${fn:trim(row.LNMHG)}'/> <c:out value='${fn:trim(row.FNMHG)}'/></option> <!-- 데이터 확인 index 및 trim -->

							</c:forEach>

                          	</select>
                          </td>
                      </tr>
                      <tr>
                		  <th><span class="textPink">*</span><!-- 학력 --><spring:message code="LABEL.E.E22.0026" /></th>
                		  <td colspan="3">
                          	  <input type="text" name="ACAD_CARE" value="<c:out value='${ resultData.ACAD_CARE}'/>" size="5"  readonly />
                          	  <input type="text" name="STEXT" value="<c:out value='${ resultData.STEXT}'/>" size="22" readonly />
                		  </td>
               		  </tr>

               		  <tr>
                		  <th><!-- 교육기관 --><spring:message code="LABEL.E.E22.0027" /></th>
                		  <td>
                		  		<!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
		                      	<span id="ACAD_TYPE1" style="display:none;">
		                      	<input type="text" name="SEARCH_ACAD" value="" size="31" style="ime-mode:active;" onKeyDown = "javascript:EnterAcademyPop();">
		                      	<a href="javascript:pop_academy();"> <img src="/web/images/btn_serch.gif"  align="absmiddle" border="0" alt="교육기관 검색"></a></span>
		                      	<input type="text" name="SCHCODE" id="SCHCODE" value="<c:out value='${ resultData.SCHCODE}'/>" class="noBorder" size="9" readonly style="display:none">
		                      	<!-- 신청유형:장학금인 경우에만 시스템 수정 END -->

	                            <input type="text" name="FASIN" value="<c:out value='${ resultData.FASIN}'/>" class="noBorder" size="30" readonly />

                		  </td>
                		  <th class="th02"><!-- 학년 --><spring:message code="LABEL.E.E22.0029" /></th>
                		  <td>
                		  	  <input type="text" name="ACAD_YEAR" value="${resultData.ACAD_YEAR eq '0' ? '' : resultData.ACAD_YEAR}" style="text-align:center" size="10"  onBlur="javascript:usableChar(this,'123456890');" maxlength="1"  />
                		  	  <!-- 학년 --><spring:message code="LABEL.E.E22.0029" />
                	      </td>
               		  </tr>

					  <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 start -->
					  <tr id="FRTXT" style="display:none;">
	                      <th><span class="textPink">*</span><!-- 학과 --><spring:message code="LABEL.E.E22.0047" /></th>
	                      <td colspan="3">
		               	  		<input type="text" name="FRTXT" value="<c:out value='${resultData.FRTXT}'/>" style="text-align:left" size="31"/>
	                      </td>
	                  </tr>
					  <!-- [CSR ID:3569058] Global HR Portal 장학금 신청화면 개선 요청의 건 end -->
               		  <tr>
                          <th><span class="textPink">*</span><!-- 신청액 --><spring:message code="LABEL.E.E22.0018" /></th>
                          <td>
                          <input type="text" name="PROP_AMNT" value="${f:printNumFormat(resultData.PROP_AMNT, currencyValue) }" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS');" style="text-align:right" size="20">
                          <select name="WAERS" onChange="javascript:moneyChkForLGchemR3(document.form1.PROP_AMNT,'WAERS');javascript:moneyChkReSetting();">
                          <!-- 통화키 가져오기-->
                           ${f:printCodeOption(currencyCodeList,resultData.WAERS)}
                           <!-- 통화키 가져오기-->
                          </select>
                          </td>
                          <th class="th02"><!-- 수혜횟수 --><spring:message code="LABEL.E.E22.0030" /></th>
                          <td>
                          	  <input type="text" name="P_COUNT" value="${f:printNum(print_count)}" style="text-align:center" size="10" class="noBorder" readonly> <!-- 회 --><spring:message code="LABEL.E.E22.0037" />
                       	  </td>
                      </tr>

                      <tr>
                          <th><!-- 입학금 --><spring:message code="LABEL.E.E22.0028" /></th>
                          <td>
                              <input type="checkbox" name="ENTR_FIAG" value="X" <c:if test = "${resultData.ENTR_FIAG eq 'X' }" >checked</c:if> >
                          </td>
                          <!-- 신청유형:장학금인 경우에만 시스템 수정 START -->
						  <th class="th02" ><div  id="TYPE_3" style="display:none;"><!-- 유학 학자금 --><spring:message code="LABEL.E.E22.0031" /></div> </th>
                          <td>
                          	  <div id="TYPE_3_1" style="display:none;" >
                          	  <input type="checkbox" name="ABRSCHOOL" value="X" size="20" onClick="javascript:change_student('', false);" <c:if test = "${resultData.ABRSCHOOL eq 'X' }" >checked</c:if> >
                          	  </div>
                          </td>

						 <!-- 신청유형:장학금인 경우에만 시스템 수정 END -->
                      </tr>

                	</c:otherwise>
                	</c:choose>
             </table>
		</div><!-- end class="table" -->

		<div class="commentsMoreThan2">
        	<div><!-- 추가분은 등록금 인상시 선택하여 신청함 --><spring:message code="LABEL.E.E22.0044" /></div>
        	<div><spring:message code="MSG.COMMON.0061" /><%--* 는 필수 입력사항입니다.--%></div>
        </div>
		<!-- 상단 입력 테이블 끝-->

    <!-- Hidden Field -->

    <input type="hidden" name="SUBTY"       value="${resultData.FAMSA}">        <!-- 가족유형 -->
    <input type="hidden" name="OBJC_CODE"   value="${resultData.OBJC_CODE}">    <!-- 하부유형 -->
    <input type="hidden" name="PAID_DATE"   value="${resultData.PAID_DATE}">    <!-- 통화키 -->
    <input type="hidden" name="LNMHG"       value="${resultData.LNMHG}">        <!-- 성(이름) -->
    <input type="hidden" name="FNMHG"       value="${resultData.FNMHG}">        <!-- 이름 -->
    <input type="hidden" name="PAY1_TYPE"   value="${resultData.PAY1_TYPE}">
    <input type="hidden" name="PAY2_TYPE"   value="${resultData.PAY2_TYPE}">
    <input type="hidden" name="PERD_TYPE"   value="${resultData.PERD_TYPE}">    <!-- 분기 -->
    <input type="hidden" name="HALF_TYPE"   value="${resultData.HALF_TYPE}">    <!-- 반기 -->


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

	</div>


	</tags-approval:request-layout>
</tags:layout>

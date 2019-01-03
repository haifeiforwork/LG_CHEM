<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustGibuChange.jsp                                  */
/*   Description  : 특별공제기부금 입력 및 조회                                 */
/*   Note         : 없음                                                        */
/*   Creation     :   2005.11.17 lsa                                            */
/*   Update       :   2005.12.08 lsa  @v1.1  사업자등록번호 정치자금인경우 비활성화처리*/
/*                    2006.11.22 lsa  @v1.2  국체청자료 체크추가                */
/*                    2008-11-20  CSR ID:1361257 2008년말정산반영               */
/*                    2012-12-13  C20121213_34842 기부금유형: 당해년도 입사자만 기부금 유형 '31' 신탁기부금 '30' 특례기부금 조회됨 */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector gibu_vt    = (Vector)request.getAttribute("gibu_vt" );
    String rowCount   = (String)request.getAttribute("rowCount" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));

    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    int gibu_count = 8;
    if( gibu_vt.size() > gibu_count ) {
        gibu_count = gibu_vt.size();
    }
    if ( Integer.parseInt(rowCount) != 8  ) {
        gibu_count = Integer.parseInt(rowCount);
    }
    String Gubn = "Tax06";
    String PERNR = (String)request.getAttribute("PERNR");

    //CSR ID:1361257
    D11TaxAdjustPePersonRFC   rfcPeP   = new D11TaxAdjustPePersonRFC();
    Vector MediPeP_vt = new Vector();
    MediPeP_vt      = rfcPeP.getPePerson( "5",user.empNo, targetYear  ); //I_GUBUN :1 - 보험료 2- 의료비  3-교육비 4-신용카드 5-기부금

    String Prev_YN="";
    //  전근무지 메뉴를 해당년도 입사자인 경우에만 메뉴를 보여준다.
    if( user.e_dat03.substring(0,4).equals(targetYear) ) {
    	Prev_YN ="Y";
    }

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
	//enable 처리
	function setEnable(){
		var tbody = $('#table tbody');
		tbody.find(':input').each(function(){
			this.disabled = false;
		});
		
		eval("document.form1.FSTID.disabled = false;") ; //세대주여부
	    if( eval("document.form1.FSTID.checked == true") )
	        eval("document.form1.FSTID.value ='X';");
	}

function check_data() {
    for( var i = 0 ; i < "<%= gibu_count %>" ; i++ ) {
        subty    = eval("document.form1.SUBTY"+i+".value");   //CSR ID:1361257
        f_ename  = eval("document.form1.F_ENAME"+i+".value"); //CSR ID:1361257
        f_regno  = eval("document.form1.F_REGNO"+i+".value"); //CSR ID:1361257

        dona_code    = eval("document.form1.DONA_CODE"+i+".value");
        DONA_YYMM    = eval("document.form1.DONA_YYMM"+i+".value");
        dona_desc    = eval("document.form1.DONA_DESC"+i+".value");
        dona_numb    = eval("document.form1.DONA_NUMB"+i+".value");
        dona_comp    = eval("document.form1.DONA_COMP"+i+".value");
        dona_amnt    = eval("document.form1.DONA_AMNT"+i+".value");
        gubun        = eval("document.form1.GUBUN"+i+".value");

        if ( gubun != "1" && gubun != "9") { //자동반영분은 체크하지 않음
             if ( f_ename != "" || dona_code != "" || f_regno != ""   ) {
                if ( f_ename == ""   ) {
                    alert("<spring:message code='MSG.D.D11.0039' />"); //관계,성명은 필수 항목입니다.
                    eval("document.form1.F_ENAME"+i+".focus()");
                    return;
                }
                if ( f_regno == ""   ) {
                    alert("<spring:message code='MSG.D.D11.0040' />"); //주민번호는 필수 항목입니다.
                    eval("document.form1.F_REGNO"+i+".focus()");
                    return;
                }
                if ( dona_code == ""   ) {
                    alert("<spring:message code='MSG.D.D11.0041' />"); //기부금유형은 필수 항목입니다.
                    eval("document.form1.DONA_CODE"+i+".focus()");
                    return;
                }
                if ( DONA_YYMM == ""   ) {
                    alert("<spring:message code='MSG.D.D11.0042' />"); //기부년월은 필수 항목입니다.
                    eval("document.form1.DONA_YYMM"+i+".focus()");
                    return;
                }
                if ( dona_desc == ""   ) {
                    alert("<spring:message code='MSG.D.D11.0043' />"); //기부금내용은 필수 항목입니다.
                    eval("document.form1.DONA_DESC"+i+".focus()");
                    return;
                }
                if ( dona_amnt == ""   ) {
                    alert("<spring:message code='MSG.D.D11.0044' />"); //금액은 필수 항목입니다.
                    eval("document.form1.DONA_AMNT"+i+".focus()");
                    return;
                }
            	if ( dona_code == "20" ) { //정치기부금
            	    if ( dona_comp == ""   ) {
            	        alert("<spring:message code='MSG.D.D11.0045' />"); //상호는 필수 항목입니다.
            	        eval("document.form1.DONA_COMP"+i+".focus()");
            	        return;
            	    }
            	} else  if ( dona_code == "41" ||dona_code != "" ) {//41:종교단체기부금, 20:정치기부금
            	    if ( dona_comp == ""   ) {
            	        alert("<spring:message code='MSG.D.D11.0045' />"); //상호는 필수 항목입니다.
            	        eval("document.form1.DONA_COMP"+i+".focus()");
            	        return;
            	    }
            	    if ( dona_numb == ""   ) {
            	        alert("<spring:message code='MSG.D.D11.0046' />"); //사업자번호는 필수 항목입니다.
            	        eval("document.form1.DONA_NUMB"+i+".focus()");
            	        return;
            	    }

               }
               //@2011
	       if ( dona_code == "30" ) {//특례기부금

                   if ( DONA_YYMM >= "201107"  ) {
                       alert("<spring:message code='MSG.D.D11.0047' />"); //특례기부금은 2011년06월까지만 입력할 수 없습니다.
                       return;
                   }
               }
            }
            //@2011 이월 항목 체크
            <% if ( Prev_YN.equals("Y") ){ %>

        	if( eval("document.form1.DONA_CRVIN"+ i + ".checked == true") ) {
        	    eval("document.form1.DONA_CRVIN"+ i + ".value ='X';");
        	} else {
        	    eval("document.form1.DONA_CRVIN"+ i + ".value ='';");
        	}
        	dona_crvin = eval("document.form1.DONA_CRVIN"+i+".value"); //이월공제
        	dona_crvyr = eval("document.form1.DONA_CRVYR"+i+".value"); //이월공제년도
        	dona_dedpr = eval("document.form1.DONA_DEDPR"+i+".value"); //전년까지공제액
 		if ( dona_crvin == "X" ) {
		    if ( dona_crvyr == ""   ) {
            	        alert("<spring:message code='MSG.D.D11.0048' />"); //이월공제년도를 입력하세요.
            	        eval("document.form1.DONA_CRVYR"+i+".focus()");
            	        return;
            	    }
		    if ( dona_dedpr == ""|| dona_dedpr == "0"   ) {
            	        alert("<spring:message code='MSG.D.D11.0049' />"); //전년까지공제액을 입력하세요.
            	        eval("document.form1.DONA_DEDPR"+i+".focus()");
            	        return;
            	    }
               }

            <% } %>

            if (!lastDay(i, eval("document.form1.DONA_YYMM" +i) )) {
               return;
            }
        }
    }
    return true;
}

function validDate(date)
{
    if(date.length == 8 ) {
        year  = date.substring(0,4);
        month = date.substring(4,6);
        day   = date.substring(6,8);
    }
    else if ( date.length == 0)	{
         return true;
    }
    else {
        return false;
    }
    if (year < '1900') return false;
    if (month < '01' || month > '12') return false;
    if (day < '01' || day > '31') return false;
    switch (month) {
        case '02' :  if ((year%4 == 0 && year%100 != 0) || year%400 == 0) {
                    if (day > 29) return false;
                  } else {
                    if (day > 28) return false;
                  }
                  break;
        case '04' :
        case '06' :
        case '09' :
        case '11' : if (day > 30) return false;
    }

    return true;
}

// 특별공제기부금 - 수정
function do_change() {

    if ( check_data() ) {
        for( var i = 0 ; i < "<%= gibu_count %>" ; i++ ) {

            eval("document.form1.DONA_AMNT"+i+".value  = removeComma(document.form1.DONA_AMNT"+i+".value);");
            eval("document.form1.DONA_NUMB"+i+".value  = removeResBar2(document.form1.DONA_NUMB"+i+".value);");

            if (  eval("document.form1.DONA_AMNT"+i+".value.length") > 9 ) {
                alert("<spring:message code='MSG.D.D11.0058' />"); //신청금액 자리수가 9자리가 넘는지 확인하세요!
                eval("document.form1.DONA_AMNT"+i+".focus()")
                return;
            }
            eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");

            <% if (Prev_YN.equals("Y") ) { %>

            eval("document.form1.DONA_DEDPR"+i+".value  = removeComma(document.form1.DONA_DEDPR"+i+".value);");

            if( eval("document.form1.DONA_CRVIN"+ i + ".checked == true") ) { //이월공제 지시자
                eval("document.form1.DONA_CRVIN"+ i + ".value ='X';");
            } else {
                eval("document.form1.DONA_CRVIN"+ i + ".value ='';");
                eval("document.form1.DONA_DEDPR"+ i + ".value ='0';");
            }

            //@2011-v2
            if ( eval("parseInt(removeComma(document.form1.DONA_DEDPR"+i+".value)) > parseInt(removeComma(document.form1.DONA_AMNT"+i+".value))") ){

                alert("<spring:message code='MSG.D.D11.0051' />"); //전년까지공제액은 금액을 초과해서 입력할 수 없습니다.!
                eval("document.form1.DONA_DEDPR"+i+".focus()");
                return;
            }
            <% } %>

            //국세청PDF
	         if( eval("document.form1.GUBUN"+ i + ".checked == true") ) {
	            eval("document.form1.GUBUN"+ i + ".value ='X';");
	        } else {

	            if( eval("document.form1.GUBUN_SAP"+ i + ".value == '1'") ) {
	            	eval("document.form1.GUBUN"+ i + ".value ='1';");
	            	//alert("i-----:"+  eval("document.form1.GUBUN"+ i + ".value")  );
	            }else{
	            	eval("document.form1.GUBUN"+ i + ".value ='';");
	            }
	        }
	        //연말정산삭제
	         if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
	            eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
	        } else {
	            eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
	        }
            // alert("i:"+i+ "GUBUN_SAP:"+ eval("document.form1.GUBUN_SAP"+ i + ".value")+ "GUBUN:"+ eval("document.form1.GUBUN"+ i + ".value")  );


        }
        //세대주여부
        if( eval("document.form1.FSTID.checked == true") )
            eval("document.form1.FSTID.value ='X';");

        //필드 enable처리
        setEnable();
        document.form1.jobid.value = "change";
        document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
        document.form1.method      = "post";
        document.form1.target      = "menuContentIframe";
        document.form1.submit();
    }
}

/* 기부금 입력항목 1개 추가 */
function add_field(){
    document.form1.gibu_count.value = parseInt(document.form1.gibu_count.value) + 1;
    for( var i = 0 ; i < "<%= gibu_count %>" ; i++ ) {
        eval("document.form1.DONA_AMNT"+i+".value  = removeComma(document.form1.DONA_AMNT"+i+".value);");
        eval("document.form1.DONA_NUMB"+i+".value  = removeResBar2(document.form1.DONA_NUMB"+i+".value);");
        eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");

        <% if (Prev_YN.equals("Y") ) { %>

        //@2011
        eval("document.form1.DONA_DEDPR"+i+".value  = removeComma(document.form1.DONA_DEDPR"+i+".value);");//이월공제금액

        <% } %>

	//국세청PDF
	 if( eval("document.form1.GUBUN"+ i + ".checked == true") ) {
	    eval("document.form1.GUBUN"+ i + ".value ='X';");
	} else {

	    if( eval("document.form1.GUBUN_SAP"+ i + ".value == '1'") ) {
	    	eval("document.form1.GUBUN"+ i + ".value ='1';");
	    	//alert("i-----:"+  eval("document.form1.GUBUN"+ i + ".value")  );
	    }else{
	    	eval("document.form1.GUBUN"+ i + ".value ='';");
	    }
	}
       //연말정산삭제
        if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
           eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
       } else {
           eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
       }
    }

	//필드 enable처리
    setEnable();

    document.form1.jobid.value = "AddorDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

/* 기부금 입력항목 아래항목 지우기 */
function remove_field(){

    if ( document.form1.gibu_count.value == 0 ) {
        alert("<spring:message code='MSG.D.D11.0052' />"); //기부금 입력항목을 더이상 줄일수 없습니다.
        return;
    }
    var delchk = false;
    var deleteLine = "";
    for( var i = 0 ; i < "<%= gibu_count %>" ; i++ ) {
        if (document.form1.radiobutton[i].checked == true &&  eval("document.form1.GUBUN"+i+".value") == "1"     )  {
            alert("<spring:message code='MSG.D.D11.0027' />"); //자동반영분은 삭제할 수 없습니다.
            return;
        }
        if( isNaN( document.form1.radiobutton.length ) ){
            eval("document.form1.use_flag0.value = 'N'");
        } else {
            if ( document.form1.radiobutton[i].checked == true ) {
                if(!delchk){
                	delchk = true;
                	deleteLine = i;

                }
                eval("document.form1.use_flag"+ i +".value = 'N'");
            }
        }

    }
    //alert("deleteLine:"+deleteLine);
    if(!delchk) {
    	alert("<spring:message code='MSG.D.D11.0021' />"); //삭제할 건을 선택하세요.
    	return;
    }

    document.form1.gibu_count.value = parseInt(document.form1.gibu_count.value) - 1;

    for( var i = 0 ; i < "<%= gibu_count %>" ; i++ ) {
    	//@v1.1
		//if (  eval("document.form1.GUBUN"+i+".value") == "1")  {
		//    alert("이미 급여처리 된 건은 삭제할 수 없습니다.");
		//    return;
		//}
        eval("document.form1.DONA_AMNT"+i+".value  = removeComma(document.form1.DONA_AMNT"+i+".value);");
        eval("document.form1.DONA_NUMB"+i+".value  = removeResBar2(document.form1.DONA_NUMB"+i+".value);");
        eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");
        <% if (Prev_YN.equals("Y") ) { %>
        //@2011
        eval("document.form1.DONA_DEDPR"+i+".value  = removeComma(document.form1.DONA_DEDPR"+i+".value);");//이월공제금액
        <% } %>
	//국세청PDF
	 if( eval("document.form1.GUBUN"+ i + ".checked == true") ) {
	    eval("document.form1.GUBUN"+ i + ".value ='X';");
	} else {

	    if( eval("document.form1.GUBUN_SAP"+ i + ".value == '1'") ) {
	    	eval("document.form1.GUBUN"+ i + ".value ='1';");
	    }else{
	    	eval("document.form1.GUBUN"+ i + ".value ='';");
	    }
	}
       //연말정산삭제
        if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
           eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
       } else {
           eval("document.form1.OMIT_FLAG"+ i + ".value =''");
       }
    }

  	//필드 enable처리
  	setEnable();
    document.form1.jobid.value = "AddorDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();

}



// 값이 변경되었는지 체크한다
function chk_change() {
    flag = false;
}
/*-------------------------------------------------------------------
    Description   : valid Date
-------------------------------------------------------------------*/
function lastDay(i,date)
{

    if ( eval("document.form1.GUBUN"+i+".value") == "1" ){
        return true;
    } else {
            if ( date.value == "" ) {
                return true;
            }

            if (!validDate(date.value+"01")&& date.value != "") {
                alert("<spring:message code='MSG.D.D11.0053' />"); //유효한 년월(YYYYMM)포맷이 아닙니다.!
                date.focus();
		return false;

            }
	    //@2011-v2
            <% if ( Prev_YN.equals("Y") ){ %>
        	if( eval("document.form1.DONA_CRVIN"+ i + ".checked == true") ) {
        	    return true;
        	}
            <% } %>

            //C20121213_34842 '31' 신탁기부금 '30' 특례기부금 은 이전년도 입력가능
            if( eval("document.form1.DONA_CODE"+ i + ".value == '30'") ||eval("document.form1.DONA_CODE"+ i + ".value == '31'")  ) {
                null;
            }else{
                if ("<%=targetYear%>" != date.value.substring(0,4) ) {
                    alert("<spring:message code='MSG.D.D11.0054' />"); //해당 년도만 입력가능합니다!
                    date.focus();
		    return false;
                }
            }

     }
     return true;
}
//@v1.2 사업자번호 또는 주민번호
function businoFormat1(i,obj) {
    if ( obj.value.length ==  0  )
        return;
    if ( obj.value.length ==  10  ){
        if (!check_busino(obj.value)) {
             alert("<spring:message code='MSG.D.D11.0056' />"); //사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요.
         //    alert("숫자로만 입력하시기 바랍니다!\n10자리 또는 13자리로 입력하세요");

	     obj.focus();
	     obj.select();
             return false;
        }
    }
    else if ( obj.value.length ==  13  ) {
        if (!resno_chk(obj)) {
            return false;
        }
        return;
    }
    else {
        alert("<spring:message code='MSG.D.D11.0057' />"); //숫자로만 입력하시기 바랍니다!\n10자리 또는 13자리로 입력하세요
	obj.focus();
	obj.select();
        return false;
    }
    obj.value= obj.value.replace("-","");
}
function resno_chk(obj){
    if( chkResnoObj_1(obj) == false ) {
        return false;
    }
}
function dona_numb_check(i,obj) {
    var val = obj.value;

    if ( eval("document.form1.GUBUN"+i+".value") == "1" )
        return false;

    prev_check(obj,i);// 기부금유형선택시마다 이월공제체크

    if (val == "20") { //정치기부금
        eval("document.form1.DONA_NUMB"+i+".value  = \"\";");
        eval("document.form1.DONA_NUMB"+i+".disabled  = true;");
    }else if (val == "41") { //종교단체기부금
        eval("document.form1.DONA_NUMB"+i+".disabled  = false;"); //사업자번호
        eval("document.form1.DONA_COMP"+i+".disabled  = false;");
    }else {

        eval("document.form1.DONA_COMP"+i+".disabled  = false;");
        eval("document.form1.DONA_NUMB"+i+".disabled  = false;");
    }
    //정치기부금 20  은 본인이 기부한것만 입력이 가능
    var notValue = new Array("20" );

    for (r=0;r< notValue.length;r++) {
       if ( eval("document.form1.DONA_CODE"+i+".value") == notValue[r] && eval( "document.form1.SUBTY"+i+".value") != "35" ) {
          alert("<spring:message code='MSG.D.D11.0055' />"); //정치기부금은 본인이 기부한것만 입력가능합니다.
          eval( "document.form1.DONA_CODE"+i+"[0].selected = true;");

          return;
       }
    }
}
//@2011 이월체크
function dona_crvin_check(i,obj) {
    var val = obj.value;
    if ( eval("document.form1.GUBUN"+i+".value") == "1" )
        return false;

    if( eval("document.form1.DONA_CRVIN"+ i + ".checked == false") ) {
        eval("document.form1.DONA_CRVYR"+i+".value  = '';");
        eval("document.form1.DONA_DEDPR"+i+".value  = '';");
        eval("document.form1.DONA_DEDPR"+i+".disabled  = true;");
	eval("document.form1.DONA_DEDPR"+i+".style.backgroundColor='#F5F5F5'");

    }else  {

        eval("document.form1.DONA_CRVYR"+i+".value  = document.form1.DONA_YYMM"+i+".value.substring(0,4);");
        eval("document.form1.DONA_DEDPR"+i+".disabled  = false;");
	eval("document.form1.DONA_DEDPR"+i+".style.backgroundColor='#FFFFFF'");

    }
}

//@2011 전월공제 가능년도 체크
function prev_check(obj,i)
{

    //@2011-v2
    <% if ( Prev_YN.equals("Y") ){ %>

    if( eval("document.form1.DONA_CRVIN"+ i + ".checked == true") ) {

        eval("document.form1.DONA_CRVYR"+i+".value  = document.form1.DONA_YYMM"+i+".value.substring(0,4);");

        if( eval("document.form1.DONA_CRVIN"+ i + ".checked == true") && eval("document.form1.DONA_CRVYR"+i+".value") != ""  ) {

    		document.form1.H_GUBN.value = "CHECK";
    		document.form1.DONA_CODE.value = eval("document.form1.DONA_CODE"+i+".value");
    		document.form1.DONA_CRVYR.value = eval("document.form1.DONA_YYMM"+i+".value.substring(0,4)");
    		//document.form1.DONA_CRVYR.value = eval("document.form1.DONA_CRVYR"+i+".value");
    		document.form1.INX.value = i;
    		document.form1.target = "ifHidden";
    		document.form1.action = "<%=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustGibuHiddenbusiName.jsp";
    		document.form1.submit();
    	}
    }
    <% } %>
}

//@v2007  대리 신청 추가
function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
    frm.target = "";
    frm.submit();
}
//@v1.1 사업자번호 명칭검색 //@2014 연말정산 박난이S 요청 명칭 아예 안불러오도록.
function name_search(obj,i)
{
    val1 = obj.value;
    val1 = rtrim(ltrim(val1));

    if ( val1 == "" ) {
        return;
    }

    document.form1.H_GUBN.value = "NAME";
    document.form1.BUS01.value = removeResBar2(val1);
    document.form1.INX.value = i;
    document.form1.target = "ifHidden";
    document.form1.action = "<%=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustGibuHiddenbusiName.jsp";
    document.form1.submit();
} // @v1.1 end function
//CSR ID:1361257 성명변경시 관계 값 선택
function subty_change(row, obj) {
 	  var val = obj[obj.selectedIndex].value;//DREL_CODE
    var inx = obj.selectedIndex;
    if( inx > 0 ) {
        var fami_rlat =  eval( "document.form1.FAMI_RLAT"+(inx-1)+".value"); //선택된 성명의 관계코드
        var fami_regn =  eval( "document.form1.FAMI_REGN"+(inx-1)+".value"); //선택된 성명의 주민번호
        var fami_b001 =  eval( "document.form1.FAMI_B001"+(inx-1)+".value"); //선택된 성명의 인적공제 기본공제
        var fami_b002 =  eval( "document.form1.FAMI_B002"+(inx-1)+".value"); //선택된 성명의 인적공제 장애인여부

        var subI =  eval( "document.form1.SUBTY0.length");     //화면의관계코드index
        //화면의성명에 해당하는 관계코드setting
        for ( i=0; i< subI ; i++ ) {
           if ( eval( "document.form1.SUBTY"+row+"["+i+"].value") == fami_rlat )
               eval( "document.form1.SUBTY"+row+"["+i+"].selected = true;");
        }
        //화면의성명에 해당하는 주민번호setting
        eval( "document.form1.F_REGNO"+row+".value = \""+addResBar(fami_regn)+"\";");

    } else {
        eval( "document.form1.SUBTY"+row+"["+inx+"].selected = true;");
        eval( "document.form1.F_REGNO"+row+".value = \"\";");

        eval( "document.form1.DONA_CODE"+row+"[0].selected = true;");
        eval( "document.form1.DONA_YYMM"+row+".value = \"\";");
        eval( "document.form1.DONA_DESC"+row+".value = \"\";");
        eval( "document.form1.DONA_NUMB"+row+".value = \"\";");
        eval( "document.form1.DONA_COMP"+row+".value = \"\";");
        eval( "document.form1.DONA_AMNT"+row+".value = \"\";");
        eval("document.form1.CHNTS"+row+".checked = false;");
    }

    dona_numb_check(row,eval("document.form1.DONA_CODE"+row));
}

//입력취소
function cancel(){
    if(confirm("<spring:message code='MSG.D.D11.0038' />")){ //입력작업을 취소하시겠습니까?
        document.form1.jobid.value = "first";
        document.form1.action =  "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustGibuSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}

//-->
</SCRIPT>
 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>

<form name="form1" method="post">


<%@ include file="D11TaxAdjustButton.jsp" %>

    <!--특별공제 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:add_field();"><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><!-- 추가 --></span></a></li>
                    <li><a href="javascript:remove_field();"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><!-- 삭제 --></span></a></li>
                </ul>
            </div>
        </div>
        <div class="table">
            <table class="listTable" id="table">
            <thead>
              <tr>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0047" /><!-- 선택 --></th>
                <th colspan="3"><spring:message code="LABEL.D.D11.0131" /><!-- 기부자 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0132" /><!-- 기부금유형 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0133" /><!-- 기부년월 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0134" /><!-- 기부금 내용 --></th>
                <th colspan="2"><spring:message code="LABEL.D.D11.0135" /><!-- 기부처 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
             <% if ( Prev_YN.equals("Y") ){ %>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0136" /><!-- 이월<BR>공제 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0137" /><!-- 이월<BR>공제<BR>년도 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0138" /><!-- 전년까지<BR>공제액 --></th>
             <% } %>
                <% if("Y".equals(pdfYn)) {%>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                <th class="lastCol" rowspan="2"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></th>
                <%} %>
              </tr>

              <tr>
                <th><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>    <!--CSR ID:1361257-->
                <th><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></th>     <!--CSR ID:1361257-->
                <th><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></th><!--CSR ID:1361257-->
                <th><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></th>
                <th><spring:message code="LABEL.D.D11.0140" /><!-- 상호(법인명) --></th>
              </tr>
          </thead>
<%
    String old_Name = "";
    int index = 0;
    // @v1.3
    for( int j = 0 ; j < MediPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)MediPeP_vt.get(j);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {

%>
           <input type=hidden name="FAMI_RLAT<%= index %>" value="<%=fdata.KDSVH%>">
           <input type=hidden name="FAMI_REGN<%= index %>" value="<%=fdata.REGNO%>">
           <input type=hidden name="FAMI_B001<%= index %>" value="<%=fdata.DPTID%>">
           <input type=hidden name="FAMI_B002<%= index %>" value="<%=fdata.HNDID%>">

<%
        index = index + 1;

        }
        old_Name = fdata.ENAME;
    }
%>
    <%
        for( int i = 0 ; i < gibu_vt.size() ; i++ ){
            D11TaxAdjustGibuData data = (D11TaxAdjustGibuData)gibu_vt.get(i);
    %>
              <tr class="<%=WebUtil.printOddRow(i) %>">
                <input type="hidden" name="GUBUN_SAP<%=i%>"  value="<%= data.GUBUN %>"> <!--GUBUN 추가 20140116-->
                <input type="hidden" name="use_flag<%=i%>"  value="Y">
                <td >
                <input type="radio" name="radiobutton" value="<%=i%>" <%= data.GUBUN.equals("9")||data.GUBUN.equals("1") ? "disabled" : "" %>>
                </td>
            <td >
              <select name="SUBTY<%=i%>"  style="width=70px" auto class="input04" disabled>
                <option value="">-------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %>
              </select>
            </td>
            <td >
              <select name="F_ENAME<%=i%>"  style="width=60px" auto class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" onChange="javascript:subty_change(<%=i%>,this);" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                <option value="">--------</option>
<%
    //@v1.3
    old_Name = "";
    for( int j = 0 ; j < MediPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)MediPeP_vt.get(j);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {
             if (data.F_ENAME.equals(fdata.ENAME)) {
%>
                     <option value="<%=fdata.ENAME%>" selected><%=fdata.ENAME%></option>
<%
             } else  {
%>
                     <option value="<%=fdata.ENAME%>"><%=fdata.ENAME%></option>
<%
             }
         }
         old_Name = fdata.ENAME;

    }
%>

              </select>
            </td>
            <td >
              <input type="text" name="F_REGNO<%=i%>" value="<%= data.F_REGNO.equals("") ? "" : DataUtil.addSeparate(data.F_REGNO) %>" size="13" class="input04" maxlength="14" onBlur="javascript:<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "return;" : "" %>resno_chk(this);" readonly>
            </td>
                <td >
                  <select name="DONA_CODE<%= i %>"  style="width=90px" auto class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %> onChange="javascript:dona_numb_check(<%= i %>,this);">
                    <option value="">-------------</option>
    <%= WebUtil.printOption((new D11TaxAdjustDonationTypeRFC()).getDonationType(targetYear,PERNR), data.DONA_CODE) %>
                  </select>
                </td>
                <td >
                  <input type="text" name="DONA_YYMM<%= i %>" value="<%= data.DONA_YYMM.equals("") ? "" : data.DONA_YYMM %>" size="6" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>"  maxlength="6" style="text-align:center" onBlur="javascript:prev_check(this,<%=i%>);if (!lastDay(<%= i %>,this)) return;" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                </td>
                <td >
                  <input type="text" name="DONA_DESC<%= i %>" value="<%= data.DONA_DESC.equals("") ? "" : data.DONA_DESC %>" size="15" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" maxlength="20"  <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                </td>

                <td >
                  <input type="text" name="DONA_NUMB<%= i %>" value="<%= data.DONA_NUMB %>" size="10" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" maxlength="15" style="text-align:center" onBlur="javascript:name_search(this,<%=i%>);businoFormat1(<%=i%>,this);resno_chk(this);return;" <%= data.GUBUN.equals("1")||data.DONA_CODE.equals("20")||data.GUBUN.equals("9") ? "disabled" : "" %>><!-- name_search(this,< %=i%>); 제외(박난이S요청) -->
                </td>
                <td >
                  <input type="text" name="DONA_COMP<%= i %>" value="<%= data.DONA_COMP.equals("") ? "" : data.DONA_COMP %>" size="15" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" maxlength="20" <%= data.GUBUN.equals("9") ? "disabled" : "" %> onkeypress="javascript:fn_checkSpText(this);">
                </td>
                <td >
                  <input type="text" name="DONA_AMNT<%= i %>" value="<%= data.DONA_AMNT.equals("") ? "" : WebUtil.printNumFormat(data.DONA_AMNT) %>" size="10" maxlength="11" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right"  <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                </td>
                  <input type="hidden" name="CHNTS<%=i%>" value="<%=  data.CHNTS.equals("") ? "" : data.CHNTS %>" <%= data.CHNTS.equals("X")  ? "checked" : "" %>>

             <% if ( Prev_YN.equals("Y") ){ //@2011 %>
                <td >
                  <input type="checkbox" name="DONA_CRVIN<%= i %>" value="<%=  data.DONA_CRVIN.equals("") ? "" : data.DONA_CRVIN %>" <%= data.DONA_CRVIN.equals("X")  ? "checked" : "" %>  class="input03" style="text-align:center"  onClick="javascript:dona_crvin_check(<%= i %>,this);prev_check(this,<%=i%>);" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                </td><!--이월공제-->
                <td >
                  <input type="text" name="DONA_CRVYR<%= i %>" value="<%= data.DONA_CRVYR.equals("0000") ? "" : data.DONA_CRVYR %>" size="4" class="input04" maxlength="4" style="text-align:center"  disabled>
                </td><!--이월공제년도-->
                <td >
                  <input type="text" name="DONA_DEDPR<%= i %>" value="<%= data.DONA_DEDPR.equals("")||data.DONA_DEDPR.equals("0.0") ? "" : WebUtil.printNumFormat(data.DONA_DEDPR) %>" size="10" maxlength="11" class="<%= data.GUBUN.equals("1")||data.DONA_CRVIN.equals("")||data.GUBUN.equals("9") ? "input04" : "input03" %>" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right"  <%= data.GUBUN.equals("1")||data.DONA_CRVIN.equals("")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                </td><!--전년까지공제액-->
             <% }else{ %>
                  <input type="hidden" name="DONA_CRVIN<%=i%>" value="">
                  <input type="hidden" name="DONA_CRVYR<%=i%>" value="">
                  <input type="hidden" name="DONA_DEDPR<%=i%>" value="0">
             <% } %>
             <% if("Y".equals(pdfYn)) {%>
            <td >
             <% if(data.GUBUN.equals("1")) {%>
              <input type="checkbox" name="GUBUN<%=i%>" value="<%=  data.GUBUN %>" <%= data.GUBUN.equals("9")  ? "checked" : "" %> class="input03" disabled>
             <% }else{ %>
              <input type="checkbox" name="GUBUN<%=i%>" value="<%=  data.GUBUN.equals("9") ? "X" : "" %>" <%= data.GUBUN.equals("9")  ? "checked" : "" %> class="input03" disabled>
             <% } %>
            </td>
            <td  class="lastCol">
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> <%= !data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <%} else {%>
            	<div style="display:none">
            	<input type="checkbox" name="GUBUN<%=i%>">
            	<input type="checkbox" name="OMIT_FLAG<%=i%>">
            	</div>
            <%} %>
              </tr>
    <%
        }
    %>

    <%
        for( int i = gibu_vt.size() ; i < gibu_count ; i++ ){
    %>
              <tr class="<%=WebUtil.printOddRow(i) %>">

                <input type="hidden" name="GUBUN_SAP<%=i%>"  value="2"> <!--GUBUN 추가 20140116-->
            <input type="hidden" name="use_flag<%=i%>"  value="Y"><!--@v1.4-->
            <td ><!--@v1.4-->
              <input type="radio" name="radiobutton" value="<%=i%>" <%=(i==0) ? "checked" : "" %>>
            </td>
            <td >
              <select name="SUBTY<%=i%>"  style="width=70px" auto class="input04" disabled>
                <option value="">-------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), "") %>
              </select>
            </td>
            <td >
              <select name="F_ENAME<%=i%>"  style="width=60px" auto class="input03" onChange="javascript:subty_change(<%=i%>,this);">
                <option value="">--------</option>
<%
    // @v1.3
    old_Name = "";
    for( int j = 0 ; j < MediPeP_vt.size() ; j++ ){

        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)MediPeP_vt.get(j);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {
%>
                <option value="<%=fdata.ENAME%>"><%=fdata.ENAME%></option>
<%
        }
        old_Name = fdata.ENAME;

    }
%>

              </select>
            </td>
            <td >
              <input type="text" name="F_REGNO<%=i%>" value="" size="13" class="input04" readonly maxlength="14" onBlur="javascript:return;resno_chk(this);">
            </td>
                <td >
                  <!--<input type="hidden" name="GUBUN<%= i %>" value="2">-->
                  <select name="DONA_CODE<%= i %>"  style="width=90px" auto class="input03" onChange="javascript:dona_numb_check(<%= i %>,this);">
                    <option value="">-------------</option>
    <%= WebUtil.printOption((new D11TaxAdjustDonationTypeRFC()).getDonationType(targetYear,PERNR), "") %>
                  </select>
                </td>
                <td >
                  <input type="text" name="DONA_YYMM<%= i %>" value="" size="6" class="input03" maxlength="6" style="text-align:center" onBlur="javascript:prev_check(this,<%=i%>);if (!lastDay(<%= i %>,this)) return;">
                </td>
                <td >
                  <input type="text" name="DONA_DESC<%= i %>" value="" size="15" class="input03" maxlength="40">
                </td>

                <td >
                  <input type="text" name="DONA_NUMB<%= i %>" value="" size="10" class="input03"  maxlength="15" style="text-align:center" onBlur="javascript:name_search(this,<%=i%>);businoFormat1(<%=i%>,this);resno_chk(this);"><!-- name_search(this,< %=i%>); 박난이S 요청 -->
                </td>
                <td >
                  <input type="text" name="DONA_COMP<%= i %>" value="" size="15" class="input03" maxlength="20" onkeypress="javascript:fn_checkSpText(this);">
                </td>
                <td >
                  <input type="text" name="DONA_AMNT<%= i %>" value="" size="10" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right">
                </td>
                  <input type="hidden" name="CHNTS<%=i%>" value="" class="input03">

             <% if ( Prev_YN.equals("Y") ){ %>
                <td >
                  <input type="checkbox" name="DONA_CRVIN<%= i %>" value="" class="input03" style="text-align:center"   onClick="javascript:dona_crvin_check(<%= i %>,this);prev_check(this,<%=i%>);">
                </td><!--이월공제-->
                <td >
                  <input type="text" name="DONA_CRVYR<%= i %>" value="" class="input04" size="4" maxlength="4" style="text-align:center" disabled>
                </td><!--이월공제년도-->
                <td >
                  <input type="text" name="DONA_DEDPR<%= i %>" value="" class="input03" size="10" maxlength="11"  onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" disabled>
                </td><!--전년까지공제액-->
             <% }else{ %>
                  <input type="hidden" name="DONA_CRVIN<%=i%>" value="">
                  <input type="hidden" name="DONA_CRVYR<%=i%>" value="">
                  <input type="hidden" name="DONA_DEDPR<%=i%>" value="0">
             <% } %>
			<% if("Y".equals(pdfYn)) {%>
            <td >
             <input type="checkbox" name="GUBUN<%=i%>" value="" disabled>
            </td>
            <td  class="lastCol">
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="" class="input03" disabled>
            </td>
            <%} else {%>
            	<div style="display:none">
            	<input type="checkbox" name="GUBUN<%=i%>">
            	<input type="checkbox" name="OMIT_FLAG<%=i%>">
            	</div>
            <%} %>

              </tr>
    <%
        }
    %>
            </table>
        </div>
        <span class="commentOne"><spring:message code="LABEL.D.D11.0058" /><!-- PDF를 통하여 업로드 된 경우에는 “PDF”열에 표시되며, 반영을 취소할 경우에는 “연말정산 삭제”열에 체크 --></span>
    </div>
    <!--특별공제 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_change();"><span><spring:message code="BUTTON.COMMON.INSERT" /><!-- 입력 --></span></a></li>
            <li><a  href="javascript:cancel();"><span><spring:message code="BUTTON.COMMON.CANCEL" /><!-- 취소 --></span></a></li>
        </ul>
    </div>

<!-- 숨겨진 필드 -->
  <input type="hidden" name="jobid"      value="">
  <input type="hidden" name="targetYear" value="<%= targetYear %>">
  <input type="hidden" name="rowCount"   value="<%= gibu_vt.size() %>">
  <input type="hidden" name="gibu_count" value="<%= gibu_count %>">
  <input type="hidden" name="curr_job" value="change">
<!-- 숨겨진 필드 -->

  <input type="hidden" name="BUS01"         value="">
  <input type="hidden" name="INX"           value="">
  <input type="hidden" name="H_GUBN"        value="">
  <input type="hidden" name="DONA_CODE"     value="">
  <input type="hidden" name="DONA_CRVYR"    value="">

</form>
<iframe name="ifHidden" width="0" height="0" />
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustCardChange.jsp                                  */
/*   Description  : 신용카드.현금영수증.보험료 입력 및 조회                     */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2006-11-23                                                  */
/*                  2008-11-20  CSR ID:1361257 2008년말정산반영               */
/*                  2012-12-13  C20121213_34842 2012 년말정산  전통시장여부추가 */
/*                  2013-11-25  CSR ID:C20140106_63914 2013년말정산반영 대중교통추가  */
/*                                               신용카드: 지로영수증 삭제      */
/*                 2014-12-03 @2014 연말정산                                                            */
/* 				2018-01-04 cykim  [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건	신용카드 사용기간 컬럼 삭제	 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector card_vt    = (Vector)request.getAttribute("card_vt" );
    String rowCount   = (String)request.getAttribute("rowCount" );
    String tab_gubun  = (String)request.getAttribute("tab_gubun" );
    //@2016연말정산 sort 추가 start
    String sortField = (String)request.getAttribute("sortField");
    String sortValue = (String)request.getAttribute("sortValue");
    //@2016연말정산 sort 추가 end
//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));
    int card_count = 8;

    if( card_vt.size() > card_count ) {
        card_count = card_vt.size();
    }
    if ( Integer.parseInt(rowCount) != 8  ) {
        card_count = Integer.parseInt(rowCount);
    }
    String Gubn = "Tax09";
    if ( tab_gubun.equals("2") )
         Gubn = "Tax10";
    else
         Gubn = "Tax09";


    //@v1.3
    D11TaxAdjustPePersonRFC   rfcPeP   = new D11TaxAdjustPePersonRFC();
    Vector cardPeP_vt = new Vector();
    cardPeP_vt = rfcPeP.getPePerson( "4",user.empNo, targetYear  ); //I_GUBUN :1 - 보험료 2- 의료비  3-교육비 4-신용카드
    Vector insurancePeP_vt = new Vector();
    insurancePeP_vt = rfcPeP.getPePerson( "1",user.empNo, targetYear  ); //I_GUBUN :1 - 보험료 2- 의료비  3-교육비 4-신용카드

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

		var tbody = $('#table1 tbody');
		tbody.find(':input').each(function(){
			this.disabled = false;
		});


	}

function check_data() {
	/* [CSR ID:3569665]
	var temp = 0;//13년도 count -> 14
	var temp2 = 0;//14년도 count -> 15
	var temp1 = 0;//13년도 추가 */

<%-- [CSR ID:3569665] 	<%if(tab_gubun.equals("1")){//신용카드(1)%>
	for( var i = 0 ; i < "<%= card_count %>" ; i++ ) {
		subty    = eval("document.form1.SUBTY"+i+".value");
		/* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 start*/
		/* exprd = eval("document.form1.EXPRD_"+i+".value"); */
		/* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 end*/
		if( eval("document.form1.OMIT_FLAG"+ i + ".checked == false") ){
			/* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 로직수정 start*/
			/* org source
			if(subty=="35"&&(exprd=="2"||exprd=="3")){
				temp2 += 1;
			}
			*/
			if(subty=="35"){
				temp2 += 1;
			}
			/* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 로직수정 end*/
		}
	}
	<%}%> --%>
    for( var i = 0 ; i < "<%= card_count %>" ; i++ ) {

        subty    = eval("document.form1.SUBTY"+i+".value");
        f_ename  = eval("document.form1.F_ENAME"+i+".value");
        f_regno  = eval("document.form1.F_REGNO"+i+".value");
        egubun  = eval("document.form1.E_GUBUN"+i+".value");
        betrg = eval("document.form1.BETRG"+i+".value");
		gubun = eval("document.form1.GUBUN"+i+".value");

//@2014 연말정산 "본인"은 반드시 2013년 사용액이 입력 되어야 하며, 입력이 안되면 오류메세지 나와야 함

        if ( subty != "" ) {
<%if(tab_gubun.equals("1")){//신용카드(1)%>
			/* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 start */
			//exprd = eval("document.form1.EXPRD_"+i+".value");//@2014 연말정산 사용기간 추가
			/* if( eval("document.form1.OMIT_FLAG"+ i + ".checked == false") ){
	        	if(subty=="35"&&exprd=="1"){
	        		temp += 1;//본인 이면서 2014 사용액을 입력한 case
	        	}
	        	if(subty=="35"&&exprd=="4"){
	        		temp1 += 1;//본인 이면서 2013 사용액을 입력한 case
	        	}
				if(subty=="35"){
	        		temp += 1;//본인
	        		temp1 += 1;//본인
	        	}
        	} */

			if ( f_ename == "" || f_regno == "" || egubun == "" || betrg == ""  ) {
                alert("<spring:message code='MSG.D.D11.0014' />"); //\"관계\",\"성명\", \"주민번호\", \"구분\", \"금액\", \"사용기한\"은 필수 항목입니다.\n\n 누락된 값을 입력해주세요
                return;
            }

			/* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 */
            /* if(exprd ==""){
            	alert("<spring:message code='MSG.D.D11.0015' />"); //사용기한은 필수 항목입니다. 누락된 값을 입력해주세요.
            	return;
            } */
<%}else{%>
			if(gubun=="X") continue;//@2014 연말정산 원래 있던 로직인데... full count를 하면 저거땜에 안되니까. 조건으로 묶음
            if ( f_ename == "" || f_regno == "" || egubun == "" || betrg == ""  ) {
                alert("<spring:message code='MSG.D.D11.0016' />"); //\"관계\",\"성명\", \"주민번호\", \"구분\", \"금액\"은 필수 항목입니다.\n\n 누락된 값을 입력해주세요
                return;
            }
<%}%>
        } else {
            if ( f_ename != "" || f_regno != "" || egubun != "" || betrg != "" ) {
                alert("<spring:message code='MSG.D.D11.0017' />"); //\"관계\"는 필수 항목입니다. 선택해 주세요
                return;
            }
        }

    }//for end

<%-- <%if(tab_gubun.equals("1")){//신용카드(1)%>
    //@2014 연말정산 값이 있으면서 본인 & 2013년도 항목이 없는 경우
   	var str =  eval("document.form1.F_REGNO0.value");
    if(temp2>0&&str != ""&&(temp==0 || temp1==0 )){
    	//alert("본인 명의로 되어 있는 2013년 신용카드, 직불카드, 현금영수증\n\n 사용분을 반드시 입력해 주시기 바랍니다.");
    	alert("<spring:message code='MSG.D.D11.0018' />");//@2015 연말정산  //본인 명의로 되어 있는 2013년, 2014년 신용카드, 직불카드, \n\n현금영수증 사용분을 반드시 입력해 주시기 바랍니다.
     	return;
     }
<%}%> --%>
    return true;

}

// 신용카드.현금영수증.보험료 - 수정
function do_change() {
    if ( check_data() ) {
        eval("document.form1.BETRG_ETC.value   = removeComma(document.form1.BETRG_ETC.value);");
        for( var i = 0 ; i < "<%= card_count %>" ; i++ ) {

            eval("document.form1.BETRG"+i+".value   = removeComma(document.form1.BETRG"+i+".value);");
            eval("document.form1.BETRG_B"+i+".value   = removeComma(document.form1.BETRG_B"+i+".value);");
            eval("document.form1.BETRG_M"+i+".value   = removeComma(document.form1.BETRG_M"+i+".value);");
            eval("document.form1.BETRG_O"+i+".value   = removeComma(document.form1.BETRG_O"+i+".value);");
            eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");
<%-- <%if(tab_gubun.equals("1")){//신용카드(1)%>
			/* [CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리  */
            //eval("document.form1.EXSTX_"+i+".value  =  document.form1.EXPRD_"+i+"[document.form1.EXPRD_"+i+".selectedIndex].text;");//@2014 연말정산 사용기간 추가
<%}%> --%>
            if (  eval("document.form1.BETRG"+i+".value.length") > 9 ) {
                alert("<spring:message code='MSG.D.D11.0019' />"); //신청금액을 9자리이하로 입력하세요!
                eval("document.form1.BETRG"+i+".focus()")
                return;
            }

            if( eval("document.form1.CHNTS"+ i + ".checked == true") ) {
                eval("document.form1.CHNTS"+ i + ".value ='X';");
            } else {
                eval("document.form1.CHNTS"+ i + ".value ='';");
            }
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
	       //  if( eval("document.form1.GUBUN"+ i + ".checked == true") ) {
	       //     eval("document.form1.GUBUN"+ i + ".value ='X';");
	       // } else {
	       //     eval("document.form1.GUBUN"+ i + ".value ='';");
	       // }
	        //연말정산삭제
	         if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
	            eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
	        } else {
	            eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
	        }

            if( eval("document.form1.BETRG_B"+ i + ".value == ''") )
                eval("document.form1.BETRG_B"+ i + ".value ='0';");
            if( eval("document.form1.BETRG_M"+ i + ".value == ''") )
                eval("document.form1.BETRG_M"+ i + ".value ='0';");
            if( eval("document.form1.BETRG_O"+ i + ".value == ''") )
                eval("document.form1.BETRG_O"+ i + ".value ='0';");

             <%  if (tab_gubun.equals("1")) { //신용카드/현금 %>

             //C20121213_34842 2012
             if( eval("document.form1.TRDMK"+ i + ".checked == true") ) {
                 eval("document.form1.TRDMK"+ i + ".value ='X';");
             } else {
                 eval("document.form1.TRDMK"+ i + ".value ='';");
             }
	     //CSR ID:C20140106_63914 대중교통추가
             eval("document.form1.CCTRA"+i+".disabled  = false;");
             if( eval("document.form1.CCTRA"+ i + ".checked == true") ) {
                 eval("document.form1.CCTRA"+ i + ".value ='X';");
             } else {
                 eval("document.form1.CCTRA"+ i + ".value ='';");
             }
             //@2014 연말정산
             /* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 start*/
             <%--
             <%if(tab_gubun.equals("1")){//신용카드(1)%>
              eval("document.form1.EXPRD_"+i+".disabled  = false;");
             <% }
             --%>
             /* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 end */
             <%} %>

        }

        //세대주여부
        eval("document.form1.FSTID.disabled = false;") ; //세대주여부
  	 	 if( eval("document.form1.FSTID.checked == true") ){
       	 	eval("document.form1.FSTID.value ='X';");
  	 	 }

        //필드 enable처리
        setEnable();
        document.form1.jobid.value = "change";
        document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV";
        document.form1.method      = "post";
        document.form1.target      = "menuContentIframe";
        document.form1.submit();
    }
}

/* 의료비 입력항목 1개 추가 */
function add_field(){
    document.form1.rowCount.value = document.form1.card_count.value = parseInt(document.form1.card_count.value) + 1; //@v1.4

    eval("document.form1.BETRG_ETC.value   = removeComma(document.form1.BETRG_ETC.value);");
    for( var i = 0 ; i < "<%= card_count %>" ; i++ ) {
        eval("document.form1.BETRG"+i+".value   = removeComma(document.form1.BETRG"+i+".value);");
        eval("document.form1.BETRG_B"+i+".value   = removeComma(document.form1.BETRG_B"+i+".value);");
        eval("document.form1.BETRG_M"+i+".value   = removeComma(document.form1.BETRG_M"+i+".value);");
        eval("document.form1.BETRG_O"+i+".value   = removeComma(document.form1.BETRG_O"+i+".value);");
        eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");

        if( eval("document.form1.CHNTS"+ i + ".checked == true") ) {
            eval("document.form1.CHNTS"+ i + ".value ='X';");
        } else {
            eval("document.form1.CHNTS"+ i + ".value ='';");
        }

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


        <%  if (tab_gubun.equals("1")) { //신용카드/현금 %>
        //C20121213_34842 2012
        if( eval("document.form1.TRDMK"+ i + ".checked == true") ) {
            eval("document.form1.TRDMK"+ i + ".value ='X';");
        } else {
            eval("document.form1.TRDMK"+ i + ".value ='';");
        }
	//CSR ID:C20140106_63914 대중교통추가
        if( eval("document.form1.CCTRA"+ i + ".checked == true") ) {
            eval("document.form1.CCTRA"+ i + ".value ='X';");
        } else {
            eval("document.form1.CCTRA"+ i + ".value ='';");
        }
        <% } %>

    }

    //필드 enable처리
    setEnable();
    document.form1.jobid.value = "AddorDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

/* 의료비 입력항목 아래항목 지우기 */
function remove_field(){
	var delchk = false;
    //선택 삭제 추가
    document.form1.rowCount.value = parseInt(document.form1.card_count.value) - 1;

    for( var i = 0 ; i < "<%= card_count %>" ; i++ ) {

        if( isNaN( document.form1.radiobutton.length ) ){
            eval("document.form1.use_flag0.value = 'N'");
            if(!delchk){
                delchk = true;
            }
            if (document.form1.radiobutton.checked == true &&  eval("document.form1.GUBUN"+i+".value") == "1"     )  {
                alert("<spring:message code='MSG.D.D11.0027' />"); //자동반영분은 삭제할 수 없습니다.
                return;
            }
        } else {
            if ( document.form1.radiobutton[i].checked == true ) {
                eval("document.form1.use_flag"+ i +".value = 'N'");
                if(!delchk){
                    delchk = true;
                }
            }

            if (document.form1.radiobutton[i].checked == true &&  eval("document.form1.GUBUN"+i+".value") == "1"     )  {
                alert("<spring:message code='MSG.D.D11.0027' />"); //자동반영분은 삭제할 수 없습니다.
                return;
            }
        }

    }
    if ( document.form1.card_count.value == 0 ) {
        alert("<spring:message code='MSG.D.D11.0020' /> "); //입력항목을 더이상 줄일수 없습니다.
        return;
    }

    if(!delchk) {
        alert("<spring:message code='MSG.D.D11.0021' />"); //삭제할 건을 선택하세요.
        return;
    }

    var row=0;
    row = "<%= card_count - 1 %>";


    eval("document.form1.BETRG_ETC.value   = removeComma(document.form1.BETRG_ETC.value);");
    for( var i = 0 ; i < "<%= card_count %>" ; i++ ) {
        eval("document.form1.BETRG"+i+".value   = removeComma(document.form1.BETRG"+i+".value);");
        eval("document.form1.BETRG_B"+i+".value   = removeComma(document.form1.BETRG_B"+i+".value);");
        eval("document.form1.BETRG_M"+i+".value   = removeComma(document.form1.BETRG_M"+i+".value);");
        eval("document.form1.BETRG_O"+i+".value   = removeComma(document.form1.BETRG_O"+i+".value);");
        eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");

        if( eval("document.form1.CHNTS"+ i + ".checked == true") ) {
            eval("document.form1.CHNTS"+ i + ".value ='X';");
        } else {
            eval("document.form1.CHNTS"+ i + ".value ='';");
        }

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

        <%  if (tab_gubun.equals("1")) { //신용카드/현금 %>
        //C20121213_34842 2012
        if( eval("document.form1.TRDMK"+ i + ".checked == true") ) {
            eval("document.form1.TRDMK"+ i + ".value ='X';");
        } else {
            eval("document.form1.TRDMK"+ i + ".value ='';");
        }
	//CSR ID:C20140106_63914 대중교통추가
        if( eval("document.form1.CCTRA"+ i + ".checked == true") ) {
            eval("document.form1.CCTRA"+ i + ".value ='X';");
        } else {
            eval("document.form1.CCTRA"+ i + ".value ='';");
        }
        <% } %>
    }

	//필드 enable처리
    setEnable();
    document.form1.jobid.value = "AddorDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function resno_chk(obj){
    if( chkResnoObj_1(obj) == false ) {
        return false;
    }
}


// 값이 변경되었는지 체크한다
function chk_change() {
    flag = false;


//2003.12.26.mkbae.    if( flag ) {
//        if( confirm( "변경된 내용이 존재합니다.\n저장하시겠습니까?") ){
//            return true;
//        } else {
//            return false;
//        }
//    }
}

// onLoad시 호출됨.
function first(){
   <% if (tab_gubun.equals("1")) { //신용카드/현금  %>
   alert("<spring:message code='MSG.D.D11.0022' />"); //신용카드/직불카드/현금영수증은 반드시 \"일반\" 과 \"전통시장\" 과 \n\"대중교통\"으로 구분하여 입력해주시기 바랍니다.\n\n영수증상에 전통시장 및 대중교통으로 표시되는 금액은 반드시 \n\"전통시장\" 또는 \"대중교통\" 체크박스에 \"V\"체크 해주시기 바랍니다.
   <% } %>
     return;
}

function businoFormat1(i,obj) {
    if ( eval("document.form1.CHNTS"+i+".value") == "X" )
        return false;
    else
        businoFormat(obj);
}

//@v1.2 성명변경시 관계 값 선택
function subty_change(row, obj) {
 	var val = obj[obj.selectedIndex].value;//DREL_CODE
    var inx = obj.selectedIndex;
    if( inx > 0 ) {
        var fami_rlat =  eval( "document.form1.FAMI_RLAT"+(inx-1)+".value"); //선택된 성명의 관계코드
        var fami_regn =  eval( "document.form1.FAMI_REGN"+(inx-1)+".value"); //선택된 성명의 주민번호
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
        eval( "document.form1.E_GUBUN"+row+"[0].selected = true;");
        eval( "document.form1.BETRG"+row+".value = \"\";");
        //eval( "document.form1.BETRG_B"+row+".value = \"\";");
        eval("document.form1.CHNTS"+row+".checked = false;");
    }
    <%  if (tab_gubun.equals("1")) { //신용카드/현금 %>
    eval("document.form1.CHNTS"+row+".checked = false;");
    /* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 start*/
    //eval("document.form1.EXPRD_"+row+".selectedIndex = 0;");//@2014 연말정산
    /* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 end*/
    <% } %>

    do_check(row, obj);
}
//@v1.2 성명,구분 변경시
function do_check(row, obj) {
    // 1. 현금영수증공제:2 인 경우 자동으로 체크되어 비활성화
    eval( "document.form1.CHNTS"+row+".disabled  = false;");
    eval( "document.form1.CHNTS"+ row + ".checked = false");

    eval( "document.form1.BETRG"+row+".disabled  = false;");
    eval( "document.form1.BETRG_B"+row+".value = \"\";");
    eval( "document.form1.BETRG_B"+row+".disabled  = true;");
    eval( "document.form1.BETRG_M"+row+".disabled  = false;");
    eval( "document.form1.BETRG_O"+row+".disabled  = false;");

    if ( eval("document.form1.E_GUBUN"+row+".value;")=="2" ) {
         eval("document.form1.CHNTS"+ row + ".checked = true");
         eval( "document.form1.CHNTS"+row+".disabled  = true;");
    }
    if ( eval("document.form1.E_GUBUN"+row+".value;")=="5" ) { //지로영수증
         eval("document.form1.CHNTS"+ row + ".checked = false");
         eval( "document.form1.CHNTS"+row+".disabled  = true;");
    }

    <%  if (tab_gubun.equals("1")) { //신용카드/현금 %>
    if ( eval("document.form1.E_GUBUN"+row+".value;")=="5" ) { //지로영수증
         eval("document.form1.TRDMK"+ row + ".checked = false"); //C20121213_34842 2012
         eval( "document.form1.TRDMK"+row+".disabled  = true;"); //C20121213_34842 2012
         eval("document.form1.CCTRA"+ row + ".checked = false"); //CSR ID:C20140106_63914 대중교통
         eval( "document.form1.CCTRA"+row+".disabled  = true;"); //CSR ID:C20140106_63914 대중교통
    }else{
         eval( "document.form1.TRDMK"+row+".disabled  = false;"); //C20121213_34842 2012
         eval( "document.form1.CCTRA"+row+".disabled  = false;"); //CSR ID:C20140106_63914 대중교통
    }
    <% } %>

    //인적공제 대상이 장애인인 경우에만 장애인 보험만 선택할수 있다
    var valInx = eval("document.form1.F_ENAME"+row+".selectedIndex");
    if (valInx <1 ) return

    if ( eval("document.form1.E_GUBUN"+row+".value;")=="4" &&  eval( "document.form1.FAMI_B002"+(valInx-1)+".value") !="X" ) { //장애인 보험료
         alert("<spring:message code='MSG.D.D11.0023' />"); //장애 대상자만 선택 가능합니다
         eval( "document.form1.E_GUBUN"+row+"[0].selected = true;");
         return;
    }



    // 2. 금액비활성화: 신용카드:1/현금영수증공제:2 인 경우에 형제자매인 경우 금액 입력 안되도록 비활성화
    //관계코드 : 07-형(오빠), 08-제(남동생), 09-자(누나/언니), 10-매(여동생), 28-처형제, 29-처자매
    var notValue = new Array("07",
                             "08",
                             "09",
                             "10",
                             "28",
                             "29");

    if ( eval("document.form1.E_GUBUN"+row+".value;") == "1" || eval("document.form1.E_GUBUN"+row+".value;")=="2" ||
         eval("document.form1.E_GUBUN"+row+".value;") == "5" || eval("document.form1.E_GUBUN"+row+".value;")=="6"
        ) {
        for (r=0;r< notValue.length;r++) {
           if ( eval("document.form1.SUBTY"+row+".value;") == notValue[r]) {
              eval( "document.form1.BETRG"+row+".value = \"\";");
              eval( "document.form1.BETRG"+row+".disabled  = true;");
              eval( "document.form1.BETRG_M"+row+".value = \"\";");
              eval( "document.form1.BETRG_M"+row+".disabled  = true;");
              eval( "document.form1.BETRG_O"+row+".value = \"\";");
              eval( "document.form1.BETRG_O"+row+".disabled  = true;");
              alert("<spring:message code='MSG.D.D11.0024' />"); //형제자매는 공제대상이 아닙니다.
           }
        }
    }

}
//C20121213_34842
function check_TrdmkCctra(obj,gubn, row) {
   //CSR ID:C20140106_63914 전통시장과 대중교통중 한가지만 체크

   if( gubn=="1"){
	if ( eval( "document.form1.TRDMK"+row+".checked  == true;") ){
         eval("document.form1.CCTRA"+ row + ".checked = false");
   	}
   }else if( gubn=="2"){
	   if ( eval( "document.form1.CCTRA"+row+".checked  == true;") ){
	         eval("document.form1.TRDMK"+ row + ".checked = false");
	   }
   }
   return;
   if ( obj.checked == true ) {
        alert("<spring:message code='MSG.D.D11.0025' />"); //온누리 상품권 사용만으로는 공제 불가능 하며, 반드시 현금영수증으로 처리해야 함
   }
}

//@2014 연말정산 사용기간의 경우 2013은 본인일 경우만 선택 가능함.
/* [CSR ID:3569665] 2017 연말정산 사용기간 삭제로 주석처리 */
/* function check_UseCardPeriod(obj, row){
	subty    = eval("document.form1.SUBTY"+row+".value");
	if(subty!=""&&subty!="35"&&(obj.value==1||obj.value==4)){
		//alert("2013년도 신용카드 등은 본인만 입력가능합니다.");
		alert("<spring:message code='MSG.D.D11.0026' />");//@2015 연말정산  //2013년, 2014년도 신용카드 등은 본인만 입력가능합니다.
		obj.selectedIndex = 0;
	}
} */
$(function() {
	first();
});

//입력취소
function cancel(){
    if(confirm("<spring:message code='MSG.D.D11.0038' />")){ //입력작업을 취소하시겠습니까?
        document.form1.jobid.value = "first";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV?tab_gubun=<%=tab_gubun%>";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}

//@2016연말정산 sort 추가 start
function get_Page(){
    document.form1.action = '<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustCardSV';
    document.form1.method = "post";
    document.form1.jobid.value = "change_first";
    document.form1.submit();

}

function sortPage( FieldName, FieldValue ){
	  if(document.form1.sortField.value==FieldName){
	      if(document.form1.sortValue.value == 'asc') {
	        document.form1.sortValue.value = 'desc';
	      } else {
	        document.form1.sortValue.value = 'asc';
	      }
	  } else {
	    document.form1.sortField.value = FieldName;
	    document.form1.sortValue.value = FieldValue;
	  }
	  get_Page();
	}
//@2016연말정산 sort 추가 end
//-->
</SCRIPT>


 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>
<form name="form1" method="post">

<%@ include file="D11TaxAdjustButton.jsp" %>

<%      if (tab_gubun.equals("1")) { //신용카드/현금
%>
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
        <!--특별공제 테이블 시작-->
		<thead>
          <tr>
            <th><spring:message code="LABEL.D.D11.0047" /><!-- 선택 --></th>
            <th><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
            <th onClick="javascript:sortPage('F_ENAME','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --><%= WebUtil.printSort("F_ENAME",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('F_REGNO','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --><%= WebUtil.printSort("F_REGNO",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('GU_NAME','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --><%= WebUtil.printSort("GU_NAME",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('BETRG','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0048" /><!-- 공제대상액 --><%= WebUtil.printSort("BETRG",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('TRDMK','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0074" /><!-- 전통<br>시장 --><%= WebUtil.printSort("TRDMK",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('CCTRA','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0075" /><!-- 대중<br>교통 --><%= WebUtil.printSort("CCTRA",sortField,sortValue)%></th>
            <!-- [CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 start-->
            <%-- <th onClick="javascript:sortPage('EXSTX','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0051" /><!-- 사용기간 --><%= WebUtil.printSort("EXSTX",sortField,sortValue)%></th><!-- @2014 연말정산 -->
 			--%>
 			<!-- [CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 end -->
            <th onClick="javascript:sortPage('BETRG_B','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0052" /><!-- 회사비용 정리금 --><%= WebUtil.printSort("BETRG_B",sortField,sortValue)%></th>
            <th class="<%=!"Y".equals(pdfYn) ? "lastCol": ""%>" onClick="javascript:sortPage('CHNTS','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0076" /><!-- 국세청<br>자료 --><%= WebUtil.printSort("CHNTS",sortField,sortValue)%></th>
            <% if("Y".equals(pdfYn)) {%>
            <th onClick="javascript:sortPage('GUBUN','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --><%= WebUtil.printSort("GUBUN",sortField,sortValue)%></th>
            <th class="lastCol"  onClick="javascript:sortPage('OMIT_FLAG','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0077" /><!-- 연말<br>정산<br>삭제 --><%= WebUtil.printSort("OMIT_FLAG",sortField,sortValue)%></th>
            <%} %>
          </tr>
          </thead>
<%
    String old_Name = "";
    int index = 0;
    // @v1.3
    for( int j = 0 ; j < cardPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)cardPeP_vt.get(j);
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
    String BETRG_Display ="";
    String Gubun_Display ="";
    for( int i = 0 ; i < card_vt.size() ; i++ ){
        D11TaxAdjustCardData data = (D11TaxAdjustCardData)card_vt.get(i);
        // 2. 금액비활성화: 신용카드:1/현금영수증공제:2 인 경우에 형제자매인 경우 금액 입력 안되도록 비활성화
        //관계코드 : 07-형(오빠), 08-제(남동생), 09-자(누나/언니), 10-매(여동생), 28-처형제, 29-처자매
        if ( data.E_GUBUN.equals("1") || data.E_GUBUN.equals("2")||data.E_GUBUN.equals("5") || data.E_GUBUN.equals("6") ) {
             if ( data.SUBTY.equals("07") ||data.SUBTY.equals("08") ||data.SUBTY.equals("09") ||data.SUBTY.equals("10") ||data.SUBTY.equals("28") ||data.SUBTY.equals("29") ) {
                 BETRG_Display ="disabled";
             }
             else {
                 BETRG_Display ="";
             }
        }

        if (data.GUBUN.equals("1") ) { //회사지원분
             Gubun_Display ="disabled";
        }else {
             Gubun_Display ="";
        }
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">

            <input type="hidden" name="GUBUN_SAP<%=i%>"  value="<%= data.GUBUN %>"> <!--GUBUN 추가 20140116-->
            <input type="hidden" name="use_flag<%=i%>"  value="Y">
            <td >
              <input type="radio" name="radiobutton" value="<%=i%>" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td >
              <select name="SUBTY<%=i%>"  disabled>
                <option value="">-------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %>
              </select>
            </td>
            <td >
              <select name="F_ENAME<%=i%>" class="<%= data.GUBUN.equals("9")  ? "input04" : "input03" %>" onChange="javascript:subty_change(<%=i%>,this);" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                <option value="">--------</option>
<%
    //@v1.3
    old_Name = "";
    for( int j = 0 ; j < cardPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)cardPeP_vt.get(j);
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
              <input type="text" name="F_REGNO<%=i%>" value="<%= data.F_REGNO.equals("") ? "" : DataUtil.addSeparate(data.F_REGNO) %>" size="13" class="input04" maxlength="14" onBlur="javascript:resno_chk(this);" readonly disabled>
            </td>
            <td >
              <select name="E_GUBUN<%=i%>" class="<%= data.GUBUN.equals("9")  ? "input04" : "input03" %>"  onChange="javascript:do_check(<%=i%>,this);" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                <option value="">-------------</option>
                <option value="1" <%= data.E_GUBUN.equals("1") ? "selected" : "" %>><spring:message code="LABEL.D.D11.0039" /><!-- 신용카드 --></option>
                <option value="2" <%= data.E_GUBUN.equals("2") ? "selected" : "" %>><spring:message code="LABEL.D.D11.0056" /><!-- 현금영수증 --></option>
                <!--<option value="5" <%= data.E_GUBUN.equals("5") ? "selected" : "" %>>지로영수증</option> CSR ID :C20140106_63914-->
                <option value="6" <%= data.E_GUBUN.equals("6") ? "selected" : "" %>><spring:message code="LABEL.D.D11.0057" /><!-- 직불/선불카드 --></option>
              </select>
            </td>
            <td >
              <input type="text" name="BETRG<%=i%>" value="<%= data.BETRG.equals("")  ? "" : WebUtil.printNumFormat(data.BETRG) %>" size="15" maxlength="11" class="<%= data.GUBUN.equals("9")  ? "input04" : "input03" %>" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" <%=BETRG_Display%> onFocus="this.select()" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <!--C20121213_34842 2012 전통시장여부 -->
            <td >
              <input type="checkbox" name="TRDMK<%=i%>" value="<%=  data.TRDMK.equals("") ? "" : data.TRDMK %>" <%= data.TRDMK.equals("X")  ? "checked" : "" %> class="input03" <%=  data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "" %> <%=Gubun_Display%>   onClick="javascript:check_TrdmkCctra(this,'1',<%=i%>);">
            </td>
            <!--CSR ID:C20140106_63914 대중교통추가 -->
            <td >
              <input type="checkbox" name="CCTRA<%=i%>" value="<%=  data.CCTRA.equals("") ? "" : data.CCTRA %>" <%= data.CCTRA.equals("X")  ? "checked" : "" %> class="input03" <%=  data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "" %> <%=Gubun_Display%>   onClick="javascript:check_TrdmkCctra(this,'2',<%=i%>);">
            </td>
            <!-- @2014 연말정산 사용기간 text/code추가  -->
            <!-- [CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 start -->
            <%-- <td >
             <select name="EXPRD_<%= i %>"  class="<%= data.GUBUN.equals("9")  ? "input04" : "input03" %>" onchange="check_UseCardPeriod(this,<%=i%>);" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
             <option value="">-------------</option>
    <%= WebUtil.printOption((new D11TaxAdjustCardUseYearComboRFC()).getCardUseYearCombo(targetYear), data.EXPRD) %>
            </select>
            <input type="hidden" name="EXSTX_<%= i %>" value="" size="30" maxlength=100  class="input03">
          </td> --%>
          	<!-- [CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 end -->
            <td >
              <input type="text" name="BETRG_B<%=i%>" value="<%= data.BETRG_B.equals("")  ? "" : WebUtil.printNumFormat(data.BETRG_B) %>" size="15" maxlength="11" class="input03"  <%=  data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %> onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right"  disabled onFocus="this.select()">
            </td>
            <td class="<%=!"Y".equals(pdfYn) ? "lastCol": ""%>" >
              <input type="checkbox" name="CHNTS<%=i%>" value="<%=  data.CHNTS.equals("") ? "" : data.CHNTS %>" <%= data.CHNTS.equals("X")  ? "checked" : "" %> class="input03" <%=  data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "" %> <%=Gubun_Display%> >
            </td>
            <% if("Y".equals(pdfYn)) {%>
            <td >
             <input type="checkbox" name="GUBUN<%=i%>" value="<%=  data.GUBUN.equals("9") ? "X" : "" %>" <%= data.GUBUN.equals("9")  ? "checked" : "" %> class="input03" disabled>
            </td>
            <td class="lastCol">
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> class="input03" <%= !data.GUBUN.equals("9") ? "disabled" : "" %> >
            </td>
            <%} else {%>
            	<div style="display:none">
            	<input type="checkbox" name="GUBUN<%=i%>">
            	<input type="checkbox" name="OMIT_FLAG<%=i%>">
            	</div>
            <%} %>
          </tr>
            <input type="hidden" name="BETRG_O<%=i%>">
            <input type="hidden" name="BETRG_M<%=i%>">
<%
    }
%>
<%
    for( int i = card_vt.size() ; i < card_count ; i++ ){
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <input type="hidden" name="GUBUN<%=i%>"  value="">
            <input type="hidden" name="GUBUN_SAP<%=i%>"  value="2"> <!--GUBUN 추가 20140116 입력분-->
            <input type="hidden" name="use_flag<%=i%>"  value="Y"><!--@v1.4-->
            <td ><!--@v1.4-->
              <input type="radio" name="radiobutton" value="<%=i%>" <%=(i==0) ? "checked" : "" %>>
            </td>

            <td >
              <select name="SUBTY<%=i%>" class="input04" disabled>
                <option value="">-------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), "") %>
              </select>
            </td>
            <td >
              <select name="F_ENAME<%=i%>" class="input03" onChange="javascript:subty_change(<%=i%>,this);">
                <option value="">--------</option>
<%
    //@v1.3
    old_Name = "";
    for( int j = 0 ; j < cardPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)cardPeP_vt.get(j);
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
              <input type="text" name="F_REGNO<%=i%>" value="" size="13" class="input04" readonly maxlength="14" onBlur="javascript:return;resno_chk(this);" disabled>
            </td>
            <td >
              <select name="E_GUBUN<%=i%>" class="input03"  onChange="javascript:do_check(<%=i%>,this);">
                <option value="">-------------</option>
                <option value="1"><spring:message code="LABEL.D.D11.0039" /><!-- 신용카드 --></option>
                <option value="2"><spring:message code="LABEL.D.D11.0056" /><!-- 현금영수증 --></option>
                <!--<option value="5">지로영수증</option>CSR ID :C20140106_63914-->
                <option value="6"><spring:message code="LABEL.D.D11.0057" /><!-- 직불/선불카드 --></option>

              </select>
            </td>
            <td >
              <input type="text" name="BETRG<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right">
            </td>
            <!--C20121213_34842 2012 전통시장여부 -->
            <td >
              <input type="checkbox" name="TRDMK<%=i%>" value=""  class="input03"  onClick="javascript:check_TrdmkCctra(this,'1',<%=i%>);">
            </td>
            <!--CSR ID:C20140106_63914 대중교통추가 -->
            <td >
              <input type="checkbox" name="CCTRA<%=i%>" value=""  class="input03" onClick="javascript:check_TrdmkCctra(this,'2',<%=i%>);">
            </td>
            <!-- @2014 연말정산 사용기간 text/code추가  -->
            <!-- [CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 start -->
            <%-- <td >
             <select name="EXPRD_<%= i %>"  class="input03"  onchange="check_UseCardPeriod(this,<%=i%>);">
             <option value="">-------------</option>
    			<%= WebUtil.printOption((new D11TaxAdjustCardUseYearComboRFC()).getCardUseYearCombo(targetYear)) %>
            </select>
            <input type="hidden" name="EXSTX_<%= i %>" value="" size="30" maxlength=100  class="input03">
          </td> --%>
          	<!-- [CSR ID:3569665] @2017 연말정산 사용기간 삭제로 주석처리 end -->
            <td >
              <input type="text" name="BETRG_B<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" disabled>
            </td>

            <td >
              <input type="checkbox" name="CHNTS<%=i%>" value="" class="input03">
            </td>
            <% if("Y".equals(pdfYn)) {%>
            <td >
             <input type="checkbox" name="GUBUN<%=i%>" value="" disabled>
            </td>
            <td class="lastCol">
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="" class="input03" disabled>
            </td>
            <%} else {%>
            	<div style="display:none">
            	<input type="checkbox" name="GUBUN<%=i%>">
            	<input type="checkbox" name="OMIT_FLAG<%=i%>">
            	</div>
            <%} %>
          </tr>

            <input type="hidden" name="BETRG_O<%=i%>">
            <input type="hidden" name="BETRG_M<%=i%>">
<%
    }
%>
        </table>
        <!--특별공제 테이블 끝-->
        </div>
        </div>
        <!--특별공제 테이블 끝-->

    <div class="commentImportant" >
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <!--[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  -->
        <p><span class="bold"><spring:message code="LABEL.D.D11.0285" /><!-- 1. 중도 입사자의 경우 근로기간의 카드 사용액만 입력 --></span></p>
        <p><span class="bold"><spring:message code="LABEL.D.D11.0060" /><!-- 2. 입력하는 방법 --></span></p>
        <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
        <p><span class="bold">&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0080" /><!-- <b>ⓐ 구분</b> : 신용카드/직불(선불카드)/현금영수증을 정확하게 입력해야 함 --></span></p>
    	<p><span class="bold">&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0081" /><!-- <b>ⓑ 공제대상액</b> : 신용카드 영수증 및 현금영수증은 일반 공제 대상 금액이라고 나와있는 부분을 그대로 입력 --></span></p>
    	<p><span class="bold"><font color=red>&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0082" /><!-- <b>ⓒ 전통시장/대중교통</b> : <u>신용카드 영수증 및 현금영수증에 전통시장으로 구분 되어 있는 경우 반드시 체크 --></u></font></span></p>
    	<p><span class="bold"><font color=red>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><spring:message code="LABEL.D.D11.0064" /><!-- →하나의 영수증에 일반공제/전통시장/대중교통으로 구분되어 있는 경우 각각 구분해서 입력해야 함 --></b></font></span></p>
    	<!--[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  -->
    	<%-- <p><span class="bold"><font color=red>&nbsp;&nbsp;&nbsp;<b><spring:message code="LABEL.D.D11.0065" /><!-- ⓓ 사용기간 : 본인이 사용한 신용카드, 직불카드, 현금영수증은 반드시 2014년, 2015년 사용액으로 구분하여 입력해야함 --></b></font></span></p> --%> <!-- @2015 연말정산 -->
    	<p><span class="bold">&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0083" /><!-- <b>ⓓ 회사비용 정리금</b> : 개인카드 사용 후 회사비용으로 정리한 경우 관할 부서에서 일괄 반영할 예정임 --></span></p>
    	<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
    	<p><span class="bold"><spring:message code="LABEL.D.D11.0067" /><!-- 2. 신용카드가 연급여(HR Center > 인사정보 > 급여 > 연급여)에서 지급계의 25% 이하인 경우 공제 안되므로 입력할 필요 없음 --></span></p>
    	<p><span class="bold"><spring:message code="LABEL.D.D11.0068" /><!-- ※ 온누리 상품권 사용만으로는 공제 불가능 하며, 반드시 현금영수증으로 처리해야 함 --></span></p>
  		<!--[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  -->
    	<p><span class="bold"><spring:message code="LABEL.D.D11.0284" /><!-- ※ 중도 입사자의 경우 근로기간의 카드 사용액만 입력 --></span></p>
    	<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
  </div>



<% } //신용카드
   else { //보험료
%>
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
            <table class="listTable"  id="table1">
        <!--특별공제 테이블 시작-->
		<thead>

          <tr>
            <th><spring:message code="LABEL.D.D11.0047" /><!-- 선택 --></th>
            <th><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
            <th onClick="javascript:sortPage('F_ENAME','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --><%= WebUtil.printSort("F_ENAME",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('F_REGNO','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --><%= WebUtil.printSort("F_REGNO",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('GU_NAME','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --><%= WebUtil.printSort("GU_NAME",sortField,sortValue)%></th>
            <th onClick="javascript:sortPage('BETRG','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --><%= WebUtil.printSort("BETRG",sortField,sortValue)%></th>
            <th class="<%=!"Y".equals(pdfYn) ? "lastCol": ""%>" onClick="javascript:sortPage('CHNTS','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0053" /><!-- 국세청자료 --><%= WebUtil.printSort("CHNTS",sortField,sortValue)%></th>
            <% if("Y".equals(pdfYn)) {%>
            <th onClick="javascript:sortPage('GUBUN','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --><%= WebUtil.printSort("GUBUN",sortField,sortValue)%></th>
            <th class="lastCol"  onClick="javascript:sortPage('OMIT_FLAG','desc')" style="cursor:hand"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --><%= WebUtil.printSort("OMIT_FLAG",sortField,sortValue)%></th>
            <%} %>
          </tr>
          </thead>
<%
    String old_Name = "";
    int index = 0;
    // @v1.3
    for( int j = 0 ; j < insurancePeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)insurancePeP_vt.get(j);
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
    String BETRG_Display ="";
    for( int i = 0 ; i < card_vt.size() ; i++ ){
        D11TaxAdjustCardData data = (D11TaxAdjustCardData)card_vt.get(i);
        // 2. 금액비활성화: 신용카드:1/현금영수증공제:2 인 경우에 형제자매인 경우 금액 입력 안되도록 비활성화
        //관계코드 : 07-형(오빠), 08-제(남동생), 09-자(누나/언니), 10-매(여동생), 28-처형제, 29-처자매
        if ( data.E_GUBUN.equals("1") || data.E_GUBUN.equals("2") ) {
             if ( data.SUBTY.equals("07") ||data.SUBTY.equals("08") ||data.SUBTY.equals("09") ||data.SUBTY.equals("10") ||data.SUBTY.equals("28") ||data.SUBTY.equals("29") ) {
                 BETRG_Display ="disabled";
             }
             else {
                 BETRG_Display ="";
             }
        }

%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <td >
            <input type="hidden" name="use_flag<%=i%>"  value="Y">
            <input type="hidden" name="GUBUN_SAP<%=i%>"  value="<%= data.GUBUN %>"> <!--GUBUN 추가 20140116-->
              <input type="radio" name="radiobutton" value="<%=i%>" <%= data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td >
              <select name="SUBTY<%=i%>" class="input04" disabled>
                <option value="">-------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %>
              </select>
            </td>
            <td >
              <select name="F_ENAME<%=i%>" class="<%= data.GUBUN.equals("9")  ? "input04" : "input03" %>" onChange="javascript:subty_change(<%=i%>,this);" <%= data.GUBUN.equals("9") ? "disabled" : "" %>>
                <option value="">--------</option>

<%
    //@v1.3
    old_Name = "";
    for( int j = 0 ; j < insurancePeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)insurancePeP_vt.get(j);
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
              <input type="text" name="F_REGNO<%=i%>" value="<%= data.F_REGNO.equals("") ? "" : DataUtil.addSeparate(data.F_REGNO) %>" size="13" class="input04" maxlength="14" onBlur="javascript:resno_chk(this);" readonly disabled>
            </td>
            <td >
              <select name="E_GUBUN<%=i%>" class="<%= data.GUBUN.equals("9")  ? "input04" : "input03" %>"  onChange="javascript:do_check(<%=i%>,this);" <%= data.GUBUN.equals("9") ? "disabled" : "" %>>
                <option value="">-------------</option>

                <option value="3" <%= data.E_GUBUN.equals("3") ? "selected" : "" %>><spring:message code="LABEL.D.D11.0071" /><!-- 보장성보험료 --></option>
                <option value="4" <%= data.E_GUBUN.equals("4") ? "selected" : "" %>><spring:message code="LABEL.D.D11.0072" /><!-- 장애인보험료 --></option>
              </select>
            </td>
            <td >
              <input type="text" name="BETRG<%=i%>" value="<%= data.BETRG.equals("")  ? "" : WebUtil.printNumFormat(data.BETRG) %>" size="15" maxlength="11" class="<%= data.GUBUN.equals("9")  ? "input04" : "input03" %>" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" <%=BETRG_Display%> onFocus="this.select()" <%= data.GUBUN.equals("9") ? "disabled" : "" %>>

            </td>
            <td >
              <input type="checkbox" class="<%=!"Y".equals(pdfYn) ? "lastCol": ""%>" name="CHNTS<%=i%>" value="<%=  data.CHNTS.equals("") ? "" : data.CHNTS %>" <%= data.CHNTS.equals("X")  ? "checked" : "" %> class="input03" <%=  data.E_GUBUN.equals("2")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <% if("Y".equals(pdfYn)) {%>
            <td >
             <input type="checkbox" name="GUBUN<%=i%>" value="<%=  data.GUBUN.equals("9") ? "X" : "" %>" <%= data.GUBUN.equals("9")  ? "checked" : "" %> class="input03" disabled>
            </td>
            <td class="lastCol">
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> class="input03" <%= !data.GUBUN.equals("9") ? "disabled" : "" %> >
            </td>
            <%} else {%>
            	<div style="display:none">
            	<input type="checkbox" name="GUBUN<%=i%>">
            	<input type="checkbox" name="OMIT_FLAG<%=i%>">
            	</div>
            <%} %>
            <input type="hidden" name="BETRG_O<%=i%>">
            <input type="hidden" name="BETRG_M<%=i%>">
            <input type="hidden" name="BETRG_B<%=i%>">
          </tr>
<%
    }
%>
<%
    for( int i = card_vt.size() ; i < card_count ; i++ ){
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <input type="hidden" name="use_flag<%=i%>"  value="Y"><!--@v1.4-->
            <input type="hidden" name="GUBUN_SAP<%=i%>"  value="2"> <!--GUBUN 추가 20140116-->

            <td ><!--@v1.4-->
              <input type="radio" name="radiobutton" value="<%=i%>" <%=(i==0) ? "checked" : "" %>>
            </td>

            <td >
              <select name="SUBTY<%=i%>" class="input04" disabled>
                <option value="">-------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), "") %>
              </select>
            </td>
            <td >
              <select name="F_ENAME<%=i%>" class="input03" onChange="javascript:subty_change(<%=i%>,this);">
                <option value="">--------</option>
<%
    // @v1.3
    old_Name = "";
    for( int j = 0 ; j < insurancePeP_vt.size() ; j++ ){

        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)insurancePeP_vt.get(j);
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
              <input type="text" name="F_REGNO<%=i%>" value="" size="13" class="input04" readonly maxlength="14" onBlur="javascript:return;resno_chk(this);" disabled>
            </td>
            <td >
              <select name="E_GUBUN<%=i%>" class="input03"  onChange="javascript:do_check(<%=i%>,this);">
                <option value="">-------------</option>
                <option value="3"><spring:message code="LABEL.D.D11.0071" /><!-- 보장성보험료 --></option>
                <option value="4"><spring:message code="LABEL.D.D11.0072" /><!-- 장애인보험료 --></option>

              </select>
            </td>
            <td >
              <input type="text" name="BETRG<%=i%>" value="" size="15" maxlength="11" class="input03" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right">
            </td>
            <td >
              <input type="checkbox" name="CHNTS<%=i%>" value="" class="input03">
            </td>
            <% if("Y".equals(pdfYn)) {%>
            <td >
             <input type="checkbox" name="GUBUN<%=i%>" value="" disabled>
            </td>
            <td class="lastCol">
            <input type="checkbox" name="OMIT_FLAG<%=i%>" value="" class="input03" disabled>
            </td>
            <%} else {%>
            	<div style="display:none">
            	<input type="checkbox" name="GUBUN<%=i%>">
            	<input type="checkbox" name="OMIT_FLAG<%=i%>">
            	</div>
            <%} %>
            <input type="hidden" name="BETRG_O<%=i%>">
            <input type="hidden" name="BETRG_M<%=i%>">
            <input type="hidden" name="BETRG_B<%=i%>">
          </tr>
<%
    }
%>
           </table>
       </div>
      </div>
     <!--특별공제 테이블 끝-->
    <span  class="commentOne"><spring:message code="LABEL.D.D11.0078" /><!-- ※ PDF를 통하여 업로드 된 경우에는 “PDF”열에 표시되며, 반영을 취소할 경우에는 “연말정산 삭제”열에 체크 --></span>
<% }
%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_change();"><span><spring:message code="BUTTON.COMMON.INSERT" /><!-- 입력 --></span></a></li>
            <li><a href="javascript:cancel();"><span><spring:message code="BUTTON.COMMON.CANCEL" /><!-- 취소 --></span></a></li>
        </ul>
    </div>



       <input type="hidden" name="BETRG_ETC" value="">
<!-- 숨겨진 필드 -->
  <input type="hidden" name="jobid"      value="">
  <input type="hidden" name="targetYear" value="<%= targetYear %>">
  <input type="hidden" name="tab_gubun"  value="<%= tab_gubun %>">
  <input type="hidden" name="rowCount"   value="<%= rowCount %>">
  <input type="hidden" name="card_count" value="<%= card_count %>">
  <input type="hidden" name="curr_job" value="change">
<%--@2016연말정산 sort 추가 start --%>
  <input type="hidden" name="sortField" value="<%= sortField %>">
  <input type="hidden" name="sortValue" value="<%= sortValue %>">
<%--@2016연말정산 sort 추가 end --%>
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

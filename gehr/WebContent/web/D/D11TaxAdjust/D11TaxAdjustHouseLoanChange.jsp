<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustPensionChange.jsp                                */
/*   Description  : 연금/저축공제 수정 및 조회                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-12-08                                                  */
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
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    String rowCount   = (String)request.getAttribute("rowCount" );
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector houseLoan_vt     = (Vector)request.getAttribute("houseLoan_vt" );

//  2002.12.04. 연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );

//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    String Gubn = "Tax13";    //@v1.1
    int houseLoan_count = 8;

    if( houseLoan_vt.size() > houseLoan_count ) {
    	houseLoan_count = houseLoan_vt.size();
    }
    if ( Integer.parseInt(rowCount) != 8  ) {
    	houseLoan_count = Integer.parseInt(rowCount);
    }
    D11TaxAdjustHouseEssentialChkRFC HouseEChkRFC           = new D11TaxAdjustHouseEssentialChkRFC();
    String E_CHECK = HouseEChkRFC.getYn( user.empNo,targetYear);
 %>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

var delete_check=false;
function check_delete(obj, row) {
   //CSR ID:2013_9999 연말정산삭제클릭시

}
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

// 연금/저축공제 - 신청
function do_change() {

    for( var i = 0 ; i < "<%= houseLoan_count %>" ; i++ ) {
    	if(checkMaxNum( eval("document.form1.LNPRD_"+i))) return ;//@2016연말정산
    	SUBTY = eval("document.form1.SUBTY_"+i+".value");
        RCBEG = removePoint(eval("document.form1.RCBEG_"+i+".value"));
        eval("document.form1.RCBEG_"+i+".value = RCBEG;");
        RCEND = removePoint(eval("document.form1.RCEND_"+i+".value"));
        eval("document.form1.RCEND_"+i+".value = RCEND;");
        //@2016연말정산
        //대출기간(년)
        LNPRD = eval("document.form1.LNPRD_"+i+".value");
        eval("document.form1.LNPRD_"+i+".value = LNPRD;");
        //금액
        NAM01 = removeComma(eval("document.form1.NAM01_"+i+".value"));
        eval("document.form1.NAM01_"+i+".value = NAM01;");
        //check 고정금리
        if( eval("document.form1.FIXRT_"+ i + ".checked == true") )  {
            eval("document.form1.FIXRT_"+ i + ".value ='X';");
            FIXRT = "X";
        } else{
        	FIXRT = "";
        }
        //check 비거치
        if( eval("document.form1.NODEF_"+ i + ".checked == true") )  {
            eval("document.form1.NODEF_"+ i + ".value ='X';");
            NODEF = "X";
        } else{
        	NODEF = "";
        }
 /*       //주민번호
        LSREG = removeResBar(eval("document.form1.LSREG_"+i+".value"));
        eval("document.form1.LSREG_"+i+".value = LSREG;");
        //이자율
        INRAT = eval("document.form1.INRAT_"+i+".value");
        //이자
        INTRS = removeComma(eval("document.form1.INTRS_"+i+".value"));
        eval("document.form1.INTRS_"+i+".value = INTRS;"); */
        //구분(입력 2, pdf 9)

        if(eval("document.form1.PDF_FLAG"+ i + ".checked == true")) {
        	eval("document.form1.GUBUN_"+ i + ".value ='9';");
        } else {
        	eval("document.form1.GUBUN_"+ i + ".value ='2';");
        }

        //PDF여부
        if( eval("document.form1.PDF_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.PDF_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.PDF_FLAG"+ i + ".value =''");
        }

        //삭제여부
        if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.OMIT_FLAG"+ i + ".value =''");
        }

      //날짜 확인
        if(dayDiff(RCBEG, RCEND)< 0 ){
        	alert("<spring:message code='MSG.D.D11.0061' />"); //날짜 입력 오류입니다.
            eval("document.form1.RCBEG_"+i+".focus()");
            return;
        }

       var PDF_FLAG = eval("document.form1.PDF_FLAG"+ i + ".value;");

        if (SUBTY == "96" && PDF_FLAG == ""){
        	if ( NAM01 == ""  ) {
                alert("<spring:message code='MSG.D.D11.0044' />"); //금액은 필수 항목입니다.
                eval("document.form1.NAM01_"+i+".focus()");
                return;
            }

        }else if (SUBTY == "E8" && PDF_FLAG == ""){//@2016연말정산 LNPRD  추가
			if( RCBEG == "" || RCEND == "" || NAM01 == "" || LNPRD == "" ){
				if ( RCBEG == ""  ) {
                    alert("<spring:message code='MSG.D.D11.0062' />"); //최초차입일은 필수 항목입니다.
                    eval("document.form1.RCBEG_"+i+".focus()");
                    return;
                }
        		if ( RCEND == ""  ) {
                    alert("<spring:message code='MSG.D.D11.0063' />"); //최종상환예정일은 필수 항목입니다.
                    eval("document.form1.RCEND_"+i+".focus()");
                    return;
                }
        		if ( LNPRD == ""  ) {
                    alert("<spring:message code='MSG.D.D11.0102' />"); //대출기간(년)은 필수 항목입니다.
                    eval("document.form1.LNPRD_"+i+".focus()");
                    return;
                }
        		if ( NAM01 == ""  ) {
                    alert("<spring:message code='MSG.D.D11.0044' />"); //금액은 필수 항목입니다.
                    eval("document.form1.NAM01_"+i+".focus()");
                    return;
                }
			}
        }

    }//for end

    //if ("< %=E_CHECK%>"=="X" && document.form1.FSTID.checked != true) {
    //     alert("주택자금 관련공제는 세대주이어야 합니다.\n(단, 주택자금 저당차입금 이자상환액은 반드시 세대주가 아니여도 됨)\n다른 화면에서 입력한 주택자금 관련 공제항목이 있으니 세대주가 맞는지 확인 후 [세대주 여부]에 체크하시기 바랍니다.");
    //     return;
    //}
    for( var i = 0 ; i < "<%= houseLoan_count %>" ; i++ ) {
    	eval( "document.form1.RCBEG_"+i+".disabled  = false;");
    	eval( "document.form1.RCEND_"+i+".disabled  = false;");
    	eval( "document.form1.LNPRD_"+i+".disabled  = false;");//@2016연말정산 LNPRD 추가
    	eval( "document.form1.NAM01_"+i+".disabled  = false;");
    	eval( "document.form1.FIXRT_"+i+".disabled  = false;");
    	eval( "document.form1.NODEF_"+i+".disabled  = false;");
    	//eval( "document.form1.LSREG_"+i+".disabled = false ");
        //eval( "document.form1.INRAT_"+i+".disabled = false ");
        //eval( "document.form1.INTRS_"+i+".disabled = false ");
    }

    //필드 enable처리
    setEnable();
    document.form1.jobid.value = "change";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustHouseLoanSV";
    document.form1.method      = "post";
    document.form1.target      = "menuContentIframe";
    document.form1.submit();
}


/*function changeSubty(obj,i,gubn )
{
     if (gubn=="1") { //구분변경
        document.code.GUBUN.value = "1";
        document.code.SUBTY.value = obj.value;
        document.code.i.value = i;
        document.code.target = "ifHidden";
        document.code.action = "< %=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustPensionHiddenGubn.jsp";
        document.code.submit();
     } else if (gubn=="3") {   //유형변경시
        eval("document.code.SUBTY.value =  document.form1.SUBTY_"+i+"[document.form1.SUBTY_"+i+".selectedIndex].value ;");


        document.code.PNSTY.value = obj.value;
        document.code.GUBUN.value = "3";
        document.code.i.value = i;
        document.code.target = "ifHidden";
        document.code.action = "< %=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustPensionHiddenGubn.jsp";
        document.code.submit();

     } else if (gubn=="2") {
           eval("document.form1.INSNM_"+i+".value =  document.form1.FINCO_"+i+"[document.form1.FINCO_"+i+".selectedIndex].text ;");

     }

}*/

//@구분 값 변경 시
function subtyChg(obj, row) {
    var val = obj[obj.selectedIndex].value;//DREL_CODE
	do_init(row);
    do_check(obj, row, val);
}

//구분 값 변경에 따른 입력 값 초기화
function do_init(row){
    eval("document.form1.RCBEG_"+ row + ".value = ''; ");
    eval("document.form1.RCEND_"+ row + ".value = ''; ");
    eval("document.form1.LNPRD_"+ row + ".value = ''; ");//@2016연말정산 LNPRD 추가
    eval("document.form1.NAM01_"+ row + ".value = ''; ");
    eval("document.form1.FIXRT_"+ row + ".checked = false; ");
    eval("document.form1.NODEF_"+ row + ".checked = false; ");
    //eval("document.form1.LSREG_"+ row + ".value = ''; ");
    //eval("document.form1.INRAT_"+ row + ".value = ''; ");
    //eval("document.form1.INTRS_"+ row + ".value = ''; ");
}

//구분에 따른 필수항목 validation
function do_check(obj, row, val) {
    //2. 구분이 E6인 경우에는 주민번호/최초차입일/최종상환예정일/금액/이자율 /이자 입력 가능(필수입력 사항으로 처리 - 이자 제외)
	//3. 구분이 96인 경우에는 금액 입력 가능(필수입력 사항으로 처리)
	//4. 구분이 E8인 경우에는 최초차입일/최종상환예정일/금액/고정금리(체크박스)/비거치(체크박스)  입력 가능(필수입력 사항으로 처리 - 체크박스 제외)

    if(val == "E6"){
    	eval( "document.form1.FIXRT_"+row+".disabled  = true;");
    	eval( "document.form1.NODEF_"+row+".disabled  = true;");

    	eval( "document.form1.RCBEG_"+row+".disabled  = false;");
    	eval( "document.form1.RCEND_"+row+".disabled  = false;");
    	eval( "document.form1.LNPRD_"+row+".disabled  = true;");//@2016연말정산 추가
    	eval( "document.form1.NAM01_"+row+".disabled  = false;");
    	//eval( "document.form1.LSREG_"+row+".disabled = false ");
        //eval( "document.form1.INRAT_"+row+".disabled = false ");
        //eval( "document.form1.INTRS_"+row+".disabled = false ");
    }else if (val == "96"){
    	eval( "document.form1.RCBEG_"+row+".disabled  = true;");
    	eval( "document.form1.RCEND_"+row+".disabled  = true;");
    	eval( "document.form1.FIXRT_"+row+".disabled  = true;");
    	eval( "document.form1.NODEF_"+row+".disabled  = true;");
    	//eval( "document.form1.LSREG_"+row+".disabled = true ");
        //eval( "document.form1.INRAT_"+row+".disabled = true ");
        //eval( "document.form1.INTRS_"+row+".disabled = true ");
		eval( "document.form1.LNPRD_"+row+".disabled  = true;");//@2016연말정산 추가
        eval( "document.form1.NAM01_"+row+".disabled  = false;");
    }else if (val == "E8"){
    	//eval( "document.form1.LSREG_"+row+".disabled = true ");
        //eval( "document.form1.INRAT_"+row+".disabled = true ");
        //eval( "document.form1.INTRS_"+row+".disabled = true ");

    	eval( "document.form1.RCBEG_"+row+".disabled  = false;");
    	eval( "document.form1.RCEND_"+row+".disabled  = false;");
    	eval( "document.form1.FIXRT_"+row+".disabled  = false;");
    	eval( "document.form1.NODEF_"+row+".disabled  = false;");
    	eval( "document.form1.LNPRD_"+row+".disabled  = false;");//@2016연말정산 추가
    	eval( "document.form1.NAM01_"+row+".disabled  = false;");
    }else{
    	eval( "document.form1.RCBEG_"+row+".disabled  = false;");
    	eval( "document.form1.RCEND_"+row+".disabled  = false;");
    	eval( "document.form1.NAM01_"+row+".disabled  = false;");
    	eval( "document.form1.FIXRT_"+row+".disabled  = false;");
    	eval( "document.form1.LNPRD_"+row+".disabled  = false;");//@2016연말정산 추가
    	eval( "document.form1.NODEF_"+row+".disabled  = false;");
    	//eval( "document.form1.LSREG_"+row+".disabled = false ");
        //eval( "document.form1.INRAT_"+row+".disabled = false ");
        //eval( "document.form1.INTRS_"+row+".disabled = false ");
    }
}

/*   입력항목 1개 추가 */
function add_field(){
    document.form1.rowCount.value = document.form1.houseLoan_count.value = parseInt(document.form1.houseLoan_count.value) + 1; //@v1.4
    row = "<%= houseLoan_count - 1 %>";
    for( var i = 0 ; i < "<%= houseLoan_count %>" ; i++ ) {

        eval("document.form1.NAM01_"+i+".value  = removeComma(document.form1.NAM01_"+i+".value);");

       // if( eval("document.form1.PREIN_"+ i + ".checked == true") )
       //    eval("document.form1.PREIN_"+ i + ".value ='X';");

        //PDF여부
        if( eval("document.form1.PDF_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.PDF_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.PDF_FLAG"+ i + ".value ='';");
        }

        //삭제여부
        if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
        }
    }

	//필드 enable처리
    setEnable();
    document.form1.jobid.value = "AddorDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustHouseLoanSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function remove_field(){
	var delchk = false;
    //선택 삭제 추가
    document.form1.rowCount.value = parseInt(document.form1.houseLoan_count.value) - 1;

    for( var i = 0 ; i < "<%= houseLoan_count %>" ; i++ ) {
        if( isNaN( document.form1.radiobutton.length ) ){
            eval("document.form1.use_flag0.value = 'N'");
        } else {
            if ( document.form1.radiobutton[i].checked == true ) {
                eval("document.form1.use_flag"+ i +".value = 'N'");
                if(!delchk){
                	delchk = true;
                }
            }
        }
    }

    if ( document.form1.houseLoan_count.value == 0 ) {
        alert("<spring:message code='MSG.D.D11.0020' />"); //입력항목을 더이상 줄일수 없습니다.
        return;
    }

    if(!delchk) {
    	alert("<spring:message code='MSG.D.D11.0021' />"); //삭제할 건을 선택하세요.
    	return;
    }

    var row=0;
    row = "<%= houseLoan_count - 1 %>";
    for( var i = 0 ; i < "<%= houseLoan_count %>" ; i++ ) {

        eval("document.form1.NAM01_"+i+".value  = removeComma(document.form1.NAM01_"+i+".value);");

       // if( eval("document.form1.PREIN_"+ i + ".checked == true") )
       //     eval("document.form1.PREIN_"+ i + ".value ='X';");

        //PDF여부
        if( eval("document.form1.PDF_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.PDF_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.PDF_FLAG"+ i + ".value ='';");
        }

        //삭제여부
        if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
        }
    }

    //필드 enable처리
    setEnable();
    document.form1.jobid.value = "AddorDel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustHouseLoanSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
//onLoad시 호출됨.
function first(){
    for( var i = 0 ; i <"<%= houseLoan_count %>" ; i++ ){
		if(eval("document.form1.SUBTY_"+i+".value") == "96"){
	        	eval( "document.form1.RCBEG_"+i+".disabled  = true;");
	        	eval( "document.form1.RCEND_"+i+".disabled  = true;");
	        	eval( "document.form1.FIXRT_"+i+".disabled  = true;");
	        	eval( "document.form1.NODEF_"+i+".disabled  = true;");
	        	eval( "document.form1.LNPRD_"+i+".disabled  = true;");//@2016연말정산
	    }
	}
}

//입력취소
function cancel(){
    if(confirm("<spring:message code='MSG.D.D11.0038' />")){ //입력작업을 취소하시겠습니까?
        document.form1.jobid.value = "first";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustHouseLoanSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
</SCRIPT>
 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>

 <form name="form1" method="post">


    <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>

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
                  <th><spring:message code='LABEL.D.D11.0047' /><!-- 선택 --></td>
                  <th><spring:message code="LABEL.D.D11.0017" /><!-- 구분 --></th>
                  <th><spring:message code="LABEL.D.D11.0163" /><!-- 최초차입일 --></th>
                  <th><spring:message code="LABEL.D.D11.0164" /><!-- 최종상환예정일 --></th>
                  <th><spring:message code="LABEL.D.D11.0283" /><!-- 대출기한(년) --></th><!-- @2016연말정산 -->
                  <th><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                  <th><spring:message code="LABEL.D.D11.0165" /><!-- 고정금리 --></th>
                  <th><spring:message code="LABEL.D.D11.0166" /><!-- 비거치 --></th>
                  <% if("Y".equals(pdfYn)) {%>
                  <th><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                  <th class="lastCol"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></th>
                  <%} %>
                </tr>
               </thead>

<%


    for( int i = 0 ; i < houseLoan_vt.size() ; i++ ){
    	D11TaxAdjustHouseLoanData data = (D11TaxAdjustHouseLoanData)houseLoan_vt.get(i);

%>
        <tr class="<%=WebUtil.printOddRow(i) %>">
            <input type="hidden" name="use_flag<%=i%>"  value="Y">
            <td >
            	<input type="radio" name="radiobutton" value="<%=i%>" <%= data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td >
            <select name="SUBTY_<%= i %>" class="<%= data.GUBUN.equals("9") ? "input04" : "input03" %>" onChange="javascript:subtyChg(this,<%= i %>);" <%= data.GUBUN.equals("9") ? "disabled" : "" %>>
            <option value="">---------------</option>
<%= WebUtil.printOption((new D11TaxAdjustPensionCodeRFC()).getHouseLoanType(targetYear,"3",""), data.SUBTY) %>
            </select>
          </td>
			<td >
            	<input style="text-align:center" type="text" name="RCBEG_<%= i %>" value="<%=data.RCBEG.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCBEG, ".") %>" maxlength=18 size="18" class="<%= data.GUBUN.equals("9") ? "input04" : "input03" %>" onblur="javascript:dateFormat(this);" <%= data.SUBTY.equals("96")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
			<td >
            	<input style="text-align:center" type="text" name="RCEND_<%= i %>" value="<%=data.RCEND.equals("0000-00-00") ? "" : WebUtil.printDate(data.RCEND, ".") %>" maxlength=18 size="18" class="<%= data.GUBUN.equals("9") ? "input04" : "input03" %>" onblur="javascript:dateFormat(this);" <%= data.SUBTY.equals("96")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <!-- @2016연말정산 -->
            <td >
            	<input type="text" name="LNPRD_<%= i %>" value="<%= data.LNPRD.equals("000")  ? "" : data.LNPRD.equals("0") ? "" :  data.LNPRD.equals("") ? "" : WebUtil.printNumFormat(data.LNPRD) %>" style="text-align:center"  onKeyUp="javascript:checkMaxNum(this);"  size="17" class="<%= data.GUBUN.equals("9") ? "input04" : "input03" %>" <%= data.SUBTY.equals("96")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td >
            	<input type="text" name="NAM01_<%= i %>" value="<%= data.NAM01.equals("")  ? "" : WebUtil.printNumFormat(data.NAM01) %>" style="text-align:right"  onKeyUp="javascript:moneyChkEventForWon(this);"  size="17" maxlength="11" class="<%= data.GUBUN.equals("9") ? "input04" : "input03" %>" <%= data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td >
            	<input type="checkbox" name="FIXRT_<%=i%>" value="<%=  data.FIXRT.equals("") ? "" : data.FIXRT %>" <%= data.FIXRT.equals("X")  ? "checked" : "" %> <%= data.SUBTY.equals("96")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td >
            	<input type="checkbox" name="NODEF_<%=i%>" value="<%=  data.NODEF.equals("") ? "" : data.NODEF %>" <%= data.NODEF.equals("X")  ? "checked" : "" %> <%= data.SUBTY.equals("96")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
           <% if("Y".equals(pdfYn)) {%>
           <td >
             <input type="checkbox" name="PDF_FLAG<%=i%>" value="<%=  data.GUBUN.equals("9") ? "X" : "" %>" class="input03" <%= data.GUBUN.equals("9")  ? "checked" : "" %>  disabled>
            </td>
            <td class="lastCol"><!--연말정산삭제-->
             <input type="checkbox" name="OMIT_FLAG<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" class="input03" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %>  <%= data.GUBUN.equals("9")  ? "" : "disabled" %>  onClick="javascript:check_delete(this,<%=i%>);">
            </td>
            <%} else {%>
            <div style="display:none">
            <input type="checkbox" name="PDF_FLAG<%=i%>">
            </div>
           	<div style="display:none">
           	<input type="checkbox" name="OMIT_FLAG<%=i%>">
           	</div>

			<td class="td04" class="lastCol">

            </td>
	        <%} %>
<input type="hidden" name="GUBUN_<%=i%>" value="" class="input03" >
 <input type="hidden" name="PDF_FLAG<%=i%>"     value="">
        </tr>
<%
    }
%>
<%
    for( int i = houseLoan_vt.size() ; i < houseLoan_count ; i++ ){
%>
        <tr class="<%=WebUtil.printOddRow(i) %>">

            <input type="hidden" name="use_flag<%=i%>"  value="Y">
            <td >
              <input type="radio" name="radiobutton" value="<%=i%>" <%=(i==0) ? "checked" : "" %>>
            </td>
           <td >
            <select name="SUBTY_<%= i %>" class="input03" onChange="javascript:subtyChg(this,<%= i %>);">
              <option value="">---------------</option>
<%= WebUtil.printOption((new D11TaxAdjustPensionCodeRFC()).getHouseLoanType(targetYear,"3",""), "") %>

            </select>
          </td>
          <td >
            <input type="text" name="RCBEG_<%= i %>" value="" maxlength=18 size="18" class="input03" onblur="javascript:dateFormat(this);">
          </td>
          <td >
            <input type="text" name="RCEND_<%= i %>" value="" maxlength=18 size="18" class="input03" onblur="javascript:dateFormat(this);">
          </td>
          <!-- @2016연말정산 -->
          <td >
            <input type="text" name="LNPRD_<%= i %>" value="" size="18" class="input03" onKeyUp="javascript:checkMaxNum(this);" style="text-align:center">
          </td>
          <td >
            <input type="text" name="NAM01_<%= i %>" value="" size="18" class="input03" maxlength="11" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()">
          </td>
          <td >
            <input type="checkbox" name="FIXRT_<%=i%>" value="">
          </td>
          <td >
            <input type="checkbox" name="NODEF_<%=i%>" value="">
          </td>
          <% if("Y".equals(pdfYn)) {%>
            <td  >
            <input type="checkbox" name="PDF_FLAG<%=i%>" value="" class="input03" disabled>
             </td>
             <td class="lastCol">
             <input type="checkbox" name="OMIT_FLAG<%=i%>" value="" class="input03" disabled>
             </td>
            </td>
            <%} else {%>
            <div style="display:none">
            <input type="checkbox" name="PDF_FLAG<%=i%>">
           	<input type="checkbox" name="OMIT_FLAG<%=i%>">
           	</div>

	        <%} %>
	        <input type="hidden" name="PDF_FLAG<%=i%>"     value="">


              <input type="hidden" name="GUBUN_<%=i%>" value="" class="input03" >
            </td>
        </tr>
<%
    }
%>
            </table>
        </div>
        <span class="commentOne"> <spring:message code="LABEL.D.D11.0058" /><!-- PDF를 통하여 업로드 된 경우에는 “PDF”열에 표시되며, 반영을 취소할 경우에는 “연말정산 삭제”열에 체크 --></span>
    </div>
    <!--특별공제 테이블 끝-->
<%
    if(  !o_flag.equals("X") ) {
%>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_change();"><span><spring:message code="BUTTON.COMMON.INSERT" /><!-- 입력 --></span></a></li>
            <li><a  href="javascript:cancel();"><span><spring:message code="BUTTON.COMMON.CANCEL" /><!-- 취소 --></span></a></li>
        </ul>
    </div>
<%
    }
%>
    <div class="commentImportant" style="width:700px;">
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <p><spring:message code="LABEL.D.D11.0167" /><!-- 1. 연말정산 최초 신청시 증빙서류 제출 --></p>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0168" /><!-- - 임차차입금 원리금상환액 : 주민등록등본 --></p>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="LABEL.D.D11.0169" /><!-- - 장기주택저당차입금 이자상환액 : 주민등록등본, 건물등기부등본, 개별(공동)주택가격확인서 또는 분양계약서사본 --></p>
        <p><spring:message code="LABEL.D.D11.0170" /><!-- 2. 회사에서 대출 받은 주택구입 자금의 원리금 상환액은 상기 공제 대상에 포함되지 않음 --></p>
    </div>
<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<input type="hidden" name="rowCount"   value="<%= houseLoan_vt.size() %>">
<input type="hidden" name="houseLoan_count" value="<%= houseLoan_count %>">
<input type="hidden" name="curr_job" value="change">

<!-- 숨겨진 필드 -->
</form>
  <form name="code" method="post">
      <input type="hidden" name = "targetYear" value="<%= targetYear %>">
      <input type="hidden" name = "SUBTY"      value="">
      <input type="hidden" name = "i"          value="">
      <input type="hidden" name = "GUBUN"      value="">
      <input type="hidden" name = "PNSTY"      value="">
  </form>
<iframe name="ifHidden" width="0" height="0" />
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

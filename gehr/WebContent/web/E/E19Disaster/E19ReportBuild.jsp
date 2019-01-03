<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해피해신고서                                              */
/*   Program ID   : E19ReportBuild.jsp                                          */
/*   Description  : 재해피해신고서를 작성/추가/삭제 할수 있도록 하는 화면       */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-17  윤정현                                          */
/*                  2006-07-18  @v1.1 lsa 비닐/축사 제외                        */
/*                  2006-08-30  @v1.2 lsa 지급율 합값 오류로 인해 막음          */
/*  CSR ID : 2511881 재해신청 시스템 수정요청 20140327 이지은D  1) 재해신청일자 < 신청일 validation
 *                                                                                    2) 신청일이 시작일이 아니고, 재해신청일자가 BEGDA
 *                                                                                    3) 재해신청일자 입력 화면 변경(재해피해신고서로 옮김)  */
/*              2015-08-13 이지은  [CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청                                                                */
/*                      2017-09-28 이지은 [CSR ID:3497450] 주소 검색 창 오픈 안됨   */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.E.E19Disaster.*" %>
<%@ page import="hris.E.E19Disaster.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    E19CongcondData e19CongcondData = (E19CongcondData)request.getAttribute("resultData");
    Vector E19DisasterData_vt  = (Vector)request.getAttribute("E19DisasterData_vt");
    String fromJsp             = (String)request.getAttribute("fromJsp");
    Vector E19DisasterData_opt = (new E19DisaRelaRFC()).getDisaRela(user.companyCode);

    Vector E19DisasterData_rate = (Vector)request.getAttribute("E19DisasterData_rate");
    // 20030918 CYH  추가사항
    Vector E19DisasterData_rat2 = (Vector)request.getAttribute("E19DisasterData_rat2");

    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    Vector      AccountData_pers_vt = (Vector)request.getAttribute("AccountData_pers_vt");
    AccountData AccountData_hidden  = (AccountData)request.getAttribute("AccountData_hidden");

    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>
<jsp:include page="/include/header.jsp" />
<%--<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>--%>
<!--  [CSR ID:3497450] header 로 포함 <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script> -->
<script language="JavaScript">
<!--
//우편번호 버튼 클릭시 주소를 찾는 창이 뜬다.
function fn_openZipCode(){
   small_window=window.open("<%=WebUtil.JspURL%>common/SearchAddr.jsp","essPost","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=no,scrollbars=yes,width=388,height=393,left=100,top=100");
   small_window.focus();
}
//주소를 검색하여 우편번호와 주소를 받아온다.
function searchAddrData(zip_code, address){
    document.form1.xSTRAS.value = address;
}
//주소를 검색하여 우편번호와 주소를 받아온다.

//글자수입력제한
function check_length(obj) {

    val = obj.value;
    nam = obj.name;
    len = checkLength(obj.value);

    if (event.keyCode ==13 )  {
            if(nam=="xDISA_DESC1"){
            document.form1.xDISA_DESC2.focus();
        }else if(nam=="xDISA_DESC2"){
            document.form1.xDISA_DESC3.focus();
        }else if(nam=="xDISA_DESC3"){
            document.form1.xDISA_DESC4.focus();
        }else if(nam=="xDISA_DESC4"){
            document.form1.xDISA_DESC5.focus();
        }else if(nam=="xDISA_DESC5"){
            obj.blur();
        }
      }

    if(len > 59){
        vala = limitKoText(val,59);
        obj.blur();
        obj.value = vala;
        obj.focus();
    }
}

//재해구분&대상자관계에 따른 재해위로금 Action
function rate_action(obj) {
    var money = 0;
    var rate  = 0;

      var disa = document.form1.xDISA_CODE[document.form1.xDISA_CODE.selectedIndex].value;//xDISA_CODE
      var rela = obj[obj.selectedIndex].value;//xDREL_CODE

<%
            for( int i = 0 ; i < E19DisasterData_rate.size() ; i++ ) {
                E19DisasterData data_rate = (E19DisasterData)E19DisasterData_rate.get(i);
%>
    if( rela == "<%=data_rate.DREL_CODE%>" && disa == "<%=data_rate.DISA_CODE%>" ){

        document.form1.xDISA_RATE.value = "<%=data_rate.DISA_RATE%>";

        rate = Number(document.form1.xDISA_RATE.value);
//      2002.11.13. 지급율을 계산할때 근속년수를 적용한다. 재해피해신고서
        compCode = "<%=user.companyCode%>";
        WORK_YEAR = Number(document.form1.WORK_YEAR.value);
        WORK_MNTH = Number(document.form1.WORK_MNTH.value);

        if(WORK_YEAR < 1 ){//LG화학-1년미만
            rate  = rate  * 0.5 ;

        }
            document.form1.xDISA_RATE.value = rate;
//      2002.11.13. 지급율을 계산할때 근속년수를 적용한다. 재해피해신고서
    }
<%
            }
%>
}

//저장버튼 클릭시.. 추가인지 변경에 대한 저장인지 구분 실행한다.
function click_save_btn(){
    val = document.form1.addOrChangeFlag.value ;
    if( val == 'add' ){
        do_add();
    }else if( val == 'change' ){
        if( check_data() ) {
            do_change();
            document.form1.addOrChangeFlag.value = 'add';
        } else {
            document.form1.addOrChangeFlag.value = 'change';
        }
    }
}

//변경
function do_change() {
    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
      size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = i+"";
        }
    }
    eval("document.form1.DISA_CODE" +command+".value = document.form1.xDISA_CODE.value ");
    eval("document.form1.DREL_CODE" +command+".value = document.form1.xDREL_CODE.value ");
    eval("document.form1.DISA_RATE" +command+".value = document.form1.xDISA_RATE.value ");
    eval("document.form1.CONG_DATE" +command+".value = document.form1.xCONG_DATE.value ");
    eval("document.form1.DISA_DESC1"+command+".value = document.form1.xDISA_DESC1.value");
    eval("document.form1.DISA_DESC2"+command+".value = document.form1.xDISA_DESC2.value");
    eval("document.form1.DISA_DESC3"+command+".value = document.form1.xDISA_DESC3.value");
    eval("document.form1.DISA_DESC4"+command+".value = document.form1.xDISA_DESC4.value");
    eval("document.form1.DISA_DESC5"+command+".value = document.form1.xDISA_DESC5.value");
    eval("document.form1.EREL_NAME" +command+".value = document.form1.xEREL_NAME.value ");
    eval("document.form1.REGNO"     +command+".value = removeResBar(document.form1.xREGNO.value)");
    eval("document.form1.STRAS"     +command+".value = document.form1.xSTRAS.value     ");
    document.form1.jobid.value = "add";
    document.form1.target = "menuContentIframe";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19ReportControlSV";
    document.form1.method = "post";
    document.form1.submit();
}

function do_add() {
    if( check_data() ) {

        document.form1.RowCount_report.value = "<%= E19DisasterData_vt.size()+1 %>";

        document.form1.use_flag<%= E19DisasterData_vt.size() %>.value = "Y";
        document.form1.DISA_RESN<%= E19DisasterData_vt.size() %>.value = document.form1.xDISA_RESN.value;
        document.form1.DISA_CODE<%= E19DisasterData_vt.size() %>.value = document.form1.xDISA_CODE.value;
        document.form1.DREL_CODE<%= E19DisasterData_vt.size() %>.value = document.form1.xDREL_CODE.value;
        document.form1.DISA_RATE<%= E19DisasterData_vt.size() %>.value = document.form1.xDISA_RATE.value;
        document.form1.CONG_DATE<%= E19DisasterData_vt.size() %>.value = document.form1.xCONG_DATE.value;
        document.form1.DISA_DESC1<%= E19DisasterData_vt.size() %>.value = document.form1.xDISA_DESC1.value;
        document.form1.DISA_DESC2<%= E19DisasterData_vt.size() %>.value = document.form1.xDISA_DESC2.value;
        document.form1.DISA_DESC3<%= E19DisasterData_vt.size() %>.value = document.form1.xDISA_DESC3.value;
        document.form1.DISA_DESC4<%= E19DisasterData_vt.size() %>.value = document.form1.xDISA_DESC4.value;
        document.form1.DISA_DESC5<%= E19DisasterData_vt.size() %>.value = document.form1.xDISA_DESC5.value;
        document.form1.EREL_NAME<%= E19DisasterData_vt.size() %>.value = document.form1.xEREL_NAME.value;
        document.form1.REGNO<%= E19DisasterData_vt.size() %>.value = removeResBar(document.form1.xREGNO.value);
        document.form1.STRAS<%= E19DisasterData_vt.size() %>.value = document.form1.xSTRAS.value;
        document.form1.jobid.value = "add";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19ReportControlSV";
        document.form1.target = "menuContentIframe";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function go_back() {
    var rate = 0 ;
    var rat2 = 0 ;
    var flag = 'Y' ;
    var flag2 = 'Y' ;
    x_obj = document.form1.xDISA_RESN;

/*------------------ 지급률에 관한 로직을 첨가합니다. -----------------*/
<%
  for( int i = 0 ; i < E19DisasterData_vt.size() ; i++ ){
    E19DisasterData data_disa = (E19DisasterData)E19DisasterData_vt.get(i);
%>
<%
    for( int j = 0 ; j < E19DisasterData_rat2.size() ; j++ ) {
            E19DisasterData data_rat2 = (E19DisasterData)E19DisasterData_rat2.get(j);
%>
     //@v1.2
     //if( "<%=data_rat2.DISA_RESN%>" != '' && flag2 == 'Y'){
     //  if( "<%=data_disa.DISA_RESN%>" == "<%=data_rat2.DISA_RESN%>" ){
     //      rat2 = Number("<%=data_rat2.DISA_RATE%>") + Number("<%=data_disa.DISA_RATE%>");
     //      if( rat2 > 100 ){
     //         rate = rate + (100 - Number("<%=data_rat2.DISA_RATE%>") );
     //         flag2 = 'N';
     //      }else{
     //         rate = rate + Number("<%=data_disa.DISA_RATE%>");
     //      }
     //    flag = 'N';
     //  }
     //}
<%
    }
%>

   if( flag == 'Y' ){
      rate = rate + Number("<%=data_disa.DISA_RATE%>");
   }
   flag = 'Y';
<%
  }
%>
//   if(rate = '0'){
//     alert("재해내역에 관하여 지원금이 초과되었습니다. ");
//   }
      flag = "";
/*------------------------------------------------------------------*/
    if(rate > 100 ){
        rate = 100;
    }

    if(rate > 0){

        document.form1.CONG_RATE.value = rate;
        cal_money_val = cal_money();
        if(cal_money_val < 100000){//최소 10만원
          cal_money_val = 100000;
        }
        document.form1.CONG_WONX.value = cal_money_val;
    }
<%
    if( E19DisasterData_vt.size() == 0 ) {
%>
        document.form1.CONG_RATE.value = "";
        document.form1.CONG_WONX.value = "";
<%
    }
%>

    document.form1.jobid.value = "back_build";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19ReportControlSV";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
//self.close();
}
//submit 시에 데이터 체크
function check_data(){

	 if(!isValid("form1")) return;


//성명-10, 주소-60 입력시 길이 제한
    x_obj = document.form1.xEREL_NAME;
    xx_value = x_obj.value;
    if( checkLength(xx_value) > 10 ){
        x_obj.value = limitKoText(xx_value,9);
        //alert("성명은 한글 5자, 영문10자 이내여야 합니다.");
        alert("<%=g.getMessage("MSG.E.E19.0001")%>");
        x_obj.focus();
        x_obj.select();
        return false;
    }

//성명-10, 주소-60 입력시 길이 제한
    x_obj = document.form1.xSTRAS;
    xx_value = x_obj.value;
    if( checkLength(xx_value) > 60 ){
        x_obj.value = limitKoText(xx_value,59);
        //alert("주소는 한글 30자, 영문60자 이내여야 합니다.");
        alert("<%=g.getMessage("MSG.E.E19.0002")%>");
        x_obj.focus();
        x_obj.select();
        return false;
    }

    return true;
}

//변경될 항목들 화면에 뿌리기
function show_change() {

    document.form1.addOrChangeFlag.value = 'change';
    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
      size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = i+"";
        }
    }

    eval("document.form1.xDISA_RESN.value  = document.form1.DISA_RESN" +command+".value");
    eval("document.form1.xDISA_CODE.value  = document.form1.DISA_CODE" +command+".value");
    val = eval("document.form1.DISA_CODE" +command+".value");
    set_change_desa(val);
    eval("document.form1.xDREL_CODE.value  = document.form1.DREL_CODE" +command+".value");
    eval("document.form1.xDISA_RATE.value  = document.form1.DISA_RATE" +command+".value");
    eval("document.form1.xCONG_DATE.value  = document.form1.CONG_DATE" +command+".value");
    eval("document.form1.xDISA_DESC1.value = document.form1.DISA_DESC1"+command+".value");
    eval("document.form1.xDISA_DESC2.value = document.form1.DISA_DESC2"+command+".value");
    eval("document.form1.xDISA_DESC3.value = document.form1.DISA_DESC3"+command+".value");
    eval("document.form1.xDISA_DESC4.value = document.form1.DISA_DESC4"+command+".value");
    eval("document.form1.xDISA_DESC5.value = document.form1.DISA_DESC5"+command+".value");
    eval("document.form1.xEREL_NAME.value  = document.form1.EREL_NAME" +command+".value");

    eval("document.form1.xREGNO.value      = document.form1.REGNO"     +command+".value");
    eval("document.form1.xREGNO.value      = addResBar(document.form1.xREGNO.value)"    );
    eval("document.form1.xSTRAS.value      = document.form1.STRAS"     +command+".value");
}

//삭제
function do_delete() {

    var command = "";
    var size = "";
    if( isNaN( document.form1.radiobutton.length ) ){
      size = 1;
    } else {
      size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            command = i+"";
        }
    }
    eval("document.form1.use_flag"+command+".value = 'N'");
    document.form1.jobid.value = "delete";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19ReportControlSV";
    document.form1.target = "menuContentIframe";
    document.form1.method = "post";
    document.form1.submit();
}

function view_DisaRela(obj) {
      var val = obj[obj.selectedIndex].value;//DISA_CODE 값
<%
    int inx = 0;
    String before = "";
    for( int i = 0 ; i < E19DisasterData_opt.size() ; i++ ) {
        E19DisasterData data = (E19DisasterData)E19DisasterData_opt.get(i);
        if( before.equals(data.DISA_CODE) ) {
          inx++;
%>
        document.form1.xDREL_CODE.length = <%= inx %>;
        document.form1.xDREL_CODE[<%= inx-1 %>].value = "<%=data.DREL_CODE%>";
        document.form1.xDREL_CODE[<%= inx-1 %>].text  = "<%=data.DREL_NAME%>";
<%
        } else {
            inx = 2;
            if( i == 0 ) {
%>
    if( val == "<%=data.DISA_CODE%>" ) {
        document.form1.xDREL_CODE.length = <%= inx %>;
        document.form1.xDREL_CODE[<%= inx-1 %>].value = "<%=data.DREL_CODE%>";
        document.form1.xDREL_CODE[<%= inx-1 %>].text  = "<%=data.DREL_NAME%>";
<%
            } else {
%>
    }else if( val == "<%=data.DISA_CODE%>" ) {
        document.form1.xDREL_CODE.length = <%= inx %>;
        document.form1.xDREL_CODE[<%= inx-1 %>].value = "<%=data.DREL_CODE%>";
        document.form1.xDREL_CODE[<%= inx-1 %>].text  = "<%=data.DREL_NAME%>";
<%
            }
            before = data.DISA_CODE;
        }
    }
%>
        }
    if( val == "" ) {
        document.form1.xDREL_CODE.length = 1;
    }
    document.form1.xDREL_CODE[0].selected = true;
}

function set_change_desa(val) {
<%
    inx = 0;
    before = "";
    for( int i = 0 ; i < E19DisasterData_opt.size() ; i++ ) {
        E19DisasterData data = (E19DisasterData)E19DisasterData_opt.get(i);
        if( before.equals(data.DISA_CODE) ) {
          inx++;
%>
        document.form1.xDREL_CODE.length = <%= inx %>;
        document.form1.xDREL_CODE[<%= inx-1 %>].value = "<%=data.DREL_CODE%>";
        document.form1.xDREL_CODE[<%= inx-1 %>].text  = "<%=data.DREL_NAME%>";
<%
        } else {
            inx = 2;
            if( i == 0 ) {
%>
    if( val == "<%=data.DISA_CODE%>" ) {
        document.form1.xDREL_CODE.length = <%= inx %>;
        document.form1.xDREL_CODE[<%= inx-1 %>].value = "<%=data.DREL_CODE%>";
        document.form1.xDREL_CODE[<%= inx-1 %>].text  = "<%=data.DREL_NAME%>";
<%
            } else {
%>
    }else if( val == "<%=data.DISA_CODE%>" ) {
        document.form1.xDREL_CODE.length = <%= inx %>;
        document.form1.xDREL_CODE[<%= inx-1 %>].value = "<%=data.DREL_CODE%>";
        document.form1.xDREL_CODE[<%= inx-1 %>].text  = "<%=data.DREL_NAME%>";
<%
            }
            before = data.DISA_CODE;
        }
    }
%>
        }
    if( val == "" ) {
        document.form1.xDREL_CODE.length = 1;
    }
}

function cal_money(){

    var rate = 0;
    var wage = 0;
    var money = 0 ;

    rate = Number(document.form1.CONG_RATE.value);
    wage = Number(document.form1.WAGE_WONX.value);
    money = ( rate * wage ) / 100;
    money = money_olim(money);

    return money;
}

//LG화학, LG석유화학 구분없이 1000 미만 단수절상
function money_olim(val_int){
    var money = 0;
    var compCode = 0;
    var rate = 0;


        money = olim(val_int, -3);
    return money;
}

//
function MM_openBrWindow(theURL,winName,features) {//v2.0
  window.open(theURL,winName,features);
}

function check_text_size(obj){
  var len = obj.value.length;
  var nam = obj.name;
  var inx = nam.substring(10,11);
//alert(inx);
  if( len > 56){
    if( Number(inx) != 5 ){
      eval("document.form1.xDISA_DESC"+(Number(inx)+1)+".focus();");
    } else {
      //alert( "글자수 초과입니다." );
    	 alert("<%=g.getMessage("MSG.E.E19.0003")%>");
    }
  }
}

function resno_chk(obj){
  if( chkResnoObj_1(obj) == false ) {
    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////추가
function after_event_CONG_DATE(){
    event_CONG_DATE(document.form1.CONG_DATE);
}
function event_CONG_DATE(obj){
   if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() ){
        document.form3.CONG_DATE.value = removePoint(document.form1.CONG_DATE.value);
        document.form3.action="<%=WebUtil.JspURL%>E/E19Disaster/E19Hidden4WorkYear.jsp";
        document.form3.target="ifHidden";
        document.form3.submit();
    }
}

function chkInvalidDate(){
    var begin_date = removePoint(document.form1.BEGDA.value);

    var congra_date = removePoint(document.form1.CONG_DATE.value);
    betw = getAfterMonth(addSlash(congra_date), 3);
    dif = dayDiff(addSlash(begin_date), addSlash(betw));

    //betw2 = getAfterMonth(addSlash(begin_date), 1);
    dif2 = dayDiff(addSlash(congra_date), addSlash(begin_date));

    //경조사 발생 3개월초과시 에러처리
    if(dif < 0){
        //str = '        재해를 신청할수 없습니다.\n\n 재해발생일로부터 3개월 이전까지 신청할수 있습니다. ';
        str = '        <%=g.getMessage("MSG.E.E19.0004")%>';
        alert(str);
        document.form1.CONG_DATE.value="";
        return false;
    }

    //재해 발생 전에 신청할 수 없음
    if(dif2 < 0) {
        //str = '        재해를 신청할수 없습니다.\n\n 재해발생 전에는 미리 신청할수 없습니다. ';
        str = '        <%=g.getMessage("MSG.E.E19.0005")%> ';
//str = str + '\n\n 신청가능 기간 : '+addPointAtDate(getAfterMonth(addSlash(congra_date), -3))+' ~ '+addPointAtDate(getAfterMonth(addSlash(congra_date), 3))+' 입니다.  ';
        alert(str);
        document.form1.CONG_DATE.value="";
        return false;
    }
    return true;
}


function doSubmit() {
    document.form1.checkSubmit.value = "Y";
    if( !check_data() ){
        document.form1.checkSubmit.value = "";
        return;
    }
}

function doSubmit_save() {
    document.form1.jobid.value = "create";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E19Disaster.E19CongraBuildSV";
    document.form1.method = "post";
    document.form1.submit();
}


//[CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청
function execDaumPostcode2() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                //document.getElementById('PSTLZ').value = data.zonecode; //5자리 기초구역번호 사용
                //var testArr = fullRoadAddr.split('(');
                //alert(testArr[0]);
                //alert(testArr[1]);

                document.getElementById('xSTRAS').value = fullRoadAddr;
                //document.getElementById('LOCAT').value = '';//지번 주소는 받지 않음.

                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(<%=g.getMessage("LABEL.E.E19.0004")%> : ' + expRoadAddr + ')';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(<%=g.getMessage("LABEL.E.E19.0005")%> : ' + expJibunAddr + ')';

                } else {
                    document.getElementById('guide').innerHTML = '';
                }
            }
        }).open();
    }
//-->
</script>

 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="title" value="LABEL.E.E19.0001"/>
 </jsp:include>
<form name="form1" id="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=e19CongcondData.PERNR%>">
<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            	<colgroup>
            		<col width="10%" />
            		<col width="10%" />
            		<col />
            	</colgroup>
                <tr>
                    <th colspan="2"><span class="textPink">*</span><!-- 재해발생일자 --><%=g.getMessage("LABEL.E.E19.0003")%></th>
                    <td>
                      <input type="text" class="date required" name="CONG_DATE"  placeholder="<%=g.getMessage("LABEL.E.E19.0003")%>"  value="<%= e19CongcondData.CONG_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(e19CongcondData.CONG_DATE) %>" size="20" onChange="event_CONG_DATE(this);">
                    </td>
                </tr>
                <tr>
                    <th colspan="2"><span class="textPink">*</span><!-- 재해내역 --><%=g.getMessage("LABEL.E.E19.0002")%></th>
                    <td>
                        <select name="xDISA_RESN"  class="required" placeholder="<%=g.getMessage("LABEL.E.E19.0002")%> "style="width:130px">
                            <option value="">--------------------</option>
                            <!-- 재해내역 option -->
                            <%= WebUtil.printOption((new E19DisaResnRFC()).getDisaResn(user.companyCode)) %>
                            <!-- 재해내역 option -->
                        </select>
                    </td>
                </tr>
                <tr>
                    <th colspan="2"><span class="textPink">*</span><!-- 재해구분 --><%=g.getMessage("LABEL.E.E20.0020")%></th>
                    <td>
                        <select name="xDISA_CODE" onChange="javascript:view_DisaRela(this);" class="required" placeholder="<%=g.getMessage("LABEL.E.E20.0020")%>" style="width:130px">
                            <option value="">--------------------</option>
                            <!-- 재해구분 option -->
                            <!-- //WebUtil.printOption((new E19DisaCodeRFC()).getDisaCode(user.companyCode)) -->
                            <%  //@v1.1 재해 비닐/축사 제외
                              Vector  key = new Vector();
                              key = (new E19DisaCodeRFC()).getDisaCode(user.companyCode);
                              for ( int i=0 ; i < key.size() ; i++ )
                              {
                                  com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)key.get(i);
                                  if ( !ck.code.equals("1200") && !ck.code.equals("1210")&& !ck.code.equals("1220") && !ck.code.equals("1300") && !ck.code.equals("1310") ) {
                            %>      <option value ="<%=ck.code%>"><%=ck.value%></option>
                            <%      }
                                  }
                            %>

                            <!-- 재해구분 option -->
                        </select>
                    </td>
                </tr>
                <tr>
                    <th rowspan="4"><!-- 재해피해자 --><%=g.getMessage("LABEL.E.E20.0021")%></th>
                    <th><span class="textPink">*</span><!-- 구분 --><%=g.getMessage("LABEL.E.E20.0022")%></th>
                    <td>
                        <select name="xDREL_CODE" onChange="javascript:rate_action(this);" class="required" placeholder="<%=g.getMessage("LABEL.E.E20.0021")%><%=g.getMessage("LABEL.E.E20.0022")%>" style="width:130px">
                            <option value="">--------------------</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><!-- 성명 --><%=g.getMessage("LABEL.E.E20.0023")%></th>
                    <td>
                        <input type="text" name="xEREL_NAME" size="19" class="required" placeholder="<%=g.getMessage("LABEL.E.E20.0021")%><%=g.getMessage("LABEL.E.E20.0023")%>">
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><!-- 주민등록번호 --><%=g.getMessage("LABEL.E.E20.0024")%></th>
                    <td>
                        <input type="text" name="xREGNO" onBlur="javascript:resno_chk(this);" size="19" maxlength="14" class="required" placeholder="<%=g.getMessage("LABEL.E.E20.0024")%>">
                    </td>
                </tr>
                <tr>
                    <th><span class="textPink">*</span><!-- 주소 --><%=g.getMessage("LABEL.E.E20.0025")%></th>
                    <td>
                        <input type="text" id ="xSTRAS"  name="xSTRAS" size="80" class="required" placeholder="<%=g.getMessage("LABEL.E.E20.0025")%>">
                        <!-- [CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청 <a href="javascript:fn_openZipCode();"> <img src="<%= WebUtil.ImageURL %>btn_addserch.gif" align="absmiddle" border="0"></a>-->
                        <a class="inlineBtn" href="javascript:execDaumPostcode2();"><span><!-- 주소찾기 --><%=g.getMessage("BUTTON.COMMON.ADDRESS")%></span></a>
                        <br><span id="guide" style="color:#999"></span>
                    </td>
                </tr>
                <tr>
                    <th colspan="2"><!-- 재해내용 --><%=g.getMessage("LABEL.E.E20.0026")%></th>
                    <td>
                      <input type="text" name="xDISA_DESC1" size="80" onKeyUp="check_length(this);" maxlength="80"><br />
                      <input type="text" name="xDISA_DESC2" size="80" onKeyUp="check_length(this);" maxlength="80"><br />
                      <input type="text" name="xDISA_DESC3" size="80" onKeyUp="check_length(this);" maxlength="80"><br />
                      <input type="text" name="xDISA_DESC4" size="80" onKeyUp="check_length(this);" maxlength="80"><br />
                      <input type="text" name="xDISA_DESC5" size="80" onKeyUp="check_length(this);" maxlength="80">
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:click_save_btn();"><span><!-- 저장 --><%=g.getMessage("BUTTON.COMMON.SAVE")%></span></a></li>
            <li><a href="javascript:go_back();"><span><!-- 이전화면 --><%=g.getMessage("BUTTON.COMMON.BACK.PREVIOUS")%></span></a></li>
        </ul>
    </div>

<!--  HIDDEN  처리해야할 부분 -->
                <input type="hidden" name="xDISA_RATE"  value="">
                <input type="hidden" name="xCONG_DATE"  value="<%= e19CongcondData.CONG_DATE %>">
<!--  HIDDEN  처리해야할 부분 -->
                <input type="hidden" name="use_flag<%= E19DisasterData_vt.size() %>"  value="N">
                <input type="hidden" name="DISA_RESN<%= E19DisasterData_vt.size() %>"  value="">
                <input type="hidden" name="DISA_CODE<%= E19DisasterData_vt.size() %>"  value="">
                <input type="hidden" name="DREL_CODE<%= E19DisasterData_vt.size() %>"  value="">
                <input type="hidden" name="DISA_RATE<%= E19DisasterData_vt.size() %>"  value="">
                <input type="hidden" name="CONG_DATE<%= E19DisasterData_vt.size() %>"  value="">
                <input type="hidden" name="DISA_DESC1<%= E19DisasterData_vt.size() %>" value="">
                <input type="hidden" name="DISA_DESC2<%= E19DisasterData_vt.size() %>" value="">
                <input type="hidden" name="DISA_DESC3<%= E19DisasterData_vt.size() %>" value="">
                <input type="hidden" name="DISA_DESC4<%= E19DisasterData_vt.size() %>" value="">
                <input type="hidden" name="DISA_DESC5<%= E19DisasterData_vt.size() %>" value="">
                <input type="hidden" name="EREL_NAME<%= E19DisasterData_vt.size() %>"  value="">
                <input type="hidden" name="REGNO<%= E19DisasterData_vt.size() %>"      value="">
                <input type="hidden" name="STRAS<%= E19DisasterData_vt.size() %>"      value="">
                <input type="hidden" name="checkSubmit"     value="">
                <input type="hidden" name="isUpdate"     value="${isUpdate}">
<%
    if( E19DisasterData_vt.size() > 0 ){
%>

    <div class="listArea">
        <div class="table">
            <table class="listTable">
            <thead>
                <tr>
                    <th rowspan="2"><!-- 선택 --><%=g.getMessage("LABEL.E.E20.0008")%></th>
                    <th rowspan="2">No.</th>
                    <th rowspan="2"><!-- 재해구분 --><%=g.getMessage("LABEL.E.E20.0020")%></th>
                    <th colspan="3"><!-- 재해피해자 --><%=g.getMessage("LABEL.E.E20.0021")%></th>
                    <th class="lastCol" rowspan="2"><!-- 지급율 --><%=g.getMessage("LABEL.E.E20.0011")%></th>
                </tr>
                <tr>
                    <th><!-- 구분 --><%=g.getMessage("LABEL.E.E20.0022")%></th>
                    <th><!-- 성명 --><%=g.getMessage("LABEL.E.E20.0023")%></th>
                    <th><!-- 주민등록번호 --><%=g.getMessage("LABEL.E.E20.0024")%></th>
                </tr>
               </thead>
<%
        for( int i = 0 ; i < E19DisasterData_vt.size() ; i++ ) {
            E19DisasterData data_rep = (E19DisasterData)E19DisasterData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td>
                      <input type="radio" name="radiobutton" value="" <%= (i==0) ? "checked" : ""%>>
                    </td>
                    <td ><%= i+1 %></td>
                    <td><%= data_rep.DISA_NAME %></td>
                    <td><%= data_rep.DREL_NAME %></td>
                    <td><%= data_rep.EREL_NAME %></td>
                    <td><%= DataUtil.addSeparate(data_rep.REGNO) %></td>
                    <td class="lastCol"><%= WebUtil.printNum(data_rep.DISA_RATE) %>%
                    <input type="hidden" name="use_flag<%= i %>"  value="Y">
                    <input type="hidden" name="DISA_RESN<%= i %>"  value="<%= data_rep.DISA_RESN %>">
                    <input type="hidden" name="DISA_CODE<%= i %>"  value="<%= data_rep.DISA_CODE %>">
                    <input type="hidden" name="DREL_CODE<%= i %>"  value="<%= data_rep.DREL_CODE %>">
                    <input type="hidden" name="DISA_RATE<%= i %>"  value="<%= data_rep.DISA_RATE %>">
                    <input type="hidden" name="CONG_DATE<%= i %>"  value="<%= data_rep.CONG_DATE %>">
                    <input type="hidden" name="DISA_DESC1<%= i %>" value="<%= data_rep.DISA_DESC1%>">
                    <input type="hidden" name="DISA_DESC2<%= i %>" value="<%= data_rep.DISA_DESC2%>">
                    <input type="hidden" name="DISA_DESC3<%= i %>" value="<%= data_rep.DISA_DESC3%>">
                    <input type="hidden" name="DISA_DESC4<%= i %>" value="<%= data_rep.DISA_DESC4%>">
                    <input type="hidden" name="DISA_DESC5<%= i %>" value="<%= data_rep.DISA_DESC5%>">
                    <input type="hidden" name="EREL_NAME<%= i %>"  value="<%= data_rep.EREL_NAME %>">
                    <input type="hidden" name="REGNO<%= i %>"      value="<%= data_rep.REGNO     %>">
                    <input type="hidden" name="STRAS<%= i %>"      value="<%= data_rep.STRAS     %>">
<%
            if(i==0){
%>
                        <input type="hidden" name="DISA_NAME"  value="<%= data_rep.DISA_NAME%>">
                        <input type="hidden" name="DREL_NAME"  value="<%= data_rep.DREL_NAME%>">

<%
            }
%>
                    </td>




</tr>
<%
        }
%>

            </table>
        </div>
    </div>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:show_change();"><span><!-- 수정 --><%=g.getMessage("BUTTON.COMMON.UPDATE")%></span></a></li>
            <li><a href="javascript:do_delete();"><span><!-- 삭제 --><%=g.getMessage("BUTTON.COMMON.DELETE")%></span></a>
        </ul>
    </div>


<%
    }
%>


<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
    <input type="hidden" name="fromJsp" value="<%= fromJsp %>">
    <input type="hidden" name="fromJsp2" value="E19ReportBuild.jsp">
    <input type="hidden" name="AINF_SEQN" value="<%= e19CongcondData.AINF_SEQN %>">
    <input type="hidden" name="RowCount_report" value="<%=E19DisasterData_vt.size()+1%>">
    <input type="hidden" name="addOrChangeFlag" value="add">
<!--  HIDDEN  처리해야할 부분 -->
    <input type="hidden" name="CONG_CODE" value="<%= e19CongcondData.CONG_CODE %>">
    <input type="hidden" name="RELA_CODE" value="<%= e19CongcondData.RELA_CODE %>">
    <input type="hidden" name="HOLI_CONT" value="<%= e19CongcondData.HOLI_CONT %>">
    <input type="hidden" name="EREL_NAME" value="<%= e19CongcondData.EREL_NAME %>">
    <!-- <input type="hidden" name="CONG_DATE" value="<%= e19CongcondData.CONG_DATE %>"> -->
    <input type="hidden" name="WAGE_WONX" value="<%= e19CongcondData.WAGE_WONX %>">
    <input type="hidden" name="CONG_RATE" value="<%= e19CongcondData.CONG_RATE %>">
    <input type="hidden" name="CONG_WONX" value="<%= e19CongcondData.CONG_WONX %>">
    <input type="hidden" name="PROV_DATE" value="<%= e19CongcondData.PROV_DATE %>">
    <input type="hidden" name="BANK_NAME" value="<%= e19CongcondData.BANK_NAME %>">
    <input type="hidden" name="BANKN"     value="<%= e19CongcondData.BANKN     %>">
    <input type="hidden" name="WORK_YEAR" value="<%= e19CongcondData.WORK_YEAR %>">
    <input type="hidden" name="WORK_MNTH" value="<%= e19CongcondData.WORK_MNTH %>">
    <input type="hidden" name="RTRO_MNTH" value="<%= e19CongcondData.RTRO_MNTH %>">
    <input type="hidden" name="RTRO_WONX" value="<%= e19CongcondData.RTRO_WONX %>">
    <input type="hidden" name="BEGDA"     value="<%= e19CongcondData.BEGDA     %>">

    <input type="hidden" name="LIFNR"     value="<%= e19CongcondData.LIFNR %>">
    <input type="hidden" name="BANKL"     value="<%= e19CongcondData.BANKL %>">


    <input type="hidden" name="AccountData_pers_RowCount" value="<%=AccountData_pers_vt.size()%>">
<%
    /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
    for(int i = 0 ; i < AccountData_pers_vt.size() ; i++){
        AccountData data_vt = (AccountData)AccountData_pers_vt.get(i);//은행계좌번호 BANKN , 은행명 BANKA
%>
    <input type="hidden" name="p_LIFNR<%= i %>" value="<%= data_vt.LIFNR %>">
    <input type="hidden" name="p_BANKN<%= i %>" value="<%= data_vt.BANKN %>">
    <input type="hidden" name="p_BANKA<%= i %>" value="<%= data_vt.BANKA %>">
    <input type="hidden" name="p_BANKL<%= i %>" value="<%= data_vt.BANKL %>">
<%
    }
%>
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
  <form name="form3" method="post">
    <input type="hidden" name = "CONG_DATE" value="">
    <input type="hidden" name = "PERNR" value="<%=e19CongcondData.PERNR%>">
  </form>
  <iframe name="ifHidden" width="0" height="0" />
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

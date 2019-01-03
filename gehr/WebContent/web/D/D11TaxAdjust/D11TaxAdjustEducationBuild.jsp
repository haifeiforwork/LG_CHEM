<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustEducationBuild.jsp                              */
/*   Description  : 특별공제 교육비 신청/수정/조회                              */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2013-07-01  손혜영                                          */
/*                  2013-11-25  CSR ID:2013_9999 2013년말정산반영               */
/*                              재활비삭제후 장애인교육비 항목추가              */
/* 				    2018-01-04 cykim [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건*/
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
<%@ page import=" java.lang.reflect.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(user.companyCode, user.empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector edu_vt     = (Vector)request.getAttribute("edu_vt" );
    //연말정산 확정여부 조회
    String o_flag     = (String)request.getAttribute("o_flag" );
    String jobid     = (String)request.getAttribute("jobid" );
    //내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    //교육비
    String Gubn = "Tax03";

    //@v1.3
    D11TaxAdjustPePersonRFC   rfcPeP   = new D11TaxAdjustPePersonRFC();
    Vector EduPeP_vt = new Vector();
    EduPeP_vt      = rfcPeP.getPePerson( "3",user.empNo, targetYear  ); //I_GUBUN :1 - 보험료 2- 의료비  3-교육비 4-신용카드
    //관계 선택시 비교용
    String old_Name = "";


    //입력가능한 초기 row 생성용
    int edu_count = 8;
    if( edu_vt.size()  >= edu_count ) {
        edu_count = edu_vt.size()+1;
    }
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">

    //전체 공통 이벤트 적용
    $(document).ready(function(){

        //체크박스가 선택될 때 값 세팅 function
        $(':checkbox').click(function(){
            var nm = this.name;
            var nm1 = nm.split('_')[0];
            var nm2 = nm.split('_')[1];
            if(nm1!="chkedit"){ //선택 체크박스는 제외:삭제 시 값이 셋팅되어야함
                if(this.checked){
                    //체크 2개 못되게 막기(교복과 재활)<!-- CSR ID:2013_9999 -->
                    //if((nm1=="exsty"&&$("input[name=actcheck_"+nm2 + "]").attr("checked"))
                    //||(nm1=="actcheck"&&$("input[name=exsty_"+nm2 + "]").attr("checked"))){
                    //  alert("교복구입비와 재활비는 동시에 체크하실 수 없습니다.");
                    //  this.checked=false;
                    //  return;
                    //}
                    this.value="X";
                } else {
                    this.value="";
                }
            }
        });

        //select change
        $('select').change(function(){
            var nm = this.name;
            var nm1 = nm.split('_')[0];
            var nm2 = nm.split('_')[1];
            //성명 select
            if(nm1=="ename"){
                var val = $(this).children("option:selected").val();
                var val1 = val.split('_')[0];
                var val2 = val.split('_')[1];
                var val3 = val.split('_')[2];
                var val4 = val.split('_')[3];

                $("select[name=subty_" + nm2 + "] option[value=" + val1 + "]").attr("selected",true);   //관계 selectbox 선택
                $("input[name=ename_"+nm2 + "]").attr("readonly", false);   //금액 활성화 CSR ID: 2013_9999
                $("input[name=fregno_"+nm2 + "]").val(addResBar(val2)); //주민번호 셋팅
                $("input[name=betrg_"+nm2 + "]").attr("readonly", false);   //금액 활성화
                $("input[name=betrg_"+nm2 + "]").attr("class", "input03");
                $("input[name=betrg_" + nm2 + "]").val(''); //금액 초기화

                $("select[name=fasar_" + nm2 + "]").val('');    //학력 초기화
                $("input[name=exsty_"+nm2 + "]").val('');   //교복초기화
                $("input[name=exsty_"+nm2 + "]").attr({disabled:true,checked:false});   //교복초기화
                $("input[name=actcheck_"+nm2 + "]").val('');//장애초기화
                $("input[name=actcheck_"+nm2 + "]").attr({disabled:true,checked:false});//장애초기화
                /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  */
                $("input[name=exstyh_"+nm2 + "]").val('');   //현장학습비초기화
                $("input[name=exstyh_"+nm2 + "]").attr({disabled:true,checked:false});   //현장학습비초기화
                $("input[name=loan_"+nm2 + "]").val('');   //학자금상환 초기화
                $("input[name=loan_"+nm2 + "]").attr({disabled:true,checked:false});   //학자금상환 초기화
                /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end  */

                // 관계코드 인경우 금액 비활성처리(직계존속은 교육비 공제 안됨):
                // 01-부, 02-모, 11-조부, 12-조모, 13-장인, 14-장모, 22-시부, 23-시모,
                // 26-처조부, 27-처조모, 30-외조부, 31-외조모, 45-시조모, 46-시조부
                var notValue = new Array("01","02","11","12","13","14","22","23","26","27","30","31","45","46");
                for (r=0;r< notValue.length;r++) {
                    if ( val1 == notValue[r]){
                        if(val3!="X"){
                            $("input[name=betrg_"+nm2 + "]").val('');
                            $("input[name=betrg_"+nm2 + "]").attr("readonly",true);
                            $("input[name=betrg_"+nm2 + "]").attr("class", "input04");
                            alert("<spring:message code='MSG.D.D11.0032' />"); //직계존속은 공제대상이 아닙니다.
                        }
                        break;
                    }
                }
                //장애
                if(val3=="X"){
                    $("input[name=actcheck_"+nm2 + "]").val('X');
                    $("input[name=actcheck_"+nm2 + "]").attr({disabled:false,checked:true});
                }

                /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start  */
                if(val1 == "35"){
                	$("input[name=loan_"+nm2 + "]").attr("disabled",false);
                }
                /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end */
            }

            //학력 select
            if(nm1=="fasar"){
                $("input[name=exsty_"+nm2 + "]").val('');   //교복초기화
                $("input[name=exsty_"+nm2 + "]").attr({disabled:true,checked:false});   //교복초기화
                //[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건
                $("input[name=exstyh_"+nm2 + "]").val('');   //현장학습비초기화
                $("input[name=exstyh_"+nm2 + "]").attr({disabled:true,checked:false});   //현장학습비초기화
                var val = $(this).children("option:selected").val();
                var subty = $("select[name=subty_" + nm2 + "]").children("option:selected").val();
                //@v1.4 본인( subty:35)인 경우만 대학원(H1) 선택가능하게
                if(subty!="35"&&val=="H1"){
                    $(this).val('');
                    alert("<spring:message code='MSG.D.D11.0033' />"); //대학원 교육비 공제는 본인만 가능합니다.!
                }
                //@2011 교복구입비 D1:중학생, E1:고등학생인 경우만 가능
                /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start */
                //2017 본인(subty:35)이 아닌경우만 교육구입비 선택가능
				if(subty != "35"){
	                if(val=="D1"||val=="E1"){
	                    $("input[name=exsty_"+nm2 + "]").attr("disabled",false);
	                }
				}
                // CSR ID: 2013_9999 장애인 경우만 I1:장애인 특수교육선택가능

                /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start */
                //@2017 현장학습비 C1:초등학교, D1:중학생, E1:고등학생인 경우만 가능
                //2017 본인(subty:35)이 아닌경우만 현장학습비 선택가능
                if(subty != "35"){
	                if(val=="C1"||val=="D1"||val=="E1"){
	                    $("input[name=exstyh_"+nm2 + "]").attr("disabled",false);
	                }
                }
                /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end */

                var enamVal = $("select[name=ename_" + nm2 + "]").children("option:selected").val();
                var val1 = enamVal.split('_')[0];
                var val2 = enamVal.split('_')[1];
                var val3 = enamVal.split('_')[2];
                if(subty!=""&& val=="I1"){
                    if (val3!="X" ) {
                        $(this).val('');
                        alert("<spring:message code='MSG.D.D11.0034' />"); //장애인 특수교육은 장애인 경우만 가능합니다.!
                        $("input[name=actcheck_"+nm2 + "]").attr({checked:false});//장애초기화
                    }else{
                        $("input[name=actcheck_"+nm2 + "]").attr({checked:true});//장애체크
                    }
                }else if(subty!=""&& val!="I1"){
                        $("input[name=actcheck_"+nm2 + "]").attr({checked:false});//장애체크
                }

            }

        });
    });

    //테이블에 행추가 function
    function add_field(){
        var tbody = $('#table1 tbody'); //id가 table1인 obj 의 tbody obj를 찾는다.
        var rows = tbody.find('tr').length; //tbody obj의 갯수를 찾는다.
        var newRow = tbody.find('tr:last').clone(true).appendTo(tbody); //tbody의 마지막 row를 복사하여 생성한다.

        ctlTb(newRow, rows);    //생성한 row의 환경설정
    }

    //생성한 row의 환경세팅 function
    function ctlTb(jRowobj, rowCnt){
        jRowobj.show(); //보여주기
        var cls = jRowobj.attr("class");
        if (cls== "listTableHover oddRow") jRowobj.removeClass( "oddRow");
        else  jRowobj.addClass("oddRow");

        jRowobj.find(':checkbox').attr({checked:false,disabled:true});  //체크박스 체크 해제, disabled 처리
        jRowobj.find(':input').val('').each(function(){ //input value 초기화
            var nm = this.name;
            var nm1 = nm.split('_')[0];
            this.name = nm1+'_'+rowCnt; //생성한 row의 input name을 바꿔준다.
            if(nm1=="chkedit" || nm1=="chnts"){ // 선택, 국세청자료 disabled 해제
                this.disabled = false;
            }

            if(nm1 == "ename"){ // 성명 select box 초기화
                this.options[0].selected = true;    //첫번째 옵션 선택해준다.
            }

        });
    }

    //테이블에 선택한 행삭제 function : 실제적으로는 숨김처리하고 구분자로 삭제하지 않은 데이터만 처리
    function remove_field(){

    	   var row_checkCnt=0;
            var tbody = $('#table1 tbody'); //id가 table1인 obj 의 tbody obj를 찾는다.
			var rows = tbody.find('tr').length; //tbody obj의 갯수를 찾는다.
			var row_cnt = 0;
			for( var i = 0 ; i < rows ; i++ ) {
				var chkedit = $("input[name=chkedit_"+ i + "]").val();
				if(chkedit!="X"){
					row_cnt = row_cnt+1;
				}
			}
            if ( row_cnt == 0 ) {
                alert("<spring:message code='MSG.D.D11.0020' /> "); //입력항목을 더이상 줄일수 없습니다.
                return;
            }

            tbody.find(':checkbox').each(function(){    //checkbox obj를 찾는다.
                var nm = this.name;
                var nm1 = nm.split('_')[0];
                if(nm1 == "chkedit" && this.checked && this.value!="X"){   //행삭제용 checkbox obj 중 체크된 obj를 찾는다.
                    var parents = $(this).parent().parent();    //해당 tr obj를 찾는다.
                    $(parents).hide();  //해당 tr obj를 숨김처리
                    this.value="X";     //체크박스 value set
                    row_checkCnt=row_checkCnt+1;

                }
            });
            if(row_checkCnt==0){
            	alert("<spring:message code='MSG.D.D11.0021' />"); //삭제할 건을 선택하세요.
            }

        }


    //특별공제 교육비 - 저장전 체크
    function chk_build(){
        var tbody = $('#table1 tbody'); //id가 table1인 obj 의 tbody obj를 찾는다.
        var rows = tbody.find('tr').length; //tbody obj의 갯수를 찾는다.
        document.form1.rowCount.value=rows;

        for( var i = 0 ; i < rows ; i++ ) {
            //삭제,자동반영 빼고 값 검증
            var chkedit = $("input[name=chkedit_"+ i + "]").val();
            var gubun = $("input[name=gubun_"+ i + "]").val();
            var pdf = $("input[name=pdf_"+ i + "]").val();

                var betrg = removeComma($("input[name=betrg_"+ i + "]").val());

            var sname = $("select[name=ename_"+ i + "]").children("option:selected").text();
            $("input[name=fname_"+ i + "]").val(sname);

            if(gubun!="X"&&chkedit!="X"&&pdf!="X"){
                var subty = $("select[name=subty_"+ i + "]").children("option:selected").val();
                var ename = $("select[name=ename_"+ i + "]").children("option:selected").val();
                var fasar = $("select[name=fasar_"+ i + "]").children("option:selected").val();
            //  var betrg = removeComma($("input[name=betrg_"+ i + "]").val());
                var exsty = $("input[name=exsty_"+ i + "]").val();
                var actcheck = $("input[name=actcheck_"+ i + "]").val();
                var chnts = $("input[name=chnts_"+ i + "]").val();
                var sname = $("select[name=ename_"+ i + "]").children("option:selected").text();
                if(subty==""&&ename=="___"&&fasar==""&&betrg==""&&exsty==""&&actcheck==""&&chnts==""){
                    //빈 row 검증하여 skip
                    $("input[name=empty_"+ i + "]").val('X');
                    continue;
                }

                if(subty==""||ename=="___"||fasar==""){
                    alert("<spring:message code='MSG.D.D11.0030' />"); //관계, 성명, 학력은 필수 항목입니다.
                    return false;
                }

                if(Number(betrg)==0){
                    alert("<spring:message code='MSG.D.D11.0036' />"); //금액에 값을 입력하세요.
                    return false;
                }
                $("input[name=fname_"+ i + "]").val(sname);
                //CSR ID:2013_9999 I1: 장애인특수교육
                if(fasar=="I1" ){
                  $("input[name=actcheck_"+i + "]").attr({disabled:false,checked:true});    //장애인교육비
                  $("input[name=actcheck_"+i + "]").val('X');   //장애인교육비
                }
            }


                var fregno = removebar($("input[name=fregno_"+ i + "]").val());
                //mma replaceall 처리안되어 웹에서처리
                $("input[name=betrg_"+ i + "]").val(betrg);
                $("input[name=fregno_"+ i + "]").val(fregno);

        }

        return true;

    }

    //enable 처리
    function setEnable(){
        var tbody = $('#table1 tbody');
        tbody.find(':input').each(function(){
            this.disabled = false;
        });
        
        //세대주여부
        eval("document.form1.FSTID.disabled = false;") ; //세대주여부
        if( eval("document.form1.FSTID.checked == true") )
           eval("document.form1.FSTID.value ='X';");
    }

    //특별공제 교육비 - 신청
    function do_build(){
        if(!chk_build()) return;

        if(confirm("<spring:message code='MSG.D.D11.0037' />")){ //입력하시겠습니까?
            setEnable();

            
            document.form1.jobid.value = "build";
            document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEducationSV";
            document.form1.method      = "post";
            document.form1.target      = "menuContentIframe";
            document.form1.submit();
        }
    }

    //입력취소
    function cancel(){
        if(confirm("<spring:message code='MSG.D.D11.0038' />")){ //입력작업을 취소하시겠습니까?
            document.form1.jobid.value = "first";
            document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustEducationSV";
            document.form1.method = "post";
            document.form1.target = "menuContentIframe";
            document.form1.submit();
        }
    }

    /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start */
  	//@2017연말정산 교복구입비, 현장학습비 선택 중복 불가
    function noDup(code , i ){//code 1 = 교복구입, 2 = 현장학습
        var glassVal = "";
        if(code== "1" && eval("document.form1.exsty_"+i+".checked")){
            eval("document.form1.exstyh_"+i+".checked = false");
        }else if (code == "2" && eval("document.form1.exstyh_"+i+".checked")){
            eval("document.form1.exsty_"+i+".checked = false");
        }
    }
    /* [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end */

</SCRIPT>
</head>


 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>
<form name="form1" method="post">

    <%@ include file="/web/D/D11TaxAdjust/D11TaxAdjustButton.jsp" %>


    <!--특별공제 테이블 시작-->
    <div class="listArea">

<%
    if(  !o_flag.equals("X") ) {
%>
        <div class="listTop">
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:add_field();"><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><!-- 추가 --></span></a></li>
                    <li><a href="javascript:remove_field();"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><!-- 삭제 --></span></a></li>
                </ul>
            </div>
        </div>
<%
    }
%>

        <div class="table">
            <table id = "table1" class="listTable">
                <thead>
                    <tr>
                      <th><spring:message code="LABEL.D.D11.0047" /><!-- 선택 --></th>
                      <th><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
                      <th><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></th>
                      <th><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></th>
                      <th><spring:message code="LABEL.D.D11.0018" /><!-- 학력 --></th>
                      <th><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                      <th><spring:message code="LABEL.D.D11.0119" /><!-- 교복<BR/>구입비 --></th>
                      <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
					  <th><spring:message code="LABEL.D.D11.0287" /><!-- 현장<BR/>학습비 --></th>
                      <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
                      <th><spring:message code="LABEL.D.D11.0120" /><!-- 장애인<br>교육비 --></th><!--CSR ID:2013_9999 -->
                      <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
                      <th><spring:message code="LABEL.D.D11.0288" /><!-- 학자금<br>상환 --></th>
                      <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
                      <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
                      <%--<th><spring:message code="LABEL.D.D11.0121" /><!-- 회사<br>지원분 --></th> --%>
                      <th><spring:message code="LABEL.D.D11.0076" /><!-- 국세청<BR/>자료 --></th>
                      <% if("Y".equals(pdfYn)) {%>
                      <th><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                      <%} %>
                      <th class="lastCol"><spring:message code="LABEL.D.D11.0122" /><!-- 연말정산<BR/>삭제 --></th>
                    </tr>
                </thead>
                <tbody>
<%
    for( int i = 0 ; i < edu_vt.size() ; i++ ){
        D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)edu_vt.get(i);
%>
<%
    //자동반영분일때와 아닐때 달라짐
%>
        <tr <%= data.GUBUN.equals("1")  ? "style='background-color:#f5f5f5;'" : "" %> class="<%=WebUtil.printOddRow(i) %>">
          <td><input type="checkbox" name="chkedit_<%=i%>" value="" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "" %>></td>
          <td>
            <select name="subty_<%= i %>" disabled>
              <option value="">---------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %>
            </select>
          </td>
          <td>
              <select name="ename_<%= i %>" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "input04" : "input03" %>" width=10 <%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "" %>>
                <option value="___">---------</option>
<%
    //@v1.3

    for( int j1 = 0 ; j1 < EduPeP_vt.size() ; j1++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)EduPeP_vt.get(j1);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {
%>
             <option value="<%=fdata.KDSVH%>_<%=fdata.REGNO%>_<%=fdata.HNDID%>_<%=fdata.ENAME%>"  <%=fdata.REGNO.equals(data.F_REGNO) ? "selected" : ""%> ><%=fdata.ENAME%></option>
<%
         }
         old_Name = fdata.ENAME;

    }
%>

              </select>
          </td>
          <td>
            <input type="hidden" name="fname_<%=i%>" >
            <input type="text" name="fregno_<%=i%>" value="<%= data.F_REGNO.equals("") ? "" : DataUtil.addSeparate(data.F_REGNO) %>" size="13" readonly maxlength="14" disabled>
          </td>
          <td>
            <select name="fasar_<%= i %>" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "input04" : "input03" %>" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "" %>>
              <option value="">-----------</option>
<%= WebUtil.printOption((new D11FamilyScholarshipRFC()).getFamilyScholarship(), data.FASAR) %>
            </select>
          </td>
          <td>
            <input type="text" name="betrg_<%= i %>" value="<%= data.BETRG.equals("0.0")  ? "" : WebUtil.printNumFormat(data.BETRG) %>" size="12" maxlength="11" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "input04" : "input03" %>" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "readonly" : "" %>>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
          <!-- @2017연말정산 교복구입비, 현장학습비 선택 중복 불가 -->
          <td><!--@2011 교복구입비 -->
            <input type="checkbox" name="exsty_<%=i%>" value="<%=  data.EXSTY.equals("") ? "" : data.EXSTY %>" <%= data.EXSTY.equals("X")  ? "checked" : "" %> <%= data.GUBUN.equals("1")||(!data.FASAR.equals("D1")&&!data.FASAR.equals("E1"))||data.GUBUN.equals("9")  ? "disabled" : "" %> onclick="noDup('1','<%=i%>');">
          </td>
          <!--@2011 재활비 -->
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
		  <td><!--@2017 현장학습비 -->
            <input type="checkbox" id="exstyh_<%=i%>" name="exstyh_<%=i%>" value="<%=  data.EXSTY.equals("") ? "" : data.EXSTY %>" <%= data.EXSTY.equals("F")  ? "checked" : "" %> <%= data.GUBUN.equals("1")||(!data.FASAR.equals("C1")&&!data.FASAR.equals("D1")&&!data.FASAR.equals("E1"))||data.GUBUN.equals("9")  ? "disabled" : "" %> onclick="noDup('2','<%=i%>');">
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->

          <td><!--CSR ID:2013_9999  장애인 교육비-->
            <input type="checkbox" name="actcheck_<%=i%>" value="<%=  data.ACT_CHECK.equals("") ? "" : data.ACT_CHECK %>" <%= data.ACT_CHECK.equals("X")  ? "checked" : "" %> <%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "disabled" %>>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
		  <td><!--@2017 학자금상환-->
            <input type="checkbox" name="loan_<%=i%>" value="<%=  data.LOAN.equals("") ? "" : data.LOAN %>" <%= data.LOAN.equals("X")  ? "checked" : "" %> <%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "" %>>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->

          <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
          <td style="display:none"><!--@2011 자동반영분 -->
            <input type="checkbox" name="gubun_<%=i%>" value="<%=  data.GUBUN.equals("1") ? "X" : "" %>" <%= data.GUBUN.equals("1")  ? "checked" : "" %> disabled>
          </td>
          <td><!--@국세청자료-->
            <input type="checkbox" name="chnts_<%=i%>" value="<%=  data.CHNTS.equals("") ? "" : data.CHNTS %>" <%= data.CHNTS.equals("X")  ? "checked" : "" %> <%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "disabled" : "" %>>
          </td>
          <% if("Y".equals(pdfYn)) {%>
          <td >
           <input type="checkbox" name="pdf_<%=i%>" value="<%=  data.GUBUN.equals("9") ? "X" : "" %>" <%= data.GUBUN.equals("9")  ? "checked" : "" %> disabled>
          </td>
          <%} else {%>
            <div style="display:none">
            <input type="checkbox" name="pdf_<%=i%>">
            </div>
          <%} %>
          <td class="lastCol"><!--@삭제-->
            <input type="checkbox" name="omitflag_<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "" : "disabled" %>>
            <input type="hidden" name="seqnr_<%=i%>" value="<%=  data.SEQNR %>">
            <input type="hidden" name="empty_<%=i%>" value="">
          </td>
        </tr>
<%
    }
%>



<%
    //입력 빈 필드 만들기
    for( int j = edu_vt.size() ; j < edu_count ; j++ ){

%>
    <tr class="<%=WebUtil.printOddRow(j) %>">
        <td><input type="checkbox" name="chkedit_<%=j%>" value=""></td>
        <td>
            <select name="subty_<%= j %>" disabled>
              <option value="">---------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), "") %>
            </select>
          </td>
          <td>
              <select name="ename_<%= j %>" width="10">
                <option value="___">---------</option>
<%
    //@v1.3

    for( int k= 0 ; k < EduPeP_vt.size() ; k++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)EduPeP_vt.get(k);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {
%>
             <option value="<%=fdata.KDSVH%>_<%=fdata.REGNO%>_<%=fdata.HNDID%>_<%=fdata.ENAME%>"  <%=fdata.REGNO.equals("") ? "selected" : ""%>><%=fdata.ENAME%></option>
<%
         }
         old_Name = fdata.ENAME;

    }
%>

              </select>
          </td>
          <td>
              <input type="hidden" name="fname_<%=j%>" >
              <input type="text" name="fregno_<%=j%>" value="" size="13" readonly maxlength="14" disabled>
           </td>
          <td><!--학력-->
            <select name="fasar_<%= j %>" >
              <option value="">-----------</option>
<%= WebUtil.printOption((new D11FamilyScholarshipRFC()).getFamilyScholarship(), "") %>
            </select>
          </td>
          <td>
            <input type="text" name="betrg_<%= j %>" value="" size="12" maxlength="11" onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right" onFocus="this.select()" >
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
          <!-- @2017연말정산 교복구입비, 현장학습비 선택 중복 불가 -->
          <td><!--@2011 교복구입비 -->
            <input type="checkbox" name="exsty_<%=j%>" value="" onclick="noDup('1','<%=j%>');" disabled>
          </td>
		  <td><!--@2017 현장학습비 -->
            <input type="checkbox" name="exstyh_<%=j%>" value="" onclick="noDup('2','<%=j%>');" disabled>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
          <!--@2013 재활비 -->
          <!--CSR ID:2013_9999-->
          <td>
            <input type="checkbox" name="actcheck_<%=j%>" value=""  disabled>
          </td>
          <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
          <td style="display:none"><!--@2011 자동반영분 -->
            <input type="checkbox" name="gubun_<%=j%>" value="" disabled>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
		  <td><!--@2017 학자금상환-->
            <input type="checkbox" name="loan_<%=j%>" value="" disabled>
          </td>
          <!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
          <td><!--@국세청자료-->
            <input type="checkbox" name="chnts_<%=j%>" value="">
          </td>
          <% if("Y".equals(pdfYn)) {%>
          <td>
           <input type="checkbox" name="pdf_<%=j%>" value="" disabled>
          </td>
          <%} else {%>
            <div style="display:none">
            <input type="checkbox" name="pdf_<%=j%>">
            </div>
          <%} %>
          <td class="lastCol"><!--@삭제-->
            <input type="checkbox" name="omitflag_<%=j%>" value=""  disabled>
            <input type="hidden" name="seqnr_<%=j%>" value="">
            <input type="hidden" name="empty_<%=j%>" value="">
          </td>
    </tr>

<%
    }
%>


                </tbody>
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
            <li><a class="darken" href="javascript:do_build();"><span><spring:message code="LABEL.D.D11.0073" /><!-- 입력 --></span></a></li>
            <li><a href="javascript:cancel();"><span><spring:message code="LABEL.D.D11.0125" /><!-- 취소 --></span></a></li>
        </ul>
    </div>

<%
    }
%>


    <div class="commentImportant" style="width:720px;">
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
        <%--<p><spring:message code="LABEL.D.D11.0123" /><!-- 1. 회사에서 지원 받은 교육비 내역이 보여지며, 연말정산 공제 적용하기 위해서는 "연말정산삭제"열 체크 된 부분을 해지해야 함 --></p> --%>
        <p><spring:message code="LABEL.D.D11.0124" /><!-- 1. 중/고등학교의 교복(체육복)구입비 입력시 “교복구입비”체크란에 반드시 체크해야 함 --></p>
		<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start -->
		<p><spring:message code="LABEL.D.D11.0286" /><!-- 2. 체험학습비(초/중/고생 30만원 한도) --></p>
		<p><spring:message code="LABEL.D.D11.0289" /><!-- 3. 학자금 상환 : 든든학자금 등의 학자금대출 원리금 상환액<br>&nbsp;&nbsp;(‘17.1.1 이후 상환하는 학자금 대출분에 한하여 공제 가능,<br>&nbsp;&nbsp;&nbsp;旣 이미 연말정산 공제 받은 금액에 대해서 중복공제 불가) --></p>
		<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end -->
    </div>

</div>

<!-- 숨겨진 필드 -->
<input type="hidden" name="jobid"      value="">
<input type="hidden" name="targetYear" value="<%= targetYear %>">
<input type="hidden" name="rowCount"   value="">
<!-- 숨겨진 필드 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 신규신청 결재                                      */
/*   Program Name : 주택자금 신규신청 결재                                      */
/*   Program ID   : G052ApprovalHouse.jsp                                       */
/*   Description  : 주택자금 신규신청 결재할 수 있도록 하는 화면                */
/*   Note         :                                                             */
/*   Creation     : 2005-03-09  윤정현                                          */
/*   Update       : 2005-11-14  @v1.1 C2005110701000000370 반려시 에러          */
/*                                      [CSRID : 2545905]  시간선택제 (주택자금) 수정요청 건                    */
/*                     2014-06-27  [CSR ID:2564967] 주택자금신규신청 화면 수정  화면 최초 호출 시 상환일자 등 자동 호출*/
/*  					2015-05-07  [CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정  */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    E05HouseData    e05HouseData    = (E05HouseData)request.getAttribute("e05HouseData");
    E05PersInfoData e05PersInfoData = (E05PersInfoData)request.getAttribute("E05PersInfoData");
    Vector       vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String       RequestPageName = (String)request.getAttribute("RequestPageName");

//  @CSR1 : 시간제의 경우 사전 popup 추가 2014.05.21 (사무직(4H) : 50% 지급, 사무직(6H) : 75% 지급)
    String      E_COUPLEYN          = (String)request.getAttribute("E_COUPLEYN");   //Y: 시간제 근무의 경우
    String      E_MESSAGE           = (String)request.getAttribute("E_MESSAGE");   //Y: 시간제 근무의 경우 메세지 처리

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if


    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e05HouseData.AINF_SEQN ,user.empNo, false);
    int approvalStep = docinfo.getApprovalStep();

    //※ 기상환없이 추가 대출 가능하게 하기 위하여 담당자결재시 한도금액체크로직 추가
    // 진행중인건 대출금액목록[C20110808_41085]

    Vector  E05MaxMoneyData_vt = (Vector)request.getAttribute("E05MaxMoneyData_vt");
    Vector  PersLoanData_vt    = (Vector)request.getAttribute("PersLoanData_vt");
    Vector  IngPersLoanData_vt = (Vector)request.getAttribute("IngPersLoanData_vt");

    // 급여계좌 리스트를 구성한다.@v1.0
    E05HouseBankCodeRFC  rfc_bank    = new E05HouseBankCodeRFC();
    Vector          e05BankCodeData_vt = rfc_bank.getBankCode();
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

function approval()
{
    var frm = document.form1;

<%  if ( approvalStep == DocumentInfo.DUTY_CHARGER || approvalStep == DocumentInfo.DUTY_MANGER) { %>

    if ( frm.ZZSECU_FLAG.disabled == true ) {
        frm.ZZSECU_FLAG.disabled = false;
    }
    if ( frm.PROOF.disabled == true ) {
        frm.PROOF.disabled = false;
    }
    if ( frm.ZZRELA_CODE.disabled == true ) {
        frm.ZZRELA_CODE.disabled = false;
    }
 <%if(Double.parseDouble(e05HouseData.REQU_MONY)*100>20000000.0){%>
    if ( frm.ZZRELA_CODE2.disabled == true ) {
        frm.ZZRELA_CODE2.disabled = false;
    }
  <%}%>
    //※ 한도금액체크 로직 추가[C20110808_41085]
    loantype = frm.DLART.value;
    max_money = max_amount(loantype);
    requ_money = removeComma(document.form1.DARBT.value);
    if( requ_money > max_money ) {
        comma_money = insertComma(max_money+"");
        if (document.form1.ingcount.value > 0){
            alert("신청진행중 금액도 기대출금액으로 환산하여 \n신청 가능금액은 " + comma_money + "원이하 입니다.");
        }else{
            alert("신청금액이 너무 많습니다.\n신청 가능금액은 " + comma_money + "원이하 입니다.");
        }
        return;
    }

    if ( frm.DARBT.value == "" || parseInt(removeComma(frm.DARBT.value), 10) == 0 ) {
        alert("대출승인금액을 입력해 주시기 바랍니다.");
        return;
    }

    if ( frm.MONY_RATE.value == "" || parseInt(removeComma(frm.MONY_RATE.value), 10) == 0 ) {
        alert("개별금리를 입력해 주시기 바랍니다.");
        return;
    }

    if ( frm.ZAHLD.value == ""  ) {
        alert("지급일을 입력해 주시기 바랍니다.");
        frm.ZAHLD.select();
        return;
    }

    //[CSR ID:2564967]
    if ( frm.ZZRPAY_MNTH.value == ""||frm.ZZRPAY_CONT.value == "" ||frm.REFN_BEGDA.value == ""||frm.ZZRPAY_CONT.value == "" ){
    	alert("지급일의 검색버튼을 누르시기 바랍니다.");
        frm.ZAHLD.select();
        return;
    }

    if ( frm.PROOF.checked == true ) {
        frm.PROOF.value = "X";
    } else {
        alert("증빙확인에 체크해주시기 바랍니다.");
        return;
    }
    //[CSR ID:1411665]지급일 체크로직 삭제요청
    //if ( removePoint(frm.ZAHLD.value) < "<%= DataUtil.getCurrentDate()%>" ) {
    //    alert("지급일이 결재일 보다 커야 합니다.");
    //    return;
    //}

    if ( frm.ZZSECU_FLAG.value == "Y" ) {

        if ( frm.ZZSECU_NAME.value == "" ) {
            alert("보증인 성명을 입력하세요.");
            frm.ZZSECU_NAME.select();
            return;
        }
        if ( frm.ZZRELA_CODE.options[frm.ZZRELA_CODE.selectedIndex].value == "" ) {
            alert("보증인 관계를 입력하세요.");
            frm.ZZRELA_CODE.focus();
            return;
        }
        if ( frm.ZZSECU_REGNO.value == "" ) {
            alert("보증인 주민등록번호를 입력하세요.");
            frm.ZZSECU_REGNO.select();
            return;
        }
        if ( frm.ZZSECU_TELX.value == "" ) {
            alert("보증인 연락처를 입력하세요.");
            frm.ZZSECU_TELX.select();
            return;
        }
     <% if(Double.parseDouble(e05HouseData.REQU_MONY)*100>20000000.0){%>
        if ( frm.ZZSECU_NAME2.value == "" ) {
            alert("보증인 성명을 입력하세요.");
            frm.ZZSECU_NAME2.select();
            return;
        }
        if ( frm.ZZRELA_CODE2.options[frm.ZZRELA_CODE2.selectedIndex].value == "" ) {
            alert("보증인 관계를 입력하세요.");
            frm.ZZRELA_CODE2.focus();
            return;
        }
        if ( frm.ZZSECU_REGNO2.value == "" ) {
            alert("보증인 주민등록번호를 입력하세요.");
            frm.ZZSECU_REGNO2.select();
            return;
        }
        if ( frm.ZZSECU_TELX2.value == "" ) {
            alert("보증인 연락처를 입력하세요.");
            frm.ZZSECU_TELX2.select();
            return;
        }
     <% } %>
    }

	 <% if ( E_COUPLEYN.equals("Y") ) { %>
             if (!confirm("<%=E_MESSAGE%>")) {
                 return;
             }
         <% } // end if %>

	// [[CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정] 결재시 사원서브그룹체크(주택신규,장학자금)
	// 사원서브그룹 : 14-계약직(자문고문), 24-계약직, 34-계약직(생산기술직), 35-계약직(전문기술직), 36-계약직(4H), 37-계약직(6H)
    <% if (  "14".equals(user.e_persk)
    		|| "24".equals(user.e_persk)
    		|| "34".equals(user.e_persk)
    		|| "35".equals(user.e_persk)
    		|| "36".equals(user.e_persk)
    		|| "37".equals(user.e_persk)
    	    ) { %>
              if (!confirm("계약직이므로 계약처우 내용을 확인후 결재를 진행해주시기 바랍니다.\n계속진행하시겠습니까?")) {
                 return;
              }
    <% }else{ %>
			//사원 서브그룹 계약직 이외의 사람들
		    if(!confirm("결재 하시겠습니까.")) {
		        return;
		    } // end if
	<%}//사원 서브그룹 체크 끝 %>
    frm.DARBT.value = removeComma(frm.DARBT.value)/100;
    frm.TILBT.value = removeComma(frm.TILBT.value)/100;
    frm.MNTH_INTEREST.value = removeComma(frm.MNTH_INTEREST.value)/100;
    frm.ZAHLD.value = changeChar( frm.ZAHLD.value, ".", "-" );
    frm.REFN_BEGDA.value = changeChar( frm.REFN_BEGDA.value, ".", "-" );
    frm.REFN_ENDDA.value = changeChar( frm.REFN_ENDDA.value, ".", "-" );
    frm.ZZSECU_REGNO.value = changeChar( frm.ZZSECU_REGNO.value, "-", "" );
 <%if(Double.parseDouble(e05HouseData.REQU_MONY)*100>20000000.0){%>
    frm.ZZSECU_REGNO2.value = changeChar( frm.ZZSECU_REGNO2.value, "-", "" );
 <%}%>
<%  } %>

    frm.APPR_STAT.value = "A";
    frm.submit();
}

function reject()
{
    if(!confirm("반려 하시겠습니까.")) {
        return;
    } // end if
    var frm = document.form1;

    frm.DARBT.value = removeComma(frm.DARBT.value)/100;
    frm.TILBT.value = removeComma(frm.TILBT.value)/100;
    frm.MNTH_INTEREST.value = removeComma(frm.MNTH_INTEREST.value)/100;
    frm.ZAHLD.value = changeChar( frm.ZAHLD.value, ".", "-" );
    frm.REFN_BEGDA.value = changeChar( frm.REFN_BEGDA.value, ".", "-" );
    frm.REFN_ENDDA.value = changeChar( frm.REFN_ENDDA.value, ".", "-" );
    frm.ZZSECU_REGNO.value = changeChar( frm.ZZSECU_REGNO.value, "-", "" );
 <% //@v1.1
    if(Double.parseDouble(e05HouseData.REQU_MONY)*100>20000000.0){%>
    frm.ZZSECU_REGNO2.value = changeChar( frm.ZZSECU_REGNO2.value, "-", "" );
 <%}%>

    frm.APPR_STAT.value = "R";

    frm.submit();
}

function goToList()
{
    var frm = document.form1;
    frm.jobid.value ="";
<% if (RequestPageName != null ) { %>
    frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
<% } // end if %>

    frm.submit();
}
function firstHideshow() {
<%  if ( approvalStep != DocumentInfo.POST_MANGER ) { %>
<%      if ( e05HouseData.ZZSECU_FLAG.equals("Y") ) { %>
        guarantee.style.display = "block";
<%      } else { %>
        guarantee.style.display = "none";
<%      } // end if %>
<%  } // end if %>
}

function hideshow(obj) {

    if (obj.value == "Y" ) {
        guarantee.style.display = "block";
    } else {
        guarantee.style.display = "none";
    } // end if
}

function resno_chk(obj){
    if( chkResnoObj_1(obj) == false ) {
        return false;
    }
}

//달력 사용
function fn_openCal(Objectname, moreScriptFunction){
  var lastDate;
  lastDate = eval("document.form1." + Objectname + ".value");
  small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?moreScriptFunction="+moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
}
//달력 사용

function after_event_ZAHLD(){
    event_ZAHLD(document.form1.ZAHLD);
}
function event_ZAHLD(obj){
    if( (obj.value != "") && dateFormat(obj) ){

        document.form3.PERNR.value = document.form1.PERNR.value;
        document.form3.DARBT.value = removeComma(document.form1.DARBT.value)/100;
        document.form3.ZAHLD.value = removePoint(obj.value);

        document.form3.action="<%=WebUtil.JspURL%>G/HiddenHouse.jsp";
        document.form3.target="ifHidden";
        document.form3.submit();
    }
}

function setLoanDetail(ZZRPAY_MNTH, TILBT, REFN_BEGDA, REFN_ENDDA, MNTH_INTEREST ) {
    document.form1.ZZRPAY_MNTH.value = ZZRPAY_MNTH;
    document.form1.TILBT.value       = TILBT;
    document.form1.REFN_BEGDA.value  = changeChar( REFN_BEGDA, "-", "." );
    document.form1.REFN_ENDDA.value  = changeChar( REFN_ENDDA, "-", "." );
    document.form1.MNTH_INTEREST.value = MNTH_INTEREST;
    document.form1.ZZRPAY_CONT.value = "10";
}

function max_amount(loantype) {
    count = document.form1.loantypecount.value;
    oldcount = document.form1.oldcount.value;
    max_money = 0;
    old_money = 0;

    for( i = 0; i < count; i++) {
        loancode = eval("document.form1.LOAN_CODE" + i + ".value");

        if( (loancode == loantype) ){
            max_money = parseFloat(eval("document.form1.LOAN_MONY" + i + ".value"));
        }
    }

    if( loantype == "0020" ) {
        for( i = 0; i < oldcount; i++) {
            loancode = eval("document.form1.OLD_DLART" + i + ".value");
            old_money = old_money + parseFloat(eval("document.form1.OLD_DARBT" + i + ".value"));
        }
        max_money = max_money - old_money;
    } else if( loantype == "0010" ) {
        for( i = 0; i < oldcount; i++) {
            loancode = eval("document.form1.OLD_DLART" + i + ".value");
            old_money = old_money + parseFloat(eval("document.form1.OLD_DARBT" + i + ".value"));
        }
        max_money = max_money - old_money;
    }

    //※ 진행중인건 대출금액목록[C20110808_41085]
    ING_money = 0; //신청진행중인 금액
    if( loantype == "0010" || loantype == "0020" ) {
        for( i = 0; i < document.form1.ingcount.value; i++) {
            loancode = eval("document.form1.ING_DLART" + i + ".value");
            ING_money = ING_money + parseFloat(eval("document.form1.ING_DARBT" + i + ".value"));
        }
        max_money = max_money - ING_money;
    }

    //수정화면에서의 한도체크시 현재 대출승인 금액을 포함해준다.
    curr_money = <%= e05HouseData.DARBT.equals("0") ? Double.parseDouble(e05HouseData.REQU_MONY)*100  :  Double.parseDouble(e05HouseData.DARBT)*100  %>;
    max_money = max_money + curr_money;

    if(max_money < 0) {
        max_money = 0;
    }
    return max_money;
}

//-->
</script>
</head>
<!-- CSR ID:2564967 after_event_ZAHLD(); 추가-->
<%  if ( approvalStep == DocumentInfo.DUTY_CHARGER || approvalStep == DocumentInfo.DUTY_MANGER) { %>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:firstHideshow(); after_event_ZAHLD();">
<%}else{ %>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:firstHideshow();">
<%} %>
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid" value="save">
  <input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
  <input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
  <input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

  <input type="hidden" name="PERNR"         value="<%= e05HouseData.PERNR         %>" >
  <input type="hidden" name="BEGDA"         value="<%= e05HouseData.BEGDA         %>" >
  <input type="hidden" name="AINF_SEQN"     value="<%= e05HouseData.AINF_SEQN     %>" >
  <INPUT TYPE="hidden" name="DLART"         value="<%= e05HouseData.DLART         %>" >
  <INPUT TYPE="hidden" name="DATBW"         value="<%= e05HouseData.DATBW         %>" >
  <INPUT TYPE="hidden" name="TILBG"         value="<%= e05HouseData.TILBG         %>" >
  <INPUT TYPE="hidden" name="DLEND"         value="<%= e05HouseData.DLEND         %>" >
  <INPUT TYPE="hidden" name="REQU_MONY"     value="<%= e05HouseData.REQU_MONY     %>" >
  <INPUT TYPE="hidden" name="POST_DATE"     value="<%= e05HouseData.POST_DATE     %>" >
  <INPUT TYPE="hidden" name="BELNR"         value="<%= e05HouseData.BELNR         %>" >
  <input type="hidden" name="ZPERNR"        value="<%= e05HouseData.ZPERNR        %>" >
  <input type="hidden" name="ZUNAME"        value="<%= e05HouseData.ZUNAME        %>" >
  <input type="hidden" name="AEDTM"         value="<%= e05HouseData.AEDTM         %>" >
  <input type="hidden" name="UNAME"         value="<%= e05HouseData.UNAME         %>" >
  <INPUT TYPE="hidden" name="ZZFUND_CODE"   value="<%= e05HouseData.ZZFUND_CODE   %>" >

  <input type="hidden" name="APPR_STAT">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
  <input type="hidden" name="approvalStep" value="<%=approvalStep%>">

  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="subhead"><h2>주택자금신규신청 결재해야 할 문서</h2></td>
                  </td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td height="10">
              <!-- 신청자 기본 정보 시작 -->
              <%@ include file="/web/common/ApprovalIncludePersInfo.jsp" %>
              <!--  신청자 기본 정보 끝-->
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td>
              <!-- 상단 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5">
                <tr>
                  <td class="tr01">
                  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                  		<tr>
                  			<td>
			                  	<div class="buttonArea">
			                  		<ul class="btn_crud">
			                  			<li><a class="darken" href="javascript:approval()"><span>결재</span></a></li>
			                  			<li><a href="javascript:reject()"><span>반려</span></a></li>
			                          <% if (isCanGoList) {  %>
			                          	<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
			                  			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
			                          <% } // end if %>
			                  		</ul>
			                  	</div>
                  			</td>
                  		</tr>
                      <tr>
                        <td><h2 class="subtitle">신청정보</h2></td>
                      </tr>
                      <tr>
                        <td>
                        	<div class="tableArea">
                        	<table class="tableGeneral">
                            <tr>
                              <th>주택융자유형</th>
                              <td colspan="3"><%= WebUtil.printOptionText((new E05LoanCodeRFC()).getLoanType(), e05HouseData.DLART) %></td>
                            </tr>
                            <tr>
                              <th width="100">현주소</th>
                              <td colspan="3"><%= e05PersInfoData.E_STRAS %></td>
                            </tr>
                            <tr>
                              <th>근속년수</th>
                              <td width="260"><%= e05PersInfoData.E_YEARS %> 년 </td>
                              <th class="th02" width="100" >신청은행</th>
                              <td>
  				<INPUT TYPE="hidden" name="BANK_CODE"   value="<%= e05HouseData.BANK_CODE   %>" >
<%
    for(int i = 0 ; i < e05BankCodeData_vt.size() ; i++){
        E05HouseBankCodeData data_bank = (E05HouseBankCodeData)e05BankCodeData_vt.get(i);
%>
     <%=data_bank.BANK_CODE.equals(e05HouseData.BANK_CODE) ? data_bank.BANK_NAME : "" %>
<%
    }
%>
                              </td>

                            </tr>
                            <tr>
                              <th>자금용도</th>
                              <td>
<%  //CSR ID:1327268
    Vector E05FundCode_vt  = (new E05FundCodeRFC()).getFundCode();

    for( int i = 0 ; i < E05FundCode_vt.size() ; i++ ) {
        E05FundCodeData dt = (E05FundCodeData)E05FundCode_vt.get(i);
        if ( e05HouseData.DLART.equals(dt.DLART)&& e05HouseData.ZZFUND_CODE.equals(dt.FUND_CODE)) {
%>
           <%=dt.FUND_TEXT%>
<%
        }
    }
%>
                              </td>
                              <th class="th02">신청금액</th>
                              <td><%= WebUtil.printNumFormat(Double.parseDouble(e05HouseData.REQU_MONY)*100) %> 원 </td>

                            </tr>
                            <tr>
                              <th>보증여부</th>
                              <td colspan="3">
								<%  if( e05HouseData.ZZSECU_FLAG.equals("Y") ) {  %>
                                연대보증인 입보
								<%  } else if( e05HouseData.ZZSECU_FLAG.equals("N") ) {  %>
                                보증보험가입희망
								<%  } else if( e05HouseData.ZZSECU_FLAG.equals("C") ) {  %>
                                신용보증
								<%  } %>
                               </td>
                            </tr>
                          </table>
                          </div>
                          </td>
                      </tr>
                    </table></td>
                </tr>
              </table>
			  <%
                  // ***** 업무담당자와 업무담당 부서장만 보여준다. ********************************************
                  if( approvalStep == DocumentInfo.DUTY_CHARGER || approvalStep == DocumentInfo.DUTY_MANGER ) {
              %>
              <!-- 상단 테이블 끝-->
              <table width="780" border="0" cellspacing="0" cellpadding="0" >
                <tr>
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <table width="780" border="0" cellspacing="1" cellpadding="5" c>
                <tr>
                  <td class="tr01">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><h2 class="subtitle">담당자입력</h2></td>
                      </tr>
                      <tr>
                        <td>
                          <!--담당자입력 테이블 시작-->
                          <div class="tableArea">
                          <table class="tableGeneral">
                            <tr>
                              <th width="100">대출승인금액</th>
                              <td width="260"><input name="DARBT" type="text" value="<%= e05HouseData.DARBT.equals("0") ? WebUtil.printNumFormat(Double.parseDouble(e05HouseData.REQU_MONY)*100) : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.DARBT)*100) %>" size="20" style="text-align:right" onKeyUp="javascript:moneyChkEventForWon(this);"  <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> ></td>
                              <th class="th02" width="100">개별금리</th>
                              <td>
                                <input name="MONY_RATE" type="text" value="<%= e05HouseData.MONY_RATE.equals("000") ? "1" : WebUtil.printNumFormat(e05HouseData.MONY_RATE) %>" size="3" style="text-align:right" onBlur="javascript:usableChar(this, '0123456789');"  <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> >%</td>
                              <th class="th02" width="100">지급일</th>
                              <td>
                              	<input name="ZAHLD" type="text" value="<%= e05HouseData.ZAHLD.equals("0000-00-00") ? "" : WebUtil.printDate(e05HouseData.ZAHLD, ".") %>" size="12" onBlur="event_ZAHLD(this);"  <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> >
                                <!-- 날짜검색-->
                                <a href="javascript:fn_openCal('ZAHLD','after_event_ZAHLD()')">
                                  <img src="<%= WebUtil.ImageURL %>btn_serch.gif" align="absmiddle" border="0" alt="날짜검색">
                                </a>
                              </td>
                            </tr>
                            <tr>
                              <th>상환기간</th>
                              <td colspan="5">
                                <input name="ZZRPAY_MNTH" type="text" value="<%= e05HouseData.ZZRPAY_MNTH.equals("000000") ? "" : e05HouseData.ZZRPAY_MNTH %>"  size="6" class="input04" style="text-align:right" readonly> 부터
                                <input name="ZZRPAY_CONT" type="text" value="<%= e05HouseData.ZZRPAY_CONT.equals("00") ? "" : e05HouseData.ZZRPAY_CONT %>" size="2"  class="input04" style="text-align:right" readonly> 년
                               </td>
                            </tr>
                            <tr>
                              <th>원상환시작</th>
                              <td><input name="REFN_BEGDA" type="text" value="<%= e05HouseData.REFN_BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(e05HouseData.REFN_BEGDA, ".") %>" size="12" class="input04" readonly></td>
                              <th class="th02">월상환종료</th>
                              <td colspan="2"><input name="REFN_ENDDA" type="text" value="<%= e05HouseData.REFN_ENDDA.equals("0000-00-00") ? "" : WebUtil.printDate(e05HouseData.REFN_ENDDA, ".") %>" size="12"  class="input04" readonly></td>
                            </tr>
                            <tr>
                              <th>신청자연락처</th>
                              <td colspan="5">
                                <input name="ZZHIRE_TELX" type="text" value="<%= e05HouseData.ZZHIRE_TELX %>" size="20" class="input04"  readonly>
                                <input name="ZZHIRE_MOBILE" type="text" value="<%= e05HouseData.ZZHIRE_MOBILE %>" size="20" class="input04"  readonly>
                               </td>
                            </tr>
                            <tr>
                              <th>보증여부</th>
                              <td>
                                <select name="ZZSECU_FLAG" onChange="javascript:hideshow(this);"  <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 disabled" %> >
                                <option value ='Y' <%= e05HouseData.ZZSECU_FLAG.equals("Y") ? "selected" : "" %>>보증인</option>
                                <option value ='N' <%= e05HouseData.ZZSECU_FLAG.equals("N") ? "selected" : "" %>>보증보험</option>
                                <option value ='C' <%= e05HouseData.ZZSECU_FLAG.equals("C") ? "selected" : "" %>>신용보증</option>
                                </select>
                               </td>
                              <th class="th02">증빙확인</th>
                              <td colspan="3">
                                <input name="PROOF" type="checkbox" value="" <%= e05HouseData.PROOF.equals("X") ? "checked" : "" %> <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input03 disabled" %> >
                               </td>
                            </tr>
                          </table>
                          </div>
                          <!--담당자입력 테이블 끝-->
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <table id="guarantee">
                            <tr>
                              <td>&nbsp;</td>
                            </tr>
		                        <tr>
		                          <td><h2 class="subtitle">보증인 인적사항</h2></td>
		                        </tr>
		                        <tr>
		                          <td>
		                            <!--보증인 인적사항 테이블 시작-->
		                            <div class="tableArea">
			                            <table class="tableGeneral">
			                              <tr>
			                                <th width="100">성명</th>
			                                <td width="260"><input name="ZZSECU_NAME" type="text" value="<%= e05HouseData.ZZSECU_NAME %>" size="10"  <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> ></td>
			                                <th class="th02">관계</th>
			                                <td>
			                                  <select name="ZZRELA_CODE" <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 disabled" %> >
			                                    <option value="">---------------</option>
	                                          <%= WebUtil.printOption((new A12FamilyRelationRFC()).getFamilyRelation(""), e05HouseData.ZZRELA_CODE) %>
			                                  </select>
			                                </td>
			                              </tr>
			                              <tr>
			                                <th>주민등록번호</th>
			                                <td><input name="ZZSECU_REGNO" type="text" value="<%= e05HouseData.ZZSECU_REGNO.equals("") ? "" : DataUtil.addSeparate(e05HouseData.ZZSECU_REGNO) %>" size="20" maxlength="14" onBlur="javascript:resno_chk(this);"  <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> ></td>
			                                <th class="th02">연락처</th>
			                                <td><input name="ZZSECU_TELX" type="text" value="<%= e05HouseData.ZZSECU_TELX %>" size="20"   <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> ></td>
			                              </tr>
			                            </table>
		                            </div>
		                            <!--보증인 인적사항 테이블 끝-->
                              <% if(Double.parseDouble(e05HouseData.REQU_MONY)*100>20000000.0){%>
		                            <!--보증인(2) 인적사항 테이블 시작-->
		                            <div class="tableArea">
			                            <table class="tableGeneral">
			                              <tr>
			                                <th width="100">성명</th>
			                                <td width="260"><input name="ZZSECU_NAME2" type="text" value="<%= e05HouseData.ZZSECU_NAME2 %>" size="10"  <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> ></td>
			                                <th class="th02" width="100">관계</th>
			                                <td>
			                                  <select name="ZZRELA_CODE2" <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 disabled" %> >
			                                    <option value="">---------------</option>
	                                          <%= WebUtil.printOption((new A12FamilyRelationRFC()).getFamilyRelation(""), e05HouseData.ZZRELA_CODE2) %> </select>
			                                  </select>
			                                 </td>
			                              </tr>
			                              <tr>
			                                <th>주민등록번호</th>
			                                <td><input name="ZZSECU_REGNO2" type="text" value="<%= e05HouseData.ZZSECU_REGNO2.equals("") ? "" : DataUtil.addSeparate(e05HouseData.ZZSECU_REGNO2) %>" size="20" maxlength="14" onBlur="javascript:resno_chk(this);"  <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> ></td>
			                                <th class="th02">연락처</th>
			                                <td><input name="ZZSECU_TELX2" type="text" value="<%= e05HouseData.ZZSECU_TELX2 %>" size="20"   <%= approvalStep == DocumentInfo.DUTY_CHARGER ? "class=input03" : "class=input04 readonly" %> ></td>
			                              </tr>
			                            </table>
		                            </div>
		                            <!--보증인(2) 인적사항 테이블 끝-->
                              <% } %>
		                        </td>
		                      </tr>
	                      </table>
                        <input name="TILBT" type=hidden value="<%= e05HouseData.TILBT.equals("0") ? "" : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.TILBT)*100) %>">
                        <input name="MNTH_INTEREST" type=hidden value="<%= e05HouseData.MNTH_INTEREST.equals("0") ? "" : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.MNTH_INTEREST)*100) %>">
	                    </td>
	                  </tr>
                    </table></td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
            </td>
          </tr>
			  <%
                  } else {
              %>
  <INPUT TYPE="hidden" name="DARBT"         value="<%= e05HouseData.DARBT         %>" >
  <INPUT TYPE="hidden" name="MONY_RATE"     value="<%= e05HouseData.MONY_RATE     %>" >
  <INPUT TYPE="hidden" name="ZAHLD"         value="<%= e05HouseData.ZAHLD         %>" >
  <INPUT TYPE="hidden" name="ZZRPAY_MNTH"   value="<%= e05HouseData.ZZRPAY_MNTH   %>" >
  <INPUT TYPE="hidden" name="ZZRPAY_CONT"   value="<%= e05HouseData.ZZRPAY_CONT   %>" >
  <INPUT TYPE="hidden" name="TILBT"         value="<%= e05HouseData.TILBT         %>" >
  <INPUT TYPE="hidden" name="REFN_BEGDA"    value="<%= e05HouseData.REFN_BEGDA    %>" >
  <INPUT TYPE="hidden" name="REFN_ENDDA"    value="<%= e05HouseData.REFN_ENDDA    %>" >
  <INPUT TYPE="hidden" name="ZZHIRE_TELX"   value="<%= e05HouseData.ZZHIRE_TELX   %>" >
  <INPUT TYPE="hidden" name="ZZHIRE_MOBILE" value="<%= e05HouseData.ZZHIRE_MOBILE %>" >
  <INPUT TYPE="hidden" name="ZZSECU_FLAG"   value="<%= e05HouseData.ZZSECU_FLAG   %>" >
  <INPUT TYPE="hidden" name="PROOF"         value="<%= e05HouseData.PROOF         %>" >
  <INPUT TYPE="hidden" name="ZZFUND_CODE"   value="<%= e05HouseData.ZZFUND_CODE   %>" >
  <INPUT TYPE="hidden" name="ZZSECU_NAME"   value="<%= e05HouseData.ZZSECU_NAME   %>" >
  <INPUT TYPE="hidden" name="ZZRELA_CODE"   value="<%= e05HouseData.ZZRELA_CODE   %>" >
  <INPUT TYPE="hidden" name="ZZSECU_REGNO"  value="<%= e05HouseData.ZZSECU_REGNO  %>" >
  <INPUT TYPE="hidden" name="ZZSECU_TELX"   value="<%= e05HouseData.ZZSECU_TELX   %>" >
  <INPUT TYPE="hidden" name="MNTH_INTEREST" value="<%= e05HouseData.MNTH_INTEREST %>" >
  <INPUT TYPE="hidden" name="ZZSECU_NAME2"   value="<%= e05HouseData.ZZSECU_NAME2   %>" >
  <INPUT TYPE="hidden" name="ZZRELA_CODE2"   value="<%= e05HouseData.ZZRELA_CODE2   %>" >
  <INPUT TYPE="hidden" name="ZZSECU_REGNO2"  value="<%= e05HouseData.ZZSECU_REGNO2  %>" >
  <INPUT TYPE="hidden" name="ZZSECU_TELX2"   value="<%= e05HouseData.ZZSECU_TELX2   %>" >
  <INPUT TYPE="hidden" name="DLEND"   value="<%= e05HouseData.DLEND   %>" >

			  <%
                  }
              %>


          <tr>
            <td><h2 class="subtitle">적요</h2></td>
          </tr>
<%
    String tmpBigo = "";

    for (int i = 0; i < vcAppLineData.size(); i++) {
        AppLineData ald = (AppLineData) vcAppLineData.get(i);

        if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) {
            if (ald.APPL_PERNR.equals(user.empNo)) {
                tmpBigo = ald.APPL_BIGO_TEXT;
            } else {
%>
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1">

                    <tr>
                    	<td>
			          	 	<div class="tableArea">
			            		<table class="tableGeneral">
			            			<tr>
			            				<th width="100"><%=ald.APPL_ENAME%></th>
			            				<td><%=ald.APPL_BIGO_TEXT%></td>
			            			</tr>
			                	</table>
			                </div>
                    	</td>
                    </tr>
                </table>
            </td>
          </tr>
<%
            } // end if
        } // end if
    } // end for
%>
          <tr>
            <td>
            	<div class="tableArea">
            		<table class="tableGeneral">
            			<tr>
            				<td><textarea name="BIGO_TEXT" cols="100" rows="4"><%=tmpBigo%></textarea></td>
            			</tr>
                	</table>
                </div>
            </td>
          </tr>
          <tr>
            <td>
            	<table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><h2 class="subtitle">결재정보</h2></td>
                </tr>
                <tr>
                  <td>
                  <table width="780" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>
                          <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(vcAppLineData) %>
                          <!--결재정보 테이블 끝-->
                        </td>
                      </tr>
                    </table></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td align="center">
                  <!--버튼 들어가는 테이블 시작 -->
                      <table width="780" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>
		                  	<div class="buttonArea">
		                  		<ul class="btn_crud">
		                  			<li><a class="darken" href="javascript:approval()"><span>결재</span></a></li>
		                  			<li><a href="javascript:reject()"><span>반려</span></a></li>
		                          <% if (isCanGoList) {  %>
		                          	<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
		                  			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
		                          <% } // end if %>
		                  		</ul>
		                  	</div>
                          </td>
                        </tr>
                      </table>
                  <!--버튼 들어가는 테이블 끝 -->
                  </td>
                  <!--버튼끝-->
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
              </table></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>

  <!-- ※한도금액체크로직추가[C20110808_41085] -->
    <input type="hidden" name="loantypecount" value="<%= E05MaxMoneyData_vt.size() %>">
<%
    for ( int i = 0 ; i < E05MaxMoneyData_vt.size() ; i++ ) {
        E05MaxMoneyData E05MaxMoneyData = (E05MaxMoneyData)E05MaxMoneyData_vt.get(i);
%>
    <input type="hidden" name="LOAN_CODE<%= i %>" value='<%= E05MaxMoneyData.LOAN_CODE %>'>
    <input type="hidden" name="LOAN_MONY<%= i %>" value='<%= WebUtil.printNum( E05MaxMoneyData.LOAN_MONY ) %>' >
<%
    }
%>
    <input type="hidden" name="oldcount" value="<%= PersLoanData_vt.size() %>">
<%
    for ( int i = 0 ; i < PersLoanData_vt.size() ; i++ ) {
        E05PersLoanData persLoanData = (E05PersLoanData)PersLoanData_vt.get(i);
%>
    <input type="hidden" name="OLD_DLART<%= i %>" value='<%= persLoanData.DLART %>'>
    <input type="hidden" name="OLD_DARBT<%= i %>" value='<%= WebUtil.printNum( persLoanData.DARBT ) %>' >
    <input type="hidden" name="OLD_ENDDA<%=i %>" value='<%=persLoanData.ENDDA%>'>
<%
    }
%>

<!-- //※ 진행중인건 대출금액목록[C20110808_41085]-->
          <input type="hidden" name="ingcount" value="<%= IngPersLoanData_vt.size() %>">

<%
        for ( int i = 0 ; i < IngPersLoanData_vt.size() ; i++ ) {
            E05PersLoanData IngpersLoanData = (E05PersLoanData)IngPersLoanData_vt.get(i);
%>
          <input type="hidden" name="ING_DLART<%= i %>" value='<%= IngpersLoanData.DLART %>'>
          <input type="hidden" name="ING_DARBT<%= i %>" value='<%= WebUtil.printNum( IngpersLoanData.DARBT ) %>' >
<%
        }
%>

  </form>
  <form name="form3" method="post">
    <input type="hidden" name = "PERNR" value="">
    <input type="hidden" name = "DLART" value="">
    <input type="hidden" name = "DARBT" value="">
    <input type="hidden" name = "ZAHLD" value="">
  </form>
<iframe name="ifHidden" width="0" height="0" />
<%@ include file="/web/common/commonEnd.jsp" %>

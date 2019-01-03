<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>

<%
    String      last_RCPT_NUMB     = (String)request.getAttribute("last_RCPT_NUMB");
//    String      P_Flag             = (String)request.getAttribute("P_Flag");
    String      COMP_sum           = (String)request.getAttribute("COMP_sum");

    Vector      E17HospitalData_vt = (Vector)request.getAttribute("E17HospitalData_vt");
    Vector      E17BillData_vt     = (Vector)request.getAttribute("E17BillData_vt");
    Vector      AppLineData_vt     = (Vector)request.getAttribute("AppLineData_vt");
    E17SickData e17SickData        = (E17SickData)request.getAttribute("e17SickData");
    E17SickData hidden_e17SickData = (E17SickData)request.getAttribute("hidden_e17SickData");
    String      fromJsp            = (String)request.getAttribute("fromJsp");
    String      radio_index        = (String)request.getAttribute("radio_index");
    String      ThisJspName        = (String)request.getAttribute("ThisJspName");
    int         select_index       = Integer.parseInt(radio_index);

//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e17SickData.WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess6.css" type="text/css">
<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function MM_swapImgRestore() {//v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() {//v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) {//v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() {//v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
/**/
function do_back_fromJsp(){

	if( check_data() ) {
		document.form1.jobid.value       = "back_fromJsp";
    document.form1.fromJsp.value     = "<%= fromJsp %>";
    document.form1.ThisJspName.value = "<%= ThisJspName %>";

		document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E17Hospital.E17BillControlSV";
		document.form1.method = "post";
    document.form1.target = "menuContentIframe";
		document.form1.submit();
	}
}

/* 앞화면 */
function do_preview(){
  document.form1.jobid.value       = "back_fromJsp";
  document.form1.fromJsp.value     = "<%= fromJsp %>";
  document.form1.ThisJspName.value = "<%= ThisJspName %>";

	document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E17Hospital.E17BillControlSV";
	document.form1.method = "post";
  document.form1.target = "menuContentIframe";
	document.form1.submit();
}

/* check_data **********************************************************************************************/
function check_data() {
//    if(document.form1.x_EMPL_WONX.value == ""){
//        alert("본인부담금①이 계산되지 않았습니다.\n\n해당 항목에 금액을 입력해 주세요");
//        return false;
//    }
    gap1 = Number(removeComma(document.form1.TOTL_WONX.value)) -
           Number(removeComma(document.form1.ASSO_WONX.value)) ;
    if(gap1 < 0){
        alert("조합부담금이 총 진료비를 초과할수 없습니다. 다시 입력해 주세요.");
        document.form1.TOTL_WONX.focus();
        return false;
    }
    if( (document.form1.ETC1_WONX.value != "" && document.form1.ETC1_TEXT.value == "") ||
        (document.form1.ETC2_WONX.value != "" && document.form1.ETC2_TEXT.value == "") ||
        (document.form1.ETC3_WONX.value != "" && document.form1.ETC3_TEXT.value == "") ||
        (document.form1.ETC4_WONX.value != "" && document.form1.ETC4_TEXT.value == "") ||
        (document.form1.ETC5_WONX.value != "" && document.form1.ETC5_TEXT.value == "") ){

        alert("'보험비급여' 항목의 금액에 대한 항목 설명이 빠져있습니다.");
        return false;
    }
    setting_bill_data();
//진료비계산서 입력시 본인 부담금액이 10만원 이상인 경우만 허용함.
//int_tt_wonx = Number(removeComma(document.form1.EMPL_WONX_tot.value));
//if( int_tt_wonx < 100000 ){
//alert(" 본인부담금 총액은 10만원이상일 경우에만 신청이 가능합니다. ");
//return false;
//}

    return true;
}
/* check_data **********************************************************************************************/

function setting_onload(){
    ind = <%=select_index%>;
    eval("document.form1.TOTL_WONX.value   = insertComma(pointFormat(document.form1.TOTL_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.ASSO_WONX.value   = insertComma(pointFormat(document.form1.ASSO_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.x_EMPL_WONX.value = insertComma(pointFormat(document.form1.x_EMPL_WONX"+ind+".value, <%= currencyValue %>));");
    eval("document.form1.MEAL_WONX.value   = insertComma(pointFormat(document.form1.MEAL_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.APNT_WONX.value   = insertComma(pointFormat(document.form1.APNT_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.ROOM_WONX.value   = insertComma(pointFormat(document.form1.ROOM_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.CTXX_WONX.value   = insertComma(pointFormat(document.form1.CTXX_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.MRIX_WONX.value   = insertComma(pointFormat(document.form1.MRIX_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.SWAV_WONX.value   = insertComma(pointFormat(document.form1.SWAV_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.DISC_WONX.value   = insertComma(pointFormat(document.form1.DISC_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.ETC1_WONX.value   = insertComma(pointFormat(document.form1.ETC1_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.ETC1_TEXT.value   = insertComma(            document.form1.ETC1_TEXT"+ind+".value);");
    eval("document.form1.ETC2_WONX.value   = insertComma(pointFormat(document.form1.ETC2_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.ETC2_TEXT.value   = insertComma(            document.form1.ETC2_TEXT"+ind+".value);");
    eval("document.form1.ETC3_WONX.value   = insertComma(pointFormat(document.form1.ETC3_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.ETC3_TEXT.value   = insertComma(            document.form1.ETC3_TEXT"+ind+".value);");
    eval("document.form1.ETC4_WONX.value   = insertComma(pointFormat(document.form1.ETC4_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.ETC4_TEXT.value   = insertComma(            document.form1.ETC4_TEXT"+ind+".value);");
    eval("document.form1.ETC5_WONX.value   = insertComma(pointFormat(document.form1.ETC5_WONX"+ind+".value,   <%= currencyValue %>));");
    eval("document.form1.ETC5_TEXT.value   = insertComma(            document.form1.ETC5_TEXT"+ind+".value);");

    multiple_won();
}

function setting_bill_data(){
    ind = <%=select_index%>;
    eval("document.form1.TOTL_WONX"+ind+".value   = removeComma(document.form1.TOTL_WONX.value);");
    eval("document.form1.ASSO_WONX"+ind+".value   = removeComma(document.form1.ASSO_WONX.value);");
    eval("document.form1.x_EMPL_WONX"+ind+".value = removeComma(document.form1.x_EMPL_WONX.value);");
    eval("document.form1.MEAL_WONX"+ind+".value   = removeComma(document.form1.MEAL_WONX.value);");
    eval("document.form1.APNT_WONX"+ind+".value   = removeComma(document.form1.APNT_WONX.value);");
    eval("document.form1.ROOM_WONX"+ind+".value   = removeComma(document.form1.ROOM_WONX.value);");
    eval("document.form1.CTXX_WONX"+ind+".value   = removeComma(document.form1.CTXX_WONX.value);");
    eval("document.form1.MRIX_WONX"+ind+".value   = removeComma(document.form1.MRIX_WONX.value);");
    eval("document.form1.SWAV_WONX"+ind+".value   = removeComma(document.form1.SWAV_WONX.value);");
    eval("document.form1.DISC_WONX"+ind+".value   = removeComma(document.form1.DISC_WONX.value);");
    eval("document.form1.ETC1_WONX"+ind+".value   = removeComma(document.form1.ETC1_WONX.value);");
    eval("document.form1.ETC1_TEXT"+ind+".value   = removeComma(document.form1.ETC1_TEXT.value);");
    eval("document.form1.ETC2_WONX"+ind+".value   = removeComma(document.form1.ETC2_WONX.value);");
    eval("document.form1.ETC2_TEXT"+ind+".value   = removeComma(document.form1.ETC2_TEXT.value);");
    eval("document.form1.ETC3_WONX"+ind+".value   = removeComma(document.form1.ETC3_WONX.value);");
    eval("document.form1.ETC3_TEXT"+ind+".value   = removeComma(document.form1.ETC3_TEXT.value);");
    eval("document.form1.ETC4_WONX"+ind+".value   = removeComma(document.form1.ETC4_WONX.value);");
    eval("document.form1.ETC4_TEXT"+ind+".value   = removeComma(document.form1.ETC4_TEXT.value);");
    eval("document.form1.ETC5_WONX"+ind+".value   = removeComma(document.form1.ETC5_WONX.value);");
    eval("document.form1.ETC5_TEXT"+ind+".value   = removeComma(document.form1.ETC5_TEXT.value);");
}

/* 본인 부담금 총액 합계구하기 */
function multiple_won() {
    var hap = 0;
    var gap1 = 0;
    var gap2 = 0;

    gap1 = Number(removeComma(document.form1.TOTL_WONX.value)) -
           Number(removeComma(document.form1.ASSO_WONX.value)) ;
    gap2 = Number(removeComma(document.form1.MEAL_WONX.value)) +
           Number(removeComma(document.form1.APNT_WONX.value)) +
           Number(removeComma(document.form1.ROOM_WONX.value)) +
           Number(removeComma(document.form1.CTXX_WONX.value)) +
           Number(removeComma(document.form1.MRIX_WONX.value)) +
           Number(removeComma(document.form1.SWAV_WONX.value)) +
           Number(removeComma(document.form1.ETC1_WONX.value)) +
           Number(removeComma(document.form1.ETC2_WONX.value)) +
           Number(removeComma(document.form1.ETC3_WONX.value)) +
           Number(removeComma(document.form1.ETC4_WONX.value)) +
           Number(removeComma(document.form1.ETC5_WONX.value));

    hap = gap1 + gap2 - Number(removeComma(document.form1.DISC_WONX.value));

    if( gap1 > 0 ) {
        gap1 = pointFormat(gap1, <%= currencyValue %>);

        document.form1.x_EMPL_WONX.value = insertComma(gap1+"");
    }else{
        document.form1.x_EMPL_WONX.value = "";
    }
    if( gap2 > 0 ) {
        gap2 = pointFormat(gap2, <%= currencyValue %>);

        document.form1.EMPL_WONX_sub.value = insertComma(gap2+"");
    }else{
        document.form1.EMPL_WONX_sub.value = "";
    }
    if( hap > 0 ) {
        hap = pointFormat(hap, <%= currencyValue %>);

        document.form1.EMPL_WONX_tot.value = insertComma(hap+"");
    }else{
        document.form1.EMPL_WONX_tot.value = "";
    }
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>btn_help_on.gif');setting_onload();">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>
      <!--타이틀 테이블 시작-->
        <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="right">
              &nbsp;<a href="javascript:open_help('E17Hospital.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
            </td>
          </tr>
          <tr>
            <td class="title01">진료비 계산서 입력</td>
          </tr>
        </table>
      <!--타이틀 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td align="center">
        <table width="384" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td class="font01" valign="bottom"><font color="#7897FC">■</font>
              보험급여</td>
          </tr>
          <tr>
            <td>
              <table width="380" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr>
                  <td class="td03" width="135">총 진료비</td>
                  <td class="td02">
                    <input type="text" name="TOTL_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">조합부담금</td>
                  <td class="td02">
                    <input type="text" name="ASSO_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">본인부담금①</td>
                  <td class="td02">
                    <input type="text" name="x_EMPL_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03" readonly>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="font01" valign="bottom"><font color="#7897FC">■</font>
              보험 비급여</td>
          </tr>
          <tr>
            <td>
              <table width="380" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr>
                  <td class="td03" width="135">식 대</td>
                  <td class="td02">
                    <input type="text" name="MEAL_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">지정진료비</td>
                  <td class="td02">
                    <input type="text" name="APNT_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">상급병실료차액</td>
                  <td class="td02">
                    <input type="text" name="ROOM_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">C T</td>
                  <td class="td02">
                    <input type="text" name="CTXX_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">MRI</td>
                  <td class="td02">
                    <input type="text" name="MRIX_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">초음파</td>
                  <td class="td02">
                    <input type="text" name="SWAV_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">
                    <input type="text" name="ETC1_TEXT" style="text-align:center" size="15" class="input03">
                  </td>
                  <td class="td02">
                    <input type="text" name="ETC1_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">
                    <input type="text" name="ETC2_TEXT" style="text-align:center" size="15" class="input03">
                  </td>
                  <td class="td02">
                    <input type="text" name="ETC2_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">
                    <input type="text" name="ETC3_TEXT" style="text-align:center" size="15" class="input03">
                  </td>
                  <td class="td02">
                    <input type="text" name="ETC3_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">
                    <input type="text" name="ETC4_TEXT" style="text-align:center" size="15" class="input03">
                  </td>
                  <td class="td02">
                    <input type="text" name="ETC4_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">
                    <input type="text" name="ETC5_TEXT" style="text-align:center" size="15" class="input03">
                  </td>
                  <td class="td02">
                    <input type="text" name="ETC5_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
                <tr>
                  <td class="td03">소 계②</td>
                  <td class="td02">
                    <input type="text" name="EMPL_WONX_sub" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this,'WAERS_Bill');javascript:multiple_won();" size="25" class="input04" readonly>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="font01"><font color="#7897FC">■</font> 할인금액</td>
          </tr>
          <tr>
            <td>
              <table width="380" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr>
                  <td class="td03" width="135">할인금액③</td>
                  <td class="td02">
                    <input type="text" name="DISC_WONX" style="text-align:right" onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS_Bill');" onBlur="javascript:moneyChkForLGchemR3_onBlur(this, 'WAERS_Bill');javascript:multiple_won();" size="25" class="input03">
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="font01"><font color="#7897FC">■</font> 본인부담금 총액</td>
          </tr>
          <tr>
            <td>
              <table width="380" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr>
                  <td class="td03" width="135">① + ② - ③&nbsp;<font color="#0000FF"><b>*</b></font></td>
                  <td class="td02">
                    <input type="text" name="EMPL_WONX_tot" style="text-align:right" size="25" class="input04" readonly>
                    <select name="WAERS_Bill" class="input03" disabled>
<!-- 통화키 가져오기-->
<%= WebUtil.printOption((new CurrencyCodeRFC()).getCurrencyCode(), e17SickData.WAERS) %>
<!-- 통화키 가져오기-->
                    </select>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="15">&nbsp;</td>
      <td align="center">
      <a href="javascript:do_back_fromJsp();">
      <img src="<%= WebUtil.ImageURL %>btn_input.gif" width="49" height="20" border="0" align="absmiddle"></a>
      <a href="javascript:do_preview()">
      <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" width="59" height="20" align="absmiddle" border="0"></a>
      </td>
    </tr>
  </table>
<!-- hidden field : common -->
    <input type="hidden" name="jobid"             value="">
    <input type="hidden" name="fromJsp"           value="">
    <input type="hidden" name="ThisJspName"       value="">
    <input type="hidden" name="last_RCPT_NUMB"    value="<%= last_RCPT_NUMB %>">
<!--    <input type="hidden" name="P_Flag"            value="P_Flag"> -->
    <input type="hidden" name="COMP_sum"          value="<%= COMP_sum %>">
    <input type="hidden" name="RowCount_hospital" value="<%= E17HospitalData_vt.size() %>">
    <input type="hidden" name="RowCount_report"   value="<%= E17BillData_vt.size() %>">
<!-- hidden field : common -->
<!-- hidden field : E17SickData -->
    <input type="hidden" name="hidden_CTRL_NUMB"  value="<%= hidden_e17SickData.CTRL_NUMB  %>"> <!-- 관리번호   -->
    <input type="hidden" name="hidden_SICK_NAME"  value="<%= hidden_e17SickData.SICK_NAME  %>"> <!-- 상병명     -->
    <input type="hidden" name="hidden_GUEN_CODE"  value="<%= hidden_e17SickData.GUEN_CODE  %>"> <!-- 구분       -->
    <input type="hidden" name="hidden_SICK_DESC1" value="<%= hidden_e17SickData.SICK_DESC1 %>"> <!-- 구체적증상 -->
    <input type="hidden" name="hidden_SICK_DESC2" value="<%= hidden_e17SickData.SICK_DESC2 %>"> <!-- 구체적증상 -->
    <input type="hidden" name="hidden_SICK_DESC3" value="<%= hidden_e17SickData.SICK_DESC3 %>"> <!-- 구체적증상 -->
    <input type="hidden" name="hidden_SICK_DESC4" value="<%= hidden_e17SickData.SICK_DESC4 %>"> <!-- 구체적증상 -->

    <input type="hidden" name="CTRL_NUMB"  value="<%= e17SickData.CTRL_NUMB  %>"> <!-- 관리번호   -->
    <input type="hidden" name="SICK_NAME"  value="<%= e17SickData.SICK_NAME  %>"> <!-- 상병명     -->
    <input type="hidden" name="GUEN_CODE"  value="<%= e17SickData.GUEN_CODE  %>"> <!-- 구분       -->
    <input type="hidden" name="PROOF"      value="<%= e17SickData.PROOF      %>"> <!-- 배우자 연말정산반영여부 -->
    <input type="hidden" name="SICK_DESC1" value="<%= e17SickData.SICK_DESC1 %>"> <!-- 구체적증상 -->
    <input type="hidden" name="SICK_DESC2" value="<%= e17SickData.SICK_DESC2 %>"> <!-- 구체적증상 -->
    <input type="hidden" name="SICK_DESC3" value="<%= e17SickData.SICK_DESC3 %>"> <!-- 구체적증상 -->
    <input type="hidden" name="SICK_DESC4" value="<%= e17SickData.SICK_DESC4 %>"> <!-- 구체적증상 -->
    <input type="hidden" name="SICK_DESC"  value="<%= e17SickData.SICK_DESC  %>"> <!-- 관리번호   -->
    <input type="hidden" name="is_new_num" value="<%= e17SickData.is_new_num %>"> <!-- 상병명     -->
    <input type="hidden" name="medi_count" value="<%= e17SickData.medi_count %>"> <!-- 구체적증상 -->
    <input type="hidden" name="BEGDA"      value="<%= e17SickData.BEGDA      %>"> <!-- 관리번호   -->
    <input type="hidden" name="AINF_SEQN"  value="<%= e17SickData.AINF_SEQN  %>"> <!-- 상병명     -->
    <input type="hidden" name="WAERS"      value="<%= e17SickData.WAERS  %>">     <!-- 통화키     -->
<!-- hidden field : E17SickData -->
<!-- hidden field : E17HospitalData -->
<%
    for( int i = 0 ; i < E17HospitalData_vt.size() ; i++ ){
        E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
%>
    <input type="hidden" name="MEDI_NAME<%=i%>" value="<%= e17HospitalData.MEDI_NAME %>"> <!-- 의료기관          -->
    <input type="hidden" name="TELX_NUMB<%=i%>" value="<%= e17HospitalData.TELX_NUMB %>"> <!-- 전화번호          -->
    <input type="hidden" name="EXAM_DATE<%=i%>" value="<%= e17HospitalData.EXAM_DATE %>"> <!-- 진료일            -->
    <input type="hidden" name="MEDI_CODE<%=i%>" value="<%= e17HospitalData.MEDI_CODE %>"> <!-- 입원/외래         -->
    <input type="hidden" name="RCPT_CODE<%=i%>" value="<%= e17HospitalData.RCPT_CODE %>"> <!-- 영수증 구분       -->
    <input type="hidden" name="RCPT_NUMB<%=i%>" value="<%= e17HospitalData.RCPT_NUMB %>"> <!-- No. 영수증번호    -->
    <input type="hidden" name="EMPL_WONX<%=i%>" value="<%= e17HospitalData.EMPL_WONX %>"> <!-- 본인 실납부액     -->
<!-- 2004년 연말정산 이후 사업자등록번호 필드 추가 (5.3) -->
    <input type="hidden" name="MEDI_NUMB<%=i%>" value="<%= e17HospitalData.MEDI_NUMB %>"> <!-- 의료기관 사업자등록번호 -->
<%
    }
%>
<!-- hidden field : E17HospitalData -->
<!-- hidden field : E17BillData -->
<%
    for( int i = 0 ; i < E17BillData_vt.size() ; i++ ){
        E17BillData e17BillData = (E17BillData)E17BillData_vt.get(i);
%>
    <input type="hidden" name="CTRL_NUMB<%=i%>"   value="<%= e17BillData.CTRL_NUMB %>"> <!-- 관리번호          -->
    <input type="hidden" name="x_RCPT_NUMB<%=i%>" value="<%= e17BillData.RCPT_NUMB %>"> <!-- 영수증번호        -->
    <input type="hidden" name="AINF_SEQN<%=i%>"   value="<%= e17BillData.AINF_SEQN %>"> <!-- 결재정보 일련번호 -->
    <input type="hidden" name="TOTL_WONX<%=i%>"   value="<%= e17BillData.TOTL_WONX %>"> <!-- 총 진료비         -->
    <input type="hidden" name="ASSO_WONX<%=i%>"   value="<%= e17BillData.ASSO_WONX %>"> <!-- 조합 부담금       -->
    <input type="hidden" name="x_EMPL_WONX<%=i%>" value="<%= e17BillData.EMPL_WONX %>"> <!-- 본인 부담금       -->
    <input type="hidden" name="MEAL_WONX<%=i%>"   value="<%= e17BillData.MEAL_WONX %>"> <!-- 식대              -->
    <input type="hidden" name="APNT_WONX<%=i%>"   value="<%= e17BillData.APNT_WONX %>"> <!-- 지정 진료비       -->
    <input type="hidden" name="ROOM_WONX<%=i%>"   value="<%= e17BillData.ROOM_WONX %>"> <!-- 상급 병실료 차액  -->
    <input type="hidden" name="CTXX_WONX<%=i%>"   value="<%= e17BillData.CTXX_WONX %>"> <!-- C T 검사비        -->
    <input type="hidden" name="MRIX_WONX<%=i%>"   value="<%= e17BillData.MRIX_WONX %>"> <!-- M R I 검사비      -->
    <input type="hidden" name="SWAV_WONX<%=i%>"   value="<%= e17BillData.SWAV_WONX %>"> <!-- 초음파 검사비     -->
    <input type="hidden" name="DISC_WONX<%=i%>"   value="<%= e17BillData.DISC_WONX %>"> <!-- 할인금액          -->
    <input type="hidden" name="ETC1_WONX<%=i%>"   value="<%= e17BillData.ETC1_WONX %>"> <!-- 기타1 의 금액     -->
    <input type="hidden" name="ETC1_TEXT<%=i%>"   value="<%= e17BillData.ETC1_TEXT %>"> <!-- 기타1 의 항목명   -->
    <input type="hidden" name="ETC2_WONX<%=i%>"   value="<%= e17BillData.ETC2_WONX %>"> <!-- 기타2 의 금액     -->
    <input type="hidden" name="ETC2_TEXT<%=i%>"   value="<%= e17BillData.ETC2_TEXT %>"> <!-- 기타2 의 항목명   -->
    <input type="hidden" name="ETC3_WONX<%=i%>"   value="<%= e17BillData.ETC3_WONX %>"> <!-- 기타3 의 금액     -->
    <input type="hidden" name="ETC3_TEXT<%=i%>"   value="<%= e17BillData.ETC3_TEXT %>"> <!-- 기타3 의 항목명   -->
    <input type="hidden" name="ETC4_WONX<%=i%>"   value="<%= e17BillData.ETC4_WONX %>"> <!-- 기타4 의 금액     -->
    <input type="hidden" name="ETC4_TEXT<%=i%>"   value="<%= e17BillData.ETC4_TEXT %>"> <!-- 기타4 의 항목명   -->
    <input type="hidden" name="ETC5_WONX<%=i%>"   value="<%= e17BillData.ETC5_WONX %>"> <!-- 기타5 의 금액     -->
    <input type="hidden" name="ETC5_TEXT<%=i%>"   value="<%= e17BillData.ETC5_TEXT %>"> <!-- 기타5 의 항목명   -->
<%
    }
%>
<!-- hidden field : E17BillData -->
<!--  HIDDEN  처리해야할 부분 -->
    <input type="hidden" name="RowCount" value="<%= AppLineData_vt.size() %>">
<%
      for( int i = 0 ; i < AppLineData_vt.size() ; i++ ){
          AppLineData appLine =(AppLineData)AppLineData_vt.get(i);
%>
      <input type="hidden" name="APPL_APPU_NAME<%= i %>" value="<%= appLine.APPL_APPU_NAME %>">
      <input type="hidden" name="APPL_ENAME<%= i %>"     value="<%= appLine.APPL_ENAME     %>">
      <input type="hidden" name="APPL_ORGTX<%= i %>"     value="<%= appLine.APPL_ORGTX     %>">
      <input type="hidden" name="APPL_TITL2<%= i %>"     value="<%= appLine.APPL_TITL2     %>">
      <input type="hidden" name="APPL_TELNUMBER<%= i %>" value="<%= appLine.APPL_TELNUMBER %>">
      <input type="hidden" name="APPL_UPMU_FLAG<%= i %>" value="<%= appLine.APPL_UPMU_FLAG %>">
      <input type="hidden" name="APPL_APPR_TYPE<%= i %>" value="<%= appLine.APPL_APPR_TYPE %>">
      <input type="hidden" name="APPL_APPU_TYPE<%= i %>" value="<%= appLine.APPL_APPU_TYPE %>">
      <input type="hidden" name="APPL_APPR_SEQN<%= i %>" value="<%= appLine.APPL_APPR_SEQN %>">
      <input type="hidden" name="APPL_PERNR<%= i %>"     value="<%= appLine.APPL_PERNR     %>">
      <input type="hidden" name="APPL_OTYPE<%= i %>"     value="<%= appLine.APPL_OTYPE     %>">
      <input type="hidden" name="APPL_OBJID<%= i %>"     value="<%= appLine.APPL_OBJID     %>">
      <input type="hidden" name="APPL_STEXT<%= i %>"     value="<%= appLine.APPL_STEXT     %>">
      <input type="hidden" name="APPL_TITEL<%= i %>"     value="<%= appLine.APPL_TITEL     %>">
      <input type="hidden" name="APPL_APPU_NUMB<%= i %>" value="<%= appLine.APPL_APPU_NUMB %>">
<%
      }
%>
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

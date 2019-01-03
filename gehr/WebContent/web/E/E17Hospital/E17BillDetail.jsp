<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E17Hospital.*" %>

<%
    E17BillData e17BillData = (E17BillData)request.getAttribute("e17BillData");
    
//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( e17BillData.WAERS.equals(codeEnt.code) ){
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

function MM_openBrWindow(theURL,winName,features) {//v2.0
  window.open(theURL,winName,features);
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

function setting_onload(){
    document.form1.TOTL_WONX.value = "<%= e17BillData.TOTL_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.TOTL_WONX,currencyValue) %>";
    document.form1.ASSO_WONX.value = "<%= e17BillData.ASSO_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ASSO_WONX,currencyValue) %>";
    document.form1.MEAL_WONX.value = "<%= e17BillData.MEAL_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.MEAL_WONX,currencyValue) %>";
    document.form1.APNT_WONX.value = "<%= e17BillData.APNT_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.APNT_WONX,currencyValue) %>";
    document.form1.ROOM_WONX.value = "<%= e17BillData.ROOM_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ROOM_WONX,currencyValue) %>";
    document.form1.CTXX_WONX.value = "<%= e17BillData.CTXX_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.CTXX_WONX,currencyValue) %>";
    document.form1.MRIX_WONX.value = "<%= e17BillData.MRIX_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.MRIX_WONX,currencyValue) %>";
    document.form1.SWAV_WONX.value = "<%= e17BillData.SWAV_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.SWAV_WONX,currencyValue) %>";
    document.form1.DISC_WONX.value = "<%= e17BillData.DISC_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.DISC_WONX,currencyValue) %>";
    document.form1.ETC1_WONX.value = "<%= e17BillData.ETC1_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC1_WONX,currencyValue) %>";
    document.form1.ETC2_WONX.value = "<%= e17BillData.ETC2_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC2_WONX,currencyValue) %>";
    document.form1.ETC3_WONX.value = "<%= e17BillData.ETC3_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC3_WONX,currencyValue) %>";
    document.form1.ETC4_WONX.value = "<%= e17BillData.ETC4_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC4_WONX,currencyValue) %>";
    document.form1.ETC5_WONX.value = "<%= e17BillData.ETC5_WONX.equals("0") ? "" : WebUtil.printNumFormat(e17BillData.ETC5_WONX,currencyValue) %>";
    document.form1.ETC1_TEXT.value = "<%= e17BillData.ETC1_TEXT.trim() %>";
    document.form1.ETC2_TEXT.value = "<%= e17BillData.ETC2_TEXT.trim() %>";
    document.form1.ETC3_TEXT.value = "<%= e17BillData.ETC3_TEXT.trim() %>";
    document.form1.ETC4_TEXT.value = "<%= e17BillData.ETC4_TEXT.trim() %>";
    document.form1.ETC5_TEXT.value = "<%= e17BillData.ETC5_TEXT.trim() %>";

    multiple_won();                   
    for ( j = 0 ; j < document.form1.elements.length ; j++ ){
      if(document.form1.elements[j].value=="0"){
        document.form1.elements[j].value = "";
      }
    }
}

function do_print(){
    window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=650,left=100,top=60");
    document.form1.jobid.value = "print_bill";
    document.form1.AINF_SEQN.value = "<%= e17BillData.AINF_SEQN %>";
    document.form1.RCPT_NUMB.value = "<%= e17BillData.RCPT_NUMB %>";
    document.form1.target = "essPrintWindow";
    document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E17Hospital.E17BillControlSV';
    document.form1.method = "post";
    document.form1.submit();
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
            <td class="title01">진료비 계산서 조회</td>
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
        <table width="364" border="0" cellspacing="0" cellpadding="2">
          <tr> 
            <td class="font01" valign="bottom"><font color="#7897FC">■</font> 
              보험급여</td>
          </tr>
          <tr> 
            <td> 
              <table width="360" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr> 
                  <td class="td03" width="135">총 진료비</td>
                  <td class="td02"> 
                    <input type="text" name="TOTL_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03">조합부담금</td>
                  <td class="td02"> 
                    <input type="text" name="ASSO_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03">본인부담금①</td>
                  <td class="td02"> 
                    <input type="text" name="x_EMPL_WONX" style="text-align:right" size="25" class="input04" readonly>
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
              <table width="360" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr> 
                  <td class="td03" width="135">식 대</td>
                  <td class="td02"> 
                    <input type="text" name="MEAL_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03">지정진료비</td>
                  <td class="td02"> 
                    <input type="text" name="APNT_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03">상급병실료차액</td>
                  <td class="td02"> 
                    <input type="text" name="ROOM_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03">C T</td>
                  <td class="td02"> 
                    <input type="text" name="CTXX_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03">MRI</td>
                  <td class="td02"> 
                    <input type="text" name="MRIX_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03">초음파</td>
                  <td class="td02"> 
                    <input type="text" name="SWAV_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03"> 
                    <input type="text" name="ETC1_TEXT" style="text-align:center" size="15" class="input04" readonly>
                  </td>
                  <td class="td02"> 
                    <input type="text" name="ETC1_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03"> 
                    <input type="text" name="ETC2_TEXT" style="text-align:center" size="15" class="input04" readonly>
                  </td>
                  <td class="td02"> 
                    <input type="text" name="ETC2_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03"> 
                    <input type="text" name="ETC3_TEXT" style="text-align:center" size="15" class="input04" readonly>
                  </td>
                  <td class="td02"> 
                    <input type="text" name="ETC3_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03"> 
                    <input type="text" name="ETC4_TEXT" style="text-align:center" size="15" class="input04" readonly>
                  </td>
                  <td class="td02"> 
                    <input type="text" name="ETC4_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                <tr> 
                  <td class="td03"> 
                    <input type="text" name="ETC5_TEXT" style="text-align:center" size="15" class="input04" readonly>
                  </td>
                  <td class="td02"> 
                    <input type="text" name="ETC5_WONX" style="text-align:right" size="25" class="input04" readonly>
                  </td>
                </tr>
                </tr>
                <tr> 
                  <td class="td03">소 계②</td>
                  <td class="td02"> 
                    <input type="text" name="EMPL_WONX_sub" style="text-align:right" size="25" class="input04" readonly>
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
              <table width="360" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr> 
                  <td class="td03" width="135">할인금액③</td>
                  <td class="td02">
                    <input type="text" name="DISC_WONX" style="text-align:right" size="25" class="input04" readonly>
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
              <table width="360" border="0" cellspacing="1" cellpadding="2" align="center" class="table02">
                <tr> 
                  <td class="td03" width="135">① + ② - ③</td>
                  <td class="td02"> 
                    <input type="text" name="EMPL_WONX_tot" style="text-align:right" size="25" class="input04" readonly>
                    <%= e17BillData.WAERS %>
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
      <a href="javascript:history.back()">
      <img src="<%= WebUtil.ImageURL %>btn_prevview.gif" width="59" height="20" align="absmiddle" border="0"></a> 
      <a href="javascript:do_print();">
      <img src="<%= WebUtil.ImageURL %>btn_print.gif" width="59" height="20" align="absmiddle" border="0"></a> 
      </td>
    </tr>
  </table>
<!-- hidden field : common -->
    <input type="hidden" name="jobid"      value="">
    <input type="hidden" name="AINF_SEQN"  value="">
    <input type="hidden" name="RCPT_NUMB"  value=""> 
<!-- hidden field : common -->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

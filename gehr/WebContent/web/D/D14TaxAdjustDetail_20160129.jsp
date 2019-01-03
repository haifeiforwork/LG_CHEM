<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D14TaxAdjustDetail.jsp                                      */
/*   Description  : 연말정산내역조회 조회                                       */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-01  윤정현                                          */
/*                  2005-11-24  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
/*                  2013-02-06  @v2  특별공제 > _특별공제_주택저당차입금이자공제액 /Y79   금액에 추가 */
/*                  2014-01-15  C20140106_63914 /YSP 한부모가족 /YAA 특별공제 종합한도 초과액 추가  */
/*                  2015-02-10  [CSR ID:2703097] 연말정산내역 조회의 문구 추가 요청 */
/*                  2015-05-18  [CSR ID:2778743] 연말정산 내역조회 화면 수정   */
/*                  2015-05-22  [CSR ID:2782595] 5월 급여 공지사항 문구 삽입 요청                                                            */
/*                  2015-06-15  [CSR ID:2801522] 해외근무자 연말정산 open  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    //D14TaxAdjustData data       = (D14TaxAdjustData)request.getAttribute("d14TaxAdjustData") ;


    //C20140106_63914 구조변경되어 수정
    Vector D14TaxAdjustData_vt = ( Vector ) request.getAttribute( "d14TaxAdjustData_vt" ) ;

    String           targetYear = (String)request.getAttribute("targetYear") ;
    String		notChgP = (String)request.getAttribute("notChgP");//[CSR ID:2778743]  2014 연말정산 재정산 해당하지 않는 인원 구분 용.(Y=변경없음, N=변경있음)

    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

    TaxAdjustFlagData taxAdjustFlagData = ((TaxAdjustFlagData)session.getAttribute("taxAdjust"));
    String Message ="";
    String curYear = "";
    curYear = Integer.toString(Integer.parseInt( taxAdjustFlagData.targetYear ) - 1);

    	    D14TaxAdjustDetailRFC  rfc1  = new D14TaxAdjustDetailRFC();
    //if( disp_from <= 0 && disp_toxx >= 0 ) {
    //} else {
    //    if ( targetYear.equals(taxAdjustFlagData.targetYear) ) {
    //        data = null;
    //        data = (D14TaxAdjustData)rfc1.detail( user.empNo, targetYear );
    //
    //       // Vector d14TaxAdjustData_vt = rfc.detail( user.empNo, targetYear );
    //
    //
    //    }
    //}
    String Gubn = "Detail";   //@v1.1

    String title="";

       int ROW=0;
    String overseaYN="";
    String[] titleText = new String[]{"0","","",""};

       for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
    	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
		if ( data.Count >0  ){

			ROW++;
		    	if (j==0) {
		    	    title = "국내";
		        }else if (j==1) {
		    	    title = "해외근무기간(1~6월)"; //S 해외근무기간(1~6월)
		    	    overseaYN ="Y";
		        }else if (j==2) {
		    	    title = "해외근무기간(7~12월)";  //T 해외근무기간(7~12월)
		    	    overseaYN ="Y";
		        }else if (j==3) {
		    	    title = "국내근무기간";  //L 국내근무기간
		    	    overseaYN ="Y";
		    	}

		    	titleText[j]=   title;
		}
	}

%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<style>
<!--
.xtr01 {font-size: 12px; background-color: #FFDECE}
.xtd01 {font-size: 9pt; font-weight: normal; color: #333333; background-color: #FFC0A2; padding-left: 10px}
.xtd02 {font-size: 9pt; color: #333333; padding-left: 5px; background-color: #FFC0A2; line-height: 14pt}
.xtd03 {font-size: 9pt; background-color: #FFC0A2; font-weight: normal; text-align: center; line-height: 14pt}
.xtd04 {font-size: 9pt; background-color: #DBDBDB; font-weight: normal; text-align: center; line-height: 14pt}
-->
</style>
<SCRIPT LANGUAGE="JavaScript">


// (해외근무자)국내 연말정산 내역조회
function do_Taxadj() {
//    if( do_Check(1) ) {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D14TaxAdjustDetail_k_SV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
//    }
}

function showList() {
    var up = document.form1;
    var up1 = eval(up.year.options[up.year.options.selectedIndex].value);
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D14TaxAdjustDetailSV?targetYear="+up1;
    document.form1.method = "post" ;
    document.form1.target = "menuContentIframe" ;
    document.form1.submit() ;
}

function cardInfo()
	{
	    window.open( "<%= WebUtil.JspURL %>D/D14TaxAdjustCardInfopopup.jsp", "cardInfo", "width=630,height=300,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
	}

function init(){
//@2015 연말정산 해당 function 사용안함
//[CSR ID:2801522] 해외근무자 연말정산 open
<%    if ( !overseaYN.equals("Y") || (overseaYN.equals("Y") && Integer.parseInt(DataUtil.getCurrentDate())>=20150616)){ %>
	window.open( "<%= WebUtil.JspURL %>D/D14TaxAdjustReTaxGuidepopup.jsp", "cardInfo", "width=557,height=503,toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=0,left=100,top=100");
	<%}%>
}
//-->
</SCRIPT>
</head>

<!-- @2015 연말정산 init() 삭제 -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  ><!-- 20151110 담당님 지시사항 보안조치 강화 -->
<form name="form1" method="post">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="850" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="850">
              <table width="850" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">연말정산 내역 조회</td>
                  <td align="right"></td>
                </tr>
              </table></td>
          </tr>

          <tr>
            <td height="10">&nbsp;</td>
          </tr>
    <tr>
      <td class="font01">연도 :
        <select name="year">
<%
    String selectYear = taxAdjustFlagData.targetYear;
    if( disp_from <= 0 && disp_toxx >= 0 ) {
    } else {
        selectYear = Integer.toString(Integer.parseInt( taxAdjustFlagData.targetYear ) - 1);
        if ( targetYear.equals(taxAdjustFlagData.targetYear) ) {
            targetYear = Integer.toString(Integer.parseInt( targetYear ) - 1);
        }
    }

    for( int i = Integer.parseInt( selectYear )  ; i <= Integer.parseInt( selectYear ) ; i++ ) {
  //  for( int i = Integer.parseInt( selectYear )-3 ; i <= Integer.parseInt( selectYear ) ; i++ ) {
%>
         <option value="<%= i %>" <%= i == Integer.parseInt(targetYear) ? "selected" : "" %>><%= i %></option>
<%
    }
%>
        </select>
        <a href="javascript:showList();"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif" border="0" align="absmiddle"></a>
      </td>
    </tr>
    <%@ include file="../D/D11TaxAdjust/D11TaxAdjustButton.jsp"  %>

    <tr>
      <td>
        <!--개인정보 테이블 시작-->
        <table width="780" border="0" cellspacing="0" cellpadding="0" height="22">
<%


    //if(user.e_oversea.equals("X")||user.e_oversea.equals("L")) {
    if(user.e_oversea.equals("X999")||user.e_oversea.equals("L999")) {
    //국내 연말정산 내역조회 해외근무자에게 제공하는것을 중단함
%>
          <tr>
            <td width="63"></td>
            <td width="72"> </td>
            <td width="72"> </td>
            <td width="109"></td>
            <td width="109"></td>
            <td width="109"></td>
            <td width="102"></td>
            <td width="144">
            <a href="javascript:do_Taxadj();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Taxadj','','<%= WebUtil.ImageURL %>k_on.gif',1)"><img name="Taxadj" border="0" src="<%= WebUtil.ImageURL %>k_off.gif" alt="국내소득연말정산조회"></a>
            </td>
          </tr>
<%
    } else {
%>
          <tr>
            <td width="63"></td>
            <td width="72"> </td>
            <td width="72"> </td>
            <td width="109"></td>
            <td width="109"></td>
            <td width="109"></td>
            <td width="102"></td>
            <td width="144">
          </tr>
<%
    }
%>
        </table>
        <!--개인정보 테이블 끝-->
      </td>
    </tr>
    <tr>
      <td>

<!-----------------T A B L E -- S T A R T-------------------------------------------------------------------------------->
<%

    Message    = (String)rfc1.GetMessage(user.empNo, targetYear );

     //out.println("D14TaxAdjustData_vt:"+D14TaxAdjustData_vt.toString());
     if( D14TaxAdjustData_vt.size() > 0 ) {
      	for ( int i = 0 ; i < D14TaxAdjustData_vt.size() ; i++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( i ) ;

	    if (data.isUsableData.equals("NO")&& Message.equals("")){
	        Message = "해당연도에 연말정산 내역 데이타가 없습니다.";
	    }
      	}
     }
%>


<%
     if(!Message.equals("")){
    //if(data.isUsableData.equals("NO") ||  ( targetYear.equals("2007") && ( Long.parseLong("20080111") > Long.parseLong(DataUtil.getCurrentDate())  ) )  ){
%>
        <table width="780" border="0" cellspacing="1" cellpadding="2" bordercolor="#999999" class="table01">
          <tr>
            <td class="td03" align="center"><br><%=Message%><br>&nbsp;</td>
          </tr>
        </table>

<%

    } else {

%>

 <!-- [CSR ID:2801522] 해외근무자 연말정산 open 6/22 오픈 -->
<%    if ( overseaYN.equals("Y") && Integer.parseInt(DataUtil.getCurrentDate())<20150616 ){ %><!-- @2014연말정산 삭제요청 Y 를 X로 변경 //[CSR ID:2782595] 5월 급여 공지사항 문구 삽입 요청 -->
        <table width="780" border="5" cellspacing="0" cellpadding="0">
          <tr>
            <td class="tr01"  align="left" width="100%"><!-- ※2014년 中 해외근무 기간이 있는 경우에는 별도 작업으로 인하여 2월 13일(금) 이후에 조회 가능합니다.  -->
            	※2014년 해외근무 기간이 있는 경우에는 별도의 일정을 수립하여 연말정산 재정산 대상자 선정 및 작업을 실시할 예정입니다.
            </td>

          </tr>
        </table>
<%    }else{//국내사번의 경우 %>
        <!--연말정산 내역 테이블 시작-->
<%if(notChgP.equals("Y")){ %>
<table width="100%"cellspacing="1"  bgcolor="#FFDECE">
<tr><td align="center"><br>
<font color="blue" size="3" align="center"><b><u><%=user.ename %>님</u>은 금번 <u>연말정산 재정산 대상 항목이 없어 환급 금액이 발생하지 않았습니다.</u></b></font>
<br>
<br> <font color="#333333"  size="3">기타 관련 문의사항은  본사 HR서비스팀 또는 각 사업장 담당부서(인사지원팀, 총무팀)으로 연락 주시기 바랍니다.</font>
<br>&nbsp;
</td></tr>
</table>
<br>
<%} %>
        <table width="900" border="0" cellspacing="1" cellpadding="2" bordercolor="#999999" class="table02">


          <tr>
            <td class="td03" colspan="4" width=60%>항목</td>
<%
         //for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      //D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
		//if ( data.Count >0  ){
%>
            <!-- @2014 연말정산 <td class="tr01" align="center" width=10%>&nbsp;< %=titleText[j]%>-->
            <td class="td03" width=10% align="center">금액</td>
            </td>

<%		//}
	//}
%>
			<td class="td03" width=30%  align="center">비고</td>
          </tr>

          <tr>
            <td class="td03" rowspan="4" width=10%>전근무지</td>
            <td class="td01" colspan="3">급여총액</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._전근무지_급여총액    ==0) ? ""    : (WebUtil.printNumFormat(data._전근무지_급여총액,0)+" 원")%>&nbsp;
            </td>

<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
           <tr>
            <td class="td01" colspan="3">상여총액</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._전근무지_상여총액               ==0)?""    :(WebUtil.printNumFormat(data._전근무지_상여총액,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
		<td class="td01" ></td>
	  </tr>
          <tr>
            <td class="td01" colspan="3">인정상여</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._전근무지_인정상여               ==0)?""    :(WebUtil.printNumFormat(data._전근무지_인정상여,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>

          <tr>
            <td class="td01" colspan="3">비과세소득</td>
<%
     for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data1 = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data1.Count>0) {
%>

            <td class="tr01" align="right">
<% double bgs = data1._전근무지_비과세해외소득 + data1._전근무지_비과세초과근무 + data1._전근무지_기타비과세대상; %>
<%=(bgs    ==0)?""                       :(WebUtil.printNumFormat(bgs                     ,0)+" 원")%>&nbsp;
            </td>
<%	      }
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td03" rowspan="4">현근무지</td>
            <td class="td01" colspan="3">급여총액</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._급여총액               ==0)?""             :(WebUtil.printNumFormat(data._급여총액               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td01" colspan="3">상여총액</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._상여총액               ==0)?""             :(WebUtil.printNumFormat(data._상여총액               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td01" colspan="3">인정상여</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._인정상여               ==0)?""             :(WebUtil.printNumFormat(data._인정상여               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td01" colspan="3">비과세소득</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<% double bgs2 = (data._비과세소득_국외근로 + data._비과세소득_야간근로수당 + data._비과세소득_기타비과세) - (data._전근무지_비과세해외소득 + data._전근무지_비과세초과근무 + data._전근무지_기타비과세대상); %>
<%=(bgs2    ==0)?""                       :(WebUtil.printNumFormat(bgs2                     ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="xtd03" colspan="4">총급여
<%    if ( overseaYN.equals("X") ){ %><!-- @2014 연말정산 삭제요청 Y를 X로 변경-->
          :  <font color=red>해당기간의 소득을 연간소득으로 환산함(소득÷해당기간 월수×12개월)</font>
<%    }%>
            </td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="xtr01" align="right">
<%=(data._총급여                 ==0)?""             :(WebUtil.printNumFormat(data._총급여                 ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01" ></td>
          </tr>

          <tr>
            <td class="td03" colspan="4">근로소득공제</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._근로소득공제           ==0)?""              :(WebUtil.printNumFormat(data._근로소득공제           ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="xtd03" colspan="4">근로소득금액</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="xtr01" align="right">
<%=(data._과세대상근로소득금액   ==0)?""               :(WebUtil.printNumFormat(data._과세대상근로소득금액   ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01" >&nbsp;총급여 - 근로소득공제</td>
          </tr>
          <tr>
            <td class="td03" rowspan="3">기본공제</td>
            <td class="td01" colspan="3">본인</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._기본공제_본인          ==0)?""               :(WebUtil.printNumFormat(data._기본공제_본인          ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>

          <tr>
            <td class="td01" colspan="3">배우자</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._기본공제_배우자        ==0)?""               :(WebUtil.printNumFormat(data._기본공제_배우자        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td01" colspan="3">부양가족</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._기본공제_부양가족      ==0)?""    :(WebUtil.printNumFormat(data._기본공제_부양가족      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td03" rowspan="4">추가공제</td>
            <td class="td01" colspan="3">경로우대</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._추가공제_경로우대70      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_경로우대70      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td01" colspan="3">장애인</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._추가공제_장애인        ==0)?""    :(WebUtil.printNumFormat(data._추가공제_장애인        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td01" colspan="3">부녀자</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._추가공제_부녀자        ==0)?""    :(WebUtil.printNumFormat(data._추가공제_부녀자        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<!--@2015 연말정산 <td class="td01" >&nbsp;근로소득금액이 3,000만원 이하인 경우에만 가능</td> -->
			<td class="td01" >&nbsp;총급여 4,147만원 이하인 경우에만 가능</td>
          </tr>

          <!--CSR ID:C20140106_63914  한부모가족 /YSP -->
          <tr>
            <td class="td01" colspan="3">한부모가족</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._추가공제_한부모가족    ==0)?""    :(WebUtil.printNumFormat(data._추가공제_한부모가족    ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td03" rowspan="2">연금보험료공제</td>
            <td class="td01" colspan="3">국민연금보험료</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._연금보험료공제         ==0)?""    :(WebUtil.printNumFormat(data._연금보험료공제 - data._연금보험료공제_기타       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <tr>
            <td class="td01" colspan="3">기타연금보험료공제</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._연금보험료공제_기타         ==0)?""    :(WebUtil.printNumFormat(data._연금보험료공제_기타         ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>

          <tr>
            <td class="td03" rowspan="4">특별공제</td>
            <td class="td01" colspan="3">건강보험료</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._특별공제_건강보험료        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_건강보험료        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>
          <td class="td01" colspan="3">고용보험료</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._특별공제_고용보험료        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_고용보험료        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>

          <tr>
            <td class="td01" colspan="3">주택자금(주택임차차입원리금상환액,<br>&nbsp;저당차입금이자상환액)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%  //C20130206_68828
    double Y54_Y68_Y5L_Y79 = (data._특별공제_주택자금이자상환액 + 0+data._특별공제_주택임차차입금원리금상환액+ 0 + data._특별공제_주택저당차입금이자공제액+0 )  ; %>
<%=(Y54_Y68_Y5L_Y79      ==0)?""    :(WebUtil.printNumFormat(Y54_Y68_Y5L_Y79 ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" >&nbsp;임차차입원리금상환액:납입액×40%
<br>&nbsp;(임차차입원리금상환액에 한하여, 주택마련저축공제포함 300만원한도)</td>
          </tr>

          <tr>
            <td class="td01" colspan="3">기부금(이월분)
<%    if ( overseaYN.equals("Y") ){ %>
          :  <font color=red>국내근무자 총소득 동일 구간별 평균 공제액 반영</font>
<%    }%>
            </td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._특별공제_기부금        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_기부금        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>

          <tr>
<%if(notChgP.equals("Y")){ %>
			<td class="td03" rowspan="5">그밖의 소득공제</td>
<%}else{ %>
            <td class="td03" rowspan="6">그밖의 소득공제</td>
<%} %>
            <td class="td01" colspan="3">개인연금저축</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._개인연금저축소득공제 == 0)?"":(WebUtil.printNumFormat(data._개인연금저축소득공제,0)+" 원")%>&nbsp;
	    </td>
<%		}
	}
%>
			<td class="td01" >&nbsp;납입액×40%(72만원한도)</td>
          </tr>


          <tr>
            <td class="td01" colspan="3">주택마련저축소득공제(청약저축,주택청약종합저축)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._특별공제_주택마련저축소득공제 == 0)?"":(WebUtil.printNumFormat(data._특별공제_주택마련저축소득공제,0)+" 원")%>&nbsp;
	    </td>
<%		}
	}
%>
			<td class="td01" >&nbsp;납입액×40%(임차차입원리금상환액 포함 300만원한도)</td>
          </tr>

          <tr>
            <td class="td01" colspan="3">투자조합출자 소득공제</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._투자조합출자등소득공제 ==0)?""    :(WebUtil.printNumFormat(data._투자조합출자등소득공제 ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>

<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------신용카드 시작-------------------------------------------------------- -->
<%if (notChgP.equals("Y")){ %>
		<tr>
            <td class="td01" colspan="3">신용카드 등 소득공제
<%    if ( overseaYN.equals("Y") ){ %>
          :  <font color=red>국내근무자 총소득 동일 구간별 평균 공제액 반영</font>
<%    }%>
            </td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._신용카드공제          ==0)?""    :(WebUtil.printNumFormat(data._신용카드공제           ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" >
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
			<!-- @2015 연말정산<a href="javascript:cardInfo();"><font color=red><b>&nbsp;공제기준 상세내역</b></font></a> -->
			&nbsp;총급여 25% 초과 시 소득공제 가능
<%} %>
			</td>
          </tr>
<%}else{ %>
          <tr>
            <td class="td01" colspan="3">신용카드 등 소득공제(전)
<%    if ( overseaYN.equals("Y") ){ %>
          :  <font color=red>국내근무자 총소득 동일 구간별 평균 공제액 반영</font>
<%    }%>
            </td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._신용카드공제_전          ==0)?""    :(WebUtil.printNumFormat(data._신용카드공제_전           ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" rowspan="2">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
			<!-- @2015 연말정산<a href="javascript:cardInfo();"><font color=red><b>&nbsp;공제기준 상세내역</b></font></a> -->
			&nbsp;총급여 25% 초과 시 소득공제 가능
<%} %>
			</td>
          </tr>


          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
          <tr>
            <td class="td01" colspan="3">신용카드 등 소득공제(후)
<%    if ( overseaYN.equals("Y") ){ %>
          :  <font color=red>국내근무자 총소득 동일 구간별 평균 공제액 반영</font>
<%    }%>
            </td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._신용카드공제           ==0)?""    :(WebUtil.printNumFormat(data._신용카드공제           ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
          </tr>
<%} %>
<!-- ------------------------------------------------신용카드 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->


          <tr>
            <td class="td01" colspan="3">장기집합투자증권저축</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="tr01" align="right">
<%=(data._그밖의_장기집합투자증권저축       ==0)?""    :(WebUtil.printNumFormat(data._그밖의_장기집합투자증권저축       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01">&nbsp;납입액×40%(240만원한도) 단, 총급여 8,000만원 이하</td>
          </tr>


          <!--CSR ID:C20140106_63914  특별공제 종합한도 초과액  -->
          <tr>
            <td class="td03" colspan="4">종합한도 초과액</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._특별공제_종합한도_초과액       ==0)?""    :(WebUtil.printNumFormat(data._특별공제_종합한도_초과액       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" ></td>
          </tr>


<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------종합소득 과세표준 시작-------------------------------------------------------- -->
<%if(notChgP.equals("Y")){ %>
          <tr>
            <td class="xtd03" colspan="4">종합소득 과세표준</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="xtr01" align="right">
<%=(data._종합소득과세표준       ==0)?""    :(WebUtil.printNumFormat(data._종합소득과세표준       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01">&nbsp;근로소득금액－기본－추가－연금－특별－그밖의소득공제</td>
          </tr>
          <tr>
            <td class="xtd03" colspan="4">산출세액</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="xtr01" align="right">
<%=(data._산출세액               ==0)?""    :(WebUtil.printNumFormat(data._산출세액               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01">&nbsp;과세표준×세율－누진공제율</td>
          </tr>
<%}else{ %>
          <tr>
            <td class="xtd03" colspan="4">종합소득 과세표준(전)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="xtr01" align="right">
<%=(data._종합소득과세표준_전       ==0)?""    :(WebUtil.printNumFormat(data._종합소득과세표준_전       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01">&nbsp;근로소득금액－기본－추가－연금－특별－그밖의소득공제</td>
          </tr>
<!-- [CSR ID:2778743] -->
          <tr>
            <td class="xtd03" colspan="4">산출세액(전)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="xtr01" align="right">
<%=(data._산출세액_전               ==0)?""    :(WebUtil.printNumFormat(data._산출세액_전               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01">&nbsp;과세표준×세율－누진공제율</td>
          </tr>
<%
%>


          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
          <tr>
            <td class="xtd03" colspan="4">종합소득 과세표준(후)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="xtr01" align="right">
<%=(data._종합소득과세표준       ==0)?""    :(WebUtil.printNumFormat(data._종합소득과세표준       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01">&nbsp;근로소득금액－기본－추가－연금－특별－그밖의소득공제</td>
          </tr>
          <tr>
            <td class="xtd03" colspan="4">산출세액(후)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="xtr01" align="right">
<%=(data._산출세액               ==0)?""    :(WebUtil.printNumFormat(data._산출세액               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01">&nbsp;과세표준×세율－누진공제율</td>
          </tr>
<%
}
%>
<!-- ------------------------------------------------종합소득 과세표준 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->



          <tr>
<%if(notChgP.equals("Y")){ %>
			<td class="td03" rowspan="12">세액공제</td>
<%}else{ %>
            <td class="td03" rowspan="19">세액공제</td>
<%} %>
<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------근로소득 시작-------------------------------------------------------- -->
<%if(notChgP.equals("Y")){ %>
            <td class="td01" colspan="3">근로소득</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_근로소득     ==0)?""    :(WebUtil.printNumFormat(data._세액공제_근로소득      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01">&nbsp;</td>
          </tr>
<%}else{ %>

            <td class="td01" colspan="3">근로소득(전)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_근로소득_전      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_근로소득_전      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01" rowspan="2">&nbsp;</td>
          </tr>


          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
          <tr>
            <td class="td01" colspan="3">근로소득(후)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_근로소득      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_근로소득      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
          </tr>
<%} %>
<!-- ------------------------------------------------근로소득 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->

<!-- ------------------------------------------------자녀 시작-------------------------------------------------------- -->
<%if(notChgP.equals("Y")){ %>
          <tr>
            <td class="td01" colspan="3">자녀</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_자녀      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_자녀      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01">&nbsp;<!-- 자녀2명까지:1명당 15만원<br>&nbsp;자녀3명이상:30만원＋(자녀수－2)×20만원 --></td>
          </tr>
<%}else{ %>
          <tr>
            <td class="td01" colspan="3">자녀(전)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_자녀_전      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_자녀_전      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01" rowspan="2">&nbsp;<!-- 자녀2명까지:1명당 15만원<br>&nbsp;자녀3명이상:30만원＋(자녀수－2)×20만원 --></td>
          </tr>



          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
          <tr>
            <td class="td01" colspan="3">자녀(후)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_자녀      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_자녀      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
          </tr>
<%} %>
<!-- ------------------------------------------------자녀 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->
          <!-- @2014 연말정산 재정산 추가 항목 2건 -->
<!-- ------------------------------------------------추가 항목 2건 시작-------------------------------------------------------- -->
<%if(!notChgP.equals("Y")){ %>

           <tr>
            <td class="td01" colspan="3">6세 이하 자녀 2명이상(추가)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._추가공제_자녀양육비      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_자녀양육비      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           	<td class="td01"></td>
          </tr>
                     <tr>
            <td class="td01" colspan="3">출산 및 입양공제(추가)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._추가공제_출산입양      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_출산입양      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           	<td class="td01"></td>
          </tr>
<%} %>
<!-- ------------------------------------------------추가 항목 2건 끝-------------------------------------------------------- -->

           <tr>
            <td class="td01" colspan="3">과학기술인공제 및 퇴직연금소득공제</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_퇴직연금소득공제      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_퇴직연금소득공제      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           	<td class="td01"></td>
          </tr>


<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------연금저축소득공제 시작-------------------------------------------------------- -->
<%if(notChgP.equals("Y")){ %>
           <tr>
            <td class="td01" colspan="3">연금저축소득공제</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_연금저축소득공제      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_연금저축소득공제      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01">&nbsp;<!--납입액(400만원한도)×12%--></td>
          </tr>
<%}else{ %>
           <tr>
            <td class="td01" colspan="3">연금저축소득공제(전)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_연금저축소득공제_전      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_연금저축소득공제_전      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01" rowspan="2">&nbsp;<!--납입액(400만원한도)×12%--></td>
          </tr>


          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
           <tr>
            <td class="td01" colspan="3">연금저축소득공제(후)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_연금저축소득공제      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_연금저축소득공제      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
          </tr>
<%} %>
<!-- ------------------------------------------------연금저축소득공제 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->

<!-- ------------------------------------------------보장성보험료 시작-------------------------------------------------------- -->
<%if(notChgP.equals("Y")){ %>
           <tr>
            <td class="td01" colspan="3">보장성보험료</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_보장성보험료      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_보장성보험료      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01">&nbsp;<!-- 납입액(100만원한도)×12% --></td>
          </tr>
<%}else{ %>
           <tr>
            <td class="td01" colspan="3">보장성보험료(전)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_보장성보험료_전      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_보장성보험료_전      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01" rowspan="2">&nbsp;<!-- 납입액(100만원한도)×12% --></td>
          </tr>


          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
           <tr>
            <td class="td01" colspan="3">보장성보험료(후)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_보장성보험료      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_보장성보험료      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
          </tr>
<%} %>
<!-- ------------------------------------------------보장성보험료 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->


           <tr>
            <td class="td01" colspan="3">의료비
<%    if ( overseaYN.equals("Y") ){ %><!-- @2014 연말정산 해외대상 추가 -->
          :  <font color=red>국내근무자 총소득 동일 구간별 평균 공제액 반영</font>
<%    }%>
            </td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_의료비      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_의료비      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
           <!-- @2015 연말정산 &nbsp;(근로소득3%초과된 의료비(700만원한도)＋추가공제)×15% -->
           &nbsp;(총급여 3%초과된 의료비(700만원한도)＋추가공제)×15%
<%} %>
           </td>
          </tr>
           <tr>
            <td class="td01" colspan="3">교육비
<%    if ( overseaYN.equals("Y") ){ %><!-- @2014 연말정산 해외대상 추가 -->
          :  <font color=red>국내근무자 총소득 동일 구간별 평균 공제액 반영</font>
<%    }%>
            </td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_교육비      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_교육비      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
           &nbsp;교육비납입액(학력한도)×15%
<%} %>
           </td>
          </tr>
           <tr>
            <td class="td01" colspan="3">기부금
<%    if ( overseaYN.equals("Y") ){ %><!-- @2014 연말정산 해외대상 추가 -->
          :  <font color=red>국내근무자 총소득 동일 구간별 평균 공제액 반영</font>
<%    }%>
            </td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_기부금      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_기부금      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
           &nbsp;공제금액×15%(3,000만원 초과분은 25%)
<%} %>
           </td>
          </tr>
          <tr>
            <td class="td01" colspan="3">정치기부금</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_정치기부금==0)?""    :(WebUtil.printNumFormat(data._세액공제_정치기부금,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
			&nbsp;10만원이하:100/110<br>
&nbsp;10만원초과:10만원초과액×15%(3,000만원 초과분 25%)
<%} %>
</td>
          </tr>
          <tr>
            <td class="td01" colspan="3">주택차입금</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_주택차입금    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_주택차입금    ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="td01">&nbsp;이자상환액×30%</td>
          </tr>

<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------표준세액공제 시작-------------------------------------------------------- -->
<%if(notChgP.equals("Y")){ %>
<tr>
            <td class="td01" colspan="3">표준세액공제</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_표준세액공제    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_표준세액공제  ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01">
           &nbsp;<!-- 특별공제 및 세액공제가 "0"원일 때 12만원 공제<br>&nbsp;(단, 근로소득. 자녀공제 제외) -->
           </td>
          </tr>

<%}else{ %>
 			<tr>
            <td class="td01" colspan="3">표준세액공제(전)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_표준세액공제_전    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_표준세액공제_전    ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01" rowspan="2">
           &nbsp;<!-- 특별공제 및 세액공제가 "0"원일 때 12만원 공제<br>&nbsp;(단, 근로소득. 자녀공제 제외) -->
           </td>
          </tr>


          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
 			<tr>
            <td class="td01" colspan="3">표준세액공제(후)</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_표준세액공제    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_표준세액공제    ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
          </tr>
<%} %>
<!-- ------------------------------------------------표준세액공제 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->

           <tr>
            <td class="td01" colspan="3">월세액</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="tr01" align="right">
<%=(data._세액공제_월세액    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_월세액    ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td class="td01">&nbsp;월세액(750만원한도)×10% 단, 총급여 7,000만원 이하</td>
          </tr>

          <tr>
          	<td class="td03"></td>
            <td class="td03" width=10%>갑근세</td>
            <td class="td03" width=10%>주민세</td>
            <td class="td03" width=10%>농특세</td>
            <td class="td03" colspan=<%=ROW%> width=10%>계</td>
            <td class="td03"></td>
          </tr>

<%
      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
    double _전근무지기납부세액합계 = data._전근무지_납부소득세 + data._전근무지_납부주민세 +  data._전근무지_납부특별세;

%>
<!-- @2014 연말정산 해당 항목 삭제
< %	if (!titleText[j].equals("국내")){%>
	  <tr><td class="tr01" colspan=< %=ROW+4%>><b>< %=titleText[j]%><b></td></tr>
< %	} %>	  -->
<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------결정세액 시작-------------------------------------------------------- -->
<%if(notChgP.equals("Y")){ %>
          <tr>
            <td class="xtd01">결정세액</td>
            <td class="xtr01" align="right">
<%=(data._결정세액_갑근세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_갑근세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_주민세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_주민세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_농특세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_농특세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right"  colspan=<%=ROW%>>
<%=(data._결정세액합계           ==0)?""    :(WebUtil.printNumFormat( data._결정세액합계 ,0)+" 원")%>&nbsp;
            </td>
            <td class="xtd01" >&nbsp;산출세액－세액공제</td>
          </tr>
<%}else{ %>
          <tr>
            <td class="xtd01">결정세액(전)
<!-- @2014 연말정산 해당 항목 삭제
< %    if ( data.ABART.equals("S") ){ //S 해외근무기간(1~6월) %>
         <br> :  <font color=red>(산출세액－세액공제)÷12개월×해당기간 월수×2/3</font>

< %    }else if ( data.ABART.equals("T") ){ //T 해외근무기간(7~12월) %>
         <br> : <font color=red>(산출세액－세액공제)÷12개월×해당기간 월수</font>
         <!--<br> : <font color=red>(산출세액－세액공제)</font>- ->
< %    }else if ( data.ABART.equals("L") ){ //L 국내근무기간 %>
         <br> :  <font color=red>(산출세액－세액공제)÷12개월×해당기간 월수</font>
< %    }  %>
-->
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_갑근세_전        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_갑근세_전,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_주민세_전        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_주민세_전,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_농특세_전        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_농특세_전,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right"  colspan=<%=ROW%>>
<%=(data._결정세액합계_전           ==0)?""    :(WebUtil.printNumFormat( data._결정세액합계_전 ,0)+" 원")%>&nbsp;
            </td>
            <td class="xtd01" rowspan="2">&nbsp;산출세액－세액공제</td>
          </tr>


          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
          <tr>
            <td class="xtd01">결정세액(후)</td>
            <td class="xtr01" align="right">
<%=(data._결정세액_갑근세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_갑근세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_주민세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_주민세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._결정세액_농특세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_농특세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right"  colspan=<%=ROW%>>
<%=(data._결정세액합계           ==0)?""    :(WebUtil.printNumFormat( data._결정세액합계 ,0)+" 원")%>&nbsp;
            </td>
          </tr>
<%} %>
<!-- ------------------------------------------------결정세액 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->


          <tr>
            <td class="td01">기납부세액(전)</td>
            <td class="tr01" align="right">
<%=(data._전근무지_납부소득세      ==0)?""    :(WebUtil.printNumFormat(data._전근무지_납부소득세      ,0)+" 원")%>&nbsp;
            </td>
            <td class="tr01" align="right">
<%=(data._전근무지_납부주민세      ==0)?""    :(WebUtil.printNumFormat(data._전근무지_납부주민세      ,0)+" 원")%>&nbsp;
            </td>
            <td class="tr01" align="right">&nbsp;
<%=(data._전근무지_납부특별세      ==0)?""    :(WebUtil.printNumFormat(data._전근무지_납부특별세      ,0)+" 원")%>
            </td>
            <td class="tr01" align="right" colspan=<%=ROW%>>
<%=( _전근무지기납부세액합계         ==0)?""    :(WebUtil.printNumFormat( _전근무지기납부세액합계  ,0)+" 원")%>&nbsp;
            </td>
            <td class="td01"></td>
          </tr>

<%
    double _기납부세액_갑근세1 = data._기납부세액_갑근세 - data._전근무지_납부소득세 ;
    double _기납부세액_주민세1 = data._기납부세액_주민세 - data._전근무지_납부주민세 ;
    double _기납부세액_농특세1 = data._기납부세액_농특세 - data._전근무지_납부특별세 ;
    double _기납부세액합계1 = _기납부세액_갑근세1+_기납부세액_주민세1+_기납부세액_농특세1 ;
%>
          <tr>
            <td class="td01">기납부세액(현)</td>
            <td class="tr01" align="right">
<%=(_기납부세액_갑근세1      ==0)?""    :(WebUtil.printNumFormat(_기납부세액_갑근세1      ,0)+" 원")%>&nbsp;
            </td>
            <td class="tr01" align="right">
<%=(_기납부세액_주민세1      ==0)?""    :(WebUtil.printNumFormat(_기납부세액_주민세1      ,0)+" 원")%>&nbsp;
            </td>
            <td class="tr01" align="right">
<%=(_기납부세액_농특세1      ==0)?""    :(WebUtil.printNumFormat(_기납부세액_농특세1      ,0)+" 원")%>&nbsp;
            </td>
            <td class="tr01" align="right" colspan=<%=ROW%>>
<%=(_기납부세액합계1         ==0)?""    :(WebUtil.printNumFormat(_기납부세액합계1         ,0)+" 원")%>&nbsp;
            </td>
            <td class="td01"></td>
          </tr>

<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------차감징수세액 시작-------------------------------------------------------- -->
<%if(notChgP.equals("Y")){ %>
          <tr>
            <td class="xtd01">차감징수세액</td><!-- 원단위 절사 -->
            <td class="xtr01" align="right">
<%=(data._차감징수세액_갑근세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_갑근세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._차감징수세액_주민세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_주민세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._차감징수세액_농특세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_농특세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right" colspan=<%=ROW%>>
<%=(data._차감징수세액합계       ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액합계,0)+" 원")%>&nbsp;
            </td>
            <td class="xtd01">&nbsp;결정세액－기납부세액(전/현)<br>&nbsp;(+) 금액은 추가납부, (-) 금액은 환급대상임</td><!-- [CSR ID:2703097] 연말정산내역 조회의 문구 추가 요청  -->
          </tr>
<%}else{ %>
          <tr>
            <td class="xtd01">차감징수세액(전)</td><!-- 원단위 절사 -->
            <td class="xtr01" align="right">
<%=(data._차감징수세액_갑근세_전    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_갑근세_전,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._차감징수세액_주민세_전    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_주민세_전,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._차감징수세액_농특세_전    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_농특세_전,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right" colspan=<%=ROW%>>
<%=(data._차감징수세액합계_전       ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액합계_전,0)+" 원")%>&nbsp;
            </td>
            <td class="xtd01" rowspan="2">&nbsp;결정세액－기납부세액(전/현)<br>&nbsp;(+) 금액은 추가납부, (-) 금액은 환급대상임</td><!-- [CSR ID:2703097] 연말정산내역 조회의 문구 추가 요청  -->
          </tr>

          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 시작-->
          <tr>
            <td class="xtd01">차감징수세액(후)</td><!-- 원단위 절사 -->
            <td class="xtr01" align="right">
<%=(data._차감징수세액_갑근세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_갑근세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._차감징수세액_주민세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_주민세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right">
<%=(data._차감징수세액_농특세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_농특세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01" align="right" colspan=<%=ROW%>>
<%=(data._차감징수세액합계       ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액합계,0)+" 원")%>&nbsp;
            </td>
          </tr>
<%} %>
<!-- ------------------------------------------------차감징수세액 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->
<%if(!notChgP.equals("Y")){ %>
		<tr>
			<td class="xtd01">재정산 지급액</td>
			<td class="xtr01" align="right" colspan="4"><%=(data._차감징수세액합계_2014       ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액합계_2014,0)+" 원")%></td>
			<td class="xtd01">&nbsp;차감징수세액(후)-차감징수세액(전)</td><!--@2014연말정산 재정산  -->
		</tr>
<%} %>
<%		}
	}
%>


        </table>


    <!--연말정산 내역 테이블 끝-->
<%
    }}//해외사번 잠시 안보이도록 막음.
%>

<!-------------T A B L E -- E N D--------------------------------------------------------------------------------------------->

      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
  </table>
  <input type="hidden" name="selectYear"       value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

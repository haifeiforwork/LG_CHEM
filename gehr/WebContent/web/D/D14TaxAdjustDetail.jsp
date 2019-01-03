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
/*                  2016-02-03  [CSR ID:2974323] 연말정산 내역조회 오픈요청  */
/*                  2017-02-13 [CSR ID:3301860] 연말정산 내역조회 화면 차량과세 임원 66명 주석 요청의 건  */
/*                  2017-02-14 [CSR ID:3301430] 2016 해외근무자 연말정산 관련(14일 막고 16일 오픈함)  */
/* 				 2018-02-01 cykim	[CSR ID:3598202] 2017 연말정산 내역조회 화면 수정 요청의 건  */
/* 				 2018-02-12 cykim   [CSR ID:3608233] 연말정산 내역조회 화면 수정요청의 건 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
    //[2974323] '14년도 연말정산에만 잠시 사용됨.소스에서 모두 제거함.

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
		    	    title = g.getMessage("LABEL.D.D14.0008"); //국내
		        }else if (j==1) {
		    	    title = g.getMessage("LABEL.D.D14.0009"); //S 해외근무기간(1~6월)
		    	    overseaYN ="Y";
		        }else if (j==2) {
		    	    title = g.getMessage("LABEL.D.D14.0010");  //T 해외근무기간(7~12월)
		    	    overseaYN ="Y";
		        }else if (j==3) {
		    	    title = g.getMessage("LABEL.D.D14.0011");  //L 국내근무기간
		    	    overseaYN ="Y";
		    	}

		    	titleText[j]=   title;
		}
	}
//[CSR ID:3301860] 연말정산 내역조회 화면 차량과세 임원 66명 주석 요청의 건_김소희(요청자)  begin
//[CSR ID:3598202] 2017 연말정산 차량과세 임원 대상 없으므로 주석처리 start
       /* List<String> roleAEmpnoList = Arrays.asList( "00205756"
               ,"00202896"
               ,"00039885"
               ,"00218574"
               ,"00019385"
               ,"00038297"
               ,"00205200"
               ,"00203141"
               ,"00005486"
               ,"00030032"
               ,"00034122"
               ,"00205503"
               ,"00037355"
               ,"00010684"
               ,"00217646"
               ,"00009577"
               ,"00218774"
               ,"00217842"
               ,"00015344"
               ,"00045403"
               ,"00003445"
               ,"00029319"
               ,"00215013"
               ,"00218586"
               ,"00035301"
               ,"00201910"
               ,"00217843"
               ,"00030287"
               ,"00005195"
               ,"00041808"
               ,"00040674"
               ,"00018383"
               ,"00110280"
               ,"00044504"
               ,"00037629"
               ,"00071783"
               ,"00037886"
               ,"00037424"
               ,"00044588"
               ,"00044527"
               ,"00017019"
               ,"00068594"
               ,"00213553"
               ,"00217201"
               ,"00070359"
               ,"00110358"
               ,"00044569"
               ,"00206182"
               ,"00215020"
               ,"00037567"
               ,"00030041"
               ,"00203593"
               ,"00111090"
               ,"00201234"
               ,"00043713"
               ,"00038096"
               ,"00217852"
               ,"00037916"
               ,"00037466"
               ,"00116534"
               ,"00003913"
               ,"00022778"
               ,"00204291"
               ,"00005487"
               ,"00218588"
               ,"00080798"); */
     //[CSR ID:3598202] 2017 연말정산 차량과세 임원 대상 없으므로 주석처리 end
     //[CSR ID:3301860] 연말정산 내역조회 화면 차량과세 임원 66명 주석 요청의 건_김소희(요청자)  end
%>

<jsp:include page="/include/header.jsp" />
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
<!-- @2015 연말정산 init() 삭제 -->
 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
         <jsp:param name="title" value="LABEL.D.D14.0012"/>
 </jsp:include>
<form name="form1" method="post">
<input type="hidden" name="jobid"  value="">
    <%@ include file="../D/D11TaxAdjust/D11TaxAdjustButton.jsp"  %>

        <!--개인정보 테이블 시작-->

<%


    //if(user.e_oversea.equals("X")||user.e_oversea.equals("L")) {
    if(user.e_oversea.equals("X999")||user.e_oversea.equals("L999")) {
    //국내 연말정산 내역조회 해외근무자에게 제공하는것을 중단함
%>
    <div class="listArea">
        <div class="table">
           <table class="tableGeneral" >
          <tr class="borderRow">
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
                  </table>
        <!--개인정보 테이블 끝-->
</div>
</div>
<%
    }
%>


<!-----------------T A B L E -- S T A R T-------------------------------------------------------------------------------->
<%

    Message    = (String)rfc1.GetMessage(user.empNo, targetYear );
     //out.println("D14TaxAdjustData_vt:"+D14TaxAdjustData_vt.toString());
     if( D14TaxAdjustData_vt.size() > 0 ) {
      	for ( int i = 0 ; i < D14TaxAdjustData_vt.size() ; i++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( i ) ;

	    if (data.isUsableData.equals("NO")&& Message.equals("")){
	        Message = g.getMessage("LABEL.D.D14.0013");  //해당연도에 연말정산 내역 데이타가 없습니다.
	    }
      	}
     }
%>


<%
     if(!Message.equals("")){
    //if(data.isUsableData.equals("NO") ||  ( targetYear.equals("2007") && ( Long.parseLong("20080111") > Long.parseLong(DataUtil.getCurrentDate())  ) )  ){
%>
<span class="commentOne"><%=Message%></span>
<%

    } else {

%>

 <!-- [CSR ID:2801522] 해외근무자 연말정산 open 6/22 오픈 및 일부 인원 해외근무 인원이나, 정상 조회 되도록 요청-->
<%    //if ( overseaYN.equals("Y") && Integer.parseInt(DataUtil.getCurrentDate())<20160116 &&!user.empNo.equals("00003913")&&!user.empNo.equals("00044527")&&!user.empNo.equals("00045894")&&!user.empNo.equals("00205756")&&!user.empNo.equals("00037466")&&!user.empNo.equals("00111090")){ <!-- @2014연말정산 삭제요청 Y 를 X로 변경 //[CSR ID:2782595] 5월 급여 공지사항 문구 삽입 요청 -->%>
 <!-- [CSR ID:3301430] 2016 해외근무자 연말정산 관련(20170214일 막고 20170216일 12시에 오픈함) begin-->
 <!-- [CSR ID:3598202] 2017 해외근무자, 국내사번 구분없이 내역조회 오픈으로 분기처리 주석처리함 start  -->
<%-- <%   if ( overseaYN.equals("Y") && Integer.parseInt(DataUtil.getCurrentDate())<20170216){ %>
 <!-- [CSR ID:3301430] 2016 해외근무자 연말정산 관련(14일 막고 16일 오픈함) end-->
       <span class="commentOne">※2016년 해외근무 기간이 있는 경우에는 별도의 일정을 수립하여 실시할 예정입니다.</span>
<%    }else{//국내사번의 경우 %> --%>
 <!-- [CSR ID:3598202] 2017 해외근무자, 국내사번 구분없이 내역조회 오픈으로 분기처리 주석처리함 end  -->

<!-- [CSR ID:2974323] 연말정산 내역조회 오픈요청 -->
<%if(user.e_werks.equals("AA00")||user.e_werks.equals("AB00")){ %>
<span class="commentOne"><font color=red><b><spring:message code="LABEL.D.D14.0015" /><!-- ※ 미비서류가 있을시 입력하신 모든 공제 부분이 미적용 되므로 미비서류를 보완 제출하여 연말정산 내역을 재확인하여 주시기 바랍니다. --></b></font></span>
<%} %>
        <!--연말정산 내역 테이블 시작-->

    <div class="tableArea">
        <div class="listTop">
                    <div class="buttonArea">

    <spring:message code="LABEL.D.D11.0002" /><!-- 연도 --> :
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
        </div>
        </div>
      <div class="table">
      <table class="listTable" style="text-align: left;">
        <thead>
          <tr class="borderRow">
            <th  colspan="4" width=60%><spring:message code="LABEL.D.D14.0016" /><!-- 항목 --></th>
<%
         //for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      //D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
		//if ( data.Count >0  ){
%>
            <!-- @2014 연말정산 <td  align="center" width=10%>&nbsp;< %=titleText[j]%>-->
            <th  width=10% align="center"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>

<%		//}
	//}
%>
			<th  width=30%  align="center" class="lastCol"><spring:message code="LABEL.D.D14.0017" /><!-- 비고 --></th>
          </tr>
        </thead>
          <tr class="borderRow">
            <td  rowspan="4" width=10%><spring:message code="LABEL.D.D11.0030" /><!-- 전근무지 --></td>
            <td  colspan="3"  class="align_left"  class="align_left"><spring:message code="LABEL.D.D14.0018" /><!-- 급여총액 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._전근무지_급여총액    ==0) ? ""    : (WebUtil.printNumFormat(data._전근무지_급여총액,0)+" 원")%>&nbsp;
            </td>

<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>

           <tr class="borderRow">
            <td  colspan="3"  class="align_left"  class="align_left"><spring:message code="LABEL.D.D14.0019" /><!-- 상여총액 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._전근무지_상여총액               ==0)?""    :(WebUtil.printNumFormat(data._전근무지_상여총액,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
		<td  class="lastCol"></td>
	  </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0020" /><!-- 인정상여 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._전근무지_인정상여               ==0)?""    :(WebUtil.printNumFormat(data._전근무지_인정상여,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
<%-- [CSR ID:3301860] 연말정산 내역조회 화면 차량과세 임원 66명 주석 요청의 건  begin --%>
			<td  class="lastCol align_left">
			<%-- [CSR ID:3598202] 2017 연말정산 차량과세 임원 대상 없으므로 주석처리 start --%>
			<%-- <%=roleAEmpnoList.contains(user.empNo) ? "<font color=red>업무용 차량 개인 사용분 과세반영 금액임</font>" : "" %> --%>
			<%-- [CSR ID:3598202] 2017 연말정산 차량과세 임원 대상 없으므로 주석처리 end --%>
<%-- [CSR ID:3301860] 연말정산 내역조회 화면 차량과세 임원 66명 주석 요청의 건  end --%>
			</td>
          </tr>

          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0021" /><!-- 비과세소득 --></td>
<%
     for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data1 = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data1.Count>0) {
%>

            <td  class="align_right">
<% double bgs = data1._전근무지_비과세해외소득 + data1._전근무지_비과세초과근무 + data1._전근무지_기타비과세대상; %>
<%=(bgs    ==0)?""                       :(WebUtil.printNumFormat(bgs                     ,0)+" 원")%>&nbsp;
            </td>
<%	      }
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td  rowspan="4"><spring:message code="LABEL.D.D14.0022" /><!-- 현근무지 --></td>
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0018" /><!-- 급여총액 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._급여총액               ==0)?""             :(WebUtil.printNumFormat(data._급여총액               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0019" /><!-- 상여총액 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._상여총액               ==0)?""             :(WebUtil.printNumFormat(data._상여총액               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0020" /><!-- 인정상여 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._인정상여               ==0)?""             :(WebUtil.printNumFormat(data._인정상여               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0021" /><!-- 비과세소득 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<% double bgs2 = (data._비과세소득_국외근로 + data._비과세소득_야간근로수당 + data._비과세소득_기타비과세) - (data._전근무지_비과세해외소득 + data._전근무지_비과세초과근무 + data._전근무지_기타비과세대상); %>
<%=(bgs2    ==0)?""                       :(WebUtil.printNumFormat(bgs2                     ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td class="xtd03" colspan="4"><spring:message code="LABEL.D.D14.0023" /><!-- 총급여 -->
<%    if ( overseaYN.equals("X") ){ %><!-- @2014 연말정산 삭제요청 Y를 X로 변경-->
          :  <font color=red>해당기간의 소득을 연간소득으로 환산함(소득÷해당기간 월수×12개월)</font>
<%    }%>
            </td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="xtr01 align_right">
<%=(data._총급여                 ==0)?""             :(WebUtil.printNumFormat(data._총급여                 ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01 lastCol" ></td>
          </tr>

          <tr class="borderRow">
            <td  colspan="4"><spring:message code="LABEL.D.D14.0024" /><!-- 근로소득공제 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._근로소득공제           ==0)?""              :(WebUtil.printNumFormat(data._근로소득공제           ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td class="xtd03" colspan="4"><spring:message code="LABEL.D.D14.0025" /><!-- 근로소득금액 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td class="xtr01 align_right">
<%=(data._과세대상근로소득금액   ==0)?""               :(WebUtil.printNumFormat(data._과세대상근로소득금액   ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01 lastCol align_left" >&nbsp;<spring:message code="LABEL.D.D14.0026" /><!-- 총급여 - 근로소득공제 --></td>
          </tr>
          <tr class="borderRow">
            <td  rowspan="3"><spring:message code="LABEL.D.D11.0015" /><!-- 기본공제 --></td>
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0027" /><!-- 본인 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._기본공제_본인          ==0)?""               :(WebUtil.printNumFormat(data._기본공제_본인          ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>

          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0028" /><!-- 배우자 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._기본공제_배우자        ==0)?""               :(WebUtil.printNumFormat(data._기본공제_배우자        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0029" /><!-- 부양가족 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._기본공제_부양가족      ==0)?""    :(WebUtil.printNumFormat(data._기본공제_부양가족      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td  rowspan="4"><spring:message code="LABEL.D.D11.0209" /><!-- 추가공제 --></td>
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D11.0011" /><!-- 경로우대 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._추가공제_경로우대70      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_경로우대70      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0030" /><!-- 장애인 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._추가공제_장애인        ==0)?""    :(WebUtil.printNumFormat(data._추가공제_장애인        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol"></td>
          </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D11.0013" /><!-- 부녀자 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._추가공제_부녀자        ==0)?""    :(WebUtil.printNumFormat(data._추가공제_부녀자        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<!--@2015 연말정산 <td  >&nbsp;근로소득금액이 3,000만원 이하인 경우에만 가능</td> -->
			<td  class="lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0031" /><!-- 총급여 4,147만원 이하인 경우에만 가능 --></td>
          </tr>

          <!--CSR ID:C20140106_63914  한부모가족 /YSP -->
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0032" /><!-- 한부모가족 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._추가공제_한부모가족    ==0)?""    :(WebUtil.printNumFormat(data._추가공제_한부모가족    ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left"></td>
          </tr>
          <tr class="borderRow">
            <td  rowspan="2"><spring:message code="LABEL.D.D14.0033" /><!-- 연금보험료공제 --></td>
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0034" /><!-- 국민연금보험료 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._연금보험료공제         ==0)?""    :(WebUtil.printNumFormat(data._연금보험료공제 - data._연금보험료공제_기타       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left"></td>
          </tr>
          <tr class="borderRow">
          <!-- [CSR ID:3598202] 2017 연말정산 -->
            <%-- <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0035" /><!-- 기타연금보험료공제 --></td> --%>
            <td  colspan="3"  class="align_left">공적연금보험료공제</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._연금보험료공제_기타         ==0)?""    :(WebUtil.printNumFormat(data._연금보험료공제_기타         ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left"></td>
          </tr>

          <tr class="borderRow">
            <td  rowspan="4"><spring:message code="LABEL.D.D11.0016" /><!-- 특별공제 --></td>
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D05.0109" /><!-- 건강보험료 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._특별공제_건강보험료        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_건강보험료        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left"></td>
          </tr>
          <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D05.0110" /><!-- 고용보험료 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._특별공제_고용보험료        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_고용보험료        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left"></td>
          </tr>

          <tr class="borderRow">
          <!-- [CSR ID:3598202] 2017 연말정산 내역조회 화면 수정 -->
            <td  colspan="3"  class="align_left">주택자금(주택임차차입원리금상환액, 저당차입금이자상환액)<%-- <spring:message code="LABEL.D.D14.0036" /> --%><!-- 주택자금(주택임차차입원리금상환액,<br>&nbsp;저당차입금이자상환액) --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%  //C20130206_68828
    double Y54_Y68_Y5L_Y79 = (data._특별공제_주택자금이자상환액 + 0+data._특별공제_주택임차차입금원리금상환액+ 0 + data._특별공제_주택저당차입금이자공제액+0 )  ; %>
<%=(Y54_Y68_Y5L_Y79      ==0)?""    :(WebUtil.printNumFormat(Y54_Y68_Y5L_Y79 ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0037" /><!-- 임차차입원리금상환액:납입액×40% -->
<br>&nbsp;<spring:message code="LABEL.D.D14.0038" /><!-- (임차차입원리금상환액에 한하여, 주택마련저축공제포함 300만원한도) --></td>
          </tr>

          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0039" /><!-- 기부금(이월분) -->
<%    if ( overseaYN.equals("Y") ){ %>
          :  <font color=red><spring:message code="LABEL.D.D14.0040" /><!-- 국내근무자 총소득 동일 구간별 평균 공제액 반영 --></font>
<%    }%>
            </td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._특별공제_기부금        ==0)?""    :(WebUtil.printNumFormat(data._특별공제_기부금        ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left"></td>
          </tr>

          <tr class="borderRow">

			<td  rowspan="6"><spring:message code="LABEL.D.D14.0041" /><!-- 그밖의 소득공제 --></td>

            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0042" /><!-- 개인연금저축 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._개인연금저축소득공제 == 0)?"":(WebUtil.printNumFormat(data._개인연금저축소득공제,0)+" 원")%>&nbsp;
	    </td>
<%		}
	}
%>
			<td  class="lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0043" /><!-- 납입액×40%(72만원한도) --></td>
          </tr>


          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0044" /><!-- 소기업 소상공인 공제부금 소득공제 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._소기업등소득공제 == 0)?"":(WebUtil.printNumFormat(data._소기업등소득공제,0)+" 원")%>&nbsp;
	    </td>
<%		}
	}
%>
			<td  class="lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0045" /><!-- 300만원 한도 --></td>
          </tr>



          <tr class="borderRow">
          <!-- [CSR ID:3598202] 2017 연말정산 문구 수정-->
            <%-- <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0046" /><!-- 주택마련저축소득공제(청약저축,주택청약종합저축) --></td> --%>
            <td  colspan="3"  class="align_left">주택마련저축소득공제(청약저축,주택청약종합저축,근로자주택마련저축)</td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._특별공제_주택마련저축소득공제 == 0)?"":(WebUtil.printNumFormat(data._특별공제_주택마련저축소득공제,0)+" 원")%>&nbsp;
	    </td>
<%		}
	}
%>
			<td  class="lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0047" /><!-- 납입액×40%(임차차입원리금상환액 포함 300만원한도) --></td>
          </tr>

          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0048" /><!-- 투자조합출자 소득공제 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._투자조합출자등소득공제 ==0)?""    :(WebUtil.printNumFormat(data._투자조합출자등소득공제 ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left"></td>
          </tr>

<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------신용카드 시작-------------------------------------------------------- -->

		<tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0049" /><!-- 신용카드 등 소득공제 -->
<%    if ( overseaYN.equals("Y") ){ %>
          :  <font color=red><spring:message code="LABEL.D.D14.0050" /><!-- 국내근무자 총소득 동일 구간별 평균 공제액 반영 --></font>
<%    }%>
            </td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._신용카드공제          ==0)?""    :(WebUtil.printNumFormat(data._신용카드공제           ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
			<!-- @2015 연말정산<a href="javascript:cardInfo();"><font color=red><b>&nbsp;공제기준 상세내역</b></font></a> -->
			&nbsp;<spring:message code="LABEL.D.D14.0051" /><!-- 총급여 25% 초과 시 소득공제 가능 -->
<%} %>
			</td>
          </tr>

<!-- ------------------------------------------------신용카드 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->


          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0052" /><!-- 장기집합투자증권저축 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>

            <td  class="align_right">
<%=(data._그밖의_장기집합투자증권저축       ==0)?""    :(WebUtil.printNumFormat(data._그밖의_장기집합투자증권저축       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0053" /><!-- 납입액×40%(240만원한도) 단, 총급여 8,000만원 이하 --></td>
          </tr>


          <!--CSR ID:C20140106_63914  특별공제 종합한도 초과액  -->
          <tr class="borderRow">
            <td  colspan="4"><spring:message code="LABEL.D.D14.0054" /><!-- 종합한도 초과액 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._특별공제_종합한도_초과액       ==0)?""    :(WebUtil.printNumFormat(data._특별공제_종합한도_초과액       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left"></td>
          </tr>


<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------종합소득 과세표준 시작-------------------------------------------------------- -->

          <tr class="borderRow">
            <td class="xtd03" colspan="4"><spring:message code="LABEL.D.D14.0055" /><!-- 종합소득 과세표준 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="xtr01 align_right">
<%=(data._종합소득과세표준       ==0)?""    :(WebUtil.printNumFormat(data._종합소득과세표준       ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01 lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0056" /><!-- 근로소득금액－기본－추가－연금－특별－그밖의소득공제 --></td>
          </tr>
          <tr class="borderRow">
            <td class="xtd03" colspan="4"><spring:message code="LABEL.D.D14.0057" /><!-- 산출세액 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td class="xtr01 align_right">
<%=(data._산출세액               ==0)?""    :(WebUtil.printNumFormat(data._산출세액               ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01 lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0058" /><!-- 과세표준×세율－누진공제율 --></td>
          </tr>

<!-- ------------------------------------------------종합소득 과세표준 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->



          <tr class="borderRow">

			<td  rowspan="14"><spring:message code="LABEL.D.D14.0059" /><!-- 세액공제 --></td>

<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------근로소득 시작-------------------------------------------------------- -->

            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0060" /><!-- 근로소득 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_근로소득     ==0)?""    :(WebUtil.printNumFormat(data._세액공제_근로소득      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left">&nbsp;</td>
          </tr>

<!-- ------------------------------------------------근로소득 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->

<!-- ------------------------------------------------자녀 시작-------------------------------------------------------- -->

          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0061" /><!-- 자녀 --></td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_자녀      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_자녀      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td  class="lastCol align_left">&nbsp;<!-- 자녀2명까지:1명당 15만원<br>&nbsp;자녀3명이상:30만원＋(자녀수－2)×20만원 --></td>
          </tr>

<!-- ------------------------------------------------자녀 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->
          <!-- @2014 연말정산 재정산 추가 항목 2건 -->
<!-- ------------------------------------------------추가 항목 2건 시작-------------------------------------------------------- -->
<%//if(notChgP.equals("Y")){ %>

           <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0062" /><!-- 6세 이하 자녀 2명이상 --></td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._추가공제_자녀양육비      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_자녀양육비      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           	<td  class="lastCol align_left"></td>
          </tr>
                     <tr class="borderRow">
            <!-- [CSR ID:3598202] 2017 연말정산 내역조회 문구수정 -->
            <%-- <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0063" /><!-- 출산 및 입양공제 --></td> --%>
            <td  colspan="3"  class="align_left">'17.1.1 이후 출생/입양한 기본공제대상 자녀</td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._추가공제_출산입양      ==0)?""    :(WebUtil.printNumFormat(data._추가공제_출산입양      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<!-- [CSR ID:3598202] 2017 연말정산 내역조회 문구수정 -->
           	<td  class="lastCol align_left">&nbsp;(자녀 1명당 30만원 : 첫째 30만원, 둘째 50만원, 셋째 이상 70만원)</td>
          </tr>
<%//} %>
<!-- ------------------------------------------------추가 항목 2건 끝-------------------------------------------------------- -->

           <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0064" /><!-- 과학기술인공제 및 퇴직연금소득공제 --></td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_퇴직연금소득공제      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_퇴직연금소득공제      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           	<td  class="lastCol align_left"></td>
          </tr>


<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------연금저축소득공제 시작-------------------------------------------------------- -->

           <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0065" /><!-- 연금저축소득공제 --></td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_연금저축소득공제      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_연금저축소득공제      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td  class="lastCol align_left">&nbsp;<!--납입액(400만원한도)×12%--></td>
          </tr>

<!-- ------------------------------------------------연금저축소득공제 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->

<!-- ------------------------------------------------보장성보험료 시작-------------------------------------------------------- -->

           <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0066" /><!-- 보장성보험료 --></td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_보장성보험료      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_보장성보험료      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td  class="lastCol align_left">&nbsp;<!-- 납입액(100만원한도)×12% --></td>
          </tr>

<!-- ------------------------------------------------보장성보험료 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->


           <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D11.0033" /><!-- 의료비 -->
<%    if ( overseaYN.equals("Y") ){ %><!-- @2014 연말정산 해외대상 추가 -->
          :  <font color=red><spring:message code="LABEL.D.D14.0050" /><!-- 국내근무자 총소득 동일 구간별 평균 공제액 반영 --></font>
<%    }%>
            </td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_의료비      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_의료비      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td  class="lastCol align_left">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
           <!-- @2015 연말정산 &nbsp;(근로소득3%초과된 의료비(700만원한도)＋추가공제)×15% -->
           <spring:message code="LABEL.D.D14.0067" /><!-- (총급여 3%초과된 의료비(700만원한도)＋추가공제)×15% -->
<%} %>
           </td>
          </tr>
           <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D11.0034" /><!-- 교육비 -->
<%    if ( overseaYN.equals("Y") ){ %><!-- @2014 연말정산 해외대상 추가 -->
          :  <font color=red><spring:message code="LABEL.D.D14.0050" /><!-- 국내근무자 총소득 동일 구간별 평균 공제액 반영 --></font>
<%    }%>
            </td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_교육비      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_교육비      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td  class="lastCol align_left">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
           &nbsp;<spring:message code="LABEL.D.D14.0068" /><!-- 교육비납입액(학력한도)×15% -->
<%} %>
           </td>
          </tr>
           <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D11.0036" /><!-- 기부금 -->
<%    if ( overseaYN.equals("Y") ){ %><!-- @2014 연말정산 해외대상 추가 -->
          :  <font color=red><spring:message code="LABEL.D.D14.0050" /><!-- 국내근무자 총소득 동일 구간별 평균 공제액 반영 --></font>
<%    }%>
            </td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_기부금      ==0)?""    :(WebUtil.printNumFormat(data._세액공제_기부금      ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td  class="lastCol align_left">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
           &nbsp;<spring:message code="LABEL.D.D14.0069" /><!-- 공제금액×15%(2,000만원 초과분은 30%,’16년부터 기부한 법정·우리사주·지정기부금限) -->
<%} %>
           </td>
          </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0070" /><!-- 정치기부금 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_정치기부금==0)?""    :(WebUtil.printNumFormat(data._세액공제_정치기부금,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left">
<%    if ( !overseaYN.equals("Y") ){ %><!-- @2014 연말정산 국내인원만 조회되도록 -->
			&nbsp;<spring:message code="LABEL.D.D14.0071" /><!-- 10만원이하:100/110 --><br>
&nbsp;<spring:message code="LABEL.D.D14.0072" /><!-- 10만원초과:10만원초과액×15%(3,000만원 초과분 25%) -->
<%} %>
</td>
          </tr>
          <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0073" /><!-- 주택차입금 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_주택차입금    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_주택차입금    ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td  class="lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0074" /><!-- 이자상환액×30% --></td>
          </tr>

<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------표준세액공제 시작-------------------------------------------------------- -->

<tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0075" /><!-- 표준세액공제 --></td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_표준세액공제    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_표준세액공제  ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td  class="lastCol align_left">
           &nbsp;<!-- 특별공제 및 세액공제가 "0"원일 때 12만원 공제<br>&nbsp;(단, 근로소득. 자녀공제 제외) -->
           </td>
          </tr>


<!-- ------------------------------------------------표준세액공제 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->

           <tr class="borderRow">
            <td  colspan="3"  class="align_left"><spring:message code="LABEL.D.D14.0076" /><!-- 월세액 --></td>

<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
            <td  class="align_right">
<%=(data._세액공제_월세액    ==0)?""    :(WebUtil.printNumFormat(data._세액공제_월세액    ,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
           <td  class="lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0077" /><!-- 월세액(750만원한도)×10% 단, 총급여 7,000만원 이하 --></td>
          </tr>

<!-- [CSR ID:3608233] 행추가하여 결정세액(갑근세) display 추가건_연말정산 내역조회 화면 수정요청의 건 start -->
<!-- ------------------------------------------------결정세액(산출세액-세액공제) 시작 ------------------------------------------------------ -->
<tr class="borderRow2">
            <td class="xtd03" colspan="4"><spring:message code="LABEL.D.D14.0082" /><!-- 결정세액 --></td>
<%      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
%>
			<td class="xtr01 align_right">
<%=(data._결정세액_갑근세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_갑근세,0)+" 원")%>&nbsp;
            </td>
<%		}
	}
%>
			<td class="xtd01 lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0083" /><!-- 산출세액 - 세액공제 --></td>
          </tr>
<!-- ------------------------------------------------결정세액(산출세액-세액공제) 끝-------------------------------------------------------- -->
<!-- [CSR ID:3608233] 행추가하여 결정세액(갑근세) display 추가건_연말정산 내역조회 화면 수정요청의 건 end -->

          <tr class="borderRow">
          	<td ></td>
            <td  width=10%><spring:message code="LABEL.D.D14.0078" /><!-- 갑근세 --></td>
            <td  width=10%><spring:message code="LABEL.D.D14.0079" /><!-- 주민세 --></td>
            <td  width=10%><spring:message code="LABEL.D.D14.0080" /><!-- 농특세 --></td>
            <td  colspan=<%=ROW%> width=10%><spring:message code="LABEL.D.D14.0081" /><!-- 계 --></td>
            <!-- [CSR ID:3608233] 연말정산 내역조회 화면 수정요청의 건_비고란 삭제요청 주석처리 -->
            <td class="lastCol align_left">&nbsp; <!-- 근로소득금액－기본－추가－연금－특별－그밖의소득공제 -->

            </td>
          </tr>

<%
      for ( int j = 0 ;j < D14TaxAdjustData_vt.size() ; j++ ) {
      	      D14TaxAdjustData data = ( D14TaxAdjustData ) D14TaxAdjustData_vt.get( j ) ;
      	      if (data.Count>0) {
    double _전근무지기납부세액합계 = data._전근무지_납부소득세 + data._전근무지_납부주민세 +  data._전근무지_납부특별세;

%>

<!-- @2014 연말정산 해당 항목 삭제
< %	if (!titleText[j].equals("국내")){%>
	  <tr class="borderRow"><td  colspan=< %=ROW+4%>><b>< %=titleText[j]%><b></td></tr>
< %	} %>	  -->
<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------결정세액 시작-------------------------------------------------------- -->

          <tr class="borderRow">
            <td class="xtd01"><spring:message code="LABEL.D.D14.0082" /><!-- 결정세액 --></td>
            <td class="xtr01 align_right">
<%=(data._결정세액_갑근세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_갑근세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01 align_right">
<%=(data._결정세액_주민세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_주민세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01 align_right">
<%=(data._결정세액_농특세        ==0)?""    :(WebUtil.printNumFormat(  data._결정세액_농특세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01 align_right"  colspan=<%=ROW%>>
<%=(data._결정세액합계           ==0)?""    :(WebUtil.printNumFormat( data._결정세액합계 ,0)+" 원")%>&nbsp;
            </td>
            <!-- [CSR ID:3608233] 연말정산 내역조회 화면 수정요청의 건_비고란 삭제요청 주석처리 -->
            <td class="xtd01 lastCol align_left" >&nbsp;<%-- <spring:message code="LABEL.D.D14.0083" /> --%><!-- 산출세액－세액공제 --></td>
          </tr>

<!-- ------------------------------------------------결정세액 끝-------------------------------------------------------- -->
          <!-- [CSR ID:2778743] 금액은 일단 위와 동일하게 나오도록 default 세팅 종료-->


          <tr class="borderRow">
            <td ><spring:message code="LABEL.D.D14.0084" /><!-- 기납부세액(전) --></td>
            <td  class="align_right">
<%=(data._전근무지_납부소득세      ==0)?""    :(WebUtil.printNumFormat(data._전근무지_납부소득세      ,0)+" 원")%>&nbsp;
            </td>
            <td  class="align_right">
<%=(data._전근무지_납부주민세      ==0)?""    :(WebUtil.printNumFormat(data._전근무지_납부주민세      ,0)+" 원")%>&nbsp;
            </td>
            <td  class="align_right">&nbsp;
<%=(data._전근무지_납부특별세      ==0)?""    :(WebUtil.printNumFormat(data._전근무지_납부특별세      ,0)+" 원")%>
            </td>
            <td  class="align_right" colspan=<%=ROW%>>
<%=( _전근무지기납부세액합계         ==0)?""    :(WebUtil.printNumFormat( _전근무지기납부세액합계  ,0)+" 원")%>&nbsp;
            </td>
            <td  class="lastCol align_left"></td>
          </tr>

<%
    double _기납부세액_갑근세1 = data._기납부세액_갑근세 - data._전근무지_납부소득세 ;
    double _기납부세액_주민세1 = data._기납부세액_주민세 - data._전근무지_납부주민세 ;
    double _기납부세액_농특세1 = data._기납부세액_농특세 - data._전근무지_납부특별세 ;
    double _기납부세액합계1 = _기납부세액_갑근세1+_기납부세액_주민세1+_기납부세액_농특세1 ;
%>
          <tr class="borderRow">
            <td ><spring:message code="LABEL.D.D14.0085" /><!-- 기납부세액(현) --></td>
            <td  class="align_right">
<%=(_기납부세액_갑근세1      ==0)?""    :(WebUtil.printNumFormat(_기납부세액_갑근세1      ,0)+" 원")%>&nbsp;
            </td>
            <td  class="align_right">
<%=(_기납부세액_주민세1      ==0)?""    :(WebUtil.printNumFormat(_기납부세액_주민세1      ,0)+" 원")%>&nbsp;
            </td>
            <td  class="align_right">
<%=(_기납부세액_농특세1      ==0)?""    :(WebUtil.printNumFormat(_기납부세액_농특세1      ,0)+" 원")%>&nbsp;
            </td>
            <td  class="align_right" colspan=<%=ROW%>>
<%=(_기납부세액합계1         ==0)?""    :(WebUtil.printNumFormat(_기납부세액합계1         ,0)+" 원")%>&nbsp;
            </td>
            <td  class="lastCol align_left"></td>
          </tr>

<!-- [CSR ID:2778743] -->
<!-- ------------------------------------------------차감징수세액 시작-------------------------------------------------------- -->

          <tr class="borderRow">
            <td class="xtd01"><spring:message code="LABEL.D.D14.0086" /><!-- 차감징수세액 --></td><!-- 원단위 절사 -->
            <td class="xtr01 align_right">
<%=(data._차감징수세액_갑근세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_갑근세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01 align_right">
<%=(data._차감징수세액_주민세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_주민세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01 align_right">
<%=(data._차감징수세액_농특세    ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액_농특세,0)+" 원")%>&nbsp;
            </td>
            <td class="xtr01 align_right" colspan=<%=ROW%>>
<%=(data._차감징수세액합계       ==0)?""    :(WebUtil.printNumFormat( data._차감징수세액합계,0)+" 원")%>&nbsp;
            </td>
            <td class="xtd01 lastCol align_left">&nbsp;<spring:message code="LABEL.D.D14.0087" /><!-- 결정세액－기납부세액(전/현)<br>&nbsp;(+) 금액은 추가납부, (-) 금액은 환급대상임 --></td><!-- [CSR ID:2703097] 연말정산내역 조회의 문구 추가 요청  -->
          </tr>

<!-- ------------------------------------------------차감징수세액 끝-------------------------------------------------------- -->

<%		}
	}
%>


        </table>


    <!--연말정산 내역 테이블 끝-->
<%
    }//해외사번 잠시 안보이도록 막음. // [CSR ID:3598202] 2017 연말정산  국내/해외 사번 구분없이 오픈
%>

<!-------------T A B L E -- E N D--------------------------------------------------------------------------------------------->
</div></div>
  <input type="hidden" name="selectYear"       value="">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

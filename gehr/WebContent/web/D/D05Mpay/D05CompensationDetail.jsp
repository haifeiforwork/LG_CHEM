<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 월급여                                                      */
/*   Program Name : 총 보상명세서                                                     */
/*   Program ID   : D05CompensationDetail.jsp                                   */
/*   Description  : 개인의 Total Compensation 명세서 조회                       */
/*   Note         :                                                             */
/*   Creation     : 2012-07-30  LSA                                           */
/*   Update       : 2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)                                                            */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<jsp:include page="/web/common/includeLocation.jsp" />
<%
    WebUserData user = WebUtil.getSessionUser(request);
    WebUserData user_m = WebUtil.getSessionMSSUser(request);

    String year      = ( String ) request.getParameter("year1");
    String month     = ( String ) request.getParameter("month1");
    String type = (String) request.getParameter("type");

    //총보상명세내역
    String begym  = year + "01" ;
    String endym  = year + month ;
    D05CompensationRFC   rfc                = new D05CompensationRFC();
    String searchEmpNo = "";
    String searchOrgtx = "";//부서
    String searchEname = "";

    if(type.equals("I")){
        searchEmpNo = user.empNo;
        searchOrgtx = user.e_orgtx;
        searchEname = user.ename;
    }else if(type.equals("Y") && user_m != null){
        searchEmpNo = user_m.empNo;
        searchOrgtx = user_m.e_orgtx;
        searchEname = user_m.ename;
    }else{
        searchEmpNo = "";
        searchOrgtx = "";//부서
        searchEname = "";
    }

    D05CompensationData d05CompensationData = (D05CompensationData)rfc.getDetail(searchEmpNo, begym, endym);

%>


<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->

<script language="JavaScript">
<!--
//내용만 이동
function doLink(gubn, menuCode, upMenuCode, realPath, mPath) {
    if("<%=type%>"=="I"){
       document.form1.action = realPath+"&RequestPageName=D05CompensationDetail";
    }else if("<%=type%>"=="Y"){
        document.form1.action = mPath+"&RequestPageName=D05CompensationDetail";
    }

    if(gubn=="E09House"){
        document.form1.action = document.form1.action+"&year=<%=year%>&month=<%=month%>";
    }
       document.form1.submit();
}


    //선택적복리후생
    function Js_Employee() {
        return;
    var url = "http://lgchem.ezwel.com/login/login_employee_lgchem.php?jikno=" + post_encrypt("<%= searchEmpNo %>", "lgchem") +"&gourl=/cuser/mypage/point/myPointViewEtc.ez";
    var win= window.open(url,'employee','width=1024,height=768,status=yes,toolbar=yes,menubar=yes,location=no,scrollbars=yes,resizable=yes');
    }

    function post_encrypt(clearText,keyText) {
        //post_encrypt(입력값,비밀키)

        cLength = clearText.length;       // 4의 배수의 평문의 길이

        <!-- =================================================== -->
        <!-- ==== 아래는 비밀키 처리입니다. ============== -->
        <!-- =================================================== -->
        var cKey10 = new Array(keyText.length); // 비밀키(10진숫자)의 길이만큼 방 만들기
        var cKey2 = new Array(keyText.length);  // 비밀키(2진숫자)의 길이만큼 방 만들기
        var cKey2all = "";                      // 모든 비밀키(2진숫자) 방 만들기
        var cKeyList = "";                      // 각 비밀키 변환(2진숫자)

        for (t=0; t<keyText.length; t++) { // 문자추출 = 아스키코드 = 2진수
            cKey10[t] = keyText.charCodeAt(t); // keyText의 문자를 10진수로 바꾸기(평문사용시)
            cKey2[t] = cKey10[t].toString(2);   // keyText의 문자를 2진수로 바꾸기
            cKey2all += cKey2[t];               // 모든 keyText(2진수)
        }

        var cKeyLength = cKey2all.length; // 2진수 비밀키의 길이

        <!-- =================================================== -->
        <!-- =================================================== -->
        var cText10 = new Array(cLength); //  평문(10진숫자)의 길이만큼 방 만들기
        var cText2 = new Array(cLength);  //  평문(2진숫자)의 길이만큼 방 만들기

        var cTextTemp = new Array(64);  // 4자리씩 나눈 몫만큼 방 만들기

        <!-- =================================================== -->
        <!-- =================================================== -->
        <!-- ==== 아래는 문자 블록(M_i)별 처리입니다. ============== -->
        <!-- =================================================== -->
        <!-- =================================================== -->
        var cTextAll = "";  // 모든 2진 변환

        for (var i=0;i<cLength;i++) {
            cText10[i] = clearText.charCodeAt(i); // clearText의 문자를 10진수로 바꾸기(평문사용시)
            cText2[i] = cText10[i].toString(2);   // clearText의 문자를 2진수로 바꾸기

            while (cText2[i].length%16 != 0) {
                cText2[i] = "0"+cText2[i]
            };  // 2진 평문의 길이를 16의 배수자리(문자형이 됨)로 만들기.

            <!-- ======== 문장으로 입력하기 끝 ======================== -->
            <!-- =================================================== -->

            var cBinaryTemp = cText2[i];  // 64비트 임시 파일

            <!-- =================================================== -->
            <!-- =================================================== -->
            <!-- ==== 아래는 암호문 만들기입니다. ============== -->
            <!-- =================================================== -->
            <!-- =================================================== -->

            cTextAll += cBinaryTemp;         // 모든 2진 변환 평문
        }
        //document.write("모든 평문키 = "+cTextAll+"<p>")
        //document.write("평문 길이 = "+cTextAll.length+"<p>")

        var cTextAllLength =cTextAll.length;   // 모든 2진 변환 평문길이
        var cAllQuot = Math.floor(cTextAll.length/cKeyLength);     // 비밀키의 길이로 나눈 몫
        var cAllCyper =new Array(cAllQuot);  // 비밀키자리씩 나눈 몫만큼 방 만들기
        var roundDisplay ="";  // 중간과정 나타내기

        for (j=0;j<cAllQuot;j++){ // 평문과 비밀키 더하기
            for (k=0;k<cKeyLength;k++){
                cAllCyper[j*cKeyLength+k] = cTextAll.substring(j*cKeyLength+k,j*cKeyLength+k+1)^cKey2all.substring(k,k+1);
               // 2진 평문과 비밀키 더하기
            }
        };

        var rest= 0; // 2진수 평문이 암호키의 길이의 배수가 아닐 때 처리
        if (cTextAllLength%cKeyLength != 0){
            rest= cTextAllLength-cAllQuot*cKeyLength;

            for (j=0;j<rest;j++){ // 평문과 비밀키 더하기
                cAllCyper[cAllQuot*cKeyLength+j] = cTextAll.substring(cAllQuot*cKeyLength+j,cAllQuot*cKeyLength+j+1)^cKey2all.substring(j,j+1);
                // 2진 평문과 비밀키 더하기
            };
        };

        <!-- =================================================== -->
        <!-- ======== 아래는  구간 16진수 암호문입니다.=================== -->
        <!-- =================================================== -->

        var CyperText3 = "";  // 각 단계 최종암호문(16진수)
        var CyperText4 = "";  // 각 단계 최종암호문(16진수)

        for (jj=0;jj<Math.floor(cTextAllLength/8);jj++){
            // 암호문장으로 변환 ===> 문장으로 하면 실행이 이상해질 수 있음

            CyperText4=parseInt(cAllCyper.join("").substring(jj*8,jj*8+8),2).toString(16); // 16진수로 만들기

            if (CyperText4.length == 1){CyperText4 ="0"+CyperText4};               // 16진수 2자리수로 만들기
            CyperText3 += CyperText4;                                              // 전체 암호문(16진수)
        };
        // 전체 16진수 암호문
        return CyperText3;
    }

 // [CSR ID:2995203]@v1.4 연급여 링크
    function doPayment() {

        date1 = new Date();
        n_month = date1.getMonth()+1;

        document.form2.jobid.value  = "search";
        document.form2.from_year1.value  = "<%=year%>";
        document.form2.from_month1.value = "01";   // 시작월은 항상 01월로 한다.
        document.form2.to_year1.value  = "<%=year%>";
        if(n_month < 10) {
            document.form2.to_month1.value = "0"+n_month;  // 현재월까지를 보낸다.
        }else{
            document.form2.to_month1.value = n_month;  // 현재월까지를 보낸다.
        }
        if("<%=type%>"=="I"){
            document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayKoreaSV?RequestPageName=D05CompensationDetail";
        }else if ("<%=type%>"=="Y"){
            document.form2.action = "<%= WebUtil.ServletURL %>hris.D.D06Ypay.D06YpayKoreaSV_m?RequestPageName=D05CompensationDetail";
        }
        document.form2.method = "post";
        blockFrame();
        document.form2.submit();
    }
//-->
</script>

<style type="text/css">
  .tds2 {  font-size: 7pt;background-color: #FFFFFF; text-align: right; color: #585858; padding-top: 0px; padding-left: 5px; height:12px; vertical-align: middle;}
  .subWrapper{width:950px;}
</style>

<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D05.0103"/>
    <jsp:param name="help" value="D05Mpay.html"/>
</jsp:include>

<form name="form1" method="post">

    <!-- 상단 검색테이블 시작-->
    <div class="tableArea" >
        <div class="table">
            <table class="tableGeneral">

            	<colgroup>
            		<col width="13%" />
            		<col width="20%" />
            		<col width="13%" />
            		<col width="20%" />
            		<col width="13%" />
            		<col />
            	</colgroup>
            	<thead>
                <tr>
                    <th><spring:message code="LABEL.D.D05.0002"/></th><!--해당년월  -->
                    <td colspan="4">
                        <%=year%>
                        <spring:message code="LABEL.D.D15.0020"/> <%=month%>
                        <spring:message code="LABEL.D.D15.0021"/>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <th><spring:message code="LABEL.D.D05.0004"/></th><!-- 부서명 -->
                    <td><%= searchOrgtx %></td>
                    <th class="th02"><spring:message code="LABEL.D.D05.0005"/></th><!--사 번  -->
                    <td><%= searchEmpNo %></td>
                    <th class="th02"><spring:message code="LABEL.D.D05.0006"/></th><!-- 성 명 -->
                    <td><%= searchEname %></td>
                </tr>
                </thead>
            </table>
        </div>
    </div>
    <!-- 상단 검색테이블 끝-->


<%
        double ytot = 0;//연급여계

        if ( d05CompensationData  != null ) {
            ytot    = Double.parseDouble(d05CompensationData.BET01) +Double.parseDouble(d05CompensationData.BET19);
%>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
                <colgroup>
                    <col width="20%" />
                    <col width="20%" />
                    <col width="30%" />
                    <col width="30%" />
                </colgroup>
                <thead>
                <tr>
                    <th class="divide" colspan="2"><spring:message code="LABEL.D.D12.0032" /></th><!-- 구분 -->
                    <th><spring:message code="LABEL.D.D05.0104" /></th><!-- 지원항목 -->
                    <th class="lastCol align_right"><spring:message code="LABEL.D.D05.0105" /></th><!-- 회사지원액 -->
                </tr>
                <tr class="oddRow">
                    <td class="divide" rowspan="3" colspan="2" style="background:#fff;">
                    	<a href="javascript:doPayment();"><span class="textPink">
                    	<spring:message code="LABEL.D.D05.0088" /><!-- 연급여--></span></a></td>
                    <td><spring:message code="LABEL.D.D06.0022" /></td><!-- 급여 -->
                    <td class="lastCol align_right"><%= WebUtil.printNumFormat(Double.parseDouble(d05CompensationData.BET01)*100,0) %></td>
                </tr>
                <tr>
                    <td><spring:message code="LABEL.D.D06.0023" /></td><!-- 상여 -->
                    <td class="lastCol align_right"><%= WebUtil.printNumFormat(Double.parseDouble(d05CompensationData.BET19)*100,0) %></td>
                </tr>
                <tr class="sumRow">
                    <td><spring:message code="LABEL.D.D05.0106" /></td><!--  연급여 계-->
                    <td class="lastCol align_right"><%= WebUtil.printNumFormat(ytot*100,0) %></td>
                </tr>
                </thead>
            </table>
        </div>
    </div>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
                <colgroup>
                    <col width="20%" />
                    <col width="20%" />
                    <col width="30%" />
                    <col width="30%" />
                </colgroup>
                <thead>
                <tr class="oddRow borderRow">
                    <td rowspan="17" style="background:#fff; border-bottom:1px solid #ddd;"><spring:message code="LABEL.D.D05.0107" /></td><!-- 복리후생<br>회사지원액<br>(연간누계) -->
                    <td rowspan="5"  class="divide" style="background:#fff"><spring:message code="LABEL.D.D05.0108" /></td><!-- 법정<br>복리후생 -->
                    <td><spring:message code="LABEL.D.D05.0109" /></td><!--건강보험료  -->
                    <td class="lastCol align_right align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET03)*100,0) %></td>
                </tr>
                <tr class="borderRow">
                    <td><spring:message code="LABEL.D.D05.0110" /></td><!-- 고용보험료 -->
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET04)*100,0) %></td>
                </tr>
                <tr class="oddRow borderRow">
                    <td><!-- <a href="javascript:doLink('E29PensionDetail','1115','1092','/servlet/servlet.hris.E.E29PensionDetail.E29PensionListSV');"><font color="#CC3300" weight="900"> -->
                        <spring:message code="LABEL.D.D05.0018" /><!-- 국민연금 -->
                    <!-- </a> -->
                    </td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET05)*100,0) %></td>
                </tr>
                <tr class="borderRow">
                    <td><spring:message code="LABEL.D.D05.0111" /><!-- 산재보험료 --></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET06)*100,0) %></td>
                </tr>
                <tr class="oddRow sumRow borderRow">
                    <td><spring:message code="LABEL.D.D15.0170" /><!--  소계--></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET07)*100,0) %></td>
                </tr>

                <tr class="borderRow">
                    <td class="divide" rowspan="10" style="border-bottom:1px solid #bbb;"><spring:message code="LABEL.D.D05.0112" /><!-- 법정外<br>복리후생 --></td>
                    <td><a href="javascript:doLink('E20Congra','1112','1092','/servlet/servlet.hris.E.E19Congra.E19CongraFrameSV?tabid=tab_3',
                    	'/servlet/servlet.hris.E.E00BenefitFrameSV?tabid=tab_3');"><span class="textPink">경조금</span></a></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET08)*100,0) %></td>
                </tr>
                <tr class="oddRow borderRow">
                    <td><a href="javascript:doLink('E18Hospital','1111','1092','/servlet/servlet.hris.E.E18Hospital.E18HospitalFrameSV?tabid=tab_2' ,
                    	'/servlet/servlet.hris.E.E00BenefitFrameSV?tabid=tab_2');"><span class="textPink">의료비</span></a></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET09)*100,0) %></td>
                </tr>
                <tr class="borderRow">
                    <td><a href="javascript:doLink('E22Expense','1113','1092','/servlet/servlet.hris.E.E22Expense.E22ExpenseFrameSV?tabid=tab_4',
                    	'/servlet/servlet.hris.E.E00BenefitFrameSV?tabid=tab_4');"><span class="textPink">장학자금</span></a></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET10)*100,0) %></td>
                </tr>
                <tr class="oddRow borderRow">
                    <td><a href="javascript:doLink('A06Prize','1083','1006','/servlet/servlet.hris.N.essperson.A01SelfDetailNeoSV?tabid=tab_6',
                    	'/servlet/servlet.hris.N.mssperson.A01SelfDetailNeoSV_m?tabid=tab_3');"><span class="textPink">포상비</span></a></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET12)*100,0) %></td>
                </tr>
                <tr class=borderRow>
                    <td><a href="javascript:doLink('A06Prize','1083','1006','/servlet/servlet.hris.N.essperson.A01SelfDetailNeoSV?tabid=tab_6',
                    	'/servlet/servlet.hris.N.mssperson.A01SelfDetailNeoSV_m?tabid=tab_3');"><span class="textPink">장기근속상</span></a></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET15)*100,0) %></td>
                </tr>
                <tr class="oddRow borderRow">
                    <td><a href="javascript:doLink('E28General','1117','1092','/servlet/servlet.hris.E.E28General.E28GeneralFrameSV?tabid=tab_7',
                    	'/servlet/servlet.hris.E.E00BenefitFrameSV?tabid=tab_7');"><span class="textPink">종합검진</span></a></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET17)*100,0) %></td>
                </tr>
                <tr class="borderRow">
                    <td><a href="javascript:doLink('E09House','1110','1092','/servlet/servlet.hris.E.E09House.E09HouseFrameSV?tabid=tab_1',
                    	'/servlet/servlet.hris.E.E00BenefitFrameSV?tabid=tab_1');"><span class="textPink">주택자금 이자지원</span></a></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET14)*100,0) %></td>
                </tr>
                <tr class="oddRow borderRow">
                    <td><spring:message code="LABEL.D.D05.0113" /><!-- 선택적복리후생포인트 <sup>주1)</sup> --></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET13)*100,0) %></td>
                </tr>
                <tr class="borderRow">
                    <td><spring:message code="LABEL.D.D05.0114" /><!-- 단체정기보험--></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET18)*100,0) %></td>
                </tr>
                <tr class="oddRow">
                    <td><spring:message code="LABEL.D.D15.0170" /><!--  소계--></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET16)*100,0) %></td>
                </tr>
                <tr class="sumRow">
                    <td colspan=2><spring:message code="LABEL.D.D05.0089" /><!--  복리후생 계--></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormatBlank(Double.parseDouble(d05CompensationData.BET02)*100,0) %></td>
                </tr>
                </thead>
            </table>
        </div>
    </div>

    <div class="listArea">
        <div class="table">
            <table class="mpayTable">
            <thead>
                <tr class="oddRow">
                    <code><td  width="70%" colspan="3"><spring:message code="LABEL.D.D05.0092" /><!--  Total <sup>주2)</sup>--></td></code>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormat((ytot+Double.parseDouble(d05CompensationData.BET02))*100,0)%></td>
                </tr>
                </thead>
            </table>
        </div>

<%  } %>

    <div class="commentsMoreThan2">
        <div>
            <code>
                <spring:message code="LABEL.D.D05.0115" /><!-- <sup>주1)</sup> 선택적복리후생포인트 : 전월 사용실적까지 반영된 기준으로 현재 사용금액과 차이가 발생할 수 있습니다.-->
            </code>
        </div>
        <div>
            <code>
                <spring:message code="LABEL.D.D05.0116" /><!-- <sup>주2)</sup> 연간 회사 지원 누계액 기준이며, 자세한 내역은 해당 항목을 클릭하여 조회하시기 바랍니다.-->
            </code>
        </div>
    </div>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back()"><span><spring:message code="BUTTON.COMMON.BACK" /></span></a></li>
        </ul>
    </div>

    </div>

    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="year1" value="">
    <input type="hidden" name="RequestPageName"   value="D05CompensationDetail">
</form>
  <form name="form2" method="post" action="">
        <!--  [CSR ID:2995203]@v1.4 보상명세서 항목추가 -->
    <input type="hidden" name="from_year1" value="">
    <input type="hidden" name="from_month1" value="">
    <input type="hidden" name="to_year1" value="">
    <input type="hidden" name="to_month1" value="">
    <input type="hidden" name="jobid" value="search">
  </form>
<form name="tssform" method="post">
<input type="hidden" name="menuCount" value="">
<input type="hidden" name="docCount" value="">

</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
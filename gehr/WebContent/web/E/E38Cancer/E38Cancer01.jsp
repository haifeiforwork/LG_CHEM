<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 추가암검진(7대암검진)                                                */
/*   Program Name : 추가암검진(7대암검진)                                                */
/*   Program ID   : E38Cancer01.jsp                                            */
/*   Description  : 추가암검진(7대암검진) 상세일정을 조회                                    */
/*   Note         :                                                             */
/*   Creation     : 2013-06-21  lsa  C20130620_53407                 */
/*   Update       :                                                             */
/*   Update       : 2014-01-23  lsa  파주공장 검진항목추가   csr_9999  */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/*               2015-05-08  이지은D  [CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정요청   */
/*                  2016-01-23 rdcamel [CSR ID:2967911] HR portal 종합검진 신청화면 수정 요청의 건 */
/*                  2017-09-21 eunhal [CSR ID:3489341] 2017년 암검진 실시 */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="hris.E.E38Cancer.*" %>
<%@ page import="hris.E.E38Cancer.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    String PERNR = (String)request.getAttribute("PERNR");

    E38CancerDayData e38CancerDayData = new E38CancerDayData();

    E38CancerGetDayRFC func = new E38CancerGetDayRFC();
    Vector ret = func.getMedicday(PERNR);
    Vector ret_DamDang = func.getMedicday(user.empNo);
    e38CancerDayData = (E38CancerDayData)ret.get(0); //사업장별 일정
    String E_HEALTH  = (String)ret_DamDang.get(1); //담당자여부

    String GRUP_NUMB    = e38CancerDayData.GRUP_NUMB    ;  //사업장
    String GRUP_NAME    = e38CancerDayData.GRUP_NAME    ;  //사업장명
    String DATE_FROM    = DataUtil.delDateGubn(e38CancerDayData.DATE_FROM)+"09";  //신청기간 FROM
    String DATE_TO  = DataUtil.delDateGubn(e38CancerDayData.DATE_TO)+"24"  ;  //신청기간 TO
    String BEFORE_MSG   = e38CancerDayData.BEFORE_MSG   ;  //신청기간 전 MESSAGE
    String AFTER_MSG    = e38CancerDayData.AFTER_MSG    ;  //신청기간 후 MESSAGE
    String alertMSG = ""    ;  //MESSAGE

    Date toDay = new Date();
    java.text.SimpleDateFormat sdf1 = new java.text.SimpleDateFormat("yyyyMMddkk"); //시간
    String CurrYMDK = sdf1.format(toDay);

    if (GRUP_NUMB !=null ){
        if (  Long.parseLong(CurrYMDK) <= Long.parseLong(DATE_TO) && Long.parseLong(CurrYMDK) >=  Long.parseLong(DATE_FROM) ) {
             alertMSG = "";
        } else if (  Long.parseLong(CurrYMDK) < Long.parseLong(DATE_FROM)) {
             alertMSG = BEFORE_MSG;
        } else if (  Long.parseLong(CurrYMDK) > Long.parseLong(DATE_TO)) {
             alertMSG= AFTER_MSG;

        }
    }

    //String  itemFilename  = "org_item_"+GRUP_NUMB+".xls";
    String  itemFilename  = "";
    String  guideFilename = "";
    //csr_9999 파주추가
    //[CSR ID:3489341] 2017년 암검진 실시 09(기술원추가)
    if (GRUP_NUMB.equals("10") ||GRUP_NUMB.equals("12") || GRUP_NUMB.equals("04") || GRUP_NUMB.equals("09")) { //10:오창,12:파주, 04:대산 ([CSR ID:2698889] 2015년 종합검진 및 추가암검진 신청안내문. 검진병원별 항목표 게시 요청 件 대산 추가)
        //guideFilename = "org_guide_"+GRUP_NUMB+".ppt";
        itemFilename  = "org_item_"+GRUP_NUMB+".xls";
    }

%>

<%!
    public String getDay(int yy ,int mm ,int dd) {
         Calendar oCalendar = Calendar.getInstance();
         Date d  = new Date( (yy-1900) , mm-1 , dd );
         final String[] week = {"일","월","화","수","목","금","토"};
         return week[d.getDay()];
    }
%>

<jsp:include page="/include/header.jsp"/>

<script language="JavaScript">
<!--
function doSubmit(){
        f_build('');
}

function f_build(ZCONFIRM) {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.ZCONFIRM.value = ZCONFIRM;
    frm.action =  "<%= WebUtil.ServletURL %>hris.E.E38Cancer.E38CancerBuildSV";
    document.form1.method = "post";
    document.form1.target = "listFrame";
    document.form1.submit();
}
function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action =  "<%= WebUtil.ServletURL %>hris.E.E38Cancer.E38CancerListSV";
    frm.target = "listFrame";
    frm.submit();
}
//알림추가12.08.16
function winNoticOpen(gubun){
   return;
    if (  "<%=GRUP_NUMB%>"=="02"){ // 여수:02

         var url="<%=WebUtil.JspURL%>"+"notice.jsp?gubun="+gubun;
         var win = window.open(url,"notice","width=750,height=300,left=365,top=70,scrollbars=no");
         win.focus();
    }
}

//-->
</script>
<body>
<form name="form1" method="post">
  <input type="hidden" name ="PERNR" value="<%=PERNR%>">
  <input type="hidden" name ="ZCONFIRM" value="">
  <input type="hidden" name ="jobid" value="">

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>
        <!--
          <td width="100">
            <a href="javascript:do_Btn01();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Tax10','','/web/images/btn_E15General_on.gif',1)"><img name="Tax10" border="0" src="/web/images/btn_E15General_off.gif" alt="종합검진"></a>
          </td>

          <td width="100">
             <img name="Tax11" border="0" src="/web/images/btn_E38Cancer_on.gif" alt="추가암검진(7대암검진)">
          </td>
          -->
<%
    if (  GRUP_NUMB != null && !GRUP_NUMB.equals("08")) {//[CSR ID:2967911]청주의 경우 제외함.
%>
	<div class="textDiv_t">
<% if (!itemFilename.equals("")){ %>
        <a href="<%=WebUtil.ImageURL%>../E/E38Cancer/<%=itemFilename%>" target="_blank"><img src="<%= WebUtil.ImageURL %>xls.gif" border="0" style="vertical-align: middle;"><font color="blue"> <!--검진기관별 검진항목--><spring:message code="LABEL.E.E28.0024" /></font></a>
<% }%>
<% if (!guideFilename.equals("")){ %>
        <a href="<%=WebUtil.ImageURL%>../E/E38Cancer/<%=guideFilename%>" target="_blank"><img src="<%= WebUtil.ImageURL %>ppt.gif" border="0" style="vertical-align: middle;"><font color="blue"> <!--종합건강진단 주의사항 및 검사설명--><spring:message code="LABEL.E.E28.0025" /></font></a>
<% }%>
	</div>
<%
        if (  E_HEALTH.equals("Y")  ) { //담당자항상 신청
%>
    <div class="buttonArea">
        <ul class="btn_crud">
    	<%if ( alertMSG.equals("") ) { %>
            <li id="sc_button"><a class="darken" href="javascript:doSubmit()"><span><!--신청--><spring:message code='BUTTON.COMMON.REQUEST' /></span></a></li>
    	<% } else { %>
            <li id="sc_button"><a class="darken" href="javascript:alert('<%=alertMSG%>');doSubmit()"><span><!--신청--><spring:message code='BUTTON.COMMON.REQUEST' /></span></a></li>
    	<% } %>
        </ul>
    </div>

<%      } else if (  Long.parseLong(CurrYMDK) > Long.parseLong(DATE_TO) || Long.parseLong(CurrYMDK) <  Long.parseLong(DATE_FROM) ) {
%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a class="darken unloading" href="javascript:alert('<%=alertMSG%>');"><span><!--신청--><spring:message code='BUTTON.COMMON.REQUEST' /></span></a></li>
        </ul>
    </div>

<%      } else {
           if (  Long.parseLong(CurrYMDK) <= Long.parseLong(DATE_TO) && Long.parseLong(CurrYMDK) >=  Long.parseLong(DATE_FROM) ) {
               if(  user.e_persk.equals("14") ){// [CSR ID:2766987] 14 삭제 누락으로 같이 수정
                   //---
               } else {

%>
    <div class="buttonArea">
        <ul class="btn_crud">
            <li id="sc_button"><a class="darken" href="javascript:doSubmit()"><span><!--신청--><spring:message code='BUTTON.COMMON.REQUEST' /></span></a></li>
        </ul>
    </div>
<%
               }
           }
        }
%>

<%
    } else {
%>

<%
    }
%>

</form>
</body>
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

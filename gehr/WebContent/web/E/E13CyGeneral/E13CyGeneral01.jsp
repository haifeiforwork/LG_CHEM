<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 이월종합검진                                                */
/*   Program Name : 이월종합검진                                                */
/*   Program ID   : E13CyGeneral01.jsp                                            */
/*   Description  : 이월종합검진 상세일정을 조회                                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                  2005-11-01  lsa                                             */
/*                              C2005110101000000598에의해 청주는 신청할수 없게 처리함 */
/*                              LINE113                                          */
/*                  2006-01-09  lsa C2006010901000000510 이월종합검진 신청버튼 삭제  */
/*          2010-08-02  jungin [C20100802_12671] 여수사업장 마감일 변경  */
/*          2013-02-01  [CSR ID:2265439] 이월종합검진 신청시 동의서 수정 관련의 건 -모든사업장 동의여부팝업내림  */
/*                  2014-08-06  이지은D [CSR ID:2588087] '14년 주요제도 변경에 따른 제도안내 페이지 미열람 요청                 */
/*                  2015-02-12  이지은D [CSR ID:2705323] 2015년 종합검진 안내 이미지 및 첨부 파일 업데이트 요청  */
/*               2015-05-08  이지은D  [CSR ID:2766987] 학자금 및 주택자금 담당자 결재 화면 수정요청   */
/*                  2016-03-03 이지은D [CSR ID:3000360] 2016년 종합검진(이월)  신청 이미지 및 첨부 파일 반영 요청   */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="hris.E.E15General.*" %>
<%@ page import="hris.E.E15General.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    String PERNR = (String)request.getAttribute("PERNR");

    E15GeneralDayData e15GeneralDayData = new E15GeneralDayData();

    E15GeneralGetDayRFC func = new E15GeneralGetDayRFC();
    Vector ret = func.getMedicday(PERNR);
    Vector ret_DamDang = func.getMedicday(user.empNo);
    e15GeneralDayData = (E15GeneralDayData)ret.get(0); //사업장별 일정
    String E_HEALTH  = (String)ret_DamDang.get(1); //담당자여부

    String GRUP_NUMB    = e15GeneralDayData.GRUP_NUMB   ;  //사업장
    String GRUP_NAME    = e15GeneralDayData.GRUP_NAME   ;  //사업장명
    String DATE_FROM    = DataUtil.delDateGubn(e15GeneralDayData.DATE_FROM)+"09";  //신청기간 FROM
    String DATE_TO  = DataUtil.delDateGubn(e15GeneralDayData.DATE_TO)+"24"  ;  //신청기간 TO
    String BEFORE_MSG   = e15GeneralDayData.BEFORE_MSG  ;  //신청기간 전 MESSAGE
    String AFTER_MSG    = e15GeneralDayData.AFTER_MSG   ;  //신청기간 후 MESSAGE
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

    String  itemFilename  = "org_item_"+GRUP_NUMB+".xls";
    String  guideFilename = "";
    if (GRUP_NUMB.equals("02")||GRUP_NUMB.equals("03")) { //03:나주
        guideFilename = "org_guide_"+GRUP_NUMB+".ppt";
    }

    //CSRID : 2705323
    String hospitalInfoSev = "";
    String hospitalInfoHwasun = "";
    if (GRUP_NUMB.equals("02")) { //02:여수
        hospitalInfoSev = "hospitalInfo_sev_"+GRUP_NUMB+".xls";
        hospitalInfoHwasun = "hospitalInfo_hwasun_"+GRUP_NUMB+".xls";
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
    frm.action =  "<%= WebUtil.ServletURL %>hris.E.E13CyGeneral.E13CyGeneralBuildSV";
    document.form1.method = "post";
    document.form1.target = "listFrame";
    document.form1.submit();
}
function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action =  "<%= WebUtil.ServletURL %>hris.E.E13CyGeneral.E13CyGeneralListSV";
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

<%
    if (  GRUP_NUMB != null ) {
%>

<!---------------------------------------------->
    <div class="textDiv_t">
         <!-- [CSR ID:3000360] 2016년 종합검진(이월)  신청 이미지 및 첨부 파일 반영 요청 -->
         <a href="<%=WebUtil.ImageURL%>../E/E13CyGeneral/<%=itemFilename%>" target="_blank"><img src="<%= WebUtil.ImageURL %>sshr/ico_excel.png" border="0" style="vertical-align: middle;"><font color=blue> <!--검진기관별 검진항목--><spring:message code="LABEL.E.E28.0020" /></font></a>
         <% if (!guideFilename.equals("")){ %>
         <a href="<%=WebUtil.ImageURL%>../E/E13CyGeneral/<%=guideFilename%>" target="_blank"><img src="<%= WebUtil.ImageURL %>sshr/ico_ppt.png" border="0" style="vertical-align: middle;"><font color=blue> <!--종합건강진단 주의사항 및 검사설명--><spring:message code="LABEL.E.E28.0021" /></font></a>
         <% } if (!hospitalInfoSev.equals("")){%>
         <a href="<%=WebUtil.ImageURL%>../E/E13CyGeneral/<%=hospitalInfoSev%>" target="_blank"><img src="<%= WebUtil.ImageURL %>sshr/ico_excel.png" border="0" style="vertical-align: middle;"><font color=blue> <!--종합검진(세브란스)--><spring:message code="LABEL.E.E28.0022" /></font></a>
         <% } if (!hospitalInfoHwasun.equals("")){%>
         <a href="<%=WebUtil.ImageURL%>../E/E13CyGeneral/<%=hospitalInfoHwasun%>" target="_blank"><img src="<%= WebUtil.ImageURL %>sshr/ico_excel.png" border="0"style="vertical-align: middle;"><font color=blue> <!--종합검진(화순전대)--><spring:message code="LABEL.E.E28.0023" /></font></a>
         <% } %>
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
            <li id="sc_button"><a class="darken" href="javascript:alert('<%=alertMSG%>');"><span><!--신청--><spring:message code='BUTTON.COMMON.REQUEST' /></span></a></li>
        </ul>
    </div>

<%      }  else {
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
<jsp:include page="/include/footer.jsp"/>
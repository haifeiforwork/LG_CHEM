<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진                                                    */
/*   Program ID   : E15General01.jsp                                            */
/*   Description  : 종합검진 상세일정을 조회                                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                  2005-11-01  lsa                                             */
/*                              C2005110101000000598에의해 청주는 신청할수 없게 처리함 */
/*                              LINE113                                          */
/*                  2006-01-09  lsa C2006010901000000510 종합검진 신청버튼 삭제  */
/*		    2010-08-02	jungin [C20100802_12671] 여수사업장 마감일 변경  */
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
    e15GeneralDayData = (E15GeneralDayData)ret.get(0); //사업장별 일정
    String E_HEALTH  = (String)ret.get(1); //담당자여부

    String GRUP_NUMB	= e15GeneralDayData.GRUP_NUMB	;  //사업장             
    String GRUP_NAME	= e15GeneralDayData.GRUP_NAME	;  //사업장명           
    String DATE_FROM	= DataUtil.delDateGubn(e15GeneralDayData.DATE_FROM)+"09";  //신청기간 FROM      
    String DATE_TO	= DataUtil.delDateGubn(e15GeneralDayData.DATE_TO)+"24"  ;  //신청기간 TO        
    String BEFORE_MSG	= e15GeneralDayData.BEFORE_MSG	;  //신청기간 전 MESSAGE
    String AFTER_MSG	= e15GeneralDayData.AFTER_MSG	;  //신청기간 후 MESSAGE    
    String alertMSG	= ""	;  //MESSAGE
    
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
    if (GRUP_NUMB.equals("02")) {
        guideFilename = "org_guide_"+GRUP_NUMB+".ppt";  
    }
     
    //int Index = 6;
    //String GrupNumb[]    = new String[Index];
    //String FromDT[]      = new String[10];
    //String ToDT[]        = new String[10];
    //String beforeMSG[]   = new String[10];
    //String afterMSG[]    = new String[10];
    //String alertMSG[]    = new String[10];
    //String itemFilename[]= new String[10];
    //String guideFilename[]= new String[10];
    //String exceptPERNRYN  = "N";
    //  
    //GrupNumb[0]    = "01";
    //GrupNumb[1]    = "02";//여수
    //GrupNumb[2]    = "03";//청주
    //GrupNumb[3]    = "05";//기술원
    //GrupNumb[4]    = "10";//오창
    //GrupNumb[5]    = "09";//대산
    //
    //FromDT[0]      = "2011041809"; //본사       yyyyMMddkk
    //FromDT[1]      = "2011032909"; //여수       
    //FromDT[2]      = "2012010909"; //청주       
    //FromDT[3]      = "2012011109"; //기술원     
    //FromDT[4]      = "2012010909"; //오창        
    //FromDT[5]      = "2011062709"; //대산        
    //ToDT[0]        = "2011093024"; //본사    
    //ToDT[1]        = "2011113024"; //여수        
    //ToDT[2]        = "2012123124"; //청주        
    //ToDT[3]        = "2012123124"; //기술원      
    //ToDT[4]        = "2012123124"; //오창         
    //ToDT[5]        = "2011070724"; //대산          
    //
    //beforeMSG[0]   = Integer.parseInt(FromDT[0].substring(4,6))+"/"+Integer.parseInt(FromDT[0].substring(6,8))+"일("+getDay( Integer.parseInt(FromDT[0].substring(0,4)), Integer.parseInt(FromDT[0].substring(4,6)), Integer.parseInt(FromDT[0].substring(6,8)))+") "+Integer.parseInt(FromDT[0].substring(8,10))+"시 부터 ~ ";  
    //beforeMSG[0]   = beforeMSG[0] + Integer.parseInt(ToDT[0].substring(4,6))+"/"+Integer.parseInt(ToDT[0].substring(6,8))+"일("+getDay( Integer.parseInt(ToDT[0].substring(0,4)), Integer.parseInt(ToDT[0].substring(4,6)), Integer.parseInt(ToDT[0].substring(6,8)))+") "+Integer.parseInt(ToDT[0].substring(8,10))+"시 까지 신청가능 합니다.";  
    //
    //beforeMSG[1]   = Integer.parseInt(FromDT[1].substring(4,6))+"/"+Integer.parseInt(FromDT[1].substring(6,8))+"일("+getDay( Integer.parseInt(FromDT[1].substring(0,4)), Integer.parseInt(FromDT[1].substring(4,6)), Integer.parseInt(FromDT[1].substring(6,8)))+") "+Integer.parseInt(FromDT[1].substring(8,10))+"시 부터 ~ ";     
    //beforeMSG[1]   = beforeMSG[1] + Integer.parseInt(ToDT[1].substring(4,6))+"/"+Integer.parseInt(ToDT[1].substring(6,8))+"일("+getDay( Integer.parseInt(ToDT[1].substring(0,4)), Integer.parseInt(ToDT[1].substring(4,6)), Integer.parseInt(ToDT[1].substring(6,8)))+") "+Integer.parseInt(ToDT[1].substring(8,10))+"시 까지 신청가능 합니다.";  
    //
    //beforeMSG[2]   = Integer.parseInt(FromDT[2].substring(4,6))+"/"+Integer.parseInt(FromDT[2].substring(6,8))+"일("+getDay( Integer.parseInt(FromDT[2].substring(0,4)), Integer.parseInt(FromDT[2].substring(4,6)), Integer.parseInt(FromDT[2].substring(6,8)))+") "+Integer.parseInt(FromDT[2].substring(8,10))+"시 부터 ~ ";   
    //beforeMSG[2]   = beforeMSG[2] + Integer.parseInt(ToDT[2].substring(4,6))+"/"+Integer.parseInt(ToDT[2].substring(6,8))+"일("+getDay( Integer.parseInt(ToDT[2].substring(0,4)), Integer.parseInt(ToDT[2].substring(4,6)), Integer.parseInt(ToDT[2].substring(6,8)))+") "+Integer.parseInt(ToDT[2].substring(8,10))+"시 까지 신청가능 합니다.";  
    //
    //beforeMSG[3]   = Integer.parseInt(FromDT[3].substring(4,6))+"/"+Integer.parseInt(FromDT[3].substring(6,8))+"일("+getDay( Integer.parseInt(FromDT[3].substring(0,4)), Integer.parseInt(FromDT[3].substring(4,6)), Integer.parseInt(FromDT[3].substring(6,8)))+") "+Integer.parseInt(FromDT[3].substring(8,10))+"시 부터 ~ ";     
    //beforeMSG[3]   = beforeMSG[3] + Integer.parseInt(ToDT[3].substring(4,6))+"/"+Integer.parseInt(ToDT[3].substring(6,8))+"일("+getDay( Integer.parseInt(ToDT[3].substring(0,4)), Integer.parseInt(ToDT[3].substring(4,6)), Integer.parseInt(ToDT[3].substring(6,8)))+") "+Integer.parseInt(ToDT[3].substring(8,10))+"시 까지 신청가능 합니다.";  
    //
    //beforeMSG[4]   = Integer.parseInt(FromDT[4].substring(4,6))+"/"+Integer.parseInt(FromDT[4].substring(6,8))+"일("+getDay( Integer.parseInt(FromDT[4].substring(0,4)), Integer.parseInt(FromDT[4].substring(4,6)), Integer.parseInt(FromDT[4].substring(6,8)))+") "+Integer.parseInt(FromDT[4].substring(8,10))+"시 부터 ~ ";    
    //beforeMSG[4]   = beforeMSG[4] + Integer.parseInt(ToDT[4].substring(4,6))+"/"+Integer.parseInt(ToDT[4].substring(6,8))+"일("+getDay( Integer.parseInt(ToDT[4].substring(0,4)), Integer.parseInt(ToDT[4].substring(4,6)), Integer.parseInt(ToDT[4].substring(6,8)))+") "+Integer.parseInt(ToDT[4].substring(8,10))+"시 까지 신청가능 합니다.";  
    //
    //beforeMSG[5]   = Integer.parseInt(FromDT[5].substring(4,6))+"/"+Integer.parseInt(FromDT[5].substring(6,8))+"일("+getDay( Integer.parseInt(FromDT[5].substring(0,4)), Integer.parseInt(FromDT[5].substring(4,6)), Integer.parseInt(FromDT[5].substring(6,8)))+") "+Integer.parseInt(FromDT[5].substring(8,10))+"시 부터 ~ ";   
    //beforeMSG[5]   = beforeMSG[5] + Integer.parseInt(ToDT[5].substring(4,6))+"/"+Integer.parseInt(ToDT[5].substring(6,8))+"일("+getDay( Integer.parseInt(ToDT[5].substring(0,4)), Integer.parseInt(ToDT[5].substring(4,6)), Integer.parseInt(ToDT[5].substring(6,8)))+") "+Integer.parseInt(ToDT[5].substring(8,10))+"시 까지 신청가능 합니다.";                
    //
    //    
    //afterMSG[0]   = "종합검진 신청이 마감되었습니다.";  
    //afterMSG[1]   = "신청기간이 아닙니다.";  
    //afterMSG[2]   = "신청기간이 아닙니다.";  
    //afterMSG[3]   = "신청기간이 아닙니다.";  
    //afterMSG[4]   = "신청기간이 아닙니다.";  
    //afterMSG[5]   = "신청기간이 아닙니다.";  
    //itemFilename[0] = "org_item_01.xls";   
    //itemFilename[1] = "org_item_02.xls";   
    //itemFilename[2] = "org_item_03.xls";   
    //itemFilename[3] = "org_item_05.xls";   
    //itemFilename[4] = "org_item_10.xls";    
    //itemFilename[5] = "org_item_09.xls";   
    //guideFilename[0] = "";   
    //guideFilename[1] = "org_guide_02.ppt";   
    //guideFilename[2] = "";   
    //guideFilename[3] = "";   
    //guideFilename[4] = "";       
    //guideFilename[5] = "";    
    //    
    //int   GrupIndex=99;
    //
    //for( int i =0 ; i <  GrupNumb.length; i++ ) {
    //    if (user.e_grup_numb.equals(GrupNumb[i])) {
    //        GrupIndex = i;
    //    }
    //}
    //
    //
    //      
    ////GrupIndex=5;//개발
    //if (GrupIndex !=99 ){
    //    if (  Long.parseLong(CurrYMDK) <= Long.parseLong(ToDT[GrupIndex]) && Long.parseLong(CurrYMDK) >=  Long.parseLong(FromDT[GrupIndex]) ) {
    //         alertMSG[GrupIndex] = "";
    //    } else if (  Long.parseLong(CurrYMDK) < Long.parseLong(FromDT[GrupIndex])) {
    //         alertMSG[GrupIndex] = beforeMSG[GrupIndex];
    //    } else if (  Long.parseLong(CurrYMDK) > Long.parseLong(ToDT[GrupIndex])) {
    //         alertMSG[GrupIndex] = afterMSG[GrupIndex];
    //    }
    //}
    //
    //  
    //String exceptPERNR[]    = new String[10]; 
    ////운영 
    //exceptPERNR[0] = "00202501"; //윤명희
    //exceptPERNR[1] = "00043832"; //서민원 청주
    //exceptPERNR[2] = "00202344"; //강호선 오창
    //exceptPERNR[3] = "00004615"; //박금옥 여수
    //exceptPERNR[4] = "00117589"; //김주희 여수 
    //exceptPERNR[5] = "00200673"; //김은미 여수
    //exceptPERNR[6] = "00203532"; //임정혜 여수
    //exceptPERNR[7] = "00207813"; //임현정 대전기술원
    //exceptPERNR[8] = "00207795"; //윤혜정 대산 
    //exceptPERNR[9] = "00206430"; //박은혜 청주
    // 
    ////개발 
    ////exceptPERNR[8] = "00070000"; //임정혜 여수 
    ////exceptPERNR[9] = "00030215"; //임정혜 여수 
    //
    //
    //for( int i =0 ; i <  exceptPERNR.length; i++ ) {
    //    if (user.empNo.equals(exceptPERNR[i])) {
    //        exceptPERNRYN = "Y";
    //    }
    //}          		
    
%>

<%!
      
                           
    public String getDay(int yy ,int mm ,int dd) 
    {
      
         Calendar oCalendar = Calendar.getInstance();
      
         Date d  = new Date( (yy-1900) , mm-1 , dd );
 
         final String[] week = {"일","월","화","수","목","금","토"};
 
         return week[d.getDay()];
    } 
    

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
function doSubmit(){
    //buttonDisabled();
    url = "<%=WebUtil.JspPath%>E/E15General/E15GeneralAgreePopup.jsp";
    
    var args = new Array();
    //args["PERNR"] = "<%=PERNR%>";
    ret = window.showModalDialog(url, window, "scroll:yes;status:no;help:no;dialogWidth:520px;dialogHeight:320px")		
}
function doSubmit_bak(){
    buttonDisabled();
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E15General.E15GeneralBuildSV";
    document.form1.target = "main_ess";
    document.form1.method = "post";
    document.form1.submit();
}
function f_build() {  
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action =  "<%= WebUtil.ServletURL %>hris.E.E15General.E15GeneralBuildSV";
    document.form1.method = "post";
    document.form1.target = "main_ess";
    document.form1.submit();
}
function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action =  "<%= WebUtil.ServletURL %>hris.E.E15General.E15GeneralListSV";
    frm.target = "main_ess";
    frm.submit();
}

//-->
</script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <input type="hidden" name ="PERNR" value="<%=PERNR%>">
  <input type="hidden" name ="jobid" value="">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="780"> <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td height="5" colspan="2"></td>
                </tr>
                <tr> 
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">종합검진신청</td>
                  <td align="right"><a href="javascript:open_rule('Rule02Benefits08.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','<%= WebUtil.ImageURL %>btn_rule_on.gif',1)"><img name="Image5" border="0" src="<%= WebUtil.ImageURL %>btn_rule_off.gif" width="90" height="15" alt="제도안내"></a><a href="javascript:open_help('E15General.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
<%
    }
%>
          <tr> 
            <td>
              <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="title02" width="200"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    종합검진 실시안내</td>
<%       
    //if (  GrupIndex !=99  &&GrupIndex < GrupNumb.length+1) {
    if (  GRUP_NUMB != null ) {
%>

<!---------------------------------------------->

 <%
        if (  E_HEALTH.equals("Y")  ) { //담당자항상 신청
%>
                  <td width="60">
                  <%if ( alertMSG.equals("") ) { %>
                    <span id="sc_button"><a href="javascript:doSubmit()"><img src="<%= WebUtil.ImageURL %>btn_build.gif" border="0"></a></span> 
                  <% } else { %>
                    <span id="sc_button"><a href="javascript:alert('<%=alertMSG%>');doSubmit()"><img src="<%= WebUtil.ImageURL %>btn_build.gif" border="0"></a></span> 
                  <% } %>                  
                  </td>
<%      }
        else if (  Long.parseLong(CurrYMDK) > Long.parseLong(DATE_TO) || Long.parseLong(CurrYMDK) <  Long.parseLong(DATE_FROM) ) {
%>
                  <td width="60">
                    <span id="sc_button"><a href="javascript:alert('<%=alertMSG%>');"><img src="<%= WebUtil.ImageURL %>btn_build.gif" border="0"></a></span> 
                  </td>
<%      }
        else {
           if (  Long.parseLong(CurrYMDK) <= Long.parseLong(DATE_TO) && Long.parseLong(CurrYMDK) >=  Long.parseLong(DATE_FROM) ) {
           
%>
                  <td width="60">
                    <span id="sc_button"><a href="javascript:doSubmit()"><img src="<%= WebUtil.ImageURL %>btn_build.gif" border="0"></a></span>
                  </td>
<%
           } 
        }
%>
    <td>
     <table  border="0" cellspacing="1" cellpadding="0" height="25">
       <tr>
         <td class="td09" valign=middle><img src="<%= WebUtil.ImageURL %>xls.gif" border="0" valign=middle><a href="<%=WebUtil.ImageURL%>../E/E15General/<%=itemFilename%>" target="_blank"><font color=blue> 검진기관별 검진항목</font></a></td>
         <% if (!guideFilename.equals("")){ %>
         <td class="td09" valign=middle><img src="<%= WebUtil.ImageURL %>xls.gif" border="0" valign=middle><a href="<%=WebUtil.ImageURL%>../E/E15General/<%=guideFilename%>" target="_blank"><font color=blue> 종합건강진단 주의사항 및 검사설명</font></a></td>
         <% }%>
       </tr>
     </table>
    </td> 
 

<!---------------------------------------------->       
 
<%       
    } else {
%>
                  <td></td>
<%
    }
%> 

                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
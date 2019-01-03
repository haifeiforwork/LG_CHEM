<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR	                                                */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 진행중 문서                                            */
/*   Program Name : 경조금 결재                                                 */
/*   Program ID   : G004ApprovalCongra.jsp                                      */
/*   Description  : 경조금 결재                                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*                  2006-06-08  @v1.1 LSA 프로세스개선                          */
/*                  2006-06-14  @v1.2 경조지원내역 조회                         */
/*                              [CSR ID:1225704] -프로세스개선 임시 막음        */
/*                  2013-09-26  [CSR ID:@CSR1 ] - 회갑 결재시 생년월일+60년 한 날짜에서 +-1달차이 warning 처리*/
/*                  2013-12-04  [CSR ID:C20131203_47673] 문구변경 */
/*                  2014-04-24  [CSR ID:C20140416_24713]  화환신청시 0007 주문업체 정보추가 , 통상임금정보삭제 , 배송업체메일발송,sms추가,초기구분자 추가    */
/*                  2014-07-31  [CSR ID:2584987] HR Center 경조금 신청 화면 문구 수정                                            */
/*                  2016-07-13  [CSR ID:3051290]  쌀화환 경조 신청 관련 시스템 개발  - 김불휘S                          */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>

<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.E19CongcondData" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.G.rfc.G004CongraReasonRFC" %>
<%@ page import="hris.G.G004CongraReasonData" %>
<%@ page import="hris.A.A04FamilyDetailData" %>
<%
    WebUserData     user                = (WebUserData)session.getValue("user");
    E19CongcondData e19CongcondData     = (E19CongcondData)request.getAttribute("E19CongcondData");
    Vector          vcAppLineData       = (Vector) request.getAttribute("vcAppLineData");
    PersonData phonenum            = (PersonData) request.getAttribute("PersInfoData");

    String          RequestPageName     = (String) request.getAttribute("RequestPageName");

    Vector  vcCongCode   =   (new E19CongCodeRFC()).getCongCode(user.companyCode);
    Vector  E19CongcondData_opt = (new E19CongRelaRFC()).getCongRela(user.empNo);

    Vector vcCongRela = new Vector();

    for( int i = 0 ; i < E19CongcondData_opt.size() ; i++ ){
        E19CongcondData old_data = (E19CongcondData)E19CongcondData_opt.get(i);
        if( e19CongcondData.CONG_CODE.equals(old_data.CONG_CODE) ){
            CodeEntity code_data = new CodeEntity();
            code_data.code = old_data.RELA_CODE ;
            code_data.value = old_data.RELA_NAME ;
            vcCongRela.addElement(code_data);
        } // end if
    } // end for

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if

    boolean isHaveRight = true;
    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e19CongcondData.AINF_SEQN ,user.empNo ,false);
    int approvalStep = docinfo.getApprovalStep();

    //@v1.1
    String webUserID = "";
    if (user.webUserId == null ||user.webUserId.equals("") )
        webUserID = "";
    else
        webUserID = user.webUserId.substring(0,6).toUpperCase();

    //@CSR1

   // Vector          vcA04FamilyData       = (Vector) request.getAttribute("vcA04FamilyData");   //신청대상자 상세정보
     //A04FamilyDetailData A04FamilyData = (A04FamilyDetailData)vcA04FamilyData.get(0);

     String SIXTH_DATE             = (String)request.getAttribute("SIXTH_DATE");
%>

<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr2.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" type="text/JavaScript">
    //@v1.1 start
    var epUrl = new Array("","","","","");
    //인사정보
    epUrl[0]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url=";
    //신청
    epUrl[1]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url=";
    //사원인사정보
    epUrl[2]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHROrgStatMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHROrgStatMenu%2Fbegin&_windowLabel=portlet_EHROrgStatMenu_1&_pageLabel=Menu03_Book04_Page01&portlet_EHROrgStatMenu_1url=";
    //조직통계
    epUrl[3]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url=";
    //결재함
    epUrl[4]= "http://epapp.lgchem.com:8101/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url=";

    var docUpid = new Array("0_1006","0_1088","0_1089","0_1090","0_1091","0_1092","0_1285","1_1007","1_1066","1_1134","1_1163","1_1168","1_1222","1_1281","2_1033","2_1053","2_1056","2_1060","2_1063","3_1094","3_1137","3_1138","3_1139","3_1140","3_1141","4_1003");

    function openDoc(docID, upID, realPath)
    {
        var epReturnUrl = "";
        for (r=0;r<docUpid.length;r++) {
           if (upID == docUpid[r].substring(2,6)) {
              epReturnUrl = epUrl[docUpid[r].substring(0,1)]+realPath;
           }
        }
        clickDoc(docID,epReturnUrl);

    }
    function clickDoc(docID,epReturnUrl)
    {
       small_window=window.open("","CongraPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=680,height=460,left=100,top=100");

       small_window.focus();

       frm = document.form1;
       frm.action = epReturnUrl;
       frm.target = "CongraPers";
       frm.submit();
    } // end function
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

    //메시지
    function show_waiting_smessage(div_id ,message)
    {
        // alert(document.body.scrollLeft + "\t ," + document.body.scrollTop);
        var _x = document.body.clientWidth/2 + document.body.scrollLeft-120;
        var _y = document.body.clientHeight/2 + document.body.scrollTop+5;
        job_message.innerHTML = message;
        document.all[div_id].style.posLeft=_x;
        document.all[div_id].style.posTop=_y;
        document.all[div_id].style.visibility='visible';
    }



    function approval()
    {
        var frm = document.form1;
        if ( "<%=e19CongcondData.CONG_CODE%>" == "0002" && "<%=e19CongcondData.REGNO%>" != "" &&
             ("<%=DataUtil.delDateGubn(e19CongcondData.CONG_DATE )%>"  != <%=SIXTH_DATE%>  ) ) {
            if ( frm.REASON_CD.value == "" ) {
                alert("회갑경조일차이사유를 입력하세요");
                document.form1.REASON_CD.focus();
                return;
            }
            if ( frm.BIGO_TEXT.value == "" ) {

                alert("경조발생일이 주민등록번호상 생년월일과 차이가 있으므로\n결재자께서는 사실 확인을 하여, \n확인내용을 [적요]란에 상세히 기재 바랍니다.\n※ 기재내용을 기준으로 경조금 Data Monitoring을 실시\n하오니 정확한 확인 및 기재 부탁드립니다.");
                return;
           }
           frm.REASON_TEXT.value=frm.REASON_CD[frm.REASON_CD.selectedIndex].text;



        }
        if(!frm.chPROOF.checked) {
            //C20131203_47673
	    if ( "<%=e19CongcondData.CONG_CODE%>" == "0002" && "<%=e19CongcondData.REGNO%>" != "" &&
	         ("<%=DataUtil.delDateGubn(e19CongcondData.CONG_DATE )%>"  != <%=SIXTH_DATE%>  ) ) {
	        alert("회갑 대상자의 주민등록상 생일과 경조일자가 상이하므로 증빙 등을 통해 사실 관계를 확인 후에 결재하여 지급하시기 바랍니다.");
            }else{
            	alert("사실여부를 확인하세요");
            }
            return;
        } else {
            frm.PROOF.value = frm.chPROOF.value;
        } // end if



        if(!confirm("결재 하시겠습니까.")) {
            return;
        } // end if

        frm.APPR_STAT.value = "A";
	buttonDisabled();
	show_waiting_smessage("waiting","결재 중입니다...");
        frm.submit();
    }
    //[CSR ID:1225704] 경조지원내역 조회
    function goToList()
    {

       var frm = document.form1;
       frm.jobid.value = "";
       frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
       frm.submit();

      //var url="<%=WebUtil.JspURL%>"+"E/E19Congra/E19CongraFamily_pop.jsp?PERNR="+"<%=e19CongcondData.PERNR%>";

 }
    function goToList_pop() {

      var url="<%=WebUtil.JspURL%>"+"G/G004ApprovalCongra_pop.jsp?PERNR="+"<%=e19CongcondData.PERNR%>"+"&sortField=BEGDA&select=BEGDA";
      //var url = "/servlet/hris.E.E20Congra.E20CongraListSV_m"
      var win = window.open(url,"","width=830,height=480,left=365,top=70,scrollbars=yes");
      win.focus();
}
    function reject()
    {
        if(!confirm("반려 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPR_STAT.value = "R";
        frm.submit();

    }
//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!---- waiting message start-->
<DIV id="waiting" style="Z-INDEX: 1; LEFT: 50px; VISIBILITY: hidden; WIDTH: 250px; POSITION: absolute; TOP: 120px; HEIGHT: 45px">
<TABLE cellSpacing=1 cellPadding=0 width="98%" bgColor=black border=0>
  <TBODY>
  <TR bgColor=white>
    <TD>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD class=icms align=middle height=70 id = "job_message">... 잠시만 기다려주십시요 </TD>
        </TR>
        </TBODY>
      </TABLE>
    </TD>
  </TR>
  </TBODY>
</TABLE>
</DIV>
<!---- waiting message end-->
<form name="form1" id="form1" method="post">
<input type="hidden" name="jobid" value="save">



<!-- @CSR1 회갑일자, 백숙부모 姓 체크 -->

<input type="hidden" name="SIXTH_DATE" value="<%=SIXTH_DATE%>"><!--대상자회갑생년월일-->

<!--<input type="hidden" name="FGBDT" value=" A04FamilyData.FGBDT >">--><!--대상자생년월일-->
<!--<input type="hidden" name="PER_LNMHG" value="< =phonenum.E_ENAME.substring(0,A04FamilyData.LNMHG.length()) >">--><!--신청자姓-->
<!--<input type="hidden" name="LNMHG" value="< =A04FamilyData.LNMHG  >">--><!--대상자姓-->

<input type="hidden" name="CONG_NAME" value="<%=WebUtil.printOptionText(vcCongCode ,e19CongcondData.CONG_CODE)%>"><!--경조명-->


<input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
<input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">

<input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

<input type="hidden" name="PERNR" value="<%=e19CongcondData.PERNR%>">
<input type="hidden" name="BEGDA" value="<%=e19CongcondData.BEGDA%>">
<input type="hidden" name="AINF_SEQN" value="<%=e19CongcondData.AINF_SEQN%>">
<input type="hidden" name="CONG_CODE" value="<%=e19CongcondData.CONG_CODE%>">
<input type="hidden" name="RELA_CODE" value="<%=e19CongcondData.RELA_CODE%>">
<input type="hidden" name="EREL_NAME" value="<%=e19CongcondData.EREL_NAME%>">
<input type="hidden" name="CONG_DATE" value="<%=e19CongcondData.CONG_DATE%>">
<input type="hidden" name="WAGE_WONX" value="<%=e19CongcondData.WAGE_WONX%>">
<input type="hidden" name="CONG_RATE" value="<%=e19CongcondData.CONG_RATE%>">
<input type="hidden" name="CONG_WONX" value="<%=e19CongcondData.CONG_WONX%>">
<input type="hidden" name="PROV_DATE" value="<%=e19CongcondData.PROV_DATE%>">
<input type="hidden" name="BANK_NAME" value="<%=e19CongcondData.BANK_NAME%>">
<input type="hidden" name="BANKL" value="<%=e19CongcondData.BANKL%>">
<input type="hidden" name="BANKN" value="<%=e19CongcondData.BANKN%>">
<input type="hidden" name="HOLI_CONT" value="<%=e19CongcondData.HOLI_CONT%>">
<input type="hidden" name="WORK_YEAR" value="<%=e19CongcondData.WORK_YEAR%>">
<input type="hidden" name="WORK_MNTH" value="<%=e19CongcondData.WORK_MNTH%>">
<input type="hidden" name="RTRO_MNTH" value="<%=e19CongcondData.RTRO_MNTH%>">
<input type="hidden" name="RTRO_WONX" value="<%=e19CongcondData.RTRO_WONX%>">
<input type="hidden" name="LIFNR" value="<%=e19CongcondData.LIFNR%>">
<input type="hidden" name="DISA_RESN" value="<%=e19CongcondData.DISA_RESN%>">
<input type="hidden" name="POST_DATE" value="<%=e19CongcondData.POST_DATE%>">
<input type="hidden" name="BELNR" value="<%=e19CongcondData.BELNR%>">
<input type="hidden" name="ZPERNR" value="<%=e19CongcondData.ZPERNR%>">
<input type="hidden" name="ZUNAME" value="<%=e19CongcondData.ZUNAME%>">
<input type="hidden" name="REGNO" value="<%=e19CongcondData.REGNO%>">

<input type="hidden" name="PROOF">
<input type="hidden" name="APPR_STAT">
<input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">

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
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">경조금신청 결재</td>
                  <td align="right" class="title02">&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              <!--  검색테이블 시작 -->
              <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                <tr>
                  <td width="40" class="td03">사번</td>
                  <td width="80" class="td04"><%=phonenum.E_PERNR%></td>
                  <td width="40" class="td03">성명</td>
                  <td width="70" class="td04"><%=phonenum.E_ENAME%></td>
                  <td width="40" class="td03">직위</td>
                  <td width="70" class="td04"><%=phonenum.E_TITEL%></td>
                  <td width="40" class="td03">직책</td>
                  <td width="70" class="td04"><%=phonenum.E_TITL2%></td>
                  <td width="40" class="td03">부서</td>
                  <td class="td04"><%=phonenum.E_ORGTX%></td>
                </tr>
              </table>
              <!--  검색테이블 끝-->
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              <!-- 리스트테이블 시작 -->
              <table width="780" border="0" cellpadding="5" cellspacing="1" class="table03">
                <tr>
                  <td bgcolor="#FFFFFF"><table border="0" cellpadding="0" cellspacing="1">
                      <tr>
                        <td width="130" class="td01">신청일</td>
                        <td width="130" class="td09"><%=WebUtil.printDate(e19CongcondData.BEGDA)%>
                        </td>
                        <td width="130" class="td01">경조내역</td>
                        <td width="388" class="td09"><%= WebUtil.printOptionText(vcCongCode ,e19CongcondData.CONG_CODE)%></td>
                      </tr>
                      <tr>
                        <td class="td01">경조대상자 관계</td>
                        <td class="td09"><%= WebUtil.printOptionText(vcCongRela ,e19CongcondData.RELA_CODE)%></td>
                        <td class="td01">경조대상자 성명</td>
                        <td class="td09"><%=e19CongcondData.EREL_NAME%> <%= e19CongcondData.REGNO.equals("") ? "" : "["+e19CongcondData.REGNO.substring(0,6)+"-*******]"%></td>
                      </tr>
                      <tr>
                        <td class="td01">경조발생일자</td>
                        <td class="td09"><%=WebUtil.printDate(e19CongcondData.CONG_DATE)%></td>
                        <td class="td09">&nbsp;</td>
                        <td class="td09">&nbsp;</td>
                      </tr>
                    </table>
                    <br/>
                    <table border="0" cellpadding="0" cellspacing="1">
						<%
						    //  0007 화환만  통상임금 안보여줌 C20140416_24713
						    //[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
						    // 쌀화환도 화환처럼 수정
						    if(!e19CongcondData.CONG_CODE.equals("0007") && !e19CongcondData.CONG_CODE.equals("0010")  ) {
						%>
                      <tr>
                        <!--[CSR ID:2584987] 통상임금 -> 기준급  -->
                        <!-- <td width="130" class="td01">통상임금</td> -->
                        <td width="130" class="td01">기준급</td>
                        <td width="130" class="td09"><%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%></td>
                        <td width="130" class="td01">지급률</td>
                        <td width="130" class="td09"><%=e19CongcondData.CONG_RATE%>%</td>
                        <td width="130" class="td01">경조금액</td>
                        <td width="110" class="td09"><%= WebUtil.printNumFormat(e19CongcondData.CONG_WONX) %>원</td>
                      </tr>
                      <tr>
                        <td class="td01">이체은행명</td>
                        <td class="td09"><%= e19CongcondData.BANK_NAME %></td>
                        <td class="td01">은행계좌번호</td>
                        <td class="td09"><%= e19CongcondData.BANKN%></td>
                        <td class="td01">부서계좌번호</td>
                        <td class="td09"><%= e19CongcondData.LIFNR%></td>
                      </tr>
                      <tr>
                        <td class="td01">경조휴가일수</td>
                        <td class="td09">
						<%
						    //  조위 - 부모, 배우자부모이면 "Help 참조"라고 메시지를 보여준다.
						    if( e19CongcondData.CONG_CODE.equals("0003") && (e19CongcondData.RELA_CODE.equals("0002") || e19CongcondData.RELA_CODE.equals("0003")) ) {
						%>
                          Help 참조
						<%  } else {  %>
                          <%= e19CongcondData.HOLI_CONT.equals("") ? "" : WebUtil.printNum(e19CongcondData.HOLI_CONT) %> 일
						<%  }  // end if %>
                          </td>
                        <td class="td01">근속년수</td>
                        <td class="td09"><%= e19CongcondData.WORK_YEAR.equals("00") ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>년
                          <%= e19CongcondData.WORK_MNTH.equals("00") ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>개월</td>
                        <td class="td09">&nbsp;</td>
                        <td class="td09">&nbsp;</td>
                      </tr>
                      <% } // 0007 화환만  통상임금 안보여줌 C20140416_24713 %>

                      <tr>
                        <td class="td01" width="130"><!--@v2.0증빙유무확인-->사실여부확인</td>
                        <td class="td09"><input name="chPROOF" type="checkbox" value="X"></td>
<%  //@v1.1
    if ( (webUserID.equals("EADMIN") || webUserID.equals("EMANAG") )) {
%>
                        <td class="td09"><!--[CSR ID:1225704]@v2.0-->
                        <a href="javascript:goToList_pop()">
                        <img src="<%= WebUtil.ImageURL %>btn_search2_G04.gif" align="absmiddle" border="0" ></a></td>
<%  } else { //@v1.1%>
			<!--@v2.0[CSR ID:1225704]-->
			<td class="td09"><a href="javascript:goToList_pop()">
			<img src="<%= WebUtil.ImageURL %>btn_search2_G04.gif" align="absmiddle" border="0" ></a></td>
<%  } //@v1.1%>

                        <td class="td09">&nbsp;</td>
                        <td class="td09">&nbsp;</td>
                        <td class="td09">&nbsp;</td>
                      </tr>

<%
    Vector G004CongraReason_vt  = (new G004CongraReasonRFC()).getCode( "ZREASON_CD");
    if (  e19CongcondData.CONG_CODE.equals("0002")  &&  !DataUtil.delDateGubn(e19CongcondData.CONG_DATE ).equals(SIXTH_DATE)  ) {

%>
                      <tr id="Reason">
                        <td class="td01">회갑경조일차이사유&nbsp;<font color="#006699"><b>*</b></font></td>
                        <td class="td09" colspan=5>
                        <table  border="0" cellspacing="0" cellpadding="0">
                           <tr>
                             <td>
                             <select name="REASON_CD" class="input03">
                              <option value="">-------------</option>

   <%
    for( int i = 0 ; i < G004CongraReason_vt.size() ; i++ ) {
        G004CongraReasonData data = (G004CongraReasonData)G004CongraReason_vt.get(i);

   %>
        <option value="<%=data.DOMVALUE%>"><%=data.DDTEXT %></option>
   <%
    }
   %>
                             </select></td>
                           </tr>
                        </table>
                        </td>
                      </tr>
   <input type=hidden name="REASON_TEXT" value="">
   <input type=hidden name="RELA_TEXT" value="<%= WebUtil.printOptionText(vcCongRela ,e19CongcondData.RELA_CODE)%>">
   <input type=hidden name="WORK_YEAR_TEXT" value="<%= e19CongcondData.WORK_YEAR.equals("00") ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>년<%= e19CongcondData.WORK_MNTH.equals("00") ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>개월">
   <%
    }else{
   %>
   <input type=hidden name="RELA_TEXT" value="<%= WebUtil.printOptionText(vcCongRela ,e19CongcondData.RELA_CODE)%>">
   <input type=hidden name="REASON_CD" value="">
   <input type=hidden name="REASON_TEXT" value="">
   <input type=hidden name="WORK_YEAR_TEXT" value="<%= e19CongcondData.WORK_YEAR.equals("00") ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>년<%= e19CongcondData.WORK_MNTH.equals("00") ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>개월">
   <%
    }
   %>
                    </table>


            <!--C20140416_24713 주문업체 정보  START-->
					   <%

					   //근무지리스트
					   Vector E19CongraGrubNumb_vt  = (new E19CongraGrubNumbRFC()).getGrupCode(user.companyCode,"010");
					   String ZGRUP_NUMB_O_NM="";
					   String ZGRUP_NUMB_R_NM="";
					   for( int i = 0 ; i < E19CongraGrubNumb_vt.size() ; i++ ){
						   E19CongGrupData  data = (E19CongGrupData)E19CongraGrubNumb_vt.get(i);
						   if (e19CongcondData.ZGRUP_NUMB_O.equals( data.GRUP_NUMB)){
							   ZGRUP_NUMB_O_NM=data.GRUP_NAME;
						   }
						   if (e19CongcondData.ZGRUP_NUMB_R.equals( data.GRUP_NUMB)){
							   ZGRUP_NUMB_R_NM=data.GRUP_NAME;
						   }
					   }

					    //  0007 화환만 주문정보 보여줌 C20140416_24713
					    //	[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
					    //쌀화환도 화환처럼 수정
					    if(e19CongcondData.CONG_CODE.equals("0007") || e19CongcondData.CONG_CODE.equals("0010")  ) {
					   %>		<br>
					            <table border="0" cellpadding="0" cellspacing="1">
					            <tr id="jumunINFO">
					              <td>
					              <table>
					            <tr>
					              <td>&nbsp;</td>
					            </tr>
					            <tr>
					              <td>
					                <table width="780" border="0" cellspacing="0" cellpadding="0">
					                  <tr>
					                    <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 주문자 정보</td>
					                  </tr>
					                </table></td>
					            </tr>
					            <tr>
					              <td class="tr01">
					                <table width="780" border="0" cellspacing="1" cellpadding="2">

					            	<input type="hidden" name="ZPERNR2"   value="<%= e19CongcondData.ZPERNR2 %>"> <!-- 신청자사번 -->
					            	<input type="hidden" name="ZUNAME2"   value="<%= e19CongcondData.ZUNAME2 %>"> <!-- 신청자사번 -->
					            	<input type="hidden" name="ZGRUP_NUMB_O"   value="<%= e19CongcondData.ZGRUP_NUMB_O  %>"><!-- 신청자근무지코드 -->
					                <tr>
					                  <td class="td01" width="130">신청자</td>
					                  <td class="td09" width="255"><%= e19CongcondData.ZUNAME2 %>
					                  </td>
					                  <td class="td01" width="100">근무지명</td>
					                  <td class="td09" width="254"><%=ZGRUP_NUMB_O_NM %>
					                  </td>
					                </tr>
					                 <tr>
					                  <td class="td01">전화번호</td>
					                  <td class="td09"><input type="text" name="ZPHONE_NUM" value="<%=e19CongcondData.ZPHONE_NUM  %>" class="input04"  size="20" maxsize=20 style="text-align:left" readonly>
					                  </td>
					                  <td class="td01">핸드폰<font color="#006699"><b>*</b></font></td>
					                  <td class="td09"><input type="text" name="ZCELL_NUM" value="<%=e19CongcondData.ZCELL_NUM  %>" class="input04"  size="20" maxsize=20 style="text-align:left" readonly>
					                   </td>
					                </tr>
					              </table>
					              </td>
					            </tr>
					            <tr>
					              <td>&nbsp;</td>
					            </tr>

					            <tr>
					              <td>
					                <table width="780" border="0" cellspacing="0" cellpadding="0">
					                  <tr>
					                    <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 배송정보</td>
					                  </tr>
					                </table></td>
					            </tr>
					            	<input type="hidden" name="ZUNAME_R"   value="<%=e19CongcondData.ZUNAME_R %>"><!-- 대상자(직원명) -->
					            	<input type="hidden" name="ZUNION_FLAG"   value="<%=e19CongcondData.ZUNION_FLAG %>"><!-- 대상자(조합원) -->
					            	<input type="hidden" name="ZTRANS_DATE"   value="<%=e19CongcondData.ZTRANS_DATE %>"><!--배송일자 -->
					            	<input type="hidden" name="ZTRANS_TIME"   value="<%=e19CongcondData.ZTRANS_TIME %>"><!-- 배송시간 -->
					            	<input type="hidden" name="ZGRUP_NUMB_R"   value="<%= e19CongcondData.ZGRUP_NUMB_R  %>"><!-- 신청자근무지코드 -->
					            <tr>
					              <td class="tr01">
					                <table width="780" border="0" cellspacing="1" cellpadding="2">

					                <tr>
					                  <td class="td01" width="130">대상자(직원명)</td>
					                  <td class="td09" width="255"><%= phonenum.E_ENAME %>
					                  </td>
					                  <td class="td01" width="100">대상자 연락처<font color="#006699"><b>*</b></font></td>
					                  <td class="td09" width="254"><input type="text" name="ZCELL_NUM_R" value="<%=e19CongcondData.ZCELL_NUM_R  %>" class="input04" size="20" maxsize=20 style="text-align:left" readonly>
					                  </td>
					                </tr>
					                <tr>
					                  <td class="td01">근무지<font color="#006699"><b>*</b></font></td>
					                  <td class="td09"> <%=ZGRUP_NUMB_R_NM %>
					                  </td>
					                  <td class="td01">대상자 부서</td>
					                  <td class="td09"><%= phonenum.E_ORGTX %>
					                   </td>
					                </tr>
					                <!--
					                <tr>
					                  <td class="td01">신분</td>
					                  <td class="td09" colspan=3><%= phonenum.E_PTEXT %> <%= e19CongcondData.ZUNION_FLAG.equals("X") ? "조합원:Y" : "" %>
					                  </td>
					                </tr>-->
					                <tr>
					                  <td class="td01">배송일자<font color="#006699"><b>*</b></font></td>
					                  <td class="td09" colspan=3><%= WebUtil.printDate(e19CongcondData.ZTRANS_DATE,".")%> &nbsp; &nbsp;
					                   <%=   WebUtil.printTime(e19CongcondData.ZTRANS_TIME ) %>
					                  </td>
					                </tr>
					                <tr>
					                  <td class="td01">배송지주소<font color="#006699"><b>*</b></font></td>
					                  <td class="td09" colspan=3><input type="text" name="ZTRANS_ADDR" value="<%=e19CongcondData.ZTRANS_ADDR %>" class="input04" size="80"  maxsize="100" style="text-align:left" readonly>
					                  </td>
					                </tr>
					                <tr>
					                  <td class="td01">기타 요구사항</td>
					                  <td class="td09" colspan=3><input type="text" name="ZTRANS_ETC" value="<%=e19CongcondData.ZTRANS_ETC %>" class="input04" size="80" maxsize="100"  style="text-align:left" readonly>
					                  </td>
					                </tr>
					              </table>
					              </td>
					            </tr>

					            <tr>
					              <td>&nbsp;</td>
					            </tr>
					            <tr>
					              <td>
					                <table width="780" border="0" cellspacing="0" cellpadding="0">
					                  <tr>
					                    <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 업체정보</td>
					                  </tr>
					                </table></td>
					            </tr>
					            <tr>
					              <td class="tr01">
					                <table width="780" border="0" cellspacing="1" cellpadding="2">
					<%

						//CSR ID: 20140416_24713 화환업체
						// [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
						Vector e19CongFlowerInfoData_vt = (new E19CongraFlowerInfoRFC()).getFlowerInfoCode(e19CongcondData.CONG_CODE);



						for( int i = 0 ; i < e19CongFlowerInfoData_vt.size() ; i++ ){
						   E19CongFlowerInfoData  dataF = (E19CongFlowerInfoData)e19CongFlowerInfoData_vt.get(i);
								if (i==0){
					%>
					            	<input type="hidden" name="ZTRANS_SEQ"   value="<%=dataF.ZTRANS_SEQ %>"><!--업체 SEQ-->
					            	<input type="hidden" name="ZTRANS_PSEQ"   value="<%=dataF.ZTRANS_PSEQ %>"><!--담당자 SEQ-->
					                <tr>
					                  <td class="td01" width="130">업체명</td>
					                  <td class="td09" width="255"><%= dataF.ZTRANS_NAME %>
					                  </td>
					                  <td class="td01" width="100">주소</td>
					                  <td class="td09" width="254"><%= dataF.ZTRANS_ADDR %>
					                  </td>
					                </tr>

					                <!-- [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
					                	   for문 밖의 <tr>을 for문 안으로 넣음
					                 -->

					                <tr>
					                  <td class="td01">담당자</td>
					                  <td class="td09"><%= dataF.ZTRANS_UNAME %>
					                  </td>
					                  <td class="td01">연락처</td>
					                  <td class="td09">T e l : <%=dataF.ZPHONE_NUM  %>
					                  <BR>H .P : <%=dataF.ZCELL_NUM  %>
					               <!--   <BR>FAX : <%=dataF.ZFAX_NUM  %>-->
					                   </td>
					                </tr>
					<%		} %>


					<%	} //end for %>
					              </table>
					              </td>
					            </tr>
					            <tr>
					              <td>&nbsp;</td>
					            </tr>

					              </table>
					              </td>
					            </tr>

					            </table>
							<% } //  0007 화환만 주문정보 보여줌 C20140416_24713 %>

					           <!-- C20140416_24713 주문업체정보 END -->


                    </td>
                </tr>
              </table>
              <!-- 리스트테이블 끝-->
            </td>
          </tr>
          <tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
<%
        if (  e19CongcondData.CONG_CODE.equals("0002")  &&  !DataUtil.delDateGubn(e19CongcondData.CONG_DATE ).equals(SIXTH_DATE)  ) {

%>

<!--          <tr>
            <td class="td09"> <font color="red">※ 경조발생일이 생년월일과 차이가 있으므로 결재자께서는 사실 확인을 하여, 확인내용을 "적요"란에 상세히 기재 바랍니다.
              <BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;기재내용을 기준으로 경조금 Data Monitoring을 실시하오니 정확한 확인 및 기재 부탁드립니다.
                   <b>&nbsp;
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>-->
<%
	}
%>
          <tr>
            <td><table border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="830" class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                    적요</td>
                </tr>
              </table></td>
          </tr>
          <tr>
		  <!-- 텍스트필드 시작 -->
            <td class="td03" style="padding-top:5px;padding-bottom:5px"><textarea name="BIGO_TEXT" cols="80" rows="2"></textarea></td>
		  <!-- 텍스트필드 끝 -->
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><table border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="830" class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                    결재정보</td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td>
			<!-- 결재정보 테이블 시작-->
			<!--
			<table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                <tr>
                  <td class="td03">결재자 구분</td>
                  <td class="td03">성명</td>
                  <td class="td03">부서명</td>
                  <td class="td03">직책</td>
                  <td class="td03">승인일</td>
                  <td class="td03">상대</td>
                  <td class="td03">연락처</td>
                </tr>
              </table>
              -->
              <%= AppUtil.getAppDetail(vcAppLineData) %>
			  <!-- 결재정보 테이블 끝-->
			</td>
          </tr>
          <tr>
            <td height="20">&nbsp;</td>
          </tr>
          <tr>
            <td>
              <!--버튼 들어가는 테이블 시작 -->
              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td class="td04">
                  <span id="sc_button">
                  <% if (isCanGoList) {  %>
                    <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                  <% } // end if %>
                    <a href="javascript:approval()"><img src="<%= WebUtil.ImageURL %>btn_submit.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                    <a href="javascript:reject()"><img src="<%= WebUtil.ImageURL %>btn_return.gif" border="0"></a>
                  </span>
                  </td>
                </tr>
              </table>
              <!--버튼 들어가는 테이블 끝 -->
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
<form name="formS" method="post" action="" onsubmit="return false">
<!--  HIDDEN  처리해야할 부분 시작-->
<input type="hidden" name="jobid"     value="pernr">
<input type="hidden" name="I_DEPT"    value="<%= user.empNo   %>">
<input type="hidden" name="E_RETIR"   value="N">
<input type="hidden" name="retir_chk" value="N">
<input type="hidden" name="I_VALUE1"  value="<%=e19CongcondData.PERNR%>">
<input type="hidden" name="I_GUBUN"   value="1">
<!--  HIDDEN  처리해야할 부분 시작-->
</form>
<form name="family_list" method="post">
</form>

<script language="javascript">
<!--
function persNewSet(){
    small_window=window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=100,top=100");

    small_window.focus();
    document.formS.target = "DeptPers";
    //document.formS.action = "/web/common/SearchDeptPersonsWait_m.jsp";
    //document.formS.submit();

    document.formS.action = "/web/common/SearchDeptPersonsPop_m.jsp";
    document.formS.submit();
}
//-->
</script>

</body>
</html>

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 진행중 문서                                            */
/*   Program Name : 경조금 결재 진행중/취소                                     */
/*   Program ID   : G004ApprovalIngCongra.jsp                                   */
/*   Description  : 경조금 결재 진행중/취소                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*                                                                              */
/*                  2014-04-24  [CSR ID:C20140416_24713]  화환신청시 0007 주문업체 정보추가 , 통상임금정보삭제 , 배송업체메일발송,sms추가,초기구분자 추가    */
/*                  2014-07-31  [CSR ID:2584987] HR Center 경조금 신청 화면 문구 수정                                            */
/*                  2016-07-13  [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발 - 김불휘S                            */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
WebUserData     user                = (WebUserData)session.getAttribute("user");
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
    DocumentInfo docinfo = new DocumentInfo(e19CongcondData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
%>

<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr2.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}


   function cancel()
    {
        if(!confirm("취소 하시겠습니까.")) {
            return;
        } // end if
        var frm = document.form1;
        frm.APPR_STAT.value = "";
        frm.submit();
    }

    function goToList()
    {
        var frm = document.form1;
        frm.jobid.value = "";
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
        frm.submit();
    }
//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" id="form1" method="post">
<input type="hidden" name="jobid" value="save">
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

<INPUT TYPE="HIDDEN" NAME="BIGO_TEXT">
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
                  <td width="70" class="td04"><%=phonenum.E_JIKWT%></td>
                  <td width="40" class="td03">직책</td>
                  <td width="70" class="td04"><%=phonenum.E_JIKKB%></td>
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
                        <td class="td09"><%=e19CongcondData.EREL_NAME%></td>
                      </tr>
                      <tr>
                        <td class="td01">경조발생일자</td>
                        <td class="td09"><%=WebUtil.printDate(e19CongcondData.CONG_DATE)%></td>
                        <td class="td09">&nbsp;</td>
                        <td class="td09">&nbsp;</td>
                      </tr>
                    </table>
                    <br />
                    <table border="0" cellpadding="0" cellspacing="1">
						<%
						    //  0007 화환만  통상임금 안보여줌 C20140416_24713
						    if(!e19CongcondData.CONG_CODE.equals("0007")  ) {
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
                        <td width="130" class="td01">사실여부확인</td>
                        <td class="td09"><input name="chPROOF" type="checkbox" <%=e19CongcondData.PROOF.equals("X") ? "checked" : "" %>></td>
                        <td class="td09">&nbsp;</td>
                        <td class="td09">&nbsp;</td>
                        <td class="td09">&nbsp;</td>
                        <td class="td09">&nbsp;</td>
                      </tr>
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
					    if(e19CongcondData.CONG_CODE.equals("0007")  ) {
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
					                <!--<tr>
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
					<%		} %>
					                <tr>
					                  <td class="td01">담당자</td>
					                  <td class="td09"><%= dataF.ZTRANS_UNAME %>
					                  </td>
					                  <td class="td01">연락처</td>
					                  <td class="td09">T e l : <%=dataF.ZPHONE_NUM  %>
					                  <BR>H .P : <%=dataF.ZCELL_NUM  %>
					                  <!--<BR>FAX : <%=dataF.ZFAX_NUM  %>-->
					                   </td>
					                </tr>

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
            boolean visible = false;
            for (int i = 0; i < vcAppLineData.size(); i++) {
                AppLineData ald = (AppLineData) vcAppLineData.get(i);
                if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) {
                    visible = true;
                    break;
                } // end if
            } // end for
       %>
       <%   if (visible) { %>
          <tr>
            <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 적요</td>
          </tr>
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">
                <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
                    <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
                       <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr>
                       <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                       <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
                    </tr>
                    <% } // end if %>
                <% } // end for %>
                </table>
            </td>
          </tr>
        <% } // end if %>
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
                      <% if (isCanGoList) {  %>
                        <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                      <% } // end if %>
                      <% if (docinfo.isHasCancel()) {  %>
                        <a href="javascript:cancel()"><img src="<%= WebUtil.ImageURL %>btn_cancel01.gif" border="0" /></a>&nbsp;&nbsp;&nbsp;
                      <% } // end if %>
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
</body>
</html>

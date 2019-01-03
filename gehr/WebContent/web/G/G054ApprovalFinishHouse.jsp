<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 신규신청 결재                                      */
/*   Program Name : 주택자금 신규신청 결재                                      */
/*   Program ID   : G054ApprovalFinishHouse.jsp                                 */
/*   Description  : 주택자금 신규신청 결재 완료                                 */
/*   Note         :                                                             */
/*   Creation     : 2005-03-10  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E05House.*" %>
<%@ page import="hris.E.E05House.rfc.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    E05HouseData    e05HouseData    = (E05HouseData)request.getAttribute("e05HouseData");
    E05PersInfoData e05PersInfoData = (E05PersInfoData)request.getAttribute("E05PersInfoData");
    Vector       vcAppLineData   = (Vector)request.getAttribute("vcAppLineData");
    String       RequestPageName = (String)request.getAttribute("RequestPageName");

    boolean isCanGoList ;
    if (RequestPageName == null || RequestPageName.equals("")) {
        isCanGoList = false;
    } else {
        isCanGoList = true;
    } // end if


    // 현재 결재자 구분
    DocumentInfo docinfo = new DocumentInfo(e05HouseData.AINF_SEQN ,user.empNo);
    int approvalStep = docinfo.getApprovalStep();
    // 급여계좌 리스트를 구성한다.@v1.0
    E05HouseBankCodeRFC  rfc_bank    = new E05HouseBankCodeRFC(); 
    Vector          e05BankCodeData_vt = rfc_bank.getBankCode();      

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--

function goToList() {
    var frm = document.form1;
    frm.jobid.value ="";
    <% if (RequestPageName != null ) { %>
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
    <% } // end if %>

    frm.submit();
}

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid" value="save">
  <input type="hidden" name="BUKRS" value="<%=user.companyCode%>">

  <input type="hidden" name="PERNR"         value="<%= e05HouseData.PERNR         %>" >
  <input type="hidden" name="BEGDA"         value="<%= e05HouseData.BEGDA         %>" >
  <input type="hidden" name="AINF_SEQN"     value="<%= e05HouseData.AINF_SEQN     %>" >
  <INPUT TYPE="hidden" name="DLART"         value="<%= e05HouseData.DLART         %>" >
  <INPUT TYPE="hidden" name="DATBW"         value="<%= e05HouseData.DATBW         %>" >
  <INPUT TYPE="hidden" name="TILBG"         value="<%= e05HouseData.TILBG         %>" >
  <INPUT TYPE="hidden" name="DLEND"         value="<%= e05HouseData.DLEND         %>" >
  <INPUT TYPE="hidden" name="REQU_MONY"     value="<%= e05HouseData.REQU_MONY     %>" >
  <INPUT TYPE="hidden" name="POST_DATE"     value="<%= e05HouseData.POST_DATE     %>" >
  <INPUT TYPE="hidden" name="BELNR"         value="<%= e05HouseData.BELNR         %>" >
  <input type="hidden" name="ZPERNR"        value="<%= e05HouseData.ZPERNR        %>" >
  <input type="hidden" name="ZUNAME"        value="<%= e05HouseData.ZUNAME        %>" >
  <input type="hidden" name="AEDTM"         value="<%= e05HouseData.AEDTM         %>" >
  <input type="hidden" name="UNAME"         value="<%= e05HouseData.UNAME         %>" >
  <INPUT TYPE="hidden" name="ZZFUND_CODE"   value="<%= e05HouseData.ZZFUND_CODE   %>" >
  <INPUT TYPE="hidden" name="DARBT"         value="<%= e05HouseData.DARBT         %>" >
  <INPUT TYPE="hidden" name="MONY_RATE"     value="<%= e05HouseData.MONY_RATE     %>" >
  <INPUT TYPE="hidden" name="ZAHLD"         value="<%= e05HouseData.ZAHLD         %>" >
  <INPUT TYPE="hidden" name="ZZRPAY_MNTH"   value="<%= e05HouseData.ZZRPAY_MNTH   %>" >
  <INPUT TYPE="hidden" name="ZZRPAY_CONT"   value="<%= e05HouseData.ZZRPAY_CONT   %>" >
  <INPUT TYPE="hidden" name="TILBT"         value="<%= e05HouseData.TILBT         %>" >
  <INPUT TYPE="hidden" name="REFN_BEGDA"    value="<%= e05HouseData.REFN_BEGDA    %>" >
  <INPUT TYPE="hidden" name="REFN_ENDDA"    value="<%= e05HouseData.REFN_ENDDA    %>" >
  <INPUT TYPE="hidden" name="ZZHIRE_TELX"   value="<%= e05HouseData.ZZHIRE_TELX   %>" >
  <INPUT TYPE="hidden" name="ZZHIRE_MOBILE" value="<%= e05HouseData.ZZHIRE_MOBILE %>" >
  <INPUT TYPE="hidden" name="ZZSECU_FLAG"   value="<%= e05HouseData.ZZSECU_FLAG   %>" >
  <INPUT TYPE="hidden" name="PROOF"         value="<%= e05HouseData.PROOF         %>" >
  <INPUT TYPE="hidden" name="ZZSECU_NAME"   value="<%= e05HouseData.ZZSECU_NAME   %>" >
  <INPUT TYPE="hidden" name="ZZRELA_CODE"   value="<%= e05HouseData.ZZRELA_CODE   %>" >
  <INPUT TYPE="hidden" name="ZZSECU_REGNO"  value="<%= e05HouseData.ZZSECU_REGNO  %>" >
  <INPUT TYPE="hidden" name="ZZSECU_TELX"   value="<%= e05HouseData.ZZSECU_TELX   %>" >
  <INPUT TYPE="hidden" name="MNTH_INTEREST" value="<%= e05HouseData.MNTH_INTEREST %>" >
  <INPUT TYPE="hidden" name="ZZSECU_NAME2"   value="<%= e05HouseData.ZZSECU_NAME2   %>" >
  <INPUT TYPE="hidden" name="ZZRELA_CODE2"   value="<%= e05HouseData.ZZRELA_CODE2   %>" >
  <INPUT TYPE="hidden" name="ZZSECU_REGNO2"  value="<%= e05HouseData.ZZSECU_REGNO2  %>" >
  <INPUT TYPE="hidden" name="ZZSECU_TELX2"   value="<%= e05HouseData.ZZSECU_TELX2   %>" >

  <input type="hidden" name="APPR_STAT">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
  <input type="hidden" name="approvalStep" value="<%=approvalStep%>">

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
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">주택자금신규신청
                    결재완료 문서 </td>
                  <td align="right" style="padding-bottom:4px"><a href="javascript:open_help('E05House.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
                  </td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td height="10">
              <!-- 신청자 기본 정보 시작 -->
              <%@ include file="/web/common/ApprovalIncludePersInfo.jsp" %>
              <!--  신청자 기본 정보 끝-->
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td>
              <!-- 상단 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr>
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          신청정보 </td>
                      </tr>
                      <tr>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                              <td class="td01">주택융자유형</td>
                              <td class="td09" colspan="3">
                                <%= WebUtil.printOptionText((new E05LoanCodeRFC()).getLoanType(), e05HouseData.DLART) %>
                            </tr>
                            <tr>
                              <td class="td01" width="100">현주소</td>
                              <td class="td09" colspan="3"><%= e05PersInfoData.E_STRAS %></td>
                            </tr>
                            <tr>
                              <td class="td01">근속년수</td>
                              <td width="220" class="td09"><%= e05PersInfoData.E_YEARS %> 년 </td>
                              <td class="td01" width="100" >신청은행</td>
                              <td class="td09" style="text-align:left">
<%
    for(int i = 0 ; i < e05BankCodeData_vt.size() ; i++){
        E05HouseBankCodeData data_bank = (E05HouseBankCodeData)e05BankCodeData_vt.get(i);
%>
     <%=data_bank.BANK_CODE.equals(e05HouseData.BANK_CODE) ? data_bank.BANK_NAME : "" %>
<%
    }
%>
                              </td>                            </tr>
                            <tr>
                              <td class="td01">자금용도</td>
                              <td class="td09">
<%  //CSR ID:1327268             
    Vector E05FundCode_vt  = (new E05FundCodeRFC()).getFundCode();
        
    for( int i = 0 ; i < E05FundCode_vt.size() ; i++ ) {
        E05FundCodeData dt = (E05FundCodeData)E05FundCode_vt.get(i); 
        if ( e05HouseData.DLART.equals(dt.DLART)&& e05HouseData.ZZFUND_CODE.equals(dt.FUND_CODE)) {
%>
           <%=dt.FUND_TEXT%>
<%
        }
    }
%>
                              </td>
                              
                              <td width="100" class="td01">신청금액</td>
                              <td class="td09"><%= WebUtil.printNumFormat(Double.parseDouble(e05HouseData.REQU_MONY)*100) %> 원 </td>
                              
                            </tr>
                            <tr>
                              <td class="td01">보증여부</td>
                              <td colspan="3" class="td09">
                                <%  if( e05HouseData.ZZSECU_FLAG.equals("Y") ) {  %>
                                연대보증인 입보
                                <%  } else if( e05HouseData.ZZSECU_FLAG.equals("N") ) {  %>
                                보증보험가입희망
                                <%  } else if( e05HouseData.ZZSECU_FLAG.equals("C") ) {  %>
                                신용보증
                                <%  } %>
                               </td>
                            </tr>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <%
                  // ***** 업무담당자와 업무담당 부서장만 보여준다. ********************************************
                  if( approvalStep == DocumentInfo.DUTY_CHARGER || approvalStep == DocumentInfo.DUTY_MANGER ) {
              %>
              <!-- 상단 테이블 끝-->
              <table width="780" border="0" cellspacing="0" cellpadding="0" >
                <tr>
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
                <tr>
                  <td class="tr01"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                          담당자입력</td>
                      </tr>
                      <tr>
                        <td>
                          <!--담당자입력 테이블 시작-->
                          <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                              <td class="td01" width="100">대출승인금액</td>
                              <td width="170" class="td09">
                                <%= e05HouseData.DARBT.equals("0") ? WebUtil.printNumFormat(Double.parseDouble(e05HouseData.REQU_MONY)*100) : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.DARBT)*100) %> 원 </td>
                              <td class="td01" width="100">개별금리</td>
                              <td class="td09">
                                <%= e05HouseData.MONY_RATE.equals("000") ? "1" : WebUtil.printNumFormat(e05HouseData.MONY_RATE) %>%</td>
                              <td class="td01" width="100">지급일</td>
                              <td class="td09">
                                <%= e05HouseData.ZAHLD.equals("0000-00-00")||e05HouseData.ZAHLD.equals("") ? "" : WebUtil.printDate(e05HouseData.ZAHLD, ".") %></td>
                            </tr>
                            <tr>
                              <td class="td01">상환기간</td>
                              <td class="td09" colspan="5">
                                <%= e05HouseData.ZZRPAY_MNTH.equals("000000") ? "" : e05HouseData.ZZRPAY_MNTH %> 부터
                                <%= e05HouseData.ZZRPAY_CONT.equals("00") ? "" : e05HouseData.ZZRPAY_CONT %> 년</td>
                            </tr>
                            <tr>
                              <td class="td01">월상환원금</td>
                              <td class="td09">
                                <%= e05HouseData.TILBT.equals("0") ? "" : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.TILBT)*100) %> 원 </td>
                              <td class="td01">원상환시작</td>
                              <td class="td09">
                                <%= e05HouseData.REFN_BEGDA.equals("0000-00-00")||e05HouseData.REFN_BEGDA.equals("") ? "" : WebUtil.printDate(e05HouseData.REFN_BEGDA, ".") %></td>
                              <td class="td01">월상환종료</td>
                              <td class="td09">
                                <%= e05HouseData.REFN_ENDDA.equals("0000-00-00")||e05HouseData.REFN_ENDDA.equals("") ? "" : WebUtil.printDate(e05HouseData.REFN_ENDDA, ".") %></td>
                            </tr>
                            <tr>
                              <td class="td01">월상환이자</td>
                              <td colspan="5" class="td09">
                                <%= e05HouseData.MNTH_INTEREST.equals("0") ? "" : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.MNTH_INTEREST)*100) %> 원 </td>
                            </tr>
                            <tr>
                              <td class="td01">신청자연락처</td>
                              <td colspan="5" class="td09">
                                <%= e05HouseData.ZZHIRE_TELX %>&nbsp;&nbsp;/&nbsp;&nbsp;
                                <%= e05HouseData.ZZHIRE_MOBILE %></td>
                            </tr>
                            <tr>
                              <td class="td01">보증여부</td>
                              <td class="td09">
                                <%  if( e05HouseData.ZZSECU_FLAG.equals("Y") ) {  %>
                                보증인
                                <%  } else if( e05HouseData.ZZSECU_FLAG.equals("N") ) {  %>
                                보증보험
                                <%  } else if( e05HouseData.ZZSECU_FLAG.equals("C") ) {  %>
                                신용보증
                                <%  } %>
                              </td>
                              <td class="td01">증빙확인</td>
                              <td colspan="5" class="td09">
                                <input name="PROOF" type="checkbox" value="" <%= e05HouseData.PROOF.equals("X") ? "checked" : "" %> class="input03" disabled></td>
                            </tr>
                          </table>
                          <!--담당자입력 테이블 끝-->
                        </td>
                      </tr>
	                  <%  if ( approvalStep != DocumentInfo.POST_MANGER ) { // 업무담당자, 업무담당부서장이고 %>
	                  <%      if ( e05HouseData.ZZSECU_FLAG.equals("Y") ) { // 보증인 일때만 보여줌 %>
                      <tr>
                        <td>
                          <table id="guarantee">
                              <tr>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">
                                  보증인 인적사항</td>
                              </tr>
                              <tr>
                                <td>
                                  <!--보증인 인적사항 테이블 시작-->
                                  <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                    <tr>
                                      <td class="td01">성명</td>
                                      <td width="230" class="td09">
                                        <%= e05HouseData.ZZSECU_NAME %>
                                      </td>
                                      <td class="td01">관계</td>
                                      <td class="td09">
                                        <%= WebUtil.printOptionText((new A12FamilyRelationRFC()).getFamilyRelation(""), e05HouseData.ZZRELA_CODE) %>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td class="td01" width="100">주민등록번호</td>
                                      <td class="td09">
<%        String REGNO_dis = e05HouseData.ZZSECU_REGNO.substring(0, 6) + "-*******";
%>                                                            
                                      <%=REGNO_dis%>                                         
                                      </td>
                                      <td class="td01">연락처</td>
                                      <td class="td09">
                                        <%= e05HouseData.ZZSECU_TELX %>
                                      </td>
                                    </tr>
                                  </table>
                                  <!--보증인 인적사항 테이블 끝-->
                                <% if(Double.parseDouble(e05HouseData.REQU_MONY)*100>20000000.0){%>
		                              <!--보증인(2) 인적사항 테이블 시작-->
                                  <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                    <tr>
                                      <td class="td01">성명</td>
                                      <td width="230" class="td09">
                                        <%= e05HouseData.ZZSECU_NAME2 %>
                                      </td>
                                      <td class="td01">관계</td>
                                      <td class="td09">
                                        <%= WebUtil.printOptionText((new A12FamilyRelationRFC()).getFamilyRelation(""), e05HouseData.ZZRELA_CODE2) %>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td class="td01" width="100">주민등록번호</td>
                                      <td class="td09">
                                        <%= DataUtil.addSeparate(e05HouseData.ZZSECU_REGNO2) %>
                                      </td>
                                      <td class="td01">연락처</td>
                                      <td class="td09">
                                        <%= e05HouseData.ZZSECU_TELX2 %>
                                      </td>
                                    </tr>
                                  </table>
		                              <!--보증인(2) 인적사항 테이블 끝-->
                                <% } %>
                                </td>
                              </tr>
                          </table>
                        </td>
                      </tr>
	                  <%      } // end if %>
	                  <%  } // end if %>
                    </table></td>
                </tr>
              </table>
              <!-- 상단 테이블 끝-->
            </td>
          </tr>
              <%
                  }
              %>
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
         <%  if (visible) { %>
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
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 
                    결재정보</td>
                </tr>
                <tr> 
                  <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td> 
                          <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(vcAppLineData) %>
                          <!--결재정보 테이블 끝-->
                        </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">
                  <!--버튼 들어가는 테이블 시작 -->
                      <table width="780" border="0" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td class="td04">
                          <% if (isCanGoList) {  %>
                            <a href="javascript:goToList()"><img src="<%= WebUtil.ImageURL %>btn_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
                          <% } // end if %>
                          </td>
                        </tr>
                      </table>
                  <!--버튼 들어가는 테이블 끝 -->
                  </td>
                  <!--버튼끝-->
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
              </table></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  </form>

<%@ include file="/web/common/commonEnd.jsp" %>

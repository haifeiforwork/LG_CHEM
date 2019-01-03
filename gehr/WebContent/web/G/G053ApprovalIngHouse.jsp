<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 신규신청 결재                                      */
/*   Program Name : 주택자금 신규신청 결재                                      */
/*   Program ID   : G053ApprovalIngHouse.jsp                                    */
/*   Description  : 주택자금 신규신청 결재 취소                                 */
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
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<script language="JavaScript">
<!--
function cancel()
{
    var frm = document.form1;

<%  if ( approvalStep == DocumentInfo.DUTY_CHARGER || approvalStep == DocumentInfo.DUTY_MANGER) { %>

    if ( document.form1.PROOF.disabled == true ) {
        document.form1.PROOF.disabled = false;
    }

    frm.DARBT.value = removeComma(frm.DARBT.value)/100;
    frm.TILBT.value = removeComma(frm.TILBT.value)/100;
    frm.MNTH_INTEREST.value = removeComma(frm.MNTH_INTEREST.value)/100;
    frm.ZAHLD.value = changeChar( frm.ZAHLD.value, ".", "-" );
    frm.REFN_BEGDA.value = changeChar( frm.REFN_BEGDA.value, ".", "-" );
    frm.REFN_ENDDA.value = changeChar( frm.REFN_ENDDA.value, ".", "-" );
    frm.ZZSECU_REGNO.value = changeChar( frm.ZZSECU_REGNO.value, "-", "" );
    frm.ZZSECU_REGNO2.value = changeChar( frm.ZZSECU_REGNO2.value, "-", "" );
<%  } %>


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
        frm.jobid.value ="";
    <% if (RequestPageName != null ) { %>
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
    <% } // end if %>

        frm.submit();
}
function firstHideshow() {
<%  if ( approvalStep != DocumentInfo.POST_MANGER ) { %>
<%      if ( e05HouseData.ZZSECU_FLAG.equals("Y") ) { %>
        guarantee.style.display = "block";
<%      } else { %>
        guarantee.style.display = "none";
<%      } // end if %>
<%  } // end if %>
}

//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:firstHideshow();">
<form name="form1" method="post" action="">
  <input type="hidden" name="jobid" value="save">
  <input type="hidden" name="APPU_TYPE" value="<%=docinfo.getAPPU_TYPE()%>">
  <input type="hidden" name="APPR_SEQN" value="<%=docinfo.getAPPR_SEQN()%>">
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
                  <td class="subhead"><h2>주택자금신규신청 결재진행 중 문서</h2></td>
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
              <table width="780" border="0" cellspacing="1" cellpadding="5" >
                <tr>
                  <td class="tr01">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  	<tr>
                  		<td>
		                  	<div class="buttonArea">
		                  		<ul class="btn_crud">
                        		<% if (docinfo.isHasCancel()) {  %>
		                  			<li><a class="darken" href="javascript:cancel()"><span>결재취소</span></a></li>
		                          <% } // end if %>
		                          <% if (isCanGoList) {  %>
		                          	<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
		                  			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
		                          <% } // end if %>
		                  		</ul>
		                  	</div>
                  		</td>
                  	</tr>
                      <tr>
                        <td><h2 class="subtitle">신청정보</h2></td>
                      </tr>
                      <tr>
                        <td>
                        <div class="tableArea">
                        <table class="tableGeneral">
                            <tr>
                              <th width="100">주택융자유형</th>
                              <td colspan="3">
                                <%= WebUtil.printOptionText((new E05LoanCodeRFC()).getLoanType(), e05HouseData.DLART) %>
                               </td>
                            </tr>
                            <tr>
                              <th>현주소</th>
                              <td colspan="3"><%= e05PersInfoData.E_STRAS %></td>
                            </tr>
                            <tr>
                              <th>근속년수</th>
                              <td width="260"><%= e05PersInfoData.E_YEARS %> 년 </td>
                              <th class="th02" width="100" >신청은행</th>
                              <td>
<%
    for(int i = 0 ; i < e05BankCodeData_vt.size() ; i++){
        E05HouseBankCodeData data_bank = (E05HouseBankCodeData)e05BankCodeData_vt.get(i);
%>
     <%=data_bank.BANK_CODE.equals(e05HouseData.BANK_CODE) ? data_bank.BANK_NAME : "" %>
<%
    }
%>
                              </td>
                            </tr>
                            <tr>
                              <th>자금용도</th>
                              <td>
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
                              <th class="th02">신청금액</th>
                              <td><%= WebUtil.printNumFormat(Double.parseDouble(e05HouseData.REQU_MONY)*100) %> 원 </td>
                            </tr>
                            <tr>
                              <th>보증여부</th>
                              <td colspan="3">
                                <%  if( e05HouseData.ZZSECU_FLAG.equals("Y") ) {  %>
                                연대보증인 입보
                                <%  } else if( e05HouseData.ZZSECU_FLAG.equals("N") ) {  %>
                                보증보험가입희망
                                <%  } else if( e05HouseData.ZZSECU_FLAG.equals("C") ) {  %>
                                신용보증
                                <%  } %>
                               </td>
                            </tr>
                          </table>
                          </div>
                          </td>
                      </tr>
                    </table>

                    </td>
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
                        <td><h2 class="subtitle">담당자입력</h2></td>
                      </tr>
                      <tr>
                        <td>
                          <!--담당자입력 테이블 시작-->
                          <div class="tableArea">
                          <table class="tableGeneral">
                            <tr>
                              <th width="100">대출승인금액</th>
                              <td width="170">
                                <%= e05HouseData.DARBT.equals("0") ? WebUtil.printNumFormat(Double.parseDouble(e05HouseData.REQU_MONY)*100) : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.DARBT)*100) %></td>
                              <th class="th02" width="100">개별금리</th>
                              <td>
                                <%= e05HouseData.MONY_RATE.equals("000") ? "1" : WebUtil.printNumFormat(e05HouseData.MONY_RATE) %>%</td>
                              <th class="th02" width="100">지급일</th>
                              <td>
                                <%= e05HouseData.ZAHLD.equals("0000-00-00")||e05HouseData.ZAHLD.equals("") ? "" : WebUtil.printDate(e05HouseData.ZAHLD, ".") %></td>
                            </tr>
                            <tr>
                              <th>상환기간</th>
                              <td colspan="5">
                                <%= e05HouseData.ZZRPAY_MNTH.equals("000000") ? "" : e05HouseData.ZZRPAY_MNTH %> 부터
                                <%= e05HouseData.ZZRPAY_CONT.equals("00") ? "" : e05HouseData.ZZRPAY_CONT %> 년</td>
                            </tr>
                            <tr>
                              <th>월상환원금</th>
                              <td>
                                <%= e05HouseData.TILBT.equals("0") ? "" : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.TILBT)*100) %>
                              </td>
                              <th class="th02">원상환시작</th>
                              <td>
                                <%= e05HouseData.REFN_BEGDA.equals("0000-00-00")||e05HouseData.REFN_BEGDA.equals("") ? "" : WebUtil.printDate(e05HouseData.REFN_BEGDA, ".") %></td>
                              <th class="th02">월상환종료</th>
                              <td>
                                <%= e05HouseData.REFN_ENDDA.equals("0000-00-00")||e05HouseData.REFN_ENDDA.equals("") ? "" : WebUtil.printDate(e05HouseData.REFN_ENDDA, ".") %></td>
                            </tr>
                            <tr>
                              <th>월상환이자</th>
                              <td colspan="5">
                                <%= e05HouseData.MNTH_INTEREST.equals("0") ? "" : WebUtil.printNumFormat(Double.parseDouble(e05HouseData.MNTH_INTEREST)*100) %></td>
                            </tr>
                            <tr>
                              <th>신청자연락처</th>
                              <td colspan="5">
                                <%= e05HouseData.ZZHIRE_TELX %>&nbsp;&nbsp;/&nbsp;&nbsp;
                                <%= e05HouseData.ZZHIRE_MOBILE %>
                              </td>
                            </tr>
                            <tr>
                              <th>보증여부</th>
                              <td>
                                <%  if( e05HouseData.ZZSECU_FLAG.equals("Y") ) {  %>
                                보증인
                                <%  } else if( e05HouseData.ZZSECU_FLAG.equals("N") ) {  %>
                                보증보험
                                <%  } else if( e05HouseData.ZZSECU_FLAG.equals("C") ) {  %>
                                신용보증
                                <%  } %>
                              </td>
                              <th class="th02">증빙확인</th>
                              <td colspan="3">
                                <input name="PROOF" type="checkbox" value="" <%= e05HouseData.PROOF.equals("X") ? "checked" : "" %> class="input03" disabled>
                               </td>
                            </tr>
                          </table>
                          </div>
                          <!--담당자입력 테이블 끝-->
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <table id="guarantee">
                              <tr>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td><h2 class="subtitle">보증인 인적사항</h2></td>
                              </tr>
                              <tr>
                                <td>
                                  <!--보증인 인적사항 테이블 시작-->
                                  <div class="tableArea">
                                  <table class="tableGeneral">
                                    <tr>
                                      <th>성명</th>
                                      <td width="230">
                                        <%= e05HouseData.ZZSECU_NAME %>
                                      </td>
                                      <th class="th02">관계</th>
                                      <td>
                                        <%= WebUtil.printOptionText((new A12FamilyRelationRFC()).getFamilyRelation(""), e05HouseData.ZZRELA_CODE) %>
                                      </td>
                                    </tr>
                                    <tr>
                                      <th width="100">주민등록번호</th>
                                      <td>
<%        String REGNO_dis = e05HouseData.ZZSECU_REGNO.substring(0, 6) + "-*******";
%>
                                      <%=REGNO_dis%>
                                      </td>
                                      <th class="th02">연락처</th>
                                      <td>
                                        <%= e05HouseData.ZZSECU_TELX %>
                                      </td>
                                    </tr>
                                  </table>
                                  </div>
                                  <!--보증인 인적사항 테이블 끝-->
                                <% if(Double.parseDouble(e05HouseData.REQU_MONY)*100>20000000.0){%>
		                              <!--보증인(2) 인적사항 테이블 시작-->
		                          <div class="tableArea">
	                                  <table class="tableGeneral">
	                                    <tr>
	                                      <th>성명</th>
	                                      <td width="230">
	                                        <%= e05HouseData.ZZSECU_NAME2 %>
	                                      </td>
	                                      <th class="th02">관계</th>
	                                      <td>
	                                        <%= WebUtil.printOptionText((new A12FamilyRelationRFC()).getFamilyRelation(""), e05HouseData.ZZRELA_CODE2) %>
	                                      </td>
	                                    </tr>
	                                    <tr>
	                                      <th width="100">주민등록번호</th>
	                                      <td>
	                                        <%= e05HouseData.ZZSECU_REGNO.equals("") ? "" : DataUtil.addSeparate(e05HouseData.ZZSECU_REGNO2) %>
	                                      </td>
	                                      <th class="th02">연락처</th>
	                                      <td>
	                                        <%= e05HouseData.ZZSECU_TELX2 %>
	                                      </td>
	                                    </tr>
	                                  </table>
                                  </div>
		                              <!--보증인(2) 인적사항 테이블 끝-->
                                <% } %>
                                </td>
                              </tr>
                          </table>
                        </td>
                      </tr>
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
          <tr>
            <td><h2 class="subtitle">적요</h2></td>
          </tr>
        <%
            String tmpBigo = "";
        %>
        <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
           <% AppLineData ald = (AppLineData) vcAppLineData.get(i); %>
           <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                <% if (ald.APPL_PERNR.equals(user.empNo)) { %>
                    <% tmpBigo = ald.APPL_BIGO_TEXT; %>
                <% } else { %>
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1" class="table03">

                    <tr>
                       <td width="80" class="td03"><%=ald.APPL_ENAME%></td>
                       <td class="td09"><%=ald.APPL_BIGO_TEXT%></td>
                    </tr>
                </table>
            </td>
          </tr>
                <% } // end if %>
            <% } // end if %>
        <% } // end for %>
          <tr>
            <td>
            	<div class="tableArea">
            		<table class="tableGeneral">
            			<tr>
            				<td><textarea name="BIGO_TEXT" cols="100" rows="4"><%=tmpBigo%></textarea></td>
            			</tr>
                	</table>
                </div>
            </td>
          </tr>
          <tr>
            <td> <table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td><h2 class="subtitle">결재정보</h2></td>
                </tr>
                <tr>
                  <td>
                  <table width="780" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>
                          <!--결재정보 테이블 시작-->
                          <%= AppUtil.getAppDetail(vcAppLineData) %>
                          <!--결재정보 테이블 끝-->
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
                  <!--버튼 들어가는 테이블 시작 -->
                    <table width="780" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td>
		                  	<div class="buttonArea">
		                  		<ul class="btn_crud">
                        		<% if (docinfo.isHasCancel()) {  %>
		                  			<li><a class="darken" href="javascript:cancel()"><span>결재취소</span></a></li>
		                          <% } // end if %>
		                          <% if (isCanGoList) {  %>
		                          	<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  align="absmiddle" border="0" />
		                  			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
		                          <% } // end if %>
		                  		</ul>
		                  	</div>
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

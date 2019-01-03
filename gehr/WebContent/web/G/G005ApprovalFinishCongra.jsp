<%/******************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재                                                     */
/*   2Depth Name  : 결재 완료 문서                                              */
/*   Program Name : 경조금 결재 완료                                            */
/*   Program ID   : G005ApprovalFinishCongra.jsp                                */
/*   Description  : 경조금 결재 완료                                            */
/*   Note         : 없음                                                        */
/*   Creation     : 2003-03-26  이승희                                          */
/*   Update       : 2003-03-26  이승희                                          */
/*                  2014-04-24  [CSR ID:C20140416_24713]  화환신청시 0007 주문업체 정보추가 , 통상임금정보삭제 , 배송업체메일발송,sms추가,초기구분자 추가    */
/*                  2014-07-31  [CSR ID:2584987] HR Center 경조금 신청 화면 문구 수정                                            */
/*                  2016-07-13  [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발 - 김불휘S                            */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>

<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData     user                = (WebUserData)session.getAttribute("user");
    E19CongcondData e19CongcondData     = (E19CongcondData)request.getAttribute("E19CongcondData");
    Vector          vcAppLineData       = (Vector) request.getAttribute("vcAppLineData");

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

%>

<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr2.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

    function goToList()
    {
        var frm = document.form1;
        frm.jobid.value ="";
        frm.action = "<%=RequestPageName.replace('|' ,'&')%>";
        frm.submit();
    }
//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" id="form1" method="post">
<input type="hidden" name="RequestPageName" value="<%=RequestPageName%>">
<input type="hidden" name="jobid" value="save">
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
                  <td class="subhead"><h2>경조금신청 결재완료</h2></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
             <!-- 신청자 기본 정보 시작 -->
            <%
                PersonData phonenum            = (PersonData) request.getAttribute("PersInfoData");
            %>
            	<div class="tableArea">
	              <table class="tableGeneral">
	                <tr>
	                  <th width="40">사번</th>
	                  <td width="80"><%=phonenum.E_PERNR%></td>
		                <th width="40" class="th02">성명</th>
		                <td width="70"><%=phonenum.E_ENAME%></td>
		                <th width="40" class="th02">직위</th>
		                <td width="70"><%=phonenum.E_JIKWT%></td>
		                <th width="40" class="th02">직책</th>
		                <td width="70"><%=phonenum.E_JIKKT%></td>
		                <th width="40" class="th02">부서</th>
		                <td><%=phonenum.E_ORGTX%></td>
	                </tr>
	              </table>
              	</div>
             <!--  신청자 기본 정보 끝-->
            </td>
          </tr>
          <tr>
          	<td>
	           	<div class="buttonArea">
	           		<ul class="btn_crud">
	                   <% if (isCanGoList) {  %>
	           			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
	                   <% } // end if %>
	           		</ul>
	           	</div>
          	</td>
          </tr>
          <tr>
            <td>
              <!-- 리스트테이블 시작 -->
                  <div class="tableArea">
	                  <table class="tableGeneral">
	                      <tr>
	                        <th width="100">신청일</th>
	                        <td width="260"><%=WebUtil.printDate(e19CongcondData.BEGDA)%></td>
	                        <th width="100" class="th02">경조내역</th>
	                        <td><%= WebUtil.printOptionText(vcCongCode ,e19CongcondData.CONG_CODE)%></td>
	                      </tr>
	                      <tr>
	                        <th>경조대상자 관계</th>
	                        <td><%= WebUtil.printOptionText(vcCongRela ,e19CongcondData.RELA_CODE)%></td>
	                        <th class="th02">경조대상자 성명</th>
	                        <td><%=e19CongcondData.EREL_NAME%></td>
	                      </tr>
	                      <tr>
	                        <th>경조발생일자</th>
	                        <td colspan="3"><%=WebUtil.printDate(e19CongcondData.CONG_DATE)%></td>
	                      </tr>
	                    </table>
                    </div>

                    <div class="tableArea">
                    <table class="tableGeneral">

<%
	boolean app = false;
	for (int i = 0; i < vcAppLineData.size(); i++) {
		AppLineData ald = (AppLineData) vcAppLineData.get(i);
//		out.println( ald.APPL_PERNR );
//		out.println( user.empNo );
//		out.println( e19CongcondData.PERNR );

		if (ald.APPL_PERNR.equals( user.empNo ) ) {
			app = true;
//    	    out.println( app );
			break;
		}
	} // end for
%>

						<%
						    //  0007 화환만  통상임금 안보여줌 C20140416_24713
						    //	[CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
						    // 쌀화환을 화환과 같도록 수정
						    if(!e19CongcondData.CONG_CODE.equals("0007") && !e19CongcondData.CONG_CODE.equals("0010")  ) {
						%>

<%
	if ( user.empNo.equals( e19CongcondData.PERNR )  || ( app == true ) ) {
%>
                      <tr>
                        <!--[CSR ID:2584987] 통상임금 -> 기준급  -->
                        <!-- <td width="130" class="td01">통상임금</td> -->
                        <th width="100">기준급</th>
                        <td width="130"><%=WebUtil.printNumFormat(e19CongcondData.WAGE_WONX)%></td>
                        <th width="100" class="th02">지급률</th>
                        <td width="130"><%=e19CongcondData.CONG_RATE%>%</td>
                        <th width="100" class="th02">경조금액</th>
                        <td><%= WebUtil.printNumFormat(e19CongcondData.CONG_WONX) %>원</td>
                      </tr>
<%
        } else {
%>
                      <tr>
                        <th width="100">경조금액</th>
                        <td><%= WebUtil.printNumFormat(e19CongcondData.CONG_WONX) %>원</td>
                      </tr>
<%
			  }
%>

					  <tr>
                        <th>이체은행명</th>
                        <td><%= e19CongcondData.BANK_NAME %></td>
                        <th class="th02">은행계좌번호</th>
                        <td><%= e19CongcondData.BANKN%></td>
                        <th class="th02">부서계좌번호</th>
                        <td><%= e19CongcondData.LIFNR%></td>
                      </tr>
                      <tr>
                        <th>경조휴가일수</th>
                        <td>
						<%
						    //  조위 - 부모, 배우자부모이면 "Help 참조"라고 메시지를 보여준다.
						    if( e19CongcondData.CONG_CODE.equals("0003") && (e19CongcondData.RELA_CODE.equals("0002") || e19CongcondData.RELA_CODE.equals("0003")) ) {
						%>
                          Help 참조
						<%  } else {  %>
                          <%= e19CongcondData.HOLI_CONT.equals("") ? "" : WebUtil.printNum(e19CongcondData.HOLI_CONT) %> 일
						<%  }  // end if %>
                          </td>
                        <th class="th02">근속년수</th>
                        <td colspan="3"><%= e19CongcondData.WORK_YEAR.equals("00") ? "" : WebUtil.printNum(e19CongcondData.WORK_YEAR) %>년
                          <%= e19CongcondData.WORK_MNTH.equals("00") ? "" : WebUtil.printNum(e19CongcondData.WORK_MNTH) %>개월
                        </td>
                      </tr>

                      <% } // 0007 화환만  통상임금 안보여줌 C20140416_24713 %>

                      <tr>
                        <th>사실여부확인</th>
                        <%
                            String checked = "";
                            if ("X".equals(e19CongcondData.PROOF)) {
                                checked = "checked";
                            } // end if
                        %>
                        <td><input name="chPROOF" type="checkbox" value="X" <%=checked%>></td>
			<%
			    //  0007 화환만  회계전표번호생성안됨
			    // [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
			    // 쌀화환도 전표 생성 안되도록 수정
			    if(!e19CongcondData.CONG_CODE.equals("0007") && !e19CongcondData.CONG_CODE.equals("0010") ) {
			%>

                        <th class="th02">회계전표번호</th>
                        <td colspan="3"><%=e19CongcondData.BELNR%></td>
                        <% } %>
                      </tr>
                    </table>
                    </div>

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
					    // 살화환도 보이도록 수정
					    if(e19CongcondData.CONG_CODE.equals("0007") || e19CongcondData.CONG_CODE.equals("0010")  ) {
					   %>

					              <h2 class="subtitle">주문자 정보</h2>
					              <div class="tableArea">
					                <table class="tableGeneral">

					            	<input type="hidden" name="ZPERNR2"   value="<%= e19CongcondData.ZPERNR2 %>"> <!-- 신청자사번 -->
					            	<input type="hidden" name="ZUNAME2"   value="<%= e19CongcondData.ZUNAME2 %>"> <!-- 신청자사번 -->
					            	<input type="hidden" name="ZGRUP_NUMB_O"   value="<%= e19CongcondData.ZGRUP_NUMB_O  %>"><!-- 신청자근무지코드 -->
					                <tr>
					                  <th width="100">신청자</th>
					                  <td width="260"><%= e19CongcondData.ZUNAME2 %></td>
					                  <th class="th02" width="100">근무지명</th>
					                  <td><%=ZGRUP_NUMB_O_NM %></td>
					                </tr>
					                 <tr>
					                  <th>전화번호</th>
					                  <td><input type="text" name="ZPHONE_NUM" value="<%=e19CongcondData.ZPHONE_NUM  %>" size="20" maxsize=20 style="text-align:left" readonly></td>
					                  <th class="th02">핸드폰<font color="#006699"><b>*</b></font></th>
					                  <td><input type="text" name="ZCELL_NUM" value="<%=e19CongcondData.ZCELL_NUM  %>"  size="20" maxsize=20 style="text-align:left" readonly></td>
					                </tr>
					              </table>
					              </div>


									<h2 class="subtitle">배송정보</h2>
					            	<input type="hidden" name="ZUNAME_R"   value="<%=e19CongcondData.ZUNAME_R %>"><!-- 대상자(직원명) -->
					            	<input type="hidden" name="ZUNION_FLAG"   value="<%=e19CongcondData.ZUNION_FLAG %>"><!-- 대상자(조합원) -->
									<div class="tableArea">
						                <table class="tableGeneral">
							                <tr>
							                  <th width="100">대상자(직원명)</th>
							                  <td width="260"><%= phonenum.E_ENAME %></td>
							                  <th class="th02" width="100">대상자 연락처<font color="#006699"><b>*</b></font></th>
							                  <td><input type="text" name="ZCELL_NUM_R" value="<%=e19CongcondData.ZCELL_NUM_R  %>" size="20" maxsize=20 style="text-align:left" readonly></td>
							                </tr>
							                <tr>
							                  <th>근무지<font color="#006699"><b>*</b></font></th>
							                  <td> <%=ZGRUP_NUMB_R_NM %></td>
							                  <th class="th02">대상자 부서</th>
							                  <td><%= phonenum.E_ORGTX %></td>
							                </tr>
							                <!--<tr>
							                  <td class="td01">신분</td>
							                  <td class="td09" colspan=3><%= phonenum.E_PTEXT %> <%= e19CongcondData.ZUNION_FLAG.equals("X") ? "조합원:Y" : "" %>
							                  </td>
							                </tr>-->
							                <tr>
							                  <th>배송일자<font color="#006699"><b>*</b></font></th>
							                  <td colspan=3><%= WebUtil.printDate(e19CongcondData.ZTRANS_DATE,".")%> &nbsp; &nbsp;
							                   <%=   WebUtil.printTime(e19CongcondData.ZTRANS_TIME ) %>
							                  </td>
							                </tr>
							                <tr>
							                  <th">배송지주소<font color="#006699"><b>*</b></font></th>
							                  <td colspan=3><input type="text" name="ZTRANS_ADDR" value="<%=e19CongcondData.ZTRANS_ADDR %>" size="80"  maxsize="100" style="text-align:left" readonly></td>
							                </tr>
							                <tr>
							                  <th>기타 요구사항</th>
							                  <td colspan=3><input type="text" name="ZTRANS_ETC" value="<%=e19CongcondData.ZTRANS_ETC %>" size="80" maxsize="100"  style="text-align:left" readonly></td>
							                </tr>
						              </table>
					              </div>

					              <h2 class="subtitle">업체정보</h2>
					              <div class="tableArea">
					                <table class="tableGeneral">
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
					                  <th width="100">업체명</th>
					                  <td width="260"><%= dataF.ZTRANS_NAME %></td>
					                  <th class="th02" width="100">주소</th>
					                  <td><%= dataF.ZTRANS_ADDR %></td>
					                </tr>

					                <!-- [CSR ID:3051290] 쌀화환 경조 신청 관련 시스템 개발  2016.07.13 김불휘S
					                	  for문 밖의 <tr>을 for문 안으로 넣음
					                  -->
					                <tr>
					                  <th>담당자</th>
					                  <td><%= dataF.ZTRANS_UNAME %></td>
					                  <th class="th02">연락처</th>
					                  <td>T e l : <%=dataF.ZPHONE_NUM  %>
					                  <BR>H .P : <%=dataF.ZCELL_NUM  %>
					                 <!-- <BR>FAX : <%=dataF.ZFAX_NUM  %>-->
					                   </td>
					                </tr>

					<%		} %>


					<%	} //end for %>
					              </table>
					              </div>
							<% } //  0007 화환만 주문정보 보여줌 C20140416_24713 %>

					           <!-- C20140416_24713 주문업체정보 END -->
                    </td>
              <!-- 리스트테이블 끝-->
            </td>
          </tr>
          <tr>
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
		<% if (visible) { %>
          <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td><h2 class="subtitle">적요</h2></td>
                    </tr>
                </table>
              </td>
          </tr>
          <tr>
            <td>
                <table width="780" border="0" cellpadding="0" cellspacing="1">
                <% for (int i = 0; i < vcAppLineData.size(); i++) { %>
	                <%
	                    AppLineData ald = (AppLineData) vcAppLineData.get(i);
	                %>
	                <% if (ald.APPL_BIGO_TEXT != null && !ald.APPL_BIGO_TEXT.equals("")) { %>
                    <tr>
                    	<td>
                    		<div class="tableArea">
                    			<table class="tableGeneral">
                    				<tr>
                    					<th width="100"><%=ald.APPL_ENAME%></th>
                    					<td><%=ald.APPL_BIGO_TEXT%></td>
                    				</tr>
                    			</table>
                    		</div>
                    	</td>
					</tr>
					<% } // end if %>
            	<% } // end for %>
				</table>
		    </td>
		  </tr>
		<% } // end if %>
          <tr>
            <td>
            	<table border="0" cellspacing="0" cellpadding="0">
	                <tr>
	                  <td><h2 class="subtitle">결재정보</h2></td>
	                </tr>
              </table>
              </td>
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
                  <td>
		           	<div class="buttonArea">
		           		<ul class="btn_crud">
		                   <% if (isCanGoList) {  %>
		           			<li><a href="javascript:goToList()"><span>목록보기</span></a></li>
		                   <% } // end if %>
		           		</ul>
		           	</div>
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

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 퇴직금 시뮬레이션                                           */
/*   Program Name : 퇴직금 시뮬레이션                                           */
/*   Program ID   : D15RetirementSimul.jsp                                      */
/*   Description  : 퇴직금 시뮬레이션                                           */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-21  윤정현                                          */
/*   Update       : 2006-03-17  @v1.1 lsa 급여작업으로 막음                     */
/*                              @v1.1 lsa 5월급여작업으로 막음  전문기술직만    */
/*                  2006-06-16 @v1.1 kdy 임금인상관련 급여화면 제어              */
/*                  20141127 [CSR ID:2651601] E-HR 퇴직금 시뮬레이션 메뉴 수정    */
/*                  2015-04-30 [CSR ID:2766467] HR Center 퇴직금 시뮬레이션 open 요청  */
/* 				 2018-01-22 cykim [CSR ID:3565818] 퇴직금 시스템 관련  */
/* 				 2018-06-07 cykim  [CSR ID:3708472] 퇴직금 시뮬레이션 화면 수정 요청 */
/* 				 2018-07-17 taeilkang [CSR : C20180710_35476] 퇴직금 시뮬레이션 - 퇴직연금제도안내 ppt 파일 변경 요청 */
/* 				 2018-08-13 taeilkang [CSR : 3694675] 퇴직금 주택자금 관련 부분 삭제의 건 */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="hris.E.E03Retire.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.common.*" %>


<%
    WebUserData user = WebUtil.getSessionUser(request);
	//20141127 [CSR ID:2651601] E-HR 퇴직금 시뮬레이션 메뉴 수정
	PersonData PERNR_Data = (PersonData)request.getAttribute("PersonData");

    D15RetirementSimulData data = (D15RetirementSimulData)request.getAttribute("d15RetirementSimulData") ;
	
    //db,dc여부
    String retireType = new E03RetireGubunRFC().getRetireGubunInfo(user.empNo);
%>


<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
function do_simulation(){
    if(document.form1.retireDate.value == "" || document.form1.fu_retireDate.value == ""){
    	//alert('예상퇴직일자를 입력하세요.');
        alert('<%=g.getMessage("MSG.D.D15.0001") %>');
        document.form1.retireDate.value = document.form1.fu_retireDate.value;
        document.form1.retireDate.focus();
        document.form1.retireDate.select();
        return;
    }
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D15RetirementSimulSV";
    document.form1.fu_retireDate.value = removePoint(document.form1.retireDate.value);
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
// 달력 사용
function fn_openCal(Objectname){
    var lastDate;
    lastDate = eval("document.form1." + Objectname + ".value");
    small_window=window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0","essOpen","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
}
// 달력 사용
function event_CONG_DATE(obj){
    if( (obj.value != "") && dateFormat(obj) && chkInvalidDate() ){
    }
}

function chkInvalidDate(){
    // 퇴직금기산일이 안나올 경우 문제가 됨.. ?????
    var begin_date = removePoint(document.form1.O_GIDAT.value);
    var retireDate = removePoint(document.form1.retireDate.value);

    if(begin_date=='') return true;

    dif = dayDiff(addSlash(begin_date), addSlash(retireDate));

    if(dif <= 0){
    	//alert('퇴직금기산일 이후의 예상퇴직일자를 입력해 주세요');
    	alert('<%=g.getMessage("MSG.D.D15.0002") %>');
        return false;
    }
    return true;
}
//-->
</SCRIPT>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D15.0001"/>
    <jsp:param name="click" value="Y"/>
</jsp:include>

<% //@v1.1
   String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( user.empNo );
  //C20100406_42869 2010.04.07  14 계약직(자문/고문) 은 대상자 아님
 // O_CHECK_FLAG="IMSINOT";
  if (!retireType.equalsIgnoreCase("DB")){
%>
                    <table width=100% border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td  align="center"><br><br><br><font color=green><B> <!-- ※ 퇴직연금 DC가입자는 퇴직금 업무 관할 부서로 연락하시기 바랍니다. -->※<%=g.getMessage("MSG.D.D15.0003") %></B><br><br></font>
                         </td>
                      </tr>
                    </table>
<% } else if (user.e_persk.equals("14") ) {
%>
                    <table width=100% border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td  align="center"><br><br><br><font color=green><B> <!-- ※ 조회대상자가 아닙니다. -->※ <%=g.getMessage("MSG.D.D15.0004") %></B><br><br></font>
                         </td>
                      </tr>
                    </table>
<% } else if (O_CHECK_FLAG.equals("IMSI") ) { %>
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="center"><br>
                           <font color="red"><!-- ※ 사용을 일시 중지합니다. -->※ <%=g.getMessage("MSG.D.D15.0005") %><br><br></font>
                         </td>
                      </tr>
                    </table>
<% } else if (O_CHECK_FLAG.equals("N") ) { %>
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="center"><br>
                           <font color="red" face="굴림, 굴림체" size="-1"><!-- ※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다. -->※<%=g.getMessage("MSG.D.D15.0006") %><br><br></font>
                         </td>
                      </tr>
                    </table>
<% } else if (PERNR_Data.E_WERKS.equals("BA00X")) {//20141127 [CSR ID:2651601] E-HR 퇴직금 시뮬레이션 메뉴 수정 //[CSR ID:2766467] 없는 코드로 수정해서 all open 되도록 %>
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="center"><br>
                           <font color="red" face="굴림, 굴림체" size="-1"><!-- ※ 시스템 점검중입니다. -->※ <%=g.getMessage("MSG.D.D15.0007") %><br><br></font>
                         </td>
                      </tr>
                    </table>
<% } else {  //@v1.1 else %>

              <!--조회년월 검색 테이블 시작-->
  <form name="form1" method="post">


				        <div class="tableInquiry ">
				            <table>
    						<colgroup>
    							<col width="20%" />
    							<col width="20%" />
    							<col width="20%" />
    							<col width="20%" />
    							<col width="20%" />

                      <tr style="line-height:0px ">
                        <th><!-- 퇴직금기산일 --><%=g.getMessage("LABEL.D.D15.0002") %></th>
                        <td>
                          <input type="text" name="O_GIDAT" value="<%= data.O_GIDAT.equals("0000-00-00")? "" : WebUtil.printDate(data.O_GIDAT) %>" size="14" class="input04" style="text-align:left" readonly>
                        </td>
                        <th><!-- 예상퇴직일자 --><%=g.getMessage("LABEL.D.D15.0003") %></th>
                        <td>
                          <input type="text" name="retireDate" value="<%= WebUtil.printDate(data.fu_retireDate) %>" size="14" class="input03 date" style="text-align:left" >
                          <input type="hidden" name="fu_retireDate" value="<%= WebUtil.printDate(data.fu_retireDate) %>" >
                          <!-- 날짜검색-->
						            </td>
						            <td class="btn_mdl">
	                          <a onclick="javascript:do_simulation();"><span>실행</span></a>
	                          <!-- [CSR ID:3708472] 퇴직금 시뮬레이션 화면 수정 요청  start @ HR제도안내  퇴직급여> 퇴직연금 제도 설명 자료 PPT와 동일하게 파일변경 요청 -->
	                          <!-- <a href="/web/images/D15RetirementGuide.ppt"  target="_blank"><span>퇴직연금제도안내</span></a> -->
	                          <!-- [CSR : C20180710_35476] 퇴직연금제도안내 ppt 파일 변경 start -->
	                          <a href="/web/help_online/help/Rule01Payment02.pptx"  target="_blank"><span>퇴직연금제도안내</span></a>
	                          <!-- [CSR : C20180710_35476] 퇴직연금제도안내 ppt 파일 변경 end -->
	                          <!-- [CSR ID:3708472] 퇴직금 시뮬레이션 화면 수정 요청  END -->
                        </td>
                      </tr>
                    </table>

                      <div class="clear">
                      </div>
                      <div class="commentsMoreThan2">
    					<div> <%=g.getMessage("MSG.D.D15.0008") %></div>
  					  </div>

  					  </div>



  </form>
              <!--조회년월 검색 테이블 끝-->

  <form name="form2">
  			<div class="tableArea">
			    <div class="table">
              <table width="750" border="0" cellspacing="0" cellpadding="2" class="tableGeneral">
                <tr>
                  <th width="100"><!-- 평균임금 --><%=g.getMessage("LABEL.D.D15.0006") %></th>
                  <td width="250">
                    <input type="text" name="WAGE_AVER" value="<%= WebUtil.printNumFormat(data.WAGE_AVER)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                  </td>
                  <th class="th02" width="100"><!-- 평균임금기산일 --><%=g.getMessage("LABEL.D.D15.0007") %></th>
                  <td width="300">
                    <input type="text" name="AVER_DATE" value="<%= data.AVER_DATE.equals("0000-00-00")? "" : WebUtil.printDate(data.AVER_DATE) %>" size="14" class="input04" style="text-align:left" readonly>
                  </td>
                </tr>
                <tr>
                  <th><!-- 근속년수 --><%=g.getMessage("LABEL.D.D15.0008") %></th>
                  <td colspan="3">
                    <input type="text" name="SERV_PROD_Y" value="<%= (data.SERV_PROD_Y.equals("00") ? "" : WebUtil.printNum(data.SERV_PROD_Y)+" "+g.getMessage("LABEL.D.D15.0020")+" ")+(data.SERV_PROD_M.equals("00") ? "" : WebUtil.printNum(data.SERV_PROD_M)+" "+g.getMessage("LABEL.D.D15.0021"))%>" size="20" class="input04" style="text-align:right" readonly>
                  </td>
                </tr>
                <tr>
                  <th><!-- 퇴직금 총액 --><%=g.getMessage("LABEL.D.D15.0009") %></th>
                  <td colspan="3">
                    <input type="text" name="GRNT_RSGN" value="<%= WebUtil.printNumFormat(data.GRNT_RSGN)+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                  </td>
                </tr>
                <tr>
                  <th>&nbsp;</th>
                  <td colspan="3">
                    <table class="innerTable" width="100%" border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <th><!-- 퇴직보험사 --><%=g.getMessage("LABEL.D.D15.0011") %>(A)<!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="JON1_AMNT1" value="<%= data.JON1_AMNT1.equals("") ? "" : WebUtil.printNumFormat(data.JON1_AMNT1)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                          &nbsp;<%= data.INS1_NAME1.equals("") ? "" : data.INS1_NAME1 %>
                         </td>
                      </tr>
                      <tr>
                        <th><!-- 퇴직보험사 --><%=g.getMessage("LABEL.D.D15.0011") %>(B)<!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="JON1_AMNT2" value="<%= data.JON1_AMNT2.equals("") ? "" : WebUtil.printNumFormat(data.JON1_AMNT2)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                          &nbsp;<%= data.INS1_NAME2.equals("") ? "" : data.INS1_NAME2 %>
                        </td>
                      </tr>
<%
//  2002.10.08. LG석유화학일경우 퇴직보험사가 3개임. - 현재상태
//    if( user.companyCode.equals("N100") && !data.INS1_NAME3.equals("") ) {
    if( !data.INS1_NAME3.equals("") ) {
%>
                      <tr>
                        <th><!-- 퇴직보험사 --><%=g.getMessage("LABEL.D.D15.0011") %>(C)<!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="JON1_AMNT3" value="<%= data.JON1_AMNT3.equals("") ? "" : WebUtil.printNumFormat(data.JON1_AMNT3)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                          &nbsp;<%= data.INS1_NAME3.equals("") ? "" : data.INS1_NAME3 %>
                         </td>
                      </tr>
<%
    }
%>
<%
    if( !data.INS1_NAME4.equals("") ) {
%>
                      <tr>
                        <th><!-- 퇴직보험사 --><%=g.getMessage("LABEL.D.D15.0011") %>(D)<!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="JON1_AMNT4" value="<%= data.JON1_AMNT4.equals("") ? "" : WebUtil.printNumFormat(data.JON1_AMNT4)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                          &nbsp;<%= data.INS1_NAME4.equals("") ? "" : data.INS1_NAME4 %>
                        </td>
                      </tr>
<%
    }
%>
<%
    if( !data.INS1_NAME5.equals("") ) {
%>
                      <tr>
                        <th><!-- 퇴직보험사 --><%=g.getMessage("LABEL.D.D15.0011") %>(E)<!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="JON1_AMNT5" value="<%= data.JON1_AMNT5.equals("") ? "" : WebUtil.printNumFormat(data.JON1_AMNT5)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                          &nbsp;<%= data.INS1_NAME5.equals("") ? "" : data.INS1_NAME5 %>
                        </td>
                      </tr>
<%
    }
%>
<%
    if( !data.INS1_NAME6.equals("") ) {
%>
                      <tr>
                        <th><!-- 퇴직보험사 --><%=g.getMessage("LABEL.D.D15.0011") %>(F)<!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="JON1_AMNT6" value="<%= data.JON1_AMNT6.equals("") ? "" : WebUtil.printNumFormat(data.JON1_AMNT6)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                          &nbsp;<%= data.INS1_NAME6.equals("") ? "" : data.INS1_NAME6 %>
                         </td>
                      </tr>
<%
    }
%>
<!-- [CSR ID:3565818] 퇴직금 시스템 관련  start -->
<%
    if( !data.INS1_NAME7.equals("") ) {
%>
                      <tr>
                        <th><!-- 퇴직보험사 --><%=g.getMessage("LABEL.D.D15.0011") %>(G)<!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="JON1_AMNT7" value="<%= data.JON1_AMNT7.equals("") ? "" : WebUtil.printNumFormat(data.JON1_AMNT7)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                          &nbsp;<%= data.INS1_NAME7.equals("") ? "" : data.INS1_NAME7 %>
                         </td>
                      </tr>
<%
    }
%>
<%
    if( !data.INS1_NAME8.equals("") ) {
%>
                      <tr>
                        <th><!-- 퇴직보험사 --><%=g.getMessage("LABEL.D.D15.0011") %>(H)<!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="JON1_AMNT8" value="<%= data.JON1_AMNT8.equals("") ? "" : WebUtil.printNumFormat(data.JON1_AMNT8)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                          &nbsp;<%= data.INS1_NAME8.equals("") ? "" : data.INS1_NAME8 %>
                         </td>
                      </tr>
<%
    }
%>
<!-- [CSR ID:3565818] 퇴직금 시스템 관련  end -->
                      <tr>
                        <th class="noBtBorder"><!-- 회사에서 --><%=g.getMessage("LABEL.D.D15.0013") %> <!-- 지급액 --><%=g.getMessage("LABEL.D.D15.0012") %></th>
                        <td class="align_left noRtBorder noBtBorder">
                          <input type="text" name="_회사지급액" value="<%= WebUtil.printNumFormat(data._회사지급액)+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                        </td>
                      </tr>
                    </table>

                  </td>
                </tr>
                <tr>
                  <th><!-- 공제총액 --><%=g.getMessage("LABEL.D.D15.0014") %></th>
                  <td colspan="3">
                    <!-- <input type="text" name="_공제총액" value="<%= WebUtil.printNumFormat(Double.toString(Double.parseDouble(data._공제총액)-Double.parseDouble(data.O_BONDM)))+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly> -->
                    <!-- 2018-08-13 taeilkang [CSR : 3694675] 퇴직금 주택자금 관련 부분 삭제의 건 start -->
                    <input type="text" name="_공제총액" value="<%= WebUtil.printNumFormat( Double.toString(Double.parseDouble(data._퇴직갑근세) + Double.parseDouble(data._퇴직주민세) + Double.parseDouble(data.O_NAPPR)))+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                    <!-- 2018-08-13 taeilkang [CSR : 3694675] 퇴직금 주택자금 관련 부분 삭제의 건 end -->
                  </td>
                </tr>
                <tr>
                  <th>&nbsp;</th>
                  <td colspan="3">
                    <table class="innerTable" width="100%" border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <th><!-- 퇴직갑근세 --><%=g.getMessage("LABEL.D.D15.0015") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="_퇴직갑근세" value="<%= WebUtil.printNumFormat( data._퇴직갑근세 )+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                        </td>
                      </tr>
                      <tr>
                        <th><!-- 퇴직주민세 --><%=g.getMessage("LABEL.D.D15.0016") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="_퇴직주민세" value="<%= WebUtil.printNumFormat(data._퇴직주민세 )+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                        </td>
                      </tr>
                      <tr>
                        <th><!-- 퇴직전환금 --><%=g.getMessage("LABEL.D.D15.0017") %></th>
                        <td class="align_left noRtBorder">
                          <input type="text" name="O_NAPPR" value="<%= WebUtil.printNumFormat( data.O_NAPPR )+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                        </td>
                      </tr>
<!--
                      <tr>
                        <td class="td01">채권가압류공제</td>
                        <td class="td09">
                          <input type="text" name="O_BONDM" value="<%= WebUtil.printNumFormat( data.O_BONDM )+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                        </td>
                      </tr>-->
                      
                      <!-- 2018-08-13 taeilkang [CSR : 3694675] 퇴직금 주택자금 관련 부분 삭제의 건 start -->
                      <%--<tr>
                        <th class="noBtBorder"><!-- 주택자금공제 --><%=g.getMessage("LABEL.D.D15.0018") %></th>
                        <td class="align_left noRtBorder noBtBorder">
                          <input type="text" name="O_HLOAN" value="<%= WebUtil.printNumFormat( data.O_HLOAN )+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                        </td>
                      </tr> --%>
                      <!-- 2018-08-13 taeilkang [CSR : 3694675] 퇴직금 주택자금 관련 부분 삭제의 건 end -->
                    </table>

                  </td>
                </tr>
                <tr>
                  <th><!-- 차감지급액 --><%=g.getMessage("LABEL.D.D15.0019") %></th>
                  <td colspan="3">
<!--                    <input type="text" name="_차감지급액" value="<%= WebUtil.printNumFormat( data._차감지급액 )+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>-->
                    <!-- 2018-08-13 taeilkang [CSR : 3694675] 퇴직금 주택자금 관련 부분 삭제의 건 start -->
                    <input type="text" name="_차감지급액" value="<%= WebUtil.printNumFormat(Double.toString(Double.parseDouble(data.GRNT_RSGN) - (Double.parseDouble(data._퇴직갑근세) + Double.parseDouble(data._퇴직주민세) + Double.parseDouble(data.O_NAPPR))))+" "+g.getMessage("LABEL.D.D15.0010") %>" size="20" class="input04" style="text-align:right" readonly>
                    <!-- 2018-08-13 taeilkang [CSR : 3694675] 퇴직금 주택자금 관련 부분 삭제의 건 end -->
                    <div class="commentsMoreThan2">
                    <span  style="color:#006699;">
                   		 &nbsp; ※<!-- ※ 상기 퇴직금 시뮬레이션은 직전 3개월치의 평균임금으로 산정한 것이므로 --> <%=g.getMessage("MSG.D.D15.0009") %>
              		      <!-- 화면상의 차감지급액은 실제 퇴직금과 다를수 있습니다. -->(<%=g.getMessage("MSG.D.D15.0010") %>)
              		  </span >
              		  </div>
                  </td>
                </tr>
              </table>
              </div>
             </div>
                      <div class="commentsMoreThan2">
    					<div> <span style="color:#006699;"><!-- ※ 채권가압류 대상자는 차감지급액에서 압류금액이 차감될 수 있습니다. --> <%=g.getMessage("MSG.D.D15.0011") %></span></div>
  					  </div>
  </form>

  <% } //@v1.1 end %>

</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
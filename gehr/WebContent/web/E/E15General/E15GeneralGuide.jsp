<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진                                                    */
/*   Program ID   : E15GeneralGuide.jsp                                         */
/*   Description  : 종합검진 상세일정을 조회                                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                  2005-11-01  lsa                                             */
/*                              C2005110101000000598에의해 청주는 신청할수 없게 처리함 */
/*                              LINE54                                          */
/*                              ZHRMR300: 기간입력                              */
/*                  2013-01-28  [CSR ID:2261371] 종합검진 본사: 검진센터링크 추가 */
/*		    2014-01-23  링크변경 C20140123_75289  */
/*  			2014-10-30 SJY  CSR ID:2634070 임직원 건강검진 시스템 오류 수정 요청       */
/*				2015/01/30  이지은 [CSR ID:2694158] 종합검진 신청화면 수정 관련의 건 17(과천 추가)  */
/*             2016/01/23  rdcamel[CSR ID:2967911] HR portal 종합검진 신청화면 수정 요청의 건 */
/*             2016/02/02  rdcamel[CSR ID:2978241] 16년 종합검진 신청안내   */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E15General.*" %>
<%@ page import="hris.E.E15General.rfc.*" %>

<%
    //WebUserData user = (WebUserData)session.getAttribute("user");
	WebUserData user = WebUtil.getSessionUser(request);

    String PERNR = (String)request.getAttribute("PERNR");

    E15GeneralDayData e15GeneralDayData = new E15GeneralDayData();

    E15GeneralGetDayRFC func = new E15GeneralGetDayRFC();
    Vector ret = func.getMedicday(PERNR);
    e15GeneralDayData = (E15GeneralDayData)ret.get(0); //사업장별 일정

    String GRUP_NUMB	= e15GeneralDayData.GRUP_NUMB	;  //사업장
    String GRUP_NAME	= e15GeneralDayData.GRUP_NAME	;  //사업장명
    //out.println("GRUP_NUMB:"+GRUP_NUMB);

    //2634070 START
    //오늘날짜
	java.text.SimpleDateFormat sdf1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String nowDate = sdf1.format(new Date());
    int toCompare = nowDate.compareTo(e15GeneralDayData.DATE_TO); //종료날짜 비교
    int fromCompare = nowDate.compareTo(e15GeneralDayData.DATE_FROM); //시작날짜 비교
    //2634070 END
 %>

<jsp:include page="/include/header.jsp"/>

<!--서울사업장(01), 청주(03), 오창(10),02:여수,05:기술원-->
<%
	//2634070 START
	if(true){
   // if (  !e15GeneralDayData.DATE_FROM.equals("0000-00-00") ) {
   //2634070 END

   //if( user.e_grup_numb.equals("01")||user.e_grup_numb.equals("03")||user.e_grup_numb.equals("10")||user.e_grup_numb.equals("02") ||user.e_grup_numb.equals("05")){

   //if( user.e_grup_numb.equals("01")||user.e_grup_numb.equals("03")||user.e_grup_numb.equals("10")||user.e_grup_numb.equals("02") ||user.e_grup_numb.equals("09")){ //개발서버땜시롱 임시로박음
   //csr요청C2005110101000000598에의해 청주는 신청할수 없게 처리함
   //if( user.e_grup_numb.equals("01")||user.e_grup_numb.equals("10") ){
%>
	 <div class="tableArea">
		  <div class="table">
			  <table class="tableGeneral">
					<colgroup>
	            		<col width="80%" />
            			<col width="20" />
	            	</colgroup>
	            	<tr>
		            	<td align="center"><b><%=DataUtil.getCurrentYear()%> <!-- 종합건강검진 실시 안내 --><spring:message code='MSG.E.E15.0032' /> (<%=GRUP_NAME %>)</b></td>
		            	<td>
	                        <a class="inlineBtn" href="javascript:open_rule('Rule02Benefits08.html');" style="float: right"><span>종합검진 실시기준</span></a>
	                    </td>
	            	</tr>
	            	<% //본사
					if (  GRUP_NUMB.equals("00")) {
					%>
	            	<tr>
		            	<td colspan="2">&nbsp;<img src="<%=WebUtil.ImageURL%>../E/E15General/e15_2006flow0.gif" border="0"></td>
	            	</tr>
	            	<tr>
			            <td><!-- 1. 실시대상 : 만 35세이상('72,'74,'76년 출생자)사원 및 배우자 --><spring:message code='MSG.E.E15.0033' /></td>
			        </tr>
			        <tr>
			            <td colspan="2"style="padding:0px 76px"><!--만 40세이상(1971.12.31 이전 출생자)사원 및 배우자--><spring:message code='MSG.E.E15.0034' /></td>
			        </tr>
			        <tr >
			            <td colspan="2"><!-- 2. 실시기간 : '11.02.14(월)~'11.06.30(목)까지(6월말 이후 예약 및 검진불가 함) --><spring:message code='MSG.E.E15.0035' /></td>
			        </tr>
			        <tr >
			            <td colspan="2"><!-- 3. 신청기한 --><spring:message code='MSG.E.E15.0036' /> : <font color="#CC3300">'11.01.24(월)~'11.01.31(월)</font></td>
			        </tr>
			        <tr>
			            <td colspan="2"><!-- 4. 진행FLOW --><spring:message code='MSG.E.E15.0037' /></td>
			        </tr>
			        <tr>
			          <td colspan="2">
			            <table border="0" cellspacing="0" cellpadding="0">
			              <tr>
			                <td valign="top"><img src="<%=WebUtil.ImageURL%>../E/E15General/e15_2007flow1.gif" border="0"></td>
			                <td valign="top"><img src="<%=WebUtil.ImageURL%>../E/E15General/e15_2007flow2.gif" border="0"></td>
			                <td valign="top"><img src="<%=WebUtil.ImageURL%>../E/E15General/e15_2007flow3.gif" border="0"></td>
			                <td valign="top"><img src="<%=WebUtil.ImageURL%>../E/E15General/e15_2007flow4.gif" border="0"></td>
			              </tr>

			              <tr>
			                  <td valign="top">
			                  <!-- ① 반드시 본인/배우자를 구분하여 각각 신청해야 함 --><spring:message code='MSG.E.E15.0038' /><br>
			                  <!-- ② 검진기간을 정확하게 선택해야 함 --><spring:message code='MSG.E.E15.0039' /><br>
			                  <!--③ 검진기간별 검진항목 확인바람 --><spring:message code='MSG.E.E15.0040' />
		                      </td>
			                  <td valign="top">
			                  	<!--① 검진기관별 검진일정 의뢰 및 확정 통보 --><spring:message code='MSG.E.E15.0041' /><br>
			                    <!--② 확정내용은 본인에게 E-mail 통보 --><spring:message code='MSG.E.E15.0042' />
		                      </td>
				              <td valign="top">
				              	<!--① 확정된 검진기관 및 검진일정을 HR Center에서 확인함 --><spring:message code='MSG.E.E15.0043' /><br>
			                    <!--② 검진기관에서 검진안내문 사전배포 --><spring:message code='MSG.E.E15.0044' />
			                   </td>
				               <td valign="top">
				               	<!--② 검진기관에서 검진안내문 사전배포 --><spring:message code='MSG.E.E15.0045' /><br> <font color=red><b>(<!--일부병원 제외--><spring:message code='MSG.E.E15.0046' />)</b></font><br>
			                    <!--② 검진일정에 따라 검진실시 --><spring:message code='MSG.E.E15.0047' /><br>
			                    <!--③ 검진후 20일이내 결과통보 --><spring:message code='MSG.E.E15.0048' />
			                   </td>
			              </tr>
			            </table><br>
			          </td>
			        </tr>

			        <tr>
			          <td colspan="2">
			              <img src="<%=WebUtil.ImageURL%>../E/E15General/e15_hospital_01.gif" border="0">
			          </td>
			        </tr>

			        <tr>
			            <td colspan="2"><!--5. 기타--><spring:message code='MSG.E.E15.0049' /><br>
			            <!--(1) 공장 및 기술연구원 대상자는 해당 사업장에서 자체적으로 실시함.--><spring:message code='MSG.E.E15.0050' /><br>
			            <!--(2) 지방 영업에 근무하는 검진 대상자는 지방관리과/영업소 단위로 자체실시한 후 본사에 통보함.--><spring:message code='MSG.E.E15.0051' /><br>
			            <!--(3) 기타 문의사항은 HR서비스팀 윤명희 간호사(☎3773-6828)에게 문의 바람.--><spring:message code='MSG.E.E15.0052' /><br>
			            </td>
				 	</tr>

				 	<% } else {  %>
      				<tr>
		            	<%if(GRUP_NUMB.equals("08")){//[CSR ID:2967911]  %>
					          <td colspan="2">종합검진 신청은 <font color=blue><u><b>Service -> SH&E System -> 보건 -> 검진관리 -> 신청 -> 종합검진 신청화면</b></u></font>에서 신청하여 주시기 바랍니다.</td>
						<%}else{ %>
							  <td colspan="2"><img src="<%=WebUtil.ImageURL%>../E/E15General/e15guide_<%=GRUP_NUMB%>.gif" border="0"></td>
						<%} %>
	            	</tr>

	            	<% } %>

         		</table>
          </div>
      </div>
<!------------------------------>

    <% //본사    [CSR ID:2261371] 종합검진 안내화면 수정의 건
    //링크변경 C20140123_75289
    //[CSR ID:2689524] 종합검진 신청화면 수정 관련의 건
    //[CSR ID:2694158] 종합검진 신청화면 수정 관련의 건 17(과천 추가)
     if (  GRUP_NUMB.equals("01") || GRUP_NUMB.equals("17")) { %>

     <div class="tableArea">
		  <div class="table">
			  <table class="tableGeneral">
					<colgroup>
	            		<col width="5%" />
            			<col width="30%" />
	            		<col width="" />
	            	</colgroup>
	            	<tr>
			            <td colspan="3"><font color=blue>※. <b><!--검진기관별 Homepage 안내--><spring:message code='MSG.E.E15.0053' /></b></font></td>
			        </tr>
			        <tr>
		                <td></td>
		                <td>-. <font color=black><b>서울필립센터</b></font></td>
		                <td><font color=black><a href="http://y.philipmedi.co.kr" target="new_open">http://y.philipmedi.co.kr/</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>한국의료재단</b></font></td>
		                <td><font color=black><a href="http://www.komef.org/" target="new_open">http://www.komef.org/</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>KMI한국의학연구소</b></font></td>
		                <td><font color=black><a href="http://www.kmi.or.kr/kor/center/network/yeouido.web" target="new_open">http://www.kmi.or.kr/kor/center/network/yeouido.web</a></font></td>
		              </tr>
		              <tr><!--CSR9999-->
		                <td> </td>
		                <td>-. <font color=black><b>구로성심병원</b></font></td>
		                <!-- <td><font color=black><a href="p://gurosungsim.co.kr/medicipia/main/main.php/" target="new_open">p://gurosungsim.co.kr/medicipia/main/main.php/</td> -->
		                <td><font color=black><a href="http://gurosungsim.co.kr/medicipia/main/main.php" target="new_open">http://gurosungsim.co.kr/medicipia/main/main.php</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>한신 메디피아</b></font></td>
		                <td><font color=black><a href="http://www.medikind.com/" target="new_open">http://www.medikind.com/</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>하트스캔센터</b></font></td>
		                <td><font color=black><a href="http://www.heartscan.co.kr/" target="new_open">http://www.heartscan.co.kr/</a></font></td>
		              </tr>
		              <tr><!--CSR9999-->
		                <td> </td>
		                <td>-. <font color=black><b>차병원 차움검진센터(강남차)</b></font></td>
		                <td><font color=black><a href="http://gangnam.chahealth.co.kr" target="new_open">http://gangnam.chahealth.co.kr/</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>고대안암병원</b></font></td>
		                <td><font color=black><a href="http://healthpro.kumc.or.kr/" target="new_open">http://healthpro.kumc.or.kr/</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>여의도성모병원</b></font></td>
		                <td><font color=black><a href="http://www.cmcsungmo.or.kr/health/" target="new_open">http://www.cmcsungmo.or.kr/health/</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>서울성모병원</b></font></td>
		                <td><font color=black><a href="http://www.cmcseoul.or.kr/healthcare/index.dindex.do" target="new_open">http://www.cmcseoul.or.kr/healthcare/index.dindex.do</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>세브란스</b></font></td>
		                <td><font color=black><a href="http://sev.iseverance.com/health/" target="new_open">http://sev.iseverance.com/health/</a></font></td>
		              </tr>
		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>분당필립센터</b></font></td>
		                <td><font color=black><a href="http://b.philipmedi.co.kr/" target="new_open">http://b.philipmedi.co.kr/</a></font></td>
		              </tr>

		              <tr>
		                <td> </td>
		                <td>-. <font color=black><b>일산병원</b></font></td>
		                <td><font color=black><a href="http://www.nhimc.or.kr/imc/index.do" target="new_open">http://www.nhimc.or.kr/imc/index.do</a></font></td>
		              </tr>

         		</table>
          </div>
      </div>

<%   }   %>


<% } %>
<input type=hidden name="aa" value="<%=user.e_grup_numb%>">
<jsp:include page="/include/footer.jsp"/>
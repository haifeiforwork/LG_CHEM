<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 추가암검진(7대암검진)                                                      */
/*   Program Name : 추가암검진(7대암검진)                                                      */
/*   Program ID   : E38CancerGuide.jsp                                          */
/*   Description  : 추가암검진(7대암검진) 상세일정을 조회                                       */
/*   Note         :                                                              */
/*   Creation     : 2013-06-21  lsa   C20130620_53407                                           */
/*   Update       : 2014-10-30 SJY  CSR ID:2634070 임직원 건강검진 시스템 오류 수정 요청                                                              */

/*                     2015-10-02 이지은D [CSR ID:2885254] 2015년 추가암검진 신청안내문 e-HR 게시 요청(10/5)  */
/*                  2016-01-23 rdcamel [CSR ID:2967911] HR portal 종합검진 신청화면 수정 요청의 건 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E38Cancer.*" %>
<%@ page import="hris.E.E38Cancer.rfc.*" %>
<%
    //WebUserData        user           = (WebUserData)session.getAttribute("user");
	WebUserData user = WebUtil.getSessionUser(request);

    String PERNR = (String)request.getAttribute("PERNR");

    E38CancerDayData e15GeneralDayData = new E38CancerDayData();

    E38CancerGetDayRFC func = new E38CancerGetDayRFC();
    Vector ret = func.getMedicday(PERNR);
    e15GeneralDayData = (E38CancerDayData)ret.get(0); //사업장별 일정

    String GRUP_NUMB	= e15GeneralDayData.GRUP_NUMB	;  //사업장
    String GRUP_NAME	= e15GeneralDayData.GRUP_NAME	;  //사업장명
    //out.println("GRUP_NUMB:"+GRUP_NUMB);

    //2634070 START

    //오늘날짜
	java.text.SimpleDateFormat sdf1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String nowDate = sdf1.format(new Date());

	//[CSR ID:2885254] 기술원 사업장만 예외적으로 이미지 오픈을 하루 먼저 할 수 있도록 함.

	String fromdt = e15GeneralDayData.DATE_FROM;//fromdt="2015-10-03";
    int toCompare = nowDate.compareTo(e15GeneralDayData.DATE_TO); //종료날짜 비교

    //int fromCompare = nowDate.compareTo(e15GeneralDayData.DATE_FROM); //시작날짜 비교

     int fromCompare = 0;

    if(GRUP_NUMB.equals("09")){
    	String oneDayBefore = DataUtil.addDays(DataUtil.removeStructur(fromdt,"-"), -1);
        String oneDayBefore2 = WebUtil.printDate(oneDayBefore, "-");//date 포맷 맞춤.
    	fromCompare = nowDate.compareTo(oneDayBefore2); //시작날짜 비교

    }else{
    	fromCompare = nowDate.compareTo(e15GeneralDayData.DATE_FROM); //시작날짜 비교
    }

    //2634070 END
 %>

 <jsp:include page="/include/header.jsp"/>
 <!--서울사업장(01), 청주(03), 오창(10),02:여수,05:기술원-->

	<div class="tableArea">
		  <div class="table">
			  <table class="tableGeneral">
					<colgroup>
	            		<col width="" />
	            	</colgroup>
	            	<%
					   //2634070 START
				    	if(toCompare <= 0 && fromCompare >= 0){
				        // if (  !e15GeneralDayData.DATE_FROM.equals("0000-00-00") ) {
				        //2634070 END
					%>
	            	<tr>
		            	<td align="center"><b><%=DataUtil.getCurrentYear()%><!--년 추가암검진(7대암검진) 실시 안내 --><spring:message code='MSG.E.E15.0056' /> (<%=GRUP_NAME %>)</b></td>
	            	</tr>
	            	<tr>
						  <%if(GRUP_NUMB.equals("08")){// [CSR ID:2967911]  %>
				          <td>종합검진 신청은 <font color=blue><u><b>Service -> SH&E System -> 보건 -> 검진관리 -> 신청 -> 추가암검진 신청화면</b></u></font>에서 신청하여 주시기 바랍니다.</td>
						  <%}else{ %>
						  <td><img src="<%=WebUtil.ImageURL%>../E/E38Cancer/e38guide_<%=GRUP_NUMB%>.gif" border="0"></td>
						  <%} %>
			        </tr>
	            	<% } else { %>
	            	<tr>
			            <td align="center" ><br>
			               <!-- 현재 추가암검진(7대암검진) 신청기간이 아닙니다. --><spring:message code='MSG.E.E15.0055' /><br><br>
			            </td>
			        </tr>
					<% } %>
            	</table>
          </div>
      </div>

<input type=hidden name="aa" value="<%=user.e_grup_numb%>">

<jsp:include page="/include/footer.jsp"/>
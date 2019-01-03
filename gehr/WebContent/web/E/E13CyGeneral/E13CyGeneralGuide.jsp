<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 이월종합검진                                                    */
/*   Program Name : 이월종합검진                                                    */
/*   Program ID   : E13CyGeneralGuide.jsp                                         */
/*   Description  : 이월종합검진 상세일정을 조회                                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                  2005-11-01  lsa                                             */
/*                              C2005110101000000598에의해 청주는 신청할수 없게 처리함 */
/*                              LINE54                                          */
/*                              ZHRMR300: 기간입력                              */
/*                  2013-01-28  [CSR ID:2261371] 이월종합검진 본사: 검진센터링크 추가 */
/*  			2014-10-30 SJY  CSR ID:2634070 임직원 건강검진 시스템 오류 수정 요청                                                              */
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
		            	<td align="center"><b><%=DataUtil.getCurrentYear()%> <!-- 종합건강검진 실시 안내 --><spring:message code='MSG.E.E15.0032' /> (<%=GRUP_NAME %>)</b></td>
	            	</tr>
	            	<tr>
		            	<td>&nbsp;<img src="<%=WebUtil.ImageURL%>../E/E13CyGeneral/e13guide_<%=GRUP_NUMB%>.gif" border="0"></td>
	            	</tr>
	            	<% } else { %>
	            	<tr>
			            <td align="center" ><br>
			              <!-- 현재 종합검진 신청기간이 아닙니다. --><spring:message code='MSG.E.E15.0054' /><br><br>
			            </td>
			        </tr>
					<% } %>
            	</table>
          </div>
      </div>

<input type=hidden name="aa" value="<%=user.e_grup_numb%>">
<jsp:include page="/include/footer.jsp"/>
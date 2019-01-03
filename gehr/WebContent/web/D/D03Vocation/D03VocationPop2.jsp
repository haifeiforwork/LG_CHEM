<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ page import="java.util.Vector" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="com.common.*" %>



 <%
	WebUserData user = (WebUserData)session.getAttribute("user");
	String PERNR = request.getParameter("PERNR");
	if (PERNR == null || PERNR.equals("")) {
		PERNR = user.empNo;
	} // end if
	String EmpNo = PERNR;
	String APPL_FROM = request.getParameter("APPL_FROM");
	String AWART = request.getParameter("AWART");

	Vector  HolidayTimeData_vt = new Vector();
	Vector timeData = ( new D03HolidayTimeRFC() ).getHolidayTime(EmpNo, AWART,APPL_FROM,APPL_FROM);
   	String begTime = (String)Utils.indexOf(timeData,0);
   	String endTime = (String)Utils.indexOf(timeData,1);
    String pabegTime = (String)Utils.indexOf(timeData,2);
   	String paendTime = (String)Utils.indexOf(timeData,3);
    String msg = (String)Utils.indexOf(timeData,5);
    
    if(!msg.equals("")){
	    String msg1 = msg.substring(0,1);

	    if(msg1.equals("E")){
	    	msg = msg.substring(9,msg.length());
	    }
    }

   	Vector v = new Vector();
   	v = (Vector)timeData.get(4);

    /* start ksc_test 2016/12/10 */
//     if (v.size()==0){
// 	    D03ScheduleData d03data = new D03ScheduleData();
// 	    d03data.BEGZT ="08:00:00";
// 	    d03data.ENDZT ="13:00:00";
// 	    v.addElement(d03data);
//     }
	/* end test 2016/12/10 */


//    if(begTime.equals("00:00:00") && endTime.equals("00:00:00")){
%>

<!-- 	<SCRIPT LANGUAGE="JavaScript">
	    window.close();
	    opener.alert("<spring:message code='MSG.D.D03.0032'/>"); //<!--Can't apply in off day.
	    opener.form1.APPL_FROM.value = "";
	    opener.form1.APPL_TO.value = "";
	</SCRIPT> -->

<%
//	}
%>
<jsp:include page="/include/header.jsp" />

<!-- body header 부 title 및 body 시작 부 선언 -->

<SCRIPT LANGUAGE="JavaScript">
	function changeAppData(BEGUZ,ENDUZ){
//     opener.form1.BEGUZ.value = BEGUZ;
//     opener.form1.ENDUZ.value = ENDUZ;
//     opener.check_Time();
//     window.close();

	    var retVal = new Object();

	    retVal.BEGUZ = BEGUZ;
	    retVal.ENDUZ = ENDUZ;

	    window.returnValue = retVal;
	    self.close();

}
</SCRIPT>
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D03.0032"/>
</jsp:include>
<div class="listArea">
	<div class="table">
   		<table class="listTable"   >
   			<thead>
     			<tr>
       			<th><spring:message code="LABEL.D.D03.0033"/><!--Selection--></th>
				<th><spring:message code="LABEL.D.D15.0162"/><!--Start Time--></th>
				<th class="lastCol"><spring:message code="LABEL.D.D15.0163"/><!--End Time--></th>
			</tr>
			</thead>

			<%
			if( v != null && v.size() > 0 ){
				for( int i = 0 ; i <v.size(); i++ ) {
					D03ScheduleData holidaytimeData = (D03ScheduleData)v.get(i);
					String BEGZT = holidaytimeData.BEGZT.equals("")? "000000": holidaytimeData.BEGZT ;
					String ENDZT = holidaytimeData.ENDZT.equals("")? "000000": holidaytimeData.ENDZT;

					Logger.debug.println("holidaytimeData:BEGZT:"+holidaytimeData.BEGZT);

					String tr_class = "";
					if( i % 2 == 0 ){
						tr_class = "oddRow";
					}else{
						tr_class = "";
					}
			%>
			<tr class = "<%= tr_class %>">
				<td><input type="radio" name="radiobutton" value="radiobutton"
	          		onClick="javascript:changeAppData('<%= BEGZT.substring(0,5) %>','<%= ENDZT.substring(0,5) %>');"></td>
				<td><%=WebUtil.printString(BEGZT.substring(0,5) )%></td>
				<td class="lastCol"><%=WebUtil.printString(ENDZT.substring(0,5))%></td>
			</tr>
			<%
				}
			}else{
			%>
			<tr align="oddRow">
				<td class="lastCol" colspan="3"><%=msg %></td>
			</tr>
			<%
			}
			%>
		</table>
	</div>
</div>
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

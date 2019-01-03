<%--
			경조휴가 가족선택 팝업창 
 --%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>
<%@ page import="hris.D.D03Vocation.*" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	request.setCharacterEncoding("utf-8");
    WebUserData user                   = (WebUserData)session.getAttribute("user");
    boolean isFirst             = true;
    Vector  HolidayAbsenceData_vt = new Vector();

    String  count               = request.getParameter("count");
    long    l_count             = 0;
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }
//  page 처리
    String  paging              = request.getParameter("page");
    
	String PERNR = request.getParameter("PERNR");
	String AWART = request.getParameter("AWART");
	String E_BUKRS = request.getParameter("E_BUKRS");	
	if (E_BUKRS == null){
		E_BUKRS = "";
	}

	
	if (PERNR == null || PERNR.equals("")) {
		PERNR = user.empNo;
	} // end if

    String  i_dept              = PERNR;
    
    if( paging == null ) {

        try{
            HolidayAbsenceData_vt = ( new D03HolidayAbsenceRFC() ).getHolidayAbsence(i_dept,AWART);
            l_count = HolidayAbsenceData_vt.size();

        }catch(Exception ex){
            HolidayAbsenceData_vt = null;
        }

        isFirst = false;

    } else if(paging != null ) {

        isFirst = false;
		
        for( int i = 0 ; i < l_count ; i++ ) {
            D03HolidayAbsenceData absenceData = new D03HolidayAbsenceData();
				
            absenceData.ABSN_DATE = (request.getParameter("ABSN_DATE"+i)); 
            absenceData.ENAME = (request.getParameter("ENAME"+i)); 
            absenceData.AINF_SEQN = (request.getParameter("AINF_SEQN"+i));   
            absenceData.BEGDA = (request.getParameter("BEGDA"+i));    
            absenceData.CELDT = (request.getParameter("CELDT"+i));    
            absenceData.FAMY_CODE = (request.getParameter("FAMY_CODE"+i));    
            absenceData.FAMY_TEXT = (request.getParameter("FAMY_TEXT"+i));    
		
            HolidayAbsenceData_vt.addElement(absenceData);
        }
    }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
  	PageUtil pu = null;
   	try {
		pu = new PageUtil(HolidayAbsenceData_vt.size(), paging , 10, 10);
		Logger.debug.println(this, "page : "+paging);
   	} catch (Exception ex) {
   		Logger.debug.println(DataUtil.getStackTrace(ex));
   	}
%>

<c:set var="E_BUKRS" value="<%=E_BUKRS%>"/>


		<jsp:include page="/include/header.jsp" />

		<!-- body header 부 title 및 body 시작 부 선언 -->
		<jsp:include page="/include/body-header.jsp">
			<jsp:param name="title" value='${(E_BUKRS == "")? "LABEL.D.D03.0027":"LABEL.D.D03.0028"}' />       
		</jsp:include>

<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
<%
    if( HolidayAbsenceData_vt != null ) {
        if( HolidayAbsenceData_vt.size() == 1 ) {
            D03HolidayAbsenceData data = (D03HolidayAbsenceData)HolidayAbsenceData_vt.get(0);
%>
    //changeAppData("<%= data.ABSN_DATE %>");
<%
        }
    }
%>
}

function PageMove_m() {
    document.form1.action = "/web/D/D03Vocation/D03VocationPop.jsp";
    document.form1.submit();
}

// 가족유형  opener창에 출력.	2008-01-11
function changeAppData(ABSN_DATE,AINF_SEQN,FAMY_TEXT,FAMY_CODE, CELTY, CELDT ){ 
    opener.form1.P_STDAZ2.value = ABSN_DATE;
    opener.form1.AINF_SEQN2.value = AINF_SEQN;
    opener.form1.FAMY_TEXT.value = FAMY_TEXT;
    opener.form1.FAMY_CODE.value = FAMY_CODE;
    
    //opener.sp1.style.visibility='hidden';
    opener.sp3.style.visibility='';
    opener.ajax_change(CELTY, CELDT, FAMY_CODE);		// 추가 2016-11-07 *ksc
    window.close();
}


//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    PageMove_m();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}

$(function (){
	init();
	
})

//-->
</SCRIPT>
<script>
//    window.resizeTo(690,490);
</script>

    <div class="tableArea">
        <div class="table">
        
<table  width="660" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post">
  <tr>
    <td><br>
      <table width="360" border="0" cellspacing="0" cellpadding="0" align="center">
        
        <%
    if ( HolidayAbsenceData_vt != null && HolidayAbsenceData_vt.size() > 0 ) {
%>
        <tr> 
          <td align="right" ><%= pu == null ? "" : pu.pageInfo() %></td>
        </tr>
        <%
    } else {
%>
        <tr> 
          <td align="right" >&nbsp;</td>
        </tr>
        <%
    }
%>
        <tr> 
          <td> <table width="" border="0" cellspacing="1" cellpadding="2" class="table02" align="center">
              <tr align="center"> 
                <td >Select</td>
                <%
                	if(AWART.equals("0120")){
                %>
                <td ><spring:message code="LABEL.D.D03.0029"/><!--Celebration/Condolence--></td>
                <%
                	}
                 %>
				<td ><spring:message code="LABEL.D.D03.0030"/><!--Family--></td>
                <td ><spring:message code="LABEL.D.D03.0031"/><!--Day--></td>
              </tr>
<%
   if( !isFirst ){
        if( HolidayAbsenceData_vt != null && HolidayAbsenceData_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                D03HolidayAbsenceData holidayAbsenceData = (D03HolidayAbsenceData)HolidayAbsenceData_vt.get(i);
%>
              <tr align="center"> 
              
              	<!-- ************************************************************************* 
				// 영문으로 출력시 " ' "의 히든값 처리.	[CSR번호 : C20080415_51381]	2008-04-18.	김정인.             -->
                <td >
                	<input type="radio" name="radiobutton" value="radiobutton" 
                		onClick='changeAppData("<%= holidayAbsenceData.ABSN_DATE %>","<%= holidayAbsenceData.AINF_SEQN %>",document.form1.FAMY_TEXT<%= i %>.value,"<%= holidayAbsenceData.FAMY_CODE %>", "<%= holidayAbsenceData.CELTY%>","<%= holidayAbsenceData.CELDT %>")'>
             	</td>
                <!-- ***********************************************************************-->
                <%
                	if(AWART.equals("0120")){		//2008-01-14.
                %>
                <td ><%=WebUtil.printString( holidayAbsenceData.CELTX)%></td>
                <%
					}                
                %>
                <td ><%=WebUtil.printString( holidayAbsenceData.FAMY_TEXT )%></td>
                <td ><%=WebUtil.printString( holidayAbsenceData.ABSN_DATE )%></td>
              </tr>
<%
            }

            for( int i = 0 ; i < HolidayAbsenceData_vt.size(); i++ ) {
                D03HolidayAbsenceData holidayAbsenceData = (D03HolidayAbsenceData)HolidayAbsenceData_vt.get(i);
%>
              <input type="hidden" name="BEGDA<%= i %>" value="<%= holidayAbsenceData.BEGDA %>">
              <input type="hidden" name="AINF_SEQN<%= i %>" value="<%= holidayAbsenceData.AINF_SEQN %>">
              <input type="hidden" name="FAMY_CODE<%= i %>" value="<%= holidayAbsenceData.FAMY_CODE %>">
              <input type="hidden" name="FAMY_TEXT<%= i %>" value="<%= holidayAbsenceData.FAMY_TEXT %>">
              <input type="hidden" name="ENAME<%= i %>" value="<%= holidayAbsenceData.ENAME %>">
              <input type="hidden" name="ABSN_DATE<%= i %>" value="<%= holidayAbsenceData.ABSN_DATE %>">
              <%
            }
%>
            </table></td>
        </tr>
        <!-- PageUtil 관련 - 반드시 써준다. -->
        <tr> 
          <td align="center" height="25" valign="bottom"  colspan="6"> 
            <%= pu == null ? "" : pu.pageControl() %> </td>
        </tr>
        <!-- PageUtil 관련 - 반드시 써준다. -->
        <%
        } else {

%>
        <tr align="center"> 
          <td  align="center" colspan="8">
          	<spring:message code="MSG.COMMON.0004"/><!-- No Data. --></td>
        </tr>
      </table>
          </td>
        </tr>
<%
        }
%>
        <tr>
          <td>&nbsp;</td>
        </tr>
<%
    }
%>
        <tr>
         	<td align="center">
				<div class="buttonArea">
				
				    <ul class="btn_crud">
				            <li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"></spring:message></span></a></li>
				    </ul>
				
				</div>

          </td>
        </tr>
      </table>
 

  <input type="hidden" name="I_DEPT"   value="<%= PERNR %>">
  <input type="hidden" name="page"     value="">
  <input type="hidden" name="count"    value="<%= l_count %>">
  <input type="hidden" name="empNo"   value="">
  <input type="hidden" name="PERNR"   value="<%= PERNR %>">
  <input type="hidden" name="AWART"   value="<%= AWART %>">
</form>
</div></div>

<form name="form2" method="post">
    <input type="hidden" name="empNo"   value="">
     <input type="hidden" name="P_STDAZ"   value="">
     <input type="hidden" name="AINF_SEQN2"   value="">
    <input type="hidden" name="i_dept"  value="">
    <input type="hidden" name="i_stat2" value="">
  	<input type="hidden" name="PERNR"   value="<%= PERNR %>">
</form>
</table>

<%-- 꼬리 --%>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

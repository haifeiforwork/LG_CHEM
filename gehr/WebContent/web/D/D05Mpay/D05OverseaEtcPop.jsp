<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 월급여                                                      */
/*   Program Name : 월급여                                                      */
/*   Program ID   : D05OverseaEtcPop.jsp < D05MpayDetail.jsp                    */
/*   Description  : 국내 기타 지급 내역                                         */
/*   Note         :                                                             */
/*   Creation     : 2013-10-17  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<jsp:include page="/web/common/includeLocation.jsp" />

<%
    String year     = request.getParameter("year");
    String month     = request.getParameter("month");
    String pernr     = request.getParameter("pernr");
    String ename     = request.getParameter("ename");
    
     String[] LGTXT = request.getParameterValues("LGTXT");    
     String[] LGTX1 = request.getParameterValues("LGTX1");  
     String[] BET01 = request.getParameterValues("BET01");  
     String[] BET02 = request.getParameterValues("BET02");  
     String[] BET03 = request.getParameterValues("BET03");   
        
%>

<jsp:include page="/include/header.jsp" />
<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D05.0102"/>  
    <jsp:param name="help" value="D05Mpay.html"/>    
</jsp:include>


<form name="form1" method="post" onsubmit="return false">

      	<div class="tableArea">        <!--급여명세 테이블 시작-->
        	<div class="table" >
				<table class="listTable" width="420"  >
<!-- <table border="0" cellspacing="0" cellpadding="0"> -->
				
		
              <tr> 
                <th width="120" ><%= year %><spring:message code="LABEL.D.D04.0002"/><!-- 년 --> <%= month %><spring:message code="LABEL.D.D12.0028"/><!--월--></td>
                <td width="120" ><spring:message code="LABEL.D.D05.0005"/><!-- 사번 --> : &nbsp;<%= pernr %></td>
                <td width="120" class="lastCol"><spring:message code="LABEL.D.D05.0006"/><!-- 성명 --> : &nbsp;<%= ename %></td>
              </tr>    
                        
            </table>
          </div>
          
	      <div class="table" >
            <table width="390" border="0" cellspacing="1" cellpadding="2" class="listTable">
              <tr> 
                <th  width="200"><spring:message code="LABEL.D.D14.0016"/><!--항 목--></td>
                <th  width="190" class="lastCol"><spring:message code="LABEL.D.D05.0015"/><!--금액--></td> 
              </tr>
      
<%
    double bet01Sum=0;  //총금액
	
    for ( int i=0; i < LGTXT.length; i++ ) {
%>
              <tr> 
                <td  style="text-align: left">&nbsp;&nbsp;<%= LGTXT[i] %></td>
                <td class="align_right lastCol"><%= WebUtil.printNumFormat(BET01[i])  %>&nbsp;&nbsp;</td>
              </tr> 
<%
	bet01Sum = bet01Sum + Double.parseDouble(BET01[i])  ;

    }
%>    
              <tr class="sumRow"> 
                <td  style="text-align: center">&nbsp;&nbsp;<spring:message code="LABEL.D.D06.0011"/><!--총계--></td>
                <td  class="align_right lastCol"><%= WebUtil.printNumFormat(bet01Sum)  %>&nbsp;&nbsp;</td>
              </tr> 
                              
            </table>
          </td>
        </tr>
       
      </table>
    </td>
  </tr>
</table>
</table></div>

            	<div class="buttonArea" style="width:400px">
            		<ul class="btn_crud">
            			<li><a class="darken" href="javascript:self.close()">
                           <span><spring:message code="BUTTON.COMMON.CLOSE"/></span></a>
                         </li>
                  </ul>
                 </div>
</div>
</form>                

                  
<jsp:include page="/include/pop-body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

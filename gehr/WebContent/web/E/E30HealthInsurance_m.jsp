<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 건강보험                                                    */
/*   Program Name : 건강보험                                                    */
/*   Program ID   : E30HealthInsurance_m.jsp                                    */
/*   Description  : 건강보험 관련 정보 조회                                     */
/*   Note         :                                                             */
/*   Creation     : 2003-02-19  김도신                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                                                                              */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E30HealthInsurance.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    Vector e30Health01_vt = (Vector)request.getAttribute("e30Health01_vt");
    Vector e30Health02_vt = (Vector)request.getAttribute("e30Health02_vt");

    String E_MINUM = (String)request.getAttribute("E_MINUM");
    String E_MICNR = (String)request.getAttribute("E_MICNR");
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E30HealthInsurance.E30HealthInsuranceSV_m";
    document.form1.method = "post";
    document.form1.target = "listFrame";
    document.form1.submit();
}

$(document).ready(function(){
	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
 });

//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="X03PersonInfo.html'"/>
        <jsp:param name="click" value="Y"/>
    </jsp:include>
<form name="form1" method="post">
          <%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>


	<!--본인정보 테이블 시작-->
	<div class="listArea">
		<div class="table">
	        <table class="listTable">
	          <thead>
	          <tr>
	            <th><!-- 성명 --><%=g.getMessage("LABEL.E.E29.0001")%></th>
	            <th><!-- 주민번호 --><%=g.getMessage("LABEL.E.E29.0002")%></th>
	            <th><!-- 현재등급 --><%=g.getMessage("LABEL.E.E29.0003")%></th>
	            <th class="lastCol"><!-- 가입일 --><%=g.getMessage("LABEL.E.E29.0004")%></th>
	          </tr>
	          </thead>
<%
    if( e30Health01_vt.size() == 0 ) {
%>
          <tr>
            <td class="lastCol" colspan="4"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
          </tr>
<%
    } else {
        E30HealthInsuranceData e30Health01 = (E30HealthInsuranceData)e30Health01_vt.get(0);
        String REGNO_dis = e30Health01.REGNO.substring(0, 6) + "-*******";
%>
	          <tr class="oddRow">
	            <td><%= e30Health01.LNMHG + e30Health01.FNMHG %></td>
	            <td><%= REGNO_dis %></td>
	            <td><%= WebUtil.printNum(e30Health01.GRADE) %><!-- 등급 --><%=g.getMessage("LABEL.E.E29.0005")%></td>
	            <td class="lastCol"><%= WebUtil.printDate(e30Health01.BEGDA) %></td>
	          </tr>
	        </table>
		</div>
	</div>
	<!--본인정보 테이블 끝-->

	<h2 class="subtitle"><!--  대상정보 --><%=g.getMessage("LABEL.E.E30.0001")%></h2>

	<!--대상정보 테이블 시작-->
	<div class="listArea">
		<div class="table">
	         <table class="listTable">
	         <thead>
	          <tr>
	            <th><!--  사업장 기호 --><%=g.getMessage("LABEL.E.E30.0002")%></th>
	            <th class="lastCol"><!--  대상정보 --><%=g.getMessage("LABEL.E.E30.0003")%></th>
	          </tr>
	          </thead>
	          <tr class="oddRow">
	            <!--[CSR ID:1559057] 건강보험 사업장기호 수정의 건-->

	            <!--<td class="td04"><%= E_MINUM.substring(0,1) + "-" + E_MINUM.substring(1,8) %></td>-->
	            <td><%= E_MINUM %></td>

	            <td class="lastCol"><%= E_MICNR %></td>
	          </tr>
	        </table>
		</div>
	</div>
	<!--대상정보 테이블 끝-->

<!--2004.03.31 mkbae.
<%
        if( e30Health02_vt.size() > 0 ) {
%>
    <tr>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif"> 피보험 대상자</td>
    </tr>
     <tr>
      <td>
        <!--피보험 대상자 테이블 시작-->
        <!--<table width="461" border="0" cellspacing="1" cellpadding="2" class="table02">
          <tr>
            <td class="td03" width="100">가족유형</td>
            <td class="td03" width="100">성명</td>
            <td class="td03" width="161">주민번호</td>
            <td class="td03" width="100">가입일자</td>
          </tr>
<%
            for( int i = 0 ; i < e30Health02_vt.size() ; i++ ) {
                E30HealthInsuranceData e30Health02 = (E30HealthInsuranceData)e30Health02_vt.get(i);
%>
          <tr>
            <td class="td04"><%= e30Health02.STEXT %></td>
            <td class="td04"><%= e30Health02.LNMHG + e30Health02.FNMHG %></td>
            <td class="td04"><%= DataUtil.addSeparate(e30Health02.REGNO) %></td>
            <td class="td04"><%= WebUtil.printDate(e30Health02.BEGDA) %></td>
          </tr>
<%
            }
%>
        </table>
        <!--피보험 대상자 테이블 끝-->
      <!--</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
<%
        }
%>
-->
<%
    }
%>
</div>
<%
}
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
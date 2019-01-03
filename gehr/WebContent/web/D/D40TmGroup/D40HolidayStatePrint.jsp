<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 휴가사용현황 프린트					*/
/*   Program ID		: D40HolidayStatePrint.jsp								*/
/*   Description		: 근태집계표 - 휴가사용현황	 프린트					*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
	WebUserData user = (WebUserData)session.getAttribute("user");

	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE

	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름
	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜

	String I_BEGDA    = (String)request.getAttribute("I_BEGDA");	//선택날짜
	String I_ENDDA    = (String)request.getAttribute("I_ENDDA");	//선택날짜
	String gubun    = (String)request.getAttribute("gubun");	//선택날짜
	String p_gubun    = (String)request.getAttribute("p_gubun");	//선택날짜
%>

<jsp:include page="/include/header.jsp" />
<!-- Page Skip 해서 프린트 하기 -->
<style type = "text/css">
P.breakhere {page-break-before: always}
</style>


<jsp:include page="/include/header.jsp" />
<style type="text/css">
P.breakhere {
	page-break-before: always
}
</style>



<jsp:include page="/include/body-header.jsp">
	<jsp:param name="click" value="Y"/>
</jsp:include>

<form name="form1" method="post">


	<div class="winPop">
		<div class="header">
			<span><!-- 휴가사용현황--><%=g.getMessage("LABEL.D.D40.0059")%></span>
			<a href=""onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
		</div>
	</div>

<%
	//부서명, 조회된 건수.
	if ( T_EXPORTA != null && T_EXPORTA.size() > 0 ) {
		//[CSR ID:3038270]
		double sumOCCUR = 0.0;
		double sumABWTG = 0.0;
		double sumZKVRB = 0.0;
		String allAVG = "0.00";
%>

	<div class="listArea">
		<div class="listTop">
	  		<span class="listCnt">
	  			<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
	  		</span>
		</div>

		<div class="table">
  			<div class="wideTable">
      			<table class="listTable">
      				<thead>
        				<tr>
				            <th><!-- 이름 --><%=g.getMessage("LABEL.F.F41.0005")%></th>
		                	<th><!-- 사번 --><%=g.getMessage("LABEL.F.F41.0004")%></th>
				            <th><!-- 소속 --><%=g.getMessage("LABEL.F.F41.0006")%></th>
				            <th><!-- 직책 --><%=g.getMessage("LABEL.F.F41.0007")%></th>
						    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
				    	    <%--<th><!-- 직위 --><%=g.getMessage("LABEL.F.F41.0008")%></th> --%>
							<th><!-- 직위/직급호칭 --><%=g.getMessage("MSG.A.A01.0083")%></th>
				             <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
<%-- 				            <th><!-- 직급 --><%=g.getMessage("LABEL.F.F41.0009")%></th> --%>
<%-- 				            <th><!-- 호봉 --><%=g.getMessage("LABEL.F.F41.0010")%></th> --%>
<%-- 				            <th><!-- 연차 --><%=g.getMessage("LABEL.F.F41.0011")%></th> --%>
				            <th><!-- 입사일자 --><%=g.getMessage("LABEL.F.F41.0012")%></th>
				            <th><!-- 발생일수 --><%=g.getMessage("LABEL.F.F41.0013")%></th>
				            <th><!--사용일수 --><%=g.getMessage("LABEL.F.F41.0014")%></th>
				            <th><!--잔여일수 --><%=g.getMessage("LABEL.F.F41.0015")%></th>
				            <th class="lastCol"><!-- 휴가사용율 --><%=g.getMessage("LABEL.F.F41.0016")%>(%)</th>
               	 		</tr>
					</thead>
					<tbody>
<%
		//전체 합계를 구함//[CSR ID:3038270]
		for( int i = 0; i < T_EXPORTA.size(); i++ ){
			D40HolidayStateData data = (D40HolidayStateData)T_EXPORTA.get(i);
			sumOCCUR += Double.parseDouble(data.OCCUR);
			sumABWTG += Double.parseDouble(data.ABWTG);
			sumZKVRB += Double.parseDouble(data.ZKVRB);
		}

		//평균 값 계산//[CSR ID:3038270]
		if(sumABWTG >0 && sumOCCUR>0){
			allAVG = WebUtil.printNumFormat((sumABWTG / sumOCCUR )*100,2);
		}else{
			allAVG = "0.00";
		}

		for( int i = 0; i < T_EXPORTA.size(); i++ ){
			D40HolidayStateData data = (D40HolidayStateData)T_EXPORTA.get(i);
		    String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

		    //[CSR ID:3038270]
			String class1 = "";
			if (Double.parseDouble(data.CONSUMRATE)>=Double.parseDouble(allAVG)) {
				class1 = "";
			} else {
				class1 = "bgcolor='#f8f5ed'";
			}
%>
						<tr>
				            <td <%=class1%>><%= data.KNAME %></td>
				            <td <%=class1%>><%= data.PERNR %></td>
				            <td <%=class1%>><%= data.ORGTX %></td>
				            <td <%=class1%>><%= data.TITL2 %></td>
				            <td <%=class1%>><%= data.TITEL %></td>
<%-- 				            <td <%=class1%>><%= data.TRFGR %></td> --%>
<%-- 				            <td <%=class1%>><%= data.TRFST %></td> --%>
<%-- 				            <td <%=class1%>><%= data.VGLST %></td> --%>
				            <td <%=class1%>><%= (data.DAT01).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT01) %></td>
				            <td <%=class1%>><%= WebUtil.printNumFormat(data.OCCUR,2) %></td>
				            <td <%=class1%>><%= WebUtil.printNumFormat(data.ABWTG,2) %></td>
				            <td <%=class1%>><%= WebUtil.printNumFormat(data.ZKVRB,2) %></td>
				            <td class="lastCol" <%=class1%>><%= data.CONSUMRATE %></td>
          				</tr>
<%
		} //end for...
%>
          				<tr class="sumRow">
							<td class="td11" colspan="6"><%=g.getMessage("LABEL.D.D40.0058")%></td>
							<td class="td11"><%=sumOCCUR %></td>
							<td class="td11"><%=sumABWTG %></td>
							<td class="td11" ><%=sumZKVRB %></td>
							<td class="lastCol td11"><%=allAVG %></td>
						</tr>
					</tbody>
        		</table>
        	</div>
        </div>
<%--         <span class="commentOne">&nbsp;<!-- 건전한 휴가 사용 문화 정착을 위하여 조직책임자께서는  <font color="#CC3300" ><b><u>본인을 포함한</u></b></font> 조직 구성원 전체의 사전 휴가 계획 수립/관리 바랍니다. --><%=g.getMessage("MSG.F.F41.0001")%></span> --%>

<%
    }else{
%>
		<div class="align_center">
			<span><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.F.FCOMMON.0002")%></span>
		</div>
<%
	} //end if...
%>
	</div>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

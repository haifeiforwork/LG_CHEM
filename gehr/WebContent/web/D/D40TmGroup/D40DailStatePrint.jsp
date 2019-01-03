<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 일간 프린트								*/
/*   Program ID		: D40DailStatePrint.jsp									*/
/*   Description		: 근태집계표 - 일간	 프린트								*/
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

	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자

	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE
	Vector T_EXPORTB    = (Vector)request.getAttribute("T_EXPORTB");	//근무계획표-DATA
	String E_DAY_CNT    = (String)request.getAttribute("E_DAY_CNT");	//

	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름
	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜

	String I_BEGDA    = (String)request.getAttribute("I_BEGDA");	//선택날짜
	String I_ENDDA    = (String)request.getAttribute("I_ENDDA");	//선택날짜
	String gubun    = (String)request.getAttribute("gubun");	//선택날짜
	String p_gubun    = (String)request.getAttribute("p_gubun");	//선택날짜
%>

<jsp:include page="/include/header.jsp" />
<style type="text/css">
P.breakhere {
	page-break-before: always
}
</style>

<SCRIPT LANGUAGE="JavaScript">
<!--
function prevDetail() {
  switch (location.hash)  {
    case "#page2":
      location.hash ="#page1";
    break;
  } // end switch
}

function nextDetail() {
  switch (location.hash)  {
    case "":
    case "#page1":
      location.hash ="#page2";
    break;
  } // end switch
}

function click() {
    if (event.button==2) {
      //alert('마우스 오른쪽 버튼은 사용할수 없습니다.');
      //alert('오른쪽 버튼은 사용할수 없습니다.');
      alert('<%=g.getMessage("MSG.F.F41.0006")%>');

   return false;
    }
  }

 function keypressed() {
      //alert('키를 사용할 수 없습니다.');
       return false;
  }

  document.onmousedown=click;
  document.onkeydown=keypressed;


//-->
</SCRIPT>


<jsp:include page="/include/body-header.jsp">
	<jsp:param name="click" value="Y"/>
</jsp:include>

<form name="form1" method="post">


	<div class="winPop">
		<div class="header">
			<span><!-- 일간 근태 집계표--><%=g.getMessage("TAB.COMMON.0043")%></span>
			<a href=""onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
		</div>
	</div>

<%
		//부서명, 조회된 건수.
		D40DailStateData titleData = (D40DailStateData) T_EXPORTA.get(0);

		String tempDept = "";

		for (int j = 0; j < T_EXPORTB.size(); j++) {
			D40DailStateData deptData = (D40DailStateData) T_EXPORTB.get(j);
			//하위부서를 선택했을 경우 부서 비교.
			if (!deptData.ORGEH.equals(tempDept)) {
%>

	<div class="listArea">
		<div class="listTop">
	  		<span class="listCnt">
	  			<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> :	<%=deptData.STEXT%></h2>
	  		</span>
	  		<div style="position:relative; display:block; text-align:right; margin-right: 8px;margin-left: 2px;top:8px; ">
	  			<%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %>
	  		</div>
		</div>

		<div class="table">
  			<div class="wideTable">
      			<table class="listTable">
      				<thead>
        				<tr>
<%-- 							<th rowspan="2"><!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%></th> --%>
							<th rowspan="2"><!-- 이름--><%=g.getMessage("LABEL.D.D12.0018")%></th>
							<th rowspan="2"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
							<th rowspan="2"><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></th>
							<th colspan="<%=E_DAY_CNT%>"><!-- 일일근태내용--><%=g.getMessage("LABEL.F.F43.0002")%>(<%=titleData.BEGDA%> ~ <%=titleData.ENDDA%>)</th>
							<th class="lastCol" rowspan="2"><!-- 서명--><%=g.getMessage("LABEL.F.F42.0054")%></th>
						</tr>
						<tr>
							<%=titleData.D1.equals("00") ? "" : "<th>" + titleData.D1 + "</th>"%>
							<%=titleData.D2.equals("00") ? "" : "<th>" + titleData.D2 + "</th>"%>
							<%=titleData.D3.equals("00") ? "" : "<th>" + titleData.D3 + "</th>"%>
							<%=titleData.D4.equals("00") ? "" : "<th>" + titleData.D4 + "</th>"%>
							<%=titleData.D5.equals("00") ? "" : "<th>" + titleData.D5 + "</th>"%>
							<%=titleData.D6.equals("00") ? "" : "<th>" + titleData.D6 + "</th>"%>
							<%=titleData.D7.equals("00") ? "" : "<th>" + titleData.D7 + "</th>"%>
							<%=titleData.D8.equals("00") ? "" : "<th>" + titleData.D8 + "</th>"%>
							<%=titleData.D9.equals("00") ? "" : "<th>" + titleData.D9 + "</th>"%>
							<%=titleData.D10.equals("00") ? "" : "<th>" + titleData.D10 + "</th>"%>
							<%=titleData.D11.equals("00") ? "" : "<th>" + titleData.D11 + "</th>"%>
							<%=titleData.D12.equals("00") ? "" : "<th>" + titleData.D12 + "</th>"%>
							<%=titleData.D13.equals("00") ? "" : "<th>" + titleData.D13 + "</th>"%>
							<%=titleData.D14.equals("00") ? "" : "<th>" + titleData.D14 + "</th>"%>
							<%=titleData.D15.equals("00") ? "" : "<th>" + titleData.D15 + "</th>"%>
							<%=titleData.D16.equals("00") ? "" : "<th>" + titleData.D16 + "</th>"%>
							<%=titleData.D17.equals("00") ? "" : "<th>" + titleData.D17 + "</th>"%>
							<%=titleData.D18.equals("00") ? "" : "<th>" + titleData.D18 + "</th>"%>
							<%=titleData.D19.equals("00") ? "" : "<th>" + titleData.D19 + "</th>"%>
							<%=titleData.D20.equals("00") ? "" : "<th>" + titleData.D20 + "</th>"%>
							<%=titleData.D21.equals("00") ? "" : "<th>" + titleData.D21 + "</th>"%>
							<%=titleData.D22.equals("00") ? "" : "<th>" + titleData.D22 + "</th>"%>
							<%=titleData.D23.equals("00") ? "" : "<th>" + titleData.D23 + "</th>"%>
							<%=titleData.D24.equals("00") ? "" : "<th>" + titleData.D24 + "</th>"%>
							<%=titleData.D25.equals("00") ? "" : "<th>" + titleData.D25 + "</th>"%>
							<%=titleData.D26.equals("00") ? "" : "<th>" + titleData.D26 + "</th>"%>
							<%=titleData.D27.equals("00") ? "" : "<th>" + titleData.D27 + "</th>"%>
							<%=titleData.D28.equals("00") ? "" : "<th>" + titleData.D28 + "</th>"%>
							<%=titleData.D29.equals("00") ? "" : "<th>" + titleData.D29 + "</th>"%>
							<%=titleData.D30.equals("00") ? "" : "<th>" + titleData.D30 + "</th>"%>
							<%=titleData.D31.equals("00") ? "" : "<th>" + titleData.D31 + "</th>"%>
						</tr>
					</thead>
<%
					String preEmpNo = "";
					int cnt = 0;
					for (int i = j; i < T_EXPORTB.size(); i++) {
						D40DailStateData data = (D40DailStateData) T_EXPORTB.get(i);
						String tr_class = "";
						if (data.ORGEH.equals(deptData.ORGEH)) {
							if (cnt % 2 == 0) {
								tr_class = "oddRow";
							} else {
								tr_class = "";
							}
							cnt++;
%>
					<tbody>
						<tr class="<%=tr_class%>">
<%-- 							<td>&nbsp;<%=cnt%></td>  --%>
							<td nowrap><%=data.ENAME%></td>
							<td><%=data.PERNR%></td>
							<td><%=WebUtil.printNumFormat(data.REMA_HUGA, 1)%></td>
							<%=titleData.D1.equals("00") ? "" : "<td>"+ data.D1 + "</td>"%>
							<%=titleData.D2.equals("00") ? "" : "<td>"+ data.D2 + "</td>"%>
							<%=titleData.D3.equals("00") ? "" : "<td>"+ data.D3 + "</td>"%>
							<%=titleData.D4.equals("00") ? "" : "<td>"+ data.D4 + "</td>"%>
							<%=titleData.D5.equals("00") ? "" : "<td>"+ data.D5 + "</td>"%>
							<%=titleData.D6.equals("00") ? "" : "<td>"+ data.D6 + "</td>"%>
							<%=titleData.D7.equals("00") ? "" : "<td>"+ data.D7 + "</td>"%>
							<%=titleData.D8.equals("00") ? "" : "<td>"+ data.D8 + "</td>"%>
							<%=titleData.D9.equals("00") ? "" : "<td>"+ data.D9 + "</td>"%>
							<%=titleData.D10.equals("00") ? "" : "<td>"+ data.D10 + "</td>"%>
							<%=titleData.D11.equals("00") ? "" : "<td>"+ data.D11 + "</td>"%>
							<%=titleData.D12.equals("00") ? "" : "<td>"+ data.D12 + "</td>"%>
							<%=titleData.D13.equals("00") ? "" : "<td>"+ data.D13 + "</td>"%>
							<%=titleData.D14.equals("00") ? "" : "<td>"+ data.D14 + "</td>"%>
							<%=titleData.D15.equals("00") ? "" : "<td>"+ data.D15 + "</td>"%>
							<%=titleData.D16.equals("00") ? "" : "<td>"+ data.D16 + "</td>"%>
							<%=titleData.D17.equals("00") ? "" : "<td>"+ data.D17 + "</td>"%>
							<%=titleData.D18.equals("00") ? "" : "<td>"+ data.D18 + "</td>"%>
							<%=titleData.D19.equals("00") ? "" : "<td>"+ data.D19 + "</td>"%>
							<%=titleData.D20.equals("00") ? "" : "<td>"+ data.D20 + "</td>"%>
							<%=titleData.D21.equals("00") ? "" : "<td>"+ data.D21 + "</td>"%>
							<%=titleData.D22.equals("00") ? "" : "<td>"+ data.D22 + "</td>"%>
							<%=titleData.D23.equals("00") ? "" : "<td>"+ data.D23 + "</td>"%>
							<%=titleData.D24.equals("00") ? "" : "<td>"+ data.D24 + "</td>"%>
							<%=titleData.D25.equals("00") ? "" : "<td>"+ data.D25 + "</td>"%>
							<%=titleData.D26.equals("00") ? "" : "<td>"+ data.D26 + "</td>"%>
							<%=titleData.D27.equals("00") ? "" : "<td>"+ data.D27 + "</td>"%>
							<%=titleData.D28.equals("00") ? "" : "<td>"+ data.D28 + "</td>"%>
							<%=titleData.D29.equals("00") ? "" : "<td>"+ data.D29 + "</td>"%>
							<%=titleData.D30.equals("00") ? "" : "<td>"+ data.D30 + "</td>"%>
							<%=titleData.D31.equals("00") ? "" : "<td>"+ data.D31 + "</td>"%>
							<td class="lastCol" style="font-size: 8px;"><font color="#BDBDBD"><%=data.ENAME%></font></td>
						</tr>
					</tbody>
<%
						}//end if
					} //end for...
%>
				</table>
			</div>
		</div>

		<h2 class="subtitle"><!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%></h2>
		<div class="listArea">
			<div class="table">
				<table class="listTable">
					<colgroup>
						<col width="16%" />
						<col width="42%" />
						<col width="42%" />
<!-- 						<col width="10%" /> -->
					</colgroup>
					<thead>
						<tr>
							<th width="100">&nbsp;</th>
		                   	<th><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></th>
		                   	<th class="lastCol"><!-- 일수--><%=g.getMessage("LABEL.F.F42.0047")%></th>
<%-- 		                   	<th ><!-- 횟수--><%=g.getMessage("LABEL.F.F42.0049")%></th> --%>
						</tr>
					</thead>
					<tr class="oddRow">
						<td class="align_center"><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></td>
						<td style="text-align: left; padding-left: 20px;">
		                  	L:<spring:message code="LABEL.D.D40.0126"/><!-- 시간공가 --> U:<spring:message code="LABEL.D.D40.0127"/><!-- 휴일근무 --> <br/>
							W:<spring:message code="LABEL.D.D40.0128"/><!-- 모성보호휴가 --><br/>
							O:<spring:message code="LABEL.D.D40.0142"/><!-- 지각 --> P:<spring:message code="LABEL.D.D40.0143"/><!-- 조퇴 --> Q:<spring:message code="LABEL.D.D40.0144"/><!-- 외출 -->
						</td>
						<td style="text-align: left; padding-left: 20px;">
		                   	D:<spring:message code="LABEL.D.D40.0129"/><!-- 반일휴가(전반) --> E:<spring:message code="LABEL.D.D40.0130"/><!-- 반일휴가(후반) --> F:<spring:message code="LABEL.D.D40.0131"/><!-- 보건휴가 --><br/>
							C:<spring:message code="LABEL.D.D40.0132"/><!-- 전일휴가 --> G:<spring:message code="LABEL.D.D40.0133"/><!-- 경조휴가 --> H:<spring:message code="LABEL.D.D40.0134"/><!-- 하계휴가 --><br/>
							J:<spring:message code="LABEL.D.D40.0136"/><!-- 산전후휴가 --> K:<spring:message code="LABEL.D.D40.0137"/><!-- 전일공가 --> M:<spring:message code="LABEL.D.D40.0138"/><!-- 유급결근 --> N:<spring:message code="LABEL.D.D40.0139"/><!-- 무급결근   --><br/>
							V:<spring:message code="LABEL.D.D40.0135"/><!-- 근속여행공가 --> R:<spring:message code="LABEL.D.D40.0140"/><!-- 휴직/공상  --> S:<spring:message code="LABEL.D.D40.0141"/><!-- 산재 -->
						</td>
<!-- 						<td class="lastCol" > -->
<%-- 		                   	O:<spring:message code="LABEL.D.D40.0142"/><!-- 지각 --><br/> --%>
<%-- 							P:<spring:message code="LABEL.D.D40.0143"/><!-- 조퇴 --><br/> --%>
<%-- 							Q:<spring:message code="LABEL.D.D40.0144"/><!-- 외출 --> --%>
<!-- 						</td> -->
					</tr>
					<tr>
						<td class="align_center"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></td>
						<td>&nbsp;</td>
						<td style="text-align: left; padding-left: 20px;" class="lastCol">
		                   	A:<spring:message code="LABEL.D.D40.0145"/><!-- 교육(근무시간내)--> B:<spring:message code="LABEL.D.D40.0146"/><!-- 출장 -->
						</td>
<!-- 						<td class="lastCol">&nbsp;</td> -->
					</tr>
					<tr class="oddRow">
						<td class="align_center"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></td>
						<td style="text-align: left; padding-left: 20px;">
		                   	OA:<spring:message code="LABEL.D.D40.0147"/><!-- 휴일특근 --> OC:<spring:message code="LABEL.D.D40.0148"/><!-- 명절특근 --> OE:<spring:message code="LABEL.D.D40.0149"/><!-- 휴일연장 --> OF:<spring:message code="LABEL.D.D40.0150"/><!-- 연장근무 --><br/>
							OG:<spring:message code="LABEL.D.D40.0151"/><!-- 야간근로 -->
						</td>
						<td class="lastCol">&nbsp;</td>
<!-- 						<td>&nbsp;</td> -->
					</tr>
					<tr>
						<td class="align_center"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></td>
						<td style="text-align: left; padding-left: 20px;">
		                   	EA:<spring:message code="LABEL.D.D40.0152"/><!-- 향군(근무시간외)--> EB:<spring:message code="LABEL.D.D40.0153"/><!-- 교육(근무시간외)-->
						</td>
						<td class="lastCol">&nbsp;</td>
<!-- 						<td>&nbsp;</td> -->
					</tr>
				</table>
			</div>
		</div>
		<div style="page-break-before:always"></div>

<%
                //부서코드 비교를 위한 값.
                tempDept = deptData.ORGEH;
			}//end if
		}//end for
%>
	</div>

</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

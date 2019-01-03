
<%
	/********************************************************************************/
	/*                                                                            	*/
	/*   System Name  : MSS                                                       	*/
	/*   1Depth Name  : Manaer's Desk                                             	*/
	/*   2Depth Name  : 근태                                                        		*/
	/*   Program Name : 일간 근태 집계표                                            		*/
	/*   Program ID   : F43DeptDayWorkConditionPrint.jsp                            */
	/*   Description  : 부서별 일간 근태 집계표 출력을 위한 jsp 파일                		*/
	/*   Note         : 없음                                                        		*/
	/*   Creation     : 2009-03-03 김종서                                           		*/
	/*   Update       : 2018-07-19 성환희 [Worktime52] 잔여보상휴가 추가                 */
	/*                                                                              */
	/********************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/web/common/commonProcess.jsp"%>

<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.F.*"%>

<%
	String deptId = WebUtil.nvl(request.getParameter("hdn_deptId")); //부서코드
	String deptNm = WebUtil.nvl(request.getParameter("hdn_deptNm")); //부서명
	String searchDay = WebUtil.nvl((String) request
			.getAttribute("E_YYYYMON")); //대상년월
	String year = "";
	String month = "";
	String dayCnt = WebUtil.nvl(
			(String) request.getAttribute("E_DAY_CNT"), "28"); //일자수
	Vector F43DeptDayTitle_vt = (Vector) request
			.getAttribute("F43DeptDayTitle_vt"); //제목
	Vector F43DeptDayData_vt = (Vector) request
			.getAttribute("F43DeptDayData_vt"); //내용
%>


<jsp:include page="/include/header.jsp" />
<style type="text/css">
P.breakhere {
	page-break-before: always
}
</style>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0"
	marginwidth="0" marginheight="0">
	<form name="form1" method="post" onsubmit="return false">
		<div class="winPop">
			<div class="header">
				<span>
					<!-- 일간 근태 집계표--><%=g.getMessage("TAB.COMMON.0043")%></span> <a href=""
					onclick="top.close();"><img
					src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" />
				</a>
			</div>
		</div>
		<div class="subWrapper iframeWrap wideTable" style="height:550px; overflow:auto">


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

			<div class="body" class="iframeWrap">

				<%
					//부서명, 조회된 건수.
					F43DeptDayTitleWorkConditionData titleData = (F43DeptDayTitleWorkConditionData) F43DeptDayTitle_vt
							.get(0);
					int day_width = 30;
					String table_width = "";
					if (!titleData.D31.equals("00")) {
						table_width = String.valueOf(145 + (day_width * 31));
					} else if (!titleData.D30.equals("00")) {
						table_width = String.valueOf(145 + (day_width * 30));
					} else if (!titleData.D29.equals("00")) {
						table_width = String.valueOf(145 + (day_width * 29));
					} else {
						table_width = String.valueOf(145 + (day_width * 28));
					}
				%>

				<div class="listArea">

					<%
						String tempDept = "";

						for (int j = 0; j < F43DeptDayData_vt.size(); j++) {
							F43DeptDayDataWorkConditionData deptData = (F43DeptDayDataWorkConditionData) F43DeptDayData_vt
									.get(j);

							//하위부서를 선택했을 경우 부서 비교.
							if (!deptData.ORGEH.equals(tempDept)) {
					%>

					<div class="body">
						<h2 class="subtitle"><%=g.getMessage("LABEL.F.F41.0002")%>
							:
							<%=deptData.STEXT%></h2>

						<%
							int year1 = Integer.parseInt(searchDay.substring(0, 4));
									int mon = Integer.parseInt(searchDay.substring(4, 6));
						%>



						<div class="listTop">
							<span class="listCnt"> <%=year1%><!-- 년 --><%=g.getMessage("LABEL.F.F42.0052")%>
								&nbsp;<%=mon%><!-- 월 --><%=g.getMessage("LABEL.F.F42.0053")%>
							</span>
						</div>
						<table width="" <%=table_width%>"" border="0" cellspacing="0"
							cellpadding="0">
							<TR>
								<TD>
									<div class="table">
										<table class="listTable">
											<thead>
												<tr>
													<th rowspan="2">
														<!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%></th>
													<th rowspan="2">
														<!-- 성명--><%=g.getMessage("LABEL.F.F42.0003")%></th>
													<th rowspan="2">
														<!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
													<th rowspan="2">
														<!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></th>
													<th rowspan="2">
														<!-- 잔여보상--><%=g.getMessage("LABEL.F.F42.0087")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
													<th colspan="<%=dayCnt%>">
														<!-- 일일근태내용--><%=g.getMessage("LABEL.F.F43.0002")%>(<%=titleData.BEGDA%>
														~ <%=titleData.ENDDA%>)</th>
													<th class="lastCol" rowspan="2">
														<!-- 서명--><%=g.getMessage("LABEL.F.F42.0054")%></th>
												</tr>
												<tr>
													<th width="<%=day_width%>"><%=titleData.D1%></th>
													<th width="<%=day_width%>"><%=titleData.D2%></th>
													<th width="<%=day_width%>"><%=titleData.D3%></th>
													<th width="<%=day_width%>"><%=titleData.D4%></th>
													<th width="<%=day_width%>"><%=titleData.D5%></th>
													<th width="<%=day_width%>"><%=titleData.D6%></th>
													<th width="<%=day_width%>"><%=titleData.D7%></th>
													<th width="<%=day_width%>"><%=titleData.D8%></th>
													<th width="<%=day_width%>"><%=titleData.D9%></th>
													<th width="<%=day_width%>"><%=titleData.D10%></th>
													<th width="<%=day_width%>"><%=titleData.D11%></th>
													<th width="<%=day_width%>"><%=titleData.D12%></th>
													<th width="<%=day_width%>"><%=titleData.D13%></th>
													<th width="<%=day_width%>"><%=titleData.D14%></th>
													<th width="<%=day_width%>"><%=titleData.D15%></th>
													<th width="<%=day_width%>"><%=titleData.D16%></th>
													<th width="<%=day_width%>"><%=titleData.D17%></th>
													<th width="<%=day_width%>"><%=titleData.D18%></th>
													<th width="<%=day_width%>"><%=titleData.D19%></th>
													<th width="<%=day_width%>"><%=titleData.D20%></th>
													<th width="<%=day_width%>"><%=titleData.D21%></th>
													<th width="<%=day_width%>"><%=titleData.D22%></th>
													<th width="<%=day_width%>"><%=titleData.D23%></th>
													<th width="<%=day_width%>"><%=titleData.D24%></th>
													<th width="<%=day_width%>"><%=titleData.D25%></th>
													<th width="<%=day_width%>"><%=titleData.D26%></th>
													<th width="<%=day_width%>"><%=titleData.D27%></th>
													<th width="<%=day_width%>"><%=titleData.D28%></th>
													<%=titleData.D29.equals("00") ? "" : "<th width="
							+ day_width + " >" + titleData.D29 + "</th>"%>
													<%=titleData.D30.equals("00") ? "" : "<th width="
							+ day_width + " >" + titleData.D30 + "</th>"%>
													<%=titleData.D31.equals("00") ? "" : "<th width="
							+ day_width + " >" + titleData.D31 + "</th>"%>
												</tr>
											</thead>
											<%
												String preEmpNo = "";
														int cnt = 0;
														for (int i = j; i < F43DeptDayData_vt.size(); i++) {
															F43DeptDayDataWorkConditionData data = (F43DeptDayDataWorkConditionData) F43DeptDayData_vt
																	.get(i);

															String tr_class = "";

															if (i % 2 == 0) {
																tr_class = "oddRow";
															} else {
																tr_class = "";
															}

															if (data.ORGEH.equals(deptData.ORGEH)) {
																cnt++;
											%>
											<tr class="<%=tr_class%>">
												<td>&nbsp;<%=cnt%></td>
												<td nowrap><%=data.ENAME%></td>
												<td><%=data.PERNR%></td>
												<td><%=WebUtil.printNumFormat(data.REMA_HUGA, 1)%></td>
												<td><%=WebUtil.printNumFormat(data.REMA_RWHUGA, 1)%></td>
												<td><%=data.D1%></td>
												<td><%=data.D2%></td>
												<td><%=data.D3%></td>
												<td><%=data.D4%></td>
												<td><%=data.D5%></td>
												<td><%=data.D6%></td>
												<td><%=data.D7%></td>
												<td><%=data.D8%></td>
												<td><%=data.D9%></td>
												<td><%=data.D10%></td>
												<td><%=data.D11%></td>
												<td><%=data.D12%></td>
												<td><%=data.D13%></td>
												<td><%=data.D14%></td>
												<td><%=data.D15%></td>
												<td><%=data.D16%></td>
												<td><%=data.D17%></td>
												<td><%=data.D18%></td>
												<td><%=data.D19%></td>
												<td><%=data.D20%></td>
												<td><%=data.D21%></td>
												<td><%=data.D22%></td>
												<td><%=data.D23%></td>
												<td><%=data.D24%></td>
												<td><%=data.D25%></td>
												<td><%=data.D26%></td>
												<td><%=data.D27%></td>
												<td><%=data.D28%></td>
												<%=titleData.D29.equals("00") ? "" : "<td >"
									+ data.D29 + "</td>"%>
												<%=titleData.D30.equals("00") ? "" : "<td >"
									+ data.D30 + "</td>"%>
												<%=titleData.D31.equals("00") ? "" : "<td>"
									+ data.D31 + "</td>"%>
												<td class="lastCol">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
											</tr>

											<%
												}//end if
														} //end for...
											%>
										</table>
									</div>
									</div> <%
 	//부서코드 비교를 위한 값.
 			tempDept = deptData.ORGEH;
 		}//end if
 	}//end for
 %>

									<h2 class="subtitle">
										<!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%></h2>

									<div class="listArea">
										<div class="table">
											<table class="listTable">
												<colgroup>
													<col width="16%" />
													<col width="42%" />
													<col width="42%" />
												</colgroup>
												<thead>
													<tr>
														<th>&nbsp;</th>
									                   	<th><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></th>
									                   	<th class="lastCol"><!-- 일수--><%=g.getMessage("LABEL.F.F42.0047")%></th>
									<%--                    	<th class="lastCol"><!-- 횟수--><%=g.getMessage("LABEL.F.F42.0049")%></th> --%>
													</tr>
												</thead>
												<tr class="oddRow">
													<td class="align_center"><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></td>
													<td style="text-align: left; padding-left: 20px;">
									                  	L:<spring:message code="LABEL.D.D40.0126"/><!-- 시간공가 --> U:<spring:message code="LABEL.D.D40.0127"/><!-- 휴일근무 --> <br/>
														W:<spring:message code="LABEL.D.D40.0128"/><!-- 모성보호휴가 --> <br/>
														O:<spring:message code="LABEL.D.D40.0142"/><!-- 지각 --> P:<spring:message code="LABEL.D.D40.0143"/><!-- 조퇴 --> Q:<spring:message code="LABEL.D.D40.0144"/><!-- 외출 -->
													</td>
													<td style="text-align: left; padding-left: 20px;" class="lastCol">
									                   	D:<spring:message code="LABEL.D.D40.0129"/><!-- 반일휴가(전반) --> E:<spring:message code="LABEL.D.D40.0130"/><!-- 반일휴가(후반) --> F:<spring:message code="LABEL.D.D40.0131"/><!-- 보건휴가 --> X:<spring:message code="LABEL.F.F42.0089"/><!-- 반일보상휴가(전반) --><br/>
														C:<spring:message code="LABEL.D.D40.0132"/><!-- 전일휴가 --> G:<spring:message code="LABEL.D.D40.0133"/><!-- 경조휴가 --> H:<spring:message code="LABEL.D.D40.0134"/><!-- 하계휴가 --> Y:<spring:message code="LABEL.F.F42.0090"/><!-- 반일보상휴가(후반) --><br/>
														J:<spring:message code="LABEL.D.D40.0136"/><!-- 산전후휴가 --> K:<spring:message code="LABEL.D.D40.0137"/><!-- 전일공가 --> M:<spring:message code="LABEL.D.D40.0138"/><!-- 유급결근 --> N:<spring:message code="LABEL.D.D40.0139"/><!-- 무급결근   --> Z:<spring:message code="LABEL.F.F42.0091"/><!-- 전일보상휴가 --><br/>
														V:<spring:message code="LABEL.D.D40.0135"/><!-- 근속여행공가 --> R:<spring:message code="LABEL.D.D40.0140"/><!-- 휴직/공상  --> S:<spring:message code="LABEL.D.D40.0141"/><!-- 산재 -->
													</td>
												</tr>
												<tr>
													<td class="align_center"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></td>
													<td>&nbsp;</td>
													<td class="lastCol" style="text-align: left; padding-left: 20px;">
									                   	A:<spring:message code="LABEL.D.D40.0145"/><!-- 교육(근무시간내)--> B:<spring:message code="LABEL.D.D40.0146"/><!-- 출장 -->
													</td>
												</tr>
												<tr class="oddRow">
													<td class="align_center"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></td>
													<td style="text-align: left; padding-left: 20px;">
									                   	OA:<spring:message code="LABEL.D.D40.0147"/><!-- 휴일특근 --> OC:<spring:message code="LABEL.D.D40.0148"/><!-- 명절특근 --> OE:<spring:message code="LABEL.D.D40.0149"/><!-- 휴일연장 --> OF:<spring:message code="LABEL.D.D40.0150"/><!-- 연장근무 --><br/>
														OG:<spring:message code="LABEL.D.D40.0151"/><!-- 야간근로 -->
													</td>
													<td class="lastCol">&nbsp;</td>
												</tr>
												<tr>
													<td class="align_center"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></td>
													<td style="text-align: left; padding-left: 20px;">
									                   	EA:<spring:message code="LABEL.D.D40.0152"/><!-- 향군(근무시간외)--> EB:<spring:message code="LABEL.D.D40.0153"/><!-- 교육(근무시간외)-->
													</td>
													<td class="lastCol">&nbsp;</td>
												</tr>
											</table>
										</div>
									</div>
								</TD>
							</TR>
						</table>
					</div>

				</div>
			</div>
		</div>

	</form>
	<jsp:include page="/include/body-footer.jsp" />
	<jsp:include page="/include/footer.jsp" />
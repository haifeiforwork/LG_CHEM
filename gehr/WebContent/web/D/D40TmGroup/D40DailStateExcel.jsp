<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 일간 엑셀다운로드						*/
/*   Program ID		: D40DailStateExcel.jsp									*/
/*   Description		: 근태집계표 - 일간	엑셀다운로드							*/
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
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%

	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자

    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                  //부서명
    String searchDay    = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));           //대상년월
    String dayCnt       = WebUtil.nvl((String)request.getAttribute("E_DAY_CNT"), "28");     //일자수
    Vector F43DeptDayTitle_vt = (Vector)request.getAttribute("T_EXPORTA");         //제목
    Vector F43DeptDayData_vt  = (Vector)request.getAttribute("T_EXPORTB");          //내용

    Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

// 	String fileName = java.net.URLEncoder.encode("일간근태집계표","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("TAB.D.D40.0015"),"UTF-8");
	fileName = fileName+time;
	fileName = fileName.replace("\r","").replace("\n","");
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename="+fileName+".xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<%
    //부서명, 조회된 건수.
    if ( F43DeptDayTitle_vt != null && F43DeptDayTitle_vt.size() > 0 ) {
    	D40DailStateData titleData = (D40DailStateData)F43DeptDayTitle_vt.get(0);

        //대상년월 폼 변경.
        if( !searchDay.equals("") )
            searchDay = searchDay.substring(0, 4)+"."+searchDay.substring(4, 6);
%>
<table width="2040" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">* <!-- 일간 근태 집계표--><%=g.getMessage("LABEL.F.F43.0001")%></td>
        </tr>
	    <tr><td colspan="15" height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
<!--   <tr> -->
<!--     <td width="16">&nbsp;</td> -->
<!--     <td colspan="15"> -->
<!--       <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"> -->
<!--         <tr> -->
<!--           <td colspan="15" class="td09"> -->
<%--             &nbsp;<!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%> : <!--월누계--><%=g.getMessage("LABEL.F.F42.0056")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --%>
<%--             &nbsp;<!-- 대상년월--><%=g.getMessage("LABEL.F.F42.0057")%> : <%=searchDay%> --%>
<!--           </td> -->
<!--           <td colspan="15"></td> -->
<!--         </tr> -->
<!--       </table> -->
<!--     </td> -->
<!--     <td  width="16">&nbsp;</td> -->
<!--   </tr> -->

<%
        String tempDept = "";
        for( int j = 0; j < F43DeptDayData_vt.size(); j++ ){
        	D40DailStateData deptData = (D40DailStateData)F43DeptDayData_vt.get(j);

            //하위부서를 선택했을 경우 부서 비교.
            if( !deptData.ORGEH.equals(tempDept) ){
%>
  <tr><td height="10"></td></tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td class="td09">&nbsp;<!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%>  : <%=deptData.STEXT%></td>
    <td class="td08"><%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %></td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr>
          <td width="60" rowspan="2" class="td03"><!-- 이름--><%=g.getMessage("LABEL.D.D12.0018")%></td>
          <td width="60" rowspan="2" class="td03"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></td>
          <td width="60" rowspan="2" class="td03"><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></td>
          <td colspan="<%=dayCnt%>" class="td03"><!-- 일일근태내용--><%=g.getMessage("LABEL.F.F43.0002")%>(<%=titleData.BEGDA%>~<%=titleData.ENDDA%>)</td>
        </tr>
        <tr>
          <%= titleData.D1.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D1 +"</td>" %>
          <%= titleData.D2.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D2 +"</td>" %>
          <%= titleData.D3.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D3 +"</td>" %>
          <%= titleData.D4.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D4 +"</td>" %>
          <%= titleData.D5.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D5 +"</td>" %>
          <%= titleData.D6.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D6 +"</td>" %>
          <%= titleData.D7.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D7 +"</td>" %>
          <%= titleData.D8.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D8 +"</td>" %>
          <%= titleData.D9.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D9 +"</td>" %>
          <%= titleData.D10.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D10+"</td>" %>
          <%= titleData.D11.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D11+"</td>" %>
          <%= titleData.D12.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D12+"</td>" %>
          <%= titleData.D13.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D13+"</td>" %>
          <%= titleData.D14.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D14+"</td>" %>
          <%= titleData.D15.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D15+"</td>" %>
          <%= titleData.D16.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D16+"</td>" %>
          <%= titleData.D17.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D17+"</td>" %>
          <%= titleData.D18.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D18+"</td>" %>
          <%= titleData.D19.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D19+"</td>" %>
          <%= titleData.D20.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D20+"</td>" %>
          <%= titleData.D21.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D21+"</td>" %>
          <%= titleData.D22.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D22+"</td>" %>
          <%= titleData.D23.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D23+"</td>" %>
          <%= titleData.D24.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D24+"</td>" %>
          <%= titleData.D25.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D25+"</td>" %>
          <%= titleData.D26.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D26+"</td>" %>
          <%= titleData.D27.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D27+"</td>" %>
          <%= titleData.D28.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D28+"</td>" %>
          <%= titleData.D29.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D29+"</td>" %>
          <%= titleData.D30.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D30+"</td>" %>
          <%= titleData.D31.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D31+"</td>" %>
        </tr>
<%
				for( int i = j; i < F43DeptDayData_vt.size(); i++ ){
					D40DailStateData data = (D40DailStateData)F43DeptDayData_vt.get(i);
				    if( data.ORGEH.equals(deptData.ORGEH) ){
%>
        <tr>
                    <td class="td04"><%=data.ENAME%></td>
          <td class="td04"><%=data.PERNR%></td>
          <td class="td04"><%=data.REMA_HUGA%></td>
          <%= titleData.D1.equals("00") ? "" : "<td class=td04>"+data.D1+"</td>" %>
          <%= titleData.D2.equals("00") ? "" : "<td class=td04>"+data.D2+"</td>" %>
          <%= titleData.D3.equals("00") ? "" : "<td class=td04>"+data.D3+"</td>" %>
          <%= titleData.D4.equals("00") ? "" : "<td class=td04>"+data.D4+"</td>" %>
          <%= titleData.D5.equals("00") ? "" : "<td class=td04>"+data.D5+"</td>" %>
          <%= titleData.D6.equals("00") ? "" : "<td class=td04>"+data.D6+"</td>" %>
          <%= titleData.D7.equals("00") ? "" : "<td class=td04>"+data.D7+"</td>" %>
          <%= titleData.D8.equals("00") ? "" : "<td class=td04>"+data.D8+"</td>" %>
          <%= titleData.D9.equals("00") ? "" : "<td class=td04>"+data.D9+"</td>" %>
          <%= titleData.D10.equals("00") ? "" : "<td class=td04>"+data.D10+"</td>" %>
          <%= titleData.D11.equals("00") ? "" : "<td class=td04>"+data.D11+"</td>" %>
          <%= titleData.D12.equals("00") ? "" : "<td class=td04>"+data.D12+"</td>" %>
          <%= titleData.D13.equals("00") ? "" : "<td class=td04>"+data.D13+"</td>" %>
          <%= titleData.D14.equals("00") ? "" : "<td class=td04>"+data.D14+"</td>" %>
          <%= titleData.D15.equals("00") ? "" : "<td class=td04>"+data.D15+"</td>" %>
          <%= titleData.D16.equals("00") ? "" : "<td class=td04>"+data.D16+"</td>" %>
          <%= titleData.D17.equals("00") ? "" : "<td class=td04>"+data.D17+"</td>" %>
          <%= titleData.D18.equals("00") ? "" : "<td class=td04>"+data.D18+"</td>" %>
          <%= titleData.D19.equals("00") ? "" : "<td class=td04>"+data.D19+"</td>" %>
          <%= titleData.D20.equals("00") ? "" : "<td class=td04>"+data.D20+"</td>" %>
          <%= titleData.D21.equals("00") ? "" : "<td class=td04>"+data.D21+"</td>" %>
          <%= titleData.D22.equals("00") ? "" : "<td class=td04>"+data.D22+"</td>" %>
          <%= titleData.D23.equals("00") ? "" : "<td class=td04>"+data.D23+"</td>" %>
          <%= titleData.D24.equals("00") ? "" : "<td class=td04>"+data.D24+"</td>" %>
          <%= titleData.D25.equals("00") ? "" : "<td class=td04>"+data.D25+"</td>" %>
          <%= titleData.D26.equals("00") ? "" : "<td class=td04>"+data.D26+"</td>" %>
          <%= titleData.D27.equals("00") ? "" : "<td class=td04>"+data.D27+"</td>" %>
          <%= titleData.D28.equals("00") ? "" : "<td class=td04>"+data.D28+"</td>" %>
          <%= titleData.D29.equals("00") ? "" : "<td class=td04>"+data.D29+"</td>" %>
          <%= titleData.D30.equals("00") ? "" : "<td class=td04>"+data.D30+"</td>" %>
          <%= titleData.D31.equals("00") ? "" : "<td class=td04>"+data.D31+"</td>" %>
        </tr>

<%
                    }//end if
		        } //end for...
%>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
<%
                //부서코드 비교를 위한 값.
	            tempDept = deptData.ORGEH;
	        }//end if
        }//end for
%>

  <tr><td height="15"></td></tr>
  <tr>
	<td width="16">&nbsp;</td>
	<td colspan="15" >
       <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td colspan="15" style="padding-bottom:2px">＊<!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%> </td>
        </tr>
        <tr>
          <td colspan="35">
            <table width="100%" border="1" cellpadding="0" cellspacing="1" class="table01">
              <tr class="td07">
                <td width="100">&nbsp;</td>
                <td colspan="7"><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></td>
                <td colspan="7"><!-- 일수--><%=g.getMessage("LABEL.F.F42.0047")%></td>
<%--                 <td colspan="4" width="200"><!-- 횟수--><%=g.getMessage("LABEL.F.F42.0049")%></td> --%>
              </tr>
              <tr>
                <td class="td07"><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></td>
                <td colspan="7" class="td09">
                	L:<spring:message code="LABEL.D.D40.0126"/><!-- 시간공가 --> U:<spring:message code="LABEL.D.D40.0127"/><!-- 휴일근무 --> <br/>
					W:<spring:message code="LABEL.D.D40.0128"/><!-- 모성보호휴가 --> <br/>
					O:<spring:message code="LABEL.D.D40.0142"/><!-- 지각 --> P:<spring:message code="LABEL.D.D40.0143"/><!-- 조퇴 --> Q:<spring:message code="LABEL.D.D40.0144"/><!-- 외출 -->
                </td>
                <td colspan="7" class="td09">
                	D:<spring:message code="LABEL.D.D40.0129"/><!-- 반일휴가(전반) --> E:<spring:message code="LABEL.D.D40.0130"/><!-- 반일휴가(후반) --> F:<spring:message code="LABEL.D.D40.0131"/><!-- 보건휴가 --><br/>
					C:<spring:message code="LABEL.D.D40.0132"/><!-- 전일휴가 --> G:<spring:message code="LABEL.D.D40.0133"/><!-- 경조휴가 --> H:<spring:message code="LABEL.D.D40.0134"/><!-- 하계휴가 --><br/>
					J:<spring:message code="LABEL.D.D40.0136"/><!-- 산전후휴가 --> K:<spring:message code="LABEL.D.D40.0137"/><!-- 전일공가 --> M:<spring:message code="LABEL.D.D40.0138"/><!-- 유급결근 --> N:<spring:message code="LABEL.D.D40.0139"/><!-- 무급결근   --><br/>
					V:<spring:message code="LABEL.D.D40.0135"/><!-- 근속여행공가 --> R:<spring:message code="LABEL.D.D40.0140"/><!-- 휴직/공상  --> S:<spring:message code="LABEL.D.D40.0141"/><!-- 산재 -->
                </td>
<!--                 <td colspan="4" class="td09"> -->
<%--                 	O:<spring:message code="LABEL.D.D40.0142"/><!-- 지각 --><br/> --%>
<%-- 					P:<spring:message code="LABEL.D.D40.0143"/><!-- 조퇴 --><br/> --%>
<%-- 					Q:<spring:message code="LABEL.D.D40.0144"/><!-- 외출 --> --%>
<!-- 				</td> -->
              </tr>
              <tr>
                <td class="td07"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="7" class="td09">
                	A:<spring:message code="LABEL.D.D40.0145"/><!-- 교육(근무시간내)--> B:<spring:message code="LABEL.D.D40.0146"/><!-- 출장 -->
				</td>
<!--                 <td colspan="4" class="td09">&nbsp;</td> -->
              </tr>
              <tr>
                <td class="td07"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></td>
                <td colspan="7" class="td09">
                	OA:<spring:message code="LABEL.D.D40.0147"/><!-- 휴일특근 --> OC:<spring:message code="LABEL.D.D40.0148"/><!-- 명절특근 --> OE:<spring:message code="LABEL.D.D40.0149"/><!-- 휴일연장 --> OF:<spring:message code="LABEL.D.D40.0150"/><!-- 연장근무 --><br/>
					OG:<spring:message code="LABEL.D.D40.0151"/><!-- 야간근로 -->
				</td>
                <td colspan="7" class="td09">&nbsp;</td>
<!--                 <td colspan="4" class="td09">&nbsp;</td> -->
              </tr>
              <tr>
                <td class="td07"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></td>
                <td colspan="7" class="td09">
                	EA:<spring:message code="LABEL.D.D40.0152"/><!-- 향군(근무시간외)--> EB:<spring:message code="LABEL.D.D40.0153"/><!-- 교육(근무시간외)-->
				</td>
                <td colspan="7" class="td09">&nbsp;</td>
<!--                 <td colspan="4" class="td09">&nbsp;</td> -->
              </tr>
            </table>
          </td>
        </tr>
      </table>
    <td colspan="15"  width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>
<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.COMMON.0004")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>
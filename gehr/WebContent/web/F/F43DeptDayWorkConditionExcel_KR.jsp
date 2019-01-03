<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 일간 근태 집계표                                            		*/
/*   Program ID   : F43DeptDayWorkConditionExcel.jsp                            */
/*   Description  : 부서별 일간 근태 집계표 Excel 저장을 위한 jsp 파일          		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2005-02-18 유용원                                           		*/
/*   Update       : 2018-07-19 성환희 [Worktime52] 잔여보상휴가 추가                 */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>

<%
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                  //부서명
    String searchDay    = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));           //대상년월
    String dayCnt       = WebUtil.nvl((String)request.getAttribute("E_DAY_CNT"), "28");     //일자수
    Vector F43DeptDayTitle_vt = (Vector)request.getAttribute("F43DeptDayTitle_vt");         //제목
    Vector F43DeptDayData_vt  = (Vector)request.getAttribute("F43DeptDayData_vt");          //내용

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptDayWorkCondition.xls");
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
        F43DeptDayTitleWorkConditionData titleData = (F43DeptDayTitleWorkConditionData)F43DeptDayTitle_vt.get(0);

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
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="15" class="td09">
            &nbsp;<!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%> : <!--월누계--><%=g.getMessage("LABEL.F.F42.0056")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;<!-- 대상년월--><%=g.getMessage("LABEL.F.F42.0057")%> : <%=searchDay%>
          </td>
          <td colspan="15"></td>
        </tr>
      </table>
    </td>
    <td  width="16">&nbsp;</td>
  </tr>

<%
        String tempDept = "";
        for( int j = 0; j < F43DeptDayData_vt.size(); j++ ){
            F43DeptDayDataWorkConditionData deptData = (F43DeptDayDataWorkConditionData)F43DeptDayData_vt.get(j);

            //하위부서를 선택했을 경우 부서 비교.
            if( !deptData.ORGEH.equals(tempDept) ){
%>
  <tr><td colspan="15" height="10"></td></tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td class="td09">&nbsp;<!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%>  : <%=deptData.STEXT%></td>
    <td class="td08">&nbsp;</td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr>
          <td width="60" rowspan="2" class="td03"><!-- 성명--><%=g.getMessage("LABEL.F.F42.0003")%></td>
          <td width="60" rowspan="2" class="td03"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></td>
          <td width="60" rowspan="2" class="td03"><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></td>
          <td width="60" rowspan="2" class="td03"><!-- 잔여보상--><%=g.getMessage("LABEL.F.F42.0087")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></td>
          <td colspan="<%=dayCnt%>" class="td03"><!-- 일일근태내용--><%=g.getMessage("LABEL.F.F43.0002")%>(<%=titleData.BEGDA%>~<%=titleData.ENDDA%>)</td>
        </tr>
        <tr>
          <td width="60" class="td03"><%= titleData.D1  %></td>
          <td width="60" class="td03"><%= titleData.D2  %></td>
          <td width="60" class="td03"><%= titleData.D3  %></td>
          <td width="60" class="td03"><%= titleData.D4  %></td>
          <td width="60" class="td03"><%= titleData.D5  %></td>
          <td width="60" class="td03"><%= titleData.D6  %></td>
          <td width="60" class="td03"><%= titleData.D7  %></td>
          <td width="60" class="td03"><%= titleData.D8  %></td>
          <td width="60" class="td03"><%= titleData.D9  %></td>
          <td width="60" class="td03"><%= titleData.D10 %></td>
          <td width="60" class="td03"><%= titleData.D11 %></td>
          <td width="60" class="td03"><%= titleData.D12 %></td>
          <td width="60" class="td03"><%= titleData.D13 %></td>
          <td width="60" class="td03"><%= titleData.D14 %></td>
          <td width="60" class="td03"><%= titleData.D15 %></td>
          <td width="60" class="td03"><%= titleData.D16 %></td>
          <td width="60" class="td03"><%= titleData.D17 %></td>
          <td width="60" class="td03"><%= titleData.D18 %></td>
          <td width="60" class="td03"><%= titleData.D19 %></td>
          <td width="60" class="td03"><%= titleData.D20 %></td>
          <td width="60" class="td03"><%= titleData.D21 %></td>
          <td width="60" class="td03"><%= titleData.D22 %></td>
          <td width="60" class="td03"><%= titleData.D23 %></td>
          <td width="60" class="td03"><%= titleData.D24 %></td>
          <td width="60" class="td03"><%= titleData.D25 %></td>
          <td width="60" class="td03"><%= titleData.D26 %></td>
          <td width="60" class="td03"><%= titleData.D27 %></td>
          <td width="60" class="td03"><%= titleData.D28 %></td>
          <%= titleData.D29.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D29+"</td>" %>
          <%= titleData.D30.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D30+"</td>" %>
          <%= titleData.D31.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D31+"</td>" %>
        </tr>
<%
				for( int i = j; i < F43DeptDayData_vt.size(); i++ ){
				    F43DeptDayDataWorkConditionData data = (F43DeptDayDataWorkConditionData)F43DeptDayData_vt.get(i);
				    if( data.ORGEH.equals(deptData.ORGEH) ){
%>
        <tr>
                    <td class="td04"><%=data.ENAME%></td>
          <td class="td04"><%=data.PERNR%></td>
          <td class="td04"><%=data.REMA_HUGA%></td>
          <td class="td04"><%=data.REMA_RWHUGA%></td>
          <td class="td04"><%=data.D1 %></td>
          <td class="td04"><%=data.D2 %></td>
          <td class="td04"><%=data.D3 %></td>
          <td class="td04"><%=data.D4 %></td>
          <td class="td04"><%=data.D5 %></td>
          <td class="td04"><%=data.D6 %></td>
          <td class="td04"><%=data.D7 %></td>
          <td class="td04"><%=data.D8 %></td>
          <td class="td04"><%=data.D9 %></td>
          <td class="td04"><%=data.D10%></td>
          <td class="td04"><%=data.D11%></td>
          <td class="td04"><%=data.D12%></td>
          <td class="td04"><%=data.D13%></td>
          <td class="td04"><%=data.D14%></td>
          <td class="td04"><%=data.D15%></td>
          <td class="td04"><%=data.D16%></td>
          <td class="td04"><%=data.D17%></td>
          <td class="td04"><%=data.D18%></td>
          <td class="td04"><%=data.D19%></td>
          <td class="td04"><%=data.D20%></td>
          <td class="td04"><%=data.D21%></td>
          <td class="td04"><%=data.D22%></td>
          <td class="td04"><%=data.D23%></td>
          <td class="td04"><%=data.D24%></td>
          <td class="td04"><%=data.D25%></td>
          <td class="td04"><%=data.D26%></td>
          <td class="td04"><%=data.D27%></td>
          <td class="td04"><%=data.D28%></td>
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

  <tr><td colspan="15" height="15"></td></tr>
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
                	D:<spring:message code="LABEL.D.D40.0129"/><!-- 반일휴가(전반) --> E:<spring:message code="LABEL.D.D40.0130"/><!-- 반일휴가(후반) --> F:<spring:message code="LABEL.D.D40.0131"/><!-- 보건휴가 --> X:<spring:message code="LABEL.F.F42.0089"/><!-- 반일보상휴가(전반) --><br/>
					C:<spring:message code="LABEL.D.D40.0132"/><!-- 전일휴가 --> G:<spring:message code="LABEL.D.D40.0133"/><!-- 경조휴가 --> H:<spring:message code="LABEL.D.D40.0134"/><!-- 하계휴가 --> Y:<spring:message code="LABEL.F.F42.0090"/><!-- 반일보상휴가(후반) --><br/>
					J:<spring:message code="LABEL.D.D40.0136"/><!-- 산전후휴가 --> K:<spring:message code="LABEL.D.D40.0137"/><!-- 전일공가 --> M:<spring:message code="LABEL.D.D40.0138"/><!-- 유급결근 --> N:<spring:message code="LABEL.D.D40.0139"/><!-- 무급결근   --> Z:<spring:message code="LABEL.F.F42.0091"/><!-- 전일보상휴가 --><br/>
					V:<spring:message code="LABEL.D.D40.0135"/><!-- 근속여행공가 --> R:<spring:message code="LABEL.D.D40.0140"/><!-- 휴직/공상  --> S:<spring:message code="LABEL.D.D40.0141"/><!-- 산재 -->
                </td>
<%--                 <td colspan="4" class="td09"><!-- O:지각<BR>P:조퇴<BR>Q:외출--><%=g.getMessage("LABEL.F.F43.0005")%></td> --%>
              </tr>
              <tr>
                <td class="td07"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="7" class="td09">
                	A:<spring:message code="LABEL.D.D40.0145"/><!-- 교육(근무시간내)--> B:<spring:message code="LABEL.D.D40.0146"/><!-- 출장 -->
				</td>
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
  <tr><td colspan="15"  height="16"></td></tr>
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
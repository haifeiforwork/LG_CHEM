<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 월간 엑셀다운로드						*/
/*   Program ID		: D40MonthStateExcel.jsp								*/
/*   Description		: 근태집계표 - 월간	엑셀다운로드							*/
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
    Vector T_EXPORTC = (Vector)request.getAttribute("T_EXPORTC");         //제목

    Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

// 	String fileName = java.net.URLEncoder.encode("월간근태집계표","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("TAB.D.D40.0016"),"UTF-8");
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
    if ( T_EXPORTC != null && T_EXPORTC.size() > 0 ) {
        //대상년월 폼 변경.
//         if( !searchDay.equals("") )
//             searchDay = searchDay.substring(0, 4)+"."+searchDay.substring(4, 6);
%>
<table width="1380" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">* <!-- 월간 근태 집계표 --><%=g.getMessage("TAB.D.D40.0016")%></td>
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
<%--             &nbsp;<!-- 구분 --><%=g.getMessage("LABEL.F.F42.0055")%> : <!-- 월누계 --><%=g.getMessage("LABEL.F.F42.0056")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --%>
<%--             &nbsp;<!-- 대상년월 --><%=g.getMessage("LABEL.F.F42.0057")%> : <%=searchDay%> --%>
<!--           </td> -->
<!--           <td colspan="15"></td> -->
<!--         </tr> -->
<!--       </table> -->
<!--     </td> -->
<!--     <td width="16">&nbsp;</td> -->
<!--   </tr> -->

<%
        String tempDept = "";
        for( int j = 0; j < T_EXPORTC.size(); j++ ){
        	D40DailStateData deptData = (D40DailStateData)T_EXPORTC.get(j);

            //하위부서를 선택했을 경우 부서 비교.
            if( !deptData.ORGEH.equals(tempDept) ){
%>
  <tr><td colspan="15" height="10"></td></tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td class="td09">&nbsp;<!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=deptData.STEXT%></td>
    <td class="td08"><%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %></td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr>
          <td width="60" rowspan="3" class="td03"><!-- 이름--><%=g.getMessage("LABEL.D.D12.0018")%></td>
          <td width="80" rowspan="3" class="td03"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></td>
          <td width="60" rowspan="3" class="td03"><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></td>
          <td colspan="23" class="td03"><!-- 근태집계--><%=g.getMessage("LABEL.F.F42.0005")%></td>
        </tr>
        <tr>
          <td colspan="11" class="td03"><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></td>
          <td colspan="2" class="td03"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></td>
          <td colspan="6" class="td03"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></td>
          <td colspan="2" class="td03"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></td>
          <td colspan="2" class="td03"><!-- 공수--><%=g.getMessage("LABEL.F.F42.0010")%></td>
        </tr>
        <tr>
          <td width="50" class="td03"><!-- 휴가--><%=g.getMessage("LABEL.F.F41.0011")%></td>
          <td width="50" class="td03"><!-- 경조--><%=g.getMessage("LABEL.F.F42.0012")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></td>
          <td width="50" class="td03"><!-- 하계--><%=g.getMessage("LABEL.F.F42.0013")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></td>
          <td width="50" class="td03"><!-- 보건--><%=g.getMessage("LABEL.F.F42.0014")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></td>
          <td width="50" class="td03"><!-- 모성--><%=g.getMessage("LABEL.F.F42.0015")%><br/><!--보호--><%=g.getMessage("LABEL.F.F42.0017")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></td>
          <td width="50" class="td03"><!-- 공가--><%=g.getMessage("LABEL.F.F42.0016")%></td>
          <td width="50" class="td03"><!-- 결근--><%=g.getMessage("LABEL.F.F42.0018")%></td>
          <td width="50" class="td03"><!-- 지각--><%=g.getMessage("LABEL.F.F42.0019")%></td>
          <td width="50" class="td03"><!-- 조퇴--><%=g.getMessage("LABEL.F.F42.0020")%></td>
          <td width="50" class="td03"><!-- 외출--><%=g.getMessage("LABEL.F.F42.0021")%></td>
          <td width="50" class="td03"><!-- 무노동--><%=g.getMessage("LABEL.F.F42.0022")%><br/><!-- 무임금--><%=g.getMessage("LABEL.F.F42.0023")%></td>
          <td width="50" class="td03"><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%></td>
          <td width="50" class="td03"><!-- 출장--><%=g.getMessage("LABEL.F.F42.0025")%></td>
          <td width="50" class="td03"><!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%></td>
          <td width="50" class="td03"><!-- 명절--><%=g.getMessage("LABEL.F.F42.0029")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%><br /> </td>
          <td width="50" class="td03"><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%></td>
          <td width="50" class="td03"><%=g.getMessage("LABEL.F.F42.0031")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></td>
          <td width="50" class="td03"><%=g.getMessage("LABEL.F.F42.0033")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></td>
          <td width="50" class="td03"><%=g.getMessage("LABEL.F.F42.0034")%></td>
          <td width="50" class="td03"><%=g.getMessage("LABEL.F.F42.0035")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%></td>
          <td width="50" class="td03"><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%> </td>
          <td width="50" class="td03"><!-- 금액--><%=g.getMessage("LABEL.F.F42.0037")%></td>
          <td width="50" class="td03"><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></td>
        </tr>

<%
                for( int i = j; i < T_EXPORTC.size(); i++ ){
                	D40DailStateData data = (D40DailStateData)T_EXPORTC.get(i);

                    //합계부분에 명수 보여주는 부분.
                    if (data.ENAME.equals("TOTAL")) {
                        for (int h = 0; h < 8; h++) {
                            if( !data.PERNR.substring(h, h+1).equals("0") ){
                                data.PERNR = "( "+ data.PERNR.substring(h, 8) + " )"+g.getMessage("LABEL.F.F42.0058");
                                break;
                            }
                        }
                    }
%>
        <tr>
          <td class="td04"><%=data.ENAME    %></td>
          <td class="td04"><%=data.PERNR    %></td>
          <td class="td05"><%=data.REMA_HUGA%></td>
          <td class="td05"><%=data.HUGA     %></td>
          <td class="td05"><%=data.KHUGA    %></td>
          <td class="td05"><%=data.HHUGA    %></td>
          <td class="td05"><%=data.BHUG     %></td>
          <td class="td05"><%=data.MHUG     %></td>
          <td class="td05"><%=data.GONGA    %></td>
          <td class="td05"><%=data.KYULKN   %></td>
          <td class="td05"><%=data.JIGAK    %></td>
          <td class="td05"><%=data.JOTAE    %></td>
          <td class="td05"><%=data.WECHUL   %></td>
          <td class="td05"><%=data.MUNO     %></td>
          <td class="td05"><%=data.GOYUK    %></td>
          <td class="td05"><%=data.CHULJANG %></td>
          <td class="td05"><%=data.HTKGUN   %></td>

          <td class="td05"><%=data.MTKGUN   %></td>

          <td class="td05"><%=data.HYUNJANG %></td>
          <td class="td05"><%=data.YUNJANG  %></td>
          <td class="td05"><%=data.YAGAN    %></td>
          <td class="td05"><%=data.DANGJIC  %></td>
          <td class="td05"><%=data.HYANGUN  %></td>
          <td class="td05"><%=data.KOYUK    %></td>
          <td class="td05"><%=data.KONGSU   %></td>
          <td class="td05"><%=data.KONGSU_HOUR%></td>
        </tr>
<%                  //마자막 합계 데이터 일 경우.
                    if (data.ENAME.equals("TOTAL")) {
                        break;
                    }
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
          <td colspan="15"><!-- ＊공수 = 실출근일수 + 유급휴일수 + (초과근로 + 기타) * 가중시수 반영<br/>
              ＊초과근로 + 기타 = (연장 + 야간 + 특근 + 근무시간외 교육, 향군)/ 8h--><%=g.getMessage("LABEL.F.F42.0039")%></td>
        </tr>
        <tr>
          <td colspan="15">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="15" style="padding-bottom:2px">＊<!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%>  </td>
        </tr>
        <tr>
          <td colspan="35">
            <table border="1" cellspacing="1" cellpadding="0" class="table01">
              <tr class="td07">
                <td colspan="2"><!-- 근태유형--><%=g.getMessage("LABEL.F.F42.0041")%> </td>
                <td colspan="7"><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0084")%></td>
                <td width="100" ><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></td>
                <td colspan="7"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></td>
                <td colspan="5" width="200" ><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></td>
              </tr>
              <tr>
                <td width="60" rowspan="3" class="td04"><!-- 단위--><%=g.getMessage("LABEL.F.F42.0042")%></td>
                <td width="60" class="td04"><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></td>
                <td colspan="7" class="td09"><!-- 시간공가, 휴일비근무, 비근무<br>모성보호휴가 --><%=g.getMessage("LABEL.F.F42.0043")%></td>
                <td width="100" rowspan="3" class="td04"><!-- 교육, 출장 --><%=g.getMessage("LABEL.F.F42.0044")%></td>
                <td colspan="7" class="td09"><!-- 휴일특근, 명절특근, 휴일연장,연장근로,, <br>
                   야간근로, 야간근로(명절) --><%=g.getMessage("LABEL.D.D40.0056")%>  </td>
                <td colspan="5" class="td09"><!-- 향군(근무시간외),<br />
                  교육(근무시간외) --> <%=g.getMessage("LABEL.F.F42.0046")%></td>
              </tr>
              <tr>
                <td class="td04"><!-- 일수 --><%=g.getMessage("LABEL.F.F42.0047")%></td>
                <td colspan="7" class="td09"><!-- 반일휴가(전반/후반), 토요휴가, 전일휴가,<br>
                  경조휴가, 하계휴가,보건휴가, 출산전후휴가,<br>전일공가, 유급결근, 무급결근, 전일공가 --><%=g.getMessage("LABEL.F.F42.0048")%></td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="5" class="td09">&nbsp;</td>
              </tr>
              <tr>
                <td class="td04"><!-- 횟수 --><%=g.getMessage("LABEL.F.F42.0049")%></td>
                <td colspan="7" class="td09"><!-- 지각, 조퇴, 외출 --><%=g.getMessage("LABEL.F.F42.0050")%></td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="5" class="td09">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    <td colspan="15" width="16">&nbsp;</td>
  </tr>
  <tr><td colspan="15" height="16"></td></tr>
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
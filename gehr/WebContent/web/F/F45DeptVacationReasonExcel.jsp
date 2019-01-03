<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 부서별 휴가사유 리포트                                      		*/
/*   Program ID   : F45DeptVacationReasonExcel.jsp                              */
/*   Description  : 부서별 휴가사유 리포트 Excel 저장을 위한 jsp 파일           		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2010-03-15 lsa                                           	*/
/*   Update       : 2018-07-31 성환희 [Worktime52] 경로,미확정사유 추가 			*/
/*                                                                              */
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
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptVacation_vt = (Vector)request.getAttribute("DeptVacation_vt");
    String year         = WebUtil.nvl((String)request.getParameter("year"),DataUtil.getCurrentYear());    //대상년
    String month        = WebUtil.nvl((String)request.getParameter("month"),DataUtil.getCurrentMonth());  //대상월
    String i_gubun      = WebUtil.nvl(request.getParameter("i_gubun"),"1");                               //메뉴구분


    String headNm = "";
    String gubunNm = "";
    if ( i_gubun.equals("1") ) {   //휴가사유
         //headNm ="휴가 레포트" ;
         //gubunNm = "휴가";
         headNm =g.getMessage("LABEL.D.D15.0141")+" "+g.getMessage("LABEL.D.D15.0143");
         gubunNm = g.getMessage("LABEL.D.D15.0141");
    }else if ( i_gubun.equals("2") ) { //휴가사유
         //headNm ="휴가 레포트";
         //gubunNm = "미결재휴가";
         headNm =g.getMessage("LABEL.D.D15.0141")+" "+g.getMessage("LABEL.D.D15.0143");
         gubunNm = g.getMessage("LABEL.D.D15.0144");
    }else if ( i_gubun.equals("3") ) { //근태사유
        //headNm ="초과근무 레포트";
        //gubunNm = "초과근무";
         headNm =g.getMessage("LABEL.D.D15.0142")+" "+g.getMessage("LABEL.D.D15.0143");
         gubunNm = g.getMessage("LABEL.D.D15.0142");
    }else if ( i_gubun.equals("4") ) { //근태사유
        // headNm ="초과근무 레포트";
        // gubunNm = "미결재초과근무";
         headNm =   g.getMessage("LABEL.D.D15.0142")+" "+g.getMessage("LABEL.D.D15.0143");
         gubunNm =  g.getMessage("LABEL.D.D15.0144");
    }
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=DeptVacationReason.xls");
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
    if ( DeptVacation_vt != null && DeptVacation_vt.size() > 0 ) {
%>
<table width="1200" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="5" class="title02"><%=headNm%></td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
	      <td colspan="13" class="td09">&nbsp;년월 : <%= year %>년 <%=month%>월 &nbsp;&nbsp;구분 : <%=gubunNm%>&nbsp;&nbsp;부서명 : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></td>
	    </tr>
        <tr>
	      <td colspan="13"  align="right">(총 <%=DeptVacation_vt.size()%> 건)</td>
	    </tr>
	    <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td >
<%  if ( i_gubun.equals("1")||i_gubun.equals("2") ) {//휴가사유 %>
        <table  border="0" cellspacing="1" cellpadding="4" class="table02" align="left">
          <tr>
            <th nowrap><!--사번--><%=g.getMessage("LABEL.D.D15.0149")%></th>
            <th nowrap><!--이름--><%=g.getMessage("LABEL.D.D15.0150")%></th>
            <th nowrap><!--휴무유형--><%=g.getMessage("LABEL.D.D15.0151")%></th>
            <th nowrap><!--시작일--><%=g.getMessage("LABEL.D.D15.0152")%></th>
            <th nowrap><!--종료일--><%=g.getMessage("LABEL.D.D15.0153")%></th>
            <th nowrap><!--신청일--><%=g.getMessage("LABEL.D.D15.0154")%></th>
            <th nowrap><!--승인일--><%=g.getMessage("LABEL.D.D15.0155")%></th>
            <th nowrap><!--결재자사번--><%=g.getMessage("LABEL.D.D15.0156")%></th>
            <th nowrap><!--신청사유--><%=g.getMessage("LABEL.D.D15.0157")%></th>
            <th nowrap><!--오브젝트이름--><%=g.getMessage("LABEL.D.D15.0158")%></th>
            <th nowrap><!--EE그룹이름--><%=g.getMessage("LABEL.D.D15.0159")%></th>
            <th nowrap><!--근태사유명--><%=g.getMessage("LABEL.D.D15.0160")%></th>
            <th class="lastCol" nowrap><!-- 대근자--><%=g.getMessage("LABEL.D.D15.0161")%></th>
          </tr>
<%
            for( int i = 0; i < DeptVacation_vt.size(); i++ ){
                F45DeptVacationReasonData data = (F45DeptVacationReasonData)DeptVacation_vt.get(i);
%>
          <tr align="center">
            <td class="td09" nowrap>&nbsp;<%= data.PERNR %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= data.ATEXT %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.ENDDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.ENDDA) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.REQU_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.REQU_DATE) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.APPR_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.APPR_DATE) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.APPU_NUMB).equals("00000000") ? "": data.APPU_NUMB%>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= data.REASON %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= data.ORGTX %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= data.PTEXT %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= data.OVTM_CD_NAME %>&nbsp;</td>
            <td class="td04" nowrap>&nbsp;<%= data.OVTM_NAME %>&nbsp;</td>
          </tr>
<%
	        } //end for...
%>
<%  }else if ( i_gubun.equals("3")||i_gubun.equals("4") ) { //근태사유%>
        <table  border="0" cellspacing="1" cellpadding="4" class="table02" align="left">
          <tr>
            <th nowrap><!--사번--><%=g.getMessage("LABEL.D.D15.0149")%></th>
            <th nowrap><!--이름--><%=g.getMessage("LABEL.D.D15.0150")%></th>
            <th nowrap><!--시작일--><%=g.getMessage("LABEL.D.D15.0152")%></th>
            <th nowrap><!--시작시간--><%=g.getMessage("LABEL.D.D15.0162")%></th>
            <th nowrap><!--종료시간--><%=g.getMessage("LABEL.D.D15.0163")%></th>
            <th nowrap><!--휴식시간시간--><%=g.getMessage("LABEL.D.D15.0164")%></th>
            <th nowrap><!--휴식종료시간--><%=g.getMessage("LABEL.D.D15.0165")%></th>
            <th nowrap><!--작업시간--><%=g.getMessage("LABEL.D.D15.0166")%></th>
			<% if(i_gubun.equals("3")) { //초과근무%>
				<th nowrap><!--경로--><%=g.getMessage("LABEL.D.D15.0171")%></th>
			<% } else { //미결재초과근무%>
	            <th nowrap><!--신청일--><%=g.getMessage("LABEL.D.D15.0154")%></th>
	            <th nowrap><!--승인일--><%=g.getMessage("LABEL.D.D15.0155")%></th>
	            <th nowrap><!--결재자사번--><%=g.getMessage("LABEL.D.D15.0156")%></th>
	            <th nowrap><!--신청사유--><%=g.getMessage("LABEL.D.D15.0157")%></th>
	            <th nowrap><!--오브젝트이름--><%=g.getMessage("LABEL.D.D15.0158")%></th>
	            <th nowrap><!--EE그룹이름--><%=g.getMessage("LABEL.D.D15.0159")%></th>
	            <th nowrap><!-- 근태사유명--><%=g.getMessage("LABEL.D.D15.0160")%></th>
	            <th nowrap><!--휴가자--><%=g.getMessage("LABEL.D.D15.0167")%></th>
	            <th nowrap><!--미 확정사유--><%=g.getMessage("LABEL.D.D15.0172")%></th>
            <% } %>
          </tr>
<%
            for( int i = 0; i < DeptVacation_vt.size(); i++ ){
                F45DeptVacationReasonData data = (F45DeptVacationReasonData)DeptVacation_vt.get(i);
%>
          <tr align="center">
            <td class="td09" nowrap>&nbsp;<%= data.PERNR %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= data.ENAME %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.BEGUZ).equals("") ? "" : WebUtil.printTime( data.BEGUZ ) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.ENDUZ).equals("") ? "" : WebUtil.printTime( data.ENDUZ ) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.PBEG1).equals("") ? "" : WebUtil.printTime( data.PBEG1 ) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.PEND1).equals("") ? "" : WebUtil.printTime( data.PEND1 ) %>&nbsp;</td>
            <td class="td09" nowrap>&nbsp;<%= (data.STDAZ).equals("") ? "" : WebUtil.printTime( data.STDAZ ) %>&nbsp;</td>
            <% if(i_gubun.equals("3")) { //초과근무%>
            	<td class="td04" nowrap><%= data.INPUT_PASS %></td>
            <% } else { //미결재초과근무%>
	            <td class="td09" nowrap>&nbsp;<%= (data.REQU_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.REQU_DATE) %>&nbsp;</td>
	            <td class="td09" nowrap>&nbsp;<%= (data.APPR_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.APPR_DATE) %>&nbsp;</td>
	            <td class="td09" nowrap>&nbsp;<%= (data.APPU_NUMB).equals("00000000") ? "": data.APPU_NUMB%>&nbsp;</td>
	            <td class="td09" nowrap>&nbsp;<%= data.REASON %>&nbsp;</td>
	            <td class="td04" nowrap>&nbsp;<%= data.ORGTX %>&nbsp;</td>
	            <td class="td04" nowrap>&nbsp;<%= data.PTEXT %>&nbsp;</td>
	            <td class="td04" nowrap>&nbsp;<%= data.OVTM_CD_NAME %>&nbsp;</td>
	            <td class="td04" nowrap>&nbsp;<%= data.OVTM_NAME %>&nbsp;</td>
            	<td class="td04" nowrap><%= data.UNCONFIRM_RESN %></td>
            <% } %>
          </tr>
<%
	        } //end for...
%>
<%  } %>
        </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.D.D15.0016")%></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>


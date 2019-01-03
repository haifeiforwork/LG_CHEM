<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 부서별 휴가사유 리포트                                      		*/
/*   Program ID   : F45DeptVacationReason.jsp                                   */
/*   Description  : 부서별 휴가사유 리포트 조회를 위한 jsp 파일                 		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2010-03-15 lsa                                              */
/*   Update       : 2018-07-31 성환희 [Worktime52] 경로,미확정사유 추가 			*/
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%

	// 웹로그 메뉴 코드명
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

    WebUserData user    = (WebUserData)session.getAttribute("user");              //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));    //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));    //부서명
    Vector DeptVacation_vt = (Vector)request.getAttribute("DeptVacation_vt");
    String year         = WebUtil.nvl((String)request.getParameter("year"),DataUtil.getCurrentYear());  //대상년
    String month         = WebUtil.nvl((String)request.getParameter("month"),DataUtil.getCurrentMonth());  //대상월
    String i_gubun         = WebUtil.nvl(request.getParameter("i_gubun"),"1");                          //메뉴구분
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),WebUtil.nvl((String)request.getAttribute("checkYn")));     //하위부서여부.
	String subView       = WebUtil.nvl(request.getParameter("subView"));


    String headNm = "";
    if ( i_gubun.equals("1")||i_gubun.equals("2") ) {   //휴가사유
        // headNm ="휴가 레포트" ;
    	headNm = "LABEL.D.D15.01163";
    }else if ( i_gubun.equals("3")||i_gubun.equals("4") ) { //근태사유
         //headNm ="초과근무 레포트";
         headNm = "LABEL.D.D15.01164";
    }
%>
<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">
<!--

function search(){
    frm = document.form1;

    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F45DeptVacationReasonSV";
    frm.target = "_self";
    frm.submit();
}

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현
    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
        //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
        alert("<%=g.getMessage("MSG.D.D15.0015")%>   ");
        return;
    }

   frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
   frm.month1.value = frm.month.options[frm.month.selectedIndex].text;

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F45DeptVacationReasonSV";
    frm.target = "_self";
    frm.submit();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F45DeptVacationReasonSV";
    frm.target = "hidden";
    frm.submit();
}

function popupView(winName, width, height, pernr) {
	var formN = document.form1;
	formN.viewEmpno.value = pernr;

	var screenwidth = (screen.width-width)/2;
    var screenheight = (screen.height-height)/2;
    var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr;

	 var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

}

//-->
</SCRIPT>

    <jsp:include page="/include/body-header.jsp">
    <jsp:param name="click" value="Y"/>
    </jsp:include>

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type='hidden' name='chck_yeno' value='<%=chck_yeno%>' >






<h2 class="subtitle"><!--  부서명--><%=g.getMessage("LABEL.D.D15.0146")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
	<div class="listArea">
  	<div class="listTop">
  	  	<%
    //부서명, 조회된 건수.
    if ( DeptVacation_vt != null && DeptVacation_vt.size() > 0 ) {
      %>
  		<span class="listCnt">
		<<!--  총--><%=g.getMessage("LABEL.D.D15.0147")%> <%=DeptVacation_vt.size()%> <!--  건--><%=g.getMessage("LABEL.D.D15.0148")%> >
     	</span>
    <%} %>
	    <div class="buttonArea">
<select name="year" onChange="javascript:search();">
<%
    for( int i = 2001 ; i <= Integer.parseInt( DataUtil.getCurrentYear() ) ; i++ ) {
        int year1 = Integer.parseInt(year);
%>
             <option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>
             </select>
             <select name="month" onChange="javascript:search();">
<%
    for( int i = 1 ; i <= 12 ; i++ ) {
        String temp = Integer.toString(i);
        int mon = Integer.parseInt(month);
%>
             <option value="<%= i %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
             </select>
             <select name="i_gubun" class="input03" onChange="javascript:search();">
<%  if ( i_gubun.equals("1")||i_gubun.equals("2") ) { %>

             <option value="1" <%= i_gubun.equals("1") ? " selected ":"" %>><!--  휴가--><%=g.getMessage("LABEL.D.D15.0141")%></option>
             <option value="2" <%= i_gubun.equals("2") ? " selected ":"" %>><!--  미결재휴가--><%=g.getMessage("LABEL.D.D15.0144")%></option>
<%  }else if ( i_gubun.equals("3")||i_gubun.equals("4") ) { %>

             <option value="3" <%= i_gubun.equals("3") ? " selected ":"" %>><!--  초과근무--><%=g.getMessage("LABEL.D.D15.0142")%></option>
             <option value="4" <%= i_gubun.equals("4") ? " selected ":"" %>><!--  미결재초과근무--><%=g.getMessage("LABEL.D.D15.0145")%></option>
<%  } %>

             </select>
             <input type="hidden" name="year1" value="">
             <input type="hidden" name="month1" value="">
             <img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  />
			<ul class="btn_mdl displayInline" style="position:relative; top:-2px;">
				<li><a class="unloading" onClick="excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
			</ul>

	    </div>
  	</div>
  	<%
    //부서명, 조회된 건수.
    if ( DeptVacation_vt != null && DeptVacation_vt.size() > 0 ) {
%>
    <div class="table">

<%  if ( i_gubun.equals("1")||i_gubun.equals("2") ) {//휴가사유 %>
        <table class="listTable">
        <thead>
          <tr>
            <th><!--사번--><%=g.getMessage("LABEL.D.D15.0149")%></th>
            <th><!--이름--><%=g.getMessage("LABEL.D.D15.0150")%></th>
            <th><!--휴무유형--><%=g.getMessage("LABEL.D.D15.0151")%></th>
            <th><!--시작일--><%=g.getMessage("LABEL.D.D15.0152")%></th>
            <th><!--종료일--><%=g.getMessage("LABEL.D.D15.0153")%></th>
            <th><!--신청일--><%=g.getMessage("LABEL.D.D15.0154")%></th>
            <th><!--승인일--><%=g.getMessage("LABEL.D.D15.0155")%></th>
            <th><!--결재자사번--><%=g.getMessage("LABEL.D.D15.0156")%></th>
            <th><!--신청사유--><%=g.getMessage("LABEL.D.D15.0157")%></th>
            <th><!--오브젝트이름--><%=g.getMessage("LABEL.D.D15.0158")%></th>
            <th><!--EE그룹이름--><%=g.getMessage("LABEL.D.D15.0159")%></th>
            <th><!--근태사유명--><%=g.getMessage("LABEL.D.D15.0160")%></th>
            <th class="lastCol"><!-- 대근자--><%=g.getMessage("LABEL.D.D15.0161")%></th>
          </tr>
          </thead>
<%
            for( int i = 0; i < DeptVacation_vt.size(); i++ ){
                F45DeptVacationReasonData data = (F45DeptVacationReasonData)DeptVacation_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
          <tr class="<%=tr_class%>">
            <td><a class="unloading"  href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
            <td nowrap><%= data.ENAME %></td>
            <td><%= data.ATEXT %></td>
            <td><%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %></td>
            <td><%= (data.ENDDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.ENDDA) %></td>
            <td><%= (data.REQU_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.REQU_DATE) %></td>
            <td><%= (data.APPR_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.APPR_DATE) %></td>
            <td><%= (data.APPU_NUMB).equals("00000000") ? "": data.APPU_NUMB%></td>
            <td><%= data.REASON %></td>
            <td><%= data.ORGTX %></td>
            <td><%= data.PTEXT %></td>
            <td><%= data.OVTM_CD_NAME %></td>
            <td class="lastCol"><%= data.OVTM_NAME %></td>
          </tr>
<%
	        } //end for...
%>
</table>
<%  }else if ( i_gubun.equals("3")||i_gubun.equals("4") ) { //근태사유%>
        <table class="listTable">
        <thead>
          <tr>
            <th><!--사번--><%=g.getMessage("LABEL.D.D15.0149")%></th>
            <th><!--이름--><%=g.getMessage("LABEL.D.D15.0150")%></th>
            <th><!--시작일--><%=g.getMessage("LABEL.D.D15.0152")%></th>
            <th><!--시작시간--><%=g.getMessage("LABEL.D.D15.0162")%></th>
            <th><!--종료시간--><%=g.getMessage("LABEL.D.D15.0163")%></th>
            <th><!--휴식시간시간--><%=g.getMessage("LABEL.D.D15.0164")%></th>
            <th><!--휴식종료시간--><%=g.getMessage("LABEL.D.D15.0165")%></th>
            <th><!--작업시간--><%=g.getMessage("LABEL.D.D15.0166")%></th>
          <% if(i_gubun.equals("3")) { %>
            <th class="lastCol"><!--경로--><%=g.getMessage("LABEL.D.D15.0171")%></th>
          <% } else { %>
          	<th><!--신청일--><%=g.getMessage("LABEL.D.D15.0154")%></th>
            <th><!--승인일--><%=g.getMessage("LABEL.D.D15.0155")%></th>
            <th><!--결재자사번--><%=g.getMessage("LABEL.D.D15.0156")%></th>
            <th><!--신청사유--><%=g.getMessage("LABEL.D.D15.0157")%></th>
            <th><!--오브젝트이름--><%=g.getMessage("LABEL.D.D15.0158")%></th>
            <th><!--EE그룹이름--><%=g.getMessage("LABEL.D.D15.0159")%></th>
            <th><!-- 근태사유명--><%=g.getMessage("LABEL.D.D15.0160")%></th>
            <th><!--휴가자--><%=g.getMessage("LABEL.D.D15.0167")%></th>
            <th class="lastCol"><!--미 확정사유--><%=g.getMessage("LABEL.D.D15.0172")%></th>
          <% } %>
          </tr>
          </thead>
<%
            for( int i = 0; i < DeptVacation_vt.size(); i++ ){
                F45DeptVacationReasonData data = (F45DeptVacationReasonData)DeptVacation_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR,request); //암호화를 위해
                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
          <tr class="<%=tr_class%>">
            <td><a class="unloading" href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
            <td><%= data.ENAME %></td>
            <td><%= (data.BEGDA).equals("0000-00-00") ? "" : WebUtil.printDate(data.BEGDA) %></td>
            <td><%= (data.BEGUZ).equals("") ? "" : WebUtil.printTime( data.BEGUZ ) %></td>
            <td><%= (data.ENDUZ).equals("") ? "" : WebUtil.printTime( data.ENDUZ ) %></td>
            <td><%= (data.PBEG1).equals("") ? "" : WebUtil.printTime( data.PBEG1 ) %></td>
            <td><%= (data.PEND1).equals("") ? "" : WebUtil.printTime( data.PEND1 ) %></td>
            <td><%= (data.STDAZ).equals("") ? "" : WebUtil.printTime( data.STDAZ ) %></td>
          <% if(i_gubun.equals("3")) { //초과근무%>
          	<td class="lastCol"><%= data.INPUT_PASS %></td>
          <% } else { //미결재초과근무%>
          	<td><%= (data.REQU_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.REQU_DATE) %></td>
            <td><%= (data.APPR_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.APPR_DATE) %></td>
            <td><%= (data.APPU_NUMB).equals("00000000") ? "": data.APPU_NUMB%></td>
            <td><%= data.REASON %></td>
            <td><%= data.ORGTX %></td>
            <td><%= data.PTEXT %></td>
            <td><%= data.OVTM_CD_NAME %></td>
            <td><%= data.OVTM_NAME %></td>
            <td class="lastCol"><%= data.UNCONFIRM_RESN %></td>
          <% } %>
          </tr>
<%
	        } //end for...
%>
</table>
<%  } %>

</div>
</div>

<%
    }else{
%>

<div class="align_center">
    <p ><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.D.D15.0016")%></p>
</div>
<%
    } //end if...
%>

</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
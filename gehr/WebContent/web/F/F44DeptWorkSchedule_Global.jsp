<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근무 계획표                                                 */
/*   Program ID   : F44DeptWorkSchedule.jsp                                     */
/*   Description  : 부서별 근무 계획표 조회를 위한 jsp 파일                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-18 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  WebUserData user = (WebUserData) session.getAttribute("user");
  String deptId = WebUtil.nvl(request.getParameter("hdn_deptId")); //부서코드

  String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm"))); //부서명
  String searchDay = WebUtil.nvl((String) request.getAttribute("E_YYYYMON")); //대상년월
  /*out.println(searchDay + 1);
  if(searchDay == null || searchDay.equals("")){
    Calendar calendar = Calendar.getInstance();
    searchDay = calendar.get(Calendar.YEAR) + "" + (calendar.get(Calendar.MONTH)+1);
  }
  out.println(searchDay);*/
  String year = "";
  String month = "";
  Vector F44DeptScheduleTitle_vt = (Vector) request.getAttribute("F44DeptScheduleTitle_vt"); //제목
  Vector F44DeptScheduleData_vt = (Vector) request.getAttribute("F44DeptScheduleData_vt"); //내용
  String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
  String subView       = WebUtil.nvl(request.getParameter("subView"));
    String chkAll = WebUtil.nvl(request.getParameter("chek_all"));
    if(chkAll==null){
      chkAll = "";
    }

    String paging    = WebUtil.nvl((String)request.getParameter("page" )) ;
    // PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if(chkAll.equals("")){
      if ( F44DeptScheduleData_vt != null && F44DeptScheduleData_vt.size() != 0 ) {
          try {
              pu = new PageUtil( F44DeptScheduleData_vt.size(), paging, 14, 10 ) ;
              Logger.debug.println( this, "page : " + paging ) ;
          } catch( Exception ex ) {
              Logger.debug.println( DataUtil.getStackTrace( ex ) ) ;
          }
      }
    }
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    frm = document.form1;

    // 하위조직포함이고 LG Chem(50000000) 은 데이타가 많아서 막음. - 2005.03.30 윤정현

    if ( deptId == "50000000" && frm.chk_organAll.checked == true ) {
        //alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
        alert("<%=g.getMessage("MSG.F.F41.0003")%>   ");
        return;
    }
     if((frm.year!==null)&&(frm.month!=null)){
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }
    frm.searchDay_bf.value = "<%=searchDay%>";
  document.form1.page.value = '';
    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%=WebUtil.ServletURL%>hris.F.F44DeptWorkScheduleSV";
    frm.target = "_self";
    frm.submit();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;
     if((frm.year!==null)&&(frm.month!=null)){
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "ED";
    frm.action = "<%=WebUtil.ServletURL%>hris.F.F44DeptWorkScheduleSV";
    frm.target = "hidden";
    frm.submit();
    frm.hdn_excel.value = "";
}

function zocrsn_get() {
    frm = document.form1;
     if((frm.year!==null)&&(frm.month!=null)){
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }
    frm.searchDay_bf.value = "<%=searchDay%>";
  document.form1.page.value = '';
    frm.hdn_excel.value = "";
    frm.action = "<%=WebUtil.ServletURL%>hris.F.F44DeptWorkScheduleSV";
    frm.target = "_self";
    frm.method = "post";
    frm.submit();
}


//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
	 frm = document.form1;
     if((frm.year!==null)&&(frm.month!=null)){
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }
    frm.searchDay_bf.value = "<%=searchDay%>";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.F.F44DeptWorkScheduleSV";
    document.form1.method = 'post';
    document.form1.target = '_self';
    document.form1.submit();
}

function fnc_all(){
    frm = document.form1;
    if ( frm.chk_All.checked == true )
        frm.chek_all.value = 'Y';
    else
        frm.chek_all.value = '';
     if((frm.year!==null)&&(frm.month!=null)){
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    }
    frm.searchDay_bf.value = "<%=searchDay%>";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.F.F44DeptWorkScheduleSV";
    document.form1.method = 'post';
    document.form1.target = '_self';
    document.form1.submit();
}

//-->
</SCRIPT>



    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y'"/>
    </jsp:include>

  <form name="form1" method="post" onsubmit="return false">
  <input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
  <input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
  <input type="hidden" name="hdn_excel"   value="">
  <input type="hidden" name="subView" value="<%=subView%>">
  <INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >


<%
      if (F44DeptScheduleData_vt != null
      && F44DeptScheduleData_vt.size() > 0) {
    //타이틀 사이즈.
    int titlSize = F44DeptScheduleTitle_vt.size();

    //대상년월 폼 변경.
%>
<h2 class="subtitle"><!--Org.Unit --><%=g.getMessage("LABEL.F.F51.0030")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
  <div class="listArea">
  	<div class="listTop">
  	  		<span class="listCnt">
  			<%= (chkAll.equals(""))?(pu == null ? "" : pu.pageInfo()):"&lt; "+g.getMessage("LABEL.F.F51.0017")+" "+F44DeptScheduleData_vt.size()+"&gt;" %>
  			<span style="display:<%=F44DeptScheduleData_vt.size()<=14?"none":"inline" %>"><input type="checkbox" name="chk_All" value="" onClick="javaScript:fnc_all();" <%=(chkAll.equals("")?"":"checked") %> >Show All<input type="hidden" name="chek_all" value="<%=chkAll %>"></span>
  		</span>
  		<div class="buttonArea">
  		   			<select name="year">
<%
    int year1;
    for (int i = 2007; i <= Integer.parseInt(DataUtil.getCurrentYear()); i++) {
      year1 = Integer.parseInt(searchDay.substring(0, 4));
%>
     			 <option value="<%=i%>" <%=year1 == i ? " selected " : ""%>><%=i%></option>
<%
}
%>
   			 </select>
    			<select name="month">
<%
      for (int i = 1; i <= 12; i++) {
      String temp = Integer.toString(i);
      int mon = Integer.parseInt(searchDay.substring(4, 6));
%>
     			 <option value="<%=i%>"<%=mon == i ? " selected " : ""%>><%=temp.length() == 1 ? '0' + temp : temp%></option>
<%
}
%>
    			</select>
	              <input type="hidden" name="year1" value="">
	              <input type="hidden" name="month1" value="">
	              <input type="hidden" name="searchDay_bf" value="">
	        	<a href="javascript:zocrsn_get();"><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0" align="absmiddle"></a>&nbsp;&nbsp;
				<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  />
	        	<ul class="btn_mdl displayInline">
	         		<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	         	</ul>
			</div>
		</div>
    <div class="table">
    <div class="wideTable" >
      <table class="listTable">
      <thead>
        <tr>
          <th rowspan="2"><!--Pers.No --><%=g.getMessage("LABEL.F.F51.0019")%></th>
          <th rowspan="2"><!--Name --><%=g.getMessage("LABEL.F.F51.0025")%></th>
<%
    //타이틀(일자).
    for (int h = 0; h < titlSize; h++) {
      F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData) F44DeptScheduleTitle_vt
      .get(h);
      String tdColor = "";
      if (titleData.DAYTXT.equals("Sunday")) {
    tdColor = "class=td11";
      }
%>
          <th <%=tdColor%>><%=titleData.DAY.substring(8, 10)%></th>
<%
}
%>
        </tr>
        <tr>
<%
    //타이틀(요일).
    for (int k = 0; k < titlSize; k++) {
      F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData) F44DeptScheduleTitle_vt
      .get(k);
      String tdColor = "";
      if (titleData.DAYTXT.equals("Sunday")) {
    tdColor = "class=td11";
      }
%>
          <th <%=tdColor%>><%=titleData.DAYTXT.substring(0, 3)%></th>
<%
}//end if
%>
    </tr>
    </thead>
<%
        int ifrom = chkAll.equals("")?pu.formRow():0;
        int ito = chkAll.equals("")?pu.toRow():F44DeptScheduleData_vt.size();
        for( int i = ifrom ; i < ito; i++ ){
      		F44DeptWorkScheduleNoteData data = (F44DeptWorkScheduleNoteData) F44DeptScheduleData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
        <tr class="<%=tr_class%>">
          <td><%=data.PERNR%></td>
          <td class="align_left" nowrap><%=data.ENAME%></td>
          <td><%=data.TPROG01%></td>
          <td><%=data.TPROG02%></td>
          <td><%=data.TPROG03%></td>
          <td><%=data.TPROG04%></td>
          <td><%=data.TPROG05%></td>
          <td><%=data.TPROG06%></td>
          <td><%=data.TPROG07%></td>
          <td><%=data.TPROG08%></td>
          <td><%=data.TPROG09%></td>
          <td><%=data.TPROG10%></td>
          <td><%=data.TPROG11%></td>
          <td><%=data.TPROG12%></td>
          <td><%=data.TPROG13%></td>
          <td><%=data.TPROG14%></td>
          <td><%=data.TPROG15%></td>
          <td><%=data.TPROG16%></td>
          <td><%=data.TPROG17%></td>
          <td><%=data.TPROG18%></td>
          <td><%=data.TPROG19%></td>
          <td><%=data.TPROG20%></td>
          <td><%=data.TPROG21%></td>
          <td><%=data.TPROG22%></td>
          <td><%=data.TPROG23%></td>
          <td><%=data.TPROG24%></td>
          <td><%=data.TPROG25%></td>
          <td><%=data.TPROG26%></td>
          <td><%=data.TPROG27%></td>
          <td><%=data.TPROG28%></td>
          <%
              if (titlSize >= 29)
              out.println("<td>" + data.TPROG29 + "</td>");
          %>
          <%
              if (titlSize >= 30)
              out.println("<td>" + data.TPROG30 + "</td>");
          %>
          <%
              if (titlSize >= 31)
              out.println("<td>" + data.TPROG31 + "</td>");
          %>
        </tr>
<%
} //end for...
%>
      </table>
      </div>
	    <!-- PageUtil 관련 - 반드시 써준다. -->

	  <div class="align_center">
	    <%= chkAll.equals("")?(pu == null ? "" : pu.pageControl()):"" %>
	  </div>
    </div>
  </div>



<%
    } else {
    int titlSize = F44DeptScheduleTitle_vt.size();
%>


  <h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>

  <div class="listArea">
    	<div class="listTop">
  	  		<span class="listCnt">
  			<%= (chkAll.equals(""))?(pu == null ? "" : pu.pageInfo()):"&lt;"+g.getMessage("LABEL.F.F51.0017")+" "+F44DeptScheduleData_vt.size()+"&gt;" %>
  			<span style="display:<%=F44DeptScheduleData_vt.size()<=14?"none":"inline" %>"><input type="checkbox" name="chk_All" value="" onClick="javaScript:fnc_all();" <%=(chkAll.equals("")?"":"checked") %> >Show All<input type="hidden" name="chek_all" value="<%=chkAll %>"></span>
  		</span>
  		<div class="buttonArea">
  		   			<select name="year">
<%
    int year1;
    for (int i = 2007; i <= Integer.parseInt(DataUtil.getCurrentYear()); i++) {
      year1 = Integer.parseInt(searchDay.substring(0, 4));
%>
     			 <option value="<%=i%>" <%=year1 == i ? " selected " : ""%>><%=i%></option>
<%
}
%>
   			 </select>
    			<select name="month">
<%
      for (int i = 1; i <= 12; i++) {
      String temp = Integer.toString(i);
      int mon = Integer.parseInt(searchDay.substring(4, 6));
%>
     			 <option value="<%=i%>"<%=mon == i ? " selected " : ""%>><%=temp.length() == 1 ? '0' + temp : temp%></option>
<%
}
%>
    			</select>
	              <input type="hidden" name="year1" value="">
	              <input type="hidden" name="month1" value="">
	              <input type="hidden" name="searchDay_bf" value="">
	        	<a href="javascript:zocrsn_get();"><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0" align="absmiddle"></a>&nbsp;&nbsp;
				<img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  />
	        	<ul class="btn_mdl displayInline">
	         		<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	         	</ul>
			</div>
		</div>
    <div class="table">
      <table class="listTable">

      <thead>
        <tr>
          <th rowspan="2"><!--Pers.No --><%=g.getMessage("LABEL.F.F51.0019")%></th>
          <th rowspan="2" width="100px"><!--Name --><%=g.getMessage("LABEL.F.F51.0025")%></th>
<%
    //타이틀(일자).
    for (int h = 0; h < titlSize; h++) {
      F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData) F44DeptScheduleTitle_vt.get(h);
      String tdColor = "";
      if (titleData.DAYTXT.equals("Sunday")) {
    tdColor = "class=td11";
      }
%>
          <th <%=tdColor%>><%=titleData.DAY.substring(8, 10)%></th>
<%
}
%>
        </tr>
        <tr>
<%
    //타이틀(요일).
    for (int k = 0; k < titlSize; k++) {
      F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData) F44DeptScheduleTitle_vt
      .get(k);
      String tdColor = "";
      if (titleData.DAYTXT.equals("Sunday")) {
    tdColor = "class=td11";
      }
%>
          <th <%=tdColor%>><%=titleData.DAYTXT.substring(0, 3)%></th>
<%
}//end if
%>
        </tr>
       </thead>
        <tr class="oddRow">
          <td colspan="33" class="lastCol"><!-- No data --><%=g.getMessage("LABEL.F.F51.0029")%></td>
        </tr>
      </table>
    </div>
  </div>
<%
} //end if...
%>
  <input type="hidden" name="page" value="<%= paging %>">
</div>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

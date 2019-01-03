<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 부서별 휴가 사용 현황                                       */
/*   Program ID   : F41DeptVacation.jsp                                         */
/*   Description  : 부서별 휴가 사용 현황 조회를 위한 jsp 파일                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.Global.*" %>

<%
  request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));  //부서명
    Vector DeptVacation_vt = (Vector)request.getAttribute("DeptVacation_vt");
    String chkAll = WebUtil.nvl(request.getParameter("chek_all"));
    String subView       = WebUtil.nvl(request.getParameter("subView"));
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

    if(chkAll==null){
      chkAll = "";
    }

    String paging    =WebUtil.nvl( (String)request.getParameter("page" )) ;
    // PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    if(chkAll.equals("")){
    if ( DeptVacation_vt != null && DeptVacation_vt.size() != 0 ) {
        try {
            pu = new PageUtil( DeptVacation_vt.size(), paging, 14, 10 ) ;
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
       // alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
       alert("<%=g.getMessage("MSG.F.F41.0003")%>  ");
        return;
    }

  document.form1.page.value = '';
    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F41DeptVacationSV";
    frm.target = "_self";
    frm.submit();
}


//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F41DeptVacationSV";
    frm.target = "hidden";
    frm.submit();
    frm.hdn_excel.value = "";
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    get_Page();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function get_Page(){
    document.form1.action = "<%= WebUtil.ServletURL %>hris.F.F41DeptVacationSV";
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
    document.form1.action = "<%= WebUtil.ServletURL %>hris.F.F41DeptVacationSV";
    document.form1.method = 'post';
    document.form1.target = '_self';
    document.form1.submit();
}
//-->
</SCRIPT>


    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="help" value="F41DeptVacation.html'"/>
     </jsp:include>



<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >


<%
    //부서명, 조회된 건수.
    if ( DeptVacation_vt != null && DeptVacation_vt.size() > 0 ) {
    	double sumOCCUR = 0.0;
    	double sumABWTG = 0.0;
    	double sumZKVRB = 0.0;
    	String allAVG = "0.00";
%>
	<h2 class="subtitle"><!--Org.Unit--><%=g.getMessage("LABEL.F.F43.0010")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
  <div class="listArea">
  	<div class="listTop">
  		<span class="listCnt">
  			<%= (chkAll.equals(""))?(pu == null ? "" : pu.pageInfo()):"&lt "+g.getMessage("LABEL.F.F51.0017")+" "+DeptVacation_vt.size()+"&gt;" %>
  			<span style="display:<%=DeptVacation_vt.size()<=14?"none":"inline; margin-left:8px" %>"><input type="checkbox" name="chk_All" value="" onClick="javaScript:fnc_all();" <%=(chkAll.equals("")?"":"checked") %> >Show All<input type="hidden" name="chek_all" value="<%=chkAll %>"></span>
  		</span>
	    <div class="buttonArea">
	    	<ul class="btn_mdl">
	    		<li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	    	</ul>
	    </div>
  	</div>
    <div class="table">
      <table class="listTable">
      <thead>
        <tr>
          <th><!--Pers.No --><%=g.getMessage("LABEL.F.F41.0020")%></th>
          <th><!-- Name --><%=g.getMessage("LABEL.F.F41.0021")%></th>
          <th><!-- Org.Unit --><%=g.getMessage("LABEL.F.F41.0022")%></th>
          <th><!-- Res of Office --><%=g.getMessage("LABEL.F.F41.0023")%></th>
          <th><!-- Title of Level--><%=g.getMessage("LABEL.F.F41.0024")%></th>
          <th><!-- Level / Annual --><%=g.getMessage("LABEL.F.F41.0025")%>/<%=g.getMessage("LABEL.F.F41.0032")%></th>
          <th><!-- Hiring Date --><%=g.getMessage("LABEL.F.F41.0026")%></th>
          <th> <!--Int Date of Conti. --><%=g.getMessage("LABEL.F.F41.0027")%></th>
          <th><!-- Generated(Days) --><%=g.getMessage("LABEL.F.F41.0028")%></th>
          <th><!--Used(Days) --><%=g.getMessage("LABEL.F.F41.0029")%></th>
          <th><!--Balance(Days) --><%=g.getMessage("LABEL.F.F41.0030")%></th>
          <th class="lastCol"><!-- Use Rate(%) --><%=g.getMessage("LABEL.F.F41.0031")%></th>
        </tr>
       </thead>
<%
          int ifrom = chkAll.equals("")?pu.formRow():0;
          int ito = chkAll.equals("")?pu.toRow():DeptVacation_vt.size();

			for( int i = 0; i < DeptVacation_vt.size(); i++ ){
			    F41DeptVacationData data = (F41DeptVacationData)DeptVacation_vt.get(i);
				sumOCCUR += Double.parseDouble(data.GENERATED);
				sumABWTG += Double.parseDouble(data.USED);
				sumZKVRB += Double.parseDouble(data.BALANCE);
			}

			//평균 값 계산//[CSR ID:3038270]
			if(sumABWTG >0 && sumOCCUR>0){
				allAVG = WebUtil.printNumFormat((sumABWTG / sumOCCUR )*100,2);
			}else{
				allAVG = "0.00";
			}


          for( int i = ifrom ; i < ito; i++ ){
            F41DeptVacationData data = (F41DeptVacationData)DeptVacation_vt.get(i);

			String class1 = "";
			if (Double.parseDouble(data.USERATE)>=Double.parseDouble(allAVG)) {
				class1 = "";
			} else {
				class1 = "bgcolor='#f8f5ed'";
			}
%>
        <tr class="borderRow">
          <td <%=class1%>><%= data.PERNR %></td>
          <td <%=class1%>><%= data.ENAME %></td>
          <td <%=class1%>><%= data.STEXT %></td>
          <td <%=class1%>><%= data.JIKTX %></td>
          <td <%=class1%>><%= data.JIWTX %></td>
          <td <%=class1%>><%= data.JICTX + " / " + data.ANNUL %></td>
          <td <%=class1%>><%= (data.HDATE).replace("-","").replace(".","").equals("00000000")  ? "" : WebUtil.printDate(data.HDATE) %></td>
          <td <%=class1%>><%= (data.CSDAT).replace("-","").replace(".","").equals("00000000")  ? "" : WebUtil.printDate(data.CSDAT) %></td>
          <td <%=class1%>><%= (data.GENERATED).equals("") ? "" : WebUtil.printNumFormat(data.GENERATED,2) %></td>
          <td <%=class1%>><%= (data.USED).equals("") ? "" : WebUtil.printNumFormat(data.USED,2) %></td>
          <td <%=class1%>><%= (data.BALANCE).equals("") ? "" : WebUtil.printNumFormat(data.BALANCE,2) %></td>
          <td class="lastCol" <%=class1%>><%= data.USERATE %></td>
        </tr>
<%
          } //end for...
%>
          <tr class="sumRow">
          <td class="td11" colspan="8"> <!-- 팀 휴가 사용율 --><%=g.getMessage("LABEL.F.F41.0017")%></td>
          <td class="td11"><%=sumOCCUR %></td>
          <td class="td11"><%=sumABWTG %></td>
          <td class="td11"><%=sumZKVRB %></td>
          <td class="lastCol td11"><%=allAVG %></td>
          </tr>
      </table>
    </div>
  </div>

  <div><%= chkAll.equals("")?(pu == null ? "" : pu.pageControl()):"" %></div>


<%
    }else{
%>

  <h2 class="subtitle"><!-- Org.Unit --><%=g.getMessage("LABEL.F.F41.0022")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
      <thead>
        <tr>
          <th><!--Pers.No --><%=g.getMessage("LABEL.F.F41.0020")%></th>
          <th><!-- Name --><%=g.getMessage("LABEL.F.F41.0021")%></th>
          <th><!-- Org.Unit --><%=g.getMessage("LABEL.F.F41.0022")%></th>
          <th><!-- Res of Office --><%=g.getMessage("LABEL.F.F41.0023")%></th>
          <th><!-- Title of Level--><%=g.getMessage("LABEL.F.F41.0024")%></th>
          <th><!-- Level / Annual --><%=g.getMessage("LABEL.F.F41.0025")%>/<%=g.getMessage("LABEL.F.F41.0032")%></th>
          <th><!-- Hiring Date --><%=g.getMessage("LABEL.F.F41.0026")%></th>
          <th> <!--Int Date of Conti. --><%=g.getMessage("LABEL.F.F41.0027")%></th>
          <th><!-- Generated(Days) --><%=g.getMessage("LABEL.F.F41.0028")%></th>
          <th><!--Used(Days) --><%=g.getMessage("LABEL.F.F41.0029")%></th>
          <th><!--Balance(Days) --><%=g.getMessage("LABEL.F.F41.0030")%></th>
          <th  class="lastCol"><!-- Use Rate(%) --><%=g.getMessage("LABEL.F.F41.0031")%></th>
        </tr>
        </thead>
        <tr>
          <td colspan="12" class="lastCol"><!--No data --><%=g.getMessage("LABEL.F.F51.0029")%></td>
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
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

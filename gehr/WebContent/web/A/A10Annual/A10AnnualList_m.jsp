<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 나의 연봉                                                   */
/*   Program Name : 나의 연봉                                                   */
/*   Program ID   : A10AnnualList.jsp                                           */
/*   Description  : 나의 연봉 조회                                              */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-28  윤정현                                          */
/*                  2006-03-17  @v1.1 lsa 급여작업으로 막음                     */
/*                  2006-05-17  @v1.1 lsa 5월급여작업으로 막음  전문기술직만    */
/*                  2006-06-16 @v1.1 kdy 임금인상관련 급여화면 제어              */
/*  [CSR ID:2510507] 문구 수정 요청의 건 | [요청번호]C20140325_10507  이지은D  2014-03-25 해당 건 받은 뒤 긴급반영(문구 수정) 직책/직무 삭제 (유한범D) */
/*   // [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청                                                                           */
/*  2017/01/18 rdcamel [CSR ID:3275644] ERP 급여항목 명칭 변경(추가) 요청    */
/*  2017-04-05 rdcamel [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건 */
/*  2018-03-09 cykim  [CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件   */
/*  2018-03-27 rdcamel [CSR ID:3633546] 임원 연봉계약/집행임원서약서 온라인 날인을 위한 시스템 지원 요청  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.A.A10Annual.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="hris.B.db.*" %>

<%
	WebUserData user_m = WebUtil.getSessionMSSUser(request);

    Vector A10AnnualData_vt = (Vector)request.getAttribute("A10AnnualData_vt");
    String jobid  = (String)request.getAttribute("jobid");
    String paging = (String)request.getAttribute("page");

    PageUtil pu = null;
    try {
        if( A10AnnualData_vt.size() != 0 ){
            pu = new PageUtil(A10AnnualData_vt.size(), paging , 10, 10);
            Logger.debug.println(this, "page : "+paging);
        }
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }
    B01ValuateDetailDB valuateDetailDB     = new B01ValuateDetailDB();
    String       DB_YEAR            = valuateDetailDB.getYEAR();
    String       StartDate           = valuateDetailDB.getStartDate();

    //Logger.debug.println(this, A10AnnualData_vt.toString() );
      // 2015- 06-08 개인정보 통합시 subView ="Y";
    String subView = WebUtil.nvl(request.getParameter("subView"));
%>

<jsp:include page="/include/header.jsp"/>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit() { //연봉계약서 page로 이동한다.
    document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A10Annual.A10AnnualListSV_m?subView=<%=subView%>';

    document.form2.method = "post";
    document.form2.target = "listFrame";
    document.form2.submit();
}

function trans_form(option) {

    var command = "";
    var size = "";
    if( document.form1.radiobutton.value =="99"){
        return;
    } else if( isNaN( document.form1.radiobutton.length ) ){
        size = 1;
    } else {
        size = document.form1.radiobutton.length;
    }
    for (var i = 0; i < size ; i++) {
        if ( size == 1 ){
            command = 0;
        } else if ( document.form1.radiobutton[i].checked == true ) {
            if( i == 0 && document.form1.BETRG0.value==0.0 ){//평가등급에서 연봉으로 변경
                command = 1;//전년도 값
            } else {
                command = document.form1.radiobutton[i].value;
            }
        }
    }

    if (command !="" || command =="0") {
    	if(option == "2"){//집행임원서약서
	        eval("document.form2.ZYEAR.value = document.form1.ZYEAR"+command+".value");
    		if(document.form2.ZYEAR.value >= "2016"){
		        window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=800,height=650");
		        document.form2.jobid.value = "search";
		        document.form2.target = "essPrintWindow";
		        document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A21ExecutivePledge.A21EPListSV_m';
		        document.form2.method = "post";
		        document.form2.submit();
    		}else{
    			alert("<spring:message code='MSG.A.A10.0002' />");  //집행임원서약서의 경우 2016년도 이후부터 조회 가능합니다.
    			return;
    		}
    	}else{//연봉계약서
    		eval("document.form2.ZYEAR.value = document.form1.ZYEAR"+command+".value");
		        window.open('', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=800,height=650");
		        document.form2.jobid.value = "search";
		        document.form2.target = "essPrintWindow";
		        document.form2.action = '<%= WebUtil.ServletURL %>hris.A.A10Annual.A10AnnualListSV_m';
		        document.form2.method = "post";
		        document.form2.submit();
    	}
    }
    else {
        alert("<spring:message code='MSG.A.A10.0001' />"); //년도를 선택하세요!
    }
    //doSubmit();
}

// PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form2.page.value = page;
    document.form2.jobid.value = "page";
    doSubmit();
}

//-->
</SCRIPT>
</head>
<jsp:include page="/include/body-header.jsp" >
    <jsp:param name="click" value="Y" />
</jsp:include>
<form name="form1" method="post">

    <h2 class="subtitle"><spring:message code='TAB.COMMON.0010' /><!-- 나의 연봉 --></h2>

    <% //@v1.1
        //if ( (user.e_persk.equals("32")||user.e_persk.equals("33") ) && Integer.parseInt(DataUtil.getCurrentDate()) >= 20060616 &&  Integer.parseInt(DataUtil.getCurrentDate())  < 20060623 ) {
        String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( user_m.empNo );

        if (O_CHECK_FLAG.equals("N") ) {
    %>

    <div class="align_center">
        <font color="red"><spring:message code='MSG.A.A01.0075' /><!-- ※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다. --></font><!--@v1.1-->
    </div>

    <% } else {  //@v1.1 else %>




    <!-- 조회 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <%
                if( A10AnnualData_vt.size() > 0 ) {

                    if (user_m.companyCode.equals("C100")) {
            %>
            <%-- <span><a href="javascript:trans_form(1);" ><img src="<%= WebUtil.ImageURL %>btn_PaySerch.gif" border="0" align="absmiddle"></a> <a href="javascript:trans_form(2);" ><img src="<%= WebUtil.ImageURL %>btn_pledgeSearch.gif" border="0" align="absmiddle"></a></span> --%>
            <span><a href="javascript:trans_form(1);" ><img src="<%= WebUtil.ImageURL %>btn_PaySerch.gif" border="0" align="absmiddle"></a>
            <!--[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 start  -->
            <%if(user_m.e_persk.equals("11") || user_m.e_persk.equals("12")){%>
             <a href="javascript:trans_form(2);" ><img src="<%= WebUtil.ImageURL %>btn_pledgeSearch.gif" border="0" align="absmiddle"></a>
             <%} %></span>
             <!-- [CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 end -->
            <%
                        if(!(user_m.e_persk.equals("11") || user_m.e_persk.equals("12"))){//// [CSR ID:3006173]
            %>
            <span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
            <%
                    }
                }
            %>
            <%--<div class="buttonArea">--%>
                <%--<ul class="btn_mdl">--%>
                    <%--<li><a href="javascript:trans_form();"><span>연봉계약서 조회</span></a></li>--%>
                <%--</ul>--%>
            <%--</div>--%>
                <%
                    }
                %>

        </div>
        <div class="table">
            <table class="listTable">
                <thead>
                <tr>
                    <%if(user_m.e_persk.equals("11") || user_m.e_persk.equals("12")){//// [CSR ID:3006173]%>
                    <th width="10%"><spring:message code='MSG.A.A03.0020' /><!-- 선택 --></th>
                    <th width="10%" ><spring:message code='LABEL.A.A10.0003' /><!-- 년도 --></th>
                    <th width="20%"><spring:message code='MSG.A.A05.0005' /><!-- 소속 --></th>
                    <!-- <th width="96">직급/년차</th>
                    <th width="96">전년평가등급</th> -->
                    <th width="20%"><spring:message code='LABEL.A.A10.0004' /><!-- 기본연봉 --></th>
                    <!-- [CSR ID:3275644] -->
                    <%if(user_m.empNo.equals("00217646")||user_m.empNo.equals("00223615")||user_m.empNo.equals("00221313")){ %>
                    	<th width="20%"><spring:message code='LABEL.A.A10.0005' /><!-- 역할급 --> / <spring:message code='LABEL.A.A10.0021' /><!-- Fellow Allowance --></th>
                    <%}else{ %>
                    	<th width="20%"><spring:message code='LABEL.A.A10.0005' /><!-- 역할급 --></th>
                    <%} %>

                    <th class="lastCol" width="20%"><spring:message code='LABEL.A.A10.0006' /><!-- 고정연봉 --></th>
                    <!-- <th width="60">인상율</th> -->
                    <%}else{ %>
                    <th width="40"><spring:message code='MSG.A.A03.0020' /><!-- 선택 --></th>
                    <th width="70" ><spring:message code='LABEL.A.A10.0003' /><!-- 년도 --></th>
                    <th width="170"><spring:message code='MSG.A.A01.0006' /><!-- 소속 --></th>
                    <th width="96"><spring:message code='MSG.A.A05.0008' /><!-- 직급/년차 --></th>
                    <th width="96"><spring:message code='LABEL.A.A10.0007' /><!-- 전년평가등급 --></th>
                    <th width="96"><spring:message code='LABEL.A.A10.0004' /><!-- 기본연봉 --></th>
                    <th width="96"><spring:message code='LABEL.A.A10.0008' /><!-- 수당계(월) --></th>
                    <th width="96"><spring:message code='LABEL.A.A10.0009' /><!-- 연봉총액 --></th>
                    <th class="lastCol" width="60"><spring:message code='LABEL.A.A10.0010' /><!-- 인상율 --></th>

                    <%} %>
                </tr>
                </thead>
                <%
                    if( A10AnnualData_vt.size() > 0 ) {
                        int j = 0;// 내부 카운터용
                        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                            A10AnnualData data1 = (A10AnnualData)A10AnnualData_vt.get(i);
                            A10AnnualData data = null;

                            String tr_class = "";

                            if(i%2 == 0){
                                tr_class="oddRow";
                            }else{
                                tr_class="";
                            }

                            //	[CSR ID:3006173] 임원의 경우 16년도만 데이터 가져오도록 수정
                            if(user_m.e_persk.equals("11") ||user_m.e_persk.equals("12"))	{

                            	//[CSR ID:3348752]
                            	//Integer.parseInt(data1.ZYEAR) > 2015){
                                if(data1.TRFAR.equals("01")&&Integer.parseInt(data1.ZYEAR) > 2015){
                                    data =  data1;
                                }
                            }else{
                                data =  data1;
                            }



                            // [CSR ID:3006173]
                            if(data != null){
                %>
                <tr class="<%=tr_class%>">
                    <%
                        // [CSR ID:3006173] 연봉계약서 조회 조건, 1. 2007 이후부터 가능, 2. 임원일 경우 연봉계약서 online 관리를 2016년부터 시작함.
                        // [CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 start @ 조직관리의 타인 연봉계약서 조회시 폴더이력관리가 2008년도 부터 있으므로 2008년부터 연봉계약서 조회 가능하도록 함.
                        //if (user_m.companyCode.equals("C100") && Integer.parseInt(data.ZYEAR) > 2006) {
						if (user_m.companyCode.equals("C100") && Integer.parseInt(data.ZYEAR) > 2007) {
                        // [CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 end
                        	if(data.TRFAR.equals("01")){//임원?
                                if(Integer.parseInt(data.ZYEAR) > 2015){//임원 연봉계약서 2016년도 개발 및 open
                    %>
                    <td>
                        <input type="radio" name="radiobutton" value="<%= j %>" <%=(j==0) ? "checked" : ""%> >
                    </td>
                    <%

                    }else{//임원 2015이하 년도
                    %>
                    <td width="40">&nbsp;</td>
                    <input type="hidden" name="radiobutton" value="99">
                    <%
                        }
                    }else{//일반사원
                    %>
                    <td>
                        <input type="radio" name="radiobutton" value="<%= j %>" <%=(j==0) ? "checked" : ""%> >
                    </td>
                    <%
                        }//일반 사원 끝
                    }else {
                    %>
                    <td width="40">&nbsp;</td>
                    <input type="hidden" name="radiobutton" value="99">
                    <%
                        }
                    %>

                    <%
                        if (user_m.companyCode.equals("C100")&&data.ZYEAR.equals("2004")) {
                    %>
                    <td><%=  WebUtil.printDate(data.BEGDA) %>&nbsp;</td>
                    <%
                    }else {
                    %>
                    <td><%= data.ZYEAR %>&nbsp;</td>
                    <%
                        }
                    %>
                    <td><%= (i==pu.formRow()) && (data.ORGTX).equals("") ? user_m.e_orgtx : data.ORGTX %>&nbsp;</td>

                    <%if(!(user_m.e_persk.equals("11") || user_m.e_persk.equals("12"))){//// [CSR ID:3006173]%>
                    <td><%= (i==pu.formRow()) && (data.TRFGR).equals("") ? ( user_m.e_trfgr+"&nbsp;/&nbsp;"+ ((user_m.e_vglst).equals("") ? "-" : user_m.e_vglst )) : ( data.TRFGR+"&nbsp;/&nbsp;"+ ((data.VGLST).equals("") ? "-" : data.VGLST) )%>&nbsp;</td>
                    <td>
                        <%                int beforYear = Integer.parseInt(data.ZYEAR)-1;
                            if ( ( beforYear == Integer.parseInt(DB_YEAR))&& (Long.parseLong(StartDate) > Long.parseLong(DataUtil.getCurrentDate())  ) ) {


                        %>
                        <%                } else { %>
                        <%= data.EVLVL %>
                        <%                } %>
                        &nbsp;</td>

                    <%} %>
                    <td ><%= WebUtil.printNumFormat(data.BETRG).equals("0") ? "" : WebUtil.printNumFormat(data.BETRG) %>&nbsp;</td>



<%if(data.ZYEAR.equals("2018") && user_m.empNo.equals("00223401")){ //손지웅%>
                    <td>160,800,000&nbsp;</td>
<%}else if(data.ZYEAR.equals("2018") && user_m.empNo.equals("00005486")){ //김종현%>
                   <td>241,200,000&nbsp;</td>
<%}else{ %>
					<td><%= WebUtil.printNumFormat(data.BET01).equals("0") ? "" : WebUtil.printNumFormat(data.BET01) %>&nbsp;</td>
<%} %>



                    <%if(user_m.e_persk.equals("11") || user_m.e_persk.equals("12")){%>


<%if(data.ZYEAR.equals("2018") && user_m.empNo.equals("00223401")){ //손지웅%>
                    <td class="lastCol">562,800,000&nbsp;</td>
<%}else if(data.ZYEAR.equals("2018") && user_m.empNo.equals("00005486")){ //김종현%>
                   <td class="lastCol">643,200,000&nbsp;</td>
<%}else{ %>
					<td class="lastCol"><%= WebUtil.printNumFormat(data.ANSAL).equals("0") ? "" : WebUtil.printNumFormat(data.ANSAL) %>&nbsp;</td>
<%} %>


                    <%}else{%>
                    <td ><%= WebUtil.printNumFormat(data.ANSAL).equals("0") ? "" : WebUtil.printNumFormat(data.ANSAL) %>&nbsp;</td>
                    <%

                    } %>
                    <%if(!(user_m.e_persk.equals("11") || user_m.e_persk.equals("12"))){//// [CSR ID:3006173]%>
                    <td class="lastCol"><%= ( data.ZINCR.equals("0") && i == (pu.toRow()-1) ) ? "" :  WebUtil.printNumFormat(data.ANSAL).equals("0")  ? "" : data.ZINCR+"(%)"%>&nbsp;  <!-- 조건 연봉총액이 0 이거나 현재 값이 0일경우에  표시안함 -->
                    </td>
                    <%} %>
                    <input type="hidden" name="BETRG<%= j %>" value="<%= data.BETRG %>">
                    <input type="hidden" name="EVLVL<%= j %>" value="<%= data.EVLVL %>">
                    <input type="hidden" name="ZYEAR<%= j %>" value="<%= data.ZYEAR %>">
                </tr>
                <%
                            j++;
                        }
                    }
                %>

                <%
                }else {
                %>
                <tr align="center">
                    <td class="lastCol" colspan="9"><spring:message code='LABEL.A.A04.0014' /><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
                </tr>
                <%
                    }
                %>
            </table>
            <div class="align_center">

                <%if(!(user_m.e_persk.equals("11") || user_m.e_persk.equals("12"))){//// [CSR ID:3006173]%>
                <!-- PageUtil 관련 - 반드시 써준다. -->
                <%= pu == null ? "" : pu.pageControl() %>
                <!-- PageUtil 관련 - 반드시 써준다. -->
                <%} %>
            </div>
        </div>
    </div>
    <!-- 조회 리스트 테이블 끝-->




    <%if(!(user_m.e_persk.equals("11") || user_m.e_persk.equals("12"))){//// [CSR ID:3006173]%>

    <div class="commentImportant" style="width:75%;">
        <p><span class="bold"><spring:message code='LABEL.A.A10.0011' /><!-- ○ 기본연봉 : 금년 3월부터 내년 2월까지 실수령하는 금액으로 [(月기본급 + 상여월할분) x 12 + 명절상여 x 2] 한 금액임. --></span></p>
        <p style="padding-left: 77px"><spring:message code='LABEL.A.A10.0012' /><!-- → 月기본급  = 명절상여 = 기본연봉의 20분의 1 --></p>
        <p style="padding-left: 93px"><spring:message code='LABEL.A.A10.0013' /><!-- 상여월할분 = 月기본급의 2분의 1 --></p>
        <p style="padding-left: 22px"><spring:message code='LABEL.A.A10.0014' /><!-- ☞ 중도 입사자 : 입사일로 부터 1년이 되는 날까지의 수령액 기준이며 내년도 --></p>
        <p style="padding-left: 22px"><spring:message code='LABEL.A.A10.0015' /><!-- 급여조정시 회사가 정하는 바에 따라 연봉조정할 수 있다. --></p>



        <p><span class="bold"><spring:message code='LABEL.A.A10.0016' /><!-- ○ 수당계(월) : 자격/기타수당 등 --></span></p>
        <p><span class="bold"><spring:message code='LABEL.A.A10.0017' /><!-- ○ 연봉총액 : 기본연봉 + 수당계(월) X 12 (성과급은 제외) --></span></p>
        <p><span class="bold"><spring:message code='LABEL.A.A10.0018' /><!-- ○ 지급방법 : --></span></p>
        <p style="padding-left: 22px"><spring:message code='LABEL.A.A10.0019' /><!-- - 매월 : 月기본급 + 상여월할분 + 수당계(월) --></p>
        <p style="padding-left: 22px"><spring:message code='LABEL.A.A10.0020' /><!-- - 추석.설 : 명절상여 --></p>
    </div>

    <%} %>

    <% } //@v1.1 end %>
</form>
<form name="form2" method="post" action="">
<!--  HIDDEN  처리해야할 부분 시작-->
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="page" value="<%= paging %>">
  <input type="hidden" name="ZYEAR" value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>

<jsp:include page="/include/footer.jsp"/>

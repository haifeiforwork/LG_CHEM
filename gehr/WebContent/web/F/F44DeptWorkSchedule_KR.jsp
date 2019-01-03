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
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>


<%
	// 웹로그 메뉴 코드명
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

	String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
    String E_BEGDA      = WebUtil.nvl((String)request.getAttribute("E_BEGDA"));     //대상년월
    String E_ENDDA      = WebUtil.nvl((String)request.getAttribute("E_ENDDA"));     //대상년월
    Vector F44DeptScheduleTitle_vt = (Vector)request.getAttribute("F44DeptScheduleTitle_vt");   //제목
    Vector F44DeptScheduleData_vt  = (Vector)request.getAttribute("F44DeptScheduleData_vt");    //내용
    Vector T_TPROG  = (Vector)request.getAttribute("T_TPROG");    //내용
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
	String subView       = WebUtil.nvl(request.getParameter("subView"));
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

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F44DeptWorkScheduleSV";
    frm.target = "_self";
    frm.submit();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F44DeptWorkScheduleSV";
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

/**
 * null 이나 빈값을 기본값으로 변경
 * @param str       입력값
 * @param defaultVal    기본값(옵션)
 * @returns {String}    체크 결과값
 */
function nvl(str, defaultVal) {
    var defaultValue = "";
    if (typeof defaultVal != 'undefined') {
        defaultValue = defaultVal;
    }
    if (typeof str == "undefined" || str == null || str == '' || str == "undefined") {
        return defaultValue;
    }
    return str;
}

	$(document).ready(function() {
		$('.listTab').find('tr').each(function(i,val){
			$(val).find('td').each(function(j,val2){
				var title = $(val2).html();
				if(title == "OFF" || title == "OFFH"){
					$(val2).css("color", "red");
				}
			});

			$(val).find('th').each(function(j,val2){
				if(i == 0){
					if(nvl($(val2).attr("class")) != ""){
						var tdClass = $(val2).attr("class").split(" ");
						var tdId = tdClass[1];
						$(".td_"+tdId).css({'color':'red'});
					}
				}
			});
		});
	});

//-->
</SCRIPT>


	<jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value ="Y"/>
        <jsp:param name="help" value="X04Statistics.html'"/>
    </jsp:include>

<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >

<%
    if ( F44DeptScheduleTitle_vt != null && F44DeptScheduleTitle_vt.size() > 0 ) {
        //타이틀 사이즈.
        int titlSize = F44DeptScheduleTitle_vt.size();

        //대상년월 폼 변경.
        if( !E_BEGDA.equals("") && !E_ENDDA.equals("") ){
            E_BEGDA = E_BEGDA.substring(0, 4)+"."+E_BEGDA.substring(4, 6);
            E_ENDDA = E_ENDDA.substring(0, 4)+"."+E_ENDDA.substring(4, 6);
        }
%>
<h2 class="subtitle withButtons">( <%=E_BEGDA%>~<%=E_ENDDA%> )<!-- 월 --><%=g.getMessage("LABEL.F.F42.0053")%> <!-- 근무 계획표 --><%=g.getMessage("LABEL.F.F44.0001")%></h2>
			<div class="buttonArea">
	            <ul class="btn_mdl displayInline">
	                <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>

	            </ul>
	         </div>

<%
        String tempDept = "";
        for( int j = 0; j < F44DeptScheduleData_vt.size(); j++ ){
            F44DeptWorkScheduleNoteData deptData = (F44DeptWorkScheduleNoteData)F44DeptScheduleData_vt.get(j);

            //하위부서를 선택했을 경우 부서 비교.
            if( !deptData.ORGEH.equals(tempDept) ){
%>
   	<div class="listArea">
  	<div class="listTop">
  		<span class="listCnt">
  			<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=deptData.STEXT%></h2>
  		</span>

  	</div>
   		<div class="table">
   		<div class="wideTable">
	      <table class="listTable listTab">
	      <thead>
	        <tr>
	          <th class="" rowspan="2"><!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%></th>
	          <th class="" rowspan="2"><!-- 성명--><%=g.getMessage("LABEL.F.F42.0003")%></th>
	          <th class="" rowspan="2"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
<%
                //타이틀(일자).
                for( int h = 0; h < titlSize; h++ ){
                    F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData)F44DeptScheduleTitle_vt.get(h);
                    String tdColor = "";
                    if (titleData.HOLIDAY.equals("Y")) {
                    	tdColor = "td11 T"+(h+1);
                    }
%>
      	    	<th class="<%=tdColor%>" ><%=titleData.DD%></th>
<%
                }
%>
	        </tr>

	        <tr>
<%
                //타이틀(요일).
                for( int k = 0; k < titlSize; k++ ){
                    F44DeptWorkScheduleTitleData titleData = (F44DeptWorkScheduleTitleData)F44DeptScheduleTitle_vt.get(k);
                    String tdColor = "";
                    if (titleData.HOLIDAY.equals("Y")) {
                        tdColor = "td11";
                    }
%>
      	    	<th class="<%=tdColor%>"  nowrap><%=titleData.KURZT%></th>
<%
                }//end if

                int inx = 0;
                for( int i = j; i < F44DeptScheduleData_vt.size(); i++ ){
                    F44DeptWorkScheduleNoteData data = (F44DeptWorkScheduleNoteData)F44DeptScheduleData_vt.get(i);
                    String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

                    String tr_class = "";

                    if(i%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }

                    if( data.ORGEH.equals(deptData.ORGEH) ){
                    inx++;
%>
	        </thead>
	        <tr class="<%=tr_class%>">
	          <td ><%=inx%>&nbsp;&nbsp;</td>
	         <td class="align_left" nowrap><%=data.ENAME%></td>
	          <td class=''><%=data.PERNR%>&nbsp;</td>
	          <td class='td_T1'><%=data.T1 %></td>
	          <td class='td_T2'><%=data.T2 %></td>
	          <td class='td_T3'><%=data.T3 %></td>
	          <td class='td_T4'><%=data.T4 %></td>
	          <td class='td_T5'><%=data.T5 %></td>
	          <td class='td_T6'><%=data.T6 %></td>
	          <td class='td_T7'><%=data.T7 %></td>
	          <td class='td_T8'><%=data.T8 %></td>
	          <td class='td_T9'><%=data.T9 %></td>
	          <td class='td_T10'><%=data.T10%></td>
	          <td class='td_T11'><%=data.T11%></td>
	          <td class='td_T12'><%=data.T12%></td>
	          <td class='td_T13'><%=data.T13%></td>
	          <td class='td_T14'><%=data.T14%></td>
	          <td class='td_T15'><%=data.T15%></td>
	          <td class='td_T16'><%=data.T16%></td>
	          <td class='td_T17'><%=data.T17%></td>
	          <td class='td_T18'><%=data.T18%></td>
	          <td class='td_T19'><%=data.T19%></td>
	          <td class='td_T20'><%=data.T20%></td>
	          <td class='td_T21'><%=data.T21%></td>
	          <td class='td_T22'><%=data.T22%></td>
	          <td class='td_T23'><%=data.T23%></td>
	          <td class='td_T24'><%=data.T24%></td>
	          <td class='td_T25'><%=data.T25%></td>
	          <td class='td_T26'><%=data.T26%></td>
	          <td class='td_T27'><%=data.T27%></td>
	          <td class='td_T28'><%=data.T28%></td>
	          <% if( titlSize >= 29 )  out.println("<td class='td_T29'>"+data.T29+"</td>"); %>
	          <% if( titlSize >= 30 )  out.println("<td class='td_T30'>"+data.T30+"</td>"); %>
	          <% if( titlSize >= 31 )  out.println("<td class='td_T31'>"+data.T31+"</td>"); %>
	        </tr>
<%
                    }//end if
                } //end for...
%>
      		</table>
      		</div>
      	</div>
	</div>
<%
                //부서코드 비교를 위한 값.
                tempDept = deptData.ORGEH;
            }//end if
        }//end for
%>

</div>
<div class="listArea">
			<div class="listTop">
		  		<span class="listCnt">
		  			<h2 class="subtitle"><spring:message code='LABEL.D.D40.0026'/><!-- 일일근무일정 설명 --></h2>
		  		</span>
			</div>
			<div class="table">
   				<div class="wideTable">
	      			<table class="listTable">
	      				<thead>
	      				<colgroup>
			                <col width="10%" />
							<col width="15%" />
							<col width="25%" />
							<col width="10%" />
							<col width="15%" />
				            <col width="25%" />
			            </colgroup>
	        			<tr>
							<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
							<th><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
							<th><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
							<th><!-- 코드--><spring:message code='LABEL.D.D13.0004'/></th>
							<th><!-- 명칭--><spring:message code='LABEL.D.D40.0027'/></th>
							<th class="lastCol"><!-- 설명--><spring:message code='LABEL.D.D40.0028'/></th>
						</tr>
						</thead>
<%
						if(T_TPROG.size()%2 != 0){
							D40TmSchkzPlanningChartCodeData addDt = new D40TmSchkzPlanningChartCodeData();
							addDt.CODE = "";
							addDt.TEXT = "";
							addDt.DESC = "";
							T_TPROG.addElement(addDt);
						}
						for( int i = 0; i < T_TPROG.size(); i++ ){
							D40TmSchkzPlanningChartCodeData data = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(i);
							String tr_class = "";
		                    if(i%4 == 0){
		                        tr_class="oddRow";
		                    }else{
		                        tr_class="";
		                    }
%>
						<%if(i%2 == 0){ %>
						<tr class="<%=tr_class%>">
							<td><%=data.CODE %></td>
							<td><%=data.TEXT %></td>
							<td><%=data.DESC %></td>
						<%}else{ %>
							<td><%=data.CODE %></td>
							<td><%=data.TEXT %></td>
							<td class="lastCol"><%=data.DESC %></td>
						</tr>
						<%} %>

<%
						}
%>

					</table>
				</div>
			</div>
		</div>

<%
    }else{
%>
<div class="align_center">
    <p><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.COMMON.0004")%></p>
</div>
<%
    } //end if...
%>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

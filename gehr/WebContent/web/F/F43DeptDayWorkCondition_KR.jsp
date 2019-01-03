<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 일간 근태 집계표                                            		*/
/*   Program ID   : F43DeptDayWorkCondition.jsp                                 */
/*   Description  : 부서별 일간 근태 집계표 조회를 위한 jsp 파일                		*/
/*   Note         : 없음                                                         		*/
/*   Creation     : 2005-02-17 유용원                                            		*/
/*   Update       : 2018-07-19 성환희 [Worktime52] 잔여보상휴가 추가 				*/
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
	// 웹로그 메뉴 코드명
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                  //부서명
    String searchDay    = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));           //대상년월
    String year      = "";
    String month     = "";
    String dayCnt       = WebUtil.nvl((String)request.getAttribute("E_DAY_CNT"), "28");     //일자수
    Vector F43DeptDayTitle_vt = (Vector)request.getAttribute("F43DeptDayTitle_vt");         //제목
    Vector F43DeptDayData_vt = (Vector)request.getAttribute("F43DeptDayData_vt");           //내용
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
    	// alert("선택하신 조직은 데이터가 너무 많습니다. \n\n하위조직을 선택하여 조회하시기 바랍니다.   ");
        alert("<%=g.getMessage("MSG.F.F41.0003")%>  ");
        return;
    }

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F43DeptDayWorkConditionSV";
    frm.target = "_self";
    frm.submit();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F43DeptDayWorkConditionSV";
    frm.target = "hidden";
    frm.submit();
}

//집계표
function go_Rotationprint(){
	var t_year = document.form1.year.value;
	var t_month = document.form1.month.value;
    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1300,height=662,left=0,top=2");

    document.form1.target = "essPrintWindow";
    document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_daily_rotation.jsp?hdn_deptId=<%=deptId %>&hdn_excel=print&year1="+t_year+"&month1="+t_month+"&checkYn="+document.form1.chck_yeno.value ;
    document.form1.method = "post";
    document.form1.submit();
}

function zocrsn_get() {
    frm = document.form1;
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F43DeptDayWorkConditionSV";
    frm.target = "_self";
    frm.method = "post";
    frm.submit();
}

function searchDayCheck() {
    frm = document.form1;
    var yymm = "";
    if(frm.month.value.length==1) {
      yymm = frm.year.value + '0' + frm.month.value;
    } else {
      yymm = frm.year.value + frm.month.value;
    }
    if(frm.searchDay_bf.value!=yymm&&frm.searchDay_bf.value!="") {
      frm.year.value = frm.searchDay_bf.value.substring(0,4);
      if(frm.searchDay_bf.value.substring(4,6)!=10&&frm.searchDay_bf.value.substring(4,6)!=11&&frm.searchDay_bf.value.substring(4,6)!=12) {
        frm.month.value = frm.searchDay_bf.value.substring(5,6);
      } else {
        frm.month.value = frm.searchDay_bf.value.substring(4,6);
      }
    }
}

function popupView(winName, width, height, pernr) {
	var formN = document.form1;
	formN.viewEmpno.value = pernr;

	var screenwidth = (screen.width-width)/2;
    var screenheight = (screen.height-height)/2;
    var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr;

	 var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

}

$(document).ready(function(){
	searchDayCheck();

 });
//-->
</SCRIPT>

      <jsp:include page="/include/body-header.jsp">
      <jsp:param name="click" value="Y'"/>
    </jsp:include>


<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="I_VALUE1"  value="">
<input type="hidden" name="retir_chk"  value="">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">
<input type="hidden" name="subView" value="<%=subView%>">
<INPUT type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >


<%
    //부서명, 조회된 건수.
//    if ( F43DeptDayTitle_vt != null && F43DeptDayTitle_vt.size() > 0 ) {
        F43DeptDayTitleWorkConditionData titleData = (F43DeptDayTitleWorkConditionData)F43DeptDayTitle_vt.get(0);
%>

			<div class="buttonArea">
				<select name="year" onChange="javascript:zocrsn_get();">
<%
	int end_year= Integer.parseInt( DataUtil.getCurrentYear() );
	if (Integer.parseInt(DataUtil.getCurrentDate().substring(4,8)) >=1221){
		  end_year = end_year+1;
	}
    for( int i = 2001 ; i <= end_year ; i++ ) {
        int year1 = Integer.parseInt(searchDay.substring(0, 4));
%>
                      <option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>
				</select>
				<select name="month" onChange="javascript:zocrsn_get();">
<%
    for( int i = 1 ; i <= 12 ; i++ ) {
        String temp = Integer.toString(i);
        int mon = Integer.parseInt(searchDay.substring(4, 6));
%>
					<option value="<%= i %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
    }
%>
				</select>
	            <input type="hidden" name="year1" value="">
	            <input type="hidden" name="month1" value="">
	            <input type="hidden" name="searchDay_bf" value="">
	            <ul class="btn_mdl displayInline">
	                <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	                <li><a href="javascript:go_Rotationprint();"><span><!-- 인쇄하기--><%=g.getMessage("LABEL.F.F42.0002")%></span></a></li>
	            </ul>
			</div>
<%
        String tempDept = "";
        for( int j = 0; j < F43DeptDayData_vt.size(); j++ ){
            F43DeptDayDataWorkConditionData deptData = (F43DeptDayDataWorkConditionData)F43DeptDayData_vt.get(j);

            //하위부서를 선택했을 경우 부서 비교.
            if( !deptData.ORGEH.equals(tempDept) ){
%>
<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=deptData.STEXT%></h2>
    <div class="listArea">
        <div class="table">
        <div class="wideTable" >
            <table class="listTable">
            <thead>
                <tr>
                  <th width="5%" rowspan="2" ><!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%></th>
                  <th width="8%" rowspan="2" ><!-- 성명--><%=g.getMessage("LABEL.F.F42.0003")%></th>
                  <th width="8%" rowspan="2" ><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
                  <th width="7%" rowspan="2" ><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></th>
                  <th width="7%" rowspan="2" ><!-- 잔여보상--><%=g.getMessage("LABEL.F.F42.0087")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th class="lastCol" colspan="<%=dayCnt%>" ><!-- 일일근태내용--><%=g.getMessage("LABEL.F.F43.0002")%>(<%=WebUtil.printDate(titleData.BEGDA)%>~<%=WebUtil.printDate(titleData.ENDDA)%>)</th>
                </tr>

                <tr>
                  <th ><%= titleData.D1  %></th>
                  <th ><%= titleData.D2  %></th>
                  <th ><%= titleData.D3  %></th>
                  <th ><%= titleData.D4  %></th>
                  <th ><%= titleData.D5  %></th>
                  <th ><%= titleData.D6  %></th>
                  <th ><%= titleData.D7  %></th>
                  <th ><%= titleData.D8  %></th>
                  <th ><%= titleData.D9  %></th>
                  <th ><%= titleData.D10 %></th>
                  <th ><%= titleData.D11 %></th>
                  <th ><%= titleData.D12 %></th>
                  <th ><%= titleData.D13 %></th>
                  <th ><%= titleData.D14 %></th>
                  <th ><%= titleData.D15 %></th>
                  <th ><%= titleData.D16 %></th>
                  <th ><%= titleData.D17 %></th>
                  <th ><%= titleData.D18 %></th>
                  <th ><%= titleData.D19 %></th>
                  <th ><%= titleData.D20 %></th>
                  <th ><%= titleData.D21 %></th>
                  <th ><%= titleData.D22 %></th>
                  <th ><%= titleData.D23 %></th>
                  <th ><%= titleData.D24 %></th>
                  <th ><%= titleData.D25 %></th>
                  <th ><%= titleData.D26 %></th>
                  <th ><%= titleData.D27 %></th>
                  <th ><%= titleData.D28 %></th>
                  <%= titleData.D29.equals("00") ? "" : "<th>"+titleData.D29+"</td>" %>
                  <%= titleData.D30.equals("00") ? "" : "<th>"+titleData.D30+"</td>" %>
                  <%= titleData.D31.equals("00") ? "" : "<th class=lastCol>"+titleData.D31+"</td>" %>
                </tr>
              </thead>
	<%
	                String preEmpNo = "";
	                int cnt = 0;
	                for( int i = j; i < F43DeptDayData_vt.size(); i++ ){
	                    F43DeptDayDataWorkConditionData data = (F43DeptDayDataWorkConditionData)F43DeptDayData_vt.get(i);
	                    String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

	                    String tr_class = "";

	                    if(i%2 == 0){
	                        tr_class="oddRow";
	                    }else{
	                        tr_class="";
	                    }

	                    if( data.ORGEH.equals(deptData.ORGEH) ){
	                        cnt++;
	%>
            <tr class="<%=tr_class%>">
              <td ><%=cnt%>&nbsp;&nbsp;</td>
              <td class="align_left" nowrap> <%=data.ENAME%></td>
              <td ><%=data.PERNR%></td>
              <td ><%=WebUtil.printNumFormat(data.REMA_HUGA,1)%></td>
              <td ><%=WebUtil.printNumFormat(data.REMA_RWHUGA,1)%></td>
              <td ><%=data.D1 %></td>
              <td ><%=data.D2 %></td>
              <td ><%=data.D3 %></td>
              <td ><%=data.D4 %></td>
              <td ><%=data.D5 %></td>
              <td ><%=data.D6 %></td>
              <td ><%=data.D7 %></td>
              <td ><%=data.D8 %></td>
              <td ><%=data.D9 %></td>
              <td ><%=data.D10%></td>
              <td ><%=data.D11%></td>
              <td ><%=data.D12%></td>
              <td ><%=data.D13%></td>
              <td ><%=data.D14%></td>
              <td ><%=data.D15%></td>
              <td ><%=data.D16%></td>
              <td ><%=data.D17%></td>
              <td ><%=data.D18%></td>
              <td ><%=data.D19%></td>
              <td ><%=data.D20%></td>
              <td ><%=data.D21%></td>
              <td ><%=data.D22%></td>
              <td ><%=data.D23%></td>
              <td ><%=data.D24%></td>
              <td ><%=data.D25%></td>
              <td ><%=data.D26%></td>
              <td ><%=data.D27%></td>
              <td ><%=data.D28%></td>
              <%= titleData.D29.equals("00") ? "" : "<td>"+data.D29+"</td>" %>
              <%= titleData.D30.equals("00") ? "" : "<td>"+data.D30+"</td>" %>
              <%= titleData.D31.equals("00") ? "" : "<td class=lastCol>"+data.D31+"</td>" %>
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

    <h2 class="subtitle"><!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%></h2>

	<div class="listArea">
		<div class="table">
			<table class="listTable">
				<colgroup>
					<col width="16%" />
					<col width="42%" />
					<col width="42%" />
	<!-- 				<col width="10%" /> -->
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
	<!-- 				<td class="lastCol" > -->
	<%--                    	O:<spring:message code="LABEL.D.D40.0142"/><!-- 지각 --><br/> --%>
	<%-- 					P:<spring:message code="LABEL.D.D40.0143"/><!-- 조퇴 --><br/> --%>
	<%-- 					Q:<spring:message code="LABEL.D.D40.0144"/><!-- 외출 --> --%>
	<!-- 				</td> -->
				</tr>
				<tr>
					<td class="align_center"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></td>
					<td>&nbsp;</td>
					<td style="text-align: left; padding-left: 20px;">
	                   	A:<spring:message code="LABEL.D.D40.0145"/><!-- 교육(근무시간내)--> B:<spring:message code="LABEL.D.D40.0146"/><!-- 출장 -->
					</td>
					<td class="lastCol">&nbsp;</td>
				</tr>
				<tr class="oddRow">
					<td class="align_center"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></td>
					<td style="text-align: left; padding-left: 20px;">
	                   	OA:<spring:message code="LABEL.D.D40.0147"/><!-- 휴일특근 --> OC:<spring:message code="LABEL.D.D40.0148"/><!-- 명절특근 --> OE:<spring:message code="LABEL.D.D40.0149"/><!-- 휴일연장 --> OF:<spring:message code="LABEL.D.D40.0150"/><!-- 연장근무 --><br/>
						OG:<spring:message code="LABEL.D.D40.0151"/><!-- 야간근로 -->
					</td>
					<td class="lastCol">&nbsp;</td>
	<!-- 				<td>&nbsp;</td> -->
				</tr>
				<tr>
					<td class="align_center"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></td>
					<td style="text-align: left; padding-left: 20px;">
	                   	EA:<spring:message code="LABEL.D.D40.0152"/><!-- 향군(근무시간외)--> EB:<spring:message code="LABEL.D.D40.0153"/><!-- 교육(근무시간외)-->
					</td>
					<td class="lastCol">&nbsp;</td>
	<!-- 				<td>&nbsp;</td> -->
				</tr>
			</table>
		</div>
	</div>

<%
//    }else{
%>
<!--<table width="780" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr align="center">
    <td  class="td04" align="center" height="25" >해당하는 데이터가 존재하지 않습니다.</td>
  </tr>
</table>-->
<%
//    } //end if...
%>
</div>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

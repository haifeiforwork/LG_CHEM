<%/******************************************************************************/
/*                                                                             	*/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                       	 		*/
/*   Program Name : 월간 근태 집계표                                            		*/
/*   Program ID   : F42DeptMonthWorkCondition.jsp                               */
/*   Description  : 부서별 월간 근태 집계표 조회를 위한 jsp 파일                		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2005-02-17 유용원                                           		*/
/*   Update       : 2011-10-25  ※CSR ID:C20111025_86242   모성보호휴가 유형추가 :0190 */
/*   		      : 2018-07-19  성환희 [Worktime52] 잔여보상휴가, 보상휴가 필드 추가 */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
	//암호화 추가
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
    String searchDay    = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));   //대상년월
    String year      = "";
    String month     = "";
    Vector F42DeptMonthWorkCondition_vt = (Vector)request.getAttribute("F42DeptMonthWorkCondition_vt");
    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
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
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV?sMenuCode=<%=sMenuCode%>";
    frm.target = "_self";
    frm.submit();
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.hdn_excel.value = "ED";
    frm.action =  "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV?sMenuCode=<%=sMenuCode%>";
    frm.target = "hidden";
    frm.submit();
}

//집계표
function go_Rotationprint(){
	var t_year = document.form1.year.value;
	var t_month = document.form1.month.value;

    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1050,height=662,left=0,top=2");
    document.form1.target = "essPrintWindow";
    document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_rotation.jsp?hdn_deptId=<%=deptId %>&hdn_excel=print&year1="+t_year+"&month1="+t_month+"&checkYn="+document.form1.chck_yeno.value ;

    document.form1.method = "post";
    //alert(document.form1.action);
    document.form1.submit();
}

function zocrsn_get() {
    frm = document.form1;
    frm.year1.value  = frm.year.options[frm.year.selectedIndex].text;
    frm.month1.value = frm.month.options[frm.month.selectedIndex].text;
    frm.searchDay_bf.value = "<%=searchDay%>";
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F42DeptMonthWorkConditionSV?sMenuCode=<%=sMenuCode%>";
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
        <jsp:param name="click" value="Y"/>
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
//    if ( F42DeptMonthWorkCondition_vt != null && F42DeptMonthWorkCondition_vt.size() > 0 ) {
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
	            <img src="<%= WebUtil.ImageURL %>sshr/brdr_buttons.gif"  />
	            <ul class="btn_mdl displayInline">
	                <li><a class="unloading" href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
	                <li><a href="javascript:go_Rotationprint();"><span><!-- 인쇄하기 --><%=g.getMessage("LABEL.F.F42.0002")%></span></a></li>
	            </ul>

    		</div>

<%
        String tempDept = "";
        for( int j = 0; j < F42DeptMonthWorkCondition_vt.size(); j++ ){
            F42DeptMonthWorkConditionData deptData = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(j);

            //하위부서를 선택했을 경우 부서 비교.
            if( !deptData.ORGEH.equals(tempDept) ){
%>

<h2 class="subtitle"><%=g.getMessage("LABEL.F.F41.0002")%> : <%=deptData.STEXT%></h2>
    <div class="listArea">
        <div class="table">
            <table class="listTable">
            <thead>
                <tr>
                  <th rowspan="3"><!-- 성명--><%=g.getMessage("LABEL.F.F42.0003")%></th>
                  <th rowspan="3"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
                  <th rowspan="3"><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></th>
                  <th rowspan="3"><!-- 잔여보상--><%=g.getMessage("LABEL.F.F42.0087")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th colspan="23" class="lastCol"><!-- 근태집계--><%=g.getMessage("LABEL.F.F42.0005")%></th>
                </tr>
                <tr>
                  <th colspan="11"><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></th>
                  <th colspan="2"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></th>
                  <th colspan="6"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></th>
                  <th colspan="2"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></th>
                  <th colspan="2" class="lastCol"><!-- 공수--><%=g.getMessage("LABEL.F.F42.0010")%></th>
                </tr>
                <tr>
                  <th><!-- 연차--><%=g.getMessage("LABEL.F.F41.0011")%></th>
                  <th><!-- 보상--><%=g.getMessage("LABEL.F.F42.0088")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 경조--><%=g.getMessage("LABEL.F.F42.0012")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 하계--><%=g.getMessage("LABEL.F.F42.0013")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 보건--><%=g.getMessage("LABEL.F.F42.0014")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 모성--><%=g.getMessage("LABEL.F.F42.0015")%><br/><!--보호--><%=g.getMessage("LABEL.F.F42.0017")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 공가--><%=g.getMessage("LABEL.F.F42.0016")%></th>
                  <th><!-- 결근--><%=g.getMessage("LABEL.F.F42.0018")%></th>
                  <th><!-- 지각--><%=g.getMessage("LABEL.F.F42.0019")%></th>
                  <th><!-- 조퇴--><%=g.getMessage("LABEL.F.F42.0020")%></th>
                  <th><!-- 외출--><%=g.getMessage("LABEL.F.F42.0021")%></th>
<%--                   <th><!-- 무노동--><%=g.getMessage("LABEL.F.F42.0022")%><br/><!-- 무임금--><%=g.getMessage("LABEL.F.F42.0023")%> </th> --%>
                  <th><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%></th>
                  <th><!-- 출장--><%=g.getMessage("LABEL.F.F42.0025")%></th>
                  <th><!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%></th>
<%--                   <th><!-- 토요--><%=g.getMessage("LABEL.F.F42.0028")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%></th> --%>
                  <th><!-- 명절--><%=g.getMessage("LABEL.F.F42.0029")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%><br /> </th>
<%--                   <th><!-- 명절--><%=g.getMessage("LABEL.F.F42.0029")%><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%><br><!-- (토)--><%=g.getMessage("LABEL.F.F42.0030")%></th> --%>
                  <th><!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%></th>
                  <th><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></th>
                  <th><!--야간--><%=g.getMessage("LABEL.F.F42.0033")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></th>
                  <th><!-- 당직--><%=g.getMessage("LABEL.F.F42.0034")%></th>
                  <th><!-- 항군--><%=g.getMessage("LABEL.F.F42.0035")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%> </th>
                  <th><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%> </th>
                  <th><!-- 금액--><%=g.getMessage("LABEL.F.F42.0037")%></th>
                  <th class="lastCol"><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></th>
                </tr>
			</thead>
<%
                for( int i = j; i < F42DeptMonthWorkCondition_vt.size(); i++ ){
                    F42DeptMonthWorkConditionData data = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(i);
                    String PERNR =  AESgenerUtil.encryptAES(data.PERNR,request); //암호화를 위해

                    String tr_class = "";
                    String td_class ="";

                    if(i%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }

                    //합계부분에 명수 보여주는 부분.
                    if (data.ENAME.equals("TOTAL")) {
                        for (int h = 0; h < 8; h++) {
                            if( !data.PERNR.substring(h, h+1).equals("0") ){
                                data.PERNR = "( "+ data.PERNR.substring(h, 8) + " )"+g.getMessage("LABEL.F.F42.0058");
                                break;
                            }
                        }
                    }
                    if (data.ENAME.equals("TOTAL")) {
                    	td_class ="td11";
                    }

%>
                <tr class="<%=tr_class%>">
                  <td nowrap class="<%=td_class%>"><%=data.ENAME    %></td>
                  <td class="<%=td_class%>"><%=data.PERNR    %></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.REMA_HUGA,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.REMA_RWHUGA,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HUGA     ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.RWHUGA   ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.KHUGA    ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HHUGA    ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.BHUG     ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.MHUG     ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.GONGA    ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.KYULKN   ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.JIGAK    ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.JOTAE    ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.WECHUL   ,1)%></td>
<%--                   <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.MUNO     ,1)%></td> --%>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.GOYUK    ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.CHULJANG ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HTKGUN   ,1)%></td>
<%--                   <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.TTKGUN   ,1)%></td> --%>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.MTKGUN   ,1)%></td>
<%--                   <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.MTKGUN_T ,1)%></td> --%>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HYUNJANG ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.YUNJANG  ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.YAGAN    ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.DANGJIC  ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HYANGUN  ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.KOYUK    ,1)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.KONGSU   ,1)%></td>
                  <td class="lastCol  <%=td_class%>"><%=WebUtil.printNumFormat(data.KONGSU_HOUR,1)%></td>
                </tr>
<%                  //마자막 합계 데이터 일 경우.
                    if (data.ENAME.equals("TOTAL")) {
                        break;
                    }
                } //end for...
%>
            </table>
        </div>

    </div>
<%
                //부서코드 비교를 위한 값.
                tempDept = deptData.ORGEH;
            }//end if
        }//end for
%>
        <div class="commentsMoreThan2">
            <div><%=g.getMessage("LABEL.F.F42.0039")%></div>
        </div>
    <h2 class="subtitle"><!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%></h2>

	<div class="listArea">
		<div class="table">
			<table class="listTable">
			   <thead>
				<tr>
		            <th colspan="2"><!-- 근태유형--><%=g.getMessage("LABEL.F.F42.0041")%> </th>
		            <th><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0084")%> </th>
		            <th><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%> </th>
		            <th><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%> </th>
		            <th class="lastCol"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%> </th>
				</tr>
				</thead>
		          <tr class="oddRow">
		            <td class="align_center" width="40" rowspan="3" style="background:#fff;"><!-- 단위--><%=g.getMessage("LABEL.F.F42.0042")%> </td>
		            <td class="align_center" width="40" ><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%> </td>
		            <td><!-- 시간공가, 휴일비근무, 비근무<br>모성보호휴가 --><%=g.getMessage("LABEL.F.F42.0043")%></td>
		            <td class="align_center" rowspan="3"  style="background:#fff;"><!-- 교육, 출장 --><%=g.getMessage("LABEL.F.F42.0044")%></td>
		            <td><!-- 휴일특근, 토요특근, 명절특근, 명절특근(토), <br>
		              휴일연장,연장근로, 야간근로, 야간근로(명절) --><%=g.getMessage("LABEL.F.F42.0045")%> </td>
		            <td class="lastCol"><!-- 향군(근무시간외),<br />
		              교육(근무시간외) --> <%=g.getMessage("LABEL.F.F42.0046")%></td>
		          </tr>
		          <tr>
		            <td class="align_center"><!-- 일수 --><%=g.getMessage("LABEL.F.F42.0047")%></td>
		            <td><!-- 반일휴가(전반/후반), 토요휴가, 전일휴가, 보상휴가,<br>
		              경조휴가, 하계휴가,보건휴가, 출산전후휴가,<br>전일공가, 유급결근, 무급결근, 전일공가 --><%=g.getMessage("LABEL.F.F42.0048")%></td>
		            <td>&nbsp;</td>
		            <td class="lastCol">&nbsp;</td>
		          </tr>
		          <tr class="oddRow">
		            <td class="align_center"><!-- 횟수 --><%=g.getMessage("LABEL.F.F42.0049")%></td>
		            <td><!-- 지각, 조퇴, 외출 --><%=g.getMessage("LABEL.F.F42.0050")%></td>
		            <td>&nbsp;</td>
		            <td class="lastCol">&nbsp;</td>
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
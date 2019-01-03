<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                          */
/*   1Depth Name    : Application                                                                                                                   */
/*   2Depth Name    : Time Management                                                                                                           */
/*   Program Name   : Time Sheet                                                                                                                */
/*   Program ID         : D07TimeSheetBuild.jsp                                                                                                     */
/*   Description        : Time Sheet 신청을 하는 화면 (USA - LG CPI(G400))                                                                 */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-10-11 jungin @v1.0 LGCPI Time Sheet 신규 개발                                                            */
/*   Update             : 2011-02-11 jungin @v1.1 [C20110124_13389] 결재요청 취소(Cancle Application) 추가.                 */
/*                          :                                                                대리신청 사원검색 오류 수정.                                   */
/*              : 2013-02-07 WBS 직접입력 불가처리                  */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>


<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D01OT.*" %>
<%@ page import="hris.D.D07TimeSheet.*" %>
<%@ page import="hris.D.D07TimeSheet.rfc.*" %>
<%@ page import="hris.common.approval.ApprovalHeader" %>


<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>
<%


    String jobid            = (String)request.getAttribute("jobid");

    //String message    = (String)request.getAttribute("message");

    String PERNR = (String)request.getAttribute("PERNR");
    String E_BUKRS = (String)request.getAttribute("E_BUKRS");

    Vector D07TimeSheetDeatilDataUsa_vt = null;
    Vector D07TimeSheetSummaryDataUsa_vt = null;
    D07TimeSheetDetailDataUsa data = null;

    D07TimeSheetDeatilDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetDeatilDataUsa_vt");
    D07TimeSheetSummaryDataUsa_vt = (Vector)request.getAttribute("D07TimeSheetSummaryDataUsa_vt");
    String message = (String)request.getAttribute("E_MESSAGE");
    String E_BEGDA = (String)request.getAttribute("E_BEGDA");
    String E_ENDDA = (String)request.getAttribute("E_ENDDA");

    String PAYDR = (String)request.getAttribute("E_PAYDRX");


    String paging = (String)request.getAttribute("page");

    //PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    String rowCount =null;
    try {
        pu = new PageUtil(D07TimeSheetDeatilDataUsa_vt.size(), paging , 10, 10);
        rowCount =pu.toRow() - pu.formRow()+"";
        Logger.debug.println(this, "page : " + paging);
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }



%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />
<c:set var="jobid" value="<%=jobid%>" />
<c:set var="message" value="<%= message%>" />
<c:set var="PERNR" value="<%=PERNR %>" />
<c:set var="E_BUKRS" value="<%=E_BUKRS %>" />
<c:set var="E_ENDDA" value="<%=E_ENDDA %>" />
<c:set var="E_BEGDA" value="<%=E_BEGDA %>" />
<c:set var="PAYDR" value="<%=PAYDR %>" />
<c:set var="paging" value="<%=paging %>" />
<c:set var="pu" value="<%=pu %>" />
<c:set var="rowCount" value="<%=rowCount %>" />





<tags:layout css="ui_library_approval.css">
    <tags-approval:request-layout titlePrefix="COMMON.MENU.ESS_PT_TIME_SHEET" >


        <!-- 상단 입력 테이블 시작-->

                <tags:script>
                    <script>

// msg 를 보여준다.
function msg() {

}

function init() {
	var frm = document.form1;

    <c:if  test="${not empty  approverData.AINF_SEQN }">
 			$(".-request-button").hide();
    </c:if>
   <c:if test="${isUpdate}">
  	 	bt03.style.visibility = "hidden";
   		$(".-request-button").show();
   </c:if>



<c:if  test="${iframeBuildYn ne 'true'}">
	$("#btn_pre").hide();
	$("#btn_next").hide();
</c:if>


   <c:if  test="${ approverData.APPR_STAT=='A' and  not empty approverData.AINF_SEQN}">
	$(".-request-button").hide();

	frm.TBEGDA.disabled = true;
	frm.TENDDA.disabled = true;
	bt02.style.visibility = "hidden";
	bt03.style.visibility = "hidden";
   </c:if>

}

// 신청 (Application)
// 날짜 변경해서 보낸다.
function doSubmit() {

    // 결재자 유무 체크.   @v1.1
    if (check_empNo()) {
      return;
    }

    var vObj = document.form1;
    objNum = document.getElementsByName("chkCode").length;

    vObj.TBEGDA.value = removePoint(vObj.TBEGDA.value);
    vObj.TENDDA.value = removePoint(vObj.TENDDA.value);

//     buttonDisabled();
    vObj.rowCount.value = objNum;
    vObj.jobid.value = "create";
    vObj.target = "_self";
    vObj.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV";
    vObj.method = "post";
    vObj.submit();
}

// 결재요청 취소 (Cancel Application)
function doCancelApp() {
    var vObj = document.form1;

    vObj.TBEGDA.value = removePoint(vObj.TBEGDA.value);
    vObj.TENDDA.value = removePoint(vObj.TENDDA.value);

    if (confirm("Are you sure to cancel?")) {
        //buttonDisabled();
        vObj.jobid.value = "cancle";
        vObj.target = "_self";
        vObj.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV";
        vObj.method = "post";
        vObj.submit();
    }
}

// 임시저장 (Save)
// 날짜 변경해서 보낸다.
function doSave() {

    var vObj = document.form1;
    objNum = document.getElementsByName("chkCode").length;

    vObj.TBEGDA.value = removePoint(vObj.TBEGDA.value);
    vObj.TENDDA.value = removePoint(vObj.TENDDA.value);

  //  buttonDisabled();
    vObj.rowCount.value = objNum;
    vObj.jobid.value = "save";
    vObj.target = "_self";
    vObj.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV";
    vObj.method = "post";
    vObj.submit();
}

function check_Data(){
    var vObj = document.form1;
    objNum = document.getElementsByName("chkCode").length;

    if (objNum > 1) {
        for (i = 0 ; i < objNum ; i++) {
            if (vObj.chkCode[i].checked) {
                //  필수 필드의 형식 체크
                if (vObj.WKHRS[i].value == "") {
                    //alert("Please input Hours.");
                    alert("<spring:message code='MSG.D.D07.0001'/>");
                    vObj.WKHRS[i].focus();
                    return;
                }
                if (vObj.POSID[i].value == "") {
                    //alert("Please input WBS.");
                    alert("<spring:message code='MSG.D.D07.0002'/>");
                    vObj.POSID[i].focus();
                    return;
                }
            }
        }
    } else {

    }
}

var flag = 0 ;
function EnterCheck2() {
    if (event.keyCode == 13) {
        flag = 1;
        f_dayTotSum();
    }
}

function doPayDateSearch(i_paydr, i_lcldt) {
    var frm = document.form1;

    // 필수 필드의 형식 체크
    /*if (frm.PAYDR.options[frm.PAYDR.selectedIndex].value == "") {
        alert("Please select Pay Date Range.");
        frm.PAYDR.focus();
        return;
    }*/

    frm.jobid.value = "first";
    frm.I_PAYDR.value = i_paydr;        // Week 유형 (Previous Week - PW / Next Week - NW)
    frm.I_LCLDT.value = i_lcldt;        // 현재 화면 Week의 시작일
    if(parent.resizeIframe){
    parent.setVal(i_paydr, i_lcldt);
    parent.resizeIframe(document.body.scrollHeight);
    }
    frm.target = "_self";
    frm.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV";
    frm.method = "post";
    frm.submit();
}

// Payroll Summary 팝업
function f_summary(i_paydr, i_lcldt) {
    var frm = document.form1;

    // 필수 필드의 형식 체크
    /*if (frm.PAYDR.options[frm.PAYDR.selectedIndex].value == "") {
        alert("Please select Pay Date Range.");
        frm.PAYDR.focus();
        return;
    }*/

    window.open('', 'payrollSummaryWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=550,height=470");

    frm.jobid.value = "summary";
    frm.I_PAYDR.value = i_paydr;        // 현재 화면 Week가 CW라고 지정
    frm.I_LCLDT.value = i_lcldt;        // 현재 화면 Week의 시작일

    frm.target = "payrollSummaryWindow";
    frm.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV";
    frm.method = "post";
    frm.submit();
}

// Printable View 팝업
function f_printableView(i_paydr, i_lcldt) {
    var frm = document.form1;

    // 필수 필드의 형식 체크
    /*if (frm.PAYDR.options[frm.PAYDR.selectedIndex].value == "") {
        alert("Please select Pay Date Range.");
        frm.PAYDR.focus();
        return;
    }*/

    frm.I_PAYDR.value = i_paydr;        // 현재 화면 Week가 CW라고 지정
    frm.I_LCLDT.value = i_lcldt;        // 현재 화면 Week의 시작일

    var ainf_seqn = frm.SUM_AINF_SEQN.value;
    var appr_stat = "X";


    window.open('', 'timeCardWindow', "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,width=780,height=650,left=0,top=2");

    frm.target = "timeCardWindow";
    frm.action = "${g.jsp}common/printFrame_TimeSheetUsa.jsp?I_PAYDR="+i_paydr+"&AINF_SEQN="+ainf_seqn+"&APPR_STAT="+appr_stat;
    frm.method = "post";
    frm.submit();
}


function f_wbsEnter() {
    if (event.keyCode == 13)  {
        f_wbsCheck();
    }
}

// WBS 체크
function f_wbsCheck() {
    // form Array index 0~
    var idx = getObj().parentElement.rowIndex - 1;

    var frm = document.form1;

    var posid = frm.POSID[idx].value;
    var pspnr = frm.PSPNR[idx].value;

    if (posid == "") {
        frm.POSID[idx].value = "";
        frm.PSPNR[idx].value = "00000000";
    } else {
        window.open("/web/D/D07TimeSheet/D07TimeSheetWBSPopUsa.jsp?rowIndex=" + idx + "&I_GUBUN=01" + "&I_VALUE=" + posid + "&POSID=" + posid + "&I_SEARCH=Y", "DeptPers","toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=677,height=500,left=100,top=100");

        if ( (posid != "" && pspnr == "") || (posid == "" && pspnr != "") ) {
            frm.POSID[idx].value = "";
            frm.PSPNR[idx].value = "";
            return;
        }
    }
}

// WBS 팝업
function f_popWBS() {
    // form Array index 0~
    var idx = getObj().parentElement.rowIndex - 1;
    window.open("/web/D/D07TimeSheet/D07TimeSheetWBSPopUsa.jsp?rowIndex="+idx,"DeptPers","toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=yes,width=677,height=500,left=100,top=100");
}

// Memo 팝업
function f_popMemo() {
    var frm = document.form1;

    // form Array index 0~
    var idx = getObj().parentElement.rowIndex - 1;
    var wtext = frm.WTEXT[idx].value;
    window.open("/web/D/D07TimeSheet/D07TimeSheetMemoPopUsa.jsp?rowIndex="+idx+"&wtext="+wtext,"DeptPers","toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=no,scrollbars=no,width=430,height=200,left=100,top=100");
}

/***************************************************
* New Row Add
*
* - gubun 1 : '+' images click added.
* - gubun 2 : checkBox check, 'insert' button click added.
*
* 1) dayTB      : 0 ~
* 2) chkCode    : 0 ~
* 3) chkValue   : 0 ~
***************************************************/

var fNum = 1;
var oldIdx = 0;
var newIdx = 0;

// 'dayTB' row index get. (0 ~)
function getObj() {
  var obj = window.event.srcElement;
    while (obj.tagName != "TD") {   // TD가 나올때까지의 Object추출
        obj = obj.parentElement;
    }
    return obj;
}

// checkBox checked.
function f_check() {

    var vObj = document.form1;
    objNum = document.getElementsByName("chkCode").length;

    var chkIdx = getObj().parentElement.rowIndex;

    if (oldIdx != 0) {
        if (vObj.chkCode[oldIdx-1].value != chkIdx) {
            vObj.chkCode[oldIdx-1].checked = false
        }
    }

    if (objNum > 1) {
        for (var i=0; i < objNum; i++) {
            if (vObj.chkCode[i].checked == true) {
                vObj.chkValue[chkIdx-1].value = chkIdx;
                vObj.chkCode[chkIdx-1].checked = true;
                oldIdx = chkIdx;
                newIdx = chkIdx + 1;
            } else {
                vObj.chkValue[i].value = "OFF";
                vObj.chkCode[i].checked = false;
            }
        }
    } else if (objNum == 1) {
        if (vObj.chkCode[0].checked == true) {
            vObj.chkValue[0].value = chkIdx;
            vObj.chkCode[0].checked = true;
            oldIdx = chkIdx;
            newIdx = chkIdx + 1;
        } else {
            vObj.chkValue[0].value = "OFF";
            vObj.chkCode[0].checked = false;
        }
    }
}

// insert
function f_insetRow() {

    var vObj = document.form1;
    objNum = document.getElementsByName("chkCode").length;

    if (objNum == 0 || oldIdx == 0) {
        if (objNum == 0) {
            vObj.PAYDR.value = "";
            vObj.PAYDR.focus();
        }
        //alert("Please select the day.");
        alert("<spring:message code='MSG.D.D07.0004'/>");
        return;
    } else {
        var weekDay = vObj.WEEKDAY_L[oldIdx-1].value;
        var wkdat = vObj.WKDAT[oldIdx-1].value;
        var hours = vObj.WKHRS[oldIdx-1].value;
        var atext = vObj.ATEXT[oldIdx-1].value;
        var kostl = vObj.KOSTL[oldIdx-1].value;
        var dytot = vObj.DYTOT[oldIdx-1].value;
        var begda = vObj.BEGDA[oldIdx-1].value;
        var ainf_seqn = vObj.I_AINF_SEQN[oldIdx-1].value;
    }
    f_inDayRow("2", weekDay, wkdat, hours, atext, kostl, dytot, begda, ainf_seqn);
}

// delete
function f_deleteRow() {

    var vObj = document.form1;
    objNum = document.getElementsByName("WEBFLAG").length;

    if (oldIdx == 0) {
        //alert("No rows to delete.");
        alert("<spring:message code='MSG.D.D07.0005'/>");
        return;
    } else {
        for (var i=0; i < objNum; i++) {
            if (vObj.WEBFLAG[oldIdx-1].value == "X") {
                //alert("Unable to delete rows.");
                alert("<spring:message code='MSG.D.D07.0006'/>");
                vObj.POSID[oldIdx-1].value="";
                vObj.chkCode[oldIdx-1].checked = false;
                return;
            } else {

                var hours = vObj.WKHRS[oldIdx-1].value;
                var dytot = vObj.DYTOT[oldIdx-1].value;

                dayTB.deleteRow(oldIdx);

                f_dayTotSum('2', oldIdx, hours, dytot);

                oldIdx = 0;
                return;
            }
        }
    }
}

function f_inDayRow(gubun, weekDay, wkdat, hours, atext, kostl, dytot, begda, ainf_seqn) {

    var vObj = document.form1;

    if (atext != "") {
        atextStyle = "style=\"text-align:left;padding-left:5;background-color:#F7F7F7;color:#F7F7F7;\"";
    } else {
        atextStyle = "style=\"text-align:left;padding-left:5;background-color:#F7F7F7;\"";
    }

    /*if (dytot != "") {
        dytot = "";
    }*/

    if (gubun == "1") {
        var idx = getObj().parentElement.rowIndex + 1;
        var newRow = dayTB.insertRow(idx);

    } else {
        var newRow = dayTB.insertRow(newIdx);
        vObj.chkCode[oldIdx-1].checked = false
    }
    //newRow.className = "borderRow";
    var cell1 = newRow.insertCell();
    var cell2 = newRow.insertCell();
    var cell3 = newRow.insertCell();
    var cell4 = newRow.insertCell();
    var cell5 = newRow.insertCell();
    var cell6 = newRow.insertCell();
    var cell7 = newRow.insertCell();
    var cell8 = newRow.insertCell();
    var cell9 = newRow.insertCell();
    var cell10 = newRow.insertCell();


    cell1.innerHTML =   "<tr >";
    cell1.innerHTML += "<td>";
    cell1.innerHTML     += "<input type=\"checkbox\" name=\"chkCode\" onClick=\"f_check();\">";
    cell1.innerHTML     += "<input type=\"hidden\" name=\"chkValue\" size=\"1\" value=\"OFF\">";
    cell1.innerHTML     += "<input type=\"hidden\" name=\"WEBFLAG\" size=\"1\" value=\"\">";
    cell1.innerHTML     += "</td>";

    cell2.innerHTML     =   "<td></td>";

    cell3.innerHTML     =   "<td>";
    cell3.innerHTML     += "<img src=\"/web/images/sshr/ico_action_add.png\" align=\"absmiddle\" border=\"0\" style=\"cursor:hand; vertical-align:middle;\" onclick=\"f_inDayRow('1', '"+weekDay+"', '"+wkdat+"', '"+hours+"', '"+atext+"', '"+kostl+"', '"+dytot+"', '"+begda+"', '"+ainf_seqn+"');\">&nbsp;&nbsp;";
    cell3.innerHTML     += "<input type=\"text\" name=\"WEEKDAY_L\" size=\"2\" value=\""+weekDay+"\" style=\"ime-mode:active;text-align:left;color:#FFFFFF;background-color:#FFFFFF;visibility:hidden\" readonly>";
    cell3.innerHTML     += "</td>";

    cell4.innerHTML     =   "<td>";
    cell4.innerHTML     += "<input type=\"text\" name=\"WKDAT\"  size=\"10\" value=\""+wkdat+"\" style=\"ime-mode:active;text-align:center;color:#FFFFFF;background-color:#FFFFFF;visibility:hidden\" readonly>";
    cell4.innerHTML     += "</td>";

    cell5.innerHTML =   "<td>";
    cell5.innerHTML     += "<input type=\"text\" name=\"WKHRS\" size=\"4\"  value=\"0.00\" style=\"text-align:right;padding:0px;padding-right:5px;padding-top:3px;height:16px\" onkeyup=\"onlyNumber(this);\" onKeyPress=\"EnterCheck2();\" onChange=\"f_dayTotSum('1', '', '', '');\">";
    cell5.innerHTML     += "</td>";

    cell6.innerHTML     =   "<td>";
    cell6.innerHTML     += "<input type=\"text\" name=\"DYTOT\" size=\"3\" value=\"0.00\" style=\"text-align:right;background-color:#F7F7F7\" readonly>";
    cell6.innerHTML     += "<input type=\"hidden\" name=\"DYTOT_T\" size=\"3\" value=\"\">";
    cell6.innerHTML     += "</td>";

    cell7.innerHTML     =   "<td>";
    cell7.innerHTML     += "<input type=\"text\" name=\"ATEXT\" size=\"13\" value=\""+atext+"\" "+atextStyle+" readonly>";
    cell7.innerHTML     += "</td>";

    cell8.innerHTML     =   "<td>";
    cell8.innerHTML     += "<input type=\"text\" name=\"KOSTL\" size=\"10\" value=\""+kostl+"\" style=\"text-align:left;padding-left:5;background-color:#F7F7F7;\" readonly>";
    cell8.innerHTML     += "</td>";

    cell9.innerHTML     =   "<td>";
    cell9.innerHTML     += "<input type=\"text\" name=\"POSID\" size=\"10\" value=\"\"  style=\"text-align:left;padding-left:5;background-color:#FFFFFF;\" readonly>&nbsp;";
    cell9.innerHTML     += "<img src=\"/web/images/ico_magnify.png\" align=\"absmiddle\" border=\"0\" style=\"cursor:hand; vertical-align:middle;\" onclick=\"f_popWBS();\" >";
    cell9.innerHTML     += "</td>";

    cell10.innerHTML =  "<td>";
    cell10.innerHTML += "<img src=\"/web/images/icon_memo.gif\" align=\"absmiddle\" width=\"16\" height=\"16\" border=\"0\" style=\"cursor:hand;\" onclick=\"f_popMemo();\">&nbsp;";
    cell10.innerHTML += "<span id=\"sp1\" style=\"display:none;\"><img src=\"/web/images/sshr/ico_action_check.png\" align=\"absmiddle\" width=\"16\" height=\"16\" border=\"0\"></span>";
    cell10.innerHTML += "</td>";

    cell10.innerHTML += "<input type=\"hidden\" name=\"BEGDA\" size=\"5\" value=\""+begda+"\">";
    cell10.innerHTML += "<input type=\"hidden\" name=\"I_AINF_SEQN\" size=\"5\" value=\""+ainf_seqn+"\">";
    cell10.innerHTML += "<input type=\"hidden\" name=\"AWART\" size=\"5\" value=\"\">";
    cell10.innerHTML += "<input type=\"hidden\" name=\"WTEXT\" size=\"5\" value=\"\">";
    cell10.innerHTML += "<input type=\"hidden\" name=\"PSPNR\" size=\"5\" value=\"\">";
    cell10.innerHTML += "<input type=\"hidden\" name=\"SEQNR\" size=\"5\" value=\"\">";
    cell10.innerHTML += "</tr>";

    //f_idx();
    oldIdx = 0;
}

// row Index get.
function f_idx() {
    var vObj = document.form1;
    objNum = document.getElementsByName("chkValue").length;

    if (objNum > 1) {
        for (i = 0; i < objNum; i++) {
            // 'dayTB' 테이블의 tr 인덱스에 맞추어 +1
            vObj.chkValue[i].value = "OFF";
        }
    } else {
        vObj.chkValue[0].value = 1;
    }
}

// 단순히 숫자와 '.'만을 체크한다.
function onlyNumber(obj) {
    var idx = getObj().parentElement.rowIndex;

    var vObj = document.form1;

    var resultVal = obj.value;
    var num="0123456789.";

    if (resultVal.length != 0) {
        for (var i=0; i < resultVal.length ;i++ ) {
            if (-1 == num.indexOf(resultVal.charAt(i))) {
                //alert("Please input number.");
                alert("<spring:message code='MSG.D.D07.0003'/>");

                obj.value = "";
                vObj.DYTOT[idx-1].value = "0.00";
                obj.focus();
                obj.select();
                return false;
            }
        }
    }
    return true;
}

// Hours 입력시에 인풋창 초기화
function f_wkhrsClick() {
    var idx = getObj().parentElement.rowIndex;

    var vObj = document.form1;
    vObj.WKHRS[idx-1].value = "";
}

// Hours 입력후에, Day Total을 계산
function f_dayTotSum(rowCount, idx, hValue, dValue) {

    if (rowCount == "1") {
        var rowIdx = getObj().parentElement.rowIndex;       // 현재 row
    } else {
        var rowIdx = idx;
    }

    var upperIdx = rowIdx - 1;                                      // 상위 row

    var vObj = document.form1;
    objNum = document.getElementsByName("WEEKDAY_L").length;

    var date = vObj.WKDAT[rowIdx-1].value;
    var hours = vObj.WKHRS[rowIdx-1].value;

    if (hours == null || hours == "") {
        vObj.WKHRS[rowIdx-1].value = "0.00";
        vObj.DYTOT[rowIdx-1].value = "";
    }

    if (rowCount == 1) {        // onChange시에,

        if (rowIdx != 1) {
            for (var i=0; i < objNum; i++) {

                var date1 = vObj.WKDAT[i].value;
                var hours1 = vObj.DYTOT[i].value;

                if (date == vObj.WKDAT[i].value) {

                    if (upperIdx != i) {
                        vObj.WKHRS[rowIdx-1].value = pointFormat(hours, 2);
                        vObj.DYTOT[rowIdx-1].value = pointFormat(Number(hours1) + Number(hours), 2);
                        vObj.DYTOT_T[rowIdx-1].value = pointFormat(Number(hours1) + Number(hours), 2);
                        vObj.DYTOT[i].value = "";
                    } else {
                        return;
                    }

                } else {
                    vObj.WKHRS[rowIdx-1].value = pointFormat(hours, 2);
                    vObj.DYTOT[rowIdx-1].value = pointFormat(hours, 2);
                    vObj.DYTOT_T[rowIdx-1].value = pointFormat(hours, 2);
                }
            }

        } else {
            vObj.WKHRS[rowIdx-1].value = pointFormat(hours, 2);
            vObj.DYTOT[rowIdx-1].value = pointFormat(hours, 2);
            vObj.DYTOT_T[rowIdx-1].value = pointFormat(hours, 2);
        }

    } else {        // delete row 후에,
        //alert(Number(dValue)-Number(hValue));
        //vObj.DYTOT[idx-2].value = pointFormat(Number(dValue)-Number(hValue), 2);
        //vObj.DYTOT_T[idx-2].value = pointFormat(Number(dValue)-Number(hValue), 2);
        //return;
    }

}

function reload() {
    frm = document.form1;
    frm.jobid.value = "first";
    //frm.PERNR.value = frm.I_DEPT.value;
    frm.action = "${g.servlet}hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV";
    frm.target = "";
    frm.submit();
}

$(function() {
	msg();
	init();
	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
});
</script>
</tags:script>


<input type="hidden" name="I_PAYDR" value="">
<input type="hidden" name="I_LCLDT" value="">
<input type="hidden" name="SUM_AINF_SEQN" value="${approverData.AINF_SEQN}">
<input type="hidden" name="APPR_STAT" value="">
<input type="hidden" name="iframeBuildYn" value="${iframeBuildYn}">


    <div class="tableInquiry">
       <table>
       	<colgroup>
       		<col width="15%" />
       		<col />
       	</colgroup>

         <tr style="line-height:0px ">
           <th><!--Pay Date Range --><spring:message code="LABEL.D.D07.0002"/></th>
           <td >
             <a class="inlineBtn" href="javascript:doPayDateSearch('PW', '${f:deleteStr(E_BEGDA,'.')}')"><span id="btn_pre"><!-- previous --><spring:message code="BUTTON.COMMON.PREVIOUS"/></span></a>
             <input type="text" name="TBEGDA" size="10" value="${f:printDate(E_BEGDA)}" readonly>
             ~
             <input type="text" name="TENDDA" size="10"  value="${f:printDate(E_ENDDA)}" readonly>
             <a class="inlineBtn" href="javascript:doPayDateSearch('NW','${f:deleteStr(E_BEGDA, '.')}' )"><span  id="btn_next"><!-- next --><spring:message code="BUTTON.COMMON.NEXT"/></span></a>
           </td>
         </tr>
       </table>
    </div>


    <!-- 리스트테이블 시작 -->
    <div class="listArea">
    	<div class="listTop">
    		<div class="buttonArea">
    			<ul class="btn_mdl">
    				<span id="bt02">
                    <li><a href="javascript:f_insetRow()"><span><!-- Insert --><spring:message code="BUTTON.COMMON.LINE.ADD"/></span></a></li>
                    <li><a href="javascript:f_deleteRow()"><span><!-- Delete --><spring:message code="BUTTON.COMMON.LINE.DELETE"/></span></a></li>
                    <img src="${g.image}sshr/brdr_buttons.gif" align="absmiddle" border="0">
                    </span>
    				<li><a href="javascript:f_summary('CW', '${f:deleteStr(E_BEGDA, '-')}');"><span><!-- Payroll Summary --><spring:message code="BUTTON.COMMON.PAYROLL"/></span></a></li>
    				<li><a href="javascript:f_printableView('CW', '${f:deleteStr(E_BEGDA, '-')}');"><span><!-- Printable View --><spring:message code="BUTTON.COMMON.PRINTVIEW"/></span></a></li>

    			</ul>
    		</div>
    		<div class="clear"></div>
    	</div>
        <div class="table">
            <table class="listTable"  id="dayTB">
              <thead>
                <tr>
                  <th><img src="${g.image}icon_check.gif" align="absmiddle" border="0">
                                                         <!-- <input type="checkbox" name="allchk" onClick="javascript:f_allChk(this.checked);"> --></th>
                  <th></th>
                  <th></th>
                  <th><!-- Date In --><spring:message code="LABEL.D.D07.0004"/></th>
                  <th><!--Hours --><spring:message code="LABEL.D.D07.0005"/></th>
                  <th><!--Daily Totals --><spring:message code="LABEL.D.D07.0006"/></th>
                  <th><!--A/A Type--><spring:message code="LABEL.D.D07.0007"/></th>
                  <th><!-- Cost Center --><spring:message code="LABEL.D.D07.0008"/></th>
                  <th><!--WBS --><spring:message code="LABEL.D.D07.0009"/></th>
                  <th class="lastCol"></th>
                </tr>
               </thead>
  				<c:forEach var="row" items="${D07TimeSheetDeatilDataUsa_vt}" varStatus="status" begin="${pu.from}" >
          		<c:if test="${ row.WEEKDAY_L ne 'Total'}">
          		<c:choose>
				<c:when  test="${row.APPR_STAT eq 'A'}">
					<c:set var="bgColor" value= "style=\"background-color:#d7dee4;font-size: 9pt; border:none;\""/>
					<c:set var="wkhrsClss" value= "class=\"input05\" style=\"text-align:right;padding-right:5;background-color:#d7dee4;\" readonly" />
					<c:set var="dayTotStyle" value= "style=\"text-align:right;background-color:#d7dee4;\"" />
					<c:set var="isStyle1" value= "style=\"text-align:left;padding-left:5;background-color:#d7dee4;\"" />
					<c:set var="isStyle2" value=  "style=\"text-align:left;padding-left:5;background-color:#d7dee4;\"" />
					<c:set var="readStyle" value= "readonly" />
									   <c:choose>
					    	<c:when  test="${row.WEEKDAY_L eq day}">
 							<c:set var="dayStyle" value= "style=\"ime-mode:active;text-align:left;color:#FFFFFF;background-color:#FFFFFF;visibility:hidden\"" />
							<c:set var="dateStyle" value="style=\"ime-mode:active;text-align:center;color:#FFFFFF;background-color:#FFFFFF;visibility:hidden\"" />

					   		</c:when>
					   		<c:otherwise>
    							<c:set var="dayStyle" value=  "style=\"ime-mode:active;text-align:left;\"" />
    							<c:set var="dateStyle" value= "style=\"ime-mode:active;text-align:center;\"" />
    						</c:otherwise>
    					</c:choose>
    				 <c:choose>
					    	<c:when  test="${empty row.WTEXT}">
    							<c:set var="wtextStyle" value=  "style=\"display:none;\"" />
					   		</c:when>
					   		<c:otherwise>
					   			<c:set var="wtextStyle" value=  "" />
    						</c:otherwise>
    				</c:choose>
    		</c:when>
			<c:otherwise>
				<c:set var="bgColor" value= "style=\"background-color:#FFFFFF;\""/>
				<c:set var="readStyle" value= "" />
				<c:set var="dayTotStyle" value="style=\"text-align:right;background-color:#F7F7F7;\"" />
				<c:set var="isStyle1" value="style=\"text-align:left;padding-left:5;background-color:#F7F7F7;\"" />
				<c:set var="isStyle2" value=  "style=\"text-align:left;padding-left:5;background-color:#FFFFFF;\""/>
					<c:choose>
	    				<c:when  test="${row.WEEKDAY_L eq day}">
							<c:set var="dayStyle" value= "style=\"ime-mode:active;text-align:left;color:#FFFFFF;background-color:#FFFFFF;visibility:hidden\"" />
							<c:set var="dateStyle" value="style=\"ime-mode:active;text-align:center;color:#FFFFFF;background-color:#FFFFFF;visibility:hidden\"" />
	   					</c:when>
	   					<c:otherwise>
							<c:set var="dayStyle" value=  "style=\"ime-mode:active;text-align:left;\"" />
							<c:set var="dateStyle" value=  "style=\"ime-mode:active;text-align:center;\"" />
						</c:otherwise>
					</c:choose>
    				 <c:choose>
				    	<c:when  test="${empty row.WTEXT}">
							<c:set var="wtextStyle" value=  "style=\"display:none;\"" />
				   		</c:when>
				   		<c:otherwise>
				   			<c:set var="wtextStyle" value=  "" />
							</c:otherwise>
						</c:choose>

    				 <c:choose>
				    	<c:when  test="${empty row.ATEXT}">
						<c:set var="wkhrsClss" value=  "style=\"text-align:right;padding:0px;padding-right:5px;padding-top:3px;height:16px\" " />
				   		</c:when>
				   		<c:otherwise>
				   			<c:set var="wkhrsClss" value=  " style=\"text-align:right;padding:0px;padding-right:5px;padding-top:3px;height:16px;background-color:#F7F7F7;\" readOnly" />
						</c:otherwise>
					</c:choose>
		</c:otherwise>
		</c:choose>
                  <tr><td ${bgColor }><input type="checkbox" name="chkCode" onClick="f_check();" <c:if test="${row.APPR_STAT eq 'A' }">  disabled="false"</c:if> ></td>
                  <td ${bgColor }></td>
                  <td ${ bgColor }>
                  <img src="${g.image}sshr/ico_action_add.png" align="absmiddle" border="0" <c:if test="${row.APPR_STAT ne 'A' }">  style="cursor:hand; vertical-align:middle;" onclick="f_inDayRow('1', '${ row.WEEKDAY_L}', '${f:printDate(row.WKDAT)}', '${ row.WKHRS}', '${ row.ATEXT}', '${ row.KOSTL}', '${f:printNumFormat(row.DYTOT, 2)}', '${f:deleteStr(row.BEGDA,'-')}', '${ row.AINF_SEQN }');"</c:if>>&nbsp;&nbsp;
                  <input type="text" name="WEEKDAY_L" size="2" value="${ row.WEEKDAY_L }"  ${ dayStyle }  "${ bgColor }" readonly></td>
                  <td ${ bgColor }><input type="text" name="WKDAT" size="10" value="${ f:printDate(row.WKDAT) }"  ${dateStyle} "${ bgColor  }" readonly></td>
				<td ${ bgColor}><input type="text" name="WKHRS" ${wkhrsClss}  size="4"  value="${f:printNumFormat(row.WKHRS, 2)}"  ${readStyle}  onkeyup="onlyNumber(this);" onKeyPress="EnterCheck2();" onChange="f_dayTotSum('1', '', '', '');"></td>
                  <td ${ bgColor}><input type="text" name="DYTOT"  size="3" value="${f:printNumFormat(row.DYTOT, 2)}"  ${dayTotStyle } readonly></td>

                  <td ${ bgColor }><input type="text" name="ATEXT" size="13" value= "${ row.ATEXT}"  ${ isStyle1} readonly></td>
                  <td ${ bgColor }><input type="text" name="KOSTL" size="10" value= "${ row.KOSTL}"  ${ isStyle1 } readonly></td>
                  <td ${ bgColor }>
                        <input type="hidden" name="DYTOT_T"  size="3">
                 <input type="hidden" name="chkValue" size="1"  value=<c:if test="${row.APPR_STAT eq 'A' }">  "APP"</c:if><c:if test="${row.APPR_STAT ne 'A' }">  "NOTAPP"</c:if> >
                  <input type="hidden" name="WEBFLAG" size="1" value="${row.WEBFLAG}">
                  <input type="hidden" name="DYTOT_T"  size="3">
                  <input type="hidden" name="BEGDA" size="5" value="${approvalHeader.RQDAT}">
                  <input type="hidden" name="PSPNR" size="5" value="${row.PSPNR}">
                  <input type="hidden" name="I_AINF_SEQN" size="5" value="${row.AINF_SEQN}">
                  <input type="hidden" name="AWART" size="5" value="${row.AWART}">
                  <input type="hidden" name="WTEXT" size="5" value="${row.WTEXT}">
                  <input type="hidden" name="SEQNR" size="5" value="${row.SEQNR}">
                  	<input type="text" name="POSID" size="10" value="${ row.POSID }" ${ isStyle2 } ${ readStyle } readonly onChange="f_wbsCheck();" onKeyPress="f_wbsEnter();">&nbsp;
					 <img src="${g.image}sshr/ico_magnify.png" align="absmiddle" border="0"  <c:if test="${row.APPR_STAT ne 'A' }"> style="cursor:hand; vertical-align:middle;" onclick="f_popWBS();" </c:if>}></td>
                  <td ${ bgColor }><img src="${g.image}icon_memo.gif" align="absmiddle" width="16" height="16" border="0" style="cursor:hand;" onclick="f_popMemo();">&nbsp;
                  <span id="sp1" ${ wtextStyle }><img src="${g.image}sshr/ico_action_check.png" align="absmiddle" border="0" style="margin-top:0px;"></span></td></tr>


      			<c:set var="day" value="${row.WEEKDAY_L}"/>
    			<c:set var="date" value="${row.WKDAT}"/>


                 </c:if>
                 </c:forEach>
                  <c:if test="${f:getSize(D07TimeSheetDeatilDataUsa_vt) <= pu.from}">
                    <tags:table-row-nodata list="${D07TimeSheetDeatilDataUsa_vt}" col="10" />
                </c:if>
            </table>

            </div>
        </div>
    <!-- 리스트테이블 끝-->
    <div class="buttonArea">
        <ul class="btn_crud">
            	<span id="bt03">
            		<li><a class="darken" href="javascript:doSave()" ><span><!--Save --><spring:message code="BUTTON.COMMON.SAVE"/></span></a></li>
            	</span>

                 <span id="bt04">
                 <c:if  test="${not empty approverData.AINF_SEQN and approverData.APPR_STAT ne 'A'}">
            		<li><a class="darken" href="javascript:doCancelApp()" ><span><!--cancel --><spring:message code="BUTTON.COMMON.CANCEL"/></span></a></li>
            	  </c:if>
            	</span>
        </ul>
    </div>
   <input type="hidden" name="rowCount" value = "${rowCount }">
<input type="hidden" name="jobid2" value="">
<input type="hidden" name="SUM_BEGDA" size="5" value="${approvalHeader.RQDAT}">


	</tags-approval:request-layout>

	<%-- 하단 추가 부분 - 필요시 --%>
	<div class="commentsMoreThan2">
	</div>

</tags:layout>

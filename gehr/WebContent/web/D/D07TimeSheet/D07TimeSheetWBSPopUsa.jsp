<%/***************************************************************************************/
/*   System Name    : g-HR                                                                                                                          */
/*   1Depth Name    : Application                                                                                                                   */
/*   2Depth Name    : Time Management                                                                                                           */
/*   Program Name   : Time Sheet                                                                                                                */
/*   Program ID         : D07TimeSheetWBSPop.jsp                                                                                                */
/*   Description        : Time Sheet 신청시 WBS 팝업 조회 화면 (USA - LG CPI(G400))                                                      */
/*   Note               :                                                                                                                                   */
/*   Creation           : 2010-10-11 jungin @v1.0 LG CPI Time Sheet 신규 개발                                                           */
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.D.D07TimeSheet.*" %>
<%@ page import="hris.D.D07TimeSheet.rfc.D07TimeSheetWBSRFCUsa "%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");

    int rowIndex = Integer.parseInt(request.getParameter("rowIndex"));
    //

    String I_GUBUN = request.getParameter("I_GUBUN");
    String I_VALUE = request.getParameter("I_VALUE");
    String I_SEARCH = request.getParameter("I_SEARCH");

    //String I_chkACTIVE = request.getParameter("chkACTVE");
    String I_chkEFFCTVE = request.getParameter("chkEFFCTVE");

    String I_DATLO = DataUtil.getCurrentDate();
    String I_BUKRS = user.companyCode;
    String I_POSID = request.getParameter("POSID");
    String I_POST1 = request.getParameter("POST1");

    boolean isFirst = true;
    Vector D07TimeSheetWBSDataUsa_vt = new Vector();

    String count = request.getParameter("count");
    long l_count = 0;
    if (count != null) {
        l_count = Long.parseLong(count);
    }

    // page 처리
    String paging = request.getParameter("page");

    String PERNR = request.getParameter("PERNR");
    if (PERNR == null || PERNR.equals("")) {
        PERNR = user.empNo;
    } // end if

    String i_dept = PERNR;

    if (paging == null || paging.equals("")) {

        try {
            D07TimeSheetWBSRFCUsa rfc = new D07TimeSheetWBSRFCUsa();

            D07TimeSheetWBSDataUsa_vt = rfc.getWbsList(I_DATLO, I_BUKRS, I_POSID, I_POST1);
            l_count = D07TimeSheetWBSDataUsa_vt.size();
        } catch(Exception ex) {
            D07TimeSheetWBSDataUsa_vt = null;
        }

        isFirst = false;

    } else if (paging != null ) {

        isFirst = false;

        for (int i = 0 ; i < l_count ; i++) {
            D07TimeSheetWBSDataUsa wbsData = new D07TimeSheetWBSDataUsa();

            wbsData.PSPNR = (request.getParameter("PSPNR"+i));
            wbsData.POSID = (request.getParameter("POSID"+i));
            wbsData.POST1 = (request.getParameter("POST1"+i));
            wbsData.ERDAT= (request.getParameter("ERDAT"+i));

            D07TimeSheetWBSDataUsa_vt.addElement(wbsData);
        }
    }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    try {
        pu = new PageUtil(D07TimeSheetWBSDataUsa_vt.size(), paging , 10, 10);
        //
    } catch (Exception ex) {

    }
%>

<jsp:include page="/include/header.jsp"/>

<SCRIPT LANGUAGE="JavaScript">
<!--
function init() {
<%
    if (D07TimeSheetWBSDataUsa_vt != null) {
       if (D07TimeSheetWBSDataUsa_vt.size() == 0) {
%>
        deleteWBS();
<%
        }
    }
%>
}

function f_wbsSearch() {
    var frm = document.form1;

    var i_gubun = frm.I_GUBUN.value;

    if (i_gubun == null || i_gubun == ""){
        //alert("Please select Column.");
        alert("<spring:message code='MSG.D.D07.0007'/>");
        frm.I_GUBUN.focus();
        return;
    }

    // ID Search
    if (i_gubun == "01") {

        val = frm.I_VALUE.value;
        val = rtrim(ltrim(val));

        if (val == "") {
            //alert("Please input ID.");
            alert("<spring:message code='MSG.D.D07.0008'/>");
            frm.I_VALUE.focus();
            return;
        } else {
            frm.jobid.value = "id";
            frm.POSID.value = val;
        } // end if

    // Description Search
    } else if (i_gubun == "02") {

        val1 = frm.I_VALUE.value;
        val1 = rtrim(ltrim(val1));

        if (val1 == "") {
            //alert("Please input Description.");
            alert("<spring:message code='MSG.D.D07.0009'/>");
            frm.I_VALUE.focus();
            return;
        } else {
            if (val1.length < 2) {
                //alert("Please input more than one character.");
                alert("<spring:message code='MSG.D.D07.0010'/>");
                frm.I_VALUE.focus();
                return;
            } else {
                frm.jobid.value = "des";
                frm.POST1.value = val1;
            }
        }
    }

    document.form1.action = "/web/D/D07TimeSheet/D07TimeSheetWBSPopUsa.jsp";
    document.form1.submit();
}

function changeWBS(index, PSPNR, POSID) {
    // opener form Array index 0~
    opener.form1.PSPNR[<%= rowIndex %>].value = PSPNR + index;
    opener.form1.POSID[<%= rowIndex %>].value = POSID;
    //opener.form1.POST1[<%= rowIndex %>].value = POST1;
    //opener.form1.ERDAT[<%= rowIndex %>].value = ERDAT;

    window.close();
}

function deleteWBS() {
    // opener form Array index 0~
    opener.form1.PSPNR[<%= rowIndex %>].value = "00000000";
    opener.form1.POSID[<%= rowIndex %>].value = "";

    //alert("No data.");
    alert("<spring:message code='MSG.D.D07.0011'/>");
    document.form1.I_VALUE.value = "";
    document.form1.I_VALUE.focus();
    return;

    //window.close();
}

function gubun_change() {
    var frm = document.form1;

    if (frm.I_VALUE.value == "") {
        frm.I_VALUE.focus();
    }
}

function EnterCheck(){
    if (event.keyCode == 13) {
        f_wbsSearch();
    }
}

function PageMove_m() {
    document.form1.action = "/web/D/D07TimeSheet/D07TimeSheetWBSPopUsa.jsp";
    document.form1.submit();
}

// PageUtil 관련 script - page처리시 반드시 써준다.
function pageChange(page){
    document.form1.page.value = page;
    PageMove_m();
}

// PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj) {
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}

//-->
</SCRIPT>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init();">
<div class="winPop">
<form name="form1" method="post">
<input type="hidden" name="rowIndex" value="<%= rowIndex %>">
<input type="hidden" name="POSID" value="">
<input type="hidden" name="POST1" value="">

    <div class="header">
        <span><!-- Project Lookup --><spring:message code='LABEL.D.D07.0024'/></span>
        <a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" border="0" /></a>
    </div>

    <div class="body">
        <!-- Search Option 테이블 시작 -->
        <h2 class="subtitle"><!-- Search Option --><spring:message code='LABEL.D.D07.0023'/></h2>

        <div class="tableInquiry">
            <table>
            	<colgroup>
            		<col />
            		<col />
            		<col width="10"/>
            		<col width="220" />
            		<col width="70" />
            	</colgroup>
                <tr>
                    <th><!-- Column --><spring:message code='LABEL.D.D07.0025'/></th>
                    <td>
                        <select name="I_GUBUN" style="width:90;" onChange="javascript:gubun_change()">
                            <option value=""><!-- Select --><spring:message code='LABEL.D.D07.0022'/></option>
                            <option value="01" <%= (I_GUBUN != null && I_GUBUN.equals("01")) ? "selected" : "" %>><!-- ID --><spring:message code='LABEL.D.D07.0019'/></option>
                            <option value="02" <%= (I_GUBUN != null && I_GUBUN.equals("02")) ? "selected" : "" %>><!--Description --><spring:message code='LABEL.D.D07.0020'/></option>
                        </select>
                    </td>
                    <th><!--Search--><spring:message code='LABEL.D.D07.0026'/></th>
                    <td>
                        <input type="text" size="14" name="I_VALUE" value="<%= I_VALUE != null ? I_VALUE : "" %>" onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active ">&nbsp;<br/>(<!--leave field blank to select all --><spring:message code='LABEL.D.D07.0027'/>)
                    </td>
                    <td>
                        <div class="tableBtnSearch tableBtnSearch2">
                            <a class="search" href="javascript:f_wbsSearch();"><span><!-- 조회 --><spring:message code='BUTTON.COMMON.SEARCH'/></span></a>
                        </div>
                    </td>
               </tr>
               <!--
               <tr>
                  <td class="td03" colspan="3" style="text-align:left;">&nbsp;&nbsp;
                                        <input type="checkbox" name="chkACTVE">&nbsp;Active Only&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" name="chkEFFCTVE">&nbsp;Effective Only</td>
               </tr>
                -->

            </table>
        </div>


        <div class="listArea">
<%
    if (D07TimeSheetWBSDataUsa_vt != null && D07TimeSheetWBSDataUsa_vt.size() > 0) {
%>
            <div class="listTop">
                <span class="lintCnt"><%= pu == null ? "" : pu.pageInfo() %></span>
            </div>
<%
    }
%>
            <div class="table">
                <table class="listTable">
                 <thead>
                    <tr>
                        <th><!-- ID --><spring:message code='LABEL.D.D07.0019'/></th>
                        <th><!--Description --><spring:message code='LABEL.D.D07.0020'/></th>
                        <th class="lastCol"><!-- Start --><spring:message code='LABEL.D.D07.0021'/></th>
                        <!-- <td class="td03">Active</td> -->
                    </tr>
                  </thead>
<%
   if (!isFirst) {
        if (D07TimeSheetWBSDataUsa_vt != null && D07TimeSheetWBSDataUsa_vt.size() > 0) {
            for (int i = pu.formRow(); i < pu.toRow(); i++) {
                D07TimeSheetWBSDataUsa holidayAbsenceData = (D07TimeSheetWBSDataUsa)D07TimeSheetWBSDataUsa_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }

                int index = i - pu.formRow();
%>
                    <tr class="<%=tr_class%>">
                        <td>
                            <a href="javascript:changeWBS('<%= index %>', '<%= WebUtil.printString(holidayAbsenceData.PSPNR) %>', '<%= WebUtil.printString(holidayAbsenceData.POSID) %>', '<%= WebUtil.printString(holidayAbsenceData.POST1) %>', '<%= WebUtil.printString(holidayAbsenceData.ERDAT) %>');" style="cursor:hand;margin-top:0px;">
                            <%= WebUtil.printString(holidayAbsenceData.POSID) %></a>
                        </td>
                        <td><%= WebUtil.printString(holidayAbsenceData.POST1) %></td>
                        <td class="lastCol"><%= WebUtil.printString(holidayAbsenceData.ERDAT) %></td>
                        <!-- <td class="td04"></td>
                        <input type="hidden" name="PSPNR<%= index %>" class="input04" value="<%= WebUtil.printString(holidayAbsenceData.PSPNR) %>">
                        -->
                    </tr>
              <%
                }
          %>
        <%
            for( int i = 0 ; i < D07TimeSheetWBSDataUsa_vt.size(); i++ ) {
                D07TimeSheetWBSDataUsa holidayAbsenceData = (D07TimeSheetWBSDataUsa)D07TimeSheetWBSDataUsa_vt.get(i);
        %>
              <input type="hidden" name="PSPNR<%= i %>" value="<%= holidayAbsenceData.PSPNR %>">
              <input type="hidden" name="POSID<%= i %>" value="<%= holidayAbsenceData.POSID%>">
              <input type="hidden" name="POST1<%= i %>" value="<%= holidayAbsenceData.POST1 %>">
              <input type="hidden" name="ERDAT<%= i %>" value="<%= holidayAbsenceData.ERDAT %>">

            <%
            }
        %>

                </table>
                <!-- PageUtil 관련 - 반드시 써준다. -->
                <div class="align_center">
                    <%= pu == null ? "" : pu.pageControl() %>
                </div>
                <!-- PageUtil 관련 - 반드시 써준다. -->
            </div>
        </div>

<%
        } else {

%>
                    <tr class="oddRow">
                        <td class="lastCol" colspan="4"><!-- No data --><spring:message code='MSG.COMMON.0004'/></td>
                    </tr>
                </table>
            </div>
        </div>

<%
        }
%>

<%
    }
%>
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:self.close()"><span><!-- 닫기 --><spring:message code='BUTTON.COMMON.CLOSE'/></span></a></li>
            </ul>
        </div>
        <input type="hidden" name="rowCount" value = "<%= pu.toRow() - pu.formRow()%>">
    </div>

    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="empNo" value="">
    <input type="hidden" name="I_DEPT" value="<%= PERNR %>">
    <input type="hidden" name="page" value="">
    <input type="hidden" name="count" value="<%= l_count %>">
    <input type="hidden" name="PERNR" value="<%= PERNR %>">


</form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>

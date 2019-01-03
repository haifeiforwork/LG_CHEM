<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 안내/신청                                          */
/*   Program ID   : C02CurriSearchTop.jsp                                       */
/*   Description  : 교육과정 정보를 가져오는 화면                               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  박영락                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    String PERNR         =  request.getParameter("PERNR");
    // 대리 신청 추가
    PersonInfoRFC numfunc = new PersonInfoRFC();
    PersonData phonenumdata;
    phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

    request.setAttribute("PersonData" , phonenumdata );

    String gubun         = request.getParameter("gubun");
    String date          = "";
    String I_GROUP       = "";
    String I_LOCATE      = "";
    String I_BUSEO       = "";
    String I_DESCRIPTION = "";

    if( gubun.equals("1") ) {
        date          = request.getParameter("I_FDATE");
        I_GROUP       = request.getParameter("I_GROUP");
        I_LOCATE      = request.getParameter("I_LOCATE");
        I_BUSEO       = request.getParameter("I_BUSEO");
        I_DESCRIPTION = request.getParameter("I_DESCRIPTION");
    } else {
        date          = DataUtil.getCurrentDate();
        I_GROUP       = "";
        I_LOCATE      = "";
        I_BUSEO       = "";
        I_DESCRIPTION = "";
    }

    String tmpYear    = date.substring(0,4);
    int    year       = Integer.parseInt(date.substring(0,4));
    String startMonth = date.substring(4,6);
    String endMonth   = date.substring(4,6);

    C02CurriGetYearRFC rfc = new C02CurriGetYearRFC();
    Vector getYear = rfc.getYear();

    int startYear = Integer.parseInt( (String)getYear.get(0) );
    int endYear   = Integer.parseInt( (String)getYear.get(1) );

    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function doSubmit(){
    //parent.endPage.location.href = '<%= WebUtil.JspURL %>C/C02Curri/C02CurriWait.jsp';
    var tmpYear    = document.form1.searchYear.value;
    var startMonth = document.form1.startMonth[form1.startMonth.selectedIndex].value;
    var endMonth   = document.form1.endMonth[form1.endMonth.selectedIndex].value;
    document.form1.I_FDATE.value  = tmpYear+startMonth+"01";
    document.form1.I_TDATE.value  = getLastDay( tmpYear, endMonth );
    document.form1.jobid.value = "submit";
    document.form1.target = "endPage";
    document.form1.action = '<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoListSV';
    document.form1.submit();
}

function on_Load_search() {
    gubun = "<%=request.getParameter("gubun")%>";
    if( gubun == "1" ) {
        doSubmit()
    }
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoListSV";
    frm.target = "menuContentIframe";
    frm.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:on_Load_search();" onSubmit="return;">
<form name="form1" method="post" action="" onsubmit="return false">
<input type="hidden" name ="PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>교육과정 안내/신청</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/SearchDeptPersons.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>

    <!--검색 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>분야</th>
                    <td>
                        <select name="I_GROUP">
                            <option value="">전체</option>
<%= WebUtil.printOption( (new C02CurriGroupRFC()).getGroup(), I_GROUP ) %>
                        </select>
                    </td>
                    <th class="th02">기간</th>
                    <td>
                        <select name="searchYear">
<%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%>
                        </select>
                        <select name="startMonth" >
                            <option value="01" <%= startMonth.equals("01") ? "selected" : "" %> >01</option>
                            <option value="02" <%= startMonth.equals("02") ? "selected" : "" %> >02</option>
                            <option value="03" <%= startMonth.equals("03") ? "selected" : "" %> >03</option>
                            <option value="04" <%= startMonth.equals("04") ? "selected" : "" %> >04</option>
                            <option value="05" <%= startMonth.equals("05") ? "selected" : "" %> >05</option>
                            <option value="06" <%= startMonth.equals("06") ? "selected" : "" %> >06</option>
                            <option value="07" <%= startMonth.equals("07") ? "selected" : "" %> >07</option>
                            <option value="08" <%= startMonth.equals("08") ? "selected" : "" %> >08</option>
                            <option value="09" <%= startMonth.equals("09") ? "selected" : "" %> >09</option>
                            <option value="10" <%= startMonth.equals("10") ? "selected" : "" %> >10</option>
                            <option value="11" <%= startMonth.equals("11") ? "selected" : "" %> >11</option>
                            <option value="12" <%= startMonth.equals("12") ? "selected" : "" %> >12</option>
                        </select>
                        ~
                        <select name="endMonth" >
                            <option value="01" <%= endMonth.equals("01") ? "selected" : "" %> >01</option>
                            <option value="02" <%= endMonth.equals("02") ? "selected" : "" %> >02</option>
                            <option value="03" <%= endMonth.equals("03") ? "selected" : "" %> >03</option>
                            <option value="04" <%= endMonth.equals("04") ? "selected" : "" %> >04</option>
                            <option value="05" <%= endMonth.equals("05") ? "selected" : "" %> >05</option>
                            <option value="06" <%= endMonth.equals("06") ? "selected" : "" %> >06</option>
                            <option value="07" <%= endMonth.equals("07") ? "selected" : "" %> >07</option>
                            <option value="08" <%= endMonth.equals("08") ? "selected" : "" %> >08</option>
                            <option value="09" <%= endMonth.equals("09") ? "selected" : "" %> >09</option>
                            <option value="10" <%= endMonth.equals("10") ? "selected" : "" %> >10</option>
                            <option value="11" <%= endMonth.equals("11") ? "selected" : "" %> >11</option>
                            <option value="12" <%= endMonth.equals("12") ? "selected" : "" %> >12</option>
                        </select>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <th>장소</th>
                    <td>
                        <select name="I_LOCATE">
                            <option value="">전체</option>
<%= WebUtil.printOption( (new C02CurriLocationRFC()).getLocation(), I_LOCATE ) %>
                        </select>
                    </td>
                    <th class="th02">주관부서</th>
                    <td>
                        <select name="I_BUSEO">
                            <option value="">전체</option>
<%= WebUtil.printOption( (new C02CurriBuseoRFC()).getBuseo(), I_BUSEO ) %>
                        </select>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <th>검색어</th>
                    <td colspan="3">
                        <input type="text" name="I_DESCRIPTION" value="<%= I_DESCRIPTION %>" size="70" value="" onFocus="this.select()">
                    </td>
                    <td class="align_right"><a class="inlineBtn" href="javascript:doSubmit()"><span>조회</span></a></td>
                </tr>
            </table>
        </div>
    </div>
    <!--검색 테이블 끝-->

<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="I_FDATE" value="">
    <input type="hidden" name="I_TDATE" value="">
    <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
<!--  HIDDEN  처리해야할 부분 시작-->
  </form>
</div>

<%@ include file="/web/common/commonEnd.jsp" %>

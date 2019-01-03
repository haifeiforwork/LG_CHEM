<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : 교육과정 안내/신청
/*   Program ID   : C02EpCurriSearchTop.jsp
/*   Description  :교육과정 정보를 가져오는 화면
/*   Note         : 없음
/*   Creation     : 2005-09-01  배민규
/*   Update       : 2005-10-13  lsa (table size 492->476로 수정)
/*                  2005-10-18  lsa (화면design 변경)
/*                  2005-11-02  lsa (포틀릿 UI 수정요청에 의하여 변경)
/*                  2005-11-29  @v1.4검색버튼이미지 변경 (포틀릿 UI 수정요청에 의하여 변경)
/*
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    String jobid   = (String)request.getAttribute("jobid");
    String date          = "";
    String I_GROUP       = "";
    String I_LOCATE      = "";
    String I_BUSEO       = "";
    String I_DESCRIPTION = "";
    String tmpYear = "";
    int year = 0;
    String startMonth = "";
    String endMonth = "";
    String paging  = (String)request.getAttribute("page");

    C02CurriGetYearRFC rfc = new C02CurriGetYearRFC();
    Vector getYear = rfc.getYear();

    int startYear = Integer.parseInt( (String)getYear.get(0) );
    int endYear   = Integer.parseInt( (String)getYear.get(1) );

    Vector CodeEntity_vt = new Vector();

    C02CurriInfoData key                 = (C02CurriInfoData)request.getAttribute("C02CurriInfoData");
    Vector        C02CurriInfoData_vt = (Vector)request.getAttribute("C02CurriInfoData_vt");

    PageUtilEp pu = null;

    if(jobid.equals("first")) {
      date          = DataUtil.getCurrentDate();
      I_GROUP       = "";
      I_LOCATE      = "";
      I_BUSEO       = "";
      I_DESCRIPTION = "";

      tmpYear    = date.substring(0,4);
      year       = Integer.parseInt(date.substring(0,4));
      startMonth = date.substring(4,6);
      endMonth   = date.substring(4,6);

      for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
      }
    } else if(jobid.equals("search")){
      date          = request.getParameter("I_FDATE");
      I_GROUP       = request.getParameter("I_GROUP");
      I_LOCATE      = request.getParameter("I_LOCATE");
      I_BUSEO       = request.getParameter("I_BUSEO");
      I_DESCRIPTION = request.getParameter("I_DESCRIPTION");
      tmpYear = (DataUtil.getCurrentDate()).substring(0,4);
      year       = Integer.parseInt((key.I_FDATE).substring(0,4));
      startMonth = (key.I_FDATE).substring(4,6);
      endMonth   = (key.I_TDATE).substring(4,6);

      if ( C02CurriInfoData_vt != null && C02CurriInfoData_vt.size() != 0 ) {
        try {
          pu = new PageUtilEp(C02CurriInfoData_vt.size(), paging , 5, 10);
          Logger.debug.println(this, "page : "+paging);
        } catch (Exception ex) {
          Logger.debug.println(DataUtil.getStackTrace(ex));
        }
      }

      for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
      }
    }

    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>

<html>
<head>
<title>e-HR(교육과정 안내 / 신청)</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/lgchem_ep.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/ep_common.js"></script>

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function doSubmit(){
    //parent.endPage.location.href = '<%= WebUtil.JspURL %>C/C02Curri/C02CurriWait.jsp';
    var tmpYear    = document.form1.searchYear.value;
    var startMonth = document.form1.startMonth[form1.startMonth.selectedIndex].value;
    var endMonth   = document.form1.endMonth[form1.endMonth.selectedIndex].value;
    document.form1.I_FDATE.value  = tmpYear+startMonth+"01";
    document.form1.I_TDATE.value  = getLastDay( tmpYear, endMonth );
    document.form1.jobid.value = "search";
    document.form1.target = "_self";
    document.form1.action = '<%= WebUtil.ServletURL %>hris.C.C02Curri.C02EpCurriInfoListSV';
    document.form1.submit();
}

function pageChange(page){
    document.form1.page.value = page;
    doSubmit();
}
    
function goDetail(index){
    var command = index;
    eval("document.form2.GWAJUNG.value = document.form1.GWAJUNG"+command+".value");
    eval("document.form2.GWAID.value   = document.form1.GWAID"+command+".value");
    eval("document.form2.CHASU.value   = document.form1.CHASU"+command+".value");
    eval("document.form2.CHAID.value   = document.form1.CHAID"+command+".value");
    eval("document.form2.SHORT.value   = document.form1.SHORT"+command+".value");
    eval("document.form2.BEGDA.value   = document.form1.BEGDA"+command+".value");
    eval("document.form2.ENDDA.value   = document.form1.ENDDA"+command+".value");
    eval("document.form2.EXTRN.value   = document.form1.EXTRN"+command+".value");
    eval("document.form2.KAPZ2.value   = document.form1.KAPZ2"+command+".value");
    eval("document.form2.RESRV.value   = document.form1.RESRV"+command+".value");
    eval("document.form2.LOCATE.value  = document.form1.LOCATE"+command+".value");
    eval("document.form2.BUSEO.value   = document.form1.BUSEO"+command+".value");
    eval("document.form2.SDATE.value   = document.form1.SDATE"+command+".value");
    eval("document.form2.EDATE.value   = document.form1.EDATE"+command+".value");
    eval("document.form2.DELET.value   = document.form1.DELET"+command+".value");
    eval("document.form2.PELSU.value   = document.form1.PELSU"+command+".value");
    eval("document.form2.GIGWAN.value  = document.form1.GIGWAN"+command+".value");
    eval("document.form2.IKOST.value   = document.form1.IKOST"+command+".value");
    eval("document.form2.STATE.value   = document.form1.STATE"+command+".value");
    document.form2.jobid.value = "detail";
    small_window=window.open('', '_epeddetail', "width=775,height=422,scrollbars=yes,toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=no,left=100,top=100");
    small_window.focus();    
    document.form2.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02EpCurriInfoListSV";
    document.form2.target = "_epeddetail";
    document.form2.method = "post";
    document.form2.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0">
<form name="form1" method="post" action="">

<table width="476" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td><table width="476" border="0" cellspacing="0" cellpadding="0">

        <tr> 
          <td class="title-text"> 

            <!-------메일 내용 테이블 하단 Grey Bar ----->
            <table width="100" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="10">
				<!--검색테이블 라인 시작-->
            <table width="100" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="10" ><table width="475" border="0" cellspacing="0" cellpadding="0" class="tablehead-text">
                    <tr> 
                      <td height="2"></td>
                    </tr>
                  </table>
				  <!--검색테이블 라인 끝-->
<TABLE width="476" border="0" cellpadding="3" cellspacing="1" >
                    <TR> 
                      <TD width="80" valign="middle" class="maintable_titleleft">분야7</TD>
                      <TD colspan=3 align="left" valign="middle" class="table_gray">
                    <select name="I_GROUP" class="select">
                      <option value="">전체</option>
                      <%= WebUtil.printOption( (new C02CurriGroupRFC()).getGroup(), I_GROUP ) %>
                    </select>
                      </TD>
                    </TR>
                    <TR>
                      <TD width="80"  align="left" valign="middle" class="maintable_titleleft">기간</TD>
                      <TD width="160" align="left" valign="middle" class="table_gray">
                    <select name="searchYear" class="select">
                      <%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%>
                    </select>
                    <select name="startMonth" class="select">
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
                    <select name="endMonth" class="select">
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
                      </TD>
                      <TD valign="middle" width=50 class="maintable_titleleft">장소</TD>
                      <TD align="left" valign="middle" class="table_gray">
                    <select name="I_LOCATE" class="select">
                      <option value="">전체</option>
                      <%= WebUtil.printOption( (new C02CurriLocationRFC()).getLocation(), I_LOCATE ) %>
                    </select>
                      </TD>
                    </TR>
                    <TR>                      
                      <TD valign="middle" class="maintable_titleleft">주관부서 </TD>
                      <TD colspan=3 align="left" valign="middle" class="table_gray">
                    <select name="I_BUSEO" class="select">
                      <option value="">전체</option>
                      <%= WebUtil.printOption( (new C02CurriBuseoRFC()).getBuseo(), I_BUSEO ) %>
                    </select>
                      </TD>
                    </TR>
                    <TR> 
                      <TD valign="middle" class="maintable_titleleft">검색어</TD>
                      <TD colspan="3"  align="left" valign="middle" class="table_gray">
                      <input type="text" name="I_DESCRIPTION" value="<%= I_DESCRIPTION %>" size="25" class="input_textfield" value="" onFocus="this.select()" onKeyDown="javascript:if (event.keyCode == 13){doSubmit();}">
                                              
                      <!--@v1.4<a href="javascript:doSubmit()"><img src="<%= WebUtil.ImageURL %>ep/r_ico_search.gif" align="absmiddle" border="0"></a>-->
                      <input name="submit32232" type="button" class="btn_img2text" value="검색" style="background-image: url('<%= WebUtil.ImageURL %>ep/f_btn_2text.gif');" onMouseOver="javascript:this.style.color='#B36C20';"onMouseOut="javascript:this.style.color='#000000';" onclick="javascript:doSubmit();"></TD>
                      </TD>
                    </TR>
                  </TABLE>
				  				              <!-------테이블 하단 Grey Bar ----->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" bgcolor="#CDCDCD"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif" width="1" height="2"></td>
              </tr>
            </table>
            <!------- Grey Bar 끝  ----->
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<% 
    if( jobid.equals("first") ) {
%>   
                <tr> 
                  <td align="right">&nbsp;</td>
                </tr>
<%
    } else if( jobid.equals("search") && C02CurriInfoData_vt.size() > 0 ){
%>
                <tr> 
                  <td align="right"><%= pu.pageInfo() %></td>
                </tr>
<%
    } 
%>
                  </table></td>
              </tr>
            </table>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_backline" >
                      <tr class="tablehead-text"> 
                        <td class="tablehead-text" height="26">과정명</td>
                        <td class="tablehead-text" width="20%" height="26">교육기간</td>
                        <td class="tablehead-text" width="20%" height="26">신청기간</td>
                        <td class="tablehead-text" width="13%">상태</td>
                      </tr>

<%
    if( jobid.equals("first") ) {
%>
                      <tr class="table-text"> 
                        <td height="1" colspan="4" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                      </tr>
                      <tr align="center" class="table_colorlist"> 
                        <td colspan="4">조건 선택 후, 조회하시기 바랍니다.</td>
                      </tr>
<!--  HIDDEN  처리해야할 부분 시작-->
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="I_FDATE" value="">
    <input type="hidden" name="I_TDATE" value="">
    <input type="hidden" name="SSNO"   value="<%=DataUtil.encodeEmpNo(user.empNo)%>">
    <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
                    </table>
            <!-------하단 Grey Bar ----->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" bgcolor="#CDCDCD"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif" width="1" height="2"></td>
              </tr>
            </table>
            <!------- 영역 끝  ----->
          </td>
        </tr>
      </table>
      </td>
  </tr>
</table>
    </form>
    
<!--  HIDDEN  처리해야할 부분 끝-->
<%
    } else if( jobid.equals("search")) {
      if( C02CurriInfoData_vt.size() > 0 ) {
        int j = 0;// 내부 카운터용
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            C02CurriInfoData data = (C02CurriInfoData)C02CurriInfoData_vt.get(i);
%>
                      <tr class="table-text"> 
                        <td height="1" colspan="4" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                      </tr>
                      <tr bgcolor="#FFFFFF" class="table-text">
                        <td style="padding-left:3px"><a href="javascript:goDetail(<%= j %>);" ><%= data.GWAJUNG %></a></td>
                        <td><%= WebUtil.printDate(data.BEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(data.BEGDA,".") + " ~" %><br><%= WebUtil.printDate(data.ENDDA,".").equals("0000.00.00") ? "" : "　　" + WebUtil.printDate(data.ENDDA,".") %></td>
                        <td><%= WebUtil.printDate(data.SDATE,".").equals("0000.00.00") ? "" : WebUtil.printDate(data.SDATE,".") + " ~" %><br><%= WebUtil.printDate(data.EDATE,".").equals("0000.00.00") ? "" : "　　" + WebUtil.printDate(data.EDATE,".") %></td>
                        <td align="center">
                          <%= data.DELET.equals("X") ? "취소" : data.PELSU.equals("C") ? "진급필수" : data.PELSU.equals("N") ? "PC진급필수" : data.STATE.equals("접수중") ? "<font color=blue>접수중</font>" : data.STATE %>
                        </td>
                        <input type="hidden" name="GWAJUNG<%= j %>" value="<%= data.GWAJUNG %>">
                        <input type="hidden" name="GWAID<%= j %>"   value="<%= data.GWAID %>"  >
                        <input type="hidden" name="CHASU<%= j %>"   value="<%= data.CHASU %>"  >
                        <input type="hidden" name="CHAID<%= j %>"   value="<%= data.CHAID %>"  >
                        <input type="hidden" name="SHORT<%= j %>"   value="<%= data.SHORT %>"  >
                        <input type="hidden" name="BEGDA<%= j %>"   value="<%= data.BEGDA %>"  >
                        <input type="hidden" name="ENDDA<%= j %>"   value="<%= data.ENDDA %>"  >
                        <input type="hidden" name="EXTRN<%= j %>"   value="<%= data.EXTRN %>"  >
                        <input type="hidden" name="KAPZ2<%= j %>"   value="<%= data.KAPZ2 %>"  >
                        <input type="hidden" name="RESRV<%= j %>"   value="<%= data.RESRV %>"  >
                        <input type="hidden" name="LOCATE<%= j %>"  value="<%= data.LOCATE %>" >
                        <input type="hidden" name="BUSEO<%= j %>"   value="<%= data.BUSEO %>"  >
                        <input type="hidden" name="SDATE<%= j %>"   value="<%= data.SDATE %>"  >
                        <input type="hidden" name="EDATE<%= j %>"   value="<%= data.EDATE %>"  >
                        <input type="hidden" name="DELET<%= j %>"   value="<%= data.DELET %>"  >
                        <input type="hidden" name="PELSU<%= j %>"   value="<%= data.PELSU %>"  >
                        <input type="hidden" name="GIGWAN<%= j %>"  value="<%= data.GIGWAN %>" >
                        <input type="hidden" name="IKOST<%= j %>"   value="<%= data.IKOST %>"  >
                        <input type="hidden" name="STATE<%= j %>"   value="<%= data.STATE %>"  >
                      </tr>
<%
           j++;
        }  //end for
%>

<%
      } else {
%>
                      <tr class="table-text"> 
                        <td height="1" colspan="4" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif"></td>
                      </tr>
                      <tr align="center" class="table_colorlist"> 
                        <td colspan="4">해당하는 데이터가 존재하지 않습니다.</td>
                      </tr>
<%
      }
%>
                    </table>
            <!-------하단 Grey Bar ----->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" bgcolor="#CDCDCD"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif" width="1" height="2"></td>
              </tr>
            </table>
            <!------- 영역 끝  ----->
          </td>
        </tr>
      </table>
    
      <table width="274" height="25" border="0" align="center" cellpadding="0" cellspacing="0">
<!-- PageUtilEp 관련 - 반드시 써준다. -->
          <tr valign="top" style="padding-bottom:5px">
            <!--<td width="9" background="<%= WebUtil.ImageURL %>ep/r_m_box04.gif"></td>-->
            <td width="474" align="center" height="25" valign="bottom">
              <input type="hidden" name="page" value=""><%= pu == null ? "" : pu.pageControl() %></td>
            <td width="9" background="<%= WebUtil.ImageURL %>ep/r_m_box06.gif"></td>
          </tr>
<!-- PageUtilEp 관련 - 반드시 써준다. -->
      </table>           
      </td>
      
  </tr>
</table>

<!--  HIDDEN  처리해야할 부분 시작-->
  <input type="hidden" name="jobid"         value="">
  <input type="hidden" name="I_FDATE"       value="<%= key.I_FDATE %>">
  <input type="hidden" name="I_TDATE"       value="<%= key.I_TDATE %>">
  <input type="hidden" name="I_BUSEO"       value="<%= key.I_BUSEO %>">
  <input type="hidden" name="I_GROUP"       value="<%= key.I_GROUP %>">
  <input type="hidden" name="I_LOCATE"      value="<%= key.I_LOCATE %>">
  <input type="hidden" name="I_DESCRIPTION" value="<%= key.I_DESCRIPTION %>">
  <input type="hidden" name="SSNO"   value="<%=DataUtil.encodeEmpNo(user.empNo)%>">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">  
<!--  HIDDEN  처리해야할 부분 시작-->
</form>

<form name="form2" method="post">
  <input type="hidden" name="jobid"   value="">
  <input type="hidden" name="GWAJUNG" value="">
  <input type="hidden" name="GWAID"   value="">
  <input type="hidden" name="CHASU"   value="">
  <input type="hidden" name="CHAID"   value="">
  <input type="hidden" name="SHORT"   value="">
  <input type="hidden" name="BEGDA"   value="">
  <input type="hidden" name="ENDDA"   value="">
  <input type="hidden" name="EXTRN"   value="">
  <input type="hidden" name="KAPZ2"   value="">
  <input type="hidden" name="RESRV"   value="">
  <input type="hidden" name="LOCATE"  value="">
  <input type="hidden" name="BUSEO"   value="">
  <input type="hidden" name="SDATE"   value="">
  <input type="hidden" name="EDATE"   value="">
  <input type="hidden" name="DELET"   value="">
  <input type="hidden" name="PELSU"   value="">
  <input type="hidden" name="GIGWAN"  value="">
  <input type="hidden" name="IKOST"   value="">
  <input type="hidden" name="STATE"   value="">
  <!---------------------------------------------------------------------->
  <input type="hidden" name="I_FDATE" value="<%= key.I_FDATE %>">
  <input type="hidden" name="I_TDATE" value="<%= key.I_TDATE %>">
  <input type="hidden" name="I_BUSEO" value="<%= key.I_BUSEO %>">
  <input type="hidden" name="I_GROUP" value="<%= key.I_GROUP %>">
  <input type="hidden" name="I_LOCATE" value="<%= key.I_LOCATE %>">
  <input type="hidden" name="I_DESCRIPTION" value="<%= key.I_DESCRIPTION %>">
  <input type="hidden" name="SSNO"   value="<%=DataUtil.encodeEmpNo(user.empNo)%>">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
</form>

<%
    }
%>
<%@ include file="/web/common/commonEnd.jsp" %>

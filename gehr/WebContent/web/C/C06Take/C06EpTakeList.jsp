<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : 수강신청현황
/*   Program ID   : C06EpTakeList.jsp
/*   Description  :수강신청현황 조회
/*   Note         : 없음
/*   Creation     : 2005-08-29  배민규
/*   Update       : 2005-10-13  lsa (table size 492->476로 수정)
/*                  2005-10-18  lsa (화면design 변경)
/*                  2005-11-02  lsa (포틀릿 UI 수정요청에 의하여 변경)
/*
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C06Take.*" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String jobid  = (String)request.getAttribute("jobid");
    String paging       = (String)request.getAttribute("page"); 
    Vector c06Take_vt   = (Vector)request.getAttribute("c06Take_vt");
    Vector p_edu_vt     = (Vector)request.getAttribute("p_edu_vt");

    WebUserData user = WebUtil.getSessionUser(request);
    String year      = (String)request.getAttribute("year"); 
    int startYear    = Integer.parseInt( (user.e_dat03).substring(0,4) );
    int endYear    = Integer.parseInt( DataUtil.getCurrentYear() );
    
    if( startYear < 2002 ){
        startYear = 2002;
    }
    
    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }
	      
	  //PageUtilEp 관련 - Page 사용시 반드시 써줄것.
	PageUtilEp pu = null;
	try {
      pu = new PageUtilEp(c06Take_vt.size(), paging , 5, 10);
      Logger.debug.println(this, "page : "+paging);
	} catch (Exception ex) {
		  Logger.debug.println(DataUtil.getStackTrace(ex));
	}

%>
<html>
<head>
<title>eHR(수강신청현황 검색)</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/lgchem_ep.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/ep_common.js"></script>

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function detail(i){
  eval("document.form1.GWAJUNG.value   = document.form1.GWAJUNG"+i+".value");
  eval("document.form1.GWAID.value     = document.form1.GWAID"+i+".value");
  eval("document.form1.CHASU.value     = document.form1.CHASU"+i+".value");
  eval("document.form1.CHAID.value     = document.form1.CHAID"+i+".value");
  eval("document.form1.SHORT.value     = document.form1.SHORT"+i+".value");
  eval("document.form1.BEGDA.value     = document.form1.BEGDA"+i+".value");
  eval("document.form1.ENDDA.value     = document.form1.ENDDA"+i+".value");
  eval("document.form1.EXTRN.value     = document.form1.EXTRN"+i+".value");
  eval("document.form1.KAPZ2.value     = document.form1.KAPZ2"+i+".value");
  eval("document.form1.RESRV.value     = document.form1.RESRV"+i+".value");
  eval("document.form1.LOCATE.value     = document.form1.LOCATE"+i+".value");
  eval("document.form1.BUSEO.value     = document.form1.BUSEO"+i+".value");
  eval("document.form1.SDATE.value     = document.form1.SDATE"+i+".value");
  eval("document.form1.EDATE.value     = document.form1.EDATE"+i+".value");
  eval("document.form1.DELET.value     = document.form1.DELET"+i+".value");
  eval("document.form1.PELSU.value     = document.form1.PELSU"+i+".value");
  eval("document.form1.GIGWAN.value    = document.form1.GIGWAN"+i+".value");
  eval("document.form1.IKOST.value     = document.form1.IKOST"+i+".value");
  
  document.form1.jobid.value = "detail";
  small_window=window.open('', '_epapdetail', "width=775,height=422,scrollbars=yes,toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=no,left=100,top=100");
  small_window.focus();    
  document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C06Take.C06EpTakeListSV";
  document.form1.target = "_epapdetail";
  document.form1.method = "post";
  document.form1.submit();
}

function doSubmit(){
	document.form1.YEAR.value  = document.form1.YEAR[form1.YEAR.selectedIndex].value ;
	document.form1.jobid.value = "search";
	document.form1.action = '<%= WebUtil.ServletURL %>hris.C.C06Take.C06EpTakeListSV';
  document.form1.target = "_self";
	document.form1.method = "post";
	document.form1.submit();
}

// PageUtilEp 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value = page;
  doSubmit();
}
// PageUtilEp 관련 script - page처리시 반드시 써준다...

// PageUtilEp 관련 script - selectBox 사용시 - Option
function selectPage(obj){
  val = obj[obj.selectedIndex].value;
  pageChange(val);
}
// PageUtilEp 관련 script - selectBox 사용시 - Option
//-->
</script>
</head>

<body leftmargin="0" topmargin="0">
<form name="form1" method="post">
<!--수강신청현황 검색-->
<table width="476" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td> 
        <table width="476" border="0" cellspacing="0" cellpadding="0">
        <!------- 메인이미지 상단여백 10픽셀----->
        <!------- 메인이미지  ----->
        <tr> 
          <td class="title-text"> 
<!--검색테이블 라인 시작-->
            <table width="100" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="10" ><table width="475" border="0" cellspacing="0" cellpadding="0" class="tablehead-text">
                    <tr> 
                      <td height="2"></td>
                    </tr>
                  </table>
				  <!--검색테이블 라인 끝-->
				  <!--검색 시작-->
                  <TABLE width="476" border="0" cellpadding="3" cellspacing="1" >
                    <TR> 
                      <TD width="80" valign="middle" class="maintable_titleleft">기간97</TD>
                      <TD  align="left" valign="middle" class="table_gray">
                    <select name="YEAR" class="select">
                      <%= WebUtil.printOption(CodeEntity_vt, year )%>
			              </select>
			              <a href="javascript:doSubmit()"><img src="<%= WebUtil.ImageURL %>ep/r_ico_search.gif" align="absmiddle" border="0"></a>
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
    if( c06Take_vt.size() > 0 ) {
%>   
                <tr> 
                  <td align="right"><%= pu.pageInfo() %></td>
                </tr>
<%
    } else {
%>
                <tr> 
                  <td align="right">&nbsp;</td>
                </tr>
<%
    } 
%>
                      
                  </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table_backline" >
              <tr class="tablehead-text" > 
                <td class="tablehead-text" height="23">과정명</td>
                <td class="tablehead-text" width="22%" height="26">차수</td>
                <td class="tablehead-text" width="15%" height="26">시작일</td>
                <td class="tablehead-text" width="15%">종료일</td>
                <td class="tablehead-text" width="13%">상태</td>
              </tr>
<% 
    String wGWAJUNG = "";       
    String wCHASU   = ""; 
    
    if( c06Take_vt.size() > 0 ) {
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            C06TakeData takedata = (C06TakeData)c06Take_vt.get(i);
            if (takedata.GWAJUNG.length() > 15) 
                wGWAJUNG = takedata.GWAJUNG.substring(0,15) + "..";
            else
                wGWAJUNG = takedata.GWAJUNG;
            if (takedata.CHASU.length() > 8) 
                wCHASU = takedata.CHASU.substring(0,8) + "..";
            else
                wCHASU = takedata.CHASU;
%> 				
				      <input type="hidden" name="GWAJUNG<%=i%>" value="<%= takedata.GWAJUNG %>">
				      <input type="hidden" name="GWAID<%=i%>"   value="<%= takedata.GWAID %>">
				      <input type="hidden" name="CHASU<%=i%>"   value="<%= takedata.CHASU %>">
				      <input type="hidden" name="CHAID<%=i%>"   value="<%= takedata.CHAID %>">
				      <input type="hidden" name="GBEGDA<%=i%>"  value="<%= takedata.GBEGDA %>">
				      <input type="hidden" name="GENDDA<%=i%>"  value="<%= takedata.GENDDA %>">
				      <input type="hidden" name="ZSTAT_ID<%=i%>"value="<%= takedata.ZSTAT_ID %>">
              <tr class="table-text"> 
                <td height="1" colspan="5" background="<%= WebUtil.ImageURL %>ep/r_temp_tabledot.gif"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif" width="1" height="1"></td>
              </tr>                      

				      <tr class="table-text" bgcolor="#FFFFFF">
                <td>ㆍ<a href="javascript:detail(<%=i%>)"><%= wGWAJUNG %></a></td>
                <td><%= wCHASU %></td>
                <td align="center"><%= WebUtil.printDate(takedata.GBEGDA) %></td>
                <td align="center"><%= WebUtil.printDate(takedata.GENDDA) %></td>
                <td align="center"><%= takedata.ZSTAT_ID.equals("1") ? "미결재": takedata.ZSTAT_ID.equals("2") ? "정상예약" : takedata.ZSTAT_ID.equals("3") ? "대기예약": takedata.ZSTAT_ID.equals("4") ? "확정":takedata.ZSTAT_ID.equals("5") ? "취소" : ""  %></td>
              </tr>
<%
	    }//end for
%>
<%
    } else {
        if( jobid.equals("first")||jobid.equals("search") ) {
%>
                      <tr align="center" class="table_colorlist"> 
                        <td colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
                      </tr>
<%
        } //end if
    } //end if
%>         
            </table>
            <!-------메일 내용 테이블 하단 Grey Bar ----->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" bgcolor="#CDCDCD"><img src="<%= WebUtil.ImageURL %>ep/r_fixbar.gif" width="1" height="2"></td>
              </tr>
            </table>
            <!------- 메일영역 끝  ----->
          </td>
        </tr>
      </table>
      
      
      <table width="274" height="25" border="0" align="center" cellpadding="0" cellspacing="0">
<!-- PageUtilEp 관련 - 반드시 써준다. -->
          <tr valign="top" style="padding-bottom:5px">
            <td width="6" background="<%= WebUtil.ImageURL %>ep/r_m_box04.gif"></td>
            <td width="464" align="center" height="25" valign="bottom" class="pagenumber_td">
              <input type="hidden" name="page" value=""><%= pu.pageControl() %></td>
            <td width="6" background="<%= WebUtil.ImageURL %>ep/r_m_box06.gif"></td>
          </tr>
<!-- PageUtilEp 관련 - 반드시 써준다. -->
      </table></td>
  </tr>
</table>

  <!--<%=user.empNo%>
  [<%=DataUtil.decodeEmpNo("1333419697769681")%>]
  [<%=DataUtil.encodeEmpNo("00026909")%>]-->
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="GBEGD"   value="">
    <input type="hidden" name="GENDDA"  value="">
    <input type="hidden" name="ZSTAT_ID"value="">

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
    <input type="hidden" name="SSNO"    value="<%=DataUtil.encodeEmpNo(user.empNo)%>">
<% 
    for( int i = 0 ; i < p_edu_vt.size(); i++ ) {
        C02CurriInfoData infodata = (C02CurriInfoData)p_edu_vt.get(i);
%>   
    <input type="hidden" name="SHORT<%=i%>"   value="<%=infodata.SHORT%>">      
    <input type="hidden" name="BEGDA<%=i%>"   value="<%=infodata.BEGDA%>">      
    <input type="hidden" name="ENDDA<%=i%>"   value="<%=infodata.ENDDA%>">       
    <input type="hidden" name="EXTRN<%=i%>"   value="<%=infodata.EXTRN%>">         
    <input type="hidden" name="KAPZ2<%=i%>"   value="<%=infodata.KAPZ2%>">        
    <input type="hidden" name="RESRV<%=i%>"   value="<%=infodata.RESRV%>">
    <input type="hidden" name="LOCATE<%=i%>"  value="<%=infodata.LOCATE%>">
    <input type="hidden" name="BUSEO<%=i%>"   value="<%=infodata.BUSEO%>">
    <input type="hidden" name="SDATE<%=i%>"   value="<%=infodata.SDATE%>">
    <input type="hidden" name="EDATE<%=i%>"   value="<%=infodata.EDATE%>">
    <input type="hidden" name="DELET<%=i%>"   value="<%=infodata.DELET%>">
    <input type="hidden" name="PELSU<%=i%>"   value="<%=infodata.PELSU%>">
    <input type="hidden" name="GIGWAN<%=i%>"  value="<%=infodata.GIGWAN%>">
    <input type="hidden" name="IKOST<%=i%>"   value="<%=infodata.IKOST%>">
<%
    }
%>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 수강신청현황                                                */
/*   Program Name : 수강신청현황                                                */
/*   Program ID   : C06TakeList.jsp                                             */
/*   Description  : 수강신청현황 조회                                           */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-28  윤정현                                          */
/*                                                                              */
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
	
      
	  //PageUtil 관련 - Page 사용시 반드시 써줄것.
	PageUtil pu = null;
	try {
      pu = new PageUtil(c06Take_vt.size(), paging , 10, 10);
      Logger.debug.println(this, "page : "+paging);
	} catch (Exception ex) {
		  Logger.debug.println(DataUtil.getStackTrace(ex));
	}

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

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
  document.form1.action = '<%= WebUtil.ServletURL %>hris.C.C06Take.C06TakeListSV';
  document.form1.method = "post";
  document.form1.submit();
}

function doSubmit(){
	document.form1.YEAR.value  = document.form1.YEAR[form1.YEAR.selectedIndex].value ;
	document.form1.jobid.value = "search";
	document.form1.action = '<%= WebUtil.ServletURL %>hris.C.C06Take.C06TakeListSV';
	document.form1.method = "post";
	document.form1.submit();
}

// PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value = page;
  doSubmit();
}
// PageUtil 관련 script - page처리시 반드시 써준다...

// PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
  val = obj[obj.selectedIndex].value;
  pageChange(val);
}
// PageUtil 관련 script - selectBox 사용시 - Option
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780">
              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">수강신청현황</td>
                  <td align="right"></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
    <tr> 
      <td> 
        <table width="780" border="0" cellspacing="1" cellpadding="5" class="table02">
          <tr>
            <td class="tr01">
              <table width="770" border="0" cellspacing="1" cellpadding="0" >
                <tr> 
                  <td width="100" class="td03">기 간</td>
                  <td  class="td09"> 
                    <select name="YEAR">
<%= WebUtil.printOption(CodeEntity_vt, year )%>
			        </select>
			        <a href="javascript:doSubmit()"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif" align="absmiddle" border="0"></a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td> 
         <table width="780" border="0" cellspacing="0" cellpadding="0">
<% 
    if( c06Take_vt.size() > 0 ) {
%>   
          <tr> 
            <td class="td02" align="right"><%= pu.pageInfo() %></td>
          </tr>
<%
    } else {
%>
          <tr> 
            <td class="td02" align="right">&nbsp;</td>
          </tr>
<%
    } 
%>
          <tr> 
            <td> 
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
                <tr> 
                  <td class="td03" width="260">과정명</td>
                  <td class="td03" width="250">차수</td>
                  <td class="td03" width="90">시작일</td>
                  <td class="td03" width="90">종료일</td>
                  <td class="td03" width="90">상태</td>
                </tr>
<% 
    if( c06Take_vt.size() > 0 ) {
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            C06TakeData takedata = (C06TakeData)c06Take_vt.get(i);
%>   
				
				        <input type="hidden" name="GWAJUNG<%=i%>" value="<%= takedata.GWAJUNG %>">
				        <input type="hidden" name="GWAID<%=i%>"   value="<%= takedata.GWAID %>">
				        <input type="hidden" name="CHASU<%=i%>"   value="<%= takedata.CHASU %>">
				        <input type="hidden" name="CHAID<%=i%>"   value="<%= takedata.CHAID %>">
				        <input type="hidden" name="GBEGDA<%=i%>"  value="<%= takedata.GBEGDA %>">
				        <input type="hidden" name="GENDDA<%=i%>"  value="<%= takedata.GENDDA %>">
				        <input type="hidden" name="ZSTAT_ID<%=i%>"value="<%= takedata.ZSTAT_ID %>">

				        <tr> 
                  <td class="td04"><a href="javascript:detail(<%=i%>)"><font color="#006699"><%= takedata.GWAJUNG %></font></a></td>
                  <td class="td04"><%= takedata.CHASU %></td>
                  <td class="td04"><%= WebUtil.printDate(takedata.GBEGDA) %></td>
                  <td class="td04"><%= WebUtil.printDate(takedata.GENDDA) %></td>
                  <td class="td04"><%= takedata.ZSTAT_ID.equals("1") ? "미결재": takedata.ZSTAT_ID.equals("2") ? "정상예약" : takedata.ZSTAT_ID.equals("3") ? "대기예약": takedata.ZSTAT_ID.equals("4") ? "확정":takedata.ZSTAT_ID.equals("5") ? "취소" : ""  %></td>
                </tr>
<%
	    }
%>
			        </table>
<!-- 조회 리스트 테이블 끝-->
            </td>
          </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
          <tr> 
            <td align="center" height="25" valign="bottom" class="td02">
              <input type="hidden" name="page" value="">
<%= pu.pageControl() %>
	          </td>
          </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
<%
    } else {
        if( jobid.equals("first")||jobid.equals("search") ) {
%>
                <tr align="center"> 
                  <td class="td04" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
              </table>
            </td>
          </tr>
<%
        }
    }
%>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
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

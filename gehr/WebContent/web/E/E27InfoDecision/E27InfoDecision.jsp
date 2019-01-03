<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회 간사결재                                             */
/*   Program Name : 동호회 간사결재                                             */
/*   Program ID   : E27InfoDecision.jsp                                         */
/*   Description  : 동호회 간사결재                                             */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E27InfoDecision.*" %>

<%
    String jobid  = (String)request.getAttribute("jobid");
	  String paging = (String)request.getAttribute("page");
	  E27InfoDecisionKey  key = (E27InfoDecisionKey)request.getAttribute("E27InfoDecisionKey");
	  Vector E27InfoDecision_vt = (Vector)request.getAttribute("E27InfoDecision_vt");
	
//  PageUtil 관련 - Page 사용시 반드시 써줄것.
	  PageUtil pu = null;
	  try {
		    pu = new PageUtil(E27InfoDecision_vt.size(), paging , 10, 10);
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
<script language="JavaScript">
<!--
function doSubmit(){
	if( check_data() ) {
		document.form1.P_INFO_TYPE.value = document.form1.P_INFO_TYPE[form1.P_INFO_TYPE.selectedIndex].value ;
		document.form1.P_APPR_STAT.value = document.form1.P_APPR_STAT[form1.P_APPR_STAT.selectedIndex].value ;
		document.form1.P_BEGDA.value     = changeChar( document.form1.from_date.value, ".", "" );
		document.form1.P_ENDDA.value     = changeChar( document.form1.to_date.value, ".", "" );
		document.form1.jobid.value       = "search";

		document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E27InfoDecision.E27InfoDecisionListSV';
		document.form1.method = "post";
    document.form1.submit();
	}
}

function viewDetail(i) {
    document.form1.P_BEGDA.value   = changeChar( document.form1.from_date.value, ".", "" );
    document.form1.P_ENDDA.value   = changeChar( document.form1.to_date.value, ".", "" );        
    document.form1.AINF_SEQN.value = eval("document.form1.AINF_SEQN"+i+".value") ;
    document.form1.MGART.value     = eval("document.form1.MGART"+i+".value") ;
    document.form1.APPR_STAT.value = eval("document.form1.APPR_STAT"+i+".value") ;
    document.form1.INFO_TYPE.value = eval("document.form1.INFO_TYPE"+i+".value") ;
    document.form1.INFO_TEXT.value = eval("document.form1.INFO_TEXT"+i+".value") ;
    document.form1.STEXT.value     = eval("document.form1.STEXT"+i+".value") ;
    document.form1.BEGDA.value     = eval("document.form1.BEGDA"+i+".value") ;
    document.form1.PERNR.value     = eval("document.form1.PERNR"+i+".value") ;
    document.form1.ENAME.value     = eval("document.form1.ENAME"+i+".value") ;
    document.form1.BETRG.value     = eval("document.form1.BETRG"+i+".value") ;
    
    document.form1.jobid.value = "detail";
    document.form1.action      = '<%= WebUtil.ServletURL %>hris.E.E27InfoDecision.E27InfoDecisionListSV';
    document.form1.method      = "post";
    document.form1.submit();
}

function check_data() {
	def = dayDiff(document.form1.from_date.value, document.form1.to_date.value);
	if( def < 0 ) {
		alert("신청일의 범위가 올바르지 않습니다.");
		return false;
	}
	return true;
}

//달력 사용
function fn_openCal(Objectname){
    var lastDate;
    
    lastDate     = eval("document.form1." + Objectname + ".value");
    small_window = window.open("<%=WebUtil.JspURL%>common/calendar.jsp?formname=form1&fieldname="+ Objectname + "&curDate=" + lastDate + "&iflag=0","essCal", "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=300,height=300");
    small_window.focus();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
  document.form1.page.value = page;
  doSubmit();
}
//PageUtil 관련 script - page처리시 반드시 써준다...

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
  val = obj[obj.selectedIndex].value;
  pageChange(val);
}
//PageUtil 관련 script - selectBox 사용시 - Option
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
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">동호회 간사결재</td>
                  <td align="right"><a href="#"><img src="<%= WebUtil.ImageURL %>ehr/bt_start.gif" border="0"></a></td>
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
        <!-- 상단 검색테이블 시작-->
        <table width="780" border="0" cellspacing="1" cellpadding="5" class="table01">
          <tr> 
            <td class="tr01"> 
              <table width="760" border="0" cellspacing="2" cellpadding="2">
                <tr> 
                  <td width="80" class="td01">신청구분</td>
                  <td class="td09" width="150"> 
                    <select name="P_INFO_TYPE" class="input03">
                     <option value="2" <%= key.P_INFO_TYPE.equals("")  ? "selected" : "" %>>전체</option>
                     <option value="0" <%= key.P_INFO_TYPE.equals("0") ? "selected" : "" %>>가입</option>
                     <option value="1" <%= key.P_INFO_TYPE.equals("1") ? "selected" : "" %>>탈퇴</option>

                  </td>
                  <td width="80" class="td01">상 태</td>
                  <td class="td09" width="198"> 
                    <select name="P_APPR_STAT" class="input03">
                      <option value=""  <%= key.P_APPR_STAT.equals("")  ? "selected" : "" %>>전체</option>
					            <option value="A" <%= key.P_APPR_STAT.equals("A") ? "selected" : "" %>>승인</option>
					            <option value="B" <%= key.P_APPR_STAT.equals("B") ? "selected" : "" %>>미승인</option>
					          </select>
                  </td>
                  <td class="td09" width="52">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="80" class="td01">신청일</td>
                  <td class="td09" colspan="3"> 
                    <input type="text" name="from_date" size="15" class="input03" value='<%= WebUtil.printDate(key.P_BEGDA,".") %>' onBlur="dateFormat(this);"">
                    <a href="javascript:fn_openCal('from_date')"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0"></a> 
                    - 
                    <input type="text" name="to_date" size="15" class="input03" value='<%= WebUtil.printDate(key.P_ENDDA,".") %>' onBlur="dateFormat(this);">
                    <a href="javascript:fn_openCal('to_date')"><img src="<%= WebUtil.ImageURL %>btn_serch.gif" width="31" height="21" align="absmiddle" border="0"></a> 
                    (예: 2001.12.13)</td>
                  <td class="td02" width="52"><a href="javascript:doSubmit();"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif" align="absmiddle" border="0"></a></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!-- 상단 검색테이블 끝-->
      </td>
    </tr>
    <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td> 
      <table width="780" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="font01" background="<%= WebUtil.ImageURL %>bg_pixel02.gif"><img src="<%= WebUtil.ImageURL %>bg_pixel02.gif" width="4" height="13"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td> 
      <!--테이블 시작-->
      <table width="780" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <table width="780" border="0" cellspacing="3" cellpadding="0" align="center">
              <tr> 
<%
    if ( E27InfoDecision_vt.size() > 0 ) {
%>
                <td align="right" class="td02"><%= pu.pageInfo() %></td>
<%
    } else {
%>
                <td align="right" class="td02">&nbsp;</td>
<%
    } 
%>
              </tr>
              <tr> 
                <td> 
                  <table width="780" border="0" cellspacing="1" cellpadding="2" class="table01">
                    <tr> 
                      <td class="td03" width="280">동호회</td>
                      <td class="td03" width="100">신청구분</td>
                      <td class="td03" width="100">신청일</td>
                      <td class="td03" width="100">성명</td>
                      <td class="td03" width="100">사번</td>
                      <td class="td03" width="100">상태</td>
                    </tr>
<%
    if ( E27InfoDecision_vt.size() > 0 ) {
        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            E27InfoDecisionData data = (E27InfoDecisionData)E27InfoDecision_vt.get(i);
%>
					          <INPUT TYPE="hidden" name="AINF_SEQN<%= i %>" value="<%= data.AINF_SEQN %>">
                    <INPUT TYPE="hidden" name="APPR_STAT<%= i %>"     value="<%= data.APPR_STAT %>">
                    <INPUT TYPE="hidden" name="MGART<%= i %>"     value="<%= data.MGART %>">
                    <INPUT TYPE="hidden" name="INFO_TYPE<%= i %>" value="<%= data.INFO_TYPE %>">
                    <INPUT TYPE="hidden" name="INFO_TEXT<%= i %>" value="<%= data.INFO_TEXT %>">
                    <INPUT TYPE="hidden" name="STEXT<%= i %>"     value="<%= data.STEXT %>">
                    <INPUT TYPE="hidden" name="BEGDA<%= i %>"     value="<%= data.BEGDA %>">
                    <INPUT TYPE="hidden" name="PERNR<%= i %>"     value="<%= data.PERNR %>">
                    <INPUT TYPE="hidden" name="ENAME<%= i %>"     value="<%= data.ENAME %>">
                    <INPUT TYPE="hidden" name="BETRG<%= i %>"     value="<%= data.BETRG %>">
              
                    <tr> 
                      <td class="td04"><a href="javascript:viewDetail(<%= i %>)"><%= data.STEXT %><a/></td>
                      <td class="td04"><%= data.INFO_TEXT %></td>
                      <td class="td04"><a href="javascript:viewDetail(<%= i %>)"><%=WebUtil.printDate(data.BEGDA) %></a></td>
                      <td class="td04"><%= data.ENAME %></td>
                      <td class="td04"><%= WebUtil.printNum(data.PERNR) %></td>
                      <td class="td04"> 
<%= data.APPR_STAT.equals("A") ?  "<img src='"+WebUtil.ImageURL+"icon_green.gif' border=0 >" : "<img src='"+WebUtil.ImageURL+"icon_red.gif' border=0 >" %>
					            </td>
                    </tr>
<%
        }
%>                    
                  </table>
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
			  </table>
          </td>
        </tr>
      </table>
      <!--테이블 끝-->
    </td>
  </tr>
<%
    } else {
%>
                    <tr> 
                      <td class="td02" align="center" colspan="6">해당하는 데이타가 없습니다.</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
<%
    }
%>
</table>
<INPUT TYPE="hidden" name="jobid" value="">
<INPUT TYPE="hidden" name="ThisJspName" value="">
<INPUT TYPE="hidden" name="BeforeJspName" value="">
<INPUT TYPE="hidden" name="P_BEGDA" value="">
<INPUT TYPE="hidden" name="P_ENDDA" value="">

<INPUT TYPE="hidden" name="AINF_SEQN" value="">
<INPUT TYPE="hidden" name="MGART" value="">
<INPUT TYPE="hidden" name="APPR_STAT" value="">
<INPUT TYPE="hidden" name="INFO_TYPE" value="">
<INPUT TYPE="hidden" name="INFO_TEXT" value="">
<INPUT TYPE="hidden" name="STEXT" value="">
<INPUT TYPE="hidden" name="BEGDA" value="">
<INPUT TYPE="hidden" name="PERNR" value="">
<INPUT TYPE="hidden" name="ENAME" value="">
<INPUT TYPE="hidden" name="BETRG" value="">
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

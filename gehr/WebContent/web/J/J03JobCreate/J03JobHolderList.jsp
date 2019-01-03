<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    WebUserData user            = (WebUserData)session.getAttribute("user");

//  생성, 수정 화면을 구분하기위해서 추가된 argument 
    String      jobidPop        = request.getParameter("jobidPop");

//  선택된 조직 코드를 읽는다.
    String      i_objid         = request.getParameter("OBJID_S");

//  page 처리
    String      paging          = request.getParameter("page");

    String      count           = request.getParameter("count");
    
    long        l_count         = 0;
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }

    J03OrgehPersListRFC rfc                 = new J03OrgehPersListRFC();
    Vector              j01OrgehPersList_vt = new Vector();
    Vector              j01SelectPers_vt    = new Vector();

    if( paging == null ) {
        paging = "1";  

//      Job Profile화면에서 이미 선택된 Job Holder 정보를 check한다.
        for( int i = 0 ; i < l_count ; i++ ) {
            J01PersonsData data_S = new J01PersonsData();

            data_S.PERNR = request.getParameter("PERNR_S"+i);                                 // 사번
            data_S.OBJID = request.getParameter("SOBID_S"+i);                                 // 포지션
            data_S.BEGDA = request.getParameter("BEGDA_S"+i);   // Job 시작일

            j01SelectPers_vt.addElement(data_S);
        }

        j01OrgehPersList_vt = rfc.getDetail(user.empNo, i_objid);
        for( int i = 0 ; i < j01OrgehPersList_vt.size() ; i++ ) {
            J01PersonsData data = (J01PersonsData)j01OrgehPersList_vt.get(i);
            if( l_count > 0 ) {
                for( int j = 0 ; j < l_count ; j++ ) {
                    J01PersonsData data_c = (J01PersonsData)j01SelectPers_vt.get(j);
                    if( data.PERNR.equals(data_c.PERNR) && data.OBJID.equals(data_c.OBJID) ) {
                        data.CHK_HOLDER = "X";
                        data.BEGDA      = data_c.BEGDA;
                        break;
                    } else {
//                      default로 현재날짜
                        data.BEGDA      = DataUtil.getCurrentDate();
                    }
                }
            } else {
//              default로 현재날짜
                data.BEGDA      = DataUtil.getCurrentDate();
            }
        }
        l_count = j01OrgehPersList_vt.size();
    } else {
//      Job Holder 정보
        for( int i = 0 ; i < l_count ; i++ ) {
            J01PersonsData data = new J01PersonsData();

            data.PERNR      = request.getParameter("PERNR"+i);        // 사번
            data.ENAME      = request.getParameter("ENAME"+i);        // 성명
            data.ORGEH      = request.getParameter("ORGEH"+i);        // 조직코드
            data.ORGTX      = request.getParameter("ORGTX"+i);        // 조직명
            data.TITEL      = request.getParameter("TITEL"+i);        // 직급호칭(직위)
            data.OBJID      = request.getParameter("OBJID"+i);        // 포지션
            data.CHK_HOLDER = request.getParameter("CHK_HOLDER"+i);   // Job Holder 선택 여부
            data.BEGDA      = request.getParameter("BEGDA"+i);        // Job 시작일

            j01OrgehPersList_vt.addElement(data);
        }
    }
//  PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    try {
        pu = new PageUtil(j01OrgehPersList_vt.size(), paging , 10, 10);
        Logger.debug.println(this, "page : "+paging);
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }
%>

<html>
<head>
<title>Job Holder 지정</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
<!--
//check시 정보를 저장한다.
function setCheck(index, paging) {
  var inx = 0;

//form의 checkbox index를 구한다.
  inx = index - (10 * (paging - 1));

<%
    if( (pu.toRow() - pu.formRow()) == 1 ) {
%>
  if( document.form1.holder.checked ) {
    eval("document.form1.CHK_HOLDER"+index+".value = 'X';");
  } else {
    eval("document.form1.CHK_HOLDER"+index+".value = '';");
  }
<%
    } else {
%>
  if( eval("document.form1.holder["+inx+"].checked") ) {
    eval("document.form1.CHK_HOLDER"+index+".value = 'X';");
  } else {
    eval("document.form1.CHK_HOLDER"+index+".value = '';");
  }
<%
    }
%>
}

function setJobHolder() {
  var count      = 0;
  var chk_holder = "";
  var htmlTITEL  = "", htmlENAME = "", htmlBEGDA = "", htmlINFO = "";

  for( i = 0 ; i < <%= l_count %> ; i++ ) {
    chk_holder = eval("document.form1.CHK_HOLDER"+i+".value");
    if( chk_holder == "X" ) {
      htmlTITEL += "<table height=22 cellspacing=0 cellpadding=0><tr><td conspan=2><input type=text name='TITEL_S"+count+"' size=8  value='" + eval("document.form1.TITEL"+i+".value") + "' style='border:0;text-align:center'></td></tr></table>";
      htmlENAME += "<table height=22 cellspacing=0 cellpadding=0><tr><td conspan=2><input type=text name='ENAME_S"+count+"' size=10 value='" + eval("document.form1.ENAME"+i+".value") + "' style='border:0;text-align:center'></td></tr></table>";
      htmlBEGDA += "<table height=22 cellspacing=0 cellpadding=0><tr><td width=85><input type=text name='BEGDA_S"+count+"' size=10 value='" + eval("document.form1.BEGDA"+i+".value") + "' onBlur='javascript:dateFormat(this);'></td><td><a href=\"javascript:fn_openCal('BEGDA_S"+count+"');\"><img src='<%= WebUtil.ImageURL %>jms/btn_searchs.gif' width=19 height=20 border=0 alt='달력보기'></a></td></tr></table>";
      htmlINFO  += "<input type=hidden name='PERNR_S"+count+"' value='" + eval("document.form1.PERNR"+i+".value") + "'>"
                +  "<input type=hidden name='SOBID_S"+count+"' value='" + eval("document.form1.OBJID"+i+".value") + "'>";

      count += 1;
    }
  }

//선택건수를 check한다.
  if( count == 0 ) {
<%
    if( jobidPop.equals("change") ) {
%>
    htmlINFO  += "<input type=hidden name='BEGDA_S"+count+"' value='0000.00.00'>"
              +  "<input type=hidden name='SOBID_S"+count+"' value=''>";
    count = 1;
<%
    } else {
%>
    alert("Job Holder를 지정하세요.");
    return;
<%
    }
%>
  }

  parent.opener.TITEL_S.innerHTML          = htmlTITEL;
  parent.opener.ENAME_S.innerHTML          = htmlENAME;
  parent.opener.BEGDA_S.innerHTML          = htmlBEGDA;
  parent.opener.INFO_S.innerHTML           = htmlINFO;
  parent.opener.document.form1.count.value = count;

  parent.opener.fn_inputCheck();         //Job Holder 지정을 check한다.

  self.close();
}

//PageUtil 관련 script - page처리시 반드시 써준다...
function pageChange(page){
    document.form1.page.value = page;
    PageMove();
}

//PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj){
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}

function PageMove() {
    document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03JobHolderList.jsp?i_objid=<%= i_objid %>";
    document.form1.submit();
}
//-->
</script>
</head>

<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <input type="hidden" name="jobidPop" value="<%= jobidPop %>">

  <input type="hidden" name="page"     value="">
  <input type="hidden" name="count"    value="<%= l_count %>">

  <input type="hidden" name="jobid"    value="">
  <input type="hidden" name="OBJID"    value="<%= i_objid %>">      <!-- Objective ID -->
  <input type="hidden" name="IMGIDX"   value="1">                   <!-- Menu Index   -->     

<%
//  Page 이동을 위해서 정보를 저장함.
    for( int i = 0 ; i < j01OrgehPersList_vt.size(); i++ ) {
        J01PersonsData data_P = (J01PersonsData)j01OrgehPersList_vt.get(i);
%>
   <input type="hidden" name="PERNR<%= i %>"      value="<%= data_P.PERNR      %>">
   <input type="hidden" name="ENAME<%= i %>"      value="<%= data_P.ENAME      %>">
   <input type="hidden" name="ORGEH<%= i %>"      value="<%= data_P.ORGEH      %>">
   <input type="hidden" name="ORGTX<%= i %>"      value="<%= data_P.ORGTX      %>">
   <input type="hidden" name="TITEL<%= i %>"      value="<%= data_P.TITEL      %>">
   <input type="hidden" name="OBJID<%= i %>"      value="<%= data_P.OBJID      %>">
   <input type="hidden" name="CHK_HOLDER<%= i %>" value="<%= data_P.CHK_HOLDER %>">
   <input type="hidden" name="BEGDA<%= i %>"      value="<%= WebUtil.printDate(data_P.BEGDA) %>">
<%
    }
%>
<table width=100% border=0>
  <tr height=20>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=20></td>
  </tr>
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>
  <tr height=332>
    <td valign=top align=center>
      <br>
      <table cellpadding=0 cellspacing=0 border=0 width=360>
        <tr height=30>
          <td colspan=3 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job Holder 지정</td>
<%
    if( j01OrgehPersList_vt.size() > 0 ) {
%>
          <td align="right" class="cc"><%= pu == null ? "" : pu.pageInfo() %></td>
<%
    } else {
%>
          <td align="right" class="cc">&nbsp;</td>
<%
    }
%>
		    </tr>         
        <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
        <tr bgcolor=#999999 height=2>
          <td width=40></td>
          <td width=1></td>
          <td width=200></td>
          <td width=119></td>
        </tr>
<%
    if( j01OrgehPersList_vt.size() > 0 ) {
        String old_ORGEH = "";
        for( int i = pu.formRow() ; i < pu.toRow() ; i++ ) {
            J01PersonsData data = (J01PersonsData)j01OrgehPersList_vt.get(i);
            if( (i % 10) == 0 || !old_ORGEH.equals(data.ORGEH) ) {
                old_ORGEH = data.ORGEH;
%>
        <tr>
          <td class=ct align=center>&nbsp;</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct colspan=2>&nbsp;<%= data.ORGTX %></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
<%
            }
%>
        <tr>
          <td class=ct1 align=center>
            <input type="checkbox" name="holder" class="formset2" <%= data.CHK_HOLDER.equals("X") ? "checked" : "" %> onClick="javascript:setCheck('<%= i %>', '<%= paging %>')">
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc colspan=2>&nbsp;<%= data.ENAME + " " + data.TITEL + " (" + data.PERNR + ")" %></td>
        </tr>
        <tr>
          <td colspan=4 bgcolor=#999999></td>
        </tr>
<%
        }
%>
<!-- PageUtil 관련 - 반드시 써준다. -->
        <tr> 
          <td align="center" height="25" valign="bottom" class="cc" colspan="4">
<%= pu == null ? "" : pu.pageControl() %>
          </td>
        </tr>
<!-- PageUtil 관련 - 반드시 써준다. -->
<%

    } else {
%>
    	        <tr height=60 align=center class=c01>
    	          <td class="bas" colspan="4">해당하는 팀원이 존재하지 않습니다.</td>
    	        </tr>
<%
    } 
%>
        <tr height=40>
          <td colspan=4 align=center valign=bottom>
           <a href="javascript:setJobHolder();"><img src="<%= WebUtil.ImageURL %>jms/btn_point.gif" border=0 hspace=5 alt="지정"></a>
           <a href="javascript:parent.window.close();"><img src="<%= WebUtil.ImageURL %>jms/btn_close.gif" border=0 hspace=5 alt="삭제"></a>
          </td>
        </tr>
      </table>	
      <br>
    </td>
  </tr>  
  <tr height=1>
    <td background="<%= WebUtil.ImageURL %>jms/J02bg.gif"></td>
  </tr>  
  <tr height=10>
    <td bgcolor=#efefef><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=10></td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

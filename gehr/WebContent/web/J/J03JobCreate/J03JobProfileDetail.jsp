<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 

<%@ page import="java.util.Vector" %> 
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
//  Job Profile 정보
    Vector             j01Result_P_vt = (Vector)request.getAttribute("j01Result_P_vt");
    Vector             j01Result_D_vt = (Vector)request.getAttribute("j01Result_D_vt");
    String             E_STEXT_L      = (String)request.getAttribute("E_STEXT_L");
//  subty별 직무요건 내역을 조회한다.
    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    StringBuffer subtype5 = new StringBuffer();
    StringBuffer subtype6 = new StringBuffer();
    for( int i = 0 ; i < j01Result_D_vt.size() ; i++ ) {
        J01JobProfileData data_D = (J01JobProfileData)j01Result_D_vt.get(i);
        
        if( data_D.SUBTY.equals("9040") ) {
            subtype1.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("9041") ) {
            subtype2.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("9042") ) {
            subtype3.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("9043") ) {
            subtype4.append(data_D.TLINE+"<br>"); 
        } else if( data_D.SUBTY.equals("9044") ) {
            subtype5.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("9045") ) {
            subtype6.append(data_D.TLINE+"<br>");
        }
    }
//  5개 이상일 경우 5개만 보여주고 popup을 띄운다.
    int to_inx = 0;
    if( j01Result_P_vt.size() > 5 ) {  
        to_inx = 5;
    } else {
        to_inx = j01Result_P_vt.size();
    }
%>
   
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<%@ include file="J03JobMatrixMenu.jsp" %>
<script language="JavaScript">
<!-- 
//Job Holder의 성명을 click시 사원인사정보를 띄워준다.
function open_dept(pernr){
    document.form1.I_DEPT.value   = "<%= user.empNo   %>";
    document.form1.I_GUBUN.value  = "1";                    //사번조회
    document.form1.I_VALUE1.value = pernr;
    document.form1.E_RETIR.value  = "<%= user.e_retir %>";
    document.form1.jobid.value    = "pernr";

    window.open("","DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=<%= user.e_retir.equals("Y") ? "740" : "680" %>,height=500,left=100,top=100");
    document.form1.action         = "<%= WebUtil.JspURL %>common/DeptPersonsPopWait_m.jsp";
    document.form1.target         = "DeptPers";
    document.form1.submit();
}

//  
function pers_List() {
    small_window=window.open("","JobHolder","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=335,height=380,left=100,top=100");
    small_window.focus();

		document.form1.action = "<%= WebUtil.JspURL %>J/J01JobMatrix/J01JobHolder.jsp?i_objid=<%= i_objid %>";
    document.form1.target = "JobHolder";
    document.form1.submit();
}
//-->
</script>     
  
<form name="form1" method="post" action="">        
  <input type="hidden" name="jobid"    value="">
  <input type="hidden" name="I_DEPT"   value="">
  <input type="hidden" name="I_GUBUN"  value="">
  <input type="hidden" name="I_VALUE1" value="">
  <input type="hidden" name="E_RETIR"  value="">

  <input type="hidden" name="l_count"  value="<%= j01Result_P_vt.size() %>">                 <!-- Job Holder List -->

<table cellspacing=0 cellpadding=0 border=0 width=746>
  <tr>
    <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
    <td width=746 valign=top>
      <!-- 테이블 시작-->
      <table cellpadding=0 cellspacing=0 border=0 width=746>
        <tr>
          <td colspan=11 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Job Profile 조회</td>
        </tr>
        <tr bgcolor=#999999 height=2>
          <td width=99></td>     
          <td width=1></td>
          <td width=60></td>
          <td width=1></td>
          <td width=145></td>
          <td width=1></td>
          <td width=145></td>
          <td width=1></td>
          <td width=145></td>
          <td width=1></td>
          <td width=145></td>
        </tr>
        <tr>
          <td class=ct colspan=3 align="center">Job Name</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=7 class=cc><%= dStext.STEXT_JOB %></td>
    	  </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=11 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->	  
        <tr height=2>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <!-- 서브제목은 ct1클래스를 적용하여 주세요 -->
        <tr>
<%
    if( j01Result_P_vt.size() > 5 || j01Result_P_vt.size() == 0 ) {
%>
          <td rowspan="<%= to_inx + 3 %>" class=ct colspan=3 align="center">Main<br>Job Holder</td>
          <td rowspan="<%= to_inx + 3 %>" width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
    } else {
%>
          <td rowspan="<%= to_inx + 2 %>" class=ct colspan=3 align="center">Main<br>Job Holder</td>
          <td rowspan="<%= to_inx + 2 %>" width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
    }
%>
          <td class=ct1 align="center">직위</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1 align="center">성명</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1 align="center">Job 시작일</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1 align="center">Job Grade</td>
        </tr>
        <tr>
          <td colspan=7 bgcolor=#999999></td>
        </tr>
<%
    if( j01Result_P_vt.size() > 0 ) {
        for( int i = 0 ; i < to_inx ; i ++ ) {
            J01JobProfileData data_P = (J01JobProfileData)j01Result_P_vt.get(i);
%>
        <tr>
          <td class=cc align="center"><%= data_P.TITEL %></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
            if ( i_objid.equals("") ) {
%>
          <td class=cc align="center"><%= data_P.ENAME %></td>  
<%
            } else {
%>
          <td class=cc align="center"><a href="javascript:open_dept('<%= data_P.PERNR %>');"><%= data_P.ENAME %></a></td>
<%
            }
%>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align="center"><%= data_P.BEGDA.equals("0000-00-00") ? "" : WebUtil.printDate(data_P.BEGDA, ".") %></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
            if( i == 0 ) {
%>
          <td class=cc rowspan="<%= j01Result_P_vt.size() > 5 ? to_inx + 1 : to_inx %>" align="center"><%= E_STEXT_L %></td>
<%
            } 
%>
        </tr>
<%
            if( j01Result_P_vt.size() > 5 && i == 4 ) {
%>
        <tr>
          <td class=cc align="center">&nbsp;</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align="right"><a href="javascript:pers_List();"><img src="<%= WebUtil.ImageURL %>jms/btn_more.gif" border=0 alt="more"></a></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align="center">&nbsp;</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
        </tr>
<%
            }
%>        
          <input type="hidden" name="SOBID<%= i %>"     value="<%= data_P.SOBID     %>">
          <input type="hidden" name="PERNR<%= i %>"     value="<%= data_P.PERNR     %>">
          <input type="hidden" name="TITEL<%= i %>"     value="<%= data_P.TITEL     %>">
          <input type="hidden" name="ENAME<%= i %>"     value="<%= data_P.ENAME     %>">
          <input type="hidden" name="BEGDA<%= i %>"     value="<%= data_P.BEGDA     %>">
<%
        }
        if ( j01Result_P_vt.size() > 5 ) {
            for( int i = 5 ; i < j01Result_P_vt.size() ; i ++ ) {  // -- 6개 이상일 경우 파라미터 데이터만 생성.
                J01JobProfileData data_P = (J01JobProfileData)j01Result_P_vt.get(i);
%>           
           <input type="hidden" name="SOBID<%= i %>"     value="<%= data_P.SOBID     %>">
           <input type="hidden" name="PERNR<%= i %>"     value="<%= data_P.PERNR     %>">
           <input type="hidden" name="TITEL<%= i %>"     value="<%= data_P.TITEL     %>">
           <input type="hidden" name="ENAME<%= i %>"     value="<%= data_P.ENAME     %>">
           <input type="hidden" name="BEGDA<%= i %>"     value="<%= data_P.BEGDA     %>">
<%           
            }   
        }
    } else {
%>
        <tr>
          <td class=cc align="center">&nbsp;</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align="center">&nbsp;</td>  
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align="center">&nbsp;</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc rowspan="<%= to_inx %>" align="center"><%= E_STEXT_L %></td>
        </tr>
<%
    }
%>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
        <tr>
          <td colspan=11 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
        </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->	  
        <tr height=2>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td colspan=3 class=ct align="center">직무목적<br>(Job Objective)</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=7 class=cc><%= subtype1.toString() %></td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td colspan=3 class=ct align="center">주요 책임 및 활동<br>(Main task &<br>Responsibilities)</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=7 class=cc><%= subtype2.toString() %></td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct rowspan=7 style="writing-mode:tb-rl" align="center">직무요건<br>(Job Requirements)</td>
          <td width=1 rowspan=7 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=ct1 align="center">지식</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=7 class=cc><%= subtype3.toString() %></td>
        </tr>
        <tr>
          <td colspan=9 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct1 align="center">스킬</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=7 class=cc><%= subtype4.toString() %></td>
        </tr>
        <tr>
          <td colspan=9 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct1 align="center">경험</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=7 class=cc><%= subtype5.toString() %></td>
        </tr>
        <tr>
          <td colspan=9 bgcolor=#999999></td>
        </tr>
        <tr>
          <td class=ct1 align="center">태도</td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td colspan=7 class=cc><%= subtype6.toString() %></td>
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999></td>
        </tr>
        <tr height=30 valign=bottom>
          <td colspan=11 align=center>
            <a href="javascript:goChange('<%= i_sobid %>','1');"><img src="<%= WebUtil.ImageURL %>jms/btn_modify.gif" border=0 hspace=5 alt="수 정"></a>
            <a href="javascript:goDelete('<%= i_sobid %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_delJob.gif" border=0 hspace=5 alt="Job 삭제"></a>
            <a href="javascript:goMatrix('<%= i_pernr %>', '<%= i_objid %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_goback.gif" border=0 hspace=5 alt="이동"></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

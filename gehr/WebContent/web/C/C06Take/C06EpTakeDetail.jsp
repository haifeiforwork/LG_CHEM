<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : 수강신청현황
/*   Program ID   : C06EpTakeDetail.jsp
/*   Description  :수강신청현황 과정 상세조회
/*   Note         : 없음
/*   Creation     : 2005-08-29  배민규
/*   Update       :
/*
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    C02CurriInfoData infoData       = (C02CurriInfoData)request.getAttribute("C02CurriInfoData");
    Vector C02CurriEventInfoData_vt = (Vector)request.getAttribute( "C02CurriEventInfoData_vt" );
    Vector C02CurriEventData_vt     = (Vector)request.getAttribute( "C02CurriEventData_vt" );//유형정보
    
    Vector C02CurriData_Course_vt   = (Vector)request.getAttribute( "C02CurriData_Course_vt" );//선수과정
    Vector C02CurriData_Grint_vt    = (Vector)request.getAttribute( "C02CurriData_Grint_vt" );//선수자격
    Vector C02CurriData_Get_vt      = (Vector)request.getAttribute( "C02CurriData_Get_vt" );//자격요건
       
    StringBuffer subtype1 = new StringBuffer();
    StringBuffer subtype2 = new StringBuffer();
    StringBuffer subtype3 = new StringBuffer();
    StringBuffer subtype4 = new StringBuffer();
    for(int i = 0; i<C02CurriEventInfoData_vt.size(); i++){
      C02CurriEventInfoData data = (C02CurriEventInfoData)C02CurriEventInfoData_vt.get(i);
      if( data.SUBTY.equals("9001") ){
          subtype1.append(data.TLINE+"<br>");
      } else if( data.SUBTY.equals("9002") ){
          subtype2.append(data.TLINE+"<br>");
      } else if( data.SUBTY.equals("9003") ){
          subtype3.append(data.TLINE+"<br>");
      } else if( data.SUBTY.equals("9004") ){
          subtype4.append(data.TLINE+"<br>");
      }
    }
    
    C02CurriEventData eventData = (C02CurriEventData)C02CurriEventData_vt.get(0);
    StringBuffer curse          = new StringBuffer();
    StringBuffer grentText      = new StringBuffer();
    StringBuffer grentLevel     = new StringBuffer();
    StringBuffer getText        = new StringBuffer();
    StringBuffer getLevel       = new StringBuffer();
    for(int i = 0; i < C02CurriData_Course_vt.size(); i++){
      C02CurriData data = (C02CurriData)C02CurriData_Course_vt.get(i);
      curse.append ( data.PRE_TEXT+"<br>");
    }
    for(int i = 0; i < C02CurriData_Grint_vt.size(); i++){
      C02CurriData data = (C02CurriData)C02CurriData_Grint_vt.get(i);
      grentText.append ( data.PRE_TEXT+"<br>");
      grentLevel.append ( data.PRE_LEVEL+"<br>");
    }
    for(int i = 0; i < C02CurriData_Get_vt.size(); i++){
      C02CurriData data = (C02CurriData)C02CurriData_Get_vt.get(i);
      getText.append ( data.PRE_TEXT+"<br>");
      getLevel.append ( data.PRE_LEVEL+"<br>");
    }

    Logger.debug.println(this, "eventData : "+eventData.toString());
%>

<html>
<head>
<title>e-HR</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/lgchem_ep.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/ep_common.js"></script>

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body leftmargin="0" topmargin="0" style="overflow:auto">
<form name="form1" method="post">
<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td width="8">
    </td>
    <td>
      <table height="25" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="10"></td>
          <td><font class="depth_1"><img src="<%= WebUtil.ImageURL %>ep/r_contents_bullet.gif" width="6" height="9"> 과정 상세조회</font> </td>
        </tr>
      </table>
      <table width="758" border="0" cellspacing="0" cellpadding="4" >
        <tr> 
          <td height="5"></td>
        </tr>
        <tr> 
          <td height="1" bgcolor="#DBDBDB"></td>
        </tr>
        <tr> 
          <td height="5" bgcolor="#F6F6F6"></td>
        </tr>
      </table>
      <table width="758" border="0" cellpadding="3" cellspacing="1" >
        <tr> 
          <td width="114" height="20" align="center" valign="middle" class="table_titleleft">교육분야</td>
          <td width="265" height="20" valign="middle" bgcolor="#FFFFFF" class="table_gray"><%= eventData.ZGROUP %></td>
          <td width="114" valign="middle" bgcolor="#FFFFFF" class="table_titleleft">과정명</td>
          <td width="265" align="right" valign="middle" bgcolor="#FFFFFF" class="table_gray" colspan=3><%= eventData.GWAJUNG %></td>
        </tr>
        <tr> 
          <td width="114" height="20" valign="middle" class="table_titleleft">차수명</td>
          <td width="265"  align="left" valign="middle" class="table_gray"><%= infoData.CHASU %></td>
          <td width="114" height="20" valign="middle" class="table_titleleft">차수ID</td>
          <td width="133" align="left" valign="middle" class="table_gray"><%= infoData.CHAID %></td>
          <td width="114" height="20" valign="middle" class="table_titleleft">진급필수</td>
          <td width="132" align="left" valign="middle" class="table_gray"><%= eventData.PELSU %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">구분</td>
          <td align="left" valign="middle" class="table_gray"><%= infoData.EXTRN %></td>
          <td height="20" valign="middle" class="table_titleleft">사회교육기관명</td>
          <td align="left" valign="middle" class="table_gray" colspan=3><%= infoData.GIGWAN %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">개요</td>
          <td align="left" valign="middle" class="table_gray" colspan=5><%= subtype1.toString() %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">목표</td>
          <td align="left" valign="middle" class="table_gray" colspan=5><%= subtype2.toString() %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">교육내용</td>
          <td align="left" valign="middle" class="table_gray" colspan=5><%= subtype3.toString() %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">추천직무</td>
          <td align="left" valign="middle" class="table_gray" colspan=5><%= eventData.JIKMU %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">선이수 과정</td>
          <td align="left" valign="middle" class="table_gray" colspan=5><%= curse.toString() %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">선이수 과정</td>
          <td align="left" valign="middle" class="table_gray" colspan=5><%= curse.toString() %></td>
        </tr>
        <tr> 
          <td height="20" align="center" valign="middle" class="table_titleleft">선수 자격요건</td>
          <td height="20" valign="middle" bgcolor="#FFFFFF" class="table_gray"><%= getText.toString() %></td>
          <td valign="middle" bgcolor="#FFFFFF" class="table_titleleft">Level</td>
          <td align="right" valign="middle" bgcolor="#FFFFFF" class="table_gray" colspan=3><%= getLevel.toString() %></td>
        </tr>
        <tr> 
          <td height="20" align="center" valign="middle" class="table_titleleft">자격요건 획득</td>
          <td height="20" valign="middle" bgcolor="#FFFFFF" class="table_gray"><%= grentText.toString() %></td>
          <td valign="middle" bgcolor="#FFFFFF" class="table_titleleft">Level</td>
          <td align="right" valign="middle" bgcolor="#FFFFFF" class="table_gray" colspan=3><%= getLevel.toString() %></td>
        </tr>
        <tr> 
          <td height="20" align="center" valign="middle" class="table_titleleft">교육일정</td>
          <td height="20" valign="middle" bgcolor="#FFFFFF" class="table_gray"><%= WebUtil.printDate(infoData.BEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(infoData.BEGDA,".") + " ~ " %><%= WebUtil.printDate(infoData.ENDDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(infoData.ENDDA,".") %></td>
          <td valign="middle" bgcolor="#FFFFFF" class="table_titleleft">교육장소</td>
          <td align="right" valign="middle" bgcolor="#FFFFFF" class="table_gray" colspan=3><%= infoData.LOCATE %></td>
        </tr>
        <tr> 
          <td height="20" align="center" valign="middle" class="table_titleleft">가격</td>
          <td height="20" valign="middle" bgcolor="#FFFFFF" class="table_gray"><%=WebUtil.printNumFormat( infoData.IKOST )%>원</td>
          <td valign="middle" bgcolor="#FFFFFF" class="table_titleleft">교육인원</td>
          <td align="right" valign="middle" bgcolor="#FFFFFF" class="table_gray" colspan=3><%= infoData.KAPZ2 %>명</td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">주관부서</td>
          <td align="left" valign="middle" class="table_gray"><%= infoData.BUSEO %></td>
          <td height="20" valign="middle" class="table_titleleft">담당자</td>
          <td align="left" valign="middle" class="table_gray"><%= eventData.ENAME %></td>
          <td height="20" valign="middle" class="table_titleleft">전화</td>
          <td align="left" valign="middle" class="table_gray"><%= eventData.TELNO %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">기타</td>
          <td align="left" valign="middle" class="table_gray" colspan=5><%= subtype4.toString() %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">첨부파일</td>
          <td align="left" valign="middle" class="table_gray" colspan=5><%= new C02CurriFileLinkRFC().getLink(infoData.CHAID) %></td>
        </tr>
      </table>
      <table width="758" border="0" cellspacing="0" cellpadding="4" >
        <tr> 
          <td height="5" bgcolor="#F6F6F6"></td>
        </tr>
        <tr> 
          <td height="1" bgcolor="#DBDBDB"></td>
        </tr>
        <tr> 
          <td height="5"></td>
        </tr>
      </table>
      <table width="758" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align="center">
            <a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>ep/r_ico_close.gif" width="11" height="11" border="0" align="absmiddle">&nbsp;<spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

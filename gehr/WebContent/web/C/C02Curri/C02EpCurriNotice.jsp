<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : 교육과정 안내/신청
/*   Program ID   : C02EpCurriNotice.jsp
/*   Description  :교육과정 안내 정보를 가져오는 화면
/*   Note         : 없음
/*   Creation     : 2005-09-01  배민규
/*   Update       :
/*
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>  
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>
<%= WebUtil.ImageURL %>
<%
    WebUserData      user           = (WebUserData)session.getAttribute("user");
    C02CurriInfoData infoData       = (C02CurriInfoData)request.getAttribute("C02CurriInfoData");
    
    //////////////////////////////////////////
    C02CurriInfoData key            = (C02CurriInfoData)request.getAttribute("C02CurriInfoKey");
    //////////////////////////////////////////

    Vector C02CurriEventInfoData_vt = (Vector)request.getAttribute( "C02CurriEventInfoData_vt" );

    Vector C02CurriEventData_vt     = (Vector)request.getAttribute( "C02CurriEventData_vt" );//유형정보
    Vector C02CurriData_Course_vt   = (Vector)request.getAttribute( "C02CurriData_Course_vt" );//선수과정
    Vector C02CurriData_Grint_vt    = (Vector)request.getAttribute( "C02CurriData_Grint_vt" );//선수자격
    Vector C02CurriData_Get_vt      = (Vector)request.getAttribute( "C02CurriData_Get_vt" );//자격요건

    Vector C02CurriCheck_Pre_vt     = (Vector)request.getAttribute("C02CurriCheck_Pre_vt");//선수자격첵크
    Vector C02CurriCheck_PreChk_vt  = (Vector)request.getAttribute("C02CurriCheck_PreChk_vt");//요건첵크

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
    C02CurriEventData eventData = null;
    if( C02CurriEventData_vt.size() != 0 ){
      eventData = (C02CurriEventData)C02CurriEventData_vt.get(0);
    } else {
      eventData = new C02CurriEventData();
    }
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

    StringBuffer checkString = new StringBuffer();
    StringBuffer checkString2 = new StringBuffer();
    checkString.append("");

    //선이수과정첵크

     for(int i = 0; i < C02CurriData_Course_vt.size(); i++){
        C02CurriData data = (C02CurriData)C02CurriData_Course_vt.get(i);
        boolean flag = false;
        for( int j = 0; j < C02CurriCheck_Pre_vt.size(); j++ ){
            C02CurriCheckData checkData = (C02CurriCheckData)C02CurriCheck_Pre_vt.get(j);
            if( (data.PREID).equals(checkData.OBJID) ){
                flag = true;
                break;
            }
        }
        if( !flag ){
            
            checkString.append(data.PRE_TEXT+", ");
        }
    }

    //선이수자격첵크
    for(int i = 0; i < C02CurriData_Grint_vt.size(); i++){
        C02CurriData data = (C02CurriData)C02CurriData_Grint_vt.get(i);
        boolean flag = false;
        for( int j = 0; j < C02CurriCheck_PreChk_vt.size(); j++ ){
            C02CurriCheckData checkData = (C02CurriCheckData)C02CurriCheck_PreChk_vt.get(j);
            if( (data.PREID).equals(checkData.OBJID) ){
                flag = true;
                break;
            }
        }
        if( !flag ) { 
             checkString2.append(data.PRE_TEXT+", ");
        }
    }
    
    String RequestPageName = (String)request.getAttribute("RequestPageName");
%>
<html>
<head>
<title>e-HR</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/lgchem_ep.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/ep_common.js"></script>

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="javascript">
<!--
function doSubmit(){
    if( check_data() ) {
        document.form2.jobid.value = "build";
//        opener.document.location.href="<%= WebUtil.ServletURL %>hris.C.C02Curri.C02EpCurriInfoListSV";
        document.form2.action = '<%= WebUtil.ServletURL %>hris.C.C02Curri.C02EpCurriInfoListSV';
        document.form2.method = "post";
        document.form2.target = "_self";
        document.form2.submit();
//        self.close();
    }
}

function check_data() {
    if ( <%= (checkString.toString()).equals("") ? "false" : "true" %> ){
        if( confirm( "선이수에 대한 요건이 부족합니다.\n계속 신청하시겠습니까?") ){
            return true;
        }
        return false;
    }
    if ( <%= (checkString2.toString()).equals("") ? "false" : "true" %> ){

        if( confirm( "선수자격요건이 부족합니다.\n계속 신청하시겠습니까?") ){
            return true;
        }
        return false;
    }
    return true;
}

//-->
</script>
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
<%
    if( eventData.ZGROUP == null && eventData.GWAJUNG == null ) {
%>
        <tr> 
          <td class="td04" align="center" height="100"><br><font color="#006699">현재 수강 신청이 가능한 차수가 아닙니다.</font><br><br></td>
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
<%
    } else {
%>
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
          <td width="132" align="left" valign="middle" class="table_gray"><%= (infoData.DELET).equals("X") ? "&nbsp;" : (infoData.PELSU).equals("") ? "&nbsp;" : eventData.PELSU %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">구분</td>
          <td align="left" valign="middle" class="table_gray"><%= infoData.EXTRN %></td>
          <td height="20" valign="middle" class="table_titleleft">사외교육기관명</td>
          <td align="left" valign="middle" class="table_gray" colspan=3><%= infoData.GIGWAN %></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">개요</td>
          <td align="left" valign="middle" class="table_gray" colspan=5> <p> <%= subtype1.toString() %> </p></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">목표</td>
          <td align="left" valign="middle" class="table_gray" colspan=5> <p> <%= subtype2.toString() %> </p></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">교육내용</td>
          <td align="left" valign="middle" class="table_gray" colspan=5> <p> <%= subtype3.toString() %> </p></td>
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
          <td height="20" align="center" valign="middle" class="table_titleleft">선수 자격요건</td>
          <td height="20" valign="middle" bgcolor="#FFFFFF" class="table_gray">&nbsp;<%= grentText.toString() %></td>
          <td valign="middle" bgcolor="#FFFFFF" class="table_titleleft">Level</td>
          <td align="right" valign="middle" bgcolor="#FFFFFF" class="table_gray" colspan=3>&nbsp;<%= grentLevel.toString() %></td>
        </tr>
        <tr> 
          <td height="20" align="center" valign="middle" class="table_titleleft">자격요건 획득</td>
          <td height="20" valign="middle" bgcolor="#FFFFFF" class="table_gray">&nbsp;<%= getText.toString() %></td>
          <td valign="middle" bgcolor="#FFFFFF" class="table_titleleft">Level</td>
          <td align="right" valign="middle" bgcolor="#FFFFFF" class="table_gray" colspan=3>&nbsp;<%= getLevel.toString() %></td>
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
          <td align="left" valign="middle" class="table_gray" colspan=5> <p> <%= subtype4.toString() %> </p></td>
        </tr>
        <tr> 
          <td height="20" valign="middle" class="table_titleleft">첨부파일</td>
          <td align="left" valign="middle" class="table_gray" colspan=5> <p> <%= new C02CurriFileLinkRFC().getLink(infoData.CHAID) %> </p></td>
        </tr>
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
          <td align="center" class="pop_back_gray">
				  <%  if( infoData.STATE.equals("접수중") ){   //테스트 %> 
            <a href="javascript:doSubmit();" class="main">신청</a> :&nbsp;&nbsp;<a href="javascript:self.close()" class="main"><img src="<%= WebUtil.ImageURL %>ep/r_ico_close.gif" width="11" height="11" border="0" align="absmiddle">&nbsp;<spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%>   </a>
          <%  } %>
          </td>
        </tr>
      </table>
<%
    } 
%>
    </td>
  </tr>
</table>
<input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">        
</form>
<form name="form2">
  <input type="hidden" name="jobid"   value="">
  <input type="hidden" name="PERNR"   value="<%= user.empNo %>">
  <input type="hidden" name="GWAJUNG" value="<%= infoData.GWAJUNG %>">
  <input type="hidden" name="GWAID"   value="<%= infoData.GWAID %>"  >
  <input type="hidden" name="CHASU"   value="<%= infoData.CHASU %>"  >
  <input type="hidden" name="CHAID"   value="<%= infoData.CHAID %>"  >
  <input type="hidden" name="SHORT"   value="<%= infoData.SHORT %>"  >
  <input type="hidden" name="BEGDA"   value="<%= infoData.BEGDA %>"  >
  <input type="hidden" name="ENDDA"   value="<%= infoData.ENDDA %>"  >
  <input type="hidden" name="EXTRN"   value="<%= infoData.EXTRN %>"  >
  <input type="hidden" name="KAPZ2"   value="<%= infoData.KAPZ2 %>"  >
  <input type="hidden" name="RESRV"   value="<%= infoData.RESRV %>"  >
  <input type="hidden" name="LOCATE"  value="<%= infoData.LOCATE %>" >
  <input type="hidden" name="BUSEO"   value="<%= infoData.BUSEO %>"  >
  <input type="hidden" name="SDATE"   value="<%= infoData.SDATE %>"  >
  <input type="hidden" name="EDATE"   value="<%= infoData.EDATE %>"  >
  <input type="hidden" name="DELET"   value="<%= infoData.DELET %>"  >
  <input type="hidden" name="PELSU"   value="<%= infoData.PELSU %>"  >
  <input type="hidden" name="GIGWAN"  value="<%= infoData.GIGWAN %>" >
  <input type="hidden" name="IKOST"   value="<%= infoData.IKOST %>"  >
  <input type="hidden" name="STATE"   value="<%= infoData.STATE %>"  >

  <input type="hidden" name="page"          value="">
  <input type="hidden" name="I_FDATE"       value="<%= key.I_FDATE %>">
  <input type="hidden" name="I_TDATE"       value="<%= key.I_TDATE %>">
  <input type="hidden" name="I_BUSEO"       value="<%= key.I_BUSEO %>">
  <input type="hidden" name="I_GROUP"       value="<%= key.I_GROUP %>">
  <input type="hidden" name="I_LOCATE"      value="<%= key.I_LOCATE %>">
  <input type="hidden" name="I_DESCRIPTION" value="<%= key.I_DESCRIPTION %>">
  <input type="hidden" name="SSNO"   value="<%=DataUtil.encodeEmpNo(user.empNo)%>">
  <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
</form>

<%@ include file="/web/common/commonEnd.jsp" %>

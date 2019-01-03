<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 수강신청현황                                                */
/*   Program Name : 수강신청현황                                                */
/*   Program ID   : C06TakeDetail.jsp                                           */
/*   Description  : 수강신청현황 과정 상세조회                                  */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-28  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>

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
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

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
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">과정 상세조회</td>
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
		      <table width="780" border="0" cellspacing="1" cellpadding="10" class="table02">
		        <tr> 
		          <td class="tr01"> 
		            <table width="760" border="0" cellspacing="1" cellpadding="0" class="table02">
		              <tr> 
		                <td width="100" class="td01">교육분야</td>
		                <td width="280" class="td09"><%= eventData.ZGROUP %></td>
		                <td width="100" class="td01">과정명</td>
		                <td class="td09" colspan="3"><%= eventData.GWAJUNG %></td>
		              </tr>
		              <tr> 
		                <td class="td01">차수명</td>
		                <td class="td09"><%= infoData.CHASU %></td>
		                <td class="td01">차수ID</td>
		                <td class="td09" width="100"><%= infoData.CHAID %></td>
		                <td class="td01" width="90">진급필수</td>
		                <td class="td09" width="110"><%= eventData.PELSU %></td>
		              </tr>
		              <tr> 
		                <td class="td01">구분</td>
		                <td class="td09"><%= infoData.EXTRN %></td>
		                <td class="td01">사외교육기관명</td>
		                <td class="td09" colspan="3"><%= infoData.GIGWAN %></td>
		              </tr>
		              <tr> 
		                <td class="td01">개요</td>
		                <td class="td09" colspan="5"><%= subtype1.toString() %></td>
		        	  </tr>
		              <tr> 
		                <td class="td01">목표</td>
		                <td class="td09" colspan="5"> <%= subtype2.toString() %></td>
		              </tr>
		              <tr> 
		                <td class="td01">교육내용</td>
		                <td class="td09" colspan="5"><%= subtype3.toString() %></td>
		              </tr>
		              <tr> 
		                <td class="td01">추천직무</td>
		                <td class="td09" colspan="5"><%= eventData.JIKMU %></td>
		              </tr>
		              <tr> 
		                <td class="td01">선이수 과정</td>
		                <td class="td09" colspan="5"><%= curse.toString() %></td>
		              </tr>
		              <tr> 
		                <td class="td01">선수 자격요건</td>
		                <td class="td09"><%= getText.toString() %></td>
		                <td class="td01">Level</td>
		                <td class="td09" colspan="3"><%= getLevel.toString() %></td>
		              </tr>
		              <tr> 
		                <td class="td01">자격요건 획득</td>
		                <td class="td09"><%= grentText.toString() %></td>
		                <td class="td01">Level</td>
		                <td class="td09" colspan="3"><%= getLevel.toString() %></td>
		              </tr>
		              <tr> 
		                <td class="td01">교육일정</td>
		                <td class="td09"><%= WebUtil.printDate(infoData.BEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(infoData.BEGDA,".") + " ~ " %><%= WebUtil.printDate(infoData.ENDDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(infoData.ENDDA,".") %></td>
		                <td class="td01">교육장소</td>
		                <td class="td09" colspan="3"><%= infoData.LOCATE %></td>
		              </tr>
		              <tr> 
		                <td class="td01">가격</td>
		                <td class="td09"><%=WebUtil.printNumFormat( infoData.IKOST )%>원</td>
		                <td class="td01">교육인원</td>
		                <td class="td09" colspan="3"><%= infoData.KAPZ2 %>명</td>
		              </tr>
		              <tr> 
		                <td class="td01">주관부서</td>
		                <td class="td09"><%= infoData.BUSEO %></td>
		                <td class="td01">담당자</td>
		                <td class="td09"><%= eventData.ENAME %></td>
		                <td class="td01">전화</td>
		                <td class="td09"><%= eventData.TELNO %></td>
		              </tr>
		              <tr> 
		                <td class="td01">기타</td>
		                <td class="td09" colspan="5"><%= subtype4.toString() %></td>
		              </tr>
		              <tr> 
		                <td class="td01">첨부파일</td>
		                <td class="td09" colspan="5"><%= new C02CurriFileLinkRFC().getLink(infoData.CHAID) %></td>
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
		        <tr> 
		          <td align="center">
		            <a href="javascript:history.back()"><img src="<%= WebUtil.ImageURL %>btn_prevview.gif" align="absmiddle" border="0"></a> 
		          </td>
		        </tr>
		      </table>
		    </td>
		  </tr>
</form>
</table>
<%@ include file="/web/common/commonEnd.jsp" %>

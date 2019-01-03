<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 안내                                               */
/*   Program ID   : C02CurriNotice.jsp                                          */
/*   Description  : 교육과정 안내 정보를 가져오는 화면                          */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  박영락                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.C.C02Curri.*" %>
<%@ page import="hris.C.C02Curri.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
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

    String PERNR = (String)request.getAttribute("PERNR");

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
    if( check_data() ) {
        buttonDisabled();
        document.form2.jobid.value = "first";
        document.form2.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriBuildSV";
        document.form2.method = "post";
        document.form2.submit();
    }
}

function goBack(){
    document.form3.jobid.value = "goBack";
    document.form3.action = "<%= WebUtil.ServletURL %>hris.C.C02Curri.C02CurriInfoListSV";
    document.form3.method = "post";
    document.form3.submit();
}

function check_data() {
    if ( <%= (checkString.toString()).equals("") ? "false" : "true" %> ){
    //if( confirm("<%= (checkString.toString()).equals("") ? "" : (checkString.toString()).substring( 1, (checkString.toString()).length()-2 ) %>에 대한 요건이 부족합니다.\n계속신청하시겠습니까?") ){
    //return true
    //}
        if( confirm( "선이수에대한 요건이 부족합니다.\n계속 신청하시겠습니까?") ){
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">
<input type="hidden" name = "PERNR" value="<%=PERNR%>">

<div class="subWrapper">

    <div class="title"><h1>교육과정 안내</h1></div>

<%
    if ("Y".equals(user.e_representative) ) {
%>
    <!--   사원검색 보여주는 부분 시작   -->
    <%@ include file="/web/common/PersonInfo.jsp" %>
    <!--   사원검색 보여주는 부분  끝    -->
<%
    }
%>
          <%
    if( eventData.ZGROUP == null && eventData.GWAJUNG == null ) {
%>

    <div calss="align_center">
        <p>현재 수강 신청이 가능한 차수가 아닙니다.</p>
    </div>

    <div class="buttonArea">
        <ul class="btn_crud">
<%
     if( user.e_learning.equals("") ){
%>
            <li><a href="javascript:history.back();" ><span>목록</span></a></li>
<%
     } else {
%>
            <li><a href="<%= RequestPageName %>" ><span>목록</span></a></li>
<%
      }
%>
        </ul>
    </div>

<%
    } else {
%>

    <!--검색 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>교육분야</th>
                    <td><%= eventData.ZGROUP %></td>
                    <th class="th02">과정명</th>
                    <td colspan="3"><%= eventData.GWAJUNG %></td>
                </tr>
                <tr>
                    <th>차수명</th>
                    <td><%= infoData.CHASU %></td>
                    <th class="th02">차수ID</th>
                    <td><%= infoData.CHAID %></td>
                    <th class="th02">진급필수</th>
                    <td><%= (infoData.DELET).equals("X") ? "&nbsp;" : (infoData.PELSU).equals("") ? "&nbsp;" : eventData.PELSU %></td>
                </tr>
                <tr>
                    <th>구분</th>
                    <td><%= infoData.EXTRN %></td>
                    <th class="th02">사외교육기관명</td>
                    <td><%= infoData.GIGWAN %></td>
                </tr>
                <tr>
                    <th>개요</th>
                    <td colspan="5"> <p> <%= subtype1.toString() %> </p></td>
                </tr>
                <tr>
                    <th>목표</th>
                    <td colspan="5"> <p> <%= subtype2.toString() %> </p></td>
                </tr>
                <tr>
                    <th>교육내용</th>
                    <td colspan="5"> <p> <%= subtype3.toString() %> </p></td>
                </tr>
                <tr>
                    <th>추천직무</th>
                    <td colspan="5"><%= eventData.JIKMU %></td>
                </tr>
                <tr>
                    <th>선이수 과정</th>
                    <td colspan="5"><%= curse.toString() %></td>
                </tr>
                <tr>
                    <th>선수 자격요건</th>
                    <td><%= grentText.toString() %></td>
                    <th class="th02">Level</td>
                    <td colspan="3"><%= grentLevel.toString() %></td>
                </tr>
                <tr>
                    <th>자격요건 획득</th>
                    <td><%= getText.toString() %></td>
                    <th class="th02">Level</th>
                    <td colspan="3"><%= getLevel.toString() %></td>
                </tr>
                <tr>
                    <th>교육일정</th>
                    <td><%= WebUtil.printDate(infoData.BEGDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(infoData.BEGDA,".") + " ~ " %><%= WebUtil.printDate(infoData.ENDDA,".").equals("0000.00.00") ? "" : WebUtil.printDate(infoData.ENDDA,".") %></td>
                    <th class="th02">교육장소</th>
                    <td colspan="3"><%= infoData.LOCATE %></td>
                </tr>
                <tr>
                    <th>가격</th>
                    <td><%=WebUtil.printNumFormat( infoData.IKOST )%>원</td>
                    <th class="th02">교육인원</th>
                    <td colspan="3"><%= infoData.KAPZ2 %>명</td>
                </tr>
                <tr>
                    <th>주관부서</th>
                    <td><%= infoData.BUSEO %></td>
                    <th class="th02">담당자</th>
                    <td><%= eventData.ENAME %></td>
                    <th class="th02">전화</th>
                    <td><%= eventData.TELNO %></td>
                </tr>
                <tr>
                    <th>기타</th>
                    <td colspan="5"> <p> <%= subtype4.toString() %> </p></td>
                </tr>
                <tr>
                    <th>첨부파일</th>
                    <td colspan="5"> <p> <%= new C02CurriFileLinkRFC().getLink(infoData.CHAID) %> </p></td>
                </tr>
            </table>
        </div>
    </div>
    <!--검색 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
<%  if( infoData.STATE.equals("접수중") ){   //테스트 %>
            <li id="sc_button"><a class="darken" href="javascript:doSubmit();" ><span>신청</span></a></li>
<%  } %>
<%  if( user.e_learning.equals("") ){ %>
            <li><a href="javascript:history.back();" ><span>목록</span></a></li>
<%  } else { %>
            <li><a href="<%=RequestPageName%>" ><span>목록</span></a></li>
          <%  } %>
        </ul>
    </div>

<%
    }
%>


    </div>
    <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
  </form>
  <form name="form2">
      <input type="hidden" name="jobid"   value="">
      <input type="hidden" name="PERNR"   value="<%= PERNR %>">
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
    <input type="hidden" name="RequestPageName"   value="<%=RequestPageName%>">
  </form>



<%@ include file="/web/common/commonEnd.jsp" %>

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인재개발 협의결과 조회                                      */
/*   Program Name : 인재개발 협의결과 조회                                      */
/*   Program ID   : B03DevelopDetail.jsp                                        */
/*   Description  : 사원의 인재개발 협의결과 조회List                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2002-01-29  이형석                                          */
/*   Update       : 2003-06-23  최영호                                          */
/*                  2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector      B03DevelopDetail_vt = (Vector)request.getAttribute("B03DevelopDetail_vt") ;
    String      BEGDA               = (String)request.getAttribute("begDa");
    String      command             = (String)request.getAttribute("command");
    WebUserData user = WebUtil.getSessionUser(request);

    B03DevelopData data = (B03DevelopData)B03DevelopDetail_vt.get(Integer.parseInt(command));
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function goDetail(){
    document.form2.jobid.value = "detailD_1";
    document.form2.begDa.value = '<%= BEGDA %>';
    document.form2.seqnr.value = '<%= data.SEQNR %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopListSV' ;
    document.form2.method = 'get' ;
    document.form2.submit() ;
}
//-->
</SCRIPT></head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과 상세조회</h1></div>

    <!--리스트 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
<%
B03DevelopData developDetailData = (B03DevelopData)B03DevelopDetail_vt.get(Integer.parseInt(command));
%>
<%      if (user.companyCode.equals("N100")) { %>
                <tr>
                    <th>협의일</th>
                    <td name="BEGDA" id="BEGDA" colspan="3"><%= DataUtil.removeStructur(developDetailData.BEGDA,"-",".") %></td>
                </tr>
                <tr>
                    <th>위원장</th>
                    <td colspan="3"><%= developDetailData.COMM_NAME %></td>
                </tr>
<%      }else{       %>
                <tr>
                    <th>협의일</th>
                    <td name="BEGDA" id="BEGDA"><%= DataUtil.removeStructur(developDetailData.BEGDA,"-",".") %></td>
                    <th class="th02">본인F/B여부</th>
                    <td><input type="checkbox" name="SELF_FLAG" value="X"   <%= developDetailData.SELF_FLAG.equals("X") ? "checked" : "" %> disabled></td>
                </tr>
                <tr>
                    <th>위원장</th>
                    <td colspan="3"><%= developDetailData.COMM_NAME %></td>
                </tr>
<%      }            %>
                <tr>
                    <th>인재위</th>
                    <td colspan="3"><%= developDetailData.SECT_TEXT %></td>
                </tr>
<%     if (user.companyCode.equals("N100")) { %>
                <tr>
                    <th>우수한점</th>
                    <td colspan="3"><%= developDetailData.EXL1_PONT %>
                <% if (developDetailData.EXL2_PONT != null) { %>
                    <br><%= developDetailData.EXL2_PONT %>
                <% } %>
                    </td>
                </tr>
<%     }     %>
<%     if (user.companyCode.equals("C100")) { %>
                <tr>
                    <th>육성POST</th>
                    <td colspan="3"><%= developDetailData.UPBR_POST %>
                </tr>
<%     }     %>
                <tr>
                    <th>육성방향</th>
                    <td colspan="3"><%= developDetailData.UPB1_CRSE %>
                        <% if (developDetailData.UPB2_CRSE != null) { %>
                            <br><%= developDetailData.UPB2_CRSE %>
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <th>종합의견</th>
                    <td colspan="3"><%= developDetailData.CMT1_TEXT %>
                        <% if (developDetailData.CMT2_TEXT != null){ %><br><%= developDetailData.CMT2_TEXT %><%}%>
                        <% if (developDetailData.CMT3_TEXT != null){ %><br><%= developDetailData.CMT3_TEXT %><%}%>
                        <% if (developDetailData.CMT4_TEXT != null){ %><br><%= developDetailData.CMT4_TEXT %><%}%>
                        <% if (developDetailData.CMT5_TEXT != null){ %><br><%= developDetailData.CMT5_TEXT %><%}%>
                        <% if (developDetailData.CMT6_TEXT != null){ %><br><%= developDetailData.CMT6_TEXT %><%}%>
                    </td>
                </tr>
                <tr>
                    <th>기타사항</th>
                    <td colspan="3"><%= developDetailData.ETC1_TEXT %>
                        <% if (developDetailData.ETC2_TEXT != null) { %>
                            <br><%= developDetailData.ETC2_TEXT %>
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <th>육성책 협의결과F/U</th>
                    <td colspan="3"><%= developDetailData.FUP1_TEXT %>
                        <% if (developDetailData.FUP2_TEXT != null) { %>
                            <br><%= developDetailData.FUP2_TEXT %>
                        <% } %>
                    </td>
                </tr>
                <%-- if (user.companyCode.equals("N100")) { --%>
                <tr>
                    <th>위 원</th>
                    <td><%= developDetailData.COM1_NAME %></td>
                    <th class="th02">위 원</th>
                    <td><%= developDetailData.COM2_NAME %></td>
                </tr>
                <tr>
                    <th>위 원</th>
                    <td><%= developDetailData.COM3_NAME %></td>
                    <th class="th02">간 사</th>
                    <td><%= developDetailData.COM4_NAME %></td>
                </tr>
<%-- } --%>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:goDetail();"><span>경력/교육개발</span></a></li>
            <li><a href="javascript:history.back();"><span>목록</span></a></li>
        </ul>
    </div>

  </div>
</form>
<form name="form2">
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="begDa" value="">
    <input type="hidden" name="seqnr" value="">
</form>

<%@ include file="/web/common/commonEnd.jsp" %>

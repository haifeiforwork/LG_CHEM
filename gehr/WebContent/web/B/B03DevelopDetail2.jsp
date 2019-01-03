<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인재개발협의결과입력                                        */
/*   Program Name : 인재개발 협의결과 - 경력/교육개발                           */
/*   Program ID   : B03DevelogDetail2.jsp                                       */
/*   Description  : 인재개발 협의결과 - 경력/교육개발 화면                      */
/*   Note         : 없음                                                        */
/*   Creation     : 최영호                                                      */
/*   Update       : 2005-01-26  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector B03DevelopDetail2_vt = (Vector)request.getAttribute("B03DevelopDetail2_vt");
    String begDa = (String)request.getAttribute("begDa");

    String empNo = (String)request.getAttribute("empNo");
    String ORGTX = (String)request.getAttribute("ORGTX");
    String TITEL = (String)request.getAttribute("TITEL");
    String TITL2 = (String)request.getAttribute("TITL2");
    String ENAME = (String)request.getAttribute("ENAME");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과 - 경력/교육개발</h1></div>

    <div class="tableInquiry">
        <table>
            <tr>
                <th>선택구분</th>
                <td>
                    <select name="I_GUBUN" onChange="javascript:gubun_change()">
                        <option value="2" >성명별</option>
                        <option value="1" >사번별</option>
                    </select>
                    <input type="text"   name="I_VALUE1" size="10"  maxlength="10" value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                    <input type="hidden" name="jobid" value="">
                    <input type="hidden" name="empNo" value="">
                    <input type="hidden" name="I_DEPT"    value="">
                    <input type="hidden" name="E_RETIR"   value="">
                    <input type="hidden" name="retir_chk" value="">
                    <input type="hidden" name="page"      value="">
                    <input type="hidden" name="count"     value="">
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:opensawon();"><span>사원찾기</span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                <tr>
                    <th>부서</th>
                    <td><input size="30" style="border-width:0;text-align:left" type="text" name="ORGTX" value="<%= ORGTX == null ? "" : ORGTX %>" readonly></td>
                    <th class="th02">직위</th>
                    <td><input size="20" style="border-width:0;text-align:left" type="text" name="TITEL" value="<%= TITEL == null ? "" : TITEL %>" readonly></td>
                    <th class="th02">직책</th>
                    <td><input size="20" style="border-width:0;text-align:left" type="text" name="TITL2" value="<%= TITL2 == null ? "" : TITL2 %>" readonly></td>
                    <th class="th02">성명</th>
                    <td>
                        <input size="8" style="border-width:0;text-align:left" type="text" name="ENAME" value="<%= ENAME == null ? "" : ENAME %>" readonly>
                        <input size="9" style="border-width:0;text-align:left" type="text" name="EMPNO2" value="<%= !empNo.equals("") ? "(" : "" %><%= empNo == null ? "" : empNo %><%= !empNo.equals("") ? ")" : "" %>" readonly>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!--리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>구분</th>
                    <th>년도</th>
                    <th>시기</th>
                    <th>직무/교육명</th>
                    <th>상태</th>
                    <th class="lastCol">비고</th>
                </tr>
<%
    if( B03DevelopDetail2_vt.size() > 0 ) {
        for ( int i = 0 ; i < B03DevelopDetail2_vt.size() ; i++ ) {
            B03DevelopData2 developDetailData = (B03DevelopData2)B03DevelopDetail2_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td><% if(developDetailData.DEVP_TYPE.equals("01")){ %>경력<% } %>
                                   <% if(developDetailData.DEVP_TYPE.equals("02")){ %>교육<% } %></td>
                    <td><%= developDetailData.DEVP_YEAR %></td>
                    <td><% if(developDetailData.DEVP_MNTH.equals("01")){ %>상반기<% } %>
                                   <% if(developDetailData.DEVP_MNTH.equals("02")){ %>하반기<% } %>
                                   <% if(developDetailData.DEVP_MNTH.equals("03")){ %>1/4분기<% } %>
                                   <% if(developDetailData.DEVP_MNTH.equals("04")){ %>2/4분기<% } %>
                                   <% if(developDetailData.DEVP_MNTH.equals("05")){ %>3/4분기<% } %>
                                   <% if(developDetailData.DEVP_MNTH.equals("06")){ %>4/4분기<% } %></td>
                    <td><%= developDetailData.DEVP_TEXT %></td>
                    <td><% if(developDetailData.DEVP_STAT.equals("01")){ %>계획<% } %>
                                   <% if(developDetailData.DEVP_STAT.equals("02")){ %>현재<% } %>
                                   <% if(developDetailData.DEVP_STAT.equals("03")){ %>완료<% } %></td>
                    <td class="lastCol"><%= developDetailData.RMRK_TEXT %></td>
                </tr>
<%
        }
    } else {
%>
                <tr class="oddRow">
                    <td class="lastCor" colspan="6">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
<%
    }
%>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back();"><span>이전화면</span></a></li>
        </ul>
    </div>

  </div>
</form>
<form name="form2">
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="begDa" value="">
</form>

<%@ include file="/web/common/commonEnd.jsp" %>

<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 교육이력                                                    */
/*   Program Name : 교육이력                                                    */
/*   Program ID   : C04HrdLearnDetail_m.jsp                                     */
/*   Description  : 교육 이력 조회                                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       : 2008-09-19  lsa [CSR ID:1331138]                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.C.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);
    String pernr       = (String)request.getParameter("pernr");
    String IM_SORTKEY = (String)request.getParameter("IM_SORTKEY");
    String IM_SORTDIR = (String)request.getParameter("IM_SORTDIR");

    Vector C04HrdLearnDetailData_vt = ( Vector ) request.getAttribute( "C04HrdLearnDetailData_vt" ) ;
   // C04HrdLearnDetailData_vt = com.sns.jdf.util.SortUtil.sort( C04HrdLearnDetailData_vt, "3", "desc" ) ;
%>



<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<SCRIPT LANGUAGE="JavaScript">
<!--
function  doSearchDetail() {

    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04HrdLearnDetailSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
function doSort(key) {
    var vObj = document.form1;

    vObj.IM_SORTKEY.value = key;
    if(vObj.IM_SORTDIR.value=="DES") {
        vObj.IM_SORTDIR.value = "ASC";
    } else {
        vObj.IM_SORTDIR.value = "DES";
    }

    vObj.jobid2.value = "wait_detail";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04HrdLearnDetailSV_m";
    document.form1.method = "post";
    document.form1.submit();
}
//Execl Down 하기.
function excelDown() {

    var vObj = document.form1;

    vObj.target = "ifHidden";
    vObj.jobid2.value = "excel";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.C.C04HrdLearnDetailSV_m";
    document.form1.method = "post";
    document.form1.submit();

}

//-->
</SCRIPT>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
<div class="subWrapper">

    <div class="title"><h1>교육이력 조회</h1></div>

<%
// 사원 검색한 사람이 없을때
if ( user_m == null ) {
%>

    <!--교육이수현황 리스트 테이블 시작-->
    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><font color="#006699">※ Y : 이수, N : 미이수</font></span>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:excelDown();"><span>Excel Download</span></a></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <div class="table">
            <table class="listTable">
                <tr>
                  <th onClick="doSort('STEXT_D')" style="cursor:hand">과정명
                  <%= IM_SORTKEY.equals("STEXT_D") ? IM_SORTDIR.equals("DES") ? "<font color='#FF0000'><b>▼</b></font>"
                  : "<font color='#FF0000'><b>▲</b></font>"
                  : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                  </th>
                  <th onClick="doSort('STEXT_E')" style="cursor:hand">차수명
                  <%= IM_SORTKEY.equals("STEXT_E") ? IM_SORTDIR.equals("DES") ? "<font color='#FF0000'><b>▼</b></font>"
                  : "<font color='#FF0000'><b>▲</b></font>"
                  : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                  </th>
                  <th onClick="doSort('BEGDA')" style="cursor:hand">교육기간
                  <%= IM_SORTKEY.equals("BEGDA") ? IM_SORTDIR.equals("DES") ? "<font color='#FF0000'><b>▼</b></font>"
                  : "<font color='#FF0000'><b>▲</b></font>"
                  : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                  </th>
                  <th onClick="doSort('MC_STEXT')" style="cursor:hand">주관부서
                  <%= IM_SORTKEY.equals("MC_STEXT") ? IM_SORTDIR.equals("DES") ? "<font color='#FF0000'><b>▼</b></font>"
                  : "<font color='#FF0000'><b>▲</b></font>"
                  : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                  </th>
                  <th onClick="doSort('FLAG1')" style="cursor:hand">이수
                  <%= IM_SORTKEY.equals("FLAG1") ? IM_SORTDIR.equals("DES") ? "<font color='#FF0000'><b>▼</b></font>"
                  : "<font color='#FF0000'><b>▲</b></font>"
                  : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                  </th>
                  <th onClick="doSort('PYONGGA')" style="cursor:hand">평가
                  <%= IM_SORTKEY.equals("PYONGGA") ? IM_SORTDIR.equals("DES") ? "<font color='#FF0000'><b>▼</b></font>"
                  : "<font color='#FF0000'><b>▲</b></font>"
                  : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                  </th>
                  <th onClick="doSort('STEXT_N')" style="cursor:hand">필수과정
                  <%= IM_SORTKEY.equals("STEXT_N") ? IM_SORTDIR.equals("DES") ? "<font color='#FF0000'><b>▼</b></font>"
                  : "<font color='#FF0000'><b>▲</b></font>"
                  : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                  </th>
                  <th class="lastCol" onClick="doSort('CODE_NAME')" style="cursor:hand">교육형태
                  <%= IM_SORTKEY.equals("CODE_NAME") ? IM_SORTDIR.equals("DES") ? "<font color='#FF0000'><b>▼</b></font>"
                  : "<font color='#FF0000'><b>▲</b></font>"
                  : "<img src=" + WebUtil.ImageURL + "icon_arrow_top.gif  border='0' align='absmiddle'>" %>
                  </th>


                </tr>
                <%
    if( C04HrdLearnDetailData_vt.size() > 0 ) {
        for ( int i = 0 ; i < C04HrdLearnDetailData_vt.size() ; i++ ) {
            C03LearnDetailData learnDetailData = ( C03LearnDetailData ) C04HrdLearnDetailData_vt.get( i ) ;

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }

            if(!learnDetailData.FLAG1.equals("")) {
%>
                <tr class="<%=tr_class%>">
                  <td class="align_left"><%= learnDetailData.STEXT_D %></td>
                  <td class="align_left"><%= learnDetailData.STEXT_E %></td>
                  <td><%= learnDetailData.PERIOD    %></td>
                  <td class="align_left"><%= learnDetailData.MC_STEXT  %></td>
                  <td><%= learnDetailData.FLAG1     %></td>
                  <td><%= learnDetailData.PYONGGA   %></td>
                  <!--<td class="td04"><%= learnDetailData.FLAG2.equals("N") ? "" : learnDetailData.FLAG2 %></td>-->
                  <td><%= learnDetailData.STEXT_N %></td>
                  <td class="lastCol"><%= learnDetailData.CODE_NAME %></td>
                </tr>
                <%
            }
        }
    } else {
%>
                <tr class="oddRow">
                  <td class="lastCol" colspan="7">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
                <%
    }
%>
            </table>
        </div>
    </div>
    <!--교육이수현황 리스트 테이블 끝-->

</div>
<%
}
%>
<input type="hidden" name="jobid2" value="wait_detail">
<input type="hidden" name="pernr" value="<%=pernr%>">
<input type="hidden" name="IM_SORTKEY" value="<%=IM_SORTKEY%>">
<input type="hidden" name="IM_SORTDIR" value="<%=IM_SORTDIR%>">
</form>
<iframe name="ifHidden" width="0" height="0" />
<%@ include file="/web/common/commonEnd.jsp" %>
</body>
</html>

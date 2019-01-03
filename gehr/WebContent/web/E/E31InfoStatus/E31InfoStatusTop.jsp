<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회가입현황(간사용)                                      */
/*   Program Name : 동호회가입현황(간사용)                                      */
/*   Program ID   : E31InfoStatusTop.jsp                                        */
/*   Description  : 동호회가입현황(간사용)                                      */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E31InfoStatus.*" %>
<%@ page import="hris.E.E31InfoStatus.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    int year  = Integer.parseInt( DataUtil.getCurrentYear() ) ;  // 년
    int month = Integer.parseInt( DataUtil.getCurrentMonth() );  // 월

    int startYear = 2002;
    int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

//  2003.01.02. - 12월일때만 endYear에 + 1년을 해준다.
    if( month == 12 ) {
        endYear = Integer.parseInt( DataUtil.getCurrentYear() ) + 1;
    }

    if( ( endYear - startYear ) > 10 ){
        startYear = endYear - 10;
    }

    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    E31InfoStatusRFC  rfc             = new E31InfoStatusRFC();
    E31InfoNameData   e31InfoNameData = null;

    Vector returnAll_vt         = null;
    Vector E31InfoNameData_vt   = null;
    Vector E31InfoMemberData_vt = null;

    String currDate = DataUtil.getCurrentDate().substring(0,6);

    returnAll_vt       = rfc.detail(user.empNo, "", "2", currDate);
    E31InfoNameData_vt = (Vector)returnAll_vt.get(0);
%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
function showList() {

    document.form1.jobid.value = "search";
    document.form1.YEAR.value  = document.form1.YEAR.options[document.form1.YEAR.selectedIndex].text;
    document.form1.MONTH.value = document.form1.MONTH.options[document.form1.MONTH.selectedIndex].text;
    document.form1.MGART.value = document.form1.MGART.options[document.form1.MGART.selectedIndex].value;
    document.form1.STEXT.value = document.form1.MGART.options[document.form1.MGART.selectedIndex].text;
    document.form1.INFTY.value = document.form1.INFTY.options[document.form1.INFTY.selectedIndex].value;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E31InfoStatus.E31InfoStatusListSV";
    document.form1.target = "endPage";
    document.form1.method = "post";
    document.form1.submit();
}

function on_first() { // 처음 들어왔을때
<%
    int inx = 2;
    for( int i = 0 ; i < E31InfoNameData_vt.size() ; i++ ) {
        E31InfoNameData data = (E31InfoNameData)E31InfoNameData_vt.get(i);
%>
        document.form1.MGART.length = <%= inx %>;
        document.form1.MGART[<%= inx-1 %>].value = "<%=data.MGART%>";
        document.form1.MGART[<%= inx-1 %>].text  = "<%=data.STEXT%>";
<%
        inx++;
    }
%>
    document.form1.MGART[0].selected = true;
}

function view_Rela() {

    document.form1.jobid.value = "hidden";
    document.form1.YEAR.value  = document.form1.YEAR.options[document.form1.YEAR.selectedIndex].text;
    document.form1.MONTH.value = document.form1.MONTH.options[document.form1.MONTH.selectedIndex].text;
    document.form1.MGART.value = document.form1.MGART.options[document.form1.MGART.selectedIndex].value;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E31InfoStatus.E31InfoStatusListSV";
    document.form1.target = "hidden";
    document.form1.method = "post";
    document.form1.submit();
}

$(function() {
	on_first();
});
//-->
</script>


    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="title" value="COMMON.MENU.ESS_BE_INFO_STAT_MGT"/>
        <jsp:param name="always" value="true"/>
    </jsp:include>
<form name="form1" method="post">
    <!--조회년월 검색 테이블 시작-->
    <div class="tableInquiry">
        <table>
        	<colgroup>
        		<col width="20%" />
        		<col width="15%" />
        		<col width="10%" />
        		<col />
        	</colgroup>
            <tr>
                <th>
                	<img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
                	<!-- 조회년월 --><%=g.getMessage("LABEL.E.E13.0001")%>
                </th>
                <td>
                    <select name="YEAR"  onChange="javascript:view_Rela(this);">
<%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%>
                    </select>
                    <select name="MONTH" onChange="javascript:view_Rela(this);">
                        <option value="<%=g.getMessage("LABEL.E.E13.0002")%>"><!-- 전체 --><%=g.getMessage("LABEL.E.E13.0002")%></option>
<%
    for( int i = 1 ; i < 13 ; i++ ) {
%>
                        <option value="<%= i %>" <%= i == month ? "selected" : "" %> ><%= i %></option>
<%
    }
%>
                    </select>
                </td>
                <th><!-- 동호회 --><%=g.getMessage("LABEL.E.E13.0003")%></th>
                <td>
                    <select name="MGART">
                        <option value="ALL"><!-- 전체 --><%=g.getMessage("LABEL.E.E13.0002")%></option>
                    </select>
                    <select name="INFTY">
                        <option value="2"><!-- 전체 --><%=g.getMessage("LABEL.E.E13.0002")%></option>
                        <option value="0"><!-- 가입자 --><%=g.getMessage("LABEL.E.E13.0004")%></option>
                        <option value="1"><!-- 탈퇴자 --><%=g.getMessage("LABEL.E.E13.0005")%></option>
                    </select>
	                <div class="tableBtnSearch tableBtnSearch2">
	                	<a class="search" href="javascript:showList();"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
	                </div>
                </td>
                <!-- <td width="80" class="td02"><a href="javascript:showList();"><img src="<%= WebUtil.ImageURL %>btn_serch02.gif" border="0" align="absmiddle"></a></td> -->
            </tr>
        </table>
    </div>
    <!--조회년월 검색 테이블 끝-->
<input type="hidden" name="jobid" value="">
<input type="hidden" name="STEXT" value="">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
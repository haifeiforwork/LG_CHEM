<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 학교검색창                                                  */
/*   Program ID   : SearchSchoolPop.jsp                                    */
/*   Description  : 학교검색 창                                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2014-10-23  SJY                                          */
/*   Update       :  최초생성 [CSR ID:2634836] 학자금 신청 시스템 개발 요청           */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData user          = (WebUserData)session.getAttribute("user");
    boolean isFirst              = true;
    Vector  SchoolData_vt	  = new Vector();
    long    l_count              = 0;
    String  count                 = request.getParameter("count");
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }

    String i_pernr    	= WebUtil.nvl(request.getParameter("P_PERNR"));
    String i_ename 	= WebUtil.nvl(request.getParameter("i_ename"));
    String i_shool    	= WebUtil.nvl(request.getParameter("i_shool"));
    String  paging      = request.getParameter("page");
    if(paging == null ) {

        try{
            SchoolData_vt = ( new SchoolRFC() ).getSchool(i_pernr, i_ename, i_shool);

            l_count = SchoolData_vt.size();
        }catch(Exception ex){
        	SchoolData_vt = null;
        }

        isFirst = false;

    } else if(paging != null ) {

        isFirst = false;

        for( int i = 0 ; i < l_count ; i++ ) {
            SchoolData schoolData = new SchoolData();
			schoolData.SCHCODE = WebUtil.nvl(request.getParameter("SCHCODE"+i));    // 학교코드
            schoolData.SCHTYPE = WebUtil.nvl(request.getParameter("SCHTYPE"+i));    // 학교타입
            schoolData.SCHNAME = WebUtil.nvl(request.getParameter("SCHNAME"+i));    // 학교이름
            schoolData.SCHBR 	= WebUtil.nvl(request.getParameter("SCHBR"+i));    // 본분교
            schoolData.SCHEST 	= WebUtil.nvl(request.getParameter("SCHEST"+i));    // 설립구분
            schoolData.SCHREG =WebUtil.nvl( request.getParameter("SCHREG"+i));    // 지역
            schoolData.SCHBEGDA = WebUtil.nvl(request.getParameter("SCHBEGDA"+i));    // 시작일
            schoolData.SCGENDDA = WebUtil.nvl(request.getParameter("SCGENDDA"+i));    // 종료일
            SchoolData_vt.addElement(schoolData);
        }
    }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
  	PageUtil pu = null;
	try {
		pu = new PageUtil(SchoolData_vt.size(), paging , 10, 10);
		Logger.debug.println(this, "page : "+paging);
	} catch (Exception ex) {
		Logger.debug.println(DataUtil.getStackTrace(ex));
	}
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
function init(){
<%
    if( SchoolData_vt != null ) {
        if( SchoolData_vt.size() == 1 ) {
        	SchoolData data = (SchoolData)SchoolData_vt.get(0);
%>

    changeAppData("<%= data.SCHCODE %>", "<%= data.SCHNAME%>");

<%
        }
    }
%>
}

function PageMove() {
    document.form1.action = "<%=WebUtil.JspURL%>"+"common/SearchSchoolPop.jsp";
    document.form1.submit();
}

function changeAppData(sch_code , sch_name){
    opener.document.form1.SCHCODE.value   = sch_code;
    opener.document.form1.FASIN.value   = sch_name;
    close();
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
//-->
</SCRIPT>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init()" >
<div class="winPop dvMinheight">
    <div class="header">
        <span><spring:message code="LABEL.COMMON.0031" /></span>
        <a href="javascript:void(0);" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" alt="팝업닫기" /></a>
    </div>
<div class="body">
<form name="form1" method="post" onsubmit="return false">
	<input type="hidden" name="P_PERNR"   value="<%=i_pernr  %>">
	<input type="hidden" name="i_ename"   value="<%=i_ename  %>">
	<input type="hidden" name="i_shool" value="<%= i_shool %>">
  	<input type="hidden" name="page"     value="">
  	<input type="hidden" name="count"    value="<%= l_count %>">
<%
    if ( SchoolData_vt != null && SchoolData_vt.size() > 0 ) {
%>
          <%= pu == null ? "" : pu.pageInfo() %>
<%
    } else {
%>
<%
    }
%>
<div class="listArea">
	<div class="table">
   		<table class="listTable"   >
   		   	<colgroup>
   			<col width="10"/>
   			<col width="40"/>
   			<col width="15"/>
   			<col width="15"/>
   			<col width="20"/>
   			</colgroup>
   			<thead>
             <tr>
                <th><spring:message code="LABEL.COMMON.0014"/><!-- 선택 --></th>
                <th><spring:message code="LABEL.COMMON.0032"/><!-- 학교명 --></th>
                <th><spring:message code="LABEL.COMMON.0033"/><!-- 본분교 --></th>
                <th><spring:message code="LABEL.COMMON.0034"/><!-- 설립구분 --></th>
                <th class = "lastCol"><spring:message code="LABEL.COMMON.0035"/><!-- 지역 --></th>
			</tr>
			</thead>
<%
   if( !isFirst ){
        if( SchoolData_vt != null && SchoolData_vt.size() > 0 ){
            for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
            	SchoolData schoolData = (SchoolData)SchoolData_vt.get(i);
            	String tr_class = "";

            	if( i % 2 == 0 ){
            		tr_class = "oddRow";
            	}else{
            		tr_class = "";
            	}
%>
              <tr class="<%= tr_class %>">
                <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= schoolData.SCHCODE %>', '<%= schoolData.SCHNAME %>');"></td>
                <td><%=WebUtil.printString( schoolData.SCHNAME)%></td>
                <td><%=WebUtil.printString( schoolData.SCHBR )%></td>
                <td><%=WebUtil.printString( schoolData.SCHEST )%></td>
                <td class="lastCol"><%=WebUtil.printString( schoolData.SCHREG )%></td>
              </tr>
<%
            }
			for( int i = 0 ; i < SchoolData_vt.size(); i++ ) {
				SchoolData schoolData = (SchoolData)SchoolData_vt.get(i);
%>
			  <input type="hidden" name="SCHCODE<%= i %>" value="<%= schoolData.SCHCODE %>">
			  <input type="hidden" name="SCHTYPE<%= i %>" value="<%= schoolData.SCHTYPE %>">
			  <input type="hidden" name="SCHNAME<%= i %>" value="<%= schoolData.SCHNAME %>">
			  <input type="hidden" name="SCHBR<%= i %>" value="<%= schoolData.SCHBR %>">
			  <input type="hidden" name="SCHEST<%= i %>" value="<%= schoolData.SCHEST %>">
			  <input type="hidden" name="SCHREG<%= i %>" value="<%= schoolData.SCHREG %>">
			  <input type="hidden" name="SCHBEGDA<%= i %>" value="<%= schoolData.SCHBEGDA %>">
			  <input type="hidden" name="SCGENDDA<%= i %>" value="<%= schoolData.SCGENDDA %>">


<%
			}
%>
		</table>
	</div>
</div>
<!-- PageUtil 관련 - 반드시 써준다. -->
<%= pu == null ? "" : pu.pageControl() %>
<!-- PageUtil 관련 - 반드시 써준다. -->
<%
        } else {

%>
              <tr class="oddRow">
                <td class="lastCol" colspan="5"><spring:message code="MSG.COMMON.0081"/><!-- 신청하는 학교는 지원대상이 아니므로 해당 사업장 학/장학금 담당자에게  문의하시기 바랍니다. --></td>
              </tr>
		</table>
	</div>
</div>
<%
        }
    }
%>
</form>
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

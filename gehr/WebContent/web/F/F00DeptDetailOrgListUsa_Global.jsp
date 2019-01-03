<%/**********************************************************************************/
/*	  System Name  	: g-HR																													*/
/*   1Depth Name		:                                                  																			*/
/*   2Depth Name  	:                                                     																		*/
/*   Program Name 	:                           																								*/
/*   Program ID   		: F00DeptDetailOrgListUsa.jsp                                       												*/
/*   Description  		: 개인별/조직별 근태 각각의 상세화면 팝업 조회 화면           														*/
/*   Note         		: 없음                                                        																		*/
/*   Creation     		: 2010-11-05 jungin @v1.0																						*/
/***********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.Global.*" %>
<%@ page import="hris.F.rfc.Global.*" %>
<%
	request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");		// 세션

    String pageCode = (String)request.getAttribute("pageCode");
    String gubun = (String)request.getAttribute("gubun");

    String year = (String)request.getAttribute("year");
    String month = (String)request.getAttribute("month");

    String PERNR = (String)request.getAttribute("PERNR");
    String BEGDA = (String)request.getAttribute("BEGDA");
    String ENDDA = (String)request.getAttribute("ENDDA");
    String ABSTY = (String)request.getAttribute("ABSTY");

    String ORGEH = (String)request.getAttribute("ORGEH");
    String checkYN = (String)request.getAttribute("checkYN");

    int l_count = 0;

	// page 처리
    String paging = request.getParameter("page");

    boolean isFirst = false;
   	Vector F00DeptDetailListDataUsa_vt = (Vector)request.getAttribute("F00DeptDetailListDataUsa_vt");    // 내용
    l_count = F00DeptDetailListDataUsa_vt.size();


	// PageUtil 관련 - Page 사용시 반드시 써줄것.
  	PageUtil pu = null;
   	try {
		pu = new PageUtil(F00DeptDetailListDataUsa_vt.size(), paging , 10, 10);
		//
   	} catch (Exception ex) {

   	}
%>
<jsp:include page="/include/header.jsp" />

<SCRIPT LANGUAGE="JavaScript">
<!--

function PageMove_m() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.F.Global.F00DeptDetailListUsaSV";
    document.form1.submit();
}

// PageUtil 관련 script - page처리시 반드시 써준다.
function pageChange(page){
    document.form1.page.value = page;
    PageMove_m();
}

// PageUtil 관련 script - selectBox 사용시 - Option
function selectPage(obj) {
    val = obj[obj.selectedIndex].value;
    pageChange(val);
}

//-->
</SCRIPT>


<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="winPop">
<div class="header">
    	<span>Monthly Time Statement Detail</span>
    	<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
</div>
<div class="body">

<form name="form1" method="post">
<input type="hidden" name="pageCode" value="<%= pageCode %>">
<input type="hidden" name="gubun" value="<%= gubun %>">

<input type="hidden" name="year" value="<%= year %>">
<input type="hidden" name="month" value="<%= month %>">

<input type="hidden" name="PERNR" value="<%= PERNR %>">
<input type="hidden" name="BEGDA" value="<%= BEGDA %>">
<input type="hidden" name="ENDDA" value="<%= ENDDA %>">
<input type="hidden" name="ABSTY" value="<%= ABSTY %>">

<input type="hidden" name="ORGEH" value="<%= ORGEH %>">
<input type="hidden" name="chck_yeno" value="<%= checkYN %>">

  	<div class="listArea" >
			<div class="listTop">

		<%
		    if (F00DeptDetailListDataUsa_vt != null && F00DeptDetailListDataUsa_vt.size() > 0) {
		%>
		<h2 class="subtitle"><%= pu == null ? "" : pu.pageInfo() %></h2>

		<%
		    }
		%>
		</div>
	    <div class="table">
	    	<table class="listTable">
	    	<thead>
          	      <tr align="center">
		          <th  width="90" nowrap><%=g.getMessage("LABEL.F.F41.0004") %><%--Pers. No --%></th>
		          <th  width="170" nowrap><%=g.getMessage("LABEL.F.F41.0005") %><%--Name --%></th>
		          <th  width="200" nowrap><%=g.getMessage("LABEL.F.F51.0009") %><%--Description --%></th>
		          <th  width="90" nowrap><%=g.getMessage("LABEL.F.F43.0082") %><%--Date --%></th>
		          <th class="lastCol" width="90" nowrap><%=g.getMessage("LABEL.D.D07.0005") %><%--Hours --%></th>
              </tr>
            </thead>
				<%
				   if (!isFirst) {
				        if (F00DeptDetailListDataUsa_vt != null && F00DeptDetailListDataUsa_vt.size() > 0){
				            for (int i = pu.formRow(); i < pu.toRow(); i++) {
				            	F00DeptDetailListDataUsa data = (F00DeptDetailListDataUsa)F00DeptDetailListDataUsa_vt.get(i);
				    			int index = i - pu.formRow();
				%>
              <tr align="center" class=<%=WebUtil.printOddRow(i) %>>
              	  <td  nowrap>&nbsp;&nbsp;<%= data.PERNR %>&nbsp;&nbsp;</td>
              	  <td  nowrap>&nbsp;&nbsp;<%= data.ENAME %>&nbsp;&nbsp;</td>
		          <td  nowrap>&nbsp;&nbsp;<%= data.ATEXT %>&nbsp;&nbsp;</td>
		          <td  nowrap>&nbsp;&nbsp;<%= data.DATUM.equals("0000-00-00") ?  "" : WebUtil.printDate(data.DATUM) %>&nbsp;&nbsp;</td>
		          <td  class="lastCol"  nowrap>&nbsp;&nbsp;<%= data.STDAZ %>&nbsp;&nbsp;</td>
              </tr>
            	<%
            				}
				%>
            </table>
			</div>


        <!-- PageUtil 관련 - 반드시 써준다. -->
	<!-- 이동아이콘 테이블 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="td04" style="padding-top:10px"><input type="hidden" name="page" value="">
					<%= pu == null ? "" : pu.pageControl() %>
                  </td>
                </tr>
            </table>
			<!-- 이동아이콘 테이블 끝 -->

        <!-- PageUtil 관련 - 반드시 써준다. -->
		<%
		        	} else {

		%>
        <tr align="center">
          <td class="td04" align="center" colspan="4"><%=g.getMessage("LABEL.F.F51.0029") %><%--No Data --%></td>
        </tr>


		<%
		        	}
		%>
		<%
		    	}
		%>
       </div>
              </form>
	<div class="buttonArea" style="margin-right:20px;margin-top:-50px;">
		<ul class="btn_crud">
         	<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
         </ul>
		 <div class="clear"></div>
	</div>
   </div>
  </div>
<%@ include file="/web/common/commonEnd.jsp" %>
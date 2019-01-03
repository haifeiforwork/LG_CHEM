<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%

	String searchBIZTY = WebUtil.nvl(request.getParameter("I_BIZTY"));
	String I_SEARCH = WebUtil.nvl(request.getParameter("I_SEARCH"));
	HashMap qlHM = (HashMap)request.getAttribute("resultVT");
	int TOTCNT =  0;

	int dtSize = 0;
	int listSize = 0;
	PageUtil pu = null;
	String paging =   WebUtil.nvl((String)request.getParameter("page"));
	int fagNo = 1;

	Vector dtVT = (Vector)qlHM.get("T_BIZTY"); //검색조건 List
	dtSize = dtVT.size();
	Vector listVT = (Vector)qlHM.get("T_EXPORT");
	listSize = listVT.size();

	if(listSize > 0 ){
		TOTCNT =Integer.parseInt((String)qlHM.get("TOTCNT"));
	}

	if(!paging.equals("") && !paging.equals("1") ){
		int mpaging = Integer.parseInt(paging) -1;
		int pagNo  = mpaging * 10;
		fagNo =  pagNo+1;
	}else{
		paging = "1";
	}

	try {
	  	pu = new PageUtil(TOTCNT, paging , 10, 10 );//Page 관련사항
	} catch (Exception ex) {

	}
%>

<jsp:include page="/include/header.jsp"/>

	<script type="text/javascript">

	function searchData(){
		    frm = document.form1;
		    frm.action = "<%= WebUtil.ServletURL%>hris.N.ehrFAQ.EHRfaqSV?I_PFLAG=X";
		    frm.submit();
	}

	function dataDetail(objid){
		    frm = document.form1;
		    frm.mode.value="DETL";
		    frm.I_OBJID.value=objid;
		    frm.action = "<%= WebUtil.ServletURL%>hris.N.ehrFAQ.EHRfaqSV?I_PFLAG=";
		    frm.submit();
	}

	function pageChange(page){
			document.form1.page.value = page;
			get_Page();
	}
	function get_Page(){
			frm = document.form1;
		  	frm.action = '<%= WebUtil.ServletURL %>hris.N.ehrFAQ.EHRfaqSV?I_PFLAG=X';
	  		frm.method = "post";
	  		frm.submit();
	}

	</script>


<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.COMMON.0050"/>
</jsp:include>

<form name="form1" method="post">
<input type="hidden" name="page" value="<%= paging %>">
<input type="hidden" name="mode" value="">
<input type="hidden" name="I_OBJID" value="">

	<div class="tableInquiry">
        <table>
            <tr>
                <th><img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" /></th>
                <th><spring:message code="LABEL.COMMON.0041" /><!--업무분류 --></th>
                <td>
                    <select name="I_BIZTY" style="vertical-align:middle">
					<%
						if(dtSize > 0 ){
							 HashMap<String, String> qlhm2 = new HashMap<String, String>();

							 for(int k = 0 ; k < dtSize ; k++){
								 qlhm2 = (HashMap)dtVT.get(k);
								 String ZCODE = qlhm2.get("ZCODE");
								 String CODTX = qlhm2.get("CODTX");
					%>

						<option value="<%=ZCODE %>" <%if(ZCODE.equals(searchBIZTY)){ %> selected <%} %>><%= CODTX%></option>

					<%
							}
						}
					%>
					</select>

					<input type="text" name="I_SEARCH" value="<%=I_SEARCH %>" size="40" />
					<div class="tableBtnSearch tableBtnSearch2">
                        <a class="search"  onclick="searchData();"><span><spring:message code="BUTTON.COMMON.SEARCH" /><!--검색  --></span></a>
                    </div>
                </td>
            </tr>
        </table>
    	</div>

		<div class="brdTop">
			<%= pu == null ?  "" : pu.pageInfo() %>
		</div>

		<!-- 테이블 시작 -->
		<div class="listArea">
			<div class="table">
			<table class="listTable" summary="" >
				<caption></caption>
				<col width="5%" />
				<col width="10%" />
				<col width="12%" />
				<col />
				<col width="10%" />
				<thead>
					<tr>
						<th><spring:message code="LABEL.COMMON.0042" /><!--번호--></th>
						<th><spring:message code="LABEL.COMMON.0041" /><!--업무분류 --></th>
						<th><spring:message code="LABEL.COMMON.0043" /><!--구분 --></th>
						<th><spring:message code="LABEL.COMMON.0044" /><!--문의내용 --></th>
						<th class="lastCol"><spring:message code="LABEL.COMMON.0045" /><!-- 등록일자 --></th>
					</tr>
				</thead>
				<%
					if(listSize > 0 ){
						 HashMap<String, String> sphm = new HashMap<String, String>();

						 for(int k = 0 ; k < listSize ; k++){
							 sphm = (HashMap)listVT.get(k);
							 String CODTX = sphm.get("CODTX");
							 String SUBTX = sphm.get("SUBTX");
							 String TITLE = sphm.get("TITLE");
							 String REGDT = sphm.get("REGDT");
							 String OBJID = sphm.get("OBJID");
				%>
				<tr class="borderRow">
					<td><%=fagNo+k %></td>
					<td><%=CODTX %></td>
					<td><%= SUBTX %></td>
					<td class="align_left"><a href="javascript:dataDetail('<%= OBJID%>')"><%=TITLE %></a></td>
					<td class="lastCol"><%=REGDT %></td>
				</tr>
				<%
						}
					 }
				%>

			</table>
			</div>
		</div>

		<!-- 테이블 끝 -->

		<!--페이징 시작 -->
		<style type="text/css">
			a:link {  color: #666666; text-decoration: none}
			a:visited {  color: #666666; text-decoration: none}
			a:hover {  color: #666666; }
			.pagingTd {vertical-align:middle;text-align:center;height:25px;}
			.pagingTd img {vertical-align:middle;}
		</style>

		<div class="align_center">
	    	<%= pu == null ? "" : pu.pageControl() %>
	    </div>

		<!--페이징 끝 -->

		<div class="buttonArea">
	        <ul class="btn_crud">
	            <li><a href="javascript:self.close();"><span><!--닫기--><spring:message code="BUTTON.COMMON.CLOSE" /></span></a></li>
	        </ul>
    	</div>

</form>
<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>
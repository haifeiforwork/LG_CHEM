<%
	/******************************************************************************/
	/*   System Name  : ESS                                                         													*/
	/*   1Depth Name  : MY HR 정보                                                  															*/
	/*   2Depth Name  : 휴가/근태                                                        														*/
	/*   Program Name : Flextime                                                   													*/
	/*   Program ID   :D20FlextimeBuild.jsp                                        													*/
	/*   Description  : 개인이 Flextime을 조회하는 화면                                        										    */
	/*   Note         :                                                             															*/
	/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청                                       */
	/*   Update       :                                         																			*/
	/******************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.D20Flextime.*" %>

<%
	WebUserData  user = (WebUserData)session.getAttribute("user");
	Vector resultList = (Vector) request.getAttribute( "resultList" ) ;
    String year         = ( String ) request.getAttribute( "year"  ) ;
    int startYear       = Integer.parseInt( (user.e_dat03).substring(0,4) );
    int endYear         = Integer.parseInt( DataUtil.getCurrentYear() )+1;


    if( startYear < 2002 ){
        startYear = 2002;
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

%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
function doSubmit(obj) {
    if ( obj.value =="") {
       //alert("년도를 선택하세요!");
       alert("<%=g.getMessage("MSG.D.D15.0014")%>");
       return;
    }
    document.form1.target = "_self";
    document.form1.year.value  = document.form1.year.options[document.form1.year.selectedIndex].text;
    document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D20Flextime.D20FlextimeListSV";
    document.form1.method = "post";
    document.form1.submit();

}


//-->
</script>
<%-- html body 안 헤더부분 - 타이틀 등 --%>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="title" value="COMMON.MENU.ESS_PT_FLEXTIME"/>
        <jsp:param name="subView" value="Y"/>
    </jsp:include>

<form name="form1" method="post">

  <!--조회년월 검색 테이블 시작-->
  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
		 <colgroup>
			<col width=15% />
			<col />
		</colgroup>
        <tr>
          <th><!--  조회년도--><%=g.getMessage("LABEL.D.D15.0046")%></th>
          <td>
            <select name="year" onChange="javascript:doSubmit(this);">
             <%= WebUtil.printOption(CodeEntity_vt, year )%>
            </select>
          </td>
        </tr>
      </table>
    </div>
  </div>
  <!--조회년월 검색 테이블 끝-->
  <h2 class="subtitle">Flextime 사용내역</h2>
  <div class="listArea">
    <div class="table">
      <table class="listTable">
      	<colgroup>
			<col width="4%">
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
			<col width="8%" >
		</colgroup>
        <thead>
        <tr>
          <th><!--구분  --><%=g.getMessage("LABEL.D.D20.0011")%></th>
          <th><!--1월  --><%=g.getMessage("LABEL.D.D15.0058")%></th>
          <th><!--2월  --><%=g.getMessage("LABEL.D.D15.0059")%></th>
          <th><!--3월  --><%=g.getMessage("LABEL.D.D15.0060")%></th>
          <th><!--4월  --><%=g.getMessage("LABEL.D.D15.0061")%></th>
          <th><!--5월  --><%=g.getMessage("LABEL.D.D15.0062")%></th>
          <th><!--6월  --><%=g.getMessage("LABEL.D.D15.0063")%></th>
          <th><!--7월  --><%=g.getMessage("LABEL.D.D15.0064")%></th>
          <th><!--8월  --><%=g.getMessage("LABEL.D.D15.0065")%></th>
          <th><!--9월  --><%=g.getMessage("LABEL.D.D15.0066")%></th>
          <th><!--10월  --><%=g.getMessage("LABEL.D.D15.0067")%></th>
          <th><!--11월  --><%=g.getMessage("LABEL.D.D15.0068")%></th>
          <th class="lastCol"><!--12월  --><%=g.getMessage("LABEL.D.D15.0069")%></th>
        </tr>
        </thead>
        <%
        	for(int i=0; i< resultList.size(); i++){
        		D20FlextimeListData data = (D20FlextimeListData)resultList.get(i);

        		String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
        %>
        <tr class="<%=tr_class%>">
          <td><%= i+1 %> 일</td>
          <td><%= data.ZFLEXT01 %></td>
          <td><%= data.ZFLEXT02 %></td>
          <td><%= data.ZFLEXT03 %></td>
          <td><%= data.ZFLEXT04 %></td>
          <td><%= data.ZFLEXT05 %></td>
          <td><%= data.ZFLEXT06 %></td>
          <td><%= data.ZFLEXT07 %></td>
          <td><%= data.ZFLEXT08 %></td>
          <td><%= data.ZFLEXT09 %></td>
          <td><%= data.ZFLEXT10 %></td>
          <td><%= data.ZFLEXT11 %></td>
          <td class="lastCol"><%= data.ZFLEXT12 %></td>
        </tr>
        <% } %>
       </table>
    </div>
  </div>
  <!-- hidden 처리부분 -->
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

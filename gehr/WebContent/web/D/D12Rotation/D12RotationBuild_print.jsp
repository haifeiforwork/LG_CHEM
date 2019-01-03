<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 부서근태마감													*/
/*   Program ID   : D12RotationBuild|D12RotationBuild.jsp						*/
/*   Description  : 부서근태마감 화면												*/
/*   Note         : 															*/
/*   Creation     : 2009-02-10  김종서												*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Date" %>
<%@ page import="hris.D.D12Rotation.*" %>
<%@ page import="hris.D.D12Rotation.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>

<%
    String jobid      = (String)request.getAttribute("jobid");
	String message = (String)request.getAttribute("message");
	Vector AppLineData_vt       = (Vector)request.getAttribute("AppLineData_vt"); //결재라인
    Vector main_vt1    = (Vector)request.getAttribute("main_vt1");
    Vector main_vt2    = (Vector)request.getAttribute("main_vt2");
    Vector main_vt3    = (Vector)request.getAttribute("main_vt3");
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));          //부서명
    String S_DATE  = WebUtil.nvl(request.getParameter("S_DATE"));          //기간
    String E_DATE  = WebUtil.nvl(request.getParameter("E_DATE"));          //기간
    String I_GBN  = WebUtil.nvl(request.getParameter("I_GBN"));
    String I_SEARCHDATA  = WebUtil.nvl(request.getParameter("I_SEARCHDATA"));

    String t_year = (String)request.getAttribute("t_year");
    String t_month = (String)request.getAttribute("t_month");

    if( S_DATE == null|| S_DATE.equals("")) {
    	S_DATE = DataUtil.getCurrentDate();           //1번째 조회시
    }
    if( E_DATE == null|| E_DATE.equals("")) {
    	E_DATE = DataUtil.getCurrentDate();           //1번째 조회시
    }
    String rowCount   = (String)request.getAttribute("rowCount" );

    if(deptId == null || deptId.equals("")){
    	WebUserData user = WebUtil.getSessionUser(request);
    	deptId = user.e_orgeh;
    }

    int  main_count = main_vt1.size();

    if( message == null ){
        message = "";
    }

    int dateSize = 28;
    int tableSize = 215+(main_vt3.size()*dateSize);

    D12RotationBuild2Data first_data = (D12RotationBuild2Data)main_vt3.get(0);
    D12RotationBuild2Data last_data = (D12RotationBuild2Data)main_vt3.get(main_vt3.size()-1);

    String first_date = first_data.BEGDA;
    String last_date = last_data.BEGDA;
%>
<jsp:include page="/include/header.jsp" />


<script language="JavaScript">

function msg(){
<%
    if( !message.equals("") ){
%>
   alert("<%= message %>");
<%
    }
%>
}

function handleError (err, url, line) {
   //alert('오류 : '+err + '\nURL : ' + url + '\n줄 : '+line);
   alert('<%=g.getMessage("MSG.D.D12.0018")%> : '+err + '\nURL : ' + url + '\n<%=g.getMessage("MSG.D.D12.0019")%> : '+line);
   return true;
}

</script>


<style type="text/css">
  .td13 {  background-color: #F0EEDF; text-align: center; color: #585858; padding-top: 1px; height:20px;
	font-size: 8pt;}
.td14 {  font-family: "굴림", "굴림체"; font-size: 7pt; font-weight: normal; color: #333333; background-color: #ffffff}
  .td15 {
	background-color: #FFFACD;
	text-align: center;
	padding-top: 1px;
	height:20px;
	color: #585858;font-size: 8pt;
	}
  .td16 {  background-color: #EAEAEA; text-align: center; padding-top: 3px; height:20px; color: #585858;font-size: 8pt;}


</style>




<form name="form1" method="post" onsubmit="return false">

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="I_SEARCHDATA"  value="<%=I_SEARCHDATA%>">
<input type="hidden" name="retir_chk"  value="">
<input type="hidden" name="I_GUBUN"  value="2">
<input type="hidden" name="I_VALUE1"  value="">
<input type="hidden" name="txt_deptNm"  value="">
<div class="winPop">
	<div class="header">
		<span><%=g.getMessage("COMMON.MENU.ESS_HRA_TIME_CLOS")%></span>
		<a href="" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
	</div>
	<div class="body">
<!--   조회조건 시작   -->
<table width="764" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>

			<div class="tableArea">
				<div class="table">
                      <table  class="tableGeneral">
                        <tr>
                          <th width="100"><!--조회 대상월--><%=g.getMessage("LABEL.D.D12.0041")%></th>
                          <td>
                            <%=t_year %><!--  년--><%=g.getMessage("LABEL.D.D12.0042")%>&nbsp;
                            <%=t_month %><!--  월--><%=g.getMessage("LABEL.D.D12.0028")%>
                          </td>
                        </tr>
                      </table>
					</div>
				</div>
          </td>
        </tr>
              <tr>
                <td  align="right">[<font color="#FFFACD">■</font> :<!--토,일요일--><%=g.getMessage("LABEL.D.D12.0029")%>  ,<font color="#FFB6C1">■</font>:<!--결재진행중--><%=g.getMessage("LABEL.D.D12.0030")%> ,<font color="#EAEAEA">■</font>:<!--결재완료--><%=g.getMessage("LABEL.D.D12.0031")%>]</td>
              </tr>

<!--  조회조건  끝  -->

      <!-- 근태일자 Field Table Header 시작 -->

      <!-- 근태일자 Field Table Header 끝 -->

      <!-- 상단 입력 테이블 시작-->
  <tr>
    <td>
		<div class="listArea wideTable">
			<div class="table">
                  <table border="0" cellspacing="1" cellpadding="0" class="listTable" >
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
					<thead>
                    <tr>
                      <th width="10"  rowspan="2"><!--구분--><%=g.getMessage("LABEL.D.D12.0032")%></th>
                      <th width="40"  rowspan="2"><!--성명--><%=g.getMessage("LABEL.D.D12.0018")%></th>
                      <th width="40"  rowspan="2"><!-- 사번--><%=g.getMessage("LABEL.D.D12.0033")%></th>
                      <th width="20" rowspan="2"><!--잔여휴가--><%=g.getMessage("LABEL.D.D12.0034")%></th>
                      <th colspan=<%=main_vt3.size() %>>&nbsp;<!--근태내용--><%=g.getMessage("LABEL.D.D12.0035")%>(<%=first_date %> ~ <%=last_date %> )</th>
                    </tr>
                    <tr>
                      <%
                      for(int i = 0 ; i < main_vt3.size() ; i++){
                    	  D12RotationBuild2Data data3 = (D12RotationBuild2Data)main_vt3.get(i);
                    	  if(i==0){

                      %>

                      <%
                    	  }
                      %>
                      <th id="<%=data3.BEGDA.replaceAll("-","") %>" value="<%=data3.AINF_SEQN %>" value2="<%=data3.APPR_STAT %>"  width="<%=dateSize %>" title="<%=data3.BEGDA%>"><%=data3.BEGDA.substring(8,10) %>

                      </th>
                      <%
                      }
                      %>
                    </tr>
					</thead>
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
<%


    for( int i = 0 ; i < main_vt1.size() ; i++ ) {
        D12RotationBuildData data = (D12RotationBuildData)main_vt1.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>

                    <tr class="<%=tr_class%> borderRow" height=25>

                      <td >
                      <input type="hidden" name="use_flag<%=i%>"  value="Y" ><!--@v1.4-->
                        <%=i+1%>
                      </td>
                      <td nowrap><%= data.ENAME %></td>
                      <td><%= data.PERNR %></td>
                      <td><%= Math.abs(Double.parseDouble(data.QUATA)) %></td>
                      <%
                      for(int j = 0 ; j < main_vt3.size() ; j++){
                    	  D12RotationBuild2Data data3 = (D12RotationBuild2Data)main_vt3.get(j);
                    	  String cellData = "";
                    	  String title = "";
                    	  Map map = new HashMap();
                    	  for(int l=0; l<main_vt2.size(); l++){
                    		  D12RotationBuildData data2 = (D12RotationBuildData)main_vt2.get(l);

                    		  if(data.PERNR.equals(data2.PERNR) && data3.BEGDA.equals(data2.BEGDA)){
                    			  cellData = cellData + data2.ACODE + " : " + data2.ATIME + "<br>";
                    			  title = title+data2.ATEXT+" "+data2.ATIME+"시간\n";
                    			  map.put(data2.BEGDA, data2.APPR_STAT);
                    		  }
                    	  }


                    	  if((data3.APPR_STAT.equals("A")&&cellData.equals("")) || (data3.APPR_STAT.equals("A")&&!cellData.equals("")&&map.get(data3.BEGDA).equals("A")) || (!data3.APPR_STAT.equals("A")&&!cellData.equals("")&&map.get(data3.BEGDA).equals("A"))){ //승인된 항목
                      %>
                      <td nowrap class="td16" title="<%= title %>"><%= cellData %></td>
                      <%
                    	  }else if(data3.APPR_STAT.equals("I")){//신청중 항목
                      %>
                      <td nowrap class="td11" title="<%= title %>"><%= cellData %></td>
                      <%
                          }else{
                        	  String[] dateArray = data3.BEGDA.split("-");
                        	  Date df = new Date(Integer.parseInt(dateArray[0])-1900, Integer.parseInt(dateArray[1])-1, Integer.parseInt(dateArray[2]));

                        	  String tdClass = "td14";
                        	  if(df.getDay()==0||df.getDay()==6){
                        		  tdClass = "td15";
                        	  }
                      %>
                      <td nowrap class="<%=tdClass %>" title="<%= title %>"><%= cellData %></td>
                      <%
                          }
                      }
                      %>
                    </tr>



<%
    }

%>
                  </table>
				</div>
			</div>



<!-----ADD ROW ---------------------------------->
<!---- ADD ROW ---------------------------------->

      <!-- 상단 입력 테이블 끝-->
    </td>
  </tr>

  <tr>
    <td>
      <table  border="0" cellpadding="0" cellspacing="0" align="left">
        <tr>
          <td>
			<h2 class="subtitle"><!-- 근태유형 및 단위--><%=g.getMessage("LABEL.D.D12.0036")%></h2>
          </td>
        </tr>
        <tr>
          <td>
   <div class="listArea">
		<div class="table">
	        <table class="listTable">
	        <%=g.getMessage("LABEL.D.D12.0052")%>
	        </table>
		</div>
</div>
          </td>
        </tr>
      </table>
    </td>
  </tr>

  <tr>
<td>


<table width="780" border="0" cellspacing="0" cellpadding="0">
    <tr>
          <td >
			<h2 class="subtitle"><spring:message code="MSG.APPROVAL.0011" /><%--승인자정보--%></h2>
          </td>
    </tr>
  <tr>

    <td>
    <!-- 결재라인 테이블 시작-->
<div class="listArea" id="-approvalLine-layout">
    <div class="table">
        <table class="listTable" id="-approvalLine-table">
            <colgroup>
                <col width="15%" />
                <col width="20%" />
                <col width="10%" />
                <col width="55%" />
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="MSG.APPROVAL.0012" /><%--구분--%></th>
                <th><spring:message code="MSG.APPROVAL.0013" /><%--성명--%></th>
                <th><%-- //[CSR ID:3456352]<spring:message code="MSG.APPROVAL.0014" />직위 --%>
                <spring:message code="MSG.APPROVAL.0025" /><%--직책/직급호칭--%>
                </th>
                <th class="lastCol"><spring:message code="MSG.APPROVAL.0015" /><%--부서--%></th>
            </tr>
            </thead>
            <%--@elvariable id="approvalLine" type="java.util.Vector<hris.common.approval.ApprovalLineData>"--%>
            <c:forEach var="row" items="${approvalLine}" varStatus="status">
                <tr class="${f:printOddRow(status.index)}">
                    <td>${row.APPU_NAME}</td>
                    <td>
                        ${row.ENAME}
                    </td>
                    <td id="-APPLINE-JIKWT-${status.index}" >
                    <c:choose>
	            		<c:when test="${row.JIKWT =='책임' && row.JIKKT!=''}">
	            			${row.JIKKT }
	            		</c:when>
            		<c:otherwise>${row.JIKWT }</c:otherwise>
            		<%-- //[CSR ID:3456352]--%>
            	</c:choose>
                    </td>
                    <td id="-APPLINE-ORGTX-${status.index}" class="lastCol">${row.ORGTX}</td>
                </tr>
            </c:forEach>
            <tags:table-row-nodata list="${approvalLine}" col="4" />
        </table>
    </div>
</div>
      <!-- 결재자 입력 테이블 End-->
</td>
</tr>
</table>
</td>
</tr>
</table>
</div>
</div>
<!-- HIDDEN  처리해야할 부분 시작 -->
      <input type="hidden" name="jobid"    value="">
      <input type="hidden" name="rowCount" value="<%= rowCount %>">
  <input type="hidden" name="main_count" value="<%= main_vt1.size() %>">
<!-- HIDDEN  처리해야할 부분 끝   -->
</form>
<!-------hidden------------>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />


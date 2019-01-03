<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 부서근태마감													*/
/*   Program ID   : D12RotationBuild|D12RotationDetail2.jsp						*/
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
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String jobid      = (String)request.getAttribute("jobid");
	String deptNm = (String)request.getAttribute("deptNm");
	Vector AppLineData_vt       = (Vector)request.getAttribute("AppLineData_vt"); //결재라인
    Vector main_vt1    = (Vector)request.getAttribute("main_vt1");
    Vector main_vt2    = (Vector)request.getAttribute("main_vt2");
    Vector main_vt3    = (Vector)request.getAttribute("main_vt3");

    String AINF_SEQN  = WebUtil.nvl((String)request.getAttribute("AINF_SEQN"));
    String E_FROMDA  = WebUtil.nvl((String)request.getAttribute("E_FROMDA"));
    String E_TODA  = WebUtil.nvl((String)request.getAttribute("E_TODA"));
    String E_ORGEH  = WebUtil.nvl((String)request.getAttribute("E_ORGEH"));
    String E_STEXT  = WebUtil.nvl((String)request.getAttribute("E_STEXT"));
    String RequestPageName = (String)request.getAttribute("RequestPageName");

    String rowCount   = (String)request.getAttribute("rowCount" );

    int  emp_count = main_vt1.size();
    int  result_count = main_vt2.size();
    int  date_count = main_vt3.size();

    int from_date = Integer.parseInt(E_FROMDA.replaceAll("-",""));
	int to_date = Integer.parseInt(E_TODA.replaceAll("-",""));

	int dateSize = 40;
    int tableSize = 215+(main_vt3.size()*dateSize);
    String first_date="" ;
    String last_date="";
    D12RotationBuild2Data first_data ;
    D12RotationBuild2Data last_data ;

    if (date_count>0 ){
     first_data = (D12RotationBuild2Data)main_vt3.get(0);
     last_data = (D12RotationBuild2Data)main_vt3.get(main_vt3.size()-1);
     first_date = first_data.BEGDA;
     last_date = last_data.BEGDA;
    }



%>

<c:set var="user" value="<%=WebUtil.getSessionUser(request)%>" />
<c:set var="dateSize" value="<%=dateSize %>"/>
<c:set var="tableSize" value="<%=tableSize %>"/>
<c:set var="first_date" value="<%=first_date %>"/>
<c:set var="last_date" value="<%=last_date %>"/>
<c:set var="emp_count" value="<%=emp_count %>"/>
<c:set var="date_count" value="<%=date_count %>"/>
<c:set var="rowCount" value="<%=rowCount %>"/>
<c:set var="from_date" value="<%=from_date %>"/>
<c:set var="to_date" value="<%=to_date %>"/>
<c:set var="rowCount" value="<%=rowCount %>"/>
<c:set var="deptId" value="<%=E_ORGEH %>"/>

<c:set var="map" value = "<%=new java.util.HashMap<String,String>()%>"/>

<tags:layout css="ui_library_approval.css" script="dialog.js" >

    <%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
    <tags-approval:detail-layout titlePrefix="COMMON.MENU.ESS_HRA_TIME_CLOS" updateUrl="">
<tags:script>
<script>

function handleError (err, url, line) {
	   //alert('오류 : '+err + '\nURL : ' + url + '\n줄 : '+line);
	  alert('<spring:message code='MSG.D.D12.0018'/> : '+err + '\nURL : ' + url + '\n<spring:message code='MSG.D.D12.0019'/>  : '+line);
   return true;
}

function goRotationDetail(deptId, yyyymmdd){

	window.open( "${g.servlet}hris.D.D12Rotation.D12RotationSV?hdn_isPop=DETAIL&jobid=&hdn_deptId="+deptId+"&I_DATE="+yyyymmdd+"&I_SEARCHDATA="+deptId,"RotataionDetail","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,width=1200,height=600, scrollbars=1");
}

function init() {
	$(".-update-button").hide();
	}

$(function() {

	init();

});
      </script>
</tags:script>
		<div class="tableAreal">
			<div class="table">
                 <table class="tableGeneral">
            		<colgroup>
                		<col width="15%">
                		<col width="35%">
                		<col width="15%">
                		<col width="35%">
            		</colgroup>
                   <tr>
                     <th><!--  -기간--><spring:message code="LABEL.D.D12.0013"/></th>
                     <td>
                     	<input type="text" name="S_DATE" value="${f:printDate(E_FROMDA) }" size="10" onBlur="" readonly>
                     	~
                     	<input type="text" name="E_DATE" value="${f:printDate(E_TODA) }" size="10" onBlur="" readonly>
                     </td>
                     <th class="th02"><!--  -부서명--><spring:message code="LABEL.D.D12.0010"/></th>
                     <td><input type="text" name="txt_deptNm" size="50" maxlength="50" value="${ E_STEXT}"   readonly></td>
                   </tr>
                  </table>
			</div>
		</div>
<div class="listArea">
        <div class="listTop">
            <div class="buttonArea">
                [<font color="#FFE4E1">■</font><!--:요청일--><spring:message code="LABEL.D.D12.0047"/>  ,<font color="#FFFACD">■</font> :<!--토,일요일--><spring:message code="LABEL.D.D12.0029"/> ,<font color="#FFB6C1">■</font>:<!--결재진행중--><spring:message code="LABEL.D.D12.0030"/> ,<font color="#EAEAEA">■</font>:<!--결재완료--><spring:message code="LABEL.D.D12.0031"/>]
            </div>
        </div>
	<div class="table">
                  <table class="listTable">
<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
				<thead>
                    <tr>
                   <th rowspan="2" nowrap><!--구분--><spring:message code="LABEL.D.D12.0032"/></th>
                  <th rowspan="2"><!--성명--><spring:message code="LABEL.D.D12.0018"/></th>
                  <th rowspan="2"><!-- 사번--><spring:message code="LABEL.D.D12.0033"/></th>
                  <th rowspan="2" nowrap><!--잔여휴가--><spring:message code="LABEL.D.D12.0034"/></th>
                  <th class="lastCol" colspan="${date_count}">&nbsp;<!--근태내용--><spring:message code="LABEL.D.D12.0035"/>(${f:printDate(first_date) } ~ ${f:printDate(last_date)})</th>
                    </tr>
                    <tr>
                      <c:forEach var="row" items="${main_vt3}" varStatus="status">
                     <c:choose>
                     <c:when test="${approvalHeader.finish}">
                      <th id="${f:deleteStr(row.BEGDA,'-')}" value="${row. AINF_SEQN}" value2="${row. APPR_STAT}"  width="${dateSize}" title="${row. BEGDA}">${fn:substring(row.BEGDA,8,10)}</th>
                       </c:when>
                       <c:otherwise>
                       <th id="${f:deleteStr(row.BEGDA,'-')}" value="${row. AINF_SEQN}" value2="${row. APPR_STAT}"  width="${dateSize}" title="${row. BEGDA}"><a href="javascript:goRotationDetail('${deptId}','${row.BEGDA}');">${fn:substring(row.BEGDA,8,10)}</a></th>
                       </c:otherwise>
                       </c:choose>

                       </c:forEach>
                    </tr>
                 </thead>
                <c:forEach var="data" items="${main_vt1}" varStatus="status">
                   <tr class="${f:printOddRow(status.index)}">
                      <td>${status.index+1}
                      <input type="hidden" name="use_flag${status.index}"  value="Y" ><!--@v1.4-->
                      <input type="hidden" name="BEGDA${status.index}" value="${data.BEGDA }">
                      </td>
                      <td nowrap>${data. ENAME}</td>
                      <td>${data. PERNR}</td>
                      <td><fmt:formatNumber value="${data.QUATA}" pattern="0.0"/><%--<%= Math.abs(Double.parseDouble(data.QUATA)) --%></td>
                      <c:forEach var="data3" items="${main_vt3}" varStatus="status1">
                          <c:set var="cellData" value=""/>
                          <c:set var="title" value=""/>
                          <c:set var="today" value = "${f:deleteStr(data3.BEGDA,'-')}"/>
						   <c:set var="map" value = "<%=new java.util.HashMap<String,String>()%>"/>
                          <c:forEach var="data2" items="${main_vt2}" varStatus="status2">
                        	  <c:if  test="${data.PERNR eq data2.PERNR and  data3.BEGDA eq data2.BEGDA}">
                          		<c:set var="cellData" value="${cellData}${ data2.ACODE}:${data2.ATIME }<br>"/>
                          		<c:set var="title" value="${title}${data2.ATEXT}:${data2.ATIME}시간\n "  />
                          		<c:set target="${map}" property="${data2.BEGDA}" value= "${data2.APPR_STAT}"/>
                              </c:if>
                          </c:forEach>
   						<c:choose>
   								<c:when  test="${(data3.APPR_STAT eq 'A' and  empty cellData ) or  (data3.APPR_STAT eq  'A' and  not empty cellData and  map[data3.BEGDA] eq  'A' )or( data3.APPR_STAT !=  'A'  and  not empty cellData  and map[data3.BEGDA] eq 'A')}">
    										<c:choose>
    											<c:when test="${ from_date<=today and today<=to_date}">
    									            <td class="td12" title="${title}"> ${cellData}</td>
    									         </c:when>
    									         <c:otherwise>
    									            <td class="td07" title="${title}"> ${cellData}</td>
    									          </c:otherwise>
    									      </c:choose>
   								</c:when>
      							<c:when  test="${data3.APPR_STAT eq 'I'}">
    										<c:choose>
    											<c:when test="${ from_date<=today and today<=to_date}">
    									            <td class="td12" title="${title}"> ${cellData}</td>
    									         </c:when>
    									         <c:otherwise>
    									            <td class="td11" title="${title}">${cellData}</td>
    									          </c:otherwise>
    									      </c:choose>
   								</c:when>
   								<c:otherwise>
          								<c:set var="dateNum" value="${f:getDay(f:deleteStr(data3.BEGDA,'-'))}"/>
          								       <c:choose>
    											<c:when test="${ dateNum==1 or   dateNum==7}">
    									            <td class="td10" title="${title}"> ${cellData}</td>
    									         </c:when>
    											<c:when test="${ from_date<=today and today<=to_date}">
    									            <td class="td12" title="${title}"> </td>
    									         </c:when>
    									         <c:otherwise>
    									            <td  title="${title}">${cellData}</td>
    									          </c:otherwise>
    									      </c:choose>
   								</c:otherwise>
   						</c:choose>
   					</c:forEach>
    			</tr>

	</c:forEach>

                  </table>
			</div>
		</div>

<!-----ADD ROW ---------------------------------->
<!---- ADD ROW ---------------------------------->

      <!-- 상단 입력 테이블 끝-->
    <h2 class="subtitle"><!-- 근태유형 및 단위--><spring:message code="LABEL.D.D12.0036"/></h2>

    <div class="listArea">
		<div class="table">
	        <table class="listTable">
	          <spring:message code="LABEL.D.D12.0052"/>
	        </table>
		</div>
    </div>
<!-------hidden------------>
<input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" readonly>
    </tags-approval:detail-layout>
</tags:layout>
<%/******************************************************************************/
/*																				*/
/*   System Name  : My HR															*/
/*   1Depth Name  : 	부서근태														*/
/*   2Depth Name  : 													*/
/*   Program Name : 일일근무일정 변경(근무규칙선택창)												*/
/*   Program ID   : D13Schedulexcel.jsp			*/
/*   Description  : 일일근무일정 변경 (엑셀다운로드 ])											*/
/*   Note         : 															*/
/*   Creation     : 2016-12-19 김승철												*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/commonProcess.jsp" %> 

<%@ page import="java.util.Vector" %> 
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.C.*" %>
       
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>     
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%    
    String pernr       = (String)request.getAttribute("pernr"); 
    String IM_BEGDA = (String)request.getAttribute("BEGDA"); 
    String IM_ENDDA = (String)request.getAttribute("ENDDA"); 
 
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=ScheduleChangeGlobal_"+IM_BEGDA+"_"+IM_ENDDA+".xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */        
%>
 
<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
	<style type="text/css">
		.orgStats_tb {padding-left:20px;}
		.excelTitle {text-align:center;font-family:malgun gothic;font-size:15px;font-weight:bold;color:#ee8aa3}
		.tb_def {table-layout:fixed;}
		.tb_def th {font-family:malgun gothic;color:#000;font-size:12px;font-weight:bold;border:solid 1px #000; background:#eee}
		.tb_def td {font-family:malgun gothic;color:#000;font-size:12px;font-weight:normal;border:solid 1px #000;text-align:center;}
		.colSum {font-family:malgun gothic;color:#000;font-size:12px;font-weight:bold;border:solid 1px #000;background:#f4eeff}

	</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">      
  
    		<table  class="tb_def" >
    		<colgroup>
    		<col width=20px/>	<!-- 선택-->
    		<col width=120px/>	<!-- 사원번호-->
    		<col width=90px/>	<!-- 이름-->
    		<col width=140px/>	<!-- 시작일-->
    		<col width=140px/>	<!-- 종료일-->
    		<col width=170px/>	<!-- 대체유형-->
    		<col width=120px/>	<!-- 일일근무일정-->
    		<col width=100px/>	<!-- 근무일정규칙-->
    		<col width=110px/>	<!-- 근무일정명-->
    		<col width=70px/>	<!-- 시작시간-->
    		<col width=70px/>	<!-- 종료시간-->
    		<col width=70px/>	<!-- 근무시간-->
    		<col />					<!-- 오류메시지-->
    		</colgroup>
    		<tr></tr>
            <tr> 
              <td colspan=11 class="title02"><spring:message code="COMMON.MENU.ESS_HRA_DAIL_SCHE" /></td>
              <td><spring:message code='COMMON.PAGE.TOTAL' arguments='${fn:length(resultList)}' /><!--총 건--></td>
            </tr>
<%
// 사원 검색한 사람이 없을때
if ( pernr != null ) {
%>

			<tr>
				<th ><spring:message code="LABEL.D.D12.0017"/> <!-- 사원번호--></th>
				<th><spring:message code="LABEL.D.D12.0018"/> <!-- 이름--></th>
				<th ><spring:message code="LABEL.D.D15.0152"/> <!-- 시작일--></th>
				<th ><spring:message code="LABEL.D.D15.0153"/> <!-- 종료일--></th>
				<th ><spring:message code="LABEL.D.D13.0014"/> <!-- 대체유형--></th>
				<th ><spring:message code="LABEL.D.D13.0015"/> <!-- 일일근무일정--></th>
				<th ><spring:message code="LABEL.D.D14.0001"/> <!-- 근무일정규칙--></th>
				<th ><spring:message code="LABEL.D.D13.0016"/> <!-- 근무일정명--></th>
				<th ><spring:message code="LABEL.D.D12.0020"/> <!-- 시작시간--></th>
				<th ><spring:message code="LABEL.D.D12.0021"/> <!-- 종료시간--></th>
				<th><spring:message code="LABEL.D.D13.0017"/> <!-- 근무시간--></th>
				<th  class="lastCol"><spring:message code="MSG.COMMON.UPLOAD.BIGO"/> <!-- 오류메시지--></th>
			</tr>

			<c:forEach var="row" items="${resultList}" varStatus="status">
				<tr  id="-pay-row-${status.index}" 				 style="border-bottom:#eee 1 solid;border-top:0; border-right:0;border-left:0">
					<td >
						<c:choose>
						<c:when test='${row.PERNR == "00000000"}'> 
							<input type="text"  id="PERNR${status.index}" 	name="LIST_PERNR" 	 size="8"   value="">
						</c:when>
						<c:otherwise>
								${row.PERNR == "00000000" ? "" : row.PERNR}
						</c:otherwise>
						</c:choose>
					<td >						${row.ENAME}</td>
					<td >${ row.CBEGDA == "0000-00-00" ? "" : row.CBEGDA 	}	</td>
					<td >${ row.CENDDA == "0000-00-00" ? "" : row.CENDDA	} </td>
					<td >
						<c:choose>
						<c:when test='${row.VTART=="01"}'> 
							<spring:message code='LABEL.D.D13.0028'/>
						</c:when>
						<c:otherwise>
							<spring:message code='LABEL.D.D13.0029'/>
						</c:otherwise>
						</c:choose>
					</td>
					<td >${row.TPROG	}											</td>
					<td >	${row.RTEXT	}</td>
					<td>	${row.TTEXT	}</td>
					<td >	${(row.SOBEG == "00:00:00" && row.SOLLZ=="0") ? "" : f:printTime(row.SOBEG)	}</td>
					<td >	${(row.SOEND == "00:00:00" && row.SOLLZ=="0") ? "" : f:printTime(row.SOEND)}</td>
					<td >	${f:printTime(row.SOLLZ)	}</td>
					<td class="lastCol " >						${row.ZBIGO}					</td>
				</tr>
			</c:forEach>


<%
    } else {
%>
                <tr align="center"> 
                  <td  colspan="7">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
<%
    }
%>
        </table>

</form>
</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.C.*" %>
<%@ page import="hris.C.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>

<%
    // 4. 년도별 조직별 교육이력
    Vector        historyData_vt = (Vector)request.getAttribute("historyData_vt");
    String  		 returnSUM       = (String)request.getAttribute("returnSUM");
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setContentType("Application/Msexcel;charset=UTF-8"); 
    response.setHeader("Content-Disposition", "ATTachment; Filename=EducationHistory.xls"); 
    /*----------------------------------------------------------------------------- */ 
    
%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">      

                            <table width="1300" border="0" cellspacing="1" cellpadding="3" class="table02" >
                                 <tr> 
                                    <td class="td03">사번</td>
                                    <td class="td03">이름</td>
                                    <td class="td03">소속</td>
                                    <td class="td03">직위</td>
                                    <td class="td03">직책</td>
                                    <td class="td03">시작일</td>
                                    <td class="td03">종료일</td>
                                    <td class="td03">교육기관</td>
                                    <td class="td03">교육분야</td>
                                    <td class="td03">교육년도</td>
                                    <td class="td03">교육과정</td>
                                    <td class="td03">차수</td>
                                    <td class="td03">교육비</td>
                                    <td class="td03">교육시간</td>                                    
                                </tr>                            
<%
    // 교육예산 조회 - 조직명
    for ( int i = 0 ; i < historyData_vt.size() ; i++){
    	C10LearnHistoryEduHistoryListData data =  ( C10LearnHistoryEduHistoryListData )historyData_vt.get(i);
%>        	
                                <tr> 
                                    <td class="td04"><%=data.PERNR%></td>
                                    <td class="td04"><%=data.ENAME%></td>
                                    <td class="td04"><%=data.ORGTX%></td>
                                    <td class="td04"><%=data.TIT01%></td>
                                    <td class="td04"><%=data.TIT02%></td>
                                    <td class="td04"><%=data.BEGDA%></td>
                                    <td class="td04"><%=data.ENDDA%></td>
                                    <td class="td04"><%=data.ORGA_NAME%></td>
                                    <td class="td04"><%=data.CATA_NAME%></td>
                                    <td class="td04"><%=data.EDUC_YEAR%></td>
                                    <td class="td02"><%=data.COUR_NAME%></td>
                                    <td class="td04"><%=data.COUR_SCHE%></td>
                                    <td class="td04"><%=WebUtil.printNumFormat(data.EDUC_COST)%></td>
                                    <td class="td04"><%=data.EDUC_TIME.substring(1,3)%></td>                                    
                                 </tr>                                 
<%
    } // for end
%>     
<tr>
<td  class="td03" colspan="3">교육비 총계</td>
<td  class="td03" colspan="11"><%=WebUtil.printNumFormat(returnSUM)%></td>
</tr>                           
                            </table>
</form>
</body>
</html>

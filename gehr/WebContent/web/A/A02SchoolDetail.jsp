<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 학력사항                                                    */
/*   Program Name : 학력사항                                                    */
/*   Program ID   : A02SchoolDetail.jsp                                         */
/*   Description  : 학력사항 조회                                               */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-28  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector A02SchoolData_vt = (Vector)request.getAttribute("A02SchoolData_vt");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="title"><h1>학력사항 조회</h1></td>
          </tr>

          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td>
              <!--학력 사항 리스트 테이블 시작-->
              <div class="listArea">
	              <div class="table">
		              <table class="listTable">
		                <tr>
		                  <th width="130">기 간</th>
		                  <th width="110">학교명</th>
		                  <th width="110">전 공</th>
		                  <th width="110">졸업구분</th>
		                  <th width="250">소재지</th>
		                  <th class="lastCol" width="70">입사시 학력</th>
		                </tr>
<%
    if( A02SchoolData_vt.size() > 0 ) {
        for( int i = 0; i < A02SchoolData_vt.size(); i++ ){
            A02SchoolData data = (A02SchoolData)A02SchoolData_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
		                <tr class="<%=tr_class%>">
		                  <td><%= data.PERIOD    %></td>
		                  <td><%= data.LART_TEXT %></td>
		                  <td><%= data.FTEXT     %></td>
		                  <td><%= data.STEXT     %></td>
		                  <td style="text-align:left">&nbsp;&nbsp;<%= data.SOJAE.equals("") ? "" : data.SOJAE %></td>
		                  <td class="lastCol"><%= ( (data.EMARK).toUpperCase() ).equals("N") ? "" : data.EMARK %></td>
		                </tr>
<%
        }
    } else {
%>
		                <tr align="center">
		                  <td colspan="6">해당하는 데이터가 존재하지 않습니다.</td>
		                </tr>
<%
    }
%>
              		</table>
				</div>
			</div>
              <!--학력 사항 리스트 테이블 끝-->
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess_m.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    // 첫 화면에 리스트되는 데이터들..
    Vector                   A08LicenseDetailAllo_vt = (Vector)request.getAttribute("A08LicenseDetailAllo_vt");
    A08LicenseDetailAlloData data                    = (A08LicenseDetailAlloData)A08LicenseDetailAllo_vt.get(0);
%>

<jsp:include page="/include/header.jsp" />

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<div class="winPop">
	<div class="header">
		<span>자격면허</span>
		<a href="javascript:self.close();"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
	</div>
<form name="form1" method="post" action="">
<div class="body">
				<h2 class="subtitle">기본사항</h2>
				<div class="tableArea">
			      <div class="table">
           			<table class="tableGeneral">
            		<colgroup>
            			<col width="35%" />
            			<col width="65%" />
            		</colgroup>
                    <tr>
                      <th>자격증</td>
                      <td ><%= data.LICN_NAME %></td>
                    </tr>
                    <tr>
                      <th>자격 등급</td>
                      <td><%= data.GRAD_NAME %></td>
                    </tr>
                  </table>
                 </div>
                </div>
				<h2 class="subtitle">수 당</h2>
				<div class="tableArea">
			      <div class="table">
           			<table class="tableGeneral">
            		<colgroup>
            			<col width="35%" />
            			<col width="65%" />
            		</colgroup>
                    <tr>
                      <th>지급율</td>
                      <td><%= data.GIVE_RATE1 + " %" %></td>
                    </tr>
                    <tr>
                      <th>자격수당</td>
                      <td><%=WebUtil.convertCurrency(DataUtil.changeLocalAmount(data.LICN_AMNT, data.WAERS), "0")  + " 원" %></td>
                    </tr>
                  </table>
                 </div>
                </div>

               <h2 class="subtitle">법정선임정보</h2>
				<div class="tableArea">
			      <div class="table">
           			<table class="tableGeneral">
            		<colgroup>
            			<col width="35%" />
            			<col width="65%" />
            		</colgroup>
                    <tr>
                      <th>조직단위</td>
                      <td><%= data.ORGTX %></td>
                    </tr>
                    <tr>
                      <th>설비 / 위치</td>
                      <td ><%= data.EQUI_NAME %></td>
                    </tr>
                    <tr>
                      <th>선임사유</td>
                      <td><%= data.ESTA_AREA %></td>
                    </tr>
                    <tr>
                      <th>비고</td>
                      <td><%= data.PRIZ_TEXT %></td>
                    </tr>
                  </table>
                 </div>
                </div>

    <ul class="btn_crud close">
		<li><a href="javascript:self.close()"><span>닫기</span></a>
	</ul>
</div>
</form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>


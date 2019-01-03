<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.*" %>
<%@ page import="hris.common.*"%>
<%@ page import="hris.N.ehrptmain.*"%>

<%

	String reOBJID =(String)request.getParameter("OBJID");
	HashMap resultData  = (HashMap)request.getAttribute("initPop_hm");
	Vector vt = (Vector)resultData.get("T_EXPORTA");

	int cSize = vt.size() ;

	HashMap<String, String> T_EXPORT = new HashMap<String, String>();

	String sCODTX =  "";
 	String sTITLE   = "";
 	String sBEGDA  = "";
 	String sENDDA  =  "";
 	String sNOTER  = "";
 	String sFURL    =  "";
 	String sGURL    =  "";
 	String sFILEN   =  "";

	for(int t = 0 ; t < cSize ; t++){
		 T_EXPORT = (HashMap)vt.get(t);
	     String sOBJID =  T_EXPORT.get("OBJID");
	     if(reOBJID.equals(sOBJID)){
			 sCODTX =  T_EXPORT.get("CODTX");
		 	 sTITLE   =  T_EXPORT.get("TITLE");
		 	 sBEGDA =   T_EXPORT.get("BEGDA");
		 	 sENDDA = 	 T_EXPORT.get("ENDDA");
		 	 sNOTER =	 T_EXPORT.get("NOTER");
		 	 sFURL =    T_EXPORT.get("FURL");
		 	 sGURL =    T_EXPORT.get("GURL");
		 	 sFILEN =   T_EXPORT.get("FILEN");
	     }
	}
	//T_EXPORT = (HashMap)vt.get(0);






 	Vector titlevt = (Vector)resultData.get("T_TEXT");
 	int ctSize = titlevt.size() ;
 	HashMap<String, String> T_TEXT = new HashMap<String, String>();
 	StringBuffer content = new StringBuffer();
 	for(int k = 0 ; k < ctSize ; k ++){
 		T_TEXT = (HashMap)titlevt.get(k);
 		String sOBJID =  T_TEXT.get("OBJID");
 		if(reOBJID.equals(sOBJID)){
 			content.append(T_TEXT.get("TDLINE")+"<br/>");
 		}
 	}





%>
<jsp:include page="/include/header.jsp"/>

		<script>
			function setCookie( name, value, expiredays )
			{
				var todayDate = new Date();
				todayDate.setDate( todayDate.getDate() + expiredays );
				document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
			}


			function closeWin()
			{
				if (document.forms[0].Notice.checked )
					setCookie( "<%=reOBJID%>", "done" , 1);
				self.close();
			}
		</script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<div class="winPop dvMinheight">

	<div class="header">
		<span><%=sCODTX %></span>
		<a href="javascript:void(0);" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" alt="팝업닫기" /></a>
	</div>
	<div class="body">

	<div class="tableArea">
		<!-- 개인 인적사항 조회 -->
		<div class="table">
			<table border="0" cellspacing="0" cellpadding="0" class="tableGeneral">

				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<th scope="row" class="titleNotice" colspan="4"><%=sTITLE %></th>
				</tr>
				<tr>
					<th><spring:message code='LABEL.N.N03.0001'/><!-- 게시자 --></th>
					<td><%= sNOTER%></td>
					<th class="th02"><spring:message code='LABEL.N.N03.0002'/><!-- 게시시간 --></th>
					<td><%= sBEGDA%> ~ <%= sENDDA%></td>
				</tr>
				<tr class="attachment">
					<td colspan="4">
						<%if(sFURL.equals("")){%>
						&nbsp;
						<%}else{ %>
						<a href="<%= sFURL%>" target="_new"><%=sFILEN %></a>

						<%} %>
					</td>
				</tr>
				<tr>
					<td class="viewNotice" colspan="4">
						<%=content %>
						<br /><img src="<%=sGURL %>" /><br />
					</td>
				</tr>
			</table>
		</div>
	</div>

	<div class="nBottom">
		<form><span class="closeToday"><input type="checkbox" name="Notice"  onclick="closeWin()"> <spring:message code='LABEL.N.N03.0003'/><!-- 오늘 하루 페이지를 열지 않습니다. --></span>
			<a href="javascript:window.close();"><spring:message code='BUTTON.COMMON.CLOSE'/><!-- 닫기 --></a>
		</form>
	</div><!-- /bottom -->

	</div>
</div>
</body>
<jsp:include page="/include/footer.jsp"/>


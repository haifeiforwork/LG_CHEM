<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 기부금                                                      */
/*   Program Name : 기부금사업자번호 명칭 조회                                  */
/*   Program ID   : D11TaxAdjustGibuHiddenbusiName .jsp                         */
/*   Description  : 기부금사업자번호 명칭 조회                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2007.11.19                                                  */
/*                    2013-11-25  CSR ID:2013_9999 2013년말정산반영             */
/*                                부당공제기부처 체크메세지추가                 */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.servlet.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String BUS01 = request.getParameter("BUS01");
    String INX = request.getParameter("INX");
    String H_GUBN = request.getParameter("H_GUBN");
    String DONA_CODE = request.getParameter("DONA_CODE");
    String DONA_CRVYR = request.getParameter("DONA_CRVYR");
    String targetYear = request.getParameter("targetYear");

    String  name = "";    //상호명
    String  eFlag = "";   //부당공제처여부 CSR ID:2013_9999
    //상호명검색
    if (H_GUBN.equals("NAME") || H_GUBN.equals("") ) {
   	 if( !BUS01.equals("") ) {
   	     try {
   	         D11TaxAdjustGibuBusiNameRFC func = new D11TaxAdjustGibuBusiNameRFC();

    	         Vector ret = func.getBusiName(BUS01);
                 name  = (String)ret.get(0);
                 eFlag = (String)ret.get(1); //CSR ID:2013_9999
   	     } catch (Exception ex) {
   	         Logger.debug.println(DataUtil.getStackTrace(ex));

   	     }
   	 }
%>
<form name="form1">

<script>

    //@2014 연말정산 기부처 상호는 부당공제 기부처에만 보이도록.
    //parent.document.form1.DONA_COMP< %=INX%>.value = "< %= name %>";
    //부당공제처여부 CSR ID:2013_9999
    <% if (  eFlag.equals("Y"))   { %>
     	//parent.document.form1.DONA_COMP< %=INX%>.value = "< %= name %>";//@2014 연말정산 박난이s 요청 사업장명 보이지 않도록.
       	var msg = "<spring:message code='MSG.D.D11.0059' />";  //입력하신 해당 기부처는 이전에 기부금 부당공제 관련 기부처로 확인된 바 있으므로,
           	 msg = msg + "<spring:message code='MSG.D.D11.0060' />";  //기부금액 및 주무관청 등록여부를 다시 확인하여 주시기 바랍니다.

        alert(msg);
    <% } %>

</script>
<%
    //전월공제 체크
    }else if (H_GUBN.equals("CHECK") ) {
    	String  message = "";
    	String  code = "";
    	if( !DONA_CODE.equals("") && !DONA_CRVYR.equals("")) {
    	    try {
    	        D11TaxAdjustGibuDonaCheckRFC func = new D11TaxAdjustGibuDonaCheckRFC();

    	        Vector ret = func.getResult(DONA_CODE,DONA_CRVYR,targetYear+"0101");


                code = (String)ret.get(0);
                message =  (String)ret.get(1);


    	        if ( code.equals("E") ){
    	       		DONA_CRVYR ="";
    	        }

    	    } catch (Exception ex) {
    	        Logger.debug.println(DataUtil.getStackTrace(ex));

    	    }
    	}

%>
<form name="form1">
<script>
    parent.document.form1.DONA_CRVYR<%=INX%>.value = "<%=DONA_CRVYR%>";

    if ("<%=message%>"!=""){
        alert("<%=message%>");
    	parent.document.form1.DONA_YYMM<%=INX%>.value = "";
    	parent.document.form1.DONA_YYMM<%=INX%>.focus();
    }
</script>
<%
    }
%>
</form>


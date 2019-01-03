<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연금/저축                                                   */
/*   Program ID   : D11TaxAdjustPensionHiddenGubn.jsp                           */
/*   Description  : 연금/저축 구분별 유형 조회                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-12-10                                                  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>

<%
    String GUBUN = request.getParameter("GUBUN");


    //유형조회
    String SUBTY = request.getParameter("SUBTY");
    String PNSTY = request.getParameter("PNSTY");
    String index     = request.getParameter("i");
    String targetYear     = request.getParameter("targetYear");
    Vector D11TaxAdjustPensionCodeData_vt  =     (new D11TaxAdjustPensionCodeRFC()).getPensionGubn(targetYear,"2",SUBTY);
%>
<%  if (GUBUN.equals("1")) { //유형조회  %>
<script>
    parent.document.form1.PNSTY_<%= index%>.length = <%= D11TaxAdjustPensionCodeData_vt.size()+1 %>;
<%
    int inx = 0;
    for( int i = 0 ; i < D11TaxAdjustPensionCodeData_vt.size() ; i++ ) {
        D11TaxAdjustPensionCodeData data = (D11TaxAdjustPensionCodeData)D11TaxAdjustPensionCodeData_vt.get(i);
        inx++;
        if ( i ==0) {
%>
        parent.document.form1.PNSTY_<%= index%>[<%= inx-1 %>].value = "";
        parent.document.form1.PNSTY_<%= index%>[<%= inx-1 %>].text  = "----------------";
<%
        inx = inx +1;

        }
%>
        parent.document.form1.PNSTY_<%= index%>[<%= inx-1 %>].value = "<%=data.GOJE_CODE%>";
        parent.document.form1.PNSTY_<%= index%>[<%= inx-1 %>].text  = "<%=data.GOJE_TEXT%>";
        parent.document.form1.PNSTY_<%= index%>[0].selected = true;
<%
    }
%>
</script>
<%  } %>
<%  if (GUBUN.equals("3")) { //구분별 유형별 세대주체크여부 조회

    //세대주필수체크 rfc get
    D11TaxAdjustHouseHoleRequiredRFC   rfcHole        = new D11TaxAdjustHouseHoleRequiredRFC();
    String REQ_H =  rfcHole.getReqH("","",targetYear+"0101" ,SUBTY,PNSTY);

    //항목별필수체크여부
    Vector pensionCode_vt = new Vector();
    D11TaxAdjustPensionCodeRFC       PCoderfc        = new D11TaxAdjustPensionCodeRFC();
    String PREIN_FLAG  = ""; //종(전)근무지필수 체크
    String FINCO_FLAG  = ""; //금융기관코드필수 체크
    String ACCNO_FLAG =  ""; //계좌번호필수 체크
    pensionCode_vt = PCoderfc.getPensionGubn(targetYear,"2", SUBTY);
    for( int j = 0 ; j < pensionCode_vt.size() ; j++ ){
    	D11TaxAdjustPensionCodeData dataC = (D11TaxAdjustPensionCodeData)pensionCode_vt.get(j);
    	if (PNSTY.equals(dataC.GOJE_CODE)) {
    	    PREIN_FLAG  = dataC.PREIN_FLAG;
    	    FINCO_FLAG  = dataC.FINCO_FLAG;
    	    ACCNO_FLAG =  dataC.ACCNO_FLAG;
    	}
    }

%>
<script>
    parent.document.form1.E_HOLD_<%= index%>.value = "<%=REQ_H%>";
    parent.document.form1.PREIN_FLAG_<%= index%>.value = "<%=PREIN_FLAG%>";
    parent.document.form1.FINCO_FLAG_<%= index%>.value = "<%=FINCO_FLAG%>";
    parent.document.form1.ACCNO_FLAG_<%= index%>.value = "<%=ACCNO_FLAG%>";

    if ("<%=PREIN_FLAG%>"=="X")  //종(전)근무지
        eval( "parent.document.form1.PREIN_<%= index%>.disabled = false;");
    else {
        eval( "parent.document.form1.PREIN_<%= index%>.disabled = true;");
        eval( "parent.document.form1.PREIN_<%= index%>.checked = false;");
    }
    if ("<%=FINCO_FLAG%>"=="X") { //금융기관코드
        eval( "parent.document.form1.FINCO_<%= index%>.disabled = false;");
    } else {
        eval( "parent.document.form1.FINCO_<%= index%>.disabled = true;");
        eval( "parent.document.form1.FINCO_<%= index%>[0].selected = true;");
    }
    if ("<%=ACCNO_FLAG%>"=="X") //계좌번호
        eval( "parent.document.form1.ACCNO_<%= index%>.disabled = false;");
    else{
        eval( "parent.document.form1.ACCNO_<%= index%>.disabled = true;");
        eval( "parent.document.form1.ACCNO_<%= index%>.value = '';");
    }
</script>
<%  } %>
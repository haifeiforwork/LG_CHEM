<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 진급자격요건 시뮬레이션                                     */
/*   Program Name : 진급자격요건 시뮬레이션                                     */
/*   Program ID   : B04Promotion01.jsp                                          */
/*   Description  : 진급자격요건 시뮬레이션을 조회                              */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                      2017-11-15 eunha [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件                  */
/********************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.common.RFCReturnEntity" %>
<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="com.sns.jdf.util.SortUtil" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.B.B04Promotion.B04PromotionAData" %>
<%@ page import="hris.B.B04Promotion.B04PromotionCData" %>
<%@ page import="hris.B.db.B01ValuateDetailDB" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%@ page import="java.util.Vector" %>

<%
    WebUserData user = (WebUserData) session.getAttribute("user");
//    Vector B04PromotionData_vt = (Vector) request.getAttribute("B04PromotionData_vt");
    //Vector Pyunga1_vt = (Vector) B04PromotionData_vt.get(0);
//    Vector Pyunga_vt = SortUtil.sort(Pyunga1_vt, "PROM_YEAR", "desc");
    B04PromotionCData fielddata = (B04PromotionCData) request.getAttribute("B04PromotionCData");

    Vector Pyunga1_vt = fielddata.PYUNGA_TAB;
    Vector Pyunga_vt = SortUtil.sort(Pyunga1_vt, "PROM_YEAR", "desc");

    B01ValuateDetailDB valuateDetailDB = new B01ValuateDetailDB();
    String DB_YEAR = valuateDetailDB.getYEAR();
    String StartDate = valuateDetailDB.getStartDate();

    RFCReturnEntity result = (RFCReturnEntity) request.getAttribute("result");

%>

<jsp:include page="/include/header.jsp"/>
<script language="javascript">
    <!--
    function doSubmit() {
        <%
          if(!fielddata.E_CFLAG.equals("")){
        %>
//    if(!confirm("직간전환자(신분변경 포함), 재입사자(지사근무 포함), 일부 경력입사자 등의 Case에 대해서는\n채용품의시 명시된 별도의 진급자격을 적용함에 따라 정확한 Simulation을 제공하지 못합니다.")){
        if (!confirm("<%=g.getMessage("MSG.B.B01.0001") %>")) {
            return;
        }
        <%
        }
        %>
        window.open('', 'essPopup', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=670,height=500,scrollbars=yes,left=100,top=100');
        document.form1.jobid.value = "pop";
        document.form1.target = "essPopup";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.B.B04Promotion.B04PromotionListSV';
        document.form1.method = "post";
        document.form1.submit();
    }

    function moveScroll(page) {
        var _endPage = parent.frames["endPage"];

        _endPage.document.documentElement.scrollTop = _endPage.$("a[name=" +  page + "]").offset().top;
        _endPage.$("body").scrollTop(_endPage.$("a[name=" +  page + "]").offset().top);
    }

    //-->
</script>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PA_PROM_SIMU"/>
    <jsp:param name="always" value="true"/>
    <jsp:param name="click" value="Y"/>
</jsp:include>

<form name="form1" method="post">
    <%

    // [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  start
    /*
      if (result.isSuccess() && (user.e_trfar).equals("02") && ((user.e_trfgr).equals("Ⅱ-1급") || (user.e_trfgr).equals("Ⅱ-2급")
            || (user.e_trfgr).equals("Ⅲ급") || (user.e_trfgr).equals("Ⅲ-1급")
            || (user.e_trfgr).equals("Ⅲ-2급") || (user.e_trfgr).equals("Ⅳ-1급")
            || (user.e_trfgr).equals("Ⅳ-2급") || (user.e_trfgr).equals("Ⅳ-3급"))) {
    */
        if (result.isSuccess()
        		&& ((user.e_trfgr).equals("L1A") || (user.e_trfgr).equals("L1B")||(user.e_trfgr).equals("L2"))
        		)

        {
     // [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  end
    %>
    <div class="tableInquiry">
        <table width="760" border="0" cellspacing="1" cellpadding="0">
            <tr>
                <td width="300">
                    <img src="<%= WebUtil.ImageURL %>sshr/ico_bullet2.gif" width="12" height="11" align="absmiddle">
                    <a  onclick="moveScroll('1')"
                       target="endPage"><%=g.getMessage("MSG.B.B01.0003") %><%--평가등급--%></a>
                    &nbsp;&nbsp;&nbsp;
                    <img src="<%= WebUtil.ImageURL %>sshr/ico_bullet2.gif" width="12" height="11" align="absmiddle">
                    <a  onclick="moveScroll('2')"
                       target="endPage"><%=g.getMessage("MSG.B.B01.0004") %><%--필수교육--%></a>
                    &nbsp;&nbsp;&nbsp;
                    <img src="<%= WebUtil.ImageURL %>sshr/ico_bullet2.gif" width="12" height="11" align="absmiddle">
                    <a  onclick="moveScroll('3')"
                       target="endPage"><%=g.getMessage("MSG.B.B01.0005") %><%--어학--%></a>
                    &nbsp;&nbsp;&nbsp;
                    <!--
                          <img src="<%= WebUtil.ImageURL %>icon_arrow_box.gif" width="9" height="9" align="absmiddle">
                            <a href="<%= WebUtil.ServletURL %>hris.B.B04Promotion.B04PromotionListSV?jobid=end#4" target="endPage">6sigma 인증</a>
                          -->
                </td>
                <td width="80"><%=g.getMessage("MSG.B.B01.0006") %><%--진급대상구분--%></td>
                <td width="110">

                    <input type="text" name="PROM_NAME" size="20" value="<%=fielddata.E_PROM_NAME%>" readonly>
                </td>
                <td>
                    <div class="btn_crud">
                        <%
                            if (user.companyCode.equals("C100") && Utils.getSize(Pyunga_vt) > 0) {
                                // R/3이관된 평가data의 평가년도가 평가년도(HRES)와 같고, 평가결과조회일자(HRES)가 현재일자보다 늦은 경우 해당data가 조회되지 않도록 함.
                                B04PromotionAData pyungadata = (B04PromotionAData) Pyunga_vt.get(0);
                                if ((NumberUtils.toInt(fielddata.E_GIJUN_AMNT) > NumberUtils.toInt(fielddata.E_SCPM_AMNT)) && !(pyungadata.PROM_YEAR.equals(DB_YEAR) && (Long.parseLong(StartDate) > Long.parseLong(DataUtil.getCurrentDate())))) { %>
                        <!-- <a href="javascript:doSubmit()">
                                <img src="<%= WebUtil.ImageURL %>btn_simulation.gif" align="absmiddle" border="0">
                              </a>-->
                        <%
                            }
                        } else { %>
                        <a href="javascript:doSubmit()"><span><%=g.getMessage("MSG.B.B01.0007") %><%--시뮬레이션--%></span></a>
                        <!-- <a href="javascript:doSubmit()">
                                <img src="<%= WebUtil.ImageURL %>btn_simulation.gif" align="absmiddle" border="0">
                              </a> -->
                        <%
                            } %>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <%
    // [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件
    } else if ((user.e_trfgr).equals("L3")){
    %>
    <div>
        <p><%=g.getMessage("MSG.B.B01.0066") %><%--진급 대상자가 아닙니다. --%></p>
    </div>
    <%
    } else {
    %>
    <div>
        <p><%=g.getMessage("MSG.B.B01.0008") %><%--진급자격요건 시뮬레이션을 사용할 수 없습니다.--%></p>
    </div>

    <%
        }
    %>
    <input type="hidden" name="jobid" value="">
</form>

<jsp:include page="/include/body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>

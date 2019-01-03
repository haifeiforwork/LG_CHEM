<%@ page import="hris.B.B04Promotion.B04PromotionCData" %>
<%@ page import="hris.B.db.B01ValuateDetailDB" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.common.*" %>
<%@ page import="hris.B.B04Promotion.B04PromotionAData" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%@ page import="hris.B.B04Promotion.B04PromotionBData" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 진급자격요건 시뮬레이션                                     */
/*   Program Name : 진급자격요건 시뮬레이션                                     */
/*   Program ID   : B04PromotionDetail.jsp                                      */
/*   Description  : 진급자격요건 시뮬레이션을 조회                              */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                      [CSR ID:2748124] E-HR 내 진급 시뮬레이션 화면 조정 件                                                         */
/*                      [CSR ID:3268071] 사내표준 내 진급제도 파일 변경 요청의 件  */
/*                      2017-11-15 eunha [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件                  */
/*  				 2017-12-15 cykim    [CSR ID:3554436] 진급 규정 HR Portal Update 반영 요청의 건 	*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user         = (WebUserData)session.getAttribute("user");

    B01ValuateDetailDB valuateDetailDB     = new B01ValuateDetailDB();
    String       DB_YEAR            = valuateDetailDB.getYEAR();
    String       StartDate           = valuateDetailDB.getBossStartDate();

%>


<jsp:include page="/include/header.jsp"/>
<script>
    function  doSearchDetail() {
        document.form1.action = "";
        document.form1.jobid.value = "";
        document.form1.target = "";
        document.form1.submit();
    }
</script>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.MSS_PA_PROM_SIMU"/>
    <jsp:param name="always" value="true"/>
</jsp:include>
<form name="form1" method="post">

    <%@ include file="/web/common/SearchDeptPersons_m.jsp" %>

    <%
        if (user_m != null && "X".equals(user_m.e_mss) && StringUtils.isNotBlank(user_m.empNo)) {

            B04PromotionCData fielddata = (B04PromotionCData) request.getAttribute("B04PromotionCData");

            /*Vector Pyunga1_vt = fielddata.PYUNGA_TAB;
            Vector Pyunga_vt = SortUtil.sort(Pyunga1_vt, "PROM_YEAR", "desc");*/

            Vector Pyunga_vt = (Vector) request.getAttribute("Pyunga_vt");
            Vector Edu_vt = (Vector) request.getAttribute("Edu_vt");
            Vector PyunggaScore_vt = (Vector) request.getAttribute("PyunggaScore_vt");
            Vector Lang_vt = (Vector) request.getAttribute("Lang_vt");
            Vector LangGijun_vt = (Vector) request.getAttribute("LangGijun_vt");
            /*B04PromotionCData fielddata = (B04PromotionCData) request.getAttribute("B04PromotionCData");*/

            String       EVAL_AMNT_T = "0";

            RFCReturnEntity result = (RFCReturnEntity) request.getAttribute("result");

    %>
    <script language="javascript">
        <!--


        function doSubmit() {
            <%
             if(!fielddata.E_CFLAG.equals("")){
            %>
            if(!confirm("직간전환자(신분변경 포함), 재입사자(지사근무 포함), 일부 경력입사자 등의 Case에 대해서는\n채용품의시 명시된 별도의 진급자격을 적용함에 따라 정확한 Simulation을 제공하지 못합니다.")){
                return;
            }
            <%
             }
            %>
            window.open('', 'essPopup', 'toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=670,height=500,scrollbars=yes,left=100,top=100');
            document.form1.jobid.value = "pop";
            document.form1.target = "essPopup";
            document.form1.action = '<%= WebUtil.ServletURL %>hris.B.B04Promotion.B04PromotionListSV_m';
            document.form1.method = "post";
            document.form1.submit();
        }

        function moveScroll(page) {
            var _endPage = parent.endPage;

            var _pageTop = $("a[name=" +  page + "]").offset().top;
            document.documentElement.scrollTop = _pageTop;
            $("body").scrollTop(_pageTop);
        }

        //-->
    </script>
    <%

    // [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  start
    /*if(result.isSuccess() &&  (user_m.e_trfar).equals("02") && ( (user_m.e_trfgr).equals("Ⅱ-1급") || (user_m.e_trfgr).equals("Ⅱ-2급")
            || (user_m.e_trfgr).equals("Ⅲ급")   || (user_m.e_trfgr).equals("Ⅲ-1급")
            || (user_m.e_trfgr).equals("Ⅲ-2급") || (user_m.e_trfgr).equals("Ⅳ-1급")
            || (user_m.e_trfgr).equals("Ⅳ-2급") || (user_m.e_trfgr).equals("Ⅳ-3급") ) ){
    */

    if (result.isSuccess()
        		&& ((user_m.e_trfgr).equals("L1A") || (user_m.e_trfgr).equals("L1B")||(user_m.e_trfgr).equals("L2")))

        {
	// [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  end
    	%>
    <div class="tableInquiry">
        <table width="760" border="0" cellspacing="1" cellpadding="0">
            <tr>
                <td class="td09" width="300">
                    <img src="<%= WebUtil.ImageURL %>icon_arrow_box.gif" width="9" height="9" align="absmiddle">
                    <a href="javascript:;" class="unloading" onclick="moveScroll('1')" ><%=g.getMessage("MSG.B.B01.0003") %><%--평가등급--%></a>
                    &nbsp;&nbsp;&nbsp;
                    <img src="<%= WebUtil.ImageURL %>icon_arrow_box.gif" width="9" height="9" align="absmiddle">
                    <a href="javascript:;" class="unloading" onclick="moveScroll('2')" ><%=g.getMessage("MSG.B.B01.0004") %><%--필수교육--%></a>
                    &nbsp;&nbsp;&nbsp;
                    <img src="<%= WebUtil.ImageURL %>icon_arrow_box.gif" width="9" height="9" align="absmiddle">
                    <a href="javascript:;" class="unloading" onclick="moveScroll('3')" ><%=g.getMessage("MSG.B.B01.0005") %><%--어학--%></a>
                    &nbsp;&nbsp;&nbsp;
                    <!--
                              <img src="<%= WebUtil.ImageURL %>icon_arrow_box.gif" width="9" height="9" align="absmiddle">
                                <a href="<%= WebUtil.ServletURL %>hris.B.B04Promotion.B04PromotionListSV_m?jobid=end#4" >6sigma 인증</a>
                                -->
                </td>
                <td class="td09" width="80"><%=g.getMessage("MSG.B.B01.0006") %><%--진급대상구분--%></td>
                <td class="td09" width="110">
                    <input type="text" name="PROM_NAME" size="20" class="input04" value="<%=fielddata.E_PROM_NAME%>" readonly>
                </td>
                <td class="td09" align="right">
                    <%
                        if( user_m.companyCode.equals("C100") && Utils.getSize(Pyunga_vt) > 0 ) {
                            // R/3이관된 평가data의 평가년도가 평가년도(HRES)와 같고, 평가결과조회일자(HRES)가 현재일자보다 늦은 경우 해당data가 조회되지 않도록 함.
                            B04PromotionAData pyungadata = (B04PromotionAData)Pyunga_vt.get(0);
                            if ( (NumberUtils.toInt(fielddata.E_GIJUN_AMNT) > NumberUtils.toInt(fielddata.E_SCPM_AMNT))&&!(pyungadata.PROM_YEAR.equals(DB_YEAR)&&(Long.parseLong(StartDate) > Long.parseLong(DataUtil.getCurrentDate()))) ) { %>
                    <a href="javascript:doSubmit()">
                        <img src="<%= WebUtil.ImageURL %>btn_simulation.gif" align="absmiddle" border="0">
                    </a>
                    <%
                        }
                    } else { %>
                    <a href="javascript:doSubmit()">
                        <img src="<%= WebUtil.ImageURL %>btn_simulation.gif" align="absmiddle" border="0">
                    </a>
                    <%
                        } %>
                </td>
            </tr>
        </table>
    </div>

    <%
        if (user_m != null && StringUtils.isNotBlank(user_m.empNo)) {
    %>
    <%
        if (user.companyCode.equals("C100")) { %>


    <div class="textDiv">
        <p><%=g.getMessage("MSG.B.B01.0010") %><%--本 진급자격요건 Simulation은 신입사원으로 입사하여 정상적인 진급 단계를 거친 경우를 기준으로 본인의
                  진급관련 사항을 조회하는 서비스를 제공하는 기능입니다. <br>
                  단, 직간전환자(신분변경 포함), 재입사자(지사근무 포함), 일부 경력입사자 등의 Case에 대해서는 채용품의시
                  명시된 별도의 진급자격을 적용함에 따라 정확한 Simulation을 제공하지 못하므로
                  첨부의 진급제도를 참조하시거나 또는 인사기획팀(진급담당자)으로
                문의해 주시기 바랍니다.--%>
        </p>

        <!-- [CSR ID:2561802] <a href="/web/B/B04Promotion/B04_2010Guide.pdf" target="_blank"><font color="#006699">※사무기술직 --></b>
        <!-- [CSR ID:2688370] 사무기술직 진급제도 안내 파일 변경 요청의 件 [CSR ID:2999612] '16년 진급제도 관련 파일 Update 요청 -->
        <!-- </b><a href="http://bssprod.lgchem.com/lightpack/lgccom/lgcComFileViewerView.do?printFlag=Y&fileIdParam=2B2K8cI9kzNyY0TkHQHX2g" target="_new"><font color="#006699">※사무기술직 -->
        <!-- [CSR ID:3268071]<a href="http://bssprod.lgchem.com/lightpack/lgccom/lgcComFileViewerView.do?fileIdParam=GzdeZaTiwOrWV7H9IW19bA" -->
        <!-- <a href="http://bssprod.lgchem.com/lightpack/lgccom/lgcComFileViewerView.do?fileIdParam=mTjwuD5eVpRWHTTowYxQ"
           target="_new"> -->
        <!-- [CSR ID:3554436] 진급 규정 HR Portal Update 반영 요청의 건 start-->
           <a href="http://bssprod.lgchem.com/lightpack/lgccom/lgcComFileViewerView.do?fileIdParam=Pm8Z8eItLeAsQGUvd7hdw" target="_new">
        <!-- [CSR ID:3554436] 진급 규정 HR Portal Update 반영 요청의 건 end-->
            <span class="inlineComment"><%=g.getMessage("MSG.B.B01.0011") %><%--※사무기술직 진급제도 안내--%></span>
        </a>
    </div>

    <%
        }



        String sb = "";
        String sb1 = "";
        String sb2 = "";
        String sb3 = "";
        String sb4 = "";
        String sb5 = "";

        for (int i = 0; i < PyunggaScore_vt.size(); i++) {
            B04PromotionBData pdata = (B04PromotionBData) PyunggaScore_vt.get(i);
            if (i == 0) {
                sb = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
            } else if (i == 1) {
                sb1 = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
            } else if (i == 2) {
                sb2 = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
                sb5 = g.getMessage("MSG.B.B01.0009", pdata.EVAL_LEVL, WebUtil.printNum(pdata.EVAL_AMNT));  //"입사시 인정경력 기간중에는 개인평가 등급을 "+pdata.EVAL_LEVL+"등급 "+WebUtil.printNum(pdata.EVAL_AMNT)+"점 기준으로 진급누적점수 산정에 반영하였음.";
            } else if (i == 3) {
                sb3 = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
            } else if (i == 4) {
                sb4 = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
            }
        }
    %>

    <h2 class="subtitle"><a name="1"><%=g.getMessage("MSG.B.B01.0003") %><%--평가등급--%></a></h2>



    <!--평가등급 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table border="0" cellspacing="0" cellpadding="2" class="listTable">
                <thead>
                <tr>
                    <th><%=g.getMessage("MSG.B.B01.0012") %><%--평가년도--%></th>
                    <th><%=g.getMessage("MSG.B.B01.0003") %><%--평가등급--%></th>
                    <th class="lastCol"><%=g.getMessage("MSG.B.B01.0013") %><%--점수화--%></th>
                </tr>
                </thead>
                <%
                    // R/3이관된 평가data의 평가년도가 평가년도(HRES)와 같고, 평가결과조회일자(HRES)가 현재일자보다 늦은 경우 해당data가 조회되지 않도록 함.
                    for (int i = 0; i < Pyunga_vt.size(); i++) {
                        B04PromotionAData pyungadata = (B04PromotionAData) Pyunga_vt.get(i);

                        String tr_class = "";

                        if(i%2 == 0){
                            tr_class="oddRow";
                        }else{
                            tr_class="";
                        }

                        if (user.companyCode.equals("C100") && pyungadata.PROM_YEAR.equals(DB_YEAR) && (Long.parseLong(StartDate) > Long.parseLong(DataUtil.getCurrentDate()))) {
                            EVAL_AMNT_T = pyungadata.EVAL_AMNT;
                        } else {
                %>
                <tr class="<%=tr_class%>">
                    <td><%= pyungadata.PROM_YEAR %></td>
                    <td><%= pyungadata.EVAL_LEVL %></td>
                    <td class="lastCol"><%= WebUtil.printNum(pyungadata.EVAL_AMNT) %>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </table>
        </div>
        <% if (StringUtils.isNotBlank(fielddata.E_GIJUN_AMNT) && (NumberUtils.toInt(fielddata.E_GIJUN_AMNT) <= (NumberUtils.toInt(fielddata.E_SCPM_AMNT) - NumberUtils.toInt(EVAL_AMNT_T)))) { %>
        <font class="td04"><%=g.getMessage("MSG.B.B01.0014") %><%--진급점수 기준을 충족하셨습니다.--%></font>
        <% } %>
        <div class="buttonArea">
            <div class="btn_crud">
                <input type="text" name="SCPM_AMNT" size="15" style="text-align:right"
                       value="<%=  WebUtil.printNum(NumberUtils.toInt(fielddata.E_SCPM_AMNT)-NumberUtils.toInt(EVAL_AMNT_T))%>"
                       readonly>
            </div>
        </div>
    </div>

    <!--평가등급 테이블 끝-->

    <div class="textDiv">
        <div class="commentImportant">
            <p><strong><%=g.getMessage("MSG.B.B01.0015") %><%--직급별 진급심의 대상선정 평가기준 점수--%></strong></p>
            <p>
                <input type="text" name="PROM_NAME" size="18" value="<%= fielddata.E_PROM_NAME %>" readonly>
                <input type="text" name="GIJUN_AMNT" size="15" style="text-align:right"
                       value="<%=g.getMessage("MSG.B.B01.0016", fielddata.E_GIJUN_AMNT) %><%--<%= fielddata.E_GIJUN_AMNT %> 점 이상--%>"
                       readonly>
            </p>
            <p><strong><%=g.getMessage("MSG.B.B01.0017") %>
            </strong></p>
            <p><input type="text" name="GIJUN" size="40" value="<%=sb4%>  <%=sb3%>  <%=sb2%>  <%=sb1%>  <%=sb%>"
                      readonly></p>
        </div>
        <span class="inlineComment"><%= sb5%></span>
    </div>

    <h2 class="subtitle"><a name="2"><%=g.getMessage("MSG.B.B01.0018") %><%--진급필수교육이수 현황--%></a></h2>

   <!--진급필수 테이블 시작-->
    <div class="listArea">
    	<div class="table">
        <table border="0" cellspacing="0" cellpadding="2" class="listTable">
            <thead>
            <tr>
                <th><%=g.getMessage("MSG.B.B01.0019") %><%--필수교육명--%></th>
                <th class="lastCol"><%=g.getMessage("MSG.B.B01.0020") %><%--이수여부--%></th>
            </tr>
            </thead>
                  <%
            if ( Utils.getSize(Edu_vt) > 0) {
            	B04PromotionAData edudata =  (B04PromotionAData)Utils.indexOf(Edu_vt, 0, B04PromotionAData.class);
        %>
        <tr  class="oddRow">
                <td><%=edudata.EDU_NAME %>
                </td>
                <td class="lastCol"><%=edudata.EDU_FLAG.equals("Y") ? g.getMessage("MSG.B.B01.0021") : g.getMessage("MSG.B.B01.0022")  %>
                </td>
                <%-- 이수, 미이수 --%>
            </tr>
        </table>
        </div>
        <div class="buttonArea">
	        <div class="btn_crud">
	            <input type="text" name="EDU_FLAG" size="15"
	                   value="<%= edudata.EDU_FLAG.equals("Y") ? g.getMessage("MSG.B.B01.0021") : g.getMessage("MSG.B.B01.0022") %>"
	                   readonly><%-- "이수" : "미이수" --%>
	        </div>
        </div>
        <%
        } else {
        %>

        </table>
        </div>

        <div class="buttonArea">
	        <div class="btn_crud">
	            <input type="text" name="EDU_FLAG" size="15"   readonly><%-- "이수" : "미이수" --%>
	        </div>
        </div>
        <%
            }
        %>
        </div>
    </div>

    <!--진급필수 테이블 끝-->

    <h2 class="subtitle"><a name="3"><%=g.getMessage("MSG.B.B01.0005") %><%--어학--%></a></h2>

    <!--어학 테이블 시작-->
    <div>
        <div class="listArea">
            <div class="table">
                <table border="0" cellspacing="0" cellpadding="0" class="listTable">
                    <thead>
                    <tr>
                        <th><%=g.getMessage("MSG.B.B01.0023") %>어학명</th>
                        <th><%=g.getMessage("MSG.B.B01.0024") %>어학점수/등급</th>
                        <th class="lastCol"><%=g.getMessage("MSG.B.B01.0025") %>기준</th>
                    </tr>
                    </thead>
                    <%
                        for (int i = 0; i < Lang_vt.size(); i++) {
                            B04PromotionBData langbdata = (B04PromotionBData) Lang_vt.get(i);

                            String tr_class = "";

                            if (i % 2 == 0) {
                                tr_class = "oddRow";
                            } else {
                                tr_class = "";
                            }
                    %>
                    <tr class="<%=tr_class%>">
                        <td><%=langbdata.LANG_NAME %>
                        </td>
                        <td><%=WebUtil.printNum(langbdata.LANG_AMNT) %>
                        </td>
                        <td class="lastCol"><%=WebUtil.printNum(langbdata.GIJUN_AMNT) %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
            <span class="inlineComment">
              <% if (fielddata.E_LANG_FLAG.equals("Y")) { %>
                <%=g.getMessage("MSG.B.B01.0026") %><%--진급어학 기준자격요건을 충족하셨습니다.--%>
              <% } else if (LangGijun_vt.size() == 0) { %>
                <%=g.getMessage("MSG.B.B01.0027") %><%--당 승급구간은 어학기준이 없습니다.--%>
              <% } else { %>
                <%=g.getMessage("MSG.B.B01.0028") %><%--진급어학기준 자격요건에 도달하기에는 좀 더 노력이 필요합니다.--%>
              <% } %>
            </span>
        </div>

    </div>

    <% if (LangGijun_vt.size() != 0) {%>

    <div class="commentImportant textDiv">

        <p><strong><%=g.getMessage("MSG.B.B01.0029") %><%--직급별 진급심의 대상선정 어학기준점수--%></strong></p>
        <p>- <%=g.getMessage("MSG.B.B01.0030") %><%--어학구분별 기준--%></p>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%
                for (int i = 0; i < LangGijun_vt.size(); i++) {
                    B04PromotionCData gijundata = (B04PromotionCData) LangGijun_vt.get(i);
            %>
            <colgroup>
                <col width="200">
                <col width="">
            </colgroup>
            <tr>
                <td>
                    <input type="text" name="lang_name" style="text-align:right" value="<%= gijundata.LANG_NAME %>"
                           readonly>
                    <input type="text" name="text001" size="1" value=":" readonly>
                </td>
                <td class="style01">
                    <input type="text" name="lang_amnt"
                           value="<%= WebUtil.printNum(gijundata.LANG_AMNT) %> <%=g.getMessage("MSG.B.B01.0031") %><%--점수/등급--%>"
                           readonly>
                    <!-- CSR ID:2724630 어학점수 2번째 기준 추가 -->
                    <%if (WebUtil.printNum(gijundata.LANG_AMNT1).length() > 1) { %>
                    <input type="text" name="lang_amnt1"
                           value="(<%=g.getMessage("MSG.B.B01.0016", WebUtil.printNum(gijundata.LANG_AMNT1)) %> <%--WebUtil.printNum(gijundata.LANG_AMNT1) 점 이상--%>)"
                           readonly>

                    <%} %>
                </td>
            </tr>
            <%
                }
            %>
        </table>


    </div>

    <% } %>





    <%
        }
    %>

    <%
    // [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  start
    } else if ( (user_m.e_trfgr).equals("L3")){
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
        }%>
    <%}else{
    %>
        <div>
    <p>시스템 점검중 입니다.</p>
</div>
<%--[CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 2017-06-15 eunha end --%>
<%} %>

</form>
<jsp:include page="/include/body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>

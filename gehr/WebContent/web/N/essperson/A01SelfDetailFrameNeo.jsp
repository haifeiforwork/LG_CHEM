<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<jsp:useBean id="a01SelfDetailData" class="hris.A.A01SelfDetailData" scope="request"/>
<!-- 개인사항-->
<jsp:useBean id="a08LicenseDetail_vt" class="java.util.Vector" scope="request"/>
<!-- 자격사항 -->
<jsp:useBean id="a02SchoolData_vt" class="java.util.Vector" scope="request"/>
<!-- 학력사항 -->
<%
    WebUserData user = WebUtil.getSessionUser(request);
    /*int insaFlag = user.e_authorization.indexOf("H");    //인사담당*/
%>
<jsp:include page="/include/header.jsp"/>
<SCRIPT LANGUAGE="JavaScript">
    <!--
    function doSearchDetail() {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }

    function view_detail(idx) {
        if ($("input[name=FLAG" + idx + "]").val() == "X") {    // 자격수당이 있는 경우..
            window.open('', 'essPopup', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=552,height=365,left=100,top=100");

            document.form1.jobid2.value = "license_pop";
            document.form1.licn_code.value = $("input[name=LICN_CODE" + idx + "]").val();;

            document.form1.target = "essPopup";
            document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A01SelfDetailSV_m";
            document.form1.method = "post";
            document.form1.submit();
        }
    }

    //-->
</SCRIPT>

<body>
<form name="form1" method="post">
    <div class="subWrapper">
        <h2 class="subtitle">주소 및 신상</h2>
        <div class="tableArea">
            <%
                // 사원 검색한 사람이 없을때
                if (user != null) {
            %>
            	<div class="table">
	 	           <table class="tableGeneral" cellspacing="0">
	                <tr>
	                    <th>현주소</th>
	                    <td>&nbsp;&nbsp;<%= a01SelfDetailData.STRAS1 %>
	                    </td>
	                    <th class="th02">우편번호</th>
	                    <td colspan="5"><%= a01SelfDetailData.PSTLZ1 %>&nbsp;</td>
	                </tr>
	                <tr>
	                    <th>본적</th>
	                    <td colspan="4">&nbsp;&nbsp;<%= a01SelfDetailData.STRAS %>
	                    </td>
	                    <th class="th02">우편번호</th>
	                    <td colspan="2"><%= a01SelfDetailData.PSTLZ %>&nbsp;</td>
	                </tr>
	                <tr>
	                    <th>신장</th>
	                    <td><%= a01SelfDetailData.NMF01.equals("") ? "" : WebUtil.printNum(a01SelfDetailData.NMF01) + " ㎝" %>
	                        &nbsp;</td>
	                    <th class="th02">체중</th>
	                    <td><%= a01SelfDetailData.NMF02.equals("") ? "" : WebUtil.printNum(a01SelfDetailData.NMF02) + " ㎏" %>
	                        &nbsp;</td>
	                    <th class="th02">시력(좌)</th>
	                    <td><%= a01SelfDetailData.NMF06.equals("") ? "" : WebUtil.printNumFormat(a01SelfDetailData.NMF06, 1) %>
	                        &nbsp;</td>
	                    <th class="th02">시력(우)</th>
	                    <td><%= a01SelfDetailData.NMF07.equals("") ? "" : WebUtil.printNumFormat(a01SelfDetailData.NMF07, 1) %>
	                        &nbsp;</td>
	                </tr>
	                <tr>
	                    <th>색맹</th>
	                    <td><%= a01SelfDetailData.FLAG.equals("N") ? "정상" : "비정상" %>&nbsp;</td>
	                    <th class="th02">혈액형</th>
	                    <td><%= a01SelfDetailData.STEXT %>&nbsp;</td>
	                    <th class="th02">장애</th>
	                    <td><%= a01SelfDetailData.FLAG1.equals("N") ? "" : a01SelfDetailData.FLAG1 %>&nbsp;</td>
	                    <th class="th02">특기</th>
	                    <td><%= a01SelfDetailData.HBBY_TEXT1 %>&nbsp;</td>
	                </tr>
	                <tr>
	                    <th>혼인여부</th>
	                    <td><%= a01SelfDetailData.FTEXT %>&nbsp;</td>
	                    <th class="th02">주거형태</th>
	                    <td><%= a01SelfDetailData.LIVE_TEXT %>&nbsp;</td>
	                    <th class="th02">종교</th>
	                    <td><%= a01SelfDetailData.KTEXT %>&nbsp;</td>
	                    <th class="th02">취미</th>
	                    <td><%= a01SelfDetailData.HBBY_TEXT %>&nbsp;</td>
	                </tr>
	                <tr>
	                    <%
	                        if (user.companyCode.equals("C100")) {
	                    %>
	                    <th>보훈대상</th>
	                    <td colspan="7">&nbsp;&nbsp;<%= a01SelfDetailData.CONTX %>&nbsp;</td>
	                    <%
	                        //  석유화학의 경우 개인의 핸드폰 번호를 보여준다.
	                    } else if (user.companyCode.equals("N100")) {
	                    %>
	                    <th>보훈대상</th>
	                    <td colspan="4">&nbsp;&nbsp;<%= a01SelfDetailData.CONTX %>&nbsp;</td>
	                    <th class="th02">휴대폰</th>
	                    <td colspan="2">&nbsp;</td>
	                    <%
	                            }
	                        }
	                    %>
	                </tr>
	            </table>
            </div>
        </div>

        <h2 class="subtitle">병역사항</h2>
        <div class="tableArea">
        	<div class="table">
	            <table class="tableGeneral" cellspacing="0">
	                <tr>
	                    <th>실역구분</th>
	                    <td><%= a01SelfDetailData.TRAN_TEXT %>&nbsp;</td>
	                    <th class="th02">면제사유</th>
	                    <td colspan="5"><%= a01SelfDetailData.RSEXP %>&nbsp;</td>
	                </tr>
	                <tr>
	                    <th>군별</th>
	                    <td><%= a01SelfDetailData.SERTX %>&nbsp;</td>
	                    <th class="th02">계급</th>
	                    <td><%= a01SelfDetailData.RKTXT %>&nbsp;</td>
	                    <th class="th02">주특기</th>
	                    <td><%= a01SelfDetailData.JBTXT %>&nbsp;</td>
	                    <th class="th02">근무부대</th>
	                    <td><%= a01SelfDetailData.SERUT %>&nbsp;</td>
	                </tr>
	                <tr>
	                    <th>전역사유</th>
	                    <td class="td04"><%= a01SelfDetailData.RTEXT %>&nbsp;</td>
	                    <th class="th02">군번</th>
	                    <td colspan="2"><%= a01SelfDetailData.IDNUM %>&nbsp;</td>
	                    <th class="th02">복무기간</th>
	                    <td colspan="2"><%= a01SelfDetailData.PERIOD.equals("0000.00.00~0000.00.00") ? "" : a01SelfDetailData.PERIOD %>
	                        &nbsp;</td>
	                </tr>
	            </table>
			</div>
        </div>

        <h2 class="subtitle">자격면허</h2>
        <div class="listArea">
        	<div class="table">
	            <table class="listTable" cellspacing="0">
	                <thead>
	                <tr>
	                    <th>자격면허</th>
	                    <th>취득일</th>
	                    <th>등급</th>
	                    <th>발행기관</th>
	                    <th class="lastCol">법정선임사유</th>
	                </tr>
	                </thead>
	                <tbody>
	                <%

	                    if (a08LicenseDetail_vt.size() > 0) {
	                        for (int i = 0; i < a08LicenseDetail_vt.size(); i++) {
	                            A08LicenseDetailData licndata = (A08LicenseDetailData) a08LicenseDetail_vt.get(i);

	                            String tr_class = "";

	                            if (i % 2 == 0) {
	                                tr_class = "oddRow";
	                            } else {
	                                tr_class = "";
	                            }

	                %>
	                <tr class="<%=tr_class%>">
	                    <%
	                        if (licndata.FLAG.equals("X")) {
	                    %>
	                    <td><a href="javascript:view_detail(<%=i%>)"><font color="#006699"><%= licndata.LICN_NAME %>
	                    </font></a></td>
	                    <%
	                    } else {
	                    %>
	                    <td><%= licndata.LICN_NAME %>
	                    </td>
	                    <%
	                        }
	                    %>
	                    <td><%= licndata.OBN_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(licndata.OBN_DATE) %>
	                    </td>
	                    <td><%= licndata.GRAD_NAME %>
	                    </td>
	                    <td><%= licndata.PUBL_ORGH %>
	                    </td>
	                    <td class="lastCol"><%= licndata.ESTA_AREA %>
	                    </td>
	                    <input type="hidden" name="LICN_CODE<%= i %>" value="<%= licndata.LICN_CODE %>">
	                    <input type="hidden" name="FLAG<%= i %>" value="<%= licndata.FLAG %>">
	                </tr>
	                <%
	                    }
	                } else {
	                %>
	                <tr align="center">
	                    <td class="lastCol" colspan="5">해당하는 데이터가 존재하지 않습니다.</td>
	                </tr>
	                <%
	                    }
	                %>
	                </tbody>
	            </table>
			</div>
        </div>

        <h2 class="subtitle">학력사항</h2>
        <div class="listArea">
        	<div class="table">
	            <table class="listTable" cellspacing="0">
	                <thead>
	                <tr>
	                    <th>기 간</th>
	                    <th>학교명</th>
	                    <th>전 공</th>
	                    <th>졸업구분</th>
	                    <th>소재지</th>
	                    <th class="lastCol">입사시 학력</th>
	                </tr>
	                </thead>
	                <tbody>
	                <%
	                    int cnt = 5;
	                    if (a02SchoolData_vt.size() < 5) { // 학력사항은 최근 5개 학력만 display 한다.
	                        cnt = a02SchoolData_vt.size();
	                    }
	                    if (a02SchoolData_vt.size() > 0) {
	                        for (int i = 0; i < cnt; i++) {
	                            A02SchoolData schldata = (A02SchoolData) a02SchoolData_vt.get(i);

	                            String tr_class = "";

	                            if (i % 2 == 0) {
	                                tr_class = "oddRow";
	                            } else {
	                                tr_class = "";
	                            }
	                %>
	                <tr class="<%=tr_class%>" align="center">
	                    <td><%= schldata.PERIOD    %>
	                    </td>
	                    <td><%= schldata.LART_TEXT %>
	                    </td>
	                    <td><%= schldata.FTEXT     %>
	                    </td>
	                    <td><%= schldata.STEXT     %>
	                    </td>
	                    <td>&nbsp;&nbsp;<%= schldata.SOJAE.equals("") ? "" : schldata.SOJAE %>
	                    </td>
	                    <td class="lastCol"><%= ((schldata.EMARK).toUpperCase()).equals("N") ? "" : schldata.EMARK %>
	                    </td>
	                </tr>
	                <%
	                    }
	                } else {
	                %>
	                <tr align="center">
	                    <td class="lastCol" colspan="6">해당하는 데이터가 존재하지 않습니다.</td>
	                </tr>
	                <%
	                    }
	                %>
	                </tbody>
	            </table>
			</div>
        </div>
    </div>

    <input type="hidden" name="jobid2" value="">
    <input type="hidden" name="licn_code" value="">
</form>
</body>
<jsp:include page="/include/footer.jsp"/>

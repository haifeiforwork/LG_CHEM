<%
    /******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주소                                                        */
/*   Program Name : 주소                                                        */
/*   Program ID   : A13AddressList.jsp                                          */
/*   Description  : 주소 목록 조회                                              */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-01-27  윤정현                                          */
/*                     @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel                                                         */
/********************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.A.A13Address.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.common.constant.Area" %>
<%@ page import="org.apache.commons.collections.CollectionUtils" %>
<%@ page import="com.google.common.collect.Lists" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<jsp:useBean id="a13AddressTypeData_vt" class="java.util.Vector" scope="request" />
<jsp:useBean id="a13AddressListData_vt" class="java.util.Vector" scope="request" />

<jsp:include page="/include/header.jsp"/>
<%
    WebUserData user = WebUtil.getSessionUser(request);

    boolean isApproval = Arrays.asList("DE").contains(user.area.name()); //신청 가능 지역
    boolean isInput = Arrays.asList("KR", "CN", "TW", "HK").contains(user.area.name()); //입력 가능 지역
    boolean isUpdate = Arrays.asList("KR", "CN", "TW", "HK").contains(user.area.name());    //수정 가능 지역
    //boolean isDetail = Arrays.asList("KR", "PL", "US").contains(user.area.name()); //조회 가능지역
    boolean isDetail = Arrays.asList("KR", "PL", "US", "MX").contains(user.area.name()); //조회 가능지역 @PJ.멕시코 법인 Rollout
%>
<SCRIPT LANGUAGE="JavaScript">
    <!--


<%  if(isApproval) { %>
    function doSubmit_Approval() {
        document.form1.jobid.value = "first";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A13Address.A13AddressApprovalBuildSV';
        document.form1.submit();
    }
<%  } %>
<%  if(isDetail) { %>
    function doSubmit() {
        document.form1.jobid.value = "detail";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A13Address.A13AddressListSV';
        document.form1.submit();
    }
<%  } %>
<%  if(isInput) { %>
    function doSubmit_Build() {
        if (document.form1.subtycount.value == document.form1.totalcount.value) {
            alert("<%=g.getMessage("MSG.A.A13.004") %>");  //더이상 입력 가능한 주소유형이 존재하지 않습니다.
            return;
        }

        document.form1.jobid.value = "first";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A13Address.A13AddressBuildSV';
        document.form1.submit();
    }
<%   } %>
<%   if(isUpdate) { %>
    function doSubmit_Change() {
        //본적,원적지 는 수정 안됨
<%  if(user.area == Area.KR) { %>
        if (document.form1.I_SUBTY.value == "1" || document.form1.I_SUBTY.value == "2") {
            alert("<%=g.getMessage("MSG.A.A13.005") %>");  //본적,원적지는 수정할 수 없습니다.\n인사팀에 문의하세요
            return;
        }
<%  } %>
        document.form1.jobid.value = "first";
        document.form1.action = '<%= WebUtil.ServletURL %>hris.A.A13Address.A13AddressChangeSV';
        document.form1.submit();
    }
<%  } %>

    function Detail_Show(p_idx) {
        $("#idx").val(p_idx);
    }
    //-->
</SCRIPT>
<%-- 주소목록 --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="MSG.A.A13.001" />
</jsp:include>
    <div class="tableArea">
    <form name="form1" method="post">
    	<div class="table">
            <input type="hidden" name="subView" value="${param.subView}"/>
            <input type="hidden" id="idx" name="idx" />
            <table class="listTable" cellspacing="0">
            <thead>
            <tr>
                <th><spring:message code="LABEL.COMMON.0014"/></th>
<%
    /*
    MSG.A.A13.006   =   유형
MSG.A.A13.007   =   우편번호
MSG.A.A13.008   =   주소
MSG.A.A13.009   =   주거형태
     */
    List<String> headerList = Lists.newArrayList(g.getMessage("MSG.A.A13.006"), g.getMessage("MSG.A.A13.007"), g.getMessage("MSG.A.A13.008")); //Arrays.asList("유형", "우편번호", "주소");    //기본 header
    List<String> colList = Lists.newArrayList("ANSTX", "PSTLZ", "ADRES");  //기본 내용부 column address

    if(user.area == Area.KR) {
        headerList = Arrays.asList(g.getMessage("MSG.A.A13.006"), g.getMessage("MSG.A.A13.007"), g.getMessage("MSG.A.A13.008"), g.getMessage("MSG.A.A13.009"));
        colList = Arrays.asList("ANSTX", "PSTLZ", "ADRES", "LIVE_TEXT");
    } else if(user.area == Area.HK) {
        headerList.remove(1);
        colList.remove(1); //HR 일 경우 우편번호 삭제
    }

    for(int n = 0; n < headerList.size(); n++) {
%>
                <th <%=Utils.isLast(headerList, n) ? "class=\"lastCol\"" : "" %>><%=headerList.get(n)%></th>
<%  } %>
            </tr>
            </thead>
            <tbody>
            <!--현재 입력되어있는 주소유형의 갯수를 저장한다.-->
            <input type="hidden" name="totalcount" value="<%= a13AddressListData_vt.size() %>">
<%
    for (int i = 0; i < Utils.getSize(a13AddressListData_vt); i++) {
        A13AddressListData data = (A13AddressListData) a13AddressListData_vt.get(i);
            data.setAddress(user.area);
%>
            <tr class="<%=i % 2 == 0 ? "oddRow" : ""%>">
                <td>
                    <input type="radio" name="I_SUBTY" value="<%= data.SUBTY %>" <%= i == 0 ? "checked" : "" %> onclick="Detail_Show(<%= i %>);">
                </td>
<%      for(int n = 0; n < colList.size(); n++) { %>
                <td <%=Utils.isLast(colList, n) ? "class=\"lastCol\"" : "" %>><%=Utils.getFieldValue(data, colList.get(n))%></td>
<%      } %>
            </tr>
<%
    }
%>
            <tags:table-row-nodata list="${a13AddressListData_vt}" col="4" />
            </tbody>
        </table>

    </div>
    <div class="buttonArea">
        <ul class="btn_crud">
<%  if(isApproval) { %>
            <li><a href="javascript:;" onclick="doSubmit_Approval();"><span><%=g.getMessage("BUTTON.COMMON.INSERT") %><%--입력--%></span></a></li>
<%  } %>
<%  if(isInput) { %>
            <li><a href="javascript:;" onclick="doSubmit_Build();"><span><%=g.getMessage("BUTTON.COMMON.INSERT") %><%--입력--%></span></a></li>
<%  } %>
<%  if(isUpdate) { %>
            <li><a href="javascript:;" onclick="doSubmit_Change();"><span><%=g.getMessage("BUTTON.COMMON.UPDATE") %><%--수정--%></span></a></li>
<%  } %>
<%  if(isDetail) { %>
            <li><a href="javascript:;" onclick="doSubmit();"><span><%=g.getMessage("BUTTON.COMMON.DETAIL") %><%--조회--%></span></a></li>
<%  } %>
        </ul>
       </div>
    </div>
<input type="hidden" name="jobid" value="">
<input type="hidden" name="subtycount" value="<%= a13AddressTypeData_vt.size() %>">
</form>
</div>
<jsp:include page="/include/body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>


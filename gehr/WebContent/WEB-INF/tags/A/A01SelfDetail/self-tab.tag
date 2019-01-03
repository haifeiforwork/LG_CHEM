<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ attribute name="tabType" type="java.lang.String" required="true" %>

<%--@elvariable id="user" type="hris.common.WebUserData"--%>
<%--@elvariable id="resultData" type="hris.A.A01SelfDetailData"--%>
<%--update [CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha--%>
<!-- @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  -->
<!-- @PJ.베트남 하이퐁 법인 Rollout 프로젝트 추가 관련(Area = OT("99")) 2018/04/02 Kang DM  -->
<tags:script>
    <script type="text/javascript">

        $(function() {
            $(".-tab-link").click(function() {
                $(".tab").find(".selected").removeClass("selected");
                $(this).addClass("selected");

                document.all.urlForm.action = $(this).data("url");
                document.all.urlForm.submit();

                /*document.all.listFrame.height = "0";*/
            });



            /*$(".tab").find("a:first").trigger("click").addClass("selected");*/
            $("#${empty param.tabid ? 'tab_1' : param.tabid}").trigger("click").addClass("selected");
        });

        function resizeIframe(height) {
            document.all.listFrame.height = height + 20;
        }

    </script>
</tags:script>

<div class="contentBody">
    <!-- 탭 시작 -->
    <div class="tabArea">
        <ul class="tab">
            <c:choose>
                <%-- ESS --%>
                <c:when test="${tabType == 'E'}">
                    <c:choose>
                        <c:when test="${user.area == 'KR'}">
                            <li><a id="tab_1" class="-tab-link" href="javascript:void(0);" data-url="${g.jsp}common/wait.jsp?url=${g.servlet}hris.N.essperson.A01SelfDetailNeoExtraSV" ><spring:message code="TAB.COMMON.0001" /><%--인사기본--%></a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a id="tab_1" class="-tab-link" href="javascript:void(0);" data-url="${g.jsp}common/wait.jsp?url=${g.servlet}hris.N.essperson.A01SelfDetailNeoExtraSV" ><spring:message code="TAB.COMMON.0087" /><%--학력--%></a></li>
                        </c:otherwise>
                    </c:choose>

                    <%--<c:if test="${user.area == 'KR'}">
                        <li><a class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.N.essperson.A01SelfDetailNeoPersonalSV" ><spring:message code="TAB.COMMON.0002" />&lt;%&ndash;신상/병역&ndash;%&gt;</a></li>
                    </c:if>--%>
                    <li><a id="tab_2" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.N.essperson.A01SelfDetailNeoLicenseSV" ><spring:message code="TAB.COMMON.0003" /><%--자격면허--%></a></li>

                    <!--  original 2018-04-02
                    <c:if test="${user.area != 'OT' }"><%--[CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha--%>
                    <li><a id="tab_3" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A13Address.A13AddressListSV"><spring:message code="TAB.COMMON.0004" /><%--주소--%></a></li>
					</c:if>
					-->
					<%--@ PJT. 베트남 하이퐁 법인 GEHR 적용 요청 2018/04/02 Kanng DM  Start --%>
					<c:if test="${(user.area != 'OT' ) or (user.area == 'OT' and user.companyCode == 'G580')}">
                    <li><a id="tab_3" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A13Address.A13AddressListSV"><spring:message code="TAB.COMMON.0004" /><%--주소--%></a></li>
					</c:if>
					<%--@ PJT. 베트남 하이퐁 법인 GEHR 적용 요청 2018/04/02 Kanng DM  End --%>

					<!--  original 2018-04-02
                    <c:if test="${user.area != 'US' and user.area != 'MX' and user.area != 'OT' }"><%--[CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha / @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel --%>
                    <li><a id="tab_4" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A04FamilyDetailSV"><spring:message code="TAB.COMMON.0005" /><%--가족--%></a></li>
                    </c:if>
                    -->

                    <%--@ PJT. 베트남 하이퐁 법인 GEHR 적용 요청 2018/04/02 Kanng DM  Start --%>
                    <c:if test="${(user.area != 'US' and user.area != 'MX' and user.area != 'OT') or  (user.area == 'OT' and user.companyCode == 'G580')}">
                    <li><a id="tab_4" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A04FamilyDetailSV"><spring:message code="TAB.COMMON.0005" /><%--가족--%></a></li>
                    </c:if>
                    <%--@ PJT. 베트남 하이퐁 법인 GEHR 적용 요청 2018/04/02 Kanng DM  End --%>

					<c:if test="${O_CHECK_FLAG != 'N'}">
                    <li><a id="tab_5" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A05AppointDetailSV"><spring:message code="TAB.COMMON.0006" /><%--발령--%></a></li>
                    </c:if>
                    <li><a id="tab_6" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A06PrizeNPunishSV"><spring:message code="TAB.COMMON.0007" /><%--포상/징계--%></a></li>
                    <li><a id="tab_7" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A09CareerDetailSV"><spring:message code="TAB.COMMON.0008" /><%--경력사항--%></a></li>

                    <c:if test="${check_A01 == 'Y'}">
                        <li ><a id="tab_8" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.B.B01ValuateDetailSV"><spring:message code="TAB.COMMON.0009" /><%--평가결과--%></a></li>
                    </c:if>

                    <c:if test="${user.area == 'KR' and user.ipersk <= 28 and user.ipersk >= 11}">
                        <li><a id="tab_9" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A10Annual.A10AnnualListSV"><spring:message code="TAB.COMMON.0010" /><%--나의 연봉--%></a></li>
                    </c:if>

                    <li><a id="tab_10" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.C.C05FtestResultSV"><spring:message code="TAB.COMMON.0011" /><%--어학--%></a></li>

                    <c:if test="${user.area == 'US' || user.area == 'MX'}"><!-- @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel -->
                        <li><a id="tab_11" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A20EmergencyContactsListSV"><spring:message code="TAB.COMMON.0012" /><%--긴급연락처--%></a></li>
                    </c:if>
                </c:when>

                <%-- MSS --%>
                <c:when test="${tabType == 'M'}">

                    <li><a id="tab_1" class="-tab-link" href="javascript:void(0);" data-url="${g.jsp}common/wait.jsp?url=${g.servlet}hris.N.mssperson.A01SelfDetailNeoPersonalSV_m" ><spring:message code="TAB.COMMON.0001" /><%--인사기본--%></a></li>

                    <c:if test="${O_CHECK_FLAG != 'N'}">
                    <li><a id="tab_2" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A05AppointDetailSV_m"><spring:message code="TAB.COMMON.0006" /><%--발령--%></a></li>
                    </c:if>
                    <li><a id="tab_3" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A06PrizeNPunishSV_m"><spring:message code="TAB.COMMON.0007" /><%--포상/징계--%></a></li>
                    <li><a id="tab_4" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A09CareerDetailSV_m"><spring:message code="TAB.COMMON.0008" /><%--경력사항--%></a></li>

                    <c:if test="${check_A01 == 'Y'}">
                        <li><a id="tab_5" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.B.B01ValuateDetailSV_m"><spring:message code="TAB.COMMON.0009" /><%--평가결과--%></a></li>
                    </c:if>

                    <c:if test="${user.area == 'KR' and check_A03 == 'Y'}">
                        <li><a href="javascript:;" class="-tab-link" data-url="${g.servlet}hris.A.A10Annual.A10AnnualListSV_m"><spring:message code="MSG.A.A01.TAB08" /><%--나의 연봉--%></a></li>
                   	</c:if>

                    <li><a id="tab_7" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.C.C05FtestResultSV_m"><spring:message code="TAB.COMMON.0011" /><%--어학--%></a></li>

                    <c:if test="${user.area == 'US'||user.area == 'MX'}"><!-- @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel -->
                        <li><a id="tab_8" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A20EmergencyContactsListSV_m"><spring:message code="TAB.COMMON.0012" /><%--긴급연락처--%></a></li>
                    </c:if>

                </c:when>

                <%-- 개인정보 확인 --%>
                <c:when test="${tabType == 'C'}">

                    <c:choose>
                        <c:when test="${user.area == 'KR'}">
                            <li><a id="tab_1" class="-tab-link" href="javascript:void(0);" href="javascript:void(0);" data-url="${g.jsp}common/wait.jsp?url=${g.servlet}hris.N.essperson.A01SelfDetailNeoExtraSV" ><spring:message code="TAB.COMMON.0001" /><%--인사기본--%></a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a id="tab_1" class="-tab-link" href="javascript:void(0);" href="javascript:void(0);" data-url="${g.jsp}common/wait.jsp?url=${g.servlet}hris.N.essperson.A01SelfDetailNeoExtraSV" ><spring:message code="TAB.COMMON.0087" /><%--학력--%></a></li>
                        </c:otherwise>
                    </c:choose>
                    <%--<c:if test="${user.area == 'KR'}">
                        <li><a class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.N.essperson.A01SelfDetailNeoPersonalSV" ><spring:message code="TAB.COMMON.0002" />&lt;%&ndash;신상/병역&ndash;%&gt;</a></li>
                    </c:if>--%>
                    <li><a id="tab_2" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A13Address.A13AddressListSV"><spring:message code="TAB.COMMON.0004" /><%--주소--%></a></li>
                    <c:if test="${user.area != 'US' and user.area != 'MX' and user.area != 'OT'}"><%--[CSR ID:3440690] 베트남법인 GEHR 적용 요청 2017/07/21 eunha / @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel--%>
                    <li><a id="tab_3" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A04FamilyDetailSV"><spring:message code="TAB.COMMON.0005" /><%--가족--%></a></li>
                    </c:if>
                    <li><a id="tab_4" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.A.A09CareerDetailSV"><spring:message code="TAB.COMMON.0008" /><%--경력사항--%></a></li>
                    <li><a id="tab_5" class="-tab-link" href="javascript:void(0);" data-url="${g.servlet}hris.C.C05FtestResultSV"><spring:message code="TAB.COMMON.0011" /><%--어학--%></a></li>
                </c:when>
            </c:choose>

        </ul>
    </div>
</div>

<div class="frameWrapper">
    <!-- TAB 프레임  -->
    <script>
        function autoResize(target) {
            target.height = 100;
            var iframeHeight =  target.contentWindow.document.body.scrollHeight;
            target.height = iframeHeight ;
        }
    </script>
    <iframe id="listFrame" onload="autoResize(this);" <%--onload="scroll(0,0);"--%> name="listFrame" style="min-height: 100px;" scrolling="no"
            width="100%"  marginwidth="0" marginheight="0"  frameborder=0></iframe>
</div>

<form id="urlForm" name="urlForm" target="listFrame" method="post">
    <input type="hidden" name="subView" value="Y">
    <input type="hidden" name="pageType" value="${pageType}">
</form>

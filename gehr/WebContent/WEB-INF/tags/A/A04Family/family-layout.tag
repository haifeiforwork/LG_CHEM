<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%@ attribute name="help" type="java.lang.String"  %>
<%@ attribute name="buttonBody" type="com.common.vo.BodyContainer"  %>
<%@ attribute name="detailBody" type="com.common.vo.BodyContainer"  %>
<c:set var="help" value="${(empty help) ? 'A04Family.html' : help}" />

<c:set var="isOwner" value="${PERNR == user.empNo}"/>
<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<tags:layout >
    <tags:script>
        <script>
            $(function() {
                detail($("input[name=radiobutton]:first").prop("checked", true));

                document.oncontextmenu = function () {
                    return false;
                };
                document.ondragstart = function () {
                    return false;
                };
                document.onselectstart = function () {
                    return false;
                };
				//[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 start
                <c:if test="${user.area == 'TH' }">
                 $('#familyButtonArea').attr('style','display:none');
                 </c:if>
                //[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 end
            });

            function reload() {
                var frm = document.form1;

                frm.action = "";
                frm.target = "";
                frm.submit();
            }
            //--------------------------------------------------------------------------------------------
            function detail($obj) {

                $obj.siblings("input:hidden").each(function(){
                    var $this = $(this);

                    var _$target = $("#form1").find("input[name=" + $this.attr("name") + "]");

                    if(_$target.is(":radio")) {
                        $("#form1").find("input[name=" + $this.attr("name") + "]").removeAttr("checked");
                        $("#form1").find("input[name=" + $this.attr("name") + "][value=" + $this.val() + "]").prop("checked", true);
                    } else if(_$target.is(":checkbox")) {
                        if(_.isEqual($this.val(), "X")) _$target.prop("checked", true);
                        else _$target.prop("checked", false);
                    } else _$target.val($this.val());

                });

                $("input[name=REGNO_R]").val($("input[name=REGNO]:first").val());
            }

            function do_addFamily() {
                var frm = document.form1;
                frm.action = "${g.servlet}hris.A.A12Family.A12FamilyBuildSV";
                frm.target = "";
                frm.submit();
            }
        <c:if test="${isOwner}" >
            function do_change(){
                document.form1.jobid.value = "first";
                document.form1.action = "${g.servlet}hris.A.A12Family.A12FamilyChangeSV";
                document.form1.method = "post";
                document.form1.submit();
            }
        </c:if>
        </script>
    </tags:script>

    <div class="tableArea">
        <%-- 리스트 --%>
        <jsp:doBody/>

        <form id="form1" name="form1" method="post">
            <input type="hidden" id="PERNR" name="PERNR" value="${PERNR}">
            <input type="hidden" name="RequestPageName" value="${currentURL}"/>
            <c:if test="${not empty detailBody and not empty a04FamilyDetailData_vt}">
        <%-- 상세 --%>
        <table width="100%" border="0" cellspacing="1" cellpadding="10" class="table01">
            <tr>
                <td class="tr01">
                        <h2 class="subtitle"><spring:message code="LABEL.A.A12.0044"/><%--가족사항--%></h2>
                        <%-- 가족 상세 사항 --%>
                        ${detailBody}
                </td>
            </tr>
        </table>
        <!--가족 상세 사항 테이블끝-->
        </c:if>
        </form>
    </div>

    <div class="buttonArea" id = "familyButtonArea">
        <%-- button --%>
        <ul class="btn_crud">
        <c:if test="${isOwner and isUpdate}" >
            <li><a href="javascript:;" onclick="do_change();"><span><spring:message code="BUTTON.COMMON.UPDATE"/><%-- 수정--%></span></a></li>
        </c:if>
        <c:if test="${!isEU}">
            <li><a href="javascript:;" onclick="do_addFamily();"><span><spring:message code="MSG.A.A12.0028"/><%--가족사항 추가 입력--%></span></a></li>
        </c:if>
            ${buttonBody}
        </ul>
    </div>

</tags:layout>

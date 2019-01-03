<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="uploadURL" type="java.lang.String" required="true" %>
<%@ attribute name="templateURL" type="java.lang.String" required="true" %>
<%@ attribute name="payTypeURL" type="java.lang.String" required="true" %>
<%@ attribute name="validateURL" type="java.lang.String" required="true" %>
<%@ attribute name="validateAjaxURL" type="java.lang.String" required="true" %>

<%@ attribute name="titlePrefix" type="java.lang.String" required="true" %>
<%-- empPay, member --%>
<%@ attribute name="pageGubun" type="java.lang.String" required="true" %>


<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>

<c:set var="payTypeItem" value="${pageGubun == 'empPay'? 'LGART' : 'MGART'}" />

<c:set var="disable" value="${empty yearMonthList}" />

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout css="ui_library_approval.css" script="dialog.js">
    <style>
        .result-msg {color: red;}
    </style>
    <%--<tags:upload uploadURL="${uploadURL}"/>--%>

    <script>
        var lastIndex = ${fn:length(resultList)};
    </script>

    <c:set var="buttonBody" value="${g.bodyContainer}" />

    <tags:body-container bodyContainer="${buttonBody}">
        <li><a href="${templateURL}" ><span><spring:message code="LABEL.D.D13.0019"/><!-- Excel Template --></span></a></li>
        <li>
            <%--<input type="file" class="file-input" name="uploadFile" id="uploadFile">--%>
            <a onclick="openExcelUpload();" ><span><spring:message code="LABEL.D.D13.0020"/><!-- 엑셀 업로드 --></span></a>
        </li>
    </tags:body-container>

    <tags-approval:request-layout titlePrefix="${titlePrefix}" representative="false" button="${buttonBody}" disable="${disable}">
        <!-- 상단 입력 테이블 시작-->
        <%--@elvariable id="resultData" type="hris.D.D15EmpPayInfo.D15EmpPayData"--%>
        <tags:script>
            <script>

                var _searchPersonIdx = null;

                var _requiredMessage = "<spring:message code="script.validate.required"/>";

                function beforeSubmit() {
                    var _isProcess = true;

                    var $msg = $("#form1 .result-msg");

                    $msg.each(function() {
                        var $this = $(this);
                        if(!_.isEmpty($this.val())) {
                            alert("<spring:message code='MSG.D.D13.0004'/>"); //메세지를 확인 후 데이타를 수정하십시오
                            $this.focus();
                            _isProcess = false;
                            return false;
                        }
                    });

                    if(!_isProcess) return _isProcess;

                    $("#form1 .required").each(function() {
                        var $this = $(this);
                        if(_.isEmpty($this.val())) {
                            alert(_requiredMessage.replace(/#e#/g, $this.attr("placeholder")));
                            _isProcess = false;
                            return false;
                        }
                    });

                    <c:if test="${pageGubun == 'empPay'}">
                    if(!_isProcess) return _isProcess;

                    var title = "<spring:message code="LABEL.D.D05.0015"/>";
                    $("#form1 input[name=LIST_BETRG]").each(function() {
                        var $this = $(this);
                        if(Number(removeComma($this.val())) <= 0) {
                            alert("<spring:message code='script.validate.required2' arguments='"+title+"' />");
                            $this.focus();
                            _isProcess = false;
                            return false;
                        }
                    });
                    </c:if>

                    return _isProcess;
                }


                function removeSearchPerson(idx) {
                    $("#APPR_SEARCH_VALUE" + idx).val('');
                }

                /**
                 * 사원 검색 팝업
                 */
                function searchPerson(idx) {
                    _searchPersonIdx = idx;

                    if(event.keyCode && event.keyCode != 13) return;

                    var type = $("#APPR_SEARCH_GUBUN" + idx).val();
                    var _jobid = type == "1" ? "pernr" : "ename";

                    var _value = $("#APPR_SEARCH_VALUE" + idx).val();

                    if ( _.isEmpty(_value)) {
                        if(type == "1")
                            alert("<spring:message code='MSG.APPROVAL.SEARCH.PERNR.REQUIRED'/>");//검색할 부서원 사번을 입력하세요
                        if(type == "2")
                            alert("<spring:message code='MSG.APPROVAL.SEARCH.NAME.REQUIRED'/>");//검색할 부서원 성명을 입력하세요

                        $("#APPR_SEARCH_VALUE" + idx).focus();
                        return;
                    }

                    var url = "${g.jsp}common/SearchDeptPersonsWait_T.jsp?I_GUBUN=" + type + "&I_VALUE1=" + encodeURIComponent(_value) + "&jobid=" + _jobid;

                    var searchApprovalHeaderPop = window.open(url,"DeptPers","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=800,height=550,left=450,top=00");
                    //$(searchFrom).unloadingSubmit();

                    <%--var searchApprovalHeaderPop = window.open("${g.jsp}common/ApprovalOrganListFramePop.jsp","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=960,height=480,left=450,top=0");--%>
                    <%--searchApprovalHeaderPop.focus();--%>
                }

                function setPersInfo(obj) {
                    $("#PERNR" + _searchPersonIdx).val(obj.PERNR);
                    $("#ENAME" + _searchPersonIdx).val(obj.ENAME);

                    checkRow($("#-pay-row-" + _searchPersonIdx));
                }

                /**
                 * 사번 셋팅
                 */
                /*function setPerson(PERNR, ENAME) {
                    $("#PERNR" + _searchPersonIdx).val(PERNR);
                    $("#ENAME" + _searchPersonIdx).val(ENAME);
//                    /!*getPayTypeOption($("#-pay-row-" + _searchPersonIdx));*!/
                }*/

                /**
                 * row 추가 시 해당 로우에 값 검증
                 */
                function checkRow($row, isSelectPayType) {

                    var $payType = $row.find(".-pay-type");


                    if(_.isEmpty($row.find("input[name=LIST_PERNR]").val()) ||
                            _.isEmpty($payType.val())) return true;

                    var YYYYMM = $("#I_YYYYMM").val();

                    $("#validateForm").empty()
                            .append($row.find("input").clone())
                            .append($("<input/>").prop("name", "I_YYYYMM").val(YYYYMM))
                            .append($("<input/>").prop("name", "LIST_${payTypeItem}").val($payType.val()));

                    ajaxPost("${validateAjaxURL}", "validateForm", function(data) {
                        console.log(data.resultList);
                        _.each(data.resultList, function(row) {

                            setRow($row, row, isSelectPayType);
                        });
                    }, function() {

                    });
                }

                /**
                 * key 값이 중복되는 로우가 존재하는지 확인
                 * 중복되는 로우 리턴
                 */
                function checkDuplicate(obj) {
                    var $rows = $("#-listTable-body tr");

                    var result = null;

                    $rows.each(function() {
                        var $this = $(this);

                        if($this.find("[name=LIST_PERNR]").val() == obj.PERNR) {

                            var _payType = $this.find(".-pay-type").val() || obj.${payTypeItem};
                            if(_payType == obj.${payTypeItem}) {
                                result = $this;
                                return false;
                            }
                        }
                    });

                    return result;
                }

                /**
                 * 해당 로우에 데이타 셋팅
                 */
                function setRow($row, obj, isSelectPayType) {
                    var payType;

                    if(obj) {
                        /* input box set */
                        $row.find("input").each(function() {
                            var $this = $(this);

                            $this.val(obj[$this.prop("name").replace("LIST_", "")]);
                            if($this.attr("name") == "LIST_CHECK_RETIRE") {
                                if(obj['ZQUIT'] == 'X') $this.prop("checked", true);
                                else $this.prop("checked", false);
                            }
                            /*$this.formatVal(obj[$this.prop("name").replace("LIST_", "")]);*/
                        });

                        payType = obj.${payTypeItem};

                        /* LGART set*/
                        <%--
                        if(isSelectPayType) getPayTypeOption($row, payType);
                        else $row.find("select[name=LIST_${payTypeItem}]").val(payType)
                         --%>
                        $row.find("select[name=LIST_${payTypeItem}]").val(payType)
                    }
                }

                /**
                 * 로우추가
                 */
                function addRow(obj) {
                    console.log("--- addROw -- ");
                    var $row;

                    //속도문제로 검증로직 제외
                    /*if(obj) {
                        $row = checkDuplicate(obj);
                    }*/

                    if(!$row) {
                        var templateText = $("#template").text();
                        templateText = templateText.replace(/#idx#/g, ++lastIndex);
                        $row = $(templateText);
                    }

                    setRow($row, obj, true);

                    /*addMaskFilter($row);*/
                    $("#-listTable-body").append($row);

                    setValidate($("#form1"));

                    setTotalCount(false);
                }

                function setTotalCount(isSum) {
                    $("#-list-total").text($("#-listTable-body input[name=LIST_ENAME]").length);

                    if(isSum != false) sumBetrg();
                }

                function getPayTypeOption($row, selectValue) {

                    var YYYYMM = $("#I_YYYYMM").val();
                    var PERNR = $row.find("input[name=LIST_PERNR]").val();
                    var $payType = $row.find(".-pay-type");

                    ajaxPost("${payTypeURL}", {I_PERNR: PERNR, I_YYYYMM : YYYYMM}, function(data) {

                        _.each(data.resultList, function(row) {
                            var $option;
                            <c:if test="${pageGubun == 'empPay'}">
                            $option = $("<option/>").data("infty", row.INFTY).val(row.LGART).text("[" + row.LGART + "]" + row.LGTXT);
                            if(row.${payTypeItem} == selectValue) {
                                $option.prop("selected", true);
                                $row.find("input[name=LIST_INFTY]").val(row.INFTY);
                            }
                            </c:if>
                            <c:if test="${pageGubun == 'member'}">
                            $option = $("<option/>").data("lgart", row.LGART).data("betrg", row.BETRG).val(row.MGART).text("[" + row.MGART + "]" + row.MGTXT);
                            if(row.${payTypeItem} == selectValue) {
                                $option.prop("selected", true);
                                $row.find("input[name=LIST_LGART]").val(row.LGART);
                                $row.find("input[name=LIST_BETRG]").val(row.BETRG);
                            }
                            </c:if>


                            $payType.append($option);
                        })

                    });

                }

                /**
                 * 로우 삭제
                 */
                function deleteRow() {
                    $(".-row-check:checked").parents("tr").remove();

                    if($("#-listTable-body tr").length == 0) {
                        addRow();
                        $("#checkAll").prop("checked", false);
                        /*$("#-listTable-body").append($("<tr/>").append($("<td colspan='7'/>").text("<spring:message code="MSG.COMMON.0004" />")));*/
                    }

                    setTotalCount();
                }

                /**
                 * 전체 체크
                 */
                function checkAllChange() {
                    if($("#checkAll").is(":checked")) {
                        $(".-row-check").prop("checked", true);
                    } else {
                        $(".-row-check").prop("checked", false);
                    }
                }

                function selectPayType(payTypeId) {

                    var $select = $("#" + payTypeId);
                    var $row = $select.parents("tr:first");

                    var $option = $select.find("option:selected");
                    $select.val($option.val())

                    <c:if test="${pageGubun == 'empPay'}">
                    $row.find("input[name=LIST_INFTY]").val($option.data("infty"));
                    </c:if>
                    <c:if test="${pageGubun == 'member'}">
                    $row.find("input[name=LIST_LGART]").val($option.data("lgart"));
                    $row.find("input[name=LIST_BETRG]").val($option.data("betrg"));
                    sumBetrg();
                    </c:if>

                    checkRow($row);
                }

                function afterUploadProcess($data) {

                    $("#-listTable-body").empty().html($data.html());
                    addMaskFilter($("#-listTable-body"));
                    /*setValidate($("#form1"));*/

                    lastIndex = $("#-listTable-body input[name=LIST_ENAME]").length + 1;

                    setTotalCount();



                    parent.resizeIframe(document.body.scrollHeight);

                    <%--
                    console.log("---- add row -- start=---- ");
                    console.log(data.resultList);

                    if(data.resultList) {
                        var isError = false;

//                        if(data.resultList.length > 0 && $(".-search-person").length == 1 &&  _.isEmpty($(".-search-person:first").val())) {
                        if(data.resultList.length > 0) {
                            $("#-listTable-body").empty();
                        }

                        $("#-excel-result-tbody").empty();

                        _.each(data.resultList, function(row) {
                            addRow(row);

                            if(!_.isEmpty(row.ZMSG)) {
                                $("<tr/>")
                                        .append($("<td/>").text(row.PERNR))
                                        .append($("<td/>").text(row.${payTypeItem}))
                                        <c:if test="${pageGubun == 'empPay'}">
                                        .append($("<td/>").text(row.BETRG).css("text-align", "right"))
                                        </c:if>
                                        .append($("<td/>").text(row.ZMSG).addClass("result-msg"))
                                        .appendTo("#-excel-result-tbody");

                                isError = true;
                            }
                        });

                        /*if(isError) $("#-excel-result-dialog").openDialog();*/

                        parent.resizeIframe(document.body.scrollHeight);
                    }
                    --%>

                }

                function sumBetrg() {
                    var _sum = 0;

                    $("#form1 input[name=LIST_BETRG]").each(function() {
                        _sum += Number(removeComma($(this).val()));
                        console.log($(this).prop("id") + " : " + $(this).val());
                    });

                    /*$(selector).autoNumeric('set', value);*/

                    $("#sumAmt").autoNumeric('init').autoNumeric('set', _sum);
                }

                $(function() {
                    if($(".-pay-type").length == 0) {
                        $("#-listTable-body").empty();
                        addRow();
                    }

                    /*파일업로드 추가 파라메터 */
                    $('.file-input').bind('fileuploadsubmit', function (e, data) {
                        data.formData = {I_YYYYMM: $("#I_YYYYMM").val()};
                    });

                    /* 반영년월 변경시 모든 데이타 다시 체크 */
                    $(".-yyyymm").change(function() {

                        ajaxPost("${validateURL}", "form1", function(data) {
                            var $data = $(data);

                            var _template = $data.find("textarea:first").html();
                            if(!_.isEmpty(_template)) $("#template").empty().html(_template);

                            $("#-listTable-body").empty().html($data.find("tbody:first").html());
                            addMaskFilter($("#-listTable-body"));
                        });

                    });

                    $(document).on("change", "input[name=LIST_BETRG]", function() {
                        sumBetrg();
                    });

                });

                function openExcelUpload() {
                    window.open('${uploadURL}?YYYYMM=' + $("#I_YYYYMM").val(),"empExcelUpload","width=500,height=300,left=365,top=70,scrollbars=no");
                }

            </script>
        </tags:script>



        <c:choose>
            <c:when test="${disable}">
                <div class="tableArea">
                    <div class="table">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="center" style="color:red;">
                                    ※ <spring:message code="MSG.D.D15.0210"/><%-- 근태 담당자에게 문의하시기 바랍니다.--%>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="tableArea">
                    <div class="table">
                        <table id="-search-table" class="tableGeneral tableApproval">
                            <colgroup>
                                <col width="15%">
                                <col width="85%">

                            </colgroup>
                            <tr>
                                <th class="th02"><span class="textPink">*</span><spring:message code='LABEL.D.D15.0202'/><!-- 반영년월 --></th>
                                <td>
                                    <select id="I_YYYYMM" name="I_YYYYMM" class="-yyyymm">
                                        <c:forEach var="row" items="${yearMonthList}">
                                            <option value="${row.code}">${row.value}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!-- 상단 입력 테이블 끝-->
                </div>

                <jsp:doBody />
            </c:otherwise>
        </c:choose>


    </tags-approval:request-layout>
    <div style="display: none; top:-9999px;" >
        <form id="validateForm" name="validateForm" method="post" style="display: none;">
        </form>
    </div>


    <%-- excel 결과 dialog --%>
    <div id="-excel-result-dialog" class="-ui-dialog" data-width="600" data-height="400" style="display: none;">
        <div id="-accept-info">
        </div>
        <div class="popWindow">
            <div class="popTop">
                <div class="popHeader">
                    <p><spring:message code="LABEL.EXCEL.UPLOAD.RESULT.TITLE" /><%--결과--%></p>
                    <a class="-close-dialog"><img src="${g.image}sshr/btn_popup_close.png" /></a>
                </div>
            </div>
            <div class="popCenter">
                <div class="table">
                    <table class="listTable">
                        <colgroup>
                            <col width="100">
                            <col width="100">
                            <c:if test="${pageGubun == 'empPay'}">
                            <col width="100">
                            </c:if>
                            <col width="">
                        </colgroup>
                        <thead>
                        <tr>
                            <th><spring:message code="LABEL.D.D12.0017"/><!-- 사원번호 --></th>
                            <th><spring:message code="LABEL.D.D08.0004"/><!-- 임금유형 --></th>
                            <c:if test="${pageGubun == 'empPay'}">
                            <th><spring:message code="LABEL.D.D05.0015"/><!-- 금액 --></th>
                            </c:if>
                            <th class="lastCol" ><spring:message code="LABEL.D.D13.0021"/><!-- 메세지 --></th>
                        </tr>
                        </thead>
                        <tbody id="-excel-result-tbody">

                        </tbody>
                    </table>
                </div>
                <div class="buttonArea">
                    <ul class="btn_crud">
                        <li><a href="javascript:;" class="-close-dialog"><span><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

</tags:layout>

<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="isDev" value="<%=WebUtil.isDev(request) %>"/>

<tags:layout title="MENU.COMMON.0067" script="dialog.js" css="jquery/ui-lightness/jquery-ui-1.10.4.custom.css" >


    <style>
        .-row-click {cursor: pointer;}

        .ui-progressbar {
            position: relative;
            width:100%;
        }
        .progress-label {
            position: absolute;
            left: 50%;
            top: 4px;
            font-weight: bold;
            text-shadow: 1px 1px 0 #fff;
        }
    </style>

    <c:set var="elofficeURL" value="${isDev ? 'http://uapprovaldev.lgchem.com:9021' : 'http://uapproval.lgchem.com:7010'}/lgchem/front.appint.cmd.RetrieveSappiTraceListCmd.lgc?s_legacy=EHR&s_appId="/>

    <tags:script>
        <script>

            var resetURL = "${g.servlet}hris.ResetApporvalSV";
            var loop = 1;
            var progressLabel;
            var progressbar;

            $(function() {

                progressLabel = $(".progress-label");
                progressbar = $("#progressbar");

                progressbar.progressbar({
                    value: false,
                    max: ${fn:length(resultList)},
                    change: function() {
                        progressLabel.text(progressbar.progressbar( "value" ) + " / " + ${fn:length(resultList)} );
                    },
                    complete: function() {
                        $("#stopButton").click();
                        //progressLabel.text( "Complete!" );
                    }
                });

               /* $('#processBarDiv').openDialog();*/


                $(".-request-button").click(function() {
                    if($(".-row-check:checked").length == 0) {
                        alert("전송할 데이타를 선택하십시오.");
                        return;
                    }

                    initProgress();

                    loop = 1;

                    var $dialog = $('#processBarDiv').openDialog();

                    initDialog($dialog);

                    setTimeout(resetApproval, 10);
                    //progressbar.progressbar("value",  6);

                });

                $(".-upload-button").click(function() {
                    blockFrame();
                    $("#jobid").val("upload");
                    document.form1.submit();
                });

                $(".-row-click").click(function() {
                    var $this = $(this);
                    var $tr = $this.parents("tr");

                    var seqn = $tr.find(".-ainf-seqn").text();
                    var pernr = $tr.find(".-pernr").text();

                    window.open( resetURL + "?AINF_SEQN=" + seqn + "&PERNR=" + pernr + "&jobid=search", "_blank", "width=1024,height=800");
                });

                $("#stopButton").click(function() {
                    cancelReset();
                    $(this).hide();
                    $("#closeButton").show();
                });

            });

            function increaseProgress(_progressValue) {
                $("#send").text(_progressValue);
                progressbar.progressbar("value",  _progressValue);
            }

            function initProgress() {
                $("#send").text("0");
                $("#progressbar").progressbar("option", "value" , false);
                $(".progress-label").text("Loading...");
            }


            function resetApproval() {
                if(loop > ${fn:length(resultList)}) return;

                var current = loop++;

                var $tr = $(".-row-check:checked:eq(" + (current - 1) + ")").parents("tr");

                var _param = {jobid : "save", requestType : "json", AINF_SEQN : $tr.find(".-ainf-seqn").text(), PERNR : $tr.find(".-pernr").text()};

                $.ajax({
                    type: "POST",
                    url: resetURL,
                    data: _param,
                    success: function(data) {
                        if(data && data.isSuccess == true) {
                            msg = "성공";
                            if(data.approvalHeader) {
                                $tr.find(".-type").text(data.approvalHeader.UPMU_NAME);
                                $tr.find(".-status").text(data.approvalHeader.AFSTATX);
                                $tr.find(".-date").text(data.approvalHeader.AFDAT);

                                //$tr.find("iframe").prop("src", "${elofficeURL}" + data.approvalHeader.AINF_SEQN);
                            }
                        }
                        else msg = "실패<br>" + (data.message || "");

                        $tr.find(".-result").html(msg);
                    },
                    error: function() {
                        $tr.find(".-result").html("실패");
                    },
                    complete: function(data) {
                        increaseProgress(current);
                        setTimeout(resetApproval, 500);
                    }
                });
            }

            function cancelReset() {
                loop = ${fn:length(resultList)} + 1;
            }

            function initDialog($dialog) {
                //$dialog.dialog( "option", "position", { my: "top", at: "top-100px", of: "window" } );

                $("#closeButton").hide();
                $("#stopButton").show();
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

        </script>
    </tags:script>

    <form id="form1" name="form1" method="post" action="" enctype="multipart/form-data" >
    <div class="tableArea">
        <!-- 개인 인적사항 조회 -->
        <div class="table">
            <table border="0" cellspacing="0" cellpadding="0" class="tableGeneral">
                <colgroup>
                    <col width="15%" />
                    <col width="85%" />
                </colgroup>
                <tr>
                    <th>엑셀파일</th>
                    <td>
                        <input type= "file" name="uploadFile" id="uploadFile" style="width: 500px;" />
                        <input type="checkbox" id="showEloffice" name="showEloffice" value="Y"/> eloffice 결과 보기

                        <input type="hidden" id="jobid" name="jobid" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a class="-upload-template-button" href="javascript:;" onclick="$('#-template-dialog').openDialog();"><span>엑셀양식보기</span></a></li>
                <li><a class="-upload-button " href="javascript:;"><span>엑셀업로드</span></a></li>
                <c:if test="${not empty resultList}">
                <li><a class="-request-button darken" href="javascript:;"><span>실행</span></a></li>
                </c:if>
            </ul>
        </div>
    </div>
    </form>



    <c:if test="${jobid == 'save'}">


    <h2 class="subtitle">처리결과</h2>
    <div class="tableArea">
        <!-- 개인 인적사항 조회 -->
        <div class="table">
            <table border="0" cellspacing="0" cellpadding="0" class="tableGeneral">
                <colgroup>
                    <col width="15%" />
                    <col width="85%" />
                </colgroup>
                <tr>
                    <th>결과메세지</th>
                    <td>${isSuccess ? "성공" : message}</td>
                </tr>
            </table>
        </div>
    </div>
    </c:if>

      <%--@elvariable id="approvalHeader" type="hris.common.approval.ApprovalHeader"--%>



    <c:if test="${not empty resultList}">

    <div id="processBarDiv" style="display:none; " class="-ui-dialog" data-width="500" data-height="200"
         data-modal="true" data-position='["center",200]' <%--data-position="{ my: 'left top'}"--%>>
        <div id="progressbar"><div class="progress-label">실행전</div></div>
        <div class="buttonArea" style="margin-top: 20px;">
            <ul class="btn_crud">
                <li id="closeButton"><a href="javascript:;" class="-close-dialog" ><span>닫기</span></a></li>
                <li id="stopButton"><a href="javascript:;" ><span>중지</span></a></li>
            </ul>
        </div>
    </div>

    <!-- 결재자 입력 테이블 시작-->
    <h2 class="subtitle">엑셀 업로드 결과 <span id="send">0</span> / <span id="total">${fn:length(resultList)}</span> (전송건/total)</h2>

    <!-- 결재자 입력 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <colgroup>
                    <col width="10" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <col width="" />
                    <c:if test="${showEloffice =='Y'}">
                    <col width="800" />
                    </c:if>
                </colgroup>
                <thead>
                <tr>
                    <th><input type="checkbox" id="checkAll" name="checkAll" onclick="checkAllChange()"/></th>
                    <th>결재번호</th>
                    <th>사번</th>
                    <th>업무유형</th>
                    <th>승인상태</th>
                    <th>승인일</th>
                    <th ${showEloffice !='Y' ? 'class="lastCol"': ''}>결과</th>
                    <c:if test="${showEloffice =='Y'}">
                    <th class="lastCol">Eloffice상태(${isDev ? "http://dev.lgchem.com:9021" : "http://uapproval.lgchem.com:7010"})</th>
                     </c:if>
                </tr>
                </thead>
                    <%--@elvariable id="resultList" type="java.util.Vector<hris.ResetExcelUploadData>"--%>
                <c:forEach var="row" items="${resultList}" varStatus="status">
                    <tr class="${f:printOddRow(status.index)}" >
                        <td><input type="checkbox" id="checkRow${status.index}" name="checkRow" class="-row-check" value="X"/></td>
                        <td class="-row-click -ainf-seqn">${row.AINF_SEQN}</td>
                        <td class="-row-click -pernr">${row.PERNR}</td>
                        <td class="-type"></td>
                        <td class="-status"></td>
                        <td class="-date"></td>
                        <td class="-result" ${showEloffice !='Y' ? 'class="lastCol"': ''}></td>
                        <c:if test="${showEloffice =='Y'}">
                        <td class="-eloffice lastCol">
                            <iframe id="iframe${status.index}" src="${elofficeURL}${row.AINF_SEQN}" width="100%" height="150" onload="$('#iframe${status.index}').scrollTop(200)">
                            </iframe>
                        </td>
                        </c:if>
                    </tr>
                </c:forEach>
                <tags:table-row-nodata list="${resultList}" col="${showEloffice !='Y' ? '6': '7'}" />
            </table>
        </div>
    </div>
    <!-- 결재자 입력 테이블 End-->


    </c:if>



    <div id="-template-dialog" class="-ui-dialog" data-width="400" data-height="400" style="display: none;">
        <div class="popWindow">
            <div class="popTop">
                <div class="popHeader">
                    <p>엑셀양식</p>
                    <a href="javascript:;" class="-close-dialog unloading"><img src="${g.image}sshr/btn_popup_close.png" /></a>
                </div>
            </div>
            <div class="popCenter">
                <div class="listArea">
                    <div class="table">
                        <table class="listTable">
                            <thead>
                            <tr>
                                <th>결재번호</th>
                                <th class="lastCol">사번</th>
                            </tr>
                            </thead>
                            <tr>
                                <td>7000000001</td>
                                <td class="lastCol">37003790</td>
                            </tr>
                            <tr>
                                <td>7000000002</td>
                                <td class="lastCol">37003790</td>
                            </tr>
                        </table>
                    </div>
                </div>
        </div>
    </div>

</tags:layout>
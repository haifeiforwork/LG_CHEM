<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%-- 근무취소신청 --%>
    <div class="tableInquiry">
        <table>
            <caption>근무취소신청</caption>
            <colgroup>
                <col class="col_10p" />
                <col class="col_30p" />
                <col class="col_10p" />
                <col class="col_50p" />
            </colgroup>
            <tbody>
                <tr>
                    <th><span class="textPink">*</span>업무구분</th>
                    <td>
                        <select class="wAuto" id="I_UPMU_TYPE" name="I_UPMU_TYPE">
                            <c:if test="${OTbuildYn eq 'Y'}">
                                <c:if test="${TAB.T01 eq 'Y'}">
                            <option value="17">초과근무</option>
                                </c:if>
                                <c:if test="${TAB.T02 eq 'Y'}">
                            <option value="47">초과근무 사후신청</option>
                                </c:if>
                            </c:if>
                            <option value="40">교육/출장</option>
                        </select>
                    </td>
                    <th><span class="textPink">*</span><span id="SCancelDate">근태일</span></th>
                    <td class="periodpicker">
                        <input type="text" id="I_TBEGDA" name="I_TBEGDA" value="<%= WebUtil.printDate(DataUtil.getLastMonthFirstDay(), ".") %>" readonly/> ~
                        <input type="text" id="I_TENDDA" name="I_TENDDA" value="<%= WebUtil.printDate(DataUtil.getMonthLastDays(), ".") %>" readonly/>
                    </td>
                    <!-- td><span class="noteItem">※ 근태일 : 초과근무일, 교육/출장, 휴가일</span></td-->
                </tr>
            </tbody>
        </table>
        <div class="tableBtnSearch"><button type="submit" id="attCancelSearchBtn"><span>조회</span></button></div>
    </div>

    <!-- list start -->
    <div class="listArea">
        <div id="attCancelGrid" class="jsGridPaging"></div>
    </div>
    <!--// list end -->

    <div id="attCancelDiv">
        <!-- 조회상세화면 -->
        <div id="overTimeDiv" style="padding-bottom:0; display:none;">
            <!-- Table start -->
            <div class="tableArea">
                <h2 class="subtitle">초과근무(OT/특근) 신청 조회</h2>
                <div class="buttonArea">
                    <ul class="btn_mdl">
                        <li><a href="#" name="RADL-button"${TPGUB_CD ? '' : ' style="display:none"'}><span>신청/결재 기한</span></a></li>
                        <li><a href="#" onclick="$schedulePopup()"><span>근무일정 조회</span></a></li>
                    </ul>
                </div>
                <div class="table">
                    <table class="tableGeneral table-layout-fixed" id="otFormTable">
                        <caption>초과근무(OT/특근) 신청</caption>
                        <colgroup>
                            <col class="col_15p" />
                            <col />
                            <c:if test="${TPGUB_CD}"><col /></c:if>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>신청일</th>
                                <td name="BEGDA"></td>
                                <%-- [WorkTime52] 시작 : 지정일자 근무시간현황 --%>
                                <jsp:include page="/WEB-INF/views/pages/work/include/realWorkTimeReportTable.jsp" />
                                <%-- [WorkTime52] 종료 : 지정일자 근무시간현황 --%>
                            </tr>
                            <tr>
                                <th>초과근무일</th>
                                <td class="tdDate">
                                    <span name="WORK_DATE"></span>
                                    <input type="checkbox" name="VTKEN" class="checkbox-large" disabled="disabled" /> 前日 근태에 포함
                                </td>
                            </tr>
                            <tr>
                                <th>신청시간</th>
                                <td><span name="BEGUZ" format="time"></span> ~ <span name="ENDUZ" format="time"></span> / <span name="STDAZ"></span> 시간</td>
                            </tr>
                            <tr>
                                <th class="ot-reason ${TPGUB_CD ? fn:escapeXml( STYLE_TPGUB ) : ''}">신청사유</th>
                                <td class="align-top"><span name="OVTM_CODE" id="OVTM_TEXT"></span> <span name="REASON"></span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="tableArea">
                <h2 class="subtitle">선택사항</h2>
                <div class="table">
                    <table class="listTable borderBottom">
                        <caption>휴게시간 작성</caption>
                        <colgroup>
                            <col class="col_16p"/>
                            <col class="col_24p"/>
                            <col class="col_24p"/>
                            <col class="col_18p"/>
                            <col class="col_18p"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th></th>
                                <th class="thAlignCenter">시작시간</th>
                                <th class="thAlignCenter">종료시간</th>
                                <th class="thAlignCenter">무급</th>
                                <th class="thAlignCenter tdBorder">유급</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th>휴게시간 1</th>
                                <td name="PBEG1" format="time"></td>
                                <td name="PEND1" format="time"></td>
                                <td name="PUNB1"></td>
                                <td class="tdBorder" name="PBEZ1"></td>
                            </tr>
                            <tr>
                                <th>휴게시간 2</th>
                                <td name="PBEG2" format="time"></td>
                                <td name="PEND2" format="time"></td>
                                <td name="PUNB2"></td>
                                <td class="tdBorder" name="PBEZ2"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!--// Table end -->

        <div class="tableArea" id="eduBizDiv" style="padding-bottom:0; display:none">
            <h2 class="subtitle">교육/출장 신청 조회</h2>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="#" onclick="$schedulePopup()"><span>근무일정 조회</span></a></li>
                </ul>
            </div>
            <div class="table">
                <table class="tableGeneral">
                    <caption>교육/출장 신청</caption>
                    <colgroup>
                        <col class="col_15p"/>
                        <col class="col_85p"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>신청일</th>
                            <td name="BEGDA"></td>
                        </tr>
                        <tr>
                            <th>신청구분</th>
                            <td name="AWART" format="replace" code="code" codeNm="value"></td>
                        </tr>
                        <tr>
                            <th>구분</th>
                            <td name="OVTM_CODE" format="replace" code="SCODE" codeNm="STEXT"></td>
                        </tr>
                        <tr>
                            <th>신청사유</th>
                            <td name="REASON"></td>
                        </tr>
                        <tr>
                            <th>대근자</th>
                            <td name="OVTM_NAME"></td>
                        </tr>
                        <tr>
                            <th>신청기간</th>
                            <td>
                                <span name="APPL_FROM"></span> ~ <span name="APPL_TO"></span>
                            </td>
                        </tr>
                        <tr id="cancleInputTimeArea" style="display:none;">
                            <th>신청시간</th>
                            <td>
                                <span name="CANCLE_BEGUZ"></span> ~ <span name="CANCLE_ENDUZ"></span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Table start -->
        <div id="afterOverTimeDiv" class="tableArea" style="padding-bottom:0; display:none;">
            <h2 class="subtitle">초과근무(OT/특근) 사후신청 조회</h2>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="#" name="RADL-button"><span>신청/결재 기한</span></a></li>
                    <li><a href="#" onclick="$schedulePopup()"><span>근무일정 조회</span></a></li>
                </ul>
            </div>
            <div class="table">
                <table class="tableGeneral table-layout-fixed">
                    <caption>초과근무(OT/특근) 사후신청</caption>
                    <colgroup>
                        <col class="col_15p" />
                        <col />
                        <col class="worktime-report type-c" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>신청일</th>
                            <td name="BEGDA" format="dateB" colspan="2"></td>
                        </tr>
                        <tr>
                            <th>선택일</th>
                            <td name="PICKED_DATE" colspan="2"></td>
                        </tr>
                        <tr>
                            <th>선택일 실근무시간</th>
                            <td colspan="2" class="selected-date-worktime">
                                <table>
                                    <colgroup>
                                        <col style="width: 80px" />
                                        <col style="width:130px" />
                                        <col style="width: 80px" />
                                        <col style="width:130px" />
                                        <col style="width: 80px" />
                                        <col style="width:110px" />
                                        <col style="width: 80px" />
                                        <col style="width:173px" />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>정상업무</th>
                                            <td id="CSTDAZ"></td>
                                            <th>업무재개</th>
                                            <td>
                                                <div id="ABEGUZ01" style="display:none"></div>
                                                <div id="ABEGUZ02" style="display:none"></div>
                                                <div id="CAREWK"></div>
                                            </td>
                                            <th>합계</th>
                                            <td id="CTOTAL"></td>
                                            <th>사후신청<br />가능시간</th>
                                            <td id="CRQPST"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <th>시간대 선택</th>
                            <td>
                                <span name="NRFLGG" style="display:none">정상초과</span>
                                <span name="R01FLG" style="display:none">업무재개1</span>
                                <span name="R02FLG" style="display:none">업무재개2</span>
                            </td>
                            <%-- [WorkTime52] 시작 : 지정일자 근무시간현황 --%>
                            <jsp:include page="/WEB-INF/views/pages/work/include/realWorkTimeReportTable.jsp">
                                <jsp:param name="rowspan" value="4" />
                            </jsp:include>
                            <%-- [WorkTime52] 종료 : 지정일자 근무시간현황 --%>
                        </tr>
                        <tr>
                            <th>신청 초과근무일</th>
                            <td class="tdDate">
                                <span name="WORK_DATE" format="dateB"></span>
                                <input type="checkbox" name="VTKEN" class="checkbox-large" disabled="disabled" /> 前日 근태에 포함
                            </td>
                        </tr>
                        <tr>
                            <th>신청시간</th>
                            <td>
                                <span name="BEGUZ" format="time"></span> ~ <span name="ENDUZ" format="time"></span> / <span name="STDAZ"></span> 시간
                                <div style="display:none">(휴게/비근무 <span id="CPDABS"></span>)</div>
                            </td>
                        </tr>
                        <tr>
                            <th class="aot-reason type-c">신청사유</th>
                            <td class="align-top"><span id="OVTM_TEXT"></span> <span name="REASON"></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="tableComment display-none consultant-request">
                <p><span class="bold">초과근무 사후신청은 발생 이후 3근무일 이내에 신청 및 결재를 완료하여 주시기 바랍니다.</span></p>
            </div>
        </div>

        <!-- Table start -->
        <div class="tableArea" id="cancelDiv" style="display:none">
            <h2 class="subtitle">취소신청사유</h2>
            <div class="table">
                <form id="attCancelForm" name="attCancelForm">
                <table class="tableGeneral">
                    <caption>취소신청사유</caption>
                    <colgroup>
                        <col class="col_15p" />
                        <col class="col_85p" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label>취소 신청일</label></th>
                            <td class="tdDate">
                                <input class="readOnly" type="text" name="BEGDA" value="${today}" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th><span class="textPink">*</span><label for="inputText01-5">취소사유</label></th>
                            <td>
                                <input class="wPer" id="CREASON" name="CREASON" type="text" value="" required="required" vname="취소사유" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
        </div>
        <!--// Table end -->

        <!-- list start -->
        <div class="listArea" id="cancelDecisioner" style="display:none"></div>

        <div class="tableComment floatLeft pt5 mb30" style="display:none">
            <p><span class="bold colorRed">취소신청에 대한 삭제는 '결재진행현황'에서 진행해야 합니다. 단, 취소신청의 수정은 불가합니다.</span></p>
        </div>
        <!--// list end -->

        <div class="buttonArea mb30" id="cancelBtnDiv" style="display:none">
            <ul class="btn_crud">
                <c:if test="${selfApprovalEnable eq 'Y'}">
                <li><a href="#" id="requestCancelNapprovalBtn" onclick="attCancelRequest(true)"><span>자가취소승인</span></a></li>
                </c:if>
                <li><a href="#" class="darken" id="cancelBtn" onclick="attCancelRequest(false)"><span>취소신청</span></a></li>
            </ul>
        </div>
    </div>
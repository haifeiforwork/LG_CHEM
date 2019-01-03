<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%-- 초과근무(OT/특근) 사후신청 --%>
    <form id="afterOT">
    <div class="tableArea">
        <h2 class="subtitle">신청서 작성</h2>
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
                        <th><label>신청일</label></th>
                        <td colspan="2" class="tdDate">
                            <input type="text" name="BEGDA" value="${today}" class="readOnly align-center" readonly="readonly" />
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><label>초과근무일 선택</label></th>
                        <td colspan="2" class="tdDate">
                            <input type="text" name="PICKED_DATE" class="datepicker align-center" />
                        </td>
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
                                        <td><span id="CSTDAZ" data-reset="text" data-reset-text="-">-</span></td>
                                        <th>업무재개</th>
                                        <td>
                                            <div id="ABEGUZ01" style="display:none" data-reset="text,display" data-reset-text="-" data-reset-display="none">-</div>
                                            <div id="ABEGUZ02" style="display:none" data-reset="text,display" data-reset-text="-" data-reset-display="none">-</div>
                                            <div id="CAREWK" data-reset="text" data-reset-text="-">-</div>
                                        </td>
                                        <th>합계</th>
                                        <td><span id="CTOTAL" data-reset="text" data-reset-text="-">-</span></td>
                                        <th>사후신청<br />가능시간</th>
                                        <td><span id="CRQPST" data-reset="text" data-reset-text="-">-</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span>시간대 선택</th>
                        <td>
                            <label class="for-radio"><input type="radio" name="ZOVTYP" id="NRFLGG" value="N0" disabled="disabled" data-reset="checked,disabled" data-reset-checked="false" data-reset-disabled="true" />정상초과</label>
                            <label class="for-radio"><input type="radio" name="ZOVTYP" id="R01FLG" value="R1" disabled="disabled" data-reset="checked,disabled" data-reset-checked="false" data-reset-disabled="true" />업무재개1</label>
                            <label class="for-radio"><input type="radio" name="ZOVTYP" id="R02FLG" value="R2" disabled="disabled" data-reset="checked,disabled" data-reset-checked="false" data-reset-disabled="true" />업무재개2</label>
                        </td>
                        <%-- [WorkTime52] 시작 : 지정일자 근무시간현황 --%>
                        <jsp:include page="/WEB-INF/views/pages/work/include/realWorkTimeReportTable.jsp">
                            <jsp:param name="rowspan" value="4" />
                        </jsp:include>
                        <%-- [WorkTime52] 종료 : 지정일자 근무시간현황 --%>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span>신청 초과근무일</th>
                        <td class="tdDate">
                            <input type="text" name="WORK_DATE" class="datetime-yyyymmdd readOnly" readonly="readonly" data-reset="value" />
                            <input type="checkbox" name="VTKEN" class="checkbox-large" value="X" disabled="disabled" data-reset="checked" data-reset-checked="false" /> 前日 근태에 포함
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span>신청시간</th>
                        <td>
                            <input type="text" name="BEGUZ" class="datetime-hhmm readOnly" readonly="readonly" data-reset="value" />
                            ~
                            <input type="text" name="ENDUZ" class="datetime-hhmm readOnly" readonly="readonly" data-reset="value" />
                            <input type="text" name="STDAZ" class="datetime-hours readOnly align-right" readonly="readonly" data-reset="value" /> 시간
                            <div style="margin-left:10px; display:none" data-reset="display" data-reset-display="none">(휴게/비근무 <span id="CPDABS" data-reset="text"></span>)</div>

                            <input type="hidden" name="PBEG1" data-reset="value" />
                            <input type="hidden" name="PEND1" data-reset="value" />
                            <input type="hidden" name="PUNB1" data-reset="value" />
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span>신청사유</th>
                        <td class="align-top">
                            <select name="OVTM_CODE" data-reset="value">
                                <option value="">-------------</option>
                                <%= WebUtil.printOption(otOptions, data.OVTM_CODE) %>
                            </select>
                            <input type="text" name="REASON" placeholder="신청사유 입력" maxlength="40" class="ot-reason" data-reset="value" />
                            <div class="bottom-filler type-c tall"></div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="tableComment display-none consultant-request">
            <p><span class="bold">초과근무 사후신청은 발생 이후 3근무일 이내에 신청 및 결재를 완료하여 주시기 바랍니다.</span></p>
        </div>
    </div>
    </form>

    <!-- list start -->
    <div class="listArea" id="afterOTDecisioner"></div>
    <!--// list end -->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken salBtn" href="#" onclick="submitAfterOverTime()"><span>신청</span></a></li>
        </ul>
    </div>
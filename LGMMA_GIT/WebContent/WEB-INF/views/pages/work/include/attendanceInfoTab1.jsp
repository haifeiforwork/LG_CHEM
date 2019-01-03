<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%-- 초과근무(OT/특근) 신청 --%>
    <form id="attForm" method="post">
        <input type="hidden" name="work_time" id="work_time" />
        <input type="hidden" name="RowCount" id="RowCount" />
        <input type="hidden" name="inputFlag" id="inputFlag" />
        <input type="hidden" name="TPGUB" id="TPGUB" value="${fn:escapeXml( GUBUN_TPGUB )}" />
        <input type="hidden" name="CHKLMT" id="CHKLMT" />
        <input type="hidden" name="CHGDAT" id="CHGDAT" />

        <!-- Table start -->
        <div class="tableArea">
            <h2 class="subtitle">신청서 작성</h2>
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
                            <th><label>신청일</label></th>
                            <td class="tdDate">
                                <input class="readOnly align-center" type="text" name="BEGDA" id="BEGDA" value="${today}" readonly />
                            </td>
                            <%-- [WorkTime52] 시작 : 지정일자 근무시간현황 --%>
                            <jsp:include page="/WEB-INF/views/pages/work/include/realWorkTimeReportTable.jsp" />
                            <%-- [WorkTime52] 종료 : 지정일자 근무시간현황 --%>
                        </tr>
                        <tr>
                            <th><span class="textPink">*</span><label>초과근무일</label></th>
                            <td class="tdDate">
                                <input id="WORK_DATE" class="datepicker align-center" name="WORK_DATE" type="text" size="5" vname="초과근무일" required="required" />
                                <label><input type="checkbox" name="VTKEN" class="checkbox-large" value="X" /> 前日 근태에 포함</label>
                                <div style="margin-top:4px; color:blue">
                                    * '前日 근태에 포함' 체크는 새벽에 비상 호출 등의 근무가 발생하여 전날 근무와 연속적인 근무가 발생할 경우만 체크해야 함
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="textPink">*</span><label>신청시간</label></th>
                            <td>
                                <select class="w50" name="BEGUZSTDT" id="BEGUZSTDT" vname="신청시간" required="required"${GUBUN_TPGUB eq 'C' and empty GUBUN_WORK ? ' data-limit="9" data-limit-target="ENDUZSTDT"' : ''}>
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                                    <option value="${hour}">${hour}</option>
                                    </c:forEach>
                                </select>
                                :
                                <select class="w50" name="BEGUZEDDT" id="BEGUZEDDT" vname="신청시간" required="required"${GUBUN_TPGUB eq 'C' ? ' data-mimic' : ''}>
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                                    <option value="${minute}">${minute}</option>
                                    </c:forEach>
                                </select>
                                ~
                                <select class="w50" name="ENDUZSTDT" id="ENDUZSTDT" vname="신청시간" required="required">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                                    <option value="${hour}">${hour}</option>
                                    </c:forEach>
                                </select>
                                :
                                <select class="w50" name="ENDUZEDDT" id="ENDUZEDDT" vname="신청시간" required="required"${GUBUN_TPGUB eq 'C' ? ' data-mimic' : ''}>
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                                    <option value="${minute}">${minute}</option>
                                    </c:forEach>
                                </select>
                                <span class="pl10"><input class="w60 readOnly align-right" type="text" id="STDAZ" name="STDAZ" value="0.00" readonly /> 시간</span>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="textPink">*</span><label>신청사유</label></th>
                            <td class="align-top">
                                <select id="OVTM_CODE" name="OVTM_CODE" vname="신청사유" required="required">
                                    <option value="">-------------</option>
                                    <%= WebUtil.printOption(otOptions, data.OVTM_CODE) %>
                                </select>
                                <input type="text" name="REASON" id="REASON" placeholder="신청사유 입력" maxlength="40" class="ot-reason" />
                                <div class="bottom-filler ${TPGUB_CD ? fn:escapeXml( STYLE_TPGUB ) : ''} short"></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!--// Table end -->

        <!-- Table start -->
        <div class="listArea">
            <h2 class="subtitle">선택사항</h2>
            <div class="clear"></div>
            <div class="table">
                <table class="listTable borderBottom" id="breaktimeTable">
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
                        <c:choose><c:when test="${GUBUN_TPGUB eq 'C'}">
                        <tr>
                            <th>휴게시간 1</th>
                            <td>
                                <input type="text" name="PBEG1STDT" id="PBEG1STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
                                <input type="text" name="PBEG1EDDT" id="PBEG1EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
                            </td>
                            <td>
                                <input type="text" name="PEND1STDT" id="PEND1STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
                                <input type="text" name="PEND1EDDT" id="PEND1EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
                            </td>
                            <td><input type="text" name="PUNB1" id="PUNB1" class="span-look align-center" readonly="readonly" /></td>
                            <td class="tdBorder"><input type="text" name="PBEZ1" id="PBEZ1" class="span-look align-center" readonly="readonly" /></td>
                        </tr>
                        <tr>
                            <th>휴게시간 2</th>
                            <td>
                                <input type="text" name="PBEG2STDT" id="PBEG2STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
                                <input type="text" name="PBEG2EDDT" id="PBEG2EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
                            </td>
                            <td>
                                <input type="text" name="PEND2STDT" id="PEND2STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
                                <input type="text" name="PEND2EDDT" id="PEND2EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
                            </td>
                            <td><input type="text" name="PUNB2" id="PUNB2" class="span-look align-center" readonly="readonly" /></td>
                            <td class="tdBorder"><input type="text" name="PBEZ2" id="PBEZ2" class="span-look align-center" readonly="readonly" /></td>
                        </tr>
                        </c:when><c:otherwise>
                        <tr>
                            <th>휴게시간 1</th>
                            <td>
                                <select class="w50" name="PBEG1STDT" id="PBEG1STDT">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                                    <option value="${hour}">${hour}</option>
                                    </c:forEach>
                                </select>
                                :
                                <select class="w50" name="PBEG1EDDT" id="PBEG1EDDT">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                                    <option value="${minute}">${minute}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>
                                <select class="w50" name="PEND1STDT" id="PEND1STDT">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                                    <option value="${hour}">${hour}</option>
                                    </c:forEach>
                                </select>
                                :
                                <select class="w50" name="PEND1EDDT" id="PEND1EDDT">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                                    <option value="${minute}">${minute}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td><input type="text" name="PUNB1" id="PUNB1" /></td>
                            <td class="tdBorder"><input type="text" name="PBEZ1" id="PBEZ1" /></td>
                        </tr>
                        <tr>
                            <th>휴게시간 2</th>
                            <td>
                                <select class="w50" name="PBEG2STDT" id="PBEG2STDT">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                                    <option value="${hour}">${hour}</option>
                                    </c:forEach>
                                </select>
                                :
                                <select class="w50" name="PBEG2EDDT" id="PBEG2EDDT">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                                    <option value="${minute}">${minute}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>
                                <select class="w50" name="PEND2STDT" id="PEND2STDT">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
                                    <option value="${hour}">${hour}</option>
                                    </c:forEach>
                                </select>
                                :
                                <select class="w50" name="PEND2EDDT" id="PEND2EDDT">
                                    <option value="">--</option>
                                    <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
                                    <option value="${minute}">${minute}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td><input type="text" name="PUNB2" id="PUNB2" /></td>
                            <td class="tdBorder"><input type="text" name="PBEZ2" id="PBEZ2" /></td>
                        </tr>
                        </c:otherwise></c:choose>
                    </tbody>
                </table>
            </div>
            <div class="tableComment">
                <p><span class="bold type-c${GUBUN_TPGUB eq 'C' ? '' : ' display-none'}">사무직 초과근무는 시간 단위로만 신청이 가능합니다.</span></p>
                <p><span class="bold">심야 초과근무 입력시, 아래 예시를 참조하여 주시기 바랍니다.</span></p>
                <p>ex) N(night) 대근시 : 23:00 ~ 07:00</p>
            </div>
        </div>
        <!--// Table end -->
    </form>

    <!-- list start -->
    <div class="listArea" id="decisioner"></div>
    <!--// list end -->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="darken salBtn" href="#" onclick="submitOverTime()"><span>신청</span></a></li>
        </ul>
    </div>

<%@ include file="breaktimeTableTemplate.jsp" %>
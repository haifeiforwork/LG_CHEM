<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
    <div class="tableInquiry">
        <table>
            <caption>휴가취소신청</caption>
            <colgroup>
                <col class="col_10p" />
                <col class="col_90p" />
            </colgroup>
            <tbody>
                <tr>
                    <th><span class="textPink">*</span><span id="SCancelDate">휴가일</span></th>
                    <td class="periodpicker">
                        <input type="text" id="I_TBEGDA" name="I_TBEGDA" value="<%= WebUtil.printDate(DataUtil.getLastMonthFirstDay(),".")%>" readonly/> ~
                        <input type="text" id="I_TENDDA" name="I_TENDDA" value="<%= WebUtil.printDate(DataUtil.getMonthLastDays(),".")%>" readonly/>
                    </td>
                    <!-- td><span class="noteItem">※ 근태일 : 초과근무일, 교육/출장, 휴가일</span></td-->
                </tr>
            </tbody>
        </table>
        <div class="tableBtnSearch"><button type="submit" id="attCancelSearchBtn"><span>조회</span></button></div>
    </div>

    <!--// list start -->
    <div class="listArea">
        <div id="attCancelGrid"  class="jsGridPaging"></div>
    </div>
    <!--// list end -->

    <div id="attCancelDiv">
        <div class="tableArea">
            <h2 class="subtitle">휴가신청</h2>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="#" name="RADL-button"${EMPGUB eq 'S' ? ' data-tpgub="C"' : ''}${EMPGUB eq 'S' or TPGUB eq 'D' ? '' : ' style="display:none"'}><span>신청/결재 기한</span></a></li>
                    <li><a href="#" onclick="$schedulePopup();"><span>근무일정 조회</span></a></li>
                </ul>
            </div>
            <div class="table">
                <table class="tableGeneral">
                    <caption>휴가신청</caption>
                    <colgroup>
                        <col class="col_15p"/>
                        <col class="col_85p"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>신청일</th>
                            <td name="BEGDA"></td>
                        </tr>
                        <tr id="cancelVocaType" style="display:none;">
                            <th>휴가유형</th>
                            <td name="cancelVocaTypeTxt"></td>
                        </tr>
                        <tr>
                            <th>휴가구분</th>
                            <td name="AWART" format="replace" code="AWART" codeNm="ATEXT"></td>
                        </tr>
                        <tr>
                            <th>신청사유</th>
                            <td><span id="c_ovtm_code"></span><span name="REASON"></span></td>
                        </tr>
                        <tr>
                            <th>대근자</th>
                            <td name="OVTM_NAME"></td>
                        </tr>
                        <tr>
                            <th>잔여휴가일수</th>
                            <td id="cancelRemainTxt"></td>
                        </tr>
                        <tr>
                            <th>휴가기간</th>
                            <td><span name="APPL_FROM"></span> ~ <span name="APPL_TO"></span></td>
                        </tr>
                        <tr>
                            <th>신청시간</th>
                            <td><span name="BEGUZ" format="time"></span> ~ <span name="ENDUZ" format="time"></span></td>
                        </tr>
                        <tr>
                            <th>휴가공제일수</th>
                            <td><span name="DEDUCT_DATE"></span> 일</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!--// Table start -->
        <div class="tableArea"  style="display:none;" id="cancelDiv">
            <h2 class="subtitle">취소신청사유</h2>
            <div class="table">
                <form id="attCancelForm" name="attCancelForm">
                <table class="tableGeneral">
                    <caption>취소신청사유</caption>
                    <colgroup>
                        <col class="col_15p"/>
                        <col class="col_85p"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label>취소 신청일</label></th>
                            <td class="tdDate">
                                <input class="readOnly" type="text" name="BEGDA" value="<%= WebUtil.printDate(DataUtil.getCurrentDate(),".")%>" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th><span class="textPink">*</span><label>취소사유</label></th>
                            <td>
                                <input class="wPer" id="CREASON" name="CREASON" type="text" value="" required vname="취소사유" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
        </div>
        <!--// Table end -->
    
        <!--// list start -->
        <div class="listArea" id="cancelDecisioner" style="display:none;"></div>
        <div class="tableComment floatLeft pt5 mb30">
            <p><span class="bold colorRed">취소신청에 대한 삭제는 '결재진행현황'에서 진행해야 합니다. 단, 취소신청의 수정은 불가합니다.</span></p>
        </div>
        <!--// list end -->
        <div class="buttonArea mb30" id="cancelBtnDiv" style="display:none;">
            <ul class="btn_crud">
                <c:if test="${selfApprovalEnable == 'Y'}">
                <li><a href="#" id="requestCancelNapprovalBtn" onclick="$attCancelRequest(true);"><span>자가승인</span></a></li>
                </c:if>
                <li><a class="darken" href="#" id="cancelBtn" onclick="$attCancelRequest(false);"><span>취소신청</span></a></li>
            </ul>
        </div>
    </div>
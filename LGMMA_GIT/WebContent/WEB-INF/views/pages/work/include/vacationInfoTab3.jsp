<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
    <div class="tableArea">
        <h2 class="subtitle">휴가실적조회</h2>
        <div class="table">
            <table class="tableGeneral">
            <caption>휴가실적조회</caption>
            <colgroup>
                <col class="col_10p" />
                <col class="col_15p" />
                <col class="col_10p" />
                <col class="col_15p" />
                <col class="col_10p" />
                <col class="col_15p" />
                <col class="col_10p" />
                <col class="col_15p" />
            </colgroup>
            <tbody>
                <tr>
                    <th><label for="year">조회년도</label></th>
                    <td><select class="w90" id="year" name="year">
                            <%= WebUtil.printOption(CodeEntity_vt, Integer.toString(endYear)) %>
                        </select>
                    </td>
                    <th><label for="BALSENG_ILSU">발생일수</label></th>
                    <td><input class="readOnly alignRight" type="text" name="BALSENG_ILSU" id="BALSENG_ILSU" readonly="readonly" /></td>
                    <th><label for="ABRTG_SUM">사용<c:if test="${E_AUTH eq 'Y'}">/보상</c:if>일수</label></th>
                    <td><input class="readOnly alignRight" type="text" name="ABRTG_SUM" id="ABRTG_SUM" readonly="readonly" /></td>
                    <th><label for="JAN_ILSU">잔여일수</label></th>
                    <td><input class="readOnly alignRight" type="text" name="JAN_ILSU" id="JAN_ILSU" readonly="readonly" /></td>
                </tr>
            </tbody>
            </table>
        </div>
    </div>

    <!--// list start -->
    <div class="listArea">
        <h2 class="subtitle">휴가발생내역</h2>
        <div id="balSengListGrid"></div>
    </div>
    <!--// list end -->

    <!--// list start -->
    <div class="listArea">
        <h2 class="subtitle">휴가사용<c:if test="${E_AUTH eq 'Y'}">/보상</c:if>내역</h2>
        <div id="saYongListGrid"></div>
    </div>
    <!--// list end -->

    <!--// list start -->
    <div class="listArea" id="sajunListArea">
        <h2 class="subtitle">사전부여휴가내역</h2>
        <div id="saJunListGrid"></div>
        <div class="totalArea">
            <strong>사전부여휴가 잔여일수</strong>
            <span class="number"><input type="text" id="ABRTG_SUM3" class="alignRight readOnly wPer" readonly ></span>
        </div>
    </div>
    <!--// list end -->

    <div class="listArea" id="selectListArea">
        <h2 class="subtitle">선택적보상휴가내역</h2>
        <div id="selectListGrid"></div>
        <div class="totalArea" >
            <strong>선택적보상휴가 보상일수</strong>
            <span class="number"><input type="text" id="ABRTG_SUM1" class="alignRight readOnly wPer" readonly ></span>
            <strong>선택적보상휴가 잔여일수</strong>
            <span class="number"><input type="text" id="ABRTG_SUM2" class="alignRight readOnly wPer" readonly ></span>
        </div>
    </div>

    <div class="tableComment" id="saJuntableComment">
        <p><span class="bold">용어설명</span></p>
        <ul>
            <li class="janyeoComment"><strong>잔여일수</strong> : 발생한 휴가중 미사용 휴가일수로서 당해년도 말에 보상 가능한 휴가 일수</li>
            <li class="saJunComment"><strong>사전부여휴가</strong> : 근속1년 미만자에게 부여되는 휴가로서 매월 만근한 자에 한하여 발생하며, 당해년도 12월21일에 발생할 년차휴가의 일부를 미리 발생시킨 휴가</li>
            <li class="saJunComment"><strong>사전부여휴가 잔여일수</strong> : 발생한 사전부여휴가중 미사용한 휴가일수로서 당해년도에는 보상하지 않음</li>
            <li class="selectComment"><strong>선택적보상휴가</strong> : 4조3교대 근무자의 주단위 40시간을 초과하는 2시간 근무에 대해서 월 단위로 부여하는 휴가</li>
            <li class="selectComment"><strong>선택적보상휴가 잔여일수</strong> : 매월 근태마감시 사용하지 않은 잔여휴가에 대해 고정O/T로 보상</li>
        </ul>
    </div>
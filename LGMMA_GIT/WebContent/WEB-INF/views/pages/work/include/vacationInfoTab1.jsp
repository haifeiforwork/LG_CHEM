<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
    <!--// Table start -->
    <form id="vacationForm">
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
                <th><label>신청일</label></th>
                <td class="tdDate">
                    <input class="readOnly" type="text" name="BEGDA" value="<%=WebUtil.printDate(DataUtil.getCurrentDate(), ".")%>" id="BEGDA" readonly="readonly" />
                </td>
            </tr>
            <c:if test="${E_AUTH eq 'Y'}">
                <tr>
                    <th><span class="textPink">*</span><label>휴가유형</label></th>
                    <td>
                        <ul class="tdRadioList">
                            <li style="width:160px;"><input type="radio" name="vocaType" value="A" id="voca_radio01_1" /><label for="voca_radio01_1">휴가(연차,경조,공가 등)</label></li>
                            <li><input type="radio" name="vocaType" value="B" id="voca_radio01_0" /><label for="voca_radio01_0">보상휴가</label></li>
                        </ul>
                    </td>
                </tr>
                <tr id="vocaType0Panel" style="display:none;">
                    <th><span class="textPink">*</span><label>휴가구분</label></th>
                    <td>
                        <ul class="tdRadioList">
                            <li><input type="radio" name="awartRadio" value="0111" id="input_radio02_1" /><label for="input_radio02_1">전일휴가</label></li>
                            <li><input type="radio" name="awartRadio" value="0112" id="input_radio02_2" /><label for="input_radio02_2">반일휴가(전반)</label></li>
                            <li><input type="radio" name="awartRadio" value="0113" id="input_radio02_3" /><label for="input_radio02_3">반일휴가(후반)</label></li>
                        </ul>
                    </td>
                </tr>
            </c:if>
            <tr id="vocaType1Panel" <c:if test="${E_AUTH eq 'Y'}">style="display:none;"</c:if>>
                <th><span class="textPink">*</span><label>휴가구분</label></th>
                <td>
                    <ul class="tdRadioList">
                        <li><input type="radio" name="awartRadio" value="0110" id="input_radio01_1" /><label for="input_radio01_1">전일휴가</label></li>
                        <li><input type="radio" name="awartRadio" value="0123" id="input_radio01_2" /><label for="input_radio01_2">반일휴가(전반)</label></li>
                        <li><input type="radio" name="awartRadio" value="0124" id="input_radio01_3" /><label for="input_radio01_3">반일휴가(후반)</label></li>
<%
                    //  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다.
                    if (!userData.e_regno.equals("") && userData.e_regno.substring(6,7).equals("2")) {
%>
                        <li><input type="radio" name="awartRadio" value="0190" id="input_radio01_4" /><label for="input_radio01_4">모성보호휴가</label></li>
<%
                    }
%>
                        <li><input type="radio" name="awartRadio" value="0340" id="input_radio01_5" /><label for="input_radio01_5">유휴</label></li>
                        <li><input type="radio" name="awartRadio" value="0140" id="input_radio01_6" /><label for="input_radio01_6">하계휴가</label></li>
                        <li><input type="radio" name="awartRadio" value="0130" id="input_radio01_7" /><label for="input_radio01_7">경조공가</label></li>
                        <li><input type="radio" name="awartRadio" value="0170" id="input_radio01_8" /><label for="input_radio01_8">전일공가</label></li>
                        <li><input type="radio" name="awartRadio" value="0180" id="input_radio01_9" /><label for="input_radio01_9">시간공가</label></li>
<%
                    //  2002.07.08. 여사원일경우 보건휴가를 신청가능하도록 한다.
                    if (!userData.e_regno.equals("") && userData.e_regno.substring(6,7).equals("2")) {
%>
                        <li><input type="radio" name="awartRadio" value="0150" id="input_radio01_10" /><label for="input_radio01_10">보건휴가</label></li>
<%
                    }
%>
                    <c:if test="${E_AUTH ne 'Y' && !(user.e_titl2 eq 'CFO' || user.e_titl2 eq '담당(관리자)' || user.e_titl2 eq '실장' || user.e_titl2 eq '연구소장')}">
                        <li><input type="radio" name="awartRadio" value="0220" id="input_radio01_11" /><label for="input_radio01_11">지각</label></li>
                        <li><input type="radio" name="awartRadio" value="0230" id="input_radio01_12" /><label for="input_radio01_12">조퇴</label></li>
                    </c:if>
                        <li><input type="radio" name="awartRadio" value="0133" id="input_radio01_14" /><label for="input_radio01_14">난임휴가(유급)</label></li>
                        <li><input type="radio" name="awartRadio" value="0134" id="input_radio01_13" /><label for="input_radio01_13">난임휴가(무급)</label></li>
                    </ul>
                </td>
            </tr>
            <tr>
                <th><span class="textPink">*</span><label for="REASON">신청사유</label></th>
                <td>
                    <select id="OVTM_CODE1" name="OVTM_CODE1" vname="신청사유">
                        <option value="">---------선택---------</option>
<%
                    //전일 공가  추가 ( 이세희 대리)
                    Vector D03VocationAReason_vt1  = (new D03VocationAReasonRFC()).getSubtyCode(userData.companyCode, userData.empNo, "0170" , DataUtil.getCurrentDate());
                        for( int j = 0 ; j < D03VocationAReason_vt1.size() ; j++) {
                        D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt1.get(j);
                        CodeEntity code_data = new CodeEntity();
%>
                        <option value ="<%=old_data.SCODE%>"><%=old_data.STEXT %></option>
<%
                    }
%>
                    </select>
                    <select id="OVTM_CODE2" name="OVTM_CODE2" vname="신청사유">
                        <option value="">---------선택---------</option>
<%
                    //전일 공가  추가 ( 이세희 대리)
                    Vector D03VocationAReason_vt2  = (new D03VocationAReasonRFC()).getSubtyCode(userData.companyCode, userData.empNo, "0180" , DataUtil.getCurrentDate());
                    for( int j = 0 ; j < D03VocationAReason_vt2.size() ; j++) {
                        D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt2.get(j);
                        CodeEntity code_data = new CodeEntity();
%>
                        <option value ="<%=old_data.SCODE%>"><%=old_data.STEXT %></option>
<%
                    }
%>
                    </select>
                    <select id="CONG_CODE" name="CONG_CODE" vname="신청사유">
                        <option value="">---------선택---------</option>
                        <%= WebUtil.printOption((new E19CongCodeRFC()).getCongCode(userData.companyCode,"X") )%>
                    </select>

                    <input class="w200" type="text" name="REASON" id="REASON" vname="신청사유" required />

                    <span class="buttonArea">
                        <ul class="btn_crud">
                            <li><a class="darken" href="#" id="EventMoneyListBtn" ><span>경조금조회</span></a></li>
                        </ul>
                    </span>
                </td>

            </tr>
            <tr>
                <th><label for="OVTM_NAME">대근자</label></th>
                <td>
                    <input class="fixedWidth" type="text" name="OVTM_NAME" id="OVTM_NAME" />
                    <span class="noteItem colorRed">※ 교대조는 필수입력 사항입니다. </span>
                </td>
            </tr>
            <tr>
                <th><label for="P_REMAIN">잔여휴가일수</label></th>
                <td>
                    <c:choose>
                        <c:when test="${E_AUTH ne 'Y'}">
                            <input class="fixedWidth readOnly alignCenter" type="text" name="P_REMAIN" id="P_REMAIN" value="<%= dataRemain.P_REMAIN.equals("0") ? "0" : WebUtil.printNumFormat(dataRemain.P_REMAIN, 1) %>/<%= dataRemain.P_SELECT_C.equals("0") ? "0" : WebUtil.printNumFormat(dataRemain.P_SELECT_C, 1) %>/<%= dataRemain.P_VACATION.equals("0") ? "0" : WebUtil.printNumFormat(dataRemain.P_VACATION, 1) %>" readonly/> 일
                            <span class="noteItem colorBlue">(연월차/선택적보상/하계)</span>
                        </c:when>
                        <c:otherwise>
                            <input class="fixedWidth readOnly alignCenter" type="text" name="P_REMAIN" id="P_REMAIN" value="" readonly/> 일
                            <span class="noteItem colorBlue"></span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th><span class="textPink">*</span><label for="inputDateFrom">휴가기간</label></th>
                <td class="tdDate">
                    <input type="text" id="inputDateFrom" name="APPL_FROM" size="5" vname="휴가시작일" required />
                    ~
                    <input type="text" id="inputDateTo" name="APPL_TO" size="5" vname="휴가종료일" required />
	                <span id="Message_1" name="Message_1" class="colorRed">※ 6일 이상 경조휴가의 경우, 휴가 기간은 반드시 토요일을 포함하여 입력해야 합니다.</span>
                </td>
            </tr>
             <tr>
                <th><label for="BEGUZ_HH">신청시간</label></th>
                <td>
                    <select class="w50" id="BEGUZ_HH" name="BEGUZ_HH" >
<%
                for( int i = 0 ; i < 24 ; i++) {
                    String temp = Integer.toString(i);
%>
                        <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
                }
%>
                    </select>
                    :
                    <select class="w50" id="BEGUZ_MM" name="BEGUZ_MM" >
<%
                for( int i = 0 ; i < 60 ; i++) {
                    String temp = Integer.toString(i);
%>
                        <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
                }
%>
                    </select>
                    ~
                    <select class="w50" id="ENDUZ_HH" name="ENDUZ_HH" >
<%
                for( int i = 0 ; i < 24 ; i++) {
                    String temp = Integer.toString(i);
%>
                        <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
                }
%>
                    </select>
                    :
                    <select class="w50" id="ENDUZ_MM" name="ENDUZ_MM" >
<%
                for( int i = 0 ; i < 60 ; i++) {
                    String temp = Integer.toString(i);
%>
                        <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
                }
%>
                    </select>
                    <c:choose>
                    	<c:when test="${E_AUTH eq 'Y'}">
                    		<span class="noteItem colorRed">※ 신청시간은 시간공가의 경우에만 입력 가능합니다.</span>
                    	</c:when>
                        <c:when test="${E_AUTH ne 'Y' && !(user.e_titl2 eq 'CFO' || user.e_titl2 eq '담당(관리자)' || user.e_titl2 eq '실장' || user.e_titl2 eq '연구소장')}">
                            <span class="noteItem colorRed">※ 신청시간은 반일휴가,시간공가,지각,조퇴의 경우에만 입력 가능합니다.</span>
                        </c:when>
                        <c:otherwise>
                            <span class="noteItem colorRed">※ 신청시간은 반일휴가,시간공가의 경우에만 입력 가능합니다.</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            </tbody>
            </table>
        </div>
        <div class="tableComment">
            <p id="Message_2" name="Message_2"><span class="bold">경조발생일 기준 1개월 이내 사용가능</span></p>
            <p><span class="bold">유휴(휴일비근무)는 전문기술직 전용 휴가구분입니다.</span></p>
            <p><span class="bold">난임휴가는 연간 3일 한도로(최초 1일 유급, 나머지 2일 무급)사용 가능합니다.</span></p>
			<p><span class="bold">여성에 한하여 근태월 기준 월1일의 보건휴가(무급) 또는 모성보호휴가(임신 시, 유급) 사용 가능합니다.</span></p>
            
        </div>
    </div>
    <input type="hidden" name="E_AUTH" value="${E_AUTH}" />
    <input type="hidden" id="AWART"       name="AWART" />
    <input type="hidden" id="DEDUCT_DATE" name="DEDUCT_DATE" />
    <input type="hidden" id="REMAIN_DATE" name="REMAIN_DATE" value="<%= dataRemain.P_REMAIN   %>" />
    <input type="hidden" id="VACATI_DATE" name="VACATI_DATE" value="<%= dataRemain.P_VACATION %>" />
    <input type="hidden" id="BE_ALLO_DAY" name="BE_ALLO_DAY" value="<%= dataRemain.P_BE_ALLO  %>" />
    <input type="hidden" id="SELECT_C"    name="SELECT_C"    value="<%= dataRemain.P_SELECT_C %>" />
    <input type="hidden" id="OVTM_CODE"   name="OVTM_CODE"  />
    <input type="hidden" id="BEGUZ"       name="BEGUZ" />
    <input type="hidden" id="ENDUZ"       name="ENDUZ" />
    <input type="hidden" id="timeopen"    name="timeopen" />

    <!-- 경조금 -->
    <input type="hidden" name="DETAIL_PERNR"      id="DETAIL_PERNR" />
    <input type="hidden" name="DETAIL_AINF_SEQN"  id="DETAIL_AINF_SEQN" />
    <input type="hidden" name="DETAIL_CONG_CODE"  id="DETAIL_CONG_CODE" />
    <input type="hidden" name="DETAIL_CONG_NAME"  id="DETAIL_CONG_NAME" />
    <input type="hidden" name="DETAIL_RELA_CODE"  id="DETAIL_RELA_CODE" />
    <input type="hidden" name="DETAIL_RELA_NAME"  id="DETAIL_RELA_NAME" />
    <input type="hidden" name="DETAIL_CONG_DATE"  id="DETAIL_CONG_DATE" />
    <input type="hidden" name="DETAIL_HOLI_CONT"  id="DETAIL_HOLI_CONT" />

    <!-- 경조휴가 날짜validatoin 용 -->
    <input type="hidden" name="CONG_DATE_CHECK"  id="CONG_DATE_CHECK" />
    </form>
    <!--// Table end -->

    <!--// list start -->
    <div class="listArea" id="decisionerTab1"></div>
    <!--// list end -->

    <div class="buttonArea">
        <ul class="btn_crud">
            <c:if test="${selfApprovalEnable == 'Y'}">
            <li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
            </c:if>
            <li><a href="#" id="requestVacationBtn" class="darken" ><span>신청</span></a></li>
        </ul>
    </div>
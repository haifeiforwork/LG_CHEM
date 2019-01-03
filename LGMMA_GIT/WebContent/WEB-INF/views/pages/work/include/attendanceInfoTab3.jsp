<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%-- 교육/출장 신청 --%>
    <form id="eduForm" name="eduForm" method="post" action="">
    <input type="hidden" name="RowCount" id="RowCount" value="" />
    <input type="hidden" name="PERNR" id="PERNR" value="<%=PERNR%>" />
    <input type="hidden" name="TAB_F01" id="TAB_F01" value="<c:out value="${TAB.F01}" />" />

    <!-- Table start -->
    <div class="tableArea">
        <h2 class="subtitle">신청서 작성</h2>
        <div class="buttonArea">
            <ul class="btn_mdl">
                <li><a href="#" onclick="$schedulePopup()"><span>근무일정 조회</span></a></li>
            </ul>
        </div>
        <div class="table">
            <table class="tableGeneral">
                <caption>교육/출장 신청</caption>
                <colgroup>
                    <col class="col_15p" />
                    <col class="col_85p" />
                </colgroup>
                <tbody>
<%
    if ("Y".equals(user.e_representative)) {
%>
                    <!-- 사원검색 보여주는 부분 끝  -->
                    <tr>
                        <td colspan="2" style="height:21px; empty-cells:show"></td>
                    </tr>
<%
    }
    if (isForbiddenEduOrBizTrip) { // 교육/출장 대상이 아닌 경우 // (이세희 대리)
%>
                    <tr>
                        <td colspan="2" class="align-center bold" style="padding:8px 0">교육/출장 신청을 할 수 없습니다.<br />담당자에게 문의하세요.</td>
                    </tr>
<%
    } else {
%>
                    <tr>
                        <th><label for="inputText02-1">신청일</label></th>
                        <td class="tdDate">
                            <input class="readOnly" type="text" id="BEGDA" name="BEGDA" value="${empty data.BEGDA ? today : data.BEGDA}" readonly />
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><label>신청구분</label></th>
                        <td>
                        	<c:choose>
	                        	<c:when test="${TAB.F01 eq 'Y'}">
                        			<label><input type="radio" name="AWART" id="AWART" value="0010" checked="checked" /> 필수교육</label>
                        			<label><input type="radio" name="AWART" id="AWART" value="0011" /> 선택교육</label>
                        		</c:when>
                        		<c:otherwise>
                        			<label><input type="radio" name="AWART" id="AWART" value="0010" checked="checked" /> 교육</label>
                        		</c:otherwise>
                        	</c:choose>
                            <label><input type="radio" name="AWART" id="AWART" value="0020" /> 출장</label>
                        </td>
                    </tr>
                    <tr>
                        <th><label>대근자</label></th>
                        <td>
                            <input class="w300" type="text" name="OVTM_NAME" size="40" maxlength="40" />
                            <span class="noteItem colorRed">※ 교대조는 필수입력 사항입니다.</span>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><label>신청기간</label></th>
                        <td class="tdDate">
                            <input id="inputDateFrom" name="APPL_FROM" type="text" size="5" vname="신청기간" required="required" />
                            ~
                            <input id="inputDateTo"   name="APPL_TO"  type="text" size="5" vname="신청기간" required="required" />
                        </td>
                    </tr>
                    <tr id="inputTimeArea">
                        <th><label>신청시간</label></th>
                        <td class="tdDate">
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
		                for( int i = 0 ; i < 60 ; i+=10) {
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
		                for( int i = 0 ; i < 60 ; i+=10) {
		                    String temp = Integer.toString(i);
%>
		                        <option value='<%= temp.length() == 1 ? '0' + temp : temp %>'><%= temp.length() == 1 ? '0' + temp : temp %></option>
<%
		                }
%>
		                    </select>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span><label>신청사유</label></th>
                        <td>
                            <select name="OVTM_CODE" id="OVTM_CODES" vname="신청사유" required="required">
                                <option value="">-------------</option>
                                <%= WebUtil.printOption(eduOptions, "") %>
                            </select>
                            <p class="br"><input class="wPer" type="text" name="REASON" id="REASONS" placeholder="신청사유 입력" /></p>
                        </td>
                    </tr>
                </tbody>
<%
    }
%>
            </table>
        </div>
<%
    if (!isForbiddenEduOrBizTrip) { // 교육/출장 대상이 아닌 경우 // (이세희 대리)
%>
        <div class="tableComment">
            <p><span class="bold">안내사항</span></p>
            <p>근무 OFF시, 교육인 경우에는 교육시간만큼 초과근무 신청하시기 바랍니다. (O/T 자동발생 안됨)</p>
            <p>전일 교육 및 출장의 경우, 교육/출장 근태 신청 바랍니다.</p>
        </div>
<%
    }
%>
    </div>
    <!-- Table end -->
    </form>

<%
    if (!isForbiddenEduOrBizTrip) { // 교육/출장 대상이 아닌 경우 // (이세희 대리)
%>
    <!-- list start -->
    <div class="listArea" id="edudecisioner"></div>
    <!--// list end -->
    
    <div class="buttonArea">
        <ul class="btn_crud">
            <c:if test="${selfApprovalEnable eq 'Y'}">
            <li><a href="#" id="requestNapprovalBtn"><span>자가승인</span></a></li>
            </c:if>
            <li><a href="#" class="darken" id="eduBtn" onclick="EduClient(false)"><span>신청</span></a></li>
        </ul>
    </div>
<%
    }
%>
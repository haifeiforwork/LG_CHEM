<%--
/******************************************************************************/
/*                                                         						*/
/*   System Name  : MSS                                                  */
/*   1Depth Name  : 공통                                                        		*/
/*   2Depth Name  :                                                         */
/*   Program Name : 기본값 설정                                                   	*/
/*   Program ID   : DefaultSettingPop.jsp                              */
/*   Description  : 인원추가 기본값 설정 팝업                                   */
/*   Note         : 없음                                                        			*/
/*   Creation     : 2017-12-08 정준현                                           	*/
/*   Update       :                                                            */
/*                                                                              	*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%@ include file="/web/common/popupPorcess.jsp" %>

<jsp:include page="/include/header.jsp"/>

<script language="JavaScript">

	var regExp = new RegExp(/^([1-9]|[01][0-9]|2[0-3])([0-5][0-9])$/);

	//확인(부모창에 값 전달)
	function goSubmit(){

		if($("#D_WTMCODE").length > 0){$(opener.document).find("#D_WTMCODE").val($("#D_WTMCODE").val());}
		if($("#D_BEGDA").length > 0){$(opener.document).find("#D_BEGDA").val($("#D_BEGDA").val());}
		if($("#D_ENDDA").length > 0){$(opener.document).find("#D_ENDDA").val($("#D_ENDDA").val());}
		if($("#D_BEGUZ").length > 0){$(opener.document).find("#D_BEGUZ").val($("#D_BEGUZ").val());}
		if($("#D_ENDUZ").length > 0){$(opener.document).find("#D_ENDUZ").val($("#D_ENDUZ").val());}
		if($("#D_PBEG1").length > 0){$(opener.document).find("#D_PBEG1").val($("#D_PBEG1").val());}
		if($("#D_PEND1").length > 0){$(opener.document).find("#D_PEND1").val($("#D_PEND1").val());}
		if($("#D_PBEG2").length > 0){$(opener.document).find("#D_PBEG2").val($("#D_PBEG2").val());}
		if($("#D_PEND2").length > 0){$(opener.document).find("#D_PEND2").val($("#D_PEND2").val());}
		if($("#D_REASON").length > 0){$(opener.document).find("#D_REASON").val($("#D_REASON").val());}
		if($("#D_DETAIL").length > 0){$(opener.document).find("#D_DETAIL").val($("#D_DETAIL").val());}
		if($("#D_REASON_YN").length > 0){$(opener.document).find("#D_REASON_YN").val($("#D_REASON_YN").val());}
		if($("#D_DETAIL_YN").length > 0){$(opener.document).find("#D_DETAIL_YN").val($("#D_DETAIL_YN").val());}
		if($("#D_TIME_YN").length > 0){$(opener.document).find("#D_TIME_YN").val($("#D_TIME_YN").val());}
		if($("#D_STDAZ_YN").length > 0){$(opener.document).find("#D_STDAZ_YN").val($("#D_STDAZ_YN").val());}
		if($("#D_PTIME_YN").length > 0){$(opener.document).find("#D_PTIME_YN").val($("#D_PTIME_YN").val());}

		this.close();

	}

	//시간 : 표시
	function textCh(val){
		val = val + "";
		var point = val.length % 2;
        var len = val.length;
		str = val.substring(0, point);
        while (point < len) {
            if (str != "") str += ":";
            str += val.substring(point, point + 2);
            point += 2;
        }
		return str;
	}

	$(document).ready(function(){
		//시간 형식 체크
		$(".eTime").blur(function(){
			if($.trim($(this).val()) == ""){
				return;
			}
			if($.trim($(this).val()).length < 4){
				alert('<spring:message code="MSG.D.D40.0016"/>'); /* 올바른 시간을 입력해주십시오.(예 0930, 0030) */
				return;
			}
	        var isValidrunningTime = regExp.test($.trim($(this).val()).replace(/\:/g,''));
	        if( isValidrunningTime == false ){
	        	alert('<spring:message code="MSG.D.D40.0016"/>'); /* 올바른 시간을 입력해주십시오.(예 0930, 0030) */
	        }else{
	        	$(this).val(textCh($.trim($(this).val()).replace(/\:/g,'')));
	        }
		});

		//  : 제거
		$(".eTime").focus(function(){
			$(this).val($(this).val().replace(/\:/g,''));
			$(this).select();
		});

		//시작일과 종료일을 같게
		$("#D_BEGDA").change(function(){
  			$("#D_ENDDA").val($(this).val());
		});

		//유형 체인지 이벤트
		$("#D_WTMCODE").on("change",function(){
			var option = '<option value=""><spring:message code="LABEL.D.D11.0047"/></option>';

			if($(this).val() != ""){
				//사유 select option create
				'<c:forEach var="row" items="${OBJPS_OUT2}" varStatus="status">';
					if('<c:out value="${row.PKEY}"/>' == $(this).val()){
						option += '<option value="<c:out value="${row.CODE }"/>"><c:out value="${row.TEXT }"/></option>';
					}
				'</c:forEach>';
				//화면 disabled 처리
				'<c:forEach var="row" items="${OBJPS_OUT3}" varStatus="status">';
					if('<c:out value="${row.PKEY}"/>' == $(this).val()){
						if('<c:out value="${row.BEGUZ}"/>' == 'Y'){
							$("#D_BEGUZ").attr('disabled', false);
						}else if('<c:out value="${row.BEGUZ}"/>' == 'N'){
							$("#D_BEGUZ").val("");
							$("#D_BEGUZ").attr('disabled', true);
						}
						if('<c:out value="${row.ENDUZ}"/>' == 'Y'){
							$("#D_ENDUZ").attr('disabled', false);
						}else if('<c:out value="${row.ENDUZ}"/>' == 'N'){
							$("#D_ENDUZ").val("");
							$("#D_ENDUZ").attr('disabled', true);
						}
						if('<c:out value="${row.PBEG1}"/>' == 'Y'){
							$("#D_PBEG1").attr('disabled', false);
						}else if('<c:out value="${row.PBEG1}"/>' == 'N'){
							$("#D_PBEG1").val("");
							$("#D_PBEG1").attr('disabled', true);
						}
						if('<c:out value="${row.PEND1}"/>' == 'Y'){
							$("#D_PEND1").attr('disabled', false);
						}else if('<c:out value="${row.PEND1}"/>' == 'N'){
							$("#D_PEND1").val("");
							$("#D_PEND1").attr('disabled', true);
						}
						if('<c:out value="${row.PBEG2}"/>' == 'Y'){
							$("#D_PBEG2").attr('disabled', false);
						}else if('<c:out value="${row.PBEG2}"/>' == 'N'){
							$("#D_PBEG2").val("");
							$("#D_PBEG2").attr('disabled', true);
						}
						if('<c:out value="${row.PEND2}"/>' == 'Y'){
							$("#D_PEND2").attr('disabled', false);
						}else if('<c:out value="${row.PEND2}"/>' == 'N'){
							$("#D_PEND2").val("");
							$("#D_PEND2").attr('disabled', true);
						}
						if('<c:out value="${row.REASON}"/>' == 'Y'){
							$("#D_REASON").attr('disabled', false);
						}else if('<c:out value="${row.REASON}"/>' == 'N'){
							$("#D_REASON").val("");
							$("#D_REASON").attr('disabled', true);
						}
						if('<c:out value="${row.DETAIL}"/>' == 'Y'){
							$("#D_DETAIL").attr('disabled', false);
						}else if('<c:out value="${row.DETAIL}"/>' == 'N'){
							$("#D_DETAIL").val("");
							$("#D_DETAIL").attr('disabled', true);
						}

						$("#D_REASON_YN").val('<c:out value="${row.REASON_YN}"/>');
						$("#D_DETAIL_YN").val('<c:out value="${row.DETAIL_YN}"/>');
						$("#D_TIME_YN").val('<c:out value="${row.TIME_YN}"/>');
						$("#D_STDAZ_YN").val('<c:out value="${row.STDAZ_YN}"/>');
						$("#D_PTIME_YN").val('<c:out value="${row.PTIME_YN}"/>');

					}
				'</c:forEach>';

			}else{
				$("#D_BEGUZ").attr('disabled', false);
				$("#D_ENDUZ").attr('disabled', false);
				$("#D_PBEG1").attr('disabled', false);
				$("#D_PEND1").attr('disabled', false);
				$("#D_PBEG2").attr('disabled', false);
				$("#D_PEND2").attr('disabled', false);
				$("#D_REASON").attr('disabled', false);
				$("#D_DETAIL").attr('disabled', false);
			}

			$("#D_REASON").html(option);

		}).change();

		//REASON
		$("select[name=D_REASON]").on("change", function(){
			var cnt = 0;
			var code = $("#D_WTMCODE").val()+$(this).val();

			//기타인 경우 상세사유 입력하게
			'<c:forEach var="row" items="${OBJPS_OUT4}" varStatus="i">';

				if('<c:out value="${row.PKEY}${row.CODE}"/>' == code){
					cnt++;
				}
			'</c:forEach>';

			if(cnt != 0){
				$("#D_DETAIL").attr('disabled', false);
			}else{
				if($("#D_DETAIL_YN").val() == "N"){
					$("#D_DETAIL").attr('disabled', true);
				}else{
					$("#D_DETAIL").attr('disabled', false);
				}
			}
		}).change();

	});

</script>
</head>

<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" >
	<form id="form1" name="form1" method="post" action="">
		<input type="hidden" id="D_REASON_YN" name="D_REASON_YN" />
		<input type="hidden" id="D_DETAIL_YN" name="D_DETAIL_YN" />
		<input type="hidden" id="D_TIME_YN" name="D_TIME_YN" />
		<input type="hidden" id="D_STDAZ_YN" name="D_STDAZ_YN" />
		<input type="hidden" id="D_PTIME_YN" name="D_PTIME_YN" />
		<div class="winPop">
			<div class="header">
				<span>
					<spring:message code="BUTTON.D.D40.0007"/><%--기본값 설정--%>
				</span>
				<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
			</div>

			<div class="body">
				<div class="content">
					<div class="subContent">
						<div class="tableArea">
							<div class="table">
								<table class="tableGeneral">
									<colgroup>
										<col width="20%" />
										<col width="80%" />
									</colgroup>
									<tbody>

									<!-- 초과근무 시작 -->
									<c:if test="${param.I_SCREEN eq 'A' }">
										<tr>
											<th class="th02"><spring:message code='LABEL.D.D40.0052' /><!-- 유형 --></th>
											<td>
												<select id="D_WTMCODE" name="D_WTMCODE">
<%-- 													<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option> --%>
													<c:forEach var="row" items="${OBJPS_OUT1}" varStatus="status">
														<option value='<c:out value="${row.CODE }"/>'><c:out value="${row.TEXT }"/></option>
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D15.0206"/><!-- 일자 --></th>
											<td>
												<input type="text"  class="date" id="D_BEGDA" name="D_BEGDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
												~ <input type="text"  class="date" id="D_ENDDA" name="D_ENDDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D12.0043"/><!-- 시간 --></th>
											<td>
												<input type="text" class="eTime" id="D_BEGUZ" name="D_BEGUZ" value="" style="width: 35px;" maxlength="4">
												~ <input type="text" class="eTime" id="D_ENDUZ" name="D_ENDUZ" value="" style="width: 35px;" maxlength="4">
												<spring:message code="LABEL.D.D40.0160"/> <!-- ex) 13시 30분 → 1330, 09시 30분 → 0930 -->
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D12.0068"/><!-- 휴식시간1 --></th>
											<td>
												<input type="text" class="eTime" id="D_PBEG1" name="D_PBEG1" value="" style="width: 35px;" maxlength="4">
												~ <input type="text" class="eTime" id="D_PEND1" name="D_PEND1" value="" style="width: 35px;" maxlength="4">
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D12.0070"/><!-- 휴식시간2 --></th>
											<td>
												<input type="text" class="eTime" id="D_PBEG2" name="D_PBEG2" value="" style="width: 35px;" maxlength="4">
												~ <input type="text" class="eTime" id="D_PEND2" name="D_PEND2" value="" style="width: 35px;" maxlength="4">
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D12.0024"/><!-- 사유 --></th>
											<td>
												<select  id="D_REASON" name="D_REASON">
													<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
												</select>
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D40.0053"/><!-- 상세사유 --></th>
											<td>
												<input type=text id="D_DETAIL" name="D_DETAIL" value="" >
											</td>
										</tr>
									</c:if>
									<!-- 초과근무 종료 -->

									<!-- 근무 비근무 시작 -->
									<c:if test="${param.I_SCREEN eq 'B' }">
										<tr>
											<th class="th02"><spring:message code='LABEL.D.D40.0052' /><!-- 유형 --></th>
											<td>
												<select id="D_WTMCODE" name="D_WTMCODE">
													<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
													<c:forEach var="row" items="${OBJPS_OUT1}" varStatus="status">
														<option value='<c:out value="${row.CODE }"/>'><c:out value="${row.TEXT }"/></option>
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D15.0206"/><!-- 일자 --></th>
											<td>
												<input type="text"  class="date" id="D_BEGDA" name="D_BEGDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
												~ <input type="text"  class="date" id="D_ENDDA" name="D_ENDDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D12.0043"/><!-- 시간 --></th>
											<td>
												<input type="text" class="eTime" id="D_BEGUZ" name="D_BEGUZ" value="" style="width: 35px;" maxlength="4">
												~ <input type="text" class="eTime" id="D_ENDUZ" name="D_ENDUZ" value="" style="width: 35px;" maxlength="4">
												<spring:message code="LABEL.D.D40.0160"/> <!-- ex) 13시 30분 → 1330, 09시 30분 → 0930 -->
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D12.0024"/><!-- 사유 --></th>
											<td>
												<select  id="D_REASON" name="D_REASON">
													<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
												</select>
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D40.0053"/><!-- 상세사유 --></th>
											<td>
												<input type=text id="D_DETAIL" name="D_DETAIL" value="" >
											</td>
										</tr>
									</c:if>
									<!-- 근무 비근무 종료 -->

									<!-- 사원지급정보 시작 -->
									<c:if test="${param.I_SCREEN eq 'C' }">
										<tr>
											<th class="th02"><spring:message code='LABEL.D.D40.0052' /><!-- 유형 --></th>
											<td>
												<select id="D_WTMCODE" name="D_WTMCODE">
													<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
													<c:forEach var="row" items="${OBJPS_OUT1}" varStatus="status">
														<option value='<c:out value="${row.CODE }"/>'><c:out value="${row.TEXT }"/></option>
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D15.0206"/><!-- 일자 --></th>
											<td>
												<input type="text"  class="date" id="D_BEGDA" name="D_BEGDA" value=""  size="15" onBlur="javascript:dateFormat(this);" style="margin-right: 4px">
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D12.0043"/><!-- 시간 --></th>
											<td>
												<input type="text" class="eTime" id="D_BEGUZ" name="D_BEGUZ" value="" style="width: 35px;" maxlength="4">
												~ <input type="text" class="eTime" id="D_ENDUZ" name="D_ENDUZ" value="" style="width: 35px;" maxlength="4">
												<spring:message code="LABEL.D.D40.0160"/> <!-- ex) 13시 30분 → 1330, 09시 30분 → 0930 -->
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D40.0161"/><!-- 휴식시간 --></th>
											<td>
												<input type="text" class="eTime" id="D_PBEG1" name="D_PBEG1" value="" style="width: 35px;" maxlength="4">
												~ <input type="text" class="eTime" id="D_PEND1" name="D_PEND1" value="" style="width: 35px;" maxlength="4">
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D12.0024"/><!-- 사유 --></th>
											<td>
												<select  id="D_REASON" name="D_REASON">
													<option value=""><spring:message code="LABEL.D.D11.0047"/><!-- 선택 --></option>
												</select>
											</td>
										</tr>
										<tr>
											<th class="th02"><spring:message code="LABEL.D.D40.0053"/><!-- 상세사유 --></th>
											<td>
												<input type=text id="D_DETAIL" name="D_DETAIL" value="" >
											</td>
										</tr>
									</c:if>
									<!-- 사원지급정보 종료 -->
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="buttonArea" style="padding-right: 20px;">
				<ul class="btn_crud">
					<li><a class="darken" href="javascript:goSubmit();"><span><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
					<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE" /><%--닫기--%></span></a></li>
				</ul>
			</div>
		</div>
	</form>
</body>
<jsp:include page="/include/footer.jsp"/>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.A.*"%>
<%@ page import="hris.A.rfc.*"%>
<%@ page import="hris.A.A13Address.rfc.A13AddressNationRFC"%>
<%@ page import="hris.A.A13Address.rfc.A13AddressLiveTypeRFC"%>
<%@ page import="hris.A.A13Address.rfc.A13AddressTypeRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%
	Vector a01SelfDetailData_vt = (Vector) request.getAttribute("A01SelfDetailData_vt");
	String imgUrl = (String) request.getAttribute("imgUrl");
	A01SelfDetailData data = (A01SelfDetailData) a01SelfDetailData_vt.get(0);
%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="15">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="15">&nbsp;</td>
			<td>
				<!--타이틀 테이블 시작-->
				<table width="790" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td width="250" class="title01">개인 인적사항 조회</td>
					</tr>
				</table> <!--타이틀 테이블 끝-->
			</td>
		</tr>
		<tr>
			<td width="15">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="15">&nbsp;</td>
			<td>
				<!--개인인적사항 테이블 시작-->
				<table width="750" border="0" cellspacing="1" cellpadding="0"
					class="table01">
					<tr>
						<td class="tr01">
							<table width="730" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<table width="730" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="120">
													<table width="115" border="1" cellspacing="1"
														cellpadding="0" height="148" class="table02">
														<tr>
															<td class="td04"><img name="photo" border="0"
																src="<c:out value='${imgUrl}'/>" width="110"
																height="140"></td>
															<!--<td class="td04"><img name="photo" border="0" src="<c:out value='${WebUtil.ImageURL}'/>pernr/000<c:out value='${data.PERNR}'/>.JPG" width="110" height="140" ></td>-->
														</tr>
													</table>
												</td>
												<td>
													<table width="610" border="1" cellspacing="1"
														cellpadding="3" class="table02">
														<tr>
															<td class="td03" width="80">사번</td>
															<td class="td04" width="109"><%=data.PERNR%>&nbsp;</td>
															<td class="td03" width="80">소속</td>
															<td colspan="3" class="td04"><%=data.ORGTX%>&nbsp;</td>
														</tr>
														<tr>
															<td class="td03">성명(한글)</td>
															<td class="td04"><%=data.KNAME%>&nbsp;</td>
															<td class="td03">성명(한자)</td>
															<td class="td04" width="80"><%=data.CNAME%>&nbsp;</td>
															<td class="td03" width="80">성명(영어)</td>
															<td class="td04" width="138"><%=data.YNAME%>&nbsp;</td>
														</tr>
														<tr>
															<td class="td03">직위</td>
															<td class="td04">
																<%
																	if (data.PERNR.equals("00008")) {
																%> 사장&nbsp; <%
 	} else {
 %>
																<%=data.TITEL%>&nbsp; <%
 	}
 %>
															</td>
															<td class="td03">생년월일</td>
															<td class="td04"><%=WebUtil.printDate(data.GBDAT)%>&nbsp;</td>
															<td class="td03">주민번호</td>
															<td class="td04"><%=DataUtil.addSeparate(data.REGNO)%>&nbsp;</td>
														</tr>
														<tr>
															<td class="td03">사원구분</td>
															<td class="td04"><%=data.PTEXT%>&nbsp;</td>
															<td class="td03">그룹입사일</td>
															<td class="td04"><%=(data.DAT02).equals("0000.00.00") ? "" : WebUtil.printDate(data.DAT02)%>&nbsp;</td>
															<td class="td03">입사구분</td>
															<td class="td04"><%=data.MGTXT%>&nbsp;</td>
														</tr>
														<tr>
															<td class="td03">직무</td>
															<td class="td04"><%=data.STLTX%>&nbsp;</td>
															<td class="td03">자사입사일</td>
															<td class="td04"><%=(data.DAT03).equals("0000.00.00") ? "" : WebUtil.printDate(data.DAT03)%>&nbsp;</td>
															<td class="td03">입사시학력</td>
															<td class="td04"><%=data.SLABS%>&nbsp;</td>
														</tr>
														<tr>
															<td class="td03">직책</td>
															<td class="td04"><%=data.TITL2%>&nbsp;</td>
															<td class="td03">현직위승진</td>
															<td class="td04"><%=(data.BEGDA).equals("0000.00.00") ? "" : WebUtil.printDate(data.BEGDA)%>&nbsp;</td>
															<td class="td03">근무지</td>
															<td class="td04"><%=data.BTEXT%>&nbsp;</td>
														</tr>
														<tr>
															<td class="td03">급호/년차</td>
															<td class="td04"><%=data.VGLST%>&nbsp;</td>
															<td class="td03">근속기준일</td>
															<td class="td04"><%=(data.DAT01).equals("0000.00.00") ? "" : WebUtil.printDate(data.DAT01)%>&nbsp;</td>
															<td class="td03">국적</td>
															<td class="td04"><%=data.LANDX%>&nbsp;</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td class="font01"><font color="#7897FC">■</font> 주소 및 신상</td>
								</tr>
								<tr>
									<td>
										<table width="730" border="1" cellspacing="1" cellpadding="3"
											class="table02">
											<tr>
												<td class="td03" width="80">현주소</td>
												<td colspan="4" class="td04" style="text-align: left">&nbsp;&nbsp;<%=data.STRAS1%></td>
												<td class="td03" width="80">우편번호</td>
												<td colspan="2" class="td04"><%=data.PSTLZ1%>&nbsp;</td>
											</tr>
											<tr>
												<td class="td03">본적</td>
												<td colspan="4" class="td04" style="text-align: left">&nbsp;&nbsp;<%=data.STRAS%></td>
												<td class="td03">우편번호</td>
												<td colspan="2" class="td04"><%=data.PSTLZ%>&nbsp;</td>
											</tr>
											<tr>
												<td class="td03" width="100">신장</td>
												<td class="td04" width="80"><%=data.NMF01.equals("") ? "" : WebUtil.printNum(data.NMF01) + " ㎝"%>&nbsp;</td>
												<td class="td03" width="100">체중</td>
												<td class="td04" width="80"><%=data.NMF02.equals("") ? "" : WebUtil.printNum(data.NMF02) + " ㎏"%>&nbsp;</td>
												<td class="td03" width="100">시력(좌)</td>
												<td class="td04" width="80"><%=data.NMF06.equals("") ? "" : WebUtil.printNumFormat(data.NMF06, 1)%>&nbsp;</td>
												<td class="td03" width="100">시력(우)</td>
												<td class="td04" width="90"><%=data.NMF07.equals("") ? "" : WebUtil.printNumFormat(data.NMF07, 1)%>&nbsp;</td>
											</tr>
											<tr>
												<td class="td03">색맹</td>
												<td class="td04"><%=data.FLAG.equals("N") ? "정상" : "비정상"%>&nbsp;</td>
												<td class="td03">혈액형</td>
												<td class="td04"><%=data.STEXT%>&nbsp;</td>
												<td class="td03">장애</td>
												<td class="td04"><%=data.FLAG1.equals("N") ? "" : data.FLAG1%>&nbsp;</td>
												<td class="td03">특기</td>
												<td class="td04"><%=data.HBBY_TEXT1%>&nbsp;</td>
											</tr>
											<tr>
												<td class="td03">혼인여부</td>
												<td class="td04"><%=data.FTEXT%>&nbsp;</td>
												<td class="td03">주거형태</td>
												<td class="td04"><%=data.LIVE_TEXT%>&nbsp;</td>
												<td class="td03">종교</td>
												<td class="td04"><%=data.KTEXT%>&nbsp;</td>
												<td class="td03">취미</td>
												<td class="td04"><%=data.HBBY_TEXT%>&nbsp;</td>
											</tr>
											<tr>
												<td class="td03">보훈대상</td>
												<td colspan="7" class="td04" style="text-align: left">&nbsp;&nbsp;<%=data.CONTX%>&nbsp;
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td class="font01"><font color="#7897FC">■</font> 병역사항</td>
								</tr>
								<tr>
									<td>
										<table width="730" border="0" cellspacing="1" cellpadding="3"
											class="table02">
											<tr>
												<td class="td03" width="80">실역구분</td>
												<td class="td04" width="120"><%=data.TRAN_TEXT%>&nbsp;</td>
												<td class="td03" width="80">면제사유</td>
												<td colspan="5" class="td04"><%=data.RSEXP%>&nbsp;</td>
											</tr>
											<tr>
												<td class="td03">군별</td>
												<td class="td04"><%=data.SERTX%>&nbsp;</td>
												<td class="td03">계급</td>
												<td class="td04" width="100"><%=data.RKTXT%>&nbsp;</td>
												<td class="td03" width="80">주특기</td>
												<td class="td04"><%=data.JBTXT%>&nbsp;</td>
												<td class="td03" width="80">근무부대</td>
												<td class="td04" width="110"><%=data.SERUT%>&nbsp;</td>
											</tr>
											<tr>
												<td class="td03">전역사유</td>
												<td class="td04"><%=data.RTEXT%>&nbsp;</td>
												<td class="td03">군번</td>
												<td colspan="2" class="td04"><%=data.IDNUM%>&nbsp;</td>
												<td class="td03" width="80">복무기간</td>
												<td colspan="2" class="td04"><%=data.PERIOD.equals("0000.00.00~0000.00.00") ? "" : data.PERIOD%>&nbsp;</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table> <!--개인인적사항 테이블 끝-->
			</td>
		</tr>
		<tr>
			<td width="15">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<div id="addListGrid"></div>
    <div id="detailsDialog">
        <form id="detailsForm">
            <div class="details-form-field">
                <label for="SUBTY">유형:</label>
                    <select id="SUBTY" name="SUBTY" class="input03" >  <!-- onChange="javascript:telinfo(this.value);" --> 
<%= WebUtil.printOption((new A13AddressTypeRFC()).getAddressType()) %>
                    </select>
            </div>
            <div class="details-form-field">
                <label for="STEXT">국가:</label>
                    <select id="LAND1" name="LAND1" class="input03">
<%= WebUtil.printOption((new A13AddressNationRFC()).getAddressNation()) %>
                    </select>
            </div>
            <div class="details-form-field">
                <label for="PSTLZ">우편번호:</label>
                <input id="PSTLZ" name="PSTLZ" type="text" />
            </div>
            <div class="details-form-field">
                <label for="STRAS">주소:</label>
                <input id="STRAS" name="STRAS" type="text" />
            </div>
            <div class="details-form-field">
                <label for="LOCAT">상세주소:</label>
                <input id="LOCAT" name="LOCAT" type="text" />
            </div>
            <div class="details-form-field">
                <label for="LIVE_TYPE">주거형태:</label>
                    <select id="LIVE_TYPE" name="LIVE_TYPE" class="input03">
                      <option value="10">------------</option>
<%= WebUtil.printOption((new A13AddressLiveTypeRFC()).getAddressLiveType()) %>
                    </select>
            </div>
            <div class="details-form-field">
                <label for="TELNR">전화번호:</label>
                <input id="TELNR" name="TELNR" type="text" />
            </div>
            <div class="details-form-field">
                <button type="submit" id="save">Save</button>
            </div>
			<input type="hidden" id="LANDX" name="LANDX"     value="">
			<input type="hidden" id="LIVE_TEXT" name="LIVE_TEXT" value="">
    		<input type="hidden" id="STEXT"  name="STEXT"     value="">
        </form>
    </div>
	<script type="text/javascript">
		$(function() {
			$("#addListGrid").jsGrid({
				width : "100%",
				height : "400px",
				sorting : true,
				autoload : true,
				paging : true,

                rowClick: function(args) {
                    showDetailsDialog("Edit", args.item);
                },
				controller : {
					loadData : function() {
						var d = $.Deferred();

						$.ajax({
							type : "GET",
							url : "/sample/empAddList.json",
							dataType : "json"
						}).done(function(response) {
							d.resolve(response.storeData);
						});

						return d.promise();
					}
				},

				fields : [ {
					title : "유형",
					name : "STEXT",
					type : "text"
				}, {
					title : "우편번호",
					name : "PSTLZ",
					type : "text"
				}, {
					title : "주소",
					name : "STRAS",
					type : "text"
				}, {
					title : "주거형태",
					name : "LIVE_TEXT",
					type : "text"
				}, {
					title : "전화번호",
					name : "TELNR",
					type : "text"
				} ]
			});

			$("#detailsDialog").dialog({
                autoOpen: false,
                width: 400,
                close: function() {
                    $("#detailsForm").validate().resetForm();
                    $("#detailsForm").find(".error").removeClass("error");
                }
            });

			$("#detailsForm").validate({
/* 
				rules: {
                    name: "required",
                    age: { required: true, range: [18, 150] },
                    address: { required: true, minlength: 10 },
                    country: "required"
                },
                messages: {
                    name: "Please enter name",
                    age: "Please enter valid age",
                    address: "Please enter address (more than 10 chars)",
                    country: "Please select country"
                },
 */
				rules: {
			    },
			    messages: {
			    },
                submitHandler: function() {
                    formSubmitHandler();
                }
            });

			var formSubmitHandler = $.noop;            
			var showDetailsDialog = function(dialogType, client) {
				$("#SUBTY").val(client.SUBTY);
				$("#LAND1").val(client.LAND1);
                $("#STEXT").val(client.STEXT);
                $("#PSTLZ").val(client.PSTLZ);
                $("#STRAS").val(client.STRAS);
                $("#LIVE_TYPE").val(client.LIVE_TYPE);
                $("#TELNR").val(client.TELNR);

                formSubmitHandler = function() {
                    saveClient(client, dialogType === "Add");
                };

                $("#detailsDialog").dialog("option", "title", dialogType + " Client")
                    .dialog("open");
            };

            var saveClient = function(client, isNew) {
    			$("#LANDX").val = $("#LAND1 option:selected").text();
    			$("#LIVE_TEXT").val =  $("#LIVE_TYPE option:selected").text();
    			$("#STEXT").val =  $("#SUBTY option:selected").text();
            	jQuery.ajax({
            		type : 'POST',
            		url : '/sample/updateAddr.json',
            		cache : false,
            		dataType : 'json',
            		data : $('#detailsForm').serialize(),
            		async :false,
            		error : function(a, b, g) {
            			//console.log('error : ' + b);
            		},
            		success : function(json) {
            		}
            	});
                $("#detailsDialog").dialog("close");
            };
		});
	</script>
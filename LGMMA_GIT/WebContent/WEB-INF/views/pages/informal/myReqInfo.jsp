<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.E.E27InfoDecision.*" %>    
<%@ page import="hris.E.E27InfoDecision.rfc.* "%>
<%
WebUserData user = (WebUserData)session.getValue("user");

String                s_date        = DataUtil.getCurrentDate();
Vector                app_vt  = new Vector();
E27InfoReqRFC         fun_req = new E27InfoReqRFC();

app_vt  = fun_req.getReqMsg( user.empNo, s_date );
String STATE = (String)app_vt.get(0);    //작업 결과 FLAG

%>
				<!--// Page Title start -->
				<div class="title">
					<h1>인포멀관리</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">Admin관리</a></span></li>
							<li><span><a href="#">인포멀관리</a></span></li>
							<li class="lastLocation"><span><a href="#">인포멀 간사결재</a></span></li>
						</ul>
					</div>
				</div>
				<!--// Page Title end -->
		
				<!--------------- layout body start --------------->
				<!--// Inquiry Table start -->
				<div class="tableInquiry">
					<table>
						<caption>인포멀 간사결재 조회</caption>
						<colgroup>
							<col class="col_9p" />
							<col class="col_21p" />
							<col class="col_10p" />
							<col class="col_21p" />
							<col class="col_10p" />
							<col class="col_29p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="inputText01-1">신청구분</label></th>
								<td>
									<select name="P_INFO_TYPE" class="wPer" id="P_INFO_TYPE">
										<option value="2" >전체</option>
					                    <option value="0" >가입</option>
					                    <option value="1" >탈퇴</option>
									</select>
								</td>
								<th><label for="inputText01-2">상태</label></th>
								<td>
									<select name="P_APPR_STAT" class="wPer" id="P_APPR_STAT">
				                      <option value="">전체</option>
				                        <option value="A" >승인</option>
					            	    <option value="B" >미승인</option>
				                    </select>
								</td>
								<th><label for="inputDateFrom">신청일</label></th>
								<td class="tdDate">
									<input id="inputDateFrom" name="P_BEGDA" type="text" value="<c:out value='${P_BEGDA}'/>" />
									~
									<input id="inputDateTo" name="P_ENDDA" type="text" value="<c:out value='${P_ENDDA}'/>" />
								</td>
							</tr>
						</tbody>
					</table>
					<div class="tableBtnSearch"><button type="submit" id="applSearchBtn"><span>조회</span></button></div>
					<div class="clear"> </div>
				</div>
				<!--// Inquiry Table end -->
				
				<div id="reqApplGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
				<div class="tableComment">
					<p><span class="bold">급여작업중에는 인포멀 간사결재를 하실 수 없습니다.</span></p>
				</div>
			
				<!-- popup : 인포몰 가입신청 정보 start -->
<div class="layerWrapper layerSizeS" id="popLayerInformal">
	<form id="informalDetailForm" name="informalDetailForm">
		<div class="layerHeader">
			<strong>인포멀 신청정보</strong>
			<a href="#" class="btnClose popLayerInformal_close">창닫기</a>
		</div>
		<div class="layerContainer">
			<div class="layerContent">
				<!--// Content start  -->
				<div class="tableArea tablePopup pb0">
					<div class="table">
						<table class="tableGeneral">
							<caption>인포멀 신청정보</caption>
							<colgroup>
								<col class="col_25p" />
								<col class="col_75p" />
							</colgroup>
							<tbody>
								<tr>
									<th>인포멀회</th>
									<td>
										<input class="readOnly" id="STEXT" name="STEXT" type="text" class="w150" readOnly/>
									</td>
								</tr>
								<tr>
									<th>신청구분</th>
									<td>
										<input class="readOnly" id="INFO_TEXT" name="INFO_TEXT" type="text" class="w150" readOnly/>
									</td>
								</tr>
								<tr>
									<th>신청일</th>
									<td>
										<input class="readOnly" id="BEGDA" name="BEGDA" type="text" class="w150" readOnly/>
									</td>
								</tr>
								<tr>
									<th>성명</th>
									<td>
										<input class="readOnly" id="ENAME" name="ENAME" type="text" class="w150" readOnly/>
									</td>
								</tr>
								<tr>
									<th>사번</th>
									<td>
										<input class="readOnly" id="PERNR" name="PERNR" type="text" class="w150" readOnly/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="APPRSTATCount" name="APPRSTATCount">
						<table class="tableGeneral">
							<caption>간사입력</caption>
							<colgroup>
								<col class="col_25p" />
								<col class="col_75p" />
							</colgroup>
							<tbody>
								<tr>
									<th>가입일</th>
									<td>
										<input type="text" name="to_date" id="inputDateDay" value=""  />
									</td>
								</tr>
								<tr>
									<th>회비</th>
									<td>
										<input class="inputMoney w120" type="text" name="BETRG" id="BETRG" value=""> 원
									</td>
								</tr>
							</tbody>
						</table>
						<div class="tableComment">
							<p><span class="bold">※ 회비는 가입월부터 급여공제 됩니다.</span></p>
						</div>
						<div class="buttonArea">
							<ul class="btn_crud">
								<li><a class="" id="requestInformalBtn" href="#"><span>신청</span></a></li>
							</ul>
						</div>
					</div>
				</div>
				<!--// Content end  -->
			</div>		
		</div>
		<INPUT TYPE="hidden" id="AINF_SEQN"   name="AINF_SEQN"   value="">
		<INPUT TYPE="hidden" id="MGART"       name="MGART"       value="">
		<INPUT TYPE="hidden" id="INFO_TYPE"   name="INFO_TYPE"   value="">
		<INPUT TYPE="hidden" id="APPR_STAT"   name="APPR_STAT"   value="">
		<INPUT TYPE="hidden" id="APPR_TEXT"   name="APPR_TEXT"   value="">
		<INPUT TYPE="hidden" id="APPL_DATE"   name="APPL_DATE"   value="">
		<INPUT TYPE="hidden" id="P_INFO_TYPE" name="P_INFO_TYPE" value="">
		<INPUT TYPE="hidden" id="P_PERNR"     name="P_PERNR"     value="">
		<INPUT TYPE="hidden" id="P_BEGDA"     name="P_BEGDA"     value="">
		<INPUT TYPE="hidden" id="P_ENDDA"     name="P_ENDDA"     value="">
	</form>
</div>
<!-- //popup: 동거인 인포몰 가입신청 정보  end -->
	<script>
	
	$("#applSearchBtn").click(function(){
    	$("#reqApplGrid").jsGrid("search");
    });
	$("#requestInformalBtn").click(function(){
		requestInformalBtn();
    });
	
        $(function() {
        	if(listCheckData()){
	            $("#reqApplGrid").jsGrid({
	                height: "auto",
	                width: "100%",
	                sorting: true,
	                paging: true,
	                pageSize: 10,
	                pageButtonCount: 10,
	                autoload: true,
	    			controller : {
	    				loadData : function() {
	       					var d = $.Deferred();
	       					$.ajax({
	       						type : "get",
	       						url : "/informal/getInformalList.json",
	       						dataType : "json",
	       						data : { 
	       							 "P_BEGDA" : $('input[name="P_BEGDA"]').val()
	       							,"P_ENDDA" : $('input[name="P_ENDDA"]').val()
	       							,"P_INFO_TYPE" : $("#P_INFO_TYPE option:selected").val()
	       							,"P_APPR_STAT" : $("#P_APPR_STAT option:selected").val()
	       						}
	      					}).done(function(response) {
	       						if(response.success)
	       							d.resolve(response.storeData);
	       		    			else
	       		    				alert("조회시 오류가 발생하였습니다. " + response.message);
	       					});
	       					return d.promise();
	       				}
	       			},
	                fields: [
	                    	{
	                       	title: "선택",
	                       	name: "AINF_SEQN",
	       					itemTemplate: function(__, item) {
	       						return $("<input name='AINF_SEQN'>")
	       								.attr("type", "radio")
	       								.on("click",function(e){
	       									showApplDetailView(item);
	       								});
	       					},
	       					sorting: false,
	                           align: "center",
	                           width: "8%"
	                       },
	                	{ title: "인포멀회", name: "STEXT", type: "text", align: "center", width: "28%" },
	                	{ title: "신청구분", name: "INFO_TEXT", type: "text", align: "center", width: "14%" },
	                    { title: "신청일", name: "BEGDA", type: "text", align: "center", width: "11%" },
	                    { title: "성명", name: "ENAME", type: "text", align: "center", width: "11%" },
	                    { title: "사번", name: "PERNR", type: "text", align: "center", width: "13%" },
	                    { title: "상태", name: "APPR_STAT", type: "text", align: "center", width: "28%",
	                            itemTemplate: function(value, item) {
	                                switch (value) {
	                                 case "A" :
	                                 	return "<img src='/web-resource/images/ico/ico_condition3.png' alt='가입'>";
	                                 break;
	                                 default :
	                                 	return "<img src='/web-resource/images/ico/ico_condition1.png' alt='탈퇴'>";
								}
							}
	                    },
	                    { name: "BEGDA", type: "text", visible: false },
	                    { name: "ENDDA", type: "text", visible: false },
	                    { name: "AINF_SEQN", type: "text", visible: false },
	                    { name: "MGART", type: "text", visible: false },
	                    { name: "APPR_STAT", type: "text", visible: false },
	                    { name: "INFO_TYPE", type: "text", visible: false },
	                    { name: "BETRG", type: "text", visible: false }
	                ]
	            });
        	};
        });
        
    	var listCheckData = function(){
    		var begin_date = removePoint($('input[name="P_BEGDA"]').val());
    		var retireDate = removePoint($('input[name="P_ENDDA"]').val());
    		dif = dayDiff(addSlash(begin_date), addSlash(retireDate));
    		if( dif < 0 ) {
    			alert("신청일의 범위가 올바르지 않습니다.");
    			return false;
    		}
    		return true;
    	}
        
        var showApplDetailView =function(item){
        	$("#informalDetailForm").each(function() {
				this.reset();
			});
        	jQuery.ajax({
        		type : 'POST',
        		url : '/informal/getInformalDetail.json',
        		cache : false,
        		dataType : 'json',
        		data : {
        			"P_BEGDA" : item.BEGDA,
        		    "P_ENDDA" : item.ENDDA,
        		    "AINF_SEQN" : item.AINF_SEQN,
        		    "MGART" : item.MGART,
        		    "APPR_STAT" : item.APPR_STAT,
        		    "INFO_TYPE" : item.INFO_TYPE,
        		    "INFO_TEXT" : item.INFO_TEXT,
        		    "STEXT" : item.STEXT,
        		    "BEGDA" : item.BEGDA,
        		    "PERNR" : item.PERNR,
        		    "ENAME" : item.ENAME,
        		    "BETRG" : item.BETRG
        		},
        		async :false,
        		success : function(response) {
        			if(response.success){
        				var storeData = response.storeData;
        				$("#informalDetailForm #AINF_SEQN").val(storeData.AINF_SEQN);
        				$("#informalDetailForm #MGART").val(storeData.MGART);
        				$("#informalDetailForm #STEXT").val(storeData.STEXT);
        				$("#informalDetailForm #INFO_TYPE").val(storeData.INFO_TYPE);
        				$("#informalDetailForm #INFO_TEXT").val(storeData.INFO_TEXT);
        				$("#informalDetailForm #BEGDA").val(storeData.BEGDA.substring(0,4) + "." +storeData.BEGDA.substring(4,6) + "." +storeData.BEGDA.substring(6,8));
        				$("#informalDetailForm #ENAME").val(storeData.ENAME);
        				$("#informalDetailForm #PERNR").val(storeData.PERNR.substring(4));
        				$("#informalDetailForm #APPR_STAT").val(storeData.APPR_STAT);
        				$("#informalDetailForm #APPR_TEXT").val(storeData.APPR_TEXT);
        				$("#informalDetailForm #APPL_DATE").val(storeData.APPL_DATE);
        				var key = response.key;
        				$("#informalDetailForm #P_INFO_TYPE").val(key.P_INFO_TYPE);
        				$("#informalDetailForm #P_PERNR").val(key.P_PERNR);
        				$("#informalDetailForm #P_BEGDA").val(key.P_BEGDA);
        				$("#informalDetailForm #P_ENDDA").val(key.P_ENDDA);
        				$('#popLayerInformal').popup('show');
        				if(storeData.APPR_STAT==null || storeData.APPR_STAT==""){
        					$("#APPRSTATCount").show();
        				}else{
        					$("#APPRSTATCount").hide();
        				}
        			}else{
        				alert("급여 작업중에는 결재 하실수 없습니다." + response.message);
        			}
        		}
        	});
        }
        
        var requestInformalBtn = function(){
        	if(detailCheckData()){
        		if(confirm("신청 하시겠습니까?")){
        			jQuery.ajax({
        				type : 'POST',
        				url : '/informal/requestInformal.json',
        				cache : false,
        				dataType : 'json',
        				data : $('#informalDetailForm').serialize(),
        				async :false,
        				success : function(response) {
        		  			if(response.success){
        		  				alert("신청 되었습니다.");
        		  				$("#informalDetailForm").each(function() {
        	    					this.reset();
        	    				});
        		  				$("#informalDetailForm").hide();
        		  			}else{
        		  				alert("신청시 오류가 발생하였습니다. " + response.message);
        		  			}
        		  			$('#popLayerInformal').popup('hide');
        		  			$("#reqApplGrid").jsGrid("search");
        		  		}
        			});
        		};
        	}
        };
        
    	var detailCheckData = function(){
<%
			if( STATE.equals("1") ) {         //1   급여릴리즈 상태일경우만 막아준다.
%>
				alert("급여 작업중에는 결재를 하실 수 없습니다.");
			return false;
<%
			}
%>
			  if($('input[name="to_date"]').val() == null || $('input[name="to_date"]').val() == "") {
			    alert("가입일을 입력해주세요");
			    $('input[name="to_date"]').focus();
			    return false;
			//급여가 끝난시점의 경우 다음월을 결재일로 입력하도록 메시지를 보여준다. -> 급여마감이므로 다음월부터 공제되도록..
			  } else {
			    var DATE =$('input[name="to_date"]').val();
			    if( "<%= DataUtil.getCurrentMonth() %>" == DATE.substring(5, 7) 
			                                          && DATE.substring(8, 10) >= 22 && DATE.substring(8, 10) <=31 ) {
			    alert("해당월에 급여작업이 끝났습니다. 가입일을 다음월로 변경해주세요.");
			    return;
			  }
			}
			
			if($("#informalDetailForm #BETRG").val() == null || $("#informalDetailForm #BETRG").val() == "") {
			  alert("회비를 입력해주세요");
			  $("#informalDetailForm #BETRG").focus();
			  return false;
			} 
			  
			if($("#informalDetailForm #BETRG").val() > 100000) {
			  alert("회비는 100,000원 이내로 입력하여주십시요");
			  return false;
			}  
    		return true;
    	}
    </script>
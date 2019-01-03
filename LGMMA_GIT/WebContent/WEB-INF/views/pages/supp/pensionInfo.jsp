<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="hris.E.E04Pension.rfc.E04PensionChngGradeRFC"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="hris.E.E29PensionDetail.E29PensionDetailData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	WebUserData user   = (WebUserData)session.getValue("user");
    E29PensionDetailData data = (E29PensionDetailData)request.getAttribute("E29PensionDetailData");
    DataUtil.fixNull(data);
	int                  year                =    Integer.parseInt((String)request.getAttribute("year"));     
    int                  startYear           = Integer.parseInt( (user.e_dat03).substring(0,4) );
    int                  endYear             = Integer.parseInt( DataUtil.getCurrentYear() );

    if( startYear < 2003 ){
        startYear = 2003;
    }

    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }
%>
				<!--// Page Title start -->
				<div class="title">
					<h1>국민연금</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">복리후생</a></span></li>
							<li class="lastLocation"><span><a href="#">국민연금</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->	
				
				<!--------------- layout body start --------------->				
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" onclick="switchTabs(this, 'tab1');" class="selected">국민연금 자격변경 신청</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab2');">국민연금내역</a></li>
					</ul>
				</div>
				<!--// Tab end -->
				
				<!--// Tab1 start -->
				<div class="tabUnder tab1">	
					<!--// Table start -->	
					<div class="tableArea">
					<form name="reqChangeForm" id="reqChangeForm" method="post" action="">
						<input type="hidden" name="CHNG_TEXT" value="">
						<h2 class="subtitle">국민연금 자격변경 신청</h2>
						<div class="table">
							<table class="tableGeneral">
							<caption>국민연금 자격변경 신청</caption>
							<colgroup>
								<col class="col_15p"/>
								<col class="col_35p"/>
								<col class="col_15p"/>
								<col class="col_35p"/>
							</colgroup>
							<tbody>
							<tr>
								<th><label for="inputText01-1">신청일</label></th>
								<td colspan="3" class="tdDate">
									<input class="readOnly" type="text" name="BEGDA" id="BEGDA" value='<%= WebUtil.printDate(DataUtil.getCurrentDate(),".") %>' readonly />
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputText01-2">변경항목</label></th>
								<td colspan="3">
									<select id="CHNG_TYPE" name="CHNG_TYPE"> 
										<option>-------선택-------</option>
										<%= WebUtil.printOption((new E04PensionChngGradeRFC()).getPensionChngGrade()) %>
									</select> 
								</td>
							</tr>
							<tr>
								<th><span class="textPink">*</span><label for="inputText01-3">변경전Data</label></th>
								<td>
									<input class="w150" type="text" name="CHNG_BEFORE" id="CHNG_BEFORE" />                              
                                </td>
                                <th><span class="textPink">*</span><label for="inputText01-4">변경후Data</label></th>
								<td>
									<input class="w150" type="text" name="CHNG_AFTER" id="CHNG_AFTER" />                           
                                </td>
                            </tr>				
							</tbody>
							</table>
						</div>
					</div>	
					</form>		
					<!--// Table end -->					
					<!--// list start -->
					<div class="listArea" id="decisioner">	
					</div>	
					<!--// list end -->					
					<div class="buttonArea">
						<ul class="btn_crud">
							<li><a class="darken" href="#" id="reqChangeBtn"><span>신청</span></a></li>
						</ul>
					</div>
				</div>
				<!--// Tab1 end -->
				
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">
<%
    if( data.E_LNMHG.equals("") && data.E_FNMHG.equals("") ) {
%>
				<div class="errorArea">
					<div class="errorMsg">	
						<div class="errorImg"><!-- 에러이미지 --></div>					
						<div class="alertContent">
							<p>해당하는 데이터가 존재하지 않습니다.</p>
						</div>
					</div>
				</div>
<%
    } else {
%>          
					<!--// list start -->
					<div class="listArea">	
						<h2 class="subtitle">기본정보</h2>	
						<div class="clear"> </div>
						<div class="table">
							<table class="listTable borderBottom">
							<caption>기본정보</caption>
							<colgroup>
								<col class="col_25p"/>
								<col class="col_25p"/>
								<col class="col_25p"/>
								<col class="col_25p"/>
							</colgroup>
							<thead>
							<tr>
								<th class="thAlignCenter">성명</th>
								<th class="thAlignCenter">주민번호</th>
								<th class="thAlignCenter">현재등급</th>
								<th class="thAlignCenter tdBorder">가입일</th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<td><%=data.E_LNMHG%><%=data.E_FNMHG%></td>     
								<td><%=DataUtil.addSeparate(data.E_REGNO)%></td>
								<td><%=WebUtil.printNum(data.E_GRADE)%>등급</td>
								<td><%=WebUtil.printDate(data.E_BEGDA)%></td>   
							</tr>
							</tbody>
							</table>
						</div>		
					</div>	
					<!--// list end -->
					<!--// table start -->
					<div class="tableArea">
						<h2 class="subtitle">총누계내역</h2>
						<div class="table">
							<table class="tableGeneral">
								<caption>총누계내역</caption>
								<colgroup>
									<col class="col_15p" />
									<col class="col_35p" />
									<col class="col_15p" />
									<col class="col_35p" />
								</colgroup>
								<tbody>
								<tr>
									<th>본인부담금</th>
									<td class="alignRight"><%=WebUtil.printNumFormat(data.E_MY_PAYMENT)%></td>
									<th>퇴직전환금</th>
									<td class="alignRight"><%=WebUtil.printNumFormat(data.E_RETIRE_PAYMENT)%></td>
								</tr>
								<tr>
									<th>회사부담금</th>
									<td class="alignRight"><%=WebUtil.printNumFormat(data.E_FIRM_PAYMENT)%></td>
									<th>총불입금액</th>
									<td class="alignRight"><%=WebUtil.printNumFormat(data.E_TOTAL_PAYMENT)%></td>
								</tr>
								</tbody>
							</table>
						</div>
					</div>	
					<!--// table end -->
					<!--// table start -->
					<div class="tableArea">
						<h2 class="subtitle">퇴직전환금</h2>
						<div class="table">
							<table class="tableGeneral">
								<caption>퇴직전환금</caption>
								<colgroup>
									<col class="col_15p" />
									<col class="col_35p" />
									<col class="col_15p" />
									<col class="col_35p" />
								</colgroup>
								<tbody>
								<tr>
									<th>본인부담금</th>
									<td class="alignRight"><%=WebUtil.printNumFormat(data.E_PENI_AMNT)%></td>
									<th>퇴직전환금 회사부담금</th>
									<td class="alignRight"><%=WebUtil.printNumFormat(data.E_PENC_AMNT)%></td>
								</tr>
								<tr>
									<th>퇴직전환금(전근무지)</th>
									<td class="alignRight"><%=WebUtil.printNumFormat(data.E_PENB_AMNT)%></td>
									<th></th>
									<td></td>
								</tr>
								</tbody>
							</table>
						</div>
					</div>	
					<!--// table end -->
					<!--// list start -->
					<div class="listArea">	
						<h2 class="subtitle">년도별 상세내역</h2>
						<div class="floatRight">
							<select class="w60" id="selectedYear">							
							<%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%>
							</select>
						</div>
						<div class="clear"> </div>
						<div id="pensionListGrid"></div>								
					</div>	
					<!--// list end -->
<%
    }
%>          
				</div>
				<!--// Tab2 end -->	
				<!--------------- layout body end --------------->						
	<script>
        $(function() {
        	$('#decisioner').load('/common/getDecisionerGrid?upmuType=22&gridDivId=decisionerGrid');

        	$("#selectedYear").change(function() {
        		$("#pensionListGrid").jsGrid("search");
        	});
            $("#pensionListGrid").jsGrid({
                height: "auto",
                width: "100%",
                autoload: true,
                rowClass: function(item, itemIndex) {
                	if($("#pensionListGrid").jsGrid("option", "data").length == itemIndex+1) {
                		return "jsTotal";                		
                	}
               	},
				controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "GET",
							url : "/supp/getYearPensionList.json",
							dataType : "json",
							data :{"YEAR" : $("#selectedYear option:selected").val()},
						}).done(function(response) {
							if(response.success) {
								d.resolve(response.storeData);
							}
			    			else
			    				alert("조회시 오류가 발생하였습니다. " + response.message);
						});
						return d.promise();
					}
				},
                fields: [
                	{ title: "월", name: "PAYDT", type: "text", align: "center", width: 25 },
                    { title: "등급", name: "GRADE", type: "text", align: "center", width: 25 },
                    { title: "본인부담금", name: "BETRG", type: "text", align: "right", width: 25,
		                itemTemplate: function(value) {
		                    return value.format();
						}
                    },
                    { title: "회사부담금", name: "BETRG", type: "text", align: "right", width: 25,
		                itemTemplate: function(value) {
		                    return value.format();
						}
                    }
                ]
            });

    		//action start
    		$("#reqChangeBtn").click(function(){
    			if(checkReqChangeFormValid()) {
    				if(confirm("신청하시겠습니까?")) {
    					$("#reqChangeBtn").prop("disabled", true);
    					var param = $("#reqChangeForm").serializeArray();
    					$("#decisionerGrid").jsGrid("serialize", param);
    					jQuery.ajax({
    		        		type : 'POST',
    		        		url : '/supp/requestPensionChange',
    		        		cache : false,
    		        		dataType : 'json',
    		        		data : param,
    		        		async : false,
    		        		success : function(response) {
    		        			if(response.success) {
    		        				alert("신청되었습니다.");
    								$("#reqChangeForm").each(function() {  
    									this.reset();
    									$("#mateGrid").jsGrid({data: []});
    								});  
    		        			} else {
    		        				alert("신청시 오류가 발생하였습니다. " + response.message);
    		        			}
    							$("#reqChangeBtn").prop("disabled", false);
    		        		}
    		        	});
    				}
    			}
    		});
    		var checkReqChangeFormValid = function() {
   				if($("#reqChangeForm #CHNG_TYPE").prop("selectedIndex")==0){
    				alert("변경항목을 선택하세요");
    				$("#reqChangeForm #CHNG_TYPE").focus();
    				return false;
   				}
    			if($("#reqChangeForm #CHNG_BEFORE").val() == "") {
    				alert("변경전 Data를 입력하세요 ");
    				$("#reqChangeForm #CHNG_BEFORE").focus();
    				return false;
   				}
    			if($("#reqChangeForm #CHNG_AFTER").val() == "") {
    				alert("변경후 Data를 입력하세요 ");
    				$("#reqChangeForm #CHNG_AFTER").focus();
    				return false;
   				}
				if($("#CHNG_TYPE option:selected").val() == "02"){
					if(!chkResnoObj_1(document.reqChangeForm.CHNG_BEFORE)){
	    				return false;
					}
				}
				if($("#CHNG_TYPE option:selected").val() == "02"){
					if(!chkResnoObj_1(document.reqChangeForm.CHNG_AFTER)) {
	    				return false;
					}
				}
				return true;
    		}
		});
    </script>

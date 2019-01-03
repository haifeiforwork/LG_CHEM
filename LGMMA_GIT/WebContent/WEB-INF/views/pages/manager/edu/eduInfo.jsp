<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.C.rfc.*"%>
<%@ page import="hris.C.C09Educ.rfc.C09EducRFC"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<!--// Page Title start -->
<div class="title">
	<h1>교육</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">My Info</a></span></li>
			<li><span><a href="#">교육</a></span></li>
			<li class="lastLocation"><span><a href="#">교육</a></span></li>
		</ul>
	</div>
</div>
<!--// Page Title end -->
<!--------------- layout body start --------------->
<!--// Tab5 start -->
<div class="tabUnder Tab5">
	<!--// list start -->
	<div class="listArea">
		<h2 class="subtitle withButtons">교육이수현황</h2>
		<div class="floatRight colorBlue">※ Y : 이수, M : 미이수, N : 불참</div>
		<div class="clear"> </div>
		<div id="finishedGrid" class="jsGridPaging"></div>
	</div>
	<!--// list end -->
</div>
<!--// Tab5 end -->

<script type="text/javascript">

	$(document).ready(function(){
		$("#tab1").click(function(){
			$("#EDUC_YEAR").val("").prop("disabled", false);
			$("#CATA_CODE").val("").prop("disabled", false);
			$("#COUR_CODE").val("").prop("disabled", false);

			// 초기화
			CHANGE_CODE();

			$("#ORGA_NAME").val("");
			$("#CATA_NAME").val("");
			
			$("#decisionerGrid").jsGrid("search");
			$("#curriculumGrid").jsGrid({"data":$.noop});
			
			$("#requestOnLineBtn").show();
			$("#changeOnLineBtn").hide();
			
		});
		$("#tab2").click(function(){
			// 초기화
			$("#eduRequestOffLineForm").each(function() {
				this.reset();
			});
			
			$("#requestOffLineEducYear").prop("disabled", false);
			$("#requestOffLineCataCode").prop("disabled", false);
			
			$("#requestOffLineBtn").show();
			$("#changeOffLineBtn").hide();
		});
		$("#tab3").click(function(){
			$("#changeOnLineGrid").jsGrid("search");
		});
		$("#tab4").click(function(){
			$("#changeOffLineGrid").jsGrid("search");
		});
		$("#Tab5").click(function(){
			$("#finishedGrid").jsGrid("search");
		});
		
		$("#changeOnLineBtn").hide();
		
		if($(".layerWrapper").length){
			// 결재자 팝업
			$('#popLayerAppl').popup();
		};
		//  년도 select box 변경
		$("#EDUC_YEAR").change(function(){
			CHANGE_CODE();
			$("#curriculumGrid").jsGrid("search");
		});
		
		// 교육뷴야 select box 변경
		$("#CATA_CODE").change(function(){
			CHANGE_CODE();
			$("#applPopupGrid").jsGrid("search");
		});
		
		// 교육과정 select box 변경
		$("#COUR_CODE").change(function(){
			$("#curriculumGrid").jsGrid("search");
		});
		
		// 결재자 조회 popup 검색
		$("#applPopupSearchbtn").click(function(){
			$("#applPopupGrid").jsGrid("search");
		});
		
		// OnLine 교육신청 버튼
		$("#requestOnLineBtn").click(function(){
			requestOnLine();
		});
		
		// OnLine 교육 변경 신청 버튼
		$("#changeOnLineBtn").click(function(){
			changeOnLine();
		});
		
		// OffLine 교육신청 버튼
		$("#requestOffLineBtn").click(function(){
			requestOffLine();
		});
		
		// OffLine 교육신청 변경 버튼
		$("#changeOffLineBtn").click(function(){
			changeOffLine();
		});
		
		// OnLine 교육신청 수정
		$("#changeOnLineFormBtn").click(function(){
			if( !$("input:radio[name='onLineRadio']").is(":checked")) {
				alert("교육변경 신청 대상을 선택하세요.");
				return false;
			}
			
			$("#requestOnLineBtn").hide();
			$("#changeOnLineBtn").show();
			// 탭전환
			selectEduChageValue();
		});
		
		// OffLine 교육신청 수정
		$("#changeOffLineFormBtn").click(function(){
			if( !$("input:radio[name='offLineRadio']").is(":checked")) {
				alert("교육변경 신청 대상을 선택하세요.");
				return false;
			}
			
			$("#requestOffLineBtn").hide();
			$("#changeOffLineBtn").show();
			// 탭전환
			switchTabs($("#tab2"), 'tab2');
		});
		
	});
	
	// onChange CategoryCode
	var CHANGE_CODE = function() {
		$("#COUR_CODE").lenth = 1;
		$("#COUR_CODE").val("");
		
		$("#GUBUN").val("4");
		$("#ORGA_CODE_1").val($("#ORGA_CODE").val());
		$("#CATA_CODE_1").val($("#CATA_CODE").val());
		$("#EDUC_YEAR_1").val($("#EDUC_YEAR").val());
		$("#COUR_CODE_1").val($("#COUR_CODE").val());
		
		getCategoryCode();
		
		if( $('#EDUC_YEAR').val() != "" && $('#ORGA_CODE').val() != "" && $('#CATA_CODE').val() != "" ) {
			$("#TDLINE_TEXT").text("");
			$("#curriculumGrid").jsGrid("search");
		}
	};
	
	//교육차수에 대한 데이터 가져오기
	var getCategoryCode = function() {
		jQuery.ajax({
			type : "POST",
			url : "/manager/edu/getCategoryList.json",
			cache : false,
			dataType : "json",
		data : {
				 "ORGA_CODE" : "2000"
				,"CATA_CODE" : $("#CATA_CODE_1").val()
				,"EDUC_YEAR" : $("#EDUC_YEAR_1").val()
				,"COUR_CODE" : $("#COUR_CODE_1").val()
				,"GUBUN" : "4"
			},
			async :false,
			success : function(response) {
				if(response.success){
					setCategoryOption(response.storeData)
				}
				else{
					alert("급여사유 조회시 오류가 발생하였습니다. " + response.message);
				}
		}
		});
	};
	
	// 교육과정 옵션 설정
	var setCategoryOption = function(jsonData) {
		$('#COUR_CODE').empty();
		$.each(jsonData, function (key, value) {
			$('#COUR_CODE').append('<option value=' + value.code + '>' + value.value + '</option>');
		});
	}
	
	// 교육과정 상세정보
	$(function() {
		$("#curriculumGrid").jsGrid({
			height: "auto",
			width: "100%",
			sorting: true,
			paging: false,
			autoload: false,
			controller : {
				loadData : function() {
					var d = $.Deferred();
					$.ajax({
						type : "GET",
						url : "/manager/edu/getCurriculumList.json",
						dataType : "json",
						data :  {
							   "ORGA_CODE" : $("#ORGA_CODE").val()
							  ,"CATA_CODE" : $("#CATA_CODE").val()
							  ,"EDUC_YEAR" : $("#EDUC_YEAR").val()
							  ,"COUR_CODE" : $("#COUR_CODE").val()
							  ,"GUBUN"     : "5"
						}
					}).done(function(response) {
						if(response.success){
							d.resolve(response.storeData[0]);
							setTextareaChange(response.storeData[1]);
						}
		    			else{
		    				alert("조회시 오류가 발생하였습니다. " + response.message);
		    			}
					});
					return d.promise();
				}
			},
            fields: [
                { title: "선택", name: "th1", align: "center", width: "5%",
                	itemTemplate: function(_, item) {
                        return $("<input name='courRadio'>")
                        	   .attr("type", "radio")
                        	   .on("click", function(e) {
                        		   $("#COUR_SCHE").val(item.COUR_SCHE);
                        		   $("#EDUC_BEGD").val(item.EDUC_BEGD);
                        		   $("#EDUC_ENDD").val(item.EDUC_ENDD);
                        		   $("#EDUC_COST").val(item.EDUC_COST);
                        		   $("#EDUC_TIME").val(item.EDUC_TIME);
                        		   $("#APPR_MARK").val(item.APPR_MARK);
                        		   $("#PASS_FLAG").val(item.PASS_FLAG);
                        		   $("#ESSE_FLAG").val(item.ESSE_FLAG);
                        		   $("#EMPL_FLAG").val(item.EMPL_FLAG);
                        		   $("#SEMI_FLAG").val(item.SEMI_FLAG);
                        	   });
                    }
                },
                { title: "차수", name: "COUR_SCHE", type: "text", align: "center", width: "15%" },
                { title: "교육기간", name: "EDUC_BEGD", type: "text", align: "center", width: "21%",
                	itemTemplate: function(value, storeData) {
                        return storeData.EDUC_BEGD + " ~ " + storeData.EDUC_ENDD;
                    }
                },
                { title: "교육비", name: "EDUC_COST", type: "number", align: "center", width: "16%",
                	itemTemplate: function(value, storeData) {
                        return value.format();
                    }
                },
                { title: "교육시간", name: "EDUC_TIME", type: "number", align: "center", width: "16%",
                	itemTemplate: function(value, storeData) {
                        return value.format();
                    }
                },
                { title: "필수여부",name: "ESSE_FLAG", align: "center", width: "8%",
                	itemTemplate: function(value, item) {
                        if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
                    }
                },
                { title: "고용보험", name: "EMPL_FLAG", align: "center", width: "8%",
                    itemTemplate: function(value, item) {
                    	if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
                    }
                },
                { title: "세미나과정", name: "SEMI_FLAG", align: "center", width: "8%",
                    itemTemplate: function(value, item) {
                    	if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
                    }
                }
            ]
        });
    });
	
	// 교육과정 상세 정보 변경
	var setTextareaChange= function(storeData) {
		$.each(storeData, function (key, value) {
			$("#TDLINE_TEXT").append(value.TDLINE + "<br>");
        });
	};
	
	// 결재정보 Grid
	$(function() {
   		$("#decisionerGrid").jsGrid({
   			height: "auto",
   			width: "100%",
   			sorting: true,
   			paging: false,
   			autoload: true,
   			rowClick: function(args){
   				$("#clickRow").val(args.itemIndex);
   			},
   			onDataLoaded: function(args) {
   				$("#RowCount").val(this.option("data").length);
   			},
   			controller : {
   				loadData : function() {
   					var d = $.Deferred();
   					var upmuType = "83";
   					
   					$.ajax({
   						type : "GET",
   						url : "/common/getDecisionerList.json",
   						dataType : "json",
   					    data: {upmuType:upmuType}
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
   		         { title: "결제자 구분", name: "APPL_APPU_NAME", type: "text", align: "center", width: "20%" },
   		         { title: "성 명(*)", name: "APPL_ENAME", type: "text", align: "center", width: "20%",
   		        	itemTemplate: function(value, storeData) {
   		        		if(storeData.APPL_APPU_TYPE=="01")
                        	return $("<input class='jsInputSearch readOnly' disabled=true>")
                        	       .attr({
                        	    	   type:"text"
                       	    	   })
                        	       .val(value)
                        	       .add(
                        	    		$("<img>")
                       	    		    .attr({
                       	    			   src:"/web-resource/images/ico/ico_magnify.png",
                       	    			   alt:'검색'
                     	    			})
                       	    		    .on("click", function(e) {
                       	    		    	$("#objid").val(storeData.APPL_OBJID);
                       	    		    	showPopLayerAppl(storeData);
                       	    		    })
                      	    	   );
   		        		else
   		        			return value;
                    }
   		         },
   		         { title: "부서명", name: "APPL_ORGTX", type: "text", align: "center", width: "20%" },
   		         { title: "직 책", name: "APPL_TITL2", type: "text", align: "center", width: "20%" },
   		         { title: "연락처", name: "APPL_TELNUMBER", type: "number", align: "center", width: "20%" },
   		         
				 { name: "APPL_UPMU_FLAG", type: "text", visible: false },
				 { name: "APPL_APPU_TYPE", type: "text", visible: false },
				 { name: "APPL_APPR_TYPE", type: "text", visible: false },
				 { name: "APPL_APPR_SEQN", type: "text", visible: false },
				 { name: "APPL_PERNR", type: "text", visible: false },
				 { name: "APPL_OTYPE", type: "text", visible: false },
				 { name: "APPL_OBJID", type: "text", visible: false },
				 { name: "APPL_STEXT", type: "text", visible: false },
				 { name: "APPL_PERNR", type: "text", visible: false },
				 { name: "APPL_APPU_NUMB", type: "text", visible: false },
				 { name: "APPL_TITEL", type: "text", visible: false }
   		         
   			]
   		});
   	});

	// 결재자 변경
	var showPopLayerAppl = function(item) {
		$("#popLayerForm").each(function() {
			this.reset();
		});
		$("#applPopupGrid").jsGrid({"data":$.noop}); //초기화 방안 재확인 필요
		
		$("#popLayerAppl").popup('show');
		$("#applPopupGrid").jsGrid({
			controller : {
				loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "get",
   						url : "/common/searchDecisionerList.json",
   						dataType : "json",
   						data : { 
   							 "I_ENAME" : $("#I_ENAME").val()
   							,"I_ENAME1" : $("#I_ENAME1").val()
   							,"objid" : item.APPL_OBJID
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
   			rowClick : function(args){
            	var newItem = {
					"APPL_PERNR": args.item.PERNR,
					"APPL_APPU_NUMB": args.item.APPU_NUMB,
					"APPL_APPU_NAME": args.item.APPU_NAME,
					"APPL_ENAME": args.item.ENAME,
					"APPL_ORGTX": args.item.ORGTX,
					"APPL_TITEL": args.item.TITEL,
					"APPL_TITL2": args.item.TITL2,
					"APPL_TELNUMBER": args.item.TELNUMBER
				};
            	$("#decisionerGrid").jsGrid("updateItem", item, newItem).done(function() {
                    $("#popLayerAppl").popup('hide');
				});
				
				//var kkk = $("#decisionerGrid").jsGrid("option", "data");
				
				//kkk[$("#clickRow").val()].APPL_APPU_NAME = args.item.APPU_NAME;
				//kkk[$("#clickRow").val()].APPL_ENAME = args.item.ENAME;
				//kkk[$("#clickRow").val()].APPL_ORGTX = args.item.ORGTX;
				//kkk[$("#clickRow").val()].APPL_TITL2 = args.item.TITL2;
				//kkk[$("#clickRow").val()].APPL_TELNUMBER = args.item.TELNUMBER;
				//kkk[$("#clickRow").val()].APPL_OBJID = args.item.OBJID;
				
				//$("#decisionerGrid").jsGrid({"data" : kkk });
            }
		});
	};
	
	// 결재자 검색 grid
	$(function() {
        $("#applPopupGrid").jsGrid({
        	height: "auto",
   			width: "100%",
   			sorting: true,
   			paging: false,
            autoload: false,
            fields: [
                {
                	title: "선택", align: "center", width: "8%",
                    itemTemplate: function(_, item) {
                        return $("<input>").attr("type", "radio");
                    }
                },
                { title: "사번",  name: "PERNR", type: "text", align: "center", width: "16%" },
                { title: "성명",  name: "ENAME", type: "text", align: "center", width: "16%" },
                { title: "부서명", name: "ORGTX", type: "text", align: "center", width: "30%" },
                { title: "직위명", name: "TITEL", type: "text", align: "center", width: "15%" },
                { title: "직책명", name: "TITL2", type: "text", align: "center", width: "15%" }
            ]
        });
    });
	
	var requestOnLine = function() {
		if( requestOnLineCheck() ) {
			if(confirm("신청 하시겠습니까?")){
				$("#ORGA_NAME").val("LG사이버아카데미");
				$("#CATA_NAME").val($("#CATA_CODE option:selected").text());
				$("#COUR_NAME").val($("#COUR_CODE option:selected").text());
				
				$("#eduForm>#RowCount").val($("#decisionerGrid").jsGrid("dataCount"));
				var param = $("#eduForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				jQuery.ajax({
					type : 'POST',
					url : '/manager/edu/requestOnLine.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
		    			if(response.success){
		    				alert("신청 되었습니다.");
		    				
		    				$("#EDUC_YEAR").val("").prop("disabled", false);
		    				$("#CATA_CODE").val("").prop("disabled", false);
		    				$("#COUR_CODE").val("").prop("disabled", false);

		    				// 초기화
		    				CHANGE_CODE();

		    				$("#ORGA_NAME").val("");
		    				$("#CATA_NAME").val("");
		    				
		    				$("#decisionerGrid").jsGrid("search");
		    				$("#curriculumGrid").jsGrid({"data":$.noop});
		    				
		    				$("#requestOnLineBtn").show();
		    				$("#changeOnLineBtn").hide();
		    			}else{
		    				alert("신청시 오류가 발생하였습니다. " + response.message);
		    			}
		    		}
				});
			}
		};
	};
	
	var changeOnLine = function(){
		if( requestOnLineCheck() ) {
			if(confirm("정말 변경 하시겠습니까?")){
				$("#EDUC_YEAR").prop("disabled", false);
				$("#CATA_CODE").prop("disabled", false);
				$("#COUR_CODE").prop("disabled", false);
				$("#ORGA_NAME").val("LG사이버아카데미");
				$("#COUR_NAME").val($("#COUR_CODE option:selected").text());
				$("#CATA_NAME").val($("#CATA_CODE option:selected").text());
				
				var param = $("#eduForm").serializeArray();
				$("#decisionerGrid").jsGrid("serialize", param);
				
				jQuery.ajax({
					type : 'POST',
					url : '/manager/edu/requestChangeOnLine.json',
					cache : false,
					dataType : 'json',
					data : param,
					async :false,
					success : function(response) {
		    			if(response.success){
		    				$("#EDUC_YEAR").prop("disabled", true);
		    				$("#CATA_CODE").prop("disabled", true);
		    				$("#COUR_CODE").prop("disabled", true);
		    				alert("변경 신청 되었습니다.");
		    			}else{
		    				alert("변경 신청시 오류가 발생하였습니다. " + response.message);
		    			}
		    			$("#changeOnLineGrid").jsGrid("search");
		    			switchTabs($("#tab3"), 'tab3');
		    		}
				});
			}
		}
	};
	
	var requestOnLineCheck = function(){
		if(!checkNullField("eduForm")){
			return false;
		}
		if( !$("input:radio[name='courRadio']").is(":checked")) {
			alert("교육차수를 선택하세요.");
			return false;
		}
		
		//결재자 체크
		if( $("#RowCount").val() < 1 ){
            alert("결재자 정보가 없습니다.");
            return false;
        }
//         for ( i = 0 ; i<$("#RowCount").val()-1 ; i++ ){
//             val = $("#APPL_APPU_NUMB"+i).val();
//             if( val == "" || val == null || val == "00000000" ){ 
//                 alert("결재자 이름을 입력하세요.");
//                 return false;
//             }
//         }
//         for( i = 0; i < $("#RowCount").val()-1; i++ ){
//             for( j = 0; j < $("#RowCount").val()-1; j++){
//                 if( i != j ){
//                     if( eval($("#APPL_APPU_TYPE"+i).val() != '02' && $("#APPL_APPU_TYPE"+j).val() != '02' ) ){
//                         if( eval($("#APPL_PERNR"+i).val() == $("#APPL_PERNR"+j).val() ) ){
//                             alert("결재자가 중복 입력되었습니다.");
//                             return false;
//                         }
//                     }
//                 }
//             }
//         }

		return true;
	};
	
	// OffLine 교육신청 
	var requestOffLine = function(){
		if(confirm("신청 하시겠습니까?")){
			$("#requestOffLineCataName").val($("#requestOffLineCataCode option:selected").text());
			
			if( requestOffLineCheck() ) {
				jQuery.ajax({
					type : 'POST',
					url : '/manager/edu/requestOffLine.json',
					cache : false,
					dataType : 'json',
					data : $('#eduRequestOffLineForm').serialize(),
					async :false,
					success : function(response) {
		    			if(response.success){
		    				alert("신청 되었습니다.");
		    				// 초기화
		    				$("#eduRequestOffLineForm").each(function() {
		    					this.reset();
		    				});
		    				
		    				$("#requestOffLineEducYear").prop("disabled", false);
		    				$("#requestOffLineCataCode").prop("disabled", false);
		    				
		    				$("#requestOffLineBtn").show();
		    				$("#changeOffLineBtn").hide();
		    				
		    			}else{
		    				alert("신청시 오류가 발생하였습니다. " + response.message);
		    			}
		    		}
				});
			};
		}
	};
	
	// OffLine 교육신청 변경
	var changeOffLine = function(){
		if( requestOffLineCheck() ){
			if(confirm("정말 수정 하시겠습니까?")){
				$("#requestOffLineEducYear").prop("disabled", false);
				$("#requestOffLineCataCode").prop("disabled", false);
				jQuery.ajax({
					type : 'POST',
					url : '/manager/edu/requestChangeOffLine.json',
					cache : false,
					dataType : 'json',
					data : $('#eduRequestOffLineForm').serialize(),
					async :false,
					success : function(response) {
		    			if(response.success){
		    				$("#requestOffLineEducYear").prop("disabled", true);
		    				$("#requestOffLineCataCode").prop("disabled", true);
		    				alert("신청 되었습니다.");
		    			}else{
		    				alert("신청시 오류가 발생하였습니다. " + response.message);
		    			}
		    			$("#changeOffLineGrid").jsGrid("search");
		    			switchTabs($("#tab4"), 'tab4');
		    		}
				});
			}
		};
	};
	
	var requestOffLineCheck = function(){
		
		if(!checkNullField("eduRequestOffLineForm")){
			return false;
		}
		
		if(!checkNum($("#requestOffLineEducCost").val())){
			alert("교육비는 숫자만 입력하세요");
			return false;
		}
		if( !$("#requestOffLineEducTime").val() == "" ) {
			if(!checkNum($("#requestOffLineEducTime").val())){
				alert("교육시간은 숫자만 입력하세요");
				return false;
			}
		}
		
		if(!checkdate($("#inputDateFrom"))){
			return false;
		}
		if(!checkdate($("#inputDateTo"))){
			return false;
		}

		return true;
	}
	
	// OnLIne 교육변경 신청 grid
	$(function() {
		$("#changeOnLineGrid").jsGrid({
			height: "auto",
	        width: "100%",
	        sorting: true,
	        paging: false,
	        autoload: false,
			controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/manager/edu/getForChangeOnLineList.json",
   						dataType : "json"
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
           			title: "선택", name: "th1", align: "center", width: "4%",
           			itemTemplate: function(_, item) {
           				return $("<input name='onLineRadio' >")
           					   .attr("type", "radio")
           					   .on("click", function(e) {
           						   $("#changeOnLineRadioChk").val("Y");
           						   $("#ainfSeqn").val(item.AINF_SEQN);
           					       $("#changeOnLineAinfSeqn").val(item.AINF_SEQN);
           					   });
           			}
           		},
           		{ title: "년도", name: "EDUC_YEAR", type: "text", align: "center", width: "7%" },
           		{ title: "교육기관", name: "ORGA_NAME", type: "text", align: "center", width: "14%" },
           		{ title: "교육분야", name: "CATA_NAME", type: "text", align: "center", width: "14%" },
           		{ title: "교육과정", name: "COUR_NAME", type: "text", align: "center", width: "13%" },
           		{ title: "확정차수", name: "COUR_SCHE_C", type: "text", align: "center", width: "7%" },
           		{ title: "확정차수<br/>교육기간", name: "PERIOD_C", type: "text", align: "center", width: "14%" },
           		{ title: "변경차수", name: "COUR_SCHE", type: "text", align: "center", width: "7%" },
           		{ title: "변경신청중인<br/>차수교육기간", name: "EDUC_BEGD", type: "text", align: "center", width: "14%" 
           			,itemTemplate : function(_,item){
           				return item.EDUC_BEGD + "~" + item.EDUC_ENDD;
           			}
           		},
           		{ title: "필수여부", name: "ESSE_FLAG", type: "text", align: "center", width: "6%" 
           			,itemTemplate: function(value,item){
           				if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
           			}
           		}
       		]
		});
	});
	
	// OffLIne 교육변경 신청 grid
	$(function() {
		$("#changeOffLineGrid").jsGrid({
			height: "auto",
	        width: "100%",
	        sorting: true,
	        paging: false,
	        autoload: false,
			controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/manager/edu/getForChangeOffLineList.json",
   						dataType : "json"
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
           			title: "선택", name: "th1", align: "center", width: "6%",
           			itemTemplate: function(_, item) {
           				return $("<input name='offLineRadio'>")
           					   .attr("type", "radio")
           					   .on("click", function(e) {
           						   $("#requestOffLineEducYear").val(item.EDUC_YEAR).prop("disabled", true);
           						   $("#requestOffLineCataCode").val(item.CATA_CODE).prop("disabled", true);
           						   $("#requestOffLineCourName").val(item.COUR_NAME);
           						   $("#requestOffLineOrgaName").val(item.ORGA_NAME);
           						   $("#inputDateFrom").val(item.EDUC_BEGD);
           						   $("#inputDateTo").val(item.EDUC_ENDD);
           						   $("#requestOffLineEducCost").val(parseInt(item.EDUC_COST * 100));
           						   $("#requestOffLineEducTime").val(parseInt(item.EDUC_TIME));
           						   $("#requestOffLineCataName").val(item.CATA_NAME);
           						   $("#requestOffLineCourSche").val(item.COUR_SCHE);
           						   $("#requestOffLineOrgaCode").val(item.ORGA_CODE);
           					       $("#requestOffLineAinfSeqn").val(item.AINF_SEQN);
           					       $("#requestOffLineCourCode").val(item.COUR_CODE);
           					   });
           			}
           		},
           		{ title: "년도", name: "EDUC_YEAR", type: "text", align: "center", width: "10%" },
           		{ title: "교육과정", name: "COUR_NAME", type: "text", align: "center", width: "19%" },
           		{ title: "차수교육기간", name: "EDUC_BEGD", type: "text", align: "center", width: "20%", 
           			itemTemplate: function(value,item){
           				return value + "~" + item.EDUC_ENDD;
           			}
           		},
           		{ title: "교육비", name: "EDUC_COST", type: "number", align: "center", width: "15%",
           			itemTemplate: function(value,item){
           				return parseInt(value*100).format();
           			}
           		},
           		{ title: "교육기관", name: "ORGA_NAME", type: "text", align: "center", width: "20%" },
           		{ title: "필수여부", name: "ESSE_FLAG", type: "text", align: "center", width: "8%",
           			itemTemplate: function(value,item){
           				if(value=="X")
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : true, "disabled" : true} );
                        else
                        	return $("<input>").attr("type", "checkbox").prop({"checked" : false, "disabled" : true} );
           			}
           		}
       		]
		});
	});
	
	var selectEduChageValue = function(){
		jQuery.ajax({
			type : 'GET',
			url : '/manager/edu/getDetailForChangeOnLine.json',
			cache : false,
			dataType : 'json',
			data : $('#changeOnLineForm').serialize(),
			async :false,
			success : function(response) {
    			if(response.success){
    				$("#EDUC_YEAR").val(response.storeData.EDUC_YEAR).prop("disabled", true);
    				$("#ORGA_NAME").val(response.storeData.ORGA_NAME);
    				$("#CATA_CODE").val(response.storeData.CATA_CODE).prop("disabled", true);
    				CHANGE_CODE();
    				$("#CATA_NAME").val(response.storeData.CATA_NAME);
    				$("#COUR_CODE").val(response.storeData.COUR_CODE).prop("disabled", true);
    				$("#curriculumGrid").jsGrid("search");
    				
    			    $("#COUR_SCHE_CHECK").val(response.storeData.COUR_SCHE);
    			    $("#ORGA_CODE").val(response.storeData.ORGA_CODE);
    				
    				switchTabs($("#tab1"), 'tab1');
    			}else{
    				alert("조회시 오류가 발생하였습니다. " + response.message);
    			}
    		}
		});
	};
	
	// 교육이수 현황 그리드
	$(function() {
	    $("#finishedGrid").jsGrid({
	        height: "auto",
	        width: "100%",
	        sorting: true,
	        paging: true,
	        autoload: true,
	        controller : {
            	loadData : function() {
   					var d = $.Deferred();
   					$.ajax({
   						type : "GET",
   						url : "/manager/edu/getFinishedList.json",
   						dataType : "json"
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
	        	{ title: "교육분야", name: "MC_STEXT", type: "text", align: "left", width: "10%" },
	        	{ title: "과정명", name: "TTEXT", type: "text", align: "left", width: "24%" },
	            { title: "교육기관", name: "MC_STEXT1", type: "text", align: "left", width: "24%" },
	            { title: "교육기간", name: "PERIOD", type: "text", align: "center", width: "18%" },
	            { title: "시간", name: "ILSU", type: "number", align: "center", width: "6%" 
	            	,itemTemplate: function(value, item) {
	            		if(value.format() > 0 )
	            			return value.format();
	            		else
	            			return "";
                    },
	            },
	            { title: "이수", name: "FLAG1", type: "number", align: "center", width: "6%" },
	            { title: "평가", name: "PYONGGA", type: "number", align: "center", width: "6%" },
	            { title: "진급필수", name: "FLAG2", type: "number", align: "center", width: "6%"  
	            	,itemTemplate: function(value, item) {
	            		if(value == "N" )
	            			return "";
	            		else
	            			return value;
                    },
	            }
	        ]
	    });
	});
	
</script>

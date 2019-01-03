<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- contents start -->
	<!--// Page Title start -->
	<div class="title">
		<h1>서약/동의현황</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">서약서관리</a></span></li>
				<li><span><a href="#">정도경영/개인정보</a></span></li>
				<li class="lastLocation"><span><a href="#">서약/동의현황</a></span></li>
			</ul>						
		</div>
	</div>
	<div class="listArea">
		<h3 class="subsubtitle withButtons">서약/동의현황</h3>
		<div class="buttonArea">
			<ul class="btn_mdl">
				<li><a href="#" id="viewPledgeBtn"><span>세부내역 조회</span></a></li>								
			</ul>
		</div>
		<div class="clear"> </div>
		<div id="pledgeListGrid" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>	
	</div>

	
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong id="popupTitle"></strong>
		<a href="#" class="btnClose popLayerPrint_close" id="closePrint">창닫기</a>
	</div>
	<div class="printScroll">
	<div id="printContentsArea" class="layerContainer">
	<iframe name="iframeprint" id="iframeprint" src="" frameborder="0" scroll=no style="float:center; height:750px; width:700px;"></iframe>
	</div>
	</div>
	<div class="buttonArea buttonPrint">
		<ul class="btn_crud">
			<li><a class="darken" href="#" id="printPopPledgeBtn"><span>프린트</span></a></li>								
		</ul>
	</div>	
	
</div>
<script>
$(document).ready(function(){
	$("#pledgeListGrid").jsGrid({
	    height: "auto",
	    width: "100%",
		sorting : true,
	    paging: true,
	    autoload: true,
		controller : {
			loadData : function() {
				var d = $.Deferred();
				$.ajax({
					type : "GET",
					url : "/pledge/getPledgeList.json",
					dataType : "json"
				}).done(function(response) {
					if(response.success) {
						//연봉계약서 iframe 세팅
						d.resolve(response.storeData);
					}
	    			else
	    				alert("조회시 오류가 발생하였습니다. " + response.message);
				});
				return d.promise();
			}
		},
	
		fields : [ 
	               { title: "선택", name: "selected", align: "center", width: "5%",
	                	itemTemplate: function(_, item) {
	                        return $("<input name='courRadio'>")
	                        	   .attr("type", "radio")
	                        	   .on("click", function(e) {
	                        	   });     
	                    }
	               }, 
	               { name : "SEQ", title : "순서",  align : "center", type : "text", width: "10%",
	            	   itemTemplate: function(value) {
	            		   return Number(value);
	               		}
	               },
		           { name : "GUBUN", title : "구분",  align : "left", type : "text", width: "45%"},
		           { name : "AGR_YN", title : "동의여부",  align : "center", type : "text", width: "20%"},
		           { name : "AGR_DATE", title : "동의일",  align : "center", type : "text", width: "20%",
		        	   itemTemplate: function(value) {
	            		   if(value !="0000.00.00") return value;   
		           	   }
		           }
		         ]
	});
	
	$("#viewPledgeBtn").click(function() {
		var year = "";
		var gubun = "";
		var seq = "";
    	$.each($("#pledgeListGrid").jsGrid("option", "data"), function(i, $item){
    		var $row = $("#pledgeListGrid").jsGrid("rowByItem", $item);
    		if($row.find('input[name="courRadio"]').is(":checked")) {
    			year = $item.ZYEAR;
    			gubun = $item.ATYPE;
    			seq = $item.ZSEQ;
    			return false;
    		}
    	});

    	if(year == "")
			alert("서약서를 선택하시기 바랍니다.");
    	else {
    		$("#iframeprint").attr("src","/pledge/detail/" + year + "?gubun=" + gubun + "&seq="+seq);
    		$("#iframeprint").load(function(){
    			$('#popLayerPrint').popup("show");
    		});
    	}
	});
	
	$("#printPopPledgeBtn").click(function() {
		$("#printContentsArea").print();
	});
	
	$("#closePrint").click(function() {
		$('#pledgeListGrid').jsGrid('search');
	});
});
</script>
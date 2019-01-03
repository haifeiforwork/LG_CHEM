<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D01OT.*"%>
<%@ page import="hris.D.D01OT.rfc.*"%>
<%@ page import="hris.D.D03Vocation.*"%>
<%@ page import="hris.D.D03Vocation.rfc.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>

<%
	WebUserData user = (WebUserData)session.getValue("managedUser");
	String      message        = (String)request.getAttribute("message");
    String      inputFlag        = (String)request.getAttribute("inputFlag");

    Vector      attAppLineData_vt = (Vector)request.getAttribute("attAppLineData_vt"); //초과근무결재
    Vector      edtAppLineData_vt = (Vector)request.getAttribute("edtAppLineData_vt"); //교육신청결재

    Vector      D01OTData_vt   = null; //초과근무신청
    D01OTData   data           = null;
    
    D01OTData_vt = (Vector)request.getAttribute( "D01OTData_vt" );
    data         = (D01OTData)D01OTData_vt.get(0);
    
    Vector      ret             = null;
    D03WorkPeriodData   data2   = null;
    ret = (Vector)request.getAttribute( "ret" );

//  2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
    GetTimmoRFC rfc = new GetTimmoRFC();
    String      E_RRDAT = rfc.GetTimmo( user.companyCode );
    long        D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT,"."));
    
    int year  = 0;
    int month = 0;
    
	year  = Integer.parseInt( DataUtil.getCurrentYear()) ;   // 년
	month = Integer.parseInt( DataUtil.getCurrentMonth()) ;  // 월
	
    
    int startYear                    = Integer.parseInt( (user.e_dat03).substring(0,4) );
    int endYear                      = Integer.parseInt( DataUtil.getCurrentYear() );
    
   //  2003.01.02. - 12월일때만 endYear에 + 1년을 해준다. 
    if( month == 12 ) {
        endYear                      = Integer.parseInt( DataUtil.getCurrentYear() ) + 1;
    } 
    
    if( startYear < 2004 ){
        startYear = 2004;
    }
    if( ( endYear - startYear ) > 10 ){
        startYear = endYear - 10;
    }
    
    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }
 
%>
 
<%
		String PERNR = WebUtil.nvl((String)request.getAttribute("PERNR"),user.empNo); 

 		Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, user.empNo, "2005" , DataUtil.getCurrentDate());
		Vector newOpt = new Vector();
		
		for( int j = 0 ; j < D03VocationAReason_vt.size() ; j++ )
		{
			D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(j);
			CodeEntity code_data = new CodeEntity();
			code_data.code = old_data.SCODE ;						
			code_data.value = old_data.STEXT ;
			newOpt.addElement(code_data);	
		}  
		
	   	Vector D03VocationAReason0010_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, PERNR, "0010",DataUtil.getCurrentDate());
	  	Vector D03VocationAReason0020_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, PERNR, "0020",DataUtil.getCurrentDate());
	 
 	  	Vector D03OvertimeCodeData0010_vt  = new Vector(); 
	  	for( int i = 0 ; i < D03VocationAReason0010_vt.size() ; i++ ){
	      	D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason0010_vt.get(i);
	      	CodeEntity code_data = new CodeEntity();
	      	code_data.code = old_data.SCODE ;
	      	code_data.value = old_data.STEXT ;
			
	     if(!("1".equals(code_data.code) || "2".equals(code_data.code))){
	     	 D03OvertimeCodeData0010_vt.addElement(code_data);
	     }
	  }  	 
%>  

	<!--// Page Title start -->
	<div class="title">
		<h1>근태</h1>
		<div class="titleRight">
			<ul class="pageLocation">
				<li><span><a href="#">Home</a></span></li>
				<li><span><a href="#">My Info</a></span></li>
				<li><span><a href="#">근태</a></span></li>
				<li class="lastLocation"><span><a href="#">근태</a></span></li>
			</ul>						
		</div>
	</div>
	<!--// Page Title end -->	
	
	<!--------------- layout body start --------------->				
<!--// Tab3 start -->
<form id="attListForm" name="attListForm" method="post" action="">
	<div class="tabUnder tab3">
		<div class="tableInquiry ">
			<table>
				<caption>1행조회</caption>
				<colgroup>
					<col class="col_11p" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>조회년월</th>
						<td class="td04">
							<select class="w70" id="year" name="year">
						 		<%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%> 
							</select> 
							<select class="w50" id="month" name="month">
<%
    for( int i = 1 ; i < 13 ; i++ ) {
%>
                      			<option value="<%= i %>" <%= i == month ? "selected" : "" %>><%= i %></option>
<%
    }
%> 
							</select> 
						<a class="icoSearch" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색" /></a></td>
					</tr>
				</tbody>
			</table>
		</div>
	<!--// list start -->
	<div class="listArea">
	    <h3 class="subsubtitle">
			<span class="colorPoint" id="yearMonth" ></span> 근태실적 조회
		</h3>
<!-- slide content -->
<div class="contentDetail">
  <div id="addListGrid" class="thSpan"></div>		
	 <div id="attendanceList" class="listTotal"></div>
	<table class="listTable tHead">
		<colgroup>
			<col class="col_9p"/>
			<col class="col_7p"/>
			<col class="col_7p"/>
			<col class="col_7p"/>
			<col class="col_7p"/>
			<col class="col_7p"/>
			<col class="col_8p"/>
			<col class="col_8p"/>
			<col class="col_8p"/>
			<col class="col_8p"/>
			<col class="col_8p"/>
			<col class="col_8p"/>
			<col class="col_8p"/>
	</colgroup>
		<thead>											
			  <tr class="totalMonth">
			    <td><strong>월계</strong></td>
			    <td id="TOTAL"></td>
			    <td id="TOTAL1"></td>
			    <td id="TOTAL2"></td>
			    <td id="TOTAL3"></td>
			    <td id="TOTAL4"></td>
			    <td id="TOTAL5"></td>
			    <td id="TOTAL6"></td>
			    <td id="TOTAL7"></td>
			    <td id="TOTAL8"></td>
			    <td id="TOTAL9"></td>
			    <td id="TOTAL10"></td>
			    <td id="TOTAL11"></td>
			  </tr>
		</thead>
	</table>
</div>
	</div>
   </div>
</form>
<!--// Tab3 end -->

<!-- //  script -->
<script type="text/javascript">
// 근태 실적조회 그리드
$(function() {
	$("#addListGrid").jsGrid({
		height : "auto",
		width : "100%",
		sorting : true,
		paging : false,
		autoload : true,
        headerRowRenderer: function() {
                var $result = $("<tr>").height(0)
                	.append($("<th>").width("9%"))
                	.append($("<th>").width('7%'))
                	.append($("<th>").width('7%'))
                	.append($("<th>").width('7%'))
                	.append($("<th>").width('7%'))
        	        .append($("<th>").width('7%'))
                	.append($("<th>").width('8%'))
                	.append($("<th>").width('8%'))
        	        .append($("<th>").width('8%'))
                	.append($("<th>").width('8%'))
                	.append($("<th>").width('8%'))
              		.append($("<th>").width('8%'))
        	        .append($("<th>").width('8%'));
                $result = $result.add($("<tr>")
                    .append($("<th>").attr("rowspan", 2).text("구분"))
                	.append($("<th>").attr("colspan", 5).text("추가 근로(시간)"))
                	.append($("<th>").attr("colspan", 2).text("사원급료정보"))
                	.append($("<th>").attr("colspan", 4).text("휴가(일수)"))
                	.append($("<th>").attr("colspan", 1).text("기타(일수)")));
                
                var $tr = $("<tr>");
                var grid = this;
                grid._eachField(function(field, index) {
                    if (index>0 && index<13) {
                        var $th = $("<th>").text(field.title).width(field.width).appendTo($tr);
                        if(grid.sorting && field.sorting) {
                    		$th.on("click", function() {
                            	grid.sort(index);
                        	});
                        }
                    }
                });
                
                return $result.add($tr);
            },
		controller : {
			loadData : function() {
				var d = $.Deferred();
				$.ajax({
					type : "GET",
					url : "/manager/work/getAttendanceList.json",
					dataType : "json",
		    		data : {
		    		    "year" : $("#year option:selected").val(),
		    		    "month" : $("#month option:selected").val()
					}
				}).done(function(response) {
					if(response.success){
						d.resolve(response.storeData);
						$("#yearMonth").html( $("#year option:selected").text() + "년"+ " " + $("#month option:selected").text()+ "월"+" ");
					}else{
	    				alert("조회시 오류가 발생하였습니다. " + response.message);
					}
				});
				return d.promise();
			}
		},
		 fields:  [
		          { title: "구분", name: "DATE", type: "text", align: "center"  ,width: '9%'},
		          { title: "평일연장", name: "COL1", type: "number", align: "center"  ,width: '7%',
		        		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
		          { title: "휴일연장", name: "COL2", type: "number", align: "center"  ,width: '7%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
				  
		          { title: "야간근무 ", name: "COL3", type: "number", align: "center" ,width: '7%',
		      		itemTemplate : function(value) {
						return (value == 0) ? "" : value;
			  	  }},
		          { title: "휴일근무", name: "COL4", type: "number", align: "center"  ,width: '7%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
		          { title: "명절특근", name: "COL0", type: "number", align: "center"   ,width: '7%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
		          
		          { title: "교육수당", name: "COL11", type: "number", align: "center" ,width: '8%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
		          
		          { title: "당직", name: "COL12", type: "number", align: "center" ,width: '8%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},  
		          { title: "사용휴가", name: "COL5", type: "number", align: "center"  ,width: '8%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
		          { title: "보건휴가", name: "COL6", type: "number", align: "center" ,width: '8%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
		          { title: "하계휴가", name: "C0140", type: "number", align: "center"  ,width: '8%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
		          { title: "공가", name: "COL13", type: "number", align: "center"   ,width: '8%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }},
		          { title: "결근", name: "COL7", type: "number", align: "center" ,width: '8%',
			      		itemTemplate : function(value) {
							return (value == 0) ? "" : value;
				  }}
		      ]
		   });
	    });
	  //근태 실적조회 합계
        $(function() {
            $("#attendanceList").jsGrid({
                height: "auto",
                width: "100%",
                paging: false,
				autoload : true,
                onDataLoaded: function(args) {
	                var rows = args.grid.data;              
	                var total_price = 0;  
	                var total_price1 = 0; 
	                var total_price2 = 0; 
	                var total_price3 = 0;  
	                var total_price4 = 0;  
	                var total_price5 = 0;  
	                var total_price6 = 0;  
	                var total_price7 = 0;  
	                var total_price8 = 0;  
	                var total_price9 = 0;  
	                var total_price10 = 0;  
	                var total_price11 = 0;  

	                for (row in rows) 
	                {   
	                    curRow = rows[row];    
	                    total_price  += parseFloat(curRow.COL1.format()); 
	                    total_price1 += parseFloat(curRow.COL2.format()); 
	                    total_price2 += parseFloat(curRow.COL3.format()); 
	                    total_price3 += parseFloat(curRow.COL4.format()); 
	                    total_price4 += parseFloat(curRow.COL0.format()); 
	                    total_price5 += parseFloat(curRow.COL11.format()); 
	                    total_price6 += parseFloat(curRow.COL12.format()); 
	                    total_price7 += parseFloat(curRow.COL5.format()); 
	                    total_price8 += parseFloat(curRow.COL6.format()); 
	                    total_price9 += parseFloat(curRow.C0140.format()); 
	                    total_price10 += parseFloat(curRow.COL13.format()); 
	                    total_price11 += parseFloat(curRow.COL7.format()); 
	                };
	                	$("#TOTAL").html(parseFloat(total_price).toFixed(1));
	                	$("#TOTAL1").html(parseFloat(total_price1).toFixed(1));
	                	$("#TOTAL2").html(parseFloat(total_price2).toFixed(1));
	                	$("#TOTAL3").html(parseFloat(total_price3).toFixed(1));
	                	$("#TOTAL4").html(parseFloat(total_price4).toFixed(1));
	                	$("#TOTAL5").html(parseFloat(total_price5).toFixed(1));
	                	$("#TOTAL6").html(parseFloat(total_price6).toFixed(1));
	                	$("#TOTAL7").html(parseFloat(total_price7).toFixed(1));
	                	$("#TOTAL8").html(parseFloat(total_price8).toFixed(1));
	                	$("#TOTAL9").html(parseFloat(total_price9).toFixed(1));
	                	$("#TOTAL10").html(parseFloat(total_price10).toFixed(1));
	                	$("#TOTAL11").html(parseFloat(total_price11).toFixed(1));
	            }, 
	            controller : {
					loadData : function() {
						var d = $.Deferred();
						$.ajax({
							type : "GET",
							url : "/manager/work/getAttendanceList.json",
							dataType : "json",
				    		data : {
				    		    "year" : $("#year option:selected").val(),
				    		    "month" : $("#month option:selected").val()
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
            });
        });
// 근태실적정보 조회
$(".icoSearch").click(function() {
	if($("#year").val() == "2004" && ($("#month").val() == "1" || $("#month").val() == "2") ){
	    alert("근태 실적정보는 2004년 3월부터 조회가능합니다.");
	    return;
	}else{
       	$("#attendanceList").jsGrid("search");
       	$("#addListGrid").jsGrid("search");
	}
});	
</script>

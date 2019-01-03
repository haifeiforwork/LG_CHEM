<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>

<%
	Vector CodeEntity_vt = new Vector();
	int endYear = Integer.parseInt( DataUtil.getCurrentYear() );
	for( int i = endYear-1 ; i <= endYear+1 ; i++ ){
		CodeEntity entity = new CodeEntity();
		entity.code  = Integer.toString(i);
		entity.value = Integer.toString(i);
		CodeEntity_vt.addElement(entity);
	}
%>

	<div class="tableArea">
		<div class="table">
			<table class="tableGeneral">
			<caption>FlexTime 실적조회</caption>
			<colgroup>
				<col class="col_10p" />
				<col class="col_90p" />

			</colgroup>
			<tbody>
				<tr>
					<th><label for="year">조회년도</label></th>
					<td>
						<select class="w90" id="year" name="year"> 
							<%= WebUtil.printOption(CodeEntity_vt, Integer.toString(endYear)) %>
						</select>
					</td>

				</tr>
			</tbody>
			</table>
		</div>
	</div>
	<!--// list start -->
	<div class="listArea">	
 <!-- flextime 실적조회 -->
		<div id="balSengListGrid"></div>
	</div>
	<!--// list end -->	


<script type="text/javascript">

	$("#year").change(function(){
		$("#balSengListGrid").jsGrid("search");
	});

	// 휴가 발생 내역 그리드
	$(function() {
		$.fn.Rowspan = function(colIdx, isStats) {
			return this.each(function(){
				var that;
				$('tr', this).each(function(row) {
					$('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
						
						if ($(this).html() != '' && $(this).html() == $(that).html()
							&& (!isStats
									|| isStats && $(this).prev().html() == $(that).prev().html()
									)
							) {
							rowspan = $(that).attr("rowspan") || 1;
							rowspan = Number(rowspan)+1;

							$(that).attr("rowspan",rowspan);

							$(that).css('background-color', '#fff')
							$(this).hide();

						} else {
							that = this;
						}

						that = (that == null) ? this : that;
					});
				});
			});
		};
		
		$("#balSengListGrid").jsGrid({
	         height : "560px",
	         width : "100%",
	         sorting : false,
	         paging : false,
	         autoload : false,
	         controller : {
	             loadData : function() {
	                 var d = $.Deferred();
	                 $.ajax({
	                     type : "GET",
	                     url : "/work/getFlexTimeList.json",
	                     dataType : "json",
	                     data : {
	                    	 "PERNR" : '<c:out value="${PERNR}" />',
	                    	 "year" : $("#year option:selected").val()
	                     }
	                 }).done(function(response) {
	                     if(response.success){
	                         d.resolve(response.storeData);
	                         
	                         $('.jsgrid-grid-body .jsgrid-table')
	                         		.Rowspan(12)
	                         		.Rowspan(11)
	                         		.Rowspan(10)
	                         		.Rowspan(9)
	                         		.Rowspan(8)
	                         		.Rowspan(7)
	                         		.Rowspan(6)
	                         		.Rowspan(5)
	                         		.Rowspan(4)
	                         		.Rowspan(3)
	                         		.Rowspan(2)
	                         		.Rowspan(1);
	                         		//.find('.jsgrid-row').each(function() { $(this).removeClass('jsgrid-row').addClass('jsgrid-alt-row') });
	                         
	                         $('.jsgrid-grid-header').css('overflow-y', 'scroll');
	                         $('.jsgrid-grid-body').css('overflow-y', 'scroll');
	                     }else{
	                         alert("조회시 오류가 발생하였습니다. " + response.message);
	                     }
	                 });
	                 return d.promise();
	             }
	         },
	         fields: [
	        		{ title: "구분", name: "ZDATE01", type: "text", align: "center", width: "5.2%",
	                     itemTemplate: function(value, item) {
	                    	 var day = Number(item.ZDATE01.substr(item.ZDATE01.length - 2, 2));
	                         return day + " 일";
	                     }
	                },
					{ title: "1월", name: "ZFLEXT01", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT01.split(' ').join('');
	                     }
	                },
					{ title: "2월", name: "ZFLEXT02", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT02.split(' ').join('');
	                     }
	                },
					{ title: "3월", name: "ZFLEXT03", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT03.split(' ').join('');
	                     }
	                },
					{ title: "4월", name: "ZFLEXT04", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT04.split(' ').join('');
	                     }
	                },
					{ title: "5월", name: "ZFLEXT05", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT05.split(' ').join('');
	                     }
	                },
					{ title: "6월", name: "ZFLEXT06", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT06.split(' ').join('');
	                     }
	                },
					{ title: "7월", name: "ZFLEXT07", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT07.split(' ').join('');
	                     }
	                },
					{ title: "8월", name: "ZFLEXT08", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT08.split(' ').join('');
	                     }
	                },
					{ title: "9월", name: "ZFLEXT09", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT09.split(' ').join('');
	                     }
	                },
					{ title: "10월", name: "ZFLEXT10", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT10.split(' ').join('');
	                     }
	                },
					{ title: "11월", name: "ZFLEXT11", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT11.split(' ').join('');
	                     }
	                },
					{ title: "12월", name: "ZFLEXT12", type: "text", align: "center", width: "7.9%",
	                     itemTemplate: function(value, item) {
	                         return item.ZFLEXT12.split(' ').join('');
	                     }
	                }
	         ]
	    });
		
		$("#balSengListGrid").jsGrid("search");
	});

</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.D.D06Ypay.D06YpayDetailData_to_year" %>
<%@ page import="hris.D.D06Ypay.D06YpayTaxDetailData_to_year" %>
<%@ page import="hris.D.D06Ypay.D06YpayDetailData2_to_year" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.DateTime"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.SortUtil"%>
<%
	WebUserData user   = (WebUserData)session.getValue("user");
	Vector D06YpayDetailData_vt = (Vector) request.getAttribute("D06YpayDetailData_vt"); // 연급여 내역 리스트
	Vector D06YpayDetailData3_vt = (Vector) request.getAttribute("D06YpayDetailData3_vt"); // 과세반영 내역 조회

	String from_year = (String) request.getAttribute("from_year");


	int startYear = Integer.parseInt((user.e_dat03).substring(0, 4));
	int endYear = Integer.parseInt(DataUtil.getCurrentYear());
	if (startYear < 2003) {
		startYear = 2003;
	}

	Vector CodeEntity_vt = new Vector();
	for (int i = startYear; i <= endYear; i++) {
		CodeEntity entity = new CodeEntity();
		entity.code = Integer.toString(i);
		entity.value = Integer.toString(i);
		CodeEntity_vt.addElement(entity);
	}
%>
				<!--// Page Title start -->
				<div class="title">
					<h1>연급여</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">급여</a></span></li>
							<li class="lastLocation"><span><a href="#">연급여</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->	
				
				<!--------------- layout body start --------------->							
				<div class="tableArea">
					<form id="searchForm">
					<h2 class="subsubtitle withButtons">연급여 조회</h2>
					<div class="clear"> </div>	
					<div class="table">
						<table class="tableGeneral">
						<caption>급여조회정보</caption>
						<colgroup>
							<col class="col_15p" />
							<col class="col_37p" />
							<col class="col_10p" />
							<col class="col_14p" />
							<col class="col_10p" />
							<col class="col_14p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="input_select01">조회년도</label></th>
								<td colspan="6">
									<select id="year" name="year" class="w80">
                    <% for( int i = DateTime.getYear() ; i > 2002 ; i-- ) {
                       int from_year1 = Integer.parseInt(from_year);
                    %>
                     					<option value="<%= i %>"<%= from_year1 == i ? " selected " : "" %>><%= i %></option>
                    <% } %>
									</select>
									<a class="icoSearch" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
								</td>
							</tr>
							<tr>
								<th>부서명</th>
								<td><%= user.e_orgtx %></td>
								<th>사번</th>
								<td><%= user.empNo %></td>
								<th>성명</th>
								<td><%= user.ename %></td>
							</tr>
						</tbody>
						</table>
					</div>
<%  
    if(user.e_trfar.equals("02") || user.e_trfar.equals("03") || user.e_trfar.equals("04")) {   
%>
					<div class="tableComment" id="printArea03">
						<p><span class="bold">개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며, <br/>이를 위반시에는
    취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려드립니다.</span></p>
					</div>
<%  
    }   
%>
					<div class="tableComment">
						<p><span class="bold">연급여 조회의 경우 연간근로소득의 정확한 집계를 위해 소급분이 지급월이 아닌 발생월에 합산 처리되어 월별 실지급액과는<br/>
						차이가 있으므로 월별 실지급액은 해당년월을 선택하시어 조회하시기 바랍니다.</span></p>
						<p><span class="bold">근로소득원천징수영수증의 총급여액은 연간 급여/상여 합계금액과 인정이자를 합산한 금액임.</span></p>
						<p><span class="bold">청구금액은 연말정산 시 총급여에 포함되지 않습니다.</span></p>
					</div>
					</form>
				</div>							
				
				<!--// List start -->	
				<div class="listArea" id="printArea01">
					<h2 class="subtitle">연급여 내역</h2>
					<div class="table">
						<table class="listTable">
						<caption>연급여 내역 테이블</caption>
						<colgroup>
							<col/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
							<col class="col_8p"/>
						</colgroup>
						<thead>
							<tr>
								<th rowspan="2" class="thAlignCenter">해당<br>년월</th>						
								<th colspan="4" class="thAlignCenter">지급내역</th>
								<th colspan="7" class="thAlignCenter">공제내역</th>
								<th rowspan="2" class="thAlignCenter tdBorder">차감<br>지급액</th>									
							</tr>
							<tr>
								<th class="thAlignCenter">급여</th>
								<th class="thAlignCenter">상여</th>
								<th class="thAlignCenter">청구</th>
								<th class="thAlignCenter">지급계</th>								
								<th class="thAlignCenter">갑근세</th>
								<th class="thAlignCenter">주민세</th>
								<th class="thAlignCenter">건강보험</th>
								<th class="thAlignCenter">고용보험</th>
								<th class="thAlignCenter">국민연금</th>
								<th class="thAlignCenter">기타</th>	
								<th class="thAlignCenter">공제계</th>	
							</tr>
						</thead>
						<tbody>
<%
    if ( D06YpayDetailData_vt.size() == 0 ) {
%>
							<tr>
								<td colspan="13">해당 데이터가 없습니다.</td>
							</tr>
<%
    } else {
	    for ( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ) {
	    	D06YpayDetailData_to_year data = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);
%>
							<tr <% if(data.GUBUN.equals("T")) {%> class="total"<% } %>>
								<td>
									<% if(data.GUBUN.equals("")) {%>
									<a href="#" class="showMonthly" id="<%= data.ZYYMM.replaceAll("[.]","") %>">
									<% } else { %>
									<strong>
									<% } %>
									<%= data.ZYYMM %>
									<% if(data.GUBUN.equals("")) {%>
									</a>
									<% } else { %>
									</strong>
									<% } %>
								</td>
								
								<td class="tdAlignRight" <% if(data.GUBUN.equals("Y")) {%> colspan="3" <%} %>><%= data.GUBUN.equals("Y")?data.BET01:WebUtil.printNumFormat(data.BET01) %></td>   
								<% if(!data.GUBUN.equals("Y")) {%>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET02) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET03) %></td>
								<% } %>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET04) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET05) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET06) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET07) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET08) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET09) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.ETCBET) %></td>        
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET11) %></td>
								<td class="tdAlignRight tdBorder"><%= WebUtil.printNumFormat(data.MINBET) %></td>      
							</tr>							
<%
	    }
    }
%>
						</tbody>
						</table>
					</div>									
				</div>
				<!--// List end -->
				
				<!--// List start -->	
				<div class="listArea" id="printArea02">
					<h2 class="subtitle">기타사항</h2>
					<div class="table">
						<table class="listTable">
						<caption>기타사항 테이블</caption>
						<colgroup>
							<col class="col_11p"/>
							<col class="col_11p"/>
							<col class="col_11p"/>
							<col class="col_11p"/>
							<col class="col_11p"/>
							<col class="col_11p"/>
							<col class="col_11p"/>
							<col class="col_11p"/>
							<col class="col_12p"/>
						</colgroup>
						<thead>
							<tr>
								<th rowspan="2" class="thAlignCenter">해당년월</th>	
								<th rowspan="2" class="thAlignCenter">생산직비과세</th>	
								<th colspan="7" class="thAlignCenter tdBorder">과세반영</th>									
							</tr>
							<tr>
								<th class="thAlignCenter">의료비</th>
								<th class="thAlignCenter">장학자금</th>
								<th class="thAlignCenter">포상비</th>								
								<th class="thAlignCenter">인정이자</th>
								<th class="thAlignCenter">선택적복리</th>
								<th class="thAlignCenter">기타</th>
								<th class="thAlignCenter tdBorder">계</th>
							</tr>
						</thead>
						<tbody>
<%
    if ( D06YpayDetailData3_vt.size() == 0 ) {
%>
							<tr>
								<td colspan="13">해당 데이터가 없습니다.</td>
							</tr>
<%
    } else {
	    for ( int j = 0 ; j < D06YpayDetailData3_vt.size() ; j++ ) {
	    	D06YpayDetailData_to_year data = (D06YpayDetailData_to_year)D06YpayDetailData3_vt.get(j);
%>
							<tr <% if(data.GUBUN.equals("T")) {%> class="total"<% } %>>
								<td>
									<% if(data.GUBUN.equals("T")) {%>
									<strong>
									<% } %>
									<%= data.ZYYMM %>
									<% if(data.GUBUN.equals("T")) {%>
									</strong>
									<% } %>
								</td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET08) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET01) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET02) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET03) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET04) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET05) %></td>
								<td class="tdAlignRight"><%= WebUtil.printNumFormat(data.BET06) %></td>
								<td class="tdAlignRight tdBorder"><%= WebUtil.printNumFormat(data.BET07) %></td>
							</tr>							
<%
	    }
    }
%>						
													
						</tbody>
						</table>
					</div>									
				</div>
				<!--// List end -->	

				<div class="buttonArea">
					<ul class="btn_crud">
						<li><a class="darken" href="#"><span>프린트</span></a></li>								
					</ul>
				</div>
				<div class="clear"> </div>			
				<!--------------- layout body start --------------->
<!-- //print start -->
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<strong>연급여 내역</strong>
		<a href="#" class="btnClose popLayerPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer" style="width:840px;">
			<div id="printHeader" class="printHeader">
				<div class="tableArea">
					<div class="table">
						<table class="tableGeneral">
						<caption></caption>
						<colgroup>
							<col class="col_25p" />
							<col class="col_25p" />
							<col class="col_25p" />
							<col class="col_25p" />
						</colgroup>
						<tbody>
							<tr>
								<td><%= from_year %>년</td>
								<td>부서명 : <%= user.e_orgtx %></td>
								<td>사번 : <%= user.empNo %></td>
								<td>성명 : <%= user.ename %></td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div id="printBody">
				</div>
			</div>
			<!-- 프린트 영역 -->
		</div>	
	</div>
	<div class="buttonArea buttonPrint">
			<ul class="btn_crud">
				<li><a class="darken" href="#"><span>프린트</span></a></li>								
			</ul>
		</div>	
		<div class="clear"> </div>	
</div>

<form name="detailForm" id="detailForm" method="post" action="">
	<input type="hidden" name="year" value="">
	<input type="hidden" name="month" value="">
	<input type="hidden" name="ocrsn" value="ZZ00000">
</form>
<!-- // popup script -->
<script type="text/javascript">
	$(document).ready(function(){
		//search
		$(".icoSearch").click(function(){
			$("body").loader('show','<img style="width:50px;height:50px;" src="/web-resource/images/img_loading.gif">');
			$("#searchForm").attr("method", "POST");
			$("#searchForm").attr("action", "/salary/yearlyDetail");
			$("#searchForm").submit();
		});
		//팝업 띄우기
		$(function(){
			if($(".layerWrapper").length){
				//팝업 : 연급여 프린트
				$('#popLayerPrint').popup();
			}
		});
		
		//프린트 팝업 영역 설정
		$("#popLayerPrint").dialog({
		    autoOpen: false,
		    close: function() {
		    }
		});

		$(".showMonthly").click(this, function(){
            var yyyymm = $(this).attr('id');
            $("#detailForm>[name=year]").val(yyyymm.substring(0,4));
            $("#detailForm>[name=month]").val(yyyymm.substring(4,6));
			$("#detailForm").attr("method", "POST");
			$("#detailForm").attr("action", "/salary/monthlyDetail");
			$("#detailForm").submit();
		});

		$(".darken").click(function() {
//			var printDivs = $("#printArea01").wrap('<p/>').parent().html().find(".subsubtitle").hide();
			var printBody = $("#printArea01").wrap('<p/>').parent().clone().html();
			$("#printArea01").unwrap();
			printBody = printBody + $("#printArea02").wrap('<p/>').parent().clone().html();
			$("#printArea02").unwrap();
			if($("#printArea03").length){
				printBody = printBody + $("#printArea03").wrap('<p/>').parent().clone().html();
				$("#printArea03").unwrap();
			}
			$("#printBody").html(printBody);
			$('#popLayerPrint').popup("show");
			//$("#popLayerPrint").contents().find(".subsubtitle").hide();
			$("#printContentsArea").print();
		});
	});

</script>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.D.D15RetirementSimulData" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.DateTime"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.SortUtil"%>
<%@ page import="com.lgmma.ess.common.util.Util"%>
<%
    D15RetirementSimulData data = (D15RetirementSimulData)request.getAttribute("d15RetirementSimulData") ;
    Vector zhrpi00sList = (Vector)request.getAttribute("zhrpi00sList");
    String SumPenAmt = "";
    //20170209 퇴직보험사지급액 TOTAL로 변경 : 퇴직연금사지급액
    BigDecimal sum = BigDecimal.ZERO;
    for(int i=0; i<zhrpi00sList.size(); i++){
		CodeEntity codeEnt = (CodeEntity)zhrpi00sList.get(i);
		sum = sum.add(new BigDecimal(Util.parseForWon(codeEnt.value, true)));
    }
    
    SumPenAmt = sum.toString();
%>
				<!--// Page Title start -->
				<div class="title">
					<h1>퇴직금 시뮬레이션</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">급여</a></span></li>
							<li class="lastLocation"><span><a href="#">퇴직금 시뮬레이션</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->	
				
				<form id="searchForm">
				<!--------------- layout body start --------------->				
				<div class="tableInquiry mb0">
					<table>
					<caption>1행조회</caption>
					<colgroup>
						<col class="col_15p">
						<col class="col_20p">
						<col class="col_15p">
						<col class="col_25p">
						<col class="col_25p">
					</colgroup>
					<tbody>
						<tr>
							<th>퇴직금기산일</th>
							<td>
								<input class="readOnly w80" type="text" id="O_GIDAT" name="O_GIDAT" value="<%= data.O_GIDAT.equals("0000.00.00")? "" : WebUtil.printDate(data.O_GIDAT) %>" readonly="readonly" />
							</td>
							<th>예상퇴직일자</th>
							<td>
								<input class="datepicker w80" type="text" id="retireDate" name="retireDate" value="<%= WebUtil.printDate(data.fu_retireDate) %>"/>
							</td>
							<td class="btn_mdl">
								<a class="icoSearch" href="#"><span>실행</span></a>
							</td>
						</tr>
					</tbody>
					</table>
				 </div>
				 <div class="tableComment mb30">				 	
					<p><span class="bold">퇴직금중간정산을 받으신 경우 퇴직금기산일은 퇴직금중간정산일자입니다.</span></p>
					<p><span class="bold">퇴직연금에 가입되어 다음의 경우에 한해서만 중간정산을 할 수 있습니다.</span></p>
					<p>1. 무주택자의 본인명의 주택구입</p>
					<p>&nbsp;&nbsp;- 주택매매계약서 상의 잔금일이 중도인출서류 접수일 이후여야 함. 계약 체결일부터 소유권 등기 후 1개월 이내 신청 가능</p>
				    <p>2. 무주택자인 근로자가 주거목적으로 전세금 또는 보증금을 부담하는 경우</p> 
				    <p>&nbsp;&nbsp;- 근무 기간 중 1회 한정. 계약 체결일부터 잔금지급일 이후 1개월 이내 신청 가능</p>
				    <p>3. 본인, 배우자 및 부양가족의 6개월 이상 요양</p>
				    <p>&nbsp;&nbsp;- 진단서 또는 요양확인서 상 병명 및 「6개월 이상」치료기간 명기되어야 함. 요양이 종료된 경우에는 종료일 1개월 이내에 신청 가능</p>
				    <p>4. 본인이 「채무자 회생 및 파산에 관한 법률」에 따른 회생절차개시의 결정을 받은 경우</p> 
				    <p>&nbsp;&nbsp;- 신청일로 부터 5년 이내 결정 및 효력 유지 시 신청 가능</p>
				    <p> 5. 본인이 「채무자 회생 및 파산에 관한 법률」에 따른 파산선고를 받은 경우</p>
				    <p>&nbsp;&nbsp;- 신청일로 부터 5년 이내 결정 및 효력 유지 시 신청 가능</p>
				    <p> 6. 태풍, 홍수,가뭄, 지진 등 천재지변으로 고용노동부장관이 정한 사유와 요건에 해당하는 경우</p>
				    <p>&nbsp;&nbsp;- 물적․인적 피해를 입은 날로부터 3개월 이내에 신청 가능</p>
				    <p> 7. 임금피크제를 실시하여 임금이 줄어드는 경우 (임금피크제가 실시되는 날 신청)</p> 
				    
				</div>
				<div class="tableArea">
				  <div class="table">
				    <table class="tableGeneral">
				      <caption>
				      퇴직금 시뮬레이션 실행
				      </caption>
				      <colgroup>
				      <col class="col_15p" />
				      <col class="col_35p" />
				      <col class="col_15p" />
				      <col class="col_35p" />
				      </colgroup>
				      <tbody>
				        <tr>
				          <th>평균임금</th>
				          <td><input type="text" name="WAGE_AVER" value="<%= WebUtil.printNumFormat(data.WAGE_AVER)+" 원" %>" class="readOnly alignRight" readonly></td>
				          <th class="th02" width="100">평균임금기산일</th>
				          <td><input type="text" name="AVER_DATE" value="<%= data.AVER_DATE.equals("0000.00.00")? "" : WebUtil.printDate(data.AVER_DATE) %>" size="14" class="readOnly" readonly></td>
				        </tr>
				        <tr>
				          <th>근속년수</th>
				          <td colspan="3"><input type="text" name="SERV_PROD_Y" value="<%= (data.SERV_PROD_Y.equals("00") ? "" : WebUtil.printNum(data.SERV_PROD_Y)+" 년 ")+(data.SERV_PROD_M.equals("00") ? "" : WebUtil.printNum(data.SERV_PROD_M)+" 개월")%>" class="readOnly alignRight" readonly></td>
				        </tr>
				        <tr>
				          <th>퇴직금 총액</th>
				          <td colspan="3"><input type="text" name="GRNT_RSGN" value="<%= WebUtil.printNumFormat(data.GRNT_RSGN)+" 원" %>" class="readOnly alignRight" readonly>
				            <span class="noteItem colorRed">※ 평균임금 계산시 반영되는 연장근로 한도초과시 실제와 다를 수 있습니다. </span></td>
				        </tr>
				        <tr>
				          <th></th>
				          <td colspan="3">
					          <table class="innerTable">
					              <colgroup>
					              <col class="col_25p" />
					              <col class="col_75p" />
					              </colgroup>
					              <tbody>

					            	<tr>
					                  <th>퇴직연금사지급액</th>
					                  <td><input type="text" value="<%= WebUtil.printNumFormat(SumPenAmt)+" 원" %>" class="readOnly alignRight" readonly>
					                  </td>
					                </tr>
					                <tr>
					                  <th class="noBtBorder">회사에서 지급액</th>
					                  <td class="align_left noRtBorder noBtBorder"><input type="text" name="companyAmt" value="<%= WebUtil.printNumFormat(data.companyAmt)+" 원" %>" class="readOnly alignRight" readonly></td>
					                </tr>
					              </tbody>
					            </table>
					        </td>
				        </tr>
				        <tr>
				          <th>공제총액</th>
				          <td colspan="3"><input type="text" name="deductinTotal" value="<%= WebUtil.printNumFormat(data.deductinTotal)+" 원" %>" class="readOnly alignRight" readonly></td>
				        </tr>
				        <tr>
				          <th></th>
				          <td colspan="3">
					          <table class="innerTable">
					              <colgroup>
					              <col class="col_25p" />
					              <col class="col_75p" />
					              </colgroup>
					              <tbody>
					                <tr>
					                  <th>퇴직갑근세</th>
					                  <td><input type="text" name="incomeTax" value="<%= WebUtil.printNumFormat( data.incomeTax )+" 원" %>" class="readOnly alignRight" readonly></td>
					                </tr>
					                <tr>
					                  <th>퇴직주민세</th>
					                  <td><input type="text" name="residenceTax" value="<%= WebUtil.printNumFormat(data.residenceTax )+" 원" %>" class="readOnly alignRight" readonly></td>
					                </tr>
					                <tr>
					                  <th>퇴직전환금</th>
					                  <td><input type="text" name="O_NAPPR" value="<%= WebUtil.printNumFormat( data.O_NAPPR )+" 원" %>" class="readOnly alignRight" readonly></td>
					                </tr>
					                <tr>
					                  <th>채권가압류공제</th>
					                  <td><input type="text" name="O_BONDM" value="<%= WebUtil.printNumFormat( data.O_BONDM )+" 원" %>" class="readOnly alignRight" readonly></td>
					                </tr>
					                <tr>
					                  <th>주택자금공제</th>
					                  <td><input type="text" name="O_HLOAN" value="<%= WebUtil.printNumFormat( data.O_HLOAN )+" 원" %>" class="readOnly alignRight" readonly></td>
					                </tr>
					                <tr>
					                  <th>소액대출공제</th>
					                  <td><input type="text" name="O_SLOAN" value="<%= data.O_SLOAN.equals("") ? "0 원" : WebUtil.printNumFormat(Double.toString(Double.parseDouble(data.O_SLOAN) * 100.0 ))+" 원" %>" class="readOnly alignRight" readonly></td>
					                </tr> 
					                <tr>
					                  <th>구입전환일시지원금공제</th>
					                  <td><input type="text" name="O_GLOAN" value="<%= data.O_GLOAN.equals("") ? "0 원" : WebUtil.printNumFormat(Double.toString(Double.parseDouble(data.O_GLOAN) * 100.0 ))+" 원" %>" class="readOnly alignRight" readonly></td>
					                </tr>
					              </tbody>
					            </table>
				            </td>
				        </tr>
				        <tr>
				          <th>차감지급액</th>
				          <td colspan="3"><input type="text" name="balancedAmt" value="<%= WebUtil.printNumFormat( data.balancedAmt )+" 원" %>" class="readOnly alignRight" readonly>
				            <span class="noteItem colorRed">※ 화면상의 차감지급액은 실제 퇴직금과 다를 수 있습니다.</span></td>
				        </tr>
				      </tbody>
				    </table>
				  </div>
				</div>
				</form>
				<!--------------- layout body start --------------->
<script type="text/javascript">
	$(document).ready(function(){
		//search
		$(".icoSearch").click(function(){
			if(checkValid()) {
				$("#searchForm").attr("method", "POST");
				$("#searchForm").attr("action", "/salary/retirementSimul");
				$("#searchForm").submit();
			}
		});
		var checkValid = function (){
		    if($("#retireDate").val() == ""){
		        alert('예상퇴직일자를 입력하세요.');
		        $("#retireDate").focus();
		        return false;    
		    }
		    // 퇴직금기산일이 안나올 경우 문제가 됨.. ?????
		    var begin_date = removePoint($("#O_GIDAT").val());
		    var retireDate = removePoint($("#retireDate").val());

		    if(begin_date=='') return true;

		    dif = dayDiff(addSlash(begin_date), addSlash(retireDate));

		    if(dif <= 0){
		        alert('퇴직금기산일 이후의 예상퇴직일자를 입력해 주세요');
		        return false;
		    }
		    return true;
		}
	});
</script>

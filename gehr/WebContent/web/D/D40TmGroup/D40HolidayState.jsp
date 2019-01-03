<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 휴가사용현황							*/
/*   Program ID		: D40HolidayState.jsp									*/
/*   Description		: 근태집계표 - 휴가사용현황								*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%@ include file="/web/common/commonProcess.jsp" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);
	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자
	String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));
	String searchDeptNo =  WebUtil.nvl(request.getParameter("searchDeptNo"));
	String searchDeptNm =  WebUtil.nvl(request.getParameter("searchDeptNm"));

	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE

	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름
	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜
	String gubun    = (String)request.getAttribute("gubun");	//선택날짜


%>
<jsp:include page="/include/header.jsp" />

<script language="JavaScript">



	function excelDown(){

		//상단 공통 조회조건
	  	$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
		$("#searchDeptNm").val(parent.$("#searchDeptNm").val());
// 		$("#iSeqno").val(parent.$("#iSeqno").val());
// 		$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
		var iSeqno = "";
		if(parent.$("#iSeqno").val() == ""){
			parent.$("#iSeqno option").each(function(){
				iSeqno += $(this).val()+",";
			});
			$("#ISEQNO").val(iSeqno.slice(0, -1));
		}else{
			$("#ISEQNO").val( parent.$("#iSeqno").val());
		}
		if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
			$("#I_SELTAB").val("C");
		}else{
			$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
		}

		$("#I_PERNR").val(parent.$("#I_PERNR").val());
		$("#I_ENAME").val(parent.$("#I_ENAME").val());
		$("#I_SCHKZ").val(parent.$("#I_SCHKZ").val());
		$("#I_BEGDA").val(parent.$("#I_BEGDA").val());
		$("#I_ENDDA").val(parent.$("#I_ENDDA").val());
		$("#p_gubun").val(parent.$("#p_gubun").val());

		var val1 = parent.$("#I_BEGDA").val();
		var val2 = parent.$("#I_ENDDA").val();
		var dt = Number(parent.chkDt(val1, val2)+1);
		if(val1 == ""){
			alert("<spring:message code='MSG.D.D40.0034'/>");/* 조회기간 시작일은 필수 입니다. */
			$.unblockUI();
			return;
		}
		if(val2 == ""){
			alert("<spring:message code='MSG.D.D40.0035'/>");/* 조회기간 종료일은 필수 입니다. */
			$.unblockUI();
			return;
		}
		if(val1 > val2){
			alert("<spring:message code='MSG.D.D40.0036'/>");/* 조회 시작일이 종료일보다 클 수 없습니다. */
			$.unblockUI();
			return;
		}
		if(dt > 31){
			alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
			$.unblockUI();
			return;
		}else{
			var vObj = document.form1;
			$("#I_ACTTY").val("R");
			$("#gubun").val("EXCEL");
			vObj.target = "ifHidden";
		    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40HolidayStateSV";
		    vObj.method = "post";
		    vObj.submit();
 		}


	}

	function go_Rotationprint(){

		$("#orgOrTm").val(parent.$(':input:radio[name=orgOrTm]:checked').val());
		$("#searchDeptNo").val(parent.$("#searchDeptNo").val());
		$("#searchDeptNm").val(parent.$("#searchDeptNm").val());
// 		$("#iSeqno").val(parent.$("#iSeqno").val());
// 		$("#I_SELTAB").val(parent.$("#I_SELTAB").val());

		var iSeqno = "";
		if(parent.$("#iSeqno").val() == ""){
			parent.$("#iSeqno option").each(function(){
				iSeqno += $(this).val()+"-";
			});
			$("#ISEQNO").val(iSeqno.slice(0, -1));
		}else{
			$("#ISEQNO").val( parent.$("#iSeqno").val());
		}
		if(parent.$(':input:radio[name=orgOrTm]:checked').val() == "2"){
			$("#I_SELTAB").val("C");
		}else{
			$("#I_SELTAB").val(parent.$("#I_SELTAB").val());
		}

		$("#I_PERNR").val(parent.$("#I_PERNR").val());
		$("#I_ENAME").val(parent.$("#I_ENAME").val());
		$("#I_SCHKZ").val(parent.$("#I_SCHKZ").val());
		$("#I_BEGDA").val(parent.$("#I_BEGDA").val());
		$("#I_ENDDA").val(parent.$("#I_ENDDA").val());
		$("#p_gubun").val(parent.$("#p_gubun").val());

		var val1 = parent.$("#I_BEGDA").val();
		var val2 = parent.$("#I_ENDDA").val();
		var dt = Number(parent.chkDt(val1, val2)+1);
		if(val1 == ""){
			alert("<spring:message code='MSG.D.D40.0034'/>");/* 조회기간 시작일은 필수 입니다. */
			$.unblockUI();
			return;
		}
		if(val2 == ""){
			alert("<spring:message code='MSG.D.D40.0035'/>");/* 조회기간 종료일은 필수 입니다. */
			$.unblockUI();
			return;
		}
		if(val1 > val2){
			alert("<spring:message code='MSG.D.D40.0036'/>");/* 조회 시작일이 종료일보다 클 수 없습니다. */
			$.unblockUI();
			return;
		}
		if(dt > 31){
			alert("<spring:message code='MSG.D.D40.0037'/>");/* 조회기간 날짜의 차이는 31일 이내여야 합니다. */
			$.unblockUI();
			return;
		}else{

 			$("#I_ACTTY").val("R");
			$("#gubun").val("PRINT");

 			window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1300,height=662,left=0,top=2");

 		    document.form1.target = "essPrintWindow";
 		    document.form1.action = "<%=WebUtil.JspURL%>"+"D/D40TmGroup/common/printFrame_holidayState.jsp";
 		    document.form1.method = "post";
 		    document.form1.submit();
 		}
	}

	function clickTd(id, emp){
// 		alert(emp);
// 		alert($("#th"+id).val().replace(/\-/g,''));
		var dt = $("#th"+id).val();
		var $form = $('<form></form>');
		$form.attr('action', '<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailStatePopupSV');
		$form.attr('method', 'post');
		$form.attr('target', 'targetName');
		$form.appendTo('body');

		var emp = $('<input type="hidden" value="'+emp+'" name="I_PERNR">');
		var I_BEGDA = $('<input type="hidden" value="'+dt+'" name="I_BEGDA">');
		var I_ENDDA = $('<input type="hidden" value="'+dt+'" name="I_ENDDA">');

		$form.append(emp).append(I_BEGDA).append(I_ENDDA);

		var pop = window.open('', "targetName","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
		pop.focus();

		$form.submit();

	}

// 	function popupView(winName, width, height, pernr) {
// 		var formN = document.form1;
// 		formN.viewEmpno.value = pernr;

// 		var screenwidth = (screen.width-width)/2;
// 	    var screenheight = (screen.height-height)/2;
<%-- 	    var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr; --%>
// 		var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

// 	}

	$(function() {
		var height = document.body.scrollHeight;
		parent.autoResize(height);
	});

</script>

	<jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value ="Y"/>
        <jsp:param name="help" value="X04Statistics.html'"/>
    </jsp:include>

<form name="form1" method="post" onsubmit="return false">
	<input type="hidden" id="orgOrTm" name="orgOrTm" value="">
	<input type="hidden" id="searchDeptNo" name="searchDeptNo" value="<%=searchDeptNo%>">
	<input type="hidden" id="searchDeptNm" name="searchDeptNm" value="<%=searchDeptNm%>">
	<input type="hidden" id="iSeqno" name="iSeqno" value="">
	<input type="hidden" id="ISEQNO" name="ISEQNO" value="">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB" value="">
	<input type="hidden" id="gubun" name="gubun" value="">
	<input type="hidden" id="p_gubun" name="p_gubun" value="">
	<input type="hidden" id="pageGubun" name="pageGubun" value="">
	<input type="hidden" id="I_PERNR" name="I_PERNR" value="">
	<input type="hidden" id="I_ENAME" name="I_ENAME"   value="">
	<input type="hidden" id="I_SCHKZ" name="I_SCHKZ"   value="">
	<input type="hidden" id="I_BEGDA" name="I_BEGDA"   value="">
	<input type="hidden" id="I_ENDDA" name="I_ENDDA"   value="">
	<input type="hidden" name="viewEmpno" value="">

<%
	//부서명, 조회된 건수.
	if ( T_EXPORTA != null && T_EXPORTA.size() > 0 ) {
%>

	<div class="buttonArea">
       	<ul class="btn_mdl displayInline">
               <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
               <li><a href="javascript:go_Rotationprint();"><span><spring:message code='LABEL.F.F42.0002'/><!-- 인쇄 --></span></a></li>
           </ul>
	</div>
<%


    	//[CSR ID:3038270]
    	double sumOCCUR = 0.0;
    	double sumABWTG = 0.0;
    	double sumZKVRB = 0.0;
    	String allAVG = "0.00";
%>
    <div class="listArea">
    	<div class="listTop">
	  		<span class="listCnt">
	  			<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=WebUtil.nvl(searchDeptNm, user.e_obtxt)%> [ <%=WebUtil.nvl(searchDeptNo, user.e_objid)%> ]</h2>
	  		</span>
	  		<div style="position:relative; display:block; text-align:right; margin-right: 8px;margin-left: 2px;top:8px; ">
	  			<%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %>
	  		</div>
		</div>
    	<div class="table">
        	<div class="wideTable" >
            	<table class="listTable">
            		<thead>
                		<tr>
				            <th><!-- 이름 --><%=g.getMessage("LABEL.F.F41.0005")%></th>
		                	<th><!-- 사번 --><%=g.getMessage("LABEL.F.F41.0004")%></th>
				            <th><!-- 소속 --><%=g.getMessage("LABEL.F.F41.0006")%></th>
				            <th><!-- 직책 --><%=g.getMessage("LABEL.F.F41.0007")%></th>
						    <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
				    	    <%--<th><!-- 직위 --><%=g.getMessage("LABEL.F.F41.0008")%></th> --%>
							<th><!-- 직위/직급호칭 --><%=g.getMessage("MSG.A.A01.0083")%></th>
				             <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
<%-- 				            <th><!-- 직급 --><%=g.getMessage("LABEL.F.F41.0009")%></th> --%>
<%-- 				            <th><!-- 호봉 --><%=g.getMessage("LABEL.F.F41.0010")%></th> --%>
<%-- 				            <th><!-- 연차 --><%=g.getMessage("LABEL.F.F41.0011")%></th> --%>
				            <th><!-- 입사일자 --><%=g.getMessage("LABEL.F.F41.0012")%></th>
				            <th><!-- 발생일수 --><%=g.getMessage("LABEL.F.F41.0013")%></th>
				            <th><!--사용일수 --><%=g.getMessage("LABEL.F.F41.0014")%></th>
				            <th><!--잔여일수 --><%=g.getMessage("LABEL.F.F41.0015")%></th>
				            <th class="lastCol"><!-- 휴가사용율 --><%=g.getMessage("LABEL.F.F41.0016")%>(%)</th>
               	 		</tr>
              		</thead>
<%
		//전체 합계를 구함//[CSR ID:3038270]
		for( int i = 0; i < T_EXPORTA.size(); i++ ){
			D40HolidayStateData data = (D40HolidayStateData)T_EXPORTA.get(i);
			sumOCCUR += Double.parseDouble(data.OCCUR);
			sumABWTG += Double.parseDouble(data.ABWTG);
			sumZKVRB += Double.parseDouble(data.ZKVRB);
		}

		//평균 값 계산//[CSR ID:3038270]
		if(sumABWTG >0 && sumOCCUR>0){
			allAVG = WebUtil.printNumFormat((sumABWTG / sumOCCUR )*100,2);
		}else{
			allAVG = "0.00";
		}

	    for( int i = 0; i < T_EXPORTA.size(); i++ ){
	    	D40HolidayStateData data = (D40HolidayStateData)T_EXPORTA.get(i);
// 	        String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

	        //[CSR ID:3038270]
			String class1 = "";
			if(i%2 == 0){
				class1="oddRow";
            }else{
            	class1="";
            }
// 			if (Double.parseDouble(data.CONSUMRATE)>=Double.parseDouble(allAVG)) {
// 				class1 = "";
// 			} else {
// 				class1 = "bgcolor='#f8f5ed'";
// 			}
	%>
               	 		<tr class=<%=class1%>>
<%-- 				            <td <%=class1%>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td> --%>
				            <td><%= data.KNAME %></td>
				            <td><%= data.PERNR %></td>
				            <td><%= data.ORGTX %></td>
				            <td><%= data.TITL2 %></td>
				            <td><%= data.TITEL %></td>
<%-- 				            <td><%= data.TRFGR %></td> --%>
<%-- 				            <td><%= data.TRFST %></td> --%>
<%-- 				            <td><%= data.VGLST %></td> --%>
				            <td><%= (data.DAT01).equals("0000-00-00") ? "" : WebUtil.printDate(data.DAT01) %></td>
				            <td><%= WebUtil.printNumFormat(data.OCCUR,1) %></td>
				            <td><%= WebUtil.printNumFormat(data.ABWTG,1) %></td>
				            <td><%= WebUtil.printNumFormat(data.ZKVRB,1) %></td>
				            <td class="lastCol"><%= WebUtil.printNumFormat(data.CONSUMRATE,2) %></td>
          				</tr>

<%
		} //end for...
%>
          				<!-- //[CSR ID:3038270]  -->
          				<tr class="sumRow">
							<td class="td11" colspan="6"> <!-- 휴가 사용율 --><%=g.getMessage("LABEL.D.D40.0058")%></td>
							<td class="td11"><%=sumOCCUR %></td>
							<td class="td11"><%=sumABWTG %></td>
							<td class="td11" ><%=sumZKVRB %></td>
							<td class="td11"><%=allAVG %></td>
						</tr>
        			</table>
        		</div>
        	</div>
<%--         	<span class="commentOne">&nbsp;<!-- 건전한 휴가 사용 문화 정착을 위하여 조직책임자께서는  <font color="#CC3300" ><b><u>본인을 포함한</u></b></font> 조직 구성원 전체의 사전 휴가 계획 수립/관리 바랍니다. --><%=g.getMessage("MSG.F.F41.0001")%></span> --%>

<%
    }else{
%>
  	<div class="listArea">
        <div class="table">
	        <div class="wideTable" >
	            <table class="listTable">
	    			 <tr>
	    			 	<td class="lastCol"><spring:message code="MSG.COMMON.0004"/></td><!-- 해당하는 데이타가 존재하지 않습니다 -->
	    			 </tr>
	            </table>
	        </div>
        </div>
    </div>
<%
	} //end if...
%>
	</div>
</form>

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
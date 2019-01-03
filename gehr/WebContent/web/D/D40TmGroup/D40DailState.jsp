<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 일간										*/
/*   Program ID		: D40DailState.jsp										*/
/*   Description		: 근태집계표 - 일간											*/
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

	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));
	String sMenuCode =  (String)request.getAttribute("sMenuCode");

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE
	Vector T_EXPORTB    = (Vector)request.getAttribute("T_EXPORTB");	//근무계획표-DATA
	Vector T_EXPORTD    = (Vector)request.getAttribute("T_EXPORTD");	//근무계획표-날짜
	String E_DAY_CNT    = (String)request.getAttribute("E_DAY_CNT");	//일자수

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
		    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DailStateSV";
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
				if($(this).val() !=""){
					iSeqno += $(this).val()+"-";
				}
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
 		    document.form1.action = "<%=WebUtil.JspURL%>"+"D/D40TmGroup/common/printFrame_dailState.jsp";
 		    document.form1.method = "post";
 		    document.form1.submit();
 		}
	}

	function clickTd(id, emp){

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
	<input type="hidden" id="searchDeptNo" name="searchDeptNo" value="">
	<input type="hidden" id="searchDeptNm" name="searchDeptNm" value="">
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

<%
		if(T_EXPORTA.size() > 0){
%>

	<div class="buttonArea">
       	<ul class="btn_mdl displayInline">
               <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
               <li><a href="javascript:go_Rotationprint();"><span><spring:message code='LABEL.F.F42.0002'/><!-- 인쇄 --></span></a></li>
           </ul>
	</div>
<%
			D40DailStateData titleData = (D40DailStateData)T_EXPORTA.get(0);
			D40DailStateData hiddenData = (D40DailStateData)T_EXPORTD.get(0);

	        String tempDept = "";
	        for( int j = 0; j < T_EXPORTB.size(); j++ ){
	            D40DailStateData deptData = (D40DailStateData)T_EXPORTB.get(j);

	            //하위부서를 선택했을 경우 부서 비교.
	            if( !deptData.ORGEH.equals(tempDept) ){
%>
    <div class="listArea">
    	<div class="listTop">
	  		<span class="listCnt">
	  			<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> : <%=deptData.STEXT%> [<%=deptData.ORGEH%>]</h2>
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
<%--                   <th width="5%" rowspan="2" ><!-- 구분--><%=g.getMessage("LABEL.F.F42.0055")%></th> --%>
                  <th width="8%" rowspan="2" ><!-- 이름--><%=g.getMessage("LABEL.D.D12.0018")%></th>
                  <th width="8%" rowspan="2" ><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
                  <th width="7%" rowspan="2" ><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></th>
                  <th class="lastCol" colspan="<%=E_DAY_CNT%>" ><!-- 일일근태내용--><%=g.getMessage("LABEL.F.F43.0002")%>(<%=WebUtil.printDate(titleData.BEGDA)%>~<%=WebUtil.printDate(titleData.ENDDA)%>)</th>
                </tr>

                <tr>
                  <%= titleData.D1.equals("00") ? "" : "<th>"+titleData.D1+"<input type='hidden' id='th1' name='th1' value=\""+hiddenData.D1+"\"> </td>" %>
                  <%= titleData.D2.equals("00") ? "" : "<th>"+titleData.D2+"<input type='hidden' id='th2' name='th2' value=\""+hiddenData.D2+"\"> </td>" %>
                  <%= titleData.D3.equals("00") ? "" : "<th>"+titleData.D3+"<input type='hidden' id='th3' name='th3' value=\""+hiddenData.D3+"\"> </td>" %>
                  <%= titleData.D4.equals("00") ? "" : "<th>"+titleData.D4+"<input type='hidden' id='th4' name='th4' value=\""+hiddenData.D4+"\"> </td>" %>
                  <%= titleData.D5.equals("00") ? "" : "<th>"+titleData.D5+"<input type='hidden' id='th5' name='th5' value=\""+hiddenData.D5+"\"> </td>" %>
                  <%= titleData.D6.equals("00") ? "" : "<th>"+titleData.D6+"<input type='hidden' id='th6' name='th6' value=\""+hiddenData.D6+"\"> </td>" %>
                  <%= titleData.D7.equals("00") ? "" : "<th>"+titleData.D7+"<input type='hidden' id='th7' name='th7' value=\""+hiddenData.D7+"\"> </td>" %>
                  <%= titleData.D8.equals("00") ? "" : "<th>"+titleData.D8+"<input type='hidden' id='th8' name='th8' value=\""+hiddenData.D8+"\"> </td>" %>
                  <%= titleData.D9.equals("00") ? "" : "<th>"+titleData.D9+"<input type='hidden' id='th9' name='th9' value=\""+hiddenData.D9+"\"> </td>" %>
                  <%= titleData.D10.equals("00") ? "" : "<th>"+titleData.D10+"<input type='hidden' id='th10' name='th10' value=\""+hiddenData.D10+"\"> </td>" %>
                  <%= titleData.D11.equals("00") ? "" : "<th>"+titleData.D11+"<input type='hidden' id='th11' name='th11' value=\""+hiddenData.D11+"\"> </td>" %>
                  <%= titleData.D12.equals("00") ? "" : "<th>"+titleData.D12+"<input type='hidden' id='th12' name='th12' value=\""+hiddenData.D12+"\"> </td>" %>
                  <%= titleData.D13.equals("00") ? "" : "<th>"+titleData.D13+"<input type='hidden' id='th13' name='th13' value=\""+hiddenData.D13+"\"> </td>" %>
                  <%= titleData.D14.equals("00") ? "" : "<th>"+titleData.D14+"<input type='hidden' id='th14' name='th14' value=\""+hiddenData.D14+"\"> </td>" %>
                  <%= titleData.D15.equals("00") ? "" : "<th>"+titleData.D15+"<input type='hidden' id='th15' name='th15' value=\""+hiddenData.D15+"\"> </td>" %>
                  <%= titleData.D16.equals("00") ? "" : "<th>"+titleData.D16+"<input type='hidden' id='th16' name='th16' value=\""+hiddenData.D16+"\"> </td>" %>
                  <%= titleData.D17.equals("00") ? "" : "<th>"+titleData.D17+"<input type='hidden' id='th17' name='th17' value=\""+hiddenData.D17+"\"> </td>" %>
                  <%= titleData.D18.equals("00") ? "" : "<th>"+titleData.D18+"<input type='hidden' id='th18' name='th18' value=\""+hiddenData.D18+"\"> </td>" %>
                  <%= titleData.D19.equals("00") ? "" : "<th>"+titleData.D19+"<input type='hidden' id='th19' name='th19' value=\""+hiddenData.D19+"\"> </td>" %>
                  <%= titleData.D20.equals("00") ? "" : "<th>"+titleData.D20+"<input type='hidden' id='th20' name='th20' value=\""+hiddenData.D20+"\"> </td>" %>
                  <%= titleData.D21.equals("00") ? "" : "<th>"+titleData.D21+"<input type='hidden' id='th21' name='th21' value=\""+hiddenData.D21+"\"> </td>" %>
                  <%= titleData.D22.equals("00") ? "" : "<th>"+titleData.D22+"<input type='hidden' id='th22' name='th22' value=\""+hiddenData.D22+"\"> </td>" %>
                  <%= titleData.D23.equals("00") ? "" : "<th>"+titleData.D23+"<input type='hidden' id='th23' name='th23' value=\""+hiddenData.D23+"\"> </td>" %>
                  <%= titleData.D24.equals("00") ? "" : "<th>"+titleData.D24+"<input type='hidden' id='th24' name='th24' value=\""+hiddenData.D24+"\"> </td>" %>
                  <%= titleData.D25.equals("00") ? "" : "<th>"+titleData.D25+"<input type='hidden' id='th25' name='th25' value=\""+hiddenData.D25+"\"> </td>" %>
                  <%= titleData.D26.equals("00") ? "" : "<th>"+titleData.D26+"<input type='hidden' id='th26' name='th26' value=\""+hiddenData.D26+"\"> </td>" %>
                  <%= titleData.D27.equals("00") ? "" : "<th>"+titleData.D27+"<input type='hidden' id='th27' name='th27' value=\""+hiddenData.D27+"\"> </td>" %>
                  <%= titleData.D28.equals("00") ? "" : "<th>"+titleData.D28+"<input type='hidden' id='th28' name='th28' value=\""+hiddenData.D28+"\"> </td>" %>
                  <%= titleData.D29.equals("00") ? "" : "<th>"+titleData.D29+"<input type='hidden' id='th29' name='th29' value=\""+hiddenData.D29+"\"> </td>" %>
                  <%= titleData.D30.equals("00") ? "" : "<th>"+titleData.D30+"<input type='hidden' id='th30' name='th30' value=\""+hiddenData.D30+"\"> </td>" %>
                  <%= titleData.D31.equals("00") ? "" : "<th class=lastCol>"+titleData.D31+"<input type='hidden' id='th31' name='th31' value=\""+hiddenData.D31+"\"> </td>" %>
                </tr>
              </thead>
	<%
		                String preEmpNo = "";
		                int cnt = 0;
		                for( int i = j; i < T_EXPORTB.size(); i++ ){
		                	D40DailStateData data = (D40DailStateData)T_EXPORTB.get(i);
		                    String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

		                    String tr_class = "";


		                    if( data.ORGEH.equals(deptData.ORGEH) ){
			                    if(cnt%2 == 0){
			                        tr_class="oddRow";
			                    }else{
			                        tr_class="";
			                    }
		                        cnt++;
	%>
            <tr class="<%=tr_class%>">
<%--               <td ><%=cnt%>&nbsp;&nbsp;</td> --%>
              <td class="align_left" nowrap> <%=data.ENAME%></td>
              <td ><%=data.PERNR%></td>
              <td ><%=WebUtil.printNumFormat(data.REMA_HUGA,1)%></td>
              <%= titleData.D1.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(1, \""+PERNR+"\")'>"+data.D1+"</td>" %>
              <%= titleData.D2.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(2, \""+PERNR+"\")'>"+data.D2+"</td>" %>
              <%= titleData.D3.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(3, \""+PERNR+"\")'>"+data.D3+"</td>" %>
              <%= titleData.D4.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(4, \""+PERNR+"\")'>"+data.D4+"</td>" %>
              <%= titleData.D5.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(5, \""+PERNR+"\")'>"+data.D5+"</td>" %>
              <%= titleData.D6.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(6, \""+PERNR+"\")'>"+data.D6+"</td>" %>
              <%= titleData.D7.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(7, \""+PERNR+"\")'>"+data.D7+"</td>" %>
              <%= titleData.D8.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(8, \""+PERNR+"\")'>"+data.D8+"</td>" %>
              <%= titleData.D9.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(9, \""+PERNR+"\")'>"+data.D9+"</td>" %>
              <%= titleData.D10.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(10, \""+PERNR+"\")'>"+data.D10+"</td>" %>
              <%= titleData.D11.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(11, \""+PERNR+"\")'>"+data.D11+"</td>" %>
              <%= titleData.D12.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(12, \""+PERNR+"\")'>"+data.D12+"</td>" %>
              <%= titleData.D13.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(13, \""+PERNR+"\")'>"+data.D13+"</td>" %>
              <%= titleData.D14.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(14, \""+PERNR+"\")'>"+data.D14+"</td>" %>
              <%= titleData.D15.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(15, \""+PERNR+"\")'>"+data.D15+"</td>" %>
              <%= titleData.D16.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(16, \""+PERNR+"\")'>"+data.D16+"</td>" %>
              <%= titleData.D17.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(17, \""+PERNR+"\")'>"+data.D17+"</td>" %>
              <%= titleData.D18.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(18, \""+PERNR+"\")'>"+data.D18+"</td>" %>
              <%= titleData.D19.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(19, \""+PERNR+"\")'>"+data.D19+"</td>" %>
              <%= titleData.D20.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(20, \""+PERNR+"\")'>"+data.D20+"</td>" %>
              <%= titleData.D21.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(21, \""+PERNR+"\")'>"+data.D21+"</td>" %>
              <%= titleData.D22.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(22, \""+PERNR+"\")'>"+data.D22+"</td>" %>
              <%= titleData.D23.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(23, \""+PERNR+"\")'>"+data.D23+"</td>" %>
              <%= titleData.D24.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(24, \""+PERNR+"\")'>"+data.D24+"</td>" %>
              <%= titleData.D25.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(25, \""+PERNR+"\")'>"+data.D25+"</td>" %>
              <%= titleData.D26.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(26, \""+PERNR+"\")'>"+data.D26+"</td>" %>
              <%= titleData.D27.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(27, \""+PERNR+"\")'>"+data.D27+"</td>" %>
              <%= titleData.D28.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(28, \""+PERNR+"\")'>"+data.D28+"</td>" %>
              <%= titleData.D29.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(29, \""+PERNR+"\")'>"+data.D29+"</td>" %>
              <%= titleData.D30.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(30, \""+PERNR+"\")'>"+data.D30+"</td>" %>
              <%= titleData.D31.equals("00") ? "" : "<td style='cursor: pointer;' onclick='javascript:clickTd(31, \""+PERNR+"\")' class=lastCol>"+data.D31+"</td>" %>
            </tr>

	<%
		                    }//end if
		                } //end for...
	%>
            </table>
        </div>
        </div>
    </div>
<%
                //부서코드 비교를 위한 값.
	                tempDept = deptData.ORGEH;
	            }//end if
	        }//end for
%>

<h2 class="subtitle"><!-- 근태유형 및 단위--><spring:message code="LABEL.D.D12.0036"/></h2>

<div class="listArea">
	<div class="table">
		<table class="listTable">
			<colgroup>
				<col width="16%" />
				<col width="42%" />
				<col width="42%" />
<!-- 				<col width="10%" /> -->
			</colgroup>
			<thead>
				<tr>
					<th>&nbsp;</th>
                   	<th><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></th>
                   	<th class="lastCol"><!-- 일수--><%=g.getMessage("LABEL.F.F42.0047")%></th>
<%--                    	<th class="lastCol"><!-- 횟수--><%=g.getMessage("LABEL.F.F42.0049")%></th> --%>
				</tr>
			</thead>
			<tr class="oddRow">
				<td class="align_center"><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></td>
				<td style="text-align: left; padding-left: 20px;">
                  	L:<spring:message code="LABEL.D.D40.0126"/><!-- 시간공가 --> U:<spring:message code="LABEL.D.D40.0127"/><!-- 휴일근무 --> <br/>
					W:<spring:message code="LABEL.D.D40.0128"/><!-- 모성보호휴가 --> <br/>
					O:<spring:message code="LABEL.D.D40.0142"/><!-- 지각 --> P:<spring:message code="LABEL.D.D40.0143"/><!-- 조퇴 --> Q:<spring:message code="LABEL.D.D40.0144"/><!-- 외출 -->
				</td>
				<td style="text-align: left; padding-left: 20px;" class="lastCol">
                   	D:<spring:message code="LABEL.D.D40.0129"/><!-- 반일휴가(전반) --> E:<spring:message code="LABEL.D.D40.0130"/><!-- 반일휴가(후반) --> F:<spring:message code="LABEL.D.D40.0131"/><!-- 보건휴가 --><br/>
					C:<spring:message code="LABEL.D.D40.0132"/><!-- 전일휴가 --> G:<spring:message code="LABEL.D.D40.0133"/><!-- 경조휴가 --> H:<spring:message code="LABEL.D.D40.0134"/><!-- 하계휴가 --><br/>
					J:<spring:message code="LABEL.D.D40.0136"/><!-- 산전후휴가 --> K:<spring:message code="LABEL.D.D40.0137"/><!-- 전일공가 --> M:<spring:message code="LABEL.D.D40.0138"/><!-- 유급결근 --> N:<spring:message code="LABEL.D.D40.0139"/><!-- 무급결근   --><br/>
					V:<spring:message code="LABEL.D.D40.0135"/><!-- 근속여행공가 --> R:<spring:message code="LABEL.D.D40.0140"/><!-- 휴직/공상  --> S:<spring:message code="LABEL.D.D40.0141"/><!-- 산재 -->
				</td>
<!-- 				<td class="lastCol" > -->
<%--                    	O:<spring:message code="LABEL.D.D40.0142"/><!-- 지각 --><br/> --%>
<%-- 					P:<spring:message code="LABEL.D.D40.0143"/><!-- 조퇴 --><br/> --%>
<%-- 					Q:<spring:message code="LABEL.D.D40.0144"/><!-- 외출 --> --%>
<!-- 				</td> -->
			</tr>
			<tr>
				<td class="align_center"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></td>
				<td>&nbsp;</td>
				<td style="text-align: left; padding-left: 20px;">
                   	A:<spring:message code="LABEL.D.D40.0145"/><!-- 교육(근무시간내)--> B:<spring:message code="LABEL.D.D40.0146"/><!-- 출장 -->
				</td>
				<td class="lastCol">&nbsp;</td>
			</tr>
			<tr class="oddRow">
				<td class="align_center"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></td>
				<td style="text-align: left; padding-left: 20px;">
                   	OA:<spring:message code="LABEL.D.D40.0147"/><!-- 휴일특근 --> OC:<spring:message code="LABEL.D.D40.0148"/><!-- 명절특근 --> OE:<spring:message code="LABEL.D.D40.0149"/><!-- 휴일연장 --> OF:<spring:message code="LABEL.D.D40.0150"/><!-- 연장근무 --><br/>
					OG:<spring:message code="LABEL.D.D40.0151"/><!-- 야간근로 -->
				</td>
				<td class="lastCol">&nbsp;</td>
<!-- 				<td>&nbsp;</td> -->
			</tr>
			<tr>
				<td class="align_center"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></td>
				<td style="text-align: left; padding-left: 20px;">
                   	EA:<spring:message code="LABEL.D.D40.0152"/><!-- 향군(근무시간외)--> EB:<spring:message code="LABEL.D.D40.0153"/><!-- 교육(근무시간외)-->
				</td>
				<td class="lastCol">&nbsp;</td>
<!-- 				<td>&nbsp;</td> -->
			</tr>
		</table>
	</div>
</div>
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
		}
%>
</form>

<iframe name="ifHidden" width="0" height="0" /></iframe>

<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />
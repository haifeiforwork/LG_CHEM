<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 월간										*/
/*   Program ID		: D40MonthState.jsp										*/
/*   Description		: 근태집계표 - 월간											*/
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
	Vector T_EXPORTC    = (Vector)request.getAttribute("T_EXPORTC");	//월간집계표 DATA
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
				if($(this).val() !=""){
					iSeqno += $(this).val()+",";
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
		if(dt > 365){
			alert("조회기간 날짜의 차이는 365일 이내여야 합니다.");/* 조회기간 날짜의 차이는 365일 이내여야 합니다. */
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
		if(dt > 365){
			alert("조회기간 날짜의 차이는 365일 이내여야 합니다.");/* 조회기간 날짜의 차이는 365일 이내여야 합니다. */
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
	if(T_EXPORTC.size() > 0){
%>

	<div class="buttonArea">
       	<ul class="btn_mdl displayInline">
               <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
               <li><a href="javascript:go_Rotationprint();"><span><spring:message code='LABEL.F.F42.0002'/><!-- 인쇄 --></span></a></li>
           </ul>
	</div>
<%
		String tempDept = "";
        for( int j = 0; j < T_EXPORTC.size(); j++ ){
        	D40DailStateData deptData = (D40DailStateData)T_EXPORTC.get(j);

            //하위부서를 선택했을 경우 부서 비교.
            if( !deptData.ORGEH.equals(tempDept) ){
%>

    <div class="listArea">
    	<div class="listTop">
	  		<span class="listCnt">
	  			<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> :	<%=deptData.STEXT%> [<%=deptData.ORGEH%>]</h2>
	  		</span>
	  		<div style="position:relative; display:block; text-align:right; margin-right: 8px;margin-left: 2px;top:8px; ">
	  			<%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %>
	  		</div>
		</div>
        <div class="table">
            <table class="listTable">
            <thead>
                <tr>
                  <th rowspan="3"><!-- 이름--><%=g.getMessage("LABEL.D.D12.0018")%></th>
                  <th rowspan="3"><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
                  <th rowspan="3"><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></th>
                  <th colspan="23" class="lastCol"><!-- 근태집계--><%=g.getMessage("LABEL.F.F42.0005")%></th>
                </tr>
                <tr>
                  <th colspan="11"><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></th>
                  <th colspan="2"><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></th>
                  <th colspan="6"><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></th>
                  <th colspan="2"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></th>
                  <th colspan="2" class="lastCol"><!-- 공수--><%=g.getMessage("LABEL.F.F42.0010")%></th>
                </tr>
                <tr>
                  <th ><!-- 휴가--><%=g.getMessage("LABEL.F.F41.0011")%></th>
                  <th><!-- 경조--><%=g.getMessage("LABEL.F.F42.0012")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 하계--><%=g.getMessage("LABEL.F.F42.0013")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 보건--><%=g.getMessage("LABEL.F.F42.0014")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 모성--><%=g.getMessage("LABEL.F.F42.0015")%><br/><!--보호--><%=g.getMessage("LABEL.F.F42.0017")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
                  <th><!-- 공가--><%=g.getMessage("LABEL.F.F42.0016")%></th>
                  <th><!-- 결근--><%=g.getMessage("LABEL.F.F42.0018")%></th>
                  <th><!-- 지각--><%=g.getMessage("LABEL.F.F42.0019")%></th>
                  <th><!-- 조퇴--><%=g.getMessage("LABEL.F.F42.0020")%></th>
                  <th><!-- 외출--><%=g.getMessage("LABEL.F.F42.0021")%></th>
                  <th><!-- 무노동--><%=g.getMessage("LABEL.F.F42.0022")%><br/><!-- 무임금--><%=g.getMessage("LABEL.F.F42.0023")%> </th>
                  <th><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%></th>
                  <th><!-- 출장--><%=g.getMessage("LABEL.F.F42.0025")%></th>
                  <th><!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%></th>
<%--                   <th><!-- 토요--><%=g.getMessage("LABEL.F.F42.0028")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%></th> --%>
                  <th><!-- 명절--><%=g.getMessage("LABEL.F.F42.0029")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%><br /> </th>
<%--                   <th><!-- 명절--><%=g.getMessage("LABEL.F.F42.0029")%><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%><br><!-- (토)--><%=g.getMessage("LABEL.F.F42.0030")%></th> --%>
                  <th><!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%></th>
                  <th><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></th>
                  <th><!--야간--><%=g.getMessage("LABEL.F.F42.0033")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></th>
                  <th><!-- 당직--><%=g.getMessage("LABEL.F.F42.0034")%></th>
                  <th><!-- 항군--><%=g.getMessage("LABEL.F.F42.0035")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%> </th>
                  <th><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%> </th>
                  <th><!-- 금액--><%=g.getMessage("LABEL.F.F42.0037")%></th>
                  <th class="lastCol"><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></th>
                </tr>
			</thead>
<%
				int rowCnt = 0;
                for( int i = j; i < T_EXPORTC.size(); i++ ){
                	D40DailStateData data = (D40DailStateData)T_EXPORTC.get(i);
                    String PERNR =  AESgenerUtil.encryptAES(data.PERNR,request); //암호화를 위해

                    String tr_class = "";
                    String td_class ="";

                    if(rowCnt%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }
                    rowCnt++;
                    //합계부분에 명수 보여주는 부분.
                    if (data.ENAME.equals("TOTAL")) {
                        for (int h = 0; h < 8; h++) {
                            if( !data.PERNR.substring(h, h+1).equals("0") ){
                                data.PERNR = "( "+ data.PERNR.substring(h, 8) + " )"+g.getMessage("LABEL.F.F42.0058");
                                break;
                            }
                        }
                    }
                    if (data.ENAME.equals("TOTAL")) {
                    	td_class ="td11";
                    }

%>
                <tr class="<%=tr_class%>">
                  <td nowrap class="<%=td_class%>"><%=data.ENAME    %></td>
                  <td class="<%=td_class%>"><%=data.PERNR    %></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.REMA_HUGA,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HUGA     ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.KHUGA    ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HHUGA    ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.BHUG     ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.MHUG     ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.GONGA    ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.KYULKN   ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.JIGAK    ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.JOTAE    ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.WECHUL   ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.MUNO     ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.GOYUK    ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.CHULJANG ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HTKGUN   ,2)%></td>
<%--                   <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.TTKGUN   ,1)%></td> --%>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.MTKGUN   ,2)%></td>
<%--                   <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.MTKGUN_T ,1)%></td> --%>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HYUNJANG ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.YUNJANG  ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.YAGAN    ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.DANGJIC  ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.HYANGUN  ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.KOYUK    ,2)%></td>
                  <td class="<%=td_class%>"><%=WebUtil.printNumFormat(data.KONGSU   ,2)%></td>
                  <td class="lastCol  <%=td_class%>"><%=WebUtil.printNumFormat(data.KONGSU_HOUR,2)%></td>
                </tr>
<%                  //마자막 합계 데이터 일 경우.
                    if (data.ENAME.equals("TOTAL")) {
                    	rowCnt = 0;
                        break;
                    }
                } //end for...
%>
            </table>
        </div>

    </div>
<%
                //부서코드 비교를 위한 값.
                tempDept = deptData.ORGEH;
            }//end if
        }//end for
%>
        <div class="commentsMoreThan2">
            <div><%=g.getMessage("LABEL.F.F42.0039")%></div>
        </div>
    <h2 class="subtitle"><!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%></h2>

	<div class="listArea">
		<div class="table">
			<table class="listTable">
			   <thead>
				<tr>
		            <th colspan="2"><!-- 근태유형--><%=g.getMessage("LABEL.F.F42.0041")%> </th>
		            <th><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0084")%> </th>
		            <th><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%> </th>
		            <th><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%> </th>
		            <th class="lastCol"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%> </th>
				</tr>
				</thead>
		          <tr class="oddRow">
		            <td class="align_center" width="40" rowspan="3" style="background:#fff;"><!-- 단위--><%=g.getMessage("LABEL.F.F42.0042")%> </td>
		            <td class="align_center" width="40" ><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%> </td>
		            <td style="text-align: left; padding-left: 20px;"><!-- 시간공가, 휴일비근무, 비근무<br>모성보호휴가 --><%=g.getMessage("LABEL.F.F42.0043")%></td>
		            <td class="align_center" rowspan="3"  style="background:#fff;"><!-- 교육, 출장 --><%=g.getMessage("LABEL.F.F42.0044")%></td>
		            <td style="text-align: left; padding-left: 20px;"><!-- 휴일특근, 명절특근, 휴일연장,연장근로, <br>
		               야간근로, 야간근로(명절) --><%=g.getMessage("LABEL.D.D40.0056")%> </td>
		            <td class="lastCol" style="text-align: left; padding-left: 20px;"><!-- 향군(근무시간외),<br />
		              교육(근무시간외) --> <%=g.getMessage("LABEL.F.F42.0046")%></td>
		          </tr>
		          <tr>
		            <td class="align_center"><!-- 일수 --><%=g.getMessage("LABEL.F.F42.0047")%></td>
		            <td style="text-align: left; padding-left: 20px;"><!-- 반일휴가(전반/후반), 토요휴가, 전일휴가,<br>
		              경조휴가, 하계휴가,보건휴가, 출산전후휴가,<br>전일공가, 유급결근, 무급결근, 전일공가 --><%=g.getMessage("LABEL.F.F42.0048")%></td>
		            <td>&nbsp;</td>
		            <td class="lastCol">&nbsp;</td>
		          </tr>
		          <tr class="oddRow">
		            <td class="align_center"><!-- 횟수 --><%=g.getMessage("LABEL.F.F42.0049")%></td>
		            <td style="text-align: left; padding-left: 20px;"><!-- 지각, 조퇴, 외출 --><%=g.getMessage("LABEL.F.F42.0050")%></td>
		            <td>&nbsp;</td>
		            <td class="lastCol">&nbsp;</td>
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
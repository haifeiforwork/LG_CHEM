<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
/******************************************************************************/
/*                                                                          			    */
/*   System Name  : MSS                                               	      */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :  근태그룹정의                                                           */
/*   Program Name : 근태그룹인원지정 팝업                                                 */
/*   Program ID   : OrganListPop.jsp                                       */
/*   Description  : 근태그룹인원지정 PopUp                                           */
/*   Note         : 사용안함 페이지 이동으로 처리                                                        */
/*   Creation     : 2017-12-08  정준현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>

<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.ss.usermodel.CellStyle" %>
<%@ page import="org.apache.poi.ss.usermodel.Font" %>
<%@ page import="org.apache.poi.ss.usermodel.Row" %>
<%@ page import="org.apache.poi.ss.usermodel.Sheet" %>
<%@ page import="org.apache.poi.ss.usermodel.Workbook" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>

<%@ include file="/web/common/popupPorcess.jsp" %>
<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	String gubun = WebUtil.nvl(request.getParameter("gubun"));
	String paramSEQNO = WebUtil.nvl(request.getParameter("paramSEQNO"));
	String paramTIME_GRUP = WebUtil.nvl(request.getParameter("paramTIME_GRUP"));
	String paramBEGDA = WebUtil.nvl(request.getParameter("paramBEGDA"));
	String paramPABRJ = WebUtil.nvl(request.getParameter("I_PABRJ"));
	String paramPABRP = WebUtil.nvl(request.getParameter("I_PABRP"));

	//저장
	if("SAVE".equals(gubun)){
		Vector save_vt = new Vector();
		String SPERNR[] = request.getParameterValues("SPERNR");
		if(SPERNR != null){
			for (int i = 0; i <  SPERNR.length; i++) {
				D40TmGroupPersData data = new D40TmGroupPersData();
				data.SPERNR = WebUtil.nvl(SPERNR[i]);
				save_vt.addElement(data);
			}
		}
		Vector save_ret = (new D40TmGroupPersRFC()).saveTmGroupPersList(user.empNo, "2", paramPABRJ, paramPABRP, paramSEQNO, save_vt);
	}

	Vector ret = (new D40TmGroupPersRFC()).getTmGroupPersList(user.empNo, "1", paramPABRJ, paramPABRP, paramSEQNO);
	Vector vt = (Vector)ret.get(0);
	String E_RETURN = WebUtil.nvl((String)ret.get(1));
	String E_MESSAGE = WebUtil.nvl((String)ret.get(2));
	int cnt = vt.size();

// 	if("EXCEL".equals(gubun)){


//     }

%>

<jsp:include page="/include/header.jsp" />

<script>
	var rowindex = '<%=cnt%>';
	//사원검색 Popup.
	function organ_search() {
	    var frm = document.form1;
	    small_window=window.open("","Organ","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
	    small_window.focus();
	    document.form1.target = "Organ";
	    document.form1.pageGubun.value = "A";
	    document.form1.action = "<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListFramePop.jsp";
	    document.form1.submit();
	}

	function spernr_search(){
		$("#returnGubun").val("ALL");
	    document.form1.target = "ifHidden";
	    document.form1.action = "<%=WebUtil.JspURL%>D/D40TmGroup/D40OrganListHiddenPop.jsp";
	    document.form1.submit();
	}

	function name_search(obj, b, c){
		var val = obj.value;
		if (val.match(/^\d+$/gi) == null) {
	    	alert('<spring:message code="MSG.D.D40.0004"/>'); /* 사번은 숫자만 넣으세요! */
	    	obj.select();
	        return;
	    }
		$("#returnGubun").val("ONE");
		$("#rowindex").val(c);
		$("#pop_SPERNR").val(obj.value);
		document.form1.target = "ifHidden";
	    document.form1.action = "<%=WebUtil.JspURL%>D/D40TmGroup/D40OrganListHiddenPop.jsp";
	    document.form1.submit();
	}

	function do_save(){
		saveBlockFrame();
		$("#gubun").val("SAVE");
		document.form1.action = "<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListPop.jsp";
		document.form1.method = "post";
		document.form1.target = "_self";
		document.form1.submit();
	}

	function excelDown(){
		var vObj = document.form1;
		$("#gubun").val("EXCEL");
	    vObj.target = "ifHidden";
	    vObj.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmGroupFramePersSV";
// 	    vObj.action = "${g.jsp}D/D40TmGroup/D40TmGroupPersExcel.jsp";
	    vObj.method = "post";
	    vObj.submit();
	}

	function deleteRow(){
		$("input[name=chkbutton]:checked").each(function() {
			$("#tr"+$(this).val()).remove();
		});
	}

	function saveBlockFrame() {
        $.blockUI({ message : '<spring:message code="MSG.D.D40.0001"/>' });
    }

	function closePop(){
		opener.showList();
		self.close();
	}

</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
	<form name="form1" method="post" action="">
		<input type="hidden" id="pop_SPERNR" name="pop_SPERNR">
		<input type="hidden" id="pop_SPERNR_TX" name="pop_SPERNR_TX">
		<input type="hidden" id="pop_ORGEH_TX" name="pop_ORGEH_TX">
		<input type="hidden" id="pageGubun" name="pageGubun">
		<input type="hidden" id="returnGubun" name="returnGubun">
		<input type="hidden" id="rowindex" name="rowindex">
		<input type="hidden" id="rowcount" name="rowcount" value="<%=cnt%>">
		<input type="hidden" id="gubun" name="gubun">
		<input type="hidden" id="deptNo" name="deptNo">
		<input type="hidden" id="I_SELTAB" name="I_SELTAB">
		<input type="hidden" id="I_ENAME" name="I_ENAME">
		<input type="hidden" id="I_PERNR" name="I_PERNR">

		<input type="hidden" id="paramSEQNO" name="paramSEQNO" value="<%=paramSEQNO%>">
		<input type="hidden" id="paramTIME_GRUP" name="paramTIME_GRUP" value="<%=paramTIME_GRUP%>">
		<input type="hidden" id="paramBEGDA" name="paramBEGDA" value="<%=paramBEGDA%>">
		<input type="hidden" id="I_PABRJ" name="I_PABRJ" value="<%=paramPABRJ%>">
		<input type="hidden" id="I_PABRP" name="I_PABRP" value="<%=paramPABRP%>">

		<div class="winPop">
			<div class="header">
		    	<span><spring:message code="LABEL.D.D40.0011"/> <%--근태그룹인원지정--%></span>
		    	<a href="javascript:closePop()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
		    </div>

			<div class="body">

				<div class="tableArea" >
	    			<div class="table">
	      				<table class="tableGeneral">
				      	<colgroup>
					      	<col width=15%/>
					      	<col width=25%/>
					      	<col width=15%/>
					      	<col width=15%/>
					      	<col width=15%/>
					      	<col width=15%/>
				      	</colgroup>
						<tr>
				        	<th style="text-align: center;"><spring:message code="LABEL.D.D40.0004"/></th><!-- 근태그룹 -->
				          	<td><%=paramTIME_GRUP%></td>
				          	<th style="text-align: center;"><spring:message code="LABEL.D.D40.0016"/></th><!--입력자  -->
				          	<td><%=user.ename %></td>
				          	<th style="text-align: center;"><spring:message code="LABEL.D.D40.0006"/></th><!-- 적용일자 -->
				          	<td><%=paramBEGDA %></td>
				        </tr>
				      	</table>
					</div>
				</div>

    			<div class="listArea">
    				<div class="listTop">
		            	<div class="buttonArea">
			                <ul class="btn_mdl displayInline" style="margin-left: 10px;">
			                    <li><a class="search" onclick="organ_search();"><span><spring:message code="BUTTON.D.D40.0003" /><%-- 인원추가 --%></span></a></li>
			                    <li><a class="search" onclick="deleteRow()"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><%-- 행삭제 --%></span></a></li>
			                    <li><a class="search" onclick="excelDown()"><span><spring:message code="BUTTON.D.D40.0002" /><%-- 엑셀다운로드 --%></span></a></li>
					            <li><a class="darken" onclick="do_save();"><span><spring:message code="BUTTON.COMMON.SAVE" /><!-- 저장 --></span></a></li>
			                </ul>
		            	</div>
		        	</div>
    				<div class="table" style="overflow-x:hidden; overflow-y:auto; width: 990px; height: 340px;">
      					<table class="listTable" id="tmGroupTable" style="width: 990px">
      			   			<colgroup>
						      	<col width=6%/>
						      	<col width=8%/>
						      	<col width=8%/>
						      	<col width=10%/>
						      	<col width=22%/>
						      	<col width=22%/>
						      	<col width=10%/>
						      	<col width=10%/>
					      	</colgroup>
      			   			<thead>
			        		<tr>
			          			<th><spring:message code='LABEL.D.D11.0047' /><!-- 선택 --></th>
			           			<th><spring:message code='LABEL.D.D12.0017' /><!-- 사번 --></th>
			           			<th><spring:message code='LABEL.D.D12.0018' /><!-- 이름 --></th>
			           			<th><spring:message code='LABEL.COMMON.0016' /><!-- 입력일자 --></th>
			           			<th><spring:message code='LABEL.D.D12.0051' /><!-- 부서 --></th>
			           			<th><spring:message code='LABEL.D.D40.0013' /><!-- 현부서 --></th>
			           			<th><spring:message code='LABEL.D.D40.0014' /><!-- 현부서일자 --></th>
			          			<th class="lastCol"><spring:message code='LABEL.D.D40.0015' /><!-- 퇴직일자 --></th>
			        		</tr>
			        		</thead>
<%

					if( vt != null && vt.size() > 0 ){
						for( int i = 0; i < vt.size(); i++ ) {
							D40TmGroupPersData data = (D40TmGroupPersData)vt.get(i);
					        String tr_class = "";
					        if(i%2 == 0){
					            tr_class="oddRow";
					        }else{
					            tr_class="";
					        }
%>
							<tr class="<%=tr_class%>" id="tr<%=i%>">
					      		<td>
					      			<input type="checkbox" name="chkbutton" class="chkbox" value="<%=i%>">
					      			<input type="hidden" id="SPERNR<%=i%>" name="SPERNR" value="<%= data.SPERNR%>" maxlength="8" onblur="javascript:name_search(this,'1','<%=i%>');" style="width: 90%" ><!-- 사번 -->
<%-- 					      			<input type="hidden" id="SORGEH" name="SORGEH" value="<%= data.SORGEH%>" ><!-- 생성시 소속부서 코드 --> --%>
<%-- 					      			<input type="hidden" id="PERSG" name="PERSG" value="<%= data.PERSG%>" ><!-- 구분코드 --> --%>
<%-- 					      			<input type="hidden" id="PERSG_TX" name="PERSG_TX" value="<%= data.PERSG_TX%>" ><!-- 구분텍스트 --> --%>
<%-- 					      			<input type="hidden" id="PERSG_DT" name="PERSG_DT" value="<%= data.PERSG_DT%>" ><!-- 구분일자 --> --%>
<%-- 					      			<input type="hidden" id="AEZET" name="AEZET" value="<%= data.AEZET%>" ><!-- 최종변경시간 --> --%>
<%-- 					      			<input type="hidden" id="UNAME" name="UNAME" value="<%= data.UNAME%>" ><!-- 사용자이름 --> --%>
					      		</td>
					      		<td id="SPERNR<%=i%>">
					      			<%= data.SPERNR%>
					      		</td>
					      		<td id="SPERNR_TX<%=i%>">
					      			<%= data.SPERNR_TX%>
<%-- 					      			<input type="hidden" id="SPERNR_TX" name="SPERNR_TX" value="<%= data.SPERNR_TX%>" ><!--이름  --> --%>
					      		</td>
					      		<td>
					      			<%= data.OBEGDA.replace("-",".")%>
<%-- 					      			<input type="hidden" id="OBEGDA" name="OBEGDA" value="<%= data.OBEGDA.replace("-","")%>" ><!-- 입력일자 --> --%>
					      		</td>
					      		<td>
					      			<%= data.SORGEH_TX%>
<%-- 					      			<input type="hidden" id="SORGEH_TX" name="SORGEH_TX" value="<%= data.SORGEH_TX%>"  ><!-- 부서 --> --%>
					      		</td>
					      		<td id="ORGEH_TX<%=i%>">
					      			<%= data.ORGEH_TX%>
<%-- 					      			<input type="hidden" id="ORGEH_TX" name="ORGEH_TX" value="<%= data.ORGEH_TX%>" ><!-- 현부서 --> --%>
					      		</td>
					      		<td>
					      			<%= data.ORGEH_DT.replace("-",".")%>
<%-- 					      			<input type="hidden" id="ORGEH_DT" name="ORGEH_DT" value="<%= data.ORGEH_DT.replace("-","")%>"  ><!-- 현부서일자 --> --%>
					      		</td>
					     		<td class="lastCol">
					     			<%= data.PERSG_DT.replace("-",".")%>
<%-- 					     			<input type="hidden" id="AEDTM" name="AEDTM" value="<%= data.AEDTM.replace("-","")%>" ><!-- 퇴직일자 --> --%>
					     		</td>
			     			</tr>
<%
			} //end for
		}
%>

      					</table>
      				</div>
      			</div>
    			<ul class="btn_crud close">
    				<%-- <li><a href="javascript:fn_confirm()"><span><spring:message code="BUTTON.COMMON.CONFIRM"/>확인</span></a> --%>
    				<li><a href="javascript:closePop()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a>
    			</ul>
    		</div>
		</div>
	</form>
<iframe name="ifHidden" width="0" height="0" /></iframe>
</body>

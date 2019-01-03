<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   공통														*/
/*   Program Name	:   사원찾기 팝업											*/
/*   Program ID		: D40OrganListFramePop.jsp							*/
/*   Description		: 사원찾기 팝업												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%

	WebUserData user = (WebUserData)session.getAttribute("user");
	String emp = user.empNo;
	String I_DATUM  = WebUtil.nvl(request.getParameter("I_DATUM"));          //기간
	String pageGubun  = WebUtil.nvl(request.getParameter("pageGubun"));	//페이지구분(A:근태그룹인원지정, B:계획근무일정 조회/변경, 검색조건, C: 인원추가)
// 	String I_SCREEN  = WebUtil.nvl(request.getParameter("I_SCREEN"));	//화면구분(A:초과근무, B:비근무/근무 ,C:사원지급정보)
	if( I_DATUM == null|| I_DATUM.equals("")) {
		I_DATUM = DataUtil.getCurrentDate();           //1번째 조회시
    }

	String orgOrTm  = WebUtil.nvl(request.getParameter("orgOrTm"));          //1 : 조직도, 2 : 근태그룹
	String iSeqno  = WebUtil.nvl(request.getParameter("iSeqno"));          //

	D40CheckDeptAhtuRFC func = new D40CheckDeptAhtuRFC();
    Object D40CheckDeptAhtu_vt = func.checkDeptAhtuRFC( emp, I_DATUM );
    String E_CHECK = DataUtil.getValue(D40CheckDeptAhtu_vt, "E_CHECK");

%>

<c:set var="E_CHECK" value="<%=E_CHECK%>"/>

<jsp:include page="/include/header.jsp" />

<style type="text/css">
.box1 {
	float:left;
	width:310px;
	height:475px;
}
.box2 {
 	display:inline-block;
 	width:630px;
 	height:395px;
 	margin-left:10px;
}
.box3{
	width: 310px;
    height: 315px;
    margin-bottom: 5px;
}
.box4{
	height: 40px;
    background-color: #f4f3f3;
    padding-top: 5px;
    border-width: 1px;
    border-style: solid;
    border-color: #e0e0e0;
}
.box5 {
 	width:630px;
 	height: 40px;
 	margin-left:320px;
 	padding-top: 5px;
 	background-color: #f4f3f3;
 	border-width: 1px;
    border-style: solid;
    border-color: #e0e0e0;
}
</style>

<script language="JavaScript">

	$(function() {
		<% if("2".equals(orgOrTm)){ %>
		$(".tab").find("#tmGrp").trigger("click").addClass("selected");
		<% }else{ %>
	    $(".tab").find("a:first").trigger("click").addClass("selected");
	    <% } %>
	});

	//텝 클릭 이벤트
	function tabMove(target, urlName, gubun) {
	    $(".tab").find(".selected").removeClass("selected");
	    $(target).addClass("selected");
	    $("#I_SELTAB").val(gubun);
	    $("#deptNo").val("");

	    $("#form1").attr("action", urlName);
	    $("#form1").attr("target", "iFrame1");
	    $("#form1").attr("method", "post");
	    $("#form1").attr("onsubmit", "true");
	    $("#form1").submit();
	}

	//기준일자 조회 => 사용안함
    function do_search(){

    	$("#form1").attr("action", "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OrganListSV");
	    $("#form1").attr("target", "iFrame1");
	    $("#form1").attr("method", "post");
	    $("#form1").attr("onsubmit", "true");
	    $("#form1").submit();

    }

	//하단 조회
    function do_searchEmp(){
    	blockFrame();
    	$("#gubun").val("1");
    	$("#form1").attr("action", "<%= WebUtil.JspPath %>D/D40TmGroup/D40OrganListRightIF.jsp");
	    $("#form1").attr("target", "iFrame2");
	    $("#form1").attr("method", "post");
	    $("#form1").attr("onsubmit", "true");
	    $("#form1").submit();

	}

	//사원찾기
    function do_searchSawon(){

    	if($("#I_GUBUN").val() == "2"){	//이름별
    		if($("#searchText").val().length > 1){
	    		$("#I_ENAME").val($("#searchText").val());
	    		$("#I_PERNR").val("");

    		}else{
    			alert("<spring:message code='MSG.D.D40.0002'/>");/* 검색할 이름을 2글자 이상 입력해 주십시오. */
    			return;
    		}
    	}else{	//사번별
    		
    		$("#I_PERNR").val($("#searchText").val());
    		$("#I_ENAME").val("");
    	}
    	blockFrame();
    	$("#gubun").val("2");
    	$("#form1").attr("action", "<%= WebUtil.JspPath %>D/D40TmGroup/D40OrganListRightIF.jsp");
	    $("#form1").attr("target", "iFrame2");
	    $("#form1").attr("method", "post");
	    $("#form1").attr("onsubmit", "true");
	    $("#form1").submit();

    }
	
	//2018-08-09 사번 선택 후 이름 넣을 시 오류 방지
    function InpuOnlyNumber(obj) 
    {
        if ($("#I_GUBUN").val() == "1" ){
        	if(event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
        		return true;
	        } else {
	            event.returnValue = false; 
	        }
	    } else{
        	return true;
       	}
    }
	
  //2018-08-09 이름-사번 구분 변경 시 초기화 안됨 수정
	function i_gubun_init(){
		$("#searchText").val("");	
	}

	//기본값 설정 팝업
    function openDefault(){

    	var cw = "600";
    	var ch = "420";
    	var sw = screen.availWidth;
    	var sh = screen.availHeight;
		var px = (sw-cw)/2;
    	var py = (sh-ch)/2;

    	var pop_window=window.open("","default","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width="+cw+",height="+ch+",left="+px+",top="+py);
	    pop_window.focus();
	    $("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40DefaultSettingSV");
	    $("#form1").attr("target", "default");
	    $("#form1").attr("method", "post");
	    $("#form1").attr("onsubmit", "true");
	    $("#form1").submit();
    }

	//확인 클릭
    function goSubmit(){

    	if($('#iFrame2').contents().find(".chkbox:checked").size()==0){
    		alert("<spring:message code='MSG.D.D40.0003'/>"); /* 선택된 사원이 없습니다. */
    	}else{

    		var iframe = document.getElementById("iFrame2");
    		var doc = iframe.contentWindow.document;
    		var checkboxes = doc.getElementsByName("radiobutton");
    		var chkGroup = "";
    		var chkGrp = "";
    		var SPERNR = "";
    		var SPERNR_TX = "";
    		var ORGEH_TX = "";
    		for (var i = 0; i < checkboxes.length; i++) {
    			if(checkboxes[i].checked == true){
    				chkGroup = checkboxes[i].value;
    				chkGrp = chkGroup.split("^");
    				SPERNR += chkGrp[0]+",";
    				SPERNR_TX += chkGrp[1]+",";
    				ORGEH_TX += chkGrp[2]+",";
				}
			}

			if("A" == '<%=pageGubun%>'){	//근태그룹인원지정

	    		$(opener.document).find("#pop_SPERNR").val(SPERNR.slice(0, -1));
	    		$(opener.document).find("#pop_SPERNR_TX").val(SPERNR_TX.slice(0, -1));
	    		$(opener.document).find("#pop_ORGEH_TX").val(ORGEH_TX.slice(0, -1));

	    		//$(opener.document).find("#tmGroupTable").html(SPERNR);
	    		window.opener.spernr_search();

			}else if("B" == '<%=pageGubun%>'){	//계획근무일정 조회/변경, 검색조건

				$(opener.document).find("#I_PERNR").val(SPERNR.slice(0, -1));
	    		$(opener.document).find("#I_ENAME").val(SPERNR_TX.slice(0, -1));

			}else if("C" == '<%=pageGubun%>'){	//인원추가 (일일근무일정, 초과근무, 근무/비근무, 사원지급정보)

				$(opener.document).find("#popPERNR").val(SPERNR.slice(0, -1));
	    		$(opener.document).find("#popENAME").val(SPERNR_TX.slice(0, -1));

	    		if('<c:out value="${param.I_SCREEN }"/>' == "A"){	//초과근무
	    			$(opener.document).find("#D_WTMCODE").val($("#D_WTMCODE").val());	//유형
	    			$(opener.document).find("#D_BEGDA").val($("#D_BEGDA").val());				//시작일
	    			$(opener.document).find("#D_ENDDA").val($("#D_ENDDA").val());				//종료일
	    			$(opener.document).find("#D_BEGUZ").val($("#D_BEGUZ").val());				//시작시간
	    			$(opener.document).find("#D_ENDUZ").val($("#D_ENDUZ").val());				//종료시간
	    			$(opener.document).find("#D_PBEG1").val($("#D_PBEG1").val());				//휴식시작1
	    			$(opener.document).find("#D_PEND1").val($("#D_PEND1").val());				//휴식종료1
	    			$(opener.document).find("#D_PBEG2").val($("#D_PBEG2").val());				//휴식시작2
	    			$(opener.document).find("#D_PEND2").val($("#D_PEND2").val());				//휴식종료2
	    			$(opener.document).find("#D_REASON").val($("#D_REASON").val());			//사유
	    			$(opener.document).find("#D_DETAIL").val($("#D_DETAIL").val());			//상세사유
	    			$(opener.document).find("#D_REASON_YN").val($("#D_REASON_YN").val());	//사유 필수여부
	    			$(opener.document).find("#D_DETAIL_YN").val($("#D_DETAIL_YN").val());		//상세사유 필수여부
	    			$(opener.document).find("#D_TIME_YN").val($("#D_TIME_YN").val());			//시간 필수여부
	    			$(opener.document).find("#repeatCnt").val($("#repeatCnt").val());				//반복회수
	    		}else if('<c:out value="${param.I_SCREEN }"/>' == "B"){	// 비근무/근무
	    			$(opener.document).find("#D_WTMCODE").val($("#D_WTMCODE").val());	//유형
	    			$(opener.document).find("#D_BEGDA").val($("#D_BEGDA").val());				//시작일
	    			$(opener.document).find("#D_ENDDA").val($("#D_ENDDA").val());				//종료일
	    			$(opener.document).find("#D_BEGUZ").val($("#D_BEGUZ").val());				//시작시간
	    			$(opener.document).find("#D_ENDUZ").val($("#D_ENDUZ").val());				//종료시간
	    			$(opener.document).find("#D_REASON").val($("#D_REASON").val());			//사유
	    			$(opener.document).find("#D_DETAIL").val($("#D_DETAIL").val());			//상세사유
	    			$(opener.document).find("#D_REASON_YN").val($("#D_REASON_YN").val());	//사유 필수여부
	    			$(opener.document).find("#D_DETAIL_YN").val($("#D_DETAIL_YN").val());		//상세사유 필수여부
	    			$(opener.document).find("#D_TIME_YN").val($("#D_TIME_YN").val());			//시간 필수여부
	    			$(opener.document).find("#repeatCnt").val($("#repeatCnt").val());				//반복회수
	    		}else if('<c:out value="${param.I_SCREEN }"/>' == "C"){	//사원지급정보
	    			$(opener.document).find("#D_WTMCODE").val($("#D_WTMCODE").val());	//유형
	    			$(opener.document).find("#D_BEGDA").val($("#D_BEGDA").val());				//일자
	    			$(opener.document).find("#D_BEGUZ").val($("#D_BEGUZ").val());				//시작시간
	    			$(opener.document).find("#D_ENDUZ").val($("#D_ENDUZ").val());				//종료시간
	    			$(opener.document).find("#D_PBEG1").val($("#D_PBEG1").val());				//휴식시작1
	    			$(opener.document).find("#D_PEND1").val($("#D_PEND1").val());				//휴식종료1
	    			$(opener.document).find("#D_REASON").val($("#D_REASON").val());			//사유
	    			$(opener.document).find("#D_DETAIL").val($("#D_DETAIL").val());			//상세사유
	    			$(opener.document).find("#D_REASON_YN").val($("#D_REASON_YN").val());	//사유 필수여부
	    			$(opener.document).find("#D_DETAIL_YN").val($("#D_DETAIL_YN").val());		//상세사유 필수여부
	    			$(opener.document).find("#D_TIME_YN").val($("#D_TIME_YN").val());			//시간 필수여부
	    			$(opener.document).find("#D_STDAZ_YN").val($("#D_STDAZ_YN").val());		//수 입력 가능여부
	    			$(opener.document).find("#D_PTIME_YN").val($("#D_PTIME_YN").val());		//시간 입력가능 여부
	    			$(opener.document).find("#repeatCnt").val($("#repeatCnt").val());				//반복회수
	    		}

	    		window.opener.makeInput();

			}

    		this.close();
    	}
    }

</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form id="form1" name="form1" method="post" action="" onsubmit="return false">
<div class="winPop">
	<input type="hidden" id="gubun" name="gubun">
	<input type="hidden" id="deptNo" name="deptNo">
	<input type="hidden" id="I_SELTAB" name="I_SELTAB">
	<input type="hidden" id="I_ENAME" name="I_ENAME">
	<input type="hidden" id="I_PERNR" name="I_PERNR">
	<input type="hidden" id="orgOrTm" name="orgOrTm" value="<%=orgOrTm%>">
	<input type="hidden" id="iSeqno" name="iSeqno" value="<%=iSeqno%>">
	<input type="hidden" id="I_SCREEN" name="I_SCREEN" value='<c:out value="${param.I_SCREEN }"/>'>
	<!-- 기본값설정 hidden -->
	<input type="hidden" id="D_WTMCODE" name="D_WTMCODE">
	<input type="hidden" id="D_BEGDA" name="D_BEGDA">
	<input type="hidden" id="D_ENDDA" name="D_ENDDA">
	<input type="hidden" id="D_BEGUZ" name="D_BEGUZ">
	<input type="hidden" id="D_ENDUZ" name="D_ENDUZ">
	<input type="hidden" id="D_PBEG1" name="D_PBEG1">
	<input type="hidden" id="D_PEND1" name="D_PEND1">
	<input type="hidden" id="D_PBEG2" name="D_PBEG2">
	<input type="hidden" id="D_PEND2" name="D_PEND2">
	<input type="hidden" id="D_REASON" name="D_REASON">
	<input type="hidden" id="D_DETAIL" name="D_DETAIL">
	<input type="hidden" id="D_REASON_YN" name="D_REASON_YN">
	<input type="hidden" id="D_DETAIL_YN" name="D_DETAIL_YN">
	<input type="hidden" id="D_TIME_YN" name="D_TIME_YN">
	<input type="hidden" id="D_STDAZ_YN" name="D_STDAZ_YN">
	<input type="hidden" id="D_PTIME_YN" name="D_PTIME_YN">

	<div class="header">
    	<span><spring:message code="LABEL.D.D12.0050"/><%--사원검색--%></span>
    	<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
    </div>

	<div class="body">

		<div>
			<div class="box1">
				<div class="box4">
					<table>
						<colgroup>
			                <col />
							<col width="10%" />
							<col width="10%" />
			            </colgroup>
				        <tr>
				            <th style="padding-top: 5px">
			                    <!-- 기준일자 --><spring:message code="LABEL.D.D40.0010"/> : <%= WebUtil.printDate(I_DATUM) %>
			                </th>
			                <td>
			                	<input type="text" id="I_DATUM"  name="I_DATUM" value="<%= WebUtil.printDate(I_DATUM) %>" style="display: none;" >
							</td>
							<td>
<!-- 								<div class="tableBtnSearch" style="text-align: center;"> -->
<%-- 				                    <a href="javascript:do_search();" class="search"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a> --%>
<!-- 				                </div> -->
			                </td>
			             </tr>
			        </table>
				</div>
				<div style="height: 5px;"> </div>
				<div class="tabArea" style="width: 310px;">
			        <ul class="tab" style="margin-bottom: 5px;">
			           	<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OrganListSV', 'A');"><spring:message code='TAB.D.D40.0001'/><%-- 부서근태 권한조직--%></a></li>
			           	<li><a href="javascript:;" id="tmGrp" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OrganListSV', 'C');"><spring:message code='TAB.D.D40.0002'/><!-- 근태그룹 --></a></li>
			           	<c:if test="${ E_CHECK eq 'X' }">
			           		<li><a href="javascript:;" onclick="tabMove(this, '<%= WebUtil.JspPath %>common/wait.jsp?url=<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40OrganListSV', 'B');"><spring:message code='TAB.D.D40.0003'/><!-- 인사조직 --></a></li>
			        	</c:if>
			        </ul>
			    </div>
				<div class="box3">
					<IFRAME src="" name="iFrame1" frameborder="0" leftmargin="0" height="315" width="310" marginheight="0" marginwidth="0" topmargin="0" style="float:left; border:1px solid #ddd; "></IFRAME>
				</div>
				<div style="height: 5px;"> </div>
		     	<div class="tableBtnSearch" style="text-align: center;">
	                <a href="javascript:do_searchEmp();" class="search"><span><!-- 검색 --><spring:message code="BUTTON.COMMON.SEARCH"/></span></a>
	            </div>
			</div>
			<div class="box5">
				<table>
					<colgroup>
						<col width="20%" />
						<col width="40%" />
		                <col />
		            </colgroup>
		            <tr>
			            <td>
		                    <select id="I_GUBUN" name="I_GUBUN" style="vertical-align:middle;" onchange="i_gubun_init();">
		                    	<option value="2"><spring:message code="LABEL.D.D40.0020"/></option>
		                    	<option value="1"><spring:message code="LABEL.D.D40.0021"/></option>
		                    </select>
		                </td>
		                <td>
		                	<input type="text"  id = "searchText"    name="searchText" value="" onKeyDown="if(event.keyCode == 13) do_searchSawon();" onkeyPress="InpuOnlyNumber(this);"  style="width: 200px" >
						</td>
						<td>
							<div class="tableBtnSearch" style="text-align: center;">
			                    <a href="javascript:do_searchSawon();" class="search"><span><!-- 사원찾기 --><spring:message code="LABEL.COMMON.0006"/></span></a>
			                </div>
		                </td>
	                </tr>
		        </table>
			</div>
			<div style="height: 5px;"> </div>
	     	<div class="box2">
	     		<IFRAME src="<%= WebUtil.JspPath %>D/D40TmGroup/D40OrganListRightIF.jsp" id="iFrame2" name="iFrame2" frameborder="0" leftmargin="0" height="395" width="630" marginheight="0" marginwidth="0" topmargin="0" scrolling="no" style="right;  border:1px solid #ddd; border-top:none; "></IFRAME>
	     	</div>
		</div>

		<div class="clear"></div>
	  	<div class="buttonArea" style="padding-right: 40px;">
	  		<ul class="btn_crud">
	  			<c:if test="${not empty param.I_SCREEN}">
		  			<li style="display: none;"> 반복 회수
		  				<select id="repeatCnt" name="repeatCnt">
		  					<c:forEach var="i" begin="1" end="10">
	            				<option value="${i}"><c:out value="${i}"/></option>
	          				</c:forEach>
		  				</select>
		  			</li>
	  				<li><a href="javascript:openDefault();"><span><spring:message code="BUTTON.D.D40.0007" /><%--기본값 설정--%></span></a></li>
	  			</c:if>
	  			<li><a class="darken" href="javascript:goSubmit();"><span><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
	  			<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
	  		</ul>
	  	</div>
	</div>



</div>
</form>
</body>
<jsp:include page="/include/footer.jsp"/>

<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태그룹관리												*/
/*   Program Name	:   근태그룹관리												*/
/*   Program ID		: D40TmGroupFrame.jsp									*/
/*   Description		: 근태그룹관리												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
	WebUserData user = (WebUserData)session.getValue("user");

// 	int year  = Integer.parseInt( DataUtil.getCurrentYear()) ;  // 년
// 	int month = Integer.parseInt( DataUtil.getCurrentMonth() ) ;  // 월
// 	int I_PABRJ  = Integer.parseInt( ( String ) request.getAttribute( "I_PABRJ"  ) ) ;  // 년
// 	int I_PABRP = Integer.parseInt( ( String ) request.getAttribute( "I_PABRP" ) ) ;  // 월
	String I_SEQNO = ( String ) request.getAttribute( "I_SEQNO" )  ;  // 월

// 	int startYear = Integer.parseInt( (user.e_dat03).substring(0,4) );
// 	int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

	//2003.01.02. - 12월일때만 endYear에 + 1년을 해준다.
// 	if( I_PABRP == 12 ) {
// 	    endYear = Integer.parseInt( DataUtil.getCurrentYear() ) + 1;
// 	}

// 	if( startYear < 2002 ){
// 	    startYear = 2002;
// 	}

// 	if( ( endYear - startYear ) > 10 ){
// 	    startYear = endYear - 10;
// 	}
// 	Vector CodeEntity_vt = new Vector();
// 	for( int i = startYear ; i <= endYear+1 ; i++ ){
// 	    CodeEntity entity = new CodeEntity();
// 	    entity.code  = Integer.toString(i);
// 	    entity.value = Integer.toString(i);
// 	    CodeEntity_vt.addElement(entity);
// 	}

	Vector data_vt    = (Vector)request.getAttribute("data_vt");
	Vector select_vt    = (Vector)request.getAttribute("select_vt");


%>
<c:set var="count" value="<%=data_vt.size()%>"/>
<jsp:include page="/include/header.jsp" />

<script language="JavaScript">
	var rowCount = '<c:out value="${count }"/>';
	var now = $.datepicker.formatDate($.datepicker.ATOM, new Date());
	now = now.replace(/-/g, '.');

	function saveBlockFrame() {
        $.blockUI({ message : '<spring:message code="MSG.D.D40.0001"/>' });
    }

	$(function() {

		//조회
		$("#do_search").click(function(){
			_showLoading();
			$("#I_GTYPE").val("1");
			$("#form1").attr("action","<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmGroupFrameSV");
		    $("#form1").attr("target", "_self");
		    $("#form1").attr("method", "post");
		    $("#form1").attr("onsubmit", "true");
		    $("#form1").submit();

		});

		//행추가
		$("#addRow").click(function(){
			rowCount++;

			var addStaffText = '<tr id="tr'+rowCount+'">'+
				'	<td>'+
				'		<input type="radio" name="rdo" id="rdo'+rowCount+'" value="tr'+rowCount+'">'+
				'	</td>'+
		      	'	<td>'+
		      	'		<input type="hidden"  name="SEQNO" value="" >'+
		      	'		<input type="text"  name="TIME_GRUP" value="" style="width: 90%">'+
		      	'	</td>'+
		      	'	<td style="display: none;">'+
		      	'		<input type="text"  class="date" name="BEGDA" value="'+now+'" size="15" style="margin-right: 4px">'+
		      	'	</td>'+
		      	'	<td>'+
		      	'	</td>'+
		      	'	<td class="lastCol">'+
		      	'	</td>'+
		      	'</tr>' ;

			var trHtml = $( "tr[name=trStaff]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출

			trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
			var pickerOpts = {
					dateFormat : "yy.mm.dd"
			};
			$('.date').each(function(){ $(this).datepicker(pickerOpts); });
		});

		//행삭제
		$("#deleteRow").click(function(){
			if(!$('input:radio[name=rdo]').is(':checked')){
				alert('<spring:message code="MSG.D.D40.0005"/>'); /* 삭제할려는 행 선택 후 행삭제 하십시오. */
				return;
			}
			var temp = $(':radio[name="rdo"]:checked').val();
			$("#"+temp).remove();
		});

		//저장
		$("#do_save, #save").click(function(){
			saveBlockFrame();
			var chk = true;
			$("input[name=TIME_GRUP]").each(function(idx){
		        if($(this).val() == ""){
		        	alert('<spring:message code="MSG.D.D40.0007"/>'); /* 근태그룹명을 입력 하십시오. */
		        	$(this).focus();
		        	chk = false;
		        }
			});

			if(!chk){
				$.unblockUI();
				return;
			}
			if(chk){
				$("input[name=BEGDA]").each(function(idx){
			        if($(this).val() == ""){
			        	alert('<spring:message code="MSG.D.D40.0006"/>');  /* 적용일자를 입력 하십시오. */
			        	$(this).focus();
			        	chk = false;
			        }
				});
				if(!chk){
					$.unblockUI();
					return;
				}
			}
			var trCount = jQuery("table#tmGroupTable tr").length -1;

			document.form1.rowCount.value = trCount;
			document.form1.I_GTYPE.value = "2";
			document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmGroupFrameSV";
			document.form1.method = "post";
			document.form1.target = "_self";
			document.form1.submit();
		});

		//인원지정
		$("#do_createPage").click(function(){

			if(!$('input:radio[name=rdo]').is(':checked')){
				alert('<spring:message code="MSG.D.D40.0009"/>'); /* 인원지정 할려는 근태그룹을 선택해 주십시오. */
				return;
			}
			var temp = $(':radio[name="rdo"]:checked').val();
			temp = temp.substring( 2 );
			if($("#SEQNO"+temp).length == 0){
				alert('<spring:message code="MSG.D.D40.0008"/>'); /* 근태그룹을 저장 하신 후 인원지정을 하십시오. */
				return;
			}

			var frm = document.form1;
	        var value1 = $("#SEQNO"+temp).val();
	        var value2 = $("#TIME_GRUP"+temp).val();
	        var value3 = $("#BEGDA"+temp).val();
			frm.method = "post";
			frm.target = "_self";
			$("#paramSEQNO").val(value1);
			$("#paramTIME_GRUP").val(value2);
			$("#paramBEGDA").val(value3);
	        frm.action = "<%= WebUtil.ServletURL %>hris.D.D40TmGroup.D40TmGroupFramePersSV";
	        frm.submit();
		});

		//인원지정 Popup. 사용안함
		$("#do_create").click(function(){

			if(!$('input:radio[name=rdo]').is(':checked')){
				alert('<spring:message code="MSG.D.D40.0009"/>'); /* 인원지정 할려는 근태그룹을 선택해 주십시오. */
				return;
			}
			var temp = $(':radio[name="rdo"]:checked').val();
			temp = temp.substring( 2 );
			if($("#SEQNO"+temp).length == 0){
				alert('<spring:message code="MSG.D.D40.0008"/>'); /* 근태그룹을 저장 하신 후 인원지정을 하십시오. */
				return;
			}

			var frm = document.form1;
	        var value1 = $("#SEQNO"+temp).val();
	        var value2 = $("#TIME_GRUP"+temp).val();
	        var value3 = $("#BEGDA"+temp).val();
		    small_window=window.open("","jijung","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=no,width=1030,height=580,left=100,top=100");
	        small_window.focus();
	        frm.target = "jijung";
	        frm.action = "<%=WebUtil.JspURL%>"+"D/D40TmGroup/D40OrganListPop.jsp?paramSEQNO="+value1+"&paramTIME_GRUP="+value2+"&paramBEGDA="+value3;
	        frm.submit();
		});

		//인원지정
		$("#guide").click(function(){

		});

	});

</script>

<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D40.0001"/>
</jsp:include>

<form id="form1" name="form1" method="post" onsubmit="return false">
	<input type="hidden" id="I_GTYPE" name="I_GTYPE">
	<input type="hidden" id="rowCount" name="rowCount">
	<input type="hidden" id="paramSEQNO" name="paramSEQNO">
	<input type="hidden" id="paramTIME_GRUP" name="paramTIME_GRUP">
	<input type="hidden" id="paramBEGDA" name="paramBEGDA">
	<!--조회년월 검색 테이블 시작-->
	<div class="tableInquiry">
		<table>
			<colgroup>
				<col width="20%" />
                <col />
            </colgroup>
            <tr>
                <th>
                    <img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
<%--                     <spring:message code="LABEL.D.D40.0002"/><!-- 근태년월 --> --%>
                    <spring:message code="LABEL.D.D40.0004"/><!-- 근태그룹 -->
                </th>
<!--                 <td style="display: none;"> -->
<!--                     <select name="I_PABRJ" id="I_PABRJ"> -->
<%--                     	<%= WebUtil.printOption(CodeEntity_vt, String.valueOf(I_PABRJ) )%> --%>
<!--                     </select> -->
<!--                     <select name="I_PABRP" id="I_PABRP"> -->
<%--                         <% --%>
<!--                             for( int i = 1 ; i < 13 ; i++ ) { -->
<!--                         %> -->
<%--                         <option value="<%= i %>" <%= i == I_PABRP ? "selected" : "" %>><%= i %></option> --%>
<%--                         <% --%>
<!--                             } -->
<!--                         %> -->
<!--                     </select> -->
<!--                 </td> -->
<!--                 <th> -->
<%--                     <spring:message code="LABEL.D.D40.0004"/><!-- 근태그룹 --> --%>
<!--                 </th> -->
                <td>
                    <select name="I_SEQNO" id="I_SEQNO">
                    	<option value=""><spring:message code="LABEL.COMMON.0024"/><!--전체  --></option>
                    	<%
                            for( int i = 0 ; i < select_vt.size() ; i++ ) {
                            	D40TmGroupData data = ( D40TmGroupData ) select_vt.get( i ) ;
                        %>
                        <option value="<%= data.CODE %>" <%= data.CODE.equals(I_SEQNO) ? "selected" : "" %>><%=data.TEXT %></option>                         <%
                            }
                        %>
                    	<%-- <%= WebUtil.printOption(select_vt, String.valueOf(I_SEQNO) )%> --%>
                    </select>

                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:void(0);" id="do_search"><span><spring:message code="BUTTON.COMMON.SEARCH"/><!-- 조회 --></span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a class="search" href="<%= WebUtil.ImageURL %>user_manual.ppt"><span><spring:message code="BUTTON.D.D40.0009"/><!-- 부서근태 사용자 가이드 --></span></a></li>
        </ul>
    </div>


  <!--조회년월 검색 테이블 끝-->
<%
// 사원 검색한 사람이 없을때
//if ( user_m != null ) {
%>
		<div class="listArea">
			<div class="listTop">
			<span class="listCnt"><spring:message code="LABEL.D.D12.0081" /><!-- 총 --> <span><%=data_vt.size() %></span><spring:message code="LABEL.D.D12.0083" /><!-- 건 --></span>
            	<div class="buttonArea">
	                <ul class="btn_mdl displayInline" style="margin-left: 10px;">
	                    <li><a class="search" href="javascript:void(0);" id="addRow" ><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><%-- 행추가 --%></span></a></li>
	                    <li><a class="search" href="javascript:void(0);" id="deleteRow"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><%-- 행삭제 --%></span></a></li>
			            <li><a class="search" href="javascript:void(0);" id="do_createPage"><span><spring:message code="BUTTON.D.D40.0004"/><!-- 인원지정 --></span></a></li>
	        	        <li><a class="darken" href="javascript:void(0);" id="do_save"><span><spring:message code="BUTTON.COMMON.SAVE"/><!-- 저장 --></span></a></li>
	                </ul>
            	</div>
        	</div>
    		<div class="table">
      			<table class="listTable" id="tmGroupTable">
      			<colgroup>
                    <col width="7%" />
                    <col width="auto" />
<!--                     <col width="15%" /> -->
                    <col width="15%" />
                    <col width="15%" />
                    <col width="20%" />
                </colgroup>
                <thead>
                      <tr name="trStaff">
                        <th><spring:message code="LABEL.D.D40.0003" /><!--선택--></td>
                        <th><spring:message code="LABEL.D.D40.0004" /><!--근태그룹--></td>
<%--                         <th><spring:message code="LABEL.D.D40.0005" /><!--인원--></td> --%>
                        <th style="display: none;"><spring:message code="LABEL.D.D40.0006" /><!--적용일자--></td>
                        <th><spring:message code="LABEL.D.D40.0008" /><!--변경일자--></td>
                        <th class="lastCol"><spring:message code="LABEL.D.D40.0009" /><!--변경자--></td>
                      </tr>
                </thead>
<%
   for ( int i = 0 ; i < data_vt.size() ; i++ ) {
	   D40TmGroupData data = ( D40TmGroupData ) data_vt.get( i ) ;
%>
				<tr class="<%=WebUtil.printOddRow(i)%>" id="tr<%=i+1%>">
					<td>
						<input type="radio" name="rdo" id="rdo<%=i+1%>" value="tr<%=i+1%>">
					</td>
                  	<td>
                  		<input type="hidden"  id="SEQNO<%=i+1%>" name="SEQNO" value="<%=data.SEQNO %>" >
                  		<input type="text" id="TIME_GRUP<%=i+1%>" name="TIME_GRUP" value="<%= data.TIME_GRUP %>" style="width: 90%">
                  	</td>
<!--                   	<td> -->
<%--                   		<%=  data.TOTAL %> <spring:message code="LABEL.D.D40.0018" /> --%>
<!--                   	</td> -->
                  	<td style="display: none;">
                  		<input type="text"  class="date" id="BEGDA<%=i+1%>" name="BEGDA" value="<%= data.BEGDA%>" size="15" >
                  	</td>
                  	<td>
                  		<%= data.AEDTM.replace("-",".") %>
                  	</td>
                  	<td class="lastCol">
                  		<%=  data.UNAME %>
                  	</td>
                </tr>
<%
   }
%>
                 	   </table>
                    </div>
                 </div>
        <!-- 조회 리스트 테이블 끝-->

 			    <div class="buttonArea">
			        <ul class="btn_crud">
			            <li><a class="darken" href="javascript:void(0);" id="save"><span><spring:message code="BUTTON.COMMON.SAVE" /><!-- 저장 --></span></a></li>
			        </ul>
			    </div>
<%
// }
%>
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

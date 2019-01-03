<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : EAP                                                      */
/*   Program Name : 건강상담 신청하기                                                     */
/*   Program ID   : health_apply.jsp                                   */
/*   Description  : 조회                       */
/*   Note         :                                                             */
/*   Creation     : 2012-07-30  LSA                                           */
/*   Update       : 2016-10-26 GEHR 통합 (김승철) */
/*                    :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import = "hris.common.WebUserData"%>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.common.constant.Area" %>


<%
	String RECEIVER = request.getParameter("RECEIVER");
	WebUserData user = WebUtil.getSessionUser(request);
	String userName = user.ename;
	String userOrg = user.e_orgtx;
	String userTitle = user.e_titel;
	//[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start
	String userTitl2 = user.e_titl2;
	if (userTitle.equals("책임") && !userTitl2.equals(""))  userTitle = userTitl2;
	//[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end
	String sDate = DataUtil.getCurrentDate();


%>

		<jsp:include page="/include/header.jsp" />

		<jsp:include page="/include/body-header.jsp">
			<jsp:param name="title" value="LABEL.N.EAP.0001"/>
		</jsp:include>

<link href="/web/images/css/jquery-ui-timepicker-addon.css" rel="stylesheet" type="text/css"/>

		<script src="/web/images/js/jquery-ui-timepicker-addon.js" type="text/javascript" ></script>
		<script type="text/javascript" src="/web/images/js/jquery-ui-timepicker-addon-i18n.min.js"></script>

	<script>
	$(function() {

		$('.time').timepicker({
			controlType: 'select', oneLine: true,
			timeFormat: 'HHmm', hourMin:9, hourMax:18,
			buttonImage:"/web/images/icon_time.gif"

		});
	});

	function timeFocus(){
		if ($('#sUZEIT').attr('readonly')){
	           $('.time').timepicker('hide');
	     }else{
		    	 if ($('#sUZEIT').val()=="")$('#sUZEIT').val("0900");
	            $('.time').timepicker('show');
	     }
	}
	</script>

	<!--[if lt IE 9]>
	<script src="http://getbootstrap.com/2.3.2/assets/js/html5shiv.js"></script>
	<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js">IE7_PNG_SUFFIX=".png";</script>
	<![endif]-->


	<script type="text/javascript">

		function rePopup(theURL,winName) {
		 var feature = "toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=700,height=300";
		  window.open(theURL,winName,features);
		}


		function popup(theURL,winName, width, height) {
		  var screenwidth = (screen.width-width)/2;
          var screenheight = (screen.height-height)/2;
		  winitem = 'height='+height+',width='+width+',top='+screenheight+',left='+screenwidth+',scrollbars=no';

		  window.open(theURL,winName,winitem);
		}




		function goback(){
			document.form1.action = "<%= WebUtil.ServletURL %>hris.N.EAP.health.HealthCounselSV";
		    document.form1.method = "post";
		    document.form1.submit();
		}

		function sendMail(){
			var mailForm = document.form1;

			var dataF = mailForm.sDATUM.value;
			var timeF = mailForm.sUZEIT.value;

			if(dataF == ""){
				alert("희망일자를 입력해 주세요");
				return;
			}
			if(mailForm.LINE.value ==""){
				alert("상담사유를 입력해 주세요");
				return;
			}

			if(f_timeFormat()){
				if(dataF ==""){
					mailForm.DATUM.value ="<%=sDate%>";
				}else{
					mailForm.DATUM.value = dataF.replace(/\./gi, ""); //날짜
				}

				if(!dateFormat(mailForm.DATUM)){
					return;
				}

				if(timeF == ""){
					mailForm.UZEIT.value = "000000";
				}else{
					mailForm.UZEIT.value = timeF.replace(/\:/gi, "")+"00"; //시간
				}
				if(confirm("건강상담을 신청하시겠습니까?")){
					mailForm.DATUM.value = dataF.replace(/\./gi, ""); //날짜
					mailForm.command.value="MAIL";
					mailForm.action = "<%= WebUtil.ServletURL %>hris.N.EAP.health.HealthCounselSV";
				    mailForm.submit();
		    	}
	    	}
		}

		//시간입력시 호출하는 펑션 - 꼭 필요함.
		function check_Time(){

		}

		function EnterCheck2(){
		    if (event.keyCode == 13)  {
		        f_timeFormat();
		    }
		}

	function f_timeFormat()
	{
	 	if( !timeFormat(document.form1.sUZEIT) ){//24:00일때 00:00으로 변환 필요
       		return false;
    	} else {
	        if( document.form1.sUZEIT.value == "24:00" ){
	            document.form1.sUZEIT.value = "00:00";
	        }
	        return true;
    	}
	}


	</script>
</head>

<form name="form1" method="post">

<input type="hidden" name ="ENAME" value="<%=userName %>">
<input type="hidden" name ="ORGTX" value="<%=userOrg %>">
<input type="hidden" name ="JIKWI" value="<%=userTitle %>">
<input type="hidden" name ="RECEIVER" value="<%= RECEIVER%>">
<input type="hidden" name ="DATUM" value="">
<input type="hidden" name ="UZEIT" value="">
<input type="hidden" name ="command" value="">


		<!-- 테이블 시작 -->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral"  summary="">
<!-- 		<table class="tb_def fixed" > -->
			<caption></caption>
			<colgroup>
			<col width="10%" /><col  width=20%/>
			<col width="10%" /><col  />
			<col width="10%" /><col  width=20%/>
			</colgroup>
			<tbody>
				<tr>
					<th>성명</th>
					<td class="left"><%=userName %></td>
					<th>소속</th>
					<td class="left"><%=userOrg %></td>
					 <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
					<%--<th>직위</th> --%>
					<th>직책/직급호칭</th>
					<%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
					<td class="left"><%=userTitle %></td>
				</tr>
				<tr>
					<th><span class="textPink">*</span>희망일자</th>
					<td class="left">
						<input type="text" name="sDATUM" class="date required" size="10" onfocus="$('.date').datepicker('show');" />

					</td>
					<th>희망시간</th>
					<td class="left" colspan="3">
						<input type="text" class="time" name="sUZEIT" size="10" onfocus="timeFocus()" onKeyPress = "EnterCheck2()" />

					</td>
				<tr>
					<th><span class="textPink">*</span>상담사유</th>
					<td class="left" colspan="5">
						<textarea cols="80" rows="5"  name="LINE" style="width:98%;" ></textarea>
					</td>
				</tr>
			</tbody>
		</table>
		</div></div>

		<!-- 테이블 끝 -->

    <div class="commentsMoreThan2">
        <div>
            <code>
                <spring:message code="MSG.COMMON.0061" /><!-- 는 필수 입력사항입니다. -->
            </code>
        </div>
        <div>
            <code>
                <spring:message code="MSG.N.EAP.0001" /><!-- ※ 본 메일은 건강 상담사 전용 발신 메일로서, 상담 신청 후 개별 연락드릴 예정입니다.-->
            </code>
        </div>
    </div>


    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:sendMail()" class="darken" ><span><spring:message code="LABEL.N.EAP.0002"/></span></a></li><!-- 상담신청 -->
            <li><a href="javascript:goback()"><span><spring:message code="BUTTON.COMMON.BACK" /></span></a></li>
        </ul>
    </div>


</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
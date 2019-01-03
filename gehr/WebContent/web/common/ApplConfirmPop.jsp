<%/******************************************************************************/
/*                                                                              */
/*   System Name  : common                                                          */
/*   1Depth Name  : common                                             */
/*   2Depth Name  : 결재 common confirm 창                                                            */
/*   Program Name : 결재 확인 popup                                                   */
/*   Program ID   : ApplConfirmPop.jsp                                    */
/*   Description  : 결재 시 공통으로 이용할 popup 창                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2016-09-01 이지은   [CSR ID:3129893] 전자결재 UI 통합                                          */
/*   Update       :                                                             */
/*                                                                          */
/*                                                                              */
/********************************************************************************/%>
<%@ include file="popupPorcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%
	String confirmMsg = "";
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><spring:message code="MSG.APPROVAL.0018"/></title>
	<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>eloffice/css/ui_library.css" />
	<link rel="stylesheet" type="text/css" href="<%= WebUtil.ImageURL %>eloffice/css/ui_library_approval.css" />
	<script type="text/javascript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="<%= WebUtil.ImageURL %>js/common.js"></script>
	<SCRIPT LANGUAGE="JavaScript">
        //<!--

        var winObj = window.dialogArguments;  // 부모창객체 통째로 get

        function goSubmit(){
            window.returnValue = {acceptCommentText : $("#acceptCommentText").val(), confirm : "Y"};
            this.close();
        }

        $(function() {
            $("#confMsg").html(winObj.confMsg);
            /*$("#confMsgCenter").text(winObj.confMsgCenter);*/
		});

        function calByte() {
            var message = $("#acceptCommentText").val();
            var totalByte = 0;
            for(var i =0; i < message.length; i++) {
                var currentByte = message.charCodeAt(i);
                if (currentByte > 128) totalByte += 2;
                else totalByte++;
            }

            $("#inputByte").text(totalByte);
        }

        //document.onkeydown = pers_search();
        //-->
	</SCRIPT>
</head>
<body style="padding:0px;" >
	<div class="winPop_appl popW380" style="border: 0px">
		<div class="header">
			<span><spring:message code="MSG.APPROVAL.0018" /><%--결재의견 --%></span>
			<a href="javascript:window.close();"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" alt="" /></a>
		</div>
		<div class="body"><!-- // 메시지가 한 줄인 경우는 중앙정렬이므로 class에서 t_center 추가,두 줄 이상인 경우 좌측정렬이므로 t_center 삭제 -->
			<p class="marBot10"><span id="confMsg"></span></p>
			<%--<p class="t_center bold marBot10"><span id="confMsgCenter"></span></p><!-- // 결재하시겠습니까?안내창일경우 의문형문구  삭제	 -->--%>

			<div class="content">
				<textarea name="acceptCommentText" id="acceptCommentText" cols="40" rows="5" class="w100" onkeyup="calByte()"></textarea>
				<p class="t_byte_appl"><span id="inputByte">0</span> / 500 Bytes</p><!--//11.21 -->
			</div>
			<div class="buttonArea_appl t_center">
				<ul class="btn_crud_appl">
					<li><a class="darken" href="javascript:goSubmit();"><span><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
					<li><a href="javascript:window.close();"><span><spring:message code="BUTTON.COMMON.CANCEL" /><%--취소--%></span></a></li><!-- // 안내창일경우 취소버튼 삭제--></span></a></li>
				</ul>
			</div>


		</div>
	</div>
</body>
</html>
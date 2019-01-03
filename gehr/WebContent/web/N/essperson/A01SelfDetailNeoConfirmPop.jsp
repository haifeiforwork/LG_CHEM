<%/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보 확인                                                        */
/*   Program Name : 인사정보 확인                                                 */
/*   Program ID   : A01SelfDetailNeoConfirmPop.jsp                                      */
/*   Description  : 인사정보 확인                                            */
/*   Note         :                                                             */
/*   Creation     : 2016-01-04     [CSR ID:2953938] 개인 인사정보 확인기능 구축 및 반영의 件                                     */
/*   Update       : 2016-04-12     [CSR ID:3035111] 인사정보 확인기능 수정요청의 件                                         */
/*                      2016-06-20     [CSR ID:3090169] 인사정보 확인 기능 버튼 수정 요청의 件  김불휘S         */
/********************************************************************************/%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>


<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%--@elvariable id="g" type="com.common.Global"--%>
<tags:layout title="MSG.A.A01.0001" pop="true">
    <tags:script>
    <script>
        function doConfirm(){
            //본인 정보를 확인하셨습니까?\n인사정보의 정확성을 위해 신중히 확인을 부탁드립니다.
            if(confirm("<spring:message code="MSG.A.A15.001" />")){
                document.form1.action = "${g.servlet}hris.N.essperson.A01SelfDetailNeoConfirmSV";
                document.form1.method = "post";
                document.form1.submit();
            }
        }
        // [CSR ID:3035111] 인사정보 확인기능 수정요청의 件
        function doModify(){
            window.open('${g.jsp}common/HRChargePop2.jsp', 'essPrintWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=700,height=450");
        }

        $(function() {
            addpopup();
        });
        //[CSR ID:3187400] 인사정보 확인기능 수정요청의 件 , addpopup 새로 작성함
        function addpopup() {
            window.open('', 'addpopup', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=720,height=950,top=40");
            document.form1.target = "addpopup";
            document.form1.action = "${g.jsp}common/addpopup.jsp";
            document.form1.method = "post";
            document.form1.submit();
        }
    </script>
    </tags:script>
    <form name="form1" method="post">
    </form>

    <div class="clear"></div>

    <%-- 인사 기록부 헤더부분 --%>
    <self:self-header personData="${resultData}" />

    <%-- 탭 영역 --%>
    <self:self-tab tabType="C"/>


<!-- [CSR ID:3090169] 인사정보 확인 기능 버튼 수정 요청의 件.  김불휘S 2016.6.20 -->
	<div class="commentsMoreThan2">
		<div>인사정보 확인을 완료했을 경우 ▶ 확인버튼 click </div>
		<div>수정 및 보완이 필요한 경우 ▶ 수정버튼 click</div>
	</div>
	<div class="buttonArea">
		<ul class="btn_crud">
			<li id="sc_button1"><a href="javascript:doModify();"><span>수정요청 메일 보내기</span></a></li>
			<li id="sc_button2"><a href="javascript:doConfirm();"><span class="darken">확인</span></a></li>
		</ul>
	</div>
<!-- [CSR ID:3090169]  -->

</tags:layout>

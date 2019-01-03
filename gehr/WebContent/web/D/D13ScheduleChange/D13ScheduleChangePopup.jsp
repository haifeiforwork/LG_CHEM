<%/******************************************************************************/
/*																				*/
/*   System Name  : MSS															*/
/*   1Depth Name  : 신청															*/
/*   2Depth Name  : 부서근태														*/
/*   Program Name : 일일근무일정 변경(근무규칙선택창)												*/
/*   Program ID   : D13ScheduleChangePopup|D13ScheduleChangePopup.jsp			*/
/*   Description  : 일일근무일정 변경 화면											*/
/*   Note         : 															*/
/*   Creation     : 2009-03-23  김종서												*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<tags:layout-pop title="LABEL.D.D13.0001" >
    <tags:script>
        <script>

        $(function(){
        	var w = 650;
        	var h = 450;
        	var offset = $(".bottonX").offset();
        	resizeTo( w, offset.top + 100);
        })
        
            function send(idx){
                var retVal = new Object();

                $("#-row-" + idx + " input").each(function() {
                    var $this = $(this);
                    retVal[$this.prop("name")] = $this.val();
                });

                window.returnValue = retVal;
                self.close();
            }
        </script>
    </tags:script>
    <form name="form1" method="post" onsubmit="return false">

        <div class="tableArea" style="height:300px; overflow:auto;">
            <div class="table">
                <table class="listTable" >
                    <!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
                    <tr>

                        <th width="100"><spring:message code='LABEL.D.D13.0007'/><!--근무일정코드--></th>
                        <th width="30">V</th>
                        <th width="140"><spring:message code='LABEL.D.D13.0008'/><!--근무일정유형TEXT--></th>
                        <th width="80"><spring:message code='LABEL.D.D13.0009'/><!--계획시간--></th>
                        <th width="80"><spring:message code='LABEL.D.D13.0010'/><!--근무시작--></th>
                        <th class="lastCol" width="60">
                            <spring:message code='LABEL.D.D13.0011'/><!--근무종료--></th>
                    </tr>
                    <c:forEach var="row" items="${scheduleType_vt}" varStatus="status">
                        <tr id="-row-${status.index}" class="${f:printOddRow(status.index)}" height=25 onclick="send('${status.index}');">
                            <td><input type="text" id="TPROG_${status.index}" name="TPROG"  value="${row.TPROG }" size=4 class="noBorder"></td>
                            <td><input type="text" id="VARIA_${status.index}" name="VARIA" value="${row.VARIA }" size=4 class="noBorder"></td>
                            <td><input type="text" id="TTEXT_${status.index}" name="TTEXT" value="${row.TTEXT }" class="noBorder"></td>
                            <td>
                                <input type="text"   id="SOLLZ_${status.index}" name="SOLLZ" value="${row.SOLLZ }" size=4 class="noBorder">
                            </td>
                            <td>
                                <input type="text"   id="SOBEG_TXT_${status.index}" name="SOBEG_TXT" value="${f:printTime(row.SOBEG)}" size=4 class="noBorder">
                                <input type="hidden" id="SOBEG_${status.index}" name="SOBEG" value="${row.SOBEG }" size=4 class="noBorder">
                            </td>
                            <td class="lastCol">
                                <input type="text"    id="SOEND_TXT_${status.index}" name="SOEND_TXT" value="${f:printTime(row.SOEND)}" size=4 class="noBorder">
                                <input type="hidden" id="SOEND_${status.index}" name="SOEND" value="${row.SOEND }" size=4 class="noBorder">
                            </td>
                        </tr>
                    </c:forEach>
                    <tags:table-row-nodata list="${scheduleType_vt}" col="6"/>
                </table>
            </div>
            <div class="buttonArea">

                <ul class="btn_crud">
                    <!-- 			        <li><a href="javascript:parent.hidePop();"> -->
                    <li><a href="javascript:self.close();">
                        <span><spring:message code="BUTTON.COMMON.CLOSE"></spring:message></span></a></li>
                </ul>

            </div>
            

        </div>
    </form>
</tags:layout-pop>
<div class="bottonX"></div>




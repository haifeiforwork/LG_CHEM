<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Personal HR Info                                                  															*/
/*   2Depth Name  	: Personal Info                                                    																*/
/*   Program Name 	: Emergency Contacts                                               														*/
/*   Program ID   		: A20EmergencyContactsBuildUsa.jsp                                             										*/
/*   Description  		: 비상연락망 정보를 신청할 수 하는 화면 [USA]                          													*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-09-30 jungin @v1.0                                          														*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="emergency" tagdir="/WEB-INF/tags/A/A20EmergencyContract" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<emergency:emergency-insert-layout title="MSG.A.A20.0001" >
    <tags:script>
        <script>
            function doSubmit_Build() {

                if (check_data()) {

                    document.form1.jobid.value = "create";
                    if (!confirm("<spring:message code='MSG.COMMON.SAVE.CONFIRM' />")) {
                        return;
                    }

                    //buttonDisabled();
                    document.form1.action = "${g.servlet}hris.A.A20EmergencyContactsBuildSV";
                    document.form1.submit();
                }
            }
        </script>
    </tags:script>

    <li><a href="javascript:;" onclick="doSubmit_Build();"><span><spring:message code="BUTTON.COMMON.SAVE" /></span></a></li>

</emergency:emergency-insert-layout>

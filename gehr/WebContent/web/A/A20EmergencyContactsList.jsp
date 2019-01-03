<%/***************************************************************************************/
/*   System Name  	: g-HR                                                         																	*/
/*   1Depth Name  	: Personal HR Info                                                  															*/
/*   2Depth Name  	: Personal Info                                                    																*/
/*   Program Name 	: Emergency Contacts                                               														*/
/*   Program ID   		: A20EmergencyContactsListUsa.jsp                                             										*/
/*   Description  		: 비상연락망 정보를 조회 하는 화면 [USA]                          														*/
/*   Note         		:                                                             																		*/
/*   Creation    		: 2010-09-30 jungin @v1.0                                          														*/
/***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ include file="/web/common/commonProcess.jsp" %>

<tags:layout>

   <self:self-emergency />

</tags:layout>



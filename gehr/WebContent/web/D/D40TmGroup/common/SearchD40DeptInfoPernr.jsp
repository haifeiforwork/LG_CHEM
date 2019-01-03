<%--
/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 상단 조회 공통                                                   */
/*   Program ID   : SearchD40DeptInfoPernr.jsp                                          */
/*   Description  : 상단 조회공통 jsp 파일                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2017-12-08 정준현                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.Vector" %>
<%--@ include file="/include/includeCommon.jsp"--%>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%@ taglib prefix="d40" tagdir="/WEB-INF/tags/D/D40" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="deptId" value="<%=deptId%>" />
<c:set var="deptNm" value="<%=deptNm%>" />
<c:set var="eInfo" value="<%=E_INFO%>" />
<c:set var="resultList" value="<%=resultList%>" />

<d40:search-d40dept-layout deptId="${deptId}" deptNm="${deptNm}" deptTimelink="${eInfo}" disabledSubOrg="${disabledSubOrg}" resultList="${resultList }"/>

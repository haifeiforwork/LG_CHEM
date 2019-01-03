<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서 검색                                                   */
/*   Program ID   : SearchDeptInfoPernr.jsp                                          */
/*   Description  : 부서 검색을 위한 jsp 파일                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-27 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="java.util.Vector" %>
<%--@ include file="/include/includeCommon.jsp"--%>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%@ taglib prefix="tags-common" tagdir="/WEB-INF/tags/common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="deptId" value="<%=deptId%>" />
<c:set var="deptNm" value="<%=deptNm%>" />


<tags-common:search-dept-layout deptId="${deptId}" deptNm="${deptNm}" disabledSubOrg="${disabledSubOrg}" deptTimelink="${deptTimelink}"/>

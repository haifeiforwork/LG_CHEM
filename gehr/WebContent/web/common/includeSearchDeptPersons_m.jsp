<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원 검색하는 include 파일                                  */
/*   Program ID   : SearchDeptPersons_m.jsp                                     */
/*   Description  : 사원 검색하는 include 파일                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.common.Global" %>
<%@ page import="com.common.Utils" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);
    Global g = Utils.getBean("global");
%>
<%@include file="/web/common/SearchDeptPersons_m.jsp"%>
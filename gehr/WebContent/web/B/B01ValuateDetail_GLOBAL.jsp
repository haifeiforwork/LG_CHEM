<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 평가결과                                                    */
/*   Program Name : 평가사항 조회                                               */
/*   Program ID   : B01ValuateDetail.jsp                                        */
/*   Description  : 평가사항 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                  2006-01-03  LSA HR INDEX추가                                */
/*                  2006-01-17  @v1.1LSA 상사점수(기존 상사점수*0.8*1.125)에서 그냥 상사점수의 합(다시 역환산함)*/
/*                  2006-02-13  @v1.2 신평가시스템연결 업적display group 없앰   */
/*                  2008-04-22  @v1.3 CSR ID:1249079 조회화면 조정              */
/*                  2013-05-24  CSR ID:99999 현장직( 전문기술직(실장 포함) 31 , 기능직33)은 본인 평가화면 조회하지 않음   */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                                             */
/*                  2016-02-19  [CSR ID:2990374] 전문기술직 15년도 개인평가 결과 Open  */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="valudte" tagdir="/WEB-INF/tags/B/B01ValuateDetail" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="com.sns.jdf.util.*" %>

<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>" />

<tags:layout >

    <valudte:valuate-list-GLOBAL />



</tags:layout>


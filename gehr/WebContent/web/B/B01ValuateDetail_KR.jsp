<%@ page import="com.sns.jdf.security.Encoder" %>
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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="valudte" tagdir="/WEB-INF/tags/B/B01ValuateDetail" %>

<%--
1. WebUtil.getSessionUser(request).empNo
2. fixEndZero empNo
3. Encode empNO
--%>

<c:set var="encodeEmpNo" value="<%= Encoder.Chang(DataUtil.fixEndZero(((WebUserData) request.getAttribute("user")).empNo, 8)) %>" />

<tags:layout>


        <%--<tags:script>
            <script language="JavaScript">
                <!--
                function goLink(year,grade) {
                    var width  = screen.width*8/10;
                    var height = screen.height*7/10;
                    var vleft  = screen.width*1/10;
                    var vtop   = screen.height*1/10;
                    //@v1.2
                    window.open("","HRIS","toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=1,left="+vleft+",top="+vtop+",width="+width+" height="+height);

                    var link = "/app/jsp/app501_012.jsp?S_NAPEMPID=${encodeEmpNo}&S_APYEAR="+year+"&S_APRLTGRD="+grade;
                    document.form_hris.linkpage.value = link;

                    //document.form_hris.action = "http://epdev.lgchem.com:9010/appindex.jsp";
                    document.form_hris.action = "http://ehrapp.lgchem.com:9010/appindex.jsp";
                    //document.form_hris.action = "http://165.244.243.134:9011/appindex.jsp";

                    document.form_hris.target = "HRIS";
                    document.form_hris.submit();
                }
                //-->
            </script>
        </tags:script>--%>

    <form name="form_hris" method="post">
        <input type=hidden name=linkpage value="">
        <input type=hidden name=stylecss value="blue">
        <c:if test="${pageType == 'M'}">
        <input type=hidden name=empid value="${encodeEmpNo}">
        </c:if>
    </form>
    <form name="form_hris1" method="post">
        <input type=hidden name=p_empl_numb value="${user.empNo}">
        <input type=hidden name=p_eval_year value="">
        <input type=hidden name=p_gubun     value="ESS">
    </form>

    <valudte:valuate-list-KR isLink="false"/>


</tags:layout>





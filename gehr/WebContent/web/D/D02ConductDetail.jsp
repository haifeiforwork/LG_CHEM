<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근태실적정보                                                */
/*   Program ID   : D02ConductDetail_m.jsp                                      */
/*   Description  : 근태 사항을 조회                                            */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%
    WebUserData user = (WebUserData)session.getValue("user");
    String year  = DataUtil.getCurrentYear()  ;
    String month = DataUtil.getCurrentMonth() ;

//  2003.01.02. - 01월일때 1로 넘겨줘야함 SV에서 처리하기위해서..
    month = String.valueOf( Integer.parseInt( month ) );

    Logger.debug.println( this, year  ) ;
    Logger.debug.println( this, month ) ;

    if( request.getParameter( "year"  ) != null ) {
        year = request.getParameter( "year"  ) ;
    }

    if( request.getParameter( "month" ) != null ) {
        month = request.getParameter( "month" ) ;
    }
    String rowheight;
    //31:전문기술직,32:지도직,33:기능직
    //[CSR ID:2583929] 생산기술직 38 추가
    if ( user.e_persk.equals("31") ||user.e_persk.equals("32")||user.e_persk.equals("33")||user.e_persk.equals("38") ) {
        rowheight="300";
    }else{
        rowheight="280";
    }
%>

<html>
<head>
<title>ESS</title>
</head>
<frameset rows="<%=rowheight%>,*" frameborder="NO" border="0" framespacing="0">
  <frame name="topPage" scrolling="NO"   noresize src="<%= WebUtil.ServletURL %>hris.D.D02ConductHeaderSV?year=<%= year %>&month=<%= month %>" frameborder="NO" marginwidth="0" marginheight="0">
  <frame name="endPage" scrolling="AUTO"          src="<%= WebUtil.ServletURL %>hris.D.D02ConductListSV?year=<%= year %>&month=<%= month %>"   frameborder="NO" marginwidth="0" marginheight="0">
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</noframes>
</html>

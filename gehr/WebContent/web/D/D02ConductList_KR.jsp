<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근태실적정보                                                */
/*   Program ID   : D02ConductList.jsp                                          */
/*   Description  : 근태 사항을 조회                                            */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.rfc.*" %>
<%
    WebUserData user = (WebUserData)session.getValue("user");

    String rowheight;
//31:전문기술직,32:지도직,33:기능직
//[CSR ID:2583929] 생산기술직 38 추가
    if ( user.e_persk.equals("31") ||user.e_persk.equals("32")||user.e_persk.equals("33")||user.e_persk.equals("38") ) {
        rowheight="300";
    }else{
        rowheight="280";
    }

    Vector D02ConductDisplayData_vt = ( Vector ) request.getAttribute( "D02ConductDisplayData_vt" ) ;

    int year  = Integer.parseInt( ( String ) request.getAttribute( "year"  ) ) ;  // 년
    int month = Integer.parseInt( ( String ) request.getAttribute( "month" ) ) ;  // 월

    String class_code = "td04" ;
    String day        = "" ;

    String COL1  = ( String ) request.getAttribute( "COL1"  ) ;
    String COL2  = ( String ) request.getAttribute( "COL2"  ) ;
    String COL3  = ( String ) request.getAttribute( "COL3"  ) ;
    String COL4  = ( String ) request.getAttribute( "COL4"  ) ;
    String COL5  = ( String ) request.getAttribute( "COL5"  ) ;
    String COL6  = ( String ) request.getAttribute( "COL6"  ) ;
    String COL7  = ( String ) request.getAttribute( "COL7"  ) ;
    String COL8  = ( String ) request.getAttribute( "COL8"  ) ;
    String COL9  = ( String ) request.getAttribute( "COL9"  ) ;
    String COL10 = ( String ) request.getAttribute( "COL10" ) ;
    String COL11 = ( String ) request.getAttribute( "COL11" ) ;
    String COL12 = ( String ) request.getAttribute( "COL12" ) ;
    String C0140 = ( String ) request.getAttribute( "C0140" ) ;
    String C0240 = ( String ) request.getAttribute( "C0240" ) ;

    int startYear = Integer.parseInt( (user.e_dat03).substring(0,4) );
    int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

//  2003.01.02. - 12월일때만 endYear에 + 1년을 해준다.
    if( month == 12 ) {
        endYear = Integer.parseInt( DataUtil.getCurrentYear() ) + 1;
    }

    if( startYear < 2002 ){
        startYear = 2002;
    }
    if( ( endYear - startYear ) > 10 ){
        startYear = endYear - 10;
    }
    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    //총공수
    D02KongsuHourRFC rfcH       = new D02KongsuHourRFC();
    String yymm = year+DataUtil.fixEndZero(Integer.toString(month),2);
    String KONGSU_HOUR = rfcH.getHour(user.empNo,yymm);

    String DispFlag="false";
    // 공수 : 33:기능직,34 && 가공공장만 조회
    //[CSR ID:2583929] 생산기술직 38 추가
    if ( (user.e_persk.equals("33") ||user.e_persk.equals("38") ||user.e_persk.equals("34") ) && user.e_werks.equals("BB00")   ) {
        DispFlag = "true";
    }
%>

<jsp:include page="/include/header.jsp" />
<% if(Locale.ENGLISH.equals(user.locale)){
%>
<style>
    .listTable th {
        font-size: 10.5px;
        padding:0px;
    }
</style>
<%} %>
<script language="JavaScript">
    <!--
    function showList() {
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D02ConductListSV" ;
        document.form1.method = "post" ;
        document.form1.submit() ;
    }

    $(document).ready(function() {
        parent.resizeIframe(document.body.scrollHeight);

        $(window).resize(function(){
            var tableWidth = $('.subWrapper').width()-20;
            $('.listTable').css('width', tableWidth);
            $('.tableArea').css('width', tableWidth);
        });
        $(window).trigger("resize");

    });




    //-->
</script>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="click" value="Y"/>
</jsp:include>
<form name="form1" method="post">
    <div class="tableInquiry">
        <table>
            <colgroup>
                <col width="20%" />
                <col />
            </colgroup>
            <tr>
                <th>
                    <img class="searchTitle" src="<%= WebUtil.ImageURL %>sshr/top_box_search.gif" />
                    <!-- 조회년월 --><%=g.getMessage("LABEL.D.D15.0118")%>
                </th>
                <td>
                    <select name="year"><%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%></select>
                    <select name="month">
                        <%
                            for( int i = 1 ; i < 13 ; i++ ) {
                        %>
                        <option value="<%= i %>" <%= i == month ? "selected" : "" %>><%= i %></option>
                        <%
                            }
                        %>
                    </select>
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a href="javascript:showList();" class="search"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <%
        //31:전문기술직,32:지도직,33:기능직
        //[CSR ID:2583929] 생산기술직 38 추가
        if ( user.e_persk.equals("31") ||user.e_persk.equals("32")||user.e_persk.equals("33") ||user.e_persk.equals("38") ) {
    %>
    <div class="commentsMoreThan2">
        <div><%=g.getMessage("LABEL.D.D15.0119")%></div>
    </div>
    <!--  근태, 월급여, 연급여 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며,<br> 이를 위반 시에는 취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려 드립니다. -->
    <%
        }
    %>
    <!--조회년월 검색 테이블 끝-->

    <h2 class="subtitle"><%= year %><!-- 년 --><%=g.getMessage("LABEL.D.D15.0020")%> <%= month %><!-- 월 --><%=g.getMessage("LABEL.D.D15.0021")%></h2>
    <%    if ( DispFlag.equals("true")  ) {  %>
    ( <!-- 총공수 --><%=g.getMessage("LABEL.D.D15.0121")%> : <%= WebUtil.printNumFormat(KONGSU_HOUR,1)%> )
    <%    }  %>

    <div class="tableArea noBtMargin noBtPadding">
        <div class="table">
            <table class="listTable noBtMargin">
                <colgroup>
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                    <col width="7.1%">
                </colgroup>
                <thead>
                <tr>
                    <th rowspan="2"><!-- 구 분 --><%=g.getMessage("LABEL.D.D15.0122")%> </th>
                    <th colspan="4"><!-- 추가 근로(시간) --><%=g.getMessage("LABEL.D.D15.0123")%> </th>
                    <th colspan="3"><!-- 사원급료정보 --><%=g.getMessage("LABEL.D.D15.0124")%> </th>
                    <th colspan="2"><!-- 휴 가(일수) --><%=g.getMessage("LABEL.D.D15.0125")%> </th>
                    <th colspan="4" class="lastCol"><!-- 기 타(일수) --><%=g.getMessage("LABEL.D.D15.0126")%> </th>
                </tr>
                <tr>
                    <th><!-- 평일연장 --><%=g.getMessage("LABEL.D.D15.0127")%> </th>
                    <th><!--휴일연장 --><%=g.getMessage("LABEL.D.D15.0128")%> </th>
                    <th><!-- 야간근무 --><%=g.getMessage("LABEL.D.D15.0129")%> </th>
                    <th><!-- 휴일근무 --><%=g.getMessage("LABEL.D.D15.0130")%> </th>
                    <th><!-- 향군수당 --><%=g.getMessage("LABEL.D.D15.0131")%> </th>
                    <th><!-- 교육수당 --><%=g.getMessage("LABEL.D.D15.0132")%> </th>
                    <th><!-- 당직 --><%=g.getMessage("LABEL.D.D15.0133")%> </th>
                    <th><!-- 사용휴가 --><%=g.getMessage("LABEL.D.D15.0134")%> </th>
                    <th><!-- 보건휴가 --><%=g.getMessage("LABEL.D.D15.0135")%> </th>
                    <th><!-- 결근 --><%=g.getMessage("LABEL.D.D15.0136")%> </th>
                    <th><!-- 지각 --><%=g.getMessage("LABEL.D.D15.0137")%> </th>
                    <th ><!-- 조퇴 --><%=g.getMessage("LABEL.D.D15.0138")%> </th>
                    <th class="lastCol"><!-- 외출 --><%=g.getMessage("LABEL.F.F42.0021")%> </th>
                </tr>
                <tr>
                    <th><!-- 월 계 --><%=g.getMessage("LABEL.D.D15.0139")%></th>
                    <th><%= COL1  %></th>
                    <th><%= COL2  %></th>
                    <th><%= COL3  %></th>
                    <th><%= COL4  %></th>
                    <th><%= COL10 %></th>
                    <th><%= COL11 %></th>
                    <th><%= COL12 %></th>
                    <th><%= COL5  %></th>
                    <th><%= COL6  %></th>
                    <th><%= COL7  %></th>
                    <th><%= COL8  %></th>
                    <th><%= COL9  %></th>
                    <th class="lastCol"><%= C0240  %></th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</form>

<div style="height:310px; overflow-y:auto;">
    <table class="listTable noBtMargin underline">
        <colgroup>
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
            <col width="7.1%">
        </colgroup>
        <%
            for ( int i = 0 ; i < D02ConductDisplayData_vt.size() ; i++ ) {
                D02ConductDisplayData data = ( D02ConductDisplayData ) D02ConductDisplayData_vt.get( i ) ;

                day = data.DATE.substring( data.DATE.length() - 2, data.DATE.length() - 1 ) ;

                if( day.equals( "월" ) ) {
                    if( class_code.equals( "td04" ) ) {
                        class_code = "line01" ;
                    } else {
                        class_code = "td04" ;
                    }
                }


        %>
        <tr>
            <td><%= data.DATE %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>" style="height: 13px;"><%= data.COL1.equals( "0.0" )  ? "&nbsp;" : data.COL1  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL2.equals( "0.0" )  ? "&nbsp;" : data.COL2  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL3.equals( "0.0" )  ? "&nbsp;" : data.COL3  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL4.equals( "0.0" )  ? "&nbsp;" : data.COL4  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL10.equals( "0.0" ) ? "&nbsp;" : data.COL10 %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL11.equals( "0.0" ) ? "&nbsp;" : data.COL11 %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL12.equals( "0.0" ) ? "&nbsp;" : data.COL12 %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL5.equals( "0.0" )  ? "&nbsp;" : data.COL5  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL6.equals( "0.0" )  ? "&nbsp;" : data.COL6  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL7.equals( "0.0" )  ? "&nbsp;" : data.COL7  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %>"  style="height: 13px;"><%= data.COL8.equals( "0.0" )  ? "&nbsp;" : data.COL8  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %> "  style="height: 13px;"><%= data.COL9.equals( "0.0" )  ? "&nbsp;" : data.COL9  %></td>
            <td class="<%= day.equals( "일" ) ? "line02" : class_code %> lastCol"  style="height: 13px;"><%= data.C0240.equals( "0.0" )  ? "&nbsp;" : data.C0240  %></td>
        </tr>

        <%

            }
        %>
    </table>
</div>


<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근태실적정보                                                */
/*   Program ID   : D02ConductHeader_m.jsp                                      */
/*   Description  : 근태 사항을 조회                                            */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  한성덕                                          */
/*   Update       : 2005-01-21  윤정현                                          */
/*                  2014-07-30  [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.rfc.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    String COL1  = ( String ) request.getAttribute( "COL1"  );
    String COL2  = ( String ) request.getAttribute( "COL2"  );
    String COL3  = ( String ) request.getAttribute( "COL3"  );
    String COL4  = ( String ) request.getAttribute( "COL4"  );
    String COL5  = ( String ) request.getAttribute( "COL5"  );
    String COL6  = ( String ) request.getAttribute( "COL6"  );
    String COL7  = ( String ) request.getAttribute( "COL7"  );
    String COL8  = ( String ) request.getAttribute( "COL8"  );
    String COL9  = ( String ) request.getAttribute( "COL9"  );
    String COL10 = ( String ) request.getAttribute( "COL10" );
    String COL11 = ( String ) request.getAttribute( "COL11" );
    String COL12 = ( String ) request.getAttribute( "COL12" );
    String C0140 = ( String ) request.getAttribute( "C0140" );

    int year  = Integer.parseInt( ( String ) request.getAttribute( "year"  ) ) ;  // 년
    int month = Integer.parseInt( ( String ) request.getAttribute( "month" ) ) ;  // 월

    int startYear = Integer.parseInt( DataUtil.getCurrentYear() );
    int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );
    String KONGSU_HOUR = "";
    String DispFlag="false";
    if ( user_m != null ) {
        startYear = Integer.parseInt( (user_m.e_dat03).substring(0,4) );

        //총공수
        D02KongsuHourRFC rfcH       = new D02KongsuHourRFC();
        String yymm = year+DataUtil.fixEndZero(Integer.toString(month),2);
        KONGSU_HOUR = rfcH.getHour(user_m.empNo,yymm);

        // 공수 : 기능직 33 ,34 && 가공공장만 조회
        //[CSR ID:2583929] 생산기술직 38 추가
        if ( (user_m.e_persk.equals("33") ||user_m.e_persk.equals("38") || user_m.e_persk.equals("34") ) && user_m.e_werks.equals("BB00")   ) {
              DispFlag = "true";
        }
    }

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


%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
// NewSession.jsp에서 이 function 호출함
function doSearchDetail() {

    document.form1.action = "<%= WebUtil.JspURL %>D/D02ConductDetail_m.jsp" ;
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function showList() {
    document.form1.action = "<%= WebUtil.JspURL %>D/D02ConductDetail_m.jsp" ;
    document.form1.method = "post" ;
    document.form1.target = "menuContentIframe" ;
    document.form1.submit() ;
}
-->
</script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return true" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->
<form name="form1">
<div class="subWrapper">
	<div class="title"><h1><!--  근태실적정보--><%=g.getMessage("LABEL.D.D15.0117")%></h1></div>

	<!--   사원검색 보여주는 부분 시작   -->
	<%@ include file="/web/common/SearchDeptPersons_m.jsp" %>
	<!--   사원검색 보여주는 부분  끝    -->

<%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

	<div class="tableInquiry">
		<table>
			<colgroup>
				<col width="10%" />
				<col />
			</colgroup>
	         <tr>
	           <th><!-- 조회년월 --><%=g.getMessage("LABEL.D.D15.0118")%></th>
	           <td>
					<select name="year"><%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%> </select>
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
          				<a class="search" href="javascript:showList();"><span>조회</span></a>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<!--조회년월 검색 테이블 끝-->

<%
    //31:전문기술직,32:지도직,33:기능직
    //[CSR ID:2583929] 생산기술직 38 추가
    if ( user_m.e_persk.equals("31") ||user_m.e_persk.equals("32")||user_m.e_persk.equals("33") ||user_m.e_persk.equals("38") ) {
%>

	<div class="commentsMoreThan2">
 		<div><!-- ※ 근태, 월급여, 연급여 및 성과급 등 개인 처우 관련 사항을
                    社內外 제3자에게 절대로 공개하지 마시기 바라며,<br>
                    &nbsp;&nbsp;&nbsp;&nbsp; 이를 위반 시에는 취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려 드립니다. --><%=g.getMessage("LABEL.D.D15.0119")%></font></td>
		</div>
	</div>

<%
    }
%>

	<h2 class="subtitle"><%= year %><!-- 년 --><%=g.getMessage("LABEL.D.D15.0020")%> <%= month %><!-- 월 --><%=g.getMessage("LABEL.D.D15.0021")%></h2>
<%    if ( DispFlag.equals("true")  ) {  %>
                 ( <!-- 총공수 --><%=g.getMessage("LABEL.D.D15.0121")%> : <%= WebUtil.printNumFormat(KONGSU_HOUR,1)%> )
<%    }  %>

	<div class="tableArea">
		<div class="table">
			<table class="listTable">
				<colgroup>
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
					<col width="7.69%" />
				</colgroup>
                    <tr>
                      <th rowspan="2"><!-- 구 분 --><%=g.getMessage("LABEL.D.D15.0122")%> </th>
                      <th colspan="4"><!-- 추가 근로(시간) --><%=g.getMessage("LABEL.D.D15.0123")%></th>
                      <th colspan="3"><!-- 사원급료정보 --><%=g.getMessage("LABEL.D.D15.0124")%> </th>
                      <th colspan="2"><!-- 휴 가(일수) --><%=g.getMessage("LABEL.D.D15.0125")%> </th>
                      <th class="lastCol" colspan="3"><!-- 기 타(일수) --><%=g.getMessage("LABEL.D.D15.0126")%></th>
                    </tr>
                    <tr>
                      <th ><!-- 평일연장 --><%=g.getMessage("LABEL.D.D15.0127")%></th>
                      <th><!--휴일연장 --><%=g.getMessage("LABEL.D.D15.0128")%></th>
                      <th><!-- 야간근무 --><%=g.getMessage("LABEL.D.D15.0129")%></th>
                      <th><!-- 휴일근무 --><%=g.getMessage("LABEL.D.D15.0130")%></th>
                      <th><!-- 향군수당 --><%=g.getMessage("LABEL.D.D15.0131")%></th>
                      <th><!-- 교육수당 --><%=g.getMessage("LABEL.D.D15.0132")%></th>
                      <th><!-- 당직 --><%=g.getMessage("LABEL.D.D15.0133")%></th>
                      <th><!-- 사용휴가 --><%=g.getMessage("LABEL.D.D15.0134")%></th>
                      <th><!-- 보건휴가 --><%=g.getMessage("LABEL.D.D15.0135")%></th>
                      <th><!-- 결근 --><%=g.getMessage("LABEL.D.D15.0136")%></th>
                      <th><!-- 지각 --><%=g.getMessage("LABEL.D.D15.0137")%></th>
                      <th class="lastCol"><!-- 조퇴 --><%=g.getMessage("LABEL.D.D15.0138")%></th>
                    </tr>
                    <tr>
                      <th><B><!-- 월 계 --><%=g.getMessage("LABEL.D.D15.0139")%></B></th>
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
                      <th  class="lastCol"><%= COL9  %></th>
                    </tr>
			</table>
		</div>
	</div>

<%
}
%>

</div>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

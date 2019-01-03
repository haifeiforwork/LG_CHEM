<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 사원평가                                                    */
/*   Program Name : 평가사항 조회                                               */
/*   Program ID   : B01ValuateDetail_m.jsp                                      */
/*   Description  : 사원의 평가 사항을 조회                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2002-07-12  김도신                                          */
/*   Update       : 2005-01-11  윤정현                                          */
/*                  2006-01-03  LSA HR INDEX추가                                */
/*                  2006-01-06  LSA 조회기간전에 팀장확인가능하게 함            */
/*                  2006-01-17  @v1.1LSA 상사점수(기존 상사점수*0.8*1.125)에서 그냥 상사점수의 합(다시 역환산함)*/
/*                  2006-02-22  @v1.2 신평가시스템연결 업적display group 없앰   */
/*                  2006-03-20  @v1.3 상세연결                                  */
/*                  2008-04-22  @v1.3 CSR ID:1249079 조회화면 조정              */
/*                  2013-05-24  CSR ID:99999 현장직은 본인 평가화면 조회하지 않음   */
/*                               전문기술직(실장 포함) 31 , 기능직33 은 현장직평가표 조회  */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                  2014-07-29 [CSR ID:2583929] 사원서브그룹 추가에 따른 프로그램 수정 요청                                                            */
/*                  2014-11-25 [CSR ID:2651528] 인사권한 추가 및 메뉴조회 기능 변경           */
/*                  2016-02-22 [CSR ID:2990374] 전문기술직 15년도 개인평가 결과 Open => 환경 안전 -> 안전환경 문구만 변경 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.B.*" %>
<%@ page import="com.sns.jdf.security.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.B.db.*" %>
<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);
    Vector B01ValuateDetailData_vt = (Vector)request.getAttribute("B01ValuateDetailData_vt");
    String DB_YEAR                 = (String)request.getAttribute("DB_YEAR");
    String StartDate               = (String)request.getAttribute("StartDate");
    String retnMsg                 = (String)request.getAttribute("retnMsg");
    B01ValuateDetailDB valuateDetailDB     = new B01ValuateDetailDB();
    StartDate           = valuateDetailDB.getBossStartDate();

    String empNo     = "";
    if ( user_m != null )
        empNo     = DataUtil.fixEndZero(user_m.empNo, 8);
    else
        empNo     = DataUtil.fixEndZero(user.empNo, 8);


//  2015- 06-08 개인정보 통합시 subView ="Y";
    String subView = WebUtil.nvl(request.getParameter("subView"));
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function  doSearchDetail() {
    document.form1.action = "<%= WebUtil.ServletURL %>hris.B.B01ValuateDetailSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}
//-->
</SCRIPT>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="JavaScript">
function goLink(year,grade) {
    width  = screen.width*7/10;
    height = screen.height*7/10;
    vleft  = screen.width*1/10;
    vtop   = screen.height*1/10;
    //@v1.2
    window.open("","HRIS","toolbar=0,directories=0,menubar=0,status=0,resizable=0,location=0,scrollbars=1,left="+vleft+",top="+vtop+",width="+width+" height="+height);

    var link = "/app/jsp/app501_012.jsp?S_NAPEMPID=<%= Encoder.Chang(empNo) %>&S_APYEAR="+year+"&S_APRLTGRD="+grade;
    document.form_hris.linkpage.value = link;

    document.form_hris.action = "http://ehrapp.lgchem.com:9010/appindex.jsp";
    //document.form_hris.action = "http://epdev.lgchem.com:9010/appindex.jsp";

    document.form_hris.target = "HRIS";
    document.form_hris.submit();
}
</script>
<link href="<%= WebUtil.ImageURL %>css/ehr.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<!-- 2013-08-21 [CSR ID:2389767] [정보보안] 화면캡쳐방지  -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false"  onKeyUp="ClipBoardClear()">
<form name="form_hris" method="post">
    <input type=hidden name=linkpage value="">
    <input type=hidden name=stylecss value="blue">
    <input type=hidden name=empid value="<%=Encoder.Chang(empNo)%>">
</form>
<form name="form1" method="post">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="1">&nbsp;</td>
      <td>
      <table width="780" border="0" cellspacing="0" cellpadding="0">

          <tr>
            <td>
            <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="15" colspan="2"></td>
                </tr>
 <%if(!subView.equals("Y")){ %>
                <tr>
                  <td width="624" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">평가사항</td>
                  <td class="titleRight"><a href="javascript:open_help('X03PersonInfo.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a></td>
                </tr>
              </table></td>
          </tr>
          <!--   사원검색 보여주는 부분 시작   -->

          <!--   사원검색 보여주는 부분  끝    -->
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <%}
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
	//20141125 사무직이 현장직 평가 조회하면 권한 없다고 나와야 함. [CSR ID:2651528] 인사권한 추가 및 메뉴조회 기능 변경
	if(!retnMsg.equals("")){
%>
		<tr align="center">
        <td class="td04" colspan="17"><%=retnMsg %></td>
      	</tr>
<%
	}else{

      if ( user_m.e_persk.equals("31") || user_m.e_persk.equals("33")||user_m.e_persk.equals("38") ) { // Start CSR ID:99999 현장직평가표 전문기술직(실장 포함) 31 , 기능직33 은 현장직평가표, [CSR ID:2583929] 생산기술직 38 추가
     %>

          <tr>
            <td>
              <!--평가사항 리스트 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
               <tr>
                 <td class="td03" width="60" rowspan=2>년도</td>
                 <td class="td03" width="150" rowspan=2>소속</td>
                 <td class="td03" width="100" rowspan=2>직급</td>
                 <td class="td03" width="70" rowspan=2>호칭</td>
                 <td class="td03" width="120" colspan=3>업적평가</td>
                 <td class="td03" width="50" rowspan=2>능력</td>
                 <td class="td03" width="50" rowspan=2>태도</td>
                 <td class="td03" width="50" rowspan=2>절대<br>평가</td>
                 <td class="td03" width="50" rowspan=2>상대화</td>
                 <td class="td03" width="80" rowspan=2>최종<br>평가자</td>
               </tr>
               <tr>
                 <td class="td03" width="40">본인</td>
                 <td class="td03" width="40">상사</td>
                 <td class="td03" width="40">계</td>
               </tr>
     <%
         double d_RATING5 = 0; //@v1.1

         if( B01ValuateDetailData_vt.size() > 0 ) {
             for ( int i = 0 ; i < B01ValuateDetailData_vt.size() ; i++ ) {
                 B01ValuateDetailData data = ( B01ValuateDetailData ) B01ValuateDetailData_vt.get( i ) ;

                 d_RATING5 = Double.parseDouble(data.RATING5);
     %>
               <tr>
                 <td class="td04"><%= data.YEAR1 %></td>
                 <td class="td04" style="text-align:left">&nbsp;<%= data.ORGTX %></td>
                 <td class="td04"><%= data.TRFGR %></td>
                 <td class="td04"><%= data.TITEL %></td>
                 <td class="td04"><%= data.RATING4.equals("0.0") ? "" : data.RATING4 %></td>
                 <td class="td04"><%= data.RATING5.equals("0.0") ? "" : String.valueOf(d_RATING5) %></td>
                 <td class="td04"><%= data.RATING7 %></td>
                 <td class="td04"><%= data.RATING1.equals("0.0") ? "" : data.RATING1 %></td>
                 <td class="td04"><%= data.RATING2.equals("0.0") ? "" : data.RATING2 %></td>
                 <td class="td04"><%= data.TOTL %></td>
                 <td class="td04"><%= data.RTEXT1 %></td>
                 <td class="td04"><%= data.BOSS_NAME %></td>
               </tr>
     <%

             }


         } else {
     %>
               <tr align="center">
                 <td class="td04" colspan="17">해당하는 데이터가 존재하지 않습니다.</td>
               </tr>
     <%
         }

     }else  { //사무직평가표

%>
          <tr>
            <td>
              <!--평가사항 리스트 테이블 시작-->
              <table width="780" border="0" cellspacing="1" cellpadding="2" class="table02">
          <tr>
            <td class="td03" width="25" rowspan=2>년도</td>
            <td class="td03" width="141" rowspan=2>소속</td>
            <td class="td03" width="55" rowspan=2>직급</td>
            <td class="td03" width="35" rowspan=2>호칭</td>
            <td class="td03" width="100" colspan=3>업무목표달성도</td>
            <td class="td03" width="40" rowspan=2>난이도<br>/<br>기여도</td>
            <td class="td03" width="30" rowspan=2>안전<br>환경</td>
            <td class="td03" colspan=3>HR Index</td>
            <td class="td03" width="38" rowspan=2>능력</td>
            <td class="td03" width="30" rowspan=2>태도</td>
            <td class="td03" width="40" rowspan=2>절대<br>평가</td>
            <td class="td03" width="15" rowspan=2>상대화</td>
            <td class="td03" width="55" rowspan=2>최종<br>평가자</td>
          </tr>
          <tr>
            <td class="td03" width="30">본인</td>
            <td class="td03" width="30">상사</td>
            <td class="td03" width="40">계</td>
            <td class="td03" width="40">조직<br>활성화</td>
            <td class="td03" width="62">HR<br>KPI</td>
            <td class="td03" width="40">계</td>
          </tr>
                <%
        double d_RATING5 = 0; //@v1.1
        if( B01ValuateDetailData_vt.size() > 0 ) {
            for ( int i = 0 ; i < B01ValuateDetailData_vt.size() ; i++ ) {
                B01ValuateDetailData data = ( B01ValuateDetailData ) B01ValuateDetailData_vt.get( i ) ;

                //@v1.1
                if (Integer.parseInt(data.YEAR1) > 1998 &&Integer.parseInt(data.YEAR1) < 2006)
                    d_RATING5 = DataUtil.nelim(Double.parseDouble(data.RATING5)/0.8/1.125,1);
                else
                    d_RATING5 = Double.parseDouble(data.RATING5);

                if( data.YEAR1.equals(DB_YEAR) ) { //당해년도
                    if( Long.parseLong(StartDate) <= Long.parseLong(DataUtil.getCurrentDate()) ) {

%>
                <tr>

<%
                    if( !data.L_FLAG.equals("Y") ) {
%>
            <td class="td04"><a href="javascript:goLink(<%= data.YEAR1 %>,'<%= data.RTEXT1 %>');"><font color="#006699"><%= data.YEAR1 %></font></a></td>
<%
                    } else {
%>
            <td class="td04"><%= data.YEAR1 %></td>
<%
                    }
%>
                  <td class="td04" style="text-align:left">&nbsp;<%= data.ORGTX %></td>
                  <td class="td04"><%= data.TRFGR %></td>
                  <td class="td04"><%= data.TITEL %></td>
                  <td class="td04"><%= data.RATING4.equals("0.0") ? "" : data.RATING4 %></td>
                  <td class="td04"><%= data.RATING5.equals("0.0") ? "" : String.valueOf(d_RATING5) %></td>
                  <td class="td04"><%= data.RATING7 %></td>
                  <td class="td04"><%= data.RATING6.equals("0.0") ? "" : data.RATING6 %></td>
                  <td class="td04"><%= data.RATING9.equals("0.0") ? "" : data.RATING9 %></td>
                  <td class="td04"><%= data.RATING8.equals("0.0") ? "" : data.RATING8 %></td>
                  <td class="td04"><%= data.RATING10.equals("0.0") ? "" : data.RATING10 %><br><%= data.RATING3.equals("0.0") ? "" : "("+data.RATING3+")" %></td>
                  <td class="td04"><%= data.RATING12.equals("0.0") ? "" : data.RATING12 %></td>
                  <td class="td04"><%= data.RATING1.equals("0.0") ? "" : data.RATING1 %><br><%= data.RATING11.equals("")||data.RATING11.equals("0.0") ? "" : "("+data.RATING11+")" %></td>
                  <td class="td04"><%= data.RATING2.equals("0.0") ? "" : data.RATING2 %></td>
                  <td class="td04"><%= data.TOTL %></td>
                  <td class="td04"><%= data.RTEXT1 %></td>
                  <td class="td04"><%= data.BOSS_NAME %></td>
                </tr>
                <%
                    }
                } else { //당행년도 이전
%>
                <tr>
<%
                    if( Integer.parseInt(data.YEAR1) > 1998) {
%>
            <td class="td04"><a href="javascript:goLink(<%= data.YEAR1 %>,'<%= data.RTEXT1 %>');"><font color="#006699"><%= data.YEAR1 %></font></a></td>
<%
                    } else {
%>
            <td class="td04"><%= data.YEAR1 %></td>
<%
                    }
%>
                  <td class="td04" style="text-align:left">&nbsp;<%= data.ORGTX %></td>
                  <td class="td04"><%= data.TRFGR %></td>
                  <td class="td04"><%= data.TITEL %></td>
                  <td class="td04"><%= data.RATING4.equals("0.0") ? "" : data.RATING4 %></td>
                  <td class="td04"><%= data.RATING5.equals("0.0") ? "" : String.valueOf(d_RATING5) %></td>
                  <td class="td04"><%= data.RATING7 %></td>
                  <td class="td04"><%= data.RATING6.equals("0.0") ? "" : data.RATING6 %></td>
                  <td class="td04"><%= data.RATING9.equals("0.0") ? "" : data.RATING9 %></td>
                  <td class="td04"><%= data.RATING8.equals("0.0") ? "" : data.RATING8 %></td>
                  <td class="td04"><%= data.RATING10.equals("0.0") ? "" : data.RATING10 %><br><%= data.RATING3.equals("0.0") ? "" : "("+data.RATING3+")" %></td>
                  <td class="td04"><%= data.RATING12.equals("0.0") ? "" : data.RATING12 %></td>
                  <td class="td04"><%= data.RATING1.equals("0.0") ? "" : data.RATING1 %><br><%= data.RATING11.equals("")||data.RATING11.equals("0.0") ? "" : "("+data.RATING11+")" %></td>
                  <td class="td04"><%= data.RATING2.equals("0.0") ? "" : data.RATING2 %></td>
                  <td class="td04"><%= data.TOTL %></td>
                  <td class="td04"><%= data.RTEXT1 %></td>
                  <td class="td04"><%= data.BOSS_NAME %></td>
                </tr>
                <%
                }
            }
        } else {
%>
                <tr align="center">
                  <td class="td04" colspan="17">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
                <%
        }
%>


<%
      } //사무직평가표end
	}// 권한 check end
}
%>
              </table>
              <!--평가사항 리스트 테이블 끝-->
            </td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
            <td height="30">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>
</body>
</html>
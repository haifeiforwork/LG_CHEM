<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 채권가압류                                                  */
/*   Program Name : 채권가압류                                                  */
/*   Program ID   : D09BondList.jsp                                             */
/*   Description  : 채권 압류 현황을 조회                                       */
/*   Note         :                                                             */
/*   Creation     : 2002-02-27  한성덕                                          */
/*   Update       : 2005-01-28  윤정현                                          */
/*                      2017-07-26 [CSR ID:3444703] 채권가압류 미공제잔액 금액 수정 요청                                                        */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D09Bond.*" %>
<%@ page import="hris.D.D09Bond.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<jsp:include page="/include/header.jsp" />
<%
    WebUserData user = WebUtil.getSessionUser(request);
    Vector D09BondListData_vt = ( Vector ) request.getAttribute( "D09BondListData_vt" ) ;

    String CRED_TOTA   = ( String ) request.getAttribute( "CRED_TOTA"   );  // 가압류총액
    String G_SUM       = ( String ) request.getAttribute( "G_SUM"       );  // 공제총액
    String dedu_rest   = ( String ) request.getAttribute( "dedu_rest"   );  // 미공제잔액
    String GIVE_TOTA   = ( String ) request.getAttribute( "GIVE_TOTA"   );  // 지급총액
    String G_DPOT_REST = ( String ) request.getAttribute( "G_DPOT_REST" );  // 미배당공탁액
    String coll_rest   = ( String ) request.getAttribute( "coll_rest"   );  // 예수금잔액
    String REST_TOTA   = ( String ) request.getAttribute( "REST_TOTA"   );  // 가압류잔액 합계
    //[CSR ID:3444703] 채권가압류 미공제잔액 금액 수정 요청
    if(Double.parseDouble(dedu_rest) <0) {
    	dedu_rest = "0.0";
    }
%>

<script language="JavaScript">
<!--
function goDetail( i ) {
    arguSetting( i ) ;
    document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondDetailSV' ;
    document.form2.method = 'post' ;
    document.form2.submit() ;
}

// 지급액
function goProvDetail( i, value ) {
    if( value == 0 ) {
        //alert("조회할 내용이 없습니다.");
        alert("<%=g.getMessage("MSG.D.D15.0012")%>");
        return;
    }
    arguSetting( i ) ;
    document.form2.action      = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondProvisionSV' ;
    document.form2.jobid.value = 'detail' ;
    document.form2.method      = 'post' ;
    document.form2.submit() ;
}

// 지급총액
function goGiveTota( value ) {
    if( value == 0 ) {
        //alert("조회할 내용이 없습니다.");
        alert("<%=g.getMessage("MSG.D.D15.0012")%>");
        return;
    }
    document.form2.MGTT_NUMB.value  = "";
    document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondProvisionSV' ;
    document.form2.method = 'post' ;
    document.form2.submit() ;
}

// 미배당공탁액
function goDpotTota( value ) {
    if( value == 0 ) {
        //alert("조회할 내용이 없습니다.");
        alert("<%=g.getMessage("MSG.D.D15.0012")%>");
        return;
    }
    document.form2.action = '<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondDepositSV' ;
    document.form2.method = 'post' ;
    document.form2.submit() ;
}

function arguSetting( i ) {
    eval("document.form2.BEGDA.value      = document.form1.BEGDA" + i + ".value");
    eval("document.form2.CRED_NAME.value  = document.form1.CRED_NAME" + i + ".value");
    eval("document.form2.MGTT_NUMB.value  = document.form1.MGTT_NUMB" + i + ".value");
    eval("document.form2.CRED_ADDR.value  = document.form1.CRED_ADDR" + i + ".value");
    eval("document.form2.CRED_AMNT.value  = document.form1.CRED_AMNT" + i + ".value");
    eval("document.form2.CRED_TEXT.value  = document.form1.CRED_TEXT" + i + ".value");
    eval("document.form2.CRED_NUMB.value  = document.form1.CRED_NUMB" + i + ".value");
    eval("document.form2.SEQN_NUMB.value  = document.form1.SEQN_NUMB" + i + ".value");
}
//-->
</script>
<%-- html body 안 헤더부분 - 타이틀 등 --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D15.0140"/>
    <jsp:param name="click" value="Y"/>
</jsp:include>

  <!-- 조회 리스트 테이블 시작-->
  <form name="form1" method="post">
  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <thead>
          <tr>
            <th><!-- No. --><%=g.getMessage("LABEL.D.D15.0022")%></th>
            <th><!-- 접수일 --><%=g.getMessage("LABEL.D.D15.0023")%></th>
            <th><!-- 채권자 --><%=g.getMessage("LABEL.D.D15.0024")%></th>
            <th><!--법원결정내용 --><%=g.getMessage("LABEL.D.D15.0025")%></th>
            <th><!--가압류액 --><%=g.getMessage("LABEL.D.D15.0026")%></th>
            <th><!--지급액 --><%=g.getMessage("LABEL.D.D15.0027")%></th>
            <th><!--가압류잔액 --><%=g.getMessage("LABEL.D.D15.0028")%></th>
            <th class="lastCol"><!--해지일 --><%=g.getMessage("LABEL.D.D15.0029")%></th>
          </tr>
        </thead>
        <tbody>
<%
    if( D09BondListData_vt.size() > 0 ) {
        for ( int i = 0 ; i < D09BondListData_vt.size() ; i++ ) {
            D09BondListData data = ( D09BondListData ) D09BondListData_vt.get( i ) ;

            // 2004.09.14 수정 - 화면수정
            D09BondCortRFC func1              = null ;
            Vector         D09BondCortData_vt = null ;
            func1 = new D09BondCortRFC() ;
            D09BondCortData_vt = func1.getBondCort( user.empNo, data.CRED_NUMB, data.SEQN_NUMB );

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
          <tr class="<%=tr_class%>">
            <td><%= i + 1 %></td>
            <td><a href="javascript:goDetail(<%= i %>);"><font color="#006699"><%= WebUtil.printDate( data.BEGDA ) %></font></a></td>
            <td><%= data.CRED_NAME %></td>
            <td>
<%
            if(D09BondCortData_vt !=null &&  D09BondCortData_vt.size() > 0 ) {
                for ( int j = 0 ; j < D09BondCortData_vt.size() ; j++ ) {
                    D09BondCortData cdata = ( D09BondCortData ) D09BondCortData_vt.get( j ) ;
                    if( j > 0 ) {
%>
<br>
<%
                    }
%>

            <%= cdata.ATTA_TEXT %>
<%
                }
            }
%>
            </td>
            <td class="align_right"><%= WebUtil.printNumFormat( data.CRED_AMNT ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
            <td class="align_right"><a href="javascript:goProvDetail(<%= i %>, <%= data.GIVE_AMNT %>);"><font color="#006699"><%= WebUtil.printNumFormat( data.GIVE_AMNT ) %><!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></font></a></td>
            <td class="align_right"><%= WebUtil.printNumFormat( data.REST_AMNT ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
            <td class="lastCol"><%= data.ENDDA.equals( "0000-00-00" ) ? "" : WebUtil.printDate( data.ENDDA ) %>
             <input type="hidden" name="BEGDA<%=i%>"      value="<%= data.BEGDA  %>">
            <input type="hidden" name="CRED_NAME<%=i%>"  value="<%= data.CRED_NAME  %>">
            <input type="hidden" name="MGTT_NUMB<%=i%>"  value="<%= data.MGTT_NUMB  %>">
            <input type="hidden" name="CRED_ADDR<%=i%>"  value="<%= data.CRED_ADDR  %>">
            <input type="hidden" name="CRED_AMNT<%=i%>"  value="<%= data.CRED_AMNT  %>">
            <input type="hidden" name="CRED_TEXT<%=i%>"  value="<%= data.CRED_TEXT  %>">
            <input type="hidden" name="CRED_NUMB<%=i%>"  value="<%= data.CRED_NUMB  %>">
            <input type="hidden" name="SEQN_NUMB<%=i%>"  value="<%= data.SEQN_NUMB  %>">
            </td>

        </tr>

<%
        }
%>
        <tr class="sumRow">
          <td>계</td>
          <td></td>
          <td></td>
          <td></td>
          <td class="align_right"><%= WebUtil.printNumFormat( CRED_TOTA ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
          <td class="align_right"><%= WebUtil.printNumFormat( GIVE_TOTA ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
          <td class="align_right"><%= WebUtil.printNumFormat( REST_TOTA ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
          <td class="lastCol"></td>
        </tr>
      </tbody>
      </table>
    </div>
  </div>
  </form>

  <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
        <tr>
          <th><!--가압류 총액--><%=g.getMessage("LABEL.D.D15.0030")%></th>
          <td class="align_right"><%= WebUtil.printNumFormat( CRED_TOTA ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></th>
          <th class="th02"><!-- 공제액(해지건 제외) --><%=g.getMessage("LABEL.D.D15.0031")%></th>
          <td class="align_right"><%= WebUtil.printNumFormat( G_SUM ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></th>
          <th class="th02"><!-- 미공제 잔액 --><%=g.getMessage("LABEL.D.D15.0032")%></th>
          <td class="align_right"><%= WebUtil.printNumFormat( dedu_rest ) %><!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></th>
        </tr>
        <tr>
          <th><!-- 지급 총액--><%=g.getMessage("LABEL.D.D15.0036")%></th>
          <td class="align_right"><a href="javascript:goGiveTota('<%= GIVE_TOTA %>');"><font color="#006699"><%= WebUtil.printNumFormat( GIVE_TOTA ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></font></a></td>
          <th class="th02"><!-- 미배당 공탁액 --><%=g.getMessage("LABEL.D.D15.0033")%></th>
          <td class="align_right"><a href="javascript:goDpotTota('<%= G_DPOT_REST %>');"><font color="#006699"><%= WebUtil.printNumFormat( G_DPOT_REST ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></font></a></td>
          <th class="th02"><!-- 예수금 잔액 --><%=g.getMessage("LABEL.D.D15.0034")%></th>
          <td class="lastCol align_right"><%= WebUtil.printNumFormat( coll_rest ).equals("-0") ? "" : WebUtil.printNumFormat( coll_rest ) %> <!-- 원 --><%=g.getMessage("LABEL.D.D15.0010")%></td>
        </tr>
      </table>
    </div>
  </div>

  <div class="buttonArea">
      <ul class="btn_crud">
          <li><a href="<%= WebUtil.ServletURL %>hris.D.D09Bond.D09BondDeductionSV"><span><!-- 공제 현황 조회 --><%=g.getMessage("LABEL.D.D15.0035")%></span></a></li>
      </ul>
  </div>


<%
    } else {
%>
            <tr class="oddRow">
              <td colspan="8" class="lastCol align_center"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.D.D15.0013")%></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

<%
    }
%>

</div>


<form name="form2">
<!-----   hidden field ---------->
  <input type="hidden" name="BEGDA"      value="">
  <input type="hidden" name="CRED_NAME"  value="">
  <input type="hidden" name="MGTT_NUMB"  value="">
  <input type="hidden" name="CRED_ADDR"  value="">
  <input type="hidden" name="CRED_AMNT"  value="">
  <input type="hidden" name="CRED_TEXT"  value="">
  <input type="hidden" name="CRED_NUMB"  value="">
  <input type="hidden" name="SEQN_NUMB"  value="">

  <input type="hidden" name="jobid"      value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

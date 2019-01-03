<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 국민연금                                                    */
/*   Program Name : 국민연금                                                    */
/*   Program ID   : E29PensionDetail_m.jsp                                      */
/*   Description  : 국민연금에 대한 개인누계 및 연도별상세내역을 조회           */
/*   Note         :                                                             */
/*   Creation     : 2002-12-23  이형석                                          */
/*   Update       : 2005-01-25  윤정현                                          */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E29PensionDetail.*" %>

<%
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    WebUserData user = WebUtil.getSessionUser(request);

    String jobid_m = (String)request.getAttribute("jobid_m");

    E29PensionDetailData data = (E29PensionDetailData)request.getAttribute("E29PensionDetailData");
    DataUtil.fixNull(data);

    Vector E29PensionDetail_vt = (Vector)request.getAttribute("E29PensionDetail_vt");

    int year      = Integer.parseInt((String)request.getAttribute("year"));

    int startYear = Integer.parseInt( DataUtil.getCurrentYear() );
    int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

    if ( user_m != null ) {
        startYear = Integer.parseInt( (user_m.e_dat03).substring(0,4) );
    }

    if( startYear < 2002 ){
        startYear = 2002;
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
function  doSearchDetail() {

    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E29PensionDetail.E29PensionListSV_m";
    document.form1.method = "post";
    document.form1.target = "menuContentIframe";
    document.form1.submit();
}

function doSubmit(){
    document.form1.YEAR.value  = document.form1.YEAR[form1.YEAR.selectedIndex].value ;
    document.form1.jobid_m.value = "search";
    document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E29PensionDetail.E29PensionListSV_m';
    document.form1.method = "post";
    document.form1.submit();
}

$(function() {
	 if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
});
//-->
</script>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="help" value="X03PersonInfo.html"/>
    </jsp:include>
<form name="form1" method="post">
<input type="hidden" name="jobid_m" value="">
          <%
// 사원 검색한 사람이 없을때
if ( user_m != null ) {
%>

<%
    if( data.E_LNMHG.equals("") && data.E_FNMHG.equals("") ) {
%>
    <div class="align_center">
            <p><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></p>
    </table>
<%
    } else {
%>
    <div class="tableArea">
        <div class="table">
            <table class="listTable">
            <thead>
              <tr>
                <th><!-- 성명 --><%=g.getMessage("LABEL.E.E29.0001")%></th>
                <th><!-- 주민번호 --><%=g.getMessage("LABEL.E.E29.0002")%></th>
                <th><!-- 현재등급 --><%=g.getMessage("LABEL.E.E29.0003")%></th>
                <th class="lastCol"><!-- 가입일 --><%=g.getMessage("LABEL.E.E29.0004")%></th>
              </tr>
             </thead>
              <tr class="oddRow">
                <td><%=data.E_LNMHG%><%=data.E_FNMHG%></td>
                <td><%= data.E_REGNO.substring(0, 6) + "-*******" %></td>
                <td><%=WebUtil.printNum(data.E_GRADE)%><!-- 등급 --><%=g.getMessage("LABEL.E.E29.0005")%></td>
                <td class="lastCol"><%=WebUtil.printDate(data.E_BEGDA)%></td>
              </tr>
            </table>
        </div>
    </div>

    <h2 class="subtitle"> <!-- 총누계내역 --><%=g.getMessage("LABEL.E.E29.0014")%></h2>

    <!--총누계내역 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            	<colgroup>
            		<col width="20%" />
            		<col width="30%" />
            		<col width="20%" />
            		<col width="30%" />
            	</colgroup>
              <tr>
                <th><!-- 본인부담금 --><%=g.getMessage("LABEL.E.E29.0006")%></th>
                <td class="align_right"><%=WebUtil.printNumFormat(data.E_MY_PAYMENT)%></td>
                <th class="th02"><!-- 퇴직전환금 --><%=g.getMessage("LABEL.E.E29.0007")%></th>
                <td class="align_right"><%=WebUtil.printNumFormat(data.E_RETIRE_PAYMENT)%></td>
              </tr>
              <tr>
                <th><!-- 회사부담금 --><%=g.getMessage("LABEL.E.E29.0008")%></th>
                <td class="align_right"><%=WebUtil.printNumFormat(data.E_FIRM_PAYMENT)%></td>
                <th class="th02"><!-- 총불입금액 --><%=g.getMessage("LABEL.E.E29.0009")%></th>
                <td class="align_right"><%=WebUtil.printNumFormat(data.E_TOTAL_PAYMENT)%></td>
              </tr>
            </table>
        </div>
    </div>
    <!--총누계내역 테이블 끝-->

    <h2 class="subtitle"> <!-- 퇴직전환금 --><%=g.getMessage("LABEL.E.E29.0007")%></h2>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            	<colgroup>
            		<col width="20%" />
            		<col width="30%" />
            		<col width="20%" />
            		<col width="30%" />
            	</colgroup>
               <tr>
                <th><!-- 본인부담금 --><%=g.getMessage("LABEL.E.E29.0006")%></td>
                <td class="align_right" colspan="3"><%=WebUtil.printNumFormat(data.E_PENI_AMNT)%></td>
               </tr>
               <tr>
                <th><!-- 퇴직전환금 --><%=g.getMessage("LABEL.E.E29.0007")%> <!-- 회사부담금 --><%=g.getMessage("LABEL.E.E29.0008")%></th>
                <td class="align_right"><%=WebUtil.printNumFormat(data.E_PENC_AMNT)%></td>
                <th class="th02"><!-- 퇴직전환금 --><%=g.getMessage("LABEL.E.E29.0007")%>(<!-- 전근무지 --><%=g.getMessage("LABEL.E.E29.0010")%>)</th>
                <td class="align_right"><%=WebUtil.printNumFormat(data.E_PENB_AMNT)%></td>
              </tr>
             </table>
        </div>
    </div>
        <div class="listTop">
		<h2 class="subtitle withButtons"><!-- 년도별 상세내역 --><%=g.getMessage("LABEL.E.E29.0011")%></h2>
            <div class="buttonArea" style="height:25px">
                			    <select name="YEAR" onChange="javascript:doSubmit()">
			        <%= WebUtil.printOption(CodeEntity_vt, String.valueOf(year) )%>
			    </select>
            </div>
        </div>
      <div class="listArea">

    <!--총누계내역 테이블 끝-->

    <!--년도별 상세내역 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="listTable">
             <thead>
              <tr>
                <th><!-- 월 --><%=g.getMessage("LABEL.E.E29.0012")%></th>
                <th><!-- 등급 --><%=g.getMessage("LABEL.E.E29.0005")%></th>
                <th><!-- 본인부담금 --><%=g.getMessage("LABEL.E.E29.0006")%></th>
                <th class="lastCol"><!-- 회사부담금 --><%=g.getMessage("LABEL.E.E29.0008")%></th>
              </tr>
              </thead>

<%
        if( E29PensionDetail_vt.size() > 0 ) {
            double totalBetrg = 0;
            double totalBetrgb = 0;
            for( int i = 0 ; i < E29PensionDetail_vt.size(); i = i + 2 ) {
                int j = i + 1;
                E29PensionDetailData pensiondata = (E29PensionDetailData)E29PensionDetail_vt.get(i);
                E29PensionDetailData pensiondata1 = (E29PensionDetailData)E29PensionDetail_vt.get(j);
                totalBetrg = totalBetrg + Double.parseDouble(pensiondata.BETRG);
                totalBetrgb = totalBetrgb + Double.parseDouble(pensiondata1.BETRG);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }

%>
                  <tr class="<%=tr_class%>">
                    <td><%= WebUtil.printNum(pensiondata.PAYDT.substring(5,7)) %><!-- 월 --><%=g.getMessage("LABEL.E.E29.0012")%></td>
                    <td><%= WebUtil.printNum(pensiondata.GRADE)%></td>
                    <td class="align_right"><%= WebUtil.printNumFormat(pensiondata.BETRG)%></td>
                    <td class="lastCol align_right"><%= WebUtil.printNumFormat(pensiondata1.BETRG)%></td>
                  </tr>
<%
        }
%>
                  <tr class="sumRow">
                    <td colspan="2">계</td>
                    <td class="align_right"><%=WebUtil.printNumFormat(totalBetrg)%></td>
                    <td class="lastCol align_right"><%=WebUtil.printNumFormat(totalBetrgb)%></td>
                </tr>
            </table>
        <div>
    </div>
    </div>
    <!--년도별 상세내역 테이블 끝-->

<%
        } else {
            if( jobid_m.equals("first")||jobid_m.equals("search") ) {
%>
          <tr class="oddRow">
            <td class="lastCol align_center" colspan="4"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
          </tr>
            </table>
        <div>
    </div>
    </div>
<%
            }
        }
    }
%>

</div>

<%
}
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
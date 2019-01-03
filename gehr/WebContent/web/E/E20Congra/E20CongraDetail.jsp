<%/******************************************************************************/

/*                                                                              */

/*   System Name  : MSS                                                         */

/*   1Depth Name  : MY HR 정보                                                  */

/*   2Depth Name  : 경조금                                                      */

/*   Program Name : 경조금 상세조회                                             */

/*   Program ID   : E20CongraDetail.jsp                                         */

/*   Description  : 경조금 상세조회                                             */

/*   Note         : 없음                                                        */

/*   Creation     :                                                             */

/*   Update       : 2005-01-31  윤정현                                          */

/*                  2005/11/03  version @v1.1 C2005101901000000340 :회수내역추가 */

/*                  2014-07-31  [CSR ID:2584987] HR Center 경조금 신청 화면 문구 수정                                            */

/********************************************************************************/%>



<%@ page contentType="text/html; charset=utf-8" %>

<%@ include file="/web/common/commonProcess.jsp" %>



<%@ page import="com.sns.jdf.servlet.*" %>

<%@ page import="hris.E.E20Congra.*" %>



<%

    WebUserData     user = (WebUserData)session.getAttribute("user");

    Box             box  = WebUtil.getBox(request);

    E20CongcondData data = new E20CongcondData();

    box.copyToEntity(data);

%>

<jsp:include page="/include/header.jsp" />

<script language="JavaScript">

<!--

function open_report(){

//    window.open('', 'essNewWindow', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=550,height=350");

    document.form1.CONG_DATE.value = removePoint(document.form1.CONG_DATE.value);

//    document.form1.target = 'essNewWindow';

    document.form1.action = '<%= WebUtil.ServletURL %>hris.E.E20Congra.E20ReportDetailSV';

    document.form1.method = "post";

    document.form1.submit();

}



function MM_openBrWindow(theURL,winName,features) {//v2.0

  window.open(theURL,winName,features);

}

$(document).ready(function(){
	if(parent.resizeIframe) parent.resizeIframe(document.body.scrollHeight);
 });

//-->

</script>

<jsp:include page="/include/body-header.jsp">
    <jsp:param name="click" value="Y"/>
</jsp:include>
<form name="form1" method="post">

    <!-- 상단 입력 테이블 시작-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
                    <colgroup>
            		<col width="15%" />
            		<col  />

            	</colgroup>
                <tr>
                    <th><!-- 경조내역 --><%=g.getMessage("LABEL.E.E20.0002")%></th>
                    <td>
                        <input type="text" name="CONG_NAME" value="<%= data.CONG_NAME %>" size="20" readonly value="재해">

<%

    if( data.CONG_CODE.equals("0005") ){

%>

                        <a href="javascript:open_report();" class="inlineBtn"><span><!-- 재해피해신고서 조회 --><%=g.getMessage("LABEL.E.E19.0006")%></span></a>

<%

    }

%>

                    </td>
                </tr>

<%

    if( data.CONG_CODE.equals("0005") ){

        //

    } else {

%>

                <tr>
                    <th><!-- 경조대상자 관계 --><%=g.getMessage("LABEL.E.E20.0003")%></th>
                    <td><input type="text" name="RELA_NAME" value="<%= data.RELA_NAME %>" size="20" readonly></td>
                </tr>
                <tr>
                    <th><!-- 경조대상자 성명 --><%=g.getMessage("LABEL.E.E20.0009")%></th>
                    <td><input type="text" name="EREL_NAME" value="<%= data.EREL_NAME %>" size="20" readonly></td>
                </tr>

<%

    }

%>

                <tr>
                    <th><!-- 경조발생일자 --><%=g.getMessage("LABEL.E.E20.0005")%></th>
                    <td>
                        <input type="text" name="CONGDATE" value="<%= data.CONG_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.CONG_DATE) %>" size="20" readonly>
                        <input type="hidden" name="CONG_DATE" value="<%= data.CONG_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.CONG_DATE) %>" >
                    </td>
                </tr>

            </table>
        </div>
    </div>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            	<colgroup>
            		<col width="15%" />
            		<col width="35%" />
            		<col width="15%" />
            		<col width="35%" />
            	</colgroup>
                <tr>
                    <!--[CSR ID:2584987] 통상임금 -> 기준급  -->
                    <!-- <td width="100" class="td01">통상임금</td> -->
                    <th><!-- 기준급 --><%=g.getMessage("LABEL.E.E20.0010")%></th>
                    <td colspan="3">

<%

//  2002.07.09. 경조발생일자가 2002.01.01. 이전이면 통상임금, 경조금액을 보여주지 않는다.

    String dateCheck = "Y";


        long dateLong = Long.parseLong(DataUtil.removeStructur(data.CONG_DATE, "-"));



        if( dateLong < 20020101 ) {

            dateCheck = "N";

        }

        if( dateCheck.equals("Y") ) {

%>

                    <input type="text" name="WAGE_WONX" value="<%= WebUtil.printNumFormat(data.WAGE_WONX) %> " style="text-align:right" size="20" readonly> 원

<%

        } else {

%>

                    <input type="text" name="WAGE_WONX" value="" style="text-align:right" size="20" readonly>

<%

        }

%>
                    </td>
                </tr>
                <tr>
                    <th><!-- 지급율 --><%=g.getMessage("LABEL.E.E20.0011")%></th>
                    <td colspan="3"><input type="text" name="CONG_RATE" value="<%= data.CONG_RATE %> " style="text-align:right" size="20" readonly> %</td>
                </tr>
                <tr>
                    <th><!-- 경조금액 --><%=g.getMessage("LABEL.E.E20.0006")%></th>
                    <td colspan="3">

<%


        if( dateCheck.equals("Y") ) {

%>

                    <input type="text" name="CONG_WONX" value="<%= WebUtil.printNumFormat(data.CONG_WONX) %> " style="text-align:right" size="20" readonly> 원

<%

        } else {

%>

                    <input type="text" name="CONG_WONX" value="" style="text-align:right" size="20" readonly>

<%

        }
%>


                    </td>
                </tr>
                <tr>
                    <th><!-- 이체은행명 --><%=g.getMessage("LABEL.E.E20.0012")%></th>
                    <td><input type="text" name="BANK_NAME" value="<%= data.BANK_NAME %>" size="30" readonly></td>
                    <th class="th02"><!-- 은행계좌번호 --><%=g.getMessage("LABEL.E.E20.0013")%></th>
                    <td><input type="text" name="BANKN" value="<%= data.BANKN     %>" size="30" readonly></td>
                </tr>

<%

    if( data.CONG_CODE.equals("0005") ){

        //

    } else {

%>

                <tr>
                    <th><!-- 경조휴가일수 --><%=g.getMessage("LABEL.E.E20.0014")%></th>
                    <td colspan="3"><input type="text" name="HOLI_CONT" value="<%= data.HOLI_CONT.equals("") ? "" : WebUtil.printNum(data.HOLI_CONT) %>" style="text-align:right" size="10" readonly>  <!-- 일 --><%=g.getMessage("LABEL.E.E20.0016")%></td>
                </tr>

<%

    }

%>

                <tr>
                    <th><!-- 근속년수 --><%=g.getMessage("LABEL.E.E20.0015")%></th>
                    <td colspan="3">
                        <input type="text" name="WORK_YEAR" value="<%= data.WORK_YEAR.equals("00") ? "" : WebUtil.printNum(data.WORK_YEAR) %>" style="text-align:right" size="7" readonly> <!-- 년 --><%=g.getMessage("LABEL.E.E20.0017")%>
                        <input type="text" name="WORK_MNTH" value="<%= data.WORK_MNTH.equals("00") ? "" : WebUtil.printNum(data.WORK_MNTH) %>" style="text-align:right" size="10"  readonly> <!-- 개월 --><%=g.getMessage("LABEL.E.E20.0018")%>
                    </td>
                </tr>

            </table>
        </div>
    </div>
    <!-- 상단 입력 테이블 끝-->

    <!-- 회수내역추가 v1.1 START-->
    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral">
            	<colgroup>
            		<col width="15%" />
            		<col width="35%" />
            		<col width="15%" />
            		<col width="35%" />
            	</colgroup>
                <tr>
                    <th><!-- 반납일자 --><%=g.getMessage("LABEL.E.E20.0028")%></th>
                    <td><input type="text" name="RFUN_DATE" value="<%= data.RFUN_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.RFUN_DATE) %> " size="20" readonly></td>
                    <th class="th02"><!-- 반납액 --><%=g.getMessage("LABEL.E.E20.0029")%></th>
                    <td><input type="text" name="RFUN_AMNT" value="<%= WebUtil.printNumFormat(data.RFUN_AMNT) %> " style="text-align:right" size="20" readonly></td>
                </tr>
                <tr>
                    <th><!-- 반납사유 --><%=g.getMessage("LABEL.E.E20.0030")%></th>
                    <td><input type="text" name="RFUN_RESN" value="<%= data.RFUN_RESN %> " size="40" readonly></td>
                    <th class="th02"><!-- 회수전표번호 --><%=g.getMessage("LABEL.E.E20.0031")%></th>
                    <td><input type="text" name="BELNR1" value="<%= data.BELNR1 %> " size="20" readonly></td>
                </tr>
            </table>
        </div>
    </div>
    <!-- 회수내역추가 v1.1 END-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back();"><span><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
    </ul>
</div>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
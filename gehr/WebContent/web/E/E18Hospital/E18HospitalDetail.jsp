<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 조회                                                 */
/*   Program ID   : E19HospitalDetail.jsp                                       */
/*   Description  : 의료비 신청 조회                                            */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                  2005-11-09  lsa @v1.1:C2005110201000000339(의료비 조회시 이름포함 )*/
/*                  2005-12-29  @v1.2 C2005121301000001097 신용카드/현금구분추가*/
/*                  2006-01-20  @v1.3 연말정산제외 제거 연말정산반영액추가      */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.E.E18Hospital.*" %>
<%@ page import="hris.E.E18Hospital.rfc.*" %>

<%
    Vector E18HospitalDetailData_vt = ( Vector ) request.getAttribute( "E18HospitalDetailData_vt" ) ;
    String CTRL_NUMB  = (String)request.getAttribute( "CTRL_NUMB"  );
    String GUEN_CODE  = (String)request.getAttribute( "GUEN_CODE"  );
    String PROOF      = (String)request.getAttribute( "PROOF"      );
    String ENAME      = (String)request.getAttribute( "ENAME"      );  //@v1.1구분명
    String SICK_NAME  = (String)request.getAttribute( "SICK_NAME"  );
    String SICK_DESC1 = (String)request.getAttribute( "SICK_DESC1" );
    String SICK_DESC2 = (String)request.getAttribute( "SICK_DESC2" );
    String SICK_DESC3 = (String)request.getAttribute( "SICK_DESC3" );
    String EMPL_WONX  = (String)request.getAttribute( "EMPL_WONX"  );
    String COMP_WONX  = (String)request.getAttribute( "COMP_WONX"  );  // 회사지원액
    String YTAX_WONX  = (String)request.getAttribute( "YTAX_WONX"  );  // 연말정산반영액
    String BIGO_TEXT1 = (String)request.getAttribute( "BIGO_TEXT1" );
    String BIGO_TEXT2 = (String)request.getAttribute( "BIGO_TEXT2" );
    String WAERS      = (String)request.getAttribute( "WAERS"      );  // 통화키
    String RFUN_DATE  = (String)request.getAttribute( "RFUN_DATE"  );
    String RFUN_RESN  = (String)request.getAttribute( "RFUN_RESN"  );
    String RFUN_AMNT  = (String)request.getAttribute( "RFUN_AMNT"  );
    String COMP_sum   = (String)request.getAttribute( "COMP_sum"   );  // 회사지원총액(배우자일경우만 보여줌)
    String TREA_CODE  = (String)request.getAttribute( "TREA_CODE"   ); // 진료과코드   06.02.23추가
    String TREA_TEXT  = (String)request.getAttribute( "TREA_TEXT"   ); // 진료과코드명 06.02.23추가

//  통화키에 따른 소수자리수를 가져온다
    double currencyDecimalSize = 2;
    int    currencyValue = 0;
    Vector currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
    for( int j = 0 ; j < currency_vt.size() ; j++ ) {
        CodeEntity codeEnt = (CodeEntity)currency_vt.get(j);
        if( WAERS.equals(codeEnt.code) ){
            currencyDecimalSize = Double.parseDouble(codeEnt.value);
        }
    }
    currencyValue = (int)currencyDecimalSize; //???  KRW -> 0, USDN -> 5
//  통화키에 따른 소수자리수를 가져온다
%>

<jsp:include page="/include/header.jsp" />

<script language="javascript">
<!--
function goBill() {
    if( document.form1.RCPT_NUMB.checked == true ) {
        if( document.form1.RCPT_CODE.value == "0002" ) {
            document.form2.CTRL_NUMB.value  = document.form1.CTRL_NUMB.value ;
            document.form2.GUEN_CODE.value  = document.form1.GUEN_CODE.value ;
            document.form2.PROOF.value      = document.form1.PROOF.value     ;
            document.form2.RCPT_NUMB.value  = document.form1.RCPT_NUMB.value ;
        }
        else {
            //alert( "영수증 구분이 '진료비계산서'인 경우에만 조회가 가능합니다." ) ;
            alert( "<%=g.getMessage("MSG.E.E18.0001")%>" ) ;
            return ;
        }
    } else {
        for( var i = 0 ; i < document.form1.RCPT_NUMB.length ; i++ ) {
            if( document.form1.RCPT_NUMB[i].checked == true ) {
                if( document.form1.RCPT_CODE[i].value == "0002" ) {
                    document.form2.CTRL_NUMB.value  = document.form1.CTRL_NUMB[i].value ;
                    document.form2.GUEN_CODE.value  = document.form1.GUEN_CODE[i].value ;
                    document.form2.PROOF.value      = document.form1.PROOF[i].value     ;
                    document.form2.RCPT_NUMB.value  = document.form1.RCPT_NUMB[i].value ;
                }
                else {
                    //alert( "영수증 구분이 '진료비계산서'인 경우에만 조회가 가능합니다." ) ;
                    alert( "<%=g.getMessage("MSG.E.E18.0001")%>" ) ;
                    return ;
                }
            }
        }
    }
    document.form2.action = '<%= WebUtil.ServletURL %>hris.E.E18Hospital.E18BillDetailSV' ;
    document.form2.method = 'post' ;
    document.form2.submit() ;
}
-->
</script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return true" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->
<form name="form1" method="post">

<div class="subWrapper">

    <!-- 상단 입력 테이블 시작-->
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
                    <th><!--관리번호--><%=g.getMessage("LABEL.E.E18.0016")%></th>
                    <td colspan="3"><input type="text" size="20" value="<%= CTRL_NUMB %>" readonly></td>
                </tr>
                <tr>
                    <th><!--구분--><%=g.getMessage("LABEL.E.E18.0017")%></th>
                    <td colspan="3">
                        <input type="text" size="20" value="<%= GUEN_CODE.equals("0001") ? g.getMessage("LABEL.E.E18.0043") : GUEN_CODE.equals("0002") ? g.getMessage("LABEL.E.E18.0044") : g.getMessage("LABEL.E.E18.0045") %>" readonly> <!-- 본인:LABEL.E.E18.0043 / 배우자:LABEL.E.E18.0044 / 자녀:LABEL.E.E18.0045 -->
                        <input type="text" size="11" value="<%=ENAME%>" readonly><!--v1.1-->
<%
    if( GUEN_CODE.equals("0002")||GUEN_CODE.equals("0003") ) {
%>
                    &nbsp;&nbsp;&nbsp;<input type="checkbox" name="PROOF" value="X" size="20" class="input03" <%= PROOF.equals("X") ? "checked" : "" %> disabled>&nbsp;<!--연말정산반영여부--><%=g.getMessage("LABEL.E.E18.0021")%>
<%
    }
%>
                    </td>
                </tr>
                <tr>
                    <th><!--진료과--><%=g.getMessage("LABEL.E.E18.0022")%></th>
                    <td colspan="3">
                        <input type="text" size="35" value="<%= TREA_TEXT %>" readonly>
                    </td>
                </tr>
                <tr>
                    <th><!--상병명--><%=g.getMessage("LABEL.E.E18.0006")%></th>
                    <td colspan="3">
                        <input type="text" size="103" value="<%= SICK_NAME %>" readonly>
                    </td>
                </tr>
                <tr>
                    <th><!--구체적증상--><%=g.getMessage("LABEL.E.E18.0023")%></th>
                    <td colspan="3">
                        <textarea wrap="VIRTUAL" cols="100" rows="5" readonly><%= SICK_DESC1 +"\n"+ SICK_DESC2 +"\n"+ SICK_DESC3 %></textarea>
                    </td>
                </tr>

                <tr>
                    <th rowspan="2"><!--비고--><%=g.getMessage("LABEL.E.E18.0027")%></th>
                    <td colspan="3">
                        <input type="text" name="BIGO_TEXT1" value="<%= BIGO_TEXT1 %>" style="text-align:left" size="103" readonly>
                    </td>
                </tr>
                <tr>
                    <td class="td09" colspan="3"><input type="text" name="BIGO_TEXT2" value="<%= BIGO_TEXT2 %>" style="text-align:left" size="103" readonly></td>
                </tr>
                <tr>
                    <th><!--반납일자--><%=g.getMessage("LABEL.E.E18.0024")%></th>
                    <td><input type="text" name="RFUN_DATE" value="<%= RFUN_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(RFUN_DATE) %>" style="text-align:left" size="20" readonly></td>
                    <th class="th02"><!--반납액--><%=g.getMessage("LABEL.E.E18.0025")%></th>
                    <td>
                        <input type="text" name="RFUN_AMNT" value="<%= RFUN_AMNT.equals("0.0") ? "" : WebUtil.printNumFormat(RFUN_AMNT,currencyValue)+" " %>" style="text-align:right" size="20" readonly>
                        <%= RFUN_AMNT.equals("0.0") ? "" : WAERS %>
                    </td>
                </tr>
                <tr>
                    <th><!--반납사유--><%=g.getMessage("LABEL.E.E18.0026")%></th>
                    <td colspan="3"><input type="text" name="RFUN_RESN" value="<%= RFUN_RESN %>" style="text-align:left" size="103" readonly></td>
                </tr>
            </table>
        </div>
    </div>

    <div class="listArea">
        <div class="listTop">
        	<div class="buttonArea">
	            <ul class="btn_mdl">
	                <li><a href="javascript:goBill();"><span><!--진료비계산서 조회--><%=g.getMessage("BUTTON.COMMON.HOSPITALSRCH")%></span></a></li>
	            </ul>
            </div>
        </div>
        <div class="table">
            <table class="listTable">
                <tr>
                    <th><!--선택--><%=g.getMessage("LABEL.E.E18.0014")%></th>
                    <th><!--의료기관--><%=g.getMessage("LABEL.E.E18.0028")%></th>
                    <th><!--사업자<br>등록번호--><%=g.getMessage("LABEL.E.E18.0029")%></th>
                    <th><!--전화번호--><%=g.getMessage("LABEL.E.E18.0030")%></th>
                    <th><!--진료일--><%=g.getMessage("LABEL.E.E18.0031")%></th>
                    <th><!--입원<br>/외래--><%=g.getMessage("LABEL.E.E18.0032")%></th>
                    <th><!--영수증구분--><%=g.getMessage("LABEL.E.E18.0033")%></th>
                    <th><!--No.--><%=g.getMessage("LABEL.E.E18.0034")%></th>
                    <th><!--결재수단--><%=g.getMessage("LABEL.E.E18.0035")%></th>
                    <th><!--본인실납부액--><%=g.getMessage("LABEL.E.E18.0036")%></th>
                    <th class="lastCol"><!--연말정산<br>반영액--><%=g.getMessage("LABEL.E.E18.0037")%></th>
                </tr>
<%
    String MEDI_MTHD_TEXT = ""; //@v1.2
    for ( int i = 0 ; i < E18HospitalDetailData_vt.size() ; i++ ) {
        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }

        E18HospitalDetailData data = ( E18HospitalDetailData ) E18HospitalDetailData_vt.get( i ) ;
                //@v1.2
    if (data.MEDI_MTHD.equals("1"))
            MEDI_MTHD_TEXT = g.getMessage("LABEL.E.E18.0040");//"현금";
        else if (data.MEDI_MTHD.equals("2"))
            MEDI_MTHD_TEXT =g.getMessage("LABEL.E.E18.0041");// "신용카드";
        else if (data.MEDI_MTHD.equals("3"))
            MEDI_MTHD_TEXT = g.getMessage("LABEL.E.E18.0042");//"현금영수증";
        else  MEDI_MTHD_TEXT = "";
%>
                <tr class="<%=tr_class%>">
                    <td>
                        <input type="radio"  name="RCPT_NUMB" value="<%= data.RCPT_NUMB %>" <%= i == 0 ? "checked" : "" %>>
                        <input type="hidden" name="CTRL_NUMB" value="<%= CTRL_NUMB  %>">
                        <input type="hidden" name="GUEN_CODE" value="<%= GUEN_CODE  %>">
                        <input type="hidden" name="PROOF"     value="<%= PROOF      %>">
                        <input type="hidden" name="RCPT_CODE" value="<%= data.RCPT_CODE  %>">
                    </td>
                    <td><%= data.MEDI_NAME %></td>
                    <td><%= data.MEDI_NUMB.equals("") ? "" : DataUtil.addSeparate2(data.MEDI_NUMB) %></td>
                    <td><%= data.TELX_NUMB %></td>
                    <td><%= data.EXAM_DATE.equals("0000-00-00") ? "" : WebUtil.printDate(data.EXAM_DATE) %></td>
                    <td><%= data.MEDI_TEXT %></td>
                    <td><%= data.RCPT_TEXT %></td>
                    <td><%= data.RCPT_NUMB %></td>
                    <td><%= MEDI_MTHD_TEXT %></td>
                    <td class="align_right"><%= WebUtil.printNumFormat(data.EMPL_WONX,currencyValue) %>&nbsp;&nbsp;</td>
                    <td class="align_right lastCol"><%= data.YTAX_WONX.equals("") ? "" : WebUtil.printNumFormat(data.YTAX_WONX ,currencyValue) %></td>

                </tr>
<%
    }
%>
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
<%
    if( GUEN_CODE.equals("0001") ) {
%>
				   <th>&nbsp;</th>
                   <td>&nbsp;</td>

<%
//  배우자일 경우 회사지원 총액을 보여준다.
    } else {
%>
                    <th><!--회사지원총액--><%=g.getMessage("LABEL.E.E18.0038")%></th>
                    <td>
                        <input type="text" value="<%= COMP_sum.equals("0.0") ? "" : WebUtil.printNumFormat(COMP_sum,currencyValue)+" " %>" size="13" style="text-align:right" readonly>
                        <%= WAERS %>
                    </td>
<%
    }
%>
                    <th class="th02"><!--계--><%=g.getMessage("LABEL.E.E18.0039")%></th>
                    <td>
                        <input type="text" value="<%= EMPL_WONX.equals("0.0") ? "" : WebUtil.printNumFormat(EMPL_WONX,currencyValue)+" " %>" size="13" style="text-align:right" readonly>
                        <%= WAERS %>
                    </td>
                </tr>

                <tr>
<%
    if( WAERS.equals("KRW") ) {
%>
	                <th><!--연말정산반영액--><%=g.getMessage("LABEL.E.E18.0037")%></th>
	                <td>
	                    <input type="text" value="<%= YTAX_WONX.equals("0.0") ? "" : WebUtil.printNumFormat(YTAX_WONX,currencyValue)+" " %>" size="13" style="text-align:right" readonly>
	                    <%= WAERS %>
	                </td>
<%
    } else {
%>
					<th>&nbsp;</th>
                    <td>&nbsp;</td>
<%
    }
%>

	                <th class="th02"><!--회사지원액--><%=g.getMessage("LABEL.E.E18.0019")%></th>
	                <td>
	                    <input type="text" value="<%= COMP_WONX.equals("0.0") ? "" : WebUtil.printNumFormat(COMP_WONX,currencyValue)+" " %>" size="13" style="text-align:right" readonly>
	                    <%= WAERS %>
	                </td>
            </tr>
        </table>
        </div>
    </div>
    <!--상단 입력 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:history.back();"><span><!--목록--><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
        </ul>
    </div>

</div>
</form>
<form name="form2">
<!-----   hidden field ---------->
  <input type="hidden" name="CTRL_NUMB"  value="">
  <input type="hidden" name="GUEN_CODE"  value="">
  <input type="hidden" name="PROOF"      value="">
  <input type="hidden" name="RCPT_NUMB"  value="">
<!--  HIDDEN  처리해야할 부분 끝-->
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

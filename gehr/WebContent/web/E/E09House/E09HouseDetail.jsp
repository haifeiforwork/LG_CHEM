<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금                                                    */
/*   Program Name : 주택자금 융자 조회                                          */
/*   Program ID   : E09HouseDetail.jsp                                          */
/*   Description  : 주택자금 융자 상세조회                                      */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="hris.E.E09House.E09HouseDetailData" %>

<%
    E09HouseDetailData data  = (E09HouseDetailData)request.getAttribute("E09HouseDetailData");
    data.E_ZZRPAY_MNTH = (data.E_ZZRPAY_MNTH).substring(0,4) + "-" + (data.E_ZZRPAY_MNTH).substring(4,6); //data 날짜 포멧 check
    data.E_ENDDA       = (data.E_ENDDA).substring(0,4)       + "-" + (data.E_ENDDA).substring(4,6)      ;
    data.E_DARBT_BEGDA = (data.E_DARBT_BEGDA).substring(0,4) + "-" + (data.E_DARBT_BEGDA).substring(4,6);
    data.E_DARBT_ENDDA = (data.E_DARBT_ENDDA).substring(0,4) + "-" + (data.E_DARBT_ENDDA).substring(4,6);
//out.println(data.toString());
%>

<jsp:include page="/include/header.jsp" />

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return true" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->
<form name="form1" method="post">

<div class="subWrapper">
    <h2 class="subtitle"><!--융자현황--><%=g.getMessage("LABEL.E.E09.0015")%></h2>

    <!-- 조회 리스트 테이블 시작-->
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
                    <th><!--융자금액--><%=g.getMessage("LABEL.E.E09.0016")%></th>
                    <td class="align_right"><%= WebUtil.printNumFormat( data.E_DARBT ).equals("0") ? "" : WebUtil.printNumFormat( data.E_DARBT ) %></td>
                    <th class="th02"><!--월 상환원금--><%=g.getMessage("LABEL.E.E09.0017")%></th>
                    <td class="align_right"><%= WebUtil.printNumFormat( data.E_TILBT ).equals("0") ? "" : WebUtil.printNumFormat( data.E_TILBT ) %></td>
                </tr>
                <tr>
                    <th><!--융자일자--><%=g.getMessage("LABEL.E.E09.0005")%></th>
                    <td><%= WebUtil.printDate( data.E_DATBW )%></td>
                    <th class="th02"><!--월 상환이자--><%=g.getMessage("LABEL.E.E09.0018")%></th>
                    <td class="align_right"><%= WebUtil.printNumFormat( data.E_BETRG ).equals("0") ? "" : WebUtil.printNumFormat( data.E_BETRG ) %></td>
                </tr>
                <tr>
                    <th><!--총상환기간--><%=g.getMessage("LABEL.E.E09.0019")%></th>
                    <td><%= data.E_ZZRPAY_MNTH %> ~ <%= data.E_ENDDA %></td>
                    <th class="th02"><!--월 상환금--><%=g.getMessage("LABEL.E.E09.0020")%></th>
                    <td class="align_right"><%= WebUtil.printNumFormat( data.E_TILBT_BETRG ).equals("0") ? "" : WebUtil.printNumFormat( data.E_TILBT_BETRG ) %></td>
                </tr>
                <tr>
                    <th><!--총상환횟수--><%=g.getMessage("LABEL.E.E09.0021")%></th>
                    <td><%= WebUtil.printNum( data.E_ZZRPAY_CONT ) %></td>
                    <th class="th02"><!--보증구분--><%=g.getMessage("LABEL.E.E09.0022")%></th>
                    <td><%= data.E_ZZSECU_FLAG.equals("C") ? g.getMessage("LABEL.E.E09.0023") : (data.E_ZZSECU_FLAG.equals("N") ?  g.getMessage("LABEL.E.E09.0024") : g.getMessage("LABEL.E.E09.0025"))  %></td> <!--신용보증:LABEL.E.E09.0023 /보험보증가입:LABEL.E.E09.0025/ 보증인 -->
                </tr>
            </table>
        </div>
    </div>
    <!-- 조회 리스트 테이블 끝-->

    <h2 class="subtitle"><!--상환내역--><%=g.getMessage("LABEL.E.E09.0026")%></h2>

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
                    <th><!--상환원금누계--><%=g.getMessage("LABEL.E.E09.0027")%></th>
                    <td class="align_right"><%= WebUtil.printNumFormat( data.E_TOTAL_DARBT ).equals("0") ? "" : WebUtil.printNumFormat( data.E_TOTAL_DARBT ) %></td>
                    <th class="th02"><!--상 환 일 자--><%=g.getMessage("LABEL.E.E09.0028")%></th>
<%
    if( data.E_TOTAL_CONT.equals("000") ) {
%>
                    <td>&nbsp;</td>
<%
    } else {
%>
                    <td><%= data.E_DARBT_BEGDA %> ~ <%= data.E_DARBT_ENDDA %></td>
<%
    }
%>
                </tr>
                <tr>
                    <th><!--상환이자누계--><%=g.getMessage("LABEL.E.E09.0029")%></th>
                    <td class="align_right"><%= WebUtil.printNumFormat( data.E_TOTAL_INTEREST ).equals("0") ? "" : WebUtil.printNumFormat( data.E_TOTAL_INTEREST ) %></td>
                    <th class="th02"><!--상 환 횟 수--><%=g.getMessage("LABEL.E.E09.0030")%></th>
                    <td><%= WebUtil.printNum( data.E_TOTAL_CONT ) %></td>
                </tr>
            </table>
        </div>
    </div>

    <h2 class="subtitle"><!--잔여금--><%=g.getMessage("LABEL.E.E09.0031")%></h2>

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
                    <th><!--잔여원금--><%=g.getMessage("LABEL.E.E09.0009")%></th>
                    <td class="align_right"><%= WebUtil.printNumFormat( data.E_REMAIN_BETRG ).equals("0") ? "" : WebUtil.printNumFormat( data.E_REMAIN_BETRG ) %>&nbsp;</td>
                    <th class="th02"><!--잔여횟수--><%=g.getMessage("LABEL.E.E09.0032")%></th>
                    <td><%= WebUtil.printNumFormat( data.E_REMAIN_CONT).equals("0") ? "" : WebUtil.printNumFormat( data.E_REMAIN_CONT ) %></td>
                </tr>
            </table>
        </div>
    </div>



    <div class="buttonArea">
        <ul class="btn_crud">
          <li><a href="javascript:history.back()"><span><!--목록--><%=g.getMessage("BUTTON.COMMON.LIST")%></span></a></li>
        </ul>
     </div>

</div>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

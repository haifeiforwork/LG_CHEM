<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustGibuCarriedList.jsp                                   */
/*   Description  : 특별공제기부금 이월 내역 조회                                 */
/*   Note         : 없음                                                        */
/*   Creation     :   rdcamel 2018/01/05  [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건                                           */
/*   Update       :    */
/*                                   */
/*                                    */
/*                      */
/*                                                                               */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%
Vector gibuCarried_vt = (Vector)request.getAttribute("gibuCarried_vt" );//[CSR ID:3569665]
%>

    <!--특별공제 테이블 시작-->
	<h2 class="subtitle "><spring:message code="LABEL.D.D14.0088"/></h2><!-- 이월기부금 -->
        <div class="table">
            <table class="listTable" id="table">
            <thead>
              <tr>
                <th width="15%"><spring:message code="LABEL.D.D14.0092" /><!-- 기부년도 --></th>
                <th width="25%"><spring:message code="LABEL.D.D11.0134" /><!-- 기부금 내용 --></th>
                <th width="20%"><spring:message code="LABEL.D.D14.0089" /><!-- 기부총액 --></th>
                <th width="20%"><spring:message code="LABEL.D.D14.0090" /><!-- 작년까지 공제 총액 --></th>
                <th width="20%"><spring:message code="LABEL.D.D14.0091" /><!-- 이월기부금액 --></th>
                </tr>
          </thead>
          
    <%
        for( int i = 0 ; i < gibuCarried_vt.size() ; i++ ){
            D11TaxAdjustGibuCarriedData data = (D11TaxAdjustGibuCarriedData)gibuCarried_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
    %>     
    		<tr class="<%=tr_class%>">
                <td nowrap><%= data.CRVYR.equals("") ? "" : data.CRVYR %></td>
                <td nowrap><%= data.DOCOD_TEXT%></td>
                <td nowrap><%= data.DON_TOT.equals("") ? "" : WebUtil.printNumFormat(data.DON_TOT) %></td>
                <td nowrap><%= data.DON_MID.equals("") ? "" : WebUtil.printNumFormat(data.DON_MID) %></td>
                <td nowrap><%= data.BETRG.equals("") ? "" : WebUtil.printNumFormat(data.BETRG) %></td>
			</tr> 
    <%
        }
    %>   
</table>
</div>
    <!--특별공제 테이블 끝-->

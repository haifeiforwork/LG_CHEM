<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 계좌 정보                                                   */
/*   Program Name : 계좌 정보                                                   */
/*   Program ID   : A03AccountDetail.jsp                                        */
/*   Description  : 계좌 정보를 조회하는 화면                                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-07 김도신                                           */
/*   Update       : 2005-03-03 윤정현                                           */
/*                  : 2016-09-20 통합구축 - 김승철                     */
/*                     2017/11/06 eunha  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 */
/*                     2018/04/19 kang 베트남 하이퐁 RollOut 프로젝트 적용  */
/*                     2018/06/07 변지현 LGCLC 생명과학 북경법인(G610)  Rollout  프로젝트 적용 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="hris.A.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="java.util.*" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);

    Vector a03AccountDetail1Data_vt = (Vector)request.getAttribute("a03AccountDetail1Data_vt");
    String PERNR = (String)request.getAttribute("PERNR");
//     PhoneNumData  phoneUser = (PhoneNumData)request.getAttribute("PhoneNumData"); //PhoneNumData
    PersonData  phoneUser = (PersonData)request.getAttribute("PersonData"); //PhoneNumData
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                      //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));                  //부서명
%>

<jsp:include page="/include/header.jsp" />
<script language="javascript">
<!--
function do_bank(text){
  document.form1.jobid.value     = "first";

  BNKSA= eval(" document.form1.BNKSA"+text+".value");
  ZBANKL= eval(" document.form1.ZBANKL"+text+".value");
  BNKTX= eval(" document.form1.BNKTX"+text+".value");

  //ZBANKA= eval(" document.form1.ZBANKA"+text+".value");
  //ZBANKN= eval(" document.form1.ZBANKN"+text+".value");

  document.form1.BNKSA.value = BNKSA;
  document.form1.ZBANKL.value = ZBANKL;

	//document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A14Bank.A14BankBuildSV";
  document.form1.action = "<%= WebUtil.ServletURL %>hris.A.A14Bank.A14BankBuildSV?TYPE="+(text)+"&BNKTX="+BNKTX;
  //?BNKSA="+BNKSA+"&ZBANKL="+ZBANKL
  document.form1.method = "post";
  document.form1.submit();
  blockFrame();
}

function do_stock(){
	document.form1.jobid.value     = "first";
	document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E12Stock.E12StockBuildSV";
	document.form1.method = "post";
	document.form1.submit();
    blockFrame();
}

function reload() {
    frm =  document.form1;
    frm.action = "<%= WebUtil.ServletURL %>hris.A.A03AccountDetailSV";
    frm.target = "";
    frm.submit();
    blockFrame();
}

//-->
</script>



<!-- body header 부 title 및 body 시작 부 선언 -->
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="COMMON.MENU.ESS_PY_BANK_DETAIL"/>
    <jsp:param name="help" value="A03Account.html"/>
    <jsp:param name="css" value="/image/css/ui_library_approval.css"/>
</jsp:include>

<%
    if ("Y".equals(user.e_representative) ) {
%>
          <!--   사원검색 보여주는 부분 시작   -->
          <%@ include file="/web/common/SearchDeptPersons.jsp" %>
          <!--   사원검색 보여주는 부분  끝    -->

<%
    }
%>

<form name="form1" method="post">

  <input type="hidden" name = "PERNR" value="<%=PERNR%>">

  <%--
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="780"> <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td width="660" class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">
                        <spring:message code="MSG.A.A03.0002"/><!--Bank Account Change--></td>
                  <td width="120" align="right">&nbsp;<a href="javascript:open_help('A03Account.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"><img name="Image6" border="0" src="<%= WebUtil.ImageURL %>btn_help_off.gif" alt="Guide"></a>
                  </td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                   <td height="3" align="left" valign="top" background="/web/images/maintitle_line.gif">
                        <img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
 --%>

              <!--주소 리스트 테이블 시작-->
            <div class="listArea">
              <div class="table">
              <table border="0" cellspacing="0" cellpadding="3" class="listTable">
              <colgroup>
              <col width=25%/>
              <col width=25%/>
              <col width=50%/>
              </colgroup>
                <thead>
                <tr class="th03">
                  <th><spring:message code="MSG.A.A03.0005"/><!--Bank&nbsp;Type--></th>
                  <th><spring:message code="MSG.A.A03.0006"/><!--Bank&nbsp;Key--></th>
                  <th class="lastCol"><spring:message code="MSG.A.A03.0008"/><!--Bank&nbsp;Account--></th>
                </tr>
                <!-- 20151116 bankcard pangxiaolin start -->
                <%  if( a03AccountDetail1Data_vt.size() > 0 ) {
        A03AccountDetail1Data data1 = (A03AccountDetail1Data)a03AccountDetail1Data_vt.get(0);
%>
                <tr>
                <%//2018-06-07 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout
                	if( (user.companyCode.equals("G100") || user.companyCode.equals("G610"))&&phoneUser.E_PERSG.equals("A")){
                		if(data1.BNKTX.equals("Main bank")){%>
                		<td class="td04"><spring:message code="MSG.A.A03.0009"/><!--工资账号--></td>
                <%}else if(data1.BNKTX.equals("Fee for EXP bank")){%>
                		<td class="td04"><spring:message code="MSG.A.A03.0010"/><!--报销账号--></td>
                <%}}else{ %>
                  <td class="td04"><%=data1.BNKTX %></td>
                <%} %>
                  <td class="td04"><%= data1.ZBANKA %></td>
                  <td class="lastCol "><%= data1.ZBANKN + data1.ZBKREF%></td>
                </tr>
                <input type="hidden" name="BNKTX1" value="<%= data1.BNKTX %>">
                <input type="hidden" name="BNKSA1" value="<%= data1.BNKSA %>">
                <input type="hidden" name="ZBANKL1"     value="<%= data1.ZBANKL     %>">
              <!--  20151109 -->
                <%
    } else {
%>
                <input type="hidden" name="BNKSA1" value="">
                <input type="hidden" name="ZBANKL1"     value="">
                <input type="hidden" name="BNKTX1"     value="">
                <input type="hidden" name="ZBANKA1" value="">
                <input type="hidden" name="ZBANKN1" value="">
<%
    }
%>
              </table>
              <!--주소 리스트 테이블 끝-->
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
    		 <%--[CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건 2017/11/06 eunha --%>
    		 <c:if test="${user.area != 'TH' }">
                <div class="buttonArea">
                    <ul class="btn_crud">
                    	<%--베트남 하이퐁 법인 RollOut 프로젝트 반영 Kang 2018-04-19 --%>
                    <% if(!user.companyCode.equals("G580")) { %>
                        <li><a class="darken" href="javascript:do_bank(1);"><span><spring:message code="MSG.A.A03.0003"/><!--급여계좌신청--></span>
                            </a></li>
                    <% } %>

                    <% if(user.companyCode.equals("N100")) { %>
                            <li><a class="darken" href="javascript:do_stock();"> <span><spring:message code="MSG.A.A03.0004"/><!--증권계좌신청--></span></a></li>
                    <% } %>
                    </ul></div>
                </c:if>

              </td>
          </tr>
        </table>
</div></div>
        <%
		    //2018-06-07 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout  start
		    if ( ( user.companyCode.equals("G100") || user.companyCode.equals("G610") )&&phoneUser.E_PERSG.equals("A")&&(a03AccountDetail1Data_vt.size() > 1 ) ) {
		    //2018-06-07 @PJ.LGCLC 생명과학 북경법인(G610)  Rollout  end
		%>
      <div class="listArea">
        <div class="table">
         <table class="listTable" >
              <colgroup>
              <col width=25%/>
              <col width=25%/>
              <col width=50%/>
              </colgroup>
          <tr>
                  <th><spring:message code="MSG.A.A03.0005"/><!--Bank&nbsp;Type--></th>
                  <th><spring:message code="MSG.A.A03.0006"/><!--Bank&nbsp;Key--></th>
                  <th class="lastCol"><spring:message code="MSG.A.A03.0008"/><!--Bank&nbsp;Account--></th>
                </tr>
                <%  if( a03AccountDetail1Data_vt.size() > 1 ) {
	        		A03AccountDetail1Data data2 = (A03AccountDetail1Data)a03AccountDetail1Data_vt.get(1);
				%>
                <tr>
                <%if(data2.BNKTX.equals("Main bank")){%>
                		<td class="td04"><spring:message code="MSG.A.A03.0009"/><!--工资账号--></td>
                <%}else if(data2.BNKTX.equals("Fee for EXP bank")){%>
                		<td class="td04"><spring:message code="MSG.A.A03.0010"/><!--报销账号--></td>
                <%} %>
                  <td class="td04"><%= data2.ZBANKA %></td>
                  <td class="lastCol "><%= data2.ZBANKN + data2.ZBKREF%></td>
                </tr>
                <input type="hidden" name="BNKTX2"     value="<%=data2.BNKTX %>">
                <input type="hidden" name="ZBANKA2"     value="<%=data2.ZBANKA %>">
                <input type="hidden" name="BNKSA2" value="<%= data2.BNKSA %>">
                <input type="hidden" name="ZBANKL2"     value="<%= data2.ZBANKL     %>">
                <input type="hidden" name="BANKT2"     value="2">
                <%
    } else {
%>
                <input type="hidden" name="BNKSA2" value="">
                <input type="hidden" name="ZBANKL2"     value="">
                <input type="hidden" name="BNKTX2"     value="">
                <input type="hidden" name="ZBANKA2" value="">
                <input type="hidden" name="ZBANKN2" value="">
<%
    }
%>
              </table>
              <!--주소 리스트 테이블 끝-->
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>



                <div class="buttonArea">
                    <ul class="btn_crud">
                        <li> <a class="darken" href="javascript:do_bank(2);">
                    <span><spring:message code="MSG.A.A03.0004"/><!--급여계좌신청--></span></a></li>
                    <% if(user.companyCode.equals("N100")) { %>
	                    <li><a class="darken" href="javascript:do_stock();">
	                    <span><spring:message code="MSG.A.A03.0004"/><!--증권계좌신청--></span></a></li>
                    <% } %>
                    </ul></div>


              </td>
          </tr>
        </table>
        <%
    }
%>
  <!-- 20151116 bankcard pangxiaolin end -->
<% if(user.companyCode.equals("C100")) { %>

  <br>

    <tr>
            <td><h2 class="subtitle"><a name="1"> <spring:message code="MSG.A.A03.0012"/><!--참고--></a></h2></td>
    </tr>

    <tr>

          <td>
            <div class="commentImportant" style="width:640px;">
            <table cellspacing="0" class="infoTable">
              <tr>
                <th width="14%"><spring:message code="MSG.A.A03.0013"/><!--구 분--></th>
                <th width="43%"><spring:message code="MSG.A.A03.0014"/><!--지급 항목--></th>
                <th width="43%" class="lastCol"><spring:message code="MSG.A.A03.0015"/><!--신청 및 변경 주관부서--></th>
              </tr>
              <tr class="oddRow"><!-- [CSR ID:2882594] e-hr 계좌정보 문구 수정 요청  -->
                <td class=""><spring:message code="MSG.A.A03.0009"/><!--급여계좌--></td>
                <td><spring:message code="MSG.A.A03.0016"/><!--월급여, 상여금--></td>
                <td class="lastCol"><spring:message code="MSG.A.A03.0017"/><!--HR서비스팀(본사,지방영업) 및 각 사업장 급여주관 부서<br>
                  (e-HR를 통하여 신청 및 변경 후, 계좌사본 제출)--></td>
              </tr>
              <tr>
                <td><spring:message code="MSG.A.A03.0011"/><!--개인F/B계좌--></td>
                <td><spring:message code="MSG.A.A03.0018"/><!--퇴직금,복리후생비(학자금,의료비,경조금 등),<br/>경비정산금액(법인카드,개인카드 등)--></td>
                <td class="lastCol"><spring:message code="MSG.A.A03.0019"/><!--UAS에서 임직원이 직접 계좌인증 및 등록--></td>
              </tr>
            </table>
            </div>
        </td>

    </tr>




<% } %>
<!-- HIDDEN  처리해야할 부분 시작-->
      <input type="hidden" name="jobid"       value="">
      <input type="hidden" name="AINF_SEQN"   value="">
      <input type="hidden" name="BEGDA"       value="">
      <input type="hidden" name="BANK_FLAG"   value="">
      <input type="hidden" name="BANK_CODE"   value="">
      <input type="hidden" name="BANK_NAME"   value="">
      <input type="hidden" name="BANKN"       value="">
      <input type="hidden" name="ThisJspName" value="A03AccountDetail_Global.jsp">
      <input type="hidden" name="BNKSA"       value="">
      <input type="hidden" name="ZBANKL"       value="">

<!-- HIDDEN  처리해야할 부분 끝-->
	  </td>
	</tr>
  </table>
  </div>

</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

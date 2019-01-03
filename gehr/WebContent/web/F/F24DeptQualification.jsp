<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 자격 소지자 조회                                     */
/*   Program ID   : F24DeptQualification.jsp                                    */
/*   Description  : 부서별 자격 소지자 조회를 위한 jsp 파일                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-31 유용원                                           */
/*   Update       :                                                             */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정  */
/*                 :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 */
/*					//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.common.constant.Area" %>

<%
    String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));
    WebUserData user    = (WebUserData)session.getAttribute("user");            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));  //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));  //부서명
    Vector DeptQualification_vt = (Vector)request.getAttribute("DeptQualification_vt");
    HashMap empCnt = (HashMap)request.getAttribute("empCnt");
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
    <!--

    function popupView(winName, width, height, pernr) {
        var formN = document.form1;
        formN.viewEmpno.value = pernr;
        var screenwidth = (screen.width-width)/2;
        var screenheight = (screen.height-height)/2;
        var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr;
        var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

    }

    function excelDown() {
        frm = document.form1;
        frm.hdn_excel.value = "ED";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F24DeptQualificationSV";
        frm.target = "hidden";
        frm.submit();
    }

    //-->
</SCRIPT>
 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="viewEmpno"   value="">
<input type="hidden" name="chck_yeno" value="<%=chck_yeno%>" >
<%
    //부서명, 조회된 건수.
    if ( DeptQualification_vt != null && DeptQualification_vt.size() > 0 ) {
%>

    <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!--부서명  --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>

    <!-- 화면에 보여줄 영역 시작 -->
    <div class="listArea">
        <div class="listTop">
            <div class="listCnt"><<!--총--><spring:message code='LABEL.F.FCOMMON.0006'/> <%=DeptQualification_vt.size()%><!--건--><spring:message code='LABEL.F.FCOMMON.0007'/>></div>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a  onClick="javascript:excelDown();" class="unloading"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
<%
	if( user.area == Area.KR ){
%>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
               <thead>
                <tr>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              	<%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
              	<th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
                <th><spring:message code="MSG.A.A01.0070"/><!-- 자격면허 --></th>
                <th><spring:message code="MSG.A.A01.0071"/><!-- 취득일 --></th>
                <th><spring:message code="MSG.A.A01.0072"/><!-- 등급 --></th>
                <th><spring:message code="MSG.A.A01.0073"/><!-- 발행기관 --></th>
                <th class="lastCol"><spring:message code="MSG.A.A01.0074"/><!-- 법정선임여부 --></th>
                </tr>
               </thead>
<%

				String oldPer="";
				String sRow = "";
            for( int i = 0; i < DeptQualification_vt.size(); i++ ){
                F24DeptQualificationData data = (F24DeptQualificationData)DeptQualification_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작
                if(data.PERNR.equals(oldPer) ){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt.get(data.PERNR);
                }
                oldPer = data.PERNR;

%>
                <tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.JIKCT %></td>
				<td nowrap <%= sRow %>><%= data.TRFST %></td>
				<td nowrap <%= sRow %>><%= data.VGLST %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
                    <td ><%= data.LICNNM%></td>
                    <td><%= (data.OBNDAT).equals("0000-00-00") ? "" : WebUtil.printDate(data.OBNDAT) %></td>
                    <td><%= data.LGRDNM  %></td>
                    <td><%= data.PBORGH  %></td>
                    <td class="lastCol"><%= data.LAW.equals("N")? "":  data.LAW   %></td>
                </tr>
<%
            } //end for...
%>
            </table>
        </div>
<%
    	}else{
%>

	<div class="table">
		<table class="listTable">
		   <thead>
			<tr>
				<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              	<%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
              	<th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
                <th><spring:message code="MSG.A.A01.0070"/><!-- 자격면허 --></th>
                <th><spring:message code="MSG.A.A01.0071"/><!-- 취득일 --></th>
                <th><spring:message code="MSG.A.A01.0072"/><!-- 등급 --></th>
                <!-- //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  -->
                <th class=<%=(user.area== Area.US || user.area== Area.MX)? "lastCol" :"" %> ><spring:message code="MSG.A.A01.0073"/><!-- 발행기관 --></th>
<%
                if( user.area != Area.US && user.area != Area.MX ){
%>

                <th class="lastCol"><spring:message code="MSG.A.A01.0074"/><!-- 법정선임여부 --></th>
<%
				}
%>
			</tr>
			</thead>
			<%

			String oldPer="";
			String sRow = "";


            for( int i = 0; i < DeptQualification_vt.size(); i++ ){
            	F24DeptQualificationData data = (F24DeptQualificationData)DeptQualification_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위한 작
                if(oldPer.equals(data.PERNR)){
                	sRow = "";
                }else{
                	sRow = "rowspan=" + empCnt.get(data.PERNR);
                }
                oldPer = data.PERNR;
			%>
			<tr class="borderRow">
          	<%if (!sRow.equals("")) {%>
				<td nowrap <%= sRow %>><%= data.NAME1 %></td>
				<td nowrap <%= sRow %>><a href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a></td>
				<td nowrap <%= sRow %>><%= data.ENAME %></td>
				<td nowrap <%= sRow %>><%= data.ORGTX %></td>
				<td nowrap <%= sRow %>><%= data.JIKKT %></td>
				<td nowrap <%= sRow %>><%= data.JIKWT %></td>
				<td nowrap <%= sRow %>><%= data.VGLST %></td>
				<td nowrap <%= sRow %>><%= (data.DAT01).equals("0000-00-00") ?  "" : WebUtil.printDate(data.DAT01) %></td>
			<%} %>
                    <td ><%= data.LICNNM%></td>
                    <td><%= (data.OBNDAT).equals("0000-00-00") ? "" : WebUtil.printDate(data.OBNDAT) %></td>
                    <td><%= data.LGRDNM  %></td>
                    <!-- //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  -->
                    <td class=<%=(user.area== Area.US || user.area== Area.MX)? "lastCol" :"" %>><%= data.PBORGH  %></td>
<%
                if( user.area != Area.US && user.area== Area.MX ){
%>
                    <td class="lastCol"><%= data.LAW.equals("N")? "":  data.LAW   %></td>
<%
				}
%>
			</tr>
<%
            } //end for...
%>
		</table>
	</div>
<%
    	}
%>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a  onClick="javascript:excelDown();" class="unloading"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
</div>

<%
    }else{
%>
<%
	if( user.area == Area.KR ){
%>
        <div class="table">
            <table class="listTable">
               <thead>
                <tr>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              	<%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
              	<th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F41.0009"/><!-- 직급 --></th>
				<th><spring:message code="LABEL.F.F41.0010"/><!-- 호봉 --></th>
				<th><spring:message code="LABEL.F.F41.0011"/><!-- 연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
                <th><spring:message code="MSG.A.A01.0070"/><!-- 자격면허 --></th>
                <th><spring:message code="MSG.A.A01.0071"/><!-- 취득일 --></th>
                <th><spring:message code="MSG.A.A01.0072"/><!-- 등급 --></th>
                <th><spring:message code="MSG.A.A01.0073"/><!-- 발행기관 --></th>
                <th class="lastCol"><spring:message code="MSG.A.A01.0074"/><!-- 법정선임여부 --></th>
                </tr>
               </thead>
			<tr class="oddRow">
				<td class="lastCol" colSpan="14"><spring:message code="MSG.F.FCOMMON.0002"/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
			</tr>
		</table>
	</div>
<%
    	}else{
%>
	<div class="table">
		<table class="listTable">
		   <thead>
			<tr>
				<th><spring:message code="LABEL.F.F51.0018"/><!-- 회사 --></th>
				<th><spring:message code="LABEL.F.F41.0004"/><!-- 사번 --></th>
				<th><spring:message code="LABEL.F.F41.0005"/><!-- 이름 --></th>
				<th><spring:message code="LABEL.F.F41.0006"/><!-- 소속 --></th>
				<th><spring:message code="LABEL.F.F41.0007"/><!-- 직책 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
              	<%--<th><spring:message code="LABEL.F.F41.0008"/><!-- 직위 --></th> --%>
              	<th><spring:message code='MSG.A.A01.0083'/><!-- 직위/직급호칭 --></th>
              	<%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
				<th><spring:message code="LABEL.F.F22.0007"/><!-- 직급/연차 --></th>
				<th><spring:message code="LABEL.F.F41.0012"/><!-- 입사일 --></th>
                <th><spring:message code="MSG.A.A01.0070"/><!-- 자격면허 --></th>
                <th><spring:message code="MSG.A.A01.0071"/><!-- 취득일 --></th>
                <th><spring:message code="MSG.A.A01.0072"/><!-- 등급 --></th>
                <!-- //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  -->
                <th class=<%=(user.area== Area.US || user.area== Area.MX)? "lastCol" :"" %> ><spring:message code="MSG.A.A01.0073"/><!-- 발행기관 --></th>
<%
                if( user.area != Area.US &&  user.area != Area.MX){
%>

                <th class="lastCol"><spring:message code="MSG.A.A01.0074"/><!-- 법정선임여부 --></th>
<%
				}
%>
			</tr>
			</thead>
			<tr class="oddRow">
				<td class="lastCol" colSpan="14"><spring:message code="MSG.F.FCOMMON.0002"/><!-- 해당하는 데이터가 존재하지 않습니다. --></td>
			</tr>
		</table>
	</div>
<%

    	} //end if...
    } 	//end if...
%>
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->

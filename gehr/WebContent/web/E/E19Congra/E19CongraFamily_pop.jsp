<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조대상자                                                    */
/*   Program Name : 경조대상자 조회                                               */
/*   Program ID   : E19CongraFamily_pop.jsp                                     */
/*   Description  : 경조대상자 조회                                               */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2006-06-09  lsa                                             */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E19Congra.*" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.servlet.Box" %>
<%@ page import="hris.sys.SysAuthInput" %>
<%@ page import="hris.sys.rfc.SysAuthRFC" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    // 경조대상자 조회..
    //String PERNR = (String)request.getParameter("PERNR");
    //대리신청권한이 있는지 확인(모의해킹진단반영)
        Box fbox = WebUtil.getBox(request);
        String PERNR = fbox.get("PERNR", user.empNo);

     if (!"Y".equals(user.e_representative)) PERNR = user.empNo;
      if(!user.empNo.equals(PERNR)) {
        /* 대상 사번이 신청 대상 가능인지 확인 */
            SysAuthInput inputData = new SysAuthInput();
            inputData.I_CHKGB = "2";
            inputData.I_DEPT = user.empNo;
            inputData.I_PERNR = PERNR;

            SysAuthRFC sysAuthRFC = new SysAuthRFC();
            if (!sysAuthRFC.isAuth(inputData)) PERNR = user.empNo;

        }


    String OBJ = (String)request.getParameter("OBJ");
    String CONG_CODE = (String)request.getParameter("CONG_CODE");
    String RELA_CODE = (String)request.getParameter("RELA_CODE");

    // @v1.7 가족data get
    //A04FamilyDetailRFC func1                  = new A04FamilyDetailRFC();
    E19CongFamilyRFC func1                  = new E19CongFamilyRFC();
    Vector             e19CongFamilyData_vt = func1.getCongFamily(PERNR,CONG_CODE,RELA_CODE) ;
    //Vector             a04FamilyDetailData_vt = func1.getCongFamily(PERNR) ;

    // 대리 신청 추가
    PersonInfoRFC numfunc = new PersonInfoRFC();
    PersonData phonenumdata;
    phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);

%><html>
<jsp:include page="/include/header.jsp" />
<script language="Javascript">
function Detail_Show(p_idx,nm,reg,LNMHG,EXCEP){
   var obj = eval("opener.document."+"<%=OBJ%>");
   var regno = eval("opener.document.form1.REGNO");
   obj.value = nm;
   regno.value = reg;
   opener.openerPutLNMHG(LNMHG);
   //[CSR ID:3189675] 경조금 회갑 예외신청 개선
   opener.openerPutEXCEP(EXCEP);
   self.close();
 return;
}
function openDocPOP() {
  //var url="<%=WebUtil.JspURL%>"+"E/E19Congra/E19CongraFamily_pop.jsp?PERNR="+"<%=PERNR%>";
  //var url="<%=WebUtil.JspURL%>"+"A/A12Family/A12FamilyBuild.jsp";
  var url= "<%=WebUtil.ServletURL%>hris.A.A12Family.A12FamilyBuildSV?SCREEN=E19" ;
  var win = window.open(url,"family","width=800,height=480,left=365,top=70,scrollbars=yes");
  //openDoc('1012','1007','/servlet/hris.A.A12Family.A12FamilyBuildSV')
  win.focus();

}
</script>


<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<div class="winPop">
	<div class="header">
		<span><spring:message code='LABEL.E.E19.0050' /><!-- 경조대상자조회 --></span>
		<a href="javascript:self.close();"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
	</div>
<form name="form1" method="post">
	<div class="body">
	<input type="hidden" name = "PERNR" value="<%=PERNR%>">
	<!--경조대상자 리스트 테이블 시작-->
	<div class="listArea">
		<div class="table">
			<table class="listTable">
                <tr>
                  <th><spring:message code='LABEL.E.E19.0051' /><!-- 선 택 --></th>
                  <th><spring:message code='LABEL.E.E19.0052' /><!-- 가족유형 --></th>
                  <th><spring:message code='LABEL.E.E19.0053' /><!-- 관계 --></th>
                  <th><spring:message code='LABEL.E.E19.0054' /><!-- 성 명 --></th>
                  <th><spring:message code='LABEL.E.E20.0024' /><!-- 주민등록번호 --></th>
                  <th class="lastCol"><spring:message code='LABEL.E.E19.0055' /><!-- 생년월일 --></th>
                </tr>
<%
    for ( int i = 0 ; i < e19CongFamilyData_vt.size() ; i++ ) {
        E19CongFamilyData data = (E19CongFamilyData)e19CongFamilyData_vt.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }
%>


                <tr class="<%=tr_class%>">
                 <td> <input type="radio" name="radiobutton" value="radiobutton"  onclick="javascript:Detail_Show(<%= i %>,'<%= data.LNMHG %><%= data.FNMHG %>','<%=data.REGNO%>','<%=data.LNMHG%>','<%=data.EXCEP%>')">
                <input type="hidden" name="SUBTY<%= i %>"  value="<%= data.SUBTY %>">
                <input type="hidden" name="STEXT<%= i %>"  value="<%= data.STEXT %>">
                <input type="hidden" name="OBJPS<%= i %>"  value="<%= data.OBJPS %>">
                <input type="hidden" name="name<%= i %>"  value="<%= data.LNMHG %> <%= data.FNMHG %>">
                <input type="hidden" name="LNMHG<%= i %>"  value="<%= data.LNMHG %>">
                <input type="hidden" name="FNMHG<%= i %>"  value="<%= data.FNMHG %>">
                <input type="hidden" name="REGNO<%= i %>"  value="<%= DataUtil.addSeparate(data.REGNO) %>">
                <input type="hidden" name="BDay<%= i %>"   value="<%= data.FGBDT.substring(0, 4) + " 년 " + data.FGBDT.substring(5, 7) + " 월 " + data.FGBDT.substring(8, 10) + " 일" %>">
                <input type="hidden" name="FGBDT<%= i %>"  value="<%= data.FGBDT %>">
                <input type="hidden" name="STEXTA<%= i %>" value="<%= data.STEXT1 %>">
                <input type="hidden" name="FASIN<%= i %>"  value="<%= data.FASIN %>">
                <input type="hidden" name="FAJOB<%= i %>"  value="<%= data.FAJOB %>">
                <input type="hidden" name="KDSVH<%= i %>"  value="<%= data.KDSVH %>">
                <input type="hidden" name="ATEXT<%= i %>"  value="<%= data.ATEXT %>">
                <input type="hidden" name="FASEX<%= i %>"  value="<%= data.FASEX %>">
                <input type="hidden" name="FGBOT<%= i %>"  value="<%= data.FGBOT %>">
                <input type="hidden" name="LANDX<%= i %>"  value="<%= data.LANDX %>">
                <input type="hidden" name="NATIO<%= i %>"  value="<%= data.NATIO %>">
                <input type="hidden" name="DPTID<%= i %>"  value="<%= data.DPTID %>">
                <input type="hidden" name="HNDID<%= i %>"  value="<%= data.HNDID %>">
                <input type="hidden" name="LIVID<%= i %>"  value="<%= data.LIVID %>">
                <input type="hidden" name="HELID<%= i %>"  value="<%= data.HELID %>">
                <input type="hidden" name="FAMID<%= i %>"  value="<%= data.FAMID %>">
                <input type="hidden" name="CHDID<%= i %>"  value="<%= data.CHDID %>">
                <!-- [CSR ID:3189675] 경조금 회갑 예외신청 개선  -->
                <input type="hidden" name="EXCEP<%= i %>"  value="<%= data.EXCEP %>">
				<input type="hidden" name="CONG"  value="<%= CONG_CODE %>">
				<input type="hidden" name="RELA"  value="<%= RELA_CODE %>">
				<input type="hidden" name="PERNR"  value="<%= PERNR %>">



                  </td>
                  <td><%= data.STEXT %> </td>
                  <td><%= data.ATEXT %> </td>
                  <td><%= data.LNMHG %> <%= data.FNMHG %> </td>
                  <td>
<%
        if( user.empNo.equals(PERNR) ) {
%>
					<%= DataUtil.addSeparate(data.REGNO) %>
<%
        } else {
             String regno = data.REGNO.substring( 0, 6 ) + "-*******";
%>
                    <%= regno %>
<%
        }
%>
                  </td>
                  <td class="lastCol"><%= data.FGBDT.substring(0, 4) + "-" + data.FGBDT.substring(5, 7) + "-" + data.FGBDT.substring(8, 10)  %></td>
                </tr>
<%
        }
%>
              </table>
		</div>
	</div>
	<!--경조대상자 리스트 테이블 끝-->


<% if (e19CongFamilyData_vt.size()  ==0 ) { %>

          <tr>

            <td colspan="6" class="lastCol"><b><spring:message code='LABEL.E.E19.0056' /><!-- 등록된 경조대상자가 없습니다. --><br>
            <spring:message code='LABEL.E.E19.0058' /><!-- 버튼을 클릭하시어 경조대상자를 신규로 등록하시기 바랍니다. --></b>
            </td>
          </tr>
<% } %>

<% if (CONG_CODE.equals("0001") && RELA_CODE.equals("0001") ) { //CSR ID:1464024본인,결혼 %>

          <tr>

            <td class="lastCol" colspan="6">
              <p><span class="textPink">*</span><spring:message code='LABEL.E.E19.0059' /><!--  본인 결혼 경조금 신청시 반드시 (예비)배우자를 등록 후 (예비)배우자를 선택하여 신청하시기 바랍니다. --></p>
            </td>
          </tr>
<% } %>
	<ul class="btn_crud close">
		<li><a href="javascript:openDocPOP()"><span><spring:message code='LABEL.E.E19.0057' /><!-- 경조대상자등록 --></span></a>
	</ul>
	</div>
</form>
</div>
<%@ include file="/web/common/commonEnd.jsp" %>

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


<%@ page import="hris.A.*" %>
<%@ page import="hris.A.rfc.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    

    // 경조대상자 조회..
    String PERNR = (String)request.getParameter("PERNR");
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
<head>
<title>LG화학/e-HR - 경조대상자조회</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<script language="Javascript">
function Detail_Show(p_idx,nm,reg,LNMHG){
   var obj = eval("opener.document."+"<%=OBJ%>");
   var regno = eval("opener.document.form1.REGNO");
   obj.value = nm;
   regno.value = reg;
   opener.openerPutLNMHG(LNMHG);
   self.close();
 return;
}
function openDocPOP() {
  //var url="<%=WebUtil.JspURL%>"+"E/E19Congra/E19CongraFamily_pop.jsp?PERNR="+"<%=PERNR%>";
  //var url="<%=WebUtil.JspURL%>"+"A/A12Family/A12FamilyBuild.jsp";
  var url= "<%=WebUtil.ServletURL%>hris.A.A12Family.A12FamilyBuildSV?SCREEN=E19" ;
  var win = window.open(url,"family","width=680,height=480,left=365,top=70,scrollbars=yes");
  //openDoc('1012','1007','/servlet/hris.A.A12Family.A12FamilyBuildSV')
  win.focus();

}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post">
  <input type="hidden" name = "PERNR" value="<%=PERNR%>">
  <table width="516" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="510" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="510"> <table width="440" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td height="5" colspan="2"></td>
                </tr>
                <tr> 
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">경조대상자조회</td>
                  <td align="right"><a href="javascript:openDocPOP()">  
                           <img src="<%= WebUtil.ImageURL %>btn_search2_e19.gif" align="absmiddle" border="0" ></a></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="titleLine"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
          <tr> 
            <td> 
              <!--경조대상자 리스트 테이블 시작-->
              <table width="510" border="0" cellspacing="1" cellpadding="4" class="table02">
                <tr> 
                  <td class="td03" width="40">선 택</td>
                  <td class="td03" width="80">가족유형</td>
                  <td class="td03" width="80">관계</td>
                  <td class="td03" width="80">성 명</td>
                  <td class="td03" width="130">주민등록번호</td>
                  <td class="td03" width="100">생년월일</td>
                </tr>
<%
    for ( int i = 0 ; i < e19CongFamilyData_vt.size() ; i++ ) {
        E19CongFamilyData data = (E19CongFamilyData)e19CongFamilyData_vt.get(i);
%>
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
<input type="hidden" name="CONG"  value="<%= CONG_CODE %>">
<input type="hidden" name="RELA"  value="<%= RELA_CODE %>">
<input type="hidden" name="PERNR"  value="<%= PERNR %>">

                <tr> 
                  <td class="td04"> <input type="radio" name="radiobutton" value="radiobutton"  onclick="javascript:Detail_Show(<%= i %>,'<%= data.LNMHG %><%= data.FNMHG %>','<%=data.REGNO%>','<%=data.LNMHG%>')"> 
                  </td>
                  <td class="td04"><%= data.STEXT %> </td>
                  <td class="td04"><%= data.ATEXT %> </td>
                  <td class="td04"><%= data.LNMHG %> <%= data.FNMHG %> </td>
                  <td class="td04">
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
                  <td class="td04"><%= data.FGBDT.substring(0, 4) + "-" + data.FGBDT.substring(5, 7) + "-" + data.FGBDT.substring(8, 10)  %></td>
                </tr>
<%
        }
%>                
              </table>
              <!--경조대상자 리스트 테이블 끝-->
            </td>
          </tr>
        </table>
    </td>
  </tr>

<% if (e19CongFamilyData_vt.size()  ==0 ) { %>
          <tr> 
            <td height=14></td>
            <td></td>
          </tr>
          <tr> 
            <td></td>
            <td align=center><b>등록된 경조대상자가 없습니다.<br><a href="javascript:openDocPOP()">  
                           <img src="<%= WebUtil.ImageURL %>btn_search2_e19.gif" align="absmiddle" border="0" ></a>버튼을 클릭하시어 경조대상자를 신규로 등록하시기 바랍니다.</b></td>
          </tr>
<% } %>

<% if (CONG_CODE.equals("0001") && RELA_CODE.equals("0001") ) { //CSR ID:1464024본인,결혼 %> 
          <tr> 
            <td height=15></td>
            <td></td>
          </tr>
          <tr>                
            <td></td>
            <td class="td09">
              <font color="#006699"><b>&nbsp;*</b> 본인 결혼 경조금 신청시 반드시 (예비)배우자를 등록 후 (예비)배우자를 선택하여 <br>신청하시기 바랍니다.</font>
            </td>
          </tr>          
<% } %>
</table>

</form>
<%@ include file="/web/common/commonEnd.jsp" %>

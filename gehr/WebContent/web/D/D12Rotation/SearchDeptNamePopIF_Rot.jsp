<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : SearchDeptNamePopIF_Rot.jsp                                 */
/*   Description  : 조직도 조회 PopUp                                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20  유용원                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*"%>
<%@ page import="hris.D.D12Rotation.*"%>
<%@ page import="hris.D.D12Rotation.rfc.*" %>

<%
    WebUserData user    = (WebUserData)session.getAttribute("user");
    String deptNm       = WebUtil.nvl(request.getParameter("txt_deptNm"));   //부서명
    String DEPTNM       = (String)request.getAttribute("DEPTNM");                //권한 그룹
    String ENAME       = (String)request.getAttribute("ENAME");                //권한 그룹
    Vector DeptName_vt       = (Vector)request.getAttribute("DeptName_vt");                //권한 그룹
    //RFC Logger....
%>

<html>
<head>
<title>부서명 검색</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">

<script LANGUAGE="JavaScript">
<!--
<%
    //RFC 성공여부.
    if( DeptName_vt.size()==0 ){
%>
        //alert("NO Data Found : "+"DATA가 존재하지 않습니다.");
        alert("<%=g.getMessage("MSG.D.D12.0026")%>");
        parent.close();
<%
    }
%>

//단건인 경우.
function init(){
<%

    if( DeptName_vt != null && DeptName_vt.size() == 1 ) {
        D12RotationSearchData data = (D12RotationSearchData)DeptName_vt.get(0);
%>
        selectDept('<%= data.OBJID %>', '<%= data.OBJTXT %>');
<%
    }
%>
}

//부서명 Set.
function selectDept(deptId, deptNm){
    //opener에 함수 호출
    parent.opener.setDeptID(deptId, deptNm);
    parent.close();
}
//-->
</script>
</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:init();">
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="txt_deptNm"  value="<%=deptNm%>">

<table width="100%" border="0" cellspacing="1" cellpadding="4" class="table02" >
  <tr>
    <td width="15%" class="td03" ><!--  선택--><%=g.getMessage("LABEL.D.D12.0049")%></td>
    <td width="85%" class="td03" ><!--  부서명--><%=g.getMessage("LABEL.D.D12.0005")%></td>
  </tr>
<%
	//부서명, 조회된 건수.
	if ( DeptName_vt != null && DeptName_vt.size() > 0 ) {
	    for( int i = 0; i < DeptName_vt.size(); i++ ){
	        D12RotationSearchData data = (D12RotationSearchData)DeptName_vt.get(i);
%>
  <tr>
    <td class="td04"><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:selectDept('<%= data.OBJID %>', '<%= data.STEXT %>');"></td>
    <td class="td09"><%= data.STEXT %></td>
  </tr>
<%
          } //end for...
      }else{
%>
   <tr>
    <td colspan="2" class="td04"><!--해당하는 데이터가 존재하지 않습니다.--><%=g.getMessage("MSG.D.D12.0023")%></td>
  </tr>
<%
     } //end if...
%>
</table>

</form>
</body>
</html>


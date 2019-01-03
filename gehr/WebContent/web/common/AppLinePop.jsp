<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="hris.N.AES.AESgenerUtil" %>
<%@ page import="hris.common.PersInfoData" %>
<%@ page import="hris.common.PersonData" %>
<%@ page import="hris.common.rfc.PersInfoWithNameRFC" %>
<%@ page import="java.util.Vector" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%
    boolean isFirst         = true;
    Vector  PersInfoData_vt = null;

    String jobid            = request.getParameter("jobid");
    String ename            = request.getParameter("I_ENAME");
    String index            = request.getParameter("index");
    String objid            = request.getParameter("objid");
    String pernr           =  request.getParameter("pernr");  //신청자사번

    if( jobid != null && jobid.equals("search") ) {
        if ( ename == null ) {
            ename = "";
        }

        try{
            Logger.debug.println(this, "## : objid           : " + objid);
            PersInfoData_vt = ( new PersInfoWithNameRFC() ).getApproval(ename, objid, AESgenerUtil.decryptAES(request.getParameter("pernr")));
            Logger.debug.println(this, "## : PersInfoData_vt : " + PersInfoData_vt);
        }catch(Exception ex){
            PersInfoData_vt = null;
        }

        isFirst = false;
    }
%>

<jsp:include page="/include/header.jsp"/>

<SCRIPT LANGUAGE="JavaScript">
<!--
$(function() {
    document.form1.I_ENAME.focus();
});

function pers_search() {
  val  = document.form1.I_ENAME.value;

  val  = rtrim(ltrim(val));

  if ( val == "" ) {
    alert('<spring:message code="MSG.APPROVAL.0022" />'); //검색할 결재자의 이름을 입력하세요!
    document.form1.I_ENAME.focus();
    return;
  }

  if ( val.length < 2 ) {
    alert('<spring:message code="MSG.APPROVAL.0023" />'); //검색할 결재자 이름을 두자 이상 입력하세요!
    document.form1.I_ENAME.focus();
    return;
  }

  document.form1.jobid.value = "search";
  document.form1.action = "<%=WebUtil.JspURL%>"+"common/AppLinePop.jsp";
    blockFrame();
  document.form1.submit();
}

function EnterCheck(){
	if (event.keyCode == 13)  {
		pers_search();
	}
}

function changeAppData(index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER){
    opener.change_AppData(index, PERNR, ENAME, ORGTX, TITEL, TITL2, TELNUMBER);
    self.close();
}

//document.onkeydown = pers_search();
//-->
</SCRIPT>

</head>
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.APPROVAL.0001"/>
</jsp:include>
         <form name="form1" method="post" onsubmit="return false">
         <div class="tableInquiry">
             <table>
               <tr>
                 <th width="139"><spring:message code="LABEL.APPROVAL.0002" /><!-- 결재자 --></th>
                 <td width="221">
                   <input type="text" name="I_ENAME"  size="10"  class="input03" value="<%= ( ename == null  || ename.equals("")  ) ? "" : ename  %>"  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                   <input type="hidden" name="jobid" value="">
                   <input type="hidden" name="index" value="<%= index %>">
                   <input type="hidden" name="objid" value="<%= objid %>">
                   <input type="hidden" name="pernr" value="<%= pernr %>">
                   <a href="javascript:pers_search();" ><img src="<%= WebUtil.ImageURL %>sshr/ico_magnify.png" border="0"></a>
                 </td>
               </tr>
             </table>
		</div>
         </form>


<%
   if( !isFirst ){
%>
        <div class="align_center" style="height:1px; background:url(<%= WebUtil.ImageURL %>bg_pixel.gif") repeat-x"></div>
		<div class="listArea">
			<div class="table">
            <table class="listTable">
                <thead>
              <tr>
                <th width="30"><spring:message code="LABEL.APPROVAL.0003" /><!-- 선 택 --></th>
                <th width="70"><spring:message code="LABEL.APPROVAL.0004" /><!-- 사 번 --></th>
                <th width="100"><spring:message code="LABEL.APPROVAL.0005" /><!-- 성 명 --></th>
                <th width=""><spring:message code="LABEL.SEARCH.ORGEH.NAME" /><!-- 부서명 --></th>
                <th width="100"><%-- //[CSR ID:3456352]<spring:message code="LABEL.APPROVAL.0006" /><!-- 직위명 --> --%>
                <spring:message code="LABEL.COMMON.0051" /><!-- 직위/직급호칭명 --></th>
                <th class="lastCol" width="100"><spring:message code="LABEL.APPROVAL.0007" /><!-- 직책명 --></th>
              </tr>
                </thead>
<%
    //[CSR ID:3525213] Flextime 시스템 변경 요청
	if( PersInfoData_vt != null && PersInfoData_vt.size() > 0 ){
%>
              <form name="form2" method="post">
                  <tbody >
<%
            for( int i = 0 ; i < PersInfoData_vt.size() ; i++ ) {
            	PersonData persInfoData = (PersonData)PersInfoData_vt.get(i);
%>
                <tr class="listTableHover <%=WebUtil.printOddRow(i)%>" >
                  <td><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= index %>', '<%="00000000".equals(persInfoData.E_PERNR) ? "" : AESgenerUtil.encryptAES(persInfoData.E_PERNR) %>', '<%= persInfoData.E_ENAME %>', '<%= persInfoData.E_ORGTX %>', '<%= persInfoData.E_JIKWT %>', '<%= persInfoData.E_JIKKT %>', '<%= persInfoData.E_PHONE_NUM %>');"></td>
                  <td><%=StringUtils.defaultString(persInfoData.E_PERNR)%></td>
                  <td><%=StringUtils.defaultString( persInfoData.E_ENAME )%></td>
                  <td><%=StringUtils.defaultString( persInfoData.E_ORGTX )%></td>
                  <td><%=StringUtils.defaultString( persInfoData.E_JIKWT )%></td>
                  <td class="lastCol"><%=StringUtils.defaultString( persInfoData.E_JIKKT )%></td>
                </tr>
<%
            }
%>
                  </tbody>
              </form>
            </table>
			</div>
		</div>
<%
        } else {

%>
                <tr >
                  <td class="align_center lastCol" colspan="6"><spring:message code="LABEL.APPROVAL.0008" /><!-- 해당하는 데이타가 없습니다. --></td>
                </tr>
<%
        }
%>
        </tr>
<%
    }
%>
	      </table>
		</div>
	</div>
</div>
	<div class="buttonArea" style="margin-right:20px;">
		<ul class="btn_crud">
         	<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a></li>
         </ul>
		 <div class="clear"></div>
	</div>
<jsp:include page="/include/pop-body-footer.jsp" />

<jsp:include page="/include/footer.jsp"/>
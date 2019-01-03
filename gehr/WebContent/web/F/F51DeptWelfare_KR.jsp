<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 복리후생                                                    */
/*   Program Name : 부서별 복리후생 현황                                        */
/*   Program ID   : F51DeptWelfare.jsp                                          */
/*   Description  : 부서별 복리후생 조회를 위한 jsp 파일                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       : 2016-07-26 김불휘S [CSR ID:3124077] 조직통계<복리후생현황 데이타 삭제요청의 건    */
/*                   : 2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
  // 웹로그 메뉴 코드명
  String sMenuCode = WebUtil.nvl(request.getParameter("sMenuCode"));

  //현재 일자 형식 'YYYYMMDD'
    String toDate       = DataUtil.getCurrentDate();
    String preDate      = DataUtil.addDays(toDate, -30);

    WebUserData user    = (WebUserData)session.getAttribute("user");                        //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));              //부서코드
    String deptNm       = WebUtil.nvl(request.getParameter("hdn_deptNm"));              //부서명
    String selGubun     = WebUtil.nvl(request.getParameter("sel_gubun"), "99");         //구분
    String startDay     = WebUtil.nvl(request.getParameter("txt_startDay"), preDate);   //검색시작일
    String endDay       = WebUtil.nvl(request.getParameter("txt_endDay"), toDate);      //검색종료일
    String E_RETURN     = WebUtil.nvl((String)request.getAttribute("E_RETURN"));        //RFC 결과
    String E_MESSAGE    = WebUtil.nvl((String)request.getAttribute("E_MESSAGE"));       //RFC 결과 메시지
    Vector DeptWelfare_vt = (Vector)request.getAttribute("DeptWelfare_vt");
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--

//조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm){
    var frm = document.form1;

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    searchWelfare();
}

//조회에 의한 부서ID와 그에 따른 조회.
function searchWelfare(){
    var frm = document.form1;
    var isValide = false;

    if ( dateFormat(frm.txt_startDay) ) {
        isValide = true;
    } else {
        frm.txt_startDay.focus();
        return;
    }

    if ( dateFormat(frm.txt_endDay) ) {
        isValide = true;
    } else {
        return;
    }

    if ( isValide ) {
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F51DeptWelfareSV";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기.
function excelDown() {
    var frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F51DeptWelfareSV";
    frm.target = "hidden";
    frm.submit();
}


function popupView(winName, width, height, pernr) {
  var formN = document.form1;
  formN.viewEmpno.value = pernr;

  var screenwidth = (screen.width-width)/2;
    var screenheight = (screen.height-height)/2;
    var theURL = "<%= WebUtil.ServletURL %>hris.N.mssperson.A01SelfDetailNeoSV_m?sMenuCode=<%=sMenuCode%>&ViewOrg=Y&viewEmpno="+pernr;

   var retData = showModalDialog(theURL,window, "location:no;scroll:yes;menubar:no;status:no;help:no;dialogwidth:"+width+"px;dialogHeight:"+height+"px");

}

//-->
</SCRIPT>



    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y'"/>
        <jsp:param name="title" value="LABEL.F.F51.0001"/>
    </jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="viewEmpno" value="">
<input type="hidden" name="ViewOrg" value="Y">
<!--   부서검색 보여주는 부분 시작   -->

      <%@ include file="/web/common/SearchDeptInfo.jsp" %>

<!--   부서검색 보여주는 부분  끝    -->


<!--  검색테이블 시작 -->



  <div class="tableInquiry" >
  	<table>
  		<colgroup>
  			<col width="15%" />
  			<col />
  		</colgroup>
  		<tr>
  			<th>
	          <select name="sel_gubun">
	              <option value="99" <%= selGubun.equals("99") ? "selected" : "" %> ><!-- 전체 --><%=g.getMessage("LABEL.F.F51.0002")%></option>
	              <option value="01" <%= selGubun.equals("01") ? "selected" : "" %> ><!--경조금 --><%=g.getMessage("LABEL.F.F51.0003")%></option>
	              <option value="02" <%= selGubun.equals("02") ? "selected" : "" %> ><!--의료비 --><%=g.getMessage("LABEL.F.F51.0004")%></option>
	              <option value="03" <%= selGubun.equals("03") ? "selected" : "" %> ><!--장학 자금 --><%=g.getMessage("LABEL.F.F51.0005")%></option>
              <!--[CSR ID:3124077] 조직통계<복리후생현황 데이타 삭제요청의 건  -->
              <!--<option value="04" <%= selGubun.equals("04") ? "selected" : "" %> >입학 축하금</option> -->
	              <option value="05" <%= selGubun.equals("05") ? "selected" : "" %> ><!--주택자금 지원 --><%=g.getMessage("LABEL.F.F51.0007")%></option>
	          </select>
			</th>
			<td>
				<input name="txt_startDay" class="date" type="text" size="10" maxlength="10" value="<%=WebUtil.printDate(startDay)%>">
				~
				<input name="txt_endDay" class="date" type="text"  size="10" maxlength="10" value="<%=WebUtil.printDate(endDay)%>" >
				(<!-- 예 --><%=g.getMessage("LABEL.F.F51.0031")%> : 2005-01-28)&nbsp;
				<div class="tableBtnSearch tableBtnSearch2">
					<a   class="search loading" href="javascript:searchWelfare()"><span><!-- 조회 --><%=g.getMessage("BUTTON.COMMON.SEARCH")%></span></a>
				</div>
			</td>
		</tr>
	</table>
  </div>

<!--  검색테이블 끝-->


<%
//RFC 결과
if ( E_RETURN.equals("S") ) {
    //부서명, 조회된 건수.
    if ( DeptWelfare_vt != null && DeptWelfare_vt.size() > 0 ) {
%>


	<h2 class="subtitle"><!-- 부서명 --><%=g.getMessage("LABEL.F.F41.0002")%> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>

  <div class="listArea">
  	<div class="listTop">
  		<span class="listCnt"><!-- 총 --><%=g.getMessage("LABEL.F.F41.0003")%> <%=DeptWelfare_vt.size()%> <!--건 --><%=g.getMessage("LABEL.F.F41.0018")%></span>
  		<div class="buttonArea">
		    <ul class="btn_mdl">
		    	<li><a class="unloading" href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
		    </ul>
  		</div>
  		<div class="clear"></div>
  	</div>
    <div class="table">
      <table class="listTable">
		<thead>
        <tr>
          <th><!--사번 --><%=g.getMessage("LABEL.F.F41.0004")%></th>
          <th><!--이름 --><%=g.getMessage("LABEL.F.F41.0005")%></th>
          <th><!-- 소속 --><%=g.getMessage("LABEL.F.F51.0008")%></th>
		  <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
    	  <%--<th><!-- 직위 --><%=g.getMessage("LABEL.F.F41.0008")%></th>--%>
    	  <th><!-- 직책/직급호칭 --><%=g.getMessage("MSG.APPROVAL.0024")%></th>
          <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
          <th><!-- 구분 --><%=g.getMessage("LABEL.F.F42.0055")%></th>
          <th><!-- 내역 --><%=g.getMessage("LABEL.F.F51.0009")%></th>
          <th><!-- 대상구분 --><%=g.getMessage("LABEL.F.F51.0010")%></th>
          <th><!-- 대상자 --><%=g.getMessage("LABEL.F.F51.0011")%></th>
          <th><!-- 지원액 --><%=g.getMessage("LABEL.F.F51.0012")%></th>
          <th><!--통화 --><%=g.getMessage("LABEL.F.F51.0013")%></th>
          <th><!-- 신청일자 --><%=g.getMessage("LABEL.F.F51.0014")%></th>
          <th class="lastCol"><!-- 결재일자 --><%=g.getMessage("LABEL.F.F51.0015")%></th>
        </tr>
        </thead>
<%
            for( int i = 0; i < DeptWelfare_vt.size(); i++ ){
                F51DeptWelfareData data = (F51DeptWelfareData)DeptWelfare_vt.get(i);
                String PERNR =  AESgenerUtil.encryptAES(data.PERNR, request); //암호화를 위해

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
        <tr class="<%=tr_class%>">
          <td><a class="unloading"  href="javascript:popupView('orgView','1024','700','<%= PERNR %>')"><font color=blue><%= data.PERNR %></font></a>&nbsp;</td>
          <td><%= data.KNAME %>&nbsp;</td>
          <td><%= data.STEXT %>&nbsp;</td>
           <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
           <%--<td><%= data.TITEL%>&nbsp;</td> --%>
          <td><%= data.TITEL_T.equals("EBA") && !data.TITL2.equals("")? data.TITL2 : data.TITEL %>&nbsp;</td>
           <%--CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
          <td><%= data.GUBUN %>&nbsp;</td>
          <td><%= data.DESCRIPTION %>&nbsp;</td>
          <td><%= data.RELA_CODE %>&nbsp;</td>
          <td><%= data.EREL_NAME %>&nbsp;</td>
          <td><%= WebUtil.printNumFormat(Double.parseDouble(data.PAID_AMNT)*100) %>&nbsp;</td>
          <td><%= data.WAERS %>&nbsp;</td>
          <td><%= (data.APPL_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.APPL_DATE) %>&nbsp;</td>
          <td class="lastCol"><%= (data.APPR_DATE).equals("0000-00-00") ? "" : WebUtil.printDate(data.APPR_DATE) %>&nbsp;</td>
        </tr>
<%
          } //end for...
%>
      </table>
    </div>
  </div>


<%
    }else{
%>

  <table>
    <tr align="center">
      <td align="center"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.COMMON.0004")%></td>
    </tr>
  </table>
<%
    } //end if...
//RFC에서 해당 데이터가 없을경우.
}else{
%>
  <table>
    <tr align="center">
      <td align="center"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.COMMON.0004")%></td>
    </tr>
  </table>
<%
} //end if...
%>

</form>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />

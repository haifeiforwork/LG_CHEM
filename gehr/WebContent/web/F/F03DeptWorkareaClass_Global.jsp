<%/******************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 근무지별/직급별 인원현황
*   Program ID   : F03DeptWorkareaClass.jsp
*   Description  : 근무지별/직급별 인원현황 조회를 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       : 2018-04-04 cykim		[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청
*
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>

<%
    request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");                                          //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                  //부서코드



    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                                //부서명
    Vector F03DeptWorkareaClassTitle_vt = (Vector)request.getAttribute("F03DeptWorkareaClassTitle_vt");   //제목
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
    HashMap meta = (HashMap)request.getAttribute("meta");
    F03DeptWorkareaClassTitleGlobalData total = new F03DeptWorkareaClassTitleGlobalData();
    AppUtil.initEntity(total,"1");
    if(F03DeptWorkareaClassTitle_vt != null && F03DeptWorkareaClassTitle_vt.size() > 0)
       total = (F03DeptWorkareaClassTitleGlobalData)F03DeptWorkareaClassTitle_vt.get(F03DeptWorkareaClassTitle_vt.size() - 1 );
    AppUtil.nvlEntity(total);
    int office = 0 ;
    int plant = 0 ;
    int intern = 0 ;

    //office colspan

    if(Integer.parseInt(total.P03) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P04) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P05) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P06) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P24) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P25) > 0){
        office ++;
    }

    if(Integer.parseInt(total.P07) > 0){
        office ++;
    }

    if(Integer.parseInt(total.P26) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P27) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P08) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P09) > 0){
        office ++;
    }
    if(Integer.parseInt(total.P10) > 0){
        office ++;
    }
  	//[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start
	if (Integer.parseInt(total.P28) > 0) {
        office ++;
    }
    if (Integer.parseInt(total.P29) > 0) {
        office ++;
    }
    if (Integer.parseInt(total.P30) > 0) {
        office ++;
    }
    if (Integer.parseInt(total.P31) > 0) {
        office ++;
    }
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 end

    //plant colspan
    if(Integer.parseInt(total.P11) > 0){
        plant ++;
    }
    if(Integer.parseInt(total.P12) > 0){
        plant ++;
    }
    if(Integer.parseInt(total.P13) > 0){
        plant ++;
    }
    if(Integer.parseInt(total.P14) > 0){
        plant ++;
    }
    if(Integer.parseInt(total.P15) > 0){
        plant ++;
    }
    if(Integer.parseInt(total.P16) > 0){
        plant ++;
    }
    if(Integer.parseInt(total.P17) > 0){
        plant ++;
    }


    //Intern colspan
    if(Integer.parseInt(total.P18) > 0){
        intern ++;
    }
    if(Integer.parseInt(total.P19) > 0){
        intern ++;
    }
    if(Integer.parseInt(total.P20) > 0){
        intern ++;
    }

%>
<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(paramA, paramB, paramC, paramD, paramE, value){
    frm = document.form1;

    if( value!= "" && value!= "0"){
        /*if(paramD!= ""){
            paramD = paramD.substring(6,8);
        } */
        paramA = '00000000';
        if(paramB=='TOTAL'){
            paramA = '00000000';
            paramD = '8888';
        }else{
            //paramA = '';
        }
        frm.hdn_gubun.value  = "16";             //근무지별/직급별 인원현황
        frm.hdn_deptId.value = "<%= deptId %>";  //조회된 부서코드.
        frm.hdn_paramA.value = paramA;           //선택된 부서코드.
        frm.hdn_paramB.value = paramB;           //선택된 부서명
        frm.hdn_paramC.value = paramC;
        frm.hdn_paramD.value = paramD;
        frm.hdn_paramE.value = paramE;
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
        frm.target = "_self";
        frm.submit();
    }
}

//Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F03DeptWorkareaClassSV";
    frm.target = "hidden";
    frm.submit();
}
//-->
</SCRIPT>

<jsp:include page="/include/header.jsp" />
 <jsp:include page="/include/body-header.jsp">
     <jsp:param name="click" value="Y'"/>
</jsp:include>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_paramA"  value="">
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="">
<input type="hidden" name="hdn_paramE"  value="">

<%
    if ( F03DeptWorkareaClassTitle_vt != null && F03DeptWorkareaClassTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
%>

    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
            <div class="clear"></div>
        </div>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
            	<thead>
                <tr>
                  <th colspan="2"><spring:message code='LABEL.F.F03.0001'/><!-- Working Area --></th>
                  <%
                    if(Integer.parseInt(total.P01)>0 && Integer.parseInt(total.P02) > 0){
                  %>
                  <th colspan="2"><spring:message code='LABEL.F.F01.0001'/><!-- EMP. --></th>
                  <%
                    }else if(Integer.parseInt(total.P01)>0 || Integer.parseInt(total.P02) > 0){
                  %>
                  <th><spring:message code='LABEL.F.F01.0001'/><!-- EMP. --></th>
                  <%
                    }
                    if(office > 0){
                  %>
                  <th colspan="<%=office %>" ><spring:message code='LABEL.F.F01.0002'/><!-- Office Worker --></th>
                  <%
                  }
                  if(plant >0){
                  %>
                  <th colspan="<%=plant %>" ><spring:message code='LABEL.F.F01.0003'/><!-- Plant Operator --></th>
                  <%
                  }
                  if(intern > 0){
                  %>
                  <th colspan="<%=intern %>" ><spring:message code='LABEL.F.F01.0004'/><!-- Intern --></th>
                  <%
                  }
                  if(Integer.parseInt(total.P21) > 0){
                  %>
                  <th rowspan="2" width="55" nowrap><spring:message code='LABEL.F.F01.0005'/><!-- Others --></th>
                  <%
                  }
                  if(Integer.parseInt(total.P22) > 0){
                  %>
                  <th rowspan="2" width="55" nowrap><spring:message code='LABEL.F.F01.0043'/><!-- EMP. --><br><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                  <%
                  }
                  %>
                  <th rowspan="2" width="55" nowrap><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
                </tr>
                <tr>
                  <th><spring:message code='LABEL.F.F03.0002'/><!-- Pers. Area --></th>
                  <th><spring:message code='LABEL.F.F03.0003'/><!-- Pers. Subarea --></th>

                  <%
                    if(Integer.parseInt(total.P01) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0007'/><!-- KR --></th>
                  <%
                  }
                    if(Integer.parseInt(total.P02) > 0){
                  %>

                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0008'/><!-- Partner --></th>
                  <%
                  }
                    if(Integer.parseInt(total.P03) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0010'/><!-- I --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P04) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0011'/><!-- II-1 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P05) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0012'/><!-- II-2 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P06) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0013'/><!-- III --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P24) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0014'/><!-- III-1 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P25) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0015'/><!-- III-2 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P07) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0016'/><!-- IV-1 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P26) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0017'/><!-- IV-1.A --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P27) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0018'/><!-- IV-1.B --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P08) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0019'/><!-- IV-2 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P09) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0020'/><!-- IV-3 --></th>
                  <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start -->
				  <%
                    }
                    if (Integer.parseInt(total.P30) > 0) {
                  %>
                  <th width="65" nowrap><spring:message code='LABEL.F.F01.0044'/><!-- L1 --></th>
                  <%
                    }
                    if (Integer.parseInt(total.P29) > 0) {
                  %>
                  <th width="65" nowrap><spring:message code='LABEL.F.F01.0045'/><!-- L2 --></th>
                  <%
                    }
                    if (Integer.parseInt(total.P28) > 0) {
                  %>
                  <th width="65" nowrap><spring:message code='LABEL.F.F01.0046'/><!-- L3 --></th>
                  <%
                    }
                    if (Integer.parseInt(total.P31) > 0) {
                  %>
                  <th width="65" nowrap><spring:message code='LABEL.F.F01.0047'/><!-- OTHERS --></th>
                  <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  end -->
                  <%
                    }
                    if(Integer.parseInt(total.P10) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P11) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0021'/><!-- J1 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P14) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0022'/><!-- J2 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P12) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0023'/><!-- J1-1 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P13) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0024'/><!-- J1-2 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P15) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0025'/><!-- J2-1 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P16) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0026'/><!-- J2-2 --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P17) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F04.0002'/><!--SUM --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P18) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0027'/><!-- O/W --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P19) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F01.0028'/><!-- P/O --></th>
                  <%
                    }
                    if(Integer.parseInt(total.P20) > 0){
                  %>
                  <th width="60" nowrap><spring:message code='LABEL.F.F04.0002'/><!--SUM --></th>
                  <%
                    }
                  %>
                </tr>
                </thead>
                <%
                    String tmp = "";
                    for( int i = 0 ; i < F03DeptWorkareaClassTitle_vt.size() ; i ++){
         	           F03DeptWorkareaClassTitleGlobalData entity = (F03DeptWorkareaClassTitleGlobalData)F03DeptWorkareaClassTitle_vt.get(i);
         	        	String tr_class = "";

                        if(i%2 == 0){
                            tr_class="oddRow";
                        }else{
                            tr_class="";
                        }
                %>
                <tr class="borderRow">
                    <%
                        if(!tmp.equals(entity.PBTXT)){
                    %>
                    <td nowrap class="<%=entity.PBTXT.equals("TOTAL")?"td11":""%>" rowspan="<%=meta.get(entity.PBTXT)%>" <%=entity.PBTXT.equals("TOTAL")?"colspan='2'":""%> ><%=entity.PBTXT %></td>
                    <%
                        }if(!entity.PBTXT.equals("TOTAL")){
                            if(entity.BTEXT != null && entity.BTEXT.equals("SUBTOTAL"))
                                entity.BTEXT = "Sub-sum";
                    %>
                    <td nowrap class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>"><%=entity.BTEXT %></td>
                    <%
                    }
                    if(Integer.parseInt(total.P01) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C01 %>','<%=entity.P01 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P01) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P02) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C02 %>','<%=entity.P02 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P02) %></a>
                    </td>
                    <%
                    }
                    %>
                  <%
                    if(Integer.parseInt(total.P03) > 0){
                  %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>">
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C03 %>','<%=entity.P03 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P03) %></a>
                    </td>
                  <%
                    }
                    if(Integer.parseInt(total.P04) > 0){
                  %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>">
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C04 %>','<%=entity.P04 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P04) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P05) > 0 ){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>">
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C05 %>','<%=entity.P05 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P05)%></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P06) > 0 ){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C06 %>','<%=entity.P06 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P06) %></a>
                    </td>

                    <%
                    }
                    if(Integer.parseInt(total.P24) > 0 ){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C24 %>','<%=entity.P24 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P24) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P25) > 0 ){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C25 %>','<%=entity.P25 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P25) %></a>
                    </td>

                    <%
                    }
                    if(Integer.parseInt(total.P07) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C07 %>','<%=entity.P07 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P07) %></a>
                    </td>
                    <!-- 20150309 -->
                    <%
                    }
                    if(Integer.parseInt(total.P26) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C26 %>','<%=entity.P26 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P26) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P27) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C27 %>','<%=entity.P27 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P27) %></a>
                    </td>

                    <%
                    }
                    if(Integer.parseInt(total.P08) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C08 %>','<%=entity.P08 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P08) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P09) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C09 %>','<%=entity.P09 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P09) %></a>
                    </td>
                    <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start -->
					<%
                    }
                    if(Integer.parseInt(total.P30) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C30 %>','<%=entity.P30 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P30) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P29) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C29 %>','<%=entity.P29 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P29) %></a>
                    </td>

                    <%
                    }
                    if(Integer.parseInt(total.P28) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C28 %>','<%=entity.P28 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P28) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P31) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C31 %>','<%=entity.P31 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P31) %></a>
                    </td>
		            <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  end -->
                    <%
                    }
                    if(Integer.parseInt(total.P10) > 0 ){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C10 %>','<%=entity.P10 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P10) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P11) > 0 ){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C11 %>','<%=entity.P11 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P11) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P14) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C14 %>','<%=entity.P14 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P14) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P12) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C12 %>','<%=entity.P12 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P12) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P13) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C13 %>','<%=entity.P13 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P13) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P15) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C15 %>','<%=entity.P15 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P15) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P16) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C16 %>','<%=entity.P16 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P16) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P17) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C17 %>','<%=entity.P17 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P17) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P18) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C18 %>','<%=entity.P18 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P18) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P19) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C19 %>','<%=entity.P19 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P19) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P20) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C20 %>','<%=entity.P20 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P20) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P21) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C21 %>','<%=entity.P21 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P21) %></a>
                    </td>
                    <%
                    }
                    if(Integer.parseInt(total.P22) > 0){
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C22 %>','<%=entity.P22 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P22) %></a>
                    </td>
                    <%
                    }
                    %>
                    <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("Sub-sum")?"td11_2":""%>" >
                    <a href="javascript:goDetail('<%=deptId%>','<%=entity.PBTXT.equals("TOTAL")?"TOTAL":entity.BTEXT.equals("Sub-sum")?"Sub-sum":entity.PBTXT %>','<%=entity.WERKS %>','<%=entity.BTRTL %>','<%=entity.C23 %>','<%=entity.P23 %>')" title='<%=entity.PBTXT.equals("TOTAL")?"":entity.BTEXT %>'><%=WebUtil.printNumFormat(entity.P23)%></a>
                    </td>
                </tr>
            <%
                tmp = entity.PBTXT;
                }
            %>
            </table>
        </div>
    </div>

</div>

<%
    }else{
%>


    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></div>
        </div>
        <div class="table">
            <table border="0" cellpadding="0" cellspacing="1" class="table02" align="left">
                <tr>
                  <th rowspan="2"><spring:message code='LABEL.F.F03.0001'/><!-- Working Area --></th>
                  <th colspan="2"><spring:message code='LABEL.F.F01.0001'/><!-- EXP. --></th>
                  <th colspan="16" ><spring:message code='LABEL.F.F01.0002'/><!-- Office Worker --></th>
                  <th colspan="7" ><spring:message code='LABEL.F.F01.0003'/><!-- Plant Operator --></th>
                  <th colspan="3"><spring:message code='LABEL.F.F01.0004'/><!-- Intern --></th>
                  <th rowspan="2"><spring:message code='LABEL.F.F01.0005'/><!-- Others --></th>
                  <th rowspan="2"><spring:message code='LABEL.F.F01.0043'/><!-- EMP. --> <br><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                  <th class="lastCol" rowspan="2"><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></th>
                </tr>
                <tr>
                  <th><spring:message code='LABEL.F.F01.0007'/><!-- KR --></th>
                  <th><spring:message code='LABEL.F.F01.0008'/><!-- Partner --></th>
                  <th><spring:message code='LABEL.F.F01.0009'/><!-- EXEC. --></th>
                  <th><spring:message code='LABEL.F.F01.0010'/><!-- I --></th>
                  <th><spring:message code='LABEL.F.F01.0011'/><!-- II-1 --></th>
                  <th><spring:message code='LABEL.F.F01.0012'/><!-- II-2 --></th>
                  <th><spring:message code='LABEL.F.F01.0013'/><!-- III --></th>
                  <th><spring:message code='LABEL.F.F01.0014'/><!-- III-1 --></th>
                  <th><spring:message code='LABEL.F.F01.0015'/><!-- III-2 --></th>
                  <th><spring:message code='LABEL.F.F01.0016'/><!-- IV-1 --></th>
                  <th><spring:message code='LABEL.F.F01.0017'/><!-- IV-1.A --></th>
                  <th><spring:message code='LABEL.F.F01.0018'/><!-- IV-1.B --></th>
                  <th><spring:message code='LABEL.F.F01.0019'/><!-- IV-2 --></th>
                  <th><spring:message code='LABEL.F.F01.0020'/><!-- IV-3 --></th>
				  <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start -->
				  <th><spring:message code='LABEL.F.F01.0044'/><!-- L1 --></th>
                  <th><spring:message code='LABEL.F.F01.0045'/><!-- L2 --></th>
                  <th><spring:message code='LABEL.F.F01.0046'/><!-- L3 --></th>
                  <th><spring:message code='LABEL.F.F01.0047'/><!-- OTHERS --></th>
                  <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 end -->
                  <th><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                  <th><spring:message code='LABEL.F.F01.0021'/><!-- J1 --></th>
                  <th><spring:message code='LABEL.F.F01.0022'/><!-- J2 --></th>
                  <th><spring:message code='LABEL.F.F01.0023'/><!-- J1-1 --></th>
                  <th><spring:message code='LABEL.F.F01.0024'/><!-- J1-2 --></th>
                  <th><spring:message code='LABEL.F.F01.0025'/><!-- J2-1 --></th>
                  <th><spring:message code='LABEL.F.F01.0026'/><!-- J2-2 --></th>
                  <th><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                  <th><spring:message code='LABEL.F.F01.0027'/><!-- O/W --></th>
                  <th><spring:message code='LABEL.F.F01.0028'/><!-- P/O --></th>
                  <th><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                </tr>
              <tr>
                <td class="lastCol" colspan="25"><spring:message code='MSG.F.FCOMMON.0002'/></td>
              </tr>
            </table>
        </div>
    </div>
</div>
<%
    } //end if...
%>
</form>
</body>
</html>


<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Organization & Staffing
*   2Depth Name  : Headcount
*   Program Name : Org.Unit/Distance
*   Program ID   : F73DistanceInKilometersEurp.jsp
*   Description  : 부서별 거주지와 출퇴근정보 조회를 위한 jsp 파일
*   Note         :
*   Creation     :
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.common.util.*" %>

<%
    request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");                                          //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);                  //부서코드
    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                                //부서명

    Vector F73DistanceInKilometersTitle_vt = (Vector)request.getAttribute("F73DistanceInKilometersTitle_vt");   //제목
    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.
    HashMap meta = (HashMap)request.getAttribute("meta");
    F73DistanceInKilometersEurpGlobalData total = new F73DistanceInKilometersEurpGlobalData();
    AppUtil.initEntity(total,"1");
    if(F73DistanceInKilometersTitle_vt != null && F73DistanceInKilometersTitle_vt.size() > 0)
       total = (F73DistanceInKilometersEurpGlobalData)F73DistanceInKilometersTitle_vt.get(F73DistanceInKilometersTitle_vt.size() - 1 );
    AppUtil.nvlEntity(total);
%>
<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
//상세화면으로 이동.
function goDetail(selectedOrgeh, selectedItemNm, paramC, paramD, paramE, value){
    frm = document.form1;

    if( value!= "" && value!= "0"){

        paramA = '00000000';
        if(selectedItemNm=='TOTAL'){
            paramA = '00000000';
            paramD = '8888';
        }

        frm.hdn_gubun.value  = "22";             //근무지별/직급별 인원현황
        frm.hdn_deptId.value = "<%= deptId %>";  //조회된 부서코드.
        frm.hdn_paramA.value = selectedOrgeh;           //선택된 부서코드.
        frm.hdn_paramB.value = selectedItemNm;           //선택된 값의 컬럼이름
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
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F73DistanceInKilometersEurpSV";
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
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">
<input type="hidden" name="hdn_Popflag"   value="N">

<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_paramA"  value="">
<input type="hidden" name="hdn_paramB"  value="">
<input type="hidden" name="hdn_paramC"  value="">
<input type="hidden" name="hdn_paramD"  value="">
<input type="hidden" name="hdn_paramE"  value="">
<%
 if ( F73DistanceInKilometersTitle_vt != null && F73DistanceInKilometersTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
%>

    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
                </ul>
            </div>
        </div>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
            <thead>
            <tr>
              <th rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/></th>
              <th rowspan="2"><spring:message code='LABEL.F.F73.0001'/><!-- Active --><br><spring:message code='LABEL.F.F73.0002'/><!-- Employee --></th>
              <th colspan="5"><spring:message code='LABEL.F.F73.0003'/><!-- 51km&nbsp;↑ --></th>
             <th colspan="2"><spring:message code='LABEL.F.F73.0004'/><!-- 50km&nbsp;↓ --></th>
            </tr>
            <tr>
              <th width="100" nowrap><spring:message code='LABEL.F.F73.0005'/><!-- 100Km&nbsp;↑ --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F73.0006'/><!-- 71~100Km --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F73.0007'/><!-- 51~71Km --></th>
              <th width="100" nowrap><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></th>
              <th width="100" nowrap>%</th>
              <th width="100" nowrap><spring:message code='LABEL.F.F73.0004'/><!-- 50Km&nbsp;↓ --></th>
              <th width="100" nowrap>%</th>
            </tr>
            </thead>
            <%
            int tok = 0;
            for( int i = 0 ; i < F73DistanceInKilometersTitle_vt.size() ; i ++){
                F73DistanceInKilometersEurpGlobalData entity = (F73DistanceInKilometersEurpGlobalData)F73DistanceInKilometersTitle_vt.get(i);

                if((entity.ZLEVEL != null && !entity.ZLEVEL.equals("") && Integer.parseInt(entity.ZLEVEL) != 0 && Integer.parseInt(entity.ZLEVEL) < tok) || i ==0){
                    tok = Integer.parseInt(entity.ZLEVEL);
                }

            }
            //타이틀에 맞추어 내용영역 보여주기위한 개수.
            int noteSize = F73DistanceInKilometersTitle_vt.size();
            //내용.
            for( int i = 0; i < F73DistanceInKilometersTitle_vt.size(); i++ ){
                F73DistanceInKilometersEurpGlobalData data = (F73DistanceInKilometersEurpGlobalData)F73DistanceInKilometersTitle_vt.get(i);

                String strBlank  = "";
                String titlClass = "";
                String noteClass = "";
                int blankSize = Integer.parseInt(WebUtil.nvl(data.ZLEVEL, "0")) ;

                int bstyle = 0 ;
                if(blankSize >= tok)
                    bstyle = 5 * (blankSize - tok) + 10;
                //클래스 설정.
                if (!data.ORGTX.equals("TOTAL")) {
                    titlClass = "class=td09_1 style='padding-left:"+ bstyle +"'";
                    noteClass = "class=td05";
                } else {
                    titlClass = "class=td11 style='text-align:center;padding-left:"+ bstyle +"'";
                    noteClass = "class=td11";
                }
                //부서명 앞에 공백넣기.
                String tr_class = "";
                if( i%2 == 0){
                	tr_class ="oddRow";
                }else{
                	tr_class ="";
                }
            %>

            <tr class=<%=tr_class %>>
                <td nowrap <%=titlClass%> nowrap><%=strBlank%><%= data.ORGTX %></td>
                <td class="<%=data.ORGTX.equals("TOTAL")?"td11":""%>"><%=data.EMPNR %></td>
                <td class="<%=data.ORGTX.equals("TOTAL")?"td11":""%>">
                    <a href="javascript:goDetail('<%=data.ORGEH%>','DIS01','','','','<%=data.DIS01 %>')" title='<%= data.ORGTX %>'>
                    <%= WebUtil.printNumFormat(data.DIS01) %></td>
                <td class="<%=data.ORGTX.equals("TOTAL")?"td11":""%>">
                    <a href="javascript:goDetail('<%=data.ORGEH%>','DIS02','','','','<%=data.DIS02 %>')" title='<%= data.ORGTX %>'>
                    <%= WebUtil.printNumFormat(data.DIS02) %></td>
                <td class="<%=data.ORGTX.equals("TOTAL")?"td11":""%>">
                    <a href="javascript:goDetail('<%=data.ORGEH%>','DIS03','','','','<%=data.DIS03 %>')" title='<%= data.ORGTX %>'>
                    <%= WebUtil.printNumFormat(data.DIS03) %></td>
                <td class="<%=data.ORGTX.equals("TOTAL")?"td11":""%>">
                    <a href="javascript:goDetail('<%=data.ORGEH%>','TOTAL','','','','<%=data.TOTAL %>')" title='<%= data.ORGTX %>'>
                    <%= WebUtil.printNumFormat(data.TOTAL) %></td>
                <td class="<%=data.ORGTX.equals("TOTAL")?"td11":""%>">
                    <%= WebUtil.printNumFormat(data.PCT01) %></td>
                <td class="<%=data.ORGTX.equals("TOTAL")?"td11":""%>">
                    <a href="javascript:goDetail('<%=data.ORGEH%>','DIS04','','','','<%=data.DIS04 %>')" title='<%= data.ORGTX %>'>
                    <%= WebUtil.printNumFormat(data.DIS04) %></td>
                <td class="<%=data.ORGTX.equals("TOTAL")?"td11":""%>">
                    <%= WebUtil.printNumFormat(data.PCT02) %></td>
            </tr>
            <%
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
            <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%></h2>
        </div>
        <div class="table">
            <table class="listTable">
                <tr>
					<th rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/></th>
					<th rowspan="2"><spring:message code='LABEL.F.F73.0001'/><!-- Active --><br><spring:message code='LABEL.F.F73.0002'/><!-- Employee --></th>
					<th colspan="5"><spring:message code='LABEL.F.F73.0003'/><!-- 51km&nbsp;↑ --></th>
					<th class="lastCol" colspan="2"><spring:message code='LABEL.F.F73.0004'/><!-- 50km&nbsp;↓ --></th>
                </tr>
                <tr>
	              <th><spring:message code='LABEL.F.F73.0005'/><!-- 100Km&nbsp;↑ --></th>
	              <th><spring:message code='LABEL.F.F73.0006'/><!-- 71~100Km --></th>
	              <th><spring:message code='LABEL.F.F73.0007'/><!-- 51~71Km --></th>
	              <th><spring:message code='LABEL.F.F10.0006'/><!-- SUM --></th>
	              <th>%</th>
	              <th><spring:message code='LABEL.F.F73.0004'/><!-- 50Km&nbsp;↓ --></th>
	              <th>%</th>
                </tr>
                <tr>
                    <td class="lastCol" colspan="9"><spring:message code='LABEL.F.FCOMMON.0002'/></td>
                </tr>
            </table>
        </div>
    </div>
</div>
<%
    } //end if...
%>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
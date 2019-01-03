<%/***************************************************************************************
*      System Name : g-HR
*      1Depth Name     : Organization & Staffing
*      2Depth Name     : Org.Unit/Level
*      Program Name    : 소속별/직급별 인원현황
*      Program ID      : F01DeptPositionClass_Global.jsp
*      Description     : 소속별/직급별 인원현황 조회를 위한 jsp 파일
*      Note                : 없음
*      Creation        :
*      Update          :   2018-04-03 cykim   [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ page import="com.common.constant.Area" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.*" %>
<%
    request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");                               // 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"), user.e_objid);          // 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                          // 부서명

    Vector F01DeptPositionClassTitle_vt = (Vector)request.getAttribute("F01DeptPositionClassTitle_vt");     // 제목


    String chck_yeno = WebUtil.nvl((String)request.getParameter("chck_yeno"),(String)request.getAttribute("checkYn"));     //하위부서여부.

    HashMap meta = (HashMap)request.getAttribute("meta");
    if (meta == null)
        meta = new HashMap();

    F01DeptPositionClassTitleGlobalData total = new F01DeptPositionClassTitleGlobalData();
    AppUtil.initEntity(total,"0");

    if (F01DeptPositionClassTitle_vt != null && F01DeptPositionClassTitle_vt.size() > 0)
        total = (F01DeptPositionClassTitleGlobalData)F01DeptPositionClassTitle_vt.get(F01DeptPositionClassTitle_vt.size() - 1 );
    AppUtil.nvlEntity(total);

    int office = 0;
    int plant = 0;
    int intern = 0;

    //office colspan
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start
    /* if(Integer.parseInt(total.JIKCN03) > 0) {
        office ++;
    } */
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 end
    if(Integer.parseInt(total.JIKCN04) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN05) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN06) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN07) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN08) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN09) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.SUBTOL1) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN10) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN11) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN12) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN13) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN14) > 0) {
        office ++;
    }
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start
    if(Integer.parseInt(total.JIKCN21) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN22) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN23) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN24) > 0) {
        office ++;
    }
  	//[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 end

    //plant colspan
    if(Integer.parseInt(total.JIKCN15) > 0) {
        plant ++;
    }
    if(Integer.parseInt(total.JIKCN16) > 0) {
        plant ++;
    }
    if(Integer.parseInt(total.JIKCN17) > 0) {
        plant ++;
    }
    if(Integer.parseInt(total.JIKCN18) > 0) {
        plant ++;
    }
    if(Integer.parseInt(total.JIKCN19) > 0) {
        plant ++;
    }
    if(Integer.parseInt(total.JIKCN20) > 0) {
        plant ++;
    }
    if(Integer.parseInt(total.SUBTOL2) > 0) {
        plant ++;
    }
    //Intern colspan
    if(Integer.parseInt(total.INTERN1) > 0) {
        intern ++;
    }
    if(Integer.parseInt(total.INTERN2) > 0) {
        intern ++;
    }
    if(Integer.parseInt(total.SUBTOL3) > 0) {
        intern ++;
    }
%>

<SCRIPT LANGUAGE="JavaScript">
<!--

// 조회에 의한 부서ID와 그에 따른 조회.
function setDeptID(deptId, deptNm) {
    frm = document.form1;

    frm.hdn_deptId.value = deptId;
    frm.hdn_deptNm.value = deptNm;
    frm.hdn_excel.value = "";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F01DeptPositionClassSV";
    frm.target = "_self";
    frm.submit();
}

// 상세화면으로 이동.
function goDetail(paramA, paramB, paramC, paramD, paramE, value) {
    frm = document.form1;

    if (value!= "" && value!= "0") {
        /*if(paramC!= ""){
            paramC = paramC.substring(6,8);
        }*/
        frm.hdn_gubun.value  = "21";                        //소속별/직급별
        frm.hdn_deptId.value = "<%= deptId %>";     //조회된 부서코드.
        frm.hdn_paramA.value = paramA;                  //선택된 부서코드.
        frm.hdn_paramB.value = paramB;                  //선택된 부서명
        frm.hdn_paramC.value = paramC;
        frm.hdn_excel.value = "";
        frm.action = "<%= WebUtil.ServletURL %>hris.F.F00DeptDetailListSV";
        frm.target = "_self";
        frm.submit();
    }
}

// Execl Down 하기.
function excelDown() {
    frm = document.form1;

    frm.hdn_excel.value = "ED";
    frm.action = "<%= WebUtil.ServletURL %>hris.F.F01DeptPositionClassSV";
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
<input type="hidden" name="hdn_deptId" value="<%= deptId %>">
<input type="hidden" name="hdn_deptNm" value="<%= deptNm %>">
<input type="hidden" name="hdn_excel" value="">
<input type="hidden" name="chck_yeno"   value="<%= chck_yeno%>">

<input type="hidden" name="hdn_gubun" value="">
<input type="hidden" name="hdn_paramA" value="">
<input type="hidden" name="hdn_paramB" value="">
<input type="hidden" name="hdn_paramC" value="">
<input type="hidden" name="hdn_paramD" value="">
<input type="hidden" name="hdn_paramE" value="">

<%
    if (F01DeptPositionClassTitle_vt != null && F01DeptPositionClassTitle_vt.size() > 0 ) {
%>

    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle withButtons"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %> <span class="commentOne">Others = Particular Emp. , Temporary Emp. , Retiree/Pensioner , Contract</span></h2>

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
                    <th rowspan="2"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --></th>
                    <%
                        if (Integer.parseInt(total.JIKEXP_KR) > 0 && Integer.parseInt(total.JIKEXP_PR) > 0){
                    %>
                    <th colspan="2"><spring:message code='LABEL.F.F01.0001'/><!-- EMP. --></th>
                    <%
                        } else if (Integer.parseInt(total.JIKEXP_KR) > 0 || Integer.parseInt(total.JIKEXP_PR) > 0){
                    %>
                    <th><spring:message code='LABEL.F.F01.0001'/><!-- EXP. --></th>
                    <%
                        }
                        if (office > 0) {
                    %>
                    <th colspan="<%= office %>"><spring:message code='LABEL.F.F01.0002'/><!-- Office Worker --></th>
                    <%
                        }
                        if (plant >0) {
                    %>
                    <th colspan="<%= plant %>"><spring:message code='LABEL.F.F01.0003'/><!-- Plant Operator --></th>
                    <%
                        }
                        if (intern > 0) {
                    %>
                    <th colspan="<%= intern %>"><spring:message code='LABEL.F.F01.0004'/><!-- Intern --></th>
                    <%
                        }
                        if (Integer.parseInt(total.OTHRS) > 0) {
                    %>
                    <th rowspan="2" width="60" nowrap><spring:message code='LABEL.F.F01.0005'/><!-- Others --></th>
                    <%
                        }
                        if (Integer.parseInt(total.EMPSUM) > 0) {
                    %>
                    <th rowspan="2" width="60" nowrap>&nbsp;&nbsp;<spring:message code='LABEL.F.F01.0043'/><!-- EMP. -->&nbsp;<br>&nbsp;<spring:message code='LABEL.F.F04.0002'/><!-- SUM -->&nbsp;&nbsp;</th>
                    <%
                        }
                    %>
                    <th rowspan="2" width="60" nowrap><spring:message code='LABEL.F.F01.0006'/></th>
                </tr>

                <tr>
                    <%
                        if (Integer.parseInt(total.JIKEXP_KR) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0007'/><!-- KR --></th>
                     <%
                        }
                        if (Integer.parseInt(total.JIKEXP_PR) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0008'/><!-- Partner --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKEXEC) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0009'/><!-- EXEC. --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN04) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0010'/><!-- I --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN05) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0011'/><!-- II-1 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN06) > 0) {
                    %>
                     <th width="60" nowrap><spring:message code='LABEL.F.F01.0012'/><!-- II-2 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN07) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0013'/><!-- III --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN08) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0014'/><!-- III-1 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN09) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0015'/><!-- III-2 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN10) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0016'/><!-- IV-1 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN11) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0017'/><!-- IV-1.A --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN12) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0018'/><!-- IV-1.B --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN13) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0019'/><!-- IV-2 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN14) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0020'/><!-- IV-3 --></th>
                    <!--[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  START -->
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN23) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0044'/><!-- L1 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN22) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0045'/><!-- L2 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN21) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0046'/><!-- L3 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN24) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0047'/><!-- OTHERS --></th>
                    <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  END -->
                    <%
                        }
                        if (Integer.parseInt(total.SUBTOL1) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN15) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0021'/><!-- J1 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN18) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0022'/><!-- J2 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN16) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0023'/><!-- J1-1 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN17) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0024'/><!-- J1-2 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN19) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0025'/><!-- J2-1 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN20) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0026'/><!-- J2-2 --></th>
                    <%
                        }
                        if (Integer.parseInt(total.SUBTOL2) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F04.0002'/><!--SUM --></th>
                    <%
                        }
                        if (Integer.parseInt(total.INTERN1) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0027'/><!-- O/W --></th>
                    <%
                        }
                        if (Integer.parseInt(total.INTERN2) > 0) {
                    %>
                    <th width="60" nowrap><spring:message code='LABEL.F.F01.0028'/><!-- P/O --></th>
                    <%
                        }
                        if (Integer.parseInt(total.SUBTOL3) > 0) {
                     %>
                     <th width="60" nowrap><spring:message code='LABEL.F.F04.0002'/><!--SUM --></th>
                     <%
                        }
                     %>
                </tr>
				</thead>
                <%
                    int tok = 0;
                    for (int i = 0 ; i < F01DeptPositionClassTitle_vt.size(); i ++) {
                    F01DeptPositionClassTitleGlobalData entity = (F01DeptPositionClassTitleGlobalData)F01DeptPositionClassTitle_vt.get(i);

                        if ((entity.ZLEVEL != null && Integer.parseInt(entity.ZLEVEL) != 0 && Integer.parseInt(entity.ZLEVEL) < tok) || i ==0) {
                            tok = Integer.parseInt(entity.ZLEVEL);
                        }
                    }

                    String tmp = "";
                    String tmpCode = "";

                    for ( int i = 0 ; i < F01DeptPositionClassTitle_vt.size() ; i ++) {
                    	F01DeptPositionClassTitleGlobalData entity = (F01DeptPositionClassTitleGlobalData)F01DeptPositionClassTitle_vt.get(i);
                    int bstyle = 0;
                    if (Integer.parseInt(entity.ZLEVEL) >= tok)
                        bstyle = 5 * (Integer.parseInt(entity.ZLEVEL) - tok) + 10;

                    String tr_class = "";
                    if(i%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }
                %>
                <tr class=<%=tr_class %>>
                    <%
                        if (!tmpCode.equals(entity.ORGEH) || !tmp.equals(entity.ORGTX) || entity.ORGTX.equals("")) {
                    %>
                    <td nowrap class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>" rowspan="<%= meta.get(entity.ORGTX + entity.ORGEH) == null ? "0" : meta.get(entity.ORGTX)%>" ;'>
                    <%
                            if (!entity.ZLEVEL.equals(""))
                                // for (int j = 0 ; j < Integer.parseInt(entity.ZLEVEL) - tok; j ++) {
                                //  out.print("&nbsp;&nbsp;&nbsp;&nbsp;");
                                //}
                    %>
                    <%= entity.ORGTX %>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKEXP_KR) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>" >
                    <a title="<%=entity.ORGTX %>" title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKEXP_KR','','','','<%= entity.JIKEXP_KR %>')"><%= WebUtil.printNumFormat( entity.JIKEXP_KR )%></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKEXP_PR) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>" >
                    <a title="<%= entity.ORGTX %>" title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKEXP_PR','','','','<%= entity.JIKEXP_PR %>')"><%= WebUtil.printNumFormat( entity.JIKEXP_PR)%></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKEXEC) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKEXEC','','','','<%= entity.JIKEXEC %>')"><%= WebUtil.printNumFormat( entity.JIKEXEC ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN04) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN04','<%= entity.JIKCH04 %>','','','<%= entity.JIKCN04 %>')"><%= WebUtil.printNumFormat( entity.JIKCN04 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN05) > 0 ) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN05','<%= entity.JIKCH05 %>','','','<%= entity.JIKCN05 %>')"><%= WebUtil.printNumFormat( entity.JIKCN05 )%></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN06) > 0 ) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN06','<%= entity.JIKCH06 %>','','','<%= entity.JIKCN06 %>')"><%= WebUtil.printNumFormat( entity.JIKCN06 ) %></a>
                    </td>
                    <%
                        }
                        //2015-03-13 pangxiaolin  @1.0 [C20150304_18004] 制度变更带来的E-HR界面修正申请start
                        if (Integer.parseInt(total.JIKCN07) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN07','<%= entity.JIKCH07 %>','','','<%= entity.JIKCN07 %>')"><%= WebUtil.printNumFormat( entity.JIKCN07)  %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN08) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN08','<%= entity.JIKCH08 %>','','','<%= entity.JIKCN08 %>')"><%= WebUtil.printNumFormat( entity.JIKCN08 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN09) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN09','<%= entity.JIKCH09 %>','','','<%= entity.JIKCN09 %>')"><%= WebUtil.printNumFormat( entity.JIKCN09 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN10) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN10','<%= entity.JIKCH10 %>','','','<%= entity.JIKCN10 %>')"><%= WebUtil.printNumFormat( entity.JIKCN10 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN11) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN11','<%= entity.JIKCH11 %>','','','<%= entity.JIKCN11 %>')"><%= WebUtil.printNumFormat( entity.JIKCN11 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN12) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN12','<%= entity.JIKCH12 %>','','','<%= entity.JIKCN12 %>')"><%= WebUtil.printNumFormat( entity.JIKCN12 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN13) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN13','<%= entity.JIKCH13 %>','','','<%= entity.JIKCN13 %>')"><%= WebUtil.printNumFormat( entity.JIKCN13 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN14) > 0 ) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN14','<%= entity.JIKCH14 %>','','','<%= entity.JIKCN14 %>')"><%= WebUtil.printNumFormat( entity.JIKCN14 ) %></a>
                    </td>
                    <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  START -->
					<%
                        }
                        if (Integer.parseInt(total.JIKCN23) > 0 ) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN23','<%= entity.JIKCH23 %>','','','<%= entity.JIKCN23 %>')"><%= WebUtil.printNumFormat( entity.JIKCN23 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN22) > 0 ) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN22','<%= entity.JIKCH22 %>','','','<%= entity.JIKCN22 %>')"><%= WebUtil.printNumFormat( entity.JIKCN22 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN21) > 0 ) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN21','<%= entity.JIKCH21 %>','','','<%= entity.JIKCN21 %>')"><%= WebUtil.printNumFormat( entity.JIKCN21 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN24) > 0 ) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN24','<%= entity.JIKCH24 %>','','','<%= entity.JIKCN24 %>')"><%= WebUtil.printNumFormat( entity.JIKCN24 ) %></a>
                    </td>
                    <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  END -->
                    <%
                        }
                        if (Integer.parseInt(total.SUBTOL1) > 0 ) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','SUBTOL1','','','','<%= entity.SUBTOL1 %>')"><%= WebUtil.printNumFormat( entity.SUBTOL1 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN15) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN15','<%= entity.JIKCH15 %>','','','<%= entity.JIKCN15 %>')"><%= WebUtil.printNumFormat( entity.JIKCN15 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN18) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN18','<%= entity.JIKCH18 %>','','','<%= entity.JIKCN18 %>')"><%= WebUtil.printNumFormat( entity.JIKCN18 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN16) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN16','<%= entity.JIKCH16 %>','','','<%= entity.JIKCN16 %>')"><%= WebUtil.printNumFormat( entity.JIKCN16 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN17) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN17','<%= entity.JIKCH17 %>','','','<%= entity.JIKCN17 %>')"><%= WebUtil.printNumFormat( entity.JIKCN17 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN19) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN19','<%= entity.JIKCH19 %>','','','<%= entity.JIKCN19 %>')"><%= WebUtil.printNumFormat( entity.JIKCN19 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.JIKCN20) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKCN20','<%= entity.JIKCH20 %>','','','<%= entity.JIKCN20 %>')"><%= WebUtil.printNumFormat( entity.JIKCN20 ) %></a>
                    </td>
                    <%
                        }
                        //2015-03-13 pangxiaolin  @1.0 [C20150304_18004] 制度变更带来的E-HR界面修正申请end
                        if (Integer.parseInt(total.SUBTOL2) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','SUBTOL2','','','','<%= entity.SUBTOL2 %>')"><%= WebUtil.printNumFormat( entity.SUBTOL2 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.INTERN1) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','INTERN1','','','','<%= entity.INTERN1 %>')"><%= WebUtil.printNumFormat( entity.INTERN1 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.INTERN2) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','INTERN2','','','','<%= entity.INTERN2 %>')"><%= WebUtil.printNumFormat( entity.INTERN2 )  %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.SUBTOL3) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','SUBTOL3','','','','<%= entity.SUBTOL3 %>')"><%= WebUtil.printNumFormat( entity.SUBTOL3 ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.OTHRS) > 0) {
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','OTHRS','','','','<%= entity.OTHRS %>')"><%= WebUtil.printNumFormat( entity.OTHRS ) %></a>
                    </td>
                    <%
                        }
                        if (Integer.parseInt(total.EMPSUM) > 0){
                    %>
                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','EMPSUM','','','','<%= entity.EMPSUM %>')"><%= WebUtil.printNumFormat( entity.EMPSUM ) %></a>
                    </td>
                    <%
                        }
                    %><td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"" %>">
                    <a title="<%= entity.ORGTX %>" href="javascript:goDetail('<%= entity.ORGEH %>','JIKTOL','','','','<%= entity.JIKTOL %>')"><%= WebUtil.printNumFormat( entity.JIKTOL ) %></a>
                    </td>
                </tr>
                <%
                    tmp = entity.ORGTX;
                    tmpCode = entity.ORGEH;
                    }
                %>
            </table>
        </div>
    </div>
</div>

<%
    } else {
%>



    <div class="listArea">
        <div class="listTop">
            <h2 class="subtitle"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %></h2>
        </div>
        <div class="wideTable" style="border-top: 2px solid #c8294b;">
            <table class="listTable">
                <tr>
                    <th>&nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team -->&nbsp;</th>
                    <th colspan="2">&nbsp;<spring:message code='LABEL.F.F01.0001'/><!-- EXP. -->&nbsp;</th>
                    <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 -->
                    <%-- <th colspan="9">&nbsp;<spring:message code='LABEL.F.F01.0002'/><!-- Office Worker -->&nbsp;</th> --%>
                    <th colspan="16">&nbsp;<spring:message code='LABEL.F.F01.0002'/><!-- Office Worker -->&nbsp;</th>
                    <th colspan="7">&nbsp;<spring:message code='LABEL.F.F01.0003'/><!-- Plant Operator -->&nbsp;</th>
                    <th colspan="3">&nbsp;<spring:message code='LABEL.F.F01.0004'/><!-- Intern -->&nbsp;</th>
                    <th rowspan="2">&nbsp;<spring:message code='LABEL.F.F01.0005'/><!-- Others -->&nbsp;</th>
                    <th rowspan="2">&nbsp;&nbsp;<spring:message code='LABEL.F.F01.0043'/><!-- EMP. -->&nbsp;<br>&nbsp;<spring:message code='LABEL.F.F04.0002'/><!-- SUM -->&nbsp;&nbsp;</th>
                    <th rowspan="2">&nbsp;<spring:message code='LABEL.F.F01.0006'/><!-- TOTAL -->&nbsp;</th>
                </tr>
                <tr>
                    <th>&nbsp;<spring:message code='LABEL.F.F01.0007'/><!-- KR -->&nbsp;</th>
                    <th>&nbsp;<spring:message code='LABEL.F.F01.0008'/><!-- Partner -->&nbsp;</th>
                    <th>&nbsp;<spring:message code='LABEL.F.F01.0009'/><!-- EXEC. -->&nbsp;</th>
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
                    <td colspan="25"><spring:message code='MSG.F.FCOMMON.0002'/><!-- There is no data that match. --></td>
                </tr>
            </table>
        </div>
    </div>
</div>

<%
    } //end if.
%>
</form>
</body>
</html>


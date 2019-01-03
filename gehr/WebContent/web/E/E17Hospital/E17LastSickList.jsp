<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 동일진료목록                                         */
/*   Program ID   : E17LastSickList.jsp                                         */
/*   Description  : 의료비 동일진료를 선택할수 있는 팝업목록                    */
/*   Note         :                                                             */
/*   Creation     : 2008-11-13  CSR ID:1357074 의료비담당자결재관련 보완        */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.E.E17Hospital.*" %>
<%@ page import="hris.E.E17Hospital.rfc.*" %>
<%
    E17LastYearSickRFC rfcSick            = new E17LastYearSickRFC();
    Vector     E17LastSickData_vt = new Vector();

    String     GUEN_CODE          = request.getParameter("GUEN_CODE");
    String     OBJPS_21           = request.getParameter("OBJPS_21");
    String     REGNO_21           = request.getParameter("REGNO");
    String     PERNR              = request.getParameter("PERNR");
    String     count              = request.getParameter("count");

    long       l_count            = 0;
    if( count != null ) {
        l_count                 = Long.parseLong(count);
    }

//  page 처리
    String  paging              = request.getParameter("page");

    try{
        E17LastSickData_vt = rfcSick.getSickData(PERNR, GUEN_CODE, OBJPS_21, REGNO_21);

        l_count = E17LastSickData_vt.size();

    }catch(Exception ex){
        E17LastSickData_vt = null;
    }

//  PageUtil 관련 - Page 사용시 반드시 써줄것.
  	PageUtil pu = null;
  	try {
  		pu = new PageUtil(E17LastSickData_vt.size(), paging , 10, 10);
      Logger.debug.println(this, "page : "+paging);
  	} catch (Exception ex) {
  		Logger.debug.println(DataUtil.getStackTrace(ex));
  	}
%>

<jsp:include page="/include/header.jsp"/>


<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="LABEL.E.E17.0021"/>
</jsp:include>
<script LANGUAGE="JavaScript">
    <!--
    $(function() {
        init();
    });
    function init(){
        <%
            if( E17LastSickData_vt != null ) {
                if( E17LastSickData_vt.size() == 0 ) {
        %>
        alert("<spring:message code='LABEL.E.E17.0049' />");  //신청된 의료비가 존재하지 않습니다.\n최초진료로 신청하세요.
        opener.document.form1.is_new_num[0].checked = true;
        //self.close();
        <%
                }
            }
        %>
    }

    function PageMove() {
        document.form1.action = "./E17LastSickList.jsp";
        document.form1.submit();
    }

    function changeAppData(inx){
        eval("opener.document.form1.LAST_CTRL.value=document.form1.LAST_CTRL"+inx+".value");
        eval("opener.document.form1.ORG_CTRL.value=document.form1.CTRL_NUMB"+inx+".value");
        eval("opener.document.form1.CTRL_NUMB.value=document.form1.CTRL_NUMB"+inx+".value");
        eval("opener.document.form1.SICK_NAME.value=document.form1.SICK_NAME"+inx+".value");
        eval("opener.document.form1.SICK_DESC.value=document.form1.SICK_DESC1"+inx+".value"+"\n"+"document.form1.SICK_DESC2"+inx+".value"+"\n"+"document.form1.SICK_DESC3"+inx+".value"+"\n"+"document.form1.SICK_DESC4"+inx+".value");
        self.close();
    }

    //PageUtil 관련 script - page처리시 반드시 써준다...
    function pageChange(page){
        document.form1.page.value = page;
        PageMove();
    }

    //PageUtil 관련 script - selectBox 사용시 - Option
    function selectPage(obj){
        val = obj[obj.selectedIndex].value;
        pageChange(val);
    }
    //-->
</script>


<form name="form1" method="post" onsubmit="return false">
    <input type="hidden" name="page"      value="">
    <input type="hidden" name="count"     value="<%= l_count   %>">
    <input type="hidden" name="GUEN_CODE" value="<%= GUEN_CODE %>">
    <input type="hidden" name="OBJPS_21"  value="<%= OBJPS_21  %>">
    <input type="hidden" name="REGNO"  value="<%= REGNO_21  %>">
    <input type="hidden" name="PERNR"  value="<%= PERNR  %>">


    <div class="listArea">
        <div class="listTop">
            <span class="listCnt"><%= pu == null ? "" : pu.pageInfo() %></span>
        </div>
        <div class="table">
            <table class="listTable">
                <tr>
                    <th width="30"><spring:message code="LABEL.E.E09.0004" /><!-- 선택 --></th>
                    <th width="70"><spring:message code="LABEL.E.E18.0017" /><!-- 구분 --></th>
                    <th width="90"><spring:message code="LABEL.E.E22.0014" /><!-- 신청일 --></th>
                    <th width="90"><spring:message code="LABEL.E.E18.0031" /><!-- 진료일 --></th>
                    <th class="lastCol" width="300"><spring:message code="LABEL.E.E17.0012" /><!-- 상병명 --></th>
                </tr>
                <%
                    if( E17LastSickData_vt != null && E17LastSickData_vt.size() > 0 ){
                        for( int i = pu.formRow() ; i < pu.toRow(); i++ ) {
                            E17SickData data = (E17SickData)E17LastSickData_vt.get(i);
                %>
                <tr align="center">
                    <td ><input type="radio" name="radiobutton" value="radiobutton" onClick="javascript:changeAppData('<%= i %>');"></td>
                    <td ><%= WebUtil.printOptionText((new E17GuenCodeRFC()).getGuenCode(PERNR).get("T_RESULT"), data.GUEN_CODE) %></td>
                    <td  style="text-align:center"><%= WebUtil.printDate(data.BEGDA) %></td>
                    <td  style="text-align:center"><%= WebUtil.printDate(data.EXAM_DATE) %></td>
                    <td class="lastCol" style="text-align:left"><%= data.SICK_NAME %></td>

                </tr>
                <%
                    }

                    for( int i = 0 ; i < E17LastSickData_vt.size(); i++ ) {
                        E17SickData data = (E17SickData)E17LastSickData_vt.get(i);
                %>
                <input type="hidden" name="GUEN_CODE<%= i %>"  value="<%= data.GUEN_CODE  %>">
                <input type="hidden" name="CTRL_NUMB<%= i %>"  value="<%= data.CTRL_NUMB  %>">
                <input type="hidden" name="SICK_NAME<%= i %>"  value="<%= data.SICK_NAME  %>">
                <input type="hidden" name="SICK_DESC1<%= i %>" value="<%= data.SICK_DESC1 %>">
                <input type="hidden" name="SICK_DESC2<%= i %>" value="<%= data.SICK_DESC2 %>">
                <input type="hidden" name="SICK_DESC3<%= i %>" value="<%= data.SICK_DESC3 %>">
                <input type="hidden" name="SICK_DESC4<%= i %>" value="<%= data.SICK_DESC4 %>">
                <input type="hidden" name="RCPT_NUMB<%= i %>"  value="<%= data.RCPT_NUMB  %>">
                <input type="hidden" name="OBJPS_21<%= i %>"   value="<%= data.OBJPS_21   %>">
                <input type="hidden" name="REGNO_21<%= i %>"   value="<%= data.REGNO_21   %>">
                <input type="hidden" name="DATUM_21<%= i %>"   value="<%= data.DATUM_21   %>">
                <input type="hidden" name="MAX_CHK<%= i %>"    value="<%= data.MAX_CHK    %>">
                <input type="hidden" name="LAST_CTRL<%= i %>"  value="<%= data.LAST_CTRL  %>">
                <%
                    }
                    } else {
                %>
                <tr>
                    <%-- 해당하는 데이타가 존재하지 않습니다. --%>
                    <td class="lastCol" colspan="5"><spring:message code="MSG.COMMON.0004" /></td>
                </tr>
                <%  } %>
            </table>
            <div class="align_center">
                <%= pu == null ? "" : pu.pageControl() %>
            </div>
        </div>
    </div>
</form>

<jsp:include page="/include/pop-body-footer.jsp"/>

<jsp:include page="/include/footer.jsp"/>

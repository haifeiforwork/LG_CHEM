<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                          */
/*   2Depth Name  : 부서근태                                                        */
/*   Program Name : 근무일정규칙 팝업                                               */
/*   Program ID   : D14WorkScheduleRulePopup|D14WorkScheduleRulePopup.jsp           */
/*   Description  : 근무일정규칙 팝업 화면                                            */
/*   Note         :                                                             */
/*   Creation     : 2009-03-25  김종서                                             */
/*   Update       : 2016-08-30 김승철                                                          */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D14PlanWorkTime.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%

    Vector scheduleRuleType_vt       = (Vector)request.getAttribute("scheduleRuleType_vt"); //일일근무일정 데이터
%>

<jsp:include page="/include/header.jsp"/>

<script language="JavaScript">
<!--


function handleError (err, url, line) {
       alert('<%=g.getMessage("MSG.D.D12.0018")%> : '+err + '\nURL : ' + url + '\n<%=g.getMessage("MSG.D.D12.0019")%> : '+line);
   return true;
}

function init(){
    var ob = document.createElement('<img src="<%= WebUtil.ImageURL %>btn_close.gif" name="image" align="absmiddle" border="0" style="cursor:hand;">');
    ob.onclick =  function() {
        var retVal = new Object();

        var idx = null;
        for(var i=0; i<<%=scheduleRuleType_vt.size()%>; i++){
            if(eval("document.form1.chk["+i+"].checked")){
                idx = i;
            }
        }

        if(idx == null){
            retVal = null;
        }else{
            retVal.SCHKZ = eval("document.form1.SCHKZ_"+idx+".value");
            retVal.RTEXT = eval("document.form1.RTEXT_"+idx+".value");
        }
        window.returnValue = retVal;
        window.close();
    };
    document.getElementById("closeButton").appendChild(ob);
}
function send(idx){
    var retVal = new Object();

    if(idx == null){
        retVal == null;
    }else{
        retVal.SCHKZ = eval("document.form1.SCHKZ_"+idx+".value");
        retVal.RTEXT = eval("document.form1.RTEXT_"+idx+".value");
    }
    window.returnValue = retVal;
    window.close();
}

-->
</script>

<body onLoad="init();">
<form name="form1" method="post" onsubmit="return false">
<div class="winPop">
  <div class="header">
    <span><spring:message code="LABEL.D.D14.0001"/></span> <!-- 근무일정 유형 -->
   
  </div>

  <div class="body">
      <div class="listArea">
        <div class="table">
          <table class="listTable" ">
            <tr>
              <th><spring:message code="LABEL.D.D12.0049"/></th><!-- 선택 -->
              <th><spring:message code="LABEL.D.D14.0001"/></th>       <!--근무일정규칙  -->
              <th><spring:message code="LABEL.D.D14.0005"/></th>  <!-- 근무일정규칙명 -->
              <th><spring:message code="LABEL.D.D14.0006"/></th> <!--  기간 근무 일정-->
              <th><spring:message code="LABEL.D.D15.0152"/></th>  <!-- 시작일 -->
              <th class="lastCol" width="70"><spring:message code="LABEL.D.D15.0153"/></th><!--종료일  -->
            </tr>
            <%
            for(int i=0; i<scheduleRuleType_vt.size(); i++){
              D14WorkScheduleRuleData data = (D14WorkScheduleRuleData)scheduleRuleType_vt.get(i);

                  String tr_class = "";

                  if(i%2 == 0){
                      tr_class="oddRow";
                  }else{
                      tr_class="";
                  }
                %>
                <tr class="<%=tr_class%>">
                  <input type="hidden" name="SCHKZ_<%=i%>" value="<%= data.SCHKZ %>">
                  <input type="hidden" name="RTEXT_<%=i%>" value="<%= data.RTEXT %>">
                  <td><input type="radio" name="chk" value="<%=i %>" onclick="send('<%=i %>');"></td>
                  <td><%= data.SCHKZ %></td>
                  <td><%= data.RTEXT %></td>
                  <td><%= data.ZMODN %></td>
                  <td><%= data.BEGDA %></td>
                  <td class="lastCol"><%= data.ENDDA %></td>
                </tr>
               <%} %>
              </table>
              </div>
            </div>
        </div>
    </div>

</form>
<iframe name="ifHidden" width="0" height="0" />
<!-------hidden------------>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
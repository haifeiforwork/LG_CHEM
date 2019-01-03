<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.B04Promotion.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector pyunga_vt = (Vector) request.getAttribute("Pyunga_vt");
    Vector pyungaScore_vt = (Vector) request.getAttribute("PyunggaScore_vt");
    B04PromotionCData data = (B04PromotionCData) request.getAttribute("B04PromotionCData");

    String sb = null;
    String sb1 = null;
    String sb2 = null;
    String sb3 = null;
    String sb4 = null;
    String sb5 = null;

    for (int i = 0; i < pyungaScore_vt.size(); i++) {
        B04PromotionBData pdata = (B04PromotionBData) pyungaScore_vt.get(i);
        if (i == 0) {
            sb = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
        } else if (i == 1) {
            sb1 = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
        } else if (i == 2) {
            sb2 = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
            sb5 = g.getMessage("MSG.B.B01.0009", pdata.EVAL_LEVL, WebUtil.printNum(pdata.EVAL_AMNT));  //"입사시 인정경력 기간중에는 개인평가 등급을"+pdata.EVAL_LEVL+"등급"+WebUtil.printNum(pdata.EVAL_AMNT)+"점 기준으로 진급누적점수 산정에 반영하였음.";


        } else if (i == 3) {
            sb3 = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
        } else if (i == 4) {
            sb4 = pdata.EVAL_LEVL + ":" + WebUtil.printNum(pdata.EVAL_AMNT);
        }
    }

%>
<jsp:include page="/include/header.jsp"/>
<script language="JavaScript">
    <!--
    function doSubmit() {
//  소문자로 입력했을경우 대문자로 변환
        var EVAL_LEVL = document.form1.EVAL_LEVL.value;
        document.form1.EVAL_LEVL.value = EVAL_LEVL.toUpperCase();
//  소문자로 입력했을경우 대문자로 변환

        var level = document.form1.EVAL_LEVL.value;
        var scpm = parseInt(document.form1.SCPM_AMNT.value);
        rowcount = document.form1.count.value;
        var temp_str = false;

        for (i = 0; i < rowcount; i++) {
            temp_level = eval("document.form1.EVAL_LEVL" + i + ".value");
            temp_amnt = eval("document.form1.EVAL_AMNT" + i + ".value");

            if (level == temp_level) {
                temp_str = true;
                document.form1.EVAL_AMNT.value = temp_amnt;
                document.form1.TOTAL_AMNT.value = scpm + parseInt(temp_amnt);
            }
        }

        if (level.length == 0) {
            return true;
        }

        if (temp_str == false) {
            alert("<%=g.getMessage("MSG.B.B01.0034") %>");  //정확한 등급을 넣어주세요.
            document.form1.EVAL_LEVL.select();
            return false;
        }

        total = document.form1.TOTAL_AMNT.value
        if (total >= eval("<%= data.E_GIJUN_AMNT %>")) {
            document.form1.TOTAL.value = "<%=g.getMessage("MSG.B.B01.0032") %>";   //어학기준 통과, 직급별 진급교육 이수 및 6sigma 인증을 받으셨다면 \n진급자격요건을 충족하셨습니다.
        } else if (total < eval("<%= data.E_GIJUN_AMNT %>")) {
            document.form1.TOTAL.value = "<%=g.getMessage("MSG.B.B01.0033") %>";//어학기준 통과, 직급별 진급교육 이수 및 6sigma 인증을 받으셨더라도 \n진급자격요건에 충족하지 못하셨습니다.
        }
    }
    $(function () {
        document.form1.EVAL_LEVL.focus();
    });
    //-->
</script>
<jsp:include page="/include/pop-body-header.jsp">
    <jsp:param name="title" value="MSG.B.B01.0035"/>
</jsp:include>

<h2 class="subtitle"><%=g.getMessage("MSG.B.B01.0003") %><%--평가등급--%></h2>
<form name="form1">

<!--??가등급 테이블 시작-->
<div class="listArea">
    <div class="table">


        <table border="0" cellspacing="0" cellpadding="2" class="listTable">
            <tr>
                <th><%=g.getMessage("MSG.B.B01.0012") %><%--평가년도--%></th>
                <th><%=g.getMessage("MSG.B.B01.0003") %><%--평가등급--%></th>
                <th class="lastCol"><%=g.getMessage("MSG.B.B01.0013") %><%--점수화--%></th>
            </tr>
            <%
                for (int i = 0; i < pyunga_vt.size(); i++) {
                    B04PromotionAData pyungadata = (B04PromotionAData) pyunga_vt.get(i);
            %>
            <tr>
                <td><%= pyungadata.PROM_YEAR %></td>
                <td><%= pyungadata.EVAL_LEVL %></td>
                <td><%= WebUtil.printNum(pyungadata.EVAL_AMNT) %></td>
            </tr>
            <%
                }
            %>
            <tr class="oddRow">
                <td>
                    <input type="text" name="PROM_YEAR" size="8" style="text-align:center"
                           value="<%= DataUtil.getCurrentYear()%>" readonly>
                </td>
                <td>
                    <input type="text" id="EVAL_LEVL" name="EVAL_LEVL" size="4" style="text-align:center" value=""
                           onKeyUp="javascript:doSubmit();">
                </td>
                <td class="lastCol">
                    <input type="text" name="EVAL_AMNT" size="4" style="text-align:center" value="" readonly>
                </td>
            </tr>
        </table>
    </div>
    <div class="btn_crud" style="margin-top:-10px;">
        <input type="text" name="TOTAL_AMNT" size="15" style="text-align:right" value="" readonly>
    </div>

</div>

<!--??가등급 테이블 끝-->

<div class="textDiv">
    <div class="commentImportant">
        <p><strong><%=g.getMessage("MSG.B.B01.0015") %><%--직급별 진급심의 대상선정 평가기준 점수--%></strong></p>
        <p>
            <input type="text" name="PROM_NAME" size="15" class="input02" value="<%= data.E_PROM_NAME %>" readonly>
            <input type="text" name="GIJUN_AMNT" size="6" class="input02" style="text-align:right"
                   value="<%= data.E_GIJUN_AMNT %>" readonly>
        </p>
        <p><strong><%=g.getMessage("MSG.B.B01.0017") %><%--점수화기준--%></strong></p>
        <p><input type="text" name="GIJUN" size="40" class="input02"
                  value="<%=sb4%>  <%=sb3%>  <%=sb2%>  <%=sb1%>  <%=sb%>" readonly></p>
    </div>
    <span class="inlineComment"><%= sb5 %></span>
</div>


<textarea id="TOTAL" name="body" scrollbars=no class="total" rows="2"
          style="width:100%; margin-bottom:20px; color:blue;scrollbar-face-color:#FFFFFF; scrollbar-highlight-color:#FFFFFF; scrollbar-shadow-color:#FFFFFF"></textarea>

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:javascript:self.close();"><span><%=g.getMessage("LABEL.COMMON.0002")%></span></a></li>
        </ul>
    </div>

<input type="hidden" name="SCPM_AMNT" value="<%= WebUtil.printNum(data.E_SCPM_AMNT) %>">
<input type="hidden" name="count" value="<%= pyungaScore_vt.size() %>">
<%
    for (int i = 0; i < pyungaScore_vt.size(); i++) {
        B04PromotionBData pydata = (B04PromotionBData) pyungaScore_vt.get(i);
%>
<input type="hidden" name="EVAL_LEVL<%= i%>" value="<%= pydata.EVAL_LEVL%>">
<input type="hidden" name="EVAL_AMNT<%= i%>" value="<%= WebUtil.printNum(pydata.EVAL_AMNT)%>">
<%
    }
%>
</form>


<jsp:include page="/include/pop-body-footer.jsp"/>
<jsp:include page="/include/footer.jsp"/>
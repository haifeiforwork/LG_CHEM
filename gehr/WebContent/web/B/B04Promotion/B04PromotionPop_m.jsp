<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.B04Promotion.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector pyunga_vt = (Vector)request.getAttribute("Pyunga_vt");
    Vector pyungaScore_vt = (Vector)request.getAttribute("PyunggaScore_vt");
    B04PromotionCData data = (B04PromotionCData)request.getAttribute("B04PromotionCData");

    String sb = null;
    String sb1 = null;
    String sb2 = null;
    String sb3 = null;
    String sb4 = null;
    String sb5 = null;

    for( int i = 0 ; i < pyungaScore_vt.size(); i++ ) {
            B04PromotionBData pdata = (B04PromotionBData)pyungaScore_vt.get(i);
        if( i==0){
            sb = pdata.EVAL_LEVL+":"+WebUtil.printNum(pdata.EVAL_AMNT);
        } else if(i==1){
            sb1 = pdata.EVAL_LEVL+":"+WebUtil.printNum(pdata.EVAL_AMNT);
        } else if(i==2){
            sb2 = pdata.EVAL_LEVL+":"+WebUtil.printNum(pdata.EVAL_AMNT);
            sb5 = "입사시 인정경력 기간중에는 개인평가 등급을"+pdata.EVAL_LEVL+"등급"+WebUtil.printNum(pdata.EVAL_AMNT)+"점 기준으로 진급누적점수 산정에 반영하였음.";
        } else if(i==3){
            sb3 = pdata.EVAL_LEVL+":"+WebUtil.printNum(pdata.EVAL_AMNT);
        } else if(i==4){
            sb4 = pdata.EVAL_LEVL+":"+WebUtil.printNum(pdata.EVAL_AMNT);
        }
    }

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<style type = "text/css">
.total {  border-width: 0 0 0 0  font-family: "굴림", "굴림체" font-size: 9pt ; color: #585858 ; font-weight: bold}
</style>

<script language="JavaScript">
<!--
function doSubmit(){
//  소문자로 입력했을경우 대문자로 변환
    var EVAL_LEVL = document.form1.EVAL_LEVL.value;
    document.form1.EVAL_LEVL.value = EVAL_LEVL.toUpperCase( );
//  소문자로 입력했을경우 대문자로 변환

    var level = document.form1.EVAL_LEVL.value;
    var scpm  = parseInt(document.form1.SCPM_AMNT.value);
    rowcount = document.form1.count.value;
    var temp_str =false;

    for(i=0;i<rowcount;i++){
        temp_level=eval("document.form1.EVAL_LEVL"+i+".value");
        temp_amnt =eval("document.form1.EVAL_AMNT"+i+".value");

        if(level == temp_level){
		        temp_str=true;
		        document.form1.EVAL_AMNT.value = temp_amnt;
            document.form1.TOTAL_AMNT.value= scpm + parseInt(temp_amnt);
        }
    }

    if(level.length == 0){
        return true;
    }

    if(temp_str==false){
		    alert("정확한 등급을 넣어주세요.");
        document.form1.EVAL_LEVL.select();
		    return false;
	  }

    total = document.form1.TOTAL_AMNT.value
    if(total>=eval("<%= data.E_GIJUN_AMNT %>")){
    		document.form1.TOTAL.value="어학기준 통과, 직급별 진급교육 이수 및 6sigma 인증을 받으셨다면 \n진급자격요건을 충족하셨습니다."
	  } else if(total<eval("<%= data.E_GIJUN_AMNT %>")){
    		document.form1.TOTAL.value="어학기준 통과, 직급별 진급교육 이수 및 6sigma 인증을 받으셨더라도 \n진급자격요건에 충족하지 못하셨습니다."
    }
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="document.form1.EVAL_LEVL.focus();">
<form name="form1">
  <table width="660" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td width="10">&nbsp;</td>
      <td class="font01" width="640">&nbsp;</td>
      <td class="font01" width="10">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td class="font01" align="center"><img src="<%= WebUtil.ImageURL %>img_simulation.gif" align="absmiddle"></td>
      <td class="font01">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td class="font01">&nbsp;</td>
      <td class="font01">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td class="font01" style="padding-bottom:2px"><img src="<%= WebUtil.ImageURL %>ehr/icon_o.gif">&nbsp;평가등급</td>
      <td class="font01">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp; </td>
      <td>
        <!--??가등급 테이블 시작-->
        <table width="640" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="tr01"> 
              <table width="620" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td> 
                    <table width="420" border="0" cellspacing="1" cellpadding="2" class="table02">
                      <tr> 
                        <td class="td03" width="140">평가년도</td>
                        <td class="td03" width="140">평가등급</td>
                        <td class="td03" width="140">점수화</td>
                      </tr>
<%
        for( int i = 0 ; i < pyunga_vt.size(); i++ ) {
            B04PromotionAData pyungadata = (B04PromotionAData)pyunga_vt.get(i);
%>
                      <tr>
                        <td class="td03"><%= pyungadata.PROM_YEAR %></td>
                        <td class="td04"><%= pyungadata.EVAL_LEVL %></td>
                        <td class="td04"><%= WebUtil.printNum(pyungadata.EVAL_AMNT) %></td>
                      </tr>
<%
    }
%>
                      <tr>
                        <td class="td03">
                          <input type="text" name="PROM_YEAR" size="8" class="input04" style="text-align:center" value="<%= DataUtil.getCurrentYear()%>" readonly>
                        </td>
                        <td class="td04">
                          <input type="text" name="EVAL_LEVL" size="4" class="input03" style="text-align:center" value="" onKeyUp="javascript:doSubmit();">
                        </td>
                        <td class="td04">
                          <input type="text" name="EVAL_AMNT" size="4" class="input04" style="text-align:center" value="" readonly>
                        </td>
                      </tr>
                    </table>
                  </td>
                  <td width="200" align="center" valign="bottom">
                    <input type="text" name="TOTAL_AMNT" size="15" class="input04" style="text-align:right" value="" readonly>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!--??가등급 테이블 끝-->
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="style01">&nbsp;</td>
      <td class="style01">&nbsp;</td>
      <td class="style01">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td class="style01">
        <ul>
          <li> 직급별 진급심의 대상선정 평가기준 점수<br>
            -
            <input type="text" name="PROM_NAME" size="15" class="input02" value="<%= data.E_PROM_NAME %>" readonly >
            <input type="text" name="GIJUN_AMNT" size="6" class="input02" style="text-align:right" value="<%= data.E_GIJUN_AMNT %>" readonly>
            점 이상<br>
            - 점수화기준<br>
            &nbsp;&nbsp;
            <input type="text" name="GIJUN" size="40" class="input02" value="<%=sb4%>  <%=sb3%>  <%=sb2%>  <%=sb1%>  <%=sb%>" readonly>
         </li>
       </ul>
      </td>
     </tr>
      <tr>
    <td width="15">&nbsp;</td>
    <td class="style01" ><%= sb5 %></td>
    </tr>
    <tr>
      <td class="style01">&nbsp;</td>
      <td class="style01">&nbsp;</td>
      <td class="style01">&nbsp;</td>
    </tr>
    <tr>
      <td class="style01">&nbsp;</td>
      <td class="font01" align="center">
        <textarea id="TOTAL" name="body" scrollbars=no class="total" rows="2" cols="70" style="color:blue;scrollbar-face-color:FFFFFF; scrollbar-highlight-color:FFFFFF; scrollbar-shadow-color:#FFFFFF"></textarea>
      </td>
      <td class="style01">&nbsp;</td>
    </tr>
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="5" colspan="3"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="style01">&nbsp;</td>
      <td class="style01" align="center">
        <a href="javascript:self.close()">
          <img src="<%= WebUtil.ImageURL %>btn_close.gif" align="absmiddle" border="0">
        </a>
      </td>
      <td class="style01">&nbsp;</td>
    </tr>
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="5" colspan="3"><img src="<%= WebUtil.ImageURL %>ehr/space.gif"></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
 <input type = "hidden" name="SCPM_AMNT" value="<%= WebUtil.printNum(data.E_SCPM_AMNT) %>">
 <input type = "hidden" name="count" value="<%= pyungaScore_vt.size() %>"> 
<%
for( int i = 0 ; i < pyungaScore_vt.size(); i++ ) {
     B04PromotionBData pydata = (B04PromotionBData)pyungaScore_vt.get(i);
%>
<input type = "hidden" name="EVAL_LEVL<%= i%>" value="<%= pydata.EVAL_LEVL%>"> 
<input type = "hidden" name="EVAL_AMNT<%= i%>" value="<%= WebUtil.printNum(pydata.EVAL_AMNT)%>"> 
<%
      }
%>
</form>
<%@ include file="/web/common/commonEnd.jsp" %>

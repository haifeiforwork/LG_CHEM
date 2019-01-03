<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.A10Annual.*" %>
<%@ page import="hris.A.A10Annual.rfc.*" %>

<%
	WebUserData user   = (WebUserData)session.getValue("user");
  	A10AnnualData data   = (A10AnnualData)request.getAttribute("a10AnnualData");

    String        ename  = user.ename;
    String        imgURL = (String)request.getAttribute("imgURL");
    double        tmpInt = Double.parseDouble( data.BETRG );

    tmpInt = tmpInt/20;
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= imgURL %>ess.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript"> 
function f_print() {
  self.print();
}
</SCRIPT> 
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="660" border="0" cellspacing="2" cellpadding="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="20">&nbsp;</td>
          <td><img src="<%= imgURL %>img_logo_mma.gif"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td align="center">
      <table width="450" border="0" cellspacing="2" cellpadding="0">
        <tr> 
          <td align="center"><font face="돋움, 돋움체" size="6"><b><u>年 俸 契 約 書</u></b></font></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td class="style01">
            <table width="400" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr> 
                <td class="style01">LG MMA(주)와 <%= ename %>은(는) 信義와 誠實을 바탕으로<br>
                  <%= data.BEGDA.substring(0,4) %>년 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>월 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>일부터 
                  <%= data.ENDDA.substring(0,4) %>년 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>월 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>일까지 <%= data.TITEL %> <%= ename %>의 年俸을<br>
                  다음과 같이 契約한다.</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td align="center"><font face="돋움, 돋움체" size="3">- 다 음 -</font></td>
        </tr>
        <tr> 
          <td> 
            <table width="300" border="1" cellspacing="0" cellpadding="5" align="center" bordercolor="#999999">
              <tr align="center"> 
                <td class="style01" width="138"><%= data.ZYEAR %>年 基本年俸</td>
                <td class="style01" width="137">基本年俸 月割分</td>
              </tr>
              <tr align="center"> 
                <td class="style01"><%= WebUtil.printNumFormat(data.BETRG) %></td>
                <td class="style01"><%= WebUtil.printNumFormat(tmpInt+"") %></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
              <tr> 
                <td width="10" class="style01">①</td>
                <td class="style01">상기 基本年俸은 <%= data.BEGDA.substring(0,4) %>年 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>月 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>日부터 <%= data.ENDDA.substring(0,4) %>年 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>月 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>日까지</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">③항의 약정된 지급일에 「基本年俸 月割分」으로 지급된다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">②</td>
                <td class="style01">基本年俸은 매월 시간외 근로 20시간을 포함한 금액이다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">③</td>
                <td class="style01">基本年俸 지급방법은 『基本年俸÷20』을 「基本年俸 月割分」으로</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">산정한 후, 매월 25일과 짝수월 25일, 설날, 추석에 「基本年俸 月割</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">分」을 각각 지급한다.</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">※ 중도입사자의 짝수월 25일, 설날, 추석에 지급되는 「基本年俸</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">&nbsp;&nbsp;&nbsp;&nbsp;月割分」에 대해서는 별도 기준에 따름.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">④</td>
                <td class="style01">기타 職責, 資格수당은 정해진 기준에 따라 지급한다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">⑤</td>
                <td class="style01">여사원이 月 1일 보건(생리)휴가 청구 시, 「基本年俸 月割分」의</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">「日割分(基本年俸 月割分/근태일수)」을 공제한다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">⑥</td>
                <td class="style01">경영목표달성에 따라 비정기적으로 지급되는 成果給은 별도로 정하며,</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">平均賃金에는 산입하지 않는다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td class="style01">⑦</td>
                <td class="style01">基本年俸을 제3자에게 이야기해서는 안된다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td class="style01">⑧</td>
                <td class="style01">기타사항은 就業規則과 勤勞基準法에 따른다.</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="230"><img src="<%= imgURL %>img_sign_mma.gif" width="230" height="82"></td>
                <td> 
                  <table width="100" border="0" cellspacing="0" cellpadding="0" align="right">
                    <tr> 
                      <td align="center" width="197" class="style01">LG MMA(주)<br>
                        <%= data.ORGTX %><br>
                        <%= ename %> (印)</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>

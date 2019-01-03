<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.A10Annual.*" %>
<%@ page import="hris.A.A10Annual.rfc.*" %>

<%
  	A10AnnualData data   = (A10AnnualData)request.getAttribute("a10AnnualData");
    WebUserData   user   = (WebUserData)session.getAttribute("user");
    
    String        ename  = user.ename;
    String        imgURL = (String)request.getAttribute("imgURL");
    double        tmpInt = Double.parseDouble( data.BETRG );
    
    tmpInt               = tmpInt/20;
%>
<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%= imgURL %>ess.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript"> 
            function f_print(){
                self.print();
                }
        </SCRIPT> 
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="624" border="0" cellspacing="2" cellpadding="0">
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td align="center">
      <table width="450" border="0" cellspacing="2" cellpadding="0">
        <tr> 
          <td align="center"><font face="굴림, 굴림체" size="5"><b><u>年 俸 契 約 書</u></b></font></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td class="style01"> 
            <table width="360" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr> 
                <td class="style01">LG석유화학(주)와 <%= ename %> 은(는) 信義와 誠實을 바탕으로<br>
                  <%= data.BEGDA.substring(0,4) %>년 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>월 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>일부터 
                  <%= data.ENDDA.substring(0,4) %>년 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>월 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>일까지 <%= data.TITEL %> <%= ename %>의<br>
                  年俸을 다음과 같이 契約한다.</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td align="center"><font face="굴림, 굴림체" size="2">- 다 음 -</font></td>
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
            <table width="397" border="0" cellspacing="0" cellpadding="2" align="center">
              <tr> 
                <td width="10" class="style01">①</td>
                <td class="style01">基本年俸은 계약기간동안 받을 개인별 계약금액으로 매월 시간외 </td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">근로 20시간을 포함한다.</td>
              </tr>
              <tr> 
                <td class="style01">②</td>
                <td class="style01">基本年俸 지급방법은 『基本年俸÷20』을 「基本年俸 月割分」으로</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">산정한 후, 매월 25일과 짝수월 말일,설날,추석에「基本年俸 月割分」</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">을 각각 지급한다.</td>
              </tr>
              <tr> 
                <td class="style01">③</td>
                <td class="style01">기타 職責,資格수당은 정해진 기준에 따라 지급한다.</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">(Ⅱ급 이상은 2001.09.01부로 직책수당 30,000원을 상기 기본연봉 
                  <br>
                  월분할에 추가하여 지급함)</td>
              </tr>
              <tr> 
                <td class="style01">④</td>
                <td class="style01">경영목표달성에 따라 비정기적으로 지급되는 成果給은 별도로 정하며,</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">平均賃金에는 산입하지 않는다.</td>
              </tr>
              <tr> 
                <td class="style01">⑤</td>
                <td class="style01">基本年俸을 제3자에게 이야기해서는 안된다.</td>
              </tr>
              <tr> 
                <td class="style01">⑥</td>
                <td class="style01">기타사항은 就業規則과 勤勞基準法에 따른다.</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="249"><img src="<%= imgURL %>img_sign_oil.gif" width="249" height="82"></td>
                <td> 
                  <table width="150" border="0" cellspacing="0" cellpadding="0" align="right">
                    <tr> 
                      <td align="center" width="197" class="style01">LG석유화학(주)<br>
                        <%= data.ORGTX %><br>
                        <%= ename %> (印)</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td align="center"><img src="<%= imgURL %>img_logo_oil.gif" width="240" height="51"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>

<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.A10Annual.*" %>
<%@ page import="hris.A.A10Annual.rfc.*" %>

<%
  	A10AnnualData data               = (A10AnnualData)request.getAttribute("a10AnnualData");
  	Vector        A10AnnualDetail_vt = (Vector)request.getAttribute("A10AnnualDetail_vt");
    WebUserData   user_m             = (WebUserData)session.getAttribute("user_m");

    String        ename              = user_m.ename;
    String        imgURL             = (String)request.getAttribute("imgURL");
%>
<!--- 석유화학 주요 계약서 -->
<html>
<head>
<title>ESS</title>
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
                  <%= data.ENDDA.substring(0,4) %>년 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>월 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>일까지 적용되는 <%= data.TITEL %> <%= ename %>의<br>
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
            <table width="430" border="1" cellspacing="0" cellpadding="5" align="center" bordercolor="#999999">
              <tr align="center"> 
                <td class="style01" width="135">기 간</td>
                <td class="style01" width="105">基本年俸 月割分</td>
                <td class="style01" width="100">基本年俸</td>
                <td class="style01" width="90">비 고</td>
              </tr>
<%
//  7월 1일자 보전금액이 없는 사원 -> 구조본 인원
    if( A10AnnualDetail_vt.size() == 1 ) {
        A10AnnualData dataDetail = (A10AnnualData)A10AnnualDetail_vt.get(0);
        double        tmpInt     = Double.parseDouble( dataDetail.BETRG );
        int           month      = 0;
        
        month  = 20;
        tmpInt = tmpInt/month;
%>
              <tr align="center">
                <td class="style01"><%= WebUtil.printDate(dataDetail.BEGDA,".") + "~" + WebUtil.printDate(dataDetail.ENDDA,".") %></td>
                <td class="style01"><%= WebUtil.printNumFormat(tmpInt+"") %></td>
                <td class="style01"><%= WebUtil.printNumFormat(dataDetail.BETRG) %></td>
                <td class="style01">月割分 X <%= month %></td>
              </tr>
<%
    } else {
        for( int i = 0 ; i < A10AnnualDetail_vt.size() ; i++ ) {
            A10AnnualData dataDetail = (A10AnnualData)A10AnnualDetail_vt.get(i);
            double        tmpInt     = Double.parseDouble( dataDetail.BETRG );
            int           month      = 0;
            
            if( dataDetail.BEGDA.equals("2004-03-01") ) {
                month  = 6;
                tmpInt = tmpInt/month;
            } else {
                month  = 14;
                tmpInt = tmpInt/month;
            }
%>
              <tr align="center">
                <td class="style01"><%= WebUtil.printDate(dataDetail.BEGDA,".") + "~" + WebUtil.printDate(dataDetail.ENDDA,".") %></td>
                <td class="style01"><%= WebUtil.printNumFormat(tmpInt+"") %></td>
                <td class="style01"><%= WebUtil.printNumFormat(dataDetail.BETRG) %></td>
                <td class="style01">月割分 X <%= month %></td>
              </tr>
<%
        }
    }
%>
              <tr align="center">
                <td class="style01" colspan="2">年俸 計</td>
                <td class="style01"><%= WebUtil.printNumFormat(data.BETRG) %></td>
                <td class="style01">&nbsp;</td>
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
                <td class="style01">상기 基本年俸 중 2004年7月1日부터 적용되는 基本年俸은</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">2004年 3月 1日부로 소급되지 아니한다.</td>
              </tr>
              <tr> 
                <td width="10" class="style01">②</td>
                <td class="style01">2004年7月1日부로 적용되는 基本年俸은『주 40시간제』적용에 따른</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">개인별 연월차 휴가 축소분 및 여사원에 限하여 보건(생리)휴가</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">보전분을 포함한다. 단, 여사원이 月 1일 보건(생리)휴가 청구 시,</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">「基本年俸 月割分」의「日割分(基本年俸 月割分 X 1/근태일수)」을</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">공제한다.</td>
              </tr>
              <tr> 
                <td width="10" class="style01">③</td>
                <td class="style01">基本年俸은 매월 시간외 근로 20시간을 포함한 금액이다.</td>
              </tr>
              <tr> 
                <td width="10" class="style01">④</td>
                <td class="style01">基本年俸 지급방법은 각 계약기간별「基本年俸 月割分」을</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">매월 25일과 짝수월 25일, 설날, 추석에 각각 지급한다.</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">(年俸Ⅰ: 6회, 年俸Ⅱ: 14회)</td>
              </tr>
              <tr> 
                <td width="10" class="style01">⑤</td>
                <td class="style01">기타 職責, 資格수당은 정해진 기준에 따라 지급한다.</td>
              </tr>
              <tr> 
                <td width="10" class="style01">⑥</td>
                <td class="style01">경영목표달성에 따라 비정기적으로 지급되는 成果給은 별도로 정하며,</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">平均賃金에는 산입하지 않는다.</td>
              </tr>
              <tr> 
                <td width="10" class="style01">⑦</td>
                <td class="style01">基本年俸을 제3자에게 이야기해서는 안된다.</td>
              </tr>
              <tr> 
                <td width="10" class="style01">⑧</td>
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
          <td align="center"><img src="<%= imgURL %>img_logo_oil.gif" width="190" height="51"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>

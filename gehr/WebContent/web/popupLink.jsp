<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : LG화학 popupLink                                            */
/*   Program Name : LG화학 popupLink                                            */
/*   Program ID   : popupLink.jsp                                               */
/*   Description  : LG화학 popupLink 로그인 후 창 띄움                          */
/*   Note         : 없음                                                        */
/*   Creation     :  2005-12-27  lsa C2005122601000000017                       */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="hris.common.*" %>
<%@ page import="java.security.SecureRandom" %>

<%
    WebUserData user = (WebUserData)session.getAttribute( "user" );
    String Gubn      = (String)request.getParameter("Gubn");

//  ① 사번, 주민번호 암호화
    //String empNo     = String.valueOf((Integer.parseInt(user.empNo)));
    String empNo     = user.empNo;
    String regno     = user.e_regno;
    String temp      = "";
    String random    = "";
    long   temp_L    = 0;
    int    sum       = 0;

//  ② 각 자리수의 합의 1의 자리 수를 ①의 뒤에 붙인다.
//--사번
    for(int i = 0 ; i < empNo.length() ; i++ ){
        sum = sum + Integer.parseInt( empNo.substring( i, i+1 ) );
    }
    temp = Integer.toString(sum);

    empNo = empNo + temp.substring( (temp.length()-1), temp.length() );

//--주민번호
    sum = 0;
    for(int i = 0 ; i < regno.length() ; i++ ){
        sum = sum + Integer.parseInt( regno.substring( i, i+1 ) );
    }
    temp = Integer.toString(sum);

    regno = regno + temp.substring( (temp.length()-1), temp.length() );

//  ③ 1~9까지의 랜덤한 수를 ②의 수 앞에 붙인다.
    SecureRandom num   = new SecureRandom();
    int    R_num = num.nextInt(9);             // 0부터 8까지의 난수 발생

    R_num  = R_num + 1;                         // 1부터 9까지의 난수 발생
    random = Integer.toString(R_num);

//--사번
    empNo = random + empNo;

//--주민번호
    regno = random + regno;

//  ④ 3의 수에 333을 곱한다.
//--사번
    temp_L = Long.parseLong(empNo);
    empNo  = Long.toString(temp_L * 333);

//--주민번호
    temp_L = Long.parseLong(regno);
    regno  = Long.toString(temp_L * 333);

//  ⑤ 각 자리수의 합의 1의 자리 수를 ④의 사번뒤에 붙인다.
//--사번
    sum = 0;
    for(int i = 0 ; i < empNo.length() ; i++ ){
        sum = sum + Integer.parseInt( empNo.substring( i, i+1 ) );
    }
    temp = Integer.toString(sum);

    empNo = empNo + temp.substring( (temp.length()-1), temp.length() );

//--주민번호
    sum = 0;
    for(int i = 0 ; i < regno.length() ; i++ ){
        sum = sum + Integer.parseInt( regno.substring( i, i+1 ) );
    }
    temp = Integer.toString(sum);

    regno = regno + temp.substring( (temp.length()-1), temp.length() );

//  ⑥ ③의 임의의 수를 ⑤의 수 앞에 붙인다.
//--사번
    empNo = random + empNo;

//--주민번호
    regno = random + regno;

Logger.debug.println(this, "######## empNo = " + empNo + " // regno = " + regno);
%>

<html>
<head>
<title>EHR</title>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form_w" method="post">
  <input type="hidden" name="p" value="<%= empNo %>">
  <input type="hidden" name="u" value="<%= regno %>">
  <input type="hidden" name="n" value="<%= user.ename %>">
</form>
<script language="JavaScript">
<!--

go_NewPop();

function go_NewPop() {
  width  = screen.width*8/10;
  height = screen.height*6/10;
  vleft  = screen.width*1/10;
  vtop   = screen.height*1/10;

  window.open("","NewPop","toolbar=0,location=no,directories=0,status=1,menubar=1,scrollbars=1,left="+vleft+",top="+vtop+",width="+width+" height="+height);
  if ( "<%=Gubn%>" == "ezwel")
      document.form_w.action="http://lgchem.ezwel.com";
  document.form_w.target="NewPop";
  document.form_w.submit();
}
//-->
</script>
</body>
</html>

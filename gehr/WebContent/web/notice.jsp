<%@ page contentType="text/html; charset=utf-8" %>  
   
<%@ page import="java.util.Vector" %>   
<%@ page import="hris.common.*" %>     
<%   
    String gubun    = request.getParameter("gubun"); 
		if (gubun.equals("backup")) {    
%>
<html>
	<head>
		<title>시스템 BackUp 안내</title>
	</head>
	<body>
<center>
<table border=0>
<tr><td>		
		<font face="Comic Sans MS" size=4>
		<blockquote>
		<center>
		<h1><font color=red size=2>시스템 BackUp 안내</font></h1>
		</center>
</td></tr>
<tr><td height=50>		<font size=-1 color=green>
		<p>시스템 정기 BackUp 작업을 위해 <br> 서버가동을       
중단할  예정이오니 업무에 참조하여 <br>주시기 바랍니다.    
</td></tr>
<tr  height=50><td><font size=-1>                       
.중단시간 : '매주 일요일 오후 20시(국내 기준) 이후 약 5시간
</td></tr>
                       
		</blockquote>
		</font>	
</table>	
</center>		
	</body>
</html>
<%  } else if (gubun.equals("0609")) { %>
<html>
	<head>
		<title>시스템 다운 안내</title>
	</head>
	<body>

<table border=0>
<tr><td>		
		<font face="Comic Sans MS" size=4>
		<blockquote>
		<center>
		<h1><font color=red size=2>[ 공지] 7월 19 ~ 20일 주말간 서비스 다운 안내</font></h1>
		</center>
</td></tr>
<tr><td height=50>		<font size=-1 color=blue>
		<p>&nbsp;&nbsp; WEB서버 이관 작업으로 인해 아래 시간 동안 시스템 사용이  <br>  &nbsp;&nbsp;&nbsp;&nbsp;불가능하오니 업무 참조 바랍니다. 
</td></tr>
<tr><td height=30></td></tr>
<tr><td><font size=-1>                       
- 작업 시간 : 7월19(土) 16:00 ~ 7월20일(日) 09:00 (한국시간 기준)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</td></tr>
          
		</blockquote>
		</font>	
</table>			
	</body>
</html>
<%  } else if (gubun.equals("E15General01")) { %>
<html>
	<head>
		<title>여수사업장 검진병원 안내</title>
	</head>
	<body>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr height=50></tr>
  <tr>
    <td width="30">&nbsp;</td>
    <td>
      <table width="758" border="0" cellspacing="1" cellpadding="0">
        <tr class="td09">
          <td><img src="E/E15General/e15Notice_02.jpg" border="0"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>     
	</body>
</html>
<%  } else { %>
<html>
	<head>
		<title>시스템 점검 안내</title>
	</head>
	<body>

<table border=0>
<tr><td>		
		<font face="Comic Sans MS" size=4>
		<blockquote>
		<center>
		<h1><font color=red size=2>시스템 점검 안내</font></h1>
		</center>
</td></tr>
<tr><td height=50>		<font size=-1 color=blue>
		<p>서버 위탁운영 및 N/W 서비스를 제공하고 있는 LG CNS의 4월 정기 <br>
		점검 작업에 따라 아래와 같이 HR Center(구 e-HR)의 서비스가 <br>중단되오니 全 임직원께서는 업무에 
참조하시기 바랍니다.    
</td></tr>
<tr><td><font size=-1>                       
1.작업 일시 : '06. 4. 15(土) AM 09:00 ~ 4. 16(日) AM 9:00, <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
총 24시간( 한국 시간 기준 )                                
</td></tr>
<tr><td><font size=-1>                       
2.작업 목적 :                                                                     
</td></tr>
<tr><td><font size=-1>                       
&nbsp;&nbsp;&nbsp;- 안정적인 IT 서비스 제공을 위한 장비 정기 점검,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;노후 장비 교체 및 Upgrade 작업 
                                                  
</td></tr>
          
		</blockquote>
		</font>	
</table>			
	</body>
</html>
<%  }  %>
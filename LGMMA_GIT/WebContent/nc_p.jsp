<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="common.NameCheck"%>
<jsp:useBean id="NC" class="common.NameCheck" scope="request"/>
<meta http-equiv='Content-Type' content='text/html;charset=utf-8'>
<%

String SITECODE = ""; 
String SITEPW = ""; 

//nc.jsp 에서 셋팅한 세션값을 확인한다. 
HttpSession s = request.getSession(true);
if(!s.getValue("NmChkSec").equals("98u9iuhuyg87"))
{
	// 인증이 안되는 경우 필요하신 사항으로 처리해주세요.
}

//s.invalidate();

//nc.jsp 에서 파라미터로 값을 전달받는다.
String sJumin1 = request.getParameter("jumin1");	
String sJumin2 = request.getParameter("jumin2");

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////내외국인 구분 /////////////////////////////////////////////////////////////////////////////

String alien = sJumin2.substring(0, 1);
  
if(alien.equals("1") || alien.equals("2") || alien.equals("3") || alien.equals("4")|| alien.equals("9")|| alien.equals("0")){
 
	//내국인 경우
	SITECODE = "BY01"; //NICE평가정보에서 부여받은 내국인 사이트코드를 수정한다.
	SITEPW = "74700234"; 	   //NICE평가정보에서 부여받은 내국인 사이트패스워드를 수정한다.

}else if (alien.equals("5") || alien.equals("6") || alien.equals("7") || alien.equals("8")){
	
	//외국인 경우
	SITECODE = "BY02"; //NICE평가정보에서 부여받은 외국인 사이트코드를 수정한다.
	SITEPW = "03711639"; 	   //NICE평가정보에서 부여받은 외국인 사이트패스워드를 수정한다.
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

String sJumin = sJumin1 + sJumin2;


//한글 인코딩 관련하여 넘겨주시는 이름이 깨질경우 아래를 참고해서 euc-kr 로 이름을 넘겨주세요
String sName = request.getParameter("name");
String sName1 = new String(request.getParameter("name").getBytes("8859_1"), "KSC5601");
System.out.println("######파라미터 : " +  sJumin + " // " + sName  + "/orig/" + sName1) ;



//주민번호와 이름 사이트아이디 패스워드의 값을 나이스평가정보에 넘겨주고 Rtn 에 리턴값을 받는다.
if((!sJumin.equals("")) && (!sName.equals("")))
{
	String Rtn = "";
	NC.setChkName(sName);				// 
	Rtn = NC.setJumin(sJumin+SITEPW);
		System.out.println("######### 리턴값 : " + Rtn);
	
	//정상처리인 경우
	if(Rtn.equals("0")) 
	{
		NC.setSiteCode(SITECODE);
		NC.setTimeOut(30000);
		Rtn = NC.getRtn().trim(); 
		
		
	}				
	
				
				//Rtn 변수값에 따라 아래 참고하셔서 처리해주세요.(결과값의 자세한 사항은 리턴코드.txt 파일을 참고해 주세요~)
								//Rtn :	1 이면 --> 실명인증 성공 : XXX.jsp 로 페이지 이동. 
								//			2 이면 --> 실명인증 실패 : 주민과 이름이 일치하지 않음. 사용자가 직접 www.namecheck.co.kr 로 접속하여 등록 or 1600-1522 콜센터로 접수요청.
								//									아래와 같이 나이스평가정보에서 제공한 자바스크립트 이용하셔도 됩니다.		
								//									정상적으로 등록된 사용자임에도 오류가 나오면 한글깨짐을 확인해 주세요. 
								//									한글은 euc-kr로 넘겨주셔야 합니다.
								//			3 이면 --> 나이스평가정보 해당자료 없음 : 사용자가 직접 www.namecheck.co.kr 로 접속하여 등록 or 1600-1522 콜센터로 접수요청.
								//									아래와 같이 나이스평가정보에서 제공한 자바스크립트 이용하셔도 됩니다.
								//			5 이면 --> 체크썸오류(주민번호생성규칙에 어긋난 경우: 임의로 생성한 값입니다.)
								//			50이면 --> NICE지키미의 명의도용차단 서비스 가입자임 : 직접 명의도용차단 해제 후 실명인증 재시도.
								//								아래와 같이 나이스평가정보에서 제공한 자바스크립트 이용하셔도 됩니다.
								//			그밖에 --> 30번대, 60번대 : 통신오류 ip: 203.234.219.72 port: 81~85(5개) 방화벽 관련 오픈등록해준다. 
								//								(결과값의 자세한 사항은 리턴코드.txt 파일을 참고해 주세요~) 

				
        if (Rtn.equals("1")){
       // out.println(Rtn);
%>
			<script language='javascript'>     
      	alert("인증성공");  
      	opener.RegNoSet( '<%=sJumin1%>', '<%=sJumin2%>'  );
      	window.close();
      	
      </script>

			<!--페이지 처리를 하실때에는 아래와같이 처리하셔도 됩니다. 이동할 페이지로 수정해서 사용하시면 됩니다. 
			<html>
				<head>
				</head>
				<body onLoad="document.form1.submit()">
					<form name="form1" method="post" action=XXX.jsp>
						<input type="hidden" name="jumin1" value="<%=sJumin1%>">
						<input type="hidden" name="jumin2" value="<%=sJumin2%>">
						<input type="hidden" name="name" value="<%=sName%>">
					</form>
				</body>
			</html>
			
			-->			
<%
		}else if (Rtn.equals("2")){
		//리턴값 2인 사용자의 경우, www.namecheck.co.kr 의 실명등록확인 또는 02-1600-1522 콜센터로 문의주시기 바랍니다.		
%>
            <script language="javascript">
               history.go(-1); 
               var URL ="https://www.namecheck.co.kr/front/personal/register_online.jsp?menu_num=1&page_num=0&page_num_1=0"; 
               var status = "toolbar=no,directories=no,scrollbars=yes,resizable=no,status=no,menubar=no, width= 1024, height=768, top=0,left=20"; 
               window.open(URL,"",status); 
            </script> 
<%
		}else if (Rtn.equals("3")){
		//리턴값 3인 사용자의 경우, www.namecheck.co.kr 의 실명등록확인 또는 02-1600-1522 콜센터로 문의주시기 바랍니다.   			
%>
            <script language="javascript">
               history.go(-1); 
               var URL ="https://www.namecheck.co.kr/front/personal/register_online.jsp?menu_num=1&page_num=0&page_num_1=0"; 
               var status = "toolbar=no,directories=no,scrollbars=yes,resizable=no,status=no,menubar=no, width= 1024, height= 768, top=0,left=20"; 
               window.open(URL,"",status); 
            </script> 
<%
		}else if (Rtn.equals("50")){
		//리턴값 50 명의도용차단 서비스 가입자의 경우, www.creditbank.co.kr 에서 명의도용차단해제 후 재시도 해주시면 됩니다. 
		// 또는 02-1600-1533 콜센터로문의주세요.  	
			
%>	
            <script language="javascript">
               history.go(-1); 
               var URL ="https://www.credit.co.kr/ib20/mnu/BZWPNSOUT01"; 
               var status = "toolbar=no,directories=no,scrollbars=yes,resizable=no,status=no,menubar=no, width= 1024, height= 768, top=0,left=20"; 
               window.open(URL,"",status); 
            </script> 

<%
		}else{
		//인증에 실패한 경우는 리턴코드.txt 를 참고하여 리턴값을 확인해 주세요~	
		/*
		 리턴코드 분류
		1 : 본인 맞음(주민번호와 이름이 일치하는 경우.)
2 : 본인 아님 
    (주민번호는 맞고 이름이 올바르지 않은경우.
     http://www.namecheck.co.kr/per_callcenter.asp로 이동하시게 하셔서 수정해 주시면 
     입력한 정보가 맞을경우 추후에 실명확인 이용가능하게 됩니다.)
3 : 자료 없음 
    (NICE평가정보에 입력한 데이타가 없는경우.
     http://www.namecheck.co.kr/per_callcenter.asp로 이동하시게 하셔서 입력해 주시면 
     입력한 정보가 맞을경우 추후에 실명확인 이용가능하게 됩니다.) 
4 : 시스템 장애.
    귀사의 네트워크장애일 경우도 발생하고,
    방화벽이 설치되어 있으실경우 저희쪽 서버 IP,Port를 등록해 주지 않으셨을 경우에도 발생합니다.
    네트워크 확인해 주시고 문의 주십시오.
5 : 주민번호 오류 (주민번호 체크 썸이 맞지 않은 경우.)
6 : 성인인증시 만19세 이하인 경우 실명인증 거치지 않고 바로 리턴코드 출력됩니다.
    (실명확인 서비스 신청시 서비스성격이 성인인증인 업체에만 해당됩니다.)
9 : send 된 데이타가 이상한 경우.( 주민번호, 사이트패스워드, 사이트아이디, 성명 중 한개의 데이타라도 빠지고 온 경우.)
10 : 사이트 코드 오류 ( nc_p.asp 에 입력하신 사이트 아이디의 대소문자를 확인해 주세요. 대문자로 입력하셔야 합니다.)
11 : 정지된 사이트 ( 저희쪽 계약 담당자에게 문의 주세요.)
12 : 해당사이트 비밀번호 오류 ( nc_p.asp 에 입력하신 사이트 패스워드를 확인해 주시기 바랍니다.)
13 : 사이트 인증 시스템 장애(개발자에게 연락주세요.)
15 : Decoding 오류(Data) 
16 : Decoding 시스템장애 

21 : 암호화 데이타 이상 ( 주민번호(13), 비밀번호(8) 자릿수를 확인해 주세요.)
24 : 암호화 연산중 에러 ( 올바르지 않은 주민번호인지 확인해 주세요.)
31 : 연결 장애 
    (실명확인 모듈을 설치한 서버의 브라우져에서 아래의 경로로 접속해 보시고 
     연결 안 되실 경우 개인 pc에서 해보시고 그래도 연결이 안될 경우는 문의 주십시오. 
     서버쪽에서만 안 될경우 서버 네트워크 확인 해주시고,
     방화벽이 설치되어 있을경우 저희쪽 실명확인 서버 IP(203.234.219.72),Port(81~85)를 등록해 주셔야 통신 가능합니다.)
     
     http://203.234.219.72:81/check.asp 
     http://203.234.219.72:82/check.asp
     http://203.234.219.72:83/check.asp 
     http://203.234.219.72:84/check.asp
     http://203.234.219.72:85/check.asp

     위의 아이피로 접속하셨을때 아이피와 디렉토리가 출력되면 네트워크는 정상입니다. 
	
32, 34, 44 : 몇번 해보시고 계속 발생할 경우 연락주세요.

50 : NICE지키미 명의도용 차단 요청 주민번호
     (실명확인 요청시 성명 일치/불일치에 관계없이 결과값으로 "50"을 리턴)

55~57 : 외국인 번호 확인 오류
58 : 출입국 관리소 통신 오류
60 ~ 63 : 네트워크 장애. 실명확인 서버 IP(203.234.219.72),Port(81~85) 확인 바랍니다.
		
		*/
		
%>
			<script language='javascript'>
				alert("인증에 실패 하였습니다.리턴코드:[<%=Rtn%>]");
				history.go(-1);
			</script>			
<%
		}
}else{
	out.println("성명이나 주민번호를 확인하세요.");
}
%>

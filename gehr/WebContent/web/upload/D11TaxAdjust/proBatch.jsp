<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 -->
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="hris.common.util.PdfUtil" %>
<%@ page import="hris.common.rfc.PdfParseRFC" %>
<%@ page import="hris.common.rfc.PdfFileNameRFC" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="hris.common.PdfParseData" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="com.sns.jdf.Logger" %>

<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.InputStreamReader"%>


<%
	request.setCharacterEncoding("UTF-8");
    String targetYear =  (String)application.getAttribute("targetYear");

	//up.jsp에서 넘겨받은 파일리스트
	ArrayList alist = (ArrayList)application.getAttribute(session.getId());
	//팝업메세지 처리
	String msg = "일괄 PDF업로드가 완료 되었습니다.";
	//화면에 나올 결과값
	String result = "";
	//처리결과코드
	String rtnCd = "";

	if(alist != null){

		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][6]);

		if(  alist.size() < 1 ){
			msg = "업로드할 파일이 존재하지 않습니다." ;
			result = "일괄 PDF업로드에 실패하였습니다.(업로드파일 0개)</br>";

		} else {
			// 최종 생성된 XML파일을 SAP에 전송 처리

			String sXML = "";
			String sEmplNo 		= "";
			String sNextEmplNo 	= "";
			String sMessage        = "";

			//************* 생성된 XML파일을 파일 개수만큼 attach 한다.
			for(int i=0;objarr!=null&&i<objarr.length;i++){
				sEmplNo 		= (String)objarr[i][4];			// 사번
				//
				sXML 			= (String)objarr[i][2];			// 본문
				sMessage	= (String)objarr[i][5];			// 메세지

				if(!PdfUtil.isStringDouble(sEmplNo)){
					msg = "기본 파일명이 아닙니다.";
					result = result + sMessage + "( 파일명 : " + (String)objarr[i][1] + " )</br>";
					continue;
				}

				if( StringUtil.isNull( sXML ) ){
					msg = "일부 일괄업로드 파일에 오류가 있습니다.";
					result = result + sMessage + "( 파일명 : " + (String)objarr[i][1] + " )</br>";
					continue;
				}

				if( !StringUtil.isNull( sMessage )){
					msg = "일부 일괄업로드 파일에 오류가 있습니다.";
					result = result + sMessage + "( 파일명 : " + (String)objarr[i][1] + " )</br>";
					continue;
				}

				//******** SAP 전송을 위해 File 데이타를 Line 별로 Vector 에 저장 ******************
				Vector xml_vt = new Vector();

				InputStream is = new ByteArrayInputStream( sXML.getBytes());
				BufferedReader br = new BufferedReader( new InputStreamReader(is));

				//[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
				//[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건
				String line = "";

				while((line = br.readLine()) != null ){
					PdfParseData xData = new PdfParseData();
					xData.XML_TEXT = line.trim();
					xml_vt.addElement(xData);
				}

				/* int MAX_SIZE=200000;
				char[] buffer = new char[MAX_SIZE];
				while(br.read(buffer,0,MAX_SIZE)>0){
					PdfParseData xData = new PdfParseData();
					xData.XML_TEXT = (String.valueOf(buffer)).trim();
					xml_vt.addElement(xData);
				} */

				//[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
				br.close();
				//****************************************************************************************

				//***********  SAP에 XML 데이타 전송( param : 사원번호, target년도, XML(Vector) )
				PdfParseRFC   pdfRfc	= new PdfParseRFC();	 									//연말정산 RFC 선언
				Vector 		result_vt 	= pdfRfc.build( sEmplNo, targetYear, xml_vt,  "all"); 		// RFC 호출( param :  사원번호, 작업년도, XML )


			}   // for end
			//*************************************************************

		}     // if end ( msg != null )

	}   // if end ( alist != null )

	if( StringUtil.isNull( result )){
		result = "일괄 PDF업로드 작업이 완료 되었습니다. SAP작업을 확인 하십시오.";
	}
	application.removeAttribute(session.getId());
	application.removeAttribute("msg");


%>

<html>
<head>
<script language="JavaScript">
	function sendMsg(){
		if("<%=msg%>"=="") return;
		alert("<%=msg%>");
		var doc = window.parent.document;
		doc.getElementById("resultTd").innerHTML = "<%=result%>";
		doc.body.style.cursor="auto";
	}
</script>
</head>
<body onload="sendMsg()">
</body>
</html>
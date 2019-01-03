<!-- [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 -->

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="hris.common.util.PdfUtil" %>
<%@ page import="hris.common.rfc.PdfParseRFC" %>
<%@ page import="hris.common.rfc.PdfFileNameRFC" %>
<%@ page import="hris.D.D11TaxAdjust.rfc.*" %>
<%@ page import="hris.common.PdfParseData" %>
<%@ page import="com.sns.jdf.ApLoggerWriter" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="com.sns.jdf.util.*" %>

<%@ page import="com.sns.jdf.Logger" %>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%

//System.out.println("sdfsdfsdflskdfj!!!");
    WebUserData user               = (WebUserData)session.getAttribute("user");


	//DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();
	String targetYear =  (String)application.getAttribute("targetYear");
	//String empNo =  (String)application.getAttribute("empNo");

	String empNo =  user.empNo;
	//저장디렉토리
	String savedir = PdfUtil.getURL("real", targetYear, empNo);  					// Real 파일 저장 디렉토리
	String tempdir = PdfUtil.getURL("temp", targetYear, empNo);					// Temp 파일 저장 디렉토리
	//파일저장시퀀스
	String seq = "";
	//up.jsp에서 넘겨받은 파일리스트
	ArrayList alist = (ArrayList)application.getAttribute(session.getId());
	//팝업메세지 처리
	String msg = (String)application.getAttribute("msg")==null?"":(String)application.getAttribute("msg");
	//화면에 나올 결과값
	String result = "";
	//처리결과코드
	String rtnCd = "";
	//세대주여부처리(특별공제건때문에 처리함)
	D11TaxAdjustHouseHoleCheckRFC   rfcHC   = new D11TaxAdjustHouseHoleCheckRFC();
	String begda = targetYear + "0101";
    String endda = targetYear + "1231";
    String E_HOLD =  rfcHC.getChk(  user.empNo, targetYear,begda,endda,""); //세대주체크여부
	String fstid = E_HOLD;
	if (fstid==null){
	    fstid ="";
	}
	// 백업 파일
	String sUploadFile = "";

	if( "비밀번호설정".equals(msg)){
		msg = "PDF 파일에 비밀번호가 설정 되었습니다. 비밀번호 설정없는 PDF파일을 다시 받아 업로드 하십시오.";
		result = msg;
	}else{
		msg = msg;
		result = msg;
	}
	//세대주여부메세지 화면에 나올 결과값
	String rtnHoldcd = "";
	String rtnHold = "";

	D11TaxAdjustHouseHoleCheckRFC rfcHS = new D11TaxAdjustHouseHoleCheckRFC();
	//System.out.println("empNo:"+empNo+"targetYear:"+targetYear+":"+targetYear+"0101"+":"+targetYear+"1231"+"fstid:"+fstid);
	rfcHS.build(empNo,targetYear,targetYear+"0101",targetYear+"1231", fstid);

	if(alist != null){
		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][4]);
		if(!"".equals(msg)){
				//파일자체오류
				for(int i=0;objarr!=null&&i<objarr.length;i++){
					//((File)objarr[i][0]).delete();//임시폴더에서 업로드 파일을 삭제함.
				}
				msg = "파일업로드오류 : " + msg;

		} else {
			//@2015  연말정산 web에서 파싱하지 않도록 XML 통째로 전달하는 방식으로 변경
			// 최종 생성된 XML파일을 SAP에 전송 처리

			String sXML = "";

			//************* 생성된 XML파일을 파일 개수만큼 attach 한다.( 파일 여러개를 업로드 했을 경우 )
			for(int i=0;objarr!=null&&i<objarr.length;i++){
				sXML = sXML + objarr[i][2];
				//System.out.println( "################### XML ##################");
				//System.out.println( sXML );
			}
			//*************************************************************


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
			Vector 		result_vt 	= pdfRfc.build( user.empNo, targetYear, xml_vt); 		// RFC 호출( param :  사원번호, 작업년도, XML )

			Logger.debug.println( "##### 연말정산 Result ###### " );
			// 전송 후 리턴
			if(result_vt!=null){
				if(result_vt.size()>0){
					// SAP 전송 데이타 오류 발생
					for(int j=0; j<result_vt.size();j++){
						PdfParseData oData = (PdfParseData)result_vt.get(j);
						Logger.debug.println("@@@@@@"+oData);
						//rtnCd = "-1";//@2015 연말정산, 일부 오류나도 실제 xml 데이터 올라가므로, 이력을 남길 수 있도록 -1(오류처리)하지 않음
						rtnCd=  "-1";//[CSR ID:3569665] 다시 오류 메시지 뜨도록 수정
						result = result+"("+oData.F_REGNO+"/"+oData.F_ENAME+") "+oData.MESSAGE+"<br>";
					    msg = "일부 데이터 반영 실패하였습니다. 처리결과 확인 후 다시 등록하세요";
					}
				}
			}    // if end
			//***********  SAP에 XML 데이타 전송( param : 사원번호, target년도, XML(Vector) )

			//***********  PDF BACKUP File 생성
			// SAP전송이 성공하였을 경우 서버 Real Path에 해당 File upload
			//msg = makeDir(savedir);
			if(!makeDir(savedir).equals("")){//[CSR ID:3569665] msg 가 ""로 리셋 되면 안되니까, 메시지가 있을 때만 엎어치게.
				msg = makeDir(savedir);
			}
			//------------- 기존에 존재하는 리얼대상파일 삭제
			File f = new File(savedir);
	           //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
            if( !f.getAbsolutePath().equals(f.getCanonicalPath())){
            	msg = "파일경로 및 파일명을 확인하십시오.";
            	return;
            }
          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
			String[] fnameList = f.list();
			int fCnt = fnameList.length;
			for(int fj = 0; fj < fCnt;fj++) {
				File sFile = new File(savedir+"/"+fnameList[fj]);
		           //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
	            if( !sFile.getAbsolutePath().equals(sFile.getCanonicalPath())){
	            	msg = "파일경로 및 파일명을 확인하십시오.";
	            	return;
	            }
	          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
				if(!sFile.isDirectory()){
					sFile.delete();
				}
			}

			//--------------  Backup 용 신규파일생성
			Vector fileV = new Vector();
			int fiCnt = 0;
			for( fiCnt=0;objarr!=null&&fiCnt<objarr.length;fiCnt++){
				// seq 채번 ( 001 ~ 000 )
				//seq = String.format( "%3s", String.valueOf(fiCnt) ).replace(' ', '0');
				//String filename = empNo + "_" + seq + ".pdf";
				String filename = empNo + "_" + objarr[fiCnt][1];
				File file = new File(savedir + "/" +  filename);
		      //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
	            if( !file.getAbsolutePath().equals(file.getCanonicalPath())){
	            	msg = "파일경로 및 파일명을 확인하십시오.";
	            	return;
	            }
	          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end

				//최종으로 저장폴더에 파일을 복사함.
				copyFileAbs((File)objarr[fiCnt][0],file);

				//파일명을 Vector에 넣음
				PdfParseData fData = new PdfParseData();
				fData.WORK_YEAR = targetYear;
				fData.PERNR = empNo;
				fData.SEQNR = String.valueOf(fiCnt);
				fData.FILE_NAME = filename;
				fileV.addElement(fData);
			}    // for end

			//*********************** SAP전송 Success 후 메세지 처리
			if("".equals(rtnCd)&&"".equals(msg)){
				// 백업한 파일 개수와 업로드 파일 개수가 같을 경우 - 모두 성공
				if( (fiCnt) == objarr.length ){
					msg   = "PDF 파일 업로드가 성공적으로 처리되었습니다.";
					result = msg + "<br/>";
					//---------- PDF 파일명 SAP에 저장
					PdfFileNameRFC filerfc = new PdfFileNameRFC();
					filerfc.build(empNo, targetYear, fileV);

				}else{
					msg = "PDF 파일 백업 중 오류가 발생하였습니다. 다시 등록 하십시오.";
					result = "[데이터반영성공]<br/>"+result +  "<br>"+rtnHold+"<br/>[파일업로드 실패]<br/>" + msg + "<br/>";
				}

			} else{
				result = "[데이터반영실패]<br/>"+result + rtnHold+"<br/>";
			}    // if end ( "".equals(rtnCd) )

			for( int fi=0;objarr!=null&&fi<objarr.length;fi++){
				//임시폴더에서 업로드 파일을 삭제함.
				//System.out.println( "#####  Delete File Path : " + tempdir + objarr[fi][1] );
				File delFile = new File( tempdir + "/" + objarr[fi][1] ) ;
			      //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
	            if( !delFile.getAbsolutePath().equals(delFile.getCanonicalPath())){
	            	msg = "파일경로 및 파일명을 확인하십시오.";
	            	return;
	            }
	          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
				delFile.delete();

				sUploadFile = sUploadFile + (fi+1) + " : " + objarr[fi][1] + "<br/>";
			}
			result = result + rtnHold+"<br/>[업로드 요청 파일 목록]<br/>" + sUploadFile;

		}// else end

		if("".equals(result)){
			result = msg;
		}
		//다른 폼변수들
		//out.println("src:"+ko(request.getParameter("src")));
		//out.println("</xmp>");

	}
	application.removeAttribute(session.getId());
	application.removeAttribute("msg");
%>
<%!
public String  makeDir(String savedir) throws Exception{
	String msg="";
	java.io.File dir=new java.io.File(savedir);
    //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
    if( !dir.getAbsolutePath().equals(dir.getCanonicalPath())){
    	msg = "파일경로 및 파일명을 확인하십시오.";
    	return msg;
    }
  //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
	if(!dir.exists()){	dir.mkdirs();	}
	return "";
}
public static String ko(String s){
	if(s==null)return "";
	try{
		s = new String(s.getBytes("8859_1"),"utf-8");
	}catch(Exception e){}
	return s;
}
public void copyFileAbs(java.io.File src, java.io.File dst) throws java.io.IOException {
	java.io.InputStream in = new java.io.FileInputStream(src);
	java.io.OutputStream out = new java.io.FileOutputStream(dst);

	byte[] buf = new byte[1024];
	int len;
	while ((len = in.read(buf)) > 0) {
		out.write(buf, 0, len);
	}
	in.close();
	out.close();
}
%>
<html>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
	function sendMsg(){
		if("<%=msg%>"=="") return;
		alert("<%=msg%>");
		var doc = window.parent.document;
		doc.getElementById("resultTd").innerHTML = "<%=result%>";

	}

	$(function() {
		 sendMsg();
	});
</script>

 <jsp:include page="/include/body-header.jsp"/>


<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
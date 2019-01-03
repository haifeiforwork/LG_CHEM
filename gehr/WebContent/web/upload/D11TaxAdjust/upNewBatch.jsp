<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,java.net.*"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="org.apache.commons.io.IOUtils"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.epapyrus.api.ExportCustomFile"%>
<%@ page import="com.dreamsecurity.exception.DVException"%>
<%@ page import="com.dreamsecurity.jcaos.util.encoders.Base64"%>
<%@ page import="com.dreamsecurity.verify.DSTSPDFSig"%>
<%@ page import="java.util.List"%>
<%@ page import="hris.common.util.PdfUtil"%>
<%@ page import="com.sns.jdf.*"%>
<%@ page import="com.sns.jdf.util.*"%>
<%@ page import="org.pdfbox.pdmodel.PDDocument"%>
<%
/*
2015.11.30  paperless
설  명 : 플래시로 부터 파일을 임시저장폴더에 저장합니다.
         플래시에서 폼값을 받을때 utf-8로 받아야 합니다.
*/
String msg 			= "";


try{
	String p_pwd 		= "";  // 비밀번호가 없을 경우 null
	String key 			= "XML";  //key
	String targetYear 	=  (String)application.getAttribute("targetYear");
	String empNo 		=  (String)application.getAttribute("empNo");
	String browser_id 	= request.getParameter("browser_id");
	String sMessage = "";


	// PDF 저장 디렉토리
	//String sourceDir = "D:/pdf";
	String sourceDir = "/sorc001/gehr/gehr.ear/gehrWeb.war/upload/" + targetYear;


	browser_id=session.getId();
	if(browser_id==null || browser_id.trim().length()==0){
		return;
	}

	//-PDF 저장 디렉토리에 등록된  기존 파일 Read
	File f = new File(sourceDir);
    // [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
    if( !f.getAbsolutePath().equals(f.getCanonicalPath())){
    	application.setAttribute("msg", "파일경로 및 파일명을 확인하십시오.");
    	return;
    }
    // [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
	File[] fileList = f.listFiles();

	//여러개의 파일이 첨부되므로 파일의 속성값을  Object[]에 담아서 ArrayList에 집어넣어준다.
	//application.setAttribute 하여 pro.jsp에 넘겨줌
	ArrayList alist = (ArrayList)application.getAttribute(browser_id);
	if(alist==null){
		alist = new ArrayList();
	}

	for(int i = 0 ; i < fileList.length ; i++){
		File oFile = fileList[i];
		File file = null;
		Object[] objarr = new Object[6];

		if(oFile.isFile()){  // 파일이 있다면 파일 이름 출력
			file = oFile;

			if(PdfUtil.isStringDouble(file.getName().substring(0, 8))){// temp 파일은 체크 안하도록.

				objarr = pdfTOxmlParsing( file, sourceDir);
				alist.add(objarr);	//ArrayList에 집어넣어준다.
			}

		}else if(oFile.isDirectory()){  // 서브 디렉토리가 있다면 다시 탐색
			subDirList(oFile.getCanonicalPath().toString(), alist);
		}

	}     // for end

	application.setAttribute(browser_id,alist);

}catch(Exception e){
	//Logger.debug.println(this, e);
	//application.setAttribute(browser_id,alist);

	return;
	//
}
%>
<%!//하위 폴더 읽기
	public void subDirList(String source, ArrayList alist) throws Exception {
		File dir = new File(source);
		File[] fileList = dir.listFiles();
		File returnFile = null;

		try {
			for (int i = 0; i < fileList.length; i++) {
				File file = fileList[i];
				Object[] objarr = new Object[6];

				if (file.isFile()) {
					// 파일이 파일 리턴

					if(PdfUtil.isStringDouble(file.getName().substring(0, 8))){// temp 파일은 체크 안하도록.


						objarr = pdfTOxmlParsing(file, source);
						alist.add(objarr); //ArrayList에 집어넣어준다.
					}

				} else if (file.isDirectory()) {
					// 서브디렉토리가 존재하면 재귀적 방법으로 다시 탐색
					subDirList(file.getCanonicalPath().toString(), alist);
				}
			}

		} catch (Exception e) {
			//

		}

	}

	// 비밀번호 설정 여부 체크 후 Exception 처리
	public String checkPasswordException(File file) throws Exception {

		PDDocument document = null;
		document = PDDocument.load(file);
		String sReturn = "";
		try {
			if (document.isEncrypted()) {
				//document.close();
				sReturn = "비밀번호가 설정된 파일입니다.";
				//throw new Exception("비밀번호가 설정되었습니다. 비밀번호 설정없는 PDF파일을 다시 받으십시오.");
			}
		} finally {
			document.close();
			return sReturn;
		}

	}

int upCnt = 0;
	//PFD => XML Parsing처리
	public Object[] pdfTOxmlParsing(File file, String sourceDir)
			throws Exception {
		String p_pwd = ""; // 비밀번호가 없을 경우 null
		String key = "XML"; //key
		String sMessage = "";
		Object[] objarr = new Object[6];

		if (file == null) { //파일저장에 실패
			sMessage = "파일 Read 실패";
		} else {

			String sEmplNo = file.getName().substring(0, 8); // 사원번호

			String originFileName = file.getName(); //저장요청한 파일명
			String saveFileName = file.getName(); //실제저장된 파일명
			String filePath = sourceDir + saveFileName;
			//Vector fileContents_vt = new Vector();

			//파일에 관련된 속성을 Object[]에 담아서 pro.jsp에 넘겨줌. 5=emplno
			objarr[0] = file;
			objarr[1] = originFileName; //업로드파일명
			objarr[2] = null; //파일내용을 XML화 한 string 테이타 ( 122 Line : 실제 SAP에 넘겨줄 값)
			objarr[3] = saveFileName; //저장파일명
			objarr[4] = sEmplNo; //사번
			objarr[5] = sMessage; //메세지

			// 파일내용을 읽음
			FileInputStream fisFile = null;
			byte[] pdfBytes = null;

			try {
				fisFile = new FileInputStream(file);
				pdfBytes = IOUtils.toByteArray(fisFile);

			} catch (Exception e) {
				sMessage = "Format 변환 중 오류가 발생하였습니다. PDF파일을 다시 받으십시오.";
			}

			try {
				sMessage = checkPasswordException(file);
			} catch (Exception e) {
				sMessage = "비밀번호가 설정된 파일입니다.";
			}

			boolean isSuccess = false;

			/* [Step1] 전자문서 위변조 검증 */
			try {
				DSTSPDFSig dstsPdfsig = new DSTSPDFSig();

				dstsPdfsig.init(pdfBytes);
				dstsPdfsig.tokenParse();

				isSuccess = dstsPdfsig.tokenVerify();

				if (isSuccess) {
					//application.setAttribute("msg", "진본성 검증 완료." );
				} else {
					sMessage = dstsPdfsig.getTstVerifyFailInfo();
				}

			} catch (DVException e) {
				sMessage = "진본성 파일 검증 중 오류가 발생하였습니다.";
			}

			/* [Step2] XML(or SAM) 데이터 추출 */
			try {
				if (isSuccess && StringUtil.isNull(sMessage)) {
					ExportCustomFile pdf = new ExportCustomFile();


					upCnt++;

					// 데이터 추출
					byte[] buf = pdf.NTS_GetFileBufEx(pdfBytes, p_pwd, key,
							false);
					int v_ret = pdf.NTS_GetLastError();

					// 정상적으로 추출된 데이터 활용하는 로직 구현 부분
					if (v_ret == 1) {
						// 이렇게 하니까 서버에서 한글 깨짐
						String strXml = new String(buf, "UTF-8");
						//String strXml = new String( buf );
						objarr[2] = strXml;//저장파일명
						//

					} else if (v_ret == 0) {
						sMessage = "연말정산간소화 표준 전자문서가 아닙니다.";

					} else if (v_ret == -1) {
						sMessage = "비밀번호가 틀립니다.";

					} else if (v_ret == -2) {
						sMessage = "PDF문서가 아니거나 손상된 문서입니다.";

					} else {
						sMessage = "데이터 추출에 실패하였습니다.";
					}
				}

			} catch (Exception e) {
				sMessage = "데이터 추출중 오류가 발생하였습니다.";
			}
		} // if end
		objarr[5] = sMessage;
		return objarr;
	}%>
<html>
<head>
<script language="JavaScript">
	function sendMsg() {
		var doc = window.parent.document;
		doc.getElementById("resultTd").innerHTML = "파일검증이 끝나고 SAP전송을 진행하고 있습니다..";

		doc.getElementById("form1").target = "hiddenFramePro";
		doc.getElementById("form1").action = "proBatch.jsp";
		doc.getElementById("form1").submit();
	}
</script>
</head>
<body onload="sendMsg()">
	<form name="form1" id="form1" method="post" action="proBatch.jsp">
	</form>
</body>
</html>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*,java.util.*,java.net.*" %>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="org.apache.commons.io.IOUtils"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.epapyrus.api.ExportCustomFile"%>
<%@ page import="com.dreamsecurity.exception.DVException"%>
<%@ page import="com.dreamsecurity.verify.DSTSPDFSig"%>
<%@ page import="java.util.List" %>
<%@ page import="hris.common.util.PdfUtil" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="org.pdfbox.pdmodel.PDDocument" %>
<%@ page import="org.apache.commons.codec.binary.Base64"%>



<%
/*
2015.11.30  paperless
설  명 : 플래시로 부터 파일을 임시저장폴더에 저장합니다.
         플래시에서 폼값을 받을때 utf-8로 받아야 합니다.
         @2015  연말정산  새로 작성
         2017-05-25 eunha [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치
*/

try{
	String p_pwd 		= "";  // 비밀번호가 없을 경우 null
	String key 			= "XML";  //key
	String msg 			= "";
	String targetYear 	=  (String)application.getAttribute("targetYear");
	String empNo 		=  (String)application.getAttribute("empNo");
	String browser_id 	= request.getParameter("browser_id");
	if(browser_id==null || browser_id.trim().length()==0){
		return;
	}

	//temp 저장 경로지정(일시저장하는 내용은 년도/사원번호/temp/로 함
	String savedir = PdfUtil.getURL("temp", targetYear, empNo);
	//디렉토리 생성
	makeDir(savedir);

	//파일 Upload
	MultipartRequest multi=new MultipartRequest(request, savedir,1024*1024*10, "utf-8", new DefaultFileRenamePolicy());
	File file = multi.getFile("Filedata");

	if(file==null) {	//파일저장에 실패
		application.setAttribute("msg", "파일첨부에 실패했습니다.");
		return;
	}

	String originFileName = multi.getOriginalFileName("Filedata");	//저장요청한 파일명
	String saveFileName   = multi.getFilesystemName("Filedata");		//실제저장된 파일명
	String filePath           = savedir+saveFileName;
	//Vector fileContents_vt = new Vector();

// 웹소스진단 조치 start
	File f = new File(savedir+ File.separator + originFileName);

    //보안진단 1차 개선
    if( !f.getAbsolutePath().equals(f.getCanonicalPath())){
    	application.setAttribute("msg", "파일경로 및 파일명을 확인하십시오.");
    	return;
    }
 // 웹소스진단 조치 end

	//여러개의 파일이 첨부되므로 파일의 속성값을  Object[]에 담아서 ArrayList에 집어넣어준다.
	//application.setAttribute 하여 pro.jsp에 넘겨줌
	ArrayList alist = (ArrayList)application.getAttribute(browser_id);
	if(alist==null){
		alist = new ArrayList();
	}

	//파일에 관련된 속성을 Object[]에 담아서 pro.jsp에 넘겨줌
	Object[] objarr = new Object[4];
	objarr[0] = file;
	objarr[1] = originFileName;	//업로드파일명
	objarr[2] = null;					//파일내용을 XML화 한 string 테이타 ( 122 Line : 실제 SAP에 넘겨줄 값)
	objarr[3] = saveFileName;		//저장파일명

	alist.add(objarr);	//ArrayList에 집어넣어준다.


	//--start--문서중앙화링크 파일 첨부 대응//
	long filesize = file.length();
	if(filesize==49){
		//--start--문서중앙화파일 첨부 시 파일 저장하지 않고 튕겨냄 추후 원본링크를 원하면 로직 삭제//
		//if(true){
		//	application.setAttribute("msg", "["+originFileName+"] 문서중앙화파일입니다. 원본파일을 전송하세요.");
		//	application.setAttribute(browser_id,alist);
		//	return;
		//}
		//--end--문서중앙화파일 첨부 시 파일 저장하지 않고 튕겨냄 추후 원본링크를 원하면 로직 삭제//

		//문서중앙화서버에 접속하여 원본파일 가져옴
		Config conf = new Configuration();
		StringBuffer edmsf = new StringBuffer(conf.get("com.sns.jdf.edms.filefath"));
		edmsf.append("file_id=");
		BufferedReader br = new BufferedReader(new FileReader(file));
		//BASE64Decoder decoder = new BASE64Decoder();
		String temp = "";
		while( (temp = br.readLine()) != null ) {
			//edmsf.append(new String(decoder.decodeBuffer(temp)));

			edmsf.append(new String(Base64.decodeBase64(temp.getBytes())));
		}
		edmsf.append("&limit_size=-1");	//파일 용량 제한 "-1"일 경우 제한 없음
		br.close();

		URL url = new URL(edmsf.toString());
		HttpURLConnection conn = (HttpURLConnection)url.openConnection();

		//--start--테스트용(Response Parameters 전체 찍기)//
		//Set set = conn.getHeaderFields().keySet();
		//for(int ss=0;ss<set.size();ss++){
	    //
		//}
		//--end--테스트용(Response Parameters 전체 찍기)//

		//문서중앙화서버에서 결과값 넘겨받음
		String result = conn.getHeaderField("result");	//success, fail
		if(!result.equals("success")){	//전송실패시
			application.setAttribute("msg", "["+originFileName+"] 문서중앙화파일전송에 실패했습니다.");
			application.setAttribute(browser_id,alist);
			Logger.debug.println(this, "[문서중앙화파일전송실패]" + conn.getHeaderField("result_message"));	//result=fail일 경우 에러 메시지 출력
    		return;
		}

		//성공하면 temp에 저장된 중앙화파일삭제
		file.delete();

		//문서중앙화서버에서 전송받은 원본파일저장
		BufferedInputStream bis = new BufferedInputStream(conn.getInputStream());
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(filePath));

        byte[] bbuf = new byte[1024000];
        int read=0;

        try {
             while ((read = bis.read(bbuf)) != -1)   {
                 bos.write(bbuf, 0, read);
             }
             bis.close();
             bos.close();
             //파일내용을 문서중앙화파일로 바꿔준다.
             file = new File(filePath);
           //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
             if( !file.getAbsolutePath().equals(file.getCanonicalPath())){
             	application.setAttribute("msg", "파일경로 및 파일명을 확인하십시오.");
             	return;
             }
           //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
        } catch (Exception e) {
            //e.printStackTrace();
            application.setAttribute("msg", "["+originFileName+"]문서중앙화파일전송에 실패했습니다.");
            application.setAttribute(browser_id,alist);
    		return;
        } finally {
            if (bis != null) {
                bis.close();
            }
            if (bos != null) {
                bos.close();
            }
        }
	}
	//--end--문서중앙화링크 파일 첨부 대응//

	// PDF파일이 아닌 경우 skip
	if (!originFileName.toUpperCase().endsWith(".PDF")) {
		application.setAttribute("msg", "PDF 파일이 아닙니다.");
		return;
	}

	// 파일내용을 읽음
	FileInputStream fisFile = null;
	byte[] pdfBytes         = null;

	try{
		fisFile = new FileInputStream(file);
	    pdfBytes = IOUtils.toByteArray(fisFile);

	}catch (Exception e) {
		application.setAttribute("msg", "Format 변환 중 오류가 발생하였습니다. PDF파일을 다시 받으십시오.");
		return;
	}

    try{
    	checkPasswordException( file );
    }catch(Exception e){
    	application.setAttribute("msg", "비밀번호설정");
		return;
    }

	boolean isSuccess = false;

	/* [Step1] 전자문서 위변조 검증 */
	try {
		DSTSPDFSig dstsPdfsig = new DSTSPDFSig();

		dstsPdfsig.init(pdfBytes);
		dstsPdfsig.tokenParse();

		isSuccess = dstsPdfsig.tokenVerify();

		if( isSuccess ) {
			//application.setAttribute("msg", "진본성 검증 완료." );
		} else {
			msg = dstsPdfsig.getTstVerifyFailInfo();
			application.setAttribute("msg", msg );
			return;
		}

	} catch (DVException e) {
		application.setAttribute("msg", "진본성 파일 검증 중 오류가 발생하였습니다." );
		return;
	}

	/* [Step2] XML(or SAM) 데이터 추출 */
	try {
		if (isSuccess) {
			ExportCustomFile pdf = new ExportCustomFile();

     		// 데이터 추출
			byte[] buf = pdf.NTS_GetFileBufEx(pdfBytes, p_pwd, key, false );
			int v_ret = pdf.NTS_GetLastError();

			// 정상적으로 추출된 데이터 활용하는 로직 구현 부분
			if (v_ret == 1) {
				// 이렇게 하니까 서버에서 한글 깨짐
				 String strXml = new String( buf, "UTF-8" );
				//String strXml = new String( buf );
				objarr[2]       = strXml;//저장파일명

			} else if (v_ret == 0) {
				application.setAttribute("msg", "["+originFileName+"] 연말정산간소화 표준 전자문서가 아닙니다." );
				return;
			} else if (v_ret == -1) {
				application.setAttribute("msg", "["+originFileName+"] 비밀번호가 틀립니다." );
				return;
			} else if (v_ret == -2) {
				application.setAttribute("msg", "["+originFileName+"] PDF문서가 아니거나 손상된 문서입니다." );
				return;
			} else {
				application.setAttribute("msg", "["+originFileName+"] " + PdfUtil.getParseMsg(v_ret));
				return;
			}
		}

	} catch (Exception e) {
		//out.println("[Step2] 데이터 추출 실패(" + e.toString() + ")");
		application.setAttribute("msg", "데이터 추출중 오류가 발생하였습니다." );
		return;
	}

	application.setAttribute(browser_id,alist);
	application.setAttribute("msg", msg);

}catch(Exception e){
	//Logger.debug.println(this, e);
	//application.setAttribute(browser_id,alist);

	return;
	//
}
%>
<%!
//폴더만들기
public void makeDir(String savedir) throws Exception{
	java.io.File dir=new java.io.File(savedir);
	if(!dir.exists()){	dir.mkdirs();	}
}

// 비밀번호 설정 여부 체크 후 Exception 처리
public void checkPasswordException(File file) throws Exception{

    	PDDocument document = null;
	    document = PDDocument.load(file);

	    try{
		    if(document.isEncrypted()){
		    	//document.close();

		    	throw new Exception("비밀번호가 설정되었습니다. 비밀번호 설정없는 PDF파일을 다시 받으십시오.");
		    }
	    }finally{
	    	document.close();
	    }

}
%>
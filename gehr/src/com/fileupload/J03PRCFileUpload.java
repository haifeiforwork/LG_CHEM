package com.fileupload;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
//import oracle.ec.common.Log;
//import com.fileupload.*;

import com.sns.jdf.Logger;

public class J03PRCFileUpload extends MultipartRequest{
	static final int MAX_POST_SIZE    = 1024 * 1024; // 1024kb --> 1M
	static final String server        = "165.244.234.69";                //   <===========server ip
	static final String user          = "oracle";                        //   <===========server userid
	static final String password      = "aug01" ;                        //   <===========p/w
	static final String savedirectory = "/user8/hris/j-image/prc_ppt/"; //   <==============저장하려는 directory
	static final String downdirectory = ".";

	public J03PRCFileUpload(ServletRequest request, String rename)throws IOException{
		this(request, MAX_POST_SIZE, rename);
	}

	public J03PRCFileUpload(ServletRequest request, int postsize, String rename) throws IOException {
		super(request, downdirectory, postsize, rename);
	}

	/**
	*	 readAndSaveFile Overriding
	*
	*	 여기선 단순히 ftp 모듈을 첨가하기 위해 재정의 했다.
	*	 readAndSaveFile은 일단 자신이 동작하는 디렉토리에
	*	 파일받고, 그것을 다시 ftp모듈로 전송한 다음, 해당
	*	 파일을 지워버린다.
	*	 이 동작을 개선하기 원한다면... filter Class를 제작하여
	*	 MultipartInputStreamHandler 를 필터하는 것을 권장한다.
	*/
	public void readAndSaveFile(MultipartInputStreamHandler in, String boundary, String filename) throws IOException{


		if(getRename() != null && !getRename().equals("") && !filename.equals("unknown")) filename = getRename() +'_' + filename;
		File f = new File(getDir() + File.separator + filename);

        //보안진단 1차 개선
        if( !f.getAbsolutePath().equals(f.getCanonicalPath())){
        	try {
        		throw new Exception("파일경로 및 파일명을 확인하십시오.");
        	} catch (Exception e) {
        		Logger.debug.println(e.getMessage());
        	}
        }

		FileOutputStream fos = new FileOutputStream(f);
		BufferedOutputStream out = new BufferedOutputStream(fos, 8 * 1024); // 8k

		byte[] bbuf = new byte[8 * 1024]; //8k
		int result;
		String line;

		// ServletInputStream.readLine()은 마지막 라인 끝에 \r\n을 추가한다.
		// 바이트 단위의 전송을 위해서는 이렇나 문자를 제거해야만 한다.
		boolean rnflag = false;

		while((result = in.readLine(bbuf, 0, bbuf.length)) != -1){
			// 경계를 체크한다.
			if(result > 2 && bbuf[0] == '-' && bbuf[1] == '-'){ // 빠른 예비체크
				line = new String(bbuf, 0, result, "ISO-8859-1");
				if(line.startsWith(boundary)) break;
			}
			// 마지막 반복을 위해 \r\n을 출력했다고 가정하는가?
			if(rnflag){
				out.write('\r');
				out.write('\n');
				rnflag = false;
			}
			// 버퍼를 출력하고, \r\n으로 끝나는 어떠한 종료도 연기한다.
			if(result >= 2 && bbuf[result - 2] == '\r' && bbuf[result - 1] == '\n'){
				out.write(bbuf, 0, result - 2);		// 마지막 2문자를 건너뛴다.
				rnflag = true;  // 다음 반목에 이들을 출력하기 위해 이를 알린다.
			}else{
				out.write(bbuf, 0, result);
			}
		}

		out.flush();
		out.close();
		fos.close();

		// ftp로 전송하자
		try{
			FtpClient ftp = new FtpClient(server, user, password);
			// 이동경로가 있을꺼얌...  // throws FtpException, IOException
			ftp.cd(savedirectory);
			// 모드는 바이너리로...
			FileInputStream is= new FileInputStream(f);
			ftp.setAscii(false);
			ftp.put(is, filename);
			is.close();
		}catch(FtpException fe){
			throw new IOException(fe.getMessage());
		}finally{
			f.delete();	// 반듯이 삭제하자.
		}
	}
}
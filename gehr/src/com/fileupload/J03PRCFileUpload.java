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
	static final String savedirectory = "/user8/hris/j-image/prc_ppt/"; //   <==============�����Ϸ��� directory
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
	*	 ���⼱ �ܼ��� ftp ����� ÷���ϱ� ���� ������ �ߴ�.
	*	 readAndSaveFile�� �ϴ� �ڽ��� �����ϴ� ���丮��
	*	 ���Ϲް�, �װ��� �ٽ� ftp���� ������ ����, �ش�
	*	 ������ ����������.
	*	 �� ������ �����ϱ� ���Ѵٸ�... filter Class�� �����Ͽ�
	*	 MultipartInputStreamHandler �� �����ϴ� ���� �����Ѵ�.
	*/
	public void readAndSaveFile(MultipartInputStreamHandler in, String boundary, String filename) throws IOException{


		if(getRename() != null && !getRename().equals("") && !filename.equals("unknown")) filename = getRename() +'_' + filename;
		File f = new File(getDir() + File.separator + filename);

        //�������� 1�� ����
        if( !f.getAbsolutePath().equals(f.getCanonicalPath())){
        	try {
        		throw new Exception("���ϰ�� �� ���ϸ��� Ȯ���Ͻʽÿ�.");
        	} catch (Exception e) {
        		Logger.debug.println(e.getMessage());
        	}
        }

		FileOutputStream fos = new FileOutputStream(f);
		BufferedOutputStream out = new BufferedOutputStream(fos, 8 * 1024); // 8k

		byte[] bbuf = new byte[8 * 1024]; //8k
		int result;
		String line;

		// ServletInputStream.readLine()�� ������ ���� ���� \r\n�� �߰��Ѵ�.
		// ����Ʈ ������ ������ ���ؼ��� �̷��� ���ڸ� �����ؾ߸� �Ѵ�.
		boolean rnflag = false;

		while((result = in.readLine(bbuf, 0, bbuf.length)) != -1){
			// ��踦 üũ�Ѵ�.
			if(result > 2 && bbuf[0] == '-' && bbuf[1] == '-'){ // ���� ����üũ
				line = new String(bbuf, 0, result, "ISO-8859-1");
				if(line.startsWith(boundary)) break;
			}
			// ������ �ݺ��� ���� \r\n�� ����ߴٰ� �����ϴ°�?
			if(rnflag){
				out.write('\r');
				out.write('\n');
				rnflag = false;
			}
			// ���۸� ����ϰ�, \r\n���� ������ ��� ���ᵵ �����Ѵ�.
			if(result >= 2 && bbuf[result - 2] == '\r' && bbuf[result - 1] == '\n'){
				out.write(bbuf, 0, result - 2);		// ������ 2���ڸ� �ǳʶڴ�.
				rnflag = true;  // ���� �ݸ� �̵��� ����ϱ� ���� �̸� �˸���.
			}else{
				out.write(bbuf, 0, result);
			}
		}

		out.flush();
		out.close();
		fos.close();

		// ftp�� ��������
		try{
			FtpClient ftp = new FtpClient(server, user, password);
			// �̵���ΰ� ��������...  // throws FtpException, IOException
			ftp.cd(savedirectory);
			// ���� ���̳ʸ���...
			FileInputStream is= new FileInputStream(f);
			ftp.setAscii(false);
			ftp.put(is, filename);
			is.close();
		}catch(FtpException fe){
			throw new IOException(fe.getMessage());
		}finally{
			f.delete();	// �ݵ��� ��������.
		}
	}
}
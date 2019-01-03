package com.fileupload;

import java.io.*;
import java.util.*;
import java.lang.Object.*;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
//import oracle.ec.common.Log;

import com.common.Utils;
import com.sns.jdf.Logger;

public class MultipartRequest{
	private static final int DEFAULT_MAX_POST_SIZE = 1024 * 1024; // 1MB
	private ServletRequest req;
	private File dir;
	private int maxSize;

	private Hashtable parameters = new Hashtable();
	private Hashtable files = new Hashtable();

	private String rename;

	public MultipartRequest(ServletRequest request, String saveDirectory) throws IOException {
		this(request, saveDirectory, DEFAULT_MAX_POST_SIZE, null);
	}
	public File getDir(){
		return dir;
	}
	public String getRename(){
		return rename;
	}

	public MultipartRequest(ServletRequest request, String saveDirectory, int maxPostSize, String rename) throws IOException{
		// ���� �Է� ���� üũ
		if(request == null)
			throw new IllegalArgumentException("request cannot be null");
		if(saveDirectory == null)
			throw new IllegalArgumentException("saveDirectory cannot be null");
		if(maxPostSize <= 0)
			throw new IllegalArgumentException("maxPostSize must be positive");
		this.rename = rename;

		// ��û, ���丮 �׸��� �ִ� ����� �����Ѵ�.
		req = request;
		dir = new File(saveDirectory);

		//�������� 1������
		if( ! dir.getAbsolutePath().equals(dir.getCanonicalPath())){
			try {
				throw new Exception("���ϰ�� �� ���ϸ��� Ȯ���Ͻʽÿ�.");
			} catch (Exception e) {
				Logger.debug.println(e.getMessage());
			}
		}
		maxSize = maxPostSize;

		// saveDirectory�� ��¥ ���丮������ ��ũ�Ѵ�.
		if(!dir.isDirectory())
			throw new IllegalArgumentException("Not a directory : " + saveDirectory);

		// saveDirectory�� �� �� �ִ����� ���θ� üũ �Ѵ�.
		if(!dir.canWrite())
			throw new IllegalArgumentException("Not writable : " + saveDirectory);
		// Parameter �� files�� �����͸� �����ϴ� ��û�� �Ľ��Ѵ�.
		// ���� �������� saveDirectory�� ����Ѵ�.
		readRequest();
	}

	public Enumeration getParameterNames(){
		return parameters.keys();
	}
	public Enumeration getFileNames(){
		return files.keys();
	}
	public String getParameter(String name){
		try{
			String param = (String) parameters.get(name);
			if(param.equals("")) return null;
			return param;
		}catch(Exception e){
			return null;
		}
	}
	public String getFilesystemName(String name){
		try{
			UploadedFile file = (UploadedFile) files.get(name);
			return file.getFilesystemName();	// null �� �� �ִ�.
		}catch(Exception e){
			return null;
		}
	}
	public String getContentType(String name){
		try{
			UploadedFile file = (UploadedFile)files.get(name);
			return file.getContentType();
		}catch(Exception e){
			return null;
		}
	}
	public File getFile(String name){
		try{
			UploadedFile file = (UploadedFile)files.get(name);
			return file.getFile();	// null �� �� �ִ�.
		}catch(Exception e){
			return null;
		}
	}
	protected void readRequest() throws IOException{
		// multipart/form-date ���� Ȯ���ϱ� ���� ������ Ÿ���� üũ�Ѵ�.
		String type = req.getContentType();
		if(type == null || !type.toLowerCase().startsWith("multipart/form-data")){
			throw new IOException("Posted content type isn't multipart/form-data");
		}

		// ���� ������ ���� ���� ������ ���̸� üũ�Ѵ�.
		int length = req.getContentLength();
		if(length > maxSize){
			throw new IOException("Posted content length of " + length + " exceeds limit of " + maxSize);
		}

		// ��� ��Ʈ���� ���Ѵ�. �̴� ������ Ÿ�� �ȿ� ���ԵǾ� �ִ�.
		// ------------------1201233613061 �� ���ƾ��Ѵ�.
		String boundary = extractBoundary(type);
		if(boundary == null){
			throw new IOException("Separation boundary was not specified");
		}

		// �о���� Ư���� �Է� ��Ʈ���� �����Ѵ�.
		MultipartInputStreamHandler in = new MultipartInputStreamHandler(req.getInputStream(), boundary, length);

		// ù��° ������ �д´�. �ݵ��, ù��° ����̾�� �Ѵ�.
		String line = in.readLine();
		if(line == null){
			throw new IOException("Corrupt form data : premature ending");
		}

		// ������ ������� ����
		if(!line.startsWith(boundary)){
			throw new IOException("Corrupt form data : no leading boundary");
		}

		// ���� ù���� ��踦 �����. ������ �κп� ���� ������ ����.
		boolean done = false;
		while(!done){
			done = readNextPart(in, boundary);
		}
	}

	protected boolean readNextPart(MultipartInputStreamHandler in, String boundary) throws IOException{
		// ù��° ������ �о���δ�. ������ ���ƾ� �Ѵ�.
		//content-dispossition: form-data; name="fiedl1"; filename="file1.txt"
		String line = in.readLine();
		if(line == null){
			// ��� �κе� ����. �̹� �����ߴ�.
			return true;
		}

		// conjtent-disposition ������ �Ľ��Ѵ�.
		String[] dispInfo = extractDispositionInfo(line);
		String disposition = dispInfo[0];
		String name = dispInfo[1];
		String filename = dispInfo[2];

		// ���� ������ ó���Ѵ�. �� ������ �����̰ų� Content-Type�� �����ϸ�, ���̾� ������ ������ ���̾�����.
		line = in.readLine();
		if(line == null){
			// ��� �κе� ����. �̹� ���� �ߴ�.
			return true;
		}

		// ������ Ÿ����  ��´�. Ȥ�� �ƹ��͵� ����Ǿ� ���� �ʴٸ� null�̴�.
		String contentType = extractContentType(line);
		if(contentType != null){
			// ���� ������ ó���ϳ�.
			line = in.readLine();
			if(line == null || line.length() > 0){ // ������ �����̾�� �Ѵ�.
				throw new IOException("Malformed line after content type : " + line);
			}
		}else{
			// ����Ʈ ������ Ÿ���� �����Ѵ�.
			contentType = "application/octet-stream";
		}

		// ���� ���������� �������� �о� ���δ�(��踦 ���� �� ����)
		if (filename == null){
			// �̰��� �Ķ����
			String value = readParameter(in, boundary);
			parameters.put(name, value);
		}else{
//    ���ϸ� �ҹ��� -> �빮�� ��ȯ
      filename = filename.toUpperCase();

			// �̰��� ����
			readAndSaveFile(in, boundary, filename);
			if(filename.equals("unknown")){
				files.put(name, new UploadedFile(null, null, null));
			}else{
				files.put(name, new UploadedFile(dir.toString(), filename, contentType));
			}
		}
		return false; // ���� ���� �� �ִ�.
	}

	protected String readParameter(MultipartInputStreamHandler in, String boundary) throws IOException{
		StringBuffer sbuf = new StringBuffer();
		String line;

		while((line = in.readLine()) != null){
			if(line.startsWith(boundary)) break;
			sbuf.append(line + "\r\n");
		}

		if(sbuf.length() == 0){
			return null;
		}

		sbuf.setLength(sbuf.length() - 2); // ������ ������ \r\n�� �߶󳽴�.
		return sbuf.toString();
	}

	public void readAndSaveFile(MultipartInputStreamHandler in, String boundary, String filename) throws IOException{
		File f = new File(dir + File.separator + filename);

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
	}

	private String extractBoundary(String line){
		int index = line.indexOf("boundary=");
		if(index == -1){
			return null;
		}
		String boundary = line.substring(index + 9); // 9 for "boundary="

		// �������� ���� �׻� �߰����� "--" �� ����ȴ�.
		boundary = "--" + boundary;

		return boundary;
	}

	private String[] extractDispositionInfo(String line) throws IOException{
		// ������ ����Ÿ�� �迭�μ� �����Ѵ�. - disposition, name, filename
		String[] retval = new String[3];

		// ������ \r\n �� ���� �ҹ��� ���ڿ��� ��ȯ�Ѵ�.
		// ���� �޽����� ���� �̸��� ���� ������ ������ �����Ѵ�.
		String origline = line;
		line = origline.toLowerCase();

		// ������ ������ ��´�. �ݵ�� "form-data" �̾�� �Ѵ�.
		int start = line.indexOf("content-disposition: ");
		int end = line.indexOf(";");
		if(start == -1 || end == -1){
			throw new IOException("Content disposition corrupt : " + origline);
		}
		String disposition = line.substring(start + 21, end);
		if(!disposition.equals("form-data")){
			throw new IOException("Invalid content disposition : " + disposition);
		}

		// �ʵ��� �̸��� ��´�.
		start = line.indexOf("name=\"", end);	// ������ �����ݷп��� ����
		end = line.indexOf("\"", start + 7);	// name=\'�� �ǳʶ�
		if(start == -1 || end == -1){
			throw new IOException("Content disposition corrupt : " + origline);
		}
		String name = origline.substring(start + 6, end);

		// �־����ٸ�, ���� �̸��� ��´�.
		String filename = null;
		start = line.indexOf("filename=\"", end + 2);	// name ������ ����
		end = line.indexOf("\"",start + 10);			// name=\" �� �ǳʶ�
		if(start != -1 && end != -1){
			//filename = origline.substring(start + 10, end);
                          filename = new String(origline.substring(start + 10, end).getBytes("8859_1"),"KSC5601");

			// filename�� ������ ��θ� ������ ���� �𸥴�. ���� ���ϸ��� ���Ұ�
			int slash = Math.max(filename.lastIndexOf('/'), filename.lastIndexOf('\\'));
			if(slash > -1){
				filename = filename.substring(slash + 1);	// ������ �����ø� ����ģ��.
			}
			if(filename.equals("")) filename = "unknown";	// filename ����üũ
		}

		// ��Ʈ�� �迭�� �����Ѵ�. - disposition, name, filename
		retval[0]	= disposition;
		retval[1] = name;
		retval[2] = filename;
		return retval;
	}

	private String extractContentType(String line) throws IOException{
		String contentType = null;

		// ������ �ҹ��� ��Ʈ������ ��ȯ�Ѵ�.
		String origline = line;
		line = origline.toLowerCase();

		// �����Ѵٸ�, ������ Ÿ���� ���Ѵ�.
		if(line.startsWith("content-type")){
			int start = line.indexOf(" ");
			if(start == -1){
				throw new IOException("Content type corrupt : " + origline);
			}
			contentType = line.substring(start + 1);
		}else if(line.length() != 0){	// ������ Ÿ���� ����. ���� �����̴�.
			throw new IOException("Malformed line after disposition : " + origline);
		}
		return contentType;
	}
}
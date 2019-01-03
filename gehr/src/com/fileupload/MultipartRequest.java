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
		// 값의 입력 여부 체크
		if(request == null)
			throw new IllegalArgumentException("request cannot be null");
		if(saveDirectory == null)
			throw new IllegalArgumentException("saveDirectory cannot be null");
		if(maxPostSize <= 0)
			throw new IllegalArgumentException("maxPostSize must be positive");
		this.rename = rename;

		// 요청, 디렉토리 그리고 최대 사이즈를 저장한다.
		req = request;
		dir = new File(saveDirectory);

		//보안진단 1차개선
		if( ! dir.getAbsolutePath().equals(dir.getCanonicalPath())){
			try {
				throw new Exception("파일경로 및 파일명을 확인하십시오.");
			} catch (Exception e) {
				Logger.debug.println(e.getMessage());
			}
		}
		maxSize = maxPostSize;

		// saveDirectory가 진짜 디렉토리인지를 테크한다.
		if(!dir.isDirectory())
			throw new IllegalArgumentException("Not a directory : " + saveDirectory);

		// saveDirectory에 쓸 수 있는지의 여부를 체크 한다.
		if(!dir.canWrite())
			throw new IllegalArgumentException("Not writable : " + saveDirectory);
		// Parameter 와 files에 데이터를 저장하는 요청을 파싱한다.
		// 파일 컨텐츠를 saveDirectory에 출력한다.
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
			return file.getFilesystemName();	// null 일 수 있다.
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
			return file.getFile();	// null 일 수 있다.
		}catch(Exception e){
			return null;
		}
	}
	protected void readRequest() throws IOException{
		// multipart/form-date 임을 확신하기 위해 컨텐츠 타입을 체크한다.
		String type = req.getContentType();
		if(type == null || !type.toLowerCase().startsWith("multipart/form-data")){
			throw new IOException("Posted content type isn't multipart/form-data");
		}

		// 서비스 공격을 막기 위해 컨텐츠 길이를 체크한다.
		int length = req.getContentLength();
		if(length > maxSize){
			throw new IOException("Posted content length of " + length + " exceeds limit of " + maxSize);
		}

		// 경계 스트링을 구한다. 이는 컨텐츠 타입 안에 포함되어 있다.
		// ------------------1201233613061 과 같아야한다.
		String boundary = extractBoundary(type);
		if(boundary == null){
			throw new IOException("Separation boundary was not specified");
		}

		// 읽어들일 특별한 입력 스트림을 생성한다.
		MultipartInputStreamHandler in = new MultipartInputStreamHandler(req.getInputStream(), boundary, length);

		// 첫번째 라인을 읽는다. 반드시, 첫번째 경계이어야 한다.
		String line = in.readLine();
		if(line == null){
			throw new IOException("Corrupt form data : premature ending");
		}

		// 라인이 경계인지 검증
		if(!line.startsWith(boundary)){
			throw new IOException("Corrupt form data : no leading boundary");
		}

		// 이제 첫번재 경계를 벗어났다. 각각의 부분에 대해 루프를 돈다.
		boolean done = false;
		while(!done){
			done = readNextPart(in, boundary);
		}
	}

	protected boolean readNextPart(MultipartInputStreamHandler in, String boundary) throws IOException{
		// 첫번째 라인을 읽어들인다. 다음과 같아야 한다.
		//content-dispossition: form-data; name="fiedl1"; filename="file1.txt"
		String line = in.readLine();
		if(line == null){
			// 어느 부분도 없다. 이미 수행했다.
			return true;
		}

		// conjtent-disposition 라인을 파싱한다.
		String[] dispInfo = extractDispositionInfo(line);
		String disposition = dispInfo[0];
		String name = dispInfo[1];
		String filename = dispInfo[2];

		// 다음 라인을 처리한다. 이 라인은 공백이거나 Content-Type을 포함하며, 뒤이어 공백의 라인이 뒤이어진다.
		line = in.readLine();
		if(line == null){
			// 어느 부분도 없다. 이미 수행 했다.
			return true;
		}

		// 컨텐츠 타입을  얻는다. 혹은 아무것도 기술되어 있지 않다면 null이다.
		String contentType = extractContentType(line);
		if(contentType != null){
			// 공백 라인을 처리하낟.
			line = in.readLine();
			if(line == null || line.length() > 0){ // 라인은 공백이어야 한다.
				throw new IOException("Malformed line after content type : " + line);
			}
		}else{
			// 디폴트 컨텐츠 타입을 가정한다.
			contentType = "application/octet-stream";
		}

		// 지금 마지막으로 컨텐츠를 읽어 들인다(경계를 읽은 후 종료)
		if (filename == null){
			// 이것은 파라미터
			String value = readParameter(in, boundary);
			parameters.put(name, value);
		}else{
//    파일명 소문자 -> 대문자 변환
      filename = filename.toUpperCase();

			// 이것은 파일
			readAndSaveFile(in, boundary, filename);
			if(filename.equals("unknown")){
				files.put(name, new UploadedFile(null, null, null));
			}else{
				files.put(name, new UploadedFile(dir.toString(), filename, contentType));
			}
		}
		return false; // 읽은 것이 더 있다.
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

		sbuf.setLength(sbuf.length() - 2); // 마지막 라인의 \r\n을 잘라낸다.
		return sbuf.toString();
	}

	public void readAndSaveFile(MultipartInputStreamHandler in, String boundary, String filename) throws IOException{
		File f = new File(dir + File.separator + filename);

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
	}

	private String extractBoundary(String line){
		int index = line.indexOf("boundary=");
		if(index == -1){
			return null;
		}
		String boundary = line.substring(index + 9); // 9 for "boundary="

		// 실제적인 경계는 항상 추가적인 "--" 가 선행된다.
		boundary = "--" + boundary;

		return boundary;
	}

	private String[] extractDispositionInfo(String line) throws IOException{
		// 라인의 테이타를 배열로서 리턴한다. - disposition, name, filename
		String[] retval = new String[3];

		// 라인을 \r\n 이 없는 소문자 문자열로 변환한다.
		// 오류 메시지와 변수 이름을 위해 원래의 라인을 유지한다.
		String origline = line;
		line = origline.toLowerCase();

		// 컨텐츠 성격을 얻는다. 반드시 "form-data" 이어야 한다.
		int start = line.indexOf("content-disposition: ");
		int end = line.indexOf(";");
		if(start == -1 || end == -1){
			throw new IOException("Content disposition corrupt : " + origline);
		}
		String disposition = line.substring(start + 21, end);
		if(!disposition.equals("form-data")){
			throw new IOException("Invalid content disposition : " + disposition);
		}

		// 필드의 이름을 얻는다.
		start = line.indexOf("name=\"", end);	// 마지막 세미콜론에서 시작
		end = line.indexOf("\"", start + 7);	// name=\'을 건너뜀
		if(start == -1 || end == -1){
			throw new IOException("Content disposition corrupt : " + origline);
		}
		String name = origline.substring(start + 6, end);

		// 주어졌다면, 파일 이름을 얻는다.
		String filename = null;
		start = line.indexOf("filename=\"", end + 2);	// name 다음에 시작
		end = line.indexOf("\"",start + 10);			// name=\" 을 건너뜀
		if(start != -1 && end != -1){
			//filename = origline.substring(start + 10, end);
                          filename = new String(origline.substring(start + 10, end).getBytes("8859_1"),"KSC5601");

			// filename이 완전한 경로를 포함할 지도 모른다. 단지 파일명만을 구할것
			int slash = Math.max(filename.lastIndexOf('/'), filename.lastIndexOf('\\'));
			if(slash > -1){
				filename = filename.substring(slash + 1);	// 마지막 슬래시를 지나친다.
			}
			if(filename.equals("")) filename = "unknown";	// filename 유무체크
		}

		// 스트링 배열을 리턴한다. - disposition, name, filename
		retval[0]	= disposition;
		retval[1] = name;
		retval[2] = filename;
		return retval;
	}

	private String extractContentType(String line) throws IOException{
		String contentType = null;

		// 라인을 소문자 스트링으로 변환한다.
		String origline = line;
		line = origline.toLowerCase();

		// 존재한다면, 컨텐츠 타입을 구한다.
		if(line.startsWith("content-type")){
			int start = line.indexOf(" ");
			if(start == -1){
				throw new IOException("Content type corrupt : " + origline);
			}
			contentType = line.substring(start + 1);
		}else if(line.length() != 0){	// 컨텐츠 타입이 없다. 따라서 공백이다.
			throw new IOException("Malformed line after disposition : " + origline);
		}
		return contentType;
	}
}
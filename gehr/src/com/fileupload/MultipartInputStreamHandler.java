package com.fileupload;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
//import oracle.ec.common.Log;


// ServletInputStream으로 부터 multipart/form-date를 읽어들이는데 도움을 주는 클래스로서
// 얼마나 많은 바이트를 읽어들였는 지에 대한 내용을 유지하며, Content-Length의 제약에
// 언제 도달했는지를 탐지한다. 이는 필수 적인데, 그 이유는 몇몇 서블릿 엔진이 스트림의 
// 끝에 다다른 것을 알려주는 데 있어 너무 느리기 때문이다.
public class MultipartInputStreamHandler{
	ServletInputStream in;
	String boundary;
	int totalExpected;
	int totalRead = 0;
	byte[] buf = new byte[8 * 1024]; // 8k
	
	public MultipartInputStreamHandler(ServletInputStream in, String boundary, int totalExpected){
		this.in = in;
		this.boundary = boundary;
		this.totalExpected = totalExpected;	
	}
	
	public String readLine() throws IOException{
		StringBuffer sbuf = new StringBuffer();
		int result;
		String line;
		
		do{
			result = this.readLine(buf, 0, buf.length);	// this.readLine()은 += 을 수행한다.
			if(result != -1){
				sbuf.append(new String(buf, 0, result, "ISO-8859-1"));	
			}
		}while(result == buf.length);	// 버퍼가 채워졌을 경우에만 반복수행
		
		if(sbuf.length() == 0){
			return null; // 읽을 것이 없으므로, 스트림의 끝 부분에 위치함에 틀림없다.	
		}
		
		sbuf.setLength(sbuf.length() -2);	// 끝 부분의 \r\n을 잘라낸다.
		return sbuf.toString();
	}
	
	public int readLine(byte b[], int off, int len) throws IOException{
		if(totalRead >= totalExpected){
			return -1;	
		}else{
			int result = in.readLine(b, off, len);
			if(result > 0){
				totalRead += result;	
			}
			return result;
		}
	}
}
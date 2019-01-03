package com.fileupload;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
//import oracle.ec.common.Log;


// ServletInputStream���� ���� multipart/form-date�� �о���̴µ� ������ �ִ� Ŭ�����μ�
// �󸶳� ���� ����Ʈ�� �о�鿴�� ���� ���� ������ �����ϸ�, Content-Length�� ���࿡
// ���� �����ߴ����� Ž���Ѵ�. �̴� �ʼ� ���ε�, �� ������ ��� ���� ������ ��Ʈ���� 
// ���� �ٴٸ� ���� �˷��ִ� �� �־� �ʹ� ������ �����̴�.
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
			result = this.readLine(buf, 0, buf.length);	// this.readLine()�� += �� �����Ѵ�.
			if(result != -1){
				sbuf.append(new String(buf, 0, result, "ISO-8859-1"));	
			}
		}while(result == buf.length);	// ���۰� ä������ ��쿡�� �ݺ�����
		
		if(sbuf.length() == 0){
			return null; // ���� ���� �����Ƿ�, ��Ʈ���� �� �κп� ��ġ�Կ� Ʋ������.	
		}
		
		sbuf.setLength(sbuf.length() -2);	// �� �κ��� \r\n�� �߶󳽴�.
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
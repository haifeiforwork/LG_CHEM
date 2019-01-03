package com.sns.jdf.security;

public class Encoder
{

	public static String Chang (String str)
	{
		byte []  by = str.getBytes() ;

		SEncoder enc = new SEncoder();
		String encStr = enc.encode(by);
		return encStr ;
	
	}
	
}
package com.sns.jdf.security;

public class Decoder
{

	public static String Chang (String str)
	
	{
		String str0 = str+"=";
		String str1 = "";
		SDecoder dec = new SDecoder();
		byte []  by = dec.decodeBuffer(str);
		str1 = new String (by) ;
		return str1 ;
	}
	
}
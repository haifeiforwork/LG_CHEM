package com.sns.jdf.security;

public class SEncoder 
{
	public String encode(byte[] raw) 
	{
		return MakeSecurity.encode(raw);
	}
	
}
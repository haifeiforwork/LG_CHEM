package com.sns.jdf.security;

public class SDecoder 
{
  public byte[] decodeBuffer(String base64) 
  {
    return MakeSecurity.decode(base64);
  }
}
package com.lgcns;

//import com.sns.jdf.GeneralException;

import com.sns.jdf.Logger;

public class Crypto {
//	private native int _crypt(String alg, byte src[], byte dst[]);
	private native String crypt(String alg, String src);
 	public String Encrypt(String src)  
	{
		Logger.debug("Crypto==> Encrypt Strart ");
		String ret = crypt("KEY_CH2/3DES_E/BASE64_E",src);
		Logger.debug("Crypto==> Encrypt End ");
		return ret;
	}

	public String Decrypt(String src)
	{
		Logger.debug("Crypto==> Decrypt Strart ");
		String ret = crypt("KEY_CH2/BASE64_D/3DES_D",src);
		Logger.debug("Crypto==> Decrypt End ");
		return ret;
	}
	static {
		Logger.debug("CnsEncJni==> loadLibrary  Strart ");
		System.loadLibrary("CnsEncJni");
		Logger.debug("CnsEncJni==> loadLibrary  End ");
		
	}
}


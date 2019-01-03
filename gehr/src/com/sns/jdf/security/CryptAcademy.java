package com.sns.jdf.security; 
import com.lgcns.Crypto;
import com.sns.jdf.GeneralException;

/*import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.WebUtil;
*/
public class CryptAcademy {

	public static String Encrypt (String str) throws GeneralException 
	{
	       try{
	    	   
		Crypto cr =new Crypto(); 

		return cr.Encrypt(str) ;
	       } catch(Exception e) {
	           throw new GeneralException(e);
	       }	 
	}
	
	public static String Decrypt (String str)
	{
		Crypto cr =new Crypto();
		
		return cr.Decrypt(str) ;
	
	}
	
/*	public static void main(String[] args) 
	{
	
		CryptAcademy cra = new CryptAcademy();

		String bbbb;
		
		Logger.debug("abcdefg");
		Logger.debug(cra.Encrypt( "abcdefg"));
		
		bbbb = cra.Encrypt( "12345");
		Logger.debug(bbbb);
		
		Logger.debug(cra.Decrypt("CLJz0H1pnXsCr95nAlvZUf86GcZJrUYR7oYnntfwuUk="));

	} */
}
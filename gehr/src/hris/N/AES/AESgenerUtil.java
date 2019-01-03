package hris.N.AES;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.WebUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class AESgenerUtil {   
	private Log LOG = LogFactory.getLog(this.getClass());
	/**     * @param args     */    
	public static void main(String[] args) {       
		// TODO Auto-generated method stub
		AESgenerUtil cu = new AESgenerUtil();       
		String key = cu.getKey();
		Logger.debug("key: " + key);
		key = "sshr092606230055";
		String text = "93333";
		String encryptText = null;        
		String decryptText = null;
		
		try {           
			encryptText = cu.encryptAES(text, key);           
			decryptText = cu.decryptAES(encryptText, key);        
		} catch (Exception e) {            
			Logger.error(e);
		}        
		Logger.debug("encryptText: " + encryptText);
		Logger.debug("beforeText : " + text);
		Logger.debug("decryptText: " + decryptText);        // 2011051813190051        // abcdefgh01234567
	}     // key는 16바이트로 구성 되어야 한다.   
	
	
	public static String getKey(){
		Calendar cal = Calendar.getInstance();        
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssss");
		String key = sdf.format(cal.getTime());
		Logger.debug("key: " + key);
		return key;
	}

	public static String encryptAES(String s, HttpServletRequest reqest) throws GeneralException {
		return encryptAES(s, WebUtil.getEncryptKey(reqest));
	}

	public static String decryptAES(String s, HttpServletRequest reqest) throws GeneralException {
		return decryptAES(s, WebUtil.getEncryptKey(reqest));
	}

	public static String encryptAES(String s)  {
		try {
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
			return encryptAES(s, request);
		} catch(Exception e) {
			Logger.error(e);
		}
		return s;
	}

	public static String decryptAES(String s)  {
		try {
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
			return decryptAES(s, request);
		} catch(Exception e) {
			Logger.error(e);
		}
		return s;
	}

	public static String encryptAES(String s, String key) throws GeneralException {
		String encrypted = null;        
		try {            
			SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes(), "AES"); 
			Cipher cipher = Cipher.getInstance("AES");   
			cipher.init(Cipher.ENCRYPT_MODE, skeySpec);  
			encrypted = byteArrayToHex(cipher.doFinal(s.getBytes()));
			return encrypted;        
		} catch (Exception e) {
			Logger.error(e);
			throw new GeneralException(e);
		}    
	}         // key는 16 바이트로 구성 되어야 한다.
	
	public static String decryptAES(String s, String key) throws GeneralException  {
		String decrypted = null;        
		try {            
			SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes(), "AES"); 
			Cipher cipher = Cipher.getInstance("AES");  
			cipher.init(Cipher.DECRYPT_MODE, skeySpec);
			decrypted = new String(cipher.doFinal(hexToByteArray(s)));
			Logger.debug("복호화 작업 : " + decrypted);
			return decrypted;        	
		} catch (Exception e) {            
			Logger.error(e);
            throw new GeneralException(e);
		}
	} 
	
	private static byte[] hexToByteArray(String s) {
		byte[] retValue = null;        
		if (s != null && s.length() != 0) {  
			retValue = new byte[s.length() / 2]; 
			for (int i = 0; i < retValue.length; i++) {
				retValue[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2), 16);  
			}
		}
		return retValue;    
	}
	
	private static String byteArrayToHex(byte buf[]) {
		StringBuffer strbuf = new StringBuffer(buf.length * 2);
		for (int i = 0; i < buf.length; i++) {
			if (((int) buf[i] & 0xff) < 0x10) {
				strbuf.append("0");            
			}  
			strbuf.append(Long.toString((int) buf[i] & 0xff, 16));        
		}  
		return strbuf.toString();  
	}
	

}
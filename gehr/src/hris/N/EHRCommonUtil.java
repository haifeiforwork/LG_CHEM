package hris.N;

import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DateTime;
import hris.N.AES.AESgener;

import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;



public final class  EHRCommonUtil {
	/**
	 * 2015-05-28 marco257
	 * Long Text처리
	 * 넘어온 BOX 값의 특정 필드값 sTextFieldName을 splitSize만큼 잘라서 Vector에 insert후 return 한다.
	 * @param boxData
	 * @param sTextFieldName
	 * @param splitSize
	 * @return
	 * @throws Exception
	 * [CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 eunha  2017-06-22
	 */
	 public static Vector LongTextSplit(Box boxData, String sTextFieldName, int splitSize) throws Exception {
		    HashMap<String, Object> vResult = new  HashMap<String, Object>();
		    Vector splitvt = new Vector();
	        try{
	            	String line = boxData.getString(sTextFieldName);
	            	//Logger.debug("data LINE : "+ line);
	            	if(!line.equals("")){
		                Vector vSplitString = splitAsSize(line, splitSize);
		                int size = vSplitString.size();
		                if(size > 0){
		                	for(int k = 0 ;k < size ; k++){
		                		 HashMap<String, Object> reR = (HashMap)vResult.clone();
		                		//Logger.debug("split data : "+vSplitString.get(k));
		                		reR.put(sTextFieldName, vSplitString.get(k));
		                		splitvt.add(reR);
		                	}
		                }
	            	}

	        } catch(Exception e) {
	            throw new Exception(e);
	        }
	        return splitvt;
	    }

	     public static Vector splitAsSize(String sTarget, int nSplitSize) {
	         Vector vResult = new Vector();
	         int nTextSize = sTarget.length();
	         int nLoop = (int) Math.ceil((float) nTextSize / nSplitSize);

	         for(int n = 0; n < nLoop ; n++) {
	             int nStart = n * nSplitSize;

	             if(n == nLoop - 1)
	                 vResult.add(sTarget.substring(nStart));
	             else
	                 vResult.add(sTarget.substring(nStart, nStart + nSplitSize));
	         }

	         return vResult;
	     }

	     /**
	      * 숫자 String값으로 넘어온 값을 Interger로 변환후 다시 String으로 변환
	      * 008 -> 8
	      * @param sInt
	      * @return
	      */

	     public static String reIntString(String sInt){
	    	String reS = "";
	   //[CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 start
	   // 연차가 비어있는경우  0 으로 나오는 문제 조치
	    	//if(sInt == null || sInt.equals("")){
	    	if(sInt == null || sInt.equals("")|| sInt.equals("000")){
	   //[CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 start
	    		reS ="";
	    	}else{
	    		int tInt = Integer.parseInt(sInt);
	    		reS = tInt+"";
	    	}
	    	return reS;

	     }

	     public static String setAESencrypt(String pernr) throws Exception{
	    	AESgener ae = new AESgener();
	    	String stime=DateTime.getFormatString("HHmmss");
			Logger.debug(stime);
	        byte[] plain = (stime+pernr).getBytes("UTF-8");
	        Logger.debug( "(" + plain.length + ")" + "원문 : " + AESgener.toHexString( plain ) );
	        byte[] encrypt = ae.encrypt( plain );
	        Logger.debug( "암호화 : "+new String( encrypt ,"UTF-8") );
	        return new String( encrypt ,"UTF-8");
	     }


	     public static String getAESencrypt(String src) throws Exception{
		    	AESgener ae = new AESgener();

				byte[] decrypt = ae.decrypt( ae.hex2byte(src) );
		        Logger.debug( "복호화 : "+new String( decrypt ,"UTF-8") );
		        return new String( decrypt ,"UTF-8");
		  }

	     public static String nullToEmpty(String arg){
	         String retValue;
	         if (arg == null || arg.trim().equals("")) {
	             retValue = "";
	         } else {
	              retValue = arg.trim();
	         }
	         return retValue;
	     }

	     /**
	      * .5 -> 0.5
	      * @param str
	      * @return
	      */
	     public static String dotCheck(String str){

	          if( str == null ){
	        	  str = "0";
	          }else{
		          if(str.startsWith(".")){
		        	str ="0"+str;
		          }
	          }
	          return str;
	     }

	     /**
	      * 메일에서 넘어오는 데이터를 분리함
	      * OT^menuCode=1184^year=2006^month=09";
	      * menuCode=1184
	      * year=2006
	      * month=09
	      * @param urlParam
	      * @return
	      */
	     public static HashMap dataConvert(String urlParam){
	    	HashMap<String, String> ldField = new HashMap<String, String>();

          	StringTokenizer st = new StringTokenizer(urlParam,"^");
          	while(st.hasMoreTokens()){
	  			String test = st.nextToken();
	  			Logger.debug("test: "+test);
	  			int cheq = test.indexOf("=");
	  			if(cheq != -1){
	      			String sName =test.substring(0,cheq);
	      			String sValue =test.substring(cheq+1);
	      			Logger.debug("year: "+sName);
	      			Logger.debug("sValue: "+sValue);
	      			ldField.put(sName, sValue);
	  			}

          	}


	    	return ldField;

	     }



	     public static void main(String args[] ) throws Exception{

	    	 	String aes = setAESencrypt("00003412");
				Logger.debug(aes);
				Logger.debug(dotCheck("0.03"));
				String returnUrl = "OT^menuCode=1184^year=2006^month=09";

				HashMap valueHM= EHRCommonUtil.dataConvert(returnUrl);
				Logger.debug(valueHM);
				String menuCode = (String)valueHM.get("menuCode");
          		String sYear    = (String)valueHM.get("year");
          		String sMonth = (String)valueHM.get("month");

          		Logger.debug(menuCode);
          		Logger.debug(sYear);
          		Logger.debug(sMonth);







		}
}
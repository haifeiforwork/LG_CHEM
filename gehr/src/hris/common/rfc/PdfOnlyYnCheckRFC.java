package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * PdfOnlyYnCheckRFC.java
 * 오직 pdf 만을 upload 한건지 아닌건지 여부에 대한 값을 가져오는 RFC를 호출하는 Class(@2014 연말정산 소득공제신고서에 추가된 항목)
 *
 * @author 이지은   
 * @version 1.0, 2014/12/18
 *
 */
public class PdfOnlyYnCheckRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_NON_PDF";

    public String getOnlyPdfYN( String webUserId, String targetYear ) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, webUserId, targetYear);

            excute(mConnection, function);
            return getOutput(function);

        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
 

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     * 
     */
    private void setInput(JCO.Function function, String webUserId, String targetYear) throws GeneralException{
        String fieldName = "I_PERNR";
        setField(function, fieldName, webUserId);
		String fieldName2 = "I_YEAR";
        setField(function, fieldName2, targetYear);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        //String fieldName = "E_FLAG";      // RFC Export 구성요소 참조
        //return getField(fieldName, function);
    	String fieldName = "E_CHK";

		String E_CHK    = getField(fieldName,    function);  // Y.N 
        return E_CHK;
    	
    }
}


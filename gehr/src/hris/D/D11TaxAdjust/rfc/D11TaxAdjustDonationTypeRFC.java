package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*; 

/**
 * D11TaxAdjustDonationTypeRFC.java
 * 기부금유형명을 가져오는 RFC를 호출하는 Class
 *
 * @author LSA
 * @version 1.0, 2005/11/23
 */
public class D11TaxAdjustDonationTypeRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_YEAR_DONATION_PE";
 
    /**
     * 기부금유형명을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDonationType(String targetYear, String Pernr  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function,  targetYear,Pernr );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            
            return ret;
        } catch(Exception ex){
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
     */
    private void setInput(JCO.Function function, String targetYear, String Pernr ) throws GeneralException {
 
        String fieldName1 = "I_YEAR";
        setField( function, fieldName1, targetYear ); 
        String fieldName2 = "I_PERNR";  //C20121213_34842
        setField( function, fieldName2, Pernr ); 
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "RESULT";
        return getCodeVector(function, tableName);
    }
}
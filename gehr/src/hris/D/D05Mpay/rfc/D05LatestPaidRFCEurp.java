package	hris.D.D05Mpay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D05LatestPaidRFCEurp.java
 * 가장최근 급여내역 정보를 가져오는 RFC를 호출하는 Class[유럽용]
 *
 * @author yji
 * @version 1.0, 2010/08/04
 */
public class D05LatestPaidRFCEurp extends SAPWrap {

    private String functionName = "ZGHR_RFC_PAID_YEAR";

    /**
     * 가장최근 급여내역 정보를 가져오는 RFC를 호출하는 Method
     * 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLatestPaid1(String empNo) throws GeneralException {
        JCO.Client mConnection = null;
        
        Vector vt = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, empNo);
            excute(mConnection, function);
            vt = getOutput4(function);
            
            return  vt;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public String getLatestPaid2(String empNo) throws GeneralException {
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo);
            excute(mConnection, function);
            
            String E_ZOCRSN = null;
                        
            E_ZOCRSN = getOutput2(function);  
                        
            return E_ZOCRSN;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
 // 5월 21일 순번 추가    
    public String getLatestPaid3(String empNo) throws GeneralException {
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo);
            excute(mConnection, function);
            
            String E_SEQNR = null;
                        
            E_SEQNR = getOutput3(function);  
                        
            return E_SEQNR;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }   
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, value);
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput4(JCO.Function function) throws GeneralException {

        String entityName = "hris.D.D05Mpay.D05MpayDetailData6Eurp";
        String tableName  = "T_YEAR";
        
        return getTable(entityName, function, tableName);
    }
    
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput1(JCO.Function function) throws GeneralException {
        String fieldName = "T_YEAR";      // 급여결과에 대한 지급일
        return getField(fieldName, function);
    }
    
    private String getOutput2(JCO.Function function) throws GeneralException {
        String fieldName = "E_ZOCRSN";      // 급여사유  
        return getField(fieldName, function);
    }
 // 5월 21일 순번 추가    
    private String getOutput3(JCO.Function function) throws GeneralException {
        String fieldName = "E_SEQNR";      // 순번   
        return getField(fieldName, function);
    }
}
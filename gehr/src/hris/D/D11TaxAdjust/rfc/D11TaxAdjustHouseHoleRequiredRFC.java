package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustHouseHoleRequiredRFC.java
 * 연말정산 -공제유형별 세대주체크용 조회 RFC를 호출하는 Class
 *
 * @author lsa    2010/12/09   
 */
public class D11TaxAdjustHouseHoleRequiredRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_HOUSEHOLE_REQUIRED" ;

    /**
     * 연말정산 - 연금구분/유형 조회 RFC 호출하는 Method 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getHouseHole(  String GubnCode , String GojeCode,String Begda, String GubnCode2 , String GojeCode2   ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function,  GubnCode, GojeCode ,Begda ,  GubnCode2, GojeCode2);
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
    public String getReqH(    String GubnCode , String GojeCode,String Begda, String GubnCode2 , String GojeCode2   ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function,  GubnCode, GojeCode ,Begda,GubnCode2 ,GojeCode2);
            excute(mConnection, function);

            
            String E_REQ_H    = getField("E_REQ_H",    function);  // 세대주 여부
            return E_REQ_H;

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
    private void setInput(JCO.Function function,  String GubnCode , String GojeCode,String Begda, String GubnCode2 , String GojeCode2) throws GeneralException {
        String fieldName1 = "I_GUBN_CODE";
        setField( function, fieldName1, GubnCode );
        String fieldName2 = "I_GOJE_CODE";
        setField( function, fieldName2, GojeCode );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3,Begda );  
        String fieldName4 = "I_GUBN_CODE2";
        setField( function, fieldName4,GubnCode2 );  
        String fieldName5 = "I_GOJE_CODE2";
        setField( function, fieldName5,GojeCode2 );  
    }
 
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();    	
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustHouseHoleCheckData";
        String tableName  = "T_DATA";

        Vector T_DATA =getTable(entityName, function, tableName);
        ret.addElement(T_DATA);
        
        String E_REQ_H    = getField("E_REQ_H",    function);  // 세대주 여부
        
        ret.addElement(E_REQ_H);
        
        return ret;
        
    }
}

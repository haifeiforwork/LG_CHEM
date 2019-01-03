package hris.A.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A20EmergencyContactsData;

import java.util.Vector;

/**
 * A20EmergencyContactsRFC.java
 * 비상연락망 정보를 가져오는 RFC를 호출하는 Class [USA]
 *
 * @author jungin
 * @version 1.0, 2010/09/30
 */
public class A20EmergencyContactsRelationRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_RLSHP_F4";		// ESS

    /**
     * 비상연락망 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<A20EmergencyContactsData> getEmergencyContactList(String I_PERNR) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_GTYPE", "1");

            excute(mConnection, function);

            return getTable(A20EmergencyContactsData.class, function, "T_LIST");

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }




    
    public Vector getEmergencyContactDetail(String empNo) throws GeneralException {
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, "1");
            excute(mConnection, function);
            Vector ret = getOutput(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String build(String I_PERNR, String I_GTYPE, String I_DATLO, Vector a20EmergencyContactsData_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput2(function, I_PERNR, I_GTYPE, I_DATLO);
            
            setInput3(function, a20EmergencyContactsData_vt, "ITAB");

            excute(mConnection, function);
            return getField("E_MESSAG", function);
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
     * @param value java.lang.String 사번
     * @exception GeneralException
     */
    private void setInput(JCO.Function function, String value, String value1) throws GeneralException {
        String fieldName = "I_PERNR";
        setField(function, fieldName, value);
        String fieldName1 = "I_GTYPE";
        setField(function, fieldName1, value1);
    }
    
    private void setInput2(JCO.Function function, String value, String value1, String value2) throws GeneralException {
        String fieldName = "I_PERNR";
        setField(function, fieldName, value);
        String fieldName1 = "I_GTYPE";
        setField(function, fieldName1, value1);
        String fieldName2 = "I_DATLO";
        setField(function, fieldName2, value2);
    }

    private void setInput3(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A20EmergencyContactsData";
        String tableName  = "ITAB";
        return getTable(entityName, function, tableName);
    }
    
}

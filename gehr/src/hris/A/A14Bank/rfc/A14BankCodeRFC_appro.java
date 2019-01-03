package	hris.A.A14Bank.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;

import hris.common.approval.ApprovalSAPWrap;

/**
 * A14BankCodeRFC.java
 * 은행계좌 코드 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/07
 */
public class A14BankCodeRFC_appro extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_P_BANK_CODE";//ZHRH_RFC_P_BANK_CODE

    /**
     * 개인의 입학축하금 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getBankCode(String keycode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
            //excute(mConnection, function);
            excuteDetail(mConnection, function);
            
            Vector ret =null;
            if(!g.getSapType().isLocal()){
            	 ret = getOutput1(function);
            }else{
                 ret = getTable(hris.A.A14Bank.A14BankCodeData.class, function, "E_RESULT");//P_RESULT
            }
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    
    public Vector getBankValue(String keycode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
            //excute(mConnection, function);
            excuteDetail(mConnection, function);

            Vector ret = getOutput1(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * 입학축하금 입력 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     
    public void build(String keycode, String seqn, Object entrance) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            E21EntranceData data = (E21EntranceData)entrance;

            Vector entranceVector = new Vector();
            entranceVector.addElement(data);

            setInput(function, keycode, seqn, "2");

            setInput(function, entranceVector, "P_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 입학축하금 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     
    public void change(String keycode, String seqn, Object entrance) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            E21EntranceData data = (E21EntranceData)entrance;

            Vector entranceVector = new Vector();
            entranceVector.addElement(data);

            setInput(function, keycode, seqn, "3");

            setInput(function, entranceVector, "P_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * 입학축하금 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     
    public void delete(String keycode, String seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, seqn, "4");
            excute(mConnection, function);

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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;//P_PERNR
        setField(function, fieldName1, keycode);
    }

// Import Parameter 가 Vector(Table) 인 경우
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }
    */

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        return getTable(hris.A.A14Bank.A14BankCodeData.class, function, "T_ITAB");// Global:ITAB
    }
}
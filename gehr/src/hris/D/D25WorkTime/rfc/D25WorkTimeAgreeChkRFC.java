package hris.D.D25WorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.D.D25WorkTime.D25WorkTimeAgreeData;

/**
 * D25WorkTimeAgreeChkRFC.java
 * 실 근로시간 제도 동의 등록 조회 RFC
 * 2018-06-05  이지은    [CSR ID:3704184] 유연근로제 동의 관련 기능 추가 건 - Global HR Portal
 * @author 이지은
 * @version 1.0, 2018/06/05
 */
public class D25WorkTimeAgreeChkRFC extends SAPWrap {

	private static String functionName = "ZGHR_RFC_AGRE_MANAGE";

    /**
     * 실 근로시간 제도 동의 등록 조회 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector getAgreeFlag(String yyyy, String empNo) throws GeneralException {  

        JCO.Client mConnection = null;
        Vector ret = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, yyyy, empNo);   
            excute(mConnection, function);
            
             ret = getOutput(function,   new D25WorkTimeAgreeData() );
                   
            return ret;
            
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }   
    
    
    /**
     * 실 근로시간 제도 동의 등록 조회 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector setAgreeFlag(String empNo) throws GeneralException {  

        JCO.Client mConnection = null;
        Vector ret = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);   
            excute(mConnection, function);
            
             ret = getOutput(function,   new D25WorkTimeAgreeData() );
                   
            return ret;
            
        }catch(Exception ex){
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
    private void setInput(JCO.Function function, String value, String value1 ) throws GeneralException {  
        String fieldName  = "I_GUBUN";//01 : 조회 , 02 : 입력
        String fieldName1 = "I_YEAR"; 
        String fieldName2 = "I_PERNR"; 
        String fieldName3 = "I_AGRE_TYPE"; // 동의유형(01 : 2018 근로유형합의)
        setField(function, fieldName, "01");
        setField(function, fieldName1, value); 
        setField(function, fieldName2, value1); 
        setField(function, fieldName3, "01");
        
    }
    
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value ) throws GeneralException {  
        String fieldName  = "I_GUBUN";//01 : 조회 , 02 : 입력
        String fieldName1 = "I_PERNR"; 
        String fieldName2 = "I_AGRE_TYPE"; // 동의유형(01 : 2018 근로유형합의)
        String fieldName3 = "I_AGRE_FLAG"; // 동의 YN
        setField(function, fieldName, "02");
        setField(function, fieldName1, value); 
        setField(function, fieldName2, "01");
        setField(function, fieldName3, "Y");
        
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function, Object data) throws GeneralException {
    	
    	Vector ret = new Vector();
    	
    	Vector T_EXPORTA   = getTable(hris.D.D25WorkTime.D25WorkTimeAgreeData.class,  function, "T_AGRE_STAT");

    	ret.addElement(getReturn().MSGTY);
    	ret.addElement(getReturn().MSGTX);
    	ret.addElement(T_EXPORTA);
        
        return ret;
    } 
}

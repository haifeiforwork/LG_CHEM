package hris.D.D25WorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.D.D25WorkTime.D25WorkTimeAgreeData;

/**
 * D25WorkTimeEmpGubRFC.java
 * 사원의 구분(type) 조회 RFC 이며 아래 정보를 return 한다.
 * 2018-06-05  이지은    [CSR ID:3701161] 모바일 초과근무 신청/결재 로직 수정 요청 건
 * @author 이지은
 * @version 1.0, 2018/06/05
 */
public class D25WorkTimeEmpGubRFC extends SAPWrap {

	private static String functionName = "ZGHR_RFC_NTM_GET_EMPGUB";

    /**
     * 사무직의 구분을 조회하는 RFC를 호출하는 Method
     * E_EMPGUB : S(사무직) , H(현장직)
	 * E_TPGUB : A(사무직일반),B(현장직일반),C(사무직 선택근로),D(현장직 선택근로)
	 * E_WORK : X(평일), 공백(휴일)
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector getEmpGub(String empNo, String date) throws GeneralException {  

        JCO.Client mConnection = null;
        Vector ret = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, date);   
            excute(mConnection, function);
            
             ret = getOutput(function);
                   
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
        String fieldName  = "I_PERNR";
        String fieldName1 = "I_DATUM"; 
        
        setField(function, fieldName, value);
        setField(function, fieldName1, value1); 
        
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

    	ret.addElement(getReturn().MSGTY);
    	ret.addElement(getReturn().MSGTX);
    	ret.addElement(getField("E_EMPGUB", function));
    	ret.addElement(getField("E_TPGUB", function));
    	ret.addElement(getField("E_WORK", function));
        
        return ret;
    } 
}

package	hris.D.D05Mpay.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D05Mpay.*;

/**
 * D05HealthInsuranceRFC.java
 * 전년도 건강보험료 합계를 구하는 rfc (N100 석유화학 전용)
 *
 * @author  김도신
 * @version 1.0, 2003/04/22
 */
public class D05HealthInsuranceRFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_GET_HEALTH_INSURANCE";	
//    private String functionName = "ZGHR_RFC_GET_HEALTH_INSURANCE";	// E_SUM_BETRG 건강보험료합계가 없음

    /**
     * 전년도 건강보험료 합계를 조회함.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_SUM_BETRG( String i_pernr, String i_year ) throws GeneralException {
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, i_pernr, i_year);
            excute(mConnection, function);
            
            String E_SUM_BETRG = "";
                        
            E_SUM_BETRG = getOutput(function);  
                        
            return E_SUM_BETRG;
            
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
    private void setInput(JCO.Function function, String i_pernr, String i_year ) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName,  i_pernr);
        String fieldName1 = "I_YEAR";
        setField(function, fieldName1, i_year);
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        String fieldName = "E_SUM_BETRG";  
        return getField(fieldName, function);
    }
}
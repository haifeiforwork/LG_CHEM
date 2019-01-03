package hris.A.A10Annual.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.A.A10Annual.*;

/**
 * A10AnnualCheckRFC.java
 * 연봉계약여부 를 가져오는 RFC를 호출하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2002/01/10
 */
public class A10AnnualCheckRFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_CHECK_SAL_TYPE";

    /**
     * 연봉계약여부 를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String PERNR 사원번호
     * @param java.lang.String DATE 시스템날짜
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public String getAnnualCheck( String I_PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, I_PERNR );

            excute(mConnection, function);

            String ret = getOutput(function);

            return ret;
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
     * @param java.lang.String PERNR 사원번호
     * @param java.lang.String DATE 시스템날짜
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1 ) throws GeneralException{
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, key1);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String  getOutput(JCO.Function function) throws GeneralException {
        String fieldName = "E_TRFAR";
        return getField(fieldName, function);
    }
}

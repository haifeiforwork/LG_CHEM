package	hris.D.D03Vocation.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D03Vocation.*;

/**
 * D03WorkPeriodRFC.java
 * 개인 기간 작업 스케줄 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/24
 */
public class D03WorkPeriodRFC extends SAPWrap {

//    private String functionName = "ZHRP_RFC_GET_WORK_PERIOD";
    private String functionName = "ZGHR_RFC_GET_WORK_PERIOD";

    /**
     * 개인의 휴가신청 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getWorkPeriod(String keycode, String begda, String endda) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, begda, endda);
            
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
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode, String begda, String endda) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, keycode);
        
        String fieldName2 = "I_BEGDA"          ;
        setField(function, fieldName2, begda)  ;
        
        String fieldName3 = "I_ENDDA"          ;
        setField(function, fieldName3, endda)  ;
    }

// Import Parameter 가 Vector(Table) 인 경우
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D03Vocation.D03WorkPeriodData";
        String tableName  = "T_RESULT";
        return getTable(entityName, function, tableName);
    }
}
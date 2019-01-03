package	hris.E.E10Personal.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E10Personal.*;

/**
 * E10PentionMoneyRFC.java
 * 개인연금/마이라이프 지원액 조회하는 RFC를 호출하는 class
 *
 * @author 김도신
 * @version 1.0, 2002/10/10
 */
public class E10PentionMoneyRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_PENTION_MONEY";

    /**
     * 개인연금/마이라이프 신청,수정,조회 하는 RFC를 호출하는 Method
     * @param java.lang.String 결재일련번호 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPentionMoney( String i_bukrs, String i_date, String i_gubun ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_bukrs, i_date, i_gubun);
            
            excute(mConnection, function);
            
            Vector ret = getOutput(function);
            
            if( ret.size() > 0 ) {
                E10PentionMoneyData data = (E10PentionMoneyData)ret.get(0);
            
                data.DEDUCT   = Double.toString(Double.parseDouble(data.DEDUCT) * 100.0 );
                data.ASSIST   = Double.toString(Double.parseDouble(data.ASSIST) * 100.0 );
                data.DISCOUNT = Double.toString(Double.parseDouble(data.DISCOUNT) * 100.0 );
            }
     
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
     * @param value java.lang.String 결재일련번호 java.lang.String 작업구분 java.lang.String 가입 및 탈퇴여부 코드 
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String i_bukrs, String i_date, String i_gubun ) throws GeneralException {
        String fieldName1 = "I_BUKRS";
        setField(function, fieldName1, i_bukrs);
        
        String fieldName2 = "I_DATE" ;
        setField(function, fieldName2, i_date) ;
                
        String fieldName3 = "I_GUBUN";
        setField(function, fieldName3, i_gubun);
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
        String entityName = "hris.E.E10Personal.E10PentionMoneyData";
        String tableName  = "IT";
        return getTable(entityName, function, tableName);
    }
}



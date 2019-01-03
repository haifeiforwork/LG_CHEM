package hris.A.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.A.*;

/**
 * A10RaiseResultRFC.java
 * 육성정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 이지은
 * @version 1.0, 2016/01/27
 * @[CSR ID:2991671] g-mobile 내 인사정보 조회 기능 추가 개발 요청
 */
public class A10RaiseResultRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_CORE_TALENTED_PERSON2";

    /**
     * 육성정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String empNo
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRaise( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
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
     * @param empNo java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }


    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A10RaiseResultData";
        String tableName  = "T_ZHRS041T";
        return getTable(entityName, function, tableName);
    }
}



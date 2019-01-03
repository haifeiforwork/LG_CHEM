package hris.C.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C07Language.*;

/**
 * C08LanguageListRFC.java
 * 어학지원비 조회 RFC 를 호출하는 Class                        
 *
 * @author  김도신
 * @version 1.0, 2003/04/15
 */
public class C08LanguageListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_SUPP_LIST";

    /**
     * 경조금조회 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLangList( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                C07LanguageData data = (C07LanguageData)ret.get(i);
                
                data.SETL_WONX = Double.toString(Double.parseDouble(data.SETL_WONX) * 100.0 ) ;  // 결제금액
                data.CMPY_WONX = Double.toString(Double.parseDouble(data.CMPY_WONX) * 100.0 ) ;  // 회사지원금액
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
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "PERNR";
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
        String entityName = "hris.C.C07Language.C07LanguageData";
        String tableName = "RESULT";
        return getTable(entityName, function, tableName);
    }
}



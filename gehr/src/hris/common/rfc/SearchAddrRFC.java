package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.common.*;

/**
 * SearchAddrRFC.java
 * 주소 검색 List 를 가져오는 RFC를 호출하는 Class
 * @author 박영락   
 * @version 1.0, 2001/12/18
 */
public class SearchAddrRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_ZIPP_CODE";

    /**
     * 주소검색 List 를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 동면명
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAddrDetail( String zippcode ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, zippcode);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Logger.debug.println(this, ret.toString());
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value) throws GeneralException{
        String fieldName = "ZIPP_CODE";
        setField(function, fieldName, value);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.common.SearchAddrData";
        String tableName = "RESULT";
        return getTable(entityName, function, tableName);
    }
}


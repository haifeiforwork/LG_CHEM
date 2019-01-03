package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriPreChkRFC.java
 * 선수 자격 조건내용을 가져오는 RFC를 호출하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2002/01/16
 */
public class C02CurriPreChkRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_PRE_EVENT_CHECK";

    /**
     * 선수자격요건 내용를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원번호
     * @return java.util.Vector 선수자격요건
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCurriPreCheck( String PERNR , Vector PLAN ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, PERNR, PLAN );
            excute(mConnection, function);
            Vector ret = getOutput(function);
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
     * @param java.lang.String 사원번호
     * @param java.util.Vector 선수자격요건
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, Vector entityVector )  throws GeneralException{
        String fieldName = "PERNR";
        setField(function, fieldName, key1);
        setTable(function, "PRE_EVENT", entityVector);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C02Curri.C02CurriCheckData";
        return getTable(entityName, function, "PP_PLAN");
    }
}

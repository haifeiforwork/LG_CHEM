package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriPersonRFC.java
 * 개인정보를 조회하는 RFC를 호출하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2002/01/15
 */
public class C02CurriPersonRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_PERSON_INFORM";

    /**
     * 개인정보를 조회하는 RFC를 호출하는 Method
     * @param java.lang.Object hris.C.C02Curri.C02CurriInfoData Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCurriPerson( String PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, PERNR );
            excute(mConnection, function);
            return getOutput(function);

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
     * @param java.lang.String OBJID 오브젝트ID
     * @param java.lang.String SOBID 관련오브젝트ID
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1 ) throws GeneralException{
        String fieldName1 = "PERNR";
        setField(function, fieldName1, key1);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        
        String entityName1 = "hris.C.C02Curri.C02CurriPersonData";
        Vector ret = getTable(entityName1, function, "P_PERSON");
        return ret;
    }
}

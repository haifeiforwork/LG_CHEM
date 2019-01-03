package	hris.J.J03JobCreate.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

/**
 * J03JobBegdaRFC.java
 * Job의 최초 시작일을 조회하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/06/24
 */
public class J03JobBegdaRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_OBJECT_BEGDA";

    /**
     * Job의 최초 시작일을 조회하는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param  java.lang.String
     * @exception com.sns.jdf.GeneralException
     */ 
    public String getBegda(String i_otype, String i_objid) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_otype, i_objid);

            excute(mConnection, function);

            return getField("E_BEGDA", function);
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
    private void setInput(JCO.Function function, String i_otype, String i_objid) throws GeneralException {
        String fieldName1 = "I_OTYPE";
        setField(function, fieldName1, i_otype);

        String fieldName2 = "I_OBJID";
        setField(function, fieldName2, i_objid);
    }

}
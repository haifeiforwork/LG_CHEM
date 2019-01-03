package hris.E.E19Disaster.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Disaster.*;

/**
 * E19DisaRat2RFC.java
 * 재해위로금지급율 possible entry RFC 를 호출하는 Class
 *
 * @author 최 영호
 * @version 1.0, 2001/12/18
 */
public class E19DisaRat2RFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_R_DISASTER_RATE";
	 private String functionName = "ZGHR_RFC_R_DISASTER_RATE";

    /**
     * 재해위로금지급율 possible entry RFC 호출하는 Method
     * @param BUKRS java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDisaRat2( String PERNR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;


            setInput(function, PERNR);
            excute(mConnection, function);
            Vector ret = getTable(E19DisasterData.class, function, "T_RESULT");

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
     * @param BUKRS java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String PERNR) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, PERNR );
    }
}



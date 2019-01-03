package hris.E.E02Medicare.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E02Medicare.*;

/**
 * E02MedicareTargetNameRFC.java
 * 건강보험증 대상자 이름 possible entry를 갖어오는 RFC를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2002/02/28
 */
public class E02MedicareTargetNameRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_P_GET_TARGET_NAME";
	 private String functionName = "ZGHR_RFC_P_GET_TARGET_NAME";

    /**
     * 건강보험증 대상자 이름을 갖어오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getName( String PERNR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, PERNR );
            excute(mConnection, function);
            Vector ret = getTable(E02MedicareNameData.class, function, "T_RESULT");
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
    }
}
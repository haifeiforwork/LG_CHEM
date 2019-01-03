package hris.E.E11Personal.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E11Personal.*;

/**
 * E02MedicareTargetNameRFC.java
 * 개인연금 연금구분 이름 possible entry를 갖어오는 RFC를 호출하는 Class                        
 *
 * @author 박영락 
 * @version 1.0, 2002/02/01
 */
public class E11PersonalDivisionNameRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_P_PENTION_DIVIDE";

    /**
     * 개인연금 연금구분 이름을 갖어오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getName() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
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
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "IT";
        return getCodeVector( function, tableName, "PENT_TYPE", "PENT_TEXT");
    }
}
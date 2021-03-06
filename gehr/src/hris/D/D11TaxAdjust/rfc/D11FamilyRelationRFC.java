package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.A.A12Family.*;

/**
 * D11FamilyRelationRFC.java
 * 가족 관계 코드, 명을 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/02/04
 */
public class D11FamilyRelationRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_RELATION_PE";

    /**
     * 가족 관계 코드, 명을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFamilyRelation( String subty ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField( function, "I_SUBTY", subty ); 
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
        String tableName = "TAB";
        return getCodeVector(function, tableName);
    }
}
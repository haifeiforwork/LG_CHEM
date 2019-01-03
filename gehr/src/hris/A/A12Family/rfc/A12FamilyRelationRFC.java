package	hris.A.A12Family.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.A.A12Family.*;

/**
 * A12FamilyRelationRFC.java
 * 가족 관계 코드, 명을 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/02/04
 */
public class A12FamilyRelationRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_RELATION_PE";
    private String functionName = "ZGHR_RFC_RELATION_PE";


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
            Vector ret = getCodeVector(function, "T_TAB");//getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


}
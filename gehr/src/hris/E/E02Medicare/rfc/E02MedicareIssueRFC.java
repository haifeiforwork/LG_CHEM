package hris.E.E02Medicare.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E02Medicare.*;

/**
 * E02MedicareIssueRFC.java
 * 건강보험증 추가발급 possible entry를 갖어오는 RFC를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2002/02/28
 */
public class E02MedicareIssueRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_P_INSURANCE_ISSUE";
	 private String functionName = "ZGHR_RFC_P_INSURANCE_ISSUE";

    /**
     * 건강보험증 추가발급 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getIssue() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            Vector ret = getCodeVector( function, "T_RESULT", "APPL_TYPE", "APPL_TEXT");
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}
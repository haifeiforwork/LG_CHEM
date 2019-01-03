package hris.F.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.F.F76DeptEmergencyContactsDataUsa;

import java.util.Vector;
 
/**
 * F76DeptEmergencyContactsRFCUsa.java
 * 부서에 따른 전체 부서원의 비상연락망 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author jungin
 * @version 1.0 
 */

public class F76DeptEmergencyContactsRFCUsa extends SAPWrap {
 
    private String functionName = "ZGHR_RFC_GET_ORG_ECONTACT_INFO";

    /** 
     * 부서코드에 따른 전체 부서원의 비상연락망 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<F76DeptEmergencyContactsDataUsa> DeptEmergencyContacts(String I_ORGEH, String I_LOWERYN) throws GeneralException {
         
        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            excute(mConnection, function);

            return getTable(F76DeptEmergencyContactsDataUsa.class, function, "T_EXPORTA");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } 
    }
    

}

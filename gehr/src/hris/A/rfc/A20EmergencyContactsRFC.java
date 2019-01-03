package hris.A.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A20EmergencyContactsData;

import java.util.Vector;

/**
 * A20EmergencyContactsRFC.java
 * 비상연락망 정보를 가져오는 RFC를 호출하는 Class [USA]
 *
 * @author jungin
 * @version 1.0, 2010/09/30
 */
public class A20EmergencyContactsRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_EMG_CONTACTS";		// ESS

    /**
     * 비상연락망 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<A20EmergencyContactsData> getEmergencyContactList(String I_PERNR) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_GTYPE", "1");

            excute(mConnection, function);

            return getTable(A20EmergencyContactsData.class, function, "T_LIST");

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public RFCReturnEntity build(String I_PERNR, String I_GTYPE, String I_DATUM, Vector a20EmergencyContactsData_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_GTYPE", I_GTYPE);
            setField(function, "I_DATUM", I_DATUM);

            setTable(function, "T_LIST", a20EmergencyContactsData_vt);

            excute(mConnection, function);

            return getReturn();
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    } 
    
}

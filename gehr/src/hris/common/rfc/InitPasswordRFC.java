package hris.common.rfc;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * InitPasswordRFC.java
 * ����� ���� password�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��   
 * @version 1.0, 2014/07/17
 * Create       :  [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����                  
 */
public class InitPasswordRFC extends SAPWrap {

    private String functionName = "ZGHR_INIT_PASSWORD";

    /**
     * ������ URL�� �������� RFC�� ȣ���ϴ� Method
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity initPassword(String webUserId ) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ID" ,webUserId);

            excute(mConnection, function);

            return getReturn();
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    

}


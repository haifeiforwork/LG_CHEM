package hris.common.rfc;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * InitPasswordRFC.java
 * 사번에 대한 password를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일   
 * @version 1.0, 2014/07/17
 * Create       :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정                  
 */
public class InitPasswordRFC extends SAPWrap {

    private String functionName = "ZGHR_INIT_PASSWORD";

    /**
     * 사진의 URL를 가져오는 RFC를 호출하는 Method
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


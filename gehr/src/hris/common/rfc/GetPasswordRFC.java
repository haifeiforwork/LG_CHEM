package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.LoginResultData;

/**
 * GetPasswordRFC.java
 * 사번에 대한 password를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일   
 * @version 1.0, 2002/02/27
 * Update       :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정                  
 */
public class GetPasswordRFC extends SAPWrap {

    private String functionName = "ZGHR_GET_PASSWORD";

    /**
     *  [CSR ID:2574807] 사번, password를 전송 후 E_RETURN, E_MESSAGE, E_IP를 리턴받는다.
     */
    public LoginResultData getLoginYN(String I_ID, String I_PASSWORD) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ID", I_ID);
            setField(function, "I_PASSWORD", I_PASSWORD);

            excute(mConnection, function);

            LoginResultData resultData = getStructor(LoginResultData.class, function, "E_RETURN", null);
            resultData.E_IP = getField("E_IP", function);

            return resultData;
        } catch(Exception ex) {
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


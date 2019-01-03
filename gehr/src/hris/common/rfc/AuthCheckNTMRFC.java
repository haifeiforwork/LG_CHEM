package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * AuthCheckNTMRFC.java
 * [WorkTime52] 권한 체크 RFC
 *
 * @author 성환희
 * @version 1.0, 2018/05/31
 */
public class AuthCheckNTMRFC extends SAPWrap {
	
	private String functionName = "ZGHR_RFC_NTM_AUTH_CHECK_MENU";
	
	/**
     *  권한 체크 RFC를 호출하는 Method
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getAuth(String I_PERNR, String I_MENU) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_MENU", I_MENU);

            excute(mConnection, function);

            return getField("E_AUTH", function);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}

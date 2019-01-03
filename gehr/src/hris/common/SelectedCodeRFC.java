package hris.common;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * SelectedCodeRFC.java
 * Selected Code 정보를 가져오는 RFC를 호출하는 공통 Class
 *
 * @author jungin
 * @version 1.0, 2010/10/04
 */
public class SelectedCodeRFC extends SAPWrap {
	
    private String functionName = "ZGHR_RFC_GET_DOMAIN_F4";

    /**
     * Select Code 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */

    public Vector getSelectedCode(String I_DOMNAME) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_DOMNAME", I_DOMNAME);

            excute(mConnection, function);

            return getCodeVector(function, "T_RESULT", "CODE", "TEXT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    

}

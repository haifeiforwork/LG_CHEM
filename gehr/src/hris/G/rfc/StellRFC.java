/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 3. 8.
 *
 */
package hris.G.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * @author ÀÌ½ÂÈñ
 *
 */
public class StellRFC extends SAPWrap
{
    private String functionName = "ZGHR_RFC_GET_STELL_F4";
    
    public Vector getStellCodeEntity() throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
           
            excute(mConnection ,function);

            return getCodeVector(function, "T_RESULT", "STELL", "STLTX");

        } finally {
            close(mConnection);
        } // end try & catch
    }
}

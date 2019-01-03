/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 3. 3.
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
public class BizPlaceDataRFC extends SAPWrap
{
    private String functionName = "ZGHR_RFC_GET_BIZPLACE_JUSO";
    
    public Vector getBizPlacesCodeEntity(String I_PERNR, String I_UPMU_TYPE) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField(function ,"I_PERNR", I_PERNR);
            setField(function ,"I_UPMU_TYPE", I_UPMU_TYPE);
            excute(mConnection ,function);

            return getCodeVector(function, "T_RESULT", "JUSO_CODE", "JUSO_NAME");

        } finally {
            close(mConnection);
        } // end try & catch
    }
    
}
